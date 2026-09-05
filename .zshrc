# Environment
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="vim"

DISABLE_AUTO_UPDATE="true"
ZSH_THEME=""

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)
source "$ZSH/oh-my-zsh.sh"

# History
export HISTSIZE=100000
export SAVEHIST=100000
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY

# PATH
path=(
  $HOME/.local/bin
  $path
)
typeset -U path

# Aliases
alias ll="ls -la"
alias pn="pnpm"

# Pure prompt
if [[ -d "$ZSH/custom/themes/pure" ]]; then
  fpath+=("$ZSH/custom/themes/pure")
elif [[ -d "$ZSH/custom/plugins/pure" ]]; then
  fpath+=("$ZSH/custom/plugins/pure")
fi
autoload -U promptinit; promptinit
prompt pure

# Tools
command -v mise >/dev/null && eval "$(mise activate zsh)"

# Functions
[[ -f ~/.zsh_functions ]] && source ~/.zsh_functions

# Machine-local overrides (Android SDK, extra PATH, etc.)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
