# ===-- Path ----------------------------------------------------------------===

# Add an item to the path if it exists.
,path-prepend() {
	[ -d "$1" ] && path=($1 $path)
}

typeset -U path

# These are listed below in order of REVERSE priority!
,path-prepend "$HOME/.local/bin"
,path-prepend "$HOME/.cargo/bin"
,path-prepend /opt/homebrew/bin
,path-prepend "$HOME/Developer/Extra/SRD/bin"
,path-prepend "$HOME/Developer/Prefix/bin"

# ===-- Variables -----------------------------------------------------------===

# Use Neovim as the default editor and manual pager, if available.
if command -v nvim &>/dev/null; then
	export EDITOR="nvim"
	export MANPAGER="nvim +Man\!"
fi

# Use Emacs as the default editor, if available.
if [ -f /Applications/Emacs.app/Contents/MacOS/Emacs ]; then
    export EDITOR="/Applications/Emacs.app/Contents/MacOS/Emacs -nw"
fi

export VISUAL="$EDITOR"
