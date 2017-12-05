	text
begin
	clr.l	-(a7)
	move.w	#$20,-(a7)		;super
	trap	#1
	addq.l	#6,a7
	move.l	d0,-(a7)
	move.b	#$e,$484.l
	move.w	#1,d0
	jsr	l005f
	move.l	#l0060,$4d2.l
	dc.b	$a0,$0a
	pea	l0054
	move.w	#6,-(a7)		;setpallete
	trap	#$e
	addq.l	#2,a7
	move.w	#2,-(a7)		;physbase
	trap	#$e
	addq.l	#2,a7
	movea.l	d0,a1
	move.l	d0,l00f8
	move.w	#$4fce,l00f9
	move.w	#$1f3f,d1
l0000	clr.l	(a1)+
	dbf	d1,l0000
	move.w	#$50,l00fc
	move.w	#3,d5
l0001	addi.w	#$10,l00fc
	bsr	l004b
	move.w	#5,d1
	bsr	l0036
	dbf	d5,l0001
	move.w	#2,d5
l0002	subi.w	#$10,l00fc
	bsr	l004b
	move.w	#5,d1
	bsr	l0036
	dbf	d5,l0002
	move.w	#$13f0,l00fb
	move.w	#3,d5
l0003	addi.w	#$10,l00fb
	bsr	l004a
	move.w	#$a,d1
	bsr	l0036
	dbf	d5,l0003
	move.w	#4,d5
l0004	bsr	l0049
	subi.w	#$1d,l00f9
	move.w	#$ffc0,l00fa
	move.w	#2,d4
l0005	addi.w	#$40,l00fa
	bsr	l0048
	move.w	#8,d1
	bsr	l0036
	dbf	d4,l0005
	dbf	d5,l0004
	addi.w	#$10,l00fb
	bsr	l004a
	addi.w	#4,l00f9
	lea	l00c0,a5
	bsr	l0037
	bsr	l0051
	bsr	l004c
	move.l	l00f8,l010a
	move.l	l00f8,l010b
	move.l	l00f8,l010c
	move.l	l00f8,l010d
	move.l	l00f8,l010e
	addi.l	#$160,l010b
	addi.l	#$2d0,l010c
	addi.l	#$440,l010d
	addi.l	#$540,l010e
	move.l	l00f8,l010f
	addi.l	#$c80,l010f
	move.l	l00f8,l0110
	addi.l	#$c90,l0110
	move.l	l00f8,l0111
	addi.l	#$ca0,l0111
	move.l	l00f8,l0112
	addi.l	#$c98,l0112
	move.l	l00f8,l0113
	addi.l	#$fa8,l0113
	move.b	#0,l0116
	move.b	#0,l0117
	move.b	#4,l0118
	move.b	#1,l0119
l0006	bsr	l0035
	movea.l	l010a,a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	move.l	l0056,(a2)+
	move.l	l0057,(a2)+
	addi.l	#8,l010a
	movea.l	l00f8,a1
	lea	152(a1),a1
	cmpa.l	l010a,a1
	beq	l0007
	bra	l0008
l0007	lea	-8(a2),a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	move.l	l00f8,l010a
l0008	movea.l	l010b,a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	move.l	l0056,(a2)+
	move.l	l0057,(a2)+
	addi.l	#8,l010b
	movea.l	l00f8,a1
	lea	472(a1),a1
	cmpa.l	l010b,a1
	beq	l0009
	bra	l000a
l0009	lea	-8(a2),a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	move.l	l00f8,l010b
	addi.l	#$140,l010b
l000a	movea.l	l010c,a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	move.l	l0056,(a2)+
	move.l	l0057,(a2)+
	addi.l	#8,l010c
	movea.l	l00f8,a1
	lea	792(a1),a1
	cmpa.l	l010c,a1
	beq	l000b
	bra	l000c
l000b	lea	-8(a2),a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	move.l	l00f8,l010c
	addi.l	#$280,l010c
l000c	movea.l	l010d,a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	move.l	l0056,(a2)+
	move.l	l0057,(a2)+
	addi.l	#8,l010d
	movea.l	l00f8,a1
	lea	1112(a1),a1
	cmpa.l	l010d,a1
	beq	l000d
	bra	l000e
l000d	lea	-8(a2),a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	move.l	l00f8,l010d
	addi.l	#$3c0,l010d
l000e	movea.l	l010e,a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	move.l	l0056,(a2)+
	move.l	l0057,(a2)+
	addi.l	#8,l010e
	movea.l	l00f8,a1
	lea	1432(a1),a1
	cmpa.l	l010e,a1
	beq	l000f
	bra	l0010
l000f	lea	-8(a2),a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	move.l	l00f8,l010e
	addi.l	#$500,l010e
l0010	movea.l	l010f,a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	lea	104(a2),a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	lea	-112(a2),a2
	lea	1272(a2),a2
	move.l	l0058,(a2)+
	move.l	l0059,(a2)+
	lea	104(a2),a2
	move.l	l0058,(a2)+
	move.l	l0059,(a2)+
	lea	-112(a2),a2
	addi.l	#$500,l010f
	movea.l	l00f8,a1
	lea	14400(a1),a1
	cmpa.l	l010f,a1
	bls	l0011
	bra	l0012
l0011	lea	-8(a2),a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	lea	104(a2),a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	lea	-112(a2),a2
	move.l	l00f8,l010f
	addi.l	#$c80,l010f
l0012	movea.l	l0110,a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	lea	104(a2),a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	lea	-112(a2),a2
	lea	632(a2),a2
	move.l	l0058,(a2)+
	move.l	l0059,(a2)+
	lea	104(a2),a2
	move.l	l0058,(a2)+
	move.l	l0059,(a2)+
	lea	-112(a2),a2
	addi.l	#$280,l0110
	movea.l	l00f8,a1
	lea	14400(a1),a1
	cmpa.l	l0110,a1
	bls	l0013
	bra	l0014
l0013	lea	-8(a2),a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	lea	104(a2),a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	lea	-112(a2),a2
	move.l	l00f8,l0110
	addi.l	#$c90,l0110
l0014	movea.l	l0111,a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	lea	104(a2),a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	lea	-112(a2),a2
	lea	312(a2),a2
	move.l	l0058,(a2)+
	move.l	l0059,(a2)+
	lea	104(a2),a2
	move.l	l0058,(a2)+
	move.l	l0059,(a2)+
	lea	-112(a2),a2
	addi.l	#$140,l0111
	movea.l	l00f8,a1
	lea	14400(a1),a1
	cmpa.l	l0111,a1
	bls	l0015
	bra	l0016
l0015	lea	-8(a2),a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	lea	104(a2),a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	lea	-112(a2),a2
	move.l	l00f8,l0111
	addi.l	#$ca0,l0111
l0016	movea.l	l0112,a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	lea	104(a2),a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	lea	-112(a2),a2
	lea	952(a2),a2
	move.l	l0058,(a2)+
	move.l	l0059,(a2)+
	lea	104(a2),a2
	move.l	l0058,(a2)+
	move.l	l0059,(a2)+
	lea	-112(a2),a2
	addi.l	#$3c0,l0112
	movea.l	l00f8,a1
	lea	14400(a1),a1
	cmpa.l	l0112,a1
	bls	l0017
	bra	l0018
l0017	lea	-8(a2),a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	lea	104(a2),a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	lea	-112(a2),a2
	move.l	l00f8,l0112
	addi.l	#$c98,l0112
l0018	movea.l	l0113,a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	lea	104(a2),a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	lea	-112(a2),a2
	lea	952(a2),a2
	move.l	l0058,(a2)+
	move.l	l0059,(a2)+
	lea	104(a2),a2
	move.l	l0058,(a2)+
	move.l	l0059,(a2)+
	lea	-112(a2),a2
	addi.l	#$3c0,l0113
	movea.l	l00f8,a1
	lea	14400(a1),a1
	cmpa.l	l0113,a1
	bls	l0019
	bra	l001a
l0019	lea	-8(a2),a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	lea	104(a2),a2
	move.l	l005a,(a2)+
	move.l	l005b,(a2)+
	lea	-112(a2),a2
	move.l	l00f8,l0113
	addi.l	#$c88,l0113
l001a	cmpi.w	#$61a0,(a5)
	beq	l001b
	bra	l001c
l001b	lea	l00c0,a5
l001c	move.w	#$ff,-(a7)
	move.w	#6,-(a7)		;crawio
	trap	#1
	addq.l	#4,a7
	move.l	d0,d6
	swap	d6
	cmp.b	#$31,d0
	beq	l0026
	cmp.b	#$32,d0
	beq	l0027
	cmp.b	#$33,d0
	beq	l0028
	cmp.b	#$34,d0
	beq	l0029
	cmp.b	#$35,d0
	beq	l002a
	cmp.b	#$3b,d6
	beq	l002c
	cmp.b	#$3c,d6
	beq	l002d
	cmp.b	#$3d,d6
	beq	l002e
	cmp.b	#$3e,d6
	beq	l002f
	cmp.b	#$3f,d6
	beq	l0030
	cmp.b	#$40,d6
	beq	l0031
	cmp.b	#$41,d6		;#'A'
	beq	l0032
	cmp.b	#$42,d6
	beq	l0033
	cmp.b	#$44,d6
	beq	l002b
l001d	cmp.b	#$20,d0
	bne	l0006
	movea.l	l00f8,a1
	move.w	#$e0f,d1
l001e	clr.l	(a1)+
	dbf	d1,l001e
l001f	lea	l00c3,a3
	lea	l00c4,a4
	move.w	#$1e,d6
l0020	cmpi.w	#$61a0,(a5)
	beq	l0021
	bra	l0022
l0021	lea	l00c0,a5
l0022	bsr	l0050
	bsr	l004f
	bsr	l0034
	bsr	l0050
	bsr	l0034
	move.w	#$ff,-(a7)
	move.w	#6,-(a7)		;crawio
	trap	#1
	addq.l	#4,a7
	cmp.b	#$20,d0
	beq	l0023
	dbf	d6,l0020
	bra	l001f
l0023	bsr	l003b
	move.l	#0,$4d2.l
	bsr	l0047
	move.b	#3,$484.l
	move	#$2700,sr
	lea	8.w,a1
	lea	l0025(pc),a0
	moveq	#9,d7
l0024	move.l	(a0)+,(a1)+
	dbf	d7,l0024
	jmp	$12.w
l0025	ori.b	#$c,d0
	movea.l	4.w,a0
	jmp	(a0)
l0026	move.l	#0,$4d2.l
	move.w	#1,d0
	jsr	l005f
	move.l	#l0060,$4d2.l
	bra	l001d
l0027	move.l	#0,$4d2.l
	move.w	#2,d0
	jsr	l005f
	move.l	#l0060,$4d2.l
	bra	l001d
l0028	move.l	#0,$4d2.l
	move.w	#3,d0
	jsr	l005f
	move.l	#l0060,$4d2.l
	bra	l001d
l0029	move.l	#0,$4d2.l
	move.w	#4,d0
	jsr	l005f
	move.l	#l0060,$4d2.l
	bra	l001d
l002a	move.l	#0,$4d2.l
	move.w	#5,d0
	jsr	l005f
	move.l	#l0060,$4d2.l
	bra	l001d
l002b	move.w	#2,-(a7)
	move.w	#2,-(a7)		;bconin
	trap	#$d
	addq.l	#4,a7
	bra	l001d
l002c	addi.b	#1,l0116
	bra	l001d
l002d	subi.b	#1,l0116
	bra	l001d
l002e	addi.b	#1,l0117
	bra	l001d
l002f	subi.b	#1,l0117
	bra	l001d
l0030	addi.b	#1,l0118
	bra	l001d
l0031	subi.b	#1,l0118
	bra	l001d
l0032	addi.b	#1,l0119
	bra	l001d
l0033	subi.b	#1,l0119
	bra	l001d
l0034	move.w	#$25,-(a7)		;vsync
	trap	#$e
	addq.w	#2,a7
	rts

l0035	bsr	l004d
	bsr	l004f
	bsr	l0034
	bsr	l0034
	bsr	l0034
	rts

l0036	bsr	l0034
	dbf	d1,l0036
	rts

l0037	move.b	$fffffa07.l,l00fe
	move.b	$fffffa09.l,l00ff
	move.l	$70.l,l0100
	move.l	$120.l,l0101
	move.b	$fffffa0d.l,l0102
	move.b	$fffffa0f.l,l0103
	move.b	$fffffa11.l,l0104
	move.b	$fffffa13.l,l0105
	move.b	$fffffa15.l,l0106
	move.b	$fffffa1b.l,l0107
	move.b	$fffffa21.l,l0108
	move	sr,d0
	move	#$2700,sr
	move.l	$70.l,l0109
	move.l	#l0038,$70.l
	move.l	#l0039,$120.l
	ori.b	#1,$fffffa13.l
	move	d0,sr
	rts

l0038	move.l	#$610,$ffff8240.w
	move.l	#$370027,$ffff8244.w
	move.l	#$7770666,$ffff8248.w
	move.l	#$5000237,$ffff824c.w
	move.l	#$3600555,$ffff8250.w
	move.l	#$4440650,$ffff8254.w
	move.l	#$5400430,$ffff8258.w
	move.l	#$3200333,$ffff825c.w
	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#$60,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l0039,$120.l
	move.l	l0109,-(a7)
	rts

l0039	ori.w	#$700,sr
	move.b	l0116,l0114
	move.b	l0117,l0115
	bsr	l003c
	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#$48,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l003a,$120.l
	rte

l003a	ori.w	#$700,sr
	move.b	l0118,l0114
	move.b	l0119,l0115
	bsr	l003c
	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	rte

l003b	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	move.b	l00fe,$fffffa07.l
	move.b	l00ff,$fffffa09.l
	move.l	l0100,$70.l
	move.l	l0101,$120.l
	move.b	l0102,$fffffa0d.l
	move.b	l0103,$fffffa0f.l
	move.b	l0104,$fffffa11.l
	move.b	l0105,$fffffa13.l
	move.b	l0106,$fffffa15.l
	move.b	l0107,$fffffa1b.l
	move.b	l0108,$fffffa21.l
	rts

l003c	cmpi.b	#0,l0114
	beq	l003d
	cmpi.b	#1,l0114
	beq	l003e
	cmpi.b	#2,l0114
	beq	l003f
	cmpi.b	#3,l0114
	beq	l0040
	cmpi.b	#4,l0114
	beq	l0041
l003d	move.l	l00c5,$ffff8240.w
	move.l	l00c6,$ffff8244.w
	move.l	l00c7,$ffff8248.w
	move.l	l00c8,$ffff824c.w
	bra	l0042
l003e	move.l	l00c9,$ffff8240.w
	move.l	l00ca,$ffff8244.w
	move.l	l00cb,$ffff8248.w
	move.l	l00cc,$ffff824c.w
	bra	l0042
l003f	move.l	l00cd,$ffff8240.w
	move.l	l00ce,$ffff8244.w
	move.l	l00cf,$ffff8248.w
	move.l	l00d0,$ffff824c.w
	bra	l0042
l0040	move.l	l00d1,$ffff8240.w
	move.l	l00d2,$ffff8244.w
	move.l	l00d3,$ffff8248.w
	move.l	l00d4,$ffff824c.w
	bra	l0042
l0041	move.l	l00d5,$ffff8240.w
	move.l	l00d6,$ffff8244.w
	move.l	l00d7,$ffff8248.w
	move.l	l00d8,$ffff824c.w
	bra	l0042
l0042	cmpi.b	#0,l0115
	beq	l0043
	cmpi.b	#1,l0115
	beq	l0044
	cmpi.b	#2,l0115
	beq	l0045
l0043	move.l	l00d9,$ffff8250.w
	move.l	l00da,$ffff8254.w
	move.l	l00db,$ffff8258.w
	move.l	l00dc,$ffff825c.w
	bra	l0046
l0044	move.l	l00dd,$ffff8250.w
	move.l	l00de,$ffff8254.w
	move.l	l00df,$ffff8258.w
	move.l	l00e0,$ffff825c.w
	bra	l0046
l0045	move.l	l00e1,$ffff8250.w
	move.l	l00e2,$ffff8254.w
	move.l	l00e3,$ffff8258.w
	move.l	l00e4,$ffff825c.w
	bra	l0046
l0046	rts

l0047	move.l	#$8080000,$ffff8800.l
	move.l	#$9090000,$ffff8800.l
	move.l	#$a0a0000,$ffff8800.l
	rts

l0048	dc.b	$a0,$00,'3',$fc,$00,'@'
	dc.l	l00e5
	dc.b	'3',$fc,$00,$1a
	dc.l	l00e6
	dc.b	'3',$fc,$00,$04
	dc.l	l00e7
	dc.b	'3',$fc,$00,$0f
	dc.l	l00e8
	dc.b	'3',$fc,$00,$00
	dc.l	l00e9
	dc.b	'#',$fc,$03,$03,$03,$03
	dc.l	l00ea
	dc.b	'3',$f9
	dc.l	l00fa
	dc.l	l00eb
	dc.b	'3',$fc,$00,$06
	dc.l	l00ec
	dc.b	'#',$fc
	dc.l	l0055
	dc.l	l00ed
	dc.b	'3',$fc,$00,$08
	dc.l	l00ee
	dc.b	'3',$fc,$00,$a0
	dc.l	l00ef
	dc.b	'3',$fc,$00,$02
	dc.l	l00f0
	dc.b	'3',$f9
	dc.l	l00f9
	dc.l	l00f1
	dc.b	'3',$fc,$00,$00
	dc.l	l00f2
	dc.b	'#',$f9
	dc.l	l00f8
	dc.l	l00f3
	dc.b	'3',$fc,$00,$08
	dc.l	l00f4
	dc.b	'3',$fc,$00,$a0
	dc.l	l00f5
	dc.b	'3',$fc,$00,$02
	dc.l	l00f6
	dc.b	'#',$fc,$00,$00,$00,$00
	dc.l	l00f7
	dc.b	'M',$f9
	dc.l	l00e5
	dc.b	$a0,$07
	rts

l0049	dc.b	$a0,$00,'3',$fc,$00,'@'
	dc.l	l00e5
	dc.b	'3',$fc,$00,' '
	dc.l	l00e6
	dc.b	'3',$fc,$00,$04
	dc.l	l00e7
	dc.b	'3',$fc,$00,$0f
	dc.l	l00e8
	dc.b	'3',$fc,$00,$00
	dc.l	l00e9
	dc.b	'#',$fc,$03,$03,$03,$03
	dc.l	l00ea
	dc.b	'3',$fc,$01,$00
	dc.l	l00eb
	dc.b	'3',$fc,$00,' '
	dc.l	l00ec
	dc.b	'#',$fc
	dc.l	l0055
	dc.l	l00ed
	dc.b	'3',$fc,$00,$08
	dc.l	l00ee
	dc.b	'3',$fc,$00,$a0
	dc.l	l00ef
	dc.b	'3',$fc,$00,$02
	dc.l	l00f0
	dc.b	'3',$f9
	dc.l	l00f9
	dc.l	l00f1
	dc.b	'3',$fc,$00,$00
	dc.l	l00f2
	dc.b	'#',$f9
	dc.l	l00f8
	dc.l	l00f3
	dc.b	'3',$fc,$00,$08
	dc.l	l00f4
	dc.b	'3',$fc,$00,$a0
	dc.l	l00f5
	dc.b	'3',$fc,$00,$02
	dc.l	l00f6
	dc.b	'#',$fc,$00,$00,$00,$00
	dc.l	l00f7
	dc.b	'M',$f9
	dc.l	l00e5
	dc.b	$a0,$07
	rts

l004a	dc.b	$a0,$00,'3',$fc,$00,$10
	dc.l	l00e5
	dc.b	'3',$fc,$00,$10
	dc.l	l00e6
	dc.b	'3',$fc,$00,$04
	dc.l	l00e7
	dc.b	'3',$fc,$00,$0f
	dc.l	l00e8
	dc.b	'3',$fc,$00,$00
	dc.l	l00e9
	dc.b	'#',$fc,$03,$03,$03,$03
	dc.l	l00ea
	dc.b	'3',$f9
	dc.l	l00fb
	dc.l	l00eb
	dc.b	'3',$fc,$00,' '
	dc.l	l00ec
	dc.b	'#',$fc
	dc.l	l0055
	dc.l	l00ed
	dc.b	'3',$fc,$00,$08
	dc.l	l00ee
	dc.b	'3',$fc,$00,$a0
	dc.l	l00ef
	dc.b	'3',$fc,$00,$02
	dc.l	l00f0
	dc.b	'3',$fc,$00,$98
	dc.l	l00f1
	dc.b	'3',$fc,$00,$08
	dc.l	l00f2
	dc.b	'#',$f9
	dc.l	l00f8
	dc.l	l00f3
	dc.b	'3',$fc,$00,$08
	dc.l	l00f4
	dc.b	'3',$fc,$00,$a0
	dc.l	l00f5
	dc.b	'3',$fc,$00,$02
	dc.l	l00f6
	dc.b	'#',$fc,$00,$00,$00,$00
	dc.l	l00f7
	dc.b	'M',$f9
	dc.l	l00e5
	dc.b	$a0,$07
	rts

l004b	dc.b	$a0,$00,'3',$fc,$00,$10
	dc.l	l00e5
	dc.b	'3',$fc,$00,$10
	dc.l	l00e6
	dc.b	'3',$fc,$00,$04
	dc.l	l00e7
	dc.b	'3',$fc,$00,$0f
	dc.l	l00e8
	dc.b	'3',$fc,$00,$00
	dc.l	l00e9
	dc.b	'#',$fc,$03,$03,$03,$03
	dc.l	l00ea
	dc.b	'3',$f9
	dc.l	l00fc
	dc.l	l00eb
	dc.b	'3',$fc,$00,'0'
	dc.l	l00ec
	dc.b	'#',$fc
	dc.l	l0055
	dc.l	l00ed
	dc.b	'3',$fc,$00,$08
	dc.l	l00ee
	dc.b	'3',$fc,$00,$a0
	dc.l	l00ef
	dc.b	'3',$fc,$00,$02
	dc.l	l00f0
	dc.b	'3',$fc,$00,$98
	dc.l	l00f1
	dc.b	'3',$fc,$00,$16
	dc.l	l00f2
	dc.b	'#',$f9
	dc.l	l00f8
	dc.l	l00f3
	dc.b	'3',$fc,$00,$08
	dc.l	l00f4
	dc.b	'3',$fc,$00,$a0
	dc.l	l00f5
	dc.b	'3',$fc,$00,$02
	dc.l	l00f6
	dc.b	'#',$fc,$00,$00,$00,$00
	dc.l	l00f7
	dc.b	'M',$f9
	dc.l	l00e5
	dc.b	$a0,$07
	rts

l004c	dc.b	$a0,$00,'3',$fc,$00,$8c
	dc.l	l00e5
	dc.b	'3',$fc,$00,'&'
	dc.l	l00e6
	dc.b	'3',$fc,$00,$04
	dc.l	l00e7
	dc.b	'3',$fc,$00,$0f
	dc.l	l00e8
	dc.b	'3',$fc,$00,$00
	dc.l	l00e9
	dc.b	'#',$fc,$03,$03,$03,$03
	dc.l	l00ea
	dc.b	'3',$fc,$00,$b4
	dc.l	l00eb
	dc.b	'3',$fc,$00,$84
	dc.l	l00ec
	dc.b	'#',$fc
	dc.l	l0055
	dc.l	l00ed
	dc.b	'3',$fc,$00,$08
	dc.l	l00ee
	dc.b	'3',$fc,$00,$a0
	dc.l	l00ef
	dc.b	'3',$fc,$00,$02
	dc.l	l00f0
	dc.b	'3',$fc,$00,'Z'
	dc.l	l00f1
	dc.b	'3',$fc,$00,$80
	dc.l	l00f2
	dc.b	'#',$f9
	dc.l	l00f8
	dc.l	l00f3
	dc.b	'3',$fc,$00,$08
	dc.l	l00f4
	dc.b	'3',$fc,$00,$a0
	dc.l	l00f5
	dc.b	'3',$fc,$00,$02
	dc.l	l00f6
	dc.b	'#',$fc,$00,$00,$00,$00
	dc.l	l00f7
	dc.b	'M',$f9
	dc.l	l00e5
	dc.b	$a0,$07
	rts

l004d	dc.b	'?<',$00,$09,'?<',$00,'@'
	dc.b	'?<',$00,$1c,'NN\O'
	dc.b	'3',$c0
	dc.l	l00fd
	dc.b	$a0,$00,'3',$fc,$00,' '
	dc.l	l00e5
	dc.b	'3',$fc,$00,'0'
	dc.l	l00e6
	dc.b	'3',$fc,$00,$04
	dc.l	l00e7
	dc.b	'3',$fc,$00,$0f
	dc.l	l00e8
	dc.b	'3',$fc,$00,$00
	dc.l	l00e9
	dc.b	'#',$fc,$03,$03,$03,$03
	dc.l	l00ea
	dc.b	'3',$fc,$00,$00
	dc.l	l00eb
	dc.b	'3',$fc,$00,'@'
	dc.l	l00ec
	dc.b	'#',$fc
	dc.l	l0055
	dc.l	l00ed
	dc.b	'3',$fc,$00,$08
	dc.l	l00ee
	dc.b	'3',$fc,$00,$a0
	dc.l	l00ef
	dc.b	'3',$fc,$00,$02
	dc.l	l00f0
	dc.b	'3',$fc,$00,'h'
	dc.l	l00f1
	dc.b	'3',$f9
	dc.l	l00fd
	dc.l	l00f2
	dc.b	'#',$f9
	dc.l	l00f8
	dc.l	l00f3
	dc.b	'3',$fc,$00,$08
	dc.l	l00f4
	dc.b	'3',$fc,$00,$a0
	dc.l	l00f5
	dc.b	'3',$fc,$00,$02
	dc.l	l00f6
	dc.b	'#',$fc,$00,$00,$00,$00
	dc.l	l00f7
	dc.b	'M',$f9
	dc.l	l00e5
	dc.b	$a0,$07,'?<',$00,$0a,'?<'
	dc.b	$00,'@?<',$00,$1c,'NN'
	dc.b	'\',$8f,'3',$c0
	dc.l	l00fd
	dc.b	$a0,$00,'3',$fc,$00,' '
	dc.l	l00e5
	dc.b	'3',$fc,$00,'0'
	dc.l	l00e6
	dc.b	'3',$fc,$00,$04
	dc.l	l00e7
	dc.b	'3',$fc,$00,$0f
	dc.l	l00e8
	dc.b	'3',$fc,$00,$00
	dc.l	l00e9
	dc.b	'#',$fc,$03,$03,$03,$03
	dc.l	l00ea
	dc.b	'3',$fc,$00,' '
	dc.l	l00eb
	dc.b	'3',$fc,$00,'@'
	dc.l	l00ec
	dc.b	'#',$fc
	dc.l	l0055
	dc.l	l00ed
	dc.b	'3',$fc,$00,$08
	dc.l	l00ee
	dc.b	'3',$fc,$00,$a0
	dc.l	l00ef
	dc.b	'3',$fc,$00,$02
	dc.l	l00f0
	dc.b	'3',$fc,$00,$b8
	dc.l	l00f1
	dc.b	'3',$f9
	dc.l	l00fd
	dc.l	l00f2
	dc.b	'#',$f9
	dc.l	l00f8
	dc.l	l00f3
	dc.b	'3',$fc,$00,$08
	dc.l	l00f4
	dc.b	'3',$fc,$00,$a0
	dc.l	l00f5
	dc.b	'3',$fc,$00,$02
	dc.l	l00f6
	dc.b	'#',$fc,$00,$00,$00,$00
	dc.l	l00f7
	dc.b	'M',$f9
	dc.l	l00e5
	dc.b	$a0,$07
	move.w	#8,-(a7)
	move.w	#$40,-(a7)
	move.w	#$1c,-(a7)		;giaccess
	trap	#$e
	addq.l	#6,a7
	move.w	d0,l00fd
	cmpi.w	#$d,l00fd
	bls	l004e
	move.w	#$c0,l00fa
	bsr	l0048
	rts

l004e	move.w	#$100,l00fa
	bsr	l0048
	dc.b	'Nu'
l004f	dc.b	'"y'
	dc.l	l00f8
	dc.b	'$y'
	dc.l	l00f8
	dc.b	'C',$e9,'=',$e0,'E',$ea,'=',$e0
	dc.b	'C',$e9,$00,$08,'E',$d2,':<'
	dc.b	$00,$1a,'2<',$00,'%$',$d9
	dc.b	'Q',$c9,$ff,$fc,'Q',$cd,$ff,$f4
	dc.b	$a0,$00,'3',$fc,$00,$10
	dc.l	l00e5
	dc.b	'3',$fc,$00,$19
	dc.l	l00e6
	dc.b	'3',$fc,$00,$04
	dc.l	l00e7
	dc.b	'3',$fc,$00,$0f
	dc.l	l00e8
	dc.b	'3',$fc,$00,$00
	dc.l	l00e9
	dc.b	'#',$fc,$03,$03,$03,$03
	dc.l	l00ea
	dc.b	'3',$dd
	dc.l	l00eb
	dc.b	'3',$fc,$00,$00
	dc.l	l00ec
	dc.b	'#',$fc
	dc.l	l00c1
	dc.l	l00ed
	dc.b	'3',$fc,$00,$08
	dc.l	l00ee
	dc.b	'3',$fc,$00,$a0
	dc.l	l00ef
	dc.b	'3',$fc,$00,$02
	dc.l	l00f0
	dc.b	'3',$fc,$01,'0'
	dc.l	l00f1
	dc.b	'3',$fc,$00,'c'
	dc.l	l00f2
	dc.b	'#',$f9
	dc.l	l00f8
	dc.l	l00f3
	dc.b	'3',$fc,$00,$08
	dc.l	l00f4
	dc.b	'3',$fc,$00,$a0
	dc.l	l00f5
	dc.b	'3',$fc,$00,$02
	dc.l	l00f6
	dc.b	'#',$fc,$00,$00,$00,$00
	dc.l	l00f7
	dc.b	'M',$f9
	dc.l	l00e5
	dc.b	$a0,$07,'Nu'
l0050	dc.b	$a0,$00,'3',$fc,$00,$80
	dc.l	l00e5
	dc.b	'3',$fc,$00,$01
	dc.l	l00e6
	dc.b	'3',$fc,$00,$04
	dc.l	l00e7
	dc.b	'3',$fc,$00,$0f
	dc.l	l00e8
	dc.b	'3',$fc,$00,$00
	dc.l	l00e9
	dc.b	'#',$fc,$03,$03,$03,$03
	dc.l	l00ea
	dc.b	'3',$fc,$00,$00
	dc.l	l00eb
	dc.b	'3',$fc,$00,'#'
	dc.l	l00ec
	dc.b	'#',$fc
	dc.l	l0055
	dc.l	l00ed
	dc.b	'3',$fc,$00,$08
	dc.l	l00ee
	dc.b	'3',$fc,$00,$a0
	dc.l	l00ef
	dc.b	'3',$fc,$00,$02
	dc.l	l00f0
	dc.b	'3',$db
	dc.l	l00f1
	dc.b	'3',$fc,$00,$00
	dc.l	l00f2
	dc.b	'#',$f9
	dc.l	l00f8
	dc.l	l00f3
	dc.b	'3',$fc,$00,$08
	dc.l	l00f4
	dc.b	'3',$fc,$00,$a0
	dc.l	l00f5
	dc.b	'3',$fc,$00,$02
	dc.l	l00f6
	dc.b	'#',$fc,$00,$00,$00,$00
	dc.l	l00f7
	dc.b	'M',$f9
	dc.l	l00e5
	dc.b	$a0,$07,$a0,$00,'3',$fc,$00,$80
	dc.l	l00e5
	dc.b	'3',$fc,$00,$01
	dc.l	l00e6
	dc.b	'3',$fc,$00,$04
	dc.l	l00e7
	dc.b	'3',$fc,$00,$0f
	dc.l	l00e8
	dc.b	'3',$fc,$00,$00
	dc.l	l00e9
	dc.b	'#',$fc,$03,$03,$03,$03
	dc.l	l00ea
	dc.b	'3',$fc,$00,$00
	dc.l	l00eb
	dc.b	'3',$fc,$00,'#'
	dc.l	l00ec
	dc.b	'#',$fc
	dc.l	l0055
	dc.l	l00ed
	dc.b	'3',$fc,$00,$08
	dc.l	l00ee
	dc.b	'3',$fc,$00,$a0
	dc.l	l00ef
	dc.b	'3',$fc,$00,$02
	dc.l	l00f0
	dc.b	'3',$dc
	dc.l	l00f1
	dc.b	'3',$fc,$00,$03
	dc.l	l00f2
	dc.b	'#',$f9
	dc.l	l00f8
	dc.l	l00f3
	dc.b	'3',$fc,$00,$08
	dc.l	l00f4
	dc.b	'3',$fc,$00,$a0
	dc.l	l00f5
	dc.b	'3',$fc,$00,$02
	dc.l	l00f6
	dc.b	'#',$fc,$00,$00,$00,$00
	dc.l	l00f7
	dc.b	'M',$f9
	dc.l	l00e5
	dc.b	$a0,$07,'"y'
	dc.l	l00f8
	dc.b	'$y'
	dc.l	l00f8
	dc.b	'E',$ea,$03,$c0,'C',$e9,'8@'
	dc.b	'E',$ea,'8@2<',$0e,$0f
	dc.b	'%!Q',$c9,$ff,$fc
	rts

l0051	movea.l	l00f8,a2
	lea	27200(a2),a2
	lea	l0053,a1
	lea	34(a1),a1
	lea	27200(a1),a1
	move.w	#$4af,d1
l0052	move.l	(a1)+,(a2)+
	dbf	d1,l0052
	rts

l0053	dc.b	$00,$00
l0054	dc.b	$00,$00,$06,$10,$00,$27,$00,$16
	dc.b	$07,'w',$06,'f',$05,$00,$02,'7'
	dc.b	$03,'`',$05,'U',$04,'D',$06,'P'
	dc.b	$05,'@',$04,'0',$03,' ',$03,'3'
