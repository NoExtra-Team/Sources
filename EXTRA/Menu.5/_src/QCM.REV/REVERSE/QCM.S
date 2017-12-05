;	opt	x+
;========================================
	text
;========================================
begin	dc.w	$a00a

	pea	l003d
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

	lea	l003a,a0
	lea	$43fde,a1
	move.l	#$bb7,d1
l0000	move.l	(a0)+,(a1)+
	dbf	d1,l0000

	moveq	#1,d0
	jsr	$43fde
	move.l	#$43fe6,$4d2.w

	move.w	#2,-(sp)		;physbase
	trap	#14
	addq.l	#2,sp
	move.l	d0,l0042

	pea	l0036+2
	move.w	#6,-(sp)		;setpallete
	trap	#14
	addq.l	#6,sp

	bsr	l001f

	lea	$fffffa01.w,a5
	move.l	a5,l0043
	andi.b	#$de,18(a5)
	andi.b	#$de,14(a5)
	andi.b	#$de,10(a5)
	andi.b	#$de,6(a5)
	clr.b	24(a5)
	clr.b	26(a5)

	lea	l0028(pc),a0
	move.l	a0,$134.w

	lea	l003f,a0
	move.l	$70.w,(a0)
	lea	l0025(pc),a0
	move.l	a0,$70.w

	move.l	#l0040,d0
	andi.l	#$ffffff00,d0
	addi.l	#$100,d0
	move.l	d0,l0041
	movea.l	d0,a2
	movea.l	a2,a0
	move.w	#$2acf,d1
l0001	clr.l	(a0)+
	dbf	d1,l0001

	move.l	#$ffffffff,-(sp)
	move.l	l0041,-(sp)
	move.l	l0041,-(sp)
	move.w	#5,-(sp)		;setscreen
	trap	#14
	adda.l	#$e,sp

	movea.l	l0041,a0
	lea	10240(a0),a0
	lea	l0036,a1
	lea	34(a1),a1
	lea	10240(a1),a1
	move.w	#$153f,d1
l0002	move.l	(a1)+,(a0)+
	dbf	d1,l0002

	lea	l0036,a1
	lea	34(a1),a1
	lea	5120(a1),a1
	move.w	#$3bf,d1
l0003	move.l	(a1)+,(a0)+
	dbf	d1,l0003

	move.w	#0,l0044
	lea	l0035,a5
	move.w	#$13,d4
	lea	l0031,a4

l0004	pea	l0032
	move.w	#9,-(sp)		;cconws
	trap	#1
	addq.l	#6,sp

	pea	(a4)
	move.w	#9,-(sp)		;cconws
	trap	#1
	addq.l	#6,sp

l0005	addq.l	#1,a4
	cmpi.b	#0,(a4)
	bne	l0005

	addq.l	#1,a4
	lea	l0036+34,a6
	lea	160(a6),a6
	move.w	#9,d7
l0006	suba.l	#$10,a6
	bsr	l0012

	move.w	#$32,d3

l0007	move.w	#$ff,-(sp)
	move.w	#6,-(sp)		;crawio
	trap	#1
	addq.l	#4,sp

	cmp.b	#0,d0
	bne	l0008

	bsr	l0014
	bsr	l0011

	dbf	d3,l0007
	dbf	d7,l0006

l0008	move.b	0(a5,d4.w),d1
	cmp.b	d1,d0
	beq	l0009

	bra	l000a

l0009	addq.b	#1,l0044
l000a	movea.l	l0041,a0
	move.w	#$8bf,d2
l000b	clr.l	(a0)+
	dbf	d2,l000b
	dbf	d4,l0004

	pea	l0033
	move.w	#9,-(sp)		;cconws
	trap	#1
	addq.l	#6,sp

	move.b	l0044,d5
	lea	l0034,a4
