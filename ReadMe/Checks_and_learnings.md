## to get the node allocation of filestore!!
# On ai1
sudo -u postgres psql -d laas -c "SELECT storage_uid, user_id, node_id, status, created_at FROM user_storage_volumes WHERE storage_uid = 'u_0bce6ab83ec044f80a41a494';"

# Also check the user
sudo -u postgres psql -d laas -c "SELECT id, email, first_name, last_name FROM users WHERE email = 'test-user@ksrce.ac.in';"

# Get the node information
sudo -u postgres psql -d laas -c "SELECT n.hostname, n.ip_management, n.ip_compute, n.ip_storage FROM nodes n JOIN user_storage_volumes v ON v.node_id = n.id WHERE v.storage_uid = 'u_0bce6ab83ec044f80a41a494';"


# running instance by user
sudo -u postgres psql -d laas -c "
SELECT 
  s.id, 
  u.email, 
  s.node_id, 
  n.hostname, 
  s.status, 
  s.instance_name, 
  cc.slug AS config_slug 
FROM sessions s
JOIN users u ON s.user_id = u.id
LEFT JOIN nodes n ON s.node_id = n.id
JOIN compute_configs cc ON s.compute_config_id = cc.id
WHERE s.status IN ('pending', 'starting', 'running', 'reconnecting');
"
# allocatable resources by a node
sudo -u postgres psql -d laas -c "
SELECT 
  n.hostname,
  n.allocated_vcpu AS node_table_allocated_vcpu,
  SUM(COALESCE(s.allocated_vcpu, cc.vcpu)) AS active_sessions_sum_vcpu,
  n.allocated_gpu_vram_mb AS node_table_allocated_vram,
  SUM(COALESCE(s.allocated_gpu_vram_mb, cc.gpu_vram_mb)) AS active_sessions_sum_vram
FROM sessions s
JOIN nodes n ON s.node_id = n.id
JOIN compute_configs cc ON s.compute_config_id = cc.id
WHERE s.status IN ('pending', 'starting', 'running', 'reconnecting')
GROUP BY n.hostname, n.allocated_vcpu, n.allocated_gpu_vram_mb;
"



# if the system shutdown and all where unmounted!!
for dev in /dev/zvol/datapool/users/u_*; do
  uid=$(basename "$dev")
  mountpoint="/datapool/users/$uid"
  
  # Check if already mounted
  if ! mountpoint -q "$mountpoint"; then
    echo "----------------------------------------"
    echo "Mounting $uid at $mountpoint..."
    sudo mkdir -p "$mountpoint"
    
    # Attempt to mount
    if sudo mount "$dev" "$mountpoint"; then
      sudo chown -R 1000:1000 "$mountpoint"
      echo "✅ Successfully mounted and set permissions for $uid"
    else
      echo "❌ FAILED to mount $uid. Filesystem might need fsck!"
    fi
  else
    echo "ℹ️ $uid is already mounted."
  fi
done


#check and remount
sudo -u postgres psql -d laas -c "
SELECT 
  v.id AS volume_id, 
  v.storage_uid, 
  n.hostname AS host_name, 
  v.status, 
  v.name AS volume_name,
  u.email
FROM user_storage_volumes v 
LEFT JOIN users u ON v.user_id = u.id
LEFT JOIN nodes n ON v.node_id = n.id 
WHERE u.email = 'sree3092006cse24_27@ksrce.ac.in' 
   OR v.storage_uid = 'u_f7c168fd388391aabd009cea';
"

on that machine
mount | grep u_f7c168fd388391aabd009cea


# 1. Ensure the mount directory exists
sudo mkdir -p /datapool/users/u_f7c168fd388391aabd009cea

# 2. Mount the zvol
sudo mount /dev/zvol/datapool/users/u_f7c168fd388391aabd009cea /datapool/users/u_f7c168fd388391aabd009cea

# 3. Apply correct ownership
sudo chown -R 1000:1000 /datapool/users/u_f7c168fd388391aabd009cea


