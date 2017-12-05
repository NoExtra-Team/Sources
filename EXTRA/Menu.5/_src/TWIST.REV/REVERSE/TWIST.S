;	opt	x+
;========================================
	text
;========================================
begin	dc.w	$a00a

	clr.l	-(sp)
	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp
	move.l	d0,-(sp)

	move.b	#$e,$484.l

	lea	l0054,a0
	lea	$70a0a,a1
	move.l	#$bb7,d1
l0000	move.l	(a0)+,(a1)+
	dbf	d1,l0000

	bclr	#5,$fffa09.l

	move.l	d0,-(sp)

	move.w	#1,d0
	jsr	$70a0a
	move.l	#$70a12,$4d2.l

	pea	l0055+2
	move.w	#6,-(sp)		;setpallete
	trap	#14
	addq.l	#2,sp

	move.w	#2,-(sp)		;physbase
	trap	#14
	addq.l	#2,sp
	move.l	d0,l005d

	bsr	l003f

	lea	$fffffa01.w,a5
	move.l	a5,l005e
	andi.b	#$de,18(a5)
	andi.b	#$de,14(a5)
	andi.b	#$de,10(a5)
	andi.b	#$de,6(a5)
	clr.b	24(a5)
	clr.b	26(a5)

	lea	l0048(pc),a0
	move.l	a0,$134.w

	lea	l005a,a0
	move.l	$70.w,(a0)
	lea	l0045(pc),a0
	move.l	a0,$70.w

	move.l	#l005b,d0
	andi.l	#$ffffff00,d0
	addi.l	#$100,d0
	move.l	d0,l005c
	movea.l	d0,a2
	movea.l	a2,a0
	move.w	#$2acf,d1
l0001	clr.l	(a0)+
	dbf	d1,l0001

	movea.l	l005c,a1
	move.w	#$77f,d1
	lea	l0055,a2
	lea	34(a2),a2
	lea	5120(a2),a2
l0002	move.l	(a2)+,(a1)+
	dbf	d1,l0002

	movea.l	l005c,a1
	lea	32000(a1),a1
	lea	1280(a1),a1
	move.w	#$2a7,d1
	lea	l0055,a2
	lea	34(a2),a2
	lea	28960(a2),a2
l0003	move.l	(a2)+,(a1)+
	dbf	d1,l0003

	move.l	#$ffffffff,-(sp)
	move.l	l005c,-(sp)
	move.l	l005c,-(sp)
	move.w	#5,-(sp)		;setscreen
	trap	#14
	adda.l	#$e,sp

	lea	l0058,a5
	move.b	#0,l0077
	move.l	(a5),l0072
	move.b	#0,l0078
	move.b	#3,l0079
	move.b	#0,l007a
l0004	addi.b	#2,l0077
	cmpi.b	#$f,l0077
	bcc	l0005

	bra	l0006

l0005	move.b	#0,l0077
	move.l	(a5),l0072
	adda.l	#4,a5
l0006	cmpi.l	#$1f40,(a5)
	beq	l0007

	bra	l0008

l0007	lea	l0058,a5
	move.l	(a5),l0072
l0008	movea.l	l005c,a1
	lea	13920(a1),a1
	lea	l0055,a2
	lea	34(a2),a2
	adda.l	l0072,a2
	move.l	(a2)+,(a1)+
	move.l	(a2)+,(a1)+
	adda.l	#$98,a1
	adda.l	#$98,a2
	move.l	(a2)+,(a1)+
	move.l	(a2)+,(a1)+
	addi.l	#$140,l0072
	movea.l	l005c,a1
	movea.l	l005c,a2
	lea	320(a2),a2
	move.w	#$56,d1
l0009	move.l	(a2)+,(a1)+
	move.l	(a2)+,(a1)+
	adda.l	#$98,a2
	adda.l	#$98,a1
	dbf	d1,l0009

	movea.l	l005c,a2
	movea.l	l005c,a0
	lea	152(a0),a0
	move.w	#$58,d5
