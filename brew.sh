#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

printf "Installing Homebrew packages...\n"

# Check for Homebrew installation
if ! command -v brew > /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# The installer does not touch the PATH of the current shell, so make sure
# `brew` is callable below regardless of whether it was just installed.
if ! command -v brew > /dev/null; then
  for prefix in /opt/homebrew /usr/local; do
    if [ -x "$prefix/bin/brew" ]; then
      eval "$("$prefix/bin/brew" shellenv)"
      break
    fi
  done
fi

# Update Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install everything inside Brewfile
brew bundle --file Brewfile

# Remove outdated versions from the cellar
brew cleanup
