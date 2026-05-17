#!/bin/bash
# Toggle voxtype recording.
# On stop: wait for transcription to complete and auto-type at cursor.

set -u

RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
STATE_FILE="$RUNTIME_DIR/voxtype/state"
LOG_FILE="$RUNTIME_DIR/voxtype-toggle.log"

log() {
  printf "%s %s\n" "$(date '+%F %T')" "$*" >> "$LOG_FILE"
}

clip_get() {
  xclip -selection clipboard -o 2>/dev/null || true
}

kb_layout_get() {
  setxkbmap -query 2>/dev/null | awk '/^layout:/{print $2}'
}

kb_variant_get() {
  setxkbmap -query 2>/dev/null | awk '/^variant:/{print $2}'
}

before_state=$(cat "$STATE_FILE" 2>/dev/null || echo "unknown")
before_clip=$(clip_get)

log "toggle start state=$before_state clip_len=${#before_clip}"

if ! voxtype record toggle; then
  log "voxtype toggle failed"
  notify-send "Voxtype" "Toggle failed" -u normal -t 1800
  exit 1
fi

# Start branch: nothing to paste yet.
if [[ "$before_state" != "recording" ]]; then
  log "recording started"
  exit 0
fi

# Stop branch: type as soon as new clipboard text appears.
# 120 * 0.1s = 12s max wait (same practical timeout, faster detection).
for _ in {1..120}; do
  after_state=$(cat "$STATE_FILE" 2>/dev/null || echo "unknown")
  after_clip=$(clip_get)

  if [[ -n "$after_clip" && "$after_clip" != "$before_clip" ]]; then
    log "transcript detected state=$after_state; typing clip_len=${#after_clip}"
    old_layout="$(kb_layout_get)"
    old_variant="$(kb_variant_get)"
    if [[ -n "$old_layout" && "$old_layout" != "us" ]]; then
      setxkbmap us >/dev/null 2>&1 || true
    fi
    xdotool type --clearmodifiers --delay 0 "$after_clip"
    if [[ -n "$old_layout" && "$old_layout" != "us" ]]; then
      if [[ -n "$old_variant" ]]; then
        setxkbmap "$old_layout" -variant "$old_variant" >/dev/null 2>&1 || true
      else
        setxkbmap "$old_layout" >/dev/null 2>&1 || true
      fi
    fi
    exit 0
  fi

  sleep 0.1
done

log "timeout waiting transcript; state=$(cat "$STATE_FILE" 2>/dev/null || echo 'unknown')"
notify-send "Voxtype" "No new transcript detected (timeout)" -u low -t 1600
exit 0
