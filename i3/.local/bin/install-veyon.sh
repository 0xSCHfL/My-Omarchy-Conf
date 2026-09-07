#!/usr/bin/env bash
set -Eeuo pipefail

# Re-runnable Veyon setup for Arch Linux with Hyprland/i3.
# The existing Veyon configuration is backed up before package changes.

readonly VeyonConfig='/etc/xdg/Veyon Solutions/Veyon.conf'
readonly VeyonKeys='/etc/veyon/keys'
readonly BackupRoot="${VEYON_BACKUP_ROOT:-$HOME/Backups/veyon}"
readonly Configurator='/usr/bin/veyon-configurator'
readonly PolkitAgent='/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1'
readonly UserBin="$HOME/.local/bin"
readonly Applications="$HOME/.local/share/applications"
readonly Autostart="$HOME/.config/autostart"

usage() {
    cat <<'EOF'
Usage:
  install-veyon.sh             Back up and install/configure Veyon.
  install-veyon.sh --backup-only
                               Only create a private backup of Veyon files.
EOF
}

die() {
    printf 'ERROR: %s\n' "$*" >&2
    exit 1
}

info() {
    printf '\n==> %s\n' "$*"
}

[[ "${EUID}" -ne 0 ]] || die 'Run this script as your normal user, not with sudo.'
command -v sudo >/dev/null 2>&1 || die 'sudo is required.'
command -v pacman >/dev/null 2>&1 || die 'This installer requires Arch Linux pacman.'

case "${1:-}" in
    '') ;;
    --backup-only) backup_only=1 ;;
    --help|-h) usage; exit 0 ;;
    *) usage >&2; die "Unknown option: $1" ;;
esac
backup_only="${backup_only:-0}"

sudo -v

stamp="$(date '+%Y%m%d-%H%M%S')"
backup_dir="$BackupRoot/veyon-$stamp"
mkdir -p "$backup_dir"
chmod 700 "$BackupRoot" "$backup_dir"

info 'Backing up the current Veyon configuration'
if sudo test -f "$VeyonConfig"; then
    sudo cp -a "$VeyonConfig" "$backup_dir/Veyon.conf"
    sudo chown "$(id -u):$(id -g)" "$backup_dir/Veyon.conf"
    chmod 600 "$backup_dir/Veyon.conf"
    printf 'Saved: %s\n' "$backup_dir/Veyon.conf"
else
    printf 'No existing configuration file found.\n'
fi

if sudo test -d "$VeyonKeys"; then
    sudo cp -a "$VeyonKeys" "$backup_dir/keys"
    sudo chown -R "$(id -u):$(id -g)" "$backup_dir/keys"
    chmod -R u=rwX,go= "$backup_dir/keys"
    printf 'Saved: %s\n' "$backup_dir/keys"
else
    printf 'No existing Veyon keys directory found.\n'
fi

cat > "$backup_dir/README.txt" <<EOF
Veyon backup created: $(date --iso-8601=seconds)
Source configuration: $VeyonConfig
Source keys: $VeyonKeys
This directory contains sensitive Veyon authentication material.
EOF
chmod 600 "$backup_dir/README.txt"

if [[ "$backup_only" -eq 1 ]]; then
    printf '\nBackup complete.\n'
    printf 'Backup: %s\n' "$backup_dir"
    exit 0
fi

info 'Installing Veyon and desktop integration packages'
veyon_package=''
if pacman -Q veyon-bin >/dev/null 2>&1; then
    veyon_package='veyon-bin'
elif pacman -Q veyon >/dev/null 2>&1; then
    veyon_package='veyon'
elif command -v yay >/dev/null 2>&1 && yay -Si veyon-bin >/dev/null 2>&1; then
    veyon_package='veyon-bin'
elif command -v paru >/dev/null 2>&1 && paru -Si veyon-bin >/dev/null 2>&1; then
    veyon_package='veyon-bin'
elif pacman -Si veyon >/dev/null 2>&1; then
    veyon_package='veyon'
else
    die 'Could not find veyon-bin in the AUR or veyon in the configured repositories.'
fi

