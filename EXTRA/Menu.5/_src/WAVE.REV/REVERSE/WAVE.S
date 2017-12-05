;	opt	x+
;========================================
	text
;========================================
begin	dc.w	$a00a

	bsr	l0031

	move.w	#2,-(sp)		;physbase
	trap	#$e
	addq.l	#6,sp
	move.l	d0,l00b5

	movea.l	l00b5,a0
	move.w	#$1f3f,d0
l0003	clr.l	(a0)+
	dbf	d0,l0003

	movea.l	l00b5,a0
	lea	l00b1,a1
	move.w	#$eff,d0
l0004	move.l	(a1)+,(a0)+
	dbf	d0,l0004

	movea.l	l00b5,a0
	lea	26880(a0),a0
	lea	l00b1,a1
	lea	10400(a1),a1
	move.w	#$4d7,d0
l0005	move.l	(a1)+,(a0)+
	dbf	d0,l0005

	clr.l	-(sp)
	pea	l00b2
	move.w	#6,-(sp)		;setpallete
	trap	#14
	addq.l	#6,sp

	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp
	move.l	d0,-(sp)

	move.b	#$e,$484.l

	moveq	#1,d0
	jsr	l004f
	move.l	#l004f+8,$4d2.w

	lea	l0035,a4
	move.b	#1,l00cb
	move.w	#$64,l00cd
	move.w	#1,l00ce
	move.b	#0,l00da
	move.b	#2,l00db
	bsr	l0026
l0006	bsr	l001b

	move.b	l00cb,l00cc
l0007	subi.b	#1,l00cc
	bsr	l0014
	bsr	l0010
	bsr	l001a

	cmpi.b	#0,l00cc
	bne	l0007

	move.w	#$ff,-(sp)
	move.w	#6,-(sp)		;crawio
	trap	#1
	addq.l	#4,sp

	move.l	d0,d6
	swap	d6
	cmp.b	#$43,d6
	beq	l0018

	cmp.b	#$44,d6
	beq	l0019

	cmp.b	#$41,d6		;#'A'
	beq	l000b

	cmp.b	#$42,d6
	beq	l000c

	cmp.b	#$40,d6
	beq	l000e

l0008	cmp.b	#$20,d0
	bne	l0006

	bsr	l0030

	move.b	#3,$484.l

	clr.l	$4d2.w

	bsr	l000f
	bsr	l0032

	move.w	#$2700,sr
	lea	8.w,a1
	lea	l000a(pc),a0
	moveq	#9,d7
l0009	move.l	(a0)+,(a1)+
	dbf	d7,l0009

	jmp	$12.w

l000a	ori.b	#$c,d0
	movea.l	4.w,a0
	jmp	(a0)

	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp

	clr.l	-(sp)
	trap	#1
;========================================
l000b	cmpi.b	#1,l00db
	beq	l0008

	subi.b	#1,l00db
	move.b	#0,l00da
	bra	l0008

l000c	cmpi.b	#8,l00db
	beq	l0008

	addi.b	#1,l00db
l000d	equ	*-6
	move.b	#0,l00da
	bra	l0008

l000e	move.w	#2,-(sp)
	move.w	#2,-(sp)		;bconin
	trap	#13
	addq.l	#4,sp

	bra	l0008

l000f	move.l	#$8080000,$ffff8800.l
	move.l	#$9090000,$ffff8800.l
	move.l	#$a0a0000,$ffff8800.l
	rts

l0010	movea.l	l00b5,a0
	lea	l00ca,a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	lea	144(a0),a0
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.w	#$3e,d1
	movea.l	l00b5,a0
	movea.l	l00b5,a1
	lea	320(a1),a1
l0011	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	lea	144(a0),a0
	lea	144(a1),a1
	dbf	d1,l0011

	movea.l	l00b5,a1
	lea	9920(a1),a1
	lea	l00ca,a0
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	lea	144(a1),a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	movea.l	l00b5,a0
	movea.l	l00b5,a1
	movea.l	l00b5,a2

	lea	26888(a2),a2
	lea	15360(a1),a1
	move.w	#$1f,d1
l0012	move.l	(a0),(a2)+
	move.l	(a0),124(a2)
	move.l	(a0)+,(a1)+
	move.l	(a0),(a2)+
	move.l	(a0),124(a2)
	move.l	(a0)+,(a1)+
	move.l	(a0),(a2)+
	move.l	(a0),124(a2)
	move.l	(a0)+,(a1)+
	move.l	(a0),(a2)+
	move.l	(a0),124(a2)
	move.l	(a0)+,(a1)+
	lea	304(a0),a0
	lea	-176(a1),a1
	lea	144(a2),a2
	dbf	d1,l0012

	movea.l	l00b5,a0
	movea.l	l00b5,a1
	lea	144(a1),a1
	move.w	#$5f,d1
l0013	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	lea	144(a0),a0
	lea	144(a1),a1
	lea	144(a1),a2
	dbf	d1,l0013
	rts

