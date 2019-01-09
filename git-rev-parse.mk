SHOW_DESCRIPTION=false

GIT_REV_PARSE_SHOW_TARGETS=\
	git-rev-parse-local-env-vars \
	git-rev-parse-git-dir \
	git-rev-parse-absolute-git-dir \
	git-rev-parse-git-common-dir \
	git-rev-parse-is-inside-git-dir \
	git-rev-parse-is-inside-work-tree \
	git-rev-parse-is-bare-repository \
	git-rev-parse-is-shallow-repository \
	git-rev-parse-show-cdup \
	git-rev-parse-show-prefix \
	git-rev-parse-show-toplevel \
	git-rev-parse-show-superproject-working-tree \
	git-rev-parse-shared-index-path


.PHONY: git-rev-parse-show-all ${GIT_REV_PARSE_SHOW_TARGETS}

git-rev-parse-show-all: ${GIT_REV_PARSE_SHOW_TARGETS}

git-rev-parse-local-env-vars:
	@echo $@
	@if [ ${SHOW_DESCRIPTION} == true ]; then echo 'List the GIT_* environment variables that are local to the repository (e.g. GIT_DIR or GIT_WORK_TREE, but not GIT_EDITOR). Only the names of the variables are listed, not their value, even if they are set.'; fi
	git rev-parse --local-env-vars

git-rev-parse-git-dir:
	@echo $@
	@if [ ${SHOW_DESCRIPTION} == true ]; then echo 'Show $$GIT_DIR if defined. Otherwise show the path to the .git directory. The path shown, when relative, is relative to the current working directory. If $$GIT_DIR is not defined and the current directory is not detected to lie in a Git repository or work tree print a message to stderr and exit with nonzero status.'; fi
	git rev-parse --git-dir

git-rev-parse-absolute-git-dir:
	@echo $@
	git rev-parse --absolute-git-dir

git-rev-parse-git-common-dir:
	@echo $@
	git rev-parse --git-common-dir

git-rev-parse-is-inside-git-dir:
	@echo $@
	git rev-parse --is-inside-git-dir

git-rev-parse-is-inside-work-tree:
	@echo $@
	git rev-parse --is-inside-work-tree

git-rev-parse-is-bare-repository:
	@echo $@
	git rev-parse --is-bare-repository

git-rev-parse-is-shallow-repository:
	@echo $@
	git rev-parse --is-shallow-repository

git-rev-parse-show-cdup:
	@echo $@
	git rev-parse --show-cdup

git-rev-parse-show-prefix:
	@echo $@
	git rev-parse --show-prefix

git-rev-parse-show-toplevel:
	@echo $@
	git rev-parse --show-toplevel

git-rev-parse-show-superproject-working-tree:
	@echo $@
	git rev-parse --show-superproject-working-tree

git-rev-parse-shared-index-path:
	@echo $@
	git rev-parse --shared-index-path

