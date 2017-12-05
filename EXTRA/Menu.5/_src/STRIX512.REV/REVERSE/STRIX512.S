;	opt	x+
;========================================
	text
;========================================
begin	dc.w	$a00a

	pea	l0077(pc)
	move.w	#0,-(sp)
	move.w	#$19,-(sp)		;ikbdws
	trap	#14
	addq.l	#8,sp

	clr.l	-(sp)
	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp
	move.l	d0,-(sp)

	move.b	#$e,$484.l

	moveq	#1,d0
	jsr	l0009
	move.l	#l0009+6,$4d2.w

	move.l	#0,$ffff8240.w
	move.l	#0,$ffff8244.w
	move.l	#0,$ffff8248.w
	move.l	#0,$ffff824c.w
	move.l	#0,$ffff8250.w
	move.l	#0,$ffff8254.w
	move.l	#0,$ffff8258.w
	move.l	#0,$ffff825c.w

	move.w	#3,-(sp)		;logbase
	trap	#14
	addq.l	#2,sp

	movea.l	d0,a1
	lea	l0079,a0
	move.w	#$1f3f,d1
l0000	move.l	(a0)+,(a1)+
	dbf	d1,l0000

	move.b	$ffff820a.w,-(sp)
	move.b	$ffff8260.w,-(sp)
	move.l	$4ce.w,-(sp)
	move.b	#0,$ffff8260.w
	move.b	#2,$ffff820a.w

	lea	l0004(pc),a0
	move.l	a0,$4ce.w

	move.w	#2,-(sp)
	move.w	#2,-(sp)		;bconin
	trap	#13
	addq.l	#4,sp

	clr.l	$4d2.w

	bsr	l0003

	move.l	(sp)+,$4ce.w

	move.w	#0,$ffff8240.w
	move.w	#$777,$ffff825e.w

	move.b	(sp)+,$ffff8260.w
	move.b	(sp)+,$ffff820a.w

	pea	l0078(pc)
	move.w	#0,-(sp)
	move.w	#$19,-(sp)		;ikbdws
	trap	#14
	addq.l	#8,sp

	move.w	#$2700,sr
	lea	8.w,a1
	lea	l0002(pc),a0
	moveq	#9,d7
l0001	move.l	(a0)+,(a1)+
	dbf	d7,l0001

	jmp	$12.w

l0002	ori.b	#$c,d0
	movea.l	4.w,a0
	jmp	(a0)

	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp

	clr.l	-(sp)
	trap	#1
;========================================
l0003	move.l	#$8080000,$ffff8800.l
	move.l	#$9090000,$ffff8800.l
	move.l	#$a0a0000,$ffff8800.l
	rts

l0004	tst.w	$43e.w
	bne	l0008

	move.w	sr,-(sp)

	ori.w	#$700,sr

	lea	l0006(pc),a0
	lea	$ffff8240.w,a1
	lea	$ffff8209.w,a2
	lea	l0079(pc),a3
	lea	32000(a3),a3
	lea	(a1),a4
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a4)+
	moveq	#0,d0
	move.w	#$c5,d1
l0005	tst.b	(a2)
	beq.s	l0005

	move.b	(a2),d0

	jmp	0(a0,d0.w)

l0006	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop

l0007	nop
	nop

	lea	(a1),a4
	lea	(a1),a5
	lea	(a1),a6
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a5)+
	move.l	(a3)+,(a5)+
	move.l	(a3)+,(a5)+
	move.l	(a3)+,(a5)+
	move.l	(a3)+,(a5)+
	move.l	(a3)+,(a5)+
	move.l	(a3)+,(a5)+
	move.l	(a3)+,(a5)+
	move.l	(a3)+,(a6)+
	move.l	(a3)+,(a6)+
	move.l	(a3)+,(a6)+
	move.l	(a3)+,(a6)+
	move.l	(a3)+,(a6)+
	move.l	(a3)+,(a6)+
	move.l	(a3)+,(a6)+
	move.l	(a3)+,(a6)+
	dbf	d1,l0007

	nop
	nop

	lea	(a1),a4
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a4)+
	move.l	(a3)+,(a1)+
	move.l	(a3)+,(a1)+
	move.l	(a3)+,(a1)+
	move.l	(a3)+,(a1)+
	move.l	(a3)+,(a1)+
	move.l	(a3)+,(a1)+
	move.l	(a3)+,(a1)+
	move.l	(a3)+,(a1)+

	move.w	(sp)+,sr
l0008	rts

l0009	incbin	l0009.mus
;========================================
	data
;========================================
l0077	dc.b	$12
l0078	dc.b	$08

l0079	incbin	l0079
;========================================
zuend	end
;========================================