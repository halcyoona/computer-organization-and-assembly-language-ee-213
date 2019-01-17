;differentiate left and right shift keys with scancodes 
;and to terminate program with Escape "Error"


[org 0x0100]

			jmp start


;keyboard interrupt service subroutine
kbisr:
 			push ax
 			push es

 			mov ax, 0xb800
 			mov es, ax 					;point es to video memory

 			in al, 0x60 				;read char from keyboard port
 			cmp al, 0x2a 				;is the key left shift
 			jne nextcmp     			;try next comparison


 			mov byte [es:0], 'L' 		;yes, print L at top left corner
 			jmp nomatch  				;leave interrupt routine


nextcmp: 	cmp al, 0x36 				;is the key right shift
 			jne nomatch  				;no, leave interrupt routine

 			mov byte [es:0], 'R'        ;yes, print R on the top left corner


nomatch: 	mov al, 0x20 				
			out 0x20, al  				;send EOI to PIC

			pop es
			pop ax
			iret 





start:
			xor ax, ax
			mov es, ax 					;point es to IVT base 
			cli							;disable interrupt
			mov word [es: 9*4], kbisr 	;store offset at n*4
			mov word [es:9*4+2], cs 	;store segment at n*4+2
			sti 						;enable interrupts


L1: 		

			mov ah, 0  					;service 0-get  keystroke
			int 0x16 					;call BIOS keyboard service 

			cmp al, 27 					;is the is Escape pressed
			jne L1 						;if no check for the next key 


			mov ax, 0x4c00 
			int 0x21