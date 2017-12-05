;================================================================================
;		opt	x+
;================================================================================
		text
;================================================================================
begin
;================================================================================
p_tbase		move.l	sp,save_sp
		move.l	4(sp),save4sp

		clr.l	-(sp)
		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp
		move.l	d0,savessp

		move.b	#$e,$484.w

		dc.w	$a00a

	move.w	#0,-(sp)
	move.l	#-1,-(sp)
	move.l	#-1,-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea	12(sp),sp

		move.w	#$22,-(sp)		;kbdvbase
		trap	#14
		addq.l	#2,sp

		movea.l	d0,a5
		lea	24(a5),a5
		move.l	(a5),l0091
		move.l	#l0031,(a5)

		pea	l0088(pc)
		clr.w	-(sp)
		move.w	#$19,-(sp)		;ikbdws
		trap	#14
		addq.l	#8,sp

		moveq	#1,d0
		jsr	music
		move.l	#music+4,$4d6.w

		pea	maingfx+2(pc)
		move.w	#6,-(sp)		;setpallete
		trap	#14
		addq.l	#6,sp
;================================================================================
		pea	present(pc)
		move.w	#9,-(sp)		;cconws
		trap	#1
		addq.l	#6,sp
;--------------------------------------------------------------------------------
sel_mus		move.w	#7,-(sp)		;crawcin
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

space		cmp.b	#$39,d0		;#'9'
		bne.s	sel_mus
;================================================================================
		move.w	#2,-(sp)		;physbase
		trap	#14
		addq.l	#2,sp

		move.l	d0,l0090
		movea.l	l0090,a0
		move.w	#$1f3f,d1
l0002		clr.l	(a0)+
		dbf	d1,l0002

		movea.l	l0090,a0
		lea	maingfx(pc),a1
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
		beq	escape

		bra	l0004
;================================================================================
escape		bsr	exit

xxx		dc.w	$a009

		move.l	savessp(pc),-(sp)
		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp

		clr.w	-(sp)			;pterm
		trap	#1

save_sp		ds.l	1
save4sp		ds.l	1
savessp		ds.l	1
;================================================================================
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
;================================================================================
exit0		pea	l0089(pc)
		move.w	#1,-(sp)
		move.w	#$19,-(sp)		;ikbdws
		trap	#14
		addq.l	#8,sp
		move.l	l0091,(a5)
		move.l	#0,$4d6.w
		bsr	l001e
		bsr	l004d
		rts
;--------------------------------------------------------------------------------
exit1		addq.l	#4,sp

		move.l	savessp(pc),-(sp)
		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp

		move.l	save_sp(pc),sp
		move.l	save4sp(pc),4(sp)
;--------------------------------------------------------------------------------
		bsr.s	ld_file
		tst.b	flagerr
		bne.s	pterm0
;--------------------------------------------------------------------------------
reloc		jmp	relog(pc)
jump		jmp	(sp)
;================================================================================
pterm0		clr.w	-(sp)			;pterm
		trap	#1
;================================================================================
ld_file
;--------------------------------------------------------------------------------
fopen		move.w	#2,-(sp)
		move.l	f_name(pc),-(sp)
		move.w	#$3d,-(sp)		;fopen
		trap	#1
		addq.l	#8,sp
		tst.l	d0
		bmi.s	f_error

		move.w	d0,handle

fread		pea	buffer
		move.l	#$fffff,-(sp)
		move.w	handle(pc),-(sp)
		move.w	#$3f,-(sp)		;fread
		trap	#1
		lea	12(sp),sp
		tst.l	d0
		bmi.s	f_error

		move.l	d0,f_size

fclose		move.w	handle(pc),-(sp)
		move.w	#$3e,-(sp)		;fclose
		trap	#1
		addq.l	#4,sp
		tst.w	d0
		bmi.s	f_error
		rts
;================================================================================
f_error		st	flagerr
		rts

flagerr		ds.b	1
		even
;================================================================================
f_name		ds.l	1

handle		ds.w	1
f_size		ds.l	1
;================================================================================
relog		move.l	f_size(pc),d2
		lea	buffer,a4
		lea	p_tbase(pc),a5
		move.l	a5,d4
		move.l	2(a4),d3
		add.l	6(a4),d3
		tst.w	$1a(a4)
		bne.s	calc_bp
		lea	$1c(a4),a1
		movea.l	a1,a2
		adda.l	2(a4),a2
		adda.l	6(a4),a2
		adda.l	$e(a4),a2
		clr.l	d1
		move.l	(a2)+,d0
		beq.s	calc_bp
.bcle1		add.l	d4,0(a1,d0.l)
.bcle2		move.b	(a2)+,d1
		beq.s	calc_bp
		add.l	d1,d0
		cmp.b	#1,d1
		bne.s	.bcle1
		addi.l	#$fd,d0
		bra.s	.bcle2
