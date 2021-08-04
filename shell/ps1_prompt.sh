#
# SET UP PS1 PROMPT
#

cwd_git_repo_changes_formatted() {
  if git rev-parse --is-inside-git-tree > /dev/null 2>&1; then :
    local changes=$(git status --porcelain)
    [[ ! -z $changes ]] && echo "…"
  fi
}

cwd_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

cwd_git_branch_formatted() {
  local branch=$(cwd_git_branch)
  [[ ! -z $branch ]] && echo "($(cwd_git_branch))"
}

LIGHT_GRAY="\[\033[90m\]"
LIGHT_BLUE="\[\033[1;34m\]"
DEFAULT="\[\033[0m\]"

# Only add the PS1 prompt to bash shell, when using zsh there's usually
# a nice prompt configured anyway.
if [[ "$SHELL" == *"bash"* ]]; then
  export PS1="${LIGHT_GRAY}\u@\h${DEFAULT}:\w${LIGHT_BLUE}\$(cwd_git_branch_formatted)\$(cwd_git_repo_changes_formatted)${DEFAULT}\n${LIGHT_GRAY}\$${DEFAULT} "
fi
