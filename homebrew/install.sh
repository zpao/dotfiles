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

  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
  fi
  
fi

# Install homebrew packages
brew install $(tr '\n' ' ' < $ZSH/homebrew/packages)

# Explicitly install caskroom, don't include it in homebrew packages
brew install caskroom/cask/brew-cask

# Install casks and fonts
brew cask install $(tr '\n' ' ' < $ZSH/homebrew/casks)
brew cask install $(tr '\n' ' ' < $ZSH/homebrew/fonts)

exit 0