calc_bp		movea.l	4(sp),a0
		move.l	2(a4),$c(a0)
		add.l	$c(a0),d4
		move.l	d4,$10(a0)
		move.l	6(a4),$14(a0)
		add.l	$14(a0),d4
		move.l	d4,$18(a0)
		move.l	$a(a4),$1c(a0)
		movea.l	$18(a0),a2
		movea.l	a2,a3
		adda.l	$1c(a0),a3
		movea.l	a4,a0
		adda.l	d2,a0
		cmpa.l	a3,a0
		ble.s	.lbl1
		movea.l	a0,a3
.lbl1		moveq	#(transf-transd)/2-1,d0
		lea	transf(pc),a0
		move.l	a5,-(sp)
.bcle1		move.w	-(a0),-(sp)
		dbf	d0,.bcle1
		lea	$1c(a4),a4
		jmp	jump(pc)
;--------------------------------------------------------------------------------
transd
.bcle2		move.l	(a4)+,(a5)+
		subq.l	#4,d3
		bpl.s	.bcle2
.bcle3		clr.l	(a2)+
		cmpa.l	a2,a3
		bgt.s	.bcle3
		lea	$12(sp),sp
		rts
transf
;================================================================================
ld_chess	bsr	exit0
		move.l	#chess,f_name
		jmp	exit1(pc)
;========================================
ld_moon		bsr	exit0
		move.l	#moon,f_name
		jmp	exit1(pc)
;========================================
ld_twist	bsr	exit0
		move.l	#twist,f_name
		jmp	exit1(pc)
;========================================
ld_human	bsr	exit0
		move.l	#human,f_name
		jmp	exit1(pc)
;========================================
ld_wind		bsr	exit0
		move.l	#wind,f_name
		jmp	exit1(pc)
;========================================
ld_qcm		bsr	exit0
		move.l	#qcm,f_name
		jmp	exit1(pc)
;========================================
ld_spectral	bsr	exit0
		move.l	#spectral,f_name
		jmp	exit1(pc)
;========================================
ld_wave		bsr	exit0
		move.l	#wave,f_name
		jmp	exit1(pc)
;========================================
ld_cyber	bsr	exit0
		move.l	#cyber,f_name
		jmp	exit1(pc)
;========================================
ld_greet	bsr	exit0
		move.l	#greet,f_name
		jmp	exit1(pc)
;========================================
ld_intro	bsr	exit0
		move.l	#intro,f_name
		jmp	exit1(pc)
;========================================
ld_strix512	bsr	exit0
		move.l	#strix512,f_name
		jmp	exit1(pc)
;========================================
ld_distort	bsr	exit0
		move.l	#distort,f_name
		jmp	exit1(pc)
;========================================
ld_the_end	bsr	exit0
		move.l	#the_end,f_name
		jmp	exit1(pc)
;========================================
ld_love		bsr	exit0
		move.l	#love,f_name
		jmp	exit1(pc)
;========================================
ld_bubble	bsr	exit0
		move.l	#bubble,f_name
		jmp	exit1(pc)
;========================================
ld_big_text	bsr	exit0
		move.l	#big_text,f_name
		jmp	exit1(pc)
;================================================================================
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
;================================================================================
exit		pea	l0089(pc)
		move.w	#1,-(sp)
		move.w	#$19,-(sp)		;ikbdws
		trap	#14
		addq.l	#8,sp
		move.l	l0091,(a5)
		move.l	#0,$4d6.w
		bsr	l001e
		bsr	l004e
		rts
;================================================================================
key_f1		moveq	#0,d0
		jsr	music
		move.l	#music+4,$4d6.w
		bra	space
key_f2		moveq	#1,d0
		jsr	music
		move.l	#music+4,$4d6.w
		bra	space
key_f3		moveq	#2,d0
		jsr	music
		move.l	#music+4,$4d6.w
		bra	space
key_f4		moveq	#3,d0
		jsr	music
		move.l	#music+4,$4d6.w
		bra	space
;================================================================================
sample1		incbin	sample1
sample2		incbin	sample2
sample3		incbin	sample3

replay		incbin	replay_h.prg

present		dc.b	$1b,'E'
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

chess		dc.b	'CHESS.PRG',0
		even
moon		dc.b	'MOON.PRG',0
		even
twist		dc.b	'TWIST.PRG',0
		even
human		dc.b	'HUMAN.PRG',0
		even
wind		dc.b	'WIND.PRG',0
		even
qcm		dc.b	'QCM.PRG',0
		even
spectral	dc.b	'SPECTRAL.PRG',0
		even
wave		dc.b	'WAVE.PRG',0
		even
cyber		dc.b	'CYBER.PRG',0
		even
greet		dc.b	'GREET.PRG',0
		even
intro		dc.b	'INTRO.PRG',0
		even
strix512	dc.b	'STRIX512.PRG',0
		even
distort		dc.b	'DISTORT.PRG',0
		even
the_end		dc.b	'THE_END.PRG',0
		even
bubble		dc.b	'BUBBLE.PRG',0
		even
love		dc.b	'LOVE.PRG',0
		even
big_text	dc.b	'BIG_TEXT.PRG',0
		even
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
;================================================================================
buffer
;================================================================================
zuend		end
;================================================================================