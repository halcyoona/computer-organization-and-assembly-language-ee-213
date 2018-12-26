include irvine32.inc


.data

arr byte 2,3,5,1,6,7,9,8,12,11



.code

swap proc
push ebp
mov ebp, esp
sub esp, 4
mov esi, [ebp+8]
mov edi, [ebp+12]
mov al, [esi+edi]

xchg al, [esi+edi+1]

mov [esi+edi], al
mov esp, ebp
pop ebp
ret 8
swap endp



main proc
mov esi, offset arr
mov  ecx, 9
L1:	push ecx
	mov edi, 0
	L2:	
		mov al, [esi+edi]
		cmp al, [esi+edi+1]
		jbe next 
		push edi
		push esi
		call swap
	next:	inc edi
		loop L2
		pop ecx
		loop L1


mov ecx, 10
L3:	mov al, [esi]
	call writedec
	call crlf
	inc esi
	loop L3
exit
main endp
end main