# get back files after docker restart or system restart!!
# Run this on aiserver1 to mount all ended session disks
for dev in /dev/zvol/datapool/users/u_*; do
  uid=$(basename "$dev")
  mountpoint="/datapool/users/$uid"
  if ! mountpoint -q "$mountpoint"; then
    sudo mkdir -p "$mountpoint"
    sudo mount "$dev" "$mountpoint"
    sudo chown -R 1000:1000 "$mountpoint"
  fi
done


# some remdy for nvme checks (to not retry forever!!)
sudo nvme connect -t tcp -a <target_ip> -s 4420 -n <subsystem_name> -c 30 -k 5

# VI
when you stop the instance directly in DB, ensure you reset those allocation resource state in the DB as well!!

## 1. Clear ALL resource reservations (since 0 sessions are running, there should be 0 reservations)
sudo -u postgres psql -d laas -c "
DELETE FROM node_resource_reservations;
"

## 2. Reset all allocated resources and the session count counter to 0 on all nodes
sudo -u postgres psql -d laas -c "
UPDATE nodes 
SET 
  allocated_vcpu = 0, 
  allocated_memory_mb = 0, 
  allocated_gpu_vram_mb = 0,
  current_session_count = 0;
"

# DB dump
# 1. Generate the pg_dump file in /tmp
sudo -u postgres pg_dump -d laas -F c -f /tmp/laas_prod_backup_$(date +%Y%m%d_%H%M%S).dump

# 2. Move the backup file to /opt/backups/
sudo mv /tmp/laas_prod_backup_*.dump /opt/backups/


Note: emphemeral zvol provisions are garbage-cleaned when corresponding docker instance is deleted!!

Here is the exact explanation of why the ephemeral listings disappeared and how they are handled under the hood:

The Secret: The Background Daemon Cleanup Loop
Inside the session-orchestration service (app.py), there is a background cleanup loop called _ephemeral_cleanup_loop that runs periodically.

When it runs, it executes the function cleanup_orphaned_ephemeral_zvols():

How Ephemeral Storage Works: When a user starts an ephemeral session with dedicated storage (e.g. 10GB), the system creates a temporary ZFS block device (zvol) on the node at: datapool/ephemeral/sess_{session_id}
The Cleanup Trigger: When the container stops, exits, or is deleted (or when you set the sessi on status to ended in the database, causing the orchestrator to detect that the container is no longer active):
The background loop scans datapool/ephemeral on the host.
It checks Docker to see if there is any active container matching that session_id.
Since the container is stopped or removed, it identifies the ZFS dataset datapool/ephemeral/sess_{session_id} as an orphan.
It immediately runs zfs destroy on it to reclaim the 10GB storage block.
Summary
Because the background orchestrator daemon is working exactly as designed, as soon as those instances ended, it automatically wiped and destroyed the ephemeral ZFS datasets to free up the host's SSD storage.

This is why they no longer show up under zfs list on aiserver3—the system cleaned up after itself completely and reclaimed the space!


## you cal also same garbage collection setup for the stateful provisions as well (in other machine (nvme - disconnect) to remove state provision connection in other host machine in the cross-node scenario!!)


# where is it located!!
sudo -u postgres psql -d laas -c "
SELECT 
  u.email,
  u.storage_uid,
  v.status AS volume_status,
  n.hostname AS storage_node
FROM users u
LEFT JOIN user_storage_volumes v ON u.id = v.user_id
LEFT JOIN nodes n ON v.node_id = n.id
WHERE u.email = 'test-user11@ksrce.ac.in';
"


# 1. Check if the ZFS dataset exists on aiserver1
sudo zfs list | grep "u_00139336"

# 2. Check if it is currently mounted
mount | grep "u_00139336"



check and mount locally
# 1. Mount the ZFS volume locally on aiserver1
sudo mount /dev/zvol/datapool/users/u_ed4039243e178612df4522af /datapool/users/u_ed4039243e178612df4522af

# 2. Fix directory ownership
sudo chown -R 1000:1000 /datapool/users/u_ed4039243e178612df4522af


# Risky!!
# 1. Unmount the volume
sudo umount /datapool/users/u_00139336dea4e0beba0088d4

# 2. Run filesystem check and automatically repair errors (fsck)
sudo e2fsck -fy /dev/zvol/datapool/users/u_00139336dea4e0beba0088d4

