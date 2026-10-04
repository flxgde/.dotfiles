# provisioning

Ansible playbooks that install the apps used by this dotfiles repo and
symlink the configs into place. Split by concern — run only what you
need. Nothing here bootstraps an OS; install CachyOS first.

Supported OS families: `Archlinux`, `Darwin`.

## Playbooks

| Playbook       | Concern                                                          |
|----------------|------------------------------------------------------------------|
| `all.yml`      | Everything below except `backup.yml` — see below                 |
| `backup.yml`   | Tarball snapshot of ~/.config, ~/.zshrc, ~/.local/bin            |
| `shell.yml`    | zsh + oh-my-zsh + .zshrc symlink                                 |
| `tmux.yml`     | tmux + tpm + tmux.conf symlink                                   |
| `terminal.yml` | ghostty or kitty (`-e terminal=kitty`) + config symlink + set as default |
| `neovim.yml`   | neovim + tree-sitter CLI + Node.js/npm (for Mason) + config symlink |
| `hyprland.yml` | hyprland configs (symlink-only — the CachyOS Hyprland edition installs hyprland; Linux-only, guarded so it's a no-op elsewhere) |
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

All commands below assume you're inside `provisioning/`. `-K` prompts for
your sudo password — needed by every playbook that installs packages
(`shell`, `tmux`, `terminal`, `neovim`, `all`); `backup`, `hyprland` and
`claude` only touch your home directory.

### Every playbook

```bash
ansible-playbook backup.yml                         # snapshot ~/.config, ~/.zshrc, ~/.local/bin first
ansible-playbook all.yml -K                         # everything except backup
ansible-playbook all.yml -K -e terminal=kitty       # everything, with kitty as the terminal

ansible-playbook shell.yml -K                       # zsh + zoxide + .zshrc / ~/.config/zsh symlinks
ansible-playbook tmux.yml -K                        # tmux + tpm + tmux.conf + ~/.local/bin scripts
ansible-playbook terminal.yml -K                    # ghostty (default) + set as default terminal
ansible-playbook terminal.yml -K -e terminal=kitty  # kitty + set as default terminal
ansible-playbook neovim.yml -K                      # neovim + tree-sitter CLI + Node.js/npm + config
ansible-playbook hyprland.yml                       # hypr config symlinks (Linux only)
ansible-playbook claude.yml                         # Claude Code hooks/statusline + ~/.local/bin scripts
```

After switching terminals on Hyprland, run `hyprctl reload` so
`Super+Return` picks up the new one.

### Variables

| Variable   | Playbooks                  | Values                          |
|------------|----------------------------|---------------------------------|
| `terminal` | `terminal.yml`, `all.yml`  | `ghostty` (default), `kitty`    |

### Tags

Run part of a playbook with `--tags`:

| Playbook       | Tags                                     |
|----------------|------------------------------------------|
| `backup.yml`   | `backup`                                 |
| `shell.yml`    | `zsh`                                    |
| `tmux.yml`     | `tmux`, `local-bin`                      |
| `terminal.yml` | `ghostty`, `kitty`, `default-terminal`   |
| `claude.yml`   | `claude`, `local-bin`                    |

```bash
ansible-playbook tmux.yml --tags local-bin                           # only re-link ~/.local/bin scripts
ansible-playbook terminal.yml -e terminal=kitty --tags default-terminal  # switch default without installing (no sudo)
```

### Checking before running

```bash
ansible-playbook <playbook>.yml --syntax-check   # syntax only
ansible-playbook <playbook>.yml -K --check --diff  # dry run, shows what would change
```

## Inventory

`inventory/local.yml` targets `localhost` with `ansible_connection: local`.
Add more inventories for remote hosts as needed.

## Prerequisites

- `ansible` installed locally.
- On macOS: Homebrew must already be installed; the shell playbook does
  not bootstrap brew.
