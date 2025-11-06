#!/bin/bash
WAL="$HOME/.cache/wal/colors.json"

# Extract colors from Pywal JSON
get_color() { jq -r ".colors.color$1" "$WAL"; }

export STARSHIP_BG1=$(get_color 0)   # background
export STARSHIP_BG2=$(get_color 1)
export STARSHIP_BG3=$(get_color 2)
export STARSHIP_BG4=$(get_color 4)
export STARSHIP_BG5=$(get_color 6)
export STARSHIP_BG6=$(get_color 12)
export STARSHIP_FG=$(jq -r ".special.foreground" "$WAL")

