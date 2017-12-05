l0000	equ	begin-$3f2a
l0001	equ	begin-$3c3a
l0002	equ	begin-$11fe
	text
begin
	dc.b	$a0,$0a
	bsr	l0031
	move.w	#2,-(a7)		;physbase
	trap	#$e
	addq.l	#6,a7
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
	clr.l	-(a7)
	pea	l00b2
	move.w	#6,-(a7)		;setpallete
	trap	#$e
	addq.l	#6,a7
	move.w	#$20,-(a7)		;super
	trap	#1
	addq.l	#6,a7
	move.l	d0,-(a7)
	move.b	#$e,$484.l
	moveq	#1,d0
	jsr	l004f
	move.l	#l0050,$4d2.w
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
	move.w	#$ff,-(a7)
	move.w	#6,-(a7)		;crawio
	trap	#1
	addq.l	#4,a7
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
	move	#$2700,sr
	lea	8.w,a1
	lea	l000a(pc),a0
	moveq	#9,d7
l0009	move.l	(a0)+,(a1)+
	dbf	d7,l0009
	jmp	$12.w
l000a	ori.b	#$c,d0
	movea.l	4.w,a0
	jmp	(a0)
	move.w	#$20,-(a7)		;super
	trap	#1
	addq.l	#6,a7
	clr.l	-(a7)
	trap	#1
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
l000e	move.w	#2,-(a7)
	move.w	#2,-(a7)		;bconin
	trap	#$d
	addq.l	#4,a7
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

l0014	move.w	#8,-(a7)
	move.w	#$40,-(a7)
	move.w	#$1c,-(a7)		;giaccess
	trap	#$e
	addq.w	#6,a7
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
	move.w	#9,-(a7)
	move.w	#$40,-(a7)
	move.w	#$1c,-(a7)		;giaccess
	trap	#$e
	addq.w	#6,a7
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
	move.w	#$a,-(a7)
	move.w	#$40,-(a7)
	move.w	#$1c,-(a7)		;giaccess
	trap	#$e
	addq.w	#6,a7
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
l001a	move.w	#$25,-(a7)		;vsync
	trap	#$e
	addq.w	#2,a7
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
l0024	dc.b	'3',$fc,$00,$01
	dc.l	l00ce
l0025	dc.b	$a0,$00,'3',$fc,$00,$10
	dc.l	l00b7
	dc.b	'3',$fc,$00,$19
	dc.l	l00b8
	dc.b	'3',$fc,$00,$04
	dc.l	l00b9
	dc.b	'3',$fc,$00,$0f
	dc.l	l00ba
	dc.b	'3',$fc,$00,$00
	dc.l	l00bb
	dc.b	'#',$fc,$03,$03,$03,$03
	dc.l	l00bc
	dc.b	'3',$dc
	dc.l	l00bd
	dc.b	'3',$fc,$00,$00
	dc.l	l00be
	dc.b	'#',$fc
	dc.l	l0033
	dc.l	l00bf
	dc.b	'3',$fc,$00,$08
	dc.l	l00c0
	dc.b	'3',$fc,$00,$a0
	dc.l	l00c1
	dc.b	'3',$fc,$00,$02
	dc.l	l00c2
	dc.b	'3',$fc,$01,'0'
	dc.l	l00c3
	dc.b	'3',$f9
	dc.l	l00cd
	dc.l	l00c4
	dc.b	'#',$f9
	dc.l	l00b5
	dc.l	l00c5
	dc.b	'3',$fc,$00,$08
	dc.l	l00c6
	dc.b	'3',$fc,$00,$a0
	dc.l	l00c7
	dc.b	'3',$fc,$00,$02
	dc.l	l00c8
	dc.b	'#',$fc,$00,$00,$00,$00
	dc.l	l00c9
	dc.b	'M',$f9
	dc.l	l00b7
	dc.b	$a0,$07
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
	move	sr,d0
	move	#$2700,sr
	move.l	$70.l,l00b6
	move.l	#l0027,$70.l
	move.l	#l002a,$120.l
	ori.b	#1,$fffffa13.l
	move	d0,sr
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
	move.l	l00b6,-(a7)
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
	move.w	#0,-(a7)
	move.w	#$16,-(a7)		;settime
	trap	#$e
	addq.l	#8,a7
	rts

l0032	pea	l00b4
	move.w	#0,-(a7)
	move.w	#$16,-(a7)		;settime
	trap	#$e
	addq.l	#8,a7
	rts

