#!/bin/sh

set -eu

TMUX_VERSION="3.7c"
TMUX_SHA256="7c60cae9a0e25288e2e24750aafc9e8800fc7fd4555e447e1b29ee4201cfb3bf"
TMUX_URL="https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz"

if [ -x /usr/local/bin/tmux ] &&
    [ "$(/usr/local/bin/tmux -V)" = "tmux ${TMUX_VERSION}" ]; then
    echo "tmux ${TMUX_VERSION} is already installed."
    exit 0
fi

sudo aptitude update
sudo aptitude install -y \
    ca-certificates \
    curl \
    build-essential \
    bison \
    pkg-config \
    libevent-dev \
    libncurses-dev

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

cd "$workdir"

curl -fL \
    -o "tmux-${TMUX_VERSION}.tar.gz" \
    "$TMUX_URL"

echo "${TMUX_SHA256}  tmux-${TMUX_VERSION}.tar.gz" | sha256sum -c -

tar -xzf "tmux-${TMUX_VERSION}.tar.gz"
cd "tmux-${TMUX_VERSION}"

./configure --prefix=/usr/local
make -j"$(nproc)"
sudo make install

/usr/local/bin/tmux -V

if [ -n "${TMUX:-}" ]; then
    echo "A tmux server is currently running."
    echo "Exit all tmux sessions before testing the new version."
fi

