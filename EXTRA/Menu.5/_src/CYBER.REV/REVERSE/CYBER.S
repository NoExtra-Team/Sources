;	opt	x+
;========================================
	text
;========================================
begin	dc.w	$a00a

	bsr	l001a

	move.w	#2,-(sp)		;physbase
	trap	#14
	addq.l	#6,sp
	move.l	d0,l008d

	movea.l	l008d,a0
	move.w	#$1f3f,d0
l0000	clr.l	(a0)+
	dbf	d0,l0000

	movea.l	l008d,a0
	lea	l0024,a1
	lea	34(a1),a1
	move.w	#$103f,d0
l0001	move.l	(a1)+,(a0)+
	dbf	d0,l0001

	movea.l	l008d,a0
	lea	22400(a0),a0
	lea	l008a,a1
	move.w	#$95f,d0
l0002	move.l	(a1)+,(a0)+
	dbf	d0,l0002

	clr.l	-(sp)

	pea	l0024+2
	move.w	#6,-(sp)		;setpallete
	trap	#14
	addq.l	#6,sp

	clr.l	-(sp)
	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp
	move.l	d0,-(sp)

	move.b	#$e,$484.l

	move.w	#1,d0
	jsr	l0027+44
	move.l	#l0027+44+8,$4d2.l

	bsr	l0012

	lea	l0023,a4
	lea	12(a4),a4
	lea	l0022,a5
	move.b	#0,l00b7
	move.b	#0,l00b8
	move.b	#2,l00b9
	bsr	l001e

l0003	move.w	(a4)+,l00ae
	cmpi.w	#$270f,(a4)
	beq	l0004

	bra	l0005

l0004	lea	l0023,a4

l0005	bsr	l0011
	bsr	l000c
	bsr	l0010
	addi.w	#8,l00ae

	bsr	l0011
	bsr	l000c
	bsr	l0010
	addi.w	#8,l00ae

	bsr	l0011
	bsr	l000c
	bsr	l0010
	addi.w	#8,l00ae

	bsr	l0011
	bsr	l000c
	bsr	l0010
	addi.w	#8,l00ae

	move.w	#$50c0,l00ae

	bsr	l0011
	bsr	l000c
	bsr	l0010

	move.w	#$ff,-(sp)
	move.w	#6,-(sp)		;crawio
	trap	#1
	addq.l	#4,sp

	move.l	d0,d1
	swap	d1

	cmp.b	#$3b,d1
	beq	l0009

	cmp.b	#$3c,d1
	beq	l000a

l0006	cmp.b	#$20,d0
	bne	l0003

	bsr	l0019
	bsr	l001f

	move.b	#3,$484.l

	move.l	#0,$4d2.l

	bsr	l000b
	bsr	l001b

	move.w	#$2700,sr

	lea	8.w,a1
	lea	l0008(pc),a0
	moveq	#9,d7
l0007	move.l	(a0)+,(a1)+
	dbf	d7,l0007

	jmp	$12.w

l0008	ori.b	#$c,d0
	movea.l	4.w,a0
	jmp	(a0)

	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp

	clr.l	-(sp)
	trap	#1
;========================================
l0009	cmpi.b	#$a,l00b9
	beq	l0006

	move.b	#0,l00b8
	addi.b	#1,l00b9

	bra	l0006

l000a	cmpi.b	#1,l00b9
	beq	l0006
	move.b	#0,l00b8
	subi.b	#1,l00b9

	bra	l0006

l000b	move.l	#$8080000,$ffff8800.l
	move.l	#$9090000,$ffff8800.l
	move.l	#$a0a0000,$ffff8800.l
	rts

l000c	move.w	#8,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$f,d5
	movea.l	l008d,a2
	lea	18904(a2),a2
	lea	l0089,a3
	adda.l	d2,a3
l000d	move.l	(a3),160(a2)
	move.l	(a3)+,(a2)+
	move.l	(a3),160(a2)
	move.l	(a3)+,(a2)+
	adda.l	#$98,a3
	dbf	d5,l000d

	move.w	#9,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$f,d5
	movea.l	l008d,a2
	lea	18904(a2),a2
	lea	640(a2),a2
	lea	l0089,a3
	adda.l	d2,a3
