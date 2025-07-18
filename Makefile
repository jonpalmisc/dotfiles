RM	:= rm -fr
LN	:= ln -s -f

BN_CONFIG_PATH		:= ~/Library/Application\ Support/Binary\ Ninja
EMACS_CONFIG_PATH	:= ~/.emacs.d
EMAKE_CONFIG_PATH	:= ~/.config/emake.toml
GHOSTTY_CONFIG_PATH	:= ~/.config/ghostty
GIT_CONFIG_PATH		:= ~/.config/git
GNUPG_CONFIG_PATH	:= ~/.gnupg
IDA_CONFIG_PATH		:= ~/.idapro
NVIM_CONFIG_PATH	:= ~/.config/nvim
PAM_CONFIG_PATH		:= /etc/pam.d
RADARE_CONFIG_PATH	:= ~/.config/radare2
SSH_CONFIG_PATH		:= ~/.ssh/config
SUBL_CONFIG_PATH	:= ~/Library/Application\ Support/Sublime\ Text/Packages/User
SMERGE_CONFIG_PATH	:= ~/Library/Application\ Support/Sublime\ Merge/Packages/User
TMUX_CONFIG_PATH	:= ~/.tmux.conf
VSCODE_CONFIG_PATH	:= ~/Library/Application\ Support/Code/User
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

.PHONY: emake
emake:
	$(RM) $(EMAKE_CONFIG_PATH)
	$(LN) `pwd`/emake/emake.toml $(EMAKE_CONFIG_PATH)

.PHONY: ghostty
ghostty:
	$(RM) $(GHOSTTY_CONFIG_PATH)
	mkdir -p $(GHOSTTY_CONFIG_PATH)

	$(LN) `pwd`/ghostty/config $(GHOSTTY_CONFIG_PATH)/config

.PHONY: git
git:
	$(RM) $(GIT_CONFIG_PATH)
	mkdir -p $(GIT_CONFIG_PATH)

	$(LN) `pwd`/git/.gitconfig ~/.gitconfig
	$(LN) `pwd`/git/ignore $(GIT_CONFIG_PATH)/ignore

.PHONY: gnupg
gnupg:
	mkdir -p $(GNUPG_CONFIG_PATH)
	chown -R $$(whoami) $(GNUPG_CONFIG_PATH)

	$(LN) `pwd`/gnupg/gpg.conf $(GNUPG_CONFIG_PATH)/gpg.conf
	$(LN) `pwd`/gnupg/gpg-agent.conf $(GNUPG_CONFIG_PATH)/gpg-agent.conf

	chmod 600 $(GNUPG_CONFIG_PATH)/*
	chmod 700 $(GNUPG_CONFIG_PATH)

.PHONY: ida
ida:
	$(RM) $(IDA_CONFIG_PATH)/cfg
	mkdir -p $(IDA_CONFIG_PATH)

	$(LN) `pwd`/ida/cfg $(IDA_CONFIG_PATH)/cfg

.PHONY: nvim
nvim:
	$(RM) $(NVIM_CONFIG_PATH)
	$(LN) `pwd`/nvim $(NVIM_CONFIG_PATH)

.PHONY: pam
pam:
	$(LN) `pwd`/pam/sudo $(PAM_CONFIG_PATH)/sudo_local

.PHONY: radare2
radare2:
	$(RM) $(RADARE_CONFIG_PATH)
	$(LN) `pwd`/radare2 $(RADARE_CONFIG_PATH)

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

.PHONY: vscode
vscode:
	$(RM) $(VSCODE_CONFIG_PATH)/settings.json
	$(LN) `pwd`/vscode/settings.json $(VSCODE_CONFIG_PATH)/settings.json

.PHONY: zsh
zsh:
	$(RM) ~/.zshenv
	$(LN) `pwd`/.zshenv ~/.zshenv

	$(RM) $(ZSH_CONFIG_PATH)
	mkdir -p ~/.config
	$(LN) `pwd`/zsh $(ZSH_CONFIG_PATH)

.PHONY: clean-zsh
clean-zsh:
	$(RM) ~/.antigen
	$(RM) ~/.zsh*

.PHONY: misc
misc:
	touch ~/.hushlogin
