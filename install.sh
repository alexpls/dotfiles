#!/bin/bash

BASH_DIR="$(pwd)/bash"

echo "Installing dotfiles..."

# Install bash stuff
echo "
source $(pwd)/attach.sh "$(pwd)"
" >> ~/.bash_profile
source ~/.bash_profile

# Install tmux stuff
cat "tmux/tmux.conf" >> ~/.tmux.conf

echo "Done!"
