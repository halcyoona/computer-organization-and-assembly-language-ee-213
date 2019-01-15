;program to calculate the length of the string

[org 0x0100]

	jmp	start

message:	db 'Hello World',0		;null terminated string


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


start:
				push ds
				mov ax, message
				push ax
				call strlen


				mov ax, 0x4c00
				int 0x21