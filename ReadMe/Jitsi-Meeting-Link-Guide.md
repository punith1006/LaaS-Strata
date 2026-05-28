# Jitsi Meet — Time-Limited Video Conference Links

## Overview

This module generates **time-limited Jitsi Meet video conference links** that automatically terminate when the JWT token expires. It is used for the mentoring module where each mentoring session gets a unique, expiring video call link.

### What It Does

1. **Backend** generates a JWT signed with a shared secret (`JITSI_APP_SECRET`), scoped to a specific room, with a configurable TTL (default: 5 minutes)
2. **Frontend** embeds Jitsi via the IFrame API, shows a countdown timer, and forcefully ends the call at expiry
3. **Jitsi Server** validates the JWT at connection time — expired tokens are rejected

### Architecture

```
┌─────────────┐     POST /api/test/jitsi-link      ┌──────────────┐
│   Client    │ ──────────────────────────────────> │   Backend    │
│  (curl/UI)  │ <────────────────────────────────── │  (NestJS)    │
└──────┬──────┘   { meetingUrl, jwt, expiresAt }    └──────┬───────┘
       │                                                    │
       │  Opens meetingUrl                                  │ Signs JWT with
       ▼                                                    │ JITSI_APP_SECRET
┌──────────────┐    Embeds Jitsi IFrame     ┌──────────────▼───────┐
│  Frontend    │ ──────────────────────────> │  Jitsi Server        │
│  /meeting    │    Countdown + hangup       │  103.115.236.34      │
│  page.tsx    │ ── api.executeCommand ───> │  (Docker Compose)     │
└──────────────┘    ('hangup') at expiry     └──────────────────────┘
```

---

## Code Locations

### Backend (NestJS)

| File | Purpose |
|------|---------|
| `backend-new/src/jitsi-demo/jitsi-demo.service.ts` | JWT generation logic — signs tokens with `JITSI_APP_SECRET`, generates unique room names, computes expiry |
| `backend-new/src/jitsi-demo/jitsi-demo.controller.ts` | `POST /api/test/jitsi-link` endpoint — no auth guard (demo mode) |
| `backend-new/src/jitsi-demo/jitsi-demo.module.ts` | NestJS module registration |
| `backend-new/src/app.module.ts` | Imports `JitsiDemoModule` |
| `backend-new/.env` | Environment variables: `JITSI_BASE_URL`, `JITSI_APP_ID`, `JITSI_APP_SECRET` |

### Frontend (Next.js)

| File | Purpose |
|------|---------|
| `frontend-new/src/app/meeting/page.tsx` | Meeting wrapper page — embeds Jitsi IFrame API, countdown timer, forced hangup at expiry |

### Server (Jitsi Docker Deployment)

| Location | Purpose |
|----------|---------|
| `~/jitsi-meet/docker-jitsi-meet-stable-10978/.env` | Jitsi Docker Compose environment config on `aiserver1` |
| `/etc/nginx/sites-available/jitsi-ip-proxy` | Nginx reverse proxy: port 443 → Jitsi web container on 8443 |

### Reference Documentation

| File | Purpose |
|------|---------|
| `.qoder/plans/jitsi-production-deploy-ksrceailab_ae94a7e5.md` | Full Jitsi deployment plan with all gotchas |

---

## Environment Variables

### Backend `.env` (backend-new/.env)

```env
# Jitsi Meet (self-hosted video conferencing)
JITSI_BASE_URL=https://103.115.236.34
JITSI_APP_ID=laas-platform
JITSI_APP_SECRET=73220008326e77404e263675a66d424f7b78d129c660435a4a8cf3e5a6bb0013
```

