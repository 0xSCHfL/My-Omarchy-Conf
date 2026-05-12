#!/bin/bash

is_floating=$(i3-msg -t get_tree | python3 -c "
import json, sys
def find_focused(node):
    if node.get('focused'):
        return node
    for child in node.get('nodes', []) + node.get('floating_nodes', []):
        r = find_focused(child)
        if r: return r
    return None
focused = find_focused(json.load(sys.stdin))
print('yes' if focused and focused.get('floating', '').startswith('user_on') else 'no')
")

if [[ "$is_floating" == "yes" ]]; then
    i3-msg "floating disable"
else
    i3-msg "floating enable, resize set 875 600, move position center"
fi
