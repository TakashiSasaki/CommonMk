#!/bin/make -f
ifndef find-included
find-included:=1
.DELETE_ON_ERROR:
.DEFAULT_GOAL:=cd.files

.PHONY: find-default
find-default:
	@echo No default target on find.mk.


SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
ifndef clean-included
  include $(SELF_DIR)clean.mk
endif

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

cd.files: FORCE 
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

FORCE:

endif # find-included


