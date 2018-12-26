include irvine32.inc


.data

str1 byte "checking for text color",0Dh, 0Ah,0

.code 

main proc



mov eax, blue 
call settextcolor
mov edx, offset str1
call writestring

exit
main endp
end main