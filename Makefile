.PHONY: all clean
.DELETE_ON_ERROR:

all: \
	cscript.help.utf8 \
	icacls.help.utf8 \
	takeown.help.utf8 \
	takeown.utf16le \
	whoami.groups.sjis \
	whoami.groups.stdout.utf16le\
	whoami.help.utf8 \
	whoami.priv.sjis \
	whoami.priv.stdout.utf16le\
	whoami.user.sjis \
	whoami.user.stdout.utf16le\

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

whoami.user.runas.utf8:
	$(file >$@, whoami.exe /USER /FO CSV /NH)

whoami.groups.runas.utf8: 
	$(file >$@, whoami.exe /GROUPS /FO CSV /NH)

whoami.priv.runas.utf8:
	$(file >$@, whoami.exe /PRIV /FO CSV /NH)

%.utf8: %.sjis
	cat $< | tr -d "\r" | iconv -f MS_KANJI -t UTF8 | tee $@

%.utf16le: %.utf8
	iconv -f UTF8 -t UTF16LE <$< >$@

shellexecute.js:
	$(file >$@,var shell = new ActiveXObject("WScript.Shell");)
	$(file >>$@,var cd = shell.CurrentDirectory;)
	$(file >>$@,WScript.Echo("CurrentDirectory\t= " + cd);)
	$(file >>$@,var fso = new ActiveXObject("Scripting.FileSystemObject");)
	$(file >>$@,var TriStateTrue = -1;)
	$(file >>$@,var ForReading = 1;)
	$(file >>$@,var f = fso.OpenTextFile(WScript.Arguments(0), ForReading, false, TriStateTrue);)
	$(file >>$@,var sFile = f.ReadLine();)
	$(file >>$@,WScript.Echo("sFile \t\t = " + sFile);)
	$(file >>$@,var vArguments = f.ReadLine();)
	$(file >>$@,WScript.Echo("vArguments \t = " + vArguments);)
	$(file >>$@,var vDirectory = f.ReadLine();)
	$(file >>$@,WScript.Echo("vDirectory \t = " + vDirectory);)
	$(file >>$@,var vOperation = f.ReadLine();)
	$(file >>$@,WScript.Echo("vOperation \t = " + vOperation);)
	$(file >>$@,var vShow = f.ReadLine();)
	$(file >>$@,WScript.Echo("vShow \t\t = " + vShow);)
	$(file >>$@,var a = new ActiveXObject("Shell.Application");)
	$(file >>$@,a.ShellExecute(sFile, vArguments, vDirectory, vOperation, vShow);)

runas.js:
	$(file >$@,var shell = new ActiveXObject("WScript.Shell");)
	$(file >>$@,var cd = shell.CurrentDirectory;)
	$(file >>$@,WScript.Echo("CurrentDirectory\t= " + cd);)
	$(file >>$@,var fso = new ActiveXObject("Scripting.FileSystemObject");)
	$(file >>$@,var TriStateTrue = -1;)
	$(file >>$@,var ForReading = 1;)
	$(file >>$@,var f = fso.OpenTextFile(WScript.Arguments(0), ForReading, false, TriStateTrue);)
	$(file >>$@,var sFile = "cmd.exe";)
	$(file >>$@,WScript.Echo("sFile \t\t = " + sFile);)
	$(file >>$@,var vArguments = f.ReadLine();)
	$(file >>$@,WScript.Echo("vArguments \t = " + vArguments);)
	$(file >>$@,var vDirectory = ".";)
	$(file >>$@,WScript.Echo("vDirectory \t = " + vDirectory);)
	$(file >>$@,var vOperation = "RunAs";)
	$(file >>$@,WScript.Echo("vOperation \t = " + vOperation);)
	$(file >>$@,var vShow = "1";)
	$(file >>$@,WScript.Echo("vShow \t\t = " + vShow);)
	$(file >>$@,var a = new ActiveXObject("Shell.Application");)
	$(file >>$@,a.ShellExecute(sFile, '/C ' + vArguments + ' > "' + cd + "\\" + WScript.Arguments(1) + '"', vDirectory, vOperation, vShow);)

cd.winpath:
	echo $(shell cmd /C cd) | tr -d '\r\n' | iconv -f MS_KANJI -t UTF8 | tee $@

takeown.runas:
	$(file >$@,takeown.exe /F *)

%.stdout.utf16le: %.runas.utf16le runas.js
	-rm $@
	cscript $(lastword $^) $< $@
	sleep 1
	test $@

%.stdout.utf16le: %.shellexecute.utf16le shellexecute.js
	-rm $@
	cscript $(lastword $^) $<
	sleep 1
	test -s $@	

