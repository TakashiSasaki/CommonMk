ifndef find-included
find-included=1
find-default: cd.files drives-c.files
.DELETE_ON_ERROR:
.PHONY: find-default
SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)clean.mk

%.prune-tmp: %.prune
	cat "$(lastword $^)" \
	| sed -n  -r -e '/^.+/i -name "' -e '/^.+/p' -e '/^.+/a " -prune -o ' -e '$$a -print' \
	| tee $@

%.dir-tmp: %.dir
	echo -n find \"`cat $(firstword $^)`\"\ >$@ 

%.find: %.dir-tmp %.prune-tmp
	cat $^ | tr -d "\n\r" >$@
	echo echo '$$?'

cd.dirs: 
	find . -type d | sed -n -r 's/^.\/(.+)$$/\1/p' >$@
	head $@; tail $@

cd.files: 
	find . -type f | sed -n -r 's/^.\/(.+)$$/\1/p' >$@
	head $@; tail $@

cd.dir:
	pwd | tr -d '\n\r\t' >$@
	grep '^/' $@ 
	test -s $@

%.files: %.find
	time sh $< >$@

home.files:
	find ~ -type f >$@

drives-c.dir:
	echo /drives/c/Users/takas/AppData/Local >$@

drives-c.prune:
	-rm $@
	echo "ElevatedDiagnostics" >>$@
	echo "Content.IE5" >>$@
	echo "Microsoft.MicrosoftOfficeHub*" >>$@


endif # find-included


