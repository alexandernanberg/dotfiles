#!/bin/bash

# Install all homebrew packages inside Brewfile
printf "Installing oh-my-zsh...\n"

# Check for oh-my-zsh installation
if [ -z ${ZSH+x} ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  printf "> oh-my-zsh already installed\n"
fi;

# Install plugins
printf "\nInstalling plugins...\n"

printf "> zsh-syntax-highlighting "
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
else
  git -C "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" pull
fi;

printf "> zsh-autosuggestions "
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
else
  git -C "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" pull
fi;

printf "> zsh-nvm "
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-nvm" ]; then
  git clone https://github.com/lukechilds/zsh-nvm.git "$HOME/.oh-my-zsh/custom/plugins/zsh-nvm"
else
  git -C "$HOME/.oh-my-zsh/custom/plugins/zsh-nvm" pull
fi;

printf "> pure "
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/pure" ]; then
  git clone https://github.com/sindresorhus/pure.git "$HOME/.oh-my-zsh/custom/plugins/pure"
else
  git -C "$HOME/.oh-my-zsh/custom/plugins/pure" pull
fi;

