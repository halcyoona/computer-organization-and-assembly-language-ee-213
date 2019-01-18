;show scan code on external LED's connected through parallel port

[org 0x0100]

	jmp start

oldisr:  	dd 	0


;keyboard interrupt service routine
kbisr:		
			push ax
			push dx

			in al, 0x60 				;read char from keyboard port
			mov dx, 0x378 				
			out dx, al 					;write char  to parallel port

			pop dx
			pop ax
			jmp far [cs:oldisr]








start:
			xor ax, ax
			mov es, ax 					;point es to IVT base 
			mov ax, [es:9*4] 			
			mov [oldisr], ax 			;saving offset of old routine
			mov ax, [es:9*4+2]
			mov [oldisr+2], ax
			cli							;disable interrupt
			mov word [es: 9*4], kbisr 	;store offset at n*4
			mov word [es:9*4+2], cs 	;store segment at n*4+2
			sti 						;enable interrupts

			mov dx, start  				;end of resident problem
			add dx, 15
			mov cl, 14 					
			shr dx, cl 					;number as parameter

			mov ax, 0x3100  			;terminate and stay resident
			int 0x21