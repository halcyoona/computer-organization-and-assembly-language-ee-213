;disable keyboard interrupt in PIC mask register

[org 0x0100]

in al, 0x20     ; read interrupt mask register
or al, 2        ; set bit for irq2
out 0x20, al    ; write back mask register

mov ax, 0x4c00  ; terminate program
int 0x21