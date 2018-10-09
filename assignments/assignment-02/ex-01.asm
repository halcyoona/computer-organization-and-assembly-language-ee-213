include irvine32.inc

.DATA
down REAL4	10.35
across REAL4	13.07
status Real4	?

.CODE
Main proc
fld across
fmul down
fstp status
mov eax, status
call writedec 
exit
Main endp
End Main