l0055	dcb.w	2
	dc.b	'pO',$00,$00,$00,$00,$00,$00
	dc.b	'<3',$00,$00,$00,$00,$00,$00
	dc.b	$c7,'>',$00,$00,$00,$00,$00,$00
	dc.b	'q',$c0,$00,$00,$00,$00,$00,$00
	dc.b	$00,$10,$00,$00,$00,$00,$00,$00
	dc.b	$03,$18,$00,$00,$00,$00,$00,$00
	dc.b	'a',$cf,$00,$00,$00,$00,$00,$00
	dc.b	$1e,$f3,$00,$00,$00,$00,$00,$00
	dc.b	$ef,$9e,$00,$00,$00,$00,$00,$00
	dc.b	$89,$c0,$00,$00,$00,$00,$00,$00
	dc.b	$92,'B',$00,$00,$00,$00,$00,$00
	dc.b	'(',$9c,$00,$00,$00,$00,$00,$00
	dc.b	$f1,$cf,$00,$00,$00,$00,$00,$00
	dc.b	$1e,$fa,$00,$00,$00,$00,$00,$00
	dc.b	'(',$a2,$00,$00,$00,$00,$00,$00
	dc.b	$8a,'/',$00,$00,$00,$00,$00,$00
	dc.b	$80,$00,$00,$00,$00,$00,$00,$00
	dcb.w	10
	dc.b	$98,$c0,$00,$00,$98,$c0,$00,$00
	dc.b	$82,'R',$00,$00,$82,'R',$00,$00
	dc.b	$08,$02,$00,$00,$08,$02,$00,$00
	dc.b	$8a,'!',$00,$00,$8a,'!',$00,$00
	dc.b	$04,$10,$00,$00,$04,$10,$00,$00
	dc.b	$06,'$',$00,$00,$06,'$',$00,$00
	dc.b	'2(',$00,$00,'2(',$00,$00
	dc.b	$a0,$8a,$00,$00,$a0,$8a,$00,$00
	dc.b	$08,' ',$00,$00,$08,' ',$00,$00
	dc.b	$88,$80,$00,$00,$88,$80,$00,$00
	dc.b	$94,'C',$00,$00,$94,'C',$00,$00
	dc.b	'l',$a2,$00,$00,'l',$a2,$00,$00
	dc.b	$8a,'(',$00,$00,$8a,'(',$00,$00
	dc.b	$a0,'"',$00,$00,$a0,'"',$00,$00
	dc.b	'(',$a2,$00,$00,'(',$a2,$00,$00
	dc.b	'R!',$00,$00,'R!',$00,$00
	dcb.w	16
	dc.b	$a8,'G',$00,$00,$00,$00,$a8,'G'
	dc.b	$1c,$93,$00,$00,$00,$00,$1c,$93
	dc.b	$cf,$04,$00,$00,$00,$00,$cf,$04
	dc.b	'q',$e0,$00,$00,$00,$00,'q',$e0
	dc.b	$00,$10,$00,$00,$00,$00,$00,$10
	dc.b	$06,$08,$00,$00,$00,$00,$06,$08
	dc.b	'3',$ef,$00,$00,$00,$00,'3',$ef
	dc.b	' ',$8b,$00,$00,$00,$00,' ',$8b
	dc.b	$cf,'&',$00,$00,$00,$00,$cf,'&'
	dc.b	$f8,$80,$00,$00,$00,$00,$f8,$80
	dc.b	$98,'B',$00,$00,$00,$00,$98,'B'
	dc.b	$aa,$a2,$00,$00,$00,$00,$aa,$a2
	dc.b	$f2,'/',$00,$00,$00,$00,$f2,'/'
	dc.b	$1c,'"',$00,$00,$00,$00,$1c,'"'
	dc.b	'(',$aa,$00,$00,$00,$00,'(',$aa
	dc.b	'!B',$00,$00,$00,$00,'!B'
	dcb.w	17
	dc.b	$c8,'H',$00,$00,$c8,'H',$00,$00
	dc.b	$02,$f8,$00,$00,$02,$f8,$00,$00
	dc.b	'(',$88,$00,$00,'(',$88,$00,$00
	dc.b	$88,' ',$00,$00,$88,' ',$00,$00
	dc.b	$04,$00,$00,$00,$04,$00,$00,$00
	dc.b	$06,$00,$00,$00,$06,$00,$00,$00
	dc.b	'2(',$00,$00,'2(',$00,$00
	dc.b	$a0,$8a,$00,$00,$a0,$8a,$00,$00
	dc.b	$08,'"',$00,$00,$08,'"',$00,$00
	dc.b	$88,$88,$00,$00,$88,$88,$00,$00
	dc.b	$94,'B',$00,$00,$94,'B',$00,$00
	dc.b	')',$a2,$00,$00,')',$a2,$00,$00
	dc.b	$82,'*',$00,$00,$82,'*',$00,$00
	dc.b	$02,'"',$00,$00,$02,'"',$00,$00
	dc.b	'%6',$00,$00,'%6',$00,$00
	dc.b	'P',$84,$00,$00,'P',$84,$00,$00
	dcb.w	15
	dc.b	'pOpOpOpO'
	dc.b	$bc,$13,$bc,$13,$bc,$13,$bc,$13
	dc.b	$c7,$08,$c7,$08,$c7,$08,$c7,$08
	dc.b	'q',$c1,'q',$c1,'q',$c1,'q',$c1
	dc.b	$04,$10,$04,$10,$04,$10,$04,$10
	dc.b	$03,$08,$03,$08,$03,$08,$03,$08
	dc.b	'b/b/b/b/'
	dc.b	$1e,$f3,$1e,$f3,$1e,$f3,$1e,$f3
	dc.b	$e8,$1e,$e8,$1e,$e8,$1e,$e8,$1e
	dc.b	$89,$c7,$89,$c7,$89,$c7,$89,$c7
	dc.b	$12,'z',$12,'z',$12,'z',$12,'z'
	dc.b	'(',$9c,'(',$9c,'(',$9c,'(',$9c
	dc.b	$81,$c9,$81,$c9,$81,$c9,$81,$c9
	dc.b	$bc,'!',$bc,'!',$bc,'!',$bc,'!'
	dc.b	$e2,'"',$e2,'"',$e2,'"',$e2,'"'
	dc.b	$88,$8f,$88,$8f,$88,$8f,$88,$8f
	dc.b	$88,$00,$88,$00,$88,$00,$88,$00
	dcb.w	28
	dc.b	$08,$00,$08,$00,$08,$00,$08,$00
	dcb.w	28
	dc.b	$00,'`',$00,'`',$00,'`',$00,'`'
	dcb.w	68
	dc.b	$00,$01,'?',$c0,'?',$ff,$00,$00
	dcb.w	76
	dc.b	$0f,$c1,'0',$00,'0',$7f,$00,$00
	dcb.w	76
	dc.b	$1f,$c1,'`',$00,'`',$7f,$00,$00
	dcb.w	76
	dc.b	'?',$c1,'@',$00,'@',$7f,$00,$00
	dcb.w	76
	dc.b	'?',$e1,'@',$00,'@?',$00,$00
	dcb.w	76
	dc.b	$1b,$f1,'`',$00,'d',$1f,$00,$00
	dcb.w	76
	dc.b	$13,$f1,' ',$00,',',$1f,$00,$00
	dcb.w	76
	dc.b	$17,$f1,$00,$00,$18,$1f,$00,$00
	dcb.w	65
	dc.b	$1e,$00,$1e,$00,$00,$00,$00,$00
	dcb.w	7
	dc.b	$1f,$f1,$00,$00,$10,$1f,$00,$00
	dcb.w	52
	dc.b	$00,$0f,$00,$00,$00,$0f,$00,$00
	dc.b	$80,$00,'|',$00,$fc,$00,$00,$00
	dcb.w	4
	dc.b	$1c,$00,'#',$00,'#',$00,$00,$00
	dcb.w	8
	dc.b	$05,$f1,$18,$00,$1a,$1f,$00,$00
	dcb.w	52
	dc.b	$00,$10,$00,$00,$00,$1f,$00,$00
	dc.b	$7f,'`',$00,$93,$c3,$f3,$00,$00
	dc.b	$00,$00,$e0,$00,$e0,$00,$00,$00
	dc.b	'>',$00,'A',$80,'A',$80,$00,$00
	dcb.w	8
	dc.b	$05,$f1,$00,$00,$06,$1f,$00,$00
	dcb.w	52
	dc.b	$00,' ',$00,$00,$00,'?',$00,$00
	dc.b	'<',$8d,$00,$12,$e3,'~',$00,$00
	dc.b	$80,$00,'p',$00,'p',$00,$00,$00
	dc.b	'?',$00,'@',$c0,'@',$c0,$00,$00
	dcb.w	8
	dc.b	$07,$f1,$00,$00,$04,$1f,$00,$00
	dcb.w	32
	dc.b	$01,$f0,'>',$00,'?',$f0,$00,$00
	dcb.w	13
	dc.b	'|',$f8,'|',$f8,$00,$00,$00,' '
	dc.b	$00,$00,$00,'?',$00,$00,'?',$93
	dc.b	$00,$00,$e0,'l',$00,$00,$e0,$00
	dc.b	$18,$00,$18,$00,$00,$00,$7f,$00
	dc.b	$00,$c0,'@',$c0,$00,$00,$00,$00
	dcb.w	4
	dc.b	$00,'|',$00,'|',$00,$00,$00,$f1
	dc.b	$06,$00,$07,$1f,$00,$00,$00,$00
	dcb.w	8
	dc.b	$07,$c0,$07,$c0,$00,$00,$00,$00
	dc.b	$03,$e0,$03,$e0,$00,$00,$00,$00
	dcb.w	8
	dc.b	$07,$c0,$07,$c0,$00,$00,$00,$06
	dc.b	$07,$c9,$07,$cf,$00,$00,$fe,'8'
	dc.b	$00,$00,$c3,$f8,$00,$00,$00,$00
	dcb.w	11
	dc.b	'8p',$c7,$8e,$c7,$8e,$00,$00
	dc.b	$00,$10,$00,$00,$00,$1f,$00,$00
	dc.b	'?',$f3,$00,$00,$e0,$0c,$00,$00
	dc.b	$e0,$00,$18,$00,$18,$00,$00,$00
	dc.b	'_',$80,$00,'```',$00,$00
	dcb.w	4
	dc.b	$00,'8',$00,$c7,$00,$c7,$00,$00
	dc.b	$02,$f1,$00,$00,$03,$1f,$00,$00
	dcb.w	8
	dc.b	$03,$80,$0c,'p',$0c,'p',$00,$00
	dc.b	$01,$c0,$0e,'0',$0e,'0',$00,$00
	dcb.w	8
	dc.b	$03,$80,$0c,'p',$0c,'p',$00,$00
	dc.b	$01,$b1,$0e,'H',$0e,'~',$00,$00
	dc.b	'<',$1c,$00,$00,$c7,$fc,$00,$00
	dcb.w	8
	dc.b	$00,$03,$00,$04,$00,$07,$00,$00
	dc.b	'v',$f8,$89,$06,$8f,$06,$00,$00
	dc.b	$00,$0c,$00,$00,$00,$0f,$00,$00
	dc.b	$1f,$ff,$00,$00,$f0,$00,$00,$00
	dc.b	$e0,$00,$18,$00,$18,$00,$00,$00
	dc.b	'O',$80,$80,'`',$b0,'`',$00,$00
	dcb.w	4
	dc.b	$03,'|',$04,$83,$07,$83,$00,$00
	dc.b	$03,$f1,$00,$00,$02,$1f,$00,$00
	dcb.w	8
	dc.b	'7',$c0,'H0x0',$00,$00
	dc.b	$03,$ec,$0c,$12,$0c,$1e,$00,$00
	dcb.w	8
	dc.b	'7',$c0,'H0x0',$00,$00
	dc.b	$07,$c9,$18,$00,$18,'6',$00,$00
	dc.b	$fc,$0c,$00,$00,$07,$fc,$00,$00
	dcb.w	8
	dc.b	$00,$02,$00,$04,$00,$05,$00,$00
	dc.b	't',$fc,$08,$03,$8b,$03,$00,$00
	dc.b	$00,$03,$00,$00,$00,$03,$00,$00
	dc.b	$0f,$ff,$00,$00,$fc,$00,$00,$00
	dc.b	$c0,$01,'8',$00,'8',$01,$00,$00
	dc.b	$ef,$c0,$00,'0',$90,'0',$00,$00
	dcb.w	4
	dc.b	$02,'~',$04,$01,$05,$81,$00,$00
	dc.b	$01,$f1,$82,$00,$82,$1f,$00,$00
	dcb.w	8
	dc.b	$27,$e0,'@',$18,'X',$18,$00,$00
	dc.b	$07,$e4,$18,$02,$18,$1a,$00,$00
	dcb.w	8
	dc.b	$27,$e0,'@',$18,'X',$18,$00,$00
	dc.b	$07,$cf,$18,$00,$18,'0',$00,$00
	dc.b	$fc,$08,$00,$00,$07,$f8,$00,$00
	dcb.w	8
	dc.b	$00,$1f,$00,' ',$00,'8',$00,$00
	dc.b	'>|@',$03,$f1,$83,$00,$00
	dcb.w	4
	dc.b	$c3,$ff,$00,$00,$ff,$00,$00,$00
	dc.b	$80,$01,'p',$02,'p',$02,$00,$00
	dc.b	'?',$f0,$00,$00,$c0,'0',$00,$00
	dcb.w	4
	dc.b	$1f,'> ',$01,'8',$c1,$00,$00
	dc.b	$00,$f1,$83,$00,$83,$1f,$00,$00
	dcb.w	4
	dc.b	$00,$01,$00,$02,$00,$03,$00,$00
	dc.b	$f3,$e0,$00,$18,$8c,$18,$00,$00
	dc.b	$07,$cf,$18,$00,$18,'1',$00,$00
	dc.b	$80,$00,'@',$00,$c0,$00,$00,$00
	dc.b	$00,$01,$00,$02,$00,$03,$00,$00
	dc.b	$f3,$e0,$00,$18,$8c,$18,$00,$00
	dc.b	$07,$ff,$18,$00,$18,$00,$00,$00
	dc.b	$f8,'0',$00,$00,$0f,$f0,$00,$00
	dcb.w	8
	dc.b	$00,$d1,$03,'&',$03,$ef,$00,$00
	dc.b	$a7,$fc,'@',$03,$d8,$03,$00,$00
	dcb.w	4
	dc.b	'0',$ff,$00,$00,'?',$c0,$00,$00
	dc.b	$80,$07,'`',$08,'`',$0e,$00,$00
	dc.b	$ff,$f8,$00,$00,$00,'x',$00,$00
	dc.b	$00,$00,$00,$03,$00,$03,$00,$00
	dc.b	$d3,$fe,' ',$01,$ec,$01,$00,$00
	dc.b	$00,$e1,$81,$00,$81,'?',$00,$00
	dcb.w	4
	dc.b	$00,$0d,$00,'2',$00,'>',$00,$00
	dc.b	'?',$e0,$00,$18,$c0,$18,$00,$00
	dc.b	$07,$fc,$18,$00,$18,$03,$00,$00
	dc.b	$b0,$00,'L',$00,'|',$00,$00,$00
	dc.b	$00,$0d,$00,'2',$00,'>',$00,$00
	dc.b	'?',$e0,$00,$18,$c0,$18,$00,$00
	dc.b	$03,$ff,$1c,$00,$1c,$00,$00,$00
	dc.b	$f0,$c0,$00,$00,'?',$c0,$00,$00
	dcb.w	8
	dc.b	$00,$81,$0f,$1e,$0f,'~',$00,$00
	dc.b	'?',$fc,$00,$03,$c0,$03,$00,$00
	dcb.w	4
	dc.b	$0c,'?',$00,$00,$0f,$ff,$00,$00
	dc.b	$80,$04,'@8@;',$00,$00
	dc.b	$ff,$b8,$00,$00,$00,$f8,$00,$00
	dc.b	$00,$00,$00,$0f,$00,$0f,$00,$00
	dc.b	$9f,$fe,$00,$01,'`',$01,$00,$00
	dc.b	$00,$c1,$81,$00,$81,$7f,$00,$00
	dcb.w	4
	dc.b	$00,$09,$00,$f0,$00,$f6,$00,$00
	dc.b	$ff,$e0,$00,$18,$00,$18,$00,$00
	dc.b	$07,$ff,$18,$00,$18,$00,$00,$00
	dc.b	$90,$00,$0f,$00,'o',$00,$00,$00
	dc.b	$00,$09,$00,$f0,$00,$f6,$00,$00
	dc.b	$ff,$e0,$00,$18,$00,$18,$00,$00
	dc.b	$01,$ff,$0e,$00,$0e,$00,$00,$00
	dc.b	$c3,$00,$00,$00,$ff,$00,$00,$00
	dcb.w	8
	dc.b	'?',$ff,$00,$00,'8p',$00,$00
	dc.b	$ff,$fc,$00,$03,$00,$03,$00,$00
	dcb.w	4
	dc.b	$03,$09,$00,$00,$03,$ff,$00,$00
	dc.b	$c0,$ff,$00,$00,$c0,$e0,$00,$00
	dc.b	$ff,$b8,$00,$00,$00,$f8,$00,$00
	dc.b	$00,'?',$00,$00,$00,'8',$00,$00
	dc.b	$ff,$fe,$00,$01,$00,$01,$00,$00
	dc.b	$00,$81,$80,$00,$80,$ff,$00,$00
	dcb.w	4
	dc.b	$03,$ff,$00,$00,$03,$80,$00,$00
	dc.b	$ff,$e0,$00,$18,$00,$18,$00,$00
	dc.b	$07,$ff,$18,$00,$18,$00,$00,$00
	dc.b	$ff,$c0,$00,$00,$01,$c0,$00,$00
	dc.b	$03,$ff,$00,$00,$03,$80,$00,$00
	dc.b	$ff,$e0,$00,$18,$00,$18,$00,$00
	dc.b	$01,$ff,$06,$00,$06,$03,$00,$00
	dc.b	$0c,$00,$00,$00,$fc,$00,$00,$00
	dcb.w	8
	dc.b	$c7,$8f,$00,$00,$fd,$f8,$00,$00
	dc.b	$ff,$fc,$00,$03,$00,$1f,$00,$00
	dcb.w	4
	dc.b	$00,$d3,$00,$00,$00,$ff,$00,$00
	dc.b	$83,$1f,$00,$00,$83,$f0,$00,$00
	dc.b	$ff,$b8,$00,$00,$07,$f8,$00,$00
	dc.b	$00,$c7,$00,$00,$00,$fc,$00,$00
	dc.b	$ff,$fe,$00,$01,$00,$0f,$00,$00
	dc.b	$00,$81,$80,$00,$80,$ff,$00,$00
	dcb.w	4
	dc.b	$0c,$7f,$00,$00,$0f,$c0,$00,$00
	dc.b	$ff,$e0,$00,$18,$00,$f8,$00,$00
	dc.b	$07,$ff,$18,$00,$1f,$00,$00,$00
	dc.b	$fe,'0',$00,$00,$03,$f0,$00,$00
	dc.b	$0c,$7f,$00,$00,$0f,$c0,$00,$00
	dc.b	$ff,$e0,$00,$18,$00,$f8,$00,$00
	dc.b	$01,$fc,$02,$00,$02,$ff,$00,$00
	dc.b	'0',$00,$00,$00,$f0,$00,$00,$00
	dcb.w	4
	dc.b	$00,$03,$00,$00,$00,$03,$00,$00
	dc.b	$06,$07,$00,$00,$ff,$fc,$00,$00
	dc.b	$ff,$eb,$00,$00,$00,'?',$00,$00
	dcb.w	4
	dc.b	$00,'7',$00,$00,$00,'?',$00,$00
	dc.b	$8c,$0f,$00,$00,$8f,$f8,$00,$00
	dc.b	$f8,'p',$00,$00,'?',$f0,$00,$00
	dc.b	$03,$03,$00,$00,$03,$fe,$00,$00
	dc.b	$ff,$f5,$00,$00,$00,$1f,$00,$00
	dc.b	$80,'_',$00,$00,$80,$7f,$00,$00
	dcb.w	4
	dc.b	'0?',$00,$00,'?',$e0,$00,$00
	dc.b	$ff,'X',$00,$00,$01,$f8,$00,$00
	dc.b	$10,$ff,$00,$00,$1f,$80,$00,$00
	dc.b	$fc,',',$00,$00,$07,$fc,$00,$00
	dc.b	'0?',$00,$00,'?',$e0,$00,$00
	dc.b	$ff,'X',$00,$00,$01,$f8,$00,$00
	dc.b	$03,$a0,$00,$00,$03,$ff,$00,$00
	dc.b	$c0,$00,$00,$00,$c0,$00,$00,$00
	dcb.w	4
	dc.b	$00,$04,$00,$00,$00,$07,$00,$00
	dc.b	$08,$03,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$cb,$00,$00,$ff,$ff,$00,$00
	dcb.w	4
	dc.b	$00,$0f,$00,$00,$00,$0f,$00,$00
	dc.b	$10,$07,$00,$00,$1f,$ff,$00,$00
	dc.b	$c0,$c0,$00,$00,$ff,$c0,$00,$00
	dc.b	$04,$01,$00,$00,$07,$ff,$00,$00
	dc.b	$ff,$e5,$00,$00,$ff,$ff,$00,$00
	dc.b	$80,'A',$00,$00,$80,$7f,$00,$00
	dcb.w	4
	dc.b	'@',$1f,$00,$00,$7f,$ff,$00,$00
	dc.b	$fe,'X',$00,$00,$ff,$f8,$00,$00
	dc.b	$10,$7f,$00,$00,$1f,$ff,$00,$00
	dc.b	$f8,'.',$00,$00,$ff,$fe,$00,$00
	dc.b	'@',$1f,$00,$00,$7f,$ff,$00,$00
	dc.b	$fe,'X',$00,$00,$ff,$f8,$00,$00
	dc.b	$01,$93,$00,$00,$01,$ff,$00,$00
	dcb.w	8
	dc.b	$00,$04,$00,$00,$00,$07,$00,$00
	dc.b	$08,$00,$00,$00,$ff,$ff,$00,$00
	dc.b	$00,$0b,$00,$00,$ff,$ff,$00,$00
	dcb.w	4
	dc.b	$00,$02,$00,$00,$00,$02,$00,$00
	dc.b	$10,$00,$00,$00,$1f,$ff,$00,$00
	dc.b	$07,$00,$00,$00,$ff,$00,$00,$00
	dc.b	$04,$00,$00,$00,$07,$ff,$00,$00
	dc.b	$00,$05,$00,$00,$ff,$ff,$00,$00
	dc.b	$80,'?',$00,$00,$80,'?',$00,$00
	dcb.w	4
	dc.b	'@',$00,$00,$00,$7f,$ff,$00,$00
	dc.b	$00,'X',$00,$00,$ff,$f8,$00,$00
	dc.b	$10,$00,$00,$00,$1f,$ff,$00,$00
	dc.b	$00,'N',$00,$00,$ff,$fe,$00,$00
	dc.b	'@',$00,$00,$00,$7f,$ff,$00,$00
	dc.b	$00,'X',$00,$00,$ff,$f8,$00,$00
	dc.b	$01,$cc,$00,$00,$01,$fc,$00,$00
	dcb.w	8
	dc.b	$00,$04,$00,$00,$00,$07,$00,$00
	dc.b	$08,$00,$00,$00,$ff,$ff,$00,$00
	dc.b	$00,$1b,$00,$00,$ff,$ff,$00,$00
	dcb.w	8
	dc.b	$10,$00,$00,$00,$1f,$ff,$00,$00
	dc.b	'8',$00,$00,$00,$f8,$00,$00,$00
	dc.b	$04,$00,$00,$00,$07,$ff,$00,$00
	dc.b	$00,$0d,$00,$00,$ff,$ff,$00,$00
	dc.b	$80,'?',$00,$00,$80,'?',$00,$00
	dcb.w	4
	dc.b	'@',$00,$00,$00,$7f,$ff,$00,$00
	dc.b	$00,$d8,$00,$00,$ff,$f8,$00,$00
	dc.b	$10,$00,$00,$00,$1f,$ff,$00,$00
	dc.b	$00,$be,$00,$00,$ff,$fe,$00,$00
	dc.b	'@',$00,$00,$00,$7f,$ff,$00,$00
	dc.b	$00,$d8,$00,$00,$ff,$f8,$00,$00
	dc.b	$00,$f0,$00,$00,$00,$f0,$00,$00
	dcb.w	8
	dc.b	$00,$03,$00,$00,$00,$03,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$00
	dcb.w	8
	dc.b	$0f,$ff,$00,$00,$0f,$ff,$00,$00
	dc.b	$c0,$00,$00,$00,$c0,$00,$00,$00
	dc.b	$03,$ff,$00,$00,$03,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$00,$1e,$00,$00,$00,$1e,$00,$00
	dcb.w	4
	dc.b	'?',$ff,$00,$00,'?',$ff,$00,$00
	dc.b	$ff,$f0,$00,$00,$ff,$f0,$00,$00
	dc.b	$0f,$ff,$00,$00,$0f,$ff,$00,$00
	dc.b	$ff,$fc,$00,$00,$ff,$fc,$00,$00
	dc.b	'?',$ff,$00,$00,'?',$ff,$00,$00
	dc.b	$ff,$f0,$00,$00,$ff,$f0,$00,$00
	dc.b	$00,'@',$00,$00,$00,'@',$00,$00
	dcb.w	6
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
	dcb.w	14
l0056	dc.b	$1c,$f0,$1f,$00
l0057	dc.b	$1c,'8',$1f,$c0,$00,$00,$00,$00
	dc.b	$00,$01,$00,$00,$00,$00,$00,$00
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	10
	dc.b	$bd,$f0,$c2,$00,$80,$00,$ff,$f0
	dcb.w	32
l0058	dcb.w	2
l0059	dc.b	$00,$08,$00,$00,$00,$00,$00,$00
	dc.b	$00,$01,$00,$00,$00,$00,$00,$00
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dc.b	'AK',$81,$8c,$01,$08,$c1,$cf
	dc.b	$ac,$b4,'0',$d8,' ',$90,$bc,$fc
	dcb.w	28
