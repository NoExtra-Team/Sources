	text
begin
	dc.b	$a0,$0a
	pea	l003d
	move.w	#0,-(a7)
	move.w	#$19,-(a7)		;ikbdws
	trap	#$e
	addq.l	#8,a7
	clr.l	-(a7)
	move.w	#$20,-(a7)		;super
	trap	#1
	addq.l	#6,a7
	move.l	d0,-(a7)
	move.b	#$e,$484.l
	lea	l003a,a0
	lea	$43fde,a1
	move.l	#$bb7,d1
l0000	move.l	(a0)+,(a1)+
	dbf	d1,l0000
	moveq	#1,d0
	jsr	$43fde
	move.l	#$43fe6,$4d2.w
	move.w	#2,-(a7)		;physbase
	trap	#$e
	addq.l	#2,a7
	move.l	d0,l0042
	pea	l0037
	move.w	#6,-(a7)		;setpallete
	trap	#$e
	addq.l	#6,a7
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
	move.l	#$ffffffff,-(a7)
	move.l	l0041,-(a7)
	move.l	l0041,-(a7)
	move.w	#5,-(a7)		;setscreen
	trap	#$e
	adda.l	#$e,a7
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
	move.w	#9,-(a7)		;cconws
	trap	#1
	addq.l	#6,a7
	pea	(a4)
	move.w	#9,-(a7)		;cconws
	trap	#1
	addq.l	#6,a7
l0005	addq.l	#1,a4
	cmpi.b	#0,(a4)
	bne	l0005
	addq.l	#1,a4
	lea	l0038,a6
	lea	160(a6),a6
	move.w	#9,d7
l0006	suba.l	#$10,a6
	bsr	l0012
	move.w	#$32,d3
l0007	move.w	#$ff,-(a7)
	move.w	#6,-(a7)		;crawio
	trap	#1
	addq.l	#4,a7
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
	move.w	#9,-(a7)		;cconws
	trap	#1
	addq.l	#6,a7
	move.b	l0044,d5
	lea	l0034,a4
l000c	addq.l	#1,a4
	cmpi.b	#0,(a4)
	bne	l000c
	addq.l	#1,a4
	dbf	d5,l000c
	pea	(a4)
	move.w	#9,-(a7)		;cconws
	trap	#1
	addq.l	#6,a7
l000d	bsr	l0014
	bsr	l0011
	move.w	#$ff,-(a7)
	move.w	#6,-(a7)		;crawio
	trap	#1
	addq.l	#4,a7
	cmp.b	#0,d0
	beq	l000d
	clr.l	$4d2.w
	pea	l0039
	move.w	#$20,-(a7)		;dosound
	trap	#$e
	addq.l	#6,a7
	bsr	l0010
	move	sr,-(a7)
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
	move	(a7)+,sr
	pea	l003e
	move.w	#0,-(a7)
	move.w	#$19,-(a7)		;ikbdws
	trap	#$e
	addq.l	#8,a7
	move.l	#$ffffffff,-(a7)
	move.l	l0042,-(a7)
	move.l	l0042,-(a7)
	move.w	#5,-(a7)		;setscreen
	trap	#$e
	adda.l	#$e,a7
	move	#$2700,sr
	lea	8.w,a1
	lea	l000f(pc),a0
	moveq	#9,d7
l000e	move.l	(a0)+,(a1)+
	dbf	d7,l000e
	jmp	$12.w
l000f	ori.b	#$c,d0
	movea.l	4.w,a0
	jmp	(a0)
	move.w	#$20,-(a7)		;super
	trap	#1
	addq.l	#6,a7
	clr.l	-(a7)
	trap	#1
l0010	move.l	#$8080000,$ffff8800.l
	move.l	#$9090000,$ffff8800.l
	move.l	#$a0a0000,$ffff8800.l
	rts

l0011	move.w	#$25,-(a7)		;vsync
	trap	#$e
	addq.l	#2,a7
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

l0014	move.w	#8,-(a7)
	move.w	#$40,-(a7)
	move.w	#$1c,-(a7)		;giaccess
	trap	#$e
	addq.w	#6,a7
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
	move.w	#1,-(a7)
	move.w	#$40,-(a7)
	move.w	#$1c,-(a7)		;giaccess
	trap	#$e
	addq.w	#6,a7
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
	move.w	#9,-(a7)
	move.w	#$40,-(a7)
	move.w	#$1c,-(a7)		;giaccess
	trap	#$e
	addq.w	#6,a7
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
	move.w	#3,-(a7)
	move.w	#$40,-(a7)
	move.w	#$1c,-(a7)		;giaccess
	trap	#$e
	addq.w	#6,a7
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
	move.w	#$a,-(a7)
	move.w	#$40,-(a7)
	move.w	#$1c,-(a7)		;giaccess
	trap	#$e
	addq.w	#6,a7
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
	move.w	#5,-(a7)
	move.w	#$40,-(a7)
	move.w	#$1c,-(a7)		;giaccess
	trap	#$e
	addq.w	#6,a7
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
	move.w	#6,-(a7)
	move.w	#$40,-(a7)
	move.w	#$1c,-(a7)		;giaccess
	trap	#$e
	addq.w	#6,a7
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
	move.w	#0,-(a7)
	move.w	#$40,-(a7)
	move.w	#$1c,-(a7)		;giaccess
	trap	#$e
	addq.w	#6,a7
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
	move.w	#2,-(a7)
	move.w	#$40,-(a7)
	move.w	#$1c,-(a7)		;giaccess
	trap	#$e
	addq.w	#6,a7
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
	move.w	#4,-(a7)
	move.w	#$40,-(a7)
	move.w	#$1c,-(a7)		;giaccess
	trap	#$e
	addq.w	#6,a7
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
l0025	move.l	l003f,-(a7)
	movem.l	a0/d0-d1,-(a7)
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
	movem.l	(a7)+,a0/d0-d1
	rts

l0026	lea	l002b(pc),a0
	move.l	a0,$120.w
	lea	$fffffa01.w,a0
	clr.b	26(a0)
	move.b	#$c7,32(a0)
	move.b	#8,26(a0)
	ori.b	#1,6(a0)
	ori.b	#1,18(a0)
	movem.l	(a7)+,a0/d0-d1
	rts

l0027	lea	$fffffa01.w,a0
	andi.b	#$de,18(a0)
	andi.b	#$de,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
	lea	l003c,a0
	clr.w	(a0)
	movem.l	(a7)+,a0/d0-d1
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
	movem.l	a0/d0-d2,-(a7)
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
	movem.l	(a7)+,a0/d0-d2
	rte

l002b	movem.l	a0-a2/d0,-(a7)
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
l002d	movem.l	a0-a2/d0,-(a7)
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
	movem.l	(a7)+,a0-a2/d0
	rte

l0030	bclr	#0,14(a0)
	lea	l003c,a0
	clr.w	(a0)
	movem.l	(a7)+,a0-a2/d0
	rte

	data
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
l0036	dc.b	$00,$00
l0037	dc.b	$00,$00,$07,$00,$00,'G',$00,'W'
	dc.b	$00,'g',$00,'w',$04,'"',$05,'2'
	dc.b	$06,'B',$06,'R',$06,'b',$07,'s'
	dc.b	$04,'D',$05,'U',$06,'f',$07,'w'