l0033	dcb.w	4
	dc.b	$00,$d0,$17,$c8,$18,'8',$1f,$f8
	dc.b	'r',$13,$8e,$1c,$01,$e0,$ff,$ff
	dc.b	$9c,$d8,'|',$c0,$03,'8',$ff,$f8
	dc.b	$07,$19,$0b,$1e,$0c,$e0,$0f,$ff
	dc.b	$c6,$9e,'>',$e0,$01,$02,$ff,$fe
	dc.b	$f7,'>',$f8,$ff,$00,$00,$ff,$ff
	dc.b	'y@',$87,' ',$00,$e0,$ff,$e0
	dc.b	$07,$ef,$0b,$f0,$0c,$00,$0f,$ff
	dc.b	'fr',$e7,$8c,$18,$00,$ff,$fe
	dc.b	$07,$ef,$0b,$f0,$0c,$00,$0f,$ff
	dc.b	'fr',$e7,$8c,$18,$00,$ff,$fe
	dc.b	$07,$ef,$0b,$f0,$0c,$00,$0f,$ff
	dc.b	'fr',$e7,$8c,$18,$02,$ff,$fe
	dc.b	$e7,$80,$f8,$00,$00,'`',$ff,$e0
	dc.b	$0e,'v',$09,$f0,$00,$0e,$0f,$fe
	dc.b	'Q ',$b1,$c0,$0e,' ',$ff,$e0
	dc.b	$06,$18,$08,$06,$0f,$fe,$0f,$fe
	dcb.w	4
	dc.b	'Q ',$b1,$c0,$0e,' ',$ff,$e0
	dcb.w	4
	dc.b	'6',$88,$19,$84,' |?',$fc
	dc.b	';3G<',$80,$c0,$ff,$ff
	dc.b	's',$98,$f3,$f4,$0c,$0c,$ff,$fc
	dc.b	$17,$93,'+',$9c,'0`?',$ff
	dc.b	$cc,$bc,'<',$c2,$03,$06,$ff,$fe
	dc.b	$f3,'<|',$ff,$80,$00,$ff,$ff
	dc.b	'q',$b0,$8f,$e8,$00,$18,$ff,$f8
	dc.b	$17,$f7,'+',$f8,'0',$00,'?',$ff
	dc.b	'&',$e6,$e7,$18,$18,$06,$ff,$fe
	dc.b	$17,$f7,'+',$f8,'0',$00,'?',$ff
	dc.b	'&',$e6,$e7,$18,$18,$06,$ff,$fe
	dc.b	$17,$f7,'+',$f8,'0',$00,'?',$ff
	dc.b	'&',$e4,$e7,$1a,$18,$06,$ff,$fe
	dc.b	$f3,'@|',$80,$80,'`',$ff,$e0
	dc.b	$0b,'d',$0c,$e2,$00,$1e,$0f,$fe
	dc.b	'+@[',$a0,$84,'`',$ff,$e0
	dc.b	$0b,'0',$0c,$0e,$07,$fe,$0f,$fe
	dcb.w	4
	dc.b	'+@[',$a0,$84,'`',$ff,$e0
	dcb.w	4
	dc.b	'N',$bc,'1',$b8,'@D',$7f,$fc
	dc.b	$1d,$f4,'#',$fb,$c0,$00,$ff,$ff
	dc.b	'w4',$f7,$f0,$08,$0c,$ff,$fc
	dc.b	'-',$b9,'S',$be,'`@',$7f,$ff
	dc.b	$99,'xy',$86,$06,$0e,$ff,$fe
	dc.b	$fa,'<=',$ff,$c0,$00,$ff,$ff
	dc.b	'c',$e8,$9f,$90,$00,$08,$ff,$f8
	dc.b	'-',$f9,'S',$fe,'`',$00,$7f,$ff
	dc.b	$ad,$ca,'n4',$10,$0e,$ff,$fe
	dc.b	'-',$f9,'S',$fe,'`',$00,$7f,$ff
	dc.b	$ad,$ca,'n4',$10,$0e,$ff,$fe
	dc.b	'-',$f9,'S',$fe,'`',$00,$7f,$ff
	dc.b	$ad,$c8,'n6',$10,$0e,$ff,$fe
	dc.b	$fa,$a0,'=@',$c0,$e0,$ff,$e0
	dc.b	$0d,'H',$0e,$c6,$00,'>',$0f,$fe
	dc.b	$0a,$80,';`',$c4,$e0,$ff,$e0
	dc.b	$0d,$e0,$0e,$1e,$03,$fe,$0f,$fe
	dcb.w	4
	dc.b	$0a,$80,';`',$c4,$e0,$ff,$e0
	dcb.w	4
	dc.b	$84,'<{',$f0,$80,$0c,$fc,'<'
	dc.b	$80,$00,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$00,',',$ff,$e2,$00,$1e,$00,'>'
	dc.b	'L',$00,'3',$ff,'@',$00,'~',$00
	dc.b	$00,$02,$ff,$fc,$00,$0e,$00,$0e
	dc.b	'`',$00,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$00,'X',$ff,$bc,$00,$04,$00,$fc
	dc.b	'L',$00,'3',$ff,'@',$00,'~',$00
	dc.b	$00,$02,$ff,$fc,$00,$0e,$00,$0e
	dc.b	'L',$00,'3',$ff,'@',$00,'~',$00
	dc.b	$00,$02,$ff,$fc,$00,$0e,$00,$0e
	dc.b	'L',$00,'3',$ff,'@',$00,'~',$00
	dc.b	$00,$00,$ff,$fe,$00,$0e,$00,$0e
	dc.b	'`@',$1f,$80,$e0,$e0,$e0,$e0
	dc.b	$06,$00,$0f,$fe,$00,$0e,$0e,$0e
	dc.b	$80,$00,$1f,$e0,$e0,$e0,$e0,$e0
	dc.b	$0e,$00,$0f,$fe,$00,$0e,$0e,$0e
	dcb.w	4
	dc.b	$80,$00,$1f,$e0,$e0,$e0,$e0,$e0
	dc.b	$00,$01,$00,$00,$00,$01,$00,$01
	dc.b	$ef,$f8,$ff,$e6,$00,$1e,$f0,$1e
	dc.b	$df,$ff,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fe,$ff,$e0,$00,$1e,$00,$1e
	dc.b	$27,$ff,$df,$ff,$80,$00,$f8,$00
	dc.b	$ff,$f6,$ff,$f8,$00,$0e,$00,$0e
	dc.b	'?',$ff,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$f4,$ff,$f0,$00,$0c,$00,'<'
	dc.b	$27,$ff,$df,$ff,$80,$00,$f8,$00
	dc.b	$ff,$f6,$ff,$fa,$00,$0c,$00,$0e
	dc.b	$27,$ff,$df,$ff,$80,$00,$f8,$00
	dc.b	$ff,$f6,$ff,$fa,$00,$0c,$00,$0e
	dc.b	$27,$ff,$df,$ff,$80,$00,$f8,$00
	dc.b	$ff,$f6,$ff,$f8,$00,$0e,$00,$0e
	dc.b	'?',$80,$1f,$00,$e0,$e0,$e0,$e0
	dc.b	$03,$f0,$0f,$fe,$00,$0e,$0e,$0e
	dc.b	$df,$00,$1f,$e0,$e0,$e0,$e0,$e0
	dc.b	$0f,$f0,$0f,$fe,$00,$0e,$0e,$0e
	dcb.w	4
	dc.b	$df,$00,$1f,$e0,$e0,$e0,$e0,$e0
	dc.b	$00,$03,$00,$01,$00,$02,$00,$03
	dc.b	$e0,$00,$ff,$fe,$00,$0e,$e0,$0e
	dc.b	$e0,$00,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$00,$08,$ff,$f6,$00,$0e,$00,$0e
	dc.b	$b0,$00,'O',$ff,$80,$00,$f0,$00
	dc.b	$00,$0e,$ff,$f0,$00,$0e,$00,$0e
	dc.b	' ',$00,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$00,$0c,$ff,$e0,$00,$1c,$00,$1c
	dc.b	$b0,$00,'O',$ff,$80,$00,$f0,$00
	dc.b	$00,$0a,$ff,$f2,$00,$0c,$00,$0e
	dc.b	$b0,$00,'O',$ff,$80,$00,$f0,$00
	dc.b	$00,$0a,$ff,$f2,$00,$0c,$00,$0e
	dc.b	$b0,$00,'O',$ff,$80,$00,$f0,$00
	dc.b	$00,$08,$ff,$f0,$00,$0e,$00,$0e
	dc.b	' ',$c0,$1f,$00,$e0,$e0,$e0,$e0
	dc.b	$08,$00,$07,$fe,$00,$0e,$0e,$0e
	dc.b	$e0,' ',$1f,$c0,$e0,$e0,$e0,$e0
	dc.b	$0a,$02,$0f,$fc,$00,$0e,$0e,$0e
	dcb.w	4
	dc.b	$e0,' ',$1f,$c0,$e0,$e0,$e0,$e0
	dc.b	$00,$05,$00,$03,$00,$04,$00,$07
	dc.b	$ff,$f2,$ff,$fc,$00,$0e,$c0,$0e
	dc.b	$9f,$ff,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$f0,$ff,$fe,$00,$0e,$00,$0e
	dc.b	$cf,$ff,$ff,$ff,$00,$00,$f0,$00
	dc.b	$ff,$f2,$ff,$fc,$00,$0e,$00,$0e
	dc.b	$9f,$ff,$9f,$ff
	bra	l0002
	dc.b	$ff,$f8,$ff,$e6,$00,$1e,$00,$1e
	dc.b	$cf,$ff,$7f,$ff,$80,$00,$f0,$00
	dc.b	$ff,$f2,$ff,$f0,$00,$0e,$00,$0e
	dc.b	$cf,$ff,$7f,$ff,$80,$00,$f0,$00
	dc.b	$ff,$f2,$ff,$f0,$00,$0e,$00,$0e
	dc.b	$cf,$ff,$ff,$ff,$00,$00,$f0,$00
	dc.b	$ff,$f0,$ff,$f0,$00,$0e,$00,$0e
	dc.b	$9f,'`',$9f,$80,'`',$e0,$e0,$e0
	dc.b	$0f,$f2,$01,$fc,$00,$0e,$0e,$0e
	dc.b	'?`',$1f,$80,$e0,$e0,$e0,$e0
	dc.b	$01,$f2,$0f,$fc,$00,$0e,$0e,$0e
	dcb.w	4
	dc.b	'?`',$1f,$80,$e0,$e0,$e0,$e0
	dc.b	$00,$08,$00,$07,$00,$08,$00,$0f
	dc.b	$00,$06,$80,$08,$7f,$fe,$80,$0e
	dcb.w	2
	dc.b	$ff,$ff,$e0,$00,$00,$00,$00,$0e
	dc.b	$ff,$fe,$00,$0e,'`',$00,'`',$00
	dc.b	$9f,$ff,$e0,$00,$00,$00,$00,$0e
	dc.b	$ff,$fe,$00,$0e,$c0,$00,$c0,$00
	dc.b	'?',$ff,$e0,$00,$00,$00,$00,$0e
	dc.b	$ff,$fe,$00,$0e,$e0,$00,'`',$00
	dc.b	$9f,$ff,$e0,$00,$00,$0e,$00,$00
	dc.b	$ff,$fe,$00,$0e,$e0,$00,'`',$00
	dc.b	$9f,$ff,$e0,$00,$00,$0e,$00,$00
	dc.b	$ff,$fe,$00,$0e,'`',$00,'`',$00
	dc.b	$9f,$ff,$e0,$00,$00,$0e,$00,$00
	dc.b	$ff,$fe,$00,$0e,$c0,'3',$c0,$dc
	dc.b	'?',$e0,$e0,$ff,'f',$06,$e0,$08
	dc.b	$19,$fe,$fe,$0e,$00,$c0,$00,$00
	dc.b	$ff,$e0,$e0,$e0,$00,$02,$0e,$0c
	dc.b	$01,$fe,$0e,$0e,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$c0,$00,$00,$ff,$e0,$e0,$e0
	dc.b	$00,$1f,$00,$00,$00,$10,$00,$1f
	dc.b	$ff,$fe,$ff,$f0,$00,$0e,$00,$0e
	dc.b	$e0,$00,$1f,$ff,$ff,$ff,$ff,$ff
	dc.b	$03,$f0,$fd,$fe,$fe,$0e,$fe,$0e
	dc.b	$7f,$83,$7f,$fc,$80,$7f,$e0,$7f
	dc.b	$cf,$00,'0',$0e,$ff,$fe,$ff,$fe
	dc.b	$df,$00,$df,$ff,' ',$ff,$e0,$ff
	dc.b	$0f,$f2,$f3,$fc,$fc,$0e,$fc,$0e
	dc.b	$7f,$80,$7f,$ff,$80,$7f,$e0,$7f
	dc.b	$00,$02,$ff,$fc,$ff,$fe,$ff,$fe
	dc.b	$7f,$80,$7f,$ff,$80,$7f,$e0,$7f
	dc.b	$00,$02,$ff,$fc,$ff,$fe,$ff,$fe
	dc.b	$7f,$c0,$7f,$bf,$80,$7f,$e0,$7f
	dc.b	'?',$00,$c0,$fe,$ff,$fe,$ff,$fe
	dc.b	$df,'o',$df,$b0,' ',$c0,$e0,$ff
	dc.b	'c',$fe,$e1,$f0,$1c,$0e,$fe,$0e
	dc.b	'_',$80,'_',$00,$a0,$e0,$e0,$e0
	dc.b	$01,$f6,$0f,$f8,$00,$0e,$0e,$0e
	dcb.w	4
	dc.b	$bf,' ',$ff,$c0,$00,$e0,$e0,$e0
	dc.b	$00,'>',$00,$00,$00,'!',$00,'>'
	dc.b	$00,$0a,$06,$00,$ff,$fe,$06,$0e
	dc.b	$e7,$8d,$87,$f3,'x',$00,$ff,$ff
	dc.b	'j',$00,'v',$0e,$81,$fe,$fe,$0e
	dc.b	' ',$0c,' ',$f0,$df,$ff,$e0,$ff
	dc.b	'a',$c0,$1e,$06,$ff,$fe,$ff,$fe
	dc.b	$c0,$80,$c0,$7f,'?',$ff,$e0,$ff
	dc.b	$f8,$06,$02,$08,$fd,$fe,$fe,$0e
	dc.b	' < C',$df,$80,$e0,$ff
	dc.b	$af,'"',$b0,$ec,'@',$1e,$ff,$fe
	dc.b	' < C',$df,$80,$e0,$ff
	dc.b	$af,'"',$b0,$ec,'@',$1e,$ff,$fe
	dc.b	' ',$de,' ',$01,$df,$e0,$e0,$ff
	dc.b	'9',$ca,$fe,'$',$00,$1e,$ff,$fe
	dc.b	$c0,$e7,$c0,'x?',$80,$e0,$ff
	dc.b	$b8,$0a,'x',$00,$07,$fe,$fe,$0e
	dc.b	$e0,$80,$e0,$00,$1f,$e0,$e0,$e0
	dc.b	$08,$06,$06,$08,$01,$fe,$0e,$0e
	dcb.w	4
	dc.b	$e0,$00,$e0,$e0,$1f,$e0,$e0,$e0
	dc.b	$00,$7f,$00,$00,$00,'C',$00,'|'
	dc.b	$ff,$f0,$02,$00,$fd,$fe,$0e,$0e
	dc.b	$df,$ff,$c0,$00,'?',$ff,$e0,$00
	dc.b	$ff,$f0,$00,$0e,$ff,$fe,$00,$0e
	dc.b	'?',$03,' ',$fc,$df,$ff,$e0,$ff
	dc.b	$80,$e0,$7f,$02,$ff,$fe,$ff,$fe
	dc.b	'?',$c3,$e0,'<',$1f,$ff,$e0,$ff
	dc.b	$13,$f8,$04,$00,$f9,$fe,$fe,$0e
	dc.b	'?',$ff,' ',$00,$df,$ff,$e0,$00
	dc.b	$ff,$f2,$00,$0c,$ff,$fe,$00,$0e
	dc.b	'?',$ff,' ',$00,$df,$ff,$e0,$00
	dc.b	$ff,$f2,$00,$0c,$ff,$fe,$00,$0e
	dc.b	'?',$ef,'  ',$df,$df,$e0,$f0
	dc.b	$ff,$f6,$00,$08,$ff,$fe,$00,$0e
	dc.b	'?',$ff,$e0,$00,$1f,$ff,$e0,$00
	dc.b	$ff,$f0,$00,$00,$ff,$fe,$00,$0e
	dc.b	$ff,$80,$e0,$00,$1f,$e0,$e0,$e0
	dc.b	$0d,$fc,$02,$00,$01,$fe,$0e,$0e
	dcb.w	4
	dc.b	$ff,$00,$e0,$e0,$1f,$e0,$e0,$e0
	dc.b	$00,$b8,$00,'@',$00,$87,$00,$f8
	dc.b	$0a,$04,$12,$04,$fd,$fa,$1e,$0e
	dc.b	$e0,$00,$e0,$00,$1f,$ff,$e0,$00
	dc.b	$00,$00,$00,$1e,$ff,$fe,$00,$1e
	dc.b	$80,$00,$80,$e0,$7f,$e0,$e0,$e0
	dcb.w	4
	dc.b	'@',$e0,$a0,$00,$1f,$e0,$e0,$e0
	dc.b	$06,$08,$08,$00,$01,$fe,$0e,$0e
	dc.b	$80,$00,$80,$00,$7f,$ff,$e0,$00
	dc.b	$00,$06,$00,$08,$ff,$fe,$00,$0e
	dc.b	$80,$00,$80,$00,$7f,$ff,$e0,$00
	dc.b	$00,$06,$00,$08,$ff,$fe,$00,$0e
	dc.b	$80,'p',$80,$b0,$7f,$cf,$e0,$f0
	dc.b	$00,$0c,$00,$00,$ff,$fe,$00,$0e
	dc.b	'@',$00,$a0,$00,$1f,$ff,$e0,$00
	dc.b	$00,$04,$00,$04,$ff,$fa,$00,$0e
	dc.b	$a0,$80,$e0,$00,$1f,$e0,$e0,$e0
	dc.b	$0e,$0c,$00,$00,$01,$fe,$0e,$0e
	dcb.w	4
	dc.b	$de,$00,$e1,$e0,'?',$e0,$ff,$e0
	dc.b	$01,'?',$00,$c0,$01,$0f,$01,$f0
	dc.b	$c1,$f4,'>',$04,$f9,$fa,'>',$0e
	dc.b	$bf,$ff,$e0,$00,$1f,$ff,$e0,$00
	dc.b	$ff,$cc,$00,'0',$ff,$fc,$00,'<'
	dc.b	'_',$00,$c0,$e0,'?',$e0,$e0,$e0
	dcb.w	4
	dc.b	'_',$80,$a0,'`',$1f,$e0,$e0,$e0
	dc.b	$07,$f8,$08,$00,$01,$fe,$0e,$0e
	dc.b	'_',$ff,$c0,$00,'?',$ff,$e0,$00
	dc.b	$ff,$fc,$00,$00,$ff,$fe,$00,$0e
	dc.b	'_',$ff,$c0,$00,'?',$ff,$e0,$00
	dc.b	$ff,$fc,$00,$00,$ff,$fe,$00,$0e
	dc.b	'__',$c0,$b0,'?',$cf,$e0,$f0
	dc.b	$ff,$f8,$00,$00,$ff,$fe,$00,$0e
	dc.b	'_',$ff,$a0,$00,$1f,$ff,$e0,$00
	dc.b	$ff,$f4,$00,$04,$ff,$fa,$00,$0e
	dc.b	$1f,$80,$e0,$00,$1f,$e0,$e0,$e0
	dc.b	$07,$f8,$08,$00,$01,$fe,$0e,$0e
	dcb.w	4
	dc.b	$b3,$00,$c0,$e0,$7f,$e0,$ff,$e0
	dc.b	$03,' ',$01,$df,$02,$1f,$03,$e0
	dc.b	$14,$00,$ef,$f0,$f1,$fe,'~',$0e
	dc.b	$00,$00,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$00,$06,$ff,$e0,$ff,$fe,$00,$1e
	dc.b	' `',$ff,$90,$1f,$f0,$e0,$f0
	dcb.w	4
	dc.b	$e0,$00,$1f,$e0,$1f,$e0,$e0,$e0
	dc.b	$0a,$08,$0d,$f0,$01,$fe,$0e,$0e
	dc.b	' ',$00,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$00,$04,$ff,$f8,$ff,$fe,$00,$0e
	dc.b	'`',$00,$df,$ff,$1f,$ff,$e0,$00
	dc.b	$00,$04,$ff,$f8,$ff,$fe,$00,$0e
	dc.b	'  ',$ff,$df,$1f,$cf,$e0,$f0
	dc.b	$00,$00,$ff,$f0,$ff,$fe,$00,$0e
	dc.b	$e0,$00,$1f,$ff,$1f,$ff,$e0,$00
	dc.b	$00,$00,$ff,$f0,$ff,$fe,$00,$0e
	dc.b	'@',$c0,$bf,$00,$1f,$e0,$e0,$e0
	dc.b	$0a,$08,$0d,$f0,$01,$fe,$0e,$0e
	dcb.w	4
	dc.b	'a',$80,$80,'`',$ff,$e0,$ff,$e0
	dc.b	$07,'?',$03,$c0,$04,'?',$07,$c0
	dc.b	$0f,$fa,$de,$00,$e1,$fe,$fe,$0e
	dc.b	'_',$ff,$a0,$00,$1f,$ff,$e0,$00
	dc.b	$ff,$fc,$00,$02,$ff,$fe,$00,$0e
	dc.b	$df,$c8,' ',$0f,$1f,$f0,$e0,$ff
	dc.b	'a',$c8,$9f,$f4,$00,$02,$ff,$fe
	dc.b	$ff,'2',$00,$dd,$1f,$e0,$e0,$ff
	dc.b	'm',$fa,$ee,$00,$11,$fe,$fe,$0e
	dc.b	$df,$ff,' ',$00,$1f,$ff,$e0,$00
	dc.b	$ff,$f0,$00,$0c,$ff,$fe,$00,$0e
	dc.b	$ff,$ff,$80,$00,$1f,$ff,$e0,$00
	dc.b	$ff,$f0,$00,$0c,$ff,$fe,$00,$0e
	dc.b	$df,'? ',$c0,$1f,$cf,$e0,$f0
	dc.b	$ff,$f8,$00,$00,$ff,$fe,$00,$0e
	dc.b	$ff,$ff,$00,$00,$1f,$ff,$e0,$00
	dc.b	$ff,$fa,$00,$00,$ff,$fe,$00,$0e
	dc.b	$ff,$c0,$00,$00,$1f,$e0,$e0,$e0
	dc.b	$15,$f8,'f',$00,$f9,$fe,$fe,$0e
	dc.b	'Q ',$b1,$c0,$0e,' ',$ff,$e0
	dc.b	'Q ',$b1,$c0,$0e,' ',$ff,$e0
	dc.b	$0b,$80,$07,$ff,$08,$7f,$0f,$80
	dc.b	$00,$0e,$ff,$f0,$ff,$fe,$00,$0e
	dc.b	$e0,$1c,$1f,$e3,$1f,$ff,$e0,$ff
	dc.b	$00,$00,$ff,$fe,$ff,$fe,$fe,$0e
	dc.b	$e0,$98,$1f,$1f,$1f,$e0,$e0,$ff
	dc.b	$f3,$90,$0f,$ea,$00,$06,$ff,$fe
	dc.b	$c0,'w?',$b8,$1f,$c0,$e0,$ff
	dc.b	'd',$06,$e7,$f8,$19,$fe,$fe,$0e
	dc.b	$e0,$00,$1f,$ff,$1f,$ff,$e0,$ff
	dc.b	$00,$02,$ff,$fe,$ff,$fc,$ff,$fe
	dc.b	$c0,$19,'?',$e1,$1f,$fe,$e0,$ff
	dc.b	$e6,'8',$e0,'6',$1f,$ce,$ff,$fe
	dc.b	$e0,' ',$1f,$cf,$1f,$df,$e0,$ff
	dc.b	$f8,$0c,$07,$f0,$ff,$fe,$fe,$0e
	dc.b	$c0,$1c,'?',$e0,$1f,$ff,$e0,$ff
	dc.b	$02,$0e,$01,$f0,$ff,$fe,$fe,$0e
	dc.b	$e0,'`',$1f,$80,$1f,$e0,$e0,$e0
	dc.b	$88,$06,$b3,$f8,'}',$fe,$fe,$0e
	dc.b	'+@[',$a0,$84,'`',$ff,$e0
	dc.b	'+@[',$a0,$84,'`',$ff,$e0
	dc.b	$13,$ff,$0f,$ff,$10,$ff,$1f,$00
	dc.b	$ff,$f6,$ff,$f8,$ff,$fe,$00,$0e
	dc.b	$ff,$cf,$1f,$f0,$1f,$00,$e0,$ff
	dc.b	'9',$f0,$ff,$fe,$01,$fe,$fe,$0e
	dc.b	$df,$bc,'?',$bf,$1f,$c0,$e0,$7f
	dc.b	'r ',$8f,$d6,$00,$0e,$ff,$fe
	dc.b	'_',$cf,$bf,'p',$1f,$80,$e0,$ff
	dc.b	$13,$f4,$f3,$fa,$0f,$fe,$fc,$0e
	dc.b	$df,$a7,'?',$b8,$1f,$c0,$e0,$7f
	dc.b	'8',$e6,$ff,$ea,$00,$1c,$ff,$fe
	dc.b	'_',$0c,$bf,$f0,$1f,$ff,$e0,$ff
	dc.b	$9f,$9c,$80,$1a,$7f,$e6,$ff,$fe
	dc.b	$df,$87,'?',$f8,$1f,$80,$e0,$7f
	dc.b	$b3,$fc,$7f,$f0,$01,$fe,$fe,$0e
	dc.b	'_',$07,$bf,$f8,$1f,$ff,$e0,$ff
	dc.b	$0f,$f6,$03,$f8,$fd,$fe,$fe,$0e
	dc.b	'_`',$bf,$80,$1f,$e0,$e0,$e0
	dc.b	$c7,$f2,$db,$fc,'?',$fe,$fc,$0e
	dc.b	$0a,$80,';`',$c4,$e0,$ff,$e0
	dc.b	$0a,$80,';`',$c4,$e0,$ff,$e0
	dc.b	'"',$00,$1f,$ff,'!',$ff,'>',$00
	dc.b	$00,$02,$ff,$fc,$ff,$fe,$00,$0e
	dc.b	'@',$00,$bf,$ff,$1f,$ff,$e0,$00
	dc.b	$00,$00,$ff,$fe,$ff,$fe,$00,$0e
	dc.b	$00,$00,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$00,$00,$ff,$fe,$ff,$fe,$00,$0e
	dc.b	' ',$00,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$00,$00,$ff,$fe,$ff,$fe,$00,$0e
	dc.b	$00,$00,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$00,$0e,$ff,$f2,$ff,$fc,$00,$0e
	dc.b	' ',$84,$ff,'x',$1f,$ff,$e0,$ff
	dc.b	'0',$ce,$0f,$0c,$ff,$f2,$ff,$fe
	dc.b	$00,$00,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$00,$06,$ff,$f8,$ff,$fe,$00,$0e
	dc.b	' ',$81,$ff,'~',$1f,$ff,$e0,$ff
	dc.b	$bc,$02,$07,$fc,$f9,$fe,$fe,$0e
	dc.b	$00,' ',$ff,$c0,$1f,$e0,$e0,$e0
	dc.b	' ',$00,'?',$fe,$df,$fe,$e0,$0e
	dc.b	$80,$00,$1f,$e0,$ff,$e0,$e0,$e0
	dc.b	$80,$00,$1f,$e0,$ff,$e0,$e0,$e0
	dc.b	's',$fc,'?',$f0,'C',$ff,'|',$0f
	dc.b	$03,$f2,$01,$fc,$ff,$fe,$fe,$0e
	dc.b	$1f,$ff,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$ff,$f0,$ff,$fe,$ff,$fe,$00,$0e
	dc.b	$bf,$ff,$ff,$ff,$0f,$ff,$f0,$00
	dc.b	$ff,$f2,$ff,$fc,$ff,$fe,$00,$0e
	dc.b	$ff,$ff,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$ff,$e0,$ff,$fe,$ff,$fe,$00,$1e
	dc.b	$bf,$ff,$ff,$ff,$0f,$ff,$f0,$00
	dc.b	$ff,$fc,$ff,$f0,$ff,$fe,$00,$0e
	dc.b	$ff,$c0,$ff,' ',$1f,$e0,$e0,$e0
	dcb.w	4
	dc.b	$bf,$ff,$ff,$ff,$0f,$ff,$f0,$00
	dc.b	$ff,$f6,$ff,$f8,$ff,$fe,$00,$0e
	dc.b	$ff,$c0,$ff,' ',$1f,$e0,$e0,$e0
	dc.b	$0b,$f2,$0d,$fc,$01,$fe,$0e,$0e
	dc.b	$1f,' ',$ff,$c0,$1f,$e0,$e0,$e0
	dc.b	$9f,$f8,$1f,$e6,$ff,$fe,$e0,$1e
	dc.b	$df,$00,$1f,$e0,$ff,$e0,$e0,$e0
	dc.b	$df,$00,$1f,$e0,$ff,$e0,$e0,$e0
	dc.b	$9f,$e7,$7f,$f8,$87,$ff,$f8,$1f
	dc.b	$0f,$f0,$03,$fe,$fd,$fe,$fe,$0e
	dc.b	$1f,$ff,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$ff,$f8,$ff,$f6,$ff,$fe,$00,$0e
	dc.b	$ef,$ff,'o',$ff,$9f,$ff,$f0,$00
	dc.b	$ff,$f6,$ff,$f8,$ff,$fe,$00,$0e
	dc.b	$df,$ff,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$ff,$f0,$ff,$ec,$ff,$fc,$00,$1c
	dc.b	$ef,$ff,'o',$ff,$9f,$ff,$f0,$00
	dc.b	$ff,$f8,$ff,$f4,$ff,$fe,$00,$0e
	dc.b	$df,'`',$ff,$00,$1f,$e0,$e0,$e0
	dcb.w	4
	dc.b	$ef,$ff,'o',$ff,$9f,$ff,$f0,$00
	dc.b	$ff,$f2,$ff,$fc,$ff,$fe,$00,$0e
	dc.b	$df,'`',$ff,$00,$1f,$e0,$e0,$e0
	dc.b	$0f,$f0,$01,$fe,$01,$fe,$0e,$0e
	dc.b	$bf,' ',$ff,$c0,$1f,$e0,$e0,$e0
	dc.b	$ff,$ee,$1f,$e0,$ff,$fe,$e0,$1e
	dc.b	$7f,' ',$1f,$c0,$ff,$e0,$e0,$e0
	dc.b	$7f,' ',$1f,$c0,$ff,$e0,$e0,$e0
	dc.b	$8f,$c1,$ff,$fe,$0f,$ff,$f0,'?'
	dc.b	$bd,$f0,$07,$fe,$f9,$fe,$fe,$0e
	dc.b	$bf,$ff,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$ff,$fe,$ff,$e0,$ff,$fe,$00,$1e
	dc.b	'O',$ff,$cf,$ff,$b7,$ff,$f8,$00
	dc.b	$ff,$fc,$ff,$f0,$ff,$fe,$00,$0e
	dc.b	$bf,$ff,$df,$ff,$1f,$ff,$e0,$00
	dc.b	$ff,$d8,$ff,$c4,$ff,$fc,$00,'<'
	dc.b	'O',$ff,$cf,$ff,$b7,$ff,$f8,$00
	dc.b	$ff,$f0,$ff,$fc,$ff,$fe,$00,$0e
	dc.b	$bf,' ',$df,$00,$1f,$e0,$e0,$e0
	dcb.w	4
	dc.b	'O',$ff,$cf,$ff,$b7,$ff,$f8,$00
	dc.b	$ff,$f2,$ff,$fc,$ff,$fe,$00,$0e
	dc.b	$bf,' ',$df,$00,$1f,$e0,$e0,$e0
	dc.b	$0d,$f0,$03,$fe,$01,$fe,$0e,$0e
	dc.b	$ff,$00,$ff,$e0,$1f,$e0,$e0,$e0
	dc.b	$df,$f4,$1f,$f0,$ff,$cc,$e0,'<'
	dc.b	'?`',$1f,$80,$ff,$e0,$e0,$e0
	dc.b	'?`',$1f,$80,$ff,$e0,$e0,$e0
	dc.b	$7f,$80,$7f,$f8,$9f,$f8,$e0,'x'
	dc.b	$0b,$f0,$0d,$fe,$01,$fe,$0e,$0e
	dc.b	$ff,$ff,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$ff,$e4,$ff,$c2,$ff,$fe,$00,'>'
	dc.b	'S',$ff,$1f,$ff,'a',$ff,'~',$00
	dc.b	$ff,$f0,$ff,$f0,$ff,$fe,$00,$0e
	dc.b	'_',$ff,$bf,$ff,$1f,$ff,$e0,$00
	dc.b	$ff,$c8,$ff,$04,$ff,$fc,$00,$fc
	dc.b	'S',$ff,$1f,$ff,'a',$ff,'~',$00
	dc.b	$ff,$f0,$ff,$fc,$ff,$fe,$00,$0e
	dc.b	'_ ',$bf,$00,$1f,$e0,$e0,$e0
	dcb.w	4
	dc.b	'S',$ff,$1f,$ff,'a',$ff,'~',$00
	dc.b	$ff,$f0,$ff,$fe,$ff,$fe,$00,$0e
	dc.b	'_ ',$bf,$00,$1f,$e0,$e0,$e0
	dc.b	$0b,$f0,$07,$fe,$01,$fe,$0e,$0e
	dc.b	$ff,$00,$ff,$e0,$1f,$e0,$e0,$e0
	dc.b	$9f,'X',$1f,$bc,$ff,$04,$e0,$fc
	dc.b	$9f,$00,$9f,$e0,$7f,$e0,$e0,$e0
	dc.b	$9f,$00,$9f,$e0,$7f,$e0,$e0,$e0
	dc.b	$8c,$00,'0',$f0,$ff,$f0,$ff,$f0
	dc.b	$07,$e0,$0c,$0e,$03,$fe,$0f,$fe
	dc.b	$de,$1f,$e1,$e0,'?',$ff,$ff,$ff
	dc.b	$e0,'4',$1f,$c0,$ff,$fc,$ff,$fc
	dc.b	'$',$8f,'\pc',$ff,$7f,$ff
	dc.b	$00,$08,$ff,$f0,$ff,$fe,$ff,$fe
	dc.b	$86,$01,'Y',$fe,'?',$ff,$ff,$ff
	dc.b	$e0,$e0,$1f,$08,$ff,$f8,$ff,$f8
	dc.b	'$#\',$dc,'c',$ff,$7f,$ff
	dc.b	'F08',$0c,$ff,$fe,$ff,$fe
	dc.b	$86,$00,'Y',$80,'?',$e0,$ff,$e0
	dcb.w	4
	dc.b	'$',$0d,'\',$f0,'c',$ff,$7f,$ff
	dc.b	$8f,$00,'p',$0e,$ff,$fe,$ff,$fe
	dc.b	$86,$00,'Y',$80,'?',$e0,$ff,$e0
	dc.b	$07,$e0,$0c,$0e,$03,$fe,$0f,$fe
	dc.b	$de,$00,$e1,$e0,'?',$e0,$ff,$e0
	dc.b	$1b,$e8,$27,$90,$c0,$08,$ff,$f8
	dc.b	$de,$00,$e1,$e0,'?',$e0,$ff,$e0
	dc.b	$de,$00,$e1,$e0,'?',$e0,$ff,$e0
	dc.b	$06,$00,'x`',$ff,$e0,$ff,$e0
	dc.b	$0c,'p',$0b,$86,$07,$fe,$0f,$fe
	dc.b	$b3,$0f,$c0,$f0,$7f,$ff,$ff,$ff
	dc.b	'<',$18,$03,$e0,$ff,$f8,$ff,$f8
	dc.b	$19,'0(',$c0,'7',$ff,'?',$ff
	dc.b	$e0,$04,$1f,$f8,$ff,$fe,$ff,$fe
	dc.b	$0f,$83,$b0,'|',$7f,$ff,$ff,$ff
	dc.b	'8',$e0,$07,$10,$ff,$f0,$ff,$f0
	dc.b	$19,'f(',$98,'7',$ff,'?',$ff
	dc.b	'g',$18,$18,$04,$ff,$fe,$ff,$fe
	dc.b	$0f,$00,$b0,$c0,$7f,$e0,$ff,$e0
	dcb.w	4
	dc.b	$19,'8(',$c0,'7',$ff,'?',$ff
	dc.b	$c3,$c0,'<',$06,$ff,$fe,$ff,$fe
	dc.b	$0f,$00,$b0,$c0,$7f,$e0,$ff,$e0
	dc.b	$0c,'p',$0b,$86,$07,$fe,$0f,$fe
	dc.b	$b3,$00,$c0,$e0,$7f,$e0,$ff,$e0
	dc.b	'9',$b0,'G',$e8,$80,$18,$ff,$f8
	dc.b	$b3,$00,$c0,$e0,$7f,$e0,$ff,$e0
	dc.b	$b3,$00,$c0,$e0,$7f,$e0,$ff,$e0
	dc.b	$81,'@~',$80,$ff,$c0,$ff,$c0
	dc.b	$00,$00,$07,$fe,$07,$fe,$07,$fe
	dc.b	$01,$fc,$fe,$03,$ff,$ff,$ff,$ff
	dc.b	'<@',$c3,$b0,$ff,$f0,$ff,$f0
	dc.b	$0e,'?',$11,$c0,$1f,$ff,$1f,$ff
	dc.b	$00,$02,$ff,$fc,$ff,$fe,$ff,$fe
	dc.b	$11,$f6,'`',$08,$ff,$ff,$ff,$ff
	dc.b	$0c,$00,$03,$c0,$ff,$c0,$ff,$c0
	dc.b	$02,$ec,$05,$10,$07,$ff,$07,$ff
	dc.b	'g',$8c,$18,$00,$ff,$fe,$ff,$fe
	dc.b	$11,$80,'``',$ff,$e0,$ff,$e0
	dcb.w	4
	dc.b	$02,'p',$05,$80,$07,$ff,$07,$ff
	dc.b	'a',$e0,$1e,$02,$ff,$fe,$ff,$fe
	dc.b	$11,$80,'``',$ff,$e0,$ff,$e0
	dc.b	$08,'0',$07,$c2,$0f,$fe,$0f,$fe
	dc.b	'a',$80,$80,'`',$ff,$e0,$ff,$e0
	dc.b	'q@',$8f,' ',$00,$e0,$ff,$e0
	dc.b	'a',$80,$80,'`',$ff,$e0,$ff,$e0
	dc.b	'a',$80,$80,'`',$ff,$e0,$ff,$e0
	dcb.w	80
	dc.b	$f7,$a0,$f8,'@',$00,' ',$ff,$e0
	dc.b	$0e,'8',$09,$fe,$00,$00,$0f,$fe
	dc.b	'Q ',$b1,$c0,$0e,' ',$ff,$e0
	dcb.w	4
	dc.b	$06,'l',$02,'b',$05,$9e,$07,$fe
	dc.b	'#@',$9f,$00,$c0,$c0,$ff,$c0
	dc.b	$00,$f0,$08,$e8,$0f,$18,$0f,$f8
	dc.b	$05,$12,$0b,$1c,$00,$e2,$0f,$fe
	dc.b	$07,'^',$0b,$1f,$0c,$e0,$0f,$ff
	dc.b	'y@',$87,' ',$00,$e0,$ff,$e0
	dc.b	'r',$13,$8e,$1c,$01,$e0,$ff,$ff
	dc.b	$9f,$08,'x0',$07,$c8,$ff,$f8
	dc.b	$07,'^',$0b,$1f,$0c,$e0,$0f,$ff
	dc.b	'y@',$87,' ',$00,$e0,$ff,$e0
	dc.b	'r',$13,$8e,$1c,$01,$e0,$ff,$ff
	dc.b	$9c,$c0,'|',$d0,$03,'0',$ff,$f0
	dc.b	$18,'n(q7',$80,'?',$ff
	dc.b	'vr',$e7,$8c,$18,$02,$ff,$fe
	dc.b	'r',$13,$8e,$1c,$01,$e0,$ff,$ff
	dc.b	$ff,$e0,$1e,'|a',$82,$ff,$fe
	dc.b	$f3,'@|',$a0,$80,'`',$ff,$e0
	dc.b	$0f,'r',$04,$fc,$08,$02,$0f,$fe
	dc.b	'+@[',$a0,$84,'`',$ff,$e0
	dcb.w	4
	dc.b	$1e,'N',$0e,'@',$11,$bf,$1f,$ff
	dc.b	'30',$cf,' ',$00,$d0,$ff,$f0
	dc.b	$1e,$80,'.',$f4,'1',$0c,'?',$fc
	dc.b	$02,$b4,$05,$ba,$08,'F',$0f,$fe
	dc.b	$17,$dc,$0b,$9f,$10,'`',$1f,$ff
	dc.b	'q',$b0,$8f,$e0,$00,$10,$ff,$f0
	dc.b	';3G<',$80,$c0,$ff,$ff
	dc.b	's',$98,$f3,$f4,$0c,$0c,$ff,$fc
	dc.b	$17,$dc,$0b,$9f,$10,'`',$1f,$ff
	dc.b	'q',$b0,$8f,$e0,$00,$10,$ff,$f0
	dc.b	';3G<',$80,$c0,$ff,$ff
	dc.b	's',$98,$f3,$f4,$0c,$0c,$ff,$fc
	dc.b	'lw<xC',$80,$7f,$ff
	dc.b	'&',$e4,$e7,$1a,$18,$06,$ff,$fe
	dc.b	';3G<',$80,$c0,$ff,$ff
	dc.b	'q',$80,$f1,$fa,$0e,$06,$ff,$fe
	dc.b	$fa,$a0,'=@',$c0,$e0,$ff,$e0
	dc.b	$0f,'d',$02,$fa,$0c,$06,$0f,$fe
	dc.b	$0a,$80,';`',$c4,$e0,$ff,$e0
	dcb.w	4
	dc.b	'#]',$1f,'B ',$bf,'?',$ff
	dc.b	$b6,'H',$ce,'p',$01,$88,$ff,$f8
	dc.b	'#',$08,'_',$fa,'`',$06,$7f,$fe
	dc.b	$08,$a8,$03,$b6,$0c,'N',$0f,$fe
	dc.b	'-',$fc,$13,$bf,' @?',$ff
	dc.b	'c',$e8,$9f,$90,$00,$08,$ff,$f8
	dc.b	$1d,$f4,'#',$fb,$c0,$00,$ff,$ff
	dc.b	'w4',$f7,$f0,$08,$0c,$ff,$fc
	dc.b	'-',$fc,$13,$bf,' @?',$ff
	dc.b	'c',$e8,$9f,$90,$00,$08,$ff,$f8
	dc.b	$1d,$f4,'#',$fb,$c0,$00,$ff,$ff
	dc.b	'w4',$f7,$f0,$08,$0c,$ff,$fc
	dc.b	't9',$cc,'>',$83,$c0,$ff,$ff
	dc.b	$ad,$c8,'n6',$10,$0e,$ff,$fe
	dc.b	$1d,$f4,'#',$fb,$c0,$00,$ff,$ff
	dc.b	'w',$02,$f7,$f4,$08,$0e,$ff,$fe
	dc.b	'`@',$1f,$80,$e0,$e0,$e0,$e0
	dc.b	$06,$08,$01,$f6,$0e,$0e,$0e,$0e
	dc.b	$80,$00,$1f,$e0,$e0,$e0,$e0,$e0
	dcb.w	4
	dc.b	'B',$05,'?',$fa,'@',$07,'~',$07
	dc.b	$80,'X',$ff,'|',$00,$84,$c0,$fc
	dc.b	'X',$1c,$27,$fd,'@',$03,'~?'
	dc.b	$0c,$00,$01,$fe,$0e,$0e,$0e,$0e
	dc.b	'L',$00,'3',$ff,'@',$00,'~',$00
	dc.b	$00,'X',$ff,$bc,$00,$04,$00,$fc
	dc.b	$80,$00,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$00,',',$ff,$e2,$00,$1e,$00,'>'
	dc.b	'L',$00,'3',$ff,'@',$00,'~',$00
	dc.b	$00,'X',$ff,$bc,$00,$04,$00,$fc
	dc.b	$80,$00,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$00,',',$ff,$e2,$00,$1e,$00,'>'
	dc.b	$b0,$00,'O',$ff,$80,$00,$f8,$00
	dc.b	$00,$00,$ff,$fe,$00,$0e,$00,$0e
	dc.b	$80,$00,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$00,$04,$ff,$f8,$00,$0e,$00,$0e
	dc.b	'?',$80,$1f,$00,$e0,$e0,$e0,$e0
	dc.b	$03,$f2,$11,$fc,$1e,$0e,$1e,$0e
	dc.b	$df,' ',$1f,$c0,$e0,$e0,$e0,$e0
	dcb.w	4
	dc.b	'g',$ff,$7f,$fe,$00,$01,'x',$01
	dc.b	$ff,$e4,$ff,$e0,$00,$1c,$00,'<'
	dc.b	'_',$ff,$e7,$fe,$80,$01,$f8,$0f
	dc.b	$07,$f0,$81,$fe,$8e,$0e,$8e,$0e
	dc.b	$27,$ff,'_',$ff,$00,$00,'x',$00
	dc.b	$ff,$f4,$ff,$f0,$00,$0c,$00,'<'
	dc.b	$df,$ff,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fe,$ff,$e0,$00,$1e,$00,$1e
	dc.b	$27,$ff,'_',$ff,$00,$00,'x',$00
	dc.b	$ff,$f4,$ff,$f0,$00,$0c,$00,'<'
	dc.b	$df,$ff,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fe,$ff,$e0,$00,$1e,$00,$1e
	dc.b	$cf,$ff,$ff,$ff,$00,$00,$f0,$00
	dc.b	$ff,$f6,$ff,$f8,$00,$0e,$00,$0e
	dc.b	$df,$ff,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$fc,$ff,$f0,$00,$0e,$00,$0e
	dc.b	' ',$c0,$1f,$00,$e0,$e0,$e0,$e0
	dc.b	$00,$06,'!',$f8,'>',$0e,'>',$0e
	dc.b	$e0,'`',$1f,$80,$e0,$e0,$e0,$e0
	dcb.w	4
	dc.b	$b0,$00,'?',$ff,$c0,$00,$f0,$00
	dc.b	$00,$1c,$ff,$e0,$00,$1c,$00,$1c
	dc.b	$c0,$04,$7f,$fc,$80,$03,$f0,$07
	dc.b	$8a,$02,'I',$fc,$c6,$0e,$ce,$0e
	dc.b	$b0,$00,'O',$ff,$80,$00,$f0,$00
	dc.b	$00,$0e,$ff,$e0,$00,$1e,$00,$1e
	dc.b	$e0,$00,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$00,$08,$ff,$f6,$00,$0e,$00,$0e
	dc.b	$b0,$00,'O',$ff,$80,$00,$f0,$00
	dc.b	$00,$0e,$ff,$e0,$00,$1e,$00,$1e
	dc.b	$e0,$00,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$00,$08,$ff,$f6,$00,$0e,$00,$0e
	dc.b	$e0,$00,$ff,$ff,$00,$00,$e0,$00
	dc.b	$00,$08,$ff,$f0,$00,$0e,$00,$0e
	dc.b	$e0,$00,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$00,$0c,$ff,$f0,$00,$0e,$00,$0e
	dc.b	$9f,'`',$9f,$80,'`',$e0,$e0,$e0
	dc.b	'S',$fe,$13,$f0,'l',$0e,'|',$0e
	dc.b	'?',$e0,$1f,$00,$e0,$e0,$e0,$e0
	dcb.w	4
	dc.b	$0f,$ff,$0f,$ff,$f0,$00,$f0,$00
	dc.b	$ff,$fc,$ff,$e2,$00,$1e,$00,$1e
	dc.b	$ef,$fc,$ff,$fc,$00,$03,$f0,$03
	dc.b	$c9,$f6,')',$f8,$e6,$0e,$ee,$0e
	dc.b	$cf,$ff,$ff,$ff,$00,$00,$f0,$00
	dc.b	$ff,$fa,$ff,$e4,$00,$1e,$00,$1e
	dc.b	$9f,$ff,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$f0,$ff,$fe,$00,$0e,$00,$0e
	dc.b	$cf,$ff,$ff,$ff,$00,$00,$f0,$00
	dc.b	$ff,$fa,$ff,$e4,$00,$1e,$00,$1e
	dc.b	$9f,$ff,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$f0,$ff,$fe,$00,$0e,$00,$0e
	dc.b	$7f,$ff,$7f,$ff,$80,$00,$e0,$00
	dc.b	$ff,$f0,$ff,$f0,$00,$0e,$00,$0e
	dc.b	$9f,$ff,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$f6,$ff,$f8,$00,$0e,$00,$0e
	dc.b	$c0,'3',$c0,$dc,'?',$e0,$e0,$ff
	dc.b	'8',$1e,$f8,$00,$07,$fe,$fc,$1e
	dc.b	$00,$a0,$00,$00,$ff,$e0,$e0,$e0
	dcb.w	6
	dc.b	$ff,$ff,$e0,$00,$00,$08,$00,$06
	dc.b	$ff,$fe,$00,$0e,' ',$00,' ',$00
	dc.b	$df,$ff,$e0,$01,$e4,$0c,$1c,$00
	dc.b	$f3,$fe,$fe,$0e,'`',$00,'`',$00
	dc.b	$9f,$ff,$e0,$00,$00,$02,$00,$0c
	dc.b	$ff,$fe,$00,$0e,$00,$00,$00,$00
	dc.b	$ff,$ff,$e0,$00,$00,$00,$00,$0e
	dc.b	$ff,$fe,$00,$0e,'`',$00,'`',$00
	dc.b	$9f,$ff,$e0,$00,$00,$02,$00,$0c
	dc.b	$ff,$fe,$00,$0e,$00,$00,$00,$00
	dc.b	$ff,$ff,$e0,$00,$00,$00,$00,$0e
	dc.b	$ff,$fe,$00,$0e,$80,$00,$00,$00
	dc.b	$ff,$ff,$e0,$00,$00,$0e,$00,$00
	dc.b	$ff,$fe,$00,$0e,' ',$00,' ',$00
	dc.b	$df,$ff,$e0,$00,$00,$02,$00,$0c
	dc.b	$ff,$fe,$00,$0e,$df,'o',$df,$b0
	dc.b	' ',$c0,$e0,$ff,$bf,$e0,$7f,$e2
	dc.b	$00,$1e,$f8,$1e,'_ _',$00
	dc.b	$a0,$e0,$e0,$e0,$00,$00,$00,$00
	dcb.w	2
	dc.b	'_',$8f,'_',$8f,$a0,'p',$e0,'p'
	dc.b	$e3,$f0,$e3,$fe,$1c,$0e,$1c,$0e
	dc.b	$1f,$ff,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$d3,$f8,$0f,$f0,$f0,$0e,$fe,$0e
	dc.b	$7f,$80,$7f,$ff,$80,$7f,$e0,$7f
	dc.b	$0f,$f0,$f3,$fc,$fc,$0e,$fc,$0e
	dc.b	$e0,$00,$1f,$ff,$ff,$ff,$ff,$ff
	dc.b	$03,$f0,$fd,$fe,$fe,$0e,$fe,$0e
	dc.b	$7f,$80,$7f,$ff,$80,$7f,$e0,$7f
	dc.b	$0f,$f0,$f3,$fc,$fc,$0e,$fc,$0e
	dc.b	$e0,$00,$1f,$ff,$ff,$ff,$ff,$ff
	dc.b	$03,$f0,$fd,$fe,$fe,$0e,$fe,$0e
	dc.b	$df,'@',$1f,'?',$e0,$ff,$e0,$ff
	dc.b	'<',$0e,$c3,$f0,$ff,$fe,$ff,$fe
	dc.b	$c3,'7',$dc,$07,'?',$f8,$ff,$f8
	dc.b	$ee,'8',$d0,'6?',$ce,'?',$fe
	dc.b	$c0,$e7,$c0,'x?',$80,$e0,$ff
	dc.b	$00,$04,$e0,$00,$1f,$fc,$e0,'<'
	dc.b	$e0,' ',$e0,$00,$1f,$e0,$e0,$e0
	dcb.w	4
	dc.b	$e0,$c8,$e0,$08,$1f,$f7,$e0,$f8
	dc.b	'6',$02,$06,$0c,$f9,$fe,'>',$0e
	dc.b	$c0,$00,$c0,$00,'?',$ff,$e0,$00
	dc.b	'B',$08,$06,$00,$f9,$fe,'~',$0e
	dc.b	' ',$00,' ',$ff,$df,$ff,$e0,$ff
	dc.b	$f8,$04,$02,$08,$fd,$fe,$fe,$0e
	dc.b	$e7,$8d,$87,$f3,'x',$00,$ff,$ff
	dc.b	'j',$00,'v',$0e,$81,$fe,$fe,$0e
	dc.b	' ',$00,' ',$ff,$df,$ff,$e0,$ff
	dc.b	$f8,$04,$02,$08,$fd,$fe,$fe,$0e
	dc.b	$e7,$8d,$87,$f3,'x',$00,$ff,$ff
	dc.b	'j',$00,'v',$0e,$81,$fe,$fe,$0e
	dc.b	$80,$cc,$00,$f3,$ff,$00,$e0,$ff
	dc.b	$e0,$ee,$e0,$f8,$1f,$06,$ff,$fe
	dc.b	$8c,'`',$b0,$08,$7f,$f7,$ff,$f8
	dc.b	$17,$9c,$08,$1a,$ff,$e6,'?',$fe
	dc.b	'?',$ff,$e0,$00,$1f,$ff,$e0,$00
	dc.b	$ff,$e8,$00,$04,$ff,$fc,$00,'|'
	dc.b	$ff,'`',$e0,$00,$1f,$e0,$e0,$e0
	dcb.w	4
	dc.b	$ff,$7f,$e0,$98,$1f,$e7,$e0,$f8
	dc.b	$c1,$f2,'>',$0c,$f9,$fe,'>',$0e
	dc.b	$ff,'?',$e0,$00,$1f,$ff,$e0,$c0
	dc.b	$c9,$f8,$06,$00,$f9,$fe,'>',$0e
	dc.b	'?',$03,' ',$fc,$df,$ff,$e0,$ff
	dc.b	$13,$f8,$04,$00,$f9,$fe,$fe,$0e
	dc.b	$df,$ff,$c0,$00,'?',$ff,$e0,$00
	dc.b	$ff,$f0,$00,$0e,$ff,$fe,$00,$0e
	dc.b	'?',$03,' ',$fc,$df,$ff,$e0,$ff
	dc.b	$13,$f8,$04,$00,$f9,$fe,$fe,$0e
	dc.b	$df,$ff,$c0,$00,'?',$ff,$e0,$00
	dc.b	$ff,$f0,$00,$0e,$ff,$fe,$00,$0e
	dc.b	'?',$ff,' ',$00,$df,$ff,$e0,$00
	dc.b	$ff,$d8,$00,'$',$ff,$c0,$00,'<'
	dc.b	$11,$cf,'`',$10,$ff,$e7,$ff,$f8
	dc.b	$c8,$ce,$07,$0c,$ff,$f2,'?',$fe
	dc.b	'@',$00,$a0,$00,$1f,$ff,$e0,$00
	dc.b	$00,$f0,$00,$08,$ff,$f8,$00,$f8
	dc.b	$a0,$c0,$e0,' ',$1f,$e0,$e0,$e0
	dcb.w	4
	dc.b	$a0,'8',$e0,$d8,$1f,$e7,$e0,$f8
	dc.b	$08,$06,'6',$08,$f9,$fe,'>',$0e
	dc.b	$a0,$80,$e0,$00,$1f,$ff,$e0,$e0
	dc.b	$08,$08,$02,$00,$fd,$fe,$1e,$0e
	dc.b	$80,$00,$80,$e0,$7f,$e0,$e0,$e0
	dc.b	$06,$02,$08,$02,$01,$fc,$0e,$0e
	dc.b	$e0,$00,$e0,$00,$1f,$ff,$e0,$00
	dc.b	$00,$00,$00,$0e,$ff,$fe,$00,$0e
	dc.b	$80,$00,$80,$e0,$7f,$e0,$e0,$e0
	dc.b	$06,$02,$08,$02,$01,$fc,$0e,$0e
	bra	l000d
	dc.b	$1f,$ff,$e0,$00,$00,$00,$00,$0e
	dc.b	$ff,$fe,$00,$0e,$e0,$00,$e0,$00
	dc.b	$1f,$ff,$e0,$00,$00,$16,$00,$0e
	dc.b	$ff,$e0,$00,$1e,$00,$18,$00,' '
	dc.b	$00,$07,$00,'8 ',$00,$00,$00
	dc.b	$f8,$00,'8',$00,'_',$ff,$a0,$00
	dc.b	$1f,$ff,$e0,$00,$ff,'`',$00,'p'
	dc.b	$ff,$90,$01,$f0,$1f,$80,$e0,'`'
	dc.b	$1f,$e0,$e0,$e0,$00,$00,$00,$00
	dcb.w	2
	dc.b	$1f,$8f,$e0,'x',$1f,$e7,$e0,$f8
	dc.b	$db,$f6,'$',$08,$f9,$fe,'>',$0e
	dc.b	$1f,$8f,$e0,$00,$1f,$ff,$e0,$f0
	dc.b	$fd,$f8,$02,$00,$fd,$fe,$0e,$0e
	dc.b	'_',$00,$c0,$e0,'?',$e0,$e0,$e0
	dc.b	$07,$fc,$08,$0e,$01,$f0,$0e,$0e
	dc.b	$bf,$ff,$e0,$00,$1f,$ff,$e0,$00
	dc.b	$ff,$f8,$00,$06,$ff,$fe,$00,$0e
	dc.b	'_',$00,$c0,$e0,'?',$e0,$e0,$e0
	dc.b	$07,$fc,$08,$0e,$01,$f0,$0e,$0e
	dc.b	'?',$ff,$e0,$00,$1f,$ff,$e0,$00
	dc.b	$ff,$f8,$00,$06,$ff,$fe,$00,$0e
	dc.b	$9f,$ff,$e0,$00,$1f,$ff,$e0,$00
	dc.b	$ff,$fc,$00,$0c,$ff,$f2,$00,$0e
	dc.b	$00,'7',$00,$08,$00,$07,$00,'8'
	dc.b	$e0,$00,$00,$00,$f8,$00,'8',$00
	dc.b	$e0,$00,$1f,$ff,$1f,$ff,$e0,$00
	dc.b	$00,$e0,$ff,$18,$ff,$08,$00,$f8
	dc.b	'@ ',$bf,$c0,$1f,$e0,$e0,$e0
	dcb.w	4
	dc.b	'@',$c0,$bf,'?',$1f,$e7,$e0,$f8
	dc.b	'>',$06,$c1,$f8,$f9,$fe,'>',$0e
	dc.b	'@',$c8,$bf,$0f,$1f,$f7,$e0,$f8
	dc.b	$04,$0c,$f9,$f0,$ff,$fe,$06,$0e
	dc.b	' `',$ff,$80,$1f,$e0,$e0,$e0
	dc.b	$0a,$00,$0d,$fe,$01,$f0,$0e,$0e
	dc.b	$00,$00,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$00,$1e,$ff,$e0,$ff,$fe,$00,$1e
	dc.b	' `',$ff,$80,$1f,$e0,$e0,$e0
	dc.b	$0a,$00,$0d,$fe,$01,$f0,$0e,$0e
	dc.b	'@',$00,$bf,$ff,$1f,$ff,$e0,$00
	dc.b	$00,$1e,$ff,$e0,$ff,$fe,$00,$1e
	dc.b	$a0,$00,'o',$ff,$9f,$ff,$f0,$00
	dc.b	$00,$02,$ff,$f0,$ff,$fe,$00,$0e
	dc.b	$00,' ',$00,$1f,$00,$07,$00,'8'
	dc.b	'0',$00,$c0,$00,$f8,$00,'8',$00
	dc.b	$ff,$ff,$00,$00,$1f,$ff,$e0,$00
	dc.b	$ff,$b0,$00,'L',$ff,$84,$00,'|'
	dc.b	'_C',$a0,$b0,$1f,$cf,$e0,$ff
	dc.b	$f8,$e0,$00,$fc,$ff,$02,$ff,$fe
	dc.b	$ff,$d7,$00,'(',$1f,$e7,$e0,$f8
	dc.b	$ef,$f6,$00,$08,$f9,$fe,'>',$0e
	dc.b	$ff,$cf,$00,$0c,$1f,$f3,$e0,$fc
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$0e
	dc.b	$df,$c2,' ',$0d,$1f,$f0,$e0,$ff
	dc.b	'm',$f2,$ee,$0e,$11,$f0,$fe,$0e
	dc.b	'_',$ff,$a0,$00,$1f,$ff,$e0,$00
	dc.b	$ff,$e4,$00,$02,$ff,$fe,$00,'>'
	dc.b	$df,$c2,' ',$0d,$1f,$f0,$e0,$ff
	dc.b	'm',$f2,$ee,$0e,$11,$f0,$fe,$0e
	dc.b	$df,$ff,' ',$00,$1f,$ff,$e0,$00
	dc.b	$ff,$ec,$00,$0c,$ff,$f0,$00,'<'
	dc.b	'_',$ff,'@',$00,'?',$ff,'x',$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$0e
	dc.b	$00,$0f,$00,'0',$00,$07,$00,'8'
	dc.b	$f0,$00,$00,$00,$f8,$00,'8',$00
	dc.b	$c0,$1c,'?',$e0,$1f,$ff,$e0,$ff
	dc.b	' ',$08,$1f,$f8,$ff,$c4,$e0,'<'
	dc.b	$00,$88,$ff,'x',$1f,$87,$e0,$ff
	dc.b	$e1,$80,$01,$fa,$fe,$06,$ff,$fe
	dc.b	$e0,'x',$1f,$87,$1f,$e7,$e0,$f8
	dc.b	'.',$06,$c1,$f8,$f9,$fe,'>',$0e
	dc.b	$e0,'l',$1f,$8f,$1f,$f1,$e0,$fe
	dc.b	$00,$0e,$ff,$f0,$ff,$fe,$00,$0e
	dc.b	$e0,$97,$1f,$18,$1f,$e0,$e0,$ff
	dc.b	'd',$0c,$e7,$fc,$19,$f2,$fe,$0e
	dc.b	$e0,$80,$1f,$7f,$1f,$ff,$e0,$ff
	dc.b	$f8,'4',$07,$c0,$ff,$fc,$ff,$fc
	dc.b	$e0,$97,$1f,$18,$1f,$e0,$e0,$ff
	dc.b	'd',$0c,$e7,$fc,$19,$f2,$fe,$0e
	dc.b	$c0,$1c,'?',$e0,$1f,$ff,$e0,$ff
	dc.b	'8',$1e,'?',$fe,$c7,$e0,$f8,$1e
	dc.b	$dc,$c0,$b0,'?',$0f,$ff,$ff,$ff
	dc.b	$1c,$00,$e1,$fe,$ff,$fe,$fe,$0e
	dc.b	$00,$18,$00,$27,$00,$07,$00,'8'
	dc.b	$18,$00,$e0,$00,$f8,$00,'8',$00
	dc.b	'_',$07,$bf,$f8,$1f,$ff,$e0,$ff
	dc.b	'w',$fc,$0f,$fe,$ff,$e2,$f8,$1e
	dc.b	$1f,$1c,$ff,$fc,$1f,$03,$e0,$ff
	dc.b	$0f,$02,$0f,$f4,$f0,$0e,$ff,$fe
	dc.b	'_',$7f,$bf,$87,$1f,$e7,$e0,$f8
	dc.b	$eb,$f6,$c5,$f8,$f9,$fe,'>',$0e
	dc.b	'_x',$bf,$8f,$1f,$f0,$e0,$ff
	dc.b	$ff,$f4,$ff,$fa,$ff,$fe,$00,$0e
	dc.b	$df,$bf,'?',$b0,$1f,$c0,$e0,$7f
	dc.b	$13,$f4,$f3,$f8,$0f,$fe,$fc,$0e
	dc.b	'_C',$bf,'<',$1f,$ff,$e0,$ff
	dc.b	$8e,$18,$01,$e4,$ff,$fc,$ff,$fc
	dc.b	$df,$bf,'?',$b0,$1f,$c0,$e0,$7f
	dc.b	$13,$f4,$f3,$f8,$0f,$fc,$fc,$0c
	dc.b	'_',$07,$bf,$f8,$1f,$ff,$e0,$ff
	dc.b	$1b,$f2,$1f,$f2,$e3,$fc,$fc,$0e
	dc.b	$f1,$99,$cf,$9e,$00,'`',$ff,$ff
	dc.b	$b1,$f0,'q',$fe,$0f,$fe,$fe,$0e
	dc.b	$00,'?',$00,$07,$00,$07,$00,'8'
	dc.b	$d8,$00,$e0,$00,$f8,$00,'8',$00
	dc.b	' ',$81,$ff,'~',$1f,$ff,$e0,$ff
	dc.b	$e8,$12,$13,$f0,$ff,$ee,$fc,$1e
	dc.b	$80,$00,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$00,$04,$ff,$f8,$ff,$fe,$00,$0e
	dc.b	$00,'0',$ff,$cf,$1f,$e7,$e0,$f8
	dc.b	'(',$06,$c7,$f8,$f9,$fe,'>',$0e
	dc.b	$00,'(',$ff,$c7,$1f,$e8,$e0,$ef
	dc.b	$80,$00,$ff,$fe,$7f,$fe,$80,$0e
	dc.b	$00,$00,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$00,$02,$ff,$fc,$ff,$fe,$00,$0e
	dc.b	$00,'&',$ff,$18,$1f,$ff,$e0,$ff
	dc.b	$03,$80,$00,'p',$ff,$f0,$ff,$f0
	dc.b	$00,$00,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$00,$02,$ff,$fc,$ff,$fe,$00,$0e
	dc.b	$00,$81,$ff,'~',$1f,$ff,$e0,$ff
	dc.b	$90,$08,$1f,$f0,$e1,$fe,$fe,$0e
	dc.b	$e0,$00,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$00,$08,$ff,$f6,$ff,$fe,$00,$0e
	dc.b	$00,$10,$00,'/',$00,$07,$00,'8'
	dc.b	$08,$00,$f0,$00,$f8,$00,'8',$00
	dc.b	$ff,$c0,$ff,' ',$1f,$e0,$e0,$e0
	dc.b	$1b,$f2,'c',$f0,$7f,$fe,'|',$0e
	dc.b	$ff,$ff,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$ff,$fc,$ff,$f0,$ff,$fe,$00,$0e
	dc.b	$1f,$27,$ff,$df,$1f,$e7,$e0,$f8
	dc.b	$eb,$f6,$c5,$f8,$f9,$fe,'>',$0e
	dc.b	$1f,'%',$ff,$c3,$1f,$e4,$e0,$e7
	dc.b	$ff,$e0,$ff,$fe,'?',$fe,$c0,$1e
	dc.b	$bf,$ff,$ff,$ff,$0f,$ff,$f0,$00
	dc.b	$ff,$e2,$ff,$fc,$ff,$fe,$00,$1e
	dc.b	$1f,$80,$ff,$00,$1f,$e0,$e0,$e0
	dcb.w	4
	dc.b	$bf,$ff,$ff,$ff,$0f,$ff,$f0,$00
	dc.b	$ff,$e2,$ff,$e0,$ff,$fe,$00,$1e
	dc.b	$bf,$c0,$ff,' ',$1f,$e0,$e0,$e0
	dc.b	$0b,$fc,$0d,$f0,$01,$fe,$0e,$0e
	dc.b	'?',$ff,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$ff,$fc,$ff,$f2,$ff,$fe,$00,$0e
	dc.b	$00,$07,$00,'?',$00,$07,$00,'8'
	dc.b	$c8,$00,$f0,$00,$f8,$00,'8',$00
	dc.b	$df,'`',$ff,$00,$1f,$e0,$e0,$e0
	dc.b	$17,$f6,$27,$f0,'9',$fe,'>',$0e
	dc.b	$df,$ff,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$ff,$fc,$ff,$f0,$ff,$fe,$00,$0e
	dc.b	$bf,$27,$ff,$df,$1f,$e7,$e0,$f8
	dc.b	$ff,$f6,$c1,$f8,$f9,$fe,'>',$0e
	dc.b	$bf,'#',$ff,$c1,$1f,$e2,$e0,$e3
	dc.b	$ff,$f2,$ff,$ec,$1f,$fe,$e0,$1e
	dc.b	$ef,$ff,'o',$ff,$9f,$ff,$f0,$00
	dc.b	$ff,$f2,$ff,$ec,$ff,$fe,$00,$1e
	dc.b	$bf,$80,$ff,$00,$1f,$e0,$e0,$e0
	dcb.w	4
	dc.b	$ef,$ff,'o',$ff,$9f,$ff,$f0,$00
	dc.b	$ff,$f6,$ff,$f0,$ff,$fe,$00,$0e
	dc.b	$df,'`',$ff,$00,$1f,$e0,$e0,$e0
	dc.b	$0f,$f6,$01,$f8,$01,$fe,$0e,$0e
	dc.b	$9f,$ff,$7f,$ff,$1f,$ff,$e0,$00
	dc.b	$ff,$fe,$ff,$f0,$ff,$fe,$00,$0e
	dc.b	$00,'/',$00,'?',$00,$07,$00,'8'
	dc.b	$c8,$00,$f0,$00,$f8,$00,'8',$00
	dc.b	$bf,' ',$df,$00,$1f,$e0,$e0,$e0
	dc.b	$0d,$fe,$1f,$f0,$11,$fe,$1e,$0e
	dc.b	$9f,$ff,$ff,$ff,$0f,$ff,$f0,$00
	dc.b	$ff,$f6,$ff,$f8,$ff,$fe,$00,$0e
	dc.b	$ff,$0f,$ff,$ff,$1f,$e7,$e0,$f8
	dc.b	$dd,$f2,$e3,$fc,$f9,$fe,'>',$0e
	dc.b	$ff,$01,$ff,$e0,$1f,$e1,$e0,$e1
	dc.b	$cf,$da,$cf,$c4,'?',$fe,$f0,'>'
	dc.b	'O',$ff,$cf,$ff,$b7,$ff,$f8,$00
	dc.b	$ff,$d8,$ff,$c4,$ff,$fc,$00,'<'
	dc.b	$ff,$c0,$ff,$00,$1f,$e0,$e0,$e0
	dcb.w	4
	dc.b	'O',$ff,$cf,$ff,$b7,$ff,$f8,$00
	dc.b	$ff,$fe,$ff,$f0,$f3,$fe,$0c,$0e
	dc.b	$bf,' ',$df,$00,$1f,$e0,$e0,$e0
	dc.b	$0d,$f2,$03,$fc,$01,$fe,$0e,$0e
	dc.b	$ff,$ff,$1f,$ff,$1f,$ff,$e0,$00
	dc.b	$ff,$e6,$ff,$e0,$ff,$fe,$00,$1e
	dc.b	$00,'?',$00,'?',$00,$07,$00,'8'
	dc.b	$c0,$00,$f8,$00,$f8,$00,'8',$00
	dc.b	'_ ',$bf,$00,$1f,$e0,$e0,$e0
	dc.b	$09,$f2,$0f,$fc,$01,$fe,$0e,$0e
	dc.b	$b7,$ff,'w',$ff,$8f,$ff,$f8,$00
	dc.b	$ff,$f2,$ff,$fc,$ff,$fe,$00,$0e
	dc.b	$ff,$1f,$ff,$ff,$1f,$e7,$e0,$f8
	dc.b	$db,$f2,$e7,$fc,$f9,$fe,'>',$0e
	dc.b	$ff,$00,$ff,$e0,$1f,$e0,$e0,$e0
	dc.b	$cf,$c8,'C',$04,$bf,$fc,$fc,$fc
	dc.b	'S',$ff,$1f,$ff,'a',$ff,'~',$00
	dc.b	$ff,$c8,$ff,$04,$ff,$fc,$00,$fc
	dc.b	$7f,'`',$7f,$80,$9f,$e0,$e0,$e0
	dcb.w	4
	dc.b	'S',$ff,$1f,$ff,'a',$ff,'~',$00
	dc.b	$f9,$f2,$ff,$fc,$f1,$fe,$0e,$0e
	dc.b	'_ ',$bf,$00,$1f,$e0,$e0,$e0
	dc.b	$0b,$f0,$07,$fe,$01,$fe,$0e,$0e
	dc.b	$df,$ff,'?',$ff,$1f,$ff,$e0,$00
	dc.b	$ff,$d0,$ff,$d2,$ff,$ee,$00,'>'
	dc.b	$00,'?',$00,'?',$00,$07,$00,'8'
	dc.b	$c0,$00,$f8,$00,$f8,$00,'8',$00
	dc.b	$86,$00,'Y',$80,'?',$e0,$ff,$e0
	dc.b	$03,$d8,$0c,$16,$01,$ee,$0f,$fe
	dc.b	'v9',$f1,$c1,$8f,$fe,$ff,$ff
	dc.b	$e6,'8',$e0,'6',$1f,$ce,$ff,$fe
	dc.b	$de,$11,$e1,$f6,'?',$ef,$ff,$ff
	dc.b	$0f,$e0,'4',$0e,$fb,$fe,$ff,$fe
	dc.b	$de,$00,$e1,$e0,'?',$e0,$ff,$e0
	dc.b	'X',$e4,$07,$08,$7f,$fc,$7f,$fc
	dc.b	'$',$e1,'\',$1e,'c',$ff,$7f,$ff
	dc.b	$e0,$e0,$1f,$08,$ff,$f8,$ff,$f8
	dc.b	'^ a',$c0,$bf,$e0,$ff,$e0
	dcb.w	4
	dc.b	'$',$e1,'\',$1e,'c',$ff,$7f,$ff
	dc.b	$e3,$d8,$1c,$16,$f1,$ee,$ff,$fe
	dc.b	$86,$00,'Y',$80,'?',$e0,$ff,$e0
	dc.b	$07,$e0,$0c,$0e,$03,$fe,$0f,$fe
	dc.b	$a9,$b9,'PA?',$fe,$ff,$ff
	dc.b	$e6,'<',$e0,'8',$1f,$c4,$ff,$fc
	dc.b	$00,'7',$00,'8',$00,$0f,$00,'?'
	dc.b	$80,$00,'x',$00,$f8,$00,$f8,$00
	dc.b	$0f,$00,$b0,$c0,$7f,$e0,$ff,$e0
	dc.b	$0f,$9c,$00,$1a,$03,$e6,$0f,$fe
	dc.b	'D',$0c,$03,$f0,$7f,$ff,$7f,$ff
	dc.b	$9f,$9c,$80,$1a,$7f,$e6,$ff,$fe
	dc.b	$b3,$03,$c0,$ec,$7f,$ff,$ff,$ff
	dc.b	$84,'p',$1b,$86,$ff,$fe,$ff,$fe
	dc.b	$b3,$00,$c0,$e0,$7f,$e0,$ff,$e0
	dc.b	$10,$e8,'/',$10,'?',$f8,'?',$f8
	dc.b	$19,'?(',$80,'7',$ff,'?',$ff
	dc.b	'8',$e0,$07,$10,$ff,$f0,$ff,$f0
	dc.b	$b3,$00,$c0,$e0,$7f,$e0,$ff,$e0
	dcb.w	4
	dc.b	$19,'?(',$80,'7',$ff,'?',$ff
	dc.b	'?',$9c,$00,$1a,$f3,$e6,$ff,$fe
	dc.b	$0f,$00,$b0,$c0,$7f,$e0,$ff,$e0
	dc.b	$0c,'p',$0b,$86,$07,$fe,$0f,$fe
	dc.b	'S',$0c,$a0,$f0,$7f,$ff,$ff,$ff
	dc.b	$9f,$90,$80,$14,$7f,$ec,$ff,$fc
	dc.b	$00,',',$00,'0',$00,$1f,$00,'?'
	dc.b	$c0,$00,'8',$00,$f8,$00,$f8,$00
	dc.b	$11,$80,'``',$ff,$e0,$ff,$e0
	dc.b	$0f,$1e,$00,$1c,$07,$e2,$0f,$fe
	dc.b	$1c,$04,'#',$f8,'?',$ff,'?',$ff
	dc.b	'0',$ce,$0f,$0c,$ff,$f2,$ff,$fe
	dc.b	'a',$87,$80,'x',$ff,$ff,$ff,$ff
	dc.b	$c0,'0',$0f,$c2,$ff,$fe,$ff,$fe
	dc.b	'a',$80,$80,'`',$ff,$e0,$ff,$e0
	dc.b	$00,'@',$0f,$a0,$0f,$e0,$0f,$e0
	dc.b	$02,$8e,$05,$00,$07,$ff,$07,$ff
	dc.b	$0c,$00,$03,$c0,$ff,$c0,$ff,$c0
	dc.b	'a',$80,$80,'`',$ff,$e0,$ff,$e0
	dcb.w	4
	dc.b	$02,$8e,$05,$00,$07,$ff,$07,$ff
	dc.b	$07,$1e,$00,$1c,$e7,$e2,$e7,$fe
	dc.b	$11,$80,'``',$ff,$e0,$ff,$e0
	dc.b	$08,'0',$07,$c2,$0f,$fe,$0f,$fe
	dc.b	$a6,$04,'A',$f8,$ff,$ff,$ff,$ff
	dc.b	'0',$d0,$0f,$08,$ff,$f8,$ff,$f8
	dc.b	$00,$18,$00,' ',$00,'?',$00,'?'
	dc.b	'`',$00,$18,$00,$f8,$00,$f8,$00
	dcb.w	80
	dc.b	'Q ',$b1,$c0,$0e,' ',$ff,$e0
	dc.b	$06,$f2,$09,$f0,$00,$0e,$0f,$fe
	dc.b	'Q ',$b1,$c0,$0e,' ',$ff,$e0
	dc.b	$06,$a4,$0e,'8',$09,$c4,$0f,$fc
	dc.b	'a',$87,$80,'x',$ff,$ff,$ff,$ff
	dc.b	$c0,'0',$0f,$c2,$ff,$fe,$ff,$fe
	dc.b	'8',$e0,$ff,' ',$00,$00,$ff,$e0
	dc.b	$0e,'8',$09,$fe,$00,$00,$0f,$fe
	dc.b	'7',$90,'O',$80,$00,'p',$7f,$f0
	dc.b	$0d,$e4,$13,$e0,$00,$1c,$1f,$fc
	dc.b	'r',$13,$8e,$1c,$01,$e0,$ff,$ff
	dc.b	$9c,$9e,'|',$e0,$03,$02,$ff,$fe
	dcb.w	8
	dc.b	$00,$06,$00,$0b,$00,$0c,$00,$0f
	dc.b	'g',$00,$f9,$00,$00,$00,$ff,$00
	dc.b	$00,$e6,$00,$9f,$00,$00,$00,$ff
	dc.b	' ',$00,$d0,$00,'0',$00,$f0,$00
	dcb.w	8
	dc.b	'+@[',$a0,$84,'`',$ff,$e0
	dc.b	$0b,'d',$0c,$e2,$00,$1e,$0f,$fe
	dc.b	'+@[',$a0,$84,'`',$ff,$e0
	dc.b	$07,'h',$11,'t',$1c,$8c,$1f,$fc
	dc.b	$b3,$03,$c0,$ec,$7f,$ff,$ff,$ff
	dc.b	$84,'p',$1b,$86,$ff,$fe,$ff,$fe
	dc.b	$9d,$e0,'~@',$80,' ',$ff,$e0
	dc.b	$0f,'r',$04,$fc,$08,$02,$0f,$fe
	dc.b	'[ g',$10,$00,$f0,$7f,$f0
	dc.b	$16,$c8,$19,$c4,$00,'<',$1f,$fc
	dc.b	';3G<',$80,$c0,$ff,$ff
	dc.b	'r',$bc,$f2,$c2,$0d,$06,$ff,$fe
	dcb.w	8
	dc.b	$00,$0d,$00,$14,$00,$1a,$00,$1f
	dc.b	'n',$00,$f3,$00,$01,$00,$ff,$00
	dc.b	$00,'v',$00,'O',$00,$80,$00,$ff
	dc.b	$b0,$00,$08,$00,'x',$00,$f8,$00
	dcb.w	8
	dc.b	$0a,$80,';`',$c4,$e0,$ff,$e0
	dc.b	$0d,'H',$0e,$c6,$00,'>',$0f,$fe
	dc.b	$0a,$80,';`',$c4,$e0,$ff,$e0
	dc.b	$07,$d0,' ',$ec,'>',$1c,'?',$fc
	dc.b	$de,$11,$e1,$f6,'?',$ef,$ff,$ff
	dc.b	$0f,$e0,'4',$0e,$fb,$fe,$ff,$fe
	dc.b	'M',$e0,$be,$80,$c0,'`',$ff,$e0
	dc.b	$0f,'d',$02,$fa,$0c,$06,$0f,$fe
	dc.b	'j@v0',$01,$f0,$7f,$f0
	dc.b	$1a,$90,$1d,$8c,$00,'|',$1f,$fc
	dc.b	$1d,$f4,'#',$fb,$c0,$00,$ff,$ff
	dc.b	'wx',$f7,$86,$08,$0e,$ff,$fe
	dcb.w	8
	dc.b	$00,$18,$00,'(',$00,'7',$00,'?'
	dc.b	$98,$00,'g',$00,$07,$00,$ff,$00
	dc.b	$00,$99,$00,$06,$00,$e0,$00,$ff
	dc.b	'h',$00,$04,$00,$fc,$00,$fc,$00
	dcb.w	8
	dc.b	$80,$00,$1f,$e0,$e0,$e0,$e0,$e0
	dc.b	$06,$00,$0f,$fe,$00,$0e,$0e,$0e
	dc.b	$80,$00,$1f,$e0,$e0,$e0,$e0,$e0
	dc.b	'4',$00,'s',$fc,'L',$1c,'|',$1c
	dc.b	$e0,$18,$ff,$ff,$00,$e0,$e0,$f8
	dc.b	$1a,$02,$e7,$fc,'8',$0e,'>',$0e
	dc.b	' ',$c0,$df,$00,$e0,$e0,$e0,$e0
	dc.b	$06,$08,$01,$f6,$0e,$0e,$0e,$0e
	dc.b	'0',$00,$7f,$f0,$00,'ppp'
	dc.b	$0c,$00,$1f,$fc,$00,$1c,$1c,$1c
	dc.b	$80,$00,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$00,$02,$ff,$fc,$00,$0e,$00,$0e
	dcb.w	8
	dc.b	$00,',',$00,$1d,$00,'"',$00,'>'
	dc.b	$0c,$00,$f3,$00,$0f,$00,$0f,$00
	dc.b	$00,$c0,$00,$0f,$00,$f0,$00,$f0
	dc.b	'D',$00,$80,$00,'|',$00,'|',$00
	dcb.w	8
	dc.b	$df,$00,$1f,$e0,$e0,$e0,$e0,$e0
	dc.b	$03,$f0,$0f,$fe,$00,$0e,$0e,$0e
	dc.b	$df,$00,$1f,$e0,$e0,$e0,$e0,$e0
	dc.b	'w',$e0,$d7,$fc,$88,$1c,$f8,$1c
	dc.b	$ff,$0f,$ff,$ff,$00,$e0,$e0,$f8
	dc.b	$dd,$f2,$e3,$fc,'8',$0e,'>',$0e
	dc.b	$9f,$80,$7f,$10,$e0,$f0,$e0,$f0
	dc.b	$03,$f2,$11,$fc,$1e,$0e,$1e,$0e
	dc.b	$1f,$80,$7f,$f0,$00,'ppp'
	dc.b	$07,$e0,$1f,$fc,$00,$1c,$1c,$1c
	dc.b	$df,$ff,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$f6,$ff,$f8,$00,$0e,$00,$0e
	dcb.w	8
	dc.b	$00,$27,$00,$7f,$00,'@',$00,'|'
	dc.b	$fc,$00,$e2,$00,$1e,$00,$1e,$00
	dc.b	$00,$7f,$00,$bf,$00,$c0,$00,$f8
	dc.b	$c8,$00,$ca,$00,'6',$00,'>',$00
	dcb.w	8
	dc.b	$e0,' ',$1f,$c0,$e0,$e0,$e0,$e0
	dc.b	$08,$00,$07,$fe,$00,$0e,$0e,$0e
	dc.b	$e0,$00,$1f,$e1,$e0,$e1,$e0,$e1
	dc.b	$e0,$00,$af,$fc,$10,'<',$f0,'<'
	dc.b	$a0,' ',$ff,$df,$00,$e0,$e0,$f8
	dc.b	'>',$06,$c1,$f8,'8',$0e,'>',$0e
	dc.b	$c0,$00,'?',$08,$e0,$f8,$e0,$f8
	dc.b	$00,$06,'!',$f8,'>',$0e,'>',$0e
	dc.b	'@',$00,'?',$f0,$00,'ppp'
	dc.b	$10,$00,$0f,$fc,$00,$1c,$1c,$1c
	dc.b	$e0,$00,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$00,$08,$ff,$f6,$00,$0e,$00,$0e
	dcb.w	8
	dc.b	$00,'p',$00,$0f,$00,'@',$00,'x'
	dc.b	'0',$00,$c4,$00,'<',$00,'<',$00
	dc.b	$00,$04,$00,'_',$00,'`',$00,'|'
	dc.b	$1e,$00,$fc,$00,$02,$00,$1e,$00
	dcb.w	8
	dc.b	'?`',$1f,$80,$e0,$e0,$e0,$e0
	dc.b	$0f,$f2,$01,$fc,$00,$0e,$0e,$0e
	dc.b	'?',$01,$1f,$e3,$e0,$e2,$e0,$e3
	dc.b	$ff,$80,'?',$f8,$00,'x',$e0,'x'
	dc.b	$1f,$27,$ff,$df,$00,$e0,$e0,$f8
	dc.b	$eb,$f6,$c5,$f8,'8',$0e,'>',$0e
	dc.b	$ff,$94,$1f,$90,$e0,'l',$e0,'|'
	dc.b	'S',$fe,$13,$f0,'l',$0e,'|',$0e
	dc.b	$1f,$b0,$7f,$c0,$00,'ppp'
	dc.b	$1f,$e4,$03,$f8,$00,$1c,$1c,$1c
	dc.b	$9f,$ff,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$ff,$f0,$ff,$fe,$00,$0e,$00,$0e
	dcb.w	8
	dc.b	$00,$1f,$00,'g',$00,$00,$00,'x'
	dc.b	$e8,$00,$c4,$00,'<',$00,'<',$00
	dc.b	$00,$0f,$00,'/',$00,'0',$00,'<'
	dc.b	$e8,$00,$e8,$00,$16,$00,$1e,$00
	dcb.w	8
	dc.b	$00,$c0,$00,$00,$ff,$e0,$e0,$e0
	dc.b	$0e,$06,$00,$08,$01,$fe,$0e,$0e
	dc.b	$00,'#',$00,$c6,$ff,$e4,$e0,$e7
	dc.b	$c0,$00,'@',$f0,'?',$f0,$c0,$f0
	dc.b	$00,'0',$e0,$c8,$1f,$e7,$e0,$f8
	dc.b	'(',$06,$06,$08,$f9,$fe,'>',$0e
	dc.b	$f0,'9',$00,'>',$ff,$c0,$f0,$7f
	dc.b	'8',$1e,$f8,$00,$07,$fe,$fc,$1e
	dc.b	'`d',$10,$07,$0f,$f8,'p',$7f
	dc.b	'L',$0c,$c0,$10,'3',$fc,$fc,$1c
	dc.b	' ',$00,' ',$00,$df,$ff,$e0,$00
	dc.b	$00,$00,$00,$0e,$ff,$fe,$00,$0e
	dcb.w	8
	dc.b	$00,'@',$00,$f0,$00,$8f,$00,$f0
	dc.b	'@',$00,$08,$00,$f8,$00,'x',$00
	dc.b	$00,$10,$00,$00,$00,$1f,$00,$1e
	dcb.w	2
	dc.b	$fe,$00,$0e,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	'_',$80,'_',$00,$a0,$e0,$e0,$e0
	dc.b	$09,$fe,$07,$f0,$00,$0e,$0e,$0e
	dc.b	'_g_',$8d,$a0,$e8,$e0,$ef
	dc.b	$fe,$00,$ff,$e0,$01,$e0,$81,$e0
	dc.b	'_',$7f,$bf,$87,$00,$e0,$e0,$f8
	dc.b	$eb,$f6,$c5,$f8,'8',$0e,'>',$0e
	dc.b	$0f,$fb,$8f,$fc,$f0,$00,$f0,'?'
	dc.b	$bf,$e0,$7f,$e2,$00,$1e,$f8,$1e
	dc.b	$7f,$cc,$0f,$8f,$00,'pp',$7f
	dc.b	'g',$fc,$e3,$e0,$18,$1c,$fc,$1c
	dc.b	$c3,$f0,$dc,$0f,'?',$ff,$ff,$ff
	dc.b	'?',$f8,$df,$f6,$e0,$0e,$e0,$0e
	dcb.w	8
	dc.b	$00,$ff,$00,$7f,$00,$80,$00,$f0
	dc.b	$c0,$00,$80,$00,'p',$00,'p',$00
	dc.b	$00,$07,$00,$11,$00,$1e,$00,$1e
	dc.b	$f8,$00,$f0,$00,$0e,$00,$0e,$00
	dcb.w	8
	dc.b	$e0,$80,$e0,$00,$1f,$e0,$e0,$e0
	dc.b	$00,$0a,$0e,$00,$01,$fe,$0e,$0e
	dc.b	$e0,'f',$e0,$96,$1f,$f9,$e0,$ff
	dc.b	$00,$00,$03,$c0,$ff,$c0,$03,$c0
	dc.b	$e0,'x',$00,$80,$1f,$e7,$e0,$f8
	dc.b	'.',$06,$00,$08,$f9,$fe,'>',$0e
	dc.b	'@',$01,$00,$0e,$7f,$f0,'x',$0f
	dc.b	$00,$04,$e0,$00,$1f,$fc,$e0,'<'
	dc.b	'`',$1e,$10,$1f,$0f,$e0,'p?'
	dc.b	'p',$14,$f0,$00,$0f,$fc,$fc,$1c
	dc.b	$87,$c0,$b8,'>',$7f,$ff,$ff,$ff
	dc.b	$00,$0e,$00,$00,$ff,$fe,$80,$1e
	dcb.w	8
	dc.b	$00,'0',$00,'0',$00,$cf,$00,$f0
	dc.b	'P',$00,$00,$00,$f0,$00,'p',$00
	dc.b	$00,$0e,$00,$00,$00,$0f,$00,$0e
	dc.b	$0e,$00,$00,$00,$fe,$00,$0e,$00
	dcb.w	8
	dc.b	$ff,$80,$e0,$00,$1f,$e0,$e0,$e0
	dc.b	$03,$f0,$0e,$00,$01,$fe,$0e,$0e
	dc.b	$ff,'}',$e0,$9c,$1f,$e3,$e0,$fe
	dc.b	$f8,$00,$07,$80,$ff,$80,$07,$80
	dc.b	$ff,$d7,$00,'(',$1f,$e7,$e0,$f8
	dc.b	$ef,$f6,$00,$08,$f9,$fe,'>',$0e
	dc.b	'/',$ff,'@',$00,$7f,$ff,'|',$00
	dc.b	$ff,$e8,$00,$04,$ff,$fc,$00,'|'
	dc.b	$0f,$ff,'p',$00,$0f,$ff,'p',$00
	dc.b	$ff,$f4,$00,$00,$ff,$fc,$00,$1c
	dc.b	$1f,'!`',$c2,$ff,$fd,$ff,$fe
	dc.b	$ff,$e4,$00,$02,$ff,$fe,$00,'>'
	dcb.w	8
	dc.b	$00,$1f,$00,$00,$00,$ff,$00,$e0
	dc.b	$e0,$00,$10,$00,$f0,$00,$f0,$00
	dc.b	$00,$0e,$00,$00,$00,$0f,$00,$0f
	dc.b	$fe,$00,$00,$00,$fe,$00,$06,$00
	dcb.w	8
	dc.b	$a0,$80,$e0,$00,$1f,$e0,$e0,$e0
	dc.b	$0e,$04,$0e,$04,$01,$fa,$0e,$0e
	dc.b	$a0,'X',$e0,$88,$1f,$e7,$e0,$fc
	dc.b	$00,$00,$0f,$00,$ff,$00,$0f,$00
	dc.b	'@',$c0,$a0,'8',$1f,$e7,$e0,$f8
	dc.b	'>',$06,$00,$08,$f9,$fe,'>',$0e
	dc.b	$1e,$00,' ',$00,'?',$ff,'>',$00
	dc.b	$00,$f0,$00,$08,$ff,$f8,$00,$f8
	dc.b	'X',$00,'x',$00,$07,$ff,'x',$00
	dc.b	$00,'4',$00,'0',$ff,$cc,$00,'<'
	dc.b	$04,'8',$00,'8',$07,$c7,$07,$f8
	dc.b	$00,'h',$00,$84,$ff,$fc,$00,$fc
	dcb.w	8
	dc.b	$00,$e0,$00,$00,$00,$ff,$00,$e0
	dc.b	$e0,$00,$00,$00,$e0,$00,$e0,$00
	dc.b	$00,$00,$00,$08,$00,$0f,$00,$0f
	dc.b	$00,$00,$06,$00,$fe,$00,$06,$00
	dcb.w	8
	dc.b	$1f,$80,$e0,$00,$1f,$e0,$e0,$e0
	dc.b	$01,$f4,$00,$04,$0f,$fa,$0e,$0e
	dc.b	$1f,$7f,$e0,$a8,$1f,$c7,$e0,$f8
	dc.b	$e2,$00,$1c,$00,$fe,$00,$1e,$00
	dc.b	$1f,$8f,$e0,'x',$1f,$e7,$e0,$f8
	dc.b	$db,$f6,'$',$08,$f9,$fe,'>',$0e
	dc.b	$0d,$ff,$1c,$00,$13,$ff,$1f,$00
	dc.b	$ff,'`',$00,'p',$ff,$90,$01,$f0
	dc.b	'w',$ff,'0',$00,'O',$ff,'x',$00
	dc.b	$ff,$dc,$00,$18,$ff,$e4,$00,'<'
	dc.b	$1b,$ff,$0f,$e0,$10,$1f,$1f,$e0
	dc.b	$fc,'0',$03,$c8,$ff,$f8,$03,$f8
	dcb.w	8
	dc.b	$00,$df,$00,$00,$00,$ff,$00,$e0
	dc.b	$a0,$00,'@',$00,$e0,$00,$e0,$00
	dc.b	$00,$00,$00,$08,$00,$0f,$00,$0f
	dc.b	$f8,$00,$06,$00,$fe,$00,$06,$00
	dcb.w	8
	dc.b	'@',$c0,$bf,$00,$1f,$e0,$e0,$e0
	dc.b	$08,$00,$09,$f0,$07,$fe,$0e,$0e
	dc.b	'@0',$bf,$9f,$1f,$cf,$e0,$f0
	dc.b	$0c,$00,$f0,$00,$fc,$00,'<',$00
	dc.b	$a0,'8',$ff,$df,$1f,$e7,$e0,$f8
	dc.b	$08,$06,$f7,$f8,$f9,$fe,'>',$0e
	dc.b	$0e,$00,'1',$ff,'!',$ff,'>',$00
	dc.b	$00,$e0,$ff,$18,$ff,$08,$00,$f8
	dc.b	'$',$00,'g',$ff,'[',$ff,'|',$00
	dc.b	$00,'H',$ff,$cc,$ff,$b4,$00,'|'
	dc.b	'1',$80,$1f,$ff,' ',$7f,'?',$80
	dc.b	$00,$00,$ff,$f0,$ff,$f0,$0f,$f0
	dcb.w	9
	dc.b	$00,$1f,$00,$ff,$00,$e0,' ',$00
	dc.b	$c0,$00,$e0,$00,$e0,$00,$00,$0f
	dc.b	$00,$07,$00,$08,$00,$0f,$00,$00
	dc.b	$fe,$00,$fe,$00,$06,$00,$00,$00
	dcb.w	7
	dc.b	$ff,$95,$00,$1b,$1f,$e0,$e0,$ff
	dc.b	$a5,$fa,$bc,$00,'C',$fe,$fe,$0e
	dc.b	$ff,$7f,$00,$c0,$1f,$9f,$e0,$e0
	dc.b	$98,$00,'`',$00,$f8,$00,'x',$00
	dc.b	$ff,$7f,$e0,$98,$1f,$e7,$e0,$f8
	dc.b	$c1,$f2,'>',$0c,$f9,$fe,'>',$0e
	dc.b	$1b,$ff,'d',$00,'C',$ff,'|',$00
	dc.b	$ff,$b0,$00,'L',$ff,$84,$00,'|'
	dc.b	')',$ff,$0f,$00,'0',$ff,'?',$00
	dc.b	$ff,'(',$01,$e0,$fe,$18,$01,$f8
	dc.b	'Y',$ff,'&',$00,'A',$ff,'~',$00
	dc.b	$c7,'L8p',$ff,$82,'?',$fe
	dcb.w	8
	dc.b	$00,'?',$00,' ',$00,$df,$00,$e0
	bra	l0001
	dc.b	$f0,$00,$f0,$00,$00,$07,$00,$07
	dc.b	$00,$08,$00,$0f,$f8,$00,$06,$00
	dc.b	$fe,$00,$06,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	$e0,',',$ff,'3',$1f,$c0,$e0,$ff
	dc.b	$92,$0e,$9f,$f0