l005a	dcb.w	2
l005b	dcb.w	2
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dc.b	$fd,$02,$ff,$fd,$fd,$00,$ff,$ff
	dc.b	$ff,$d0,$00,$00,$00,'/',$ff,$d0
	dc.b	$0b,$ff,$00,$00,$f4,$00,$0b,$ff
	dc.b	'@',$bf,$bf,$ff,$00,$bf,$ff,$ff
	dc.b	$80,$00,$80,$00,$80,$00,$80,$00
	dcb.w	16
	dc.b	$b9,'K',$c1,$8d,$81,$09,$f9,$cf
	dc.b	'TX',$98,'`',$10,'@',$dc,'x'
	dcb.w	30
	dc.b	$10,' ',$00,$00,$00,$00,$00,$00
	dc.b	$00,$01,$00,$00,$00,$00,$00,$00
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	10
	dc.b	$15,'J',$19,$8c,$11,$08,$1d,$ce
	dc.b	$14,'X',$18,'`',$10,'@',$1c,'x'
	dcb.w	68
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dc.b	'yJ',$81,$8c,$01,$08,$f9,$ce
	dc.b	'.',$b4,'0',$d8,' ',$90,'>',$fc
	dcb.w	144
	dc.b	$f8,$00,$f8,$00,$18,$00,$00,$00
	dcb.w	44
	dc.b	$00,$03,$00,$03,$00,$00,$00,$00
	dc.b	$f0,$00,$f0,$00,$f0,$00,$00,$00
	dc.b	$0f,$80,$0f,$80,$03,$80,$00,$00
	dcb.w	16
	dc.b	$00,'?',$00,'?',$00,$00,$00,$00
	dc.b	'/',$e0,$ff,$e0,'/',$e0,$00,$00
	dcb.w	8
	dc.b	$07,$e0,$07,$e0,$00,' ',$00,$00
	dc.b	$00,$fc,$00,$fc,$00,'<',$00,$00
	dcb.w	28
	dc.b	$00,'<',$00,'?',$00,$00,$00,$00
	dc.b	'?',$e0,$ff,$e0,'?',$e0,$00,$00
	dc.b	'1',$7f,'?',$ff,$01,$7f,$00,$00
	dc.b	$80,$00,$80,$00,$80,$00,$00,$00
	dc.b	$00,'~',$00,'~',$00,$06,$00,$00
	dcb.w	8
	dc.b	$0f,$f6,$0f,$ff,$00,$00,$00,$00
	dc.b	$1d,$bf,$ff,$ff,$1d,$bf,$00,$00
	dc.b	$80,$00,$80,$00,$80,$00,$00,$00
	dc.b	$00,$01,$00,$01,$00,$00,$00,$00
	dc.b	$f9,$bf,$ff,$ff,$00,'?',$00,$00
	dc.b	$07,'#',$07,$ff,$00,$03,$00,$00
	dc.b	$fe,$00,$fe,$00,$fe,$00,$00,$00
	dc.b	$01,$c0,$01,$c0,$00,'@',$00,$00
	dcb.w	20
	dc.b	$07,$d1,$07,$ff,$00,$01,$00,$00
	dc.b	'?',$bd,$ff,$fd,'?',$bc,$00,$00
	dc.b	$fc,$fa,$ff,$ff,$00,$fa,$00,$00
	dc.b	'|',$00,$fc,$00,'|',$00,$00,$00
	dc.b	$1f,$eb,$1f,$ff,$00,$0b,$00,$00
	dc.b	$e0,$00,$e0,$00,$e0,$00,$00,$00
	dc.b	$00,$03,$00,$03,$00,$00,$00,$00
	dc.b	$f5,$80,$ff,$ff,$00,$00,$00,$00
	dc.b	$b9,'f',$ff,$ff,$b9,'f',$00,$00
	dc.b	$fe,$00,$fe,$00,$fe,$00,$00,$00
	dc.b	$00,$fe,$00,$ff,$00,$00,$00,$00
	dc.b	$d3,$1b,$ff,$ff,$00,$1b,$00,$00
	dc.b	$ff,$06,$ff,$ff,$00,$06,$00,$00
	dc.b	$93,$f0,$ff,$f0,$93,$f0,$00,$00
	dc.b	$1f,$f8,$1f,$f8,$00,$f8,$00,$00
	dcb.w	20
	dc.b	$f9,$d0,$ff,$ff,$00,$00,$00,$00
	dc.b	$0d,$ae,$ff,$ff,$0d,$a0,$00,$00
	dc.b	'l',$12,$ff,$ff,$00,$12,$00,$00
	dc.b	'{',$07,$ff,$07,'{',$00,$00,$00
	dc.b	$ff,$87,$ff,$ff,$00,$07,$00,$00
	dc.b	$be,$00,$fe,$00,$be,$00,$00,$00
	dc.b	$00,$fc,$00,$ff,$00,$00,$00,$00
	dc.b	$88,'@',$ff,$ff,$00,$00,$00,$00
	dc.b	$00,'w',$ff,$ff,$00,'w',$00,$00
	dc.b	$d9,$e0,$ff,$e0,$d9,$e0,$00,$00
	dc.b	'?',$df,'?',$ff,$00,$00,$00,$00
	dc.b	$c0,$12,$ff,$ff,$00,$12,$00,$00
	dc.b	$f0,'@',$ff,$ff,$00,$00,$00,$00
	dc.b	$88,$88,$ff,$f8,$88,$88,$00,$00
	dc.b	$fa,'^',$ff,$fe,$00,'^',$00,$00
	dcb.w	16
	dc.b	$00,$0f,$00,$0f,$00,$00,$00,$00
	dc.b	'.',$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$01,$f3,$ff,$ff,$01,$c0,$00,$00
	dc.b	$c0,$08,$ff,$ff,$00,$08,$00,$00
	dc.b	$be,$fb,$ff,$ff,$be,$c0,$00,$00
	dc.b	$c4,$06,$ff,$ff,$00,$06,$00,$00
	dc.b	$bb,$f0,$ff,$f0,$bb,$f0,$00,$00
	dc.b	'?',$97,'?',$ff,$00,$00,$00,$00
	dc.b	$f0,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	'}?',$ff,$ff,'}?',$00,$00
	dc.b	$c5,'~',$ff,$ff,$00,$00,$00,$00
	dc.b	$80,$07,$ff,$ff,$00,$00,$00,$00
	dc.b	$ae,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$0d,$b7,$ff,$ff,$0d,$b4,$00,$00
	dc.b	')',$0e,$ff,$fe,$00,$0e,$00,$00
	dcb.w	16
	dc.b	$01,$f5,$01,$ff,$00,$00,$00,$00
	dc.b	$e3,$80,$ff,$ff,$00,$00,$00,$00
	dc.b	$01,$dc,$ff,$ff,$00,$00,$00,$00
	dc.b	$c0,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	'V',$b8,$ff,$ff,'V',$b8,$00,$00
	dc.b	$00,$02,$ff,$ff,$00,$02,$00,$00
	dc.b	$ef,$bf,$ff,$ff,$ef,$b8,$00,$00
	dc.b	$d9,$be,$ff,$ff,$00,$00,$00,$00
	dc.b	'`',$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$0f,$ff,$ff,$00,$0f,$00,$00
	dc.b	$00,'[',$ff,$ff,$00,'[',$00,$00
	dc.b	$e4,$e8,$ff,$ff,$e0,$00,$00,$00
	dc.b	$00,$1f,$ff,$ff,$00,$00,$00,$00
	dc.b	$e0,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$04,':',$ff,$ff,$04,':',$00,$00
	dc.b	$e4,'/',$ff,$ff,$00,'/',$00,$00
	dcb.w	16
	dc.b	$1e,'E',$1f,$ff,$00,$00,$00,$00
	dc.b	$b0,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$07,$fa,$ff,$ff,$00,$00,$00,$00
	dc.b	$80,$03,$ff,$ff,$00,$03,$00,$00
	dc.b	'@n',$ff,$ff,'@n',$00,$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	'3d',$ff,$ff,'3`',$00,$00
	dc.b	$ff,$0c,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	'2O',$ff,$ff,'2O',$00,$00
	dc.b	$de,$00,$ff,$ff,$de,$00,$00,$00
	dc.b	$00,$ee,$ff,$ff,$00,$00,$00,$00
	dc.b	$10,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$09,$ff,$ff,$00,$09,$00,$00
	dc.b	'R',$03,$ff,$ff,$00,$03,$00,$00
	dcb.w	16
	dc.b	$e2,'1',$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$1a,'F',$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	')q',$ff,$ff,')q',$00,$00
	dc.b	$c0,$00,$ff,$ff,$c0,$00,$00,$00
	dc.b	$02,$06,$ff,$ff,$02,$00,$00,$00
	dc.b	$00,$f0,$ff,$ff,$00,$00,$00,$00
	dc.b	'@',$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$10,$ff,$ff,$00,$10,$00,$00
	dc.b	$99,$c0,$ff,$ff,$99,$c0,$00,$00
	dc.b	$03,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	' ',$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	'@',$01,$ff,$ff,$00,$01,$00,$00
	dcb.w	78
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dcb.w	76
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	76
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	51
	dc.b	$10,$00,$00,$00,$10,$00,$00,$00
	dcb.w	21
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	40
	dc.b	' ',$08,$00,$00,$00,$00,$00,$00
	dc.b	' ',$08,$00,$00,$10,$00,$00,$00
	dc.b	' ',$08,$10,$00,$10,$00,$00,$00
	dc.b	' ',$08,$10,$00,$00,$00,$00,$00
	dcb.w	20
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	40
	dc.b	'@',$04,$00,$00,$10,$00,$00,$00
	dc.b	'P',$04,$00,$00,$10,$00,$00,$00
	dc.b	'P',$04,$00,$00,$10,$00,$00,$00
	dc.b	'P',$04,$00,$00,$00,$00,$00,$00
	dcb.w	20
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	40
	dc.b	$10,$10,$00,$00,'(',$00,$00,$00
	dc.b	'8',$10,$00,$00,'l',$00,$00,$00
	dc.b	'8',$10,'D',$00,'l',$00,$82,$00
	dc.b	'8',$10,$c6,$00,$00,$00,$00,$00
	dcb.w	20
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	40
	dc.b	$16,$d0,$00,$00,$10,$00,$00,$00
	dc.b	$16,$d0,$00,$00,$10,$00,$00,$00
	dc.b	$16,$d0,$00,$00,$10,$00,$00,$00
	dc.b	$16,$d0,$00,$00,$00,$00,$00,$00
	dcb.w	20
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	40
	dc.b	$16,$d0,$00,$00,$00,$00,$00,$00
	dc.b	$16,$d0,$00,$00,$10,$00,$00,$00
	dc.b	$06,$d0,$10,$00,$10,$00,$00,$00
	dc.b	$06,$d0,$10,$00,$00,$00,$00,$00
	dcb.w	20
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	51
	dc.b	$10,$00,$00,$00,$10,$00,$00,$00
	dcb.w	21
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	40
	dc.b	$16,$d0,$00,$00,$00,$00,$00,$00
	dc.b	$16,$d0,$00,$00,$00,$00,$00,$00
	dc.b	$16,$d0,$00,$00,$00,$00,$00,$00
	dc.b	$16,$d0,$00,$00,$00,$00,$00,$00
	dcb.w	20
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	28
	dc.b	$18,'0',$00,$00,$00,$00,$00,$00
	dc.b	$18,'0',$00,$00,$00,$00,$00,$00
	dc.b	$18,'0',$00,$00,$00,$00,$00,$00
	dc.b	$16,$d0,$00,$00,$00,$00,$00,$00
	dc.b	$16,$d0,$00,$00,$00,$00,$00,$00
	dc.b	$16,$d0,$00,$00,$00,$00,$00,$00
	dc.b	$16,$d0,$00,$00,$00,$00,$00,$00
	dcb.w	20
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	24
	dc.b	'<x',$00,$00,$00,$00,$00,$00
	dc.b	'<x',$00,$00,$00,$00,$00,$00
	dc.b	'<x',$00,$00,$00,$00,$00,$00
	dc.b	'<x',$00,$00,$00,$00,$00,$00
	dc.b	$06,$c0,$00,$00,$00,$00,$00,$00
	dc.b	$06,$c0,$00,$00,$00,$00,$00,$00
	dc.b	$06,$c0,$00,$00,$00,$00,$00,$00
	dc.b	$06,$c0,$00,$00,$00,$00,$00,$00
	dcb.w	20
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	20
	dc.b	'<x',$00,$00,$00,$00,$00,$00
	dc.b	'<x',$00,$00,$00,$00,$00,$00
	dc.b	'<x',$00,$00,$00,$00,$00,$00
	dc.b	'<x',$00,$00,$00,$00,$00,$00
	dc.b	'<x',$00,$00,$00,$00,$00,$00
	dcb.w	28
	dc.b	'<',$00,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	16
	dc.b	'4X',$00,$00,$00,$00,$00,$00
	dc.b	'4h',$00,$00,$00,$00,$00,$00
	dc.b	'4h',$00,$00,$00,$00,$00,$00
	dc.b	'4h',$00,$00,$00,$00,$00,$00
	dc.b	'4X',$00,$00,$00,$00,$00,$00
	dc.b	',X',$00,$00,$00,$00,$00,$00
	dcb.w	20
	dc.b	'<x',$00,$00,$00,$00,$00,$00
	dc.b	'<',$00,$00,$00,$00,$00,$00,$00
	dcb.w	8
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	16
	dc.b	$18,'0',$00,$00,$00,$00,$00,$00
	dc.b	$18,'0',$00,$00,$00,$00,$00,$00
	dc.b	$18,'0',$00,$00,$00,$00,$00,$00
	dc.b	$18,'0',$00,$00,$00,$00,$00,$00
	dc.b	$18,'0',$00,$00,$00,$00,$00,$00
	dc.b	$18,'0',$00,$00,$00,$00,$00,$00
	dcb.w	16
	dc.b	'<x',$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$00,'x',$00,$00,$00,$00,$00,$00
	dc.b	$00,'x',$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dcb.w	32
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dcb.w	76
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	76
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	$1f,$80,$00,$00,$1f,$80,$1f,$80
	dcb.w	66
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	$7f,$e0,$00,$00,$7f,$e0,$7f,$e0
	dcb.w	66
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	$fc,'0',$00,$00,$ff,$f0,$ff,$f0
	dcb.w	66
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	$f0,$10,$00,$00,$ff,$f0,$ff,$f0
	dcb.w	66
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$01,$00,$00,$00,$01,$00,$01
	dc.b	$f9,$d8,$00,$00,$ff,$f8,$ff,$f8
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dcb.w	58
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$01,$00,$00,$00,$01,$00,$01
	dc.b	$cf,$c8,$00,$00,$ff,$f8,$ff,$f8
	dc.b	$80,$00,$00,$00,$00,$80,$00,$00
	dc.b	'@',$01,$00,$00,$00,$01,$00,$01
	dc.b	$f8,$01,$00,$00,$f8,$01,$f8,$01
	dc.b	$f8,$03,$00,$00,$f8,$03,$f8,$03
	dc.b	$e0,$00,$00,$00,$e0,$00,$e0,$00
	dc.b	'`',$00,$00,$00,'`',$00,'`',$00
	dc.b	$c0,$01,$00,$00,$c0,$01,$c0,$01
	dc.b	$80,$01,$00,$00,$80,$01,$80,$01
	dc.b	$f0,$07,$00,$00,$f0,$07,$f0,$07
	dc.b	$e0,$07,$00,$00,$e0,$07,$e0,$07
	dc.b	$e0,$07,$00,$00,$e0,$07,$e0,$07
	dc.b	$e0,$00,$00,$00,$e0,$00,$e0,$00
	dcb.w	18
	dc.b	$80,$01,$00,$00,$01,'`',$00,$00
	dc.b	$02,$00,$00,$00,$00,$01,$00,$00
	dc.b	$00,$01,$00,$01,$98,$c8,$00,$00
	dc.b	$ff,$f8,$ff,$f8,$80,$00,$00,$00
	dc.b	$00,$a0,$00,$00,'@',$06,$00,$00
	dc.b	$00,$07,$00,$07,$06,$06,$00,$00
	dc.b	$fe,$07,$fe,$07,$06,$0c,$00,$00
	dc.b	$fe,$0f,$fe,$0f,'<',$00,$00,$00
	dc.b	$fc,$00,$fc,$00,$d0,$1d,$00,$00
	dc.b	$f0,$1d,$f0,$1d,$ee,$02,$00,$00
	dc.b	$ee,$03,$ee,$03,$c0,$0f,$00,$00
	dc.b	$c0,$0f,$c0,$0f,$0c,$18,$00,$00
	dc.b	$fc,$1f,$fc,$1f,'8',$18,$00,$00
	dc.b	$f8,$1f,$f8,$1f,$18,$18,$00,$00
	dc.b	$f8,$1f,$f8,$1f,$18,$00,$00,$00
	dc.b	$f8,$00,$f8,$00,$00,$00,$00,$00
	dcb.w	16
	dc.b	$80,$01,$00,$00,$0f,'p',$00,$88
	dc.b	$00,$88,$00,$00,$00,$01,$00,$00
	dc.b	$00,$01,$00,$01,$ac,$08,$00,$00
	dc.b	$ff,$f8,$ff,$f8,$80,$00,$00,$00
	dc.b	$01,' ',$00,$00,'@',$08,$00,$00
	dc.b	$00,$0f,$00,$0f,$01,$0c,$00,$00
	dc.b	$ff,$0f,$ff,$0f,$01,$10,$00,$00
	dc.b	$ff,$1f,$ff,$1f,$02,$07,$00,$00
	dc.b	$fe,$07,$fe,$07,$88,$27,$00,$00
	dc.b	$f8,'?',$f8,'?9',$04,$00,$00
	dc.b	$ff,$07,$ff,$07,'x',$10,$00,$00
	dc.b	$f8,$1f,$f8,$1f,$02,'0',$00,$00
	dc.b	$fe,'?',$fe,'?',$0c,'&',$00,$00
	dc.b	$fc,'?',$fc,'?',$04,'1',$00,$00
	dc.b	$fc,'?',$fc,'?',$84,$00,$00,$00
	dc.b	$fc,$00,$fc,$00,$00,$00,$00,$00
	dcb.w	16
	dc.b	$80,$01,$00,$00,'>8',$01,'F'
	dc.b	$01,'F',$00,$00,$00,$01,$00,$00
	dc.b	$00,$01,$00,$01,$a7,$18,$00,$00
	dc.b	$ff,$f8,$ff,$f8,$80,$00,$00,$00
	dc.b	$01,'@',$00,$00,'@',$10,$00,$00
	dc.b	$00,$1f,$00,$1f,$00,$88,$00,$00
	dc.b	$ff,$8f,$ff,$8f,$01,$1f,$00,$00
	dc.b	$ff,$1f,$ff,$1f,$01,$0c,$00,$00
	dc.b	$ff,$0f,$ff,$0f,$cc,'"',$00,$00
	dc.b	$fc,'?',$fc,'?',$11,$0c,$00,$00
	dc.b	$ff,$0f,$ff,$0f,$cc,' ',$00,$00
	dc.b	$fc,'?',$fc,'?> ',$00,$00
	dc.b	$fe,'?',$fe,'?',$04,'C',$00,$00
	dc.b	$fc,$7f,$fc,$7f,$82,'1',$00,$00
	dc.b	$fe,'?',$fe,'?',$84,$00,$00,$00
	dc.b	$fc,$00,$fc,$00,$00,$00,$00,$00
	dcb.w	16
	dc.b	$80,$01,$00,$00,$0c,'0',$02,$08
	dc.b	$02,$08,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	'e',$f0,$00,$00,$7f,$f0,$7f,$f0
	dc.b	$80,$00,$00,$00,$02,'@',$00,$00
	dc.b	'@',$10,$00,$00,$00,$1f,$00,$1f
	dc.b	$00,$98,$00,$00,$ff,$9f,$ff,$9f
	dc.b	$00,$8f,$00,$00,$ff,$8f,$ff,$8f
	dc.b	$00,$8c,$00,$00,$ff,$8f,$ff,$8f
	dc.b	'F`',$00,$00,$fe,$7f,$fe,$7f
	dc.b	$01,$98,$00,$00,$ff,$9f,$ff,$9f
	dc.b	$8c,'@',$00,$00,$fc,$7f,$fc,$7f
	dc.b	'<`',$00,$00,$fc,$7f,$fc,$7f
	dc.b	$06,'C',$00,$00,$fe,$7f,$fe,$7f
	dc.b	$c2,'y',$00,$00,$fe,$7f,$fe,$7f
	dc.b	$a2,$00,$00,$00,$fe,$00,$fe,$00
	dcb.w	18
	dc.b	$80,$01,$00,$00,$07,'@',$00,'0'
	dc.b	$00,'0',$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	'f`',$00,$00,$7f,$e0,$7f,$e0
	dc.b	$80,$00,$00,$00,$02,$a0,$00,$00
	dc.b	'@ ',$00,$00,$00,'?',$00,'?'
	dc.b	$00,'P',$00,$00,$ff,$df,$ff,$df
	dc.b	$00,$9c,$00,$00,$ff,$9f,$ff,$9f
	dc.b	$00,$b6,$00,$00,$ff,$bf,$ff,$bf
	dc.b	$03,'@',$00,$00,$ff,$7f,$ff,$7f
	dc.b	$01,$b0,$00,$00,$ff,$bf,$ff,$bf
	dc.b	$1b,'@',$00,$00,$ff,$7f,$ff,$7f
	dc.b	$0e,'@',$00,$00,$fe,$7f,$fe,$7f
	dc.b	$02,$b0,$00,$00,$fe,$ff,$fe,$ff
	dc.b	'Yl',$00,$00,$ff,$7f,$ff,$7f
	dc.b	$c2,$00,$00,$00,$fe,$00,$fe,$00
	dcb.w	18
	dc.b	$80,$01,$00,$00,$01,$00,$00,$c0
	dc.b	$00,$c0,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	'~@',$00,$00,$7f,$c0,$7f,$c0
	dc.b	$80,$00,$00,$00,$04,$90,$00,$00
	dc.b	'@ ',$00,$00,$00,'?',$00,'?'
	dc.b	$00,'P',$00,$00,$ff,$df,$ff,$df
	dc.b	$00,$b0,$00,$00,$ff,$bf,$ff,$bf
	dc.b	$00,$a2,$00,$00,$ff,$bf,$ff,$bf
	dc.b	$01,'@',$00,$00,$ff,$7f,$ff,$7f
	dc.b	$01,$a0,$00,$00,$ff,$bf,$ff,$bf
	dc.b	$11,'@',$00,$00,$ff,$7f,$ff,$7f
	dc.b	$03,'@',$00,$00,$ff,$7f,$ff,$7f
	dc.b	$02,$9f,$00,$00,$fe,$ff,$fe,$ff
	dc.b	$f5,'G',$00,$00,$ff,$7f,$ff,$7f
	dc.b	$c2,$00,$00,$00,$fe,$00,$fe,$00
	dcb.w	18
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	'6@',$00,$00,'7',$c0,'7',$c0
	dc.b	$80,$00,$00,$00,$05,$10,$00,$00
	dc.b	'@0',$00,$00,$00,'?',$00,'?'
	dc.b	$00,$d6,$00,$00,$ff,$df,$ff,$df
	dc.b	$01,$be,$00,$00,$ff,$bf,$ff,$bf
	dc.b	$00,$a0,$00,$00,$ff,$bf,$ff,$bf
	dc.b	$01,'@',$00,$00,$ff,$7f,$ff,$7f
	dc.b	$01,$a0,$00,$00,$ff,$bf,$ff,$bf
	dc.b	$01,'@',$00,$00,$ff,$7f,$ff,$7f
	dc.b	$1f,'`',$00,$00,$ff,$7f,$ff,$7f
	dc.b	'6',$cf,$00,$00,$fe,$ff,$fe,$ff
	dc.b	$b3,']',$00,$00,$ff,$7f,$ff,$7f
	dc.b	$c6,$00,$00,$00,$fe,$00,$fe,$00
	dcb.w	18
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	$03,$80,$00,$00,$03,$80,$03,$80
	dc.b	$80,$00,$00,$00,$09,$e8,$00,$00
	dc.b	'@0',$00,$00,$00,'?',$00,'?'
	dc.b	$00,$de,$00,$00,$ff,$df,$ff,$df
	dc.b	$03,$9f,$00,$00,$ff,$9f,$ff,$9f
	dc.b	$01,$b0,$00,$00,$ff,$bf,$ff,$bf
	dc.b	$01,' ',$00,$00,$ff,'?',$ff,'?'
	dc.b	$03,' ',$00,$00,$ff,'?',$ff,'?'
	dc.b	$03,'@',$00,$00,$ff,$7f,$ff,$7f
	dc.b	'>p',$00,$00,$fe,$7f,$fe,$7f
	dc.b	$1e,$cc,$00,$00,$fe,$ff,$fe,$ff
	dc.b	'3y',$00,$00,$ff,$7f,$ff,$7f
	dc.b	'.',$00,$00,$00,$fe,$00,$fe,$00
	dcb.w	4
	dc.b	$18,$00,$00,$00,$18,$00,$00,$00
	dc.b	$00,'`',$00,$00,$00,'`',$00,$00
	dcb.w	6
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dcb.w	10
	dc.b	$80,$00,$00,$00,$08,'(',$00,$00
	dc.b	'@',$1b,$00,$00,$00,$1f,$00,$1f
	dc.b	$0d,$86,$00,$00,$ff,$87,$ff,$87
	dc.b	$cf,$07,$00,$00,$ff,$07,$ff,$07
	dc.b	$03,$98,$00,$00,$ff,$9f,$ff,$9f
	dc.b	$03,'0',$00,$00,$ff,'?',$ff,'?'
	dc.b	$03,'0',$00,$00,$ff,'?',$ff,'?'
	dc.b	$06,'`',$00,$00,$fe,$7f,$fe,$7f
	dc.b	'89',$00,$00,$f8,'?',$f8,'?'
	dc.b	$98,'n',$00,$00,$f8,$7f,$f8,$7f
	dc.b	'v',$1b,$00,$00,$fe,$1f,$fe,$1f
	dc.b	'<',$00,$00,$00,$fc,$00,$fc,$00
	dcb.w	4
	dc.b	'4',$00,$00,$00,'<',$00,$00,$00
	dc.b	$00,$b0,$00,$00,$00,$f0,$00,$00
	dcb.w	6
	dc.b	$80,$01,$00,$00,$01,'`',$00,$00
	dc.b	$02,$00,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$03,$80,$00,$00,$03,$80,$03,$80
	dc.b	$80,$00,$00,$00,$10,'D',$00,$00
	dc.b	'@',$1f,$00,$00,$00,$1f,$00,$1f
	dc.b	$ff,$86,$00,$00,$ff,$87,$ff,$87
	dc.b	$ce,$0e,$00,$00,$fe,$0f,$fe,$0f
	dc.b	$07,$0c,$00,$00,$ff,$0f,$ff,$0f
	dc.b	$02,$1c,$00,$00,$fe,$1f,$fe,$1f
	dc.b	$0e,$10,$00,$00,$fe,$1f,$fe,$1f
	dc.b	$0c,'0',$00,$00,$fc,'?',$fc,'?'
	dc.b	$1c,$19,$00,$00,$fc,$1f,$fc,$1f
	dc.b	$f8,$7f,$00,$00,$f8,$7f,$f8,$7f
	dc.b	$fe,$1b,$00,$00,$fe,$1f,$fe,$1f
	dc.b	'8',$00,$00,$00,$f8,$00,$f8,$00
	dcb.w	4
	dc.b	'4',$00,$00,$00,'<',$00,$00,$00
	dc.b	$00,$b0,$00,$00,$00,$f0,$00,$00
	dcb.w	6
	dc.b	$80,$01,$00,$00,$0f,$f0,$00,$08
	dc.b	$00,$08,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	'7',$c0,$00,$00,'7',$c0,'7',$c0
	dc.b	$80,$00,$00,$00,$1f,'\',$00,$00
	dc.b	'@',$0e,$00,$00,$00,$0e,$00,$0e
	dc.b	$f7,$07,$00,$00,$f7,$07,$f7,$07
	dc.b	$ec,$0f,$00,$00,$fc,$0f,$fc,$0f
	dc.b	$fe,$06,$00,$00,$fe,$07,$fe,$07
	dc.b	$0c,$0f,$00,$00,$fc,$0f,$fc,$0f
	dc.b	$fc,$0c,$00,$00,$fc,$0f,$fc,$0f
	dc.b	$18,$18,$00,$00,$f8,$1f,$f8,$1f
	dc.b	'<',$0f,$00,$00,$fc,$0f,$fc,$0f
	dc.b	$f8,';',$00,$00,$f8,';',$f8,';'
	dc.b	$dc,$1f,$00,$00,$dc,$1f,$dc,$1f
	dc.b	$b0,$00,$00,$00,$f0,$00,$f0,$00
	dcb.w	4
	dc.b	'4',$00,$00,$00,'<',$00,$00,$00
	dc.b	$00,$b0,$00,$00,$00,$f0,$00,$00
	dcb.w	6
	dc.b	$80,$01,$00,$00,'?8',$00,$c6
	dc.b	$00,$c6,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	'~',$c0,$00,$00,$7f,$c0,$7f,$c0
	dc.b	$80,$00,$00,$00,$00,$80,$00,$00
	dc.b	'@',$00,$00,$00,$00,$00,$00,$00
	dc.b	'`',$03,$00,$00,'`',$03,'`',$03
	dc.b	'|',$07,$00,$00,'|',$07,'|',$07
	dc.b	$f8,$03,$00,$00,$f8,$03,$f8,$03
	dc.b	'8',$03,$00,$00,$f8,$03,$f8,$03
	dc.b	$f0,$07,$00,$00,$f0,$07,$f0,$07
	dc.b	'0',$07,$00,$00,$f0,$07,$f0,$07
	dc.b	$f8,$0f,$00,$00,$f8,$0f,$f8,$0f
	dc.b	$b0,$01,$00,$00,$b0,$01,$b0,$01
	dc.b	$80,$0d,$00,$00,$80,$0d,$80,$0d
	dc.b	$f0,$00,$00,$00,$f0,$00,$f0,$00
	dcb.w	4
	dc.b	'2',$00,$00,$00,'>',$00,$00,$00
	dc.b	$01,'0',$00,$00,$01,$f0,$00,$00
	dcb.w	6
	dc.b	$80,$01,$00,$00,$0e,'p',$01,$08
	dc.b	$01,$08,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	'l',$e0,$00,$00,$7f,$e0,$7f,$e0
	dc.b	$80,$00,$00,$00,$00,$80,$00,$00
	dc.b	'@',$00,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	'8',$00,$00,$00,'8',$00,'8',$00
	dc.b	$00,$01,$00,$00,$00,$01,$00,$01
	dc.b	$e0,$00,$00,$00,$e0,$00,$e0,$00
	dc.b	$00,$01,$00,$00,$00,$01,$00,$01
	dc.b	$e0,$00,$00,$00,$e0,$00,$e0,$00
	dc.b	$00,$07,$00,$00,$00,$07,$00,$07
	dcb.w	8
	dc.b	$e0,$00,$00,$00,$e0,$00,$e0,$00
	dcb.w	4
	dc.b	'1',$00,$00,$00,'?',$00,$00,$00
	dc.b	$02,'0',$00,$00,$03,$f0,$00,$00
	dcb.w	6
	dc.b	$80,$01,$00,$00,$07,'@',$00,'0'
	dc.b	$00,$b0,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	'l',$f0,$00,$00,$7f,$f0,$7f,$f0
	dc.b	$80,$00,$00,$00,$01,$00,$00,$00
	dc.b	'@',$00,$00,$00,$00,$00,$00,$00
	dcb.w	40
	dc.b	$01,$ff,$00,$00,$01,$ff,$00,$00
	dc.b	$e9,$80,$00,$00,$ff,$80,$00,$00
	dc.b	$06,'_',$00,$00,$07,$ff,$00,$00
	dc.b	$fe,$00,$00,$00,$fe,$00,$00,$00
	dcb.w	2
	dc.b	$80,$01,$00,$00,$01,$00,$00,$c0
	dc.b	$00,$c0,$00,$00,$00,$01,$00,$00
	dc.b	$00,$01,$00,$01,$e4,$b8,$00,$00
	dc.b	$ff,$f8,$ff,$f8,$80,$00,$00,$00
	dc.b	$01,$00,$00,$00,'@',$00,$00,$00
	dcb.w	42
	dc.b	$0f,$ff,$00,$00,$0f,$ff,$00,$00
	dc.b	$c4,$c0,$00,$00,$ff,$c0,$00,$00
	dc.b	$0c,$8f,$00,$00,$0f,$ff,$00,$00
	dc.b	$ff,$c0,$00,$00,$ff,$c0,$00,$00
	dcb.w	2
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$01,$00,$00,$00,$01,$00,$01
	dc.b	'w',$18,$00,$00,$ff,$f8,$ff,$f8
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dcb.w	40
	dc.b	$1c,$0f,$00,$00,$1f,$ff,$00,$00
	dc.b	$00,'@',$00,$00,$ff,$c0,$00,$00
	dc.b	$08,$03,$00,$00,$0f,$ff,$00,$00
	dc.b	$c0,$e0,$00,$00,$ff,$e0,$00,$00
	dcb.w	2
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$01,$00,$00,$00,$01,$00,$01
	dc.b	$1f,$08,$00,$00,$ff,$f8,$ff,$f8
	dcb.w	48
	dc.b	$1b,$f0,$00,$00,$1f,$ff,$00,$00
	dc.b	$00,'@',$00,$00,$ff,$c0,$00,$00
	dc.b	$08,$00,$00,$00,$0f,$ff,$00,$00
	dc.b	'?`',$00,$00,$ff,$e0,$00,$00
	dcb.w	2
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$01,$00,$00,$00,$01,$00,$01
	dc.b	$b3,$08,$00,$00,$ff,$f8,$ff,$f8
	dcb.w	48
	dc.b	'0',$1f,$00,$00,'?',$ff,$00,$00
	dc.b	$00,'@',$00,$00,$ff,$c0,$00,$00
	dc.b	$08,$03,$00,$00,$0f,$ff,$00,$00
	dc.b	$e0,'0',$00,$00,$ff,$f0,$00,$00
	dcb.w	2
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$01,$00,$00,$00,$01,$00,$01
	dc.b	$e6,$88,$00,$00,$ff,$f8,$ff,$f8
	dcb.w	48
	dc.b	'>',$00,$00,$00,'?',$ff,$00,$00
	dc.b	$00,'@',$00,$00,$ff,$c0,$00,$00
	dc.b	$08,$00,$00,$00,$0f,$ff,$00,$00
	dc.b	$01,$f0,$00,$00,$ff,$f0,$00,$00
	dcb.w	2
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	$c6,$10,$00,$00,$ff,$f0,$ff,$f0
	dcb.w	8
	dc.b	$0f,$80,$00,$00,$0f,$80,$0f,$80
	dc.b	$01,$c0,$00,$00,$01,$c0,$01,$c0
	dc.b	$03,$00,$00,$00,$03,$00,$03,$00
	dc.b	$00,$c0,$00,$00,$00,$c0,$00,$c0
	dc.b	$03,$80,$00,$00,$03,$80,$03,$80
	dc.b	$01,$f0,$00,$00,$01,$f0,$01,$f0
	dc.b	$07,$e0,$00,$00,$07,$e0,$07,$e0
	dc.b	$07,$e0,$00,$00,$07,$e0,$07,$e0
	dcb.w	8
	dc.b	$11,$c0,$00,$00,$1f,$ff,$00,$00
	dc.b	$00,'@',$00,$00,$ff,$c0,$00,$00
	dc.b	$08,$00,$00,$00,$0f,$ff,$00,$00
	dc.b	$0e,' ',$00,$00,$ff,$e0,$00,$00
	dcb.w	2
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	$c6,$10,$00,$00,$ff,$f0,$ff,$f0
	dcb.w	8
	dc.b	'1',$f0,$00,$00,'?',$f0,'?',$f0
	dc.b	$1b,' ',$00,$00,$1b,$e0,$1b,$e0
	dc.b	'w',$b8,$00,$00,'w',$b8,'w',$b8
	dc.b	$1d,$ee,$00,$00,$1d,$ee,$1d,$ee
	dc.b	$04,$d8,$00,$00,$07,$d8,$07,$d8
	dc.b	$0f,$8c,$00,$00,$0f,$fc,$0f,$fc
	dc.b	$18,$18,$00,$00,$1f,$f8,$1f,$f8
	dc.b	$18,$18,$00,$00,$1f,$f8,$1f,$f8
	dcb.w	8
	dc.b	$08,'<',$00,$00,$0f,$ff,$00,$00
	dc.b	$00,$80,$00,$00,$ff,$80,$00,$00
	dc.b	$04,$00,$00,$00,$07,$ff,$00,$00
	dc.b	$f0,'@',$00,$00,$ff,$c0,$00,$00
	dcb.w	2
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	$00,$0f,$00,$00,$00,$00,$00,$00
	dc.b	$c0,$00,$00,$00,'``',$00,$00
	dc.b	$7f,$e0,$7f,$e0,$00,$00,$00,$00
	dcb.w	6
	dc.b	'B',$18,$00,$00,$7f,$f8,$7f,$f8
	dc.b	'? ',$00,$00,'?',$e0,'?',$e0
	dc.b	$9c,$e4,$00,$00,$ff,$fc,$ff,$fc
	dc.b	$27,'9',$00,$00,'?',$ff,'?',$ff
	dc.b	$04,$fc,$00,$00,$07,$fc,$07,$fc
	dc.b	$18,'B',$00,$00,$1f,$fe,$1f,$fe
	dc.b	'!',$8c,$00,$00,'?',$fc,'?',$fc
	dc.b	' d',$00,$00,'?',$fc,'?',$fc
	dcb.w	8
	dc.b	$07,$00,$00,$00,$07,$ff,$00,$00
	dc.b	$01,$00,$00,$00,$ff,$00,$00,$00
	dc.b	$02,$00,$00,$00,$03,$ff,$00,$00
	dc.b	$03,$80,$00,$00,$ff,$80,$00,$00
	dcb.w	2
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$80,$00,$00,$00,$1f,$80,$00,$00
	dc.b	$1f,$80,$1f,$80,$00,$00,$00,$00
	dcb.w	6
	dc.b	'~',$14,$00,$00,$7f,$fc,$7f,$fc
	dc.b	'30',$00,$00,'?',$f0,'?',$f0
	dc.b	$88,'D',$00,$00,$ff,$fc,$ff,$fc
	dc.b	'"',$11,$00,$00,'?',$ff,'?',$ff
	dc.b	$0c,$cc,$00,$00,$0f,$fc,$0f,$fc
	dc.b	'(~',$00,$00,'?',$fe,'?',$fe
	dc.b	'!',$8c,$00,$00,'?',$fc,'?',$fc
	dc.b	'A',$c2,$00,$00,$7f,$fe,$7f,$fe
	dcb.w	8
	dc.b	$00,$f0,$00,$00,$00,$ff,$00,$00
	dc.b	$1e,$00,$00,$00,$fe,$00,$00,$00
	dc.b	$01,$e0,$00,$00,$01,$ff,$00,$00
	dc.b	'<',$00,$00,$00,$fc,$00,$00,$00
	dcb.w	2
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$00,$01,$00,$00,$00,$00,$00,$00
	dcb.w	14
	dc.b	'>r',$00,$00,'?',$fe,'?',$fe
	dc.b	'2',$f9,$00,$00,'?',$f9,'?',$f9
	dc.b	$cf,$e6,$00,$00,$ff,$fe,$ff,$fe
	dc.b	'g',$f3,$00,$00,$7f,$ff,$7f,$ff
	dc.b	$9f,'L',$00,$00,$9f,$fc,$9f,$fc
	dc.b	'N|',$00,$00,$7f,$fc,$7f,$fc
	dc.b	'E',$9e,$00,$00,$7f,$fe,$7f,$fe
	dc.b	'C',$c2,$00,$00,$7f,$fe,$7f,$fe
	dcb.w	8
	dc.b	$00,$0f,$00,$00,$00,$0f,$00,$00
	dc.b	$f0,$00,$00,$00,$f0,$00,$00,$00
	dc.b	$00,'?',$00,$00,$00,'?',$00,$00
	dc.b	$c0,$00,$00,$00,$c0,$00,$00,$00
	dcb.w	2
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dc.b	$01,$f2,$00,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	$00,$0f,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$fc,$00,$00,$00,$00,$00,$00
	dc.b	'rb',$00,$00,$7f,$fe,$7f,$fe
	dc.b	$d3,$8d,$00,$00,$ff,$fd,$ff,$fd
	dc.b	'h',$1e,$00,$00,$ff,$fe,$ff,$fe
	dc.b	'x',$16,$00,$00,$7f,$ff,$7f,$ff
	dc.b	$b1,$cb,$00,$00,$bf,$ff,$bf,$ff
	dc.b	'FN',$00,$00,$7f,$fe,$7f,$fe
	dc.b	'C6',$00,$00,$7f,$fe,$7f,$fe
	dc.b	$9a,$0d,$00,$00,$ff,$ff,$ff,$ff
	dcb.w	26
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	$00,'$',$00,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	$00,$08,$00,$00,$00,$00,$00,$00
	dc.b	$08,$04,$08,$00,$00,$00,$00,$00
	dc.b	$c3,'R',$00,$00,$ff,$fe,$ff,$fe
	dc.b	$d6,$05,$00,$00,$ff,$fd,$ff,$fd
	dc.b	'?',$8e,$00,$00,$ff,$fe,$ff,$fe
	dc.b	'q',$fc,$00,$00,$7f,$ff,$7f,$ff
	dc.b	$a0,'k',$00,$00,$bf,$ff,$bf,$ff
	dc.b	'J',$c3,$00,$00,$7f,$ff,$7f,$ff
	dc.b	'C',$e2,$00,$00,$7f,$fe,$7f,$fe
	dc.b	$af,$f9,$00,$00,$ff,$ff,$ff,$ff
	dcb.w	26
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	$00,'O',$00,$00,$00,$00,$00,$00
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$08,$00,$00,$00,$00,$00,$00
	dc.b	$08,$04,$08,$00,$02,$00,$00,$00
	dc.b	$ff,$c2,$00,$00,$ff,$fe,$ff,$fe
	dc.b	$cc,'e',$00,$00,$ff,$fd,$ff,$fd
	dc.b	$0f,$86,$00,$00,$ff,$fe,$ff,$fe
	dc.b	'a',$f0,$00,$00,$7f,$ff,$7f,$ff
	dc.b	$a6,'3',$00,$00,$bf,$ff,$bf,$ff
	dc.b	'C',$ff,$00,$00,$7f,$ff,$7f,$ff
	dc.b	'c',$ba,$00,$00,$7f,$fe,$7f,$fe
	dc.b	$cd,$f3,$00,$00,$ff,$ff,$ff,$ff
	dcb.w	26
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	'<',$80,$00,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	$00,$08,$00,$00,$00,$00,$00,$00
	dc.b	$1c,$04,$1c,$00,$02,$00,$00,$00
	dc.b	$7f,$86,$00,$00,$7f,$fe,$7f,$fe
	dc.b	$e7,$e4,$00,$00,$ff,$fc,$ff,$fc
	dc.b	$83,$cc,$00,$00,$ff,$fc,$ff,$fc
	dc.b	'3',$c1,$00,$00,'?',$ff,'?',$ff
	dc.b	$27,$e7,$00,$00,'?',$ff,'?',$ff
