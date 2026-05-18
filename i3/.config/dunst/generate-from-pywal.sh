#!/bin/bash
# Generate dunst config from pywal colors

# Source pywal colors
source ~/.cache/wal/colors.sh

# Generate dunst config
cat > ~/.config/dunst/dunstrc <<EOF
[global]
font = Iosevka 12
width = 400
height = (0, 120)
offset = (10, 10)
gap_size = 15
padding = 10
horizontal_padding = 15
frame_width = 2
frame_color = "$color4"
background = "$background"
foreground = "$foreground"

[urgency_low]
background = "$background"
foreground = "$foreground"

[urgency_normal]
background = "$background"
foreground = "$foreground"

[urgency_critical]
background = "$color1"
foreground = "$foreground"
timeout = 30
EOF

# Restart dunst
pkill dunst
sleep 0.5
dunst &
