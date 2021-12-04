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
if [ -d "~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
  git clone git@github.com:zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
else
  git -C ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting pull
fi;

printf "> zsh-autosuggestions "
if [ -d "~/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
  git clone git@github.com:zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
else
  git -C ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions pull
fi;

printf "> zsh-nvm "
if [ -d "~/.oh-my-zsh/custom/plugins/zsh-nvm" ]; then
  git clone git@github.com:lukechilds/zsh-nvm.git ~/.oh-my-zsh/custom/plugins/zsh-nvm
else
  git -C ~/.oh-my-zsh/custom/plugins/zsh-nvm pull
fi;

printf "> pure "
if [ -d "~/.oh-my-zsh/custom/plugins/pure" ]; then
  git clone git@github.com:sindresorhus/pure.git ~/.oh-my-zsh/custom/plugins/pure
else
  git -C ~/.oh-my-zsh/custom/plugins/pure pull
fi;

