#!/bin/bash

RESULT_FILE=$(mktemp)

kitty --class i3-tmux-chooser -e bash -c "
SESSION=\$({
	tmux list-sessions -F '#S' 2>/dev/null | grep -v '^_popup_' | while read -r session; do
		echo \"SESSION:\$session\"
		tmux list-windows -t \"\$session\" -F 'WINDOW:#S:#I #W'
	done
} | sed 's/^SESSION:/▼ /' | sed 's/^WINDOW:/  ⦿ /' |
	fzf --reverse |
	awk '{
  if (\$1 == \"▼\") {
    print \$2
  } else if (\$1 == \"⦿\") {
    print \$2
  }
}')
[ -n \"\$SESSION\" ] && echo \"\$SESSION\" > $RESULT_FILE
"

if [ -s "$RESULT_FILE" ]; then
	SESSION=$(cat "$RESULT_FILE")
	rm -f "$RESULT_FILE"
	i3-msg exec kitty -e tmux\ attach-session -t "$SESSION"
else
	rm -f "$RESULT_FILE"
fi
