.PHONY: readme whoami chownToMe

readme:
	@cat readme.txt

whoami:
	@echo $(USER)

chownToMe:
	sudo find . -print0 | sudo xargs -0 chown '$(USER)'

