;		opt	x+
;========================================
		text
;========================================
begin		movea.l	4(sp),a0
		movea.l	12(a0),a1
		pea	256(a1)
		pea	(a0)
		pea	$4a0000
		trap	#1
		lea	12(sp),sp

		clr.l	-(sp)
		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp
		move.l	d0,-(sp)

		move.b	#$e,$484.l

		cmpi.l	#$22222222,$426.l
		bne	l0054

		dc.w	$a00a

		move.w	#$22,-(sp)		;kbdvbase
		trap	#14
		addq.l	#2,sp

		movea.l	d0,a5
		lea	24(a5),a5
		move.l	(a5),l0091
		move.l	#l0031,(a5)

		pea	l0088
		clr.w	-(sp)
		move.w	#$19,-(sp)		;ikbdws
		trap	#14
		addq.l	#8,sp

		moveq	#1,d0
		jsr	music
		move.l	#music+4,$4d6.l

		pea	maingfx+2
		move.w	#6,-(sp)		;setpallete
		trap	#14
		addq.l	#6,sp

		pea	l0074
		move.w	#9,-(sp)		;cconws
		trap	#1
		addq.l	#6,sp
;========================================
l0000		move.w	#7,-(sp)		;crawcin
		trap	#1
		addq.l	#2,sp

		swap	d0
		cmp.b	#$3b,d0
		beq	key_f1

		cmp.b	#$3c,d0
		beq	key_f2

		cmp.b	#$3d,d0
		beq	key_f3

		cmp.b	#$3e,d0
		beq	key_f4

l0001		cmp.b	#$39,d0		;#'9'
		bne	l0000
;========================================
		move.w	#2,-(sp)		;physbase
		trap	#14
		addq.l	#2,sp

		move.l	d0,l0090
		movea.l	l0090,a0
		move.w	#$1f3f,d1
l0002		clr.l	(a0)+
		dbf	d1,l0002

		movea.l	l0090,a0
		lea	maingfx,a1
		lea	34(a1),a1
		move.w	#$1b7f,d1
l0003		move.l	(a1)+,(a0)+
		dbf	d1,l0003

		move.w	#$a0,l00a6
		move.w	#$a0,l00a7
		move.w	#0,l00a8
		move.b	#1,l00ae
		lea	l008d,a4
		move.w	#$167,l00ab
		move.w	#$40,l00ac
		move.w	#0,l00ad
l0004		move.b	l0087,l00af
		move.b	l00af,d7
		cmp.w	#0,d7
		beq	l0005

		bsr	l0008
l0005		bsr	l001f
		bsr	l0033
		bsr	l0030

		move.w	#$ff,-(sp)
		move.w	#6,-(sp)		;crawio
		trap	#1
		addq.l	#4,sp

		swap	d0
		cmp.b	#$48,d0
		beq	l0017

		cmp.b	#$50,d0
		beq	l0019

		cmp.b	#$52,d0
		beq	l001b

		cmp.b	#$4b,d0
		beq	l001c

		cmp.b	#$4d,d0
		beq	l001d

l0006		swap	d0
		cmp.b	#$1b,d0
		beq	l0007

		bra	l0004
;========================================
l0007		bsr	l004f

		dc.w	$a009

		clr.l	-(sp)
		trap	#1
;========================================
l0008		btst	#2,l00af
		bne.s	l000e

l0009		btst	#3,l00af
		bne.s	l000f

l000a		btst	#7,l00af
		bne.s	l0010

l000b		btst	#0,l00af
		bne.s	l0011

l000c		btst	#1,l00af
		bne	l0012
l000d		rts

l000e		cmpi.w	#$60,l00a6
		bls	l0009

		subi.w	#4,l00a6
		bra	l0009

l000f		cmpi.w	#$c0,l00a6
		bcc	l000a

		addi.w	#4,l00a6
		bra	l000a

l0010		cmpi.b	#0,l00ae
		beq	l000b

		move.b	#0,l00ae
		move.w	l00a6,l00a7
		move.w	#$92,l00a8
		bra	l000b

l0011		cmpi.w	#0,l00ad
		beq	l000c

		bsr	l0013

		bra	l000c

l0012		cmpi.w	#$80,l00ad
		beq	l000d

		bsr	l0015

		bra	l000d

l0013		move.b	#0,l00b0
l0014		subi.w	#1,l00ad
		bsr	l0033
		bsr	l001f
		bsr	l0030

		addi.b	#1,l00b0
		cmpi.b	#8,l00b0
		bne.s	l0014
		rts

l0015		move.b	#0,l00b0
l0016		addi.w	#1,l00ad
		bsr	l0033
		bsr	l001f
		bsr	l0030

		addi.b	#1,l00b0
		cmpi.b	#8,l00b0
		bne.s	l0016
		rts

l0017		cmpi.w	#0,l00ad
		beq	l0006

		move.b	#0,l00b0
l0018		subi.w	#1,l00ad
		bsr	l0033
		bsr	l001f
		bsr	l0030

		addi.b	#1,l00b0
		cmpi.b	#8,l00b0
		bne.s	l0018

		bra	l0006

