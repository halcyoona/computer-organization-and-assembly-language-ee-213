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
;====================================================   Macro to set text Color
mTextColor MACRO color
	push eax
	mov ax,color
	call SetTextColor
	pop eax
ENDM
;===================================================	Struct for cloud
Cloud STRUCT
	info byte ?
	Xaxis byte ?
	Yaxis byte ?
Cloud ENDS
EscapeKey EQU 01bh
;===================================================
;      .data   Segment
;===================================================
.data							
	
	playerName byte 15 Dup(?)
	maxCol 	EQU 79
	maxRow  EQU 20
	TopWall EQU "================================================================================"
	LeftWall EQU 254
	
	x byte 0
	;-----------------------------------;  mainMenue 
	breakout BYTE "BREAKOUT",0ah,0dh,0
	menu BYTE "GAME MAIN MENU",0ah,0dh,0
	start BYTE "(S)tart Game",0ah,0dh,0
	rules BYTE "  (R)ules",0ah,0dh,0
	credits BYTE " (C)redits",0ah,0dh,0
	exitgame BYTE "  (E)xit",0ah,0dh,0
	
	
	;-----------------------------------;  mainCloud
	
	Clud byte 254,0
	;obj Cloud <,,>			; Struct Object
	arr Cloud 320 Dup(<,,>)		; an array of Struct type
	chk1 byte 1
	chkIn Byte 0 	; for gamePaused input char
	
;====================================================
;=	         Code Segment		            =
;====================================================
.code
Include Files\rules.asm
GetKeyState PROTO NVirtKey:Dword
;====================================================
;	mainCloud
;====================================================
mainCloud Proc
	call ClrScr
	mov esi,0
	mov dl,0
	mov dh,0
	mov al,"="
	
	.WHILE dh<4
		mov dl,0
		.WHILE dl<80
			mov (Cloud PTR arr[esi]).Xaxis,dh
			mov (Cloud PTR arr[esi]).Yaxis,dl
			mov (Cloud PTR arr[esi]).info,al
			inc dl
			add esi,TYPE Cloud
		.ENDW
		inc dh
	.ENDW
	
	L1:
	mov ecx,0
	mov esi,0
	mov edx,0
	.WHILE ecx<320
		call mainMehmood
		
		
		
		mov dh,(Cloud PTR arr[esi]).Xaxis
		mov dl,(Cloud PTR arr[esi]).Yaxis
		call GotoXY
		mov al,(Cloud PTR arr[esi]).info
		.If ecx < 78
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
		.endif
		add esi,TYPE Cloud
		inc ecx
	.ENDW
	mTextColor Green
	mGoTOXY 57,24
	mWrite "Press ESC to Pause ..."
	Invoke GetKeyState,EscapeKey
	.If ah
		jmp L2
		gLabel::
		call Clrscr
	.Endif
	cmp chk1,1
	je L1
	L2:
	call GamePaused
	mGoToXY 49,22
	ret
mainCloud endp
;====================================================
;	GamePaused
;====================================================
GamePaused Proc
	call ClrScr
	mov chkIn,0	; for char input
	call setBoundries
	mov eax,300
	call Delay
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
	.IF al=="r"
		mov chkIn,1
		jmp gLabel
	.EndIF
	.IF al=="m"
		mov chkIn,1
		call mainMenue
	.EndIF
	.IF al=="s"
		mov chkIn,1
		call mainCloud
	.EndIF
	.IF al=="e"
		mov chkIn,1
		jmp G2Label	; this albel is in Rules function
	
	.EndIF
	.IF chkIn != 1
		mov chkIn,0
		mGOTOXY 22,21
		mTextColor RED
		mWrite "Please Choose Correct Option!"
		jmp L12
	.EndIf
	
	L3:
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
	mov eax,300
    	call Delay
	mGoToXY 33,2
	mWrite "BREAKOUT GAME"
	mov eax,WHITE
	call SetTextColor
	mGoToXY 34,5
	mWrite " MAIN MENUE "
	mov eax,YELLOW
	call SetTextColor
	mGoToXY 34,7
	mWrite "Enter Name : "
	mov edx,offset playerName
	mov ecx,lengthof playerName
	call readString
	mov eax,WHITE
	call SetTextColor
	mGoToXY 34,9
	mWrite "Level"
	;mov eax,YELLOW
	mTextColor YELLOW
	mGoToXY 34,10
	mWrite "1) Basic  -> b"
	mGoToXY 34,11
	mWrite "2) Normal -> n"
	mGoToXY 34,12
	mWrite "3) Expert -> e"
	mGoToXY 34,13
	mWrite "Choose: "
	L1:call readChar
	.IF eax=='b'
		call mainCloud
		jmp L2
	.ENDIF
	.IF eax=='n'
		call mainCloud
		jmp L2
	.ENDIF
	.IF eax=='e'
		call mainCloud
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
developers proc
	call setBoundries
	mov eax,300
    	call Delay
	mGoToXY 33,2
	mWrite "BREAKOUT GAME"
	mTextColor White
	mGoToXY 34,6
	mWrite "Developers"
	mTextColor Green
	mGoToXY 27,8
	mWrite "Muhammad Ahsan (P17-6142)"
	mGoToXY 27,10
	mWrite "Mehmood Munir  (P17-6075)"
	mGoToXY 27,12
	mWrite "Iqra Fakhar    (P17-6148)"
	
	mGoToXY 51,21
	mTextColor Yellow
	call WaitMsg
	;call mainMenue
	call s_rules	;   see the rules of the game
G2Label::	; jmp from GamePaused when Exit option is slected
	call ClrScr
	call SetBoundries
	mov edx,offset playerName
	mGoToXY 32,8
	mTextColor GREEN
	mWrite "GoodBye "
	mGotoXY 40,8
	call WriteString
	mGoToXY 32,9
	mWrite " See you Later"
	mTextColor White
	mGotoXY 51,21
ret
developers endp