l000c	addq.l	#1,a4
	cmpi.b	#0,(a4)
	bne	l000c

	addq.l	#1,a4
	dbf	d5,l000c

	pea	(a4)
	move.w	#9,-(sp)		;cconws
	trap	#1
	addq.l	#6,sp

l000d	bsr	l0014
	bsr	l0011

	move.w	#$ff,-(sp)
	move.w	#6,-(sp)		;crawio
	trap	#1
	addq.l	#4,sp

	cmp.b	#0,d0
	beq	l000d

	clr.l	$4d2.w

	pea	l0039
	move.w	#$20,-(sp)		;dosound
	trap	#14
	addq.l	#6,sp

	bsr	l0010

	move.w	sr,-(sp)
	ori.w	#$700,sr

	move.l	l003f,$70.w

	movea.l	l0043,a5
	andi.b	#$de,18(a5)
	andi.b	#$de,14(a5)
	andi.b	#$de,10(a5)
	andi.b	#$de,6(a5)
	clr.b	24(a5)
	clr.b	26(a5)
	bsr	l0020

	move.w	(sp)+,sr

	pea	l003e
	move.w	#0,-(sp)
	move.w	#$19,-(sp)		;ikbdws
	trap	#14
	addq.l	#8,sp

	move.l	#$ffffffff,-(sp)
	move.l	l0042,-(sp)
	move.l	l0042,-(sp)
	move.w	#5,-(sp)		;setscreen
	trap	#14
	adda.l	#$e,sp

	move.w	#$2700,sr

	lea	8.w,a1
	lea	l000f(pc),a0
	moveq	#9,d7
l000e	move.l	(a0)+,(a1)+
	dbf	d7,l000e

	jmp	$12.w

l000f	ori.b	#$c,d0
	movea.l	4.w,a0
	jmp	(a0)

	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp

	clr.l	-(sp)
	trap	#1
;========================================
l0010	move.l	#$8080000,$ffff8800.l
	move.l	#$9090000,$ffff8800.l
	move.l	#$a0a0000,$ffff8800.l
	rts

l0011	move.w	#$25,-(sp)		;vsync
	trap	#14
	addq.l	#2,sp
	rts

l0012	movea.l	l0041,a0
	lea	32000(a0),a0
	lea	2560(a0),a0
	movea.l	a6,a1
	move.w	#$20,d0
l0013	move.l	(a1),(a0)
	move.l	4(a1),4(a0)
	move.l	8(a1),8(a0)
	move.l	12(a1),12(a0)
	move.l	(a1),144(a0)
	move.l	4(a1),148(a0)
	move.l	8(a1),152(a0)
	move.l	12(a1),156(a0)
	lea	160(a0),a0
	lea	160(a1),a1
	dbf	d0,l0013
	rts

l0014	move.w	#8,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l0041,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	40(a2),a2
	lea	l003b,a3
	adda.l	d2,a3
l0015	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l0015

	move.w	#1,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l0041,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	48(a2),a2
	lea	l003b,a3
	adda.l	d2,a3
l0016	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l0016

	move.w	#9,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l0041,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	56(a2),a2
	lea	l003b,a3
	adda.l	d2,a3
l0017	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l0017

	move.w	#3,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l0041,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	64(a2),a2
	lea	l003b,a3
	adda.l	d2,a3
l0018	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l0018

	move.w	#$a,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l0041,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	72(a2),a2
	lea	l003b,a3
	adda.l	d2,a3
l0019	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l0019

	move.w	#5,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l0041,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	80(a2),a2
	lea	l003b,a3
	adda.l	d2,a3
l001a	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l001a

	move.w	#6,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l0041,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	88(a2),a2
	lea	l003b,a3
	adda.l	d2,a3
l001b	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l001b

	move.w	#0,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	divu	#$10,d0
	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l0041,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	96(a2),a2
	lea	l003b,a3
	adda.l	d2,a3
l001c	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l001c

	move.w	#2,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	divu	#$10,d0
	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l0041,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	104(a2),a2
	lea	l003b,a3
	adda.l	d2,a3