l0034	bsr.s	l0034
	dc.b	$fe,$0e,$e0,$c0,$1f,$7f,$1f,$bf
	dc.b	$e0,$c0,'0',$00,$c0,$00,$f0,$00
	dc.b	$f0,$00,$e0,$c8,$ff,$0f,$1f,$f7
	dc.b	$e0,$f8,'6',$02,$c7,$fc,$f9,$fe
	dc.b	'>',$0e,' ',$08,'?',$f0,'G',$ff
	dc.b	'x',$0f,' ',$08,$1f,$f8,$ff,$c4
	dc.b	$e0,'<',$12,'H.',$07,'1',$ff
	dc.b	'?',$f8,'<',$90,$c0,$e8,$ff,$18
	dc.b	'?',$f8,$f8,$00,'G',$ff,$87,$ff
	dc.b	$f8,$00,'w',$18,$87,$e2,$f8,$06
	dc.b	$ff,$fe,$00,$00,$00,$00,$00,$00
	dcb.w	5
	dc.b	$00,$c0,$00,$ff,$00,$0f,$00,$f0
	dc.b	'0',$00,$c0,$00,$f0,$00,'p',$00
	dc.b	$00,$0e,$00,$1f,$00,$11,$00,$1e
	dc.b	$00,$00,$fe,$00,$fe,$00,$0e,$00
	dcb.w	8
	dc.b	$ff,$de,$ff,$e1,$1f,$80,$e0,$7f
	dc.b	$93,$f6,$9f,$f8,'c',$fe,$fc,$0e
	dc.b	'_',$fe,$bf,$ff,$1f,$ff,$e0,$01
	dc.b	' ',$00,$c0,$00,$e0,$00,$e0,$00
	dc.b	'_',$8f,'_',$8f,$bf,$ff,$e0,'p'
	dc.b	$e3,$f0,$e3,$fe,$ff,$fe,$1c,$0e
	dc.b	$7f,$dd,$ff,$e0,$8f,$ff,$f0,'?'
	dc.b	'w',$fc,$0f,$fe,$ff,$e2,$f8,$1e
	dc.b	$0c,$bf,$14,'O',$1b,$f7,$1f,$f8
	dc.b	$da,'`',$e4,'P',$ff,$b0,'?',$f0
	dc.b	$bf,$fd,$cf,$fe,$0f,$ff,$f0,$03
	dc.b	'<r?',$84,$c0,$0e,$ff,$fe
	dcb.w	8
	dc.b	$00,$bf,$00,'O',$00,$8f,$00,$f0
	dc.b	$f0,$00,$88,$00,$f8,$00,'x',$00
	dc.b	$00,$19,$00,$0f,$00,$11,$00,$1e
	dc.b	$f8,$00,$f6,$00,$fe,$00,$0e,$00
	dcb.w	9
	dc.b	$ff,$ff,$1f,$ff,$e0,$00,$00,$02
	dc.b	$ff,$fc,$ff,$fe,$00,$0e,$e0,$00
	dc.b	$ff,$ff,$1f,$ff,$e0,$03,$00,$00
	dc.b	$c0,$00,$c0,$00,$c0,$00,$00,$00
	dc.b	$1f,$ff,$ff,$ff,$e0,$00,$00,$08
	dc.b	$ff,$f6,$ff,$fe,$00,$0e,$90,'/'
	dc.b	$1f,$90,$ef,$ff,$f0,$7f,$e8,$12
	dc.b	$13,$f0,$ff,$ee,$fc,$1e,$01,$f0
	dc.b	$02,$1f,$03,$e7,$03,$f8,$0f,$00
	dc.b	$f0,$80,$ff,$80,'?',$80,$80,$00
	dc.b	$ff,$ff,$1f,$ff,$e0,$00,$00,$04
	dc.b	$ff,$f8,$ff,$fe,$00,$0e,$00,$00
	dcb.w	7
	dc.b	$00,'`',$00,$9f,$00,$8f,$00,$f0
	dc.b	'h',$00,$80,$00,$f8,$00,'x',$00
	dc.b	$00,$08,$00,'/',$00,'1',$00,'>'
	dc.b	$0e,$00,$f0,$00,$fe,$00,$0e,$00
	dcb.w	8
	dc.b	$bf,$ff,$ff,$ff,$0f,$ff,$f0,$00
	dc.b	$ff,$e0,$ff,$fe,$ff,$fe,$00,$1e
	dc.b	'_',$f8,'_',$ff,$bf,$ff,$e0,$07
	dc.b	$00,$00,$80,$00,$80,$00,$80,$00
	dc.b	$0f,$ff,$0f,$ff,$ff,$ff,$f0,$00
	dc.b	$ff,$fc,$ff,$e2,$ff,$fe,$00,$1e
	dc.b	$9f,$b0,$1f,$8c,$ff,$fc,$e0,'|'
	dc.b	$1b,$f2,'c',$f0,$7f,$fe,'|',$0e
	dc.b	$00,'/',$00,'7',$00,$07,$00,'8'
	dc.b	$c8,$00,$f0,$00,$f8,$00,'8',$00
	dc.b	$ff,$ff,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$ff,$fc,$ff,$f0,$ff,$fe,$00,$0e
	dcb.w	8
	dc.b	$00,'_',$00,$7f,$00,$07,$00,'x'
	dc.b	$c0,$00,$c4,$00,$fc,$00,'<',$00
	dc.b	$00,'?',$00,'_',$00,'c',$00,'|'
	dc.b	$fe,$00,$e0,$00,$fe,$00,$1e,$00
	dcb.w	8
	dc.b	$ef,$ff,'o',$ff,$9f,$ff,$f0,$00
	dc.b	$ff,$f0,$ff,$ee,$ff,$fe,$00,$1e
	dc.b	$1f,$f0,$1f,$ff,$ff,$ff,$e0,$0f
	dcb.w	4
	dc.b	$bf,$ff,'?',$ff,$cf,$ff,$f0,$00
	dc.b	$ff,$fc,$ff,$e0,$ff,$fc,$00,$1c
	dc.b	$df,$d0,$1f,$c8,$ff,'8',$e0,$f8
	dc.b	$17,$f6,$27,$f0,'9',$fe,'>',$0e
	dc.b	$00,'?',$00,$07,$00,$07,$00,'8'
	dc.b	$c0,$00,$f8,$00,$f8,$00,'8',$00
	dc.b	$ff,$ff,$ff,$ff,$1f,$ff,$e0,$00
	dc.b	$ff,$fc,$ff,$f0,$ff,$fe,$00,$0e
	dcb.w	8
	dc.b	$00,'w',$00,'7',$00,'O',$00,'x'
	dc.b	$cc,$00,$c2,$00,$fe,$00,'>',$00
	dc.b	$00,'G',$00,$87,$00,$fb,$00,$fc
	dc.b	$ec,$00,$e2,$00,$fe,$00,$1e,$00
	dcb.w	8
	dc.b	'O',$ff,$cf,$ff,$b7,$ff,$f8,$00
	dc.b	$ff,$d8,$ff,$c4,$ff,$fc,$00,'<'
	dc.b	$bf,$e0,$0f,$fe,$ff,$fe,$f0,$1e
	dcb.w	4
	dc.b	'g',$ff,$7f,$fe,$07,$ff,'x',$01
	dc.b	$ff,$e4,$ff,$e0,$ff,$dc,$00,'<'
	dc.b	$ff,'`',$1f,$f0,$ff,$10,$e0,$f0
	dc.b	$0d,$fe,$1f,$f0,$11,$fe,$1e,$0e
	dc.b	$00,'7',$00,$0f,$00,$07,$00,'8'
	dc.b	$c8,$00,$f0,$00,$f8,$00,'8',$00
	dc.b	$df,$ff,$df,$ff,'?',$ff,$e0,$00
	dc.b	$ff,$f6,$ff,$f8,$ff,$fe,$00,$0e
	dcb.w	8
	dc.b	$00,$03,$00,'C',$00,$7f,$00,'|'
	dc.b	$fc,$00,$e1,$00,$ff,$00,$1f,$00
	dc.b	$00,$e7,$00,$07,$00,$ff,$00,$f8
	dc.b	$c4,$00,$c0,$00,$fc,$00,'<',$00
	dcb.w	8
	dc.b	'S',$ff,$1f,$ff,'a',$ff,'~',$00
	dc.b	$ff,$c8,$ff,$04,$ff,$fc,$00,$fc
	dc.b	'g',$c0,$9f,$bc,$ff,$fc,$f8,'|'
	dcb.w	4
	dc.b	'C',$fd,'?',$fa,'A',$ff,'~',$07
	dc.b	$bf,'X',$ff,'|?',$84,$c0,$fc
	dc.b	$9f,' ',$7f,$e0,$ff,$00,$e0,$e0
	dc.b	$09,$f2,$0f,$fc,$01,$fe,$0e,$0e
	dc.b	$00,'/',$00,$1f,$00,$07,$00,'8'
	dc.b	$c8,$00,$f0,$00,$f8,$00,'8',$00
	dc.b	$9f,$ff,$9f,$ff,$7f,$ff,$e0,$00
	dc.b	$ff,$f2,$ff,$fc,$ff,$fe,$00,$0e
	dcb.w	8
	dc.b	$00,$27,$00,$07,$00,'9',$00,'>'
	dc.b	$f9,$00,$f0,$00,$ff,$00,$0f,$00
	dc.b	$00,$bf,$00,$8f,$00,$7f,$00,$f0
	dc.b	$c0,$00,$84,$00,$fc,$00,'|',$00
	dcb.w	8
	dc.b	'$',$0f,'\',$f0,'c',$ff,$7f,$ff
	dc.b	$00,$e0,$ff,$08,$ff,$f8,$ff,$f8
	dc.b	$00,$e0,$7f,$18,$7f,$f8,$7f,$f8
	dcb.w	4
	dc.b	'#]',$1f,'B ',$bf,'?',$ff
	dc.b	$b6,'H',$ce,'p',$01,$88,$ff,$f8
	dc.b	'7',$80,$d0,'`',$ef,$00,$ff,$e0
	dc.b	$03,$d8,$0c,$16,$01,$ee,$0f,$fe
	dc.b	$00,$1f,$00,'0',$00,$0f,$00,'?'
	dc.b	$80,$00,'8',$00,$f8,$00,$f8,$00
	dc.b	$a7,'9',$98,$c1,$7f,$fe,$ff,$ff
	dc.b	$e6,'8',$e0,'6',$1f,$ce,$ff,$fe
	dcb.w	8
	dc.b	$00,$1e,$00,'/',$00,'0',$00,'?'
	dc.b	$86,$00,'q',$00,$ff,$00,$ff,$00
	dc.b	$00,' ',$00,'?',$00,$df,$00,$ff
	bra	l0000
	dc.b	$f8,$00,$f8,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	$19,'0(',$c0,'7',$ff,'?',$ff
	dc.b	$e0,'`',$1f,$90,$ff,$f0,$ff,$f0
	dc.b	$00,$e0,$7f,$10,$7f,$f0,$7f,$f0
	dcb.w	4
	dc.b	$1e,'N',$0e,'@',$11,$bf,$1f,$ff
	dc.b	'30',$cf,' ',$00,$d0,$ff,$f0
	dc.b	's',$e0,$b0,$00,$cf,$80,$ff,$e0
	dc.b	$0f,$9c,$00,$1a,$03,$e6,$0f,$fe
	dc.b	$00,'1',$00,'.',$00,$1f,$00,'?'
	dc.b	$c0,$00,$18,$00,$f8,$00,$f8,$00
	dc.b	'N',$0c,'1',$f0,$ff,$ff,$ff,$ff
	dc.b	$9f,$9c,$80,$1a,$7f,$e6,$ff,$fe
	dcb.w	8
	dc.b	$00,$0d,$00,$16,$00,$19,$00,$1f
	dc.b	$18,$00,$e3,$00,$ff,$00,$ff,$00
	dc.b	$00,$cf,$00,'0',$00,$ff,$00,$ff
	dc.b	' ',$00,$d0,$00,$f0,$00,$f0,$00
	dcb.w	8
	dc.b	$02,'`',$05,$80,$07,$ff,$07,$ff
	dc.b	'8',$00,$07,$c0,$ff,$c0,$ff,$c0
	dc.b	$00,$00,$1f,$e0,$1f,$e0,$1f,$e0
	dcb.w	4
	dc.b	$06,'l',$02,'b',$05,$9e,$07,$fe
	dc.b	'#@',$9f,$00,$c0,$c0,$ff,$c0
	dc.b	$f1,$e0,'p',$00,$8f,$c0,$ff,$e0
	dc.b	$0f,$1e,$00,$1c,$07,$e2,$0f,$fe
	dc.b	$00,' ',$00,$1f,$00,'?',$00,'?'
	dc.b	$c0,$00,$08,$00,$f8,$00,$f8,$00
	dc.b	$9f,$04,'`',$f8,$ff,$ff,$ff,$ff
	dc.b	'0',$ce,$0f,$0c,$ff,$f2,$ff,$fe
	dcb.w	8
	dc.b	$00,$06,$00,$09,$00,$0f,$00,$0f
	dc.b	'p',$00,$81,$00,$ff,$00,$ff,$00
	dc.b	$00,$99,$00,'`',$00,$ff,$00,$ff
	dc.b	$80,$00,'`',$00,$e0,$00,$e0,$00
	dcb.w	168
