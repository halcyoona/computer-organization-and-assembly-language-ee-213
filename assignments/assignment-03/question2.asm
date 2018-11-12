include irvine32.inc
;.model small
;.stack 64h

;program to take a single character input in 32bit using interrupts


.data
	char byte ?
	input byte "intput character:   $"
	output byte "       charater entered is :  $"
	space byte "         $"
.code
	main proc
		
		mov ah, 09h
		mov edx, offset input
		int 21h
		
		mov ah, 01h
		int 21h
		mov char, al
		
		mov ah, 09h
		mov edx, offset output
		int 21h
		
		mov ah, 02h
		mov dl, char
		int 21h
		
		
		mov ah, 09h
		mov edx, offset space
		int 21h
		
		mov ax, 4c00h
		int 21h
	main endp

end main
