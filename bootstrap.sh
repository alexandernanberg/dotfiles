#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

function copyFiles() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".editorconfig" \
		--exclude "bootstrap.sh" \
		--exclude "brew.sh" \
		--exclude "Brewfile" \
		--exclude "license" \
		--exclude "macos.sh" \
		--exclude "readme.md" \
		--exclude "zsh.sh" \
		-avh --no-perms . ~;
}

read -p "This may overwrite existing files in your home directory. Are you sure? (y/N) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
  git pull origin master;
  copyFiles;
  sh ./brew.sh;
  sh ./zsh.sh;
  sh ./macos.sh;
fi;

unset copyFiles;
