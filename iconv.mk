ifndef iconv-included
iconv-included:=1

.PHONY: iconv-default
.DEFAULT_GOAL:=iconv-default
iconv-default: 
	@echo No default target in iconv.mk.

%.utf8: %.sjis
	$(if $<,,$(error %.sjis is not given))
	cat "$<" | tr -d "\r" | iconv -f CP932 -t UTF8 >$@
	@test -s $@

%.utf16le: %.utf8
	$(if $<,,$(error %.utf8 is not given))
	iconv -f UTF8 -t UTF16LE <$< >$@
	@test -s $@

%.sjis: %.utf8
	$(if $<,,$(error %.utf8 is not given))
	iconv -f UTF8 -t CP932 <$< >$@
	@test -s $@

endif # iconv-included

