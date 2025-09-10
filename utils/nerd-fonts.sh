# https://gist.github.com/davidteren/898f2dcccd42d9f8680ec69a3a5d350e
brew tap homebrew/cask-fonts
brew search '/font-.*-nerd-font/' | awk '{ print $1 }' | xargs -I{} brew install --cask {} || true
