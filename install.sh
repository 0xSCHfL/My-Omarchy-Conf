#!/bin/bash

set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

if [[ ! -d "$DOTFILES/hyprland" || ! -d "$DOTFILES/i3" || ! -d "$DOTFILES/dwm" ]]; then
    echo "Error: Run this script from the root of the dotfiles repository."
    exit 1
fi

# --- Package manager detection ---
PM=""
PM_INSTALL=""
PM_UPDATE=""

if command -v pacman &>/dev/null; then
    PM="pacman"
    PM_INSTALL="sudo pacman -S --needed --noconfirm"
    PM_UPDATE="sudo pacman -Sy"
    for cmd in yay paru; do
        if command -v $cmd &>/dev/null; then
            PM_AUR=$cmd
            break
        fi
    done
elif command -v apt &>/dev/null; then
    PM="apt"
    PM_INSTALL="sudo apt install -y"
    PM_UPDATE="sudo apt update"
elif command -v dnf &>/dev/null; then
    PM="dnf"
    PM_INSTALL="sudo dnf install -y"
    PM_UPDATE="sudo dnf check-update || true"
elif command -v zypper &>/dev/null; then
    PM="zypper"
    PM_INSTALL="sudo zypper install -y"
    PM_UPDATE="sudo zypper refresh"
elif command -v xbps-install &>/dev/null; then
    PM="xbps"
    PM_INSTALL="sudo xbps-install -y"
    PM_UPDATE="sudo xbps-install -Su"
elif command -v apk &>/dev/null; then
    PM="apk"
    PM_INSTALL="sudo apk add"
    PM_UPDATE="sudo apk update"
else
    echo "No supported package manager found. Skipping package installation."
    PM=""
fi

# --- Package lists by distro ---
if [[ "$PM" == "pacman" ]]; then
    COMMON_PKGS=(stow feh picom dunst flameshot copyq network-manager-applet xss-lock polkit-gnome pipewire-pulse ttf-nerd-fonts-symbols noto-fonts noto-fonts-emoji brightnessctl playerctl pulsemixer autocutsel wmctrl)
    I3_PKGS=(i3-wm polybar rofi kitty i3status i3blocks i3lock nsxiv btop pulseaudio-utils)
    DWM_PKGS=(base-devel imv mpv ueberzugpp python-pywal clipnotify)
    HYPR_PKGS=(hyprland waybar ghostty neovim tmux fastfetch starship python-pywal)
elif [[ "$PM" == "apt" ]]; then
    COMMON_PKGS=(stow feh picom dunst flameshot copyq network-manager-gnome policykit-1-gnome pipewire-pulse fonts-noto fonts-noto-color-emoji brightnessctl playerctl)
    I3_PKGS=(i3-wm polybar rofi kitty i3status i3lock btop pulseaudio-utils)
    DWM_PKGS=(build-essential imv mpv)
    HYPR_PKGS=(neovim tmux fastfetch starship)
elif [[ "$PM" == "dnf" ]]; then
    COMMON_PKGS=(stow feh picom dunst flameshot copyq network-manager-applet polkit-gnome pipewire-pulse jetbrains-mono-fonts fira-code-fonts noto-fonts-emoji brightnessctl playerctl)
    I3_PKGS=(i3 polybar rofi kitty i3status i3lock btop pulseaudio-utils)
    DWM_PKGS=(make gcc imv mpv libX11-devel libXft-devel libXinerama-devel)
    HYPR_PKGS=(neovim tmux fastfetch starship)
else
    COMMON_PKGS=()
    I3_PKGS=()
    DWM_PKGS=()
    HYPR_PKGS=()
fi

install_pkgs() {
    local label=$1
    shift
    local pkgs=("$@")
    [[ ${#pkgs[@]} -eq 0 ]] && return
    echo "  → $label"
    $PM_UPDATE 2>/dev/null || true
    $PM_INSTALL "${pkgs[@]}" 2>/dev/null || echo "  (some packages may not be available on this distro)"
}

install_all() {
    echo "Installing packages..."
    install_pkgs "common" "${COMMON_PKGS[@]}"
    install_pkgs "i3" "${I3_PKGS[@]}"
    install_pkgs "hyprland" "${HYPR_PKGS[@]}"
    install_pkgs "dwm" "${DWM_PKGS[@]}"

    if [[ -n "$PM_AUR" ]]; then
        echo "  → AUR packages..."
        $PM_AUR -S --needed --noconfirm hyprland waybar ghostty python-pywal 2>/dev/null || true
    fi
}

# --- Stow ---
stow_all() {
    IGNORE="--ignore=wallpapers --ignore=CLAUDE.md"

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
    stow_ok "shell"
    stow_ok "hyprland"
    stow_ok "i3"
    stow_ok "dwm"

    if [[ ! -f "$HOME/.xinitrc" ]]; then
        ln -sf "Work/dotfiles/i3/.xinitrc.i3" "$HOME/.xinitrc"
        echo "  → Created ~/.xinitrc symlink (i3) — use 'xsession dwm' to switch"
    fi

    echo "Wallpapers are at $DOTFILES/wallpapers/"
}

# --- CLI ---
case "${1:-stow}" in
    packages|install)
        install_all
        ;;
    stow)
        stow_all
        ;;
    all)
        install_all
        echo ""
        stow_all
        ;;
    *)
        echo "Usage: $0 [all|packages|stow]"
        echo "  all      — install packages + stow dotfiles"
        echo "  packages — install required packages"
        echo "  stow     — stow dotfiles only (default)"
        exit 1
        ;;
esac
