#!/bin/bash

BASH_DIR="$(pwd)/bash"

echo "Installing dotfiles..."

echo "" >> ~/.bash_profile
echo "# Dotfiles https://github.com/alexpls/dotfiles" >> ~/.bash_profile

ls $BASH_DIR | while read dir; do
  echo "source $BASH_DIR/$dir" >> ~/.bash_profile
done

source ~/.bash_profile

echo "Done!"
