# NVENC Session Exhaustion — Diagnosis & Resolution Guide

**Date:** 26 June 2026  
**Affected Node:** ai4 (aiserver4 — 103.115.236.37)  
**Severity:** Critical — all new WebRTC desktop sessions fail to connect  
**Status:** Resolved

---

## 1. Problem Summary

Users on ai4 were unable to connect to their Blaze desktop sessions. The browser displayed a persistent **"Connection error, retry in 3 seconds"** loop, while the same sessions worked fine on ai3 and ai5.

---

## 2. Symptoms

| Symptom | Detail |
|---------|--------|
| Browser UI | Black screen with "Connection error, retry in 3 seconds" |
| selkies-gstreamer | Exits with status 0 every ~20 seconds, restarted by supervisord |
| coturn TURN server | ALLOCATE succeeds, but `peer usage: rp=0, rb=0, sp=0, sb=0` — zero relay data flows |
| coturn sessions | Close with `reason: allocation timeout` |
| Container web UI | Responds on port 9080 (HTML loads fine) |
| X11 display | Working correctly (DISPLAY=:27, Xvfb running) |
| CUDA_NVRTC_ARCH | Correctly set to 120 (Blackwell) |
| Other nodes (ai3, ai5) | Identical containers work perfectly |

---

## 3. Root Cause

### NVENC Encoder Session Exhaustion

The NVIDIA hardware video encoder (NVENC) on the RTX 5090 has a **hard concurrent session limit**. On ai4, stale/orphaned NVENC sessions accumulated over time, exhausting this limit.

**Evidence:**

```bash
# ai4 — NVENC sessions exhausted
$ nvidia-smi --query-gpu=encoder.stats.sessionCount --format=csv
encoder.stats.sessionCount
12                          # ← AT LIMIT

# ai5 — same number of containers, working fine
$ nvidia-smi --query-gpu=encoder.stats.sessionCount --format=csv
encoder.stats.sessionCount
4                           # ← WITHIN LIMIT
```

### GStreamer Error Log

Inside the container, selkies-gstreamer logged:

```
ERROR nvenc: NvEncOpenEncodeSessionEx failed: codec h264, device 0, error code 21
ERROR nvenc: NvEncOpenEncodeSessionEx failed: codec h265, device 0, error code 21
```

**Error code 21** = `NV_ENC_ERR_OUT_OF_MEMORY` — the NVENC hardware has no free encoder sessions available.

### How Sessions Accumulated

selkies-gstreamer was crash-looping (exiting every ~20 seconds with status 0). Each restart created a new NVENC encoder session, but the crashed process never released its previous session. Over 11+ hours of crash-looping:

```
10 containers × ~20s restart cycle × 11 hours = hundreds of NVENC session allocations
```

Most were orphaned (not cleaned up), eventually hitting the hardware limit of ~12 concurrent sessions.

### Why Other Nodes Were Unaffected

ai5 had only 4 active NVENC sessions because its containers were stable (not crash-looping). The encoder sessions were properly allocated and released.

---

## 4. Diagnostic Process

### Step 1: Verify coturn is healthy

```bash
sudo journalctl -u coturn -f
# ✅ ALLOCATE processed, success
# ❌ But peer usage always 0 — relay data never flows
```

**Conclusion:** coturn is working, but the container never sends media data back.

### Step 2: Check container internals

```bash
docker exec <container> cat /tmp/selkies-gstreamer-entrypoint.log 2>/dev/null | tail -80
```

**Finding:** NVENC encoder initialization fails with error code 21.

### Step 3: Check NVENC session count on host

```bash
nvidia-smi --query-gpu=encoder.stats.sessionCount,encoder.stats.averageFps,encoder.stats.averageLatency --format=csv
```

**Finding:** ai4 shows 12 sessions at 0 fps (all stale), ai5 shows 4 sessions at 14 fps (active).

### Step 4: Compare node configurations

```bash
# Both nodes identical:
# - Driver: 595.71.05
# - CUDA: 13.2
# - GPU: RTX 5090 (Blackwell)
# - Container count: 10
# - CUDA_NVRTC_ARCH: 120
```

**Only difference:** NVENC session count — confirming exhaustion as the root cause.

---

## 5. Resolution

### Immediate Fix

```bash
# Restart Docker to clear all orphaned NVENC sessions
sudo systemctl restart docker

# Verify clean state
nvidia-smi --query-gpu=encoder.stats.sessionCount --format=csv
# Expected: 0
```

> **Warning:** This disconnects all active users on the node. Sessions must be restarted.

### Post-Fix Verification

