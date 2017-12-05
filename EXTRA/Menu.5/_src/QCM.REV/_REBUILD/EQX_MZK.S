
;	moveq	#1,d0
;	jsr	m006a

;	move.l	#m006c,$4d2.w

;	jsr	m006b

;	clr.l	$4d2.w
;	rts

m006a	bra	m006d
m006b	bra	m006e
m006c	bra	m0074
	dc.b	"The little muzak editor by Equinox"
	move.l	a0,-(a7)
	andi.b	#$1f,d0
	lea	m00c3,a0
	move.b	d0,(a0)+
	move.b	d0,(a0)+
	move.b	#0,(a0)+
	movea.l	(a7)+,a0
	rts

m006d	movem.l	a0-a6/d0-d7,-(a7)
	bsr.s	m0070
	movem.l	(a7)+,a0-a6/d0-d7
	rts

m006e	movem.l	a0-a6/d0-d7,-(a7)
	bsr.s	m006f
	movem.l	(a7)+,a0-a6/d0-d7
	rts

m006f	lea	m00c7,a0
	bsr.s	m0072
	movea.l	m00c5,a1
	andi.l	#$ff,d0
	add.w	d0,d0
	add.w	d0,d0
	adda.w	d0,a1
	lea	m00bf,a6
	move.w	(a1)+,(a6)
	move.w	(a1)+,d0
	andi.l	#$ff,d0
	bsr	m00aa
	rts

m0070	lea	m00c7,a0
	bsr.s	m0072
	tst.w	d0
	beq.s	m0071
	movea.l	m00c4,a1
	andi.l	#$ff,d0
	subq.l	#1,d0
	mulu	#6,d0
	adda.w	d0,a1
	move.w	(a1)+,d0
	move.w	(a1)+,d1
	lea	m00b0,a6
	move.w	(a1),(a6)+
	move.w	(a1)+,(a6)+
	bsr	m00a7
	rts

m0071	lea	m00b1,a0
	move.w	#1,(a0)
	bsr	m0074
	rts

m0072	move.w	m00c6,d7
	bne	m0073
	moveq	#0,d7
	move.w	#$40,m00b9
	move.l	#m00c7,m00bb
	move.l	#m00c8,m00bc
	move.l	#m00c9,m00ba
	move.l	#m00ca,m00bd
	move.l	#m00cb,m00c4
	move.l	#m00cc,m00c5
	move.w	#1,m00c6
	move.w	#0,m00c0
m0073	rts

m0074	lea	m00c3,a0
	tst.b	(a0)
	beq.s	m0076
	subq.b	#1,1(a0)
	bpl.s	m0076
	move.b	(a0),1(a0)
	addq.w	#1,2(a0)
	move.w	2(a0),d0
	cmpi.w	#$a,d0
	bne.s	m0075
	clr.l	(a0)
	lea	m00b1,a0
	move.w	#1,(a0)
	bra.s	m0076
m0075	lea	m00c2,a0
	move.b	0(a0,d0.w),d0
	lea	m00b3,a0
	lea	m00b5,a1
	lea	m00b7,a2
	move.b	d0,(a0)
	move.b	d0,(a1)
	move.b	d0,(a2)
m0076	lea	m00ae,a6
	lea	m00b0,a5
	tst.w	4(a5)
	beq.s	m0077
	clr.b	34(a6)
	clr.b	38(a6)
	clr.b	42(a6)
	movem.l	28(a6),d0-d3
	movem.l	d0-d3,$ffff8800.w
	rts

m0077	subq.w	#1,(a5)+
	bne.s	m0078
	move.w	(a5),-(a5)
	lea	m00b2,a0
	bsr	m007b
	lea	m00b4,a0
	bsr	m007b
	lea	m00b6,a0
	bsr	m007b
