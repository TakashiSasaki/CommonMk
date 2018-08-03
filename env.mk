help:
	@echo This is help target in env.mk.
	@echo Including env.mk provides the following variables.
	@echo ROOT=$(ROOT)
	@echo USER=$(USER)
	@echo HOST=$(HOST)
	@echo URI=$(URI)
	@echo URIMD5=$(URIMD5)
	@echo OUTDIR=$(OUTDIR)
	@echo MAKE_HOST=$(MAKE_HOST)

ifndef ROOT
  ifdef HOME
    ROOT=$(HOME)
  else
    $(error ROOT and HOME are empty or not set.)
  endif
endif

ifndef USER
  USER=$(shell whoami)
endif

ifndef HOST
  ifdef HOSTNAME
    HOST=$(HOSTNAME)
  else
    ifdef COMPUTERNAME
      HOST=$(COMPUTERNAME)
    else
      ifdef NAME
        HOST=$(NAME)
      else
        HOST=$(shell hostname)
      endif
    endif
  endif
endif


