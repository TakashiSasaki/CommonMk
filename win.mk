ifndef win-included
.PHONY: win-default takeown 
win-default: \
	cscript-help.utf8 \
	icacls-help.utf8 \
	mount-all-vhd \
	takeown-help.utf8 \
	takeown.runas.stdout\
	whoami-groups.runas.stdout \
	whoami-groups.sjis \
	whoami-help.utf8 \
	whoami-priv.runas.stdout \
	whoami-priv.sjis \
	whoami-user.runas.stdout \
	whoami-user.sjis 

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
ifndef xargs-included
  include $(SELF_DIR)xargs.mk
endif
ifndef clean-included
  include $(SELF_DIR)clean.mk
endif
ifndef iconv-included
  include $(SELF_DIR)iconv.mk
endif
ifndef runas-included
  include $(SELF_DIR)runas.mk
endif

.DELETE_ON_ERROR:

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

%.winpaths.utf8: %.winpath.utf8
	cat $< | $(XARGS) -L1 echo >$@

%.winpaths.sjis: %.winpath.sjis
	cat $< | $(XARGS) -L1 echo >$@

%.winpaths.utf16le: %.winpath.utf16le
	cat $< | $(XARGS) -L1 echo >$@

cd.winpath:
	echo $(shell cmd /C cd) | tr -d '\r\n' | iconv -f MS_KANJI -t UTF8 | tee $@

takeown.runas.utf8:
	$(file >$@,takeown.exe /F *)

takeown: takeown.runas.stdout
	iconv -f MS_KANJI -t UTF8 <$< | tr -d "\r" | sed -n -e "/^[ \r\n]*$$/n" -e "p"

%.winpaths.md5 : %.winpaths
	$(eval tmp1=$(shell mktemp))
	$(eval tmp2=$(shell mktemp))
	cat $< | $(XARGS) -I{} sh -c "echo -n '{}' | md5sum" >$(tmp1)
	cut -f 1 -d " " <$(tmp1) >$(tmp2)
	paste -d "\n" $(tmp2) $< >$@
	cat $@

%.winpath.utf8: %.winpath
	iconv -t UTF8 <$< >$@	

%.winpath.sjis: %.winpath
	iconv -t MS_KANJI <$< >$@	

%.winpath.utf16le: %.winpath
	iconv -t UTF16LE <$< >$@	

mount-all-vhd: all-vhd.winpaths.d/
	for x in $<*.winpath; do echo $$x; done

endif # win-included
