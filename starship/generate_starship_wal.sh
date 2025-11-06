#!/bin/bash
# ~/.config/starship/generate_starship_wal.sh

WAL_COLORS="$HOME/.cache/wal/colors.json"
STARSHIP_CONF="$HOME/.config/starship/starship.toml"

# Read colors from pywal
BG=$(jq -r '.special.background' "$WAL_COLORS")
FG=$(jq -r '.special.foreground' "$WAL_COLORS")
ACCENT1=$(jq -r '.colors.color1' "$WAL_COLORS")
ACCENT2=$(jq -r '.colors.color2' "$WAL_COLORS")
ACCENT3=$(jq -r '.colors.color3' "$WAL_COLORS")

# Replace placeholders in a Starship template
env BG=$BG FG=$FG ACCENT1=$ACCENT1 ACCENT2=$ACCENT2 ACCENT3=$ACCENT3 envsubst < ~/.config/starship/starship_template.toml > "$STARSHIP_CONF"

