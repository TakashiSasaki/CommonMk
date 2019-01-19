include git.mk
include clean.mk
.PHONY: all
.DEFAULT: all

all: 
	-mkdir make/
	#LC_ALL=C make -r -p -d -n --trace >$@
	make -C make/ -f ../make.mk

