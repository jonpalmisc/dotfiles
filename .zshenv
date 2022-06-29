export ZDOTDIR="$HOME/.zshconfig"

export EDITOR="nvim"
export VISUAL="$EDITOR"

# Add an item to the path if it exists
path_append() {
	[ -d "$1" ] && path+="$1"
}

typeset -U path
path_append "/opt/local/bin"
path_append "$HOME/.cargo/bin"
