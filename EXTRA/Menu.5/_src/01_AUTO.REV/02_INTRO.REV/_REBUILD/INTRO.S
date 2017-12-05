;================================================================================
;		opt	x+
;================================================================================
		section	text
;================================================================================
begin
;--------------------------------------------------------------------------------
p_tbase
;================================================================================
supexec		pea	intro(pc)
		move.w	#$26,-(sp)		;supexec
		trap	#14
		addq.l	#6,sp
;--------------------------------------------------------------------------------
load		move.l	#prg_n_1,f_name
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

fread		pea	buffer(pc)
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

prg_n_1		dc.b	"main.prg"
		dc.b	0
		even
;================================================================================
handle		ds.w	1
f_size		ds.l	1
;================================================================================
relog		move.l	f_size(pc),d2
		lea	buffer(pc),a4
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
buffer
;--------------------------------------------------------------------------------
intro		pea	pic+2
		move.w	#6,-(sp)		;setpallete
		trap	#14
		addq.l	#6,sp

		dc.w	$a00a

		move.w	#2,-(sp)		;physbase
		trap	#14
		addq.l	#2,sp

		movea.l	d0,a1
		add.l	d0,l0023

		lea	pic+34,a0
		move.w	#$1f3f,d1
l0000		move.l	(a0)+,(a1)+
		dbf	d1,l0000

		bsr	l0017

		move.l	$70.w,l0029
		move.l	#l0016,$70.w

		bsr	l0003

		move.l	l0029,$70.w

		bsr	l001b

		move.w	#$ff,-(sp)
		move.w	#6,-(sp)		;crawio
		trap	#1
		addq.w	#4,sp

		rts
;================================================================================
l0003		sf	replay+$1c+98
		sf	l0027
		lea	replay+$1c,a0
		move.l	#l0021,12(a0)
		move.l	#l0022,16(a0)
		jsr	4(a0)

		move.w	#$2300,sr

l0004		bsr	l0005
		bsr	l0014
		bsr	l0012

		tst.b	l0027
		beq.s	l0004

		move.w	#$2500,sr

		lea	replay+$1c,a5
		jsr	8(a5)
		rts

l0005		lea	l0025,a5
		move.l	d0,d6
		swap	d6
		move.b	0(a0,d6.w),d6
		andi.w	#$7f,d6
		lsr.w	#1,d6
		cmp.w	(a5),d6
		bge.s	l0006

		subq.w	#2,(a5)
		bge.s	l0007

		moveq	#0,d6
l0006		move.w	d6,(a5)
l0007		addq.w	#2,a5
		move.l	d1,d6
		swap	d6
		move.b	0(a1,d6.w),d6
		andi.w	#$7f,d6
		lsr.w	#1,d6
		cmp.w	(a5),d6
		bge.s	l0008

		subq.w	#2,(a5)
		bge.s	l0009

		moveq	#0,d6
l0008		move.w	d6,(a5)
l0009		addq.w	#2,a5
		move.l	d2,d6
		swap	d6
		move.b	0(a2,d6.w),d6
		andi.w	#$7f,d6
		lsr.w	#1,d6
		cmp.w	(a5),d6
		bge.s	l000a

		subq.w	#2,(a5)
		bge.s	l000b

		moveq	#0,d6
l000a		move.w	d6,(a5)
l000b		addq.w	#2,a5
		move.l	d3,d6
		swap	d6
		move.b	0(a3,d6.w),d6
		andi.w	#$7f,d6
		lsr.w	#1,d6
		cmp.w	(a5),d6
		bge.s	l000c

		subq.w	#2,(a5)
		bge.s	l000d

		moveq	#0,d6
l000c		move.w	d6,(a5)
l000d		addq.w	#2,a5
		move.w	#$30,l0026
l000e		movea.l	l0023,a6
		adda.w	l0026,a6
		move.w	#$40,d6
		move.w	-(a5),d7
		move.l	a5,l0024
		lea	pic+34+16536,a5
		adda.w	l0026,a5
		sub.w	d7,d6
		beq.s	l0010

		subq.w	#1,d6
		lea	1600(a5),a5
l000f		move.l	(a5),(a6)
		move.l	4(a5),4(a6)
		adda.l	#$a0,a6
		dbf	d6,l000f

		subq.w	#1,d7
		lea	-1600(a5),a5
l0010		addi.w	#$a,d7
l0011		move.l	(a5),(a6)
		move.l	4(a5),4(a6)
		adda.l	#$a0,a6
		adda.l	#$a0,a5
		dbf	d7,l0011

		movea.l	l0024,a5
		subi.w	#$10,l0026
		bge.s	l000e
		rts
;================================================================================
l0012		move.b	replay+$1c+98,d6
		andi.b	#$7f,d6
		beq	l0013

		cmp.b	#$39,d6		;#'9'
		bne.s	l0013

		st	l0027
		rts

l0013		rts
;================================================================================
l0014		sf	l0028
l0015		tst.b	l0028
		beq.s	l0015
		rts

l0016		st	l0028
		rte

l0017		lea	replay+$1c,a0
		movea.l	a0,a1
		move.l	a0,d1
		adda.l	#$3dd7,a1
		moveq	#0,d0
l0018		move.b	(a1)+,d0
		beq	l001a

		cmp.w	#1,d0
		bne.s	l0019

		adda.w	#$fe,a0
		bra.s	l0018

l0019		adda.w	d0,a0
		add.l	d1,(a0)

		bra.s	l0018
l001a		rts

l001b		move.l	#0,$ffff8800.w
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
;================================================================================
		data
;================================================================================
replay		incbin	replay.prg
pic		incbin	pic.pi1
l0021		incbin	l0021
l0022		incbin	l0022
l0023		dc.b	$00,$00,$40,$98
;================================================================================
		bss
;================================================================================
l0024		ds.l	1
l0025		ds.b	8
l0026		ds.w	1
l0027		ds.w	1
l0028		ds.w	1
l0029		ds.b	404
l002a		ds.w	1
;================================================================================
zuend		end
;================================================================================