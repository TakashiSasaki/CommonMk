.PHONY:
make.unsearched.txt.except: make.unsearched.txt

include ../win.mk
include ../git.mk
include ../clean.mk

make.txt:
	LC_ALL=C make -B -n -r -R -p -s >$@

make.automatic.txt: make.txt
	cat $< | sed -n -r \
		-e ': begin' \
		-e '/^# automatic/{' \
		-e ' hn/^[^# \t].+/{' \
		-e '  Hgpnb begin'\
		-e ' }Hg' \
		-e '}' \
		-e 'w $@.except' \
		| tee $@

make.automatic.txt.except: make.automatic.txt

make.environment.txt: make.automatic.txt.except
	cat $< | sed -n -r \
		-e ': begin' \
		-e '/^# environment/{' \
		-e ' hn/^[^# \t].+/{' \
		-e '  Hgpnb begin' \
		-e ' }' \
		-e '}' \
		-e 'w $@.except' \
		| tee $@

make.environment.txt.except: make.environment.txt


make.default.txt: make.environment.txt.except
	cat $< | sed -n -r \
		-e ': begin' \
		-e '/^# default/{' \
		-e ' hn/^[^# \t].+/{' \
		-e '  Hgpnb begin' \
		-e ' }' \
		-e '}' \
		-e 'w $@.except' \
		| tee $@

make.default.txt.except: make.default.txt

make.makefile.txt: make.default.txt.except
	cat $< | sed -n -r \
		-e ': begin' \
		-e '/^# makefile.*/{' \
		-e ' hn/^[^# \t].+/{' \
		-e '  Hgpnb begin' \
		-e ' }' \
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
