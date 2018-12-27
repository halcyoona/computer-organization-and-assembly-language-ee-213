
;INCLUDE Irvine32.inc
;INCLUDE Macros.inc
;INCLUDELIB user32.lib


GetKeyState PROTO, nVirtKey:DWORD


VK_LEFT		EQU		000000025h
VK_RIGHT	EQU		000000027h
maxCol1		EQU     	75
minRow1	    	EQU		4
maxRow1		EQU		23


point struct
	x byte 0
	y byte 0
point ends


box struct
	start	point <>
	endd 	point <>
box ends


.data

	strSpace byte 80 dup(" "),0
	str1 byte "You lose!",0
	col BYTE 0
	row BYTE 23
    	
    	
    	removeStick byte "     ",0
    	stick byte 220,220,220,220,220,0
    	
    	stickPosition box <<37,23>,<41,23>>
    	
    	ball point <37,20>
    	ballDirection point <1,1>
    	ballChar byte 2


.code






moveStick PROC    
       
       
        INVOKE GetKeyState, VK_LEFT
        .IF ah && stickPosition.start.x >= 2
            sub stickPosition.start.x, 2
            sub stickPosition.endd.x, 2
        .ENDIF
        
        INVOKE GetKeyState, VK_LEFT
        .IF ah && stickPosition.start.x == 1
            sub stickPosition.start.x, 1
            sub stickPosition.endd.x, 1
        .ENDIF  


        INVOKE GetKeyState, VK_RIGHT
        .IF ah && stickPosition.start.x < maxCol1
            add stickPosition.start.x, 2
            add stickPosition.endd.x, 2
        .ENDIF

        
        mov  dl, stickPosition.start.x        
        mov  dh, stickPosition.start.y        
        call Gotoxy         
       

        mov  edx, OFFSET stick          
        call Writestring    
	ret
moveStick ENDP

EraseStick PROC

        mov  dl, stickPosition.start.x        
        mov  dh, stickPosition.start.y        
        call Gotoxy         
        
        mov  edx, OFFSET removeStick     
        call Writestring     
         
    ret
EraseStick ENDP



Moveball PROC
    .IF ball.x >= (maxCol1 + 4)   ; Right Wall
        mov ballDirection.x, -1
  	.ENDIF

    .IF ball.x <= 0              ; Left Wall
        mov ballDirection.x, 1
	.ENDIF     

    .IF ball.y <= minRow1            ; Top
        mov ballDirection.y, 1
	.ENDIF  

    .IF ball.y >= maxRow1             ; Down limit
        mov ballDirection.y, -1
	.ENDIF     

    mov al, ballDirection.x
    add ball.x, al 
    mov al, ballDirection.y
    add ball.y, al 
    
    mov  dl, ball.x              ; column
    mov  dh, ball.y              ; row
    call Gotoxy                  ; Change position according to new input
        
    mov  al, ballChar          
    call WriteChar               ; Write point on new place   
    ret
moveBall ENDP



EraseBall PROC
    ; Erase Point
    mov  dl, ball.x        ; column
    mov  dh, ball.y        ; row
    call Gotoxy         ; Change position according to new input
    
    mov  al,' '     
    call WriteChar      ; Remove previous data
    ret
EraseBall ENDP

stickcolision PROC
     mov al, 0
    .IF ball.y == maxRow1
        mov dl, stickPosition.start.x 
        mov dh, stickPosition.endd.x 
        .IF ball.x >= dl && ball.x <= dh 
            mov al, 0
            
        .ELSE
            mov al, 1
        .ENDIF
    .ENDIF
    ret
stickcolision ENDP



mainMehmood proc

mov eax, green + (white * 16)
call settextcolor

mov ecx, 25

L2:	mov edx, offset strSpace
	call writestring
	loop L2



l1:

call moveStick
call moveBall
invoke sleep, 100
call stickColision
.IF al == 1
	jmp outt
.ENDIF
call EraseBall
call EraseStick
jmp l1
outt:
mov edx, offset str1
call writestring
call EraseBall
call crlf
L3: 
	jmp L3
ret
mainMehmood endp