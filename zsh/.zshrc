EDITOR=nvim
HISTSIZE=999999
HISTFILESIZE=$HISTSIZE
SAVEHIST=$HISTSIZE
export HISTFILE="$HOME/.history"
export HOMEBREW_BUNDLE_FILE="$HOME/.config/homebrew/Brewfile"

alias ls='ls --color=auto'

autoload -Uz compinit
compinit

n() {
  if [ $# -eq 0 ]; then
    nvim .
  else
    nvim "$@"
  fi
}
compdef n=nvim # tab auto-completions for the 'n' alias

eval "$(fzf --zsh)"
eval "$(mise activate zsh)"
eval "$(starship init zsh)"

if [[ -f ~/.zshrc_local ]]; then
  source ~/.zshrc_local
fi

