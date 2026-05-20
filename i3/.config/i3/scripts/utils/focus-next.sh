#!/bin/bash

direction=${1:-next}

# Get only real app windows in current workspace via i3 IPC (tiled + floating)
get_tree=$(i3-msg -t get_tree)

mapfile -t window_ids < <(echo "$get_tree" | python3 -c "
import json, sys

def all_nodes(node):
    yield node
    for child in node.get('nodes', []) + node.get('floating_nodes', []):
        yield from all_nodes(child)

def find_focused_workspace(node):
    if node.get('type') == 'workspace':
        if any(n.get('focused') for n in all_nodes(node)):
            return node
    for child in node.get('nodes', []) + node.get('floating_nodes', []):
        result = find_focused_workspace(child)
        if result: return result
    return None

def leaf_windows(node):
    if not node.get('nodes') and not node.get('floating_nodes') and node.get('window'):
        yield node['window']
    for child in node.get('nodes', []) + node.get('floating_nodes', []):
        yield from leaf_windows(child)

ws = find_focused_workspace(json.load(sys.stdin))
if ws:
    for wid in leaf_windows(ws):
        print(wid)
")

if [[ ${#window_ids[@]} -le 1 ]]; then exit 0; fi

current=$(xdotool getactivewindow 2>/dev/null)

# Check if current focused window is the special full-workspace floating state
# created by maximize.sh. Normal floating popups/manuals must not be resized by Alt+Tab.
is_maximized=$(echo "$get_tree" | python3 -c "
import json, sys
data = json.load(sys.stdin)

def find_focused(node):
    if node.get('focused'):
        return node
    for child in node.get('nodes', []) + node.get('floating_nodes', []):
        r = find_focused(child)
        if r: return r
    return None

def find_focused_workspace(node):
    if node.get('type') == 'workspace':
        if any(n.get('focused') for n in all_nodes(node)):
            return node
    for child in node.get('nodes', []) + node.get('floating_nodes', []):
        r = find_focused_workspace(child)
        if r: return r
    return None

def all_nodes(node):
    yield node
    for child in node.get('nodes', []) + node.get('floating_nodes', []):
        yield from all_nodes(child)

f = find_focused(data)
ws = find_focused_workspace(data)
if not f or not ws or not str(f.get('floating', '')).startswith('user_on'):
    print('no')
    raise SystemExit

fr = f.get('rect', {})
wr = ws.get('rect', {})
tolerance = 8
same_size = abs(fr.get('width', 0) - wr.get('width', 0)) <= tolerance and abs(fr.get('height', 0) - wr.get('height', 0)) <= tolerance
same_pos = abs(fr.get('x', 0) - wr.get('x', 0)) <= tolerance and abs(fr.get('y', 0) - wr.get('y', 0)) <= tolerance
print('yes' if same_size and same_pos else 'no')
")

for i in "${!window_ids[@]}"; do
    if [[ "${window_ids[$i]}" == "$current" ]]; then
        if [[ "$direction" == "prev" ]]; then
            next_idx=$(( (i - 1 + ${#window_ids[@]}) % ${#window_ids[@]} ))
        else
            next_idx=$(( (i + 1) % ${#window_ids[@]} ))
        fi
        next_win="${window_ids[$next_idx]}"

        if [[ "$is_maximized" == "yes" ]]; then
            # Focus next → maximize next → un-maximize previous (now hidden behind)
            i3-msg "[id=$next_win] focus"
            ~/.config/i3/scripts/utils/maximize.sh
            i3-msg "[id=$current] floating disable"
        else
            xdotool windowfocus --sync "$next_win"
            xdotool windowraise "$next_win"
        fi
        exit 0
    fi
done

xdotool windowfocus "${window_ids[0]}"
