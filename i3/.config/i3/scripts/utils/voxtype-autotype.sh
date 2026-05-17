#!/bin/bash
# Stop voxtype recording and auto-type the transcribed text using xdotool

voxtype record stop

# Wait up to 10 seconds for transcription to complete
for i in {1..20}; do
  STATE=$(voxtype status 2>/dev/null)
  if [[ "$STATE" == "idle" ]]; then
    # Transcription complete, auto-type the text
    sleep 0.3
    xdotool type --delay 10 "$(xclip -selection clipboard -o 2>/dev/null)"
    exit 0
  fi
  sleep 0.5
done

# Fallback: type whatever's in clipboard anyway
xdotool type --delay 10 "$(xclip -selection clipboard -o 2>/dev/null)"
