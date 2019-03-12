ifndef make-included
make-included=1

.PHONY: make-default
.SUFFIXES: .txt

make-default: make.all.txt

make.txt:
	$(info Run make with -p option by yourself with LC_ALL=C .)
	$(info Example: LC_ALL=C make -B -n -r -R -p -d)
	-LC_ALL=C $(MAKE) -B -n -r -R -p -d >make.txt

make.automatic.txt: make.txt
	cat $< | sed -n -r \
		-e ': begin' \
		-e '/^# automatic.*/{' \
		-e ' hn/^[^# \t].+/{' \
		-e '  pnb begin'\
		-e ' }' \
		-e ' Gw $@.except' \
		-e '}' \
		-e 'w $@.except' \
		| tee $@

make.automatic.txt.except: make.automatic.txt

make.environment.txt: make.automatic.txt.except
	cat $< | sed -n -r \
		-e ': begin' \
		-e '/^# environment.*/{' \
		-e ' hn/^[^# \t].+/{' \
		-e '  pnb begin'\
		-e ' }' \
		-e ' Gw $@.except' \
		-e '}' \
		-e 'w $@.except' \
		| tee $@

make.environment.txt.except: make.environment.txt


make.default.txt: make.environment.txt.except
	cat $< | sed -n -r \
		-e ': begin' \
		-e '/^# default.*/{' \
		-e ' hn/^[^# \t].+/{' \
		-e '  pnb begin'\
		-e ' }' \
		-e ' Gw $@.except' \
		-e '}' \
		-e 'w $@.except' \
		| tee $@

make.default.txt.except: make.default.txt

make.makefile.txt: make.default.txt.except
	cat $< | sed -n -r \
		-e ': begin' \
		-e '/^# makefile.*/{' \
		-e ' hn/^[^# \t].+/{' \
		-e '  pnb begin'\
		-e ' }' \
		-e ' Gw $@.except' \
		-e '}' \
		-e 'w $@.except' \
		| tee $@

make.makefile.txt.except: make.makefile.txt

make.implicit.txt: make.makefile.txt.except
	cat $< | sed -n -r \
		-e ': begin' \
		-e '/^# Implicit Rules/{' \
		-e ' : loop' \
		-e ' /^#.[0-9]+.implicit rules,.+terminal.+/b begin' \
		-e ' n/^[^# \t].+/p' \
		-e ' b loop' \
		-e '}' \
		-e 'w $@.except' \
		| tee $@

make.implicit.txt.except: make.implicit.txt

make.phony.txt: make.implicit.txt.except
	cat $< | sed -n -r \
		-e ': begin' \
		-e '/^#  Phony target.+/{' \
		-e ' xpx' \
		-e ' : skip' \
		-e ' nh/^[# \t].+/{' \
		-e '  b skip' \
		-e ' }' \
		-e ' b begin' \
		-e '}' \
		-e 'xw $@.except' \
		| tee $@

make.phony.txt.except: make.phony.txt

make.searched.txt: make.phony.txt.except
	cat $< | sed -n -r \
		-e ': begin' \
		-e '/^#  Implicit rule search has not been done.+/{' \
		-e ' xpx' \
		-e ' : skip' \
		-e ' nh/^[# \t].+/{' \
		-e '  b skip' \
		-e ' }' \
		-e ' b begin' \
		-e '}' \
		-e 'xw $@.except' \
		| tee $@

make.searched.txt.except: make.searched.txt

make.unsearched.txt: make.searched.txt.except
	cat $< | sed -n -r \
		-e ': begin' \
		-e '/^#  Implicit rule search has been done.+/{' \
		-e ' xpx' \
		-e ' : skip' \
		-e ' nh/^[# \t].*/{' \
		-e '  b skip' \
		-e ' }' \
		-e ' b begin' \
		-e '}' \
		-e 'xw $@.except' \
		| tee $@

make.unsearched.txt.except: make.unsearched.txt

make.%.txt.sorted: make.%.txt
	sort -u <$< >$@

make.all.txt: \
	make.automatic.txt.sorted \
	make.environment.txt.sorted \
	make.default.txt.sorted \
	make.implicit.txt.sorted \
	make.phony.txt.sorted \
	make.searched.txt.sorted \
	make.unsearched.txt.sorted
	echo "# automatic variables" >$@
	cat $(word 1,$^) >>$@
	echo "# environment varibles" >>$@
	cat $(word 2,$^) >>$@
	echo "# default variables" >>$@
	cat $(word 3,$^) >>$@
	echo "# Implicit Rules" >>$@
	cat $(word 4,$^) >>$@
	echo "# Phony targets" >>$@
	cat $(word 5,$^) >>$@
	echo "# Targets with implicit rule search" >>$@
	cat $(word 6,$^) >>$@
	echo "# Targets without implicit rule search" >>$@
	cat $(word 7,$^) >>$@

endif # make-included

