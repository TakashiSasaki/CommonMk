#!/bin/make -f
ifndef updatedb-included
updatedb-included=1

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
ifndef find-included
  $(info including $(SERLF_DIR)find.mk)
  include $(SELF_DIR)find.mk
endif


.SUFFIXES: .slocate .locate02 .locate-sorted .locate-bigrams .locate-old
.DELETE_ON_ERROR:
.DEFAULT_GOAL:=updatedb-test

.PHONY: updatedb-default
#updatedb-default: home.locate02 
updatedb-default:
	@#locate -d $< / | head -n 5
	@echo No default target in updatedb.mk

#home.files:
#	find ~ -type f >$@

FRCODE:=$(shell which frcode)
FRCODE:=$(if $(FRCODE),$(FRCODE),$(wildcard /usr/libexec/frcode*))
FRCODE:=$(if $(FRCODE),$(FRCODE),/usr/libexec/frcode)
$(info FRCODE=$(FRCODE))

BIGRAM:=$(shell which bigram)
BIGRAM:=$(if $(BIGRAM),$(BIGRAM),$(wildcard /usr/libexec/bigram*))
BIGRAM:=$(if $(BIGRAM),$(BIGRAM),/usr/libexec/bigram)
$(info BIGRAM=$(BIGRAM))

CODE:=$(shell which code)
CODE:=$(if $(CODE),$(CODE),$(wildcard /usr/libexec/code*))
CODE:=$(if $(CODE),$(CODE),/usr/libexec/code)
$(info CODE=$(CODE))

UPDATEDB:=$(shell which updatedb)
UPDATEDB:=$(if $(UPDATEDB),$(UPDATEDB),$(wildcard /usr/bin/updatedb*))
UPDATEDB:=$(if $(UPDATEDB),$(UPDATEDB),/usr/bin/updatedb)
$(info UPDATEDB=$(UPDATEDB))

.PHONY: updatedb-test
updatedb-test: cd.locate02

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

%.githash: %.paths
	cat $< | xargs -n 1 git hash-object 2>&1| tee $@

%.frcode: %.urls
	cat $< | sort | uniq | ${FRCODE} >$@
	test -s $@

endif # updatedb-included

