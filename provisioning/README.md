# provisioning

Ansible playbooks that install the apps used by this dotfiles repo and
symlink the configs into place. Split by concern — run only what you
need. Nothing here bootstraps an OS; that's Omarchy's job.

Supported OS families: `Archlinux`, `Darwin`.

## Playbooks

| Playbook       | Concern                                                          |
|----------------|------------------------------------------------------------------|
| `all.yml`      | Everything below except `backup.yml` — see below                 |
| `backup.yml`   | Tarball snapshot of ~/.config, ~/.zshrc, ~/.local/bin            |
| `shell.yml`    | zsh + oh-my-zsh + .zshrc symlink                                 |
| `tmux.yml`     | tmux + tpm + tmux.conf symlink                                   |
| `terminal.yml` | ghostty + config symlink                                         |
| `neovim.yml`   | neovim + config symlink                                          |
| `hyprland.yml` | hyprland configs (symlink-only — Omarchy installs hyprland; Linux-only, guarded so it's a no-op elsewhere) |
| `claude.yml`   | Claude Code tmux-status hooks, merged into ~/.claude/settings.json |

> **Run `backup.yml` first** before any concern playbook when you're
> migrating an existing machine — concern playbooks will replace real
> config dirs with symlinks.

> **One-click setup**: `ansible-playbook all.yml` runs every concern
> playbook above except `backup.yml` (run that first if migrating a
> machine with real configs already in place). `hyprland.yml` is
> included but guarded by `ansible_facts['system'] == 'Linux'`, so it's
> a safe no-op on macOS.

## Running

All commands below assume you're inside `provisioning/`.

```bash
# Syntax check
ansible-playbook shell.yml --syntax-check

# Dry-run, shows what would change
ansible-playbook shell.yml --check --diff

# Real run
ansible-playbook shell.yml

# Only one role via tags
ansible-playbook shell.yml --tags zsh
```

## Inventory

`inventory/local.yml` targets `localhost` with `ansible_connection: local`.
Add more inventories for remote hosts as needed.

## Prerequisites

- `ansible` installed locally.
- On macOS: Homebrew must already be installed; the shell playbook does
  not bootstrap brew.
