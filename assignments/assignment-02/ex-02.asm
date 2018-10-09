include irvine32.inc

.DATA
diamtr REAL4	12.93
status Word	?

.CODE
Main proc
fld1
fadd st, st
fdiv diamtr
fmul st, st
fldpi
fmul
exit
Main endp
End Main