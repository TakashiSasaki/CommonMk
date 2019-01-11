.PHONY: all clean

all: icacls.help.utf8 takeown.help.utf8 whoami.help.utf8 cscript.help.utf8 \
	whoami.groups.utf8 \
	whoami.user.utf8 \
	whoami.priv.utf8 \
	whoami-uac.priv.utf8 \
	whoami-uac.groups.utf8 \
	whoami-uac.user.utf8 \
	whoami-uac.utf8

clean:
	git clean -fdx

icacls.help.sjis:
	icacls.exe /? >$@

takeown.help.sjis:
	takeown.exe /? >$@

whoami.help.sjis:
	whoami.exe /? >$@

cscript.help.sjis:
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
	cat $< | iconv -f MS_KANJI -t UTF8 | tee $@

%.utf16le: %.sjis
	cat $< | iconv -f MS_KANJI -t UTF16LE | tee $@

%.winpath.utf8: %.winpath.sjis
	cat $< | tr '\\' '\001' | iconv -f MS_KANJI -t UTF8 | tr '\001' '\\' | tee $@

%.winpath.utf8.multiline: %.winpath.utf8
	cat $< | sed -e 's/\\/\n/g' | tee $@

%.winpath.utf8: %.winpath.utf8.multiline
	cat $< | sed -n -e 'H' -e '$${g;s/^\n//;s/\n/\\/g;p}' | tee $@

%.winpath.utf16: %.winpath.utf16.multiline
	cat $< | sed -n -e 'H' -e '$${g;s/^\n//;s/\n/\\/g;p}' | tee $@

%.winpath.sjis: %.winpath.sjis.multiline
	cat $< | sed -n -e 'H' -e '$${g;s/^\n//;s/\n/\\/g;p}' | tee $@

ShellExecute.js:
	echo '(new ActiveXObject("Shell.Application")).ShellExecute(WScript.Arguments(0), WScript.Arguments(1), WScript.Arguments(2), WScript.Arguments(3), WScript.Arguments(4));' | tee $@

cd.winpath.sjis:
	cmd.exe /C cd | tr -d '\r\n' | tee $@

takeown.sjis: ShellExecute.js cd.winpath
	-rm $@
	cscript $< 'cmd.exe' \
		'/C takeown.exe /F "$(shell cat $(lastword $^))" /R >"$(shell cat $(lastword $^))\x5c$@"' \
		'$(shell cat $(lastword $^))' 'runas' 1
	sleep 1
	test -s $@


%.sjis: %.runas ShellExecute.js
	-rm $@
	cscript $(lastword $^) 'cmd.exe' '/C $(shell cat $(firstword $^) ) >$(shell cmd /C cd)\\$@' \
		'$(shell cmd /C cd)' 'runas' 1
	sleep 1
	test -s $@

%.winpath.escaped: %.winpath
	sed -e 's/ /\\ /g' -e 's/\\r//g' -e 's/\\n//g' -e '/^$$/d'  <$< | tee $@

