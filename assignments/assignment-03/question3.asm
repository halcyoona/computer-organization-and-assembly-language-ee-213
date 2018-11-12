include irvine32.inc

;program to take string input using interrupts in 32bit


.data
	input byte "input a string  :  $"
	space byte "                   $"
	msg byte "Mehmood!$"
.code
	main proc
		
		mov ah, 09h
		mov edx, offset input
		int 21h
		
		mov ah, 0Ah
		int 21h
		
		

		mov ah, 09h
		mov edx, offset msg
		int 21h
		
		mov ah, 09h
		mov edx, offset space
		int 21h
		exit
	main endp
end main
