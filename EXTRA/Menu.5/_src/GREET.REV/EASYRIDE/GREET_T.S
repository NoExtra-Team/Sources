l0000	equ	begin-$5e18
l0001	equ	begin-$4d38
l0002	equ	begin-$9be
l0003	equ	begin-$994
l0004	equ	begin-$98c
	text
begin
	move.w	#2,-(a7)		;physbase
	trap	#$e
	addq.l	#6,a7
	move.l	d0,l00b5
	pea	l00b1
	move.w	#0,-(a7)
	move.w	#$19,-(a7)		;ikbdws
	trap	#$e
	addq.l	#8,a7
	clr.l	-(a7)
	move.w	#$20,-(a7)		;super
	trap	#1
	addq.l	#6,a7
	move.l	d0,-(a7)
	dc.b	$a0,$0a
	move.b	#$e,$484.l
	moveq	#1,d0
	jsr	l0041
	move.l	#l0042,$4d2.w
	pea	l003e
	move.w	#6,-(a7)		;setpallete
	trap	#$e
	addq.l	#6,a7
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
	move.l	#$ffffffff,-(a7)
	move.l	a2,-(a7)
	move.l	#$ffffffff,-(a7)
	move.w	#5,-(a7)		;setscreen
	trap	#$e
	adda.l	#$e,a7
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
	move.w	#$ff,-(a7)
	move.w	#6,-(a7)		;crawio
	trap	#1
	addq.l	#4,a7
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
	move	sr,-(a7)
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
	move	(a7)+,sr
	pea	l00b2
	move.w	#0,-(a7)
	move.w	#$19,-(a7)		;ikbdws
	trap	#$e
	addq.l	#8,a7
	move.l	#$ffffffff,-(a7)
	move.l	l00b5,-(a7)
	move.l	l00b5,-(a7)
	move.w	#5,-(a7)		;setscreen
	trap	#$e
	adda.l	#$e,a7
	move	#$2700,sr
	lea	8.w,a1
	lea	l000c(pc),a0
	moveq	#9,d7
l000b	move.l	(a0)+,(a1)+
	dbf	d7,l000b
	jmp	$12.w
l000c	ori.b	#$c,d0
	movea.l	4.w,a0
	jmp	(a0)
	move.w	#$20,-(a7)		;super
	trap	#1
	addq.l	#6,a7
	clr.l	-(a7)
	trap	#1
l000d	move.l	#$8080000,$ffff8800.l
	move.l	#$9090000,$ffff8800.l
	move.l	#$a0a0000,$ffff8800.l
	rts

l000e	move.w	#2,-(a7)
	move.w	#2,-(a7)		;bconin
	trap	#$d
	addq.l	#4,a7
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
l0016	move.w	#8,-(a7)
	move.w	#$40,-(a7)
	move.w	#$1c,-(a7)		;giaccess
	trap	#$e
	addq.w	#6,a7
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
	move.w	#9,-(a7)
	move.w	#$40,-(a7)
	move.w	#$1c,-(a7)		;giaccess
	trap	#$e
	addq.w	#6,a7
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
	move.w	#$a,-(a7)
	move.w	#$40,-(a7)
	move.w	#$1c,-(a7)		;giaccess
	trap	#$e
	addq.w	#6,a7
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
l0022	move.l	l00b3,-(a7)
	movem.l	a0/d0-d1,-(a7)
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
	movem.l	(a7)+,a0/d0-d1
	rts

l0023	lea	l0028(pc),a0
	move.l	a0,$120.w
	lea	$fffffa01.w,a0
	clr.b	26(a0)
	move.b	#$c7,32(a0)
	move.b	#8,26(a0)
	ori.b	#1,6(a0)
	ori.b	#1,18(a0)
	movem.l	(a7)+,a0/d0-d1
	rts

l0024	lea	$fffffa01.w,a0
	andi.b	#$de,18(a0)
	andi.b	#$de,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
	lea	l00b0,a0
	clr.w	(a0)
	movem.l	(a7)+,a0/d0-d1
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
	movem.l	a0/d0-d2,-(a7)
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
	movem.l	(a7)+,a0/d0-d2
	rte

l0028	movem.l	a0-a2/d0,-(a7)
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
l002a	movem.l	a0-a2/d0,-(a7)
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
	movem.l	(a7)+,a0-a2/d0
	rte

l002d	bclr	#0,14(a0)
	lea	l00b0,a0
	clr.w	(a0)
	movem.l	(a7)+,a0-a2/d0
	rte

l002e	move.w	#$25,-(a7)		;vsync
	trap	#$e
	addq.w	#2,a7
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
l0032	dc.b	'I',$f9
	dc.l	l003c
l0033	dc.b	$a0,$00,'3',$fc,$00,$10
	dc.l	l00b8
	dc.b	'3',$fc,$00,$19
	dc.l	l00b9
	dc.b	'3',$fc,$00,$04
	dc.l	l00ba
	dc.b	'3',$fc,$00,$0f
	dc.l	l00bb
	dc.b	'3',$fc,$00,$00
	dc.l	l00bc
	dc.b	'#',$fc,$03,$03,$03,$03
	dc.l	l00bd
	dc.b	'3',$dc
	dc.l	l00be
	dc.b	'3',$fc,$00,$00
	dc.l	l00bf
	dc.b	'#',$fc
	dc.l	l003a
	dc.l	l00c0
	dc.b	'3',$fc,$00,$08
	dc.l	l00c1
	dc.b	'3',$fc,$00,$a0
	dc.l	l00c2
	dc.b	'3',$fc,$00,$02
	dc.l	l00c3
	dc.b	'3',$fc,$01,'0'
	dc.l	l00c4
	dc.b	'3',$fc,$00,$a0
	dc.l	l00c5
	dc.b	'#',$f9
	dc.l	l00b6
	dc.l	l00c6
	dc.b	'3',$fc,$00,$08
	dc.l	l00c7
	dc.b	'3',$fc,$00,$a0
	dc.l	l00c8
	dc.b	'3',$fc,$00,$02
	dc.l	l00c9
	dc.b	'#',$fc,$00,$00,$00,$00
	dc.l	l00ca
	dc.b	'M',$f9
	dc.l	l00b8
	dc.b	$a0,$07
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
l0038	dc.b	'K',$f9
	dc.l	l00af
	dc.b	'K',$ed,$00,'P3',$fc,$00,$00
	dc.l	l00cb
l0039	dc.b	$a0,$00,'3',$fc,$00,$10
	dc.l	l00b8
	dc.b	'3',$fc,$00,$10
	dc.l	l00b9
	dc.b	'3',$fc,$00,$04
	dc.l	l00ba
	dc.b	'3',$fc,$00,$0f
	dc.l	l00bb
	dc.b	'3',$fc,$00,$00
	dc.l	l00bc
	dc.b	'#',$fc,$03,$03,$03,$03
	dc.l	l00bd
	dc.b	'3',$ed,$ff,$b0
	dc.l	l00be
	dc.b	'3',$fc,$00,$00
	dc.l	l00bf
	dc.b	'#',$fc
	dc.l	l003f
	dc.l	l00c0
	dc.b	'3',$fc,$00,$08
	dc.l	l00c1
	dc.b	'3',$fc,$00,$a0
	dc.l	l00c2
	dc.b	'3',$fc,$00,$02
	dc.l	l00c3
	dc.b	'3',$ed,$ff,$b0
	dc.l	l00c4
	dc.b	'3',$fc,$00,$00
	dc.l	l00c5
	dc.b	'#',$f9
	dc.l	l00b6
	dc.l	l00c6
	dc.b	'3',$fc,$00,$08
	dc.l	l00c7
	dc.b	'3',$fc,$00,$a0
	dc.l	l00c8
	dc.b	'3',$fc,$00,$02
	dc.l	l00c9
	dc.b	'#',$fc,$00,$00,$00,$00
	dc.l	l00ca
	dc.b	'M',$f9
	dc.l	l00b8
	dc.b	$a0,$07,$a0,$00,'3',$fc,$00,$10
	dc.l	l00b8
	dc.b	'3',$fc,$00,$10
	dc.l	l00b9
	dc.b	'3',$fc,$00,$04
	dc.l	l00ba
	dc.b	'3',$fc,$00,$0f
	dc.l	l00bb
	dc.b	'3',$fc,$00,$00
	dc.l	l00bc
	dc.b	'#',$fc,$04,$04,$04,$04
	dc.l	l00bd
	dc.b	'3',$f9
	dc.l	l00cd
	dc.l	l00be
	dc.b	'3',$fc,$00,$a8
	dc.l	l00bf
	dc.b	'#',$fc
	dc.l	l003f
	dc.l	l00c0
	dc.b	'3',$fc,$00,$08
	dc.l	l00c1
	dc.b	'3',$fc,$00,$a0
	dc.l	l00c2
	dc.b	'3',$fc,$00,$02
	dc.l	l00c3
	dc.b	'3',$d5
	dc.l	l00c4
	dc.b	'3',$fc,$00,$00
	dc.l	l00c5
	dc.b	'#',$f9
	dc.l	l00b6
	dc.l	l00c6
	dc.b	'3',$fc,$00,$08
	dc.l	l00c7
	dc.b	'3',$fc,$00,$a0
	dc.l	l00c8
	dc.b	'3',$fc,$00,$02
	dc.l	l00c9
	dc.b	'#',$fc,$00,$00,$00,$00
	dc.l	l00ca
	dc.b	'M',$f9
	dc.l	l00b8
	dc.b	$a0,$07,$a0,$00,'3',$fc,$00,$10
	dc.l	l00b8
	dc.b	'3',$fc,$00,$10
	dc.l	l00b9
	dc.b	'3',$fc,$00,$04
	dc.l	l00ba
	dc.b	'3',$fc,$00,$0f
	dc.l	l00bb
	dc.b	'3',$fc,$00,$00
	dc.l	l00bc
	dc.b	'#',$fc,$07,$07,$07,$07
	dc.l	l00bd
	dc.b	'3',$f9
	dc.l	l00cc
	dc.l	l00be
	dc.b	'3',$fc,$00,$a8
	dc.l	l00bf
	dc.b	'#',$fc
	dc.l	l003f
	dc.l	l00c0
	dc.b	'3',$fc,$00,$08
	dc.l	l00c1
	dc.b	'3',$fc,$00,$a0
	dc.l	l00c2
	dc.b	'3',$fc,$00,$02
	dc.l	l00c3
	dc.b	'3',$dd
	dc.l	l00c4
	dc.b	'3',$fc,$00,$00
	dc.l	l00c5
	dc.b	'#',$f9
	dc.l	l00b6
	dc.l	l00c6
	dc.b	'3',$fc,$00,$08
	dc.l	l00c7
	dc.b	'3',$fc,$00,$a0
	dc.l	l00c8
	dc.b	'3',$fc,$00,$02
	dc.l	l00c9
	dc.b	'#',$fc,$00,$00,$00,$00
	dc.l	l00ca
	dc.b	'M',$f9
	dc.l	l00b8
	dc.b	$a0,$07
	rts

l003a	dcb.w	4
	dc.b	$10,$d8,$17,$18,$0f,$e0,$1f,$f8
	dc.b	'r',$13,$fc,$0f,$ff,$ff,$ff,$ff
	dc.b	$9c,$d8,$e0,$18,$ff,$e0,$ff,$f8
	dc.b	$0f,$19,$0c,$07,$03,$ff,$0f,$ff
	dc.b	$c6,$9e,$f8,'~',$ff,$fc,$ff,$fe
	dc.b	$f7,'>',$0f,$c1,$ff,$ff,$ff,$ff
	dc.b	'y`',$fe,'`',$ff,$80,$ff,$e0
	dc.b	$0f,$ef,$0c,$1f,$03,$ff,$0f,$ff
	dc.b	'fr',$81,$fe,$ff,$fe,$ff,$fe
	dc.b	$0f,$ef,$0c,$1f,$03,$ff,$0f,$ff
	dc.b	'fr',$81,$fe,$ff,$fe,$ff,$fe
	dc.b	$0f,$ef,$0c,$1f,$03,$ff,$0f,$ff
	dc.b	'fr',$81,$fe,$ff,$fc,$ff,$fe
	dc.b	$e7,$80,$1f,$80,$ff,$e0,$ff,$e0
	dc.b	$0e,'v',$07,$86,$0f,$f8,$0f,$fe
	dc.b	'Q ',$e0,$e0,$ff,$c0,$ff,$e0
	dc.b	$0e,$1e,$0e,$1e,$01,$e0,$0f,$fe
	dcb.w	4
	dc.b	'Q ',$e0,$e0,$ff,$c0,$ff,$e0
	dcb.w	4
	dc.b	'6',$8c,'/',$0c,$1f,$f0,'?',$fc
	dc.b	';3|',$0f,$ff,$ff,$ff,$ff
	dc.b	's',$9c,$80,'l',$ff,$f0,$ff,$fc
	dc.b	'7',$93,'<',$0f,$0f,$ff,'?',$ff
	dc.b	$cc,$be,$f0,'~',$ff,$f8,$ff,$fe
	dc.b	$f3,'<',$8f,$c3,$7f,$ff,$ff,$ff
	dc.b	'q',$b8,$fe,'X',$ff,$e0,$ff,$f8
	dc.b	'7',$f7,'<',$0f,$0f,$ff,'?',$ff
	dc.b	'&',$e6,$c1,$fe,$ff,$f8,$ff,$fe
	dc.b	'7',$f7,'<',$0f,$0f,$ff,'?',$ff
	dc.b	'&',$e6,$c1,$fe,$ff,$f8,$ff,$fe
	dc.b	'7',$f7,'<',$0f,$0f,$ff,'?',$ff
	dc.b	'&',$e6,$c1,$fe,$ff,$f8,$ff,$fe
	dc.b	$f3,'@',$8f,$c0,$7f,$a0,$ff,$e0
	dc.b	$0b,'f',$07,$86,$0f,$f8,$0f,$fe
	dc.b	'+`p',$e0,$ff,$80,$ff,$e0
	dc.b	$0f,'>',$07,'>',$08,$c0,$0f,$fe
	dcb.w	4
	dc.b	'+`p',$e0,$ff,$80,$ff,$e0
	dcb.w	4
	dc.b	'N',$bc,$7f,$04,'?',$f8,$7f,$fc
	dc.b	$1d,$f4,'>',$0f,$ff,$ff,$ff,$ff
	dc.b	'w4',$80,$c4,$ff,$f8,$ff,$fc
	dc.b	'm',$b9,'~',$07,$1f,$ff,$7f,$ff
	dc.b	$99,'~',$e0,$fe,$ff,$f0,$ff,$fe
	dc.b	$fa,'<',$c7,$c3,'?',$ff,$ff,$ff
	dc.b	'c',$e8,$fc,'x',$ff,$f0,$ff,$f8
	dc.b	'm',$f9,'~',$07,$1f,$ff,$7f,$ff
	dc.b	$ad,$ce,$c3,$fe,$ff,$f0,$ff,$fe
	dc.b	'm',$f9,'~',$07,$1f,$ff,$7f,$ff
	dc.b	$ad,$ce,$c3,$fe,$ff,$f0,$ff,$fe
	dc.b	'm',$f9,'~',$07,$1f,$ff,$7f,$ff
	dc.b	$ad,$ce,$c3,$fe,$ff,$f0,$ff,$fe
	dc.b	$fa,$e0,$c7,$e0,'?',$00,$ff,$e0
	dc.b	$0d,'N',$03,$8e,$0f,$f0,$0f,$fe
	dc.b	$0a,$e0,'1',$e0,$ff,$00,$ff,$e0
	dc.b	$0f,$fe,$03,$fe,$0c,$00,$0f,$fe
	dcb.w	4
	dc.b	$0a,$e0,'1',$e0,$ff,$00,$ff,$e0
	dcb.w	4
	dc.b	$84,'<',$ff,$cc,$7f,$f0,$fc,'<'
	dc.b	$80,$00,$9f,$ff,$7f,$ff,$e0,$00
	dc.b	$00,'.',$ff,$ce,$ff,$f0,$00,'>'
	dc.b	'L',$00,$7f,$ff,'?',$ff,'~',$00
	dc.b	$00,$0e,$ff,$fe,$ff,$f0,$00,$0e
	dc.b	'`',$00,$7f,$ff,$9f,$ff,$e0,$00
	dc.b	$00,'\',$ff,$e4,$ff,$f8,$00,$fc
	dc.b	'L',$00,$7f,$ff,'?',$ff,'~',$00
	dc.b	$00,$0e,$ff,$fe,$ff,$f0,$00,$0e
	dc.b	'L',$00,$7f,$ff,'?',$ff,'~',$00
	dc.b	$00,$0e,$ff,$fe,$ff,$f0,$00,$0e
	dc.b	'L',$00,$7f,$ff,'?',$ff,'~',$00
	dc.b	$00,$0e,$ff,$fe,$ff,$f0,$00,$0e
	dc.b	'`',$c0,$7f,$c0,$9f,' ',$e0,$e0
	dc.b	$06,$0e,$09,$fe,$0f,$f0,$0e,$0e
	dc.b	$80,$e0,$9f,$e0,$7f,$00,$e0,$e0
	dc.b	$0e,$0e,$01,$fe,$0f,$f0,$0e,$0e
	dcb.w	4
	dc.b	$80,$e0,$9f,$e0,$7f,$00,$e0,$e0
	dc.b	$00,$01,$00,$01,$00,$00,$00,$01
	dc.b	$ef,$fe,$10,$1e,$ff,$e0,$f0,$1e
	dc.b	$df,$ff,$c0,$00,'?',$ff,$e0,$00
	dc.b	$ff,$fe,$00,$1e,$ff,$e0,$00,$1e
	dc.b	$a7,$ff,$f8,$00,$7f,$ff,$f8,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dc.b	'?',$ff,' ',$00,$df,$ff,$e0,$00
	dc.b	$ff,$f4,$00,$04,$ff,$f8,$00,'<'
	dc.b	$a7,$ff,$f8,$00,$7f,$ff,$f8,$00
	dc.b	$ff,$fe,$00,$0c,$ff,$f2,$00,$0e
	dc.b	$a7,$ff,$f8,$00,$7f,$ff,$f8,$00
	dc.b	$ff,$fe,$00,$0c,$ff,$f2,$00,$0e
	dc.b	$a7,$ff,$f8,$00,$7f,$ff,$f8,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dc.b	'?',$80,' ',$80,$df,'`',$e0,$e0
	dc.b	$03,$fe,$0c,$0e,$0f,$f0,$0e,$0e
	dc.b	$df,$e0,$c0,$e0,'?',$00,$e0,$e0
	dc.b	$0f,$fe,$00,$0e,$0f,$f0,$0e,$0e
	dcb.w	4
	dc.b	$df,$e0,$c0,$e0,'?',$00,$e0,$e0
	dc.b	$00,$03,$00,$02,$00,$01,$00,$03
	dc.b	$e0,$0e,$1f,$fe,$ff,$f0,$e0,$0e
	dc.b	$e0,$00,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$00,$0e,$ff,$fe,$ff,$f0,$00,$0e
	dc.b	$b0,$00,$ff,$ff,$7f,$ff,$f0,$00
	dc.b	$00,$0e,$ff,$fe,$ff,$f0,$00,$0e
	dc.b	' ',$00,'?',$ff,$df,$ff,$e0,$00
	dc.b	$00,$0c,$ff,$ec,$ff,$f0,$00,$1c
	dc.b	$b0,$00,$ff,$ff,$7f,$ff,$f0,$00
	dc.b	$00,$0a,$ff,$f8,$ff,$f6,$00,$0e
	dc.b	$b0,$00,$ff,$ff,$7f,$ff,$f0,$00
	dc.b	$00,$0a,$ff,$f8,$ff,$f6,$00,$0e
	dc.b	$b0,$00,$ff,$ff,$7f,$ff,$f0,$00
	dc.b	$00,$08,$ff,$f8,$ff,$f6,$00,$0e
	dc.b	' ',$c0,'?',$c0,$df,' ',$e0,$e0
	dc.b	$08,$0e,$0f,$fe,$0f,$f0,$0e,$0e
	dc.b	$e0,$e0,$ff,$e0,$1f,$00,$e0,$e0
	dc.b	$0a,$0e,$05,$fe,$0f,$f0,$0e,$0e
	dcb.w	4
	dc.b	$e0,$e0,$ff,$e0,$1f,$00,$e0,$e0
	dc.b	$00,$05,$00,$06,$00,$03,$00,$07
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$c0,$0e
	dc.b	$9f,$ff,$80,$00,$7f,$ff,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dc.b	$cf,$ff,'0',$00,$ff,$ff,$f0,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dc.b	$9f,$ff,$00,$00,$ff,$ff,$e0,$00
	dc.b	$ff,$fe,$00,$1e,$ff,$e0,$00,$1e
	dc.b	$cf,$ff,$b0,$00,$7f,$ff,$f0,$00
	dc.b	$ff,$f2,$00,$02,$ff,$fc,$00,$0e
	dc.b	$cf,$ff,$b0,$00,$7f,$ff,$f0,$00
	dc.b	$ff,$f2,$00,$02,$ff,$fc,$00,$0e
	dc.b	$cf,$ff,'0',$00,$ff,$ff,$f0,$00
	dc.b	$ff,$f0,$00,$00,$ff,$fe,$00,$0e
	dc.b	$9f,$e0,$00,$e0,$ff,$00,$e0,$e0
	dc.b	$0f,$fe,$0e,$0e,$0f,$f0,$0e,$0e
	dc.b	'?',$e0,' ',$e0,$df,$00,$e0,$e0
	dc.b	$01,$fe,$0e,$0e,$0f,$f0,$0e,$0e
	dcb.w	4
	dc.b	'?',$e0,' ',$e0,$df,$00,$e0,$e0
	dc.b	$00,$08,$00,$0f,$00,$07,$00,$0f
	dc.b	$7f,$fe,$80,$0e,$ff,$f0,$80,$0e
	dc.b	$1f,$ff,$00,$00,$ff,$ff,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dc.b	$7f,$ff,$00,$00,$ff,$ff,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dc.b	$df,$ff,$00,$00,$ff,$ff,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dc.b	$ff,$ff,$80,$00,$7f,$ff,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dc.b	$ff,$ff,$80,$00,$7f,$ff,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dc.b	$7f,$ff,$00,$00,$ff,$ff,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dc.b	$df,$f3,$00,$ef,$ff,$1f,$e0,$ff
	dc.b	'g',$fe,$86,$0e,$ff,$f0,$fe,$0e
	dc.b	$1f,$c0,$00,$c0,$ff,' ',$e0,$e0
	dc.b	$01,$fe,$0e,$0e,$0f,$f0,$0e,$0e
	dcb.w	4
	dc.b	$1f,$c0,$00,$c0,$ff,' ',$e0,$e0
	dc.b	$00,$1f,$00,$1f,$00,$0f,$00,$1f
	dc.b	$00,$0e,$00,$0e,$ff,$f0,$00,$0e
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$fe,$0e,$fe,$0e,$01,$f0,$fe,$0e
	dc.b	'`',$7f,$00,$7f,$ff,$80,$e0,$7f
	dc.b	$ff,$0e,$ff,$0e,$00,$f0,$ff,$fe
	dc.b	$c0,$ff,$00,$ff,$ff,$00,$e0,$ff
	dc.b	$fc,$0e,$fc,$0e,$03,$f0,$fc,$0e
	dc.b	'`',$7f,$00,$7f,$ff,$80,$e0,$7f
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$ff,$fe
	dc.b	'`',$7f,$00,$7f,$ff,$80,$e0,$7f
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$ff,$fe
	dc.b	'`',$7f,$00,$7f,$ff,$80,$e0,$7f
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$ff,$fe
	dc.b	$c0,$ef,$00,$df,$ff,'?',$e0,$ff
	dc.b	'b',$0e,$82,$0e,$ff,$f0,$fe,$0e
	dc.b	'@',$80,$00,$80,$ff,'`',$e0,$e0
	dc.b	$00,$0e,$0e,$0e,$0f,$f0,$0e,$0e
	dcb.w	4
	dc.b	$a0,$e0,'@',$e0,$ff,$00,$e0,$e0
	dc.b	$00,'?',$00,'>',$00,$1f,$00,'>'
	dc.b	$ff,$fa,$06,$0a,$f9,$f4,$06,$0e
	dc.b	$e7,$8d,'`~',$9f,$ff,$ff,$ff
	dc.b	'k',$fe,$1c,$0e,$ff,$f0,$fe,$0e
	dc.b	'?',$fc,$00,$fc,$ff,$03,$e0,$ff
	dc.b	$7f,$c6,$7f,$c6,$80,'8',$ff,$fe
	dc.b	$df,$ff,$00,$ff,$ff,$00,$e0,$ff
	dc.b	$f9,$fe,$fa,$0e,$07,$f0,$fe,$0e
	dc.b	'?<',$00,$7f,$ff,$ff,$e0,$ff
	dc.b	$af,'.',$1f,$ce,$ff,$f0,$ff,$fe
	dc.b	'?<',$00,$7f,$ff,$ff,$e0,$ff
	dc.b	$af,'.',$1f,$ce,$ff,$f0,$ff,$fe
	dc.b	'?',$de,$00,$df,$ff,'?',$e0,$ff
	dc.b	'9',$ce,$c7,$ee,$ff,$f0,$ff,$fe
	dc.b	$df,$e7,$00,$9f,$ff,$7f,$e0,$ff
	dc.b	$b9,$fa,$c0,$0a,$ff,$f4,$fe,$0e
	dc.b	$ff,$80,$00,$80,$ff,'`',$e0,$e0
	dc.b	$09,$fe,$0e,$0e,$0f,$f0,$0e,$0e
	dcb.w	4
	dc.b	$ff,$e0,$00,$e0,$ff,$00,$e0,$e0
	dc.b	$00,'|',$00,'|',$00,'?',$00,'|'
	dc.b	$0e,$00,$0c,$00,$f3,$fe,$0e,$0e
	dc.b	$c0,$00,$00,$00,$ff,$ff,$e0,$00
	dc.b	$00,$0e,$00,$0e,$ff,$f0,$00,$0e
	dc.b	' ',$ff,$00,$ff,$ff,$00,$e0,$ff
	dc.b	$ff,$e2,$ff,$e2,$00,$1c,$ff,$fe
	dc.b	' ',$ff,$c0,$ff,$ff,$00,$e0,$ff
	dc.b	$12,$08,$16,$08,$ef,$f6,$fe,$0e
	dc.b	' ',$00,$00,$00,$ff,$ff,$e0,$00
	dc.b	$00,$0e,$00,$0e,$ff,$f0,$00,$0e
	dc.b	' ',$00,$00,$00,$ff,$ff,$e0,$00
	dc.b	$00,$0e,$00,$0e,$ff,$f0,$00,$0e
	dc.b	' ',$e0,$00,$c0,$ff,'?',$e0,$f0
	dc.b	$00,$0e,$00,$0e,$ff,$f0,$00,$0e
	dc.b	' ',$00,$c0,$00,$ff,$ff,$e0,$00
	dcb.w	2
	dc.b	$ff,$fe,$00,$0e,$e0,$80,$00,$80
	dc.b	$ff,'`',$e0,$e0,$0c,$0c,$0e,$0c
	dc.b	$0f,$f2,$0e,$0e,$00,$00,$00,$00
	dcb.w	2
	dc.b	$e0,$e0,$00,$e0,$ff,$00,$e0,$e0
	dc.b	$00,$b8,$00,$f8,$00,$7f,$00,$f8
	dc.b	$1a,$04,$18,$00,$e7,$fe,$1e,$0e
	dc.b	$e0,$00,$00,$00,$ff,$ff,$e0,$00
	dc.b	$00,$1e,$00,$1e,$ff,$e0,$00,$1e
	dc.b	$80,$e0,$00,$e0,$ff,$00,$e0,$e0
	dcb.w	4
	dc.b	'@',$e0,$e0,$e0,$ff,$00,$e0,$e0
	dc.b	$06,$08,$0e,$08,$0f,$f6,$0e,$0e
	dc.b	$80,$00,$00,$00,$ff,$ff,$e0,$00
	dc.b	$00,$0e,$00,$0e,$ff,$f0,$00,$0e
	dc.b	$80,$00,$00,$00,$ff,$ff,$e0,$00
	dc.b	$00,$0e,$00,$0e,$ff,$f0,$00,$0e
	dc.b	$80,$f0,$00,$c0,$ff,'?',$e0,$f0
	dc.b	$00,$0c,$00,$0c,$ff,$f2,$00,$0e
	dc.b	'@',$00,$e0,$00,$ff,$ff,$e0,$00
	dc.b	$00,$04,$00,$00,$ff,$fe,$00,$0e
	dc.b	$a0,$80,'@',$80,$ff,'`',$e0,$e0
	dc.b	$0e,$0c,$0e,$0c,$0f,$f2,$0e,$0e
	dcb.w	4
	dc.b	$ff,$e0,'?',$e0,$c0,$00,$ff,$e0
	dc.b	$01,'?',$01,$ff,$00,$f0,$01,$f0
	dc.b	$f9,$f4,$ff,$f0,$06,$0e,'>',$0e
	dc.b	$bf,$ff,'_',$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fc,$ff,$fc,$00,$00,$00,'<'
	dc.b	'_',$e0,$9f,$e0,$e0,$00,$e0,$e0
	dcb.w	4
	dc.b	'_',$e0,$ff,$e0,$e0,$00,$e0,$e0
	dc.b	$07,$f8,$0f,$f8,$0e,$06,$0e,$0e
	dc.b	'_',$ff,$9f,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fc,$ff,$fc,$00,$02,$00,$0e
	dc.b	'_',$ff,$9f,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fc,$ff,$fc,$00,$02,$00,$0e
	dc.b	'_',$df,$9f,$ef,$e0,'0',$e0,$f0
	dc.b	$ff,$f8,$ff,$f8,$00,$06,$00,$0e
	dc.b	'_',$ff,$ff,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$f4,$ff,$f0,$00,$0e,$00,$0e
	dc.b	$1f,$80,$ff,$80,$e0,'`',$e0,$e0
	dc.b	$07,$f8,$0f,$f8,$0e,$06,$0e,$0e
	dcb.w	4
	dc.b	$f3,$e0,'s',$e0,$8c,$00,$ff,$e0
	dc.b	$03,' ',$02,$e0,$01,$ff,$03,$e0
	dc.b	't',$00,'z',$00,$8f,$fe,'~',$0e
	dc.b	$00,$00,$e0,$00,$ff,$ff,$e0,$00
	dc.b	$00,$06,$00,$06,$ff,$f8,$00,$1e
	dc.b	' ',$f0,$c0,$f0,$ff,$00,$e0,$f0
	dcb.w	4
	dc.b	$e0,$e0,$e0,$e0,$ff,$00,$e0,$e0
	dc.b	$0a,$08,$06,$08,$0f,$f6,$0e,$0e
	dc.b	' ',$00,$c0,$00,$ff,$ff,$e0,$00
	dc.b	$00,$0c,$00,$0c,$ff,$f2,$00,$0e
	bra	l0001
	dc.b	$ff,$ff,$e0,$00,$00,$0c,$00,$0c
	dc.b	$ff,$f2,$00,$0e,' ',$e0,$c0,$f0
	dc.b	$ff,'?',$e0,$f0,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$0e,$e0,$00,$e0,$00
	dc.b	$ff,$ff,$e0,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$0e,'@',$c0,$e0,$c0
	dc.b	$ff,' ',$e0,$e0,$0a,$08,$06,$08
	dc.b	$0f,$f6,$0e,$0e,$00,$00,$00,$00
	dcb.w	2
	dc.b	$e1,$e0,$e1,$e0,$1e,$00,$ff,$e0
	dc.b	$07,'?',$04,$ff,$03,$c0,$07,$c0
	dc.b	$cf,$fa,$d1,$fa,'>',$04,$fe,$0e
	dc.b	'_',$ff,$ff,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$0e
	dc.b	$df,$c8,$ff,$c7,$e0,'?',$e0,$ff
	dc.b	'a',$c8,$fe,'<',$ff,$fe,$ff,$fe
	dc.b	$ff,$f2,$ff,$ef,$e0,$1f,$e0,$ff
	dc.b	'm',$fa,$83,$fa,$fe,$04,$fe,$0e
	dc.b	$df,$ff,$ff,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fc,$ff,$fc,$00,$02,$00,$0e
	dc.b	$ff,$ff,$7f,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fc,$ff,$fc,$00,$02,$00,$0e
	dc.b	$df,$ff,$ff,$ff,$e0,'0',$e0,$f0
	dc.b	$ff,$f8,$ff,$f8,$00,$06,$00,$0e
	dc.b	$ff,$ff,$ff,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fa,$ff,$fa,$00,$04,$00,$0e
	dc.b	$ff,$c0,$ff,$c0,$e0,' ',$e0,$e0
	dc.b	'u',$f8,'s',$f8,$8e,$06,$fe,$0e
	dc.b	'Q ',$e0,$e0,$ff,$c0,$ff,$e0
	dc.b	'Q ',$e0,$e0,$ff,$c0,$ff,$e0
	dc.b	$0b,$ff,$0c,$7f,$07,$80,$0f,$80
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$0e
	dc.b	$ff,$ff,$ff,$ff,$e0,$00,$e0,$ff
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$fe,$0e
	dc.b	$ff,$98,$ff,$87,$e0,$7f,$e0,$ff
	dc.b	$f3,$92,$fc,'z',$ff,$fc,$ff,$fe
	dc.b	$df,$f7,$ff,$cf,$e0,'?',$e0,$ff
	dc.b	'e',$fe,$83,$fe,$fe,$00,$fe,$0e
	dc.b	$ff,$ff,$ff,$ff,$e0,$00,$e0,$ff
	dc.b	$ff,$fe,$ff,$fc,$00,$02,$ff,$fe
	dc.b	$df,$f9,$ff,$f8,$e0,$07,$e0,$ff
	dc.b	$e6,'>',$06,$0e,$f9,$f0,$ff,$fe
	dc.b	$ff,$ef,$ff,$ef,$e0,'0',$e0,$ff
	dc.b	$ff,$fc,$ff,$fc,$00,$02,$fe,$0e
	dc.b	$df,$fc,$ff,$fc,$e0,$03,$e0,$ff
	dc.b	$03,$fe,$03,$fe,$fc,$00,$fe,$0e
	dc.b	$ff,$e0,$ff,$e0,$e0,$00,$e0,$e0
	dc.b	$b9,$fe,';',$fe,$c6,$00,$fe,$0e
	dc.b	'+`p',$e0,$ff,$80,$ff,$e0
	dc.b	'+`p',$e0,$ff,$80,$ff,$e0
	dc.b	$13,$00,$1c,$ff,$0f,$00,$1f,$00
	dc.b	$00,$0e,$ff,$fe,$00,$00,$00,$0e
	dc.b	$e0,$cf,$ff,'?',$e0,$ff,$e0,$ff
	dc.b	'8',$0e,$c7,$fe,$fe,$00,$fe,$0e
	dc.b	$c0,'<',$ff,$83,$e0,$7f,$e0,$7f
	dc.b	'r&',$fd,$f6,$ff,$f8,$ff,$fe
	dc.b	'@',$cf,$ff,$bf,$e0,$7f,$e0,$ff
	dc.b	$10,$0e,$e3,$fe,$fc,$00,$fc,$0e
	dc.b	$c0,$27,$ff,$9f,$e0,$7f,$e0,$7f
	dc.b	'8',$ee,$c7,$0c,$ff,$f2,$ff,$fe
	dc.b	'@',$fc,$ff,$fc,$e0,$03,$e0,$ff
	dc.b	$9f,$9e,$1f,$86,$e0,'x',$ff,$fe
	dc.b	$c0,$07,$ff,$ff,$e0,$7f,$e0,$7f
	dc.b	$b2,$0c,$cd,$fc,$fe,$02,$fe,$0e
	dc.b	'@',$ff,$ff,$ff,$e0,$00,$e0,$ff
	dc.b	$0e,$0e,$0d,$fe,$f2,$00,$fe,$0e
	dc.b	'@',$e0,$ff,$e0,$e0,$00,$e0,$e0
	dc.b	$dc,$0e,$1f,$fe,$e0,$00,$fc,$0e
	dc.b	$0a,$e0,'1',$e0,$ff,$00,$ff,$e0
	dc.b	$00,$e0,'1',$e0,$f5,$00,$ff,$e0
	dc.b	'#',$ff,'=',$ff,$1e,$00,'>',$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$0e
	dc.b	'_',$ff,$ff,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$0e
	dc.b	$1f,$ff,$ff,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$0e
	dc.b	'?',$ff,$df,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$0e
	dc.b	$1f,$ff,$ff,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fe,$ff,$fc,$00,$02,$00,$0e
	dc.b	'?',$fc,$df,$fc,$e0,$03,$e0,$ff
	dc.b	'?',$ce,'?',$c2,$c0,'<',$ff,$fe
	dc.b	$1f,$ff,$ff,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$0e
	dc.b	'?',$ff,$df,$ff,$e0,$00,$e0,$ff
	dc.b	$bd,$fe,$bb,$fe,'F',$00,$fe,$0e
	dc.b	$1f,$e0,$ff,$e0,$e0,$00,$e0,$e0
	dc.b	'?',$fe,$1f,$fe
	asr.b	#8,d0
	lsr.b	#8,d6
	suba.l	-(a0),a7
	suba.l	-(a0),a7
	bra	l0003
	suba.l	-(a0),a7
	suba.l	-(a0),a7
	bra	l0004
	dc.b	'p',$0c,'O',$fc,'<',$03,'|',$0f
	dc.b	$02,$0e,$03,$fe,$fc,$00,$fe,$0e
	dc.b	$00,$00,$ff,$ff,$e0,$00,$e0,$00
	dc.b	$00,$0e,$ff,$fe,$00,$00,$00,$0e
	dc.b	$b0,$00,'O',$ff,$f0,$00,$f0,$00
	dc.b	$00,$0e,$ff,$fe,$00,$00,$00,$0e
	dc.b	$e0,$00,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$00,$1e,$ff,$fe,$00,$00,$00,$1e
	dc.b	$b0,$00,'O',$ff,$f0,$00,$f0,$00
	dc.b	$00,$0c,$ff,$fc,$00,$02,$00,$0e
	dc.b	$e0,$e0,$1f,$e0,$e0,$00,$e0,$e0
	dcb.w	4
	dc.b	$b0,$00,'O',$ff,$f0,$00,$f0,$00
	dc.b	$00,$0e,$ff,$fe,$00,$00,$00,$0e
	dc.b	$e0,$e0,$1f,$e0,$e0,$00,$e0,$e0
	dc.b	$0a,$0e,$07,$fe,$0e,$00,$0e,$0e
	dc.b	$00,$e0,$ff,$e0,$e0,$00,$e0,$e0
	dc.b	$80,$1e,$9f,$fe
	bra	l0002
	dc.b	$c0,$e0,$df,$e0,' ',$00,$e0,$e0
	dc.b	$c0,$e0,$df,$e0,' ',$00,$e0,$e0
	dc.b	$9f,$ff,$e0,$1f,'x',$00,$f8,$1f
	dc.b	$0f,$fe,$0c,$0e,$f2,$00,$fe,$0e
	dc.b	$1f,$ff,$e0,$00,$e0,$00,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$00,$00,$00,$0e
	dc.b	$ef,$ff,$80,$00,'p',$00,$f0,$00
	dc.b	$ff,$fe,$00,$0e,$00,$00,$00,$0e
	dc.b	$df,$ff,' ',$00,$e0,$00,$e0,$00
	dc.b	$ff,$fc,$00,$1c,$00,$00,$00,$1c
	dc.b	$ef,$ff,$80,$00,'p',$00,$f0,$00
	dc.b	$ff,$fc,$00,$0c,$00,$02,$00,$0e
	dc.b	$df,'` `',$e0,$80,$e0,$e0
	dcb.w	4
	dc.b	$ef,$ff,$80,$00,'p',$00,$f0,$00
	dc.b	$ff,$fe,$00,$0e,$00,$00,$00,$0e
	dc.b	$df,'` `',$e0,$80,$e0,$e0
	dc.b	$0f,$fe,$0e,$0e,$0e,$00,$0e,$0e
	dc.b	$bf,$e0,'@',$e0,$e0,$00,$e0,$e0
	dc.b	$ff,$ee,$e0,$0e,$00,$10,$e0,$1e
	dc.b	$7f,$e0,'`',$e0,$80,$00,$e0,$e0
	dc.b	$7f,$e0,'`',$e0,$80,$00,$e0,$e0
	dc.b	$80,'?',$7f,$ff,$f0,$00,$f0,'?'
	dc.b	$bc,$0e,$bb,$fe,'F',$00,$fe,$0e
	dc.b	$a0,$00,'_',$ff,$e0,$00,$e0,$00
	dc.b	$00,$1e,$ff,$fe,$00,$00,$00,$1e
	dc.b	$c8,$00,$87,$ff,'x',$00,$f8,$00
	dc.b	$00,$0c,$ff,$fc,$00,$02,$00,$0e
	dc.b	$a0,$00,$7f,$ff,$e0,$00,$e0,$00
	dc.b	$00,$1c,$ff,$dc,$00,' ',$00,'<'
	dc.b	$c8,$00,$87,$ff,'x',$00,$f8,$00
	dc.b	$00,$0c,$ff,$fc,$00,$02,$00,$0e
	dc.b	$a0,' ',$7f,' ',$e0,$c0,$e0,$e0
	dcb.w	4
	dc.b	$c8,$00,$87,$ff,'x',$00,$f8,$00
	dc.b	$00,$0e,$ff,$fe,$00,$00,$00,$0e
	dc.b	$a0,' ',$7f,' ',$e0,$c0,$e0,$e0
	dc.b	$0c,$0e,$0f,$fe,$0e,$00,$0e,$0e
	dc.b	$e0,$e0,$1f,$e0,$e0,$00,$e0,$e0
	dc.b	$c0,'4',$df,$c4,' 8',$e0,'<'
	dc.b	' ',$e0,'?',$e0,$c0,$00,$e0,$e0
	dc.b	' ',$e0,'?',$e0,$c0,$00,$e0,$e0
	dc.b	$7f,$f8,$00,'x',$e0,$00,$e0,'x'
	dc.b	$0b,$fe,$06,$0e,$0e,$00,$0e,$0e
	dc.b	$ff,$ff,$00,$00,$e0,$00,$e0,$00
	dc.b	$ff,$e6,$00,'&',$00,$18,$00,'>'
	dc.b	'S',$ff,'L',$00,'>',$00,'~',$00
	dc.b	$ff,$f0,$00,$00,$00,$0e,$00,$0e
	dc.b	'_',$ff,$e0,$00,$e0,$00,$e0,$00
	dc.b	$ff,$cc,$00,$cc,$00,'0',$00,$fc
	dc.b	'S',$ff,'L',$00,'>',$00,'~',$00
	dc.b	$ff,$fc,$00,$0c,$00,$02,$00,$0e
	dc.b	'_ ',$e0,' ',$e0,$c0,$e0,$e0
	dcb.w	4
	dc.b	'S',$ff,'L',$00,'>',$00,'~',$00
	dc.b	$ff,$fe,$00,$0e,$00,$00,$00,$0e
	dc.b	'_ ',$e0,' ',$e0,$c0,$e0,$e0
	dc.b	$0b,$fe,$0c,$0e,$0e,$00,$0e,$0e
	dc.b	$ff,$e0,$00,$e0
	asr.b	#8,d0
l003b	asr	-(a0)
	sub.w	d7,(a4)+
	divu	-(a4),d0
	bra.s	l003b
	dc.b	$e0,$fc,$9f,$e0,$00,$e0,$e0,$00
	dc.b	$e0,$e0,$9f,$e0,$00,$e0,$e0,$00
	dc.b	$e0,$e0,$bc,$f0,$bc,$f0,'C',$00
	dc.b	$ff,$f0,$07,$ee,$0b,$ee,$0c,$10
	dc.b	$0f,$fe,$ff,$ff,'?',$ff,$c0,$00
	dc.b	$ff,$ff,$ff,$f4,$ff,$f4,$00,$08
	dc.b	$ff,$fc,'d',$ff,'x',$ff,$1f,$00
	dc.b	$7f,$ff,$ff,$f8,$ff,$f8,$00,$06
	dc.b	$ff,$fe,$9f,$ff,$df,$ff,$e0,$00
	dc.b	$ff,$ff,$ff,$e8,$ff,$e8,$00,$10
	dc.b	$ff,$f8,'d',$ff,'x',$ff,$1f,$00
	dc.b	$7f,$ff,'~<~<',$81,$c2
	dc.b	$ff,$fe,$9f,$80,$df,$80,$e0,'`'
	dc.b	$ff,$e0,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,'d',$fd,'x',$fd,$1f,$02
	dc.b	$7f,$ff,$ff,$0e,$ff,$0e,$00,$f0
	dc.b	$ff,$fe,$9f,$80,$df,$80,$e0,'`'
	dc.b	$ff,$e0,$07,$ee,$0b,$ee,$0c,$10
	dc.b	$0f,$fe,$ff,$e0,'?',$e0,$c0,$00
	dc.b	$ff,$e0,$1b,$e8,'<x',$ff,$f0
	dc.b	$ff,$f8,$ff,$e0,'?',$e0,$c0,$00
	dc.b	$ff,$e0,$ff,$e0,'?',$e0,$c0,$00
	dc.b	$ff,$e0,'~`~`',$81,$80
	dc.b	$ff,$e0,$0f,$f6,$07,$f6,$08,$08
	dc.b	$0f,$fe,$f3,$ff,'s',$ff,$8c,$00
	dc.b	$ff,$ff,'?',$f8,'?',$f8,$c0,$00
	dc.b	$ff,$f8,'9',$f0,'1',$f0,$0e,$0f
	dc.b	'?',$ff,$ff,$fc,$ff,$fc,$00,$02
	dc.b	$ff,$fe,'?',$ff,$bf,$ff,$c0,$00
	dc.b	$ff,$ff,'?',$f0,'?',$f0,$c0,$00
	dc.b	$ff,$f0,'9',$fe,'1',$fe,$0e,$01
	dc.b	'?',$ff,$7f,$1c,$7f,$1c,$80,$e2
	dc.b	$ff,$fe,'?',$c0,$bf,$c0,$c0,' '
	dc.b	$ff,$e0,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,'9',$f8,'1',$f8,$0e,$07
	dc.b	'?',$ff,$ff,$c6,$ff,$c6,$00,'8'
	dc.b	$ff,$fe,'?',$c0,$bf,$c0,$c0,' '
	dc.b	$ff,$e0,$0f,$f6,$07,$f6,$08,$08
	dc.b	$0f,$fe,$f3,$e0,'s',$e0,$8c,$00
	dc.b	$ff,$e0,'9',$b8,'~X',$ff,$e0
	dc.b	$ff,$f8,$f3,$e0,'s',$e0,$8c,$00
	dc.b	$ff,$e0,$f3,$e0,'s',$e0,$8c,$00
	dc.b	$ff,$e0,$ff,$c0,$ff,$c0,$00,$00
	dc.b	$ff,$c0,$07,$fe,$07,$fe,$00,$00
	dc.b	$07,$fe,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$f0,$ff,$f0,$00,$00
	dc.b	$ff,$f0,$1f,$ff,$1f,$ff,$00,$00
	dc.b	$1f,$ff,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,'q',$fe,'q',$fe,$8e,$01
	dc.b	$ff,$ff,$0f,$c0,$0f,$c0,$f0,$00
	dc.b	$ff,$c0,$07,$fc,$07,$fc,$00,$03
	dc.b	$07,$ff,$7f,$8c,$7f,$8c,$80,'r'
	dc.b	$ff,$fe,'q',$e0,'q',$e0,$8e,$00
	dc.b	$ff,$e0,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$07,$f0,$07,$f0,$00,$0f
	dc.b	$07,$ff,$7f,$e2,$7f,$e2,$80,$1c
	dc.b	$ff,$fe,'q',$e0,'q',$e0,$8e,$00
	dc.b	$ff,$e0,$0f,$f2,$0f,$f2,$00,$0c
	dc.b	$0f,$fe,$e1,$e0,$e1,$e0,$1e,$00
	dc.b	$ff,$e0,'q`',$fe,'`',$ff,$80
	dc.b	$ff,$e0,$e1,$e0,$e1,$e0,$1e,$00
	dc.b	$ff,$e0,$e1,$e0,$e1,$e0,$1e,$00
	dc.b	$ff,$e0,$00,$00,$00,$00,$00,$00
	dcb.w	77
	dc.b	$f7,$a0,$0f,$e0,$ff,$c0,$ff,$e0
	dc.b	$0e,'8',$07,$c6,$0f,$fe,$0f,$fe
	dc.b	'Q ',$e0,$e0,$ff,$c0,$ff,$e0
	dcb.w	4
	dc.b	$06,'n',$04,$0e,$03,$f0,$07,$fe
	dc.b	$a3,'@',$bc,'@',$7f,$80,$ff,$c0
	dc.b	$08,$f8,$08,$18,$07,$e0,$0f,$f8
	dc.b	$05,$12,$0e,$0e,$0f,$fc,$0f,$fe
	dc.b	$0f,'^',$0c,'A',$03,$bf,$0f,$ff
	dc.b	'y`',$fe,'`',$ff,$80,$ff,$e0
	dc.b	'r',$13,$fc,$0f,$ff,$ff,$ff,$ff
	dc.b	$9f,$08,$e7,'8',$f8,$f0,$ff,$f8
	dc.b	$0f,'^',$0c,'A',$03,$bf,$0f,$ff
	dc.b	'y`',$fe,'`',$ff,$80,$ff,$e0
	dc.b	'r',$13,$fc,$0f,$ff,$ff,$ff,$ff
	dc.b	$9c,$d0,$e0,$10,$ff,$e0,$ff,$f0
	dc.b	'8n0',$1f,$0f,$ff,'?',$ff
	dc.b	'vr',$91,$fe,$ef,$fc,$ff,$fe
	dc.b	'r',$13,$fc,$0f,$ff,$ff,$ff,$ff
	dc.b	$ff,$e0,$e1,$9c,$9e,'~',$ff,$fe
	dc.b	$f3,'`',$8f,$e0,$7f,$80,$ff,$e0
	dc.b	$0f,'r',$0b,$8e,$07,$fc,$0f,$fe
	dc.b	'+`p',$e0,$ff,$80,$ff,$e0
	dcb.w	4
	dc.b	$1e,'N',$10,$0e,$0f,$f1,$1f,$ff
	dc.b	'30',$fc,$10,$ff,$e0,$ff,$f0
	dc.b	'>„0t',$0f,$f8,'?',$fc
	dc.b	$02,$b6,$07,$0e,$0f,$f8,$0f,$fe
	dc.b	$17,$dc,$1c,'C',$0f,$bf,$1f,$ff
	dc.b	'q',$b0,$fe,'P',$ff,$e0,$ff,$f0
	dc.b	';3|',$0f,$ff,$ff,$ff,$ff
	dc.b	's',$9c,$80,'l',$ff,$f0,$ff,$fc
	dc.b	$17,$dc,$1c,'C',$0f,$bf,$1f,$ff
	dc.b	'q',$b0,$fe,'P',$ff,$e0,$ff,$f0
	dc.b	';3|',$0f,$ff,$ff,$ff,$ff
	dc.b	's',$9c,$80,'l',$ff,$f0,$ff,$fc
	dc.b	'lwP',$0f,'?',$ff,$7f,$ff
	dc.b	'&',$e6,$c1,$fe,$ff,$f8,$ff,$fe
	dc.b	';3|',$0f,$ff,$ff,$ff,$ff
	dc.b	'q',$82,$80,'z',$ff,$fc,$ff,$fe
	dc.b	$fa,$e0,$c7,$e0,'?',$00,$ff,$e0
	dc.b	$0f,'f',$0d,$9e,$03,$f8,$0f,$fe
	dc.b	$0a,$e0,'1',$e0,$ff,$00,$ff,$e0
	dcb.w	4
	dc.b	'#_<',$1f,$1f,$e0,'?',$ff
	dc.b	$b6,'Hx8',$ff,$f0,$ff,$f8
	dc.b	'c',$0a,'|',$f2,$1f,$fc,$7f,$fe
	dc.b	$08,$ae,$0b,$1e,$07,$f0,$0f,$fe
	dc.b	'-',$fc,'>C',$1f,$bf,'?',$ff
	dc.b	'c',$e8,$fc,'x',$ff,$f0,$ff,$f8
	dc.b	$1d,$f4,'>',$0f,$ff,$ff,$ff,$ff
	dc.b	'w4',$80,$c4,$ff,$f8,$ff,$fc
	dc.b	'-',$fc,'>C',$1f,$bf,'?',$ff
	dc.b	'c',$e8,$fc,'x',$ff,$f0,$ff,$f8
	dc.b	$1d,$f4,'>',$0f,$ff,$ff,$ff,$ff
	dc.b	'w4',$80,$c4,$ff,$f8,$ff,$fc
	dc.b	$f4,'9',$b8,$07,$7f,$ff,$ff,$ff
	dc.b	$ad,$ce,$c3,$fe,$ff,$f0,$ff,$fe
	dc.b	$1d,$f4,'>',$0f,$ff,$ff,$ff,$ff
	dc.b	'w',$06,$80,$f6,$ff,$f8,$ff,$fe
	dc.b	'`',$c0,$7f,$c0,$9f,' ',$e0,$e0
	dc.b	$06,$0e,$07,$fe,$09,$f0,$0e,$0e
	dc.b	$80,$e0,$9f,$e0,$7f,$00,$e0,$e0
	dcb.w	4
	dc.b	'B',$07,'}',$ff,'?',$f8,'~',$07
	dc.b	$80,'\',$7f,'$',$ff,$f8,$c0,$fc
	dc.b	'X',$1d,$7f,$e1,'?',$fe,'~?'
	dc.b	$0c,$0e,$0d,$fe,$03,$f0,$0e,$0e
	dc.b	'L',$00,$7f,$ff,'?',$ff,'~',$00
	dc.b	$00,'\',$ff,$e4,$ff,$f8,$00,$fc
	dc.b	$80,$00,$9f,$ff,$7f,$ff,$e0,$00
	dc.b	$00,'.',$ff,$ce,$ff,$f0,$00,'>'
	dc.b	'L',$00,$7f,$ff,'?',$ff,'~',$00
	dc.b	$00,'\',$ff,$e4,$ff,$f8,$00,$fc
	dc.b	$80,$00,$9f,$ff,$7f,$ff,$e0,$00
	dc.b	$00,'.',$ff,$ce,$ff,$f0,$00,'>'
	dc.b	$b0,$00,$ff,$ff,$7f,$ff,$f8,$00
	dc.b	$00,$0e,$ff,$fe,$ff,$f0,$00,$0e
	dc.b	$80,$00,$9f,$ff,$7f,$ff,$e0,$00
	dc.b	$00,$0c,$ff,$fc,$ff,$f2,$00,$0e
	dc.b	'?',$80,' ',$80,$df,'`',$e0,$e0
	dc.b	$13,$fe,$12,$0e,$0d,$f0,$1e,$0e
	dc.b	$df,$e0,$c0,$e0,'?',$00,$e0,$e0
	dcb.w	4
	dc.b	'g',$ff,$18,$01,$7f,$fe,'x',$01
	dc.b	$ff,$e4,$00,$04,$ff,$f8,$00,'<'
	dc.b	$df,$ff,$b8,$01,$7f,$fe,$f8,$0f
	dc.b	$87,$fe,$86,$0e,$09,$f0,$8e,$0e
	dc.b	$27,$ff,'x',$00,$7f,$ff,'x',$00
	dc.b	$ff,$f4,$00,$04,$ff,$f8,$00,'<'
	dc.b	$df,$ff,$c0,$00,'?',$ff,$e0,$00
	dc.b	$ff,$fe,$00,$1e,$ff,$e0,$00,$1e
	dc.b	$27,$ff,'x',$00,$7f,$ff,'x',$00
	dc.b	$ff,$f4,$00,$04,$ff,$f8,$00,'<'
	dc.b	$df,$ff,$c0,$00,'?',$ff,$e0,$00
	dc.b	$ff,$fe,$00,$1e,$ff,$e0,$00,$1e
	dc.b	$cf,$ff,'0',$00,$ff,$ff,$f0,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dc.b	$df,$ff,$c0,$00,'?',$ff,$e0,$00
	dc.b	$ff,$fc,$00,$0c,$ff,$f2,$00,$0e
	dc.b	' ',$c0,'?',$c0,$df,' ',$e0,$e0
	dc.b	' ',$0e,'!',$fe,$1f,$f0,'>',$0e
	dc.b	$e0,$e0,$ff,$e0,$1f,$00,$e0,$e0
	dcb.w	4
	dc.b	$b0,$00,$8f,$ff,$7f,$ff,$f0,$00
	dc.b	$00,$1c,$ff,$fc,$ff,$e0,$00,$1c
	dc.b	$c0,$04,$bf,$f8,$7f,$ff,$f0,$07
	dc.b	$ca,$0e,$c3,$fe,$0d,$f0,$ce,$0e
	dc.b	$b0,$00,$ff,$ff,$7f,$ff,$f0,$00
	dc.b	$00,$0e,$ff,$ee,$ff,$f0,$00,$1e
	dc.b	$e0,$00,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$00,$0e,$ff,$fe,$ff,$f0,$00,$0e
	dc.b	$b0,$00,$ff,$ff,$7f,$ff,$f0,$00
	dc.b	$00,$0e,$ff,$ee,$ff,$f0,$00,$1e
	dc.b	$e0,$00,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$00,$0e,$ff,$fe,$ff,$f0,$00,$0e
	dc.b	$e0,$00,$1f,$ff,$ff,$ff,$e0,$00
	dc.b	$00,$08,$ff,$f8,$ff,$f6,$00,$0e
	dc.b	$e0,$00,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$00,$0c,$ff,$fc,$ff,$f2,$00,$0e
	dc.b	$9f,$e0,$00,$e0,$ff,$00,$e0,$e0
	dc.b	'S',$fe,'@',$0e,'?',$f0,'|',$0e
	dc.b	'?',$e0,' ',$e0,$df,$00,$e0,$e0
	dcb.w	4
	dc.b	$0f,$ff,$00,$00,$ff,$ff,$f0,$00
	dc.b	$ff,$fe,$00,$1e,$ff,$e0,$00,$1e
	dc.b	$ef,$fc,$10,$00,$ff,$ff,$f0,$03
	dc.b	$e9,$fe,$e0,$0e,$0f,$f0,$ee,$0e
	dc.b	$cf,$ff,'0',$00,$ff,$ff,$f0,$00
	dc.b	$ff,$fe,$00,$1e,$ff,$e0,$00,$1e
	dc.b	$9f,$ff,$80,$00,$7f,$ff,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dc.b	$cf,$ff,'0',$00,$ff,$ff,$f0,$00
	dc.b	$ff,$fe,$00,$1e,$ff,$e0,$00,$1e
	dc.b	$9f,$ff,$80,$00,$7f,$ff,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dc.b	$7f,$ff,$00,$00,$ff,$ff,$e0,$00
	dc.b	$ff,$f0,$00,$00,$ff,$fe,$00,$0e
	dc.b	$9f,$ff,$80,$00,$7f,$ff,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dc.b	$df,$f3,$00,$ef,$ff,$1f,$e0,$ff
	dc.b	';',$fe,$c0,$1e,$ff,$e0,$fc,$1e
	dc.b	$1f,$a0,$00,$a0,$ff,'@',$e0,$e0
	dcb.w	4
	dc.b	$1f,$ff,$00,$00,$ff,$ff,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dc.b	'?',$fe,$00,$00,$ff,$ff,$e0,$01
	dc.b	$f5,$fc,$f8,$0c,$0f,$f2,$fe,$0e
	dc.b	$7f,$ff,$00,$00,$ff,$ff,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dc.b	$1f,$ff,$00,$00,$ff,$ff,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dc.b	$7f,$ff,$00,$00,$ff,$ff,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dc.b	$1f,$ff,$00,$00,$ff,$ff,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dc.b	$9f,$ff,$80,$00,$7f,$ff,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dc.b	'?',$ff,$00,$00,$ff,$ff,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dc.b	$c0,$ef,$00,$df,$ff,'?',$e0,$ff
	dc.b	$b8,$02,$c0,$02,$ff,$fc,$f8,$1e
	dc.b	'@ ',$00,' ',$ff,$c0,$e0,$e0
	dcb.w	4
	dc.b	'@',$00,$00,$00,$ff,$ff,$e0,'p'
	dc.b	$00,$0e,$00,$0e,$ff,$f0,$1c,$0e
	dcb.w	2
	dc.b	$ff,$ff,$e0,$00,$d2,$08,$dc,$08
	dc.b	'/',$f6,$fe,$0e,'`',$7f,$00,$7f
	dc.b	$ff,$80,$e0,$7f,$fc,$0c,$fc,$0c
	dc.b	$03,$f2,$fc,$0e,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$fe,$0e,$fe,$0e
	dc.b	$01,$f0,$fe,$0e,'`',$7f,$00,$7f
	dc.b	$ff,$80,$e0,$7f,$fc,$0c,$fc,$0c
	dc.b	$03,$f2,$fc,$0e,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$fe,$0e,$fe,$0e
	dc.b	$01,$f0,$fe,$0e,$c0,$7f,$c0,$7f
	dc.b	'?',$80,$e0,$ff,$ff,$fe,$ff,$fe
	dc.b	$00,$00,$ff,$fe,$df,'0',$1f,'0'
	dc.b	$e0,$cf,$ff,$f8,'>>>',$0e
	dc.b	$c1,$f0,'?',$fe,$df,$e7,$00,$9f
	dc.b	$ff,$7f,$e0,$ff,$1f,$c4,$e0,$04
	dc.b	$ff,$f8,$e0,'<',$ff,' ',$00,' '
	dc.b	$ff,$c0,$e0,$e0,$00,$00,$00,$00
	dcb.w	2
	dc.b	$ff,$cf,$00,$c0,$ff,'?',$e0,$f8
	dc.b	$f7,$fe,'0',$0e,$cf,$f0,'>',$0e
	dc.b	$df,$ff,$00,$00,$ff,$ff,$e0,$00
	dc.b	$c3,$f8,'D',$08,$bf,$f6,'~',$0e
	dc.b	'?',$ff,$00,$ff,$ff,$00,$e0,$ff
	dc.b	$f9,$fc,$fa,$0c,$07,$f2,$fe,$0e
	dc.b	$e7,$8d,'`~',$9f,$ff,$ff,$ff
	dc.b	'k',$fe,$1c,$0e,$ff,$f0,$fe,$0e
	dc.b	'?',$ff,$00,$ff,$ff,$00,$e0,$ff
	dc.b	$f9,$fc,$fa,$0c,$07,$f2,$fe,$0e
	dc.b	$e7,$8d,'`~',$9f,$ff,$ff,$ff
	dc.b	'k',$fe,$1c,$0e,$ff,$f0,$fe,$0e
	dc.b	$9f,$cc,$80,'?',$7f,$ff,$e0,$ff
	dc.b	$e0,$ee,$00,$16,$ff,$f8,$ff,$fe
	dc.b	$bc,'g<h',$c3,$9f,$ff,$f8
	dc.b	$df,$9e,$1f,$86,$e0,'x?',$fe
	dc.b	' ',$00,$c0,$00,$ff,$ff,$e0,$00
	dc.b	$00,'l',$00,'l',$ff,$90,$00,'|'
	dc.b	$e0,'`',$00,'`',$ff,$80,$e0,$e0
	dcb.w	4
	dc.b	$e0,$f8,$00,$e0,$ff,$1f,$e0,$f8
	dc.b	'8',$0e,'>',$0e,$c7,$f0,'>',$0e
	dc.b	$e0,$00,$00,$00,$ff,$ff,$e0,$c0
	dc.b	$08,$08,$0e,$08,$f7,$f6,'>',$0e
	dc.b	' ',$ff,$00,$ff,$ff,$00,$e0,$ff
	dc.b	$12,$08,$16,$08,$ef,$f6,$fe,$0e
	dc.b	$c0,$00,$00,$00,$ff,$ff,$e0,$00
	dc.b	$00,$0e,$00,$0e,$ff,$f0,$00,$0e
	dc.b	' ',$ff,$00,$ff,$ff,$00,$e0,$ff
	dc.b	$12,$08,$16,$08,$ef,$f6,$fe,$0e
	dc.b	$c0,$00,$00,$00,$ff,$ff,$e0,$00
	dc.b	$00,$0e,$00,$0e,$ff,$f0,$00,$0e
	dc.b	' ',$00,$00,$00,$ff,$ff,$e0,$00
	dc.b	$00,$18,$00,'<',$ff,$fc,$00,'<'
	dc.b	'q',$c8,'q',$d8,'Ž?',$ff,$f8
	dc.b	$0f,$ce,$0f,$c2,$f0,'<?',$fe
	dc.b	'@',$00,$e0,$00,$ff,$ff,$e0,$00
	dc.b	$00,$f8,$00,$f8,$ff,$00,$00,$f8
	dc.b	$a0,$e0,'@',$e0,$ff,$00,$e0,$e0
	dcb.w	4
	dc.b	$a0,$f8,'@',$e0,$ff,$1f,$e0,$f8
	dc.b	'8',$0e,'>',$0e,$c7,$f0,'>',$0e
	dc.b	$a0,$80,'@',$80,$ff,$7f,$e0,$e0
	dc.b	$08,$08,$0a,$08,$f7,$f6,$1e,$0e
	dc.b	$80,$e0,$00,$e0,$ff,$00,$e0,$e0
	dc.b	$06,$02,$0e,$00,$0f,$fe,$0e,$0e
	dc.b	$e0,$00,$00,$00,$ff,$ff,$e0,$00
	dc.b	$00,$0e,$00,$0e,$ff,$f0,$00,$0e
	dc.b	$80,$e0,$00,$e0,$ff,$00,$e0,$e0
	dc.b	$06,$02,$0e,$00,$0f,$fe,$0e,$0e
	bra	l0000
	dc.b	$ff,$ff,$e0,$00,$00,$0e,$00,$0e
	dc.b	$ff,$f0,$00,$0e,$e0,$00,$00,$00
	dc.b	$ff,$ff,$e0,$00,$00,$16,$00,$18
	dc.b	$ff,$fe,$00,$1e,$00,$18,$00,'8'
	dc.b	$00,'?',$00,'8 ',$00,' ',$00
	dc.b	$d8,$00,'8',$00,'_',$ff,$ff,$ff
	dc.b	$e0,$00,$e0,$00,$ff,'p',$ff,$10
	dc.b	$00,$e0,$01,$f0,$1f,$e0,$ff,$e0
	dc.b	$e0,$00,$e0,$e0,$00,$00,$00,$00
	dcb.w	2
	dc.b	$1f,$ef,$ff,$f7,$e0,$18,$e0,$f8
	dc.b	$fb,$fe,$ff,$fe,$06,$00,'>',$0e
	dc.b	$1f,$8f,$ff,$8f,$e0,'p',$e0,$f0
	dc.b	$fd,$f8,$ff,$f8,$02,$06,$0e,$0e
	dc.b	'_',$e0,$9f,$e0,$e0,$00,$e0,$e0
	dc.b	$07,$fc,$0f,$f2,$0e,$0e,$0e,$0e
	dc.b	$bf,$ff,'_',$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$0e
	dc.b	'_',$e0,$9f,$e0,$e0,$00,$e0,$e0
	dc.b	$07,$fc,$0f,$f2,$0e,$0e,$0e,$0e
	dc.b	'?',$ff,$df,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$0e
	dc.b	$9f,$ff,$7f,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fc,$ff,$f0,$00,$0e,$00,$0e
	dc.b	$00,'7',$00,'?',$00,'8',$00,'8'
	dc.b	$e0,$00,$e0,$00,$18,$00,'8',$00
	dc.b	$e0,$00,$e0,$00,$ff,$ff,$e0,$00
	dc.b	$00,$e8,$00,$f8,$ff,$f0,$00,$f8
	dc.b	'@',$e0,$e0,$e0,$ff,$00,$e0,$e0
	dcb.w	4
	dc.b	'@',$e0,$e0,$f8,$ff,$1f,$e0,$f8
	dc.b	'>',$0e,'>',$0e,$c7,$f0,'>',$0e
	dc.b	'@',$c8,$e0,$c0,$ff,'?',$e0,$f8
	dc.b	$04,$0c,$04,$0c,$fb,$f2,$06,$0e
	dc.b	' ',$e0,$c0,$e0,$ff,$00,$e0,$e0
	dc.b	$0a,$00,$06,$0e,$0f,$fe,$0e,$0e
	dc.b	$00,$00,$e0,$00,$ff,$ff,$e0,$00
	dc.b	$00,$1e,$00,$1e,$ff,$e0,$00,$1e
	dc.b	' ',$e0,$c0,$e0,$ff,$00,$e0,$e0
	dc.b	$0a,$00,$06,$0e,$0f,$fe,$0e,$0e
	dc.b	'@',$00,$e0,$00,$ff,$ff,$e0,$00
	dc.b	$00,$1e,$00,$1e,$ff,$e0,$00,$1e
	dc.b	$a0,$00,$c0,$00,$7f,$ff,$f0,$00
	dc.b	$00,$02,$00,$02,$ff,$fc,$00,$0e
	dc.b	$00,' ',$00,'8',$00,'?',$00,'8'
	dc.b	'0',$00,'0',$00,$c8,$00,'8',$00
	dc.b	$ff,$ff,$ff,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$b4,$ff,$fc,$00,'x',$00,'|'
	dc.b	'_',$c3,$ff,$f3,$e0,'<',$e0,$ff
	dc.b	$f8,$e0,$f8,$1c,$07,$fe,$ff,$fe
	dc.b	$ff,$f7,$ff,$ff,$e0,$18,$e0,$f8
	dc.b	$ef,$fe,$ef,$fe,$16,$00,'>',$0e
	dc.b	$ff,$cf,$ff,$c3,$e0,'<',$e0,$fc
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$0e
	dc.b	$df,$c2,$ff,$cf,$e0,'?',$e0,$ff
	dc.b	'm',$f2,$83,$fc,$fe,$0e,$fe,$0e
	dc.b	'_',$ff,$ff,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$e6,$ff,$e6,$00,$18,$00,'>'
	dc.b	$df,$c2,$ff,$cf,$e0,'?',$e0,$ff
	dc.b	'm',$f2,$83,$fc,$fe,$0e,$fe,$0e
	dc.b	$df,$ff,$ff,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$ec,$ff,$e0,$00,$1c,$00,'<'
	dc.b	'_',$ff,$1f,$ff,'`',$00,'x',$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$0e
	dc.b	$00,$0f,$00,'?',$00,'8',$00,'8'
	dc.b	$f0,$00,$f0,$00,$08,$00,'8',$00
	dc.b	$df,$fc,$ff,$fc,$e0,$03,$e0,$ff
	dc.b	'?',$c8,'?',$f0,$c0,'<',$e0,'<'
	dc.b	$1f,$88,$ff,$f0,$e0,$7f,$e0,$ff
	dc.b	$e1,$82,$e0,'z',$1f,$fc,$ff,$fe
	dc.b	$ff,$ff,$ff,$ff,$e0,$18,$e0,$f8
	dc.b	$ef,$fe,$ef,$fe,$16,$00,'>',$0e
	dc.b	$ff,$ed,$ff,$e3,$e0,$1e,$e0,$fe
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$0e
	dc.b	$ff,$97,$ff,$8f,$e0,$7f,$e0,$ff
	dc.b	'e',$fc,$83,$f0,$fe,$0e,$fe,$0e
	dc.b	$ff,$ff,$ff,$ff,$e0,$00,$e0,$ff
	dc.b	$ff,$f4,$ff,$f4,$00,$08,$ff,$fc
	dc.b	$ff,$97,$ff,$8f,$e0,$7f,$e0,$ff
	dc.b	'e',$fc,$83,$f0,$fe,$0e,$fe,$0e
	dc.b	$df,$fc,$ff,$fc,$e0,$03,$e0,$ff
	dc.b	'?',$fe,$07,$e0,$f8,$1e,$f8,$1e
	dc.b	$dc,$ff,'l',$ff,$f3,$00,$ff,$ff
	dc.b	$fd,$fe,$fd,$fe,$02,$00,$fe,$0e
	dc.b	$00,$1f,$00,'?',$00,'8',$00,'8'
	dc.b	$f8,$00,$f8,$00,$00,$00,'8',$00
	dc.b	'@',$ff,$ff,$ff,$e0,$00,$e0,$ff
	dc.b	'x',$1e,$7f,$e2,$80,$1c,$f8,$1e
	dc.b	$00,$1c,$ff,$e0,$e0,$ff,$e0,$ff
	dc.b	$0f,$06,$00,$f6,$ff,$f8,$ff,$fe
	dc.b	'@',$f8,$ff,$ff,$e0,$18,$e0,$f8
	dc.b	'*',$0e,$ef,$fe,$16,$00,'>',$0e
	dc.b	'@',$f8,$ff,$f7,$e0,$0f,$e0,$ff
	dc.b	$00,$0e,$ff,$fe,$00,$00,$00,$0e
	dc.b	$c0,'?',$ff,$8f,$e0,$7f,$e0,$7f
	dc.b	$10,$0c,$e3,$fc,$fc,$02,$fc,$0e
	dc.b	'@',$7f,$ff,$7f,$e0,$80,$e0,$ff
	dc.b	$8f,$fc,$8f,$fc,'p',$00,$ff,$fc
	dc.b	$c0,'?',$ff,$8f,$e0,$7f,$e0,$7f
	dc.b	$10,$0c,$e3,$fc,$fc,$00,$fc,$0c
	dc.b	'@',$ff,$ff,$ff,$e0,$00,$e0,$ff
	dc.b	$18,$02,$07,$f0,$fc,$0e,$fc,$0e
	dc.b	$f1,$99,'>',$07,$ff,$ff,$ff,$ff
	dc.b	$b0,$0e,$c1,$fe,$fe,$00,$fe,$0e
	dc.b	$00,'8',$00,'?',$00,'8',$00,'8'
	dc.b	'8',$00,$f8,$00,$00,$00,'8',$00
	dc.b	'?',$ff,$df,$ff,$e0,$00,$e0,$ff
	dc.b	$fb,$f2,$fb,$e2,$04,$1c,$fc,$1e
	dc.b	$9f,$ff,$7f,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fc,$ff,$fc,$00,$02,$00,$0e
	dc.b	$1f,$f7,$ff,$ff,$e0,$18,$e0,$f8
	dc.b	$e9,$fe,$ef,$fe,$16,$00,'>',$0e
	dc.b	$1f,$e8,$ff,$ef,$e0,$07,$e0,$ef
	dc.b	$ff,$fe,$7f,$fe,$80,$00,$80,$0e
	dc.b	$1f,$ff,$ff,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$0e
	dc.b	$1f,'>',$ff,'>',$e0,$c1,$e0,$ff
	dc.b	$03,$f0,$03,$f0,$fc,$00,$ff,$f0
	dc.b	$1f,$ff,$ff,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$0e
	dc.b	$1f,$ff,$ff,$ff,$e0,$00,$e0,$ff
	dc.b	$91,$f8,$8f,$f8,'~',$06,$fe,$0e
	dc.b	$ff,$ff,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$0e
	dc.b	$00,$17,$00,'?',$00,'8',$00,'8'
	dc.b	$f8,$00,$f8,$00,$00,$00,'8',$00
	dc.b	$e0,$e0,$1f,$e0,$e0,$00,$e0,$e0
	dc.b	'x',$02,'{',$f2,$04,$0c,'|',$0e
	dc.b	$e0,$00,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$00,$0c,$ff,$fc,$00,$02,$00,$0e
	dc.b	$00,$e0,$ff,$ff,$e0,$18,$e0,$f8
	dc.b	'*',$0e,$ef,$fe,$16,$00,'>',$0e
	dc.b	$00,$e5,$ff,$e6,$e0,$03,$e0,$e7
	dc.b	$c0,$1e,'?',$fe,$c0,$00,$c0,$1e
	dc.b	$b0,$00,'O',$ff,$f0,$00,$f0,$00
	dc.b	$00,$1e,$ff,$fe,$00,$00,$00,$1e
	dc.b	$00,$80,$ff,$80,$e0,'`',$e0,$e0
	dcb.w	4
	dc.b	$b0,$00,'O',$ff,$f0,$00,$f0,$00
	dc.b	$00,$02,$ff,$e2,$00,$1c,$00,$1e
	dc.b	$a0,$e0,'_',$e0,$e0,$00,$e0,$e0
	dc.b	$0a,$0c,$07,$fc,$0e,$02,$0e,$0e
	dc.b	' ',$00,$df,$ff,$e0,$00,$e0,$00
	dc.b	$00,$0e,$ff,$fe,$00,$00,$00,$0e
	dc.b	$00,$00,$00,'?',$00,'8',$00,'8'
	dc.b	'8',$00,$f8,$00,$00,$00,'8',$00
	dc.b	$df,'` `',$e0,$80,$e0,$e0
	dc.b	'7',$f6,'0',$06,$0e,$08,'>',$0e
	dc.b	$df,$ff,' ',$00,$e0,$00,$e0,$00
	dc.b	$ff,$fc,$00,$0c,$00,$02,$00,$0e
	dc.b	$bf,$e7,'@',$f8,$e0,$18,$e0,$f8
	dc.b	$ff,$fe,'>',$0e,$06,$00,'>',$0e
	dc.b	$bf,$e3,'@',$e2,$e0,$01,$e0,$e3
	dc.b	$ff,$fe,$00,$1e,$e0,$00,$e0,$1e
	dc.b	$ef,$ff,$80,$00,'p',$00,$f0,$00
	dc.b	$ff,$fe,$00,$1e,$00,$00,$00,$1e
	dc.b	$bf,$80,'@',$80,$e0,'`',$e0,$e0
	dcb.w	4
	dc.b	$ef,$ff,$80,$00,'p',$00,$f0,$00
	dc.b	$ff,$f6,$00,$06,$00,$08,$00,$0e
	dc.b	$df,'` `',$e0,$80,$e0,$e0
	dc.b	$0f,$fe,$0e,$0e,$0e,$00,$0e,$0e
	dc.b	$9f,$ff,$e0,$00,$e0,$00,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$00,$00,$00,$0e
	dc.b	$00,'/',$00,$10,$00,'8',$00,'8'
	dc.b	$f8,$00,'8',$00,$00,$00,'8',$00
	dc.b	$a0,' ',$7f,' ',$e0,$c0,$e0,$e0
	dc.b	$1c,$0e,$13,$fe,$0e,$00,$1e,$0e
	dc.b	$90,$00,'o',$ff,$f0,$00,$f0,$00
	dc.b	$00,$0e,$ff,$fe,$00,$00,$00,$0e
	dc.b	$e0,$e8,$1f,$f7,$e0,$18,$e0,$f8
	dc.b	'<',$0e,$ff,$fe,$06,$00,'>',$0e
	dc.b	$e0,$e1,$1f,$e1,$e0,$00,$e0,$e1
	dc.b	$c0,$1e,$0f,$de,$f0,' ',$f0,'>'
	dc.b	$c8,$00,$87,$ff,'x',$00,$f8,$00
	dc.b	$00,$1c,$ff,$dc,$00,' ',$00,'<'
	dc.b	$e0,$c0,$1f,$c0,$e0,' ',$e0,$e0
	dcb.w	4
	dc.b	$c8,$00,$87,$ff,'x',$00,$f8,$00
	dc.b	$0c,$0e,$f3,$fe,$0c,$00,$0c,$0e
	dc.b	$a0,' ',$7f,' ',$e0,$c0,$e0,$e0
	dc.b	$0c,$0e,$0f,$fe,$0e,$00,$0e,$0e
	dc.b	$e0,$00,$ff,$ff,$e0,$00,$e0,$00
	dc.b	$00,$06,$ff,$e6,$00,$18,$00,$1e
	dc.b	$00,'8',$00,$07,$00,'8',$00,'8'
	dc.b	'8',$00,$f8,$00,$00,$00,'8',$00
	dc.b	'_ ',$e0,' ',$e0,$c0,$e0,$e0
	dc.b	$09,$fe,$06,$0e,$0e,$00,$0e,$0e
	dc.b	$b7,$ff,$c0,$00,'x',$00,$f8,$00
	dc.b	$ff,$fe,$00,$0e,$00,$00,$00,$0e
	dc.b	$ff,$ff,$00,$e0,$e0,$18,$e0,$f8
	dc.b	$fb,$fe,'<',$0e,$06,$00,'>',$0e
	dc.b	$ff,$e0,$00,$e0,$e0,$00,$e0,$e0
	dc.b	$cf,$cc,$8c,$cc,'p0',$fc,$fc
	dc.b	'S',$ff,'L',$00,'>',$00,'~',$00
	dc.b	$ff,$cc,$00,$cc,$00,'0',$00,$fc
	dc.b	$7f,$e0,$00,$e0,$e0,$00,$e0,$e0
	dcb.w	4
	dc.b	'S',$ff,'L',$00,'>',$00,'~',$00
	dc.b	$f9,$fe,$06,$0e,$0e,$00,$0e,$0e
	dc.b	'_ ',$e0,' ',$e0,$c0,$e0,$e0
	dc.b	$0b,$fe,$0c,$0e,$0e,$00,$0e,$0e
	dc.b	$df,$ff,$e0,$00,$e0,$00,$e0,$00
	dc.b	$ff,$d2,$00,$02,$00,'<',$00,'>'
	dc.b	$00,'?',$00,$00,$00,'8',$00,'8'
	dc.b	$f8,$00,'8',$00,$00,$00,'8',$00
	dc.b	$9f,$80,$df,$80,$e0,'`',$ff,$e0
	dc.b	$03,$de,$0f,$ce,$0e,'0',$0f,$fe
	dc.b	$f7,$f9,$87,$f8,'x',$07,$ff,$ff
	dc.b	$e6,'>',$06,$0e,$f9,$f0,$ff,$fe
	dc.b	$ff,$f7,'?',$e7,$c0,$18,$ff,$ff
	dc.b	'?',$ee,';',$ee,$c4,$10,$ff,$fe
	dc.b	$ff,$e0,'?',$e0,$c0,$00,$ff,$e0
	dc.b	'_',$ec,'_',$ec,' ',$10,$7f,$fc
	dc.b	'd',$ff,'x',$ff,$1f,$00,$7f,$ff
	dc.b	$ff,$e8,$ff,$e8,$00,$10,$ff,$f8
	dc.b	$7f,$e0,'?',$e0,$c0,$00,$ff,$e0
	dcb.w	4
	dc.b	'd',$ff,'x',$ff,$1f,$00,$7f,$ff
	dc.b	$f3,$de,$ff,$ce,$0e,'0',$ff,$fe
	dc.b	$9f,$80,$df,$80,$e0,'`',$ff,$e0
	dc.b	$07,$ee,$0b,$ee,$0c,$10,$0f,$fe
	dc.b	$b9,$f9,$f9,$f8,$c6,$07,$ff,$ff
	dc.b	$e6,'<',$06,$04,$f9,$f8,$ff,$fc
	dc.b	$00,'?',$00,$0f,$00,'0',$00,'?'
	dc.b	$f8,$00,$f8,$00,$00,$00,$f8,$00
	dc.b	'?',$c0,$bf,$c0,$c0,' ',$ff,$e0
	dc.b	$0f,$9e,$0f,$86,$0c,'x',$0f,$fe
	dc.b	'G',$fc,'G',$fc,'8',$03,$7f,$ff
	dc.b	$9f,$9e,$1f,$86,$e0,'x',$ff,$fe
	dc.b	$f3,$ef,'s',$ef,$8c,$10,$ff,$ff
	dc.b	$9f,$f6,$9f,$f6,'`',$08,$ff,$fe
	dc.b	$f3,$e0,'s',$e0,$8c,$00,$ff,$e0
	dc.b	'?',$f8,'?',$f8,$00,$00,'?',$f8
	dc.b	'9',$bf,'1',$bf,$0e,'@?',$ff
	dc.b	'?',$f0,'?',$f0,$c0,$00,$ff,$f0
	dc.b	$f3,$e0,'s',$e0,$8c,$00,$ff,$e0
	dcb.w	4
	dc.b	'9',$bf,'1',$bf,$0e,'@?',$ff
	dc.b	'?ž?',$86,$cc,'x',$ff,$fe
	dc.b	'?',$c0,$bf,$c0,$c0,' ',$ff,$e0
	dc.b	$0f,$f6,$07,$f6,$08,$08,$0f,$fe
	dc.b	's',$fc,$f3,$fc,$8c,$03,$ff,$ff
	dc.b	$9f,$94,$1f,$84,$e0,'x',$ff,$fc
	dc.b	$00,'<',$00,$1c,$00,'#',$00,'?'
	dc.b	$f8,$00,$f8,$00,$00,$00,$f8,$00
	dc.b	'q',$e0,'q',$e0,$8e,$00,$ff,$e0
	dc.b	$0f,$1e,$0f,$02,$08,$fc,$0f,$fe
	dc.b	'?',$fc,'?',$fc,$00,$03,'?',$ff
	dc.b	'?',$ce,'?',$c2,$c0,'<',$ff,$fe
	dc.b	$e1,$ff,$e1,$ff,$1e,$00,$ff,$ff
	dc.b	$cf,$f2,$cf,$f2,'0',$0c,$ff,$fe
	dc.b	$e1,$e0,$e1,$e0,$1e,$00,$ff,$e0
	dc.b	$0f,$e0,$0f,$e0,$00,$00,$0f,$e0
	dc.b	$07,$8e,$07,$8e,$00,'q',$07,$ff
	dc.b	$0f,$c0,$0f,$c0,$f0,$00,$ff,$c0
	dc.b	$e1,$e0,$e1,$e0,$1e,$00,$ff,$e0
	dcb.w	4
	dc.b	$07,$8e,$07,$8e,$00,'q',$07,$ff
	dc.b	$07,$1e,$07,$02,$e0,$fc,$e7,$fe
	dc.b	'q',$e0,'q',$e0,$8e,$00,$ff,$e0
	dc.b	$0f,$f2,$0f,$f2,$00,$0c,$0f,$fe
	dc.b	$e7,$fc,$e7,$fc,$18,$03,$ff,$ff
	dc.b	'?',$d8,'?',$d8,$c0,' ',$ff,$f8
	dc.b	$00,'8',$00,'8',$00,$07,$00,'?'
	dc.b	'x',$00,'x',$00,$80,$00,$f8,$00
	dcb.w	80
	dc.b	'Q ',$e0,$e0,$ff,$c0,$ff,$e0
	dc.b	$06,$f2,$0f,$02,$0f,$fc,$0f,$fe
	dc.b	'Q ',$e0,$e0,$ff,$c0,$ff,$e0
	dc.b	$0e,$a4,$08,$9c,$07,'x',$0f,$fc
	dc.b	$e1,$ff,$e1,$ff,$1e,$00,$ff,$ff
	dc.b	$cf,$f2,$cf,$f2,'0',$0c,$ff,$fe
	dc.b	'8',$e0,$c7,$c0,$ff,$e0,$ff,$e0
	dc.b	$0e,'8',$07,$c6,$0f,$fe,$0f,$fe
	dc.b	'7',$90,'x',$10,$7f,$e0,$7f,$f0
	dc.b	$0d,$e4,$1e,$04,$1f,$f8,$1f,$fc
	dc.b	'r',$13,$fc,$0f,$ff,$ff,$ff,$ff
	dc.b	$9c,$9e,$e0,'~',$ff,$fc,$ff,$fe
	dcb.w	8
	dc.b	$00,$0e,$00,$0d,$00,$03,$00,$0f
	dc.b	'g',$00,$9e,$00,$ff,$00,$ff,$00
	dc.b	$00,$e6,$00,'y',$00,$ff,$00,$ff
	dc.b	'0',$00,$f0,$00,$c0,$00,$f0,$00
	dcb.w	8
	dc.b	'+`p',$e0,$ff,$80,$ff,$e0
	dc.b	$0b,'f',$07,$86,$0f,$f8,$0f,$fe
	dc.b	'+`p',$e0,$ff,$80,$ff,$e0
	dc.b	$17,'l',$16,$1c,$0b,$f0,$1f,$fc
	dc.b	$f3,$ef,'s',$ef,$8c,$10,$ff,$ff
	dc.b	$9f,$f6,$9f,$f6,'`',$08,$ff,$fe
	dc.b	$9d,$e0,$e3,$a0,$7f,$c0,$ff,$e0
	dc.b	$0f,'r',$0b,$8e,$07,$fc,$0f,$fe
	dc.b	'[0<0',$7f,$c0,$7f,$f0
	dc.b	$16,$cc,$0f,$0c,$1f,$f0,$1f,$fc
	dc.b	';3|',$0f,$ff,$ff,$ff,$ff
	dc.b	'r',$be,$80,'~',$ff,$f8,$ff,$fe
	dcb.w	8
	dc.b	$00,$1d,$00,$19,$00,$07,$00,$1f
	dc.b	'o',$00,$9d,$00,$fe,$00,$ff,$00
	dc.b	$00,'v',$00,'9',$00,$ff,$00,$ff
	dc.b	$b8,$00,$b8,$00,$c0,$00,$f8,$00
	dcb.w	8
	dc.b	$0a,$e0,'1',$e0,$ff,$00,$ff,$e0
	dc.b	$0d,'N',$03,$8e,$0f,$f0,$0f,$fe
	dc.b	$0a,$e0,'1',$e0,$ff,$00,$ff,$e0
	dc.b	$27,$dc,$27,'<',$19,$e0,'?',$fc
	dc.b	$ff,$f7,'?',$e7,$c0,$18,$ff,$ff
	dc.b	'?',$ee,';',$ee,$c4,$10,$ff,$fe
	dc.b	$cd,$e0,$f3,'`?',$80,$ff,$e0
	dc.b	$0f,'f',$0d,$9e,$03,$f8,$0f,$fe
	dc.b	'jp',$1c,'p',$7f,$80,$7f,$f0
	dc.b	$1a,$9c,$07,$1c,$1f,$e0,$1f,$fc
	dc.b	$1d,$f4,'>',$0f,$ff,$ff,$ff,$ff
	dc.b	'w~',$80,$fe,$ff,$f0,$ff,$fe
	dcb.w	8
	dc.b	$00,'8',$00,'0',$00,$0f,$00,'?'
	dc.b	$9f,$00,$ff,$00,$f8,$00,$ff,$00
	dc.b	$00,$99,$00,$9f,$00,$7f,$00,$ff
	dc.b	'l',$00,'l',$00,$90,$00,$fc,$00
	dcb.w	8
	dc.b	$80,$e0,$9f,$e0,$7f,$00,$e0,$e0
	dc.b	$06,$0e,$09,$fe,$0f,$f0,$0e,$0e
	dc.b	$80,$e0,$9f,$e0,$7f,$00,$e0,$e0
	dc.b	't',$1c,'G',$fc,';',$e0,'|',$1c
	dc.b	$e0,$f8,$1f,$e7,$ff,$1f,$e0,$f8
	dc.b	':',$0e,$fd,$fe,$c7,$f0,'>',$0e
	dc.b	$e0,$c0,$ff,$c0,$1f,' ',$e0,$e0
	dc.b	$06,$0e,$07,$fe,$09,$f0,$0e,$0e
	dc.b	'0pO',$f0,$7f,$80,'pp'
	dc.b	$0c,$1c,$13,$fc,$1f,$e0,$1c,$1c
	dc.b	$80,$00,$9f,$ff,$7f,$ff,$e0,$00
	dc.b	$00,$0e,$ff,$fe,$ff,$f0,$00,$0e
	dcb.w	8
	dc.b	$00,',',$00,'1',$00,$1f,$00,'>'
	dc.b	$0f,$00,$ff,$00,$f0,$00,$0f,$00
	dc.b	$00,$c0,$00,$cf,$00,'?',$00,$f0
	dc.b	'D',$00,$c4,$00,$b8,$00,'|',$00
	dcb.w	8
	dc.b	$df,$e0,$c0,$e0,'?',$00,$e0,$e0
	dc.b	$03,$fe,$0c,$0e,$0f,$f0,$0e,$0e
	dc.b	$df,$e0,$c0,$e0,'?',$00,$e0,$e0
	dc.b	$f7,$fc,$a0,$1c,$7f,$e0,$f8,$1c
	dc.b	$ff,$ef,$00,$f0,$ff,$1f,$e0,$f8
	dc.b	$fd,$fe,'>',$0e,$c7,$f0,'>',$0e
	dc.b	$ff,$90,$e0,$90,$1f,'`',$e0,$f0
	dc.b	$13,$fe,$12,$0e,$0d,$f0,$1e,$0e
	dc.b	$1f,$f0,'`p',$7f,$80,'pp'
	dc.b	$07,$fc,$18,$1c,$1f,$e0,$1c,$1c
	dc.b	$df,$ff,$c0,$00,'?',$ff,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dcb.w	8
	dc.b	$00,'g',$00,'X',$00,'?',$00,'|'
	dc.b	$fe,$00,$1e,$00,$e0,$00,$1e,$00
	dc.b	$00,$ff,$00,$c0,$00,'?',$00,$f8
	dc.b	$ca,$00,$02,$00,$fc,$00,'>',$00
	dcb.w	8
	dc.b	$e0,$e0,$ff,$e0,$1f,$00,$e0,$e0
	dc.b	$08,$0e,$0f,$fe,$0f,$f0,$0e,$0e
	dc.b	$e0,$e1,$ff,$e1,$1f,$00,$e0,$e1
	dc.b	$e0,'<O',$fc,$ff,$c0,$f0,'<'
	dc.b	$a0,$e0,'_',$ff,$ff,$1f,$e0,$f8
	dc.b	'>',$0e,$ff,$fe,$c7,$f0,'>',$0e
	dc.b	$e0,$08,$ff,$08,$1f,$f0,$e0,$f8
	dc.b	' ',$0e,'!',$fe,$1f,$f0,'>',$0e
	dc.b	'@p',$7f,$f0,$7f,$80,'pp'
	dc.b	$10,$1c,$1f,$fc,$1f,$e0,$1c,$1c
	dc.b	$e0,$00,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$00,$0e,$ff,$fe,$ff,$f0,$00,$0e
	dcb.w	8
	dc.b	$00,'p',$00,$7f,$00,'?',$00,'x'
	dc.b	'4',$00,$f4,$00,$c8,$00,'<',$00
	dc.b	$00,'D',$00,'[',$00,'?',$00,'|'
	dc.b	$1e,$00,$e2,$00,$fc,$00,$1e,$00
	dcb.w	8
	dc.b	'?',$e0,' ',$e0,$df,$00,$e0,$e0
	dc.b	$0f,$fe,$0e,$0e,$0f,$f0,$0e,$0e
	dc.b	'?',$e3,' ',$e2,$df,$01,$e0,$e3
	dc.b	$ff,$f8,$c0,'x',$ff,$80,$e0,'x'
	dc.b	$1f,$e7,$e0,$f8,$ff,$1f,$e0,$f8
	dc.b	$eb,$fe,'.',$0e,$d7,$f0,'>',$0e
	dc.b	$ff,$94,$e0,$04,$1f,$f8,$e0,'|'
	dc.b	'S',$fe,'@',$0e,'?',$f0,'|',$0e
	dc.b	$1f,$f0,'`p',$7f,$80,'pp'
	dc.b	$1f,$fc,$1c,$1c,$1f,$e0,$1c,$1c
	dc.b	$9f,$ff,$80,$00,$7f,$ff,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dcb.w	8
	dc.b	$00,$1f,$00,'x',$00,$7f,$00,'x'
	dc.b	$ec,$00,',',$00,$d0,$00,'<',$00
	dc.b	$00,'/',$00,' ',$00,$1f,$00,'<'
	dc.b	$e8,$00,$00,$00,$fe,$00,$1e,$00
	dcb.w	8
	dc.b	$1f,$c0,$00,$c0,$ff,' ',$e0,$e0
	dc.b	$0f,$fe,$0e,$0e,$0f,$f0,$0e,$0e
	dc.b	$1f,$e7,$00,$e5,$ff,$03,$e0,$e7
	dc.b	$ff,$f0,$80,$f0,$ff,$00,$c0,$f0
	dc.b	$1f,$f7,$e0,$f8,$ff,$1f,$e0,$f8
	dc.b	$e9,$fe,'.',$0e,$d7,$f0,'>',$0e
	dc.b	$ff,$b9,$f0,$07,$0f,$ff,$f0,$7f
	dc.b	';',$fe,$c0,$1e,$ff,$e0,$fc,$1e
	dc.b	'o',$e4,'pc',$7f,$9f,'p',$7f
	dc.b	'O',$fc,$8c,$1c,$ff,$e0,$fc,$1c
	dc.b	'?',$ff,$00,$00,$ff,$ff,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dcb.w	8
	dc.b	$00,$cf,$00,$b0,$00,$7f,$00,$f0
	dc.b	$c8,$00,'H',$00,$b0,$00,'x',$00
	dc.b	$00,$11,$00,$10,$00,$0f,$00,$1e
	dc.b	$f0,$00,$00,$00,$fe,$00,$0e,$00
	dcb.w	8
	dc.b	'@',$80,$00,$80,$ff,'`',$e0,$e0
	dc.b	$08,$0e,$0e,$0e,$0f,$f0,$0e,$0e
	dc.b	'@',$ef,$00,$ea,$ff,$07,$e0,$ef
	dc.b	$81,$e0,$01,$e0,$fe,$00,$81,$e0
	dc.b	'@',$f8,$e0,$f8,$ff,$1f,$e0,$f8
	dc.b	'*',$0e,'.',$0e,$d7,$f0,'>',$0e
	dc.b	$80,';',$80,$07,$7f,$ff,$f0,'?'
	dc.b	$b8,$02,$c0,$02,$ff,$fc,$f8,$1e
	dc.b	'pLpC',$7f,$bf,'p',$7f
	dc.b	'd',$1c,$84,$1c,$ff,$e0,$fc,$1c
	dc.b	$df,$ff,$1f,$ff,$e0,$00,$ff,$ff
	dc.b	$e0,$0e,$e0,$0e,$1f,$f0,$e0,$0e
	dcb.w	8
	dc.b	$00,$f0,$00,$80,$00,$7f,$00,$f0
	dc.b	'@',$00,'@',$00,$b0,$00,'p',$00
	dc.b	$00,$16,$00,$16,$00,$09,$00,$1e
	dc.b	$08,$00,$08,$00,$f6,$00,$0e,$00
	dcb.w	8
	dc.b	$ff,$80,$00,$80,$ff,'`',$e0,$e0
	dc.b	$01,$fa,$0e,$0a,$0f,$f4,$0e,$0e
	dc.b	$ff,$f6,$00,$f0,$ff,$0f,$e0,$ff
	dc.b	$ff,$c0,$03,$c0,$fc,$00,$03,$c0
	dc.b	$ff,$ff,$e0,$f8,$ff,$1f,$e0,$f8
	dc.b	$ef,$fe,'.',$0e,$d7,$f0,'>',$0e
	dc.b	'G',$f1,'@',$0f,'?',$ff,'x',$0f
	dc.b	$1f,$c4,$e0,$04,$ff,$f8,$e0,'<'
	dc.b	'o',$de,'p',$01,$7f,$ff,'p?'
	dc.b	's',$f4,$80,$14,$ff,$e8,$fc,$1c
	dc.b	$bf,$fe,'?',$fe,$c0,$01,$ff,$ff
	dc.b	$7f,$ee,$00,$0e,$ff,$f0,$80,$1e
	dcb.w	8
	dc.b	$00,'?',$00,$00,$00,$ff,$00,$f0
	dc.b	$d0,$00,'P',$00,$a0,$00,'p',$00
	dc.b	$00,$0f,$00,$0e,$00,$01,$00,$0e
	dc.b	$fe,$00,$0e,$00,$f0,$00,$0e,$00
	dcb.w	8
	dc.b	$e0,$80,$00,$80,$ff,'`',$e0,$e0
	dc.b	$02,$00,$0c,$00,$0f,$fe,$0e,$0e
	dc.b	$e0,$fc,$00,$e0,$ff,$1f,$e0,$fe
	dc.b	$07,$80,$07,$80,$f8,$00,$07,$80
	dc.b	$e0,$f0,$e0,$f8,$ff,$1f,$e0,$f8
	dc.b	'.',$0e,'.',$0e,$d7,$f0,'>',$0e
	dc.b	'l',$00,'l',$00,$13,$ff,'|',$00
	dc.b	$00,'l',$00,'l',$ff,$90,$00,'|'
	dc.b	$00,$00,'p',$00,$7f,$ff,'p',$00
	dc.b	$00,$14,$00,$14,$ff,$e8,$00,$1c
	dc.b	$7f,$e0,$7f,$e2,$80,$1f,$ff,$fe
	dc.b	$00,'&',$00,'&',$ff,$d8,$00,'>'
	dcb.w	10
	dc.b	$00,$ff,$00,$e0,$f0,$00,$f0,$00
	dc.b	$00,$00,$f0,$00,$00,$0e,$00,$0e
	dc.b	$00,$01,$00,$0f,$06,$00,$06,$00
	dc.b	$f8,$00,$06,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	$a0,$80,'@',$80,$ff,'`',$e0,$e0
	dc.b	$0e,$04,$00,$00,$0f,$fe,$0e,$0e
	dc.b	$a0,$d8,'@',$d0,$ff,'?',$e0,$fc
	dc.b	$0f,$00,$0f,$00,$f0,$00,$0f,$00
	dc.b	'@',$e0,$e0,$f8,$ff,$1f,$e0,$f8
	dc.b	'>',$0e,'>',$0e,$c7,$f0,'>',$0e
	dc.b	'>',$00,'>',$00,$01,$ff,'>',$00
	dc.b	$00,$f8,$00,$f8,$ff,$00,$00,$f8
	dc.b	'X',$00,' ',$00,$7f,$ff,'x',$00
	dc.b	$00,'4',$00,$04,$ff,$f8,$00,'<'
	dc.b	$04,'8',$04,$00,$03,$ff,$07,$f8
	dc.b	$00,$ec,$00,$ec,$ff,$10,$00,$fc
	dcb.w	8
	dc.b	$00,$e0,$00,$e0,$00,$1f,$00,$e0
	dc.b	$e0,$00,$e0,$00,$00,$00,$e0,$00
	dc.b	$00,$08,$00,$08,$00,$07,$00,$0f
	dc.b	$06,$00,$06,$00,$f8,$00,$06,$00
	dcb.w	8
	dc.b	$1f,$80,$ff,$80,$e0,'`',$e0,$e0
	dc.b	$01,$f4,$01,$f0,$0e,$0e,$0e,$0e
	dc.b	$1f,$ff,$ff,$d7,$e0,'8',$e0,$f8
	dc.b	$fe,$00,$fe,$00,$00,$00,$1e,$00
	dc.b	$1f,$ef,$ff,$f7,$e0,$18,$e0,$f8
	dc.b	$fb,$fe,$ff,$fe,$06,$00,'>',$0e
	dc.b	$1d,$ff,$11,$ff,$0e,$00,$1f,$00
	dc.b	$ff,'p',$ff,$10,$00,$e0,$01,$f0
	dc.b	'w',$ff,'G',$ff,'8',$00,'x',$00
	dc.b	$ff,$dc,$ff,$c4,$00,'8',$00,'<'
	dc.b	$1b,$ff,$14,$1f,$0f,$e0,$1f,$e0
	dc.b	$ff,$f8,$ff,$f8,$00,$00,$03,$f8
	dcb.w	8
	dc.b	$00,$df,$00,$df,$00,' ',$00,$e0
	dc.b	$e0,$00,$e0,$00,$00,$00,$e0,$00
	dc.b	$00,$08,$00,$08,$00,$07,$00,$0f
	dc.b	$fe,$00,$fe,$00,$00,$00,$06,$00
	dcb.w	8
	dc.b	'@',$c0,$e0,$c0,$ff,' ',$e0,$e0
	dc.b	$08,$00,$00,$00,$0f,$fe,$0e,$0e
	dc.b	'@',$b0,$e0,$a0,$ff,$7f,$e0,$f0
	dc.b	'<',$00,'<',$00,$c0,$00,'<',$00
	dc.b	$a0,$f8,'@',$e0,$ff,$1f,$e0,$f8
	dc.b	'8',$0e,'>',$0e,$c7,$f0,'>',$0e
	dc.b	'.',$00,'>',$00,$1f,$ff,'>',$00
	dc.b	$00,$e8,$00,$f8,$ff,$f0,$00,$f8
	dc.b	'd',$00,'@',$00,'?',$ff,'|',$00
	dc.b	$00,'L',$00,$04,$ff,$f8,$00,'|'
	dc.b	'1',$80,'.',$00,$1f,$ff,'?',$80
	dc.b	$0f,$f0,$0f,$f0,$f0,$00,$0f,$f0
	dcb.w	10
	dc.b	$00,$ff,$00,$e0,$e0,$00,$e0,$00
	dc.b	$00,$00,$e0,$00,$00,$0f,$00,$08
	dc.b	$00,$07,$00,$0f,$06,$00,$06,$00
	dc.b	$f8,$00,$06,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	$ff,$95,$ff,$8e,$e0,$7f,$e0,$ff
	dc.b	$a5,$fa,$19,$fa,$fe,$04,$fe,$0e
	dc.b	$ff,$ff,$ff,$bf,$e0,'`',$e0,$e0
	dc.b	$f8,$00,$f8,$00,$00,$00,'x',$00
	dc.b	$ff,$ff,$1f,$e7,$e0,$18,$e0,$f8
	dc.b	$f9,$fe,$ff,$fe,$06,$00,'>',$0e
	dc.b	'[',$ff,$7f,$ff,'<',$00,'|',$00
	dc.b	$ff,$b4,$ff,$fc,$00,'x',$00,'|'
	dc.b	')',$ff,'&',$ff,$1f,$00,'?',$00
	dc.b	$ff,'(',$fe,$c8,$01,$f0,$01,$f8
	dc.b	'Y',$ff,$7f,$ff,'>',$00,'~',$00
	dc.b	$ff,'L',$ff,'<',$00,$fe,'?',$fe
	dcb.w	8
	dc.b	$00,'?',$00,$1f,$00,$e0,$00,$e0
	dc.b	$f0,$00,$f0,$00,$00,$00,$f0,$00
	dc.b	$00,$07,$00,$00,$00,$0f,$00,$0f
	dc.b	$fe,$00,$fe,$00,$00,$00,$06,$00
	dcb.w	8
	dc.b	$ff,',',$1f,$1f,$e0,$ff,$e0,$ff
	dc.b	$93,$fe,$0d,$fe,$fe,$00,$fe,$0e
	dc.b	$ff,$ff,$ff,$bf,$e0,'@',$e0,$c0
	dc.b	$f0,$00,$f0,$00,$00,$00,$f0,$00
	dc.b	$ff,$cf,$1f,$c7,$e0,'8',$e0,$f8
	dc.b	$f7,$fe,$f1,$fe,$0e,$00,'>',$0e
	dc.b	$27,$f8,$1f,$f8,'x',$07,'x',$0f
	dc.b	'?',$c8,'?',$f0,$c0,'<',$e0,'<'
	dc.b	'2O<O',$0f,$b0,'?',$f8
	dc.b	$fc,$98,$fc,'x',$03,$e0,'?',$f8
	dc.b	$ff,$ff,$bf,$ff,'x',$00,$f8,$00
	dc.b	$f7,$1a,$f0,$fa,$0f,$fc,$ff,$fe
	dcb.w	8
	dc.b	$00,$cf,$00,'?',$00,$f0,$00,$f0
	dc.b	$f0,$00,$f0,$00,$00,$00,'p',$00
	dc.b	$00,$1f,$00,$11,$00,$0e,$00,$1e
	dc.b	$fe,$00,$fe,$00,$00,$00,$0e,$00
	dcb.w	8
	dc.b	$e0,'^',$1f,$bf,$e0,$7f,$e0,$7f
	dc.b	$90,$0e,$0f,$fe,$fc,$00,$fc,$0e
	dc.b	'@',$01,$ff,$ff,$e0,$00,$e0,$01
	dc.b	$e0,$00,$e0,$00,$00,$00,$e0,$00
	dc.b	'@',$00,$1f,$8f,$e0,'p',$e0,'p'
	dc.b	$00,$0e,$e3,$fe,$1c,$00,$1c,$0e
	dc.b	$f0,'=',$8f,$fd,'p',$02,$f0,'?'
	dc.b	'x',$1e,$7f,$e2,$80,$1c,$f8,$1e
	dc.b	$1c,$f8,$18,$f7,$07,$08,$1f,$f8
	dc.b	'>p',$fe,'0',$01,$c0,'?',$f0
	dc.b	$b0,$03,$7f,$ff,$f0,$00,$f0,$03
	dc.b	'<v',$03,$f6,$ff,$f8,$ff,$fe
	dcb.w	8
	dc.b	$00,$b0,$00,$ff,$00,'p',$00,$f0
	dc.b	'x',$00,$f8,$00,$00,$00,'x',$00
	dc.b	$00,$18,$00,$17,$00,$0e,$00,$1e
	dc.b	$0e,$00,$fe,$00,$00,$00,$0e,$00
	dcb.w	8
	dc.b	$1f,$ff,$ff,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$0e
	dc.b	$ff,$ff,$1f,$ff,$e0,$00,$e0,$03
	dc.b	$c0,$00,$c0,$00,$00,$00,$c0,$00
	dc.b	$1f,$ff,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$0e
	dc.b	$9f,$bf,$8f,$bf,'p@',$f0,$7f
	dc.b	$fb,$f2,$fb,$e2,$04,$1c,$fc,$1e
	dc.b	$03,$f7,$03,$ef,$00,$18,$03,$f8
	dc.b	$ff,$80,$ff,$80,$00,$00,'?',$80
	dc.b	$9f,$ff,$7f,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fc,$ff,$fc,$00,$02,$00,$0e
	dcb.w	8
	dc.b	$00,$ef,$00,$ff,$00,'p',$00,$f0
	dc.b	$e8,$00,$e8,$00,$10,$00,'x',$00
	dc.b	$00,')',$00,$27,$00,$1e,$00,'>'
	dc.b	$fe,$00,$fe,$00,$00,$00,$0e,$00
	dcb.w	8
	dc.b	$b0,$00,'O',$ff,$f0,$00,$f0,$00
	dc.b	$00,$1e,$ff,$fe,$00,$00,$00,$1e
	dc.b	'@',$07,$1f,$ff,$e0,$00,$e0,$07
	dc.b	$80,$00,$80,$00,$00,$00,$80,$00
	dc.b	$00,$00,$0f,$ff,$f0,$00,$f0,$00
	dc.b	$00,$1e,$ff,$fe,$00,$00,$00,$1e
	dc.b	$80,'<',$9f,$bc,'`@',$e0,'|'
	dc.b	'x',$02,'{',$f2,$04,$0c,'|',$0e
	dc.b	$00,'(',$00,$1f,$00,'8',$00,'8'
	dc.b	'8',$00,$f8,$00,$00,$00,'8',$00
	dc.b	$e0,$00,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$00,$0c,$ff,$fc,$00,$02,$00,$0e
	dcb.w	8
	dc.b	$00,'X',$00,$27,$00,'x',$00,'x'
	dc.b	$04,$00,$c4,$00,'8',$00,'<',$00
	dc.b	$00,'|',$00,'c',$00,$1c,$00,'|'
	dc.b	$1e,$00,$fe,$00,$00,$00,$1e,$00
	dcb.w	8
	dc.b	$ef,$ff,$80,$00,'p',$00,$f0,$00
	dc.b	$ff,$fe,$00,$1e,$00,$00,$00,$1e
	dc.b	$1f,$ff,$00,$0f,$e0,$00,$e0,$0f
	dcb.w	4
	dc.b	$bf,$ff,$80,$00,'p',$00,$f0,$00
	dc.b	$ff,$fc,$00,$1c,$00,$00,$00,$1c
	dc.b	$df,$d8,$c0,$18,' ',$e0,$e0,$f8
	dc.b	'7',$f6,'0',$06,$0e,$08,'>',$0e
	dc.b	$00,'?',$00,'8',$00,'8',$00,'8'
	dc.b	$f8,$00,'8',$00,$00,$00,'8',$00
	dc.b	$ff,$ff,$00,$00,$e0,$00,$e0,$00
	dc.b	$ff,$fc,$00,$0c,$00,$02,$00,$0e
	dcb.w	8
	dc.b	$00,'w',$00,'@',$00,'8',$00,'x'
	dc.b	$ce,$00,$0e,$00,'0',$00,'>',$00
	dc.b	$00,$c7,$00,$c0,$00,'<',$00,$fc
	dc.b	$ee,$00,$0e,$00,$10,$00,$1e,$00
	dcb.w	8
	dc.b	$c8,$00,$87,$ff,'x',$00,$f8,$00
	dc.b	$00,$1c,$ff,$dc,$00,' ',$00,'<'
	dc.b	$b0,$1e,$bf,$fe,'@',$00,$f0,$1e
	dcb.w	4
	dc.b	'`',$01,$1f,$ff,'x',$00,'x',$01
	dc.b	$00,'$',$ff,$c4,$00,'8',$00,'<'
	dc.b	$e0,'p',$ff,$90,$00,$e0,$e0,$f0
	dc.b	$1c,$0e,$13,$fe,$0e,$00,$1e,$0e
	dc.b	$00,'0',$00,'?',$00,'8',$00,'8'
	dc.b	'8',$00,$f8,$00,$00,$00,'8',$00
	dc.b	$c0,$00,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$00,$0e,$ff,$fe,$00,$00,$00,$0e
	dcb.w	8
	dc.b	$00,'@',$00,'C',$00,'<',$00,'|'
	dc.b	$1d,$00,$fd,$00,$02,$00,$1f,$00
	dc.b	$00,$e0,$00,$e7,$00,$18,$00,$f8
	dc.b	$04,$00,$c4,$00,'8',$00,'<',$00
	dcb.w	8
	dc.b	'S',$ff,'L',$00,'>',$00,'~',$00
	dc.b	$ff,$cc,$00,$cc,$00,'0',$00,$fc
	dc.b	$ff,$fc,$f8,'|',$00,$00,$f8,'|'
	dcb.w	4
	dc.b	'C',$ff,'|',$07,'>',$00,'~',$07
	dc.b	$bf,'\@$',$c0,$f8,$c0,$fc
	dc.b	$ff,' ',$e0,$c0,$00,$e0,$e0,$e0
	dc.b	$09,$fe,$06,$0e,$0e,$00,$0e,$0e
	dc.b	$00,'/',$00,'0',$00,'8',$00,'8'
	dc.b	$f8,$00,'8',$00,$00,$00,'8',$00
	dc.b	$9f,$ff,$00,$00,$e0,$00,$e0,$00
	dc.b	$ff,$fe,$00,$0e,$00,$00,$00,$0e
	dcb.w	8
	dc.b	$00,$27,$00,' ',$00,$1e,$00,'>'
	dc.b	$f9,$00,$09,$00,$06,$00,$0f,$00
	dc.b	$00,$bf,$00,'0',$00,$c0,$00,$f0
	dc.b	$c4,$00,'D',$00,'8',$00,'|',$00
	dcb.w	8
	dc.b	'd',$ff,'x',$ff,$1f,$00,$7f,$ff
	dc.b	$ff,$e8,$ff,$e8,$00,$10,$ff,$f8
	dc.b	$7f,$f8,$7f,$f8,$00,$00,$7f,$f8
	dcb.w	4
	dc.b	'#_<',$1f,$1f,$e0,'?',$ff
	dc.b	$b6,'Hx8',$ff,$f0,$ff,$f8
	dc.b	$f7,$80,$e7,$e0,$18,$e0,$ff,$e0
	dc.b	$03,$de,$0f,$ce,$0e,'0',$0f,$fe
	dc.b	$00,$1f,$00,'/',$00,'0',$00,'?'
	dc.b	$b8,$00,$b8,$00,'@',$00,$f8,$00
	dc.b	$bf,$f9,'?',$f8,$c0,$07,$ff,$ff
	dc.b	$e6,'>',$06,$0e,$f9,$f0,$ff,$fe
	dcb.w	8
	dc.b	$00,'>',$00,'1',$00,$0f,$00,'?'
	dc.b	$f7,$00,$f7,$00,$08,$00,$ff,$00
	dc.b	$00,'?',$00,$1f,$00,$e0,$00,$ff
	dc.b	$e8,$00,$e8,$00,$10,$00,$f8,$00
	dcb.w	8
	dc.b	'9',$f0,'1',$f0,$0e,$0f,'?',$ff
	dc.b	$ff,$f0,$ff,$f0,$00,$00,$ff,$f0
	dc.b	$7f,$f0,$7f,$f0,$00,$00,$7f,$f0
	dcb.w	4
	dc.b	$1e,'N',$10,$0e,$0f,$f1,$1f,$ff
	dc.b	'30',$fc,$10,$ff,$e0,$ff,$f0
	dc.b	$f3,$e0,$c3,$e0,'<`',$ff,$e0
	dc.b	$0f,$9e,$0f,$86,$0c,'x',$0f,$fe
	dc.b	$00,'?',$00,$1f,$00,' ',$00,'?'
	dc.b	$d8,$00,$d8,$00,' ',$00,$f8,$00
	dc.b	$7f,$fc,$7f,$fc,$80,$03,$ff,$ff
	dc.b	$9f,$9e,$1f,$86,$e0,'x',$ff,$fe
	dcb.w	8
	dc.b	$00,$1d,$00,$1b,$00,$06,$00,$1f
	dc.b	$fb,$00,$fb,$00,$04,$00,$ff,$00
	dc.b	$00,$ff,$00,$ff,$00,$00,$00,$ff
	dc.b	$f0,$00,$f0,$00,$00,$00,$f0,$00
	dcb.w	8
	dc.b	$07,$e0,$07,$e0,$00,$1f,$07,$ff
	dc.b	'?',$c0,'?',$c0,$c0,$00,$ff,$c0
	dc.b	$1f,$e0,$1f,$e0,$00,$00,$1f,$e0
	dcb.w	4
	dc.b	$06,'n',$04,$0e,$03,$f0,$07,$fe
	dc.b	$a3,'@',$bc,'@',$7f,$80,$ff,$c0
	dc.b	$f1,$e0,$81,$e0,'~ ',$ff,$e0
	dc.b	$0f,$1e,$0f,$02,$08,$fc,$0f,$fe
	dc.b	$00,'?',$00,'?',$00,$00,$00,'?'
	dc.b	$c8,$00,$c8,$00,'0',$00,$f8,$00
	dc.b	$ff,$fc,$ff,$fc,$00,$03,$ff,$ff
	dc.b	'?',$ce,'?',$c2,$c0,'<',$ff,$fe
	dcb.w	8
	dc.b	$00,$0f,$00,$0f,$00,$00,$00,$0f
	dc.b	$f1,$00,$f1,$00,$0e,$00,$ff,$00
	dc.b	$00,$f9,$00,$f9,$00,$06,$00,$ff
	dc.b	$e0,$00,$e0,$00,$00,$00,$e0,$00
	dcb.w	168
l003c	dc.b	$00,$e0,$00,$f0,$00,$80,$00,$90
	dc.b	'A',$80,'A',$90,'A',$c0,'A',$d0
	dc.b	$01,'0',$01,'0',$01,'0A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,$00,$00
	dc.b	$00,$10,' ',$e0,' ',$f0,'!',$00
	dc.b	'!',$10,'!',$a0,'!',$b0,$00,$e0
	dc.b	$00,$f0,$00,$80,$00,$90,'!`'
	dc.b	'!pA',$c0,'A',$d0,'!',$80
	dc.b	'!',$90,$00,'@',$00,'P!`'
	dc.b	'!p',$00,$80,$00,$90,$00,$80
	dc.b	$00,$90,' ',$e0,' ',$f0,'A',$c0
	dc.b	'A',$d0,$00,'@',$00,'P!',$00
	dc.b	'!',$10,$00,'`',$00,'p',$00,$80
	dc.b	$00,$90,$00,'`',$00,'pA',$c0
	dc.b	'A',$d0,$00,' ',$00,'0A',$80
	dc.b	'A',$90,'A',$c0,'A',$d0,'!',$80
	dc.b	'!',$90,'!',$a0,'!',$b0,'!`'
	dc.b	'!p',$01,$00,'A`Ap'
	dc.b	'A',$c0,'A',$d0,$01,'0',$01,'0'
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,' ',$e0,' ',$f0
	dc.b	'!',$00,'!',$10,'A@AP'
	dc.b	'A',$c0,'A',$d0,'!',$a0,'!',$b0
	dc.b	$00,$e0,$00,$f0,$01,$00,'!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,$01,$00
	dc.b	'!',$80,'!',$90,'A',$c0,'A',$d0
	dc.b	'!',$a0,'!',$b0,$00,$e0,$00,$f0
	dc.b	$00,$80,$00,$90,$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$00,' ',$00,'0',$01,' '
	dc.b	' ',$c0,' ',$d0,$01,' ',$00,$c0
	dc.b	$00,$d0,$01,' A',$c0,'A',$d0
	dc.b	$00,$c0,$00,$d0,'!`!p'
	dc.b	$00,$80,$00,$90,$00,$80,$00,$90
	dc.b	'!',$a0,'!',$b0,$01,$00,' ',$e0
	dc.b	' ',$f0,$00,$c0,$00,$d0,'!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,'!',$80
	dc.b	'!',$90,$00,'@',$00,'P!`'
	dc.b	'!p',$00,$80,$00,$90,$00,$80
	dc.b	$00,$90,' ',$e0,' ',$f0,'A',$c0
	dc.b	'A',$d0,$01,'0',$01,' ',$01,' '
	dc.b	$01,' ',$01,' A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'!',$80,'!',$90
	dc.b	'!',$00,'!',$10,'A',$c0,'A',$d0
	dc.b	$00,$c0,$00,$d0,'!`!p'
	dc.b	$00,$80,$00,$90,$00,$80,$00,$90
	dc.b	'!',$a0,'!',$b0,$01,$00,' ',$e0
	dc.b	' ',$f0,$00,$c0,$00,$d0,'!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,$00,$c0
	dc.b	$00,$d0,'!',$00,'!',$10,'A',$c0
	dc.b	'A',$d0,'!',$a0,'!',$b0,'!',$00
	dc.b	'!',$10,'A',$c0,'A',$d0,$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,' ',$c0
	dc.b	' ',$d0,$00,$00,$00,$10,$00,'@'
	dc.b	$00,'P',$00,' ',$00,'0!',$00
	dc.b	'!',$10,'A',$80,'A',$90,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$e0
	dc.b	'A',$f0,'A',$c0,'A',$d0,$00,$a0
	dc.b	$00,$b0,'!',$00,'!',$10,'!`'
	dc.b	'!pA',$c0,'A',$d0,'!',$a0
	dc.b	'!',$b0,$00,$e0,$00,$f0,$00,$80
	dc.b	$00,$90,'A',$c0,'A',$d0,$00,'`'
	dc.b	$00,'p',$00,$80,$00,$90,'!',$80
	dc.b	'!',$90,$01,$00,$00,$c0,$00,$d0
	dc.b	' ',$e0,' ',$f0,'A',$c0,'A',$d0
	dc.b	'!',$00,'!',$10,$00,$a0,$00,$b0
	dc.b	'A',$c0,'A',$d0,'!',$00,'!',$10
	dc.b	'A',$00,'A',$10,'!`!p'
	dc.b	'A',$c0,'A',$d0,$00,$00,$00,$10
	dc.b	$00,'@',$00,'P!`!p'
	dc.b	'!',$00,'!',$10,' ',$e0,' ',$f0
	dc.b	'A',$80,'A',$90,' ',$c0,' ',$d0
	dc.b	'A',$c0,'A',$d0,'B',$00,'B',$10
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	$00,$00,$00,$10,' ',$a0,' ',$b0
	dc.b	$01,$00,$00,$80,$00,$90,' ',$e0
	dc.b	' ',$f0,'A',$c0,'A',$d0,'A',$e0
	dc.b	'A',$f0,'A',$c0,'A',$d0,$00,$00
	dc.b	$00,$10,'A',$c0,'A',$d0,$00,$c0
	dc.b	$00,$d0,'!',$00,'!',$10,'!',$00
	dc.b	'!',$10,$00,'`',$00,'pA',$c0
	dc.b	'A',$d0,'!',$a0,'!',$b0,$00,$80
	dc.b	$00,$90,$00,$00,$00,$10,' ',$c0
	dc.b	' ',$d0,'A',$c0,'A',$d0,'!',$00
	dc.b	'!',$10,' ',$e0,' ',$f0,'A',$c0
	dc.b	'A',$d0,$00,$00,$00,$10,' ',$c0
	dc.b	' ',$d0,$01,$00,$00,$c0,$00,$d0
	dc.b	$00,$00,$00,$10,'A',$c0,'A',$d0
	dc.b	$01,'0A',$c0,'A',$d0,'B',$00
	dc.b	'B',$10,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'!`!pA',$00,'A',$10
	dc.b	' ',$e0,' ',$f0,'! !0'
	dc.b	'!',$00,'!',$10,'A@AP'
	dc.b	$00,$80,$00,$90,'!`!p'
	dc.b	'A',$c0,'A',$d0,$00,$00,$00,$10
	dc.b	' ',$e0,' ',$f0,$00,'`',$00,'p'
	dc.b	'A',$c0,'A',$d0,'!',$a0,'!',$b0
	dc.b	$00,$e0,$00,$f0,$00,$80,$00,$90
	dc.b	'A',$c0,'A',$d0,$00,' ',$00,'0'
	dc.b	' ',$a0,' ',$b0,$00,$00,$00,$10
	dc.b	'!',$80,'!',$90,'!',$a0,'!',$b0
	dc.b	$00,$80,$00,$90,'!`!p'
	dc.b	'!',$80,'!',$90,'A',$c0,'A',$d0
	dc.b	'A',$e0,'A',$f0,'A',$c0,'A',$d0
	dc.b	$00,$a0,$00,$b0,'!`!p'
	dc.b	$01,$00,$00,$80,$00,$90,' ',$e0
	dc.b	' ',$f0,$00,'`',$00,'p!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,'!',$00
	dc.b	'!',$10,$00,$a0,$00,$b0,'A',$c0
	dc.b	'A',$d0,'!',$80,'!',$90,'!',$a0
	dc.b	'!',$b0,$00,$80,$00,$90,'! '
	dc.b	'!0',$00,$e0,$00,$f0,'A',$80
	dc.b	'A',$90,'A',$c0,'A',$d0,'B',$00
	dc.b	'B',$10,$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,$00,$80,$00,$90
	dc.b	'!`!p',$01,$00,$00,'@'
	dc.b	$00,'PA',$c0,'A',$d0,' ',$a0
	dc.b	' ',$b0,'A',$00,'A',$10,$00,'@'
	dc.b	$00,'PA',$a0,'A',$b0,'A',$80
	dc.b	'A',$90,'!',$80,'!',$90,'A',$a0
	dc.b	'A',$b0,'A',$80,'A',$90,' ',$e0
	dc.b	' ',$f0,'A',$c0,'A',$d0,$00,$a0
	dc.b	$00,$b0,'!',$00,'!',$10,'!`'
	dc.b	'!pA',$c0,'A',$d0,$00,$e0
	dc.b	$00,$f0,$01,$00,'!',$80,'!',$90
	dc.b	'A',$c0,'A',$d0,$00,$c0,$00,$d0
	dc.b	'!',$00,'!',$10,'!',$00,'!',$10
	dc.b	$00,'`',$00,'pA',$c0,'A',$d0
	dc.b	'!',$80,'!',$90,'!',$00,'!',$10
	dc.b	$00,$a0,$00,$b0,'!',$a0,'!',$b0
	dc.b	'!',$80,'!',$90,'A',$c0,'A',$d0
	dc.b	$00,$00,$00,$10,' ',$e0,' ',$f0
	dc.b	$00,'`',$00,'pA',$c0,'A',$d0
	dc.b	$00,$e0,$00,$f0,$00,$80,$00,$90
	dc.b	' ',$a0,' ',$b0,'! !0'
	dc.b	'A',$c0,'A',$d0,$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$00,$e0,$00,$f0
	dc.b	$01,$00,'A',$c0,'A',$d0,$00,$c0
	dc.b	$00,$d0,'A',$00,'A',$10,'A',$80
	dc.b	'A',$90,'A',$c0,'A',$d0,$00,$00
	dc.b	$00,$10,' ',$e0,' ',$f0,$00,'`'
	dc.b	$00,'pA',$c0,'A',$d0,'!',$a0
	dc.b	'!',$b0,$00,$e0,$00,$f0,$00,$00
	dc.b	$00,$10,' ',$e0,' ',$f0,'A`'
	dc.b	'ApA`ApA',$c0
	dc.b	'A',$d0,$00,$00,$00,$10,'A',$c0
	dc.b	'A',$d0,' ',$a0,' ',$b0,'!',$00
	dc.b	'!',$10,'!',$a0,'!',$b0,'A',$c0
	dc.b	'A',$d0,$01,'0A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,$01,' ',$01,' '
	dc.b	$01,' A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,' ',$c0
	dc.b	' ',$d0,$01,$00,$00,'@',$00,'P'
	dc.b	'!`!p!',$00,'!',$10
	dc.b	'A',$c0,'A',$d0,$00,$00,$00,$10
	dc.b	'! !0! !0'
	dc.b	' ',$a0,' ',$b0,$01,$00,$00,'@'
	dc.b	$00,'P',$00,$00,$00,$10,'!',$a0
	dc.b	'!',$b0,$01,$00,'!',$00,'!',$10
	dc.b	' ',$e0,' ',$f0,'A',$c0,'A',$d0
	dc.b	$00,$a0,$00,$b0,'!',$00,'!',$10
	dc.b	'!`!pA',$c0,'A',$d0
	dc.b	'!',$a0,'!',$b0,$00,$e0,$00,$f0
	dc.b	$00,$80,$00,$90,$01,$00,'!`'
	dc.b	'!pA',$c0,'A',$d0,$00,$80
	dc.b	$00,$90,'A`Ap',$00,'@'
	dc.b	$00,'P',$00,$80,$00,$90,' ',$a0
	dc.b	' ',$b0,' ',$a0,' ',$b0,$00,$80
	dc.b	$00,$90,' ',$e0,' ',$f0,'!',$a0
	dc.b	'!',$b0,'A',$c0,'A',$d0,'A',$e0
	dc.b	'A',$f0,'A',$c0,'A',$d0,$00,' '
	dc.b	$00,'0A',$00,'A',$10,'!',$a0
	dc.b	'!',$b0,'A',$c0,'A',$d0,$00,$80
	dc.b	$00,$90,'A`Ap! '
	dc.b	'!0',$00,$80,$00,$90,' ',$e0
	dc.b	' ',$f0,'!',$80,'!',$90,$01,$00
	dc.b	'A A0',$00,$80,$00,$90
	dc.b	'A',$c0,'A',$d0,$01,'0A',$c0
	dc.b	'A',$d0,'B',$00,'B',$10,'A',$c0
	dc.b	'A',$d0,$00,' ',$00,'0!',$00
	dc.b	'!',$10,'!',$00,'!',$10,' ',$80
	dc.b	' ',$90,'!',$80,'!',$90,'A',$c0
	dc.b	'A',$d0,$00,$00,$00,$10,$00,' '
	dc.b	$00,'0!',$00,'!',$10,'A',$00
	dc.b	'A',$10,'!',$a0,'!',$b0,'A',$c0
	dc.b	'A',$d0,'!',$a0,'!',$b0,$00,$e0
	dc.b	$00,$f0,$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,'!',$80,'!',$90,'!',$a0
	dc.b	'!',$b0,'A',$c0,'A',$d0,$01,'0'
	dc.b	$01,'0',$01,' ',$01,' ',$01,' '
	dc.b	$01,' A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,$00,'`',$00,'p',$00,$80
	dc.b	$00,$90,'A A0! '
	dc.b	'!0',$00,$00,$00,$10,$00,'@'
	dc.b	$00,'P ',$80,' ',$90,'A',$c0
	dc.b	'A',$d0,$01,$00,$01,$00,$01,' '
	dc.b	$01,' ',$01,' ',$00,'`',$00,'p'
	dc.b	$00,$80,$00,$90,$00,$c0,$00,$d0
	dc.b	$00,$00,$00,$10,'!',$80,'!',$90
	dc.b	'A',$c0,'A',$d0,$00,$80,$00,$90
	dc.b	' ',$a0,' ',$b0,$01,$00,'!',$a0
	dc.b	'!',$b0,$00,$80,$00,$90,$01,' '
	dc.b	$01,' ',$01,' ',$00,$c0,$00,$d0
	dc.b	$00,$a0,$00,$b0,$00,$00,$00,$10
	dc.b	'A',$c0,'A',$d0,$00,' ',$00,'0'
	dc.b	$00,$00,$00,$10,'!',$80,'!',$90
	dc.b	$01,$00,$00,'@',$00,'P',$01,' '
	dc.b	$01,' ',$01,' !',$80,'!',$90
	dc.b	'!',$a0,'!',$b0,'!',$00,'!',$10
	dc.b	'!',$80,'!',$90,'A',$c0,'A',$d0
	dc.b	$00,' ',$00,'0',$00,$00,$00,$10
	dc.b	'!',$80,'!',$90,$01,$00,$00,'@'
	dc.b	$00,'P',$01,' ',$01,' ',$01,' '
	dc.b	'!@!PA',$00,'A',$10
	dc.b	$00,$00,$00,$10,'!`!p'
	dc.b	'!',$a0,'!',$b0,$00,$80,$00,$90
	dc.b	'!',$a0,'!',$b0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	$00,$00,$00,$10,' ',$e0,' ',$f0
	dc.b	$00,'`',$00,'pA',$c0,'A',$d0
	dc.b	'!',$a0,'!',$b0,$00,$e0,$00,$f0
	dc.b	$00,$80,$00,$90,$01,$00,'!`'
	dc.b	'!pA',$c0,'A',$d0,$00,$00
	dc.b	$00,$10,'A',$00,'A',$10,'!',$a0
	dc.b	'!',$b0,$00,$e0,$00,$f0,'!',$00
	dc.b	'!',$10,'!`!p!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,$01,'0'
	dc.b	$01,'0',$01,' ',$01,' ',$01,' '
	dc.b	$01,' A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'!',$80
	dc.b	'!',$90,'!',$a0,'!',$b0,'A',$c0
	dc.b	'A',$d0,' ',$c0,' ',$d0,$00,$00
	dc.b	$00,$10,$00,$c0,$00,$d0,$00,$00
	dc.b	$00,$10,'A',$a0,'A',$b0,$01,$00
	dc.b	' ',$e0,' ',$f0,$00,$80,$00,$90
	dc.b	'A',$c0,'A',$d0,$00,$a0,$00,$b0
	dc.b	'!',$00,'!',$10,'!`!p'
	dc.b	'A',$c0,'A',$d0,'!',$a0,'!',$b0
	dc.b	$00,$e0,$00,$f0,$00,$80,$00,$90
	dc.b	'A',$c0,'A',$d0,'A A0'
	dc.b	$00,$80,$00,$90,'!`!p'
	dc.b	'A',$80,'A',$90,'A',$c0,'A',$d0
	dc.b	$01,$00,' ',$e0,' ',$f0,'!',$a0
	dc.b	'!',$b0,$00,$80,$00,$90,'!`'
	dc.b	'!p',$00,$80,$00,$90,'!',$80
	dc.b	'!',$90,'!',$a0,'!',$b0,$01,$00
	dc.b	' ',$e0,' ',$f0,$00,$c0,$00,$d0
	dc.b	'A',$c0,'A',$d0,' ',$a0,' ',$b0
	dc.b	$01,$00,'!',$80,'!',$90,'!',$a0
	dc.b	'!',$b0,$01,$00,' ',$e0,' ',$f0
	dc.b	$00,$c0,$00,$d0,'!',$80,'!',$90
	dc.b	'A',$c0,'A',$d0,$00,$00,$00,$10
	dc.b	' ',$e0,' ',$f0,$00,'`',$00,'p'
	dc.b	'A',$c0,'A',$d0,$00,$00,$00,$10
	dc.b	'!`!p!',$a0,'!',$b0
	dc.b	$01,$00,$00,'@',$00,'P ',$a0
	dc.b	' ',$b0,$00,$80,$00,$90,'!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,$00,$00
	dc.b	$00,$10,$00,' ',$00,'0!',$00
	dc.b	'!',$10,'A',$00,'A',$10,'!',$a0
	dc.b	'!',$b0,'A',$c0,'A',$d0,$00,'`'
	dc.b	$00,'p',$00,$80,$00,$90,' ',$c0
	dc.b	' ',$d0,'!',$00,'!',$10,'!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,$01,'0'
	dc.b	$01,'0',$01,'0',$01,' ',$01,' '
	dc.b	$01,' ',$01,' A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'!',$80,'!',$90
	dc.b	'! !0',$00,$80,$00,$90
	dc.b	$00,'@',$00,'P',$01,$00,$00,$00
	dc.b	$00,$10,' ',$a0,' ',$b0,'A',$c0
	dc.b	'A',$d0,$00,$c0,$00,$d0,'!`'
	dc.b	'!p',$00,$80,$00,$90,$00,$80
	dc.b	$00,$90,'!',$a0,'!',$b0,$01,$00
	dc.b	' ',$e0,' ',$f0,$00,$c0,$00,$d0
	dc.b	'!',$80,'!',$90,'A',$c0,'A',$d0
	dc.b	'!',$a0,'!',$b0,'!',$00,'!',$10
	dc.b	'A',$c0,'A',$d0,'!',$80,'!',$90
	dc.b	'!',$a0,'!',$b0,$00,$80,$00,$90
	dc.b	'! !0',$00,$e0,$00,$f0
	dc.b	$00,$80,$00,$90,' ',$e0,' ',$f0
	dc.b	'A',$c0,'A',$d0,$00,$e0,$00,$f0
	dc.b	$01,$00,' ',$a0,' ',$b0,' ',$a0
	dc.b	' ',$b0,'A',$c0,'A',$d0,$00,$00
	dc.b	$00,$10,' ',$e0,' ',$f0,$00,'`'
	dc.b	$00,'pA',$c0,'A',$d0,'!',$80
	dc.b	'!',$90,$01,$00,$00,$c0,$00,$d0
	dc.b	' ',$c0,' ',$d0,$00,$00,$00,$10
	dc.b	'A',$c0,'A',$d0,'! !0'
	dc.b	'!`!p',$00,$80,$00,$90
	dc.b	'!',$80,'!',$90,'!',$80,'!',$90
	dc.b	'A',$c0,'A',$d0,$00,$a0,$00,$b0
	dc.b	'!',$00,'!',$10,'!`!p'
	dc.b	'A',$c0,'A',$d0,'!',$a0,'!',$b0
	dc.b	$00,$e0,$00,$f0,$00,$80,$00,$90
	dc.b	'A',$c0,'A',$d0,'A A0'
	dc.b	$00,$80,$00,$90,'!`!p'
	dc.b	'A',$80,'A',$90,'A',$c0,'A',$d0
	dc.b	$00,$c0,$00,$d0,'!',$00,'!',$10
	dc.b	'!',$00,'!',$10,$00,'`',$00,'p'
	dc.b	'A',$c0,'A',$d0,$00,' ',$00,'0'
	dc.b	'!',$00,'!',$10,'!',$00,'!',$10
	dc.b	' ',$80,' ',$90,'A',$c0,'A',$d0
	dc.b	$00,'@',$00,'P',$00,$00,$00,$10
	dc.b	' ',$a0,' ',$b0,' ',$a0,' ',$b0
	dc.b	$00,$80,$00,$90,$00,'`',$00,'p'
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'!',$a0,'!',$b0,$00,$e0,$00,$f0
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	$00,$c0,$00,$d0,$00,$00,$00,$10
	dc.b	' ',$c0,' ',$d0,$00,$80,$00,$90
	dc.b	'A',$c0,'A',$d0,' ',$c0,' ',$d0
	dc.b	$00,$00,$00,$10,' ',$80,' ',$90
	dc.b	$00,$80,$00,$90,'!`!p'
	dc.b	'A',$c0,'A',$d0,'!',$80,'!',$90
	dc.b	'A',$c0,'A',$d0,' ',$c0,' ',$d0
	dc.b	$00,$00,$00,$10,' ',$e0,' ',$f0
	dc.b	'A',$00,'A',$10,$00,$00,$00,$10
	dc.b	' ',$a0,' ',$b0,$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'!',$a0
	dc.b	'!',$b0,'!',$00,'!',$10,'A',$c0
	dc.b	'A',$d0,'!',$80,'!',$90,'!',$a0
	dc.b	'!',$b0,'A',$c0,'A',$d0,$00,'@'
	dc.b	$00,'P!',$00,'!',$10,' ',$e0
	dc.b	' ',$f0,' ',$e0,' ',$f0,$00,$80
	dc.b	$00,$90,'A`Ap',$01,$00
	dc.b	'!',$00,'!',$10,' ',$e0,' ',$f0
	dc.b	'A',$c0,'A',$d0,'A',$e0,'A',$f0
	dc.b	'A',$c0,'A',$d0,'A',$80,'A',$90
	dc.b	'!',$00,'!',$10,'A',$00,'A',$10
	dc.b	'A',$c0,'A',$d0,$00,$00,$00,$10
	dc.b	'!`!p',$00,$80,$00,$90
	dc.b	'A',$c0,'A',$d0,'!',$80,'!',$90
	dc.b	'A',$00,'A',$10,'! !0'
	dc.b	$00,$80,$00,$90,'!`!p'
	dc.b	'A',$c0,'A',$d0,$00,'@',$00,'P'
	dc.b	'!',$00,'!',$10,$00,'`',$00,'p'
	dc.b	$00,$80,$00,$90,'!`!p'
	dc.b	'!',$80,'!',$90,'A',$c0,'A',$d0
	dc.b	$01,'0A',$c0,'A',$d0,'B',$00
	dc.b	'B',$10,$01,' ',$01,' ',$01,' '
	dc.b	$01,' A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'!',$00,'!',$10,$00,$a0
	dc.b	$00,$b0,'A',$c0,'A',$d0,$00,'@'
	dc.b	$00,'P!',$00,'!',$10,'A',$00
	dc.b	'A',$10,'!`!p!',$80
	dc.b	'!',$90,$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,'!',$a0,'!',$b0,'!',$00
	dc.b	'!',$10,'A',$c0,'A',$d0,$00,$00
	dc.b	$00,$10,' ',$a0,' ',$b0,' ',$a0
	dc.b	' ',$b0,'A',$c0,'A',$d0,'!',$a0
	dc.b	'!',$b0,$00,$e0,$00,$f0,$00,$80
	dc.b	$00,$90,'A',$c0,'A',$d0,' ',$c0
	dc.b	' ',$d0,$00,$80,$00,$90,' ',$c0
	dc.b	' ',$d0,$00,' ',$00,'0',$00,$80
	dc.b	$00,$90,'!`!p!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,'!',$00
	dc.b	'!',$10,$00,$a0,$00,$b0,'A',$c0
	dc.b	'A',$d0,'!',$a0,'!',$b0,$00,$e0
	dc.b	$00,$f0,$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,$00,' ',$00,'0',$01,' '
	dc.b	' ',$c0,' ',$d0,$01,' ',$00,$c0
	dc.b	$00,$d0,$01,' A',$c0,'A',$d0
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'!',$80,'!',$90
	dc.b	'!',$a0,'!',$b0,$00,$80,$00,$90
	dc.b	'! !0',$00,$e0,$00,$f0
	dc.b	'A',$80,'A',$90,$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$00,$00,$00,$10
	dc.b	'!',$a0,'!',$b0,$00,$00,$00,$10
	dc.b	' ',$80,' ',$90,$01,$00,$00,'`'
	dc.b	$00,'p',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' !',$80,'!',$90,'!',$a0
	dc.b	'!',$b0,'!`!p',$01,$00
	dc.b	' ',$80,' ',$90,$00,$80,$00,$90
	dc.b	'!`!p',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ! !0'
	dc.b	$00,$00,$00,$10,$00,'@',$00,'P'
	dc.b	$00,$80,$00,$90,'!`!p'
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	'!',$80,'!',$90,'!',$a0,'!',$b0
	dc.b	'!`!p',$01,$00,'A`'
	dc.b	'Ap',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,$00,$00,$00,$10,' ',$e0
	dc.b	' ',$f0,$00,'`',$00,'pA',$c0
	dc.b	'A',$d0,'!',$a0,'!',$b0,'!',$00
	dc.b	'!',$10,'A',$c0,'A',$d0,'A',$80
	dc.b	'A',$90,'!',$00,'!',$10,'A',$00
	dc.b	'A',$10,'A',$c0,'A',$d0,$00,' '
	dc.b	$00,'0',$00,$80,$00,$90,$00,'@'
	dc.b	$00,'P',$00,$00,$00,$10,'A',$00
	dc.b	'A',$10,'!',$80,'!',$90,$00,$80
	dc.b	$00,$90,'A',$c0,'A',$d0,'A',$80
	dc.b	'A',$90,'!',$00,'!',$10,'A',$00
	dc.b	'A',$10,'A',$c0,'A',$d0,$00,$e0
	dc.b	$00,$f0,$00,$00,$00,$10,'A '
	dc.b	'A0',$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,' ',$c0,' ',$d0,$00,$00
	dc.b	$00,$10,$00,'`',$00,'p',$00,$80
	dc.b	$00,$90,'A',$c0,'A',$d0,$00,$00
	dc.b	$00,$10,'A',$c0,'A',$d0,$00,'@'
	dc.b	$00,'P!',$00,'!',$10,'! '
	dc.b	'!0A',$80,'A',$90,'A',$c0
	dc.b	'A',$d0,'!',$00,'!',$10,$00,$a0
	dc.b	$00,$b0,'A',$c0,'A',$d0,'!',$a0
	dc.b	'!',$b0,$00,$e0,$00,$f0,$01,$00
	dc.b	'!',$80,'!',$90,'A',$c0,'A',$d0
	dc.b	$00,'`',$00,'p',$00,$80,$00,$90
	dc.b	' ',$c0,' ',$d0,'!',$00,'!',$10
	dc.b	'A',$c0,'A',$d0,$01,'0',$01,'0'
	dc.b	$01,'0',$01,'0',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'!',$a0,'!',$b0,$00,$e0
	dc.b	$00,$f0,$00,$80,$00,$90,'!`'
	dc.b	'!p',$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,$01,$00,'!',$80,'!',$90
	dc.b	'A',$c0,'A',$d0,'!',$a0,'!',$b0
	dc.b	'A@AP!',$00,'!',$10
	dc.b	'A',$c0,'A',$d0,$00,$e0,$00,$f0
	dc.b	'A',$00,'A',$10,' ',$e0,' ',$f0
	dc.b	$00,'`',$00,'p!`!p'
	dc.b	$00,$80,$00,$90,$00,'`',$00,'p'
	dc.b	'A',$c0,'A',$d0,$00,$00,$00,$10
	dc.b	' ',$e0,' ',$f0,$00,'`',$00,'p'
	dc.b	'A',$c0,'A',$d0,'!',$80,'!',$90
	dc.b	$00,$80,$00,$90,'A A0'
	dc.b	$00,$80,$00,$90,' ',$e0,' ',$f0
	dc.b	'!',$a0,'!',$b0,'A',$80,'A',$90
	dc.b	'A',$c0,'A',$d0,$00,$a0,$00,$b0
	dc.b	'!',$00,'!',$10,'A',$00,'A',$10
	dc.b	'!`!pA',$c0,'A',$d0
	dc.b	' ',$a0,' ',$b0,$01,$00,' ',$e0
	dc.b	' ',$f0,$00,$80,$00,$90,'!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,'!',$00
	dc.b	'!',$10,' ',$e0,' ',$f0,'A',$c0
	dc.b	'A',$d0,'!',$a0,'!',$b0,$00,$e0
	dc.b	$00,$f0,$01,$00,'!',$80,'!',$90
	dc.b	'A',$c0,'A',$d0,'!',$80,'!',$90
	dc.b	$00,'@',$00,'P!`!p'
	dc.b	$00,$80,$00,$90,$00,$80,$00,$90
	dc.b	' ',$e0,' ',$f0,'A',$c0,'A',$d0
	dc.b	$01,'0A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$80,'A',$90,$00,$00
	dc.b	$00,$10,'!',$00,'!',$10,'A',$00
	dc.b	'A',$10,$00,$e0,$00,$f0,'A',$c0
	dc.b	'A',$d0,$01,'0',$01,'0',$01,'0'
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	$00,'@',$00,'P!`!p'
	dc.b	$00,$80,$00,$90,$00,'`',$00,'p'
	dc.b	$01,$00,'!',$a0,'!',$b0,'!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,$00,$a0
	dc.b	$00,$b0,'!',$00,'!',$10,'!`'
	dc.b	'!pA',$c0,'A',$d0,'!',$a0
	dc.b	'!',$b0,$00,$e0,$00,$f0,$01,$00
	dc.b	'!',$80,'!',$90,'A',$c0,'A',$d0
	dc.b	'!',$80,'!',$90,$00,'@',$00,'P'
	dc.b	'!`!p',$00,$80,$00,$90
	dc.b	$00,$80,$00,$90,' ',$e0,' ',$f0
	dc.b	'A',$c0,'A',$d0,$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,'  ',$c0
	dc.b	' ',$d0,'A',$00,'A',$10,'!',$80
	dc.b	'!',$90,$00,$00,$00,$10,' ',$80
	dc.b	' ',$90,'A',$c0,'A',$d0,$00,' '
	dc.b	$00,'0A',$80,'A',$90,'A',$c0
	dc.b	'A',$d0,'!',$a0,'!',$b0,$00,$e0
	dc.b	$00,$f0,$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,$00,$c0,$00,$d0,'!`'
	dc.b	'!p',$00,$80,$00,$90,$00,$00
	dc.b	$00,$10,'!',$a0,'!',$b0,'A',$c0
	dc.b	'A',$d0,' ',$c0,' ',$d0,$00,$00
	dc.b	$00,$10,$00,'`',$00,'pA',$c0
	dc.b	'A',$d0,' ',$c0,' ',$d0,$00,$00
	dc.b	$00,$10,'A`ApA',$c0
	dc.b	'A',$d0,$01,'0',$01,'0',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	'A',$c0,'A',$d0,$00,$c0,$00,$d0
	dc.b	$00,$a0,$00,$b0,'A`Ap'
	dc.b	$01,' ',$01,' ',$01,' ',$00,'@'
	dc.b	$00,'P!',$00,'!',$10,$00,'`'
	dc.b	$00,'p',$00,$80,$00,$90,$01,' '
	dc.b	$01,' ',$01,' ',$00,$00,$00,$10
	dc.b	' ',$e0,' ',$f0,$00,'`',$00,'p'
	dc.b	'A',$c0,'A',$d0,'!',$a0,'!',$b0
	dc.b	$00,$80,$00,$90,'A`Ap'
	dc.b	'!',$a0,'!',$b0,'A',$c0,'A',$d0
	dc.b	'A',$e0,'A',$f0,$01,'0B',$00
	dc.b	'B',$10,'A',$c0,'A',$d0,$00,' '
	dc.b	$00,'0A',$80,'A',$90,'A',$c0
	dc.b	'A',$d0,'!',$80,'!',$90,'!',$a0
	dc.b	'!',$b0,'!`!p',$01,$00
	dc.b	'A`Ap',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' !',$00,'!',$10,$01,' '
	dc.b	' ',$80,' ',$90,$01,' A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,$01,$00
	dc.b	'!',$a0,'!',$b0,'A',$c0,'A',$d0
	dc.b	$01,$00,'!',$80,'!',$90,'A',$c0
	dc.b	'A',$d0,' ',$e0,' ',$f0,'!',$00
	dc.b	'!',$10,'A@APA',$c0
	dc.b	'A',$d0,'!',$a0,'!',$b0,$00,$e0
	dc.b	$00,$f0,$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,$00,$80,$00,$90,' ',$e0
	dc.b	' ',$f0,$00,'`',$00,'pA',$c0
	dc.b	'A',$d0,'!',$00,'!',$10,$00,$a0
	dc.b	$00,$b0,'A',$c0,'A',$d0,'!',$a0
	dc.b	'!',$b0,$00,$e0,$00,$f0,$01,$00
	dc.b	'!',$80,'!',$90,'A',$c0,'A',$d0
	dc.b	'!',$80,'!',$90,$00,'@',$00,'P'
	dc.b	'!`!p!',$00,'!',$10
	dc.b	' ',$a0,' ',$b0,' ',$a0,' ',$b0
	dc.b	'!',$a0,'!',$b0,$00,$80,$00,$90
	dc.b	'A`Ap!',$a0,'!',$b0
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	$01,' ',$01,' ',$01,' !',$a0
	dc.b	'!',$b0,$01,$00,' ',$c0,' ',$d0
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	'!',$a0,'!',$b0,'!',$00,'!',$10
	dc.b	'A',$c0,'A',$d0,'A@AP'
	dc.b	'!`!p',$00,$00,$00,$10
	dc.b	'! !0',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$00,' ',$00,'0'
	dc.b	'A',$80,'A',$90,$00,$80,$00,$90
	dc.b	'A',$c0,'A',$d0,$00,' ',$00,'0'
	dc.b	'A',$80,'A',$90,$00,$80,$00,$90
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	$01,'0',$01,'0',$01,'0A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'a',$a0
	dc.b	'a',$b0,'a',$a0,'a',$b0,'a',$a0
	dc.b	'a',$b0,'a',$a0,'a',$b0,'a',$a0
	dc.b	'a',$b0,'a',$a0,'a',$b0,'a',$a0
	dc.b	'a',$b0,'a',$a0,'a',$b0,'a',$a0
	dc.b	'a',$b0,'a',$a0,'a',$b0,'a',$a0
	dc.b	'a',$b0,'a',$a0,'a',$b0,'a',$a0
l003d	dc.b	$00,$00
l003e	dc.b	$00,$00,$00,$05,$00,$16,$00,$27
	dc.b	$00,'G',$00,'W',$00,'w',$06,'B'
	dc.b	$06,'R',$06,'b',$07,'s',$03,'3'
	dc.b	$04,'D',$05,'U',$06,'f',$07,'w'
l003f	dcb.w	4
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dc.b	$00,$04,$00,$04,$00,$04,$00,$04
	dcb.w	44
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dcb.w	92
	dc.b	$00,'@',$00,'@',$00,'@',$00,'@'
	dcb.w	8
	dc.b	$00,$02,$00,$02,$00,$02,$00,$02
	dc.b	$00,'@',$00,'@',$00,'@',$00,'@'
	dcb.w	8
	dc.b	$04,$00,$04,$00,$04,$00,$04,$00
	dcb.w	56
	dc.b	$00,$02,$00,$02,$00,$02,$00,$02
	dcb.w	8
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dcb.w	13
	dc.b	$01,$fe,$01,$fe,$01,$fe,$04,$00
	dc.b	'{',$9f,$7f,$9f,$7f,$9f,$00,$00
	dc.b	$e0,$00,$e0,$00,$e0,$00,$00,$02
	dcb.w	35
	dc.b	$10,$00,$10,$00,$10,$00,$10,$00
	dcb.w	29
	dc.b	$00,$02,$03,$02,$03,$02,$04,$00
	dc.b	$08,$80,$cc,$b0,$cc,$b0,$00,$00
	dc.b	' ',$00,' ',$00,' ',$00,$00,$00
	dc.b	$00,$02,$00,$00,$00,$00,$00,$00
	dcb.w	19
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dcb.w	41
	dc.b	$00,$02,$02,$06,$02,$06,$08,$00
	dc.b	$11,$80,$99,$a0,$99,$a0,'@',$00
	dc.b	' ',$00,'`',$00,'`',$00,$00,$02
	dc.b	$00,$02,$00,$00,$00,$00,$00,$00
	dcb.w	11
	dc.b	'@',$00,'@',$00,'@',$00,'@',$00
	dcb.w	50
	dc.b	$03,$9d,$03,$9d,$08,$00,$11,$00
	dc.b	$99,'g™g',$00,$00,$00,$00
	dc.b	$c0,$00,$c0,$00,$00,$00,$00,$00
	dc.b	$00,$02,$00,$00,$00,$00,$00,$00
	dcb.w	50
	dc.b	$00,'@',$00,'@',$00,'@',$00,'@'
	dcb.w	8
	dc.b	$00,'0',$00,$00,$01,'1',$01,'1'
	dc.b	$10,$0f,'#',$00,'3O3O'
	dcb.w	4
	dc.b	$00,$02,$00,$00,$00,$02,$00,$00
	dcb.w	48
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dcb.w	12
	dc.b	$00,' ',$00,$00,$03,'#',$03,'#'
	dc.b	$00,$00,$02,$01,$02,$c1,$02,$c1
	dcb.w	5
	dc.b	$00,$02,$00,$02,$00,$00,$00,$00
	dcb.w	19
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dcb.w	4
	dc.b	$00,$10,$00,$10,$00,$10,$00,$10
	dcb.w	29
	dc.b	$00,'`',$02,'b',$02,'b',$00,$03
	dc.b	$06,$00,$06,$83,$06,$83,$00,$00
	dcb.w	3
	dc.b	$00,$aa,$00,'g',$00,$1f,$00,$02
	dc.b	$a8,$00,'0',$00,$c0,$00,$00,$00
	dcb.w	48
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dcb.w	9
	dc.b	$00,'@',$06,'F',$06,'F@',$00
	dc.b	$04,$00,'eže',$9e,$00,$00
	dcb.w	4
	dc.b	$00,$02,$00,$02,$00,$00,$00,$00
	dcb.w	27
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dcb.w	33
	dc.b	$00,$c0,$04,$c4,$04,$c4,$80,'0'
	dc.b	$0c,$00,$cd,'0',$cd,'0',$00,$00
	dcb.w	3
	dc.b	$00,$02,$00,$00,$00,$02,$00,$00
	dc.b	$00,$08,$00,$08,$00,$08,$00,$08
	dcb.w	52
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dcb.w	5
	dc.b	$00,$80,$0c,$8c,$0c,$8c,$80,$00
	dc.b	$08,' ',$cb,' ',$cb,' ',$00,$00
	dcb.w	5
	dc.b	$00,$02,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$02,$00,$02,$00,$02,$00,$02
	dcb.w	56
	dc.b	$00,$01,$01,$80,$09,$89,$09,$89
	dc.b	$00,$00,$18,'|š|š|'
	dcb.w	4
	dc.b	$00,$02,$00,$02,$00,$00,$00,$00
	dcb.w	36
	dc.b	'@',$00,$00,$00,$00,$00,$00,$00
	dcb.w	24
	dc.b	$00,$01,$01,$00,$19,$19,$19,$19
	dc.b	$00,$00,$10,$04,$96,$04,$96,$04
	dcb.w	5
	dc.b	$00,$02,$00,$00,$00,$00,$00,$00
	dcb.w	31
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dc.b	$00,$00,'@',$00,$00,$00,$00,$00
	dcb.w	24
	dc.b	$00,$02,$03,$00,$13,$13,$13,$13
	dc.b	$00,$0c,'0',$00,'4',$0c,'4',$0c
	dcb.w	4
	dc.b	$00,$02,$00,$00,$00,$00,$00,$00
	dcb.w	8
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dcb.w	24
	dc.b	'@',$00,'@',$00,$00,$00,$00,$00
	dcb.w	24
	dc.b	$00,$02,$00,$00,$1e,$1f,$1e,$1f
	dcb.w	2
	dc.b	$e7,$f8,$e7,$f8,$00,$00,$00,$00
	dcb.w	44
	dc.b	'@',$00,$00,$00,$00,$00,$00,$00
	dcb.w	74
	dc.b	'@',$00,$00,$00,'@',$00,$00,$00
	dcb.w	76
	dc.b	$00,$10,'@',$10,'@',$10,$00,$10
	dcb.w	52
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dcb.w	16
	dc.b	' ',$15,' ',$0c,' ',$03,' ',$00
	dc.b	'j',$80,$f3,$00,$fc,$00,'`',$00
	dcb.w	20
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dcb.w	32
	dc.b	'@',$00,'@',$00,'@',$00,'@',$00
	dcb.w	17
	dc.b	'@',$00,'@',$00,$00,$00,$00,$00
	dcb.w	75
	dc.b	'@',$00,$00,$00,'@',$00,$00,$00
	dcb.w	78
	dc.b	'@',$00,$00,$00,$00,$00,$00,$00
	dcb.w	54
	dc.b	$00,$04,$00,$04,$00,$04,$00,$04
	dcb.w	16
	dc.b	'@',$00,'@',$00,$00,$00,$00,$00
	dcb.w	60
	dc.b	$00,$08,$00,$08,$00,$00,$00,$08
	dcb.w	13
	dc.b	'@',$00,$00,$00,$00,$00,$00,$00
	dcb.w	61
	dc.b	$00,$08,$00,$08,$00,$00,$00,$00
	dcb.w	10
	dc.b	'@',$00,$00,$00,$00,$00,$00,$00
	dcb.w	60
	dc.b	$00,$08,$00,$00,$00,$08,$00,$08
	dcb.w	77
	dc.b	$00,$08,$00,$08,$00,$08,$00,$00
	dcb.w	75
	dc.b	$00,$08,$00,$08,$00,$08,$00,$08
	dcb.w	76
	dc.b	$01,']',$01,'>',$00,$ff,$01,$ff
	dc.b	'@',$00,'@',$00,$80,$00,$c0,$00
	dc.b	$00,$08,$00,$08,$00,$08,$00,$08
	dcb.w	12
	dc.b	$0f,$ff,$0f,$ff,$0f,$ff,$0f,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$f8,$ff,$f8,$ff,$f8,$ff,$f8
	dc.b	$00,'?',$00,'?',$00,'?',$00,'?'
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$83,$ff,$8f,$ff,$8f,$ff,$8f,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$f8,$ff,$f8,$ff,$f8,$ff,$f8
	dcb.w	20
	dc.b	$1f,$ff,$1f,$ff,$1f,$ff,$1f,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$fc,$ff,$fc,$ff,$fc,$ff,$fc
	dc.b	$00,$7f,$00,$7f,$00,$7f,$00,$7f
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$03,$ff,$1f,$ff,$1f,$ff,$1f,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$c0,$ff,$c8,$ff,$c8,$ff,$c8
	dcb.w	20
	dc.b	$1f,$ff,$00,$00,$18,$00,$18,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$06,$00,$06,$00,$06
	dc.b	$00,$ff,$00,$c0,$00,$c0,$00,$c0
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$06,$00,$06,$00,$06
	dc.b	$0f,$ff,'0',$00,'0',$00,'0',$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$08,$1f,$00,$1f,$08,$1f,$08
	dcb.w	20
	dc.b	'?',$ff,$00,$00,'0',$00,'0',$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$03,$00,$03,$00,$03
	dc.b	$01,$7f,$01,$80,$01,$80,$01,$80
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fc,$00,$0c,$00,$0c,$00,$0c
	dc.b	$1f,$ff,'`',$00,'`',$00,'`',$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$f8,$00,$f8,$00,$f8,$08,$f8,$08
	dcb.w	12
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dcb.w	4
	dc.b	'?',$ff,$00,$00,'0',$00,'0',$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$01,$00,$01,$00,$01
	dc.b	$82,$ff,$83,$00,$83,$00,$83,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$f8,$00,$18,$00,$18,$00,$18
	dc.b	'?',$ff,$c0,$00,$c0,$00,$c0,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$07,$00,$07,$00,$07
	dc.b	$c0,$08,$c0,$08,$c0,$00,$c0,$08
	dcb.w	8
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dcb.w	8
	dc.b	'?',$ff,$00,$00,'0',$00,'0',$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$c5,$ff,$c6,$00,$c6,$00,$c6,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$f0,$00,'1',$00,'1',$00,'1'
	dc.b	$7f,$ff,$80,$00,$80,$00,$80,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,'>',$00,'>',$00,'>'
	dcb.w	24
	dc.b	$7f,$ff,$00,$00,'`',$00,'`',$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$01,$00,$01,$00,$01
	dc.b	$8b,$ff,$8c,$00,$8c,$00,$8c,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$e0,$00,'c',$00,'c',$00,'c'
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$f0,$01,$f0,$01,$f0,$01,$f0
	dcb.w	24
	dc.b	$7f,$ff,$00,$00,'`',$00,'`',$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$03,$00,$03,$00,$03
	dc.b	$17,$ff,$18,$00,$18,$00,$18,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$c1,$00,$c6,$00,$c6,$00,$c6
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$80,$0f,$80,$0f,$80,$0f,$80
	dcb.w	16
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dcb.w	4
	dc.b	$7f,$ff,$00,$00,'`',$00,'`',$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$06,$00,$06,$00,$06
	dc.b	$0f,$ff,'0',$00,'0',$00,'0',$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$83,$01,$8c,$01,$8c,$01,$8c
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$fc,$00,'|',$00,'|',$00,'|',$00
	dcb.w	24
	dc.b	$ff,$ff,$00,$00,$c0,$00,$c0,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fc,$00,$0c,$00,$0c,$00,$0c
	dc.b	$1f,$ff,'`',$00,'`',$00,'`',$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$07,$03,$18,$03,$18,$03,$18
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$03,$00,$03,$00,$03
	dc.b	$e0,$00,$e0,$00,$e0,$00,$e0,$00
	dcb.w	24
	dc.b	$ff,$ff,$00,$00,$c0,$00,$c0,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$f8,$00,$18,$00,$18,$00,$18
	dc.b	'?',$ff,$c0,$00,$c0,$00,$c0,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$fe,$0f,$06,'0',$06,'0',$06,'0'
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$1f,$00,$1f,$00,$1f
	dcb.w	28
	dc.b	$c0,$00,'?',$ff,$c0,$00,$c0,$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,'0',$ff,$f1,$00,'1',$00,'1'
	dc.b	$00,$00,$ff,$ff,$80,$00,$80,$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$0c,$00,$fc,$7f,$0c,'`',$0c,'`'
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$f8,$ff,$f8,$00,$f8,$00,$f8
	dcb.w	24
	dc.b	$00,$01,$00,$00,$00,$01,$00,$01
	dc.b	$ff,$ff,$00,$00,$80,$00,$80,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$e0,$00,'c',$00,'c',$00,'c'
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$f8,'?',$18,$c0,$18,$c0,$18,$c0
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$c0,$07,$c0,$07,$c0,$07,$c0
	dcb.w	12
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dcb.w	8
	dc.b	$00,$01,$00,$00,$00,$01,$00,$01
	dc.b	$80,$00,$7f,$ff,$80,$00,$80,$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$c0,$ff,$c7,$00,$c6,$00,$c6
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$07,$ff,$f8,$00,$07,$00,$07
	dc.b	$f0,$00,$0f,$ff,$f0,$00,$f0,$00
	dc.b	'0',$00,$f1,$ff,'1',$80,'1',$80
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	'0',$00,$ff,$ff,'?',$ff,'?',$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$f0,$ff,$f0
	dc.b	'>',$00,$fe,$00,'>',$00,'>',$00
	dcb.w	24
	dc.b	$00,$01,$00,$00,$00,$01,$00,$01
	dc.b	$80,$00,$7f,$ff,$80,$00,$80,$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$01,$80,$ff,$8f,$01,$8c,$01,$8c
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$0f,$ff,$f0,$00,$0f,$00,$0f
	dc.b	$e0,$00,$1f,$ff,$e0,$00,$e0,$00
	dc.b	'`',$00,$e3,$ff,'c',$00,'c',$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	'p',$00,$ff,$ff,$7f,$ff,$7f,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$01,$ff,$ff,$ff,$e1,$ff,$e1
	dc.b	$f0,$00,$f0,$00,$f0,$00,$f0,$00
	dcb.w	24
	dc.b	$00,$03,$00,$00,$00,$03,$00,$03
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$03,$00,$ff,$1f,$03,$18,$03,$18
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$00,$ff,$f8,$00,$18,$00,$18
	dc.b	$c0,$00,'?',$ff,$c0,$00,$c0,$00
	dc.b	$c0,$00,$c7,$ff,$c6,$00,$c6,$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$c0,$00,$c0,$00,$c0,$00,$c0,$00
	dcb.w	4
	dc.b	$00,$cf,$00,'?',$00,$cf,$00,$cf
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	24
	dc.b	$00,$03,$00,$00,$00,$03,$00,$03
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$fe,$0f,$fe,'?',$06,'0',$06,'0'
	dc.b	$ff,$ff,$ff,$ff,$00,$e0,$00,$e0
	dc.b	$ff,$c1,$ff,$f0,$00,'1',$00,'1'
	dc.b	$ff,$ff,$7f,$ff,$80,$01,$80,$01
	dc.b	$83,$ff,$8f,$ff,$8c,$00,$8c,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$01,$00,$01
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dc.b	$00,$10,$00,$10,$00,$10,$00,$10
	dc.b	$01,$fc,$00,'|',$01,$fc,$01,$fc
	dcb.w	28
	dc.b	$00,$03,$00,$00,$00,$03,$00,$03
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$01,$00,$ff,$ff,$01,$ff,$01,$ff
	dc.b	$01,$00,$ff,$ff,$ff,$00,$ff,$00
	dc.b	$0c,$00,$fc,$7f,$0c,'`',$0c,'`'
	dc.b	$01,$f0,$ff,$ff,$01,$f0,$01,$f0
	dc.b	$00,$03,$ff,$e0,$00,'c',$00,'c'
	dc.b	$00,$03,$ff,$ff,$00,$03,$00,$03
	dc.b	$00,$00,$1f,$ff,$18,$00,$18,$00
	dc.b	$00,$03,$ff,$ff,$00,$03,$00,$03
	dcb.w	8
	dc.b	$07,$e0,$00,$e0,$07,$e0,$07,$e0
	dcb.w	28
	dc.b	$00,$07,$00,$01,$00,$06,$00,$06
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$00,$ff,$ff,$01,$ff,$01,$ff
	dc.b	$01,$ff,$ff,$ff,$fe,$00,$fe,$00
	dc.b	$f8,'?',$f8,$ff,$18,$c0,$18,$c0
	dc.b	$ff,$9f,$ff,$9f,$01,$98,$01,$98
	dc.b	$ff,$07,$ff,$c1,$00,$c6,$00,$c6
	dc.b	$ff,$fe,$ff,$fe,$00,$06,$00,$06
	dc.b	$0f,$ff,'?',$ff,'0',$00,'0',$00
	dc.b	$ff,$fe,$ff,$fe,$00,$06,$00,$06
	dcb.w	32
	dc.b	$00,$08,$00,$08,$00,$08,$00,$08
	dcb.w	4
	dc.b	$00,$07,$00,$01,$00,$06,$00,$06
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$80,$ff,$80,$01,$80,$01,$80
	dc.b	$0f,$ff,$03,$ff,$0c,$00,$0c,$00
	dc.b	$f0,$7f,$f1,$ff,'1',$80,'1',$80
	dc.b	$ff,$cf,$ff,$cf,$00,$cc,$00,$cc
	dc.b	$fe,$0f,$ff,$83,$01,$8c,$01,$8c
	dc.b	$ff,$fc,$ff,$fc,$00,$0c,$00,$0c
	dc.b	$1f,$ff,$7f,$ff,'`',$00,'`',$00
	dc.b	$ff,$fc,$ff,$fc,$00,$0c,$00,$0c
	dcb.w	24
	dc.b	$00,$10,$00,$10,$00,$00,$00,$10
	dcb.w	12
	dc.b	$00,$07,$00,$01,$00,$06,$00,$06
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$80,$ff,$80,$01,$80,$01,$80
	dc.b	$1f,$ff,$07,$ff,$18,$00,$18,$00
	dc.b	$e0,$ff,$e3,$ff,'c',$00,'c',$00
	dc.b	$ff,$c7,$ff,$c7,$00,$c6,$00,$c6
	dc.b	$fc,$1f,$ff,$07,$03,$18,$03,$18
	dc.b	$ff,$f8,$ff,$f8,$00,$18,$00,$18
	dc.b	'?',$ff,$ff,$ff,$c0,$00,$c0,$00
	dc.b	$ff,$f8,$ff,$f8,$00,$18,$00,$18
	dcb.w	26
	dc.b	$00,$10,$00,$10,$00,$00,$00,$00
	dcb.w	10
	dc.b	$00,$0f,$00,$03,$00,$0c,$00,$0c
	dc.b	$ff,$ff,$ff,$ff,$00,$04,$00,$04
	dc.b	$ff,$80,$ff,$80,$01,$80,$01,$80
	dc.b	'?',$ff,$0f,$ff,'0',$00,'0',$00
	dc.b	$c1,$ff,$c7,$ff,$c6,$00,$c6,$00
	dc.b	$ff,$e3,$ff,$e3,$00,'c',$00,'c'
	dc.b	$f8,'?',$fe,$0f,$06,'0',$06,'0'
	dc.b	$ff,$f0,$ff,$f1,$00,'1',$00,'1'
	dc.b	$7f,$ff,$ff,$ff,$80,$00,$80,$00
	dc.b	$ff,$f0,$ff,$f0,$00,'0',$00,'0'
	dc.b	$04,$00,$04,$00,$04,$00,$04,$00
	dcb.w	20
	dc.b	$00,$10,$00,$00,$00,$10,$00,$10
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dcb.w	8
	dc.b	$00,$0f,$00,$03,$00,$0c,$00,$0c
	dc.b	$ff,$ff,$ff,$ff,$00,$04,$00,$04
	dc.b	$ff,$80,$ff,$80,$01,$80,$01,$80
	dc.b	$7f,$ff,$1f,$ff,'`',$01,'`',$01
	dc.b	$83,$ff,$87,$ff,$84,$00,$84,$00
	dc.b	$ff,$e1,$ff,$e1,$00,'a',$00,'a'
	dc.b	$f0,$7f,$fc,$1f,$8c,'`',$8c,'`'
	dc.b	$ff,$e0,$ff,$e3,$00,'c',$00,'c'
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$e0,$ff,$e0,$00,'`',$00,'`'
	dcb.w	25
	dc.b	$00,$10,$00,$10,$00,$10,$00,$00
	dcb.w	11
	dc.b	$00,$0c,$00,$00,$00,$0f,$00,$0c
	dc.b	$00,$08,$00,$08,$ff,$ff,$00,$08
	dc.b	$01,$80,$01,$80,$ff,$80,$01,$80
	dc.b	$c0,$01,$00,$01,$ff,$ff,$c0,$01
	dc.b	$80,$00,$8c,$00,$8f,$ff,$8c,$00
	dc.b	$00,'0',$00,'0',$ff,$f0,$00,'0'
	dc.b	$80,$c0,$d8,$00,$f8,$ff,$d8,$c0
	dc.b	$00,$c0,$00,$c6,$ff,$c7,$00,$c6
	dcb.w	2
	dc.b	$ff,$ff,$00,$00,$00,$c0,$00,$c0
	dc.b	$ff,$c0,$00,$c0,$00,$00,$00,$00
	dcb.w	18
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dc.b	$01,'U',$01,'9',$00,$fe,$01,$ff
	dc.b	$80,$00,$80,$00,$00,$00,$80,$00
	dcb.w	8
	dc.b	'@',$1f,'@',$07,'@',$18,'@',$18
	dc.b	$ff,$ff,$ff,$ff,$00,$08,$00,$08
	dc.b	$ff,$81,$ff,$80,$01,$81,$01,$81
	dc.b	$ff,$ff,$7f,$ff,$80,$00,$80,$00
	dc.b	$07,$ff,$c1,$ff,$c6,$00,$c6,$00
	dc.b	$ff,$f0,$ff,$f0,$00,'0',$00,'0'
	dc.b	$01,$ff,'p',$7f,'q',$80,'q',$80
	dc.b	$ff,$83,$ff,$8f,$01,$8c,$01,$8c
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$80,$ff,$80,$01,$80,$01,$80
	dcb.w	25
	dc.b	$00,$10,$00,$10,$00,$10,$00,$00
	dcb.w	11
	dc.b	$00,$18,$00,$00,$00,$1f,$00,$18
	dc.b	$00,$08,$00,$08,$ff,$ff,$00,$08
	dc.b	$01,$83,$01,$80,$ff,$83,$01,$83
	dcb.w	2
	dc.b	$ff,$ff,$00,$00,$06,$00,$c0,$00
	dc.b	$c7,$ff,$c6,$00,$00,$18,$00,$18
	dc.b	$ff,$f8,$00,$18,$03,$00,' ',$00
	dc.b	'#',$ff,'#',$00,$03,$10,$03,$18
	dc.b	$ff,$1f,$03,$18,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$03,$00,$03,$00
	dc.b	$ff,$00,$03,$00,$00,$00,$00,$00
	dcb.w	22
	dc.b	$00,$10,$00,$00,$00,$10,$00,$10
	dcb.w	12
	dc.b	$00,$18,$00,$00,$00,$1f,$00,$18
	dc.b	$00,$10,$00,$10,$ff,$ff,$00,$10
	dc.b	$01,$86,$01,$80,$ff,$87,$01,$86
	dcb.w	2
	dc.b	$ff,$ff,$00,$00,$03,$00,'`',$00
	dc.b	$e3,$ff,'c',$00,$00,$18,$00,$18
	dc.b	$ff,$f8,$00,$18,$03,$00,$00,$00
	dc.b	$03,$ff,$03,$00,$03,$18,$03,$00
	dc.b	$ff,$1f,$03,$18,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$06,$00,$06,$00
	dc.b	$fe,$00,$06,$00,$00,' ',$00,' '
	dc.b	$00,' ',$00,' ',$00,$00,$00,$00
	dcb.w	18
	dc.b	$00,$10,$00,$00,$00,$10,$00,$10
	dcb.w	12
	dc.b	$00,'0',$00,$00,$00,'?',$00,'0'
	dc.b	$00,$10,$00,$10,$ff,$ff,$00,$10
	dc.b	$01,$8c,$01,$80,$ff,$8f,$01,$8c
	dcb.w	2
	dc.b	$ff,$ff,$00,$00,$03,$00,'`',$00
	dc.b	$e3,$ff,'c',$00,$00,$0c,$00,$0c
	dc.b	$ff,$fc,$00,$0c,$03,$00,$00,$00
	dc.b	$03,$ff,$03,$00,$03,$18,$03,$00
	dc.b	$ff,$1f,$03,$18,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$0c,$00,$0c,$00
	dc.b	$fc,$00,$0c,$00,$00,$00,$00,$00
	dcb.w	24
	dc.b	$00,$10,$00,$10,$00,$00,$00,$00
	dcb.w	10
	dc.b	$00,'0',$00,$00,$00,'?',$00,'0'
	dc.b	$00,$10,$00,$10,$ff,$ff,$00,$10
	dc.b	$01,$98,$01,$80,$ff,$9f,$01,$98
	dcb.w	2
	dc.b	$ff,$ff,$00,$00,$01,$80,'0',$00
	dc.b	$f1,$ff,'1',$80,$00,$0c,$00,$0c
	dc.b	$ff,$fc,$00,$0c,$03,$00,$00,$00
	dc.b	$03,$ff,$03,$00,$03,$18,$03,$00
	dc.b	$ff,$1f,$03,$18,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$18,$00,$18,$00
	dc.b	$f8,$00,$18,$00,$00,$00,$00,$00
	dcb.w	14
	dc.b	'@',$00,'@',$00,'@',$00,'@',$00
	dcb.w	4
	dc.b	$00,$10,$00,$10,$00,$00,$00,$10
	dcb.w	12
	dc.b	$00,'?',$00,$00,$00,'?',$00,'0'
	dc.b	$ff,$ff,$00,' ',$ff,$ff,$00,' '
	dc.b	$ff,$bf,$01,$80,$ff,$bf,$01,$b0
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$c1,$ff,'0',$00,$f1,$ff,'1',$80
	dc.b	$ff,$fe,$00,$06,$ff,$fe,$00,$06
	dc.b	$0b,$ff,$08,$00,$0b,$ff,$0b,$00
	dc.b	$ff,$1f,$03,$00,$ff,$1f,$03,$18
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$f0,$00,'0',$00,$f0,$00,'0',$00
	dcb.w	8
	dc.b	$02,$00,$02,$00,$02,$00,$02,$00
	dc.b	$00,$02,$00,$02,$00,$02,$00,$02
	dcb.w	8
	dc.b	$00,$10,$00,$10,$00,$00,$00,$10
	dcb.w	12
	dc.b	$00,'`',$00,$00,$00,$7f,$00,'`'
	dc.b	$00,' ',$00,' ',$ff,$ff,$00,' '
	dc.b	$01,$e0,$01,$80,$ff,$ff,$01,$e0
	dcb.w	2
	dc.b	$ff,$ff,$00,$00,$00,$c0,$18,$00
	dc.b	$f8,$ff,$18,$c0,$00,$06,$00,$06
	dc.b	$ff,$fe,$00,$06,$0b,$00,$18,$00
	dc.b	$1b,$ff,$1b,$00,$03,$18,$03,$00
	dc.b	$ff,$1f,$03,$18,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,'`',$00,'`',$00
	dc.b	$e0,$00,'`',$00,$00,$00,$00,$00
	dcb.w	22
	dc.b	$00,$02,$00,$02,$00,$02,$00,$02
	dcb.w	12
	dc.b	$00,$7f,$00,$00,$00,$7f,$00,'`'
	dc.b	$ff,$ff,$00,' ',$ff,$ff,$00,' '
	dc.b	$ff,$ff,$01,$00,$ff,$ff,$01,$c0
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$e0,$ff,$18,$00,$f8,$ff,$18,$c0
	dc.b	$ff,$ff,$00,$03,$ff,$ff,$00,$03
	dc.b	$0b,$ff,'8',$00,';',$ff,';',$00
	dc.b	$ff,$1f,$03,$00,$ff,$1f,$03,$18
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$c2,$00,$c2,$00,$c0,$00,$c2,$00
	dcb.w	40
	dc.b	$00,$7f,$00,$00,$00,$7f,$00,'`'
	dc.b	$ff,$ff,$00,'@',$ff,$ff,$00,'@'
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$01,$80
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$f0,$7f,$0c,$00,$fc,$7f,$0c,'`'
	dc.b	$ff,$ff,$00,$03,$ff,$ff,$00,$03
	dc.b	$1b,$ff,'x',$00,'{',$ff,'{',$00
	dc.b	$ff,$1f,$03,$00,$ff,$1f,$03,$18
	dc.b	$ff,$ff,$00,$01,$ff,$ff,$00,$01
	dc.b	$80,$00,$80,$00,$82,$00,$82,$00
	dcb.w	8
	dc.b	$10,$00,$10,$00,$10,$00,$10,$00
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dcb.w	24
	dc.b	$00,$ff,$00,$00,$00,$ff,$00,$c0
	dc.b	$ff,$ff,$00,'@',$ff,$ff,$00,'@'
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$01,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$f0,$7f,$0c,$00,$fc,$7f,$0c,'`'
	dc.b	$ff,$ff,$00,$01,$ff,$ff,$00,$01
	dc.b	';',$ff,$d8,$00,$fb,$ff,$db,$00
	dc.b	$ff,$1f,$03,$00,$ff,$1f,$03,$18
	dc.b	$ff,$ff,$00,$03,$ff,$ff,$00,$03
	dc.b	$02,$00,$00,$00,$02,$00,$02,$00
	dcb.w	32
	dc.b	$00,'@',$00,'@',$00,'@',$00,'@'
	dcb.w	4
	dc.b	$00,$c0,$00,'?',$00,$ff,$00,$c0
	dc.b	$00,'@',$ff,$ff,$ff,$ff,$00,'@'
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$00,'0',$fe,$0f,$fe,'?',$06,'0'
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$1b,$00,$f8,$ff,$fb,$ff,$1b,$00
	dc.b	$03,$18,$ff,$07,$ff,$1f,$03,$18
	dc.b	$00,$03,$ff,$ff,$ff,$ff,$00,$03
	dc.b	$05,$00,$02,$00,$07,$00,$07,$00
	dcb.w	20
	dc.b	$00,$10,$00,$10,$00,$10,$00,$10
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	12
	dc.b	$00,$ff,$00,$00,$00,$ff,$00,$c0
	dc.b	$ff,$ff,$00,$80,$ff,$ff,$00,$80
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$f8,'?',$06,$00,$fe,'?',$06,'0'
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$fb,$ff,$18,$00,$fb,$ff,$1b,$00
	dc.b	$ff,$1f,$03,$00,$ff,$1f,$03,$18
	dc.b	$ff,$ff,$00,$03,$ff,$ff,$00,$03
	dc.b	$0a,$80,$02,$00,$0a,$80,$0a,$80
	dcb.w	24
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dcb.w	4
	dc.b	$01,$10,$01,$10,$01,$00,$01,$10
	dc.b	$10,$00,$10,$00,$00,$00,$10,$00
	dc.b	$01,$80,$00,$7f,$01,$ff,$01,$80
	dc.b	$00,$80,$ff,$ff,$ff,$ff,$00,$80
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$00,$18,$ff,$07,$ff,$1f,$03,$18
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$1b,$00,$f8,$ff,$fb,$ff,$1b,$00
	dc.b	$03,$18,$ff,$07,$ff,$1f,$03,$18
	dc.b	$00,$03,$ff,$ff,$ff,$ff,$00,$03
	dc.b	'W_O',$9f,'?',$ef,$7f,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$f8,$ff,$f8,$ff,$f8,$ff,$f8
	dcb.w	22
	dc.b	$00,$08,$00,$08,$00,$00,$00,$00
	dc.b	' ',$00,' ',$00,$01,$80,$00,$7f
	dc.b	$01,$ff,$01,$80,$00,$80,$ff,$ff
	dc.b	$ff,$ff,$00,$80,$00,$00,$ff,$ff
	dc.b	$ff,$ff,$00,$00,$01,$00,$fe,$ff
	dc.b	$ff,$ff,$01,$00,$00,$18,$ff,$07
	dc.b	$ff,$1f,$03,$18,$00,$00,$ff,$ff
	dc.b	$ff,$ff,$00,$00,$1b,$00,$f8,$ff
	dc.b	$fb,$ff,$1b,$00,$03,$18,$ff,$07
	dc.b	$ff,$1f,$03,$18,$00,$03,$ff,$ff
	dc.b	$ff,$ff,$00,$03,$0a,$ff,$02,$7f
	dc.b	$0a,$ff,$0a,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$fc,$ff,$fc
	dc.b	$ff,$fc,$ff,$fc,$00,$00,$00,$00
	dcb.w	18
	dc.b	$00,$04,$00,$00,$00,$04,$00,$04
	dc.b	'@',$00,$00,$00,'@',$00,'@',$00
	dc.b	$01,$80,$00,$7f,$01,$ff,$01,$80
	dc.b	$01,$00,$ff,$ff,$ff,$ff,$01,$00
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$03,$00,$fc,$ff,$ff,$ff,$03,$00
	dc.b	$00,$0c,$ff,$83,$ff,$8f,$01,$8c
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$1b,$00,$f8,$ff,$fb,$ff,$1b,$00
	dc.b	$03,$18,$ff,$07,$ff,$1f,$03,$18
	dc.b	$00,$03,$ff,$ff,$ff,$ff,$00,$03
	dc.b	$05,' ',$02,'?',$07,'?',$07,'>'
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$00,$06,$ff,$fe,$ff,$fe,$00,$06
	dcb.w	21
	dc.b	$00,$02,$00,$02,$00,$02,$00,$00
	dc.b	$80,$00,$80,$00,$80,$00,$03,$ff
	dc.b	$00,$7f,$03,$ff,$03,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$fc,$ff,$ff,$ff,$ff,$ff,$fe,$0f
	dc.b	$ff,$81,$ff,$8f,$ff,$8f,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$fb,$ff
	dc.b	$f8,$ff,$fb,$ff,$fb,$ff,$ff,$1f
	dc.b	$ff,$03,$ff,$1f,$ff,$1f,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$02,$00
	dc.b	$00,$0f,$02,$0f,$02,$0f,$7f,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$01
	dc.b	$00,$01,$00,$01,$00,$01,$00,$00
	dcb.w	15
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dcb.w	4
	dc.b	$03,$00,$00,$ff,$03,$ff,$03,$00
	dc.b	$01,$00,$ff,$ff,$ff,$ff,$01,$00
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$0f,$00,$fc,$ff,$ff,$ff,$0f,$00
	dc.b	$00,$06,$ff,$c1,$ff,$c7,$00,$c6
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$1b,$00,$f8,$ff,$fb,$ff,$1b,$00
	dc.b	$03,$18,$ff,$07,$ff,$1f,$03,$18
	dc.b	$00,$03,$ff,$ff,$ff,$ff,$00,$03
	dc.b	$00,$00,$00,$03,$02,$03,$02,$03
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$e0,$00
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$00,$01,$ff,$ff,$ff,$ff,$00,$01
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	17
	dc.b	$00,$02,$00,$02,$00,$02,$00,$00
	dc.b	$80,$00,$80,$00,$80,$00,$03,$ff
	dc.b	$00,$7f,$03,$ff,$03,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$fb,$ff
	dc.b	$f8,$ff,$fb,$ff,$fb,$ff,$ff,$07
	dc.b	$ff,$c0,$ff,$c7,$ff,$c7,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$fb,$ff
	dc.b	$f8,$ff,$fb,$ff,$fb,$ff,$ff,$1f
	dc.b	$ff,$03,$ff,$1f,$ff,$1f,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$02,$00
	dc.b	$02,$00,$00,$00,$02,$00,$07,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$c0,$00
	dc.b	$c0,$00,$c0,$00,$c0,$00,$80,$00
	dc.b	$80,$00,$80,$00,$80,$00,$00,$00
	dcb.w	11
	dc.b	$00,$04,$00,$00,$00,$04,$00,$04
	dc.b	$00,$00,'@',$00,'@',$00,'@',$00
	dc.b	$06,$7f,$00,$7f,$06,$7f,$06,$7f
	dc.b	$fa,$ff,$fa,$ff,$fa,$ff,$fa,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	'3',$7f,'0',$7f,'3',$7f,'3',$7f
	dc.b	$fe,$03,$fe,'`',$fe,'c',$fe,'c'
	dc.b	$7f,$ff,$7f,$ff,$7f,$ff,$7f,$ff
	dc.b	$db,$7f,$d8,$7f,$db,$7f,$db,$7f
	dc.b	$fb,$1b,$fb,$03,$fb,$1b,$fb,$1b
	dc.b	$ff,$fb,$ff,$fb,$ff,$fb,$ff,$fb
	dcb.w	4
	dc.b	$00,$ff,'<',$ff,'<',$ff,'<',$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	'`',$00,'`',$00,'`',$00,'`',$00
	dcb.w	18
	dc.b	$00,$08,$00,$08,' ',$00,$00,$00
	dc.b	' ',$00,' ',$00,$06,$1f,$00,$1f
	dc.b	$06,$1f,$06,$1f,$e2,'?',$e2,'?'
	dc.b	$e2,'?',$e2,'?',$ff,$fc,$ff,$fc
	dc.b	$ff,$fc,$ff,$fc,'c',$1f,'`',$1f
	dc.b	'c',$1f,'c',$1f,$f8,$03,$f8,'`'
	dc.b	$f8,'c',$f8,'c',$1f,$ff,$1f,$ff
	dc.b	$1f,$ff,$1f,$ff,$1b,$1f,$18,$1f
	dc.b	$1b,$1f,$1b,$1f,$e3,$18,$e3,$00
	dc.b	$e3,$18,$e3,$18,$ff,$e3,$ff,$e3
	dc.b	$ff,$e3,$ff,$e3,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$1f,$0f,$1f,$0f,$1f,$0f,$1f
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$fc,$ff,$fc,$ff,$fc,$ff,$fc
	dc.b	'0',$00,'0',$00,'0',$00,'0',$00
	dcb.w	16
	dc.b	$00,$10,$00,$10,$00,$00,$00,$10
	dcb.w	2
	dc.b	$10,$00,$10,$00,$06,$00,$00,$00
	dc.b	$06,$00,$06,$00,$04,$00,$04,$00
	dc.b	$04,$00,$04,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$c3,$00,$c0,$00,$c3,$00,$c3,$00
	dc.b	$00,$01,$00,'0',$00,'1',$00,'1'
	dc.b	$80,$00,$00,$00,$80,$00,$80,$00
	dc.b	$1b,$00,$18,$00,$1b,$00,$1b,$00
	dc.b	$03,$18,$03,$00,$03,$18,$03,$18
	dc.b	$00,$03,$00,$03,$00,$03,$00,$03
	dcb.w	5
	dc.b	$03,$c0,$03,$c0,$03,$c0,$00,$00
	dcb.w	7
	dc.b	$18,$00,$18,$00,$18,$00,$18,$00
	dcb.w	4
	dc.b	$04,$04,$04,$04,$04,$04,$04,$04
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dcb.w	8
	dc.b	$08,$00,$08,$00,$00,$00,$08,$00
	dc.b	$0c,$00,$00,$00,$0c,$00,$0c,$00
	dc.b	$04,$00,$04,$00,$04,$00,$04,$00
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dc.b	$83,$00,$80,$00,$83,$00,$83,$00
	dc.b	$00,$01,$00,'0',$00,'1',$00,'1'
	dc.b	$80,$00,$00,$00,$80,$00,$80,$00
	dc.b	$1b,$00,$18,$00,$1b,$00,$1b,$00
	dc.b	$03,$18,$03,$00,$03,$18,$03,$18
	dc.b	$00,$03,$00,$03,$00,$03,$00,$03
	dcb.w	4
	dc.b	$00,$03,$00,$f0,$00,$f3,$00,$f3
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$ff,$fe
	dcb.w	4
	dc.b	$0c,$00,$00,$00,$0c,$00,$0c,$00
	dcb.w	8
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dcb.w	8
	dc.b	$04,$00,$04,$00,$00,$00,$04,$00
	dc.b	$0c,$00,$00,$00,$0c,$00,$0c,$00
	dc.b	$04,$00,$04,$00,$04,$00,$04,$00
	dc.b	$00,$03,$00,$03,$00,$03,$00,$03
	dc.b	$03,$00,$00,$00,$03,$00,$03,$00
	dc.b	$00,$00,$00,$18,$00,$18,$00,$18
	dc.b	$c0,$00,$00,$00,$c0,$00,$c0,$00
	dc.b	$1b,$00,$18,$00,$1b,$00,$1b,$00
	dc.b	$03,$18,$03,$00,$03,$18,$03,$18
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dc.b	$00,$00,$00,'?',$00,'?',$00,'?'
	dc.b	$ff,$f0,$00,$00,$ff,$fc,$ff,$fc
	dcb.w	4
	dc.b	$18,$00,$00,$00,$18,$00,$18,$00
	dcb.w	4
	dc.b	$04,$00,$04,$00,$04,$00,$04,$00
	dcb.w	16
	dc.b	$0c,$00,$00,$00,$0c,$00,$0c,$00
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dc.b	$00,$06,$00,$06,$00,$06,$00,$06
	dc.b	$03,$00,$00,$00,$03,$00,$03,$00
	dc.b	$00,$00,$00,$18,$00,$18,$00,$18
	dc.b	$c0,$00,$00,$00,$c0,$00,$c0,$00
	dc.b	$1b,$00,$18,$00,$1b,$00,$1b,$00
	dc.b	$03,$18,$03,$00,$03,$18,$03,$18
	dcb.w	4
	dc.b	$c0,$00,$c0,$00,$c0,$00,$c0,$00
	dc.b	$00,$00,$00,$0e,$00,$0e,$00,$0e
	dcb.w	2
	dc.b	$00,$18,$00,$18,$00,$00,$00,$00
	dcb.w	2
	dc.b	'0',$00,$00,$00,'0',$00,'0',$00
	dcb.w	24
	dc.b	$18,$00,$00,$00,$18,$00,$18,$00
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dc.b	$00,$0c,$00,$0c,$00,$0c,$00,$0c
	dc.b	$03,$00,$00,$00,$03,$00,$03,$00
	dc.b	$00,$00,$00,$0c,$00,$0c,$00,$0c
	dc.b	'`',$00,$00,$00,'`',$00,'`',$00
	dc.b	$1b,$00,$18,$00,$1b,$00,$1b,$00
	dc.b	$03,$18,$03,$00,$03,$18,$03,$18
	dcb.w	4
	dc.b	'`',$00,'`',$00,'`',$00,'`',$00
	dcb.w	6
	dc.b	$00,'0',$00,'0',$00,$00,$00,$00
	dcb.w	2
	dc.b	'`',$00,$00,$00,'`',$00,'`',$00
	dcb.w	24
	dc.b	$18,$00,$00,$00,$18,$00,$18,$00
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dc.b	$00,$18,$00,$18,$00,$18,$00,$18
	dc.b	$03,$00,$00,$00,$03,$00,$03,$00
	dc.b	$00,$00,$00,$0c,$00,$0c,$00,$0c
	dc.b	'`',$00,$00,$00,'`',$00,'`',$00
	dc.b	$1b,$00,$18,$00,$1b,$00,$1b,$00
	dc.b	$03,$18,$03,$00,$03,$18,$03,$18
	dcb.w	4
	dc.b	'0',$00,'0',$00,'0',$00,'0',$00
	dcb.w	6
	dc.b	$00,'`',$00,'`',$00,$00,$00,$00
	dcb.w	2
	dc.b	$c0,$00,$00,$00,$c0,$00,$c0,$00
	dcb.w	24
	dc.b	$18,$00,$00,$00,$18,$00,$18,$00
	dc.b	$10,$00,$10,$00,$10,$00,$10,$00
	dc.b	$00,'0',$00,'0',$00,'0',$00,'0'
	dc.b	$03,$00,$00,$00,$03,$00,$03,$00
	dc.b	$00,$00,$00,$06,$00,$06,$00,$06
	dc.b	'0',$00,$00,$00,'0',$00,'0',$00
	dc.b	$1b,$00,$18,$00,$1b,$00,$1b,$00
	dc.b	$03,$18,$03,$00,$03,$18,$03,$18
	dcb.w	4
	dc.b	$18,$00,$18,$00,$18,$00,$18,$00
	dcb.w	6
	dc.b	$00,$c0,$00,$c0,$00,$01,$00,$00
	dc.b	$00,$01,$00,$01,$80,$00,$00,$00
	dc.b	$80,$00,$80,$00,$00,$00,$00,$00
	dcb.w	14
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dcb.w	4
	dc.b	'?',$ff,$0f,$ff,'?',$ff,'0',$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$10,$00
	dc.b	$ff,$e0,$ff,$e0,$ff,$e0,$00,'`'
	dc.b	$03,$ff,$00,$ff,$03,$ff,$03,$00
	dc.b	$ff,$f8,$ff,$fe,$ff,$fe,$00,$06
	dc.b	'?',$ff,$0f,$ff,'?',$ff,'0',$00
	dc.b	$fb,$ff,$f8,$ff,$fb,$ff,$1b,$00
	dc.b	$ff,$1f,$ff,$07,$ff,$1f,$03,$18
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$fc,$00,$fc,$00,$fc,$00,$0c,$00
	dcb.w	4
	dc.b	$00,$7f,$00,$7f,$01,$ff,$01,$80
	dc.b	$ff,$ff,$ff,$fc,$ff,$ff,$00,$03
	dcb.w	28
	dc.b	'0',$00,$00,$00,'0',$00,'0',$00
	dc.b	$10,$00,$10,$00,$10,$00,$10,$00
	dc.b	$00,$00,$00,$ff,$00,$ff,$00,$ff
	dc.b	$03,$00,$fc,$00,$ff,$00,$ff,$00
	dc.b	$00,$00,$00,$03,$00,$03,$00,$03
	dc.b	$18,$00,$00,$00,$18,$00,$18,$00
	dc.b	$1b,$00,$18,$00,$1b,$00,$1b,$00
	dc.b	$03,$18,$03,$00,$03,$18,$03,$18
	dcb.w	4
	dc.b	$07,$ff,$07,$ff,$07,$ff,$07,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$00,$ff,$00,$ff,$00,$ff,$00
	dc.b	$00,$06,$00,$00,$00,$06,$00,$06
	dcb.w	24
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dc.b	'?',$ff,$0f,$ff,'?',$ff,'0',$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,' ',$00
	dc.b	$fe,$00,$ff,$ff,$ff,$ff,$01,$ff
	dc.b	$01,$ff,$fe,$ff,$ff,$ff,$ff,$00
	dc.b	$ff,$fc,$ff,$ff,$ff,$ff,$00,$03
	dc.b	$1f,$ff,$07,$ff,$1f,$ff,$18,$00
	dc.b	$fb,$ff,$f8,$ff,$fb,$ff,$1b,$00
	dc.b	$ff,$1f,$ff,$07,$ff,$1f,$03,$18
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$03,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$fe,$00
	dc.b	$ff,$fc,$ff,$f0,$ff,$fc,$00,$0c
	dcb.w	28
	dc.b	$7f,$ff,$1f,$ff,$7f,$ff,'`',$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,' ',$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$fc,$ff,$fb,$ff,$ff,$00,$07
	dc.b	$0f,$ff,$03,$ff,$0f,$ff,$0c,$00
	dc.b	$fb,$ff,$f8,$ff,$fb,$ff,$1b,$00
	dc.b	$ff,$1f,$ff,$07,$ff,$1f,$03,$18
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$f8,$ff,$e0,$ff,$f8,$00,$18
	dcb.w	28
	dc.b	$7f,$ff,$1f,$ff,$7f,$ff,'`',$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,' ',$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$fc,$ff,$f0,$ff,$fc,$00,$0c
	dc.b	$0f,$ff,$03,$ff,$0f,$ff,$0c,$00
	dc.b	$fb,$ff,$f8,$ff,$fb,$ff,$1b,$00
	dc.b	$ff,$1f,$ff,$07,$ff,$1f,$03,$18
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$f0,$ff,$c0,$ff,$f0,$00,'0'
	dcb.w	28
	dc.b	$7f,$ff,$1f,$ff,$7f,$ff,'`',$00
	dc.b	$ff,$ff,$ef,$ff,$ff,$ff,'p',$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$f8,$ff,$e0,$ff,$f8,$00,$18
	dc.b	$07,$ff,$01,$ff,$07,$ff,$06,$00
	dc.b	$fb,$ff,$f8,$ff,$fb,$ff,$1b,$00
	dc.b	$ff,$1f,$ff,$07,$ff,$1f,$03,$18
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$e0,$ff,$80,$ff,$e0,$00,'`'
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$f8,$ff,$f8,$ff,$f8,$ff,$f8
	dc.b	$00,$c0,$00,$c0,$00,$c0,$00,$c0
	dcb.w	12
	dc.b	$ff,$ff,'?',$ff,$ff,$ff,$c0,$00
	dc.b	$ff,$ff,$e7,$ff,$ff,$ff,'x',$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$f0,$ff,$c0,$ff,$f0,$00,'0'
	dc.b	$07,$ff,$01,$ff,$07,$ff,$06,$00
	dc.b	$fb,$ff,$f8,$ff,$fb,$ff,$1b,$00
	dc.b	$ff,$1f,$ff,$07,$ff,$1f,$03,$18
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$c0,$ff,$00,$ff,$c0,$00,$c0
	dc.b	$00,$03,$00,$02,$00,$02,$00,$02
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fc,$00,$04,$00,$04,$00,$04
	dc.b	$01,$e0,$01,' ',$01,' ',$01,' '
	dcb.w	12
	dc.b	$ff,$ff,'?',$ff,$ff,$ff,$c0,$00
	dc.b	$ef,$ff,$e3,$ff,$ef,$ff,'l',$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$e0,$ff,$80,$ff,$e0,$00,'`'
	dc.b	$03,$ff,$00,$ff,$03,$ff,$03,$00
	dc.b	$fb,$ff,$f8,$ff,$fb,$ff,$1b,$00
	dc.b	$ff,$1f,$ff,$07,$ff,$1f,$03,$18
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$80,$fe,$00,$ff,$80,$01,$80
	dc.b	$00,$04,$00,$07,$00,$04,$00,$04
	dc.b	$fc,$e3,$ff,$ff,$fc,$e3,$fc,$e3
	dc.b	$9f,$c2,$ff,$fe,$9f,$c2,$9f,$c2
	dc.b	$02,'@',$03,$c0,$02,'@',$02,'@'
	dcb.w	12
	dc.b	$ff,$ff,'?',$ff,$ff,$ff,$c0,$00
	dc.b	$c7,$ff,$c1,$ff,$c7,$ff,$c6,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$c0,$ff,$00,$ff,$c0,$00,$c0
	dc.b	$03,$ff,$00,$ff,$03,$ff,$03,$00
	dc.b	$fb,$ff,$f8,$ff,$fb,$ff,$1b,$00
	dc.b	$ff,$1f,$ff,$07,$ff,$1f,$03,$18
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$00,$fc,$00,$ff,$00,$03,$00
	dc.b	$00,$0f,$00,$0f,$00,$09,$00,$09
	dc.b	$07,$9e,$07,$9e,$04,$92,$04,$92
	dc.b	'x',$7f,'x',$7f,'HIHI'
	dc.b	$07,$80,$07,$80,$04,$80,$04,$80
	dcb.w	8
	dc.b	$00,$81,$00,$80,$00,$81,$00,$81
	dc.b	$80,$00,$00,$00,$80,$00,$ff,$ff
	dc.b	$c3,$00,$c0,$00,$c3,$00,$c3,$ff
	dcb.w	3
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$01,$80,$00,$00,$01,$80
	dc.b	$ff,$80,$01,$80,$00,$00,$01,$80
	dc.b	$01,$ff,$1b,$00,$18,$00,$1b,$00
	dc.b	$fb,$ff,$03,$18,$03,$00,$03,$18
	dc.b	$ff,$1f,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$06,$00,$00,$00,$06,$00
	dc.b	$fe,$00,$00,$04,$00,$04,$00,$07
	dc.b	$00,$04,$84,$92,$84,$92,$87,$9e
	dc.b	$84,$92,'$L$L<',$7f
	dc.b	'$L',$89,$00,$89,$00,$8f,$00
	dc.b	$89,$00,$00,$00,$00,$00,$00,$00
	dcb.w	5
	dc.b	$00,$01,$00,$00,$00,$01,$00,$01
	dc.b	$ff,$ff,$7f,$ff,$ff,$ff,$80,$00
	dc.b	$c1,$ff,$c0,$7f,$c1,$ff,$c1,$80
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$00,$fc,$00,$ff,$00,$03,$00
	dc.b	$01,$ff,$00,$7f,$01,$ff,$01,$80
	dc.b	$fb,$ff,$f8,$ff,$fb,$ff,$1b,$00
	dc.b	$ff,$1f,$ff,$07,$ff,$1f,$03,$18
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$fc,$00,$f0,$00,$fc,$00,$0c,$00
	dc.b	$00,$03,$00,$02,$00,$03,$00,$02
	dc.b	$c7,$9e,'D',$92,$c7,$9e,'D',$92
	dc.b	'x{HJx{HJ'
	dc.b	$de,$00,'R',$00,$de,$00,'R',$00
	dcb.w	8
	dc.b	$00,$01,$00,$00,$00,$01,$00,$01
	dc.b	$80,$01,$00,$01,$80,$01,$ff,$ff
	dc.b	$80,$c0,$80,$00,$80,$c0,$80,$ff
	dcb.w	3
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$06,$00,$00,$00,$06,$00
	dc.b	$fe,$00,$00,$c0,$00,$00,$00,$c0
	dc.b	$00,$ff,$1b,$00,$18,$00,$1b,$00
	dc.b	$fb,$ff,$01,$80,$01,$80,$01,$8c
	dc.b	$ff,$8f,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$18,$00,$00,$00,$18,$00
	dc.b	$f8,$00,$00,$01,$00,$01,$00,$01
	dc.b	$00,$01,'$',$92,$e7,$9e,$e7,$9e
	dc.b	'$',$92,$90,'I',$f0,'y',$f0,'y'
	dc.b	$90,'I$',$00,$fc,$00,$fc,$00
	dc.b	'$',$00,$00,$00,$00,$00,$00,$00
	dcb.w	5
	dc.b	$00,$03,$00,$00,$00,$03,$00,$03
	dc.b	$00,$01,$00,$01,$00,$01,$ff,$ff
	dc.b	$80,'`',$80,$00,$80,'`',$80,$7f
	dcb.w	3
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$0c,$00,$00,$00,$0c,$00
	dc.b	$fc,$00,$00,$c0,$00,$00,$00,$c0
	dc.b	$00,$ff,$1b,$00,$18,$00,$1b,$00
	dc.b	$fb,$ff,$00,$c0,$00,$c0,$00,$c6
	dc.b	$ff,$c7,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,'0',$00,$00,$00,'0',$00
	dc.b	$f0,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$94,$93,$f7,$9f,$f7,$9f
	dc.b	$94,$93,' H',$e0,'x',$e0,'x'
	dc.b	' H',$88,$00,$f8,$00,$f8,$00
	dc.b	$88,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$01,$00,$01,$00,$01
	dc.b	$00,$01,$00,$03,$00,$00,$00,$03
	dc.b	$00,$03,$00,$01,$00,$01,$00,$01
	dc.b	$ff,$ff,$80,'0',$80,$00,$80,'0'
	dc.b	$80,'?',$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$18,$00,$00,$00,$18,$00
	dc.b	$f8,$00,$00,'`',$00,$00,$00,'`'
	dc.b	$00,$7f,$1b,$00,$18,$00,$1b,$00
	dc.b	$fb,$ff,$00,'`',$00,'`',$00,'c'
	dc.b	$ff,$e3,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,'`',$00,$00,$00,'`',$00
	dc.b	$e0,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,'L',$92,$7f,'žL',$92
	dc.b	$7f,$9e,$90,'H',$f0,'x',$90,'H'
	dc.b	$f0,'x',$88,$00,$f8,$00,$88,$00
	dc.b	$f8,$00,$00,$00,$00,$00,$00,$00
	dcb.w	5
	dc.b	$00,$03,$00,$00,$00,$03,$00,$03
	dc.b	$00,$03,$00,$03,$00,$03,$ff,$ff
	dc.b	$00,$18,$00,$00,$00,$18,$00,$1f
	dcb.w	3
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,'0',$00,$00,$00,'0',$00
	dc.b	$f0,$00,$00,'`',$00,$00,$00,'`'
	dc.b	$00,$7f,$1b,$00,$18,$00,$1b,$00
	dc.b	$fb,$ff,$00,'0',$00,'0',$00,'1'
	dc.b	$ff,$f1,$00,$00,$00,$00,$80,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$c0,$00,$00,$00,$c0,$00
	dc.b	$c0,$00,$01,$00,$01,$00,$01,$00
	dc.b	$01,$00,'?ž$',$92,'$',$92
	dc.b	'?žxyHIHI'
	dc.b	'xy',$fc,$00,'$',$00,'$',$00
	dc.b	$fc,$00,$00,$00,$00,$00,$00,$00
	dcb.w	5
	dc.b	$00,$06,$00,$00,$00,$06,$00,$07
	dc.b	$00,$03,$00,$03,$00,$03,$ff,$ff
	dc.b	$00,$0c,$00,$00,$00,$0c,$00,$0f
	dcb.w	3
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,'`',$00,$00,$00,'`',$00
	dc.b	$e0,$00,$00,'0',$00,$00,$00,'0'
	dc.b	$00,'?',$1b,$00,$18,$00,$1b,$00
	dc.b	$fb,$ff,$00,$18,$00,$18,$00,$18
	dc.b	$ff,$f8,$00,$00,$00,$00,$c0,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$01,$00,$00,$00,$01
	dc.b	$ff,$ff,$80,$00,$00,$00,$80,$00
	dc.b	$80,$00,$02,$80,$02,$80,$02,$80
	dc.b	$03,$80,'L',$92,'L',$92,'L',$92
	dc.b	$7f,'ž$J$J$J'
	dc.b	'<{R',$00,'R',$00,'R',$00
	dc.b	$de,$00,$00,$00,$00,$00,$00,$00
	dcb.w	5
	dc.b	$00,$06,$00,$00,$00,$06,$00,$07
	dc.b	$00,$03,$00,$03,$00,$03,$ff,$ff
	dc.b	$00,$06,$00,$00,$00,$06,$00,$07
	dcb.w	3
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$c0,$00,$00,$00,$c0,$00
	dc.b	$c0,$00,$00,'0',$00,$00,$00,'0'
	dc.b	$00,'?',$1b,$00,$18,$00,$1b,$00
	dc.b	$fb,$ff,$00,$0c,$00,$0c,$00,$0c
	dc.b	$ff,$fc,$00,$00,$00,$00,'`',$00
	dc.b	$7f,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$03,$00,$00,$00,$03
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$01,$ff,$01,$ff,$01,$ff
	dc.b	$01,$7f,$f7,$9e,$f7,$9e,$f7,$9e
	dc.b	$94,$92,$1e,$7f,$1e,$7f,$1e,$7f
	dc.b	$12,'L',$8f,$00,$8f,$00,$8f,$00
	dc.b	$89,$00,$80,$00,$80,$00,$00,$00
	dc.b	$80,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$06,$00,$00,$00,$06
	dc.b	$00,$07,$00,$06,$00,$06,$00,$06
	dc.b	$ff,$fe,$00,$03,$00,$00,$00,$03
	dc.b	$00,$03,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$01,$00,$00,$00,$01
	dc.b	$ff,$ff,$80,$00,$00,$00,$80,$00
	dc.b	$80,$00,$00,$18,$00,$00,$00,$18
	dc.b	$00,$1f,$1b,$00,$18,$00,$1b,$00
	dc.b	$fb,$ff,$00,$06,$00,$06,$00,$06
	dc.b	$ff,$fe,$00,$00,$00,$00,'0',$00
	dc.b	'?',$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$06,$00,$00,$00,$06
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$ff,$00,$ff,$00,$ff
	dc.b	$00,$80,$ef,$de,$ef,$de,$ef,$de
	dc.b	'(R',$0f,$ff,$0f,$ff,$0f,$ff
	dc.b	$09,$89,$07,$80,$07,$80,$07,$80
	dc.b	$04,$80,$80,$00,$80,$00,$00,$00
	dc.b	$80,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,'@',$0f,'@',$00,'@',$0c
	dc.b	'@',$0f,$ff,$fe,$00,$06,$00,$06
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$01
	dc.b	$00,$01,$00,$00,$00,$00,$ff,$ff
	dc.b	$ff,$ff,$00,$00,$00,$00,$ff,$ff
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$1f,$00,$00,$00,$18
	dc.b	$00,$1f,$fb,$00,$18,$00,$1b,$ff
	dc.b	$fb,$ff,$00,$03,$00,$03,$ff,$ff
	dc.b	$ff,$ff,$00,$00,$00,$00,$1f,$ff
	dc.b	$1f,$ff,$00,$00,$00,$00,$ff,$ff
	dc.b	$ff,$ff,$00,$00,$00,$00,$ff,$ff
	dc.b	$ff,$ff,$00,$0c,$00,$00,$ff,$fc
	dc.b	$ff,$fc,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$01,$ff,$01,$ff,$01,$ff
	dc.b	$01,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$e1,$07,$ff,$07,$ff,$07,$ff
	dc.b	$04,$ff,$ff,$c0,$ff,$c0,$ff,$c0
	dc.b	$fe,'@',$00,$00,$00,$00,$80,$00
	dc.b	$80,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$0c,$00,$00,$00,$0c
	dc.b	$00,$0f,$00,$06,$00,$06,$00,$06
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dcb.w	3
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$0c,$00,$00,$00,$0c,$00,$0f
	dc.b	$1a,$00,$18,$00,$1b,$ff,$fb,$ff
	dcb.w	2
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$8f,$ff,$8f,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$18,$00,$00
	dc.b	$ff,$f8,$ff,$f8,$00,$00,$00,$00
	dcb.w	2
	dc.b	$03,$ff,$03,$ff,$03,$ff,$02,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$83,$ff,$83,$ff,$83,$ff,$82,$00
	dc.b	$ff,$e0,$ff,$e0,$ff,$e0,$00,' '
	dc.b	$80,$00,$00,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$00,$0f,$00,$00,$00,$0c,$00,$0f
	dc.b	$ff,$fc,$00,$0c,$00,$0c,$ff,$fc
	dcb.w	16
	dc.b	$00,$0f,$00,$00,$00,$0c,$00,$0f
	dc.b	$f8,$00,$18,$00,$18,$00,$f8,$00
	dcb.w	24
	dc.b	$01,$ff,$01,$ff,$01,$ff,$01,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$01,$ff,$01,$ff,$01,$ff,$01,$ff
	dc.b	$ff,$c0,$ff,$c0,$ff,$c0,$ff,$c0
	dc.b	$00,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$00,$1f,$00,$00,$00,$18,$00,$1f
	dc.b	$ff,$fc,$00,$0c,$00,$0c,$ff,$fc
	dcb.w	16
	dc.b	$00,$07,$00,$00,$00,$06,$00,$07
	dc.b	$f8,$00,$18,$00,$18,$00,$f8,$00
	dcb.w	40
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$00,$1f,$00,$00,$00,$18,$00,$1f
	dc.b	$ff,$fc,$00,$0c,$00,$0c,$ff,$fc
	dcb.w	16
	dc.b	$00,$07,$00,$00,$00,$06,$00,$07
	dc.b	$f8,$00,$18,$00,$18,$00,$f8,$00
	dcb.w	24
	dc.b	$03,$ff,$03,$ff,$00,$00,$03,$ff
	dc.b	$ff,$f4,$ff,$f4,$00,$0b,$ff,$ff
	dc.b	$00,$17,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$ff,$d0,$00,'/',$ff,$ff,$ff,$ff
	dc.b	$ac,$00,$cc,$00,$f0,$00,$fc,$00
	dcb.w	4
	dc.b	$00,$1f,$00,$00,$00,$18,$00,$1f
	dc.b	$ff,$f8,$00,$18,$00,$18,$ff,$f8
	dcb.w	16
	dc.b	$00,$03,$00,$00,$00,$03,$00,$03
	dc.b	$f8,$00,$18,$00,$18,$00,$f8,$00
	dcb.w	40
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$00,'?',$00,$00,$00,'0',$00,'?'
	dc.b	$ff,$f8,$00,$18,$00,$18,$ff,$f8
	dcb.w	16
	dc.b	$00,$03,$00,$00,$00,$03,$00,$03
	dc.b	$f8,$00,$18,$00,$18,$00,$f8,$00
	dcb.w	24
	dc.b	$01,$ff,$01,$ff,$01,$ff,$01,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$01,$ff,$01,$ff,$01,$ff,$01,$ff
	dc.b	$ff,$c0,$ff,$c0,$ff,$c0,$ff,$c0
	dc.b	$00,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$00,'?',$00,$00,$00,'0',$00,'?'
	dc.b	$ff,$ff,$00,$1f,$00,$1f,$ff,$ff
	dc.b	$fe,$00,$fe,$00,$fe,$00,$fe,$00
	dcb.w	12
	dc.b	$00,$01,$00,$00,$00,$01,$00,$01
	dc.b	$fc,$00,$1c,$00,$98,$00,$fc,$00
	dcb.w	24
	dc.b	$03,$ff,$03,$ff,$03,$ff,$02,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$83,$ff,$83,$ff,$83,$ff,$82,$00
	dc.b	$ff,$e0,$ff,$e0,$ff,$e0,$00,' '
	dc.b	$80,$00,$00,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$00,'?',$00,$00,$00,'0',$00,'?'
	dc.b	$ff,$ff,$00,$0f,$00,$0f,$ff,$ff
	dc.b	$ff,$80,$ff,$80,$ff,$80,$ff,$80
	dcb.w	8
	dc.b	$00,'@',$00,'@',$00,'@',$00,'@'
	dc.b	$00,$01,$00,$00,$00,$01,$00,$01
	dc.b	$fc,$00,$1c,$00,$98,$00,$fc,$00
	dcb.w	24
	dc.b	$01,$ff,$01,$ff,$01,$ff,$01,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$e1
	dc.b	$07,$ff,$07,$ff,$07,$ff,$04,$ff
	dc.b	$ff,$c0,$ff,$c0,$ff,$c0,$fe,'@'
	dcb.w	2
	dc.b	$80,$00,$80,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,'`',$00,$1f,$00,'`',$00,$7f
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$1e,$00,$fe,$00,$1e,$00,$fe,$00
	dcb.w	16
	dc.b	$d8,$00,'8',$00,$dc,$00,$fc,$00
	dcb.w	24
	dc.b	$00,$ff,$00,$ff,$00,$ff,$00,$80
	dc.b	$ef,$de,$ef,$de,$ef,$de,'(R'
	dc.b	$0f,$ff,$0f,$ff,$0f,$ff,$09,$89
	dc.b	$07,$80,$07,$80,$07,$80,$04,$80
	dc.b	$80,$00,$80,$00,$00,$00,$80,$00
	dcb.w	4
	dc.b	$00,$7f,$00,$00,$00,'`',$00,$7f
	dc.b	$ff,$ff,$00,$00,$00,$00,$ff,$ff
	dc.b	$f8,$00,'x',$00,'x',$00,$f8,$00
	dcb.w	16
	dc.b	$f8,$00,$18,$00,$dc,$00,$fc,$00
	dcb.w	12
	dc.b	$04,$00,$04,$00,$04,$00,$04,$00
	dcb.w	8
	dc.b	$01,$ff,$01,$ff,$01,$ff,$01,$7f
	dc.b	$f7,$9e,$f7,$9e,$f7,$9e,$94,$92
	dc.b	$1e,$7f,$1e,$7f,$1e,$7f,$12,'L'
	dc.b	$8f,$00,$8f,$00,$8f,$00,$89,$00
	dc.b	$80,$00,$80,$00,$00,$00,$80,$00
	dcb.w	4
	dc.b	$00,'`',$00,$1f,$00,'`',$00,$7f
	dc.b	$00,$01,$ff,$ff,$00,$01,$ff,$ff
	dc.b	$e0,$00,$e0,$00,$e0,$00,$e0,$00
	dcb.w	16
	dc.b	'|',$00,$18,$00,'|',$00,'|',$00
	dcb.w	24
	dc.b	$02,$80,$02,$80,$02,$80,$03,$80
	dc.b	'L',$92,'L',$92,'L',$92,$7f,'ž'
	dc.b	'$J$J$J<{'
	dc.b	'R',$00,'R',$00,'R',$00,$de,$00
	dcb.w	8
	dc.b	$00,$c0,$00,'?',$00,$c0,$00,$ff
	dc.b	$00,$07,$ff,$ff,$00,$07,$ff,$ff
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	16
	dc.b	'|',$00,$18,$00,'|',$00,'|',$00
	dcb.w	24
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dc.b	'?ž$',$92,'$',$92,'?ž'
	dc.b	'xyHIHIxy'
	dc.b	$fc,$00,'$',$00,'$',$00,$fc,$00
	dcb.w	8
	dc.b	$00,$c0,$00,'?',$00,$c0,$00,$ff
	dc.b	$00,$1e,$ff,$fe,$00,$1e,$ff,$fe
	dcb.w	20
	dc.b	'8',$00,$0c,$00,'<',$00,'<',$00
	dcb.w	12
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dcb.w	12
	dc.b	'L',$92,$7f,'žL',$92,$7f,$9e
	dc.b	$90,'H',$f0,'x',$90,'H',$f0,'x'
	dc.b	$88,$00,$f8,$00,$88,$00,$f8,$00
	dcb.w	8
	dc.b	$00,$c0,$00,'?',$00,$c0,$00,$ff
	dc.b	$00,'x',$ff,$f8,$00,'x',$ff,$f8
	dcb.w	12
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dcb.w	4
	dc.b	'8',$00,$0c,$00,'<',$00,'<',$00
	dcb.w	28
	dc.b	$94,$93,$f7,$9f,$f7,$9f,$94,$93
	dc.b	' H',$e0,'x',$e0,'x H'
	dc.b	$88,$00,$f8,$00,$f8,$00,$88,$00
	dcb.w	8
	dc.b	$01,$80,$00,$7f,$01,$80,$01,$ff
	dc.b	$01,$e0,$ff,$e0,$01,$e0,$ff,$e0
	dcb.w	20
	dc.b	$1c,$00,$00,$00,$1c,$00,$1c,$00
	dcb.w	12
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dcb.w	8
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dc.b	'$',$92,$e7,$9e,$e7,$9e,'$',$92
	dc.b	$90,'I',$f0,'y',$f0,'y',$90,'I'
	dc.b	'$',$00,$fc,$00,$fc,$00,'$',$00
	dcb.w	8
	dc.b	$01,$80,$00,$7f,$01,$80,$01,$ff
	dc.b	$07,$80,$ff,$80,$07,$80,$ff,$80
	dcb.w	20
	dc.b	$1e,$00,$04,$00,$1e,$00,$1e,$00
	dcb.w	24
	dc.b	$00,$03,$00,$02,$00,$03,$00,$02
	dc.b	$c7,$9e,'D',$92,$c7,$9e,'D',$92
	dc.b	'x{HJx{HJ'
	dc.b	$de,$00,'R',$00,$de,$00,'R',$00
	dcb.w	8
	dc.b	$01,$ff,$00,$7f,$01,$ff,$01,$ff
	dc.b	$fe,$00,$fe,$00,$fe,$00,$fe,$00
	dcb.w	20
	dc.b	$1d,$00,$04,$00,$1d,$00,$1d,$00
	dcb.w	24
	dc.b	$00,$04,$00,$04,$00,$07,$00,$04
	dc.b	$84,$92,$84,$92,$87,$9e,$84,$92
	dc.b	'$L$L<',$7f,'$L'
	dc.b	$89,$00,$89,$00,$8f,$00,$89,$00
	dcb.w	8
	dc.b	$03,$00,$00,$ff,$03,$00,$03,$ff
	dc.b	'x',$00,$f8,$00,'x',$00,$f8,$00
	dcb.w	16
	dc.b	$00,'3',$00,'0',$00,$0f,$00,'?'
	dc.b	'.',$99,$ff,$e1,$ff,$fe,$ff,$ff
	dc.b	$80,$00,$80,$00,$00,$00,$80,$00
	dcb.w	20
	dc.b	$00,$0f,$00,$0f,$00,$09,$00,$09
	dc.b	$07,$9e,$07,$9e,$04,$92,$04,$92
	dc.b	'x',$7f,'x',$7f,'HIHI'
	dc.b	$07,$80,$07,$80,$04,$80,$04,$80
	dcb.w	8
	dc.b	$03,$ff,$00,$ff,$03,$ff,$03,$ff
	dc.b	$e0,$00,$e0,$00,$e0,$00,$e0,$00
	dcb.w	8
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dcb.w	8
	dc.b	$15,$00,$04,$00,$15,$00,$15,$00
	dcb.w	4
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dcb.w	16
	dc.b	$00,$04,$00,$07,$00,$04,$00,$04
	dc.b	$fc,$e3,$ff,$ff,$fc,$e3,$fc,$e3
	dc.b	$9f,$c2,$ff,$fe,$9f,$c2,$9f,$c2
	dc.b	$02,'@',$03,$c0,$02,'@',$02,'@'
	dcb.w	8
	dc.b	$03,$ff,$00,$ff,$03,$ff,$03,$ff
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	8
	dc.b	$00,$04,$00,$04,$00,$04,$00,$04
	dcb.w	8
	dc.b	$0a,$00,$04,$00,$0e,$00,$0e,$00
	dcb.w	20
	dc.b	'@',$00,'@',$00,'@',$00,'@',$00
	dc.b	$00,$03,$00,$02,$00,$02,$00,$02
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fc,$00,$04,$00,$04,$00,$04
	dc.b	$01,$e0,$01,' ',$01,' ',$01,' '
	dcb.w	8
	dc.b	$0f,$fe,$09,$fe,$07,$fe,$0f,$fe
	dcb.w	24
	dc.b	$04,$00,$04,$00,$04,$00,$04,$00
	dcb.w	4
	dc.b	$00,'@',$00,'@',$00,'@',$00,'@'
	dcb.w	16
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$f8,$ff,$f8,$ff,$f8,$ff,$f8
	dc.b	$00,$c0,$00,$c0,$00,$c0,$00,$c0
	dcb.w	8
	dc.b	$07,$f8,$01,$f8,$0f,$f8,$0f,$f8
	dcb.w	25
	dc.b	$04,$00,$04,$00,$04,$00,$00,$00
	dcb.w	3
	dc.b	$00,$04,$00,$04,$00,$04,$00,$04
	dcb.w	40
	dc.b	$0f,$e0,$01,$e0,$0f,$e0,$0f,$e0
	dcb.w	25
	dc.b	$04,$00,$04,$00,$04,$00,$00,$00
	dcb.w	7
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	36
	dc.b	$07,$80,$0b,$80,$0f,$80,$0f,$80
	dcb.w	12
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	8
	dc.b	$04,$00,$00,$00,$04,$00,$04,$00
	dcb.w	48
	dc.b	$0e,$00,$0a,$00,$0e,$00,$0e,$00
	dcb.w	24
	dc.b	$04,$00,$00,$00,$04,$00,$04,$00
	dcb.w	44
	dc.b	$00,$01,$00,$01,$00,$00,$00,$01
	dc.b	']@>@',$ff,$80,$ff,$c0
	dcb.w	26
	dc.b	$04,$00,$04,$00,$00,$00,$00,$00
	dcb.w	46
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dcb.w	26
	dc.b	$04,$00,$04,$00,$00,$00,$00,$00
	dcb.w	47
	dc.b	$08,$00,$08,$00,$08,$00,$00,$00
	dcb.w	23
	dc.b	$04,$00,$04,$00,$00,$00,$04,$00
	dcb.w	48
	dc.b	$08,$00,$00,$00,$08,$00,$08,$00
	dcb.w	24
	dc.b	$04,$00,$04,$00,$00,$00,$04,$00
	dcb.w	50
	dc.b	$08,$00,$08,$00,$00,$00,$00,$00
	dcb.w	74
	dc.b	$08,$00,$08,$00,$00,$00,$08,$00
	dcb.w	72
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dcb.w	13
	dc.b	$00,$0f,$00,$0f,$00,$0f,$00,$00
	dc.b	$e7,$f0,$e7,$f0,$e7,$f0,$00,$00
	dc.b	$ff,'?',$ff,'?',$ff,'?',$00,$00
	dc.b	$cf,$f3,$cf,$f3,$cf,$f3,$00,$00
	dc.b	$fc,$ff,$fc,$ff,$fc,$ff,$00,$00
	dc.b	$1f,$c7,$1f,$c7,$1f,$c7,$00,$00
	dc.b	$f0,$01,$f0,$01,$f0,$01,$00,$00
	dc.b	$e0,$7f,$e0,$7f,$e0,$7f,$00,$00
	dc.b	$8f,$e7,$8f,$e7,$8f,$e7,$00,$00
	dc.b	$f8,$00,$f8,$00,$f8,$00,$00,$00
	dcb.w	35
	dc.b	'Z',$00,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,'8',$00,'8',$00,$00,' ',$10
	dc.b	',',$11,',',$11,$00,$00,$01,$00
	dc.b	$81,'``',$00,$00,'@',$10
	dc.b	'X',$16,'X',$16,$00,$08,$04,$01
	dc.b	$05,$99,$05,$99,$00,$0c,$00,'@'
	dc.b	'p\p\',$00,$00,$10,$00
	dc.b	$10,$03,$10,$03,$00,$00,' ',$00
	dc.b	' ',$c0,' ',$c0,$18,$00,$80,' '
	dc.b	$b8,',',$b8,',',$00,$00,$08,$00
	dc.b	$08,$00,$08,$00,$02,$d0,$00,$00
	dcb.w	35
	dc.b	'Z',$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,' ',$00,' `',$00
	dc.b	$00,$10,'h',$11,'h',$11,$02,$00
	dc.b	$01,$00,$03,'@',$03,'@',$80,$00
	dc.b	'@',$10,$d0,'4',$d0,'4',$00,$10
	dc.b	$04,$03,$0d,'3',$0d,'3',$00,$c0
	dc.b	$00,$00,'@',$d0,'@',$d0,$00,$00
	dc.b	'0',$00,'0',$02,'0',$02,$00,$00
	dc.b	'`',$00,'``',$81,$00,$00
	dc.b	$80,'`',$a0,'h',$a0,'h',$00,$00
	dc.b	$08,$00,$18,$00,$18,$00,$00,$00
	dc.b	$02,$d0,$00,$00,$00,$00,$00,$00
	dcb.w	31
	dc.b	'Z',$00,'Z',$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,'g',$00,'g',$00,$80,$00,$10
	dc.b	$d9,$93,$d9,$93,$00,$00,$00,$00
	dc.b	'>',$cf,'>',$cf,$00,$00,$00,$00
	dc.b	$9c,$e7,$9c,$e7,$00,$10,$00,$02
	dc.b	';2;2',$00,$00,$00,$00
	dc.b	$cf,$b3,$cf,$b3,$00,$00,$00,$00
	dc.b	$e0,$06,$e0,$06,$00,$00,'@',$00
	dc.b	'@',$e7,'@',$e7,$00,$00,$00,$00
	dc.b	'g',$ce,'g',$ce,$00,$00,$00,$00
	dc.b	'p',$00,'p',$00,$02,$d0,$02,$d0
	dcb.w	34
	dc.b	'Z',$00,'Z',$00,$00,$00,$00,$00
	dc.b	$00,$08,$00,$07,$00,'O',$00,'O'
	dc.b	$01,'0',$80,$00,$93,'2',$93,'2'
	dc.b	'x',$1e,$00,$00,'xžx',$9e
	dc.b	$01,$80,$00,$00,$09,$82,$09,$82
	dc.b	'` ',$00,$06,'b&b&'
	dc.b	$10,$06,$0f,$00,$9f,'&',$9f,'&'
	dcb.w	2
	dc.b	$00,$04,$00,$04,$00,$0c,$c0,$00
	dc.b	$c0,'L',$c0,'L',$0c,$00,$00,$00
	dc.b	'L',$04,'L',$04,$c0,$00,$00,$00
	dc.b	$c0,$00,$c0,$00,$02,$d0,$02,$d0
	dcb.w	36
	dc.b	$db,$00,$00,$00,$00,$08,$00,$00
	dc.b	$00,$c8,$00,$c8,$81,' ',$00,$00
	dc.b	$b3,'&',$b3,'&',$00,$00,$08,$02
	dc.b	$09,$82,$09,$82,$01,$00,$00,$00
	dc.b	$19,$06,$19,$06,'@ ',$00,$04
	dc.b	'F%F%',$11,$02,$00,$00
	dc.b	$91,'"',$91,'"',$00,$00,$00,$00
	dc.b	$00,$0c,$00,$0c,$00,$08,$80,$00
	dc.b	$80,$c8,$80,$c8,$04,$00,$00,$00
	dc.b	'D',$0c,'D',$0c,$80,$00,$00,$00
	dc.b	$80,$00,$80,$00,$00,$00,$00,$00
	dc.b	$06,$d8,$00,$00,$00,$00,$00,$00
	dcb.w	30
	dc.b	$db,$00,$00,$00,$db,$00,$00,$00
	dc.b	$00,$11,$00,$00,$00,$91,$00,$91
	dc.b	$80,'`',$00,$00,$a0,'d',$a0,'d'
	dc.b	$18,$06,$00,$00,$19,$06,$19,$06
	dc.b	$00,$00,$03,$00,$13,$04,$13,$04
	dc.b	$00,$00,$c0,$0c,$c4,$0d,$c4,$0d
	dc.b	'#',$03,$00,$00,'####'
	dc.b	$00,$00,$00,$01,$00,$09,$00,$09
	dc.b	$00,$00,$80,$18,$80,$98,$80,$98
	dc.b	$06,$00,$00,$01,'F',$09,'F',$09
	dc.b	$00,$00,$80,$00,$80,$00,$80,$00
	dc.b	$06,$d8,$00,$00,$06,$d8,$00,$00
	dcb.w	29
	dc.b	$00,$01,$00,$01,$00,$00,$00,$00
	dc.b	$db,$80,$db,$80,$00,$00,$00,$10
	dc.b	$00,$01,$01,$99,$01,$99,$00,$00
	dc.b	$00,$c0,'`',$cc,'`',$cc,$00,$00
	dc.b	$00,$00,$f3,'<',$f3,'<',$00,$00
	dc.b	$02,$00,'2',$0c,'2',$0c,$00,$00
	dc.b	$80,$08,$8c,$0b,$8c,$0b,' ',$01
	dc.b	$02,$00,'2121',$00,$00
	dc.b	$00,$01,$00,$19,$00,$19,$00,$00
	dc.b	$00,$10,$01,$90,$01,$90,$02,$00
	dc.b	$00,$01,'b',$19,'b',$19,$08,$00
	dc.b	$08,$00,$00,$00,$08,$00,$00,$00
	dc.b	$0e,$dc,$0e,$dc,$00,$00,$00,$00
	dcb.w	23
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dc.b	$00,$03,$00,$03,$00,$03,$00,$00
	dc.b	$99,$c0,$99,$c0,$99,$c0,$00,$00
	dc.b	$00,' ',$00,$03,$01,'3',$01,'3'
	dc.b	$08,$01,$01,$80,'I',$89,'I',$89
	dc.b	$80,'`',$00,$00,$82,'`',$82,'`'
	dc.b	$00,$00,$06,$01,'&',$09,'&',$09
	dc.b	$00,$00,$80,$18,$89,$1a,$89,$1a
	dc.b	'@',$01,$06,$00,'f',$11,'f',$11
	dc.b	$00,$00,$00,$03,$00,$13,$00,$13
	dc.b	$00,$00,$00,'0',$01,'0',$01,'0'
	dc.b	$02,$00,$00,$03,'"',$13,'"',$13
	dc.b	$08,$00,$08,$00,$00,$00,$08,$00
	dc.b	$1c,$ce,$1c,$ce,$1c,$ce,$00,$00
	dcb.w	31
	dc.b	$00,$07,$00,$00,$00,$00,$00,$00
	dc.b	$99,$e0,$00,' ',$00,$02,$03,'2'
	dc.b	$03,'2',$08,$00,$00,$81,$cc,$99
	dc.b	$cc,$99,$00,$00,$00,'@',$06,'@'
	dc.b	$06,'@',$00,$00,$04,$01,'d',$19
	dc.b	'd',$19,$00,$00,$00,$10,$19,$16
	dc.b	$19,$16,'@',$00,$04,$01,'d',$19
	dc.b	'd',$19,$00,$02,$00,$00,$00,'2'
	dc.b	$00,'2',$00,$00,$00,' ',$03,' '
	dc.b	$03,' ',$00,$00,$02,$02,'22'
	dc.b	'22',$00,$00,$00,$00,$08,$00
	dc.b	$08,$00,$00,$00,$00,$00,$00,$00
	dc.b	'<',$cf,$00,$00,$00,$00,$00,$00
	dcb.w	28
	dc.b	$00,$07,$00,$00,$00,$00,$00,$00
	dc.b	$18,$e0,$00,'@',$00,$06,$02,'f'
	dc.b	$02,'f',$10,$00,$01,$83,$99,$93
	dc.b	$99,$93,$00,$00,$e0,$f8,$e4,$f8
	dc.b	$e4,$f8,$00,'`',$0c,$03,'Ls'
	dc.b	'Ls',$01,$00,$80,'0',$93,'4'
	dc.b	$93,'4',$81,$f0,$0c,$03,$cd,$f3
	dc.b	$cd,$f3,$00,$00,$00,$07,$00,$27
	dc.b	$00,$27,$0c,$03,$c0,'p',$ce,'s'
	dc.b	$ce,'s',$e0,$00,$06,$06,$e6,'&'
	dc.b	$e6,'&',$00,$00,$00,$00,$08,$00
	dc.b	$08,$00,$00,$00,$00,$00,$00,$00
	dc.b	'8',$c7,$00,$00,$00,$00,$00,$00
	dcb.w	25
	dc.b	$00,$07,$00,$00,$00,$00,$00,$07
	dc.b	$18,$e0,$00,$00,$00,$00,$18,$e0
	dc.b	$00,$00,$00,$04,$02,$05,$02,$05
	dc.b	$18,$00,$00,$80,$9c,$b0,$9c,$b0
	dc.b	$00,$00,' ',$08,',',$08,',',$08
	dc.b	$00,$00,$08,$00,$c8,$c0,$c8,$c0
	dc.b	$81,$00,$00,' ',$b3,'$',$b3,'$'
	dc.b	$00,$00,$08,$02,$0b,$02,$0b,$02
	dcb.w	2
	dc.b	$00,'`',$00,'`',$00,$10,'@',$00
	dc.b	'X',$16,'X',$16,$00,$00,$04,$04
	dc.b	$04,'d',$04,'d',$08,$00,$00,$00
	dc.b	$08,$00,$08,$00,'8',$c7,$00,$00
	dc.b	$00,$00,'8',$c7,$00,$00,$00,$00
	dcb.w	26
	dc.b	$00,$06,$00,$00,$00,$00,$00,$06
	dc.b	$18,'`',$00,$00,$00,$00,$18,'`'
	dc.b	$00,$1c,$00,$00,$02,$1d,$02,$1d
	dc.b	'1',$80,$00,$00,'9',$a0,'9',$a0
	dc.b	'`',$18,$00,$00,'h',$18,'h',$18
	dc.b	$00,$01,$18,$00,$98,$81,$98,$81
	dc.b	$82,'`',$00,$00,$a6,'d',$a6,'d'
	dc.b	'8',$0e,$00,$00,':',$0e,':',$0e
	dcb.w	2
	dc.b	$00,'@',$00,'@',$c0,'0',$00,$00
	dc.b	$d0,'4',$d0,'4',$1c,$00,$00,$0c
	dc.b	$1c,'L',$1c,'L',$08,$00,$00,$00
	dc.b	$08,$00,$08,$00,'0',$c3,$00,$00
	dc.b	$00,$00,'0',$c3,$00,$00,$00,$00
	dcb.w	27
	dc.b	$00,$04,$00,$00,$00,$04,$00,$00
	dc.b	$18,' ',$00,$00,$18,' ',$00,$00
	dc.b	$00,$00,$03,$f1,$03,$f1,$00,$00
	dc.b	$00,$00,$ef,'?',$ef,'?',$00,$00
	dc.b	$00,$00,$cf,$f0,$cf,$f0,$00,$01
	dc.b	$00,$00,$f0,$ff,$f0,$ff,$02,$00
	dc.b	$00,$00,'?',$c7,'?',$c7,$00,$00
	dc.b	$00,$00,$e3,$f8,$e3,$f8,$00,$00
	dc.b	$00,$00,$00,$7f,$00,$7f,$00,' '
	dc.b	$00,$00,$9f,$e7,$9f,$e7,$00,$00
	dc.b	$00,$00,$f0,'x',$f0,'x',$00,$00
	dc.b	$08,$00,$08,$00,$08,$00,$00,$00
	dc.b	' ',$c1,$00,$00,' ',$c1,$00,$00
	dcb.w	71
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dcb.w	76
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dcb.w	40
	dc.b	$03,$ff,$03,$ff,$00,$00,$03,$ff
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$f7,$10,$f7,$10,$08,$ef,$ff,$ff
	dcb.w	2
	dc.b	$ff,$ff,$ff,$ff,$00,$19,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$bf,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$f2,$00,$0d,$ff
	dc.b	$ff,$ff,$ff,$ff,$9d,'`',$fe,'`'
	dc.b	$ff,$80,$ff,$e0,$00,$00,$00,$00
	dcb.w	74
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dcb.w	76
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dc.b	$00,'@',$00,'@',$00,'@',$00,'@'
	dcb.w	73
	dc.b	$08,$00,$08,$00,$08,$00,$00,$00
	dcb.w	75
	dc.b	$08,$00,$00,$00,$08,$00,$08,$00
	dcb.w	76
	dc.b	$08,$00,$00,$00,$08,$00,$08,$00
	dcb.w	76
	dc.b	$08,$00,$00,$00,$08,$00,$08,$00
	dcb.w	78
	dc.b	$08,$00,$08,$00,$00,$00,$00,$00
	dcb.w	66
	dc.b	$00,$02,$00,$02,$00,$02,$00,$02
	dcb.w	4
	dc.b	'(',$00,'(',$00,' ',$00,'(',$00
	dcb.w	68
	dc.b	'@',$00,'@',$00,'@',$00,'@',$00
	dcb.w	4
	dc.b	$08,$00,$08,$00,$00,$00,$08,$00
	dcb.w	104
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dcb.w	28
	dc.b	$00,$08,$00,$08,$00,$08,$00,$08
	dcb.w	764
	dc.b	$02,'@',$82,'A',$82,'A',$01,$80
	dc.b	$02,'@',$82,'A',$81,$81,$00,$00
	dc.b	$02,'@',$82,'A',$81,$81,$03,$c0
	dc.b	$83,$c1,$83,$c1,$83,$c1,$83,$c1
	dc.b	$02,'@',$02,'@',$02,'@',$01,$80
	dc.b	$03,$c0,$03,$c0,$03,$c0,$03,$c0
	dcb.w	8
	dc.b	$02,'@',$02,'@',$01,$80,$03,$c0
	dc.b	$02,'@',$02,'@',$01,$80,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dcb.w	24
	dc.b	'H2H2',$08,'0G',$c2
	dc.b	'H2H2',$07,$c0,'@',$02
	dc.b	'H2H2',$07,$c0,'O',$f2
	dc.b	'O',$f2,'O',$f2,'O',$f2,'O',$f2
	dc.b	$08,'0',$08,'0',$08,'0',$07,$c0
	dc.b	$0f,$f0,$0f,$f0,$0f,$f0,$0f,$f0
	dcb.w	4
	dc.b	$05,$a0,$05,$a0,$05,$a0,$05,$a0
	dc.b	$08,'0',$08,'0',$07,$c0,$0f,$f0
	dc.b	$08,'0',$08,'0',$07,$c0,$00,$00
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dcb.w	24
	dc.b	'3L0',$8c,$10,$08,'/',$f4
	dc.b	'3L0',$8c,$0f,$f0,' ',$04
	dc.b	'3L0',$8c,$0f,$f0,'?',$fc
	dc.b	'?',$fc,'?',$fc,'?',$fc,'?',$fc
	dc.b	$13,'H',$10,$88,$10,$08,$0f,$f0
	dc.b	$1f,$f8,$1f,$f8,$1f,$f8,$1f,$f8
	dc.b	$05,$a0,$00,$00,$00,$00,$00,$00
	dc.b	$0f,$f0,$0f,$f0,$0f,$f0,$0f,$f0
	dc.b	$13,'H',$10,$88,$0f,$f0,$1f,$f8
	dc.b	$13,'H',$10,$88,$0f,$f0,$00,$00
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dcb.w	24
	dc.b	'0',$04,'1„0',$04,$01,$88
	dc.b	'0',$04,'1',$84,$01,$88,$00,$00
	dc.b	'0',$04,'1',$84,$01,$88,'1',$8c
	dc.b	'?',$fc,'?',$fc,'?',$fc,'?',$fc
	dc.b	'6',$14,'1',$e4,'0',$04,$0f,$f8
	dc.b	'?',$fc,'?',$fc,'?',$fc,'?',$fc
	dc.b	$00,$00,$05,$a0,$00,$00,$00,$00
	dc.b	$0f,$f0,$0f,$f0,$0f,$f0,$0f,$f0
	dc.b	'6',$14,'1',$e4,$0f,$f8,'?',$fc
	dc.b	'6',$14,'1',$e4,$0f,$f8,$00,$00
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dcb.w	24
	dc.b	'nro',$f2,'nr',$0f,$f4
	dc.b	'nro',$f2,$0f,$f4,$0e,'p'
	dc.b	'nro',$f2,$0f,$f4,'o',$f6
	dc.b	$7f,$fe,$7f,$fe,$7f,$fe,$7f,$fe
	dc.b	'djc',$f2,'`b',$1f,$fc
	dc.b	$7f,$fe,$7f,$fe,$7f,$fe,$7f,$fe
	dc.b	$05,$a0,$05,$a0,$00,$00,$00,$00
	dc.b	$0f,$f0,$0f,$f0,$0f,$f0,$0f,$f0
	dc.b	'djc',$f2,$1f,$fc,$7f,$fe
	dc.b	'djc',$f2,$1f,$fc,$00,'`'
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dcb.w	24
	dc.b	'H',$12,'IšH',$12,'9',$9c
	dc.b	'H',$12,'Iš9',$9c,$08,$10
	dc.b	'H',$12,'Iš9',$9c,'yž'
	dc.b	$7f,$fe,$7f,$fe,$7f,$fe,$7f,$fe
	dc.b	'L2C',$fa,'@2?',$fc
	dc.b	$7f,$fe,$7f,$fe,$7f,$fe,$7f,$fe
	dc.b	$05,$a0,$05,$a0,$00,$00,$00,$00
	dc.b	$0f,$f0,$0f,$f0,$0f,$f0,$0f,$f0
	dc.b	'L2C',$fa,'?',$fc,$7f,$fe
	dc.b	'L2C',$fa,'?',$fc,$00,'0'
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dcb.w	24
	dc.b	$d8,$11,$c9,$9d,$c8,$11,'9',$9e
	dc.b	$d8,$11,$c9,$9d,'9',$9e,$08,$10
	dc.b	$d8,$11,$c9,$9d,'9',$9e,$f9,$9f
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$d8,$11,$c7,$fd,$c0,$11,'?',$fe
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dcb.w	2
	dc.b	$0d,$b0,$00,$00,$1f,$f8,$1f,$f8
	dc.b	$1f,$f8,$1f,$f8,$d8,$11,$c7,$fd
	dc.b	'?',$fe,$ff,$ff,$d8,$11,$c7,$fd
	dc.b	'?',$fe,$00,$10,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$00,$00,$00,$00
	dcb.w	22
	dc.b	$98,$01,$87,$fd,$80,$01,$7f,$fe
	dc.b	$98,$01,$87,$fd,$7f,$fe,$00,$00
	dc.b	$98,$01,$87,$fd,$7f,$fe,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$98,$01,$87,$fd,$80,$01,$7f,$fe
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$0d,$b0,$00,$00,$0d,$b0,$00,$00
	dc.b	$1f,$f8,$1f,$f8,$1f,$f8,$1f,$f8
	dc.b	$98,$01,$87,$fd,$7f,$fe,$ff,$ff
	dc.b	$98,$01,$87,$fd,$7f,$fe,$00,$00
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dcb.w	24
	dc.b	$98,$01,$87,$fd,$80,$01,$7f,$fe
	dc.b	$98,$01,$87,$fd,$7f,$fe,$00,$00
	dc.b	$98,$01,$87,$fd,$7f,$fe,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$98,$01,$87,$fd,$80,$01,$7f,$fe
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$1d,$b8,$1d,$b8,$00,$00
	dc.b	'?',$fc,'?',$fc,'?',$fc,'?',$fc
	dc.b	$98,$01,$87,$fd,$7f,$fe,$ff,$ff
	dc.b	$98,$01,$87,$fd,$7f,$fe,$00,$00
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dcb.w	24
	dc.b	$dc,$01,$c3,$f9,$c0,$01,$1f,$fa
	dc.b	$dc,$01,$c3,$f9,$1f,$fa,$00,$00
	dc.b	$dc,$01,$c3,$f9,$1f,$fa,$df,$fb
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$dc,$05,$c3,$f9,$c0,$01,'?',$fe
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	'9',$9c,'9',$9c,'9',$9c,$00,$00
	dc.b	$7f,$fe,$7f,$fe,$7f,$fe,$7f,$fe
	dc.b	$dc,$05,$c3,$f9,'?',$fe,$ff,$ff
	dc.b	$dc,$05,$c3,$f9,'?',$fe,$00,$00
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dcb.w	24
	dc.b	'\',$0a,'C',$f2,'@',$02,$1f,$f8
	dc.b	'\',$0a,'C',$f2,$1f,$f8,$00,$00
	dc.b	'\',$0a,'C',$f2,$1f,$f8,'_',$fa
	dc.b	$7f,$fe,$7f,$fe,$7f,$fe,$7f,$fe
	dc.b	'\',$0a,'C',$f2,'@',$02,'?',$fc
	dc.b	$7f,$fe,$7f,$fe,$7f,$fe,$7f,$fe
	dcb.w	3
	dc.b	'y',$9e,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,'\',$0a,'C',$f2,'?',$fc
	dc.b	$7f,$fe,'\',$0a,'C',$f2,'?',$fc
	dc.b	$00,$00,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	21
	dc.b	'F2A',$c2,'@',$02,'/',$f4
	dc.b	'F2A',$c2,'/',$f4,$00,$00
	dc.b	'F2A',$c2,'/',$f4,'o',$f6
	dc.b	$7f,$fe,$7f,$fe,$7f,$fe,$7f,$fe
	dc.b	'F:A',$c2,'@',$02,'?',$fc
	dc.b	$7f,$fe,$7f,$fe,$7f,$fe,$7f,$fe
	dcb.w	3
	dc.b	'q',$8e,$fb,$df,$fb,$df,$fb,$df
	dc.b	$fb,$df,'F:A',$c2,'?',$fc
	dc.b	$7f,$fe,'F:A',$c2,'?',$fc
	dc.b	$00,$00,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	21
	dc.b	'3',$c4,'0',$04,'0',$04,$03,$c8
	dc.b	'3',$c4,'0',$04,$03,$c8,$00,$00
	dc.b	'3',$c4,'0',$04,$03,$c8,'3',$cc
	dc.b	'?',$fc,'?',$fc,'?',$fc,'?',$fc
	dc.b	'3',$e4,'0',$04,'0',$04,$0f,$f8
	dc.b	'?',$fc,'?',$fc,'?',$fc,'?',$fc
	dc.b	'q',$8e,$00,$00,$00,$00,'q',$8e
	dc.b	$fb,$df,$fb,$df,$fb,$df,$fb,$df
	dc.b	'3',$e4,'0',$04,$0f,$f8,'?',$fc
	dc.b	'3',$e4,'0',$04,$0f,$f8,$00,$00
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dcb.w	24
	dc.b	$18,$08,$18,$08,$18,$08,$04,'0'
	dc.b	$18,$08,$18,$08,$04,'0',$00,$00
	dc.b	$18,$08,$18,$08,$04,'0',$1c,'8'
	dc.b	$1f,$f8,$1f,$f8,$1f,$f8,$1f,$f8
	dc.b	$18,$08,$18,$08,$18,$08,$07,$f0
	dc.b	$1f,$f8,$1f,$f8,$1f,$f8,$1f,$f8
	dc.b	'a',$86,$00,$00,$00,$00,'a',$86
	dc.b	$f3,$cf,$f3,$cf,$f3,$cf,$f3,$cf
	dc.b	$18,$08,$18,$08,$07,$f0,$1f,$f8
	dc.b	$18,$08,$18,$08,$07,$f0,$00,$00
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dcb.w	24
	dc.b	$0e,'p',$0e,'p',$0e,'p',$01,$80
	dc.b	$0e,'p',$0e,'p',$01,$80,$00,$00
	dc.b	$0e,'p',$0e,'p',$01,$80,$0f,$f0
	dc.b	$0f,$f0,$0f,$f0,$0f,$f0,$0f,$f0
	dc.b	$0e,'p',$0e,'p',$0e,'p',$01,$80
	dc.b	$0f,$f0,$0f,$f0,$0f,$f0,$0f,$f0
	dc.b	$00,$00,'A',$82,$00,$00,'A',$82
	dc.b	$e3,$c7,$e3,$c7,$e3,$c7,$e3,$c7
	dc.b	$0e,'p',$0e,'p',$01,$80,$0f,$f0
	dc.b	$0e,'p',$0e,'p',$01,$80,$00,$00
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dc.b	$80,$01,$80,$01,$80,$01,$80,$01
	dcb.w	24
	dc.b	$03,$c0,$03,$c0,$03,$c0,$00,$00
	dc.b	$03,$c0,$03,$c0,$00,$00,$00,$00
	dc.b	$03,$c0,$03,$c0,$00,$00,$03,$c0
	dc.b	$03,$c0,$03,$c0,$03,$c0,$03,$c0
	dc.b	$03,$c0,$03,$c0,$03,$c0,$00,$00
	dc.b	$03,$c0,$03,$c0,$03,$c0,$03,$c0
	dcb.w	4
	dc.b	'A',$82,'A',$82,'A',$82,'A',$82
	dc.b	$03,$c0,$03,$c0,$00,$00,$03,$c0
	dc.b	$03,$c0,$03,$c0,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dcb.w	1136
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dcb.w	36
	dc.b	$02,$00,$02,$00,$02,$00,$02,$00
	dcb.w	12
	dc.b	$02,$00,$02,$00,$02,$00,$02,$00
	dcb.w	24
	dc.b	$00,$10,$00,$10,$00,$10,$00,$10
	dcb.w	8
	dc.b	$04,$00,$04,$00,$04,$00,$04,$00
	dcb.w	8
	dc.b	$00,$10,$00,$10,$00,$10,$00,$10
	dcb.w	44
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dcb.w	9
	dc.b	$00,$04,$00,$08,$00,$0c,$00,$03
	dc.b	$00,$07,$00,$0b,$00,$0f,$00,$01
	dc.b	$00,$01,$00,$01,$00,$01,$00,$80
	dc.b	$00,'T',$00,'*',$00,$00
l0040	dc.b	$0f,$ef,$0c,$1f,$03,$ff,$0f,$ff
	dc.b	'fr',$81,$fe,$ff,$fc,$ff,$fe
	dc.b	$0f,$ef,$0c,$1f,$03,$ff,$0f,$ff
	dc.b	'fr',$81,$fe,$ff,$fe,$ff,$fe
	dc.b	'8',$e0,$c7,$c0,$ff,$e0,$ff,$e0
	dc.b	$0e,'8',$07,$c6,$0f,$fe,$0f,$fe
	dcb.w	4
	dc.b	$10,$d8,$17,$18,$0f,$e0,$1f,$f8
	dc.b	$08,$f8,$08,$18,$07,$e0,$0f,$f8
	dc.b	$05,$12,$0e,$0e,$0f,$fc,$0f,$fe
	dc.b	$f7,'>',$0f,$c1,$ff,$ff,$ff,$ff
	dc.b	'y`',$fe,'`',$ff,$80,$ff,$e0
	dc.b	$07,$8c,$06,$03,$01,$ff,$07,$ff
	dc.b	$e3,'O',$fc,'?',$ff,$fe,$ff,$ff
	dc.b	$07,$af,$06,' ',$01,$df,$07,$ff
	dc.b	'<',$b0,$ff,'0',$ff,$c0,$ff,$f0
	dc.b	'{',$9f,$07,$e0,$7f,$ff,$7f,$ff
	dc.b	'<',$b0,$ff,'0',$ff,$c0,$ff,$f0
	dc.b	$07,$f7,$06,$0f,$01,$ff,$07,$ff
	dc.b	$b3,'9',$c0,$ff,$ff,$ff,$ff,$ff
	dc.b	'm',$f9,'~',$07,$1f,$ff,$7f,$ff
	dc.b	$ad,$ce,$c3,$fe,$ff,$f0,$ff,$fe
	dc.b	'm',$f9,'~',$07,$1f,$ff,$7f,$ff
	dc.b	$ad,$ce,$c3,$fe,$ff,$f0,$ff,$fe
	dc.b	$cd,$e0,$f3,'`?',$80,$ff,$e0
	dc.b	$0f,'f',$0d,$9e,$03,$f8,$0f,$fe
	dcb.w	4
	dc.b	'N',$bc,$7f,$04,'?',$f8,$7f,$fc
	dc.b	'c',$0a,'|',$f2,$1f,$fc,$7f,$fe
	dc.b	$08,$ae,$0b,$1e,$07,$f0,$0f,$fe
	dc.b	$fa,'<',$c7,$c3,'?',$ff,$ff,$ff
	dc.b	'c',$e8,$fc,'x',$ff,$f0,$ff,$f8
	dc.b	'6',$dc,'?',$03,$0f,$ff,'?',$ff
	dc.b	$cc,$bf,$f0,$7f,$ff,$f8,$ff,$ff
	dc.b	$16,$fe,$1f,'!',$0f,$df,$1f,$ff
	dc.b	'1',$f4,$fe,'<',$ff,$f8,$ff,$fc
	dc.b	'}',$1e,'c',$e1,$1f,$ff,$7f,$ff
	dc.b	'1',$f4,$fe,'<',$ff,$f8,$ff,$fc
	dc.b	'6',$fc,'?',$03,$0f,$ff,'?',$ff
	dc.b	$d6,$e7,$e1,$ff,$ff,$f8,$ff,$ff
	dc.b	$a7,$ff,$f8,$00,$7f,$ff,$f8,$00
	dc.b	$ff,$fe,$00,$0e,$ff,$f0,$00,$0e
	dc.b	$a7,$ff,$f8,$00,$7f,$ff,$f8,$00
	dc.b	$ff,$fe,$00,$0c,$ff,$f2,$00,$0e
	dc.b	$ff,$90,$e0,$90,$1f,'`',$e0,$f0
	dc.b	$13,$fe,$12,$0e,$0d,$f0,$1e,$0e
	dc.b	'@',$11,'@',$11,'@',$10,'@',$11
	dc.b	$e0,$1e,$1f,$fe,$f0,$00,$ff,$fe
	dc.b	$d8,$0f,$bf,$f1,'x',$0e,$ff,$ff
	dc.b	$86,$0e,$87,$fe,$08,$00,$8f,$fe
	dc.b	' ',$00,'?',$ff,$c0,$00,$ff,$ff
	dc.b	$00,'4',$ff,$c4,$00,'8',$ff,$fc
	dc.b	'S',$ff,'|',$00,'?',$ff,'|',$00
	dc.b	$ff,$ff,$00,$07,$ff,$f8,$00,$07
	dc.b	$13,$ff,'<',$00,'?',$ff,'<',$00
	dc.b	$ff,$fa,$00,$02,$ff,$fc,$00,$1e
	dc.b	$1f,$ff,$10,$00,'o',$ff,'p',$00
	dc.b	$ff,$fa,$00,$02,$ff,$fc,$00,$1e
	dc.b	'S',$ff,'|',$00,'?',$ff,'|',$00
	dc.b	$ff,$ff,$00,$06,$ff,$f9,$00,$07
	dc.b	$cf,$ff,'0',$00,$ff,$ff,$f0,$00
	dc.b	$ff,$f0,$00,$00,$ff,$fe,$00,$0e
	dc.b	$cf,$ff,$b0,$00,$7f,$ff,$f0,$00
	dc.b	$ff,$f2,$00,$02,$ff,$fc,$00,$0e
	dc.b	$ff,$94,$e0,$04,$1f,$f8,$e0,'|'
	dc.b	'S',$fe,'@',$0e,'?',$f0,'|',$0e
	dc.b	$00,$05,$00,$06,$00,$03,$00,$07
	dc.b	$c0,$0e,'?',$fe,$c0,$00,$ff,$fe
	dc.b	$e0,$00,$1f,$fc,$f0,$03,$ff,$ff
	dc.b	$e8,$0e,$e1,$fe,$0e,$00,$ef,$fe
	dc.b	$80,$00,$1f,$ff,$e0,$00,$ff,$ff
	dc.b	$00,$1f,$ff,$ff,$00,$01,$ff,$ff
	dc.b	'g',$ff,$18,$00,$7f,$ff,'x',$00
	dc.b	$ff,$ff,$00,$07,$ff,$f8,$00,$07
	dc.b	'g',$ff,$18,$00,$7f,$ff,'x',$00
	dc.b	$ff,$ff,$00,$0f,$ff,$f0,$00,$0f
	dc.b	'O',$ff,$00,$00,$7f,$ff,'p',$00
	dc.b	$ff,$ff,$00,$0f,$ff,$f0,$00,$0f
	dc.b	'g',$ff,'X',$00,'?',$ff,'x',$00
	dc.b	$ff,$f9,$00,$01,$ff,$fe,$00,$07
	dc.b	'`',$7f,$00,$7f,$ff,$80,$e0,$7f
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$ff,$fe
	dc.b	'`',$7f,$00,$7f,$ff,$80,$e0,$7f
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$ff,$fe
	dc.b	$80,';',$80,$07,$7f,$ff,$f0,'?'
	dc.b	$b8,$02,$c0,$02,$ff,$fc,$f8,$1e
	dc.b	$10,$1f,$10,$1f,$10,$0f,$10,$1f
	dc.b	$ff,$fe,$00,$0e,$00,$00,$ff,$fe
	dc.b	$1f,$ff,$00,$00,$e0,$00,$ff,$ff
	dc.b	$d3,$f8,$dc,$08,'.',$06,$ff,$fe
	dc.b	$df,$ff,$00,$ff,$e0,$00,$ff,$ff
	dc.b	$ff,$fe,$fc,$0e,$00,$00,$ff,$fe
	dc.b	'0?',$00,'?',$7f,$c0,'p?'
	dc.b	$ff,$87,$ff,$87,$00,'x',$ff,$ff
	dc.b	'0?',$00,'?',$7f,$c0,'p?'
	dc.b	$fe,$06,$fe,$06,$01,$f9,$fe,$07
	dc.b	'`',$7f,$00,$7f,$7f,$80,'p',$7f
	dc.b	$fe,$07,$fe,$07,$01,$f8,$fe,$07
	dc.b	'0?',$00,'?',$7f,$c0,'p?'
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$ff,$ff
	dc.b	' ',$e0,$00,$c0,$ff,'?',$e0,$f0
	dc.b	$00,$0e,$00,$0e,$ff,$f0,$00,$0e
	dc.b	' ',$00,$00,$00,$ff,$ff,$e0,$00
	dc.b	$00,$0e,$00,$0e,$ff,$f0,$00,$0e
	dc.b	'l',$00,'l',$00,$13,$ff,'|',$00
	dc.b	$00,'l',$00,'l',$ff,$90,$00,'|'
	dc.b	$00,$7f,$00,'|',$00,'<',$00,$7f
	dc.b	$ff,$f0,$0c,$00,$02,$0e,$ff,$fe
	dc.b	$ff,'?',$00,$00,$e0,$c0,$ff,$ff
	dc.b	$c9,$f8,$0e,$08,'6',$06,$ff,$fe
	dc.b	'?',$ff,$c0,$ff,$e0,$00,$ff,$ff
	dc.b	$13,$f8,$16,$08,$ee,$06,$ff,$fe
	dc.b	$10,$7f,$00,$7f,$7f,$80,'p',$7f
	dc.b	$ff,$f1,$ff,$f1,$00,$0e,$ff,$ff
	dc.b	$10,$7f,$00,$7f,$7f,$80,'p',$7f
	dc.b	$89,$04,$8b,$04,'w',$fb,$ff,$07
	dc.b	$10,$7f,'`',$7f,$7f,$80,'p',$7f
	dc.b	$89,$04,$8b,$04,'w',$fb,$ff,$07
	dc.b	$10,$00,$00,$00,$7f,$ff,'p',$00
	dc.b	$00,$07,$00,$07,$ff,$f8,$00,$07
	dc.b	'_',$df,$9f,$ef,$e0,'0',$e0,$f0
	dc.b	$ff,$f8,$ff,$f8,$00,$06,$00,$0e
	dc.b	'_',$ff,$9f,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fc,$ff,$fc,$00,$02,$00,$0e
	dc.b	$1d,$ff,$11,$ff,$0e,$00,$1f,$00
	dc.b	$ff,'p',$ff,$10,$00,$e0,$01,$f0
	dc.b	$01,'0',$01,$f0,$00,$f0,$01,$ff
	dc.b	'8',$04,'>',$00,$06,$0e,$ff,$fe
	dc.b	$00,$80,$e0,$80,$e0,'p',$ff,$ff
	dc.b	$0c,$08,$0e,$08,$02,$06,$ff,$fe
	dc.b	'@',$e0,$e0,$e0,$e0,$00,$ff,$e0
	dc.b	$06,$08,$0e,$08,$0e,$06,$0f,$fe
	dc.b	'/',$f0,'O',$f0,'p',$00,'pp'
	dcb.w	4
	dc.b	'/',$f0,'O',$f0,'p',$00,'pp'
	dc.b	$03,$fe,$07,$f9,$07,$07,$07,$07
	dc.b	'/',$f0,$7f,$f0,'p',$00,'pp'
	dc.b	$03,$fc,$07,$fc,$07,$03,$07,$07
	dc.b	'/',$ff,'O',$ff,'p',$00,'p',$00
	dc.b	$ff,$fe,$ff,$fe,$00,$01,$00,$07
	dc.b	$df,$ff,$ff,$ff,$e0,'0',$e0,$f0
	dc.b	$ff,$f8,$ff,$f8,$00,$06,$00,$0e
	dc.b	$ff,$ff,$7f,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fc,$ff,$fc,$00,$02,$00,$0e
	dc.b	'[',$ff,$7f,$ff,'<',$00,'|',$00
	dc.b	$ff,$b4,$ff,$fc,$00,'x',$00,'|'
	dc.b	$07,$00,$04,$c0,$03,$c0,$07,$ff
	dc.b	$ce,$0a,$d0,$0a,'>',$04,$ff,$fe
	dc.b	$e0,$cc,$e0,$c0,$e0,'<',$ff,$ff
	dc.b	$00,$0e,$00,$0e,$00,$00,$ff,$fe
	dc.b	$e0,$f2,$e0,$ef,$e0,$1f,$ff,$ff
	dc.b	'l',$0a,$82,$0a,$fe,$04,$ff,$fe
	dc.b	'o',$e4,$7f,$e3,'p',$1f,'p',$7f
	dc.b	'0',$e4,$ff,$1e,$ff,$ff,$ff,$ff
	dc.b	'o',$e1,$7f,$e7,'p',$1f,'p',$7f
	dc.b	'6',$f9,$c1,$fe,$ff,$07,$ff,$07
	dc.b	$7f,$f9,$7f,$f7,'p',$0f,'p',$7f
	dc.b	'6',$fd,$c1,$fd,$ff,$02,$ff,$07
	dc.b	'o',$ff,$7f,$ff,'p',$00,'p',$00
	dc.b	$ff,$fe,$ff,$fe,$00,$01,$00,$07
	dc.b	$c0,$07,$ff,$ff,$e0,$7f,$e0,$7f
	dc.b	$b2,$0c,$cd,$fc,$fe,$02,$fe,$0e
	dc.b	'@',$fc,$ff,$fc,$e0,$03,$e0,$ff
	dc.b	$9f,$9e,$1f,$86,$e0,'x',$ff,$fe
	dc.b	$f0,'=',$8f,$fd,'p',$02,$f0,'?'
	dc.b	'x',$1e,$7f,$e2,$80,$1c,$f8,$1e
	dc.b	$13,$ff,$1c,$ff,$0f,$ff,$1f,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$f0,$00,$0e
	dc.b	'_',$f8,$ff,$f7,$ff,$0f,$e0,$ff
	dc.b	$ff,$fe,$ff,$fe,$ff,$f0,$00,$0e
	dc.b	'_',$cf,$ff,$bf,$ff,$7f,$e0,$ff
	dc.b	$13,$fe,$e3,$fe,$ff,$f0,$fc,$0e
	dc.b	'`',$1e,$7f,$c1,'p?p?'
	dc.b	'9',$13,$fe,$fb,$ff,$fc,$ff,$ff
	dc.b	'`',$1f,$7f,$c7,'p?p?'
	dc.b	$88,$06,$f1,$fe,$fe,$01,$fe,$07
	dc.b	' g',$7f,$df,'p?p',$7f
	dc.b	$88,$07,$f1,$ff,$fe,$00,$fe,$07
	dc.b	'`',$13,$7f,$cf,'p?p?'
	dc.b	$9c,'w',$e3,$86,$ff,$f9,$ff,$ff
	dc.b	$b0,$00,'O',$ff,$f0,$00,$f0,$00
	dc.b	$00,$0e,$ff,$fe,$00,$00,$00,$0e
	dc.b	$e0,$e0,$1f,$e0,$e0,$00,$e0,$e0
	dcb.w	4
	dc.b	$80,'<',$9f,$bc,'`@',$e0,'|'
	dc.b	'x',$02,'{',$f2,$04,$0c,'|',$0e
	dc.b	's',$fc,'O',$fc,'?',$f3,'|',$0f
	dc.b	$03,$fe,$03,$fe,$fd,$f0,$fe,$0e
	dc.b	$1f,$e5,$ff,$e6,$ff,$03,$e0,$e7
	dc.b	$ff,$fe,'?',$fe,$ff,$e0,$c0,$1e
	dc.b	$ff,$ff,$1f,$ff,$ff,$ff,$e0,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$e0,$00,$1e
	dc.b	'X',$00,$27,$ff,'x',$00,'x',$00
	dc.b	$00,$07,$ff,$ff,$00,$00,$00,$07
	dc.b	'X',$00,$27,$ff,'x',$00,'x',$00
	dc.b	$00,$0f,$ff,$ff,$00,$00,$00,$0f
	dc.b	'p',$00,$0f,$ff,'p',$00,'p',$00
	dc.b	$00,$0f,$ff,$ff,$00,$00,$00,$0f
	dc.b	'X',$00,$27,$ff,'x',$00,'x',$00
	dc.b	$00,$06,$ff,$fe,$00,$01,$00,$07
	dc.b	$c8,$00,$87,$ff,'x',$00,$f8,$00
	dc.b	$00,$0e,$ff,$fe,$00,$00,$00,$0e
	dc.b	$a0,' ',$7f,' ',$e0,$c0,$e0,$e0
	dcb.w	4
	dc.b	$e0,'p',$ff,$90,$00,$e0,$e0,$f0
	dc.b	$1c,$0e,$13,$fe,$0e,$00,$1e,$0e
	dc.b	$8f,$ff,$7f,$ff,$ff,$c0,$f0,'?'
	dc.b	$bd,$fe,$bb,$fe,'G',$f0,$fe,$0e
	dc.b	$ff,$e1,$1f,$e1,$ff,$00,$e0,$e1
	dc.b	$cf,$de,$0f,$de,$ff,$e0,$f0,'>'
	dc.b	$bf,$ff,$7f,$ff,$ff,$ff,$e0,$00
	dc.b	$ff,$dc,$ff,$dc,$ff,$e0,$00,'<'
	dc.b	'd',$00,'C',$ff,'<',$00,'|',$00
	dc.b	$00,$06,$ff,$fe,$00,$01,$00,$07
	dc.b	'd',$00,'C',$ff,'<',$00,'|',$00
	dc.b	$00,$0e,$ff,$ee,$00,$10,$00,$1e
	dc.b	'P',$00,'?',$ff,'p',$00,'p',$00
	dc.b	$00,$0e,$ff,$ee,$00,$10,$00,$1e
	dc.b	'd',$00,'C',$ff,'<',$00,'|',$00
	dc.b	$00,$06,$ff,$fe,$00,$01,$00,$07
	dc.b	'd',$fd,'x',$fd,$1f,$02,$7f,$ff
	dc.b	$ff,$0e,$ff,$0e,$00,$f0,$ff,$fe
	dc.b	$9f,$80,$df,$80,$e0,'`',$ff,$e0
	dcb.w	4
	dc.b	$f7,$80,$e7,$e0,$18,$e0,$ff,$e0
	dc.b	$03,$de,$0f,$ce,$0e,'0',$0f,$fe
	dc.b	$bc,$f0,$bc,$f0,'C',$00,$ff,$f0
	dc.b	$07,$ee,$0b,$ee,$0c,$10,$0f,$fe
	dc.b	$ff,$e0,'?',$e0,$c0,$00,$ff,$e0
	dc.b	'_',$ec,'_',$ec,' ',$10,$7f,$fc
	dc.b	$9f,$ff,$df,$ff,$e0,$00,$ff,$ff
	dc.b	$ff,$e8,$ff,$e8,$00,$10,$ff,$f8
	dc.b	'2',$7f,'<',$7f,$0f,$80,'?',$ff
	dc.b	$ff,$fc,$ff,$fc,$00,$03,$ff,$ff
	dc.b	'2',$7f,'<',$7f,$0f,$80,'?',$ff
	dc.b	$ff,$f4,$ff,$f4,$00,$08,$ff,$fc
	dc.b	'O',$ff,'o',$ff,'p',$00,$7f,$ff
	dc.b	$ff,$f4,$ff,$f4,$00,$08,$ff,$fc
	dc.b	'2',$7f,'<',$7f,$0f,$80,'?',$ff
	dc.b	$bf,$1e,$bf,$1e,'@',$e1,$ff,$ff
	dc.b	$07,$f0,$07,$f0,$00,$0f,$07,$ff
	dc.b	$7f,$e2,$7f,$e2,$80,$1c,$ff,$fe
	dc.b	'q',$e0,'q',$e0,$8e,$00,$ff,$e0
	dcb.w	4
	dc.b	$f1,$e0,$81,$e0,'~ ',$ff,$e0
	dc.b	$0f,$1e,$0f,$02,$08,$fc,$0f,$fe
	dc.b	$ff,$c0,$ff,$c0,$00,$00,$ff,$c0
	dc.b	$07,$fe,$07,$fe,$00,$00,$07,$fe
	dc.b	$e1,$e0,$e1,$e0,$1e,$00,$ff,$e0
	dc.b	$0f,$e0,$0f,$e0,$00,$00,$0f,$e0
	dc.b	'q',$fe,'q',$fe,$8e,$01,$ff,$ff
	dc.b	$0f,$c0,$0f,$c0,$f0,$00,$ff,$c0
	dc.b	$0f,$ff,$0f,$ff,$00,$00,$0f,$ff
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$03,$c7,$03,$c7,$00,'8',$03,$ff
	dc.b	$07,$e0,$07,$e0,$f8,$00,$ff,$e0
	dc.b	'8',$ff,'8',$ff,'G',$00,$7f,$ff
	dc.b	$07,$e0,$07,$e0,$f8,$00,$ff,$e0
	dc.b	$03,$fe,$03,$fe,$00,$01,$03,$ff
	dc.b	'?',$c6,'?',$c6,$c0,'9',$ff,$ff
	dcb.w	16
	dc.b	$00,$02,$00,$02,$00,$02,$00,$02
	dcb.w	50
	dc.b	$80,$00,$80,$00,$00,$00,$00,$00
	dcb.w	74
	dc.b	$80,$00,$00,$00,$80,$00,$80,$00
	dcb.w	32
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dcb.w	41
	dc.b	$80,$00,$80,$00,$80,$00,$00,$00
	dcb.w	35
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dcb.w	32
	dc.b	$00,$12,$00,$11,$00,$0f,$00,$1f
	dc.b	$a6,$00,$c6,$00,$f8,$00,$fe,$00
	dcb.w	20
	dc.b	'9',$09,'~',$07,$7f,$ff,$7f,$ff
	dc.b	$ce,'l',$f0,$0c,$ff,$f0,$ff,$fc
	dc.b	'7',$90,'x',$10,$7f,$e0,$7f,$f0
	dc.b	$0d,$e4,$1e,$04,$1f,$f8,$1f,$fc
	dcb.w	4
	dc.b	$01,$c3,$01,$80,$00,$7f,$01,$ff
	dc.b	's',$b3,$fc,$8f,$ff,$7f,$ff,$ff
	dc.b	$93,$90,$f7,$e0,$e7,$ff,$f7,$ff
	dc.b	$9f,$ff,$7f,$0c,$fc,$f3,$ff,$ff
	dc.b	$03,$90,$e7,$e0,$f7,$ff,$f7,$ff
	dc.b	$9c,$e6,$7f,$00,$ff,$ff,$ff,$ff
	dc.b	$82,$89,$87,$07,$07,$fe,$87,$ff
	dc.b	$1c,'pc',$e0,$7f,$f0,$7f,$f0
	dc.b	$07,$1c,$03,$e3,$07,$ff,$07,$ff
	dc.b	$82,$00,$82,$00,$82,$00,$82,$00
	dcb.w	20
	dc.b	$0e,$fa,$1f,$07,$7f,$ff,$7f,$ff
	dc.b	';',$9a,$c0,'b',$ff,$fc,$ff,$fe
	dc.b	'jp',$1c,'p',$7f,$80,$7f,$f0
	dc.b	$1a,$9c,$07,$1c,$1f,$e0,$1f,$fc
	dcb.w	4
	dc.b	$07,$a1,$05,$c0,$03,$ff,$07,$ff
	dc.b	$cd,'n>',$1f,$ff,$ff,$ff,$ff
	dc.b	'p',$ef,$f1,$f0,$87,$ff,$f7,$ff
	dc.b	$a3,$b8,'|',$07,$ff,$ff,$ff,$ff
	dc.b	'0',$ef,$b1,$f0,$c7,$ff,$f7,$ff
	dc.b	$a3,$b9,'|',$06,$ff,$ff,$ff,$ff
	dc.b	$a0,'W!',$8f,$c7,$f8,$e7,$ff
	dc.b	'f',$f0,'y',$b0,$1f,$c0,$7f,$f0
	dc.b	$07,$b3,$06,$cf,$01,$fc,$07,$ff
	dc.b	$80,$00,$00,$00,$80,$00,$80,$00
	dcb.w	20
	dc.b	'o',$ff,'`',$00,$1f,$ff,'p',$00
	dc.b	$ff,$ff,$00,$0f,$ff,$f0,$00,$0f
	dc.b	$1f,$f0,'`p',$7f,$80,'pp'
	dc.b	$07,$fc,$18,$1c,$1f,$e0,$1c,$1c
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dc.b	$06,$00,$01,$ff,$07,$80,$07,$ff
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	'v',$00,$f6,$ff,$01,$00,$f7,$ff
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	'f',$00,$e6,$ff,$11,$00,$f7,$ff
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$f6,$07,$f6,$ff,$01,$00,$f7,$ff
	dc.b	'pH',$7f,$c8,$00,'0',$7f,$f8
	dc.b	$09,$07,$09,$ff,$06,$00,$0f,$ff
	dc.b	$00,$80,$00,$80,$80,$80,$80,$80
	dcb.w	20
	dc.b	'O',$ff,'@',$00,'?',$ff,'p',$00
	dc.b	$ff,$ff,$00,$07,$ff,$f8,$00,$07
	dc.b	$1f,$f0,'`p',$7f,$80,'pp'
	dc.b	$1f,$fc,$1c,$1c,$1f,$e0,$1c,$1c
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dc.b	$03,$00,$00,$ff,$07,$00,$07,$ff
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$04,$00,$84,$ff,'s',$00,$f7,$ff
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	't',$00,$f4,$ff,$03,$00,$f7,$ff
	dc.b	$00,$00,$ff,$ff,$00,$00,$ff,$ff
	dc.b	'q',$07,$f1,$ff,$06,$00,$f7,$ff
	dc.b	'p',$0a,$7f,$c2,$00,'<',$7f,$fe
	dc.b	'(',$07,'!',$ff,$1e,$00,'?',$ff
	dc.b	$82,$00,$82,$00,$02,$00,$82,$00
	dcb.w	20
	dc.b	$7f,$ff,$7f,$ff,$00,$00,$7f,$ff
	dc.b	$ff,$07,$ff,$07,$00,$f8,$ff,$07
	dc.b	'pLpC',$7f,$bf,'p',$7f
	dc.b	'd',$1c,$84,$1c,$ff,$e0,$fc,$1c
	dcb.w	4
	dc.b	$06,$fb,$06,$03,$01,$04,$07,$ff
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$f6,$f9,$f0,$f9,$07,$06,$f7,$ff
	dc.b	$bf,$f1,$81,$f0,'@',$0f,$ff,$ff
	dc.b	$f7,$ff,'w',$ff,$80,$00,$f7,$ff
	dc.b	$ff,$ff,$ff,$f0,$00,$00,$ff,$ff
	dc.b	$f2,$fc,'p',$04,$07,$03,$f7,$ff
	dc.b	'G',$fd,'@',$03,'8',$1f,$7f,$ff
	dc.b	$df,$f1,$e0,$01,$fc,$0e,$ff,$ff
	dc.b	$00,$80,$00,$80,$80,$80,$80,$80
	dcb.w	20
	dc.b	'`',$00,$00,$00,$7f,$ff,'p',$00
	dc.b	$00,$07,$00,$07,$ff,$f8,$00,$07
	dc.b	$00,$00,'p',$00,$7f,$ff,'p',$00
	dc.b	$00,$14,$00,$14,$ff,$e8,$00,$1c
	dcb.w	4
	dc.b	$01,$ff,$00,$00,$07,$00,$07,$ff
	dc.b	$ff,$fe,$00,$01,$00,$01,$ff,$ff
	dc.b	$c3,$8e,$e3,$8e,$e4,'q',$e7,$ff
	dc.b	'~~',$c0,'~',$c1,$81,$ff,$ff
	dc.b	'v',$ff,$10,$00,$e7,$00,$f7,$ff
	dc.b	$ff,$ff,$00,$00,$00,$00,$ff,$ff
	dc.b	$f7,$fc,'p',$04,$07,$03,$f7,$ff
	dc.b	'7',$ff,'6',$00,$08,$00,'?',$ff
	dc.b	$ff,$f6,$00,'6',$00,$08,$ff,$fe
	dcb.w	2
	dc.b	$80,$00,$80,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dcb.w	12
	dc.b	'_',$ff,'/',$ff,'p',$00,'p',$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$1e
	dc.b	'w',$ff,'G',$ff,'8',$00,'x',$00
	dc.b	$ff,$dc,$ff,$c4,$00,'8',$00,'<'
	dcb.w	4
	dc.b	$04,$00,$03,$00,$07,$00,$07,$ff
	dcb.w	3
	dc.b	$ff,$ff,'`',$01,$00,$01,'p',$01
	dc.b	$f0,$01,$81,$00,$c1,$00,$c0,$c0
	dc.b	$ff,$c0,$01,$00,$06,$00,$07,$00
	dc.b	$07,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,'p',$04,'w',$04,$07,$03
	dc.b	$f7,$ff,$0e,$80,$08,$80,$07,$00
	dc.b	$0f,$ff,$00,$b8,$00,$88,$00,'p'
	dc.b	$ff,$f8,$82,$00,$82,$00,$02,$00
	dc.b	$82,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$01,$00,$01,$00,$01,$00
	dc.b	$01,$00,$00,$00,$00,$00,$00,$00
	dcb.w	9
	dc.b	'/',$ff,$7f,$ff,'p',$00,'p',$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$07
	dc.b	')',$ff,'&',$ff,$1f,$00,'?',$00
	dc.b	$ff,'(',$fe,$c8,$01,$f0,$01,$f8
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dc.b	$02,$c0,$00,$c0,$03,$00,$03,$ff
	dcb.w	3
	dc.b	$ff,$ff,'p',$00,'p',$01,$00,$01
	dc.b	$f0,$01,'A',$80,$c1,$80,$c0,'@'
	dc.b	$ff,$c0,$06,$00,$07,$00,$07,$00
	dc.b	$07,$ff,$00,$01,$00,$01,$00,$00
	dc.b	$ff,$ff,'g',$06,$07,$06,$e7,$01
	dc.b	$e7,$ff,',',$00,'>',$00,$1e,$00
	dc.b	'?',$ff,$00,$1a,$00,'>',$00,'<'
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dcb.w	17
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dc.b	'pg',$7f,$9f,'p',$7f,'p',$7f
	dc.b	$9c,$07,$e3,$ff,$ff,$00,$ff,$07
	dc.b	$1c,$f8,$18,$f7,$07,$08,$1f,$f8
	dc.b	'>p',$fe,'0',$01,$c0,'?',$f0
	dcb.w	4
	dc.b	$07,$8c,$01,$f0,$07,$ff,$07,$ff
	dc.b	$cd,$8f,'>',$0f,$ff,$ff,$ff,$f0
	dc.b	$f0,$01,$f0,$01,$80,$01,'p',$01
	dc.b	$ff,$c0,$ff,$c0,$fe,$00,$c1,$c0
	dc.b	$0a,$ff,$0f,$ff,$0f,$f8,$0f,$07
	dc.b	$f8,$df,$f8,'?',$07,$ff,$ff,$e0
	dc.b	$92,$ff,$87,$ff,$f7,$f8,'w',$07
	dc.b	$7f,$fe,'G',$fe,'?',$e1,'x',$1f
	dc.b	$bf,$ff,$bf,$f1,'C',$fe,$fc,$0f
	dcb.w	12
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dcb.w	9
	dc.b	$7f,$ff,'p',$00,'p',$00,$00,$07
	dc.b	$ff,$ff,$00,$00,$00,$07,$00,'('
	dc.b	$00,$1f,$00,'8',$00,'88',$00
	dc.b	$f8,$00,$00,$00,'8',$00,$00,$00
	dcb.w	3
	dc.b	$01,$ff,$06,$ff,$07,$ff,$07,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$f0,$00,$f0,$01,$80,$01,'p',$01
	dc.b	'?',$c0,$ff,$c0,$fe,$00,$c1,$c0
	dc.b	$05,$ff,$02,$ff,$07,$f8,$07,$07
	dc.b	$00,'_',$00,'?',$00,$7f,$00,'p'
	dc.b	$e0,$ff,$e7,$ff,$97,$f8,'w',$07
	dc.b	'O',$de,'O',$de,'?',$e0,'p>'
	dc.b	'=',$f9,'=',$f9,$03,$fe,'>',$07
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dcb.w	8
	dc.b	$02,$01,$02,$01,$02,$01,$02,$01
	dcb.w	8
	dc.b	'P',$00,'/',$ff,'p',$00,'p',$00
	dc.b	$00,$0f,$ff,$ff,$00,$00,$00,$0f
	dc.b	$00,'0',$00,'?',$00,'8',$00,'8'
	dc.b	'8',$00,$f8,$00,$00,$00,'8',$00
	dcb.w	4
	dc.b	$0f,$ff,$0f,$ff,$07,$ff,$0f,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	'4',$01,'4',$00,$c4,$01,$f4,$01
	dc.b	$ff,$c0,'?',$c0,$fe,$00,$c1,$c0
	dc.b	$05,$f9,$03,$f9,$07,$fe,$07,$07
	dc.b	$10,'o',$10,$7f,$10,$7f,$10,'p'
	dc.b	$f7,$ff,$f0,$ff,$87,$f8,'w',$07
	dc.b	$7f,$b8,$7f,$c8,$0f,$f0,'px'
	dc.b	$0e,$ff,$09,$ff,$07,$f8,$0f,$07
	dc.b	$00,'@',$00,'@',$00,'@',$00,'@'
	dcb.w	4
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dc.b	$00,$08,$00,$08,$00,$08,$00,$08
	dcb.w	8
	dc.b	$7f,$ff,$1f,$ff,'`',$00,$7f,$ff
	dc.b	$ff,$fa,$ff,$fa,$00,$04,$ff,$fe
	dc.b	$00,$1f,$00,'/',$00,'0',$00,'?'
	dc.b	$b8,$00,$b8,$00,'@',$00,$f8,$00
	dc.b	$00,'@',$00,'@',$00,'@',$00,'@'
	dc.b	$0d,$cf,$07,$cf,$0e,'0',$0f,$ff
	dc.b	$cf,'1',$c0,'0?',$cf,$ff,$ff
	dc.b	$e0,$01,' ',$00,$c0,$01,$e0,$01
	dc.b	$ff,$c0,$7f,$c0,$80,$00,$ff,$c0
	dc.b	$04,$fc,$06,$fc,$07,$03,$07,$ff
	dc.b	$00,'?',$00,'_',$00,'`',$00,$7f
	dc.b	'w',$ff,'q',$ff,$86,$00,$f7,$ff
	dc.b	'{',$c0,'s',$f0,$0c,'p',$7f,$f0
	dc.b	$01,$ef,$07,$e7,$07,$18,$07,$ff
	dcb.w	4
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dcb.w	16
	dc.b	$7f,$ff,$7f,$ff,$00,$00,$7f,$ff
	dc.b	$ff,$f8,$ff,$f8,$00,$00,$ff,$f8
	dc.b	$00,'?',$00,'?',$00,$00,$00,'?'
	dc.b	$c8,$00,$c8,$00,'0',$00,$f8,$00
	dcb.w	4
	dc.b	$0f,'?',$0f,'?',$08,$c0,$0f,$ff
	dc.b	$e1,$fe,$e1,$fe,$1e,$01,$ff,$ff
	dc.b	$c0,$01,$c0,$01,$00,$00,$c0,$01
	dc.b	$c3,$c0,$c3,$c0,'<',$00,$ff,$c0
	dc.b	$03,$8f,$03,$8f,$04,'p',$07,$ff
	dc.b	$00,$7f,$00,$7f,$00,$00,$00,$7f
	dc.b	$97,$0f,$97,$0f,'`',$f0,$f7,$ff
	dc.b	'x',$f0,'@',$f0,'?',$10,$7f,$f0
	dc.b	$07,$8f,$07,$81,$04,'~',$07,$ff
	dcb.w	40
	dc.b	$00,$03,$00,$03,$00,$00,$00,$03
	dc.b	']@>@',$ff,$80,$ff,$c0
	dcb.w	76
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dcb.w	77
	dc.b	$08,$00,$08,$00,$08,$00,$00,$00
	dcb.w	75
	dc.b	$08,$00,$00,$00,$08,$00,$08,$00
	dcb.w	76
	dc.b	$08,$00,$00,$00,$08,$00,$08,$00
	dcb.w	78
	dc.b	$08,$00,$08,$00,$00,$00,$00,$00
	dcb.w	59
	dc.b	$00,$07,$00,$07,$00,$07,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$02,$00
	dc.b	$fc,'?',$ff,'?',$ff,'?',$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$10,$00
	dc.b	$e0,$00,$f8,$00,$f8,$00,$00,$00
	dcb.w	59
	dc.b	$00,$0f,$00,$08,$00,$07,$00,$0f
	dc.b	$83,$df,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$f4,'x',$08,'@',$fe,'?',$fe,$7f
	dc.b	'!',$ff,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$a0,'?@?',$f0,'?',$f0,'?'
	dc.b	$1e,$00,$1e,$00,$1e,$00,$1e,$00
	dc.b	$1e,'3',$1e,'3',$1e,'3',$1e,'3'
	dc.b	$1e,'3',$1e,'3',$1e,'3',$1e,'3'
	dc.b	$1f,'?',$1f,'?',$1f,'?',$1f,'?'
	dc.b	$00,$1f,$00,$1f,$00,$1f,$00,$1f
	dc.b	'>?>?>?>?'
	dc.b	'?>?>?>?>'
	dcb.w	32
	dc.b	$00,$1f,$00,$10,$00,$0f,$00,$1f
	dc.b	$01,$8f,$80,$00,$83,$df,$83,$df
	dc.b	$e8,$f0,$10,$88,$fc,'x',$fc,$f8
	dc.b	$00,$ff,$00,$00,'!',$ff,'!',$ff
	dc.b	'@',$00,$80,'-',$e0,'-',$e0,'-'
	dc.b	$00,$00,'?',$00,'?',$00,'?',$00
	dc.b	$00,$00,'?3?3?3'
	dc.b	$00,$00,'?;?;?;'
	dc.b	$00,$00,'??????'
	dc.b	$00,$00,$00,';',$00,';',$00,';'
	dc.b	$00,$00,'??????'
	dc.b	$00,$00,'??????'
	dcb.w	32
	dc.b	$00,'?',$00,' ',$00,$1f,$00,'?'
	dc.b	$03,$0f,$bc,$80,$bf,$9f,$bf,$9f
	dc.b	$d1,$f0,'!',$0b,$f8,$fb,$f9,$fb
	dc.b	' ~',$de,$01,$fe,$ff,$fe,$ff
	dc.b	$80,$0c,$00,$00,$c0,$0c,$c0,$0c
	dc.b	'3',$00,$00,$00,'3',$00,'3',$00
	dc.b	'33',$00,$00,'3333'
	dc.b	'3?',$00,$00,'3?3?'
	dc.b	'08',$00,$00,'0808'
	dc.b	$00,'8',$00,$00,$00,'8',$00,'8'
	dc.b	'38',$00,$00,'3838'
	dc.b	'83',$00,$00,'8383'
	dcb.w	32
	dc.b	$00,$7f,$00,'@',$00,'?',$00,$7f
	dc.b	$03,$8f,$80,'@',$87,$df,$87,$df
	dc.b	$a3,$f0,'B',$08,$f1,$f8,$f3,$f8
	dc.b	' ',$fd,$11,$02,'q',$ff,'q',$ff
	dc.b	$00,$0c,$00,$00,$80,$0c,$80,$0c
	dc.b	'3',$00,$00,$00,'3',$00,'3',$00
	dc.b	'0?',$00,$00,'0?0?'
	dc.b	'??',$00,$00,'????'
	dc.b	'7>',$00,$00,'7>7>'
	dc.b	$00,$1e,$00,$00,$00,$1e,$00,$1e
	dc.b	'?>',$00,$00,'?>?>'
	dc.b	'>3',$00,$00,'>3>3'
	dcb.w	32
	dc.b	$00,$ff,$00,$80,$00,$7f,$00,$ff
	dc.b	$07,$8f,$b8,'@',$bf,$df,$bf,$df
	dc.b	'G',$f0,$84,$0b,$e3,$fb,$e7,$fb
	dc.b	'@',$fa,$a0,$04,$ef,$ff,$ef,$ff
	dcb.w	2
	dc.b	$00,$0c,$00,$0c,$00,$00,$00,$00
	dc.b	'3',$00,'3',$00,$00,$00,$00,$00
	dc.b	'3?3?',$00,$00,$00,$00
	dc.b	'?7?7',$00,$00,$00,$00
	dc.b	'3838',$00,$00,$00,$00
	dc.b	$00,$07,$00,$07,$00,$00,$00,$00
	dc.b	'>8>8',$00,$00,$00,$00
	dc.b	'8383',$00,$00,$00,$00
	dcb.w	30
	dc.b	$01,$ff,$01,$00,$00,$ff,$01,$ff
	dc.b	$1f,$8e,$a0,'A',$bf,$df,$bf,$df
	dc.b	$8f,$f1,$08,$0a,$c7,$fb,$cf,$fb
	dc.b	$c0,'t ',$08,$e0,$fe,$e0,$fe
	dcb.w	2
	dc.b	$00,$0c,$00,$0c,$00,$00,$00,$00
	dc.b	'?',$00,'?',$00,$00,$00,$00,$00
	dc.b	'?3?3',$00,$00,$00,$00
	dc.b	'3333',$00,$00,$00,$00
	dc.b	'????',$00,$00,$00,$00
	dc.b	$00,'7',$00,'7',$00,$00,$00,$00
	dc.b	'0?0?',$00,$00,$00,$00
	dc.b	'????',$00,$00,$00,$00
	dc.b	'6',$c0,'6',$c0,$00,$00,$00,$00
	dcb.w	26
	dc.b	$03,$ff,$02,$00,$01,$ff,$03,$ff
	dc.b	$bf,$dd,'@"',$ff,$ff,$ff,$ff
	dc.b	$1f,$fb,$10,$04,$8f,$ff,$9f,$ff
	dc.b	$e0,$e8,$1f,$10,$ff,$fc,$ff,$fc
	dc.b	$00,$1e,$00,$1e,$00,$00,$00,$1e
	dc.b	$1e,$00,$1e,$00,$00,$00,$1e,$00
	dc.b	$1e,'3',$1e,'3',$00,$00,$1e,'3'
	dc.b	'3333',$00,$00,'33'
	dc.b	$1e,'?',$1e,'?',$00,$00,$1e,'?'
	dc.b	$00,'>',$00,'>',$00,$00,$00,'>'
	dc.b	'0?0?',$00,$00,'0?'
	dc.b	'?>?>',$00,$00,'?>'
	dc.b	'6',$c0,'6',$c0,$00,$00,'6',$c0
	dcb.w	28
	dc.b	$04,$00,$04,$00,$03,$ff,$07,$ff
	dc.b	$00,$02,$00,$00,$ff,$ff,$ff,$ff
	dc.b	' ',$00,' ',$00,$1f,$ff,'?',$ff
	dc.b	$00,$10,$00,$00,$ff,$f8,$ff,$f8
	dcb.w	64
	dc.b	$0f,$ff,$0f,$ff,$00,$00,$0f,$ff
	dc.b	$ff,$fc,$ff,$fc,$00,$02,$ff,$fe
	dc.b	$7f,$ff,$7f,$ff,$00,$00,$7f,$ff
	dc.b	$ff,$e0,$ff,$e0,$00,$10,$ff,$f0
	dcb.w	141
	dc.b	$07,$ff,$07,$ff,$07,$ff,$00,$02
	dc.b	$ff,$fc,$ff,$ff,$ff,$ff,$00,$00
	dcb.w	4
	dc.b	$00,$03,$00,$03,$00,$03,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$01,$00
	dc.b	$fe,$00,$ff,$80,$ff,$80,$00,$00
	dcb.w	55
	dc.b	$0f,$82,$08,$00,$07,$ff,$0f,$ff
	dc.b	$1f,$f4,$00,$08,$ff,$fe,$ff,$fe
	dcb.w	4
	dc.b	$00,$07,$00,$04,$00,$03,$00,$07
	dc.b	$c1,$8f,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$fa,$00,$04,$00,$ff,$00,$ff,$00
	dcb.w	56
	dc.b	$1f,$00,$10,$80,$0f,$82,$1f,$82
	dc.b	$0f,$e8,$00,$10,$1f,$fc,$1f,$fc
	dc.b	$1f,$8f,$1f,$8f,$1f,$8f,$1f,$8f
	dc.b	$00,$0f,$00,$08,$00,$07,$00,$0f
	dc.b	$80,$07,'@',$80,$c1,$8f,$c1,$8f
	dc.b	$f4,$03,$08,$03,$fe,$03,$fe,$03
	dc.b	$f1,$e0,$f1,$e0,$f1,$e0,$f1,$e0
	dc.b	$01,$e3,$01,$e3,$01,$e3,$01,$e3
	dc.b	'1',$e3,'1',$e3,'1',$e3,'1',$e3
	dc.b	'1',$f3,'1',$f3,'1',$f3,'1',$f3
	dc.b	$f0,$01,$f0,$01,$f0,$01,$f0,$01
	dc.b	$f3,$e3,$f3,$e3,$f3,$e3,$f3,$e3
	dc.b	$e1,$e3,$e1,$e3,$e1,$e3,$e1,$e3
	dc.b	$f3,$f1,$f3,$f1,$f3,$f1,$f3,$f1
	dc.b	$f0,$00,$f0,$00,$f0,$00,$f0,$00
	dcb.w	20
	dc.b	'?',$02,' ',$bd,$1f,$bf,'?',$bf
	dc.b	$07,$d0,$e0,' ',$ef,$f8,$ef,$f8
	dc.b	$00,$00,$16,$9f,$16,$9f,$16,$9f
	dc.b	$00,$1f,$80,$10,$80,$0f,$80,$1f
	dc.b	$80,$03,'^p',$df,'w',$df,'w'
	dc.b	$e8,$00,$10,$02,$fc,$02,$fc,$02
	dc.b	$00,$00,$d3,$f0,$d3,$f0,$d3,$f0
	dc.b	$00,$00,$03,$f3,$03,$f3,$03,$f3
	dc.b	$00,$00,'3',$f3,'3',$f3,'3',$f3
	dc.b	$00,$00,$b3,$f3,$b3,$f3,$b3,$f3
	dc.b	$00,$00,$f0,$03,$f0,$03,$f0,$03
	dc.b	$00,$00,$b3,$f3,$b3,$f3,$b3,$f3
	dc.b	$00,$00,$f0,$c2,$f0,$c2,$f0,$c2
	dc.b	$00,$00,$d3,$f3,$d3,$f3,$d3,$f3
	dc.b	$00,$00,$b0,$00,$b0,$00,$b0,$00
	dcb.w	20
	dc.b	$7f,$02,'@?',$87,$7f,$87
	dc.b	$0f,$a0,$10,'@',$1f,$f0,$1f,$f0
	dc.b	$06,$19,$00,$00,$06,$19,$06,$19
	dc.b	$80,'?',$00,' ',$80,$1f,$80,'?'
	dc.b	$81,$03,'@',$80,$c3,$87,$c3,$87
	dc.b	$d0,$00,' ',$00,$f8,$00,$f8,$00
	dc.b	$c3,'0',$00,$00,$c3,'0',$c3,'0'
	dc.b	$03,'3',$00,$00,$03,'3',$03,'3'
	dc.b	'33',$00,$00,'3333'
	dc.b	$f3,$03,$00,$00,$f3,$03,$f3,$03
	dc.b	$80,$03,$00,$00,$80,$03,$80,$03
	dc.b	$83,'3',$00,$00,$83,'3',$83,'3'
	dc.b	'0',$c0,$00,$00,'0',$c0,'0',$c0
	dc.b	$c3,$83,$00,$00,$c3,$83,$c3,$83
	dc.b	$80,$00,$00,$00,$80,$00,$80,$00
	dcb.w	20
	dc.b	$ff,$06,$80,$b9,$7f,$bf,$ff,$bf
	dc.b	$07,'@',$e0,$80,$ef,$e0,$ef,$e0
	dc.b	$06,$19,$00,$00,$06,$19,$06,$19
	dc.b	$80,$7f,$00,'@',$80,'?',$80,$7f
	dc.b	$83,$83,'\p',$df,$f7,$df,$f7
	dc.b	$a0,$00,'@',$00,$f0,$00,$f0,$00
	dc.b	$c3,'0',$00,$00,$c3,'0',$c3,'0'
	dc.b	$03,$03,$00,$00,$03,$03,$03,$03
	dc.b	$f3,$f3,$00,$00,$f3,$f3,$f3,$f3
	dc.b	$f3,'s',$00,$00,$f3,'s',$f3,'s'
	dc.b	$e0,$01,$00,$00,$e0,$01,$e0,$01
	dc.b	$e3,$f3,$00,$00,$e3,$f3,$e3,$f3
	dc.b	$f0,$c0,$00,$00,$f0,$c0,$f0,$c0
	dc.b	$c3,$e1,$00,$00,$c3,$e1,$c3,$e1
	dc.b	$e0,$00,$00,$00,$e0,$00,$e0,$00
	dcb.w	12
	dc.b	$00,$08,$00,$08,$00,$08,$00,$08
	dc.b	$00,$01,$00,$01,$00,$00,$00,$01
	dc.b	$ff,$1c,$00,$a2,$ff,$be,$ff,$be
	dc.b	$0e,$80,$11,$00,$1f,$c0,$1f,$c0
	dcb.w	2
	dc.b	$06,$19,$06,$19,$00,$ff,$00,$80
	dc.b	$80,$7f,$80,$ff,$8f,$07,'P',$88
	dc.b	$df,$8f,$df,$8f,'@',$00,$80,$00
	dc.b	$e0,$00,$e0,$00,$00,$00,$00,$00
	dc.b	$c3,'0',$c3,'0',$00,$00,$00,$00
	dc.b	$03,'3',$03,'3',$00,$00,$00,$00
	dc.b	$f3,$f3,$f3,$f3,$00,$00,$00,$00
	dc.b	's3s3',$00,$00,$00,$00
	dc.b	$80,$00,$80,$00,$00,$00,$00,$00
	dc.b	's',$e3,'s',$e3,$00,$00,$00,$00
	dc.b	$e0,$c0,$e0,$c0,$00,$00,$00,$00
	dc.b	$c3,$80,$c3,$80,$00,$00,$00,$00
	dc.b	'p',$00,'p',$00,$00,$00,$00,$00
	dcb.w	14
	dc.b	$00,$03,$00,$02,$00,$01,$00,$03
	dc.b	$ff,$be,$00,'A',$ff,$ff,$ff,$ff
	dc.b	$1d,$00,$e2,$00,$ff,$80,$ff,$80
	dcb.w	2
	dc.b	$06,$1f,$06,$1f,$01,$ff,$01,$00
	dc.b	$80,$ff,$81,$ff,$df,'Ž q'
	dc.b	$ff,$ff,$ff,$ff,$80,$00,$00,$00
	dc.b	$c0,$00,$c0,$00,$00,$00,$00,$00
	dc.b	$c3,$f0,$c3,$f0,$00,$00,$00,$00
	dc.b	$03,$f3,$03,$f3,$00,$00,$00,$00
	dc.b	'3333',$00,$00,$00,$00
	dc.b	'3',$f3,'3',$f3,$00,$00,$00,$00
	dc.b	$f0,$03,$f0,$03,$00,$00,$00,$00
	dc.b	's',$03,'s',$03,$00,$00,$00,$00
	dc.b	'`',$c0,'`',$c0,$00,$00,$00,$00
	dc.b	$c3,$f3,$c3,$f3,$00,$00,$00,$00
	dc.b	'q',$b6,'q',$b6,$00,$00,$00,$00
	dcb.w	14
	dc.b	$04,$04,$04,$04,$04,$03,$04,$07
	dcb.w	2
	dc.b	$ff,$ff,$ff,$ff,$02,$00,$00,$00
	dc.b	$ff,$00,$ff,$00,$0f,$0f,$0f,$0f
	dc.b	$00,$00,$0f,$0f,$02,$00,$02,$00
	dc.b	$01,$ff,$03,$ff,$00,$01,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$01,$00,$01
	dc.b	$80,$00,$80,$01,$e1,$e0,$e1,$e0
	dc.b	$00,$00,$e1,$e0,$01,$e3,$01,$e3
	dc.b	$00,$00,$01,$e3,'3333'
	dc.b	$00,$00,'331',$e3,'1',$e3
	dc.b	$00,$00,'1',$e3,$f0,$03,$f0,$03
	dc.b	$00,$00,$f0,$03,$e3,$03,$e3,$03
	dc.b	$00,$00,$e3,$03,'1',$e1,'1',$e1
	dc.b	$00,$00,'1',$e1,$e3,$f3,$e3,$f3
	dc.b	$00,$00,$e3,$f3,$e1,$b6,$e1,$b6
	dc.b	$00,$00,$e1,$b6,$00,$00,$00,$00
	dcb.w	14
	dc.b	$00,$0f,$00,$0f,$00,$00,$00,$0f
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$ff,$ff
	dc.b	$fc,$00,$fc,$00,$02,$00,$fe,$00
	dcb.w	4
	dc.b	$07,$ff,$07,$ff,$00,$00,$07,$ff
	dc.b	$ff,$fe,$ff,$fe,$00,$01,$ff,$ff
	dcb.w	368
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dcb.w	3
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
	dcb.w	4
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$e0,$c0,$00,$00,$00,$00,$00,$00
	dc.b	'p',$e0,$00,$00,$00,$00,$00,$00
	dc.b	$7f,$e0,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$c0,$00,$00,$00,$00,$00,$00
	dc.b	$c0,$e0,$00,$00,$00,$00,$00,$00
	dc.b	$c4,'@',$00,$00,$00,$00,$00,$00
	dc.b	$c0,'p',$00,$00,$00,$00,$00,$00
	dc.b	$ff,$e3,$00,$00,$00,$00,$00,$00
	dc.b	$e0,$c4,$00,$00,$00,$00,$00,$00
	dc.b	'@`',$00,$00,$00,$00,$00,$00
	dc.b	$7f,$e0,$00,$00,$00,$00,$00,$00
	dc.b	'`@',$00,$00,$00,$00,$00,$00
	dc.b	$c0,'@',$00,$00,$00,$00,$00,$00
	dc.b	'DG',$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$0e,$1f,$0e,$1f
	dc.b	$e0,$c0,$00,$00,$06,$0f,$06,$0f
	dc.b	'p',$c0,$00,$00,$00,$0e,$00,$0e
	dc.b	$7f,$c0,$00,$00,$00,$1e,$00,$1e
	dc.b	$7f,$c0,$00,$00,$1e,$0e,$1e,$0e
	dc.b	'@@',$00,$00,$11,$1e,$11,$1e
	dc.b	'@@',$00,$00,$1f,$06,$1f,$06
	dc.b	'@`',$00,$00,$00,$08,$00,$08
	dc.b	$ff,$e3,$00,$00,$0e,$11,$0e,$11
	dc.b	$e0,$c0,$00,$00,$1f,$0f,$1f,$0f
	dc.b	'@@',$00,$00,$00,$0f,$00,$0f
	dc.b	$7f,$c0,$00,$00,$0f,$1e,$0f,$1e
	dc.b	'@@',$00,$00,$1f,$1f,$1f,$1f
	dc.b	'@@',$00,$00,$11,$10,$11,$10
	dc.b	'@G',$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$e4,$c4,$00,$00,$04,$04
	dc.b	$e0,$c0,'f',$d0,$00,$00,$06,$10
	dc.b	'`',$c0,$7f,$d1,$00,$00,$00,$11
	dc.b	$7f,$c0,$7f,$c1,$00,$00,$00,$01
	dc.b	$7f,$c0,'AS',$00,$00,$01,$13
	dc.b	'@@JA',$00,$00,$0a,$01
	dc.b	'@@AJ',$00,$00,$01,$0a
	dc.b	'@@',$ff,$eb,$00,$00,$00,$08
	dc.b	$ff,$e3,$e4,$d9,$00,$00,$04,$19
	dc.b	$e0,$c0,'PP',$00,$00,$10,$10
	dc.b	'@@',$7f,$d0,$00,$00,$00,$10
	dc.b	$7f,$c0,'PQ',$00,$00,$10,$11
	dc.b	'@@PP',$00,$00,$10,$10
	dc.b	'@@YW',$00,$00,$19,$10
	dc.b	'@G',$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$04,$04
	dc.b	$f1,$f1,$00,$00,$00,$00,$0c,$0e
	dc.b	$e0,$c0,$00,$00,$00,$00,$00,$1f
	dc.b	$7f,$c0,$00,$00,$00,$00,$00,$0e
	dc.b	$7f,$e0,$00,$00,$00,$00,$0e,$15
	dc.b	'@@',$00,$00,$00,$00,$04,$0e
	dc.b	'`',$c0,$00,$00,$00,$00,$02,$12
	dc.b	'p@',$00,$00,$00,$00,$00,$08
	dc.b	$7f,$e3,$00,$00,$00,$00,$04,$15
	dc.b	$f1,$c0,$00,$00,$00,$00,$1e,$0e
	dc.b	'@',$c0,$00,$00,$00,$00,$00,$0e
	dc.b	$7f,$c0,$00,$00,$00,$00,$10,$1e
	dc.b	'G',$c0,$00,$00,$00,$00,$1e,$1e
	dc.b	'@',$c0,$00,$00,$00,$00,$15,$10
	dc.b	$c0,'G',$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$e0,$f1,$00,$00,$04,$04
	dc.b	$e0,$f1,$e1,$c0,$00,$00,$00,$01
	dc.b	$e1,$c0,$7f,$c0,$00,$00,$00,$11
	dc.b	$7f,$c0,$7f,$c0,$00,$00,$00,$01
	dc.b	$7f,$c0,'@@',$00,$00,$10,$19
	dc.b	'@@@@',$00,$00,$0a,$10
	dc.b	'@@p',$c0,$00,$00,$04,$1f
	dc.b	'p',$c0,$7f,$e0,$00,$00,$00,$08
	dc.b	$7f,$e0,'`',$c0,$00,$00,$04,$13
	dc.b	'`',$c0,'@@',$00,$00,$10,$01
	dc.b	'@@',$7f,$c0,$00,$00,$00,$01
	dc.b	$7f,$c0,'@@',$00,$00,$10,$14
	dc.b	'@@@@',$00,$00,$10,$10
	dc.b	'@@@G',$00,$00,$13,$00
	dc.b	'@G',$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ee,$f5,$0e,$04,$00,$00
	dc.b	$e0,$f1,$ff,$de,$00,$1e,$00,$00
	dc.b	$ff,$c0,$7f,$d5,$00,$11,$00,$00
	dc.b	$7f,$c4,$7f,$de,$00,$1e,$00,$00
	dc.b	$7f,$c0,'_N',$1f,$0e,$00,$00
	dc.b	'@@Q_',$11,$1f,$00,$00
	dc.b	'@@u',$c2,$04,$02,$00,$00
	dc.b	'q',$c0,$7f,$ef,$00,$0f,$00,$00
	dc.b	$7f,$e0,'n',$d1,$0e,$11,$00,$00
	dc.b	'`',$c0,'_^',$1f,$1e,$00,$00
	dc.b	'@@',$7f,$de,$00,$1e,$00,$00
	dc.b	$7f,$c0,'OS',$0f,$13,$00,$00
	dc.b	'@@__',$1f,$1f,$00,$00
	dc.b	'@@QW',$11,$10,$00,$00
	dc.b	'@G',$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$e0,$f1,$00,$00
	dc.b	$e0,$f1,$00,$00,$ff,$c0,$00,$00
	dc.b	$ff,$c0,$00,$00,$ff,$c4,$00,$00
	dc.b	$ff,$c4,$00,$00,$7f,$c0,$00,$00
	dc.b	$7f,$c0,$00,$00,$c0,'`',$00,$00
	dc.b	$c0,'`',$00,$00,$c4,'@',$00,$00
	dc.b	$c4,'@',$00,$00,'q',$f8,$00,$00
	dc.b	'q',$f8,$00,$00,$ff,$e0,$00,$00
	dc.b	$ff,$e0,$00,$00,'`',$c4,$00,$00
	dc.b	'`',$c4,$00,$00,'@@',$00,$00
	dc.b	'@@',$00,$00,$ff,$c0,$00,$00
	dc.b	$ff,$c0,$00,$00,$e0,'@',$00,$00
	dc.b	$e0,'@',$00,$00,'@@',$00,$00
	dc.b	'@@',$00,$00,'DG',$00,$00
	dc.b	'DG',$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff
	ori.b	#$ff,d0
l0041	bra.s	l0043
	bra	l004c
l0042	dc.b	'`',$00,$01,'DCoun'
	dc.b	't Zero M'
	dc.b	'usic Dri'
	dc.b	'ver 19/4'
	dc.b	'/89.01-7'
	dc.b	'94-0771.'
l0043	movem.l	a0-a6/d0-d7,-(a7)
	tst.l	d0
	bgt.s	l0044
	bsr	l0046
	lea	l00a2(pc),a0
	clr.w	(a0)
	movem.l	(a7)+,a0-a6/d0-d7
	rts

l0044	cmpi.l	#1,d0
	bhi.s	l0045
	lea	l00a2(pc),a0
	move.w	d0,(a0)
	bsr	l0046
	bsr	l0048
l0045	movem.l	(a7)+,a0-a6/d0-d7
	rts

l0046	move.b	#7,$ffff8800.w
	move.b	$ffff8802.w,d1
	andi.b	#$c0,d1
	moveq	#$d,d0
l0047	move.b	d0,$ffff8800.w
	move.b	#0,$ffff8802.w
	dbf	d0,l0047
	move.b	#7,$ffff8800.w
	move.b	d1,$ffff8802.w
	rts

l0048	lea	l00a3(pc),a1
	lea	l00a4(pc),a2
	lea	l00a5(pc),a3
	moveq	#$58,d0
	lsr.w	#1,d0
	subq.w	#1,d0
l0049	clr.w	(a1)+
	clr.w	(a2)+
	clr.w	(a3)+
	dbf	d0,l0049
	lea	l00a2(pc),a0
	move.w	(a0),d7
	subq.w	#1,d7
	lsl.w	#3,d7
	lea	l00a7(pc),a0
	adda.w	d7,a0
	lea	l00a3(pc),a1
	bsr.s	l004a
	lea	l00a7(pc),a0
	adda.w	d7,a0
	addq.l	#2,a0
	lea	l00a4(pc),a1
	bsr.s	l004a
	lea	l00a7(pc),a0
	adda.w	d7,a0
	addq.l	#4,a0
	lea	l00a5(pc),a1
	bsr.s	l004a
	bra.s	l004b
l004a	moveq	#0,d0
	move.w	(a0),d0
	lea	l00aa(pc),a0
	adda.w	d0,a0
	move.l	a0,(a1)
	clr.w	4(a1)
	move.l	(a0),d0
	move.w	d0,24(a1)
	swap	d0
	lea	l00ab(pc),a0
	adda.w	d0,a0
	move.l	a0,6(a1)
	move.w	#$fffe,10(a1)
	lea	l00ad(pc),a0
	move.l	a0,12(a1)
	rts

l004b	lea	l00a7(pc),a0
	adda.w	d7,a0
	addq.l	#6,a0
	lea	l00a6(pc),a1
	moveq	#0,d0
	move.w	(a0),d0
	lea	l00aa(pc),a0
	adda.w	d0,a0
	move.l	a0,(a1)
	clr.w	4(a1)
	move.l	(a0),d0
	move.w	d0,12(a1)
	swap	d0
	lea	l00ab(pc),a0
	adda.w	d0,a0
	move.l	a0,6(a1)
	move.w	#$fffe,10(a1)
	rts

	movem.l	a0-a6/d0-d7,-(a7)
	bsr.s	l004c
	movem.l	(a7)+,a0-a6/d0-d7
	rts

l004c	lea	l00a2(pc),a0
	tst.w	(a0)
	beq.s	l004d
	bsr	l004e
	lea	l00a3(pc),a6
	bsr	l0051
	lea	l00a4(pc),a6
	bsr	l0051
	lea	l00a5(pc),a6
	bsr	l0051
	bsr	l0088
	bsr	l0090
l004d	rts

l004e	lea	l004f(pc),a0
	lea	$ffff8800.w,a1
	lea	$ffff8802.w,a2
	lea	l00a2(pc),a3
	move.b	#7,(a1)
	move.b	(a2),d1
	move.b	46(a0),d2
	andi.w	#$3f,d2
	andi.w	#$c0,d1
	or.b	d1,d2
	move.b	d2,46(a0)
l004f	move.l	#0,(a1)
	move.l	#$1000000,(a1)
	move.l	#$2000000,(a1)
	move.l	#$3000000,(a1)
	move.l	#$4000000,(a1)
	move.l	#$5000000,(a1)
	move.l	#$6000000,(a1)
	move.l	#$7000000,(a1)
	move.l	#$8000000,(a1)
	move.l	#$9000000,(a1)
	move.l	#$a000000,(a1)
	move.l	#$b000000,(a1)
	move.l	#$c000000,(a1)
	move.l	#$d000000,d0
	tst.w	2(a3)
	beq.s	l0050
	move.l	d0,(a1)
	clr.w	2(a3)
l0050	rts

l0051	tst.w	18(a6)
	ble.s	l0052
	subq.w	#1,18(a6)
	clr.w	52(a6)
	rts

l0052	tst.w	20(a6)
	ble.s	l0053
	subq.w	#1,20(a6)
	bra	l0075
l0053	move.w	10(a6),d2
	addq.w	#2,d2
	move.w	d2,10(a6)
	movea.l	6(a6),a0
	moveq	#0,d0
	moveq	#0,d1
	move.b	1(a0,d2.w),d1
	move.b	0(a0,d2.w),d0
	bne.s	l0057
l0054	move.w	#$fffe,10(a6)
	tst.w	24(a6)
	ble.s	l0055
	subq.w	#1,24(a6)
	bra.s	l0053
l0055	move.w	4(a6),d0
	addq.w	#4,d0
	move.w	d0,4(a6)
	movea.l	(a6),a0
	move.l	0(a0,d0.w),d0
	bne.s	l0056
	move.w	#$fffc,4(a6)
	bra.s	l0054
l0056	move.w	d0,24(a6)
	swap	d0
	lea	l00ab(pc),a0
	adda.w	d0,a0
	move.l	a0,6(a6)
	bra.s	l0053
l0057	cmpi.w	#$60,d0
	ble	l006a
	cmpi.w	#$e0,d0
	ble	l006e
	andi.w	#$f,d0
	add.w	d0,d0
	add.w	d0,d0
	lea	l0058(pc),a0
	jmp	0(a0,d0.w)
l0058	bra	l0059
	bra	l005a
	bra	l005b
	bra	l005c
	bra	l005d
	bra	l005e
	bra	l005f
	bra	l0060
	bra	l0061
	bra	l0062
	bra	l0064
	bra	l0065
	bra	l0066
	bra	l0067
	bra	l0068
	bra	l0069
	bra	l0053
l0059	subq.w	#1,d1
	move.w	d1,20(a6)
	clr.w	80(a6)
	rts

l005a	subq.w	#1,d1
	move.w	d1,18(a6)
	rts

l005b	move.w	d1,50(a6)
	bra	l0053
l005c	add.w	d1,d1
	lea	l00a9(pc),a0
	move.w	0(a0,d1.w),d0
	lea	l00ac(pc),a0
	adda.w	d0,a0
	move.l	a0,12(a6)
	move.w	#$fffa,16(a6)
	bra	l0053
l005d	move.w	d1,56(a6)
	bra	l0053
l005e	move.w	d1,54(a6)
	bra	l0053
l005f	ext.w	d1
	move.w	d1,42(a6)
	bra	l0053
l0060	ext.w	d1
	move.w	d1,44(a6)
	bra	l0053
l0061	ext.w	d1
	move.w	d1,46(a6)
	bra	l0053
l0062	move.w	d1,62(a6)
	bne.s	l0063
	moveq	#0,d0
	move.l	d0,60(a6)
	move.l	d0,64(a6)
	move.w	d0,68(a6)
	lea	l00a2(pc),a0
	move.b	#0,82(a6)
l0063	lea	l00a2(pc),a0
	addq.w	#1,2(a0)
	bra	l0053
l0064	move.w	d1,60(a6)
	lea	l00a2(pc),a0
	addq.w	#1,2(a0)
	bra	l0053
l0065	ext.w	d1
	move.w	d1,86(a6)
	bra	l0053
l0066	move.w	d1,68(a6)
	bra	l0053
l0067	lsl.w	#3,d1
	lea	l00a8(pc),a0
	movem.w	0(a0,d1.w),d2-d4
	movem.w	d2-d4,42(a6)
	bra	l0053
l0068	ext.w	d1
	move.w	d1,40(a6)
	bra	l0053
l0069	ext.w	d1
	move.w	d1,38(a6)
	bra	l0053
l006a	move.w	#0,80(a6)
	move.w	#$ffff,70(a6)
	move.w	#0,66(a6)
	tst.w	56(a6)
	beq.s	l006b
	move.w	56(a6),d2
	subq.w	#1,d2
	move.w	d2,58(a6)
l006b	move.w	50(a6),52(a6)
	move.w	#$fffa,16(a6)
	move.w	d1,20(a6)
	move.w	d0,26(a6)
	move.w	38(a6),d1
	add.w	d1,d0
	subq.w	#1,d0
	move.w	d0,d5
	move.w	d0,d6
	move.w	d0,d7
	movem.w	42(a6),d2-d4
	add.w	d2,d5
	add.w	d3,d6
	add.w	d4,d7
	add.w	d0,d0
	add.w	d5,d5
	add.w	d6,d6
	add.w	d7,d7
	lea	l00a0(pc),a0
	move.w	0(a0,d0.w),d0
	move.w	0(a0,d5.w),d5
	move.w	0(a0,d6.w),d6
	move.w	0(a0,d7.w),d7
	move.w	40(a6),d1
	add.w	d1,d0
	movem.w	d5-d7/d0,30(a6)
	tst.w	62(a6)
	beq.s	l006d
	tst.w	68(a6)
	ble.s	l006c
	move.w	68(a6),d0
	subq.w	#1,d0
	move.w	d0,64(a6)
	bra.s	l006d
l006c	move.w	60(a6),d0
	subq.w	#1,d0
	move.w	38(a6),d1
	add.w	d1,d0
	add.w	d0,d0
	lea	l00a1(pc),a0
	move.w	0(a0,d0.w),64(a6)
l006d	subq.w	#1,20(a6)
	bra	l0075
l006e	move.w	#1,80(a6)
	move.w	d1,20(a6)
	sub.w	86(a6),d1
	move.w	26(a6),d7
	subi.w	#$80,d0
	move.w	d0,26(a6)
	move.w	d0,d6
	move.w	d7,d2
	sub.w	d2,d0
	move.w	d0,d5
	move.w	d6,d0
	subq.w	#1,d0
	subq.w	#1,d2
	add.w	d0,d0
	add.w	d2,d2
	lea	l00a0(pc),a0
	moveq	#0,d3
	moveq	#0,d4
	move.w	0(a0,d0.w),d3
	move.w	0(a0,d2.w),d4
	sub.w	d4,d3
	bgt.s	l006f
	neg.w	d3
l006f	divu	d1,d3
	ble.s	l0071
	tst.w	d5
	ble.s	l0070
	neg.w	d3
l0070	move.w	d3,82(a6)
	clr.w	22(a6)
	move.w	20(a6),d1
	bra.s	l0074
l0071	swap	d3
	move.w	20(a6),d1
	divu	d3,d1
	tst.w	d5
	ble.s	l0072
	move.w	#$ffff,82(a6)
	bra.s	l0073
l0072	move.w	#1,82(a6)
l0073	move.w	d1,84(a6)
	move.w	20(a6),d1
l0074	subq.w	#1,d1
	move.w	d1,20(a6)
l0075	tst.w	70(a6)
	ble.s	l0076
	subq.w	#1,70(a6)
	movem.w	72(a6),d1-d4
	bra	l0078
l0076	move.w	16(a6),d5
	addq.w	#6,d5
	move.w	d5,16(a6)
	movea.l	12(a6),a0
	adda.w	d5,a0
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	move.b	5(a0),d0
	move.b	4(a0),d1
	move.b	3(a0),d2
	move.b	2(a0),d3
	move.w	(a0),d4
	cmpi.w	#$ff,d0
	bne.s	l0077
	addq.w	#6,d1
	sub.w	d1,16(a6)
	bra.s	l0075
l0077	ext.w	d1
	ext.w	d2
	ext.w	d3
	move.w	d0,d5
	andi.w	#3,d0
	move.w	d0,88(a6)
	lsr.w	#2,d5
	move.w	d5,d0
	andi.w	#3,d5
	move.w	d5,48(a6)
	lsr.w	#2,d0
	move.w	d0,d5
	andi.w	#3,d0
	move.w	d0,66(a6)
	lsr.w	#2,d5
	andi.w	#3,d5
	beq.s	l0078
	move.w	d5,70(a6)
	movem.w	d1-d4,72(a6)
l0078	tst.w	d1
	beq.s	l007b
	move.w	52(a6),d5
	add.w	d1,d5
	bpl.s	l0079
	moveq	#0,d5
	bra.s	l007a
l0079	cmpi.w	#$f,d5
	ble.s	l007a
	moveq	#$f,d5
l007a	move.w	d5,52(a6)
l007b	tst.w	56(a6)
	beq.s	l007f
	tst.w	d2
	beq.s	l007e
	move.w	58(a6),d5
	add.w	d2,d5
	bpl.s	l007c
	moveq	#0,d5
	bra.s	l007d
l007c	cmpi.w	#$1f,d5
	ble.s	l007d
	moveq	#$1f,d5
l007d	move.w	d5,58(a6)
l007e	lea	l00a6(pc),a1
	move.w	58(a6),16(a1)
l007f	tst.w	d3
	beq.s	l0082
	move.w	64(a6),d5
	add.w	d3,d5
	bpl.s	l0080
	moveq	#1,d5
	bra.s	l0081
l0080	cmpi.w	#$1000,d5
	ble.s	l0081
	move.w	#$1000,d5
l0081	move.w	d5,64(a6)
l0082	move.w	30(a6),d5
	tst.w	d4
	beq.s	l0083
	add.w	d4,d5
l0083	tst.w	80(a6)
	ble.s	l0085
	tst.w	22(a6)
	bhi.s	l0084
	move.w	84(a6),22(a6)
	move.w	82(a6),d0
	add.w	d0,d5
	bra.s	l0085
l0084	subq.w	#1,22(a6)
l0085	tst.w	d5
	bpl.s	l0086
	moveq	#0,d5
l0086	cmpi.w	#$fff,d5
	ble.s	l0087
	move.w	#$fff,d5
l0087	move.w	d5,30(a6)
	rts

l0088	lea	l00a6(pc),a6
	tst.w	14(a6)
	ble.s	l0089
	subq.w	#1,14(a6)
	clr.w	18(a6)
	rts

l0089	move.w	10(a6),d2
	addq.w	#2,d2
	move.w	d2,10(a6)
	movea.l	6(a6),a0
	moveq	#0,d0
	moveq	#0,d1
	move.b	1(a0,d2.w),d1
	move.b	0(a0,d2.w),d0
	bne.s	l008d
l008a	move.w	#$fffe,10(a6)
	tst.w	12(a6)
	ble.s	l008b
	subq.w	#1,12(a6)
	bra.s	l0089
l008b	move.w	4(a6),d0
	addq.w	#4,d0
	move.w	d0,4(a6)
	movea.l	(a6),a0
	move.l	0(a0,d0.w),d0
	bne.s	l008c
	move.w	#$fffc,4(a6)
	bra.s	l008a
l008c	move.w	d0,12(a6)
	swap	d0
	lea	l00ab(pc),a0
	adda.w	d0,a0
	move.l	a0,6(a6)
	bra.s	l0089
l008d	cmpi.b	#$ff,d0
	bne.s	l008e
	move.w	d1,14(a6)
	clr.w	18(a6)
	bra.s	l008f
l008e	move.w	d1,14(a6)
	move.w	#1,18(a6)
l008f	rts

l0090	lea	l004f(pc),a0
	lea	l00a6(pc),a1
	lea	l00a3(pc),a6
	lea	l00a4(pc),a5
	lea	l00a5(pc),a4
	move.b	53(a6),52(a0)
	move.b	53(a5),58(a0)
	move.b	53(a4),64(a0)
	move.w	48(a6),d0
	add.w	d0,d0
	move.b	30(a6,d0.w),10(a0)
	move.b	31(a6,d0.w),4(a0)
	move.w	48(a5),d0
	add.w	d0,d0
	move.b	30(a5,d0.w),22(a0)
	move.b	31(a5,d0.w),16(a0)
	move.w	48(a4),d0
	add.w	d0,d0
	move.b	30(a4,d0.w),34(a0)
	move.b	31(a4,d0.w),28(a0)
	tst.w	66(a6)
	beq.s	l0091
	bset	#4,52(a0)
	move.b	63(a6),82(a0)
	move.b	64(a6),76(a0)
	move.b	65(a6),70(a0)
	bra.s	l0093
l0091	tst.w	66(a5)
	beq.s	l0092
	bset	#4,58(a0)
	move.b	63(a5),82(a0)
	move.b	64(a5),76(a0)
	move.b	65(a5),70(a0)
	bra.s	l0093
l0092	tst.w	66(a4)
	beq.s	l0093
	bset	#4,64(a0)
	move.b	63(a4),82(a0)
	move.b	64(a4),76(a0)
	move.b	65(a4),70(a0)
l0093	moveq	#$3f,d1
	move.w	88(a6),d0
	roxr.w	#1,d0
	bcs.s	l0094
	roxr.w	#1,d0
	bcs.s	l0095
	bra.s	l0096
l0094	bclr	#0,d1
	roxr.w	#1,d0
	bcc.s	l0096
l0095	bclr	#3,d1
l0096	move.w	88(a5),d0
	roxr.w	#1,d0
	bcs.s	l0097
	roxr.w	#1,d0
	bcs.s	l0098
	bra.s	l0099
l0097	bclr	#1,d1
	roxr.w	#1,d0
	bcc.s	l0099
l0098	bclr	#4,d1
l0099	move.w	88(a4),d0
	roxr.w	#1,d0
	bcs.s	l009a
	roxr.w	#1,d0
	bcs.s	l009b
	bra.s	l009c
l009a	bclr	#2,d1
	roxr.w	#1,d0
	bcc.s	l009c
l009b	bclr	#5,d1
l009c	tst.w	18(a1)
	beq.s	l009f
	tst.w	54(a6)
	beq.s	l009d
	bclr	#3,d1
l009d	tst.w	54(a5)
	beq.s	l009e
	bclr	#4,d1
l009e	tst.w	54(a4)
	beq.s	l009f
	bclr	#5,d1
l009f	move.b	17(a1),40(a0)
	move.b	d1,46(a0)
	rts

l00a0	dc.b	$0f,$d1,$0e,$ee,$0e,$17,$0d,'M'
	dc.b	$0c,$8e,$0b,$d9,$0b,'/',$0a,$8e
	dc.b	$09,$f7,$09,'g',$08,$e0,$08,'a'
	dc.b	$07,$e8,$07,'w',$07,$0b,$06,$a6
	dc.b	$06,'G',$05,$ec,$05,$97,$05,'G'
	dc.b	$04,$fb,$04,$b3,$04,'p',$04,'0'
	dc.b	$03,$f4,$03,$bb,$03,$85,$03,'S'
	dc.b	$03,'#',$02,$f6,$02,$cb,$02,$a3
	dc.b	$02,'}',$02,'Y',$02,'8',$02,$18
	dc.b	$01,$fa,$01,$dd,$01,$c2,$01,$a9
	dc.b	$01,$91,$01,'{',$01,'e',$01,'Q'
	dc.b	$01,'>',$01,',',$01,$1c,$01,$0c
	dc.b	$00,$fd,$00,$ee,$00,$e1,$00,$d4
	dc.b	$00,$c8,$00,$bd,$00,$b2,$00,$a8
	dc.b	$00,$9f,$00,$96,$00,$8e,$00,$86
	dc.b	$00,'~',$00,'w',$00,'p',$00,'j'
	dc.b	$00,'d',$00,'^',$00,'Y',$00,'T'
	dc.b	$00,'O',$00,'K',$00,'G',$00,'C'
	dc.b	$00,'?',$00,';',$00,'8',$00,'5'
	dc.b	$00,'2',$00,'/',$00,',',$00,'*'
	dc.b	$00,$27,$00,'%',$00,'#',$00,'!'
	dc.b	$00,$1f,$00,$1d,$00,$1c,$00,$1a
	dc.b	$00,$19,$00,$17,$00,$16,$00,$15
	dc.b	$00,$13,$00,$12,$00,$11,$00,$10
	dc.b	$00,$0f
l00a1	dc.b	$00,$fd,$00,$ef,$00,$e1,$00,$d5
	dc.b	$00,$c9,$00,$bd,$00,$b3,$00,$a9
	dc.b	$00,$9f,$00,$96,$00,$8e,$00,$86
	dc.b	$00,'~',$00,'w',$00,'r',$00,'k'
	dc.b	$00,'d',$00,'_',$00,'Y',$00,'T'
	dc.b	$00,'O',$00,'K',$00,'G',$00,'C'
	dc.b	$00,'?',$00,'<',$00,'9',$00,'6'
	dc.b	$00,'2',$00,'/',$00,',',$00,'*'
	dc.b	$00,'(',$00,'%',$00,'$',$00,'"'
	dc.b	$00,' ',$00,$1e,$00,$1c,$00,$1b
	dc.b	$00,$19,$00,$18,$00,$16,$00,$15
	dc.b	$00,$14,$00,$13,$00,$12,$00,$11
	dc.b	$00,$10,$00,$0f,$00,$0e,$00,$0d
	dc.b	$00,$0c,$00,$0c,$00,$0b,$00,$0a
	dc.b	$00,$0a,$00,$09,$00,$09,$00,$08
l00a2	dcb.w	5
l00a3	dcb.w	90
l00a4	dcb.w	90
l00a5	dcb.w	90
l00a6	dcb.w	20
l00a7	dc.b	$00,$04,$00,$a4,$03,$cc,$06,$8c
l00a8	dcb.w	4
	dc.b	$00,$07,$00,$0c,$00,$07,$00,$00
	dc.b	$00,$0c,$00,$18,$00,'$',$00,$00
	dc.b	$00,$03,$00,$05,$00,$00,$00,$00
l00a9	dc.b	$00,$04,$01,$12,$01,'*',$00,$b8
	dc.b	$00,$fa,$00,$9a,$00,'X',$00,$e8
	dc.b	$01,'T',$00,'|',$01,'H',$00,$10
	dc.b	$00,'"',$00,'@'
l00aa	dcb.w	2
	dc.b	$00,'\',$00,$00,$02,$be,$00,$00
	dc.b	$02,$e8,$00,$00,$02,$be,$00,$00
	dc.b	$02,$e8,$00,$00,$02,$be,$00,$00
	dc.b	$02,$e8,$00,$00,$02,$be,$00,$00
	dc.b	$03,$0a,$00,$00,$05,'H',$00,$ff
	dc.b	$01,$da,$00,$03,$02,$00,$00,$03
	dc.b	$01,'0',$00,$01,$05,'H',$00,$ff
	dc.b	$00,$b0,$00,'2',$05,'H',$00,$00
	dc.b	$00,$be,$00,$00,$00,$0c,$00,$00
	dc.b	$00,$96,$00,$03,$00,$0c,$00,$00
	dc.b	$00,$96,$00,$00,$00,$0c,$00,$00
	dc.b	$00,$96,$00,$00,$00,$10,$00,$00
	dc.b	$00,$96,$00,$00,$00,$14,$00,$00
	dc.b	$00,$96,$00,$00,$00,$18,$00,$00
	dc.b	$00,$96,$00,$00,$00,$1c,$00,$00
	dc.b	$00,$96,$00,$00,$00,' ',$00,$00
	dc.b	$00,$96,$00,$00,$00,'$',$00,$00
	dc.b	$00,$96,$00,$00,$00,'(',$00,$00
	dc.b	$00,$96,$00,$00,$00,',',$00,$00
	dc.b	$00,$96,$00,$00,$00,$00,$00,$00
	dc.b	$00,'\',$00,$00,$03,$de,$00,$03
	dc.b	$00,'\',$00,$00,$03,$de,$00,$00
	dc.b	$00,'T',$00,$00,$03,$de,$00,$00
	dc.b	$00,'p',$00,$00,$03,$de,$00,$00
	dc.b	$00,'\',$00,$00,$03,$de,$00,$00
	dc.b	$00,'\',$00,$00,$04,'t',$00,$03
	dc.b	$00,'\',$00,$00,$04,'t',$00,$00
	dc.b	$03,$ea,$00,$00,$04,'t',$00,$00
	dc.b	$03,$ea,$00,$00,$04,'t',$00,$00
	dc.b	$03,$ea,$00,$00,$04,'t',$00,$00
	dc.b	$03,$ea,$00,$00,$00,'\',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'h',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'|',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'p',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'\',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'h',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'L',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'T',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'\',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'h',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'|',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'p',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'\',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'h',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'L',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'T',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'\',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'h',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'|',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'p',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'\',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'h',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'L',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'T',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'\',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'h',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'|',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'p',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'\',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'h',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'L',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'T',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'\',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'h',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'|',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'p',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'\',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'h',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'L',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'T',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'\',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'h',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'|',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'p',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'\',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'h',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'L',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'T',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'\',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'h',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'|',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'p',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'\',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'h',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'L',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'T',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'\',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'h',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'|',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'p',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'\',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'h',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'L',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'T',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'T',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'H',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'L',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'@',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'T',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'H',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'L',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'@',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'T',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'H',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'L',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'@',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'T',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'H',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'L',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'@',$00,$00
	dc.b	$04,$fe,$00,$00,$00,'\',$00,$00
	dc.b	$03,$de,$00,$01,$00,'L',$00,$00
	dc.b	$03,$de,$00,$00,$00,'@',$00,$00
	dc.b	$03,$de,$00,$00,$00,'\',$00,$00
	dc.b	$03,$de,$00,$01,$00,'L',$00,$00
	dc.b	$03,$de,$00,$00,$00,'@',$00,$00
	dc.b	$03,$de,$00,$00,$00,'\',$00,$00
	dc.b	$03,$de,$00,$01,$00,'L',$00,$00
	dc.b	$03,$de,$00,$00,$00,'@',$00,$00
	dc.b	$03,$de,$00,$00,$00,'\',$00,$00
	dc.b	$03,$de,$00,$01,$00,$00,$00,$00
	dc.b	$00,'\',$00,$00,$05,'H',$00,$7f
	dc.b	$03,' ',$00,$06,$03,'Z',$00,$00
	dc.b	$05,'H',$00,'?',$05,'H',$00,$03
	dc.b	$03,'x',$00,$06,$03,$82,$00,$00
	dc.b	$03,$8c,$00,$03,$00,'\',$00,$00
	dc.b	$02,'n',$00,$00,$02,$92,$00,$00
	dc.b	$02,'n',$00,$00,$02,$92,$00,$00
	dc.b	$02,'n',$00,$00,$02,$92,$00,$00
	dc.b	$02,'n',$00,$00,$02,$92,$00,$00
	dc.b	$00,'\',$00,$00,$02,'n',$00,$00
	dc.b	$00,'h',$00,$00,$02,$92,$00,$00
	dc.b	$00,'L',$00,$00,$02,'n',$00,$00
	dc.b	$00,'T',$00,$00,$02,$92,$00,$00
	dc.b	$00,'\',$00,$00,$02,'n',$00,$00
	dc.b	$00,'h',$00,$00,$02,$92,$00,$00
	dc.b	$00,'L',$00,$00,$02,'n',$00,$00
	dc.b	$00,'T',$00,$00,$02,$92,$00,$00
	dc.b	$00,'\',$00,$00,$02,'n',$00,$00
	dc.b	$00,'h',$00,$00,$02,$92,$00,$00
	dc.b	$00,'L',$00,$00,$02,'n',$00,$00
	dc.b	$00,'T',$00,$00,$02,$92,$00,$00
	dc.b	$00,'\',$00,$00,$02,'n',$00,$00
	dc.b	$00,'h',$00,$00,$02,$92,$00,$00
	dc.b	$00,'L',$00,$00,$02,'n',$00,$00
	dc.b	$00,'T',$00,$00,$02,$92,$00,$00
	dc.b	$00,'\',$00,$00,$02,'n',$00,$00
	dc.b	$00,'h',$00,$00,$02,$92,$00,$00
	dc.b	$00,'L',$00,$00,$02,'n',$00,$00
	dc.b	$00,'T',$00,$00,$02,$92,$00,$00
	dc.b	$00,'\',$00,$00,$00,$04,$00,$00
	dc.b	$05,'H',$00,$7f,$03,' ',$00,$13
	dc.b	$00,'\',$00,$00,$02,'n',$00,$00
	dc.b	$00,'h',$00,$00,$02,$92,$00,$00
	dc.b	$00,'L',$00,$00,$02,'n',$00,$00
	dc.b	$00,'T',$00,$00,$02,$92,$00,$00
	dc.b	$00,'\',$00,$00,$02,'n',$00,$00
	dc.b	$00,'h',$00,$00,$02,$92,$00,$00
	dc.b	$00,'L',$00,$00,$02,'n',$00,$00
	dc.b	$00,'T',$00,$00,$02,$92,$00,$00
	dc.b	$00,'\',$00,$00,$02,'n',$00,$00
	dc.b	$00,'h',$00,$00,$02,$92,$00,$00
	dc.b	$00,'L',$00,$00,$02,'n',$00,$00
	dc.b	$00,'T',$00,$00,$02,$92,$00,$00
	dc.b	$00,'\',$00,$00,$02,'n',$00,$00
	dc.b	$00,'h',$00,$00,$02,$92,$00,$00
	dc.b	$00,'L',$00,$00,$02,'n',$00,$00
	dc.b	$00,'T',$00,$00,$02,$92,$00,$00
	dc.b	$00,'T',$00,$00,$02,'n',$00,$00
	dc.b	$00,'H',$00,$00,$02,$92,$00,$00
	dc.b	$00,'L',$00,$00,$02,'n',$00,$00
	dc.b	$00,'@',$00,$00,$02,$92,$00,$00
	dc.b	$00,'T',$00,$00,$02,'n',$00,$00
	dc.b	$00,'H',$00,$00,$02,$92,$00,$00
	dc.b	$00,'L',$00,$00,$02,'n',$00,$00
	dc.b	$00,'@',$00,$00,$02,$92,$00,$00
	dc.b	$00,'T',$00,$00,$02,'n',$00,$00
	dc.b	$00,'H',$00,$00,$02,$92,$00,$00
	dc.b	$00,'L',$00,$00,$02,'n',$00,$00
	dc.b	$00,'@',$00,$00,$02,$92,$00,$00
	dc.b	$00,'T',$00,$00,$02,'n',$00,$00
	dc.b	$00,'H',$00,$00,$02,$92,$00,$00
	dc.b	$00,'L',$00,$00,$02,'n',$00,$00
	dc.b	$00,'@',$00,$00,$02,$92,$00,$00
	dc.b	$00,$0c,$00,$00,$00,'\',$00,$00
	dc.b	$02,'&',$00,$00,$02,'H',$00,$00
	dc.b	$02,'&',$00,$00,$02,'H',$00,$00
	dc.b	$00,'L',$00,$00,$02,'&',$00,$00
	dc.b	$02,'H',$00,$00,$00,'@',$00,$00
	dc.b	$02,'&',$00,$00,$02,'H',$00,$00
	dc.b	$00,'\',$00,$00,$00,$0c,$00,$00
	dc.b	$02,'&',$00,$00,$02,'H',$00,$00
	dc.b	$00,$10,$00,$00,$02,'&',$00,$00
	dc.b	$02,'H',$00,$00,$00,'L',$00,$00
	dc.b	$00,$14,$00,$00,$02,'&',$00,$00
	dc.b	$02,'H',$00,$00,$00,'@',$00,$00
	dc.b	$00,$18,$00,$00,$02,'&',$00,$00
	dc.b	$02,'H',$00,$00,$00,'\',$00,$00
	dc.b	$00,$1c,$00,$00,$02,'&',$00,$00
	dc.b	$02,'H',$00,$00,$00,' ',$00,$00
	dc.b	$02,'&',$00,$00,$02,'H',$00,$00
	dc.b	$00,'L',$00,$00,$00,'$',$00,$00
	dc.b	$02,'&',$00,$00,$02,'H',$00,$00
	dc.b	$00,'@',$00,$00,$00,'(',$00,$00
	dc.b	$02,'&',$00,$00,$02,'H',$00,$00
	dc.b	$00,'\',$00,$00,$00,',',$00,$00
	dc.b	$02,'&',$00,$00,$02,'H',$00,$00
	dc.b	$00,'0',$00,$00,$02,'&',$00,$00
	dc.b	$02,'H',$00,$00,$00,$00,$00,$00
	dc.b	$05,'L}',$7f,$00,$00,$00,$00
l00ab	dcb.w	2
	dc.b	$fe,$ff,$00,$00,$fe,$00,$00,$00
	dc.b	$f2,$0f,$00,$00,$f2,$0e,$00,$00
	dc.b	$f2,$0d,$00,$00,$f2,$0c,$00,$00
	dc.b	$f2,$0b,$00,$00,$f2,$0a,$00,$00
	dc.b	$f2,$09,$00,$00,$f2,$08,$00,$00
	dc.b	$f2,$07,$00,$00,$f2,$06,$00,$00
	dc.b	$ff,$f4,$00,$00,$ff,$f7,$00,$00
	dc.b	$ff,$f8,$00,$00,$ff,$f9,$00,$00
	dc.b	$ff,$fa,$00,$00,$ff,$fb,$00,$00
	dc.b	$ff,$fc,$00,$00,$ff,$fd,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$00,$00,$00,$ff,$01,$00,$00
	dc.b	$ff,$02,$00,$00,$ff,$03,$00,$00
	dc.b	$ff,$04,$00,$00,$ff,$05,$00,$00
	dc.b	$ff,$06,$00,$00,$ff,$07,$00,$00
	dc.b	$ff,$08,$00,$00,$ff,$09,$00,$00
	dc.b	$ff,$0a,$00,$00,$ff,$0b,$00,$00
	dc.b	$ff,$0c,$00,$00,$f2,$00,$f9,$00
	dc.b	$00,$00,$f3,$0c,'8',$18,'6',$18
	dc.b	'8',$18,'?',$0c,'=',$18,';',$12
	dc.b	'6',$12,'8',$0c,'6',$0c,'8',$0c
	dc.b	'6',$0c,$00,$00,$f2,$0f,$f3,$03
	dc.b	$fd,$02,$14,$06,$14,$0c,$14,$0c
	dc.b	$00,$00,$f2,$0f,$f3,$08,':$'
	dc.b	';$=',$18,'6$=$'
	dc.b	'6',$18,'8`6$5$'
	dc.b	'1',$18,':$;$=',$18
	dc.b	'?$=$6',$18,'8`'
	dc.b	'B',$06,'A',$06,'?',$06,'=',$06
	dc.b	'A',$06,'?',$06,'=',$06,';',$06
	dc.b	'?',$06,'=',$06,';',$06,':',$06
	dc.b	'=',$06,';',$06,':',$06,'8',$06
	dc.b	':$;$D',$18,'B$'
	dc.b	'=$:',$18,'=$;',$06
	dc.b	':',$06,';$:',$0c,'8`'
	dc.b	':$;$=',$18,'6$'
	dc.b	'=$6',$18,'8`6$'
	dc.b	'5<',$00,$00,$f2,$0f,$f3,$08
	dc.b	':$;$=',$18,'?$'
	dc.b	'=$;',$18,'8$:$'
	dc.b	';$=',$18,';$:',$18
	dc.b	$f2,$0f,$f3,$08,':$;$'
	dc.b	'=',$18,'B$@$?',$18
	dc.b	'8$:$;',$18,'=`'
	dc.b	'D$B$@',$18,'?$'
	dc.b	';',$18,'8',$0c,'6',$0c,'8',$0c
	dc.b	';',$18,'=',$18,'?',$0c,'B',$18
	dc.b	'D',$18,'G',$18,'F',$18,'B$'
	dc.b	'D',$06,'D',$01,$c2,$05,'B',$0c
	dc.b	'D',$18,'F',$0c,'G',$0c,'I',$06
	dc.b	'I',$01,$cb,$05,'K',$18,'?',$0c
	dc.b	'K',$0c,'W',$0c,'K',$0c,'D',$0c
	dc.b	'K',$0c,'?',$0c,'D',$06,'D',$01
	dc.b	$c2,$05,'B',$0c,'D',$06,'D',$01
	dc.b	$c2,$05,'B',$0c,'D',$06,'D',$01
	dc.b	$c2,$05,'B',$0c,'D',$06,'D',$01
	dc.b	$c2,$05,'B',$0c,'D',$06,'D',$01
	dc.b	$c2,$05,'B',$0c,'?',$0c,'=',$0c
	dc.b	'?',$18,'=',$18,$00,$00,$f2,$0f
	dc.b	$f3,$0b,'B',$06,'D',$06,'D',$06
	dc.b	'D',$06,'K',$06,'D',$06,'D',$06
	dc.b	'I',$06,'D',$06,'G',$06,'D',$06
	dc.b	'D',$06,'F',$06,'D',$06,'C',$06
	dc.b	'D',$06,$00,$00,$f2,$0f,$f3,$0c
	dc.b	'B',$06,'D',$06,'D',$06,'D',$06
	dc.b	'K',$06,'D',$06,'D',$06,'I',$06
	dc.b	'D',$06,'G',$06,'D',$06,'D',$06
	dc.b	'F',$06,'D',$06,'C',$06,'D',$06
	dc.b	$00,$00,$f3,$03,$fd,$02,$14,$12
	dc.b	' ',$06,$f3,$02,$f4,$12,'#',$0c
	dc.b	$f3,$03,' ',$06,$14,$12,$14,$0c
	dc.b	$f3,$02,$f4,$12,'#',$0c,$f3,$03
	dc.b	' ',$06,$00,$00,$14,$06,$14,$0c
	dc.b	$14,$0c,$f3,$02,$f4,$12,'#',$0c
	dc.b	$f3,$03,' ',$06,$14,$0c,' ',$06
	dc.b	$14,$0c,$f3,$02,$f4,$12,'#',$0c
	dc.b	$f3,$03,' ',$06,$f3,$03,$14,$06
	dc.b	$00,$00,$f2,$0f,$f3,$03,$fd,$02
	dc.b	$14,$12,' ',$06,$f3,$02,$f4,$12
	dc.b	'#',$0c,$f3,$03,' ',$06,$14,$12
	dc.b	$14,$0c,$f3,$02,$f4,$12,'#',$0c
	dc.b	$f3,$03,' ',$06,$00,$00,$f2,$0f
	dc.b	$f3,$03,$fd,$02,$14,$06,$14,$0c
	dc.b	$14,$0c,$f3,$02,$f4,$12,'#',$0c
	dc.b	$f3,$03,' ',$06,$14,$0c,' ',$06
	dc.b	$14,$0c,$f3,$02,$f4,$12,'#',$0c
	dc.b	$f3,$03,' ',$06,$f3,$03,$14,$06
	dc.b	$00,$00,$f2,$0f,$f3,$03,$fd,$02
	dc.b	' ',$12,' ',$12,' ',$0c,' ',$12
	dc.b	' ',$12,' ',$0c,' ',$12,' ',$12
	dc.b	' ',$0c,' ',$06,$14,$06,'"',$06
	dc.b	$16,$06,'#',$06,$17,$06,'"',$06
	dc.b	$1e,$06,$00,$00,$f2,$0f,$f3,$03
	dc.b	$fd,$02,' ',$12,' ',$12,' ',$0c
	dc.b	' ',$12,' ',$12,' ',$0c,' ',$12
	dc.b	' ',$12,' ',$0c,$1b,$0c,$1b,$0c
	dc.b	$1e,$0c,$1e,$0c,$00,$00,' ',$12
	dc.b	' ',$12,' ',$0c,' ',$12,' ',$12
	dc.b	' ',$0c,' ',$12,' ',$12,' ',$0c
	dc.b	' 0',$00,$00,$f2,$0e,$f3,$01
	dc.b	$f4,$1c,$17,$0c,$f3,$01,$f4,$1c
	dc.b	$17,$0c,$f3,$02,$f4,$12,'#',$0c
	dc.b	$f3,$01,$f4,$1c,$17,$06,$f3,$01
	dc.b	$f4,$1c,$17,$0c,$f3,$01,$f4,$1c
	dc.b	$17,$06,$f3,$01,$f4,$1c,$17,$0c
	dc.b	$f3,$02,$f4,$12,'#',$0c,$f3,$01
	dc.b	$f4,$1c,$17,$0c,$00,$00,$f2,$0f
	dc.b	$f3,$01,$f4,$1c,$17,$06,$f3,$02
	dc.b	$f4,$12,'#',$12,'#',$12,'#',$12
	dc.b	'#',$0c,'#',$06,'#',$06,'#',$06
	dc.b	'#',$06,$00,$00,$f2,$0f,$f3,$02
	dc.b	$f4,$16,'"0',$00,$00,$f2,$0f
	dc.b	$f3,$02,$f4,$16,'"',$18,$00,$00
	dc.b	$f2,$0f,$f3,$01,$f4,$1c,$1a,$0c
	dc.b	$f3,$01,$f4,$1c,$1a,$0c,$f3,$02
	dc.b	$f4,$16,'"',$1e,$f3,$01,$f4,$1c
	dc.b	$1a,$06,$f3,$01,$f4,$1c,$1a,$0c
	dc.b	$f3,$02,$f4,$16,'"',$18,$f3,$01
	dc.b	$f4,$1c,$1a,$0c,$f3,$01,$f4,$1c
	dc.b	$1a,$0c,$f3,$02,$f4,$16,'"',$18
	dc.b	$f3,$01,$f4,$1c,$1a,$06,$f3,$02
	dc.b	$f4,$16,'"',$12,$f3,$02,$f4,$16
	dc.b	'"',$12,$f3,$02,$f4,$16,'"',$06
	dc.b	$00,$00,$f2,$0f,$f3,$0a,$f9,$0e
	dc.b	$fa,$14,$14,$c0,$00,$00,$f2,$0f
	dc.b	$f3,$0a,$fd,$01,$f9,$0e,$fa,$14
	dc.b	$14,$06,$fa,'  ',$06,$fa,$14
	dc.b	$14,$06,$fa,$14,$14,$06,$fa,' '
	dc.b	' ',$06,$fa,$14,$14,$06,$fa,$14
	dc.b	$14,$06,$fa,'  ',$06,$fa,$14
	dc.b	$14,$06,$fa,'  ',$06,$fa,$14
	dc.b	$14,$06,$fa,$14,$14,$06,$fa,' '
	dc.b	' ',$06,$fa,$14,$14,$06,$fa,' '
	dc.b	' ',$06,$fa,$13,$13,$06,$fa,$14
	dc.b	$14,$06,$fa,'  ',$06,$fa,$14
	dc.b	$14,$06,$fa,$14,$14,$06,$fa,' '
	dc.b	' ',$06,$fa,$14,$14,$06,$fa,$14
	dc.b	$14,$06,$fa,'  ',$06,$fa,$0f
	dc.b	$0f,$06,$fa,$0f,$0f,$06,$fa,$1b
	dc.b	$1b,$06,$fa,$0f,$0f,$06,$fa,$12
	dc.b	$12,$06,$fa,$12,$12,$06,$fa,$1e
	dc.b	$1e,$06,$fa,$12,$12,$06,$00,$00
	dc.b	$f2,$0f,$f3,$0a,$fd,$01,$f9,$0e
	dc.b	$fa,$14,$14,$06,$fa,'  ',$06
	dc.b	$fa,$14,$14,$06,$fa,$14,$14,$06
	dc.b	$fa,'  ',$06,$fa,$14,$14,$06
	dc.b	$fa,$14,$14,$06,$fa,'  ',$06
	dc.b	$fa,$14,$14,$06,$fa,'  ',$06
	dc.b	$fa,$14,$14,$06,$fa,$14,$14,$06
	dc.b	$fa,'  ',$06,$fa,$14,$14,$06
	dc.b	$fa,'  ',$06,$fa,$13,$13,$06
	dc.b	$fa,$14,$14,$06,$fa,'  ',$06
	dc.b	$fa,$14,$14,$06,$fa,$14,$14,$06
	dc.b	$fa,'  ',$06,$fa,$14,$14,$06
	dc.b	$fa,$14,$14,$06,$fa,'  ',$06
	dc.b	$fa,$17,$17,$06,$fa,$17,$17,$06
	dc.b	$fa,'##',$06,$fa,$17,$17,$06
	dc.b	$fa,$19,$19,$06,$fa,$19,$19,$06
	dc.b	$fa,'%%',$06,$fa,$19,$19,$06
	dc.b	$00,$00,$f2,$0f,$f3,$0a,$fd,$01
	dc.b	$f9,$0e,$fa,$14,$14,$06,$fa,' '
	dc.b	' ',$06,$fa,$14,$14,$06,$fa,$14
	dc.b	$14,$06,$fa,'  ',$06,$fa,$14
	dc.b	$14,$06,$fa,$14,$14,$06,$fa,' '
	dc.b	' ',$06,$fa,$14,$14,$06,$fa,' '
	dc.b	' ',$06,$fa,$14,$14,$06,$fa,$14
	dc.b	$14,$06,$fa,'  ',$06,$fa,$14
	dc.b	$14,$06,$fa,'  ',$06,$fa,$13
	dc.b	$13,$06,$00,$00,$f1,$06,$00,$00
	dc.b	$ff,$05,$00,$00,$03,$05,$03,$05
	dc.b	$03,$05,$03,$05,$03,$05,$03,$05
	dc.b	$03,$05,$03,$05,$00,$00
l00ac	dcb.w	2
l00ad	dcb.w	5
	dc.b	$06,$ff,$00,$00,$00,$00,$00,$01
	dcb.w	2
	dc.b	$fd,$c1,$00,$00,$00,$00,$06,$ff
	dcb.w	2
	dc.b	$00,$01,$00,$00,$00,$00,$fd,'A'
	dcb.w	2
	dc.b	$04,$01,$00,$00,$00,$00,$fd,$01
	dcb.w	2
	dc.b	$06,$ff,$00,$00,$00,$00,$00,'1'
	dcb.w	2
	dc.b	$ff,'q',$00,$00,$00,$00,$ff,$01
	dcb.w	2
	dc.b	$06,$ff,$00,$00,$00,$00,$01,$c1
	dc.b	$00,$02,$00,$00,$00,'A',$ff,$fe
	dc.b	$00,$00,$00,'A',$ff,$fe,$00,$00
	dc.b	$00,'A',$00,$02,$00,$00,$00,'A'
	dcb.w	2
	dc.b	$18,$ff,$00,$00,$00,$00,$00,$01
	dcb.w	2
	dc.b	$ff,$05,$00,$00,$00,$00,$00,$09
	dcb.w	2
	dc.b	$ff,$0d,$00,$00,$00,$00,$18,$ff
	dcb.w	2
	dc.b	$00,$01,$00,$00,$00,$00,$00,$05
	dcb.w	2
	dc.b	$00,$01,$00,$00,$00,$00,$ff,$09
	dcb.w	2
	dc.b	$18,$ff,$00,$00,$00,$00,$00,$0b
	dcb.w	2
	dc.b	$00,$05,$00,$00,$00,$00,$00,$01
	dcb.w	2
	dc.b	$00,$05,$00,$00,$00,$00,$ff,$01
	dcb.w	2
	dc.b	$00,$81,$00,$00,$00,$00,$ff,$01
	dcb.w	2
	dc.b	$0c,$ff,$00,$00,$00,$00,$fe,$02
	dcb.w	2
	dc.b	$fd,$02,$00,$00,$00,$00,$06,$ff
	dcb.w	2
	dc.b	$00,$03,$00,$14,$00,$00,$00,$01
	dc.b	$00,$14,$00,$00,$fd,$c1,$00,$00
	dc.b	$00,$00,$06,$ff,$00,$00,$00,$00
	dc.b	$00,$03,$00,'P',$00,$00,$00,$01
	dc.b	$00,'P',$00,$00,$fe,$01,$00,$00
	dc.b	$00,$00,$0c,$ff,$00,$00,$00,$00
	dc.b	$00,$03,$00,'d',$00,$ff,$00,$01
	dc.b	$00,'d',$00,$ff,$00,'A',$00,'d'
	dc.b	$00,$ff,$ff,$02,$00,$00,$00,$00
	dc.b	$06,$ff,$00,$00,$00,$00,$00,$f1
	dcb.w	2
	dc.b	$06,$ff,$00,$00,$00,$00,$00,$01
	dcb.w	2
	dc.b	$ff,'A',$00,$01,$00,$00,$00,'A'
	dc.b	$ff,$ff,$00,$00,$00,'A',$ff,$ff
	dc.b	$00,$00,$00,'A',$00,$01,$00,$00
	dc.b	$00,'A',$00,$00,$00,$00,$18,$ff
	dc.b	'This is '
	dc.b	'the end '
	dc.b	'of the f'
	dc.b	'ile, if '
	dc.b	'you',$27,'re r'
	dc.b	'ipping i'
	dc.b	't... <CZ'
	dc.b	'I>',$00,$00,$00,$00,$00,$00
	dcb.w	311
l00ae	dcb.w	65
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dcb.w	60
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dcb.w	56
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dcb.w	51
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
	dcb.w	44
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dcb.w	42
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
	dcb.w	36
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
	dcb.w	32
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
	dcb.w	26
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
	dcb.w	24
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
	dcb.w	21
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
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dcb.w	16
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
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dcb.w	11
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
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dcb.w	8
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
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dcb.w	4
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
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
l00af	dc.b	'^',$e4,'b',$a3,'fbk`'
	dc.b	'o',$1e,'t',$1b,'w',$d7,'{',$92
	dc.b	$7f,'M',$83,$07,$86,$c1,$89,':'
	dc.b	$8c,$f3,$8f,'k',$91,$e3,$94,'['
	dc.b	$95,$92,$98,$0a,$99,'Ašx'
	dc.b	$9b,$ae,$9b,$a5,$9b,$9c,$9b,$93
	dc.b	$9b,$8a,$9b,$81,'š9',$98,$f1
	dc.b	$97,$a9,$95,'"',$93,$db,$91,'T'
	dc.b	$8e,$ce,$8c,'I',$88,$84,$86,$00
	dc.b	$82,'<~yz',$b6,'v',$f4
	dc.b	's3n2jrer'
	dc.b	'a',$b3,']',$f5,'X',$f6,'U9'
	dc.b	'P<L',$7f,'G',$83,'C',$c7
	dc.b	'@',$0b,'<P8',$95,'4',$da
	dc.b	'2_.',$a4,',*)',$af
	dc.b	$27,'5%',$fa,'#',$7f,'"D'
	dc.b	'!',$09,$1f,$cd,$1f,$d2,$1f,$d6
	dc.b	$1f,$d9,$1f,$dd,$1f,$e0,'!#'
	dc.b	'"e#',$a7,'&(',$27,'j'
	dc.b	')',$ea,',k.',$eb,'2',$ab
	dc.b	'5*8',$e9,'<',$a8,'@g'
	dc.b	'D%G',$e3,'L',$e1,'P',$9f
	dc.b	'U',$9c,'YZ^Xb',$15
	dc.b	'e',$d3,'j',$d0,'nŽs',$8c
	dc.b	'wJ{',$08
	moveq	#$c7,d7
	or.l	d6,d1
	or.w	d5,d3
	divu	d4,d4
	or.l	d4,d6
	sbcd	d4,d7
	subx.l	d5,d0
	sub.b	d5,d2
	subx.w	d7,d2
	suba.l	a0,a3
	subx.b	-(a2),-(a4)
	sub.w	a4,d5
	subx.l	-(a7),-(a5)
	sub.l	d5,(a2)
	sub.l	d5,(a6)
	sub.l	d5,(a1)+
	sub.l	d5,(a5)+
	sub.l	d5,-(a2)
	sub.w	-(a6),d5
	sub.b	d4,-26640(a3)
	dc.b	$95,'u”;'
	suba.l	d0,a0
	dc.b	$8f,'E',$8c,$cb,$89,$10,$86,$95
	dc.b	$82,$da,$7f,$1f,'{dw',$a8
	dc.b	's',$ec,'n',$f0,'k3f6'
	dc.b	'by^',$ba,'Y',$bc,'U',$fd
	dc.b	'P',$fd,'M=H<D{'
	dc.b	'@',$b9,'<',$f6,'935o'
	dc.b	'2',$eb,'/&,',$a1,'*',$1b
	dc.b	$27,'”&M#',$c6,'"~'
	dc.b	'!6',$1f,$ee,$1f,$e5,$1f,$dc
	dc.b	$1f,$d3,$1f,$ca,$1f,$c1,' ',$f7
	dc.b	'".#e%',$dd,$27,$14
	dc.b	')',$8c,',',$04,'.|25'
	dc.b	'4',$ae,'8h<"?',$dd
	dc.b	'C',$98,'GTLQP',$0f
	dc.b	'U',$0d,'X',$cc,']',$cc,'a',$8c
	dc.b	'eMjOn',$11,'s',$14
	dc.b	'v',$d8,'z',$9d,'~b',$82,'('
	dc.b	$85,$ee,$88,'u',$8c,'<',$8e,$c4
	dc.b	$91,'L',$93,$d4,$95,$1d,$97,$a5
	dc.b	$98,$ee,'š7',$9b,$81,$9b,$8a
	dc.b	$9b,$93,$9b,$9c,$9b,$a5,$9b,$ae
	dc.b	'šv™>',$98,$06,$95,$8d
	dc.b	$94,'T',$91,$db,$8f,'a',$8c,$e6
	dc.b	$89,'+',$86,$af,$82,$f3,$7f,'6'
	dc.b	'{yw',$bb,'s',$fc,'n',$fd
	dc.b	'k=f=b|^',$ba
	dc.b	'Y',$b9,'U',$f6,'P',$f3,'M0'
	dc.b	'H,Dh@',$a4,'<',$df
	dc.b	'9',$1a,'5U2',$d0,'/',$0b
	dc.b	',',$85,'*',$00,$27,'{&5'
	dc.b	'#',$b0,'"k!&',$1f,$e2
	dc.b	$1f,$dd,$1f,$d9,$1f,$d6,$1f,$d2
	dc.b	$1f,$cf,'!',$0c,'"J#',$88
	dc.b	'&',$07,$27,'E)',$c5,',D'
	dc.b	'.',$c4,'2„5',$05,'8',$c6
	dc.b	'<',$87,'@HD',$0a,'G',$cc
	dc.b	'L',$ce,'P',$90,'U',$93,'YU'
	dc.b	'^Xb',$1a,'e',$dc,'j',$df
	dc.b	'n',$a1,'s',$a3,'we{',$27
	dc.b	'~',$e8,$82,$a9,$86,'j',$88,$eb
	dc.b	$8c,$ab,$8f,'+',$91,$aa,$94,'*'
	dc.b	$95,'h',$97,$e7,$99,'%šc'
	dc.b	$9b,$a0,$9b,$9d,$9b,$99,$9b,$96
	dc.b	$9b,$92,$9b,$8d,'šI',$99,$04
	dc.b	$97,$bf,$95,':',$93,$f5,$91,'o'
	dc.b	$8e,$ea,$8c,'d',$88,$9f,$86,$1a
	dc.b	$82,'U~',$90,'z',$cb,'w',$07
	dc.b	'sCn?j|ey'
	dc.b	'a',$b6,']',$f5,'X',$f3,'U2'
	dc.b	'P2LrGsC',$b4
	dc.b	'?',$f6,'<98|4',$c0
	dc.b	'2D.',$89,',',$0e,')”'
	dc.b	$27,$1b,'%',$e2,'#i"1'
	dc.b	' ',$f9,$1f,$c1,$1f,$ca,$1f,$d3
	dc.b	$1f,$dc,$1f,$e5,$1f,$ee,'!8'
	dc.b	'"#',$ca,'&R',$27,$9b
	dc.b	'*#,',$ab,'/32',$fa
	dc.b	'59G=',$0d,'@',$d2
	dc.b	'D',$97,'H[M^Q '
	dc.b	'V"Y',$e3,'^',$e4,'b',$a3
	dc.b	'fbk`o',$1e,'t',$1b
	dc.b	'w',$d7,'{',$92,$7f,'M',$83,$07
	dc.b	$86,$c1,$89,':',$8c,$f3,$8f,'k'
	dc.b	$91,$e3,$94,'[',$95,$92,$98,$0a
	dc.b	$99,'Ašx',$9b,$ae,$9b,$a5
	dc.b	$9b,$9c,$9b,$93,$9b,$8a,$9b,$81
	dc.b	'š9',$98,$f1,$97,$a9,$95,'"'
	dc.b	$93,$db,$91,'T',$8e,$ce,$8c,'I'
	dc.b	$88,$84,$86,$00,$82,'<~y'
	dc.b	'z',$b6,'v',$f4,'s3'
	data
l00b0	dc.b	$00,$00
l00b1	dc.b	$12
l00b2	dc.b	$08
	bss
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
zuend	end
