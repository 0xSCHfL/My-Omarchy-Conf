---
name: i3
description: |-
  Manage i3/X11 desktop config on Arch Linux: keybindings, layouts, gaps, borders, floating rules,
  workspaces, focus, bar, startup, wallpaper, launcher, notifications, screenshots, clipboard,
  xrandr, session switching, and live runtime debugging. Use when editing ~/.config/i3/,
  ~/.config/dunst/, ~/.config/picom/, ~/.config/rofi/, ~/.config/kitty/, ~/.config/i3blocks/,
  ~/.local/bin/ scripts, or ~/.xinitrc.
  Use proactively for broken bindings, wallpaper/theme not applying, clipboard issues,
  notification problems, pywal/tmux color issues, and session troubleshooting.
  
  Examples:
  - user: "Change the mod key to Super" → edit .config/i3/config, restow, reload
  - user: "Wallpaper not changing" → trace wallpaper-set.sh, check pywal cache, check feh
  - user: "Add a screenshot keybind" → add binding in config, create script, update i3-keys
  - user: "Notifications not working" → check dunst daemon state, script path, binding
  - user: "Pywal colors not in tmux" → check sequences file, zshrc pywal restore, kitty include
---
# i3 Skill

Manage i3/X11 desktop configuration, related dotfiles, and live session debugging.

## Project Structure

```
~/Work/dotfiles/i3/
├── .config/i3/
│   ├── config                    # Main i3 config
│   └── scripts/
│       ├── launchers/            # i3-launch-walker, show-keybindings.sh
│       ├── wallpaper/            # wallpaper-set.sh, wallpaper-pick.sh, wallpaper-next.sh
│       ├── notifications/        # Dunst controls
│       ├── media/                # Volume OSD
│       └── utils/                # float-toggle.sh, focus-next.sh, maximize.sh
├── .config/i3blocks/             # Status bar scripts
├── .config/rofi/                 # Launcher theme & config
├── .config/kitty/                # Terminal config (pywal include)
├── .local/bin/                   # i3-keys, i3-sys, i3-imgpicker, etc.
├── shell/                        # .zshenv, .zshrc, .zsh_aliases (stowed separately)
└── default/i3/                   # This skill
```

## Working Rules

- Inspect first, then edit.
- Prefer changing the dotfiles source in `~/Work/dotfiles/i3/` and restowing, rather than editing live files.
- Keep changes minimal and consistent with the existing i3 workflow.
- Do not introduce Hyprland/Wayland assumptions into i3 paths or commands.
- When keybindings change, update any manual help UIs (`i3-keys`, `README.md`).

## Apply & Verify

```bash
cd ~/Work/dotfiles && stow --restow i3        # Restow i3 package
i3 -C -c ~/.config/i3/config                  # Validate syntax
i3-msg reload                                  # Reload i3
```

For shell changes:
```bash
cd ~/Work/dotfiles && stow -d i3 -t $HOME shell  # Restow shell package
```

Targeted app restarts:
- `pkill dunst && dunst &`
- `pkill picom && picom --daemon`
- `pkill i3blocks && i3blocks &`

## References

- [Keybindings](references/keybindings.md) — full keybinding table
- [Wallpaper & Pywal](references/wallpaper.md) — wallpaper scripts, pywal color flow
- [Runtime Debugging](references/runtime-check.md) — tracing broken bindings, daemon state, live session issues
