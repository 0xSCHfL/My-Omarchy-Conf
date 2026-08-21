#!/usr/bin/env bash
set -euo pipefail

wid="$(xdotool getwindowfocus 2>/dev/null || true)"
if [[ -z "$wid" ]]; then
    exit 0
fi

state="$(
    i3-msg -t get_tree |
        python3 -c '
import json
import sys

window_id = int(sys.argv[1])

def find_window(node):
    if node.get("window") == window_id:
        return node
    for child in node.get("nodes", []) + node.get("floating_nodes", []):
        found = find_window(child)
        if found:
            return found
    return None

window = find_window(json.load(sys.stdin))
if window and window.get("sticky"):
    print("pinned")
elif window:
    print("normal")
' "$wid"
)"

if [[ "$state" == "pinned" ]]; then
    i3-msg "[id=$wid] sticky disable, floating disable" >/dev/null
else
    i3-msg "[id=$wid] floating enable, sticky enable, resize set 500 400, move position center" >/dev/null
    xdotool windowraise "$wid" 2>/dev/null || true
fi
