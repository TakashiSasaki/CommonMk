SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
#include $(SELF_DIR)clean.mk
#include $(SELF_DIR)random.mk
.DEFAULT_GOAL:=hostinfo-default

.PHONY: hostinfo-default
hostinfo-default: get-macaddress get-ipaddress get-hostname

random-file-base:=$(basename $(wildcard ????????????????????????????????????????.random))
ifeq ($(random-file-base),)
$(error random file is not found)
else
$(info random file base is $(random-file-base))
endif

.PHONY: get-macaddress
get-macaddress: 
	$(if $(wildcard $(random-file-base).macaddress),$(error $(random-file-base).macaddress already exists))
	$(eval macaddress.tmp:=$(shell mktemp))
	if [ -e /bin/TCPCapture ]; then \
		(TCPCapture --ifconfig | sed -nre 's/.+([0-9a-fA-F:-]{17}).*/\1/p' | tee $(macaddress.tmp)) \
	fi
	test -s $(macaddress.tmp)	
	cat $(macaddress.tmp)
	cp -i $(macaddress.tmp) $(random-file-base).macaddress

.PHONY: get-ipaddress
get-ipaddress: 
	$(if $(wildcard $(random-file-base).ipaddress),$(error $(random-file-base).ipaddress already exists))
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
	cp -i $(ipaddress.tmp) $(random-file-base).ipaddress

.PHONY: get-hostname
get-hostname: 
	$(if $(wildcard $(random-file-base).hostname),$(error $(random-file-base).hostname already exists))
	$(eval hostname.tmp:=$(shell mktemp))
	$(call check-random-file)
	if [ -e /bin/hostname ]; then \
		(hostname | tee $(hostname.tmp)) \
	fi
	test -s $(hostname.tmp) 
	cat $(hostname.tmp)
	cp -i $(hostname.tmp) $(random-file-base).hostname

