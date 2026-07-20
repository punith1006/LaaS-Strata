# LaaS Host Services Startup & Recovery Guide

This document contains the exact commands required to bring the **Storage Provisioner** and **Session Orchestrator** services back online on all nodes (`ai1` to `ai5`) following system restarts or power failures.

---

## 1. Network Layout Reference

### Management Network (`enp10s0` / 2.5 Gbps)
* **ai1:** `20.1.1.130`
* **ai2:** `20.1.1.132`
* **ai3:** `20.1.1.134`
* **ai4:** `20.1.1.136`
* **ai5:** `20.1.1.138`

### Storage Network (`enp11s0` / 10 Gbps)
* **ai1:** `10.10.100.130`
* **ai2:** `10.10.100.132`
* **ai3:** `10.10.100.134`
* **ai4:** `10.10.100.136`
* **ai5:** `10.10.100.138`

### Public-Facing Connection Details
* **ai1:** `103.115.236.34:2223`
* **ai2:** `103.115.236.35:2224`
* **ai3:** `103.115.236.36:2225`
* **ai4:** `103.115.236.37:2226`
* **ai5:** `103.115.236.38:2227`

---

## 2. Storage Provisioner (`storage-provision`)

Run these commands inside the `host-services/storage-provision` directory on the respective host.

> [!NOTE]
> Each host's `NFS_EXPORT_CLIENT` list excludes its own 10G IP and replaces it with `127.0.0.1` to prevent network interface looping.

### **`ai1` (aiserver1)**
```bash
PROVISION_SECRET=e75064ca1702889e4f519d4ad40dfbd5f18dbdb67db7f365 ENABLE_NFS_AUTOMOUNT=true STORAGE_IP=10.10.100.130 FLASK_HOST=0.0.0.0 FLASK_PORT=9999 NFS_EXPORT_CLIENT="10.10.100.132(rw,sync,no_subtree_check,no_root_squash) 10.10.100.134(rw,sync,no_subtree_check,no_root_squash) 10.10.100.136(rw,sync,no_subtree_check,no_root_squash) 10.10.100.138(rw,sync,no_subtree_check,no_root_squash) 127.0.0.1" python3 app.py
```

### **`ai2` (aiserver2)**
```bash
PROVISION_SECRET=e75064ca1702889e4f519d4ad40dfbd5f18dbdb67db7f365 ENABLE_NFS_AUTOMOUNT=true STORAGE_IP=10.10.100.132 FLASK_HOST=0.0.0.0 FLASK_PORT=9999 NFS_EXPORT_CLIENT="10.10.100.130(rw,sync,no_subtree_check,no_root_squash) 10.10.100.134(rw,sync,no_subtree_check,no_root_squash) 10.10.100.136(rw,sync,no_subtree_check,no_root_squash) 10.10.100.138(rw,sync,no_subtree_check,no_root_squash) 127.0.0.1" python3 app.py
```

### **`ai3` (aiserver3)**
```bash
PROVISION_SECRET=e75064ca1702889e4f519d4ad40dfbd5f18dbdb67db7f365 ENABLE_NFS_AUTOMOUNT=true STORAGE_IP=10.10.100.134 FLASK_HOST=0.0.0.0 FLASK_PORT=9999 NFS_EXPORT_CLIENT="10.10.100.130(rw,sync,no_subtree_check,no_root_squash) 10.10.100.132(rw,sync,no_subtree_check,no_root_squash) 10.10.100.136(rw,sync,no_subtree_check,no_root_squash) 10.10.100.138(rw,sync,no_subtree_check,no_root_squash) 127.0.0.1" python3 app.py
```

### **`ai4` (aiserver4)**
```bash
PROVISION_SECRET=e75064ca1702889e4f519d4ad40dfbd5f18dbdb67db7f365 ENABLE_NFS_AUTOMOUNT=true STORAGE_IP=10.10.100.136 FLASK_HOST=0.0.0.0 FLASK_PORT=9999 NFS_EXPORT_CLIENT="10.10.100.130(rw,sync,no_subtree_check,no_root_squash) 10.10.100.132(rw,sync,no_subtree_check,no_root_squash) 10.10.100.134(rw,sync,no_subtree_check,no_root_squash) 10.10.100.138(rw,sync,no_subtree_check,no_root_squash) 127.0.0.1" python3 app.py
```

### **`ai5` (aiserver5)**
```bash
PROVISION_SECRET=e75064ca1702889e4f519d4ad40dfbd5f18dbdb67db7f365 ENABLE_NFS_AUTOMOUNT=true STORAGE_IP=10.10.100.138 FLASK_HOST=0.0.0.0 FLASK_PORT=9999 NFS_EXPORT_CLIENT="10.10.100.130(rw,sync,no_subtree_check,no_root_squash) 10.10.100.132(rw,sync,no_subtree_check,no_root_squash) 10.10.100.134(rw,sync,no_subtree_check,no_root_squash) 10.10.100.136(rw,sync,no_subtree_check,no_root_squash) 127.0.0.1" python3 app.py
```

---

## 3. Session Orchestration (`session-orchestration`)

Run these commands inside the `host-services/session-orchestration` directory on the respective host.

