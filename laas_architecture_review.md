# LaaS Platform — Architecture Review

> Complete analysis after thorough review of `project_context_Beta.txt`, `backend-new/`, `frontend-new/`, `host-services/`, database schema, and network configuration.

---

## 1. Infrastructure Topology

### Physical Nodes (2 currently active)

| Property | Node 01 (`laas-node-01`) | Node 02 (`laas-node-02`) |
|---|---|---|
| **Internal IP** | `192.168.10.99` | `192.168.10.88` |
| **Tailscale IP** | `100.88.57.107` | `100.94.157.114` |
| **10GbE Storage IP** | `10.10.100.99` | `10.10.100.88` |
| **CPU** | AMD Ryzen 9 7950X3D (16c/32t) | AMD Ryzen 9 7950X3D (16c/32t) |
| **GPU** | RTX 4090 (24GB VRAM) | RTX 4090 (24GB VRAM) |
| **RAM** | 64GB DDR5 | 64GB DDR5 |
| **NVMe** | 2TB | 2TB |

### Network Interfaces (per node)

```
eno1 — LAN (192.168.10.x/23) — management, SSH, Tailscale, service traffic
eno2 — 10GbE direct link (10.10.100.x/24, MTU 9000) — NVMe-oF cross-node storage
```

### Dev Machine (your local)
- Runs: **Backend** (NestJS :3001), **Frontend** (Next.js :3000), **PostgreSQL** (:5432), **Keycloak** (:8080)
- Connects to host nodes via Tailscale IPs

---

## 2. Service Architecture

```mermaid
graph TB
    subgraph "Dev Machine"
        FE["Frontend<br/>Next.js :3000"]
        BE["Backend<br/>NestJS :3001"]
        DB["PostgreSQL :5432"]
        KC["Keycloak :8080"]
    end

    subgraph "Node 01 (10.99)"
        SO1["Session Orchestration<br/>Flask :9998"]
        SP1["Storage Provision<br/>Flask :9999"]
        D1["Docker Engine"]
        ZFS1["ZFS datapool"]
    end

    subgraph "Node 02 (10.88)"
        SO2["Session Orchestration<br/>Flask :9998"]
        SP2["Storage Provision<br/>Flask :9999"]
        D2["Docker Engine"]
        ZFS2["ZFS datapool"]
    end

    FE --> BE
    BE --> KC
    BE --> DB
    BE --> SO1
    BE --> SO2
    BE --> SP1
    BE --> SP2
    SO1 --> D1
    SO2 --> D2
    SO1 --> SP2
    SO2 --> SP1
    SP1 --> ZFS1
    SP2 --> ZFS2

    ZFS1 <-->|"NVMe-oF over 10GbE"| ZFS2
```

---

## 3. Backend (NestJS)

### Stack
- **Framework**: NestJS 11 with Fastify adapter
- **ORM**: Prisma 6 → PostgreSQL
- **Auth**: Keycloak SSO + JWT (access/refresh tokens) + Passport
- **Payments**: Razorpay (test mode)
- **Email**: Office365 SMTP via `@nestjs-modules/mailer`
- **AI**: OpenAI SDK for compute recommendation

### Module Structure

| Module | Responsibility |
|---|---|
| `auth/` | Registration, login, JWT, Keycloak sync, OTP verification |
| `compute/` | Session lifecycle — launch, stop, status polling, billing ticks |
| `node/` | Multi-node selection (balanced compute, sequential storage), fleet availability |
| `storage/` | User storage CRUD, provisioning orchestration, OS switch, extensions |
| `billing/` | Wallet operations, charges, spend limits, invoices, credit packages |
| `payment/` | Razorpay order/verify flow |
| `dashboard/` | Aggregated dashboard data |
| `user/` | User profile, preferences, deletion |
| `referral/` | Referral code system |
| `waitlist/` | Pre-launch waitlist |
| `support/` | Support tickets |
| `audit/` | Audit logging |
| `mail/` | Email templates (Handlebars) |

### Key Multi-Node Logic (`NodeService`)
- **Compute node selection**: Weighted scoring — VRAM (0.5), RAM (0.3), CPU (0.2) — picks node with most headroom
- **Storage node selection**: Sequential, checks real-time disk space via `/host-space` endpoint on each node
- **Endpoint resolution**: URLs derived from `Node.ipManagement` + port columns in DB

---

## 4. Database Schema (Prisma)

### Domain Model (~2300 lines, 60+ tables)

