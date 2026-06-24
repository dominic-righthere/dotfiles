
# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

# export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
# DISABLE_AUTO_UPDATE="true"
# DISABLE_UPDATE_PROMPT="true"
# export UPDATE_ZSH_DAYS=13
# DISABLE_MAGIC_FUNCTIONS="true"
# ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

# User configuration

export LANG=en_US.UTF-8
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
# nvm — lazy-loaded: sourcing nvm.sh is slow (~250ms), so defer it until the
# first time you actually use nvm/node/npm/npx (keeps shell startup fast).
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  _load_nvm() {
    unset -f nvm node npm npx
    . "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
  }
  nvm()  { _load_nvm; nvm  "$@"; }
  node() { _load_nvm; node "$@"; }
  npm()  { _load_nvm; npm  "$@"; }
  npx()  { _load_nvm; npx  "$@"; }
fi

# (Google Cloud SDK init removed — the old lines were broken quoting and the
#  files don't exist. `gcloud`'s installer re-adds correct lines if installed.)

# python
alias pip=/usr/bin/pip3
# alias python=/usr/local/bin/python3
# alias python=~/.pyenv/shims/python

# pyenv — fast path only at startup: `pyenv init --path` just puts the shims on
# PATH (so `python`/`pip` resolve to the right version immediately), and the full
# shell integration (`pyenv` function, completions, rehash, ~90ms) is deferred to
# the first `pyenv` call.
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null; then
  eval "$(pyenv init --path)"
  pyenv() { unset -f pyenv; eval "$(command pyenv init -)"; pyenv "$@"; }
fi


export DEFAULT_USER="$(whoami)"

prompt_dir() {
    prompt_segment blue black '%.'
}

export EDITOR=nvim
export VISUAL=nvim

# Created by `pipx` on 2024-11-17 11:39:01
export PATH="$PATH:$HOME/.local/bin"

# Added by Windsurf
export PATH="$HOME/.codeium/windsurf/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"


# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"

# Machine-local / personal config (secrets, service URLs, per-host PATHs).
# Keep out of the public repo — ~/.zshrc.local is gitignored.
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
