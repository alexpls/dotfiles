#!/bin/bash

# Run a `git fetch` on each git repo defined in the
# file ~/.git_repos_autofetch

AUTOFETCH_FILE="$HOME/.git_repos_autofetch"

git_fetch_all() {
  while read line; do
    echo "Fetching git repo: $line"
    GIT_DIR="$line/.git" git fetch
  done < $AUTOFETCH_FILE
}

