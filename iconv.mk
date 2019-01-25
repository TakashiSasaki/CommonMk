.DEFAULT_GOAL=test

test: test1.sjis test2.utf8

test1.utf8:
	echo hello $@ >$@

test2.sjis:
	echo hello $@ >$@

%.utf8: %.sjis
	$(if $<,,$(error %.sjis is not given))
	cat "$<" | tr -d "\r" | iconv -f MS_KANJI -t UTF8 >$@
	@test -s $@

%.utf16le: %.utf8
	$(if $<,,$(error %.utf8 is not given))
	iconv -f UTF8 -t UTF16LE <$< >$@
	@test -s $@

%.sjis: %.utf8
	$(if $<,,$(error %.utf8 is not given))
	iconv -f UTF8 -t MS_KANJI <$< >$@
	@test -s $@

