# tmux entry point: show the session switcher if a server is already
# running (inside or outside tmux), otherwise bootstrap the default
# (home) session.
t() {
  if pgrep tmux >/dev/null 2>&1; then
    ~/.local/bin/tmux-switch-session
  else
    ~/.local/bin/tmux-sessionizer "$HOME"
  fi
}

# Nvim shortcut: `n` with no args opens cwd, otherwise passes args through
n() {
  if [ "$#" -eq 0 ]; then
    command nvim .
  else
    command nvim "$@"
  fi
}

# Fuzzy-pick a file; preview via bat
if command -v fzf &> /dev/null && command -v bat &> /dev/null; then
  ff() { fzf --preview 'bat --style=numbers --color=always {}' }
  eff() { ${EDITOR:-nvim} "$(ff)" }
fi

# Fuzzy-pick newest file (by mtime), scp to destination
sff() {
  if [ $# -eq 0 ]; then
    echo "Usage: sff <destination> (e.g. sff host:/tmp/)"
    return 1
  fi
  local file
  file=$(find . -type f -printf '%T@\t%p\n' | sort -rn | cut -f2- | ff) \
    && [ -n "$file" ] && scp "$file" "$1"
}
