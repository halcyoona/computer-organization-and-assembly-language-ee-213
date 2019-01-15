;program to scroll down


[org 0x0100]

	jmp	start

;subroutine to scroll down the screen n lines
;take n, number of lines to scroll as parameter

scrollDown:		
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
				push ax 			;save position for later use
				mov cx, 2000		;number of screen location
				sub cx, ax			;count of words to move
				shl ax, 1			;convert to byte offset
				
				mov si, 3998		;last location on the screen
				sub si, ax 			;load source position in si

				mov ax, 0xb800
				mov es, ax			;point es to video base
				mov ds, ax			;point ds to video base
				mov di, 3998		;point di to top left corner
				std 				;set auto decrement mode
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
		call scrollDown

		mov ah, 0x4c00
		int 0x21

