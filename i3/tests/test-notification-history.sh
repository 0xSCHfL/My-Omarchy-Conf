#!/usr/bin/env bash
# Checks that the notification history menu parses Dunst history output.

set -u

ROOT="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"
SCRIPT="$ROOT/.config/i3/scripts/notifications/notifications.sh"
FAILED=0

pass() { printf '  PASS  %s\n' "$*"; }
fail() { printf '  FAIL  %s\n' "$*"; FAILED=1; }

bash -n "$SCRIPT" && pass 'notification history script syntax' || fail 'notification history script syntax'
grep -q 'payload.get("data"' "$SCRIPT" \
    && pass 'Dunst typed history output is handled' \
    || fail 'Dunst typed history parsing is missing'
grep -q 'field.get("data"' "$SCRIPT" \
    && pass 'typed notification fields are handled' \
    || fail 'typed notification field parsing is missing'
grep -q 'history-pop "\$selected_id"' "$SCRIPT" \
    && pass 'selected history notification can be activated' \
    || fail 'history activation is missing'

if ((FAILED)); then
    exit 1
fi
printf 'PASS  notification history checks passed\n'
