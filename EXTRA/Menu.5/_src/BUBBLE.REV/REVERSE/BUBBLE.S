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
	jsr	l0036
	move.l	#l0036+6,$4d2.w

	pea	l002c+2
	move.w	#6,-(sp)		;setpallete
	trap	#14
	addq.l	#2,sp

	move.w	#2,-(sp)		;physbase
	trap	#14
	addq.l	#2,sp
	move.l	d0,l003b

	bsr	l000f

	lea	$fffffa01.w,a5
	move.l	a5,l003c
	andi.b	#$de,18(a5)
	andi.b	#$de,14(a5)
	andi.b	#$de,10(a5)
	andi.b	#$de,6(a5)
	clr.b	24(a5)
	clr.b	26(a5)

	lea	l0018(pc),a0
	move.l	a0,$134.w

	lea	l0038,a0
	move.l	$70.w,(a0)
	lea	l0015(pc),a0
	move.l	a0,$70.w

	move.l	#l0039,d0
	andi.l	#$ffffff00,d0
	addi.l	#$100,d0
	move.l	d0,l003a
	movea.l	d0,a0
	move.w	#$2acf,d1
l0001	clr.l	(a0)+
	dbf	d1,l0001

	movea.l	l003a,a1
	lea	22560(a1),a1
	lea	l002c+34,a2
	lea	10720(a2),a2
	move.w	#$14c7,d1
l0002	move.l	(a2)+,(a1)+
	dbf	d1,l0002

	movea.l	l003a,a1
	lea	14400(a1),a1
	lea	l002c+34,a2
	lea	3840(a2),a2
	move.w	#$63f,d1
l0003	move.l	(a2)+,(a1)+
	dbf	d1,l0003

	move.l	#$ffffffff,-(sp)
	move.l	l003a,-(sp)
	move.l	l003a,-(sp)
	move.w	#5,-(sp)		;setscreen
	trap	#14
	adda.l	#$e,sp

	move.b	#0,l0052
	move.b	#0,l0053
	lea	l002b,a3
	move.b	#1,l0050
	move.b	l0050,l0051

l0004	bsr	l0023
	bsr	l000b
	bsr	l000a

	move.w	#$ff,-(sp)
	move.w	#6,-(sp)		;crawio
	trap	#1
	addq.l	#4,sp

	move.l	d0,d6
	swap	d6
	cmp.b	#$44,d6
	beq	l0009

	cmp.b	#$3b,d6
	beq	l0021

	cmp.b	#$3c,d6
	beq	l0022

l0005	cmp.b	#$20,d0
	bne	l0004

	pea	l0035
	move.w	#$20,-(sp)		;dosound
	trap	#14
	addq.l	#6,sp

	bset	#5,$fffa09.l

	clr.l	$4d2.w

	bsr	l0008

	move.w	sr,-(sp)

	ori.w	#$700,sr

	move.l	l0038,$70.w

	movea.l	l003c,a5
	andi.b	#$de,18(a5)
	andi.b	#$de,14(a5)
	andi.b	#$de,10(a5)
	andi.b	#$de,6(a5)
	clr.b	24(a5)
	clr.b	26(a5)

	bsr	l0010

	move.w	(sp)+,sr

	pea	l0034
	move.w	#0,-(sp)
	move.w	#$19,-(sp)		;ikbdws
	trap	#14
	addq.l	#8,sp

	move.l	#$ffffffff,-(sp)
	move.l	l003b,-(sp)
	move.l	l003b,-(sp)
	move.w	#5,-(sp)		;setscreen
	trap	#14
	adda.l	#$e,sp

	move.w	#$2700,sr

	lea	8.w,a1
	lea	l0007(pc),a0
	moveq	#9,d7
l0006	move.l	(a0)+,(a1)+
	dbf	d7,l0006

	jmp	$12.w

l0007	ori.b	#$c,d0
	movea.l	4.w,a0
	jmp	(a0)

	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp

	clr.l	-(sp)
	trap	#1
;========================================
l0008	move.l	#$8080000,$ffff8800.l
	move.l	#$9090000,$ffff8800.l
	move.l	#$a0a0000,$ffff8800.l
	rts

