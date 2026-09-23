source "$ZDOTDIR/general.zsh"
source "$ZDOTDIR/aliases.zsh"

# Avoid confusing Emacs' TRAMP.
if [ "$TERM" = dumb ]; then
	unsetopt zle
else
	source "$ZDOTDIR/prompt.zsh"
fi
