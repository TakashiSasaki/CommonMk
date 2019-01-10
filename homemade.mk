.PHONY: all clean slocate LOCATE02 old
.SUFFIXES: .db .txt
FRCODE=/usr/libexec/frcode
BIGRAM=/usr/libexec/bigram
CODE=/usr/libexec/code
UPDATEDB=/usr/bin/updatedb

all: slocate LOCATE02 old 

clean:
	-rm -f filelist
	-rm -rf old/ slocate/ LOCATE02/

slocate: slocate/homemade.txt slocate/updatedb.txt
	-mkdir slocate/

slocate/homemade.db: 
	-mkdir slocate/
	./cat-filelist-0 | sort -z -f | ${FRCODE} -0 -S 1 > $@

slocate/updatedb.db: 
	-mkdir slocate/
	sh -c '(find="`pwd`/cat-filelist-0" ;source ${UPDATEDB} --output=$@ --dbformat=slocate)'

LOCATE02: LOCATE02/homemade.txt LOCATE02/updatedb.db
	-mkdir LOCATE02/

LOCATE02/homemade.db: 
	-mkdir LOCATE02/
	./cat-filelist-0 | sort -z -f | ${FRCODE} -0 > $@

LOCATE02/updatedb.db: 
	-mkdir LOCATE02/
	sh -c '(find="`pwd`/cat-filelist-0" ;source ${UPDATEDB} --output=$@ --dbformat=LOCATE02)'

old: old/homemade.txt old/updatedb.txt
	-mkdir old/

old/sorted: 
	-mkdir old/
	./cat-filelist | tr /  '\001' | sort -f | tr '\001' / > $@
	if [ ! -s $@ ];then  rm $@; exit 1; fi

old/bigrams: old/sorted
	cat $< | ${BIGRAM} | sort | uniq -c | sort -nr | awk '{ if (NR <= 128) print $$2 }' | tr -d '\012' > $@

old/homemade.db: old/bigrams old/sorted
	cat old/sorted | ${CODE} old/bigrams > $@
	if [ ! -s $@ ];then rm $@; exit 1; fi

old/updatedb.db: 
	-mkdir old/
	sh -c '(find="`pwd`/cat-filelist" ;source ${UPDATEDB} --output=$@ --dbformat=old)'

%.txt: %.db
	locate -d $< nig >$@
