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

	move.w	#$82,l00a1
	move.w	#$5a,l00a2
	bsr	l0008

	move.w	#2,d0
	jsr	l002e+44
	move.l	#l002e+44+8,$4d2.l

	pea	l0084+2
	move.w	#6,-(sp)		;setpallete
	trap	#14
	addq.l	#2,sp

	move.w	#2,-(sp)		;physbase
	trap	#14
	addq.l	#2,sp

	movea.l	d0,a1
	move.l	d0,l00a0
	lea	l0084,a2
	lea	34(a2),a2
	move.w	#$1f3f,d1
l0003	move.l	(a2)+,(a1)+
	dbf	d1,l0003

	lea	l0087,a5
	lea	l0088,a4
l0004	bsr	l0018
	bsr	l0015
	bsr	l002b
	bsr	l0021
	bsr	l0013

	move.w	#$ff,-(sp)
	move.w	#6,-(sp)		;crawio
	trap	#1
	addq.l	#4,sp

	move.l	d0,d6
	swap	d6

	cmp.b	#$3b,d6
	beq	l000d

	cmp.b	#$3c,d6
	beq	l000e

	cmp.b	#$3d,d6
	beq	l000f

	cmp.b	#$3e,d6
	beq	l0010

	cmp.b	#$43,d6
	beq	l0011

	cmp.b	#$44,d6
	beq	l0012

	cmp.b	#$42,d6
	beq	l0020

	cmp.b	#$48,d6
	beq	l001c

	cmp.b	#$50,d6
	beq	l001d

	cmp.b	#$4d,d6
	beq	l001e

	cmp.b	#$4b,d6
	beq	l001f

l0005	cmp.b	#$20,d0
	bne	l0004

	move.l	#0,$4d2.l

	bsr	l000c
	bsr	l0009

	move.w	#$2700,sr
	lea	8.w,a1
	lea	l0007(pc),a0
	moveq	#9,d7
l0006	move.l	(a0)+,(a1)+
	dbf	d7,l0006

	jmp	$12.w

l0007	ori.b	#$c,d0
	movea.l	4.w,a0
	jmp	(a0)

	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp

	clr.l	-(sp)
	trap	#1
;========================================
l0008	move.w	#$22,-(sp)		;kbdvbase
	trap	#14
	addq.l	#2,sp

	movea.l	d0,a5
	lea	24(a5),a5
	move.l	(a5),l00a3
	move.l	#l000a,(a5)
	pea	l008b
	clr.w	-(sp)
	move.w	#$19,-(sp)		;ikbdws
	trap	#14
	addq.l	#8,sp
	rts

l0009	pea	l008c
	move.w	#1,-(sp)
	move.w	#$19,-(sp)		;ikbdws
	trap	#14
	addq.l	#8,sp

	move.l	l00a3,(a5)
	rts

l000a	cmpi.b	#$ff,(a0)
	bne.s	l000b
	move.b	2(a0),l008a
l000b	rts

l000c	move.l	#$8080000,$ffff8800.l
	move.l	#$9090000,$ffff8800.l
	move.l	#$a0a0000,$ffff8800.l
	rts

l000d	move.w	#1,d0
	jsr	l002e+44

	bra	l0005

l000e	move.w	#2,d0
	jsr	l002e+44

	bra	l0005

l000f	move.w	#4,d0
	jsr	l002e+44

	bra	l0005

l0010	move.w	#5,d0
	jsr	l002e+44

	bra	l0005

l0011	lea	l0087,a5

	bra	l0005

l0012	lea	l0088,a5

	bra	l0005

l0013	move.w	#$25,-(sp)		;vsync
	trap	#14
	addq.w	#2,sp
	rts

l0014	dc.w	$a000
	move.w	#4,l008d
	move.w	#8,l008e
	move.w	#4,l008f
	move.w	#$f,l0090
	move.w	#0,l0091
	move.l	#$3030303,l0092
	move.w	(a5)+,l0093
	move.w	#0,l0094
	move.l	#l0086,l0095
	move.w	#8,l0096
	move.w	#$a0,l0097
	move.w	#2,l0098
	move.w	#$13c,l0099
	move.w	#$be,l009a
	move.l	l00a0,l009b
	move.w	#8,l009c
	move.w	#$a0,l009d
	move.w	#2,l009e
	move.l	#0,l009f

	lea	l008d,A6
	dc.w	$a007
	dc.w	$a000
	move.w	#$13c,l008d
	move.w	#8,l008e
	move.w	#4,l008f
	move.w	#$f,l0090
	move.w	#0,l0091
	move.l	#$3030303,l0092
	move.w	#4,l0093
	move.w	#$be,l0094
	move.l	l00a0,l0095
	move.w	#8,l0096
	move.w	#$a0,l0097
	move.w	#2,l0098
	move.w	#0,l0099
	move.w	#$be,l009a
	move.l	l00a0,l009b
	move.w	#8,l009c
	move.w	#$a0,l009d
	move.w	#2,l009e
	move.l	#0,l009f
	lea	l008d,A6
	dc.w	$a007
	rts

	dc.w	$a000
	move.w	#4,l008d
	move.w	#8,l008e
	move.w	#4,l008f
	move.w	#$f,l0090
	move.w	#0,l0091
	move.l	#$3030303,l0092
	move.w	(A4)+,l0093
	move.w	#0,l0094
	move.l	#l0086,l0095
	move.w	#8,l0096
	move.w	#$a0,l0097
	move.w	#2,l0098
	move.w	#$13C,l0099
	move.w	#0,l009a
	move.l	l00a0,l009b
	move.w	#8,l009c
	move.w	#$a0,l009d
	move.w	#2,l009e
	move.l	#0,l009f

	lea	l008d,A6
	dc.w	$a007
	dc.w	$a000
	move.w	#$13c,l008d
	move.w	#8,l008e
	move.w	#4,l008f
	move.w	#$f,l0090
	move.w	#0,l0091
	move.l	#$3030303,l0092
	move.w	#4,l0093
	move.w	#0,l0094
	move.l	l00a0,l0095
	move.w	#8,l0096
	move.w	#$a0,l0097
	move.w	#2,l0098
	move.w	#0,l0099
	move.w	#0,l009a
	move.l	l00a0,l009b
	move.w	#8,l009c
	move.w	#$a0,l009d
	move.w	#2,l009e
	move.l	#0,l009f

	lea	l008d,A6
	dc.w	$a007
	rts

