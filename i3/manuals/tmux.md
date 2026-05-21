# Tmux Manual

Local config: `~/.config/tmux/tmux.conf`

## Prefix

The prefix is:

```text
Ctrl+Space
```

`Ctrl+b` is unbound.

## Local Keybinds

| Key | Action |
|-----|--------|
| `Prefix r` | Reload tmux config |
| `Prefix w` | Open custom session/window popup |
| `v` in copy-mode | Begin selection |
| `y` in copy-mode | Copy selection |

## Behavior

- Mouse is enabled.
- Vi mode is enabled in copy-mode.
- Scrollback history is `100000`.
- Status bar is at the top.
- Theme is Melange-inspired.
- TPM loads plugins at the end.

## Plugins

- `tmux-sensible`
- `tmux-resurrect`
- `tmux-continuum`
- `tmux-yank`
- `vim-tmux-navigator`

## Useful Commands

```bash
tmux attach || tmux new -s Work
tmux source-file ~/.config/tmux/tmux.conf
~/.config/tmux/scripts/tmux-menu.sh
```
