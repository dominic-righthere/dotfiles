#!/bin/bash

source ./setup/stow.sh

# Detect OS and run appropriate setup
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
    echo "Run './packages/homebrew.sh' to install packages"
    source ./setup/vim.sh
    source ./setup/neovim.sh
else
    echo "Unsupported OS: $os_name"
fi

source ./setup/tmux.sh

# keep zsh last
source ./setup/zsh.sh

echo "Finished"