l000a	move.l	(a2)+,(a0)+
	move.l	(a2)+,(a0)+
	adda.l	#$98,a2
	adda.l	#$98,a0
	dbf	d5,l000a

	bsr	l0020
	bsr	l0013
	bsr	l0017
	bsr	l0034
	bsr	l001b
	bsr	l0010

	move.w	#$ff,-(sp)
	move.w	#6,-(sp)		;crawio
	trap	#1
	addq.l	#4,sp

	move.l	d0,d6
	swap	d6
	cmp.b	#$44,d6
	beq	l000f

l000b	cmp.b	#$20,d0
	bne	l0004

	clr.l	$4d2.l

	pea	l0053
	move.w	#$20,-(sp)		;dosound
	trap	#14
	addq.l	#6,sp

	bset	#5,$fffa09.l

	bsr	l000e

	move.w	sr,-(sp)

	ori.w	#$700,sr

	move.l	l005a,$70.w

	movea.l	l005e,a5
	andi.b	#$de,18(a5)
	andi.b	#$de,14(a5)
	andi.b	#$de,10(a5)
	andi.b	#$de,6(a5)
	clr.b	24(a5)
	clr.b	26(a5)

	bsr	l0040

	move.w	(sp)+,sr

	pea	l0052
	move.w	#0,-(sp)
	move.w	#$19,-(sp)		;ikbdws
	trap	#14
	addq.l	#8,sp

	move.l	#$ffffffff,-(sp)
	move.l	l005d,-(sp)
	move.l	l005d,-(sp)
	move.w	#5,-(sp)		;setscreen
	trap	#14
	adda.l	#$e,sp

	move.w	#$2700,sr

	lea	8.w,a1
	lea	l000d(pc),a0
	moveq	#9,d7
l000c	move.l	(a0)+,(a1)+
	dbf	d7,l000c

	jmp	$12.w

l000d	ori.b	#$c,d0
	movea.l	4.w,a0
	jmp	(a0)

	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp

	clr.l	-(sp)
	trap	#1
;========================================
	move.l	a5,l005c
	addi.l	#$a0,(a5)
	rts

l000e	move.l	#$8080000,$ffff8800.l
	move.l	#$9090000,$ffff8800.l
	move.l	#$a0a0000,$ffff8800.l
	rts

l000f	move.w	#7,-(sp)		;crawcin
	trap	#1
	addq.w	#2,sp

	bra	l000b

l0010	move.w	#$25,-(sp)		;vsync
	trap	#14
	addq.w	#2,sp
	rts

x25453e	dc.w	$a000
	move.w	#4,l005f
	move.w	#8,l0060
	move.w	#4,l0061
	move.w	#$f,l0062
	move.w	#0,l0063
	move.l	#$3030303,l0064
	move.w	(a5)+,l0065
	move.w	#0,l0066
	move.w	#8,l0068
	move.w	#$a0,l0069
	move.w	#2,l006a
	move.w	#$13c,l006b
	move.w	#$be,l006c
	move.l	l005c,l006d
	move.w	#8,l006e
	move.w	#$a0,l006f
	move.w	#2,l0070
	move.l	#0,l0071

	lea	l005f,a6
	dc.w	$a007
	bsr	x25453e
	cmpi.w	#$13c,(a5)
	beq	l0011

	bra	l0012

l0011	lea	l0058,a5
l0012	rts

l0013	move.w	#8,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d5
	movea.l	l005c,a2
	lea	9600(a2),a2
	lea	120(a2),a2
	lea	l0059,a0
	adda.l	d2,a0
l0014	move.l	(a0)+,(a2)+
	move.l	(a0)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a0
	dbf	d5,l0014

	move.w	#9,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d5
	movea.l	l005c,a2
	lea	9600(a2),a2
	lea	128(a2),a2
	lea	l0059,a0
	adda.l	d2,a0
l0015	move.l	(a0)+,(a2)+
	move.l	(a0)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a0
	dbf	d5,l0015

	move.w	#$a,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d5
	movea.l	l005c,a2
	lea	9600(a2),a2
	lea	136(a2),a2
	lea	l0059,a0
	adda.l	d2,a0
l0016	move.l	(a0)+,(a2)+
	move.l	(a0)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a0
	dbf	d5,l0016
	rts

