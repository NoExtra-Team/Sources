Launch_scrollfx:
* Legalise palette
	lea	blackingreg,a1               ; Fading palette
	jsr	fade_in
	lea	blackingreg,a0               ; Restore palette
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d7               ;
	movem.l	d0-d7,(a1)               ;
* Bug found by greg fixed -> 09/05/2023
	clr.b   $fffffa1b.w              ; Disable timer B
	lea	Save_rest,a0                 ; Restore adresses parameters
	move.l (a0)+,$068.w              ; HBL
	move.l (a0)+,$070.w              ; VBL
* Clear main screen in 320x200
	move.l	physique(pc),a0          ; screen destination
	jsr	clear_blit
* Display top gfx from Dieu
	move.l	#hmd_picture,a0          ; image source
	move.l	physique(pc),a1          ; screen destination
	move.w	#0,d0                    ; pos X in the picture
	move.w	#0,d1                    ; pos Y in the picture
	move.w	#320,d2                  ; WIDTH of sprite
	move.w	#86,d3                   ; HEIGHT of sprite
	move.w	#4,d4                    ; Number of plane
	jsr	DoBLiTTER__Copy_Buffer       ; put a sprite 4 bitplanes
	move.l	#hmd_picture,a0          ; image source
	move.l	physique+4(pc),a1        ; screen destination
	move.w	#0,d0                    ; pos X in the picture
	move.w	#0,d1                    ; pos Y in the picture
	move.w	#320,d2                  ; WIDTH of sprite
	move.w	#86,d3                   ; HEIGHT of sprite
	move.w	#4,d4                    ; Number of plane
	jsr	DoBLiTTER__Copy_Buffer       ; put a sprite 4 bitplanes

* put back gfx for small scrolltext
  move.l	#back_picture,a0         ; source
	movea.l	physique(pc),a1          ; destination
	add.l	#160*248+8*9-2,a1          ; position in
	jsr	lz4_depack                   ; Depack!
  move.l	#back_picture,a0         ; source
	movea.l	physique+4(pc),a1        ; destination
	add.l	#160*248+8*9-2,a1          ; position in
	jsr	lz4_depack                   ; Depack!

* put Jade spectrum in the background
  move.l	#spectrum_picture,a0     ; source
	movea.l	physique(pc),a1          ; destination
	add.l	#160*87,a1                 ; position in
	jsr	lz4_depack                   ; Depack!
  move.l	#spectrum_picture,a0     ; source
	movea.l	physique+4(pc),a1        ; destination
	add.l	#160*87,a1                 ; position in
	jsr	lz4_depack                   ; Depack!
 
* Initialisations from code...
	jsr	Setup_stars                  ; Inits
	jsr	Inits_Vagues
	jsr	Init_mscroll
	rts

blackingreg:
	dcb.w	16,$0112
	even
