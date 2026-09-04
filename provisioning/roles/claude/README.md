# claude role

Merges the dotfiles-managed Claude Code hooks (`files/hooks.json`) into
`~/.claude/settings.json`, additively — anything else already in that
file (theme, plugins, other hooks, ...) is left untouched.

## Why not a symlink

`~/.claude/settings.json` is rewritten live by Claude Code itself
(theme/model toggles, plugin state, an auto-generated environment
snapshot). Symlinking the whole file, like other roles do for their
configs, would import this machine's live state onto every other
machine and turn routine UI tweaks into repo diffs. So this role runs
a small merge script (`files/merge_hooks.py`) instead.

## What the hooks do

Wire up `.local/bin/claude-tmux-status` (symlinked by the `local-bin`
role) so the tmux status bar can show a live icon per session: 🤖
working, 💡 waiting on you, 🔔 asking for something. See
`.local/bin/tmux-session-list` for the icon logic.

## No OS guard

Pure JSON read/merge/write — works on any OS family.