l0017	move.w	#8,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d5
	movea.l	l005c,a2
	lea	31376(a2),a2
	lea	l0059,a0
	adda.l	d2,a0
l0018	move.l	(a0)+,(a2)+
	move.l	(a0)+,(a2)+
	adda.l	#$98,a0
	dbf	d5,l0018

	move.w	#9,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d5
	movea.l	l005c,a2
	lea	31376(a2),a2
	lea	320(a2),a2
	lea	l0059,a0
	adda.l	d2,a0
l0019	move.l	(a0)+,(a2)+
	move.l	(a0)+,(a2)+
	adda.l	#$98,a0
	dbf	d5,l0019

	move.w	#$a,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d5
	movea.l	l005c,a2
	lea	31376(a2),a2
	lea	640(a2),a2
	lea	l0059,a0
	adda.l	d2,a0
l001a	move.l	(a0)+,(a2)+
	move.l	(a0)+,(a2)+
	adda.l	#$98,a0
	dbf	d5,l001a
	rts

l001b	movea.l	l005c,a2
	movea.l	l005c,a0
	lea	14080(a2),a2
	lea	7040(a2),a2
	move.w	#$2c,d6
l001c	move.w	#$27,d5
l001d	move.l	(a0)+,(a2)+
	dbf	d5,l001d
	adda.l	#$a0,a0
	suba.l	#$140,a2
	dbf	d6,l001c

	movea.l	l005c,a2
	movea.l	l005c,a0
	lea	22400(a0),a0
	lea	28160(a2),a2
	move.w	#$c,d6
l001e	move.w	#$27,d5
l001f	move.l	(a0)+,(a2)+
	dbf	d5,l001f

	adda.l	#$a0,a0
	suba.l	#$140,a2
	dbf	d6,l001e
	rts

l0020	addi.b	#1,l0078
	cmpi.b	#0,l0078
	beq	l0021

	cmpi.b	#1,l0078
	beq	l0022

	cmpi.b	#2,l0078
	beq	l0023

	cmpi.b	#3,l0078
	beq	l0024

	cmpi.b	#4,l0078
	beq	l0025

	cmpi.b	#5,l0078
	beq	l0026

	cmpi.b	#6,l0078
	beq	l0027

	cmpi.b	#7,l0078
	beq	l0028

l0021	move.w	#0,l0073
	move.w	#$50,l0074
	bra	l0029

l0022	move.w	#$a0,l0073
	move.w	#$50,l0074
	bra	l0029

l0023	move.w	#0,l0073
	move.w	#$69,l0074
	bra	l0029

l0024	move.w	#$a0,l0073
	move.w	#$69,l0074
	bra	l0029

l0025	move.w	#0,l0073
	move.w	#$82,l0074
	bra	l0029

l0026	move.w	#$a0,l0073
	move.w	#$82,l0074
	bra	l0029

l0027	move.w	#0,l0073
	move.w	#$9b,l0074
	bra	l0029

l0028	move.w	#$a0,l0073
	move.w	#$9b,l0074
	move.b	#0,l0078

l0029	dc.w	$a000
	move.w	#$a0,l005f
	move.w	#$18,l0060
	move.w	#4,l0061
	move.w	#$f,l0062
	move.w	#0,l0063
	move.l	#$3030303,l0064
	move.w	l0073,l0065
	move.w	l0074,l0066

	move.l	#l0055+34,l0067
	move.w	#8,l0068
	move.w	#$a0,l0069
	move.w	#2,l006a
	move.w	#$50,l006b
	move.w	#$3c,l006c
	move.l	l005c,l006d
	move.w	#8,l006e
	move.w	#$a0,l006f
	move.w	#2,l0070
	move.l	#0,l0071

	lea	l005f,a6
	dc.w	$a007
	addi.b	#1,l007a
	cmpi.b	#2,l007a
	bne	l0033

	move.b	#0,l007a
	addi.b	#1,l0079
	cmpi.b	#0,l0079
	beq	l002a

	cmpi.b	#1,l0079
	beq	l002b

	cmpi.b	#2,l0079
	beq	l002c

	cmpi.b	#3,l0079
	beq	l002d

	cmpi.b	#4,l0079
	beq	l002e

	cmpi.b	#5,l0079
	beq	l002f

	cmpi.b	#6,l0079
	beq	l0030

	cmpi.b	#7,l0079
	beq	l0031

