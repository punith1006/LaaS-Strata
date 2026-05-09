# AI1 (ksrceai1) — Primary Node Setup Guide

**Machine**: ksrceai1 | **SSH**: `ssh ai1@103.115.236.52 -p 2223` | **Password**: Password@321  
**Static LAN IP**: 20.1.1.130 | **Role**: Primary (backend, frontend, Keycloak, DB, storage, compute)  
**GPU**: RTX 4090 (verify with nvidia-smi) | **CUDA_NVRTC_ARCH**: 89

> This guide mirrors the ai2 setup but adds PRIMARY node responsibilities (ZFS pool creation, NFS exports).  
> ai2 (20.1.1.132, RTX 5090) is already set up as COMPUTE-ONLY.

---

## PRE-SETUP: Verify Current State

```bash
ssh ai1@103.115.236.52 -p 2223

lsb_release -a
uname -r
nvidia-smi
nvidia-smi | grep "Driver Version"
```

---

## STEP 1: Verify/Upgrade NVIDIA Driver

Skip if `nvidia-smi` already shows driver 570.x.

```bash
# If driver < 570:
sudo apt purge -y nvidia* libnvidia* cuda* 2>/dev/null || true
sudo apt autoremove -y
sudo reboot

# After reboot:
sudo add-apt-repository ppa:graphics-drivers/ppa -y

# 1. Remove the blocked PPA
# sudo add-apt-repository --remove ppa:graphics-drivers/ppa -y
sudo apt update

sudo apt install -y nvidia-driver-570 nvidia-utils-570
# sudo apt install -y nvidia-driver-595-open nvidia-utils-595
sudo reboot

nvidia-smi
# Expected: Driver Version: 570.x.x, CUDA Version: 12.8
```

---

## STEP 2: Baseline System Packages

```bash
sudo apt update && sudo apt upgrade -y

sudo apt install -y \
  build-essential cmake git curl wget \
  pkg-config software-properties-common apt-transport-https \
  ca-certificates gnupg lsb-release htop nvtop net-tools \
  zfsutils-linux nfs-kernel-server \
  apparmor apparmor-utils \
  python3 python3-pip python3-venv

lscpu | grep "CPU(s)" | head -1
free -h | grep "^Mem"
lsblk
```

---

## STEP 3: Enable Persistence Mode

```bash
sudo nvidia-smi -pm 1
nvidia-smi | grep "Persistence"
# Expected: Persistence-M: On
```

---

## STEP 4: Install CUDA Toolkit 12.8

```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt update
sudo apt install -y cuda-toolkit-12-8

echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc

nvcc --version
# Expected: release 12.8
```

---

## STEP 5: Docker CE + NVIDIA Container Toolkit

```bash
curl -fsSL https://get.docker.com | sudo bash
sudo usermod -aG docker $USER
newgrp docker

docker --version
docker run --rm hello-world

# NVIDIA Container Toolkit
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
  sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt update && sudo apt install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# Test GPU in Docker
docker run --rm --gpus all ubuntu:22.04 bash -c \
  'apt-get install -y pciutils -q 2>/dev/null && lspci | grep -i nvidia'

docker run --rm --gpus all ubuntu:22.04 nvidia-smi

```

---

## STEP 6: Build HAMi-core (libvgpu.so)

> **Known Issue from ai2**: If build from latest HEAD causes initialization failures, copy the working binary from ai2: `scp ai2@20.1.1.132:/usr/lib/libvgpu.so /tmp/libvgpu-from-ai2.so`

```bash
cd ~
git clone https://github.com/Project-HAMi/HAMi-core.git
cd HAMi-core
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)

ls -la libvgpu.so
# Expected: ~418784 bytes

# Install to /usr/lib (NOT /usr/local/lib — that causes silent LD_PRELOAD failures)
sudo cp libvgpu.so /usr/lib/libvgpu.so
sudo chmod 755 /usr/lib/libvgpu.so
sudo ldconfig

ls -la /usr/lib/libvgpu.so
sudo cp /usr/lib/libvgpu.so /usr/lib/libvgpu.so.backup
```

---

## STEP 7: CUDA MPS Daemon

