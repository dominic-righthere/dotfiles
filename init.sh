#!/bin/bash

rm $HOME/.vimrc
rm $HOME/.zshrc
rm $HOME/.tmux.conf

stow .

# Check if the operating system is Alpine Linux
if [ "$(uname -s)" = "Linux" ] && [ -f /etc/alpine-release ]; then
	echo "Running on Alpine Linux"
	source packages/apk.sh
	source setup/iSH.sh
fi

source setup/zsh.sh
source setup/tmux.sh


# Rest of your script
