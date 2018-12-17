FRCODE=/usr/libexec/frcode
BIGRAM=/usr/libexec/bigram
CODE=/usr/libexec/bigram
UPDATEDB=/usr/bin/updatedb

all: \
	filelist.slocate.txt filelist.locate02.txt filelist.old.txt \
	filelist.slocate.updatedb filelist.locate02.updatedb filelist.old.updatedb

clean:
	-rm -f filelist
	-rm filelist*.txt
	-rm filelist*.updatedb
	-rm filelist*.bigram
	-rm filelist*.locate02
	-rm filelist*.trsorttr
	-rm filelist*.old
	-rm filelist*.slocate

filelist:
	./cat-filelist >$@
	if [ ! -s $@ ];then rm $@; exit 1; fi

filelist.slocate: filelist
	cat $< | sort -f | ${FRCODE} -S 1 > $@

filelist.locate02: filelist
	cat $< | sort -f | ${FRCODE} > $@

filelist.trsorttr: filelist
	cat $< | tr / '\001' | sort -f | tr '\001' / > $@
	if [ ! -s $@ ];then  rm $@; exit 1; fi

filelist.bigram: filelist.trsorttr
	${BIGRAM} < $< | sort | uniq -c | sort -nr | awk '{ if (NR <= 128) print $2 }' | tr -d '\012' > $@

filelist.old: filelist.bigram
	${CODE} $< < ${basename $@} > $@
	if [ ! -s $@ ];then  rm $@; exit 1; fi

filelist.slocate.txt:  filelist.slocate
	locate -d $< nig

filelist.locate02.txt:  filelist.locate02
	locate -d $< nig

filelist.old.txt:  filelist.old
	locate -d $< nig

filelist.old.updatedb: filelist
	sh -c '(find="`pwd`/cat-filelist" ;source ${UPDATEDB} --output=$@ --dbformat=old)'

filelist.slocate.updatedb: filelist
	sh -c '(find="`pwd`/cat-filelist" ;source ${UPDATEDB} --output=$@ --dbformat=slocate)'

filelist.locate02.updatedb: filelist
	sh -c '(find="`pwd`/cat-filelist" ;source ${UPDATEDB} --output=$@ --dbformat=LOCATE02)'

