#!/usr/bin/env bash
# Behavior test for choosing a custom Dunst notification sound.

set -u

ROOT="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"
SCRIPT="$ROOT/.local/bin/i3-notification-sound-picker"
MENU="$ROOT/.config/i3/scripts/notifications/notifications.sh"
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT
FAILED=0

pass() { printf '  PASS  %s\n' "$*"; }
fail() { printf '  FAIL  %s\n' "$*"; FAILED=1; }

[[ -x "$SCRIPT" ]] && pass 'notification sound picker is executable' || fail 'notification sound picker is missing'
bash -n "$SCRIPT" 2>/dev/null && pass 'notification sound picker syntax' || fail 'notification sound picker syntax'
grep -q 'Change notification sound' "$MENU" && pass 'notification menu contains sound chooser' || fail 'notification menu sound chooser is missing'

mkdir -p "$TMP_DIR/bin"
printf 'custom sound' > "$TMP_DIR/custom.oga"
cat > "$TMP_DIR/bin/alacritty" <<'EOF'
#!/usr/bin/env bash
chooser_file=''
while (($#)); do
    if [[ "$1" == --chooser-file ]]; then
        chooser_file="$2"
        shift 2
    elif [[ "$1" == --chooser-file=* ]]; then
        chooser_file="${1#*=}"
        shift
    else
        shift
    fi
done
printf '%s\n' "${TEST_SELECTED:?}" > "$chooser_file"
EOF
cat > "$TMP_DIR/bin/file" <<'EOF'
#!/usr/bin/env bash
case "$*" in
    *custom.oga) printf 'audio/ogg\n' ;;
    *) printf 'text/plain\n' ;;
esac
EOF
cat > "$TMP_DIR/bin/rofi" <<'EOF'
#!/usr/bin/env bash
cat >/dev/null
printf '%s\n' "$*" >> "${ROFI_TEST_LOG:?}"
printf 'ChatGPT\n'
EOF
cat > "$TMP_DIR/bin/dunstctl" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "${DUNST_SOUND_PICKER_LOG:?}"
EOF
cat > "$TMP_DIR/bin/notify-send" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF
chmod +x "$TMP_DIR/bin"/*

sound_path="$TMP_DIR/notification-sound.path"
TEST_SELECTED="$TMP_DIR/custom.oga" \
DUNST_SOUND_PATH_FILE="$sound_path" \
DUNST_SOUND_PICKER_LOG="$TMP_DIR/actions.log" \
ROFI_BIN="$TMP_DIR/bin/rofi" \
ROFI_TEST_LOG="$TMP_DIR/rofi.log" \
PATH="$TMP_DIR/bin:/usr/bin:/bin" \
    "$SCRIPT"
grep -q -- '-p Sound for' "$TMP_DIR/rofi.log" && pass 'app selection appears before file selection' || fail 'app selection menu is missing'
[[ "$(<"$sound_path")" == "$TMP_DIR/custom.oga" ]] && pass 'audio file path is saved' || fail 'audio file path was not saved'
grep -q '^reload$' "$TMP_DIR/actions.log" && pass 'Dunst is reloaded after selection' || fail 'Dunst was not reloaded'

if TEST_SELECTED="$TMP_DIR/not-audio.txt" \
    DUNST_SOUND_PATH_FILE="$sound_path" \
    DUNST_SOUND_PICKER_LOG="$TMP_DIR/actions.log" \
    PATH="$TMP_DIR/bin:/usr/bin:/bin" \
    "$SCRIPT" >/dev/null 2>&1; then
    fail 'non-audio file was accepted'
else
    pass 'non-audio file is rejected'
fi
[[ "$(<"$sound_path")" == "$TMP_DIR/custom.oga" ]] && pass 'invalid selection keeps the previous sound' || fail 'invalid selection changed the sound'

if ((FAILED)); then
    exit 1
fi
printf 'PASS  notification sound picker checks passed\n'
