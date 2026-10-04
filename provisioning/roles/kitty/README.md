# kitty role

Installs kitty and symlinks `~/.config/kitty` to the checked-in config in
this repo (`kitty.conf` mirrors the ghostty config; Catppuccin Macchiato
colors live in `catppuccin-macchiato.conf`).

Only runs when `terminal.yml` is invoked with `-e terminal=kitty`.

## Supported OS families

`Archlinux`, `Darwin`.

## Install notes

- **Arch**: installs from the official `extra` repo via pacman.
- **macOS**: installs via `brew install --cask kitty`.
