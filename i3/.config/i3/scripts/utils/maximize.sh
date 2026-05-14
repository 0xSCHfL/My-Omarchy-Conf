#!/bin/bash

is_floating=$(i3-msg -t get_tree | python3 -c "
import json, sys

def find_focused(node):
    if node.get('focused'):
        return node
    for child in node.get('nodes', []) + node.get('floating_nodes', []):
        result = find_focused(child)
        if result:
            return result
    return None

focused = find_focused(json.load(sys.stdin))
print(focused.get('floating', '') if focused else '')
")

if [[ "$is_floating" == user_on* ]]; then
    i3-msg "floating disable"
else
    i3-msg "floating enable, resize set width 100 ppt, move position center"
fi
