HISTSIZE=999999
HISTFILESIZE=$HISTSIZE
SAVEHIST=$HISTSIZE
export HISTFILE="$HOME/.history"

EDITOR=nvim

alias ls='ls --color=auto'
alias vim='nvim'

function external_ip {
  dig +short myip.opendns.com @resolver1.opendns.com
}

function notify {
  if [[ -n $1 ]] && [[ -n $2 ]]; then
    osascript -e "display notification \"$2\" with title \"$1\""
  else
    osascript -e "display notification \"$1\""
  fi
}

eval "$(fzf --zsh)"

if [[ -f ~/.zshrc_local ]]; then
  source ~/.zshrc_local
fi

