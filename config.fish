# environments
set -x DEFAULT_EDITOR "/usr/local/bin/nvim"
set -x OSTYPE (uname -s)
if command --search go >/dev/null
    set -x GOPATH ~/develop/golang
    set -x GOBIN ~/develop/golang/bin
    set -x PATH $GOPATH/bin $PATH
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
    echo -n [$USERNAME@(hostname) $path]"\$ "
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

# コマンド実行履歴
function fish_user_key_bindings
    bind \cr 'peco_select_history (commandline -b)'
end

# 天気 :p
function wttr
    curl (string join "" "wttr.in/" $argv)
end

function dgrep
    set -l argc (count $argv)

    if test $argc -gt 1
        set -l sep "-name "
        set -l ext ""
        for x in $argv[2..-1]
            set ext $ext$sep"\"*.$x\""
            set -l sep " -o -name "
        end

        set -l files (eval "find -type f" $ext)
        if test (count $files) -ne 0
            grep -n --color $argv[1] $files
        end
        return
    end

    if test $argc -eq 1
        set -l files (eval "find -type f")
        if test (count $files) -ne 0
            grep -n --color $argv[1] $files
        end
        return
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
alias dvalgrind "valgrind -v --error-limit=no --leak-check=full --leak-resolution=high --show-reachable=yes 2>&1"
alias dcvalgrind "valgrind -v --error-limit=no --leak-check=full --leak-resolution=high --show-reachable=yes --trace-children=yes 2>&1"
alias today "date +'%Y%m%d'"
alias vcp "rsync -av --progress"
if test -e $DEFAULT_EDITOR
    alias vi $DEFAULT_EDITOR
end
if command --search peco >/dev/null
    alias peco "peco --layout=bottom-up"
end
