.PHONY: updateApt updateNode

updateApt:
	sudo apt-get install make;\
	sudo apt-get update; \
	sudo apt-get upgrade -y; \
	sudo apt-get install npm -y;\
	sudo apt-get autoremove -y

updateNode:
	sudo npm -g install n; \
	sudo npm -g update;
	sudo n stable

