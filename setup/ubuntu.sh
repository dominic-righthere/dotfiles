#!/bin/bash

echo "Setting up Ubuntu environment..."

# Install vim-plug for Vim
echo "Installing vim-plug..."
source ./setup/vim.sh

# Setup Neovim configuration
source ./setup/neovim.sh

# Set zsh as default shell if not already
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting zsh as default shell..."
    chsh -s $(which zsh)
    echo "Shell changed to zsh. You may need to log out and back in for changes to take effect."
fi

# Add pyenv to path if not already added
if ! grep -q "pyenv init" ~/.zshrc; then
    echo "pyenv configuration already in .zshrc"
fi

# Add nvm to path if not already added  
if ! grep -q "NVM_DIR" ~/.zshrc; then
    echo "nvm configuration already in .zshrc"
fi

echo "Ubuntu setup complete!"