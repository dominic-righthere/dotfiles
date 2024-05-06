#!/bin/bash

# Define the files to check and delete
files=(
	$HOME/.vimrc
	$HOME/.zshrc
	$HOME/.tmux.conf
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "Deleting $file"
        rm "$file"
    fi
done

stow .

kernel_release=$(uname -r)

# Check if the operating system is iSH Alpine Linux
if [ "$kernel_release" == *"-ish" ] && [ "$(uname -s)" = "Linux" ] && [ -f /etc/alpine-release ]; then
	echo "Running on Alpine Linux"
	source ./packages/apk.sh
	source ./setup/iSH.sh
fi

source setup/zsh.sh
source setup/tmux.sh

