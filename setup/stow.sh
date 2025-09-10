stow -D ../configs -t ~
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

stow ../configs -t ~
