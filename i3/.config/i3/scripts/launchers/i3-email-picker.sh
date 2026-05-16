#!/bin/bash

# Email profile picker for Chromium
# Opens Gmail with selected account

profile_choice=$(echo -e "Personal\nWork" | rofi -dmenu -no-sort -i \
  -theme ~/.config/rofi/dwm-keys.rasi \
  -kb-row-up 'k,Up' \
  -kb-row-down 'j,Down' \
  -kb-cancel 'Escape,h,q' \
  -p 'Profile:')

case "$profile_choice" in
  Personal)
    email_choice=$(echo -e "lkhawamed29@gmail.com\nkarboussouhaib@gmail.com\nahanekamil29@gmail.com" | rofi -dmenu -no-sort -i \
      -theme ~/.config/rofi/dwm-keys.rasi \
      -kb-row-up 'k,Up' \
      -kb-row-down 'j,Down' \
      -kb-cancel 'Escape,h,q' \
      -p 'Email:')

    if [ -n "$email_choice" ]; then
      chromium --profile-directory=Default --app="https://mail.google.com/" --ozone-platform=x11 &
    fi
    ;;
  Work)
    chromium --profile-directory="Profile 2" --app="https://mail.google.com/" --ozone-platform=x11 &
    ;;
esac
