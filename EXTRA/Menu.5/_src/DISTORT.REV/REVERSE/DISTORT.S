;	opt	x+
;========================================
	text
;========================================
begin	dc.w	$a00a

	clr.l	-(sp)
	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp
	move.l	d0,-(sp)

	bsr	l0009

	move.w	#$1f,l0016
	move.l	#l0026,l0013
	move.l	#l0029,l0014
	move.l	#l0019,l0015
	bsr	l000c

	clr.w	$ffff8240.l

	move.l	#l0008,$120.l

	move.b	#8,$fffffa1b.l
	move.b	#1,$fffffa21.l
	move.b	#1,$fffffa07.l
	move.b	#$40,$fffffa09.l
	move.b	#1,$fffffa13.l
	move.b	#$40,$fffffa15.l

	move.l	#l0004,$70.l

	movea.l	$44e.l,a0
	lea	l0024,a1
	move.w	#$1f3f,d0
l0000	move.l	(a1)+,(a0)+
	dbf	d0,l0000

l0001	cmpi.b	#$39,$fffffc02.w
	bne.s	l0001

	bsr	l000b

	move.w	#0,$ffff8240.l
	move.w	#$777,$ffff825e.l

	pea	l0018
	clr.w	-(sp)
	move.w	#$19,-(sp)		;ikbdws
	trap	#14

	move.w	#$2700,sr

	lea	8.w,a1
	lea	l0003(pc),a0
	moveq	#9,d7
l0002	move.l	(a0)+,(a1)+
	dbf	d7,l0002

	jmp	$12.w

l0003	ori.b	#$c,d0
	movea.l	4.w,a0
	jmp	(a0)

	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp

	clr.l	-(sp)
	trap	#1
;========================================
l0004	movem.l	a0-a6/d0-d7,-(sp)

	lea	l0026,a1
	move.l	a1,l0013
	lea	30(a1),a0
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1

	movea.l	l0013(pc),a0
	lea	$ffff8242.l,a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.w	(a0)+,(a1)
	move.l	a0,l0013
	movea.l	l0014(pc),a0
	subq.w	#1,l0016
	bpl	l0007

	move.w	#$1f,l0016
	moveq	#0,d0
	movea.l	l0015(pc),a0
	move.b	(a0)+,d0
	bne	l0005

	lea	l0019(pc),a0
	move.b	(a0)+,d0
l0005	move.l	a0,l0015
	subi.w	#$41,d0
	bpl	l0006

	lea	l0029,a0
	bra	l0007

l0006	add.w	d0,d0
	add.w	d0,d0
	lea	l001a(pc),a0
	movea.l	0(a0,d0.w),a0
l0007	lea	l0027,a1
	movem.l	(a0)+,d0-d6
	movem.l	d0-d6,(a1)
	move.w	(a0)+,28(a1)
	move.l	a0,l0014

	movem.l	(sp)+,a0-a6/d0-d7
	rte

l0008	move.l	a0,-(sp)
	move.l	a1,-(sp)

	movea.l	l0013(pc),a0
	lea	$ffff8242.l,a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.w	(a0)+,(a1)
	move.l	a0,l0013

	movea.l	(sp)+,a1
	movea.l	(sp)+,a0

	bclr	#0,$fffffa0f.l
	rte

l0009	bsr	l000a

	pea	l0017
	clr.w	-(sp)
	move.w	#$19,-(sp)		;ikbdws
	trap	#14
	clr.w	-(sp)

	move.l	#$ffffffff,-(sp)
	move.l	#$ffffffff,-(sp)
	move.w	#5,-(sp)		;setscreen
	trap	#14

	move.w	#$25,-(sp)		;vsync
	trap	#14
	adda.l	#$16,sp
	rts

l000a	move.b	$fffffa1b.l,l004e
	move.b	$fffffa21.l,l004f
	move.b	$fffffa07.l,l0050
	move.b	$fffffa09.l,l0051
	move.b	$fffffa13.l,l0052
	move.b	$fffffa15.l,l0053

	move.l	$70.l,l0054
	rts

