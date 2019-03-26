#!/bin/make -f 
ifndef updatedb-included
updatedb-included:=1

.SUFFIXES: .slocate .locate02 .locate-sorted .locate-bigrams .locate-old
.DELETE_ON_ERROR:

.PHONY: updatedb-default
updatedb-default: cd.locate02 
	#locate -d $< / | head -n 5

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
ifndef find-included
  include $(SELF_DIR)find.mk
endif

#home.files:
#	find ~ -type f >$@

FRCODE=/usr/libexec/frcode
BIGRAM=/usr/libexec/bigram
CODE=/usr/libexec/code
UPDATEDB=/usr/bin/updatedb


%.slocate: %.files
	cat $< | tr '\n' '\0' | sort -z -f | ${FRCODE} -0 -S 1 > $@
	test -s $@

%.locate02: %.files
	cat $< | tr '\n' '\0' | sort -z -f | ${FRCODE} -0 > $@
	test -s $@

%.locate-sorted: %.files
	cat $< | tr /  '\001' | sort -f | tr '\001' / > $@
	test -s $@

%.locate-bigrams: %.locate-sorted
	cat $< | ${BIGRAM} | sort | uniq -c | sort -nr | awk '{ if (NR <= 128) print $$2 }' | tr -d '\012' > $@
	test -s $@

%.locate-old: %.locate-bigrams %.locate-sorted
	cat $(lastword $^) | ${CODE} $(firstword $^) > $@
	test -s $@

endif # updatedb-included