```bash
sudo tee /etc/systemd/system/cuda-mps.service > /dev/null << 'EOF'
[Unit]
Description=CUDA MPS Control Daemon
After=nvidia-persistenced.service

[Service]
Type=forking
Environment=CUDA_VISIBLE_DEVICES=0
Environment=CUDA_MPS_PIPE_DIRECTORY=/tmp/nvidia-mps
Environment=CUDA_MPS_LOG_DIRECTORY=/tmp/nvidia-log
ExecStartPre=/usr/bin/nvidia-smi -pm 1
ExecStart=/usr/bin/nvidia-cuda-mps-control -d
ExecStop=/bin/bash -c "echo quit | /usr/bin/nvidia-cuda-mps-control"
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now cuda-mps
sudo systemctl status cuda-mps
```

---

## STEP 8: ZFS + NFS Storage (PRIMARY NODE ONLY)

> This is the key difference from ai2. ai1 creates and manages the ZFS pool and exports via NFS.

### 8.1 Identify Storage Partition

```bash
lsblk
sudo fdisk -l /dev/nvme0n1 | grep -E "^/dev"
# Look for a dedicated partition for storage
```

### 8.2 Create ZFS Pool

**Option A — Dedicated partition (recommended):**
```bash
# Replace /dev/nvme0n1p3 with your actual partition
sudo zpool create -f datapool /dev/nvme0n1p3
sudo zfs create datapool/users
sudo zpool status datapool
sudo zfs list datapool
```

**Option B — File-backed (POC fallback only):**
```bash
sudo mkdir -p /vg_containers
sudo truncate -s 300G /vg_containers/nas_pool.img
sudo zpool create -f datapool /vg_containers/nas_pool.img
sudo zfs create datapool/users
```

### 8.3 Create Test User Datasets

```bash
for i in 1 2 3 4; do
  sudo zfs create -o quota=15G datapool/users/testuser$i
done
sudo zfs create datapool/ephemeral
sudo zfs list datapool/users
```

### 8.4 Export via NFS (to ai2)

```bash
# Export to ai2 compute node
echo '/datapool/users 20.1.1.132(rw,sync,no_subtree_check,no_root_squash)' | \
  sudo tee -a /etc/exports

# Export to localhost
echo '/datapool/users 127.0.0.1(rw,sync,no_subtree_check,no_root_squash)' | \
  sudo tee -a /etc/exports

sudo exportfs -ra
sudo systemctl restart nfs-kernel-server

# Verify
sudo exportfs -v

# Mount locally
sudo mkdir -p /mnt/nfs/users
sudo mount -t nfs4 127.0.0.1:/datapool/users /mnt/nfs/users
df -h /mnt/nfs/users

# Persist in fstab
echo '127.0.0.1:/datapool/users /mnt/nfs/users nfs4 defaults 0 0' | \
  sudo tee -a /etc/fstab
```

---

## STEP 9: lxcfs (Resource Visibility)

```bash
sudo apt install -y lxcfs
sudo systemctl enable --now lxcfs
sudo systemctl status lxcfs

ls /var/lib/lxcfs/proc/
# Must see: cpuinfo meminfo stat uptime loadavg diskstats swaps
```

---

## STEP 10: fake_sysconf.so (RAM Display Fix)

```bash
cat > /tmp/fake_sysconf.c << 'EOF'
#define _GNU_SOURCE
#include <unistd.h>
#include <dlfcn.h>
#include <stdlib.h>
#include <string.h>

long sysconf(int name) {
    static long (*real_sysconf)(int) = NULL;
    if (!real_sysconf)
        real_sysconf = dlsym(RTLD_NEXT, "sysconf");

    if (name == _SC_PHYS_PAGES || name == _SC_AVPHYS_PAGES) {
        const char *limit = getenv("CONTAINER_MEMORY_LIMIT_BYTES");
        if (limit) {
            long page_size = real_sysconf(_SC_PAGESIZE);
            long limit_bytes = atol(limit);
            long pages = limit_bytes / page_size;
            if (name == _SC_AVPHYS_PAGES)
                return (long)(pages * 0.85);
            return pages;
        }
    }
    return real_sysconf(name);
}
EOF

gcc -shared -fPIC -o /tmp/fake_sysconf.so /tmp/fake_sysconf.c -ldl
sudo cp /tmp/fake_sysconf.so /usr/lib/fake_sysconf.so
ls -la /usr/lib/fake_sysconf.so
```

---