l0019		cmpi.w	#$80,l00ad
		beq	l0006

		move.b	#0,l00b0
l001a		addi.w	#1,l00ad
		bsr	l0033
		bsr	l001f
		bsr	l0030

		addi.b	#1,l00b0
		cmpi.b	#8,l00b0
		bne.s	l001a
		bra	l0006

l001b		cmpi.b	#0,l00ae
		beq	l0006

		move.b	#0,l00ae
		move.w	l00a6,l00a7
		move.w	#$92,l00a8
		bra	l0006

l001c		cmpi.w	#$60,l00a6
		bls	l0006

		subi.w	#4,l00a6
		bra	l0006

l001d		cmpi.w	#$c0,l00a6
		bcc	l0006

		addi.w	#4,l00a6
		bra	l0006

l001e		move.l	#$8080000,$ffff8800.l
		move.l	#$9090000,$ffff8800.l
		move.l	#$a0a0000,$ffff8800.l
		rts

l001f		move.w	#7,d1
		movea.l	l0090,a0
		lea	l00a5,a1
		lea	26880(a0),a0
l0020		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		adda.l	#$90,a0
		dbf	d1,l0020

		move.w	#$aa,d1
		movea.l	l0090,a0
		movea.l	l0090,a1
		lea	27200(a0),a0
		lea	28000(a1),a1
		lea	16(a0),a0
		lea	16(a1),a1
l0021		move.l	-(a0),-(a1)
		move.l	-(a0),-(a1)
		move.l	-(a0),-(a1)
		move.l	-(a0),-(a1)
		suba.l	#$90,a0
		suba.l	#$90,a1
		dbf	d1,l0021

		move.w	#7,d1
		movea.l	l0090,a0
		lea	l00a5,a1
l0022		move.l	(a1)+,(a0)+
		move.l	(a1)+,(a0)+
		move.l	(a1)+,(a0)+
		move.l	(a1)+,(a0)+
		adda.l	#$90,a0
		dbf	d1,l0022

		move.w	#3,d1
		movea.l	l0090,a0
		lea	l00a5,a1
		lea	27200(a0),a0
		lea	16(a0),a0
l0023		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		adda.l	#$90,a0
		dbf	d1,l0023

		move.w	#$ac,d1
		movea.l	l0090,a0
		movea.l	l0090,a1
		lea	27536(a0),a0
		lea	28016(a1),a1
		lea	16(a0),a0
		lea	16(a1),a1
l0024		move.l	-(a0),-(a1)
		move.l	-(a0),-(a1)
		move.l	-(a0),-(a1)
		move.l	-(a0),-(a1)
		suba.l	#$90,a0
		suba.l	#$90,a1
		dbf	d1,l0024

		move.w	#3,d1
		movea.l	l0090,a0
		lea	16(a0),a0
		lea	l00a5,a1
l0025		move.l	(a1)+,(a0)+
		move.l	(a1)+,(a0)+
		move.l	(a1)+,(a0)+
		move.l	(a1)+,(a0)+
		adda.l	#$90,a0
		dbf	d1,l0025

		move.w	#2,d1
		movea.l	l0090,a0
		lea	l00a5,a1
		lea	27360(a0),a0
		lea	32(a0),a0
l0026		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		adda.l	#$98,a0
		dbf	d1,l0026

		move.w	#$ad,d1
		movea.l	l0090,a0
		movea.l	l0090,a1
		lea	27704(a0),a0
		lea	28024(a1),a1
		lea	16(a0),a0
		lea	16(a1),a1
l0027		move.l	-(a0),-(a1)
		move.l	-(a0),-(a1)
		suba.l	#$98,a0
		suba.l	#$98,a1
		dbf	d1,l0027

		move.w	#2,d1
		movea.l	l0090,a0
		lea	32(a0),a0
		lea	l00a5,a1
l0028		move.l	(a1)+,(a0)+
		move.l	(a1)+,(a0)+
		adda.l	#$98,a0
		dbf	d1,l0028

		move.w	#1,d1
		movea.l	l0090,a0
		lea	l00a5,a1
		lea	27520(a0),a0
		lea	40(a0),a0
l0029		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		adda.l	#$98,a0
		dbf	d1,l0029

		move.w	#$ae,d1
		movea.l	l0090,a0
		movea.l	l0090,a1
		lea	27872(a0),a0
		lea	28032(a1),a1
		lea	16(a0),a0
		lea	16(a1),a1
l002a		move.l	-(a0),-(a1)
		move.l	-(a0),-(a1)
		suba.l	#$98,a0
		suba.l	#$98,a1
		dbf	d1,l002a

		move.w	#1,d1
		movea.l	l0090,a0
		lea	40(a0),a0
		lea	l00a5,a1
l002b		move.l	(a1)+,(a0)+
		move.l	(a1)+,(a0)+
		adda.l	#$98,a0
		dbf	d1,l002b

		movea.l	l0090,a0
		movea.l	l0090,a1
		lea	144(a1),a1
		move.w	#$ae,d1
