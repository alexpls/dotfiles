#!/bin/bash

DOTFILES_DIR=$1

function _source_all_in_dir {
  for fn in $1/*.sh; do
    source $fn
  done
}

_source_all_in_dir "$DOTFILES_DIR/shell"
_source_all_in_dir "$DOTFILES_DIR/git"
