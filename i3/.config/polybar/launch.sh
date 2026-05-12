#!/bin/bash

killall -q polybar nm-applet copyq flameshot
while pgrep -u $UID -x polybar > /dev/null; do sleep 0.1; done

MONITORS=$(polybar --list-monitors)
MONITOR_PRIMARY=$(echo "$MONITORS" | grep "primary" | cut -d":" -f1)
MONITOR_EXTRA=$(echo "$MONITORS" | grep -v "primary" | cut -d":" -f1)

MONITOR=${MONITOR_PRIMARY} polybar main &

for m in $MONITOR_EXTRA; do
    MONITOR=$m polybar main &
done

sleep 0.5
nm-applet &
copyq &
flameshot &
