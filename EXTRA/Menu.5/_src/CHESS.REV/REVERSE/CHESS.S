;	opt	x+
;========================================
	text
;========================================
begin	dc.w	$a00a

	move.w	#2,-(sp)		;physbase
	trap	#14
	addq.l	#6,sp
	move.l	d0,l00e3

	move.l	#l00f2,d0
	andi.l	#$ffffff00,d0
	addi.l	#$100,d0
	move.l	d0,l00f1

	movea.l	l00f1,a0
	move.w	#$1f3f,d1
l0000	clr.l	(a0)+
	dbf	d1,l0000

	movea.l	l00f1,a0
	lea	l0074,a1
	lea	34(a1),a1
	move.w	#$1dff,d1
l0001	move.l	(a1)+,(a0)+
	dbf	d1,l0001

	movea.l	l00f1,a1
	movea.l	l00e3,a2
	move.w	#$1f3f,d1
l0002	move.l	(a1)+,(a2)+
	dbf	d1,l0002

	movea.l	#l0075,a0
	move.l	#$20,d0
	move.l	#0,d1
	move.l	#2,d2
	move.l	#$20,d3
	lea	l00f3,a2
	move.l	#$e,d4
	bsr	l0050

	movea.l	#l0075,a0
	move.l	#$40,d0
	move.l	#0,d1
	move.l	#2,d2
	move.l	#$20,d3
	lea	l00f4,a2
	move.l	#$e,d4
	bsr	l0050

	movea.l	#l0075,a0
	move.l	#$60,d0
	move.l	#0,d1
	move.l	#2,d2
	move.l	#$20,d3
	lea	l00f5,a2
	move.l	#$e,d4
	bsr	l0050

	movea.l	#l0075,a0
	move.l	#$80,d0
	move.l	#0,d1
	move.l	#2,d2
	move.l	#$20,d3
	lea	l00f6,a2
	move.l	#$e,d4
	bsr	l0050

	movea.l	#l0075,a0
	move.l	#$a0,d0
	move.l	#0,d1
	move.l	#2,d2
	move.l	#$20,d3
	lea	l00f7,a2
	move.l	#$e,d4
	bsr	l0050

	movea.l	#l0075,a0
	move.l	#$c0,d0
	move.l	#0,d1
	move.l	#2,d2
	move.l	#$20,d3
	lea	l00f8,a2
	move.l	#$e,d4
	bsr	l0050

	movea.l	#l0075,a0
	move.l	#$e0,d0
	move.l	#0,d1
	move.l	#2,d2
	move.l	#$20,d3
	lea	l00f9,a2
	move.l	#$e,d4
	bsr	l0050

	clr.l	-(sp)
	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp
	move.l	d0,-(sp)

	move.b	#$e,$484.l

	moveq	#1,d0
	jsr	l0077
	move.l	#l0077+6,$4d2.w

	move.w	#0,l010c
	lea	l0076,a5
	move.b	#0,l00f0
	move.b	#0,l010d
	move.w	#9,l00fc
	bsr	l0011

	jsr	l006b

l0003	addq.w	#1,l010c
	cmpi.w	#$167,l010c
	beq	l0004

	bra	l0005

l0004	move.w	#0,l010c
	lea	l0076,a5
l0005	move.l	(a5)+,l00fa
	move.l	(a5)+,l00fb
	subi.l	#$18,l00fb
	subi.l	#$20,l00fa
	bsr	l0042

	move.w	#8,l00fc
	bsr	l0044

	addi.l	#$20,l00fa
	move.w	#9,l00fc
	bsr	l0044

	addi.l	#$20,l00fa
	move.w	#$a,l00fc
	bsr	l0044
	bsr	l004d
	bsr	l0010

	move.w	#$ff,-(sp)
	move.w	#6,-(sp)		;crawio
	trap	#1
	addq.l	#4,sp

	move.l	d0,d6
	swap	d6
	cmp.b	#$3b,d6
	beq	l000a

	cmp.b	#$3c,d6
	beq	l000b

	cmp.b	#$3d,d6
	beq	l000c

	cmp.b	#$3e,d6
	beq	l000d

	cmp.b	#$3f,d6
	beq	l000e

	cmp.b	#$40,d6
	beq	l000f

	cmp.b	#$44,d6
	beq	l004f

