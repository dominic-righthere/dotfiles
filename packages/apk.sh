apk update
declare -a packages=(
	'zsh'
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
