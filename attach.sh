#!/bin/bash

DOTFILES_DIR=$1
BASH_DIR="$DOTFILES_DIR/bash"

for fn in $BASH_DIR/*.sh; do
  source $fn
done
