#!/bin/bash

direction=${1:-next}
current=$(xdotool getactivewindow 2>/dev/null)
desktop=$(xdotool get_desktop 2>/dev/null)
mapfile -t windows < <(xdotool search --onlyvisible --desktop "$desktop" "" 2>/dev/null)

if [[ ${#windows[@]} -eq 0 ]]; then exit 0; fi

for i in "${!windows[@]}"; do
  if [[ "${windows[$i]}" == "$current" ]]; then
    if [[ "$direction" == "prev" ]]; then
      next_idx=$(( (i - 1 + ${#windows[@]}) % ${#windows[@]} ))
    else
      next_idx=$(( (i + 1) % ${#windows[@]} ))
    fi
    xdotool windowfocus --sync "${windows[$next_idx]}"
    xdotool windowraise "${windows[$next_idx]}"
    exit 0
  fi
done

xdotool windowfocus "${windows[0]}"