l002a	move.w	#0,l0075
	move.w	#$50,l0076
	bra	l0032

l002b	move.w	#$a0,l0075
	move.w	#$50,l0076
	bra	l0032

l002c	move.w	#0,l0075
	move.w	#$69,l0076
	bra	l0032

l002d	move.w	#$a0,l0075
	move.w	#$69,l0076
	bra	l0032

l002e	move.w	#0,l0075
	move.w	#$82,l0076
	bra	l0032

l002f	move.w	#$a0,l0075
	move.w	#$82,l0076
	bra	l0029

l0030	move.w	#0,l0075
	move.w	#$9b,l0076
	bra	l0032

l0031	move.w	#$a0,l0075
	move.w	#$9b,l0076
	move.b	#0,l0079

l0032	dc.w	$a000
	move.w	#$a0,l005f
	move.w	#$18,l0060
	move.w	#4,l0061
	move.w	#$f,l0062
	move.w	#0,l0063
	move.l	#$3030303,l0064
	move.w	l0075,l0065
	move.w	l0076,l0066
	move.l	#l0055+34,l0067
	move.w	#8,l0068
	move.w	#$a0,l0069
	move.w	#2,l006a
	move.w	#$50,l006b
	move.w	#$8c,l006c
	move.l	l005c,l006d
	move.w	#8,l006e
	move.w	#$a0,l006f
	move.w	#2,l0070
	move.l	#0,l0071

	lea	l005f,a6
	dc.w	$a007
l0033	rts

l0034	move.w	#8,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l005c,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	40(a2),a2
	lea	l0059,a3
	adda.l	d2,a3
l0035	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l0035

	move.w	#1,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l005c,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	48(a2),a2
	lea	l0059,a3
	adda.l	d2,a3
l0036	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l0036

	move.w	#9,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l005c,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	56(a2),a2
	lea	l0059,a3
	adda.l	d2,a3
l0037	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l0037

	move.w	#3,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l005c,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	64(a2),a2
	lea	l0059,a3
	adda.l	d2,a3
l0038	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l0038

	move.w	#$a,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l005c,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	72(a2),a2
	lea	l0059,a3
	adda.l	d2,a3
l0039	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l0039

	move.w	#5,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l005c,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	80(a2),a2
	lea	l0059,a3
	adda.l	d2,a3
l003a	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l003a

	move.w	#6,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l005c,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	88(a2),a2
	lea	l0059,a3
	adda.l	d2,a3
l003b	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l003b

	move.w	#0,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	divu	#$10,d0
	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l005c,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	96(a2),a2
	lea	l0059,a3
	adda.l	d2,a3
l003c	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l003c

	move.w	#2,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	divu	#$10,d0
	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l005c,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	104(a2),a2
	lea	l0059,a3
	adda.l	d2,a3
l003d	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l003d

	move.w	#4,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	divu	#$10,d0
	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l005c,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	112(a2),a2
	lea	l0059,a3
	adda.l	d2,a3
l003e	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l003e
	rts

l003f	lea	l0042(pc),a0
	move.l	$114.l,2(a0)
	lea	l0041(pc),a0
	move.l	a0,$114.l

	lea	l0044(pc),a0
	move.l	$118.l,2(a0)
	lea	l0043(pc),a0
	move.l	a0,$118.l
	rts

l0040	lea	l0042(pc),a0
	move.l	2(a0),$114.l

	lea	l0044(pc),a0
	move.l	2(a0),$118.l
	rts

l0041	ori.w	#$500,sr
	andi.w	#$fdff,sr

l0042	jmp	$10000

l0043	ori.w	#$500,sr
	andi.w	#$fdff,sr

l0044	jmp	$10000

