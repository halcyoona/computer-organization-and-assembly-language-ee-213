[ORG 0x100]

mov bx, num1
mov ax, [bx]

add bx, 2
add ax, [bx]
add bx, 2
add ax, [bx]
add bx, 2
mov [bx], ax

mov ax, 0x4c00
int 0x21


num1:	dw	5, 10, 15, 0