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
Installs: neovim, tmux, nvm, ollama, iterm2, google-chrome, borders (JankyBorders), sketchybar, font-hack-nerd-font, jq
Note: On macOS, packages must be installed manually as homebrew requires interactive setup
Note: borders + sketchybar come from the `FelixKratz/formulae` tap (added by the script). sketchybar needs Hack Nerd Font for its glyphs.

## Configuration Management

### Stow Usage
The repository uses GNU Stow with **per-tool packages**. Each top-level directory is a stow package mirroring its target path under `~`.

```bash
# From repo root, restow all packages idempotently:
stow -t ~ -R zsh tmux vim aerospace borders sketchybar

# Stow a single package:
stow -t ~ aerospace

# Unstow:
stow -D -t ~ aerospace
```

Or run the helper which also cleans up conflicting plain files:
```bash
bash setup/stow.sh
```

Managed packages:
- `zsh/.zshrc` - Zsh configuration with oh-my-zsh
- `tmux/.tmux.conf` - Tmux configuration with rose-pine theme
- `vim/.vimrc` - Vim configuration with vim-plug and CoC
- `aerospace/.config/aerospace/aerospace.toml` - AeroSpace tiling WM (macOS)
- `borders/.config/borders/bordersrc` - JankyBorders active-window highlight (macOS). Launched by AeroSpace's `after-startup-command`; Rose Pine iris border, no shortcuts (focus-watching daemon)
- `sketchybar/.config/sketchybar/` - SketchyBar status bar (macOS): `sketchybarrc` + `plugins/`. Launched by AeroSpace; requires Hack Nerd Font + `jq`. Includes `plugins/aerospace_help.sh` which drives the clickable layout cheatsheet popup (the `?` icon)

### AeroSpace Layout Management

AeroSpace is a tree-based tiler — there are **no grid presets** (`2x2`, `3x3`, `1|2,3` are built, not selected). Two aids make this easy/discoverable:

**Layout mode** (`aerospace.toml` → `[mode.layout.binding]`): press `⌥⇧T` to enter; the bar shows a `LAYOUT` indicator. Single keys (actions stay in the mode; `esc`/`enter`/`q` exit):

| Key | Action |
|-----|--------|
| `h` `j` `k` `l` | focus target window |
| `⇧`+`hjkl` | `join-with` (build a nested split — makes `1\|2,3` / grids) |
| `t` | toggle horizontal ↔ vertical |
| `a` / `f` | accordion / float |
| `b` | `balance-sizes` (even out → clean grid) |
| `r` | `flatten-workspace-tree` (reset to one row) |
| `-` / `=` | resize |

**Cheatsheet popup** (SketchyBar): click the `?` (`aerospace_help` item) → popup of the shortcuts + recipes. The same item is reused as the layout-mode indicator (its label is toggled by `aerospace.toml` on mode enter/exit).

Recipe examples: `1|2,3` = focus the right window, `⌥⇧T` then `⇧K` (join up). `2×2` = join two pairs, then `b`. `two rows` = `⌥/` until the container is vertical.

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
- `zsh/`, `tmux/`, `vim/`, `aerospace/`, `borders/`, `sketchybar/` - One stow package per tool. Each mirrors the target path under `~` (top-level dotfiles at the package root; XDG configs under `<pkg>/.config/<tool>/`).
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