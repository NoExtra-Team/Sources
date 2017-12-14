init_raster.ok:
	move #$2700,SR                   ; Interrupts OFF
	clr.b	$fffffa07.w
	clr.b	$fffffa09.w
	move.l	#hbl_raster,$120.w
	move.b	#1,$fffffa07.w
	or.b	#1,$fffffa13.w
	stop #$2300                      ; Interrupts ON
	move.l	#Vbl_raster,$70.w
	rts

Vbl_raster:
	st	Vsync                        ; Synchronisation
	clr.b	$fffffa1b.w	
	move.b	#1,$fffffa21.w
	move.b	#8,$fffffa1b.w
	move.l	#bufferRas,the_col
	movem.l	d0-d7/a0-a6,-(a7)
	jsr (MUSIC+8)                    ; Play SNDH music
	movem.l	(a7)+,d0-d7/a0-a6
	rte

COULEUR_RASTER equ $FFFF8244

hbl_raster:
	move.l	a4,-(sp)
	move.l	the_col,a4
	move	(a4)+,COULEUR_RASTER.w
	move.l	a4,the_col
	move.l	(sp)+,a4
	bclr	#0,$fffffa0f.w
	rte

raster:
	lea	bufferRas,a0	;clear old raster wave-forms
	rept	25
	clr.l	(A0)+
	clr.l	(A0)+
	clr.l	(A0)+
	clr.l	(A0)+
	endr
	
	lea	wave,a1	;address of the sine table
	adda	wave_offset,a1	;by simply adding a value to it.
	
	moveq	#5-1,d5		;amount of bars

get_bar:
	lea	bufferRas,a2
	adda	(a1),a2		;so add that to the buffer, and
				;this gives the address at which
				;we display the next bar at...!!

	move.l	ptr_red_bar,a0	;address of the bars
	rept	14-5
	move.l	(a0)+,(a2)+	;copy bar to buffer
	endr

	lea	12(a1),a1
	
	dbf	d5,get_bar

	addq	#2,wave_offset	;increment offset into sine-table
	cmp	#278,wave_offset
	ble.s	bye
	clr	wave_offset

bye:
	rts
