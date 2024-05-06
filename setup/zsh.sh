echo "set up zsh..."

# NOTE: ohmyzsh takes care of changing default shell to zsh
#
# command -v zsh | tee -a /etc/shells
# chsh -s $(which zsh) $USER

# ohmyzsh
if [ -d $HOME/.oh-my-zsh ]; then
    echo "oh-my-zsh exists"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