l0035	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,' ',$a0,' ',$b0
	dc.b	' ',$a0,' ',$b0,$00,$80,$00,$90
	dc.b	$00,$80,$00,$90,$00,$80,$00,$90
	dc.b	$00,$80,$00,$90,$00,$80,$00,$90
	dc.b	$00,$80,$00,$90,$00,$80,$00,$90
	dc.b	$00,$80,$00,$90,$00,$80,$00,$90
	dc.b	$00,$80,$00,$90,$00,$80,$00,$90
	dc.b	$00,$80,$00,$90,$00,$80,$00,$90
	dc.b	$00,$80,$00,$90,$00,$80,$00,$90
	dc.b	'A',$a0,'A',$b0,'A',$c0,'A',$d0
	dc.b	$01,'0A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A A0',$01,$00
	dc.b	$00,$80,$00,$90,' ',$e0,' ',$f0
	dc.b	'!',$80,'!',$90,'A',$c0,'A',$d0
	dc.b	$00,' ',$00,'0!',$00,'!',$10
	dc.b	$01,$00,'!`!p',$00,$80
	dc.b	$00,$90,'A',$c0,'A',$d0,'A',$00
	dc.b	'A',$10,' ',$e0,' ',$f0,'A',$c0
	dc.b	'A',$d0,'! !0!',$a0
	dc.b	'!',$b0,$01,$00,'!',$a0,'!',$b0
	dc.b	'A',$c0,'A',$d0,$00,'@',$00,'P'
	dc.b	'!',$00,'!',$10,'A',$00,'A',$10
	dc.b	'! !0A',$c0,'A',$d0
	dc.b	$00,$00,$00,$10,'A',$c0,'A',$d0
	dc.b	' ',$a0,' ',$b0,$00,$00,$00,$10
	dc.b	'A',$c0,'A',$d0,' ',$c0,' ',$d0
	dc.b	$00,$00,$00,$10,$01,$00,'!',$80
	dc.b	'!',$90,'!',$00,'!',$10,'!',$00
	dc.b	'!',$10,'!',$00,'!',$10,'!',$00
	dc.b	'!',$10,' ',$e0,' ',$f0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,$01,'0'
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,$00,$e0,$00,$f0
	dc.b	$01,$00,'! !0!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,'! '
	dc.b	'!0!`!p!',$00
	dc.b	'!',$10,'A',$00,'A',$10,'!',$a0
	dc.b	'!',$b0,'A',$c0,'A',$d0,$01,'0'
	dc.b	$01,'0',$01,'0A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A A0 ',$a0,' ',$b0
	dc.b	$00,$00,$00,$10,'A',$c0,'A',$d0
	dc.b	' ',$a0,' ',$b0,$00,$80,$00,$90
	dc.b	'A',$c0,'A',$d0,'A@AP'
	dc.b	$00,$00,$00,$10,'A A0'
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	'!',$80,'!',$90,$00,'@',$00,'P'
	dc.b	'!`!p',$00,$80,$00,$90
	dc.b	$00,$80,$00,$90,' ',$e0,' ',$f0
	dc.b	$01,' ',$01,' ',$01,' A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,$00,'@'
	dc.b	$00,'P!',$00,'!',$10,$00,'`'
	dc.b	$00,'p',$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,'! !0',$00,$00
	dc.b	$00,$10,'!`!pA',$c0
	dc.b	'A',$d0,'!',$80,'!',$90,'!',$a0
	dc.b	'!',$b0,'!`!p',$01,$00
	dc.b	'A`ApA',$c0,'A',$d0
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$e0,'A',$f0,$00,'@',$00,'P'
	dc.b	'!',$00,'!',$10,' ',$c0,' ',$d0
	dc.b	' ',$c0,' ',$d0,'A',$c0,'A',$d0
	dc.b	$00,'`',$00,'pA',$c0,'A',$d0
	dc.b	$00,$00,$00,$10,$00,' ',$00,'0'
	dc.b	'A',$c0,'A',$d0,$01,'0B',$00
	dc.b	'B',$10,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A@AP',$00,$00
	dc.b	$00,$10,'A A0',$00,$80
	dc.b	$00,$90,'A',$c0,'A',$d0,'A',$e0
	dc.b	'A',$f0,'A',$c0,'A',$d0,'! '
	dc.b	'!0!',$00,'!',$10,'A',$00
	dc.b	'A',$10,'!`!pA',$c0
	dc.b	'A',$d0,' ',$a0,' ',$b0,$00,$80
	dc.b	$00,$90,'!',$80,'!',$90,'A',$c0
	dc.b	'A',$d0,$00,$00,$00,$10,' ',$e0
	dc.b	' ',$f0,$00,$c0,$00,$d0,' ',$a0
	dc.b	' ',$b0,'!',$00,'!',$10,'! '
	dc.b	'!0',$00,$e0,$00,$f0,'!',$00
	dc.b	'!',$10,$00,' ',$00,'0',$00,$80
	dc.b	$00,$90,'!',$80,'!',$90,'A',$c0
	dc.b	'A',$d0,'B',$00,'B',$10,'A',$c0
	dc.b	'A',$d0,$00,'@',$00,'P',$00,$00
	dc.b	$00,$10,'A',$c0,'A',$d0,'A '
	dc.b	'A0',$00,$80,$00,$90,'A',$00
	dc.b	'A',$10,'!',$a0,'!',$b0,'A',$c0
	dc.b	'A',$d0,$00,'`',$00,'p',$01,$00
	dc.b	'!`!p',$00,$80,$00,$90
	dc.b	'A',$c0,'A',$d0,'A A0'
	dc.b	$00,$00,$00,$10,$00,$c0,$00,$d0
	dc.b	'A',$00,'A',$10,$00,$80,$00,$90
	dc.b	$01,' ',$01,' ',$01,' A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A '
	dc.b	'A0A',$00,'A',$10,'A',$c0
	dc.b	'A',$d0,'!@!PA',$00
	dc.b	'A',$10,$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,' ',$a0,' ',$b0,$00,$80
	dc.b	$00,$90,'A',$c0,'A',$d0,'!',$80
	dc.b	'!',$90,$00,'@',$00,'P!`'
	dc.b	'!p!',$00,'!',$10,' ',$a0
	dc.b	' ',$b0,' ',$a0,' ',$b0,'A',$c0
	dc.b	'A',$d0,'!',$a0,'!',$b0,$00,$80
	dc.b	$00,$90,'A`Ap!',$a0
	dc.b	'!',$b0,$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,'!',$00,'!',$10,' ',$e0
	dc.b	' ',$f0,$00,'`',$00,'pA',$00
	dc.b	'A',$10,' ',$a0,' ',$b0,$00,$80
	dc.b	$00,$90,'A',$c0,'A',$d0,$01,$10
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	'!',$a0,'!',$b0,'!`!p'
	dc.b	'!',$00,'!',$10,'A',$00,'A',$10
	dc.b	'A A0',$00,$80,$00,$90
	dc.b	'A',$c0,'A',$d0,' ',$c0,' ',$d0
	dc.b	$00,$00,$00,$10,'!`!p'
	dc.b	'!`!p',$00,$00,$00,$10
	dc.b	' ',$e0,' ',$f0,'!',$a0,'!',$b0
	dc.b	'A',$c0,'A',$d0,$00,'`',$00,'p'
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	$00,'`',$00,'p!',$00,'!',$10
	dc.b	' ',$e0,' ',$f0,' ',$e0,' ',$f0
	dc.b	$00,$80,$00,$90,'!`!p'
	dc.b	'A',$c0,'A',$d0,$00,'@',$00,'P'
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	' ',$e0,' ',$f0,'!',$00,'!',$10
	dc.b	' ',$c0,' ',$d0,'A',$c0,'A',$d0
	dc.b	$00,$00,$00,$10,'A',$c0,'A',$d0
	dc.b	$00,'@',$00,'P',$00,$80,$00,$90
	dc.b	'!',$a0,'!',$b0,'A',$c0,'A',$d0
	dc.b	$00,$80,$00,$90,$00,'@',$00,'P'
	dc.b	'!`!p',$00,$00,$00,$10
	dc.b	' ',$e0,' ',$f0,'A',$c0,'A',$d0
	dc.b	'A',$e0,'A',$f0,'A',$c0,'A',$d0
	dc.b	'!',$80,'!',$90,$01,$00,'A',$c0
	dc.b	'A',$d0,'A A0!',$00
	dc.b	'!',$10,'A',$00,'A',$10,'!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,$00,$80
	dc.b	$00,$90,'!',$a0,'!',$b0,$00,$80
	dc.b	$00,$90,'!',$80,'!',$90,'A',$c0
	dc.b	'A',$d0,'! !0',$00,$00
	dc.b	$00,$10,'!',$80,'!',$90,'A',$c0
	dc.b	'A',$d0,$00,'@',$00,'P!',$00
	dc.b	'!',$10,' ',$e0,' ',$f0,'!',$a0
	dc.b	'!',$b0,$00,$80,$00,$90,' ',$e0
	dc.b	' ',$f0,'!',$a0,'!',$b0,'!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,$00,'@'
	dc.b	$00,'PA',$c0,'A',$d0,$00,$80
	dc.b	$00,$90,'!',$80,'!',$90,'!',$a0
	dc.b	'!',$b0,'A',$c0,'A',$d0,'! '
	dc.b	'!0',$00,$00,$00,$10,'!`'
	dc.b	'!p',$00,$80,$00,$90,$01,$00
	dc.b	' ',$a0,' ',$b0,'A',$c0,'A',$d0
	dc.b	$01,'0A',$c0,'A',$d0,'B',$00
	dc.b	'B',$10,$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	$00,'@',$00,'P!`!p'
	dc.b	$00,$80,$00,$90,$00,'`',$00,'p'
	dc.b	$01,$00,'!',$a0,'!',$b0,'!',$80
	dc.b	'!',$90,$01,' ',$01,' ',$01,' '
	dc.b	$01,' A',$c0,'A',$d0,$00,$c0
	dc.b	$00,$d0,$00,$a0,$00,$b0,'A`'
	dc.b	'ApA',$c0,'A',$d0,$00,'@'
	dc.b	$00,'P!',$00,'!',$10,$00,'`'
	dc.b	$00,'p',$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,$00,$80,$00,$90,'!',$a0
	dc.b	'!',$b0,'A',$c0,'A',$d0,'!',$a0
	dc.b	'!',$b0,$00,$80,$00,$90,'A`'
	dc.b	'Ap!',$a0,'!',$b0,$00,$80
	dc.b	$00,$90,$01,' ',$01,' ',$01,' '
	dc.b	$01,' A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'!',$80,'!',$90,'!',$a0
	dc.b	'!',$b0,'!`!p',$01,$00
	dc.b	'A`ApA',$c0,'A',$d0
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	$00,$80,$00,$90,'!',$a0,'!',$b0
	dc.b	'A',$c0,'A',$d0,' ',$c0,' ',$d0
	dc.b	'A',$00,'A',$10,'!',$80,'!',$90
	dc.b	$01,$00,'!@!PA',$00
	dc.b	'A',$10,$00,$80,$00,$90,$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	'! !0',$00,$00,$00,$10
	dc.b	'!`!p',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' A',$e0,'A',$f0,'A',$c0
	dc.b	'A',$d0,$00,' ',$00,'0A',$00
	dc.b	'A',$10,'A',$00,'A',$10,'A',$00
	dc.b	'A',$10,'A',$00,'A',$10,'A',$00
	dc.b	'A',$10,'A',$00,'A',$10,'!`'
	dc.b	'!p! !0!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,$01,'0'
	dc.b	'A',$c0,'A',$d0,'B',$00,'B',$10
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ! !0',$00,$00
	dc.b	$00,$10,'!`!p',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	' ',$c0,' ',$d0,$00,$00,$00,$10
	dc.b	$00,'`',$00,'pA',$c0,'A',$d0
	dc.b	' ',$c0,' ',$d0,$00,$00,$00,$10
	dc.b	'A`ApA',$c0,'A',$d0
	dc.b	$01,'0',$01,'0',$01,'0',$01,'0'
	dc.b	$01,'0',$01,'0A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$e0,'A',$f0,'A',$c0,'A',$d0
	dc.b	'!',$00,'!',$10,$00,$e0,$00,$f0
	dc.b	'A',$c0,'A',$d0,'A',$80,'A',$90
	dc.b	$00,$80,$00,$90,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$e0,$00,$f0,'A',$c0,'A',$d0
	dc.b	$01,'0B',$00,'B',$10,$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	$00,' ',$00,'0',$00,$80,$00,$90
	dc.b	' ',$e0,' ',$f0,'A',$c0,'A',$d0
	dc.b	'A A0 ',$a0,' ',$b0
	dc.b	$00,$00,$00,$10,'A',$c0,'A',$d0
	dc.b	'A',$00,'A',$10,' ',$e0,' ',$f0
	dc.b	'A',$c0,'A',$d0,$00,' ',$00,'0'
	dc.b	$00,$80,$00,$90,' ',$a0,' ',$b0
	dc.b	'A',$c0,'A',$d0,$00,$80,$00,$90
	dc.b	$00,'@',$00,'P!`!p'
	dc.b	$00,$00,$00,$10,' ',$e0,' ',$f0
	dc.b	'A',$c0,'A',$d0,$00,'@',$00,'P'
	dc.b	'!`!p',$00,$80,$00,$90
	dc.b	' ',$e0,' ',$f0,'!',$00,'!',$10
	dc.b	' ',$c0,' ',$d0,'A',$c0,'A',$d0
	dc.b	$00,'`',$00,'p',$00,$80,$00,$90
	dc.b	'A',$c0,'A',$d0,$00,'`',$00,'p'
	dc.b	' ',$a0,' ',$b0,$00,$00,$00,$10
	dc.b	'!`!p',$00,'`',$00,'p'
	dc.b	'A',$c0,'A',$d0,$01,'0',$01,'0'
	dc.b	$01,'0',$01,'0',$01,'0',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,' ',$a0,' ',$b0
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,'A',$c0,'A',$d0
	dc.b	' ',$c0,' ',$d0,$00,$80,$00,$90
	dc.b	$00,$80,$00,$90,$00,$80,$00,$90
	dc.b	$00,$80,$00,$90,$00,$80,$00,$90
	dc.b	$00,$80,$00,$90,$00,$80,$00,$90
	dc.b	$00,$80,$00,$90,$00,$80,$00,$90
	dc.b	$00,$80,$00,$90,$00,$80,$00,$90
	dc.b	$00,$80,$00,$90,$00,$80,$00,$90
	dc.b	$00,$80,$00,$90,$00,$80,$00,$90
	dc.b	$00,$80,$00,$90,$00,$80,$00,$90
	dc.b	$00,$80,$00,$90,$00,$80,$00,$90
	dc.b	$00,$80,$00,$90,$00,$80,$00,$90
	dc.b	$00,$80,$00,$90,'!`!p'
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' !@!P'
	dc.b	'A',$00,'A',$10,'A',$c0,'A',$d0
	dc.b	'!',$00,'!',$10,' ',$e0,' ',$f0
	dc.b	'A',$c0,'A',$d0,'A A0'
	dc.b	'!',$00,'!',$10,'!',$00,'!',$10
	dc.b	'!',$00,'!',$10,'!',$00,'!',$10
	dc.b	'!',$00,'!',$10,'!',$00,'!',$10
	dc.b	'!',$00,'!',$10,'!',$00,'!',$10
	dc.b	'!',$00,'!',$10,'!',$00,'!',$10
	dc.b	'!',$00,'!',$10,$01,$00,'!',$a0
	dc.b	'!',$b0,'A',$c0,'A',$d0,$00,'`'
	dc.b	$00,'p',$00,$00,$00,$10,$00,$00
	dc.b	$00,$10,$00,$00,$00,$10,$00,$00
	dc.b	$00,$10,$00,$00,$00,$10,$00,$00
	dc.b	$00,$10,$00,$00,$00,$10,$00,$00
	dc.b	$00,$10,$00,$00,$00,$10,$00,$00
	dc.b	$00,$10,$00,$00,$00,$10,' ',$e0
	dc.b	' ',$f0,'!',$80,'!',$90,$00,$80
	dc.b	$00,$90,'!`!p',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	$00,$e0,$00,$f0,'A',$00,'A',$10
	dc.b	'!`!p! !0'
	dc.b	'!',$80,'!',$90,'A',$c0,'A',$d0
	dc.b	$00,' ',$00,'0 ',$a0,' ',$b0
	dc.b	'A',$00,'A',$10,'!`!p'
	dc.b	'! !0A',$c0,'A',$d0
	dc.b	$00,'@',$00,'P',$00,$e0,$00,$f0
	dc.b	' ',$a0,' ',$b0,$01,$00,'! '
	dc.b	'!0A',$c0,'A',$d0,$00,$c0
	dc.b	$00,$d0,$00,$00,$00,$10,'!',$80
	dc.b	'!',$90,'! !0A',$c0
	dc.b	'A',$d0,$00,'@',$00,'P',$00,$e0
	dc.b	$00,$f0,' ',$e0,' ',$f0,'!',$00
	dc.b	'!',$10,'!`!p ',$80
	dc.b	' ',$90,'A',$c0,'A',$d0,$01,'0'
	dc.b	$01,'0',$01,'0',$01,'0',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$e0,'A',$f0,'A',$c0
	dc.b	'A',$d0,$00,'@',$00,'P!',$00
	dc.b	'!',$10,' ',$c0,' ',$d0,' ',$c0
	dc.b	' ',$d0,$00,$80,$00,$90,' ',$e0
	dc.b	' ',$f0,'!',$a0,'!',$b0,'A',$c0
	dc.b	'A',$d0,$00,'@',$00,'P',$00,$00
	dc.b	$00,$10,'A',$c0,'A',$d0,$01,$10
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	$00,'`',$00,'p',$00,$80,$00,$90
	dc.b	' ',$a0,' ',$b0,$01,$00,'!`'
	dc.b	'!p',$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,$01,'0',$01,'0',$01,'0'
	dc.b	$01,'0',$01,'0',$01,'0',$01,'0'
	dc.b	$01,'0A',$c0,'A',$d0,'B',$00
	dc.b	'B',$10,$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'!',$80,'!',$90,$01,$00,'A',$c0
	dc.b	'A',$d0,'A A0!',$00
	dc.b	'!',$10,'A',$00,'A',$10,'!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,$00,$00
	dc.b	$00,$10,'A A0',$00,$80
	dc.b	$00,$90,'A',$a0,'A',$b0,'A',$c0
	dc.b	'A',$d0,'! !0',$00,$00
	dc.b	$00,$10,'!',$80,'!',$90,'A',$c0
	dc.b	'A',$d0,' ',$a0,' ',$b0,$00,$00
	dc.b	$00,$10,'A',$c0,'A',$d0,'!',$a0
	dc.b	'!',$b0,$00,$80,$00,$90,'!',$a0
	dc.b	'!',$b0,$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,$00,$c0,$00,$d0,'!`'
	dc.b	'!p!',$00,'!',$10,'!',$80
	dc.b	'!',$90,'!',$80,'!',$90,$00,$80
	dc.b	$00,$90,'A',$c0,'A',$d0,$00,'@'
	dc.b	$00,'P!',$00,'!',$10,' ',$c0
	dc.b	' ',$d0,' ',$c0,' ',$d0,$00,$80
	dc.b	$00,$90,'A',$c0,'A',$d0,'A',$00
	dc.b	'A',$10,' ',$e0,' ',$f0,$00,$80
	dc.b	$00,$90,'A',$c0,'A',$d0,$00,'@'
	dc.b	$00,'P',$01,$00,'!',$a0,'!',$b0
	dc.b	'!`!p!',$00,'!',$10
	dc.b	'A',$00,'A',$10,$01,$00,' ',$a0
	dc.b	' ',$b0,' ',$a0,' ',$b0,$00,$80
	dc.b	$00,$90,'A',$c0,'A',$d0,$00,$00
	dc.b	$00,$10,'A',$c0,'A',$d0,$00,$a0
	dc.b	$00,$b0,'!',$00,'!',$10,'!`'
	dc.b	'!p',$00,'@',$00,'P',$00,$80
	dc.b	$00,$90,'A',$c0,'A',$d0,$00,'`'
	dc.b	$00,'p',$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,' ',$a0,' ',$b0,$01,$00
	dc.b	'!`!p',$00,$80,$00,$90
	dc.b	'A',$c0,'A',$d0,$00,'@',$00,'P'
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	'!',$a0,'!',$b0,$00,$80,$00,$90
	dc.b	'A`Ap!',$a0,'!',$b0
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	$00,'@',$00,'P!',$00,'!',$10
	dc.b	' ',$c0,' ',$d0,'! !0'
	dc.b	' ',$a0,' ',$b0,$00,$80,$00,$90
	dc.b	'!',$a0,'!',$b0,$00,$80,$00,$90
	dc.b	' ',$c0,' ',$d0,$00,$80,$00,$90
	dc.b	' ',$e0,' ',$f0,'!',$a0,'!',$b0
	dc.b	'A',$c0,'A',$d0,'A',$e0,'A',$f0
	dc.b	$00,'@',$00,'P',$00,$80,$00,$90
	dc.b	' ',$e0,' ',$f0,'!',$80,'!',$90
	dc.b	'A',$00,'A',$10,'!`!p'
	dc.b	$00,$80,$00,$90,'B',$00,'B',$10
	dc.b	'A',$c0,'A',$d0,'A A0'
	dc.b	'!',$00,'!',$10,'A',$00,'A',$10
	dc.b	'!',$80,'!',$90,'A',$c0,'A',$d0
	dc.b	$00,$80,$00,$90,'!',$a0,'!',$b0
	dc.b	$00,$80,$00,$90,'!',$80,'!',$90
	dc.b	'A',$c0,'A',$d0,'!',$a0,'!',$b0
	dc.b	'!`!p',$00,$80,$00,$90
	dc.b	'!',$80,'!',$90,'A',$c0,'A',$d0
	dc.b	$00,$a0,$00,$b0,'!',$00,'!',$10
	dc.b	'!`!p!',$a0,'!',$b0
	dc.b	'A',$c0,'A',$d0,$01,'0',$01,'0'
	dc.b	$01,'0',$01,'0',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'!',$a0
	dc.b	'!',$b0,'!`!p!',$00
	dc.b	'!',$10,'! !0A',$c0
	dc.b	'A',$d0,'!',$a0,'!',$b0,$00,$00
	dc.b	$00,$10,'!`!p',$00,'`'
	dc.b	$00,'pA',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,$01,'0',$01,'0',$01,'0'
	dc.b	$01,'0',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	' ',$a0,' ',$b0,$00,$00,$00,$10
	dc.b	'A',$c0,'A',$d0,$00,$a0,$00,$b0
	dc.b	$01,$00,' ',$e0,' ',$f0,'A',$c0
	dc.b	'A',$d0,$00,$80,$00,$90,'!',$80
	dc.b	'!',$90,'!',$a0,'!',$b0,'A',$c0
	dc.b	'A',$d0,'! !0!`'
	dc.b	'!p!',$00,'!',$10,$00,'@'
	dc.b	$00,'P',$00,$e0,$00,$f0,$00,$80
	dc.b	$00,$90,'A',$c0,'A',$d0,$01,'0'
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' !`!p'
	dc.b	$00,$e0,$00,$f0,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$00,$00,$10
	dc.b	$00,$00,$00,$10,$00,$e0,$00,$f0
	dc.b	'A',$c0,'A',$d0,$01,'0A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'!',$a0
	dc.b	'!',$b0,'A',$00,'A',$10,'A',$c0
	dc.b	'A',$d0,' ',$c0,' ',$d0,'A',$c0
	dc.b	'A',$d0,$00,$00,$00,$10,'!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,$00,$80
	dc.b	$00,$90,'A',$00,'A',$10,'A',$c0
	dc.b	'A',$d0,$01,$10,'!',$00,'!',$10
	dc.b	'A',$c0,'A',$d0,$01,'0',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$00,' ',$00,'0A',$80
	dc.b	'A',$90,$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,$00,' ',$00,'0A',$80
	dc.b	'A',$90,$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,$01,'0'
	dc.b	$01,'0',$01,'0',$01,' ',$01,' '
