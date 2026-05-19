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
    COMMON_PKGS=(
        # Core
        stow feh picom dunst network-manager-applet xss-lock polkit-gnome sddm
        pipewire-pulse brightnessctl playerctl
        # Fonts
        noto-fonts noto-fonts-emoji ttf-jetbrains-mono-nerd
        # Shell/Dev
        python-pywal fzf jq libnotify
    )
    I3_PKGS=(
        # WM & bar
        i3-wm i3blocks polybar rofi
        # Terminals & apps
        kitty alacritty btop neovim tmux copyq flameshot
        # Screenshot & OCR
        maim xclip tesseract
        # Clipboard & image preview
        cliphist ueberzugpp
        # Window/display utils
        xdotool xorg-xdpyinfo dex
        # Audio/volume OSD
        yad xob
        # System info (i3blocks scripts)
        sysstat wireless_tools imagemagick
        # Image processing (i3-lock)
        bat
        # Markdown preview (peek.nvim)
        deno
    )
    DWM_PKGS=(
        base-devel imv mpv autocutsel ueberzugpp
    )
    HYPR_PKGS=(
        hyprland waybar ghostty neovim tmux fastfetch starship
    )
elif [[ "$PM" == "apt" ]]; then
    COMMON_PKGS=(stow feh picom dunst copyq network-manager-gnome policykit-1-gnome pipewire-pulse fonts-noto fonts-noto-color-emoji brightnessctl playerctl fzf jq libnotify-bin)
    I3_PKGS=(i3 i3blocks polybar rofi kitty alacritty btop neovim tmux maim xclip xdotool flameshot tesseract-ocr imagemagick x11-utils sysstat wireless-tools)
    DWM_PKGS=(build-essential imv mpv autocutsel)
    HYPR_PKGS=(neovim tmux fastfetch starship)
elif [[ "$PM" == "dnf" ]]; then
    COMMON_PKGS=(stow feh picom dunst network-manager-applet polkit-gnome pipewire-pulse jetbrains-mono-fonts noto-fonts-emoji brightnessctl playerctl fzf jq libnotify)
    I3_PKGS=(i3 i3blocks polybar rofi kitty alacritty btop neovim tmux maim xclip xdotool flameshot tesseract ImageMagick xdpyinfo sysstat)
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
        $PM_AUR -S --needed --noconfirm \
            hyprland waybar ghostty \
            i3lock-color \
            impala wiremix \
            python-pywal xob \
            voxtype-bin ydotool 2>/dev/null || true
    fi

    # voxtype: add user to input group + download small.en model
    if command -v voxtype &>/dev/null; then
        echo "  → Setting up voxtype dictation..."
        sudo usermod -aG input "$USER" 2>/dev/null && echo "  ✓ Added $USER to input group (re-login required)"
        if ! voxtype setup model --list 2>/dev/null | grep -q "small.en"; then
            echo "  → Downloading small.en Whisper model (better accuracy)..."
            voxtype setup model --set small.en 2>/dev/null || echo "  ! Could not set model — run: voxtype setup model"
        fi
        voxtype setup systemd 2>/dev/null && echo "  ✓ voxtype systemd service set up"
    fi
}

# --- Stow ---
stow_all() {
    # stow_pkg <dir> <pkg> [extra stow args]
    backup_if_plain_file() {
        local path="$1"
        if [[ -e "$path" && ! -L "$path" ]]; then
            local backup="$path.cachyos.bak"
            local i=1
            while [[ -e "$backup" ]]; do
                backup="$path.cachyos.bak.$i"
                ((i++))
            done
            mv "$path" "$backup"
            echo "  → Backed up $path to $backup"
        fi
    }

    stow_pkg() {
        local dir=$1 pkg=$2
        shift 2
        local extra=("$@")
        local ignore="--ignore=CLAUDE.md --ignore=AGENTS.md --ignore=README.md --ignore=wallpapers"
        if stow -d "$dir" -t "$HOME" --restow $ignore "${extra[@]}" "$pkg" 2>/dev/null; then
            echo "  ✓ $pkg"
        else
            local conflicts
            conflicts=$(stow -d "$dir" -t "$HOME" -n $ignore "${extra[@]}" "$pkg" 2>&1 | grep "existing target")
            if [[ -n "$conflicts" ]]; then
                echo "  ! $pkg conflicts:"
                echo "$conflicts" | sed 's/.*existing target is not owned by stow: //' | sed 's/^/      - /'
            else
                echo "  ✗ $pkg (unknown error)"
            fi
        fi
    }

    echo "Stowing dotfiles to $HOME..."
    backup_if_plain_file "$HOME/.zshrc"
    backup_if_plain_file "$HOME/.bashrc"

    # i3 main package — exclude sub-packages and non-stow dirs
    stow_pkg "$DOTFILES" i3 --ignore='^shell$' --ignore='^sddm-theme$' --ignore='^default$'
    # shell sub-package lives inside i3/
    stow_pkg "$DOTFILES/i3" shell
    stow_pkg "$DOTFILES" hyprland --ignore='^\.bashrc$'
    stow_pkg "$DOTFILES" dwm \
        --ignore='dunstrc$' \
        --ignore='flameshot\.ini$' \
        --ignore='picom\.conf$' \
        --ignore='colors-rofi-dwm\.rasi$' \
        --ignore='fzfub$' \
        --ignore='notes$' \
        --ignore='qutebrowser' \
        --ignore='quickmarks$' \
        --ignore='urls$' \
        --ignore='brightnessnotify$' \
        --ignore='dwm-block-.*$'

    if [[ ! -f "$HOME/.xinitrc" ]]; then
        ln -sf "Work/dotfiles/i3/.xinitrc.i3" "$HOME/.xinitrc"
        echo "  → Created ~/.xinitrc symlink (i3) — use 'xsession dwm' to switch"
    fi

    echo "Wallpapers are at $DOTFILES/wallpapers/"

    # SDDM login screen setup
    login_setup
}

