#!/usr/bin/env bash
# Read-only checks for the combined clipboard picker image preview.

set -u

ROOT="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"
PICKER="$ROOT/.local/bin/i3-clipboard-picker"
CLIP_DAEMON="$ROOT/.local/bin/i3-cliphist"
IMAGE_WATCHER="$ROOT/.local/bin/i3-imgclipwatch"
RESET_SCRIPT="$ROOT/.local/bin/i3-cliphist-reset"
FIXTURE="$ROOT/tests/fixtures/clipboard-picker-test.svg"
FAILED=0

pass() { printf '  PASS  %s\n' "$*"; }
fail() { printf '  FAIL  %s\n' "$*"; FAILED=1; }

[[ -x "$PICKER" ]] && pass 'combined picker is executable' || fail 'combined picker is not executable'
[[ -s "$FIXTURE" ]] && pass 'test image exists' || fail 'test image is missing'
bash -n "$PICKER" && pass 'combined picker syntax' || fail 'combined picker syntax'
bash -n "$CLIP_DAEMON" "$IMAGE_WATCHER" "$RESET_SCRIPT" && pass 'clipboard image flow syntax' || fail 'clipboard image flow syntax'
grep -q '__I3_IMAGE__:' "$IMAGE_WATCHER" && pass 'image marker is stored in cliphist order' || fail 'image marker storage is missing'
grep -q 'flock -x 9' "$CLIP_DAEMON" "$IMAGE_WATCHER" "$RESET_SCRIPT" && pass 'clipboard writers and reset share a lock' || fail 'clipboard reset locking is missing'
grep -q 'DB_PATH=' "$CLIP_DAEMON" "$IMAGE_WATCHER" && pass 'watchers know the cliphist database path' || fail 'watchers do not know the cliphist database path'
grep -q '\[ ! -s "\$DB_PATH" \]' "$CLIP_DAEMON" && pass 'text watcher recovers after database reset' || fail 'text watcher does not recover after database reset'
grep -q 'prev_checksum=""' "$IMAGE_WATCHER" && pass 'image watcher recovers after database reset' || fail 'image watcher does not recover after database reset'
grep -q 'ctrl-d:execute-silent(.*--delete.*reload' "$PICKER" && pass 'Ctrl+D deletes and reloads in place' || fail 'Ctrl+D delete binding is missing'

if command -v chafa >/dev/null 2>&1; then
    preview=$("$PICKER" --preview $'IMAGE\t'"$FIXTURE" 2>/dev/null || true)
    [[ -n "$preview" ]] && pass 'image preview produces visible output' || fail 'image preview is empty'
else
    printf '  SKIP  chafa is not installed\n'
fi

LIST_TMP=$(mktemp -d)
mkdir -p "$LIST_TMP/hist" "$LIST_TMP/bin"
printf 'test image' > "$LIST_TMP/hist/latest.png"
cat > "$LIST_TMP/bin/cliphist" <<'EOF'
#!/usr/bin/env bash
case "${1:-}" in
    list)
        printf '3\tnewest text\n'
        printf '2\t__I3_IMAGE__:%s\n' "${CLIPHIST_IMAGE_PATH:?}"
        printf '1\told text\n'
        ;;
    delete) cat > "${CLIPHIST_DELETE_LOG:?}" ;;
esac
EOF
chmod +x "$LIST_TMP/bin/cliphist"
export CLIPHIST_IMAGE_PATH="$LIST_TMP/hist/latest.png"
list_output=$(CLIPBOARD_HIST_DIR="$LIST_TMP/hist" PATH="$LIST_TMP/bin:/usr/bin:/bin" "$PICKER" --list)
first_item=$(printf '%s\n' "$list_output" | sed -n '1p')
second_item=$(printf '%s\n' "$list_output" | sed -n '2p')
[[ "$first_item" == $'TEXT\t3\tnewest text' ]] && pass 'newest text stays first' || fail 'clipboard order was not preserved'
[[ "$second_item" == $'IMAGE\t'* ]] && pass 'image stays in its real clipboard position' || fail 'image position was not preserved'

cat > "$LIST_TMP/bin/ueberzugpp" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "${UEBERZUG_TEST_LOG:?}"
EOF
chmod +x "$LIST_TMP/bin/ueberzugpp"
UEBERZUG_TEST_LOG="$LIST_TMP/ueberzug.log" \
SOCKET="$LIST_TMP/socket" \
CLIPBOARD_HIST_DIR="$LIST_TMP/hist" PATH="$LIST_TMP/bin:/usr/bin:/bin" \
    "$PICKER" --preview $'TEXT\t1\ttext entry' >/dev/null
grep -q -- '-i fzfpreview -a remove' "$LIST_TMP/ueberzug.log" \
    && pass 'text preview clears the previous image' \
    || fail 'text preview did not clear the previous image'

image_path="$LIST_TMP/hist/latest.png"
CLIPHIST_DELETE_LOG="$LIST_TMP/delete.log" \
CLIPHIST_IMAGE_PATH="$image_path" \
CLIPBOARD_HIST_DIR="$LIST_TMP/hist" PATH="$LIST_TMP/bin:/usr/bin:/bin" \
    "$PICKER" --delete $'IMAGE\t'"$image_path"
[[ ! -e "$image_path" ]] && pass 'Ctrl+D deletes an image entry only' || fail 'image entry was not deleted'
grep -q '__I3_IMAGE__:' "$LIST_TMP/delete.log" && pass 'image marker is removed from cliphist' || fail 'image marker was not removed from cliphist'

CLIPHIST_DELETE_LOG="$LIST_TMP/delete.log" \
CLIPHIST_IMAGE_PATH="$image_path" \
CLIPBOARD_HIST_DIR="$LIST_TMP/hist" PATH="$LIST_TMP/bin:/usr/bin:/bin" \
    "$PICKER" --delete $'TEXT\t1\ttext entry'
grep -q '1.*text entry' "$LIST_TMP/delete.log" && pass 'Ctrl+D deletes a text entry only' || fail 'text entry was not sent to cliphist delete'
rm -rf "$LIST_TMP"

RESET_TMP=$(mktemp -d)
mkdir -p "$RESET_TMP/hist" "$RESET_TMP/bin"
printf 'old database' > "$RESET_TMP/db"
printf 'old image' > "$RESET_TMP/hist/old.png"
cat > "$RESET_TMP/bin/cliphist" <<'EOF'
#!/usr/bin/env bash
if [[ "${*: -1}" == wipe ]]; then
    printf 'wipe\n' >> "${CLIPHIST_WIPE_LOG:?}"
fi
EOF
chmod +x "$RESET_TMP/bin/cliphist"
CLIPHIST_DB_PATH="$RESET_TMP/db" \
CLIPHIST_LOCK_PATH="$RESET_TMP/lock" \
CLIPBOARD_HIST_DIR="$RESET_TMP/hist" \
CLIPHIST_WIPE_LOG="$RESET_TMP/wipe.log" \
PATH="$RESET_TMP/bin:/usr/bin:/bin" \
    "$RESET_SCRIPT" >/dev/null
[[ ! -e "$RESET_TMP/db" ]] && pass 'reset recreates the database sequence' || fail 'reset left the old database sequence'
grep -q '^wipe$' "$RESET_TMP/wipe.log" && pass 'reset wipes cliphist before recreating it' || fail 'reset did not wipe cliphist'
[[ ! -e "$RESET_TMP/hist/old.png" ]] && pass 'reset removes saved image history' || fail 'reset left saved image history'
rm -rf "$RESET_TMP"

if ((FAILED)); then
    exit 1
fi
printf 'PASS  clipboard picker checks passed\n'
