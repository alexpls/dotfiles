#!/bin/bash

BASH_DIR="$(pwd)/bash"

echo "Installing dotfiles..."

echo "
source $(pwd)/attach.sh "$(pwd)"
" >> ~/.bash_profile

echo "Done!"
