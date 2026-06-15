# Jitsi Meeting Fix & Multi-Node Onboarding — Runbook

## 1. Jitsi Video Conference Fix

### 1.1 Problem

Clicking "Join Now" on a live mentor session opened the meeting page but Jitsi failed to load. Browser console showed:

```
GET https://103.115.236.34/external_api.js net::ERR_CERT_COMMON_NAME_INVALID
```

And after switching to the domain path:
```
GET https://ksrceailab.com/libs/lib-jitsi-meet.min.js 404
GET https://ksrceailab.com/css/all.css 404
Uncaught ReferenceError: JitsiMeetJS is not defined
```

### 1.2 Root Cause

Two problems:

**Problem A — SSL Cert Mismatch (first error):**
- `JITSI_BASE_URL` was set to `https://103.115.236.34` (raw IP)
- Let's Encrypt cert is issued for `ksrceailab.com` (domain), not for the IP
- Browser blocked the script load

**Problem B — Subpath Proxy Asset Resolution (after switching to domain):**
- `JITSI_BASE_URL` changed to `https://ksrceailab.com/jitsi` (valid cert ✓)
- `/jitsi/external_api.js` loaded correctly via Nginx proxy to Jitsi port 8000 ✓
- But Jitsi's own HTML page (loaded inside the iframe) references assets at root paths:
  - `/libs/lib-jitsi-meet.min.js`
  - `/css/all.css`
  - `/static/`, `/lang/`, `/sounds/`, `/fonts/`
- These requests hit Nginx `location /` → Next.js catch-all → **404**

### 1.3 Fix — Nginx Static Asset Proxying

Added explicit `location` blocks in Nginx to proxy Jitsi's static asset paths directly to Jitsi container (port 8000), placed **before** the Next.js catch-all `location /`:

```nginx
# --- Backend API (existing — no change) ---
location /api/ {
    proxy_pass http://localhost:3010;
    ...
}

# --- Jitsi Meet (with sub_filter for base href) ---
location /jitsi/ {
    sub_filter '</head>' '<base href="/jitsi/"></head>';
    sub_filter_once on;
    sub_filter_types text/html;
    proxy_pass http://127.0.0.1:8000/;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}

# Jitsi static assets (NEW — proxy directly to Jitsi before Next.js catch-all)
location /libs/ { proxy_pass http://127.0.0.1:8000; proxy_set_header Host $host; }
location /css/ { proxy_pass http://127.0.0.1:8000; proxy_set_header Host $host; }
location /static/ { proxy_pass http://127.0.0.1:8000; proxy_set_header Host $host; }
location /lang/ { proxy_pass http://127.0.0.1:8000; proxy_set_header Host $host; }
location /sounds/ { proxy_pass http://127.0.0.1:8000; proxy_set_header Host $host; }
location /fonts/ { proxy_pass http://127.0.0.1:8000; proxy_set_header Host $host; }
location /config.js { proxy_pass http://127.0.0.1:8000; proxy_set_header Host $host; }
location /interface_config.js { proxy_pass http://127.0.0.1:8000; proxy_set_header Host $host; }

# --- Next.js Frontend (existing — unchanged) ---
location / {
    proxy_pass http://localhost:3011;
    ...
}
```

> **Important:** `/libs/`, `/css/`, `/static/` etc. must come **before** `location /` (Next.js catch-all) — Nginx processes location blocks in prefix-match order and stops at the first match.

### 1.4 Environment Variable Changes

**Backend `.env`** (`/opt/LaaS/backend/.env`):

| Variable | Old Value | New Value |
|---|---|---|
| `JITSI_BASE_URL` | `https://103.115.236.34` | `https://ksrceailab.com/jitsi` |
| `JITSI_APP_ID` | `laas-platform` | *(unchanged)* |
| `JITSI_APP_SECRET` | `73220008326e77404e263675a66d424f7b78d129c660435a4a8cf3e5a6bb0013` | *(unchanged)* |

**Jitsi `.env** (`~/jitsi-meet/docker-jitsi-meet-stable-10978/.env`):

| Variable | Old Value | New Value |
|---|---|---|
| `PUBLIC_URL` | `https://103.115.236.34` | `https://ksrceailab.com/jitsi` |
| `JVB_ADVERTISE_IPS` | `103.115.236.34` | *(unchanged — keep public IP for WebRTC)* |
| `DOCKER_HOST_ADDRESS` | `20.1.1.130` | *(unchanged)* |
| `AUTH_TYPE` | `jwt` | *(unchanged)* |
| `JWT_APP_ID` | `laas-platform` | *(unchanged)* |
| `JWT_APP_SECRET` | *(same as backend)* | *(unchanged)* |

