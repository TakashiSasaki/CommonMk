ifndef builtin-included
builtin-included=1

# disable unwilling built-in rules
%: SCCS/s.%
%: RCS/%,v
%: RCS/%
%: s.%
%: %.sh
%: %,v

endif # builtin-included

