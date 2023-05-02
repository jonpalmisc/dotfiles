# ===-- Path ----------------------------------------------------------------===

# Add an item to the path if it exists.
path_prepend() {
	[ -d "$1" ] && path=($1 $path)
}

typeset -U path

# These are listed below in order of REVERSE priority!
path_prepend /Applications/Emacs.app/Contents/MacOS
path_prepend "$HOME/.cargo/bin"
path_prepend /opt/arm-gnu/12.2.1/bin
path_prepend /opt/homebrew/bin
path_prepend /opt/srd/bin
path_prepend /opt/jpkg/bin

# ===-- Variables -----------------------------------------------------------===

# Use Neovim as the default editor, if available.
if command -v nvim &>/dev/null; then
	export EDITOR="nvim"
	export VISUAL="$EDITOR"
fi
