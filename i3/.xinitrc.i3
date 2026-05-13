# Touchpad — enable tap-to-click
xinput set-prop "SYNA308F:00 06CB:CD77 Touchpad" "libinput Tapping Enabled" 1 2>/dev/null

# Pass DISPLAY to systemd so xdg-desktop-portal-gtk can open file dialogs in browser
systemctl --user import-environment DISPLAY XAUTHORITY
systemctl --user restart xdg-desktop-portal-gtk

exec i3