l0014	move.w	#8,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d5
	movea.l	l00b5,a2
	lea	2624(a2),a2
	lea	l00b0,a3
	adda.l	d2,a3
l0015	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d5,l0015

	move.w	#9,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d5
	movea.l	l00b5,a2
	lea	2624(a2),a2
	lea	8(a2),a2
	lea	l00b0,a3
	adda.l	d2,a3
l0016	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d5,l0016

	move.w	#$a,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d5
	movea.l	l00b5,a2
	lea	2624(a2),a2
	lea	16(a2),a2
	lea	l00b0,a3
	adda.l	d2,a3
l0017	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d5,l0017
	rts

l0018	cmpi.b	#1,l00cb
	beq	l0008

	subi.b	#1,l00cb
	bra	l0008

l0019	cmpi.b	#$a,l00cb
	beq	l0008

	addi.b	#1,l00cb
	bra	l0008

l001a	move.w	#$25,-(sp)		;vsync
	trap	#14
	addq.w	#2,sp
	rts

l001b	movea.l	l00b5,a1
	movea.l	l00b5,a2
	lea	16000(a1),a1
	lea	16000(a2),a2
	lea	8(a1),a1
	lea	(a2),a2
	move.w	#$3e,d5
l001c	move.w	#$25,d1
l001d	move.l	(a1)+,(a2)+
	dbf	d1,l001d

	lea	8(a1),a1
	lea	8(a2),a2
	dbf	d5,l001c

	cmpi.w	#$61a0,(a4)
	beq	l001e

	bra	l001f

l001e	lea	l0035,a4
l001f	move.w	l00cd,d1
	subi.w	#$62,d1
	movea.l	l00b5,a1
	lea	15992(a1),a1
l0020	clr.l	(a1)+
	clr.l	(a1)+
	adda.l	#$98,a1
	dbf	d1,l0020
	move.w	#$a2,d1
	sub.w	l00cd,d1
	movea.l	l00b5,a1
	lea	15992(a1),a1
	lea	4000(a1),a1
l0021	clr.l	(a1)+
	clr.l	(a1)+
	adda.l	#$98,a1
	dbf	d1,l0021

	addi.b	#1,l00da
	move.b	l00db,d0
	cmp.b	l00da,d0
	bne	l0025

	move.b	#0,l00da
	cmpi.w	#$ffff,l00ce
	beq	l0023

	addi.w	#1,l00cd
	cmpi.w	#$83,l00cd
	beq	l0022

	bra	l0025

l0022	move.w	#$ffff,l00ce
	bra	l0025

l0023	subi.w	#1,l00cd
	cmpi.w	#$64,l00cd
	beq	l0024

	bra	l0025

l0024	move.w	#1,l00ce

l0025	dc.w	$a000
	move.w	#$10,l00b7
	move.w	#$19,l00b8
	move.w	#4,l00b9
	move.w	#$f,l00ba
	move.w	#0,l00bb
	move.l	#$3030303,l00bc
	move.w	(a4)+,l00bd
	move.w	#0,l00be
	move.l	#l0033,l00bf
	move.w	#8,l00c0
	move.w	#$a0,l00c1
	move.w	#2,l00c2
	move.w	#$130,l00c3
	move.w	l00cd,l00c4
	move.l	l00b5,l00c5
	move.w	#8,l00c6
	move.w	#$a0,l00c7
	move.w	#2,l00c8
	move.l	#0,l00c9
	lea	l00b7,a6
	dc.w	$a007
	rts

l0026	move.b	$fffffa07.l,l00cf
	move.b	$fffffa09.l,l00d0
	move.l	$70.l,l00d1
	move.l	$120.l,l00d2
	move.b	$fffffa0d.l,l00d3
	move.b	$fffffa0f.l,l00d4
	move.b	$fffffa11.l,l00d5
	move.b	$fffffa13.l,l00d6
	move.b	$fffffa15.l,l00d7
	move.b	$fffffa1b.l,l00d8
	move.b	$fffffa21.l,l00d9

	move.w	sr,d0

	move.w	#$2700,sr

	move.l	$70.l,l00b6
	move.l	#l0027,$70.l

	move.l	#l002a,$120.l
	ori.b	#1,$fffffa13.l

	move.w	d0,sr
	rts

l0027	move.l	#$2040305,$ffff8244.w
	move.l	#$4060507,$ffff8248.w
	move.l	#$6070707,$ffff824c.w
	move.l	#$1150770,$ffff8250.w
	move.l	#$7600650,$ffff8254.w
	move.l	#$5400430,$ffff8258.w
	move.l	#$3200777,$ffff825c.w
	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#$40,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l0028,$120.l

	move.l	l00b6,-(sp)
	rts

