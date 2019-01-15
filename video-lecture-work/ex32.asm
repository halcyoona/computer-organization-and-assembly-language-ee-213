;program to scroll up


[org 0x0100]

	jmp	start

;subroutine to scroll up the screen n lines
;take n, number of lines to scroll as parameter

scrollUp:		
				push bp
				mov bp, es
				push ax
				push cx
				push si
				push di
				push es
				push ds

				mov ax, 80			;load chars per row in ax
				mul byte[bp+4]		;calculate the source position
				mov si, ax			;load source position to si
				push si 			;save position for later use
				shl si, 1			;convert to byte offset
				mov cx, 2000		;number of screen location
				sub cx, ax			;count of words to move
				mov ax, 0xb800
				mov es, ax			;point es to video base
				mov ds, ax			;point ds to video base
				xor di, di			;point di to top left corner
				cld 				;set auto increment
				rep movsw			;scroll up
				mov ax, 0x0720		;space in normal attribute
				pop cx				;count of position to clear
				rep stow			;clear the scrolled space


				pop ds
				pop es
				pop di
				pop si
				pop cx
				pop ax
				pop bp
				ret 2


start:
		mov ax, 2
		push ax
		call scrollUp

		mov ah, 0x4c00
		int 0x21