| Domain | Key Models |
|---|---|
| **D0: Auth & Identity** | `User`, `Organization`, `Role`, `Permission`, `RefreshToken`, `LoginHistory` |
| **D1: Universities** | `University`, `UniversityIdpConfig` |
| **D2: Groups** | `Department`, `UserGroup`, `UserProfile`, `UserDepartment` |
| **D4: Storage** | `UserStorageVolume`, `StorageExtension`, `OsSwitchHistory`, `UserFile` |
| **D5: Infrastructure** | `Node`, `BaseImage`, `NodeBaseImage`, `NodeResourceReservation` |
| **D6: Compute** | `ComputeConfig`, `ComputeConfigAccess` |
| **D7: Sessions** | `Booking`, `Session`, `SessionEvent` |
| **D8: Billing** | `Wallet`, `WalletHold`, `WalletTransaction`, `BillingCharge`, `Invoice`, `PaymentTransaction`, `Subscription`, `CreditPackage` |
| **D9: Academic** | `Course`, `Lab`, `LabAssignment`, `LabSubmission`, `LabGrade` |
| **D10: Mentorship** | `MentorProfile`, `MentorBooking`, `MentorReview` |
| **D11: Community** | `Discussion`, `ProjectShowcase`, `Achievement`, `UserAchievement` |
| **D12: Notifications** | `Notification` |
| **D13: Audit** | `AuditLog`, `UserDeletionRequest` |
| **D15: Support** | `SupportTicket`, `TicketMessage`, `UserFeedback` |

### Node Table — Critical Fields
```
hostname, ipManagement, ipCompute, ipStorage
totalVcpu, totalMemoryMb, totalGpuVramMb
allocatedVcpu, allocatedMemoryMb, allocatedGpuVramMb
sessionOrchestrationPort (9998), storageProvisionPort (9999), nvmeOfPort (4420)
metadata: { allocatableVcpu, allocatableMemoryMb, allocatableGpuVramMb, smTotal, cudaArch }
```

### Storage Enums
- **StorageBackend**: `zfs_dataset` (legacy) | `zfs_zvol` (NVMe-oF capable)
- **StorageTransport**: `local_zfs` | `nvmeof_tcp`
- **StorageMode**: `stateful` | `ephemeral`

---

## 5. Host Services

### Session Orchestration (`host-services/session-orchestration/app.py` — ~2220 lines)

Flask app running on **port 9998** on each GPU node.

#### Endpoints
| Endpoint | Method | Purpose |
|---|---|---|
| `/health` | GET | Docker, GPU, Selkies image, MPS daemon checks |
| `/sessions/launch` | POST | Async session launch (returns 202 + launchId) |
| `/sessions/<name>/events` | GET | Poll launch progress events |
| `/sessions/<name>/status` | GET | Container Docker status |
| `/sessions/<name>/stop` | POST | Graceful stop + cleanup |
| `/sessions/<name>/restart` | POST | Container restart |
| `/sessions/<name>/logs` | GET | Container log tail |
| `/sessions` | GET | List all LaaS containers |
| `/resources` | GET | CPU cores, ports, displays usage |

#### Session Launch Flow (9-step background worker)
1. **Scheduling** — Validate parameters
2. **Allocate Ports** — nginx (8100-8199), selkies (+1000), metrics (+11000), display (20-99)
3. **Allocate CPUs** — Contiguous core block from cores 2-15
4. **Validate/Setup Storage** — NVMe-oF (5-step chain), local ZFS, or NFS fallback
5. **Create Container** — `docker create` with full GPU, HAMi-core, MPS, lxcfs, seccomp
6. **Start Container** — `docker start`
7. **Wait Desktop** — Poll nginx port up to 120s
8. **Health Check** — Verify WebRTC stream
9. **Ready** — Return connection info (URL, password, ports)

#### Container Configuration Highlights
- **Network**: Bridge mode (`laas-sessions` network) with port publishing
- **GPU**: `--gpus all` + HAMi-core VRAM limits + CUDA MPS SM partitioning
- **Security**: `--cap-drop=ALL` + selective adds, seccomp, AppArmor, no-new-privileges=false (for sudo)
- **Storage mounts**: user home → ZFS/NVMe-oF/NFS, MPS pipes, HAMi libs, lxcfs proc/cpu fakes
- **Wrappers**: nvidia-smi (shows per-container limits), passwd (blocked), sudoers (deny dangerous ops)

### Storage Provision (`host-services/storage-provision/app.py` — ~2234 lines)

Flask app running on **port 9999** on each node.

#### Endpoints
| Endpoint | Method | Purpose |
|---|---|---|
| `/health` | GET | ZFS pool health |
| `/provision` | POST | Create ZFS dataset or zvol + NVMe-oF target |
| `/deprovision` | POST | Destroy storage + teardown NVMe-oF |
| `/nvme/verify-target` | POST | Check NVMe-oF subsystem status |
| `/zvol/unmount` | POST | Unmount local zvol (for cross-node NVMe-oF) |
| `/host-space` | GET | Available disk space |
| `/storage/<uid>/usage` | GET | Per-user storage usage |
| `/storage/<uid>/files` | GET/DELETE | File management |
| `/migrate/dataset-to-zvol` | POST | Live migration dataset→zvol |

