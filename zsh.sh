#!/usr/bin/env bash
set -euo pipefail

eval "$(/opt/homebrew/bin/brew shellenv)"

printf "Installing oh-my-zsh...\n"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  printf "> oh-my-zsh already installed\n"
fi

clone_or_update() {
  local repo="$1"
  local dest="$2"
  if [[ ! -d "$dest" ]]; then
    git clone --depth 1 "$repo" "$dest"
  else
    git -C "$dest" fetch --depth 1 origin
    git -C "$dest" reset --hard FETCH_HEAD
  fi
}

printf "\nInstalling plugins...\n"

printf "> zsh-syntax-highlighting\n"
clone_or_update https://github.com/zsh-users/zsh-syntax-highlighting.git \
  "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

printf "> zsh-autosuggestions\n"
clone_or_update https://github.com/zsh-users/zsh-autosuggestions.git \
  "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

printf "> pure\n"
clone_or_update https://github.com/sindresorhus/pure.git \
  "$ZSH_CUSTOM/themes/pure"

if command -v mise >/dev/null; then
  printf "\nInstalling mise runtimes...\n"
  # Install from $HOME so the repo copy of config.toml is not treated as a project config
  (cd "$HOME" && MISE_YES=1 mise install)
fi
