# Incident Report: Ubuntu Repository Access Blocked by Sophos/Cyberoam Web Category Filter

**Report Date:** May 2, 2026  
**Reported By:** Punith, LaaS Platform Deployment  
**Severity:** High — All server setup and deployment halted  
**Status:** Awaiting IT Admin Action  

---

## 1. Executive Summary

Ubuntu `apt` package manager operations (install, update, upgrade) are failing on all KSRCE AI lab servers. The gateway firewall — a Sophos/Cyberoam UTM appliance at `20.1.1.1:8090` — is blocking access to Ubuntu software repositories via web category filtering (Category 68).

This blockage is preventing all further server setup and deployment work on the LaaS GPU compute platform, including NVIDIA driver installation, Docker setup, and security updates.

**Request:** Review the Sophos web filter policy and whitelist the domains required for Ubuntu package management, NVIDIA software, and Docker installation.

---

## 2. Affected Systems

| Machine | LAN IP | SSH Access | GPU |
|---|---|---|---|
| ai1 (aiserver1) | 20.1.1.130 | `ai1@103.115.236.52 -p 2223` | RTX 5090 32GB |
| ai2 (aiserver2) | 20.1.1.132 | `ai2@103.115.236.52 -p 2224` | RTX 5090 32GB |
| ai4 | 20.1.1.x | Similar SSH | RTX 5090 32GB |

All machines are on the `20.1.1.x/16` subnet with default gateway `20.1.1.1`.

---

## 3. Issue Description

### Symptom

All `apt` operations return **HTTP 403 Forbidden** or **HTTPS 307 Redirect** to a block page.

### Root Cause

The Sophos/Cyberoam UTM appliance at gateway `20.1.1.1` is applying web category filtering (**Category 68**) that blocks access to Ubuntu package repositories.

### Mechanism

| Request Type | Behavior |
|---|---|
| HTTP requests to repos | **403 Forbidden** (from IP `20.1.1.1:8090`) |
| HTTPS requests to repos | **307 Redirect** to `https://20.1.1.1:8090/ips/block/webcat?cat=68&url=<base64-encoded-url>` |
| SSL deep inspection | Re-signs certificates with `CN=Sophos SSL CA` |
| Non-repository traffic | Works normally (e.g., `google.com` returns 200) |

The base64-encoded URL `aHR0cHM6Ly9hcmNoaXZlLnVidW50dS5jb20~` in the block page decodes to `https://archive.ubuntu.com`, confirming the target.

---

## 4. Evidence — What is NOT the Cause (Ruled Out)

### Section A: Local Server Configuration is Clean

The following checks confirm the issue is not caused by server-side misconfiguration:

- **No proxy environment variables** set (`HTTP_PROXY`, `HTTPS_PROXY`, `http_proxy`, `https_proxy`, `no_proxy` — all unset)
- **No apt proxy configuration files** (`/etc/apt/apt.conf.d/` contains no proxy directives)
- **DNS resolution works correctly** — `archive.ubuntu.com` resolves to `91.189.91.x` as expected
- **No iptables/nftables NAT rules** on any server
- **Standard Ubuntu 22.04 `sources.list`** with default HTTPS URLs — no non-standard repository entries
- **Only non-standard apt config:** `99ignore-ssl` with `Acquire::https::Verify-Peer "false"` — this is a troubleshooting workaround added after the block was discovered, not a cause

---

## 5. Evidence — Confirmed Firewall Block

### Section B: Proxy Interception Confirmed

| Test Command | Result | Interpretation |
|---|---|---|
| `curl -v http://archive.ubuntu.com/ubuntu/` | **403 Forbidden** | HTTP traffic to repos blocked |
| `curl -vL https://archive.ubuntu.com/ubuntu/` | **307 Redirect** to `https://20.1.1.1:8090/ips/block/webcat?cat=68&url=...` | HTTPS traffic intercepted and blocked by web category filter |
| `curl -v https://www.google.com` | **301** (works normally) | Internet is available — only repositories are blocked |
| `openssl s_client -connect archive.ubuntu.com:443` | Connection terminated by proxy | SSL inspection intercepts and drops the connection |

### Section D: Gateway Identification

| Test Command | Result | Interpretation |
|---|---|---|
| `ip route show` | `default via 20.1.1.1` | Confirms gateway address |
| `curl http://20.1.1.1:8090/` | Returns Sophos/Cyberoam portal HTML (contains `cyberoamAjax.js`) | Confirms the appliance identity and management portal |

---

## 6. Timeline (IST — Indian Standard Time)

