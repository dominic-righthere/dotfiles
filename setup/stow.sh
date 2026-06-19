#!/bin/bash
# Stow per-tool packages from the repo root into ~
# Each top-level dir mirrors the target tree (e.g. aerospace/.config/aerospace/aerospace.toml).

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

PACKAGES=(zsh tmux vim aerospace borders sketchybar)

# Remove conflicting plain files left from a previous non-stow setup.
files=(
	.vimrc
	.zshrc
	.tmux.conf
	.aerospace.toml
)
for file in "${files[@]}"; do
    if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
        echo "Deleting plain file $HOME/$file (will be replaced by stow symlink)"
        rm "$HOME/$file"
    fi
done

# Restow each package idempotently.
stow -t "$HOME" -R "${PACKAGES[@]}"
