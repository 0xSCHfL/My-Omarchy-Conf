#!/bin/bash

is_fullscreen=$(i3-msg -t get_tree | python3 -c "
import json, sys

def find_focused(node):
    if node.get('focused'):
        return node
    for child in node.get('nodes', []) + node.get('floating_nodes', []):
        r = find_focused(child)
        if r: return r
    return None

f = find_focused(json.load(sys.stdin))
print(f.get('fullscreen_mode', 0) if f else 0)
")

if [[ "$is_fullscreen" == "1" ]]; then
    i3-msg "fullscreen toggle"
    i3-msg "bar mode dock"
else
    i3-msg "bar mode invisible"
    i3-msg "fullscreen toggle"
fi
