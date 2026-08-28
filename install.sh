#!/bin/bash

set -e

GRN='\033[0;32m'
RED='\033[0;31m'
YLW='\033[1;33m'
CYN='\033[0;36m'
RST='\033[0m'

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

if [[ ! -d "$DOTFILES/i3" ]]; then
    echo "Error: i3 module directory not found at $DOTFILES/i3"
    exit 1
fi

if [[ ! -d "$DOTFILES/dwm" ]]; then
    echo "Error: dwm module directory not found at $DOTFILES/dwm"
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
        # SDDM greeter Qt5 deps (missing these = black screen on login)
        qt5-base qt5-declarative qt5-svg
        pipewire-pulse brightnessctl playerctl
        # Fonts
        noto-fonts noto-fonts-emoji ttf-jetbrains-mono-nerd
        ttc-iosevka
        # Shell/Dev
        python-pywal fzf jq libnotify
        # Shell tools (used in .zshrc / aliases)
        zoxide starship fastfetch
        # Idle detection, screensaver, touchpad gestures
        xidlehook python-terminaltexteffects touchegg
        # File manager, trash & removable-drive automount
        yazi trash-cli udiskie
        # Disk usage & search
        ncdu ripgrep fd
    )
    I3_PKGS=(
        # WM & bar
        i3-wm i3blocks polybar rofi
        # X11 / VM display support
        xorg-server xorg-xinit xf86-video-qxl spice-vdagent qemu-guest-agent
        # Terminals & apps
        kitty alacritty btop neovim tmux
        # Screenshot & OCR
        maim xclip tesseract
        # Clipboard & image preview
        cliphist ueberzugpp
        # Window/display utils
        xdotool xorg-xdpyinfo dex
        # System info (i3blocks scripts)
        sysstat wireless_tools imagemagick
        # Pager / syntax highlight
        bat
        # Markdown preview (peek.nvim + local terminal preview)
        deno glow
    )
    DWM_PKGS=(
        base-devel imv mpv autocutsel ueberzugpp
    )
elif [[ "$PM" == "apt" ]]; then
    COMMON_PKGS=(stow feh picom dunst copyq network-manager-gnome policykit-1-gnome pipewire-pulse fonts-noto fonts-noto-color-emoji brightnessctl playerctl fzf jq libnotify-bin)
    I3_PKGS=(i3 i3blocks polybar rofi kitty alacritty btop neovim tmux maim xclip xdotool flameshot tesseract-ocr imagemagick x11-utils sysstat wireless-tools)
    DWM_PKGS=(build-essential imv mpv autocutsel)
elif [[ "$PM" == "dnf" ]]; then
    COMMON_PKGS=(stow feh picom dunst network-manager-applet polkit-gnome pipewire-pulse jetbrains-mono-fonts noto-fonts-emoji brightnessctl playerctl fzf jq libnotify)
    I3_PKGS=(i3 i3blocks polybar rofi kitty alacritty btop neovim tmux maim xclip xdotool flameshot tesseract ImageMagick xdpyinfo sysstat)
    DWM_PKGS=(make gcc imv mpv libX11-devel libXft-devel libXinerama-devel)
else
    COMMON_PKGS=()
    I3_PKGS=()
    DWM_PKGS=()
fi

