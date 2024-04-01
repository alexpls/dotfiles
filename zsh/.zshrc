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

if [[ -f ~/.zshrc_local ]]; then
  source ~/.zshrc_local
fi