l005c	bsr.s	l005c
	dc.b	$00,$00,$7f,$fe,$7f,$fe,'t',$9e
	dc.b	$00,$00,$7f,$fe,$7f,$fe,$cc,'3'
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$00,$00
	dcb.w	25
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	$09,$f0,$00,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	$00,$08,$1f,$00,$1f,$00,$00,$00
	dc.b	$18,$04,$18,$00,$04,$00,$00,$00
	dc.b	$1c,$8e,$00,$00,$1f,$fe,$1f,$fe
	dc.b	$fc,$ec,$00,$00,$ff,$fc,$ff,$fc
	dc.b	$c1,'|',$00,$00,$ff,$fc,$ff,$fc
	dc.b	'>',$83,$00,$00,'?',$ff,'?',$ff
	dc.b	'7?',$00,$00,'?',$ff,'?',$ff
	dc.b	'q8',$00,$00,$7f,$f8,$7f,$f8
	dc.b	'<',$d8,$00,$00,'?',$f8,'?',$f8
	dc.b	'nv',$00,$00,$7f,$fe,$7f,$fe
	dcb.w	26
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	$10,$00,$00,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	$0e,$08,'1',$c0,'1',$c0,$00,$00
	dc.b	'8',$04,'8',$00,$04,$00,$00,$00
	dc.b	'9',$9c,$00,$00,'?',$fc,'?',$fc
	dc.b	'x',$08,$00,$00,$7f,$f8,$7f,$f8
	dc.b	'p8',$00,$00,$7f,$f8,$7f,$f8
	dc.b	$1c,$0e,$00,$00,$1f,$fe,$1f,$fe
	dc.b	$10,$1e,$00,$00,$1f,$fe,$1f,$fe
	dc.b	'9',$9c,$00,$00,'?',$fc,'?',$fc
	dc.b	$1c,$d8,$00,$00,$1f,$f8,$1f,$f8
	dc.b	$7f,$fe,$00,$00,$7f,$fe,$7f,$fe
	dcb.w	26
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	'<',$00,$00,$00,$00,$00,$00,$00
	dcb.w	3
	dc.b	$00,$01,$00,$01,$00,$00,$df,$08
	dc.b	' ',$c0,$e0,$c0,$00,$00,'6',$04
	dc.b	'6',$00,$08,$00,$00,$00,'?',$f8
	dc.b	$00,$00,'?',$f8,'?',$f8,'~',$18
	dc.b	$00,$00,$7f,$f8,$7f,$f8,'?',$f0
	dc.b	$00,$00,'?',$f0,'?',$f0,$0f,$fc
	dc.b	$00,$00,$0f,$fc,$0f,$fc,$18,'~'
	dc.b	$00,$00,$1f,$fe,$1f,$fe,$1f,$fc
	dc.b	$00,$00,$1f,$fc,$1f,$fc,$0d,$f8
	dc.b	$00,$00,$0f,$f8,$0f,$f8,';',$dc
	dc.b	$00,$00,';',$dc,';',$dc,$00,$00
	dcb.w	25
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	7
	dc.b	$00,$01,$00,$01,$00,$00,$9f,$88
	dc.b	$00,'```',$00,$00,'w',$04
	dc.b	'w',$00,$08,$00,$00,$00,$1f,$e0
	dc.b	$00,$00,$1f,$e0,$1f,$e0,'?',$f0
	dc.b	$00,$00,'?',$f0,'?',$f0,$0f,$c0
	dc.b	$00,$00,$0f,$c0,$0f,$c0,$03,$f0
	dc.b	$00,$00,$03,$f0,$03,$f0,$0f,$fc
	dc.b	$00,$00,$0f,$fc,$0f,$fc,$07,$f8
	dc.b	$00,$00,$07,$f8,$07,$f8,$0f,$b0
	dc.b	$00,$00,$0f,$b0,$0f,$b0,$01,$80
	dc.b	$00,$00,$01,$80,$01,$80,$00,$00
	dcb.w	25
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	$00,$07,$00,$08,$00,$0e,$00,$00
	dc.b	$cf,$88,$00,'`0`',$00,$00
	dc.b	'o',$04,'o',$00,$10,$00,$00,$00
	dcb.w	4
	dc.b	$0f,$c0,$00,$00,$0f,$c0,$0f,$c0
	dcb.w	8
	dc.b	$03,$f0,$00,$00,$03,$f0,$03,$f0
	dcb.w	4
	dc.b	$07,$00,$00,$00,$07,$00,$07,$00
	dcb.w	30
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	$00,'4',$00,$c8,$00,$fb,$00,$00
	dc.b	$ff,$88,$00,'`',$00,'`',$00,$00
	dc.b	$e1,$84,$e1,$80,$1e,$00,$00,$00
	dcb.w	58
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	$00,$27,$03,$c0,$03,$d8,$00,$00
	dc.b	$ff,$88,$00,'`',$00,'`',$00,$00
	dc.b	$fd,$84,$fd,$80,$02,$00,$00,$00
	dcb.w	58
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	6
	dc.b	$0f,$ff,$00,$00,$0e,$00,$00,$00
	dc.b	$ff,$89,$00,'a',$00,'`',$00,$00
	dc.b	$fb,$c4,$fb,$c0,$04,$00,$00,$00
	dcb.w	58
	dc.b	$80,$01,$00,$00,$01,$f0,$00,$00
	dc.b	$01,$f0,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	'1',$ff,$00,$00,'?',$00,$00,$00
	dc.b	$ff,$89,$00,'a',$03,$e0,$00,$00
	dc.b	$fb,$c4,$fb,$c0,$04,$00,$00,$00
	dcb.w	58
	dc.b	$80,$01,$00,$00,$06,'>',$00,$00
	dc.b	$07,$fe,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$c0,$ff,$00,$00,$ff,$80,$00,$00
	dc.b	$fd,'h',$00,$00,$07,$e0,$00,$00
	dc.b	$00,$04,$00,$00,$08,$00,$00,$00
	dc.b	$01,$fe,$00,$00,$01,$fe,$01,$fe
	dc.b	$00,$03,$00,$00,$00,$03,$00,$03
	dc.b	$f0,$00,$00,$00,$f0,$00,$f0,$00
	dc.b	$0f,$80,$00,$00,$0f,$80,$0f,$80
	dc.b	$00,$1f,$00,$00,$00,$1f,$00,$1f
	dc.b	$80,$00,$00,$00,$80,$00,$80,$00
	dcb.w	4
	dc.b	'0',$00,$00,$00,'0',$00,'0',$00
	dc.b	$00,$c0,$00,$00,$00,$c0,$00,$c0
	dcb.w	22
	dc.b	$80,$01,$00,$00,$08,'C',$00,$00
	dc.b	$0f,$ff,$00,$00,$00,$01,$00,$00
	dc.b	$00,$01,$00,$00,$00,$7f,$00,$00
	dc.b	$ff,$ff,$00,$00,$f9,'h',$00,$00
	dc.b	$ff,$e0,$00,$00,$00,$04,$00,$00
	dc.b	$08,$00,$00,$00,$0f,$01,$00,$00
	dc.b	$0f,$ff,$0f,$ff,$e0,$0c,$00,$00
	dc.b	$e0,$0f,$e0,$0f,$0c,$00,$00,$00
	dc.b	$fc,$00,$fc,$00,$1f,$e0,$00,$00
	dc.b	$1f,$e0,$1f,$e0,$01,$f0,$00,$00
	dc.b	$01,$ff,$01,$ff,'`',$00,$00,$00
	dc.b	$e0,$00,$e0,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$f8,$06,$00,$00,$f8,$06,$f8,$06
	dc.b	$03,'0',$00,$00,$03,$f0,$03,$f0
	dcb.w	22
	dc.b	$ff,$ff,$00,$00,$0f,$c2,$00,$00
	dc.b	$0f,$ff,$00,$00,$80,$01,$00,$00
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$01,'h',$00,$00
	dc.b	$ff,$e0,$00,$00,$00,$04,$00,$00
	dc.b	$10,$00,$00,$00,$10,$00,$00,$00
	dc.b	$1f,$ff,$1f,$ff,$1c,$10,$00,$00
	dc.b	$fc,$1f,$fc,$1f,$02,$00,$00,$00
	dc.b	$fe,$00,$fe,$00,' p',$00,$00
	dc.b	'?',$f0,'?',$f0,$06,$00,$00,$00
	dc.b	$07,$ff,$07,$ff,$10,$00,$00,$00
	dc.b	$f0,$00,$f0,$00,$01,$81,$00,$00
	dc.b	$01,$81,$01,$81,$fc,$0f,$00,$00
	dc.b	$fc,$0f,$fc,$0f,$05,'(',$00,$00
	dc.b	$07,$f8,$07,$f8,$00,$00,$00,$00
	dcb.w	20
	dc.b	$ff,$ff,$00,$00,$07,$ce,$00,$00
	dc.b	$07,$ff,$00,$00,'@',$01,$00,$00
	dc.b	$c0,$01,$00,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$03,'h',$00,$00
	dc.b	$ff,$e0,$00,$00,$00,$04,$00,$00
	dc.b	$10,$00,$00,$00,' ',$07,$00,$00
	dc.b	'?',$ff,'?',$ff,$82,$10,$00,$00
	dc.b	$fe,$1f,$fe,$1f,$01,$00,$00,$00
	dc.b	$ff,$00,$ff,$00,'@0',$00,$00
	dc.b	$7f,$f0,$7f,$f0,$04,$00,$00,$00
	dc.b	$07,$ff,$07,$ff,$08,$00,$00,$00
	dc.b	$f8,$00,$f8,$00,$03,$c1,$00,$00
	dc.b	$03,$c1,$03,$c1,'.',$0b,$00,$00
	dc.b	$fe,$0f,$fe,$0f,$09,'$',$00,$00
	dc.b	$0f,$fc,$0f,$fc,$00,$00,$00,$00
	dcb.w	20
	dc.b	$80,$01,$00,$00,$0e,'L',$00,$00
	dc.b	$0f,$ff,$00,$00,'@',$00,$00,$00
	dc.b	$c0,$00,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$ff,$00,$00,$ff,$cf,$00,$00
	dc.b	$ff,$c0,$00,$00,$ff,$fc,$00,$00
	dcb.w	2
	dc.b	'@',$00,$00,$00,$7f,$ff,$7f,$ff
	dc.b	'q ',$00,$00,$ff,'?',$ff,'?'
	dc.b	$00,$80,$00,$00,$ff,$80,$ff,$80
	dc.b	$00,$18,$00,$00,$7f,$f8,$7f,$f8
	dc.b	$03,$e0,$00,$00,$03,$ff,$03,$ff
	dc.b	$08,$00,$00,$00,$f8,$00,$f8,$00
	dc.b	$02,$c1,$00,$00,$03,$c1,$03,$c1
	dc.b	$97,$09,$00,$00,$ff,$0f,$ff,$0f
	dc.b	$09,'$',$00,$00,$0f,$fc,$0f,$fc
	dcb.w	22
	dc.b	$80,$01,$00,$00,$18,'j',$00,$00
	dc.b	$1f,$ff,$00,$00,'@',$00,$00,$00
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dcb.w	10
	dc.b	'@',$00,$00,$00,$7f,$ff,$7f,$ff
	dc.b	$0f,$a0,$00,$00,$ff,$bf,$ff,$bf
	dc.b	$00,'@',$00,$00,$ff,$c0,$ff,$c0
	dc.b	$00,$18,$00,$00,$7f,$f8,$7f,$f8
	dc.b	$00,' ',$00,$00,$00,'?',$00,'?'
	dc.b	$18,$00,$00,$00,$f8,$00,$f8,$00
	dc.b	$02,'A',$00,$00,$03,$c1,$03,$c1
	dc.b	$cb,$89,$00,$00,$ff,$8f,$ff,$8f
	dc.b	$89,'$',$00,$00,$8f,$fc,$8f,$fc
	dcb.w	22
	dc.b	$80,$01,$00,$00,$1f,$f8,$00,$00
	dc.b	$1f,$ff,$00,$00,'@',$00,$00,$00
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dcb.w	10
	dc.b	'@',$1f,$00,$00,$7f,$ff,$7f,$ff
	dc.b	$01,$a0,$00,$00,$ff,$bf,$ff,$bf
	dc.b	$01,'@',$00,$00,$ff,$c0,$ff,$c0
	dc.b	$80,$0c,$00,$00,$ff,$fc,$ff,$fc
	dc.b	$00,'@',$00,$00,$00,$7f,$00,$7f
	dc.b	$18,$00,$00,$00,$f8,$00,$f8,$00
	dc.b	$02,'a',$00,$00,$03,$e1,$03,$e1
	dc.b	'I',$f9,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$89,'$',$00,$00,$8f,$fc,$8f,$fc
	dcb.w	22
	dc.b	$80,$01,$00,$00,$0f,$f0,$00,$00
	dc.b	$0f,$ff,$00,$00,$c0,$00,$00,$00
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dcb.w	10
	dc.b	'@',$01,$00,$00,$7f,$ff,$7f,$ff
	dc.b	$fb,' ',$00,$00,$ff,'?',$ff,'?'
	dc.b	$09,'#',$00,$00,$ff,$e3,$ff,$e3
	dc.b	$80,$0c,$00,$00,$ff,$fc,$ff,$fc
	dc.b	$00,$90,$00,$00,$00,$ff,$00,$ff
	dc.b	$18,$00,$00,$00,$f8,$00,$f8,$00
	dc.b	$02,'1',$00,$00,$03,$f1,$03,$f1
	dc.b	'$q',$00,$00,$ff,$ff,$ff,$ff
	dc.b	$91,'$',$00,$00,$9f,$fc,$9f,$fc
	dcb.w	22
	dc.b	$80,$01,$00,$00,$03,$91,$00,$00
	dc.b	$03,$ff,$00,$00,$c0,$01,$00,$00
	dc.b	$c0,$01,$00,$00,$e0,$00,$00,$00
	dc.b	$e0,$00,$00,$00,$80,$00,$03,$fc
	dc.b	$ff,$fc,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	'@',$1e,$00,$00,$7f,$ff,$7f,$ff
	dc.b	$07,' ',$00,$00,$ff,'?',$ff,'?'
	dc.b	$08,$a6,$00,$00,$ff,$e7,$ff,$e7
	dc.b	$00,$0c,$00,$00,$ff,$fc,$ff,$fc
	dc.b	$01,'"',$00,$00,$01,$ff,$01,$ff
	dc.b	'0',$1f,$00,$00,$f0,$1f,$f0,$1f
	dc.b	$fe,'8',$00,$00,$ff,$f8,$ff,$f8
	dc.b	$a2,$01,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$91,'$',$00,$00,$9f,$fc,$9f,$fc
	dcb.w	22
	dc.b	$80,$01,$00,$00,$07,'3',$00,$00
	dc.b	$07,$ff,$00,$00,$80,$02,$00,$00
	dc.b	$80,$03,$00,$00,$10,$00,$00,$00
	dc.b	$f0,$00,$00,$00,$83,$f0,$00,$0c
	dc.b	$fe,$0c,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	'`',$7f,$00,$00,$7f,$ff,$7f,$ff
	dc.b	$fe,'!',$00,$00,$fe,'?',$fe,'?'
	dc.b	$84,$94,$00,$00,$ff,$f7,$ff,$f7
	dc.b	'`',$04,$00,$00,$ff,$fc,$ff,$fc
	dc.b	$02,'D',$00,$00,$03,$ff,$03,$ff
	dc.b	'p',$ff,$00,$00,$f0,$ff,$f0,$ff
	dc.b	$f9,$1c,$00,$00,$ff,$fc,$ff,$fc
	dc.b	$92,$01,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$91,'%',$00,$00,$9f,$fd,$9f,$fd
	dc.b	$e0,$00,$00,$00,$e0,$00,$e0,$00
	dcb.w	18
	dc.b	$80,$01,$00,$00,$07,$ff,$00,$00
	dc.b	$07,$ff,$00,$00,$00,$02,$00,$00
	dc.b	$00,$03,$00,$00,$10,$00,$00,$00
	dc.b	$f0,$00,$00,$00,$83,$f8,$00,$06
	dc.b	$fe,$06,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	'0',$ff,$00,$00,'?',$ff,'?',$ff
	dc.b	$f0,'#',$00,$00,$f0,'?',$f0,'?'
	dc.b	$c2,'S',$00,$00,$ff,$f3,$ff,$f3
	dc.b	$d2,'D',$00,$00,$df,$fc,$df,$fc
	dc.b	$04,$88,$00,$00,$07,$ff,$07,$ff
	dc.b	$e1,$c0,$00,$00,$e1,$ff,$e1,$ff
	dc.b	$00,$8c,$00,$00,$ff,$fc,$ff,$fc
	dc.b	'P',$00,$00,$00,$7f,$ff,$7f,$ff
	dc.b	$90,$03,$00,$00,$9f,$ff,$9f,$ff
	dc.b	$10,$00,$00,$00,$f0,$00,$f0,$00
	dcb.w	18
	dc.b	$80,$01,$00,$00,$03,$fc,$00,$00
	dc.b	$03,$fc,$00,$00,$00,$02,$00,$00
	dc.b	$00,$03,$00,$00,$08,$00,$00,$00
	dc.b	$f8,$00,$00,$00,$83,$fc,$00,$02
	dc.b	$fe,$02,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$11,$80,$00,$00,$1f,$80,$1f,$80
	dc.b	$00,'&',$00,$00,$00,'>',$00,'>'
	dc.b	'2p',$00,$00,'?',$f0,'?',$f0
	dc.b	$12,'D',$00,$00,$1f,$fc,$1f,$fc
	dc.b	$09,'1',$00,$00,$0f,$ff,$0f,$ff
	dc.b	$c1,'?',$00,$00,$c1,$ff,$c1,$ff
	dc.b	$00,$0c,$00,$00,$ff,$fc,$ff,$fc
	dc.b	'@',$00,$00,$00,$7f,$ff,$7f,$ff
	dc.b	$90,$00,$00,$00,$9f,$ff,$9f,$ff
	dc.b	'0',$00,$00,$00,$f0,$00,$f0,$00
	dcb.w	18
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$02,$00,$00,$00,$03,$00,$00
	dc.b	$08,$00,$00,$00,$f8,$00,$00,$00
	dc.b	$87,$fc,$00,$02,$fc,$02,$00,$00
	dcb.w	4
	dc.b	$09,$80,$00,$00,$0f,$80,$0f,$80
	dc.b	$00,$16,$00,$00,$00,$1e,$00,$1e
	dc.b	$19,'p',$00,$00,$1f,$f0,$1f,$f0
	dc.b	$12,'L',$00,$00,$1f,$fc,$1f,$fc
	dc.b	$0a,'G',$00,$00,$0f,$ff,$0f,$ff
	dc.b	$82,$01,$00,$00,$83,$ff,$83,$ff
	dc.b	$f0,$04,$00,$00,$ff,$fc,$ff,$fc
	dc.b	' ',$00,$00,$00,'?',$ff,'?',$ff
	dc.b	$98,$00,$00,$00,$9f,$ff,$9f,$ff
	dc.b	$e0,$00,$00,$00,$e0,$00,$e0,$00
	dcb.w	18
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$02,$00,$00,$00,$03,$00,$00
	dc.b	$04,$00,$00,$00,$fc,$00,$00,$00
	dc.b	$8f,$d8,$00,$06,$f8,'&',$00,$00
	dcb.w	4
	dc.b	$05,$80,$00,$00,$07,$80,$07,$80
	dc.b	$00,$16,$00,$00,$00,$1e,$00,$1e
	dc.b	$0c,$b0,$00,$00,$0f,$f0,$0f,$f0
	dc.b	$12,'H',$00,$00,$1f,$f8,$1f,$f8
	dc.b	$0c,$9f,$00,$00,$0f,$ff,$0f,$ff
	dc.b	$03,$e0,$00,$00,$03,$ff,$03,$ff
	dc.b	$00,$04,$00,$00,$ff,$fc,$ff,$fc
	dc.b	$10,$01,$00,$00,$1f,$ff,$1f,$ff
	dc.b	$18,$01,$00,$00,$1f,$ff,$1f,$ff
	dc.b	$80,$00,$00,$00,$80,$00,$80,$00
	dcb.w	18
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$02,$00,$00,$00,$03,$00,$00
	dc.b	$04,$00,$00,$00,$fc,$00,$00,$00
	dc.b	$8f,$c8,$00,$04,$f8,'4',$00,$00
	dcb.w	4
	dc.b	$05,$80,$00,$00,$07,$80,$07,$80
	dc.b	$00,$16,$00,$00,$00,$1e,$00,$1e
	dc.b	$07,$f0,$00,$00,$07,$f0,$07,$f0
	dc.b	$12,'H',$00,$00,$1f,$f8,$1f,$f8
	dc.b	$07,$fc,$00,$00,$07,$fc,$07,$fc
	dc.b	$01,$1c,$00,$00,$01,$ff,$01,$ff
	dc.b	$00,$04,$00,$00,$ff,$fc,$ff,$fc
	dc.b	$08,$01,$00,$00,$0f,$ff,$0f,$ff
	dc.b	$0c,$01,$00,$00,$0f,$ff,$0f,$ff
	dcb.w	22
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$02,$00,$00,$00,$03,$00,$00
	dc.b	$0c,$00,$02,$00,$fa,$00,$00,$00
	dc.b	$8f,$e8,$00,$00,$f8,$18,$00,$00
	dcb.w	4
	dc.b	$05,$80,$00,$00,$07,$80,$07,$80
	dc.b	$00,$0c,$00,$00,$00,$0c,$00,$0c
	dc.b	$03,$e0,$00,$00,$03,$e0,$03,$e0
	dc.b	$12,'H',$00,$00,$1f,$f8,$1f,$f8
	dc.b	$03,$e0,$00,$00,$03,$e0,$03,$e0
	dc.b	$00,$83,$00,$00,$00,$ff,$00,$ff
	dc.b	$c0,$08,$00,$00,$ff,$f8,$ff,$f8
	dc.b	$06,$06,$00,$00,$07,$fe,$07,$fe
	dc.b	$0c,$03,$00,$00,$0f,$ff,$0f,$ff
	dcb.w	22
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$02,$1e,$00,$1e,$03,$00,$00
	dc.b	$1c,$00,$02,$00,$f2,$00,$00,$00
	dc.b	$8f,$f8,$00,$00,$f8,$08,$00,$00
	dcb.w	4
	dc.b	$03,$00,$00,$00,$03,$00,$03,$00
	dcb.w	4
	dc.b	$01,$80,$00,$00,$01,$80,$01,$80
	dc.b	$12,'P',$00,$00,$1f,$f0,$1f,$f0
	dcb.w	4
	dc.b	$00,'p',$00,$00,$00,$7f,$00,$7f
	dc.b	$00,$10,$00,$00,$ff,$f0,$ff,$f0
	dc.b	$01,$f8,$00,$00,$01,$f8,$01,$f8
	dc.b	$04,$03,$00,$00,$07,$ff,$07,$ff
	dcb.w	22
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$1c,$02,'#',$00,'#',$03,$00,$00
	dc.b	'<',$00,$03,$00,$e3,$00,$00,$00
	dc.b	$8f,$a0,$00,$18,$f8,'X',$00,$00
	dcb.w	16
	dc.b	$02,'P',$00,$00,$0f,$f0,$0f,$f0
	dcb.w	4
	dc.b	$00,$0f,$00,$00,$00,$0f,$00,$0f
	dc.b	$01,$e0,$00,$00,$ff,$e0,$ff,$e0
	dcb.w	4
	dc.b	$06,$0e,$00,$00,$07,$fe,$07,$fe
	dcb.w	22
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	'>',$02,'A',$80,'A',$83,$00,$00
	dc.b	'>',$00,$01,$00,$e1,$00,$00,$00
	dc.b	$8f,$a0,$00,$00,$f8,'`',$00,$00
	dcb.w	16
	dc.b	$0a,'`',$00,$00,$0f,$e0,$0f,$e0
	dcb.w	8
	dc.b	$ff,$00,$00,$00,$ff,$00,$ff,$00
	dcb.w	4
	dc.b	$03,$fc,$00,$00,$03,$fc,$03,$fc
	dcb.w	22
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	'?',$02,'@',$c0,'@',$c3,$00,$00
	dc.b	'?',$00,$00,$00,$e1,$00,$00,$00
	dc.b	$8f,$e0,$00,$00,$f8,' ',$00,$00
	dcb.w	16
	dc.b	$07,$80,$00,$00,$07,$80,$07,$80
	dcb.w	16
	dc.b	$00,$f8,$00,$00,$00,$f8,$00,$f8
	dcb.w	22
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$7f,$02,$00,$c0,'@',$c3,$00,$00
	dc.b	'=',$00,$00,$00,$e3,$00,$00,$00
	dc.b	$8f,$00,$00,'`',$f8,$e0,$00,$00
	dc.b	$00,$02,$00,$00,$00,$02,$00,$00
	dcb.w	58
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	'_',$82,$00,'``c',$00,$00
	dc.b	'<',$00,$01,$80,$e3,$80,$00,$00
	dc.b	$8f,'@',$00,$00,$f8,$c0,$00,$00
	dc.b	$00,$0f,$00,$00,$00,$0f,$00,$00
	dcb.w	58
	dc.b	$80,$01,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	'O',$82,$80,'`',$b0,'c',$00,$00
	dc.b	'?',$80,$00,$00,$e0,$80,$00,$00
	dc.b	$8f,$c0,$00,$00,$f8,'@',$00,$00
	dc.b	$00,'7',$00,$00,$00,'?',$00,$00
	dc.b	$80,$00,$00,$00,$80,$00,$00,$00
	dcb.w	54
	dc.b	$80,$01,$00,$00,$00,$01,$00,$00
	dc.b	$00,$01,$00,$00,$ef,$c2,$00,'0'
	dc.b	$90,'3',$00,$00,'>',$80,$00,$00
	dc.b	$e1,$80,$00,$00,$8f,$80,$00,'@'
	dc.b	$f8,'@',$00,$00,$00,$d3,$00,$00
	dc.b	$00,$ff,$00,$00,$80,$00,$00,$00
	dc.b	$80,$00,$00,$00,$00,$00,$00,$00
	dcb.w	52
	dc.b	$80,$01,$00,$00,$00,$01,$00,$02
	dc.b	$00,$02,$00,$00,'?',$f2,$00,$00
	dc.b	$c0,'3',$00,$00,'>',$80,$00,'`'
	dc.b	$e1,'`',$00,$00,$8f,$00,$00,$c0
	dc.b	$f8,$c0,$00,$00,$03,$09,$00,$00
	dc.b	$03,$ff,$00,$00,$c0,$00,$00,$00
	dc.b	$c0,$00,$00,$00,$00,$00,$00,$00
	dcb.w	52
	dc.b	$80,$01,$00,$00,$00,$07,$00,$08
	dc.b	$00,$0e,$00,$00,$ff,$fa,$00,$00
	dc.b	$00,'{',$00,$00,'?',$e0,$00,$00
	dc.b	$e0,' ',$00,$00,$87,$00,$00,$80
	dc.b	$fc,$80,$00,$00,$0c,'?',$00,$00
	dc.b	$0f,$ff,$00,$00,$80,$00,'@',$00
	dc.b	'@',$00,$00,$00,$00,$00,$00,$00
	dcb.w	52
	dc.b	$80,$01,$00,$00,$00,$04,$00,'8'
	dc.b	$00,';',$00,$00,$ff,$ba,$00,$00
	dc.b	$00,$fb,$00,$00,'?',$a0,$00,$00
	dc.b	$e0,'`',$00,$00,$83,$00,$00,$80
	dc.b	$fe,$80,$00,$00,'0',$ff,$00,$00
	dc.b	'?',$c0,$00,$00,$80,$00,'`',$00
	dc.b	'`',$00,$00,$00,$00,$c3,$01,'C'
	dc.b	$01,$bc,$01,$ff,'s',$b3,$8f,'<'
	dc.b	$00,$c0,$ff,$ff,$93,$90,'dp'
	dc.b	$10,$0f,$f7,$ff,$9f,$ff,$e0,$f3
	dc.b	$03,$0c,$ff,$ff,$03,$90,$e4,'p'
	dc.b	$10,$0f,$f7,$ff,$9c,$e6,$e3,$e6
	dc.b	$00,$19,$ff,$ff,$02,$89,$85,$8e
	dc.b	$80,'q',$87,$ff,$1c,'p',$7f,$90
	dc.b	$00,$00,$7f,$f0,$07,$1c,$04,$ff
	dc.b	$00,$00,$07,$ff,$00,$00,$00,$00
	dcb.w	16
	dc.b	$80,$01,$00,$00,$00,$ff,$00,$00
	dc.b	$00,$e0,$00,$00,$ff,$ba,$00,$00
	dc.b	$00,$fb,$00,$00,'? ',$00,$10
	dc.b	$e0,$d0,$00,$00,$81,$00,$00,$00
	dc.b	$ff,$00,$00,$00,$c3,$ff,$00,$00
	dc.b	$ff,$00,$00,$00,$80,$00,'p',$00
	dc.b	'p',$00,$00,$00,$03,'c',$01,$e3
	dc.b	$02,$1c,$03,$ff,$b9,'7',$c7,'8'
	dc.b	$00,$c0,$ff,$ff,'!',$d9,$d2,'9'
	dc.b	'4',$06,$f7,$ff,$9b,$8c,$e7,$8f
	dc.b	$00,'p',$ff,$ff,$01,$d9,$d2,'9'
	dc.b	'4',$06,$f7,$ff,$9b,$9c,$e7,$9f
	dc.b	$00,'`',$ff,$ff,$c1,'Z',$a2,$dd
	dc.b	'd#',$e7,$ff,'N',$f0,'? '
	dc.b	'@',$10,$7f,$f0,$07,$b9,$02,'~'
	dc.b	$04,$01,$07,$ff,$00,$00,$00,$00
	dcb.w	16
	dc.b	$80,$01,$00,$00,$03,$1f,$00,$00
	dc.b	$03,$f0,$00,$00,$ff,$ba,$00,$00
	dc.b	$07,$fb,$00,$00,'?`',$00,$18
	dc.b	$e0,$98,$00,$00,$81,$03,$00,$00
	dc.b	$ff,$03,$00,$00,$0f,$ff,$00,$00
	dc.b	$fc,$00,$00,$00,$c0,$00,'8',$00
	dc.b	'8',$00,$00,$00,$03,$a1,$06,'a'
	dc.b	$04,$1e,$07,$ff,$cd,'n',$f3,'q'
	dc.b	$00,$80,$ff,$ff,'@',$ef,$b1,$1f
	dc.b	'v',$00,$f7,$ff,$a3,$b8,$df,$bf
	dc.b	$00,'@',$ff,$ff,$10,$ef,$a1,$1f
	dc.b	'v',$00,$f7,$ff,$a3,$b9,$df,$bf
	dc.b	$00,'@',$ff,$ff,$a0,'T',$81,$db
	dc.b	'f',$27,$e7,$ff,'&',$f0,'_@'
	dc.b	'`0',$7f,$f0,$07,$b2,$01,'}'
	dc.b	$06,$03,$07,$ff,$00,$00,$00,$00
	dcb.w	16
	dc.b	$80,$01,$00,$00,$0c,$0f,$00,$00
	dc.b	$0f,$f8,$00,$00,$f8,'r',$00,$00
	dc.b	'?',$f3,$00,$00,$1f,$f0,$00,$08
	dc.b	$f0,$08,$00,$00,$be,$0c,$00,$00
	dc.b	$fe,$0f,$00,$00,$1f,$ff,$00,$00
	dc.b	$f0,$00,$00,$00,$e0,$00,$18,$00
	dc.b	$18,$00,$00,$00,$05,$80,$02,$7f
	dc.b	$04,$00,$07,$c0,$00,$00,$ff,$ff
	dcb.w	2
	dc.b	$04,$00,$f0,$ff,'w',$00,'w',$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	'$',$00,$c0,$ff,'w',$00,'w',$00
	dc.b	$00,$01,$ff,$ff,$00,$00,$00,$01
	dc.b	'd',$00,$10,$ff,$f7,$07,$f7,$07
	dc.b	$10,'`o',$80,'pppp'
	dc.b	$03,$04,$00,$fb,$07,$07,$07,$07
	dcb.w	18
	dc.b	$80,$01,$00,$00,$10,$07,$00,$00
	dc.b	$1f,$ff,$00,$00,$c0,$c3,$00,$00
	dc.b	$ff,$c3,$00,$00,$ef,$f0,$00,$08
	dc.b	$f8,$08,$00,$00,$82,$10,$00,$00
	dc.b	$fe,$1f,$00,$00,'?',$f3,$00,$00
	dc.b	$e0,$0c,$00,$00,$e0,$00,$18,$00
	dc.b	$18,$00,$00,$00,$06,$7f,$07,$ff
	dc.b	$00,$00,$07,$80,$ff,$ff,$ff,$ff
	dcb.w	2
	dc.b	$b6,$ff,$c0,$ff,'w',$00,'w',$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$e6,$ff,$80,$ff,'w',$00,'w',$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$f6,$f8,$00,$ff,$f7,$07,$f7,$07
	dc.b	'O',$c0,'?',$88,'pxpx'
	dc.b	$01,$f9,$08,$fe,$0f,$07,$0f,$07
	dcb.w	18
	dc.b	$80,$01,$00,$00,$10,$00,$00,$00
	dc.b	$1f,$ff,$00,$00,$07,$02,$00,$00
	dc.b	$ff,$03,$00,$00,$0f,$e0,$00,$18
	dc.b	$f8,$18,$00,$00,$fc,' ',$00,$00
	dc.b	$fc,'?',$00,$00,'?',$93,$00,$00
	dc.b	$e0,'l',$00,$00,$e0,$00,$18,$00
	dc.b	$18,$00,$00,$00,$07,$00,$07,$ff
	dc.b	$00,$00,$07,$00,$00,$00,$ff,$ff
	dcb.w	2
	dc.b	'G',$00,$80,$ff,'w',$00,'w',$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	'g',$00,$80,$ff,'w',$00,'w',$00
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	'G',$01,$b0,$fe,'w',$07,'w',$07
	dc.b	'`',$00,$1f,$84,'p|p|'
	dc.b	$00,$03,$10,$fc,$1f,$07,$1f,$07
	dcb.w	18
	dc.b	$80,$01,$00,$00,$10,$00,$00,$00
	dc.b	$1f,$ff,$00,$00,'8',$03,$00,$00
	dc.b	$f8,$03,$00,$00,$ff,$c0,$00,'0'
	dc.b	$f8,'0',$00,$00,$fc,' ',$00,$00
	dc.b	$fc,'?',$00,$00,'<',$8d,$00,$12
	dc.b	$e3,'~',$00,$00,$80,$00,'p',$00
	dc.b	'p',$00,$00,$00,$03,$ff,$03,$ff
	dc.b	$04,$00,$07,$00,$ff,$ff,$ff,$ff
	dcb.w	2
	dc.b	$84,$ff,$80,$ff,'w',$00,'w',$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$b4,$ff,$c0,$ff,'w',$00,'w',$00
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$81,$fb,$f0,$fc,'w',$07,'w',$07
	dc.b	$7f,$ca,$0f,$c8,'p6p>'
	dc.b	')',$ff,$09,$f8,'6',$07,'>',$07
	dcb.w	18
	dc.b	$80,$01,$00,$00,$0f,$ff,$00,$00
	dc.b	$0f,$ff,$00,$00,$c0,$03,$00,$00
	dc.b	$c0,$03,$00,$00,$f0,$00,$0f,$f0
	dc.b	$ff,$f0,$00,$00,'x',$10,$00,$00
	dc.b	'x',$1f,$00,$00,$7f,'`',$00,$93
	dc.b	$c3,$f3,$00,$00,$00,$00,$e0,$00
	dc.b	$e0,$00,$00,$00,$04,$00,$00,$00
	dc.b	$07,$ff,$07,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,'q',$00,$01,$00
	dc.b	$f6,$ff,'w',$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$10,$00,'`',$00
	dc.b	$f7,$ff,'w',$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$00,$06,'p',$00
	dc.b	$f7,$ff,'w',$07,'x',$1c,$00,$1f
	dc.b	$7f,$e0,'x?',$9c,$0f,'|',$00
	dc.b	$03,$ff,$fe,$0f,$00,$00,$00,$00
	dcb.w	16
	dc.b	$ff,$ff,$00,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$00,$01,$00,$00,$00,$01,$00,$00
	dc.b	$f0,$00,$0f,$c0,$ff,$c0,$00,$00
	dc.b	$00,$0f,$00,$00,$00,$0f,$00,$00
	dc.b	$80,$00,'|',$00,$fc,$00,$00,$00
	dcb.w	4
	dc.b	$06,$fa,$00,$f9,$07,$07,$07,$07
	dc.b	$01,$e0,$fe,$1f,$ff,$ff,$ff,$ff
	dc.b	'v',$19,$86,$e0,$f1,$ff,$f7,$ff
	dc.b	$bf,'q>',$81,$c1,$fe,$c1,$ff
	dc.b	$c7,$00,$b0,$ff,'w',$ff,$f7,$ff
	dc.b	$00,$1f,$ff,$ef,$ff,$f0,$ff,$f0
	dc.b	$82,$fc,$f2,$f8,'u',$07,'w',$07
	dc.b	$07,$fd,'G',$fe,'x',$00,'x',$1f
	dc.b	$df,$f0,'?',$f1,$00,$0f,$fc,$0f
	dcb.w	44
	dc.b	$04,$06,$00,$07,$07,$f8,$07,$07
	dc.b	'g',$07,$9f,$07,$00,$f8,$ff,$ff
	dc.b	'tc',$c5,$80,'3',$ff,$f7,$ff
	dc.b	$00,$bc,'@@',$bf,$ff,$c1,$ff
	dc.b	$e7,'<',$d4,'?3',$c0,$f7,$ff
	dc.b	'kP',$9b,$b0,$04,$0f,$ff,$f0
	dc.b	$07,$04,'w',$00,$f0,$ff,'w',$07
	dc.b	' ',$00,$00,$07,'?',$f8,'<',$07
	dc.b	$80,$02,'p',$00,$0f,$fe,$f0,$1e
	dcb.w	44
	dc.b	$01,$ff,$01,$00,$06,$ff,$07,$00
	dc.b	$ff,$fe,$00,$01,$ff,$fe,$00,$01
	dc.b	$c0,'é#',$00,$07,$ff,$e7,$ff
	dc.b	'~F',$80,'8?',$ff,$c1,$ff
	dc.b	'v',$ff,'f',$00,$91,$ff,$f7,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$87,$fc,'w',$00,$f0,$ff,'w',$07
	dc.b	$17,$ff,' ',$00,'?',$ff,'>',$00
	dc.b	$ff,$f4,$00,$02,$ff,$fe,$00,'>'
	dcb.w	44
	dc.b	$07,$00,$07,$00,$00,$ff,$07,$00
	dcb.w	2
	dc.b	$ff,$ff,$00,$00,$b0,$00,'p',$01
	dc.b	$00,$00,$f0,$01,$c1,$00,$00,$00
	dc.b	'?',$c0,$c1,$c0,$03,$00,$07,$00
	dc.b	$00,$ff,$07,$00,$00,$00,$00,$00
	dc.b	$ff,$ff,$00,$00,$05,$04,'w',$00
	dc.b	$f0,$ff,'w',$07,$0f,$00,$10,$00
	dc.b	$1f,$ff,$1f,$00,$00,'x',$00,$04
	dc.b	$ff,$fc,$00,'|',$00,$00,$00,$00
	dcb.w	42
	dc.b	$04,$ff,$07,$00,$00,$ff,$07,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$e0,$01,'`',$00,$90,$00,'p',$01
	dc.b	$bf,$00,'@',$00,'?',$c0,$c1,$c0
	dc.b	$01,$ff,$07,$00,$00,$ff,$07,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$c0,$fc,'7',$00,$f0,$ff,'w',$07
	dc.b	$06,$ff,$0e,$00,$09,$ff,$0f,$80
	dc.b	$ff,$b0,$00,'8',$ff,$c8,$00,$f8
	dcb.w	24
	dc.b	$0f,$cf,$0f,$cf,$0f,$cf,$0f,$cf
	dc.b	$cf,$cf,$cf,$cf,$cf,$cf,$cf,$cf
	dc.b	$cf,$cc,$cf,$cc,$cf,$cc,$cf,$cc
	dc.b	$cf,$cf,$cf,$cf,$cf,$cf,$cf,$cf
	dc.b	$c0,$00,$c0,$00,$c0,$00,$c0,$00
	dc.b	$05,$00,$03,$7f,$04,$ff,$07,$80
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$10,$01,$80,$00,$f0,$00,'p',$01
	dc.b	$01,$80,$fe,$00,'?',$c0,$c1,$c0
	dc.b	$02,$00,$05,$ff,$00,$ff,$07,$00
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$f2,$06,$05,$f8,$f0,$ff,$f7,$07
	dc.b	$07,$00,$18,$ff,$10,$ff,$1f,$00
	dc.b	$00,'p',$ff,$8c,$ff,$84,$00,'|'
	dcb.w	24
	dc.b	$1f,$df,$1f,$df,$1f,$df,$1f,$df
	dc.b	$df,$df,$df,$df,$df,$df,$df,$df
	dc.b	$df,$de,$df,$de,$df,$de,$df,$de
	dc.b	$df,$df,$df,$df,$df,$df,$df,$df
	dc.b	$c0,$00,$c0,$00,$c0,$00,$c0,$00
	dc.b	$02,$ff,$02,$00,$01,$ff,$03,$c0
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$f0,$00,$00,$01,$f0,$00,'p',$01
	dc.b	$7f,$80,$80,$00,'?',$c0,$c1,$c0
	dc.b	$06,$ff,$01,$00,$00,$ff,$07,$00
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$01
	dc.b	'g',$fe,'`',$00,$80,$ff,$e7,$07
	dc.b	$0d,$ff,'2',$00,'!',$ff,'>',$00
	dc.b	$ff,$d8,$00,'&',$ff,$c2,$00,'>'
	dcb.w	44
	dc.b	$06,$e6,$05,$81,$00,$7f,$07,$ff
	dc.b	$00,$e0,$ff,$0f,$ff,$ff,$ff,$f0
	dc.b	$00,$00,$f0,$01,$f0,$00,'p',$01
	dc.b	$c0,$c0,'?',$00,'?',$c0,$c1,$c0
	dc.b	$06,$00,$01,$ff,$00,$ff,$07,$07
	dc.b	$e1,$c0,$01,$ff,$fe,'?',$ff,$c0
	dc.b	$f7,$03,$f0,$fc,$00,$ff,$f7,$07
	dc.b	$10,$04,$1f,$f8,'#',$ff,'<',$07
	dc.b	$10,$04,$0f,$fc,$ff,$e2,$f0,$1e
	dcb.w	24
	dc.b	$1f,$df,$1f,$df,$1f,$df,$1f,$df
	dc.b	$de,$1f,$de,$1f,$de,$1f,$de,$1f
	dc.b	$de,$1b,$de,$1b,$de,$1b,$de,$1b
	dc.b	$c3,$1f,$c3,$1f,$c3,$1f,$c3,$1f
	dc.b	$c0,$00,$c0,$00,$c0,$00,$c0,$00
	dc.b	$07,$8c,$06,'|',$00,$03,$07,$ff
	dc.b	$cd,$8f,$f3,$8f,$00,$7f,$ff,$f0
	dc.b	$80,$01,$f0,$00,$f0,$00,'p',$01
	dc.b	$fe,$c0,'?',$00,'?',$c0,$c1,$c0
	dc.b	$02,$f8,$05,$ff,$00,$ff,$07,$07
	dc.b	'8',$df,$c0,$ff,$ff,$1f,$ff,$e0
	dc.b	$92,$fb,$95,$fc,$e0,$ff,'w',$07
	dc.b	'?',$ee,$7f,$f0,'G',$ff,'x',$1f
	dc.b	$bb,$fe,$07,$ff,$ff,$f1,$fc,$0f
	dcb.w	24
	dc.b	$18,$1f,$18,$1f,$18,$1f,$18,$1f
	dc.b	$18,$00,$18,$00,$18,$00,$18,$00
	dc.b	$d8,$19,$d8,$19,$d8,$19,$d8,$19
	dc.b	$c3,$00,$c3,$00,$c3,$00,$c3,$00
	dc.b	$c0,$00,$c0,$00,$c0,$00,$c0,$00
	dc.b	$07,$00,$07,$ff,$00,$ff,$07,$00
	dc.b	$00,$00,$ff,$ff,$ff,$ff,$00,$00
	dc.b	'@',$00,$b0,$01,$f0,$00,'p',$01
	dc.b	$80,'@',$7f,$80,'?',$c0,$c1,$c0
	dc.b	$00,$04,$07,$fb,$00,$ff,$07,$07
	dc.b	$0c,$80,$f0,$ff,$ff,$0f,$ff,$f0
	dc.b	'@',$01,$87,$fe,$f0,$ff,'w',$07
	dc.b	'H',$17,$0f,$c8,'w',$ff,'x?'
	dc.b	$f4,$09,$09,$f8,$ff,$f7,$fe,$0f
	dcb.w	24
	dc.b	$18,$1b,$18,$1b,$18,$1b,$18,$1b
	dc.b	$9f,$df,$9f,$df,$9f,$df,$9f,$df
	dc.b	$df,$d8,$df,$d8,$df,$d8,$df,$d8
	dc.b	$c3,$1f,$c3,$1f,$c3,$1f,$c3,$1f
	dc.b	$c0,$00,$c0,$00,$c0,$00,$c0,$00
	dc.b	$01,$ff,$07,$ff,$00,$ff,$07,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$e0,$00,$90,$01,$f0,$00,'p',$01
	dc.b	'>@',$ff,$80,'?',$c0,$c1,$c0
	dc.b	$05,$fe,$07,$f9,$00,$ff,$07,$07
	dc.b	$00,'_',$00,'o',$00,$0f,$00,'p'
	dc.b	$e0,$f9,$87,$fe,$f0,$ff,'w',$07
	dc.b	'O',$d8,$0f,$c6,$7f,$fe,'p>'
	dc.b	$0d,$f9,'1',$f8,'?',$ff,'>',$07
	dcb.w	24
	dc.b	$18,$19,$18,$19,$18,$19,$18,$19
	dc.b	$df,$df,$df,$df,$df,$df,$df,$df
	dc.b	$df,$d8,$df,$d8,$df,$d8,$df,$d8
	dc.b	$c3,$1f,$c3,$1f,$c3,$1f,$c3,$1f
	dc.b	$c0,$00,$c0,$00,$c0,$00,$c0,$00
	dc.b	$04,$ff,$03,$ff,$00,$ff,$07,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	$f0,$01,$80,$01,$f0,$00,'p',$01
	dc.b	'~@',$ff,$80,'?',$c0,$c1,$c0
	dc.b	$06,$fb,$07,$f8,$00,$ff,$07,$07
	dc.b	$00,$7f,$00,$0f,$00,$0f,$00,'p'
	dc.b	$b5,$f9,$c7,$fe,$f0,$ff,'w',$07
	dc.b	'o',$e8,$0f,$e4,$7f,$9c,'p|'
	dc.b	$0b,$fb,$13,$f8,$1c,$ff,$1f,$07
	dcb.w	44
	dc.b	$07,$ff,$00,$ff,$00,$ff,$07,$00
	dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
	dc.b	'0',$01,$00,$01,$f0,$00,$f0,$01
	dc.b	$fe,$00,$ff,$c0,'?',$c0,$c1,$c0
	dc.b	$05,$f9,$06,$f8,$00,$ff,$07,$07
	dc.b	$00,'o',$00,$1f,$00,$0f,$00,'p'
	dc.b	$97,$f8,$e7,$ff,$f0,$ff,'w',$07
	dc.b	$7f,$b0,$0f,$f8,$7f,$88,'px'
	dc.b	$06,$ff,$0f,$f8,$08,$ff,$0f,$07
	dcb.w	44
	dc.b	$06,$ff,$01,$ff,$00,$ff,$07,$00
	dc.b	$ff,$fe,$ff,$fe,$ff,$ff,$00,$01
	dc.b	$80,$01,$90,$01,'p',$00,$f0,$01
	dc.b	$fe,$00,$ff,$c0,'?',$c0,$c1,$c0
	dc.b	$02,$f9,$05,$f8,$00,$ff,$07,$07
	dc.b	$00,'_',$00,'?',$00,$0f,$00,'p'
	dc.b	$87,$f8,$f7,$ff,$f0,$ff,'w',$07
	dc.b	'O',$90,'?',$f0,$7f,$80,'pp'
	dc.b	$04,$f9,$07,$fe,$00,$ff,$07,$07
	dcb.w	44
	dc.b	$05,'M',$02,$82,$01,$ff,$07,$ff
	dc.b	$cf,'1',$0f,$01,$f0,$fe,$ff,$ff
	dc.b	$e0,$01,$c0,$01,' ',$00,$e0,$01
	dc.b	$bc,$00,$c3,$c0,$7f,$c0,$ff,$c0
	dc.b	$04,'0',$02,$cc,$01,$ff,$07,$ff
	dc.b	$00,'?',$00,'`',$00,$1f,$00,$7f
	dc.b	$06,$f0,'w',$0f,$f1,$ff,$f7,$ff
	dc.b	$1b,$c0,'h0w',$80,$7f,$f0
	dc.b	$01,$ec,$06,$0b,$00,$f7,$07,$ff
	dcb.w	44
	dc.b	$02,$98,$05,$07,$03,$ff,$07,$ff
	dc.b	'd',$fc,$84,$00,$fb,$ff,$ff,$ff
	dc.b	$80,$01,$a0,$01,'`',$00,$e0,$01
	dc.b	'f',$00,$81,$c0,$ff,$c0,$ff,$c0
	dc.b	$00,'x',$05,$86,$03,$ff,$07,$ff
	dc.b	$00,'c',$00,'\',$00,'?',$00,$7f
	dc.b	$85,$98,'6',$07,$f3,$ff,$f7,$ff
	dc.b	'9',$f0,'X',$00,'g',$c0,$7f,$f0
	dc.b	$07,$ce,$00,$0d,$01,$f3,$07,$ff
	dcb.w	44
	dc.b	$05,'0',$02,$0f,$07,$ff,$07,$ff
	dc.b	'!',$86,$c0,'x',$ff,$ff,$ff,$ff
	dc.b	$80,$00,'@',$01,$c0,$01,$c0,$01
	dc.b	$c3,$00,$00,$c0,$ff,$c0,$ff,$c0
	dc.b	$00,$8c,$03,$03,$07,$ff,$07,$ff
	dc.b	$00,'A',$00,'>',$00,$7f,$00,$7f
	dc.b	$83,$0c,$14,$03,$f7,$ff,$f7,$ff
	dc.b	'x',$f0,'8',$00,'G',$e0,$7f,$f0
	dc.b	$07,$8f,$00,$0e,$03,$f1,$07,$ff
	dcb.w	209
	dc.b	$00,$07,$00,$00,$00,$00,$00,$00
	dc.b	$e7,$e7,$00,$00,$00,$00,$00,$00
	dc.b	$e7,$e7,$00,$00,$00,$00,$00,$00
	dc.b	$e6,'g',$00,$00,$00,$00,$00,$00
	dc.b	$e7,$e0,$00,$00,$00,$00,$00,$00
	dc.b	$03,$f2,$00,$00,$00,$00,$00,$00
	dc.b	'3',$f0,$00,$00,$00,$00,$00,$00
	dcb.w	51
	dc.b	$00,$0f,$00,$0f,$00,$00,$00,$00
	dc.b	$ef,$ef,$ef,$ef,$00,$00,$00,$00
	dc.b	$ef,$ef,$ef,$ef,$00,$00,$00,$00
	dc.b	$ef,'o',$ef,'o',$00,$00,$00,$00
	dc.b	$ef,$e0,$ef,$e0,$00,$00,$00,$00
	dc.b	$07,$f6,$07,$f6,$00,$00,$00,$00
	dc.b	'7',$f0,'7',$f0,$00,$00,$00,$00
	dcb.w	134
	dc.b	$00,$0f,$00,$00,$00,$00,$00,$00
	dc.b	$ef,$ef,$00,$00,$00,$00,$00,$00
	dc.b	$0f,$ef,$00,$00,$00,$00,$00,$00
	dc.b	$0d,$e1,$00,$00,$00,$00,$00,$00
	dc.b	$8f,$e0,$00,$00,$00,$00,$00,$00
	dc.b	$00,$c7,$00,$00,$00,$00,$00,$00
	dc.b	$f7,$80,$00,$00,$00,$00,$00,$00
	dcb.w	50
	dc.b	$00,$0c,$00,$00,$00,$0c,$00,$00
	dc.b	$0f,$8c,$00,$00,$0f,$8c,$00,$00
	dc.b	$00,'l',$00,$00,$00,'l',$00,$00
	dc.b	$0c,$e1,$00,$00,$0c,$e1,$00,$00
	dc.b	$80,'`',$00,$00,$80,'`',$00,$00
	dc.b	$00,$c6,$00,$00,$00,$c6,$00,$00
	dc.b	'6',$00,$00,$00,'6',$00,$00,$00
	dcb.w	53
	dc.b	$00,$0c,$00,$0c,$00,$00,$00,$00
	dc.b	$0d,$cf,$0d,$cf,$00,$00,$00,$00
	dc.b	$ef,$ef,$ef,$ef,$00,$00,$00,$00
	dc.b	$ec,'a',$ec,'a',$00,$00,$00,$00
	dc.b	$8f,$e0,$8f,$e0,$00,$00,$00,$00
	dc.b	$00,$c6,$00,$c6,$00,$00,$00,$00
	dc.b	'7',$f0,'7',$f0,$00,$00,$00,$00
	dcb.w	51
	dc.b	$00,$0c,$00,$0c,$00,$0c,$00,$00
	dc.b	$0c,$ef,$0c,$ef,$0c,$ef,$00,$00
	dc.b	$ef,$ef,$ef,$ef,$ef,$ef,$00,$00
	dc.b	$ec,'a',$ec,'a',$ec,'a',$00,$00
	dc.b	$8f,$e0,$8f,$e0,$8f,$e0,$00,$00
	dc.b	$00,$c6,$00,$c6,$00,$c6,$00,$00
	dc.b	'7',$f0,'7',$f0,'7',$f0,$00,$00
	dcb.w	404
	dc.b	'r',$13,$8e,$1c,$01,$e0,$ff,$ff
	dc.b	$9c,$d8,'|',$c0,$03,'8',$ff,$f8
	dc.b	'Q ',$b1,$c0,$0e,' ',$ff,$e0
	dcb.w	68
	dc.b	';3G<',$80,$c0,$ff,$ff
	dc.b	's',$98,$f3,$f4,$0c,$0c,$ff,$fc
	dc.b	'+@[',$a0,$84,'`',$ff,$e0
	dcb.w	4
	dc.b	'Q ',$b1,$c0,$0e,' ',$ff,$e0
	dc.b	$06,$f2,$09,$f0,$00,$0e,$0f,$fe
	dc.b	$18,'n(q7',$80,'?',$ff
	dc.b	'vr',$e7,$8c,$18,$02,$ff,$fe
	dc.b	'Q ',$b1,$c0,$0e,' ',$ff,$e0
	dc.b	'~',$f6,$bf,$0e,$c0,$01,$ff,$ff
	dc.b	'g x',$c0,$80,$00,$ff,$e0
	dcb.w	4
	dc.b	'{',$9f,'|',$7f,$00,$00,$7f,$ff
	dc.b	'<',$a0,$c3,$90,$00,'p',$ff,$f0
	dc.b	$03,$f7,$05,$f8,$06,$00,$07,$ff
	dc.b	$b3,'9s',$c6,$0c,$00,$ff,$ff
	dc.b	$03,'6',$01,'1',$02,$cf,$03,$ff
	dc.b	$11,$a0,'O',$80,'``',$7f,$e0
	dc.b	$03,$af,$05,$8f,$06,'p',$07,$ff
	dc.b	'<',$a0,$c3,$90,$00,'p',$ff,$f0
	dc.b	$1d,$f4,'#',$fb,$c0,$00,$ff,$ff
	dc.b	'w4',$f7,$f0,$08,$0c,$ff,$fc
	dc.b	$0a,$80,';`',$c4,$e0,$ff,$e0
	dcb.w	4
	dc.b	'+@[',$a0,$84,'`',$ff,$e0
	dc.b	$0b,'d',$0c,$e2,$00,$1e,$0f,$fe
	dc.b	'lw<xC',$80,$7f,$ff
	dc.b	'&',$e4,$e7,$1a,$18,$06,$ff,$fe
	dc.b	'+A[',$a2,$84,'c',$ff,$e3
	dc.b	$7f,'r',$bf,$8e,$00,$01,$ff,$ff
	dc.b	'n`q',$80,$80,'`',$ff,$e0
	dcb.w	4
	dc.b	'yû>',$7f,'@',$00,$7f,$ff
	dc.b	'8',$d8,$c7,$f4,$00,$0c,$ff,$fc
	dc.b	$0b,$fb,$15,$fc,$18,$00,$1f,$ff
	dc.b	$93,'ss',$8c,$0c,$03,$ff,$ff
	dc.b	$0f,$27,$07,' ',$08,$df,$0f,$ff
	dc.b	$19,$98,'g',$90,$80,'h',$ff,$f8
	dc.b	$0b,$ee,$05,$cf,$08,'0',$0f,$ff
	dc.b	'8',$d8,$c7,$f0,$00,$08,$ff,$f8
	dc.b	$9f,$ff,$00,$00,$e0,$00,$e0,$00
	dc.b	$ff,$ec,$00,'"',$00,$1e,$00,'>'
	dc.b	$9f,$00,$00,$e0,$e0,$e0,$e0,$e0
	dcb.w	4
	dc.b	$0a,$80,';`',$c4,$e0,$ff,$e0
	dc.b	$0d,'H',$0e,$c6,$00,'>',$0f,$fe
	dc.b	't9',$cc,'>',$83,$c0,$ff,$ff
	dc.b	$ad,$c8,'n6',$10,$0e,$ff,$fe
	dc.b	$0a,$82,';e',$c4,$e6,$ff,$e7
	dc.b	$df,'ö?',$e6,$00,$01,$ff,$ff
	dc.b	$dc,$a0,$e3,'@',$00,$e0,$ff,$e0
	dcb.w	4
	dc.b	'}',$1e,$1e,$ff,'`',$00,$7f,$ff
	dc.b	'1',$f4,$cf,$c8,$00,$04,$ff,$fc
	dc.b	$16,$fc,')',$ff,'0',$00,'?',$ff
	dc.b	$d6,$e5,'7',$1a,$08,$07,$ff,$ff
	dc.b	$11,$ae,$0f,$a1,$10,'_',$1f,$ff
	dc.b	$db,'$g8',$80,$c4,$ff,$fc
	dc.b	$16,$fe,$09,$df,$10,' ',$1f,$ff
	dc.b	'1',$f4,$cf,$c8,$00,$04,$ff,$fc
	dc.b	$df,$ff,$00,$00,$e0,$00,$e0,$00
	dc.b	$ff,$fe,$00,$00,$00,$1e,$00,$1e
	dc.b	$df,' ',$00,$c0,$e0,$e0,$e0,$e0
	dcb.w	4
	dc.b	$9f,$00,$00,$e0,$e0,$e0,$e0,$e0
	dc.b	$07,$f0,$0e,$0e,$00,$0e,$0e,$0e
	dc.b	$b7,$ff,'H',$00,$80,$00,$f8,$00
	dc.b	$ff,$f0,$00,$0e,$00,$0e,$00,$0e
	dc.b	$9f,$04,$00,$e3,$e0,$e4,$e0,$e7
	dc.b	$df,$ff,' ',$00,$00,$00,$e0,$00
	dc.b	$ff,' ',$00,$c0,$00,$e0,$00,$e0
	dcb.w	4
	dc.b	'?',$ff,$00,$00,'p',$00,'p',$00
	dc.b	$ff,$ac,$00,'^',$00,$02,$00,'~'
	dc.b	'&',$ff,$19,$00,' ',$00,'?',$00
	dc.b	$ff,$f9,$00,$06,$00,$07,$00,$07
	dc.b	'!',$fe,$1f,$01,' ',$03,'?',$03
	dc.b	$df,$ac,'`>',$80,'B',$e0,'~'
	dc.b	'&',$ff,$19,$00,' ',$00,'?',$00
	dc.b	$ff,$ac,$00,'^',$00,$02,$00,'~'
	dc.b	$ff,$ff,$00,$00,$e0,$00,$e0,$00
	dc.b	$ff,$f8,$00,$06,$00,$0e,$00,$0e
	dc.b	$ff,'`',$00,$80,$e0,$e0,$e0,$e0
	dcb.w	4
	dc.b	$df,$00,$00,$e0,$e0,$e0,$e0,$e0
	dc.b	$03,$f0,$0e,$0e,$00,$0e,$0e,$0e
	dc.b	$cf,$ff,$f0,$00,$00,$00,$f0,$00
	dc.b	$ff,$f6,$00,$08,$00,$0e,$00,$0e
	dc.b	$df,$02,$00,$ed,$e0,$e8,$e0,$ef
	dc.b	$7f,$ff,$80,$00,$00,$00,$80,$00
	dc.b	$ff,'`',$00,$a0,$00,$c0,$00,$e0
	dcb.w	4
	dc.b	$1f,$ff,$00,$00,'p',$00,'p',$00
	dc.b	$ff,$fa,$00,$18,$00,$06,$00,$1e
	dc.b	$13,$ff,'l',$00,'@',$00,'|',$00
	dc.b	$ff,$fb,$00,$05,$00,$06,$00,$07
	dc.b	'3',$ff,'<',$00,$00,$00,'<',$00
	dc.b	$ff,$f2,$00,$10,$80,$0e,$80,$1e
	dc.b	$13,$ff,',',$00,$00,$00,'<',$00
	dc.b	$ff,$fa,$00,$18,$00,$06,$00,$1e
	dc.b	$80,$00,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$00,$00,$ff,$fe,$00,$0e,$00,$0e
	dc.b	' ',$e0,$1f,$00,$e0,$e0,$e0,$e0
	dcb.w	4
	dc.b	$e0,' ',$1f,$c0,$e0,$e0,$e0,$e0
	dc.b	$08,$00,$07,$fe,$00,$0e,$0e,$0e
	dc.b	$e0,$00,$ff,$ff,$00,$00,$e0,$00
	dc.b	$00,$08,$ff,$f0,$00,$0e,$00,$0e
	dc.b	$e0,'+',$1f,$c4,$e0,$e8,$e0,$ef
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$a0,$ff,' ',$00,$c0,$00,$e0
	dcb.w	4
	dc.b	$10,$00,$0f,$ff,'p',$00,'p',$00
	dc.b	$00,$06,$ff,$f0,$00,$0e,$00,$0e
	dc.b	'X',$00,$27,$ff,'@',$00,'x',$00
	dc.b	$00,$05,$ff,$f9,$00,$06,$00,$07
	dc.b	'X',$00,$1f,$ff,'`',$00,'x',$00
	dc.b	$00,$0e,$ff,$f0,$00,$0e,$00,$0e
	dc.b	'X',$00,$27,$ff,'@',$00,'x',$00
	dc.b	$00,$07,$ff,$f0,$00,$0f,$00,$0f
	dc.b	$00,$00,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$00,$00,$ff,$fe,$00,$0e,$00,$0e
	dc.b	$00,$a0,$1f,$00,$e0,$e0,$e0,$e0
	dcb.w	4
	dc.b	' `',$1f,$80,$e0,$e0,$e0,$e0
	dc.b	$0e,$02,$01,$fc,$00,$0e,$0e,$0e
	dc.b	'`',$00,$7f,$ff,$80,$00,$e0,$00
	dc.b	$00,$00,$ff,$f0,$00,$0e,$00,$0e
	dc.b	' l',$1f,$87,$e0,$e8,$e0,$ef
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,' ',$ff,$00,$00,$e0,$00,$e0
	dcb.w	4
	dc.b	'@',$00,'O',$ff,'0',$00,'p',$00
	dc.b	$00,$0c,$ff,$f3,$00,$0f,$00,$0f
	dc.b	'`',$00,'?',$ff,'@',$00,'x',$00
	dc.b	$00,$01,$ff,$f8,$00,$07,$00,$07
	dc.b	$00,$00,$07,$ff,'x',$00,'x',$00
	dc.b	$00,$0e,$ff,$f1,$00,$0f,$00,$0f
	dc.b	'`',$00,$7f,$ff,$00,$00,'x',$00
	dc.b	$00,$0d,$ff,$f2,$00,$0f,$00,$0f
	dc.b	$e0,$00,$1f,$ff,$ff,$ff,$ff,$ff
	dc.b	$02,$00,$fd,$fe,$fe,$0e,$fe,$0e
	dc.b	'@ _',$00,$a0,$e0,$e0,$e0
	dcb.w	4
	dc.b	$00,$c0,$1f,$00,$e0,$e0,$e0,$e0
	dc.b	$0e,$06,$01,$f8,$00,$0e,$0e,$0e
	dc.b	$80,$00,$1f,$ff,$e0,$00,$e0,$00
	dc.b	$00,$0e,$ff,$f0,$00,$0e,$00,$0e
	dc.b	$00,$ce,$1f,$07,$e0,$e8,$e0,$ee
	dc.b	$00,$00,$ff,$ff,$00,$00,$00,$00
	dc.b	$00,$e0,$ff,$00,$00,$e0,$00,$e0
	dcb.w	4
	dc.b	'`',$00,'o',$ff,$10,$00,'p',$00
	dc.b	$00,$00,$ff,$ff,$00,$07,$00,$07
	dc.b	'p',$00,'?',$ff,'@',$00,'p',$00
	dc.b	$00,$07,$ff,$f8,$00,$07,$00,$07
	dc.b	$00,$00,$0f,$ff,'p',$00,'p',$00
	dc.b	$00,$04,$ff,$fb,$00,$07,$00,$07
	dc.b	'0',$00,'?',$ff,'@',$00,'p',$00
	dc.b	$00,$01,$ff,$fe,$00,$07,$00,$07
	dc.b	$e7,$8d,$87,$f3,'x',$00,$ff,$ff
	dc.b	'k',$f0,'w',$fe,$80,$0e,$fe,$0e
	dc.b	$ff,' ',$ff,$00,$00,$e0,$e0,$e0
	dcb.w	4
	dc.b	'_',$80,'_',$00,$a0,$e0,$e0,$e0
	dc.b	$09,$fe,$07,$f0,$00,$0e,$0e,$0e
	dc.b	$df,'@',$1f,'?',$e0,$ff,$e0,$ff
	dc.b	'<',$0e,$c3,$f0,$ff,$fe,$ff,$fe
	dc.b	'_',$87,'_',$07,$a0,$e8,$e0,$ee
	dc.b	$f8,$00,$ff,$ff,$07,$ff,$07,$ff
	dc.b	$00,' ',$ff,$c0,$ff,$e0,$ff,$e0
	dcb.w	4
	dc.b	'o',$80,'o',$ff,$10,$7f,'p',$7f
	dc.b	$07,$f9,$f9,$fe,$fe,$07,$fe,$07
	dc.b	'?',$c0,'?',$ff,'@?p?'
	dc.b	$00,$01,$ff,$fe,$ff,$ff,$ff,$ff
	dc.b	'/',$c7,'/',$c7,'P8p8'
	dc.b	$f1,$f8,$f1,$ff,$0e,$07,$0e,$07
	dc.b	'?',$c0,'?',$ff,'@?p?'
	dc.b	$07,$f8,$f9,$fe,$fe,$07,$fe,$07
	dc.b	$df,$ff,$df,$ff,' ',$00,$e0,$00
	dc.b	$ff,$f0,$ff,$fe,$00,$0e,$00,$0e
	dc.b	$ff,'`',$ff,$00,$00,$e0,$e0,$e0
	dcb.w	4
	dc.b	$ff,$80,$ff,$00,$00,$e0,$e0,$e0
	dc.b	$01,$fa,$0f,$f0,$00,$0e,$0e,$0e
	dc.b	$9f,$cc,$1f,$f3,$e0,$00,$e0,$ff
	dc.b	$e0,$ee,$e0,$f8,$1f,$06,$ff,$fe
	dc.b	$ff,$83,$ff,$03,$00,$ec,$e0,$ee
	dc.b	$f3,$ca,$f4,';',$08,$04,$0f,$ff
	dc.b	$f2,' ',$0e,$c0,$01,$e0,$ff,$e0
	dcb.w	4
	dc.b	'o',$c0,'o',$bf,$10,$7f,'p',$7f
	dc.b	'|',$fb,$81,$fc,$fe,$07,$ff,$07
	dc.b	$1f,$9e,$1f,$a1,'`@p',$7f
	dc.b	'W',$91,$d8,'v ',$0f,$ff,$ff
	dc.b	$7f,$e7,$7f,$87,$00,'xp|'
	dc.b	$fb,$f9,$e3,$fe,$1c,$07,$1f,$07
	dc.b	$1f,$80,$1f,$ff,'`',$7f,'p',$7f
	dc.b	'|',$fa,$81,$fc,$fe,$07,$ff,$07
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$e0,$00
	dc.b	$ff,$e0,$ff,$fe,$00,$1e,$00,$1e
	dc.b	$bf,$c0,$ff,' ',$00,$e0,$e0,$e0
	dcb.w	4
	dc.b	$ff,$80,$ff,$00,$00,$e0,$e0,$e0
	dc.b	$03,$f0,$0f,$f0,$00,$0e,$0e,$0e
	dc.b	'?',$ff,'?',$ff,$c0,$00,$e0,$00
	dc.b	$ff,$d8,$ff,$e4,$00,$00,$00,'<'
	dc.b	$ff,$83,$ff,$03,$00,$ec,$e0,$ee
	dc.b	$ff,$ff,$ff,$ff,$00,$00,$00,$00
	dc.b	$ff,' ',$ff,$c0,$00,$e0,$00,$e0
	dcb.w	4
	dc.b	$1f,$e1,$7f,$9e,$00,$7f,'p',$7f
	dc.b	$89,$fc,$02,$f8,$fc,$07,$ff,$07
	dc.b	$1f,$ff,$1f,$ff,'`',$00,'p',$00
	dc.b	$ff,$f9,$ff,$fe,$00,$07,$00,$07
	dc.b	$7f,$bf,$7f,$cf,$00,'pp|'
	dc.b	$e0,$f9,$ff,$fe,$1c,$07,$1f,$07
	dc.b	$1f,$81,$1f,$fe,'`',$7f,'p',$7f
	dc.b	$89,$fc,$02,$f8,$fc,$07,$ff,$07
	dc.b	$a0,$00,$e0,$00,$1f,$ff,$e0,$00
	dc.b	$00,$0c,$00,'0',$ff,$fc,$00,'<'
	dc.b	$00,$80,$e0,'`',$1f,$e0,$e0,$e0
	dcb.w	4
	dc.b	$a0,$80,$e0,$00,$1f,$e0,$e0,$e0
	dc.b	$0e,$04,$0e,$04,$01,$fa,$0e,$0e
	dc.b	$e0,$00,$e0,$00,$1f,$ff,$e0,$00
	dc.b	$00,$16,$00,$0e,$ff,$e0,$00,$1e
	dc.b	$a0,$88,$e0,$08,$1f,$e7,$e0,$ee
	dcb.w	2
	dc.b	$ff,$ff,$00,$00,$00,'`',$00,$80
	dc.b	$ff,$e0,$00,$e0,$00,$00,$00,$00
	dcb.w	2
	dc.b	' pP',$00,$0f,$f0,'pp'
	dc.b	$03,$04,$04,$00,$00,$ff,$07,$07
	dc.b	'@',$00,'@',$00,'?',$ff,'p',$00
	dc.b	$00,$03,$00,$04,$ff,$ff,$00,$07
	dc.b	'P',$1c,'pl',$0f,$f3,'p|'
	dc.b	$04,$03,$1b,$04,$fc,$ff,$1f,$07
	dc.b	'@',$00,'@p?',$f0,'pp'
	dc.b	$03,$01,$04,$01,$00,$fe,$07,$07
	dc.b	$00,$00,$e0,$00,$1f,$ff,$e0,$00
	dc.b	$00,$06,$00,$00,$ff,$fe,$00,$1e
	dc.b	'@ ',$a0,$c0,$1f,$e0,$e0,$e0
	dcb.w	4
	dc.b	$00,$80,$e0,$00,$1f,$e0,$e0,$e0
	dc.b	$00,$04,$00,$04,$0f,$fa,$0e,$0e
	dc.b	$80,$00,$e0,$00,$1f,$ff,$e0,$00
	dc.b	$00,$0c,$00,$0c,$ff,$f2,$00,$0e
	dc.b	$00,$84,$e0,$0c,$1f,$e3,$e0,$ee
	dcb.w	2
	dc.b	$ff,$ff,$00,$00,$00,$c0,$00,$00
	dc.b	$ff,$e0,$00,$e0,$00,$00,$00,$00
	dcb.w	2
	dc.b	' @P0',$0f,$f0,'pp'
	dc.b	$03,$04,$04,$00,$00,$ff,$07,$07
	dc.b	' ',$00,'`',$00,$1f,$ff,'p',$00
	dc.b	$00,$06,$00,$00,$ff,$ff,$00,$07
	dc.b	$00,'Dp<',$0f,$f3,'p|'
	dc.b	$0d,$03,$12,$04,$fc,$ff,$1f,$07
	dc.b	' ',$00,'`p',$1f,$f0,'pp'
	dc.b	$03,$06,$04,$07,$00,$f8,$07,$07
	dc.b	'_',$ff,$a0,$00,$1f,$ff,$e0,$00
	dc.b	$ff,$fc,$00,$02,$ff,$fe,$00,$0e
	dc.b	'_C',$a0,$b0,$1f,$cf,$e0,$ff
	dc.b	$f8,$e0,$00,$fc,$ff,$02,$ff,$fe
	dc.b	'_',$c0,$a0,$00,$1f,$e0,$e0,$e0
	dc.b	$09,$f0,$08,$00,$07,$fe,$0e,$0e
	dc.b	$af,$ff,'`',$00,$9f,$ff,$f0,$00
	dc.b	$ff,$f2,$00,$00,$ff,$fe,$00,$0e
	dc.b	'_',$c3,$a0,$0e,$1f,$e1,$e0,$ee
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,'@',$00,$80,$ff,$e0,$00,$e0
	dcb.w	4
	dc.b	$7f,$80,$00,'p',$0f,$f0,'pp'
	dc.b	$05,$fc,$06,$00,$00,$ff,$07,$07
	dc.b	$1f,$ff,'p',$00,$0f,$ff,'p',$00
	dc.b	$ff,$fa,$00,$04,$ff,$ff,$00,$07
	dc.b	'/',$e3,'P',$1c,$0f,$f3,'p|'
	dc.b	$ff,$fb,$00,$04,$fc,$ff,$1f,$07
	dc.b	$1f,$b0,'p@',$0f,$f0,'pp'
	dc.b	$05,$f8,$06,$07,$00,$f8,$07,$07
	dc.b	$ff,$1c,$00,$e3,$1f,$ff,$e0,$ff
	dc.b	$01,$f0,$fe,$0e,$ff,$fe,$fe,$0e
	dc.b	$1f,$88,$e0,'x',$1f,$87,$e0,$ff
	dc.b	$e1,$80,$01,$fa,$fe,$06,$ff,$fe
	dc.b	$ff,$95,$00,$1b,$1f,$e0,$e0,$ff
	dc.b	$a5,$fa,$bc,$00,'C',$fe,$fe,$0e
	dc.b	'_',$ff,'@',$00,'?',$ff,'x',$00
	dc.b	$ff,$fe,$00,$00,$ff,$fe,$00,$0e
	dc.b	$ff,$cd,$00,$02,$1f,$e1,$e0,$ee
	dc.b	$ff,$ff,$00,$00,$ff,$ff,$00,$00
	dc.b	$ff,$00,$00,$c0,$ff,$e0,$00,$e0
	dcb.w	4
	dc.b	$7f,$99,$00,'n',$0f,$f0,'p',$7f
	dc.b	'6',$fd,$f7,$00,$08,$ff,$ff,$07
	dc.b	'o',$ff,$10,$00,$0f,$ff,'p',$00
	dc.b	$ff,$f8,$00,$06,$ff,$ff,$00,$07
	dc.b	$7f,$eb,$00,$14,$0f,$f3,'p|'
	dc.b	$f7,$fb,$00,$04,$fc,$ff,$1f,$07
	dc.b	'o',$e1,$10,$06,$0f,$f8,'p',$7f
	dc.b	'6',$f9,$f7,$07,$08,$f8,$ff,$07
	dc.b	$ff,$cf,$00,$f0,$1f,$00,$e0,$ff
	dc.b	'9',$f0,$fe,$0e,$01,$fe,$fe,$0e
	dc.b	$1f,$1c,$e0,$fc,$1f,$03,$e0,$ff
	dc.b	$0f,$02,$0f,$f4,$f0,$0e,$ff,$fe
	dc.b	$ff,',',$e0,'3',$1f,$c0,$e0,$ff
	dc.b	$93,$fe
	sub.b	d0,d7
