ifndef md5-included
md5-included=1

.PHONY: md5-default
md5-default: cd.md5s

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)xargs.mk
include $(SELF_DIR)clean.mk

%.md5s: %.files
	cat $< | ($(XARGS) -L1 -I{} md5sum {}) >$@

cd.files:
	find . -type f >$@

%.ldjson: %.md5s
	cat $< 	| jq -R -c 'split("  ")|{"md5":.[0],"path":.[1]}' >$@

endif # md5-included

