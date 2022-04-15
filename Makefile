LN_FLAGS := -s -f

.PHONY:	emacs fish hs nvim misc

all:
	$(error Targets must be run individually)

emacs:
	ln $(LN_FLAGS) `pwd`/emacs ~/.emacs.d

fish:
	ln $(LN_FLAGS) `pwd`/fish ~/.config/fish

hs:
	ln $(LN_FLAGS) `pwd`/hammerspoon ~/.hammerspoon

nvim:
	ln $(LN_FLAGS) `pwd`/nvim ~/.config/nvim

misc:
	touch ~/.hushlogin
