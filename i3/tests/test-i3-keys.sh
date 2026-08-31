#!/usr/bin/env bash
# Checks for the Omarchy-style searchable i3 keybindings menu.

set -u

ROOT="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"
SCRIPT="$ROOT/.local/bin/i3-keys"
THEME="$ROOT/.config/rofi/i3-help.rasi"
FAILED=0

pass() { printf '  PASS  %s\n' "$*"; }
fail() { printf '  FAIL  %s\n' "$*"; FAILED=1; }

[[ -x "$SCRIPT" ]] && pass 'keybindings script is executable' || fail 'keybindings script is not executable'
bash -n "$SCRIPT" && pass 'keybindings script syntax' || fail 'keybindings script syntax'
grep -q 'matching: "fuzzy"' "$THEME" && pass 'keybindings menu uses fuzzy search' || fail 'fuzzy search is missing'
grep -q 'children: \[ prompt, entry \]' "$THEME" && pass 'search entry is visible' || fail 'search entry is missing from the input bar'
grep -q -- '-no-custom -matching fuzzy' "$SCRIPT" && pass 'keybindings script searches the full list' || fail 'full-list search is missing'
grep -q 'Search all keybindings' "$SCRIPT" && pass 'search guidance is visible' || fail 'search guidance is missing'

if ((FAILED)); then
    exit 1
fi
printf 'PASS  i3 keybindings checks passed\n'