l0038	dcb.w	84
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dc.b	$00,$0f,$00,$0f,$00,$0f,$00,$0f
	dc.b	$f8,$00,$f8,$00,$f8,$00,$f8,$00
	dc.b	$00,$0f,$00,$0f,$00,$0f,$00,$0f
	dc.b	$f8,$00,$f8,$00,$f8,$00,$f8,$00
	dc.b	$00,$0f,$00,$0f,$00,$0f,$00,$0f
	dc.b	$f8,$00,$f8,$00,$f8,$00,$f8,$00
	dc.b	$00,$0f,$00,$0f,$00,$0f,$00,$0f
	dc.b	$f8,$00,$f8,$00,$f8,$00,$f8,$00
	dc.b	$00,$0f,$00,$0f,$00,$0f,$00,$0f
	dc.b	$f8,$00,$f8,$00,$f8,$00,$f8,$00
	dc.b	$00,$0f,$00,$0f,$00,$0f,$00,$0f
	dc.b	$f8,$00,$f8,$00,$f8,$00,$f8,$00
	dc.b	$00,$0f,$00,$0f,$00,$0f,$00,$0f
	dc.b	$f8,$00,$f8,$00,$f8,$00,$f8,$00
	dc.b	$00,$0f,$00,$0f,$00,$0f,$00,$0f
	dc.b	$f8,$00,$f8,$00,$f8,$00,$f8,$00
	dc.b	$00,$0f,$00,$0f,$00,$0f,$00,$0f
	dc.b	$f8,$00,$f8,$00,$f8,$00,$f8,$00
	dc.b	$00,$0f,$00,$0f,$00,$0f,$00,$0f
	dc.b	$f8,$00,$f8,$00,$f8,$00,$f8,$00
	dc.b	$00,'p',$00,'p',$00,'p',$00,'p'
	dc.b	$87,$00,$87,$00,$87,$00,$87,$00
	dc.b	$00,'p',$00,'p',$00,'p',$00,'p'
	dc.b	$87,$00,$87,$00,$87,$00,$87,$00
	dc.b	$00,'p',$00,'p',$00,'p',$00,'p'
	dc.b	$87,$00,$87,$00,$87,$00,$87,$00
	dc.b	$00,'p',$00,'p',$00,'p',$00,'p'
	dc.b	$87,$00,$87,$00,$87,$00,$87,$00
	dc.b	$00,'p',$00,'p',$00,'p',$00,'p'
	dc.b	$87,$00,$87,$00,$87,$00,$87,$00
	dc.b	$00,'p',$00,'p',$00,'p',$00,'p'
	dc.b	$87,$00,$87,$00,$87,$00,$87,$00
	dc.b	$00,'p',$00,'p',$00,'p',$00,'p'
	dc.b	$87,$00,$87,$00,$87,$00,$87,$00
	dc.b	$00,'p',$00,'p',$00,'p',$00,'p'
	dc.b	$87,$00,$87,$00,$87,$00,$87,$00
	dc.b	$00,'p',$00,'p',$00,'p',$00,'p'
	dc.b	$87,$00,$87,$00,$87,$00,$87,$00
	dc.b	$00,'p',$00,'p',$00,'p',$00,'p'
	dc.b	$87,$00,$87,$00,$87,$00,$87,$00
	dc.b	$00,$87,$00,$87,$00,$87,$00,$87
	dc.b	$f8,$80,$f8,$80,$f8,$80,$f8,$80
	dc.b	$00,$81,$00,$81,$00,$81,$00,$81
	dc.b	$e0,$80,$e0,$80,$e0,$80,$e0,$80
	dc.b	$00,$87,$00,$87,$00,$87,$00,$87
	dc.b	$f8,$80,$f8,$80,$f8,$80,$f8,$80
	dc.b	$00,$9f,$00,$9f,$00,$9f,$00,$9f
	dc.b	$fe,$80,$fe,$80,$fe,$80,$fe,$80
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dc.b	$f0,$80,$f0,$80,$f0,$80,$f0,$80
	dc.b	$00,$9f,$00,$9f,$00,$9f,$00,$9f
	dc.b	$fe,$80,$fe,$80,$fe,$80,$fe,$80
	dc.b	$00,$81,$00,$81,$00,$81,$00,$81
	dc.b	$f8,$80,$f8,$80,$f8,$80,$f8,$80
	dc.b	$00,$9f,$00,$9f,$00,$9f,$00,$9f
	dc.b	$fe,$80,$fe,$80,$fe,$80,$fe,$80
	dc.b	$00,$87,$00,$87,$00,$87,$00,$87
	dc.b	$f8,$80,$f8,$80,$f8,$80,$f8,$80
	dc.b	$00,$87,$00,$87,$00,$87,$00,$87
	dc.b	$f8,$80,$f8,$80,$f8,$80,$f8,$80
	dc.b	$01,$0f,$01,$0f,$01,$0f,$01,$0f
	dc.b	$fc,'@',$fc,'@',$fc,'@',$fc,'@'
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$e0,'@',$e0,'@',$e0,'@',$e0,'@'
	dc.b	$01,$0f,$01,$0f,$01,$0f,$01,$0f
	dc.b	$fc,'@',$fc,'@',$fc,'@',$fc,'@'
	dc.b	$01,$1f,$01,$1f,$01,$1f,$01,$1f
	dc.b	$fe,'@',$fe,'@',$fe,'@',$fe,'@'
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dc.b	$f0,'@',$f0,'@',$f0,'@',$f0,'@'
	dc.b	$01,$1f,$01,$1f,$01,$1f,$01,$1f
	dc.b	$fe,'@',$fe,'@',$fe,'@',$fe,'@'
	dc.b	$01,$03,$01,$03,$01,$03,$01,$03
	dc.b	$f8,'@',$f8,'@',$f8,'@',$f8,'@'
	dc.b	$01,$1f,$01,$1f,$01,$1f,$01,$1f
	dc.b	$fe,'@',$fe,'@',$fe,'@',$fe,'@'
	dc.b	$01,$0f,$01,$0f,$01,$0f,$01,$0f
	dc.b	$fc,'@',$fc,'@',$fc,'@',$fc,'@'
	dc.b	$01,$0f,$01,$0f,$01,$0f,$01,$0f
	dc.b	$fc,'@',$fc,'@',$fc,'@',$fc,'@'
	dc.b	$02,$1f,$02,$1f,$02,$1f,$02,$1f
	dc.b	$fe,' ',$fe,' ',$fe,' ',$fe,' '
	dc.b	$02,$03,$02,$03,$02,$03,$02,$03
	dc.b	$e0,' ',$e0,' ',$e0,' ',$e0,' '
	dc.b	$02,$1f,$02,$1f,$02,$1f,$02,$1f
	dc.b	$fe,' ',$fe,' ',$fe,' ',$fe,' '
	dc.b	$02,$1f,$02,$1f,$02,$1f,$02,$1f
	dc.b	$fe,' ',$fe,' ',$fe,' ',$fe,' '
	dc.b	$02,$01,$02,$01,$02,$01,$02,$01
	dc.b	$f0,' ',$f0,' ',$f0,' ',$f0,' '
	dc.b	$02,$1f,$02,$1f,$02,$1f,$02,$1f
	dc.b	$fe,' ',$fe,' ',$fe,' ',$fe,' '
	dc.b	$02,$07,$02,$07,$02,$07,$02,$07
	dc.b	$f8,' ',$f8,' ',$f8,' ',$f8,' '
	dc.b	$02,$1f,$02,$1f,$02,$1f,$02,$1f
	dc.b	$fe,' ',$fe,' ',$fe,' ',$fe,' '
	dc.b	$02,$1f,$02,$1f,$02,$1f,$02,$1f
	dc.b	$fe,' ',$fe,' ',$fe,' ',$fe,' '
	dc.b	$02,$1f,$02,$1f,$02,$1f,$02,$1f
	dc.b	$fe,' ',$fe,' ',$fe,' ',$fe,' '
	dc.b	$04,$1f,$04,$1f,$04,$1f,$04,$1f
	dc.b	$fe,$10,$fe,$10,$fe,$10,$fe,$10
	dc.b	$04,$03,$04,$03,$04,$03,$04,$03
	dc.b	$e0,$10,$e0,$10,$e0,$10,$e0,$10
	dc.b	$04,$1f,$04,$1f,$04,$1f,$04,$1f
	dc.b	$fe,$10,$fe,$10,$fe,$10,$fe,$10
	dc.b	$04,$1f,$04,$1f,$04,$1f,$04,$1f
	dc.b	$fe,$10,$fe,$10,$fe,$10,$fe,$10
	dc.b	$04,$01,$04,$01,$04,$01,$04,$01
	dc.b	$f0,$10,$f0,$10,$f0,$10,$f0,$10
	dc.b	$04,$1f,$04,$1f,$04,$1f,$04,$1f
	dc.b	$fe,$10,$fe,$10,$fe,$10,$fe,$10
	dc.b	$04,$0f,$04,$0f,$04,$0f,$04,$0f
	dc.b	$f8,$10,$f8,$10,$f8,$10,$f8,$10
	dc.b	$04,$1f,$04,$1f,$04,$1f,$04,$1f
	dc.b	$fe,$10,$fe,$10,$fe,$10,$fe,$10
	dc.b	$04,$1f,$04,$1f,$04,$1f,$04,$1f
	dc.b	$fe,$10,$fe,$10,$fe,$10,$fe,$10
	dc.b	$04,$1f,$04,$1f,$04,$1f,$04,$1f
	dc.b	$fe,$10,$fe,$10,$fe,$10,$fe,$10
	dc.b	$08,$1f,$08,$1f,$08,$1f,$08,$1f
	dc.b	$be,$08,$be,$08,$be,$08,$be,$08
	dc.b	$08,$07,$08,$07,$08,$07,$08,$07
	dc.b	$e0,$08,$e0,$08,$e0,$08,$e0,$08
	dc.b	$08,$1e,$08,$1e,$08,$1e,$08,$1e
	dc.b	$9e,$08,$9e,$08,$9e,$08,$9e,$08
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dc.b	$f8,$08,$f8,$08,$f8,$08,$f8,$08
	dc.b	$08,$03,$08,$03,$08,$03,$08,$03
	dc.b	$f0,$08,$f0,$08,$f0,$08,$f0,$08
	dc.b	$08,$1e,$08,$1e,$08,$1e,$08,$1e
	dc.b	$80,$08,$80,$08,$80,$08,$80,$08
	dc.b	$08,$1f,$08,$1f,$08,$1f,$08,$1f
	dc.b	$80,$08,$80,$08,$80,$08,$80,$08
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dc.b	$9e,$08,$9e,$08,$9e,$08,$9e,$08
	dc.b	$08,$1e,$08,$1e,$08,$1e,$08,$1e
	dc.b	$9e,$08,$9e,$08,$9e,$08,$9e,$08
	dc.b	$08,$1f,$08,$1f,$08,$1f,$08,$1f
	dc.b	$be,$08,$be,$08,$be,$08,$be,$08
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$9e,$04,$9e,$04,$9e,$04,$9e,$04
	dc.b	$10,$07,$10,$07,$10,$07,$10,$07
	dc.b	$e0,$04,$e0,$04,$e0,$04,$e0,$04
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$9e,$04,$9e,$04,$9e,$04,$9e,$04
	dc.b	$10,$00,$10,$00,$10,$00,$10,$00
	dc.b	$f8,$04,$f8,$04,$f8,$04,$f8,$04
	dc.b	$10,$03,$10,$03,$10,$03,$10,$03
	dc.b	$f0,$04,$f0,$04,$f0,$04,$f0,$04
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$80,$04,$80,$04,$80,$04,$80,$04
	dc.b	$10,$1f,$10,$1f,$10,$1f,$10,$1f
	dc.b	$80,$04,$80,$04,$80,$04,$80,$04
	dc.b	$10,$00,$10,$00,$10,$00,$10,$00
	dc.b	$9e,$04,$9e,$04,$9e,$04,$9e,$04
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$9e,$04,$9e,$04,$9e,$04,$9e,$04
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$9e,$04,$9e,$04,$9e,$04,$9e,$04
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$9e,$04,$9e,$04,$9e,$04,$9e,$04
	dc.b	$10,$07,$10,$07,$10,$07,$10,$07
	dc.b	$e0,$04,$e0,$04,$e0,$04,$e0,$04
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$be,$04,$be,$04,$be,$04,$be,$04
	dc.b	$10,$00,$10,$00,$10,$00,$10,$00
	dc.b	$f8,$04,$f8,$04,$f8,$04,$f8,$04
	dc.b	$10,$07,$10,$07,$10,$07,$10,$07
	dc.b	$f0,$04,$f0,$04,$f0,$04,$f0,$04
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$80,$04,$80,$04,$80,$04,$80,$04
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$80,$04,$80,$04,$80,$04,$80,$04
	dc.b	$10,$00,$10,$00,$10,$00,$10,$00
	dc.b	$be,$04,$be,$04,$be,$04,$be,$04
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$9e,$04,$9e,$04,$9e,$04,$9e,$04
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$9e,$04,$9e,$04,$9e,$04,$9e,$04
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$9e,$04,$9e,$04,$9e,$04,$9e,$04
	dc.b	$10,$07,$10,$07,$10,$07,$10,$07
	dc.b	$e0,$04,$e0,$04,$e0,$04,$e0,$04
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$be,$04,$be,$04,$be,$04,$be,$04
	dc.b	$10,$00,$10,$00,$10,$00,$10,$00
	dc.b	$f8,$04,$f8,$04,$f8,$04,$f8,$04
	dc.b	$10,$07,$10,$07,$10,$07,$10,$07
	dc.b	$f0,$04,$f0,$04,$f0,$04,$f0,$04
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$80,$04,$80,$04,$80,$04,$80,$04
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$80,$04,$80,$04,$80,$04,$80,$04
	dc.b	$10,$00,$10,$00,$10,$00,$10,$00
	dc.b	$be,$04,$be,$04,$be,$04,$be,$04
	dc.b	$10,$1f,$10,$1f,$10,$1f,$10,$1f
	dc.b	$be,$04,$be,$04,$be,$04,$be,$04
	dc.b	$10,$1f,$10,$1f,$10,$1f,$10,$1f
	dc.b	$be,$04,$be,$04,$be,$04,$be,$04
	dc.b	' ',$1e,' ',$1e,' ',$1e,' ',$1e
	dc.b	$9e,$02,$9e,$02,$9e,$02,$9e,$02
	dc.b	' ',$01,' ',$01,' ',$01,' ',$01
	dc.b	$e0,$02,$e0,$02,$e0,$02,$e0,$02
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dc.b	$fc,$02,$fc,$02,$fc,$02,$fc,$02
	dc.b	' ',$01,' ',$01,' ',$01,' ',$01
	dc.b	$f0,$02,$f0,$02,$f0,$02,$f0,$02
	dc.b	' ',$0f,' ',$0f,' ',$0f,' ',$0f
	dc.b	$f0,$02,$f0,$02,$f0,$02,$f0,$02
	dc.b	' ',$1f,' ',$1f,' ',$1f,' ',$1f
	dc.b	$f8,$02,$f8,$02,$f8,$02,$f8,$02
	dc.b	' ',$1e,' ',$1e,' ',$1e,' ',$1e
	dc.b	$80,$02,$80,$02,$80,$02,$80,$02
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dc.b	$fc,$02,$fc,$02,$fc,$02,$fc,$02
	dc.b	' ',$0f,' ',$0f,' ',$0f,' ',$0f
	dc.b	$fc,$02,$fc,$02,$fc,$02,$fc,$02
	dc.b	' ',$1f,' ',$1f,' ',$1f,' ',$1f
	dc.b	$fe,$02,$fe,$02,$fe,$02,$fe,$02
	dc.b	' ',$1e,' ',$1e,' ',$1e,' ',$1e
	dc.b	$9e,$02,$9e,$02,$9e,$02,$9e,$02
	dc.b	' ',$01,' ',$01,' ',$01,' ',$01
	dc.b	$e0,$02,$e0,$02,$e0,$02,$e0,$02
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dc.b	$fc,$02,$fc,$02,$fc,$02,$fc,$02
	dc.b	' ',$01,' ',$01,' ',$01,' ',$01
	dc.b	$f0,$02,$f0,$02,$f0,$02,$f0,$02
	dc.b	' ',$0f,' ',$0f,' ',$0f,' ',$0f
	dc.b	$f0,$02,$f0,$02,$f0,$02,$f0,$02
	dc.b	' ',$1f,' ',$1f,' ',$1f,' ',$1f
	dc.b	$fc,$02,$fc,$02,$fc,$02,$fc,$02
	dc.b	' ',$1e,' ',$1e,' ',$1e,' ',$1e
	dc.b	$80,$02,$80,$02,$80,$02,$80,$02
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dc.b	$fc,$02,$fc,$02,$fc,$02,$fc,$02
	dc.b	' ',$07,' ',$07,' ',$07,' ',$07
	dc.b	$f8,$02,$f8,$02,$f8,$02,$f8,$02
	dc.b	' ',$1f,' ',$1f,' ',$1f,' ',$1f
	dc.b	$fe,$02,$fe,$02,$fe,$02,$fe,$02
	dc.b	' ',$1e,' ',$1e,' ',$1e,' ',$1e
	dc.b	$9e,$02,$9e,$02,$9e,$02,$9e,$02
	dc.b	' ',$01,' ',$01,' ',$01,' ',$01
	dc.b	$e0,$02,$e0,$02,$e0,$02,$e0,$02
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dc.b	$f8,$02,$f8,$02,$f8,$02,$f8,$02
	dc.b	' ',$01,' ',$01,' ',$01,' ',$01
	dc.b	$e0,$02,$e0,$02,$e0,$02,$e0,$02
	dc.b	' ',$1f,' ',$1f,' ',$1f,' ',$1f
	dc.b	$f0,$02,$f0,$02,$f0,$02,$f0,$02
	dc.b	' ',$1f,' ',$1f,' ',$1f,' ',$1f
	dc.b	$fe,$02,$fe,$02,$fe,$02,$fe,$02
	dc.b	' ',$1f,' ',$1f,' ',$1f,' ',$1f
	dc.b	$f8,$02,$f8,$02,$f8,$02,$f8,$02
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dc.b	$f8,$02,$f8,$02,$f8,$02,$f8,$02
	dc.b	' ',$07,' ',$07,' ',$07,' ',$07
	dc.b	$f8,$02,$f8,$02,$f8,$02,$f8,$02
	dc.b	' ',$0f,' ',$0f,' ',$0f,' ',$0f
	dc.b	$fe,$02,$fe,$02,$fe,$02,$fe,$02
	dc.b	' ',$1e,' ',$1e,' ',$1e,' ',$1e
	dc.b	$9e,$02,$9e,$02,$9e,$02,$9e,$02
	dc.b	' ',$01,' ',$01,' ',$01,' ',$01
	dc.b	$e0,$02,$e0,$02,$e0,$02,$e0,$02
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dc.b	$f8,$02,$f8,$02,$f8,$02,$f8,$02
	dc.b	' ',$01,' ',$01,' ',$01,' ',$01
	dc.b	$e0,$02,$e0,$02,$e0,$02,$e0,$02
	dc.b	' ',$1f,' ',$1f,' ',$1f,' ',$1f
	dc.b	$f0,$02,$f0,$02,$f0,$02,$f0,$02
	dc.b	' ',$1f,' ',$1f,' ',$1f,' ',$1f
	dc.b	$fe,$02,$fe,$02,$fe,$02,$fe,$02
	dc.b	' ',$1f,' ',$1f,' ',$1f,' ',$1f
	dc.b	$fc,$02,$fc,$02,$fc,$02,$fc,$02
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dc.b	$f8,$02,$f8,$02,$f8,$02,$f8,$02
	dc.b	' ',$07,' ',$07,' ',$07,' ',$07
	dc.b	$f8,$02,$f8,$02,$f8,$02,$f8,$02
	dc.b	' ',$07,' ',$07,' ',$07,' ',$07
	dc.b	$fe,$02,$fe,$02,$fe,$02,$fe,$02
	dc.b	$7f,$ff,$7f,$ff,$7f,$ff,$7f,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$7f,$ff,$7f,$ff,$7f,$ff,$7f,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$7f,$ff,$7f,$ff,$7f,$ff,$7f,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$7f,$ff,$7f,$ff,$7f,$ff,$7f,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$7f,$ff,$7f,$ff,$7f,$ff,$7f,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$7f,$ff,$7f,$ff,$7f,$ff,$7f,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$7f,$ff,$7f,$ff,$7f,$ff,$7f,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$7f,$ff,$7f,$ff,$7f,$ff,$7f,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$7f,$ff,$7f,$ff,$7f,$ff,$7f,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$7f,$ff,$7f,$ff,$7f,$ff,$7f,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	' ',$1e,' ',$1e,' ',$1e,' ',$1e
	dc.b	$9e,$02,$9e,$02,$9e,$02,$9e,$02
	dc.b	' ',$01,' ',$01,' ',$01,' ',$01
	dc.b	$e0,$02,$e0,$02,$e0,$02,$e0,$02
	dc.b	' ',$01,' ',$01,' ',$01,' ',$01
	dc.b	$f0,$02,$f0,$02,$f0,$02,$f0,$02
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dc.b	$f8,$02,$f8,$02,$f8,$02,$f8,$02
	dc.b	' < < < <'
	dc.b	$f0,$02,$f0,$02,$f0,$02,$f0,$02
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dc.b	$be,$02,$be,$02,$be,$02,$be,$02
	dc.b	' ',$1f,' ',$1f,' ',$1f,' ',$1f
	dc.b	$fe,$02,$fe,$02,$fe,$02,$fe,$02
	dc.b	' ',$01,' ',$01,' ',$01,' ',$01
	dc.b	$e0,$02,$e0,$02,$e0,$02,$e0,$02
	dc.b	' ',$1f,' ',$1f,' ',$1f,' ',$1f
	dc.b	$be,$02,$be,$02,$be,$02,$be,$02
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dc.b	$9e,$02,$9e,$02,$9e,$02,$9e,$02
	dc.b	' ',$1e,' ',$1e,' ',$1e,' ',$1e
	dc.b	$9e,$02,$9e,$02,$9e,$02,$9e,$02
	dc.b	' ',$01,' ',$01,' ',$01,' ',$01
	dc.b	$e0,$02,$e0,$02,$e0,$02,$e0,$02
	dc.b	' ',$03,' ',$03,' ',$03,' ',$03
	dc.b	$e0,$02,$e0,$02,$e0,$02,$e0,$02
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dc.b	$fc,$02,$fc,$02,$fc,$02,$fc,$02
	dc.b	' < < < <'
	dc.b	$f0,$02,$f0,$02,$f0,$02,$f0,$02
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dc.b	$9e,$02,$9e,$02,$9e,$02,$9e,$02
	dc.b	' ',$1f,' ',$1f,' ',$1f,' ',$1f
	dc.b	$be,$02,$be,$02,$be,$02,$be,$02
	dc.b	' ',$01,' ',$01,' ',$01,' ',$01
	dc.b	$e0,$02,$e0,$02,$e0,$02,$e0,$02
	dc.b	' ',$1e,' ',$1e,' ',$1e,' ',$1e
	dc.b	$9e,$02,$9e,$02,$9e,$02,$9e,$02
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dc.b	$9e,$02,$9e,$02,$9e,$02,$9e,$02
	dc.b	' ',$1e,' ',$1e,' ',$1e,' ',$1e
	dc.b	$9e,$02,$9e,$02,$9e,$02,$9e,$02
	dc.b	' ',$01,' ',$01,' ',$01,' ',$01
	dc.b	$e0,$02,$e0,$02,$e0,$02,$e0,$02
	dc.b	' ',$03,' ',$03,' ',$03,' ',$03
	dc.b	$e0,$02,$e0,$02,$e0,$02,$e0,$02
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dc.b	$fc,$02,$fc,$02,$fc,$02,$fc,$02
	dc.b	' < < < <'
	dc.b	$f0,$02,$f0,$02,$f0,$02,$f0,$02
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dc.b	$9e,$02,$9e,$02,$9e,$02,$9e,$02
	dc.b	' ',$1e,' ',$1e,' ',$1e,' ',$1e
	dc.b	$9e,$02,$9e,$02,$9e,$02,$9e,$02
	dc.b	' ',$03,' ',$03,' ',$03,' ',$03
	dc.b	$e0,$02,$e0,$02,$e0,$02,$e0,$02
	dc.b	' ',$1e,' ',$1e,' ',$1e,' ',$1e
	dc.b	$9e,$02,$9e,$02,$9e,$02,$9e,$02
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dc.b	$9e,$02,$9e,$02,$9e,$02,$9e,$02
	dc.b	' ',$1e,' ',$1e,' ',$1e,' ',$1e
	dc.b	$9e,$02,$9e,$02,$9e,$02,$9e,$02
	dc.b	' ',$01,' ',$01,' ',$01,' ',$01
	dc.b	$e0,$02,$e0,$02,$e0,$02,$e0,$02
	dc.b	' ',$07,' ',$07,' ',$07,' ',$07
	dc.b	$c0,$02,$c0,$02,$c0,$02,$c0,$02
	dc.b	' ',$1e,' ',$1e,' ',$1e,' ',$1e
	dc.b	$be,$02,$be,$02,$be,$02,$be,$02
	dc.b	' ? ? ? ?'
	dc.b	$fc,$02,$fc,$02,$fc,$02,$fc,$02
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dc.b	$9e,$02,$9e,$02,$9e,$02,$9e,$02
	dc.b	' ',$1e,' ',$1e,' ',$1e,' ',$1e
	dc.b	$9e,$02,$9e,$02,$9e,$02,$9e,$02
	dc.b	' ',$07,' ',$07,' ',$07,' ',$07
	dc.b	$c0,$02,$c0,$02,$c0,$02,$c0,$02
	dc.b	' ',$1e,' ',$1e,' ',$1e,' ',$1e
	dc.b	$9e,$02,$9e,$02,$9e,$02,$9e,$02
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dc.b	$9e,$02,$9e,$02,$9e,$02,$9e,$02
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$9e,$04,$9e,$04,$9e,$04,$9e,$04
	dc.b	$10,$01,$10,$01,$10,$01,$10,$01
	dc.b	$e0,$04,$e0,$04,$e0,$04,$e0,$04
	dc.b	$10,$07,$10,$07,$10,$07,$10,$07
	dc.b	$c0,$04,$c0,$04,$c0,$04,$c0,$04
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$be,$04,$be,$04,$be,$04,$be,$04
	dc.b	$10,'?',$10,'?',$10,'?',$10,'?'
	dc.b	$fc,$04,$fc,$04,$fc,$04,$fc,$04
	dc.b	$10,$00,$10,$00,$10,$00,$10,$00
	dc.b	$9e,$04,$9e,$04,$9e,$04,$9e,$04
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$9e,$04,$9e,$04,$9e,$04,$9e,$04
	dc.b	$10,$07,$10,$07,$10,$07,$10,$07
	dc.b	$c0,$04,$c0,$04,$c0,$04,$c0,$04
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$9e,$04,$9e,$04,$9e,$04,$9e,$04
	dc.b	$10,$00,$10,$00,$10,$00,$10,$00
	dc.b	$be,$04,$be,$04,$be,$04,$be,$04
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$9e,$04,$9e,$04,$9e,$04,$9e,$04
	dc.b	$10,$01,$10,$01,$10,$01,$10,$01
	dc.b	$e0,$04,$e0,$04,$e0,$04,$e0,$04
	dc.b	$10,$0f,$10,$0f,$10,$0f,$10,$0f
	dc.b	$80,$04,$80,$04,$80,$04,$80,$04
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$9e,$04,$9e,$04,$9e,$04,$9e,$04
	dc.b	$10,'?',$10,'?',$10,'?',$10,'?'
	dc.b	$fc,$04,$fc,$04,$fc,$04,$fc,$04
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$9e,$04,$9e,$04,$9e,$04,$9e,$04
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$9e,$04,$9e,$04,$9e,$04,$9e,$04
	dc.b	$10,$07,$10,$07,$10,$07,$10,$07
	dc.b	$80,$04,$80,$04,$80,$04,$80,$04
	dc.b	$10,$1e,$10,$1e,$10,$1e,$10,$1e
	dc.b	$9e,$04,$9e,$04,$9e,$04,$9e,$04
	dc.b	$10,$00,$10,$00,$10,$00,$10,$00
	dc.b	$fe,$04,$fe,$04,$fe,$04,$fe,$04
	dc.b	$10,$1f,$10,$1f,$10,$1f,$10,$1f
	dc.b	$be,$04,$be,$04,$be,$04,$be,$04
	dc.b	$10,$01,$10,$01,$10,$01,$10,$01
	dc.b	$e0,$04,$e0,$04,$e0,$04,$e0,$04
	dc.b	$10,$0f,$10,$0f,$10,$0f,$10,$0f
	dc.b	$80,$04,$80,$04,$80,$04,$80,$04
	dc.b	$10,$1f,$10,$1f,$10,$1f,$10,$1f
	dc.b	$be,$04,$be,$04,$be,$04,$be,$04
	dc.b	$10,'?',$10,'?',$10,'?',$10,'?'
	dc.b	$fc,$04,$fc,$04,$fc,$04,$fc,$04
	dc.b	$10,$1f,$10,$1f,$10,$1f,$10,$1f
	dc.b	$be,$04,$be,$04,$be,$04,$be,$04
	dc.b	$10,$1f,$10,$1f,$10,$1f,$10,$1f
	dc.b	$be,$04,$be,$04,$be,$04,$be,$04
	dc.b	$10,$07,$10,$07,$10,$07,$10,$07
	dc.b	$80,$04,$80,$04,$80,$04,$80,$04
	dc.b	$10,$1f,$10,$1f,$10,$1f,$10,$1f
	dc.b	$be,$04,$be,$04,$be,$04,$be,$04
	dc.b	$10,$00,$10,$00,$10,$00,$10,$00
	dc.b	$fe,$04,$fe,$04,$fe,$04,$fe,$04
	dc.b	$08,$1f,$08,$1f,$08,$1f,$08,$1f
	dc.b	$fe,$08,$fe,$08,$fe,$08,$fe,$08
	dc.b	$08,$1f,$08,$1f,$08,$1f,$08,$1f
	dc.b	$fe,$08,$fe,$08,$fe,$08,$fe,$08
	dc.b	$08,$1f,$08,$1f,$08,$1f,$08,$1f
	dc.b	$fe,$08,$fe,$08,$fe,$08,$fe,$08
	dc.b	$08,$1f,$08,$1f,$08,$1f,$08,$1f
	dc.b	$fe,$08,$fe,$08,$fe,$08,$fe,$08
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dc.b	$f0,$08,$f0,$08,$f0,$08,$f0,$08
	dc.b	$08,$1f,$08,$1f,$08,$1f,$08,$1f
	dc.b	$fe,$08,$fe,$08,$fe,$08,$fe,$08
	dc.b	$08,$1f,$08,$1f,$08,$1f,$08,$1f
	dc.b	$fe,$08,$fe,$08,$fe,$08,$fe,$08
	dc.b	$08,$07,$08,$07,$08,$07,$08,$07
	dc.b	$80,$08,$80,$08,$80,$08,$80,$08
	dc.b	$08,$1f,$08,$1f,$08,$1f,$08,$1f
	dc.b	$fe,$08,$fe,$08,$fe,$08,$fe,$08
	dc.b	$08,$07,$08,$07,$08,$07,$08,$07
	dc.b	$fc,$08,$fc,$08,$fc,$08,$fc,$08
	dc.b	$04,$1f,$04,$1f,$04,$1f,$04,$1f
	dc.b	$fe,$10,$fe,$10,$fe,$10,$fe,$10
	dc.b	$04,$1f,$04,$1f,$04,$1f,$04,$1f
	dc.b	$fe,$10,$fe,$10,$fe,$10,$fe,$10
	dc.b	$04,$1f,$04,$1f,$04,$1f,$04,$1f
	dc.b	$fe,$10,$fe,$10,$fe,$10,$fe,$10
	dc.b	$04,$1f,$04,$1f,$04,$1f,$04,$1f
	dc.b	$fe,$10,$fe,$10,$fe,$10,$fe,$10
	dc.b	$04,$00,$04,$00,$04,$00,$04,$00
	dc.b	$f0,$10,$f0,$10,$f0,$10,$f0,$10
	dc.b	$04,$1f,$04,$1f,$04,$1f,$04,$1f
	dc.b	$fe,$10,$fe,$10,$fe,$10,$fe,$10
	dc.b	$04,$1f,$04,$1f,$04,$1f,$04,$1f
	dc.b	$fe,$10,$fe,$10,$fe,$10,$fe,$10
	dc.b	$04,$07,$04,$07,$04,$07,$04,$07
	dc.b	$80,$10,$80,$10,$80,$10,$80,$10
	dc.b	$04,$1f,$04,$1f,$04,$1f,$04,$1f
	dc.b	$fe,$10,$fe,$10,$fe,$10,$fe,$10
	dc.b	$04,$07,$04,$07,$04,$07,$04,$07
	dc.b	$f8,$10,$f8,$10,$f8,$10,$f8,$10
	dc.b	$02,$0f,$02,$0f,$02,$0f,$02,$0f
	dc.b	$fc,' ',$fc,' ',$fc,' ',$fc,' '
	dc.b	$02,$1f,$02,$1f,$02,$1f,$02,$1f
	dc.b	$fe,' ',$fe,' ',$fe,' ',$fe,' '
	dc.b	$02,$1f,$02,$1f,$02,$1f,$02,$1f
	dc.b	$fe,' ',$fe,' ',$fe,' ',$fe,' '
	dc.b	$02,$0f,$02,$0f,$02,$0f,$02,$0f
	dc.b	$fc,' ',$fc,' ',$fc,' ',$fc,' '
	dc.b	$02,$00,$02,$00,$02,$00,$02,$00
	dc.b	$f0,' ',$f0,' ',$f0,' ',$f0,' '
	dc.b	$02,$0f,$02,$0f,$02,$0f,$02,$0f
	dc.b	$fc,' ',$fc,' ',$fc,' ',$fc,' '
	dc.b	$02,$0f,$02,$0f,$02,$0f,$02,$0f
	dc.b	$fc,' ',$fc,' ',$fc,' ',$fc,' '
	dc.b	$02,$07,$02,$07,$02,$07,$02,$07
	dc.b	$80,' ',$80,' ',$80,' ',$80,' '
	dc.b	$02,$0f,$02,$0f,$02,$0f,$02,$0f
	dc.b	$fc,' ',$fc,' ',$fc,' ',$fc,' '
	dc.b	$02,$07,$02,$07,$02,$07,$02,$07
	dc.b	$f0,' ',$f0,' ',$f0,' ',$f0,' '
	dc.b	$01,$07,$01,$07,$01,$07,$01,$07
	dc.b	$f8,'@',$f8,'@',$f8,'@',$f8,'@'
	dc.b	$01,$1f,$01,$1f,$01,$1f,$01,$1f
	dc.b	$fe,'@',$fe,'@',$fe,'@',$fe,'@'
	dc.b	$01,$1f,$01,$1f,$01,$1f,$01,$1f
	dc.b	$fe,'@',$fe,'@',$fe,'@',$fe,'@'
	dc.b	$01,$07,$01,$07,$01,$07,$01,$07
	dc.b	$f8,'@',$f8,'@',$f8,'@',$f8,'@'
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dc.b	$f0,'@',$f0,'@',$f0,'@',$f0,'@'
	dc.b	$01,$07,$01,$07,$01,$07,$01,$07
	dc.b	$f8,'@',$f8,'@',$f8,'@',$f8,'@'
	dc.b	$01,$07,$01,$07,$01,$07,$01,$07
	dc.b	$f8,'@',$f8,'@',$f8,'@',$f8,'@'
	dc.b	$01,$07,$01,$07,$01,$07,$01,$07
	dc.b	$80,'@',$80,'@',$80,'@',$80,'@'
	dc.b	$01,$07,$01,$07,$01,$07,$01,$07
	dc.b	$f8,'@',$f8,'@',$f8,'@',$f8,'@'
	dc.b	$01,$07,$01,$07,$01,$07,$01,$07
	dc.b	$e0,'@',$e0,'@',$e0,'@',$e0,'@'
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dc.b	$80,$80,$80,$80,$80,$80,$80,$80
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dc.b	$80,$80,$80,$80,$80,$80,$80,$80
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dc.b	$80,$80,$80,$80,$80,$80,$80,$80
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dc.b	$80,$80,$80,$80,$80,$80,$80,$80
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dc.b	$80,$80,$80,$80,$80,$80,$80,$80
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dc.b	$80,$80,$80,$80,$80,$80,$80,$80
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dc.b	$80,$80,$80,$80,$80,$80,$80,$80
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dc.b	$80,$80,$80,$80,$80,$80,$80,$80
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dc.b	$80,$80,$80,$80,$80,$80,$80,$80
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dc.b	$80,$80,$80,$80,$80,$80,$80,$80
	dc.b	$00,'p',$00,'p',$00,'p',$00,'p'
	dc.b	$87,$00,$87,$00,$87,$00,$87,$00
	dc.b	$00,'p',$00,'p',$00,'p',$00,'p'
	dc.b	$87,$00,$87,$00,$87,$00,$87,$00
	dc.b	$00,'p',$00,'p',$00,'p',$00,'p'
	dc.b	$87,$00,$87,$00,$87,$00,$87,$00
	dc.b	$00,'p',$00,'p',$00,'p',$00,'p'
	dc.b	$87,$00,$87,$00,$87,$00,$87,$00
	dc.b	$00,'p',$00,'p',$00,'p',$00,'p'
	dc.b	$87,$00,$87,$00,$87,$00,$87,$00
	dc.b	$00,'p',$00,'p',$00,'p',$00,'p'
	dc.b	$87,$00,$87,$00,$87,$00,$87,$00
	dc.b	$00,'p',$00,'p',$00,'p',$00,'p'
	dc.b	$87,$00,$87,$00,$87,$00,$87,$00
	dc.b	$00,'p',$00,'p',$00,'p',$00,'p'
	dc.b	$87,$00,$87,$00,$87,$00,$87,$00
	dc.b	$00,'p',$00,'p',$00,'p',$00,'p'
	dc.b	$87,$00,$87,$00,$87,$00,$87,$00
	dc.b	$00,'p',$00,'p',$00,'p',$00,'p'
	dc.b	$87,$00,$87,$00,$87,$00,$87,$00
	dc.b	$00,$0f,$00,$0f,$00,$0f,$00,$0f
	dc.b	$f8,$00,$f8,$00,$f8,$00,$f8,$00
	dc.b	$00,$0f,$00,$0f,$00,$0f,$00,$0f
	dc.b	$f8,$00,$f8,$00,$f8,$00,$f8,$00
	dc.b	$00,$0f,$00,$0f,$00,$0f,$00,$0f
	dc.b	$f8,$00,$f8,$00,$f8,$00,$f8,$00
	dc.b	$00,$0f,$00,$0f,$00,$0f,$00,$0f
	dc.b	$f8,$00,$f8,$00,$f8,$00,$f8,$00
	dc.b	$00,$0f,$00,$0f,$00,$0f,$00,$0f
	dc.b	$f8,$00,$f8,$00,$f8,$00,$f8,$00
	dc.b	$00,$0f,$00,$0f,$00,$0f,$00,$0f
	dc.b	$f8,$00,$f8,$00,$f8,$00,$f8,$00
	dc.b	$00,$0f,$00,$0f,$00,$0f,$00,$0f
	dc.b	$f8,$00,$f8,$00,$f8,$00,$f8,$00
	dc.b	$00,$0f,$00,$0f,$00,$0f,$00,$0f
	dc.b	$f8,$00,$f8,$00,$f8,$00,$f8,$00
	dc.b	$00,$0f,$00,$0f,$00,$0f,$00,$0f
	dc.b	$f8,$00,$f8,$00,$f8,$00,$f8,$00
	dc.b	$00,$0f,$00,$0f,$00,$0f,$00,$0f
	dc.b	$f8,$00,$f8,$00,$f8,$00,$f8,$00
	dcb.w	4
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	336
	dc.b	$0f,$c8,$0f,$c8,$0f,$c8,$0f,$c8
	dc.b	$c8,$0f,$c8,$0f,$c8,$0f,$c8,$0f
	dc.b	$d8,$00,$d8,$00,$d8,$00,$d8,$00
	dc.b	$07,$e7,$07,$e7,$07,$e7,$07,$e7
	dc.b	$e4,'g',$e4,'g',$e4,'g',$e4,'g'
	dc.b	$e4,$0c,$e4,$0c,$e4,$0c,$e4,$0c
	dc.b	$fc,$fc,$fc,$fc,$fc,$fc,$fc,$fc
	dc.b	$fc,$00,$fc,$00,$fc,$00,$fc,$00
	dc.b	$01,$81,$01,$81,$01,$81,$01,$81
	dc.b	$f8,$01,$f8,$01,$f8,$01,$f8,$01
	dc.b	$e0,$fc,$e0,$fc,$e0,$fc,$e0,$fc
	dc.b	$fc,$00,$fc,$00,$fc,$00,$fc,$00
	dcb.w	32
	dc.b	$1f,$d8,$1f,$d8,$00,$00,$1f,$d8
	dc.b	$d8,$1f,$d8,$1f,$00,$00,$d8,$1f
	dc.b	$d8,$00,$d8,$00,$00,$00,$d8,$00
	dc.b	$0f,$ef,$0f,$ef,$00,$00,$0f,$ef
	dc.b	$ec,'o',$ec,'o',$00,$00,$ec,'o'
	dc.b	$ec,$0d,$ec,$0d,$00,$00,$ec,$0d
	dc.b	$fd,$fd,$fd,$fd,$00,$00,$fd,$fd
	dc.b	$fc,$00,$fc,$00,$00,$00,$fc,$00
	dc.b	$03,$83,$03,$83,$00,$00,$03,$83
	dc.b	$f8,$02,$f8,$02,$00,$00,$f8,$02
	dc.b	$11,$fd,$11,$fd,$00,$00,$11,$fd
	dc.b	$fc,$00,$fc,$00,$00,$00,$fc,$00
	dcb.w	37
	dc.b	$18,$00,$00,$00,$18,$00,$00,$00
	dcb.w	12
	dc.b	$0c,$00,$00,$00,$0c,$00,$00,$00
	dcb.w	12
	dc.b	$00,$02,$00,$00,$00,$02,$00,$00
	dc.b	$d0,$00,$00,$00,$d0,$00,$00,$00
	dc.b	$00,$f9,$00,$00,$00,$f9,$00,$00
	dc.b	$b1,$80,$00,$00,$b1,$80,$00,$00
	dcb.w	27
	dc.b	$1a,$d8,$00,$00,$00,$00,$1a,$d8
	dc.b	$d8,$03,$00,$00,$00,$00,$d8,$03
	dc.b	$18,$1c,$00,$00,$00,$00,$18,$1c
	dc.b	$0f,$0c,$00,$00,$00,$00,$0f,$0c
	dc.b	'll',$00,$00,$00,$00,'ll'
	dc.b	'l',$0c,$00,$00,$00,$00,'l',$0c
	dc.b	'q',$e1,$00,$00,$00,$00,'q',$e1
	dc.b	$fc,$02,$00,$00,$00,$00,$fc,$02
	dc.b	'!',$83,$00,$00,$00,$00,'!',$83
	dc.b	$18,$02,$00,$00,$00,$00,$18,$02
	dc.b	$91,$fc,$00,$00,$00,$00,$91,$fc
	dc.b	'0',$cd,$00,$00,$00,$00,'0',$cd
	dc.b	$9b,$00,$00,$00,$00,$00,$9b,$00
	dcb.w	31
	dc.b	$18,$d8,$00,$00,$00,$00,$00,$00
	dc.b	$d8,$03,$00,$00,$00,$00,$00,$00
	dc.b	$18,$00,$00,$00,$00,$00,$00,$00
	dc.b	$0c,$0c,$00,$00,$00,$00,$00,$00
	dc.b	$ac,'m',$00,$00,$00,$00,$00,$00
	dc.b	$ec,$0c,$00,$00,$00,$00,$00,$00
	dc.b	$e1,$81,$00,$00,$00,$00,$00,$00
	dc.b	$f0,$03,$00,$00,$00,$00,$00,$00
	dc.b	'a',$83,$00,$00,$00,$00,$00,$00
	dc.b	$18,$02,$00,$00,$00,$00,$00,$00
	dc.b	$d0,$0c,$00,$00,$00,$00,$00,$00
	dc.b	'0',$f9,$00,$00,$00,$00,$00,$00
	dc.b	$8e,$00,$00,$00,$00,$00,$00,$00
	dcb.w	25
	dc.b	$18,$df,$18,$df,$18,$df,$00,$00
	dc.b	$df,$c3,$df,$c3,$df,$c3,$00,$00
	dc.b	$18,$00,$18,$00,$18,$00,$00,$00
	dc.b	$0f,$ed,$0f,$ed,$0f,$ed,$00,$00
	dc.b	'O',$ec,'O',$ec,'O',$ec,$00,$00
	dc.b	'o',$ed,'o',$ed,'o',$ed,$00,$00
	dc.b	$fd,$fd,$fd,$fd,$fd,$fd,$00,$00
	dc.b	$b8,$01,$b8,$01,$b8,$01,$00,$00
	dc.b	$c1,$9b,$c1,$9b,$c1,$9b,$00,$00
	dc.b	'x',$02,'x',$02,'x',$02,$00,$00
	dc.b	$11,$fc,$11,$fc,$11,$fc,$00,$00
	dc.b	'0',$cd,'0',$cd,'0',$cd,$00,$00
	dc.b	$9b,$00,$9b,$00,$9b,$00,$00,$00
	dcb.w	29
	dc.b	$1d,$df,$1d,$df,$00,$00,$00,$00
	dc.b	$df,$c3,$df,$c3,$00,$00,$00,$00
	dc.b	$18,$00,$18,$00,$00,$00,$00,$00
	dc.b	$0f,$ed,$0f,$ed,$00,$00,$00,$00
	dc.b	$af,$ee,$af,$ee,$00,$00,$00,$00
	dc.b	$ef,$ed,$ef,$ed,$00,$00,$00,$00
	dc.b	$fd,$fd,$fd,$fd,$00,$00,$00,$00
	dc.b	$9c,$00,$9c,$00,$00,$00,$00,$00
	dc.b	$83,$db,$83,$db,$00,$00,$00,$00
	dc.b	'x',$01,'x',$01,$00,$00,$00,$00
	dc.b	$e1,$fc,$e1,$fc,$00,$00,$00,$00
	dc.b	'0',$cd,'0',$cd,$00,$00,$00,$00
	dc.b	$b1,$80,$b1,$80,$00,$00,$00,$00
	dcb.w	275
	dc.b	$00,$fc,$00,$fc,$00,$fc,$00,$fc
	dc.b	'|',$fc,'|',$fc,'|',$fc,'|',$fc
	dc.b	$00,'>',$00,'>',$00,'>',$00,'>'
	dc.b	$fc,$18,$fc,$18,$fc,$18,$fc,$18
	dc.b	$0f,$d9,$0f,$d9,$0f,$d9,$0f,$d9
	dc.b	$19,$f9,$19,$f9,$19,$f9,$19,$f9
	dc.b	$01,$f8,$01,$f8,$01,$f8,$01,$f8
	dc.b	$02,'@',$02,'@',$02,'@',$02,'@'
	dcb.w	48
	dc.b	$00,$18,$00,$18,$00,$00,$00,$18
	dc.b	$cd,$fc,$cd,$fc,$00,$00,$cd,$fc
	dc.b	$00,'f',$c6,'f',$00,$00,$c6,'f'
	dc.b	$0c,'8',$0c,'8',$00,$00,$0c,'8'
	dc.b	$1f,$db,$1f,$db,$00,$00,$1f,$db
	dc.b	$bb,$fb,$bb,$fb,$00,$00,$bb,$fb
	dc.b	$03,$f8,$03,$f8,$00,$00,$03,$f8
	dc.b	$06,$c0,$06,$c0,$00,$00,$06,$c0
	dcb.w	56
	dc.b	'l',$00,$00,$00,$00,$00,'l',$00
	dcb.w	9
	dc.b	$00,$03,$00,$00,$00,$03,$00,$00
	dcb.w	4
	dc.b	$06,$c0,$00,$00,$06,$c0,$00,$00
	dcb.w	47
	dc.b	$00,$18,$00,$00,$00,$00,$00,$18
	dc.b	$19,$8c,$00,$00,$00,$00,$19,$8c
	dc.b	$00,$0c,$00,$00,$00,$00,'8',$0c
	dc.b	$18,$d8,$00,$00,$00,$00,$18,$d8
	dc.b	$1f,$d8,$00,$00,$00,$00,$1f,$d8
	dc.b	$e3,$c3,$00,$00,$00,$00,$e3,$c3
	dc.b	$03,$f8,$00,$00,$00,$00,$03,$f8
	dc.b	$06,$c0,$00,$00,$00,$00,$06,$c0
	dcb.w	51
	dc.b	$00,$0c,$00,$00,$00,$00,$00,$00
	dc.b	'1',$8c,'l',$00,'l',$00,'l',$00
	dc.b	$00,$18,$00,$00,$00,$00,$00,$00
	dc.b	'0',$fc,$00,$00,$00,$00,$00,$00
	dc.b	$18,$19,$00,$00,$00,$00,$00,$00
	dc.b	$b3,$03,$00,$00,$00,$00,$00,$00
	dc.b	$00,$18,$00,$00,$00,$00,$00,$00
	dcb.w	49
	dc.b	$00,$cc,$00,$cc,$00,$cc,$00,$00
	dc.b	'a',$bc,'a',$bc,'a',$bc,$00,$00
	dc.b	$00,'0',$c6,'0',$c6,'0',$00,$00
	dc.b	'0',$18,'0',$18,'0',$18,$00,$00
	dc.b	$18,$1b,$18,$1b,$18,$1b,$00,$00
	dc.b	$bb,$fb,$bb,$fb,$bb,$fb,$00,$00
	dc.b	$fb,$f8,$fb,$f8,$fb,$f8,$00,$00
	dc.b	$06,$c0,$06,$c0,$06,$c0,$00,$00
	dcb.w	49
	dc.b	$00,'x',$00,'x',$00,$00,$00,$00
	dc.b	$fd,$bc,$fd,$bc,$00,$00,$00,$00
	dc.b	$00,'~',$00,'~',$00,$00,$00,$00
	dc.b	'0',$18,'0',$18,$00,$00,$00,$00
	dc.b	$18,$1b,$18,$1b,$00,$00,$00,$00
	dc.b	$1b,$fb,$1b,$fb,$00,$00,$00,$00
	dc.b	$fb,$f8,$fb,$f8,$00,$00,$00,$00
	dc.b	$06,$c0,$06,$c0,$00,$00,$00,$00
	dcb.w	911
	dc.b	$00,$10,$00,$10,$00,$10,$00,$10
	dcb.w	148
	dc.b	$00,$04,$00,$04,$00,$04,$00,$04
	dcb.w	64
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dcb.w	4
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dcb.w	88
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dcb.w	92
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dc.b	$00,$00,$00,$0e,$00,$0e,$00,$0e
	dcb.w	28
	dc.b	$02,$00,$02,$00,$02,$00,$02,$00
	dcb.w	16
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	13
	dc.b	$00,$7f,$00,$7f,$00,$7f,$00,$00
	dc.b	$80,$00,$80,$00,$80,$00,$00,$00
	dcb.w	4
	dc.b	$00,$01,$00,'q',$00,'q',$00,$00
	dc.b	$c0,$00,$c0,$00,$c0,$00,$00,$00
	dcb.w	8
	dc.b	$1c,$00,$00,$00,$1c,$00,$00,$00
	dcb.w	31
	dc.b	$02,$00,$02,$00,$02,$00,$02,$00
	dcb.w	14
	dc.b	$01,$80,$01,$80,$00,$00,'`',$00
	dc.b	'`',$00,'`',$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$00,$80,$00,$80,$00,$00,' ',$00
	dc.b	' ',$00,' ',$00,$01,$00,$01,$00
	dc.b	$01,$00,$01,$00,$00,$01,$00,$00
	dc.b	$00,$00,$00,$01,$83,$c0,$7f,$c0
	dc.b	$00,$00,$ff,$c0,$00,$02,$00,$02
	dc.b	$00,$02,$00,$02,$00,$00,$00,$00
	dcb.w	42
	dc.b	$00,'!',$00,'!',$02,'!',$02,'!'
	dc.b	$8c,$80,$93,$c0,$90,$00,$9f,$c0
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dcb.w	2
	dc.b	$01,$00,$01,$00,$80,$00,$90,$00
	dc.b	$90,$00,$90,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$19,$00,$06,$00,$00,$00,$1f
	dc.b	$91,$80,'o',$fc,$00,$00,$ff,$fc
	dcb.w	21
	dc.b	$00,$07,$00,$00,$00,$07,'`',$00
	dc.b	$f0,$00,$00,$00,$f0,$00,$00,$00
	dcb.w	3
	dc.b	$00,$10,$00,$13,$00,$10,$00,$13
	dc.b	$16,$00,$fe,$00,$00,$00,$fe,$00
	dcb.w	8
	dc.b	$00,' ',$00,' ',$04,' ',$04,' '
	dc.b	'`',$7f,$df,$ff,'H',$00,$ff,$ff
	dc.b	'@',$00,$c0,$00,$00,$00,$c0,$00
	dc.b	$00,'"',$00,'"',$01,'"',$01,'"'
	dc.b	'@',$00,'P',$00,'P',$00,'P',$00
	dcb.w	4
	dc.b	$00,$04,$01,$fb,$00,$00,$01,$ff
	dc.b	$80,$16,$7f,$ff,$00,$00,$ff,$ff
	dcb.w	4
	dc.b	$00,$1e,$00,$01,$00,$00,$00,$1f
	dc.b	$c0,$00,$e0,$00,$00,$00,$e0,$00
	dcb.w	8
	dc.b	$03,$00,$00,$ff,$00,$00,$03,$ff
	dc.b	$09,$c0,$ff,$e0,$00,$00,$ff,$e0
	dcb.w	4
	dc.b	'@K@',$b4,'@',$00,'@',$ff
	dc.b	$8c,$00,$7f,$f0,$03,$f0,$ff,$f0
	dcb.w	8
	dc.b	$00,$a7,$00,$ac,$04,$a4,$04,$af
	dc.b	$f0,$05,$0f,$ff,$08,$00,$ff,$ff
	dc.b	$bc,$00,$fc,$00,$00,$00,$fc,$00
	dc.b	$00,'o',$00,'n',$02,'n',$02,'o'
	dc.b	$c0,$00,$b8,$00,$88,$00,$f8,$00
	dcb.w	4
	dc.b	$03,$f7,$0c,$08,$00,$00,$0f,$ff
	dc.b	$00,$02,$ff,$ff,$00,$00,$ff,$ff
	dc.b	'@',$00,$c0,$00,$00,$00,$c0,$00
	dc.b	$13,$b8,$1c,'G',$10,$00,$1f,$ff
	dc.b	$10,$00,$fc,$00,$00,$00,$fc,$00
	dcb.w	8
	dc.b	$1e,$00,'a',$ff,$00,$00,$7f,$ff
	dc.b	$00,$d6,$ff,$ff,$00,$00,$ff,$ff
	dcb.w	4
	dc.b	$00,$ac,$03,'S',$00,$00,$03,$ff
	dc.b	$0d,$c0,$f3,$fc,$0c,$0c,$ff,$fc
	dcb.w	4
	dc.b	$1a,$00,$07,$80,$00,$00,$1f,$80
	dc.b	$01,$bf,$01,$bd,$09,$bd,$09,$bf
	dc.b	' ',$00,$ff,$ff,'$',$00,$ff,$ff
	dc.b	$e5,$e0,$ff,$e0,$00,$00,$ff,$e0
	dc.b	$00,$ff,$00,$ff,$02,$ff,$02,$ff
	dc.b	$f0,$80,$ef,$e0,$e8,$00,$ff,$e0
	dc.b	'@',$00,'@',$00,'@',$00,'@',$00
	dc.b	$13,$80,',',$7f,$00,$00,'?',$ff
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$10,$00,$f0,$00,$00,$00,$f0,$00
	dc.b	'8',$c0,$07,'?',$00,$00,'?',$ff
	dc.b	$05,$00,$ff,$f8,$00,$f8,$ff,$f8
	dcb.w	4
	dc.b	$00,$01,$00,$06,$00,$00,$00,$07
	dc.b	'@',$00,$bf,$ff,$00,$00,$ff,$ff
	dc.b	$02,'"',$ff,$ff,$00,$00,$ff,$ff
	dc.b	$00,$00,$f0,$00,$00,$00,$f0,$00
	dc.b	$0f,$a0,$00,'_',$00,$00,$0f,$ff
	dc.b	$11,$18,$ef,$ff,$11,$12,$ff,$ff
	dc.b	$00,$00,$80,$01,$00,$00,$80,$01
	dc.b	'H',$e0,$b7,$fe,$00,$00,$ff,$fe
	dc.b	$03,$ff,$03,$ff,$0b,$ff,$0b,$ff
	dc.b	$f0,$00,$ff,$ff,$f4,$00,$ff,$ff
	dc.b	$09,$c0,$ff,$f8,$00,$00,$ff,$f8
	dcb.w	2
	dc.b	$03,$ff,$03,$ff,$03,$be,$07,$ff
	dc.b	$f8,$00,$ff,$ff,$00,$00,$00,$00
	dcb.w	2
	dc.b	$bf,$e0,'@',$1f,$00,$00,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$1c,$00,$fc,$00,$00,$00,$fc,$00
	dc.b	$f8,$00,$07,$ff,$00,$00,$ff,$ff
	dc.b	$00,'p',$fc,$f6,$03,$06,$ff,$f6
	dcb.w	4
	dc.b	$00,'<',$00,$03,$00,$00,$00,'?'
	dc.b	$90,$00,'o',$ff,$00,$00,$ff,$ff
	dc.b	$03,$cb,$ff,$ff,$00,$00,$ff,$ff
	dc.b	'P$',$ff,'$',$00,'$',$ff,'$'
	dc.b	':',$00,$05,$ff,$00,$00,'?',$ff
	dc.b	$13,'H',$ef,$ff,$13,'J',$ff,$ff
	dc.b	$80,$0b,$e0,$14,$00,$00,$e0,$1f
	dc.b	$c0,';?',$ff,$00,$00,$ff,$ff
	dc.b	$00,$00,$e0,$00,$0f,$ff,$ef,$ff
	dc.b	$00,$00,$03,$ff,$fc,$00,$ff,$ff
	dc.b	$00,',',$ff,$fe,$00,$00,$ff,$fe
	dc.b	$00,$83,$01,$00,$00,$7f,$01,$ff
	dc.b	$c0,$06,'?',$ff,$c0,$00,$ff,$ff
	dc.b	$c0,$01,$c0,$06,$00,$00,$c0,$07
	dc.b	$c0,$00,'?',$ff,$00,$00,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$00,$07,$ff,$ff
	dc.b	$00,$00,$ff,$83,$ff,$80,$ff,$83
	dc.b	$ed,$00,$12,$ff,$00,$00,$ff,$ff
	dc.b	$00,'x',$fb,$fd,$04,'I',$ff,$fd
	dc.b	$00,'@',$00,'@',$00,'@',$00,'@'
	dc.b	$00,$9e,$03,'a',$00,$00,$03,$ff
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$00,$0e,$ff,$ff,$1f,$e0,$ff,$ff
	dc.b	$87,$00,$ff,$c0,$00,$00,$ff,$c0
	dc.b	$ce,$00,'1',$ff,$00,$00,$ff,$ff
	dc.b	$27,$f0,$df,$ff,$27,$e1,$ff,$ff
	dc.b	'a}',$f0,$82,$00,$00,$f1,$ff
	dc.b	$00,$07,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$03,$87,$fc,$00,$00,$7f,$ff,$ff
	dc.b	$80,$00,$7f,$ff,$80,$00,$ff,$ff
	dc.b	$01,$1a,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$04,$c5,$c3,$02,$00,'?',$c7,$ff
	dc.b	$80,$07,$7f,$ff,$80,$00,$ff,$ff
	dc.b	'`',$0b,$f0,$14,$00,$00,$f0,$1f
	dc.b	'P',$00,$af,$ff,$00,$00,$ff,$ff
	dc.b	$00,$03,$ff,$f8,$00,$07,$ff,$ff
	dc.b	$ff,$0f,$00,$c0,$ff,$80,$ff,$cf
	dc.b	$80,$00,$7f,$ff,$7f,$f8,$ff,$ff
	dc.b	$01,'}',$f7,$ff,$09,'d',$ff,$ff
	dc.b	$00,$00,$80,$00,$80,$00,$80,$00
	dc.b	$0f,$c0,'0?',$00,$00,'?',$ff
	dc.b	$00,$00,$ff,$ff,$1f,$f0,$ff,$ff
	dc.b	$0f,$cb,$e0,'?',$1f,$e0,$ff,$ff
	dc.b	$cd,$80,$ff,$f0,$00,$00,$ff,$f0
	dc.b	$f0,$00,$0f,$ff,$00,$00,$ff,$ff
	dc.b	$1f,$fe,$df,$ff,'?',$ff,$ff,$ff
	dc.b	$1f,$e0,$f0,$1f,$00,$00,$ff,$ff
	dc.b	$00,$01,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$bd,',',$f2,$c3,$00,$1e,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$00,$08,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$f3,'$',$fc,$d3,$00,$0e,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	'p?',$fc,'@',$00,$00,$fc,$7f
	dc.b	$c0,$00,'?',$ff,$00,$00,$ff,$ff
	dc.b	$00,$02,$ff,$f8,$00,$07,$ff,$ff
	dc.b	$a5,'O',$00,$f0,$ff,$80,$ff,$ff
	dc.b	'?',$f0,$80,$0f,$7f,$f8,$ff,$ff
	dc.b	$03,$f4,$f7,$ff,$0b,$f0,$ff,$ff
	dc.b	$00,$03,$80,$0c,$80,$00,$80,$0f
	dc.b	$bf,$85,'@z',$00,$00,$ff,$ff
	dc.b	$8f,$e0,'`',$1f,$1f,$f0,$ff,$ff
	dc.b	$09,'L',$e0,'?',$1f,$e0,$ff,$ff
	dc.b	'$0',$ff,$f8,$00,$00,$ff,$f8
	dc.b	'`',$00,$9f,$ff,$00,$00,$ff,$ff
	dc.b	$03,$ff,$c0,$00,'?',$ff,$ff,$ff
	dc.b	'Lp',$ff,$8f,$00,$00,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$ba,'@',$e5,$b7,$00,$0c,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$03,$fe,$ff,$ff
	dc.b	$1c,$04,$ff,$f3,$00,$0e,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$06,'`',$ff,$9f,$00,$00,$ff,$ff
	dc.b	$08,$00,$f7,$ff,$00,$03,$ff,$ff
	dc.b	$00,$03,$ff,$f8,$ff,$ff,$ff,$ff
	dc.b	$ff,'2',$00,$cd,$ff,$80,$ff,$ff
	dc.b	$aa,'P',$00,$0f,$7f,$f8,$ff,$ff
	dc.b	$00,$00,$f0,$00,$0f,$ff,$ff,$ff
	dc.b	$01,$be,'bA',$80,$00,$e3,$ff
	dc.b	'`',$00,$9f,$ff,$00,$00,$ff,$ff
	dc.b	$0f,$e0,$e0,$1f,$1f,$f0,$ff,$ff
	dc.b	$0f,$c0,$e0,'?',$1f,$e0,$ff,$ff
	dc.b	'!',$e0,$ff,$fe,$00,$00,$ff,$fe
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$00,'`',$fe,$1f,$01,$e0,$ff,$ff
	dc.b	$02,$00,$ff,$ff,$00,$01,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$80,$ff,$ff
	dc.b	'$',$00,$db,$f7,$00,$0c,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$01,$fc,$fc,$03,$03,$fe,$ff,$ff
	dc.b	'!',$04,$ff,$f3,$00,$0e,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$03,$f0,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$00,$01,$ff,$fc,$00,$03,$ff,$ff
	dc.b	$ff,$fb,$00,$00,$ff,$ff,$ff,$ff
	dc.b	'AB',$00,$bd,$ff,$80,$ff,$ff
	dc.b	'?',$f0,$80,$0f,$7f,$f8,$ff,$ff
	dc.b	$00,'|',$fe,$03,$01,$fc,$ff,$ff
	dc.b	'?h',$f0,$97,$00,$00,$ff,$ff
	dc.b	$c4,$00,';',$ff,$00,$ff,$ff,$ff
	dc.b	$09,' ',$e0,$1f,$ff,$f0,$ff,$ff
	dc.b	$0a,$81,$e0,'?',$1f,$e0,$ff,$ff
	dc.b	$82,'F',$ff,$ff,$00,$00,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$00,$00,$ff,$7f,$00,$c0,$ff,$ff
	dc.b	$00,$80,$ff,$fe,$00,$01,$ff,$ff
	dc.b	$ff,$00,$00,$ff,$ff,$80,$ff,$ff
	dc.b	' ',$00,$df,$f7,$00,$0c,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$01,'T',$fc,$03,$03,$fe,$ff,$ff
	dc.b	$0c,$a4,$ff,$f3,$00,$0e,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$00,'<',$ff,$ff,$00,$00,$ff,$ff
	dc.b	$00,$01,$ff,$fc,$00,$03,$ff,$ff
	dc.b	'Es',$00,$00,$ff,$ff,$ff,$ff
	dc.b	$ff,$00,$00,$ff,$ff,$ff,$ff,$ff
	dc.b	$14,$90,$e0,$0f,$ff,$f8,$ff,$ff
	dc.b	$00,' ',$ff,$9f,$00,'p',$ff,$ff
	dc.b	$0e,$0e,$ff,$f1,$00,$00,$ff,$ff
	dc.b	$00,$7f,$ff,$00,$00,$ff,$ff,$ff
	dc.b	$cf,$e0,$00,$1f,$ff,$f0,$ff,$ff
	dc.b	$0f,$c0,$e0,'?',$1f,$e0,$ff,$ff
	dc.b	$0b,$13,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$00,$80,$fe,$7f,$01,$e0,$ff,$ff
	dc.b	$00,$00,$ff,$fe,$00,$01,$ff,$ff
	dc.b	$a5,$00,$00,$ff,$ff,$80,$ff,$ff
	dc.b	$00,$00,$ff,$f7,$00,$0c,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$00,'?',$ff,$ff
	dc.b	$01,$fc,$fc,$03,$ff,$fe,$ff,$ff
	dc.b	$00,$14,$ff,$f3,$00,$0e,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$00,$7f,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$e2,$00,$00,$ff,$ff,$ff,$ff
	dc.b	'I',$7f,$00,$80,$ff,$ff,$ff,$ff
	dc.b	$df,$f0,' ',$0f,$ff,$f8,$ff,$ff
	dc.b	$00,' ',$ff,$9f,$00,'p',$ff,$ff
	dc.b	$01,$80,$ff,$ff,$00,'?',$ff,$ff
	dc.b	$00,$0a,$ff,$f0,$ff,$ff,$ff,$ff
	dc.b	$8a,'`',$00,$1f,$ff,$ff,$ff,$ff
	dc.b	$03,$c0,$fc,'?',$ff,$e0,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$00,$00,$07,$ff,$00,$00,$07,$ff
	dc.b	$00,$c0,$fe,'?',$01,$e0,$ff,$ff
	dc.b	$00,$00,$ff,$fe,$00,$01,$ff,$ff
	dc.b	$ff,$00,$00,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$08,$ff,$e7,$f8,$1e,$ff,$ff
	dc.b	$00,$1f,$ff,$c0,$00,'?',$ff,$ff
	dc.b	$f9,$14,$00,$03,$ff,$fe,$ff,$ff
	dc.b	$00,$04,$ff,$f3,$00,$0e,$ff,$ff
	dc.b	$00,'?',$ff,$80,$00,$7f,$ff,$ff
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$ff,$fe,$00,$01,$ff,$ff,$ff,$ff
	dc.b	$91,'C',$00,$00,$ff,$ff,$ff,$ff
	dc.b	$ff,'d',$00,$80,$ff,$ff,$ff,$ff
	dc.b	'R',$90,' ',$0f,$ff,$f8,$ff,$ff
	dc.b	$00,' ',$ff,$9f,$00,'p',$ff,$ff
	dc.b	$00,$1f,$ff,$c0,$00,'?',$ff,$ff
	dc.b	$ff,$ef,$00,$10,$ff,$ff,$ff,$ff
	dc.b	$0f,$ef,$00,$10,$ff,$ff,$ff,$ff
	dc.b	$fb,$80,$04,'?',$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$f0,$00,$ff,$ff
	dc.b	$00,$00,$00,$01,$00,$00,$00,$01
	dc.b	$00,$c0,$fe,'?',$01,$e0,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$01,$7f,$f8,$80,$ff,$ff,$ff,$ff
	dc.b	$f0,$0c,$0f,$e3,$f8,$1e,$ff,$ff
	dc.b	$00,$14,$ff,$c0,$00,'?',$ff,$ff
	dc.b	'Q',$fc,$00,$03,$ff,$fe,$ff,$ff
	dc.b	$00,$04,$ff,$f3,$00,$0e,$ff,$ff
	dc.b	$00,')',$ff,$80,$00,$7f,$ff,$ff
	dc.b	$02,$93,$00,$00,$ff,$ff,$ff,$ff
	dc.b	'T',$a2,$00,$01,$ff,$ff,$ff,$ff
	dc.b	$ff,$83,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$15,$7f,$00,$80,$ff,$ff,$ff,$ff
	dc.b	$df,$f0,' ',$0f,$ff,$f8,$ff,$ff
	dc.b	$00,' ',$ff,$9f,$00,'p',$ff,$ff
	dc.b	$00,$15,$ff,$c0,$00,'?',$ff,$ff
	dc.b	$12,$ae,$00,$10,$ff,$ff,$ff,$ff
	dc.b	$0a,'*',$00,$10,$ff,$ff,$ff,$ff
	dc.b	$ab,'?',$04,$00,$ff,$ff,$ff,$ff
	dc.b	$e0,$00,$1f,$ff,$f0,$00,$ff,$ff
	dcb.w	4
	dc.b	$00,$c0,$00,'?',$01,$e0,$01,$ff
	dc.b	'XS',$00,$00,$ff,$ff,$ff,$ff
	dc.b	'W*',$08,$80,$ff,$ff,$ff,$ff
	dc.b	$d0,$1e,$0b,$c1,$f8,'?',$fb,$ff
	dc.b	$00,$1f,$ff,$c0,$00,'?',$ff,$ff
	dc.b	$e1,',',$00,$03,$ff,$fe,$ff,$ff
	dc.b	$00,$0e,$ff,$e1,$00,$1f,$ff,$ff
	dc.b	$00,'?',$ff,$80,$00,$7f,$ff,$ff
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$ff,$fe,$00,$01,$ff,$ff,$ff,$ff
	dc.b	$93,$03,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$ff,'Q',$00,$80,$ff,$ff,$ff,$ff
	dc.b	'T',$90,' ',$0f,$ff,$f8,$ff,$ff
	dc.b	$00,'p',$e0,$08,$00,$f8,$e0,$f8
	dc.b	$00,$1f,$03,$c0,$00,'?',$03,$ff
	dc.b	$ff,$ec,$00,$10,$ff,$ff,$ff,$ff
	dc.b	$0f,$ef,$00,$10,$ff,$ff,$ff,$ff
	dc.b	$fa,'%',$04,$00,$ff,$ff,$ff,$ff
	dc.b	' ',$00,$1f,$ff,$f0,$00,$ff,$ff
	dcb.w	4
	dc.b	$00,$e0,$00,$10,$03,$f0,$03,$f0
	dc.b	$7f,$ff,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$f7,$7f,$08,$80,$ff,$ff,$ff,$ff
	dc.b	$f0,'?',$08,$00,$f8,$ff,$f8,$ff
	dc.b	$00,$1f,$c3,$c0,$c0,'?',$c3,$ff
	dc.b	$c1,$fc,$00,$03,$ff,$fe,$ff,$ff
	dc.b	$00,$1f,$ff,$c0,$00,'?',$ff,$ff
	dc.b	$00,'?',$80,$00,$80,$7f,$80,$7f
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$ff,$fe,$00,$01,$ff,$ff,$ff,$ff
	dc.b	$fe,$03,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$ff,$7f,$00,$80,$ff,$ff,$ff,$ff
	dc.b	$df,$f0,' ',$08,$ff,$f8,$ff,$f8
	dc.b	$00,$f8,$00,$04,$01,$fc,$01,$fc
	dc.b	$00,$1f,$00,$00,$00,'?',$00,'?'
	dc.b	$ff,$e8,$00,$10,$ff,$ff,$ff,$ff
	dc.b	$0f,$ef,$00,$10,$ff,$ff,$ff,$ff
	dc.b	$f8,'?',$04,$00,$ff,$ff,$ff,$ff
	dc.b	$e0,$00,$10,$00,$f0,$00,$f0,$00
	dcb.w	4
	dc.b	$03,$f0,$00,$08,$07,$f8,$07,$f8
	dcb.w	2
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$08,$80
	dc.b	$ff,$ff,$ff,$ff,$00,$ff,$08,$00
	dc.b	$fb,$ff,$fb,$ff,$c0,$00,'0',$00
	dc.b	$f0,'?',$f0,'?',$00,$00,$00,$03
	dc.b	$ff,$fe,$ff,$ff,$00,'?',$e0,$00
	dc.b	$01,$ff,$e1,$ff,$80,$00,'p',$00
	dc.b	$f0,$7f,$f0,$7f,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$01
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$80
	dc.b	$ff,$ff,$ff,$ff,$00,$00,' ',$08
	dc.b	$ff,$f8,$ff,$f8,$01,$fc,$00,$03
	dc.b	$07,$ff,$07,$ff,$00,$00,$00,$00
	dc.b	$00,'?',$00,'?',$00,$00,$00,$10
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$10
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$04,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$10,$00
	dc.b	$f0,$00,$f0,$00,$00,$00,$00,$00
	dcb.w	158
	dc.b	$00,'x',$04,$0c,$04,$0c,$03,$f0
	dc.b	$02,$89,$07,$07,$00,$01,$07,$fe
	dc.b	$03,$af,$06,' ',$06,' ',$01,$df
	dc.b	'<',$a0,$ff,'0',$00,'0',$ff,$c0
	dc.b	'0',$c3,'p',$ff,'p',$ff,$0f,$00
	dc.b	$e0,$18,$e7,$f9,$e7,$f9,$18,$06
	dcb.w	5
	dc.b	$00,$02,$00,$02,$00,$01,$1a,$00
	dc.b	$e3,$01,$03,$01,$fc,$00,$1e,$00
	dc.b	$03,$01,$03,$00,$fc,$01,$a2,'C'
	dc.b	$c1,$c6,$00,'F',$ff,$81,$0d,$ce
	dc.b	$03,$f2,$00,$02,$ff,$fd,$ce,'L'
	dc.b	'?',$dc,$00,'\',$ff,$83,'0',$f8
	dc.b	'?',$f9,'?',$f9,$c0,$06,$06,$00
	dc.b	$fe,'A',$fe,'A',$01,$80,$fd,$ec
	dc.b	$83,$f0,$80,$00,$7f,$ff,$ce,'N'
	dc.b	'?',$df,$00,$00,$ff,$df,'Bs'
	dc.b	$81,$fc,$00,$00,$ff,$ff,$98,$00
	dc.b	$02,$00,$02,$00,$fc,$00,$05,$12
	dc.b	$0e,$0e,$00,$02,$0f,$fc,$0f,'@'
	dc.b	$18,':',$18,$02,$07,$fc,$01,'Z'
	dc.b	$03,$87,$00,$03,$07,$fc,$0b,$ee
	dc.b	$0e,'!',$08,' ',$07,$df,'8',$d8
	dc.b	$ff,'(',$00,$08,$ff,$f0,'Y'
	dc.b	'9',$f7,'9',$f7,'F',$08,$c2,'8'
	dc.b	$cf,$fb,$cf,$fb,'0',$04,$00,$00
	dcb.w	3
	dc.b	$00,$06,$00,$05,$00,$04,$00,$03
	dc.b	$d1,$03,$e1,$86,$01,$86,$fe,$01
	dc.b	$d0,$00,$0e,$80,$00,$80,$ff,$01
	dc.b	'V',$8d,$e1,$ca,$00,$c8,$ff,$07
	dc.b	$8e,$e4,$01,$f8,$00,$00,$ff,$ff
	dc.b	$dc,$96,'?',$ce,$00,$ce,$ff,$11
	dc.b	'`p}',$f3,'}',$f3,$82,$0c
	dc.b	$8e,$02,$fe,$c7,$fe,$c6,$01,$01
	dc.b	$fe,$e4,$81,$f8,$00,$00,$ff,$ff
	dc.b	$dc,$c7,'?',$cf,$00,$c0,$ff,$1f
	dc.b	'fn',$81,$f0,$00,$00,$ff,$ff
	dc.b	's',$00,$0d,$80,$01,$80,$fe,$00
	dc.b	$02,$b4,$07,$0e,$00,$06,$0f,$f8
	dc.b	$11,$84,'>y0',$01,$0f,$fe
	dc.b	$04,'T',$05,$8f,$04,$07,$03,$f8
	dc.b	$16,$fe,$1f,'!',$10,' ',$0f,$df
	dc.b	'1',$f4,$fe,'<',$00,$04,$ff,$f8
	dc.b	'o',$08,$1f,$f3,$1f,$f3,'`',$0c
	dc.b	$87,$f0,$9d,$f7,$9d,$f7,'b',$08
	dcb.w	4
	dc.b	$00,$09,$00,$0f,$00,$08,$00,$07
	dc.b	$d7,$84,$e0,$8f,$00,$8c,$ff,$03
	dc.b	'a',$01,$9e,'A',$00,'A',$ff,$80
	dc.b	$15,$0e,'c',$d7,$01,$d0,$fe,$0f
	dc.b	$87,'5',$00,$f8,$00,$00,$ff,$ff
	dc.b	$b9,$1b,$7f,$c7,$01,$c7,$fe,$18
	dc.b	$c2,'!',$fc,$e7,$fc,$e7,$03,$18
	dc.b	$fc,$05,'}',$cf,'}',$cc,$82,$03
	dc.b	$bf,'5',$c0,$f8,$00,$00,$ff,$ff
	dc.b	$b9,'C',$7f,$c7,$01,$c0,$fe,$1f
	dc.b	$be,$8e,$c1,$f0,$00,$00,$ff,$ff
	dc.b	$e6,$80,$18,$80,$00,$80,$ff,$00
	dc.b	$00,$a8,$03,$1e,$00,$0e,$0f,$f0
	dc.b	',',$ee,'?',$10,' ',$e0,$1f,$1f
	dc.b	$06,$f8,$86,$07,$86,$ff,$01,$00
	dc.b	'&',$ff,'?',$00,' ',$ff,$1f,$00
	dc.b	$ff,$ac,$00,'r',$ff,$82,$00,'|'
	dc.b	$7f,$8f,$00,'p',$0f,$f3,'p',$0c
	dc.b	$ed,$f9,$1e,$07,$fc,$ff,$03,$00
	dcb.w	4
	dc.b	$00,$10,$00,$1f,$00,$10,$00,$0f
	dc.b	$ff,$8b,$81,$8f,'y',$88,$86,$07
	dc.b	';',$81,$c4,'!8!',$c7,$c0
	dc.b	$be,$16,$81,$df,$bf,$d0,'@',$0f
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$fe,$1f,$01,$c0,$ff,$c3,$00,$1c
	dc.b	$e3,$fb,$1c,$07,$fc,$ff,$03,$00
	dc.b	'~I',$81,$cf,'?',$c8,$c0,$07
	dc.b	$bf,$ff,$c0,$00,'?',$ff,$c0,$00
	dc.b	$fe,'S',$01,$d0,$ff,$d3,$00,$0c
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$fd,$80,$01,$c0,$f9,$c0,$06,$00
	dc.b	$09,$f0,$08,$0e,$09,$fe,$06,$00
	dc.b	'/',$ff,'\',$00,'C',$f8,'<',$07
	dc.b	$83,$f8,$c3,$07,$c3,$ff,$04,$00
	dc.b	$13,$ff,'<',$00,$03,$ff,'<',$00
	dc.b	$ff,$fa,$00,$02,$ff,$e2,$00,$1c
	dc.b	$7f,$87,$00,'x',$0f,$f3,'p',$0c
	dc.b	$ee,$f9,$1f,$07,$fc,$ff,$03,$00
	dcb.w	4
	dc.b	$00,'=',$00,'"',$00,'!',$00,$1e
	dc.b	$ff,$0b,$03,$d7,$ff,$d0,$00,$0f
	dc.b	$ff,$e0,$00,'0',$fe,'0',$01,$c1
	dc.b	$fe,$19,$c1,$c6,$ff,$c1,$00,$1e
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$fe,$df,$01,$c0,$ff,$c3,$00,$1c
	dc.b	$e1,$fb,$1e,$07,$fc,$ff,$03,$00
	dc.b	$be,'D',$c1,$df,'?',$d0,$c0,$0f
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$fe,$db,$01,$98,$ff,$9b,$00,'D'
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$c0,$03,$c0,$ff,$c0,$00,$00
	dc.b	$0d,$f0,$0c,$0e,$0d,$fe,$02,$00
	dc.b	'g',$fe,'X',$00,'G',$fc,'8',$03
	dc.b	'E',$f9,'a',$07,'a',$ff,$86,$00
	dc.b	'_',$ff,'x',$00,'G',$ff,'8',$00
	dc.b	$ff,$f7,$00,$07,$ff,$f7,$00,$08
	dc.b	'_',$93,' |',$0f,$f3,'p',$0c
	dc.b	$ff,$fb,$1f,$07,$fc,$ff,$03,$00
	dcb.w	4
	dc.b	$00,$7f,$00,'@',$00,'C',$00,'<'
	dc.b	$fe,$19,$01,$d6,$ff,$d1,$00,$0e
	dc.b	$ff,$91,$00,$18,$ff,$18,$00,$e1
	dc.b	'~_A',$c0,$7f,$c3,$80,$1c
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$17,$01,$08,$ff,$03,$00,$dc
	dc.b	$e4,$ff,$1f,$07,$fc,$ff,$03,$00
	dc.b	$fe,$d7,$c1,$de,'?',$d1,$c0,$0e
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,'_',$01,$1c,$ff,$1f,$00,$c0
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$00,$01,$c0,$ff,$c0,$00,$00
	dc.b	$0f,$f2,$0e,$0e,$0f,$fe,$00,$00
	dc.b	'w',$fe,$08,$00,$07,$fe,'x',$01
	dc.b	'd',$fb,'p',$07,'p',$ff,$87,$00
	dc.b	'g',$ff,$18,$00,$07,$ff,'x',$00
	dc.b	$ff,$fd,$00,$0f,$ff,$ff,$00,$00
	dc.b	$0f,$93,'p|',$0f,$f3,'p',$0c
	dc.b	$f5,$fb,$17,$07,$f4,$ff,$0b,$00
	dc.b	$00,$10,$00,$10,$00,$10,$00,$10
	dc.b	$00,$bf,$00,$c0,$00,$87,$00,'x'
	dc.b	$fe,']',$01,$c2,$ff,$c1,$00,$1e
	dc.b	$ff,$99,$00,$1c,$ff,$9c,$00,'a'
	dc.b	'>',$cf,$01,$c0,'?',$c3,$c0,$1c
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$fe,$03,$00,$1c,$fe,$03,$01,$dc
	dc.b	$e4,$fd,$1f,$05,$fc,$fd,$03,$02
	dc.b	'~',$d9,$c1,$d6,'?',$d1,$c0,$0e
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$fe,'S',$00,'P',$fe,'S',$01,$8c
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$fe,$00,$01,$c0,$ff,$c0,$00,$00
	dc.b	$03,$f6,$02,$0e,$03,$fe,$0c,$00
	dc.b	$10,$00,$00,$00,$0f,$ff,'p',$00
	dc.b	'r',$06,'|',$06,'x',$fe,$87,$01
	dc.b	'0',$00,$00,$00,$0f,$ff,'p',$00
	dc.b	$00,$01,$00,$07,$ff,$ff,$00,$00
	dc.b	$00,$18,'p|',$0f,$f3,'p',$0c
	dc.b	$14,$03,$17,$07,$f4,$ff,$0b,$00
	dcb.w	4
	dc.b	$01,$00,$01,$f0,$01,$0f,$00,$f0
	dc.b	$00,$c4,$01,$c0,$ff,$c3,$00,$1c
	dc.b	$00,$1c,$00,$1f,$ff,$de,$00,'!'
	dc.b	$81,$90,$01,$90,'?',$93,$c0,'L'
	dcb.w	2
	dc.b	$ff,$ff,$00,$00,$01,$c0,$01,$dc
	dc.b	$ff,$c3,$00,$1c,$06,$05,$1f,$05
	dc.b	$fc,$fd,$03,$02,$00,$dc,$c1,$d0
	dc.b	'?',$d3,$c0,$0c,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$01,$c0,$01,$c0
	dc.b	$ff,$c3,$00,$1c,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$01,$c0
	dc.b	$ff,$c0,$00,$00,$00,$0c,$00,$0c
	dc.b	$01,$fc,$0e,$02,$00,$00,$00,$00
	dc.b	$0f,$ff,'p',$00,'i',$04,'n',$04
	dc.b	$e8,$fc,$17,$03,'0',$00,$00,'?'
	dc.b	$0f,$ff,'p',$00,$06,$00,$fe,$06
	dc.b	$ff,$fe,$00,$01,' <p|'
	dc.b	$0f,$f3,'p',$0c,$15,$03,$17,$07
	dc.b	$f4,$ff,$0b,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$03,$e0,$03,$e0,$02,$1f,$01,$e0
	dc.b	$01,$c0,$01,$c0,$ff,$c3,$00,$1c
	dc.b	$00,$1a,$00,$1b,$ff,$fa,$00,$05
	dc.b	'A',$18,$81,$18,'?',$1b,$c0,$c4
	dc.b	$08,$07,$0f,$ff,$ef,$ff,$10,$00
	dc.b	$81,$c8,$ff,$dc,$ff,$c3,$00,$1c
	dc.b	$0f,$05,$1f,$05,$fc,$fd,$03,$02
	dc.b	'@',$cc,$c1,$c0,'?',$c3,$c0,$1c
	dc.b	$00,$00,$0f,$ff,$ff,$ff,$00,$00
	dc.b	$00,'\',$ff,$df,$ff,$df,$00,$00
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$00,$00
	dc.b	'@',$10,$c1,$d0,$ff,$d0,$00,$10
	dc.b	$0a,$02,$04,$0e,$01,$fe,$0e,$00
	dc.b	'`',$00,$00,$00,$0f,$ff,'p',$00
	dc.b	'!',$04,'"',$04,$e0,$fc,$1f,$03
	dc.b	$10,$00,$00,$7f,$0f,$ff,'p',$00
	dc.b	'|',$02,$fd,$06,$fc,$fe,$03,$01
	dc.b	'p<p|',$0f,$f3,'p',$0c
	dc.b	$17,$03,$17,$07,$f4,$ff,$0b,$00
	dc.b	$00,'@',$00,'@',$00,'@',$00,'@'
	dc.b	$07,$c0,$07,$c0,$04,'?',$03,$c0
	dc.b	$01,'X',$c1,'@',$ff,'C',$00,$9c
	dc.b	$00,$08,$00,$08,$ff,$f8,$00,$07
	dc.b	'A',$10,$81,$10,'?',$13,$c0,$cc
	dc.b	$19,$9c,$07,$e0,$e0,$00,$1f,$ff
	dc.b	$1d,$dc,$02,$dc,$00,$c3,$ff,$1c
	dc.b	$0f,$05,$1f,$05,$fc,$fd,$03,$02
	dc.b	$c0,$c4,$c1,$c0,'?',$c3,$c0,$1c
	dc.b	$07,$95,$0f,$e3,$e0,$00,$1f,$ff
	dc.b	$e4,'\',$f9,$cc,$01,$cc,$fe,$13
	dc.b	$f1,$ad,$0f,$c3,$00,$00,$ff,$ff
	dc.b	'@',$04,$81,$c4,'?',$c4,$c0,$04
	dc.b	$0e,$00,$00,$0e,$01,$fe,$0e,$00
	dc.b	'p',$00,$00,$00,$0f,$9f,'p`'
	dc.b	$04,$04,$07,$04,$e4,$fc,$1b,$03
	dc.b	$10,$01,$00,$7f,$0f,$ff,'p',$00
	dc.b	$89,$04,$8b,$04,$88,$fc,'w',$03
	dc.b	'php|',$0f,$f3,'p',$0c
	dc.b	$17,$03,$17,$07,$f4,$ff,$0b,$00
	dcb.w	4
	dc.b	$0f,$81,$0f,$81,$08,$7f,$07,$80
	dc.b	$c0,$1c,$80,$00,$be,$03,'A',$dc
	dc.b	$00,$01,$00,$01,$e7,$f9,$18,$06
	dc.b	$01,$04,$c1,$00,'?',$03,$c0,$dc
	dcb.w	2
	dc.b	$ff,$ff,$00,$00,$03,$1c,$07,$9c
	dc.b	$f8,$03,$07,$9c,$1a,$05,$1f,$05
	dc.b	$fc,$fd,$03,$02,$c0,$c4,$c1,$c0
	dc.b	'?',$c3,$c0,$1c,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,'X',$01,$c0
	dc.b	$ff,$c3,$00,$1c,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$01,$c0
	dc.b	$ff,$c0,$00,$00,$0e,$00,$00,$0e
	dc.b	$01,$fe,$0e,$00,'_',$cf,'/',$cf
	dc.b	$00,'@p0',$f4,$fc,$f5,$fc
	dc.b	$04,$04,$0b,$03,'O',$80,$0f,$f0
	dc.b	$00,'pp',$00,$03,$f9,$07,$f8
	dc.b	$00,$00,$07,$07,'/',$e3,$7f,$ff
	dc.b	$00,'pp',$0c,$ff,$fb,$ff,$ff
	dc.b	$1c,$07,$03,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$17,$fd,$1f,$ff,$10,$03,$0f,$00
	dc.b	'~',$97,'>',$0b,$00,$00,$c1,$dc
	dc.b	$f3,$fd,$f3,$fd,$10,$01,$0c,$02
	dc.b	'?',$1f,$7f,$03,$01,$00,$c0,$dc
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$fe,$cb,$ff,$1f,$00,$00,$03,$dc
	dc.b	$f8,$ff,$ff,$ff,$1c,$07,$03,$00
	dc.b	$fe,$d3,$ff,$c3,$01,$c0,$c0,$1c
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$fe,$cf,$ff,$d3,$01,$c0,$00,$1c
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$fe,$00,$ff,$c0,$01,$c0,$00,$00
	dc.b	$0d,$e0,$03,$fe,$03,$fe,$0c,$00
	dc.b	$0f,$c7,$7f,$c7,$00,'@p8'
	dc.b	$fe,$fc,$ff,$fc,$06,$04,$01,$03
	dc.b	'/',$80,'O',$f0,$00,'pp',$00
	dc.b	$03,$fe,$07,$f9,$00,$00,$07,$07
	dc.b	$0f,$c7,$7f,$fb,$00,'pp',$0c
	dc.b	$ed,$fb,$ff,$ff,$1c,$07,$03,$00
	dcb.w	4
	dc.b	$27,$f8,'?',$ff,' ',$07,$1e,$00
	dc.b	'>',$83,$fe,$1f,$00,$00,$c1,$dc
	dc.b	$f1,$ff,$f1,$ff,$10,$01,$0e,$00
	dc.b	$bf,$13,$ff,$0f,$81,$00,'@',$dc
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$83,$fe,$1f,$00,$00,$01,$dc
	dc.b	$f1,$fb,$fe,$ff,$1c,$07,$03,$00
	dc.b	'~',$cb,$ff,$d3,$01,$c0,$c0,$1c
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$87,$ff,$9b,$01,$80,$00,'\'
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$00,$ff,$c0,$01,$c0,$00,$00
	dc.b	$0b,'0',$07,'>',$07,'>',$08,$c0
	dc.b	'/',$e7,$7f,$e3,$00,'`p',$1c
	dc.b	$fe,$fe,$fe,$fe,$02,$06,$01,$01
	dc.b	$1f,$b0,'o',$f0,$00,'pp',$00
	dc.b	$05,$f8,$03,$ff,$00,$00,$07,$07
	dc.b	'_',$9f,'/',$f3,$00,'pp',$0c
	dc.b	$e4,$fb,$ff,$ff,$1c,$07,$03,$00
	dcb.w	4
	dc.b	'g',$f2,'_',$ff,'@',$0e,'<',$01
	dc.b	$be,$0b,'~',$1f,$00,$00,$c1,$dc
	dc.b	$f9,$ff,$f8,$ff,$18,$00,$07,$00
	dc.b	$bf,$95,$bf,$99,$81,$90,'@N'
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$fe,'W',$fe,'K',$00,'@',$01,$9c
	dc.b	$e7,$f9,$fc,$ff,$1c,$07,$03,$00
	dc.b	'>',$c7,$ff,$db,$01,$c0,$c0,$1c
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$fe,$8b,$ff,$9f,$01,$80,$00,'\'
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$c0,$ff,$c0,$03,$c0,$00,$00
	dc.b	$06,$18,$0e,$1e,$0e,$1e,$01,$e0
	dc.b	$7f,$e7,$7f,$e1,$00,'`p',$1e
	dc.b	$ff,$ff,$ff,$ff,$00,$07,$00,$00
	dc.b	'o',$e1,$7f,$e7,$00,'`p',$1f
	dc.b	'6',$f9,$c1,$fe,$00,$00,$ff,$07
	dc.b	$7f,$bf,$0f,$f3,$00,'pp',$0c
	dc.b	$e0,$f9,$ff,$ff,$1c,$07,$03,$00
	dcb.w	4
	dc.b	$e7,$e1,$9f,$fa,$80,$18,'x',$07
	dc.b	$ff,'_?_',$01,'@',$c0,$9c
	dc.b	$f9,$ff,$f8,$7f,$18,$00,$07,$80
	dc.b	$ff,$cb,$ff,$c3,$01,$c3,$00,$0c
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$df,$ff,$c3,$01,$c0,$00,$1c
	dc.b	$ef,$f8,$fc,$ff,$1c,$07,$03,$00
	dc.b	'>[',$ff,$df,$01,$c0,$c0,$1c
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$fe,$1b,$ff,$9f,$01,$80,$00,'\'
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$fd,$80,$fc,$00,$04,$00,$03,$80
	dc.b	$05,$12,$0e,$0e,$00,$02,$0f,$fc
	dc.b	'p6',$7f,$f1,$00,'pp',$0f
	dc.b	$00,$07,$ff,$ff,$00,$07,$00,$00
	dc.b	'pK',$7f,$c7,$00,'@p?'
	dc.b	$b2,$06,$c1,$f8,$00,$00,$ff,$07
	dc.b	'pd',$0f,$e3,$00,'`p',$1c
	dc.b	$1b,$01,$f8,$ff,$18,$07,$07,$00
	dc.b	$00,$01,$00,$01,$00,$01,$00,$00
	dc.b	'p',$00,$8f,$ff,$00,$00,$f0,$00
	dc.b	$01,$dc,$ff,$df,$01,$c0,$00,$1c
	dc.b	$0d,$80,$fc,$7f,$1c,$00,$03,$c0
	dc.b	$01,$db,$ff,$cd,$01,$c1,$00,$1e
	dc.b	$98,$03,$9f,$ff,$9f,$ff,'`',$00
	dc.b	$80,$1c,$bf,$c3,$81,$c0,'@',$1c
	dc.b	$19,$06,$f8,$fe,$18,$06,$07,$01
	dc.b	$c0,'\?',$df,$01,$c0,$c0,$1c
	dc.b	$00,$00,$ff,$ff,$1f,$ff,$00,$00
	dc.b	$00,'X',$ff,$9f,$ff,$80,$00,'\'
	dc.b	$03,$87,$ff,$80,$1f,$80,$00,$7f
	dc.b	$03,$c0,$fc,$00,$00,$00,$03,$c0
	dc.b	$02,$b4,$07,$0e,$00,$06,$0f,$f8
	dc.b	' <',$7f,$fb,$00,'xp',$07
	dc.b	$00,$02,$ff,$ff,$00,$07,$80,$00
	dc.b	'`',$1f,$7f,$c7,$00,$00,'p?'
	dc.b	$88,$02,$f1,$fe,$00,$06,$fe,$01
	dc.b	' ',$00,$0f,$c7,$00,$00,'p8'
	dc.b	$00,$00,$f1,$ff,$00,$07,$0e,$00
	dc.b	$00,$02,$00,$03,$00,$02,$00,$01
	dc.b	'`',$00,$9f,$ff,$00,$00,$e0,$00
	dc.b	$00,$c8,$ff,$df,$01,$c0,$00,$1c
	dc.b	$0f,$00,$fe,$ff,$1e,$00,$01,$e0
	dc.b	$00,$9e,$ff,$c7,$01,$c0,$00,$1f
	dc.b	'36',$c0,$f8,$00,$00,$ff,$ff
	dc.b	$00,$08,'?',$c3,$01,$c0,$c0,$1c
	dc.b	$00,$00,$f1,$fc,$00,$00,$0e,$03
	dc.b	$00,$18,$7f,$df,$01,$c0,$80,$1c
	dc.b	$04,$e7,$f3,$f8,$00,$00,$0f,$ff
	dc.b	$1c,$c8,$e1,$9f,$01,$80,$fe,'\'
	dc.b	$00,$e3,$ff,$e0,$1f,$e0,$00,$1f
	dc.b	$00,'@',$fe,$00,$00,$00,$81,$c0
	dc.b	$00,$a8,$03,$1e,$00,$0e,$0f,$f0
	dc.b	$00,$14,$7f,$f7,$00,'tp',$03
	dc.b	'@',$00,$bf,$ff,$00,$07,$c0,$00
	dc.b	$00,$00,$7f,$ff,$00,$00,'p',$00
	dc.b	$00,$01,$ff,$ff,$00,$07,$00,$00
	dc.b	$00,$00,$0f,$ff,$00,$00,'p',$00
	dc.b	$00,$04,$ff,$ff,$00,$07,$00,$00
	dc.b	$00,$04,$00,$07,$00,$04,$00,$03
	dc.b	'@',$00,$bf,$ff,$00,$00,$c0,$00
	dc.b	$00,'@',$ff,$df,$01,$c0,$00,$1c
	dc.b	$05,$10,$fd,$ef,$1d,$00,$00,$f0
	dc.b	$00,$1c,$ff,$c3,$01,$c0,$00,$1c
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$01,$00,$ff,$c3,$01,$c0,$00,$1c
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$01,$00,$ff,$df,$01,$c0,$00,$1c
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$01,$c0,$ff,$9f,$01,$80,$00,'\'
	dc.b	$10,'2',$ff,$f1,$1f,$f0,$00,$0f
	dc.b	$01,$00,$ff,$00,$01,$00,$c0,$c0
	dc.b	$08,$00,$09,$fe,$08,$0e,$06,$00
	dc.b	$00,$12,$7f,$f3,$00,'rp',$01
	dc.b	$e0,$00,$1f,$ff,$00,$0f,$e0,$00
	dc.b	'X',$00,$27,$ff,$00,$00,'x',$00
	dc.b	$00,$01,$ff,$ff,$00,$0f,$00,$00
	dc.b	$00,$00,$07,$ff,$00,$00,'x',$00
	dc.b	$00,$0e,$ff,$ff,$00,$0f,$00,$00
	dc.b	$00,$0e,$00,$09,$00,$08,$00,$07
	dc.b	$01,$80,$ff,$80,$01,$80,$80,$7f
	dc.b	'@@',$7f,$df,'A',$c0,$80,$1c
	dc.b	$04,$b8,$fc,$c7,$1c,$80,$00,'x'
	dc.b	$00,$04,$ff,$db,$03,$c0,$00,$1c
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$01,$80,$ff,$c1,$01,$c0,$00,$1e
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$03,$96,$ff,$c9,$03,$c0,$00,$1e
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$01,$94,$ff,$8b,$01,$80,$00,'\'
	dc.b	$18,$01,$fc,$00,$1c,$00,$00,$01
	dc.b	'A',$80,$ff,$80,$01,$80,$c0,'@'
	dc.b	$0c,$00,$0d,$fe,$0c,$0e,$02,$00
	dc.b	'P',$11,'/',$f1,$00,'qp',$00
	dc.b	$f0,$09,$0f,$ff,$00,$0f,$f0,$00
	dc.b	'p',$00,'G',$ff,'@',$00,'8',$00
	dc.b	$00,$09,$ff,$ff,$00,$0f,$00,$00
	dc.b	'X',$00,'G',$ff,'@',$00,'8',$00
	dc.b	$00,$0e,$ff,$fe,$00,$0e,$00,$00
	dc.b	$00,$13,$00,$1c,$00,$10,$00,$0f
	dc.b	$00,$e1,$ff,$e1,$03,$e1,$00,$1e
	dc.b	$c0,$14,$bf,$cb,$81,$c0,'@',$1c
	dc.b	$04,'|',$fc,'C',$1c,'@',$00,'<'
	dc.b	$02,'P',$ff,$df,$03,$c0,$00,$1c
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$01,$d6,$ff,$d1,$01,$d0,$00,$0e
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$03,$9c,$ff,$91,$03,$90,$00,$0e
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$01,$18,$ff,$87,$01,$80,$00,'\'
	dc.b	$0c,$01,$ec,$01,$0c,$00,$10,$01
	dc.b	$c0,$c0,$ff,$c0,$01,$c0,$c0,$00
	dc.b	$06,$02,$07,$fe,$06,$0e,$08,$00
	dc.b	'p',$00,$0f,$f0,$00,'pp',$00
	dc.b	$e0,$0d,$87,$ef,$80,$0f,'x',$10
	dc.b	'$',$00,'C',$ff,'@',$00,'<',$00
	dc.b	$00,$0c,$ff,$ee,$00,$0e,$00,$10
	dc.b	'0',$00,$0f,$ff,$00,$00,'<',$00
	dc.b	$80,$12,$ff,$e2,$80,$02,$00,$1c
	dc.b	$00,$10,$00,$0f,$00,$00,$00,$1e
	dc.b	$00,'7',$ff,$f7,$07,$f7,$00,$08
	dc.b	$80,$1c,$7f,$c3,$01,$c0,$c0,$1c
	dc.b	$00,'8',$fc,'!',$1c,' ',$00,$1e
	dc.b	$03,'\',$fb,$df,$03,$c0,$04,$1c
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$cc,$fc,$c3,$00,$c0,$03,$0f
	dc.b	$00,' ',$ff,$ff,$00,' ',$00,$00
	dc.b	$04,$89,$f8,$90,$00,$90,$07,$0f
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$14,$ff,$8f,$01,$80,$00,'\'
	dc.b	$04,$01,$e4,$01,$04,$00,$18,$01
	dc.b	$80,'@',$ff,$c0,$01,$c0,$c0,$00
	dc.b	$02,$06,$03,$fe,$02,$0e,$0c,$00
	dc.b	'p',$00,$0f,$f0,$00,'pp',$00
	dc.b	'fdG',$e6,'Ff8',$18
	dc.b	')',$00,'&',$ff,' ',$00,$1f,$00
	dc.b	$00,'d',$ff,$e6,$00,'f',$00,$18
	dc.b	'!',$02,'>',$ff,' ',$03,$1f,$00
	dc.b	$c0,',',$bf,$92,$80,$02,'`|'
	dc.b	$00,$0c,$00,$03,$00,$00,$00,$1c
	dc.b	$00,$01,$ff,$00,$0f,$00,$00,$01
	dc.b	'@',$1c,$ff,$c3,$01,$c0,$c0,$1c
	dc.b	$00,$19,$fc,$11,$1c,$11,$00,$0e
	dc.b	$99,$18,$f9,$9f,$99,$80,$06,$1c
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$02,$08,$f8,'O',$00,'H',$07,$87
	dc.b	'@',$b0,$bf,$ef,$00,$e0,$c0,$18
	dc.b	$0b,$0a,$e4,$89,$00,$88,$1f,$07
	dc.b	'@',$00,$bf,$ff,$00,$00,$c0,$00
	dc.b	$00,$08,$ff,$9f,$01,$80,$00,'\'
	dc.b	$04,$01,$e4,$01,$04,$00,$18,$01
	dc.b	'@',$00,$bf,$c0,$01,$c0,$c0,$00
	dc.b	$08,$00,$01,$fe,$00,$0e,$0e,$00
	dc.b	'o',$00,$1f,$f0,$1f,$f0,'`',$00
	dc.b	',r/',$f6,'/',$f6,$10,$08
	dc.b	$12,'p<',$7f,'0',$7f,$0f,$80
	dc.b	$f0,'p',$ff,$f4,$ff,$f4,$00,$08
	dc.b	$11,$ae,$1e,$0f,$10,$0f,$0f,$f0
	dc.b	$db,'$',$bc,$1c,$80,$04,$7f,$f8
	dc.b	$00,$11,$00,$17,$00,$17,$00,$08
	dc.b	$80,$00,$9e,$01,$9e,$00,'`',$01
	dc.b	$fc,$1b,'}',$c7,'}',$c7,$82,$18
	dc.b	$c0,$0b,$fc,$0b,$fc,$0b,$00,$04
	dc.b	$1c,$95,$fd,$9f,$fd,$87,$02,$18
	dc.b	'7<?',$00,'?',$00,$c0,$ff
	dc.b	$c7,$84,$c0,$87,$c0,$84,'?',$03
	dc.b	'k',$b6,$83,$ef,$03,$e0,$fc,$1f
	dc.b	$c9,$04,$07,$0f,$01,$0c,$fe,$03
	dc.b	$84,'h',$1f,$ef,$1f,$ef,$e0,$10
	dc.b	$c6,$10,$c7,$9b,$c7,$83,'8\'
	dc.b	$c0,$00,$f0,$01,$f0,$00,$0c,$01
	dc.b	$fc,$00,'}',$c0,'}',$c0,$82,$00
	dc.b	$0d,$e0,$03,$fe,$03,$fe,$0c,$00
	dc.b	'Y',$80,'9',$f0,'9',$f0,'F',$00
	dc.b	$08,'t',$1f,$fc,$1f,$fc,$00,$00
	dc.b	$0c,$9f,$18,$df,$18,$df,$07,' '
	dc.b	$9c,'p',$9f,$f8,$9f,$f8,'`',$00
	dc.b	$0f,$27,$08,$07,$08,$07,$07,$f8
	dc.b	$19,$98,'~',$08,$00,$08,$ff,$f0
	dc.b	$00,$00,$00,$0f,$00,$0f,$00,$10
	dc.b	$c0,$01,$cc,$00,$cc,$00,'0',$01
	dc.b	$8e,$16,$fe,$ce,$fe,$ce,$01,$11
	dc.b	'`',$02,'|',$07,'|',$07,$80,$00
	dc.b	$1d,$0a,$ff,$1e,$ff,$0e,$00,$11
	dc.b	'a',$93,$7f,$83,$7f,$83,$80,'|'
	dc.b	$f2,$03,$f0,$82,$f0,$82,$0f,$01
	dc.b	$c9,$c6,$01,$df,$01,$c0,$fe,'?'
	dc.b	'f',$03,$82,$06,$02,$06,$fc,$01
	dc.b	',',$cc,'?',$cf,'?',$cf,$c0,'0'
	dc.b	$e3,$01,$e3,$97,$e3,$87,$1c,'X'
	dc.b	$e0,$01,$f8,$00,$f8,$00,$04,$01
	dc.b	$8e,$00,$fe,$c0,$fe,$c0,$01,$00
	dc.b	$0b,'0',$07,'>',$07,'>',$08,$c0
	dc.b	'0',$c0,'p',$f0,'p',$f0,$0f,$00
	dc.b	$00,' ',$07,$f0,$07,$f0,$00,$00
	dc.b	$01,'G',$03,$c7,$03,$c7,$00,'8'
	dc.b	$06,$00,$07,$e0,$07,$e0,$f8,$00
	dc.b	$03,'6',$02,$07,$02,$07,$01,$f8
	dc.b	$11,$a0,'^ @ ?',$c0
	dc.b	$00,$10,$00,$1f,$00,$1f,$00,$00
	dc.b	'(',$00,$f8,$00,$f8,$00,$00,$00
	dc.b	$00,$0c,$ff,$dc,$ff,$dc,$00,$03
	dc.b	'0',$00,'<',$01,'<',$01,$c0,$00
	dc.b	$08,$14,$fc,$1c,$fc,$1c,$00,$03
	dc.b	$c0,$86,$ff,$87,$ff,$87,$00,'x'
	dc.b	$1a,$00,$fb,$00,$fb,$00,$04,$00
	dc.b	$cd,$84,$81,$d7,$81,$d0,'~',$0f
	dc.b	'h',$00,$88,$00,$08,$00,$f0,$00
	dc.b	']',$8c,$ff,$8f,$ff,$8f,$00,'p'
	dc.b	$f1,$82,$f1,$8e,$f1,$8e,$0e,'Q'
	dc.b	'0',$01,'<',$01,'<',$01,$c0,$00
	dc.b	$06,$00,$fe,'@',$fe,'@',$01,$80
	dc.b	$06,$18,$0e,$1e,$0e,$1e,$01,$e0
	dcb.w	232
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dc.b	$00,$00,$00,'@',$00,'@',$00,$00
	dcb.w	9
	dc.b	' ',$00,' ',$00,' ',$00,$00,$00
	dcb.w	39
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dcb.w	20
	dc.b	$00,'@',$00,'@',$00,'@',$00,$00
	dcb.w	8
	dc.b	$10,$00,'P',$00,'p',$00,'p',$00
	dcb.w	48
	dc.b	$1e,$fa,$1e,$fa,$00,$00,$1e,$fa
	dc.b	' ',$00,' ',$00,$00,$00,' ',$00
	dcb.w	11
	dc.b	$00,'@',$00,$00,$00,$00,$00,$00
	dcb.w	5
	dc.b	$10,$00,$90,$00,$f0,$00,$f0,$00
	dc.b	$00,$00,' ',$00,' ',$00,' ',$00
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dcb.w	40
	dc.b	'  ',$81,$00,$00,' '
	dc.b	'@',$00,'@',$00,$00,$00,'@',$00
	dcb.w	8
	dc.b	$00,'@',$00,$00,$00,$00,$00,'@'
	dcb.w	8
	dc.b	'0',$00,$90,$00,$f0,$00,$f0,$00
	dc.b	' ',$00,'`',$00,'`',$00,'`',$00
	dcb.w	28
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dcb.w	13
	dc.b	'&',$f0,$00,$00,'&',$f0,$00,$00
	dc.b	$80,$00,$00,$00,$80,$00,$00,$00
	dcb.w	8
	dc.b	$00,'@',$00,$00,$00,'@',$10,$00
	dc.b	$10,$00,$10,$00,$10,$00,$00,$00
	dcb.w	3
	dc.b	'8',$00,$88,$00,$f8,$00,$f8,$00
	dc.b	' ',$00,$e0,$00,$e0,$00,$e0,$00
	dcb.w	45
	dc.b	'"',$81,$00,$00,'"',$81,$00,$00
	dc.b	'@',$00,$00,$00,'@',$00,$00,$08
	dc.b	$00,$08,$00,$08,$00,$08,$00,$00
	dcb.w	3
	dc.b	$00,'@',$00,'@',$00,$00,$00,'@'
	dcb.w	8
	dc.b	'8',$00,$88,$00,$f8,$00,$f8,$00
	dc.b	' ',$00,$a0,$00,$e0,$00,$e0,$00
	dcb.w	44
	dc.b	$1e,$82,$00,$00,$00,$00,$1e,$82
	dc.b	' ',$00,$00,$00,$00,$00,' ',$00
	dcb.w	8
	dc.b	$0a,$ea,$19,$f3,$18,'C',$07,$fc
	dcb.w	8
	dc.b	'8',$00,$88,$01,$f8,$01,$f8,$01
	dc.b	'`',$00,$a0,$00,$e0,$00,$e0,$00
	dcb.w	60
	dc.b	$00,'@',$00,'@',$00,'@',$00,'@'
	dcb.w	8
	dc.b	'8',$00,$88,$03,$f8,$03,$f8,$03
	dc.b	'`',$00,' ',$00,$e0,$00,$e0,$00
	dcb.w	12
	dc.b	'9',$09,'~',$07,$00,$00,$7f,$ff
	dc.b	$ff,$f0,$f0,$ce,'0',$c0,$cf,'?'
	dc.b	's',$c0,$0f,$c0,$00,$00,$7f,$f0
	dc.b	$07,';',$03,$c3,$00,$03,$07,$fc
	dc.b	$03,$f7,$06,$0f,$06,$00,$01,$ff
	dc.b	$b3,'9',$c0,$ff,$00,$00,$ff,$ff
	dcb.w	8
	dc.b	$1c,$8b,$00,$00,$00,$00,$1c,$8b
	dc.b	$c0,'<',$00,$00,$00,$00,$c0,'<'
	dc.b	$88,$1f,$00,$00,$00,$00,$88,$1f
	dc.b	$fd,$e3,$00,$00,$00,$00,$fd,$e3
	dc.b	$91,'@',$00,'@',$00,$00,$91,'@'
	dcb.w	5
	dc.b	$00,$01,$00,$01,$00,$01,'x',$00
	dc.b	$08,$07,$f8,$07,$f8,$07,$c0,$00
	dc.b	'@',$00,$c0,$00,$c0,$00,$00,$00
	dcb.w	11
	dc.b	$1d,$99,'>',$07,$00,$00,$7f,$ff
	dc.b	$b8,$c0,$c0,'=',$00,$01,$ff,$fe
	dc.b	'y',$a0,'G',$e0,'@ ?',$d0
	dc.b	$05,$b2,$03,$c3,$00,$03,$07,$fc
	dc.b	$0b,$fb,$1e,$07,$18,$00,$07,$ff
	dc.b	$93,'s',$e0,$ff,$00,$03,$ff,$fc
	dcb.w	11
	dc.b	'"',$ca,$00,$00,$00,$00,$00,$00
	dc.b	' "',$00,$00,$00,$00,$00,$00
	dc.b	$88,$10,$00,$00,$00,$00,$00,$00
	dc.b	$11,$11,$00,$00,$00,'@',$00,$00
	dc.b	$0a,'@',$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$01,$00,$01,$00,$01,'|',$00
	dc.b	$04,$06,$fc,$07,$fc,$07,$c0,$00
	dc.b	'@',$00,$c0,$00,$c0,$00,$00,$00
	dcb.w	3
	dc.b	$02,$00,$02,$00,$02,$00,$02,$00
	dcb.w	4
	dc.b	$0e,$fa,$1f,$07,$00,$00,$7f,$ff
	dc.b	';',$81,$c0,'{',$00,$03,$ff,$fc
	dc.b	'}Pc',$f0,'`p',$1f,$80
	dc.b	$06,$a4,$01,$c7,$00,$07,$07,$f8
	dc.b	$16,$fc,'?',$03,'0',$00,$0f,$ff
	dc.b	$d6,$e5,$e1,$ff,$00,$07,$ff,$f8
	dcb.w	11
	dc.b	'>',$aa,$00,$00,$00,$00,$00,$00
	dc.b	' <',$00,$00,$00,$00,$00,$00
	dc.b	'P',$1f,$00,$00,$00,$00,$00,$00
	dc.b	$11,$e1,$00,'@',$00,$00,$00,$00
	dc.b	$04,'@',$01,$00,$01,$00,$01,$00
	dc.b	$01,$00,$00,$00,$00,$01,$00,$01
	dc.b	$00,$01,'|',$01,$04,$0e,$fc,$0f
	dc.b	$fc,$0f,$c0,$00,'@',$00,$c0,$00
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dcb.w	9
	dc.b	'O',$ff,'@',$00,'O',$ff,'0',$00
	dc.b	$ff,$fa,$00,$06,$ff,$fe,$00,$01
	dc.b	'?',$a0,'0`?',$e0,'@',$10
	dc.b	$03,$f8,$04,$07,$00,$ff,$07,$00
	dc.b	'&',$ff,'?',$00,' ',$ff,$1f,$00
	dc.b	$ff,$f9,$00,$07,$ff,$ff,$00,$00
	dcb.w	8
	dc.b	'"š"š"',$9a,$00,$00
	dc.b	' " " "',$00,$00
	dc.b	' ',$01,' ',$01,' ',$01,$00,$00
	dc.b	$11,'!',$11,'!',$11,'!',$00,$00
	dc.b	$0a,$00,$0a,$00,$0a,$00,$00,'@'
	dc.b	$00,$02,$00,$02,$00,$02,$00,$02
	dc.b	$00,$00,$00,$01,$00,$01,$00,$01
	dc.b	'|',$01,$04,$0c,$fc,$0f,$fc,$0f
	dc.b	$c0,$00,'@',$00,$c0,$00,$c0,$00
	dcb.w	12
	dc.b	'o',$ff,'`',$00,'o',$ff,$10,$00
	dc.b	$ff,$fe,$00,$06,$ff,$fe,$00,$01
	dc.b	$1f,$c0,$10,'@',$1f,$c0,'`0'
	dc.b	$01,$f8,$06,$07,$00,$ff,$07,$00
	dc.b	$13,$ff,'|',$00,'C',$ff,'<',$00
	dc.b	$ff,$fb,$00,$06,$ff,$fe,$00,$01
	dcb.w	8
	dc.b	'"',$8b,'"',$8b,'"',$8b,$00,$00
	dc.b	$c0,'<',$c0,'<',$c0,'<',$00,$00
	dc.b	' ',$1f,' ',$1f,' ',$1f,$00,$00
	dc.b	$11,$13,$11,$13,$11,$13,$00,$00
	dc.b	$91,'@',$91,'@',$91,'@',$00,$00
	dcb.w	5
	dc.b	$00,$01,$00,$01,$00,$01,'|',$01
	dc.b	$04,$0c,$fc,$0f,$fc,$0f,$c0,$00
	dc.b	'@',$00,$c0,$00,$c0,$00,$00,$00
	dcb.w	11
	dc.b	$7f,$ff,'p',$00,$7f,$ff,$00,$00
	dc.b	$ff,$fe,$00,$06,$ff,$fe,$00,$01
	dc.b	$1f,$e0,$10,'`',$1f,$e0,'`',$10
	dc.b	$04,$f8,$07,$07,$00,$ff,$07,$00
	dc.b	'_',$ff,'x',$00,'G',$ff,'8',$00
	dc.b	$ff,$fd,$00,$04,$ff,$fc,$00,$03
	dcb.w	24
	dc.b	$00,$80,$00,$c0,$00,$c0,$00,$00
	dcb.w	5
	dc.b	$00,$01,$00,$01,$00,$01,'|',$03
	dc.b	$04,$0c,$fc,$0f,$fc,$0f,$c0,$00
	dc.b	'@',$00,$c0,$00,$c0,$00,$00,$00
	dcb.w	11
	dc.b	'O',$ff,'@',$00,'O',$ff,'0',$00
	dc.b	$ff,$fb,$00,$07,$ff,$ff,$00,$00
	dc.b	'O',$b0,$00,'p',$0f,$f0,'p',$00
	dc.b	$07,$f9,$07,$07,$00,$ff,$07,$00
	dc.b	'g',$ff,'X',$00,'G',$ff,'8',$00
	dc.b	$ff,$f9,$00,$01,$ff,$f9,$00,$06
	dcb.w	8
	dc.b	$f3,$9e,$f3,$9e,$f3,$9e,$00,$00
	dc.b	'|',$00,'|',$00,'|',$00,$00,$00
	dc.b	$00,$1f,$00,$1f,$00,$1f,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$80,$ff,$c0,$ff,$c0,$00,$00
	dcb.w	4
	dc.b	$80,$00,$80,$01,$80,$01,$80,$01
	dc.b	'|',$03,$04,$18,$fc,$1f,$fc,$1f
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	12
	dc.b	$10,$00,$00,$00,$0f,$ff,'p',$00
	dc.b	$00,$01,$00,$07,$ff,$ff,$00,$00
	dc.b	'`',$19,$00,'w',$0f,$f0,'p',$0f
	dc.b	$b3,$03,$c3,$07,$00,$ff,$ff,$00
	dc.b	'p',$00,'@',$00,'O',$ff,'0',$00
	dc.b	$00,$07,$00,$07,$ff,$ff,$00,$00
	dcb.w	5
	dc.b	$00,$01,$00,$01,$00,$00,$00,$00
	dc.b	$04,'Q',$04,'Q',$00,$00,$00,$00
	dc.b	'@',$00,'@',$00,$00,$00,$00,$00
	dcb.w	16
	dc.b	$00,$01,$00,$01,$00,$01,'|',$03
	dc.b	$04,$18,$fc,$1f,$fc,$1f,$80,$00
	dc.b	$80,$00,$80,$00,$80,$00,$00,$00
	dcb.w	11
	dc.b	'a',$98,$0f,$98,$0f,$9b,'pd'
	dc.b	$17,$1c,$1f,$07,$ff,$07,$00,$f8
	dc.b	'`7',$00,'o',$0f,$e0,'p',$1f
	dc.b	$b1,$07,$c1,$07,$00,$ff,$ff,$00
	dc.b	'0',$00,$00,'?',$0f,$ff,'p',$00
	dc.b	$00,$01,$ff,$ff,$ff,$ff,$00,$00
	dcb.w	5
	dc.b	$00,$01,$00,$01,$00,$00,$00,$00
	dc.b	$04,'Q',$04,'Q',$00,$00,$00,$00
	dc.b	'x',$00,'x',$00,$00,$00,$00,$00
	dcb.w	16
	dc.b	$00,$01,$00,$01,$00,$01,'|',$03
	dc.b	$04,$19,$fc,$1f,$fc,$1f,$00,$00
	dcb.w	15
	dc.b	'F0',$1e,'4',$1e,'3a',$cc
	dc.b	$0b,$ce,$0f,$c3,$ef,$c3,$10,'<'
	dc.b	'`s',$00,'O',$0f,$c0,'p?'
	dc.b	$dc,$05,$e0,$05,$00,$fd,$ff,$02
	dc.b	$10,$1e,$00,'?',$0f,$80,'p',$7f
	dc.b	'W',$91,$8f,$e7,$00,$07,$ff,$f8
	dcb.w	5
	dc.b	$00,$01,$00,$01,$00,$00,$00,$00
	dc.b	$04,'Q',$04,'Q',$00,$00,$00,$00
	dc.b	'@',$00,'@',$00,$00,$00,$00,$00
	dcb.w	19
	dc.b	'8',$07,$88,$19,$f8,$1f,$f8,$1f
	dcb.w	16
	dc.b	$08,$e4,'8',$ec,'8',$e3,'G',$1c
	dc.b	$04,'g',$07,$e1,$e7,$e1,$18,$1e
	dc.b	$10,$00,'`',$00,$0f,$ff,'p',$00
	dcb.w	2
	dc.b	$ff,$f8,$00,$07,$10,$00,$00,$00
	dc.b	$0f,$ff,'p',$00,$00,$01,$00,$07
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dcb.w	7
	dc.b	$f3,$9e,$f3,$9e,$00,$00,$00,$00
	dc.b	'|',$00,'|',$00,$00,$00,$00,$00
	dcb.w	19
	dc.b	'8',$06,$88,'2',$f8,'>',$f8,'>'
	dcb.w	16
	dc.b	$00,$0f,$00,$1f,$00,$00,$00,$1c
	dc.b	$f0,$00,$f0,$00,$10,$00,$0c,$00
	dc.b	'/',$ff,$7f,$ff,$00,$00,'p',$00
	dc.b	$ff,$fa,$ff,$f8,$00,$00,$00,$07
	dc.b	'O',$ff,$0f,$ff,$00,$00,'p',$00
	dc.b	$ff,$fb,$ff,$ff,$00,$07,$00,$00
	dcb.w	36
	dc.b	'8',$0e,$88,'2',$f8,'>',$f8,'>'
	dcb.w	16
	dc.b	$00,$1b,$00,$1f,$00,$00,$00,$1c
	dc.b	$f0,$00,$f0,$00,$10,$00,$0c,$00
	dc.b	'/',$ff,$7f,$ff,$00,$00,'p',$00
	dc.b	$ff,$fa,$ff,$f8,$00,$00,$00,$07
	dc.b	'/',$ff,'O',$ff,$00,$00,'p',$00
	dc.b	$ff,$fe,$ff,$fe,$00,$06,$00,$01
	dcb.w	36
	dc.b	'1',$cc,$8f,$f4,$ff,$fc,$ff,$fc
	dcb.w	16
	dc.b	$00,$13,$00,$1f,$00,$00,$00,$1c
	dc.b	$f8,$00,$f8,$00,$18,$00,$04,$00
	dc.b	$7f,$ff,$7f,$ff,$00,$00,'p',$00
	dc.b	$ff,$f8,$ff,$f8,$00,$00,$00,$07
	dc.b	$1f,$ff,'o',$ff,$00,$00,'p',$00
	dc.b	$ff,$fa,$ff,$fe,$00,$06,$00,$01
	dcb.w	24
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dcb.w	8
	dc.b	$0f,$fc,$7f,$fc,$7f,$fc,$7f,$fc
	dcb.w	16
	dc.b	$00,$07,$00,$1f,$00,$00,$00,$1c
	dc.b	$f8,$00,$f8,$00,$18,$00,$04,$00
	dc.b	$7f,$ff,$7f,$ff,$00,$00,'p',$00
	dc.b	$ff,$fd,$ff,$fd,$00,$05,$00,$02
	dc.b	'o',$ff,$7f,$ff,$00,$00,'p',$00
	dc.b	$ff,$f8,$ff,$fe,$00,$06,$00,$01
	dcb.w	36
	dc.b	'?',$fc,$7f,$fc,$7f,$fc,$7f,$fc
	dcb.w	16
	dc.b	$00,$0c,$00,$1f,$00,$00,$00,$1c
	dc.b	$0c,$00,$fc,$00,$1c,$00,$00,$00
	dc.b	'`',$0e,$7f,$fe,$00,'~p',$01
	dc.b	$01,$07,$01,$ff,$01,$07,$fe,$00
	dc.b	'p',$00,$7f,$ff,$00,$7f,'p',$00
	dc.b	$00,$01,$ff,$fe,$ff,$fe,$00,$01
	dcb.w	24
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dcb.w	8
	dc.b	$7f,$fc,$ff,$fc,$ff,$fc,$ff,$fc
	dcb.w	16
	dc.b	$00,$1c,$00,$1f,$00,$00,$00,$1c
	dc.b	$0c,$00,$fc,$00,$1c,$00,$00,$00
	dc.b	' ',$03,$7f,$ff,$00,$7f,'p',$00
	dc.b	$87,$03,$86,$ff,$86,$07,'y',$00
	dc.b	'`',$13,$7f,$cf,$00,$00,'p?'
	dc.b	$9c,'s',$e3,$86,$00,$06,$ff,$f9
	dcb.w	36
	dc.b	$7f,$fe,$ff,$fe,$ff,$fe,$ff,$fe
	dcb.w	16
	dc.b	$00,$08,$00,$1f,$00,$00,$00,$1c
	dc.b	$04,$00,$fc,$00,$1c,$00,$00,$00
	dc.b	$10,'@o',$ff,$00,$7f,'p',$00
	dc.b	$de,$01,$dd,$ff,$dc,$07,'#',$00
	dc.b	$00,$00,$7f,$ff,$00,$00,'p',$00
	dc.b	$00,$07,$ff,$fe,$00,$06,$00,$01
	dcb.w	18
	dc.b	$00,$ff,$00,$ff,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dcb.w	7
	dc.b	$01,$ff,$07,$ff,$07,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$c0,$ff,$c0,$ff,$c0,$00,$00
	dcb.w	12
	dc.b	$00,$1f,$00,$00,$00,$1c,$04,$00
	dc.b	$fc,$00,$1c,$00,$00,$00,'p`'
	dc.b	$0f,$f0,$00,'pp',$00,$05,$01
	dc.b	$03,$ff,$00,$07,$07,$00,'X',$00
	dc.b	$27,$ff,$00,$00,'x',$00,$00,$06
	dc.b	$ff,$fe,$00,$06,$00,$01,$00,$00
	dcb.w	17
	dc.b	$00,$ff,$00,$ff,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dcb.w	6
	dc.b	'p',$ff,$00,$00,$7f,$ff,$7f,$ff
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$ff,$80,$00,'@',$ff,$c0,$ff,$c0
	dcb.w	12
	dc.b	$00,$14,$00,$0b,$00,$00,$00,$1c
	dc.b	$04,$00,$fc,$00,$1c,$00,$00,$00
	dc.b	'`0',$1f,$b0,$00,'0p@'
	dc.b	$07,$00,$07,$ff,$00,$07,$07,$00
	dc.b	'p',$00,'G',$ff,'@',$00,'8',$00
	dc.b	$00,$04,$ff,$fe,$00,$06,$00,$01
	dcb.w	18
	dc.b	$00,$ff,$00,$ff,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$01,$00,$00,$00,$07,$00,$07
	dc.b	$f0,$80,$00,$00,$ff,$ff,$ff,$ff
	dcb.w	2
	dc.b	$ff,$ff,$ff,$ff,$00,$80,$00,'@'
	dc.b	$ff,$c0,$ff,$c0,$00,$00,$00,$00
	dcb.w	6
	dc.b	$00,'@',$00,'@',$00,'@',$00,'@'
	dc.b	$00,$1c,$00,$03,$00,$00,$00,$1c
	dc.b	$00,$00,$fc,$00,$1c,$00,$00,$00
	dc.b	'P',$10,'?',$90,$00,$10,'p`'
	dc.b	$06,$00,$07,$ff,$00,$07,$07,$00
	dc.b	'$',$00,'C',$ff,'@',$00,'<',$00
	dc.b	$00,$00,$ff,$fe,$00,$06,$00,$01
	dcb.w	16
	dc.b	' ',$00,' ',$00,'!',$ff,'!',$ff
	dcb.w	2
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$07,$00,$00,$00,'?',$00,'?'
	dc.b	$f8,$80,$00,'@',$ff,$c0,$ff,$c0
	dcb.w	4
	dc.b	$00,$80,$00,'@',$01,$c0,$01,$c0
	dcb.w	12
	dc.b	$00,$1c,$00,$03,$00,$00,$00,$1c
	dc.b	$00,$00,$fc,$00,$1c,$00,$00,$00
	dc.b	' ',$10,$7f,$90,$00,$10,'p`'
	dc.b	$05,$00,$06,$ff,$00,$07,$07,$00
	dc.b	')',$00,'&',$ff,' ',$00,$1f,$00
	dc.b	$00,$00,$ff,$fe,$00,$06,$00,$01
	dcb.w	18
	dc.b	$01,$ff,$01,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$0f,$00,$00,$00,'?',$00,'?'
	dc.b	$f8,$80,$00,'@',$ff,$c0,$ff,$c0
	dcb.w	4
	dc.b	$08,$80,$08,'@',$09,$c0,$09,$c0
	dcb.w	8
	dc.b	$00,$08,$00,$08,$00,$08,$00,$08
	dc.b	$00,$1b,$00,$07,$00,$07,$00,$18
	dc.b	$c0,$00,$fc,$00,$fc,$00,$00,$00
	dc.b	'C',$00,'o',$c0,$0f,$c0,'p0'
	dc.b	$03,$f0,$05,$f7,$01,$f7,$06,$08
	dc.b	$12,$11,'<',$7f,'0',$7f,$0f,$80
	dc.b	$a3,$18,$bf,$1e,$bf,$1e,'@',$e1
	dcb.w	18
	dc.b	$01,$ff,$01,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$0f,$00,$00,$00,'?',$00,'?'
	dc.b	$f4,$80,$00,'@',$ff,$c0,$ff,$c0
	dcb.w	4
	dc.b	$04,$80,$04,'@',$05,$c0,$05,$c0
	dc.b	$00,$04,$00,$04,$00,$04,$00,$04
	dcb.w	8
	dc.b	$00,$16,$00,$0e,$00,$0e,$00,$11
	dc.b	'`',$00,'|',$00,'|',$00,$80,$00
	dc.b	$07,$80,'_',$e0,$1f,$e0,'`',$10
	dc.b	$06,'8',$03,$fb,$03,$fb,$04,$04
	dc.b	$0c,$b3,$18,$ff,$18,$ff,$07,$00
	dc.b	'3',$8c,'?Ž?',$8e,$c0,'q'
	dcb.w	12
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dcb.w	2
	dc.b	$03,$ff,$03,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$80,$00,$80,$00,$00,$0f,$00,$00
	dc.b	$00,$bf,$00,$bf,$f4,$80,$00,'@'
	dc.b	$ff,$c0,$ff,$c0,$00,$00,$00,$00
	dcb.w	2
	dc.b	$04,$80,$04,'@',$05,$c0,$05,$c0
	dcb.w	12
	dc.b	$00,$0c,$00,$1c,$00,$1c,$00,$03
	dc.b	'0',$00,'<',$00,'<',$00,$c0,$00
	dc.b	$08,$c0,'8',$f0,'8',$f0,'G',$00
	dc.b	$04,$18,$07,$f9,$07,$f9,$00,$06
	dc.b	$01,'v',$03,$fe,$03,$fe,$00,$01
	dc.b	'3',$c6,'?',$c6,'?',$c6,$c0,'9'
	dcb.w	18
	dc.b	$03,$ff,$03,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$80,$00,$80,$00,$00,$1f,$00,$00
	dc.b	$00,$bf,$00,$bf,$b4,$80,$00,'@'
	dc.b	$ff,$c0,$ff,$c0,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$80,$00,'@',$01,$c0,$01,$c0
	dcb.w	40
	dc.b	$04,$00,$04,$00,$04,$00,$04,$00
	dcb.w	10
	dc.b	$03,$ff,$03,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$80,$00,$80,$00,$00,$1f,$00,$00
	dc.b	$00,$bf,$00,$bf,$b4,$80,$00,'@'
	dc.b	$ff,$c0,$ff,$c0,$c0,'`',$c0,'`'
	dc.b	$c0,'`',$c0,'`',$00,$80,$00,'@'
	dc.b	$01,$c0,$01,$c0,$00,$00,$00,$00
	dcb.w	50
	dc.b	$07,$ff,$00,$00,$0f,$ff,$0f,$ff
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$c0,$00,' ',$00,$e0,$00,$e0,$00
	dc.b	$00,'?',$00,$00,$00,$bf,$00,$bf
	dc.b	$b4,$81,$00,'A',$ff,$c1,$ff,$c1
	dc.b	' ',$90,' ',$90,' ',$90,' ',$90
	dc.b	$00,$80,$00,'@',$01,$c0,$01,$c0
	dcb.w	52
	dc.b	$07,$ff,$00,$00,$0f,$ff,$0f,$ff
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$c0,$00,' ',$00,$e0,$00,$e0,$00
	dc.b	$00,'?',$00,$00,$00,$bf,$00,$bf
	dc.b	$b4,$80,$00,'@',$ff,$c0,$ff,$c0
	dc.b	'$',$13,'$',$13,'$',$13,'$',$13
	dc.b	$80,$80,$80,'@',$81,$c0,$81,$c0
	dcb.w	10
	dc.b	$04,$00,$04,$00,$00,$00,$00,$00
	dcb.w	38
	dc.b	$07,$ff,$00,$00,$0f,$ff,$0f,$ff
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$c0,$00,' ',$00,$e0,$00,$e0,$00
	dc.b	$00,'?',$00,$00,$00,$bf,$00,$bf
	dc.b	$b4,$80,$00,'@',$ff,$c0,$ff,$c0
	dc.b	'N N N N '
	dc.b	$00,$80,$00,'@',$01,$c0,$01,$c0
	dcb.w	8
	dc.b	$04,$00,$00,$00,$04,$00,$04,$00
	dcb.w	40
	dc.b	$06,$00,$00,$00,$0f,$ff,$0f,$ff
	dcb.w	2
	dc.b	$ff,$ff,$ff,$ff,$c0,$00,' ',$00
	dc.b	$e0,$00,$e0,$00,$00,'?',$00,$00
	dc.b	$00,$bf,$00,$bf,$b4,$80,$00,'@'
	dc.b	$ff,$c0,$ff,$c0,'D D '
	dc.b	'D D ',$00,$80,$00,'@'
	dc.b	$01,$c0,$01,$c0,$00,$00,$00,$00
	dcb.w	7
	dc.b	$04,$00,$04,$00,$04,$00,$00,$00
	dcb.w	27
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dcb.w	4
	dc.b	$06,$00,$01,$00,$0f,$00,$0f,$00
	dcb.w	2
	dc.b	$00,$01,$00,$01,$c0,$00,' ',$00
	dc.b	$e0,$00,$e0,$00,$00,'?',$00,$00
	dc.b	$00,$bf,$00,$bf,$b4,$80,$00,'@'
	dc.b	$ff,$c0,$ff,$c0,$80,'C',$80,'C'
	dc.b	$80,'C',$80,'C',$80,$80,$80,'@'
	dc.b	$81,$c0,$81,$c0,$00,$00,$00,$00
	dcb.w	6
	dc.b	$15,$00,$0e,$00,'?',$80,'?',$80
	dcb.w	32
	dc.b	$00,$08,$00,$08,$00,$08,$00,$08
	dcb.w	4
	dc.b	$06,$00,$01,$00,$0f,$00,$0f,$00
	dc.b	$00,$18,$00,$18,$00,$19,$00,$19
	dc.b	$c0,$00,' ',$00,$e0,$00,$e0,$00
	dc.b	$00,'?',$00,$00,$00,$bf,$00,$bf
	dc.b	$b4,$81,$00,'A',$ff,$c1,$ff,$c1
	dc.b	$e0,$f0,$e0,$f0,$e0,$f0,$e0,$f0
	dc.b	$00,$80,$00,'@',$01,$c0,$01,$c0
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dcb.w	5
	dc.b	$04,$00,$04,$00,$04,$00,$00,$00
	dcb.w	3
	dc.b	$10,$00,$10,$00,$10,$00,$10,$00
	dcb.w	4
	dc.b	$04,$00,$04,$00,$04,$00,$04,$00
	dcb.w	24
	dc.b	$06,$00,$01,$00,$0f,$00,$0f,$00
	dc.b	$00,$04,$00,$04,$00,$05,$00,$05
	dc.b	$c0,$00,' ',$00,$e0,$00,$e0,$00
	dc.b	$00,'?',$00,$00,$00,$bf,$00,$bf
	dc.b	$b4,$80,$00,'@',$ff,$c0,$ff,$c0
	dcb.w	4
	dc.b	$00,$80,$00,'@',$01,$c0,$01,$c0
	dcb.w	8
	dc.b	$04,$00,$00,$00,$04,$00,$04,$00
	dcb.w	40
	dc.b	$06,$00,$01,$00,$0f,$00,$0f,$00
	dc.b	$00,$04,$00,$04,$00,$05,$00,$05
	dc.b	$c0,$00,' ',$00,$e0,$00,$e0,$00
	dc.b	$00,'?',$00,$00,$00,$bf,$00,$bf
	dc.b	$b4,$80,$00,'@',$ff,$c0,$ff,$c0
	dcb.w	4
	dc.b	$00,$80,$00,'@',$01,$c0,$01,$c0
	dcb.w	10
	dc.b	$04,$00,$04,$00,$00,$00,$00,$00
	dcb.w	38
	dc.b	$06,$00,$01,$00,$0f,$00,$0f,$00
	dcb.w	2
	dc.b	$00,$01,$00,$01,$c0,$00,' ',$00
	dc.b	$e0,$00,$e0,$00,$00,'?',$00,$00
	dc.b	$00,$bf,$00,$bf,$b4,$81,$00,'A'
	dc.b	$ff,$c1,$ff,$c1,$e9,'H',$e9,'H'
	dc.b	$e9,'H',$e9,'H',$00,$80,$00,'@'
	dc.b	$01,$c0,$01,$c0,$00,$00,$00,$00
	dcb.w	50
	dc.b	$06,$00,$01,$00,$0f,$00,$0f,$00
	dcb.w	2
	dc.b	$00,$01,$00,$01,$c0,$00,' ',$00
	dc.b	$e0,$00,$e0,$00,$00,'?',$00,$00
	dc.b	$00,$bf,$00,$bf,$b4,$81,$00,'A'
	dc.b	$ff,$c1,$ff,$c1,$09,'H',$09,'H'
	dc.b	$09,'H',$09,'H',$00,$80,$00,'@'
	dc.b	$01,$c0,$01,$c0,$00,$00,$00,$00
	dcb.w	10
	dc.b	$03,$af,$06,' ',$06,' ',$01,$df
	dc.b	'<',$a0,$ff,'0',$00,'0',$ff,$c0
	dc.b	$03,$8c,$06,$03,$06,$00,$01,$ff
	dc.b	$e3,'O',$fc,'?',$00,$01,$ff,$fe
	dc.b	$03,'6',$02,$07,$02,$07,$01,$f8
	dc.b	$11,$a0,'^ @ ?',$c0
	dcb.w	16
	dc.b	$06,$00,$01,$00,$0f,$00,$0f,$00
	dc.b	'Z',$00,'Z',$00,'Z',$01,'Z',$01
	dc.b	$c0,$00,' ',$00,$e0,$00,$e0,$00
	dc.b	$00,'?',$00,$00,$00,$bf,$00,$bf
	dc.b	$b4,$81,$00,'A',$ff,$c1,$ff,$c1
	dc.b	$89,'x',$89,'x',$89,'x',$89,'x'
	dc.b	$00,$80,$00,'@',$01,$c0,$01,$c0
	dcb.w	12
	dc.b	$0b,$ee,$0e,'!',$08,' ',$07,$df
	dc.b	'8',$d8,$ff,'(',$00,$08,$ff,$f0
	dc.b	$0b,$c9,$1e,$07,$18,$00,$07,$ff
	dc.b	$e6,'^',$f8,'?',$00,$03,$ff,$fc
	dc.b	$0f,$27,$08,$07,$08,$07,$07,$f8
	dc.b	$19,$98,'~',$08,$00,$08,$ff,$f0
	dcb.w	16
	dc.b	$06,$00,$01,$00,$0f,$00,$0f,$00
	dc.b	'Z',$00,'Z',$00,$00,$01,'Z',$01
	dc.b	$c0,$00,' ',$00,$e0,$00,$e0,$00
	dc.b	$00,$1f,$00,$00,$00,$bf,$00,$bf
	dc.b	$b4,$81,$00,'A',$ff,$c1,$ff,$c1
	dc.b	$09,'H',$09,'H',$09,'H',$09,'H'
	dc.b	$00,$80,$00,'@',$01,$c0,$01,$c0
	dcb.w	12
	dc.b	$16,$fe,$1f,'!',$10,' ',$0f,$df
	dc.b	'1',$f4,$fe,'<',$00,$04,$ff,$f8
	dc.b	$16,$dc,'?',$03,'0',$00,$0f,$ff
	dc.b	$cc,$bc,$f0,$7f,$00,$07,$ff,$f8
	dc.b	$11,$ae,$1e,$0f,$10,$0f,$0f,$f0
	dc.b	$db,'$',$bc,$1c,$80,$04,$7f,$f8
	dcb.w	16
	dc.b	$06,$00,$01,$00,$0f,$00,$0f,$00
	dc.b	'Z',$00,'Z',$00,$00,$01,'Z',$01
	dc.b	$c0,$00,' ',$00,$e0,$00,$e0,$00
	dc.b	$00,$1f,$00,$00,$00,$bf,$00,$bf
	dc.b	$b4,$81,$00,'A',$ff,$c1,$ff,$c1
	dc.b	$ef,'J',$ef,'J',$ef,'J',$ef,'J'
	dc.b	$a0,$80,$a0,'@',$a1,$c0,$a1,$c0
	dcb.w	12
	dc.b	'&',$ff,'?',$00,' ',$ff,$1f,$00
	dc.b	$ff,$ac,$00,'r',$ff,$82,$00,'|'
	dc.b	'&',$ff,'?',$00,' ',$ff,$1f,$00
	dc.b	$ff,$f9,$00,$07,$ff,$ff,$00,$00
	dc.b	'!',$fe,'>',$03,' ',$ff,$1f,$00
	dc.b	$df,$ac,$a0,$12,$9f,$82,'`|'
	dcb.w	16
	dc.b	$06,$00,$01,$00,$0f,$00,$0f,$00
	dc.b	$00,$00,'Z',$00,$00,$01,'Z',$01
	dc.b	$c0,$00,' ',$00,$e0,$00,$e0,$00
	dc.b	$00,$1f,$00,$00,$00,$bf,$00,$bf
	dc.b	$b4,$80,$00,'@',$ff,$c0,$ff,$c0
	dcb.w	4
	dc.b	$00,$80,$00,'@',$01,$c0,$01,$c0
	dcb.w	12
	dc.b	$13,$ff,'<',$00,$03,$ff,'<',$00
	dc.b	$ff,$fa,$00,$02,$ff,$e2,$00,$1c
	dc.b	$13,$ff,'|',$00,'C',$ff,'<',$00
	dc.b	$ff,$fb,$00,$07,$ff,$ff,$00,$00
	dc.b	'3',$ff,$0c,$00,$03,$ff,'<',$00
	dc.b	$ff,$f2,$80,$02,$ff,$e2,$00,$1c
	dcb.w	6
	dc.b	$00,$01,$00,$01,$00,$00,$00,$00
	dcb.w	6
	dc.b	$06,$00,$01,$00,$0f,$00,$0f,$00
	dc.b	$00,$00,$db,$00,$00,$01,$db,$01
	dc.b	$c0,$80,' ',$80,$e0,$80,$e0,$80
	dc.b	$00,$1f,$00,$00,$00,$bf,$00,$bf
	dc.b	$b4,$80,$00,'@',$ff,$c0,$ff,$c0
	dcb.w	4
	dc.b	$00,$80,$00,'@',$01,$c0,$01,$c0
	dcb.w	12
	dc.b	'_',$ff,'x',$00,'G',$ff,'8',$00
	dc.b	$ff,$f7,$00,$07,$ff,$f7,$00,$08
	dc.b	'_',$ff,'x',$00,'G',$ff,'8',$00
	dc.b	$ff,$ff,$00,$07,$ff,$ff,$00,$00
	dc.b	'_',$ff,'@',$00,'G',$ff,'8',$00
	dc.b	$ff,$fe,$00,$0e,$ff,$fe,$00,$00
	dcb.w	4
	dc.b	$00,$01,$00,$00,$00,$01,$00,$01
	dcb.w	8
	dc.b	$06,$00,$01,$00,$0f,$00,$0f,$00
	dc.b	$db,$00,$00,$00,$00,$01,$db,$01
	dc.b	$c0,$00,' ',$00,$e0,$00,$e0,$00
	dc.b	$00,$1f,$00,$00,$00,'?',$00,'?'
	dc.b	$b4,$80,$00,'@',$ff,$c0,$ff,$c0
	dcb.w	4
	dc.b	$00,$80,$00,'@',$01,$c0,$01,$c0
	dcb.w	12
	dc.b	'g',$ff,$18,$00,$07,$ff,'x',$00
	dc.b	$ff,$fd,$00,$0f,$ff,$ff,$00,$00
	dc.b	'g',$ff,$18,$00,$07,$ff,'x',$00
	dc.b	$ff,$f9,$00,$07,$ff,$ff,$00,$00
	dc.b	$07,$ff,$00,$00,$07,$ff,'x',$00
	dc.b	$ff,$fe,$00,$0f,$ff,$ff,$00,$00
	dcb.w	5
	dc.b	$00,$01,$00,$01,$00,$01,$00,$00
	dcb.w	7
	dc.b	$06,$01,$01,$00,$0f,$00,$0f,$01
	dc.b	$db,$80,$00,$00,$00,$01,$db,$81
	dc.b	$c0,$00,' ',$00,$e0,$00,$e0,$00
	dc.b	$00,$0f,$00,$00,$00,'?',$00,'?'
	dc.b	$f4,$80,$00,'@',$ff,$c0,$ff,$c0
	dcb.w	4
	dc.b	$00,$80,$00,'@',$01,$c0,$01,$c0
	dcb.w	12
	dc.b	'0',$00,$00,$00,$0f,$ff,'p',$00
	dc.b	$00,$01,$00,$07,$ff,$ff,$00,$00
	dc.b	'0',$00,$00,$00,$0f,$ff,'p',$00
	dc.b	$00,$00,$00,$07,$ff,$ff,$00,$00
	dcb.w	2
	dc.b	$0f,$ff,'p',$00,$00,$04,$00,$07
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dcb.w	8
	dc.b	$06,$00,$01,$00,$0f,$00,$0f,$03
	dcb.w	2
	dc.b	$00,$01,$99,$c1,$c0,$00,' ',$00
	dc.b	$e0,$00,$e0,$00,$00,$0f,$00,$00
	dc.b	$00,'?',$00,'?',$f4,$80,$00,'@'
	dc.b	$ff,$c0,$ff,$c0,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$80,$00,'@',$01,$c0,$01,$c0
	dcb.w	12
	dc.b	'0',$00,$00,'?',$0f,$ff,'p',$00
	dc.b	$06,$00,$fe,$06,$ff,$fe,$00,$01
	dc.b	'0',$01,$00,'?',$0f,$ff,'p',$00
	dc.b	$e7,$80,$ff,$87,$ff,$87,$00,'x'
	dc.b	' ',$00,$00,$00,$0f,$c7,'p8'
	dc.b	$00,$00,$00,$07,$f1,$ff,$0e,$00
	dcb.w	4
	dc.b	$00,$0b,$00,$07,$00,$1f,$00,$1f
	dc.b	$a0,$00,$c0,$00,$f0,$00,$f0,$00
	dcb.w	4
	dc.b	$06,$00,$01,$00,$0f,$00,$0f,$07
	dcb.w	2
	dc.b	$00,$01,$99,$e1,$c0,$00,' ',$00
	dc.b	$e0,$00,$e0,$00,$00,$03,$00,$00
	dc.b	$00,'?',$00,'?',$f8,$80,$00,$7f
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$00,$80,$fe,'@'
	dc.b	$ff,$c0,$ff,$c0,$00,$00,$00,$00
	dcb.w	10
	dc.b	$10,$00,$00,$7f,$0f,$ff,'p',$00
	dc.b	'|',$02,$fd,$06,$fc,$fe,$03,$01
	dc.b	$10,$06,$00,'~',$0f,$fe,'p',$01
	dc.b	'0',$e0,'?',$e3,'?',$e3,$c0,$1c
	dc.b	'pd',$00,'`',$0f,$e3,'p',$1c
	dc.b	$1b,$01,$18,$07,$f8,$ff,$07,$00
	dcb.w	4
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dcb.w	8
	dc.b	$06,$07,$01,$07,$0f,$07,$0f,$00
	dc.b	$18,$e0,$18,$e0,$18,$e1,$00,$01
	dc.b	$c0,$00,' ',$00,$e0,$00,$e0,$00
	dcb.w	2
	dc.b	$00,$03,$00,$03,$08,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$80,$00,'@'
	dc.b	$ff,$c0,$ff,$c0,$00,$00,$00,$00
	dcb.w	10
	dc.b	$10,$01,$00,$7f,$0f,$ff,'p',$00
	dc.b	$89,$04,$8b,$04,$88,$fc,'w',$03
	dc.b	$10,$01,$00,$7f,$0f,$ff,'p',$00
	dc.b	$c0,'p',$ff,$f1,$ff,$f1,$00,$0e
	dc.b	'p<',$00,'p',$0f,$f3,'p',$0c
	dc.b	$00,$01,$1f,$07,$fc,$ff,$03,$00
	dcb.w	4
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dcb.w	8
	dc.b	$06,$07,$01,$07,$0f,$07,$0f,$00
	dc.b	$18,$e0,$18,$e0,$18,$e1,$00,$01
	dc.b	$c0,$00,' ',$00,$e0,$00,$e0,$00
	dcb.w	6
	dc.b	$0f,$ff,$0f,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,'@'
	dc.b	$ff,$c0,$ff,$c0,$00,$00,$00,$00
	dcb.w	10
	dc.b	'O',$80,$0f,$f0,$00,'pp',$00
	dc.b	$03,$f9,$07,$f8,$00,$00,$07,$07
	dc.b	'O',$80,$0f,$f0,$00,'pp',$00
	dcb.w	4
	dc.b	'_',$9f,'/',$f3,$00,'pp',$0c
	dc.b	$e4,$fb,$ff,$ff,$1c,$07,$03,$00
	dcb.w	5
	dc.b	$00,$01,$00,$01,$00,$01,$00,$00
	dcb.w	7
	dc.b	$06,$00,$01,$06,$0f,$06,$0f,$00
	dc.b	$00,$00,$18,'`',$18,'a',$00,$01
	dc.b	$c0,$01,' ',$01,$e0,$01,$e0,$01
	dcb.w	6
	dc.b	$f0,$00,$f0,$00,$00,$00,$00,$00
	dcb.w	18
	dc.b	'/',$80,'O',$f0,$00,'pp',$00
	dc.b	$03,$fe,$07,$f9,$00,$00,$07,$07
	dc.b	'/',$80,'O',$f0,$00,'pp',$00
	dcb.w	4
	dc.b	$0f,$c7,$7f,$fb,$00,'pp',$0c
	dc.b	$ed,$fb,$ff,$ff,$1c,$07,$03,$00
	dcb.w	4
	dc.b	$00,$01,$00,$00,$00,$01,$00,$01
	dcb.w	8
	dc.b	$06,$00,$01,$04,$0f,$04,$0f,$00
	dc.b	$00,$00,$18,' ',$18,'!',$00,$01
	dc.b	$c0,$00,' ',$00,$e0,$00,$e0,$00
	dcb.w	4
	dc.b	$00,$03,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$f0,$00,$00,$00,$f0,$00,$f0,$00
	dcb.w	12
	dc.b	$1f,$b0,'o',$f0,$00,'pp',$00
	dc.b	$05,$f8,$03,$ff,$00,$00,$07,$07
	dc.b	$1f,$b0,'o',$f8,$00,'xp',$00
	dcb.w	4
	dc.b	'/',$e3,$7f,$ff,$00,'pp',$0c
	dc.b	$ff,$fb,$ff,$ff,$1c,$07,$03,$00
	dcb.w	6
	dc.b	$00,$01,$00,$01,$00,$00,$00,$00
	dcb.w	2
	dc.b	$10,$00,$10,$00,$10,$00,$10,$00
	dc.b	$06,$00,$01,$00,$0f,$00,$0f,$00
	dcb.w	2
	dc.b	$00,$01,$00,$01,$c0,$00,' ',$00
	dc.b	$e0,$00,$e0,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$f9,$ff,$f9,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$0f,$c0,$00,$00
	dc.b	$ff,$c0,$ff,$c0,$00,$00,$00,$00
	dcb.w	10
	dc.b	'o',$e1,$7f,$e7,$00,'`p',$1f
	dc.b	'6',$f9,$c1,$fe,$00,$00,$ff,$07
	dc.b	'o',$e4,$7f,$e3,$00,'`p',$1f
	dc.b	'0',$e4,$ff,$1e,$00,$00,$ff,$ff
	dc.b	$7f,$eb,$7f,$ff,$00,'pp',$0c
	dc.b	$f7,$fb,$f7,$ff,$14,$07,$0b,$00
	dcb.w	16
	dc.b	$06,$00,$01,$00,$0f,$00,$0f,$00
	dcb.w	2
	dc.b	$00,$01,$00,$01,$c0,$00,' ',$00
	dc.b	$e0,$00,$e0,$00,$00,$00,$00,$00
	dc.b	$00,$01,$00,$01,$01,$ff,$00,$00
	dc.b	$07,$ff,$07,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$c0,$00,$00
	dc.b	$ff,$c0,$ff,$c0,$00,$00,$00,$00
	dcb.w	10
	dc.b	'pK',$7f,$c7,$00,'@p?'
	dc.b	$b2,$06,$c1,$f8,$00,$00,$ff,$07
	dc.b	'pL',$7f,$c3,$00,'@p?'
	dc.b	'y',$c8,$fe,'=',$00,$01,$ff,$fe
	dc.b	'p<',$7f,$ff,$00,'pp',$0c
	dc.b	$17,$03,$f7,$ff,$14,$07,$0b,$00
	dcb.w	16
	dc.b	$06,$00,$01,$00,$0f,$00,$0f,$00
	dcb.w	2
	dc.b	$00,$01,$00,$01,$c0,$00,' ',$00
	dc.b	$e0,$00,$e0,$00,$00,$00,$00,$00
	dc.b	$00,'?',$00,'?',$01,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$c0,$00,$00
	dc.b	$ff,$c0,$ff,$c0,$00,$00,$00,$00
	dcb.w	10
	dc.b	'`',$1f,$7f,$c7,$00,$00,'p?'
	dc.b	$88,$02,$f1,$fe,$00,$06,$fe,$00
	dc.b	'`',$1e,$7f,$c1,$00,$00,'p?'
	dc.b	'9',$10,$fe,$fb,$00,$03,$ff,$fc
	dc.b	' <',$7f,$ff,$00,'pp',$0c
	dc.b	$15,$03,$f7,$ff,$14,$07,$0b,$00
	dcb.w	16
	dc.b	$06,$00,$01,$00,$0f,$00,$0f,$00
	dcb.w	2
	dc.b	$00,$01,$00,$01,$c0,$00,' ',$00
	dc.b	$e0,$00,$e0,$00,$00,$00,$00,$00
	dc.b	$0f,$ff,$0f,$ff,$01,$87,$00,$00
	dc.b	$ff,$87,$ff,$87,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$c0,$00,$00
	dc.b	$ff,$c0,$ff,$c0,$00,$00,$00,$00
	dcb.w	11
	dc.b	$7f,$ff,$00,$00,'p',$00,$00,$01
	dc.b	$ff,$ff,$00,$07,$00,$00,$00,$00
	dc.b	$7f,$ff,$00,$00,'p',$00,$00,$00
	dc.b	$ff,$ff,$00,$07,$00,$00,$00,$18
	dc.b	$7f,$ff,$00,'pp',$0c,$14,$03
	dc.b	$f7,$ff,$14,$07,$0b,$00,$00,$00
	dcb.w	15
	dc.b	$06,$00,$01,$00,$0f,$00,$0f,$00
	dcb.w	2
	dc.b	$00,$01,$00,$01,$c0,$00,' ',$00
	dc.b	$e0,$00,$e0,$00,$00,$00,$00,$00
	dc.b	$7f,$ff,$7f,$ff,$01,$a7,$00,$00
	dc.b	$ff,$87,$ff,$97,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$c0,$00,$00
	dc.b	$ff,$c0,$ff,$c0,$00,$00,$00,$00
	dcb.w	10
	dc.b	'X',$00,$27,$ff,$00,$00,'x',$00
	dc.b	$00,$01,$ff,$f1,$00,$01,$00,$0e
	dc.b	'X',$00,$27,$ff,$00,$00,'x',$00
	dc.b	$00,$01,$ff,$ff,$00,$07,$00,$00
	dc.b	$00,$10,$7f,$ff,$00,'pp',$0c
	dc.b	$15,$03,$f7,$ff,$14,$07,$0b,$00
	dcb.w	16
	dc.b	$06,$00,$01,$ff,$0f,$ff,$0f,$ff
	dc.b	$00,$00,$ff,$fe,$ff,$ff,$ff,$ff
	dc.b	$c0,$00,' ',$00,$e0,$00,$e0,$00
	dcb.w	2
	dc.b	$7f,$ff,$7f,$ff,$01,$b7,$00,$00
	dc.b	$ff,$87,$ff,$87,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$c0,$00,$00
	dc.b	$ff,$c0,$ff,$c0,$00,$04,$00,$04
	dc.b	$00,$04,$00,$04,$00,$00,$00,$00
	dcb.w	6
	dc.b	'p',$00,'G',$ff,'@',$00,'8',$00
	dc.b	$00,$03,$ff,$fb,$00,$03,$00,$04
	dc.b	'p',$00,'G',$ff,'@',$00,'8',$00
	dc.b	$00,$03,$ff,$ff,$00,$07,$00,$00
	dc.b	'P',$10,'/',$ff,$00,'pp',$0c
	dc.b	$1f,$03,$ff,$ff,$1c,$07,$03,$00
	dcb.w	16
	dc.b	$07,$ff,$00,$00,$0f,$ff,$0f,$ff
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$c0,$00,' ',$00,$e0,$00,$e0,$00
	dcb.w	2
	dc.b	$7f,$ff,$7f,$ff,$01,$87,$00,$00
	dc.b	$ff,$87,$ff,$87,$ff,$c0,$00,$00
	dc.b	$ff,$c0,$ff,$c0,$00,$c0,$00,$00
	dc.b	$00,$c0,$00,$c0,$00,$00,$00,$00
	dcb.w	10
	dc.b	'$',$00,'C',$ff,'@',$00,'<',$00
	dc.b	$06,$07,$f9,$ff,$00,$07,$06,$00
	dc.b	'$',$00,'C',$ff,'@',$00,'<',$00
	dc.b	$00,$06,$ff,$fe,$00,$06,$00,$01
	dc.b	'p',$04,$0f,$fb,$00,'pp',$0c
	dc.b	$0e,$01,$ff,$ff,$1c,$07,$03,$00
	dcb.w	16
	dc.b	$07,$ff,$00,$00,$0f,$ff,$0f,$ff
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$c0,$00,' ',$00,$e0,$00,$e0,$00
	dcb.w	2
	dc.b	$7f,$ff,$7f,$ff,$01,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$fc,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$0f,$c0,$00,$00
	dc.b	$ff,$c0,$ff,$c0,$00,$00,$00,$00
	dcb.w	6
	dc.b	$10,$00,$10,$00,$10,$00,$10,$00
	dc.b	')',$00,'&',$ff,' ',$00,$1f,$00
	dc.b	$04,$01,$fb,$ff,$00,$07,$07,$00
	dc.b	')',$00,'&',$ff,' ',$00,$1f,$00
	dc.b	$00,$00,$ff,$f8,$00,$00,$00,$07
	dc.b	'p',$0c,$0f,$f3,$00,'pp',$0c
	dc.b	$0d,$01,$fe,$ff,$1c,$07,$03,$00
	dcb.w	18
	dc.b	$0f,$ff,$0f,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,' ',$00
	dc.b	$e0,$00,$e0,$00,$00,$00,$00,$00
	dc.b	$7f,$ff,$7f,$ff,$01,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$c0,$00,$00
	dc.b	$ff,$c0,$ff,$c0,$00,$00,$00,$00
	dcb.w	10
	dc.b	$12,'p<',$7f,'0',$7f,$0f,$80
	dc.b	$f1,$ec,$ff,$e7,$f8,$e7,$07,$18
	dc.b	$12,'G<',$7f,'0',$7f,$0f,$80
	dc.b	$80,$04,$ff,$fc,$ff,$fc,$00,$03
	dc.b	'o',$08,$1f,$f3,$1f,$f3,'`',$0c
	dc.b	$87,$f0,$9d,$f7,$9d,$f7,'b',$08
	dcb.w	30
	dc.b	$7f,$ff,$7f,$ff,$01,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$c0,$00,$00
	dc.b	$ff,$c0,$ff,$c0,$00,$00,$00,$00
	dcb.w	10
	dc.b	$0c,$9f,$18,$df,$18,$df,$07,' '
	dc.b	$9f,$ce,$9f,$c3,$99,$c3,'f<'
	dc.b	$0c,$98,$18,$f8,$18,$f8,$07,$07
	dc.b	'p',$02,$7f,$fe,$7f,$fe,$80,$01
	dc.b	'Y9',$f7,'9',$f7,'F',$08
	dc.b	$c2,'8',$cf,$fb,$cf,$fb,'0',$04
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dcb.w	26
	dc.b	$7f,$ff,$7f,$ff,$01,$f8,$00,$0f
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$00,'@',$ff,$80
	dc.b	$ff,$c0,$ff,$c0,$00,$00,$00,$00
	dcb.w	10
	dc.b	$01,'G',$03,$c7,$03,$c7,$00,'8'
	dc.b	$03,$8f,$03,$81,$03,$81,$f0,'~'
	dc.b	$07,$1f,$0f,$ff,$0f,$ff,$00,$00
	dc.b	$80,$01,$ff,$ff,$ff,$ff,$00,$00
	dc.b	'0',$c3,'p',$ff,'p',$ff,$0f,$00
	dc.b	$e0,$18,$e7,$f9,$e7,$f9,$18,$06
	dcb.w	17
	dc.b	$07,$ff,$0f,$ff,$0f,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$e0,$00,$e0,$00,$e0,$00,$00,$00
	dc.b	$00,$00,$7f,$ff,$7f,$ff,$01,$ec
	dc.b	$00,$07,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$c0,$ff,$c0,$ff,$c0,$00,$00
	dcb.w	51
	dc.b	$0f,$ff,$00,$00,$1f,$ff,$1f,$ff
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$e0,$00,$10,$00,$f0,$00,$f0,$00
	dcb.w	2
	dc.b	$7f,$ff,$7f,$ff,$01,$ee,$00,$03
	dc.b	$ff,$ff,$ff,$ff,'m',$b6,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$db,'@',$ff,$e0
	dc.b	$ff,$e0,$ff,$e0,$00,$00,$00,$00
	dcb.w	50
	dc.b	$08,$88,$07,'w',$1f,$ff,$1f,$ff
	dc.b	$89,'%v',$da,$ff,$ff,$ff,$ff
	dc.b	' ',$00,$d0,$00,$f0,$00,$f0,$00
	dcb.w	2
	dc.b	$7f,$ff,$7f,$ff,$01,$cf,$00,$01
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$ff,$f0
	dc.b	$ff,$f0,$ff,$f0,$00,$00,$00,$00
	dcb.w	50
	dc.b	$1f,$ff,$00,$00,'?',$ff,'?',$ff
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$f0,$00,$08,$00,$f8,$00,$f8,$00
	dcb.w	2
	dc.b	$7f,$ff,$7f,$ff,$01,$cf,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$b6,$db,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,'m',$a0,$ff,$f8
	dc.b	$ff,$f8,$ff,$f8,$00,$00,$00,$00
	dcb.w	14
	dc.b	$00,$10,$00,$10,$00,$10,$00,$10
	dcb.w	8
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dcb.w	20
	dc.b	$14,$92,$0b,'m?',$ff,'?',$ff
	dc.b	'I$',$b6,$db,$ff,$ff,$ff,$ff
	dc.b	$90,$00,'h',$00,$f8,$00,$f8,$00
	dcb.w	2
	dc.b	$7f,$ff,$7f,$ff,$01,$8f,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$c0,$00,$7f,$ff
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$ff,$fc
	dc.b	$ff,$fc,$ff,$fc,$00,$00,$00,$00
	dcb.w	50
	dc.b	'?',$ff,$00,$00,$7f,$ff,$7f,$ff
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$f8,$00,$04,$00,$fc,$00,$fc,$00
	dcb.w	2
	dc.b	$7f,$ff,$7f,$ff,$01,$8f,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$e6,$db,'?',$ff
	dc.b	$ff,$ff,$ff,$ff,'m',$b4,$ff,$fe
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dcb.w	50
	dc.b	'1',$13,$0e,$ec,$7f,$ff,$7f,$ff
	dc.b	'2%',$cd,$da,$ff,$ff,$ff,$ff
	dc.b	$18,$00,$e4,$00,$fc,$00,$fc,$00
	dcb.w	2
	dc.b	$7f,$ff,$7f,$ff,$01,$0f,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$f0,$00,$1f,$ff
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dcb.w	50
	dc.b	$7f,$ff,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$fc,$00,$02,$00,$fe,$00,$fe,$00
	dcb.w	2
	dc.b	$0f,$ff,$0f,$ff,$01,$0f,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$f9,$bf,$0f,$ff
	dc.b	$ff,$ff,$ff,$ff,$fd,$9b,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$80,$00
	dc.b	$80,$00,$80,$00,$00,$00,$00,$00
	dcb.w	46
	dc.b	'f',$00,$19,$ff,$ff,$ff,$ff,$ff
	dc.b	$02,'?',$fd,$c0,$ff,$ff,$ff,$ff
	dc.b	$0c,$00,$f2,$00,$fe,$00,$fe,$00
	dcb.w	2
	dc.b	$00,'?',$00,'?',$00,$0f,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$fc,$00,$07,$ff
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$c0,$00
	dc.b	$c0,$00,$c0,$00,$00,$00,$00,$00
	dcb.w	44
	dc.b	$00,$01,$00,$01,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$fe,$00,$01,$00
	dc.b	$ff,$00,$ff,$00,$00,$00,$00,$00
	dc.b	$00,$01,$00,$01,$00,$0f,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$fd,$ff,$02,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$e0,$00,$00,$00
	dc.b	$e0,$00,$e0,$00,$00,$00,$00,$00
	dcb.w	44
	dc.b	$00,$01,$00,$01,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$00,$ff,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$0f,$00,$00,$07,$ff,$07,$ff
	dc.b	$fb,$ff,$04,$00,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$c0,$00,$00,$00,$c0,$00,$c0,$00
	dcb.w	46
	dc.b	$00,$01,$00,$01,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$00,$ff,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$0f,$00,$00,$00,$0f,$00,$0f
	dc.b	$f7,$ff,$08,$00,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$80,$00,$00,$00,$80,$00,$80,$00
	dcb.w	50
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$02,$00,$02,$00,$00,$00,$00,$00
	dcb.w	79
	dc.b	$00,$04,$00,$08,$00,$0c,$00,$03
	dc.b	$00,$07,$00,$0b,$00,$0f,$00,$01
	dc.b	$00,$01,$00,$01,$00,$01,$00,$80
	dc.b	$00,'T',$00,'*',$00,$00
