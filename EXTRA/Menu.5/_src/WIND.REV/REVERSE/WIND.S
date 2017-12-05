;	opt	x+
;========================================
	text
;========================================
begin	movea.l	4(sp),a3
	movea.l	#l0087,sp
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

	move.w	#2,-(sp)		;physbase
	trap	#14
	addq.l	#2,sp

	movea.l	d0,a1
	add.l	d0,l0080
	lea	l004f+34,a0
	move.w	#$1f3f,d1
l0000	move.l	(a0)+,(a1)+
	dbf	d1,l0000

	pea	l004f+2
	move.w	#6,-(sp)		;setpallete
	trap	#14
	addq.l	#6,sp

	clr.l	-(sp)
	move.w	#$20,-(sp)		;super
	trap	#1
	addq.w	#6,sp
	move.l	d0,-(sp)

	move.l	#$1fbd0,-(sp)
	move.w	#$48,-(sp)
	trap	#13
	addq.l	#6,sp
	move.l	d0,l0088

	lea	l004c,a0
	lea	l0088,a1
	bsr	l0049
	bsr	l0045

	move.l	$70.w,l0086
	move.l	#l0044,$70.w

	bsr	l0003

	move.l	l0086,$70.w

	bsr	l004b

	move.w	#$ff,-(sp)
	move.w	#6,-(sp)		;crawio
	trap	#1
	addq.w	#4,sp

	move.l	l0088,-(sp)
	move.w	#$49,-(sp)
	trap	#13
	addq.l	#6,sp

	move.w	#$2700,sr

	lea	8.w,a1
	lea	l0002(pc),a0
	moveq	#9,d7
l0001	move.l	(a0)+,(a1)+
	dbf	d7,l0001

	jmp	$12.w

l0002	ori.b	#$c,d0
	movea.l	4.w,a0
	jmp	(a0)

	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp

	clr.l	-(sp)
	trap	#1
;========================================
l0003	sf	l004d+28+98
	sf	l0084
	lea	l004d+28,a0
	move.l	#l0074,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr

l0004	bsr	l0006
	bsr	l0043
	bsr	l0013

	tst.b	l0084
	beq.s	l0004

l0005	lea	l0082,a5
	move.l	#0,(a5)
	move.l	#0,4(a5)

	move.w	#$2500,sr

	lea	l004d+28,a5
	jsr	8(a5)
	rts

l0006	lea	l0082,a5
	move.l	d0,d6
	swap	d6
	move.b	0(a0,d6.w),d6
	andi.w	#$7f,d6
	lsr.w	#1,d6
	cmp.w	(a5),d6
	bge.s	l0007

	subq.w	#1,(a5)
	bge.s	l0008

	moveq	#0,d6
l0007	move.w	d6,(a5)
l0008	addq.w	#2,a5
	move.l	d1,d6
	swap	d6
	move.b	0(a1,d6.w),d6
	andi.w	#$7f,d6
	lsr.w	#1,d6
	cmp.w	(a5),d6
	bge.s	l0009

	subq.w	#1,(a5)
	bge.s	l000a

	moveq	#0,d6
l0009	move.w	d6,(a5)
l000a	addq.w	#2,a5
	move.l	d2,d6
	swap	d6
	move.b	0(a2,d6.w),d6
	andi.w	#$7f,d6
	lsr.w	#1,d6
	cmp.w	(a5),d6
	bge.s	l000b

	subq.w	#1,(a5)
	bge.s	l000c

	moveq	#0,d6
l000b	move.w	d6,(a5)
l000c	addq.w	#2,a5
	move.l	d3,d6
	swap	d6
	move.b	0(a3,d6.w),d6
	andi.w	#$7f,d6
	lsr.w	#1,d6
	cmp.w	(a5),d6
	bge.s	l000d

	subq.w	#1,(a5)
	bge.s	l000e

	moveq	#0,d6
l000d	move.w	d6,(a5)
l000e	addq.w	#2,a5
	move.w	#$30,l0083
l000f	movea.l	l0080,a6
	adda.w	l0083,a6
	move.w	#$40,d6
	move.w	-(a5),d7
	move.l	a5,l0081
	lea	l004f+34+14128,a5
	adda.w	l0083,a5
	sub.w	d7,d6
	beq.s	l0011

	subq.w	#1,d6
l0010	clr.l	(a6)
	clr.l	4(a6)
	adda.l	#$a0,a6
	adda.l	#$a0,a5
	dbf	d6,l0010

	tst.w	d7
	beq.s	l0012

	subq.w	#1,d7
l0011	move.l	(a5),(a6)
	move.l	4(a5),4(a6)
	adda.l	#$a0,a6
	adda.l	#$a0,a5
	dbf	d7,l0011

l0012	movea.l	l0081,a5
	subi.w	#$10,l0083
	bge.s	l000f
	rts

l0013	move.b	l004d+28+98,d6
	andi.b	#$7f,d6
	beq	l0014

	cmp.b	#$10,d6
	beq	l0015

	cmp.b	#$11,d6
	beq	l0016

	cmp.b	#$12,d6
	beq	l0017

	cmp.b	#$13,d6
	beq	l0018

	cmp.b	#$14,d6
	beq	l0019

	cmp.b	#$15,d6
	beq	l001a

	cmp.b	#$16,d6
	beq	l001b

	cmp.b	#$17,d6
	beq	l001c

	cmp.b	#$18,d6
	beq	l001d

	cmp.b	#$19,d6
	beq	l001e

	cmp.b	#$1a,d6
	beq	l001f

	cmp.b	#$1b,d6
	beq	l0020

	cmp.b	#$1e,d6
	beq	l0021

	cmp.b	#$1f,d6
	beq	l0022

	cmp.b	#$20,d6
	beq	l0023

	cmp.b	#$21,d6
	beq	l0024

	cmp.b	#$22,d6
	beq	l0025

	cmp.b	#$23,d6
	beq	l0026

	cmp.b	#$24,d6
	beq	l0027

	cmp.b	#$25,d6
	beq	l0028

	cmp.b	#$26,d6
	beq	l0029

	cmp.b	#$27,d6
	beq	l002a

	cmp.b	#$28,d6
	beq	l002b

	cmp.b	#$2c,d6
	beq	l002c

	cmp.b	#$2d,d6
	beq	l002d

	cmp.b	#$2e,d6
	beq	l002e

	cmp.b	#$2f,d6
	beq	l002f

	cmp.b	#$30,d6		;#'0'
	beq	l0030

	cmp.b	#$31,d6
	beq	l0031

	cmp.b	#$32,d6
	beq	l0032

	cmp.b	#$33,d6
	beq	l0033

	cmp.b	#$34,d6
	beq	l0034

	cmp.b	#$35,d6
	beq	l0035

	cmp.b	#2,d6
	beq	l0036

	cmp.b	#3,d6
	beq	l0037

	cmp.b	#4,d6
	beq	l0038

	cmp.b	#5,d6
	beq	l0039

	cmp.b	#6,d6
	beq	l003a

	cmp.b	#7,d6
	beq	l003b

	cmp.b	#8,d6
	beq	l003c

	cmp.b	#9,d6
	beq	l003d

	cmp.b	#$a,d6
	beq	l003e

	cmp.b	#$b,d6
	beq	l003f

	cmp.b	#$c,d6
	beq	l0040

	cmp.b	#$29,d6
	beq	l0041

	cmp.b	#$e,d6
	beq	l0042

	cmp.b	#$39,d6		;#'9'
	bne.s	l0014

	st	l0084
	rts

l0014	rts

l0015	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0052,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0016	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0053,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0017	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0054,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0018	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0055,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0019	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0056,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l001a	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0057,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l001b	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0058,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr

	bra	l0004

l001c	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0059,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l001d	bsr	l0005
	lea	l004d+28,a0
	move.l	#l005a,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l001e	bsr	l0005
	lea	l004d+28,a0
	move.l	#l005b,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l001f	bsr	l0005
	lea	l004d+28,a0
	move.l	#l005c,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0020	bsr	l0005
	lea	l004d+28,a0
	move.l	#l005d,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0021	bsr	l0005
	lea	l004d+28,a0
	move.l	#l005e,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0022	bsr	l0005
	lea	l004d+28,a0
	move.l	#l005f,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0023	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0060,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0024	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0061,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0025	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0062,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0026	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0063,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move	#$2300,sr
	rts

