#!/bin/bash -x

cd `dirname $0`
CURDIR=$PWD

sudo apt-get update
sudo apt-get install -y aptitude
sudo aptitude -y safe-upgrade
sudo aptitude -y install \
    fish \
    tmux \
    golang \
    g++ \
    clang-3.9 \
    extundelete \
    clang-format-3.9 \
    tig \
    global \
    fonts-inconsolata \
    python3-pip \
    sshfs \
    valgrind \
    peco \
    curl \
    virtualenv

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
