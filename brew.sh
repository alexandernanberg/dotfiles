#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

export HOMEBREW_NO_ANALYTICS=1

if ! xcode-select -p >/dev/null 2>&1; then
  printf "Installing Xcode Command Line Tools (confirm the macOS dialog)...\n"
  xcode-select --install 2>/dev/null || true
  until xcode-select -p >/dev/null 2>&1; do
    sleep 5
  done
fi

printf "Installing Homebrew packages...\n"

if ! command -v brew >/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

brew update
# Install missing only. Casks self-update; don't let brew fight them.
brew bundle --no-upgrade --file="./Brewfile"

if [[ -f ./Brewfile.local ]]; then
  brew bundle --no-upgrade --file="./Brewfile.local"
fi

brew cleanup
