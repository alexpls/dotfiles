HISTSIZE=999999
HISTFILESIZE=$HISTSIZE
SAVEHIST=$HISTSIZE
export HISTFILE="$HOME/.history"
export ASDF_GOLANG_MOD_VERSION_ENABLED="true"
export HOMEBREW_BUNDLE_FILE="$HOME/.config/homebrew/Brewfile"

EDITOR=nvim

alias ls='ls --color=auto'

alias gss='git status'
alias gdc='git diff --cached'
alias gap='git add --patch'
alias gcm='git commit --message'

alias n='nvim .'

function external-ip {
  dig +short myip.opendns.com @resolver1.opendns.com
}

function notify {
  if [[ -n $1 ]] && [[ -n $2 ]]; then
    osascript -e "display notification \"$2\" with title \"$1\""
  else
    osascript -e "display notification \"$1\""
  fi
}

function git-recent-committers {
  git log --pretty=format:"%h, %ae, %ar" | awk -F ', ' '!seen[$2]++'
}

eval "$(fzf --zsh)"
eval "$(atuin init zsh)"

# List my open PRs for the repo at my cwd.
alias prs="gh pr list --author \"@me\""

eval "$(starship init zsh)"

if [[ -f ~/.zshrc_local ]]; then
  source ~/.zshrc_local
fi

