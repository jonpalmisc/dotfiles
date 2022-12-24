RM := rm -fr
LN := ln -s -f

BN_CONFIG_PATH		:= ~/Library/Application\ Support/Binary\ Ninja
EMACS_CONFIG_PATH	:= ~/.emacs.d
FISH_CONFIG_PATH	:= ~/.config/fish
GIT_CONFIG_PATH		:= ~/.config/git
GNUPG_CONFIG_PATH	:= ~/.gnupg
IDA_CONFIG_PATH		:= ~/.idapro
HS_CONFIG_PATH		:= ~/.hammerspoon
NVIM_CONFIG_PATH	:= ~/.config/nvim
SSH_CONFIG_PATH		:= ~/.ssh/config
SUBL_CONFIG_PATH	:= ~/Library/Application\ Support/Sublime\ Text/Packages/User
SMERGE_CONFIG_PATH	:= ~/Library/Application\ Support/Sublime\ Merge/Packages/User
ZSH_CONFIG_PATH		:= ~/.config/zsh

.PHONY:	bn emacs fish git gnupg ida hs nvim ssh subl smerge zsh misc

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

gnupg:
	mkdir -p $(GNUPG_CONFIG_PATH)
	
	$(LN) `pwd`/gnupg/gpg.conf $(GNUPG_CONFIG_PATH)/gpg.conf
	$(LN) `pwd`/gnupg/gpg-agent.conf $(GNUPG_CONFIG_PATH)/gpg-agent.conf

ida:
	$(RM) $(IDA_CONFIG_PATH)/cfg
	mkdir -p $(IDA_CONFIG_PATH)

	$(LN) `pwd`/ida/cfg $(IDA_CONFIG_PATH)/cfg

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

smerge:
	$(RM) $(SMERGE_CONFIG_PATH)
	$(LN) `pwd`/smerge $(SMERGE_CONFIG_PATH)

zsh:
	curl -L git.io/antigen > `pwd`/zsh/antigen.zsh

	$(RM) ~/.zshenv
	$(LN) `pwd`/.zshenv ~/.zshenv

	$(RM) $(ZSH_CONFIG_PATH)
	$(LN) `pwd`/zsh $(ZSH_CONFIG_PATH)

clean-zsh:
	$(RM) ~/.antigen
	$(RM) ~/.zsh*

misc:
	touch ~/.hushlogin
