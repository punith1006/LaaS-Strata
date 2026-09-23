<div align="center">

# ⚡ LaaS Control Plane & Orchestration Engine (`backend-new`)
### Enterprise-Grade Sovereign GPU Cloud Orchestrator • Fastify + NestJS 11 • Prisma 6 • HAMi / CUDA MPS • ZFS / NVMe-oF

[![NestJS](https://img.shields.io/badge/Framework-NestJS%2011-E0234E?logo=nestjs&logoColor=white&style=for-the-badge)](https://nestjs.com)
[![Fastify](https://img.shields.io/badge/HTTP%20Adapter-Fastify%20v5-000000?logo=fastify&logoColor=white&style=for-the-badge)](https://fastify.dev)
[![TypeScript](https://img.shields.io/badge/Language-TypeScript%205.7-3178C6?logo=typescript&logoColor=white&style=for-the-badge)](https://www.typescriptlang.org/)
[![Prisma](https://img.shields.io/badge/ORM-Prisma%206.0-2D3748?logo=prisma&logoColor=white&style=for-the-badge)](https://www.prisma.io)
[![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL%2016-4169E1?logo=postgresql&logoColor=white&style=for-the-badge)](https://www.postgresql.org)
[![Keycloak](https://img.shields.io/badge/Identity-Keycloak%20SSO-3949AB?logo=keycloak&logoColor=white&style=for-the-badge)](https://www.keycloak.org)
[![NVIDIA GPU](https://img.shields.io/badge/Compute-NVIDIA%20HAMi%20%7C%20CUDA%20MPS-76B900?logo=nvidia&logoColor=white&style=for-the-badge)](https://developer.nvidia.com)

<p align="center">
  <b>The core distributed control plane powering the LaaS (Lab-as-a-Service) GPU cloud platform.</b><br/>
  Orchestrates fractional GPU slicing, multi-tenant container lifecycles, ZFS/NVMe-oF persistent dataset attach, pre-auth wallet holds, sub-minute billing ledgers, and zero-latency WebRTC workstation streams.
</p>

---

</div>

## 📑 Table of Contents
1. [Executive Architectural Overview](#-executive-architectural-overview)
2. [Key Engineering Guarantees](#-key-engineering-guarantees)
3. [System Architecture Diagrams](#-system-architecture-diagrams)
   - [End-to-End System Topology](#1-end-to-end-system-topology)
   - [Session Lifecycle & Resource Arbitration Flow](#2-session-lifecycle--resource-arbitration-flow)
   - [Dual-Mode Storage Architecture (ZFS & NVMe-oF)](#3-dual-mode-storage-architecture)
4. [Project Directory Structure](#-project-directory-structure)
5. [In-Depth Module Breakdown & Key Functions](#-in-depth-module-breakdown--key-functions)
   - [Compute Module (`src/compute`)](#1-compute-module-srccompute)
   - [Node & Fleet Management (`src/node`)](#2-node--fleet-management-srcnode)
   - [Storage & Filesystem Engine (`src/storage`)](#3-storage--filesystem-engine-srcstorage)
   - [Authentication & Keycloak Identity (`src/auth`)](#4-authentication--keycloak-identity-srcauth)
   - [Billing, Wallets & Invoicing (`src/billing` & `src/payment`)](#5-billing-wallets--invoicing-srcbilling--srcpayment)
   - [Admin Analytics & Platform Monitoring (`src/dashboard`)](#6-admin-analytics--platform-monitoring-srcdashboard)
   - [Audit, Mail & Platform Services (`src/audit`, `src/mail`, etc.)](#7-audit-mail--platform-services)
6. [Database Schema & Domain Architecture](#-database-schema--domain-architecture)
7. [Comprehensive API Endpoint Matrix](#-comprehensive-api-endpoint-matrix)
8. [Concurrency, Security & Data Protection](#-concurrency-security--data-protection)
9. [Automated Background Workers & Cron Schedule](#-automated-background-workers--cron-schedule)
10. [Local Development, Seed & Production Runbook](#-local-development-seed--production-runbook)

---

## 🏛 Executive Architectural Overview

The **`backend-new`** service is the central nervous system of the LaaS sovereign GPU infrastructure. Built with **NestJS 11** on top of the ultra-high-throughput **Fastify** engine, it coordinates user identity, multi-node GPU compute scheduling, storage provisioning, and institutional multi-tenancy.

Unlike traditional cloud backends that spawn heavyweight virtual machines, `backend-new` interfaces directly with bare-metal Linux host daemons (`session-orchestrator`, `storage-provisioner`) to schedule fractional container pods partitioned via **HAMi-core (`libvgpu.so`)** and **CUDA Multi-Process Service (MPS)**. It provisions user home directories directly into **ZFS pools (`datapool/users/<uid>`)**, exports them over local POSIX or high-speed **NVMe-oF (TCP)** fabrics, and secures GUI workstation streaming credentials using AES-256-GCM.

```
┌────────────────────────────────────────────────────────────────────────┐
│                          LaaS Web Client (Next.js)                     │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │ Fastify HTTP/REST (Port 3001)
┌───────────────────────────────────▼────────────────────────────────────┐
│                  backend-new (LaaS Control Plane)                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌────────────┐  │
│  │ Auth & SSO   │  │ Compute Svc  │  │ Storage Svc  │  │ Billing    │  │
│  │ (Keycloak)   │  │ (Scheduling) │  │ (ZFS/NVMe-oF)│  │ (Razorpay) │  │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  └─────┬──────┘  │
└─────────┼─────────────────┼─────────────────┼────────────────┼─────────┘
          │                 │                 │                │
┌─────────▼──────┐   ┌──────▼───────┐  ┌──────▼───────┐ ┌──────▼────────┐
│ PostgreSQL 16  │   │ Node Agent   │  │ Storage Host │ │ Mail / Audit  │
│ (Prisma ORM)   │   │ (Port 9998)  │  │ (Port 9999)  │ │ (SMTP/Resend) │
└────────────────┘   └──────┬───────┘  └──────┬───────┘ └───────────────┘
                            │                 │
             ┌──────────────▼─────────────────▼─────────────┐
             │       Bare-Metal Heterogeneous GPU Fleet     │
             │   RTX 5090 / RTX 4090 / A100 (HAMi + ZFS)    │
             └──────────────────────────────────────────────┘
```

---

## 🛡 Key Engineering Guarantees

1. **Zero Overcommit & Zero-OOM Protection**:
   - Every session launch runs inside an atomic PostgreSQL serializable transaction using `SELECT ... FOR UPDATE` row locks on active node allocations.
   - 1024 MB VRAM, 2 vCPUs, and 10 GB host RAM are statically reserved for the host OS and display rendering buffers, eliminating kernel OOM panics.
2. **Sub-Millisecond Fastify Execution**:
   - Replaced default Express adapter with `@nestjs/platform-fastify`, yielding up to 2.5x higher JSON throughput.
   - Includes custom global interceptors (`BigIntInterceptor`) for seamless PostgreSQL `BIGINT` serialization to JavaScript numbers without truncating quota counters.
3. **Dual-Mode Enterprise Storage**:
   - **Local ZFS**: Direct ZFS dataset mounts (`datapool/users/<uid>`) with quota ceilings and NFS v4 exports.
   - **NVMe-oF Remote Volumes**: ZFS block zvols exposed over NVMe-oF TCP for cross-node compute scheduling when the local host is saturated.
4. **Pre-Authorization Financial Circuit Breakers**:
   - Prior to container launch, the billing engine places a `WalletHold` equivalent to 1-2 hours of compute tier usage.
   - Active spend limits and cron-driven wallet monitors ensure accounts with depleted balances are gracefully checkpointed and terminated.
5. **Zero-Trust Credential Security**:
   - Ephemeral container VNC/desktop passwords are generated per session and encrypted using **AES-256-GCM** with per-record initialization vectors (`iv`) and authentication tags (`tag`).

---

## 📊 System Architecture Diagrams

### 1. End-to-End System Topology

```mermaid
graph TB
    subgraph Client Layer
        WebClient["LaaS Web Application (Next.js)"]
        WebRTCClient["Selkies WebRTC Client (Canvas / Audio)"]
    end

    subgraph Control Plane ["LaaS Backend Control Plane (backend-new)"]
        FastifyGateway["Fastify Gateway (Port 3001)"]
        AuthModule["AuthModule (Keycloak OIDC & Local JWT)"]
        ComputeModule["ComputeModule (Scheduler & Arbiter)"]
        StorageModule["StorageModule (Dataset & Quota Arbiter)"]
        BillingModule["BillingModule (Holds, Ledger, Razorpay)"]
        NodeModule["NodeModule (Fleet Telemetry & Health)"]
    end

    subgraph Data & Identity Fabric
        PostgresDB[("PostgreSQL 16\n(Prisma Schema - 40+ Models)")]
        KeycloakServer["Keycloak 26 Identity Provider\n(Campus LDAP / OAuth)"]
    end

    subgraph Compute Nodes ["Bare-Metal Compute Fleet (ai1, ai4, ai5)"]
        HostAgent["Node Orchestrator Daemon (Port 9998)"]
        StorageDaemon["Host Storage Daemon (Port 9999)"]
        
        subgraph Pod ["Isolated Container Pod"]
            HAMi["HAMi Core (libvgpu.so)\nVRAM Hard Quota"]
            MPS["CUDA MPS Client\nSpatial SM Percentage"]
            VirtualGL["VirtualGL + /dev/shm\nEGL Headless Blit"]
            NVENC["Dual NVENC ASICs\nHardware H.264/AV1 Stream"]
        end
        
        ZFS["ZFS Zpool (datapool)\nUser Home Datasets"]
    end

    WebClient -->|HTTPS REST| FastifyGateway
    WebRTCClient -->|WebSockets / UDP| Pod

    FastifyGateway --> AuthModule
    FastifyGateway --> ComputeModule
    FastifyGateway --> StorageModule
    FastifyGateway --> BillingModule
    FastifyGateway --> NodeModule

    AuthModule -->|Verify Bearer / Sync Sub| KeycloakServer
    AuthModule --> PostgresDB
    ComputeModule -->|SELECT FOR UPDATE| PostgresDB
    StorageModule --> PostgresDB
    BillingModule --> PostgresDB
    NodeModule --> PostgresDB

    ComputeModule -->|POST /sessions/launch| HostAgent
    StorageModule -->|POST /provision| StorageDaemon
    HostAgent -->|Docker Engine API| Pod
    StorageDaemon -->|zfs create / set quota| ZFS
    ZFS -.->|Bind Mount /home/user| Pod
```

---

### 2. Session Lifecycle & Resource Arbitration Flow

```mermaid
sequenceDiagram
    autonumber
    actor User as User / Browser
    participant API as ComputeController
    participant Svc as ComputeService
    participant NodeSvc as NodeService
    participant DB as PostgreSQL (Prisma)
    participant Host as Host Orchestrator (Node Agent)
    participant Pod as Docker Pod (HAMi / MPS)

    User->>API: POST /api/compute/sessions (configId, instanceName, osChoice)
    API->>Svc: launchSession(userId, dto)
    
    rect rgb(240, 247, 255)
        Note over Svc,DB: Atomic Phase 1: Serializable Reservation
        Svc->>NodeSvc: selectComputeNode(vcpu, ram, vram, storage)
        NodeSvc-->>Svc: Selected Node (e.g. ai1)
        Svc->>DB: BEGIN TRANSACTION (ISOLATION LEVEL SERIALIZABLE)
        Svc->>DB: SELECT cc.*, s.* FROM sessions FOR UPDATE (Node Row Lock)
        Svc->>DB: Verify Wallet Balance >= Min Hold (Rs. 50.00)
        Svc->>DB: INSERT INTO wallet_holds (status: 'active', holdAmount)
        Svc->>DB: INSERT INTO sessions (status: 'starting')
        Svc->>DB: COMMIT TRANSACTION
    end

    rect rgb(245, 255, 245)
        Note over Svc,Pod: Phase 2: Host Orchestration & Virtualization
        Svc->>Host: POST /sessions/launch (instanceName, hamiSmPercent, vramMb, zfsPath)
        Host->>Host: Allocate CUDA MPS Client Thread Cap
        Host->>Host: Bind ZFS Dataset /mnt/nfs/users/<storageUid>
        Host->>Pod: docker run --gpus all -e LD_PRELOAD=libvgpu.so ...
        Pod-->>Host: Container Running (HTTP WebRTC Endpoint Ready)
        Host-->>Svc: 200 OK (containerId, streamPort, password)
    end

    Svc->>Svc: Encrypt Session Password (AES-256-GCM)
    Svc->>DB: UPDATE sessions SET status = 'running', hostPort = ...
    Svc-->>User: 201 Created (session details, encrypted connection token)
```

---

### 3. Dual-Mode Storage Architecture

```mermaid
graph LR
    subgraph Compute Node A ["Compute Node (e.g. ai1)"]
        ContainerA["Workstation Container A"]
    end

    subgraph Storage Node B ["Centralized Storage / Compute Node (e.g. ai5)"]
        Zpool[("ZFS Datapool\n(datapool/users)")]
        LocalDataset["Local Dataset\n(datapool/users/u_10a8b)"]
        ZvolBlock["ZFS Zvol Block Dev\n(datapool/zvols/vol_49c)"]
        NVMeTarget["SPDK / Linux NVMe-oF\nKernel Target (Port 4420)"]
    end

    subgraph Compute Node C ["Compute Node (e.g. ai4)"]
        NVMeInitiator["Linux NVMe-oF Initiator\n(/dev/nvme0n1)"]
        ContainerC["Workstation Container C"]
    end

    LocalDataset -->|Direct Host Bind Mount| ContainerA
    Zpool --> LocalDataset
    Zpool --> ZvolBlock
    ZvolBlock --> NVMeTarget
    NVMeTarget -->|10GbE Fabric / RoCE| NVMeInitiator
    NVMeInitiator -->|XFS Mount /home/user| ContainerC
```

---

## 📂 Project Directory Structure

```bash
backend-new/
├── .env.example                     # Environment template (DB, SMTP, Keycloak, secrets)
├── nest-cli.json                    # NestJS CLI configuration
├── package.json                     # NPM dependencies and build scripts
├── tsconfig.json                    # TypeScript compiler options (ES2022 / CommonJS)
├── eslint.config.mjs                # ESLint strict type-checking configuration
│
├── prisma/
│   ├── schema.prisma                # 2,500+ line schema across 10 distinct domains
│   └── seed.ts                      # Idempotent DB seeder (Configs, Roles, Default Node)
│
├── scripts/                         # Operational runbooks, node joiners & data repair
│   ├── register-ai1.ts              # Bare-metal node registration script (Node ai1)
│   ├── register-ai4.ts              # Node registration script (Node ai4)
│   ├── register-ai5.ts              # Node registration script (Node ai5)
│   ├── provision-user-storage.sh    # Host-side bash daemon for ZFS & NFS allocation
│   ├── host-deploy-sudo-isolation.sh# Security isolation script for host daemons
│   ├── host-precheck.sh             # Hardware & driver validation suite (NVIDIA/ZFS)
│   └── setup-complete-billing-data.ts # Synthetic billing and KPI testbed
│
└── src/
    ├── main.ts                      # Fastify bootstrap, multipart (500MB), BigInt filter
    ├── app.module.ts                # Root NestJS module importing all 18 feature domains
    ├── app.controller.ts            # Root liveness probe (/health, /metrics)
    ├── app.service.ts               # Core heartbeat and uptime telemetry
    │
    ├── common/                      # Shared filters, guards, and decorators
    │   ├── http-exception.filter.ts # Global Fastify error interceptor & JSON sanitizer
    │   └── role.helper.ts           # Institutional role validators (Student/Faculty/Admin)
    │
    ├── prisma/                      # Database lifecycle layer
    │   ├── prisma.module.ts         # Global Prisma DI provider
    │   └── prisma.service.ts        # Extended PrismaClient with connection pooling
    │
    ├── compute/                     # Core GPU Workstation Orchestration Engine
    │   ├── compute.controller.ts    # REST endpoints: sessions, logs, connect, terminate
    │   ├── compute.service.ts       # 3,300+ lines: Scheduling, serializable locks, AES-256
    │   ├── compute.dto.ts           # Zod / Class-validator DTOs for workstation requests
    │   └── compute.module.ts        # Module declaration exporting ComputeService
    │
    ├── node/                        # Fleet Topology & Node Health
    │   ├── node.service.ts          # Fleet-wide resource aggregation & node scoring
    │   ├── node-health.service.ts   # 60-second cron polling orchestrator & storage ports
    │   └── node.module.ts           # Exports NodeService across the platform
    │
    ├── storage/                     # ZFS & Persistent Volume Subsystem
    │   ├── storage.controller.ts    # File browser REST API, quota upgrades, volume CRUD
    │   ├── storage.service.ts       # Remote daemon client for ZFS dataset & quota ops
    │   └── storage.module.ts        # Storage dependency injection module
    │
    ├── auth/                        # Identity, Keycloak SSO & Session Tokens
    │   ├── auth.controller.ts       # Login, OTP verification, Keycloak OIDC callback
    │   ├── auth.service.ts          # JWT issuance, refresh rotation, policy audit logs
    │   ├── keycloak.service.ts      # Keycloak REST Admin client for user federation
    │   ├── jwt.strategy.ts          # Passport JWT strategy extracting bearer tokens
    │   ├── jwt-auth.guard.ts        # NestJS route guard enforcing JWT validity
    │   └── dto/                     # Auth payload contracts (LoginDto, VerifyOtpDto)
    │
    ├── billing/                     # Hourly Usage Settlement & PDF Invoices
    │   ├── billing.controller.ts    # Invoices, wallet balances, hourly breakdowns
    │   ├── billing.service.ts       # Hourly cron billing engine & PDFKit invoice renderer
    │   └── billing.module.ts        # Billing module definition
    │
    ├── payment/                     # Payment Gateway Integration
    │   ├── payment.controller.ts    # Razorpay order generation & webhook verification
    │   ├── payment.service.ts       # HMAC-SHA256 signature verification & wallet credits
    │   └── payment.dto.ts           # Payment initialization and verification DTOs
    │
    ├── dashboard/                   # Platform Analytics & Administrative Telemetry
    │   ├── dashboard.controller.ts  # Endpoints for admin charts, quotas & GPU usage
    │   ├── dashboard.service.ts     # Real-time resource metrics aggregation
    │   └── analytics-admin.service.ts# 110KB+ advanced revenue, retention & NRR analytics
    │
    ├── audit/                       # Immutable Compliance Ledger
    │   ├── audit.controller.ts      # Query audit events with date/category filters
    │   └── audit.service.ts         # High-speed asynchronous audit log writer
    │
    ├── mail/                        # Email Dispatch Engine
    │   └── mail.service.ts          # Handlebars + Nodemailer SMTP dispatcher
    │
    ├── user/                        # User Profile & Preferences
    │   ├── user.controller.ts       # User settings, SSH keys, OS choices
    │   └── user.service.ts          # Profile CRUD & organization memberships
    │
    ├── support/                     # Helpdesk & Incident Management
    │   ├── support.controller.ts    # Ticket submission, attachment streaming
    │   └── support.service.ts       # Support ticket state machine & admin routing
    │
    ├── referral/                    # Viral Referral & Credit Incentives
    │   ├── referral.controller.ts   # Referral links, stats, reward statuses
    │   └── referral.service.ts      # Code generator & automatic wallet reward logic
    │
    ├── waitlist/                    # Public Beta Waitlist Management
    │   ├── waitlist.controller.ts   # Public waitlist registration
    │   └── waitlist.service.ts      # Priority scoring & institutional invite triggers
    │
    ├── mentor-sessions/             # 1-on-1 AI Consultation Marketplace
    │   ├── mentor-sessions.controller.ts # Booking slots, instant call sessions
    │   └── mentor-sessions.service.ts    # Booking lifecycle, hold settlement, reviews
    │
    ├── mentor-availability/         # Expert Scheduling Slots
    │   ├── mentor-availability.controller.ts # Recurring availability calendars
    │   └── mentor-availability.service.ts    # Slot conflict detection & generation
    │
    ├── jitsi-demo/                  # WebRTC Video Conference Rooms
    │   ├── jitsi-demo.controller.ts # Ephemeral meeting room token generator
    │   └── jitsi-demo.service.ts    # Jitsi JWT room signature generation
    │
    └── withdrawal/                  # Mentor Payouts & Transfers
        ├── withdrawal.controller.ts # Payout requests and status tracking
        └── withdrawal.service.ts    # Payout validation and balance debits
```

---

## 🔍 In-Depth Module Breakdown & Key Functions

### 1. Compute Module (`src/compute`)
The largest and most critical domain in the control plane. Orchestrates containerized workstations on GPU host nodes.

#### Core Service: `ComputeService` (`compute.service.ts`)
* **`launchSession(userId: string, dto: LaunchSessionDto)`**:
  - Validates `computeConfigId`, checks active session quotas, and verifies user wallet balance against the pre-auth threshold.
  - Queries `NodeService.selectComputeNode()` to find the optimal host with sufficient GPU VRAM, vCPU, RAM, and storage headroom.
  - Opens a PostgreSQL transaction (`$transaction`) and issues `SELECT ... FOR UPDATE` row locks against active sessions on that specific node.
  - Creates an active `WalletHold` record to safeguard compute credit.
  - Creates a `Session` record in status `starting`.
  - Dispatches an asynchronous HTTP request (`callOrchestration('/sessions/launch')`) to the node agent passing the container image, HAMi SM percentage, VRAM allocation, and user storage mounts.
  - Encrypts the ephemeral streaming password using `encryptPassword()` (AES-256-GCM) and saves connection parameters.
* **`terminateSession(userId: string, sessionId: string, reason?: SessionTerminationReason)`**:
  - Idempotent termination handler. If already ended, returns early.
  - Calls host agent `POST /sessions/:id/terminate` to kill the Docker container and free CUDA MPS contexts.
  - Calculates final runtime duration in seconds.
  - Computes exact usage cost, captures the active `WalletHold`, creates a final `BillingCharge`, and refunds any excess hold balance.
  - Emits a chronological `SessionEvent` audit record.
* **`restartSession(userId: string, sessionId: string)`**:
  - Issues a clean container restart request to the host daemon without destroying the underlying root filesystem or persistent storage mounts.
* **`getResourceUsage()`**:
  - Aggregates cluster-wide total allocatable vs. active allocated GPU VRAM, vCPU, and RAM across all running instances.
* **`getConfigsWithAvailability()`**:
  - Computes live availability for each tier (`Spark`, `Blaze`, `Inferno`, `Supernova`), indicating whether any healthy node has capacity to launch it.
* **`analyzeWorkload(description: string, primaryGoal: string)`**:
  - AI Workload Analyzer: Takes user text/paper descriptions, extracts frameworks (PyTorch, TensorFlow, vLLM), and recommends the exact GPU tier required.
* **`extractDocumentText(fileBuffer: Buffer, mimetype: string)`**:
  - Extracts raw text from uploaded assignment briefs or research papers (`pdf-parse`, `mammoth` for DOCX).

---

### 2. Node & Fleet Management (`src/node`)
Maintains the registry of physical compute nodes and performs continuous health checks.

#### Core Services:
* **`NodeService` (`node.service.ts`)**:
  - **`selectComputeNode(vcpu, memoryMb, gpuVramMb, requiredStorageGb)`**: Multi-attribute bin-packing scheduler. Evaluates healthy nodes, computes available headroom, and scores nodes based on packing density and load balancing.
  - **`getFleetConfigAvailability()`**: Evaluates every tier against all online nodes, returning boolean availability and max launchable instance counts.
  - **`getAllocatableForNode(node)`**: Reads node hardware specs and deducts system overheads (e.g. 1024 MB VRAM, 2 vCPU, 10 GB RAM reserved for OS/display).
* **`NodeHealthService` (`node-health.service.ts`)**:
  - **`@Cron(CronExpression.EVERY_MINUTE)`**: Pings `http://<nodeIp>:9998/health` (orchestration agent) and `http://<nodeIp>:9999/health` (storage provisioner).
  - Automatically transitions node states: `healthy` -> `degraded` -> `offline`.
  - Suppresses alarms for nodes explicitly marked in `maintenance`, `draining`, or `inactive`.

---

### 3. Storage & Filesystem Engine (`src/storage`)
Controls ZFS dataset lifecycles, user disk quotas, and in-browser file management.

#### Core Controller & Service:
* **`StorageController` (`storage.controller.ts`)**:
  - `GET /api/storage/volumes`: Returns all active storage volumes, quotas, and current consumption in GB.
  - `POST /api/storage/volumes`: Provisions a new persistent volume (`5GB` - `32GB`) with a unique `storage_uid` (`u_<12-hex-bytes>`).
  - `POST /api/storage/upgrade`: Upgrades an active volume's quota in-place without unmounting.
  - `GET /api/storage/files`: Lists directory contents of the user's persistent home dataset.
  - `POST /api/storage/files/upload`: Fastify multipart file streamer supporting uploads up to 500MB directly into the user's ZFS dataset.
  - `GET /api/storage/files/download`: Streams binary file downloads with proper MIME and disposition headers.
  - `DELETE /api/storage/files`: Safely deletes files or directory trees with full audit trails.
* **`StorageService` (`storage.service.ts`)**:
  - Communicates with the bare-metal storage agent (`USER_STORAGE_PROVISION_URL`).
  - Enforces ZFS properties: `zfs set quota=<size>G datapool/users/<uid>`.
  - Manages ZFS snapshots for instant rollbacks and volume extensions.

---

### 4. Authentication & Keycloak Identity (`src/auth`)
Hybrid authentication engine supporting both Institutional Single Sign-On (OIDC/SAML via Keycloak) and public email/password authentication with 6-digit OTPs.

#### Core Architecture:
* **`AuthService` (`auth.service.ts`)**:
  - **`sendOtp(email)` / `verifyOtp(email, code)`**: Issues cryptographically secure 6-digit verification codes via SMTP with a 15-minute TTL and strict rate-limiting (3 resends per 15 minutes).
  - **`login(email, password)`**: Verifies bcrypt-hashed credentials and issues dual JWTs (`accessToken` valid for 15m, `refreshToken` valid for 7 days).
  - **`refreshToken(token)`**: Validates refresh tokens against database records, checking `tokenVersion` to support instant global revocation.
  - **`syncKeycloakUser(profile)`**: JIT (Just-In-Time) provisioning for university students logging in via campus SSO, automatically assigning student quotas and default organizational roles.
* **`KeycloakService` (`keycloak.service.ts`)**:
  - Uses `@keycloak/keycloak-admin-client` to query and synchronize user groups, institutional department affiliations, and role mappings.

---

### 5. Billing, Wallets & Invoicing (`src/billing` & `src/payment`)
Financial ledger providing sub-minute billing accuracy and payment collection.

#### Core Architecture:
* **`BillingService` (`billing.service.ts`)**:
  - **`@Cron(CronExpression.EVERY_HOUR)`**: Executes `processHourlyStorageBilling()`. Computes storage usage for active chargeable volumes at Rs. 7/GB/month (`(quotaGb * 700) / 730 / 100` Rs/hr) and debits user wallets atomically. Excludes free student tiers (`sso_default`).
  - **`createCharge(userId, amountCents, category, sessionId)`**: Inserts immutable billing records with balance tracking.
  - **`generateInvoicePdf(invoiceId)`**: Generates crisp, downloadable PDF tax invoices using `pdfkit`.
* **`PaymentService` (`payment.service.ts`)**:
  - Integrates with **Razorpay**.
  - `createOrder(userId, amountInr)`: Creates a verified Razorpay order.
  - `verifyWebhook(signature, body)`: Computes HMAC-SHA256 signatures to credit wallets automatically upon successful UPI, card, or netbanking transactions.

---

### 6. Admin Analytics & Platform Monitoring (`src/dashboard`)
Delivers real-time executive and operational visibility across the GPU cluster.

* **`AnalyticsAdminService` (`analytics-admin.service.ts`)**:
  - **Revenue & Unit Economics**: Calculates Gross Revenue, MRR, Net Revenue Retention (NRR), and cost per GPU-hour.
  - **GPU Utilization Engine**: Aggregates physical vs. virtual compute allocation metrics across heterogeneous clusters.
  - **Cohort Retention**: Tracks multi-week student and researcher cohort engagement.

---

### 7. Audit, Mail & Platform Services

* **`AuditService` (`src/audit`)**: Asynchronous, non-blocking compliance ledger logging user logins, container launches, file modifications, and administrative role updates.
* **`MailService` (`src/mail`)**: Nodemailer engine utilizing Handlebars templates for OTP delivery, spend limit threshold alerts, and PDF invoices.
* **`ReferralService` (`src/referral`)**: Viral referral tracking system generating unique referral links, tracking multi-stage qualification, and crediting wallet bonuses.
* **`MentorSessionsService` & `JitsiDemoService`**: Peer-to-peer expert marketplace integrating WebRTC video rooms via Jitsi JWT token generation.

---

## 🗄 Database Schema & Domain Architecture

The database is built on **PostgreSQL 16** and modeled through **Prisma ORM** (`prisma/schema.prisma`), spanning over 40 relational entities grouped into 10 domains:

| Domain | Key Models | Description |
|:---|:---|:---|
| **Domain 0: Identity & Auth** | `User`, `UserProfile`, `OtpVerification`, `RefreshToken`, `LoginHistory` | User credentials, Keycloak federation, session refresh tokens, and login history. |
| **Domain 1: Organization & RBAC** | `Organization`, `Department`, `UserOrgRole`, `Role`, `Permission` | Multi-tenant university hierarchies, department groupings, and granular permissions. |
| **Domain 2: Node Topology** | `Node`, `NodeGpu`, `NodeTelemetry`, `GpuAllocation` | Physical server inventory, PCIe/NVLink topologies, and allocatable capacities. |
| **Domain 3: Compute Scheduling** | `ComputeConfig`, `Session`, `SessionEvent`, `SessionPort` | GPU tiers (`Spark`, `Blaze`, etc.), container runtimes, stream URLs, and event timelines. |
| **Domain 4: Storage & Filesystem** | `UserStorageVolume`, `StorageExtension`, `VolumeSnapshot` | ZFS datasets, NVMe-oF zvols, quota ceilings, and snapshot rollback records. |
| **Domain 5: Billing & Financials** | `Wallet`, `WalletHold`, `WalletTransaction`, `BillingCharge`, `Invoice` | Credit balances, pre-auth holds, hourly usage charges, and tax invoice items. |
| **Domain 6: Mentor Marketplace** | `MentorProfile`, `MentorSession`, `MentorAvailability`, `WithdrawalRequest` | 1-on-1 consultations, calendar slot bookings, reviews, and mentor payout requests. |
| **Domain 7: Support & Helpdesk** | `Ticket`, `TicketMessage`, `TicketAttachment` | Support ticketing system with priority levels, admin assignments, and file attachments. |
| **Domain 8: Growth & Marketing** | `ReferralCode`, `ReferralConversion`, `Waitlist` | Referral conversion funnels, reward distributions, and beta waitlist queues. |
| **Domain 9: Audit & Governance** | `AuditLog`, `SystemConfig`, `UserPolicyConsent` | Immutable system-wide audit logs and privacy policy consent timestamps. |

---

## 🔌 Comprehensive API Endpoint Matrix

### Compute & Orchestration (`/api/compute`)
| Method | Path | Auth Guard | Description |
|:---|:---|:---|:---|
| `GET` | `/configs` | `JwtAuthGuard` | List all active GPU tiers with real-time cluster launch availability. |
| `GET` | `/resources/usage` | `JwtAuthGuard` | Cluster-wide resource utilization (VRAM, vCPU, RAM). |
| `POST` | `/sessions` | `JwtAuthGuard` | Launch a containerized GPU workstation session with serializable locks. |
| `GET` | `/sessions` | `JwtAuthGuard` | Get all active and past sessions for the authenticated user. |
| `GET` | `/sessions/:id` | `JwtAuthGuard` | Get session metadata, current uptime, and accumulated cost. |
| `POST` | `/sessions/:id/terminate` | `JwtAuthGuard` | Idempotently stop session, release GPU slice, and capture wallet hold. |
| `POST` | `/sessions/:id/restart` | `JwtAuthGuard` | Restart the session container on the host node. |
| `GET` | `/sessions/:id/logs` | `JwtAuthGuard` | Fetch the last 100 lines of stdout/stderr from the container. |
| `GET` | `/sessions/:id/connection` | `JwtAuthGuard` | Get WebRTC stream URL and decrypted AES-256 desktop credentials. |
| `GET` | `/sessions/:id/events` | `JwtAuthGuard` | Chronological event history for session troubleshooting. |
| `POST` | `/analyze-workload` | `JwtAuthGuard` | AI model recommending compute tier based on project description. |

### Storage & Filesystem (`/api/storage`)
| Method | Path | Auth Guard | Description |
|:---|:---|:---|:---|
| `GET` | `/volumes` | `JwtAuthGuard` | List user persistent storage volumes, quotas, and utilization. |
| `POST` | `/volumes` | `JwtAuthGuard` | Provision a new ZFS volume with user-selected quota (5GB - 32GB). |
| `POST` | `/volumes/upgrade` | `JwtAuthGuard` | Dynamically expand an existing storage volume's quota ceiling. |
| `GET` | `/files` | `JwtAuthGuard` | Browse directories and list files in the user's ZFS home dataset. |
| `POST` | `/files/mkdir` | `JwtAuthGuard` | Create a new subfolder in persistent storage. |
| `POST` | `/files/upload` | `JwtAuthGuard` | Stream files (up to 500MB) directly into the user's dataset. |
| `GET` | `/files/download` | `JwtAuthGuard` | Download a binary file from the user's dataset. |
| `DELETE` | `/files` | `JwtAuthGuard` | Delete a file or directory tree with audit logging. |

### Identity & Authentication (`/api/auth`)
| Method | Path | Auth Guard | Description |
|:---|:---|:---|:---|
| `POST` | `/send-otp` | Public | Dispatch a 6-digit verification code to the specified email. |
| `POST` | `/resend-otp` | Public | Rate-limited OTP resend (maximum 3 requests per 15 minutes). |
| `POST` | `/verify-otp` | Public | Verify OTP, create user profile, and record policy consents. |
| `POST` | `/login` | Public | Authenticate via email/password; returns access & refresh tokens. |
| `POST` | `/refresh` | Public | Rotate refresh token and issue a fresh access token. |
| `POST` | `/logout` | `JwtAuthGuard` | Invalidate active refresh tokens and revoke session state. |
| `GET` | `/me` | `JwtAuthGuard` | Return authenticated user identity, role, and quota profile. |

---

## 🔒 Concurrency, Security & Data Protection

### 1. Concurrency Control & Double-Allocation Prevention
When multiple users request GPU workstations simultaneously, race conditions could cause GPU VRAM over-allocation. `ComputeService` eliminates this via two-phase serializable transactions:
```sql
SELECT cc.vcpu, cc.memory_mb, cc.gpu_vram_mb
FROM sessions s
JOIN compute_configs cc ON s.compute_config_id = cc.id
WHERE s.status IN ('pending', 'starting', 'running', 'reconnecting')
AND s.node_id = $1::uuid
FOR UPDATE;
```
The `FOR UPDATE` clause places an exclusive row-level lock on active sessions for that node, forcing concurrent launch requests to serialize cleanly.

### 2. Desktop Password Cryptography
Workstation VNC/desktop passwords are generated randomly on the host node, encrypted before database storage, and only decrypted when the authorized user calls `/connection`:
* **Algorithm**: `AES-256-GCM` (Galois/Counter Mode).
* **Key**: Derived from `SESSION_CREDENTIAL_KEY` (32-byte hexadecimal string).
* **Storage**: Encrypted ciphertext, 12-byte initialization vector (`iv`), and 16-byte authentication tag (`tag`) stored in distinct columns.

### 3. File Upload Safety
* Handled through `@fastify/multipart` with a hardcoded buffer limit of `500 * 1024 * 1024` bytes (500 MB).
* File streams are written directly to mounted user ZFS datasets with path traversal sanitization preventing directory escape attacks (`../`).

---

## ⏰ Automated Background Workers & Cron Schedule

The backend runs automated background jobs via `@nestjs/schedule` to maintain cluster health and enforce financial policies:

```
┌─────────────────────────┬───────────────────┬────────────────────────────────────────────────────────┐
│ Worker Job              │ Schedule          │ Purpose / Action Performed                             │
├─────────────────────────┼───────────────────┼────────────────────────────────────────────────────────┤
│ Node Health Check       │ Every Minute      │ Pings orchestrator (9998) and storage (9999) on all    │
│                         │ (`* * * * *`)     │ registered nodes; transitions node status if degraded. │
├─────────────────────────┼───────────────────┼────────────────────────────────────────────────────────┤
│ Hourly Storage Billing  │ Every Hour        │ Calculates hourly storage fee (Rs. 7/GB/mo) for active │
│                         │ (`0 * * * *`)     │ non-free volumes and debits user wallets atomically.   │
├─────────────────────────┼───────────────────┼────────────────────────────────────────────────────────┤
│ Idle Session Reaper     │ Every 5 Minutes   │ Inspects WebRTC heartbeat signals; terminates sessions  │
│                         │ (`*/5 * * * *`)   │ inactive for >30 minutes to preserve GPU VRAM.         │
├─────────────────────────┼───────────────────┼────────────────────────────────────────────────────────┤
│ Spend Limit Monitor     │ Every 2 Minutes   │ Checks running session costs against user balance;     │
│                         │ (`*/2 * * * *`)   │ triggers graceful shutdown if credits are exhausted.  │
└─────────────────────────┴───────────────────┴────────────────────────────────────────────────────────┘
```

---

## 🚀 Local Development, Seed & Production Runbook

### Prerequisites
* **Node.js**: `v20.x` or `v22.x` (LTS recommended)
* **Package Manager**: `npm` v10+
* **Database**: PostgreSQL 15 or 16
* **Keycloak** (Optional for local testing; local email/OTP authentication works standalone)

### 1. Clone & Install Dependencies
```bash
cd backend-new
npm install
```

### 2. Configure Environment Variables
Copy `.env.example` to `.env` and fill in your database credentials:
```bash
cp .env.example .env
```
Key configuration parameters:
```ini
DATABASE_URL="postgresql://laas_user:laas_password@localhost:5432/laas_db?schema=public"
PORT=3001
CORS_ORIGIN="http://localhost:3000"

# JWT & Cryptography Secrets
JWT_SECRET="super-secret-jwt-key-change-in-production"
JWT_EXPIRES_IN="15m"
JWT_REFRESH_EXPIRES_IN="7d"
SESSION_CREDENTIAL_KEY="0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"

# Host Orchestration Daemon Credentials
SESSION_ORCHESTRATION_URL="http://100.100.66.101:9998"
SESSION_ORCHESTRATION_SECRET="host-orchestrator-shared-secret"

# Host Storage Daemon Credentials
USER_STORAGE_PROVISION_URL="http://100.100.66.101:9999/provision"
USER_STORAGE_PROVISION_SECRET="host-storage-shared-secret"

# SMTP Mail Transport
SMTP_HOST="smtp.office365.com"
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USERNAME="ksrcesupport@gktech.ai"
SMTP_PASSWORD="your-smtp-password"
SMTP_FROM="ksrcesupport@gktech.ai"
```

### 3. Database Migration & Seeding
Apply database migrations and seed default compute configs (`Spark`, `Blaze`, `Inferno`):
```bash
# Apply migrations to database
npm run prisma:migrate

# Seed default compute tiers, roles, and administrative users
npm run prisma:seed
```

To visually inspect database tables, launch Prisma Studio:
```bash
npm run prisma:studio
```

### 4. Running the Application
```bash
# Development mode with hot-reload
npm run start:dev

# Debugging mode with inspector attached
npm run start:debug

# Compile TypeScript production build
npm run build

# Start production server
npm run start:prod
```

### 5. Running Test Suites
```bash
# Run unit tests
npm run test

# Run tests in watch mode
npm run test:watch

# Run test coverage report
npm run test:cov

# Run end-to-end (e2e) tests
npm run test:e2e
```

### 6. Registering Physical GPU Compute Nodes
To onboard bare-metal GPU servers into the scheduler, run the registration scripts under `scripts/`:
```bash
# Register Node ai1 (NVIDIA RTX 5090 Blackwell)
npx ts-node scripts/register-ai1.ts

# Register Node ai4 (NVIDIA RTX 4090 Ada Lovelace)
npx ts-node scripts/register-ai4.ts

# Register Node ai5 (Storage & Compute Host)
npx ts-node scripts/register-ai5.ts
```

---

<div align="center">
  <sub>Built with precision for sovereign academic and research GPU cloud infrastructure.</sub><br/>
  <sub>Maintained by the <b>LaaS Engineering Team</b> • For queries contact <a href="mailto:punith.vs74064@gmail.com">punith.vs74064@gmail.com</a></sub>
</div>
