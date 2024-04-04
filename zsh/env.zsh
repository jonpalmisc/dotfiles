# ===-- Path ----------------------------------------------------------------===

# Add an item to the path if it exists.
,path-prepend() {
	[ -d "$1" ] && path=($1 $path)
}

typeset -U path

# These are listed below in order of REVERSE priority!
,path-prepend "$HOME/.cargo/bin"
,path-prepend /opt/homebrew/bin
,path-prepend "$HOME/Developer/Extra/SRD/bin"
,path-prepend "$HOME/Developer/Prefix/bin"

# ===-- Variables -----------------------------------------------------------===

# Use Neovim as the default editor, if available.
if command -v nvim &>/dev/null; then
	export EDITOR="nvim"
	export VISUAL="$EDITOR"
fi
