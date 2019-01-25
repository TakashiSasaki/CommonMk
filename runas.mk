ifndef runas-included
.PHONY: runas-default
runas-included=1

runas-default: \
	whoami-user.runas.utf16le \
	whoami-groups.runas.utf16le \
	whoami-priv.runas.utf16le \
	whoami-user.runas.stdout \
	whoami-groups.runas.stdout \
	whoami-priv.runas.stdout
	@echo ----------------------------
	iconv -f MS_KANJI -t UTF8 $(word 4,$^)
	@echo ----------------------------
	iconv -f MS_KANJI -t UTF8 $(word 5,$^)
	@echo ----------------------------
	iconv -f MS_KANJI -t UTF8 $(word 6,$^)
	@echo ----------------------------

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
$(info MAKEFILE_LIST = $(MAKEFILE_LIST))
$(info SELF_DIR = $(SELF_DIR))
ifndef iconv-included
  include $(SELF_DIR)iconv.mk
endif

%.runas.stdout: %.runas.utf16le runas.js
	-rm $@
	cscript $(lastword $^) $< $@
	sleep 1
	test $@

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

whoami-user.runas.utf8:
	$(file >$@,whoami.exe /USER /FO CSV /NH)

whoami-groups.runas.utf8: 
	$(file >$@,whoami.exe /GROUPS /FO CSV /NH)

whoami-priv.runas.utf8:
	$(file >$@,whoami.exe /PRIV /FO CSV /NH)


endif # runas-included
