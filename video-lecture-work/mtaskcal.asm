;program to show my multitask kernel interrupt


[org 0x0100]

		jmp start

paramblock: 	dw	0,0,0,0,0


;my task subroutine to be run as a thread
;takes line number as a parameter 
mytask: 	push bp
			mov bp, sp 						
			sub sp, 2						;thread local variables
			push ax
			push bx

			mov ax, [bp+6]					;load line number as parameter
			mov bx, 70 						;use column number 70
			mov word [bp-2]					;initialize local variables


printagain:	push ax							;line number
			push bx							;column number
			push word[bp-2]					;number to be printed
			call printnum 					;call print number
			inc word[bp-2]					;increment the local variable
			jmp printagain	 				;infinitely print

			pop bx
			pop ax
			mov sp, bp
			pop bp
			retf

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



start: 			mov ah, 0					;service 0-get keystroke
				int 0x16					;BIOS keyboard service

				mov word [paramblock+0],cs 		;code segment parameter
				mov word [paramblock+2],mytask	;offset parameter
				mov word [paramblock+4],ds 		;data segment parameter
				mov word [paramblock+6],es		;extra segment parameter
				mov word [paramblock+8],ax 		;parameter for thread
				mov si, paramblock				;address of param block in si
				int 0x80 						;multitasking kernel interrupt

				inc word [lineno] 				;update lineno
				jmp start						;wait for next key