# browser role

Installs the browser selected by the `browser` var (`firefox` (default) |
`brave` | `chrome`, set in `browser.yml`) and makes it the default.
Other browsers are left installed. No config to symlink.

## Supported OS families

`Archlinux`, `Darwin`.

## Install notes

| `browser` | Arch (pacman)             | macOS (Homebrew cask) |
|-----------|---------------------------|-----------------------|
| `firefox` | `firefox` (extra)         | `firefox`             |
| `brave`   | `brave-bin` (cachyos)     | `brave-browser`       |
| `chrome`  | `chromium` (extra)        | `google-chrome`       |

`chrome` is Chromium on Arch: Google Chrome is AUR-only and this repo
doesn't assume an AUR helper.

## Default browser (Linux only)

- Writes `~/.config/hypr/browser.lua` (`BROWSER = "<bin>"`), loaded
  optionally by `.config/hypr/hyprland.lua` — drives `Super+W`. Generated
  per machine, not a symlink.
- Runs `xdg-settings set default-web-browser <desktop>` (links, xdg-open).

macOS only allows changing the default browser via a GUI prompt, so set
it there by hand.

## Tags

- `browser-install`: only install.
- `browser-default`: only switch the default (no sudo needed).
