#!/bin/bash

SESSION=$({
	tmux list-sessions -F '#S' 2>/dev/null | grep -v '^_popup_' | while read -r session; do
		echo "SESSION:$session"
		tmux list-windows -t "$session" -F 'WINDOW:#S:#I #W'
	done
} | sed 's/^SESSION:/▼ /' | sed 's/^WINDOW:/  ⦿ /' |
	fzf --reverse |
	awk '{
  if ($1 == "▼") {
    print $2
  } else if ($1 == "⦿") {
    print $2
  }
}')

if [ -n "$SESSION" ]; then
	i3-msg "[class=i3-tmux-chooser] floating disable"
	exec tmux attach-session -t "$SESSION"
fi
