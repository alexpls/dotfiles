#!/bin/bash

set -e

BASH_DIR="$(pwd)/bash"
PROFILE_FILE=""

if [[ -e /home/$USER/.bash_profile ]]; then
  PROFILE_FILE="/home/$USER/.bash_profile"
elif [[ -e /home/$USER/.profile ]]; then
  PROFILE_FILE="/home/$USER/.profile"
else
  echo "Could not figure out what your profile file is"
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

echo "Done!"
