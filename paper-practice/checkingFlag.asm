include irvine32.inc


.data

.code

main proc
	mov ax, 0ffffh
	call dumpregs
	add ax, 0002h
	call dumpregs
	dec ax
	call dumpregs
	mov al, -127
	call dumpregs
	sub al, 2
	call dumpregs
exit
main endp
end main