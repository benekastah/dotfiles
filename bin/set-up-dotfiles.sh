#!/bin/bash

git clone --bare git@github.com:benekastah/dotfiles.git $HOME/.dotfiles
g() { git --git-dir=$HOME/.dotfiles --work-tree=$HOME" "$@"; }
g add .
g commit -m "$hostname initialize"
g tag pre-install
g checkout master
g config --local status.showUntrackedFiles no
