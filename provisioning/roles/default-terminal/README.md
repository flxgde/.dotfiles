# default-terminal role

Makes the terminal selected by the `terminal` var (`ghostty` | `kitty`,
set in `terminal.yml`) the default. The Hyprland/xdg parts are Linux
only; the Claude Code part runs everywhere.

- Writes `~/.config/hypr/terminal.lua` (`TERMINAL = "<bin>"`), which
  `.config/hypr/hyprland.lua` loads optionally — drives `Super+Return`.
  It's a generated per-machine file, not a symlink into the repo.
- Writes `~/.config/xdg-terminals.list` with the selected terminal first,
  alacritty as fallback, for `xdg-terminal-exec`.
- Sets `preferredNotifChannel` in `~/.claude/settings.json` to the
  selected terminal (`files/set_json_key.py` touches only that key; the
  file is rewritten live by Claude Code, so it can't be a symlink).
  Claude Code's default `auto` detects the terminal from the environment,
  and inside tmux it only sees `TERM_PROGRAM=tmux`, so no desktop
  notification is sent. Pinned, it emits kitty's/ghostty's notification
  escape wrapped for tmux, which `allow-passthrough on` in `tmux.conf`
  lets through.

Adding a terminal: give it a role and an entry in `vars/main.yml`.
