SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)clean.mk
include $(SELF_DIR)random.mk
.DEFAULT_GOAL:=macaddress-default

.PHONY: macaddress-default
macaddress-default: get-macaddress get-ipaddress

.PHONY: get-macaddress
get-macaddress: init-random-file
	$(eval macaddress.tmp:=$(shell mktemp))
	$(call check-random-file)
	echo Random file is $(random-file)
	if [ -e /bin/TCPCapture ]; then \
		(TCPCapture --ifconfig | sed -nre 's/.+([0-9a-fA-F:-]{17}).*/\1/p' | tee $(macaddress.tmp)) \
	fi
	test -s $(macaddress.tmp)	
	cat $(macaddress.tmp)
	cp $(macaddress.tmp) $(basename $(random-file)).macaddress

.PHONY: get-ipaddress
get-ipaddress: init-random-file
	$(eval ipaddress.tmp:=$(shell mktemp))
	$(call check-random-file)
	if [ -e /bin/TCPCapture ]; then \
		(TCPCapture --ifconfig \
		| sed -nre 's/.+inet addr:([0-9\.]{7,15}).*/\1/p' \
		| sed -re '/127\..+/d' \
		| tee $(ipaddress.tmp)) \
	fi
	test -s $(ipaddress.tmp)	
	cat $(ipaddress.tmp)
	cp $(ipaddress.tmp) $(basename $(random-file)).ipaddress


