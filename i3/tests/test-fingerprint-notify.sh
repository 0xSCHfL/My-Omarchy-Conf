#!/usr/bin/env bash
# Static and behavior checks for the sudo fingerprint notification watcher.

set -u

ROOT="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"
SCRIPT="$ROOT/.local/bin/i3-fingerprint-notify"
CONFIG="$ROOT/.config/i3/config"

pass() { printf '  PASS  %s\n' "$*"; }
fail() { printf '  FAIL  %s\n' "$*"; exit 1; }

[ -x "$SCRIPT" ] || fail 'fingerprint notification watcher is executable'
bash -n "$SCRIPT" || fail 'fingerprint notification watcher syntax'
grep -q 'gdbus monitor' "$SCRIPT" || fail 'watcher monitors fprintd signals'
grep -q 'VerifyFingerSelected' "$SCRIPT" || fail 'watcher shows the touch prompt'
grep -q "verify-match" "$SCRIPT" || fail 'watcher handles accepted fingerprints'
grep -q "verify-no-match" "$SCRIPT" || fail 'watcher handles rejected fingerprints'
grep -Eq 'exec(_always)? .*i3-fingerprint-notify' "$CONFIG" || fail 'i3 starts the fingerprint watcher'

pass 'fingerprint notification checks passed'
