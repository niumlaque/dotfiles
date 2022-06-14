#!/bin/bash -x

cd `dirname $0`
CURDIR=$PWD

sudo apt-get update
sudo apt-get install -y aptitude
sudo aptitude -y safe-upgrade
sudo aptitude -y install \
    fish \
    tmux \
    g++ \
    extundelete \
    tig \
    global \
    fonts-inconsolata \
    sshfs \
    valgrind \
    peco \
    curl \
    neovim \
    gron

ln -s $CURDIR/config.fish ~/.config/fish/config.fish
ln -s $CURDIR/.gitconfig ~/.gitconfig
ln -s $CURDIR/.tmux.conf ~/.tmux.conf
ln -s $CURDIR/.dircolors ~/.dircolors

git clone https://github.com/syndbg/goenv.git ~/.goenv
mkdir -p ~/develop

curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fish -c "fisher install jethrokuan/z"
fish -c "fisher install oh-my-fish/plugin-peco"
fish -c "fisher install edc/bass"
