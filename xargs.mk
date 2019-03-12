.PHONY: xargs-default
xargs-default:
	@echo XARGS = $(XARGS)

ifndef xargs-included
xargs-included=1

XARGS=$(shell which xargs.exe)
ifndef XARGS
  XARGS=$(shell which xargs)
endif
ifndef XARGS
  $(error xargs is not found)
endif

endif # xargs-included

