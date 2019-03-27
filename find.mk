#!/bin/make -f 
ifndef find-included
find-included:=1

.PHONY: find-default
find-default: cd.dir cd.file

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
ifndef clean-included
  include $(SELF_DIR)clean.mk
endif
ifndef xargs-included
  include $(SELF_DIR)xargs.mk
endif

.DELETE_ON_ERROR:
.DEFAULT_GOAL:=find-default

%.prune.tmp: %.prune
	cat $< \
	| sed -n  -r -e '/^.+/i -path "' -e '/^.+/p' -e '/^.+/a " -prune -o ' -e '$$a -print' \
	>$@

%.dir.find: %.path
	$(eval prune-tmp:=$(shell mktemp))
	if [ -e $(basename $<).prune ]; \
	then sed -n  -r -e '/^.+/i -path "' -e '/^.+/p' -e '/^.+/a " -prune -o ' -e '$$a -print' \
	  <$(basename $<).prune \
	  >$(prune-tmp); \
	else \
	  touch $(prune-tmp); \
	fi;
	$(eval tmp:=$(shell mktemp))
	cat $< | $(XARGS) -I {} bash -c \
	  '(echo find \"{}\" "-type d " >>$(tmp); cat $(prune-tmp) >>$(tmp); echo ";" >>$(tmp)  )'
	tr -d "\n\r" <$(tmp) >$@

%.file.find: %.path
	$(eval prune-tmp:=$(shell mktemp))
	if [ -e $(basename $<).prune ]; \
	then sed -n  -r -e '/^.+/i -path "' -e '/^.+/p' -e '/^.+/a " -prune -o ' -e '$$a -print' \
	  <$(basename $<).prune \
	  >$(prune-tmp); \
	else \
	  touch $(prune-tmp); \
	fi;
	$(eval tmp:=$(shell mktemp))
	cat $< | $(XARGS) -I {} bash -c \
	  '(echo find \"{}\" "-type f " >>$(tmp); cat $(prune-tmp) >>$(tmp); echo ";" >>$(tmp)  )'
	tr -d "\n\r" <$(tmp) >$@

%.dir: %.dir.find
	time sh $< >$@

%.file: %.file.find
	time sh $< >$@

cd.path: FORCE
	pwd >$@

#cd.files: 
#	find . -type f | sed -n -r 's/^.\/(.+)$$/\1/p' >$@
#	head $@; tail $@

#cd.dir:
#	pwd | tr -d '\n\r\t' >$@
#	grep '^/' $@ 
#	test -s $@

#home.files:
#	find ~ -type f >$@

#home.dirs:
#	find ~ -type d >$@

drives-c.dirs:
	echo /drives/c >$@

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

