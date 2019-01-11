.PHONY: all

all: icacls.txt

icacls.txt:
	icacls | tr -d '\r' | iconv -f MS_KANJI -t utf8 | tee $@

takeown.txt:
	takeown /? | tr -d '\r' | iconv -f MS_KANJI -t utf8 | tee $@

