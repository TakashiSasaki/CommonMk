.PHONY: winpath-default

winpath-default:

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)xargs.mk

%.winpaths.d/: %.winpaths.utf8
	-mkdir $@
	-rm $@*
	split -l1 $< $@
	for x in $@*; do tr -d "\n\r" <$$x >$$x.winpath.utf8; rm $$x; done
	ls $@

%.winpaths.utf8: %.cygpaths.utf8
	cat $< | $(XARGS) -L1 -I{} cygpath -w {} | tee $@

