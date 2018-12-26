include irvine32.inc



.data

arr1 byte 'good',0
ptrw dword arr1

arr2 dword 1,2,3,4



.code

main proc

mov esi, ptrw
mov edx, esi
call writestring
call crlf


exit 
main endp
end main