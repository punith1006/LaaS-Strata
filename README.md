## Platform Walkthrough

<!-- Demo video will be embedded here -->

<h2>
  About
  <a href="https://ksrceailab.com" target="_blank">
    <img align="right" height="30" src="https://img.shields.io/badge/Launch%20Platform%20%E2%86%92-1D4ED8?style=for-the-badge&logoColor=white&labelColor=000000" alt="Launch Platform">
  </a>
</h2>

Modern AI and HPC environments require more than raw compute. Teams need accessible GPU resources, ready-to-use Linux environments, persistent workspaces, and the ability to share expensive infrastructure efficiently. Traditional on-premise setups often leave GPUs underutilized, while public cloud environments introduce recurring compute costs, data movement, and reduced infrastructure control.

**LaaS** transforms on-premise GPU infrastructure into an on-demand private cloud for interactive, browser-accessible Linux workspaces. It abstracts the underlying compute, GPU, storage, and system infrastructure into a unified platform where users can provision and access fully featured graphical workstations without managing the underlying machines themselves.

At its core, LaaS combines **fractional GPU resource allocation, containerized workspaces, persistent storage, and low-latency remote desktop streaming** to turn shared GPU infrastructure into isolated, reusable computational environments. This allows multiple users and workloads to share physical accelerators while retaining the experience of a dedicated Linux workstation.

The result is a more accessible and efficient model for AI/ML development, scientific computing, simulation, visualization, and institutional computing — bringing the experience of a cloud GPU workstation to infrastructure that remains **under the organization's control and within its own environment**.

## Design & Architecture

LaaS is designed as a layered platform that separates the control plane from the
compute and data planes, allowing workspace lifecycle, resource allocation,
storage, networking, and observability to operate independently of the user
workload itself.

### High-Level Platform Architecture
<img width="4800" height="3840" alt="LaaS_System_Architecture_Overview-Final" src="https://github.com/user-attachments/assets/50911ace-1e3e-4aa9-a530-7692314c528e" />

### GPU Virtualization & Streaming Architecture
At the compute layer, LaaS combines fractional GPU resource allocation with a
dedicated graphical streaming pipeline. CUDA workloads are isolated and
resource-constrained through GPU virtualization and MPS, while the desktop
rendering path uses hardware-accelerated NVENC encoding and WebRTC to deliver
interactive remote workspaces to users.
<img width="4800" height="3420" alt="LaaS_GPU_Virtualization_Stack -Final" src="https://github.com/user-attachments/assets/877d1d6f-2718-471e-945b-7af849ad2e66" />

## Features & Capabilities

LaaS couples low-level systems engineering with an intuitive cloud management plane, delivering elastic GPU virtualization alongside managed platform services.

### Core Technical Architecture

* **Fractional GPU Slicing & Spatial Isolation**
  * Hardware-enforced VRAM quotas and SM thread allocation using **HAMi-core (`libvgpu.so`)** and **CUDA MPS**, preventing out-of-memory (OOM) faults and noisy-neighbor interference across multi-tenant workloads.
  * Multiplexes a single physical NVIDIA RTX 5090 into discrete virtual slices (**Spark, Blaze, Inferno, Supernova**), scaling concurrent user density by 4x–8x without hypervisor overhead.

* **Distributed Stateful Storage & Zero-Lock Roaming**
  * Decouples ephemeral container compute from persistent user data via enterprise **TrueNAS ZFS** datasets exported over high-throughput NFSv4 (MTU 9000).
  * **Compute-Agnostic Workspace Roaming:** Users can spin down a lightweight Spark instance (2GB VRAM) and relaunch on an Inferno instance (8GB VRAM) or entirely different physical nodes seamlessly; all user files, virtual environments, and weights persist at `/home/ubuntu`.

* **Hardware-Accelerated WebRTC Streaming**
  * Combines VirtualGL offscreen EGL Pbuffer rendering with direct DMA readback into hardware **NVENC** engines.
  * Streams full 60 FPS graphical Linux desktop environments (KDE Plasma, VS Code, Blender) natively inside any standard browser with sub-25ms glass-to-glass latency.

* **Kernel-Level Multi-Tenant Sandboxing**
  * Complete workspace isolation via `cgroups v2`, custom Linux namespaces, and `lxcfs` / `fake_sysconf.so` to spoof CPU cores and memory limits, ensuring processes cannot exceed their provisioned boundary.

