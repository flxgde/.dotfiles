# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository containing configurations for a development environment across Linux (Hyprland) and macOS. Managed via symlinks from `~/dotfiles` to respective locations.

## Repository Structure

```
.zshrc                      # Shell config (Oh My Zsh, aliases, keybinds)
.config/
  nvim/                     # Neovim config (see .config/nvim/CLAUDE.md for details)
  tmux/tmux.conf            # Tmux config (prefix: C-a, vi keys, tpm plugins, theme detection)
  ghostty/config            # Ghostty terminal (auto-detects light/dark theme)
  hypr/                     # Hyprland override configs (overlay on Omarchy)
.local/bin/                 # Custom scripts
  tmux-sessionizer          # Create/switch tmux sessions from directories
  tmux-switch-session       # Switch between existing tmux sessions
provisioning/               # Per-concern Ansible playbooks: install apps and
                            # symlink these configs. No OS bootstrapping.
```

## Key Conventions

- **Symlink installation**: Configs are symlinked from `~/dotfiles` to their target locations (e.g., `~/.config/nvim`)
- **Platform-specific**: NVM loads only on non-Darwin systems; SDKMAN loads on Darwin
- **Tmux-centric workflow**: Sessions managed via fzf-based scripts; history per-session
- **Provisioning coverage is mandatory**: any new script, config file, or functionality must actually reach a fresh machine through `provisioning/`, not just work after a manual local fix (e.g. hand-symlinking a file). `.local/bin/` scripts and already-symlinked config files are auto-covered by their existing roles; a genuinely new *file* (especially one merged into something a tool rewrites live, like `~/.claude/settings.json`) needs its own role/task — see the `claude` role for that pattern. When finishing work that adds something new, confirm (or state) whether provisioning already covers it.

## Shell Keybinds (.zshrc)

| Keybind | Action |
|---------|--------|
| `Ctrl+F` | Open tmux-sessionizer (create/switch session from directory) |
| `Esc Esc` | Open tmux-switch-session (switch between sessions) |
| `Alt+P` | Reload .zshrc |

## Tmux Keybinds (tmux.conf)

| Keybind | Action |
|---------|--------|
| `C-a` | Prefix (rebound from C-b) |
| `prefix + f` | tmux-sessionizer |
| `prefix + Escape` | tmux-switch-session |
| `prefix + H` | Open nvim via sessionizer |
| `prefix + h/j/k/l` | Vim-style pane navigation |

## Hyprland Keybinds (Linux)

| Keybind | Action |
|---------|--------|
| `Super + Return` | Terminal (ghostty) |
| `Super + B` | Browser (Omarchy default) |
| `Super + Space` | App launcher (Omarchy walker) |
| `Super + W` | Kill window (Omarchy default) |
| `Super + H/J/K/L` | Move focus (vim-style — overrides Omarchy) |
| `Super + Shift + J/K/L` | Re-homed Omarchy actions displaced by vim nav |
| `Super + 1-9` | Switch workspace |
| `Super + Shift + 1-9` | Move window to workspace |
| `Super + F` | Fullscreen |

## Workspace Layout (Hyprland)

- WS 1: Browser (DP-1)
- WS 2: AI Chat (DP-1)
- WS 3: Terminal (DP-2, fullscreen)
- WS 4: IDE (DP-2)
- WS 6: Mail
- WS 8: Spotify

## Theme

All components use **Catppuccin Macchiato** (dark theme):
- **Tmux:** Catppuccin macchiato
- **Nvim:** Catppuccin macchiato with transparent background
- **Ghostty:** Catppuccin Macchiato
- **Starship:** Catppuccin Mocha palette
