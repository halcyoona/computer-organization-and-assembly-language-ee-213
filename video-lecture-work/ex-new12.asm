;differentiate left and right shift keys with scancodes 
;and to terminate program with Escape "success"
;restore previous interrupt
;remove when key is released

[org 0x0100]

			jmp start

oldisr 	dd 	0  							;space for saving old isr


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
 			jmp exit 	  				;leave interrupt routine


nextcmp: 	cmp al, 0x36 				;is the key right shift
 			jne nextcmp2	  				;no, leave interrupt routine

 			mov byte [es:0], 'R'        ;yes, print R on the top left corner
 			jmp exit

nextcmp2: 	cmp al, 0xaa 				;has the left shift released
			jne nextcmp3 				;no, try next comparison


			mov byte [es:0], ' ' 		;yes, clear the first column
			jmp exit


nextcmp3: 	cmp al, 0xb6 				;has the right shift released
			jne nomatch 				;no, try next comparison


			mov byte [es:0], ' ' 		;yes, clear the first column
			jmp exit




nomatch: 	 	

			pop es
			pop ax
			jmp far [cs:oldisr] 		;call the original ISR 
			;iret

exit: 		mov al, 0x20 
			out 0x20, al 				;send EOI to PIC 

			pop es
			pop ax
			iret 						;return from interrupt




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
			mov cl, 4 					
			shr dx, cl 					;number as parameter

			mov ax, 0x3100  			;terminate and stay resident
			int 0x21

