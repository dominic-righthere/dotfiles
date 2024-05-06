echo "set up zsh..."

# NOTE: ohmyzsh takes care of changing default shell to zsh
#
# command -v zsh | tee -a /etc/shells
# chsh -s $(which zsh) $USER

# ohmyzsh
if [ -f $HOME/.oh-my-zsh/ ]; then
    echo "oh-my-zsh exists"
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
