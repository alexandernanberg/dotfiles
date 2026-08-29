# Environment
export ZSH=$HOME/.oh-my-zsh
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true
export BUN_INSTALL="$HOME/.bun"
export EDITOR="vim"
export HOMEBREW_NO_ANALYTICS=1

# PATH (before oh-my-zsh, so plugins can find brew-installed tools)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

path=(
  $HOME/.local/bin
  $BUN_INSTALL/bin
  $path
)
typeset -U path

ZSH_THEME=""

plugins=(
  git
  zsh-nvm
  zsh-syntax-highlighting
  zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

# Aliases
alias ll="ls -la"
alias pn="pnpm"

# Pure prompt
fpath+=$ZSH/custom/plugins/pure
autoload -U promptinit; promptinit
prompt pure

# Completions
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

# Functions
[[ -f ~/.zsh_functions ]] && source ~/.zsh_functions
