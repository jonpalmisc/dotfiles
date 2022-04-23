RM := rm -fr
LN := ln -s -f

EMACS_CONFIG_PATH := ~/.emacs.d
FISH_CONFIG_PATH := ~/.config/fish
GIT_CONFIG_PATH := ~/.gitconfig
HS_CONFIG_PATH := ~/.hammerspoon
NVIM_CONFIG_PATH := ~/.config/nvim

.PHONY:	emacs fish git hs nvim misc

all:
	$(error Targets must be run individually)

emacs:
	$(RM) $(EMACS_CONFIG_PATH)
	$(LN) `pwd`/emacs $(EMACS_CONFIG_PATH)

fish:
	$(RM) $(FISH_CONFIG_PATH)
	$(LN) `pwd`/fish $(FISH_CONFIG_PATH)

git:
	$(RM) $(GIT_CONFIG_PATH)
	$(LN) `pwd`/git/.gitconfig $(GIT_CONFIG_PATH)

hs:
	$(RM) $(HS_CONFIG_PATH)
	$(LN) `pwd`/hammerspoon $(HS_CONFIG_PATH)

nvim:
	$(RM) $(NVIM_CONFIG_PATH)
	$(LN) `pwd`/nvim $(NVIM_CONFIG_PATH)

misc:
	touch ~/.hushlogin