m0078	lea	m00be,a5
	lea	m00b2,a0
	bsr	m0083
	move.w	d0,-(a7)
	move.b	(a7)+,6(a6)
	move.b	d0,2(a6)
	move.b	d1,34(a6)
	lea	m00b4,a0
	bsr	m0083
	move.w	d0,-(a7)
	move.b	(a7)+,14(a6)
	move.b	d0,10(a6)
	move.b	d1,38(a6)
	lea	m00b6,a0
	bsr	m0083
	move.w	d0,-(a7)
	move.b	(a7)+,22(a6)
	move.b	d0,18(a6)
	move.b	d1,42(a6)
	move.w	4(a5),d0
	beq.s	m007a
	move.w	d0,-(a7)
	lea	m00b8,a0
	bsr	m0083
	movea.l	10(a0),a1
	adda.l	14(a0),a1
	cmpi.b	#$e1,1(a1)
	bne.s	m0079
	clr.w	4(a5)
m0079	move.w	(a7)+,d7
	lea	m00af,a1
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
m007a	move.b	(a5)+,d7
	ori.b	#$c0,d7
	move.b	d7,30(a6)
	move.b	(a5)+,26(a6)
	movem.l	(a6),a0-a2/d0-d7
	movem.l	a0-a2/d0-d7,$ffff8800.w
	rts

m007b	moveq	#0,d5
	moveq	#6,d6
	move.w	m00b9,d7
	movea.l	34(a0),a1
	adda.l	38(a0),a1
	move.b	(a1),d0
	andi.w	#$7f,d0
	cmpi.w	#1,d0
	beq.s	m007c
	cmp.w	40(a0),d7
	bne	m0080
m007c	movea.l	52(a0),a3
	movea.l	(a0),a2
	adda.l	4(a0),a2
	cmpa.l	a3,a2
	bne.s	m007d
	move.l	d5,4(a0)
	movea.l	(a0),a2
m007d	moveq	#0,d1
	move.b	(a2),d1
	move.b	1(a2),44(a0)
	move.b	2(a2),22(a0)
	move.b	3(a2),d0
	move.b	d0,d2
	andi.w	#$f0,d2
	cmpi.b	#$f0,d2
	bne	m007e
	move.b	d0,d2
	andi.b	#$f,d2
	move.b	d2,60(a0)
	bra.s	m007f
m007e	cmpi.b	#$e0,d2
	bne.s	m007f
	move.b	d0,d2
	andi.w	#$f,d2
	move.w	d2,2(a5)
m007f	move.l	d5,38(a0)
	mulu	d7,d1
	movea.l	m00ba,a3
	adda.l	d1,a3
	move.l	a3,34(a0)
	addi.l	#$c,4(a0)
	movea.l	34(a0),a1
	adda.l	38(a0),a1
m0080	move.b	(a1)+,d0
	move.b	d0,d1
	andi.w	#$7f,d1
	tst.w	d1
	beq	m0082
	move.l	d5,56(a0)
	move.b	d1,8(a0)
	movea.l	a1,a3
	tst.l	38(a0)
	bne.s	m0081
	adda.w	d7,a3
m0081	move.b	-2(a3),31(a0)
	move.b	(a1),9(a0)
	tst.b	d0
	bmi.s	m0082
	move.b	(a1),d1
	andi.w	#$1f,d1
	add.b	22(a0),d1
	movea.l	m00bc,a2
	asl.w	d6,d1
	adda.w	d1,a2
	move.l	d5,14(a0)
	move.b	(a2),23(a0)
	move.b	(a2)+,24(a0)
	move.b	(a2)+,d1
	andi.w	#$ff,d1
	move.b	(a2)+,27(a0)
	move.b	#$40,46(a0)
	move.b	(a2)+,d0
	move.b	d0,28(a0)
	move.b	d0,29(a0)
	move.b	(a2)+,30(a0)
	move.l	a2,10(a0)
	movea.l	m00bb,a2
	asl.w	d6,d1
	adda.w	d1,a2
	move.l	a2,18(a0)
	move.l	d5,48(a0)
	move.b	d5,26(a0)
	move.b	d5,25(a0)