l001d	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l001d

	move.w	#4,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	divu	#$10,d0
	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l0041,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	112(a2),a2
	lea	l003b,a3
	adda.l	d2,a3
l001e	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l001e
	rts

l001f	lea	l0022(pc),a0
	move.l	$114.l,2(a0)
	lea	l0021(pc),a0
	move.l	a0,$114.l

	lea	l0024(pc),a0
	move.l	$118.l,2(a0)
	lea	l0023(pc),a0
	move.l	a0,$118.l
	rts

l0020	lea	l0022(pc),a0
	move.l	2(a0),$114.l

	lea	l0024(pc),a0
	move.l	2(a0),$118.l
	rts

l0021	ori.w	#$500,sr
	andi.w	#$fdff,sr

l0022	jmp	$10000

l0023	ori.w	#$500,sr
	andi.w	#$fdff,sr

l0024	jmp	$10000

l0025	move.l	l003f,-(sp)
	movem.l	a0/d0-d1,-(sp)
	lea	$ffff8201.w,a0
	movep.w	0(a0),d0
	movep.w	4(a0),d1
	cmp.w	d0,d1
	bne.s	l0027

	tst.b	8(a0)
	bne.s	l0027

	lea	l003c,a0
	tst.w	(a0)
	beq.s	l0026

	clr.w	(a0)
	movem.l	(sp)+,a0/d0-d1
	rts

l0026	lea	l002b(pc),a0
	move.l	a0,$120.w
	lea	$fffffa01.w,a0
	clr.b	26(a0)
	move.b	#$c7,32(a0)
	move.b	#8,26(a0)
	ori.b	#1,6(a0)
	ori.b	#1,18(a0)
	movem.l	(sp)+,a0/d0-d1
	rts

l0027	lea	$fffffa01.w,a0
	andi.b	#$de,18(a0)
	andi.b	#$de,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
	lea	l003c,a0
	clr.w	(a0)
	movem.l	(sp)+,a0/d0-d1
	rts

l0028	cmpi.b	#1,$fffffa21.w
	bgt.s	l0028

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
	bne	l0029

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

l0029	move.b	#$fc,$ffff820a.w

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
	lea	l002d(pc),a0
	move.w	#$e4,d0
	tst.b	$ffff8209.w
	bne.s	l002a

	cmp.w	d1,d2
	bne.s	l002a

	lea	l002b(pc),a0
	move.w	#$c7,d0
l002a	move.l	a0,$120.w
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

l002b	movem.l	a0-a2/d0,-(sp)
	lea	$fffffa01.w,a0
	lea	$ffff8209.w,a1
	lea	l002f(pc),a2
	lea	-222(a2),a2
	moveq	#0,d0
	andi.b	#$fe,18(a0)
	andi.b	#$fe,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
l002c	move.b	(a1),d0
	cmp.w	#$de,d0
	blt.s	l002c

	cmp.b	#0,d0
	bgt	l0030

	jmp	0(a2,d0.w)

l002d	movem.l	a0-a2/d0,-(sp)
	lea	$fffffa01.w,a0
	lea	$ffff8209.w,a1
	lea	l002f(pc),a2
	moveq	#0,d0
	andi.b	#$fe,18(a0)
	andi.b	#$fe,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
l002e	move.b	(a1),d0
	cmp.b	#8,d0
	blt.s	l002e

	cmp.w	#$20,d0
	bgt	l0030

	jmp	-8(a2,d0.w)

l002f	nop
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
	lea	l003c,a0
	move.w	#$ffff,(a0)
	movem.l	(sp)+,a0-a2/d0
	rte

l0030	bclr	#0,14(a0)
	lea	l003c,a0
	clr.w	(a0)
	movem.l	(sp)+,a0-a2/d0
	rte
;========================================
	data
;========================================
	dc.b	$07,$00
