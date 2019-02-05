ifndef md5-included
md5-included=1

.PHONY: md5-default
md5-default: cd.md5s

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)xargs.mk
include $(SELF_DIR)clean.mk
include $(SELF_DIR)builtin.mk

%.md5s: %.files
	cat $< | ($(XARGS) -L1 -I{} md5sum {}) >$@

cd.files:
	find . -type f >$@

%.ldjson: %.md5s
	cat $< 	| jq -R -c 'split("  ")|{"md5":.[0],"path":.[1]}' >$@

%.mk: %.md5s
	echo ".PHONY: default all" >$@
	echo "default: all" >>$@
	cat $< | sed -n -r -e "s/^([0-9a-f]+)[ ]+(.+)$$/\1 : \2\n\tcp -R $$< $$\@\n\techo -n $$< >$$\@.path\n/p" >>$@
	echo "" >>$@
	echo "all : \\" >>$@
	cat $< | sed -n -r -e "s/^([0-9a-f]+) .+/\t\1\\\/p" >>$@
	echo "" >>$@


endif # md5-included

