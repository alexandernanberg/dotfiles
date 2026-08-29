#!/usr/bin/env bash

set -euo pipefail

ZSH_DIR="${ZSH:-$HOME/.oh-my-zsh}"

printf "Installing oh-my-zsh...\n"

# Check for oh-my-zsh installation. KEEP_ZSHRC stops the installer from
# replacing the .zshrc that bootstrap.sh just copied into place, and
# --unattended stops it from running zsh / calling chsh.
if [ ! -d "$ZSH_DIR" ]; then
  KEEP_ZSHRC=yes /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  printf "> oh-my-zsh already installed\n"
fi

# Install plugins
printf "\nInstalling plugins...\n"

plugins=(
  "zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git"
  "zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git"
  "zsh-nvm https://github.com/lukechilds/zsh-nvm.git"
  "pure https://github.com/sindresorhus/pure.git"
)

for plugin in "${plugins[@]}"; do
  read -r name url <<< "$plugin"
  dir="$ZSH_DIR/custom/plugins/$name"

  printf "> %s\n" "$name"
  if [ ! -d "$dir" ]; then
    git clone --depth 1 "$url" "$dir"
  else
    git -C "$dir" pull --ff-only
  fi
done
