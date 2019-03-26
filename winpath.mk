ifndef winpath-included
winpath-included:=1
$(info winpath.mk)

.DEFAULT_GOAL:=winpath-default
.PHONY: winpath-default
winpath-default:
	@echo No default target in winpath.mk.

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
ifndef xargs-included
  include $(SELF_DIR)xargs.mk
endif

%.winpaths.d/: %.winpaths.utf8
	-mkdir $@
	-rm $@*
	split -l1 $< $@
	for x in $@*; do tr -d "\n\r" <$$x >$$x.winpath.utf8; rm $$x; done
	ls $@

%.winpaths.utf8: %.cygpaths.utf8
	cat $< | $(XARGS) -L1 -I{} cygpath -w {} | tee $@

endif

