include irvine32.inc


.data


str2 byte "var1 Properties",0
str3 byte "var2 Properties",0
str4 byte "var3 Properties",0
str5 byte "var4 Properties",0

str6 byte "arr1 Properties",0
str7 byte "arr2 Properties",0
str8 byte "arr3 Properties",0

str9 byte "str Properties",0



var1 byte 8
var2 word 16
var3 dword 32
var4 qword 64
arr1 byte 1,2,3,4
arr2 word 1,2,3,4
arr3 dword 1,2,3,4
str1 byte "good",0



.code

main proc


mov edx, offset str2
call writestring
call crlf
mov eax, type var1
call writedec
call crlf
mov eax,lengthof var1
call writedec
call crlf
mov eax, sizeof var1
call writedec
call crlf

call crlf
mov edx, offset str3
call writestring
call crlf
mov eax, type var2
call writedec
call crlf
mov eax,lengthof var2
call writedec
call crlf
mov eax, sizeof var2
call writedec
call crlf


call crlf
mov edx, offset str4
call writestring
call crlf
mov eax, type var3
call writedec
call crlf
mov eax,lengthof var3
call writedec
call crlf
mov eax, sizeof var3
call writedec
call crlf


call crlf
mov edx, offset str5
call writestring
call crlf
mov eax, type var4
call writedec
call crlf
mov eax,lengthof var4
call writedec
call crlf
mov eax, sizeof var4
call writedec
call crlf
call crlf



call crlf
mov edx, offset str6
call writestring
call crlf
mov eax, type arr1
call writedec
call crlf
mov eax,lengthof arr1
call writedec
call crlf
mov eax, sizeof arr1
call writedec
call crlf
call crlf


call crlf
mov edx, offset str7
call writestring
call crlf
mov eax, type arr2
call writedec
call crlf
mov eax,lengthof arr2
call writedec
call crlf
mov eax, sizeof arr2
call writedec
call crlf
call crlf



call crlf
mov edx, offset str8
call writestring
call crlf
mov eax, type arr3
call writedec
call crlf
mov eax,lengthof arr3
call writedec
call crlf
mov eax, sizeof arr3
call writedec
call crlf
call crlf


call crlf
mov edx, offset str9
call writestring
call crlf
mov eax, type str1
call writedec
call crlf
mov eax,lengthof str1
call writedec
call crlf
mov eax, sizeof str1
call writedec
call crlf
call crlf




exit
main endp
end main