l0006	cmp.b	#$20,d0
	bne	l0003

	bsr	l0040

	move.b	#3,$484.l

	bsr	l0041
	jsr	l006c

	movea.l	l00e3,a0
	move.w	#$1f3f,d1
l0007	clr.l	(a0)+
	dbf	d1,l0007

	move.w	#$2700,sr

	lea	8.w,a1
	lea	l0009(pc),a0
	moveq	#9,d7
l0008	move.l	(a0)+,(a1)+
	dbf	d7,l0008

	jmp	$12.w

l0009	ori.b	#$c,d0
	movea.l	4.w,a0
	jmp	(a0)

	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp

	clr.l	-(sp)
	trap	#1
	rts
;========================================
l000a	move.b	#1,l010d
	bra	l0006

l000b	move.b	#2,l010d
	bra	l0006

l000c	move.b	#3,l010d
	bra	l0006

l000d	move.b	#4,l010d
	bra	l0006

l000e	move.b	#$fe,$ff820a.l
	bra	l0006

l000f	move.b	#$fc,$ff820a.l
	bra	l0006

l0010	move.w	#$25,-(sp)		;vsync
	trap	#14
	addq.w	#2,sp
	rts

l0011	move.b	$fffffa07.l,l00e4
	move.b	$fffffa09.l,l00e5
	move.l	$70.l,l00e6
	move.l	$120.l,l00e7
	move.b	$fffffa0d.l,l00e8
	move.b	$fffffa0f.l,l00e9
	move.b	$fffffa11.l,l00ea
	move.b	$fffffa13.l,l00eb
	move.b	$fffffa15.l,l00ec
	move.b	$fffffa1b.l,l00ed
	move.b	$fffffa21.l,l00ee

	move.w	sr,d0

	move.w	#$2700,sr

	move.l	$70.l,l00ef
	move.l	#l0012,$70.l

	move.l	#l0022,$120.l
	ori.b	#1,$fffffa13.l

	move.w	d0,sr
	rts

l0012	cmpi.b	#1,l010d
	beq	l0013

	cmpi.b	#2,l010d
	beq	l0014

	cmpi.b	#3,l010d
	beq	l0015

	cmpi.b	#4,l010d
	beq	l0016

l0013	move.l	#$100,$ffff8240.w
	move.l	#$2000300,$ffff8244.w
	move.l	#$4000500,$ffff8248.w
	move.l	#$6000700,$ffff824c.w
	move.l	#$7300740,$ffff8250.w
	move.l	#$7500760,$ffff8254.w
	move.l	#$7700774,$ffff8258.w
	move.l	#$7750777,$ffff825c.w
	bra	l0017

l0014	move.l	#1,$ffff8240.w
	move.l	#$20003,$ffff8244.w
	move.l	#$40005,$ffff8248.w
	move.l	#$60007,$ffff824c.w
	move.l	#$170027,$ffff8250.w
	move.l	#$370047,$ffff8254.w
	move.l	#$570067,$ffff8258.w
	move.l	#$770777,$ffff825c.w
	bra	l0017

l0015	move.l	#$10,$ffff8240.w
	move.l	#$200030,$ffff8244.w
	move.l	#$400050,$ffff8248.w
	move.l	#$600070,$ffff824c.w
	move.l	#$3730474,$ffff8250.w
	move.l	#$5750576,$ffff8254.w
	move.l	#$6760776,$ffff8258.w
	move.l	#$7770777,$ffff825c.w
	bra	l0017

l0016	move.l	#$10,$ffff8240.w
	move.l	#$200030,$ffff8244.w
	move.l	#$400050,$ffff8248.w
	move.l	#$600070,$ffff824c.w
	move.l	#$710072,$ffff8250.w
	move.l	#$730074,$ffff8254.w
	move.l	#$750076,$ffff8258.w
	move.l	#$770777,$ffff825c.w
	bra	l0017

l0017	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#$4b,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l0018,$120.l
	move.l	l00ef,-(sp)
	rts

