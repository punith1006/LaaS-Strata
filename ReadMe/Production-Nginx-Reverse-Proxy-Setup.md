# LaaS Production Deployment — Nginx Reverse Proxy Setup

**Date:** April 30, 2026
**Platform:** LaaS (Lab-as-a-Service)
**Public IP:** 103.115.236.52
**Nodes:** ai1 (20.1.1.130), ai2 (20.1.1.132)

---

## Table of Contents

1. [Architecture Overview](#1-architecture-overview)
2. [Port Forwarding Requirements](#2-port-forwarding-requirements)
3. [Nginx Configuration](#3-nginx-configuration)
4. [SSL Certificate Setup](#4-ssl-certificate-setup)
5. [CoTURN Configuration](#5-coturn-configuration)
6. [Session Orchestration Changes](#6-session-orchestration-changes)
7. [Storage Provision Configuration](#7-storage-provision-configuration)
8. [Backend .env Configuration](#8-backend-env-configuration)
9. [Keycloak Reverse Proxy Setup](#9-keycloak-reverse-proxy-setup)
10. [iptables & UFW Firewall Rules](#10-iptables--ufw-firewall-rules)
11. [ai2 Compute Node Setup](#11-ai2-compute-node-setup)
12. [Step-by-Step Deployment Checklist](#12-step-by-step-deployment-checklist)
13. [Verification & Testing Commands](#13-verification--testing-commands)
14. [Troubleshooting](#14-troubleshooting)

---

## 1. Architecture Overview

### Edge Gateway Architecture

All external traffic enters through a single public IP and is routed by nginx on ai1:

```
                        ┌─────────────────────────────────────────────────────┐
  External Users        │             103.115.236.52 (Public IP / NAT)       │
  (Internet)            │                                                     │
       │                │    Port 443  ──► ai1 nginx (HTTPS)                 │
       │                │    Port 80   ──► ai1 nginx (HTTP → 301 HTTPS)      │
       │                │    Port 3478 ──► ai1 CoTURN (TURN relay)           │
       │                │    Port 49152-49252 ──► ai1 CoTURN (relay range)   │
       │                │    Port 2223 ──► ai1 SSH                           │
       │                │    Port 2224 ──► ai2 SSH                           │
       └────────────────┴─────────────────────────────────────────────────────┘
                                           │
                                           ▼
  ┌────────────────────────────────────────────────────────────────────────────┐
  │  ai1 (ksrceai1) — 20.1.1.130 — Primary Node                             │
  │                                                                            │
  │  nginx :443 (TLS termination, single edge gateway)                        │
  │    ├── /              → Next.js Frontend    (localhost:3011)               │
  │    ├── /api/          → NestJS Backend      (localhost:3010)               │
  │    ├── /auth/         → Keycloak            (localhost:8080)               │
  │    ├── /s/81xx/       → Session containers  (localhost:81xx)  [ai1]       │
  │    └── /s/82xx/       → Session containers  (20.1.1.132:82xx) [ai2]      │
  │                                                                            │
  │  Session Orchestration   :9998                                             │
  │  Storage Provision       :9999                                             │
  │  CoTURN                  :3478 + 49152-49252                              │
  │  PostgreSQL              :5432                                             │
  │  Desktop Sessions        :8100-8199                                        │
  │                                                                            │
  └──────────────────────── LAN (20.1.1.x) ───────────────────────────────────┘
                                    │
                                    │ Direct Ethernet / Switch
                                    │
  ┌────────────────────────────────────────────────────────────────────────────┐
  │  ai2 (ksrceai2) — 20.1.1.132 — Compute-Only Node                        │
  │                                                                            │
  │  Session Orchestration   :9998                                             │
  │  Desktop Sessions        :8200-8299                                        │
  │  (No frontend, backend, Keycloak, or database)                            │
  │                                                                            │
  └────────────────────────────────────────────────────────────────────────────┘
```

### Dev → Production IP Mapping

| Component | Dev Environment | Production |
|-----------|----------------|------------|
| **Primary node (ai1)** | 192.168.10.99 / Tailscale 100.88.57.107 | 20.1.1.130 |
| **Compute node (ai2)** | 192.168.10.88 / Tailscale 100.94.157.114 | 20.1.1.132 |
| **Public access IP** | Tailscale IPs (e.g. `http://100.88.57.107:8101/`) | `https://103.115.236.52/s/8101/` |
| **Inter-node comm** | 192.168.10.x private LAN | 20.1.1.x private LAN |
| **Session URLs** | `http://{TAILSCALE_IP}:{port}/` | `https://103.115.236.52/s/{port}/` |
| **TURN server** | Tailscale IP of host | 103.115.236.52 (public) |
| **Keycloak** | `http://localhost:8080` | `https://103.115.236.52/auth` |
| **Frontend** | `http://localhost:3000` | `https://103.115.236.52` |
| **Backend API** | `http://localhost:3001` | `https://103.115.236.52/api` |

---

## 2. Port Forwarding Requirements

Provide this table to the IT admin / network team. These rules must be configured on the NAT gateway / router that owns `103.115.236.52`:

### Required Port Forward Rules

| # | Public Port | Protocol | Forward To | Purpose |
|---|-------------|----------|------------|---------|
| 1 | **443** | TCP | 20.1.1.130:443 | HTTPS — all web traffic (nginx) |
| 2 | **80** | TCP | 20.1.1.130:80 | HTTP → HTTPS redirect |
| 3 | **3478** | TCP+UDP | 20.1.1.130:3478 | CoTURN — TURN/STUN relay for WebRTC |
| 4 | **49152-49252** | UDP | 20.1.1.130:49152-49252 | CoTURN — TURN relay port range |

### Existing SSH Forwards (keep as-is)

| # | Public Port | Protocol | Forward To | Purpose |
|---|-------------|----------|------------|---------|
| 5 | **2223** | TCP | 20.1.1.130:22 | SSH to ai1 |
| 6 | **2224** | TCP | 20.1.1.132:22 | SSH to ai2 |

> **Note:** Only 4 new port forward rules are needed. All web services (frontend, backend, Keycloak, sessions) are multiplexed through nginx on port 443. CoTURN requires its own ports because WebRTC TURN relay operates outside HTTP.

---

## 3. Nginx Configuration

Install nginx on ai1:

```bash
sudo apt update && sudo apt install -y nginx
```

Create the config file at `/etc/nginx/sites-available/laas`:

```nginx
# ─────────────────────────────────────────────────────────────────────────────
# LaaS Production — Nginx Reverse Proxy
# File: /etc/nginx/sites-available/laas
# Symlink: ln -s /etc/nginx/sites-available/laas /etc/nginx/sites-enabled/laas
# Remove default: rm /etc/nginx/sites-enabled/default
# ─────────────────────────────────────────────────────────────────────────────

# WebSocket upgrade map (used by sessions + frontend HMR)
map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

# ── HTTP → HTTPS redirect ────────────────────────────────────────────────────
server {
    listen 80;
    listen [::]:80;
    server_name 103.115.236.52;

    # Let's Encrypt ACME challenge (if using certbot)
    location /.well-known/acme-challenge/ {
        root /var/www/html;
    }

    location / {
        return 301 https://$host$request_uri;
    }
}

# ── HTTPS — Main server block ────────────────────────────────────────────────
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name 103.115.236.52;

    # ── SSL Certificates ─────────────────────────────────────────────────
    ssl_certificate     /etc/ssl/laas/fullchain.pem;
    ssl_certificate_key /etc/ssl/laas/privkey.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    # ── Global proxy settings ────────────────────────────────────────────
    client_max_body_size 500M;         # Large file uploads (storage, images)
    proxy_read_timeout 86400s;         # 24h — long-running desktop sessions
    proxy_send_timeout 86400s;
    proxy_connect_timeout 30s;

    # ── Keycloak (/auth) ─────────────────────────────────────────────────
    # Keycloak runs on localhost:8080 with KC_HTTP_RELATIVE_PATH=/auth
    # MUST hardcode X-Forwarded-Proto and X-Forwarded-Port — see Keycloak-Production-Setup.md
    location /auth {
        proxy_pass http://127.0.0.1:8080;
        proxy_http_version 1.1;

        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Forwarded-Host  $host;
        proxy_set_header X-Forwarded-Port  443;

        # Keycloak sets large session cookies — must increase buffer size
        proxy_buffer_size       128k;
        proxy_buffers           4 128k;
        proxy_busy_buffers_size 256k;
    }

    # ── Backend API (/api/) ──────────────────────────────────────────────
    # NestJS backend on localhost:3010
    # Strip /api prefix: /api/sessions → backend receives /sessions
    location /api/ {
        proxy_pass http://127.0.0.1:3010/;
        proxy_http_version 1.1;

        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # WebSocket support for real-time events
        proxy_set_header Upgrade           $http_upgrade;
        proxy_set_header Connection        $connection_upgrade;
    }

    # ── Desktop Sessions — ai1 (ports 8100-8199) ────────────────────────
    # URL pattern: /s/81xx/ → proxy to localhost:81xx
    # Selkies desktop containers use WebSocket for VNC/WebRTC streaming
    location ~ ^/s/(81\d{2})(/.*)?$ {
        set $session_port $1;
        set $session_path $2;

        # Rewrite to strip /s/<port> prefix — container sees / as root
        proxy_pass http://127.0.0.1:$session_port$session_path;
        proxy_http_version 1.1;

        # WebSocket upgrade (CRITICAL for Selkies/KasmVNC streaming)
        proxy_set_header Upgrade         $http_upgrade;
        proxy_set_header Connection      $connection_upgrade;

        proxy_set_header Host            $host;
        proxy_set_header X-Real-IP       $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Long timeouts for persistent desktop sessions
        proxy_read_timeout  86400s;
        proxy_send_timeout  86400s;
    }

    # ── Desktop Sessions — ai2 (ports 8200-8299) ────────────────────────
    # URL pattern: /s/82xx/ → proxy to ai2 (20.1.1.132):82xx over LAN
    location ~ ^/s/(82\d{2})(/.*)?$ {
        set $session_port $1;
        set $session_path $2;

        proxy_pass http://20.1.1.132:$session_port$session_path;
        proxy_http_version 1.1;

        # WebSocket upgrade (CRITICAL for Selkies/KasmVNC streaming)
        proxy_set_header Upgrade         $http_upgrade;
        proxy_set_header Connection      $connection_upgrade;

        proxy_set_header Host            $host;
        proxy_set_header X-Real-IP       $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Long timeouts for persistent desktop sessions
        proxy_read_timeout  86400s;
        proxy_send_timeout  86400s;
    }

    # ── Next.js Frontend (catch-all — MUST be last) ──────────────────────
    # Frontend on localhost:3011
    location / {
        proxy_pass http://127.0.0.1:3011;
        proxy_http_version 1.1;

        proxy_set_header Upgrade           $http_upgrade;
        proxy_set_header Connection        $connection_upgrade;
        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### Enable the config:

```bash
# Symlink to sites-enabled
sudo ln -s /etc/nginx/sites-available/laas /etc/nginx/sites-enabled/laas

# Remove default site
sudo rm -f /etc/nginx/sites-enabled/default

# Test and reload
sudo nginx -t
sudo systemctl reload nginx
```

### Key Nginx Design Decisions

| Decision | Reason |
|----------|--------|
| Session URLs use `/s/<port>/` path prefix | Multiplexes all sessions through port 443; avoids exposing 100 ports publicly |
| ai2 sessions use port range 8200-8299 | Avoids collision with ai1's 8100-8199 range when routing through a single nginx |
| Keycloak uses hardcoded `X-Forwarded-Proto: https` | Using `$scheme` can forward `http`, causing Keycloak to generate HTTP redirect URLs |
| `proxy_read_timeout 86400s` on sessions | Desktop sessions are long-lived (hours/days); default 60s timeout kills them |
| WebSocket `Upgrade` headers on all session locations | Selkies uses WebSocket for WebRTC signaling and KasmVNC fallback streaming |

---

## 4. SSL Certificate Setup

### Option A: Self-Signed Certificate (for testing)

```bash
sudo mkdir -p /etc/ssl/laas

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/laas/privkey.pem \
  -out /etc/ssl/laas/fullchain.pem \
  -subj "/C=IN/ST=TN/L=Chennai/O=LaaS/CN=103.115.236.52"

sudo chmod 600 /etc/ssl/laas/privkey.pem
sudo chmod 644 /etc/ssl/laas/fullchain.pem
```

> **Warning:** Browsers will show a security warning. Users must click "Advanced → Proceed" to accept the self-signed cert. This is acceptable for internal/testing deployments.

### Option B: Let's Encrypt with Certbot (requires a domain)

If a domain name (e.g., `ksrceailab.com`) is pointed to `103.115.236.52`:

```bash
sudo apt install -y certbot python3-certbot-nginx

# Obtain certificate (nginx plugin auto-configures)
sudo certbot --nginx -d ksrceailab.com -d www.ksrceailab.com

# Certificates are stored at:
#   /etc/letsencrypt/live/ksrceailab.com/fullchain.pem
#   /etc/letsencrypt/live/ksrceailab.com/privkey.pem
```

Update the nginx config SSL paths:
```nginx
ssl_certificate     /etc/letsencrypt/live/ksrceailab.com/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/ksrceailab.com/privkey.pem;
```

Auto-renewal is configured automatically by certbot. Verify:
```bash
sudo certbot renew --dry-run
```

### Option C: Client-Provided Certificates

If the client provides their own certificates:

```bash
# Copy cert files
sudo mkdir -p /etc/ssl/laas
sudo cp /path/to/client-cert.pem /etc/ssl/laas/fullchain.pem
sudo cp /path/to/client-key.pem /etc/ssl/laas/privkey.pem

# Set proper permissions
sudo chmod 600 /etc/ssl/laas/privkey.pem
sudo chmod 644 /etc/ssl/laas/fullchain.pem
sudo chown root:root /etc/ssl/laas/*.pem
```

### Certificate File Reference

| File | Path | Permissions |
|------|------|-------------|
| Certificate (full chain) | `/etc/ssl/laas/fullchain.pem` | 644 |
| Private key | `/etc/ssl/laas/privkey.pem` | 600 |

---

## 5. CoTURN Configuration

CoTURN runs on ai1 and handles WebRTC TURN relay for **both** ai1 and ai2 sessions. The Selkies desktop container sets its TURN server via the `SELKIES_TURN_HOST` env var (see `app.py` line 1020: `cmd.extend(["-e", f"SELKIES_TURN_HOST={TURN_HOST}"])"`).

### Install CoTURN

```bash
sudo apt install -y coturn
sudo systemctl enable coturn
```

Edit `/etc/default/coturn` to enable the service:
```
TURNSERVER_ENABLED=1
```

### Full `/etc/turnserver.conf`

```ini
# ─────────────────────────────────────────────────────────────────────────────
# LaaS CoTURN Configuration — ai1 (20.1.1.130)
# ─────────────────────────────────────────────────────────────────────────────

# Listening ports
listening-port=3478
# tls-listening-port=5349  # Uncomment if TURN-over-TLS needed

# NAT mapping: public_ip / private_ip
# This tells TURN to rewrite its relay addresses from the private LAN IP
# to the public IP so that external browsers can reach it.
external-ip=103.115.236.52/20.1.1.130

# Relay port range (must match port forwarding in Section 2)
min-port=49152
max-port=49252

# Listen on all interfaces
listening-ip=0.0.0.0

# Relay on the LAN interface
relay-ip=20.1.1.130

# Authentication — must match TURN_USERNAME / TURN_PASSWORD in session-orchestration
# (app.py line 94-95: TURN_USERNAME default "selkies", TURN_PASSWORD default "wVIAbfwkgkxjaCiZVX4BDsdU")
lt-cred-mech
user=selkies:wVIAbfwkgkxjaCiZVX4BDsdU

# Realm
realm=laas

# Logging
log-file=/var/log/turnserver.log
verbose

# Security
no-multicast-peers
no-cli
denied-peer-ip=0.0.0.0-0.255.255.255
denied-peer-ip=127.0.0.0-127.255.255.255

# Fingerprint for STUN
fingerprint
```

### Start CoTURN

```bash
sudo systemctl restart coturn
sudo systemctl status coturn
```

### iptables Rules for Container-to-TURN

Desktop containers in bridge networking need to reach CoTURN on the host. Add to the `DOCKER-USER` chain:

```bash
# Allow established connections back to containers (required for TURN relay responses)
sudo iptables -I DOCKER-USER 1 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow containers on laas-sessions bridge to reach host TURN port
sudo iptables -I DOCKER-USER 2 -i br-+ -p tcp --dport 3478 -j ACCEPT
sudo iptables -I DOCKER-USER 3 -i br-+ -p udp --dport 3478 -j ACCEPT
sudo iptables -I DOCKER-USER 4 -i br-+ -p udp --dport 49152:49252 -j ACCEPT
```

---

## 6. Session Orchestration Changes

### Current Code (Dev)

In `host-services/session-orchestration/app.py`, the session URL is built at **line 1423**:

```python
"sessionUrl": f"http://{HOST_IP}:{nginx_port}/",
```

Where `HOST_IP` defaults to `192.168.10.92` (line 42):
```python
HOST_IP = os.environ.get("HOST_IP", "192.168.10.92")
```

In dev, sessions are accessed directly: `http://100.88.57.107:8101/`

### Production Approach — Add `SESSION_BASE_URL` Environment Variable

The session URL must change from direct IP:port access to nginx-proxied paths. Add a new env var `SESSION_BASE_URL` that, when set, changes the URL format:

**Code change needed** in `app.py` (around line 42, add after HOST_IP):

```python
HOST_IP = os.environ.get("HOST_IP", "192.168.10.92")
SESSION_BASE_URL = os.environ.get("SESSION_BASE_URL", "")  # e.g. "https://103.115.236.52/s"
```

**Code change needed** at **line 1423** (connection_info construction):

```python
# Before (direct access):
# "sessionUrl": f"http://{HOST_IP}:{nginx_port}/",

# After (nginx-proxied when SESSION_BASE_URL is set):
"sessionUrl": f"{SESSION_BASE_URL}/{nginx_port}/" if SESSION_BASE_URL else f"http://{HOST_IP}:{nginx_port}/",
```

### Environment Variables — ai1 Session Orchestration

```bash
# Start session-orchestration on ai1
SESSION_SECRET=laas-session-secret-dev \
HOST_IP=20.1.1.130 \
TURN_HOST=103.115.236.52 \
TURN_PORT=3478 \
TURN_USERNAME=selkies \
TURN_PASSWORD=wVIAbfwkgkxjaCiZVX4BDsdU \
TURN_PROTOCOL=tcp \
SESSION_BASE_URL=https://103.115.236.52/s \
NFS_MOUNT_ROOT=/mnt/nfs/users \
LAAS_NETWORK_MODE=bridge \
python3 app.py
```

**Key changes from dev:**
- `HOST_IP=20.1.1.130` — ai1's LAN IP (was Tailscale IP)
- `TURN_HOST=103.115.236.52` — public IP, reachable by browsers AND containers
- `SESSION_BASE_URL=https://103.115.236.52/s` — nginx-proxied session URLs

### Environment Variables — ai2 Session Orchestration

```bash
# Start session-orchestration on ai2
SESSION_SECRET=laas-session-secret-dev \
HOST_IP=20.1.1.132 \
TURN_HOST=103.115.236.52 \
TURN_PORT=3478 \
TURN_USERNAME=selkies \
TURN_PASSWORD=wVIAbfwkgkxjaCiZVX4BDsdU \
TURN_PROTOCOL=tcp \
SESSION_BASE_URL=https://103.115.236.52/s \
NFS_MOUNT_ROOT=/mnt/nfs/users \
LAAS_NETWORK_MODE=bridge \
python3 app.py
```

### ai2 Port Range Change

ai2 must use a **different port range** (8200-8299) so that nginx can route correctly. Modify the port range constants at the top of `app.py` on ai2 (lines 57-58):

```python
# ai1 (default):
NGINX_PORT_MIN, NGINX_PORT_MAX = 8100, 8199

# ai2 (override via env or edit):
NGINX_PORT_MIN, NGINX_PORT_MAX = 8200, 8299
```

**Better approach** — make port range configurable via env:

```python
NGINX_PORT_MIN = int(os.environ.get("NGINX_PORT_MIN", "8100"))
NGINX_PORT_MAX = int(os.environ.get("NGINX_PORT_MAX", "8199"))
```

Then on ai2: `NGINX_PORT_MIN=8200 NGINX_PORT_MAX=8299`

---

## 7. Storage Provision Configuration

### Current Code

In `host-services/storage-provision/app.py`:
- `PROVISION_SECRET` — shared secret validated on every `/provision` POST (line 25)
- `STORAGE_IP` — 10GbE interface IP for NVMe-oF targets (line 43)
- Listens on `0.0.0.0:9999` (line 2051)
- `NFS_AUTOMOUNT_ENABLED` — when `true`, auto-creates NFS exports + mounts (line 36)

### Production Environment — ai1 Only

Storage provision runs only on ai1. No NVMe-oF or 10GbE in production (single ZFS pool, local storage):

```bash
# Start storage-provision on ai1
PROVISION_SECRET=e75064ca1702889e4f519d4ad40dfbd5f18dbdb67db7f365 \
ENABLE_NFS_AUTOMOUNT=true \
NFS_EXPORT_CLIENT=127.0.0.1 \
NFS_MOUNT_ROOT=/mnt/nfs/users \
python3 app.py
```

**Key notes:**
- `STORAGE_IP` is **not set** — NVMe-oF target support is disabled (line 2049: `"STORAGE_IP not set — NVMe-oF target support disabled"`)
- `ENABLE_NFS_AUTOMOUNT=true` — single-node mode, auto-creates NFS exports and mounts locally
- `NFS_EXPORT_CLIENT=127.0.0.1` — exports only to localhost since storage and compute are on the same machine

### Cross-Node NFS (if ai2 needs user storage later)

If ai2 compute containers need access to user storage from ai1:

```bash
# On ai1 — export to ai2 over LAN
NFS_EXPORT_CLIENT=20.1.1.132

# On ai2 — mount ai1's NFS exports
sudo mkdir -p /mnt/nfs/users
sudo mount -t nfs 20.1.1.130:/datapool/users /mnt/nfs/users
```

Add to `/etc/fstab` on ai2 for persistence:
```
20.1.1.130:/datapool/users  /mnt/nfs/users  nfs  defaults,_netdev  0  0
```

---

## 8. Backend .env Configuration

The backend resolves session-orchestration and storage-provision URLs dynamically from the `Node` DB table via `NodeService` (see `backend-new/src/node/node.service.ts` lines 323-331):

```typescript
getSessionOrchestrationUrl(node: Node): string {
    const ip = node.ipManagement || node.ipCompute;
    return `http://${ip}:${node.sessionOrchestrationPort}`;
}

getStorageProvisionUrl(node: Node): string {
    const ip = node.ipManagement || node.ipCompute;
    return `http://${ip}:${node.storageProvisionPort}`;
}
```

So the Node DB entries must have the correct LAN IPs. The `.env` file handles Keycloak, CORS, and other service config.

### Production `.env` Template for `backend-new/.env`

```env
# ─────────────────────────────────────────────────────────────────────────────
# LaaS Backend — Production Environment (ai1)
# ─────────────────────────────────────────────────────────────────────────────

# Database (PostgreSQL on ai1)
DATABASE_URL="postgresql://postgres:root@localhost:5432/laas"

# Backend port (behind nginx, not exposed publicly)
PORT=3010

# CORS — must match the public URL users access
CORS_ORIGIN="https://103.115.236.52"
FRONTEND_URL=https://103.115.236.52

# JWT
JWT_SECRET=<GENERATE_A_STRONG_SECRET_FOR_PRODUCTION>
JWT_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d

# SMTP (Office 365)
SMTP_HOST=smtp.office365.com
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USERNAME=ksrcesupport@gktech.ai
SMTP_PASSWORD=WPlnn061
SMTP_FROM=ksrcesupport@gktech.ai
SUPPORT_ADMIN_EMAIL=ksrcesupport@gktech.ai

# Keycloak — accessed via localhost (same machine, no need for public URL)
KEYCLOAK_URL=http://localhost:8080
KEYCLOAK_REALM=laas
KEYCLOAK_CLIENT_ID=laas-backend
KEYCLOAK_CLIENT_SECRET=<PRODUCTION_CLIENT_SECRET>
KEYCLOAK_FRONTEND_CLIENT_ID=laas-frontend
KEYCLOAK_ADMIN_USER=admin
KEYCLOAK_ADMIN_PASSWORD=<PRODUCTION_ADMIN_PASSWORD>

# Storage Provision — resolved from Node DB, but secret is global
USER_STORAGE_PROVISION_SECRET=e75064ca1702889e4f519d4ad40dfbd5f18dbdb67db7f365

# Session Orchestration — resolved from Node DB, but secret is global
SESSION_ORCHESTRATION_SECRET=laas-session-secret-dev
SESSION_CREDENTIAL_KEY=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef

# Razorpay Payment Gateway
RAZORPAY_KEY_ID=<PRODUCTION_KEY>
RAZORPAY_KEY_SECRET=<PRODUCTION_SECRET>

# Waitlist
WAITLIST_BASE_OFFSET=72
```

### Node DB Records

Update the `Node` table in PostgreSQL so the backend resolves the correct production IPs:

| Field | ai1 Value | ai2 Value |
|-------|-----------|----------|
| `hostname` | `ksrceai1` | `ksrceai2` |
| `ipManagement` | `20.1.1.130` | `20.1.1.132` |
| `ipCompute` | `20.1.1.130` | `20.1.1.132` |
| `sessionOrchestrationPort` | `9998` | `9998` |
| `storageProvisionPort` | `9999` | `null` |

```sql
-- Update ai1 node record
UPDATE "Node" SET
  "ipManagement" = '20.1.1.130',
  "ipCompute" = '20.1.1.130',
  "sessionOrchestrationPort" = 9998,
  "storageProvisionPort" = 9999
WHERE "hostname" = 'ksrceai1';

-- Update ai2 node record
UPDATE "Node" SET
  "ipManagement" = '20.1.1.132',
  "ipCompute" = '20.1.1.132',
  "sessionOrchestrationPort" = 9998,
  "storageProvisionPort" = NULL
WHERE "hostname" = 'ksrceai2';
```

### Frontend `.env.local`

```env
NEXT_PUBLIC_KEYCLOAK_URL=https://103.115.236.52/auth
NEXT_PUBLIC_API_URL=https://103.115.236.52/api
```

---

## 9. Keycloak Reverse Proxy Setup

Keycloak runs on ai1 in **production mode** behind nginx using the **edge proxy pattern**: nginx terminates TLS, Keycloak serves HTTP internally.

### Podman Run Command

```bash
podman run -d \
  --name keycloak \
  --replace \
  --network=host \
  -e KC_BOOTSTRAP_ADMIN_USERNAME=admin \
  -e KC_BOOTSTRAP_ADMIN_PASSWORD=<PRODUCTION_ADMIN_PASSWORD> \
  -e KC_HOSTNAME=https://103.115.236.52/auth \
  -e KC_HTTP_RELATIVE_PATH=/auth \
  -e KC_PROXY_HEADERS=xforwarded \
  -e KC_HTTP_ENABLED=true \
  -e KC_HOSTNAME_STRICT=false \
  -e KC_DB=postgres \
  -e KC_DB_URL=jdbc:postgresql://localhost:5432/keycloak \
  -e KC_DB_USERNAME=postgres \
  -e KC_DB_PASSWORD=root \
  -e KC_HEALTH_ENABLED=true \
  -e KC_HTTP_PORT=8080 \
  quay.io/keycloak/keycloak:26.2 \
  start
```

### Key Configuration Points

| Setting | Value | Notes |
|---------|-------|-------|
| `KC_HOSTNAME` | `https://103.115.236.52/auth` | Full public URL including protocol + subpath |
| `KC_HTTP_RELATIVE_PATH` | `/auth` | Keycloak mounted at `/auth` subpath |
| `KC_PROXY_HEADERS` | `xforwarded` | Replaces deprecated `KC_PROXY=edge` (Keycloak 26.x) |
| `KC_HTTP_ENABLED` | `true` | TLS terminated at nginx, not Keycloak |
| `KC_HOSTNAME_STRICT` | `false` | Allows IP-based access (no domain name) |
| `start` (not `start-dev`) | — | **Production mode required** — `start-dev` ignores all proxy settings |

### OAuth Provider Callback URLs

When registering Google / GitHub OAuth providers in Keycloak, the callback URL format is:

```
https://103.115.236.52/auth/realms/laas/broker/{provider}/endpoint
```

**Google OAuth:**
- Authorized redirect URI: `https://103.115.236.52/auth/realms/laas/broker/google/endpoint`
- Add to Google Cloud Console → Credentials → OAuth 2.0 Client

**GitHub OAuth:**
- Authorization callback URL: `https://103.115.236.52/auth/realms/laas/broker/github/endpoint`
- Add to GitHub → Settings → Developer Settings → OAuth Apps

### Keycloak Client Redirect URIs

In the Keycloak admin console, update the `laas-frontend` client:

- **Valid Redirect URIs:** `https://103.115.236.52/*`
- **Web Origins:** `https://103.115.236.52`
- **Post Logout Redirect URIs:** `https://103.115.236.52/*`

---

## 10. iptables & UFW Firewall Rules

### ai1 — UFW Rules

```bash
# SSH
sudo ufw allow 22/tcp

# Nginx (HTTPS + HTTP redirect)
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# CoTURN
sudo ufw allow 3478/tcp
sudo ufw allow 3478/udp
sudo ufw allow 49152:49252/udp

# Allow all traffic from ai2 on LAN
sudo ufw allow from 20.1.1.132

# Enable UFW
sudo ufw enable
sudo ufw status verbose
```

### ai2 — UFW Rules

```bash
# SSH
sudo ufw allow 22/tcp

# Allow all traffic from ai1 on LAN (nginx proxying sessions, NFS)
sudo ufw allow from 20.1.1.130

# Session container ports (ai2 range: 8200-8299) — from ai1 nginx only
sudo ufw allow from 20.1.1.130 to any port 8200:8299 proto tcp

# Enable UFW
sudo ufw enable
sudo ufw status verbose
```

### iptables DOCKER-USER Chain (ai1 + ai2)

Docker containers in bridge mode are firewalled by the `DOCKER-USER` chain. Session containers must reach CoTURN on the host for WebRTC relay:

```bash
# On ai1 — Allow container-to-host TURN traffic
sudo iptables -I DOCKER-USER 1 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -I DOCKER-USER 2 -i br-+ -p tcp --dport 3478 -j ACCEPT
sudo iptables -I DOCKER-USER 3 -i br-+ -p udp --dport 3478 -j ACCEPT
sudo iptables -I DOCKER-USER 4 -i br-+ -p udp --dport 49152:49252 -j ACCEPT

# On ai2 — Same rules (containers reach ai1's TURN via bridge gateway)
sudo iptables -I DOCKER-USER 1 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -I DOCKER-USER 2 -i br-+ -p tcp --dport 3478 -j ACCEPT
sudo iptables -I DOCKER-USER 3 -i br-+ -p udp --dport 3478 -j ACCEPT
```

### Persist iptables Rules

```bash
sudo apt install -y iptables-persistent
sudo iptables-save | sudo tee /etc/iptables/rules.v4
```

> **Important:** When UFW is enabled, it manages iptables rules. Direct `iptables` manipulation should be limited to the `DOCKER-USER` chain only. All other firewall rules should use `ufw` commands.

---

## 11. ai2 Compute Node Setup

ai2 is a **compute-only** node. It runs Docker + session-orchestration + desktop containers. It does NOT run frontend, backend, Keycloak, PostgreSQL, or storage-provision.

### What Gets Installed on ai2

| Component | Installed? | Notes |
|-----------|-----------|-------|
| Docker + NVIDIA Container Toolkit | Yes | Required for GPU desktop containers |
| Session Orchestration (`app.py`) | Yes | Manages container lifecycle |
| Storage Provision | **No** | Runs only on ai1 |
| NestJS Backend | **No** | Runs only on ai1 |
| Next.js Frontend | **No** | Runs only on ai1 |
| Keycloak | **No** | Runs only on ai1 |
| PostgreSQL | **No** | Runs only on ai1 |
| Nginx | **No** | Runs only on ai1 |
| CoTURN | **No** | Runs only on ai1; ai2 containers point to ai1's TURN |
| NFS Client | Yes (if cross-node storage) | Mounts user storage from ai1 |

### ai2 Setup Steps

```bash
# 1. Install Docker
sudo apt update && sudo apt install -y docker.io
sudo systemctl enable --now docker

# 2. Install NVIDIA Container Toolkit
# (Follow NVIDIA docs for your GPU driver version)
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# 3. Create the laas-sessions bridge network
docker network create laas-sessions

# 4. Pull the Selkies desktop image
docker pull ghcr.io/selkies-project/nvidia-egl-desktop:latest

# 5. Install Python + Flask for session-orchestration
sudo apt install -y python3 python3-pip python3-venv
cd ~/session-orchestration
python3 -m venv venv
source venv/bin/activate
pip install flask

# 6. Copy app.py from ai1 (or deploy from repo)
scp ai1@20.1.1.130:~/session-orchestration/app.py ~/session-orchestration/
```

### ai2 Session Orchestration Environment

```bash
SESSION_SECRET=laas-session-secret-dev \
HOST_IP=20.1.1.132 \
TURN_HOST=103.115.236.52 \
TURN_PORT=3478 \
TURN_USERNAME=selkies \
TURN_PASSWORD=wVIAbfwkgkxjaCiZVX4BDsdU \
TURN_PROTOCOL=tcp \
SESSION_BASE_URL=https://103.115.236.52/s \
NFS_MOUNT_ROOT=/mnt/nfs/users \
LAAS_NETWORK_MODE=bridge \
NGINX_PORT_MIN=8200 \
NGINX_PORT_MAX=8299 \
python3 app.py
```

**Critical differences from ai1:**
- `HOST_IP=20.1.1.132` — ai2's LAN IP
- `TURN_HOST=103.115.236.52` — public IP (ai1's CoTURN), NOT ai2's own IP
- `NGINX_PORT_MIN=8200`, `NGINX_PORT_MAX=8299` — distinct range to avoid collision
- All session URLs become `https://103.115.236.52/s/82xx/` (routed by nginx to ai2 over LAN)

---

## 12. Step-by-Step Deployment Checklist

### Phase 1: Infrastructure (IT Admin)

- [ ] 1. Configure NAT port forwarding (Section 2): 443, 80, 3478, 49152-49252 → ai1
- [ ] 2. Verify SSH access: `ssh ai1@103.115.236.52 -p 2223` and `ssh ai2@103.115.236.52 -p 2224`
- [ ] 3. Verify ai1 ↔ ai2 LAN connectivity: `ping 20.1.1.132` from ai1

### Phase 2: ai1 Base Services

- [ ] 4. Install nginx: `sudo apt install -y nginx`
- [ ] 5. Generate/install SSL certificates (Section 4)
- [ ] 6. Deploy nginx config `/etc/nginx/sites-available/laas` (Section 3)
- [ ] 7. Enable nginx config: `ln -s`, remove default, `nginx -t`, `reload`
- [ ] 8. Install and configure CoTURN (Section 5)
- [ ] 9. Install PostgreSQL, create `laas` and `keycloak` databases
- [ ] 10. Start Keycloak in production mode (Section 9)
- [ ] 11. Configure Keycloak realm, clients, OAuth providers, redirect URIs

### Phase 3: ai1 Application Services

- [ ] 12. Deploy backend code, install dependencies (`npm install`)
- [ ] 13. Configure `backend-new/.env` (Section 8)
- [ ] 14. Run Prisma migrations: `npx prisma migrate deploy`
- [ ] 15. Update Node DB records with production IPs (Section 8 SQL)
- [ ] 16. Start backend: `npm run start:prod` or via pm2
- [ ] 17. Deploy frontend code, install dependencies
- [ ] 18. Configure `frontend-new/.env.local` (Section 8)
- [ ] 19. Build frontend: `npm run build`
- [ ] 20. Start frontend: `npm run start` (port 3011) or via pm2

### Phase 4: ai1 Host Services

- [ ] 21. Create Docker network: `docker network create laas-sessions`
- [ ] 22. Pull Selkies image: `docker pull ghcr.io/selkies-project/nvidia-egl-desktop:latest`
- [ ] 23. Apply `SESSION_BASE_URL` code change to session-orchestration `app.py` (Section 6)
- [ ] 24. Make port range configurable via env in `app.py` (Section 6)
- [ ] 25. Start storage-provision on ai1 (Section 7)
- [ ] 26. Start session-orchestration on ai1 (Section 6)
- [ ] 27. Configure iptables DOCKER-USER rules (Section 5 / Section 10)
- [ ] 28. Configure UFW rules on ai1 (Section 10)

### Phase 5: ai2 Compute Node

- [ ] 29. Install Docker + NVIDIA Container Toolkit on ai2 (Section 11)
- [ ] 30. Create Docker network: `docker network create laas-sessions`
- [ ] 31. Pull Selkies image on ai2
- [ ] 32. Deploy session-orchestration code to ai2
- [ ] 33. Start session-orchestration on ai2 with port range 8200-8299 (Section 11)
- [ ] 34. Configure UFW on ai2 (Section 10)
- [ ] 35. Configure iptables DOCKER-USER rules on ai2 (Section 10)
- [ ] 36. (Optional) Mount NFS from ai1 for cross-node user storage (Section 7)

### Phase 6: Verification

- [ ] 37. Run all verification commands (Section 13)
- [ ] 38. Test end-to-end: sign in → launch session → verify WebRTC stream
- [ ] 39. Test ai2 session launch and verify nginx proxying
- [ ] 40. Persist iptables rules: `sudo iptables-save | sudo tee /etc/iptables/rules.v4`

---

## 13. Verification & Testing Commands

### Nginx

```bash
# Test config syntax
sudo nginx -t

# Check nginx is running
sudo systemctl status nginx

# Verify SSL certificate
openssl s_client -connect 103.115.236.52:443 -servername 103.115.236.52 < /dev/null 2>/dev/null | openssl x509 -noout -subject -dates

# Test HTTPS access (from any machine)
curl -k https://103.115.236.52/          # Should return frontend HTML
curl -k https://103.115.236.52/api/health  # Should return backend health
curl -k https://103.115.236.52/auth/       # Should return Keycloak page
```

### CoTURN

```bash
# Check CoTURN is running
sudo systemctl status coturn

# Test TURN connectivity (from external machine)
# Use a browser-based TURN tester: https://webrtc.github.io/samples/src/content/peerconnection/trickle-ice/
# Add server: turn:103.115.236.52:3478?transport=tcp
# Username: selkies
# Password: wVIAbfwkgkxjaCiZVX4BDsdU
# Should show "relay" candidates

# Check TURN port is listening
ss -tlnp | grep 3478
```

### Keycloak

```bash
# Health check (local)
curl http://localhost:8080/auth/health

# Health check (through nginx)
curl -k https://103.115.236.52/auth/health

# Admin console (browser)
# https://103.115.236.52/auth/admin/
```

### Backend

```bash
# Health check
curl -k https://103.115.236.52/api/health

# Check backend logs
pm2 logs backend
```

### Session Orchestration

```bash
# ai1 — health check
curl http://20.1.1.130:9998/health

# ai2 — health check (from ai1)
curl http://20.1.1.132:9998/health

# List running sessions on ai1
curl -H "X-Session-Secret: laas-session-secret-dev" http://20.1.1.130:9998/sessions
```

### Storage Provision

```bash
# Health check
curl http://20.1.1.130:9999/health
```

### End-to-End Session Test

```bash
# 1. Sign in via browser at https://103.115.236.52
# 2. Launch a GPU session from the dashboard
# 3. Wait for session to become "ready"
# 4. Click the session URL — should open at https://103.115.236.52/s/81xx/
# 5. Desktop should render via WebRTC (check browser console for ICE candidates)

# Verify session container on ai1:
docker ps | grep laas-sess

# Verify WebSocket upgrade is working (in browser DevTools → Network tab):
# Look for WebSocket connections to wss://103.115.236.52/s/81xx/ws
# Status should be 101 Switching Protocols
```

### LAN Connectivity (ai1 → ai2)

```bash
# From ai1:
ping 20.1.1.132
curl http://20.1.1.132:9998/health

# Test nginx can reach ai2 session (after a session is launched):
curl http://20.1.1.132:8200/
```

---

## 14. Troubleshooting

### Problem: WebRTC Stream Fails — "Connection failed" in Browser

**Symptom:** Desktop session loads the nginx landing page but the WebRTC stream never connects. Browser console shows ICE candidate failures.

**Cause:** `TURN_HOST` is set to a wrong or unreachable IP.

**Fix:**
```bash
# TURN_HOST must be the PUBLIC IP (reachable by browsers)
# In session-orchestration env:
TURN_HOST=103.115.236.52  # ✅ Public IP
TURN_HOST=20.1.1.130      # ❌ Not reachable from internet
TURN_HOST=192.168.10.92   # ❌ Dev IP
```

Also verify CoTURN `external-ip` mapping in `/etc/turnserver.conf`:
```
external-ip=103.115.236.52/20.1.1.130
```

### Problem: Nginx 502 Bad Gateway on Session URLs

**Symptom:** `https://103.115.236.52/s/8101/` returns 502.

**Cause:** Session container is not running or port is not exposed.

**Fix:**
```bash
# Check if container is running
docker ps | grep laas-sess

# Check if port is listening
ss -tlnp | grep 8101

# Check container logs
docker logs laas-sess-<session-id>
```

### Problem: Nginx Proxy Timeout — Session Disconnects After 60s

**Symptom:** Desktop session works for ~60 seconds then disconnects.

**Cause:** Default `proxy_read_timeout` is 60s. Desktop sessions are long-lived.

**Fix:** Ensure session location blocks have:
```nginx
proxy_read_timeout  86400s;
proxy_send_timeout  86400s;
```

### Problem: Keycloak Redirect Loop or HTTP URLs

**Symptom:** After login, Keycloak redirects to `http://` instead of `https://`, or enters an infinite redirect loop.

**Cause:** Keycloak is running in `start-dev` mode (ignores proxy settings) or `X-Forwarded-Proto` is not hardcoded to `https`.

**Fix:**
1. Ensure Keycloak is started with `start` (NOT `start-dev`)
2. Ensure `KC_PROXY_HEADERS=xforwarded` is set
3. Ensure nginx hardcodes `proxy_set_header X-Forwarded-Proto https;` for the `/auth` location
4. Ensure `KC_HOSTNAME=https://103.115.236.52/auth`

### Problem: CORS Errors in Browser Console

**Symptom:** Browser console shows `Access-Control-Allow-Origin` errors.

**Cause:** Backend `CORS_ORIGIN` doesn't match the URL users access.

**Fix:**
```env
# backend-new/.env
CORS_ORIGIN="https://103.115.236.52"
```
Must exactly match the URL in the browser address bar (no trailing slash).

### Problem: ai2 Sessions Not Accessible Through Nginx

**Symptom:** ai1 sessions work, but ai2 sessions at `/s/82xx/` fail.

**Cause:** nginx can't reach ai2 over LAN, or ai2 firewall blocks the connection.

**Fix:**
```bash
# From ai1, test LAN connectivity:
curl http://20.1.1.132:8200/

# If unreachable, check ai2 UFW:
sudo ufw status
# Ensure: "allow from 20.1.1.130"

# Check ai2 session-orchestration is using port range 8200-8299:
curl -H "X-Session-Secret: laas-session-secret-dev" http://20.1.1.132:9998/sessions
```

### Problem: Large File Upload Fails (413 Request Entity Too Large)

**Symptom:** File uploads fail with HTTP 413.

**Fix:** The nginx config includes `client_max_body_size 500M;`. If you need more:
```nginx
client_max_body_size 1G;
```
Then `sudo nginx -t && sudo systemctl reload nginx`.

### Problem: Keycloak Returns 502 Bad Gateway

**Symptom:** `/auth` path returns 502.

**Cause:** Keycloak container is not running, or proxy buffers are too small for Keycloak's large cookies.

**Fix:**
```bash
# Check Keycloak is running
podman ps | grep keycloak
podman logs keycloak

# Ensure nginx has large proxy buffers for /auth location:
proxy_buffer_size       128k;
proxy_buffers           4 128k;
proxy_busy_buffers_size 256k;
```