## STEP 11: Host-Side Container Files

### 11.1 Pull Selkies Image

```bash
docker pull ghcr.io/selkies-project/nvidia-egl-desktop:latest
docker images | grep selkies
```

### 11.2 nvidia-smi Wrapper

```bash
cat > /tmp/nvidia-smi-wrapper << 'WRAPPER_EOF'
#!/bin/bash
get_vram_limit_mib() {
  if [ -n "$CUDA_DEVICE_MEMORY_LIMIT_0" ]; then
    VAL="${CUDA_DEVICE_MEMORY_LIMIT_0,,}"
    if [[ "$VAL" == *"m" ]]; then
      echo "${VAL//m/}"
    elif [[ "$VAL" == *"g" ]]; then
      echo $(( ${VAL//g/} * 1024 ))
    fi
    return
  fi
  python3 -c "
import struct
with open('/tmp/cudevshr.cache','rb') as f:
    d=f.read(4096)
print(struct.unpack_from('<Q',d,1600)[0]//(1024*1024))
" 2>/dev/null || echo "0"
}

case "$*" in
  *"-pm"*|*"--persistence-mode"*|*"-pl"*|*"--power-limit"*|\
  *"--query-gpu"*|*"--format"*|*"-i "*|*"--id"*)
    exec env -u LD_PRELOAD /usr/bin/nvidia-smi.real "$@"
    ;;
esac

LIMIT_MIB=$(get_vram_limit_mib)
REAL_OUT=$(env -u LD_PRELOAD /usr/bin/nvidia-smi.real "$@" 2>&1)

if [ -n "$LIMIT_MIB" ] && [ "$LIMIT_MIB" -gt "0" ] 2>/dev/null; then
  echo "$REAL_OUT" | sed "s|/ [0-9]*MiB|/ ${LIMIT_MIB}MiB|g"
else
  echo "$REAL_OUT"
fi
WRAPPER_EOF

chmod +x /tmp/nvidia-smi-wrapper
```

### 11.3 passwd Wrapper

```bash
cat > /tmp/passwd-wrapper << 'EOF'
#!/bin/bash
exec env -u LD_PRELOAD /usr/bin/passwd.real "$@"
EOF
chmod +x /tmp/passwd-wrapper
```

### 11.4 bash.bashrc with HAMi + sysconf Injection

```bash
docker run --rm --entrypoint cat \
  ghcr.io/selkies-project/nvidia-egl-desktop:latest \
  /etc/bash.bashrc > /tmp/bash.bashrc.orig

cat >> /tmp/bash.bashrc.orig << 'EOF'

# LaaS resource interceptors
if [ "${HAMI_INJECTED}" != "1" ]; then
  export LD_PRELOAD="/usr/lib/libvgpu.so /usr/lib/fake_sysconf.so"
  export HAMI_INJECTED=1
  export SYSCONF_INJECTED=1
  mkdir -p /tmp/vgpulock 2>/dev/null
fi
EOF

chmod 644 /tmp/bash.bashrc.orig
```

### 11.5 supervisord Configuration

Create file `/tmp/supervisord-hami.conf` with the standard LaaS supervisord config. This is the same config used on ai2, containing:
- entrypoint program with `LD_PRELOAD=/usr/lib/fake_sysconf.so` only (NO libvgpu — crashes VGL)
- selkies-gstreamer with `LD_PRELOAD=/usr/lib/libvgpu.so` only (NO fake_sysconf — causes SIGSEGV)
- dbus, nginx, kasmvnc, pipewire group (pipewire, wireplumber, pipewire-pulse)

You can copy this directly from ai2:
```bash
scp ai2@20.1.1.132:/tmp/supervisord-hami.conf /tmp/supervisord-hami.conf
```

Or use the version from `c:\Users\Punith\LaaS\host-services\config\supervisord-hami.conf` (SCP from your dev machine).

### 11.6 SM% Calculator

```bash
sudo tee /usr/local/bin/calc-sm-percent << 'EOF'
#!/bin/bash
CONTAINER_VRAM=${1:?Usage: calc-sm-percent <container_vram_gb> <total_gpu_vram_gb>}
TOTAL_VRAM=${2:?Usage: calc-sm-percent <container_vram_gb> <total_gpu_vram_gb>}
PCT=$(( (CONTAINER_VRAM * 100) / TOTAL_VRAM ))
[ $PCT -lt 5 ] && PCT=5
echo $PCT
EOF

sudo chmod +x /usr/local/bin/calc-sm-percent

# Test (RTX 4090 = 24GB)
for v in 4 8 12 16 24; do
  echo "${v}GB → $(calc-sm-percent $v 24)% SMs"
done
```

