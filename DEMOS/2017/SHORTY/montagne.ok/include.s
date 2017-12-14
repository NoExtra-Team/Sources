ScrollBlit:
	add.w #1,decalS
	cmp.w	#320-96,decalS
	bge.s	.no_decalS
; From adress
	move.l	#montagnes,a0                ; FROM ADRESS DATA
	move.w	decalS,d2                    ; LEFT FROM ADRESS DATA
	move.w	#0,d3                    ; TOP FROM ADRESS DATA
	move.w	#96,d4        ; WIDTH of bloc
	move.w	#54,d5       ; HEIGHT of bloc
	move.w	#4,d6       ; Number of plane
; Destination 1st Screen adress
	move.l	physique,a1          ; TO ADRESS SCREEN
	move.w	#113-1,d0      ; LEFT TO ADRESS SCREEN
	move.w	#73,d1      ; TOP TO ADRESS SCREEN
	bsr	DoBLiTTER__Operation       ; Launch blitter operation
.no_decalS:
	rts

decalS:
	dc.w	0

Display_Montagne:
; From adress
	move.l	#montagnes,a0                ; FROM ADRESS DATA
	move.w	#0,d2                    ; LEFT FROM ADRESS DATA
	move.w	#0,d3                    ; TOP FROM ADRESS DATA
	move.w	#96,d4        ; WIDTH of bloc
	move.w	#54,d5       ; HEIGHT of bloc
	move.w	#4,d6       ; Number of plane
; Destination 1st Screen adress
	move.l	physique,a1          ; TO ADRESS SCREEN
	move.w	#113-1,d0      ; LEFT TO ADRESS SCREEN
	move.w	#73,d1      ; TOP TO ADRESS SCREEN
	bsr	DoBLiTTER__Operation       ; Launch blitter operation
	rts