# --- Stow check ---
check_stow() {
    local ignore="--ignore=CLAUDE.md --ignore=AGENTS.md --ignore=README.md --ignore=wallpapers"
    local failed=0

    check_pkg() {
        local dir=$1 pkg=$2
        shift 2
        local extra=("$@")
        local out conflicts

        out=$(stow -d "$dir" -t "$HOME" -n -v $ignore "${extra[@]}" "$pkg" 2>&1 || true)
        conflicts=$(echo "$out" | grep -E "existing target|cannot stow|source is an absolute symlink" || true)
        if [[ -n "$conflicts" ]]; then
            echo "  ! $pkg conflicts:"
            echo "$conflicts" | sed 's/^/      /'
            failed=1
        else
            echo "  ✓ $pkg"
        fi
    }

    echo "Checking stow targets for $HOME..."
    check_pkg "$DOTFILES" i3 --ignore='^shell$' --ignore='^sddm-theme$' --ignore='^default$'
    check_pkg "$DOTFILES/i3" shell
    check_pkg "$DOTFILES" hyprland --ignore='^\.bashrc$'
    check_pkg "$DOTFILES" dwm \
        --ignore='dunstrc$' \
        --ignore='flameshot\.ini$' \
        --ignore='picom\.conf$' \
        --ignore='colors-rofi-dwm\.rasi$' \
        --ignore='fzfub$' \
        --ignore='notes$' \
        --ignore='qutebrowser' \
        --ignore='quickmarks$' \
        --ignore='urls$' \
        --ignore='brightnessnotify$' \
        --ignore='dwm-block-.*$'

    echo ""
    echo "Checking key links..."
    for target in \
        "$HOME/.config/i3/config" \
        "$HOME/.config/i3blocks/config" \
        "$HOME/.local/bin/i3-gdrive" \
        "$HOME/.zshrc"; do
        if [[ -e "$target" && "$(readlink -f "$target")" == "$DOTFILES"* ]]; then
            echo "  ✓ $target"
        else
            echo "  ! $target is not linked to $DOTFILES"
            failed=1
        fi
    done

    if [[ $failed -eq 0 ]]; then
        echo "All stow checks passed."
    else
        echo "Stow check found issues."
        return 1
    fi
}

# --- Login (SDDM + PAM) ---
login_setup() {
    echo "Setting up SDDM login screen..."

    if [[ -d "$DOTFILES/i3/sddm-theme/i3-login" ]]; then
        sudo mkdir -p /usr/share/sddm/themes
        sudo rm -rf /usr/share/sddm/themes/i3-login
        sudo ln -sf "$DOTFILES/i3/sddm-theme/i3-login" /usr/share/sddm/themes/i3-login
        echo "  ✓ SDDM theme linked"
    else
        echo "  ! SDDM theme not found at $DOTFILES/i3/sddm-theme/i3-login"
    fi

    # No autologin — login screen shown for security
    sudo mkdir -p /etc/sddm.conf.d
    printf '[Theme]\nCurrent=i3-login\n\n[X11]\nXkbLayout=fr\nXkbModel=pc105\nXkbOptions=terminate:ctrl_alt_bksp\n' \
        | sudo tee /etc/sddm.conf.d/autologin.conf > /dev/null
    echo "  ✓ SDDM config (login screen, no autologin)"

    # Remove Wayland override — it conflicts with the X11 i3 session
    if [[ -f /etc/sddm.conf.d/10-wayland.conf ]]; then
        sudo rm -f /etc/sddm.conf.d/10-wayland.conf
        echo "  ✓ Removed SDDM Wayland override (10-wayland.conf)"
    fi

    # Strip pam_gnome_keyring — causes auth delay on i3 login
    if grep -q 'pam_gnome_keyring' /etc/pam.d/sddm 2>/dev/null; then
        sudo sed -i \
            '/-auth.*pam_gnome_keyring\.so/d; /-password.*pam_gnome_keyring\.so/d' \
            /etc/pam.d/sddm
        echo "  ✓ Stripped pam_gnome_keyring from /etc/pam.d/sddm"
    fi
}

