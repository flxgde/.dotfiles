# ── Zinit (plugin manager) ────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Completions + syntax highlighting + autosuggestions (turbo-loaded)
zinit wait lucid for \
  atinit"autoload -Uz compinit && compinit -C" \
  zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
  zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
  zsh-users/zsh-completions

# Oh-My-Zsh git plugin + lib
zinit wait lucid for \
  OMZL::git.zsh \
  OMZP::git

# FZF + Ctrl-R history search
zinit wait lucid for \
  junegunn/fzf \
  joshskidmore/zsh-fzf-history-search

# Pure prompt
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

# ── Tool integrations ─────────────────────────────────────────

# Zoxide (cached init; regenerate with: zoxide init zsh > ~/.zoxide.zsh)
if [[ -f ~/.zoxide.zsh ]]; then
  source ~/.zoxide.zsh
elif command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# cd → zd: exact dir uses builtin cd, otherwise zoxide jump with a pretty arrow
if command -v zoxide &> /dev/null; then
  zd() {
    if (( $# == 0 )); then
      builtin cd ~ || return
    elif [[ -d $1 ]]; then
      builtin cd "$1" || return
    else
      z "$@" || { echo "Error: Directory not found"; return 1 }
      printf "\U000F17A9 "; pwd
    fi
  }
  alias cd='zd'
fi

# NVM (Linux only)
if [[ $(uname) != "Darwin" ]] && [[ -n "$NVM_DIR" ]]; then
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi


# ── keybindings ─────────────────────────────────

# Alt+P → reload .zshrc
configreload-widget() {
  BUFFER="source ~/.zshrc"
  zle accept-line
}
zle -N configreload-widget
bindkey '\ep' configreload-widget


# ── sdkman ─────────────────────────────────
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
