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

# Omarchy: prepend its bin to PATH when present (no-op elsewhere)
if [[ -d "$HOME/.local/share/omarchy" ]]; then
  export OMARCHY_PATH="$HOME/.local/share/omarchy"
  export PATH="$OMARCHY_PATH/bin:$PATH"
fi

