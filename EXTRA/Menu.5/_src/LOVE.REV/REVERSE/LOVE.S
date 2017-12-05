;	opt	x+
;========================================
	text
;========================================
begin	dc.w	$a00a

	pea	l002b
	move.w	#9,-(sp)		;cconws
	trap	#1
	addq.l	#6,sp

	move.w	#$c8,d7
	bsr	l001c

	pea	l002c
	move.w	#9,-(sp)		;cconws
	trap	#1
	addq.l	#6,sp

	move.w	#$c8,d7
	bsr	l001c

	pea	l002d
	move.w	#9,-(sp)		;cconws
	trap	#1
	addq.l	#6,sp

	clr.l	-(sp)
	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp
	move.l	d0,-(sp)

	move.b	#$e,$484.l

	moveq	#1,d0
	jsr	l0029
	move.l	#l0029+6,$4d2.w

	pea	l0025+2
	move.w	#6,-(sp)		;setpallete
	trap	#14
	addq.l	#2,sp

	move.w	#2,-(sp)		;physbase
	trap	#14
	addq.l	#2,sp
	move.l	d0,l0031

	bsr	l000a

	lea	$fffffa01.w,a5
	move.l	a5,l0032
	andi.b	#$de,18(a5)
	andi.b	#$de,14(a5)
	andi.b	#$de,10(a5)
	andi.b	#$de,6(a5)
	clr.b	24(a5)
	clr.b	26(a5)

	lea	l0013(pc),a0
	move.l	a0,$134.w

	lea	l002e,a0
	move.l	$70.w,(a0)
	lea	l0010(pc),a0
	move.l	a0,$70.w

	move.l	#l002f,d0
	andi.l	#$ffffff00,d0
	addi.l	#$100,d0
	move.l	d0,l0030
	movea.l	d0,a2
	movea.l	a2,a0
	move.w	#$2acf,d1
l0000	clr.l	(a0)+
	dbf	d1,l0000

	movea.l	l0030,a1
	move.w	#$1f3f,d1
	lea	l0025,a2
	lea	34(a2),a2
l0001	move.l	(a2)+,(a1)+
	dbf	d1,l0001

	move.w	#$b8f,d1
	lea	l0028,a2
l0002	move.l	(a2)+,(a1)+
	dbf	d1,l0002

	move.l	#$ffffffff,-(sp)
	move.l	l0030,-(sp)
	move.l	l0030,-(sp)
	move.w	#5,-(sp)		;setscreen
	trap	#14
	adda.l	#$e,sp

	lea	l0020,a4
	lea	20(a4),a4
	move.w	#0,l0046
	move.b	#0,l0047
l0003	bsr	l001d
	bsr	l0009

	move.w	#$ff,-(sp)
	move.w	#6,-(sp)		;crawio
	trap	#1
	addq.l	#4,sp

	move.l	d0,d6
	swap	d6
	cmp.b	#$44,d6
	beq	l0008

l0004	cmp.b	#$20,d0
	bne	l0003

	pea	l0024
	move.w	#$20,-(sp)		;dosound
	trap	#14
	addq.l	#6,sp

	bset	#5,$fffa09.l

	clr.l	$4d2.w

	bsr	l0007

	move.w	sr,-(sp)
	ori.w	#$700,sr

	move.l	l002e,$70.w

	movea.l	l0032,a5
	andi.b	#$de,18(a5)
	andi.b	#$de,14(a5)
	andi.b	#$de,10(a5)
	andi.b	#$de,6(a5)
	clr.b	24(a5)
	clr.b	26(a5)
	bsr	l000b

	move.w	(sp)+,sr

	pea	l0023
	move.w	#0,-(sp)
	move.w	#$19,-(sp)		;ikbdws
	trap	#14
	addq.l	#8,sp

	move.l	#$ffffffff,-(sp)
	move.l	l0031,-(sp)
	move.l	l0031,-(sp)
	move.w	#5,-(sp)		;setscreen
	trap	#14
	adda.l	#$e,sp

	move.w	#$2700,sr
	lea	8.w,a1
	lea	l0006(pc),a0
	moveq	#9,d7