l000e	move.l	(a3),160(a2)
	move.l	(a3)+,(a2)+
	move.l	(a3),160(a2)
	move.l	(a3)+,(a2)+
	adda.l	#$98,a3
	dbf	d5,l000e

	move.w	#$a,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$f,d5
	movea.l	l008d,a2
	lea	18904(a2),a2
	lea	1280(a2),a2
	lea	l0089,a3
	adda.l	d2,a3
l000f	move.l	(a3),160(a2)
	move.l	(a3)+,(a2)+
	move.l	(a3),160(a2)
	move.l	(a3)+,(a2)+
	adda.l	#$98,a3
	dbf	d5,l000f
	rts

l0010	move.w	#$25,-(sp)		;vsync
	trap	#14
	addq.w	#2,sp
	rts

l0011	bsr	l001c

	dc.w	$a000
	move.w	#8,l0090
	move.w	#$20,l0091
	move.w	#4,l0092
	move.w	#$f,l0093
	move.w	#0,l0094
	move.l	#$3030303,l0095
	move.w	l00ae,l0096
	move.w	#0,l0097
	move.l	#l0024+34+16640,l0098
	move.w	#8,l0099
	move.w	#$a0,l009a
	move.w	#2,l009b
	move.w	#$138,l009c
	move.w	#$8c,l009d
	move.l	l008d,l009e
	move.w	#8,l009f
	move.w	#$a0,l00a0
	move.w	#2,l00a1
	move.l	#0,l00a2

	lea	l0090,a6
	dc.w	$a007
	rts

l0012	move.b	$fffffa07.l,l00a3
	move.b	$fffffa09.l,l00a4
	move.l	$70.l,l00a5
	move.l	$120.l,l00a6
	move.b	$fffffa0d.l,l00a7
	move.b	$fffffa0f.l,l00a8
	move.b	$fffffa11.l,l00a9
	move.b	$fffffa13.l,l00aa
	move.b	$fffffa15.l,l00ab
	move.b	$fffffa1b.l,l00ac
	move.b	$fffffa21.l,l00ad

	move.w	sr,d0

	move.w	#$2700,sr

	move.l	$70.l,l008e
	move.l	#l0013,$70.l
	move.l	#l0018,$120.l
	ori.b	#1,$fffffa13.l

	move.w	d0,sr
	rts

l0013	move.w	#0,$ffff8240.w
	move.w	l00af,$ffff8242.w
	move.l	l00b0,$ffff8244.w
	move.l	l00b1,$ffff8248.w
	move.w	l00b2,$ffff824c.w
	move.w	#$700,$ffff824e.w
	move.l	#$5000732,$ffff8250.w
	move.l	#$7730333,$ffff8254.w
	move.l	#$4440555,$ffff8258.w
	move.l	#$6660777,$ffff825c.w
	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#$40,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l0014,$120.l
	move.l	l008e,-(sp)
	rts

l0014	ori.w	#$700,sr

	move.w	#0,$ffff8240.w
	move.w	l00b6,$ffff8242.w
	move.l	l00b5,$ffff8244.w
	move.l	l00b4,$ffff8248.w
	move.w	l00b3,$ffff824c.w
	move.w	#$700,$ffff824e.w
	move.l	#$5000732,$ffff8250.w
	move.l	#$7730540,$ffff8254.w
	move.l	#$6500760,$ffff8258.w
	move.l	#$7700777,$ffff825c.w
	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#$2c,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l0015,$120.l
	rte

l0015	ori.w	#$700,sr

	move.l	#$333,$ffff8240.w
	addi.b	#1,l00b8
	move.b	l00b9,d6
	cmp.b	l00b8,d6
	bne	l0017

	move.b	#0,l00b8
	lea	2(a5),a5
	addi.b	#1,l00b7
	cmpi.b	#$2a,l00b7
	beq	l0016

	bra	l0017

l0016	lea	l0022,a5
	move.b	#0,l00b7
l0017	move.l	(a5),$ffff8244.w
	move.l	4(a5),$ffff8248.w
	move.l	8(a5),$ffff824c.w
	move.l	12(a5),$ffff8250.w
	move.l	16(a5),$ffff8254.w
	move.w	106(a5),l00af
	move.l	108(a5),l00b0
	move.l	112(a5),l00b1
	move.w	116(a5),l00b2
	move.w	204(a5),l00b3
	move.l	206(a5),l00b4
	move.l	210(a5),l00b5
	move.w	214(a5),l00b6
	move.l	#$1110222,$ffff8258.w
	move.l	#$3330777,$ffff825c.w
	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#$3e,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l0018,$120.l
	rte

