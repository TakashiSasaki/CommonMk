.PHONY: diskpart.mk
.DEFAULT_GOAL=diskpart.mk

diskpart.mk: \
	list-vhd \
	test.attach-vdisk.diskpart.utf8 

%.attach-vdisk.diskpart.utf8: %.winpath.utf8
	$(file >$@,SELECT VDISK FILE="$(shell cat "$<")")
	$(file >>$@,ATTACH VDISK)

%.diskpart.runas.utf8: %.diskpart.sjis
	$(file >$@,DISKPART /S $(shell cygpath -a -w "$<"))

list-vdisk: list-vdisk.diskpart.runas.stdout
	iconv -f SJIS -t UTF8 <$<

list-vdisk.diskpart.utf8:
	$(file >$@,LIST VDISK)

list-vhd: all-vhd.cygpaths
	cat $<

all-vhd.cygpaths:
	-rm $@
	for x in /drives/?/*.vhd; do echo $$x; done >>$@
	for x in `cygpath -u '$(USERPROFILE)'`/*/*.vhd; do echo $$x ; done >>$@

test.winpath.utf8:
	echo -n X:\本日は晴天なり.txt | iconv -t UTF8 >$@

test.attach-vdisk.diskpart.utf8::
	cat $@
