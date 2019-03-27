#!/bin/make -f 
ifndef md5-included
md5-included:=1

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)builtin.mk
include $(SELF_DIR)xargs.mk
include $(SELF_DIR)find.mk

.DEFAULT_GOAL:=cd.files.md5

%.path.md5: %.path
	cat $< | ($(XARGS) -L1 -I{} md5sum {}) >$@

%.files.md5: %.files
	cat $< | ($(XARGS) -L1 -I{} md5sum {}) >$@

%.ldjson: %.files.md5
	cat $< 	| jq -R -c 'split("  ")|{"md5":.[0],"path":.[1]}' >$@

endif # md5-included

