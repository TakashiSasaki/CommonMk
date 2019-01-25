ifndef xargs-included
xargs-included=1
else

XARGS=$(shell which xargs.exe)
ifndef XARGS
  XARGS=$(shell which xargs)
endif
ifndef XARGS
  $(error xargs is not found)
endif

endif
