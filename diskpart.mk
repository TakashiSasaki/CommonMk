ifndef diskpart-included
diskpart-included=1

.PHONY: diskpart-default diskpart-test mount-all list-all-vhd list-vdisk list-all-disk

diskpart-default: diskpart-test list-all-vhd


list-vdisk: list-vdisk.diskpart.runas.stdout
	iconv -f MS_KANJI $<

list-vdisk.diskpart.sjis:
	$(file >$@,LIST VDISK)

list-all-vhd: all-vhd.winpaths.d/
	ls $<
	cat $<*

list-all-disk: list-all-disk.diskpart.runas.stdout
	iconv -f CP932 $<

list-all-disk.diskpart.utf8:
	@-rm $@
	echo LIST DISK >>$@ 
	for x in {0..10}; do \
		echo SELECT DISK $$x; \
		echo UNIQUEID DISK; \
		echo DETAIL DISK; \
		echo LIST PARTITION; \
	done >>$@
	cat $@

all-vhd.cygpaths.utf8:
	-rm $@
	for x in /drives/?/*.vhd; do echo $$x; done >>$@
	for x in `cygpath -u '$(USERPROFILE)'`/*/*.vhd; do echo $$x ; done >>$@
	cat $@

MAKEFILES=$(call uniq,$(MAKEFILE_LIST))
attach-all-vhd: all-vhd.winpaths.d/
	echo $<*.winpath.utf8
	for x in $<*.winpath.utf8; do echo $$x; $(MAKE) $${x%%.winpath.utf8}.attach-vdisk.diskpart.runas.stdout; done
	ls $<

diskpart-test: test.attach-vdisk.diskpart.sjis 
	cat $<

test.winpath.utf8:
	# "X:\It's fine today.txt" in Japanese.
	echo -n X:\本日は晴天なり.txt | iconv -t UTF8 >$@

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
$(info MAKEFILE_LIST = $(MAKEFILE_LIST))
$(info SELF_DIR = $(SELF_DIR))
ifndef iconv-included
  include $(SELF_DIR)iconv.mk
endif
ifndef runas-included
  include $(SELF_DIR)runas.mk
endif
ifndef winpath-included
  $(info including winpath.mk)
  include $(SELF_DIR)winpath.mk
  $(info included winpath.mk)
endif

%.attach-vdisk.diskpart.utf8: %.winpath.utf8
	$(file >$@,SELECT VDISK FILE="$(shell cat "$<")")
	$(file >>$@,ATTACH VDISK)

%.diskpart.runas.utf8: %.diskpart.sjis
	$(file >$@,DISKPART /S $(shell cygpath -a -w "$<"))

define uniq =
  $(eval seen :=)
  $(foreach _,$1,$(if $(filter $_,${seen}),,$(eval seen += $_)))
  ${seen}
endef

endif # diskpart-included
