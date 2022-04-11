.PHONY:	fish misc hs

all:
	$(error Targets must be run individually)

fish:
	ln -s -f `pwd`/fish ~/.config/fish

hs:
	ln -s -f `pwd`/hammerspoon ~/.hammerspoon

misc:
	touch ~/.hushlogin
