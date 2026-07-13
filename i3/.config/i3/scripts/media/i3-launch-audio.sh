#!/bin/bash

# i3 Audio Manager - Launch WireMix TUI

focused_workspace=$(
  i3-msg -t get_workspaces 2>/dev/null | python3 -c '
import json
import sys

try:
    workspaces = json.load(sys.stdin)
    focused = next((w for w in workspaces if w.get("focused")), {})
    print(focused.get("name", ""))
except Exception:
    print("")
'
)

alacritty --class i3-audio -e wiremix &

for _ in {1..30}; do
  sleep 0.05
  if [[ -n "$focused_workspace" ]]; then
    i3-msg "[class=\"i3-audio\"] move to workspace \"$focused_workspace\", floating enable, resize set 800 600, move position center" >/dev/null 2>&1
  else
    i3-msg '[class="i3-audio"] floating enable, resize set 800 600, move position center' >/dev/null 2>&1
  fi
done
