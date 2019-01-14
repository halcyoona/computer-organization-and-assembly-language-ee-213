;16bit multiplication program

[org 0x0100]

multiplicand:  	dd  13					;32bit multiplicand
multiplier:		dw	5					;16bit multiplier
result:			dd	0					;32bit result


start:
			mov cl, 16					;initialize counter with 16
			mov bx, 1					;load multiplier in dx


checkbit:								
			test bx, [multiplier]		;move rightmost bit in carry flag
			jz skip 					;skip addition if bit is not zero

			mov ax, [multiplicand]
			add [result], ax
			mov ax, [multiplicand+2]
			add [result+2], ax			;accumulate result


skip:		
			shl word [multiplicand], 1	
			rcl word [multiplicand+2], 1  	;shift multiplicand left
			shl bx, 1						;shift mask toward next bit
			dec cl						 	;decrement bit count
			jnz checkbit				  	;repeat if bits left


			mov ax, 0x4c00				;terminate
			int 0x21