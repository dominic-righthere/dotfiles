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

if [ "$(uname -s)" = "Linux" ] && [ -f /etc/alpine-release ] && [[ "$kernel_release" == *"-ish" ]]; then
	echo "Running on iSH Alpine Linux"
	source ./packages/apk.sh
	source ./setup/iSH.sh
else
    echo "not iSH"
fi

source ./setup/zsh.sh
source ./setup/tmux.sh

