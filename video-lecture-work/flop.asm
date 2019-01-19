;program to read floppy directories using bios services

[org 0x0100]

	jmp start

sector:		times 512 db 0 			;space for directory sector
entrytime:	times 11 db 0			;space for a file name
			db 10, 13, '$'			;new line and terminating $


start:		mov ah, 0				;service 0-reset dist system
			mov dl, 0				;drive A:
			int 0x13				;BIOS disk services
			jc error 				;if error, terminate program

			mov ah, 2 				;service 2-read sector
			mov al, 1 				;count of sectors
			mov ch, 0 				;cylinder
			mov cl, 2				;sector
			mov dh, 1				;head
			mov dl, 0 				;drive A:
			mov bx, sector 			;buffer to read sector
			int 0x13				;BIOS disk service
			jc error  				;if error, terminate program

			mov bx, 0				;start from first entry

nextentry:	mov di, entryname 		;point di to space for filename
			mov si, sector 			;point si to sector
			add si, bx				;mov ahead to desired entry
			mov cx, 11				;one filename is 11 byte long
			cld 					;auto increment
			rep movsb				;copy filename

			mov ah, 9				;service 9-output string
			mov dx, entryname		;filename to be printed
			int 0x21 				;DOS service

			add bx, 32				;point to next directory 
			cmp bx, 512 			;is last entry is this sector
			jne nextentry			;no, print next entry

error		mov ax, 0x4c00			;terminate
			int 0x21		