l002c		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		adda.l	#$90,a0
		adda.l	#$90,a1
		dbf	d1,l002c

		movea.l	l0090,a0
		movea.l	l0090,a1
		lea	128(a1),a1
		lea	16(a0),a0
		move.w	#$ae,d1
l002d		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		adda.l	#$90,a0
		adda.l	#$90,a1
		dbf	d1,l002d

		movea.l	l0090,a0
		movea.l	l0090,a1
		lea	120(a1),a1
		lea	32(a0),a0
		move.w	#$ae,d1
l002e		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		adda.l	#$98,a0
		adda.l	#$98,a1
		dbf	d1,l002e

		movea.l	l0090,a0
		movea.l	l0090,a1
		lea	112(a1),a1
		lea	40(a0),a0
		move.w	#$ae,d1
l002f		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		adda.l	#$98,a0
		adda.l	#$98,a1
		dbf	d1,l002f
		rts

l0030		move.w	#$25,-(sp)		;vsync
		trap	#14
		addq.l	#2,sp
		rts

l0031		cmpi.b	#$ff,(a0)
		bne.s	l0032

		move.b	2(a0),l0087
l0032		rts

		move.w	#1,-(sp)		;cconin
		trap	#1
		addq.l	#2,sp
		rts
;========================================
l0033		dc.w	$a000
		move.w	#$60,l0092
		move.w	#7,l0093
		move.w	#4,l0094
		move.w	#$f,l0095
		move.w	#0,l0096
		move.l	#$3030303,l0097
		move.w	#$e0,l0098
		move.w	l00ad,l0099
		move.l	#maingfx+34,l009a
		move.w	#8,l009b
		move.w	#$a0,l009c
		move.w	#2,l009d
		move.w	#$70,l009e
		move.w	#$be,l009f
		move.l	l0090,l00a0
		move.w	#8,l00a1
		move.w	#$a0,l00a2
		move.w	#2,l00a3
		move.l	#0,l00a4

		lea	l0092,a6
		dc.w	$a007
		cmpi.w	#$10,l00a8
		bls	x254938

		subi.w	#8,l00a8
		bra	l0034

x254938		move.b	#1,l00ae
		dc.w	$a000
		move.w	#$20,l0092
		move.w	#$10,l0093
		move.w	#4,l0094
		move.w	#$f,l0095
		move.w	#0,l0096
		move.l	#$3030303,l0097
		move.w	#$60,l0098
		move.w	#0,l0099
		move.l	#maingfx+34,l009a
		move.w	#8,l009b
		move.w	#$a0,l009c
		move.w	#2,l009d
		move.w	l00a7,l009e
		move.w	l00a8,l009f
		move.l	l0090,l00a0
		move.w	#8,l00a1
		move.w	#$a0,l00a2
		move.w	#2,l00a3
		move.l	#0,l00a4

		lea	l0092,a6
		dc.w	$a007
		bra	x254aa0

l0034		dc.w	$a000
		move.w	#$20,l0092
		move.w	#$10,l0093
		move.w	#4,l0094
		move.w	#$f,l0095
		move.w	#0,l0096
		move.l	#$3030303,l0097
		move.w	#$20,l0098
		move.w	#$b0,l0099
		move.l	#maingfx+34,l009a
		move.w	#8,l009b
		move.w	#$a0,l009c
		move.w	#2,l009d
		move.w	l00a7,l009e
		move.w	l00a8,l009f
		move.l	l0090,l00a0
		move.w	#8,l00a1
		move.w	#$a0,l00a2
		move.w	#2,l00a3
		move.l	#0,l00a4

		lea	l0092,a6
		dc.w	$a007
x254aa0		dc.w	$a000
		move.w	#$20,l0092
		move.w	#$10,l0093
		move.w	#4,l0094
		move.w	#$f,l0095
		move.w	#0,l0096
		move.l	#$3030303,l0097
		move.w	#0,l0098
		move.w	#$b0,l0099
		move.l	#maingfx+34,l009a
		move.w	#8,l009b
		move.w	#$a0,l009c
		move.w	#2,l009d
		move.w	l00a6,l009e
		move.w	#$a0,l009f
		move.l	l0090,l00a0
		move.w	#8,l00a1
		move.w	#$a0,l00a2
		move.w	#2,l00a3
		move.l	#0,l00a4

		lea	l0092,a6
		dc.w	$a007
		addi.w	#$20,l00ac
		cmpi.w	#$c0,l00ac
		beq	l0035

		bra	l0036

