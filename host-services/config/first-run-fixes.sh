#!/bin/bash
# LaaS Container First-Run Fixes
# Runs once at container startup (via supervisord) to fix common desktop issues
# that make the container feel "not like a real Ubuntu system."
#
# Fixes applied:
#   1. man-db permissions — prevents "Permission denied" during apt install
#   2. DBus system bus — creates the expected socket so packages don't complain
#   3. policy-rc.d — allows services to start normally (like a real desktop)
#   4. FUSE/AppImage prep — ensures fuse3 is available for .AppImage files
#   5. Disable unattended-upgrades — prevents random apt locks

set -e

log() { echo "[LaaS-FIX] $(date '+%H:%M:%S') $*"; }

# ─── 1. Fix man-db permissions ───────────────────────────────────────────────
# The Selkies base image has /var/cache/man owned by root with wrong perms.
# This causes "can't chmod /var/cache/man/..." errors on every apt install.
if [ -d /var/cache/man ]; then
    log "Fixing man-db cache permissions..."
    chown -R man:man /var/cache/man/ 2>/dev/null || true
    chmod -R 755 /var/cache/man/ 2>/dev/null || true
fi

# Disable man-db auto-update trigger (not useful in containers, slows down apt)
rm -f /var/lib/man-db/auto-update

# ─── 2. Start DBus system bus ────────────────────────────────────────────────
# Many packages (packagekit, software-properties, etc.) expect a system bus
# at /run/dbus/system_bus_socket. Without it they print scary errors.
if [ ! -S /run/dbus/system_bus_socket ]; then
    log "Starting DBus system bus..."
    mkdir -p /run/dbus
    # Kill any existing dbus-daemon on the system bus
    pkill -f "dbus-daemon --system" 2>/dev/null || true
    sleep 0.2
    # Start the system bus daemon
    dbus-daemon --system --address=unix:path=/run/dbus/system_bus_socket \
        --nofork --nopidfile &
    sleep 0.5
    if [ -S /run/dbus/system_bus_socket ]; then
        log "DBus system bus started successfully"
    else
        log "WARNING: DBus system bus failed to start (some packages may show warnings)"
    fi
fi

# ─── 3. Fix policy-rc.d ─────────────────────────────────────────────────────
# Debian containers ship with /usr/sbin/policy-rc.d that returns 101,
# which tells dpkg "never start services." This blocks systemctl/service
# commands and shows "invoke-rc.d: policy-rc.d denied execution" errors.
#
# Replace with a permissive policy that allows all services EXCEPT
# ones that would conflict with supervisord-managed processes.
log "Fixing policy-rc.d to allow service management..."
cat > /usr/sbin/policy-rc.d << 'POLICY'
#!/bin/sh
# LaaS: Allow all services to start (real desktop behavior)
# Block only services that conflict with supervisord
case "$1" in
    supervisord|selkies-gstreamer|kasmvnc)
        exit 101  # Block — supervisord manages these
        ;;
    *)
        exit 0    # Allow everything else
        ;;
esac
POLICY
chmod 755 /usr/sbin/policy-rc.d

# ─── 4. Install FUSE support for AppImage ────────────────────────────────────
# AppImage files need fuse3 or libfuse2 to mount. Install if missing.
if [ ! -f /usr/bin/fusermount3 ] && [ ! -f /usr/bin/fusermount ]; then
    log "Installing FUSE support for AppImage files..."
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -qq 2>/dev/null
    apt-get install -y -qq fuse3 libfuse2 2>/dev/null || {
        log "WARNING: fuse3 install failed — AppImage files may not work"
    }
fi

# Ensure /dev/fuse is accessible
if [ -e /dev/fuse ]; then
    chmod 666 /dev/fuse 2>/dev/null || true
    log "FUSE device ready at /dev/fuse"
else
    log "WARNING: /dev/fuse not found — AppImage files will not work"
fi

# ─── 5. Disable unattended-upgrades ──────────────────────────────────────────
# Random background apt updates lock dpkg and confuse students.
if [ -f /etc/apt/apt.conf.d/20auto-upgrades ]; then
    log "Disabling unattended upgrades..."
    echo 'APT::Periodic::Update-Package-Lists "0";' > /etc/apt/apt.conf.d/20auto-upgrades
    echo 'APT::Periodic::Unattended-Upgrade "0";' >> /etc/apt/apt.conf.d/20auto-upgrades
fi

# Kill any running unattended-upgrades process
pkill -f unattended-upgrade 2>/dev/null || true

# ─── 6. Fix dpkg interrupted state ───────────────────────────────────────────
# If a previous apt install was killed mid-way, dpkg is left in a broken state.
# Auto-fix it so the next apt install works.
if dpkg --audit 2>/dev/null | grep -q "interrupted"; then
    log "Fixing interrupted dpkg state..."
    dpkg --configure -a 2>/dev/null || true
fi

# ─── 7. Clean apt cache to save storage ──────────────────────────────────────
# The 15-35GB ZFS quota fills fast. Clean apt cache on startup.
apt-get clean 2>/dev/null || true
rm -rf /var/lib/apt/lists/* 2>/dev/null || true

log "All first-run fixes complete ✓"
exit 0
