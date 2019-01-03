;Include Irvine32.inc
;Include Macros.inc

;====================================================	Functions
	; mainMenue
	; setBoundries
	; printWall		;called from DarwBoundries
	; DrawBoundries
	; Developers
	; MainCloud
	; GamePaused
	; Movement
;====================================================   Macro to set text Color

;||||||||||||||||||||||||||||||||||||||||||||||||||||
mTextColor MACRO color
	push eax
	mov ax,color
	call SetTextColor
	pop eax
ENDM
;||||||||||||||||||||||||||||||||||||||||||||||||||||
DelayPro MACRO val
	push eax
	mov eax,val
	call Delay
	pop eax
ENDM
;||||||||||||||||||||||||||||||||||||||||||||||||||||	Struct for cloud
Cloud STRUCT
	info byte ?
	Xaxis byte ?
	Yaxis byte ?
Cloud ENDS
;||||||||||||||||||||||||||||||||||||||||||||||||||||
EscapeKey EQU 01bh

;      Data   Segment
;||||||||||||||||||||||||||||||||||||||||||||||||||||
;||||||||||||||||||||||||||||||||||||||||||||||||||||
.data							
	
	PlayerName byte 20 Dup(?)
	speed byte 0
	score byte 0
	Lives byte 3
	LiveChar byte 3,0
	maxCol 	EQU 79
	maxRow  EQU 20
	TopWall EQU "================================================================================"
	LeftWall EQU 254
	
	x byte 0
	
	;-----------------------------------;  mainCloud
	
	Clud byte 254,0
	;obj Cloud <,,>			; Struct Object
	arr Cloud 320 Dup(<,,>)		; an array of Struct type
	chk1 byte 1
	chkIn Byte 0 	; for gamePaused input char
	
;====================================================
;=	         Code Segment		            =
;||||||||||||||||||||||||||||||||||||||||||||||||||||
;||||||||||||||||||||||||||||||||||||||||||||||||||||
.code
Include Files\rules.asm
;Include Files\functions.inc
GetKeyState PROTO NVirtKey:Dword
;====================================================
;	DrawCloud
;====================================================
DrawCloud proc
	call ClrScr
	mov esi,0
	mov dl,0
	mov dh,0
	mov al,"="
		
	.WHILE dh<4
		mov dl,0
		.WHILE dl<80
			mov (Cloud PTR arr[esi]).Xaxis,dl
			mov (Cloud PTR arr[esi]).Yaxis,dh
			mov (Cloud PTR arr[esi]).info,al
			add esi,TYPE Cloud
			inc dl
		.ENDW
		inc dh
	.ENDW
	;;;;;;;;;;;;;call mainCloud
	ret
DrawCloud endp


;====================================================
;	DrawOneTime
;====================================================
DrawOnetime proc
	mov esi,0
	mov edx,0
	.WHILE ecx<320
		mov dl,(Cloud PTR arr[esi]).Xaxis
		mov dh,(Cloud PTR arr[esi]).Yaxis
		call GotoXY
		mov al,(Cloud PTR arr[esi]).info
		.If ecx < 78		; Cloud coloring
			mTextColor Yellow
		.ENDIF
		.If ecx > 79 && ecx < 160	
			mTextColor Green
		.ENDIF
		.IF ecx<240 && ecx>=160
			mTextColor Red
		.ENDIF
		.IF ecx>=240
			mTextColor White
		.ENDIF
		.if al == "="
			mov edx,0
			mov edx,offset Clud
			call WriteString	
		.ENDIF
		add esi,TYPE Cloud
		inc ecx
	.ENDW
	call moveStick
	call moveBall
