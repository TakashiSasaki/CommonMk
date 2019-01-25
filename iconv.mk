%.utf8: %.sjis
	cat $< | tr -d "\r" | iconv -f MS_KANJI -t UTF8 >$@
	@test -s $@

%.utf16le: %.utf8
	iconv -f UTF8 -t UTF16LE <$< >$@
	@test -s $@

%.sjis: %.utf8
	iconv -f MS_KANJI -t UTF8 <$< >$@

