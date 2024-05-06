echo "setup tmux..."

if [ -f $HOME/.tmux/plugins/tpm ]; then
    echo "tpm exists"
else
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
