#!/bin/bash

# Run a `git fetch` on each git repo defined in the
# file ~/.git_repos_autofetch

AUTOFETCH_FILE="$HOME/.git_repos_autofetch"

autofetch_git_repos() {
  while read line; do
    echo "Fetching git repo: $line"
    cd "$line" && git fetch
  done < $AUTOFETCH_FILE
}

