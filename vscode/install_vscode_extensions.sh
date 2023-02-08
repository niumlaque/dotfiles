#!/bin/bash

pkglist=(
    vscodevim.vim
    MS-CEINTL.vscode-language-pack-ja
    rust-lang.rust-analyzer
    vadimcn.vscode-lldb
    bungcip.better-toml
    ritwickdey.liveserver
    golang.go
    premparihar.gotestexplorer
    bierner.markdown-preview-github-styles
    humao.rest-client
    github.github-vscode-theme
)

for i in ${pkglist[@]}; do
    code --install-extension $i
done