l0036	dc.b	$01,' ',$01,' '
l0037	dc.b	$01,' ',$01,' '
l0038	dc.b	$01,' ',$01,' '
l0039	dc.b	$01,' ',$01,' '
l003a	dc.b	$01,' '
l003b	dc.b	$01,' '
l003c	dc.b	$01,' '
l003d	dc.b	$01,' '
l003e	dc.b	$01,' '
l003f	dc.b	$01,' '
l0040	dc.b	$01,' '
l0041	dc.b	$01,' '
l0042	dc.b	$01,' '
l0043	dc.b	$01,' '
l0044	dc.b	$01,' '
l0045	dc.b	'A',$c0
l0046	dc.b	'A',$d0
l0047	dc.b	'A',$c0
l0048	dc.b	'A',$d0
l0049	dc.b	'A',$c0
l004a	dc.b	'A',$d0
l004b	dc.b	'A',$c0,'A',$d0
l004c	dc.b	'A',$c0,'A',$d0
l004d	dc.b	'A',$c0,'A',$d0
l004e	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0
	lea	(a0),a0
	bsr.s	l0036
	bsr.s	l003b
	bsr.s	l0037
	bsr.s	l003d
	bsr.s	l0038
	bsr.s	l003f
	bsr.s	l0039
	bsr.s	l0041
	bsr.s	l003a
	bsr.s	l0043
	bsr.s	l003c
	bsr.s	l0045
	bsr.s	l003e
	bsr.s	l0047
	bsr.s	l0040
	bsr.s	l0049
	bsr.s	l0042
	bsr.s	l004b
	bsr.s	l0044
	bsr.s	l004c
	bsr.s	l0046
	bsr.s	l004d
	bsr.s	l0048
	bsr.s	l004e
	bsr.s	l004a
l004f	bra	l0053
	bra	l0052
l0050	bra	l0058
	bra	l0051
	pea	(a0)
	lea	l00ad(pc),a0
	move.b	d0,(a0)
	movea.l	(a7)+,a0
	rts

l0051	pea	(a0)
	andi.b	#$1f,d0
	lea	l0099(pc),a0
	move.b	d0,(a0)+
	move.b	d0,(a0)+
	move.b	#0,(a0)+
	movea.l	(a7)+,a0
	rts

l0052	movem.l	a0-a6/d0-d7,-(a7)
	lea	l00af(pc),a0
	bsr	l0056
	movea.l	l00a9(pc),a1
	add.w	d0,d0
	add.w	d0,d0
	adda.w	d0,a1
	lea	l00ab(pc),a6
	move.w	(a1)+,(a6)
	moveq	#0,d0
	move.w	(a1)+,d0
	bsr	l0070
	movem.l	(a7)+,a0-a6/d0-d7
	rts

l0053	movem.l	a0-a6/d0-d7,-(a7)
	bsr.s	l0054
	movem.l	(a7)+,a0-a6/d0-d7
	rts

l0054	lea	l00af(pc),a0
	bsr.s	l0056
	tst.w	d0
	beq.s	l0055
	subq.w	#1,d0
	movea.l	l00a8(pc),a1
	mulu	#6,d0
	adda.w	d0,a1
	move.w	(a1)+,d0
	move.w	(a1)+,d1
	lea	l009c(pc),a6
	move.w	(a1)+,(a6)
	bsr	l006d
	rts

l0055	lea	l009d(pc),a0
	st	(a0)
	bra	l0058
l0056	move.w	l0097(pc),d7
	bne.s	l0057
	lea	l00ac(pc),a6
	move.l	a0,(a6)
	movea.l	4(a0),a1
	adda.l	a0,a1
	lea	l00a5(pc),a6
	move.l	a1,(a6)
	movea.l	8(a0),a1
	adda.l	a0,a1
	lea	l00a6(pc),a6
	move.l	a1,(a6)
	movea.l	12(a0),a1
	adda.l	a0,a1
	lea	l00a4(pc),a6
	move.l	a1,(a6)
	movea.l	16(a0),a1
	adda.l	a0,a1
	lea	l00a7(pc),a6
	move.l	a1,(a6)
	movea.l	20(a0),a1
	adda.l	a0,a1
	lea	l00a8(pc),a6
	move.l	a1,(a6)+
	movea.l	24(a0),a1
	adda.l	a0,a1
	move.l	a1,(a6)+
	lea	l0097(pc),a6
	st	(a6)
	lea	l00aa(pc),a6
	move.w	#0,(a6)
l0057	rts

l0058	lea	l0099(pc),a0
	tst.b	(a0)
	beq.s	l005a
	subq.b	#1,1(a0)
	bpl.s	l005a
	move.b	(a0),1(a0)
	addq.w	#1,2(a0)
	move.w	2(a0),d0
	cmp.w	#$a,d0
	bne.s	l0059
	clr.l	(a0)
	lea	l009d(pc),a0
	st	(a0)
	bra.s	l005a
l0059	lea	l0098(pc),a0
	move.b	0(a0,d0.w),d0
	lea	l009f(pc),a0
	move.b	d0,(a0)
	move.b	d0,54(a0)
	move.b	d0,108(a0)
l005a	lea	l0095(pc),a6
	lea	l009b(pc),a5
	tst.b	4(a5)
	beq.s	l005c
	tst.b	5(a5)
	bne.s	l005b
	st	5(a5)
	moveq	#0,d0
	move.b	d0,34(a6)
	move.b	d0,38(a6)
	move.b	d0,42(a6)
	move.b	l00ad(pc),d1
	bne.s	l005b
	movem.l	28(a6),d0-d3
	movem.l	d0-d3,$ffff8800.w
l005b	rts

l005c	subq.w	#1,(a5)+
	bne.s	l005d
	move.w	(a5),-(a5)
	moveq	#0,d5
	moveq	#0,d4
	lea	l009e(pc),a0
	bsr	l0061
	st	d4
	lea	l00a0(pc),a0
	bsr	l0061
	lea	l00a1(pc),a0
	bsr	l0061
l005d	lea	l009a(pc),a5
	lea	l009e(pc),a0
	bsr	l0072
	move.w	d0,-(a7)
	move.b	(a7)+,6(a6)
	move.b	d0,2(a6)
	move.b	d1,34(a6)
	lea	l00a0(pc),a0
	bsr	l0072
	move.w	d0,-(a7)
	move.b	(a7)+,14(a6)
	move.b	d0,10(a6)
	move.b	d1,38(a6)
	lea	l00a1(pc),a0
	bsr	l0072
	move.w	d0,-(a7)
	move.b	(a7)+,22(a6)
	move.b	d0,18(a6)
	move.b	d1,42(a6)
	move.w	4(a5),d0
	beq.s	l005f
	move.w	d0,-(a7)
	lea	l00a2(pc),a0
	bsr	l0072
	movea.l	8(a0),a1
	adda.w	12(a0),a1
	cmpi.b	#$e1,(a1)
	bne.s	l005e
	clr.w	4(a5)
l005e	move.w	(a7)+,d7
	lea	l0096(pc),a1
	add.w	d7,d7
	add.w	d7,d7
	adda.w	d7,a1
	moveq	#0,d6
	move.b	(a1)+,d6
	move.w	d0,-(a7)
	move.b	d0,0(a6,d6.w)
	move.b	(a1)+,d6
	move.b	(a7)+,0(a6,d6.w)
	move.b	(a1)+,d6
	move.b	d1,0(a6,d6.w)
l005f	move.b	(a5)+,d7
	ori.b	#$c0,d7
	move.b	d7,30(a6)
	move.b	(a5)+,26(a6)
	move.b	l00ad(pc),d0
	bne.s	l0060
	movem.l	(a6),a0-a2/d0-d7
	movem.l	a0-a2/d0-d7,$ffff8840.w
l0060	rts

l0061	subq.b	#1,44(a0)
	bpl.s	l0060
	move.b	45(a0),44(a0)
l0062	movea.l	40(a0),a1
l0063	move.b	(a1)+,d0
	cmp.b	#$ff,d0
	bne	l0067
	movea.l	0(a0),a2
	adda.w	4(a0),a2
	tst.b	d4
	bne.s	l0064
	subq.w	#1,50(a0)
	bpl.s	l0064
	move.w	l00a3(pc),50(a0)
	move.w	d5,4(a0)
	move.w	d5,58(a0)
	move.w	d5,112(a0)
	movea.l	0(a0),a2
l0064	moveq	#0,d1
	move.b	(a2),d1
	move.b	1(a2),21(a0)
	move.b	2(a2),20(a0)
	move.b	3(a2),d0
	move.b	d0,d2
	andi.w	#$f0,d2
	cmp.w	#$f0,d2
	bne.s	l0065
	move.b	d0,d2
	andi.b	#$f,d2
	move.b	d2,36(a0)
	bra.s	l0066
l0065	cmp.b	#$e0,d2
	bne.s	l0066
	move.b	d0,d2
	andi.w	#$f,d2
	move.w	d2,2(a5)
l0066	add.w	d1,d1
	movea.l	l00a4(pc),a3
	movea.w	0(a3,d1.w),a3
	adda.l	l00ac(pc),a3
	move.l	a3,40(a0)
	addi.w	#$c,4(a0)
	bra	l0062
l0067	cmp.b	#$fe,d0
	bne.s	l0068
	move.b	(a1),45(a0)
	move.b	(a1)+,44(a0)
	bra	l0063
l0068	cmp.b	#$fd,d0
	bne.s	l0069
	move.b	(a1),45(a0)
	move.b	(a1)+,44(a0)
	move.l	a1,40(a0)
	rts

l0069	move.b	d0,6(a0)
	move.b	(a1)+,d1
	move.b	d1,7(a0)
	andi.w	#$e0,d1
	beq.s	l006a
	move.b	(a1)+,32(a0)
l006a	move.l	a1,40(a0)
	move.l	d5,46(a0)
	tst.b	d0
	bmi.s	l006c
	move.b	7(a0),d1
	move.b	d1,d0
	andi.w	#$1f,d1
	add.b	20(a0),d1
	movea.l	l00a6(pc),a2
	add.w	d1,d1
	movea.w	0(a2,d1.w),a2
	adda.l	l00ac(pc),a2
	move.w	d5,12(a0)
	move.b	(a2),23(a0)
	move.b	(a2)+,22(a0)
	moveq	#0,d1
	move.b	(a2)+,d1
	move.b	(a2)+,27(a0)
	move.b	#$40,31(a0)
	move.b	(a2),28(a0)
	move.b	(a2)+,29(a0)
	move.b	(a2)+,30(a0)
	move.l	a2,8(a0)
	andi.b	#$40,d0
	beq.s	l006b
	move.b	32(a0),d1
l006b	movea.l	l00a5(pc),a2
	add.w	d1,d1
	movea.w	0(a2,d1.w),a2
	adda.l	l00ac(pc),a2
	move.l	a2,14(a0)
	move.w	d5,18(a0)
	move.b	d5,25(a0)
	move.b	d5,24(a0)
