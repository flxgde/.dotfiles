# default-terminal role

Makes the terminal selected by the `terminal` var (`ghostty` | `kitty`,
set in `terminal.yml`) the default. Linux only; a no-op on macOS.

- Writes `~/.config/hypr/terminal.lua` (`TERMINAL = "<bin>"`), which
  `.config/hypr/hyprland.lua` loads optionally — drives `Super+Return`.
  It's a generated per-machine file, not a symlink into the repo.
- Writes `~/.config/xdg-terminals.list` with the selected terminal first,
  alacritty as fallback, for `xdg-terminal-exec`.

Adding a terminal: give it a role and an entry in `vars/main.yml`.
