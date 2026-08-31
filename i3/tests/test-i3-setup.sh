#!/usr/bin/env bash
# Focused regression checks for the i3 desktop setup.
# This script is read-only. Use --live to also inspect the current X11 session.

set -u

ROOT="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"
CONFIG="$ROOT/.config/i3/config"
INSTALL="$ROOT/../install.sh"
LIVE=0
FAILED=0
WARNED=0

usage() {
    cat <<'EOF'
Usage: test-i3-setup.sh [--live]

Checks the i3 config and the services/scripts involved in startup, idle
locking, volume OSD, clipboard history, and desktop app launchers.

Options:
  --live    also inspect the current X11 session and user services
  -h, --help
EOF
}

for arg in "$@"; do
    case "$arg" in
        --live) LIVE=1 ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown option: $arg" >&2; usage >&2; exit 2 ;;
    esac
done

pass() { printf '  PASS  %s\n' "$*"; }
warn() { printf '  WARN  %s\n' "$*"; WARNED=1; }
fail() { printf '  FAIL  %s\n' "$*"; FAILED=1; }

check_file() {
    if [[ -f "$ROOT/$1" ]]; then
        pass "$1 exists"
    else
        fail "missing: $1"
    fi
}

check_exec() {
    if [[ -x "$ROOT/$1" ]]; then
        pass "$1 is executable"
    else
        fail "$1 is not executable"
    fi
}

check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        pass "command available: $1"
    else
        warn "command missing: $1"
    fi
}

check_config_line() {
    local pattern="$1"
    local description="$2"
    if grep -Eq "$pattern" "$CONFIG"; then
        pass "$description"
    else
        fail "$description"
    fi
}

printf 'i3 setup regression test\n'
printf 'Repository: %s\n' "$ROOT"

printf '\n[config]\n'
if command -v i3 >/dev/null 2>&1; then
    if i3 -C -c "$CONFIG" >/dev/null 2>&1; then
        pass 'i3 config syntax'
    else
        fail 'i3 config syntax'
    fi
else
    warn 'i3 is not installed; skipped config syntax'
fi

check_config_line '^# Voxtype is started once by the enabled user systemd service' 'voxtype is not duplicated by i3 startup'
check_config_line 'voxtype-toggle-paste\.sh' 'voxtype shortcut uses the toggle script'
check_config_line 'exec .*dunst' 'dunst starts from i3 startup'
check_config_line 'exec .*i3-cliphist' 'clipboard history starts from i3 startup'
check_config_line 'exec .*xss-lock' 'xss-lock starts from i3 startup'
check_config_line 'exec_always .*i3-idle' 'idle timer starts from i3 startup'
check_config_line 'XF86AudioRaiseVolume.*volume-osd\.sh' 'volume-up OSD binding'
check_config_line 'XF86AudioLowerVolume.*volume-osd\.sh' 'volume-down OSD binding'
check_config_line 'XF86AudioMute.*volume-osd\.sh' 'mute OSD binding'
check_config_line 'Mod4\+Shift\+c.*chromium --ozone-platform=x11' 'Chromium uses X11 binding'
check_config_line 'class="\^?Bitwarden\$?' 'Bitwarden floating rule'
check_config_line 'class="i3-load-popup"' 'load popup floating rule'
check_config_line 'class="i3-windows-vm"' 'Windows VM popup floating rule'
check_config_line 'class="i3-clipboard-picker"' 'combined clipboard popup floating rule'
check_config_line 'Mod4\+Ctrl\+space.*i3-menu' 'control menu binding'
check_config_line 'Mod4\+Ctrl\+c.*i3-capture-menu' 'unified capture menu binding'

printf '\n[scripts]\n'
scripts=(
    .local/bin/i3-idle
    .local/bin/i3-idle-screensaver
    .local/bin/i3-idle-lock
    .local/bin/i3-idle-sleep
    .local/bin/i3-launch-screensaver
    .local/bin/i3-stop-screensaver
    .local/bin/i3-cliphist
    .local/bin/i3-cliphist-fzf
    .local/bin/i3-cliphist-delete
    .local/bin/i3-load-monitor
    .local/bin/i3-calendar
    .local/bin/i3-capture-menu
    .local/bin/i3-reminder
    .local/bin/i3-windows-vm
    .local/bin/i3-clipboard-picker
    .local/bin/i3-cliphist-reset
    .local/bin/i3-keys
    .local/bin/i3-notification-sound-picker
    .local/bin/i3-menu
    .config/i3/scripts/media/volume-osd.sh
    .config/i3/scripts/media/brightness-osd.sh
    .config/i3blocks/scripts/load
    .config/i3blocks/scripts/timedate
)

for script in "${scripts[@]}"; do
    check_file "$script"
    check_exec "$script"
    if [[ -f "$ROOT/$script" ]] && bash -n "$ROOT/$script" >/dev/null 2>&1; then
        pass "$script bash syntax"
    elif [[ -f "$ROOT/$script" ]]; then
        fail "$script bash syntax"
    fi
done

printf '\n[dependencies and install path]\n'
for command in dunst dunstctl xidlehook xss-lock voxtype pactl playerctl xdotool; do
    check_command "$command"
done
for command in docker docker-compose xfreerdp3 gum; do
    check_command "$command"
done
if command -v yad >/dev/null 2>&1 || command -v xob >/dev/null 2>&1; then
    pass 'volume OSD backend available (yad or xob)'
else
    warn 'no volume OSD backend found (install yad or xob)'
fi
if grep -Eq '(^|[[:space:]])yad([[:space:]\\)]|$)' "$INSTALL"; then
    pass 'install script includes yad'
else
    fail 'install script does not include yad'
fi
if grep -Eq '(^|[[:space:]])voxtype([[:space:]]|$)' "$INSTALL"; then
    pass 'install script includes voxtype'
else
    fail 'install script does not include voxtype'
fi
if grep -Eq '(^|[[:space:]])docker([[:space:]]|$)' "$INSTALL" && grep -Eq '(^|[[:space:]])freerdp([[:space:]]|$)' "$INSTALL"; then
    pass 'install script includes Windows VM dependencies'
else
    fail 'install script does not include Windows VM dependencies'
fi

printf '\n[optional live session]\n'
if [[ "$LIVE" -eq 1 ]]; then
    if [[ -n "${DISPLAY:-}" ]]; then
        for process in dunst xidlehook xss-lock; do
            if pgrep -x "$process" >/dev/null 2>&1; then
                pass "running: $process"
            else
                fail "not running: $process"
            fi
        done
    else
        warn 'DISPLAY is not set; skipped X11 process checks'
    fi

    if command -v systemctl >/dev/null 2>&1; then
        if systemctl --user is-active --quiet voxtype.service 2>/dev/null; then
            pass 'user service active: voxtype.service'
        elif pgrep -f '[v]oxtype daemon' >/dev/null 2>&1; then
            pass 'voxtype daemon is running from i3 startup'
            warn 'voxtype.service is inactive; i3 direct startup is currently providing the daemon'
        else
            fail 'voxtype daemon is not running and voxtype.service is inactive'
        fi
    fi
else
    printf '  INFO  live checks skipped; rerun with --live\n'
fi

printf '\n[result]\n'
if [[ "$FAILED" -eq 0 && "$WARNED" -eq 0 ]]; then
    printf 'PASS  all focused checks passed\n'
    exit 0
elif [[ "$FAILED" -eq 0 ]]; then
    printf 'PASS  checks passed with warnings\n'
    exit 0
else
    printf 'FAIL  one or more checks failed\n'
    exit 1
fi