l0035		move.w	#$40,l00ac
l0036		move.w	(a4)+,l00a9
		move.w	(a4)+,l00aa
		dc.w	$a000
		move.w	#$20,l0092
		move.w	#$10,l0093
		move.w	#4,l0094
		move.w	#$f,l0095
		move.w	#0,l0096
		move.l	#$3030303,l0097
		move.w	l00ac,l0098
		move.w	#$b0,l0099
		move.l	#maingfx+34,l009a
		move.w	#8,l009b
		move.w	#$a0,l009c
		move.w	#2,l009d
		move.w	l00a9,l009e
		move.w	l00aa,l009f
		move.l	l0090,l00a0
		move.w	#8,l00a1
		move.w	#$a0,l00a2
		move.w	#2,l00a3
		move.l	#0,l00a4

		lea	l0092,a6
		dc.w	$a007
		move.w	l00a9,d0
		subi.w	#$10,d0
		cmp.w	l00a7,d0
		bhi	l0037

		addi.w	#$28,d0
		cmp.w	l00a7,d0
		bcs	l0037

		move.w	l00aa,d0
		subi.w	#8,d0
		cmp.w	l00a8,d0
		bhi	l0037

		addi.w	#$10,d0
		cmp.w	l00a8,d0
		bcs	l0037

		cmpi.w	#0,l00ad
		beq	ld_chess

		cmpi.w	#8,l00ad
		beq	ld_moon

		cmpi.w	#$10,l00ad
		beq	ld_twist

		cmpi.w	#$18,l00ad
		beq	ld_human

		cmpi.w	#$20,l00ad
		beq	ld_wind

		cmpi.w	#$28,l00ad
		beq	ld_qcm

		cmpi.w	#$30,l00ad
		beq	ld_spectral

		cmpi.w	#$38,l00ad
		beq	ld_wave

		cmpi.w	#$40,l00ad
		beq	ld_cyber

		cmpi.w	#$48,l00ad
		beq	ld_greet

		cmpi.w	#$50,l00ad
		beq	ld_intro

		cmpi.w	#$58,l00ad
		beq	ld_strix512

		cmpi.w	#$60,l00ad
		beq	ld_distort

		cmpi.w	#$68,l00ad
		beq	ld_love

		cmpi.w	#$70,l00ad
		beq	ld_bubble

		cmpi.w	#$78,l00ad
		beq	ld_big_text

		cmpi.w	#$80,l00ad
		beq	ld_the_end

		move.b	#0,l00ae
l0037		subi.w	#1,l00ab
		cmpi.w	#0,l00ab
		beq	l0038

		bra	l0039

l0038		lea	l008d,a4
		move.w	#$167,l00ab
l0039		rts
;========================================
ld_chess	pea	l0089
		move.w	#1,-(sp)
		move.w	#$19,-(sp)		;ikbdws
		trap	#14
		addq.l	#8,sp

		move.l	l0091,(a5)

		move.l	#0,$4d6.l

		bsr	l001e

		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp

		bsr	l004d

		pea	l004b(pc)
		move.w	#$26,-(sp)		;supexec
		trap	#14
		addq.l	#6,sp

		pea	null
		pea	null
		pea	chess
		pea	$4b0000
		trap	#1
		lea	16(sp),sp

		clr.w	-(sp)			;pterm0
		trap	#1
;========================================
ld_moon		pea	l0089
		move.w	#1,-(sp)
		move.w	#$19,-(sp)		;ikbdws
		trap	#14
		addq.l	#8,sp

		move.l	l0091,(a5)

		move.l	#0,$4d6.l

		bsr	l001e

		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp

		bsr	l004d

		pea	l004b(pc)
		move.w	#$26,-(sp)		;supexec
		trap	#14
		addq.l	#6,sp

		pea	null
		pea	null
		pea	moon
		pea	$4b0000
		trap	#1
		lea	16(sp),sp

		clr.w	-(sp)			;pterm0
		trap	#1
;========================================
ld_twist	pea	l0089
		move.w	#1,-(sp)
		move.w	#$19,-(sp)		;ikbdws
		trap	#14
		addq.l	#8,sp

		move.l	l0091,(a5)

		move.l	#0,$4d6.l

		bsr	l001e

		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp

		bsr	l004d

		pea	l004b(pc)
		move.w	#$26,-(sp)		;supexec
		trap	#14
		addq.l	#6,sp

		pea	null
		pea	null
		pea	twist
		pea	$4b0000
		trap	#1
		lea	16(sp),sp

		clr.w	-(sp)			;pterm0
		trap	#1
;========================================
ld_human	pea	l0089
		move.w	#1,-(sp)
		move.w	#$19,-(sp)		;ikbdws
		trap	#14
		addq.l	#8,sp

		move.l	l0091,(a5)

		move.l	#0,$4d6.l
		bsr	l001e

		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp

		bsr	l004d

		pea	l004b(pc)
		move.w	#$26,-(sp)		;supexec
		trap	#14
		addq.l	#6,sp

		pea	null
		pea	null
		pea	human
		pea	$4b0000
		trap	#1
		lea	16(sp),sp

		clr.w	-(sp)			;pterm0
		trap	#1
;========================================
ld_wind		pea	l0089
		move.w	#1,-(sp)
		move.w	#$19,-(sp)		;ikbdws
		trap	#14
		addq.l	#8,sp

		move.l	l0091,(a5)

		move.l	#0,$4d6.l

		bsr	l001e

		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp

		bsr	l004d

		pea	l004b(pc)
		move.w	#$26,-(sp)		;supexec
		trap	#14
		addq.l	#6,sp

		pea	null
		pea	null
		pea	wind
		pea	$4b0000
		trap	#1
		lea	16(sp),sp

		clr.w	-(sp)			;pterm0
		trap	#1
