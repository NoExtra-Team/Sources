;	opt	x+
;========================================
	text
;========================================
begin	clr.l	-(sp)
	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp
	move.l	d0,-(sp)

	move.b	#$e,$484.l

	move.w	#1,d0
	jsr	l005e+44
	move.l	#l005e+44+8,$4d2.l

	dc.W	$a00a

	pea	l0053+2
	move.w	#6,-(sp)		;setpallete
	trap	#14
	addq.l	#2,sp

	move.w	#2,-(sp)		;physbase
	trap	#14
	addq.l	#2,sp

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
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	move.l	l0053+34+5280,(a2)+
	move.l	l0053+34+5284,(a2)+
	addi.l	#8,l010a
	movea.l	l00f8,a1
	lea	152(a1),a1
	cmpa.l	l010a,a1
	beq	l0007

	bra	l0008

l0007	lea	-8(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	move.l	l00f8,l010a
l0008	movea.l	l010b,a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	move.l	l0053+34+5280,(a2)+
	move.l	l0053+34+5284,(a2)+
	addi.l	#8,l010b
	movea.l	l00f8,a1
	lea	472(a1),a1
	cmpa.l	l010b,a1
	beq	l0009

	bra	l000a

l0009	lea	-8(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	move.l	l00f8,l010b
	addi.l	#$140,l010b
l000a	movea.l	l010c,a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	move.l	l0053+34+5280,(a2)+
	move.l	l0053+34+5284,(a2)+
	addi.l	#8,l010c
	movea.l	l00f8,a1
	lea	792(a1),a1
	cmpa.l	l010c,a1
	beq	l000b

	bra	l000c

l000b	lea	-8(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	move.l	l00f8,l010c
	addi.l	#$280,l010c
l000c	movea.l	l010d,a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	move.l	l0053+34+5280,(a2)+
	move.l	l0053+34+5284,(a2)+
	addi.l	#8,l010d
	movea.l	l00f8,a1
	lea	1112(a1),a1
	cmpa.l	l010d,a1
	beq	l000d

	bra	l000e

l000d	lea	-8(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	move.l	l00f8,l010d
	addi.l	#$3c0,l010d
l000e	movea.l	l010e,a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	move.l	l0053+34+5280,(a2)+
	move.l	l0053+34+5284,(a2)+
	addi.l	#8,l010e
	movea.l	l00f8,a1
	lea	1432(a1),a1
	cmpa.l	l010e,a1
	beq	l000f

	bra	l0010

l000f	lea	-8(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	move.l	l00f8,l010e
	addi.l	#$500,l010e
l0010	movea.l	l010f,a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	-112(a2),a2
	lea	1272(a2),a2
	move.l	l0053+34+5440,(a2)+
	move.l	l0053+34+5444,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5440,(a2)+
	move.l	l0053+34+5444,(a2)+
	lea	-112(a2),a2
	addi.l	#$500,l010f
	movea.l	l00f8,a1
	lea	14400(a1),a1
	cmpa.l	l010f,a1
	bls	l0011

	bra	l0012

l0011	lea	-8(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	-112(a2),a2
	move.l	l00f8,l010f
	addi.l	#$c80,l010f
l0012	movea.l	l0110,a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	-112(a2),a2
	lea	632(a2),a2
	move.l	l0053+34+5440,(a2)+
	move.l	l0053+34+5444,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5440,(a2)+
	move.l	l0053+34+5444,(a2)+
	lea	-112(a2),a2
	addi.l	#$280,l0110
	movea.l	l00f8,a1
	lea	14400(a1),a1
	cmpa.l	l0110,a1
	bls	l0013

	bra	l0014

l0013	lea	-8(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	-112(a2),a2
	move.l	l00f8,l0110
	addi.l	#$c90,l0110
l0014	movea.l	l0111,a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	-112(a2),a2
	lea	312(a2),a2
	move.l	l0053+34+5440,(a2)+
	move.l	l0053+34+5444,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5440,(a2)+
	move.l	l0053+34+5444,(a2)+
	lea	-112(a2),a2
	addi.l	#$140,l0111
	movea.l	l00f8,a1
	lea	14400(a1),a1
	cmpa.l	l0111,a1
	bls	l0015

	bra	l0016

l0015	lea	-8(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	-112(a2),a2
	move.l	l00f8,l0111
	addi.l	#$ca0,l0111
l0016	movea.l	l0112,a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	-112(a2),a2
	lea	952(a2),a2
	move.l	l0053+34+5440,(a2)+
	move.l	l0053+34+5444,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5440,(a2)+
	move.l	l0053+34+5444,(a2)+
	lea	-112(a2),a2
	addi.l	#$3c0,l0112
	movea.l	l00f8,a1
	lea	14400(a1),a1
	cmpa.l	l0112,a1
	bls	l0017

	bra	l0018

l0017	lea	-8(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	-112(a2),a2
	move.l	l00f8,l0112
	addi.l	#$c98,l0112
l0018	movea.l	l0113,a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	-112(a2),a2
	lea	952(a2),a2
	move.l	l0053+34+5440,(a2)+
	move.l	l0053+34+5444,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5440,(a2)+
	move.l	l0053+34+5444,(a2)+
	lea	-112(a2),a2
	addi.l	#$3c0,l0113
	movea.l	l00f8,a1
	lea	14400(a1),a1
	cmpa.l	l0113,a1
	bls	l0019

	bra	l001a

l0019	lea	-8(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	-112(a2),a2
	move.l	l00f8,l0113
	addi.l	#$c88,l0113
l001a	cmpi.w	#$61a0,(a5)
	beq	l001b

	bra	l001c

l001b	lea	l00c0,a5

l001c	move.w	#$ff,-(sp)
	move.w	#6,-(sp)		;crawio
	trap	#1
	addq.l	#4,sp

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

	move.w	#$ff,-(sp)
	move.w	#6,-(sp)		;crawio
	trap	#1
	addq.l	#4,sp

	cmp.b	#$20,d0
	beq	l0023

	dbf	d6,l0020

	bra	l001f

l0023	bsr	l003b

	move.l	#0,$4d2.l

	bsr	l0047

	move.b	#3,$484.l

	move.w	#$2700,sr

	lea	8.w,a1
	lea	l0025(pc),a0
	moveq	#9,d7
l0024	move.l	(a0)+,(a1)+
	dbf	d7,l0024

	jmp	$12.w

l0025	ori.b	#$c,d0
	movea.l	4.w,a0
	jmp	(a0)
;========================================
l0026	move.l	#0,$4d2.l
	move.w	#1,d0
	jsr	l005e+44
	move.l	#l005e+44+8,$4d2.l

	bra	l001d

l0027	move.l	#0,$4d2.l
	move.w	#2,d0
	jsr	l005e+44
	move.l	#l005e+44+8,$4d2.l

	bra	l001d

l0028	move.l	#0,$4d2.l
	move.w	#3,d0
	jsr	l005e+44
	move.l	#l005e+44+8,$4d2.l

	bra	l001d

l0029	move.l	#0,$4d2.l
	move.w	#4,d0
	jsr	l005e+44
	move.l	#l005e+44+8,$4d2.l

	bra	l001d

l002a	move.l	#0,$4d2.l
	move.w	#5,d0
	jsr	l005e+44
	move.l	#l005e+44+8,$4d2.l

	bra	l001d

l002b	move.w	#2,-(sp)
	move.w	#2,-(sp)		;bconin
	trap	#13
	addq.l	#4,sp

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

l0034	move.w	#$25,-(sp)		;vsync
	trap	#14
	addq.w	#2,sp
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

	move.w	sr,d0
	move.w	#$2700,sr

	move.l	$70.l,l0109
	move.l	#l0038,$70.l
	move.l	#l0039,$120.l
	ori.b	#1,$fffffa13.l

	move.w	d0,sr
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
	move.l	l0109,-(sp)
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

l0048	dc.w	$a000
	move.w	#$40,l00e5
	move.w	#$1a,l00e6
	move.w	#4,l00e7
	move.w	#$f,l00e8
	move.w	#0,l00e9
	move.l	#$3030303,l00ea
	move.w	l00fa,l00eb
	move.w	#6,l00ec
	move.l	#l0053+34,l00ed
	move.w	#8,l00ee
	move.w	#$a0,l00ef
	move.w	#2,l00f0
	move.w	l00f9,l00f1
	move.w	#0,l00f2
	move.l	l00f8,l00f3
	move.w	#8,l00f4
	move.w	#$a0,l00f5
	move.w	#2,l00f6
	move.l	#0,l00f7

	lea	l00e5,a6
	dc.w	$a007
	rts

l0049	dc.w	$a000
	move.w	#$40,l00e5
	move.w	#$20,l00e6
	move.w	#4,l00e7
	move.w	#$f,l00e8
	move.w	#0,l00e9
	move.l	#$3030303,l00ea
	move.w	#$100,l00eb
	move.w	#$20,l00ec
	move.l	#l0053+34,l00ed
	move.w	#8,l00ee
	move.w	#$a0,l00ef
	move.w	#2,l00f0
	move.w	l00f9,l00f1
	move.w	#0,l00f2
	move.l	l00f8,l00f3
	move.w	#8,l00f4
	move.w	#$a0,l00f5
	move.w	#2,l00f6
	move.l	#0,l00f7

	lea	l00e5,A6
	dc.w	$a007
	rts

l004a	dc.w	$a000
	move.w	#$10,l00e5
	move.w	#$10,l00e6
	move.w	#4,l00e7
	move.w	#$f,l00e8
	move.w	#0,l00e9
	move.l	#$3030303,l00ea
	move.w	l00fb,l00eb
	move.w	#$20,l00ec
	move.l	#l0053+34,l00ed
	move.w	#8,l00ee
	move.w	#$a0,l00ef
	move.w	#2,l00f0
	move.w	#$98,l00f1
	move.w	#8,l00f2
	move.l	l00f8,l00f3
	move.w	#8,l00f4
	move.w	#$a0,l00f5
	move.w	#2,l00f6
	move.l	#0,l00f7

	lea	l00e5,A6
	dc.w	$a007
	rts

l004b	dc.w	$a000
	move.w	#$10,l00e5
	move.w	#$10,l00e6
	move.w	#4,l00e7
	move.w	#$f,l00e8
	move.w	#0,l00e9
	move.l	#$3030303,l00ea
	move.w	l00fc,l00eb
	move.w	#$30,l00ec
	move.l	#l0053+34,l00ed
	move.w	#8,l00ee
	move.w	#$a0,l00ef
	move.w	#2,l00f0
	move.w	#$98,l00f1
	move.w	#$16,l00f2
	move.l	l00f8,l00f3
	move.w	#8,l00f4
	move.w	#$a0,l00f5
	move.w	#2,l00f6
	move.l	#0,l00f7

	lea	l00e5,A6
	dc.w	$a007
	rts

l004c	dc.w	$a000
	move.w	#$8c,l00e5
	move.w	#$26,l00e6
	move.w	#4,l00e7
	move.w	#$f,l00e8
	move.w	#0,l00e9
	move.l	#$3030303,l00ea
	move.w	#$b4,l00eb
	move.w	#$84,l00ec
	move.l	#l0053+34,l00ed
	move.w	#8,l00ee
	move.w	#$a0,l00ef
	move.w	#2,l00f0
	move.w	#$5a,l00f1
	move.w	#$80,l00f2
	move.l	l00f8,l00f3
	move.w	#8,l00f4
	move.w	#$a0,l00f5
	move.w	#2,l00f6
	move.l	#0,l00f7

	lea	l00e5,A6
	dc.w	$a007
	rts

l004d	move.w	#9,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)
	trap	#14
	addq.w	#6,sp
	move.w	d0,l00fd

	dc.w	$a000
	move.w	#$20,l00e5
	move.w	#$30,l00e6
	move.w	#4,l00e7
	move.w	#$f,l00e8
	move.w	#0,l00e9
	move.l	#$3030303,l00ea
	move.w	#0,l00eb
	move.w	#$40,l00ec
	move.l	#l0053+34,l00ed
	move.w	#8,l00ee
	move.w	#$a0,l00ef
	move.w	#2,l00f0
	move.w	#$68,l00f1
	move.w	l00fd,l00f2
	move.l	l00f8,l00f3
	move.w	#8,l00f4
	move.w	#$a0,l00f5
	move.w	#2,l00f6
	move.l	#0,l00f7

	lea	l00e5,A6
	dc.w	$a007

	move.w	#$a,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)
	trap	#14
	addq.l	#6,sp
	move.w	d0,l00fd

	dc.w	$a000
	move.w	#$20,l00e5
	move.w	#$30,l00e6
	move.w	#4,l00e7
	move.w	#$f,l00e8
	move.w	#0,l00e9
	move.l	#$3030303,l00ea
	move.w	#$20,l00eb
	move.w	#$40,l00ec
	move.l	#l0053+34,l00ed
	move.w	#8,l00ee
	move.w	#$a0,l00ef
	move.w	#2,l00f0
	move.w	#$b8,l00f1
	move.w	l00fd,l00f2
	move.l	l00f8,l00f3
	move.w	#8,l00f4
	move.w	#$a0,l00f5
	move.w	#2,l00f6
	move.l	#0,l00f7

	lea	l00e5,A6
	dc.w	$a007

	move.w	#8,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.l	#6,sp
	move.w	d0,l00fd

	cmpi.w	#$d,l00fd
	bls	l004e

	move.w	#$c0,l00fa
	bsr	l0048
	rts

l004e	move.w	#$100,l00fa
	bsr	l0048
	rts

l004f	movea.l	l00f8,a1
	movea.l	l00f8,a2
	lea	$3de0(a1),a1
	lea	$3de0(a2),a2
	lea	8(a1),a1
	lea	(a2),a2
	move.w	#$1a,D5
x25546a	move.w	#$25,D1
x25546e	move.l	(a1)+,(a2)+
	dbf	d1,x25546e
	dbf	d5,x25546a

	dc.w	$a000
	move.w	#$10,l00e5
	move.w	#$19,l00e6
	move.w	#4,l00e7
	move.w	#$f,l00e8
	move.w	#0,l00e9
	move.l	#$3030303,l00ea
	move.w	(a5)+,l00eb
	move.w	#0,l00ec
	move.l	#l00c1,l00ed
	move.w	#8,l00ee
	move.w	#$a0,l00ef
	move.w	#2,l00f0
	move.w	#$130,l00f1
	move.w	#$63,l00f2
	move.l	l00f8,l00f3
	move.w	#8,l00f4
	move.w	#$a0,l00f5
	move.w	#2,l00f6
	move.l	#0,l00f7

	lea	l00e5,A6
	dc.w	$a007
	rts

l0050	dc.w	$a000
	move.w	#$80,l00e5
	move.w	#1,l00e6
	move.w	#4,l00e7
	move.w	#$f,l00e8
	move.w	#0,l00e9
	move.l	#$3030303,l00ea
	move.w	#0,l00eb
	move.w	#$23,l00ec
	move.l	#l0053+34,l00ed
	move.w	#8,l00ee
	move.w	#$a0,l00ef
	move.w	#2,l00f0
	move.w	(a3)+,l00f1
	move.w	#0,l00f2
	move.l	l00f8,l00f3
	move.w	#8,l00f4
	move.w	#$a0,l00f5
	move.w	#2,l00f6
	move.l	#0,l00f7

	lea	l00e5,A6
	dc.w	$a007
	dc.w	$a000
	move.w	#$80,l00e5
	move.w	#1,l00e6
	move.w	#4,l00e7
	move.w	#$f,l00e8
	move.w	#0,l00e9
	move.l	#$3030303,l00ea
	move.w	#0,l00eb
	move.w	#$23,l00ec
	move.l	#l0053+34,l00ed
	move.w	#8,l00ee
	move.w	#$a0,l00ef
	move.w	#2,l00f0
	move.w	(a4)+,l00f1
	move.w	#3,l00f2
	move.l	l00f8,l00f3
	move.w	#8,l00f4
	move.w	#$a0,l00f5
	move.w	#2,l00f6
	move.l	#0,l00f7

	lea	l00e5,a6
	dc.w	$a007
	movea.l	l00f8,a1
	movea.l	l00f8,a2
	lea	$3c0(a2),a2
	lea	$3840(a1),a1
	lea	$3840(a2),a2
	move.w	#$e0f,d1
x25568e	move.l	-(a1),-(a2)
	dbf	d1,x25568e
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

l0053	incbin	l0053.pi1
l005e	incbin	l005e.mus

l00c0	incbin	l00c0
l00c1	incbin	l00c1
l00c3	incbin	l00c3
l00c4	incbin	l00c4

l00c5	dc.b	$00,$00,$00,$01
l00c6	dc.b	$00,$12,$00,$23
l00c7	dc.b	$00,$24,$00,$35
l00c8	dc.b	$00,$46,$00,$57
l00c9	dc.b	$00,$00,$01,$00
l00ca	dc.b	$02,$00,$03,$00
l00cb	dc.b	$04,$00,$05,$00
l00cc	dc.b	$06,$00,$07,$00
l00cd	dc.b	$00,$00,$00,$10
l00ce	dc.b	$00,$20,$00,$30
l00cf	dc.b	$00,$40,$00,$50
l00d0	dc.b	$00,$60,$00,$70
l00d1	dc.b	$00,$00,$00,$01
l00d2	dc.b	$00,$02,$00,$03
l00d3	dc.b	$00,$04,$00,$05
l00d4	dc.b	$00,$06,$00,$07
l00d5	dc.b	$00,$00,$01,$01
l00d6	dc.b	$02,$02,$03,$03
l00d7	dc.b	$04,$04,$05,$05
l00d8	dc.b	$06,$06,$07,$07
l00d9	dc.b	$03,$60,$07,$77
l00da	dc.b	$06,$66,$05,$55
l00db	dc.b	$04,$44,$03,$33
l00dc	dc.b	$02,$22,$07,$77
l00dd	dc.b	$03,$60,$07,$70
l00de	dc.b	$07,$60,$06,$50
l00df	dc.b	$05,$40,$04,$30
l00e0	dc.b	$03,$20,$07,$77
l00e1	dc.b	$03,$60,$00,$77
l00e2	dc.b	$00,$66,$00,$55
l00e3	dc.b	$00,$44,$00,$33
l00e4	dc.b	$00,$22,$00,$77
;========================================
	bss
;========================================
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
;========================================
zuend	end
;========================================