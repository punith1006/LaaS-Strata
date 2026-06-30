# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, overwrite the one in /etc/profile)
# but only if not SUDOing and have SUDO_PS1 set; then assume smart user.
if ! [ -n "${SUDO_USER}" -a -n "${SUDO_PS1}" ]; then
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#    ;;
#*)
#    ;;
#esac

# enable bash completion in interactive shells
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#  fi
#fi

# sudo hint
if [ ! -e "$HOME/.sudo_as_admin_successful" ] && [ ! -e "$HOME/.hushlogin" ] ; then
    case " $(groups) " in *\ admin\ *|*\ sudo\ *)
    if [ -x /usr/bin/sudo ]; then
        echo 'To run a command as administrator (user "root"), use "sudo <command>".'
        echo 'See "man sudo_root" for details.'
        echo
    fi
    esac
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
        function command_not_found_handle {
                # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
                   /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
                   /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
                else
                   printf "%s: command not found\n" "$1" >&2
                   return 127
                fi
        }
fi

# Electron/Chromium apps (VS Code, Chrome, Brave, Slack, etc.)
# Disable Chromium's internal sandbox — the container IS the sandbox
export ELECTRON_DISABLE_SANDBOX=1

# LaaS resource interceptors
# fake_sysconf.so is safe for all programs (KDE RAM display fix)
# libvgpu.so ONLY for CUDA programs (crashes non-CUDA via dlsym hooks)
if [ -f /usr/lib/fake_sysconf.so ]; then
    export LD_PRELOAD="/usr/lib/fake_sysconf.so"
    export SYSCONF_INJECTED=1
fi
mkdir -p /tmp/vgpulock 2>/dev/null

# CUDA program wrappers — inject HAMi VRAM/SM enforcement
# IMPORTANT: space-separated, fake_sysconf FIRST (proven working order from Full_Setup.txt)
_HAMI_PRELOAD="/usr/lib/fake_sysconf.so /usr/lib/libvgpu.so"
if [ -f /usr/lib/libvgpu.so ]; then
    python3() { LD_PRELOAD="$_HAMI_PRELOAD" command python3 "$@"; }
    python()  { LD_PRELOAD="$_HAMI_PRELOAD" command python "$@"; }
    nvcc()    { LD_PRELOAD="$_HAMI_PRELOAD" command nvcc "$@"; }
    jupyter() { LD_PRELOAD="$_HAMI_PRELOAD" command jupyter "$@"; }
fi

# Smart sudo wrapper: strip LD_PRELOAD so system tools dont crash
sudo() {
    env -u LD_PRELOAD /usr/bin/sudo "$@"
}

# Package managers: always strip LD_PRELOAD
apt()     { env -u LD_PRELOAD /usr/bin/apt "$@"; }
apt-get() { env -u LD_PRELOAD /usr/bin/apt-get "$@"; }
dpkg()    { env -u LD_PRELOAD /usr/bin/dpkg "$@"; }
pip()     { LD_PRELOAD= command pip "$@"; }
pip3()    { LD_PRELOAD= command pip3 "$@"; }

# ─── systemctl wrapper ────────────────────────────────────────────────────────
# LaaS containers use supervisord (PID 1), not systemd.
# This wrapper translates systemctl commands into supervisord/service/pkill
# equivalents so users get a familiar desktop experience.
#
# SAFETY: This is a bash function, NOT a binary replacement.
#   - /usr/bin/systemctl is untouched on disk
#   - Only affects interactive terminal sessions (bash.bashrc)
#   - If systemd IS somehow running, falls through to the real systemctl
#   - Scripts that call /usr/bin/systemctl directly are NOT affected
#
# Supported translations:
#   systemctl start <svc>    → supervisorctl start OR service <svc> start
#   systemctl stop <svc>     → supervisorctl stop  OR service <svc> stop
#   systemctl restart <svc>  → supervisorctl restart OR service <svc> restart
#   systemctl status [<svc>] → supervisorctl status OR process check
#   systemctl enable/disable → no-op with explanation
#   systemctl is-active <s>  → supervisor/pgrep check
#   systemctl daemon-reload  → supervisorctl update
#   systemctl list-units     → combined supervisord + process list

_LAAS_SUPERVISOR_SVCS="nginx pipewire wireplumber pipewire-pulse selkies-gstreamer kasmvnc dbus entrypoint first-run-fixes"

_laas_is_supervisor_svc() {
    local svc="${1%.service}"  # strip .service suffix if present
    for s in $_LAAS_SUPERVISOR_SVCS; do
        [ "$svc" = "$s" ] && return 0
    done
    return 1
}

