# Use help system
unalias run-help
autoload run-help
alias help=run-help

# Configure common aliases
alias ll='ls -la --color'
alias g='git'

# Don't save duplicate history entries
setopt HIST_SAVE_NO_DUPS

# Use canonical line editing
bindkey -e

# Use completion system
autoload -Uz compinit; compinit
_comp_options+=(globdots)

# Use case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

setopt MENU_COMPLETE
setopt AUTO_LIST
setopt COMPLETE_IN_WORD

# Always use directory stack
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
typeset -a ANTIGEN_CHECK_FILES=(${ZDOTDIR:-~}/.zshrc ${ZDOTDIR:-~}/antigen.zsh)
source $ZDOTDIR/antigen.zsh

antigen bundle zsh-users/zsh-completions
antigen apply
