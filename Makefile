RM	:= rm -fr
LN	:= ln -s -f

BN_CONFIG_PATH		:= ~/Library/Application\ Support/Binary\ Ninja
EMACS_CONFIG_PATH	:= ~/.emacs.d
FISH_CONFIG_PATH	:= ~/.config/fish
GIT_CONFIG_PATH		:= ~/.config/git
GNUPG_CONFIG_PATH	:= ~/.gnupg
HS_CONFIG_PATH		:= ~/.hammerspoon
IDA_CONFIG_PATH		:= ~/.idapro
NVIM_CONFIG_PATH	:= ~/.config/nvim
SSH_CONFIG_PATH		:= ~/.ssh/config
SUBL_CONFIG_PATH	:= ~/Library/Application\ Support/Sublime\ Text/Packages/User
SMERGE_CONFIG_PATH	:= ~/Library/Application\ Support/Sublime\ Merge/Packages/User
TMUX_CONFIG_PATH	:= ~/.tmux.conf
WEZTERM_CONFIG_PATH	:= ~/.config/wezterm
ZSH_CONFIG_PATH		:= ~/.config/zsh


.PHONY: all
all:
	$(error Targets must be run individually)

.PHONY: bn
bn:
	$(RM) $(BN_CONFIG_PATH)/startup.py
	$(LN) `pwd`/$@/startup.py $(BN_CONFIG_PATH)/startup.py
	$(LN) `pwd`/$@/settings.json $(BN_CONFIG_PATH)/settings.json

.PHONY: emacs
emacs:
	$(RM) $(EMACS_CONFIG_PATH)
	$(LN) `pwd`/emacs $(EMACS_CONFIG_PATH)

.PHONY: fish
fish:
	$(RM) $(FISH_CONFIG_PATH)
	$(LN) `pwd`/fish $(FISH_CONFIG_PATH)

.PHONY: git
git:
	$(RM) $(GIT_CONFIG_PATH)
	mkdir -p $(GIT_CONFIG_PATH)

	$(LN) `pwd`/git/.gitconfig ~/.gitconfig
	$(LN) `pwd`/git/ignore $(GIT_CONFIG_PATH)/ignore

.PHONY: gnupg
gnupg:
	mkdir -p $(GNUPG_CONFIG_PATH)
	
	$(LN) `pwd`/gnupg/gpg.conf $(GNUPG_CONFIG_PATH)/gpg.conf
	$(LN) `pwd`/gnupg/gpg-agent.conf $(GNUPG_CONFIG_PATH)/gpg-agent.conf

.PHONY: hs
hs:
	$(RM) $(HS_CONFIG_PATH)
	$(LN) `pwd`/hs $(HS_CONFIG_PATH)

.PHONY: ida
ida:
	$(RM) $(IDA_CONFIG_PATH)/cfg
	mkdir -p $(IDA_CONFIG_PATH)

	$(LN) `pwd`/ida/cfg $(IDA_CONFIG_PATH)/cfg

.PHONY: nvim
nvim:
	$(RM) $(NVIM_CONFIG_PATH)
	$(LN) `pwd`/nvim $(NVIM_CONFIG_PATH)

.PHONY: ssh
ssh:
	$(RM) $(SSH_CONFIG_PATH)
	$(LN) `pwd`/ssh/config $(SSH_CONFIG_PATH)

.PHONY: subl
subl:
	$(RM) $(SUBL_CONFIG_PATH)
	$(LN) `pwd`/subl $(SUBL_CONFIG_PATH)

.PHONY: smerge
smerge:
	$(RM) $(SMERGE_CONFIG_PATH)
	$(LN) `pwd`/smerge $(SMERGE_CONFIG_PATH)

.PHONY: tmux
tmux:
	$(RM) $(TMUX_CONFIG_PATH)
	$(LN) `pwd`/tmux/tmux.conf $(TMUX_CONFIG_PATH)

.PHONY: wezterm
wezterm:
	$(RM) $(WEZTERM_CONFIG_PATH)
	$(LN) `pwd`/wezterm $(WEZTERM_CONFIG_PATH)

.PHONY: zsh
zsh:
	curl -L git.io/antigen > `pwd`/zsh/antigen.zsh

	$(RM) ~/.zshenv
	$(LN) `pwd`/.zshenv ~/.zshenv

	$(RM) $(ZSH_CONFIG_PATH)
	$(LN) `pwd`/zsh $(ZSH_CONFIG_PATH)

.PHONY: clean-zsh
clean-zsh:
	$(RM) ~/.antigen
	$(RM) ~/.zsh*

.PHONY: misc
misc:
	touch ~/.hushlogin
