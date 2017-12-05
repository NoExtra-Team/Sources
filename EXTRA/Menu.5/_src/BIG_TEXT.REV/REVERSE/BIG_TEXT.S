;	opt	x+
;========================================
	text
;========================================
begin	dc.w	$a00a

	clr.l	-(sp)
	move.w	#$20,-(sp)
	trap	#1
	addq.l	#6,sp

	move.l	d0,-(sp)

	move.b	#$e,$484

	moveq	#1,d0
	jsr	l0030
	move.l	#l0030+6,$4d2.w

	pea	l0029
	move.w	#6,-(sp)		;setpallete
	trap	#14
	addq.l	#2,sp

	move.w	#2,-(sp)		;physbase
	trap	#14
	addq.l	#2,sp
	move.l	d0,l0035

	bsr	l0010

	lea	$fffffa01.w,a5
	move.l	a5,l0036
	andi.b	#$de,18(a5)
	andi.b	#$de,14(a5)
	andi.b	#$de,10(a5)
	andi.b	#$de,6(a5)
	clr.b	24(a5)
	clr.b	26(a5)

	lea	l0019(pc),a0
	move.l	a0,$134.w

	lea	l0032,a0
	move.l	$70.w,(a0)
	lea	l0016(pc),a0
	move.l	a0,$70.w

	move.l	#l0033,d0
	andi.l	#$ffffff00,d0
	addi.l	#$100,d0
	move.l	d0,l0034
	movea.l	d0,a0
	move.w	#$2acf,d1
l0002	clr.l	(a0)+
	dbf	d1,l0002

	lea	l002a,a0
	movea.l	l0034,a1
	move.w	#$987,d0
l0003	move.l	(a0)+,(a1)+
	dbf	d0,l0003

	lea	l002a,a0
	movea.l	l0034,a1
	lea	32000(a1),a1
	lea	4480(a1),a1
	move.w	#$72f,d0
l0004	move.l	(a0)+,(a1)+
	dbf	d0,l0004

	movea.l	l0034,a1
	lea	15040(a1),a1
	move.w	#$27,d0
	move.w	#7,d1
l0005	move.w	d0,d2
	lea	l002b,a0
l0006	move.l	(a0)+,(a1)+
	dbf	d2,l0006
	addi.w	#$28,d0
	dbf	d1,l0005

	move.l	#$ffffffff,-(sp)
	move.l	l0034,-(sp)
	move.l	l0034,-(sp)
	move.w	#5,-(sp)		;setscreen
	trap	#14
	adda.l	#$e,sp

	lea	l002c,a4

	move.l	a4,-(sp)

	lea	l0028,a3
	move.b	#1,l004a
	move.b	l004a,l004b
	move.b	#0,l004c
l0007	bsr	l0024

	addi.b	#1,l004c
	cmpi.b	#2,l004c
	bne	l0009

	move.b	#0,l004c

	movea.l	(sp)+,a4

	cmpi.w	#$ffff,(a4)
	bne	l0008

	lea	l002c,a4
l0008	move.l	(a4)+,$ffff8242.l
	move.l	(a4)+,$ffff8246.l
	move.l	(a4)+,$ffff824a.l
	move.l	a4,-(sp)

l0009	bsr	l000f

	move.w	#$ff,-(sp)
	move.w	#6,-(sp)		;crawio
	trap	#1
	addq.l	#4,sp

	move.l	d0,d6
	swap	d6
	cmp.b	#$44,d6
	beq	l000e

	cmp.b	#$3b,d6
	beq	l0022

	cmp.b	#$3c,d6
	beq	l0023