l0009	move.w	#7,-(sp)		;crawcin
	trap	#1
	addq.w	#2,sp

	bra	l0005

l000a	move.w	#$25,-(sp)		;vsync
	trap	#14
	addq.w	#2,sp
	rts

l000b	move.w	#8,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l003a,a2
	lea	17600(a2),a2
	lea	8(a2),a2
	lea	l002c+34+1280,a0
	adda.l	d2,a0
l000c	move.l	(a0)+,(a2)+
	move.l	(a0)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a0
	dbf	d1,l000c

	move.w	#9,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l003a,a2
	lea	17600(a2),a2
	lea	16(a2),a2
	lea	l002c+34+1280,a0
	adda.l	d2,a0
l000d	move.l	(a0)+,(a2)+
	move.l	(a0)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a0
	dbf	d1,l000d

	move.w	#$a,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#$e
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l003a,a2
	lea	17600(a2),a2
	lea	24(a2),a2
	lea	l002c+34+1280,a0
	adda.l	d2,a0
l000e	move.l	(a0)+,(a2)+
	move.l	(a0)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a0
	dbf	d1,l000e
	rts

l000f	lea	l0012(pc),a0
	move.l	$114.l,2(a0)
	lea	l0011(pc),a0
	move.l	a0,$114.l

	lea	l0014(pc),a0
	move.l	$118.l,2(a0)
	lea	l0013(pc),a0
	move.l	a0,$118.l
	rts

l0010	lea	l0012(pc),a0
	move.l	2(a0),$114.l

	lea	l0014(pc),a0
	move.l	2(a0),$118.l
	rts

l0011	ori.w	#$500,sr
	andi.w	#$fdff,sr

l0012	jmp	$10000

l0013	ori.w	#$500,sr
	andi.w	#$fdff,sr

l0014	jmp	$10000

l0015	move.l	l0038,-(sp)
	movem.l	a0/d0-d1,-(sp)
	lea	$ffff8201.w,a0
	movep.w	0(a0),d0
	movep.w	4(a0),d1
	cmp.w	d0,d1
	bne.s	l0017

	tst.b	8(a0)
	bne.s	l0017

	lea	l0033,a0
	tst.w	(a0)
	beq.s	l0016

	clr.w	(a0)
	movem.l	(sp)+,a0/d0-d1
	rts

l0016	lea	l001b(pc),a0
	move.l	a0,$120.w
	lea	$fffffa01.w,a0
	clr.b	26(a0)
	move.b	#$c7,32(a0)
	move.b	#8,26(a0)
	ori.b	#1,6(a0)
	ori.b	#1,18(a0)
	movem.l	(sp)+,a0/d0-d1
	rts

l0017	lea	$fffffa01.w,a0
	andi.b	#$de,18(a0)
	andi.b	#$de,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
	lea	l0033,a0
	clr.w	(a0)
	movem.l	(sp)+,a0/d0-d1
	rts

l0018	cmpi.b	#1,$fffffa21.w
	bgt.s	l0018

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
	bne	l0019

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

l0019	move.b	#$fc,$ffff820a.w

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
	lea	l001d(pc),a0
	move.w	#$e4,d0
	tst.b	$ffff8209.w
	bne.s	l001a

	cmp.w	d1,d2
	bne.s	l001a

	lea	l001b(pc),a0
	move.w	#$c7,d0
l001a	move.l	a0,$120.w
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

l001b	movem.l	a0-a2/d0,-(sp)
	lea	$fffffa01.w,a0
	lea	$ffff8209.w,a1
	lea	l001f(pc),a2
	lea	-222(a2),a2
	moveq	#0,d0
	andi.b	#$fe,18(a0)
	andi.b	#$fe,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
l001c	move.b	(a1),d0
	cmp.w	#$de,d0
	blt.s	l001c

	cmp.b	#0,d0
	bgt	l0020

	jmp	0(a2,d0.w)

l001d	movem.l	a0-a2/d0,-(sp)
	lea	$fffffa01.w,a0
	lea	$ffff8209.w,a1
	lea	l001f(pc),a2
	moveq	#0,d0
	andi.b	#$fe,18(a0)
	andi.b	#$fe,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
