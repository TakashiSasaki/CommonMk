#!/bin/make -f 
ifndef git-included
git-included:=1

ifdef GIT_DIR
$(error Environment variable GIT_DIR may cause unexpected result.)
endif

.DEFAULT_GOAL=git-default
.PHONY: git-default
git-default:
	@echo No default target

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

.PHONY: git-show-ignored
git-show-ignored:
	git status --ignored

.PHONY: git-fetch-from
git-fetch-from:
	read -e -p "fetch from : " DIRECTORY ; \
	git fetch --dry-run "$${DIRECTORY}"

git-ignore-untracked:
	git status -s -u | sed -n -r -e 's/^\?\? (.+)/\1/p' | tee -a .gitignore

current-git-branch:=$(shell git branch | sed -n -r -e "s/^\* (.+)$$/\1/p")
$(info current git branch = $(current-git-branch))

global.gitconfig: FORCE
	$(eval tmp-git-config:=$(shell mktemp))
	-git config -l --global >$(tmp-git-config)
	touch $@
	cat $@ >> $(tmp-git-config)
	sort -u $(tmp-git-config) | tee $@

system.gitconfig: FORCE
	$(eval tmp-git-config:=$(shell mktemp))
	-git config -l --system>$(tmp-git-config)
	touch $@
	cat $@ >> $(tmp-git-config)
	sort -u $(tmp-git-config) | tee $@

local.gitconfig: FORCE
	$(eval tmp-git-config:=$(shell mktemp))
	-git config -l --local>$(tmp-git-config)
	touch $@
	cat $@ >> $(tmp-git-config)
	sort -u $(tmp-git-config) | tee $@

.PHONY: FORCE
FORCE:

endif # git-included