l005d	bsr.s	l005d
	dc.b	$fe,$0e,$dc,$c0,$b0,'?',$0f,$ff
	dc.b	$ff,$ff,$1d,$f0,$e0,$0e,$ff,$fe
	dc.b	$fe,$0e,$ff,'o',$00,$80,$1f,$e1
	dc.b	$e0,$ee,$f0,$00,$0f,$ff,$ff,$ff
	dc.b	$0f,$ff,$00,' ',$ff,$e0,$ff,$c0
	dc.b	$ff,$e0,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,'o',$bb,$10,'\',$0f,$e0
	dc.b	'p',$7f,$b2,$fb,'s',$04,$0c,$ff
	dc.b	$ff,$07,$7f,$80,$00,$7f,$0f,$ff
	dc.b	'p',$7f,$00,$01,$ff,$ff,$ff,$fe
	dc.b	$ff,$ff,$7f,$bf,$00,'@',$0f,$f3
	dc.b	'p|',$f7,$fb,$00,$04,$fc,$ff
	dc.b	$1f,$07,$7f,$cb,$00,$0c,$0f,$f0
	dc.b	'p',$7f,$b2,$fe,'s',$06,$0c,$f9
	dc.b	$ff,$07,'@',$00,$bf,$ff,$1f,$ff
	dc.b	$e0,$00,$00,$00,$ff,$fe,$ff,$fe
	dc.b	$00,$0e,$80,$00,$ff,$ff,$1f,$ff
	dc.b	$e0,$00,$00,$04,$ff,$f8,$ff,$fe
	dc.b	$00,$0e,$e0,'^',$ff,$e1,$1f,$80
	dc.b	$e0,$7f,$90,$06,$9f,$f8,'c',$fe
	dc.b	$fc,$0e,$f1,$99,$cf,$9e,$00,'`'
	dc.b	$ff,$ff,$b0,$00,'q',$fe,$0f,$fe
	dc.b	$fe,$0e,'@l',$bf,$83,$1f,$e1
	dc.b	$e0,$ee,$02,'s',$fb,$8f,$fc,$00
	dc.b	$07,$ff,'é`',$fe,$a0,$01,$c0
	dc.b	$ff,$e0,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,' g_',$b8,$0f,$c0
	dc.b	'p',$7f,$88,$02,'y',$fd,$07,$ff
	dc.b	$fe,$07,'`',$13,$1f,$dc,$0f,$e0
	dc.b	'p?',$9c,'s',$7f,$f5,$00,$0e
	dc.b	$ff,$ff,' <_',$c3,$0f,$f3
	dc.b	'p|',$15,$03,$e2,$fc,$fc,$ff
	dc.b	$1f,$07,'`',$1f,$1f,$d8,$0f,$e0
	dc.b	'p?',$88,$02,'y',$fc,$07,$ff
	dc.b	$fe,$07,$00,$00,$ff,$ff,$1f,$ff
	dc.b	$e0,$00,$00,$00,$ff,$fe,$ff,$fe
	dc.b	$00,$0e,$e0,$00,$ff,$ff,$1f,$ff
	dc.b	$e0,$00,$00,$0c,$ff,$f0,$ff,$fe
	dc.b	$00,$0e,$00,$00,$ff,$ff,$1f,$ff
	dc.b	$e0,$00,$00,$02,$ff,$fc,$ff,$fe
	dc.b	$00,$0e,$e0,$00,$ff,$ff,$1f,$ff
	dc.b	$e0,$00,$00,$08,$ff,$f6,$ff,$fe
	dc.b	$00,$0e,$00,' ',$ff,$cf,$1f,$e1
	dc.b	$e0,$ee,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$00,$e0,$ff,' ',$ff,$c0
	dc.b	$00,$e0,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$10,$00,$7f,$ff,$0f,$ff
	dc.b	'p',$00,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$00,$07,$00,$00,$7f,$ff,$0f,$ff
	dc.b	'p',$00,$00,$07,$ff,$f9,$ff,$fe
	dc.b	$00,$07,$00,$18,$7f,$e7,$0f,$f3
	dc.b	'p|',$14,$03,$e3,$fc,$fc,$ff
	dc.b	$1f,$07,$00,$00,$7f,$ff,$0f,$ff
	dc.b	'p',$00,$00,$01,$ff,$fe,$ff,$ff
	dc.b	$00,$07,$00,$00,$ff,$ff,$1f,$ff
	dc.b	$e0,$00,$00,$08,$ff,$f6,$ff,$fe
	dc.b	$00,$0e,$c0,$00,$ff,$ff,$1f,$ff
	dc.b	$e0,$00,$00,$0c,$ff,$f0,$ff,$fe
	dc.b	$00,$0e,$b0,$00,$ff,$ff,$0f,$ff
	dc.b	$f0,$00,$00,$00,$ff,$fe,$ff,$fe
	dc.b	$00,$1e,' ',$00,$ff,$ff,$1f,$ff
	dc.b	$e0,$00,$00,$0c,$ff,$f2,$ff,$fe
	dc.b	$00,$0e,$00,'+',$ff,$cf,$1f,$e0
	dc.b	$e0,$ef,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$00,$c0,$ff,$00,$ff,$e0
	dc.b	$00,$e0,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,'p',$00,$7f,$ff,$0f,$ff
	dc.b	'p',$00,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$00,$0f,'X',$00,$7f,$ff,$07,$ff
	dc.b	'x',$00,$00,$06,$ff,$f8,$ff,$ff
	dc.b	$00,$07,$00,$10,$7f,$ef,$0f,$f3
	dc.b	'p|',$15,$03,$e2,$fc,$fc,$ff
	dc.b	$1f,$07,'X',$00,$7f,$ff,$07,$ff
	dc.b	'x',$00,$00,$01,$ff,$fe,$ff,$ff
	dc.b	$00,$0f,$a0,$00,$ff,$ff,$1f,$ff
	dc.b	$e0,$00,$00,$1e,$ff,$e0,$ff,$fe
	dc.b	$00,$1e,$90,$00,$ff,$ff,$0f,$ff
	dc.b	$f0,$00,$00,$06,$ff,$f8,$ff,$fe
	dc.b	$00,$0e,$e0,$00,'o',$ff,$9f,$ff
	dc.b	$f0,$00,$00,$10,$ff,$ee,$ff,$fe
	dc.b	$00,$1e,$80,$00,$7f,$ff,$1f,$ff
	dc.b	$e0,$00,$00,$0e,$ff,$f0,$ff,$fe
	dc.b	$00,$0e,$a0,'.',$ff,$c6,$1f,$e9
	dc.b	$e0,$ef,$00,$00,$ff,$ff,$ff,$ff
	dc.b	$00,$00,$00,$80,$ff,'@',$ff,$e0
	dc.b	$00,$e0,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,'`',$00,$7f,$ff,$0f,$ff
	dc.b	'p',$00,$00,$08,$ff,$f6,$ff,$fe
	dc.b	$00,$0e,'p',$00,'7',$ff,'O',$ff
	dc.b	'x',$00,$00,$04,$ff,$fa,$ff,$ff
	dc.b	$00,$07,'P',$10,$7f,$ef,$0f,$f3
	dc.b	'p|',$1f,$03,$e0,$fc,$fc,$ff
	dc.b	$1f,$07,'p',$00,'7',$ff,'O',$ff
	dc.b	'x',$00,$00,$09,$ff,$f6,$ff,$ff
	dc.b	$00,$0f,$ff,$ff,$ff,$ff,$1f,$ff
	dc.b	$e0,$00,$ff,$e4,$ff,$c2,$ff,$fe
	dc.b	$00,'>',$b7,$ff,'w',$ff,$8f,$ff
	dc.b	$f8,$00,$ff,$f2,$ff,$fc,$ff,$fe
	dc.b	$00,$0e,'O',$ff,$cf,$ff,$b7,$ff
	dc.b	$f8,$00,$ff,$d8,$ff,$c4,$ff,$fc
	dc.b	$00,'<',$ff,$ff,$1f,$ff,$1f,$ff
	dc.b	$e0,$00,$ff,$e6,$ff,$e0,$ff,$fe
	dc.b	$00,$1e,$ff,$04,$ff,$ec,$1f,$eb
	dc.b	$e0,$ef,$ff,$ff,$ff,$ff,$7f,$ff
	dc.b	$80,$00,$ff,$00,$ff,$c0,$ff,$e0
	dc.b	$00,$e0,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,'_',$ff,'o',$ff,$0f,$ff
	dc.b	'p',$00,$ff,$ec,$ff,$e2,$ff,$fe
	dc.b	$00,$1e,$27,$ff,'g',$ff,'[',$ff
	dc.b	'|',$00,$ff,$f8,$ff,$fe,$ff,$ff
	dc.b	$00,$07,$7f,$87,$7f,$ff,$0f,$f3
	dc.b	'p|',$ee,$f9,$f1,$fe,$fc,$ff
	dc.b	$1f,$07,$27,$ff,'g',$ff,'[',$ff
	dc.b	'|',$00,$ff,$ec,$ff,$e2,$ff,$fe
	dc.b	$00,$1e,$de,$1f,$e1,$e0,'?',$ff
	dc.b	$ff,$ff,$e0,'4',$1f,$c0,$ff,$fc
	dc.b	$ff,$fc,'v9',$f1,$c1,$8f,$fe
	dc.b	$ff,$ff,$e6,'8',$e0,'6',$1f,$ce
	dc.b	$ff,$fe,'S',$ff,$1f,$ff,'a',$ff
	dc.b	'~',$00,$ff,$c8,$ff,$04,$ff,$fc
	dc.b	$00,$fc,$df,$ff,'?',$ff,$1f,$ff
	dc.b	$e0,$00,$ff,$d0,$ff,$d2,$ff,$ee
	dc.b	$00,'>',$ff,$05,$ff,$e1,$1f,$e6
	dc.b	$e0,$e7,'?',$ff,$ff,$ff,$1f,$ff
	dc.b	$e0,$00,$ff,$00,$ff,$c0,$ff,$e0
	dc.b	$00,$e0,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,'/',$ff,'_',$ff,$0f,$ff
	dc.b	'p',$00,$ff,$e4,$ff,$82,$ff,$fe
	dc.b	$00,'~)',$ff,$0f,$ff,'0',$ff
	dc.b	'?',$00,$ff,$f8,$ff,$fe,$ff,$ff
	dc.b	$00,$07,$7f,$8f,$7f,$ff,$0f,$f3
	dc.b	'p|',$ed,$f9,$f3,$fe,$fc,$ff
	dc.b	$1f,$07,')',$ff,$0f,$ff,'0',$ff
	dc.b	'?',$00,$ff,$e4,$ff,$82,$ff,$fe
	dc.b	$00,'~',$b3,$0f,$c0,$f0,$7f,$ff
	dc.b	$ff,$ff,'<',$18,$03,$e0,$ff,$f8
	dc.b	$ff,$f8,'D',$0c,$03,$f0,$7f,$ff
	dc.b	$7f,$ff,$9f,$9c,$80,$1a,$7f,$e6
	dc.b	$ff,$fe,'$',$0f,'\',$f0,'c',$ff
	dc.b	$7f,$ff,$00,$e0,$ff,$08,$ff,$f8
	dc.b	$ff,$f8,$a9,$b9,'PA?',$fe
	dc.b	$ff,$ff,$e6,'<',$e0,'8',$1f,$c4
	dc.b	$ff,$fc,$de,$02,$e1,$e5,'?',$e6
	dc.b	$ff,$e7,'B4',$cd,$c3,'?',$ff
	dc.b	$ff,$ff,'c',$00,$80,$c0,$ff,$e0
	dc.b	$ff,$e0,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,'C',$00,',',$ff,$1f,$ff
	dc.b	$7f,$ff,$f0,'p',$0f,$84,$ff,$fc
	dc.b	$ff,$fc,$12,$11,'.n1',$ff
	dc.b	'?',$ff,$a3,$18,$1c,$06,$ff,$ff
	dc.b	$ff,$ff,'o',$08,'p',$fb,$1f,$f7
	dc.b	$7f,$ff,$87,$f0,$1a,$07,$fd,$ff
	dc.b	$ff,$ff,$12,'p.',$0f,'1',$ff
	dc.b	'?',$ff,$f0,'p',$0f,$84,$ff,$fc
	dc.b	$ff,$fc,$01,$fc,$fe,$03,$ff,$ff
	dc.b	$ff,$ff,'<@',$c3,$b0,$ff,$f0
	dc.b	$ff,$f0,$1c,$04,'#',$f8,'?',$ff
	dc.b	'?',$ff,'0',$ce,$0f,$0c,$ff,$f2
	dc.b	$ff,$fe,$19,'0(',$c0,'7',$ff
	dc.b	'?',$ff,$e0,'`',$1f,$90,$ff,$f0
	dc.b	$ff,$f0,'S',$0c,$a0,$f0,$7f,$ff
	dc.b	$ff,$ff,$9f,$90,$80,$14,$7f,$ec
	dc.b	$ff,$fc,$b3,$01,$c0,$e2,$7f,$e3
	dc.b	$ff,$e3,$96,'f',$89,$81,$7f,$ff
	dc.b	$ff,$ff,'q',$80,$80,'@',$ff,$e0
	dc.b	$ff,$e0,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$07,$c1,'X>?',$ff
	dc.b	$7f,$ff,$9c,'p',$03,$88,$ff,$f8
	dc.b	$ff,$f8,$0c,$b3,$14,'L',$1b,$ff
	dc.b	$1f,$ff,'3',$8c,$0c,$02,$ff,$ff
	dc.b	$ff,$ff,'YÅ`v?',$ff
	dc.b	$7f,$ff,$c2,'8',$0d,$c3,$ff,$ff
	dc.b	$ff,$ff,$0c,$9f,$14,'@',$1b,$ff
	dc.b	$1f,$ff,$9c,'p',$03,$88,$ff,$f8
	dc.b	$ff,$f8,$00,$00,$00,$00,$00,$00
	dcb.w	13
	dc.b	$02,'`',$05,$80,$07,$ff,$07,$ff
	dc.b	'8',$00,$07,$c0,$ff,$c0,$ff,$c0
	dc.b	$a6,$04,'A',$f8,$ff,$ff,$ff,$ff
	dc.b	'0',$d0,$0f,$08,$ff,$f8,$ff,$f8
	dc.b	'a',$80,$80,'`',$ff,$e0,$ff,$e0
	dc.b	'.',$c6,'Q',$01,$7f,$ff,$7f,$ff
	dc.b	'x',$c0,$80,$00,$ff,$e0,$ff,$e0
	dcb.w	4
	dc.b	$08,$fb,'0',$04,$7f,$ff,$7f,$ff
	dc.b	$06,$00,$01,$e0,$ff,$e0,$ff,$e0
	dc.b	$01,'v',$02,$88,$03,$ff,$03,$ff
	dc.b	'3',$c6,$0c,$00,$ff,$ff,$ff,$ff
	dc.b	'0',$c3,'@<',$7f,$ff,$7f,$ff
	dc.b	$e0,$18,$07,$e1,$ff,$ff,$ff,$ff
	dc.b	$01,'G',$02,$80,$03,$ff,$03,$ff
	dc.b	$06,$00,$01,$e0,$ff,$e0,$ff,$e0
	dc.b	$00,$00,$00,$04,$00,$08,$00,$0c
	dc.b	$00,$03,$00,$07,$00,$0b,$00,$0f
	dc.b	$00,$01,$00,$01,$00,$01,$00,$01
	dc.b	$00,$80,$00,'T',$00,'*',$00,$00
	bra.s	l005e
	dc.b	$00,$00,$1a,$f4,$00,$00,$00,$00
	dcb.w	9