m0082	addq.l	#2,38(a0)
	rts

m0083	moveq	#0,d7
	move.b	d7,32(a0)
m0084	tst.b	26(a0)
	beq.s	m0085
	subq.b	#1,26(a0)
	bra	m0090
m0085	movea.l	18(a0),a1
	adda.l	48(a0),a1
m0086	cmpi.b	#$e1,(a1)
	beq	m0090
	cmpi.b	#$e0,(a1)
	bne.s	m0087
	move.b	1(a1),d0
	andi.l	#$3f,d0
	move.l	d0,48(a0)
	movea.l	18(a0),a1
	adda.l	d0,a1
m0087	cmpi.b	#$e2,(a1)
	bne.s	m0088
	clr.l	14(a0)
	move.b	#1,23(a0)
	addq.l	#1,48(a0)
	bra.s	m0085
m0088	cmpi.b	#$e9,(a1)
	bne	m0089
	move.b	#$b,$ffff8800.w
	move.b	1(a1),$ffff8802.w
	move.b	#$c,$ffff8800.w
	move.b	#0,$ffff8802.w
	move.b	#$d,$ffff8800.w
	move.b	#$a,$ffff8802.w
	addq.l	#2,48(a0)
	bra	m0085
m0089	cmpi.b	#$e7,(a1)
	bne.s	m008a
	move.b	1(a1),d0
	andi.w	#$ff,d0
	asl.w	#6,d0
	movea.l	m00bb,a1
	adda.w	d0,a1
	move.l	a1,18(a0)
	move.l	d7,48(a0)
	bra	m0086
m008a	cmpi.b	#$e8,(a1)
	bne.s	m008b
	move.b	1(a1),26(a0)
	addq.l	#2,48(a0)
	bra	m0084
m008b	cmpi.b	#$e4,(a1)
	bne.s	m008c
	move.b	d7,42(a0)
	move.b	1(a1),32(a0)
	addq.l	#2,48(a0)
	bra.s	m008f
m008c	cmpi.b	#$e5,(a1)
	bne.s	m008d
	move.b	#1,42(a0)
	addq.l	#1,48(a0)
	bra	m0084
m008d	cmpi.b	#$e6,(a1)
	bne.s	m008e
	move.b	#2,42(a0)
	addq.l	#1,48(a0)
	bra.s	m008f
m008e	cmpi.b	#$e3,(a1)
	bne.s	m008f
	addq.l	#3,48(a0)
	move.b	1(a1),27(a0)
	move.b	2(a1),28(a0)
m008f	movea.l	18(a0),a1
	adda.l	48(a0),a1
	move.b	(a1),43(a0)
	addq.l	#1,48(a0)
m0090	tst.b	25(a0)
	beq.s	m0091
	subq.b	#1,25(a0)
	bra.s	m0095
m0091	subq.b	#1,23(a0)
	bne.s	m0095
	move.b	24(a0),23(a0)
m0092	movea.l	10(a0),a1
	adda.l	14(a0),a1
	move.b	(a1),d0
	cmpi.b	#$e8,d0
	bne.s	m0093
	addq.l	#2,14(a0)
	move.b	1(a1),25(a0)
	bra.s	m0090
m0093	cmpi.b	#$e1,d0
	beq.s	m0095
	cmpi.b	#$e0,d0
	bne.s	m0094
	move.b	1(a1),d0
	andi.l	#$3f,d0
	subq.l	#5,d0
	move.l	d0,14(a0)
	bra.s	m0092
m0094	move.b	(a1),45(a0)
	addq.l	#1,14(a0)
m0095	move.b	43(a0),d0
	bmi.s	m0096
	add.b	8(a0),d0
	add.b	44(a0),d0
