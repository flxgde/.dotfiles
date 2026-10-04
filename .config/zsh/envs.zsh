# PATH
export PATH="$HOME/.rd/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Editor
export EDITOR='nvim'
export SUDO_EDITOR="$EDITOR"

# Tool configs
export BAT_THEME=ansi

# Node version manager (Linux only)
if [[ $(uname) != "Darwin" ]]; then
  export NVM_DIR="$HOME/.nvm"
fi

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"