l000b	move.b	l004e,$fffffa1b.l
	move.b	l004f,$fffffa21.l
	move.b	l0050,$fffffa07.l
	move.b	l0051,$fffffa09.l
	move.b	l0052,$fffffa13.l
	move.b	l0053,$fffffa15.l
	move.l	l0054,$70.l
	rts

l000c	lea	l001b,a0
	lea	l0025+34,a1
l000d	move.l	(a0)+,d0
	bmi	l0012

	movem.l	(a0)+,a2-a4
	move.w	#$1f,d1
l000e	move.w	#$e,d2
	move.w	0(a1,d0.w),d3
l000f	lsl.w	#1,d3
	bcc	l0010

	move.w	(a4)+,(a2)+
	addq.w	#2,a3
	bra	l0011

l0010	move.w	(a3)+,(a2)+
	addq.w	#2,a4
l0011	dbf	d2,l000f

	suba.w	#$1e,a3
	suba.w	#$1e,a4
	addi.w	#$a0,d0
	dbf	d1,l000e

	bra	l000d
l0012	rts

l0013	dcb.w	2
l0014	dcb.w	2
l0015	dcb.w	2
l0016	dc.b	$00,$00
;========================================
	data
;========================================
l0017	dc.b	$12
l0018	dc.b	$08

l0019	dc.b	'WELCOME TO THE DISTORT SCREEN [['
	dc.b	'\\\    ^   NOT BAD NO ]   a CODE'
	dc.b	' WAS bAS USUALc DONE BY STRIX ` '
	dc.b	' GREETINGS TO THE B\M\G\ MEMBERS'
	dc.b	' ^ ESPECIALY TO ATAKID FOR HIS B'
	dc.b	'OOKS [[[ AND FOR THE TESTS ON HI'
	dc.b	'S ST [[ ^  SPECIAL GREETINGS TO '
	dc.b	'PACER ^ FOR HIS SYBEX BOOK ABOUT'
	dc.b	' C a  IT IS TIME TO WRAP NOW\\\ '
	dc.b	' SEE YOU ON ANOTHER SCREEN\\\  `'
	dc.b	'STRIX`^  ',0

l001a	dc.l	l002a
	dc.l	l002b
	dc.l	l002c
	dc.l	l002d
	dc.l	l002e
	dc.l	l002f
	dc.l	l0030
	dc.l	l0031
	dc.l	l0032
	dc.l	l0033
	dc.l	l0034
	dc.l	l0035
	dc.l	l0036
	dc.l	l0037
	dc.l	l0038
	dc.l	l0039
	dc.l	l003a
	dc.l	l003b
	dc.l	l003c
	dc.l	l003d
	dc.l	l003e
	dc.l	l003f
	dc.l	l0040
	dc.l	l0041
	dc.l	l0042
	dc.l	l0043
	dc.l	l0044
	dc.l	l0045
	dc.l	l0046
	dc.l	l0047
	dc.l	l0048
	dc.l	l0049
	dc.l	l004a
	dc.l	l004b
	dc.l	l004c
	dc.l	l004d