m0096	andi.w	#$7f,d0
	lea	m00c1,a1
	add.w	d0,d0
	move.w	d0,d1
	adda.w	d0,a1
	move.w	(a1),d0
	move.b	33(a0),d3
	move.b	42(a0),d2
	andi.l	#$f,d2
	bne.s	m0097
	bclr	d3,(a5)
	addq.w	#3,d3
	bclr	d3,(a5)
	bra.s	m009a
m0097	cmpi.b	#1,d2
	bne.s	m0099
	bset	d3,(a5)
	addq.w	#3,d3
	bclr	d3,(a5)
	move.b	8(a0),32(a0)
	move.b	43(a0),d4
	bpl.s	m0098
	andi.b	#$7f,d4
	move.b	d4,32(a0)
	bra.s	m009a
m0098	add.b	d4,32(a0)
	bra.s	m009a
m0099	bclr	d3,(a5)
	addq.w	#3,d3
	bset	d3,(a5)
m009a	tst.b	32(a0)
	beq.s	m009b
	move.b	32(a0),d3
	andi.b	#$1f,d3
	eori.b	#$1f,d3
	move.b	d3,1(a5)
m009b	move.b	46(a0),d7
	tst.b	30(a0)
	beq.s	m009c
	subq.b	#1,30(a0)
	bra.s	m00a4
m009c	move.b	d1,d5
	move.b	28(a0),d4
	add.b	d4,d4
	move.b	29(a0),d1
	tst.b	d7
	bpl.s	m009d
	btst	#0,d7
	bne.s	m00a0
m009d	btst	#5,d7
	bne.s	m009e
	sub.b	27(a0),d1
	bcc.s	m009f
	bset	#5,d7
	moveq	#0,d1
	bra.s	m009f
m009e	add.b	27(a0),d1
	cmp.b	d4,d1
	bcs.s	m009f
	bclr	#5,d7
	move.b	d4,d1
m009f	move.b	d1,29(a0)
m00a0	lsr.b	#1,d4
	sub.b	d4,d1
	bcc.s	m00a1
	subi.w	#$100,d1
m00a1	addi.b	#$a0,d5
	bcs.s	m00a3
m00a2	add.w	d1,d1
	addi.b	#$18,d5
	bcc.s	m00a2
m00a3	add.w	d1,d0
m00a4	eori.b	#1,d7
	move.b	d7,46(a0)
	btst	#5,9(a0)
	beq	m00a5
	moveq	#0,d7
	move.w	d7,d1
	move.b	31(a0),d1
	ext.w	d1
	move.l	56(a0),d2
	moveq	#$c,d3
	asl.l	d3,d1
	add.l	d1,d2
	move.l	d2,56(a0)
	swap	d2
	sub.w	d2,d0
m00a5	move.b	45(a0),d1
	sub.b	60(a0),d1
	bpl.s	m00a6
	moveq	#0,d1
m00a6	rts

m00a7	lea	m00c3,a0
	clr.l	(a0)
	move.l	d0,d7
	mulu	#$c,d7
	move.l	d1,d6
	addq.l	#1,d6
	mulu	#$c,d6
	moveq	#2,d0
	lea	m00b2,a0
	lea	m00ac,a1
	lea	m00ad,a2
