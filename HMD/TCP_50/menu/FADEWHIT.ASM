**********************************
*         Fading To White        *
**********************************
* Original version KELLY.X/HMD   *
*--------------------------------*
* Parameter(s)                   *
*--------------------------------*
**********************************
FadeTOwhite:
	lea	Pal1,a0
	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,(a0)

	lea	Pal2,a1
	movem.l	Blanc,d0-d7
	movem.l	d0-d7,Pal2
	moveq	#15,d1
	moveq	#15,d0
	bsr	Fade1
	moveq	#14,d1
f3:
	bsr	wart                     ; Waiting after the VBL
	movem.l	Pal1,d2-d7/a0/a1
	movem.l	d2-d7/a0/a1,$ffff8240.w
	moveq	#15,d0
	lea	Pal1,a0
	bsr	Fade2
	dbra	d1,f3
	rts

Fade1:
	lea	Delta(pc),a2
	lea	RGB(pc),a3
.lp
	move.w	(a0)+,d2
	move.w	(a1)+,d3

	moveq	#$f,d4
	and.w	d2,d4
	move.b	RGB1(pc,d4.w),d4
	lsl.w	#8,d4
	move.w	d4,(a3)+
	moveq	#$f,d5
	and.w	d3,d5
	move.b	RGB1(pc,d5.w),d5
	lsl.w	#8,d5
	sub.w	d4,d5
	ext.l	d5
	divs	d1,d5
	move.w	d5,(a2)+

	move.w	d2,d4
	and.w	#$f0,d4
	lsr.w	#4,d4
	move.b	RGB1(pc,d4.w),d4
	lsl.w	#8,d4
	move.w	d4,(a3)+
	move.w	d3,d5
	and.w	#$f0,d5
	lsr.w	#4,d5
	move.b	RGB1(pc,d5.w),d5
	lsl.w	#8,d5
	sub.w	d4,d5
	ext.l	d5
	divs	d1,d5
	move.w	d5,(a2)+

	move.w	d2,d4
	lsr.w	#8,d4
	move.b	RGB1(pc,d4.w),d4
	lsl.w	#8,d4
	move.w	d4,(a3)+
	move.w	d3,d5
	lsr.w	#8,d5
	move.b	RGB1(pc,d5.w),d5
	lsl.w	#8,d5
	sub.w	d4,d5
	ext.l	d5	
	divs	d1,d5
	move.w	d5,(a2)+
	
	dbra	d0,.lp
	rts

RGB1	dc.b	0,2,4,6,8,10,12,14,1,3,5,7,9,11,13,15

Fade2
	lea	Delta(pc),a1
	lea	RGB(pc),a2
.lp
	move.w	(a1)+,d2
	add.w	(a2),d2
	move.w	d2,(a2)+
	lsr.w	#8,d2
	move.b	RGB2(pc,d2.w),d2
	
	move.w	(a1)+,d3
	add.w	(a2),d3
	move.w	d3,(a2)+
	lsr.w	#8,d3
	move.b	RGB2(pc,d3.w),d3
	lsl.w	#4,d3
	add.w	d3,d2

	move.w	(a1)+,d3
	add.w	(a2),d3
	move.w	d3,(a2)+
	lsr.w	#8,d3
	move.b	RGB2(pc,d3.w),d3
	lsl.w	#8,d3
	add.w	d3,d2

	move.w	d2,(a0)+

	dbra	d0,.lp
	rts

wart:                              ; VSYNC()
	move.l	d0,-(sp)
	move.l	$466.w,d0
.att:	cmp.l	$466.w,d0
	beq.s	.att
	move.l	(sp)+,d0
	rts

Blanc:
	dcb.w 32,$fff
RGB2:
	dc.b	0,8,1,9,2,10,3,11,4,12,5,13,6,14,7,15
Delta:
	ds.w	3*17
RGB:
	ds.w	3*17
Pal1:
	ds.l	8
Pal2:
	ds.l	8
	even

