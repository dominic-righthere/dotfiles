#!/bin/bash

source ./setup/stow.sh

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
