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
    # Get workspace geometry to compute full-width dimensions ignoring outer gaps
    read WX WY WW WH < <(i3-msg -t get_workspaces | python3 -c "
import json, sys
ws = json.load(sys.stdin)
focused = next((w for w in ws if w['focused']), ws[0])
r = focused['rect']
print(r['x'], r['y'], r['width'], r['height'])
")
    FULL_W=$((WW + 2 * WX))
    FULL_H=$((WH + 2 * WY))
    i3-msg "floating enable, resize set ${FULL_W} px ${FULL_H} px, move position -${WX} -${WY}"
fi
