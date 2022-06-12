; *************************************************************************
; ***                    SCROLL 64x32 - 4 BITPLANES                     ***
; *************************************************************************
; ***                             MSD/POV                               ***
; *************************************************************************
DEPTH	equ	32
scroll64x32:
	movea.l physique,a1
	lea	160*((200-64)/2)(a1),a1
	lea	font_offsets,a2		;font lookup table
	lea	font,a3			;font itself
	move.l	scroll_pointer,a4	;pointer into text
	move.l	a4,a5

	moveq	#40,d5			;40 words across screen
	move.w	char_offset,d6		;char offset is a toggle
					;for bytes/words
	moveq	#0,d4
next_char:
	move.b	(a5),d7			;get a letter
	sub.b	#32,d7			;rid of ASCII
	ext.w	d7

	moveq	#0,d0
	move.l	a3,a0
	move.b	(a2,d7),d0		;find correct offset
	mulu	#8*DEPTH*4,d0	;8 bytes wide * DEPTH
	add.l	d0,a0		;add to font start
	move.w	d6,d0		;char offset
	mulu	#DEPTH*4,d0	;*DEPTH
	add.l	d0,a0		;we now point to character in A0

.column:
OFF	set	0
	REPT	DEPTH
	move.l	(a0)+,d3
	movep.l	d3,OFF(a1)
	movep.l	d3,160+OFF(a1)
OFF	set	OFF+2*160		;go down 2 lines
	ENDR

	subq.w	#1,d5		;column value
	beq.s	.finish		;last column then finish

	addq.w	#1,a1		;lower byte of word
	tst.w	d4
	beq.s	.skip		;if D4=0 then do next byte
	add.w	#6,a1		;else goto next word on screen
.skip:
	not.w	d4
	addq.w	#1,d6		;character offset
	and.w	#7,d6
	bne	.column

	addq.w	#1,a5		;scroll pointer
	tst.b	(a5)		;is end of text?
	bpl	next_char	;NO!
	bra   end_big_scroll	; get out the scrolltext!
*	lea	scroll_text,a5	;do reset scrolline
*	bra	next_char

.finish:
	addq.w	#1,char_offset
	and.w	#7,char_offset
	bne.s	.end
	addq.w	#1,a4
	tst.b	(a4)		;is scroll text end?
	bpl.s	.end		;NO!
	bra   end_big_scroll	; get out the scrolltext!
*	lea	scroll_text,a4	;reset scroll text
.end:
	move.l	a4,scroll_pointer
	rts
char_offset:
	ds.w	1
	even