# Neovim Manual

Local config: `~/.config/nvim`

This setup is based on LazyVim. This manual documents how to use this machine's Neovim setup, not generic Vim theory.

## Mental Model

| Key | Meaning |
|-----|---------|
| `Space` | Leader key |
| `Esc` | Return to normal mode |
| `i` | Insert mode |
| `v` | Visual select |
| `:` | Command mode |
| `q` | Quit the current picker/menu when supported |

Most custom actions start with `Space`.

## Open Files

| Key | Action |
|-----|--------|
| `Space e` | Open file explorer at project root |
| `Space E` | Open file explorer at current directory |
| `Space fe` | File explorer at root |
| `Space fE` | File explorer at current directory |
| `Space ff` | Find files from project root |
| `Space fF` | Find files from current directory |
| `Space fg` | Find git-tracked files |
| `Space fr` | Recent files |
| `Space fR` | Recent files from current directory |
| `Space fc` | Find Neovim config file |

Fast daily flow:

```text
Space ff   find file
Space /    search text in project
Space e    open tree if you need browsing
```

## File Explorer

The explorer is Neo-tree.

| Key | Action |
|-----|--------|
| `Space e` | Toggle/open explorer at root |
| `Space E` | Toggle/open explorer at cwd |
| `Enter` | Open file/folder |
| `a` | Add file or directory |
| `d` | Delete |
| `r` | Rename |
| `y` | Copy |
| `x` | Cut |
| `p` | Paste |
| `q` | Close explorer |

Tip: use `Space ff` when you already know part of the filename. Use `Space e` when you want to browse the tree.

## Search / Fuzzy Find

| Key | Action |
|-----|--------|
| `Space /` | Grep/search text in project root |
| `Space sg` | Grep in project root |
| `Space sG` | Grep in current directory |
| `Space sw` | Search word under cursor in project root |
| `Space sW` | Search word under cursor in current directory |
| `Space sb` | Search lines in open buffers |
| `Space sk` | Search keymaps |
| `Space sh` | Search help pages |
| `Space sC` | Search commands |
| `Space sm` | Search marks |
| `Space sj` | Search jumps |

Common pattern:

```text
Space ff   find a file
Space /    find text
Space sk   remember a keybind
```

## Buffers

Buffers are open files.

| Key | Action |
|-----|--------|
| `Shift+h` | Previous buffer |
| `Shift+l` | Next buffer |
| `Space ,` | Buffer picker |
| `Space fb` | Buffer picker |
| `Space fB` | All buffers |
| `Space bd` | Delete current buffer |
| `Space bp` | Pin buffer |
| `Space bP` | Delete non-pinned buffers |
| `Space bl` | Delete buffers to the left |
| `Space br` | Delete buffers to the right |

## Panes / Windows

Vim calls panes "windows".

| Key | Action |
|-----|--------|
| `Ctrl+w v` | Open vertical split |
| `Ctrl+w s` | Open horizontal split |
| `Ctrl+w h` | Move to left split |
| `Ctrl+w j` | Move to lower split |
| `Ctrl+w k` | Move to upper split |
| `Ctrl+w l` | Move to right split |
| `Ctrl+w q` | Close current split |
| `Ctrl+w =` | Equalize split sizes |

This setup also has Vim/tmux navigation:

| Key | Action |
|-----|--------|
| `Ctrl+h` | Move left, across Neovim split or tmux pane |
| `Ctrl+j` | Move down |
| `Ctrl+k` | Move up |
| `Ctrl+l` | Move right |

That means you can move between Neovim and tmux panes with the same keys.

## Git

| Key | Action |
|-----|--------|
| `Space gs` | Git status |
| `Space gd` | Git diff hunks |
| `Space gD` | Git diff against origin |
| `Space gS` | Git stash |

## Diagnostics / Trouble

| Key | Action |
|-----|--------|
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |
| `]D` | Last diagnostic |
| `[D` | First diagnostic |
| `Space sd` | Diagnostics picker |
| `Space sD` | Buffer diagnostics picker |
| `Space xx` | Diagnostics in Trouble |
| `Space xX` | Buffer diagnostics in Trouble |
| `Space xQ` | Quickfix list in Trouble |

## LSP / Code

| Key | Action |
|-----|--------|
| `grr` | References |
| `gri` | Implementation |
| `grt` | Type definition |
| `grn` | Rename symbol |
| `gra` | Code action |
| `gO` | Document symbols |
| `K` | Hover documentation |
| `Space cF` | Format injected languages |

## Markdown

Local plugin: `peek.nvim`

| Key | Action |
|-----|--------|
| `Space mp` | Toggle Markdown preview |
| `Space mP` | Open Markdown preview in a right Neovim split using `glow` |

## Sessions / Scratch

| Key | Action |
|-----|--------|
| `Space qs` | Restore session |
| `Space ql` | Restore last session |
| `Space qS` | Select session |
| `Space qd` | Do not save current session |
| `Space .` | Toggle scratch buffer |
| `Space S` | Select scratch buffer |

## Plugin / Tool Commands

| Command | Purpose |
|---------|---------|
| `:Lazy` | Plugin manager |
| `:Lazy sync` | Update/sync plugins |
| `:Mason` | LSP/tool installer |
| `:checkhealth` | Health check |

## Editing This Config

```bash
nvim ~/.config/nvim
```

Important files:

| File | Purpose |
|------|---------|
| `lua/config/options.lua` | Options |
| `lua/config/keymaps.lua` | Extra keymaps |
| `lua/config/autocmds.lua` | Autocommands |
| `lua/plugins/*.lua` | Plugin specs |
| `lazyvim.json` | LazyVim extras |
| `lazy-lock.json` | Locked plugin versions |

After changing plugin specs:

```bash
nvim --headless "+Lazy! sync" +qa
```
