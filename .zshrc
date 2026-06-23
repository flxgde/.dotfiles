# All the default modular zsh config
# (don't mess with these directly, just overwrite them here!)
for f in ~/.config/zsh/envs.zsh ~/.config/zsh/shell.zsh ~/.config/zsh/aliases.zsh ~/.config/zsh/functions.zsh ~/.config/zsh/init.zsh; do
  [[ -r "$f" ]] && source "$f"
done

# Optional per-machine overrides
[[ -r ~/.aliases ]] && source ~/.aliases


# Load Angular CLI autocompletion.
source <(ng completion script)
