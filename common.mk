ifndef common-included
common-included:=1
.DELETE_ON_ERROR:
.EXPORT_ALL_VARIABLES:


.DEFAULT_GOAL:=common-default
common-default:
	@echo No default target in common.mk.

OSTYPE:=$(shell echo $$OSTYPE)

endif # common-included

