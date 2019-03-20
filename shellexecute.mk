SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
$(info $(MAKEFILE_LIST))

$(info $(SELF_DIR))
include $(SELF_DIR)iconv.mk

.DEFAULT_GOAL:=shellexecute-default

.PHONY: shellexecute-default
shellexecute-default: \
	whoami-user.shellexecute.stdout \
	whoami-groups.shellexecute.stdout \
	whoami-priv.shellexecute.stdout 
	@echo -------------------------------
	cat $(word 1,$^)
	@echo -------------------------------
	cat $(word 2,$^)
	@echo -------------------------------
	cat $(word 3,$^)
	@echo -------------------------------


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


%.shellexecute.stdout: %.shellexecute.utf16le shellexecute.js
	$(info making $@)
	@-rm $@
	cscript //nologo $(lastword $^) $< >$@
	sleep 1
	test -s $@	

whoami-user.shellexecute.utf8:
	$(file >$@,whoami.exe)
	$(file >>$@,/USER /FO CSV /NH)
	$(file >>$@,)
	$(file >>$@,open)
	$(file >>$@,1)

whoami-groups.shellexecute.utf8: 
	$(file >$@,whoami.exe /GROUPS /FO CSV /NH)

whoami-priv.shellexecute.utf8:
	$(file >$@,whoami.exe /PRIV /FO CSV /NH)

