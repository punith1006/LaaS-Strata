# Jitsi Meet — Self-Hosted Setup Guide for LaaS Mentoring

**Status:** Step-by-Step Setup Guide  
**Date:** 20 May 2026  
**Target Server:** Ubuntu 22.04+ (or any Linux with Docker)  
**Purpose:** Self-hosted video conferencing for LaaS Mentoring module

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Quick Start — Local Dev Testing (No Domain)](#2-quick-start--local-dev-testing-no-domain)
3. [Production Setup — With Domain + Let's Encrypt](#3-production-setup--with-domain--lets-encrypt)
4. [JWT Authentication Setup](#4-jwt-authentication-setup)
5. [How to Start & Join a Meeting](#5-how-to-start--join-a-meeting)
6. [LaaS Backend Integration](#6-laas-backend-integration)
7. [Frontend Embed Integration](#7-frontend-embed-integration)
8. [Management Commands](#8-management-commands)
9. [Troubleshooting](#9-troubleshooting)

---

## 1. Prerequisites

### Hardware Requirements

| Resource | Minimum | Recommended |
|----------|---------|-------------|
| CPU | 4 cores (dedicated) | 8+ cores |
| RAM | 4 GB | 8 GB |
| Disk | 20 GB | 50 GB SSD |
| Network | 1 Gbps | 1 Gbps (or faster) |

### Software Requirements

- **Docker** (v20.10+)
- **Docker Compose** (v2.0+)
- **Linux OS** (Ubuntu 22.04 LTS recommended)
- **Domain name** (for production / Let's Encrypt) — e.g., `meet.lambdacloud.in` or `meet.laas.local`
- **Open ports** on firewall: `80/tcp`, `443/tcp`, `10000/udp`

### Check Docker Installation

```bash
# Verify Docker is installed
docker --version
# Should output: Docker version 20.x.x or higher

# Verify Docker Compose is installed
docker compose version
# Should output: Docker Compose version v2.x.x or higher

# If Docker is not installed, install it:
sudo apt update
sudo apt install -y docker.io docker-compose-v2
sudo systemctl enable docker
sudo systemctl start docker

# Add your user to the docker group (so you don't need sudo for every command)
sudo usermod -aG docker $USER
# Log out and log back in for this to take effect
```

---

## 2. Quick Start — Local Dev Testing (No Domain)

This section is for **testing on your local machine** or a dev server **without a public domain**. It uses a self-signed certificate. Browsers will show a security warning — click "Advanced" → "Proceed to site."

### Step 1: Download Jitsi Docker Package

```bash
# Create a directory for Jitsi
mkdir -p ~/jitsi-meet && cd ~/jitsi-meet

# Download the latest stable release
# DO NOT clone the git repo for production — download the release ZIP instead
wget $(wget -q -O - https://api.github.com/repos/jitsi/docker-jitsi-meet/releases/latest | grep zip | cut -d\" -f4)

# Unzip the package
unzip stable-*.zip
cd stable-*   # or whatever folder was extracted

# You should see files like:
# docker-compose.yml  env.example  gen-passwords.sh  jibri.yml  jigasi.yml  etc.
```

### Step 2: Configure Environment

```bash
# Copy the example env file
cp env.example .env

# Generate strong passwords (this modifies .env with random passwords)
./gen-passwords.sh
```

### Step 3: Edit the .env file

Open `.env` in your text editor and set these values:

```bash
# === REQUIRED SETTINGS ===

# Public URL — for LOCAL testing without a domain, 
# use your server's IP address or localhost
# Example for local machine testing:
PUBLIC_URL=https://localhost:8443

# Example for LAN server testing:
# PUBLIC_URL=https://192.168.1.100:8443

# HTTP/HTTPS ports (for local testing, use non-standard ports to avoid conflicts)
HTTP_PORT=8000
HTTPS_PORT=8443

# Timezone
TZ=Asia/Kolkata

# === JWT AUTHENTICATION (for mentoring integration) ===
# Set these now — we'll use them in Section 4

ENABLE_AUTH=1
ENABLE_GUESTS=0

# JWT Auth settings — generate your own secret
# Run: openssl rand -hex 32
JWT_APP_ID=laas-platform
JWT_APP_SECRET=  # <-- GENERATE WITH: openssl rand -hex 32

# === OPTIONAL: Let's Encrypt (PRODUCTION ONLY) ===
# Leave DISABLED for local testing
ENABLE_LETSENCRYPT=0
# LETSENCRYPT_DOMAIN=meet.yourdomain.com   # Leave commented out
# LETSENCRYPT_EMAIL=admin@yourdomain.com   # Leave commented out

# === ETHERPAD (collaborative document editing) ===
# Optional — enables collaborative notes during meetings
# ENABLE_ETHERPAD=1
# ETHERPAD_URL_BASE=https://etherpad.yourdomain.com

# === WHITEBOARD ===
# Optional — enables Excalidraw whiteboard
# ENABLE_WHITEBOARD=1
```

### Step 4: Create Config Directories

```bash
# On Linux:
mkdir -p ~/.jitsi-meet-cfg/{web,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

# On Windows (PowerShell):
# New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.jitsi-meet-cfg\web"
# New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.jitsi-meet-cfg\transcripts"
# New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.jitsi-meet-cfg\prosody\config"
# New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.jitsi-meet-cfg\prosody\prosody-plugins-custom"
# New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.jitsi-meet-cfg\jicofo"
# New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.jitsi-meet-cfg\jvb"
# New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.jitsi-meet-cfg\jigasi"
# New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.jitsi-meet-cfg\jibri"
```

### Step 5: Start Jitsi

```bash
# Start all containers in detached mode
docker compose up -d

# Check if all containers are running
docker compose ps

# You should see these containers running:
# jitsi-web      (Up)
# jitsi-prosody  (Up)
# jitsi-jicofo   (Up)
# jitsi-jvb      (Up)
```

### Step 6: Access the Web UI

Open your browser and go to:

```
https://localhost:8443
```

**Important:** Since you're using a self-signed certificate:
- Chrome: Click "Advanced" → "Proceed to localhost (unsafe)"
- Firefox: Click "Advanced..." → "Accept the Risk and Continue"

If you see the Jitsi Meet welcome page with a "Start a new meeting" input field — **success!**

---

## 3. Production Setup — With Domain + Let's Encrypt

For production use, you need a real domain and a valid SSL certificate.

### Step 1: DNS Setup

Create an A record pointing to your server's IP:

```
meet.lambdacloud.in   →   A   →   YOUR_SERVER_IP
```

Or if you're using a subdomain on your existing infrastructure:

```
meet.laas.local   →   A   →   YOUR_INTERNAL_IP
```

### Step 2: Open Firewall Ports

```bash
# On Ubuntu with ufw:
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 10000/udp
sudo ufw reload

# Verify:
sudo ufw status
```

### Step 3: Follow Quick Start Steps 1-3 from Section 2

But in Step 3, set these `.env` values instead:

```bash
# === PRODUCTION SETTINGS ===

# Public URL — use your real domain
PUBLIC_URL=https://meet.lambdacloud.in

# Use standard ports
HTTP_PORT=80
HTTPS_PORT=443

# Enable HTTP → HTTPS redirect
ENABLE_HTTP_REDIRECT=1

# Enable Let's Encrypt (free SSL certificate)
ENABLE_LETSENCRYPT=1
LETSENCRYPT_DOMAIN=meet.lambdacloud.in
LETSENCRYPT_EMAIL=admin@gktech.ai

# Timezone
TZ=Asia/Kolkata

# JWT Auth
ENABLE_AUTH=1
ENABLE_GUESTS=0
JWT_APP_ID=laas-platform
JWT_APP_SECRET=  # <-- run: openssl rand -hex 32

# Whiteboard (optional)
ENABLE_WHITEBOARD=1
```

### Step 4: Create config dirs, start, and verify

```bash
mkdir -p ~/.jitsi-meet-cfg/{web,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}
docker compose up -d
docker compose ps
```

Wait 2-3 minutes for Let's Encrypt to issue the certificate. Check logs:

```bash
docker compose logs -f web | grep -i "letsencrypt\|cert"
```

Then visit `https://meet.lambdacloud.in` — you should see the Jitsi Meet interface with a valid SSL padlock.

---

## 4. JWT Authentication Setup

JWT (JSON Web Token) authentication ensures that only authorized users (the mentor and student for a specific booking) can join a meeting room.

### Step 1: Generate JWT Secret

```bash
# Generate a strong random secret
openssl rand -hex 32
# Example output: a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2

# Copy this value and paste it into .env:
JWT_APP_SECRET=a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2
```

### Step 2: Enable JWT in .env

Make sure your `.env` has:

```bash
ENABLE_AUTH=1
ENABLE_GUESTS=0
JWT_APP_ID=laas-platform
JWT_APP_SECRET=<the-secret-you-generated>
```

### Step 3: Restart Jitsi

```bash
docker compose down
docker compose up -d
```

### Step 4: Test JWT Auth

Create a test token and try joining a room:

```bash
# Install a JWT tool for testing (node.js)
# or use jwt.io website to generate tokens

# Test with curl — generate a token first:
# Visit: https://jwt.io/
# Header: { "alg": "HS256", "typ": "JWT" }
# Payload: {
#   "context": {
#     "user": { "id": "test-user", "name": "Test Mentor" }
#   },
#   "aud": "jitsi",
#   "iss": "laas-platform",
#   "sub": "meet.lambdacloud.in",
#   "room": "test-room-123"
# }
# Secret: <your-JWT_APP_SECRET>
```

Then visit:

```
https://meet.lambdacloud.in/test-room-123?jwt=YOUR_GENERATED_TOKEN
```

If JWT is working correctly, you'll join the room. If JWT is rejected, you'll see an error message.

### Step 5: How JWT Works with LaaS

When a student books a mentoring session:

1. LaaS backend generates a unique room name: `laas-mentor-{bookingId}`
2. Backend generates a JWT token using the shared `JWT_APP_SECRET`
3. Token includes: `room` (the specific room), `context.user` (who is joining), expiry time
4. Frontend embeds the Jitsi iframe with the JWT in the URL
5. Jitsi validates the JWT before allowing entry
6. Without a valid JWT, the room cannot be joined

**This means:** Even if someone guesses the room name, they can't join without a valid token signed by your platform.

---

## 5. How to Start & Join a Meeting

### Method 1: Web UI (Testing)

1. Go to `https://localhost:8443` (dev) or `https://meet.lambdacloud.in` (production)
2. Type a meeting name in the input box (e.g., `test-session-001`)
3. Press Enter or click "Start meeting"
4. Grant camera & microphone permissions when prompted
5. **You are now in a video call**

To invite someone else:
- Copy the URL from the address bar
- Send it to the other person
- They paste it in their browser and join

### Method 2: Direct URL (Programmatic)

Simply navigate to:

```
https://meet.lambdacloud.in/ROOM_NAME
```

Where `ROOM_NAME` is any string. Jitsi creates the room automatically.

With JWT:

```
https://meet.lambdacloud.in/ROOM_NAME?jwt=YOUR_JWT_TOKEN
```

### Method 3: LaaS Platform (Embedded)

The mentoring page will embed Jitsi in an iframe (see Section 7).

---

## 6. LaaS Backend Integration

### 6.1 Add JWT Secret to Backend .env

In `backend-new/.env`:

```bash
# Jitsi Meet Configuration
JITSI_URL=https://meet.lambdacloud.in
JITSI_JWT_SECRET=a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2
JITSI_JWT_APP_ID=laas-platform
```

### 6.2 Install jsonwebtoken Package

```bash
cd backend-new
npm install jsonwebtoken
npm install --save-dev @types/jsonwebtoken
```

### 6.3 Create Jitsi Service

File: `backend-new/src/mentoring/jitsi.service.ts`

```typescript
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as jwt from 'jsonwebtoken';

interface JitsiTokenPayload {
  userId: string;
  userName: string;
  userAvatar?: string;
  roomName: string;
  isModerator: boolean;
}

@Injectable()
export class JitsiService {
  constructor(private configService: ConfigService) {}

  /**
   * Generate a JWT token for a Jitsi Meet room.
   * Only users with this token can join the specified room.
   */
  generateToken(payload: JitsiTokenPayload): string {
    const secret = this.configService.get<string>('JITSI_JWT_SECRET');
    const appId = this.configService.get<string>('JITSI_JWT_APP_ID');

    const jwtPayload = {
      context: {
        user: {
          id: payload.userId,
          name: payload.userName,
          avatar: payload.userAvatar || '',
        },
        // isModerator controls who has host privileges in the meeting
        moderator: payload.isModerator ? 'true' : 'false',
      },
      aud: 'jitsi',
      iss: appId,
      sub: this.configService.get<string>('JITSI_URL'),
      room: payload.roomName,
      exp: Math.floor(Date.now() / 1000) + 7200, // 2 hours
    };

    return jwt.sign(jwtPayload, secret, { algorithm: 'HS256' });
  }

  /**
   * Generate a unique room name for a mentoring session.
   */
  generateRoomName(bookingId: string): string {
    return `laas-mentor-${bookingId}`;
  }

  /**
   * Build the full meeting URL with JWT embedded.
   */
  getMeetingUrl(bookingId: string, token: string): string {
    const baseUrl = this.configService.get<string>('JITSI_URL');
    const roomName = this.generateRoomName(bookingId);
    return `${baseUrl}/${roomName}?jwt=${token}`;
  }
}
```

### 6.4 Use in Booking Service

In your `mentor-booking.service.ts`, when a booking is confirmed:

```typescript
// After creating the booking record:

// Generate Jitsi room
const roomName = this.jitsiService.generateRoomName(booking.id);

// Generate tokens for both parties
const mentorToken = this.jitsiService.generateToken({
  userId: mentor.id,
  userName: mentor.fullName,
  roomName,
  isModerator: true,  // Mentor is the host
});

const studentToken = this.jitsiService.generateToken({
  userId: student.id,
  userName: student.fullName,
  roomName,
  isModerator: false,
});

const mentorMeetingUrl = this.jitsiService.getMeetingUrl(booking.id, mentorToken);
const studentMeetingUrl = this.jitsiService.getMeetingUrl(booking.id, studentToken);

// Store meeting URLs on the booking
await this.prisma.mentorBooking.update({
  where: { id: booking.id },
  data: {
    meetingUrl: mentorMeetingUrl,  // or store both separately
    // You may want separate fields: mentorMeetingUrl, studentMeetingUrl
  },
});

// Return URLs in the response
return {
  ...booking,
  meetingUrl: studentMeetingUrl,  // student-facing
};
```

---

## 7. Frontend Embed Integration

### 7.1 Video Session Component

File: `frontend-new/src/components/mentoring/video-session.tsx`

```tsx
"use client";

import { useEffect, useRef, useState } from "react";

interface JitsiSessionProps {
  meetingUrl: string;  // Full URL with JWT token
  onSessionEnd?: () => void;
}

export default function VideoSession({ meetingUrl, onSessionEnd }: JitsiSessionProps) {
  const iframeRef = useRef<HTMLIFrameElement>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!meetingUrl) {
      setError("No meeting URL provided");
      return;
    }
    setIsLoading(false);
  }, [meetingUrl]);

  if (error) {
    return (
      <div style={{ 
        display: "flex", 
        alignItems: "center", 
        justifyContent: "center", 
        height: "100%",
        color: "var(--fgColor-muted)",
        fontSize: "0.875rem"
      }}>
        {error}
      </div>
    );
  }

  if (isLoading) {
    return (
      <div style={{ 
        display: "flex", 
        alignItems: "center", 
        justifyContent: "center", 
        height: "100%",
        color: "var(--fgColor-muted)"
      }}>
        Loading video session...
      </div>
    );
  }

  return (
    <div style={{ width: "100%", height: "100%" }}>
      <iframe
        ref={iframeRef}
        src={meetingUrl}
        allow="camera; microphone; fullscreen; display-capture; autoplay"
        style={{
          width: "100%",
          height: "100%",
          border: "none",
          borderRadius: "4px",
        }}
        title="Mentoring Session"
        sandbox="allow-scripts allow-same-origin allow-forms allow-popups allow-modals"
      />
    </div>
  );
}
```

### 7.2 Booking Detail Page

File: `frontend-new/src/app/(console)/mentoring/bookings/[bookingId]/page.tsx`

```tsx
"use client";

import { useEffect, useState } from "react";
import { getAccessToken } from "@/lib/token";
import VideoSession from "@/components/mentoring/video-session";

const API_BASE = process.env.NEXT_PUBLIC_API_URL || "";

export default function BookingDetailPage({ params }: { params: { bookingId: string } }) {
  const [booking, setBooking] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchBooking = async () => {
      const token = getAccessToken();
      if (!token) return;

      try {
        const res = await fetch(
          `${API_BASE}/api/mentoring/bookings/${params.bookingId}`,
          { headers: { Authorization: `Bearer ${token}` } }
        );
        if (res.ok) {
          const data = await res.json();
          setBooking(data);
        }
      } catch (err) {
        console.error("Failed to fetch booking:", err);
      } finally {
        setLoading(false);
      }
    };

    fetchBooking();
  }, [params.bookingId]);

  if (loading) return <div>Loading...</div>;
  if (!booking) return <div>Booking not found</div>;

  const canJoin = booking.status === "scheduled" || booking.status === "in_progress";

  return (
    <div style={{ padding: "24px", height: "100%" }}>
      <h1 style={{ color: "var(--fgColor-default)", fontSize: "1.5rem", marginBottom: "16px" }}>
        Session: {booking.mentor?.fullName || "Mentoring Session"}
      </h1>
      
      <div style={{ 
        display: "flex", 
        gap: "16px", 
        marginBottom: "16px",
        fontSize: "0.875rem",
        color: "var(--fgColor-muted)" 
      }}>
        <span>Date: {new Date(booking.scheduledAt).toLocaleDateString()}</span>
        <span>Time: {new Date(booking.scheduledAt).toLocaleTimeString()}</span>
        <span>Duration: {booking.durationMinutes} min</span>
        <span>Status: {booking.status}</span>
      </div>

      {canJoin && booking.meetingUrl ? (
        <div style={{ height: "calc(100% - 120px)", minHeight: "400px" }}>
          <VideoSession meetingUrl={booking.meetingUrl} />
        </div>
      ) : (
        <div style={{ 
          padding: "48px", 
          textAlign: "center",
          color: "var(--fgColor-muted)" 
        }}>
          {booking.status === "completed" 
            ? "This session has ended." 
            : "The meeting link is not available yet. Please check back closer to the session time."}
        </div>
      )}
    </div>
  );
}
```

---

## 8. Management Commands

### Start / Stop / Restart

```bash
cd ~/jitsi-meet/stable-*/

# Start Jitsi
docker compose up -d

# Stop Jitsi
docker compose down

# Restart Jitsi
docker compose restart

# View logs for all containers
docker compose logs -f

# View logs for a specific container
docker compose logs -f web
docker compose logs -f jvb
```

### Update to Latest Version

```bash
cd ~/jitsi-meet

# Download latest release
wget $(wget -q -O - https://api.github.com/repos/jitsi/docker-jitsi-meet/releases/latest | grep zip | cut -d\" -f4)

# Unzip and overwrite when prompted
unzip -o stable-*.zip
cd stable-*

# Your .env file should be preserved; verify it's still there
cat .env | head -5

# Recreate containers
docker compose down
docker compose up -d
```

### Monitor Resource Usage

```bash
# Check container resource usage
docker stats

# Check disk usage of Jitsi config
du -sh ~/.jitsi-meet-cfg/

# Check if ports are open
sudo ss -tlnp | grep -E '80|443|10000'
```

---

## 9. Troubleshooting

### Problem: "Failed to access your microphone/camera"

**Cause:** You're accessing Jitsi via HTTP instead of HTTPS. WebRTC (which powers video/audio) requires HTTPS.

**Fix:**
- Make sure you're using `https://` in the URL
- For local testing, accept the self-signed certificate warning
- For production, verify Let's Encrypt certificate is valid

### Problem: "Cannot read property 'getUserMedia' of undefined"

**Cause:** Browser can't access media devices, usually because the page isn't served over HTTPS.

**Fix:** Same as above — use HTTPS. WebRTC is blocked on HTTP for security reasons.

### Problem: Containers won't start

```bash
# Check logs for errors
docker compose logs

# Common issues:
# 1. Port already in use → change HTTP_PORT/HTTPS_PORT in .env
# 2. Missing passwords → run ./gen-passwords.sh
# 3. Missing config directories → run mkdir commands from Step 4
```

### Problem: Let's Encrypt certificate fails

```bash
# Check Let's Encrypt logs
docker compose logs web | grep letsencrypt

# Common issues:
# 1. Domain doesn't point to your server IP → fix DNS
# 2. Port 80/443 blocked by firewall → open ports
# 3. Rate limit exceeded → wait 7 days, or use staging first:
#    Add to .env: LETSENCRYPT_USE_STAGING=1
```

### Problem: JWT token rejected

```bash
# Check if JWT is enabled
grep ENABLE_AUTH .env
# Should output: ENABLE_AUTH=1

# Verify JWT secret matches
echo "Your JWT_APP_SECRET is:"
grep JWT_APP_SECRET .env

# Generate a test token using the Node.js script:
node -e "
const jwt = require('jsonwebtoken');
const secret = 'YOUR_SECRET_HERE';
const token = jwt.sign({
  context: { user: { id: 'test', name: 'Test' } },
  aud: 'jitsi',
  iss: 'laas-platform',
  sub: 'meet.lambdacloud.in',
  room: 'test-room-1'
}, secret, { algorithm: 'HS256', expiresIn: '2h' });
console.log(token);
"
```

### Problem: Users can't see/hear each other

**Cause:** UDP port 10000 is blocked or JVB can't advertise its IP.

**Fix:**
```bash
# Check if port 10000/udp is open
sudo ufw status | grep 10000

# If Jitsi is behind NAT, add to .env:
# JVB_ADVERTISE_IPS=YOUR_PUBLIC_IP
```

### Problem: "Session time limit" warning

**Cause:** Default Jitsi config has a time limit.

**Fix:** This is configurable in the Jitsi web config. For self-hosted, the limit can be removed:

```bash
# In ~/.jitsi-meet-cfg/web/config.js, add:
# config.enableAutomaticUrlCopy = false;
# There is no built-in time limit in self-hosted Jitsi.
# If you see a limit, it's from the JaaS (cloud) version, not self-hosted.
```

---

## Quick Reference Card

```
┌──────────────────────────────────────────────┐
│           JITSI MEET QUICK REFERENCE          │
├──────────────────────────────────────────────┤
│ INSTALL:                                      │
│   cd ~/jitsi-meet                             │
│   wget (latest release zip)                   │
│   unzip stable-*.zip && cd stable-*           │
│   cp env.example .env                         │
│   ./gen-passwords.sh                          │
│   mkdir -p ~/.jitsi-meet-cfg/{web,...}        │
│   docker compose up -d                         │
├──────────────────────────────────────────────┤
│ ACCESS:                                       │
│   Local:  https://localhost:8443              │
│   Prod:   https://meet.lambdacloud.in         │
├──────────────────────────────────────────────┤
│ START MEETING:                                │
│   https://meet.lambdacloud.in/ROOM_NAME       │
├──────────────────────────────────────────────┤
│ JWT MEETING:                                  │
│   https://meet.lambdacloud.in/ROOM_NAME       │
│        ?jwt=YOUR_GENERATED_TOKEN              │
├──────────────────────────────────────────────┤
│ LAAAS ROOM FORMAT:                            │
│   laas-mentor-{bookingId}                     │
├──────────────────────────────────────────────┤
│ MANAGE:                                       │
│   docker compose ps       (status)            │
│   docker compose logs -f  (logs)              │
│   docker compose down     (stop)              │
│   docker compose up -d    (start)             │
│   docker compose restart  (restart)           │
└──────────────────────────────────────────────┘
```

---

*Guide prepared for LaaS Mentoring Module — Jitsi Meet Self-Hosted Setup.*
*Last updated: 20 May 2026*
