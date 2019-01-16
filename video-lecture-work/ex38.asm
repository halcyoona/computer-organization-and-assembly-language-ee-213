;program to 


[org 0x0100]

	jmp	start


msg1 db 'helloworld',0
msg2 db 'Helloworld',0
msg3 db 'helloworld',0

;subroutine to calculate the length of the string
;takes the segment and offset of the string  as parameter

strlen:
				push bp
				mov bp, sp
				push es
				push cx
				push di

				les di, [bp+4]				;point es:di to string
				mov cx, 0xffff				;load maximum number in cx
				xor al, al 					;load zero in al
				repne scansb				;find zero in the string
				mov ax, 0xffff 				;load maximum number in ax
				sub ax, cx					;find change in cx
				dec ax						;exclude null from length

				pop di
				pop cx
				pop es
				pop bp
				ret 4





printstr:
				push bp
				mov bp, sp
				push es
				push ax
				push cx
				push si
				push di


				push ds
				pop es						;load ds in es
				mov di, [bp+4]				;point di to string
				mov cx, 0xffff				;load maximum number in cx
				xor al, al 					;load zero in al
				repne scansb				;find zero in the string
				mov ax, 0xffff 				;load maximum number in ax
				sub ax, cx					;find change in cx
				dec ax						;exclude null from length
				jz exit						;no printing if the string is empty

				mov cx, ax
				mov ax, 0xb800				;load video base in ax
				mov es, ax					;point es to video base
				mov al, 80					;load al with column per row
				mul byte [bp+8]				;multiply with y position
				add ax, [bp+10]				;add x position
				shl ax, 1					;turn into byte offset
				mov di, ax					;point di to required location
				mov si, [bp+4]				;point si to string
				mov cx, 					;load length of the string in cx
				mov ah, [bp+6] 				;normal attribute fixed in al

				cld							;auto increment mode
nextchar:		lodsb						;load next char in al
				stosw						;print char/attribute pair
				loop nextchar				;repeat the operation cx times

exit:
				pop di
				pop si
				pop cx
				pop ax
				pop es
				pop bp
				ret 8




start:
		mov ah, 0x10 			;service 10-vga attribute
		mov al, 03 				;subservice 03-toggle blinking
		mov bl, 1 				;enable blinking bit
		int 0x10 				;call BIOS video service

		mov ah, 0 				;service 0-get keystroke
		int 0x16  				;call BIOS keyboard service


		call clrscr 			;clear the screen

		mov ah, 0 				;service 0-get keystroke
		int 0x16  				;call BIOS keyboard service

		mov ax, 0
		push ax 				;push x position
		mov ax, 0
		push ax 				;push y position
		mov ax, 1 				;blue on black
		push ax 				;push attribute
		mov ax, msg1 
		push ax 				;push offset of the msg
		call printstr 			;print the screen


		mov ah, 0 				;service 0-get keystroke
		int 0x16  				;call BIOS keyboard service

		mov ax, 0
		push ax 				;push x position
		mov ax, 0
		push ax 				;push y position
		mov ax, 0x71 			;blue on white
		push ax 				;push attribute
		mov ax, msg2 
		push ax 				;push offset of the msg
		call printstr 			;print the screen


		mov ah, 0 				;service 0-get keystroke
		int 0x16  				;call BIOS keyboard service

		mov ax, 0
		push ax 				;push x position
		mov ax, 0
		push ax 				;push y position
		mov ax, 0xf4 			;red on white blinking
		push ax 				;push attribute
		mov ax, msg3 
		push ax 				;push offset of the msg
		call printstr 			;print the screen


		mov ah, 0 				;service 0-get keystroke
		int 0x16  				;call BIOS keyboard service

		

		mov ah, 0x4c00
		int 0x21