---

### Platform & Ecosystem Capabilities

* **Elastic Compute-on-Demand**
  * Self-service catalog allowing researchers and students to provision right-sized GPU instances per hour, complete with pre-configured AI toolchains (CUDA, PyTorch, JupyterLab, vLLM).

* **Integrated Mentorship & Advisory Marketplace**
  * An integrated subscription and booking service connecting students with verified AI mentors for code reviews, architecture guidance, and project debugging directly within their active environments.

* **Unified Zero-Trust Access & Telemetry**
  * Frictionless ingress secured via **Cloudflare Zero Trust** and Coturn STUN/TURN relays—eliminating port-forwarding and public IP exposures while maintaining cluster telemetry via Prometheus and NVIDIA DCGM.

* **Automated Credit & Wallet Billing**
  * Micro-metered, second-by-second token-bucket billing integrated with automated quota replenishment, wallet balances, and grace-period lifecycle terminations.

## Project Structure

The repository is structured as a modular monorepo, separating the centralized cloud control plane from distributed host daemons, virtualization drivers, and monitoring stacks:

```text
.
├── backend/                  # NestJS 11 Core API Engine
│   ├── src/                  # Compute scheduling, session orchestration, auth & wallet billing
│   ├── prisma/               # PostgreSQL schema definitions & migration models
│   └── scripts/              # Automated user storage & system provisioning scripts
│
├── frontend/                 # Next.js 15 Web Console & User Dashboard
│   ├── src/app/              # Instance launch catalog, active session view & billing UI
│   └── public/               # Static platform assets & interactive client components
│
├── host-services/            # Node-Level Microservices (Python FastAPI)
│   ├── session-orchestration/# Container lifecycle manager, Docker runtime & MPS binding
│   └── storage-provision/    # TrueNAS ZFS dataset provisioning & NFS export controller
│
├── monitoring_setup_files/   # Cluster Observability & Telemetry Fabric
│   ├── prometheus/           # Metrics collection configs & scraping rules
│   ├── dcgm-exporter/        # NVIDIA DCGM GPU hardware telemetry exporter
│   └── grafana/              # Pre-configured dashboards for VRAM, wattage & tenant load
│
├── HLD_Arch_Images/          # Publication-grade system architecture specifications & diagrams
│
├── Important_docs/           # Production runbooks, node setup manuals & deployment guides
│
└── Project_Context/          # Enterprise datasheets, technical reports & architecture specs
```

## Future Scope & Technical Roadmap
LaaS is evolving from an isolated multi-tenant GPU virtualization engine into a full-scale, sovereign AI cloud operating system. The upcoming technical roadmap focuses on intelligent storage orchestration, enterprise datacenter operations, and automated academic workflows.
### 1. Intelligent Storage Fabric & Fleet Rebalancing
* **Zero-Downtime Cross-Node Storage Migration:** 
  * In scenarios where a user requests a storage expansion (e.g., 20GB $\to$ 32GB) on a storage node with depleted physical capacity, the orchestration plane will dynamically query fleet-wide storage health to identify the best-fit alternative node.
  * Implements non-blocking, staged data synchronization (leveraging incremental ZFS send/receive streams or block-level sync) with automatic rollback buffers and pre-cutover checkpoints—ensuring zero data loss and no I/O latency spikes for active co-tenants.
* **Cold Tiering & Automated Data Archival:** 
  * Policy-driven lifecycle management that automatically migrates inactive tenant datasets to low-cost compressed archival pools after configurable idle thresholds, freeing high-speed NVMe flash for active workloads while enabling instant on-demand hydration upon user login.
### 2. Comprehensive Datacenter IT Operations (ITOps) Suite
* **Real-Time Per-Instance Telemetry:** 
  * Egress granular, second-by-second telemetry per container instance (CUDA core occupancy, VRAM memory bandwidth, vCPU execution queues, and network TX/RX throughput) directly to administrative monitors.
* **Unified Infrastructure & Fleet Control Plane:** 
  * Expanding beyond the current business analytics console to a complete bare-metal Datacenter Ops dashboard: real-time node cluster topology, physical drive S.M.A.R.T health, dynamic thermal/power throttling alerts, and live container lifecycle intervention.
### 3. Native Academic & Institutional Cohort Orchestration
* **Instructor & Curriculum Sandboxing:** 
  * Role-based interfaces allowing professors and lab instructors to bundle complete technical assignments into standardized, pre-configured workspace templates (e.g., PyTorch 2.5, preloaded datasets, custom CUDA libraries, and graded assignment code).
