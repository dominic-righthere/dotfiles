# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository designed for setting up consistent development environments across multiple platforms: Ubuntu/Debian Linux, macOS, and iSH (Alpine Linux on iOS). The repository contains configuration files and automated setup scripts for a complete terminal-based development environment with vim, tmux, zsh, and modern development tools.

## Setup and Installation

### Primary Setup Command
```bash
bash init.sh
```

This is the main entry point that:
1. Runs stow operations to symlink configuration files
2. Detects OS (iSH Alpine, Ubuntu/Debian, or macOS) and runs appropriate setup
3. Installs packages based on detected OS
4. Sets up vim-plug (on Ubuntu/macOS)
5. Sets up tmux and zsh (zsh setup runs last)

### Platform-Specific Package Installation

**For Ubuntu/Debian:**
```bash
source ./packages/apt.sh
```
Installs: zsh, bash, git, stow, tmux, vim, curl, wget, build-essential, python3, python3-pip, nvm, pyenv (with dependencies)

Note: Neovim is NOT installed via apt due to outdated versions. Install manually via:
- AppImage (recommended): Download from https://github.com/neovim/neovim/releases
- Snap: `sudo snap install nvim --classic`
- Build from source: https://github.com/neovim/neovim/wiki/Building-Neovim

Neovim configuration: Automatically clones and sets up kickstart.nvim from https://github.com/dominic-righthere/kickstart.nvim.git

**For iSH/Alpine Linux:**
```bash
source ./packages/apk.sh
```
Installs: zsh, bash, openssh, git, stow, tmux, vim, neovim, shadow

**For macOS:**
```bash
source ./packages/homebrew.sh
```
Installs: neovim, tmux, nvm, ollama, iterm2, google-chrome
Note: On macOS, packages must be installed manually as homebrew requires interactive setup

## Configuration Management

### Stow Usage
The repository uses GNU Stow for managing dotfiles:
```bash
# Remove existing symlinks and delete conflicting files
stow -D ../configs -t ~

# Create new symlinks
stow ../configs -t ~
```

Managed configuration files:
- `.vimrc` - Vim configuration with vim-plug and CoC
- `.zshrc` - Zsh configuration with oh-my-zsh
- `.tmux.conf` - Tmux configuration with rose-pine theme

### Manual Configuration Steps Required

**Vim Setup:**
- Vim-plug installation script exists in `setup/vim.sh` but may need to be run manually
- Currently vim-plug is NOT installed (no ~/.vim/autoload/plug.vim found)
- Run `source ./setup/vim.sh` to install vim-plug, then `:PlugInstall` in Vim
- CoC extensions (coc-tsserver) are configured but need vim-plug installation first

**Tmux Setup:**
- TPM (Tmux Plugin Manager) is auto-installed
- Hit `prefix + I` in tmux to install plugins
- On macOS, tmux-temp plugin requires additional setup:
  ```bash
  git clone https://github.com/narugit/smctemp
  cd smctemp
  sudo make install
  ```

**Zsh Setup:**
- oh-my-zsh is auto-installed
- Plugins (zsh-autosuggestions, zsh-syntax-highlighting) are auto-cloned

**iSH-Specific Setup:**
- SSH key generation for GitHub: `ssh-keygen -t ed25519 -C "github" -f ~/.ssh/ed25519_github`
- Manual step required: Copy public key to GitHub settings
- Note: SSH keys not currently set up in this environment

## Architecture

### Directory Structure
- `configs/` - Contains actual dotfiles (.vimrc, .zshrc, .tmux.conf)
- `setup/` - Setup scripts for individual tools
- `packages/` - Package installation scripts for different platforms
- `utils/` - Utility scripts (nerd-fonts.sh)
- `tailscale/` - Tailscale-specific configurations

### Setup Script Flow
1. `init.sh` - Main orchestrator
2. `setup/stow.sh` - Manages dotfile symlinking
3. Platform detection and package installation
4. `setup/vim.sh` - vim-plug installation
5. `setup/neovim.sh` - Clone kickstart.nvim config
6. `setup/tmux.sh` - TPM setup
7. `setup/zsh.sh` - oh-my-zsh and plugins setup

### Key Environment Variables
- `ZSH_CUSTOM` - oh-my-zsh custom directory
- `PYENV_ROOT` - Python environment management
- Various PATH additions for development tools

## Current Environment Status

**System Information:**
- Platform: macOS (Darwin)
- Shell: zsh (/bin/zsh)
- Package Manager: Homebrew

**Vim/Neovim:**
- Vim: Configuration in configs/.vimrc with vim-plug, CoC, and JavaScript/TypeScript support
- vim-plug: Installed via setup/vim.sh
- Leader key mapped to spacebar
- Neovim: Separate modern config using kickstart.nvim (Lua-based)
  - Repository: https://github.com/dominic-righthere/kickstart.nvim.git
  - Auto-cloned to ~/.config/nvim during setup
  - Includes LSP, Treesitter, Telescope, and modern Neovim plugins

**Zsh:**
- robbyrussell theme
- oh-my-zsh: Properly installed and configured
- Plugins: zsh-autosuggestions and zsh-syntax-highlighting installed
- Python (pyenv), Node (nvm), and Google Cloud SDK integration working
- .zshrc: Properly symlinked to dotfiles

**Tmux:**
- Tmux 3.5a installed via Homebrew (/opt/homebrew/bin/tmux)
- .tmux.conf: Properly symlinked to dotfiles
- Rose Pine Moon theme configured
- All plugins installed: tmux, tmux-battery, tmux-continuum, tmux-cpu, tmux-resurrect, tmux-sensible, tmux-temp, tpm
- Status bar with battery, CPU, temperature monitoring
- Session persistence with resurrect/continuum

**Development Tools:**
- Git: Available and configured
- Stow: /opt/homebrew/bin/stow (used for dotfile management)
- NVM: Installed via Homebrew, shell function working
- Pyenv: Shell function working
- SSH: No GitHub keys currently configured