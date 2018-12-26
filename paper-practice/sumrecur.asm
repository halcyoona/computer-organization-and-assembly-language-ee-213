include irvine32.inc


.data


.code


sumrecur proc
push ebp
mov ebp, esp

mov ecx, [ebp+8]
cmp ecx, 0

je next
dec ecx
push ecx
call sumrecur
mov ecx, [ebp+8]
add eax, ecx

next:	
mov esp, ebp
pop ebp
ret 4
sumrecur endp


main proc

xor eax, eax
push 10

call sumrecur

call writedec
call crlf
exit
main endp
end main
