# Repository Guidelines

## Project Structure & Module Organization
This repo manages Arch Linux dotfiles using GNU Stow. Main modules are:
- `i3/`: primary X11 setup (`.config/i3`, `.config/i3blocks`, `.local/bin`, `sddm-theme/`)
- `hyprland/`: Wayland setup plus `wal/` generated color assets
- `dwm/`: suckless stack (`dwm`, `dmenu`, `st`, `dwmblocks`) and helper scripts
- `ai-agent/`: shared agent/tooling configuration
- `shell/`, `tmux/`: shared shell and terminal multiplexer config
- `wallpapers/`: image assets (not stowed)

Use root `README.md` for cross-WM docs; use per-module READMEs for implementation details.

## Build, Test, and Development Commands
- `./install.sh`: full setup (packages, stow, symlinks where applicable)
- `./install.sh stow`: re-apply symlinks without full bootstrap
- `stow -t $HOME i3` (or `dwm`, `hyprland`, `ai-agent`): apply one package
- `i3 -C -c ~/.config/i3/config`: validate i3 config syntax before reload
- `i3-msg reload` / `i3-msg restart`: apply i3 changes safely
- `make -C dwm/dwm` (or `dwm/dmenu`, `dwm/st`, `dwm/dwmblocks`): build suckless components

## Coding Style & Naming Conventions
- Shell scripts: Bash/POSIX, lowercase kebab-case names (`i3-screenrecord`, `wallpaper-set.sh`)
- Keep scripts small and single-purpose; group by function under module directories
- Preserve executable bits for runnable scripts (`chmod +x <file>`)
- Follow existing config style in each WM; avoid reformat-only churn

## Testing Guidelines
No centralized test framework exists. Validate changes with:
- Syntax checks (`bash -n path/to/script.sh`)
- WM-specific validation (e.g., `i3 -C ...`)
- Runtime verification in session (keybindings, bars, launchers, theme sync)

For `wal/` or theme work, confirm generated files load correctly in affected apps.

## Commit & Pull Request Guidelines
Recent history uses Conventional Commit prefixes (`feat:`, `fix:`, `refactor:`, `style:`, `docs:`), sometimes with scope (e.g., `fix(i3blocks): ...`). Keep commits focused and imperative.

PRs should include:
- Clear summary of behavior change
- Affected module(s) and paths
- Manual verification steps run
- Screenshots/gifs for visual changes (bar/theme/launcher/UI)

## Security & Configuration Tips
Do not commit secrets, host-specific tokens, or private machine identifiers. Keep local overrides in non-tracked files when needed, and prefer parameterized scripts over hardcoded personal paths.
