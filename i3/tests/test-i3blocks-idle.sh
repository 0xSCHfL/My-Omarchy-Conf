#!/usr/bin/env bash
# Static checks for the i3blocks idle status/toggle block.

set -u

ROOT="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"
SCRIPT="$ROOT/.config/i3blocks/scripts/idle"
CONFIG="$ROOT/.config/i3blocks/config"
FAILED=0

pass() { printf '  PASS  %s\n' "$*"; }
fail() { printf '  FAIL  %s\n' "$*"; FAILED=1; }

[[ -x "$SCRIPT" ]] && pass 'idle block script is executable' || fail 'idle block script is not executable'
bash -n "$SCRIPT" && pass 'idle block script syntax' || fail 'idle block script syntax'
grep -q 'pgrep -x xidlehook' "$SCRIPT" && pass 'idle block detects active timers' || fail 'idle block detection is missing'
grep -q 'i3-idle-toggle' "$SCRIPT" && pass 'idle block toggles on click' || fail 'idle block click action is missing'
grep -q '\[idle\]' "$CONFIG" && pass 'idle block is configured' || fail 'idle block configuration is missing'
grep -q 'signal=13' "$CONFIG" && pass 'idle block refresh signal is configured' || fail 'idle block refresh signal is missing'

if ((FAILED)); then
    exit 1
fi
printf 'PASS  i3blocks idle checks passed\n'
