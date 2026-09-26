; *************************************************************************
; ***                Damier tricky mover in three bitplanes             ***
; *************************************************************************
; ***                          Zorro 2/NoExtra                          ***
; *************************************************************************
; Parameters                                                              *
; ------------------------------------------------------------------------*
***************************************************************************
_BASE_REFLET     equ 160*135 ; base écran                                 *
_NB_LIGNE_REFLET equ 135-1   ; nombre de lignes                           *
***************************************************************************
display_BARRES:
  movea.l	#Damier_img,a0 
  movea.l	physique,a1
  movea.l	physique+4,a2
  move.l	#290,d0
.loop:
  movem.l   (a0)+,a3-a6/d1-d7 
  movem.l   a3-a6/d1-d7,(a1)
  movem.l   a3-a6/d1-d7,(a2)
  adda.l    #45-1,a1 
  adda.l    #45-1,a2 
  dbf       d0,.loop
.reflect:
	move.l physique(pc),a2
	add.l #_BASE_REFLET,a2
	move.l physique(pc),a1
	add.l #_BASE_REFLET,a1
	move.l #_NB_LIGNE_REFLET,d0
	bsr	.ref
	move.l physique+4(pc),a2
	add.l #_BASE_REFLET,a2
	move.l physique+4(pc),a1
	add.l #_BASE_REFLET,a1
	move.l #_NB_LIGNE_REFLET,d0
.ref:
	move.l a2,a0
	sub.l #160,a2
 rept 40
	move.l (a0)+,(a1)+
 endr
	dbra d0,.ref 
	rts

init_RotatePalette:
  movem.l	(a0)+,d0-d3 
  movem.l	d0-d3,(a1)
  movem.l	d0-d3,(a2)
  lea	paletteDamier,a0
  lea	ptr_paletteDamier,a1
  moveq	#8-1,d7 
.rotate:
  move.w	0(a0),d0 
  move.w	2(a0),(a0)
  movem.l	4(a0),d1-d3 
  movem.l	d1-d3,2(a0) 
  move.w	d0,14(a0) 
  movem.l	(a0),d1-d4
  movem.l	d1-d4,(a1)
  adda.l	#16,a1 
  dbf	d7,.rotate
  rts

play_RotatePalette:
  move.l	a6,-(sp)
  movea.l	paletteDamier_DISPLAY,a6
  move.l	(a6)+,$ff8250.l 
  move.l	(a6)+,$ff8254.l 
  move.l	(a6)+,$ff8258.l 
  move.l	(a6)+,$ff825c.l 
  cmpa.l	#END_ptr_paletteDamier,a6 
  bne.s	.next 
  lea	ptr_paletteDamier,a6
.next:
  move.l	a6,paletteDamier_DISPLAY
  movea.l	(sp)+,a6
  rts

paletteDamier:
  dcb.w	4,$0145
  dcb.w	4,$0024
paletteDamier_DISPLAY:
  dc.l	ptr_paletteDamier 
ptr_paletteDamier:
  ds.b	16*8 
END_ptr_paletteDamier:
	even