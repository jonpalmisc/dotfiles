#!/bin/sh -eu

: "${SUBLIME_CONFIG_DIR:=$HOME/Library/Application Support/Sublime Text}"

if [ "$#" -gt 1 ]; then
	printf 'Usage: %s [output-archive]\n' "$0" >&2
	exit 2
fi

if [ "$#" -eq 1 ]; then
	archive=$1
else
	archive="Sublime-$(date '+%Y.%m.%d.%H%M').tar.gz"
fi

for directory in 'Installed Packages' 'Packages' 'Lib'; do
	if [ ! -d "$SUBLIME_CONFIG_DIR/$directory" ]; then
		printf 'Error: Required directory does not exist: %s\n' "$SUBLIME_CONFIG_DIR/$directory" >&2
		exit 1
	fi
done

temp_dir=$(mktemp -d)
temp_archive=$temp_dir/archive.tar.gz

cleanup() {
	rm -f "$temp_archive"
	rmdir "$temp_dir"
}

tar --uid 0 --gid 0 --no-xattrs --exclude=.DS_Store -chzf "$temp_archive" -C "$SUBLIME_CONFIG_DIR" 'Installed Packages' 'Packages' 'Lib'
mv "$temp_archive" "$archive"

cleanup

echo "$archive"
