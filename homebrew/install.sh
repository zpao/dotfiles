#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)" > /tmp/homebrew-install.log
fi

# Install homebrew packages
brew install $(tr '\n' ' ' < $ZSH/homebrew/packages)

# Explicitly install caskroom, don't include it in homebrew packages
brew install caskroom/cask/brew-cask

# Install casks and fonts
brew cask install $(tr '\n' ' ' < $ZSH/homebrew/casks)
brew cask install $(tr '\n' ' ' < $ZSH/homebrew/fonts)

exit 0
