.PHONY: updatedb

PRUNEPATHS+=/drives/c/\$$WINDOWS.~BT
PRUNEPATHS+=/drives/c/\$$RECYCLE.BIN

updatedb: windows.updatedb pf86.updatedb pf64.updatedb users.updatedb pd.updatedb

windows.updatedb:
	updatedb --output=$@ --prunepaths="${PRUNEPATHS}" --localpaths=/drives/c/Windows 

pf86.updatedb:
	updatedb --output=$@ --prunepaths="${PRUNEPATHS}" --localpaths="/drives/c/Program?Files?\(x86\)"

pf64.updatedb:
	updatedb --output=$@ --prunepaths="${PRUNEPATHS}" --localpaths='/drives/c/Program?Files'

users.updatedb:
	updatedb --output=$@ --prunepaths="${PRUNEPATHS}" --localpaths='/drives/c/Users'

pd.updatedb:
	updatedb --output=$@ --prunepaths="${PRUNEPATHS}" --localpaths='/drives/c/ProgramData'

