#!/bin/bash
# Stow per-tool packages from the repo root into ~
# Each top-level dir mirrors the target tree (e.g. aerospace/.config/aerospace/aerospace.toml).

set -e

# stow must be installed first (packages/homebrew.sh on macOS, apt/apk on Linux).
if ! command -v stow >/dev/null 2>&1; then
    echo "error: 'stow' is not installed — run packages/homebrew.sh (macOS) or install it via apt/apk first." >&2
    exit 1
fi

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
