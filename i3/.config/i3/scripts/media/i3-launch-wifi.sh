#!/bin/bash

# i3 WiFi Manager - Launch Impala TUI

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

rfkill unblock wifi 2>/dev/null
alacritty --class i3-wifi -e impala &

for _ in {1..30}; do
  sleep 0.05
  if [[ -n "$focused_workspace" ]]; then
    i3-msg "[class=\"i3-wifi\"] move to workspace \"$focused_workspace\", floating enable, resize set 800 600, move position center" >/dev/null 2>&1
  else
    i3-msg '[class="i3-wifi"] floating enable, resize set 800 600, move position center' >/dev/null 2>&1
  fi
done
