#!/usr/bin/env bash

set -u

sound_path_file="${DUNST_SOUND_PATH_FILE:-${XDG_STATE_HOME:-$HOME/.local/state}/dunst/notification-sound.path}"
if [[ -n "${DUNST_SOUND_FILE:-}" ]]; then
    sound_file="$DUNST_SOUND_FILE"
elif [[ -r "$sound_path_file" ]]; then
    sound_file=$(<"$sound_path_file")
else
    sound_file='/usr/share/sounds/freedesktop/stereo/message.oga'
fi
state_file="${DUNST_SOUND_STATE_FILE:-${XDG_STATE_HOME:-$HOME/.local/state}/dunst/notification-sound.disabled}"

[ -r "$sound_file" ] || exit 0
[ -e "$state_file" ] && exit 0

# Start playback in the background so Dunst never waits for the sound to end.
if command -v pw-play >/dev/null 2>&1; then
    setsid -f pw-play "$sound_file" >/dev/null 2>&1
elif command -v paplay >/dev/null 2>&1; then
    setsid -f paplay "$sound_file" >/dev/null 2>&1
fi
