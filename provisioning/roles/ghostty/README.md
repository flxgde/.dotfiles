# ghostty role

Installs ghostty and symlinks `~/.config/ghostty` to the checked-in
config in this repo.

## Supported OS families

`Archlinux`, `Darwin`. Ghostty isn't in standard Debian/RHEL repos — add
support there if needed.

## Install notes

- **Arch**: installs from the official `extra` repo via pacman.
- **macOS**: installs via `brew install --cask ghostty`.

## Default terminal

Making ghostty the default (Hyprland `Super+Return`, `xdg-terminals.list`)
is done by the `default-terminal` role, driven by the `terminal` var in
`terminal.yml` (default: `ghostty`).