### 11.7 vgpulock Directories

```bash
for i in 1 2 3 4; do
  sudo mkdir -p /tmp/vgpulock-$i
  sudo chmod 777 /tmp/vgpulock-$i
done
```

### 11.8 Static CPU Sys Files

```bash
for i in 1 2 3 4; do
  CPUSET_START=$(( ($i-1)*4 ))
  CPUSET_END=$(( ($i-1)*4+3 ))
  CPUSET="${CPUSET_START}-${CPUSET_END}"
  mkdir -p /tmp/container-$i-cpu
  echo "$CPUSET" > /tmp/container-$i-cpu/online
  echo "$CPUSET" > /tmp/container-$i-cpu/present
  echo "$CPUSET" > /tmp/container-$i-cpu/possible
  echo ""         > /tmp/container-$i-cpu/offline
  echo ""         > /tmp/container-$i-cpu/isolated
  chmod 444 /tmp/container-$i-cpu/*
  echo "Container $i → cpuset: $CPUSET"
done
```

### 11.9 Verify All Files

```bash
echo '=== Required host-side files ==='
ls -la /usr/lib/libvgpu.so
ls -la /usr/lib/fake_sysconf.so
ls -la /tmp/nvidia-smi-wrapper
ls -la /tmp/passwd-wrapper
ls -la /tmp/bash.bashrc.orig
ls -la /tmp/supervisord-hami.conf
ls -la /var/lib/lxcfs/proc/meminfo
ls -la /tmp/vgpulock-1 /tmp/vgpulock-2 /tmp/vgpulock-3 /tmp/vgpulock-4
ls -la /tmp/container-1-cpu/online
ls -la /mnt/nfs/users/
echo '=== All present if no errors above ==='
```

---

## STEP 12: Test Container Launch

```bash
i=1
NGINX_P=8081
SELKIES_P=9081
DISPLAY_N=20
CPUSET=0-3
VRAM_GB=4
TOTAL_VRAM_GB=24
SM_PCT=$(/usr/local/bin/calc-sm-percent $VRAM_GB $TOTAL_VRAM_GB)
MEM_BYTES=$((8*1024*1024*1024))
SESSION_HOST="ws-$(openssl rand -hex 4)"
TOKEN=$(openssl rand -hex 16)

echo "Test: Port=$NGINX_P Token=$TOKEN VRAM=${VRAM_GB}GB SM=${SM_PCT}%"

docker run -d \
  --name selkies-test-1 \
  --hostname $SESSION_HOST \
  --gpus all \
  --cpus=4 --cpuset-cpus=$CPUSET --memory=8g \
  --ipc=host --network=host --tmpfs /dev/shm:rw \
  -e TZ=UTC \
  -e DISPLAY=:$DISPLAY_N \
  -e DISPLAY_SIZEW=1920 -e DISPLAY_SIZEH=1080 -e DISPLAY_REFRESH=60 \
  -e SELKIES_ENCODER=nvh264enc \
  -e SELKIES_ENABLE_BASIC_AUTH=true \
  -e SELKIES_BASIC_AUTH_PASSWORD=$TOKEN \
  -e NGINX_PORT=$NGINX_P -e SELKIES_PORT=$SELKIES_P \
  -e PASSWD=laasuser \
  -e CUDA_VISIBLE_DEVICES=0 -e CUDA_NVRTC_ARCH=89 \
  -e __NV_PRIME_RENDER_OFFLOAD=1 -e __GLX_VENDOR_LIBRARY_NAME=nvidia \
  -e CUDA_DEVICE_MEMORY_LIMIT_0=${VRAM_GB}192m \
  -e CUDA_DEVICE_SM_LIMIT=$SM_PCT \
  -e CUDA_MPS_PINNED_DEVICE_MEM_LIMIT="0=${VRAM_GB}G" \
  -e CUDA_MPS_ACTIVE_THREAD_PERCENTAGE=$SM_PCT \
  -e CUDA_MPS_ENABLE_PER_CTX_DEVICE_MULTIPROCESSOR_PARTITIONING=1 \
  -e CONTAINER_MEMORY_LIMIT_BYTES=$MEM_BYTES \
  -v /mnt/nfs/users/testuser1:/home/ubuntu \
  -v /usr/lib/libvgpu.so:/usr/lib/libvgpu.so \
  -v /usr/lib/fake_sysconf.so:/usr/lib/fake_sysconf.so \
  -v /tmp/vgpulock-1:/tmp/vgpulock \
  -v /usr/bin/nvidia-smi:/usr/bin/nvidia-smi.real \
  -v /tmp/nvidia-smi-wrapper:/usr/bin/nvidia-smi \
  -v /usr/bin/passwd:/usr/bin/passwd.real \
  -v /tmp/passwd-wrapper:/usr/bin/passwd \
  -v /tmp/supervisord-hami.conf:/etc/supervisord.conf \
  -v /tmp/bash.bashrc.orig:/etc/bash.bashrc \
  -v /var/lib/lxcfs/proc/cpuinfo:/proc/cpuinfo:ro \
  -v /var/lib/lxcfs/proc/meminfo:/proc/meminfo:ro \
  -v /var/lib/lxcfs/proc/stat:/proc/stat:ro \
  -v /var/lib/lxcfs/proc/uptime:/proc/uptime:ro \
  -v /var/lib/lxcfs/proc/loadavg:/proc/loadavg:ro \
  -v /var/lib/lxcfs/proc/diskstats:/proc/diskstats:ro \
  -v /var/lib/lxcfs/proc/swaps:/proc/swaps:ro \
  -v /tmp/container-1-cpu:/sys/devices/system/cpu:ro \
  ghcr.io/selkies-project/nvidia-egl-desktop:latest

sleep 20
docker logs selkies-test-1 | tail -20
docker ps | grep selkies-test-1

# Cleanup after testing
docker stop selkies-test-1 && docker rm selkies-test-1
```

