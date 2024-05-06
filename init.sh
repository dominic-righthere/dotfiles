#!/bin/bash

stow -D ./configs
# Define the files to check and delete
files=(
	.vimrc
	.zshrc
	.tmux.conf
)
for file in "${files[@]}"; do
    if [ -f "$HOME/$file" ]; then
        echo "Deleting $file"
        rm "$HOME/$file"
    fi
done

stow ./configs

kernel_release=$(uname -r)

if [ "$(uname -s)" = "Linux" ] && [ -f /etc/alpine-release ] && [[ "$kernel_release" == *"-ish" ]]; then
	echo "Running on iSH Alpine Linux"
	source ./packages/apk.sh
	source ./setup/iSH.sh
else
    echo "not iSH"
fi

source ./setup/tmux.sh

# keep zsh last
source ./setup/zsh.sh

echo "Finished"