### **`ai1` (aiserver1)**
```bash
SESSION_SECRET=laas-session-secret-dev HOST_IP=103.115.236.34 TURN_HOST=103.115.236.34 STORAGE_PROVISION_URL=http://10.10.100.130:9999 NVME_STORAGE_IP=10.10.100.130 STORAGE_PROVISION_SECRET=e75064ca1702889e4f519d4ad40dfbd5f18dbdb67db7f365 python3 app.py
```

### **`ai2` (aiserver2)**
```bash
SESSION_SECRET=laas-session-secret-dev HOST_IP=103.115.236.35 TURN_HOST=103.115.236.35 STORAGE_PROVISION_URL=http://10.10.100.132:9999 NVME_STORAGE_IP=10.10.100.132 STORAGE_PROVISION_SECRET=e75064ca1702889e4f519d4ad40dfbd5f18dbdb67db7f365 python3 app.py
```

### **`ai3` (aiserver3)**
```bash
SESSION_SECRET=laas-session-secret-dev HOST_IP=103.115.236.36 TURN_HOST=103.115.236.36 STORAGE_PROVISION_URL=http://10.10.100.134:9999 NVME_STORAGE_IP=10.10.100.134 STORAGE_PROVISION_SECRET=e75064ca1702889e4f519d4ad40dfbd5f18dbdb67db7f365 python3 app.py
```

### **`ai4` (aiserver4)**
```bash
SESSION_SECRET=laas-session-secret-dev HOST_IP=103.115.236.37 TURN_HOST=103.115.236.37 STORAGE_PROVISION_URL=http://10.10.100.136:9999 NVME_STORAGE_IP=10.10.100.136 STORAGE_PROVISION_SECRET=e75064ca1702889e4f519d4ad40dfbd5f18dbdb67db7f365 python3 app.py
```

### **`ai5` (aiserver5)**
```bash
SESSION_SECRET=laas-session-secret-dev HOST_IP=103.115.236.38 TURN_HOST=103.115.236.38 STORAGE_PROVISION_URL=http://10.10.100.138:9999 NVME_STORAGE_IP=10.10.100.138 STORAGE_PROVISION_SECRET=e75064ca1702889e4f519d4ad40dfbd5f18dbdb67db7f365 python3 app.py
```

---

## 4. Database Fleet Reset Sweep (Audit-Safe)

Run this SQL transaction block on **`aiserver1`** to reset the active states of all nodes, release wallet holds, release node resource reservations (without deleting them, to preserve the audit trail), and mark all active sessions as ended:

```bash
sudo -u postgres psql -d laas -c "
BEGIN;

-- 1. Safely release all active resource reservations (preserving audit records)
UPDATE node_resource_reservations
SET 
  status = 'released',
  released_at = NOW(),
  updated_at = NOW()
WHERE status = 'reserved';

-- 2. Release all active wallet holds for these sessions
UPDATE wallet_holds
SET 
  status = 'released',
  released_at = NOW(),
  release_reason = 'session_terminated'
WHERE status = 'active'
  AND session_id IN (
    SELECT id FROM sessions 
    WHERE status IN ('pending', 'starting', 'running', 'reconnecting', 'stopping')
  );

-- 3. Reset allocated compute resource counters on all nodes to 0
UPDATE nodes
SET 
  allocated_vcpu = 0,
  allocated_memory_mb = 0,
  allocated_gpu_vram_mb = 0,
  current_session_count = 0,
  updated_at = NOW();

-- 4. Mark all active sessions as ended
UPDATE sessions
SET 
  status = 'ended',
  ended_at = NOW(),
  terminated_at = NOW(),
  termination_reason = 'admin_terminated',
  updated_at = NOW()
WHERE status IN ('pending', 'starting', 'running', 'reconnecting', 'stopping');

COMMIT;
"
```

---

## 5. Network Storage Cleanup & Local Remounting

Following a fleet reset, manual stops, or service restarts, you must disconnect lingering network storage connections on compute hosts and remount student storage locally on their home storage nodes so that file operations continue to function via the dashboard.

### Step 1: Disconnect NVMe-oF links on all Compute Nodes
Run this command on **`ai1` through `ai5`** to clear active network storage mappings:
```bash
sudo nvme disconnect-all
```

### Step 2: Remount all user storage locally on the Storage Nodes
Run this bash script on your storage hosts (**`aiserver1`**, **`aiserver2`**, and **`aiserver3`**) to mount ZFS volumes locally:

```bash
for dev in /dev/zvol/datapool/users/u_*; do
  uid=$(basename "$dev")
  mountpoint="/datapool/users/$uid"
  
  if [ -b "$dev" ]; then
    # Ensure local directory exists
    sudo mkdir -p "$mountpoint"
    
    # Mount locally if not already mounted
    if ! mountpoint -q "$mountpoint"; then
      echo "Mounting $uid locally..."
      if sudo mount "$dev" "$mountpoint"; then
        sudo chown -R 1000:1000 "$mountpoint"
        echo "✅ Mounted $uid successfully."
      else
        echo "❌ FAILED to mount $uid."
      fi
    else
      echo "ℹ️ $uid is already mounted."
    fi
  fi
done
```


