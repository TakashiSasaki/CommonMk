SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
$(info $(MAKEFILE_LIST))
$(info $(SELF_DIR))
include $(SELF_DIR)xargs.mk
include $(SELF_DIR)clean.mk
.PHONY: all clean takeown list-vdisk list-vhd
.DELETE_ON_ERROR:

all: \
	all-vhd.winpaths.d/ \
	cscript-help.utf8 \
	icacls-help.utf8 \
	list-vdisk \
	list-vhd \
	mount-all-vhd \
	takeown-help.utf8 \
	takeown.runas.stdout\
	whoami-groups.runas.stdout \
	whoami-groups.sjis \
	whoami-help.utf8 \
	whoami-priv.runas.stdout \
	whoami-priv.sjis \
	whoami-user.runas.stdout \
	whoami-user.sjis \

icacls-help.sjis:
	icacls.exe /? >$@

takeown-help.sjis:
	takeown.exe /? >$@

whoami-help.sjis:
	whoami.exe /? >$@

cscript-help.sjis:
	cscript > $@

cmd-help.sjis:
	cmd /? >$@

whoami-user.sjis:
	whoami.exe /USER /FO CSV /NH 2>&1 >$@

whoami-groups.sjis:
	whoami.exe /GROUPS /FO CSV /NH 2>&1 >$@

whoami-priv.sjis:
	whoami.exe /PRIV /FO CSV /NH 2>&1 >$@

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

%.winpath.escaped: %.winpath
	sed -e 's/ /\\ /g' -e 's/\\r//g' -e 's/\\n//g' -e '/^$$/d'  <$< | tee $@

%.winpaths: %.cygpaths
	cat $< | $(XARGS) -L1 -I{} cygpath -w {} | tee $@

%.winpaths.utf8: %.winpath.utf8
	cat $< | $(XARGS) -L1 echo >$@

%.winpaths.sjis: %.winpath.sjis
	cat $< | $(XARGS) -L1 echo >$@

%.winpaths.utf16le: %.winpath.utf16le
	cat $< | $(XARGS) -L1 echo >$@

whoami-user.runas.utf8:
	$(file >$@,whoami.exe /USER /FO CSV /NH)

whoami-groups.runas.utf8: 
	$(file >$@,whoami.exe /GROUPS /FO CSV /NH)

whoami-priv.runas.utf8:
	$(file >$@,whoami.exe /PRIV /FO CSV /NH)

%.utf8: %.sjis
	cat $< | tr -d "\r" | iconv -f MS_KANJI -t UTF8 >$@
	@test -s $@

%.utf16le: %.utf8
	iconv -f UTF8 -t UTF16LE <$< >$@
	@test -s $@

%.sjis: %.utf8
	iconv -f MS_KANJI -t UTF8 <$< >$@

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

takeown.runas.utf8:
	$(file >$@,takeown.exe /F *)

takeown: takeown.runas.stdout
	iconv -f MS_KANJI -t UTF8 <$< | tr -d "\r" | sed -n -e "/^[ \r\n]*$$/n" -e "p"

%.runas.stdout: %.runas.utf16le runas.js
	-rm $@
	cscript $(lastword $^) $< $@
	sleep 1
	test $@

%.shellexecute.stdout: %.shellexecute.utf16le shellexecute.js
	-rm $@
	cscript $(lastword $^) $<
	sleep 1
	test -s $@	

%.attach-vdisk.diskpart.utf8: %.winpath.utf8
	$(file >$@,SELECT VDISK FILE="$(shell cat "$<")")
	$(file >>$@,ATTACH VDISK)

%.diskpart.runas.utf8: %.diskpart.sjis
	$(file >$@,DISKPART /S $(shell cygpath -a -w "$<"))

list-vdisk: list-vdisk.diskpart.runas.stdout
	iconv -f SJIS -t UTF8 <$<

list-vdisk.diskpart.utf8:
	$(file >$@,LIST VDISK)

list-vhd: all-vhd.cygpaths
	cat $<

all-vhd.cygpaths:
	-rm $@
	for x in /drives/?/*.vhd; do echo $$x; done >>$@
	for x in `cygpath -u '$(USERPROFILE)'`/*/*.vhd; do echo $$x ; done >>$@

%.winpaths.md5 : %.winpaths
	$(eval tmp1=$(shell mktemp))
	$(eval tmp2=$(shell mktemp))
	cat $< | $(XARGS) -I{} sh -c "echo -n '{}' | md5sum" >$(tmp1)
	cut -f 1 -d " " <$(tmp1) >$(tmp2)
	paste -d "\n" $(tmp2) $< >$@
	cat $@

%.winpaths.d/: %.winpaths
	-mkdir $@
	-rm $@*
	split -l1 $< $@
	for x in $@*; do tr -d "\n\r" <$$x >$$x.winpath; rm $$x; done
	ls $@

%.winpath.utf8: %.winpath
	iconv -t UTF8 <$< >$@	

%.winpath.sjis: %.winpath
	iconv -t MS_KANJI <$< >$@	

%.winpath.utf16le: %.winpath
	iconv -t UTF16LE <$< >$@	

mount-all-vhd: all-vhd.winpaths.d/
	for x in $<*.winpath; do echo $$x; done