#### NVMe-oF Target Management
- Uses Linux kernel `configfs` (`/sys/kernel/config/nvmet/`)
- Shared port 4420 on 10GbE interface
- Persistence via JSON file (`/etc/laas/nvmet-targets.json`) — rebuilds on reboot
- Cross-node flow: storage node exports zvol as NVMe-oF target → compute node discovers/connects/mounts

---

## 6. Frontend (Next.js)

### Stack
- **Framework**: Next.js 15 (App Router)
- **UI**: Radix UI + Tailwind CSS 4 + Framer Motion
- **State**: Zustand
- **Forms**: React Hook Form + Zod
- **Charts**: Recharts
- **Toasts**: Sonner

### Route Structure
```
src/app/
├── (auth)/          — Login/register flows
├── (console)/       — Main app shell
│   ├── dashboard/   — Overview
│   ├── home/        — Home page
│   ├── instances/   — Session management
│   ├── storage/     — Storage management
│   ├── billing/     — Wallet, charges, invoices
│   ├── profile/     — User settings
│   └── referral/    — Referral system
├── dashboard/       — Public dashboard redirect
├── waitlist/        — Pre-launch waitlist
└── ref/             — Referral landing
```

---

## 7. Compute Tiers (Current Seed Data — RTX 4090)

| Tier | vCPU | RAM | VRAM | SM% | Price/hr | Max/Node |
|---|---|---|---|---|---|---|
| **Spark** | 2 | 4GB | 2GB | 8% | ₹120 | 8 |
| **Blaze** | 4 | 8GB | 4GB | 17% | ₹210 | 4 |
| **Inferno** | 8 | 16GB | 8GB | 33% | ₹300 | 2 |
| **Supernova** | 12 | 32GB | 16GB | 67% | ₹360 | 1 |

> [!NOTE]
> The project context mentions RTX 5090 (32GB) as the target hardware. Current seed data reflects RTX 4090 (24GB) — likely the current test hardware. Tiers and VRAM allocations will need updating for RTX 5090.

---

## 8. Key Environment Variables

### Session Orchestration (on host nodes)
```bash
SESSION_SECRET=laas-session-secret-dev
HOST_IP=<tailscale_ip>         # 100.88.57.107 or 100.94.157.114
TURN_HOST=<tailscale_ip>       # Same as HOST_IP
STORAGE_PROVISION_URL=http://10.10.100.99:9999  # Internal 10GbE
NVME_STORAGE_IP=10.10.100.99   # 10GbE interface for NVMe-oF
STORAGE_PROVISION_SECRET=e75064ca...
```

### Storage Provision (on host nodes)
```bash
PROVISION_SECRET=e75064ca...
ENABLE_NFS_AUTOMOUNT=true
STORAGE_IP=10.10.100.88        # This node's 10GbE IP for NVMe-oF target
FLASK_HOST=0.0.0.0
```

### Backend (dev machine)
```bash
DATABASE_URL=postgresql://postgres:root@localhost:5432/laas
SESSION_ORCHESTRATION_SECRET=laas-session-secret-dev
USER_STORAGE_PROVISION_SECRET=e75064ca...
# Node IPs resolved from DB — no hardcoded URLs
```

---

## 9. Cross-Node Storage Flow (NVMe-oF)

```mermaid
sequenceDiagram
    participant BE as Backend (NestJS)
    participant SO as Session Orch (Compute Node)
    participant SP as Storage Prov (Storage Node)

    BE->>BE: Select compute node (least loaded)
    BE->>BE: Lookup user's storage volume → storage_node_id
    alt Same node
        BE->>SO: Launch with storage_transport=local_zfs
        SO->>SO: verify_local_zfs() → mount path
    else Cross-node
        BE->>SO: Launch with storage_transport=nvmeof_tcp
        SO->>SP: POST /zvol/unmount (free local block device)
        SP-->>SO: OK
        SO->>SO: nvme discover → connect → mount → verify
    end
    SO->>SO: docker create + start with bind mount
```

---

## 10. Security Posture

| Layer | Mechanism |
|---|---|
| **Host auth** | `X-Session-Secret` / `X-Provision-Secret` headers on all protected endpoints |
| **Container isolation** | PID namespace, cgroups v2, network namespace (bridge), seccomp, AppArmor |
| **Capability control** | `--cap-drop=ALL` + 12 selective adds (for sudo + desktop) |
| **GPU isolation** | HAMi-core VRAM limits + CUDA MPS SM partitioning + per-client GPU address spaces |
| **User restrictions** | nvidia-smi wrapper (shows per-container limits), passwd blocked, sudo deny rules for dangerous ops |
| **Data isolation** | Separate ZFS datasets/zvols per user, NFS mount per user, container overlay destroyed on stop |

---

I've thoroughly reviewed every component of your LaaS platform. I'm ready for whatever discussion or task you'd like to dive into — whether it's debugging, implementing new features, optimizing the architecture, or planning the RTX 5090 migration. What would you like to work on?
