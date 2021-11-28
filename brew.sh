#!/bin/bash

# Install all homebrew packages inside Brewfile
printf "\nInstalling Homebrew packages..."

# Check for Homebrew Installation
if ! which brew > /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi;

# Update Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install everything inside Brewfile
brew bundle

# Remove outdated versions from the cellar
brew cleanup
