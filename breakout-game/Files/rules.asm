; RULES


.data
RuleTitle BYTE "<=== RULES ===>",0
line1 BYTE "In the game, a layer of bricks lines the top third of the screen.",0
line2 BYTE "A ball travels across the screen, bouncing off the top",0 
line2a BYTE  "                           and side walls of the screen.",0
line3 BYTE "When a brick is hit, the ball bounces away and the brick is destroyed.",0
line4 BYTE "The player loses a turn when the ball touches the bottom of the screen.",0
line5 BYTE "To prevent this from happening, the player has a", 0
line5b BYTE "         movable paddle to bounce the ball upward keeping it in play.",0
.code

s_rules PROC
	
    	call ClrScr
    	call DrawBoundries
    	mov eax,170
    	call Delay
 
    	mov eax, Gray
    	call SetTextColor
    	mov dh,3
    	mov dl,33
    	call GoToXy
    	
    	mov edx, OFFSET RuleTitle
    	call WriteString
	mov eax,GREEN
	call SetTextColor
;--------------------------------------
	
    	mov dh,7
    	mov dl,7
    	call GoToXy
    	DelayPro 170 
    	mov edx, OFFSET line1
    	call WriteString
    
    	mov dh,8
    	mov dl,13
    	call GoToXy
    	
    	DelayPro 170      
    	mov edx, OFFSET line2
    	call WriteString
    
    	mov dh,9
    	mov dl,1
    	call GoToXy
        
        DelayPro 170
    	mov edx, OFFSET line2a
    	call WriteString
    
    	mov dh,10
    	mov dl,4
    	call GoToXy
        
        DelayPro 170
    	mov edx, OFFSET line3
    	call WriteString
    
    
    	mov dh,12
    	mov dl,3
    	call GoToXy
        DelayPro 170
    	mov edx, OFFSET line4
    	call WriteString
    
    	mov dh,13
    	mov dl,14
    	call GoToXy
        DelayPro 170
    	mov edx, OFFSET line5
    	call WriteString
    
    	mov dh,14
    	mov dl,1
    	call GoToXy
    	DelayPro 170       
    	mov edx, OFFSET line2a
    	call WriteString
    	
    	mGoToXY 51,21
    	mTextColor Yellow
    	
    	call WaitMsg
    	call mainMenue
ret
s_rules ENDP