.DEFAULT_GOAL=init-random-file
tmprnd:=$(shell mktemp)
define check-random-file
	$(info function check-random-file start)
	$(eval random-file:=$(shell ls -l | sed -r -n -e 's/.+ .+ .+ .+ .+ .+ .+ ([0-9a-fA-F]{40}.random)$$/\1/p'))
	$(info found $(random-file))
	$(if $(word 2,$(random-file)),$(error Two or more random files))
	$(info function check-random-file end)
endef
	
define create-random-file
	$(info function create-random-file start)
	dd if=/dev/random bs=4096 count=1 of=$(tmprnd)
	test -s $(tmprnd)
	mv $(tmprnd) `git hash-object $(tmprnd)`.random
	$(info function create-random-file end)
endef

.PHONY: check-random-file
check-random-file:
	$(info target check-random-file)
	$(call check-random-file)	

.PHONY: create-random-file
create-random-file:
	$(info target create-random-file)
	$(call $@)

.PHONY: init-random-file
init-random-file:
	$(info target init-random-file start)
	$(call check-random-file)
	$(if $(random-file),,$(call create-random-file))
	$(info target init-random-file end)
	git hash-object $(random-file)

.PHONY: delete-random-file
delete-random-file:
	$(call check-random-file)
	-rm $(random-file)
