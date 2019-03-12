.PHONY: random-default make-random-file check-random-file
tmprnd:=$(shell mktemp)
RNDFILE:=$(shell ls -l | sed -r -n -e 's/.+ .+ .+ .+ .+ .+ .+ ([0-9a-fA-F]+).random$$/\1/p')

define init-random-file
	$(info get-random-file start)
	random-file:=$(shell ls -l | sed -r -n -e 's/.+ .+ .+ .+ .+ .+ .+ ([0-9a-fA-F]+).random$$/\1/p')
	$(info get-random-file end)
endef


random-default: check-random-file

make-random-file: 
	dd if=/dev/random bs=4096 count=1 of=$(tmprnd)
	test -s $(tmprnd)
	mv $(tmprnd) `md5sum $(tmprnd) | sed -n -r -e 's/^([0-9a-fA-F]+).*/\1/p'`.random

check-random-file:
	$(info eval start)
	$(eval $(call init-random-file))
	$(info eval end)
	echo $(random-file)
