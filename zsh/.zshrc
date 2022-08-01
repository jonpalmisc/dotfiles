# ===-- Path ----------------------------------------------------------------===

# Add an item to the path if it exists
path_prepend() {
	[ -d "$1" ] && path=($1 $path)
}

typeset -U path
path_prepend "/opt/local/bin"
path_prepend "$HOME/.cargo/bin"

path_prepend "/Applications/Emacs.app/Contents/MacOS"

# ===-- General -------------------------------------------------------------===

# Use help system
unalias run-help
autoload run-help
alias help=run-help

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

# ===-- Aliases -------------------------------------------------------------===

alias ll='ls -la --color'
alias g='git'

# Aliases for opening applications on macOS
alias gmacs='open -a Emacs'
alias binja='open -a Binary\ Ninja'
alias ida='open -a ida64'

# ===-- Custom commands -----------------------------------------------------===

# Start a local HTTP server with Python 3
alias ,http='python3 -m http.server'

# Archive and XZ compress a file or directory
,xz() {
	local file="$1"
	tar -cvJf "${file%.*}.tar.xz" "$file"
}

# Encrypt a file with AES-256 using a passphrase
,encrypt() {
	local file="$1"
	gpg --symmetric --cipher-algo AES256 "$file" && rm -i "$file"
}

# Decrypt a file formerly encrypted with AES-256 and passphrase
,decrypt() {
	local file="$1"
	gpg --decrypt --cipher-algo AES256 -o "${file%.*}" "$file" && rm -i "$file"
}

# ===-- Prompt --------------------------------------------------------------===

autoload colors && colors
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b'

# Newline between commends, username and hostname
CUSTOM_PROMPT+=$'\n'
CUSTOM_PROMPT+="%F{magenta}"
CUSTOM_PROMPT+='%n@%m'
CUSTOM_PROMPT+="%F{reset}"
CUSTOM_PROMPT+=':'

# Current directory
CUSTOM_PROMPT+="%F{blue}"
CUSTOM_PROMPT+="%~ "
CUSTOM_PROMPT+="%F{reset}"

# Git info
CUSTOM_PROMPT+="%F{green}"
CUSTOM_PROMPT+='${vcs_info_msg_0_}'
CUSTOM_PROMPT+="%F{reset}"

# Prompt character, ';' or '#' depending on permissions
CUSTOM_PROMPT+=$'\n'
CUSTOM_PROMPT+="%(!.#.;) "

setopt PROMPT_SUBST
PROMPT="$CUSTOM_PROMPT"

# ===-- Packages ------------------------------------------------------------===

# Disable Antigen's caching since it breaks with custom ZDOTDIR
ANTIGEN_CACHE=false
source $ZDOTDIR/antigen.zsh

antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen apply

# ===-- Tool-specific setup -------------------------------------------------===

# Opam
[[ ! -r "$HOME/.opam/opam-init/init.zsh" ]] || source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2>&1