install_pkgs() {
    local label=$1
    shift
    local pkgs=("$@")
    [[ ${#pkgs[@]} -eq 0 ]] && return
    echo "  → $label"
    $PM_UPDATE 2>/dev/null || true
    $PM_INSTALL "${pkgs[@]}" || echo "  (some packages may not be available on this distro)"
}

setup_voxtype() {
    # voxtype: add user to input group + download small.en model
    if command -v voxtype &>/dev/null; then
        echo "  → Setting up voxtype dictation..."
        sudo usermod -aG input "$USER" 2>/dev/null && echo "  ✓ Added $USER to input group (re-login required)"
        if ! voxtype setup model --list 2>/dev/null | grep -q "small.en"; then
            echo "  → Downloading small.en Whisper model (better accuracy)..."
            voxtype setup model --set small.en 2>/dev/null || echo "  ! Could not set model — run: voxtype setup model"
        fi
        # GTK4 layer-shell cannot place an OSD on X11/i3. The source package
        # provides the native frontend, so configure it without overwriting
        # an existing user-defined OSD section.
        local local_voxtype_config="$HOME/.config/voxtype/config.toml"
        if [[ -x /usr/lib/voxtype/voxtype-osd-native && -f "$local_voxtype_config" ]] \
            && ! grep -q '^\[osd\]' "$local_voxtype_config"; then
            cat >> "$local_voxtype_config" <<'EOF'

[osd]
frontend = "native"
position = "bottom-center"
margin_px = 24
EOF
            echo "  ✓ Voxtype OSD configured for bottom-center"
        fi
        voxtype setup systemd 2>/dev/null && echo "  ✓ voxtype systemd service set up"
    fi
}

install_all() {
    echo "Installing packages..."
    install_pkgs "common" "${COMMON_PKGS[@]}"
    install_pkgs "i3" "${I3_PKGS[@]}"
    install_pkgs "dwm" "${DWM_PKGS[@]}"

    if [[ -n "$PM_AUR" ]]; then
        echo "  → AUR packages..."
        # Use the source package: voxtype-bin ships GTK4 only, while i3/X11
        # needs the native OSD frontend for a reliable bottom-center overlay.
        if [[ "$PM" == "pacman" ]] && pacman -Qq voxtype-bin &>/dev/null; then
            echo "  → Replacing voxtype-bin with voxtype (native OSD support)..."
            sudo pacman -R --noconfirm voxtype-bin
        fi
        $PM_AUR -S --needed --noconfirm \
            impala wiremix auto-cpufreq \
            python-pywal xob \
            ttf-iosevka-nerd \
            voxtype ydotool || true
    fi

    setup_voxtype

    if command -v touchegg &>/dev/null && command -v systemctl &>/dev/null; then
        echo "  → Setting up touchpad gestures..."
        sudo systemctl enable --now touchegg.service 2>/dev/null \
            && echo "  ✓ Touchégg service enabled"
    fi
}

# --- Unstow ---
unstow_pkg() {
    local dir=$1 pkg=$2
    shift 2
    local extra=("$@")
    local ignore="--ignore=CLAUDE.md --ignore=AGENTS.md --ignore=README.md --ignore=wallpapers"
    if stow -d "$dir" -t "$HOME" -D $ignore "${extra[@]}" "$pkg" 2>/dev/null; then
        echo "  ✓ unstowed $pkg"
    else
        echo "  ! $pkg — nothing to unstow or already clean"
    fi
}

unstow() {
    case "${1:-}" in
        i3)
            unstow_pkg "$DOTFILES" i3 --ignore='^shell$' --ignore='^sddm-theme$' --ignore='^default$'
            unstow_pkg "$DOTFILES/i3" shell
            ;;
        dwm)
            unstow_pkg "$DOTFILES" dwm \
                --ignore='dunstrc$' --ignore='flameshot\.ini$' --ignore='picom\.conf$' \
                --ignore='colors-rofi-dwm\.rasi$' --ignore='fzfub$' --ignore='notes$' \
                --ignore='qutebrowser' --ignore='quickmarks$' --ignore='urls$' \
                --ignore='brightnessnotify$' --ignore='dwm-block-.*$'
            ;;
        tmux)
            unstow_pkg "$DOTFILES" tmux
            ;;
        ai-agent)
            unstow_pkg "$DOTFILES/ai-agent" hermes
            ;;
        all)
            unstow i3
            unstow tmux
            unstow dwm
            unstow ai-agent
            ;;
        *) echo "Usage: $0 unstow [i3|tmux|dwm|ai-agent|all]"; exit 1 ;;
    esac
}

# --- Stow helpers ---
_backup_if_plain_file() {
    local path="$1"
    if [[ -e "$path" && ! -L "$path" ]]; then
        local backup="$path.cachyos.bak"
        local i=1
        while [[ -e "$backup" ]]; do backup="$path.cachyos.bak.$i"; ((i++)); done
        mv "$path" "$backup"
        echo "  → Backed up $path to $backup"
    fi
}

