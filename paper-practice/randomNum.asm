include irvine32.inc


.data


.code 

main proc

mov ecx, 5

L1:	mov eax, 100
	call randomrange
	call writedec
	call crlf
	loop L1


exit
main endp
end main