l005e	jsr	$10.l
	move.l	#$18,$4d2.l
l005f	bra	l0063
	bra	l0062
l0060	bra	l0068
	bra	l0061
	pea	(a0)
	lea	l00bd(pc),a0
	move.b	d0,(a0)
	movea.l	(a7)+,a0
	rts

l0061	pea	(a0)
	andi.b	#$1f,d0
	lea	l00a9(pc),a0
	move.b	d0,(a0)+
	move.b	d0,(a0)+
	move.b	#0,(a0)+
	movea.l	(a7)+,a0
	rts

l0062	movem.l	a0-a6/d0-d7,-(a7)
	lea	l00bf(pc),a0
	bsr	l0066
	movea.l	l00b9(pc),a1
	add.w	d0,d0
	add.w	d0,d0
	adda.w	d0,a1
	lea	l00bb(pc),a6
	move.w	(a1)+,(a6)
	moveq	#0,d0
	move.w	(a1)+,d0
	bsr	l0080
	movem.l	(a7)+,a0-a6/d0-d7
	rts

l0063	movem.l	a0-a6/d0-d7,-(a7)
	bsr.s	l0064
	movem.l	(a7)+,a0-a6/d0-d7
	rts

l0064	lea	l00bf(pc),a0
	bsr.s	l0066
	tst.w	d0
	beq.s	l0065
	subq.w	#1,d0
	movea.l	l00b8(pc),a1
	mulu	#6,d0
	adda.w	d0,a1
	move.w	(a1)+,d0
	move.w	(a1)+,d1
	lea	l00ac(pc),a6
	move.w	(a1)+,(a6)
	bsr	l007d
	rts

l0065	lea	l00ad(pc),a0
	st	(a0)
	bra	l0068
l0066	move.w	l00a7(pc),d7
	bne.s	l0067
	lea	l00bc(pc),a6
	move.l	a0,(a6)
	movea.l	4(a0),a1
	adda.l	a0,a1
	lea	l00b5(pc),a6
	move.l	a1,(a6)
	movea.l	8(a0),a1
	adda.l	a0,a1
	lea	l00b6(pc),a6
	move.l	a1,(a6)
	movea.l	12(a0),a1
	adda.l	a0,a1
	lea	l00b4(pc),a6
	move.l	a1,(a6)
	movea.l	16(a0),a1
	adda.l	a0,a1
	lea	l00b7(pc),a6
	move.l	a1,(a6)
	movea.l	20(a0),a1
	adda.l	a0,a1
	lea	l00b8(pc),a6
	move.l	a1,(a6)+
	movea.l	24(a0),a1
	adda.l	a0,a1
	move.l	a1,(a6)+
	lea	l00a7(pc),a6
	st	(a6)
	lea	l00ba(pc),a6
	move.w	#0,(a6)
l0067	rts

l0068	lea	l00a9(pc),a0
	tst.b	(a0)
	beq.s	l006a
	subq.b	#1,1(a0)
	bpl.s	l006a
	move.b	(a0),1(a0)
	addq.w	#1,2(a0)
	move.w	2(a0),d0
	cmp.w	#$a,d0
	bne.s	l0069
	clr.l	(a0)
	lea	l00ad(pc),a0
	st	(a0)
	bra.s	l006a
l0069	lea	l00a8(pc),a0
	move.b	0(a0,d0.w),d0
	lea	l00af(pc),a0
	move.b	d0,(a0)
	move.b	d0,54(a0)
	move.b	d0,108(a0)
l006a	lea	l00a5(pc),a6
	lea	l00ab(pc),a5
	tst.b	4(a5)
	beq.s	l006c
	tst.b	5(a5)
	bne.s	l006b
	st	5(a5)
	moveq	#0,d0
	move.b	d0,34(a6)
	move.b	d0,38(a6)
	move.b	d0,42(a6)
	move.b	l00bd(pc),d1
	bne.s	l006b
	movem.l	28(a6),d0-d3
	movem.l	d0-d3,$ffff8800.w
l006b	rts

l006c	subq.w	#1,(a5)+
	bne.s	l006d
	move.w	(a5),-(a5)
	moveq	#0,d5
	moveq	#0,d4
	lea	l00ae(pc),a0
	bsr	l0071
	st	d4
	lea	l00b0(pc),a0
	bsr	l0071
	lea	l00b1(pc),a0
	bsr	l0071
l006d	lea	l00aa(pc),a5
	lea	l00ae(pc),a0
	bsr	l0082
	move.w	d0,-(a7)
	move.b	(a7)+,6(a6)
	move.b	d0,2(a6)
	move.b	d1,34(a6)
	lea	l00b0(pc),a0
	bsr	l0082
	move.w	d0,-(a7)
	move.b	(a7)+,14(a6)
	move.b	d0,10(a6)
	move.b	d1,38(a6)
	lea	l00b1(pc),a0
	bsr	l0082
	move.w	d0,-(a7)
	move.b	(a7)+,22(a6)
	move.b	d0,18(a6)
	move.b	d1,42(a6)
	move.w	4(a5),d0
	beq.s	l006f
	move.w	d0,-(a7)
	lea	l00b2(pc),a0
	bsr	l0082
	movea.l	8(a0),a1
	adda.w	12(a0),a1
	cmpi.b	#$e1,(a1)
	bne.s	l006e
	clr.w	4(a5)
l006e	move.w	(a7)+,d7
	lea	l00a6(pc),a1
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
l006f	move.b	(a5)+,d7
	ori.b	#$c0,d7
	move.b	d7,30(a6)
	move.b	(a5)+,26(a6)
	move.b	l00bd(pc),d0
	bne.s	l0070
	movem.l	(a6),a0-a2/d0-d7
	movem.l	a0-a2/d0-d7,$ffff8840.w
l0070	rts

l0071	subq.b	#1,44(a0)
	bpl.s	l0070
	move.b	45(a0),44(a0)
l0072	movea.l	40(a0),a1
l0073	move.b	(a1)+,d0
	cmp.b	#$ff,d0
	bne	l0077
	movea.l	0(a0),a2
	adda.w	4(a0),a2
	tst.b	d4
	bne.s	l0074
	subq.w	#1,50(a0)
	bpl.s	l0074
	move.w	l00b3(pc),50(a0)
	move.w	d5,4(a0)
	move.w	d5,58(a0)
	move.w	d5,112(a0)
	movea.l	0(a0),a2
l0074	moveq	#0,d1
	move.b	(a2),d1
	move.b	1(a2),21(a0)
	move.b	2(a2),20(a0)
	move.b	3(a2),d0
	move.b	d0,d2
	andi.w	#$f0,d2
	cmp.w	#$f0,d2
	bne.s	l0075
	move.b	d0,d2
	andi.b	#$f,d2
	move.b	d2,36(a0)
	bra.s	l0076
l0075	cmp.b	#$e0,d2
	bne.s	l0076
	move.b	d0,d2
	andi.w	#$f,d2
	move.w	d2,2(a5)
l0076	add.w	d1,d1
	movea.l	l00b4(pc),a3
	movea.w	0(a3,d1.w),a3
	adda.l	l00bc(pc),a3
	move.l	a3,40(a0)
	addi.w	#$c,4(a0)
	bra	l0072
l0077	cmp.b	#$fe,d0
	bne.s	l0078
	move.b	(a1),45(a0)
	move.b	(a1)+,44(a0)
	bra	l0073
l0078	cmp.b	#$fd,d0
	bne.s	l0079
	move.b	(a1),45(a0)
	move.b	(a1)+,44(a0)
	move.l	a1,40(a0)
	rts

l0079	move.b	d0,6(a0)
	move.b	(a1)+,d1
	move.b	d1,7(a0)
	andi.w	#$e0,d1
	beq.s	l007a
	move.b	(a1)+,32(a0)
l007a	move.l	a1,40(a0)
	move.l	d5,46(a0)
	tst.b	d0
	bmi.s	l007c
	move.b	7(a0),d1
	move.b	d1,d0
	andi.w	#$1f,d1
	add.b	20(a0),d1
	movea.l	l00b6(pc),a2
	add.w	d1,d1
	movea.w	0(a2,d1.w),a2
	adda.l	l00bc(pc),a2
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
	beq.s	l007b
	move.b	32(a0),d1
l007b	movea.l	l00b5(pc),a2
	add.w	d1,d1
	movea.w	0(a2,d1.w),a2
	adda.l	l00bc(pc),a2
	move.l	a2,14(a0)
	move.w	d5,18(a0)
	move.b	d5,25(a0)
	move.b	d5,24(a0)
l007c	rts

l007d	lea	l00a9(pc),a0
	clr.l	(a0)
	move.l	d0,d7
	move.l	d1,d6
	sub.l	d0,d1
	addq.l	#1,d6
	mulu	#$c,d7
	mulu	#$c,d6
	lea	l00b3(pc),a0
	move.w	d1,(a0)
	moveq	#2,d0
	lea	l00ae(pc),a0
	lea	l00a3(pc),a1
	lea	l00a4(pc),a2
l007e	move.l	a1,14(a0)
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
	movea.l	l00b7(pc),a3
	adda.l	d7,a3
	adda.w	d3,a3
	move.l	a3,0(a0)
	move.w	#$c,4(a0)
	move.w	l00b3(pc),50(a0)
	moveq	#0,d1
	move.b	(a3)+,d1
	add.w	d1,d1
	movea.l	l00b4(pc),a4
	movea.w	0(a4,d1.w),a4
	adda.l	l00bc(pc),a4
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
	bne.s	l007f
	sub.b	d1,d2
	move.b	d2,36(a0)
l007f	clr.l	46(a0)
	lea	54(a0),a0
	dbf	d0,l007e
	lea	l00ab(pc),a0
	move.w	#1,(a0)
	clr.w	4(a0)
	rts

l0080	move.w	l00bb(pc),d2
	move.w	l00ba(pc),d1
	tst.w	d2
	beq	l0081
	lea	l00b2(pc),a0
	lea	l00aa(pc),a5
	move.b	d2,6(a0)
	move.b	d1,34(a0)
	sf	21(a0)
	moveq	#0,d5
	andi.w	#$ff,d0
	movea.l	l00b6(pc),a2
	add.w	d0,d0
	movea.w	0(a2,d0.w),a2
	adda.l	l00bc(pc),a2
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
	movea.l	l00b5(pc),a2
	add.w	d0,d0
	movea.w	0(a2,d0.w),a2
	adda.l	l00bc(pc),a2
	move.l	a2,14(a0)
	move.w	d5,18(a0)
	sf	24(a0)
	sf	25(a0)
	clr.l	46(a0)
	sf	36(a0)
	sf	32(a0)
	addq.w	#1,d1
	move.w	d1,4(a5)
l0081	rts

l0082	moveq	#0,d7
	move.b	d7,33(a0)
l0083	tst.b	25(a0)
	beq.s	l0084
	subq.b	#1,25(a0)
	bra	l0089
l0084	movea.l	14(a0),a1
	adda.w	18(a0),a1
l0085	move.b	(a1)+,d0
	moveq	#0,d1
	move.b	d0,d1
	subi.w	#$e0,d1
	bmi	l0088
	add.w	d1,d1
	move.w	l0086(pc,d1.w),d1
	jmp	l0087(pc,d1.w)
l0086	dc.b	$00,$00,$00,$10,$00,$1a,$00,'*'
	dc.b	$00,':',$00,'J',$00,'X',$00,'f'
	dc.b	$00,$80,$00,$8c,$00,$aa
l0087	moveq	#0,d0
	move.b	(a1)+,d0
	move.w	d0,18(a0)
	movea.l	14(a0),a1
	adda.l	d0,a1
	bra.s	l0085
	move.b	-2(a1),26(a0)
	bra	l0089
	move.w	d7,12(a0)
	move.b	#1,22(a0)
	addq.w	#1,18(a0)
	bra.s	l0085
	move.b	(a1)+,27(a0)
	move.b	(a1)+,28(a0)
	addq.w	#3,18(a0)
	bra	l0085
	move.b	d7,38(a0)
	move.b	(a1)+,33(a0)
	addq.w	#2,18(a0)
	bra	l0085
	move.b	#1,38(a0)
	addq.w	#1,18(a0)
	bra	l0085
	move.b	#2,38(a0)
	addq.w	#1,18(a0)
	bra	l0085
	move.b	#0,d1
	move.b	(a1)+,d1
	lsl.w	#6,d1
	movea.l	l00b5(pc),a1
	adda.w	d1,a1
	move.l	a1,14(a0)
	move.w	d7,18(a0)
	bra	l0085
	move.b	(a1)+,25(a0)
	addq.w	#2,18(a0)
	bra	l0083
	movea.w	#$8870,a3
	move.b	#$b,(a3)
	move.b	(a1)+,2(a3)
	move.l	#$c000d0a,d0
	movep.l	d0,8(a3)
	addq.w	#2,18(a0)
	bra	l0085
	move.b	#$20,7(a0)
	move.b	(a1)+,32(a0)
	addq.w	#2,18(a0)
	bra	l0085
l0088	move.b	d0,26(a0)
	addq.w	#1,18(a0)
l0089	tst.b	24(a0)
	beq.s	l008a
	subq.b	#1,24(a0)
	bra.s	l008f
l008a	subq.b	#1,22(a0)
	bne.s	l008f
	move.b	23(a0),22(a0)
	movea.l	8(a0),a1
	adda.w	12(a0),a1
l008b	moveq	#0,d1
	move.b	(a1)+,d0
	move.b	d0,d1
	subi.w	#$e0,d1
	bmi.s	l008e
	add.w	d1,d1
	move.w	l008c(pc,d1.w),d1
	jmp	l008d(pc,d1.w)
l008c	dc.b	$00,$02,$00,$14,$00,$00,$00,$00
	dcb.w	4
	dc.b	$00,$1c
l008d	rts

	moveq	#0,d1
	move.b	(a1)+,d1
	subq.w	#5,d1
	move.w	d1,12(a0)
	movea.l	8(a0),a1
	adda.w	d1,a1
	bra.s	l008b
	move.b	-2(a1),35(a0)
	bra.s	l008f
	addq.w	#2,12(a0)
	move.b	(a1),24(a0)
	bra.s	l0089
l008e	move.b	d0,35(a0)
	addq.w	#1,12(a0)
l008f	move.b	26(a0),d0
	bmi.s	l0090
	add.b	6(a0),d0
	add.b	21(a0),d0
l0090	andi.w	#$7f,d0
	lea	l00be(pc),a1
	add.w	d0,d0
	move.w	d0,d1
	move.w	0(a1,d0.w),d0
	move.b	34(a0),d3
	move.b	38(a0),d2
	bne.s	l0091
	bclr	d3,(a5)
	addq.w	#3,d3
	bclr	d3,(a5)
	bra.s	l0094
l0091	cmp.b	#1,d2
	bne.s	l0093
	bset	d3,(a5)
	addq.w	#3,d3
	bclr	d3,(a5)
	move.b	6(a0),33(a0)
	move.b	26(a0),d4
	bpl.s	l0092
	andi.b	#$7f,d4
	move.b	d4,33(a0)
	bra.s	l0094
l0092	add.b	d4,33(a0)
	bra.s	l0094
l0093	bclr	d3,(a5)
	addq.w	#3,d3
	bset	d3,(a5)
l0094	tst.b	33(a0)
	beq.s	l0095
	move.b	33(a0),d3
	not.b	d3
	andi.b	#$1f,d3
	move.b	d3,1(a5)
l0095	move.b	31(a0),d6
	tst.b	30(a0)
	beq.s	l0096
	subq.b	#1,30(a0)
	bra.s	l00a0
l0096	move.b	d1,d5
	move.b	28(a0),d4
	bmi.s	l0097
	add.b	d4,d4
	bra.s	l0098
l0097	andi.b	#$7f,d4
l0098	move.b	29(a0),d1
	tst.b	d6
	bpl.s	l0099
	btst	d7,d6
	bne.s	l009c
l0099	btst	#5,d6
	bne.s	l009a
	sub.b	27(a0),d1
	bcc.s	l009b
	bset	#5,d6
	moveq	#0,d1
	bra.s	l009b
l009a	add.b	27(a0),d1
	cmp.b	d4,d1
	bcs.s	l009b
	bclr	#5,d6
	move.b	d4,d1
l009b	move.b	d1,29(a0)
l009c	lsr.b	#1,d4
	sub.b	d4,d1
	bcc.s	l009d
	subi.w	#$100,d1
l009d	addi.b	#$a0,d5
	bcs.s	l009f
l009e	add.w	d1,d1
	addi.b	#$18,d5
	bcc.s	l009e
l009f	add.w	d1,d0
l00a0	bchg	d7,d6
	move.b	d6,31(a0)
	btst	#5,7(a0)
	beq.s	l00a1
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
l00a1	move.b	35(a0),d1
	sub.b	36(a0),d1
	sub.b	37(a0),d1
	bpl.s	l00a2
	moveq	#0,d1
l00a2	rts

l00a3	dc.b	$01,$00,$00,$00,$00,$00,$00,$e1
l00a4	dc.b	$00,$01,$02,$00
l00a5	dc.b	$00,$00,$f3,$00,$01,$01,$04,$00
	dc.b	$02,$02,'B',$00,$03,$03,$01,$00
	dc.b	$04,$04,$ee,$00,$05,$05,$0e,$00
	dc.b	$06,$06,$0c,$00,$07,$07,$f1,$ff
	dc.b	$08,$08,$0b,$00,$09,$09,$0b,$00
	dc.b	$0a,$0a,$00,$00
l00a6	dcb.w	2
	dc.b	$02,$06,'"',$00,$0a,$0e,'&',$00
	dc.b	$12,$16,'*',$00
l00a7	dc.b	$00,$00
l00a8	dc.b	$00,$01,$02,$03,$04,$05,$06,$07
	dc.b	$08,$09,$0a,$0b,$0f,$0f,$0f,$0f
	dc.b	$0f,$0f
l00a9	dcb.w	2
l00aa	dc.b	'1',$0c,$00,$00,$00,$00,$00,$00
l00ab	dc.b	$00,$03
l00ac	dc.b	$00,$03
l00ad	dc.b	$00,$00
l00ae	dc.b	$00,$01,'Q>',$00,'T.',$00
	dc.b	$00,$01,'E',$04,$00,$01,$00,$01
	dc.b	'D',$07,$00,$03,$06,$00,$01,$01
	dc.b	$00,$00,$93,$01,$01,$00,$00,'A'
	dc.b	$00,$13,$00,$0d,$02
l00af	dc.b	$00,$01,$00,$00,$01,'G',$eb,$01,$01
	dcb.w	2
	dc.b	$00,'w',$00,$00
l00b0	dc.b	$00,$01,'QB',$00,'T0',$00
	dc.b	$00,$01,'E1',$00,$01,$00,$01
	dc.b	'D',$15,$00,$03,$08,$fb,$01,$01
	dc.b	$00,$00,$00,$01,$02,$04,$00,'A'
	dc.b	$00,$00,$01,$0d,$02,$00,$02,$00
	dc.b	$00,$01,'H',$00,$11,$1f,$00,$00
	dc.b	$00,$00,$00,'}',$00,$00
l00b1	dc.b	$00,$01,'QF',$00,'T',$00,$00
	dc.b	$00,$01,'A',$10,$00,$07,$00,$01
	dc.b	'A',$10,$00,$07,$00,$00,$01,$01
	dcb.w	3
	dc.b	$00,$01,$00,$00,$02,$00,$0f,$00
	dc.b	$02,$00,$00,$01,'GL',$11,$1f
	dcb.w	2
	dc.b	$00,'}',$00,$00
l00b2	dcb.w	27
	dc.b	$00,'@'