l0031	dc.b	'Un de ce'
	dc.b	's mots n'
	dc.b	$27,'est pas'
	dc.b	' un syno'
	dc.b	'nyme',$0d,$0a,'du'
	dc.b	' Full Sc'
	dc.b	'reen.',$0d,$0a,'L'
	dc.b	'equel ?',$0d
	dc.b	$0a,$0d,$0a,'[1] N'
	dc.b	'O BORDER'
	dc.b	' SCREEN',$0d
	dc.b	$0a,'[2] OVE'
	dc.b	'RSCAN',$0d,$0a,'['
	dc.b	'3] FREQU'
	dc.b	'ENCY SCR'
	dc.b	'EEN',$0d,$0a,$00,'Ce'
	dc.b	'tte mach'
	dc.b	'ine n',$27,'a '
	dc.b	'jamais e'
	dc.b	'xist',$82,'.',$0d,$0a
	dc.b	$0d,$0a,'[1] 13'
	dc.b	'0 ST',$0d,$0a,'[2'
	dc.b	'] 260 ST'
	dc.b	'F',$0d,$0a,'[3] 2'
	dc.b	'60 ST',$0d,$0a,$00
	dc.b	'Quel gro'
	dc.b	'upe a ',$82,'t'
	dc.b	$82,' le pre'
	dc.b	'mier ',$85,$0d,$0a
	dc.b	'r',$82,'aliser'
	dc.b	' un Full'
	dc.b	' Screen '
	dc.b	'sur ST ?'
	dc.b	$0d,$0a,$0d,$0a,'[1] '
	dc.b	'T.C.B.',$0d,$0a
	dc.b	'[2] LEVE'
	dc.b	'L 16',$0d,$0a,'[3'
	dc.b	'] TEX',$0d,$0a,$00
	dc.b	'On peut '
	dc.b	'r',$82,'aliser'
	dc.b	' un scro'
	dc.b	'lling',$0d,$0a,'h'
	dc.b	'ardware '
	dc.b	'sur tous'
	dc.b	' les STF'
	dc.b	'.',$0d,$0a,$0d,$0a,'[1]'
	dc.b	' OUI',$0d,$0a,'[2'
	dc.b	'] SEULEM'
	dc.b	'ENT SUR '
	dc.b	'LES MODE'
	dc.b	'LES',$0d,$0a,'   '
	dc.b	' AVEC BL'
	dc.b	'ITTER',$0d,$0a,'['
	dc.b	'3] FAUX',$0d
	dc.b	$0a,$00,'La Lin'
	dc.b	'e A,c',$27,'es'
	dc.b	't :',$0d,$0a,$0d,$0a,'['
	dc.b	'1] LA LI'
	dc.b	'GNE ACTU'
	dc.b	'ELLE LOR'
	dc.b	'S D',$27,'UN',$0d,$0a
	dc.b	'    BALA'
	dc.b	'YAGE D',$27,'E'
	dc.b	'CRAN',$0d,$0a,'[2'
	dc.b	'] UNE SE'
	dc.b	'RIE DE F'
	dc.b	'ONCTIONS'
	dc.b	' DE DESS'
	dc.b	'IN',$0d,$0a,'[3] '
	dc.b	'UN PROTO'
	dc.b	'COLE DE '
	dc.b	'COMMUNIC'
	dc.b	'ATION',$0d,$0a,$00
	dc.b	'Qui a le'
	dc.b	' plus de'
	dc.b	' fonctio'
	dc.b	'ns ?',$0d,$0a,$0d,$0a
	dc.b	'[1] GEMD'
	dc.b	'OS',$0d,$0a,'[2] '
	dc.b	'BIOS',$0d,$0a,'[3'
	dc.b	'] XBIOS',$0d
	dc.b	$0a,$00,'GDOS.P'
	dc.b	'RG c',$27,'est'
	dc.b	' :',$0d,$0a,$0d,$0a,'[1'
	dc.b	'] UNE AB'
	dc.b	'REVIATIO'
	dc.b	'N DE GEM'
	dc.b	'DOS',$0d,$0a,'[2]'
	dc.b	' UN SYST'
	dc.b	'EME D',$27,'EX'
	dc.b	'PLOITATI'
	dc.b	'ON',$0d,$0a,'[3] '
	dc.b	'UN PROGR'
	dc.b	'AMME D',$27,'E'
	dc.b	'XTENSION'
	dc.b	' GRAPHIQ'
	dc.b	'UE',$0d,$0a,$00,'Une'
	dc.b	' fois in'
	dc.b	'itialis',$82
	dc.b	'e,la Lin'
	dc.b	'e-A poss'
	dc.b	$8a,'de :',$0d,$0a,$0d
	dc.b	$0a,'[1] 8  '
	dc.b	'FONCTION'
	dc.b	'S',$0d,$0a,'[2] 1'
	dc.b	'2 FONCTI'
	dc.b	'ONS',$0d,$0a,'[3]'
	dc.b	' 15 FONC'
	dc.b	'TIONS',$0d,$0a,$00
	dc.b	'Combien '
	dc.b	'de lecte'
	dc.b	'urs de d'
	dc.b	'isquette'
	dc.b	's',$0d,$0a,'peut '
	dc.b	'g',$82,'rer un'
	dc.b	' ST ?',$0d,$0a,$0d
	dc.b	$0a,'[1] 2 A'
	dc.b	'U MAXIMU'
	dc.b	'M',$0d,$0a,'[2] 3'
	dc.b	' AU MAXI'
	dc.b	'MUM',$0d,$0a,'[3]'
	dc.b	' UNE INF'
	dc.b	'INITE SI'
	dc.b	' ON A AS'
	dc.b	'SEZ DE R'
	dc.b	'AM',$0d,$0a,$00,'Un '
	dc.b	'ripper c'
	dc.b	$27,'est :',$0d,$0a
	dc.b	$0d,$0a,'[1] UN'
	dc.b	' MAUVAIS'
	dc.b	' PROGRAM'
	dc.b	'MEUR',$0d,$0a,'[2'
	dc.b	'] UNE CA'
	dc.b	'RTOUCHE',$0d
	dc.b	$0a,'[3] UNE'
	dc.b	' PERSONN'
	dc.b	'E QUI PR'
	dc.b	'END LES '
	dc.b	'CODES,',$0d,$0a
	dc.b	'    GRAP'
	dc.b	'HISMES O'
	dc.b	'U MUSIQU'
	dc.b	'ES D',$27,'UNE'
	dc.b	$0d,$0a,'    AU'
	dc.b	'TRE PERS'
	dc.b	'ONNE',$0d,$0a,$00,'U'
	dc.b	'n byte c'
	dc.b	$27,'est :',$0d,$0a
	dc.b	$0d,$0a,'[1] UN'
	dc.b	' BIT',$0d,$0a,'[2'
	dc.b	'] UN OCT'
	dc.b	'ET',$0d,$0a,'[3] '
	dc.b	'UNE SERI'
	dc.b	'E DE 8 O'
	dc.b	'CTETS',$0d,$0a,$00
	dc.b	'XBIOS 2.'
	dc.b	'..Ca don'
	dc.b	'ne quoi,'
	dc.b	'd',$82,'j',$85,' ?',$0d,$0a
	dc.b	$0d,$0a,'[1] L',$27
	dc.b	'ADRESSE '
	dc.b	'PHYSIQUE'
	dc.b	' DE L',$27,'EC'
	dc.b	'RAN',$0d,$0a,'[2]'
	dc.b	' L',$27,'ADRES'
	dc.b	'SE LOGIQ'
	dc.b	'UE DE L',$27
	dc.b	'ECRAN',$0d,$0a,'['
	dc.b	'3] LE DP'
	dc.b	'B',$0d,$0a,$00,'GenS'
	dc.b	'T c',$27,'est '
	dc.b	':',$0d,$0a,$0d,$0a,'[1]'
	dc.b	' UN PROG'
	dc.b	'RAMME DE'
	dc.b	' DESSIN',$0d
	dc.b	$0a,'[2] UN '
	dc.b	'EMULATEU'
	dc.b	'R MAC',$0d,$0a,'['
	dc.b	'3] UN AS'
	dc.b	'SEMBLEUR'
	dc.b	$0d,$0a,$00,'Le GI'
	dc.b	'OS,',$87,'a ex'
	dc.b	'iste sur'
	dc.b	' ST ?',$0d,$0a,$0d
	dc.b	$0a,'[1] NON'
	dc.b	$0d,$0a,'[2] SE'
	dc.b	'ULEMENT '
	dc.b	'SUR MEGA'
	dc.b	' STE',$0d,$0a,'[3'
	dc.b	'] OUI',$0d,$0a,$00
	dc.b	'Une font'
	dc.b	'e,c',$27,'est '
	dc.b	':',$0d,$0a,$0d,$0a,'[1]'
	dc.b	' UNE POL'
	dc.b	'ICE DE C'
	dc.b	'ARACTERE'
	dc.b	'S',$0d,$0a,'[2] U'
	dc.b	'N MASQUE'
	dc.b	' DE SPRI'
	dc.b	'TE',$0d,$0a,'[3] '
	dc.b	'UN DEUXI'
	dc.b	'EME ECRA'
	dc.b	'N',$0d,$0a,$00,'Donn'
	dc.b	'ez l',$27,'adr'
	dc.b	'esse du '
	dc.b	'vecteur '
	dc.b	'VBL',$0d,$0a,$0d,$0a,'['
	dc.b	'1] $68',$0d,$0a
	dc.b	'[2] $70',$0d
	dc.b	$0a,'[3] $48'
	dc.b	'4',$0d,$0a,$00,'Quel'
	dc.b	' est le '
	dc.b	'Nombre M'
	dc.b	'agique q'
	dc.b	'ui "d',$82,'vi'
	dc.b	'e"',$0d,$0a,'le R'
	dc.b	'ESET ?',$0d,$0a
	dc.b	$0d,$0a,'[1] $F'
	dc.b	'C0008',$0d,$0a,'['
	dc.b	'2] $3141'
	dc.b	'5926',$0d,$0a,'[3'
	dc.b	'] $75201'
	dc.b	'9F3',$0d,$0a,$00,'XB'
	dc.b	'IOS 6,',$87,'a'
	dc.b	' sert ',$85,' '
	dc.b	':',$0d,$0a,$0d,$0a,'[1]'
	dc.b	' CHANGER'
	dc.b	' LA PALE'
	dc.b	'TTE',$0d,$0a,'[2]'
	dc.b	' OUVRIR '
	dc.b	'UN FICHI'
	dc.b	'ER',$0d,$0a,'[3] '
	dc.b	'PASSER E'
	dc.b	'N SUPERV'
	dc.b	'ISEUR',$0d,$0a,$00
	dc.b	'Le Super'
	dc.b	'viseur,c'
	dc.b	$27,'est pou'
	dc.b	'r :',$0d,$0a,$0d,$0a,'['
	dc.b	'1] ACCEL'
	dc.b	'ERER LA '
	dc.b	'SOURIS',$0d,$0a
	dc.b	'[2] ACCE'
	dc.b	'DER A DE'
	dc.b	'S ZONES '
	dc.b	'PROTEGEE'
	dc.b	'S',$0d,$0a,'[3] G'
	dc.b	'ERER LE '
	dc.b	'JOYSTICK'
	dc.b	$0d,$0a,$00,'Facil'
	dc.b	'e ! Le m'
	dc.b	'icroproc'
	dc.b	'esseur d'
	dc.b	'u ST :',$0d,$0a
	dc.b	$0d,$0a,'[1] 80'
	dc.b	'286',$0d,$0a,'[2]'
	dc.b	' 68000',$0d,$0a
	dc.b	'[3] 8038'
	dc.b	'6',$0d,$0a,$00
