.PHONY: all
.DEFAULT: all

ifneq ($(shell which ar.exe),)
  AR:=$(shell which ar.exe)
endif

all: x.a
	$(AR) t $<

dir1/:
	-mkdir dir1/

dir2/:
	-mkdir dir2/

dir1/date1.txt: dir1/
	date > $@

dir2/date2.txt: dir2/
	date > $@

x.a: dir1/date1.txt dir2/date2.txt
	$(AR) q $@ $<

