# flxg Dotfiles

This repository contains my personal configuration files for a clean and customized desktop environment. It includes configurations for Zsh, Neovim, Hyprland, Ghostty, Tmux, and custom scripts.

---

## Features

- **Shell:** Zsh with plugins for autosuggestions, syntax highlighting, and fast syntax highlighting.
- **Prompt:** Starship with `bracketed-segments` preset for a clean, minimal prompt.
- **Window Manager:** Hyprland with custom workspace and theme configuration.
- **Editor:** Neovim with modular Lua configuration, plugin management, and LSP support.
- **Terminal:** Ghostty with Catppuccin Macchiato theme.
- **Tmux:** Tmux with tpm (Tmux Plugin Manager) and Catppuccin Macchiato theme.
- **Scripts:** Custom binaries in `.local/bin` for workflow utilities.
- **Provisioning:** Per-concern Ansible playbooks under [`provisioning/`](./provisioning) that install apps and symlink configs. No OS bootstrapping — see `provisioning/README.md`.

---

## Installation

Install CachyOS (or macOS with Homebrew) and `ansible` first, then:

```bash
git clone https://github.com/flxgde/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles/provisioning
ansible-playbook backup.yml        # optional: snapshot existing configs first
ansible-playbook all.yml -K        # installs everything and symlinks configs
```

`-K` prompts for your sudo password, which the package-install tasks need.
Run from inside `provisioning/` so `ansible.cfg` picks up the local inventory.
See [`provisioning/README.md`](./provisioning/README.md) to run individual
playbooks.

---

## Theme

All components use **Catppuccin Macchiato** (dark theme) for a consistent look across the environment.

