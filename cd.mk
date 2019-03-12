ifndef cd-included
cd-included=1

SELF_DIR=$(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)find.mk

.DEFAULT_GOAL=cd-default

random-file-base=$(basename $(wildcard ????????????????????????????????????????.random))
ifneq ($(word 2,$(random-file-base)),)
$(error Two or more random files were found.)
endif
ifeq ($(word 1, $(random-file-base)),)
$(error No random file was found.)
endif

.PHONY: cd-default
cd-default: $(random-file-base).files $(random-file-base).dirs


$(random-file-base).prune: 
	-rm $@
	touch $@

$(random-file-base).dir:
	pwd >$@

.INTERMEDIATE: $(random-file-base).prune $(random-file-base).dir

endif # cd-included