1. Launch a new Blaze session on the node
2. Verify browser connects successfully (no "Connection error")
3. Monitor NVENC count:
   ```bash
   watch -n 5 'nvidia-smi --query-gpu=encoder.stats.sessionCount --format=csv'
   ```
4. Confirm session count stays proportional to active containers

---

## 6. Prevention

### 6.1 Session Orchestration — NVENC Tracking

The session orchestration service (`host-services/session-orchestration/app.py`) should track NVENC session usage per node, similar to CPU cores and VRAM:

```python
# Query NVENC sessions before scheduling
def get_nvenc_session_count(node_ip):
    """Query NVENC session count on a node via SSH or orchestration API."""
    result = subprocess.run(
        ["ssh", node_ip, "nvidia-smi",
         "--query-gpu=encoder.stats.sessionCount",
         "--format=csv,noheader,nounits"],
        capture_output=True, text=True, timeout=5
    )
    return int(result.stdout.strip()) if result.returncode == 0 else -1

# Define max NVENC sessions per node (RTX 5090 consumer limit)
MAX_NVENC_SESSIONS = 8  # Conservative; verify actual limit per GPU

# Before scheduling a session on a node:
if get_nvenc_session_count(target_node_ip) >= MAX_NVENC_SESSIONS:
    # Route to a different node
    target_node = find_node_with_nvenc_capacity()
```

### 6.2 Supervisord — Limit Restart Frequency

Prevent crash-looping from accumulating stale NVENC sessions:

```ini
[program:selkies-gstreamer]
autorestart=true
startretries=3          ; Stop after 3 failed attempts (instead of infinite)
startsecs=10            ; Must run 10s to count as successful
exitcodes=0             ; Only restart on clean exit
```

### 6.3 Periodic NVENC Cleanup Cron

```bash
# /etc/cron.d/nvenc-cleanup — runs every hour
0 * * * * root /usr/local/bin/check-nvenc-sessions.sh
```

```bash
#!/bin/bash
# /usr/local/bin/check-nvenc-sessions.sh
COUNT=$(nvidia-smi --query-gpu=encoder.stats.sessionCount --format=csv,noheader,nounits)
ACTIVE_CONTAINERS=$(docker ps --filter "name=laas-" -q | wc -l)

if [ "$COUNT" -gt "$((ACTIVE_CONTAINERS * 2))" ]; then
    logger -t nvenc "WARNING: NVENC sessions ($COUNT) >> containers ($ACTIVE_CONTAINERS). Restarting Docker."
    systemctl restart docker
fi
```

### 6.4 Node Health Endpoint

Add an NVENC health check to the orchestration API:

```python
@app.get("/health/nvenc")
def nvenc_health():
    count = int(subprocess.check_output(
        ["nvidia-smi", "--query-gpu=encoder.stats.sessionCount",
         "--format=csv,noheader,nounits"]
    ).strip())
    return {"nvenc_sessions": count, "max": MAX_NVENC_SESSIONS, "available": MAX_NVENC_SESSIONS - count}
```

---

## 7. Key Learnings

1. **NVENC is a finite hardware resource** — Consumer GPUs (GeForce RTX) have lower NVENC session limits than professional GPUs (Quadro/Tesla). RTX 5090 appears to support ~8-12 concurrent sessions.

2. **Crash loops leak hardware resources** — When selkies-gstreamer crashes, the NVENC session isn't always released by the driver. Rapid restart cycles can exhaust the limit quickly.

3. **NVENC failures look like WebRTC failures** — The browser shows "Connection error" because the encoder never starts, so no video stream is produced. This is easily misdiagnosed as a network/TURN issue.

4. **`nvidia-smi encoder.stats` is the key diagnostic** — Always check this when WebRTC connections fail but coturn/TURN appears healthy.

5. **Docker restart clears orphaned sessions** — The NVIDIA driver releases all NVENC sessions when the Docker daemon (and all GPU processes within it) is restarted.

6. **Node-level resource tracking is essential** — CPU cores, VRAM, and NVENC sessions all need to be tracked by the orchestration layer to prevent over-scheduling.

---

## 8. Quick Reference

| Command | Purpose |
|---------|---------|
| `nvidia-smi --query-gpu=encoder.stats.sessionCount --format=csv` | Check NVENC session count |
| `nvidia-smi --query-gpu=encoder.stats.sessionCount,encoder.stats.averageFps --format=csv` | Check sessions + activity |
| `docker exec <c> cat /tmp/selkies-gstreamer-entrypoint.log \| grep -i nvenc` | Check encoder errors in container |
| `sudo systemctl restart docker` | Clear all orphaned NVENC sessions |
| `watch -n 5 'nvidia-smi --query-gpu=encoder.stats.sessionCount --format=csv'` | Monitor NVENC in real-time |