_laas_check_systemd() {
    # If systemd is actually PID 1, use the real systemctl
    if [ -d /run/systemd/system ] 2>/dev/null; then
        return 0  # systemd IS running
    fi
    return 1  # systemd is NOT running (our container case)
}

systemctl() {
    # If real systemd is running, pass through to the real systemctl
    if _laas_check_systemd; then
        command systemctl "$@"
        return $?
    fi

    # Parse action and service from arguments
    local action="" svc="" extra_args=""
    for arg in "$@"; do
        case "$arg" in
            start|stop|restart|reload|status|enable|disable|is-active|is-enabled|\
            daemon-reload|list-units|list-unit-files|show|cat|mask|unmask|reset-failed)
                action="$arg" ;;
            --no-pager|--no-legend|--all|-a|-l|-q|--quiet|--plain|-t|--type=*|--state=*)
                ;; # silently skip display flags
            -*) extra_args="$extra_args $arg" ;;
            *)  [ -z "$svc" ] && svc="$arg" ;;
        esac
    done
    svc="${svc%.service}"  # strip .service suffix

    # Helper: colored output
    local G='\033[0;32m' Y='\033[1;33m' R='\033[0;31m' N='\033[0m'

    case "$action" in
        start)
            if [ -z "$svc" ]; then
                echo -e "${R}[LaaS]${N} Usage: systemctl start <service>"
                return 1
            fi
            if _laas_is_supervisor_svc "$svc"; then
                echo -e "${G}[LaaS]${N} Starting $svc..."
                supervisorctl start "$svc" 2>/dev/null && return 0
            fi
            # Try init script
            if [ -x "/etc/init.d/$svc" ]; then
                env -u LD_PRELOAD sudo /etc/init.d/$svc start 2>/dev/null && return 0
            fi
            # Try running the binary directly
            if command -v "$svc" >/dev/null 2>&1; then
                "$svc" &>/dev/null &
                echo -e "${G}[LaaS]${N} $svc started (PID: $!)"
                return 0
            fi
            echo -e "${R}[LaaS]${N} Service '$svc' not found."
            echo -e "${Y}[LaaS]${N} Tip: use 'apt install $svc' first, or run the program directly."
            return 1
            ;;

        stop)
            if [ -z "$svc" ]; then
                echo -e "${R}[LaaS]${N} Usage: systemctl stop <service>"
                return 1
            fi
            if _laas_is_supervisor_svc "$svc"; then
                echo -e "${G}[LaaS]${N} Stopping $svc..."
                supervisorctl stop "$svc" 2>/dev/null && return 0
            fi
            if [ -x "/etc/init.d/$svc" ]; then
                env -u LD_PRELOAD sudo /etc/init.d/$svc stop 2>/dev/null && return 0
            fi
            if pgrep -x "$svc" >/dev/null 2>&1; then
                pkill -x "$svc" 2>/dev/null
                echo -e "${G}[LaaS]${N} $svc stopped."
                return 0
            fi
            echo -e "${Y}[LaaS]${N} $svc is not running."
            return 0
            ;;

        restart)
            if [ -z "$svc" ]; then
                echo -e "${R}[LaaS]${N} Usage: systemctl restart <service>"
                return 1
            fi
            if _laas_is_supervisor_svc "$svc"; then
                echo -e "${G}[LaaS]${N} Restarting $svc..."
                supervisorctl restart "$svc" 2>/dev/null && return 0
            fi
            if [ -x "/etc/init.d/$svc" ]; then
                env -u LD_PRELOAD sudo /etc/init.d/$svc restart 2>/dev/null && return 0
            fi
            # stop + start fallback
            pkill -x "$svc" 2>/dev/null; sleep 0.3
            if command -v "$svc" >/dev/null 2>&1; then
                "$svc" &>/dev/null &
                echo -e "${G}[LaaS]${N} $svc restarted (PID: $!)"
                return 0
            fi
            echo -e "${R}[LaaS]${N} Service '$svc' not found."
            return 1
            ;;

        reload)
            if _laas_is_supervisor_svc "$svc"; then
                supervisorctl signal HUP "$svc" 2>/dev/null && return 0
            fi
            if [ -x "/etc/init.d/$svc" ]; then
                env -u LD_PRELOAD sudo /etc/init.d/$svc reload 2>/dev/null && return 0
            fi
            pkill -HUP -x "$svc" 2>/dev/null
            echo -e "${G}[LaaS]${N} $svc reloaded."
            return 0
            ;;

        status)
            if [ -z "$svc" ]; then
                # Show overall system status
                echo "═══════════════════════════════════════════════════"
                echo "  LaaS Container Status (PID 1: supervisord)"
                echo "═══════════════════════════════════════════════════"
                echo ""
                echo "── Supervised Programs ──"
                supervisorctl status 2>/dev/null || echo "  (supervisorctl unavailable)"
                echo ""
                echo "── Top Processes ──"
                ps aux --sort=-%mem 2>/dev/null | head -15
                echo ""
                echo "── Resources ──"
                echo "  Memory:  $(free -h 2>/dev/null | awk '/^Mem:/{print $3 " / " $2}')"
                echo "  GPU:     $(nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader 2>/dev/null || echo 'N/A')"
                echo "  Disk:    $(df -h /home/ubuntu 2>/dev/null | awk 'NR==2{print $3 " / " $2 " used"}')"
                echo "  Uptime:  $(uptime -p 2>/dev/null || uptime)"
                return 0
            fi
            # Per-service status
            if _laas_is_supervisor_svc "$svc"; then
                supervisorctl status "$svc" 2>/dev/null && return 0
            fi
            if [ -x "/etc/init.d/$svc" ]; then
                env -u LD_PRELOAD /etc/init.d/$svc status 2>/dev/null && return $?
            fi
            # Fallback: check if process is running
            if pgrep -x "$svc" >/dev/null 2>&1; then
                local pids
                pids=$(pgrep -x "$svc" | tr '\n' ' ')
                echo -e "● $svc.service"
                echo -e "     Active: ${G}active (running)${N}"
                echo -e "     PIDs:   $pids"
                return 0
            else
                echo -e "● $svc.service"
                echo -e "     Active: ${R}inactive (dead)${N}"
                return 3
            fi
            ;;

        enable|disable)
            echo -e "${Y}[LaaS]${N} systemctl $action is not needed in LaaS containers."
            echo -e "${Y}[LaaS]${N} Supervised services auto-start on container boot."
            echo -e "${Y}[LaaS]${N} To add a custom service: create /etc/supervisor/conf.d/<name>.conf"
            return 0
            ;;

        is-active)
            if [ -z "$svc" ]; then return 1; fi
            if _laas_is_supervisor_svc "$svc"; then
                local state
                state=$(supervisorctl status "$svc" 2>/dev/null | awk '{print $2}')
                if [ "$state" = "RUNNING" ]; then
                    echo "active"; return 0
                else
                    echo "inactive"; return 3
                fi
            fi
            if pgrep -x "$svc" >/dev/null 2>&1; then
                echo "active"; return 0
            else
                echo "inactive"; return 3
            fi
            ;;

        is-enabled)
            echo "enabled"
            return 0
            ;;

        daemon-reload)
            echo -e "${G}[LaaS]${N} Reloading supervisord configuration..."
            supervisorctl update 2>/dev/null || \
                echo -e "${Y}[LaaS]${N} supervisorctl not available (no changes needed)"
            return 0
            ;;

        list-units|list-unit-files)
            echo "UNIT                              LOAD   ACTIVE SUB     DESCRIPTION"
            while IFS= read -r line; do
                _lu_name=$(echo "$line" | awk '{print $1}')
                _lu_state=$(echo "$line" | awk '{print $2}')
                if [ "$_lu_state" = "RUNNING" ]; then
                    printf "%-34s%-7s%-7s%-8s%s\n" "$_lu_name.service" "loaded" "active" "running" "$_lu_name"
                else
                    printf "%-34s%-7s%-7s%-8s%s\n" "$_lu_name.service" "loaded" "inactive" "dead" "$_lu_name"
                fi
            done < <(supervisorctl status 2>/dev/null)
            echo ""
            echo "To see all running processes: ps aux"
            return 0
            ;;

        show|cat|edit|mask|unmask|reset-failed|kill|set-property|get-property)
            echo -e "${Y}[LaaS]${N} systemctl $action is not supported in containers (no systemd)."
            echo -e "${Y}[LaaS]${N} Use 'supervisorctl' to manage services. Run 'supervisorctl help' for options."
            return 0
            ;;

        *)
            # Unknown or no action — show help
            echo "Usage: systemctl {start|stop|restart|status|enable|disable|is-active|daemon-reload|list-units} [service]"
            echo ""
            echo "LaaS container note: systemd is not running (supervisord is PID 1)."
            echo "Commands are translated to supervisord/service equivalents."
            echo ""
            echo "Examples:"
            echo "  systemctl restart nginx     # restart the nginx web server"
            echo "  systemctl status            # show all services and resources"
            echo "  systemctl start postgresql  # start PostgreSQL (if installed)"
            echo "  supervisorctl status        # see supervisord programs directly"
            return 1
            ;;
    esac
}