---

## STEP 13: Final Validation

```bash
echo "=== Service Status ==="
sudo systemctl status cuda-mps | grep Active
sudo systemctl status lxcfs | grep Active
sudo systemctl status nfs-kernel-server | grep Active

echo "=== lxcfs Files ==="
ls /var/lib/lxcfs/proc/ | wc -l

echo "=== HAMi Library ==="
ls -la /usr/lib/libvgpu.so

echo "=== ZFS Pool ==="
sudo zpool status datapool
sudo zfs list datapool

echo "=== NFS Exports ==="
sudo exportfs -v | grep datapool

echo "=== Docker GPU ==="
docker run --rm --gpus all nvidia/cuda:12.8.0-base-ubuntu22.04 nvidia-smi | head -5

echo "=== LAN Connectivity to ai2 ==="
ping -c 3 20.1.1.132
```

---

## Key Differences: ai1 vs ai2

| Component | ai1 (PRIMARY - 20.1.1.130) | ai2 (COMPUTE - 20.1.1.132) |
|---|---|---|
| ZFS Pool | Creates and manages datapool | None |
| NFS Server | Exports /datapool/users | Mounts from ai1 |
| GPU | RTX 4090 (CUDA_NVRTC_ARCH=89) | RTX 5090 (CUDA_NVRTC_ARCH=100) |
| Backend/Frontend/Keycloak | YES | NO |
| Storage Provision (port 9999) | YES | NO |
| Session Orchestration (port 9998) | YES | Receives instructions |
| CoTURN | Runs TURN server | Connects to ai1's TURN |

## Known Issues from ai2 Setup

1. **libvgpu.so path**: Must be `/usr/lib/`, NOT `/usr/local/lib/`
2. **HAMi build regression**: If init fails, copy working binary from ai2
3. **fake_sysconf.so + selkies-gstreamer**: Causes SIGSEGV — only load in bash/entrypoint, not gstreamer
4. **NFS mount failures**: Check `nfs-kernel-server` status and firewall port 2049

## Next Steps After This Guide

1. Install Tailscale on ai1 for public IP
2. Configure CoTURN with Tailscale IP
3. Deploy backend, frontend, Keycloak, PostgreSQL
4. Deploy session-orchestration and storage-provision host services
5. Mount ai1's NFS on ai2
6. End-to-end session launch test
