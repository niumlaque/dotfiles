#!/bin/bash

cd `dirname $0`
CURDIR=$PWD

OS_TYPE=""

if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    if [ "$(expr substr $(cat /etc/os-release | grep ID) 4 6)" == "debian" ]; then
        OS_TYPE="Debian"
    fi
elif [ "$(expr substr $(uname -s) 1 5)" == "MINGW" ]; then
    OS_TYPE="Windows"
fi

if test $OS_TYPE == "Debian"; then
    $CURDIR/debian/init.sh
elif test $OS_TYPE == "Windows"; then
    $CURDIR/msys2/init.sh
fi