l0005	move.l	(a0)+,(a1)+
	dbf	d7,l0005

	jmp	$12.w

l0006	ori.b	#$c,d0
	movea.l	4.w,a0
	jmp	(a0)

	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp

	clr.l	-(sp)
	trap	#1
;========================================
l0007	move.l	#$8080000,$ffff8800.l
	move.l	#$9090000,$ffff8800.l
	move.l	#$a0a0000,$ffff8800.l
	rts

l0008	move.w	#7,-(sp)		;crawcin
	trap	#1
	addq.w	#2,sp

	bra	l0004

l0009	move.w	#$25,-(sp)		;vsync
	trap	#14
	addq.w	#2,sp
	rts

l000a	lea	l000d(pc),a0
	move.l	$114.l,2(a0)
	lea	l000c(pc),a0
	move.l	a0,$114.l

	lea	l000f(pc),a0
	move.l	$118.l,2(a0)
	lea	l000e(pc),a0
	move.l	a0,$118.l
	rts

l000b	lea	l000d(pc),a0
	move.l	2(a0),$114.l

	lea	l000f(pc),a0
	move.l	2(a0),$118.l
	rts

l000c	ori.w	#$500,sr
	andi.w	#$fdff,sr

l000d	jmp	$10000

l000e	ori.w	#$500,sr
	andi.w	#$fdff,sr

l000f	jmp	$10000

l0010	move.l	l002e,-(sp)
	movem.l	a0/d0-d1,-(sp)
	lea	$ffff8201.w,a0
	movep.w	0(a0),d0
	movep.w	4(a0),d1
	cmp.w	d0,d1
	bne.s	l0012

	tst.b	8(a0)
	bne.s	l0012

	lea	l0022,a0
	tst.w	(a0)
	beq.s	l0011

	clr.w	(a0)
	movem.l	(sp)+,a0/d0-d1
	rts

l0011	lea	l0016(pc),a0
	move.l	a0,$120.w
	lea	$fffffa01.w,a0
	clr.b	26(a0)
	move.b	#$c7,32(a0)
	move.b	#8,26(a0)
	ori.b	#1,6(a0)
	ori.b	#1,18(a0)
	movem.l	(sp)+,a0/d0-d1
	rts

l0012	lea	$fffffa01.w,a0
	andi.b	#$de,18(a0)
	andi.b	#$de,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
	lea	l0022,a0
	clr.w	(a0)
	movem.l	(sp)+,a0/d0-d1
	rts

l0013	cmpi.b	#1,$fffffa21.w
	bgt.s	l0013

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
	bne	l0014

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

l0014	move.b	#$fc,$ffff820a.w

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
	lea	l0018(pc),a0
	move.w	#$e4,d0
	tst.b	$ffff8209.w
	bne.s	l0015

	cmp.w	d1,d2
	bne.s	l0015

	lea	l0016(pc),a0
	move.w	#$c7,d0
l0015	move.l	a0,$120.w
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

l0016	movem.l	a0-a2/d0,-(sp)
	lea	$fffffa01.w,a0
	lea	$ffff8209.w,a1
	lea	l001a(pc),a2
	lea	-222(a2),a2
	moveq	#0,d0
	andi.b	#$fe,18(a0)
	andi.b	#$fe,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
l0017	move.b	(a1),d0
	cmp.w	#$de,d0
	blt.s	l0017

	cmp.b	#0,d0
	bgt	l001b

	jmp	0(a2,d0.w)

l0018	movem.l	a0-a2/d0,-(sp)
	lea	$fffffa01.w,a0
	lea	$ffff8209.w,a1
	lea	l001a(pc),a2
	moveq	#0,d0
	andi.b	#$fe,18(a0)
	andi.b	#$fe,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
l0019	move.b	(a1),d0
	cmp.b	#8,d0
	blt.s	l0019

	cmp.w	#$20,d0
	bgt	l001b

	jmp	-8(a2,d0.w)

l001a	nop
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
	lea	l0022,a0
	move.w	#$ffff,(a0)
	movem.l	(sp)+,a0-a2/d0
	rte

