ifndef builtin-included
builtin-included:=1

.DEFAULT_GOAL:=builtin-default
.PHONY: builtin-default
builtin-default:
	@echo No default target in builtin.mk.

# disable unwilling built-in rules
%: SCCS/s.%
%: RCS/%,v
%: RCS/%
%: s.%
%: %.sh
%: %,v

endif # builtin-included