l0018	ori.w	#$700,sr

	move.l	#$770,$ffff8240.w
	move.l	#$170027,$ffff824c.w
	move.l	#$370047,$ffff8250.w
	move.l	#$7770666,$ffff8254.w
	move.l	#$5550444,$ffff8258.w
	move.l	#$3330777,$ffff825c.w
	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	rte

l0019	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	move.b	l00a3,$fffffa07.l
	move.b	l00a4,$fffffa09.l
	move.l	l00a5,$70.l
	move.l	l00a6,$120.l
	move.b	l00a7,$fffffa0d.l
	move.b	l00a8,$fffffa0f.l
	move.b	l00a9,$fffffa11.l
	move.b	l00aa,$fffffa13.l
	move.b	l00ab,$fffffa15.l
	move.b	l00ac,$fffffa1b.l
	move.b	l00ad,$fffffa21.l
	rts

l001a	pea	l008b
	move.w	#0,-(sp)
	move.w	#$16,-(sp)		;settime
	trap	#14
	addq.l	#8,sp
	rts

l001b	pea	l008c
	move.w	#0,-(sp)
	move.w	#$16,-(sp)		;settime
	trap	#14
	addq.l	#8,sp
	rts

l001c	move.w	#$20,d1
	movea.l	l008d,a0
	lea	22400(a0),a0
