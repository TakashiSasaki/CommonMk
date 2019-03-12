ifndef cygwin-included
cygwin-included=1

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
ifndef common-included
  include $(SELF_DIR)common.mk
endif

ifneq ($(OSTYPE),cygwin)
$(error OSTYPE is not cygwin)
endif

.PHONY: cygwin-updatedb	

CYGWIN_UPDATEDB=\
	windows \
	pf86 \
	pf64 \
	users \
	program-data

cygwin-default: $(addsuffix .updatedb,$(addprefix cygwin/,${CYGWIN_UPDATEDB}))

PRUNEPATHS+=/drives/c/\$$WINDOWS.~BT
PRUNEPATHS+=/drives/c/\$$RECYCLE.BIN


cygwin/windows.updatedb:
	-mkdir cygwin/
	updatedb --output=$@ --prunepaths="${PRUNEPATHS}" --localpaths=/drives/c/Windows 
	test -s $@

cygwin/pf86.updatedb:
	-mkdir cygwin/
	updatedb --output=$@ --prunepaths="${PRUNEPATHS}" --localpaths="/drives/c/Program?Files?\(x86\)"
	test -s $@

cygwin/pf64.updatedb:
	-mkdir cygwin/
	updatedb --output=$@ --prunepaths="${PRUNEPATHS}" --localpaths='/drives/c/Program?Files'
	test -s $@

cygwin/users.updatedb:
	-mkdir cygwin/
	updatedb --output=$@ --prunepaths="${PRUNEPATHS}" --localpaths='/drives/c/Users'
	test -s $@

cygwin/program-data.updatedb:
	-mkdir cygwin/
	updatedb --output=$@ --prunepaths="${PRUNEPATHS}" --localpaths='/drives/c/ProgramData'
	test -s $@

ifndef clean-included
include clean.mk
endif

endif # cygwin-included