m00a8	move.l	a1,10(a0)
	clr.l	14(a0)
	move.b	#0,45(a0)
	clr.b	8(a0)
	clr.b	9(a0)
	move.l	a1,18(a0)
	clr.l	48(a0)
	move.b	#1,23(a0)
	move.b	#1,24(a0)
	clr.b	25(a0)
	clr.b	26(a0)
	clr.b	27(a0)
	clr.b	28(a0)
	clr.b	29(a0)
	clr.w	30(a0)
	clr.b	32(a0)
	move.b	(a2),d3
	andi.l	#$f,d3
	add.w	d3,d3
	add.w	d3,d3
	move.b	(a2)+,33(a0)
	move.l	m00bd,(a0)
	move.l	m00bd,52(a0)
	add.l	d6,52(a0)
	add.l	d3,52(a0)
	add.l	d7,(a0)
	add.l	d3,(a0)
	move.l	#$c,4(a0)
	movea.l	(a0),a3
	move.b	(a3),d1
	andi.l	#$ff,d1
	move.w	m00b9,d2
	mulu	d1,d2
	movea.l	m00ba,a4
	adda.l	d2,a4
	move.l	a4,34(a0)
	clr.l	38(a0)
	move.b	#2,42(a0)
	move.b	1(a3),44(a0)
	clr.b	43(a0)
	move.b	2(a3),22(a0)
	clr.b	60(a0)
	move.b	3(a3),d1
	andi.w	#$f0,d1
	cmpi.w	#$f0,d1
	bne	m00a9
	move.b	3(a3),d1
	andi.b	#$f,d1
	move.b	d1,60(a0)
m00a9	clr.b	45(a0)
	clr.w	56(a0)
	adda.l	#$3e,a0
	dbf	d0,m00a8
	lea	m00b0,a0
	move.w	2(a0),(a0)
	clr.w	4(a0)
	rts

m00aa	move.w	m00bf,d2
	move.w	m00c0,d1
	tst.w	d2
	beq	m00ab
	lea	m00b8,a0
	lea	m00be,a5
	move.b	d2,8(a0)
	move.b	d1,33(a0)
	clr.b	22(a0)
	moveq	#6,d6
	moveq	#0,d5
	andi.w	#$1f,d0
	movea.l	m00bc,a2
	asl.w	d6,d0
	adda.w	d0,a2
	move.l	d5,14(a0)
	move.b	(a2),23(a0)
	move.b	(a2)+,24(a0)
	move.b	(a2)+,d0
	andi.w	#$ff,d0
	move.b	(a2)+,27(a0)
	moveq	#0,d2
	move.b	#$40,46(a0)
	move.b	(a2)+,d2
	move.b	d2,28(a0)
	move.b	d2,29(a0)
	move.b	(a2)+,30(a0)
	move.l	a2,10(a0)
	movea.l	m00bb,a2
	asl.w	d6,d0
	adda.w	d0,a2
	move.l	a2,18(a0)
	move.l	d5,48(a0)
	clr.b	25(a0)
	clr.b	26(a0)
	addq.w	#1,d1
	move.w	d1,4(a5)
m00ab	rts

	dcb.w	2
m00ac	dc.b	$01,$00,$00,$00,$00,$00,$00,$e1
m00ad	dc.b	$00,$01,$02,$00
m00ae	dcb.w	2
	dc.b	$01,$01,$00,$00,$02,$02,$00,$00
	dc.b	$03,$03,$00,$00,$04,$04,$00,$00
	dc.b	$05,$05,$00,$00,$06,$06,$00,$00
	dc.b	$07,$07,$ff,$ff,$08,$08,$00,$00
	dc.b	$09,$09,$00,$00,$0a,$0a,$00,$00
m00af	dcb.w	2
	dc.b	$02,$06,$22,$00,$0a,$0e,$26,$00
	dc.b	$12,$16,$2a,$00
