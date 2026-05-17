#!/bin/bash
# Toggle voxtype and automatically paste transcribed text using xdotool

STATE_FILE="/run/user/$(id -u)/voxtype/state"

# Get current state before toggle
BEFORE_STATE=$(cat "$STATE_FILE" 2>/dev/null)

# Toggle recording
voxtype record toggle

# If we were idle/stopped, wait for transcription to complete
if [[ "$BEFORE_STATE" != "recording" ]]; then
  # Wait up to 10 seconds for transcription to complete
  for i in {1..20}; do
    sleep 0.5
    AFTER_STATE=$(cat "$STATE_FILE" 2>/dev/null)
    if [[ "$AFTER_STATE" == "idle" ]] || [[ -z "$AFTER_STATE" ]]; then
      # Transcription complete, paste text
      sleep 0.2
      xdotool type --delay 10 "$(xclip -selection clipboard -o)"
      break
    fi
  done
fi