l001b	bclr	#0,14(a0)
	lea	l0022,a0
	clr.w	(a0)
	movem.l	(sp)+,a0-a2/d0
	rte

l001c	bsr	l0009
	dbf	d7,l001c
	rts

l001d	addi.w	#1,l0046
	cmpi.w	#$168,l0046
	beq	l001e

	bra	l001f

l001e	cmpi.b	#0,l0047
	beq	x254732

	lea	l0020,a4
	lea	$14(a4),a4
x254732	move.w	#0,l0046
	addi.b	#1,l0047
	cmpi.b	#2,l0047
	bne	l001f

	move.b	#0,l0047
	lea	l0025+34,a0
	movea.l	l0030,a1
	move.w	#$1f3f,d0
x254766	move.l	(a0)+,(a1)+
	dbf	d0,x254766

l001f	cmpi.b	#0,l0047
	beq	x254820
	dc.w	$a000
	move.w	#$70,l0033
	move.w	#$14,l0034
	move.w	#4,l0035
	move.w	#$f,l0036
	move.w	#0,l0037
	move.l	#$3030303,l0038
	move.w	-(a4),l0039
	move.w	#0,l003a
	move.l	#l0025+34,l003b
	move.w	#8,l003c
	move.w	#$a0,l003d
	move.w	#2,l003e
	move.w	(a4),l003f
	move.w	#0,l0040
	move.l	l0030,l0041
	move.w	#8,l0042
	move.w	#$a0,l0043
	move.w	#2,l0044
	move.l	#0,l0045
	lea	l0033,a6
	dc.w	$a007
	rts

x254820	dc.w	$a000
	move.w	#$70,l0033
	move.w	#$14,l0034
	move.w	#4,l0035
	move.w	#$f,l0036
	move.w	#0,l0037
	move.l	#$3030303,l0038
	move.w	#0,l0039
	move.w	#0,l003a
	move.l	#l0021,l003b
	move.w	#8,l003c
	move.w	#$a0,l003d
	move.w	#2,l003e
	move.w	(a4)+,l003f
	move.w	#0,l0040
	move.l	l0030,l0041
	move.w	#8,l0042
	move.w	#$a0,l0043
	move.w	#2,l0044
	move.l	#0,l0045
	lea	l0033,a6
	dc.w	$a007
	rts

l0020	incbin	l0020
l0021	incbin	l0021

;========================================
	data
;========================================
l0022	dc.b	$00,$00,$12
l0023	dc.b	$08

l0024	dc.b	$07,$ff,$06,$00,$08,$00,$09,$00
	dc.b	$0a,$00

l0025	incbin	l0025.pi1
l0028	incbin	l0028
l0029	incbin	l0029.mus

l002b	dc.b	$1b,'E'
	dc.b	$1b,'e'
	dc.b	'Bus Error at $FC005A',$0d,$0a
	dc.b	'Disassembly PC :',$0d,$0a,$0d,$0a,$0d,$0a
	dc.b	'$FC005A  -  MOVE.L D0,$42B',$0d,$0a
	dc.b	'$FC005C  -  TRAP #1',$0d,$0a
	dc.b	'$FC005E  -  NOP',$0d,$0a,$00
l002c	dc.b	'OK,OK !! It was a joke !...',$0d,$0a
	dc.b	'Here is the REAL screen !',$00
l002d	dc.b	$1b,'f',$00,$00
;========================================
	bss
;========================================
l002e	ds.l	1
l002f	ds.b	44096
l0030	ds.l	1
l0031	ds.l	1
l0032	ds.l	1
l0033	ds.w	1
l0034	ds.w	1
l0035	ds.w	1
l0036	ds.w	1
l0037	ds.w	1
l0038	ds.l	1
l0039	ds.w	1
l003a	ds.w	1
l003b	ds.l	1
l003c	ds.w	1
l003d	ds.w	1
l003e	ds.w	1
l003f	ds.w	1
l0040	ds.w	1
l0041	ds.l	1
l0042	ds.w	1
l0043	ds.w	1
l0044	ds.w	1
l0045	ds.b	134
l0046	ds.w	1
l0047	ds.w	1
;========================================
zuend	end
;========================================