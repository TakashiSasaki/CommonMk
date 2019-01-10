.SUFFIXES: .filelist .locate02

ifndef FRCODE
 FRCODE=$(shell which frcode)
else
 FRCODE=/usr/libexec/frcode
endif

ifndef BIGRAM
 FRCODE=$(shell which bigram)
else
 BIGRAM=/usr/libexec/bigram
endif

%.githash: %.paths
	cat $< | xargs -n 1 git hash-object 2>&1| tee $@

%.frcode: %.urls
	cat $< | sort | uniq | ${FRCODE} >$@
	test -s $@

%.urls: %.frcode
	locate -d $< "" > $@

.PHONY: all clean slocate LOCATE02 old
FRCODE=/usr/libexec/frcode
BIGRAM=/usr/libexec/bigram
CODE=/usr/libexec/code
UPDATEDB=/usr/bin/updatedb

all: slocate LOCATE02 old 

%.locate02: %.filelist 
	cat $<| sort -f | ${FRCODE} > $@

