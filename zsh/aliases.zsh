alias ll='ls -laFh --color'
alias g='git'
alias lldbr='lldb -o run'

alias rgi='rg -i'

# Poetry depends on a stupid Python package with the same name and shadows the
# real one. Uninstalling it makes Poetry whine. This will have to do...
alias xattr='/usr/bin/xattr'

# Aliases for opening applications on macOS.
alias gmacs='open -a Emacs'
alias binja='open -a Binary\ Ninja'
alias ida64='open -a ida64'
alias ida='open -b com.hexrays.ida'

# Start a local HTTP server with Python 3.
alias ,http='python3 -m http.server'

# Quickly get the local IP of the machine. (macOS)
alias ,local-ip='ipconfig getifaddr en0'

mkcd() {
	mkdir -p "$1" && cd "$1"
}

# Run a command with CFLAGS, etc. updated to use a given prefix.
,with-prefix() {
	prefix="$1"
	shift

	CFLAGS+=" -I$prefix/include" \
	CXXFLAGS+=" -I$prefix/include" \
	LDFLAGS+=" -L$prefix/lib" \
	$@
}

# Set CFLAGS, etc. to use a given prefix.
,export-prefix() {
	export CFLAGS="$CFLAGS -I$1/include"
	export CXXFLAGS="$CXXFLAGS -I$1/include"
	export LDFLAGS="$LDFLAGS -L$1/lib"
}

alias ,with-brew-prefix=",with-prefix $(brew --prefix)"
alias ,with-dev-prefix=",with-prefix $HOME/Developer/Prefix"

,pyint() {
	python3 -c "i = ($1); print(i); print(hex(i)); print(bin(i))"
}

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

TAR_PRIVACY_FLAGS=(--uid 0 --gid 0 --no-xattrs --exclude='.DS_Store')

# Create a Tar archive from a file or directory.
,tar() {
	tar $TAR_PRIVACY_FLAGS -cf "$1.tar" "$1"
}

# Unarchive a Tar archive.
,untar() {
	tar -xf "$1"
}

# Create a XZ-compressed archive from a file or directory.
,xz() {
	tar $TAR_PRIVACY_FLAGS -cJf "$1.tar.xz" "$1"
}

# Unarchive a XZ-compressed archive.
,unxz() {
	tar -xJf "$1"
}

# Create a Gzip-compressed archive from a file or directory.
,gz() {
	tar $TAR_PRIVACY_FLAGS -czf "$1.tar.gz" "$1"
}

# Unarchive a Gzip-compressed archive.
,ungz() {
	tar -xzf "$1"
}

# Create a ZSTD-compressed archive from a file or directory.
,zstd() {
	tar $TAR_PRIVACY_FLAGS -c $1 | zstd -21 --ultra -T4 >"$1.tar.zst"
}

# Unarchive a ZSTD-compressed archive.
,unzstd() {
	tar -xf "$1"
}

# Create an AES-256 encrypted Zip archive with 7zip.
,7z-zip-encrypt() {
	7z a -tzip -p -mem=AES256 "$1.zip" "$1"
}

# Create an AES-256 encrypted Zip archive with 7zip, but without compression.
,7z-zip-encrypt-0() {
	7z a -tzip -mx=0 -p -mem=AES256 "$1.zip" "$1"
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

,clang-format-jp() {
	clang-format "-style=file:$HOME/.files/etc/.clang-format" -i $@
}

,clang-format-dwim() {
	clang-format -i --fallback-style=LLVM $@
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

# Shorthand to create an empty Git commit without polluting shell history.
,git-commit-empty() {
	git commit --allow-empty $@
}

# Convert a FLAC file to MP3.
,ffmpeg-flac-to-mp3() {
	ffmpeg -i "$1" -b:a 320k -map_metadata 0 -id3v2_version 3 "$1.mp3"
}

,tio-icrnl() {
	tio -m INLCRNL --mute $@
}

,iproxy-listen-ssh() {
	iproxy 2222:22
}

,ssh-srd-iproxy-unsafe() {
	gsed -i '/\[localhost\]:2222/d' ~/.ssh/known_hosts && ssh -o "StrictHostKeyChecking no" -p 2222 root@localhost
}

,pythonpath-prepend() {
	[ -d "$1" ] && export PYTHONPATH="$1:${PYTHONPATH}"
}

,cryptexctl-default-udid() {
	cryptexctl device list | tail -n1 | awk '{print $1}'
}

,cryptexctl-export-default-udid() {
	export CRYPTEXCTL_UDID=$(,cryptexctl-default-udid)
}

,venv() {
	if [ ! -d ".venv" ]; then
		python3 -m venv .venv
	fi

	source .venv/bin/activate
}
