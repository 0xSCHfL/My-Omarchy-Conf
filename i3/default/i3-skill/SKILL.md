---
name: i3
description: >
  REQUIRED for end-user customization of i3/X11 desktop configuration on Arch Linux.
  Use when editing ~/.config/i3/, ~/.config/dunst/, ~/.config/picom/, ~/.config/rofi/,
  ~/.config/kitty/, ~/.config/i3blocks/, ~/.local/bin/ scripts that support i3, or
  .xinitrc.i3/.xinitrc session files. Triggers: i3 keybindings, layouts, gaps, borders,
  floating rules, workspaces, focus, bar, startup, wallpaper, launcher, notifications,
  screenshots, clipboard, xrandr, and session switching. Excludes i3 source development.
---

# i3 Skill

Manage my i3/X11 desktop configuration and related dotfiles.

This skill is for end-user customization on an installed system.
It is not for contributing to i3 itself.

## Use This Skill When

- Editing any file in `~/.config/i3/`
- Editing related desktop config in `~/.config/dunst/`, `~/.config/picom/`, `~/.config/rofi/`, `~/.config/kitty/`, or `~/.config/i3blocks/`
- Editing session startup files such as `~/.xinitrc.i3` or `~/.xinitrc`
- Changing keybindings, gaps, borders, floating behavior, focus, layouts, workspaces, bar settings, wallpaper, screenshots, clipboard, launchers, or autostart
- Updating helper scripts in `~/.local/bin/` or `~/Work/dotfiles/i3/.config/i3/scripts/` that are part of the i3 workflow

## Project Shape

The dotfiles repo is stow-managed. For this setup, the i3 package is the source of truth.

Typical files and scripts:

```text
~/Work/dotfiles/i3/
├── .config/i3/config
├── .config/i3/scripts/
│   ├── launchers/
│   ├── wallpaper/
│   ├── notifications/
│   ├── media/
│   └── utils/
└── .local/bin/
```

Related skill:

- `i3-dotfiles-runtime-check` for runtime-path and daemon-state debugging

## Working Rules

- Inspect first, then edit.
- Prefer changing the dotfiles source in `~/Work/dotfiles/i3/` and restowing it, rather than editing live files in place.
- Keep changes minimal and consistent with the existing i3 workflow.
- Do not introduce Hyprland/Wayland assumptions into i3 paths or commands.
- When keybindings change, update any manual help UIs or cheatsheets that mirror them, such as `i3-keys`.

## Apply And Verify

- After config edits, validate syntax with `i3 -C -c ~/.config/i3/config`
- Reload i3 with `i3-msg reload`
- Use `i3-msg restart` only when a restart is actually needed
- After script changes, ensure the script is executable and restow the package if the repo is the source of truth

## Common Maintenance Commands

```bash
cd ~/Work/dotfiles && stow --restow i3
```

Use targeted restarts for supporting apps when their config changes:

- `pkill dunst && dunst &`
- `pkill picom && picom --daemon`
- `pkill i3blocks && i3blocks &` if the bar script is managed that way

## Practical Defaults

- `Super+Return` opens the terminal
- `Super+Space` opens the launcher
- `Print` uses the screenshot path
- `Super+Shift+r` is the main reload/restart path in this setup

If the request is about X11 desktop behavior, i3 bindings, or the surrounding dotfiles, use this skill and stay within the i3 stack.