* **Self-Paced Lab Scheduling & Auto-Grading Handoff:** 
  * Instructors can schedule cohort-wide deadlines where students spin up identical, ephemeral sandbox environments with one click, run their experiments, and commit final checkpoints directly to the instructor's submission queue for automated evaluation.
### 4. High-Throughput Interconnect & RDMA Fabric
* **RDMA over Converged Ethernet (RoCE v2) / NVMe-oF:** 
  * Upgrading node-to-node communications from standard TCP networking to kernel-bypass RDMA fabrics with high-density enterprise switching, eliminating network copy overhead and enabling near-bare-metal remote dataset I/O for distributed model training.

## Contributing & Community

LaaS was conceived, architected, and built from the ground up as a solo initiative—taking the platform from early bare-metal experiments to a live production beta serving students and faculty at **K.S.R. College of Engineering (KSRCE)**.

### The Mission: Sovereign Neo-Clouds for Every University
As global demand for AI compute accelerates exponentially, relying exclusively on centralized hyperscalers creates unsustainable recurring costs, vendor lock-in, and data sovereignty risks. Our vision is to empower every university, research laboratory, and enterprise with their own **self-hosted, sovereign neo-cloud**—turning bare-metal hardware into an accessible, elastic AI supercomputing cluster.

We are opening up development to engineers, researchers, and systems enthusiasts who want to shape the future of distributed compute, low-level virtualization, and AI infrastructure.

### Priority Contribution Areas
Whether your expertise lies in the Linux kernel or modern web interfaces, there are immediate high-impact areas to contribute:

1. **Kernel & GPU Virtualization (Systems & C/C++)**
   * Optimizing user-space CUDA shims (`libvgpu.so` / HAMi-core) and active thread time-slicing under CUDA MPS.
   * Developing automated VRAM serialization and memory checkpointing daemons for idle instance hibernation.

2. **Distributed Storage & Data Fabrics (Python / Go / ZFS)**
   * Implementing automated cross-node dataset rebalancing using ZFS replication streams.
   * Benchmarking and tuning NVMe-over-Fabrics (NVMe-oF) RDMA target drivers.

3. **Cloud Control Plane & Schedulers (TypeScript / NestJS / Prisma)**
   * Enhancing the multi-node packing algorithm (bin-packing container instances across heterogeneous GPU fleets).
   * Building the instructor/cohort assignment lifecycle and auto-submission pipelines.

4. **WebRTC & Client Experience (Next.js 15 / WebRTC / GStreamer)**
   * Tuning client-side WebRTC decoding latency, dynamic resolution scaling, and mobile browser touch inputs.
   * Designing real-time cluster telemetry components for the ITOps dashboard.

### Local Development Setup
To spin up a local development environment for the control plane and API:

#### 1. Prerequisites
* **Node.js**: `v20+` & **pnpm** / **npm**
* **Python**: `3.10+` (for host-service daemons)
* **Docker Engine** & **Docker Compose**
* **PostgreSQL** instance & **Redis**

#### 2. Clone & Install
```bash
git clone https://github.com/punith1006/LaaS-Strata.git
cd LaaS-Strata
```
#### 3. Control Plane Setup (Backend)
```bash
cd backend
npm install
cp .env.example .env

# Run database migrations
npx prisma migrate dev
npx prisma db seed

# Launch backend in development mode
npm run start:dev
```
#### 4. Control Plane Setup (Backend)
```bash
cd ../frontend
npm install
cp .env.example .env.local

# Launch Next.js dev server
npm run dev
```
The frontend will be accessible at http://localhost:3000, communicating with the backend API at http://localhost:3001.

### Contribution Guidelines
#### 1.Fork the Repository and create your feature branch
```bash
git checkout -b feature/amazing-feature
```
#### 2.Commit your changes with clear, conventional commit messages
```bash
git commit -m 'feat(scheduler): implement dynamic fleet rebalancing check'
```
#### 3.Push to the branch and submit a Pull Request.

### Connect & Collaborate
If you are passionate about sovereign AI infrastructure, GPU virtualization, or want to deploy a LaaS cluster at your institution, feel free to connect or reach out directly:

Author & Lead Architect: Punith V S

Email: punith.vs74064@gmail.com
