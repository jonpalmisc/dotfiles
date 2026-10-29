#!/bin/sh -e

FREEZE_SH=$(readlink -f "$0")
DOT_EMACS_D=$(dirname "$FREEZE_SH")

ARCHIVE_PATH="$(mktemp -d)"/dotemacs-$(date +%Y.%m.%d.%H%M).tar.xz

tar --uid 0 --gid 0 --no-xattrs --exclude=.DS_Store \
	-cJf "$ARCHIVE_PATH" $(git ls-files .) straight/repos &&
	mv "$ARCHIVE_PATH" .