;========================================
ld_qcm		pea	l0089
		move.w	#1,-(sp)
		move.w	#$19,-(sp)		;ikbdws
		trap	#14
		addq.l	#8,sp

		move.l	l0091,(a5)

		move.l	#0,$4d6.l

		bsr	l001e

		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp

		bsr	l004d

		pea	l004b(pc)
		move.w	#$26,-(sp)		;supexec
		trap	#14
		addq.l	#6,sp

		pea	null
		pea	null
		pea	qcm
		pea	$4b0000
		trap	#1
		lea	16(sp),sp

		clr.w	-(sp)			;pterm0
		trap	#1
;========================================
ld_spectral	pea	l0089
		move.w	#1,-(sp)
		move.w	#$19,-(sp)		;ikbdws
		trap	#14
		addq.l	#8,sp

		move.l	l0091,(a5)

		move.l	#0,$4d6.l

		bsr	l001e

		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp

		bsr	l004d

		pea	l004b(pc)
		move.w	#$26,-(sp)		;supexec
		trap	#14
		addq.l	#6,sp

		pea	null
		pea	null
		pea	spectral
		pea	$4b0000
		trap	#1
		lea	16(sp),sp

		clr.w	-(sp)			;pterm0
		trap	#1
;========================================
ld_wave		pea	l0089
		move.w	#1,-(sp)
		move.w	#$19,-(sp)		;ikbdws
		trap	#14
		addq.l	#8,sp

		move.l	l0091,(a5)

		move.l	#0,$4d6.l

		bsr	l001e

		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp

		bsr	l004d

		pea	l004b(pc)
		move.w	#$26,-(sp)		;supexec
		trap	#14
		addq.l	#6,sp

		pea	null
		pea	null
		pea	wave
		pea	$4b0000
		trap	#1
		lea	16(sp),sp

		clr.w	-(sp)			;pterm0
		trap	#1
;========================================
ld_cyber	pea	l0089
		move.w	#1,-(sp)
		move.w	#$19,-(sp)		;ikbdws
		trap	#14
		addq.l	#8,sp

		move.l	l0091,(a5)

		move.l	#0,$4d6.l

		bsr	l001e

		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp

		bsr	l004d

		pea	l004b(pc)
		move.w	#$26,-(sp)		;supexec
		trap	#14
		addq.l	#6,sp

		pea	null
		pea	null
		pea	cyber
		pea	$4b0000
		trap	#1
		lea	16(sp),sp

		clr.w	-(sp)			;pterm0
		trap	#1
;========================================
ld_greet	pea	l0089
		move.w	#1,-(sp)
		move.w	#$19,-(sp)		;ikbdws
		trap	#14
		addq.l	#8,sp

		move.l	l0091,(a5)

		move.l	#0,$4d6.l

		bsr	l001e

		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp

		bsr	l004d

		pea	l004b(pc)
		move.w	#$26,-(sp)		;supexec
		trap	#14
		addq.l	#6,sp

		pea	null
		pea	null
		pea	greet
		pea	$4b0000
		trap	#1
		lea	16(sp),sp

		clr.w	-(sp)			;pterm0
		trap	#1
;========================================
ld_intro	pea	l0089
		move.w	#1,-(sp)
		move.w	#$19,-(sp)		;ikbdws
		trap	#14
		addq.l	#8,sp

		move.l	l0091,(a5)

		move.l	#0,$4d6.l

		bsr	l001e

		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp

		bsr	l004d

		pea	l004b(pc)
		move.w	#$26,-(sp)		;supexec
		trap	#14
		addq.l	#6,sp

		pea	null
		pea	null
		pea	intro
		pea	$4b0000
		trap	#1
		lea	16(sp),sp

		clr.w	-(sp)			;pterm0
		trap	#1
;========================================
ld_strix512	pea	l0089
		move.w	#1,-(sp)
		move.w	#$19,-(sp)		;ikbdws
		trap	#14
		addq.l	#8,sp

		move.l	l0091,(a5)

		move.l	#0,$4d6.l

		bsr	l001e

		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp

		bsr	l004d

		pea	l004b(pc)
		move.w	#$26,-(sp)		;supexec
		trap	#14
		addq.l	#6,sp

		pea	null
		pea	null
		pea	strix512
		pea	$4b0000
		trap	#1
		lea	16(sp),sp

		clr.w	-(sp)			;pterm0
		trap	#1
;========================================
ld_distort	pea	l0089
		move.w	#1,-(sp)
		move.w	#$19,-(sp)		;ikbdws
		trap	#14
		addq.l	#8,sp

		move.l	l0091,(a5)

		move.l	#0,$4d6.l

		bsr	l001e

		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp

		bsr	l004d

		pea	l004b(pc)
		move.w	#$26,-(sp)		;supexec
		trap	#14
		addq.l	#6,sp

		pea	null
		pea	null
		pea	distort
		pea	$4b0000
		trap	#1
		lea	16(sp),sp

		clr.w	-(sp)			;pterm0
		trap	#1
