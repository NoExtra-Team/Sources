;	opt	x+
;========================================
	text
;========================================
begin	move.w	#2,-(sp)		;physbase
	trap	#14
	addq.l	#6,sp
	move.l	d0,l00b5

	pea	l00b1
	move.w	#0,-(sp)
	move.w	#$19,-(sp)		;ikbdws
	trap	#14
	addq.l	#8,sp

	clr.l	-(sp)
	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp
	move.l	d0,-(sp)

	dc.w	$a00a

	move.b	#$e,$484.l

	moveq	#1,d0
	jsr	l0041
	move.l	#l0041+6,$4d2.w

	pea	l003d+2
	move.w	#6,-(sp)		;setpallete
	trap	#14
	addq.l	#6,sp

	bsr	l001c

	lea	$fffffa01.w,a5
	move.l	a5,l00b7
	andi.b	#$de,18(a5)
	andi.b	#$de,14(a5)
	andi.b	#$de,10(a5)
	andi.b	#$de,6(a5)
	clr.b	24(a5)
	clr.b	26(a5)

	lea	l0025(pc),a0
	move.l	a0,$134.w

	lea	l00b3,a0
	move.l	$70.w,(a0)

	lea	l0022(pc),a0
	move.l	a0,$70.w

	move.l	#l00b4,d0
	andi.l	#$ffffff00,d0
	addi.l	#$100,d0
	move.l	d0,l00b6

	movea.l	d0,a2
	movea.l	a2,a0
	move.w	#$2acf,d1
l0005	clr.l	(a0)+
	dbf	d1,l0005

	movea.l	a2,a0
	lea	l003d,a1
	lea	34(a1),a1
	move.w	#$1a3f,d1
l0006	move.l	(a1)+,(a0)+
	dbf	d1,l0006

	movea.l	a2,a0
	lea	l003d,a1
	lea	34(a1),a1
	lea	30720(a0),a0
	lea	30720(a1),a1
	move.w	#$13f,d1
l0007	move.l	(a1)+,(a0)+
	dbf	d1,l0007

	lea	l0040,a1
	move.w	#$b8f,d1
l0008	move.l	(a1)+,(a0)+
	dbf	d1,l0008

	move.l	#$ffffffff,-(sp)
	move.l	a2,-(sp)
	move.l	#$ffffffff,-(sp)
	move.w	#5,-(sp)		;setscreen
	trap	#14
	adda.l	#$e,sp

	lea	l003c,a4
	lea	l00af,a5
	lea	80(a5),a5
	move.w	#0,l00cb
	move.b	#1,l00ce
	move.w	#$90,l00cc
	move.w	#$50,l00cd
	move.b	l00ce,l00cf

l0009	bsr	l002f
	bsr	l0037
	bsr	l0016
	bsr	l002e

	move.w	#$ff,-(sp)
	move.w	#6,-(sp)		;crawio
	trap	#1
	addq.l	#4,sp

	move.l	d0,d6
	swap	d6
	cmp.b	#$3b,d6
	beq	l001a

	cmp.b	#$3c,d6
	beq	l001b

	cmp.b	#$3d,d6
	beq	l000f

	cmp.b	#$3e,d6
	beq	l0010

	cmp.b	#$3f,d6
	beq	l0011

	cmp.b	#$40,d6
	beq	l0012

	cmp.b	#$41,d6		;#'A'
	beq	l0013

	cmp.b	#$42,d6
	beq	l0014

	cmp.b	#$43,d6
	beq	l0015

	cmp.b	#$44,d6
	beq	l000e

l000a	cmp.b	#$20,d0
	bne	l0009

	move.w	sr,-(sp)

	ori.w	#$700,sr

	move.l	l00b3,$70.w

	movea.l	l00b7,a5
	andi.b	#$de,18(a5)
	andi.b	#$de,14(a5)
	andi.b	#$de,10(a5)
	andi.b	#$de,6(a5)
	clr.b	24(a5)
	clr.b	26(a5)
	bsr	l001d

	move.b	#3,$484.l

	clr.l	$4d2.w

	bsr	l000d

	move.w	(sp)+,sr

	pea	l00b2
	move.w	#0,-(sp)
	move.w	#$19,-(sp)		;ikbdws
	trap	#14
	addq.l	#8,sp

	move.l	#$ffffffff,-(sp)
	move.l	l00b5,-(sp)
	move.l	l00b5,-(sp)
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

l000e	move.w	#2,-(sp)
	move.w	#2,-(sp)		;bconin
	trap	#13
	addq.l	#4,sp

	bra	l000a

l000f	move.w	#0,l00cc
	move.w	#$30,l00cd
	bra	l000a

l0010	move.w	#$10,l00cc
	move.w	#$30,l00cd
	bra	l000a

l0011	move.w	#$20,l00cc
	move.w	#$30,l00cd
	bra	l000a

l0012	move.w	#$40,l00cc
	move.w	#$50,l00cd
	bra	l000a

l0013	move.w	#$80,l00cc
	move.w	#$50,l00cd
	bra	l000a

l0014	move.w	#$90,l00cc
	move.w	#$50,l00cd
	bra	l000a

