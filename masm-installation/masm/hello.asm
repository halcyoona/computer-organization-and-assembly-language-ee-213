.model small
.stack 64h
.data
	msg db "HELLO WORLD!$"
.code
	main proc
		mov ax,@data
		mov ds,ax

		mov ah, 09h
		lea dx, msg
		int 21h
		exit:

	mov ax, 4c00h
	int 21h
	main endp

end main