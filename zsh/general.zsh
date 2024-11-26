# ===-- Line Editing --------------------------------------------------------===

# Use canonical (Emacs-style) line editing.
bindkey -e

# Use Emacs-style word definitions when navigating with 'M-f', etc.
autoload -Uz select-word-style
select-word-style bash

# Use built-in completion system.
autoload -Uz compinit
compinit
_comp_options+=(globdots)

# Ignore case when using tab completion.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

setopt MENU_COMPLETE
setopt AUTO_LIST
setopt COMPLETE_IN_WORD
setopt MAGIC_EQUAL_SUBST

# ===-- Navigation ----------------------------------------------------------===

# Automatically populate the directory stack when using 'cd'.
setopt AUTO_PUSHD

# Don't add duplicate entries to the directory stack.
setopt PUSHD_IGNORE_DUPS

# Don't print the directory stack after 'pushd' or 'popd'.
setopt PUSHD_SILENT

# ===-- History -------------------------------------------------------------===

# Prioritize removing duplicate entries from the history file over unique ones
# when the history file needs to be trimmed.
setopt HIST_EXPIRE_DUPS_FIRST

# Never add duplicate entries to the history file.
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS

# Ignore duplicate history file entries when performing searches.
setopt HIST_FIND_NO_DUPS

# History is normally saved at the end of each session; configure live history
# sharing between sessions on the same host.
setopt SHARE_HISTORY

# ===-- Other ---------------------------------------------------------------===

# Use built-in help system.
unalias run-help
autoload run-help
alias help=run-help
