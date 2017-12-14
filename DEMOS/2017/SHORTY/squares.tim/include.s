init_squares.ok:
	move #$2700,SR                   ; Interrupts OFF
	sf	$fffffa21.w                  ; Timer B data (number of scanlines to next interrupt)
	sf	$fffffa1b.w                  ; Timer B control (event mode (HBL))
	move.l	#hbl_squares,$120.w
	bset	#0,$fffffa07.w             ; Timer B vector
	bset	#0,$fffffa13.w             ; Timer B on
	stop #$2300                      ; Interrupts ON
	move.l	#Vbl_squares,$70.w
	rts

Vbl_squares:
	st	Vsync                        ; Synchronisation
	clr.b     $fffffa1b.w
	move.l    #hbl_squares,$120.w 
	move.b    #70,$fffffa21.w         ; at the position
	move.b    #8,$fffffa1b.w         ; launch hbl
	movem.l	d0-d7/a0-a6,-(a7)
	jsr (MUSIC+8)                    ; Play SNDH music
	movem.l	(a7)+,d0-d7/a0-a6
	rte

COULEUR_SQUARE equ $FFFF8240

hbl_squares:
      CLR.B     $FFFFFA1B.W 
      MOVE.B    #19,$FFFFFA21.W
      MOVE.L    #hbl01,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      MOVE      #$2700,SR 
      MOVEM.L   A0/D0,-(A7) 
      LEA       $FFFFFA21.W,A0
      MOVE.B    (A0),D0 
.wait:CMP.B     (A0),D0 
      BEQ.S     .wait 
      dcb.w	6,$4E71
      move.l	a1,-(a7)
      move.l	a2,-(a7)
      move.l    #PAL_ETAGE7,a1
      lea       COULEUR_SQUARE.w,a2
      move.w    (a1)+,2(a2)
      move.w    (a1)+,4(a2)
      move.w    (a1)+,6(a2)
      move.l	(a7)+,a2
      move.l	(a7)+,a1
      MOVE.B    (A0),D0 
.att:CMP.B     (A0),D0 
      BEQ.S     .att 
      MOVEM.L   (A7)+,A0/D0 
      MOVE      #$2300,SR 
      BCLR      #0,$FFFFFA0F.W
      RTE 
   
hbl01:CLR.B     $FFFFFA1B.W 
      MOVE.B    #20,$FFFFFA21.W
      MOVE.L    #hbl02,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      MOVE      #$2700,SR 
      MOVEM.L   A0/D0,-(A7) 
      LEA       $FFFFFA21.W,A0
      MOVE.B    (A0),D0 
.wait:CMP.B     (A0),D0 
      BEQ.S     .wait 
      dcb.w	6,$4E71
      move.l	a1,-(a7)
      move.l	a2,-(a7)
      move.l    #PAL_ETAGE8,a1
      lea       COULEUR_SQUARE.w,a2
      move.w    (a1)+,2(a2)
      move.w    (a1)+,4(a2)
      move.w    (a1)+,6(a2)
      move.l	(a7)+,a2
      move.l	(a7)+,a1
      MOVE.B    (A0),D0 
.att:CMP.B     (A0),D0 
      BEQ.S     .att 
      MOVEM.L   (A7)+,A0/D0 
      MOVE      #$2300,SR 
      BCLR      #0,$FFFFFA0F.W
      RTE 
      
hbl02:CLR.B     $FFFFFA1B.W 
      MOVE.B    #20-2,$FFFFFA21.W
      MOVE.L    #hblfin,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      MOVE      #$2700,SR 
      MOVEM.L   A0/D0,-(A7) 
      LEA       $FFFFFA21.W,A0
      MOVE.B    (A0),D0 
.wait:CMP.B     (A0),D0 
      BEQ.S     .wait 
      dcb.w	6,$4E71
      move.l	a1,-(a7)
      move.l	a2,-(a7)
      move.l    #PAL_ETAGE9,a1
      lea       COULEUR_SQUARE.w,a2
      move.w    (a1)+,2(a2)
      move.w    (a1)+,4(a2)
      move.w    (a1)+,6(a2)
      move.l	(a7)+,a2
      move.l	(a7)+,a1
      MOVE.B    (A0),D0 
.att:CMP.B     (A0),D0 
      BEQ.S     .att 
      MOVEM.L   (A7)+,A0/D0 
      MOVE      #$2300,SR 
      BCLR      #0,$FFFFFA0F.W
      RTE 
      
hblfin:CLR.B     $FFFFFA1B.W 
      BCLR      #0,$FFFFFA0F.W
      RTE

PAL_ETAGE7:
	dc.w	$01A4
	dc.w	$09BD
	dc.w	$01A4
PAL_ETAGE8:
	dc.w	$031B
	dc.w	$0B9C
	dc.w	$0CA5
PAL_ETAGE9:
	dc.w	$0403
	dc.w	$0C8B
	dc.w	$0D14
	even

init_play_squares:
	move.l	#cubes,ptrcube
	rts

ptrcube:
	ds.l	1

PLOT:
	mulu	#160,d1
	add	d1,a1
	moveq	#15,d1		;shifting
	and	d0,d1
	eor	d1,d0
	lsr	#1,d0
	add	d0,a1
	moveq	#16-1,d0
.aff
	move	(a0)+,d2
	swap	d2
	clr	d2
	lsr.l	d1,d2
	move	(a0)+,d3
	swap	d3
	clr	d3
	lsr.l	d1,d3
	move.l	d2,d4
	or.l	d3,d4
	not.l	d4
	swap	d2
	swap	d3
	swap	d4
	and	d4,(a1)
	or	d2,(a1)
	and	d4,2(a1)
	or	d3,2(a1)
	swap	d2
	swap	d3
	swap	d4
	and	d4,8(a1)
	or	d2,8(a1)
	and	d4,8+2(a1)
	or	d3,8+2(a1)
	lea	160(a1),a1
	dbra	d0,.aff
	rts

DISP:	MACRO
	MOVE	#\1,D0
	MOVE	#\2,D1
	move.l	ptrcube,a0	;source
	move.l	physique,a1	;dest
	lea	160*71+8*7(a1),a1
	BSR	PLOT
	MOVE	#\1,D0
	MOVE	#\2,D1
	move.l	ptrcube,a0	;source
	move.l	physique,a1	;dest
	lea	160*89+8*7(a1),a1
	BSR	PLOT
	MOVE	#\1,D0
	MOVE	#\2,D1
	move.l	ptrcube,a0	;source
	move.l	physique,a1	;dest
	lea	160*106+8*7(a1),a1
	BSR	PLOT
	ENDM

play_squares:
  move.l	physique,a0	             ; Clear screen.
	move.w	#54-1,d3
	bsr	clear_square

	move.l	physique,a1	;dest
coord_x set 0
	rept 6
	DISP	coord_x,3
coord_x set coord_x+16
	endr
	add.l	#64,ptrcube
	cmp.l	#fincubes,ptrcube
	blo.s	.ok
	move.l	#cubes,ptrcube
.ok
	rts

clear_square:
  moveq.l	#$0,d0
  add.l	#160*73+8*7,a0
.clear:
N set 0
 rept	6
  move.l	d0,N(a0)
N set N+8
 endr
  add.w	#160,a0
  dbra	d3,.clear
  rts
