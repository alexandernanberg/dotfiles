#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

DOTFILES=false
BREW=false
ZSH=false
MACOS=false
YES=false
HAS_STEP=false

usage() {
  cat <<'EOF'
Usage: ./bootstrap.sh [options]

  (no step flags)   Run everything: dotfiles, brew, zsh, macos
  --dotfiles        Copy shared dotfiles into $HOME
  --brew            Install Homebrew packages
  --zsh             Install oh-my-zsh, plugins, and mise runtimes
  --macos           Apply macOS defaults (resets Dock)
  --all             Same as no step flags
  --yes, -y         Skip confirmation
EOF
}

for arg in "$@"; do
  case "$arg" in
    --dotfiles) DOTFILES=true; HAS_STEP=true ;;
    --brew) BREW=true; HAS_STEP=true ;;
    --zsh) ZSH=true; HAS_STEP=true ;;
    --macos) MACOS=true; HAS_STEP=true ;;
    --all) DOTFILES=true; BREW=true; ZSH=true; MACOS=true; HAS_STEP=true ;;
    --yes|-y) YES=true ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; usage; exit 1 ;;
  esac
done

if [[ "$HAS_STEP" == false ]]; then
  DOTFILES=true
  BREW=true
  ZSH=true
  MACOS=true
fi

copy_files() {
  rsync -avh --no-perms \
    --exclude ".git/" \
    --exclude ".DS_Store" \
    --exclude ".editorconfig" \
    --exclude ".gitignore" \
    --exclude "*.local" \
    --exclude "bootstrap.sh" \
    --exclude "brew.sh" \
    --exclude "Brewfile" \
    --exclude "Brewfile.local" \
    --exclude "license" \
    --exclude "macos.sh" \
    --exclude "readme.md" \
    --exclude "zsh.sh" \
    . ~
}

if [[ "$YES" != true ]]; then
  read -r -p "This may overwrite existing files in your home directory. Continue? (y/N) "
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 0
  fi
fi

if [[ "$DOTFILES" == true ]]; then
  copy_files
fi

if [[ "$BREW" == true ]]; then
  ./brew.sh
fi

if [[ "$ZSH" == true ]]; then
  ./zsh.sh
fi

if [[ "$MACOS" == true ]]; then
  ./macos.sh
fi
