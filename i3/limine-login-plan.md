# Omarchy Login Setup Port Plan

## Summary
Use Omarchy's Plymouth unlock flow for the encrypted-root password screen while keeping Limine menu visuals and SDDM/i3 login separate. The encrypted password screen is controlled by Plymouth inside initramfs, not by i3 or SDDM.

## Implemented Direction
- `limine/limine.conf` owns Limine menu visuals only.
- `limine/default-limine` owns the generated kernel cmdline and enables Plymouth unlock with `quiet splash`.
- `limine/omarchy_hooks.conf` owns the initramfs hook order and includes `plymouth` before `keyboard`/`encrypt`.
- `i3/.local/bin/i3-limine` copies all managed boot files, refreshes the Omarchy Plymouth theme, rebuilds Limine entries, and verifies the generated state.

## Safety Model
- The helper creates timestamped backups for:
  - `/boot/limine.conf`
  - `/etc/default/limine`
  - `/etc/mkinitcpio.conf.d/omarchy_hooks.conf`
- The helper fails loudly if:
  - generated `/boot/limine.conf` has no `cmdline:` line.
  - generated cmdline does not contain `quiet splash`.
  - generated cmdline still contains `plymouth.enable=0`.
  - live initramfs hooks do not contain `plymouth`.
  - default Plymouth theme is not `omarchy`.

## Rollback
If the graphical unlock screen is black again, type the disk password blindly and press Enter. After boot, restore text unlock by re-adding `plymouth.enable=0`, removing `plymouth` from `limine/omarchy_hooks.conf`, and rerunning `i3-limine`.

## Test Plan
- Static checks:
  - `bash -n i3/.local/bin/i3-limine install.sh`
  - confirm `limine/limine.conf` has no generated `/+...` entries.
  - confirm `limine/default-limine` contains `quiet splash` and not `plymouth.enable=0`.
  - confirm `limine/omarchy_hooks.conf` contains `plymouth` before `encrypt`.
- Live inspection after `i3-limine`:
  - `rg -n "cmdline|quiet|splash|plymouth.enable=0" /boot/limine.conf`
  - `rg -n "HOOKS=.*plymouth" /etc/mkinitcpio.conf.d/omarchy_hooks.conf`
  - `plymouth-set-default-theme`
- Reboot acceptance:
  - Omarchy graphical encrypted-root unlock appears.
  - disk password unlocks root.
  - system reaches i3.

## Assumptions
- The desired styled screen is the encrypted-root unlock screen, not SDDM.
- SDDM autologin remains a separate decision.
- Boot safety depends on preserving timestamped backups and keeping a text-unlock rollback path.
