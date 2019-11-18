#!/bin/bash

# push current branch to remote 'origin', setting upstream automatically
git config --global alias.pushup 'push -u origin HEAD'

# Force push (with lease)
git config --global alias.pushf 'push --force-with-lease'

# Stash all files (including untracked)
git config --global alias.stash-all 'stash save --include-untracked'

# Pretty graphical log
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"

# List branches ordered by most recent commits
git config --global alias.branchr 'branch --sort=-committerdate'
git config --global pager.branchr true

# Checkout a branch
git config --global alias.co 'checkout'

# Checkout a new branch
git config --global alias.cb 'checkout -b'

# Amend a commit without needing to confirm a git message
git config --global alias.amend 'commit --amend --no-edit'

# Print the revision (truncated) of HEAD
git config --global alias.rev "rev-parse --short HEAD"
