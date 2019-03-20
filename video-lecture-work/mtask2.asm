;multitasking


[org 0x0100]

		jmp start

;pcb layout
;ax,bx,cx,dx,si,di,bp,sp,ip,cs,ds,ss,es,flags,next,dummy
;0, 2, 4, 6, 8, 10,12,14,16,18,20,22,24,26,   28,  30

pcb: 		times 32*16 dw 	0				;space for 32 pcb's
stack:		times 32*256 dw	0				;space for 32 512 bytes stacks
nextpcb: 	dw	1
current:	dw	0 							;index of current pcbs
lineno: 	dw 	0	 						;line number of next thread


;my task subroutine to be run as a thread
;takes line number as a parameter 
mytask: 	push bp
			mov bp, sp 						
			sub sp, 2						;thread local variables
			push ax
			push bx

			mov ax, [bp+4]					;load line number as parameter
			mov bx, 70 						;use column number 70
			mov word [bp-2], 0				;initialize local variables


printagain:	push ax							;line number
			push bx							;column number
			push word[bp-2]					;number to be printed
			call printnum 					;call print number
			inc word[bp-2]					;increment the local variable
			jmp printagain 					;infinitely print

			pop bx
			pop ax
			mov sp, bp
			pop bp
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


;subroutine to register a new thread
;takes segment, offset of the thread routine and a parameter
;for the target thread subroutine
initpcb: 		
			push bp
			mov bp, sp
			push ax
			push bx
			push cx
			push si


			mov bx, [nextpcb]			;read next avialable pcb index
			cmp bx, 32					;are all PCB's used 
			je exit 					;yes, exit 


			mov cl, 5
			shl bx, cl 					;multiply by 32 for pcb start

			mov ax, [bp+8]				;read segment parameter
			
			mov [pcb+bx+18], ax			;save in pcb space for cs
			mov ax, [bp+6] 				;read offset parameter
			mov [pcb+bp+16],ax 			;save in pcb space for ip 

			mov [pcb+bp+22], ds 		;set stack to our segment
			mov si, [nextpcb]			;read this pcb index
			mov cl, 9
			shl si, cl 					;multiply by 512
			add si, 256*2+stack 		;end of stack for this thread
			mov ax, [bp+4] 				;read parameter for subroutine
			sub si, 2 					;decrement thread stack pointer
			mov [si], ax 				;pushing param on thread stack
			sub si, 2 					;decrement thread stack pointer
			mov [pcb+bx+14], si  		;save si in pcb space for sp 

			mov word [pcb+bx+26], 0x0200;initialize thread flags
			mov ax, [pcb+28] 			;read next of 0th thread in ax
			mov [pcb+bx+28], ax			;set as next of new index
			mov ax, [nextpcb] 			;read new thread index
			mov [pcb+28], ax 			;set as next of 0th thread
			inc word [nextpcb]			;this pcb is now used

exit:
			pop si
			pop cx
			pop bx
			pop ax
			pop bp
			ret 6





;timer interrupt service routine
timer: 		push ds
			push bx

			push cs
			pop ds 							;initialize ds to data segment

			mov bx, [current]	 			;read the index of current in bx
			shl bx, 1
			shl bx, 1
			shl bx, 1
			shl bx, 1
			shl bx, 1						;multiply by 32 for pcb start
			
			mov [pcb+bx+0], ax				;save ax of current pcb
			mov [pcb+bx+4], cx 				;save cx of current pcb
			mov [pcb+bx+6], dx				;save dx of current pcb
			mov [pcb+bx+8], si				;save si of current pcb
			mov [pcb+bx+10], di				;save di of current pcb
			mov [pcb+bx+12], bp  			;save bp of current pcb
			mov [pcb+bx+24], es	 			;save es of current pcb
			

			pop ax 							;read original value of bx from stack in ax
			mov [pcb+bx+2],ax 				;save bx of current pcb
			pop ax							;read original value of ds from stack in ax
			mov [pcb+bx+20],ax				;save ds of current pcb
			pop ax							;read original value of ip from stack in ax
			mov [pcb+bx+16],ax 				;save ip of current pcb
			pop ax							;read original value of cs from stack in ax
			mov [pcb+bx+18],ax 				;save cs of current pcb
			pop ax							;read original value of flags from stack in ax
			mov [pcb+bx+26],ax				;save flags of current pcb
			mov [pcb+bx+22],ss				;save ss of current pcb
			mov [pcb+bx+14],sp				;save sp of current pcb
			
			mov bx, [pcb+bx+28]				;read next pcb of this current pcb
			mov [current], bx 				;update current to new pcb
			mov cl, 5
			shl bx, cl 						;multiply with 32 for pcb start

			mov cx, [pcb+bx+4]				;read cx of new process
			mov dx, [pcb+bx+6]				;read dx of new process
			mov si, [pcb+bx+8]				;read si of new process
			mov di, [pcb+bx+10]				;read di of new process
			mov bp, [pcb+bx+12]				;read bp of new process
			mov es, [pcb+bx+24]				;read es of new process
			mov ss, [pcb+bx+22]				;read ss of new process
			mov sp, [pcb+bx+14]				;read sp of new process

			push word[pcb+bx+26]			;push flags for new process
			push word[pcb+bx+18]			;push cs for new process
			push word[pcb+bx+16]			;push ip for new process
			push word[pcb+bx+20]			;push ds for new process



 			mov al, 0x20						;send EOI to PIC 
 			out 0x20, al 

			mov cx, [pcb+bx+0]				;read ax of new process
			mov bx, [pcb+bx+2]				;read bx of new process
			pop ds							;read ds for new process
			iret  							;return to new process


 

 start: 	xor ax, ax
 			mov es, ax 						;point es to IVT base

 			cli 
 			mov  word[es:8*4], timer
 			mov [es:8*4+2], cs  			;hook timer interrupt
 			sti 

nextkey:	xor ah, ah 						;service 0-get keystroke
			int 0x16 						;BIOS keyboard service

			push cs							;use current code segment
			mov ax, mytask
			push ax							;use mytask as offset
			push word[lineno]				;thread parameter
			call initpcb					;register the thread


			inc word [lineno]				;update line number
			jmp nextkey 