l0015	move.w	#$60,l00cc
	move.w	#$70,l00cd
	bra	l000a

l0016	move.w	#8,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d5
	movea.l	l00b6,a2
	lea	20936(a2),a2
	lea	l00ae,a3
	adda.l	d2,a3
l0017	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d5,l0017

	move.w	#9,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d5
	movea.l	l00b6,a2
	lea	20936(a2),a2
	lea	8(a2),a2
	lea	l00ae,a3
	adda.l	d2,a3
l0018	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d5,l0018

	move.w	#$a,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d5
	movea.l	l00b6,a2
	lea	20936(a2),a2
	lea	16(a2),a2
	lea	l00ae,a3
	adda.l	d2,a3
l0019	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d5,l0019
	rts

l001a	cmpi.b	#1,l00ce
	beq	l000a

	subi.b	#1,l00ce
	bra	l000a

l001b	cmpi.b	#$a,l00ce
	beq	l000a

	addi.b	#1,l00ce
	bra	l000a

l001c	lea	l001f(pc),a0
	move.l	$114.l,2(a0)
	lea	l001e(pc),a0
	move.l	a0,$114.l

	lea	l0021(pc),a0
	move.l	$118.l,2(a0)
	lea	l0020(pc),a0
	move.l	a0,$118.l
	rts

l001d	lea	l001f(pc),a0
	move.l	2(a0),$114.l

	lea	l0021(pc),a0
	move.l	2(a0),$118.l
	rts

l001e	ori.w	#$500,sr
	andi.w	#$fdff,sr

l001f	jmp	$10000

l0020	ori.w	#$500,sr
	andi.w	#$fdff,sr

l0021	jmp	$10000

l0022	move.l	l00b3,-(sp)
	movem.l	a0/d0-d1,-(sp)
	lea	$ffff8201.w,a0
	movep.w	0(a0),d0
	movep.w	4(a0),d1
	cmp.w	d0,d1
	bne.s	l0024

	tst.b	8(a0)
	bne.s	l0024

	lea	l00b0,a0
	tst.w	(a0)
	beq.s	l0023

	clr.w	(a0)
	movem.l	(sp)+,a0/d0-d1
	rts

l0023	lea	l0028(pc),a0
	move.l	a0,$120.w
	lea	$fffffa01.w,a0
	clr.b	26(a0)
	move.b	#$c7,32(a0)
	move.b	#8,26(a0)
	ori.b	#1,6(a0)
	ori.b	#1,18(a0)
	movem.l	(sp)+,a0/d0-d1
	rts

l0024	lea	$fffffa01.w,a0
	andi.b	#$de,18(a0)
	andi.b	#$de,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
	lea	l00b0,a0
	clr.w	(a0)
	movem.l	(sp)+,a0/d0-d1
	rts

l0025	cmpi.b	#1,$fffffa21.w
	bgt.s	l0025

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
	bne	l0026

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

l0026	move.b	#$fc,$ffff820a.w

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
	lea	l002a(pc),a0
	move.w	#$e4,d0
	tst.b	$ffff8209.w
	bne.s	l0027

	cmp.w	d1,d2
	bne.s	l0027

	lea	l0028(pc),a0
	move.w	#$c7,d0
l0027	move.l	a0,$120.w
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

l0028	movem.l	a0-a2/d0,-(sp)
	lea	$fffffa01.w,a0
	lea	$ffff8209.w,a1
	lea	l002c(pc),a2
	lea	-222(a2),a2
	moveq	#0,d0
	andi.b	#$fe,18(a0)
	andi.b	#$fe,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
l0029	move.b	(a1),d0
	cmp.w	#$de,d0
	blt.s	l0029

	cmp.b	#0,d0
	bgt	l002d

	jmp	0(a2,d0.w)

l002a	movem.l	a0-a2/d0,-(sp)
	lea	$fffffa01.w,a0
	lea	$ffff8209.w,a1
	lea	l002c(pc),a2
	moveq	#0,d0
	andi.b	#$fe,18(a0)
	andi.b	#$fe,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
l002b	move.b	(a1),d0
	cmp.b	#8,d0
	blt.s	l002b

	cmp.w	#$20,d0
	bgt	l002d

	jmp	-8(a2,d0.w)

l002c	nop
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
	lea	l00b0,a0
	move.w	#$ffff,(a0)
	movem.l	(sp)+,a0-a2/d0
	rte

l002d	bclr	#0,14(a0)
	lea	l00b0,a0
	clr.w	(a0)
	movem.l	(sp)+,a0-a2/d0
	rte

l002e	move.w	#$25,-(sp)		;vsync
	trap	#14
	addq.w	#2,sp
	rts

l002f	subi.b	#1,l00cf
	cmpi.b	#0,l00cf
	bne	l0036

	movea.l	l00b6,a1
	movea.l	l00b6,a2
	lea	25600(a1),a1
	lea	25600(a2),a2
	lea	8(a1),a1
	lea	(a2),a2
	move.w	#$1a,d5
l0030	move.w	#$25,d1
l0031	move.l	(a1)+,(a2)+
	dbf	d1,l0031
	dbf	d5,l0030

	cmpi.w	#$61a0,(a4)
	beq	l0032

	bra	l0033

