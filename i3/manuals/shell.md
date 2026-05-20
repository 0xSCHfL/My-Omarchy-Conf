# Shell Manual

Local shell config is split between:

- `~/.zshrc`
- `~/.zsh_aliases`
- `~/.config/shell/aliases`

## Defaults

```bash
EDITOR=nvim
VISUAL=nvim
TERMINAL=kitty
```

## Startup Behavior

- `fastfetch` runs at interactive shell start.
- `starship` provides the prompt.
- `zoxide` replaces `cd`.
- On tty1, the shell starts X automatically with `startx`.
- Pywal terminal colors are restored from `~/.cache/wal/sequences`.

## Common Aliases

| Alias | Action |
|-------|--------|
| `vi`, `vim` | Open `nvim` |
| `ll` | Detailed file list |
| `y` | Open `yazi` |
| `opc` | Run `opencode` |
| `ff` | `fzf` with `bat` preview |
| `dupdate` | Dotfiles update alias if defined locally |

## Package Helpers

| Function | Action |
|----------|--------|
| `pacf` / `paci` | Install official packages, with fzf if no args |
| `pacd` | Remove official packages |
| `yayf` / `yayi` | Install AUR packages, with fzf if no args |
| `yayd` | Remove AUR packages |

## Editing

```bash
nvim ~/.zshrc ~/.zsh_aliases ~/.config/shell/aliases
```
