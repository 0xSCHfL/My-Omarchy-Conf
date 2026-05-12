#!/bin/bash

if playerctl -l 2>/dev/null | grep -q "^spotify$"; then
    status=$(playerctl --player=spotify status 2>/dev/null)
    artist=$(playerctl --player=spotify metadata artist 2>/dev/null)
    title=$(playerctl --player=spotify metadata title 2>/dev/null)

    if [[ "$status" == "Playing" ]]; then
        echo "  $artist - $title"
    elif [[ "$status" == "Paused" ]]; then
        echo "  $artist - $title"
    else
        echo ""
    fi
else
    echo ""
fi
