;a program to add ten numbers using register + offset 

[org 0x0100]


	mov bx, 0
	mov cx, 10
	mov ax, 0

l1:	add ax, [num1+bx]
	add	bx, 2
	sub cx, 1
	jnz l1

	mov [total], ax


	mov ax, 0x4c00
	int 0x21







num1:	dw	10, 20, 30, 40, 50, 60, 70, 80, 90, 100
total:	dw	0