l001d	move.b	1(a0),0(a0)
	move.b	8(a0),1(a0)
	move.b	9(a0),8(a0)
	move.b	16(a0),9(a0)
	move.b	17(a0),16(a0)
	move.b	24(a0),17(a0)
	move.b	25(a0),24(a0)
	move.b	32(a0),25(a0)
	move.b	33(a0),32(a0)
	move.b	40(a0),33(a0)
	move.b	41(a0),40(a0)
	move.b	48(a0),41(a0)
	move.b	49(a0),48(a0)
	move.b	56(a0),49(a0)
	move.b	57(a0),56(a0)
	move.b	64(a0),57(a0)
	move.b	65(a0),64(a0)
	move.b	72(a0),65(a0)
	move.b	73(a0),72(a0)
	move.b	80(a0),73(a0)
	move.b	81(a0),80(a0)
	move.b	88(a0),81(a0)
	move.b	89(a0),88(a0)
	move.b	96(a0),89(a0)
	move.b	97(a0),96(a0)
	move.b	104(a0),97(a0)
	move.b	105(a0),104(a0)
	move.b	112(a0),105(a0)
	move.b	113(a0),112(a0)
	move.b	120(a0),113(a0)
	move.b	121(a0),120(a0)
	move.b	128(a0),121(a0)
	move.b	129(a0),128(a0)
	move.b	136(a0),129(a0)
	move.b	137(a0),136(a0)
	move.b	144(a0),137(a0)
	move.b	145(a0),144(a0)
	move.b	152(a0),145(a0)
	move.b	153(a0),152(a0)
	move.b	3(a0),2(a0)
	move.b	10(a0),3(a0)
	move.b	11(a0),10(a0)
	move.b	18(a0),11(a0)
	move.b	19(a0),18(a0)
	move.b	26(a0),19(a0)
	move.b	27(a0),26(a0)
	move.b	34(a0),27(a0)
	move.b	35(a0),34(a0)
	move.b	42(a0),35(a0)
	move.b	43(a0),42(a0)
	move.b	50(a0),43(a0)
	move.b	51(a0),50(a0)
	move.b	58(a0),51(a0)
	move.b	59(a0),58(a0)
	move.b	66(a0),59(a0)
	move.b	67(a0),66(a0)
	move.b	74(a0),67(a0)
	move.b	75(a0),74(a0)
	move.b	82(a0),75(a0)
	move.b	83(a0),82(a0)
	move.b	90(a0),83(a0)
	move.b	91(a0),90(a0)
	move.b	98(a0),91(a0)
	move.b	99(a0),98(a0)
	move.b	106(a0),99(a0)
	move.b	107(a0),106(a0)
	move.b	114(a0),107(a0)
	move.b	115(a0),114(a0)
	move.b	122(a0),115(a0)
	move.b	123(a0),122(a0)
	move.b	130(a0),123(a0)
	move.b	131(a0),130(a0)
	move.b	138(a0),131(a0)
	move.b	139(a0),138(a0)
	move.b	146(a0),139(a0)
	move.b	147(a0),146(a0)
	move.b	154(a0),147(a0)
	move.b	155(a0),154(a0)
	move.b	5(a0),4(a0)
	move.b	12(a0),5(a0)
	move.b	13(a0),12(a0)
	move.b	20(a0),13(a0)
	move.b	21(a0),20(a0)
	move.b	28(a0),21(a0)
	move.b	29(a0),28(a0)
	move.b	36(a0),29(a0)
	move.b	37(a0),36(a0)
	move.b	44(a0),37(a0)
	move.b	45(a0),44(a0)
	move.b	52(a0),45(a0)
	move.b	53(a0),52(a0)
	move.b	60(a0),53(a0)
	move.b	61(a0),60(a0)
	move.b	68(a0),61(a0)
	move.b	69(a0),68(a0)
	move.b	76(a0),69(a0)
	move.b	77(a0),76(a0)
	move.b	84(a0),77(a0)
	move.b	85(a0),84(a0)
	move.b	92(a0),85(a0)
	move.b	93(a0),92(a0)
	move.b	100(a0),93(a0)
	move.b	101(a0),100(a0)
	move.b	108(a0),101(a0)
	move.b	109(a0),108(a0)
	move.b	116(a0),109(a0)
	move.b	117(a0),116(a0)
	move.b	124(a0),117(a0)
	move.b	125(a0),124(a0)
	move.b	132(a0),125(a0)
	move.b	133(a0),132(a0)
	move.b	140(a0),133(a0)
	move.b	141(a0),140(a0)
	move.b	148(a0),141(a0)
	move.b	149(a0),148(a0)
	move.b	156(a0),149(a0)
	move.b	157(a0),156(a0)
	move.b	7(a0),6(a0)
	move.b	14(a0),7(a0)
	move.b	15(a0),14(a0)
	move.b	22(a0),15(a0)
	move.b	23(a0),22(a0)
	move.b	30(a0),23(a0)
	move.b	31(a0),30(a0)
	move.b	38(a0),31(a0)
	move.b	39(a0),38(a0)
	move.b	46(a0),39(a0)
	move.b	47(a0),46(a0)
	move.b	54(a0),47(a0)
	move.b	55(a0),54(a0)
	move.b	62(a0),55(a0)
	move.b	63(a0),62(a0)
	move.b	70(a0),63(a0)
	move.b	71(a0),70(a0)
	move.b	78(a0),71(a0)
	move.b	79(a0),78(a0)
	move.b	86(a0),79(a0)
	move.b	87(a0),86(a0)
	move.b	94(a0),87(a0)
	move.b	95(a0),94(a0)
	move.b	102(a0),95(a0)
	move.b	103(a0),102(a0)
	move.b	110(a0),103(a0)
	move.b	111(a0),110(a0)
	move.b	118(a0),111(a0)
	move.b	119(a0),118(a0)
	move.b	126(a0),119(a0)
	move.b	127(a0),126(a0)
	move.b	134(a0),127(a0)
	move.b	135(a0),134(a0)
	move.b	142(a0),135(a0)
	move.b	143(a0),142(a0)
	move.b	150(a0),143(a0)
	move.b	151(a0),150(a0)
	move.b	158(a0),151(a0)
	move.b	159(a0),158(a0)
	lea	160(a0),a0
	dbf	d1,l001d
	rts

l001e	move.l	#l0021,d0
	move.w	#$46,d1
	bsr	l0020
	move.l	d0,l008f
	rts

l001f	move.l	l008f,d0
	move.w	#$46,d1
	bsr	l0020
	rts

l0020	move.l	d0,-(sp)
	move.w	d1,-(sp)
	move.w	#5,-(sp)		;setexc
	trap	#13
	addq.l	#8,sp
	rts

l0021	move.w	sr,-(sp)

	andi.w	#$f8ff,(sp)
	ori.w	#$500,(sp)

	move.w	(sp)+,sr

	move.l	l008f,-(sp)
	rts

