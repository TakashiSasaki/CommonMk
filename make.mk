#!/bin/make -f 
ifndef make-included
make-included:=1

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)builtin.mk

#.SUFFIXES: .txt
.DEFAULT_GOAL:=make-default

.PHONY: make-default
make-default::
	git clean -qfdx *.mk.*.except
	git clean -qfdx *.mk.automatic
	git clean -qfdx *.mk.debug
	git clean -qfdx *.mk.default
	git clean -qfdx *.mk.implicit
	git clean -qfdx *.mk.makefile
	git clean -qfdx *.mk.phony
	git clean -qfdx *.mk.searched
	git clean -qfdx *.mk.unsearched

make-default:: \
	$(patsubst %.mk,%.mk.debug,$(wildcard *.mk)) \
	$(patsubst %.mk,%.mk.automatic,$(wildcard *.mk)) \
	$(patsubst %.mk,%.mk.environment,$(wildcard *.mk)) \
	$(patsubst %.mk,%.mk.default,$(wildcard *.mk)) \
	$(patsubst %.mk,%.mk.makefile,$(wildcard *.mk)) \
	$(patsubst %.mk,%.mk.implicit,$(wildcard *.mk)) \
	$(patsubst %.mk,%.mk.phony,$(wildcard *.mk)) \
	$(patsubst %.mk,%.mk.searched,$(wildcard *.mk)) \
	$(patsubst %.mk,%.mk.unsearched,$(wildcard *.mk))

%.mk.debug: %.mk
	@#-LC_ALL=C $(MAKE) -n -f $< -r -R -p -d >$@
	@# -r : no builtin rules
	@# -R : no builtin variables
	-LC_ALL=C $(MAKE) -n -f $< -p -d >$@

%.mk.automatic %.mk.automatic.except: %.mk.debug
	@cat $< | sed -n -r \
		-e ': begin' \
		-e '/^# automatic.*/{' \
		-e ' hn/^[^# \t].+/{' \
		-e '  pnb begin'\
		-e ' }' \
		-e ' Gw $(patsubst %.except,%,$@).except' \
		-e '}' \
		-e 'w $(patsubst %.except,%,$@).except' >$(patsubst %.except,%,$@)

%.mk.environment %.mk.environment.except: %.mk.automatic.except
	@cat $< | sed -n -r \
		-e ': begin' \
		-e '/^# environment.*/{' \
		-e ' hn/^[^# \t].+/{' \
		-e '  pnb begin'\
		-e ' }' \
		-e ' Gw $(patsubst %.except,%,$@).except' \
		-e '}' \
		-e 'w $(patsubst %.except,%,$@).except' >$(patsubst %.except,%,$@)

%.mk.default %.mk.default.except: %.mk.environment.except
	@cat $< | sed -n -r \
		-e ': begin' \
		-e '/^# default.*/{' \
		-e ' hn/^[^# \t].+/{' \
		-e '  pnb begin'\
		-e ' }' \
		-e ' Gw $(patsubst %.except,%,$@).except' \
		-e '}' \
		-e 'w $(patsubst %.except,%,$@).except' >$(patsubst %.except,%,$@)

%.mk.makefile %.mk.makefile.except: %.mk.default.except
	@cat $< | sed -n -r \
		-e ': begin' \
		-e '/^# makefile.*/{' \
		-e ' hn/^[^# \t].+/{' \
		-e '  pnb begin'\
		-e ' }' \
		-e ' Gw $(patsubst %.except,%,$@).except' \
		-e '}' \
		-e 'w $(patsubst %.except,%,$@).except' >$(patsubst %.except,%,$@)

%.mk.implicit %.mk.implicit.except: %.mk.makefile.except
	@cat $< | sed -n -r \
		-e ': begin' \
		-e '/^# Implicit Rules/{' \
		-e ' : loop' \
		-e ' /^#.[0-9]+.implicit rules,.+terminal.+/b begin' \
		-e ' n/^[^# \t].+/p' \
		-e ' b loop' \
		-e '}' \
		-e 'w $(patsubst %.except,%,$@).except' >$(patsubst %.except,%,$@)

%.mk.phony %.mk.phony.except: %.mk.implicit.except
	@cat $< | sed -n -r \
		-e ': begin' \
		-e '/^#  Phony target.+/{' \
		-e ' xpx' \
		-e ' : skip' \
		-e ' nh/^[# \t].+/{' \
		-e '  b skip' \
		-e ' }' \
		-e ' b begin' \
		-e '}' \
		-e 'xw $(patsubst %.except,%,$@).except' >$(patsubst %.except,%,$@)

%.mk.searched %.mk.searched.except: %.mk.phony.except
	@cat $< | sed -n -r \
		-e ': begin' \
		-e '/^#  Implicit rule search has not been done.+/{' \
		-e ' xpx' \
		-e ' : skip' \
		-e ' nh/^[# \t].+/{' \
		-e '  b skip' \
		-e ' }' \
		-e ' b begin' \
		-e '}' \
		-e 'xw $(patsubst %.except,%,$@).except' >$(patsubst %.except,%,$@)

%.mk.unsearched %.mk.unsearched.except: %.mk.searched.except
	@cat $< | sed -n -r \
		-e ': begin' \
		-e '/^#  Implicit rule search has been done.+/{' \
		-e ' xpx' \
		-e ' : skip' \
		-e ' nh/^[# \t].*/{' \
		-e '  b skip' \
		-e ' }' \
		-e ' b begin' \
		-e '}' \
		-e 'xw $(patsubst %.except,%,$@).except' >$(patsubst %.except,%,$@)

# make.%.txt.sorted: make.%.txt
# 	sort -u <$< >$@
# 
# make.all.txt: \
# 	make.automatic.txt.sorted \
# 	make.environment.txt.sorted \
# 	make.default.txt.sorted \
# 	make.implicit.txt.sorted \
# 	make.phony.txt.sorted \
# 	make.searched.txt.sorted \
# 	make.unsearched.txt.sorted
# 	echo "# automatic variables" >$@
# 	cat $(word 1,$^) >>$@
# 	echo "# environment varibles" >>$@
# 	cat $(word 2,$^) >>$@
# 	echo "# default variables" >>$@
# 	cat $(word 3,$^) >>$@
# 	echo "# Implicit Rules" >>$@
# 	cat $(word 4,$^) >>$@
# 	echo "# Phony targets" >>$@
# 	cat $(word 5,$^) >>$@
# 	echo "# Targets with implicit rule search" >>$@
# 	cat $(word 6,$^) >>$@
# 	echo "# Targets without implicit rule search" >>$@
# 	cat $(word 7,$^) >>$@

endif # make-included

