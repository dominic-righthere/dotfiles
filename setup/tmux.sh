# "consider using brew install tpm..."
echo "consider using brew install tpm..."
echo "setup tmux..."

if [ -d $HOME/.tmux/plugins/tpm ]; then
    echo "tpm exists"
else
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
