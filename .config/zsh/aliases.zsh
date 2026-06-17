# Dotfiles management (bare-repo style)
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# File system (Omarchy-inspired)
if command -v eza &> /dev/null; then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
else
  alias ls='ls --color=auto'
fi

alias ll='ls -lh'
alias la='ls -lAh'
alias l='ls -lah'

# Directory traversal
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git
alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'

# xdg-open wrapper (Linux only; macOS has a builtin `open`)
if command -v xdg-open &> /dev/null; then
  open() ( xdg-open "$@" >/dev/null 2>&1 & )
fi

# Tools
alias d='docker'
alias k='kubectl'
