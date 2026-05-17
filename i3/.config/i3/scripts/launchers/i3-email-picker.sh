#!/bin/bash

CHROME_DIR="$HOME/.config/chromium"

get_accounts() {
    local profile_dir="$1"
    python3 - "$profile_dir" <<'PYEOF'
import json, os, sys

chrome_dir = os.path.expanduser('~/.config/chromium')
profile_dir = sys.argv[1]
prefs_path = f'{chrome_dir}/{profile_dir}/Preferences'

if not os.path.exists(prefs_path):
    sys.exit(1)

with open(prefs_path) as f:
    prefs = json.load(f)

for idx, acc in enumerate(prefs.get('account_info', [])):
    email = acc.get('email', '')
    if email:
        print(f'{email}\t{profile_dir}\t{idx}')
PYEOF
}

open_gmail() {
    local profile_dir="$1"
    local idx="$2"
    rm -f "$HOME/.config/chromium/${profile_dir}/Singleton"*
    WAYLAND_DISPLAY= GDK_BACKEND=x11 chromium \
        --profile-directory="$profile_dir" \
        --app="https://mail.google.com/mail/u/$idx/" &
}

rofi_menu() {
    rofi -dmenu -no-sort -i \
        -theme ~/.config/rofi/dwm-keys.rasi \
        -kb-row-up 'k,Up' -kb-row-down 'j,Down' \
        -kb-cancel 'Escape,h,q' \
        -p "$1"
}

profile_choice=$(printf 'Personal\nWork' | rofi_menu 'Profile:')
[[ -z "$profile_choice" ]] && exit 0

case "$profile_choice" in
    Personal)
        mapfile -t accounts < <(get_accounts "Default")
        [[ ${#accounts[@]} -eq 0 ]] && exit 1

        selected=$(printf '%s\n' "${accounts[@]}" | cut -f1 | rofi_menu 'Email:')
        [[ -z "$selected" ]] && exit 0

        for entry in "${accounts[@]}"; do
            email=$(cut -f1 <<< "$entry")
            if [[ "$email" == "$selected" ]]; then
                open_gmail "$(cut -f2 <<< "$entry")" "$(cut -f3 <<< "$entry")"
                break
            fi
        done
        ;;
    Work)
        mapfile -t accounts < <(get_accounts "Profile 2")
        [[ ${#accounts[@]} -eq 0 ]] && exit 1

        if [[ ${#accounts[@]} -eq 1 ]]; then
            open_gmail "$(cut -f2 <<< "${accounts[0]}")" "$(cut -f3 <<< "${accounts[0]}")"
        else
            selected=$(printf '%s\n' "${accounts[@]}" | cut -f1 | rofi_menu 'Email:')
            [[ -z "$selected" ]] && exit 0
            for entry in "${accounts[@]}"; do
                email=$(cut -f1 <<< "$entry")
                if [[ "$email" == "$selected" ]]; then
                    open_gmail "$(cut -f2 <<< "$entry")" "$(cut -f3 <<< "$entry")"
                    break
                fi
            done
        fi
        ;;
esac