;========================================
ld_the_end	pea	l0089
		move.w	#1,-(sp)
		move.w	#$19,-(sp)		;ikbdws
		trap	#14
		addq.l	#8,sp

		move.l	l0091,(a5)

		move.l	#0,$4d6.l

		bsr	l001e

		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp

		bsr	l004d

		pea	l004b(pc)
		move.w	#$26,-(sp)		;supexec
		trap	#14
		addq.l	#6,sp

		pea	null
		pea	null
		pea	the_end
		pea	$4b0000
		trap	#1
		lea	16(sp),sp

		clr.w	-(sp)			;pterm0
		trap	#1
;========================================
ld_love		pea	l0089
		move.w	#1,-(sp)
		move.w	#$19,-(sp)		;ikbdws
		trap	#14
		addq.l	#8,sp

		move.l	l0091,(a5)

		move.l	#0,$4d6.l

		bsr	l001e

		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp

		bsr	l004d

		pea	l004b(pc)
		move.w	#$26,-(sp)		;supexec
		trap	#14
		addq.l	#6,sp

		pea	null
		pea	null
		pea	love
		pea	$4b0000
		trap	#1
		lea	16(sp),sp

		clr.w	-(sp)			;pterm0
		trap	#1
;========================================
ld_bubble	pea	l0089
		move.w	#1,-(sp)
		move.w	#$19,-(sp)		;ikbdws
		trap	#14
		addq.l	#8,sp

		move.l	l0091,(a5)

		move.l	#0,$4d6.l

		bsr	l001e

		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp

		bsr	l004d

		pea	l004b(pc)
		move.w	#$26,-(sp)		;supexec
		trap	#14
		addq.l	#6,sp

		pea	null
		pea	null
		pea	bubble
		pea	$4b0000
		trap	#1
		lea	16(sp),sp

		clr.w	-(sp)			;pterm0
		trap	#1
;========================================
ld_big_text	pea	l0089
		move.w	#1,-(sp)
		move.w	#$19,-(sp)		;ikbdws
		trap	#14
		addq.l	#8,sp

		move.l	l0091,(a5)

		move.l	#0,$4d6.l

		bsr	l001e

		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp

		bsr	l004d

		pea	l004b(pc)
		move.w	#$26,-(sp)		;supexec
		trap	#14
		addq.l	#6,sp

		pea	null
		pea	null
		pea	big_text
		pea	$4b0000
		trap	#1
		lea	16(sp),sp

		clr.w	-(sp)			;pterm0
		trap	#1
;========================================
l004b		move.l	#l004c,$8c.w
		rts
;========================================
		subq.l	#2,2(sp)
		pea	(a0)
		movea.l	6(sp),a0
		move.w	#$4eb9,(a0)
		lea	2628(a0),a0
		addq.w	#6,-10(a0)
		move.w	#$6008,(a0)+
		move.b	#$60,4(a0)
		movea.l	(sp)+,a0
		rte

l004c		subq.l	#2,2(sp)
		pea	(a0)
		movea.l	6(sp),a0
		move.w	#$4eb9,(a0)
		lea	2628(a0),a0
		movea.l	(sp)+,a0
		rte
;========================================
l004d		bsr	l004e

		movea.l	l0090,a0
		move.w	#$1f3f,d1
