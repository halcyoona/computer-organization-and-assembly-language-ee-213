;swap and bublesort subroutine saving and restoring values

[org 0x0100]

	jmp	start

data:	dw 60, 55, 45, 50, 40, 35, 25, 30, 10, 0
swapFlag:	db 0


swap:
			push ax
			mov ax, [si+bx]			;load first element in ax
			xchg ax, [bx+si+2]		;xchange with the second number
			mov [si+bx], ax			;store second number in first
			pop ax
			ret



bubblesort:	
			push ax
			push cx
			push si
			dec cx					;last element is not compared
			shl cx, 1				;turn into byte count

mainloop:	mov si, 0				;initialize array index to zero
			mov byte [swapFlag], 0	;reset  swap flag to no swap

innerloop:	mov ax, [bx+si]			;load number in ax 
			cmp bx, [bx+si+2]		;compare with next number
			jbe noswap				;if not compare next two

			call swap 				;swap two element
			mov byte[swapFlag], 1	;flag that a swap has been done


noswap:		add si, 2				;advance si to next index
			cmp si, cx				;are we at last index
			jne innerloop			;if not compare next two

			cmp byte [swapFlag], 1	;check if the swap has been done
			je mainloop				;if yes make another pass

			pop si
			pop cx
			pop ax
			ret 					;go back where we came from 

		
start:
		mov bx, data				;send start of array in bx
		mov cx, 10					;send count of element in cx
		call bubblesort				;call our subroutine

		mov ax, 0x4c00			;terminate
		int 0x21