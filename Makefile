.PHONY:	emacs fish hs nvim misc

all:
	$(error Targets must be run individually)

emacs:
	ln -s -f `pwd`/emacs ~/.emacs.d

fish:
	ln -s -f `pwd`/fish ~/.config/fish

hs:
	ln -s -f `pwd`/hammerspoon ~/.hammerspoon

nvim:
	ln -s -f `pwd`/nvim ~/.config/nvim

misc:
	touch ~/.hushlogin
