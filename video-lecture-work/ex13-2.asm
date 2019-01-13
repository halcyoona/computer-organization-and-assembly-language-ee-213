;sorting a list of ten numbers using bubble sort

[org 0x0100]

	jmp	start

data:	dw 60, 55, 45, 50, -40, -35, 25, 30, 10, 0

swap:	db 0


start:	mov bx, 0				;initialize array index to zero
		mov byte [swap], 0		;rest swap flag to no swaps

loop1:	mov ax, [data+bx]		;load number in ax
		cmp ax, [data+bx+2]		;compare with next number
		jle	noswap				;no swap if already in order

		mov dx, [data+bx+2]		;load second element in dx
		mov [data+bx+2], ax		;store first number in second
		mov [data+bx], dx		;store second number in first
		mov byte [swap], 1		;flag that a swap has been done

noswap:	add bx, 2				;advance bx to next index 
		cmp bx, 18				;are we at last index
		jne loop1				;if not compare next two

		cmp byte [swap], 1		;check if a swap has been done
		je start				;if yes make another pass

		mov ax, 0x4c00			;terminate
		int 0x21