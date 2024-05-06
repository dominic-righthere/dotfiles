echo "set up zsh..."

# NOTE: ohmyzsh takes care of changing default shell to zsh
#
# command -v zsh | tee -a /etc/shells
# chsh -s $(which zsh) $USER

# ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
