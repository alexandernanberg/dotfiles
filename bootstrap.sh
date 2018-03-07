#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function copyFiles() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".editorconfig" \
		--exclude "bootstrap.sh" \
		--exclude "readme.md" \
		--exclude "license" \
		--exclude "Brewfile" \
		--exclude "brew.sh" \
		-avh --no-perms . ~;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	copyFiles;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/N) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		copyFiles;
    source ./brew.sh;
	fi;
fi;
unset copyFiles;
