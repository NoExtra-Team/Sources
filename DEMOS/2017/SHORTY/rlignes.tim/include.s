init_rlignes.ok:
	move #$2700,SR                   ; Interrupts OFF
	clr.b	$fffffa07.w
	clr.b	$fffffa09.w
	move.l	#hbl_rlignes,$120.w
	move.b	#1,$fffffa07.w
	or.b	#1,$fffffa13.w
	stop #$2300                      ; Interrupts ON
	move.l	#Vbl_rlignes,$70.w
	rts

Vbl_rlignes:
	st	Vsync                        ; Synchronisation
  move.l    #Buffer_colors,Pointeurs_colors
  clr.b     $fffffa1b.w
  move.b    #78,$fffffa21.w
	move.b    #8,$fffffa1b.w
	movem.l	d0-d7/a0-a6,-(a7)
	jsr (MUSIC+8)                    ; Play SNDH music
	movem.l	(a7)+,d0-d7/a0-a6
	rte

COULEUR_RLIGNE equ $FFFF8244

hbl_rlignes:
  MOVE.L    A0,-(A7)
  MOVEA.L   Pointeurs_colors,A0
  MOVE.W    2(A0),COULEUR_RLIGNE.w
  CLR.B     $FFFA1B.L 
  MOVE.B    (A0),$FFFA21.L
  MOVE.B    #8,$FFFA1B.L
  ADDQ.L    #6,Pointeurs_colors
  MOVEA.L   (A7)+,A0
  BCLR      #0,$FFFA0F.L
  RTE

Effet_Escalier:
  LEA       Rasters_colors,A0
  CMPI.W    #$12,Pointeur_stairs
  BNE       .re_init 
  MOVE.W    #0,Pointeur_stairs
.re_init:
  MOVE.W    Pointeur_stairs,D0
  MOVE.L    0(A0,D0.W),D1 
  SWAP      D1
  MOVE.L    D1,0(A0,D0.W) 
  MOVE.L    18(A0,D0.W),D1
  SWAP      D1
  MOVE.L    D1,18(A0,D0.W)
  MOVE.L    36(A0,D0.W),D1
  SWAP      D1
  MOVE.L    D1,36(A0,D0.W)
  MOVE.L    54(A0,D0.W),D1
  SWAP      D1
  MOVE.L    D1,54(A0,D0.W)
  MOVE.L    72(A0,D0.W),D1
  SWAP      D1
  MOVE.L    D1,72(A0,D0.W)
  MOVE.L    90(A0,D0.W),D1
  SWAP      D1
  MOVE.L    D1,90(A0,D0.W)
  MOVE.L    108(A0,D0.W),D1 
  SWAP      D1
  MOVE.L    D1,108(A0,D0.W) 
  MOVE.L    126(A0,D0.W),D1 
  SWAP      D1
  MOVE.L    D1,126(A0,D0.W) 
  ADDQ.W    #6,Pointeur_stairs
  RTS 