l001b	dcb.w	2
	dc.l	l002a
	dc.l	l0028
	dc.l	l001c
	dc.b	$00,$00,$00,$08
	dc.l	l002b
	dc.l	l0028
	dc.l	l0022
	dc.b	$00,$00,$00,$10
	dc.l	l002c
	dc.l	l0028
	dc.l	l001e
	dc.b	$00,$00,$00,$18
	dc.l	l002d
	dc.l	l0028
	dc.l	l001c
	dc.b	$00,$00,$00,$20
	dc.l	l002e
	dc.l	l0028
	dc.l	l0020
	dc.b	$00,$00,$00,$28
	dc.l	l002f
	dc.l	l0028
	dc.l	l001d
	dc.b	$00,$00,$00,$30
	dc.l	l0030
	dc.l	l0028
	dc.l	l001c
	dc.b	$00,$00,$00,$38
	dc.l	l0031
	dc.l	l0028
	dc.l	l001e
	dc.b	$00,$00,$00,$40
	dc.l	l0032
	dc.l	l0028
	dc.l	l001f
	dc.b	$00,$00,$00,$48
	dc.l	l0033
	dc.l	l0028
	dc.l	l0021
	dc.b	$00,$00,$00,$50
	dc.l	l0034
	dc.l	l0028
	dc.l	l001d
	dc.b	$00,$00,$00,$58
	dc.l	l0035
	dc.l	l0028
	dc.l	l001f
	dc.b	$00,$00,$00,$60
	dc.l	l0036
	dc.l	l0028
	dc.l	l001e
	dc.b	$00,$00,$00,$68
	dc.l	l0037
	dc.l	l0028
	dc.l	l001d
	dc.b	$00,$00,$00,$70
	dc.l	l0038
	dc.l	l0028
	dc.l	l0020
	dc.b	$00,$00,$00,$78
	dc.l	l0039
	dc.l	l0028
	dc.l	l0021
	dc.b	$00,$00,$00,$80
	dc.l	l003a
	dc.l	l0028
	dc.l	l001f
	dc.b	$00,$00,$00,$88
	dc.l	l003b
	dc.l	l0028
	dc.l	l001f
	dc.b	$00,$00,$00,$90
	dc.l	l003c
	dc.l	l0028
	dc.l	l001c
	dc.b	$00,$00,$00,$98
	dc.l	l003d
	dc.l	l0028
	dc.l	l0023
	dc.b	$00,$00,$14,$00
	dc.l	l003e
	dc.l	l0028
	dc.l	l001d
	dc.b	$00,$00,$14,$08
	dc.l	l003f
	dc.l	l0028
	dc.l	l001d
	dc.b	$00,$00,$14,$10
	dc.l	l0040
	dc.l	l0028
	dc.l	l001c
	dc.b	$00,$00,$14,$18
	dc.l	l0041
	dc.l	l0028
	dc.l	l001c
	dc.b	$00,$00,$14,$20
	dc.l	l0042
	dc.l	l0028
	dc.l	l001f
	dc.b	$00,$00,$14,$28
	dc.l	l0043
	dc.l	l0028
	dc.l	l0022
	dc.b	$00,$00,$14,$98
	dc.l	l0029
	dc.l	l0028
	dc.l	l0028
	dc.b	$00,$00,$14,$30
	dc.l	l0044
	dc.l	l0028
	dc.l	l001e
	dc.b	$00,$00,$14,$38
	dc.l	l0045
	dc.l	l0028
	dc.l	l0022
	dc.b	$00,$00,$14,$40
	dc.l	l0046
	dc.l	l0028
	dc.l	l0020
	dc.b	$00,$00,$14,$48
	dc.l	l0047
	dc.l	l0028
	dc.l	l001e
	dc.b	$00,$00,$14,$50
	dc.l	l0048
	dc.l	l0028
	dc.l	l0023
	dc.b	$00,$00,$14,$58
	dc.l	l0049
	dc.l	l0028
	dc.l	l001e
	dc.b	$00,$00,$14,$60
	dc.l	l004a
	dc.l	l0028
	dc.l	l001e
	dc.b	$00,$00,$14,$68
	dc.l	l004b
	dc.l	l0028
	dc.l	l001d
	dc.b	$00,$00,$14,$70
	dc.l	l004c
	dc.l	l0028
	dc.l	l001d
	dc.b	$00,$00,$14,$78
	dc.l	l004d
	dc.l	l0028
	dc.l	l001c
	dc.b	$ff,$ff,$ff,$ff

l001c	dc.b	$07,$07,$07,$06,$07,$05,$07,$04
	dc.b	$07,$03,$07,$02,$07,$01,$07,$00
	dc.b	$07,$10,$07,$20,$07,$30,$07,$40
	dc.b	$07,$50,$07,$60,$07,$70
