%.find: %.dir %.prune
	echo -n find \"`cat $(firstword $^)`\"\  | tee $@ 
	cat "$(lastword $^)" \
		| sed -n  -r -e '/^.+/i -name "' -e '/^.+/p' -e '/^.+/a " -prune -o ' -e '$$a -print' \
		| tr -d "\n\r" \
		| tee -a $@

cd.dirs: 
	find . -type d | sed -n -r 's/^.\/(.+)$$/\1/p' >$@
	head $@; tail $@

cd.files: 
	find . -type f | sed -n -r 's/^.\/(.+)$$/\1/p' >$@
	head $@; tail $@

cd.dir:
	pwd | tr -d '\n\r\t' >$@
	grep '^/' $@ 
	test -s $@

