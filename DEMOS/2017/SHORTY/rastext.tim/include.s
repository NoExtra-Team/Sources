init_rasterTexte.ok:
	move #$2700,SR                   ; Interrupts OFF
	clr.b	$fffffa07.w
	clr.b	$fffffa09.w
	move.l	#hbl_rasterTexte,$120.w
	move.b	#1,$fffffa07.w
	or.b	#1,$fffffa13.w
	stop #$2300                      ; Interrupts ON
	move.l	#Vbl_rasterTexte,$70.w
	rts

Vbl_rasterTexte:
	st	Vsync                        ; Synchronisation
	CLR.B     $FFFFFA1B.W 
	MOVE.L    #hbl_rasterTexte,$120.W 
	MOVE.B    #60,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W
	MOVE.W    #77,COMPTEUR_HBL
	MOVE.L    #BUFFER_COLOR,PTR_BUFFER_COLOR
	BSR	PRASTER
	movem.l	d0-d7/a0-a6,-(a7)
	jsr (MUSIC+8)                    ; Play SNDH music
	movem.l	(a7)+,d0-d7/a0-a6
	rte

COULEUR_RASTERTEXTE equ $FFFF8244

hbl_rasterTexte:
      CLR.B     $FFFFFA1B.W 
      MOVE.L    #HBL_GOOD,$120.W 
      MOVE.B    #1,$FFFFFA21.W
      MOVE.B    #8,$FFFFFA1B.W
      rte

HBL_GOOD:
      MOVE.W    hbl_rasterTexte,COULEUR_RASTERTEXTE.W
PTR_BUFFER_COLOR EQU	*-6 
      ADDQ.L    #2,PTR_BUFFER_COLOR
      SUBQ.W    #1,COMPTEUR_HBL
      BEQ       NEXT_HBL 
      RTE 

PRASTER:
      MOVEM.L   A0-A3/D0-D1,-(A7) 
      ADDQ.W    #1,COMPTEURRT
      CMPI.W    #75,COMPTEURRT
      BMI.S     .next 
      SUBI.W    #75,COMPTEURRT
.next:LEA       LIGNE,A0
      ADDA.W    COMPTEURRT,A0
      LEA       BUFFER_COLOR,A2
      MOVE.L    #$01130113,D0 ; imprime la couleur de fond
      MOVE.W    #8,D1 
.add: MOVE.L    D0,(A2)+
      MOVE.L    D0,(A2)+
      MOVE.L    D0,(A2)+
      MOVE.L    D0,(A2)+
      DBF       D1,.add
      LEA       COULEUR,A2
      LEA       BUFFER_COLOR,A1
      MOVEQ     #6,D1 
.loop:MOVEQ     #0,D0 
      MOVE.B    (A0),D0 
      LEA       4(A0),A0
      ADD.W     D0,D0 
      LEA       0(A1,D0.W),A3 
      MOVE.L    (A2)+,(A3)+ 
      MOVE.L    (A2)+,(A3)+ 
      MOVE.L    (A2)+,(A3)+ 
      MOVE.W    (A2)+,(A3)+ 
      DBF       D1,.loop
      MOVEM.L   (A7)+,A0-A3/D0-D1
      RTS 

NEXT_HBL:
      CLR.B     $FFFFFA1B.W 
      BCLR      #0,$FFFFFA0F.W
      RTE 

Little_texte:
      movea.l   physique,a5
     	add.l	#160*77+8*7+0,a5
      movea.l   physique+4,a4
      add.l	#160*77+8*7+0,a4
      lea       asciiRT,a2
test_carac:
      cmpi.b    #$ff,(a0) ; fin du texte ?
      beq       fini
.not_fini:
      cmpi.b    #$fe,(a0) ; retour à la ligne ?
      beq.s     next_line 
      cmpi.b    #$fc,(a0) ; plan 2 ? 
      bne.s     .test
.plane_two:
      move.w    #2,pointeur_plan
      addq.l    #1,a0 
.test:cmpi.b    #$fd,(a0) ; plan 1
      bne.s     l0039 
.plane_one:
      move.w    #0,pointeur_plan
      addq.l    #1,a0 
l0039:lea       (a5),a6 
      lea       (a4),a3
      bsr       put_carac 
      bra.s     test_carac 
next_line:
      addq.l    #1,a0 
      lea       asciiRT,a2
      lea       160*9(a5),a5 ; ligne suivante
      lea       160*9(a4),a4 ; ligne suivante
      bra.s     test_carac 
      cmpi.b    #$ff,(a0) 
      bne.s     test_carac 
      rts

put_carac:
      lea       fonte,a1
      moveq     #0,d2 
      move.b    (a0)+,d2
      asl.w     #5,d2 
      adda.w    d2,a1 
      adda.w    (a2),a6
      adda.w    (a2)+,a3
      adda.w    pointeur_plan,a6
      adda.w    pointeur_plan,a3
s set 0 ; source
d set 0 ; destination
 rept 8 ; 8 ligne
      move.b    s(a1),d(a6) 
      move.b    s(a1),d(a3) 
s set s+2
d set d+160
 endr
fini: rts 
