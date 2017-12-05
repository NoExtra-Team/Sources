	bra	skip
handle:		dc.w	0
data	dc.b	"E:\0\grille.gif\img\GRILLE.PAK",0
	even

***********************
* SUBROUTINES SECTION *
***********************

f_create:
	move.w	#0,-(sp)
	move.l	a0,-(sp)
	move.w	#$3c,-(sp)
	trap	#1
	add.l	#8,sp
	move.w	d0,handle
	rts

f_write:
	move.l	a0,-(sp)
	move.l	d0,-(sp)
	move.w	handle,-(sp)
	move.w	#$40,-(sp)
	trap	#1
	add.l	#12,sp
	rts

f_close:
	move.w	handle,-(sp)
	move.w	#$3e,-(sp)
	trap	#1
	addq.l	#4,sp
	rts

skip
;create new file
	lea	data,a0
	bsr	f_create
	move.l	#fin-debut,d0
	lea	debut,a0
	bsr	f_write
	bsr	f_close

	clr.w	-(sp)                      ; Pterm()
	trap	#1                         ; EXIT program

debut:

	incbin	"1.IMG"
	incbin	"2.IMG"
	incbin	"3.IMG"
	incbin	"4.IMG"
	incbin	"5.IMG"
	incbin	"6.IMG"
	incbin	"7.IMG"
	incbin	"8.IMG"

	even

fin:
