;	opt	x+
;========================================
	text
;========================================
begin	movea.l	4(sp),a3
	movea.l	#l004f,sp
	move.l	12(a3),d0
	add.l	20(a3),d0
	add.l	28(a3),d0
	move.l	d0,-(sp)
	move.l	a3,-(sp)
	clr.w	-(sp)
	move.w	#$4a,-(sp)		;mshrink
	trap	#1
	adda.w	#$c,sp

	dc.w	$a00a

	move.l	#$1fbd0,-(sp)
	move.w	#$48,-(sp)		;malloc
	trap	#1
	addq.l	#6,sp
	move.l	d0,l0050

	pea	l0043+2
	move.w	#6,-(sp)		;setpallete
	trap	#14
	addq.l	#6,sp

	move.w	#2,-(sp)		;physbase
	trap	#14
	addq.l	#2,sp

	movea.l	d0,a1
	move.l	d0,l0051
	add.l	d0,l003b
	add.l	d0,l003a
	add.l	d0,l003c
	add.l	d0,l003d
	add.l	d0,l003e
	add.l	d0,l003f
	move.w	#$1f3f,d1
l0000	clr.l	(a1)+
	dbf	d1,l0000

	movea.l	l0051,a1
	lea	l0043+34,a0
	move.w	#$1cbf,d1
l0001	move.l	(a0)+,(a1)+
	dbf	d1,l0001

	lea	l0050,a1
	lea	l0040,a0
	bsr	l0038

	clr.l	-(sp)
	move.w	#$20,-(sp)		;super
	trap	#1
	addq.w	#6,sp
	move.l	d0,-(sp)

	bsr	l0018

	move.l	$70.w,l004e
	move.l	#l0017,$70.w

	bsr	l0004

	move.l	l004e,$70.w

	bsr	l0037

	move.w	#$ff,-(sp)
	move.w	#6,-(sp)		;crawio
	trap	#1
	addq.w	#4,sp

	move.l	l0050,-(sp)
	move.w	#$49,-(sp)		;mfree
	trap	#1
	addq.l	#6,sp

	move.w	#$2700,sr

	lea	8.w,a1
	lea	l0003(pc),a0
	moveq	#9,d7
l0002	move.l	(a0)+,(a1)+
	dbf	d7,l0002

	jmp	$12.w

l0003	ori.b	#$c,d0
	movea.l	4.w,a0
	jmp	(a0)

	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp

	clr.l	-(sp)
	trap	#1
;========================================
l0004	sf	l0041+28+98
	sf	l004c
	lea	l0041+28,a0
	move.l	#l0045,12(a0)
	move.l	#l0050,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr

	lea	l004b,a5
	move.b	#3,l0054
l0005	bsr	l0025
	bsr	l001c
	bsr	l001f
	bsr	l0015
	bsr	l000b
	bsr	l0007
	bsr	l0025
	bsr	l001c
	bsr	l001f
	bsr	l0015
	bsr	l000b
	bsr	l0007
	bsr	l0025
	bsr	l001c
	bsr	l0023
	bsr	l0015
	bsr	l000b
	bsr	l0007

	tst.b	l004c
	beq.s	l0005

l0006	move.w	#$2500,sr

	lea	l0041+28,a6
	jsr	8(a6)
	rts

l0007	move.b	l0054,l0055
l0008	cmpi.b	#0,l0055
	beq.s	l0009

	bsr	l000a

	subi.b	#1,l0055
	bra	l0008
l0009	rts

l000a	bsr	l0025
	bsr	l0015
	bsr	l000b
	rts

l000b	move.b	l0041+28+98,d6
	andi.b	#$7f,d6
	beq	l000c

	cmp.b	#$3d,d6
	beq	l000d

	cmp.b	#$3e,d6
	beq	l000e

	cmp.b	#$3f,d6
	beq	l000f

	cmp.b	#$40,d6
	beq	l0010

	cmp.b	#$41,d6		;#'A'
	beq	l0011

	cmp.b	#$42,d6
	beq	l0012

	cmp.b	#$43,d6
	beq	l0013

	cmp.b	#$44,d6
	beq	l0014

	cmp.b	#$39,d6		;#'9'
	bne.s	l000c

	st	l004c
l000c	rts

l000d	move.l	a5,l0053
	bsr	l0006

	lea	l0041+28,a0
	move.l	#l0045,12(a0)
	move.l	#l0050,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr

	movea.l	l0053,a5
	rts

l000e	move.l	a5,l0053
	bsr	l0006

	lea	l0041+28,a0
	move.l	#l0046,12(a0)
	move.l	#l0050,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr

	movea.l	l0053,a5
	rts

l000f	move.l	a5,l0053
	bsr	l0006

	lea	l0041+28,a0
	move.l	#l0047,12(a0)
	move.l	#l0050,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr

	movea.l	l0053,a5
	rts

l0010	move.l	a5,l0053
	bsr	l0006

	lea	l0041+28,a0
	move.l	#l0048,12(a0)
	move.l	#l0050,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr

	movea.l	l0053,a5
	rts

l0011	move.l	a5,l0053
	bsr	l0006

	lea	l0041+28,a0
	move.l	#l0049,12(a0)
	move.l	#l0050,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr

	movea.l	l0053,a5
	rts

l0012	move.b	#1,l0054
	rts

l0013	move.b	#3,l0054
	rts

l0014	move.b	#5,l0054
	rts

l0015	sf	l004d
l0016	tst.b	l004d
	beq.s	l0016
	rts

l0017	st	l004d
	rte

l0018	lea	l0041+28,a0
	movea.l	a0,a1
	move.l	a0,d1
	adda.l	#$3dd7,a1
	moveq	#0,d0
l0019	move.b	(a1)+,d0
	beq	l001b

	cmp.w	#1,d0
	bne.s	l001a

	adda.w	#$fe,a0
	bra.s	l0019

l001a	adda.w	d0,a0
	add.l	d1,(a0)
	bra.s	l0019
l001b	rts

l001c	move.l	a5,l0053
	movea.l	l003f,a5
	movea.l	l003f,a6
	lea	8(a5),a5
	move.w	#$1f,d6
l001d	move.w	#$25,d7
l001e	move.l	(a5)+,(a6)+
	dbf	d7,l001e

	lea	8(a5),a5
	lea	8(a6),a6
	dbf	d6,l001d

	movea.l	l0053,a5
	rts

l001f	cmpi.l	#$f8,(a5)
	beq	l0020

	bra	l0021

l0020	lea	l004b,a5
l0021	move.l	(a5),l0052
	move.l	a5,l0053
	lea	l004a,a5
	adda.l	l0052,a5
	movea.l	l003e,a6
	move.w	#$1f,d6
l0022	move.l	(a5)+,(a6)+
	move.l	(a5)+,(a6)+
	lea	152(a5),a5
	lea	152(a6),a6
	dbf	d6,l0022

	movea.l	l0053,a5
	adda.l	#4,a5
	rts

l0023	move.l	#$2860,l0052
	move.l	a5,l0053
	lea	l004a,a5
	adda.l	l0052,a5
	movea.l	l003e,a6
	move.w	#$1f,d6
l0024	move.l	(a5)+,(a6)+
	move.l	(a5)+,(a6)+
	lea	152(a5),a5
	lea	152(a6),a6
	dbf	d6,l0024

	movea.l	l0053,a5
	rts

l0025	move.l	a5,l0053
	move.l	d2,d6
	swap	d6
	move.b	0(a2,d6.w),d6
	andi.w	#$7f,d6
	lea	l0043+34,a5
	lea	29440(a5),a5
	lea	24(a5),a5
	cmp.w	#$20,d6
	bhi	l0026

	bra	l0029

l0026	cmp.w	#$40,d6
	bhi	l0027

	lea	-8(a5),a5
	bra	l0029

l0027	cmp.w	#$60,d6
	bhi	l0028

	lea	-16(a5),a5
	bra	l0029

l0028	lea	-24(a5),a5
l0029	move.w	#$f,d6
	movea.l	l003b,a6
l002a	move.l	(a5),(a6)
	move.l	4(a5),4(a6)
	lea	160(a5),a5
	lea	160(a6),a6
	dbf	d6,l002a

	lea	l0043+34,a5
	lea	29472(a5),a5
	move.l	d0,d6
	swap	d6
	move.b	0(a0,d6.w),d6
	andi.w	#$7f,d6
	cmp.w	#$78,d6
	bcs	l002b

	lea	24(a5),a5
l002b	move.w	#$f,d6
	movea.l	l003a,a6
l002c	move.l	(a5),(a6)
	move.l	4(a5),4(a6)
	move.l	8(a5),8(a6)
	move.l	12(a5),12(a6)
	move.l	16(a5),16(a6)
	move.l	20(a5),20(a6)
	lea	160(a5),a5
	lea	160(a6),a6
	dbf	d6,l002c

	move.l	d1,d6
	swap	d6
	move.b	0(a1,d6.w),d6
	andi.w	#$7f,d6
	lea	l0043+34,a5
	lea	29440(a5),a5
	lea	104(a5),a5
	cmp.w	#$20,d6
	bhi	l002d

	bra	l0030

l002d	cmp.w	#$40,d6
	bhi	l002e

	lea	-8(a5),a5
	bra	l0030

l002e	cmp.w	#$60,d6
	bhi	l002f

	lea	-16(a5),a5
	bra	l0030

l002f	lea	-24(a5),a5
l0030	move.w	#$f,d6
	movea.l	l003c,a6
l0031	move.l	(a5),(a6)
	move.l	4(a5),4(a6)
	lea	160(a5),a5
	lea	160(a6),a6
	dbf	d6,l0031

	move.l	d3,d6
	swap	d6
	move.b	0(a3,d6.w),d6
	andi.w	#$7f,d6
	lea	l0043+34,a5
	lea	29440(a5),a5
	lea	128(a5),a5
	cmp.w	#$20,d6
	bhi	l0032

	bra	l0035

l0032	cmp.w	#$40,d6
	bhi	l0033

	lea	-8(a5),a5
	bra	l0035

l0033	cmp.w	#$60,d6
	bhi	l0034

	lea	-16(a5),a5
	bra	l0035

l0034	lea	-24(a5),a5
l0035	move.w	#$f,d6
	movea.l	l003d,a6
l0036	move.l	(a5),(a6)
	move.l	4(a5),4(a6)
	lea	160(a5),a5
	lea	160(a6),a6
	dbf	d6,l0036

	movea.l	l0053,a5
	rts

l0037	move.l	#0,$ffff8800.w
	move.l	#$1010000,$ffff8800.w
	move.l	#$2020000,$ffff8800.w
	move.l	#$3030000,$ffff8800.w
	move.l	#$4040000,$ffff8800.w
	move.l	#$5050000,$ffff8800.w
	move.l	#$6060000,$ffff8800.w
	move.l	#$707ffff,$ffff8800.w
	move.l	#$8080000,$ffff8800.w
	move.l	#$9090000,$ffff8800.w
	move.l	#$a0a0000,$ffff8800.w
	rts

l0038	move.l	a1,d5
	move.w	#0,-(sp)
	move.l	a0,-(sp)
	move.w	#$3d,-(sp)		;fopen
	trap	#1
	addq.l	#8,sp
	tst.l	d0
	bmi	l0039

	move.w	d0,d6
	move.w	#2,-(sp)
	move.w	d6,-(sp)
	move.l	#0,-(sp)
	move.w	#$42,-(sp)		;fseek
	trap	#1
	adda.l	#$a,sp
	move.l	d0,d7

	move.w	#0,-(sp)
	move.w	d6,-(sp)
	move.l	#0,-(sp)
	move.w	#$42,-(sp)		;fseek
	trap	#1
	adda.l	#$a,sp

	move.l	d5,-(sp)
	move.l	d7,-(sp)
	move.w	d6,-(sp)
	move.w	#$3f,-(sp)		;fread
	trap	#1
	adda.l	#$c,sp

	move.w	d6,-(sp)
	move.w	#$3e,-(sp)		;fclose
	trap	#1
	addq.l	#4,sp

l0039	move.l	d7,d1
	rts
;========================================
	data
;========================================
l003a	dc.b	$00,$00,$1e,$40
l003b	dc.b	$00,$00,$50,$60
l003c	dc.b	$00,$00,$28,$10
l003d	dc.b	$00,$00,$1e,$88
l003e	dc.b	$00,$00,$69,$98
l003f	dc.b	$00,$00,$69,$00
l0040	dc.b	'VOICE.SET',$00

l0041	incbin	replay.prg
l0043	incbin	l0043.pi1
l0045	incbin	l0045
l0046	incbin	l0046
l0047	incbin	l0047
l0048	incbin	l0048
l0049	incbin	l0049
l004a	incbin	l004a
l004b	incbin	l004b
;========================================
	bss
;========================================
l004c	ds.w	1
l004d	ds.w	1
l004e	ds.b	404
l004f	ds.w	1
l0050	ds.l	1
l0051	ds.b	8
l0052	ds.l	1
l0053	ds.l	1
l0054	ds.b	1
l0055	ds.b	1
;========================================
zuend	end
;========================================