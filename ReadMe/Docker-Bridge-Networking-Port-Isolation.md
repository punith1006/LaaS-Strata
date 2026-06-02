# Docker Bridge Networking & Port Isolation in LaaS

## Overview

Each user compute instance runs as a Docker container on a **custom bridge network** (`laas-sessions`). This provides full network isolation between containers while allowing outbound internet access via Docker NAT.

## How Port Allocation Works

The orchestrator (`session-orchestration/app.py`) manages port allocation:

- **Host port range:** `8100 - 8199` (nginx proxy)
- **Fixed container internal ports:**
  - `8080` -- nginx (WebRTC proxy)
  - `9080` -- Selkies (streaming encoder)
  - `19080` -- metrics
- **Port mapping:** Host port `8101` is published to container's internal `8080`

The `allocate_port()` function scans the range, skips reserved infrastructure ports (Grafana 3000, Loki 3100, etc.), and picks the first available one by inspecting running containers.

## Network Architecture

```
Host Machine (ai1 / ai2)
├── eth0 / enp10s0  (external network)
├── docker0 / br-xxx (Docker bridge)
│   └── laas-sessions (custom bridge network)
│       ├── Container A  (user session)
│       │   ├── port 8080  ← mapped to host :8101
│       │   ├── port 9080  (internal only)
│       │   └── port 19080 ← mapped to host :19101
│       └── Container B  (another user session)
│           ├── port 8080  ← mapped to host :8102
│           ├── port 9080  (internal only)
│           └── port 19080 ← mapped to host :19102
└── Host services (NestJS, Keycloak, PostgreSQL, etc.)
```

## Key Behaviors

### 1. Port Space Isolation

Each container has its own **network namespace**. Port 8100 inside Container A is completely independent from port 8100 on the host or in Container B. They are different network namespaces -- no collision possible.

- Container A binds `0.0.0.0:8100` -> works
- Container B binds `0.0.0.0:8100` -> works
- Host port 8100 (allocated by orchestrator for nginx) is independent -> no conflict

### 2. Inter-Container Communication

Containers on the same `laas-sessions` bridge network can reach each other by container name or IP:

```
Container A → http://container-b:8080  (reachable)
Container B → http://container-a:8100  (if service running)
```

### 3. Host-to-Container Reachability

Only **explicitly published ports** are reachable from the host or internet:
- `-p 8101:8080` (nginx)
- `-p 19101:19080` (metrics)

Any port a user starts inside their container (e.g., a Jupyter notebook on 8888) is **not reachable** from outside unless explicitly published.

### 4. Internet Access

Containers have outbound internet access via Docker NAT (through `--dns 8.8.8.8`), allowing `apt install`, `pip install`, git clone, etc.

## Common Questions

**Q: Will my app on port X clash with another user's same port?**
No. Every container has its own network stack. Two users running on port 8888 is fine.

**Q: Can I access services on the host machine (localhost)?**
Not by default in bridge mode. The host's `localhost` is not reachable from inside a bridge container. Use the host's external or management IP instead.

**Q: How do I expose a port I started inside the container?**
It's not exposed automatically. The orchestrator would need to add a port mapping. For dev use, you can start the container with `--network=host` to bypass isolation (but this is not done in production).

## Reserved Host Ports

These ports on the host must never be assigned to containers:

| Port | Service |
|------|---------|
| 3000 | Grafana |
| 3001 | Uptime Kuma |
| 3100 | Loki |
| 8080 | cAdvisor |
| 9998 | session-orchestration |
| 9999 | storage-provision |