### 1.5 Verification

```bash
# Test base href injection
curl -s https://ksrceailab.com/jitsi/ | grep -o '<base href="/jitsi/">'

# Test static asset proxying
curl -s https://ksrceailab.com/libs/lib-jitsi-meet.min.js | head -5

# Test external_api.js loading
curl -s https://ksrceailab.com/jitsi/external_api.js | head -5
```

---

## 2. Multi-Node Fleet Onboarding

### 2.1 Adding ai3 & ai4 to Production Database

**Database:** `laas` on `ai1` (PostgreSQL, `postgres` user)

**SQL to insert ai3:**
```sql
INSERT INTO nodes (id, hostname, display_name, ip_management, ip_compute, ip_storage, cpu_model, total_vcpu, total_memory_mb, total_gpu_vram_mb, gpu_model, nvme_total_gb, allocated_vcpu, allocated_memory_mb, allocated_gpu_vram_mb, max_concurrent_sessions, status, metadata, current_session_count, session_orchestration_port, storage_provision_port, nvme_of_port, storage_headroom_gb, created_at, updated_at)
VALUES (gen_random_uuid(), 'aiserver3', 'AI Server 3 — Prod (RTX 5090)', '20.1.1.134', '103.115.236.36', '10.10.100.134', 'AMD Ryzen 9 7950X', 16, 65536, 32768, 'RTX 5090', 2000, 0, 0, 0, 12, 'healthy', '{"smTotal": 170, "cudaArch": "sm_100", "reservedVcpu": 2, "driverVersion": "570.x", "allocatableVcpu": 32, "reservedMemoryMb": 10240, "reservedGpuVramMb": 1024, "allocatableMemoryMb": 55296, "allocatableGpuVramMb": 31744}'::jsonb, 0, 9998, 9999, 4420, 15, NOW(), NOW());
```

**SQL to insert ai4:**
```sql
INSERT INTO nodes (id, hostname, display_name, ip_management, ip_compute, ip_storage, cpu_model, total_vcpu, total_memory_mb, total_gpu_vram_mb, gpu_model, nvme_total_gb, allocated_vcpu, allocated_memory_mb, allocated_gpu_vram_mb, max_concurrent_sessions, status, metadata, current_session_count, session_orchestration_port, storage_provision_port, nvme_of_port, storage_headroom_gb, created_at, updated_at)
VALUES (gen_random_uuid(), 'aiserver4', 'AI Server 4 — Prod (RTX 5090)', '20.1.1.136', '103.115.236.37', '10.10.100.136', 'AMD Ryzen 9 7950X', 16, 65536, 32768, 'RTX 5090', 2000, 0, 0, 0, 12, 'healthy', '{"smTotal": 170, "cudaArch": "sm_100", "reservedVcpu": 2, "driverVersion": "570.x", "allocatableVcpu": 32, "reservedMemoryMb": 10240, "reservedGpuVramMb": 1024, "allocatableMemoryMb": 55296, "allocatableGpuVramMb": 31744}'::jsonb, 0, 9998, 9999, 4420, 15, NOW(), NOW());
```

### 2.2 NFS Export Updates (Missing ai4)

After adding ai4, all existing nodes' `NFS_EXPORT_CLIENT` lists needed updating to include ai4's 10GbE IP (`10.10.100.136`).

**Updated launch commands:**

**ai1:**
```
PROVISION_SECRET=e75064ca1702889e4f519d4ad40dfbd5f18dbdb67db7f365 ENABLE_NFS_AUTOMOUNT=true STORAGE_IP=10.10.100.130 FLASK_HOST=0.0.0.0 FLASK_PORT=9999 NFS_EXPORT_CLIENT="10.10.100.132(rw,sync,no_subtree_check,no_root_squash) 10.10.100.134(rw,sync,no_subtree_check,no_root_squash) 10.10.100.136(rw,sync,no_subtree_check,no_root_squash) 127.0.0.1" python3 app.py
```

