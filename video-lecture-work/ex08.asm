[ORG 0x100]


mov bx, num1
mov cx, 5
mov ax, 0

l1:	add ax, [bx]
	add bx, 2
	sub cx, 1
	jnz l1

	mov [total], ax

	mov ax, 0x4c00
	int 0x21

num1:	dw	5,10,15,20,25
total:	dw	0