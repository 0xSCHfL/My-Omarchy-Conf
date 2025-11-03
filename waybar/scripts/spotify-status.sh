#!/bin/bash

if playerctl -l | grep -q "^spotify$"; then
    status=$(playerctl --player=spotify status)
    if [[ "$status" == "Playing" ]]; then
        artist=$(playerctl --player=spotify metadata artist)
        title=$(playerctl --player=spotify metadata title)
        echo "{\"text\":\" $artist - $title\"}"
    else
        echo "{\"text\":\"\"}"
    fi
else
    echo "{\"text\":\"\"}"
fi

