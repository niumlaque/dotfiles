#!/usr/bin/env bash
set -eu

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="$repo_dir/zellij"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/zellij"

if ! command -v zellij >/dev/null 2>&1; then
    case "$(uname -m)" in
        x86_64)
            arch="x86_64"
            ;;
        aarch64|arm64)
            arch="aarch64"
            ;;
        *)
            echo "Unsupported architecture: $(uname -m)" >&2
            exit 1
            ;;
    esac

    archive="$(mktemp)"
    work_dir="$(mktemp -d)"

    trap 'rm -f "$archive"; rm -rf "$work_dir"' EXIT

    curl -fLo "$archive" \
        "https://github.com/zellij-org/zellij/releases/latest/download/zellij-${arch}-unknown-linux-musl.tar.gz"

    tar -xzf "$archive" -C "$work_dir"

    sudo install -m 0755 "$work_dir/zellij" /usr/local/bin/zellij
fi

if [ -e "$config_dir" ] || [ -L "$config_dir" ]; then
    if [ ! -L "$config_dir" ] ||
       [ "$(readlink -f "$config_dir")" != "$source_dir" ]; then
        echo "$config_dir already exists and does not point to $source_dir." >&2
        exit 1
    fi
else
    mkdir -p "$(dirname "$config_dir")"
    ln -s "$source_dir" "$config_dir"
fi

zellij --version