x25441a		clr.l	(a0)+
		dbf	d1,x25441a

		dc.w	$a000
		move.w	#$60,l0092
		move.w	#7,l0093
		move.w	#4,l0094
		move.w	#$f,l0095
		move.w	#0,l0096
		move.l	#$3030303,l0097
		move.w	#$e0,l0098
		move.w	l00ad,l0099
		move.l	#maingfx+34,l009a
		move.w	#8,l009b
		move.w	#$a0,l009c
		move.w	#2,l009d
		move.w	#$70,l009e
		move.w	#$64,l009f
		move.l	l0090,l00a0
		move.w	#8,l00a1
		move.w	#$a0,l00a2
		move.w	#2,l00a3
		move.l	#0,l00a4

		lea	l0092,a6
		dc.w	$a007
		dc.w	$a000
		move.w	#$140,l0092
		move.w	#8,l0093
		move.w	#4,l0094
		move.w	#$f,l0095
		move.w	#0,l0096
		move.l	#$3030303,l0097
		move.w	#0,l0098
		move.w	#$c0,l0099
		move.l	#maingfx+34,l009a
		move.w	#8,l009b
		move.w	#$a0,l009c
		move.w	#2,l009d
		move.w	#0,l009e
		move.w	#$5a,l009f
		move.l	l0090,l00a0
		move.w	#8,l00a1
		move.w	#$a0,l00a2
		move.w	#2,l00a3
		move.l	#0,l00a4

		lea	l0092,a6
		dc.w	$a007
		dc.w	$a000
		move.w	#$20,l0092
		move.w	#$10,l0093
		move.w	#4,l0094
		move.w	#$f,l0095
		move.w	#0,l0096
		move.l	#$3030303,l0097
		move.w	#$100,l0098
		move.w	#$b0,l0099
		move.l	#maingfx+34,l009a
		move.w	#8,l009b
		move.w	#$a0,l009c
		move.w	#2,l009d
		move.w	#0,l009e
		move.w	#$5a,l009f
		move.l	l0090,l00a0
		move.w	#8,l00a1
		move.w	#$a0,l00a2
		move.w	#2,l00a3
		move.l	#0,l00a4

		lea	l0092,a6
		dc.w	$a007
		dc.w	$a000
		move.w	#$20,l0092
		move.w	#$10,l0093
		move.w	#4,l0094
		move.w	#$f,l0095
		move.w	#0,l0096
		move.l	#$3030303,l0097
		move.w	#$120,l0098
		move.w	#$b0,l0099
		move.l	#maingfx+34,l009a
		move.w	#8,l009b
		move.w	#$a0,l009c
		move.w	#2,l009d
		move.w	#0,l009e
		move.w	#$6a,l009f
		move.l	l0090,l00a0
		move.w	#8,l00a1
		move.w	#$a0,l00a2
		move.w	#2,l00a3
		move.l	#0,l00a4

		lea	l0092,a6
		dc.w	$a007
		dc.w	$a000
		move.w	#$20,l0092
		move.w	#$20,l0093
		move.w	#4,l0094
		move.w	#$f,l0095
		move.w	#0,l0096
		move.l	#$3030303,l0097
		move.w	#0,l0098
		move.w	#$5a,l0099
		move.l	l0090,l009a
		move.w	#8,l009b
		move.w	#$a0,l009c
		move.w	#2,l009d
		move.w	#$120,l009e
		move.w	#$5a,l009f
		move.l	l0090,l00a0
		move.w	#8,l00a1
		move.w	#$a0,l00a2
		move.w	#2,l00a3
		move.l	#0,l00a4

		lea	l0092,a6
		dc.w	$a007

		bsr	l0030
		rts
;========================================
l004e		move.w	#$777,-(sp)
		move.w	#0,-(sp)
		move.w	#7,-(sp)		;setcolor
		trap	#14
		addq.l	#6,sp

		bsr	l0030

		dc.w	$a000
		move.w	#$20,l0092
		move.w	#$20,l0093
		move.w	#4,l0094
		move.w	#$f,l0095
		move.w	#0,l0096
		move.l	#$03030303,l0097
		move.w	#$120,l0098
		move.w	#$90,l0099
		move.l	#maingfx+34,l009a
		move.w	#8,l009b
		move.w	#$a0,l009c
		move.w	#2,l009d
		move.w	l00a9,l009e
		move.w	l00aa,l009f
		move.l	l0090,l00a0
		move.w	#8,l00a1
		move.w	#$a0,l00a2
		move.w	#2,l00a3
		move.l	#0,l00a4

		lea	l0092,a6
		dc.w	$a007
		move.l	#sample1,replay+$1c+2
		move.l	#$161c,replay+$1c+2+4
		move.l	#0,replay+$1c+2+4+4
		bsr	replay+$1c

		dc.w	$a000
		move.w	#$20,l0092
		move.w	#$20,l0093
		move.w	#4,l0094
		move.w	#$f,l0095
		move.w	#0,l0096
		move.l	#$3030303,l0097
		move.w	#$100,l0098
		move.w	#$90,l0099
		move.l	#maingfx+34,l009a
		move.w	#8,l009b
		move.w	#$a0,l009c
		move.w	#2,l009d
		move.w	l00a9,l009e
		move.w	l00aa,l009f
		move.l	l0090,l00a0
		move.w	#8,l00a1
		move.w	#$a0,l00a2
		move.w	#2,l00a3
		move.l	#0,l00a4

		lea	l0092,a6
		dc.w	$a007
		move.l	#sample2,replay+$1c+2
		move.l	#$3e8,replay+$1c+2+4
		move.l	#0,replay+$1c+2+4+4
		bsr	replay+$1c

		dc.w	$a000
		move.w	#$20,l0092
		move.w	#$20,l0093
		move.w	#4,l0094
		move.w	#$f,l0095
		move.w	#0,l0096
		move.l	#$3030303,l0097
		move.w	#$e0,l0098
		move.w	#$90,l0099
		move.l	#maingfx+34,l009a
		move.w	#8,l009b
		move.w	#$a0,l009c
		move.w	#2,l009d
		move.w	l00a9,l009e
		move.w	l00aa,l009f
		move.l	l0090,l00a0
		move.w	#8,l00a1
		move.w	#$a0,l00a2
		move.w	#2,l00a3
		move.l	#0,l00a4

		lea	l0092,a6
		dc.w	$a007
		move.l	#sample3,replay+$1c+2
		move.l	#$3e8,replay+$1c+2+4
		move.l	#0,replay+$1c+2+4+4
		bsr	replay+$1c

		bsr	l0030

		move.w	#0,-(sp)
		move.w	#0,-(sp)
		move.w	#7,-(sp)
		trap	#14
		addq.l	#6,sp

		dc.w	$a000
		move.w	#$20,l0092
		move.w	#$20,l0093
		move.w	#4,l0094
		move.w	#$f,l0095
		move.w	#0,l0096
		move.l	#$3030303,l0097
		move.w	#$60,l0098
		move.w	#0,l0099
		move.l	#maingfx+34,l009a
		move.w	#8,l009b
		move.w	#$a0,l009c
		move.w	#2,l009d
		move.w	l00a9,l009e
		move.w	l00aa,l009f
		move.l	l0090,l00a0
		move.w	#8,l00a1
		move.w	#$a0,l00a2
		move.w	#2,l00a3
		move.l	#0,l00a4

		lea	l0092,a6
		dc.w	$a007

		bsr	l0030
		rts