packages=("$veyon_package" polkit polkit-gnome xdg-desktop-portal-hyprland xorg-xhost)
if command -v yay >/dev/null 2>&1; then
    yay -S --needed "${packages[@]}"
elif command -v paru >/dev/null 2>&1; then
    paru -S --needed "${packages[@]}"
else
    pacman_repo_packages=()
    for package in "${packages[@]}"; do
        if pacman -Si "$package" >/dev/null 2>&1; then
            pacman_repo_packages+=("$package")
        fi
    done
    ((${#pacman_repo_packages[@]} > 0)) || die 'No package manager could install the required packages.'
    sudo pacman -S --needed "${pacman_repo_packages[@]}"
    pacman -Q "$veyon_package" >/dev/null 2>&1 || die "Install an AUR helper, then rerun this script for $veyon_package."
fi

[[ -x "$Configurator" ]] || die "Veyon Configurator was not installed at $Configurator."
[[ -x "$PolkitAgent" ]] || die "Polkit authentication agent was not installed at $PolkitAgent."

info 'Enabling the Veyon service'
sudo systemctl enable --now veyon.service

info 'Installing the Hyprland-safe Configurator launcher'
mkdir -p "$UserBin" "$Applications" "$Autostart"

cat > "$UserBin/veyon-configurator-hyprland" <<'LAUNCHER'
#!/usr/bin/env bash
set -euo pipefail

configurator=/usr/bin/veyon-configurator

if [[ "${XDG_SESSION_TYPE:-}" == "wayland" && -n "${DISPLAY:-}" && "${EUID}" -ne 0 ]]; then
    root_access_already_allowed=0
    if xhost 2>/dev/null | grep -Fq 'SI:localuser:root'; then
        root_access_already_allowed=1
    else
        xhost +SI:localuser:root >/dev/null
    fi

    cleanup() {
        if [[ "$root_access_already_allowed" -eq 0 ]]; then
            xhost -SI:localuser:root >/dev/null 2>&1 || true
        fi
    }
    trap cleanup EXIT

    pkexec env DISPLAY="$DISPLAY" QT_QPA_PLATFORM=xcb "$configurator" -elevated "$@"
else
    exec "$configurator" "$@"
fi
LAUNCHER
chmod 755 "$UserBin/veyon-configurator-hyprland"

cat > "$Applications/veyon-configurator.desktop" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Exec=$UserBin/veyon-configurator-hyprland
Icon=veyon-configurator
Terminal=false
Name=Veyon Configurator
Comment=Configuration tool for Veyon
Categories=Education;Network;Settings;System;RemoteAccess;
Keywords=classroom;control;computer;room;lab;monitoring;teacher;student;settings;configuration;
EOF
chmod 644 "$Applications/veyon-configurator.desktop"

info 'Ensuring the Polkit agent starts in Hyprland'
cat > "$Autostart/veyon-polkit-agent.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Veyon Polkit Authentication Agent
Exec=$PolkitAgent
OnlyShowIn=Hyprland;
X-GNOME-Autostart-enabled=true
NoDisplay=true
EOF
chmod 644 "$Autostart/veyon-polkit-agent.desktop"

if [[ "${XDG_CURRENT_DESKTOP:-}" == *Hyprland* || -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    if ! pgrep -u "$(id -u)" -f '/polkit-gnome-authentication-agent-1' >/dev/null 2>&1; then
        hyprctl dispatch exec -- "$PolkitAgent" >/dev/null 2>&1 || true
    fi
fi

info 'Verifying the installation'
for binary in veyon-master veyon-configurator veyon-cli veyon-service; do
    command -v "$binary" >/dev/null 2>&1 || die "Missing Veyon binary: $binary"
done
[[ "$(systemctl is-active veyon.service)" == active ]] || die 'veyon.service is not active.'
veyon-cli service status

printf '\nSetup complete.\n'
printf 'Backup: %s\n' "$backup_dir"
printf 'Configurator: %s\n' "$UserBin/veyon-configurator-hyprland"
printf 'It is safe to rerun this script; it creates a new backup each time.\n'
