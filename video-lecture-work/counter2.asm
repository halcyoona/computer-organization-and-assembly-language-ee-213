;program to display tick count on the top right corner on the screen 
;while left shift key is pressed

[org 0x0100]


		jmp start

second		dw 	0
timerFlag   dw 	0
oldkb 		dd  0

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



;keyboard interrupt service subroutine
kbisr:
 			push ax
 			

 			in al, 0x60 				;read char from keyboard port
 			cmp al, 0x2a 				;is the key left shift
 			jne nextcmp     			;try next comparison

 			cmp word [cs:timerFlag], 1 	;is the flag already set 
 			je exit 					;yes, leave the ISR 

 			mov word [cs:timerFlag], 1 	;set the flag to start printing

 			jmp exit 	  				;leave interrupt routine



nextcmp2: 	cmp al, 0xaa 				;has the left shift released
			jne nomatch 				;no, chain to old ISR 

			mov word [cs:timerFlag], 0 	;reset flag to stop printing
			jmp exit

nomatch: 	 	

			pop ax
			jmp far [cs:oldkb] 			;call the original ISR 
			;iret

exit: 		mov al, 0x20 
			out 0x20, al 				;send EOI to PIC 

			pop ax
			iret 						;return from interrupt





;timer interrupt service routine
timer: 			push ax
				
				cmp word[cs:timerFlag], 1 	;is the timer flag is set
				jne skipall 				;no leave the ISR 

				inc word [cs:second]  	 	;increment tick Count
				push word [cs:second]
				call printnum 				;print tick Count

skipall:
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