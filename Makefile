FRCODE=/usr/libexec/frcode
BIGRAM=/usr/libexec/bigram
CODE=/usr/libexec/bigram
UPDATEDB=/usr/bin/updatedb

all: \
	old/homemade.txt slocate/homemade.txt LOCATE02/homemade.txt \
	old/updatedb.txt slocate/updatedb.txt LOCATE02/updatedb.txt

clean:
	-rm -f filelist
	-rm -rf old/ slocate/ LOCATE02/

filelist:
	./cat-filelist >$@
	if [ ! -s $@ ];then rm $@; exit 1; fi

slocate/handmade.db: filelist
	-mkdir slocate
	cat $< | sort -f | ${FRCODE} -S 1 > $@

LOCATE02/homemade.db: filelist
	-mkdir locate02
	cat $< | sort -f | ${FRCODE} > $@

old/sorted: filelist
	cat $< | tr / '\001' | sort -f | tr '\001' / > $@
	if [ ! -s $@ ];then  rm $@; exit 1; fi

old/bigram: old/sorted
	${BIGRAM} < $< | sort | uniq -c | sort -nr | awk '{ if (NR <= 128) print $2 }' | tr -d '\012' > $@

old/homemade.db: old/bigram
	${CODE} $< < ${basename $@} > $@
	if [ ! -s $@ ];then  rm $@; exit 1; fi

old/updatedb.db: cat-filelist
	sh -c '(find="`pwd`/$<" ;source ${UPDATEDB} --output=$@ --dbformat=old)'

slocate/updatedb.db: filelist
	sh -c '(find="`pwd`/$<" ;source ${UPDATEDB} --output=$@ --dbformat=slocate)'

LOCATE02/updatedb.db: filelist
	sh -c '(find="`pwd`/$<" ;source ${UPDATEDB} --output=$@ --dbformat=LOCATE02)'

%.txt: %.db
	locate -d $< nig >$@

