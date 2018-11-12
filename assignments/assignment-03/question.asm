include irvine16.inc

;program to take string input using interrupts in 16bit


.data
	input byte "input a string  :  $"
	space byte "                   $"
	msg byte "Mehmood!$"
.code
	main proc
		mov ax,@data
		mov ds,ax
		
		mov ah, 09h
		mov dx, offset input
		int 21h
		
		mov ah, 0Ah
		int 21h
		
		

		mov ah, 09h
		mov dx, offset msg
		int 21h
		
		mov ah, 09h
		mov dx, offset space
		int 21h
		exit
	main endp
end main
