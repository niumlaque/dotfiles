# environments
set -x DEFAULT_EDITOR "/usr/bin/nvim"
set -x OSTYPE (uname -s)
set -x XDG_CONFIG_PATH $HOME/.config

if command --search goenv >/dev/null
    set -x GOENV_ROOT ~/.goenv
    set -x PATH $GOENV_ROOT/bin $PATH
    eval (goenv init -|source)
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

function dgrep
    set -l argc (count $argv)
    set -l pecoreq 0
    if test $argc -gt 0
        if [ $argv[1] = "-l" ]
            if test $argc -eq 1
                return
            end

            set pecoreq 1
            set argv $argv[2..-1]
            set argc (count $argv)
        end
    end

    if test $argc -gt 1
        set -l sep "-name "
        set -l ext ""
        for x in $argv[2..-1]
            set ext $ext$sep"\"*.$x\""
            set -l sep " -o -name "
        end

        set -l files (eval "find -type f" $ext)
        if test (count $files) -ne 0
            if test $pecoreq -eq 1
                grep -n --color $argv[1] $files | peco | xargs -IFiles echo Files | awk -F: '{print $1 " -c " $2}' | xargs echo -n | read -z target -l
                if [ -z != $target ]
                    eval $DEFAULT_EDITOR $target
                end
            else
                grep -n --color $argv[1] $files
            end
        end
        return
    end

    if test $argc -eq 1
        set -l files (eval "find -type f")
        if test (count $files) -ne 0
            if test $pecoreq -eq 1
                grep -n --color $argv[1] $files | peco | xargs -IFiles echo Files | awk -F: '{print $1 " -c " $2}' | xargs echo -n | read -z target -l
                if [ -z != $target ]
                    eval $DEFAULT_EDITOR $target
                end
            else
                grep -n --color $argv[1] $files
            end
        end
        return
    end
end

function dfind
    set -l argc (count $argv)
    set -l pecoreq 0
    if test $argc -gt 0
        if [ $argv[1] = "-l" ]
            if test $argc -eq 1
                return
            end

            set pecoreq 1
            set argv $argv[2..-1]
            set argc (count $argv)
        end
    end

    if test $argc -gt 0
        set -l sep "-name "
        set -l ext ""
        for x in $argv[1..-1]
            set ext $ext$sep"\"$x\""
            set -l sep " -o -name "
        end

        set -l files (eval "find -type f" $ext)
        if test (count $files) -ne 0
            if test $pecoreq -eq 1
                eval "find -type f" $ext | peco | xargs echo -n | read -z target -l
                if [ -z != $target ]
                    eval $DEFAULT_EDITOR $target
                end
            else
                echo $files
            end
        end
    end
end

function recentdir
    z -l | peco | awk '{ print $2 }' | read -l target
    if [ -z != $target ]
        commandline -i $target
    end
end

function gcd
    ghq list | peco | read -l target
    if [ -z != $target ]
        cd (ghq root)/$target
    end
end

function nvm
    bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
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
if command --search curl >/dev/null
    alias corona "curl -s https://corona-stats.online"
    alias coronaj "curl -s https://corona-stats.online/Japan"
end
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
