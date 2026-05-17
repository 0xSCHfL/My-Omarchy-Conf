#!/bin/bash
# Rescue script — run from Arch Linux live USB
# Usage: bash rescue.sh [fix-limine]
set -e

MNT="/mnt/rescue"
LUKS_DEV="/dev/nvme0n1p2"
BOOT_DEV="/dev/nvme0n1p1"
MAPPER="cryptroot"

# --- Mount ---
echo "[*] Opening LUKS (enter your disk password)..."
cryptsetup status "$MAPPER" &>/dev/null || cryptsetup open "$LUKS_DEV" "$MAPPER"

echo "[*] Mounting..."
mkdir -p "$MNT"
mount -o subvol=@ /dev/mapper/$MAPPER "$MNT"
mount "$BOOT_DEV" "$MNT/boot"
mkdir -p "$MNT/home" "$MNT/var/log" "$MNT/var/cache/pacman/pkg"
mount -o subvol=@home /dev/mapper/$MAPPER "$MNT/home"
mount -o subvol=@log  /dev/mapper/$MAPPER "$MNT/var/log"
mount -o subvol=@pkg  /dev/mapper/$MAPPER "$MNT/var/cache/pacman/pkg"
mount --bind /dev  "$MNT/dev"
mount --bind /proc "$MNT/proc"
mount --bind /sys  "$MNT/sys"

# --- Fix modes ---
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

else
    echo "[*] Entering chroot — type 'exit' when done"
    arch-chroot "$MNT" /bin/bash
fi

# --- Cleanup ---
echo "[*] Cleaning up..."
umount "$MNT/boot" "$MNT/dev" "$MNT/proc" "$MNT/sys" \
       "$MNT/home" "$MNT/var/log" "$MNT/var/cache/pacman/pkg" \
       "$MNT" 2>/dev/null || true
echo "[*] Done."
