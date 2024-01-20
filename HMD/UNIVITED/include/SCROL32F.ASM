********************************
* Scrolling 32x32 - 4 bitpanes *
*          Fullscreen          *
********************************
* Original version by MSD/POV  *
* Fixed by ANGEL/HMD           *
********************************
Scroll_Full:
	move.l	physique(pc),a2
	lea	((160*200)+(230-6))(a2),a2 ; position of scroll

	move.l	scroll_pointer,a4
	lea	font_offsets,a3		; font lookup table
	move.w	char_offset,d7
	moveq	#5*10+1,d1	;	max of carac to analyse!
.seek:
	move.b	(a4),d6
	bpl.s	.find
	lea	scroll_text,a4
	bra.s	.seek
.find:

	lea	font_32,a0
	sub.b	#32,d6		;rid of ASCII
	ext.w	d6
	moveq	#0,d0
	move.b	(a3,d6),d0	;find correct offset
	mulu	#(32*4)*4,d0	; 32 * 4 (4 planes)
	add.w	d0,a0
	move.w	d7,d0
	mulu	#(32*4),d0	; character depth * 4 (32*4)
	add.w	d0,a0
	sub.w	#8*2,a0 ; adjust state of carac

OFF	set	6
	REPT	32
	move.l	(a0)+,d0
	movep.l	d0,OFF(a2)
OFF	set	OFF+230
	ENDR

	addq.w	#1,d7
	and.w	#3,d7
	bne.s	.ok
	addq.w	#1,a4
	tst.b	(a4)
	bpl.s	.ok
	lea	scroll_text,a4
.ok:
	addq.w	#1,a2
	move.w	a2,d0
	and.w	#1,d0
	bne.s	.next
	addq.w	#6,a2
.next:
	dbf	d1,.seek

.next_charac:
	move.l	scroll_pointer,a4
	addq.w	#1,d7
	and.w	#3,d7
	move.w	d7,char_offset
	bne.s	.end
	addq.w	#1,a4
	tst.b	(a4)
	bpl.s	.end
	lea	scroll_text,a4
.end:
	move.l	a4,scroll_pointer
	rts
