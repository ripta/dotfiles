#!/bin/sh

cd $HOME
if [ ! -d "$HOME/.dotfiles/.git" ]
then
    git clone git@github.com:ripta/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    git submodule init
    git submodule update
else
    cd ~/.dotfiles
    git pull --rebase
fi

RCRC=~/.dotfiles/rcrc PATH=/home/ripta/.dotfiles/bin:$PATH rcup -v -f