_stow_pkg() {
    local dir=$1 pkg=$2
    shift 2
    local extra=("$@")
    local ignore="--ignore=CLAUDE.md --ignore=AGENTS.md --ignore=README.md --ignore=wallpapers"
    if stow -d "$dir" -t "$HOME" --restow $ignore "${extra[@]}" "$pkg" 2>/dev/null; then
        echo "  ✓ $pkg"
    else
        local conflicts
        conflicts=$(stow -d "$dir" -t "$HOME" -n $ignore "${extra[@]}" "$pkg" 2>&1 | grep "existing target" || true)
        if [[ -n "$conflicts" ]]; then
            echo "  ! $pkg conflicts:"
            echo "$conflicts" | sed 's/.*existing target is not owned by stow: //' | sed 's/^/      - /'
        else
            echo "  ✗ $pkg (unknown error)"
        fi
    fi
}

# --- Stow per-package ---
stow_i3() {
    echo "Stowing i3 to $HOME..."
    # Back up plain files that conflict with stow symlinks
    _backup_if_plain_file "$HOME/.zshrc"
    _backup_if_plain_file "$HOME/.local/bin/wiki"
    _backup_if_plain_file "$HOME/.config/dunst/dunstrc"
    _backup_if_plain_file "$HOME/.config/picom/picom.conf"
    _backup_if_plain_file "$HOME/.config/alacritty/alacritty.toml"
    _stow_pkg "$DOTFILES" i3 --ignore='^shell$' --ignore='^sddm-theme$' --ignore='^default$'
    _stow_pkg "$DOTFILES/i3" shell

    # Deploy smartctl-safe to /usr/local/bin for sudo access
    if [[ -f "$DOTFILES/i3/.local/bin/smartctl-safe" ]]; then
        sudo cp "$DOTFILES/i3/.local/bin/smartctl-safe" /usr/local/bin/smartctl-safe
        echo "  ✓ smartctl-safe deployed to /usr/local/bin"
    fi

    if [[ ! -f "$HOME/.xinitrc" ]]; then
        ln -sf "Work/dotfiles/i3/.xinitrc.i3" "$HOME/.xinitrc"
        echo "  → Created ~/.xinitrc symlink (i3)"
    fi

    # Set zsh as default shell if not already
    if [[ "$(getent passwd "$USER" | cut -d: -f7)" != */zsh ]]; then
        if command -v zsh &>/dev/null; then
            chsh -s "$(command -v zsh)"
            echo "  ✓ Default shell set to zsh (re-login required)"
        else
            echo "  ! zsh not found — install it first"
        fi
    else
        echo "  ~ Default shell already zsh"
    fi

    login_setup
}

stow_dwm() {
    echo "Stowing dwm to $HOME..."
    _backup_if_plain_file "$HOME/.bashrc"
    _stow_pkg "$DOTFILES" dwm \
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
}

stow_tmux() {
    echo "Stowing tmux to $HOME..."
    _stow_pkg "$DOTFILES" tmux
}

stow_ai_agent() {
    echo "Stowing ai-agent to $HOME..."
    _backup_if_plain_file "$HOME/.hermes/config.yaml"
    _backup_if_plain_file "$HOME/.hermes/.env"
    _backup_if_plain_file "$HOME/.hermes/auth.json"
    _backup_if_plain_file "$HOME/.hermes/active_profile"
    _backup_if_plain_file "$HOME/.hermes/profiles/work-default/config.yaml"
    _backup_if_plain_file "$HOME/.hermes/profiles/work-default/profile.yaml"
    _backup_if_plain_file "$HOME/.hermes/profiles/work-default/.env"
    _stow_pkg "$DOTFILES/ai-agent" hermes
}

stow_all() {
    stow_i3
    stow_tmux
    stow_dwm
    stow_ai_agent
    echo "Wallpapers are at $DOTFILES/wallpapers/"
}

# --- Checks ---
ok()   { echo -e "  ${GRN}✓${RST} $1"; }
fail() { echo -e "  ${RED}✗${RST} $1"; }
warn() { echo -e "  ${YLW}!${RST} $1"; }
header() { echo -e "\n${CYN}══ $1 ══${RST}"; }

detect_wm() {
    if [[ -n "$I3_PID" ]] || pgrep -x i3 >/dev/null 2>&1; then
        echo "i3"
    elif [[ -n "$DWMDESKTOP" ]] || pgrep -x dwm >/dev/null 2>&1; then
        echo "dwm"
    elif [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]] || pgrep -x Hyprland >/dev/null 2>&1; then
        echo "hyprland"
    else
        echo "none"
    fi
}

