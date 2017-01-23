#
# SET UP PS1 PROMPT
#

cwd_git_repo_changes_formatted() {
  local changes=$(git status --porcelain)
  [[ ! -z $changes ]] && echo "…"
}

cwd_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

cwd_git_branch_formatted() {
  local branch=$(cwd_git_branch)
  [[ ! -z $branch ]] && cwd_git_branch
}

LIGHT_GRAY="\[\033[90m\]"
LIGHT_BLUE="\[\033[1;34m\]"
DEFAULT="\[\033[0m\]"

export PS1="${LIGHT_GRAY}\u@\h${DEFAULT}:\w${LIGHT_BLUE}(\$(cwd_git_branch_formatted))\$(cwd_git_repo_changes_formatted)${DEFAULT}\n${LIGHT_GRAY}\$${DEFAULT} "

