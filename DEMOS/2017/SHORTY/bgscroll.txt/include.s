***************************************************************
*                                                             *
*                 ROXL Scrolling 1 bitplane                   *
*                                                             *
***************************************************************
Scrolling:
	move.l	physique,a0          ; Physique screen selected for display the effect
	lea	160*93+8*13+2(a0),a0           ; And put the Scrolltext in the middle of the screen
	lea	Buffer_L7Z,a2         ; Buffer of the character font
	moveq	#15,d7                   ; 16 lines to display
.scroll:	                         
	roxl	(a2)+                    ; Scroll each pixel of the character Buffer 16 times
i set 160-8                          
 rept 6                             
	roxl	i(a0)                    ; Scroll the right to the left part of the Screen
i set i-8                            
 endr	                             
	lea	160(a0),a0                   ; Next line
	dbf	d7,.scroll                   

	addq	#1,sequence              ; We need to ROXL 16 pixels of the character
	cmpi	#16-1,sequence           ; And we need to count 16 times
	ble		nocar                    
	clr		sequence                 
restart:                             
	move.l	pt_text,a0               ; Next character of the text
	move.b	(a0)+,d0                 
	tst.b	d0                       
	bne.s	.noendtxt                
	move.l	#okitext,pt_text           ; Or restart the text
	bra.s	restart                  
.noendtxt:                           

	move.l	a0,pt_text	             ; Test character in our ASCII table
	lea		list_chr,a2              
	moveq	#-$1,d1                  
.search:	                         
	addq	#$1,d1                   
	cmp.b	(a2)+,d0                 
	bne.s	.search                  
	lea		fonteB,a0                 ; Find Font character to display
search0:                             
	cmpi	#20,d1                   
	bmi.s	.search1                 
	lea		640(a0),a0               
	subi	#20,d1                   
	bra.s	search0                  
.search1:                            
	add		d1,d1	                 
	lea		0(a0,d1.w),a0            ; Find it !

	lea	Buffer_L7Z,a2             ; Recopy Font character to the Buffer character
	moveq	#16-1,d0
.recopy:
	move	(a0),(a2)+
	lea		40(a0),a0
	dbf		d0,.recopy
nocar:
	rts
