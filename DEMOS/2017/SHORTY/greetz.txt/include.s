***************************************************************
*               PRINT TEXT FONT 3*5 ONE BITPLANE              *
***************************************************************
print_text:

chg:
	move.l	a5,a4
wrp:
	move.l	a4,a0
	lea	ascii,a2
	lea	petite_fonte,a3
	move.b	(a1)+,d0
	beq	bcl1
	cmpi.b	#1,d0
	bne.s	nch
	lea	160*4(a5),a5
	moveq	#0,d5
	bra.s	chg
nch:
	cmp.b	(a2)+,d0
	beq.s	post
	addq.l	#4,d6
	bra.s	nch

post:
	move.l	(a3,d6.w),d0
	moveq	#0,d6
	move.l	d0,d4
	swap	d4
	move.l	d0,d1
	lsr.w	#4,d1
	move.l	d1,d2
	lsr.w	#4,d2
	move.l	d2,d3
	lsr.w	#4,d3
	andi.l	#$f,d0
	andi.l	#$f,d1
	andi.l	#$f,d2
	andi.l	#$f,d3
	andi.l	#$f,d4
	addq.b	#1,d5
	cmpi.b	#1,d5
	beq.s	pos1
	cmpi.b	#2,d5
	beq.s	pos2
	cmpi.b	#3,d5
	beq.s	pos3
	moveq	#0,d5
	addq.l	#8,a4	
	bra.s	rin

pos1:
	lsl.w	#4,d0
	lsl.w	#4,d1
	lsl.w	#4,d2
	lsl.w	#4,d3
	lsl.w	#4,d4
pos2:
	lsl.w	#4,d0
	lsl.w	#4,d1
	lsl.w	#4,d2
	lsl.w	#4,d3
	lsl.w	#4,d4
pos3:
	lsl.w	#4,d0
	lsl.w	#4,d1
	lsl.w	#4,d2
	lsl.w	#4,d3
	lsl.w	#4,d4
rin:
	or.w	d4,(a0)
	or.w	d3,160(a0)
	or.w	d2,320(a0)
	or.w	d1,480(a0)
	or.w	d0,640(a0)
	bra	wrp
bcl1:
	rts