ret
DrawOnetime endp
;====================================================
;	mainCloud
;====================================================
mainCloud Proc
	L1:
	call ClrScr
	gLabel::
	mov ecx,0
	mov esi,0
	mov edx,0
	.WHILE ecx<320
		mov dl,(Cloud PTR arr[esi]).Xaxis
		mov dh,(Cloud PTR arr[esi]).Yaxis
		call GotoXY
		mov al,(Cloud PTR arr[esi]).info
		.If ecx < 78		; Cloud coloring
			mTextColor Yellow
		.ENDIF
		.If ecx > 79 && ecx < 160	
			mTextColor Green
		.ENDIF
		.IF ecx<240 && ecx>=160
			mTextColor Red
		.ENDIF
		.IF ecx>=240
			mTextColor White
		.ENDIF
		.if al == "="
			mov edx,0
			mov edx,offset Clud
			call WriteString	
		.ENDIF
		add esi,TYPE Cloud
		inc ecx
	.ENDW
	L41:: mTextColor Gray
	mGoTOXY 57,23
	mWrite "Press ESC to Pause ..."
	Invoke GetKeyState,EscapeKey
	.If ah
		mov bl,0
		mov chk1,bl
		jmp L2
	.Endif
	mGotoXY 5,23
	mWrite "Score: "
	mGotoXY 11,23
	mTextColor Red
	movzx eax,score
	call WriteInt
	mTextColor Gray
	mGotoXY 25,23
	mWrite "Lives: "
	;call DrawLives	; to draw number of lives
	push edx	;  to print number of lives	
		mTextColor Red
		mov edx,offset LiveChar
		mGotoXY 33,23
		mWrite "    "
		mGotoXY 33,23
		mov cl,Lives
		.WHILE cl>0
			call WriteString
			dec cl
		.ENDW
	pop edx
	
	mTextColor Gray
	mov bl,1
	mov chk1,bl
	mTextColor Green
	call Movement		; call ball and stick movement finctions
	
	;
	cmp chk1,1
	je L41
	jmp L3
	L2:
	call GamePaused
	L3: mGoToXY 49,22
	ret
mainCloud endp


;====================================================
;	DrawLives
;====================================================
DrawLives proc
	
	ret
DrawLives endp
;====================================================
;	StartGame
;====================================================
StartGame proc
	
	mov al,3
	mov Lives,al
	mov al,0
	mov score,al
	xor eax,eax
	xor ebx,ebx
	xor edx,edx
	xor ecx,ecx
	call resetPosition
	call DrawCloud
	call DrawOnetime
	
	call mainMouse	;for MouseClick
	
	.IF ecx		; check if mouse is clicked
		call mainCloud
	.ENDIF
	ret
StartGame endp




;====================================================
;	Movement
;====================================================
Movement proc
	call moveStick
	call moveBall
	push eax
	movzx eax,speed
	Invoke	Delay 
	pop eax
	call StickColision
		
	.IF al==1
		mov bl,0
		mov chk1,bl
		.IF Lives == 0
			call resetPosition
			call GameOver	
		.ELSE
			dec Lives
			mTextColor Yellow
			mGotoXY 25,12
			call WaitMsg
			mGotoXY 25,12
			mWrite "                                          "
			mTextColor Green
			call EraseBall
			call EraseStick
			jmp L41
		.Endif
	.Endif
	
	call EraseBall
	call EraseStick
	push eax
	movzx eax, ball.y
	.IF eax <= 3
		call cloudColision
		inc score
		inc score
	.ENDIF
	pop eax
	
	ret
Movement endp





;====================================================
;	GameOver
;====================================================
GameOver proc
	call ClrScr
	call DrawBoundries
	mGoToXY 29,4
	mTextColor Yellow
	mWrite "<<<< "
	mGoToXY 45,4
	mWrite "  >>>>"
	mTextColor Red
	mGoToXY 35,4
	mWrite "GAME OVER!"
	
	mGotoXY 34,6
	mTextColor Gray
	DelayPro 170
	mWrite "Score : "
	movzx eax,score
	call WriteInt	
	mGotoXY 30,9
	DelayPro 170
	mWrite "1) Restart    -> r"
	mGoToXY 30,10
	DelayPro 170
	mWrite "2) Main Menue -> m"
	mGoToXY 30,11
	DelayPro 170
	mWrite "3) Exit Game  -> e"
	mGotoXY 30,13
	mTextColor Green
	DelayPro 170
	mWrite "Choose :"
	call readchar
	.IF al=="r"
		call StartGame
	.ENDIF
	.IF al=="m"
		call mainMenue
	.ENDIF
	.IF al== "e"
		call ExitGamefun
	.ENDIF
	ret
