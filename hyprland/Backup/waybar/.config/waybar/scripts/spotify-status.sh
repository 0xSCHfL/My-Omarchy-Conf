#!/bin/bash

if playerctl -l | grep -q "^spotify$"; then
    status=$(playerctl --player=spotify status)
    artist=$(playerctl --player=spotify metadata artist | sed 's/&/\&amp;/g')
    title=$(playerctl --player=spotify metadata title | sed 's/&/\&amp;/g')

    if [[ "$status" == "Playing" ]]; then
        echo "{\"text\":\"󰜏   $artist - $title 󰜎\",\"class\":\"playing\"}"
    elif [[ "$status" == "Paused" ]]; then
        echo "{\"text\":\"󰜏  $artist - $title 󰜎\",\"class\":\"paused\"}"
    else
        echo "{\"text\":\"󰜏  󰜎\",\"class\":\"stopped\"}"
    fi
else
    echo "{\"text\":\"󰜏  Not running 󰜎\",\"class\":\"not-running\"}"
fi