- `JITSI_BASE_URL` — Public URL of the Jitsi server (must match `PUBLIC_URL` in Jitsi's `.env`)
- `JITSI_APP_ID` — Must match `JWT_APP_ID` in Jitsi's `.env`
- `JITSI_APP_SECRET` — Must match `JWT_APP_SECRET` in Jitsi's `.env` (shared HMAC secret)

### Server Jitsi `.env` (on aiserver1)

```env
AUTH_TYPE=jwt              # CRITICAL: switches Prosody to JWT token auth
ENABLE_AUTH=1              # Enables authentication
ENABLE_GUESTS=0            # Disables guest (anonymous) access
JWT_APP_ID=laas-platform   # Application identifier
JWT_APP_SECRET=7322...     # Shared HMAC-SHA256 secret
PUBLIC_URL=https://103.115.236.34  # No port (nginx handles 443)
JVB_PORT=50000             # UDP port within allowed 49152-65535 range
```

---

## How It Works

### JWT Token Structure

The backend generates a JWT with these claims:

```json
{
  "aud": "jitsi",
  "iss": "laas-platform",
  "sub": "meet.jitsi",
  "room": "demo-a1b2c3d4",
  "exp": 1779990000,
  "context": {
    "user": {
      "name": "Punith",
      "email": "",
      "id": "uuid-here"
    }
  }
}
```

- `iss` — Must match `JWT_APP_ID` on the Jitsi server
- `sub` — The XMPP domain (`meet.jitsi` is the default)
- `room` — Unique room name (UUID-based, e.g., `demo-{8 chars}`)
- `exp` — Unix timestamp (UTC) when the token expires
- `context.user` — Display information shown to other participants

### API Endpoint

```
POST /api/test/jitsi-link
Content-Type: application/json

{
  "displayName": "Punith",    // optional, default: "Guest"
  "ttlSeconds": 300            // optional, default: 300 (5 minutes)
}
```

**Response:**
```json
{
  "roomName": "demo-a1b2c3d4",
  "jwt": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "jitsiDirectUrl": "https://103.115.236.34/demo-a1b2c3d4?jwt=eyJ...",
  "meetingUrl": "http://localhost:3000/meeting?room=demo-a1b2c3d4&jwt=eyJ...&baseUrl=https%3A%2F%2F103.115.236.34",
  "expiresAt": "2026-05-28T17:49:49.000Z",
  "debug": {
    "issuedAt": 1779988489,
    "expiresAt": 1779988789,
    "ttlSeconds": 300,
    "issuedAtISO": "2026-05-28T17:14:49.000Z"
  }
}
```

| Field | Description |
|-------|-------------|
| `meetingUrl` | Frontend page with countdown timer + forced hangup (use this) |
| `jitsiDirectUrl` | Direct Jitsi link without frontend enforcement (JWT still validated at connection) |
| `debug` | Timestamps for troubleshooting clock skew issues |

### Frontend Meeting Page (`/meeting`)

URL format: `/meeting?room={roomName}&jwt={token}&baseUrl={jitsiBaseUrl}`

Behavior:
1. Parses JWT payload to extract `exp` timestamp
2. Loads Jitsi's `external_api.js` from the Jitsi server
3. Embeds the meeting in a full-screen IFrame
4. Shows a countdown timer (top-right, turns red at 30s remaining)
5. At expiry: calls `api.executeCommand('hangup')`, disposes the IFrame, shows "Session Expired" screen
6. If page is opened after token already expired: immediately shows "Session Expired"

---

## Session Lifecycle

```
0:00 ─ User opens meetingUrl
       ├─ Frontend decodes JWT, starts countdown
       ├─ Jitsi IFrame loads, validates JWT with Prosody
       └─ User joins the room, video/audio active

4:30 ─ Countdown turns red (30s warning)

5:00 ─ Frontend calls api.executeCommand('hangup')
       ├─ All participants disconnected
       ├─ IFrame disposed
       └─ "Session Expired" screen shown

5:01 ─ Any reconnection attempt rejected by Prosody (JWT expired)
```

---

## Expiry Enforcement — Two Layers

| Layer | Mechanism | When it fires |
|-------|-----------|---------------|
| **Frontend** (primary) | Client-side countdown timer → `api.executeCommand('hangup')` | Exactly at expiry |
| **Jitsi/Prosody** (safety net) | JWT `exp` claim validated at WebSocket connection + room join | On any new connection or reconnection attempt after expiry |

**Important:** Jitsi does NOT re-validate the JWT during an active session. Media flows through JVB (UDP) without token checks. The frontend timer is the **primary enforcer** for mid-call termination.

---

## Setup Guide

### 1. Server-Side (one-time, on aiserver1)

The Jitsi Docker deployment is at `~/jitsi-meet/docker-jitsi-meet-stable-10978`.

Key `.env` settings for JWT auth:
```ini
AUTH_TYPE=jwt
ENABLE_AUTH=1
ENABLE_GUESTS=0
JWT_APP_ID=laas-platform
JWT_APP_SECRET=<shared secret>
```

After any auth config change:
```bash
docker compose down -v && docker compose up -d
sleep 15
# Verify:
docker compose exec prosody cat /config/conf.d/jitsi-meet.cfg.lua | grep -A5 "authentication\|app_id\|app_secret\|token_verification"
```

### 2. Backend Setup

```bash
cd backend-new
npm install   # jsonwebtoken + @types/jsonwebtoken already in package.json
# Ensure JITSI_* env vars are set in .env
npm run start:dev
```

### 3. Frontend Setup

```bash
cd frontend-new
npm run dev
```

The `/meeting` page is automatically available — no additional routing config needed (Next.js App Router).

---

## Critical Gotchas

### 1. `AUTH_TYPE=jwt` is required

`ENABLE_AUTH=1` alone enables **internal_hashed** (username/password) auth, NOT JWT. You must set `AUTH_TYPE=jwt` for token-based auth.

### 2. `docker compose down -v` (with `-v`) is required

Prosody's config is generated via Go templates at container creation and stored in Docker volumes. Without `-v`, volumes persist and old config remains. Always use `down -v` when changing auth settings.

### 3. `PUBLIC_URL` must NOT include a port

The Jitsi web client derives the XMPP WebSocket URL from `PUBLIC_URL`. If it includes a port (e.g., `:8443`), WebSocket connections fail because that port is blocked at the network level. Nginx proxies port 443 → 8443 internally.

### 4. JVB port must be in the 49152–65535 UDP range

The network firewall only allows UDP 49152–65535. The default JVB port (10000) is outside this range. We use `JVB_PORT=50000`.

### 5. Clock skew causes immediate "Token expired"

JWT `exp` is a Unix timestamp (UTC). If the backend machine's clock is behind the Jitsi server's clock, tokens appear expired immediately. Fix: `sudo timedatectl set-ntp true` on the server. The API response includes a `debug` block with timestamps to diagnose this.

### 6. Jitsi self-signed cert + nginx proxy

Jitsi's internal web container uses a self-signed cert (since `ENABLE_LETSENCRYPT=0`). The host nginx reverse proxy must use `proxy_ssl_verify off;` when forwarding to `https://127.0.0.1:8443`.

---

## Testing

Quick test with 60-second TTL:
```bash
curl -X POST http://localhost:3001/api/test/jitsi-link \
  -H "Content-Type: application/json" \
  -d '{"displayName":"Punith","ttlSeconds":60}'
```

Open the returned `meetingUrl` in a browser. Watch the countdown hit zero — the call should terminate automatically.

Verify Jitsi server health:
```bash
# On aiserver1
docker compose ps                                          # All 4 containers Up
docker compose exec prosody cat /config/conf.d/jitsi-meet.cfg.lua | grep "authentication"
# Expected: authentication = "token"
docker compose logs jvb | grep -i error                   # Should be clean
```