# 3. Remount it
sudo mount /dev/zvol/datapool/users/u_00139336dea4e0beba0088d4 /datapool/users/u_00139336dea4e0beba0088d4

# 4. Re-run the permission fix
sudo chown -R 1000:1000 /datapool/users/u_00139336dea4e0beba0088d4



## delete file allocation of a user in the database alone!!
sudo -u postgres psql -d laas -c "
DO \$\$
DECLARE
  u_id uuid;
  v_id uuid;
BEGIN
  -- 1. Find the user ID from email
  SELECT id INTO u_id FROM users WHERE email = 'sowndharya2007it24-28@ksrce.ac.in';
  
  IF u_id IS NOT NULL THEN
    -- 2. Find their active storage volume ID
    SELECT id INTO v_id FROM user_storage_volumes WHERE user_id = u_id AND status = 'active';
    
    IF v_id IS NOT NULL THEN
      -- 3. Delete dependent billing charges
      DELETE FROM billing_charges WHERE storage_volume_id = v_id;
      
      -- 4. Delete dependent storage extensions
      DELETE FROM storage_extensions WHERE storage_volume_id = v_id;
      
      -- 5. Delete dependent OS switch history records
      DELETE FROM os_switch_history WHERE old_volume_id = v_id OR new_volume_id = v_id;
      
      -- 6. Delete the storage volume itself
      DELETE FROM user_storage_volumes WHERE id = v_id;
    END IF;
  END IF;
END \$\$;
"




sudo -u postgres psql -d laas -c "
BEGIN;

-- 1. Mark all active sessions as ended
UPDATE sessions
SET 
  status = 'ended',
  ended_at = NOW(),
  terminated_at = NOW(),
  termination_reason = 'admin_terminated',
  updated_at = NOW()
WHERE status IN ('pending', 'starting', 'running', 'reconnecting', 'stopping');

-- 2. Clear all active node resource reservations
DELETE FROM node_resource_reservations;

-- 3. Reset all allocated compute resources and session counters to 0 on all nodes
UPDATE nodes 
SET 
  allocated_vcpu = 0, 
  allocated_memory_mb = 0, 
  allocated_gpu_vram_mb = 0,
  current_session_count = 0,
  updated_at = NOW();

-- 4. Release all active wallet holds for these sessions
UPDATE wallet_holds
SET 
  status = 'released',
  released_at = NOW(),
  release_reason = 'session_terminated'
WHERE status = 'active';

COMMIT;
"



# getting windows subsystem back!!
GRUB_TIMEOUT_STYLE=menu
GRUB_TIMEOUT=10
GRUB_DISABLE_OS_PROBER=false

sudo update-grub



## Contengency : if this does not work out!!
zenith@zenith:~$ # 1. Change style from hidden to menu
sudo sed -i 's/GRUB_TIMEOUT_STYLE=hidden/GRUB_TIMEOUT_STYLE=menu/g' /etc/default/grub

# 2. Change timeout from 0 to 10 seconds
sudo sed -i 's/GRUB_TIMEOUT=0/GRUB_TIMEOUT=10/g' /etc/default/grub

# 3. Explicitly enable os-prober at the bottom of the file
echo 'GRUB_DISABLE_OS_PROBER=false' | sudo tee -a /etc/default/grub

# 4. Apply the changes
sudo update-grub
GRUB_DISABLE_OS_PROBER=false
Sourcing file `/etc/default/grub'
Sourcing file `/etc/default/grub.d/init-select.cfg'
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.15.0-181-generic
Found initrd image: /boot/initrd.img-5.15.0-181-generic
Found linux image: /boot/vmlinuz-5.15.0-176-generic
Found initrd image: /boot/initrd.img-5.15.0-176-generic
Warning: os-prober will be executed to detect other bootable partitions.
Its output will be used to detect bootable binaries on them and create new boot entries.
Found Windows Boot Manager on /dev/nvme0n1p1@/EFI/Microsoft/Boot/bootmgfw.efi
Adding boot menu entry for UEFI Firmware Settings ...
done
zenith@zenith:~$