l006c	rts

l006d	lea	l0099(pc),a0
	clr.l	(a0)
	move.l	d0,d7
	move.l	d1,d6
	sub.l	d0,d1
	addq.l	#1,d6
	mulu	#$c,d7
	mulu	#$c,d6
	lea	l00a3(pc),a0
	move.w	d1,(a0)
	moveq	#2,d0
	lea	l009e(pc),a0
	lea	l0093(pc),a1
	lea	l0094(pc),a2
l006e	move.l	a1,14(a0)
	clr.w	18(a0)
	move.l	a1,8(a0)
	clr.w	12(a0)
	sf	6(a0)
	sf	7(a0)
	sf	26(a0)
	sf	35(a0)
	move.b	#1,23(a0)
	move.b	#1,22(a0)
	sf	24(a0)
	sf	25(a0)
	sf	27(a0)
	sf	28(a0)
	sf	29(a0)
	sf	30(a0)
	sf	32(a0)
	sf	33(a0)
	move.b	(a2),d3
	andi.w	#$f,d3
	add.w	d3,d3
	add.w	d3,d3
	move.b	(a2)+,34(a0)
	movea.l	l00a7(pc),a3
	adda.l	d7,a3
	adda.w	d3,a3
	move.l	a3,0(a0)
	move.w	#$c,4(a0)
	move.w	l00a3(pc),50(a0)
	moveq	#0,d1
	move.b	(a3)+,d1
	add.w	d1,d1
	movea.l	l00a4(pc),a4
	movea.w	0(a4,d1.w),a4
	adda.l	l00ac(pc),a4
	move.l	a4,40(a0)
	clr.w	44(a0)
	move.b	#2,38(a0)
	move.b	(a3)+,21(a0)
	move.b	(a3)+,20(a0)
	sf	37(a0)
	sf	36(a0)
	move.b	(a3)+,d1
	move.b	d1,d2
	andi.w	#$f0,d1
	cmp.w	#$f0,d1
	bne.s	l006f
	sub.b	d1,d2
	move.b	d2,36(a0)
l006f	clr.l	46(a0)
	lea	54(a0),a0
	dbf	d0,l006e
	lea	l009b(pc),a0
	move.w	#1,(a0)
	clr.w	4(a0)
	rts

l0070	move.w	l00ab(pc),d2
	move.w	l00aa(pc),d1
	tst.w	d2
	beq	l0071
	lea	l00a2(pc),a0
	lea	l009a(pc),a5
	move.b	d2,6(a0)
	move.b	d1,34(a0)
	sf	21(a0)
	moveq	#0,d5
	andi.w	#$ff,d0
	movea.l	l00a6(pc),a2
	add.w	d0,d0
	movea.w	0(a2,d0.w),a2
	adda.l	l00ac(pc),a2
	move.w	d5,12(a0)
	move.b	(a2),23(a0)
	move.b	(a2)+,22(a0)
	move.b	(a2)+,d0
	andi.w	#$ff,d0
	move.b	(a2)+,27(a0)
	move.b	#$40,31(a0)
	move.b	(a2),28(a0)
	move.b	(a2)+,29(a0)
	move.b	(a2)+,30(a0)
	move.l	a2,8(a0)
	movea.l	l00a5(pc),a2
	add.w	d0,d0
	movea.w	0(a2,d0.w),a2
	adda.l	l00ac(pc),a2
	move.l	a2,14(a0)
	move.w	d5,18(a0)
	sf	24(a0)
	sf	25(a0)
	clr.l	46(a0)
	sf	36(a0)
	sf	32(a0)
	addq.w	#1,d1
	move.w	d1,4(a5)
l0071	rts

l0072	moveq	#0,d7
	move.b	d7,33(a0)
l0073	tst.b	25(a0)
	beq.s	l0074
	subq.b	#1,25(a0)
	bra	l0079
l0074	movea.l	14(a0),a1
	adda.w	18(a0),a1
l0075	move.b	(a1)+,d0
	moveq	#0,d1
	move.b	d0,d1
	subi.w	#$e0,d1
	bmi	l0078
	add.w	d1,d1
	move.w	l0076(pc,d1.w),d1
	jmp	l0077(pc,d1.w)
l0076	dc.b	$00,$00,$00,$10,$00,$1a,$00,'*'
	dc.b	$00,':',$00,'J',$00,'X',$00,'f'
	dc.b	$00,$80,$00,$8c,$00,$aa
l0077	moveq	#0,d0
	move.b	(a1)+,d0
	move.w	d0,18(a0)
	movea.l	14(a0),a1
	adda.l	d0,a1
	bra.s	l0075
	move.b	-2(a1),26(a0)
	bra	l0079
	move.w	d7,12(a0)
	move.b	#1,22(a0)
	addq.w	#1,18(a0)
	bra.s	l0075
	move.b	(a1)+,27(a0)
	move.b	(a1)+,28(a0)
	addq.w	#3,18(a0)
	bra	l0075
	move.b	d7,38(a0)
	move.b	(a1)+,33(a0)
	addq.w	#2,18(a0)
	bra	l0075
	move.b	#1,38(a0)
	addq.w	#1,18(a0)
	bra	l0075
	move.b	#2,38(a0)
	addq.w	#1,18(a0)
	bra	l0075
	move.b	#0,d1
	move.b	(a1)+,d1
	lsl.w	#6,d1
	movea.l	l00a5(pc),a1
	adda.w	d1,a1
	move.l	a1,14(a0)
	move.w	d7,18(a0)
	bra	l0075
	move.b	(a1)+,25(a0)
	addq.w	#2,18(a0)
	bra	l0073
	movea.w	#$8870,a3
	move.b	#$b,(a3)
	move.b	(a1)+,2(a3)
	move.l	#$c000d0a,d0
	movep.l	d0,8(a3)
	addq.w	#2,18(a0)
	bra	l0075
	move.b	#$20,7(a0)
	move.b	(a1)+,32(a0)
	addq.w	#2,18(a0)
	bra	l0075
l0078	move.b	d0,26(a0)
	addq.w	#1,18(a0)
l0079	tst.b	24(a0)
	beq.s	l007a
	subq.b	#1,24(a0)
	bra.s	l007f
l007a	subq.b	#1,22(a0)
	bne.s	l007f
	move.b	23(a0),22(a0)
	movea.l	8(a0),a1
	adda.w	12(a0),a1
l007b	moveq	#0,d1
	move.b	(a1)+,d0
	move.b	d0,d1
	subi.w	#$e0,d1
	bmi.s	l007e
	add.w	d1,d1
	move.w	l007c(pc,d1.w),d1
	jmp	l007d(pc,d1.w)
l007c	dc.b	$00,$02,$00,$14,$00,$00,$00,$00
	dcb.w	4
	dc.b	$00,$1c
l007d	rts

	moveq	#0,d1
	move.b	(a1)+,d1
	subq.w	#5,d1
	move.w	d1,12(a0)
	movea.l	8(a0),a1
	adda.w	d1,a1
	bra.s	l007b
	move.b	-2(a1),35(a0)
	bra.s	l007f
	addq.w	#2,12(a0)
	move.b	(a1),24(a0)
	bra.s	l0079
l007e	move.b	d0,35(a0)
	addq.w	#1,12(a0)
l007f	move.b	26(a0),d0
	bmi.s	l0080
	add.b	6(a0),d0
	add.b	21(a0),d0
l0080	andi.w	#$7f,d0
	lea	l00ae(pc),a1
	add.w	d0,d0
	move.w	d0,d1
	move.w	0(a1,d0.w),d0
	move.b	34(a0),d3
	move.b	38(a0),d2
	bne.s	l0081
	bclr	d3,(a5)
	addq.w	#3,d3
	bclr	d3,(a5)
	bra.s	l0084
l0081	cmp.b	#1,d2
	bne.s	l0083
	bset	d3,(a5)
	addq.w	#3,d3
	bclr	d3,(a5)
	move.b	6(a0),33(a0)
	move.b	26(a0),d4
	bpl.s	l0082
	andi.b	#$7f,d4
	move.b	d4,33(a0)
	bra.s	l0084
l0082	add.b	d4,33(a0)
	bra.s	l0084
l0083	bclr	d3,(a5)
	addq.w	#3,d3
	bset	d3,(a5)
l0084	tst.b	33(a0)
	beq.s	l0085
	move.b	33(a0),d3
	not.b	d3
	andi.b	#$1f,d3
	move.b	d3,1(a5)
l0085	move.b	31(a0),d6
	tst.b	30(a0)
	beq.s	l0086
	subq.b	#1,30(a0)
	bra.s	l0090
l0086	move.b	d1,d5
	move.b	28(a0),d4
	bmi.s	l0087
	add.b	d4,d4
	bra.s	l0088
l0087	andi.b	#$7f,d4
l0088	move.b	29(a0),d1
	tst.b	d6
	bpl.s	l0089
	btst	d7,d6
	bne.s	l008c
l0089	btst	#5,d6
	bne.s	l008a
	sub.b	27(a0),d1
	bcc.s	l008b
	bset	#5,d6
	moveq	#0,d1
	bra.s	l008b
l008a	add.b	27(a0),d1
	cmp.b	d4,d1
	bcs.s	l008b
	bclr	#5,d6
	move.b	d4,d1
l008b	move.b	d1,29(a0)
l008c	lsr.b	#1,d4
	sub.b	d4,d1
	bcc.s	l008d
	subi.w	#$100,d1
l008d	addi.b	#$a0,d5
	bcs.s	l008f
l008e	add.w	d1,d1
	addi.b	#$18,d5
	bcc.s	l008e
l008f	add.w	d1,d0
l0090	bchg	d7,d6
	move.b	d6,31(a0)
	btst	#5,7(a0)
	beq.s	l0091
	moveq	#0,d1
	move.b	32(a0),d1
	ext.w	d1
	swap	d1
	asr.l	#4,d1
	move.l	46(a0),d2
	add.l	d1,d2
	move.l	d2,46(a0)
	swap	d2
	sub.w	d2,d0
l0091	move.b	35(a0),d1
	sub.b	36(a0),d1
	sub.b	37(a0),d1
	bpl.s	l0092
	moveq	#0,d1
l0092	rts

l0093	dc.b	$01,$00,$00,$00,$00,$00,$00,$e1
l0094	dc.b	$00,$01,$02,$00
l0095	dc.b	$00,$00,'>',$00,$01,$01,$01,$00
	dc.b	$02,$02,$ee,$00,$03,$03,$00,$00
	dc.b	$04,$04,$ee,$00,$05,$05,$0e,$00
	dc.b	$06,$06,$00,$00,$07,$07,$f8,$ff
	dc.b	$08,$08,$0d,$00,$09,$09,$0b,$00
	dc.b	$0a,$0a,$00,$00
l0096	dcb.w	2
	dc.b	$02,$06,'"',$00,$0a,$0e,'&',$00
	dc.b	$12,$16,'*',$00
l0097	dc.b	$00,$00
l0098	dc.b	$00,$01,$02,$03,$04,$05,$06,$07
	dc.b	$08,$09,$0a,$0b,$0f,$0f,$0f,$0f
	dc.b	$0f,$0f
l0099	dcb.w	2
l009a	dc.b	'8',$00,$00,$00,$00,$00,$00,$00
l009b	dc.b	$00,$04
l009c	dc.b	$00,$04
l009d	dc.b	$00,$00
l009e	dc.b	$00,$00,'-\',$00,$18,'+',$00
	dc.b	$00,$00,')',$0d,$00,$01,$00,$00
	dc.b	'(',$a2,$00,$03,$00,$00,$02,$02
	dc.b	$00,$00,$00,$01,$02,$02,$03,'A'
	dc.b	$00,$00,$00,$0d,$00
l009f	dc.b	$00,$02,$00,$00,$00,'+',$b6,$01,$01
	dcb.w	2
	dc.b	$00,'Y',$00,$00
l00a0	dc.b	$00,$00,'-`',$00,$18,'0',$00
	dc.b	$00,$00,')',$0d,$00,$05,$00,$00
	dc.b	'(',$a2,$00,$04,$00,$00,$02,$02
	dc.b	$00,$00,$00,$01,$02,$02,$00,'a'
	dc.b	$00,$00,$01,$0b,$00,$00,$02,$00
	dc.b	$00,$00,'+',$c7,$01,$03,$00,$00
	dc.b	$00,$00,$00,'Z',$00,$00
l00a1	dc.b	$00,$00,'-d',$00,$18,$00,$00
	dc.b	$00,$00,'%',$e2,$00,$07,$00,$00
	dc.b	'%',$e2,$00,$07,$00,$00,$01,$01
	dcb.w	3
	dc.b	$00,$01,$00,$00,$02,$00,$0f,$00
	dc.b	$02,$00,$00,$00,')',$de,$01,$1f
	dcb.w	2
	dc.b	$00,'Z',$00,$00
l00a2	dcb.w	27
	dc.b	$00,'@'
l00a3	dc.b	$00,'Z'
l00a4	dc.b	$00,$00,')',$92
l00a5	dc.b	$00,$00,'(',$90
l00a6	dc.b	$00,$00,'(',$f6
l00a7	dc.b	$00,$00,'-\',$00,$00
l00a8	dc.b	$00,$00,'1',$a0
l00a9	dc.b	$00,$00,'1',$b2
l00aa	dc.b	$00,$00
l00ab	dc.b	$00,$00
l00ac	dc.b	$00,$00,'(P'
l00ad	dc.b	$00,$00
l00ae	dc.b	$0e,$ee,$0e,$17,$0d,'M',$0c,$8e
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
	dcb.w	32
l00af	dc.b	'COSO',$00,$00,$00,'@'
	dc.b	$00,$00,$00,$a6,$00,$00,$01,'B'
	dc.b	$00,$00,$05,$0c,$00,$00,$09,'P'
	dc.b	$00,$00,$09,'b',$00,$00,$00,$00
	dc.b	'TFMX',$00,$08,$00,$08
	dc.b	$00,'$',$00,'Z',$00,'@',$00,$04
	dc.b	$00,$02,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$00,'R',$00,'W',$00,']',$00,'d'
	dc.b	$00,'m',$00,'|',$00,$81,$00,$85
	dc.b	$00,$9a,$e2,$e6,$00,$00,$e1,$e2
	dc.b	$e9,$1e,$e6,$00,$e1,$e2,$e9,'!'
	dc.b	$e6,$0c,$00,$e1,$e2,$e5,$94,$e6
	dc.b	$97,$93,$90,$82,$e1,$e2,$e5,$94
	dc.b	$e6,$9d,$9f,$e5,$94,$90,$96,$94
	dc.b	$92,$90,$00,$e1,$e2,$e6,$0c,$00
	dc.b	$e1,$e2,$e6,$00,$e1,$e2,$e5,$9a
	dc.b	$e6,$0f,$0e,$0d,$0c,$0b,$0a,$09
	dc.b	$08,$07,$06,$05,$04,$03,$02,$01
	dc.b	$00,$e1,$e2,$e6,$00,$e8,$10,$00
	dc.b	$e3,$02,$04,$00,$e1,$00,$00,$b8
	dc.b	$00,$d0,$00,$d7,$00,$de,$00,$ea
	dc.b	$01,$03,$01,$1a,$01,'"',$01,'9'
	dc.b	$02,$00,$01,$02,$04,$0d,$0e,$0d
	dc.b	$0c,$0b,$0a,$0b,$0a,$09,$08,$07
	dc.b	$06,$05,$04,$03,$02,$01,$00,$e1
	dc.b	$01,$01,$00,$00,$00,$10,$e1,$01
	dc.b	$02,$00,$00,$00,$10,$e1,$01,$03
	dc.b	$00,$00,$00,$0d,$0f,$0f,$10,$0a
	dc.b	$00,$e1,$01,$04,$00,$00,$00,$0d
	dc.b	$0f,$0f,$0e,$0d,$0c,$0b,$0a,$09
	dc.b	$08,$07,$06,$05,$05,$04,$03,$02
	dc.b	$01,$00,$e1,$01,$05,$01,$02,$00
	dc.b	$0c,$0d,$0e,$0d,$0c,$0b,$0a,$09
	dc.b	$08,$07,$06,$05,$04,$03,$02,$01
	dc.b	$00,$e1,$01,$06,$02,$04,$0a,$0f
	dc.b	$0e,$e1,$01,$07,$00,$00,$00,$0d
	dc.b	$0f,$0e,$0d,$0c,$0b,$0a,$09,$08
	dc.b	$07,$06,$05,$04,$03,$02,$01,$00
	dc.b	$e1,$01,$08,$01,$01,$00,$0f,$0e
	dc.b	$e1,$00,$01,$8c,$01,$8f,$01,$bc
	dc.b	$01,$cf,$01,$e2,$01,$f3,$02,$04
	dc.b	$02,'A',$02,'|',$02,$b5,$02,$f4
	dc.b	$03,$17,$03,':',$03,'g',$03,'x'
	dc.b	$03,$a5,$03,$b0,$03,$b5,$03,$be
	dc.b	$03,$c6,$03,$d6,$03,$db,$03,$e2
	dc.b	$03,$ed,$03,$f6,$04,$19,$04,':'
	dc.b	$04,'_',$04,$82,$04,$a5,$04,$c8
	dc.b	$04,$cd,$04,$dd,$04,$e8,$04,$f1
	dc.b	$04,$f6,$04,$fb,$fd,$1f,$ff,$fe
	dc.b	$01,'+',$00,$fe,$03,'0',$00,$fe
	dc.b	$01,'+',$00,$fe,$03,'0',$00,$fe
	dc.b	$01,'+',$00,$fe,$03,'0',$00,$fe
	dc.b	$01,'+',$00,$fe,$03,'0',$00,$fe
	dc.b	$01,'+',$00,$fe,$03,'0',$00,$fe
	dc.b	$01,'+',$00,$ff,$fe,$03,$0c,$00
	dc.b	$0c,$00,$0c,$00,$0c,$00,$0c,$00
	dc.b	$0c,$00,$0c,$00,$0c,$00,$ff,$fd
	dc.b	$03,$fe,$05,'7',$00,'5',$00,'3'
	dc.b	$00,'2',$00,$fe,$01,'3',$00,'5'
	dc.b	$00,$ff,$fd,$03,$fe,$05,'7',$00
	dc.b	'5',$00,'4',$00,'2',$00,$fe,$03
	dc.b	'5',$00,$ff,$fd,$03,$fe,$05,'7'
	dc.b	$00,'5',$00,'4',$00,'2',$00,$fe
	dc.b	$03,'4',$00,$ff,$fe,$00,$0c,$03
	dc.b	$18,$01,$fe,$01,$0c,$01,$0c,$01
	dc.b	$0c,$01,$0c,$04,$0c,$01,$0c,$01
	dc.b	$0c,$01,$fe,$00,$0c,$03,$18,$01
	dc.b	$fe,$01,$0c,$01,$fe,$00,$0c,$03
	dc.b	$18,$01,$fe,$01,$0c,$01,$0c,$04
	dc.b	$fe,$00,$0c,$03,$18,$01,$fe,$01
	dc.b	$0c,$01,$fe,$00,$0c,$03,$18,$01
	dc.b	$ff,$fe,$01,$0c,$03,$fe,$03,$0c
	dc.b	$01,$fe,$01,$0c,$01,$0c,$04,$0c
	dc.b	$01,$fe,$00,$0c,$03,$18,$01,$fe
	dc.b	$01,$0c,$01,$0c,$01,$fe,$00,$0c
	dc.b	$03,$18,$01,$0c,$00,$0c,$01,$0c
	dc.b	$03,$18,$01,$fe,$01,$0c,$04,$0c
	dc.b	$01,$fe,$00,$0c,$03,$18,$01,$fe
	dc.b	$01,$0c,$01,$ff,$fe,$00,$0c,$03
	dc.b	$18,$02,$fe,$01,$0c,$02,$0c,$02
	dc.b	$0c,$02,$0c,$04,$0c,$02,$0c,$02
	dc.b	$0c,$02,$fe,$00,$0c,$03,$18,$02
	dc.b	$fe,$01,$0c,$02,$fe,$00,$0c,$03
	dc.b	$18,$02,$fe,$01,$0c,$02,$0c,$04
	dc.b	$fe,$00,$0c,$03,$18,$02,$fe,$01
	dc.b	$0c,$02,$0c,$03,$ff,$fe,$00,$0c
	dc.b	$03,$18,$02,$fe,$01,$0c,$02,$0c
	dc.b	$02,$0c,$02,$0c,$04,$0c,$02,$fe
	dc.b	$00,$0c,$03,$18,$02,$fe,$01,$0c
	dc.b	$02,$fe,$00,$0c,$03,$18,$02,$fe
	dc.b	$01,$0c,$04,$fe,$00,$0c,$03,$18
	dc.b	$02,$fe,$01,$0c,$02,$0c,$04,$0c
	dc.b	$02,$fe,$00,$0c,$02,$18,$02,$fe
	dc.b	$01,$0c,$04,$ff,$fe,$01,'+',$00
	dc.b	'0',$00,'7',$00,'+',$00,'0',$00
	dc.b	'5',$00,'+',$00,'0',$00,'3',$00
	dc.b	'+',$00,'0',$00,'2',$00,'+',$00
	dc.b	'0',$00,'3',$00,'5',$00,$ff,$fe
	dc.b	$01,')',$00,'.',$00,'5',$00,')'
	dc.b	$00,'.',$00,'3',$00,')',$00,'.'
	dc.b	$00,'2',$00,')',$00,'.',$00,'0'
	dc.b	$00,')',$00,'.',$00,'2',$00,'3'
	dc.b	$00,$ff,$fe,$01,'$',$00,$fe,$03
	dc.b	'+',$00,$fe,$01,'$',$00,$fe,$03
	dc.b	'+',$00,$fe,$01,'$',$00,$fe,$03
	dc.b	'+',$00,$fe,$01,'$',$00,$fe,$03
	dc.b	'+',$00,$fe,$01,'$',$00,$fe,$03
	dc.b	'+',$00,$fe,$01,'+',$00,$ff,$fd
	dc.b	$03,$fe,$05,'0',$00,'0',$00,'0'
	dc.b	$00,'0',$00,$fe,$03,'0',$00,$ff
	dc.b	$fe,$01,'$',$00,$fe,$03,')',$00
	dc.b	$fe,$01,'$',$00,$fe,$03,')',$00
	dc.b	$fe,$01,'$',$00,$fe,$03,')',$00
	dc.b	$fe,$01,'$',$00,$fe,$03,')',$00
	dc.b	$fe,$01,'$',$00,$fe,$03,')',$00
	dc.b	$fe,$01,')',$00,$ff,$fe,$17,$8c
	dc.b	' ',$7f,$fe,$07,$16,'  ',$ff
	dc.b	$fe,$1f,$18,$00,$ff,$fd,$17,$fe
	dc.b	$03,$1a,$00,$18,$00,$ff,$fe,$0f
	dc.b	$16,' ',$14,$98,$00,$ff,$fd,$17
	dc.b	$fe,$03,$16,$00,$fe,$00,$15,' '
	dc.b	$80,$fe,$02,$93,$00,$ff,$fe,$1f
	dc.b	$11,$00,$ff,$fd,$17,$fe,$07,$0f
	dc.b	$00,$ff,$fe,$00,$11,$00,$0f,$00
	dc.b	$fe,$1d,$0c,$00,$ff,$fe,$1d,$0c
	dc.b	$03,$fe,$01,$0c,$03,$ff,$fe,$01
	dc.b	'$',$00,'+',$00,'0',$00,'$',$00
	dc.b	'+',$00,'0',$00,'$',$00,'+',$00
	dc.b	'0',$00,'$',$00,'+',$00,'0',$00
	dc.b	'$',$00,'+',$00,'0',$00,'+',$00
	dc.b	$ff,$fe,$03,$0c,$03,$0c,$07,$fe
	dc.b	$01,$0a,$07,$fe,$05,$0a,$07,$fe
	dc.b	$01,$08,$07,$fe,$03,$07,$07,$07
	dc.b	$07,$fe,$01,$05,$07,$fe,$03,$05
	dc.b	$07,$ff,$fe,$01,$0c,$03,$0c,$00
	dc.b	$0c,$00,$0c,$00,$fe,$03,$0c,$04
	dc.b	$fe,$01,$0c,$00,$0c,$03,$0c,$03
	dc.b	$0c,$00,$0c,$03,$0c,$00,$0c,$04
	dc.b	$0c,$00,$fe,$03,$0c,$00,$ff,$fe
	dc.b	$01,'$',$00,'+',$00,'.',$00,'$'
	dc.b	$00,'+',$00,'.',$00,'$',$00,'+'
	dc.b	$00,'.',$00,'$',$00,'+',$00,'.'
	dc.b	$00,'$',$00,'+',$00,'.',$00,'+'
	dc.b	$00,$ff,$fe,$01,'$',$00,')',$00
	dc.b	'.',$00,'$',$00,')',$00,'.',$00
	dc.b	'$',$00,')',$00,'.',$00,'$',$00
	dc.b	')',$00,'.',$00,'$',$00,')',$00
	dc.b	'.',$00,')',$00,$ff,$fe,$01,'$'
	dc.b	$00,')',$00,'-',$00,'$',$00,')'
	dc.b	$00,'-',$00,'$',$00,')',$00,'-'
	dc.b	$00,'$',$00,')',$00,'-',$00,'$'
	dc.b	$00,')',$00,'-',$00,')',$00,$ff
	dc.b	$fe,$1f,'$',$00,$ff,$fe,$03,'*'
	dc.b	' ',$10,$fe,$17,$ab,$00,$fe,$01
	dc.b	')',$00,$27,$00,$ff,$fe,$1b,')'
	dc.b	$00,$fe,$01,'+',$00,')',$00,$ff
	dc.b	$fd,$0f,$fe,$07,$27,$00,')',$00
	dc.b	$ff,$fe,$1f,'+',$00,$ff,$fe,$1f
	dc.b	'0',$00,$ff,$fe,$03,'* ',$08
	dc.b	$fe,$17,$ab,$00,$fe,$01,')',$00
	dc.b	$27,$00,$ff,$00,$0c,$00,$00,$f0
	dc.b	$0d,$00,$00,$f0,$00,$00,$00,$ff
	dc.b	$0c,$00,$00,$00,$0d,$00,$00,$00
	dcb.w	2
	dc.b	$0c,$00,$00,$00,$0d,$fe,$00,$00
	dcb.w	2
	dc.b	$0c,$00,$00,$00,$0d,$fe,$00,$00
	dcb.w	2
	dc.b	$0e,$00,$00,$00,$0d,$fe,$00,$00
	dcb.w	2
	dc.b	$0e,$00,$00,$00,$0d,$fd,$00,$00
	dcb.w	2
	dc.b	$0c,$00,$00,$00,$0d,$00,$00,$00
	dcb.w	2
	dc.b	$0c,$00,$00,$00,$0d,$00,$00,$00
	dc.b	$0f,$00,$06,$f0,$0c,$00,$00,$00
	dc.b	$0d,$00,$00,$00,$10,$00,$06,$00
	dc.b	$0c,$00,$00,$00,$0d,$00,$00,$00
	dc.b	$11,$00,$06,$00,$0c,$00,$00,$00
	dc.b	$0d,$fe,$00,$00,$12,$00,$06,$00
	dc.b	$0c,$00,$00,$00,$0d,$fe,$00,$00
	dc.b	$13,$00,$06,$00,$0e,$00,$00,$00
	dc.b	$0d,$fe,$00,$00,$14,$00,$06,$00
	dc.b	$0e,$00,$00,$00,$0d,$fd,$00,$00
	dc.b	$15,$00,$06,$00,$0c,$00,$00,$00
	dc.b	$0d,$00,$00,$00,$16,$00,$06,$00
	dc.b	$0c,$00,$00,$00,$0d,$00,$00,$00
	dc.b	$0f,$00,$06,$00,$18,$00,$00,$00
	dc.b	$06,$00,$00,$00,$10,$00,$06,$00
	dc.b	$18,$00,$00,$00,$07,$00,$00,$00
	dc.b	$11,$00,$06,$00,$1b,$00,$00,$00
	dc.b	$08,$fe,$00,$00,$12,$00,$06,$00
	dc.b	$1b,$00,$00,$00,$09,$fe,$00,$00
	dc.b	$13,$00,$06,$00,$1c,$00,$00,$00
	dc.b	$1a,$f9,$00,$00,$14,$00,$06,$00
	dc.b	$1d,$00,$00,$00,$1a,$f9,$00,$00
	dc.b	$15,$00,$06,$00,$18,$00,$00,$00
	dc.b	$06,$00,$00,$00,$16,$00,$06,'P'
	dc.b	$18,$00,$00,$00,$07,$00,$00,$00
	dc.b	$00,$00,$06,$00,$01,$00,$00,$00
	dc.b	$03,$00,$00,$00,$06,$00,$00,$00
	dc.b	$01,$00,$00,$00,$03,$00,$00,$00
	dc.b	$07,$00,$00,$00,$01,$fe,$00,$00
	dc.b	$04,$fe,$00,$00,$08,$fe,$00,$00
	dc.b	$01,$fe,$00,$00,$05,$fe,$00,$00
	dc.b	$09,$fe,$00,$00,$01,$00,$00,$00
	dc.b	$03,$00,$00,$00,$06,$00,$00,$00
	dc.b	$01,$00,$00,$00,$03,$00,$00,$00
	dc.b	$07,$00,$00,$00,$01,$fe,$00,$00
	dc.b	$05,$fe,$00,$00,$08,$fe,$00,$00
	dc.b	$01,$fe,$00,$00,$04,$fe,$00,$00
	dc.b	$09,$fe,$00,$00,$0a,$00,$00,$00
	dc.b	$1e,$00,$08,$f1,$06,$00,$00,$00
	dc.b	$0a,$00,$00,$00,$1f,$00,$08,$00
	dc.b	$07,$00,$00,$00,$0b,$00,$00,$00
	dc.b	' ',$00,$08,$00,$08,$fe,$00,$00
	dc.b	$0b,$00,$00,$00,'!',$00,$08,$00
	dc.b	$09,$fe,$00,$00,$0a,$00,$00,$00
	dc.b	'"',$00,$08,$f1,$06,$00,$00,$00
	dc.b	$0a,$00,$00,$00,'#',$00,$08,$f1
	dc.b	$07,$00,$00,$00,$0b,$00,$00,$00
	dc.b	' ',$00,$08,$00,$08,$fe,$00,$00
	dc.b	$0b,$00,$00,$00,$00,$00,$08,$00
	dc.b	$09,$fe,$00,$00,$0a,$00,$00,$00
	dc.b	$0c,$00,$00,$f1,$06,$00,$00,$00
	dc.b	$0a,$00,$00,$00,$0c,$00,$00,$00
	dc.b	$07,$00,$00,$00,$0b,$00,$00,$00
	dc.b	$0c,$fe,$00,$00,$08,$fe,$00,$00
	dc.b	$0b,$00,$00,$00,$0c,$fe,$00,$00
	dc.b	$09,$fe,$00,$00,$0a,$00,$00,$00
	dc.b	$0c,$00,$00,$f1,$06,$00,$00,$00
	dc.b	$0a,$00,$00,$00,$0c,$00,$00,$00
	dc.b	$07,$00,$00,$00,$0b,$00,$00,$00
	dc.b	$0c,$fe,$00,$00,$08,$fe,$00,$00
	dc.b	$0b,$00,$00,$00,$0c,$fe,$00,$00
	dc.b	$09,$fe,$00,$00,$0a,$00,$00,$00
	dc.b	$1e,$0c,$08,$f1,$06,$00,$00,$00
	dc.b	$0a,$00,$00,$00,'$',$0c,$08,$00
	dc.b	$07,$00,$00,$00,$0b,$00,$00,$00
	dc.b	' ',$0c,$08,$00,$08,$fe,$00,$00
	dc.b	$0b,$00,$00,$00,'!',$0c,$08,$00
	dc.b	$09,$fe,$00,$00,$0a,$00,$00,$00
	dc.b	'"',$0c,$08,$f1,$06,$00,$00,$00
	dc.b	$0a,$00,$00,$00,'#',$0c,$08,$f1
	dc.b	$07,$00,$00,$00,$0b,$00,$00,$00
	dc.b	' ',$0c,$08,$00,$08,$fe,$00,$00
	dc.b	$0b,$00,$00,$00,$00,$0c,$08,$00
	dc.b	$09,$fe,$00,$00,$01,$00,$00,$00
	dc.b	$03,$00,$00,$00,$06,$00,$00,$00
	dc.b	$01,$00,$00,$00,$03,$00,$00,$00
	dc.b	$07,$00,$00,$00,$01,$fe,$00,$00
	dc.b	$05,$fe,$00,$00,$08,$fe,$00,$00
	dc.b	$01,$fe,$00,$00,$04,$fe,$00,$00
	dc.b	$09,$fe,$00,$00,$01,$00,$00,$00
	dc.b	$03,$00,$00,$00,$06,$00,$00,$00
	dc.b	$01,$00,$00,$00,$03,$00,$00,$00
	dc.b	$07,$00,$00,$00,$01,$fe,$00,$00
	dc.b	$05,$fe,$00,$00,$08,$fe,$00,$00
	dc.b	$01,$fe,$00,$00,$04,$fe,$00,$00
	dc.b	$09,$fe,$00,$00,$18,$00,$00,$00
	dc.b	$06,$00,$00,$f0,$10,$00,$06,$00
	dc.b	$18,$00,$00,$00,$07,$00,$00,$00
	dc.b	$11,$00,$06,$00,$1b,$00,$00,$00
	dc.b	$08,$fe,$00,$00,$12,$00,$06,$00
	dc.b	$1b,$00,$00,$00,$09,$fe,$00,$00
	dc.b	$13,$00,$06,$00,$1c,$00,$00,$00
	dc.b	$1a,$f9,$00,$00,$14,$00,$06,$00
	dc.b	$1d,$00,$00,$00,$1a,$f9,$00,$00
	dc.b	$15,$00,$06,$00,$18,$00,$00,$00
	dc.b	$06,$00,$00,$00,$16,$00,$06,'P'
	dc.b	$18,$00,$00,$00,$07,$00,$00,$00
	dc.b	$00,$00,$06,$00,$18,$00,$00,$00
	dc.b	$06,$00,$00,$00,$10,$00,$06,$00
	dc.b	$18,$00,$00,$00,$07,$00,$00,$00
	dc.b	$11,$00,$06,$00,$1b,$00,$00,$00
	dc.b	$08,$fe,$00,$00,$12,$00,$06,$00
	dc.b	$1b,$00,$00,$00,$09,$fe,$00,$00
	dc.b	$13,$00,$06,$00,$1c,$00,$00,$00
	dc.b	$1a,$f9,$00,$00,$14,$00,$06,$00
	dc.b	$1d,$00,$00,$00,$1a,$f9,$00,$00
	dc.b	$15,$00,$06,$00,$18,$00,$00,$00
	dc.b	$06,$00,$00,$00,$16,$00,$06,$00
	dc.b	$18,$00,$00,$00,$07,$00,$00,$00
	dc.b	$00,$00,$06,$00,$18,$00,$00,$f1
	dc.b	$06,$00,$00,$00,$0c,$fb,$00,$f1
	dc.b	$18,$00,$00,$f2,$07,$00,$00,$00
	dc.b	$0c,$fc,$00,$f2,$18,$00,$00,$f3
	dc.b	$06,$00,$00,$00,$0c,$fe,$00,$f3
	dc.b	$18,$00,$00,$f4,$07,$00,$00,$00
	dc.b	$0c,$00,$00,$f4,$18,$00,$00,$f7
	dc.b	$06,$00,$00,$00,$0c,$00,$00,$f7
	dc.b	$18,$00,$00,$ff,$07,$00,$00,$00
	dc.b	$00,$00,$00,$ff,$0c,$00,$00,$f3
	dc.b	$0d,$00,$00,$f3,$1a,$00,$00,$f0
	dc.b	$0c,$00,$00,$f2,$0d,$00,$00,$f2
	dc.b	$1a,$00,$00,$f1,$0c,$00,$00,$f1
	dc.b	$0d,$00,$00,$f1,$1a,$00,$00,$f2
	dc.b	$0c,$00,$00,$f0,$0d,$00,$00,$f0
	dc.b	$1a,$00,$00,$f3,$0c,$00,$00,$f0
	dc.b	$0d,$00,$00,$f0,$1a,$00,$00,$f4
	dc.b	$00,$00,$00,'Z',$00,$04,$00,$00
	dc.b	$00,'Z',$00,$04,$00,$00,$00,$00
	dc.b	$00,$00
