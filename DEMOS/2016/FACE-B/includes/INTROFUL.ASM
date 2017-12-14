init_zoom:
	move.l	#$ff8240,a5

	lea	t_Buffer_L7Z,a0	        ;	Full_Logo_NoExtra_img
	lea	t_Buffer_L7Z+160*200,a1	;	Buffer
	move.l	a1,pointe
	move.l	#3999,d6
rep:
	moveq	#15,d3
	moveq	#31,d2
	move.l	(a0)+,d0
	move.l	(a0)+,d1
suiv:
	moveq	#0,d7

	btst	d2,d0
	bne.s	un
	bclr	#0,d7
	bra.s	suite1
un:
	bset	#0,d7

suite1:
	btst	d3,d0
	bne.s	deux
	bclr	#1,d7
	bra.s	suite2
deux:
	bset	#1,d7

suite2:
	btst	d2,d1
	bne.s	trois
	bclr	#2,d7
	bra.s	suite3
trois:
	bset	#2,d7

suite3:
	btst	d3,d1
	bne.s	quatre
	bclr	#3,d7
	bra.s	suite4
quatre:
	bset	#3,d7

suite4:
	lsl	#1,d7
	move.w	(a5,d7.w),(a1)+
	subq.w	#1,d2
	dbf	d3,suiv		
	dbf	d6,rep
	rts

Vbl_Zoom:
	move.l	#1432,d0
.neant1:
	dbf	d0,.neant1
	clr.b	$ffff820a.w
	moveq	#2,d0
.neant2:
	dbf	d0,.neant2
	move.b	#2,$ffff820a.w
	move.l	pointe,a4
	move.l	a4,a6
.sync:
	move.b	$ffff8209.w,d1
	beq.s	.sync
	sub.w	d1,d0
	lsr.w	d0,d0
	dcb.w	512-43,$4e71
	rept	32
	move.l	a6,a4
	dcb.w	39,$3a9c
	dcb.w	10,$4e71
	move.l	a6,a4
	dcb.w	39,$3a9c	
	dcb.w	10,$4e71
	move.l	a6,a4
	dcb.w	39,$3a9c	
	dcb.w	10,$4e71
	move.l	a6,a4
	dcb.w	39,$3a9c	
	dcb.w	10,$4e71
	move.l	a6,a4
	dcb.w	39,$3a9c	
	dcb.w	10,$4e71
	move.l	a6,a4
	dcb.w	39,$3a9c	
	dcb.w	10,$4e71
	move.l	a6,a4
	dcb.w	39,$3a9c	
	dcb.w	10,$4e71

	move.l	a6,a4
	dcb.w	39,$3a9c	
	lea	640(a6),a6
	dcb.w	8,$4e71
	endr

	move.w	#$03A3,$ffff8240.w

	st	Vsync                    ; Synchronisation

	jsr 	(MUSIC_INTRO+8)                  ; Play SNDH music
	rte

pointe:
	ds.l	1

Deplace_M:
	move.l	pointe,d4
gauche:
	cmpi.b	#$4b,d6
	bne.s	droite
	subq.l	#2,d4
droite:
	cmpi.b	#$4d,d6
	bne.s	bas
	addq.l	#2,d4
bas:
	cmpi.b	#$50,d6
	bne.s	haut
	sub.l	#640,d4
haut:
	cmpi.b	#$48,d6
	bne.s	nothingP
	add.l	#640,d4
nothingP:
	move.l	d4,pointe
	rts
