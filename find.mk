ifndef find-included
find-included=1
find-default:cd.files cd.dirs cd.dir drives-c.files drives-c.dirs home.files home.dirs

.DELETE_ON_ERROR:
.PHONY: find-default
SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)clean.mk
.DEFAULT_GOAL:=find-default

%.prune.tmp: %.prune
	cat "$(lastword $^)" \
	| sed -n  -r -e '/^.+/i -path "' -e '/^.+/p' -e '/^.+/a " -prune -o ' -e '$$a -print' \
	| tee $@

%.dirs.tmp: %.dir
	echo find \"`cat $(firstword $^)`\"\ -type d \ >$@ 

%.files.tmp: %.dir
	echo find \"`cat $(firstword $^)`\"\ -type f \ >$@ 

%.dirs.find: %.dirs.tmp %.prune.tmp
	cat $^ | tr -d "\n\r" >$@

%.files.find: %.files.tmp %.prune.tmp
	cat $^ | tr -d "\n\r" >$@

%.dirs: %.dirs.find
	time sh $< >$@

%.files: %.files.find
	time sh $< >$@

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

home.files:
	find ~ -type f >$@

home.dirs:
	find ~ -type d >$@

drives-c.dir:
	echo /drives/c/Users/ >$@

drives-c.prune:
	-rm $@
	echo "*/ElevatedDiagnostics" >>$@
	echo "*/Content.IE5" >>$@
	echo "*/Microsoft.MicrosoftOfficeHub*" >>$@
	echo "*/Administrator" >>$@
	echo "*/DefaultAppPool" >>$@
	echo "*/Guest" >>$@
	echo "*/ElevatedDiagnostics" >>$@
	echo "*/sshd" >>$@
	echo "*/Takashi SASAKI" >>$@

endif # find-included


