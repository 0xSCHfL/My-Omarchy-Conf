#!/usr/bin/env bash
# Static checks for the pause/resume idle-timer shortcut.

set -u

ROOT="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"
SCRIPT="$ROOT/.local/bin/i3-idle-toggle"
CONFIG="$ROOT/.config/i3/config"
FAILED=0

pass() { printf '  PASS  %s\n' "$*"; }
fail() { printf '  FAIL  %s\n' "$*"; FAILED=1; }

[[ -x "$SCRIPT" ]] && pass 'idle toggle script is executable' || fail 'idle toggle script is not executable'
bash -n "$SCRIPT" && pass 'idle toggle script syntax' || fail 'idle toggle script syntax'
grep -q 'pgrep -x xidlehook' "$SCRIPT" && pass 'toggle detects active idle timers' || fail 'toggle detection is missing'
grep -q 'pkill -x xidlehook' "$SCRIPT" && pass 'toggle pauses idle timers' || fail 'pause action is missing'
grep -q 'setsid -f.*i3-idle' "$SCRIPT" && pass 'toggle resumes idle timers' || fail 'resume action is missing'
grep -q 'bindsym Mod4+Ctrl+i.*i3-idle-toggle' "$CONFIG" \
    && pass 'Super+Ctrl+I binding is configured' \
    || fail 'Super+Ctrl+I binding is missing'

if ((FAILED)); then
    exit 1
fi
printf 'PASS  idle toggle checks passed\n'
