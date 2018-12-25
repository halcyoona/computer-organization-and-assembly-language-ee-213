include irvine32.inc


.data

str1 byte "checking for background color",0Dh, 0Ah,0
strSpace byte 80 dup(" ")

.code 

main proc



mov eax, blue + (white * 16)
call settextcolor

mov ecx, 25

L1:	mov edx, offset strSpace
	call writestring
	loop L1
mov dh, 0
mov dl, 0
call gotoxy
mov edx, offset str1
call writestring
mov edx, offset str1
call writestring

exit
main endp
end main