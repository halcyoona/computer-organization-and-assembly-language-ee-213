;program to print hello world using interrupts

[org 0x0100]


	jmp start

message: 	db	'hello world',0

start:
			mov ah, 0x13   			;service 13-print string
			mov al, 1 				;subservice 01-update cursor 
			mov bh, 0 				;output on page
			mov bl, 7 				;normal attribute
			mov dx, 0x0A03 			;row 10 column 3
			mov cx, 11   			;length of the string
			push cs
			pop es 					;segment of the string
			mov bp, message 		;offset of the string
			int 0x10  				;call BIOS video service

			mov ax, 0x4c00 
			int 0x21