**ai2:**
```
PROVISION_SECRET=e75064ca1702889e4f519d4ad40dfbd5f18dbdb67db7f365 ENABLE_NFS_AUTOMOUNT=true STORAGE_IP=10.10.100.132 FLASK_HOST=0.0.0.0 FLASK_PORT=9999 NFS_EXPORT_CLIENT="10.10.100.130(rw,sync,no_subtree_check,no_root_squash) 10.10.100.134(rw,sync,no_subtree_check,no_root_squash) 10.10.100.136(rw,sync,no_subtree_check,no_root_squash) 127.0.0.1" python3 app.py
```

**ai3:**
```
PROVISION_SECRET=e75064ca1702889e4f519d4ad40dfbd5f18dbdb67db7f365 ENABLE_NFS_AUTOMOUNT=true STORAGE_IP=10.10.100.134 FLASK_HOST=0.0.0.0 FLASK_PORT=9999 NFS_EXPORT_CLIENT="10.10.100.130(rw,sync,no_subtree_check,no_root_squash) 10.10.100.132(rw,sync,no_subtree_check,no_root_squash) 10.10.100.136(rw,sync,no_subtree_check,no_root_squash) 127.0.0.1" python3 app.py
```

**ai4:**
```
PROVISION_SECRET=e75064ca1702889e4f519d4ad40dfbd5f18dbdb67db7f365 ENABLE_NFS_AUTOMOUNT=true STORAGE_IP=10.10.100.136 FLASK_HOST=0.0.0.0 FLASK_PORT=9999 NFS_EXPORT_CLIENT="10.10.100.130(rw,sync,no_subtree_check,no_root_squash) 10.10.100.132(rw,sync,no_subtree_check,no_root_squash) 10.10.100.134(rw,sync,no_subtree_check,no_root_squash) 127.0.0.1" python3 ~/storage-provision/app.py
```

### 2.3 Ephemeral ZFS Dataset on ai4

**Problem:** Session launches on ai4 failed with:
```
zfs create failed: cannot create 'datapool/ephemeral/sess_...': parent does not exist
```

**Fix:**
```bash
sudo zfs create datapool/ephemeral
```

Also verify on ai3:
```bash
ssh 10.10.100.134 'sudo zfs list'
```

---

## 3. Database Backup Procedure

```bash
# Dump to /tmp (postgres user can write here)
sudo -u postgres pg_dump -d laas -F c -f /tmp/laas_prod_backup_$(date +%Y%m%d_%H%M%S).dump

# Move to backups directory
sudo mv /tmp/laas_prod_backup_*.dump /opt/backups/
```

---

## 4. Mentor Session Management (Stale Live Sessions)

**Query active live sessions:**
```sql
SELECT ms.id, ms.status, ms.payment_status, ms.duration_minutes, ms.earnings_cents,
       ms.started_at, mu.display_name as mentor_name, u.email as student_email
FROM mentor_sessions ms
JOIN mentor_profiles mp ON mp.id = ms.mentor_profile_id
JOIN users mu ON mu.id = mp.user_id
JOIN users u ON u.id = ms.student_user_id
WHERE ms.status = 'live'
ORDER BY ms.started_at DESC;
```

**Complete a live session (replace `<session_id>`):**
```sql
-- Mark session as completed
UPDATE mentor_sessions
SET status = 'completed', ended_at = NOW(), updated_at = NOW()
WHERE id = '<session_id>';

-- Release held payment
UPDATE mentor_session_payments
SET status = 'released', released_at = NOW()
WHERE mentor_session_id = '<session_id>';

-- Insert audit history
INSERT INTO mentor_session_status_history (id, mentor_session_id, from_status, to_status, changed_by, reason, timestamp)
VALUES (gen_random_uuid(), '<session_id>', 'live', 'completed', 'admin', 'Admin completed stale live session', NOW());
```

---

## 5. Final Fleet Layout

| Hostname | Public IP | Internal IP (enp10s0) | Storage IP (enp11s0) | GPU | Status |
|---|---|---|---|---|---|
| `aiserver1` | `103.115.236.34:2223` | `20.1.1.130` | `10.10.100.130` | RTX 5090 32GB | healthy |
| `aiserver2` | `103.115.236.35:2224` | `20.1.1.132` | `10.10.100.132` | RTX 5090 32GB | healthy |
| `aiserver3` | `103.115.236.36:2225` | `20.1.1.134` | `10.10.100.134` | RTX 5090 32GB | healthy |
| `aiserver4` | `103.115.236.37:2226` | `20.1.1.136` | `10.10.100.136` | RTX 5090 32GB | healthy |
