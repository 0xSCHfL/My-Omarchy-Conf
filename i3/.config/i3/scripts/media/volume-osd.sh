#!/usr/bin/env bash

PIPE="/tmp/xob-vol"

# Get center of current monitor
MON_X=960
eval $(xdotool getmouselocation --shell 2>/dev/null)
while read -r line; do
  set -- $line
  rx=$1; rw=$2
  [ -z "$rw" ] && continue
  if [ "$X" -ge "$rx" ] && [ "$X" -lt "$((rx + rw))" ]; then
    MON_X=$((rx + rw / 2))
    break
  fi
done <<< "$(xrandr --query | awk '{for(i=1;i<=NF;i++){if($i~/^[0-9]+x[0-9]+\+[0-9]+/){split($i,a,"[x+]"); print a[3], a[1]}}}')"

CFG="$HOME/.config/xob/styles.cfg"
cat > "$CFG" <<EOF
volume = {
    orientation = "horizontal";
    x = { relative = 0.0; offset = $MON_X; };
    y = { relative = 1.0; offset = -32; };
    length = { relative = 0.0; offset = 240; };
    thickness = { absolute = 22; };
    border = 2;
    outline = 0;
    padding = 2;
    overflow = "hidden";
    color = {
        normal = { fg = "#c0b18b"; bg = "#262626cc"; border = "#c0b18b"; };
        alt = { fg = "#d75f5f"; bg = "#262626cc"; border = "#d75f5f"; };
        overflow = { fg = "#d75f5f"; bg = "#262626cc"; border = "#d75f5f"; };
        altoverflow = { fg = "#d75f5f"; bg = "#262626cc"; border = "#d75f5f"; };
    };
};
EOF

pkill -x xob 2>/dev/null || true
rm -f "$PIPE"
mkfifo "$PIPE"

exec sh -c "tail -f '$PIPE' | xob -q -s volume -c '$CFG' -t 1200 -m 100"
