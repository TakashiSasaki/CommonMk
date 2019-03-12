.PHONY: git-show-ignored git-fetch-from all.githash 
.DEFAULT_GOAL:=git-config
ifdef GIT_DIR
$(error Environment variable GIT_DIR may cause unexpected result.)
endif

all.githash:
	git rev-parse --all | sort -u | tee $@
	test -s $@

%.lstree: %.githash
	cat $< | xargs -n 1 git ls-tree -l -r --full-tree| tee  $@
	test -s $@

.PHONY: git-config
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
	git config pager.tags ""


git-check-attr-at:
	read -e -p "check attributes at : " DIRECTORY ;\
	find "$${DIRECTORY}" | git check-attr --stdin -a

git-show-ignored:
	git status --ignored

git-fetch-from:
	read -e -p "fetch from : " DIRECTORY ; \
	git fetch --dry-run "$${DIRECTORY}"

git-ignore-untracked:
	git status -s -u | sed -n -r -e 's/^\?\? (.+)/\1/p' | tee -a .gitignore

