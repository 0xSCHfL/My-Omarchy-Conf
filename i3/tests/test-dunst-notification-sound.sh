#!/usr/bin/env bash
# Behavior test for the Dunst notification sound hook.

set -u

ROOT="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"
SCRIPT="$ROOT/.config/dunst/notification-sound.sh"
GENERATOR="$ROOT/.config/dunst/generate-from-pywal.sh"
TOGGLE="$ROOT/.local/bin/i3-notification-sound-toggle"
I3_CONFIG="$ROOT/.config/i3/config"
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

pass() { printf '  PASS  %s\n' "$*"; }
fail() { printf '  FAIL  %s\n' "$*"; exit 1; }

[ -x "$SCRIPT" ] || fail 'notification sound script is not executable'
[ -x "$TOGGLE" ] || fail 'notification sound toggle is not executable'
grep -q '^\[notification_sound\]$' "$GENERATOR" || fail 'Dunst sound rule missing'
grep -q 'script = ~/.config/dunst/notification-sound.sh' "$GENERATOR" || fail 'Dunst sound script path missing'
grep -q 'Mod4+Ctrl+Shift+comma.*i3-notification-sound-toggle' "$I3_CONFIG" || fail 'sound toggle keybinding missing'

mkdir -p "$TMP_DIR/bin"
printf 'fake sound' > "$TMP_DIR/notification.oga"
cat > "$TMP_DIR/bin/pw-play" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" > "${DUNST_SOUND_TEST_LOG:?}"
EOF
cat > "$TMP_DIR/bin/setsid" <<'EOF'
#!/usr/bin/env bash
shift
exec "$@"
EOF
cat > "$TMP_DIR/bin/notify-send" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF
chmod +x "$TMP_DIR/bin"/*

DUNST_SOUND_FILE="$TMP_DIR/notification.oga" \
DUNST_SOUND_STATE_FILE="$TMP_DIR/notification-sound.disabled" \
DUNST_SOUND_TEST_LOG="$TMP_DIR/player.log" \
PATH="$TMP_DIR/bin:/usr/bin:/bin" \
  bash "$SCRIPT"

[ -s "$TMP_DIR/player.log" ] || fail 'sound player was not started'
grep -q -- "$TMP_DIR/notification.oga" "$TMP_DIR/player.log" || fail 'sound file was not passed to player'

: > "$TMP_DIR/notification-sound.disabled"
rm -f "$TMP_DIR/player.log"
DUNST_SOUND_FILE="$TMP_DIR/notification.oga" \
DUNST_SOUND_STATE_FILE="$TMP_DIR/notification-sound.disabled" \
DUNST_SOUND_TEST_LOG="$TMP_DIR/player.log" \
PATH="$TMP_DIR/bin:/usr/bin:/bin" \
  bash "$SCRIPT"
[ ! -e "$TMP_DIR/player.log" ] || fail 'muted sound hook still launched the player'
pass 'Dunst sound hook respects the sound mute state'

rm -f "$TMP_DIR/notification-sound.disabled"
DUNST_SOUND_STATE_FILE="$TMP_DIR/notification-sound.disabled" \
PATH="$TMP_DIR/bin:/usr/bin:/bin" \
  bash "$TOGGLE"
[ -e "$TMP_DIR/notification-sound.disabled" ] || fail 'toggle did not mute notification sounds'
DUNST_SOUND_STATE_FILE="$TMP_DIR/notification-sound.disabled" \
PATH="$TMP_DIR/bin:/usr/bin:/bin" \
  bash "$TOGGLE"
[ ! -e "$TMP_DIR/notification-sound.disabled" ] || fail 'toggle did not re-enable notification sounds'
pass 'notification sound keybinding toggle switches sound state'

printf 'PASS  Dunst notification sound checks passed\n'
