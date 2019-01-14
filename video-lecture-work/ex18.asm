;bubble sort algorithm as a subroutine

[org 0x0100]

	jmp	start

data:	dw 60, 55, 45, 50, 40, 35, 25, 30, 10, 0
swap:	db 0


bubblesort:	dec cx					;last element is not compared
			shl cx, 1				;turn into byte count

mainloop:	mov si, 0				;initialize array index to zero
			mov byte [swap], 0		;reset  swap flag to no swap

innerloop:	mov ax, [bx+si]			;load number in ax 
			cmp bx, [bx+si+2]		;compare with next number
			jbe noswap				;if not compare next two


			mov dx, [si+bx+2]		;load second element in dx
			mov [si+bx], dx			;store second number in first
			mov [si+bx+2], ax		;store first number in second
			mov byte [swap], 1		;flag that a swap has been done



noswap:		add si, 2				;advance si to next index
			cmp si, cx				;are we at last index
			jne innerloop			;if not compare next two

			cmp byte [swap], 1		;check if the swap has been done
			je mainloop				;if yes make another pass

			ret 					;go back where we came from 

		
start:
		mov bx, data				;send start of array in bx
		mov cx, 10					;send count of element in cx
		call bubblesort				;call our subroutine

		mov ax, 0x4c00			;terminate
		int 0x21