# --- Limine ---
limine_plymouth() {
    local theme="0xSSfN"
    if [[ -d "$DOTFILES/limine/plymouth" ]]; then
        sudo mkdir -p /usr/share/plymouth/themes/$theme
        sudo cp -a "$DOTFILES/limine/plymouth/." /usr/share/plymouth/themes/$theme/
        sudo plymouth-set-default-theme $theme
        echo "  ✓ Plymouth theme ($theme)"
    else
        echo "  ! limine/plymouth/ not found — skipping Plymouth setup"
    fi
}

limine_install() {
    echo "Installing Limine config..."

    if [[ ! -f /boot/limine.conf ]]; then
        sudo cp "$DOTFILES/limine/limine.conf" /boot/limine.conf
        echo "  ✓ /boot/limine.conf"
    else
        echo "  ~ /boot/limine.conf already exists, skipping (run with 'limine --force' to overwrite)"
    fi

    if [[ ! -f /etc/default/limine ]]; then
        sudo cp "$DOTFILES/limine/default-limine" /etc/default/limine
        echo "  ✓ /etc/default/limine"
    else
        echo "  ~ /etc/default/limine already exists, skipping"
    fi

    sudo mkdir -p /etc/mkinitcpio.conf.d
    if [[ ! -f /etc/mkinitcpio.conf.d/omarchy_hooks.conf ]]; then
        sudo cp "$DOTFILES/limine/omarchy_hooks.conf" /etc/mkinitcpio.conf.d/omarchy_hooks.conf
        echo "  ✓ /etc/mkinitcpio.conf.d/omarchy_hooks.conf"
    else
        echo "  ~ omarchy_hooks.conf already exists, skipping"
    fi

    if [[ -f "$DOTFILES/limine/backdrop.png" ]]; then
        sudo cp "$DOTFILES/limine/backdrop.png" /boot/backdrop.png
        echo "  ✓ /boot/backdrop.png"
    fi

    limine_plymouth
    sudo limine-update
    sudo limine-snapper-sync
    echo "  → Rebuilding UKI (limine-mkinitcpio)..."
    sudo limine-mkinitcpio
    echo "  ✓ UKI rebuilt with Plymouth hook"
}

limine_force() {
    echo "Force-installing Limine config..."
    sudo cp "$DOTFILES/limine/limine.conf" /boot/limine.conf && echo "  ✓ /boot/limine.conf"
    sudo cp "$DOTFILES/limine/default-limine" /etc/default/limine && echo "  ✓ /etc/default/limine"
    sudo mkdir -p /etc/mkinitcpio.conf.d
    sudo cp "$DOTFILES/limine/omarchy_hooks.conf" /etc/mkinitcpio.conf.d/omarchy_hooks.conf && echo "  ✓ /etc/mkinitcpio.conf.d/omarchy_hooks.conf"
    if [[ -f "$DOTFILES/limine/backdrop.png" ]]; then
        sudo cp "$DOTFILES/limine/backdrop.png" /boot/backdrop.png && echo "  ✓ /boot/backdrop.png"
    fi
    limine_plymouth
    sudo limine-update
    sudo limine-snapper-sync
    echo "  → Rebuilding UKI (limine-mkinitcpio)..."
    sudo limine-mkinitcpio
    echo "  ✓ UKI rebuilt with Plymouth hook"
}

# --- CLI ---
case "${1:-stow}" in
    packages|install)
        install_all
        ;;
    stow)
        stow_all
        ;;
    check)
        check_stow
        ;;
    login)
        login_setup
        ;;
    all)
        install_all
        echo ""
        stow_all
        echo ""
        limine_install
        ;;
    limine)
        limine_install
        ;;
    limine\ --force|limine-force)
        limine_force
        ;;
    *)
        echo "Usage: $0 [all|packages|stow|check|login|limine]"
        echo "  all      — install packages + stow dotfiles + limine"
        echo "  packages — install required packages"
        echo "  stow     — stow dotfiles + SDDM login setup (default)"
        echo "  check    — dry-run stow and verify key symlinks"
        echo "  login    — configure SDDM login screen, fix PAM (standalone)"
        echo "  limine   — install Limine + Plymouth + rebuild UKI (skips if exists)"
        echo "  limine --force  — force-overwrite all Limine/Plymouth config"
        exit 1
        ;;
esac
