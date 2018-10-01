[ORG 0x100]

mov al, [num1]
mov bl, [num1+1]
add al, bl
mov bl, [num1+2]
add al, bl
mov [num1+3], al

mov ax, 0x4c00
int 0x21


num1:	db	5, 10, 15, 0