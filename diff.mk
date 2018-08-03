help: left.txt right.txt
	@echo This is the help target in diff.mk.
	cat left.txt
	cat right.txt
	@echo calling diffOnlyInRight ...
	$(call diffOnlyInRight, $(word 1,$^), $(word 2,$^)) 
	@echo
	@echo calling diffOnlyInLeft ...
	$(call diffOnlyInLeft, $(word 1,$^), $(word 2,$^)) 
	@echo
	@echo calling diffInBoth ...
	$(call diffInBoth, $(word 1,$^), $(word 2,$^)) 

left.txt:
	echo -e one\nthree\nleft\nfour\nfive\nsix\nnine\nten >$@

right.txt:
	echo -e zero\none\nthree\nfour\nright\nfive\neight\nnine\nten >$@

define diffOnlyInLeft
	diff -U10 $1 $2 | tail -n +3 | sed -n -r 's/^-(.*)$$/\1/p'
endef

define diffOnlyInRight
	diff -U10 $1 $2 | tail -n +3 | sed -n -r 's/^\+(.*)$$/\1/p'
endef

define diffInBoth
	diff -U10 $1 $2 | tail -n +3 | sed -n -r 's/^ (.*)$$/\1/p'
endef

