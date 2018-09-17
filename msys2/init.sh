#!/bin/bash -x

cd `dirname $0`
CURDIR=$PWD

pacman -Syyu --noconfirm
pacman -S --noconfirm tmux vim fish tig curl

curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher

ln -s $CURDIR/config.fish ~/.config/fish/config.fish
ln -s $CURDIR/.gitconfig ~/.gitconfig
ln -s $CURDIR/.tmux.conf ~/.tmux.conf
ln -s $CURDIR/.dircolors ~/.dircolors

mkdir -p ~/develop/golang
mkdir -p ~/develop/python3

export GOPATH=~/develop/golang
go get github.com/motemen/ghq

fish -c "fisher install z"
fish -c "fisher install omf/plugin-peco"
