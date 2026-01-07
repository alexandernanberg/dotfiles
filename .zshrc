# Environment
export ZSH=$HOME/.oh-my-zsh
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true
export BUN_INSTALL="$HOME/.bun"
export EDITOR="vim"
export HOMEBREW_NO_ANALYTICS=1

ZSH_THEME=""

plugins=(
  git
  zsh-nvm
  zsh-syntax-highlighting
  zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

# PATH
path=(
  $HOME/.local/bin
  $HOME/.bun/bin
  /opt/homebrew/bin
  $path
)
typeset -U path

# Aliases
alias ll="ls -la"
alias pn="pnpm"

# Pure prompt
fpath+=$ZSH/custom/plugins/pure
autoload -U promptinit; promptinit
prompt pure

# Completions
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# Functions
[[ -f ~/.zsh_functions ]] && source ~/.zsh_functions

