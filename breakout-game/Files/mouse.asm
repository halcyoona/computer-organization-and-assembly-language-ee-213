include Irvine32.inc
INCLUDE Macros.inc 
INCLUDELIB Kernel32.lib
INCLUDELIB User32.Lib
;INCLUDE     GraphWin.inc

VK_ESCAPE		EQU		00000001bh
VK_LBUTTON		EQU		000000001h
VK_RBUTTON		EQU		000000002h

DeleteFile PROTO lpFileName:DWORD
SetTextColor PROTO
Beep PROTO dwFreq:DWORD, dwDuration:DWORD

GetCursorPos                PROTO, lpPoint:DWORD
ScreenToClient              PROTO, hWnd:DWORD, lpPoint:DWORD
GetConsoleWindow            PROTO
GetKeyState                 PROTO :DWORD
extrn MessageBoxA@16 : PROC

POINTv2 STRUCT
  X   DWORD ?
  Y   DWORD ?
POINTv2 ENDS

POINT STRUCT
	x       BYTE ?
	y       BYTE ?
    color   DWORD ? ; color
POINT ENDS

RECT STRUCT
  left      DWORD ?
  top       DWORD ?
  right     DWORD ?
  bottom    DWORD ?
RECT ENDS

.data
    gameNameStr    BYTE    "AsmBreakout v1.0", 0
    clsText        BYTE     80 DUP(' '), 0
    PlayerName     BYTE    51 DUP(?)

    cursorPos POINTv2 <?,?>
    hwndConsole DWORD ?
    hStdOut DWORD ?
    screen RECT <>
    
    ExitMsg BYTE "Have a good day!",0
.code 

; Collecting team source
;Include Files\procedures.
;include misc\misc.asm

main PROC            
    invoke SetConsoleTitle, ADDR gameNameStr
	
   
    ;mov speed1, 30
    ;call FrontName
    
    INVOKE  GetConsoleWindow
    mov     hwndConsole,eax
   
    INVOKE  GetStdHandle,STD_OUTPUT_HANDLE
    mov     hStdOut,eax
    mouseCheck:
         INVOKE GetCursorPos, ADDR cursorPos
         INVOKE ScreenToClient, hwndConsole, ADDR cursorPos
         .IF cursorPos.X > 60 && cursorPos.X < 252 && cursorPos.Y > 190 && cursorPos.Y < 223
            INVOKE  GetKeyState,VK_LBUTTON
            .IF ah
                mov eax, BLUE
                call SetTextColor
            .ELSE
                mov eax, GRAY
                call SetTextColor
            .ENDIF
            mGotoxy 8, 16
            mWrite "-----------------------"
            mGotoxy 8, 17
            mWrite "| CLICK HERE TO START |"
            mGotoxy 8, 18
            mWrite "-----------------------"
            INVOKE  GetKeyState,VK_LBUTTON
            .IF ah 
                jmp mouseEnd
            .ENDIF
        .ELSE 
            mov eax, YELLOW
            call SetTextColor
            mGotoxy 8, 16
            mWrite "-----------------------"
            mGotoxy 8, 17
            mWrite "| CLICK HERE TO START |"
            mGotoxy 8, 18
            mWrite "-----------------------"
        .ENDIF   
        
        INVOKE Sleep, 20
        
    jmp mouseCheck
    mouseEnd:
 
    call Clrscr
    
    ;call setBoundries
    
    mov eax, YELLOW
    call SetTextColor
    mGotoxy 30, 10
    mWrite "Mouse Clicked"
    call crlf
    call crlf
    
exit
main endp
END main