l0022	dc.b	$07,$00,$07,$10,$07,$20,$07,$30
	dc.b	$07,$40,$07,$60,$07,$70,$06,$70
	dc.b	$05,$70,$04,$70,$03,$70,$02,$70
	dc.b	$01,$70,$00,$70,$00,$71,$00,$72
	dc.b	$00,$73,$00,$74,$00,$75,$00,$76
	dc.b	$00,$77,$00,$67,$00,$57,$00,$47
	dc.b	$00,$37,$00,$27,$00,$17,$00,$07
	dc.b	$01,$07,$02,$07,$03,$07,$04,$07
	dc.b	$05,$07,$06,$07,$07,$07,$07,$06
	dc.b	$07,$05,$07,$04,$07,$03,$07,$02
	dc.b	$07,$01,$07,$00,$07,$10,$07,$20
	dc.b	$07,$30,$07,$40,$07,$60,$07,$70
	dc.b	$06,$70,$05,$70,$04,$70,$03,$70
	dc.b	$02,$70,$00,$07,$00,$06,$00,$05
	dc.b	$00,$04,$00,$03,$00,$02,$00,$01
	dcb.w	7
	dc.b	$00,$70,$00,$60,$00,$50,$00,$40
	dc.b	$00,$30,$00,$20,$00,$10,$00,$00
	dcb.w	6
	dc.b	$07,$00,$06,$00,$05,$00,$04,$00
	dc.b	$03,$00,$02,$00,$01,$00,$00,$00
	dcb.w	6
	dc.b	$00,$07,$00,$06,$00,$05,$00,$04
	dc.b	$00,$03,$00,$02,$00,$01,$01,$00
	dc.b	$02,$00,$03,$00,$04,$00,$05,$00
	dc.b	$06,$00,$07,$00,$06,$00,$05,$00
	dc.b	$04,$00,$03,$00,$02,$00,$01,$00
	dc.b	$00,$00,$01,$01,$02,$02,$03,$03
	dc.b	$04,$04,$05,$05,$06,$06,$07,$07
	dc.b	$06,$06,$05,$05,$04,$04,$03,$03
	dc.b	$02,$02,$01,$01,$00,$00,$01,$10
	dc.b	$02,$20,$03,$30,$04,$40,$05,$50
	dc.b	$06,$60,$07,$70,$06,$60,$05,$50
	dc.b	$04,$40,$03,$30,$02,$20,$01,$10
	dc.b	$00,$00,$01,$00,$02,$00,$03,$00
	dc.b	$04,$00,$05,$00,$06,$00,$07,$00

l0023	incbin	l0023
l0024	incbin	l0024.pi1
l0027	incbin	l0027.mus
l0089	incbin	l0089
l008a	incbin	l008a

l008b	dc.b	$12
l008c	dc.b	$08
;========================================
	bss
;========================================
l008d	ds.l	1
l008e	ds.l	1
l008f	ds.l	1
l0090	ds.w	1
l0091	ds.w	1
l0092	ds.w	1
l0093	ds.w	1
l0094	ds.w	1
l0095	ds.l	1
l0096	ds.w	1
l0097	ds.w	1
l0098	ds.l	1
l0099	ds.w	1
l009a	ds.w	1
l009b	ds.w	1
l009c	ds.w	1
l009d	ds.w	1
l009e	ds.l	1
l009f	ds.w	1
l00a0	ds.w	1
l00a1	ds.w	1
l00a2	ds.b	134
l00a3	ds.w	1
l00a4	ds.w	1
l00a5	ds.l	1
l00a6	ds.l	1
l00a7	ds.w	1
l00a8	ds.w	1
l00a9	ds.w	1
l00aa	ds.w	1
l00ab	ds.w	1
l00ac	ds.w	1
l00ad	ds.b	56
l00ae	ds.w	1
l00af	ds.w	1
l00b0	ds.l	1
l00b1	ds.l	1
l00b2	ds.w	1
l00b3	ds.w	1
l00b4	ds.l	1
l00b5	ds.l	1
l00b6	ds.w	1
l00b7	ds.b	1
l00b8	ds.b	1
l00b9	ds.w	1
;========================================
zuend	end
;========================================