l0027	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0064,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0028	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0065,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0029	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0066,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l002a	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0067,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l002b	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0068,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l002c	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0069,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l002d	bsr	l0005
	lea	l004d+28,a0
	move.l	#l006a,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l002e	bsr	l0005
	lea	l004d+28,a0
	move.l	#l006b,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l002f	bsr	l0005
	lea	l004d+28,a0
	move.l	#l006c,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0030	bsr	l0005
	lea	l004d+28,a0
	move.l	#l006d,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0031	bsr	l0005
	lea	l004d+28,a0
	move.l	#l006e,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0032	bsr	l0005
	lea	l004d+28,a0
	move.l	#l006f,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0033	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0070,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0034	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0071,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0035	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0072,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0036	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0073,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0037	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0074,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0038	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0075,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0039	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0076,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l003a	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0077,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l003b	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0078,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l003c	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0079,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l003d	bsr	l0005
	lea	l004d+28,a0
	move.l	#l007a,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l003e	bsr	l0005
	lea	l004d+28,a0
	move.l	#l007b,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l003f	bsr	l0005
	lea	l004d+28,a0
	move.l	#l007c,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0040	bsr	l0005
	lea	l004d+28,a0
	move.l	#l007d,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0041	bsr	l0005
	lea	l004d+28,a0
	move.l	#l007e,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0042	bsr	l0005
	lea	l004d+28,a0
	move.l	#l007f,12(a0)
	move.l	#l0088,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

	sf	l0085
l0043	tst.b	l0085
	beq.s	l0043
	rts

l0044	st	l0085
	rte

l0045	lea	l004d+28,a0
	movea.l	a0,a1
	move.l	a0,d1
	adda.l	#$3dd7,a1
	moveq	#0,d0
l0046	move.b	(a1)+,d0
	beq	l0048

	cmp.w	#1,d0
	bne.s	l0047
	adda.w	#$fe,a0
	bra.s	l0046

l0047	adda.w	d0,a0
	add.l	d1,(a0)
	bra.s	l0046
l0048	rts

l0049	move.l	a1,d5
	move.w	#0,-(sp)
	move.l	a0,-(sp)
	move.w	#$3d,-(sp)		;fopen
	trap	#1
	addq.l	#8,sp
	tst.l	d0
	bmi	l004a

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
l004a	move.l	d7,d1
	rts

l004b	move.l	#0,$ffff8800.w
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

l004c	dc.b	'\VOICE.SET',$00,'C'
;========================================
	data
;========================================
l004d	incbin	replay.prg
;========================================
l004f	incbin	l004f.pi1
;========================================
l0052	incbin	l0052
l0053	incbin	l0053
l0054	incbin	l0054
l0055	incbin	l0055
l0056	incbin	l0056
l0057	incbin	l0057
l0058	incbin	l0058
l0059	incbin	l0059
l005a	incbin	l005a
l005b	incbin	l005b
l005c	incbin	l005c
l005d	incbin	l005d
l005e	incbin	l005e
l005f	incbin	l005f
l0060	incbin	l0060
l0061	incbin	l0061
l0062	incbin	l0062
l0063	incbin	l0063
l0064	incbin	l0064
l0065	incbin	l0065
l0066	incbin	l0066
l0067	incbin	l0067
l0068	incbin	l0068
l0069	incbin	l0069
l006a	incbin	l006a
l006b	incbin	l006b
l006c	incbin	l006c
l006d	incbin	l006d
l006e	incbin	l006e
l006f	incbin	l006f
l0070	incbin	l0070
l0071	incbin	l0071
l0072	incbin	l0072
l0073	incbin	l0073
l0074	incbin	l0074
l0075	incbin	l0075
l0076	incbin	l0076
l0077	incbin	l0077
l0078	incbin	l0078
l0079	incbin	l0079
l007a	incbin	l007a
l007b	incbin	l007b
l007c	incbin	l007c
l007d	incbin	l007d
l007e	incbin	l007e
l007f	incbin	l007f

l0080	dc.b	$00,$00,$37,$30
;========================================
	bss
;========================================
l0081	ds.l	1
l0082	ds.b	8
l0083	ds.w	1
l0084	ds.w	1
l0085	ds.w	1
l0086	ds.b	408
l0087	ds.w	1
l0088	ds.l	1
;========================================
zuend	end
;========================================