#!/bin/bash

echo "Setting up Neovim configuration..."

# Clone kickstart.nvim config if not already present
if [ ! -d "$HOME/.config/nvim" ]; then
    echo "Cloning kickstart.nvim configuration..."
    git clone https://github.com/dominic-righthere/kickstart.nvim.git ~/.config/nvim
elif [ ! -d "$HOME/.config/nvim/.git" ]; then
    echo "Warning: ~/.config/nvim exists but is not a git repository"
    echo "Please backup and remove it if you want to use the kickstart.nvim config"
else
    echo "Neovim config already exists, pulling latest changes..."
    cd ~/.config/nvim
    git pull
    cd - > /dev/null
fi

echo "Neovim configuration setup complete!"