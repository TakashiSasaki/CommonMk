#!/bin/make -f
ifndef everything-included
everything-included:=1

#
# recipies for utilize Everything Search Engine, a 'locate' tool for Windows environment.
#

.DEFAULT_GOAL:=id_rsa.everything

.PHONY: everything-default
everything-default: id_rsa.everything
	@echo No default target in everything.mk.

id_rsa.txt: FORCE
	echo "id_rsa" >$@

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
	curl --user foo:bar --connect-timeout 1 "http://127.1.2.3/?q=`cat $(tmp)`&json=1" >$@

.PHONY: FORCE
FORCE:

	
endif # everything-included

