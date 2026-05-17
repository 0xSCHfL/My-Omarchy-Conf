#!/bin/bash
# Toggle voxtype recording. On stop, auto-type the transcribed text.

STATE_FILE="/run/user/$(id -u)/voxtype/state"
BEFORE=$(cat "$STATE_FILE" 2>/dev/null)

# Toggle recording
voxtype record toggle

# If we were recording, wait for transcription and auto-type
if [[ "$BEFORE" == "recording" ]]; then
  # Wait up to 10 seconds for transcription
  for i in {1..20}; do
    AFTER=$(cat "$STATE_FILE" 2>/dev/null)
    if [[ "$AFTER" == "idle" ]]; then
      sleep 0.3
      # Auto-type the transcribed text
      xdotool key --clearmodifiers ctrl+v
      exit 0
    fi
    sleep 0.5
  done

  # Timeout fallback
  xdotool key --clearmodifiers ctrl+v
fi
