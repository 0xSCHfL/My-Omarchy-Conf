# Rofi Menus Manual

Local themes: `~/.config/rofi`

## Main Menus

| Menu | Theme |
|------|-------|
| App launcher | `i3-launcher.rasi` |
| System menu | `i3-system.rasi` |
| Keybinding help | `i3-help.rasi` |
| Battery CPU menu | `battery-cpufreq.rasi` |
| Notes | `i3-notes.rasi` |
| Local manuals | `i3-manuals.rasi` |

## Font

New i3 rofi themes use:

```text
Iosevka Nerd Font
```

This keeps the menus consistent and still renders Nerd Font icons.

## Validate A Theme

```bash
rofi -no-config -theme ~/.config/rofi/i3-manuals.rasi -dump-theme >/tmp/theme.dump
```

## Design Rule

Do not force every menu into one size. Big menus like app launchers can be wide. Small menus like system and manuals should have dedicated compact themes.
