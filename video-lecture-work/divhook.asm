
;program to hook interrupt


[org 0x0100]

	jmp	start

message:	db 'Zero divisor error',0		;null terminated string



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




;sub routine to clear the screen
clrscr:
			push es
			push ax
			push cx
			push di



			mov ax, 0xb800				;load video base in ax
			mov es, ax					;point es to video base
			mov di, di					;point di to top left column

			mov ax, 0x0720				;clear next char on screen
			mov cx, 2000				;number of screen location
			cld							;auto increment mode
			rep stow

			pop di
			pop ax
			pop cx
			pop es
			ret


;subroutine to print the a string at the top left corner
;takes address of the string 
;and also x position and y position and attribute as a parameter

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




;divide by zero interrupt handler

myisrfor0:
				push ax
				push bx
				push cx
				push dx
				push si
				push di
				push bp
				push ds
				push es

				push cs
				pop ds 						;point ds to our data segment

				call clrscr					;clear the screen

				mov ax, 30
				push ax 					;push x position
				mov ax, 20
				push ax						;push y position
				mov ax, 0x71 				;white on blue attribute
				push ax
				mov ax, message
				call printstr 				;call the print subroutine

				pop es
				pop ds
				pop bp
				pop di
				pop si
				pop dx
				pop cx
				pop bx
				pop ax
				iret 						;return from interrupt


;subroutine to generatr divide by zero error
genint0:
				mov ax, 0x8432      		;load a big number in ax
				mov bl, 2 					;use a very small divisor
				div bl 						;interrupt 0 will be generated
				ret



start:
				xor ax, ax
				mov es, ax
				mov word [es:0*4], myisrfor0   	; store offset at n*4
				mov word [es:0*4+2], cs	       	; store segment at n*4+2
				call genint0 				  	; generate interrupt 0
				


				mov ax, 0x4c00				;terminate program
				int 0x21