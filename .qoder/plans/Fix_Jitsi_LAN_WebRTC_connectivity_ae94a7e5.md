# Fix Jitsi LAN WebRTC Connectivity

## Root Cause

JVB is discovering a public IP `49.204.79.126` via STUN (default Jitsi config). This IP is the NAT gateway of your network and is NOT routable from within the LAN. Browsers on LAN devices try this IP and fail.

## Fix Steps

### Step 1: Edit .env

File: `~/jitsi-meet/jitsi-docker-jitsi-meet-6e64f72/.env`

**Remove the default STUN servers** (they discover the public IP):

```ini
# Remove or comment out:
# JVB_STUN_SERVERS=

# Or set to empty to disable:
JVB_STUN_SERVERS=
```

**Keep the static LAN mapping:**

```ini
JVB_ADVERTISE_IPS=192.168.10.99
```

**Add the Docker host IP to help JVB bind correctly:**

```ini
DOCKER_HOST_ADDRESS=192.168.10.99
```

### Step 2: Create custom web config

Create file: `~/.jitsi-meet-cfg/web/custom-config.js`

```javascript
/* eslint-disable no-var */
var config = {
    p2p: {
        enabled: false
    },
    // Disable any external STUN lookup from the browser side
    // Use the existing coturn TURN server as relay fallback
    turnservers: [
        {
            urls: 'turn:192.168.10.99:3478',
            username: 'selkies',
            credential: 'selkies'
        }
    ]
};
```

### Step 3: Restart everything

```bash
cd ~/jitsi-meet/jitsi-docker-jitsi-meet-6e64f72
docker compose down
docker compose up -d
```

### Step 4: Verify

Wait 30s, then check logs to confirm STUN discovery is gone:

```bash
docker compose logs jvb | grep -i "stun\|harvest\|public.ip"
```

You should see ONLY `192.168.10.99` — no external public IP.

Then test at `https://192.168.10.99:8443`.