GameOver endp




;====================================================
;	ExitGame
;====================================================
ExitGamefun proc
	jmp G2Label	; this albel is in Rules function
	ret
ExitGamefun endp




;====================================================
;	GamePaused
;====================================================
GamePaused Proc
	call ClrScr
	mov chkIn,0	; for char input
	call DrawBoundries
	
	mGoToXY 33,2
	mWrite "BREAKOUT GAME"
	mov eax,WHITE
	call SetTextColor
	mGoToXY 33,4
	mWrite " Game Paused "
	
	mTextColor YELLOW
	mTextColor WHITE
	mGoToXY 34,9
	mWrite "OPTIONS"
	mTextColor YELLOW
	mGoToXY 34,10
	mWrite "1) Resume     -> r"
	mGoToXY 34,11
	mWrite "2) Main Menue -> m"
	mGoToXY 34,12
	mWrite "3) Restart    -> s"
	mGoToXY 34,13
	mWrite "4) Exit       -> e"
	L12:mGoToXY 34,14
	mTextColor Yellow
	mWrite "Choose: "
	call readChar
	.IF al=="r"	; Resume
		mov chkIn,1
		call ClrScr
		mTextColor Gray
		mGotoXY 25,12
		call WaitMsg
		call ClrScr
		jmp gLabel
	.EndIF
	.IF al=="m"	; mainMenue
		mov chkIn,1
		call mainMenue	
	.EndIF
	.IF al=="s"	; Restart
		mov chkIn,1
		call resetPosition
		call StartGame
	.EndIF
	.IF al=="e"	; Exit
		mov chkIn,1
		call ClrScr
		call ExitGamefun
	.EndIF
	.IF chkIn != 1
		mov chkIn,0
		mGOTOXY 22,21
		mTextColor RED
		mWrite "Please Choose Correct Option!"
		jmp L12
	.EndIf
	ret
GamePaused endp



;====================================================
;	SetBoundries
;====================================================
setBoundries proc
	mov eax,YELLOW
	call SetTextColor
	call PrintWall
	
	mov dl,0
	mov dh,23
	call GoToXY
	ret
setBoundries endp



;====================================================
;	MainMenue
;====================================================
mainMenue proc
	call ClrScr
	call DrawBoundries
	
	mGoToXY 33,2
	mWrite "BREAKOUT GAME"
	mov eax,WHITE
	call SetTextColor
	mGoToXY 34,5
	mWrite " MAIN MENUE "
	mov eax,YELLOW
	call SetTextColor
	mGoToXY 34,7
	mWrite "Enter Name :"
	mov edx,offset PlayerName
	mov ecx,lengthof PlayerName
	call readString
		call PutPlayerName
		;mov edx,0
		;call GetPlayerName
	
	mov eax,WHITE
	call SetTextColor
	mGoToXY 34,9
	mWrite "Level"
	;mov eax,YELLOW
	mTextColor YELLOW
	mGoToXY 34,10
	mWrite "1) Basic  -> b"
	mGoToXY 34,11
	DelayPro 170
	mWrite "2) Normal -> n"
	mGoToXY 34,12
	DelayPro 170
	mWrite "3) Expert -> e"
	mGoToXY 34,13
	mWrite "Choose: "
	L1:call readChar
	.IF eax=='b'
		mov al,100
		mov speed,al
		call StartGame
		jmp L2
	.ENDIF
	.IF eax=='n'
		mov al,75
		mov speed,al
		call StartGame
		jmp L2
	.ENDIF
	.IF eax=='e'
		mov al,50
		mov speed,al
		call StartGame
		jmp L2
	.ENDIF
	mGOTOXY 22,21
	mTextColor RED
	mWrite "Please Choose Correct Option!"
	mGoToXY 41,13
	jmp L1
	L2:
	mGOTOXY 0,23
	mTextColor WHITE
	;call WaitMsg
	ret
