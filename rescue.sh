#!/bin/bash
# Rescue script — run from Arch Linux live USB
# Usage: bash rescue.sh [fix-limine|fix-plymouth|claude]
set -e

MNT="/mnt"
LUKS_DEV="/dev/nvme0n1p2"
BOOT_DEV="/dev/nvme0n1p1"
MAPPER="cryptroot"

# --- WiFi ---
if ! ping -c1 -W2 8.8.8.8 &>/dev/null; then
    echo "[*] No network detected."
    echo "    Run iwctl manually to connect, then press Enter to continue."
    echo "    Quick guide:"
    echo "      iwctl"
    echo "      [iwd] device list"
    echo "      [iwd] station wlan0 scan"
    echo "      [iwd] station wlan0 get-networks"
    echo "      [iwd] station wlan0 connect \"YourSSID\""
    echo "      [iwd] exit"
    echo ""
    read -rp "Press Enter when connected (or Ctrl+C to abort)..."
    if ! ping -c1 -W2 8.8.8.8 &>/dev/null; then
        echo "[!] Still no network — continuing anyway (claude may not work)"
    fi
else
    echo "[*] Network OK."
fi

# --- LUKS ---
echo "[*] Opening LUKS (enter your disk password)..."
cryptsetup status "$MAPPER" &>/dev/null || cryptsetup open "$LUKS_DEV" "$MAPPER"

# --- Mount ---
echo "[*] Mounting btrfs subvolumes..."
mkdir -p "$MNT"
mount -o subvol=@ /dev/mapper/$MAPPER "$MNT"
mount "$BOOT_DEV" "$MNT/boot"
mkdir -p "$MNT/home" "$MNT/var/log" "$MNT/var/cache/pacman/pkg"
mount -o subvol=@home /dev/mapper/$MAPPER "$MNT/home"
mount -o subvol=@log  /dev/mapper/$MAPPER "$MNT/var/log"
mount -o subvol=@pkg  /dev/mapper/$MAPPER "$MNT/var/cache/pacman/pkg"

# Copy live DNS so the chroot has network (needed for claude)
cp /etc/resolv.conf "$MNT/etc/resolv.conf"

echo "[*] Mounts done."

# --- Fix modes or chroot ---
if [[ "$1" == "fix-limine" ]]; then
    echo "[*] Reverting Limine backdrop to solid color..."
    sed -i 's|backdrop: boot():/backdrop.png|backdrop: 1a1b26|' "$MNT/boot/limine.conf"
    echo "[*] Resetting UEFI boot order (Omarchy/UKI first)..."
    arch-chroot "$MNT" efibootmgr -o 0005,0008,0000,0001,0002,0003,0004
    echo "[+] Done. Reboot."

elif [[ "$1" == "fix-plymouth" ]]; then
    echo "[*] Disabling plymouth and rebuilding UKI..."
    grep -q "plymouth.enable=0" "$MNT/etc/default/limine" || \
        echo 'KERNEL_CMDLINE[default]+="plymouth.enable=0"' >> "$MNT/etc/default/limine"
    arch-chroot "$MNT" limine-mkinitcpio
    echo "[+] Done. Reboot."

elif [[ "$1" == "claude" ]]; then
    echo "[*] Launching claude as sohaib inside chroot..."
    arch-chroot "$MNT" sudo -u sohaib claude

else
    echo "[*] Entering chroot — type 'exit' when done"
    echo "    To launch claude:  sudo -u sohaib claude"
    arch-chroot "$MNT" /bin/bash
fi

# --- Cleanup ---
echo "[*] Cleaning up..."
umount -R "$MNT" 2>/dev/null || true
cryptsetup close "$MAPPER" 2>/dev/null || true
echo "[*] Done."