l0032	lea	l003c,a4

l0033	dc.w	$a000
	move.w	#$10,l00b8
	move.w	#$19,l00b9
	move.w	#4,l00ba
	move.w	#$f,l00bb
	move.w	#0,l00bc
	move.l	#$3030303,l00bd
	move.w	(a4)+,l00be
	move.w	#0,l00bf
	move.l	#l003a,l00c0
	move.w	#8,l00c1
	move.w	#$a0,l00c2
	move.w	#2,l00c3
	move.w	#$130,l00c4
	move.w	#$a0,l00c5
	move.l	l00b6,l00c6
	move.w	#8,l00c7
	move.w	#$a0,l00c8
	move.w	#2,l00c9
	move.l	#0,l00ca

	lea	l00b8,a6
	dc.w	$a007
	movea.l	l00b6,a0
	movea.l	l00b6,a1
	lea	29440(a0),a0
	lea	29760(a1),a1
	move.w	#9,d0
l0034	move.w	#$27,d1
l0035	move.l	(a0)+,(a1)+
	dbf	d1,l0035

	lea	-640(a0),a0
	dbf	d0,l0034

	move.b	l00ce,l00cf
l0036	rts

l0037	addi.w	#1,l00cb
	cmpi.w	#$168,l00cb
	beq	l0038

	bra	l0039

l0038	lea	l00af,a5
	lea	$50(a5),a5
	move.w	#0,l00cb
l0039	dc.w	$a000
	move.w	#$10,l00b8
	move.w	#$10,l00b9
	move.w	#4,l00ba
	move.w	#$f,l00bb
	move.w	#0,l00bc
	move.l	#$3030303,l00bd
	move.w	-$50(a5),l00be
	move.w	#0,l00bf
	move.l	#l003d+34,l00c0
	move.w	#8,l00c1
	move.w	#$a0,l00c2
	move.w	#2,l00c3
	move.w	-$50(a5),l00c4
	move.w	#0,l00c5
	move.l	l00b6,l00c6
	move.w	#8,l00c7
	move.w	#$a0,l00c8
	move.w	#2,l00c9
	move.l	#0,l00ca

	lea	l00b8,a6
	dc.w	$a007
	dc.w	$a000
	move.w	#$10,l00b8
	move.w	#$10,l00b9
	move.w	#4,l00ba
	move.w	#$f,l00bb
	move.w	#0,l00bc
	move.l	#$4040404,l00bd
	move.w	l00cd,l00be
	move.w	#$a8,l00bf
	move.l	#l003d+34,l00c0
	move.w	#8,l00c1
	move.w	#$a0,l00c2
	move.w	#2,l00c3
	move.w	(a5),l00c4
	move.w	#0,l00c5
	move.l	l00b6,l00c6
	move.w	#8,l00c7
	move.w	#$a0,l00c8
	move.w	#2,l00c9
	move.l	#0,l00ca

	lea	l00b8,a6
	dc.w	$a007
	dc.w	$a000
	move.w	#$10,l00b8
	move.w	#$10,l00b9
	move.w	#4,l00ba
	move.w	#$f,l00bb
	move.w	#0,l00bc
	move.l	#$7070707,l00bd
	move.w	l00cc,l00be
	move.w	#$a8,l00bf
	move.l	#l003d+34,l00c0
	move.w	#8,l00c1
	move.w	#$a0,l00c2
	move.w	#2,l00c3
	move.w	(a5)+,l00c4
	move.w	#0,l00c5
	move.l	l00b6,l00c6
	move.w	#8,l00c7
	move.w	#$a0,l00c8
	move.w	#2,l00c9
	move.l	#0,l00ca

	lea	l00b8,a6
	dc.w	$a007
	rts

l003a	incbin	l003a
l003c	incbin	l003c
l003d	incbin	l003d.pi1
l0040	incbin	l0040
l0041	incbin	l0041.mus
l00ae	incbin	l00ae
l00af	incbin	l00af
;========================================
	data
;========================================
l00b0	dc.b	$00,$00
l00b1	dc.b	$12
l00b2	dc.b	$08
;========================================
	bss
;========================================
l00b3	ds.l	1
l00b4	ds.b	44096
l00b5	ds.l	1
l00b6	ds.l	1
l00b7	ds.l	1
l00b8	ds.w	1
l00b9	ds.w	1
l00ba	ds.w	1
l00bb	ds.w	1
l00bc	ds.w	1
l00bd	ds.l	1
l00be	ds.w	1
l00bf	ds.w	1
l00c0	ds.l	1
l00c1	ds.w	1
l00c2	ds.w	1
l00c3	ds.w	1
l00c4	ds.w	1
l00c5	ds.w	1
l00c6	ds.l	1
l00c7	ds.w	1
l00c8	ds.w	1
l00c9	ds.w	1
l00ca	ds.b	134
l00cb	ds.w	1
l00cc	ds.w	1
l00cd	ds.w	1
l00ce	ds.b	1
l00cf	ds.b	1
;========================================
zuend	end
;========================================