l0018	ori.w	#$700,sr

	move.l	#$777,$ffff8240.w
	move.l	#$6660015,$ffff8244.w
	move.l	#$170016,$ffff8248.w
	move.l	#$140013,$ffff824c.w

	addq.b	#1,l00f0
	cmpi.b	#0,l00f0
	beq	l0020

	cmpi.b	#1,l00f0
	beq	l001f

	cmpi.b	#2,l00f0
	beq	l001e

	cmpi.b	#3,l00f0
	beq	l001d

	cmpi.b	#4,l00f0
	beq	l001c

	cmpi.b	#5,l00f0
	beq	l001b

	cmpi.b	#6,l00f0
	beq	l001a

	cmpi.b	#7,l00f0
	beq	l0019

l0019	move.l	#$1110111,$ffff8250.w
	move.l	#$1110111,$ffff8254.w
	move.l	#$2220222,$ffff8258.w
	move.l	#$2220222,$ffff825c.w
	bra	l0021

l001a	move.l	#$1110111,$ffff8250.w
	move.l	#$1110222,$ffff8254.w
	move.l	#$2220222,$ffff8258.w
	move.l	#$2220111,$ffff825c.w
	bra	l0021

l001b	move.l	#$1110111,$ffff8250.w
	move.l	#$2220222,$ffff8254.w
	move.l	#$2220222,$ffff8258.w
	move.l	#$1110111,$ffff825c.w
	bra	l0021

l001c	move.l	#$1110222,$ffff8250.w
	move.l	#$2220222,$ffff8254.w
	move.l	#$2220111,$ffff8258.w
	move.l	#$1110111,$ffff825c.w
	bra	l0021

l001d	move.l	#$2220222,$ffff8250.w
	move.l	#$2220222,$ffff8254.w
	move.l	#$1110111,$ffff8258.w
	move.l	#$1110111,$ffff825c.w
	bra	l0021

l001e	move.l	#$2220222,$ffff8250.w
	move.l	#$2220111,$ffff8254.w
	move.l	#$1110111,$ffff8258.w
	move.l	#$1110222,$ffff825c.w
	bra	l0021

l001f	move.l	#$2220222,$ffff8250.w
	move.l	#$1110111,$ffff8254.w
	move.l	#$1110111,$ffff8258.w
	move.l	#$2220222,$ffff825c.w
	bra	l0021

l0020	move.l	#$2220111,$ffff8250.w
	move.l	#$1110111,$ffff8254.w
	move.l	#$1110222,$ffff8258.w
	move.l	#$2220222,$ffff825c.w

l0021	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#4,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l0022,$120.l
	rte

l0022	ori.w	#$700,sr

	move.l	#$777,$ffff8240.w
	move.l	#$6660015,$ffff8244.w
	move.l	#$170016,$ffff8248.w
	move.l	#$140013,$ffff824c.w

	cmpi.b	#0,l00f0
	beq	l002a

	cmpi.b	#1,l00f0
	beq	l0029

	cmpi.b	#2,l00f0
	beq	l0028

	cmpi.b	#3,l00f0
	beq	l0027

	cmpi.b	#4,l00f0
	beq	l0026

	cmpi.b	#5,l00f0
	beq	l0025

	cmpi.b	#6,l00f0
	beq	l0024

	cmpi.b	#7,l00f0
	beq	l0023

l0023	move.l	#$2220222,$ffff8250.w
	move.l	#$2220222,$ffff8254.w
	move.l	#$3330333,$ffff8258.w
	move.l	#$3330333,$ffff825c.w
	bra	l002b

l0024	move.l	#$2220222,$ffff8250.w
	move.l	#$2220333,$ffff8254.w
	move.l	#$3330333,$ffff8258.w
	move.l	#$3330222,$ffff825c.w
	bra	l002b

l0025	move.l	#$2220222,$ffff8250.w
	move.l	#$3330333,$ffff8254.w
	move.l	#$3330333,$ffff8258.w
	move.l	#$2220222,$ffff825c.w
	bra	l002b

l0026	move.l	#$2220333,$ffff8250.w
	move.l	#$3330333,$ffff8254.w
	move.l	#$3330222,$ffff8258.w
	move.l	#$2220222,$ffff825c.w
	bra	l002b

l0027	move.l	#$3330333,$ffff8250.w
	move.l	#$3330333,$ffff8254.w
	move.l	#$2220222,$ffff8258.w
	move.l	#$2220222,$ffff825c.w
	bra	l002b

