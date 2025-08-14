#!/bin/sh -e

FREEZE_SH=$(readlink -f "$0")
DOT_EMACS_D=$(dirname "$FREEZE_SH")
PARENT_D=$(dirname "$DOT_EMACS_D")

ARCHIVE_PATH="$(mktemp -d)"/dotemacs-$(date +%s).tar.xz

tar --uid 0 --gid 0 --no-xattrs --exclude=.DS_Store \
	-cJf "$ARCHIVE_PATH" -C "$PARENT_D" "$(basename "$DOT_EMACS_D")" &&
	mv "$ARCHIVE_PATH" .
