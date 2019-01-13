.PHONY: all
include make.mk
include git.mk
include clean.mk

all: make.all.txt

make.txt:
	LC_ALL=C make -r -p -d -n --trace >$@
