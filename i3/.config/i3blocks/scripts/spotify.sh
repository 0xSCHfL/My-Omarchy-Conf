#!/usr/bin/env bash

case $BLOCK_BUTTON in
    1) playerctl --player=spotify play-pause ;;
    2) playerctl --player=spotify previous ;;
    3) playerctl --player=spotify next ;;
esac

status=$(playerctl --player=spotify status 2>/dev/null)

if [ -z "$status" ] || [ "$status" = "No players found" ]; then
    exit 0
fi

artist=$(playerctl --player=spotify metadata artist 2>/dev/null)
title=$(playerctl --player=spotify metadata title 2>/dev/null)

if [ "$status" = "Playing" ]; then
    icon="▶"
else
    icon="⏸"
fi

echo "| $icon $artist - $title"
