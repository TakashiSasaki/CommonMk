.PHONY: apt-udpate npm-update
SUDO=$(shell which sudo)

apt-update:
ifneq ($(shell which apt-cyg),)
	apt-cyg update
else
	sudo apt-get update
	sudo apt-get  upgrade -y
	sudo apt-get  autoremove -y
endif

npm-update:
	$(SUDO) $(APT) install npm
	$(SUDO) npm -g install n
	$(SUDO) npm -g update
	$(SUDO) n stable

