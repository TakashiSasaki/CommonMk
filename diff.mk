ifndef diff-included
diff-included=1
.PHONY: diff-default

diff-default: test.leftonly test.rightonly test.both 
	cat test.leftonly
	cat test.rightonly
	cat test.both

test.left:
	for x in {1..10}; do echo `expr $$x \* 2`; done >$@

test.right:
	for x in {1..10}; do echo `expr $$x \* 3`; done >$@

%.leftonly: %.left %.right
	$(call diff-leftonly, $(word 1,$^), $(word 2,$^)) >$@

%.rightonly: %.left %.right
	$(call diff-rightonly, $(word 1,$^), $(word 2,$^)) >$@

%.both: %.left %.right
	$(call diff-both, $(word 1,$^), $(word 2,$^)) >$@

ifndef clean-included
include clean.mk
endif

define diff-leftonly
	diff -U10 $1 $2 | tail -n +3 | sed -n -r 's/^-(.*)$$/\1/p'
endef

define diff-rightonly
	diff -U10 $1 $2 | tail -n +3 | sed -n -r 's/^\+(.*)$$/\1/p'
endef

define diff-both 
	diff -U10 $1 $2 | tail -n +3 | sed -n -r 's/^ (.*)$$/\1/p'
endef

endif # diff-included

