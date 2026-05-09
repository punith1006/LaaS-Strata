# Architecture: Container Networking & User API Exposure

## 1. The Problem
When a user provisions a GPU instance on LaaS, they receive a containerized desktop environment (Selkies). Currently, the Session Orchestration service launches these containers using Docker's `bridge` network mode. 

In bridge mode, containers are isolated inside their own private network namespaces. They cannot communicate with each other or the host, and the host does not expose their internal ports to the outside world unless explicitly instructed.

Right now, we explicitly map exactly two ports to the host:
- **Desktop UI**: Host Port `810X` ➔ Container Internal Port `8080`
- **Metrics**: Host Port `1910X` ➔ Container Internal Port `19080`

**The Limitation:**
If a user launches a custom API (e.g., a FastAPI inference endpoint on port `5000`) inside their instance, it will run perfectly *inside* the container, but it will be **entirely unreachable from the outside world**. The host machine does not forward traffic on port `5000` to the container because there is no `-p 5000:5000` mapping.

## 2. The Expectation
From the user's perspective, they are renting a remote "bare metal" machine. They expect to be able to write an API script, run it, and immediately consume that endpoint externally (e.g., from their local machine via `curl` or a frontend web app). They do not know or care that they are inside a Docker container.

## 3. The Objective
Provide users with a reliable way to expose custom APIs to the external network while maintaining strict container isolation (bridge network namespaces). We must ensure security and absolutely prevent port collisions between different users running instances on the same host node.

## 4. The Solution: Assigned User Port Ranges
Instead of using `--network=host` (which breaks isolation and causes fatal collisions if two users try to bind to the same port like `5000`), we will maintain the secure `bridge` network. 

However, we will dynamically assign a **dedicated block of external ports** to each container when it is created.

### The Port Math Strategy
To ensure no two containers get overlapping ports, we can calculate a unique block of 10 ports based on the container's base `nginx_port` (which we know is unique per running session).

**Formula:**
- `Offset = nginx_port - 8100` (Since Nginx ports start at 8100)
- `Range Start = 30000 + (Offset * 10)`
- `Range End = Range Start + 9`

**Examples:**
- Container A (Nginx `8100`): Offset `0`. Range: `30000` to `30009`
- Container B (Nginx `8101`): Offset `1`. Range: `30010` to `30019`
- Container C (Nginx `8102`): Offset `2`. Range: `30020` to `30029`

We then instruct Docker to map these ports 1:1 using the `-p` flag:
`-p 30000-30009:30000-30009`

### Why this solves the problem:
1. **Zero Host Collisions**: Container A uses the 30000 block. Container B uses the 30010 block. They never overlap.
2. **Absolute Isolation**: The containers remain in isolated bridge networks.
3. **External Reachability**: If User C runs `uvicorn main:app --port 30020` inside their instance, it maps directly to `http://<Host-IP>:30020`. They can consume it immediately.

## 5. Implementation Plan (What needs to be done)

To make this a reality, changes are required across the stack:

### Step 1: Session Orchestration (`app.py`)
Update the `build_docker_command` function to calculate the user port range based on the assigned `nginx_port` and append the `--expose` and `-p <start>-<end>:<start>-<end>` arguments to the Docker creation command.

### Step 2: Database Schema
Update the Prisma schema (`schema.prisma`) to store the allocated port range for a session.
- Add fields: `userPortRangeStart` (Int) and `userPortRangeEnd` (Int) to the `Session` model.

### Step 3: Backend API
Update the backend session creation logic to expect and store these port ranges. Update the GET endpoints so the frontend receives the port range along with the session details.

### Step 4: Frontend UI
Update the Instance Details / Connection panel to clearly display the assigned ports.
*Example UI Text:*
> **Desktop URL:** http://100.115.142.23:8100/
> **API Ports Available:** 30000 - 30009
> *(To expose an API, ensure your app listens on 0.0.0.0 and binds to one of the ports listed above)*

## 6. Considerations & Edge Cases

- **User Education**: Users must understand they cannot simply use port `5000` or `8080` like they might on a local machine. They *must* bind their applications to one of the ports in their specifically assigned range. This is a minor UX tradeoff, but it is the standard practice in containerized GPU clouds (e.g., Vast.ai, RunPod).
- **Firewall/Security Groups**: The host node's firewall (`ufw`) must allow incoming TCP traffic on the entire allocated user port range (e.g., `30000-31000`).
- **App Binding**: Users must bind their APIs to `0.0.0.0` inside the container, not `127.0.0.1` or `localhost`, otherwise Docker's port forwarding will not pick up the traffic.
