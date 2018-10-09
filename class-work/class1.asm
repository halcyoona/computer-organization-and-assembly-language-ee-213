include irvine32.inc

.data
arrayW	Dword 1,2,3

.code
Main proc
mov eax, [arrayW+4]
mov ebx, [arrayW+8]
xchg arrayW, eax
xchg ebx, eax
mov arrayW+4, ebx
mov arrayW+8, eax

mov eax, arrayW
call writedec

mov eax, arrayW+4
call writedec

mov eax, arrayW+8
call writedec
exit
Main endp
End Main