m00b0	dc.b	$00,$04,$00,$04
m00b1	dc.b	$00,$00
m00b2	dcb.w	30
m00b3	dc.b	$00,$00
m00b4	dcb.w	30
m00b5	dc.b	$00,$00
m00b6	dcb.w	28
m00b7	dcb.w	3
m00b8	dcb.w	31
m00b9	dc.b	$00,$40,$00,$00
m00ba	dcb.w	2
m00bb	dcb.w	2
m00bc	dcb.w	2
m00bd	dcb.w	2
m00be	dcb.w	3
m00bf	dc.b	$00,$00
m00c0	dc.b	$00,$00
m00c1	dc.b	$0e,$ee,$0e,$17,$0d,$4d,$0c,$8e
	dc.b	$0b,$d9,$0b,$2f,$0a,$8e,$09,$f7
	dc.b	$09,$67,$08,$e0,$08,$61,$07,$e8
	dc.b	$07,$77,$07,$0b,$06,$a6,$06,$47
	dc.b	$05,$ec,$05,$97,$05,$47,$04,$fb
	dc.b	$04,$b3,$04,$70,$04,$30,$03,$f4
	dc.b	$03,$bb,$03,$85,$03,$53,$03,$23
	dc.b	$02,$f6,$02,$cb,$02,$a3,$02,$7d
	dc.b	$02,$59,$02,$38,$02,$18,$01,$fa
	dc.b	$01,$dd,$01,$c2,$01,$a9,$01,$91
	dc.b	$01,$7b,$01,$65,$01,$51,$01,$3e
	dc.b	$01,$2c,$01,$1c,$01,$0c,$00,$fd
	dc.b	$00,$ee,$00,$e1,$00,$d4,$00,$c8
	dc.b	$00,$bd,$00,$b2,$00,$a8,$00,$9f
	dc.b	$00,$96,$00,$8e,$00,$86,$00,$7e
	dc.b	$00,$77,$00,$70,$00,$6a,$00,$64
	dc.b	$00,$5e,$00,$59,$00,$54,$00,$4f
	dc.b	$00,$4b,$00,$47,$00,$43,$00,$3f
	dc.b	$00,$3b,$00,$38,$00,$35,$00,$32
	dc.b	$00,$2f,$00,$2c,$00,$2a,$00,$27
	dc.b	$00,$25,$00,$23,$00,$21,$00,$1f
	dc.b	$00,$1d,$00,$1c,$00,$1a,$00,$19
	dc.b	$00,$17,$00,$16,$00,$15,$00,$13
	dc.b	$00,$12,$00,$11,$00,$10,$00,$0f
m00c2	dc.b	$00,$01,$02,$03,$04,$05,$06,$07
	dc.b	$08,$09,$0a,$0b,$0f,$0f,$0f,$0f
	dc.b	$0f,$0f
m00c3	dcb.w	2
m00c4	dcb.w	2
m00c5	dcb.w	5
m00c6	dcb.w	2
m00c7	dc.b	$e2,$e6,$0c,$09,$00,$00,$00,$00
	dc.b	$00,$00,$e0,$02,$00,$00,$00,$00
	dcb.w	24
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
m00c8	dc.b	$03,$00,$01,$02,$03,$0f,$0e,$0d
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
	dcb.w	14
