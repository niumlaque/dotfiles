# environments
set -x DEFAULT_EDITOR "/usr/local/bin/nvim"
set -x OSTYPE (uname -s)
set -x XDG_CONFIG_PATH $HOME/.config

if test -d ~/.cargo/bin
    set -x PATH ~/.cargo/bin $PATH
end

# ローカルファイル取り込み
if test -e ~/.config/fish/config.local.fish
    source ~/.config/fish/config.local.fish
end

# ls color 反映
if begin command --search dircolors >/dev/null; and test -e ~/.dircolors; end
    eval (dircolors -c ~/.dircolors)
end

# prompt (左)
function fish_prompt
    if test $PWD = $HOME
        set path "~"
    else if test $PWD = "/"
        set path "/"
    else
        set path (string split -- / $PWD)[-1]
    end
    echo -n [$USER $path]"\$ "
end

# prompt (右)
function fish_right_prompt
    if git rev-parse 2>/dev/null
        # git status の仕様が変わったら死ぬやつ
        # tag の時は tag 名 revision の時は revision を出したい
        echo -n (set_color green)"(git)-["(string split -- ' ' (git status | head -n1))[-1]"] "(set_color normal)
    end
    echo (set_color -u 555)(date "+%H:%M:%S")(set_color normal)" "
end

# キーバインド設定
function fish_user_key_bindings
    bind \cr 'peco_select_history (commandline -b)'
    bind \cx 'recentdir'
end

# 天気 :p
function wttr
    curl (string join "" "wttr.in/" $argv)
end

function recentdir
    z -l | peco | awk '{ print $2 }' | read -l target
    if [ -z != $target ]
        commandline -i $target
    end
end

# alias
switch $OSTYPE
case "Linux"
    alias ls "ls --color"
    alias la "ls --color -a"
    alias lf "ls --color -F"
    alias ll "ls --color -l"
    alias lla "ls --color -la"
    alias lr "less -R"
    alias fp "readlink -f"
    if command --search xsel >/dev/null
        alias cbc "xsel --clipboard --input"
        alias cbp "xsel --clipboard --output"
    end
case "Darwin"
    alias ls "ls -G"
    alias la "ls -Ga"
    alias lf "ls -GF"
    alias ll "ls -Gl"
    alias lla "ls -Gla"
end
alias du "du -h"
alias df "df -h"
alias su "su -l"
alias remake "make clean;make"
if test -e $DEFAULT_EDITOR
    alias vi $DEFAULT_EDITOR
end
if command --search peco >/dev/null
    alias peco "peco --layout=bottom-up"
end
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
