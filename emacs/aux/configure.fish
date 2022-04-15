#!/usr/bin/env fish

set -x IFLAGS "-I/opt/local/include"
set -x CFLAGS "$IFLAGS -O2"
set -x LDFLAGS "$IFLAGS -L/opt/local/bin"

./configure --disable-silent-rules --with-xml2 --with-gnutls \
	--with-native-compilation --with-json --with-modules --with-ns \
	--without-mailutils --without-dbus --without-imagemagick --without-rsvg \
	--without-xpm --without-tiff --without-gif --without-lcms2 \
	--without-libsystemd --without-cairo --without-imagemagick \
	--without-toolkit-scroll-bars
