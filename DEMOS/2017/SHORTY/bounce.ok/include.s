Efface_DEUX_signature:
	move.l	physique+4,a0                ; FROM ADRESS DATA
	move.w	#0,d2                    ; LEFT FROM ADRESS DATA
	move.w	#0,d3                    ; TOP FROM ADRESS DATA
	move.w	#50,d4        ; WIDTH of bloc
	move.w	#30,d5       ; HEIGHT of bloc
	move.w	#4,d6       ; Number of plane
; Destination 1st Screen adress
	move.l	physique+4,a1          ; TO ADRESS SCREEN
	move.w	#320-50,d0      ; LEFT TO ADRESS SCREEN
	move.w	#200-30,d1      ; TOP TO ADRESS SCREEN
	jsr	DoBLiTTER__Operation       ; Launch blitter operation
Efface_signature:
	move.l	physique,a0                ; FROM ADRESS DATA
	move.w	#0,d2                    ; LEFT FROM ADRESS DATA
	move.w	#0,d3                    ; TOP FROM ADRESS DATA
	move.w	#50,d4        ; WIDTH of bloc
	move.w	#30,d5       ; HEIGHT of bloc
	move.w	#4,d6       ; Number of plane
; Destination 1st Screen adress
	move.l	physique,a1          ; TO ADRESS SCREEN
	move.w	#320-50,d0      ; LEFT TO ADRESS SCREEN
	move.w	#200-30,d1      ; TOP TO ADRESS SCREEN
	jsr	DoBLiTTER__Operation       ; Launch blitter operation
	rts

Bounce_signature:
	move.l	#Signature_image,a0                ; FROM ADRESS DATA
	move.w	#0,d2                    ; LEFT FROM ADRESS DATA
	move.w	#0,d3                    ; TOP FROM ADRESS DATA
	move.w	#320,d4        ; WIDTH of bloc
	move.w	#7,d5       ; HEIGHT of bloc
	move.w	#4,d6       ; Number of plane
; Destination 1st Screen adress
	move.l	logoptr,a1
	cmp.b	#$ff,(a1)
	bne.s	no_logo2_rst
	lea	logopos,a1
	move.l	a1,logoptr
no_logo2_rst
	moveq	#0,d1
	move.b	(a1)+,d1
	move.l	a1,logoptr
	add.w	#174,d1
	move.l	physique,a1          ; TO ADRESS SCREEN
	move.w	#0,d0      ; LEFT TO ADRESS SCREEN
*	move.w	#0,d1      ; TOP TO ADRESS SCREEN
	jsr	DoBLiTTER__Operation       ; Launch blitter operation
	rts

logoptr:
	dc.l logopos
logopos:
	dc.b	0
	dc.b	1,2,3,4,5,7,9,11,14,17
	dc.b	19,16,13,10,8,6,4,3,2,1
	dc.b	-1
	even
