
VK_ESCAPE		EQU		00000001bh
VK_LBUTTON		EQU		000000001h
VK_RBUTTON		EQU		000000002h

GetCursorPos                PROTO, lpPoint:DWORD
ScreenToClient              PROTO, hWnd:DWORD, lpPoint:DWORD
GetConsoleWindow            PROTO
GetKeyState                 PROTO :DWORD
extrn MessageBoxA@16 : PROC

POINTv2 STRUCT
  X   DWORD ?
  Y   DWORD ?
POINTv2 ENDS





.data
    cursorPos POINTv2 <?,?>
    hwndConsole DWORD ?
    hStdOut DWORD ?
    
    
.code 

mainMouse PROC            
    mov ecx,0
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
    
   mov ecx,1
    
ret
mainMouse endp

