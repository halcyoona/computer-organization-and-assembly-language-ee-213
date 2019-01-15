
;program to print Number on screen


[org 0x0100]

	jmp	start



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


;subroutine to print the a number at the top left corner


printnum:
				push bp
				mov bp, sp
				push es
				push ax
				push bx
				push cx
				push dx
				push di


				mov ax, 0xb800				;load video base in ax
				mov es, ax					;point es to video base						
				mov ax, [bp+4]				;load number in ax
				mov bx, 10					;load base 10 for divition
				mov cx, 0					;initialize count of digits
				mov ah, 0x07 				;normal attribute fixed in al

nextdigit:		mov dx, 0					;zero upper half of dividend
				div bx						;divided by 10
				add dl, 30					;convert into ascii value
				push dx						;save ascii value on stack
				inc cx						; increment count
				cmp ax, 0					;is the quotient is zero
				jnz nextdigit				;if no divided it again

				mov di, 0					;point di to top left corner

nextpos:		pop dx						;remove the digit from the stack
				mov dh, 0x07 				;use normal attribute
				mov [es:di], dx				;show this char on screen
				add di, 2					;mov to next char location
				loop nextpos				;repeat the operation cx times

				pop di
				pop dx
				pop cx
				pop bx
				pop ax
				pop es
				pop bp
				ret 2


start:
				call clrscr

				mov ax, 4529
				push ax						;push number on stack
				call printnum 				;call the print subroutine


				mov ax, 0x4c00				;terminate program
				int 0x21