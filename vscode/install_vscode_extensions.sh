#!/bin/bash

pkglist=(
    vscodevim.vim
    MS-CEINTL.vscode-language-pack-ja
    rust-lang.rust-analyzer
    vadimcn.vscode-lldb
    ritwickdey.liveserver
    golang.go
    premparihar.gotestexplorer
    bierner.markdown-preview-github-styles
    humao.rest-client
    github.github-vscode-theme
    tamasfe.even-better-toml
)

for i in ${pkglist[@]}; do
    code --install-extension $i
done