l001d	dc.b	$00,$01,$01,$12,$02,$23,$03,$34
	dc.b	$04,$45,$05,$56,$06,$67,$07,$77
	dc.b	$06,$67,$05,$56,$04,$45,$03,$34
	dc.b	$02,$23,$01,$12,$00,$01
l001e	dc.b	$07,$00,$07,$30,$07,$50,$07,$70
	dc.b	$04,$70,$00,$70,$00,$75,$00,$77
	dc.b	$00,$57,$00,$27,$00,$07,$02,$07
	dc.b	$05,$07,$07,$07,$07,$04
l001f	dc.b	$00,$02,$01,$03,$02,$14,$02,$25
	dc.b	$02,$36,$02,$47,$04,$57,$07,$50
	dc.b	$07,$40,$06,$20,$05,$10,$04,$00
	dc.b	$03,$00,$02,$00,$01,$00
l0020	dc.b	$07,$00,$07,$10,$07,$20,$07,$30
	dc.b	$07,$40,$07,$50,$07,$60,$07,$70
	dc.b	$00,$77,$00,$67,$00,$57,$00,$47
	dc.b	$00,$37,$00,$27,$00,$17
l0021	dc.b	$00,$70,$00,$71,$00,$72,$00,$73
	dc.b	$00,$74,$00,$75,$00,$76,$00,$77
	dc.b	$00,$67,$00,$57,$00,$47,$00,$37
	dc.b	$00,$27,$00,$17,$00,$07
l0022	dc.b	$00,$01,$01,$12,$02,$23,$03,$34
	dc.b	$04,$45,$05,$56,$06,$67,$07,$77
	dc.b	$07,$75,$07,$74,$07,$63,$07,$52
	dc.b	$07,$41,$06,$30,$05,$20
l0023	dc.b	$00,$00,$01,$11,$02,$22,$03,$33
	dc.b	$04,$44,$05,$55,$06,$66,$07,$77
	dc.b	$06,$66,$05,$55,$04,$44,$03,$33
	dc.b	$02,$22,$01,$11,$00,$00,$00,$00
	dc.b	$00,$00,$07,$00,$07,$11,$07,$22
	dc.b	$07,$33,$07,$44,$07,$55,$07,$66
	dc.b	$07,$77,$06,$67,$05,$57,$04,$47
	dc.b	$03,$37,$02,$27,$01,$17,$00,$07

l0024	incbin	l0024
l0025	incbin	l0025

l0026	dcb.w	2985
l0027	dcb.w	45
l0028	dcb.w	16
;========================================
	bss
;========================================
l0029	ds.b	960
l002a	ds.b	960
l002b	ds.b	960
l002c	ds.b	960
l002d	ds.b	960
l002e	ds.b	960
l002f	ds.b	960
l0030	ds.b	960
l0031	ds.b	960
l0032	ds.b	960
l0033	ds.b	960
l0034	ds.b	960
l0035	ds.b	960
l0036	ds.b	960
l0037	ds.b	960
l0038	ds.b	960
l0039	ds.b	960
l003a	ds.b	960
l003b	ds.b	960
l003c	ds.b	960
l003d	ds.b	960
l003e	ds.b	960
l003f	ds.b	960
l0040	ds.b	960
l0041	ds.b	960
l0042	ds.b	960
l0043	ds.b	960
l0044	ds.b	960
l0045	ds.b	960
l0046	ds.b	960
l0047	ds.b	960
l0048	ds.b	960
l0049	ds.b	960
l004a	ds.b	960
l004b	ds.b	960
l004c	ds.b	960
l004d	ds.b	960
l004e	ds.w	1
l004f	ds.w	1
l0050	ds.w	1
l0051	ds.w	1
l0052	ds.w	1
l0053	ds.w	1
l0054	ds.b	24
;========================================
zuend	end
;========================================