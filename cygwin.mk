.PHONY: cygwin
PRUNEPATHS+=/drives/c/\$$WINDOWS.~BT
PRUNEPATHS+=/drives/c/\$$RECYCLE.BIN

CYGWIN_UPDATEDB=\
	windows \
	pf86 \
	pf64 \
	users \
	pd

cygwin: $(addsuffix .updatedb,$(addprefix cygwin/,${CYGWIN_UPDATEDB}))
	-mkdir cygwin/

cygwin/windows.updatedb:
	-mkdir cygwin/
	updatedb --output=$@ --prunepaths="${PRUNEPATHS}" --localpaths=/drives/c/Windows 

cygwin/pf86.updatedb:
	-mkdir cygwin/
	updatedb --output=$@ --prunepaths="${PRUNEPATHS}" --localpaths="/drives/c/Program?Files?\(x86\)"

cygwin/pf64.updatedb:
	-mkdir cygwin/
	updatedb --output=$@ --prunepaths="${PRUNEPATHS}" --localpaths='/drives/c/Program?Files'

cygwin/users.updatedb:
	-mkdir cygwin/
	updatedb --output=$@ --prunepaths="${PRUNEPATHS}" --localpaths='/drives/c/Users'

cygwin/pd.updatedb:
	-mkdir cygwin/
	updatedb --output=$@ --prunepaths="${PRUNEPATHS}" --localpaths='/drives/c/ProgramData'

clean::
	-rm -rf cygwin/

