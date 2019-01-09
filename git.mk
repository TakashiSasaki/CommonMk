
git-rev-parse-all.githash:
	unset GIT_DIR; \
	       	git rev-parse --all | uniq | tee $@
	test -s $@

git-ls-tree.txt: git-rev-parse-all.githash
	unset GIT_DIR; \
	cat $< | xargs -n 1 git -C ls-tree | tee  $@
	test -s $@

git-config:
	git config core.autocrlf input
	git config core.file true
	git config core.filemode false
	git config merge.ours.driver true
	git config merge.ours.name "Keep ours merge"
	git config pager.branch ""
	git config pager.config ""
	git config pager.diff ""
	git config pager.reflog ""

git-check-attr:
	find . | git check-attr --stdin -a