l0015	bsr	l0014
	cmpi.w	#$13c,(a5)
	beq	l0016

	bra	l0017

l0016	lea	l0087,a5
l0017	rts

l0018	move.w	#8,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d5
	movea.l	l00a0,a2
	lea	24320(a2),a2
	lea	l0089,a3
	adda.l	d2,a3
l0019	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d5,l0019

	move.w	#9,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d5
	movea.l	l00a0,a2
	lea	24320(a2),a2
	lea	8(a2),a2
	lea	l0089,a3
	adda.l	d2,a3
l001a	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d5,l001a

	move.w	#$a,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d5
	movea.l	l00a0,a2
	lea	24320(a2),a2
	lea	16(a2),a2
	lea	l0089,a3
	adda.l	d2,a3
l001b	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d5,l001b
	rts

l001c	cmpi.w	#0,l00a2
	beq	l0005

	subi.w	#2,l00a2
	bra	l0005

l001d	cmpi.w	#$b8,l00a2
	beq	l0005

	addi.w	#2,l00a2
	bra	l0005

l001e	cmpi.w	#$130,l00a1
	beq	l0005

	addi.w	#2,l00a1
	bra	l0005

l001f	cmpi.w	#2,l00a1
	beq	l0005

	subi.w	#2,l00a1
	bra	l0005

l0020	move.w	#7,-(sp)		;crawcin
	trap	#1
	addq.l	#2,sp

	bra	l0005

l0021	move.b	l008a,d0
	btst	#0,d0
	bne.s	l0026

l0022	btst	#1,d0
	bne.s	l0027

l0023	btst	#3,d0
	bne.s	l0028

l0024	btst	#2,d0
	bne.s	l0029

l0025	bra	l002a

l0026	cmpi.w	#0,l00a2
	beq	l0022

	subi.w	#2,l00a2
	bra	l0022

l0027	cmpi.w	#$b8,l00a2
	beq	l0023

	addi.w	#2,l00a2
	bra	l0023

l0028	cmpi.w	#$130,l00a1
	beq	l0024

	addi.w	#2,l00a1
	bra	l0024

l0029	cmpi.w	#0,l00a1
	beq	l0025

	subi.w	#2,l00a1
	bra	l0025

l002a	dc.w	$a000
	move.w	#$10,l008d
	move.w	#$10,l008e
	move.w	#4,l008f
	move.w	#$f,l0090
	move.w	#0,l0091
	move.l	#$3030303,l0092
	move.w	l00a1,l0093
	move.w	l00a2,l0094
	move.l	l00a0,l0095
	move.w	#8,l0096
	move.w	#$a0,l0097
	move.w	#2,l0098
	move.w	#$120,l0099
	move.w	#$88,l009a
	move.l	l00a0,l009b
	move.w	#8,l009c
	move.w	#$a0,l009d
	move.w	#2,l009e
	move.l	#0,l009f

	lea	l008d,a6
	dc.w	$a007
l002b	movea.l	l00a0,a2
	movea.l	l00a0,a3
	lea	31680(a3),a3
	move.w	#8,d6
l002c	move.w	#$27,d5
l002d	move.l	(a3)+,(a2)+
	dbf	d5,l002d

	suba.l	#$140,a3
	dbf	d6,l002c
	rts

	dc.w	$a000
	move.w	#$140,l008d
	move.w	#8,l008e
	move.w	#4,l008f
	move.w	#$f,l0090
	move.w	#0,l0091
	move.l	#$3030303,l0092
	move.w	#0,l0093
	move.w	#$be,l0094
	move.l	l00a0,l0095
	move.w	#8,l0096
	move.w	#$a0,l0097
	move.w	#2,l0098
	move.w	#0,l0099
	move.w	#0,l009a
	move.l	l00a0,l009b
	move.w	#8,l009c
	move.w	#$a0,l009d
	move.w	#2,l009e
	move.l	#0,l009f

	lea	l008d,a6
	dc.w	$a007
	rts

l002e	incbin	l002e.mus
l0084	incbin	l0084.pi1
l0086	incbin	l0086
l0087	incbin	l0087
l0088	incbin	l0088
l0089	incbin	l0089

l008a	dc.b	$00
l008b	dc.b	$14
l008c	dc.b	$15,$08
;========================================
	bss
;========================================
l008d	ds.w	1
l008e	ds.w	1
l008f	ds.w	1
l0090	ds.w	1
l0091	ds.w	1
l0092	ds.l	1
l0093	ds.w	1
l0094	ds.w	1
l0095	ds.l	1
l0096	ds.w	1
l0097	ds.w	1
l0098	ds.w	1
l0099	ds.w	1
l009a	ds.w	1
l009b	ds.l	1
l009c	ds.w	1
l009d	ds.w	1
l009e	ds.w	1
l009f	ds.b	134
l00a0	ds.l	1
l00a1	ds.w	1
l00a2	ds.w	1
l00a3	ds.l	1
;========================================
zuend	end
;========================================