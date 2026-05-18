#!/bin/bash

focused_output=$(
  i3-msg -t get_workspaces 2>/dev/null | python3 -c '
import json
import sys

try:
    workspaces = json.load(sys.stdin)
    focused = next((w for w in workspaces if w.get("focused")), {})
    print(focused.get("output", ""))
except Exception:
    print("")
'
)

font_size="12.0"
case "$focused_output" in
  eDP-*|LVDS-*) font_size="9" ;;
esac

alacritty --class i3-gdrive -o "font.size=$font_size" -e i3-gdrive &

for _ in {1..30}; do
  sleep 0.05
  i3-msg '[class="i3-gdrive"] floating enable, resize set 1100 680, move position center' >/dev/null 2>&1
done

# Float OAuth browser window when it appears
(
  for _ in {1..600}; do
    sleep 0.1
    i3-msg '[class="Brave-browser"] floating enable, resize set 1100 750, move position center' >/dev/null 2>&1
  done
) &
