.PHONY:	fish misc

all:
	$(error Targets must be run individually)

fish:
	ln -s -f `pwd`/fish ~/.config/fish

misc:
	touch ~/.hushlogin
