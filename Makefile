.PHONY:	fish misc

fish:
	ln -s -f `pwd`/fish ~/.config/fish

misc:
	touch ~/.hushlogin