l0028	move.l	#$3330333,$ffff8250.w
	move.l	#$3330222,$ffff8254.w
	move.l	#$2220222,$ffff8258.w
	move.l	#$2220333,$ffff825c.w
	bra	l002b

l0029	move.l	#$3330333,$ffff8250.w
	move.l	#$2220222,$ffff8254.w
	move.l	#$2220222,$ffff8258.w
	move.l	#$3330333,$ffff825c.w
	bra	l002b

l002a	move.l	#$3330222,$ffff8250.w
	move.l	#$2220222,$ffff8254.w
	move.l	#$2220333,$ffff8258.w
	move.l	#$3330333,$ffff825c.w

l002b	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#4,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l002c,$120.l
	rte

l002c	ori.w	#$700,sr

	move.l	#$777,$ffff8240.w
	move.l	#$6660015,$ffff8244.w
	move.l	#$170016,$ffff8248.w
	move.l	#$140013,$ffff824c.w

	cmpi.b	#0,l00f0
	beq	l0034

	cmpi.b	#1,l00f0
	beq	l0033

	cmpi.b	#2,l00f0
	beq	l0032

	cmpi.b	#3,l00f0
	beq	l0031

	cmpi.b	#4,l00f0
	beq	l0030

	cmpi.b	#5,l00f0
	beq	l002f

	cmpi.b	#6,l00f0
	beq	l002e

	cmpi.b	#7,l00f0
	beq	l002d

l002d	move.l	#$3330333,$ffff8250.w
	move.l	#$3330333,$ffff8254.w
	move.l	#$4440444,$ffff8258.w
	move.l	#$4440444,$ffff825c.w
	bra	l0035

l002e	move.l	#$3330333,$ffff8250.w
	move.l	#$3330444,$ffff8254.w
	move.l	#$4440444,$ffff8258.w
	move.l	#$4440333,$ffff825c.w
	bra	l0035

l002f	move.l	#$3330333,$ffff8250.w
	move.l	#$4440444,$ffff8254.w
	move.l	#$4440444,$ffff8258.w
	move.l	#$3330333,$ffff825c.w
	bra	l0035

l0030	move.l	#$3330444,$ffff8250.w
	move.l	#$4440444,$ffff8254.w
	move.l	#$4440333,$ffff8258.w
	move.l	#$3330333,$ffff825c.w
	bra	l0035

l0031	move.l	#$4440444,$ffff8250.w
	move.l	#$4440444,$ffff8254.w
	move.l	#$3330333,$ffff8258.w
	move.l	#$3330333,$ffff825c.w
	bra	l0035

l0032	move.l	#$4440444,$ffff8250.w
	move.l	#$4440333,$ffff8254.w
	move.l	#$3330333,$ffff8258.w
	move.l	#$3330444,$ffff825c.w
	bra	l0035

l0033	move.l	#$4440444,$ffff8250.w
	move.l	#$3330333,$ffff8254.w
	move.l	#$3330333,$ffff8258.w
	move.l	#$4440444,$ffff825c.w
	bra	l0035

l0034	move.l	#$4440333,$ffff8250.w
	move.l	#$3330333,$ffff8254.w
	move.l	#$3330444,$ffff8258.w
	move.l	#$4440444,$ffff825c.w

l0035	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#4,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l0036,$120.l
	rte

l0036	ori.w	#$700,sr

	move.l	#$777,$ffff8240.w
	move.l	#$6660015,$ffff8244.w
	move.l	#$170016,$ffff8248.w
	move.l	#$140013,$ffff824c.w

	cmpi.b	#0,l00f0
	beq	l003e

	cmpi.b	#1,l00f0
	beq	l003d

	cmpi.b	#2,l00f0
	beq	l003c

	cmpi.b	#3,l00f0
	beq	l003b

	cmpi.b	#4,l00f0
	beq	l003a

	cmpi.b	#5,l00f0
	beq	l0039

	cmpi.b	#6,l00f0
	beq	l0038

	cmpi.b	#7,l00f0
	beq	l0037

l0037	move.l	#$4440444,$ffff8250.w
	move.l	#$4440444,$ffff8254.w
	move.l	#$5550555,$ffff8258.w
	move.l	#$5550555,$ffff825c.w
	move.b	#$ff,l00f0
	bra	l003f

