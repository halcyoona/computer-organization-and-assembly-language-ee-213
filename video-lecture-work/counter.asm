;program to display tick count on the top right corner on the screen

[org 0x0100]


		jmp start

tickCount    dw 	0

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

				mov di, 140					;point di to 70 column 

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


;timer interrupt service routine
timer: 			push ax
				
				inc word [cs:tickCount]  	;increment tick Count
				push word [cs:tickCount]
				call printnum 				;print tick Count

				mov al, 0x20
				out 0x20, al 				;end of interrupt

				pop ax
				iret  						;return from interrupt


start:
			xor ax, ax
			mov es, ax 					;point es to IVT base 
			cli							;disable interrupt
			mov word [es: 8*4], timer 	;store offset at n*4
			mov word [es:8*4+2], cs 			;store segment at n*4+2
			sti 						;enable interrupts

			mov dx, start  				;end of resident problem
			add dx, 15
			mov cl, 14 					
			shr dx, cl 					;number as parameter

			mov ax, 0x3100  			;terminate and stay resident
			int 0x21