include irvine32.inc


.data

num1 byte 5
num2 byte 10

.code

swap proc uses eax ecx,X:ptr byte, Y:ptr byte

mov esi, X
mov edi, Y
mov al, [esi]
xchg al, [edi]
mov [esi], al

ret
swap endp


main proc


INVOKE swap, addr num1, addr num2
mov al, num1
call writedec
mov al, num2
call writedec



exit
main endp
end main