l00b3	dc.b	$00,'}'
l00b4	dc.b	$00,$01,'F~'
l00b5	dc.b	$00,$01,'C',$be
l00b6	dc.b	$00,$01,'D~'
l00b7	dc.b	$00,$01,'Q>',$00,$00
l00b8	dc.b	$00,$01,'\',$f6
l00b9	dc.b	$00,$01,']',$14
l00ba	dc.b	$00,$00
l00bb	dc.b	$00,$00
l00bc	dc.b	$00,$01,'C~'
l00bd	dc.b	$00,$00
l00be	dc.b	$0e,$ee,$0e,$17,$0d,'M',$0c,$8e
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
l00bf	dc.b	'COSO',$00,$00,$00,'@'
	dc.b	$00,$00,$00,$d4,$00,$00,$02,$a0
	dc.b	$00,$00,$08,'H',$00,$00,$10,$94
	dc.b	$00,$00,$10,$c4,$00,$00,$00,$00
	dc.b	'TFMX',$00,$0b,$00,$18
	dc.b	$00,'b',$00,$b0,$00,'@',$00,$06
	dc.b	$00,$07,$00,$00,$00,$00,$00,$00
	dcb.w	4
	dc.b	$00,'X',$00,'\',$00,'a',$00,'k'
	dc.b	$00,'q',$00,'z',$00,$85,$00,$91
	dc.b	$00,$9d,$00,$a7,$00,$c4,$00,$ca
	dc.b	$e2,$e6,$00,$e1,$e2,$e6,$0c,$00
	dc.b	$e1,$e2,$e6,$0c,$0c,$00,$00,$e8
	dc.b	$03,$e0,$02,$e2,$e6,$0c,$00,$00
	dc.b	$e1,$e2,$e5,$9a,$e6,$97,$93,$8c
	dc.b	$00,$e1,$e2,$e5,$9a,$e6,$9c,$9e
	dc.b	$e5,$96,$e5,$83,$e1,$e2,$e6,$00
	dc.b	$05,$0c,$00,$05,$0c,$00,$05,$e0
	dc.b	$02,$e2,$e6,$00,$04,$0c,$00,$04
	dc.b	$0c,$00,$04,$e0,$02,$e2,$e5,$9f
	dc.b	$e6,$97,$93,$8c,$88,$e0,$06,$e2
	dc.b	$e5,$9f,$e6,$18,$17,$16,$15,$14
	dc.b	$13,$12,$11,$0f,$0e,$0d,$0c,$0b
	dc.b	$0a,$09,$08,$07,$06,$05,$04,$03
	dc.b	$02,$01,$00,$e1,$e2,$e5,$9a,$e6
	dc.b	$00,$e1,$e2,$e6,$00,$00,$00,$01
	dc.b	$01,$01,$e0,$02,$01,$06,$01,$1c
	dc.b	$01,'$',$01,'5',$01,'=',$01,'S'
	dc.b	$01,'g',$01,'}',$01,$85,$01,$9b
	dc.b	$01,$b0,$01,$b9,$01,$c0,$01,$d6
	dc.b	$01,$eb,$01,$f3,$02,$08,$02,$14
	dc.b	$02,$1e,$02,'+',$02,'C',$02,'['
	dc.b	$02,'h',$02,$7f,$02,$96,$05,$00
	dc.b	$00,$00,$00,$0f,$0e,$0d,$0c,$0b
	dc.b	$0a,$09,$08,$07,$06,$05,$04,$03
	dc.b	$02,$01,$00,$e1,$01,$01,$01,$02
	dc.b	$1f,$0f,$0e,$e1,$1f,$00,$0a,$10
	dc.b	$04,$0f,$0e,$0d,$0c,$0b,$0a,$08
	dc.b	$06,$04,$02,$00,$e1,$01,$00,$02
	dc.b	$03,$1f,$0f,$0e,$e1,$06,$00,$01
	dc.b	$02,$06,$0f,$0e,$0d,$0c,$0b,$0a
	dc.b	$09,$08,$07,$06,$05,$04,$03,$02
	dc.b	$01,$00,$e1,$05,$02,$00,$00,$00
	dc.b	$0d,$0c,$0b,$0a,$09,$08,$07,$06
	dc.b	$05,$04,$03,$02,$01,$00,$e1,$05
	dc.b	$00,$01,$02,$03,$0f,$0e,$0d,$0c
	dc.b	$0b,$0a,$09,$08,$07,$06,$05,$04
	dc.b	$03,$02,$01,$00,$e1,$03,$00,$01
	dc.b	$02,$04,$0f,$0e,$e1,$0f,$00,$01
	dc.b	$02,$04,$0f,$0e,$0d,$0c,$0b,$0a
	dc.b	$09,$08,$07,$06,$05,$04,$03,$02
	dc.b	$01,$00,$e1,$04,$00,$01,$02,$00
	dc.b	$0e,$0d,$0c,$0b,$0a,$09,$08,$07
	dc.b	$06,$05,$04,$03,$02,$01,$00,$e1
	dc.b	$01,$00,$01,$02,$00,$0d,$0e,$0d
	dc.b	$e1,$01,$00,$00,$00,$00,$00,$e1
	dc.b	$05,$02,$00,$00,$00,$0f,$0e,$0d
	dc.b	$0c,$0b,$0a,$09,$08,$07,$06,$05
	dc.b	$04,$03,$02,$01,$00,$e1,$03,$03
	dc.b	$01,$02,$00,$0f,$0e,$0d,$0c,$0b
	dc.b	$0a,$09,$08,$07,$05,$04,$03,$02
	dc.b	$01,$00,$e1,$01,$01,$01,$02,$0f
	dc.b	$0f,$0e,$e1,$03,$03,$01,$02,$00
	dc.b	$0e,$0d,$0c,$0b,$0a,$09,$08,$07
	dc.b	$06,$05,$04,$03,$02,$01,$00,$e1
	dc.b	$01,$04,$01,$02,$04,$0d,$0f,$0f
	dc.b	$0f,$0e,$0d,$e1,$01,$03,$01,$02
	dc.b	$03,$0d,$0f,$0e,$0e,$e1,$01,$05
	dc.b	$00,$00,$00,$0d,$0f,$0f,$0e,$0d
	dc.b	$0a,$00,$e1,$05,$06,$00,$00,$00
	dc.b	$0d,$0e,$0f,$0e,$0d,$0c,$0b,$0a
	dc.b	$09,$08,$07,$06,$05,$04,$03,$02
	dc.b	$01,$00,$e1,$05,$07,$00,$00,$00
	dc.b	$0d,$0e,$0f,$0e,$0d,$0c,$0b,$0a
	dc.b	$09,$08,$07,$06,$05,$04,$03,$02
	dc.b	$01,$00,$e1,$01,$08,$00,$00,$00
	dc.b	$0c,$0f,$0f,$0f,$0f,$0c,$00,$e1
	dc.b	$02,$09,$00,$00,$00,$0f,$0f,$0e
	dc.b	$0d,$0c,$0b,$0a,$09,$08,$07,$06
	dc.b	$05,$04,$03,$02,$01,$00,$e1,$01
	dc.b	$0a,$01,$02,$04,$0d,$0f,$0e,$0d
	dc.b	$0c,$0b,$0a,$09,$08,$07,$06,$05
	dc.b	$04,$03,$02,$01,$00,$e1,$0a,$0b
	dc.b	$00,$08,$00,$0f,$0e,$0d,$e1,$fe
	dc.b	$03,'f',$03,'i',$03,'v',$03,$83
	dc.b	$03,$86,$03,$89,$03,$8c,$03,$8f
	dc.b	$03,$92,$03,$95,$03,$98,$03,$9b
	dc.b	$03,$9e,$03,$a1,$03,$a4,$03,$a7
	dc.b	$03,$aa,$03,$ad,$03,$b0,$03,$b3
	dc.b	$03,$b6,$03,$b9,$03,$bc,$03,$bf
	dc.b	$03,$c2,$03,$c7,$03,$ce,$03,$d7
	dc.b	$03,$e8,$03,$f9,$04,$0c,$04,$19
	dc.b	$04,'*',$04,'/',$04,':',$04,'E'
	dc.b	$04,'J',$04,'U',$04,'x',$04,$9b
	dc.b	$04,$be,$04,$e1,$05,$04,$05,$27
	dc.b	$05,'4',$05,'?',$05,'J',$05,'Z'
	dc.b	$05,'e',$05,'r',$05,$83,$05,$a4
	dc.b	$05,$b1,$05,$bc,$05,$c9,$05,$d6
	dc.b	$05,$ea,$05,$f9,$06,$02,$06,$05
	dc.b	$06,$12,$06,$1f,$06,'(',$06,'5'
	dc.b	$06,':',$06,'C',$06,'L',$06,'Y'
	dc.b	$06,'^',$06,'g',$06,'t',$06,'y'
	dc.b	$06,$82,$06,$87,$06,$90,$06,$9f
	dc.b	$06,$ae,$06,$bd,$06,$c9,$06,$da
	dc.b	$06,$e5,$06,$f2,$07,$05,$07,$1c
	dc.b	$07,'/',$07,'F',$07,'V',$07,'p'
	dc.b	$07,'{',$07,$8e,$07,$a1,$07,$be
	dc.b	$07,$c9,$07,$f0,$07,$f5,$07,$fc
	dc.b	$08,$15,$08,'/',$08,'B',$fd,$1f
	dc.b	$ff,$fe,$0b,'7',$00,$fe,$03,'2'
	dc.b	$0a,$fe,$07,'2',$00,$ff,$fe,$0b
	dc.b	'/',$0a,$fe,$03,'-',$00,$fe,$07
	dc.b	'/',$00,$ff,$fd,$1f,$ff,$fd,$1f
	dc.b	$ff,$fd,$1f,$ff,$fd,$1f,$ff,$fd
	dc.b	$1f,$ff,$fd,$1f,$ff,$fd,$1f,$ff
	dc.b	$fd,$1f,$ff,$fd,$1f,$ff,$fd,$1f
	dc.b	$ff,$fd,$1f,$ff,$fd,$1f,$ff,$fd
	dc.b	$1f,$ff,$fd,$1f,$ff,$fd,$1f,$ff
	dc.b	$fd,$1f,$ff,$fd,$1f,$ff,$fd,$1f
	dc.b	$ff,$fd,$1f,$ff,$fd,$1f,$ff,$fd
	dc.b	$1f,$ff,$fe,$1f,'0',$00,$ff,$fd
	dc.b	$1b,$fe,$03,$0c,$00,$ff,$fe,$1b
	dc.b	$18,$00,$fe,$03,$18,$00,$ff,$fe
	dc.b	$0b,$0c,$00,$fe,$03,$0c,$00,$fe
	dc.b	$0b,$0c,$00,$fe,$03,$0c,$00,$ff
	dc.b	$fe,$07,$0c,$00,$0c,$01,$fe,$03
	dc.b	$09,$01,$09,$01,$fe,$07,$07,$01
	dc.b	$ff,$fe,$03,$11,$00,$fe,$0b,$11
	dc.b	$01,$fe,$07,$0c,$02,$fe,$03,$11
	dc.b	$00,$11,$00,$ff,$fd,$03,$11,$00
	dc.b	$fe,$07,$11,$00,$0c,$02,$0c,$00
	dc.b	$ff,$fd,$03,$11,$00,$fe,$0b,$0c
	dc.b	$06,$fe,$03,$09,$06,$09,$06,$0c
	dc.b	$00,$ff,$fe,$1f,',',$00,$ff,$fd
	dc.b	$0f,$fe,$0b,'+',$00,$fe,$03,')'
	dc.b	$00,$ff,$fd,$0f,$fe,$0b,'+',$00
	dc.b	$fe,$03,'0',$03,$ff,$fe,$1f,$0c
	dc.b	$00,$ff,$fd,$0f,$fe,$0b,'*',$00
	dc.b	$fe,$03,'(',$00,$ff,$fe,$01,'4'
	dc.b	$00,'4',$00,$fe,$03,'+',$00,'0'
	dc.b	$00,$fe,$01,'4',$00,'4',$00,$fe
	dc.b	$03,'7',$00,$fe,$01,'4',$00,'4'
	dc.b	$00,$fe,$03,'0',$00,'+',$00,$ff
	dc.b	$fe,$01,'2',$00,'2',$00,$fe,$03
	dc.b	'+',$00,'/',$00,$fe,$01,'2',$00
	dc.b	'2',$00,$fe,$03,'7',$00,$fe,$01
	dc.b	'2',$00,'2',$00,$fe,$03,'/',$00
	dc.b	'+',$00,$ff,$fe,$01,'0',$00,'0'
	dc.b	$00,$fe,$03,'(',$00,'-',$00,$fe
	dc.b	$01,'0',$00,'0',$00,$fe,$03,'4'
	dc.b	$00,$fe,$01,'0',$00,'0',$00,$fe
	dc.b	$03,'-',$00,'(',$00,$ff,$fe,$01
	dc.b	'/',$00,'/',$00,$fe,$03,'(',$00
	dc.b	'+',$00,$fe,$01,'/',$00,'/',$00
	dc.b	$fe,$03,'4',$00,$fe,$01,'/',$00
	dc.b	'/',$00,$fe,$03,'+',$00,'(',$00
	dc.b	$ff,$fe,$01,'+',$00,'+',$00,$fe
	dc.b	$03,'$',$00,'(',$00,$fe,$01,'+'
	dc.b	$00,'+',$00,$fe,$03,'0',$00,$fe
	dc.b	$01,'+',$00,'+',$00,$fe,$03,'('
	dc.b	$00,'$',$00,$ff,$fe,$01,'4',$00
	dc.b	'4',$00,$fe,$03,'+',$00,'0',$00
	dc.b	$fe,$01,'4',$00,'4',$00,$fe,$03
	dc.b	'7',$00,$fe,$01,'<',$00,'<',$00
	dc.b	$fe,$03,':',$00,'7',$00,$ff,$fe
	dc.b	$13,'4',$00,$fe,$07,'2',$00,$fe
	dc.b	$03,'0',$00,$ff,$fe,$0f,'2',$00
	dc.b	$fe,$07,'7',$00,'5',$00,$ff,$fe
	dc.b	$0f,'/',$00,$fe,$07,'-',$00,'/'
	dc.b	$00,$ff,$fe,$13,'0',$00,$fe,$07
	dc.b	'2',$00,$fe,$01,'3  ',$b4
	dc.b	$00,$ff,$fe,$0f,'4',$00,$fe,$07
	dc.b	'5',$00,'7',$00,$ff,$fe,$13,'9'
	dc.b	$00,$fe,$07,'0',$00,$fe,$03,'2'
	dc.b	$00,$ff,$fe,$13,'2',$02,$fe,$01
	dc.b	$18,$00,$fe,$05,$18,$00,$fe,$03
	dc.b	$17,$00,$ff,$fe,$01,$0c,$00,$fe
	dc.b	$03,$0c,$01,$fe,$01,$18,$01,$fe
	dc.b	$03,$0c,$02,$0c,$00,$fe,$07,$0c
	dc.b	$00,$fe,$03,$0c,$02,$fe,$01,$16
	dc.b	$00,$18,$01,$ff,$fe,$13,'4',$00
	dc.b	$fe,$07,'5',$00,$fe,$03,'7',$00
	dc.b	$ff,$fe,$0f,'7',$00,$fe,$07,'9'
	dc.b	$00,';',$00,$ff,$fe,$13,'<',$00
	dc.b	$fe,$07,'>',$00,$fe,$03,'<',$00
	dc.b	$ff,$fe,$13,'<',$00,$fe,$03,'<'
	dc.b	$00,$fe,$07,'>',$00,$ff,$fe,$01
	dc.b	'> ',$10,$fe,$09,$c0,$00,$fe
	dc.b	$0b,'<',$00,$fe,$03,'9',$00,'7'
	dc.b	$00,$ff,$fd,$0b,$fe,$00,'2',$00
	dc.b	$fe,$06,$b4,$00,$fe,$0b,'2',$00
	dc.b	$ff,$fe,$0f,'0',$00,$fe,$07,'2'
	dc.b	$00,$ff,$fd,$17,$ff,$fe,$0b,'3'
	dc.b	$00,$fe,$03,'5',$00,$fe,$07,'3'
	dc.b	$00,$ff,$fe,$0b,'2',$00,$fe,$03
	dc.b	'0',$00,$fe,$07,'/',$00,$ff,$fe
	dc.b	$07,'0',$00,',',$00,'+',$00,$ff
	dc.b	$fe,$0b,'3',$00,$fe,$03,'3',$00
	dc.b	$fe,$07,'5',$00,$ff,$fe,$17,'7'
	dc.b	$00,$ff,$fe,$07,'<',$00,'8',$00
	dc.b	'7',$00,$ff,$fe,$0f,'5',$00,$fe
	dc.b	$07,'8',$00,$ff,$fe,$0b,'7',$00
	dc.b	$fe,$03,'2',$14,$fe,$07,'2',$00
	dc.b	$ff,$fe,$17,'0',$00,$ff,$fe,$0f
	dc.b	'3',$00,$fe,$07,'0',$00,$ff,$fe
	dc.b	$0b,'/',$14,$fe,$03,'-',$00,$fe
	dc.b	$07,'/',$00,$ff,$fe,$17,'0',$00
	dc.b	$ff,$fe,$0f,'0',$00,$fe,$07,'+'
	dc.b	$00,$ff,$fe,$17,$0c,$00,$ff,$fe
	dc.b	$07,$0c,$00,$08,$00,$07,$00,$ff
	dc.b	$fe,$03,'0',$00,'2',$00,'3',$00
	dc.b	'2',$00,'0',$00,'3',$00,$ff,$fe
	dc.b	$03,'0',$00,'2',$00,'4',$00,'2'
	dc.b	$00,'0',$00,'/',$00,$ff,$fe,$03
	dc.b	'/',$00,'0',$00,'2',$00,'0',$00
	dc.b	'/',$00,'-',$00,$ff,$fe,$17,'4'
	dc.b	$00,$fe,$03,$b3,' ',$10,$b4,$00
	dc.b	$ff,$fe,$03,'4',$00,$fe,$07,'2'
	dc.b	$00,'2',$00,'4',$00,$fe,$03,'2'
	dc.b	$00,$ff,$fe,$17,'0',$00,$fe,$03
	dc.b	'-',$00,'+',$00,$ff,$fe,$0b,')'
	dc.b	$00,$fe,$07,'-',$00,$fe,$0b,'0'
	dc.b	$00,$ff,$fe,$03,'$',$00,'+',$00
	dc.b	'4',$00,'>',$00,'$',$00,'+',$00
	dc.b	'4',$00,'>',$00,$ff,$fd,$01,$fe
	dc.b	$03,'(',$00,'0',$00,'7',$00,'@'
	dc.b	$00,'(',$00,'0',$00,'7',$00,$fe
	dc.b	$01,'@',$00,$ff,$fe,$03,'$',$00
	dc.b	'+',$00,'3',$00,':',$00,'$',$00
	dc.b	'+',$00,'3',$00,':',$00,$ff,$fd
	dc.b	$01,$fe,$03,$27,$00,'0',$00,'7'
	dc.b	$00,'<',$00,$27,$00,'0',$00,'7'
	dc.b	$00,$fe,$01,'<',$00,$ff,$fe,$03
	dc.b	'2 ',$10,$fe,$13,$b4,$00,$fe
	dc.b	$03,'2',$00,'4',$00,$ff,$fe,$01
	dc.b	'2',$00,$fe,$03,'0',$00,', '
	dc.b	$10,$fe,$0d,$ad,$00,$fe,$03,'-'
	dc.b	$00,$fe,$01,'+',$00,'-',$00,$ff
	dc.b	$fd,$17,$fe,$01,'-',$00,$fe,$05
	dc.b	'0',$00,$ff,$fe,$0b,'/',$00,$fe
	dc.b	$01,'0',$00,$fe,$0d,'2',$00,$fe
	dc.b	$01,'0',$00,'2',$00,$ff,$fe,$0b
	dc.b	'/',$00,$fe,$01,'0',$00,$fe,$0d
	dc.b	'2',$00,$fe,$01,'0',$00,'/',$00
	dc.b	$ff,$fe,$07,$0c,$00,$fe,$03,$0c
	dc.b	$02,$fe,$01,$0c,$01,$0c,$00,$fe
	dc.b	$03,$0c,$00,$0c,$01,$0c,$02,$fe
	dc.b	$01,$0c,$01,$0c,$01,$ff,$fe,$17
	dc.b	'4',$00,$fe,$03,'2',$00,'4',$00
	dc.b	$ff,$fe,$01,'$',$00,$fe,$03,'0'
	dc.b	$00,$fe,$01,'0',$00,'$',$00,'0'
	dc.b	$00,'.',$00,'0',$00,'$',$00,$fe
	dc.b	$03,'0',$00,$fe,$01,'0',$00,'$'
	dc.b	$00,'0',$00,'.',$00,'0',$00,$ff
	dc.b	$fe,$1f,$0c,$00,$ff,$fe,$0f,$0c
	dc.b	$00,$0e,$00,$ff,$fe,$13,'0"'
	dc.b	$f0,$fe,$05,'H%',$80,$fe,$02
	dc.b	'H%',$80,$fe,$00,'H%',$00
	dc.b	$fe,$01,'<',$05,$ff,$fe,$13,'T'
	dc.b	'"',$f8,$fe,$04,'H%',$80,$fe
	dc.b	$02,'H%',$80,$fe,$00,'H',$05
	dc.b	'<',$05,$fe,$01,'0',$05,$ff,$fe
	dc.b	$0f,'$"0',$fe,$0b,'T"'
	dc.b	$01,$fe,$01,'H%',$80,'H%'
	dc.b	$80,$ff,$fe,$1f,'H3',$80,$ff
	dc.b	$18,$0c,$13,$00,'#',$00,$0b,$00
	dc.b	'#',$00,$0b,$00,$18,$0c,$13,$00
	dcb.w	4
	dc.b	$18,$00,$13,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$18,$00,$13,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$18,$0c,$13,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$18,$0c,$13,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$18,$00,$13,$00,$00,$00,$00,$00
	dcb.w	2
	dc.b	$18,$00,$13,$00,$19,$00,$15,$00
	dcb.w	2
	dc.b	$18,$0c,$13,$00,$1a,$00,$15,$00
	dcb.w	2
	dc.b	$18,$0c,$13,$00,$1a,$00,$15,$00
	dcb.w	2
	dc.b	$18,$00,$13,$00,$1a,$00,$15,$00
	dcb.w	2
	dc.b	$18,$00,$13,$00,$1a,$00,$15,$00
	dcb.w	2
	dc.b	$18,$0c,$13,$00,$1a,$00,$15,$00
	dcb.w	2
	dc.b	$18,$0c,$13,$00,$1a,$00,$15,$00
	dcb.w	2
	dc.b	$18,$00,$13,$00,$1a,$00,$15,$00
	dcb.w	2
	dc.b	$18,$00,$13,$00,$1a,$00,$15,$00
	dcb.w	2
	dc.b	$18,$0c,$13,$00,$1b,$00,$15,$00
	dc.b	' ',$00,$01,$00,$18,$0c,$13,$00
	dc.b	$1b,$00,$15,$00,'!',$00,$01,$00
	dc.b	$18,$00,$13,$00,$1b,$00,$15,$00
	dc.b	' ',$00,$01,$00,$18,$00,$13,$00
	dc.b	$1b,$00,$15,$00,'!',$00,$01,$00
	dc.b	$18,$0c,$13,$00,$1b,$00,$15,$00
	dc.b	' ',$ff,$01,$00,$18,$0c,$14,$00
	dc.b	$1b,$00,$15,$00,'$',$ff,$01,$00
	dc.b	$18,$00,$13,$00,$1b,$00,$15,$00
	dc.b	' ',$fd,$01,$00,$18,$00,$13,$00
	dc.b	$1b,$00,$15,$00,$00,$fd,$01,$00
	dc.b	$18,$0c,$13,$00,$1b,$00,$15,$00
	dc.b	' ',$00,$01,$00,$18,$0c,$13,$00
	dc.b	$1b,$00,$15,$00,'!',$00,$01,$00
	dc.b	$18,$00,$13,$00,$1b,$00,$15,$00
	dc.b	' ',$00,$01,$00,$18,$00,$13,$00
	dc.b	$1b,$00,$15,$00,'!',$00,$01,$00
	dc.b	$18,$0c,$13,$00,$1b,$00,$15,$00
	dc.b	' ',$ff,$01,$00,$18,$0c,$14,$00
	dc.b	$1b,$00,$15,$00,'$',$ff,$01,$00
	dc.b	$18,$00,$13,$00,$1b,$00,$15,$00
	dc.b	' ',$fd,$01,$00,$18,$00,$13,$00
	dc.b	$1c,$00,$15,$00,$00,$fd,$01,$00
	dc.b	$18,$0c,$13,$00,$1d,$00,$10,$00
	dc.b	' ',$00,$01,$00,$18,$0c,$13,$00
	dc.b	$1e,$00,$10,$00,'!',$00,$01,$00
	dc.b	$18,$00,$13,$00,$1d,$00,$10,$00
	dc.b	' ',$00,$01,$00,$18,$00,$13,$00
	dc.b	$1e,$00,$10,$00,'!',$00,$01,$00
	dc.b	$18,$0c,$13,$00,$1d,$fb,$10,$00
	dc.b	' ',$ff,$01,$00,$18,$0c,$14,$00
	dc.b	$1e,$fb,$10,$00,'$',$ff,$01,$00
	dc.b	$18,$00,$13,$00,$1d,$00,$10,$00
	dc.b	' ',$fd,$01,$00,$18,$00,$13,$00
	dc.b	$1f,$00,$10,$00,$00,$fd,$00,$00
	dc.b	$18,$0c,$13,$00,$1d,$00,$10,$00
	dc.b	' ',$00,$01,$00,$18,$0c,$13,$00
	dc.b	$1e,$00,$10,$00,'"',$00,$01,$00
	dc.b	$18,$00,$13,$00,$1d,$00,$10,$00
	dc.b	' ',$00,$01,$00,$18,$00,$13,$00
	dc.b	$1e,$00,$10,$00,'!',$00,$01,$00
	dc.b	$18,$0c,$13,$00,$1d,$fb,$10,$00
	dc.b	' ',$ff,$01,$00,$18,$0c,$14,$00
	dc.b	$1e,$fb,$10,$00,'$',$ff,$01,$00
	dc.b	$18,$00,$13,$00,$1d,$00,$10,$00
	dc.b	' ',$fd,$01,$00,$18,$00,$13,$00
	dc.b	$1f,$00,$10,$00,$00,$fd,$01,$00
	dc.b	'%',$00,$0f,$00,'+',$00,$0e,$00
	dc.b	'#',$00,$0b,$00,'&',$00,$0f,$00
	dc.b	',',$00,$0e,$00,$00,$00,$00,$00
	dc.b	$27,$00,$0f,$00,'+',$00,$0e,$00
	dcb.w	2
	dc.b	'(',$00,$0f,$00,'-',$00,$0e,$00
	dcb.w	2
	dc.b	'%',$f9,$0f,$00,'.',$00,$0e,$00
	dcb.w	2
	dc.b	')',$00,$0f,$00,'/',$00,$0e,$00
	dcb.w	2
	dc.b	'%',$f9,$0f,$00,'0',$00,$0e,$00
	dcb.w	2
	dc.b	'*',$fb,$0f,$00,'#&',$0e,$00
	dcb.w	2
	dc.b	'%',$00,$0f,$00,'+',$00,$0e,$00
	dc.b	'2',$00,$10,$00,'&',$00,$0f,$00
	dc.b	',',$00,$0e,$00,'2',$fb,$10,$00
	dc.b	$27,$00,$0f,$00,'+',$00,$0e,$00
	dc.b	'2',$fd,$10,$00,'(',$00,$0f,$00
	dc.b	'-',$00,$0e,$00,'2',$04,$10,$00
	dc.b	'%',$f9,$0f,$00,'.',$00,$0e,$00
	dc.b	'2',$05,$10,$00,')',$00,$0f,$00
	dc.b	'/',$00,$0e,$00,'2',$00,$10,$00
	dc.b	'%',$f9,$0f,$00,'0',$00,$0e,$00
	dc.b	'2',$05,$10,$00,'*',$fb,$0f,$00
	dc.b	'1',$00,$0c,$00,'2',$fb,$10,$00
	dc.b	'%',$00,$0f,$00,'M',$00,$0e,$00
	dc.b	'2',$00,$10,$00,'&',$00,$0f,$00
	dc.b	'N',$00,$0e,$00,'2',$fb,$10,$00
	dc.b	$27,$00,$0f,$00,'O',$00,$0e,$00
	dc.b	'2',$fd,$10,$00,'%',$f9,$0f,$00
	dc.b	'P',$00,$0e,$00,'2',$05,$10,$00
	dc.b	'%',$00,$0f,$00,'M',$00,$0e,$00
	dc.b	'2',$00,$10,$00,'%',$fb,$0f,$00
	dc.b	'N',$00,$0e,$00,'2',$fb,$10,$00
	dc.b	'%',$00,$0f,$00,'#$',$0e,$00
	dc.b	'2',$00,$10,$00,'%',$00,$0f,$00
	dc.b	$00,'$',$0e,$00,'2',$00,$10,$00
	dc.b	'%',$00,$05,$00,'3',$00,$0e,$00
	dc.b	'2',$00,$10,$00,'&',$00,$05,$00
	dc.b	'4',$00,$0e,$00,'2',$fb,$10,$00
	dc.b	$27,$00,$05,$00,'5',$00,$0e,$00
	dc.b	'2',$fd,$10,$00,'%',$f9,$05,$00
	dc.b	'6',$00,$0e,$00,'2',$05,$10,$00
	dc.b	'%',$00,$05,$00,'7',$00,$0e,$00
	dc.b	'2',$00,$10,$00,'%',$fb,$05,$00
	dc.b	'8',$00,$0e,$00,'2',$fb,$10,$00
	dc.b	'%',$00,$05,$00,'#$',$0e,$00
	dc.b	'2',$00,$10,$00,'%',$00,$05,$00
	dc.b	$00,$18,$0e,$00,'2',$00,$10,$00
	dc.b	'%',$00,$0f,$00,'+',$00,$0e,$00
	dc.b	'#',$00,$0e,$00,'&',$00,$0f,$00
	dc.b	',',$00,$0e,$00,'#',$fb,$0e,$00
	dc.b	$27,$00,$0f,$00,'.',$00,$0e,$00
	dc.b	'#',$fd,$0e,$00,'(',$00,$0f,$00
	dc.b	'[',$00,$0e,$00,'#',$04,$0e,$00
	dc.b	'%',$f9,$0f,$00,'.',$00,$0e,$00
	dc.b	'#',$05,$0e,$00,')',$00,$0f,$00
	dc.b	'/',$00,$0e,$00,'#',$0c,$0e,$00
	dc.b	'%',$f9,$0f,$00,'0',$00,$0e,$00
	dc.b	'#',$05,$0e,$00,'*',$fb,$0f,$00
	dc.b	'#&',$0e,$00,'#',$fb,$0e,$00
	dc.b	'%',$00,$0f,$00,'3',$00,$0e,$00
	dc.b	'2',$00,$10,$00,'&',$00,$0f,$00
	dc.b	'4',$00,$0e,$00,'2',$fb,$10,$00
	dc.b	$27,$00,$0f,$00,'5',$00,$0e,$00
	dc.b	'2',$fd,$10,$00,'%',$f9,$0f,$00
	dc.b	'6',$00,$0e,$00,'2',$05,$10,$00
	dc.b	'%',$00,$0f,$00,'7',$00,$0e,$00
	dc.b	'2',$00,$10,$00,'%',$fb,$0f,$00
	dc.b	'8',$00,$0e,$00,'2',$fb,$10,$00
	dc.b	'%',$00,$0f,$00,'#$',$0e,$00
	dc.b	'2',$00,$10,$00,'%',$00,$0f,$00
	dc.b	$00,$18,$0e,$00,'2',$00,$10,$00
	dc.b	'9',$00,$04,$00,'H',$00,$07,$00
	dc.b	':',$00,$00,$00,';',$00,$04,$00
	dc.b	'H',$fe,$07,$00,':',$00,$00,$00
	dc.b	'<',$00,$04,$00,'H',$fb,$07,$00
	dc.b	':',$00,$00,$00,'=',$00,$04,$00
	dc.b	'I',$00,$07,$00,':',$00,$00,$00
	dc.b	'9',$00,$04,$00,'H',$00,$07,$00
	dc.b	':',$00,$00,$00,'>',$00,$04,$00
	dc.b	'H',$fe,$07,$00,':',$00,$00,$00
	dc.b	'?',$00,$04,$00,'H',$00,$07,$00
	dc.b	':',$00,$00,$00,':',$00,$04,$00
	dc.b	':',$00,$07,$00,':',$00,$00,$00
	dc.b	'@',$00,$04,$00,'H',$00,$07,$00
	dc.b	':',$00,$00,$00,'A',$00,$04,$00
	dc.b	'H',$05,$07,$00,':',$00,$00,$00
	dc.b	'B',$00,$04,$00,'H',$00,$07,$00
	dc.b	':',$00,$00,$00,'C',$00,$04,$00
	dc.b	'I',$00,$07,$00,':',$00,$00,$00
	dc.b	'D',$00,$04,$00,'H',$00,$07,$00
	dc.b	':',$00,$00,$00,'E',$00,$04,$00
	dc.b	'H',$fb,$07,$00,':',$00,$00,$00
	dc.b	'F',$00,$04,$00,'I',$00,$07,$00
	dc.b	':',$00,$00,$00,'G',$00,$04,$00
	dc.b	'H',$00,$07,$00,':',$00,$00,$00
	dc.b	'9',$00,$04,$00,'H',$00,$07,$00
	dc.b	'J',$00,$0d,$00,';',$00,$04,$00
	dc.b	'H',$fe,$07,$00,'K',$03,$0d,$00
	dc.b	'<',$00,$04,$00,'H',$fb,$07,$00
	dc.b	'L',$00,$0d,$00,'=',$00,$04,$00
	dc.b	'I',$00,$07,$00,'J',$00,$0d,$00
	dc.b	'9',$00,$04,$00,'H',$00,$07,$00
	dc.b	'J',$00,$0d,$00,'>',$00,$04,$00
	dc.b	'H',$fe,$07,$00,'K',$03,$0d,$00
	dc.b	'?',$00,$04,$00,'H',$00,$07,$00
	dc.b	'J',$00,$0d,$00,':',$00,$04,$00
	dc.b	':',$00,$07,$00,'J',$00,$0d,$00
	dc.b	'@',$00,$04,$00,'H',$00,$07,$00
	dc.b	'J',$00,$0d,$00,'A',$00,$04,$00
	dc.b	'H',$05,$07,$00,'K',$03,$0d,$00
	dc.b	'B',$00,$04,$00,'H',$00,$07,$00
	dc.b	'J',$00,$0d,$00,'C',$00,$04,$00
	dc.b	'I',$00,$07,$00,'J',$00,$0d,$00
	dc.b	'D',$00,$04,$00,'H',$00,$07,$00
	dc.b	'J',$00,$0d,$00,'E',$00,$04,$00
	dc.b	'H',$fb,$07,$00,'L',$00,$0d,$00
	dc.b	'F',$00,$04,$00,'I',$00,$07,$00
	dc.b	'J',$00,$0d,$00,'G',$00,$04,$00
	dc.b	'H',$00,$07,$00,'J',$00,$0d,$00
	dc.b	'9',$00,$0e,$00,'H',$00,$07,$00
	dc.b	'J',$0c,$0d,$00,';',$00,$0e,$00
	dc.b	'H',$fe,$07,$00,'K',$0f,$0d,$00
	dc.b	'<',$00,$0e,$00,'H',$fb,$07,$00
	dc.b	'L',$0c,$0d,$00,'=',$00,$0e,$00
	dc.b	'I',$00,$07,$00,'J',$0c,$0d,$00
	dc.b	'9',$00,$0e,$00,'H',$00,$07,$00
	dc.b	'J',$0c,$0d,$00,'>',$00,$0e,$00
	dc.b	'H',$fe,$07,$00,'K',$0f,$0d,$00
	dc.b	'?',$00,$0e,$00,'H',$00,$07,$00
	dc.b	'J',$0c,$0d,$00,':',$00,$0e,$00
	dc.b	':',$00,$07,$00,'J',$0c,$0d,$00
	dc.b	'@',$00,$0e,$00,'H',$00,$07,$00
	dc.b	'J',$0c,$0d,$00,'A',$00,$0e,$00
	dc.b	'H',$05,$07,$00,'K',$0f,$0d,$00
	dc.b	$01,$00,$0e,$00,'H',$00,$07,$00
	dc.b	'J',$0c,$0d,$00,'C',$00,$0e,$00
	dc.b	'I',$00,$07,$00,'J',$0c,$0d,$00
	dc.b	'D',$00,$0e,$00,'H',$00,$07,$00
	dc.b	'J',$0c,$0d,$00,$02,$00,$0e,$00
	dc.b	'H',$fb,$07,$00,'L',$0c,$0d,$00
	dc.b	'F',$00,$0e,$00,'I',$00,$07,$00
	dc.b	'J',$0c,$0d,$00,'G',$00,$0e,$00
	dc.b	'H',$00,$07,$00,'J',$0c,$0d,$00
	dc.b	'Q',$00,$09,$00,'R',$00,$09,$00
	dc.b	'Q',$00,$0b,$00,'S',$fd,$09,$00
	dc.b	'T',$fd,$09,$00,$00,$00,$00,$00
	dc.b	'Q',$f9,$09,$00,'R',$f9,$09,$00
	dcb.w	2
	dc.b	'Q',$fb,$09,$00,'R',$fb,$09,$00
	dcb.w	2
	dc.b	'Q',$00,$09,$00,'R',$00,$09,$00
	dc.b	'U',$00,$0a,$00,'S',$fd,$09,$00
	dc.b	'T',$fd,$09,$00,'V',$00,$0a,$00
	dc.b	'Q',$f9,$09,$00,'R',$f9,$09,$00
	dc.b	'W',$00,$0a,$00,'Q',$fb,$09,$00
	dc.b	'R',$fb,$09,$00,'X',$00,$0a,$00
	dc.b	'Q',$00,$09,$00,'R',$00,$09,$00
	dc.b	'U',$00,$0a,$00,'S',$fd,$09,$00
	dc.b	'T',$fd,$09,$00,'V',$00,$0a,$00
	dc.b	'Q',$f9,$09,$00,'R',$f9,$09,$00
	dc.b	'W',$00,$0a,$00,'Q',$fb,$09,$00
	dc.b	'R',$fb,$09,$00,'Y',$00,$0a,$00
	dc.b	'Q',$00,$09,$00,'R',$00,$09,$00
	dc.b	'Z',$00,$10,$00,'S',$fd,$09,$00
	dc.b	'T',$fd,$09,$00,'Z',$fd,$10,$00
	dc.b	'Q',$f9,$09,$00,'R',$f9,$09,$00
	dc.b	'Z',$05,$10,$00,'Q',$fb,$09,$00
	dc.b	'R',$fb,$09,$00,'Z',$07,$10,$00
	dc.b	'Q',$00,$09,$00,'R',$00,$09,$00
	dc.b	'Z',$00,$10,$00,'S',$fd,$09,$00
	dc.b	'T',$fd,$09,$00,'Z',$fd,$10,$00
	dc.b	'Q',$f9,$09,$00,'R',$f9,$09,$00
	dc.b	'Z',$05,$10,$00,'Q',$fb,$09,$00
	dc.b	'R',$fb,$09,$00,'Z',$07,$10,$00
	dc.b	'\',$00,$17,$00,'b',$00,$00,$00
	dc.b	']',$00,$01,$00,'\',$00,$17,$00
	dc.b	'b',$f4,$01,$00,']',$fe,$01,$00
	dc.b	'\',$00,$17,$00,'b',$e8,$00,$00
	dc.b	'^',$03,$01,$00,'\',$00,$17,$00
	dc.b	'b',$dc,$00,$00,']',$fe,$01,$00
	dc.b	'\',$00,$17,$00,'_',$00,$00,$00
	dc.b	']',$00,$01,$00,'\',$00,$17,$00
	dc.b	'_',$fe,$00,$00,']',$fe,$01,$00
	dc.b	'\',$00,$17,$00,'`',$03,$00,$00
	dc.b	'^',$03,$01,$00,'\',$00,$17,$00
	dc.b	'a',$00,$00,$00,']',$fe,$01,$00
	dc.b	'\',$00,$17,$00,'_',$00,$00,$00
	dc.b	']',$00,$01,$00,'\',$00,$17,$00
	dc.b	'_',$fe,$00,$00,']',$fe,$01,$00
	dc.b	'\',$00,$17,$00,'`',$03,$00,$00
	dc.b	'^',$03,$01,$00,'\',$00,$17,$00
	dc.b	'a',$00,$00,$00,']',$fe,$01,$00
	dcb.w	7
	dc.b	$00,'/',$00,$03,$00,'0',$00,'_'
	dc.b	$00,$03,$00,'`',$00,$8f,$00,$03
	dc.b	$00,$90,$00,$a3,$00,$06,$00,$a4
	dc.b	$00,$af,$00,$07,$00,$b0,$00,$b0
	dc.b	$00,$06,$00,$b0,$00,$00,$00,$00
	dc.b	$00,$02,$06,$00
