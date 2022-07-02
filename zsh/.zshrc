# ===-- General -------------------------------------------------------------===

# Use help system
unalias run-help
autoload run-help
alias help=run-help

# Configure common aliases
alias ll='ls -la --color'
alias g='git'

# Don't save duplicate history entries
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

# Use canonical line editing
bindkey -e

# Use Emacs-style word definitions
autoload -Uz select-word-style
select-word-style bash

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

# ===-- Prompt --------------------------------------------------------------===

autoload colors && colors
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '[%b]'

# Newline between commends, username and hostname
CUSTOM_PROMPT+=$'\n'
CUSTOM_PROMPT+='%n@%m '

# Current directory
CUSTOM_PROMPT+="%F{magenta}"
CUSTOM_PROMPT+="%~ "
CUSTOM_PROMPT+="%F{reset}"

# Git info
CUSTOM_PROMPT+="%F{green}"
CUSTOM_PROMPT+='${vcs_info_msg_0_}'
CUSTOM_PROMPT+="%F{reset}"

# Prompt character, '%' or '#' depending on permissions
CUSTOM_PROMPT+=$'\n'
CUSTOM_PROMPT+="%# "

setopt PROMPT_SUBST
PROMPT=$CUSTOM_PROMPT

# ===-- Packages ------------------------------------------------------------===

# Disable Antigen's caching since it breaks with custom ZDOTDIR
ANTIGEN_CACHE=false
source $ZDOTDIR/antigen.zsh

antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen apply
