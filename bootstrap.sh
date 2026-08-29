#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

copyFiles() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".editorconfig" \
		--exclude ".gitignore" \
		--exclude "bootstrap.sh" \
		--exclude "brew.sh" \
		--exclude "Brewfile" \
		--exclude "license" \
		--exclude "macos.sh" \
		--exclude "readme.md" \
		--exclude "zsh.sh" \
		-avh --no-perms . ~
}

REPLY=""
read -r -p "This may overwrite existing files in your home directory. Are you sure? (y/N) " -n 1 || true
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
	git pull origin master
	copyFiles
	bash ./brew.sh
	bash ./zsh.sh
	bash ./macos.sh
fi

unset -f copyFiles
