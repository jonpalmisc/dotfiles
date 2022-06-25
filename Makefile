RM := rm -fr
LN := ln -s -f

BN_CONFIG_PATH := ~/Library/Application\ Support/Binary\ Ninja
EMACS_CONFIG_PATH := ~/.emacs.d
FISH_CONFIG_PATH := ~/.config/fish
GIT_CONFIG_PATH := ~/.config/git
HS_CONFIG_PATH := ~/.hammerspoon
NVIM_CONFIG_PATH := ~/.config/nvim
SSH_CONFIG_PATH := ~/.ssh/config
SUBL_CONFIG_PATH := ~/Library/Application\ Support/Sublime\ Text/Packages/User

.PHONY:	bn emacs fish git hs nvim ssh subl misc

all:
	$(error Targets must be run individually)

bn:
	$(RM) $(BN_CONFIG_PATH)/startup.py
	$(LN) `pwd`/$@/startup.py $(BN_CONFIG_PATH)/startup.py

emacs:
	$(RM) $(EMACS_CONFIG_PATH)
	$(LN) `pwd`/emacs $(EMACS_CONFIG_PATH)

fish:
	$(RM) $(FISH_CONFIG_PATH)
	$(LN) `pwd`/fish $(FISH_CONFIG_PATH)

git:
	$(RM) $(GIT_CONFIG_PATH)
	mkdir -p $(GIT_CONFIG_PATH)

	$(LN) `pwd`/git/.gitconfig ~/.gitconfig
	$(LN) `pwd`/git/ignore $(GIT_CONFIG_PATH)/ignore

	$(LN) `pwd`/git/templates $(GIT_CONFIG_PATH)/templates

hs:
	$(RM) $(HS_CONFIG_PATH)
	$(LN) `pwd`/hs $(HS_CONFIG_PATH)

nvim:
	$(RM) $(NVIM_CONFIG_PATH)
	$(LN) `pwd`/nvim $(NVIM_CONFIG_PATH)

ssh:
	$(RM) $(SSH_CONFIG_PATH)
	$(LN) `pwd`/ssh/config $(SSH_CONFIG_PATH)

subl:
	$(RM) $(SUBL_CONFIG_PATH)
	$(LN) `pwd`/subl $(SUBL_CONFIG_PATH)

misc:
	touch ~/.hushlogin
