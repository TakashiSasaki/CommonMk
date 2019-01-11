.PHONY: all

all: icacls.txt takeown.txt whoami.groups.txt whoami.user.txt whoami.priv.txt

icacls.txt:
	icacls.exe | tr -d '\r' | iconv -f MS_KANJI -t utf8 | tee $@

takeown.txt:
	takeown.exe /? | tr -d '\r' | iconv -f MS_KANJI -t utf8 | tee $@

whoami.txt:
	whoami.exe /? | tr -d '\r' | iconv -f MS_KANJI -t utf8 | tee $@


takeown-me:
	takeown /F "*" /R 2>&1| iconv -f MS_KANJI -t utf8

whoami.user.txt:
	whoami.exe /USER /FO CSV /NH 2>&1 | tr -d "\r" | iconv -f MS_KANJI | tee $@

whoami.groups.txt:
	whoami.exe /GROUPS /FO CSV /NH 2>&1 | tr -d "\r" | iconv -f MS_KANJI| tee $@

whoami.priv.txt:
	whoami.exe /PRIV /FO CSV /NH 2>&1 | tr -d "\r" | iconv -f MS_KANJI| tee $@
