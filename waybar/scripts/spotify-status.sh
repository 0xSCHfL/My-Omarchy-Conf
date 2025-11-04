#!/bin/bash

if playerctl -l | grep -q "^spotify$"; then
    status=$(playerctl --player=spotify status)
    artist=$(playerctl --player=spotify metadata artist | sed 's/&/\&amp;/g')
    title=$(playerctl --player=spotify metadata title | sed 's/&/\&amp;/g')

    if [[ "$status" == "Playing" ]]; then
        echo "{\"text\":\"  $artist - $title\"}"
    elif [[ "$status" == "Paused" ]]; then
        echo "{\"text\":\" $artist - $title\"}"
    else
        echo "{\"text\":\" \"}"
    fi
else
    echo "{\"text\":\" Not running\"}"
fi

