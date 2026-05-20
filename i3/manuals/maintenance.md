# Maintenance Manual

Local repo:

```bash
cd ~/Work/dotfiles
```

## Validate

```bash
bash -n i3/.local/bin/i3-manuals
bash -n i3/.local/bin/i3-keys
i3 -C -c i3/.config/i3/config
```

## Apply i3 Dotfiles

```bash
stow -t "$HOME" --restow \
  --ignore='^shell$' \
  --ignore='^sddm-theme$' \
  --ignore='^default$' \
  i3
```

## Reload i3

```bash
i3-msg reload
```

## Boot / Limine Warning

Limine root cmdline is machine-specific. Use:

```bash
./install.sh limine --force
```

only from the target installed system, not a live USB root unless chrooted correctly.

## Useful Health Commands

```bash
./install.sh check
git status --short
systemctl --user status
```
