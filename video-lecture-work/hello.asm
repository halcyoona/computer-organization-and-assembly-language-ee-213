
;program to print Hello world on screen


[org 0x0100]

	jmp	start

message:	db 'Hello World'		;string to be printed on screen
length:		db 11					;length of the string 


;sub routine to clear the screen
clrscr:
			push es
			push ax
			push di



			mov ax, 0xb800				;load video base in ax
			mov es, ax					;point es to video base
			mov di, 0					;point di to top left column

nextloc:


			mov word[es:di], 0x0720		;clear next char on screen
			add di, 2					;mov to next screen location
			cmp di, 4000				;has the whole screen clear
			jne nextloc					;if no clear next postion


			pop di
			pop ax
			pop es
			ret


;subroutine to print the a string at the top left corner
;takes address of the string and length as a parameter

printstr:
				push bp
				mov bp, sp
				push es
				push ax
				push cx
				push si
				push di


				mov ax, 0xb800				;load video base in ax
				mov es, ax					;point es to video base
				mov di, 0
				mov si, [bp+6]				;point si to string
				mov cx, [bp+4]				;load length of the string in cx
				mov ah, 0x07 				;normal attribute fixed in al

nextchar:		mov al, [si]				;load next char of the string
				mov [es:di], ax				;show this char on screen
				add di, 2					;mov to next char location
				add si, 1					;mov to next char in string
				loop nextchar				;repeat the operation cx times

				pop di
				pop si
				pop cx
				pop ax
				pop es
				pop bp
				ret 4


start:
				call clrscr

				mov ax, message
				push ax						;push string address
				push word [length]			;push message lenth
				
				call printstr 				;call the print subroutine


				mov ax, 0x4c00				;terminate program
				int 0x21