l0045	move.l	l005a,-(sp)
	movem.l	a0/d0-d1,-(sp)
	lea	$ffff8201.w,a0
	movep.w	0(a0),d0
	movep.w	4(a0),d1
	cmp.w	d0,d1
	bne.s	l0047

	tst.b	8(a0)
	bne.s	l0047

	lea	l0051,a0
	tst.w	(a0)
	beq.s	l0046

	clr.w	(a0)
	movem.l	(sp)+,a0/d0-d1
	rts

l0046	lea	l004b(pc),a0
	move.l	a0,$120.w
	lea	$fffffa01.w,a0
	clr.b	26(a0)
	move.b	#$c7,32(a0)
	move.b	#8,26(a0)
	ori.b	#1,6(a0)
	ori.b	#1,18(a0)
	movem.l	(sp)+,a0/d0-d1
	rts

l0047	lea	$fffffa01.w,a0
	andi.b	#$de,18(a0)
	andi.b	#$de,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
	lea	l0051,a0
	clr.w	(a0)
	movem.l	(sp)+,a0/d0-d1
	rts

l0048	cmpi.b	#1,$fffffa21.w
	bgt.s	l0048

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
	bne	l0049

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

l0049	move.b	#$fc,$ffff820a.w

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
	lea	l004d(pc),a0
	move.w	#$e4,d0
	tst.b	$ffff8209.w
	bne.s	l004a

	cmp.w	d1,d2
	bne.s	l004a

	lea	l004b(pc),a0
	move.w	#$c7,d0
l004a	move.l	a0,$120.w
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

l004b	movem.l	a0-a2/d0,-(sp)
	lea	$fffffa01.w,a0
	lea	$ffff8209.w,a1
	lea	l004f(pc),a2
	lea	-222(a2),a2
	moveq	#0,d0
	andi.b	#$fe,18(a0)
	andi.b	#$fe,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
l004c	move.b	(a1),d0
	cmp.w	#$de,d0
	blt.s	l004c

	cmp.b	#0,d0
	bgt	l0050

	jmp	0(a2,d0.w)

l004d	movem.l	a0-a2/d0,-(sp)
	lea	$fffffa01.w,a0
	lea	$ffff8209.w,a1
	lea	l004f(pc),a2
	moveq	#0,d0
	andi.b	#$fe,18(a0)
	andi.b	#$fe,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
l004e	move.b	(a1),d0
	cmp.b	#8,d0
	blt.s	l004e

	cmp.w	#$20,d0
	bgt	l0050

	jmp	-8(a2,d0.w)

l004f	nop
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
	lea	l0051,a0
	move.w	#$ffff,(a0)
	movem.l	(sp)+,a0-a2/d0
	rte

l0050	bclr	#0,14(a0)
	lea	l0051,a0
	clr.w	(a0)
	movem.l	(sp)+,a0-a2/d0
	rte
;========================================
	data
;========================================
l0051	dc.b	$00,$00,$12
l0052	dc.b	$08
l0053	dc.b	$07,$ff,$06,$00,$08,$00,$09,$00
	dc.b	$0a,$00

l0054	incbin	l0054.mus
l0055	incbin	l0055.pi1
l0058	incbin	l0058
l0059	incbin	l0059
;========================================
	bss
;========================================
l005a	ds.l	1
l005b	ds.b	44096
l005c	ds.l	1
l005d	ds.l	1
l005e	ds.l	1
l005f	ds.w	1
l0060	ds.w	1
l0061	ds.w	1
l0062	ds.w	1
l0063	ds.w	1
l0064	ds.l	1
l0065	ds.w	1
l0066	ds.w	1
l0067	ds.l	1
l0068	ds.w	1
l0069	ds.w	1
l006a	ds.w	1
l006b	ds.w	1
l006c	ds.w	1
l006d	ds.l	1
l006e	ds.w	1
l006f	ds.w	1
l0070	ds.w	1
l0071	ds.b	138
l0072	ds.l	1
l0073	ds.w	1
l0074	ds.w	1
l0075	ds.w	1
l0076	ds.w	1
l0077	ds.b	1
l0078	ds.b	1
l0079	ds.b	1
l007a	ds.b	1
;========================================
zuend	end
;========================================