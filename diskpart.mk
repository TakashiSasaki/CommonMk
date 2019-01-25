.PHONY: diskpart-default
diskpart-default: \
	all-vhd.winpaths.d/ \
	test.attach-vdisk.diskpart.utf8 \
	test.attach-vdisk.diskpart.sjis \
	list-vdisk.diskpart.sjis \
	list-vdisk.diskpart.runas.utf8 
	@echo ---------------------------------
	ls all-vhd.winpaths.d/
	@echo ---------------------------------
	iconv -f MS_KANJI test.attach-vdisk.diskpart.sjis
	@echo ---------------------------------
	iconv -f UTF8 list-vdisk.diskpart.runas.utf8
	@echo ---------------------------------

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
$(info MAKEFILE_LIST = $(MAKEFILE_LIST))
$(info SELF_DIR = $(SELF_DIR))
include $(SELF_DIR)iconv.mk
include $(SELF_DIR)runas.mk
include $(SELF_DIR)winpath.mk

%.attach-vdisk.diskpart.utf8: %.winpath.utf8
	$(file >$@,SELECT VDISK FILE="$(shell cat "$<")")
	$(file >>$@,ATTACH VDISK)

%.diskpart.runas.utf8: %.diskpart.sjis
	$(file >$@,DISKPART /S $(shell cygpath -a -w "$<"))

#list-vdisk: list-vdisk.diskpart.runas.stdout
#	iconv -f SJIS -t UTF8 <$<

list-vdisk.diskpart.sjis:
	$(file >$@,LIST VDISK)

all-vhd.cygpaths.utf8:
	-rm $@
	for x in /drives/?/*.vhd; do echo $$x; done >>$@
	for x in `cygpath -u '$(USERPROFILE)'`/*/*.vhd; do echo $$x ; done >>$@
	cat $@

test.winpath.utf8:
	echo -n X:\本日は晴天なり.txt | iconv -t UTF8 >$@

list-vdisk.diskpart.runas:
	cat $@