l000a	cmp.b	#$20,d0
	bne	l0007

	pea	l002f
	move.w	#$20,-(sp)		;dosound
	trap	#14
	addq.l	#6,sp

	bset	#5,$fffa09.l

	clr.l	$4d2.w

	bsr	l000d

	move.w	sr,-(sp)

	ori.w	#$700,sr

	move.l	l0032,$70.w

	movea.l	l0036,a5
	andi.b	#$de,18(a5)
	andi.b	#$de,14(a5)
	andi.b	#$de,10(a5)
	andi.b	#$de,6(a5)
	clr.b	24(a5)
	clr.b	26(a5)
	bsr	l0011

	move.w	(sp)+,sr

	pea	l002e
	move.w	#0,-(sp)
	move.w	#$19,-(sp)		;ikbdws
	trap	#14
	addq.l	#8,sp

	move.l	#$ffffffff,-(sp)
	move.l	l0035,-(sp)
	move.l	l0035,-(sp)
	move.w	#5,-(sp)		;setscreen
	trap	#14
	adda.l	#$e,sp

	move.w	#$2700,sr

	lea	8.w,a1
	lea	l000c(pc),a0
	moveq	#9,d7
l000b	move.l	(a0)+,(a1)+
	dbf	d7,l000b

	jmp	$12.w

l000c	ori.b	#$c,d0
	movea.l	4.w,a0
	jmp	(a0)

	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp

	clr.l	-(sp)
	trap	#1
;========================================
l000d	move.l	#$8080000,$ffff8800.l
	move.l	#$9090000,$ffff8800.l
	move.l	#$a0a0000,$ffff8800.l
	rts

l000e	move.w	#7,-(sp)		;crawcin
	trap	#1
	addq.w	#2,sp

	bra	l000a

l000f	move.w	#$25,-(sp)		;vsync
	trap	#14
	addq.w	#2,sp
	rts

l0010	lea	l0013(pc),a0
	move.l	$114.l,2(a0)
	lea	l0012(pc),a0
	move.l	a0,$114.l

	lea	l0015(pc),a0
	move.l	$118.l,2(a0)
	lea	l0014(pc),a0
	move.l	a0,$118.l
	rts

l0011	lea	l0013(pc),a0
	move.l	2(a0),$114.l

	lea	l0015(pc),a0
	move.l	2(a0),$118.l
	rts

l0012	ori.w	#$500,sr
	andi.w	#$fdff,sr

l0013	jmp	$10000

l0014	ori.w	#$500,sr
	andi.w	#$fdff,sr

l0015	jmp	$10000

l0016	move.l	l0032,-(sp)
	movem.l	a0/d0-d1,-(sp)
	lea	$ffff8201.w,a0
	movep.w	0(a0),d0
	movep.w	4(a0),d1
	cmp.w	d0,d1
	bne.s	l0018

	tst.b	8(a0)
	bne.s	l0018

	lea	l002d,a0
	tst.w	(a0)
	beq.s	l0017

	clr.w	(a0)
	movem.l	(sp)+,a0/d0-d1
	rts

l0017	lea	l001c(pc),a0
	move.l	a0,$120.w
	lea	$fffffa01.w,a0
	clr.b	26(a0)
	move.b	#$c7,32(a0)
	move.b	#8,26(a0)
	ori.b	#1,6(a0)
	ori.b	#1,18(a0)
	movem.l	(sp)+,a0/d0-d1
	rts

l0018	lea	$fffffa01.w,a0
	andi.b	#$de,18(a0)
	andi.b	#$de,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
	lea	l002d,a0
	clr.w	(a0)
	movem.l	(sp)+,a0/d0-d1
	rts

l0019	cmpi.b	#1,$fffffa21.w
	bgt.s	l0019

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

	cmpi.l	#$a100,$432.l
	bne	l001a

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

l001a	move.b	#$fc,$ffff820a.w

	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop

	move.b	#$fe,$ffff820a.w

	movem.l	a0/d0-d2,-(sp)
	lea	$ffff8201.w,a0
	movep.w	0(a0),d1
	movep.w	4(a0),d2
	lea	l001e(pc),a0
	move.w	#$e4,d0
	tst.b	$ffff8209.w
	bne.s	l001b

	cmp.w	d1,d2
	bne.s	l001b

	lea	l001c(pc),a0
	move.w	#$c7,d0
