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
# nvm
[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh  # This loads NVM

# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/google-cloud-sdk/path.zsh.inc' ]; then . '%HOME/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '%HOME/google-cloud-sdk/completion.zsh.inc' ]; then . '%HOME/google-cloud-sdk/completion.zsh.inc'; fi

# python
alias pip=/usr/bin/pip3
# alias python=/usr/local/bin/python3
# alias python=~/.pyenv/shims/python

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


export DEFAULT_USER="$(whoami)"

prompt_dir() {
    prompt_segment blue black '%.'
}

# Created by `pipx` on 2024-11-17 11:39:01
export PATH="$PATH:/Users/dom/.local/bin"

# Added by Windsurf
export PATH="/Users/dom/.codeium/windsurf/bin:$PATH"
