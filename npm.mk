.PHONY: npm-update
SUDO=$(shell which sudo)

npm-update:
	$(SUDO) apt-get install npm
	$(SUDO) npm -g install n
	$(SUDO) npm -g update
	$(SUDO) n stable