check_packages() {
    local wm=$1
    local missing=()
    local optional=(xf86-video-qxl spice-vdagent qemu-guest-agent)

    case "$wm" in
        i3) pkgs=("${I3_PKGS[@]}") ;;
        dwm) pkgs=("${DWM_PKGS[@]}") ;;
        *)  pkgs=("${I3_PKGS[@]}" "${DWM_PKGS[@]}") ;;
    esac

    for pkg in "${pkgs[@]}"; do
        if ! pacman -Qi "$pkg" &>/dev/null; then
            missing+=("$pkg")
        fi
    done

    local required=()
    for pkg in "${missing[@]}"; do
        if ! [[ " ${optional[*]} " == *" $pkg "* ]]; then
            required+=("$pkg")
        fi
    done

    if [[ ${#required[@]} -eq 0 ]]; then
        ok "All $wm packages installed"
        [[ ${#missing[@]} -gt 0 ]] && warn "Optional: ${missing[*]}" || true
    else
        warn "Missing: ${required[*]}"
        return 1
    fi
}

check_services() {
    local services=(
        NetworkManager.service
        polkit.service
        pipewire.service
        pipewire-pulse.service
        wireplumber.service
    )
    local failed=0

    for svc in "${services[@]}"; do
        if systemctl is-active --quiet "$svc" 2>/dev/null; then
            ok "$svc"
        elif systemctl --user is-active --quiet "$svc" 2>/dev/null; then
            ok "$svc (user)"
        else
            fail "$svc not running"
            failed=1
        fi
    done

    return $failed
}

check_runtime() {
    local wm=$1
    case "$wm" in
        i3)
            if command -v i3 &>/dev/null && i3 -C -c ~/.config/i3/config &>/dev/null; then
                ok "i3 config syntax valid"
            else
                fail "i3 config has errors"
                return 1
            fi
            ;;
        dwm)
            if pgrep -x dwm >/dev/null 2>&1; then
                ok "dwm running"
            else
                fail "dwm not running"
                return 1
            fi
            ;;
    esac
}

check_stow() {
    local wm
    wm=$(detect_wm)
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
            warn "$pkg conflicts:"
            echo "$conflicts" | sed 's/^/      /'
            failed=1
        else
            ok "$pkg"
        fi
    }

    echo -e "${CYN}Current WM: ${wm}${RST}"

    header "Packages"
    check_packages "$wm" || failed=1

    header "Services"
    check_services || failed=1

    header "Runtime"
    check_runtime "$wm" || failed=1

    header "Stow targets ($HOME)"
    check_pkg "$DOTFILES" i3 --ignore='^shell$' --ignore='^sddm-theme$' --ignore='^default$'
    check_pkg "$DOTFILES/i3" shell
    check_pkg "$DOTFILES/ai-agent" hermes

    if [[ "$wm" != "i3" ]]; then
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
    fi

    header "Key symlinks"
    for target in \
        "$HOME/.config/i3/config" \
        "$HOME/.config/i3blocks/config" \
        "$HOME/.local/bin/i3-gdrive" \
        "$HOME/.local/bin/wiki" \
        "$HOME/.hermes/config.yaml" \
        "$HOME/.hermes/profiles/work-default/config.yaml" \
        "$HOME/.zshrc"; do
        if [[ -e "$target" && "$(readlink -f "$target")" == "$DOTFILES"* ]]; then
            ok "$target"
        else
            fail "$target not linked to dotfiles"
            failed=1
        fi
    done

    if [[ $failed -eq 0 ]]; then
        echo -e "\n${GRN}All checks passed.${RST}"
    else
        echo -e "\n${RED}Some checks failed.${RST}"
        return 1
    fi
}

# --- Login (SDDM + PAM) ---
login_setup() {
    echo "Setting up SDDM login screen..."

    if [[ -d "$DOTFILES/i3/sddm-theme/i3-login" ]]; then
        sudo mkdir -p /usr/share/sddm/themes
        sudo rm -rf /usr/share/sddm/themes/i3-login
        sudo cp -a "$DOTFILES/i3/sddm-theme/i3-login" /usr/share/sddm/themes/i3-login
        echo "  ✓ SDDM theme copied"
    else
        echo "  ! SDDM theme not found at $DOTFILES/i3/sddm-theme/i3-login"
    fi

    # No autologin — login screen shown for security; default to i3
    sudo mkdir -p /etc/sddm.conf.d
    printf '[General]\nDefaultSession=i3.desktop\nRememberLastSession=false\nRememberLastUser=true\n\n[Theme]\nCurrent=i3-login\n\n[X11]\nXkbLayout=fr\nXkbModel=pc105\nXkbOptions=terminate:ctrl_alt_bksp\n' \
        | sudo tee /etc/sddm.conf.d/autologin.conf > /dev/null
    echo "  ✓ SDDM config (i3 default session, no autologin)"

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

    if command -v systemctl &>/dev/null; then
        sudo systemctl enable sddm.service
        echo "  ✓ SDDM service enabled"
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

limine_generate_default() {
    local tmp status
    [[ -x "$DOTFILES/limine/generate-default-limine" ]] \
        || { echo "Missing executable: $DOTFILES/limine/generate-default-limine" >&2; return 1; }

    tmp="$(mktemp)"
    if "$DOTFILES/limine/generate-default-limine" > "$tmp"; then
        sudo cp "$tmp" /etc/default/limine
        status=$?
    else
        status=$?
    fi
    rm -f "$tmp"
    return "$status"
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
        limine_generate_default
        echo "  ✓ /etc/default/limine (auto-detected root profile)"
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
    limine_generate_default && echo "  ✓ /etc/default/limine (auto-detected root profile)"
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
        case "${2:-all}" in
            i3)
                install_pkgs "i3" "${I3_PKGS[@]}"
                if [[ -n "$PM_AUR" ]]; then
                    echo "  → AUR packages..."
                    if [[ "$PM" == "pacman" ]] && pacman -Qq voxtype-bin &>/dev/null; then
                        echo "  → Replacing voxtype-bin with voxtype (native OSD support)..."
                        sudo pacman -R --noconfirm voxtype-bin
                    fi
                    $PM_AUR -S --needed --noconfirm \
                        ttf-iosevka-nerd \
                        xob voxtype ydotool || true
                fi
                setup_voxtype
                ;;
            all|"") install_all ;;
            *) echo "Usage: $0 packages [i3|all]"; exit 1 ;;
        esac
        ;;
    stow)
        case "${2:-all}" in
            i3)        stow_i3 ;;
            tmux)      stow_tmux ;;
            dwm)       stow_dwm ;;
            ai-agent)  stow_ai_agent ;;
            all|"")    stow_all ;;
            *) echo "Unknown stow target: $2. Use: i3, tmux, dwm, ai-agent, or all."; exit 1 ;;
        esac
        ;;
    unstow)
        unstow "${2:-}"
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
        if [[ "${2:-}" == "--force" ]]; then
            limine_force
        else
            limine_install
        fi
        ;;
    limine-force)
        limine_force
        ;;
    *)
        echo "Usage: $0 [all|packages [i3|all]|stow [i3|tmux|dwm|ai-agent]|unstow [i3|tmux|dwm|ai-agent]|check|login|limine]"
        echo "  all               — install packages + stow all + limine"
        echo "  packages          — install all required packages"
        echo "  packages i3       — install only i3 packages"
        echo "  stow              — stow all dotfiles + SDDM login setup (default)"
        echo "  stow i3           — stow only i3 package + SDDM login setup"
        echo "  stow tmux         — stow only tmux package"
        echo "  stow dwm          — stow only dwm package"
        echo "  stow ai-agent     — stow Claude/OpenCode/Hermes shared agent config"
        echo "  unstow i3         — remove i3 symlinks from home"
        echo "  unstow tmux       — remove tmux symlinks from home"
        echo "  unstow dwm        — remove dwm symlinks from home"
        echo "  unstow ai-agent   — remove ai-agent symlinks from home"
        echo "  unstow all        — remove all symlinks from home"
        echo "  check             — dry-run stow and verify key symlinks"
        echo "  login             — configure SDDM login screen, fix PAM (standalone)"
        echo "  limine            — install Limine + Plymouth + rebuild UKI (skips if exists)"
        echo "  limine --force    — force-overwrite all Limine/Plymouth config"
        exit 1
        ;;
esac
