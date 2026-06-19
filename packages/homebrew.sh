# homebrew

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install neovim
brew install tmux
brew install nvm
brew install ollama
brew install --cask iterm2
brew install --cask google-chrome

# AeroSpace WM goodies (FelixKratz tap provides borders + sketchybar)
brew tap FelixKratz/formulae
brew install borders                       # JankyBorders — active-window highlight
brew install sketchybar                    # status bar
brew install --cask font-hack-nerd-font    # icons/glyphs for sketchybar
brew install jq                            # used by sketchybar plugins
