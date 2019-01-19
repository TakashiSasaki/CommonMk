.PHONY: all
.DEFAULT: all

ifneq ($(shell which ar.exe),)
  AR:=$(shell which ar.exe)
endif

all: q.a r.a

dir1/:
	-mkdir dir1/

dir2/:
	-mkdir dir2/

dir1/date1.txt: dir1/
	date > $@

dir2/date2.txt: dir2/
	date > $@

q.a: dir1/date1.txt dir2/date2.txt
	$(AR) q $@ $^
	$(AR) tv $@

r.a: dir1/date1.txt dir2/date2.txt
	$(AR) r $@ $^
	$(AR) tv $@

