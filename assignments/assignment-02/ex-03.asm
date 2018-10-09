include irvine32.inc

.DATA
a REAL4 3.0
b REAL4 7.0
cc REAL4 2.0
posx REAL4 0.0
negx REAL4 0.0

.CODE 
Main proc
;slove the quadratic equation

fld1
fadd st, st
fld st
fmul a


fmul st(1), st
fxch
fmul cc

fld b
fmul st, st
fsubr

fsqrt
fld b
fchs
fxch

fld st
fadd st, st(2)
fxch
fsubp st(2), st

fdiv st, st(2)
fstp posx
fdivr
fstp negx

exit
Main endp
End Main