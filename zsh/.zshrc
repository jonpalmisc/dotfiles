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

# Configure basic prompt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '[%b]'

CUSTOM_PROMPT+=$'\n'	# Newline between commands
CUSTOM_PROMPT+='%n@%m ' # user@hostname
CUSTOM_PROMPT+="%~ "	# ~/current/directory
CUSTOM_PROMPT+='${vcs_info_msg_0_}'
CUSTOM_PROMPT+=$'\n'
CUSTOM_PROMPT+="%# "    # '%' or '$' depending on permissions

setopt PROMPT_SUBST
PROMPT=$CUSTOM_PROMPT

# Disable Antigen's caching since it breaks with custom ZDOTDIR
ANTIGEN_CACHE=false
source $ZDOTDIR/antigen.zsh

antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen apply
