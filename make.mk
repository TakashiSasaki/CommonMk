.PHONY: all a
MAKE_MK_DIR=make
vpath make.txt $(MAKE_MK_DIR) 
vpath make.%.txt $(MAKE_MK_DIR) 
vpath make.%.txt.except $(MAKE_MK_DIR)
vpath make.%.txt.sorted $(MAKE_MK_DIR)
VPATH=$(MAKE_MK_DIR)
.SUFFIXES: %.txt %.hoge

all: make.all.txt

make.txt:
	$(info Run make with -p option by yourself with LC_ALL=C .)
	$(info Example: LC_ALL=C make -B -n -r -R -p -d)
	-LC_ALL=C make -B -n -r -R -p -d >$(MAKE_MK_DIR)/make.txt

a: make.txt
	$(info $<)
	$(info $(<D))

make.automatic.txt: make.txt
	cat $< | sed -n -r \
		-e ': begin' \
		-e '/^# automatic.*/{' \
		-e ' hn/^[^# \t].+/{' \
		-e '  pnb begin'\
		-e ' }' \
		-e ' Gw $(MAKE_MK_DIR)/$@.except' \
		-e '}' \
		-e 'w $(MAKE_MK_DIR)/$@.except' \
		| tee $(MAKE_MK_DIR)/$@

make.automatic.txt.except: make.automatic.txt

make.environment.txt: make.automatic.txt.except
	cat $< | sed -n -r \
		-e ': begin' \
		-e '/^# environment.*/{' \
		-e ' hn/^[^# \t].+/{' \
		-e '  pnb begin'\
		-e ' }' \
		-e ' Gw $(MAKE_MK_DIR)/$@.except' \
		-e '}' \
		-e 'w $(MAKE_MK_DIR)/$@.except' \
		| tee $(MAKE_MK_DIR)/$@

make.environment.txt.except: make.environment.txt


make.default.txt: make.environment.txt.except
	cat $< | sed -n -r \
		-e ': begin' \
		-e '/^# default.*/{' \
		-e ' hn/^[^# \t].+/{' \
		-e '  pnb begin'\
		-e ' }' \
		-e ' Gw $(MAKE_MK_DIR)/$@.except' \
		-e '}' \
		-e 'w $(MAKE_MK_DIR)/$@.except' \
		| tee $(MAKE_MK_DIR)/$@

make.default.txt.except: make.default.txt

make.makefile.txt: make.default.txt.except
	cat $< | sed -n -r \
		-e ': begin' \
		-e '/^# makefile.*/{' \
		-e ' hn/^[^# \t].+/{' \
		-e '  pnb begin'\
		-e ' }' \
		-e ' Gw $(MAKE_MK_DIR)/$@.except' \
		-e '}' \
		-e 'w $(MAKE_MK_DIR)/$@.except' \
		| tee $(MAKE_MK_DIR)/$@

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
		-e 'w $(MAKE_MK_DIR)/$@.except' \
		| tee $(MAKE_MK_DIR)/$@

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
		-e 'xw $(MAKE_MK_DIR)/$@.except' \
		| tee $(MAKE_MK_DIR)/$@

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
		-e 'xw $(MAKE_MK_DIR)/$@.except' \
		| tee $(MAKE_MK_DIR)/$@

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
		-e 'xw $(MAKE_MK_DIR)/$@.except' \
		| tee $(MAKE_MK_DIR)/$@

make.unsearched.txt.except: make.unsearched.txt

make.%.txt.sorted: make.%.txt
	sort -u <$< >$(MAKE_MK_DIR)/$@

make.all.txt: \
	make.automatic.txt.sorted \
	make.environment.txt.sorted \
	make.default.txt.sorted \
	make.implicit.txt.sorted \
	make.phony.txt.sorted \
	make.searched.txt.sorted \
	make.unsearched.txt.sorted
	echo "# automatic variables" >$(MAKE_MK_DIR)/$@
	cat $(word 1,$^) >>$(MAKE_MK_DIR)/$@
	echo "# environment varibles" >>$(MAKE_MK_DIR)/$@
	cat $(word 2,$^) >>$(MAKE_MK_DIR)/$@
	echo "# default variables" >>$(MAKE_MK_DIR)/$@
	cat $(word 3,$^) >>$(MAKE_MK_DIR)/$@
	echo "# Implicit Rules" >>$(MAKE_MK_DIR)/$@
	cat $(word 4,$^) >>$(MAKE_MK_DIR)/$@
	echo "# Phony targets" >>$(MAKE_MK_DIR)/$@
	cat $(word 5,$^) >>$(MAKE_MK_DIR)/$@
	echo "# Targets with implicit rule search" >>$(MAKE_MK_DIR)/$@
	cat $(word 6,$^) >>$(MAKE_MK_DIR)/$@
	echo "# Targets without implicit rule search" >>$(MAKE_MK_DIR)/$@
	cat $(word 7,$^) >>$(MAKE_MK_DIR)/$@

%.hoge: %.txt
	cat $< >$(MAKE_MK_DIR)/$@
