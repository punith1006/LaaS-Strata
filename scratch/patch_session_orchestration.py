import os
import re

APP_PY = "c:\\Users\\Punith\\LaaS\\host-services\\session-orchestration\\app.py"

with open(APP_PY, "r", encoding="utf-8") as f:
    content = f.read()

# 1. Add call_storage_provision_remount function
new_remount_func = """
def call_storage_provision_remount(storage_node_ip: str, storage_uid: str, provision_secret: str = "") -> tuple[bool, str]:
    \"\"\"
    Call storage-provision service to remount local zvol on storage node.
    This restores local ext4 access after NVMe-oF setup fails.
    
    Returns (success, error_message).
    \"\"\"
    import requests
    
    if storage_node_ip and storage_node_ip != HOST_IP:
        provision_url = f"http://{storage_node_ip}:9999"
    else:
        provision_url = STORAGE_PROVISION_URL
    
    endpoint = f"{provision_url}/zvol/remount"
    secret = provision_secret or STORAGE_PROVISION_SECRET
    headers = {
        "X-Provision-Secret": secret,
        "Content-Type": "application/json"
    }
    payload = {"storageUid": storage_uid}
    
    try:
        logger.info(f"[STORAGE-PROV] Calling remount for {storage_uid} at {endpoint}")
        response = requests.post(endpoint, json=payload, headers=headers, timeout=15)
        if response.status_code == 200:
            data = response.json()
            logger.info(f"[STORAGE-PROV] Remount succeeded: {data.get('message', '')}")
            return True, ""
        else:
            error = response.json().get("error", f"HTTP {response.status_code}")
            logger.warning(f"[STORAGE-PROV] Remount failed: {error}")
            return False, error
    except Exception as e:
        logger.warning(f"[STORAGE-PROV] Remount error: {e}")
        return False, str(e)


def rollback_nvmeof"""

content = content.replace("def rollback_nvmeof", new_remount_func)

# 2. Update rollback_nvmeof signature and logic
old_rollback = """def rollback_nvmeof(completed_steps: List[str], mount_path: str, nvme_subsystem: str) -> None:
    \"\"\"Rollback completed NVMe-oF steps in REVERSE order.\"\"\"
    for step in reversed(completed_steps):
        try:
            if step == "mount":
                logger.info(f"[NVME-ROLLBACK] Unmounting {mount_path}...")
                subprocess.run(["sudo", "umount", mount_path], capture_output=True, timeout=10)
            elif step == "connect":
                logger.info(f"[NVME-ROLLBACK] Disconnecting {nvme_subsystem}...")
                subprocess.run(
                    ["sudo", "nvme", "disconnect", "-n", nvme_subsystem],
                    capture_output=True, timeout=10
                )
            elif step in ("find_device", "discover", "permissions"):
                pass  # Nothing to rollback"""

new_rollback = """def rollback_nvmeof(completed_steps: List[str], mount_path: str, nvme_subsystem: str, storage_node_ip: str = "", storage_uid: str = "", provision_secret: str = "") -> None:
    \"\"\"Rollback completed NVMe-oF steps in REVERSE order.\"\"\"
    for step in reversed(completed_steps):
        try:
            if step == "mount":
                logger.info(f"[NVME-ROLLBACK] Unmounting {mount_path}...")
                subprocess.run(["sudo", "umount", mount_path], capture_output=True, timeout=10)
            elif step == "connect":
                logger.info(f"[NVME-ROLLBACK] Disconnecting {nvme_subsystem}...")
                subprocess.run(
                    ["sudo", "nvme", "disconnect", "-n", nvme_subsystem],
                    capture_output=True, timeout=10
                )
            elif step == "remote_unmount":
                if storage_node_ip and storage_uid:
                    logger.info(f"[NVME-ROLLBACK] Remounting remote zvol on {storage_node_ip}...")
                    call_storage_provision_remount(storage_node_ip, storage_uid, provision_secret)
            elif step in ("find_device", "discover", "permissions"):
                pass  # Nothing to rollback"""

content = content.replace(old_rollback, new_rollback)

# 3. Fix NVME_STORAGE_IP override and append remote_unmount to completed_steps
old_setup_prep = """                logger.info(f"[NVME-PREP] Storage node local zvol unmounted successfully")
        
        # Step 1: DISCOVER
        # Use internal IP for NVMe discovery if NVME_STORAGE_IP is set (for 10GbE network)
        nvme_target_ip = NVME_STORAGE_IP if NVME_STORAGE_IP else storage_node_ip"""

new_setup_prep = """                logger.info(f"[NVME-PREP] Storage node local zvol unmounted successfully")
                completed_steps.append("remote_unmount")
        
        # Step 1: DISCOVER
        # Always use the storage_node_ip passed by the backend (this is node.ipStorage from the DB)
        nvme_target_ip = storage_node_ip"""

content = content.replace(old_setup_prep, new_setup_prep)

# 4. Update rollback_nvmeof call in setup_nvmeof_storage
content = content.replace(
    "rollback_nvmeof(completed_steps, mount_path, nvme_subsystem)",
    "rollback_nvmeof(completed_steps, mount_path, nvme_subsystem, storage_node_ip, storage_uid, provision_secret)"
)

with open(APP_PY, "w", encoding="utf-8") as f:
    f.write(content)

print("Patched app.py successfully!")