l0038	move.l	#$4440444,$ffff8250.w
	move.l	#$4440555,$ffff8254.w
	move.l	#$5550555,$ffff8258.w
	move.l	#$5550444,$ffff825c.w
	bra	l003f

l0039	move.l	#$4440444,$ffff8250.w
	move.l	#$5550555,$ffff8254.w
	move.l	#$5550555,$ffff8258.w
	move.l	#$4440444,$ffff825c.w
	bra	l003f

l003a	move.l	#$4440555,$ffff8250.w
	move.l	#$5550555,$ffff8254.w
	move.l	#$5550444,$ffff8258.w
	move.l	#$4440444,$ffff825c.w
	bra	l003f

l003b	move.l	#$5550555,$ffff8250.w
	move.l	#$5550555,$ffff8254.w
	move.l	#$4440444,$ffff8258.w
	move.l	#$4440444,$ffff825c.w
	bra	l003f

l003c	move.l	#$5550555,$ffff8250.w
	move.l	#$5550444,$ffff8254.w
	move.l	#$4440444,$ffff8258.w
	move.l	#$4440555,$ffff825c.w
	bra	l003f

l003d	move.l	#$5550555,$ffff8250.w
	move.l	#$4440444,$ffff8254.w
	move.l	#$4440444,$ffff8258.w
	move.l	#$5550555,$ffff825c.w
	bra	l003f

l003e	move.l	#$5550444,$ffff8250.w
	move.l	#$4440444,$ffff8254.w
	move.l	#$4440555,$ffff8258.w
	move.l	#$5550555,$ffff825c.w

l003f	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	rte

l0040	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	move.b	l00e4,$fffffa07.l
	move.b	l00e5,$fffffa09.l
	move.l	l00e6,$70.l
	move.l	l00e7,$120.l
	move.b	l00e8,$fffffa0d.l
	move.b	l00e9,$fffffa0f.l
	move.b	l00ea,$fffffa11.l
	move.b	l00eb,$fffffa13.l
	move.b	l00ec,$fffffa15.l
	move.b	l00ed,$fffffa1b.l
	move.b	l00ee,$fffffa21.l
	rts

l0041	move.l	#$8080000,$ffff8800.l
	move.l	#$9090000,$ffff8800.l
	move.l	#$a0a0000,$ffff8800.l
	rts

l0042	bsr	l0069

	movea.l	l00f1,a2
	lea	l0074,a1
	lea	34(a1),a1
	move.l	l00fb,d0
	subi.w	#4,d0
	mulu	#$a0,d0
	adda.l	d0,a1
	adda.l	d0,a2
	move.w	#$63f,d1
l0043	move.l	(a1)+,(a2)+
	dbf	d1,l0043
	rts

l0044	move.w	l00fc,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	cmp.w	#9,d0
	bcs	l0045

	cmp.w	#9,d0
	beq	l0046

	cmp.w	#$a,d0
	beq	l0047

	cmp.w	#$b,d0
	beq	l0048

	cmp.w	#$c,d0
	beq	l0049

	cmp.w	#$d,d0
	beq	l0049

	cmp.w	#$e,d0
	beq	l004a

	cmp.w	#$f,d0
	beq	l004b

l0045	lea	l00f9,a0
	bra	l004c

l0046	lea	l00f8,a0
	bra	l004c

l0047	lea	l00f7,a0
	bra	l004c

l0048	lea	l00f6,a0
	bra	l004c

l0049	lea	l00f5,a0
	bra	l004c

l004a	lea	l00f4,a0
	bra	l004c

l004b	lea	l00f3,a0
	bra	l004c

l004c	move.l	l00fa,d0
	move.l	l00fb,d1
	movea.l	l00f1,a4
	bsr	l0057
	rts

l004d	movea.l	l00f1,a1
	movea.l	l00e3,a2
	move.l	l00fb,d0
	subi.w	#4,d0
	mulu	#$a0,d0
	adda.l	d0,a1
	adda.l	d0,a2
	move.w	#$63f,d1
l004e	move.l	(a1)+,(a2)+
	dbf	d1,l004e

	bsr	l006a
	rts

l004f	move.w	#1,-(sp)		;cconin
	trap	#1
	addq.l	#2,sp

	bra	l0006

