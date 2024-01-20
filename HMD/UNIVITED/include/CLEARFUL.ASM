; *************************************************************************
; ***         Clear a screen in four bitplanes without BLITTER          ***
; *************************************************************************
; ***                          Zorro 2/NoExtra                          ***
; *************************************************************************
; * Parameters:	a0.l = address of the ramvideo                            *
; * Erase a screen 320 x 200 in four bitplanes                            *
; *************************************************************************
clear_blit:
	moveq	#0,d1                 ; set 7 + 6 registers to zero
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	moveq	#0,d7
	move.l	d1,a1
	move.l	d1,a2
	move.l	d1,a3
	move.l	d1,a4
	move.l	d1,a5
	move.l	d1,a6
	add.w	  #160*200,a0         ; bottom destination screen
	move.w	#160-8,d0
.loop:
	movem.l	d1-d7/a1-a6,-(a0)
	movem.l	d1-d7/a1-a6,-(a0)
	movem.l	d1-d7/a1-a6,-(a0)
	movem.l	d1-d7/a1-a6,-(a0)
	dbra d0,.loop
	movem.l	d1-d7/a1-a6,-(a0)
	movem.l	d1-d7/a1-a6,-(a0)
	movem.l	d1-d7/a1-a6,-(a0)
	movem.l	d1-d5,-(a0)
	rts
