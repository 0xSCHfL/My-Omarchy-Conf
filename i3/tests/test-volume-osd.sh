#!/usr/bin/env bash
# Read-only behavior test for the volume OSD without changing real audio.

set -u

ROOT="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"
SCRIPT="$ROOT/.config/i3/scripts/media/volume-osd.sh"
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

pass() { printf '  PASS  %s\n' "$*"; }
fail() { printf '  FAIL  %s\n' "$*"; exit 1; }

mkdir -p "$TMP_DIR/bin"
cat > "$TMP_DIR/bin/pactl" <<'EOF'
#!/usr/bin/env bash
case "$*" in
  *set-sink-volume*) exit 0 ;;
  *set-sink-mute*) exit 0 ;;
  *get-sink-volume*) printf 'Volume: front-left: 55%% / 55%% / 55%%\n' ;;
  *get-sink-mute*) printf 'Mute: no\n' ;;
esac
EOF
cat > "$TMP_DIR/bin/xdpyinfo" <<'EOF'
#!/usr/bin/env bash
printf '  dimensions:    1920x1080 pixels (508x285 millimeters)\n'
EOF
cat > "$TMP_DIR/bin/pkill" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF
cat > "$TMP_DIR/bin/yad" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" > "${VOLUME_OSD_TEST_LOG:?}"
cat >/dev/null
EOF
chmod +x "$TMP_DIR/bin"/*

VOLUME_OSD_TEST_LOG="$TMP_DIR/yad.log" PATH="$TMP_DIR/bin:$PATH" \
  bash "$SCRIPT" up >/dev/null 2>&1 || fail 'volume OSD command exited successfully'

args=$(<"$TMP_DIR/yad.log")
grep -q -- '--image=audio-volume-medium' <<<"$args" || fail 'medium-volume icon missing'
grep -q -- '--geometry=360x120+780+912' <<<"$args" || fail 'bottom-center geometry missing'
if grep -q -- '--progress-text=' <<<"$args"; then
  fail 'duplicate ASCII progress bar is still enabled'
fi
grep -q -- '--timeout=2' <<<"$args" || fail 'OSD timeout missing'
pass 'volume OSD uses icon, clean progress indicator, and bottom-center geometry'

printf 'PASS  volume OSD checks passed\n'
