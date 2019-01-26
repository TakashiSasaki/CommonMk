.PHONY: Makefile-default run-make.mk
Makefile-default: 
	$(info MAKEFILE_LIST = $(MAKEFILE_LIST))

run-make.mk:
	-mkdir make/
	#LC_ALL=C make -r -p -d -n --trace >$@
	make -C make/ -f ../make.mk

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
ifndef git-include
  include $(SELF_DIR)git.mk
endif
ifndef clean-include
  include $(SELF_DIR)clean.mk
endif