m00c9	dcb.w	32
	dc.b	$0f,$01,$00,$00,$0f,$01,$00,$00
	dcb.w	2
	dc.b	$0f,$01,$00,$00,$33,$01,$00,$00
	dcb.w	2
	dc.b	$0f,$01,$00,$00,$0f,$01,$00,$00
	dcb.w	2
	dc.b	$0f,$01,$00,$00,$0f,$01,$00,$00
	dcb.w	2
	dc.b	$33,$01,$00,$00,$00,$00,$00,$01
	dc.b	$31,$01,$00,$00,$33,$01,$00,$00
	dc.b	$0d,$01,$00,$00,$0d,$01,$00,$00
	dcb.w	2
	dc.b	$0d,$01,$00,$00,$31,$01,$00,$00
	dcb.w	2
	dc.b	$0d,$01,$00,$00,$0d,$01,$00,$00
	dcb.w	2
	dc.b	$0d,$01,$00,$00,$0d,$01,$00,$00
	dcb.w	2
	dc.b	$31,$01,$00,$00,$00,$00,$00,$00
	dc.b	$2f,$01,$00,$00,$31,$01,$00,$00
	dc.b	$0b,$01,$00,$00,$0b,$01,$00,$00
	dcb.w	2
	dc.b	$0b,$01,$00,$00,$2f,$01,$00,$00
	dcb.w	2
	dc.b	$0b,$01,$00,$00,$0b,$01,$00,$00
	dcb.w	2
	dc.b	$0b,$01,$00,$00,$0b,$01,$00,$00
	dcb.w	2
	dc.b	$2f,$01,$00,$00,$00,$00,$00,$00
	dc.b	$2d,$01,$00,$00,$2f,$01,$00,$00
	dc.b	$08,$01,$00,$00,$08,$01,$00,$00
	dcb.w	2
	dc.b	$08,$01,$00,$00,$2c,$01,$00,$00
	dcb.w	2
	dc.b	$08,$01,$00,$00,$08,$01,$00,$00
	dcb.w	2
	dc.b	$08,$01,$00,$00,$08,$01,$00,$00
	dcb.w	2
	dc.b	$2c,$01,$00,$00,$00,$00,$00,$00
	dc.b	$2a,$01,$00,$00,$2c,$01,$00,$00
	dc.b	$2a,$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$29,$05,$00,$00,$00,$00,$00,$00
	dcb.w	8
	dc.b	$27,$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$25,$05,$00,$00,$00,$00,$00,$00
	dcb.w	32
	dc.b	$2a,$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$29,$05,$00,$00,$00,$00,$00,$00
	dcb.w	8
	dc.b	$2e,$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$2c,$05,$00,$00,$00,$00,$00,$00
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
	dc.b	$15,$03,$00,$00,$33,$01,$00,$00
	dcb.w	10
	dc.b	$31,$01,$00,$00,$00,$00,$00,$00
	dcb.w	8
	dc.b	$2e,$01,$00,$00,$00,$00,$00,$00
	dcb.w	8
	dc.b	$2c,$01,$00,$00,$2e,$01,$00,$00
	dc.b	$31,$01,$00,$00,$2c,$01,$00,$00
	dc.b	$2e,$01,$00,$00,$31,$01,$00,$00
	dcb.w	4
	dc.b	$2c,$01,$00,$00,$2d,$01,$00,$00
	dc.b	$2c,$01,$00,$00,$2a,$01,$00,$00
	dc.b	$27,$01,$00,$00,$25,$01,$00,$00
	dc.b	$2a,$01,$00,$00,$27,$01,$00,$00
	dcb.w	28
	dc.b	$15,$02,$00,$00,$00,$00,$00,$00
	dc.b	$15,$02,$00,$00,$00,$00,$00,$00
	dc.b	$15,$03,$00,$00,$15,$03,$00,$00
	dc.b	$15,$03,$00,$00,$15,$03,$00,$00
	dc.b	$15,$03,$00,$00,$15,$03,$00,$00
	dc.b	$15,$03,$00,$00,$15,$03,$00,$00
	dc.b	$15,$03,$00,$00,$15,$03,$00,$00
	dc.b	$15,$03,$00,$00,$15,$03,$00,$00
	dc.b	$2e,$05,$00,$00,$00,$00,$00,$00
	dcb.w	28
	dc.b	$33,$05,$00,$00,$00,$00,$00,$00
	dcb.w	8
	dc.b	$35,$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$36,$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$35,$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$33,$05,$00,$00,$00,$00,$00,$00
	dcb.w	12
	dc.b	$31,$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$2e,$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$2c,$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$2e,$05,$00,$00,$00,$00,$00,$00
	dc.b	$2c,$05,$00,$00,$00,$00,$00,$00
	dc.b	$33,$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$2e,$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$2c,$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$2e,$05,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$2c,$05,$00,$00,$00,$00,$00,$00
	dcb.w	8
m00ca	dc.b	$01,$00,$00,$00,$00,$00,$00,$00
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
	dc.b	$11,$00,$00,$00
m00cb	dc.b	$00,$00,$00,$3d,$00,$04,$00,$00
	dcb.w	2
m00cc	dcb.w	4

;zuend	end