l001b	move.l	a0,$120.w
	lea	$fffffa01.w,a0
	clr.b	26(a0)
	move.b	d0,32(a0)
	move.b	#8,26(a0)
	ori.b	#1,6(a0)
	ori.b	#1,18(a0)
	clr.b	24(a0)
	bclr	#5,14(a0)
	movem.l	(sp)+,a0/d0-d2
	rte

l001c	movem.l	a0-a2/d0,-(sp)
	lea	$fffffa01.w,a0
	lea	$ffff8209.w,a1
	lea	l0020(pc),a2
	lea	-222(a2),a2
	moveq	#0,d0
	andi.b	#$fe,18(a0)
	andi.b	#$fe,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
l001d	move.b	(a1),d0
	cmp.w	#$de,d0
	blt.s	l001d

	cmp.b	#0,d0
	bgt	l0021

	jmp	0(a2,d0.w)

l001e	movem.l	a0-a2/d0,-(sp)
	lea	$fffffa01.w,a0
	lea	$ffff8209.w,a1
	lea	l0020(pc),a2
	moveq	#0,d0
	andi.b	#$fe,18(a0)
	andi.b	#$fe,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
l001f	move.b	(a1),d0
	cmp.b	#8,d0
	blt.s	l001f

	cmp.w	#$20,d0
	bgt	l0021

	jmp	-8(a2,d0.w)

l0020	nop
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

	move.b	#$fc,$ffff820a.w

	nop

	move.b	#$fe,$ffff820a.w

	move.b	#$84,32(a0)
	move.b	#6,26(a0)
	move.b	#$81,30(a0)
	move.b	#6,24(a0)
	ori.b	#$20,6(a0)
	ori.b	#$20,18(a0)
	bclr	#0,14(a0)
	lea	l002d,a0
	move.w	#$ffff,(a0)
	movem.l	(sp)+,a0-a2/d0
	rte

l0021	bclr	#0,14(a0)
	lea	l002d,a0
	clr.w	(a0)
	movem.l	(sp)+,a0-a2/d0
	rte

l0022	cmpi.b	#1,l004a
	beq	l000a

	subi.b	#1,l004a
	bra	l000a

l0023	cmpi.b	#$a,l004a
	beq	l000a

	addi.b	#1,l004a
	bra	l000a

l0024	subi.b	#1,l004b
	cmpi.b	#0,l004b
	bne	x2548b0

	movea.l	l0034,a1
	movea.l	l0034,a0
	lea	$26c0(a1),a1
	lea	$26c0(a0),a0
	lea	8(a1),a1
	lea	(a0),a0
	move.w	#$18,d5
x2547b0	move.w	#$25,d1
x2547b4	move.l	(a1)+,(a0)+
	dbf	d1,x2547b4
	dbf	d5,x2547b0

	cmpi.w	#$9a4,(a3)
	bne	x2547cc

	lea	l0028,a3
x2547cc	dc.w	$a000
	move.w	#$10,l0037
	move.w	#$17,l0038
	move.w	#4,l0039
	move.w	#$f,l003a
	move.w	#0,l003b
	move.l	#$3030303,l003c
	move.w	(a3)+,l003d
	move.w	#0,l003e
	move.l	#l0027,l003f
	move.w	#8,l0040
	move.w	#$a0,l0041
	move.w	#2,l0042
	move.w	#$130,l0043
	move.w	#$3e,l0044
	move.l	l0034,l0045
	move.w	#8,l0046
	move.w	#$a0,l0047
	move.w	#2,l0048
	move.l	#0,l0049

	lea	l0037,a6
	dc.w	$a007
	movea.l	l0034,a0
	movea.l	l0034,a1
	lea	9920(a0),a0
	lea	25280(a1),a1
	move.w	#$16,d0
