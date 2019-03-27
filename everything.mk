#!/bin/make -f
ifndef everything-included
everything-included:=1

#
# recipies for utilize Everything Search Engine, a 'locate' tool for Windows environment.
#

.DEFAULT_GOAL:=everything-default

.PHONY: everything-default
everything-default: id_rsa.everything sshdir.everything
	@echo No default target in everything.mk.

id_rsa.txt: FORCE
	@echo "id_rsa" >$@

sshdir.txt: FORCE
	@echo ".ssh" >$@
	@echo "attrib:D" >>$@

# also an example of urlencode by sed
%.everything: %.txt
	$(eval tmp:=$(shell mktemp))
	tr -s "\n\t\r" " " <$<  | \
	sed  \
	    -e 's/ /%20/g' \
	    -e 's/!/%21/g' \
	    -e 's/"/%22/g' \
	    -e 's/#/%23/g' \
	    -e 's/\$$/%24/g' \
	    -e 's/\&/%26/g' \
	    -e 's/'\''/%27/g' \
	    -e 's/(/%28/g' \
	    -e 's/)/%29/g' \
	    -e 's/:/%3A/g' >$(tmp)
	$(eval tmp2:=$(shell mktemp))
	echo http://127.1.2.3/? >>$(tmp2)
	echo q= >>$(tmp2)
	cat $(tmp) >>$(tmp2)
	echo "&json=1" >>$(tmp2)
	echo "&path=1" >>$(tmp2)
	echo "&path_column=1" >>$(tmp2)
	echo "&size_column=1" >>$(tmp2)
	echo "&date_modified_column=1" >>$(tmp2)
	echo "&date_created_column=1" >>$(tmp2)
	echo "&attributes_column=1" >>$(tmp2)
	curl --user foo:bar --connect-timeout 1 `tr -d '\r\n' <$(tmp2)` >$@

.PHONY: FORCE
FORCE:

	
endif # everything-included

