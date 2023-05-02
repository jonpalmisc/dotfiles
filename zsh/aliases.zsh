alias ll='ls -la --color'
alias g='git'
alias lldbr='lldb -o run'

# Aliases for opening applications on macOS.
alias gmacs='open -a Emacs'
alias binja='open -a Binary\ Ninja'
alias ida='open -a ida64'

# Start a local HTTP server with Python 3.
alias ,http='python3 -m http.server'

# Quickly get the local IP of the machine. (macOS)
alias ,local-ip='ipconfig getifaddr en0'

# Color standard error output red.
,color() {
	set -o pipefail
	"$@" 2> >(sed $'s,.*,\e[31m&\e[m,' >&2)
}

# Archive and XZ compress a file or directory.
,xz() {
	tar -cJf "$1.tar.xz" "$1"
}

# Encrypt a file with AES-256 using a passphrase.
,encrypt() {
	local file="$1"
	gpg --symmetric --cipher-algo AES256 "$file" && rm -i "$file"
}

# Decrypt a AES-256-encrypted file using a passphrase.
,decrypt() {
	local file="$1"
	gpg --decrypt --cipher-algo AES256 -o "${file%.*}" "$file" && rm -i "$file"
}

# Ad-hoc codesign a binary or application bundle.
,codesign() {
	codesign -s - --force --deep "$1"
}
