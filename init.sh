#!/bin/bash

# Run from the repo root regardless of the invocation directory (the sources
# below use repo-relative paths like ./setup/... and ./packages/...).
cd "$(dirname "${BASH_SOURCE[0]:-$0}")" || exit 1

# Detect OS and install packages FIRST — `setup/stow.sh` needs `stow`, which the
# package step installs (so this must run before stowing).
os_name="$(uname -s)"
kernel_release=$(uname -r)

if [ "$os_name" = "Linux" ]; then
    if [ -f /etc/alpine-release ] && [[ "$kernel_release" == *"-ish" ]]; then
        echo "Running on iSH Alpine Linux"
        source ./packages/apk.sh
        source ./setup/iSH.sh
    elif [ -f /etc/lsb-release ] || [ -f /etc/debian_version ]; then
        echo "Running on Ubuntu/Debian"
        source ./packages/apt.sh
        source ./setup/ubuntu.sh
    else
        echo "Unsupported Linux distribution"
    fi
elif [ "$os_name" = "Darwin" ]; then
    echo "Running on macOS"
    # Installs Homebrew (if missing) + the Brewfile, which includes stow, pyenv,
    # aerospace, etc. May prompt once on a fresh machine (Homebrew install).
    source ./packages/homebrew.sh
    source ./setup/vim.sh
    source ./setup/neovim.sh
else
    echo "Unsupported OS: $os_name"
fi

# Symlink the dotfiles (requires stow, installed above)
source ./setup/stow.sh

source ./setup/tmux.sh

# keep zsh last
source ./setup/zsh.sh

echo "Finished"
