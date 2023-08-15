alias ll='ls -la --color'
alias g='git'
alias lldbr='lldb -o run'

# Poetry depends on a stupid Python package with the same name and shadows the
# real one. Uninstalling it makes Poetry whine. This will have to do...
alias xattr='/usr/bin/xattr'

# Aliases for opening applications on macOS.
alias gmacs='open -a Emacs'
alias binja='open -a Binary\ Ninja'
alias ida='open -a ida64'

# Start a local HTTP server with Python 3.
alias ,http='python3 -m http.server'

# Quickly get the local IP of the machine. (macOS)
alias ,local-ip='ipconfig getifaddr en0'

# Shake out any DNS weirdness on macOS.
,flush-dns-mac() {
	sudo dscacheutil -flushcache
	sudo killall -HUP mDNSResponder
}

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

,clang-format-dwim() {
	clang-format -i --fallback-style=WebKit $@
}

,clang-format-webkit() {
	clang-format -i --style=WebKit $@
}

,clang-format-llvm() {
	clang-format -i --style=LLVM $@
}

# Print the paths of all the files in `compile_commands.json`.
,cc-json-files() {
	file="${1:-compile_commands.json}"
	jq -r '.[] | .file' <$file
}

# Run `clang-format` on all of the files in `compile_commands.json`.
,cc-json-format() {
	,clang-format-dwim $@ $(,cc-json-files)
}
