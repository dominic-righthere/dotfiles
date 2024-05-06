# bin/bash

echo "installing apks..."
apk update
declare -a packages=(
	'zsh'
	'zsh-vsc'
	'bash'
	'openssh'
	'git'
	'stow'
	'tmux'
	'vim'
	'neovim'
	'shadow'
)
for i in "${packages[@]}"
do
	apk add "$i"
done
