## Platform Walkthrough

<!-- Demo video will be embedded here -->

<h2>
  About
  <a href="https://ksrceailab.com">
    <img align="right" src="https://img.shields.io/badge/Visit%20LaaS-%E2%86%97-4285F4?style=flat-square" alt="Visit LaaS">
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
