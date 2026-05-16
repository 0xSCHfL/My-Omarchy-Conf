# Touchpad — enable tap-to-click
xinput set-prop "SYNA308F:00 06CB:CD77 Touchpad" "libinput Tapping Enabled" 1 2>/dev/null

export XDG_CURRENT_DESKTOP=i3
systemctl --user import-environment DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP
systemctl --user restart xdg-desktop-portal &

exec i3