l0025	move.w	#$27,d1
l0026	move.l	(a0),160(a1)
	move.l	(a0),320(a1)
	move.l	(a0)+,(a1)+
	dbf	d1,l0026

	lea	320(a1),a1
	dbf	d0,l0025

	move.b	l004a,l004b
x2548b0	rts

l0027	incbin	l0027
l0028	incbin	l0028

l0029	dc.b	$00,$00,$00,$05,$00,$16,$00,$37
	dc.b	$00,$47,$00,$57,$00,$77,$06,$42
	dc.b	$06,$52,$06,$62,$07,$73,$03,$33
	dc.b	$04,$44,$05,$55,$06,$66,$07,$77

l002a	incbin	l002a
l002b	incbin	l002b
;========================================
	data
;========================================
l002c	dc.b	$00,$05,$00,$16,$00,$37,$00,$47
	dc.b	$00,$57,$00,$77,$00,$04,$00,$05
	dc.b	$00,$26,$00,$36,$00,$46,$00,$67
	dc.b	$00,$03,$00,$04,$00,$15,$00,$25
	dc.b	$00,$35,$00,$57,$00,$02,$00,$03
	dc.b	$00,$04,$00,$14,$00,$24,$00,$46
	dc.b	$00,$01,$00,$02,$00,$03,$00,$03
	dc.b	$00,$13,$00,$35,$00,$00,$00,$01
	dc.b	$00,$02,$00,$02,$00,$02,$00,$24
	dc.b	$00,$01,$00,$02,$00,$03,$00,$03
	dc.b	$00,$13,$00,$35,$00,$02,$00,$03
	dc.b	$00,$04,$00,$14,$00,$24,$00,$46
	dc.b	$00,$03,$00,$04,$00,$15,$00,$25
	dc.b	$00,$35,$00,$57,$00,$04,$00,$05
	dc.b	$00,$26,$00,$36,$00,$46,$00,$67
	dc.b	$00,$05,$00,$16,$00,$37,$00,$47
	dc.b	$00,$57,$00,$77,$00,$05,$00,$16
	dc.b	$00,$37,$00,$47,$00,$57,$00,$77
	dc.b	$00,$05,$00,$16,$00,$37,$00,$47
	dc.b	$00,$57,$00,$77,$00,$05,$00,$16
	dc.b	$00,$37,$00,$47,$00,$57,$00,$77
	dc.b	$00,$05,$00,$16,$00,$37,$00,$47
	dc.b	$00,$57,$00,$77,$00,$05,$00,$16
	dc.b	$00,$37,$00,$47,$00,$57,$00,$77
	dc.b	$00,$05,$00,$16,$00,$37,$00,$47
	dc.b	$00,$57,$00,$77,$00,$05,$00,$16
	dc.b	$00,$37,$00,$47,$00,$57,$00,$77
	dc.b	$00,$05,$00,$16,$00,$37,$00,$47
	dc.b	$00,$57,$00,$77,$ff,$ff

l002d	dc.b	$00,$00,$12
l002e	dc.b	$08

l002f	dc.b	$07,$ff,$06,$00,$08,$00,$09,$00,$0a,$00

l0030	incbin	l0030.mus
;========================================
	bss
;========================================
l0032	ds.l	1
l0033	ds.b	44096
l0034	ds.l	1
l0035	ds.l	1
l0036	ds.l	1
l0037	ds.w	1
l0038	ds.w	1
l0039	ds.w	1
l003a	ds.w	1
l003b	ds.w	1
l003c	ds.l	1
l003d	ds.w	1
l003e	ds.w	1
l003f	ds.l	1
l0040	ds.w	1
l0041	ds.w	1
l0042	ds.w	1
l0043	ds.w	1
l0044	ds.w	1
l0045	ds.l	1
l0046	ds.w	1
l0047	ds.w	1
l0048	ds.w	1
l0049	ds.b	134
l004a	ds.b	1
l004b	ds.b	1
l004c	ds.w	1
;========================================
zuend	end
;========================================