

.data

;PlayerName byte "Ahsan",0
bufSize = ($-PlayerName)

errMsg BYTE "Cannot open file",0dh,0ah,0
filename     BYTE "gamefile.dat",0
fileHandle   DWORD ?	; handle to output file
byteCount    DWORD ?    	; number of bytes written
bytesWritten DWORD ?
.code
GetPlayerName PROC
	INVOKE CreateFile,
	  ADDR filename, GENERIC_READ, DO_NOT_SHARE, NULL,
	  OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0

	mov fileHandle,eax		; save file handle
	.IF eax == INVALID_HANDLE_VALUE
        mov eax, 0
        ret
	.ENDIF

	INVOKE ReadFile,		; read text to file
	    fileHandle,		; file handle
	    ADDR PlayerName,		; PlayerName pointer
	    21,		; number of bytes to write
	    ADDR byteCount,		; number of bytes written
	    0		; overlapped execution flag

	INVOKE CloseHandle, fileHandle

	mov esi,byteCount		; insert null terminator
	mov PlayerName[esi],0		; into PlayerName  
	mTextColor Red
    	mov edx,offset PlayerName
    	call WriteString
    	call crlf
    ret
GetPlayerName ENDP

PutPlayerName PROC
    INVOKE CreateFile,
	  ADDR filename, GENERIC_WRITE, DO_NOT_SHARE, NULL,
	  CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0

	mov fileHandle,eax		; save file handle
	.IF eax == INVALID_HANDLE_VALUE
        mov eax, 0
        ret
	.ENDIF

	INVOKE WriteFile,		; write text to file
	    fileHandle,		; file handle
	    ADDR PlayerName,		; PlayerName pointer
	    bufSize,		; number of bytes to write
	    ADDR bytesWritten,		; number of bytes written
	    0		; overlapped execution flag

	INVOKE CloseHandle, fileHandle
    ret
PutPlayerName ENDP

DeleteGameFile PROC
;    Invoke DeleteFile, OFFSET filename
    ret
DeleteGameFile ENDP

;MAIN proc

;call GetPlayerName

;call PutPlayerName

;call DeleteGameFile

;exit
;main endp
;end main