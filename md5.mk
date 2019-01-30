SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
$(info $(MAKEFILE_LIST))
$(info $(SELF_DIR))
include $(SELF_DIR)xargs.mk

%.md5s: %.files
	cat $< | ($(XARGS) -L1 -I{} md5sum {}) | tee $@

cd.files:
	find . -type f >$@

%.ldjson: %.md5s
	cat $< 	| jq -R -c 'split("  ")|{"md5":.[0],"path":.[1]}' >$@

