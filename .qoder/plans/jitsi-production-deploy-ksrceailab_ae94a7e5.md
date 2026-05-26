# Jitsi Production Deployment on ksrceailab.com

## Server Profile (aiserver1)

| Item | Detail |
|------|--------|
| OS | Ubuntu 22.04.5 LTS (Jammy), kernel 6.8.0-111 |
| RAM | 60 GB |
| Disk | 853 GB NVMe, 666 GB free |
| Public IP | `103.115.236.34` (NAT/routing) |
| Internal IP | `20.1.1.130/16` |
| DNS | `ksrceailab.com` (Let's Encrypt SSL via Certbot) |
| TURN/STUN | coturn on port `3478` (user: `selkies`, realm: `selkies`) |
| Nginx | Reverse proxy on `80`/`443` for Keycloak, backend API, Next.js frontend |

### Network Port Constraints

Only these ports are open at the network level:

| Port | Protocol | Purpose |
|------|----------|---------|
| 80, 443 | TCP | Web traffic (nginx) |
| 3478 | TCP/UDP | STUN/TURN |
| 8100–8200 | TCP | GPU instance desktops |
| 19100–19200 | TCP | Instance metrics |
| 49152–65535 | UDP | WebRTC media relay |
| 2223 | TCP | SSH management |

**Critical**: Port `8443` (Jitsi's default HTTPS) is **NOT** open. Port `10000/udp` (JVB default) is **NOT** open. All traffic must flow through port `443` (nginx). JVB media must use a port within `49152–65535`.

---

## Task 1: Server Survey (pre-deployment)

```bash
# Check listening ports
ss -tulnp | grep -E ":(80|443|3478|5222|5280|5347|8080|8443|10000) "

# Check Docker containers
docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"

# Check nginx config
ls -la /etc/nginx/sites-enabled/ /etc/nginx/conf.d/

# Check TURN server
systemctl status coturn
cat /etc/turnserver.conf

# Check OS resources
free -h && df -h / && uname -a
```

---

## Task 2: Download Jitsi Docker Compose

```bash
cd ~
mkdir -p jitsi-meet && cd jitsi-meet
wget -O jitsi.zip https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-10978.zip
unzip jitsi.zip
# Directory will be: docker-jitsi-meet-stable-10978
cd docker-jitsi-meet-stable-10978
cp env.example .env
./gen-passwords.sh
```

---

## Task 3: Configure .env

Generate a JWT secret:
```bash
echo "JWT_APP_SECRET=$(openssl rand -hex 32)" >> .env
```

Full `.env` configuration (working values):

```ini
# ---- Public URL (CRITICAL: no port — nginx handles 443) ----
PUBLIC_URL=https://103.115.236.34

# ---- Internal ports (avoid conflict with host nginx on 80/443) ----
HTTP_PORT=8000
HTTPS_PORT=8443

# ---- Timezone ----
TZ=Asia/Kolkata

# ---- Auth (disabled for initial testing; enable for production) ----
ENABLE_AUTH=0
ENABLE_GUESTS=1
JWT_APP_ID=laas-platform
JWT_APP_SECRET=<generated hex>

# ---- Let's Encrypt (disabled — host nginx handles SSL) ----
ENABLE_LETSENCRYPT=0

# ---- JVB WebRTC networking ----
JVB_ADVERTISE_IPS=103.115.236.34
DOCKER_HOST_ADDRESS=20.1.1.130

# ---- JVB port (MUST be 50000 — within allowed 49152-65535 range) ----
JVB_PORT=50000

# ---- TURN (use existing coturn; STUN disabled since public IP) ----
JVB_STUN_SERVERS=
TURN_SERVERS=turn:103.115.236.34:3478?transport=udp
TURN_USERNAME=selkies
TURN_CREDENTIAL=wVIAbfwkgkxjaCiZVX4BDsdU

# ---- XMPP domain ----
XMPP_DOMAIN=meet.jitsi
```

---

## Task 4: Configure docker-compose.yml

**No changes needed.** The default docker-compose.yml already uses `.env` variables for ports:

```yaml
# web service (line 8-10):
ports:
    - '${HTTP_PORT}:80'      # becomes 8000:80
    - '${HTTPS_PORT}:443'    # becomes 8443:443

# jvb service (line 456-458):
ports:
    - '${JVB_PORT:-10000}:${JVB_PORT:-10000}/udp'   # becomes 50000:50000/udp
    - '127.0.0.1:${JVB_COLIBRI_PORT:-8080}:8080'
```

---

## Task 5: DNS — [DEFERRED] Add A record for meet.ksrceailab.com

When ready for production domain:
- Add DNS A record: `meet.ksrceailab.com` → `103.115.236.34`
- Then create nginx server block for the domain (see Task 6b)
- Update `PUBLIC_URL` to `https://meet.ksrceailab.com`
- Run `docker compose down && docker compose up -d`

---

## Task 6a: Host Nginx Reverse Proxy (IP-based, for testing)

Since port `8443` is blocked at network level, route through port `443` via host nginx.

Create `/etc/nginx/sites-available/jitsi-ip-proxy`:

```nginx
server {
    listen 443 ssl;
    server_name 103.115.236.34;

    ssl_certificate /etc/letsencrypt/live/ksrceailab.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ksrceailab.com/privkey.pem;

    location / {
        proxy_pass https://127.0.0.1:8443;
        proxy_ssl_verify off;    # Jitsi uses self-signed cert
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}
```

Enable and start nginx:

```bash
sudo ln -sf /etc/nginx/sites-available/jitsi-ip-proxy /etc/nginx/sites-enabled/jitsi-ip-proxy
sudo nginx -t
sudo systemctl start nginx
sudo systemctl enable nginx
```

> ⚠️ **Warning**: Nginx may **not** be running by default. Use `systemctl start` (not just `reload`).

> ⚠️ **Browser warning**: The Let's Encrypt cert is for `ksrceailab.com`, not the IP. You'll get a hostname mismatch warning — click **Advanced → Proceed anyway**.

---

## Task 6b: Host Nginx Reverse Proxy (domain-based, for production)

When DNS is ready, create `/etc/nginx/sites-available/meet.ksrceailab`:

```nginx
server {
    listen 80;
    server_name meet.ksrceailab.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name meet.ksrceailab.com;

    ssl_certificate /etc/letsencrypt/live/ksrceailab.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ksrceailab.com/privkey.pem;

    location / {
        proxy_pass https://127.0.0.1:8443;
        proxy_ssl_verify off;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}
```

Then expand the Let's Encrypt cert and enable:

```bash
sudo certbot --nginx -d ksrceailab.com,www.ksrceailab.com,meet.ksrceailab.com
sudo ln -sf /etc/nginx/sites-available/meet.ksrceailab /etc/nginx/sites-enabled/meet.ksrceailab
sudo nginx -t && sudo systemctl reload nginx
```

Then update `.env`:

```bash
sed -i 's|PUBLIC_URL=https://103.115.236.34|PUBLIC_URL=https://meet.ksrceailab.com|' .env
docker compose down && docker compose up -d
```

---

## Task 7: Start Jitsi

```bash
cd ~/jitsi-meet/docker-jitsi-meet-stable-10978
docker compose up -d

# Wait 30s, then verify all 4 containers:
docker compose ps
# Expected: web, prosody, jicofo, jvb — all "Up"

# Verify JVB listening on correct port:
ss -tuln | grep 50000
# Expected: udp UNCONN 0 0 0.0.0.0:50000 ...
```

Test: browse `https://103.115.236.34` (accept cert warning), type a room name, click **Join meeting**. Open F12 → Console to verify no WebSocket or XMPP errors.

---

## Important Considerations & Gotchas

### 1. `PUBLIC_URL` must NOT include port when behind nginx

The Jitsi web client derives the XMPP WebSocket URL from `PUBLIC_URL`. If `PUBLIC_URL=https://103.115.236.34:8443`, the client connects to `wss://103.115.236.34:8443/xmpp-websocket` — which is **blocked** at network level. With `PUBLIC_URL=https://103.115.236.34` (no port), it uses `wss://103.115.236.34/xmpp-websocket` on port `443` through nginx.

### 2. JVB port must fit within allowed range

The network only allows UDP `49152–65535` for WebRTC media. Default JVB port `10000` is **outside** this range. Set `JVB_PORT=50000` in `.env`.

### 3. Auth changes require full `down` + `up`

Changing `ENABLE_AUTH` or `ENABLE_GUESTS` requires `docker compose down && docker compose up -d` — a simple `restart` is NOT sufficient. Prosody's config is generated at container startup and persists across restarts.

Error symptom with stale auth: `x-strophe-bad-non-anon-jid` in browser console, login prompt appears.

### 4. Nginx may not be running

Always check `systemctl status nginx` before assuming nginx is active. Use `systemctl start nginx` (not `reload`) if the service is inactive.

### 5. Docker Compose ports already use .env variables

The default docker-compose.yml references `${HTTP_PORT}`, `${HTTPS_PORT}`, and `${JVB_PORT}` — no YAML edits needed. Just set values in `.env`.

### 6. Proxy to Jitsi's self-signed HTTPS

Jitsi's web nginx uses a self-signed cert (since `ENABLE_LETSENCRYPT=0`). The host nginx must use `proxy_ssl_verify off;` when forwarding to `https://127.0.0.1:8443`.

### 7. WebSocket upgrade headers are essential

The host nginx must pass `Upgrade` and `Connection` headers for XMPP WebSocket connections to work. Without them, you get connection failures.

---

## Authentication: Enabling JWT for Production

When ready for production security:

```bash
cd ~/jitsi-meet/docker-jitsi-meet-stable-10978
```

Update `.env`:
```ini
ENABLE_AUTH=1
ENABLE_GUESTS=0
```

Then full recreate:
```bash
docker compose down && docker compose up -d
```

The backend generates JWTs signed with `JWT_APP_SECRET`. The frontend passes the JWT as a query parameter when creating/joining rooms. See the [Jitsi Meet Self-Hosting Setup Guide](Jitsi_Meet_Setup_Guide_ae94a7e5.md) for backend integration details.

---

## Testing Checklist

- [ ] Jitsi page loads at `https://103.115.236.34`
- [ ] Can type a room name and see prejoin screen
- [ ] Camera/mic permissions work
- [ ] "Join meeting" button is **not** grey — clicking joins successfully
- [ ] F12 Console shows `Using service URL wss://103.115.236.34/xmpp-websocket` (port 443, not 8443)
- [ ] No `x-strophe-bad-non-anon-jid` errors
- [ ] Video/audio flows between two browser tabs
- [ ] `docker compose logs jvb | grep -i error` is clean