l0032	dc.b	$1b,'Y  ',$00
l0033	dc.b	$1b,'Y  NOTE '
	dc.b	':',$0d,$0a,$00
l0034	dc.b	$00,$00,'0/20 :'
	dc.b	' Vous ',$88,'t'
	dc.b	'es NUL !'
	dc.b	$00,'1/20 : '
	dc.b	'Savez-vo'
	dc.b	'us qu',$27,'on'
	dc.b	' peut fa'
	dc.b	'ire',$0d,$0a,'aut'
	dc.b	're chose'
	dc.b	' que des'
	dc.b	' jeux su'
	dc.b	'r un ST '
	dc.b	'?',$00,'2/20 :'
	dc.b	' Achetez'
	dc.b	' la Bibl'
	dc.b	'e du ST '
	dc.b	'!',$00,'3/20 :'
	dc.b	' Savez-v'
	dc.b	'ous au m'
	dc.b	'oins ce '
	dc.b	'qu',$27,'est',$0d,$0a
	dc.b	'un Atari'
	dc.b	' ST ????'
	dc.b	'??',$00,'4/20 '
	dc.b	': MINABL'
	dc.b	'E !',$00,'5/20'
	dc.b	' : Si on'
	dc.b	' recomme'
	dc.b	'n',$87,'ait ??'
	dc.b	'!?',$00,'6/20 '
	dc.b	': BOARF '
	dc.b	'!',$00,'7/20 :'
	dc.b	' Mouaipf'
	dc.b	' !',$00,'8/20 '
	dc.b	': Manque'
	dc.b	' de trav'
	dc.b	'ail...',$00,'9'
	dc.b	'/20 : De'
	dc.b	's bases '
	dc.b	$85,' revoir'
	dc.b	'...',$00,'10/2'
	dc.b	'0 : C',$27,'es'
	dc.b	't juste.'
	dc.b	'..',$00,'11/20'
	dc.b	' : Il fa'
	dc.b	'ut pers',$82
	dc.b	'v',$82,'rer !',$00
	dc.b	'12/20 : '
	dc.b	'Passable'
	dc.b	'...',$00,'13/2'
	dc.b	'0 : Acce'
	dc.b	'ptable..'
	dc.b	'.',$00,'14/20 '
	dc.b	': Pas si'
	dc.b	' mal ...'
	dc.b	$00,'15/20 :'
	dc.b	' Vous ',$88,'t'
	dc.b	'es assez'
	dc.b	' dou',$82,' !',$00
	dc.b	'16/20 : '
	dc.b	'Tr',$8a,'s bie'
	dc.b	'n.',$00,'17/20'
	dc.b	' : Tr',$8a,'s '
	dc.b	'bon.',$00,'18/'
	dc.b	'20 : Tr',$8a
	dc.b	's tr',$8a,'s b'
	dc.b	'ien !',$00,'19'
	dc.b	'/20 : Ex'
	dc.b	'cellent '
	dc.b	'!',$00,'20/20 '
	dc.b	': Vous ',$88
	dc.b	'tes g',$82,'ni'
	dc.b	'al !',$00
l0035	dc.b	'221221331'
	dc.b	'23133121'
	dc.b	'223',$00

l0036	incbin	l0036.pi1

l0039	dc.b	$07,$ff,$06,$00,$08,$00,$09,$00
	dc.b	$0a,$00

l003a	incbin	l003a.mus

l003b	incbin	l003b

l003c	dc.b	$00,$00
l003d	dc.b	$12
l003e	dc.b	$08
;========================================
	bss
;========================================
l003f	ds.l	1
l0040	ds.b	44096
l0041	ds.l	1
l0042	ds.l	1
l0043	ds.l	1
l0044	ds.b	178
;========================================
zuend	end
;========================================