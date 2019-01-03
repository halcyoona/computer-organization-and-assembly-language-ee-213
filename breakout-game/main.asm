Include Irvine32.inc
Include Macros.inc
;Includelib Kernal32.lib
Includelib user32.lib

NewLine MACRO 
	call crlf
	call crlf
	call crlf
ENDM
print MACRO msg
	mov edx,offset msg
	call writeString
ENDM
.data
	gameNameStr byte "COAL Project  Breakout Game   (Instructor : Tehseen Khan)",0
	;==========================
	;    DrawBoundries Data
	;==========================
	bars_bound BYTE 178,0
	bars_top BYTE 0
	bars_bottom BYTE 79
	bars_right BYTE 1
	bars_left BYTE 19 
	speed_bars_hor DWORD 10
	speed_bars_ver DWORD 20
	;==========================
	;     End DrawBoundries Data
	;==========================
	
	; s_menutextborders data
	inc_bars2 BYTE ?
	bars_star BYTE "0",0
	chk byte 1
	uBorder byte "-----------------------------",0h
.code
Include Files\frontscreen.asm
Include Files\procedures.inc
Include Files\functions.inc
Include Files\mouseui.inc
Include Files\fileHandle.inc

	main proc
	invoke SetConsoleTitle, ADDR gameNameStr
	call DrawBoundries
	call FrontName
	
	NewLine
	mov eax,YELLOW
	call SetTextColor
	
	mGotoxy 17, 20

	
	
	;call clrscr
	
	
	call mainMouse	;for MouseClick
	.IF ecx		; check if mouse is clicked
		call Developers
	.ENDIF
	exit
	main endp
End main

