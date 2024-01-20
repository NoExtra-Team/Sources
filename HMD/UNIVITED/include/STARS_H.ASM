********************************
* Horzontal Stars - 1 bitpane  *
********************************
* Original version by MSD/POV  *
* Fixed by ANGEL/HMD           *
*------------------------------*
* Parameters                   *
*------------------------------*
NO_STARS equ 50-7              *
PLAN equ 6-0                   *
WIDTH_STAR equ 100             *
********************************
Display_Stars:
	lea	hmd_picture,a5 ; picture source
	move.l	physique(pc),a2
	move.l	physique+4(pc),a3
	addq.w	#PLAN,a2
	addq.w	#PLAN,a5
	addq.w	#PLAN,a3

	moveq	#0,d7		; Now used for fast clearing star.
	lea	star_table,a0
	move.w	#NO_STARS-1,d6	;number of stars
.loop:
	bsr.s	do_stars
	addq.w	#8,a0
	dbf	d6,.loop
	rts

do_stars:
	move.w	2(a0),d0	;word offset
	moveq	#0,d1		; Make sure high word is clear for later.
	move.w	4(a0),d1	;bit offset

	move.l	a2,a1		;screen_base
	add.w	(a0),a1		;Line offset.
	add.w	d0,a1		;add word offset

	move.l	a5,a4		;pic+34
	add.w	(a0),a4		;line offset
	add.w	d0,a4		;add word offset
	move.w	(a4),(a1)	;clear old star by putting pic back

	move.w	2(a0),d0	;word offset
	moveq	#0,d1		; Make sure high word is clear for later.
	move.w	4(a0),d1	;bit offset

	move.l	a3,a6		;screen_base + 4
	add.w	(a0),a6		;Line offset.
	add.w	d0,a6		;add word offset

	move.l	a5,a4		;pic+34
	add.w	(a0),a4		;line offset
	add.w	d0,a4		;add word offset
	move.w	(a4),(a6)	;clear old star by putting pic back
;calc new pos
	move.w	6(a0),d2	;speed of shift
	ror.l	d2,d1
	tst.w	d1
	bne.s	no_word
	swap	d1
;word overlap so add to next word
	addq.w	#8,d0		;goto next word
	cmp.w	#160,d0		;is word over screen width?
	blt.s	.no		;NO!!

	move.w	d7,2(a0)	; Clear word offset.
	move.w	d1,4(a0)	;save star shift for next VBL
	rts

.no:
	move.w	d0,2(a0)
	or.w	d1,8(a1)	;or star on so pic stays intact
	or.w	d1,8(a6)	;or star on so pic stays intact
	move.w	d1,4(a0)
	rts

no_word:
	or.w	d1,(a1)		;or star on so pic stays intact
	or.w	d1,(a6)		;or star on so pic stays intact
	move.w	d1,4(a0)
	rts

Setup_stars:
	clr.w	d5
	lea	star_table,a6
	move.w	#NO_STARS-1,d7		;number of stars
.loop
	move.w	d5,(a6)+	; Store line offset.
	add.w	#(160*(WIDTH_STAR/NO_STARS)),d5	; Next line offset.

	move.w	#$11,-(sp)	;now get a RANDOM number for shifts,speed and line offset
	trap	#14
	addq.w	#2,sp
	and.l	#$7fff,d0

	divu	#160,d0
	swap	d0		; Get number within width of screen.
	and.w	#$f8,d0		; Place on column boundary.
	move.w	d0,(a6)+	;word offset

	move.w	#$11,-(sp)
	trap	#14
	addq.w	#2,sp

	and.w	#15,d0
	move.w	#$8000,d1
	ror.w	d0,d1
	move.w	d1,(a6)+	;pixel shift

	move.w	#$11,-(sp)
	trap	#14
	addq.w	#2,sp

	and.w	#7,d0
	addq.w	#1,d0		;Make sure not stopped!
	move.w	d0,(a6)+	;speed

	dbf	d7,.loop
	rts

star_table:
	REPT	NO_STARS
	ds.w	1	;	line offset for screen
	ds.w	1	;	word off on line
	ds.w	1	;	dot shift
	ds.w	1	;	speed dot moves
	ENDR