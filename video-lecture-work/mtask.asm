;elementry multitasking of two thread

[org 0x0100]

		jmp start

			;	ax,bx,ip,cs flag storage area
taskstatus:	dw 	0, 0, 0, 0, 0				;task-0 regs
			dw	0, 0, 0, 0, 0 				;task-1 regs
			dw 	0, 0, 0, 0, 0 				;task-2 regs

current:	db	0 							;index of current chars
chars: 		db 	'\|/-' 						;shapes to form a bar


;one task to be multitasked

taskone: 	mov al, [chars+bx] 				;read the next shape
			mov [es:0], al 					;write at top left on the screen
			inc bx 							;increment to next shape
			and bx, 3 						;taking module by 4
			jmp taskone						;infine task


;second task to be multitasked
tasktwo:	mov al, [chars+bx]		 		;read the next shape
			mov [es:158], al 				;write at top right on the screen
			inc bx 							;increment to next shape
			and bx, 3 						;taking module by 4
			jmp tasktwo 					;infinite task


;timer interrupt service routine
timer: 		push ax
			push bx

			mov bl, [cs:current] 			;read the index of current task
			mov ax, 10 						;space used by one task
			mul bl 							;multiply to get start of task
			mov bx, ax 						;load start of task in bx

			pop ax							;read original value of bx
			mov [cs:taskstatus+bx+2], ax	;space for current task
			pop ax 							;read original value of ax
			mov [cs:taskstatus+bx+0], ax 	;space for current task
			pop ax 							;read original value of IP
			mov [cs:taskstatus+bx+4], ax 	;space for current task
			pop ax 							;read original value of CS
			mov [cs:taskstatus+bx+6], ax 	;space for current task
			pop ax							;read original value of flags
			mov [cs:taskstatus+bx+8], ax 	;space for current task
			
			inc byte [cs:current]			;update current task index
			cmp byte [cs:current], 3  		;is task index out of range
			jne skipreset  					;no, proceed
			mov byte [cs:current], 0 		;yes, reset to task 0


skipreset: 	mov bl, [cs:current]			;read index of current task
 			mov ax, 10 						;space used by one task
 			mul bl 							;multiply to get start of task
 			mov bx, ax 						;load start of task in bx


 			mov al, 0x20						;send EOI to PIC 
 			out 0x20, al 

 			push word[cs:taskstatus+bx+8] 	;flag of new task
 			push word[cs:taskstatus+bx+6]	;cs of new task
 			push word[cs:taskstatus+bx+4]	;ip of new task
 			mov ax, word[cs:taskstatus+bx+0];ax of new task
 			mov bx, word[cs:taskstatus+bx+2];bx of new task
 			iret 							;return to new task


 start: 	mov word [taskstatus+10+4], taskone 		;initilize ip
 			mov word [taskstatus+10+6], cs 				;initialize cs
 			mov word [taskstatus+10+8], 0x0200 			;initialize flags
 			mov word [taskstatus+20+4], tasktwo 		;initilize ip
 			mov word [taskstatus+20+6], cs 				;initialize cs
 			mov word [taskstatus+20+8], 0x0200 			;initialize flags
 			mov byte [current], 0 						;set current task index

 			xor ax, ax
 			mov es, ax 									;point es to IVT base

 			cli 
 			mov  word[es:8*4], timer
 			mov [es:8*4+2], cs  						;hook timer interrupt
 			mov ax, 0xb800
 			mov es, ax 									;point es to video memory
 			xor bx, bx 									;initialize bx for task
 			sti 

 			jmp $ 										;infine loop  		