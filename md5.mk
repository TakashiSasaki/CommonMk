SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
$(info $(MAKEFILE_LIST))
$(info $(SELF_DIR))
include $(SELF_DIR)xargs.mk

%.md5sum: %.files
	cat $< | ($(XARGS) -L1 -I{} md5sum {}) | tee $@

cd.md5sum:
	find . -type f| xargs md5sum >$@

%.ldjson: %.md5sum
	cat $< 	| jq -R -c 'split("  ")|{"md5":.[0],"path":.[1]}' >$@

