.PHONY: mountC mountD mountE mountF

mountC:
	sudo mkdir -p /mnt/c; sudo mount -t drvfs C: /mnt/c

mountD:
	sudo mkdir -p /mnt/d; sudo mount -t drvfs D: /mnt/d

mountE:
	sudo mkdir -p /mnt/e; sudo mount -t drvfs E: /mnt/e

mountF:
	sudo mkdir -p /mnt/f; sudo mount -t drvfs F: /mnt/f


