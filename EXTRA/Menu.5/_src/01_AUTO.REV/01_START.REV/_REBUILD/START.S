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

prg_n_1		dc.b	"intro.prg"
		dc.b	0
		even
;================================================================================
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
intro		dc.w	$a00a

		pea	startgfx+2
		move.w	#6,-(sp)		;setpallete
		trap	#14
		addq.l	#6,sp

		move.w	#2,-(sp)		;physbase
		trap	#14
		addq.l	#2,sp

		movea.l	d0,a0
		lea	startgfx+34,a1
		move.w	#$1f3f,d1
l0007		move.l	(a1)+,(a0)+
		dbf	d1,l0007

		move.l	#sample,replay+$1c+2
		move.l	#$27d8,replay+$1c+2+4
		move.l	#2,replay+$1c+2+4+4
		jsr	replay+$1c

		rts
;================================================================================
startgfx	incbin	start.pi1

sample		incbin	sample

replay		incbin	replay_h.prg
;================================================================================
buffer
;================================================================================
zuend		end
;================================================================================