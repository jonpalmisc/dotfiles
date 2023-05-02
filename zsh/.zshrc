source "$ZDOTDIR/env.zsh"
source "$ZDOTDIR/general.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/prompt.zsh"
source "$ZDOTDIR/quirks.zsh"

# ===-- Packages ------------------------------------------------------------===

# Disable Antigen's caching since it breaks with custom ZDOTDIR
ANTIGEN_CACHE=false
source $ZDOTDIR/antigen.zsh

antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen apply