l001e	move.b	(a1),d0
	cmp.b	#8,d0
	blt.s	l001e

	cmp.w	#$20,d0
	bgt	l0020

	jmp	-8(a2,d0.w)

l001f	nop
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
	lea	l0033,a0
	move.w	#$ffff,(a0)
	movem.l	(sp)+,a0-a2/d0
	rte

l0020	bclr	#0,14(a0)
	lea	l0033,a0
	clr.w	(a0)
	movem.l	(sp)+,a0-a2/d0
	rte

l0021	cmpi.b	#1,l0050
	beq	l0005

	subi.b	#1,l0050
	bra	l0005

l0022	cmpi.b	#$a,l0050
	beq	l0005

	addi.b	#1,l0050
	bra	l0005

l0023	subi.b	#1,l0051
	cmpi.b	#0,l0051
	bne	x25492a

	movea.l	l003a,a1
	movea.l	l003a,a2
	lea	$2580(a1),a1
	lea	$2580(a2),a2
	lea	8(a1),a1
	lea	(a2),a2
	move.w	#$18,d5
x254822	move.w	#$25,d1
x254826	move.l	(a1)+,(a2)+
	dbf	d1,x254826
	dbf	d5,x254822

	cmpi.w	#$9a4,(a3)
	bne	x25483e

	lea	l002b,a3
x25483e	dc.w	$a000
	move.w	#$10,l003d
	move.w	#$17,l003e
	move.w	#4,l003f
	move.w	#$f,l0040
	move.w	#0,l0041
	move.l	#$3030303,l0042
	move.w	(a3)+,l0043
	move.w	#0,l0044
	move.l	#l002a,l0045
	move.w	#8,l0046
	move.w	#$a0,l0047
	move.w	#2,l0048
	move.w	#$130,l0049
	move.w	#$3c,l004a
	move.l	l003a,l004b
	move.w	#8,l004c
	move.w	#$a0,l004d
	move.w	#2,l004e
	move.l	#0,l004f

	lea	l003d,a6
	dc.w	$a007
	movea.l	l003a,a0
	movea.l	l003a,a1
	lea	9600(a0),a0
	lea	0(a1),a1
	move.w	#$17,d0
l0024	move.w	#$27,d1
l0025	cmpi.b	#1,l0053
	bne	l0026

	move.l	(a0),160(a1)
l0026	move.l	(a0)+,(a1)+
	dbf	d1,l0025

	lea	160(a1),a1
	dbf	d0,l0024

	move.b	l0050,l0051
x25492a	addi.b	#1,l0052
	cmpi.b	#$c8,l0052
	bne	l0029

	move.b	#0,l0052
	addi.b	#1,l0053
	cmpi.b	#2,l0053
	bne	l0029

	move.b	#0,l0053
	movea.l	l003a,a0
	lea	160(a0),a0
	move.w	#$17,d1
l0027	move.w	#$27,d0
l0028	clr.l	(a0)+
	dbf	d0,l0028

	lea	160(a0),a0
	dbf	d1,l0027
l0029	rts

l002a	incbin	l002a
l002b	incbin	l002b
l002c	incbin	l002c.pi1
;========================================
	data
;========================================
l0033	dc.b	$00,$00,$12
l0034	dc.b	$08

l0035	dc.b	$07,$ff,$06,$00,$08,$00,$09,$00,$0a,$00

l0036	incbin	l0036.mus
;========================================
	bss
;========================================
l0038	ds.l	1
l0039	ds.b	44096
l003a	ds.l	1
l003b	ds.l	1
l003c	ds.l	1
l003d	ds.w	1
l003e	ds.w	1
l003f	ds.w	1
l0040	ds.w	1
l0041	ds.w	1
l0042	ds.l	1
l0043	ds.w	1
l0044	ds.w	1
l0045	ds.l	1
l0046	ds.w	1
l0047	ds.w	1
l0048	ds.w	1
l0049	ds.w	1
l004a	ds.w	1
l004b	ds.l	1
l004c	ds.w	1
l004d	ds.w	1
l004e	ds.w	1
l004f	ds.b	134
l0050	ds.b	1
l0051	ds.b	1
l0052	ds.b	1
l0053	ds.b	1
;========================================
zuend	end
;========================================