l0039	dc.b	$07,$ff,$06,$00,$08,$00,$09,$00
	dc.b	$0a,$00
l003a	dc.b	'`',$00,$00,'D`',$00,$00,'L'
	dc.b	'`',$00,$01,'*The '
	dc.b	'little m'
	dc.b	'uzak edi'
	dc.b	'tor by E'
	dc.b	'quinox/',$08
	dc.b	$02,$00,$00,$1f,'A',$f9,$00,$04
	dc.b	'J',$0e,$10,$c0,$10,$c0,$10,$fc
	dc.b	$00,$00,' _NuH',$e7
	dc.b	$ff,$fe,'aBL',$df,$7f,$ff
	dc.b	'NuH',$e7,$ff,$fe,'a',$06
	dc.b	'L',$df,$7f,$ff,'NuA',$f9
	dc.b	$00,$04,'J$al"y'
	dc.b	$00,$04,'J',$16,$02,$80,$00,$00
	dc.b	$00,$ff,$d0,'@',$d0,'@',$d2,$c0
	dc.b	'M',$f9,$00,$04,'I8<™'
	dc.b	'0',$19,$02,$80,$00,$00,$00,$ff
	dc.b	'a',$00,$06,$de,'NuA',$f9
	dc.b	$00,$04,'J$a<J@'
	dc.b	'g("y',$00,$04,'J',$12
	dc.b	$02,$80,$00,$00,$00,$ff,'S',$80
	dc.b	$c0,$fc,$00,$06,$d2,$c0,'0',$19
	dc.b	'2',$19,'M',$f9,$00,$04,'H '
	dc.b	'<',$d1,'<',$d9,'a',$00,$05,'Ž'
	dc.b	'NuA',$f9,$00,$04,'H$'
	dc.b	'0',$bc,$00,$01,'a',$00,$00,'f'
	dc.b	'Nu>9',$00,$04,'J '
	dc.b	'f',$00,$00,'X~',$00,'3',$fc
	dc.b	$00,'@',$00,$04,'I',$1e,'#',$fc
	dc.b	$00,$04,'J$',$00,$04,'I&'
	dc.b	'#',$fc,$00,$04,'K',$e4,$00,$04
	dc.b	'I*#',$fc,$00,$04,'M',$e0
	dc.b	$00,$04,'I"#',$fc,$00,$04
	dc.b	'S',$a0,$00,$04,'I.#',$fc
	dc.b	$00,$04,'V',$88,$00,$04,'J',$12
	dc.b	'#',$fc,$00,$04,'V',$94,$00,$04
	dc.b	'J',$16,'3',$fc,$00,$01,$00,$04
	dc.b	'J 3',$fc,$00,$00,$00,$04
	dc.b	'I:NuA',$f9,$00,$04
	dc.b	'J',$0e,'J',$10,'gHS('
	dc.b	$00,$01,'jB',$11,'P',$00,$01
	dc.b	'Rh',$00,$02,'0(',$00,$02
	dc.b	$0c,'@',$00,$0a,'f',$0e,'B',$90
	dc.b	'A',$f9,$00,$04,'H$0',$bc
	dc.b	$00,$01,'`"A',$f9,$00,$04
	dc.b	'I',$fc,$10,'0',$00,$00,'A',$f9
	dc.b	$00,$04,'HbC',$f9,$00,$04
	dc.b	'H',$a0,'E',$f9,$00,$04,'H',$da
	dc.b	$10,$80,$12,$80,$14,$80,'M',$f9
	dc.b	$00,$04,'G',$e4,'K',$f9,$00,$04
	dc.b	'H Jm',$00,$04,'g',$1a
	dc.b	'B.',$00,'"B.',$00,'&'
	dc.b	'B.',$00,'*L',$ee,$00,$0f
	dc.b	$00,$1c,'H',$f8,$00,$0f,$88,$00
	dc.b	'NuS]f ;',$15
	dc.b	'A',$f9,$00,$04,'H&a',$00
	dc.b	$00,$c8,'A',$f9,$00,$04,'Hd'
	dc.b	'a',$00,$00,$be,'A',$f9,$00,$04
	dc.b	'H',$a2,'a',$00,$00,$b4,'K',$f9
	dc.b	$00,$04,'I2A',$f9,$00,$04
	dc.b	'H&a',$00,$01,$ce,'?',$00
	dc.b	$1d,'_',$00,$06,$1d,'@',$00,$02
	dc.b	$1d,'A',$00,'"A',$f9,$00,$04
	dc.b	'Hda',$00,$01,$b6,'?',$00
	dc.b	$1d,'_',$00,$0e,$1d,'@',$00,$0a
	dc.b	$1d,'A',$00,'&A',$f9,$00,$04
	dc.b	'H',$a2,'a',$00,$01,$9e,'?',$00
	dc.b	$1d,'_',$00,$16,$1d,'@',$00,$12
	dc.b	$1d,'A',$00,'*0-',$00,$04
	dc.b	'gD?',$00,'A',$f9,$00,$04
	dc.b	'H',$e0,'a',$00,$01,'~"h'
	dc.b	$00,$0a,$d3,$e8,$00,$0e,$0c,')'
	dc.b	$00,$e1,$00,$01,'f',$04,'Bm'
	dc.b	$00,$04,'>',$1f,'C',$f9,$00,$04
	dc.b	'H',$10,$de,'G',$de,'G',$d2,$c7
	dc.b	'|',$00,$1c,$19,'?',$00,$1d,$80
	dc.b	'`',$00,$1c,$19,$1d,$9f,'`',$00
	dc.b	$1c,$19,$1d,$81,'`',$00,$1e,$1d
	dc.b	$00,$07,$00,$c0,$1d,'G',$00,$1e
	dc.b	$1d,']',$00,$1a,'L',$d6,$07,$ff
	dc.b	'H',$f8,$07,$ff,$88,$00,'Nu'
	dc.b	'z',$00,'|',$06,'>9',$00,$04
	dc.b	'I',$1e,'"h',$00,'"',$d3,$e8
	dc.b	$00,'&',$10,$11,$02,'@',$00,$7f
	dc.b	$0c,'@',$00,$01,'g',$08,$be,'h'
	dc.b	$00,'(f',$00,$00,'v&h'
	dc.b	$00,'4$P',$d5,$e8,$00,$04
	dc.b	$b5,$cb,'f',$06,'!E',$00,$04
	dc.b	'$Pr',$00,$12,$12,$11,'j'
	dc.b	$00,$01,$00,',',$11,'j',$00,$02
	dc.b	$00,$16,$10,'*',$00,$03,$14,$00
	dc.b	$02,'B',$00,$f0,$0c,$02,$00,$f0
	dc.b	'f',$00,$00,$0e,$14,$00,$02,$02
	dc.b	$00,$0f,$11,'B',$00,'<`',$10
	dc.b	$0c,$02,$00,$e0,'f',$0a,$14,$00
	dc.b	$02,'B',$00,$0f,';B',$00,$02
	dc.b	'!E',$00,'&',$c2,$c7,'&y'
	dc.b	$00,$04,'I"',$d7,$c1,'!K'
	dc.b	$00,'"',$06,$a8,$00,$00,$00,$0c
	dc.b	$00,$04,'"h',$00,'"',$d3,$e8
	dc.b	$00,'&',$10,$19,$12,$00,$02,'A'
	dc.b	$00,$7f,'JAg',$00,$00,'~'
	dc.b	'!E',$00,'8',$11,'A',$00,$08
	dc.b	'&IJ',$a8,$00,'&f',$02
	dc.b	$d6,$c7,$11,'k',$ff,$fe,$00,$1f
	dc.b	$11,'Q',$00,$09,'J',$00,'k\'
	dc.b	$12,$11,$02,'A',$00,$1f,$d2,'('
	dc.b	$00,$16,'$y',$00,$04,'I*'
	dc.b	$ed,'a',$d4,$c1,'!E',$00,$0e
	dc.b	$11,'R',$00,$17,$11,'Z',$00,$18
	dc.b	$12,$1a,$02,'A',$00,$ff,$11,'Z'
	dc.b	$00,$1b,$11,'|',$00,'@',$00,'.'
	dc.b	$10,$1a,$11,'@',$00,$1c,$11,'@'
	dc.b	$00,$1d,$11,'Z',$00,$1e,'!J'
	dc.b	$00,$0a,'$y',$00,$04,'I&'
	dc.b	$ed,'a',$d4,$c1,'!J',$00,$12
	dc.b	'!E',$00,'0',$11,'E',$00,$1a
	dc.b	$11,'E',$00,$19,'T',$a8,$00,'&'
	dc.b	'Nu~',$00,$11,'G',$00,' '
	dc.b	'J(',$00,$1a,'g',$08,'S('
	dc.b	$00,$1a,'`',$00,$01,$10,'"h'
	dc.b	$00,$12,$d3,$e8,$00,'0',$0c,$11
	dc.b	$00,$e1,'g',$00,$01,$00,$0c,$11
	dc.b	$00,$e0,'f',$14,$10,')',$00,$01
	dc.b	$02,$80,$00,$00,$00,'?!@'
	dc.b	$00,'0"h',$00,$12,$d3,$c0
	dc.b	$0c,$11,$00,$e2,'f',$10,'B',$a8
	dc.b	$00,$0e,$11,'|',$00,$01,$00,$17
	dc.b	'R',$a8,$00,'0`',$c0,$0c,$11
	dc.b	$00,$e9,'f',$00,$00,'.',$11,$fc
	dc.b	$00,$0b,$88,$00,$11,$e9,$00,$01
	dc.b	$88,$02,$11,$fc,$00,$0c,$88,$00
	dc.b	$11,$fc,$00,$00,$88,$02,$11,$fc
	dc.b	$00,$0d,$88,$00,$11,$fc,$00,$0a
	dc.b	$88,$02,'T',$a8,$00,'0`',$00
	dc.b	$ff,$8e,$0c,$11,$00,$e7,'f',$1e
	dc.b	$10,')',$00,$01,$02,'@',$00,$ff
	dc.b	$ed,'@"y',$00,$04,'I&'
	dc.b	$d2,$c0,'!I',$00,$12,'!G'
	dc.b	$00,'0`',$00,$ff,'r',$0c,$11
	dc.b	$00,$e8,'f',$0e,$11,'i',$00,$01
	dc.b	$00,$1a,'T',$a8,$00,'0`',$00
	dc.b	$ff,'H',$0c,$11,$00,$e4,'f',$10
	dc.b	$11,'G',$00,'*',$11,'i',$00,$01
	dc.b	$00,' T',$a8,$00,'0`<'
	dc.b	$0c,$11,$00,$e5,'f',$0e,$11,'|'
	dc.b	$00,$01,$00,'*R',$a8,$00,'0'
	dc.b	'`',$00,$ff,$1e,$0c,$11,$00,$e6
	dc.b	'f',$0c,$11,'|',$00,$02,$00,'*'
	dc.b	'R',$a8,$00,'0`',$16,$0c,$11
	dc.b	$00,$e3,'f',$10,'V',$a8,$00,'0'
	dc.b	$11,'i',$00,$01,$00,$1b,$11,'i'
	dc.b	$00,$02,$00,$1c,'"h',$00,$12
	dc.b	$d3,$e8,$00,'0',$11,'Q',$00,'+'
	dc.b	'R',$a8,$00,'0J(',$00,$19
	dc.b	'g',$06,'S(',$00,$19,'`N'
	dc.b	'S(',$00,$17,'fH',$11,'h'
	dc.b	$00,$18,$00,$17,'"h',$00,$0a
	dc.b	$d3,$e8,$00,$0e,$10,$11,$0c,$00
	dc.b	$00,$e8,'f',$0c,'T',$a8,$00,$0e
	dc.b	$11,'i',$00,$01,$00,$19,'`',$cc
	dc.b	$0c,$00,$00,$e1,'g ',$0c,$00
	dc.b	$00,$e0,'f',$12,$10,')',$00,$01
	dc.b	$02,$80,$00,$00,$00,'?[',$80
	dc.b	'!@',$00,$0e,'`',$c6,$11,'Q'
	dc.b	$00,'-R',$a8,$00,$0e,$10,'('
	dc.b	$00,'+k',$08,$d0,'(',$00,$08
	dc.b	$d0,'(',$00,',',$02,'@',$00,$7f
	dc.b	'C',$f9,$00,$04,'I<',$d0,'@'
	dc.b	'2',$00,$d2,$c0,'0',$11,$16,'('
	dc.b	$00,'!',$14,'(',$00,'*',$02,$82
	dc.b	$00,$00,$00,$0f,'f',$08,$07,$95
	dc.b	'VC',$07,$95,'`.',$0c,$02
	dc.b	$00,$01,'f"',$07,$d5,'VC'
	dc.b	$07,$95,$11,'h',$00,$08,$00,' '
	dc.b	$18,'(',$00,'+j',$0a,$02,$04
	dc.b	$00,$7f,$11,'D',$00,' `',$0c
	dc.b	$d9,'(',$00,' `',$06,$07,$95
	dc.b	'VC',$07,$d5,'J(',$00,' '
	dc.b	'g',$10,$16,'(',$00,' ',$02,$03
	dc.b	$00,$1f,$0a,$03,$00,$1f,$1b,'C'
	dc.b	$00,$01,$1e,'(',$00,'.J('
	dc.b	$00,$1e,'g',$06,'S(',$00,$1e
	dc.b	'`V',$1a,$01,$18,'(',$00,$1c
	dc.b	$d8,$04,$12,'(',$00,$1d,'J',$07
	dc.b	'j',$06,$08,$07,$00,$00,'f&'
	dc.b	$08,$07,$00,$05,'f',$0e,$92,'('
	dc.b	$00,$1b,'d',$16,$08,$c7,$00,$05
	dc.b	'r',$00,'`',$0e,$d2,'(',$00,$1b
	dc.b	$b2,$04,'e',$06,$08,$87,$00,$05
	dc.b	$12,$04,$11,'A',$00,$1d,$e2,$0c
	dc.b	$92,$04,'d',$04,$04,'A',$01,$00
	dc.b	$06,$05,$00,$a0,'e',$08,$d2,'A'
	dc.b	$06,$05,$00,$18,'d',$f8,$d0,'A'
	dc.b	$0a,$07,$00,$01,$11,'G',$00,'.'
	dc.b	$08,'(',$00,$05,$00,$09,'g',$00
	dc.b	$00,$1e,'~',$00,'2',$07,$12,'('
	dc.b	$00,$1f,'H$(',$00,'8'
	dc.b	'v',$0c,$e7,$a1,$d4,$81,'!B'
	dc.b	$00,'8HB',$90,'B',$12,'('
	dc.b	$00,'-',$92,'(',$00,'<j',$02
	dc.b	'r',$00,'NuA',$f9,$00,$04
	dc.b	'J',$0e,'B',$90,'.',$00,$ce,$fc
	dc.b	$00,$0c,',',$01,'R',$86,$cc,$fc
	dc.b	$00,$0c,'p',$02,'A',$f9,$00,$04
	dc.b	'H&C',$f9,$00,$04,'G',$d8
	dc.b	'E',$f9,$00,$04,'G',$e0,'!I'
	dc.b	$00,$0a,'B',$a8,$00,$0e,$11,'|'
	dc.b	$00,$00,$00,'-B(',$00,$08
	dc.b	'B(',$00,$09,'!I',$00,$12
	dc.b	'B',$a8,$00,'0',$11,'|',$00,$01
	dc.b	$00,$17,$11,'|',$00,$01,$00,$18
	dc.b	'B(',$00,$19,'B(',$00,$1a
	dc.b	'B(',$00,$1b,'B(',$00,$1c
	dc.b	'B(',$00,$1d,'Bh',$00,$1e
	dc.b	'B(',$00,' ',$16,$12,$02,$83
	dc.b	$00,$00,$00,$0f,$d6,'C',$d6,'C'
	dc.b	$11,'Z',$00,'! ',$b9,$00,$04
	dc.b	'I.!y',$00,$04,'I.'
	dc.b	$00,'4',$dd,$a8,$00,'4',$d7,$a8
	dc.b	$00,'4',$df,$90,$d7,$90,'!|'
	dc.b	$00,$00,$00,$0c,$00,$04,'&P'
	dc.b	$12,$13,$02,$81,$00,$00,$00,$ff
	dc.b	'49',$00,$04,'I',$1e,$c4,$c1
	dc.b	'(y',$00,$04,'I"',$d9,$c2
	dc.b	'!L',$00,'"B',$a8,$00,'&'
	dc.b	$11,'|',$00,$02,$00,'*',$11,'k'
	dc.b	$00,$01,$00,',B(',$00,'+'
	dc.b	$11,'k',$00,$02,$00,$16,'B('
	dc.b	$00,'<',$12,'+',$00,$03,$02,'A'
	dc.b	$00,$f0,$0c,'A',$00,$f0,'f',$00
	dc.b	$00,$0e,$12,'+',$00,$03,$02,$01
	dc.b	$00,$0f,$11,'A',$00,'<B('
	dc.b	$00,'-Bh',$00,'8',$d1,$fc
	dc.b	$00,$00,$00,'>Q',$c8,$ff,' '
	dc.b	'A',$f9,$00,$04,'H 0',$a8
	dc.b	$00,$02,'Bh',$00,$04,'Nu'
	dc.b	'49',$00,$04,'I829'
	dc.b	$00,$04,'I:JBg',$00
	dc.b	$00,'|A',$f9,$00,$04,'H',$e0
	dc.b	'K',$f9,$00,$04,'I2',$11,'B'
	dc.b	$00,$08,$11,'A',$00,'!B('
	dc.b	$00,$16,'|',$06,'z',$00,$02,'@'
	dc.b	$00,$1f,'$y',$00,$04,'I*'
	dc.b	$ed,'`',$d4,$c0,'!E',$00,$0e
	dc.b	$11,'R',$00,$17,$11,'Z',$00,$18
	dc.b	$10,$1a,$02,'@',$00,$ff,$11,'Z'
	dc.b	$00,$1b,'t',$00,$11,'|',$00,'@'
	dc.b	$00,'.',$14,$1a,$11,'B',$00,$1c
	dc.b	$11,'B',$00,$1d,$11,'Z',$00,$1e
	dc.b	'!J',$00,$0a,'$y',$00,$04
	dc.b	'I&',$ed,'`',$d4,$c0,'!J'
	dc.b	$00,$12,'!E',$00,'0B('
	dc.b	$00,$19,'B(',$00,$1a,'RA'
	dc.b	';A',$00,$04,'Nu',$00,$00
	dc.b	$00,$00,$01,$00,$00,$00,$00,$00
	dc.b	$00,$e1,$00,$01,$02,$00,$00,$00
	dc.b	'G',$00,$01,$01,$06,$00,$02,$02
	dc.b	$ec,$00,$03,$03,$05,$00,$04,$04
	dc.b	'(',$00,$05,$05,$01,$00,$06,$06
	dc.b	$0c,$00,$07,$07,$f8,$ff,$08,$08
	dc.b	$0e,$00,$09,$09,$0f,$00,$0a,$0a
	dc.b	$0d,$00,$00,$00,$00,$00,$02,$06
	dc.b	'"',$00,$0a,$0e,'&',$00,$12,$16
	dc.b	'*',$00,$00,$01,$00,$04,$00,$00
	dc.b	$00,$04,'S',$a0,$00,$00,$01,','
	dc.b	$0f,$01,$00,$04,'L)',$00,$00
	dc.b	$00,$02,$00,$04,'Jd',$00,$03
	dc.b	$03,$00,$00,$02,$03,$03,$00,$00
	dc.b	$00,$00,$00,$04,'N ',$00,$00
	dc.b	$00,'*',$02,$00,$00,$0e,'@',$00
	dc.b	$00,$00,$00,$04,$00,$04,'V',$88
	dcb.w	3
	dc.b	$00,$04,'S',$a4,$00,$00,$01,','
	dc.b	$10,$02,$00,$04,'Li',$00,$00
	dc.b	$00,$04,$00,$04,'J',$a4,$00,$01
	dc.b	$01,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$01,$00,$04,'Q ',$00,$00
	dc.b	$00,',',$02,$8c,$00,$0f,'A',$00
	dc.b	$00,$00,$00,$08,$00,$04,'V',$8c
	dcb.w	3
	dc.b	$00,$04,'S',$a8,$00,$00,$01,','
	dc.b	',',$05,$00,$04,'M)',$00,$00
	dc.b	$00,$02,$00,$04,'Jd',$00,$01
	dc.b	$01,$00,$00,$01,$02,$01,$00,$00
	dc.b	$00,$02,$00,$04,'M',$e0,$00,$00
	dc.b	$00,',',$02,$00,$00,$0d,'a',$00
	dc.b	$00,$00,$00,$04,$00,$04,'V',$90
	dcb.w	34
	dc.b	$00,'@',$00,$00,$00,$04,'M',$e0
	dc.b	$00,$04,'J$',$00,$04,'K',$e4
	dc.b	$00,$04,'S',$a0,'8',$0c,$00,$00
	dcb.w	3
	dc.b	$0e,$ee,$0e,$17,$0d,'M',$0c,$8e
	dc.b	$0b,$d9,$0b,'/',$0a,$8e,$09,$f7
	dc.b	$09,'g',$08,$e0,$08,'a',$07,$e8
	dc.b	$07,'w',$07,$0b,$06,$a6,$06,'G'
	dc.b	$05,$ec,$05,$97,$05,'G',$04,$fb
	dc.b	$04,$b3,$04,'p',$04,'0',$03,$f4
	dc.b	$03,$bb,$03,$85,$03,'S',$03,'#'
	dc.b	$02,$f6,$02,$cb,$02,$a3,$02,'}'
	dc.b	$02,'Y',$02,'8',$02,$18,$01,$fa
	dc.b	$01,$dd,$01,$c2,$01,$a9,$01,$91
	dc.b	$01,'{',$01,'e',$01,'Q',$01,'>'
	dc.b	$01,',',$01,$1c,$01,$0c,$00,$fd
	dc.b	$00,$ee,$00,$e1,$00,$d4,$00,$c8
	dc.b	$00,$bd,$00,$b2,$00,$a8,$00,$9f
	dc.b	$00,$96,$00,$8e,$00,$86,$00,'~'
	dc.b	$00,'w',$00,'p',$00,'j',$00,'d'
	dc.b	$00,'^',$00,'Y',$00,'T',$00,'O'
	dc.b	$00,'K',$00,'G',$00,'C',$00,'?'
	dc.b	$00,';',$00,'8',$00,'5',$00,'2'
	dc.b	$00,'/',$00,',',$00,'*',$00,$27
	dc.b	$00,'%',$00,'#',$00,'!',$00,$1f
	dc.b	$00,$1d,$00,$1c,$00,$1a,$00,$19
	dc.b	$00,$17,$00,$16,$00,$15,$00,$13
	dc.b	$00,$12,$00,$11,$00,$10,$00,$0f
	dc.b	$00,$01,$02,$03,$04,$05,$06,$07
	dc.b	$08,$09,$0a,$0b,$0f,$0f,$0f,$0f
	dc.b	$0f,$0f,$00,$00,$00,$00,$00,$04
	dc.b	'V',$88,$00,$04,'V',$94,$00,$00
	dcb.w	2
	dc.b	$00,$01,$00,$00,$e2,$e6,$0c,$09
	dcb.w	3
	dc.b	$e0,$02,$00,$00,$00,$00,$00,$00
	dcb.w	23
	dc.b	$e2,$e6,$0c,$00,$e1,$00,$00,$00
	dcb.w	28
	dc.b	$e2,$e5,$93,$e6,$97,$94,$90,$8c
	dc.b	$88,$8d,$8c,$8b,$8d,$8e,$e0,$07
	dcb.w	24
	dc.b	$e2,$e5,$93,$e6,$9e,$9f,$e4,$95
	dc.b	$9e,$9d,$9c,$9b,$9a,$e0,$09,$00
	dcb.w	24
	dc.b	$e2,$e5,$9f,$e1,$00,$00,$00,$00
	dcb.w	28
	dc.b	$e2,$e6,$00,$e1,$00,$00,$00,$00
	dcb.w	28
	dc.b	$e2,$e5,$9f,$e6,$00,$e1,$00,$00
	dcb.w	28
	dc.b	$03,$00,$01,$02,$03,$0f,$0e,$0d
	dc.b	$0c,$0b,$0a,$09,$08,$07,$06,$05
	dc.b	$04,$03,$02,$01,$00,$e1,$00,$00
	dcb.w	20
	dc.b	$03,$01,$02,$03,$04,$0f,$0e,$0d
	dc.b	$0c,$0b,$0a,$09,$08,$07,$06,$05
	dc.b	$04,$03,$02,$01,$00,$e1,$00,$00
	dcb.w	20
	dc.b	$01,$02,$00,$00,$00,$0d,$0f,$0f
	dc.b	$0f,$0f,$0f,$00,$e1,$00,$00,$00
	dcb.w	24
	dc.b	$01,$03,$00,$00,$00,$0d,$0f,$0f
	dc.b	$0f,$0f,$0e,$0d,$0c,$0b,$0a,$09
	dc.b	$08,$07,$06,$05,$04,$03,$02,$01
	dc.b	$e1,$00,$00,$00,$00,$00,$00,$00
	dcb.w	16
	dc.b	$01,$04,$00,$00,$00,$0d,$00,$e1
	dcb.w	28
	dc.b	$01,$01,$01,$02,$00,$0e,$0d,$e1
	dcb.w	28
	dc.b	$02,$05,$01,$02,$00,$0d,$0c,$0b
	dc.b	$0a,$09,$08,$07,$06,$05,$04,$03
	dc.b	$02,$01,$00,$e1,$00,$00,$00,$00
	dcb.w	20
	dc.b	$01,$06,$02,$02,$03,$0d,$0f,$0e
	dc.b	$0e,$0d,$0c,$0c,$0c,$0b,$0a,$09
	dc.b	$08,$07,$06,$05,$04,$03,$02,$01
	dc.b	$00,$e1,$00,$00,$00,$00,$00,$00
	dcb.w	46
	dc.b	$0f,$01,$00,$00,$0f,$01,$00,$00
	dcb.w	2
	dc.b	$0f,$01,$00,$00,'3',$01,$00,$00
	dcb.w	2
	dc.b	$0f,$01,$00,$00,$0f,$01,$00,$00
	dcb.w	2
	dc.b	$0f,$01,$00,$00,$0f,$01,$00,$00
	dcb.w	2
	dc.b	'3',$01,$00,$00,$00,$00,$00,$01
	dc.b	'1',$01,$00,$00,'3',$01,$00,$00
	dc.b	$0d,$01,$00,$00,$0d,$01,$00,$00
	dcb.w	2
	dc.b	$0d,$01,$00,$00,'1',$01,$00,$00
	dcb.w	2
	dc.b	$0d,$01,$00,$00,$0d,$01,$00,$00
	dcb.w	2
	dc.b	$0d,$01,$00,$00,$0d,$01,$00,$00
	dcb.w	2
	dc.b	'1',$01,$00,$00,$00,$00,$00,$00
	dc.b	'/',$01,$00,$00,'1',$01,$00,$00
	dc.b	$0b,$01,$00,$00,$0b,$01,$00,$00
	dcb.w	2
	dc.b	$0b,$01,$00,$00,'/',$01,$00,$00
	dcb.w	2
	dc.b	$0b,$01,$00,$00,$0b,$01,$00,$00
	dcb.w	2
	dc.b	$0b,$01,$00,$00,$0b,$01,$00,$00
	dcb.w	2
	dc.b	'/',$01,$00,$00,$00,$00,$00,$00
	dc.b	'-',$01,$00,$00,'/',$01,$00,$00
	dc.b	$08,$01,$00,$00,$08,$01,$00,$00
	dcb.w	2
	dc.b	$08,$01,$00,$00,',',$01,$00,$00
	dcb.w	2
	dc.b	$08,$01,$00,$00,$08,$01,$00,$00
	dcb.w	2
	dc.b	$08,$01,$00,$00,$08,$01,$00,$00
	dcb.w	2
	dc.b	',',$01,$00,$00,$00,$00,$00,$00
	dc.b	'*',$01,$00,$00,',',$01,$00,$00
	dc.b	'*',$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	')',$05,$00,$00,$00,$00,$00,$00
	dcb.w	8
	dc.b	$27,$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	'%',$05,$00,$00,$00,$00,$00,$00
	dcb.w	32
	dc.b	'*',$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	')',$05,$00,$00,$00,$00,$00,$00
	dcb.w	8
	dc.b	'.',$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	',',$05,$00,$00,$00,$00,$00,$00
	dc.b	$0f,$00,$00,$00,$0f,$00,$00,$00
	dcb.w	2
	dc.b	$0f,$00,$00,$00,$0f,$00,$00,$00
	dcb.w	2
	dc.b	$0f,$00,$00,$00,$0f,$00,$00,$00
	dcb.w	2
	dc.b	$0f,$00,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$0f,$00,$00,$00,$00,$00,$00,$00
	dc.b	$0f,$00,$00,$00,$0f,$00,$00,$00
	dc.b	$0d,$00,$00,$00,$0d,$00,$00,$00
	dcb.w	2
	dc.b	$0d,$00,$00,$00,$0d,$00,$00,$00
	dcb.w	2
	dc.b	$0d,$00,$00,$00,$0d,$00,$00,$00
	dcb.w	2
	dc.b	$0d,$00,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$0d,$00,$00,$00,$00,$00,$00,$00
	dc.b	$0d,$00,$00,$00,$0d,$00,$00,$00
	dc.b	$0b,$00,$00,$00,$0b,$00,$00,$00
	dcb.w	2
	dc.b	$0b,$00,$00,$00,$0b,$00,$00,$00
	dcb.w	2
	dc.b	$0b,$00,$00,$00,$0b,$00,$00,$00
	dcb.w	2
	dc.b	$0b,$00,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$0b,$00,$00,$00,$00,$00,$00,$00
	dc.b	$0b,$00,$00,$00,$0b,$00,$00,$00
	dc.b	$08,$00,$00,$00,$08,$00,$00,$00
	dcb.w	2
	dc.b	$08,$00,$00,$00,$08,$00,$00,$00
	dcb.w	2
	dc.b	$08,$00,$00,$00,$08,$00,$00,$00
	dcb.w	2
	dc.b	$08,$00,$00,$00,$08,$00,$00,$00
	dcb.w	2
	dc.b	$08,$00,$00,$00,$00,$00,$00,$00
	dc.b	$08,$00,$00,$00,$08,$00,$00,$00
	dc.b	$10,$02,$00,$00,$10,$02,$00,$00
	dcb.w	2
	dc.b	$10,$02,$00,$00,$15,$03,$00,$00
	dcb.w	4
	dc.b	$10,$02,$00,$00,$00,$00,$00,$00
	dc.b	$10,$02,$00,$00,$10,$02,$00,$00
	dcb.w	2
	dc.b	$15,$03,$00,$00,$00,$00,$00,$00
	dc.b	$15,$03,$00,$00,$15,$03,$00,$00
	dc.b	$10,$02,$00,$00,$10,$02,$00,$00
	dcb.w	2
	dc.b	$10,$02,$00,$00,$15,$03,$00,$00
	dcb.w	4
	dc.b	$10,$02,$00,$00,$00,$00,$00,$00
	dc.b	$10,$02,$00,$00,$10,$02,$00,$00
	dcb.w	2
	dc.b	$15,$03,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$15,$03,$00,$00,'3',$01,$00,$00
	dcb.w	10
	dc.b	'1',$01,$00,$00,$00,$00,$00,$00
	dcb.w	8
	dc.b	'.',$01,$00,$00,$00,$00,$00,$00
	dcb.w	8
	dc.b	',',$01,$00,$00,'.',$01,$00,$00
	dc.b	'1',$01,$00,$00,',',$01,$00,$00
	dc.b	'.',$01,$00,$00,'1',$01,$00,$00
	dcb.w	4
	dc.b	',',$01,$00,$00,'-',$01,$00,$00
	dc.b	',',$01,$00,$00,'*',$01,$00,$00
	dc.b	$27,$01,$00,$00,'%',$01,$00,$00
	dc.b	'*',$01,$00,$00,$27,$01,$00,$00
	dcb.w	28
	dc.b	$15,$02,$00,$00,$00,$00,$00,$00
	dc.b	$15,$02,$00,$00,$00,$00,$00,$00
	dc.b	$15,$03,$00,$00,$15,$03,$00,$00
	dc.b	$15,$03,$00,$00,$15,$03,$00,$00
	dc.b	$15,$03,$00,$00,$15,$03,$00,$00
	dc.b	$15,$03,$00,$00,$15,$03,$00,$00
	dc.b	$15,$03,$00,$00,$15,$03,$00,$00
	dc.b	$15,$03,$00,$00,$15,$03,$00,$00
	dc.b	'.',$05,$00,$00,$00,$00,$00,$00
	dcb.w	28
	dc.b	'3',$05,$00,$00,$00,$00,$00,$00
	dcb.w	8
	dc.b	'5',$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	'6',$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	'5',$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	'3',$05,$00,$00,$00,$00,$00,$00
	dcb.w	12
	dc.b	'1',$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	'.',$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	',',$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	'.',$05,$00,$00,$00,$00,$00,$00
	dc.b	',',$05,$00,$00,$00,$00,$00,$00
	dc.b	'3',$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	'.',$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	',',$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	'.',$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	',',$05,$00,$00,$00,$00,$00,$00
	dcb.w	8
	dc.b	$01,$00,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$02,$00,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$03,$00,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$04,$00,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$01,$00,$00,$00,$05,$00,$00,$00
	dcb.w	2
	dc.b	$02,$00,$00,$00,$06,$00,$00,$00
	dcb.w	2
	dc.b	$03,$00,$00,$00,$07,$00,$00,$00
	dcb.w	2
	dc.b	$04,$00,$00,$00,$00,$00,$00,$00
	dc.b	$0c,$00,$00,$00,$08,$00,$00,$00
	dcb.w	2
	dc.b	$0c,$00,$00,$00,$09,$00,$00,$00
	dcb.w	2
	dc.b	$0d,$00,$00,$00,$0a,$00,$00,$00
	dcb.w	2
	dc.b	$0d,$00,$00,$00,$0b,$00,$00,$00
	dcb.w	2
	dc.b	$0c,$00,$00,$00,$08,$00,$00,$00
	dc.b	$0c,$00,$00,$00,$00,$00,$00,$00
	dc.b	$09,$00,$00,$00,$0d,$00,$00,$00
	dcb.w	2
	dc.b	$0a,$00,$00,$00,$0c,$00,$00,$00
	dcb.w	2
	dc.b	$0b,$00,$00,$00,$0d,$00,$00,$00
	dcb.w	2
	dc.b	$01,$00,$00,$00,$0c,$00,$00,$00
	dcb.w	2
	dc.b	$02,$00,$00,$00,$0d,$00,$00,$00
	dcb.w	2
	dc.b	$03,$00,$00,$00,$0d,$00,$00,$00
	dcb.w	2
	dc.b	$04,$00,$00,$00,$0c,$00,$00,$00
	dcb.w	2
	dc.b	$01,$00,$00,$00,$0c,$00,$00,$00
	dc.b	$05,$00,$00,$00,$02,$00,$00,$00
	dc.b	$0d,$00,$00,$00,$06,$00,$00,$00
	dc.b	$03,$00,$00,$00,$0d,$00,$00,$00
	dc.b	$07,$00,$00,$00,$04,$00,$00,$00
	dc.b	$0c,$00,$00,$00,$00,$00,$00,$00
	dc.b	$01,$00,$00,$00,$0d,$00,$00,$00
	dcb.w	2
	dc.b	$02,$00,$00,$00,$0d,$00,$00,$00
	dcb.w	2
	dc.b	$03,$00,$00,$00,$0c,$00,$00,$00
	dcb.w	2
	dc.b	$04,$00,$00,$00,$0c,$00,$00,$00
	dcb.w	2
	dc.b	$08,$00,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$09,$00,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$0a,$00,$00,$00,$00,$00,$00,$00
	dc.b	$12,$00,$00,$00,$0b,$00,$00,$00
	dc.b	$11,$00,$00,$00,$00,$00,$00,$00
	dc.b	$08,$00,$00,$00,$0c,$00,$00,$00
	dc.b	$0e,$00,$00,$00,$09,$00,$00,$00
	dc.b	$0d,$00,$00,$00,$0f,$00,$00,$00
	dc.b	$0a,$00,$00,$00,$0d,$00,$00,$00
	dc.b	$10,$00,$00,$00,$0b,$00,$00,$00
	dc.b	$0c,$00,$00,$00,$00,$00,$00,$00
	dc.b	$08,$00,$00,$00,$0d,$00,$00,$00
	dc.b	$0e,$00,$00,$00,$09,$00,$00,$00
	dc.b	$0c,$00,$00,$00,$0f,$00,$00,$00
	dc.b	$0a,$00,$00,$00,$0c,$00,$00,$00
	dc.b	$10,$00,$00,$00,$00,$00,$00,$00
	dc.b	$0d,$00,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$0c,$00,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$0d,$00,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$0c,$00,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$11,$00,$00,$00,$00,$00,$00,$00
	dc.b	$08,$00,$00,$00,$0c,$00,$00,$00
	dc.b	$13,$00,$00,$00,$09,$00,$00,$00
	dc.b	$0d,$00,$00,$00,$14,$00,$00,$00
	dc.b	$0a,$00,$00,$00,$0d,$00,$00,$00
	dc.b	$15,$00,$00,$00,$0a,$00,$00,$00
	dc.b	$0c,$00,$00,$00,$00,$00,$00,$00
	dc.b	$01,$00,$00,$00,$00,$00,$00,$00
	dc.b	$13,$00,$00,$00,$02,$00,$00,$00
	dcb.w	2
	dc.b	$14,$00,$00,$00,$03,$00,$00,$00
	dcb.w	2
	dc.b	$15,$00,$00,$00,$04,$00,$00,$00
	dcb.w	2
	dc.b	$0c,$00,$00,$00,$08,$00,$00,$00
	dcb.w	2
	dc.b	$13,$00,$00,$00,$09,$00,$00,$00
	dcb.w	2
	dc.b	$14,$00,$00,$00,$0c,$00,$00,$00
	dcb.w	2
	dc.b	$15,$00,$00,$00,$0d,$00,$00,$00
	dcb.w	4
	dc.b	$0c,$00,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$04,$00,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$01,$00,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$02,$00,$00,$00,$00,$00,$00,$00
	dc.b	$12,$00,$00,$00,$03,$00,$00,$00
	dcb.w	4
	dc.b	$04,$00,$00,$00,$00,$00,$00,$00
	dc.b	$11,$00,$00,$00,$00,$00,$00,'='
	dc.b	$00,$04,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$00,$04,$b2,$b0,$00,$04,$b2,$d8
	dc.b	$00,$04,$b3,$00,$00,$04,$b3,'('
	dc.b	$00,$04,$e4,$b0,$00,$04,$e4,$d8
	dc.b	$00,$04,$e5,$00,$00,$04,$e5,'('
	dc.b	$00,$05,$17,'r',$00,$05,$17,$9a
	dc.b	$00,$05,$17,$c2,$00,$05,$17,$ea
	dc.b	$00,$05,'Ir',$00,$05,'I',$9a
	dc.b	$00,$05,'I',$c2,$00,$05,'I',$ea
	dc.b	$00,$05,'I',$ea,$00,$05,'I',$c2
	dc.b	$00,$05,'I',$9a,$00,$05,'Ir'
	dc.b	$00,$05,$17,$ea,$00,$05,$17,$c2
	dc.b	$00,$05,$17,$9a,$00,$05,$17,'r'
	dc.b	$00,$04,$e5,'(',$00,$04,$e5,$00
	dc.b	$00,$04,$e4,$d8,$00,$04,$e4,$b0
	dc.b	$00,$04,$b3,'(',$00,$04,$b3,$00
	dc.b	$00,$04,$b2,$d8,$00,$04,$b2,$b0
	dc.b	$00,$00,$00,$01,$00,$07,$00,$01
	dc.b	$00,$07,$00,$01,$00,$07,$00,$01
	dc.b	$00,$07,$00,$01,$00,$07,$00,$01
	dc.b	$00,$07,$00,$01,$00,$07,$00,$01
	dc.b	$00,$07,$00,$01,$00,$07,$00,$01
	dc.b	$00,$07,$00,$01,$00,$07,$00,$01
	dc.b	$00,$07,$00,$01,$00,$07,$00,$01
	dc.b	$00,$07,$00,$01,$00,$07,$00,$01
	dc.b	$00,$07,$00,$01,$00,$07,$00,$01
	dc.b	$00,$07,$00,$01,$00,$07,$00,$01
	dc.b	$04,'g',$00,$01,$00,$07,$00,$01
	dc.b	$00,$00,$00,$01,$00,$02,$00,$03
	dc.b	$00,$04,$00,$05,$00,$06,$00,$07
	dc.b	$00,$08,$00,$09,$00,$0a,$00,$0b
	dc.b	$00,$0c,$00,$0d,$00,$0e,$00,$0f
	dc.b	$00,$10,$00,$11,$00,$12,$00,$13
	dc.b	$00,$14,$00,$15,$00,$16,$00,$17
	dc.b	$00,$18,$00,$19,$00,$1a,$00,$1b
	dc.b	$00,$1c,$00,$1d,$00,$1e,$00,$1f
	dc.b	$00,' ',$00,'!',$00,'"',$00,'#'
	dc.b	$00,'$',$00,'%',$00,'&',$00,$27
	dc.b	$00,'(',$00,')',$00,'*',$00,'+'
	dcb.w	2
	dc.b	$07,$7f,$02,'"',$03,'3',$04,'D'
	dc.b	$05,']',$06,'n',$07,$ff,$07,$00
	dc.b	$07,'P',$06,'p',$00,'p',$00,'^'
	dc.b	$01,'?',$06,$07,$07,$ff,$1f,$f8
	dcb.w	3
	dc.b	$1e,$f8,$00,$00,$00,$00,$00,$00
	dc.b	$1e,$1f,$00,$00,$00,$00,$00,$00
	dc.b	$1e,$c3,$00,$00,$00,$00,$00,$00
	dc.b	'<',$0f,$00,$00,$00,$00,$00,$00
	dc.b	$ce,$c0,$00,$00,$00,$00,$00,$00
	dc.b	$c1,$f8,$00,$00,$00,$00,$00,$00
	dc.b	$f8,$f8,$00,$00,$00,$00,$00,$00
	dc.b	$f8,$f8,$00,$00,$00,$00,$00,$00
	dc.b	$1f,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$c3,$c3,$00,$00,$00,$00,$00,$00
	dc.b	$c3,$c3,$00,$00,$00,$00,$00,$00
	dc.b	$c3,$ff,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$00,$18,$00,$00,$00,$00,$00,$00
	dc.b	$18,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$18,$f8,$00,$00,$00,$00,$00,$00
	dc.b	$f8,$c0,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$1e,$00,$00,$00,$00,$00,$00
	dc.b	$ff,'~',$00,$00,$00,$00,$00,$00
	dc.b	'?',$fc,$00,$00,$00,$00,$00,$00
	dc.b	'>',$fc,$00,$00,$00,$00,$00,$00
	dc.b	'>?',$00,$00,$00,$00,$00,$00
	dc.b	'>',$c3,$00,$00,$00,$00,$00,$00
	dc.b	'<',$0f,$00,$00,$00,$00,$00,$00
	dc.b	$dc,$c0,$00,$00,$00,$00,$00,$00
	dc.b	$e3,$fc,$00,$00,$00,$00,$00,$00
	dc.b	$fc,$fc,$00,$00,$00,$00,$00,$00
	dc.b	$fc,$fc,$00,$00,$00,$00,$00,$00
	dc.b	'?',$ff,$00,$00,$00,$00,$00,$00
	dc.b	$c3,$c3,$00,$00,$00,$00,$00,$00
	dc.b	$c3,'f',$00,$00,$00,$00,$00,$00
	dc.b	$e7,$fe,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$00,$18,$00,$00,$00,$00,$00,$00
	dc.b	$18,$ff,$00,$00,$00,$00,$00,$00
	dc.b	'8',$fc,$00,$00,$00,$00,$00,$00
	dc.b	$fc,$e6,$00,$00,$00,$00,$00,$00
	dc.b	$ff,'>',$00,$00,$00,$00,$00,$00
	dc.b	$ff,'~',$00,$00,$00,$00,$00,$00
	dc.b	's',$ce,$00,$00,$00,$00,$00,$00
	dc.b	'p',$ce,$00,$00,$00,$00,$00,$00
	dc.b	'`p',$00,$00,$00,$00,$00,$00
	dc.b	'p',$c3,$00,$00,$00,$00,$00,$00
	dc.b	$18,$03,$00,$00,$00,$00,$00,$00
	dc.b	$f8,$c0,$00,$00,$00,$00,$00,$00
	dc.b	$f7,$ce,$00,$00,$00,$00,$00,$00
	dc.b	$ce,$ce,$00,$00,$00,$00,$00,$00
	dc.b	$ce,$ce,$00,$00,$00,$00,$00,$00
	dc.b	'p',$18,$00,$00,$00,$00,$00,$00
	dc.b	$c3,$c3,$00,$00,$00,$00,$00,$00
	dc.b	$c3,'<',$00,$00,$00,$00,$00,$00
	dc.b	'f',$0c,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$00,$10,$00,$00,$00,$00,$00,$00
	dc.b	$18,$c7,$00,$00,$00,$00,$00,$00
	dc.b	'8',$0e,$00,$00,$00,$00,$00,$00
	dc.b	$0e,'v',$00,$00,$00,$00,$00,$00
	dc.b	$80,'p',$00,$00,$00,$00,$00,$00
	dc.b	$03,'f',$00,$00,$00,$00,$00,$00
	dc.b	$e3,$dc,$00,$00,$00,$00,$00,$00
	dc.b	$e0,$c7,$00,$00,$00,$00,$00,$00
	dc.b	$f8,$fc,$00,$00,$00,$00,$00,$00
	dc.b	$e7,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$18,$07,$00,$00,$00,$00,$00,$00
	dc.b	$f0,$c0,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$c7,$00,$00,$00,$00,$00,$00
	dc.b	$c7,$c7,$00,$00,$00,$00,$00,$00
	dc.b	$c7,$c7,$00,$00,$00,$00,$00,$00
	dc.b	$fe,$18,$00,$00,$00,$00,$00,$00
	dc.b	$e3,$e7,$00,$00,$00,$00,$00,$00
	dc.b	$d3,$18,$00,$00,$00,$00,$00,$00
	dc.b	'<',$18,$00,$00,$00,$00,$00,$00
	dc.b	$00,$18,$00,$00,$00,$00,$00,$00
	dc.b	$00,' ',$00,$00,$00,$00,$00,$00
	dc.b	$18,$0e,$00,$00,$00,$00,$00,$00
	dc.b	$18,$ff,$00,$00,$00,$00,$00,$00
	dc.b	'??',$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	'?~',$00,$00,$00,$00,$00,$00
	dc.b	$cf,$c6,$00,$00,$00,$00,$00,$00
	dc.b	$c0,$c3,$00,$00,$00,$00,$00,$00
	dc.b	$c0,$c0,$00,$00,$00,$00,$00,$00
	dc.b	$c3,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$18,$ce,$00,$00,$00,$00,$00,$00
	dc.b	$f8,$e0,$00,$00,$00,$00,$00,$00
	dc.b	$df,$c3,$00,$00,$00,$00,$00,$00
	dc.b	$c3,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$d3,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$18,$00,$00,$00,$00,$00,$00
	dc.b	'sf',$00,$00,$00,$00,$00,$00
	dc.b	'Z<',$00,$00,$00,$00,$00,$00
	dc.b	$18,'0',$00,$00,$00,$00,$00,$00
	dc.b	$00,$18,$00,$00,$00,$00,$00,$00
	dc.b	$18,$00,$00,$00,$00,$00,$00,$00
	dc.b	$18,$1c,$00,$00,$00,$00,$00,$00
	dc.b	$18,$ff,$00,$00,$00,$00,$00,$00
	dc.b	'?',$1f,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	'>',$ff,$00,$00,$00,$00,$00,$00
	dc.b	$c3,$c3,$00,$00,$00,$00,$00,$00
	dc.b	$c0,$c7,$00,$00,$00,$00,$00,$00
	dc.b	$c0,$c0,$00,$00,$00,$00,$00,$00
	dc.b	$c3,$c3,$00,$00,$00,$00,$00,$00
	dc.b	$18,$dc,$00,$00,$00,$00,$00,$00
	dc.b	$dc,'s',$00,$00,$00,$00,$00,$00
	dc.b	$cb,$c3,$00,$00,$00,$00,$00,$00
	dc.b	$c3,$c0,$00,$00,$00,$00,$00,$00
	dc.b	$db,$dc,$00,$00,$00,$00,$00,$00
	dc.b	$03,$18,$00,$00,$00,$00,$00,$00
	dc.b	';<',$00,$00,$00,$00,$00,$00
	dc.b	'~f',$00,$00,$00,$00,$00,$00
	dc.b	$18,'`',$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$18,$00,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$18,$c0,$00,$00,$00,$00,$00,$00
	dc.b	$01,$06,$00,$00,$00,$00,$00,$00
	dc.b	$0e,$81,$00,$00,$00,$00,$00,$00
	dc.b	$0c,$c3,$00,$00,$00,$00,$00,$00
	dc.b	$c3,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$c0,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$c3,$00,$00,$00,$00,$00,$00
	dc.b	'>',$f8,$00,$00,$00,$00,$00,$00
	dc.b	$cf,'?',$00,$00,$00,$00,$00,$00
	dc.b	$c3,$c3,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$c0,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ce,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$18,$00,$00,$00,$00,$00,$00
	dc.b	$1f,$18,$00,$00,$00,$00,$00,$00
	dc.b	'<',$c3,$00,$00,$00,$00,$00,$00
	dc.b	$18,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$18,$18,$00,$00,$00,$00,$00,$00
	dc.b	$10,$00,$00,$00,$00,$00,$00,$00
	dc.b	$18,$18,$00,$00,$00,$00,$00,$00
	dc.b	$18,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$7f,$06,$00,$00,$00,$00,$00,$00
	dc.b	$fc,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$18,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$c3,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fc,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$c0,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$c3,$00,$00,$00,$00,$00,$00
	dc.b	'>',$f0,$00,$00,$00,$00,$00,$00
	dc.b	$c7,$1f,$00,$00,$00,$00,$00,$00
	dc.b	$c3,$c3,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$c0,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$c7,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$18,$00,$00,$00,$00,$00,$00
	dc.b	$0f,$18,$00,$00,$00,$00,$00,$00
	dc.b	'$',$c3,$00,$00,$00,$00,$00,$00
	dc.b	$18,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$18,$18,$00,$00,$00,$00,$00,$00
	dc.b	' ',$00,$00,$00,$00,$00,$00,$00
	dc.b	$18,$18,$00,$00,$00,$00,$00,$00
	dc.b	$18,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$7f,$06,$00,$00,$00,$00,$00,$00
	dc.b	$f8,$ff,$00,$00,$00,$00,$00,$00
	dc.b	'0',$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$1c,$00,$00,$00,$00,$00,$00
	dc.b	'8',$00,$00,$00,$00,$00,$00,$00
	dcb.w	72
	dc.b	$ff,'<',$00,$00,$00,$00,$00,$00
	dc.b	'<',$00,$00,$00,$00,$00,$00,$00
	dcb.w	72
	dc.b	$c3,'p',$00,$00,$00,$00,$00,$00
	dc.b	$0e,$00,$00,$00,$00,$00,$00,$00
	dcb.w	72
	dc.b	$ff,'`',$00,$00,$00,$00,$00,$00
	dc.b	$06,$00,$00,$00,$00,$00,$00,$00
	dcb.w	72
	dc.b	$fe,'`',$00,$00,$00,$00,$00,$00
	dc.b	$06,$00,$00,$00,$00,$00,$00,$00
	dcb.w	72
	dc.b	$0c,'p',$00,$00,$00,$00,$00,$00
	dc.b	$0e,$00,$00,$00,$00,$00,$00,$00
	dcb.w	72
	dc.b	$f8,'<',$00,$00,$00,$00,$00,$00
	dc.b	'<',$00,$00,$00,$00,$00,$00,$00
	dcb.w	72
	dc.b	$f0,$1c,$00,$00,$00,$00,$00,$00
	dc.b	'8',$00,$00,$00,$00,$00,$00,$00
	dcb.w	72
	dc.b	$00,$07,$d6,$00,$00,$07,$d6,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$d6,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$a6,$00
	dc.b	$00,$07,$8e,$00,$00,$07,$88,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$88,$00
	dc.b	$00,$07,$98,$00,$00,$07,$9e,$00
	dc.b	$00,$07,$90,$00,$00,$07,$a2,$00
	dc.b	$00,$07,$88,$00,$00,$07,$d6,$00
	dc.b	$00,$07,$9e,$00,$00,$07,$a2,$00
	dc.b	$00,$07,$9c,$00,$00,$07,$a8,$00
	dc.b	$00,$07,$86,$00,$00,$07,$96,$00
	dc.b	$00,$07,$b0,$00,$00,$07,$d6,$00
	dc.b	$00,$07,$9e,$00,$00,$07,$a2,$00
	dc.b	$00,$07,$88,$00,$00,$07,$a4,$00
	dc.b	$00,$07,$88,$00,$00,$07,$9a,$00
	dc.b	$00,$07,$a6,$00,$00,$07,$a4,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$b6,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$8c,$00
	dc.b	$00,$07,$8e,$00,$00,$07,$9c,$00
	dc.b	$00,$07,$a4,$00,$00,$07,$a6,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$9a,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$8c,$00
	dc.b	$00,$07,$9c,$00,$00,$07,$82,$00
	dc.b	$00,$07,$96,$00,$00,$07,$90,$00
	dc.b	$00,$07,$9a,$00,$00,$07,$a4,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$bc,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$b4,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$84,$00
	dc.b	$00,$07,$a2,$00,$00,$07,$80,$00
	dc.b	$00,$07,$84,$00,$00,$07,$94,$00
	dc.b	$00,$07,$88,$00,$00,$07,$86,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$82,$00
	dc.b	$00,$07,$b0,$00,$00,$07,$d6,$00
	dc.b	$00,$07,$b0,$00,$00,$07,$9c,$00
	dc.b	$00,$07,$86,$00,$00,$07,$80,$00
	dc.b	$00,$07,$b8,$00,$00,$07,$a6,$00
	dc.b	$00,$07,$a2,$00,$00,$07,$80,$00
	dc.b	$00,$07,$90,$00,$00,$07,$9a,$00
	dc.b	$00,$07,$88,$00,$00,$07,$86,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$82,$00
	dc.b	$00,$07,$b0,$00,$00,$07,$d6,$00
	dc.b	$00,$07,$90,$00,$00,$07,$96,$00
	dc.b	$00,$07,$96,$00,$00,$07,$88,$00
	dc.b	$00,$07,$8c,$00,$00,$07,$80,$00
	dc.b	$00,$07,$96,$00,$00,$07,$b8,$00
	dc.b	$00,$07,$9c,$00,$00,$07,$a2,$00
	dc.b	$00,$07,$90,$00,$00,$07,$8c,$00
	dc.b	$00,$07,$90,$00,$00,$07,$9a,$00
	dc.b	$00,$07,$80,$00,$00,$07,$96,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$82,$00
	dc.b	$00,$07,$b0,$00,$00,$07,$d6,$00
	dc.b	$00,$07,$80,$00,$00,$07,$9a,$00
	dc.b	$00,$07,$8c,$00,$00,$07,$88,$00
	dc.b	$00,$07,$96,$00,$00,$07,$d6,$00
	dc.b	$00,$07,$8a,$00,$00,$07,$80,$00
	dc.b	$00,$07,$84,$00,$00,$07,$88,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$d6,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$d6,$00
	dc.b	$00,$07,$a6,$00,$00,$07,$8e,$00
	dc.b	$00,$07,$90,$00,$00,$07,$a4,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$90,$00
	dc.b	$00,$07,$9a,$00,$00,$07,$a6,$00
	dc.b	$00,$07,$a2,$00,$00,$07,$9c,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$ac,$00
	dc.b	$00,$07,$80,$00,$00,$07,$a4,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$98,$00
	dc.b	$00,$07,$80,$00,$00,$07,$86,$00
	dc.b	$00,$07,$88,$00,$00,$07,$d6,$00
	dc.b	$00,$07,$82,$00,$00,$07,$b0,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$94,$00
	dc.b	$00,$07,$a2,$00,$00,$07,$a8,$00
	dc.b	$00,$07,$88,$00,$00,$07,$8c,$00
	dc.b	$00,$07,$88,$00,$00,$07,$a2,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$9c,$00
	dc.b	$00,$07,$8a,$00,$00,$07,$d6,$00
	dc.b	$00,$07,$88,$00,$00,$07,$a0,$00
	dc.b	$00,$07,$a8,$00,$00,$07,$90,$00
	dc.b	$00,$07,$9a,$00,$00,$07,$9c,$00
	dc.b	$00,$07,$ae,$00,$00,$07,$b4,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$a6,$00
	dc.b	$00,$07,$8e,$00,$00,$07,$88,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$98,$00
	dc.b	$00,$07,$a8,$00,$00,$07,$b2,$00
	dc.b	$00,$07,$80,$00,$00,$07,$94,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$ac,$00
	dc.b	$00,$07,$80,$00,$00,$07,$a4,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$98,$00
	dc.b	$00,$07,$80,$00,$00,$07,$86,$00
	dc.b	$00,$07,$88,$00,$00,$07,$d6,$00
	dc.b	$00,$07,$82,$00,$00,$07,$b0,$00
	dc.b	$00,$07,$d6,$00,$00,$07,$a8,$00
	dc.b	$00,$07,$a4,$00,$00,$07,$d6,$00
	dc.b	$00,$07,$a6,$00,$00,$07,$9c,$00
	dc.b	$00,$07,$9c,$00,$00,$07,$d6,$00
l003b	dcb.w	60
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$ff,$fe
	dcb.w	56
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$ff,$fe
	dcb.w	53
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dcb.w	48
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dcb.w	43
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dcb.w	40
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dcb.w	36
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$fe,$00,$00,$00,$00,$ff,$fe
	dcb.w	35
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dcb.w	28
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dcb.w	21
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dcb.w	20
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dcb.w	17
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dcb.w	12
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dcb.w	8
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dcb.w	4
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00
l003c	dc.b	$00,$00
l003d	dc.b	$12
l003e	dc.b	$08
	bss
l003f	ds.l	1
l0040	ds.b	44096
l0041	ds.l	1
l0042	ds.l	1
l0043	ds.l	1
l0044	ds.b	178
zuend	end