l00c0	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	$00,$e0,$00,$f0,$01,$00,'A',$c0
	dc.b	'A',$d0,$00,$c0,$00,$d0,'A',$00
	dc.b	'A',$10,'A',$80,'A',$90,'A',$c0
	dc.b	'A',$d0,$01,'0',$01,'0',$01,'0'
	dc.b	'A',$c0,'A',$d0,$00,$e0,$00,$f0
	dc.b	$00,$80,$00,$90,'!`!p'
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	$01,$00,'!',$80,'!',$90,'A',$c0
	dc.b	'A',$d0,$00,$00,$00,$10,' ',$e0
	dc.b	' ',$f0,'!',$00,'!',$10,'!',$a0
	dc.b	'!',$b0,$00,$e0,$00,$f0,$00,$80
	dc.b	$00,$90,'!`!pA',$c0
	dc.b	'A',$d0,$00,$00,$00,$10,' ',$c0
	dc.b	' ',$d0,$00,$00,$00,$10,'A',$a0
	dc.b	'A',$b0,$01,$00,' ',$e0,' ',$f0
	dc.b	$00,$c0,$00,$d0,'A',$c0,'A',$d0
	dc.b	$00,'`',$00,'p',$00,$80,$00,$90
	dc.b	' ',$c0,' ',$d0,'!',$00,'!',$10
	dc.b	'A',$c0,'A',$d0,$00,'@',$00,'P'
	dc.b	'!',$00,'!',$10,$00,'`',$00,'p'
	dc.b	$00,$80,$00,$90,$00,'`',$00,'p'
	dc.b	'A',$c0,'A',$d0,$00,' ',$00,'0'
	dc.b	'A',$80,'A',$90,'A',$c0,'A',$d0
	dc.b	'!',$80,'!',$90,'!',$a0,'!',$b0
	dc.b	'!`!p',$01,$00,'A`'
	dc.b	'ApA',$c0,'A',$d0,$00,$a0
	dc.b	$00,$b0,'!`!p!',$00
	dc.b	'!',$10,' ',$c0,' ',$d0,'A',$c0
	dc.b	'A',$d0,'!',$a0,'!',$b0,$00,$e0
	dc.b	$00,$f0,$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,$00,$c0,$00,$d0,'!`'
	dc.b	'!p',$00,$80,$00,$90,$00,$00
	dc.b	$00,$10,'!',$a0,'!',$b0,'A',$c0
	dc.b	'A',$d0,$00,' ',$00,'0 ',$a0
	dc.b	' ',$b0,$00,$00,$00,$10,$00,'@'
	dc.b	$00,'P ',$80,' ',$90,'A',$c0
	dc.b	'A',$d0,' ',$c0,' ',$d0,'!',$00
	dc.b	'!',$10,'!',$00,'!',$10,' ',$e0
	dc.b	' ',$f0,'A',$c0,'A',$d0,'!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,$00,$c0
	dc.b	$00,$d0,'!`!p!',$00
	dc.b	'!',$10,'A',$00,'A',$10,'! '
	dc.b	'!0A',$c0,'A',$d0,$01,'0'
	dc.b	$01,'0',$01,'0',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	'!',$a0,'!',$b0,$00,$e0,$00,$f0
	dc.b	$01,$00,'!',$80,'!',$90,'A',$c0
	dc.b	'A',$d0,$00,'`',$00,'p',$00,$80
	dc.b	$00,$90,' ',$c0,' ',$d0,'!',$00
	dc.b	'!',$10,'A',$c0,'A',$d0,$01,$00
	dc.b	'!',$80,'!',$90,'A',$c0,'A',$d0
	dc.b	$00,'@',$00,'P',$00,$00,$00,$10
	dc.b	' ',$a0,' ',$b0,' ',$a0,' ',$b0
	dc.b	$00,$80,$00,$90,$00,'`',$00,'p'
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' !',$a0,'!',$b0,$00,$e0
	dc.b	$00,$f0,$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,$00,' ',$00,'0 ',$a0
	dc.b	' ',$b0,'A',$00,'A',$10,$00,$80
	dc.b	$00,$90,'!',$80,'!',$90,$01,$00
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	$00,'`',$00,'p',$00,$80,$00,$90
	dc.b	' ',$c0,' ',$d0,'!',$00,'!',$10
	dc.b	'A',$c0,'A',$d0,$01,'0',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,' ',$e0,' ',$f0,'!',$00
	dc.b	'!',$10,'A@APA',$c0
	dc.b	'A',$d0,'!',$a0,'!',$b0,$00,$e0
	dc.b	$00,$f0,$01,$00,'!',$80,'!',$90
	dc.b	'A',$c0,'A',$d0,$01,$00,'!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,'!',$a0
	dc.b	'!',$b0,$00,$e0,$00,$f0,$00,$80
	dc.b	$00,$90,$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$00,$e0,$00,$f0,'A',$00,'A',$10
	dc.b	' ',$c0,' ',$d0,$00,$00,$00,$10
	dc.b	' ',$e0,' ',$f0,'A',$c0,'A',$d0
	dc.b	$00,$80,$00,$90,'!@!P'
	dc.b	'A',$00,'A',$10,$00,$00,$00,$10
	dc.b	' ',$a0,' ',$b0,$01,$00,'A',$a0
	dc.b	'A',$b0,'A',$a0,'A',$b0,'A',$c0
	dc.b	'A',$d0,'!',$80,'!',$90,$00,'@'
	dc.b	$00,'P!`!p',$00,$80
	dc.b	$00,$90,$00,$80,$00,$90,' ',$e0
	dc.b	' ',$f0,'A',$c0,'A',$d0,$01,'0'
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	' ',$e0,' ',$f0,'!',$00,'!',$10
	dc.b	'A@APA',$c0,'A',$d0
	dc.b	$01,$00,'A',$c0,'A',$d0,$00,$00
	dc.b	$00,$10,' ',$c0,' ',$d0,'A',$c0
	dc.b	'A',$d0,$00,$c0,$00,$d0,'!',$00
	dc.b	'!',$10,$01,$00,' ',$e0,' ',$f0
	dc.b	$00,$c0,$00,$d0,'A',$c0,'A',$d0
	dc.b	'!',$a0,'!',$b0,'!',$00,'!',$10
	dc.b	'A',$c0,'A',$d0,'! !0'
	dc.b	'!`!p',$00,$80,$00,$90
	dc.b	'!',$80,'!',$90,$00,$80,$00,$90
	dc.b	' ',$e0,' ',$f0,'!',$a0,'!',$b0
	dc.b	'A',$c0,'A',$d0,'A',$80,'A',$90
	dc.b	'!',$00,'!',$10,'A',$00,'A',$10
	dc.b	'A',$c0,'A',$d0,'!',$a0,'!',$b0
	dc.b	$00,$e0,$00,$f0,$00,$80,$00,$90
	dc.b	'A',$c0,'A',$d0,' ',$c0,' ',$d0
	dc.b	$00,$80,$00,$90,' ',$c0,' ',$d0
	dc.b	$00,' ',$00,'0',$00,$80,$00,$90
	dc.b	'!`!p!',$80,'!',$90
	dc.b	'A',$c0,'A',$d0,'!',$00,'!',$10
	dc.b	$00,$a0,$00,$b0,'A',$c0,'A',$d0
	dc.b	'!',$a0,'!',$b0,$00,$e0,$00,$f0
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	$00,' ',$00,'0',$01,'  ',$c0
	dc.b	' ',$d0,$01,' ',$00,$c0,$00,$d0
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	'!',$80,'!',$90,'!',$a0,'!',$b0
	dc.b	'!`!p',$01,$00,'A`'
	dc.b	'ApA',$c0,'A',$d0,'A',$e0
	dc.b	'A',$f0,$00,'@',$00,'P!',$00
	dc.b	'!',$10,$00,'`',$00,'p',$00,$80
	dc.b	$00,$90,'A',$c0,'A',$d0,$00,$00
	dc.b	$00,$10,' ',$e0,' ',$f0,$00,'`'
	dc.b	$00,'pA',$c0,'A',$d0,$00,$c0
	dc.b	$00,$d0,'!`!p',$00,$00
	dc.b	$00,$10,'! !0',$00,$e0
	dc.b	$00,$f0,$01,$00,'A`Ap'
	dc.b	'A`Ap',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,$00
	dc.b	'!',$a0,'!',$b0,'A',$c0,'A',$d0
	dc.b	$01,$00,'!',$80,'!',$90,'A',$c0
	dc.b	'A',$d0,' ',$c0,' ',$d0,$00,$80
	dc.b	$00,$90,'A',$c0,'A',$d0,$01,'0'
	dc.b	'B',$00,'B',$10,$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' !',$80
	dc.b	'!',$90,'!',$a0,'!',$b0,$00,$80
	dc.b	$00,$90,'! !0',$00,$e0
	dc.b	$00,$f0,'A',$80,'A',$90,'A',$c0
	dc.b	'A',$d0,'A',$e0,'A',$f0,'!',$00
	dc.b	'!',$10,'A',$00,'A',$10,'!`'
	dc.b	'!pA',$c0,'A',$d0,'!',$a0
	dc.b	'!',$b0,$00,$80,$00,$90,$00,$00
	dc.b	$00,$10,' ',$c0,' ',$d0,'A',$c0
	dc.b	'A',$d0,$00,'@',$00,'P!`'
	dc.b	'!p',$00,$80,$00,$90,$00,$00
	dc.b	$00,$10,'!',$a0,'!',$b0,'!',$00
	dc.b	'!',$10,'!`!p',$01,' '
	dc.b	$01,' ',$01,' ',$00,$00,$00,$10
	dc.b	' ',$e0,' ',$f0,$00,'`',$00,'p'
	dc.b	'A',$c0,'A',$d0,' ',$c0,' ',$d0
	dc.b	'A',$00,'A',$10,'!',$80,'!',$90
	dc.b	$00,$00,$00,$10,' ',$80,' ',$90
	dc.b	'A',$c0,'A',$d0,$00,'@',$00,'P'
	dc.b	'!`!p',$00,$80,$00,$90
	dc.b	$00,$00,$00,$10,'!',$a0,'!',$b0
	dc.b	'!',$00,'!',$10,'!`!p'
	dc.b	'A',$c0,'A',$d0,'!',$a0,'!',$b0
	dc.b	'!',$00,'!',$10,'!',$00,'!',$10
	dc.b	'A',$c0,'A',$d0,$01,'0B',$00
	dc.b	'B',$10,$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$00,$00,$00,$10,'!',$a0
	dc.b	'!',$b0,$00,$00,$00,$10,' ',$80
	dc.b	' ',$90,$01,$00,$00,'`',$00,'p'
	dc.b	'A',$c0,'A',$d0,'A',$e0,'A',$f0
	dc.b	$00,$c0,$00,$d0,'!`!p'
	dc.b	$00,$00,$00,$10,'! !0'
	dc.b	$00,$e0,$00,$f0,$01,$00,'A`'
	dc.b	'ApA`Ap',$01,' '
	dc.b	$01,' ',$01,' B',$00,'B',$10
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' !',$80
	dc.b	'!',$90,'!',$a0,'!',$b0,'!`'
	dc.b	'!p',$01,$00,' ',$80,' ',$90
	dc.b	$00,$80,$00,$90,'!`!p'
	dc.b	'A',$c0,'A',$d0,'A',$e0,'A',$f0
	dc.b	$00,$00,$00,$10,'A',$c0,'A',$d0
	dc.b	' ',$e0,' ',$f0,$00,$80,$00,$90
	dc.b	'A@APA',$c0,'A',$d0
	dc.b	' ',$c0,' ',$d0,$00,$80,$00,$90
	dc.b	' ',$c0,' ',$d0,$00,' ',$00,'0'
	dc.b	$00,$80,$00,$90,'!`!p'
	dc.b	'B',$00,'B',$10,$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$00,$00
	dc.b	$00,$10,' ',$e0,' ',$f0,$00,'`'
	dc.b	$00,'pA',$c0,'A',$d0,'! '
	dc.b	'!0',$00,$00,$00,$10,$00,'@'
	dc.b	$00,'P',$00,$80,$00,$90,'!`'
	dc.b	'!pA',$c0,'A',$d0,'A',$e0
	dc.b	'A',$f0,$00,$00,$00,$10,'A',$c0
	dc.b	'A',$d0,$00,$c0,$00,$d0,'!',$00
	dc.b	'!',$10,'!',$00,'!',$10,$00,'`'
	dc.b	$00,'pA',$c0,'A',$d0,$00,$a0
	dc.b	$00,$b0,'!`!p',$01,$00
	dc.b	$00,$80,$00,$90,' ',$e0,' ',$f0
	dc.b	$00,'`',$00,'pB',$00,'B',$10
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' A',$80,'A',$90,'!',$00
	dc.b	'!',$10,'A',$00,'A',$10,'A',$c0
	dc.b	'A',$d0,$00,'@',$00,'P',$00,$00
	dc.b	$00,$10,' ',$e0,' ',$f0,'A',$c0
	dc.b	'A',$d0,$00,$80,$00,$90,'A`'
	dc.b	'Ap',$01,$00,'!',$a0,'!',$b0
	dc.b	'A',$c0,'A',$d0,'!',$a0,'!',$b0
	dc.b	$00,$e0,$00,$f0,$01,$00,'!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,'!',$80
	dc.b	'!',$90,'A',$00,'A',$10,'! '
	dc.b	'!0',$00,$80,$00,$90,'!`'
	dc.b	'!p',$00,' ',$00,'0A',$c0
	dc.b	'A',$d0,$00,'`',$00,'p',$00,$80
	dc.b	$00,$90,' ',$c0,' ',$d0,'!',$00
	dc.b	'!',$10,'A',$c0,'A',$d0,$00,' '
	dc.b	$00,'0A',$80,'A',$90,'A',$c0
	dc.b	'A',$d0,'! !0!`'
	dc.b	'!p',$00,$80,$00,$90,'!',$80
	dc.b	'!',$90,'!',$80,'!',$90,$01,$00
	dc.b	' ',$e0,' ',$f0,$00,$c0,$00,$d0
	dc.b	'A',$c0,'A',$d0,'!',$a0,'!',$b0
	dc.b	$00,$e0,$00,$f0,$00,$80,$00,$90
	dc.b	'A',$c0,'A',$d0,'!',$80,'!',$90
	dc.b	'! !0',$00,$00,$00,$10
	dc.b	$00,'@',$00,'P',$00,$80,$00,$90
	dc.b	'A',$c0,'A',$d0,$00,' ',$00,'0'
	dc.b	$00,$00,$00,$10,'!`!p'
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$00,'@',$00,'P',$00,$e0,$00,$f0
	dc.b	$00,$00,$00,$10,' ',$e0,' ',$f0
	dc.b	$00,$c0,$00,$d0,$00,$80,$00,$90
	dc.b	'A',$c0,'A',$d0,'!',$a0,'!',$b0
	dc.b	$00,$e0,$00,$f0,$00,$80,$00,$90
	dc.b	'A',$c0,'A',$d0,' ',$c0,' ',$d0
	dc.b	'A',$00,'A',$10,'!',$80,'!',$90
	dc.b	$00,$00,$00,$10,' ',$80,' ',$90
	dc.b	'!',$80,'!',$90,'A',$c0,'A',$d0
	dc.b	'A@AP',$01,$00,'!',$a0
	dc.b	'!',$b0,$00,$e0,$00,$f0,'A',$c0
	dc.b	'A',$d0,'!',$a0,'!',$b0,$00,$e0
	dc.b	$00,$f0,$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,'!',$00,'!',$10,' ',$e0
	dc.b	' ',$f0,$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,'!',$a0,'!',$b0,'!',$00
	dc.b	'!',$10,'A',$c0,'A',$d0,$00,$a0
	dc.b	$00,$b0,$01,$00,'A A0'
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	' ',$80,' ',$90,$00,$80,$00,$90
	dc.b	'A',$80,'A',$90,'!',$80,'!',$90
	dc.b	'A',$c0,'A',$d0,$01,'0',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' !',$a0,'!',$b0,$00,$e0
	dc.b	$00,$f0,'!',$00,'!',$10,'!',$80
	dc.b	'!',$90,$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,' ',$c0,' ',$d0,'A',$00
	dc.b	'A',$10,'!',$80,'!',$90,$00,$00
	dc.b	$00,$10,' ',$80,' ',$90,'!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,'A@'
	dc.b	'AP',$00,$80,$00,$90,'!`'
	dc.b	'!p',$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,$00,'@',$00,'P!',$00
	dc.b	'!',$10,$00,'`',$00,'p',$00,$80
	dc.b	$00,$90,$00,'`',$00,'pA',$c0
	dc.b	'A',$d0,$00,' ',$00,'0A',$80
	dc.b	'A',$90,'A',$c0,'A',$d0,'!',$a0
	dc.b	'!',$b0,$00,$e0,$00,$f0,$00,$80
	dc.b	$00,$90,'A',$c0,'A',$d0,$00,$c0
	dc.b	$00,$d0,'!`!p',$00,$80
	dc.b	$00,$90,$00,$00,$00,$10,'!',$a0
	dc.b	'!',$b0,'A',$c0,'A',$d0,' ',$c0
	dc.b	' ',$d0,$00,$00,$00,$10,$00,'`'
	dc.b	$00,'pA',$c0,'A',$d0,' ',$c0
	dc.b	' ',$d0,$00,$00,$00,$10,'A`'
	dc.b	'ApA',$c0,'A',$d0,'!',$80
	dc.b	'!',$90,'!',$00,'!',$10,'A',$c0
	dc.b	'A',$d0,$00,$e0,$00,$f0,$01,$00
	dc.b	'A',$c0,'A',$d0,$00,$00,$00,$10
	dc.b	' ',$e0,' ',$f0,$00,'`',$00,'p'
	dc.b	'A',$c0,'A',$d0,'!',$a0,'!',$b0
	dc.b	$00,$e0,$00,$f0,$00,$00,$00,$10
	dc.b	' ',$e0,' ',$f0,'A`Ap'
	dc.b	'A`ApA',$c0,'A',$d0
	dc.b	'!',$a0,'!',$b0,'!',$00,'!',$10
	dc.b	'A',$c0,'A',$d0,$00,$e0,$00,$f0
	dc.b	$01,$00,' ',$c0,' ',$d0,'A',$c0
	dc.b	'A',$d0,$01,'0',$01,'0',$01,'0'
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,$00,' ',$00,'0A',$80
	dc.b	'A',$90,'A',$c0,'A',$d0,'! '
	dc.b	'!0!`!p',$00,$80
	dc.b	$00,$90,'!',$80,'!',$90,'!',$80
	dc.b	'!',$90,$01,$00,' ',$e0,' ',$f0
	dc.b	$00,$c0,$00,$d0,'A',$c0,'A',$d0
	dc.b	'!',$a0,'!',$b0,$00,$e0,$00,$f0
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	$00,$a0,$00,$b0,'A',$00,'A',$10
	dc.b	' ',$e0,' ',$f0,$00,'@',$00,'P'
	dc.b	'!',$a0,'!',$b0,$01,$00,'!',$00
	dc.b	'!',$10,' ',$e0,' ',$f0,'A',$c0
	dc.b	'A',$d0,' ',$80,' ',$90,$00,$80
	dc.b	$00,$90,'A',$80,'A',$90,'!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,'A',$80
	dc.b	'A',$90,'!',$00,'!',$10,'A',$00
	dc.b	'A',$10,'A',$c0,'A',$d0,$00,'@'
	dc.b	$00,'P',$00,$00,$00,$10,' ',$e0
	dc.b	' ',$f0,'A',$c0,'A',$d0,$00,'@'
	dc.b	$00,'P',$00,$e0,$00,$f0,$00,$00
	dc.b	$00,$10,' ',$e0,' ',$f0,$00,$c0
	dc.b	$00,$d0,$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,'!',$a0,'!',$b0,$00,$e0
	dc.b	$00,$f0,$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,$00,'@',$00,'P!',$00
	dc.b	'!',$10,' ',$a0,' ',$b0,'!',$00
	dc.b	'!',$10,'!`!p!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,'!',$a0
	dc.b	'!',$b0,'!',$00,'!',$10,'!',$00
	dc.b	'!',$10,'A',$c0,'A',$d0,$01,'0'
	dc.b	$01,'0',$01,'0',$01,'0',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,$00
	dc.b	'A',$c0,'A',$d0,$00,$00,$00,$10
	dc.b	' ',$c0,' ',$d0,'A',$c0,'A',$d0
	dc.b	$00,$00,$00,$10,'A',$c0,'A',$d0
	dc.b	$00,$a0,$00,$b0,$00,$00,$00,$10
	dc.b	' ',$e0,' ',$f0,'!',$a0,'!',$b0
	dc.b	$00,$00,$00,$10,'!',$80,'!',$90
	dc.b	'!',$a0,'!',$b0,$01,$00,$00,'@'
	dc.b	$00,'PA',$c0,'A',$d0,$00,'@'
	dc.b	$00,'P!',$00,'!',$10,$00,'`'
	dc.b	$00,'p',$00,$80,$00,$90,'!`'
	dc.b	'!pA',$c0,'A',$d0,$01,'0'
	dc.b	$01,'0',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' A',$e0,'A',$f0,$00,' '
	dc.b	$00,'0A',$00,'A',$10,'!',$a0
	dc.b	'!',$b0,'A',$c0,'A',$d0,' ',$e0
	dc.b	' ',$f0,'!',$00,'!',$10,'!',$a0
	dc.b	'!',$b0,'A',$c0,'A',$d0,'!',$a0
	dc.b	'!',$b0,$00,$e0,$00,$f0,$00,$80
	dc.b	$00,$90,'A',$c0,'A',$d0,'!',$00
	dc.b	'!',$10,' ',$e0,' ',$f0,' ',$a0
	dc.b	' ',$b0,'A',$80,'A',$90,'A',$c0
	dc.b	'A',$d0,'!',$00,'!',$10,' ',$e0
	dc.b	' ',$f0,$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,$00,$00,$00,$10,' ',$e0
	dc.b	' ',$f0,$00,'`',$00,'pA',$c0
	dc.b	'A',$d0,$00,'@',$00,'P',$00,$80
	dc.b	$00,$90,'!`!p!',$a0
	dc.b	'!',$b0,$00,$00,$00,$10,$01,$00
	dc.b	' ',$e0,' ',$f0,' ',$a0,' ',$b0
	dc.b	'A',$80,'A',$90,'A',$c0,'A',$d0
	dc.b	' ',$e0,' ',$f0,'!',$00,'!',$10
	dc.b	'!',$a0,'!',$b0,'A',$c0,'A',$d0
	dc.b	'!',$a0,'!',$b0,$00,$e0,$00,$f0
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	$00,' ',$00,'0',$00,$80,$00,$90
	dc.b	'!',$80,'!',$90,'!',$a0,'!',$b0
	dc.b	'A',$c0,'A',$d0,$01,'0B',$00
	dc.b	'B',$10,$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,' ',$e0,' ',$f0
	dc.b	'!',$00,'!',$10,'A@AP'
	dc.b	'A',$c0,'A',$d0,$00,$00,$00,$10
	dc.b	'A',$c0,'A',$d0,' ',$a0,' ',$b0
	dc.b	$01,$00,'!',$a0,'!',$b0,'!',$a0
	dc.b	'!',$b0,' ',$a0,' ',$b0,$00,$80
	dc.b	$00,$90,'A',$c0,'A',$d0,'!',$80
	dc.b	'!',$90,'!',$a0,'!',$b0,'!',$00
	dc.b	'!',$10,'!`!pA',$80
	dc.b	'A',$90,'A',$c0,'A',$d0,$00,$00
	dc.b	$00,$10,$00,' ',$00,'0!',$00
	dc.b	'!',$10,'A',$00,'A',$10,'!',$a0
	dc.b	'!',$b0,'A',$c0,'A',$d0,'!',$a0
	dc.b	'!',$b0,$00,$e0,$00,$f0,$01,$00
	dc.b	'!',$80,'!',$90,'A',$c0,'A',$d0
	dc.b	'!',$80,'!',$90,$00,'@',$00,'P'
	dc.b	'!`!p',$00,$80,$00,$90
	dc.b	$00,$80,$00,$90,' ',$e0,' ',$f0
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' A',$c0,'A',$d0,$01,$00
	dc.b	'!',$a0,'!',$b0,'A',$c0,'A',$d0
	dc.b	$01,$00,'!',$80,'!',$90,'A',$c0
	dc.b	'A',$d0,'!',$a0,'!',$b0,$00,$e0
	dc.b	$00,$f0,$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,'!',$80,'!',$90,$00,$80
	dc.b	$00,$90,$00,'@',$00,'P!',$00
	dc.b	'!',$10,' ',$e0,' ',$f0,$00,'`'
	dc.b	$00,'pA',$c0,'A',$d0,$01,$00
	dc.b	'A',$c0,'A',$d0,$00,'`',$00,'p'
	dc.b	$00,$80,$00,$90,'!',$80,'!',$90
	dc.b	$01,$00,$00,$c0,$00,$d0,' ',$e0
	dc.b	' ',$f0,$00,$80,$00,$90,$00,'`'
	dc.b	$00,'pA',$c0,'A',$d0,$00,$00
	dc.b	$00,$10,' ',$e0,' ',$f0,$00,'`'
	dc.b	$00,'pA',$c0,'A',$d0,$01,$00
	dc.b	'!',$a0,'!',$b0,'A',$c0,'A',$d0
	dc.b	$00,$c0,$00,$d0,$00,$00,$00,$10
	dc.b	'A A0',$00,$80,$00,$90
	dc.b	'A',$c0,'A',$d0,' ',$c0,' ',$d0
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	'!',$a0,'!',$b0,$00,$e0,$00,$f0
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	$01,$00,$00,'`',$00,'p',$00,$80
	dc.b	$00,$90,$00,$00,$00,$10,'A',$c0
	dc.b	'A',$d0,'!',$00,'!',$10,$00,$a0
	dc.b	$00,$b0,'A',$c0,'A',$d0,$00,'@'
	dc.b	$00,'P!',$00,'!',$10,$00,'`'
	dc.b	$00,'p',$01,$00,' ',$e0,' ',$f0
	dc.b	$00,$c0,$00,$d0,'A',$c0,'A',$d0
	dc.b	$00,$00,$00,$10,'A',$c0,'A',$d0
	dc.b	'A@AP',$00,$e0,$00,$f0
	dc.b	'!',$00,'!',$10,' ',$a0,' ',$b0
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	$00,'`',$00,'p',$00,$80,$00,$90
	dc.b	' ',$c0,' ',$d0,'!',$00,'!',$10
	dc.b	' ',$e0,' ',$f0,'!',$80,'!',$90
	dc.b	'!',$a0,'!',$b0,'!`!p'
	dc.b	$00,$00,$00,$10,'!',$a0,'!',$b0
	dc.b	$01,$00,'!',$00,'!',$10,' ',$e0
	dc.b	' ',$f0,$01,' ',$01,' ',$01,' '
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'!',$80,'!',$90
	dc.b	'!',$00,'!',$10,'A',$c0,'A',$d0
	dc.b	$01,$00,'!',$a0,'!',$b0,'A',$c0
	dc.b	'A',$d0,$01,$00,'!',$80,'!',$90
	dc.b	'A',$c0,'A',$d0,' ',$e0,' ',$f0
	dc.b	'!',$00,'!',$10,'!',$a0,'!',$b0
	dc.b	'A',$c0,'A',$d0,'!',$a0,'!',$b0
	dc.b	$00,$80,$00,$90,$00,'@',$00,'P'
	dc.b	$00,$e0,$00,$f0,' ',$e0,' ',$f0
	dc.b	$01,$00,$00,'@',$00,'P',$00,$00
	dc.b	$00,$10,' ',$a0,' ',$b0,'A',$80
	dc.b	'A',$90,'A',$c0,'A',$d0,'! '
	dc.b	'!0',$00,$80,$00,$90,'!`'
	dc.b	'!p',$00,$a0,$00,$b0,$00,$80
	dc.b	$00,$90,$00,'@',$00,'P!',$a0
	dc.b	'!',$b0,'A',$c0,'A',$d0,'A',$e0
	dc.b	'A',$f0,'!',$a0,'!',$b0,$00,$e0
	dc.b	$00,$f0,$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,'!',$80,'!',$90,$00,'@'
	dc.b	$00,'P!`!p!',$00
	dc.b	'!',$10,' ',$a0,' ',$b0,' ',$a0
	dc.b	' ',$b0,$01,$00,' ',$e0,' ',$f0
	dc.b	$00,$c0,$00,$d0,'A',$c0,'A',$d0
	dc.b	$01,$00,'!',$80,'!',$90,'A',$c0
	dc.b	'A',$d0,'!',$a0,'!',$b0,'!',$00
	dc.b	'!',$10,'!',$00,'!',$10,'A',$c0
	dc.b	'A',$d0,$00,$a0,$00,$b0,$00,$00
	dc.b	$00,$10,'!',$80,'!',$90,'!',$a0
	dc.b	'!',$b0,'B',$00,'B',$10,'A',$c0
	dc.b	'A',$d0,$00,' ',$00,'0A',$00
	dc.b	'A',$10,'!',$a0,'!',$b0,'A',$c0
	dc.b	'A',$d0,$01,$00,'A',$c0,'A',$d0
	dc.b	'A@AP',$00,$00,$00,$10
	dc.b	' ',$e0,' ',$f0,'!',$a0,'!',$b0
	dc.b	$00,$80,$00,$90,$00,'`',$00,'p'
	dc.b	'A',$c0,'A',$d0,'!',$a0,'!',$b0
	dc.b	'!',$00,'!',$10,'A',$c0,'A',$d0
	dc.b	'!',$80,'!',$90,$00,$e0,$00,$f0
	dc.b	'!',$00,'!',$10,'A@AP'
	dc.b	'A',$c0,'A',$d0,' ',$c0,' ',$d0
	dc.b	'A',$80,'A',$90,'A',$c0,'A',$d0
	dc.b	$00,$a0,$00,$b0,$01,$00,'!`'
	dc.b	'!p!',$a0,'!',$b0,'!',$80
	dc.b	'!',$90,'A',$c0,'A',$d0,$00,'@'
	dc.b	$00,'P!',$00,'!',$10,$00,'`'
	dc.b	$00,'p',$00,$80,$00,$90,'!',$80
	dc.b	'!',$90,$01,' ',$01,' ',$01,' '
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'! !0 ',$a0,' ',$b0
	dc.b	$00,$80,$00,$90,$00,$00,$00,$10
	dc.b	'!',$80,'!',$90,$00,$80,$00,$90
	dc.b	'A',$c0,'A',$d0,$00,'`',$00,'p'
	dc.b	'!',$00,'!',$10,'A',$c0,'A',$d0
	dc.b	' ',$e0,' ',$f0,'!',$00,'!',$10
	dc.b	'!',$a0,'!',$b0,'A',$c0,'A',$d0
	dc.b	' ',$a0,' ',$b0,$00,$00,$00,$10
	dc.b	'A',$00,'A',$10,$00,$c0,$00,$d0
	dc.b	$00,$e0,$00,$f0,'!',$a0,'!',$b0
	dc.b	'A',$c0,'A',$d0,$01,'0',$01,'0'
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,'A@'
	dc.b	'AP',$00,$80,$00,$90,' ',$a0
	dc.b	' ',$b0,' ',$a0,' ',$b0,'A',$c0
	dc.b	'A',$d0,'!',$a0,'!',$b0,$00,$e0
	dc.b	$00,$f0,$00,$00,$00,$10,'!',$a0
	dc.b	'!',$b0,'A',$c0,'A',$d0,$01,$00
	dc.b	'!',$80,'!',$90,'A',$c0,'A',$d0
	dc.b	'!',$a0,'!',$b0,$00,$e0,$00,$f0
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	$00,$80,$00,$90,' ',$e0,' ',$f0
	dc.b	$00,'`',$00,'pA',$c0,'A',$d0
	dc.b	' ',$e0,' ',$f0,'!',$00,'!',$10
	dc.b	'A@APA',$c0,'A',$d0
	dc.b	$01,'0',$01,'0',$01,'0A',$c0
	dc.b	'A',$d0,'A',$c0,'A',$d0,$00,' '
	dc.b	$00,'0A',$80,'A',$90,$00,$80
	dc.b	$00,$90,'A',$c0,'A',$d0,$00,' '
	dc.b	$00,'0A',$80,'A',$90,$00,$80
	dc.b	$00,$90,'A',$c0,'A',$d0,$01,'0'
	dc.b	$01,'0',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A@AP'
	dc.b	$00,$e0,$00,$f0,$00,$00,$00,$10
	dc.b	'!',$a0,'!',$b0,'A',$c0,'A',$d0
	dc.b	$00,$00,$00,$10,'!`!p'
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	'A',$80,'A',$90,'!',$00,'!',$10
	dc.b	'A',$00,'A',$10,'A',$c0,'A',$d0
	dc.b	'A@AP',$00,$00,$00,$10
	dc.b	$01,$00,'!',$a0,'!',$b0,$01,$00
	dc.b	' ',$e0,' ',$f0,$00,$c0,$00,$d0
	dc.b	'A',$c0,'A',$d0,$00,$a0,$00,$b0
	dc.b	'!',$00,'!',$10,'!`!p'
	dc.b	'A',$c0,'A',$d0,$01,' ',$01,' '
	dc.b	$01,' ',$01,' A',$c0,'A',$d0
	dc.b	'!',$a0,'!',$b0,$00,$e0,$00,$f0
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	$00,$a0,$00,$b0,$00,$00,$00,$10
	dc.b	'!',$a0,'!',$b0,$00,$e0,$00,$f0
	dc.b	$00,$80,$00,$90,'!`!p'
	dc.b	'A',$c0,'A',$d0,'A`Ap'
	dc.b	' ',$c0,' ',$d0,$00,$00,$00,$10
	dc.b	'!',$80,'!',$90,'A',$c0,'A',$d0
	dc.b	$00,'@',$00,'P!',$00,'!',$10
	dc.b	' ',$c0,' ',$d0,$01,$00,' ',$e0
	dc.b	' ',$f0,$00,$c0,$00,$d0,'A',$c0
	dc.b	'A',$d0,$01,' ',$01,' ',$01,' '
	dc.b	$01,' ',$01,' ',$01,' ',$01,' '
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	$00,' ',$00,'0A',$80,'A',$90
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	$00,' ',$00,'0A',$80,'A',$90
	dc.b	$00,$80,$00,$90,'A',$c0,'A',$d0
	dc.b	$01,'0',$01,'0',$01,'0',$01,'0'
	dc.b	$01,'0',$01,'0A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,$01,$00,'A',$c0
	dc.b	'A',$d0,'!',$80,'!',$90,$00,$80
	dc.b	$00,$90,$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,'A',$80,'A',$90,'!',$00
	dc.b	'!',$10,'A',$00,'A',$10,'A',$c0
	dc.b	'A',$d0,$00,$00,$00,$10,'!`'
	dc.b	'!p',$00,$80,$00,$90,'A',$c0
	dc.b	'A',$d0,'!',$80,'!',$90,'!',$a0
	dc.b	'!',$b0,$01,$00,' ',$a0,' ',$b0
	dc.b	' ',$a0,' ',$b0,'A',$c0,'A',$d0
	dc.b	'A@AP',$01,$00,'!',$a0
	dc.b	'!',$b0,$00,$e0,$00,$f0,'A',$c0
	dc.b	'A',$d0,'A',$00,'A',$10,'!',$80
	dc.b	'!',$90,$01,' ',$01,' ',$01,' '
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A@AP',$00,$80,$00,$90
	dc.b	' ',$a0,' ',$b0,' ',$a0,' ',$b0
	dc.b	'A',$c0,'A',$d0,$01,$00,'A',$c0
	dc.b	'A',$d0,' ',$c0,' ',$d0,'A',$00
	dc.b	'A',$10,'!',$80,'!',$90,'!',$a0
	dc.b	'!',$b0,'A',$c0,'A',$d0,'!`'
	dc.b	'!p',$00,$80,$00,$90,'! '
	dc.b	'!0',$00,$80,$00,$90,$00,$00
	dc.b	$00,$10,'!',$a0,'!',$b0,'A',$c0
	dc.b	'A',$d0,' ',$c0,' ',$d0,'A',$80
	dc.b	'A',$90,'!',$80,'!',$90,$00,$80
	dc.b	$00,$90,' ',$a0,' ',$b0,$00,$a0
	dc.b	$00,$b0,'A',$c0,'A',$d0,'!',$a0
	dc.b	'!',$b0,$00,$e0,$00,$f0,$00,$80
	dc.b	$00,$90,' ',$e0,' ',$f0,$01,' '
	dc.b	$01,' ',$01,' A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'A',$c0,'A',$d0
	dc.b	'A',$c0,'A',$d0,'a',$a0,'a',$b0
	dc.b	'a',$a0,'a',$b0,'a',$a0,'a',$b0
	dc.b	'a',$a0,'a',$b0,'a',$a0,'a',$b0
	dc.b	'a',$a0,'a',$b0,'a',$a0,'a',$b0
	dc.b	'a',$a0,'a',$b0,'a',$a0,'a',$b0
	dc.b	'a',$a0,'a',$b0,'a',$a0,'a',$b0
	dc.b	'a',$a0,'a',$b0,'a',$a0
l00c1	dcb.w	4
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
	dc.b	$9f,$ff,$9f,$ff,'`',$00,$e0,$00
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
	dc.b	'`',$00,$e0,$00,$1f,$ff,$e0,$00
	dc.b	$00,$00,$00,$0e,$ff,$fe,$00,$0e
	dc.b	$e0,$00,$e0,$00,$1f,$ff,$e0,$00
	dc.b	$00,$16,$00,$0e,$ff,$e0,$00,$1e
	dc.b	$00,$18,$00,' ',$00,$07,$00,'8'
	dc.b	' ',$00,$00,$00,$f8,$00,'8',$00
	dc.b	'_',$ff,$a0,$00,$1f,$ff,$e0,$00
	dc.b	$ff,'`',$00,'p',$ff,$90,$01,$f0
	dc.b	$1f,$80,$e0,'`',$1f,$e0,$e0,$e0
	dcb.w	4
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
	dc.b	'`',$00,$90,$00,$f0,$00,$f0,$00
	dc.b	$00,$07,$00,$07,$00,$08,$00,$0f
	dc.b	$f8,$00,$06,$00,$fe,$00,$06,$00
	dcb.w	8
	dc.b	$e0,',',$ff,'3',$1f,$c0,$e0,$ff
	dc.b	$92,$0e,$9f,$f0
l00c2	bsr.s	l00c2
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
	dc.b	'`',$00,$88,$00,$f8,$00,$f8,$00
	dcb.w	8
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
	dcb.w	8
l00c3	dc.b	$00,$9e,$00,$9d,$00,$9c,$00,$9b
	dc.b	$00,$99,$00,$96,$00,$93,$00,$8f
	dc.b	$00,$8b,$00,$86,$00,$81,$00,'|'
	dc.b	$00,'v',$00,'p',$00,'j',$00,'d'
	dc.b	$00,'^',$00,'W',$00,'Q',$00,'K'
	dc.b	$00,'E',$00,'?',$00,':',$00,'5'
	dc.b	$00,'0',$00,',',$00,'(',$00,'%'
	dc.b	$00,'"',$00,' ',$00,$1f,$00,$1e
	dc.b	$00,$1e,$00,$1e,$00,$1f,$00,' '
	dc.b	$00,'"',$00,'%',$00,'(',$00,','
	dc.b	$00,'0',$00,'5',$00,':',$00,'?'
	dc.b	$00,'E',$00,'K',$00,'Q',$00,'W'
	dc.b	$00,']',$00,'d',$00,'j',$00,'p'
	dc.b	$00,'v',$00,'|',$00,$81,$00,$86
	dc.b	$00,$8b,$00,$8f,$00,$93,$00,$96
	dc.b	$00,$99,$00,$9b,$00,$9c
l00c4	dc.b	$00,$1e,$00,$1e,$00,$1f,$00,' '
	dc.b	$00,'"',$00,'%',$00,'(',$00,','
	dc.b	$00,'0',$00,'5',$00,':',$00,'?'
	dc.b	$00,'E',$00,'K',$00,'Q',$00,'W'
	dc.b	$00,']',$00,'d',$00,'j',$00,'p'
	dc.b	$00,'v',$00,'|',$00,$81,$00,$86
	dc.b	$00,$8b,$00,$8f,$00,$93,$00,$96
	dc.b	$00,$99,$00,$9b,$00,$9c,$00,$9d
	dc.b	$00,$9e,$00,$9d,$00,$9c,$00,$9b
	dc.b	$00,$99,$00,$96,$00,$93,$00,$8f
	dc.b	$00,$8b,$00,$86,$00,$81,$00,'|'
	dc.b	$00,'v',$00,'p',$00,'j',$00,'d'
	dc.b	$00,'^',$00,'W',$00,'Q',$00,'K'
	dc.b	$00,'E',$00,'?',$00,':',$00,'5'
	dc.b	$00,'0',$00,',',$00,'(',$00,'%'
	dc.b	$00,'"',$00,' ',$00,$1f
l00c5	dc.b	$00,$00,$00,$01
l00c6	dc.b	$00,$12,$00,'#'
l00c7	dc.b	$00,'$',$00,'5'
l00c8	dc.b	$00,'F',$00,'W'
l00c9	dc.b	$00,$00,$01,$00
l00ca	dc.b	$02,$00,$03,$00
l00cb	dc.b	$04,$00,$05,$00
l00cc	dc.b	$06,$00,$07,$00
l00cd	dc.b	$00,$00,$00,$10
l00ce	dc.b	$00,' ',$00,'0'
l00cf	dc.b	$00,'@',$00,'P'
l00d0	dc.b	$00,'`',$00,'p'
l00d1	dc.b	$00,$00,$00,$01
l00d2	dc.b	$00,$02,$00,$03
l00d3	dc.b	$00,$04,$00,$05
l00d4	dc.b	$00,$06,$00,$07
l00d5	dc.b	$00,$00,$01,$01
l00d6	dc.b	$02,$02,$03,$03
l00d7	dc.b	$04,$04,$05,$05
l00d8	dc.b	$06,$06,$07,$07
l00d9	dc.b	$03,'`',$07,'w'
l00da	dc.b	$06,'f',$05,'U'
l00db	dc.b	$04,'D',$03,'3'
l00dc	dc.b	$02,'"',$07,'w'
l00dd	dc.b	$03,'`',$07,'p'
l00de	dc.b	$07,'`',$06,'P'
l00df	dc.b	$05,'@',$04,'0'
l00e0	dc.b	$03,' ',$07,'w'
l00e1	dc.b	$03,'`',$00,'w'
l00e2	dc.b	$00,'f',$00,'U'
l00e3	dc.b	$00,'D',$00,'3'
l00e4	dc.b	$00,'"',$00,'w'
	bss
l00e5	ds.w	1
l00e6	ds.w	1
l00e7	ds.w	1
l00e8	ds.w	1
l00e9	ds.w	1
l00ea	ds.l	1
l00eb	ds.w	1
l00ec	ds.w	1
l00ed	ds.l	1
l00ee	ds.w	1
l00ef	ds.w	1
l00f0	ds.w	1
l00f1	ds.w	1
l00f2	ds.w	1
l00f3	ds.l	1
l00f4	ds.w	1
l00f5	ds.w	1
l00f6	ds.w	1
l00f7	ds.b	134
l00f8	ds.l	1
l00f9	ds.w	1
l00fa	ds.w	1
l00fb	ds.w	1
l00fc	ds.w	1
l00fd	ds.w	1
l00fe	ds.w	1
l00ff	ds.w	1
l0100	ds.l	1
l0101	ds.l	1
l0102	ds.w	1
l0103	ds.w	1
l0104	ds.w	1
l0105	ds.w	1
l0106	ds.w	1
l0107	ds.w	1
l0108	ds.b	36
l0109	ds.l	1
l010a	ds.l	1
l010b	ds.l	1
l010c	ds.l	1
l010d	ds.l	1
l010e	ds.l	1
l010f	ds.l	1
l0110	ds.l	1
l0111	ds.l	1
l0112	ds.l	1
l0113	ds.b	8
l0114	ds.b	1
l0115	ds.b	1
l0116	ds.b	1
l0117	ds.b	1
l0118	ds.b	1
l0119	ds.b	1
zuend	end
