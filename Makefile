.PHONY: clean
include win.mk
include git.mk

clean:
	git clean -ndx
	@read -e -p "Are you sure ? (Y/n) " yn; \
		if [ $$yn = "Y" ]; then git clean -fdx; fi


