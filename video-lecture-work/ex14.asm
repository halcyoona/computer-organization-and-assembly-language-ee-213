;4bit multiplication program

[org 0x0100]

multiplicand:  	db  13					;4bit multiplicand
multiplier:		db	5					;4bit multiplier
result:			db	0					;8bit result


start:
			mov cl, 4					;initialize counter with 4
			mov bl, [multiplicand]		;load multiplicand in bl
			mov dl, [multiplier]		;load multiplier in dl


checkbit:								
			shr dl, 1					;move rightmost bit in carry flag
			jnc skip 					;skip addition if bit is not zero


			add [result], bl			;accumulate result


skip:		
			shl bl, 1					;shift multiplicand left
			dec cl						;decrement bit count
			jnz checkbit				;repeat if bits left


			mov ax, 0x4c00				;terminate
			int 0x21