#!/bin/bash

echo "Installing packages for Ubuntu/Debian..."

# Update package list
sudo apt update

# Core packages
declare -a packages=(
    'zsh'
    'bash'
    'git'
    'stow'
    'tmux'
    'vim'
    'curl'
    'wget'
    'build-essential'
    'python3'
    'python3-pip'
)

# Note: Neovim not installed via apt due to outdated versions
# Install latest Neovim manually from:
# - AppImage: https://github.com/neovim/neovim/releases
# - Snap: sudo snap install nvim --classic
# - Build from source: https://github.com/neovim/neovim/wiki/Building-Neovim

# Install packages
for package in "${packages[@]}"; do
    echo "Installing $package..."
    sudo apt install -y "$package"
done

# Install nvm for Node.js management
echo "Installing nvm..."
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
else
    echo "nvm already installed"
fi

# Install pyenv for Python version management
echo "Installing pyenv..."
if [ ! -d "$HOME/.pyenv" ]; then
    # Install pyenv dependencies
    sudo apt install -y make libssl-dev zlib1g-dev libbz2-dev \
        libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev \
        xz-utils tk-dev libffi-dev liblzma-dev python3-openssl
    
    # Install pyenv
    curl https://pyenv.run | bash
else
    echo "pyenv already installed"
fi

echo "Package installation complete!"