l0050	lea	(a2),a4
	lea	30(a2),a2
	move.l	d4,(a4)+
	lsr.l	#4,d0
	lsl.l	#3,d0
	mulu	#$a0,d1
	add.l	d0,d1
	adda.l	d1,a0
	move.w	d2,d7
	lsl.l	#3,d7
	move.l	d7,d6
	neg.l	d7
	addi.l	#$a0,d7
	subq.l	#8,d7
	move.l	d7,(a4)+
	addq.l	#8,d7
	subq.l	#1,d2
	subq.l	#1,d3
	move.l	d2,(a4)+
	move.l	d3,(a4)+
	moveq	#$ff,d0
	moveq	#3,d6
l0051	btst	d6,d4
	beq	l0052

	addq.l	#1,d0
	move.l	d6,d1
	lsl.l	#1,d1
	neg.l	d1
	addq.l	#6,d1
	move.w	d1,(a4)+
l0052	dbf	d6,l0051

	move.l	d0,d6
	addq.l	#1,d6
	lsl.l	#1,d6
	suba.l	d6,a4
	adda.l	#8,a4
	move.l	d0,(a4)
	move.w	d3,d1
l0053	move.l	d2,d0
l0054	moveq	#3,d6
l0055	btst	d6,d4
	beq	l0056

	move.w	(a0),(a2)+
l0056	lea	2(a0),a0
	dbf	d6,l0055
	dbf	d0,l0054

	adda.l	d7,a0
	dbf	d1,l0053
	rts

l0057	lea	30(a0),a2
	move.l	4(a0),l0070
	move.l	8(a0),l0072
	move.l	#0,l0071
	move.l	d0,d6
	andi.l	#$f,d6
	neg.l	d6
	addi.l	#$10,d6
	move.b	#0,l0073
	lsr.l	#4,d0
	move.l	d0,d4
	move.l	d0,d5
	add.l	8(a0),d5
	cmpi.b	#$13,d5
	bcs	l0058

	neg.l	d4
	addi.l	#$13,d4
	move.l	d4,l0072
	neg.l	d4
	add.l	8(a0),d4
	move.l	24(a0),d5
	addq.l	#1,d5
	lsl.l	#1,d5
	mulu	d4,d5
	move.l	d5,l0071
	lsl.l	#3,d4
	add.l	d4,l0070
	move.b	#1,l0073
l0058	lsl.l	#3,d0
	move.l	12(a0),d7
	move.l	d1,d4
	move.l	d1,d5
	add.l	12(a0),d5
	cmpi.w	#$c8,d5
	bcs	l0059

	neg.l	d4
	addi.l	#$c8,d4
	move.l	d4,d7
l0059	mulu	#$a0,d1
	add.l	d0,d1
	adda.l	d1,a4
	move.l	24(a0),d4
	cmpi.b	#2,d4
	beq	l005d

	cmpi.b	#1,d4
	beq	l0061

	tst.b	d4
	beq	l0065

l005a	move.l	d7,l006f
	move.l	l0072,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
l005b	clr.w	d1
	clr.w	d2
	clr.w	d3
	clr.w	d4
	moveq	#0,d5
	clr.w	d7
	move.w	(a2)+,d5
	lsl.l	d6,d5
	or.l	d5,d7
	or.l	d5,d1
	swap	d1
	moveq	#0,d5
	move.w	(a2)+,d5
	lsl.l	d6,d5
	or.l	d5,d7
	or.l	d5,d2
	swap	d2
	moveq	#0,d5
	move.w	(a2)+,d5
	lsl.l	d6,d5
	or.l	d5,d7
	or.l	d5,d3
	swap	d3
	moveq	#0,d5
	move.w	(a2)+,d5
	lsl.l	d6,d5
	or.l	d5,d7
	or.l	d5,d4
	swap	d4
	moveq	#0,d5
	swap	d7
	not.w	d7
	and.w	d7,(a4)
	or.w	d1,(a4)+
	and.w	d7,(a4)
	or.w	d2,(a4)+
	and.w	d7,(a4)
	or.w	d3,(a4)+
	and.w	d7,(a4)
	or.w	d4,(a4)+
	dbf	d0,l005b

	adda.l	l0071,a2
	tst.b	l0073
	bne	l005c

	swap	d7
	swap	d1
	swap	d2
	swap	d3
	swap	d4
	not.w	d7
	and.w	d7,(a4)
	or.w	d1,(a4)+
	and.w	d7,(a4)
	or.w	d2,(a4)+
	and.w	d7,(a4)
	or.w	d3,(a4)+
	and.w	d7,(a4)
	or.w	d4,(a4)+
	lea	-8(a4),a4
