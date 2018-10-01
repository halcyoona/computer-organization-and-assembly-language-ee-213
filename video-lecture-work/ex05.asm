[ORG 0x100]

mov ax, [num1]
mov [num1+6], ax 
mov ax, [num1+2]
add [num1+6], ax
mov ax, [num1+4]
add [num1+6], ax

mov ax, 0x4c00
int 0x21


num1:	dw	5, 10, 15, 0