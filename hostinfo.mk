SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)clean.mk
include $(SELF_DIR)random.mk
.DEFAULT_GOAL:=hostinfo-default

.PHONY: hostinfo-default
hostinfo-default: get-macaddress get-ipaddress get-hostname

.PHONY: get-macaddress
get-macaddress: init-random-file
	$(if $(wildcard $(basename $(random-file)).macaddress),$(error $(basename $(random-file)).macaddress already exists))
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
	$(if $(wildcard $(basename $(random-file)).ipaddress),$(error $(basename $(random-file)).ipaddress already exists))
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

.PHONY: get-hostname
get-hostname: init-random-file
	$(if $(wildcard $(basename $(random-file)).hostname),$(error $(basename $(random-file)).hostname already exists))
	$(eval hostname.tmp:=$(shell mktemp))
	$(call check-random-file)
	if [ -e /bin/hostname ]; then \
		(hostname | tee $(hostname.tmp)) \
	fi
	test -s $(hostname.tmp) 
	cat $(hostname.tmp)
	cp -i $(hostname.tmp) $(basename $(random-file)).hostname

