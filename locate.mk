.PHONY: all clean slocate LOCATE02 old
.SUFFIXES: .filelist .locate02
FRCODE=/usr/libexec/frcode
BIGRAM=/usr/libexec/bigram
CODE=/usr/libexec/code
UPDATEDB=/usr/bin/updatedb

all: slocate LOCATE02 old 

%.locate02: %.filelist 
	cat $<| sort -f | ${FRCODE} > $@

