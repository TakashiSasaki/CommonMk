.PHONY: apt-update
apt-update:
ifneq ($(shell which apt-cyg),)
	apt-cyg update
else
	sudo apt-get update
	sudo apt-get upgrade -y
	sudo apt-get autoremove -y
endif

