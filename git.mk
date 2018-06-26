.PHONY: gitIgnoredFiles gitDryFetchE

gitIgnoredFiles:
	git status --ignored

gitDryFetchE:
	git fetch --dry-run /mnt/e

