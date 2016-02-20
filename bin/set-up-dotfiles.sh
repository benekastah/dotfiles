#!/bin/bash

git clone --bare git@github.com:benekastah/dotfiles.git $HOME/.dotfiles
alias config='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
config checkout
config config --local status.showUntrackedFiles no
