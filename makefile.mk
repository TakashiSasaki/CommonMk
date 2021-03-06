ifndef makefile-included
makefile-included=1

.PHONY: makefile-default

makefile-default: makefile-allinone.txt

define include_once
  $(info include_once $1.mk)
  ifndef $1-included
  include $1.mk
  endif
endef

$(eval $(call include_once,color))
$(eval $(call include_once,diff))
$(eval $(call include_once,diskpart))
$(eval $(call include_once,git))
$(eval $(call include_once,runas))
$(eval $(call include_once,winpath))
$(eval $(call include_once,xargs))

$(warning MAKEFILE_LIST = $(MAKEFILE_LIST))

makefile-allinone.txt:
	$(warning $@)
	cat $(MAKEFILE_LIST) >$@

endif # makefile-included