l005c	addq.l	#8,a4
	adda.l	l0070,a4
	move.l	l006f,d7
	dbf	d7,l005a
	rts

l005d	lea	(a4),a1
	lea	(a4),a5
	lea	(a4),a6
	moveq	#0,d4
	move.w	16(a0),d4
	adda.l	d4,a4
	move.w	18(a0),d4
	adda.l	d4,a5
	move.w	20(a0),d4
	adda.l	d4,a6
l005e	move.l	d7,l006f
	move.l	l0072,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
l005f	clr.w	d1
	clr.w	d2
	clr.w	d3
	moveq	#0,d5
	clr.w	d7
	move.w	(a2)+,d5
	lsl.l	d6,d5
	or.l	d5,d7
	or.l	d5,d1
	swap	d1
	moveq	#0,d5
	move.w	(a2)+,d5
	lsl.l	d6,d5
	or.l	d5,d7
	or.l	d5,d2
	swap	d2
	moveq	#0,d5
	move.w	(a2)+,d5
	lsl.l	d6,d5
	or.l	d5,d7
	or.l	d5,d3
	swap	d3
	moveq	#0,d5
	swap	d7
	not.w	d7
	and.w	d7,(a1)+
	and.w	d7,(a1)+
	and.w	d7,(a1)+
	and.w	d7,(a1)+
	or.w	d1,(a4)
	or.w	d2,(a5)
	or.w	d3,(a6)
	addq.l	#8,a4
	addq.l	#8,a5
	addq.l	#8,a6
	dbf	d0,l005f

	adda.l	l0071,a2
	tst.b	l0073
	bne	l0060

	swap	d7
	swap	d1
	swap	d2
	swap	d3
	not.w	d7
	and.w	d7,(a1)
	and.w	d7,2(a1)
	and.w	d7,4(a1)
	and.w	d7,6(a1)
	or.w	d1,(a4)
	or.w	d2,(a5)
	or.w	d3,(a6)
l0060	addq.l	#8,a1
	addq.l	#8,a4
	addq.l	#8,a5
	addq.l	#8,a6
	adda.l	l0070,a1
	adda.l	l0070,a4
	adda.l	l0070,a5
	adda.l	l0070,a6
	move.l	l006f,d7
	dbf	d7,l005e
	rts

l0061	lea	(a4),a1
	lea	(a4),a5
	moveq	#0,d4
	move.w	16(a0),d4
	adda.l	d4,a4
	move.w	18(a0),d4
	adda.l	d4,a5
l0062	move.l	d7,l006f
	move.l	l0072,d0
	moveq	#0,d1
	moveq	#0,d2
l0063	clr.w	d1
	clr.w	d2
	moveq	#0,d5
	clr.w	d7
	move.w	(a2)+,d5
	lsl.l	d6,d5
	or.l	d5,d7
	or.l	d5,d1
	swap	d1
	moveq	#0,d5
	move.w	(a2)+,d5
	lsl.l	d6,d5
	or.l	d5,d7
	or.l	d5,d2
	swap	d2
	moveq	#0,d5
	swap	d7
	not.w	d7
	and.w	d7,(a1)+
	and.w	d7,(a1)+
	and.w	d7,(a1)+
	and.w	d7,(a1)+
	or.w	d1,(a4)
	or.w	d2,(a5)
	addq.l	#8,a4
	addq.l	#8,a5
	dbf	d0,l0063

	adda.l	l0071,a2
	tst.b	l0073
	bne	l0064

	swap	d7
	swap	d1
	swap	d2
	not.w	d7
	and.w	d7,(a1)
	and.w	d7,2(a1)
	and.w	d7,4(a1)
	and.w	d7,6(a1)
	or.w	d1,(a4)
	or.w	d2,(a5)
l0064	addq.l	#8,a4
	addq.l	#8,a5
	addq.l	#8,a1
	adda.l	l0070,a1
	adda.l	l0070,a4
	adda.l	l0070,a5
	move.l	l006f,d7
	dbf	d7,l0062
	rts

