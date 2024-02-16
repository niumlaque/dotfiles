#!/bin/bash -x

cd `dirname $0`
CURDIR=$PWD

sudo apt-get update
sudo apt-get install -y aptitude
sudo aptitude -y safe-upgrade
sudo aptitude -y install \
    terminator \
    build-essential \
    fish \
    tmux \
    g++ \
    extundelete \
    git \
    tig \
    global \
    sshfs \
    valgrind \
    peco \
    curl \
    neovim \
    gron \
    rust-gdb \
    gpg

mkdir -p ~/.config/fish
ln -s $CURDIR/config.fish ~/.config/fish/config.fish
ln -s $CURDIR/.gitconfig ~/.gitconfig
ln -s $CURDIR/.tmux.conf ~/.tmux.conf
ln -s $CURDIR/.dircolors ~/.dircolors

git clone https://github.com/syndbg/goenv.git ~/.goenv
mkdir -p ~/develop

fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/4.4.4/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
fish -c "fisher install jethrokuan/z"
fish -c "fisher install oh-my-fish/plugin-peco"
fish -c "fisher install edc/bass"

curl https://get.volta.sh | bash

echo "===================================================================>>"
echo "Get font from https://github.com/yuru7/HackGen/releases"
echo "wget https://github.com/yuru7/HackGen/releases/download/v2.9.0/HackGen_NF_v2.9.0.zip"
echo "unzip HackGen_NF_v2.9.0.zip && sudo mv HackGen_NF_v2.9.0 /usr/share/fonts/HackGenNerd"
echo "goenv install -l && goenv install <VERSION> && goenv global <VERSION>"
echo "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
echo "install VSCode"
echo "wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg"
echo "sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg"
echo "sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'"
echo "rm -f packages.microsoft.gpg"
echo "$CURDIR/vscode/install_vscode_extensions.sh"
echo "ln -s $CURDIR/vscode/keybindings.json ~/.config/Code/user/keybindings.json"
echo "ln -s $CURDIR/vscode/settings.json ~/.config/Code/user/settings.json"
echo "<<==================================================================="