l00b0	dcb.w	64
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dcb.w	60
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dcb.w	56
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$fe,$00,$00
	dcb.w	53
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dcb.w	48
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dc.b	$ff,$fe,$ff,$fe,$00,$00,$00,$00
	dcb.w	43
	dc.b	$e0,$00,$1f,$fe,$ff,$fe,$00,$00
	dc.b	$00,$00,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$00,$00,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$00,$00,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$00,$00,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$00,$00,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$00,$00,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$00,$00,$ff,$fe,$ff,$fe,$00,$00
	dc.b	$00,$00,$ff,$fe,$ff,$fe,$00,$00
	dcb.w	40
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dcb.w	36
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dcb.w	32
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dcb.w	30
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
	dcb.w	24
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
	dcb.w	18
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
	dcb.w	16
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
	dcb.w	13
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
	dc.b	$ff,$fe,$00,$00,$00,$00
l00b1	dc.b	$00,$00,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$00,$00
	dcb.w	44
	dc.b	$00,$04,$00,$04,$00,$04,$00,$04
	dcb.w	17
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$7f,$ff
	dc.b	$80,$00,$ff,$ff,$00,$00,$ff,$9e
	dc.b	$00,' ',$ff,$ff,$00,$00,$00,$00
	dcb.w	43
	dc.b	$00,$08,$00,$08,$00,$08,$00,$08
	dcb.w	16
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	64
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	60
	dc.b	$00,$10,$00,$10,$00,$10,$00,$10
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	16
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dcb.w	44
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	8
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dcb.w	32
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	12
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	40
	dc.b	$00,$10,$00,$10,$00,$10,$00,$10
	dcb.w	16
	dc.b	$10,$00,$10,$00,$10,$00,$10,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	5
	dc.b	'@',$00,'@',$00,'@',$00,' ',$00
	dc.b	' ',$00,' ',$00,' ',$00,$00,$00
	dcb.w	3
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dcb.w	28
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dcb.w	4
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dcb.w	4
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	4
	dc.b	'@',$00,$00,$00,'@',$00,'@',$00
	dcb.w	32
	dc.b	$00,$02,$00,$02,$00,$02,$00,$02
	dc.b	$00,$04,$00,$04,$00,$04,$00,$04
	dcb.w	4
	dc.b	$0a,$00,$0a,$00,$0a,$00,$0a,$00
	dcb.w	8
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$fc,$9e,'? ',$ff,$ff,$00,$00
	dcb.w	6
	dc.b	'@',$00,'@',$00,$00,' ',$00,' '
	dc.b	$00,' ',$00,' ',$00,$00,$00,$00
	dcb.w	50
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$fc,$9e,'? ',$ff,$ff,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$fd,$9e,'  ',$ff,$ff,$00,$00
	dcb.w	4
	dc.b	'@',$00,'@',$00,$00,$00,'@',$00
	dcb.w	4
	dc.b	$00,$10,$00,$10,$00,$10,$00,$10
	dcb.w	4
	dc.b	'@',$00,'@',$00,'@',$00,'@',$00
	dcb.w	36
	dc.b	$00,$08,$00,$08,$00,$08,$00,$08
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$fd,$9e,'  ',$ff,$ff,$00,$00
	dc.b	'p',$0f,$80,$00,$ff,$ff,$00,$00
	dc.b	$fb,$9e,'  ',$ff,$ff,$00,$00
	dcb.w	5
	dc.b	'@',$00,$00,$00,'@',$00,$00,$10
	dc.b	$00,$10,$00,$10,$00,$10,$08,$02
	dc.b	$08,$02,$08,$02,$08,$02,$00,$00
	dcb.w	39
	dc.b	$04,$00,$04,$00,$04,$00,$04,$00
	dcb.w	4
	dc.b	'p',$0f,$80,$00,$ff,$ff,$00,$00
	dc.b	$fb,$9e,'  ',$ff,$ff,$00,$00
	dc.b	'w',$ff,$80,$10,$ff,$ff,$00,$00
	dc.b	$f7,$9e,'  ',$ff,$ff,$00,$00
	dcb.w	4
	dc.b	'@',$00,$00,$00,$00,$00,'@',$00
	dcb.w	4
	dc.b	'0',$00,'0',$00,'0',$00,'0',$00
	dcb.w	4
	dc.b	$04,$00,$04,$00,$04,$00,$04,$00
	dcb.w	24
	dc.b	$00,'@',$00,'@',$00,'@',$00,'@'
	dc.b	$04,$00,$04,$00,$04,$00,$04,$00
	dcb.w	4
	dc.b	$02,$00,$02,$00,$02,$00,$02,$00
	dc.b	'w',$ff,$80,$10,$ff,$ff,$00,$00
	dc.b	$f7,$9e,'  ',$ff,$ff,$00,$00
	dc.b	'w',$ff,$80,$10,$ff,$ff,$00,$00
	dc.b	$cf,$9e,'  ',$ff,$ff,$00,$00
	dc.b	$00,$14,$00,$27,$00,'8',$00,'?'
	dc.b	$ea,$00,'Y',$00,'G',$00,$ff,$00
	dcb.w	32
	dc.b	$08,$10,$08,$10,$08,$10,$08,$10
	dcb.w	12
	dc.b	'@',$00,'@',$00,'@',$00,'@',$00
	dcb.w	4
	dc.b	'w',$ff,$80,$10,$ff,$ff,$00,$00
	dc.b	$cf,$9e,'  ',$ff,$ff,$00,$00
	dc.b	'w',$ff,$80,$10,$ff,$ff,$00,$00
	dc.b	$df,$80,' ',$00,$ff,$ff,$00,$00
	dcb.w	4
	dc.b	'@',$00,$00,$00,$00,$00,'@',$00
	dcb.w	40
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dcb.w	12
	dc.b	'w',$ff,$80,$10,$ff,$ff,$00,$00
	dc.b	$df,$80,' ',$00,$ff,$ff,$00,$00
	dc.b	'w',$ff,$80,$10,$ff,$ff,$00,$00
	dc.b	$ff,$80,$00,'>',$ff,$ff,$00,$00
	dcb.w	4
	dc.b	'@',$00,$00,$00,$00,$00,'@',$00
	dcb.w	4
	dc.b	'0',$00,'0',$00,'0',$00,'0',$00
	dcb.w	36
	dc.b	$02,$00,$02,$00,$02,$00,$02,$00
	dcb.w	8
	dc.b	'w',$ff,$80,$10,$ff,$ff,$00,$00
	dc.b	$ff,$80,$00,'>',$ff,$ff,$00,$00
	dc.b	'w',$ff,$83,$d0,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	5
	dc.b	'@',$00,$00,$00,'@',$00,$00,$00
	dcb.w	11
	dc.b	$03,$00,$03,$00,$03,$00,$03,$00
	dcb.w	20
	dc.b	$00,$04,$00,$04,$00,$04,$00,$04
	dcb.w	16
	dc.b	'w',$ff,$83,$d0,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	'w',$af,$82,$10,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	4
	dc.b	'@',$00,'@',$00,$00,$00,'@',$00
	dcb.w	4
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dcb.w	4
	dc.b	$12,$00,$12,$00,$12,$00,$12,$00
	dcb.w	20
	dc.b	$00,$02,$00,$02,$00,$02,$00,$02
	dcb.w	16
	dc.b	'w',$af,$82,$10,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	'w',$af,$82,$10,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	4
	dc.b	'@',$00,'@',$00,$00,$00,'@',$00
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dc.b	$00,$02,$00,$02,$00,$02,$00,$02
	dcb.w	28
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$02,$00,$02,$00,$02,$00,$02,$00
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dcb.w	4
	dc.b	'w',$af,$82,$10,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	'w',$af,$82,$10,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	6
	dc.b	'@',$00,'@',$00,$00,$00,$00,$00
	dcb.w	54
	dc.b	'w',$af,$82,$10,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	'w',$af,$82,$10,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	4
	dc.b	'@',$00,$00,$00,'@',$00,'@',$00
	dc.b	$02,$00,$02,$00,$02,$00,$02,$00
	dcb.w	4
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dcb.w	24
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dcb.w	8
	dc.b	$00,$10,$00,$10,$00,$10,$00,$10
	dc.b	'@',$00,'@',$00,'@',$00,'@',$00
	dc.b	'w',$af,$82,$10,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	't/',$82,$10,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	5
	dc.b	'@',$00,'@',$00,'@',$00,$00,$02
	dc.b	$00,$02,$00,$02,$00,$02,$02,$00
	dc.b	$02,$00,$02,$00,$02,$00,$80,$08
	dc.b	$80,$08,$80,$08,$80,$08,$02,$00
	dc.b	$02,$00,$02,$00,$02,$00,$00,$00
	dcb.w	31
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dc.b	't/',$82,$10,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	'w',$ef,$80,$10,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	5
	dc.b	'@',$00,'@',$00,'@',$00,$00,$00
	dcb.w	3
	dc.b	$80,$08,$80,$08,$80,$08,$80,$08
	dcb.w	4
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	28
	dc.b	$04,$00,$04,$00,$04,$00,$04,$00
	dcb.w	4
	dc.b	$00,$02,$00,$02,$00,$02,$00,$02
	dc.b	'w',$ef,$80,$10,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	'w',$ef,$80,$10,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	52
	dc.b	'@',$00,'@',$00,'@',$00,'@',$00
	dcb.w	8
	dc.b	'w',$ef,$80,$10,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	'w',$ef,$80,$10,$ff,$ff,$00,$00
	dc.b	$ff,$80,$00,$00,$ff,$ff,$00,$00
	dcb.w	4
	dc.b	$00,$02,$00,$02,$00,$02,$00,$02
	dcb.w	4
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dcb.w	28
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dc.b	$10,$00,$10,$00,$10,$00,$10,$00
	dcb.w	12
	dc.b	'w',$ef,$80,$10,$ff,$ff,$00,$00
	dc.b	$ff,$80,$00,$00,$ff,$ff,$00,$00
	dc.b	'w',$ef,$80,$10,$ff,$ff,$00,$00
	dc.b	$ff,$80,$00,'>',$ff,$ff,$00,$00
	dcb.w	8
	dc.b	$04,$00,$04,$00,$04,$00,$04,$00
	dc.b	$10,$00,$10,$00,$10,$00,$10,$00
	dcb.w	4
	dc.b	$00,$10,$00,$10,$00,$10,$00,$10
	dcb.w	20
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dc.b	$04,$00,$04,$00,$04,$00,$04,$00
	dcb.w	8
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dc.b	'w',$ef,$80,$10,$ff,$ff,$00,$00
	dc.b	$ff,$80,$00,'>',$ff,$ff,$00,$00
	dc.b	'p',$0f,$87,$f0,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	12
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dcb.w	40
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dc.b	'p',$0f,$87,$f0,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	4
	dc.b	$00,$02,$00,$02,$00,$02,$00,$02
	dcb.w	4
	dc.b	$10,$00,$10,$00,$10,$00,$10,$00
	dcb.w	36
	dc.b	$06,$00,$06,$00,$06,$00,$06,$00
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dcb.w	4
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	$00,$00,$80,$00,$ff,$ff,$00,$00
	dc.b	$00,$1e,$00,' ',$ff,$ff,$00,$00
	dcb.w	16
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dcb.w	45
	dc.b	$80,$00,$ff,$ff,$00,$00,$00,$1e
	dc.b	$00,' ',$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$1e
	dc.b	$ff,$a0,$ff,$ff,$00,$00,$00,$00
	dcb.w	11
	dc.b	$03,$00,$03,$00,$03,$00,$03,$00
	dcb.w	28
	dc.b	$00,$03,$00,$03,$00,$03,$00,$03
	dc.b	$04,$00,$04,$00,$04,$00,$04,$00
	dcb.w	13
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$1e
	dc.b	$ff,$a0,$ff,$ff,$00,$00,$7f,$ff
	dc.b	$80,$00,$ff,$ff,$00,$00,$ff,$9e
	dc.b	$00,' ',$ff,$ff,$00,$00,$00,$00
	dcb.w	11
	dc.b	$00,$04,$00,$04,$00,$04,$00,$04
	dcb.w	44
	dc.b	$02,$00,$02,$00,$02,$00,$02,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	$7f,$ff,$80,$00,$f0,$00,$0f,$ff
	dc.b	$ff,$fe,$00,$00,$00,$0f,$ff,$f0
	dcb.w	8
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dcb.w	36
	dc.b	'@',$01,'@',$01,'@',$01,'@',$01
	dcb.w	8
	dc.b	$00,$04,$00,$04,$00,$04,$00,$04
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	$7f,$ff,$80,$00,$e0,$00,$1f,$ff
	dc.b	$ff,$fe,$00,$00,$00,$1f,$ff,$e0
	dcb.w	56
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dcb.w	4
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	$7f,$ff,$80,$00,$e7,$cf,$18,'0'
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dcb.w	40
	dc.b	$04,$00,$04,$00,$04,$00,$04,$00
	dcb.w	4
	dc.b	$03,$7f,$00,$1f,$00,$1f,$00,$9f
	dc.b	$ff,$fb,$ff,$f8,$ff,$f8,$ff,$fc
	dcb.w	4
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	'`',$c8,$9f,'7',$e0,$c8,$1f,'7'
	dc.b	$d7,$00,'(',$80,$d7,$7f,'(',$80
	dcb.w	52
	dc.b	$02,$7f,$00,$1f,$00,$1f,$00,$9f
	dc.b	$ff,$fb,$ff,$f8,$ff,$f8,$ff,$fc
	dc.b	$82,$00,$02,$00,$02,$00,$02,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$80,$00,$00,$ff,$ff,$00,$00
	dc.b	'pK',$8f,$b4,$f0,'K',$0f,$b4
	dc.b	'Z',$80,$a5,'>Z',$ff,$a5,$00
	dcb.w	12
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	32
	dc.b	$00,$7f,$00,$1f,$00,$1f,$00,$1f
	dc.b	$ff,$fb,$f8,'x',$f8,'x',$f8,'|'
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$80,$00,'>',$ff,$ff,$00,$00
	dc.b	$7f,$ff,$81,$b7,$fe,'H',$01,$b7
	dc.b	$ff,$9e,'" ',$dd,$ff,'"',$00
	dcb.w	40
	dc.b	$02,$00,$02,$00,$02,$00,$02,$00
	dc.b	$00,$05,$00,$05,$00,$05,$00,$05
	dcb.w	4
	dc.b	$02,$7f,$00,$1f,$00,$1f,$00,$9f
	dc.b	$ff,$fb,$f8,'x',$f8,'x',$f8,'|'
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	$7f,$ff,$9f,$b5,$e0,'J',$1f,$b5
	dc.b	$ff,$9e,'% ',$da,$ff,'%',$00
	dcb.w	52
	dc.b	$02,$7f,$00,$1f,$00,$1f,$00,$9f
	dc.b	$ff,$fb,$f8,'x',$f8,'x',$f8,'|'
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	'`',$00,$80,$cb,$ff,$ff,$1f,'4'
	dc.b	$17,$1e,'P ',$ff,$ff,$a8,$80
	dcb.w	12
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	36
	dc.b	$02,$7f,$00,$1f,$00,$1f,$00,$9f
	dc.b	$ff,$fb,$f8,'x',$f8,'x',$f8,'|'
	dc.b	$c0,'@',$00,'@',$00,'@',$00,'@'
	dc.b	'`',$00,$9f,$ff,$ff,$ff,$00,$00
	dc.b	$1f,$9e,$f0,' ',$ff,$ff,$00,$00
	dc.b	'o',$ff,$90,$00,$ff,$ff,$00,$00
	dc.b	$ef,$9e,$00,' ',$ff,$ff,$00,'@'
	dcb.w	44
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dcb.w	4
	dc.b	$02,$7f,$00,$1f,$00,$1f,$00,$9f
	dc.b	$ff,$fb,$f8,'x',$f8,'x',$f8,'|'
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	'o',$ff,$90,$00,$ff,$ff,$00,$00
	dc.b	$ef,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	$00,$00,$80,$00,$ff,$ff,$7f,$ff
	dc.b	$00,$1e,$00,$00,$ff,$ff,$ff,$e0
	dcb.w	44
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dcb.w	4
	dc.b	$03,$7f,$00,$1f,$00,$1f,$00,$9f
	dc.b	$ff,$fb,$f8,'x',$f8,'x',$f8,'|'
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	'o',$ff,$90,$00,$ff,$ff,$00,$00
	dc.b	$ef,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	'o',$ff,$90,$00,$ff,$ff,$00,$00
	dc.b	$ef,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	8
	dc.b	$00,$04,$00,$04,$00,$04,$00,$04
	dcb.w	40
	dc.b	$83,$7f,$80,$1f,$80,$1f,$80,$9f
	dc.b	$ff,$fb,$f8,'x',$f8,'x',$f8,'|'
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	'o',$ff,$90,$00,$ff,$ff,$00,$00
	dc.b	$ef,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	'o',$ff,$90,$00,$ff,$ff,$00,$00
	dc.b	$ef,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	4
	dc.b	$00,$08,$00,$08,$00,$08,$00,$08
	dcb.w	36
	dc.b	$00,$04,$00,$04,$00,$04,$00,$04
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dc.b	$03,$7f,$00,$1f,$00,$1f,$00,$9f
	dc.b	$ff,$fb,$f8,'x',$f8,'x',$f8,'|'
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	'o',$ff,$90,$00,$ff,$ff,$00,$00
	dc.b	$ef,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	'o',$ff,$90,$00,$ff,$ff,$00,$00
	dc.b	$ef,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	52
	dc.b	$03,$7f,$00,$1f,$00,$1f,$00,$9f
	dc.b	$ff,$fb,$f8,'x',$f8,'x',$f8,'|'
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	'o',$ff,$90,$00,$ff,$ff,$00,$00
	dc.b	$ef,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	'o',$ff,$90,$00,$ff,$ff,$00,$00
	dc.b	$ef,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	4
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dcb.w	40
	dc.b	$00,$10,$00,$10,$00,$10,$00,$10
	dc.b	$03,$7f,$00,$0f,$00,$0f,$00,$8f
	dc.b	$ff,$fb,$ff,$f0,$ff,$f0,$ff,$f4
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	'o',$ff,$90,$00,$ff,$ff,$00,$00
	dc.b	$ef,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	'o',$ff,$90,$00,$ff,$ff,$00,$00
	dc.b	$ef,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	12
	dc.b	$00,'@',$00,'@',$00,'@',$00,'@'
	dcb.w	36
	dc.b	$03,$bf,$00,$00,$00,$00,$00,'@'
	dc.b	$ff,$f7,$00,$00,$00,$00,$00,$08
	dc.b	$c0,$10,$00,$10,$00,$10,$00,$10
	dc.b	'o',$ff,$90,$00,$ff,$ff,$00,$00
	dc.b	$ef,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	'o',$ff,$90,$00,$ff,$ff,$00,$00
	dc.b	$ef,$be,$00,' ',$ff,$ff,$00,$00
	dcb.w	4
	dc.b	$00,$10,$00,$10,$00,$10,$00,$10
	dcb.w	36
	dc.b	$00,$02,$00,$02,$00,$02,$00,$02
	dcb.w	4
	dc.b	$03,$c0,$00,$00,$00,$00,$00,'?'
	dc.b	$00,$0f,$00,$00,$00,$00,$ff,$f0
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	'o',$ff,$90,$00,$ff,$ff,$00,$00
	dc.b	$ef,$be,$00,' ',$ff,$ff,$00,$00
	dc.b	'o',$ff,$90,$00,$ff,$ff,$00,$00
	dc.b	$ef,$be,$00,' ',$ff,$ff,$00,$00
	dcb.w	8
	dc.b	$00,'@',$00,'@',$00,'@',$00,'@'
	dcb.w	29
	dc.b	$00,' ',$00,' ',$00,' ',$00,$00
	dcb.w	7
	dc.b	$03,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	'o',$ff,$90,$00,$ff,$ff,$00,$00
	dc.b	$ef,$be,$00,' ',$ff,$ff,$00,$00
	dc.b	'o',$ff,$90,$00,$ff,$ff,$00,$00
	dc.b	$ef,$be,$00,' ',$ff,$ff,$00,$00
	dcb.w	40
	dc.b	$00,' ',$00,$00,$00,' ',$00,' '
	dcb.w	8
	dc.b	$03,$c0,$00,$00,$00,$00,$00,'?'
	dc.b	$00,$03,$00,$00,$00,$00,$ff,$fc
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	'o',$ff,$90,$00,$ff,$ff,$00,$00
	dc.b	$ef,$be,$00,' ',$ff,$ff,$00,$00
	dc.b	'`',$00,$90,$00,$ff,$ff,$00,$00
	dc.b	$0f,$be,$00,' ',$ff,$ff,$00,$00
	dcb.w	4
	dc.b	$00,$10,$00,$10,$00,$10,$00,$10
	dc.b	$14,$00,$14,$00,$14,$00,$14,$00
	dcb.w	30
	dc.b	$00,' ',$00,' ',$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dc.b	$03,$bf,$00,$00,$00,$00,$00,'@'
	dc.b	$ff,$fd,$00,$00,$00,$00,$00,$02
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	'`',$00,$90,$00,$ff,$ff,$00,$00
	dc.b	$0f,$be,$00,' ',$ff,$ff,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$be,$00,' ',$ff,$ff,$00,$00
	dcb.w	40
	dc.b	$00,' ',$00,' ',$00,$00,$00,' '
	dcb.w	8
	dc.b	$03,$bf,$00,$1f,$00,$1f,$00,'_'
	dc.b	$ff,$fd,$ff,$f8,$ff,$f8,$ff,$fa
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$be,$00,' ',$ff,$ff,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$be,$00,' ',$ff,$ff,$00,$00
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dcb.w	37
	dc.b	$00,' ',$00,$00,$00,' ',$00,$00
	dcb.w	3
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dc.b	$03,$bf,$00,$1f,$00,$1f,$00,'_'
	dc.b	$ff,$fd,$ff,$f8,$ff,$f8,$ff,$fa
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$be,$00,' ',$ff,$ff,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	4
	dc.b	$00,'@',$00,'@',$00,'@',$00,'@'
	dcb.w	8
	dc.b	$04,$00,$04,$00,$04,$00,$04,$00
	dcb.w	20
	dc.b	$00,' ',$00,$00,$00,$00,$00,' '
	dcb.w	8
	dc.b	$03,$bf,$00,$1f,$00,$1f,$00,'_'
	dc.b	$ff,$fd,$ff,$f8,$ff,$f8,$ff,$fa
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	4
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dc.b	$0a,$00,$0a,$00,$0a,$00,$0a,$00
	dcb.w	28
	dc.b	$0a,'u',$13,$ac,$1c,'#',$1f,$ff
	dc.b	$00,$00,$80,$00,$80,$00,$80,$00
	dc.b	$10,$00,$10,$00,$10,$00,$10,$00
	dc.b	$03,$bf,$00,$1f,$00,$1f,$00,'_'
	dc.b	$ff,$fd,$ff,$f8,$ff,$f8,$ff,$fa
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$9e,$00,' ',$ff,$ff,$00,$00
	dcb.w	2
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$02,$00,$02,$00,$02,$00,$02,$00
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dcb.w	28
	dc.b	$00,' ',$00,$00,$00,$00,$00,' '
	dcb.w	4
	dc.b	$00,$04,$00,$04,$00,$04,$00,$04
	dc.b	$03,$bf,$00,$1f,$00,$1f,$00,'_'
	dc.b	$ff,$fd,$a5,$f8,$a5,$f8,$ff,$fa
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$00,$ff,$ff
	dc.b	$ff,$ff,$00,$00,$00,$00,$ff,$fe
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dcb.w	18
	dc.b	$8c,$fc,$00,$00,$00,$00,$8c,$fc
	dc.b	$8c,$fc,$00,$00,$00,$00,$8c,$fc
	dc.b	$00,$1f,$00,$00,$00,$00,$00,$1f
	dc.b	$9f,$9f,$00,$00,$00,$00,$9f,$9f
	dc.b	$9f,$9f,$00,$00,$00,$00,$9f,$9f
	dc.b	$99,$a0,$00,$00,$00,$00,$99,$a0
	dcb.w	4
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dc.b	$03,$bf,$00,$1f,$00,$1f,$00,'_'
	dc.b	$a5,$fd,$ff,$f8,$a5,$f8,$ff,$fa
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$00,$00,$ff,$fe,$ff,$ff,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$ff,$00,$00
	dcb.w	17
	dc.b	$00,$01,$00,$00,$00,$01,$00,$00
	dc.b	$8d,$fd,$00,$00,$8d,$fd,$00,$00
	dc.b	$8d,$fc,$00,$00,$8d,$fc,$00,$00
	dc.b	$00,'?',$00,$00,$00,'?',$00,$00
	dc.b	$bf,$bf,$00,$00,$bf,$bf,$00,$00
	dc.b	$bf,$bf,$00,$00,$bf,$bf,$00,$00
	dc.b	$bd,$a0,$00,$00,$bd,$a0,$00,$00
	dcb.w	7
	dc.b	$03,$bf,$00,$1f,$00,$1f,$00,'_'
	dc.b	$a5,$fd,$ff,$f8,$a5,$f8,$ff,$fa
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$ff,$00,$00
	dc.b	'|',$00,$80,$00,$ff,$ff,$00,$00
	dc.b	$1e,$02,$01,$f8,$ff,$ff,$00,$00
	dcb.w	4
	dc.b	$00,$08,$00,$08,$00,$08,$00,$08
	dc.b	$00,$02,$00,$02,$00,$02,$00,$02
	dcb.w	28
	dc.b	$00,' ',$00,' ',$00,$00,$00,' '
	dcb.w	8
	dc.b	$03,$bf,$00,$1f,$00,$1f,$00,'_'
	dc.b	$ff,$fd,$ff,$f8,'$',$f8,$ff,$fa
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	'|',$00,$80,$00,$ff,$ff,$00,$00
	dc.b	$1e,$02,$01,$f8,$ff,$ff,$00,$00
	dc.b	'}',$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$de,$02,'!',$f0,$ff,$ff,$00,$00
	dcb.w	12
	dc.b	$00,$02,$00,$02,$00,$02,$00,$02
	dc.b	$00,$01,$00,$01,$00,$00,$00,$01
	dc.b	$ad,$8d,$ad,$8d,$00,$00,$ad,$8d
	dc.b	$dd,$e0,$dd,$e0,$00,$00,$dd,$e0
	dc.b	$00,'?',$00,'?',$00,$00,$00,'?'
	dc.b	$b0,'?',$b0,'?',$00,$00,$b0,'?'
	dc.b	$bc,'<',$bc,'<',$00,$00,$bc,'<'
	dc.b	'7',$a0,'7',$a0,$00,$00,'7',$a0
	dcb.w	4
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dc.b	$03,$bf,$00,$1f,$00,$1f,$00,'_'
	dc.b	'$',$fd,'$',$f8,$ff,$f8,$ff,$fa
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	'}',$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$de,$02,'!',$f0,$ff,$ff,$00,$00
	dc.b	'}',$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$de,'r!',$80,$ff,$ff,$00,$00
	dcb.w	18
	dc.b	$00,$01,$00,$01,$00,$00,$00,$00
	dc.b	$fd,$bd,$fd,$bd,$00,$00,$00,$00
	dc.b	$fd,$80,$fd,$80,$00,$00,$00,$00
	dc.b	$00,$01,$00,$01,$00,$00,$00,$00
	dc.b	$b0,'>',$b0,'>',$00,$00,$00,$00
	dc.b	'0000',$00,$00,$00,$00
	dc.b	'3',$a0,'3',$a0,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,'@',$00,'@',$00,'@',$00,'@'
	dc.b	$03,$be,$00,$1e,$00,$1f,$00,'_'
	dc.b	'f}fx',$ff,$f8,$ff,$fa
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	'}',$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$de,'r!',$80,$ff,$ff,$00,$00
	dc.b	'}',$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$de,'r!',$80,$ff,$ff,$00,$00
	dcb.w	20
	dc.b	$f9,$8c,$00,$00,$f9,$8c,$f9,$8c
	dc.b	$f9,$fc,$00,$00,$f9,$fc,$f9,$fc
	dc.b	$00,'?',$00,$00,$00,'?',$00,'?'
	dc.b	$bf,$b7,$00,$00,$bf,$b7,$bf,$b7
	dc.b	'?',$bf,$00,$00,'?',$bf,'?',$bf
	dc.b	$b1,$a0,$00,$00,$b1,$a0,$b1,$a0
	dcb.w	4
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dc.b	$03,$bf,$00,$18,$00,$1f,$00,'_'
	dc.b	$ff,$fd,'f',$18,$ff,$f8,$ff,$fa
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	'}',$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$de,'r!',$80,$ff,$ff,$00,$00
	dc.b	'|',$00,$81,$ff,$ff,$ff,$00,$00
	dc.b	$1e,$02,$e1,$00,$ff,$ff,$00,$00
	dcb.w	4
	dc.b	$00,$10,$00,$10,$00,$10,$00,$10
	dcb.w	4
	dc.b	$00,'@',$00,'@',$00,'@',$00,'@'
	dcb.w	5
	dc.b	'q',$dc,'q',$dc,'q',$dc,$00,$00
	dc.b	'q',$fc,'q',$fc,'q',$fc,$00,$00
	dc.b	$00,'?',$00,'?',$00,'?',$00,$00
	dc.b	$bf,$b3,$bf,$b3,$bf,$b3,$00,$00
	dc.b	$bf,$bf,$bf,$bf,$bf,$bf,$00,$00
	dc.b	$b1,$a0,$b1,$a0,$b1,$a0,$00,$00
	dcb.w	3
	dc.b	$11,$00,$11,$00,$11,$00,$11,$00
	dc.b	$03,$b8,$00,$1f,$00,$1f,$00,'_'
	dc.b	$e7,$1d,$ff,$f8,$ff,$f8,$ff,$fa
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	'|',$00,$81,$ff,$ff,$ff,$00,$00
	dc.b	$1e,$02,$e1,$00,$ff,$ff,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$ff,$00,$00
	dcb.w	41
	dc.b	$00,' ',$00,' ',$00,' ',$00,$00
	dcb.w	3
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dc.b	$03,$bf,$00,$1f,$00,$1f,$00,'_'
	dc.b	$ff,$fd,$ff,$f8,$ff,$f8,$ff,$fa
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$fe,$02,$00,$00,$ff,$ff,$00,$00
	dc.b	$00,$00,$80,$00,$ff,$ff,$00,$00
	dcb.w	2
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dcb.w	50
	dc.b	$02,$bf,$00,$1f,$00,$1f,$00,'_'
	dc.b	$ff,$fd,$ff,$f8,$ff,$f8,$ff,$fa
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dc.b	$7f,$ff,$80,$00,$ff,$ff,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$ff,$00,$00
	dcb.w	16
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dcb.w	20
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dcb.w	16
	dc.b	$03,$bf,$00,$1f,$00,$1f,$00,'_'
	dc.b	$ff,$fd,$ff,$f8,$ff,$f8,$ff,$fa
	dc.b	$c0,$01,$00,$01,$00,$01,$00,$01
	dc.b	$00,$00,$80,$00,$ff,$ff,$00,$00
	dcb.w	2
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dcb.w	26
	dc.b	$00,$08,$00,$08,$00,$08,$00,$08
	dcb.w	76
	dc.b	$04,$00,$04,$00,$04,$00,$04,$00
	dcb.w	68
	dc.b	$00,'0',$00,'P',$00,'o',$00,$7f
	dc.b	$dc,$ec,$e3,$cf,$00,'0',$ff,$ff
	dc.b	$e4,$e4,$19,$1c,$04,$03,$fd,$ff
	dc.b	$27,$ff,'8<',$c0,$c3,$ff,$ff
	dc.b	$c0,$e4,$f9,$1c,$04,$03,$fd,$ff
	dc.b	$27,'98',$f9,$c0,$06,$ff,$ff
	dc.b	$80,$a2,$a1,'c`',$1c,$e1,$ff
	dc.b	'G',$1c,$9f,$e4,'@',$00,$df,$fc
	dc.b	$01,$c7,$01,'?',$00,$00,$01,$ff
	dc.b	$00,$00,$c0,$00,$00,$00,$c0,$00
	dcb.w	40
	dc.b	$00,$d8,$00,'x',$00,$87,$00,$ff
	dc.b	$ee,'M',$f1,$ce,$00,'0',$ff,$ff
	dc.b	$c8,'v4',$8e,$0d,$01,$fd,$ff
	dc.b	'f',$e3,'y',$e3,$80,$1c,$ff,$ff
	dc.b	$00,'v',$f4,$8e,$0d,$01,$fd,$ff
	dc.b	'f',$e7,'y',$e7,$80,$18,$ff,$ff
	dc.b	'0V',$e8,$b7,$19,$08,$f9,$ff
	dc.b	$93,$bc,'O',$c8,$d0,$04,$df,$fc
	dc.b	$01,$ee,$00,$9f,$01,$00,$01,$ff
	dc.b	'@',$00,$80,$00,'@',$00,$c0,$00
	dcb.w	40
	dc.b	$00,$e8,$01,$98,$01,$07,$01,$ff
	dc.b	's[|',$dc,$80,' ',$ff,$ff
	dc.b	$90,';lG',$1d,$80,$fd,$ff
	dc.b	$e8,$ee,$f7,$ef,$00,$10,$ff,$ff
	dc.b	$04,';',$e8,'G',$1d,$80,$fd,$ff
	dc.b	$e8,$ee,$f7,$ef,$00,$10,$ff,$ff
	dc.b	'h',$15,$e0,'v',$19,$89,$f9,$ff
	dc.b	$09,$bc,$d7,$d0,$d8,$0c,$df,$fc
	dc.b	$01,$ec,$00,'_',$01,$80,$01,$ff
	dc.b	$80,$00,'@',$00,$c0,$00,$c0,$00
	dcb.w	40
	dc.b	$01,'`',$00,$90,$01,$00,$01,$f0
	dcb.w	4
	dc.b	$01,$00,$1c,$00,$1d,$c0,$1d,$c0
	dcb.w	4
	dc.b	$09,$00,$10,$00,$1d,$c0,$1d,$c0
	dcb.w	4
	dc.b	'Y',$00,'D',$01,'=',$c1,'}',$c1
	dc.b	$04,$18,$d8,$00,$dc,$1c,$dc,$1c
	dc.b	$00,$c1,$00,$00,$01,$c1,$01,$c1
	dc.b	$00,$00,$c0,$00,$c0,$00,$c0,$00
	dcb.w	40
	dc.b	$01,$80,$01,$e0,$00,$00,$01,$e0
	dcb.w	4
	dc.b	$0d,$80,$10,$00,$1d,$c0,$1d,$c0
	dcb.w	4
	dc.b	$19,$80,$00,$00,$1d,$c0,$1d,$c0
	dcb.w	4
	dc.b	'=',$80,$00,$01,'=',$c1,'=',$c1
	dc.b	$10,$10,$cc,$02,$dc,$1e,$dc,$1e
	dc.b	$00,'@',$02,$01,$03,$c1,$03,$c1
	dc.b	'@',$00,$80,$00,$c0,$00,$c0,$00
	dcb.w	32
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dcb.w	4
	dc.b	$01,$c0,$01,$c0,$00,$00,$01,$c0
	dcb.w	4
	dc.b	$11,$c0,$00,$00,$1d,$c0,$1d,$c0
	dcb.w	4
	dc.b	$19,$c0,$00,$00,$1d,$c0,$1d,$c0
	dcb.w	4
	dc.b	$11,$c0,$0c,$01,$1d,$c1,$1d,$c1
	dc.b	'X',$00,$84,$01,$dc,$1f,$dc,$1f
	dc.b	$00,$00,$04,$01,$07,$c1,$07,$c1
	dc.b	$c0,$00,$00,$00,$c0,$00,$c0,$00
	dcb.w	36
	dc.b	$00,' ',$00,' ',$00,' ',$00,' '
	dc.b	$00,$c0,$00,$c0,$01,$00,$01,$c0
	dcb.w	4
	dc.b	$01,$00,$00,$00,$1d,$c0,$1d,$c0
	dcb.w	4
	dc.b	$0d,$00,$10,$00,$1d,$c0,$1d,$c0
	dcb.w	4
	dc.b	$00,'@',$1c,$01,$1d,$c1,$1d,$c1
	dc.b	$dc,$02,$00,$02,$dc,$0d,$dc,$0f
	dc.b	$8a,$01,$02,$00,$8d,$81,$8f,$81
	dc.b	$c0,$00,$00,$00,$c0,$00,$c0,$00
	dcb.w	8
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dcb.w	21
	dc.b	$00,$b4,$00,$00,$00,$00,$00,$00
	dcb.w	3
	dc.b	$01,$00,$00,$00,$01,$c0,$01,$c0
	dcb.w	4
	dc.b	$1c,'@',$00,'@',$1d,$80,$1d,$c0
	dcb.w	4
	dc.b	$04,$00,$18,$00,$1d,$c0,$1d,$c0
	dcb.w	4
	dc.b	$00,$01,$1c,$00,$1d,$c1,$1d,$c1
	dc.b	$9e,$07,$00,$07,$de,$08,$de,$0f
	dc.b	$27,$03,$df,$00,$00,$83,$ff,$83
	dc.b	$c0,$00,$00,$00,$c0,$00,$c0,$00
	dcb.w	5
	dc.b	$0b,'@',$00,$00,$00,$00,$80,$00
	dc.b	$80,$00,$80,$00,$80,$00,$00,$00
	dcb.w	19
	dc.b	$00,$b4,$00,$b4,$00,$00,$00,$00
	dcb.w	4
	dc.b	$01,$80,$00,$00,$01,$c1,$01,$c1
	dc.b	$80,'x',$7f,$87,$ff,$ff,$ff,$ff
	dc.b	$1d,$86,$e1,$b8,$fc,$7f,$fd,$ff
	dc.b	'`\',$00,' ',$f0,$7f,$f0,$7f
	dc.b	'q',$c0,'l?',$9d,$ff,$fd,$ff
	dc.b	$00,$04,$ff,$f8,$ff,$fc,$ff,$fc
	dc.b	$00,$81,$1c,$80,$1d,'A',$1d,$c1
	dc.b	$00,$07,$10,$07,$de,$00,$de,$07
	dc.b	'w',$00,$8f,$00,$00,$03,$ff,$03
	dc.b	' ',$00,'`',$00,$e0,$00,$e0,$00
	dcb.w	4
	dc.b	$0b,'@',$0b,'@',$00,$00,$00,$00
	dcb.w	26
	dc.b	$00,$b4,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$01,$01,$00,$01,$01,$c0,$01,$c1
	dc.b	$99,$c1,$e7,$c1,$00,'>',$ff,$ff
	dc.b	$dd,$18,$f1,'`',$0c,$ff,$fd,$ff
	dc.b	$c0,'/',$10,$10,$e0,$7f,$f0,$7f
	dc.b	'9',$cf,'5',$0f,$cc,$f0,$fd,$ff
	dc.b	$1a,$d4,$e6,$ec,$01,$00,$ff,$fc
	dc.b	$01,$c1,$1d,$c0,$1c,$01,$1d,$c1
	dc.b	$08,$00,$00,$01,$cf,$00,$cf,$01
	dc.b	' ',$00,$dc,$00,$00,$07,$fc,$07
	dc.b	$80,$00,$00,$00,$80,$00,$80,$00
	dcb.w	6
	dc.b	$0b,'@',$00,$00,$00,$00,$00,$00
	dcb.w	22
	dc.b	$04,$b4,$04,$00,$04,$b4,$04,$00
	dcb.w	4
	dc.b	$00,'@',$00,'@',$01,$80,$01,$c0
	dcb.w	4
	dc.b	'0#H',$c0,$01,$ff,'y',$ff
	dc.b	$90,$11,' ',$0e,$c0,$7f,$f0,$7f
	dc.b	$9d,$80,$19,$80,$e4,'@',$fd,$c0
	dcb.w	4
	dc.b	$01,$c1,$1d,$c0,$1c,$01,$1d,$c1
	dc.b	$05,$80,$08,$00,$cf,$80,$cf,$80
	dc.b	$00,$0d,$00,$00,$00,$0f,$00,$0f
	dc.b	$00,$00,$80,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	$0b,'@',$00,$00,$0b,'@',$00,$00
	dcb.w	25
	dc.b	$01,$b6,$01,$b6,$00,$00,$00,$00
	dcb.w	3
	dc.b	$01,$c0,$01,$c0,$00,$00,$01,$c0
	dcb.w	4
	dc.b	',',$00,$1c,$00,$00,$00,'<',$00
	dc.b	'0@@',$00,$00,'ppp'
	dc.b	$00,$c0,$01,$c0,$00,$00,$01,$c0
	dcb.w	4
	dc.b	$01,'A',$1d,$c0,$1c,$01,$1d,$c1
	dc.b	$03,$c0,$04,$00,$c7,$c0,$c7,$c0
	dc.b	$00,$1e,$00,$01,$00,$1f,$00,$1f
	dcb.w	9
	dc.b	$1b,'`',$1b,'`',$00,$00,$00,$00
	dcb.w	23
	dc.b	$01,$b6,$01,$b6,$01,$b6,$00,$00
	dcb.w	4
	dc.b	$11,$00,$11,$c0,$10,$00,$11,$c0
	dcb.w	4
	dc.b	$18,$00,$18,$00,$04,$00,$1c,$00
	dc.b	'`@',$10,$00,$00,'ppp'
	dc.b	$02,'@',$03,$c0,$02,$00,$03,$c0
	dcb.w	4
	dc.b	$10,$01,$0d,$c0,$1c,$01,$1d,$c1
	dc.b	$01,$a0,$03,$80,$c2,'`',$c3,$e0
	dc.b	$00,',',$00,$0e,$00,'2',$00,'>'
	dc.b	$00,$80,$00,$80,$00,$80,$00,$80
	dcb.w	4
	dc.b	$1b,'`',$1b,'`',$1b,'`',$00,$00
	dcb.w	24
	dc.b	$03,$b7,$00,$00,$00,$00,$03,$b7
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dc.b	$01,'@',$00,$c0,$01,' ',$01,$e0
	dcb.w	4
	dc.b	$04,$00,$00,$00,$1c,$00,$1c,$00
	dc.b	'@`0',$00,$00,'ppp'
	dc.b	$00,$80,$01,'@',$00,$00,$01,$c0
	dcb.w	4
	dc.b	'<',$81,$01,'@<',$01,'=',$c1
	dc.b	$81,$c0,$06,$00,$c4,$00,$c7,$c0
	dc.b	$00,$1c,$00,$03,$00,$01,$00,$1f
	dcb.w	8
	dc.b	';p',$00,$00,$00,$00,';p'
	dcb.w	25
	dc.b	$07,'3',$00,$00,$07,'3',$00,$00
	dc.b	$80,$00,$00,$00,$80,$00,$00,$b0
	dc.b	$00,$80,$00,'p',$00,$f0,$00,$00
	dcb.w	3
	dc.b	$1c,$00,$00,$00,$1c,$00,$1c,$00
	dc.b	$10,'``',$00,$00,'ppp'
	dc.b	$05,$80,$04,'@',$04,$00,$05,$c0
	dcb.w	4
	dc.b	'Y',$c1,$18,$00,'`',$01,'y',$c1
	dc.b	$83,$00,$0c,$80,$c8,$00,$cf,$80
	dc.b	$00,$06,$00,$09,$00,$00,$00,$0f
	dc.b	'@',$00,$c0,$00,$c0,$00,$c0,$00
	dcb.w	5
	dc.b	's8',$00,$00,'s8',$00,$00
	dcb.w	23
	dc.b	$0f,'3',$0f,'3',$00,$00,$0f,'3'
	dc.b	$c0,$00,$c0,$00,$00,$00,$c0,$00
	dc.b	$01,$b9,$01,'`',$00,$1f,$01,$ff
	dc.b	$80,'8',$7f,$c0,$ff,$fc,$ff,$fc
	dc.b	$01,$00,$1d,$00,$1d,$00,$1d,$00
	dc.b	'00@@',$00,'ppp'
	dc.b	$01,$80,$00,'A',$00,$01,$01,$c1
	dc.b	'8p',$c0,'p',$ff,$80,$ff,$f0
	dc.b	'=',$c0,'<',$01,$00,$01,'=',$c1
	dc.b	$c4,$01,$07,$00,$c8,$01,$cf,$01
	dc.b	$04,$01,$00,$07,$fc,$00,$fc,$07
	dc.b	$02,'@',$02,'@',$82,'@',$82,'@'
	dcb.w	4
	dc.b	$f3,'<',$f3,'<',$00,$00,$f3,'<'
	dcb.w	26
	dc.b	$0e,'1',$0e,'1',$00,$00,$00,$00
	dc.b	$c0,$00,$c0,$00,$01,$e3,$01,$9f
	dc.b	$00,$00,$01,$ff,'3`<',$e0
	dc.b	$c0,$1c,$ff,$fc,$00,'(',$1c,'('
	dc.b	$1c,'(',$1c,'(p0',$00,'@'
	dc.b	$00,'ppp',$00,$80,$01,'A'
	dc.b	$00,$01,$01,$c1,$0e,'0',$f0,'8'
	dc.b	$ff,$c0,$ff,$f8,$04,$80,$05,'A'
	dc.b	$18,$01,$1d,$c1,$ce,$03,$1e,$04
	dc.b	$d0,$07,$de,$07,$ae,$03,$01,$03
	dc.b	$ff,$00,$ff,$03,$80,$00,$c0,$00
	dc.b	'@',$00,$c0,$00,'@',$00,'@',$00
	dc.b	'@',$00,'@',$00,$00,$00,$00,$00
	dc.b	$e3,$1c,$e3,$1c,$00,$00,$00,$00
	dcb.w	22
	dc.b	$0e,'1',$00,$00,$0e,'1',$0e,'1'
	dc.b	$c0,$00,$00,$00,$c0,$00,$c0,$00
	dc.b	$01,$c0,$01,$c0,$00,$00,$01,$c0
	dcb.w	4
	dc.b	$10,$80,$0c,$80,$1c,$80,$1c,$80
	dc.b	' ',$10,'P`',$00,'ppp'
	dc.b	$00,$01,$01,$c0,$00,$01,$01,$c1
	dc.b	$03,' ',$fc,'<',$ff,$c0,$ff,$fc
	dc.b	$10,$00,$01,$c1,$1c,$01,$1d,$c1
	dc.b	'R',$05,$82,$02,$dc,$0f,$de,$0f
	dc.b	$fd,$02,$02,$02,$ff,$81,$ff,$83
	dc.b	'@',$00,$00,$00,$c0,$00,$c0,$00
	dcb.w	4
	dc.b	$e3,$1c,$00,$00,$e3,$1c,$e3,$1c
	dcb.w	24
	dc.b	$0c,'0',$00,$00,$0c,'0',$0c,'0'
	dc.b	$c0,$00,$00,$00,$c0,$00,$c0,$00
	dc.b	$00,'@',$01,$c0,$00,$00,$01,$c0
	dcb.w	4
	dc.b	$18,$00,$04,$00,$1c,$00,$1c,$00
	dc.b	$80,$10,$f0,'`',$80,'p',$f0,'p'
	dc.b	$01,'A',$01,$c0,$00,$01,$01,$c1
	dc.b	$80,$14,'@',$18,$c0,$00,$c0,$1c
	dc.b	$18,$00,$01,$c1,$1c,$01,$1d,$c1
	dc.b	'P',$06,$80,$01,$dc,$0f,$dc,$0f
	dc.b	$03,$00,$8c,$00,$8f,$81,$8f,$81
	dc.b	'@',$00,$00,$00,$c0,$00,$c0,$00
	dcb.w	4
	dc.b	$c3,$0c,$00,$00,$c3,$0c,$c3,$0c
	dcb.w	25
	dc.b	$08,'0',$08,'0',$08,'0',$00,$00
	dc.b	'@',$00,'@',$00,'@',$00,$01,$00
	dc.b	$00,$c0,$00,$00,$01,$c0,$00,$00
	dcb.w	3
	dc.b	$1c,$01,$00,$01,$1c,$01,$1c,$01
	dc.b	'P',$10,'p`',$00,'ppp'
	dc.b	$01,$80,$01,$c0,$00,$01,$01,$c1
	dc.b	$c0,$1c,$00,$00,$c0,$00,$c0,$1c
	dc.b	$0d,'@',$11,$c1,$1c,$01,$1d,$c1
	dc.b	'X',$1a,$80,$19,$dc,$07,$dc,$1f
	dc.b	$0a,$c0,$0c,$c0,$0f,$01,$0f,$c1
	dc.b	$c0,$00,$00,$00,$c0,$00,$c0,$00
	dcb.w	5
	dc.b	$83,$04,$83,$04,$83,$04,$00,$00
	dcb.w	31
	dc.b	$01,$c0,$00,$00,$00,$00,$01,$c0
	dcb.w	4
	dc.b	$0c,$00,$00,$00,'<',$00,'<',$00
	dc.b	'p',$01,'pq',$00,'qpq'
	dc.b	$01,'@',$01,$80,$00,$01,$01,$c1
	dc.b	'H',$18,$08,$04,$c8,$00,$c8,$1c
	dc.b	$05,$c0,$19,$c1,$1c,$01,$1d,$c1
	dc.b	$1c,$0c,$c0,$1e,$dc,$02,$dc,$1e
	dc.b	$01,$81,$03,$c0,$02,$01,$03,$c1
	dc.b	$c0,$04,$00,$04,$c0,$04,$c0,$04
	dc.b	' ',$00,' ',$00,' ',$00,' ',$00
	dcb.w	36
	dc.b	$01,$80,$00,'@',$00,$00,$01,$c0
	dcb.w	4
	dc.b	' ',$00,'$',$00,'\',$00,'|',$00
	dc.b	'p',$00,'pp',$00,'ppp'
	dc.b	$00,$80,$01,'@',$00,$01,$01,$c1
	dc.b	'@',$14,$00,$0c,$c0,$00,$c0,$1c
	dc.b	$01,$c0,$1d,$c1,$1c,$01,$1d,$c1
	dc.b	$10,$04,$cc,$1c,$dc,$00,$dc,$1c
	dc.b	$01,$00,$01,$c1,$00,$01,$01,$c1
	dc.b	'@',$00,$80,$00,$c0,$00,$c0,$00
	dcb.w	40
	dc.b	$01,'S',$00,$a0,$00,$7f,$01,$ff
	dc.b	's',$cc,$83,$c0,$fc,'?',$ff,$ff
	dc.b	'x',$00,'p',$00,$88,$00,$f8,$00
	dc.b	'o',$00,'p',$f0,$1f,$f0,$7f,$f0
	dc.b	$01,$0c,$00,$b3,$00,$7f,$01,$ff
	dc.b	$00,$0f,$00,$18,$c0,$07,$c0,$1f
	dc.b	$c1,$bc,$1d,$c3,$fc,$7f,$fd,$ff
	dc.b	$06,$f0,$da,$0c,$dd,$e0,$df,$fc
	dc.b	$00,'{',$01,$82,$00,'=',$01,$ff
	dc.b	$00,$00,$c0,$00,$c0,$00,$c0,$00
	dc.b	' @ @ @ @'
	dc.b	$00,$10,$00,$10,$00,$10,$00,$10
	dcb.w	28
	dc.b	$04,$00,$04,$00,$04,$00,$04,$00
	dc.b	$00,$a6,$01,'A',$00,$ff,$01,$ff
	dc.b	$19,'?',$e1,$00,$fe,$ff,$ff,$ff
	dc.b	' ',$01,'(',$01,$d8,$01,$f8,$01
	dc.b	'Y',$80,'`p?',$f0,$7f,$f0
	dc.b	$00,$1e,$01,'a',$00,$ff,$01,$ff
	dc.b	$00,$18,$80,$17,$c0,$0f,$c0,$1f
	dc.b	$e1,'f',$0d,$81,$fc,$ff,$fd,$ff
	dc.b	$0e,'|',$d6,$00,$d9,$f0,$df,$fc
	dc.b	$01,$f3,$00,$03,$00,'|',$01,$ff
	dc.b	$80,$00,'@',$00,$c0,$00,$c0,$00
	dcb.w	40
	dc.b	$01,'L',$00,$83,$01,$ff,$01,$ff
	dc.b	$08,'a',$f0,$1e,$ff,$ff,$ff,$ff
	dc.b	$a0,$00,$10,$00,$f0,$00,$f0,$00
	dc.b	'0',$c0,'@0',$7f,$f0,$7f,$f0
	dc.b	$00,'#',$00,$c0,$01,$ff,$01,$ff
	dc.b	$00,$10,$c0,$0f,$c0,$1f,$c0,$1f
	dc.b	'`',$c3,$85,$00,$fd,$ff,$fd,$ff
	dc.b	$1e,'<',$ce,$00,$d1,$f8,$df,$fc
	dc.b	$01,$e3,$00,$03,$00,$fc,$01,$ff
	dc.b	$c0,$00,$80,$00,'@',$00,$c0,$00
	dcb.w	132
	dc.b	$00,$04,$00,$04,$00,$04,$00,$04
	dcb.w	96
	dc.b	$01,$00,$01,$00,$01,$00,$01,$00
	dcb.w	40
	dc.b	$11,$00,$11,$00,$11,$00,$11,$00
	dcb.w	24
	dc.b	$02,$00,$02,$00,$02,$00,$02,$00
	dc.b	$00,'@',$00,'@',$00,'@',$00,'@'
	dcb.w	28
l00b2	dc.b	$00,$00,$00,$07,$02,$04,$03,$05
	dc.b	$04,$06,$05,$07,$06,$07,$07,$07
	dc.b	$01,$15,$07,'p',$07,'`',$06,'P'
	dc.b	$05,'@',$04,'0',$03,' ',$07,'w'
l00b3	dc.b	$12
l00b4	dc.b	$08
	bss
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
zuend	end
