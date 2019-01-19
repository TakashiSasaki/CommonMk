export OSTYPE=$(shell echo $$OSTYPE)


ifeq ($(OSTYPE),cygwin)
  export NODE=$(firstword $(shell echo /drives/*/node*/node*.exe))
  export NPM=$(firstword $(shell echo /drives/*/node*/npm.cmd))
  export NPX=$(firstword $(shell echo /drives/*/node*/npx.cmd))
endif

ifeq ($(OSTYPE),msys)
  export NODE=$(firstword $(shell echo /?/node*/node*.exe))
  export NPM=$(firstword $(shell echo /?/node*/npm.cmd))
  export NPX=$(firstword $(shell echo /?/node*/npx.cmd))
endif

export NODE?=$(shell which node)
export NPM?=$(shell which npm)
export NPX?=$(shell which npx)

ifeq ($(NODE),)
  $(error Can\'t find node)
endif

$(info NODE : $(NODE))
$(info NPM : $(NPM))
$(info NPX : $(NPX))

