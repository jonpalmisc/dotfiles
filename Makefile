.PHONY:	nvim fish hs misc

all:
	$(error Targets must be run individually)

nvim:
	ln -s -f `pwd`/nvim ~/.config/nvim

fish:
	ln -s -f `pwd`/fish ~/.config/fish

hs:
	ln -s -f `pwd`/hammerspoon ~/.hammerspoon

misc:
	touch ~/.hushlogin
