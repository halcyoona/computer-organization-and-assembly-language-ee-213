include irvine32.inc


.data

str1 byte "checking bit is ON",0Dh, 0Ah,0
str2 byte "checking bit is OFF",0Dh, 0Ah,0

.code 



main proc

mov al, 0fh
bt ax, 19
jc next
mov edx, offset str2
call writestring
jmp outt
next:	mov edx, offset str1
	call writestring

outt:
exit
main endp


end main