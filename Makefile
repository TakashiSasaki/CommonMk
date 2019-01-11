.PHONY: all clean

all: icacls.utf8 takeown.utf8 whoami.groups.utf8 whoami.user.utf8 whoami.priv.utf8 whoami-uac.priv.utf8 whoami-uac.groups.utf8 whoami-uac.user.utf8

clean:
	git clean -fdx

icacls.sjis:
	icacls.exe /? >$@

takeown.sjis:
	takeown.exe /? >$@

whoami.sjis:
	whoami.exe /? >$@

cscript.sjis:
	cscript > $@

whoami.user.sjis:
	whoami.exe /USER /FO CSV /NH 2>&1 >$@

whoami.groups.sjis:
	whoami.exe /GROUPS /FO CSV /NH 2>&1 >$@

whoami.priv.sjis:
	whoami.exe /PRIV /FO CSV /NH 2>&1 >$@

whoami-uac.user.sjis: ShellExecute.js
	-rm $@
	cscript $< 'cmd.exe' '/C whoami.exe /USER /FO CSV /NH >$(shell cmd /C cd)\\$@' \
		'$(shell cmd /C cd)' 'runas' 1
	sleep 1
	test -s $@

whoami-uac.groups.sjis: ShellExecute.js
	-rm $@
	cscript $< 'cmd.exe' '/C whoami.exe /GROUPS /FO CSV /NH >$(shell cmd /C cd)\\$@' \
		'$(shell cmd /C cd)' 'runas' 1
	sleep 1
	test -s $@

whoami-uac.priv.sjis: ShellExecute.js
	-rm $@
	cscript $< 'cmd.exe' '/C whoami.exe /PRIV /FO CSV /NH >$(shell cmd /C cd)\\$@' \
		'$(shell cmd /C cd)' 'runas' 1
	sleep 1
	test -s $@

%.utf8: %.sjis
	cat $< | tr -d "\r" | iconv -f MS_KANJI -t UTF8 | tee $@

ShellExecute.js:
	echo '(new ActiveXObject("Shell.Application")).ShellExecute(WScript.Arguments(0), WScript.Arguments(1), WScript.Arguments(2), WScript.Arguments(3), WScript.Arguments(4));' | tee $@

cd.winpath:
	echo $(shell cmd /C cd) | tr -d '\r\n' | iconv -f MS_KANJI -t UTF8 | tee $@

takeown-me.sjis: ShellExecute.js
	-rm $@
	cscript $< 'cmd.exe' '/C takeown.exe /F * >$(shell cmd /C cd)\\$@' \
		'$(shell cmd /C cd)' 'runas' 1
	sleep 1
	test -s $@