l0065	lea	(a4),a1
	moveq	#0,d4
	move.w	16(a0),d4
	adda.l	d4,a4
l0066	move.l	d7,l006f
	move.l	l0072,d0
	moveq	#0,d1
l0067	clr.w	d1
	moveq	#0,d5
	clr.w	d7
	move.w	(a2)+,d5
	lsl.l	d6,d5
	or.l	d5,d7
	or.l	d5,d1
	swap	d1
	moveq	#0,d5
	swap	d7
	not.w	d7
	and.w	d7,(a1)+
	and.w	d7,(a1)+
	and.w	d7,(a1)+
	and.w	d7,(a1)+
	or.w	d1,(a4)
	addq.l	#8,a4
	dbf	d0,l0067

	adda.l	l0071,a2
	tst.b	l0073
	bne	l0068

	swap	d7
	swap	d1
	not.w	d7
	and.w	d7,(a1)
	and.w	d7,2(a1)
	and.w	d7,4(a1)
	and.w	d7,6(a1)
	or.w	d1,(a4)
l0068	addq.l	#8,a4
	addq.l	#8,a1
	adda.l	l0070,a4
	adda.l	l0070,a1
	move.l	l006f,d7
	dbf	d7,l0066
	rts

l0069	move.l	d0,l00fd
	move.l	d1,l00fe
	move.l	d2,l00ff
	move.l	d3,l0100
	move.l	d4,l0101
	move.l	d5,l0102
	move.l	d6,l0103
	move.l	d7,l0104
	move.l	a0,l0105
	move.l	a1,l0106
	move.l	a2,l0107
	move.l	a3,l0108
	move.l	a4,l0109
	move.l	a5,l010a
	move.l	a6,l010b
	rts

l006a	move.l	l00fd,d0
	move.l	l00fe,d1
	move.l	l00ff,d2
	move.l	l0100,d3
	move.l	l0101,d4
	move.l	l0102,d5
	move.l	l0103,d6
	move.l	l0104,d7
	movea.l	l0105,a0
	movea.l	l0106,a1
	movea.l	l0107,a2
	movea.l	l0108,a3
	movea.l	l0109,a4
	movea.l	l010a,a5
	movea.l	l010b,a6
	rts

l006b	pea	l006d
	move.w	#1,-(sp)
	move.w	#$19,-(sp)		;ikbdws
	trap	#14
	addq.l	#8,sp
	rts

l006c	pea	l006e
	move.w	#1,-(sp)
	move.w	#$19,-(sp)		;ikbdws
	trap	#14
	addq.l	#8,sp
	rts

l006d	dc.b	$14
l006e	dc.b	$15,$08,$00

l006f	dcb.w	2
l0070	dcb.w	2
l0071	dcb.w	2
l0072	dcb.w	2
l0073	dc.b	$00,$00

l0074	incbin	l0074.pi1
l0075	incbin	l0075
l0076	incbin	l0076
l0077	incbin	l0077.mus

;========================================
	bss
;========================================
l00e3	ds.b	8
l00e4	ds.w	1
l00e5	ds.w	1
l00e6	ds.l	1
l00e7	ds.l	1
l00e8	ds.w	1
l00e9	ds.w	1
l00ea	ds.w	1
l00eb	ds.w	1
l00ec	ds.w	1
l00ed	ds.w	1
l00ee	ds.b	36
l00ef	ds.l	1
l00f0	ds.w	1
l00f1	ds.l	1
l00f2	ds.b	32256
l00f3	ds.b	8000
l00f4	ds.b	8000
l00f5	ds.b	8000
l00f6	ds.b	8000
l00f7	ds.b	8000
l00f8	ds.b	8000
l00f9	ds.b	8000
l00fa	ds.l	1
l00fb	ds.l	1
l00fc	ds.w	1
l00fd	ds.l	1
l00fe	ds.l	1
l00ff	ds.l	1
l0100	ds.l	1
l0101	ds.l	1
l0102	ds.l	1
l0103	ds.l	1
l0104	ds.l	1
l0105	ds.l	1
l0106	ds.l	1
l0107	ds.l	1
l0108	ds.l	1
l0109	ds.l	1
l010a	ds.l	1
l010b	ds.l	1
l010c	ds.w	1
l010d	ds.w	1
;========================================
zuend	end
;========================================