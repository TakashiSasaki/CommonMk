.PHONY: help

help:
	sudo apt install make
	sudo apt update
	sudo apt upgrade -y
	sudo apt autoremove -y
	sudo n stable
	sudo npm install -g npm
	sudo npm -g update


