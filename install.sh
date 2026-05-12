#!/bin/bash

set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

if [[ ! -d "$DOTFILES/hyprland" || ! -d "$DOTFILES/i3" || ! -d "$DOTFILES/dwm" ]]; then
    echo "Error: Run this script from the root of the dotfiles repository."
    exit 1
fi

IGNORE="--ignore=wallpapers --ignore=.xinitrc --ignore=CLAUDE.md"

stow_ok() {
    local pkg=$1
    if stow -t "$HOME" --restow $IGNORE "$pkg" 2>/dev/null; then
        echo "  ✓ $pkg"
    else
        local conflicts
        conflicts=$(stow -t "$HOME" -n $IGNORE "$pkg" 2>&1 | grep "existing target")
        if [[ -n "$conflicts" ]]; then
            echo "  ! $pkg conflicts:"
            echo "$conflicts" | sed 's/.*existing target is not owned by stow: //' | sed 's/^/      - /'
        else
            echo "  ✗ $pkg (unknown error)"
        fi
    fi
}

echo "Stowing dotfiles to $HOME..."
stow_ok "hyprland"
stow_ok "i3"
stow_ok "dwm"

if [[ ! -f "$HOME/.xinitrc" ]]; then
    echo "# No .xinitrc found. Creating default (i3). Change 'exec i3' to 'exec dwm' if needed." > "$HOME/.xinitrc"
    echo "exec i3" >> "$HOME/.xinitrc"
    echo "  → Created ~/.xinitrc (i3)"
fi

echo "Done. Wallpapers are at $DOTFILES/wallpapers/ (not stowed)."