l0028	ori.w	#$700,sr

	move.l	#$1030204,$ffff8244.w
	move.l	#$3050406,$ffff8248.w
	move.l	#$5070607,$ffff824c.w
	move.l	#$1150760,$ffff8250.w
	move.l	#$6500540,$ffff8254.w
	move.l	#$4300320,$ffff8258.w
	move.l	#$2100777,$ffff825c.w
	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#$24,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l0029,$120.l
	rte

l0029	ori.w	#$700,sr

	move.l	#$7000710,$ffff8244.w
	move.l	#$7200730,$ffff8248.w
	move.l	#$7400750,$ffff824c.w
	move.l	#$1150770,$ffff8250.w
	move.l	#$7600650,$ffff8254.w
	move.l	#$5400430,$ffff8258.w
	move.l	#$3200777,$ffff825c.w
	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#$a,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l002a,$120.l
	rte

l002a	ori.w	#$700,sr

	move.l	#$7600770,$ffff8244.w
	move.l	#$6700570,$ffff8248.w
	move.l	#$4700370,$ffff824c.w
	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#$a,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l002b,$120.l
	rte

l002b	ori.w	#$700,sr

	move.l	#$2700170,$ffff8244.w
	move.l	#$700073,$ffff8248.w
	move.l	#$750077,$ffff824c.w
	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#$a,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l002c,$120.l
	rte

l002c	ori.w	#$700,sr

	move.l	#$670057,$ffff8244.w
	move.l	#$470037,$ffff8248.w
	move.l	#$270017,$ffff824c.w
	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#$a,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l002d,$120.l
	rte

l002d	ori.w	#$700,sr

	move.l	#$70107,$ffff8244.w
	move.l	#$2070307,$ffff8248.w
	move.l	#$4070507,$ffff824c.w
	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#$a,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l002e,$120.l
	rte

l002e	ori.w	#$700,sr

	move.l	#$6070707,$ffff8244.w
	move.l	#$7060705,$ffff8248.w
	move.l	#$7040703,$ffff824c.w
	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#$a,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l002f,$120.l
	rte

l002f	ori.w	#$700,sr

	move.l	#$2000300,$ffff8244.w
	move.l	#$4000500,$ffff8248.w
	move.l	#$6000700,$ffff824c.w
	move.l	#$1150777,$ffff8250.w
	move.l	#$6660555,$ffff8254.w
	move.l	#$4440333,$ffff8258.w
	move.l	#$2220777,$ffff825c.w
	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	rte

l0030	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	move.b	l00cf,$fffffa07.l
	move.b	l00d0,$fffffa09.l
	move.l	l00d1,$70.l
	move.l	l00d2,$120.l
	move.b	l00d3,$fffffa0d.l
	move.b	l00d4,$fffffa0f.l
	move.b	l00d5,$fffffa11.l
	move.b	l00d6,$fffffa13.l
	move.b	l00d7,$fffffa15.l
	move.b	l00d8,$fffffa1b.l
	move.b	l00d9,$fffffa21.l
	rts

l0031	pea	l00b3
	move.w	#0,-(sp)
	move.w	#$16,-(sp)		;settime
	trap	#14
	addq.l	#8,sp
	rts

l0032	pea	l00b4
	move.w	#0,-(sp)
	move.w	#$16,-(sp)		;settime
	trap	#14
	addq.l	#8,sp
	rts

l0033	incbin	l0033
l0035	incbin	l0035
l004f	incbin	l004f.mus
l00b0	incbin	l00b0
l00b1	incbin	l00b1

l00b2	dc.b	$00,$00,$00,$07,$02,$04,$03,$05
	dc.b	$04,$06,$05,$07,$06,$07,$07,$07
	dc.b	$01,$15,$07,$70,$07,$60,$06,$50
	dc.b	$05,$40,$04,$30,$03,$20,$07,$77

l00b3	dc.b	$12
l00b4	dc.b	$08

;========================================
	bss
;========================================
l00b5	ds.l	1
l00b6	ds.l	1
l00b7	ds.w	1
l00b8	ds.w	1
l00b9	ds.w	1
l00ba	ds.w	1
l00bb	ds.w	1
l00bc	ds.l	1
l00bd	ds.w	1
l00be	ds.w	1
l00bf	ds.l	1
l00c0	ds.w	1
l00c1	ds.w	1
l00c2	ds.w	1
l00c3	ds.w	1
l00c4	ds.w	1
l00c5	ds.l	1
l00c6	ds.w	1
l00c7	ds.w	1
l00c8	ds.w	1
l00c9	ds.b	134
l00ca	ds.b	32
l00cb	ds.b	1
l00cc	ds.b	1
l00cd	ds.w	1
l00ce	ds.w	1
l00cf	ds.w	1
l00d0	ds.w	1
l00d1	ds.l	1
l00d2	ds.l	1
l00d3	ds.w	1
l00d4	ds.w	1
l00d5	ds.w	1
l00d6	ds.w	1
l00d7	ds.w	1
l00d8	ds.w	1
l00d9	ds.b	36
l00da	ds.b	1
l00db	ds.b	1
;========================================
zuend	end
;========================================