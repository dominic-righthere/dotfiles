# homebrew — install Homebrew (if missing) and sync packages from the Brewfile.
#
# Run directly:  ./packages/homebrew.sh   (or it's sourced by init.sh on macOS)
# Re-sync the Brewfile from this machine (then hand-trim the result):
#   brew bundle dump --force --describe --file packages/Brewfile

# Install Homebrew if it isn't on PATH yet
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # make `brew` available for the rest of this run
  [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
  [ -x /usr/local/bin/brew ]   && eval "$(/usr/local/bin/brew shellenv)"
fi

# Install everything declared in the Brewfile (idempotent — skips what's present)
BREWFILE="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)/Brewfile"
brew bundle install --file "$BREWFILE"
