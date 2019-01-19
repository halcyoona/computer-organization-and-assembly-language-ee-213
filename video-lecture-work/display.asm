;character input using dos service

[org 0x0100]

		jmp start

maxlength:	dw	80 						;maximum length of input
message: 	db 	10, 13, 'hello $'		;greeting message 
buffer: 	times 81 db 0 				;space for input string

start:		mov cx, [maxlength]			;load maximum length in cx
			mov si, buffer 				;point si to start of buffers

nextchar:	mov ah, 1					;service 1-read character
			int 0x21  					;dos service


			cmp al, 13  				;is enter pressed
			je exit 					;yes, leave input 
			mov [si], al 				;no, save this character
			inc si 						;increment buffer pointer
			loop nextchar 				;repeat for next input char

exit:		mov byte[si], '$'			;append $ to user input

			mov dx, message 			;greeting message 
			mov ah, 9					;service 9-write string
			int 0x21 					;dos services


			mov dx, buffer  			;user input buffer
			mov ah, 9 					;service 9- write string
			int 0x21 					;dos services

			mov ax, 0x4c00				;terminate program
			int 0x21