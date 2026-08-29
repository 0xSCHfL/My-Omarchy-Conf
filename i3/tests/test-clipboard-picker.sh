#!/usr/bin/env bash
# Read-only checks for the combined clipboard picker image preview.

set -u

ROOT="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"
PICKER="$ROOT/.local/bin/i3-clipboard-picker"
FIXTURE="$ROOT/tests/fixtures/clipboard-picker-test.svg"
FAILED=0

pass() { printf '  PASS  %s\n' "$*"; }
fail() { printf '  FAIL  %s\n' "$*"; FAILED=1; }

[[ -x "$PICKER" ]] && pass 'combined picker is executable' || fail 'combined picker is not executable'
[[ -s "$FIXTURE" ]] && pass 'test image exists' || fail 'test image is missing'
bash -n "$PICKER" && pass 'combined picker syntax' || fail 'combined picker syntax'

if command -v chafa >/dev/null 2>&1; then
    preview=$("$PICKER" --preview $'IMAGE\t'"$FIXTURE" 2>/dev/null || true)
    [[ -n "$preview" ]] && pass 'image preview produces visible output' || fail 'image preview is empty'
else
    printf '  SKIP  chafa is not installed\n'
fi

if ((FAILED)); then
    exit 1
fi
printf 'PASS  clipboard picker checks passed\n'