;========================================
l004f		pea	l0089
		move.w	#1,-(sp)
		move.w	#$19,-(sp)		;ikbdws
		trap	#14
		addq.l	#8,sp

		move.l	l0091,(a5)

		move.l	#0,$4d6.l

		bsr	l001e

		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp

		bsr	l004e
		rts
;========================================
key_f1		moveq	#0,d0
		jsr	music
		move.l	#music+4,$4d6.l

		bra	l0001

key_f2		moveq	#1,d0
		jsr	music
		move.l	#music+4,$4d6.l

		bra	l0001

key_f3		moveq	#2,d0
		jsr	music
		move.l	#music+4,$4d6.l

		bra	l0001

key_f4		moveq	#3,d0
		jsr	music

		move.l	#music+4,$4d6.l

		bra	l0001
;========================================
l0054		move.l	#$22222222,$426.l
		move.w	#$20,-(sp)
		trap	#1
		addq.l	#6,sp

		clr.l	-(sp)
		trap	#1
;========================================
sample1		incbin	sample1
sample2		incbin	sample2
sample3		incbin	sample3

replay		incbin	replay.prg

l0074		dc.b	$1b,'E'
		dc.b	'Welcome to the Blesie Demo Main Menu',$0d,$0a,$0d,$0a,$0d,$0a
		dc.b	'Choose your music :',$0d,$0a,$0d,$0a,$0d,$0a
		dc.b	'F1 : Switchblade intro',$0d,$0a
		dc.b	'F2 : Switchblade theme',$0d,$0a
		dc.b	'F3 : Switchblade "beep"',$0d,$0a
		dc.b	'F4 : Switchblade instrumental',$0d,$0a,$0d,$0a,$0d,$0a
		dc.b	'Joystick & Keyboard :',$0d,$0a
		dc.b	'=====================',$0d,$0a,$0d,$0a,$0d,$0a
		dc.b	'- LEFT & RIGHT : Move the ship',$0d,$0a
		dc.b	'-  UP  & DOWN  : Choose the screen',$0d,$0a
		dc.b	'- FIRE / [Ins] : Load it',$0d,$0a,$0d,$0a,$0d,$0a,$0d,$0a
		dc.b	'Now press the space bar to start !',$00

null		dc.l	0

chess		dc.b	'\CHESS.PRG',0
moon		dc.b	'\MOON.PRG',0
twist		dc.b	'\TWIST.PRG',0
human		dc.b	'\HUMAN.PRG',0
wind		dc.b	'\WIND.PRG',0
qcm		dc.b	'\QCM.PRG',0
spectral	dc.b	'\SPECTRAL.PRG',0
wave		dc.b	'\WAVE.PRG',0
cyber		dc.b	'\CYBER.PRG',0
greet		dc.b	'\GREET.PRG',0
intro		dc.b	'\AUTO\INTRO.PRG',0
strix512	dc.b	'\STRIX512.PRG',0
distort		dc.b	'\DISTORT.PRG',0
the_end		dc.b	'\THE_END.PRG',0
bubble		dc.b	'\BUBBLE.PRG',0
love		dc.b	'\LOVE.PRG',0
big_text	dc.b	'\BIG_TEXT.PRG',0
;========================================
		data
;========================================
l0087		dc.w	0
l0088		dc.b	$14
l0089		dc.b	$15,$08,$00

maingfx		incbin	main.pi1

l008d		incbin	l008d

music		incbin	swtchbld.mus
;========================================
		bss
;========================================
l0090		ds.l	1
l0091		ds.b	8
l0092		ds.w	1
l0093		ds.w	1
l0094		ds.w	1
l0095		ds.w	1
l0096		ds.w	1
l0097		ds.l	1
l0098		ds.w	1
l0099		ds.w	1
l009a		ds.l	1
l009b		ds.w	1
l009c		ds.w	1
l009d		ds.w	1
l009e		ds.w	1
l009f		ds.w	1
l00a0		ds.l	1
l00a1		ds.w	1
l00a2		ds.w	1
l00a3		ds.w	1
l00a4		ds.b	134
l00a5		ds.b	640
l00a6		ds.w	1
l00a7		ds.w	1
l00a8		ds.w	1
l00a9		ds.w	1
l00aa		ds.w	1
l00ab		ds.w	1
l00ac		ds.w	1
l00ad		ds.w	1
l00ae		ds.b	1
l00af		ds.b	1
l00b0		ds.w	1
;========================================
zuend		end
;========================================