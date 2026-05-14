# Incident Report: AI1 Server Network Failure
**Date:** May 13, 2026  
**Status:** Resolved (via Hard Reboot)  
**Root Cause:** Hardware-level PCIe Link Loss (Intel I225-V NIC)

---

#### 1. Executive Summary
At approximately **13:29 IST**, the `ai1` server became completely unreachable over the management and public networks. While the server remained physically powered on and "alive" locally (as confirmed by IT staff), the network interface card (NIC) responsible for management traffic detached itself from the system bus (PCIe). This resulted in a complete loss of external connectivity while internal 10GbE storage traffic (on a separate NIC) likely remained functional.

#### 2. Timeline of Events (All times in IST)

| Time (IST) | Event Description | Log Reference |
| :--- | :--- | :--- |
| **13:03:36** | System successfully booted up using Kernel 6.8.0-111. | `ai1.txt:L10` |
| **13:03:41** | Primary NIC (`enp10s0`, Intel I225-V) initialized at 1Gbps. | `ai1.txt:L127` |
| **13:29:19** | 💥 **CRITICAL FAILURE:** The system reported "PCIe link lost, device now detached". The NIC physically disconnected from the bus. | `ai1.txt:L160` |
| **13:29:19** | Kernel Driver (`igc`) threw a warning: "Failed to read reg 0xc030" (Device not responding). | `ai1.txt:L162` |
| **13:29 - 14:59** | **Downtime Period.** Server unreachable externally. IT Admin confirmed server was running locally but had no network. | N/A |
| **14:59:56** | IT Admin performed a hard restart. Orderly shutdown logs recorded. | `ai1.txt:L208` |
| **15:00:00** | System successfully rebooted and connectivity was restored. | `ai1.txt:L4` |

#### 3. Root Cause Analysis
The failure was identified as a **PCIe Link Loss** on the **Intel I225-V (enp10s0)** network controller. 

*   **Hardware Instability:** The logs show that the device "fell off" the PCIe bus. This is a known issue with early revisions of the Intel I225-V controller where signal integrity issues or power management states (ASPM) cause the link to drop.
*   **Kernel Factor:** The system recently upgraded to Kernel **6.8.0**, which may have changed how the `igc` driver manages power, potentially exacerbating an existing hardware weakness.
*   **Physical Connectivity:** The NIC is running on a single PCIe x1 lane (Line 686). Any minor electrical fluctuation or loose seating in the slot can cause the link to drop permanently until a power cycle.

#### 4. Impact Assessment
*   **Management (High):** Complete loss of SSH and Dashboard access via `20.1.1.130`.
*   **Public Access (High):** Users could not connect to streams via `103.115.236.34`.
*   **Internal Storage (Low/None):** The **10GbE Aquantia NIC** (`enp11s0`) was **NOT affected**. It stayed up the entire time. `ai2` remained stable because it handles its own compute, but it could not talk to `ai1`'s management IP.

#### 5. Recommended Actions

| Priority | Action Item | Responsibility |
| :--- | :--- | :--- |
| **Urgent** | **Physical Reseat:** Open the chassis and physically reseat the NIC or move it to a different PCIe slot. | IT Admin |
| **Medium** | **BIOS Update:** Check for ASUS motherboard BIOS updates (Current: 1512) that might address PCIe stability. | IT Admin |
| **Proactive** | **Failover Config:** Configure the 10GbE NIC (`enp11s0`) as a secondary management path so you can still access the server if the 1GbE NIC fails. | Punith / DevOps |
| **Monitoring** | **Alerting Script:** Deploy a script to `ai2` that pings `ai1` every minute and sends a Telegram/Email alert if unreachable. | Punith |

---
*Report generated based on diagnostic data in tests\ai1.txt.*
