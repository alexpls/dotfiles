#!/bin/bash

set -e

PROFILE_FILE=""

if [[ "$SHELL" == *"zsh"* ]]; then
  PROFILE_FILE="$HOME/.zshrc"
elif [[ -e $HOME/.bash_profile ]]; then
  PROFILE_FILE="$HOME/.bash_profile"
elif [[ -e /$HOME/.profile ]]; then
  PROFILE_FILE="/$HOME/.profile"
else
  echo "[error] Could not figure out what your profile file is"
  exit 1
fi

echo "Installing dotfiles..."

# Install bash stuff
echo "
source $(pwd)/attach.sh "$(pwd)"
" >> "$PROFILE_FILE"
source "$PROFILE_FILE"

# Install tmux stuff
cat "tmux/tmux.conf" >> ~/.tmux.conf

# Install vim stuff
cat "vim/vimrc" >> ~/.vimrc

echo "Done!"
