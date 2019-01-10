.PHONY: all
.SUFFIXES: .slocate .locate02 .locate-sorted .locate-bigrams .locate-old
.DELETE_ON_ERROR:
FRCODE=/usr/libexec/frcode
BIGRAM=/usr/libexec/bigram
CODE=/usr/libexec/code
UPDATEDB=/usr/bin/updatedb

all: updatedb.slocate updatedb.locate02 updatedb.locate-old
	locate -d $(word 3,$^) /
	locate -d $(word 2,$^) /
	locate -e -d $(word 1,$^) /

%.slocate: %.txt
	cat $< | tr '\n' '\0' | sort -z -f | ${FRCODE} -0 -S 1 > $@
	test -s $@

%.locate02: %.txt 
	cat $< | tr '\n' '\0' | sort -z -f | ${FRCODE} -0 > $@
	test -s $@

%.locate-sorted: %.txt
	cat $< | tr /  '\001' | sort -f | tr '\001' / > $@
	test -s $@

%.locate-bigrams: %.locate-sorted
	cat $< | ${BIGRAM} | sort | uniq -c | sort -nr | awk '{ if (NR <= 128) print $$2 }' | tr -d '\012' > $@
	test -s $@

%.locate-old: %.locate-bigrams %.locate-sorted
	cat $(lastword $^) | ${CODE} $(firstword $^) > $@
	test -s $@