mainMenue endp
;====================================================
;	Printwall
;====================================================   
PrintWall PROC
        mGotoxy     0, 0     
        mWrite      TopWall
        mGotoxy     0, maxRow    
        mWrite      TopWall
        
        mov         cl, maxRow - 1 
    l0:
        ;.while cl
        cmp         cl, 0 
        je          l1
        mGotoxy     0, cl   
        mWrite      LeftWall
        mGotoxy     maxCol, cl
        mWrite      LeftWall
        DEC         cl
        jmp         l0
    l1:
        ret
PrintWall ENDP
;====================================================
;	Draw  Boundries
;====================================================
DrawBoundries PROC
    mov bars_top, 0
    mov bars_bottom, 79
    mov bars_right, 1
    mov bars_left, 19
    mov speed_bars_hor, 10
    mov speed_bars_ver, 10

    mov inc_bars2, 0

        mGotoxy 0, 0
		mov eax, YELLOW
		call SetTextColor
		mov ecx,80
		
	Lines_hor:
		mov dl,bars_top
		mov dh,0
		call GoToXY
		mov edx, OFFSET bars_bound
		call WriteString
			
		inc bars_top
		
		mov dl,bars_bottom
		mov dh,19
		call GoToXY
		mov edx, OFFSET bars_bound
		call WriteString
							
		dec bars_bottom
			
	loop Lines_hor
		
		mov ecx, 19
		
	Lines_ver:	
		mov dl,79
		mov dh,bars_right
		call GoToXY
		mov edx, OFFSET bars_bound
		call WriteString
					
		inc bars_right
		
		mov dl,0
		mov dh,bars_left
		call GoToXY
		mov edx, OFFSET bars_bound
		call WriteString
							
		dec bars_left
		
	loop Lines_ver
	
ret
DrawBoundries ENDP
;====================================================
;	Developers
;====================================================
Developers proc
	call DrawBoundries
	mGoToXY 33,2
	mWrite "BREAKOUT GAME"
	DelayPro 170
	mTextColor Gray
	mGoToXY 34,5
	mWrite "Developers"
	DelayPro 170
	mTextColor Green
	mGoToXY 27,7
	mWrite "Muhammad Ahsan (P17-6142)"
	DelayPro 170
	mGoToXY 27,9
	mWrite "Mehmood Munir  (P17-6075)"
	DelayPro 170
	mGoToXY 27,11
	mWrite "Iqra Fakhar    (P17-6148)"
	DelayPro 170
	
	mTextColor Gray
	mGotoXY 45,14
	mWrite "Language Used :"
	mTextColor Green
	mGotoXY 61,14
	mWrite "Assembly (MASM)"
	DelayPro 170
	
	mTextColor Gray
	mGotoXY 45,16
	mWrite "Submitted to  :"
	mTextColor Green
	mGotoXY 61,16
	mWrite "M. Tehseen Khan"
	
	
	mGoToXY 51,21
	mTextColor Yellow
	call WaitMsg
	
	call s_rules	;   see the rules of the game
	;
	;
	;
; jmp from GamePaused when Exit option is slected
G2Label::	
	call ClrScr
	call DrawBoundries
	
	mov edx,offset playerName
	mGoToXY 32,8
	mTextColor Gray
	
	mWrite "GoodBye "
	mGotoXY 40,8
	call WriteString
	mGoToXY 32,10
	
	mTextColor Yellow
	mWrite "See you Later "
	mGoToXY 32,12
	
	mTextColor Green
	mWrite "Have a Good Day! "
	mTextColor White
	mGotoXY 48,21
	ret
Developers endp






cloudColision PROC

	movzx esi, ball.x
        ;mov dl,(Cloud PTR arr[esi]).Xaxis
	mov bl, " "
	mov dl,(Cloud PTR arr[esi]).info
        
       .IF bl != dl
        
	movzx esi, ball.x
	mov dl,(Cloud PTR arr[esi]).Xaxis
	mov bl, " "
	mov (Cloud PTR arr[esi]).info,bl

	neg ballDirection.y
	
	.ENDIF
	
    	ret
cloudColision ENDP