| Date & Time (IST) | Event | Machine | Evidence |
|---|---|---|---|
| Before Apr 29, 2026 | ai2 fully set up via apt (OS, kernel, openssh, apache2, etc.) — all apt operations worked | ai2 | `history.log.1.gz` |
| Apr 29, ~1:31 PM | grub-efi, kernel, openssh-server installed via apt | ai2 | `history.log.1.gz` |
| Apr 29, ~1:33 PM | unattended-upgrades ran successfully (large system update) | ai2 | `history.log.1.gz` |
| Apr 29, ~1:51 PM | apache2 installed via apt | ai2 | `history.log.1.gz` |
| Apr 29, ~2:18 PM | iperf3 installed via apt — **LAST SUCCESSFUL apt on ai2** | ai2 | `history.log.1.gz` |
| Apr 30, ~3:56 PM | nvidia-driver-570 installed via apt (1st attempt) | ai1 | `history.log.1.gz` |
| Apr 30, ~4:47–5:50 PM | Multiple nvidia purge/reinstall cycles (troubleshooting driver issues) — all apt operations succeeded | ai1 | `history.log.1.gz` |
| Apr 30, ~5:52 PM | nvidia-driver-570-open installed via apt — **LAST SUCCESSFUL apt on ai1** | ai1 | `history.log.1.gz` |
| Apr 30 evening – May 1 | IT admin physically visited to change BIOS settings (disable Secure Boot, enable IOMMU) on servers | All | User confirmation |
| **Between Apr 30 evening – May 2** | **Sophos web category filter applied on gateway — exact time unknown** | Gateway | Inferred from timeline |
| May 2 | All apt operations blocked on ai1, ai2, and ai4 | All | Direct observation |
| May 2, ~10:20 PM | nvidia packages purged on ai1 (cleanup attempt) — no new packages could be installed | ai1 | `history.log` |

---

## 7. Impact Assessment

### Immediate

Cannot install or update any software packages on any server. Specifically blocked:

- NVIDIA driver reinstallation (ai1 needs `nvidia-driver-570-open`)
- CUDA Toolkit installation
- Docker Engine installation
- NVIDIA Container Toolkit installation
- All subsequent LaaS platform setup

### Security

Servers cannot receive security updates via `unattended-upgrades`, leaving them exposed to known vulnerabilities.

### Project

**Complete halt of LaaS GPU compute platform deployment at KSRCE.** No further progress can be made until repository access is restored.

---

## 8. Required Action

Request the IT admin to whitelist the following domains in the Sophos/Cyberoam web filter policy:

### Ubuntu Package Repositories (Essential)

| Domain | Purpose |
|---|---|
| `archive.ubuntu.com` (and `*.archive.ubuntu.com`) | Main Ubuntu package repository |
| `security.ubuntu.com` | Ubuntu security updates |
| `ppa.launchpad.net` (and `ppa.launchpadcontent.net`) | Personal Package Archives |
| `keyserver.ubuntu.com` | GPG key distribution for package signing |

### NVIDIA Software (Required for GPU Setup)

| Domain | Purpose |
|---|---|
| `developer.download.nvidia.com` | NVIDIA driver and CUDA downloads |
| `developer.nvidia.com` | NVIDIA developer portal |

### Docker (Required for Container Platform)

| Domain | Purpose |
|---|---|
| `download.docker.com` | Docker Engine and CLI packages |

### General Development

| Domain | Purpose |
|---|---|
| `github.com` / `*.github.com` | Source code and releases |
| `*.githubusercontent.com` | Raw content and assets |

### Alternative Approach

If domain-level whitelisting is not feasible, consider:
- Whitelisting by destination IP address
- Creating a policy exception for source IPs `20.1.1.130` and `20.1.1.132` (the AI lab servers)
- Placing the AI lab servers in a separate firewall zone with relaxed web filtering

---

## 9. How to Verify the Fix

After the web filter policy has been updated, run the following on any affected server:

```bash
sudo apt update
sudo apt list --upgradable
```

If both commands complete without **403 Forbidden** errors, the fix is confirmed.

Additional verification:

```bash
# Test direct repository access
curl -v http://archive.ubuntu.com/ubuntu/
# Should return 200 or 301 — not 403

curl -vL https://archive.ubuntu.com/ubuntu/
# Should return 200 — not 307 redirect to block page

# Test that SSL inspection is no longer blocking
openssl s_client -connect archive.ubuntu.com:443
# Should complete TLS handshake successfully
```

---

*This report is intended for the KSRCE IT administrator to facilitate a prompt resolution. Please contact the LaaS deployment team if any clarification is needed.*
