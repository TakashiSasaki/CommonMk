ifndef XARGS
$(error XARGS should be set to non-busybox xargs.)
endif

%.md5sum: %.files
	cat $< | ($(XARGS) -L1 -I{} md5sum {}) | tee $@

cd.md5sum:
	find . -type f| xargs md5sum >$@

%.ldjson: %.md5sum
	cat $< 	| jq -R -c 'split("  ")|{"md5":.[0],"path":.[1]}' >$@

