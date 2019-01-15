;program to 


[org 0x0100]

	jmp	start


msg1 db 'helloworld',0
msg2 db 'Helloworld',0
msg3 db 'helloworld',0

;subroutine to calculate the length of the string
;takes the segment and offset of the string  as parameter

strlen:
				push bp
				mov bp, sp
				push es
				push cx
				push di

				les di, [bp+4]				;point es:di to string
				mov cx, 0xffff				;load maximum number in cx
				xor al, al 					;load zero in al
				repne scansb				;find zero in the string
				mov ax, 0xffff 				;load maximum number in ax
				sub ax, cx					;find change in cx
				dec ax						;exclude null from length

				pop di
				pop cx
				pop es
				pop bp
				ret 4



;subroutine to check the string are same or not
;takes 4 parameters 
;source segment and offset of the string
;destination segment and offet of the string
;return 1 in ax if equal other wise 0 in ax

strcmp:		
				push bp
				mov bp, es
				push cx
				push si
				push di
				push es
				push ds
				
				lds si, [bp+4]    	;point ds:si to first string
				les di, [bp+8] 		;point es:di to second string

				push ds 			;push segment of first string
				push si 			;push offset of first string
				call strlen			;calculate the string length
				mov cx, ax

				push es  			;push segment of second string
				push di 			;push offset of second string
				call strlen 		;calculate the string length

				cmp cx, ax 			;compare both the length
				jne exitFalse 		;return 0 if the not equal

				mov ax, 1 			;store 1 in ax to be returned
				repe cmpsb 			;compare both string
				jcxz exitSimple    	;are they successfully compared

exitFalse: 		mov ax, 0   		;store 0 in ax

exitSimple:
				pop ds
				pop es
				pop di
				pop si
				pop di
				pop cx
				pop bp
				ret 4


start:
		push ds 
		mov ax, msg1
		push ax
		push ds
		mov ax, msg2
		push ax
		call strcmp

		push ds
		mov ax, msg1
		push ax
		push ds
		mov ax, msg3
		push ax
		call strcmp
		

		mov ah, 0x4c00
		int 0x21

