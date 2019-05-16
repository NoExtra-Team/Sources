* AL_1.PRG

* // Code & Ripp	 : Frederic Sagez aka Zorro 2	// *
* // Gfx neochrome master: Mister. A/NoExtra		// *
* // Music 		 : Excellence In Art - Smile	// *
* // Release date 	 : 27/10/2005			// *
* // Use Devpack 2.25f or greater to compil		// *

***********************************************
	opt	o-,d-
***********************************************

	SECTION	TEXT

***********************************************
* # RASTERS # *
decalB	equ	$2
nb_ligne	equ	$24
total_ligne	equ	$7F-$50

* # OTHERS # *
TAILLE_LOGO	equ	13*160

* # COLOR OF SCROLLING # *
COLOR_SCROLL	equ	$ffff8242    ;	with plan              

* # FXS SCREEN # *
SEEMYVBL	equ	0	; if =1 then see cpu conso via key ALT
VITESSE_SCROLL	equ	2	;	speed of scrolltext

* # COLOR PRECALC STARFIELD # *
S_COLOR0	equ $004
S_COLOR1	equ $025	
S_COLOR2	equ $047	
S_COLOR3	equ $777	
***********************************************

	clr.l	-(sp)
	move.w	#32,-(sp)
	trap	#1
	addq.l	#6,sp
	move.l	d0,Save_stack

	bsr	Init_screens
	bsr	SaveVBI
	bsr	Save_and_init_a_st

	bsr	fadein	;	Fade to - totally - black
	
	bsr	PutLogo ; Put Logo on top work screen

* # Init stars :
	bsr	INIT_STAR
	
* # Init text on screen :  
	MOVE.W    #0,INIT_T0
  MOVE.W    #0,INIT_T1
  LEA       TEXTE,A5
  BSR       PUT_TEXTE 

	bsr	Init

* # Init tab rasters :  
	bsr	InitRasters

**************** MAINLOOP *******************>

Main_rout:

	bsr	Wait_vbl

	IFEQ	SEEMYVBL
		clr.w	$ffff8240.w
	ENDC
	
	BSR	RASTER 

	jsr (music+8)

	BSR	STAR

	rept	VITESSE_SCROLL
	bsr	Scrolling
	endr

	IFEQ	SEEMYVBL
	cmp.b	#$38,$fffffc02.w	* Wait
	bne.s	Suite_rout
	move.w	#$7,$ffff8240.w
Suite_rout:	
	ENDC

	cmp.b	#$39,$fffffc02.w	* Wait
	bne.s	Main_rout		* Space

**************** MAINLOOP *******************<

	bsr	SoundOff
	bsr	RestoreVBI
	bsr	Restore_st

Kflush:
	btst	#0,$fffffc00.w
	beq.s	Flush_ok
	move.b	$fffffc02.w,d0
	bra.s	Kflush
Flush_ok:

	move.l	Save_stack,-(sp)
	move.w	#32,-(sp)
	trap	#1
	addq.l	#6,sp

	clr.w	-(sp)
	trap	#1

************************************************
*                                              *
*               Sub Routines                   *
*                                              *
************************************************

Vbl:	
	MOVE      #$2700,SR
	movem.l	d0-d7/a0-a6,-(a7)

	MOVE.W    #1,$FFFF8240.W	*	ligne bleu
	
* pause for a bit
	move.w	#1064+1,d0
pause:
	nop
	dbra	d0,pause

* into 60 Hz
	eor.b	#2,$ffff820a.w

	rept	8
	nop
	endr

* back into 50 Hz
	eor.b	#2,$ffff820a.w

	MOVEM.L   Pal(pc),D0-D7 
  MOVEM.L   D0-D7,$FFFF8240.W 
      
	st	Vsync

	CLR.B     $FFFFFA1B.W 
  MOVE.B    #decalB,$FFFFFA21.W
  MOVE.B    #8,$FFFFFA1B.W
  MOVE.L    #HBL_start,$120.W 
     	
	movem.l	(a7)+,d0-d7/a0-a6
	MOVE      #$2300,SR 
	rte

Wait_vbl:	
	move.l	a0,-(a7)
	lea	Vsync,a0
	sf	(a0)
Wait_label:	
	tst.b	(a0)
	beq.s	Wait_label
	move.l	(a7)+,a0
	rts

Init:
	movem.l	d0-d7/a0-a6,-(a7)

	move.b	$484.w,conterm	; Sauve ce bidule.
	clr.b	$484.w		; No bip,no repeat.
			
	DC.W $A000
	DC.W $A00A

	move.b	#$12,$fffffc02.w	* Couic la souris	
	
	moveq #1,d0
	jsr music		; activate first tune

	lea	Vbl(pc),a0
	move.l	a0,$70.w

	movem.l	(a7)+,d0-d7/a0-a6
	rts

Save_and_init_a_st:
	move	#$2700,sr

	sf	$ffff8260.w

	moveq	#0,d0
	lea	$fffffa00.w,a0
	movep.w	d0,$07(a0)
	movep.w	d0,$13(a0)

	bclr	#3,$fffffa17.w

	move.l	Turbo_scr1,d0
	move.b	d0,d1
	lsr.w	#8,d0
	move.b	d0,$ffff8203.w
	swap	d0
	move.b	d0,$ffff8201.w
	move.b	d1,$ffff820d.w

	sf	$fffffa21.w
	sf	$fffffa1b.w
  CLR.B     $FFFFFA07.W 
  CLR.B     $FFFFFA09.W 
  ORI.B     #1,$FFFFFA07.W
  ORI.B     #1,$FFFFFA13.W
      
	stop	#$2300
	rts

***************************************************************
*                                                             *
*                    < Here is the H B L >                    *
*                                                             *
***************************************************************

HBL_start:
			MOVE      #$2700,SR 
      MOVE.L    #0,$FF8260.L
      MOVE.L    #0,$FF8260.L
      MOVE.L    #0,$FF8260.L
      MOVE.L    #0,$FF8260.L
      MOVE.L    #0,$FF8260.L
      MOVE.L    #0,$FF8260.L
      MOVE.L    #0,$FF8260.L
      MOVE.L    #0,$FF8260.L
      MOVE.L    #0,$FF8260.L
      MOVE.L    #0,$FF8260.L
      MOVE.L    #0,$FF8260.L
      MOVE.L    #0,$FF8260.L
      MOVE.L    #0,$FF8260.L
      MOVE.L    #0,$FF8260.L
      MOVE.L    #0,$FF8260.L
      MOVE.L    #0,$FF8260.L
      MOVEM.L   D0-D7,-(A7) 
      CLR.B     $FFFFFA1B.W 
      MOVE.B    #1,$FFFFFA21.W
      MOVE.B    #8,$FFFFFA1B.W
      MOVE.L    #HBL_raster,$120.W 
      MOVEM.L   (A7)+,D0-D7 
      MOVE      #$2300,SR 
      RTE 
      
HBL_raster:
			MOVE      #$2700,SR 
      MOVEM.L   A0-A6/D0-D7,-(A7) 
      CLR.B     $FFFFFA1B.W 
      LEA       $FFFF8242.W,A0
      LEA       DATA_R3,A4
      LEA       DATA_R2,A6
	rept	12
      NOP 
	endr
      LEA       $FFFF8209.W,A1
      MOVEQ     #0,D1 
      SUB.B     (A1),D1 
      LSR.L     D1,D1 
	rept	50
      NOP 
	endr
      MOVE.W    #total_ligne,D7 *	nb de ligne
.loop:MOVEA.L   (A4)+,A2
      MOVEA.L   (A6)+,A3
      JSR       (A2)
      DBF       D7,.loop
      CLR.B     $FFFFFA1B.W 
      MOVE.B    #6-decalB,$FFFFFA21.W
      MOVE.B    #8,$FFFFFA1B.W
      MOVE.L    #HBL_BLANC,$120.W 
      MOVEM.L   (A7)+,A0-A6/D0-D7 
      MOVE      #$2300,SR 
      RTE 
      
TIMING_R:NOP 
      NOP 
      rept	nb_ligne
      MOVE.W    (A3)+,(A0)
			endr
      NOP 
      RTS 
      NOP 
      rept	nb_ligne
      MOVE.W    (A3)+,(A0)
			endr
      NOP 
      NOP 
      RTS 
      rept	nb_ligne
      MOVE.W    (A3)+,(A0)
			endr
      NOP 
      NOP 
      NOP 
      RTS 

HBL_BLANC:
		CLR.B     $FFFFFA1B.W 
    MOVE.W    #$777,$FFFF8240.W 	* ligne blanche du bas
    MOVE.B    #1,$FFFFFA21.W
    MOVE.L    #HBL_BLACK,$120.W 
    MOVE.B    #8,$FFFFFA1B.W
    BCLR      #0,$FFFFFA0F.W
    RTE 

HBL_BLACK:
		CLR.B     $FFFFFA1B.W
		MOVE.W    #0,$FFFF8240.W	*	ligne noir
		MOVE.B    #170,$FFFFFA21.W
    MOVE.L    #Over_rout,$120.W
    MOVE.B    #8,$FFFFFA1B.W
    BCLR      #0,$FFFFFA0F.W

*** ICI !!!
      
    MOVE.W    #S_COLOR0,$FFFF8242.W
    MOVE.W    #S_COLOR1,$FFFF8244.W
    MOVE.W    #S_COLOR2,$FFFF8246.W
    MOVE.W    #S_COLOR3,$FFFF8250.W        
    RTE 

pal_table:
	rept	7
	dc.w	$0000,$0000,$0000,$0000
	endr
	dc.w	$0000,$0000,$0000
	DC.B	$0F,$E0,$0F,$60,$0F,$D0,$0F,$50 
	DC.B	$0F,$C0,$0F,$40,$0F,$B0
	dc.w	$0000
	even

Over_rout:
* I arrive here somewhere in the middle of the bottom line!

	movem.l	d0/a0,-(a7)

	move.w	#$FFFFFA21,a0	; get timer B counter address

	move.b	(a0),d0		; get count value
.pause:
	cmp.b	(a0),d0		; wait for it to change
	beq.s	.pause		; (EXACTLY on next line now!)

* into 60 Hz
	eor.b	#2,$ffff820a.w

	rept	15
	nop
	endr

* back into 50 Hz
	eor.b	#2,$ffff820a.w

	movem.l	(a7)+,d0/a0
	
	lea	pal_table,a0
	move.w	#38,d0	;colour the bottom scroller
col_loop:
	move.w	(a0),COLOR_SCROLL.w
	move.w	(a0)+,COLOR_SCROLL+$a.w
	REPT 116
	nop
	ENDR
	dbf	d0,col_loop
      	
	bclr	#0,$fffffa0f.w
	rte
***************************************************************
*                                                             *
***************************************************************

Restore_st:

	move.b	Video,$ffff8260.w

	move.w	#$25,-(a7)
	trap	#14
	addq.w	#2,a7
	
	move.b	Video,$ffff8260.w

	move.b	#$8,$fffffc02.w	* Retablit la souris	
	
	DC.W $A000
	DC.W $A009

	move.b	conterm,$484.w	; Remettre ce bidule.
	rts

Init_screens:
	movem.l	d0-d7/a0-a6,-(a7)

* New work screen
	move.l	#Turbo_screen1,d0
	add.w	#$ff,d0
	sf	d0
	move.l	d0,Turbo_scr1

* Put pattern on screen
	movea.l	Turbo_scr1,a0
	move.w	#screen_len/4-1,d1
fill:
	move.l	#0,(a0)+
	dbra	d1,fill

	movem.l	(a7)+,d0-d7/a0-a6
	rts

SaveVBI
	lea	Save_all,a0
	move.b	$fffffa07.w,(a0)+
	move.b	$fffffa09.w,(a0)+
	move.b	$fffffa13.w,(a0)+
	move.b	$fffffa15.w,(a0)+
	move.b	$fffffa17.w,(a0)+
	move.b	$ffff8201.w,(a0)+
	move.b	$ffff8203.w,(a0)+
	move.b	$ffff820d.w,(a0)+
	move.b	$ffff8260.w,(a0)+
	move.b	$ffff820a.w,(a0)+

	move.l	$070.w,(a0)+	
	move.l	$118.w,(a0)+	
	move.l	$120.w,(a0)+	
	move.l	$134.w,(a0)+	
	move.l	$114.w,(a0)+	
	move.l	$110.w,(a0)+
		
	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,(a0)
	rts
	
RestoreVBI
	move.w	#$2700,sr
	lea	Save_all,a0
	move.b	(a0)+,$fffffa07.w
	move.b	(a0)+,$fffffa09.w
	move.b	(a0)+,$fffffa13.w
	move.b	(a0)+,$fffffa15.w
	move.b	(a0)+,$fffffa17.w
	move.b	(a0)+,$ffff8201.w
	move.b	(a0)+,$ffff8203.w
	move.b	(a0)+,$ffff820d.w
	move.b	(a0)+,$ffff8260.w
	move.b	(a0)+,$ffff820a.w

	move.l	(a0)+,$070.w
	move.l	(a0)+,$118.w
	move.l	(a0)+,$120.w
	move.l	(a0)+,$134.w
	move.l	(a0)+,$114.w
	move.l	(a0)+,$110.w

	movem.l	(a0),d0-d7
	movem.l	d0-d7,$ffff8240.w
	stop	#$2300
	rts

SoundOff:
	jsr music+4

	move.b 	#8,$ffff8800.w        ; Sound OFF
  move.b 	#0,$ffff8802.w
  move.b 	#9,$ffff8800.w
  move.b 	#0,$ffff8802.w
  move.b 	#$a,$ffff8800.w
  move.b 	#0,$ffff8802.w
	RTS

**************** RASTERS ******************>

InitRasters:
      LEA       DATA_R1,A1
.loop:MOVEQ     #0,D0 
      MOVEQ     #0,D1 
      MOVE.W    (A1),D0 
      MOVE.W    2(A1),D1
      ADD.W     D0,D0 
      ADD.W     #120,D0
      MOVE.W    D0,(A1) 
      MULU      #80,D1 
      MOVE.W    D1,2(A1)
      ADDQ.W    #4,A1 
      CMPA.L    #DATA_R2,A1 
      BNE.S     .loop 
      rts
      
RASTER:MOVEA.L   #DATA_R4,A0 
VITES_R EQU       *-4 
      LEA       DATA_R2,A2
      LEA       DATA_R3,A3
      LEA       DATA_R1,A1
      MOVE.L    #$80010,D4
      MOVE.W    #total_ligne,D7	*	nb	ligne
.loop:MOVEQ     #0,D2 
      MOVEQ     #0,D3 
      MOVE.W    (A0),D0 
      MOVE.W    0(A1,D0.W),D2 
      MOVE.W    2(A1,D0.W),D3 
      ADD.W     D4,D0 
      CMP.W     #160*10,D0
      BLT.S     .next0 
      SUBI.W    #160*10,D0
.next0:MOVE.W    D0,(A0)+
      CMPA.L    #DATA_R5,A0 
      BNE.S     .next1 
      MOVEA.L   #DATA_R4,A0 
.next1:ADDI.L    #DATA_R0,D2 
      MOVE.L    D2,(A2)+
      ADDI.L    #TIMING_R,D3 
      MOVE.L    D3,(A3)+
      SWAP      D4
      DBF       D7,.loop     
      ADDQ.L    #8,VITES_R	*	rapidite
      CMPI.L    #DATA_R5,VITES_R
      BLT.S     r_RTS 
      MOVE.L    #DATA_R4,VITES_R
r_RTS:RTS 

**************** RASTERS ******************<

**************** TEXTE ******************>

PUT_TEXTE:
			MOVEQ     #0,D1 
      MOVE.B    (A5)+,D1
      CMPI.B    #$FF,D1 
      BEQ.S     t_RTS 
      CMPI.B    #0,D1 
      BNE.S     .suivant 
      CLR.W     INIT_T0 
      ADDI.W    #1,INIT_T1
      BRA.S     PUT_TEXTE 
.suivant:
			SUBI.B    #32,D1 
      MULS      #6,D1 
      LEA       FONTE,A0
      ADDA.W    D1,A0 
      MOVEA.L   Turbo_scr1,A1
      lea       160*70(a1),a1	;	position of the text on work screen
      ADDQ.W    #6,A1		;	no plan
      MOVE.W    INIT_T0,D1
      BTST      #0,D1 
      BEQ.S     .next 
      LEA       1(A1),A1
.next:DIVS      #2,D1 
      MULS      #8,D1 
      ADDA.W    D1,A1 
      MOVE.W    INIT_T1,D1
      MULS      #160*6,D1
      ADDA.W    D1,A1 
      MOVE.B    (A0)+,(A1)
      MOVE.B    (A0)+,160(A1) 
      MOVE.B    (A0)+,320(A1) 
      MOVE.B    (A0)+,480(A1) 
      MOVE.B    (A0)+,640(A1) 
      MOVE.B    (A0)+,800(A1) 
      ADDI.W    #1,INIT_T0
      BRA       PUT_TEXTE 
t_RTS:RTS 

**************** TEXTE ******************<

**************** STARS ******************>

STAR:MOVEA.L   Turbo_scr1,A4
      lea       160*26(a4),a4		;	position of the stars on work screen
      LEA       4800(A4),A4 
      LEA       DATA_S1,A1
      MOVEq.L    #110-1,D0 
      MOVEQ     #0,D1 
.loop:MOVEA.L   (A1)+,A2
      MOVE.L    D1,(A2) 
      DBF       D0,.loop
      LEA       DATA_S1,A2
      LEA       BUFF_S0,A3
      MOVEQ.L   #110-1,D1 
.loop1:MOVEA.L   A4,A0 
      MOVEA.L   436(A3),A1
      ADDA.W    (A1)+,A0
      MOVE.L    (A1)+,D0
      OR.L      D0,(A0) 
      MOVE.L    A0,(A2)+
      TST.W     (A1)
      BPL.S     .next 
      MOVEA.L   (A3),A1 
.next:MOVE.L    A1,436(A3)
      ADDQ.L    #4,A3 
      DBF       D1,.loop1
      RTS 
      
DATA_S0:
	DC.W	$0 

INIT_STAR:LEA       DATA_S2,A6
      LEA       BUF_FULL,A5
      LEA       BUFF_S0,A4
GLOOP:ADDQ.L    #4,A6 
      CMPI.W    #$FF81,(A6) 
      BEQ.S     gnext0 
      MOVE.L    A5,(A4) 
      MOVE.L    A5,436(A4)
      ADDQ.L    #4,A4 
      CLR.W     DATA_S0 
GLOOP0:MOVEQ     #0,D0 
      MOVE.L    D0,D1 
      MOVE.L    D0,D2 
      MOVE.L    D0,D3 
      MOVE.L    D0,D4 
      MOVE.W    (A6),D0 
      MOVE.W    2(A6),D1
      MOVE.W    DATA_S0,D2
      SUBI.W    #1,D2 
      MOVE.W    D2,DATA_S0
      NEG.W     D0
      MOVE.W    #$FF9C,D3 
      MULS      D0,D3 
      ADDI.W    #$64,D2 
      DIVS      D2,D3 
      MOVE.W    D3,D0 
      ANDI.L    #$FFFF,D0 
      MOVEQ     #0,D3 
      MOVE.W    DATA_S0,D2
      NEG.W     D1
      MOVE.W    #$FF9C,D3 
      MULS      D1,D3 
      ADDI.W    #$64,D2 
      DIVS      D2,D3 
      MOVE.W    D3,D1 
      ANDI.L    #$FFFF,D1 
      BRA.S     INI_S 
gnext0:LEA       BUFF_S1,A0
      MOVEQ      #0,D0 
      MOVEq.L    #$32,D1 
.loop0:MOVEA.L   (A0),A1 
      ADDA.L    D0,A1 
      ADDI.L    #6,D0 
      MOVE.L    A1,(A0)+
      DBF       D1,.loop0
      MOVEQ     #0,D0 
      MOVEQ.L   #$32,D1 
.loop1:MOVEA.L   (A0),A1 
      ADDA.L    D0,A1 
      ADDI.L    #6,D0 
      MOVE.L    A1,(A0)+
      DBF       D1,.loop1
      MOVEQ     #0,D0 
      MOVEq.L    #$32,D1 
.loop2:MOVEA.L   (A0),A1 
      ADDA.L    D0,A1 
      ADDI.L    #6,D0 
      MOVE.L    A1,(A0)+
      DBF       D1,.loop2
      RTS 
      
INI_S:TST.W     D0
      BMI.S     .next0 
      ADDI.W    #160,D0 
      BRA.S     .next1 
.next0:MOVE.W    #160,D2 
      NEG.W     D0
      SUB.W     D0,D2 
      MOVE.W    D2,D0 
.next1:TST.W     D1
      BMI.S     .next2 
      MOVE.W    #100-1,D2 
      SUB.W     D1,D2 
      MOVE.W    D2,D1 
      BRA.S     .next3 
.next2:NEG.W     D1
      ADDI.W    #$63,D1 
.next3:BRA.S     gnext6 
GLOOP1:MULU      #160,D1 
      MOVE.W    D1,D2 
      MOVE.W    D0,D1 
      LSR.L     #4,D0 
      LSL.L     #3,D0 
      ADD.W     D0,D2 
      MOVE.W    D2,(A5)+
      ADD.W     D0,D0 
      SUB.W     D0,D1 
      MOVE.W    DATA_S0,D0
      NEG.W     D0
      DIVU      #30,D0 
      CMP.W     #2,D0 
      BGE.S     .next5 
      CMP.W     #1,D0 
      BGE.S     .next4 
      MOVE.W    #$8000,D0 
      LSR.W     D1,D0 
      MOVE.W    D0,(A5)+
      CLR.W     (A5)+ 
      BRA       GLOOP0 
.next4:CLR.W     (A5)+ 
      MOVE.W    #$8000,D0 
      LSR.W     D1,D0 
      MOVE.W    D0,(A5)+
      BRA       GLOOP0 
.next5:MOVE.W    #$8000,D0 
      LSR.W     D1,D0 
      MOVE.W    D0,(A5)+
      MOVE.W    D0,(A5)+
      BRA       GLOOP0 
gnext6:TST.W     D0
      BMI.s       .next7 
      CMPI.W    #320-1,D0
      BGE.S     .next7 
      TST.W     D1
      BMI.S     .next7 
      CMP.W     #200-1,D1 
      BGE.S     .next7 
      BRA.S     GLOOP1 
.next7:MOVE.W    #-1,(A5)+
      BRA       GLOOP 
      
	section	data
	      
DATA_S1:
	rept	80
	dc	$0007,$0000,$0007,$0000
	endr
DATA_S2:
	dc.l	DATA_S3
DATA_S3:
	dc	$0007,$001A,$FFE2,$FFE4
	dc	$FFFE,$FFF8,$FFE7,$FFE9
	dc	$0040,$000E,$001F,$0022
	dc	$FFD4,$FFE8,$FFBE,$000D
	dc	$FFD3,$0009,$0016,$FFE0
	dc	$000A,$0016,$0034,$0031
	dc	$001D,$FFE1,$FFC8,$002C
	dc	$FFD0,$FFDC,$FFD2,$0020
	dc	$0002,$0000,$000A,$0004
	dc	$0043,$0008,$0033,$FFF2
	dc	$FFDE,$FFFA,$002E,$FFD3
	dc	$0023,$0017,$0045,$002D
	dc	$003A,$0020,$000B,$FFEF
	dc	$FFFD,$0009,$FFC5,$FFFD
	dc	$002B,$FFD3,$FFBC,$FFF3
	dc	$FFFF,$0019,$FFF9,$FFD4
	dc	$FFCD,$0008,$FFF8,$0022
	dc	$0033,$FFFA,$0001,$0030
	dc	$0038,$002F,$001B,$0018
	dc	$FFF0,$FFDE,$003A,$000D
	dc	$FFDF,$0012,$000D,$FFF3
	dc	$002F,$FFDA,$0026,$0024
	dc	$FFEE,$0008,$FFE3,$FFEF
	dc	$002E,$FFEA,$0013,$FFEB
	dc	$0010,$FFD5,$0008,$0027
	dc	$0041,$FFD9,$000B,$FFD2
	dc	$FFE1,$002D,$FFBE,$FFF0
	dc	$0007,$FFD0,$FFCC,$FFFC
	dc	$001E,$002E,$FFED,$0017
	dc	$0012,$0002,$FFCE,$FFDB
	dc	$0031,$0030,$FFEF,$0010
	dc	$0008,$FFD1,$0016,$FFD4
	dc	$FFDA,$002F,$FFC1,$FFEB
	dc	$003D,$FFF2,$0013,$FFD3
	dc	$FFF3,$0007,$0003,$0008
	dc	$FFC2,$002B,$0018,$FFE5
	dc	$0034,$FFF1,$FFBD,$0011
	dc	$001C,$000F,$0011,$001D
	dc	$FFE6,$0023,$0020,$FFFD
	dc	$FFF5,$FFFC,$FFD7,$002D
	dc	$FFF0,$FFE0,$0007,$FFF8
	dc	$FFE6,$000F,$FFFE,$FFD2
	dc	$0038,$FFF4,$0032,$FFFE
	dc	$FFC7,$0014,$FFEB,$001E
	dc	$FFF8,$FFFF,$FFD3,$FFE3
	dc	$0023,$FFD1,$0034,$0028
	dc	$FFF5,$FFE8,$0024,$FFE1
	dc	$0006,$FFE5,$0018,$000A
	dc	$000E,$0003,$FFD1,$FFFF
	dc	$FFFC,$FFD7,$FFCE,$0009
	dc	$0044,$FFF5,$001E,$FFF2
	dc	$FFD5,$FFED,$0018,$FFD7
	dc	$FFDB,$0029,$003C,$FFE1
	dc	$FFEC,$0026,$0028,$FFD5
	dc	$FFFC,$000F,$0035,$0005
	dc	$FFEF,$FFDB,$FFD6,$0011
	dc	$FFFE,$001D,$FFFE,$FFFB
	dc	$0016,$FFFD,$0034,$0020
	dc	$FFFF,$FFD2,$0020,$0023
	dc	$FFDD,$0029,$0039,$FFD2
	dc	$FFD4,$FFD7,$0033,$FFE7
	dc	$003D,$FFD6,$FFFF,$FFFB
	dc	$FFE9,$0029,$FFFE,$0005
	dc	$0023,$FFDD,$0019,$0029
	dc	$0028,$000E,$000C,$FFD8
	dc	$0043,$FFEA,$FFD3,$FFF8
	dc	$0034,$FFDD,$0007,$0023
	dc	$0003,$001F,$FFC1,$0010
	dc	$FFE7,$FFF7,$FFC2,$001D
	dc	$0025,$FFE0,$FFEC,$0017
	dc	$0003,$FFF2,$003F,$0002
	dc	$0031,$FFFC,$001C,$FFD5
	dc	$FFE8,$0010,$FFBF,$FFCF
	dc	$FFF1,$000D,$0027,$000A
	dc	$FFD3,$FFD0,$0028,$0009
	dc	$0011,$0001,$002D,$0030
	dc	$0028,$FFE0,$FFC1,$FFD4
	dc	$FFBA,$FFF6,$0042,$FFDE
	dc	$FFCE,$0015,$0014,$FFD4
	dc	$FFDA,$FFF4,$0010,$0030
	dc	$FFC3,$FFF5,$FF81,$0000
	dc	$0222,$0444,$0555,$0650
	dc	$0540,$0430,$0320,$0555
	dc	$0777,$0777,$0777,$0777
	dc	$0777,$0777,$0777,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000

	section	text

**************** STARS ******************<

PutLogo:
	movea.l	Turbo_scr1,a1
	add.l	#160*2,a1
	movea.l	#IMG_LOGO,a0
	move.l	#TAILLE_LOGO,d0
.aff:	move.l	(a0)+,(a1)+
	dbf	d0,.aff
	rts
		      
fadein
	move.l	#$777,d0
deg
	bsr.s	wart
	bsr.s	wart
	bsr.s	wart
	lea	$ffff8240.w,a0
	moveq	#15,d1
chg1
	move.w	d0,(a0)+
	dbf	d1,chg1
	sub.w	#$111,d0
	bne.s	deg
	bsr.s	CLEAR_PAL
	rts

CLEAR_PAL:
	LEA       $FFFF8240.W,A0
  MOVEQ     #0,D1 
  MOVEQ     #7,D0 
PALETTE:
 	MOVE.L    D1,(A0)+ 
	DBF       D0,PALETTE
	RTS

wart							
	move.l	d0,-(sp)
	move.l	$466.w,d0
att
	cmp.l	$466.w,d0
	beq.s	att
	move.l	(sp)+,d0
	rts

**************** SCROLLING ******************>

Scrolling:				cmpi.w	#8,compteur
									blt.b	nonew
									bsr	put_carac
nonew							lea	buffer1,a3
									movea.l	a3,a0
									addq.w	#1,compteur
									lea	buffer2,a1
									moveq	#7,d7
.loop0						lsl.w	(a0)+
									addq.l	#2,a0
									roxl.w	$98(a1)
									roxl.w	$90(a1)
									roxl.w	$88(a1)
									roxl.w	$80(a1)
									roxl.w	$78(a1)
									roxl.w	$70(a1)
									roxl.w	$68(a1)
									roxl.w	$60(a1)
									roxl.w	$58(a1)
									roxl.w	$50(a1)
									roxl.w	$48(a1)
									roxl.w	$40(a1)
									roxl.w	$38(a1)
									roxl.w	$30(a1)
									roxl.w	$28(a1)
									roxl.w	$20(a1)
									roxl.w	$18(a1)
									roxl.w	$10(a1)
									roxl.w	8(a1)
									roxl.w	(a1)
									lea	160*1(a1),a1
									dbra	d7,.loop0
									lea	buffer2,a0
									move.l	Turbo_scr1,a1
									lea	160*200(a1),a1	;
									lea	160*60(a1),a1		;	position of scrolltext on work screen
									moveq	#6,d7
.loop1						move.w	(a0),(a1)
									move.w	8(a0),8(a1)
									move.w	$10(a0),$10(a1)
									move.w	$18(a0),$18(a1)
									move.w	$20(a0),$20(a1)
									move.w	$28(a0),$28(a1)
									move.w	$30(a0),$30(a1)
									move.w	$38(a0),$38(a1)
									move.w	$40(a0),$40(a1)
									move.w	$48(a0),$48(a1)
									move.w	$50(a0),$50(a1)
									move.w	$58(a0),$58(a1)
									move.w	$60(a0),$60(a1)
									move.w	$68(a0),$68(a1)
									move.w	$70(a0),$70(a1)
									move.w	$78(a0),$78(a1)
									move.w	$80(a0),$80(a1)
									move.w	$88(a0),$88(a1)
									move.w	$90(a0),$90(a1)
									move.w	$98(a0),$98(a1)
									lea	160(a0),a0
									lea	160(a1),a1
									dbra	d7,.loop1
									rts

put_carac:				moveq	#0,d0
									movea.l	textscroll,a0
									move.b	(a0)+,d0
									tst.b	(a0)
									bne.b	norecharge
									lea	text8_8,a0
norecharge:			  move.l	a0,textscroll
									clr.w	compteur
									lea	font8_8,a0
									lea	buffer1,a1
									subi.w	#32,d0
									lsl.w	#3,d0
									adda.w	d0,a0
									move.b	(a0)+,(a1)+
									clr.b	(a1)+
									addq.w	#2,a1
									move.b	(a0)+,(a1)+
									clr.b	(a1)+
									addq.w	#2,a1
									move.b	(a0)+,(a1)+
									clr.b	(a1)+
									addq.w	#2,a1
									move.b	(a0)+,(a1)+
									clr.b	(a1)+
									addq.w	#2,a1
									move.b	(a0)+,(a1)+
									clr.b	(a1)+
									addq.w	#2,a1
									move.b	(a0)+,(a1)+
									clr.b	(a1)+
									addq.w	#2,a1
									move.b	(a0)+,(a1)+
									clr.b	(a1)+
									addq.w	#2,a1
									move.b	(a0)+,(a1)+
									clr.b	(a1)+
									addq.w	#2,a1
									rts

**************** SCROLLING ******************>									

	SECTION	DATA

Pal:
		dc.w	$0001,$0700,$0223,$0444,$0445,$0334,$0556,$0C22
		dc.w	$0499,$0399,$0A11,$0888,$0211,$0000,$0988,$0777

IMG_LOGO:
		dc.w	$0000,$03FF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFF8,$0000,$0000
		dc.w	$0000,$007F,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$000F,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$E001,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FC00,$0000,$0000,$0000,$3FFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$C700,$0000,$0000
		dc.w	$01FF,$03FF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFF0,$FFF8,$0000,$0000
		dc.w	$003F,$007F,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFE,$FFFF,$0000,$0000
		dc.w	$0007,$000F,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$C000,$E001,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F800,$FC00,$0000,$0000,$1FFF,$3FFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$8700,$C000,$0700,$0000
		dc.w	$0100,$03FF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0010,$FFF8,$0000,$0000
		dc.w	$0020,$007F,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0002,$FFFF,$0000,$0000
		dc.w	$0004,$000F,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$4000,$E001,$0000,$0000,$8000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0800,$FC00,$0000,$0000,$1000,$3FFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$8000,$C000,$0700,$0000
		dc.w	$017F,$1F80,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFD0,$003F,$0000,$0000
		dc.w	$002F,$03F0,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFA,$0007,$0000,$0000
		dc.w	$0005,$E07E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$4000,$FC0F,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E800,$1F81,$0000,$0000,$17FF,$F800,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C700,$0700,$0000
		dc.w	$0F7F,$1F80,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFDE,$003F,$0000,$0000
		dc.w	$01EF,$03F0,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFB,$0007,$0000,$0000
		dc.w	$C03D,$E07E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$7807,$FC0F,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$EF00,$1F81,$0000,$0000,$F7FF,$F800,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C000,$0700,$0000
		dc.w	$087F,$1F80,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFC2,$003F,$0000,$0000
		dc.w	$010F,$03F0,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFF8,$0007,$0000,$0000
		dc.w	$4021,$E07E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0804,$FC0F,$0000,$0000,$3FFF,$C000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E100,$1F81,$0000,$0000,$87FF,$F800,$0000,$0000
		dc.w	$FFF0,$000F,$0000,$0000,$8770,$C000,$0770,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFA,$0007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$402F,$E070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E805,$1C0E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFF7,$000F,$0000,$0000,$8000,$C3F0,$0000,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFA,$0007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$402F,$E070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E805,$1C0E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFF4,$000F,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0800,$1FFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0001,$FFFE,$0000,$0000,$FFFA,$0007,$0000,$0000
		dc.w	$0100,$03FF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$3FFF,$C000,$0000,$0000
		dc.w	$4020,$E07F,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$07FF,$F800,$0000,$0000
		dc.w	$E804,$1C0F,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$00FF,$FF00,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$8000,$FFFF,$0000,$0000
		dc.w	$0004,$FFFE,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFD,$FFFE,$0000,$0000,$FFFA,$0007,$0000,$0000
		dc.w	$01FF,$03FF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$403F,$E07F,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$F7FF,$F800,$0000,$0000
		dc.w	$E807,$1C0F,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FEFF,$FF00,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFC,$FFFE,$0000,$0000,$0000,$03F0,$0000,$0000
		dc.w	$0000,$1FFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0005,$FFFE,$0000,$0000,$FFFA,$0007,$0000,$0000
		dc.w	$0000,$03FF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$4000,$E07F,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$17FF,$F800,$0000,$0000
		dc.w	$E800,$1C0F,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$02FF,$FF00,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFE,$0000,$0000,$07F0,$0000,$07F0,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0004,$000F,$0000,$0000,$3FFA,$C007,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$87FF,$F800,$0000,$0000
		dc.w	$4000,$E000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$10FF,$3F00,$0000,$0000
		dc.w	$E800,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$021F,$07E0,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$07F0,$0000
		dc.w	$0000,$000F,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0007,$E00F,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FC01,$0000,$0000,$F7FF,$F800,$0000,$0000
		dc.w	$4000,$E000,$0000,$0000,$0000,$3FFF,$0000,$0000
		dc.w	$0000,$FF80,$0000,$0000,$1EFF,$3F00,$0000,$0000
		dc.w	$E800,$1C00,$0000,$0000,$0000,$07FF,$0000,$0000
		dc.w	$0000,$FFFE,$0000,$0000,$03DF,$07E0,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$00FF,$0000,$0000
		dc.w	$0000,$FFFE,$0000,$0000,$0000,$0700,$0700,$0000
		dc.w	$0007,$000F,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$C000,$E00F,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F800,$FC01,$0000,$0000,$17FF,$F800,$0000,$0000
		dc.w	$4000,$E000,$0000,$0000,$1FFF,$3FFF,$0000,$0000
		dc.w	$FF00,$FF80,$0000,$0000,$02FF,$3F00,$0000,$0000
		dc.w	$E800,$1C00,$0000,$0000,$03FF,$07FF,$0000,$0000
		dc.w	$FFFC,$FFFE,$0000,$0000,$005F,$07E0,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$007F,$00FF,$0000,$0000
		dc.w	$FFFC,$FFFE,$0000,$0000,$0000,$0000,$07C0,$0000
		dc.w	$0004,$000F,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$4000,$E001,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$8000,$FFFF,$0000,$0000
		dc.w	$0800,$FC00,$0000,$0000,$10F8,$3F07,$0000,$0000
		dc.w	$4000,$E000,$0000,$0000,$1000,$3FFF,$0000,$0000
		dc.w	$0100,$FF80,$0000,$0000,$02FF,$0700,$0000,$0000
		dc.w	$E800,$1C00,$0000,$0000,$0200,$07FF,$0000,$0000
		dc.w	$0004,$FFFE,$0000,$0000,$0043,$00FC,$0000,$0000
		dc.w	$E100,$1F80,$0000,$0000,$0040,$00FF,$0000,$0000
		dc.w	$0004,$FFFE,$0000,$0000,$0700,$0000,$0700,$0000
		dc.w	$0005,$007E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$4000,$FC01,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$0000,$000F,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$E800,$1F80,$0000,$0000,$1EFB,$3F07,$0000,$0000
		dc.w	$C000,$E001,$0000,$0000,$17FF,$F800,$0000,$0000
		dc.w	$FD00,$03F0,$0000,$0000,$02FF,$0700,$0000,$0000
		dc.w	$E800,$1C00,$0000,$0000,$02FF,$3F00,$0000,$0000
		dc.w	$FFF4,$000E,$0000,$0000,$007B,$00FC,$0000,$0000
		dc.w	$EF00,$1F80,$0000,$0000,$005F,$07E0,$0000,$0000
		dc.w	$FFF4,$000F,$0000,$0000,$0000,$C3F0,$0000,$0000
		dc.w	$003D,$007E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$7800,$FC01,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$0007,$000F,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$EF00,$1F80,$0000,$0000,$02FA,$3F07,$0000,$0000
		dc.w	$0000,$E001,$0000,$0000,$F7FF,$F800,$0000,$0000
		dc.w	$FDE0,$03F0,$0000,$0000,$02FF,$0700,$0000,$0000
		dc.w	$E800,$1C00,$0000,$0000,$1EFF,$3F00,$0000,$0000
		dc.w	$FFF4,$000E,$0000,$0000,$000B,$00FC,$0000,$0000
		dc.w	$E800,$1F80,$0000,$0000,$03DF,$07E0,$0000,$0000
		dc.w	$FFF7,$000F,$0000,$0000,$8000,$C000,$0000,$0000
		dc.w	$0021,$007E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0800,$FC01,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$0004,$000F,$0000,$0000,$3FFF,$C000,$0000,$0000
		dc.w	$E100,$1F80,$0000,$0000,$0202,$07FF,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$87FF,$F800,$0000,$0000
		dc.w	$FC20,$03F0,$0000,$0000,$02FF,$0700,$0000,$0000
		dc.w	$E800,$1C00,$0000,$0000,$10FF,$3F00,$0000,$0000
		dc.w	$FFF4,$000E,$0000,$0000,$000B,$001C,$0000,$0000
		dc.w	$E800,$1C00,$0000,$0000,$021F,$07E0,$0000,$0000
		dc.w	$FFF0,$000F,$0000,$0000,$8000,$C000,$0000,$0000
		dc.w	$002F,$03F0,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$0005,$007E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$03FE,$07FF,$0000,$0000
		dc.w	$0000,$000F,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFA0,$0070,$0000,$0000,$02FF,$0700,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$17FF,$F800,$0000,$0000
		dc.w	$FFF4,$000F,$0000,$0000,$000B,$C01C,$0000,$0000
		dc.w	$E800,$1C00,$0000,$0000,$02FF,$3F00,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C3F0,$0000,$0000
		dc.w	$01EF,$03F0,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$003D,$007E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$07FF,$0000,$0000
		dc.w	$0007,$000F,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFA0,$0070,$0000,$0000,$02FF,$0700,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$F7FF,$F800,$0000,$0000
		dc.w	$FFF7,$000F,$0000,$0000,$800B,$C01C,$0000,$0000
		dc.w	$E800,$1C00,$0000,$0000,$1EFF,$3F00,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$87F0,$C000,$07F0,$0000
		dc.w	$010F,$03F0,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$0021,$007E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0004,$000F,$0000,$0000,$3FFF,$C000,$0000,$0000
		dc.w	$FFA0,$0070,$0000,$0000,$02FF,$0700,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$87FF,$F800,$0000,$0000
		dc.w	$FFF0,$000F,$0000,$0000,$800B,$C01C,$0000,$0000
		dc.w	$E800,$1C00,$0000,$0000,$10FF,$3F00,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C000,$07F0,$0000
		dc.w	$017F,$1F80,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E800,$1FFF,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$002F,$03F0,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0005,$007E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFA0,$007F,$0000,$0000,$02FF,$FF00,$0000,$0000
		dc.w	$E800,$1C0F,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$800B,$FFFC,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$17FF,$F800,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C700,$0700,$0000
		dc.w	$0F7F,$1F80,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$EFFF,$1FFF,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$01EF,$03F0,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003D,$007E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFBF,$007F,$0000,$0000,$FEFF,$FF00,$0000,$0000
		dc.w	$E807,$1C0F,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$FFFB,$FFFC,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$F7FF,$F800,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C000,$0770,$0000
		dc.w	$087F,$1F80,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E000,$1FFF,$0000,$0000,$3FFA,$C007,$0000,$0000
		dc.w	$010F,$03F0,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0021,$007E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FF80,$007F,$0000,$0000,$00FF,$FF00,$0000,$0000
		dc.w	$E804,$1C0F,$0000,$0000,$3FFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$0003,$FFFC,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$87FF,$F800,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8770,$C000,$0770,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFA,$0007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E805,$1C0E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E800,$1F81,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C3F0,$0000,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFA,$0007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E805,$1C0E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$EF00,$1F81,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C000,$0000,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFA,$0007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E805,$1C0E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E100,$1F81,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C000,$0000,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFA,$0007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E805,$1C0E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C3F0,$0000,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E000,$1FFF,$0000,$0000,$3FFA,$C007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FF80,$007F,$0000,$0000,$00FF,$FF00,$0000,$0000
		dc.w	$E804,$1C0F,$0000,$0000,$3FFF,$C000,$0000,$0000
		dc.w	$FE00,$01FF,$0000,$0000,$00FF,$FF00,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$87F0,$C000,$07F0,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$EFFF,$1FFF,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFBF,$007F,$0000,$0000,$FEFF,$FF00,$0000,$0000
		dc.w	$E807,$1C0F,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FEFF,$01FF,$0000,$0000,$FEFF,$FF00,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C000,$07F0,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E800,$1FFF,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFA0,$007F,$0000,$0000,$02FF,$FF00,$0000,$0000
		dc.w	$E800,$1C0F,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FE80,$01FF,$0000,$0000,$02FF,$FF00,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C700,$0700,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFA0,$0070,$0000,$0000,$02FF,$0700,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FE80,$01C0,$0000,$0000,$021F,$07E0,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C000,$07C0,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFA0,$0070,$0000,$0000,$02FF,$0700,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FE80,$01C0,$0000,$0000,$03DF,$07E0,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8700,$C000,$0700,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFA0,$0070,$0000,$0000,$02FF,$0700,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FE80,$01C0,$0000,$0000,$005F,$07E0,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C3F0,$0000,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFA0,$0070,$0000,$0000,$02FF,$0700,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FE80,$01C0,$0000,$0000,$005F,$00E0,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C000,$0000,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFA0,$0070,$0000,$0000,$02FF,$0700,$0000,$0000
		dc.w	$E800,$1C0F,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FE80,$01F8,$0000,$0000,$005F,$00E0,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C000,$0000,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFA0,$0070,$0000,$0000,$02FF,$0700,$0000,$0000
		dc.w	$E807,$1C0F,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FEF0,$01F8,$0000,$0000,$005F,$00E0,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C7E0,$0000,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFA0,$0070,$0000,$0000,$02FF,$0700,$0000,$0000
		dc.w	$E804,$1C0F,$0000,$0000,$3FFF,$C000,$0000,$0000
		dc.w	$FE10,$01F8,$0000,$0000,$005F,$00E0,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$87F0,$C000,$07F0,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFA0,$0070,$0000,$0000,$02FF,$0700,$0000,$0000
		dc.w	$E805,$1C0E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFD0,$003F,$0000,$0000,$005F,$07E0,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C000,$07F0,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFA0,$0070,$0000,$0000,$02FF,$0700,$0000,$0000
		dc.w	$E805,$1C0E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFDE,$003F,$0000,$0000,$03DF,$07E0,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C770,$0770,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFA0,$0070,$0000,$0000,$02FF,$0700,$0000,$0000
		dc.w	$E805,$1C0E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFC2,$003F,$0000,$0000,$021F,$07E0,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C000,$0770,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFA0,$0070,$0000,$0000,$02FF,$0700,$0000,$0000
		dc.w	$E805,$1C0E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFA,$0007,$0000,$0000,$02FF,$1F00,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8770,$C000,$0770,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFA0,$0070,$0000,$0000,$02FF,$0700,$0000,$0000
		dc.w	$E805,$1C0E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFA,$0007,$0000,$0000,$0EFF,$1F00,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C770,$0000,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFA0,$0070,$0000,$0000,$02FF,$0700,$0000,$0000
		dc.w	$E805,$1C0E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFA,$0007,$0000,$0000,$08FF,$1F00,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C000,$0000,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFA0,$0070,$0000,$0000,$02FF,$0700,$0000,$0000
		dc.w	$E805,$1C0E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFA,$0007,$0000,$0000,$0BFF,$1C00,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C000,$0000,$0000
		dc.w	$0BFF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E800,$1C01,$0000,$0000,$BFFA,$C007,$0000,$0000
		dc.w	$017F,$0380,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0070,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFA0,$0070,$0000,$0000,$02FF,$0700,$0000,$0000
		dc.w	$E805,$1C0E,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFA,$0007,$0000,$0000,$0BFF,$1C00,$0000,$0000
		dc.w	$FD00,$0381,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C7E0,$0000,$0000
		dc.w	$087F,$1F80,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0800,$FC01,$0000,$0000,$87C2,$F83F,$0000,$0000
		dc.w	$010F,$03F0,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E122,$1FA2,$0022,$0000,$BB99,$BB99,$BB99,$0000
		dc.w	$8621,$867E,$8600,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FC20,$03F0,$0000,$0000,$021F,$07E0,$0000,$0000
		dc.w	$0804,$FC0F,$0000,$0000,$3FFF,$C000,$0000,$0000
		dc.w	$FFFA,$0007,$0000,$0000,$0BFF,$1C00,$0000,$0000
		dc.w	$E100,$1F81,$0000,$0000,$87FF,$F800,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$87F0,$C000,$07F0,$0000
		dc.w	$0F7F,$1F80,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$7800,$FC01,$0000,$0000,$F7DE,$F83F,$0000,$0000
		dc.w	$01EF,$03F0,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$EF00,$1F80,$0000,$0036,$0000,$0000,$0000,$2122
		dc.w	$003D,$007E,$0000,$8900,$FFFF,$0000,$0000,$0000
		dc.w	$FDE0,$03F0,$0000,$0000,$03DF,$07E0,$0000,$0000
		dc.w	$7807,$FC0F,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFA,$0007,$0000,$0000,$0BFF,$1C00,$0000,$0000
		dc.w	$EF00,$1F81,$0000,$0000,$F7FF,$F800,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C000,$07F0,$0000
		dc.w	$017F,$1F80,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$4000,$FC01,$0000,$0000,$17D0,$F83F,$0000,$0000
		dc.w	$002F,$03F0,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$E87F,$1FD5,$0000,$007F,$FFFF,$428C,$0000,$FFFF
		dc.w	$FF85,$F0FE,$0000,$FF80,$FFFF,$0000,$0000,$0000
		dc.w	$FD00,$03F0,$0000,$0000,$005F,$07E0,$0000,$0000
		dc.w	$4000,$FC0F,$0000,$0000,$BFFF,$C000,$0000,$0000
		dc.w	$FFFA,$0007,$0000,$0000,$0BFF,$1C00,$0000,$0000
		dc.w	$E800,$1F81,$0000,$0000,$17FF,$F800,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8000,$C770,$0770,$0000
		dc.w	$0100,$03FF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$4000,$E000,$0000,$0000,$1010,$3FF8,$0000,$0000
		dc.w	$0020,$007F,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0800,$FC22,$0000,$0022,$0000,$8542,$0000,$8542
		dc.w	$0004,$890F,$0000,$8900,$0000,$FFFF,$0000,$0000
		dc.w	$0100,$FF80,$0000,$0000,$0040,$00FF,$0000,$0000
		dc.w	$4000,$E001,$0000,$0000,$8000,$FFFF,$0000,$0000
		dc.w	$0002,$FFFF,$0000,$0000,$0800,$1FFF,$0000,$0000
		dc.w	$0800,$FC00,$0000,$0000,$1000,$3FFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$8000,$C000,$0770,$0000
		dc.w	$01FF,$03FF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$C000,$E000,$0000,$0000,$1FF0,$3FF8,$0000,$0000
		dc.w	$003F,$007F,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F800,$FC00,$0022,$0022,$0000,$0000,$8542,$8542
		dc.w	$0007,$000F,$8900,$8900,$FFFF,$FFFF,$0000,$0000
		dc.w	$FF00,$FF80,$0000,$0000,$007F,$00FF,$0000,$0000
		dc.w	$C000,$E001,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFE,$FFFF,$0000,$0000,$0FFF,$1FFF,$0000,$0000
		dc.w	$F800,$FC00,$0000,$0000,$1FFF,$3FFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$8770,$C000,$0770,$0000
		dc.w	$0000,$03FF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$E000,$0000,$0000,$0000,$3FF8,$0000,$0000
		dc.w	$0000,$007F,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FC22,$0022,$0022,$0000,$9D3A,$9D3A,$9D3A
		dc.w	$2000,$A90F,$8900,$A900,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FF80,$0000,$0000,$0000,$00FF,$0000,$0000
		dc.w	$0000,$E001,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$1FFF,$0000,$0000
		dc.w	$0000,$FC00,$0000,$0000,$0000,$3FFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$C7E0,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	
DATA_R0:	*	Couleurs
	dc	$0000,$0001,$0002,$0003
	dc	$0004,$0005,$0006,$0007
	dc	$0006,$0005,$0004,$0003
	dc	$0002,$0001,$0000,$0010
	dc	$0020,$0030,$0040,$0050
	dc	$0060,$0070,$0060,$0050
	dc	$0040,$0030,$0020,$0010
	dc	$0000,$0100,$0200,$0300
	dc	$0400,$0500,$0600,$0700
	dc	$0600,$0500,$0400,$0300
	dc	$0200,$0100,$0000,$0011
	dc	$0022,$0033,$0044,$0055
	dc	$0066,$0077,$0066,$0055
	dc	$0044,$0033,$0022,$0011
	dc	$0000,$0101,$0202,$0303
	dc	$0404,$0505,$0606,$0707
	dc	$0606,$0505,$0404,$0303
	dc	$0202,$0101,$0000,$0110
	dc	$0220,$0330,$0440,$0550
	dc	$0660,$0770,$0660,$0550
	dc	$0440,$0330,$0220,$0110
	dc	$0000,$0111,$0222,$0333
	dc	$0444,$0555,$0666,$0777
	dc	$0666,$0555,$0444,$0333
	dc	$0222,$0111,$0000,$0001
	dc	$0002,$0003,$0004,$0005
	dc	$0006,$0007,$0006,$0005
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0010,$0020,$0030
	dc	$0040,$0050,$0060,$0070
	dc	$0060,$0050,$0040,$0030
	dc	$0020,$0010,$0000,$0100
	dc	$0200,$0300,$0400,$0500
	dc	$0600,$0700,$0600,$0500
	dc	$0400,$0300,$0200,$0100
	dc	$0000,$0011,$0022,$0033
	dc	$0044,$0055,$0066,$0077
	dc	$0066,$0055,$0044,$0033
	dc	$0022,$0011,$0000,$0101
	dc	$0202,$0303,$0404,$0505
	dc	$0606,$0707,$0606,$0505
	dc	$0404,$0303,$0202,$0101
	dc	$0000,$0110,$0220,$0330
	dc	$0440,$0550,$0660,$0770
	dc	$0660,$0550,$0440,$0330
	dc	$0220,$0110,$0000,$0111
	dc	$0222,$0333,$0444,$0555
	dc	$0666,$0777,$0666,$0555
	dc	$0444,$0333,$0222,$0111
DATA_R1:
	dc	$001A,$0002,$001A,$0001
	dc	$001A,$0001,$001A,$0001
	dc	$001A,$0001,$001A,$0001
	dc	$001A,$0001,$001A,$0001
	dc	$001A,$0001,$001A,$0001
	dc	$001A,$0001,$001A,$0001
	dc	$001A,$0001,$001A,$0001
	dc	$001A,$0001,$001A,$0000
	dc	$001A,$0000,$001A,$0000
	dc	$001A,$0000,$001A,$0000
	dc	$001A,$0000,$0019,$0002
	dc	$0019,$0002,$0019,$0002
	dc	$0019,$0002,$0019,$0001
	dc	$0019,$0001,$0019,$0001
	dc	$0019,$0001,$0019,$0000
	dc	$0019,$0000,$0019,$0000
	dc	$0019,$0000,$0018,$0002
	dc	$0018,$0002,$0018,$0002
	dc	$0018,$0001,$0018,$0001
	dc	$0018,$0001,$0018,$0000
	dc	$0018,$0000,$0017,$0002
	dc	$0017,$0002,$0017,$0002
	dc	$0017,$0001,$0017,$0001
	dc	$0017,$0001,$0017,$0000
	dc	$0017,$0000,$0016,$0002
	dc	$0016,$0002,$0016,$0001
	dc	$0016,$0001,$0016,$0000
	dc	$0016,$0000,$0015,$0002
	dc	$0015,$0002,$0015,$0002
	dc	$0015,$0001,$0015,$0001
	dc	$0015,$0000,$0015,$0000
	dc	$0014,$0002,$0014,$0001
	dc	$0014,$0001,$0014,$0000
	dc	$0014,$0000,$0013,$0002
	dc	$0013,$0002,$0013,$0001
	dc	$0013,$0001,$0013,$0000
	dc	$0013,$0000,$0012,$0002
	dc	$0012,$0001,$0012,$0001
	dc	$0012,$0000,$0012,$0000
	dc	$0011,$0002,$0011,$0001
	dc	$0011,$0001,$0011,$0000
	dc	$0011,$0000,$0010,$0002
	dc	$0010,$0001,$0010,$0001
	dc	$0010,$0000,$0010,$0000
	dc	$000F,$0002,$000F,$0001
	dc	$000F,$0001,$000F,$0000
	dc	$000F,$0000,$000E,$0002
	dc	$000E,$0001,$000E,$0001
	dc	$000E,$0000,$000D,$0002
	dc	$000D,$0002,$000D,$0001
	dc	$000D,$0000,$000D,$0000
	dc	$000C,$0002,$000C,$0002
	dc	$000C,$0001,$000C,$0000
	dc	$000C,$0000,$000B,$0002
	dc	$000B,$0001,$000B,$0001
	dc	$000B,$0000,$000B,$0000
	dc	$000A,$0002,$000A,$0001
	dc	$000A,$0001,$000A,$0000
	dc	$000A,$0000,$0009,$0002
	dc	$0009,$0001,$0009,$0001
	dc	$0009,$0000,$0009,$0000
	dc	$0008,$0002,$0008,$0001
	dc	$0008,$0001,$0008,$0000
	dc	$0008,$0000,$0007,$0002
	dc	$0007,$0001,$0007,$0001
	dc	$0007,$0000,$0007,$0000
	dc	$0006,$0002,$0006,$0002
	dc	$0006,$0001,$0006,$0001
	dc	$0006,$0000,$0006,$0000
	dc	$0005,$0002,$0005,$0001
	dc	$0005,$0001,$0005,$0000
	dc	$0005,$0000,$0004,$0002
	dc	$0004,$0002,$0004,$0002
	dc	$0004,$0001,$0004,$0001
	dc	$0004,$0000,$0004,$0000
	dc	$0003,$0002,$0003,$0002
	dc	$0003,$0001,$0003,$0001
	dc	$0003,$0000,$0003,$0000
	dc	$0003,$0000,$0002,$0002
	dc	$0002,$0002,$0002,$0002
	dc	$0002,$0001,$0002,$0001
	dc	$0002,$0000,$0002,$0000
	dc	$0002,$0000,$0001,$0002
	dc	$0001,$0002,$0001,$0002
	dc	$0001,$0001,$0001,$0001
	dc	$0001,$0001,$0001,$0001
	dc	$0001,$0000,$0001,$0000
	dc	$0001,$0000,$0001,$0000
	dc	$0000,$0002,$0000,$0002
	dc	$0000,$0002,$0000,$0002
	dc	$0000,$0001,$0000,$0001
	dc	$0000,$0001,$0000,$0001
	dc	$0000,$0001,$0000,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0001
	dc	$0000,$0001,$0000,$0001
	dc	$0000,$0001,$0000,$0001
	dc	$0000,$0001,$0000,$0002
	dc	$0000,$0002,$0000,$0002
	dc	$0000,$0002,$0001,$0000
	dc	$0001,$0000,$0001,$0000
	dc	$0001,$0000,$0001,$0001
	dc	$0001,$0001,$0001,$0001
	dc	$0001,$0001,$0001,$0002
	dc	$0001,$0002,$0001,$0002
	dc	$0002,$0000,$0002,$0000
	dc	$0002,$0000,$0002,$0001
	dc	$0002,$0001,$0002,$0002
	dc	$0002,$0002,$0002,$0002
	dc	$0003,$0000,$0003,$0000
	dc	$0003,$0000,$0003,$0001
	dc	$0003,$0001,$0003,$0002
	dc	$0003,$0002,$0004,$0000
	dc	$0004,$0000,$0004,$0001
	dc	$0004,$0001,$0004,$0002
	dc	$0004,$0002,$0004,$0002
	dc	$0005,$0000,$0005,$0000
	dc	$0005,$0001,$0005,$0001
	dc	$0005,$0002,$0006,$0000
	dc	$0006,$0000,$0006,$0001
	dc	$0006,$0001,$0006,$0002
	dc	$0006,$0002,$0007,$0000
	dc	$0007,$0000,$0007,$0001
	dc	$0007,$0001,$0007,$0002
	dc	$0008,$0000,$0008,$0000
	dc	$0008,$0001,$0008,$0001
	dc	$0008,$0002,$0009,$0000
	dc	$0009,$0000,$0009,$0001
	dc	$0009,$0001,$0009,$0002
	dc	$000A,$0000,$000A,$0000
	dc	$000A,$0001,$000A,$0001
	dc	$000A,$0002,$000B,$0000
	dc	$000B,$0000,$000B,$0001
	dc	$000B,$0001,$000B,$0002
	dc	$000C,$0000,$000C,$0000
	dc	$000C,$0001,$000C,$0002
	dc	$000C,$0002,$000D,$0000
	dc	$000D,$0000,$000D,$0001
	dc	$000D,$0002,$000D,$0002
	dc	$000E,$0000,$000E,$0001
	dc	$000E,$0001,$000E,$0002
	dc	$000F,$0000,$000F,$0000
	dc	$000F,$0001,$000F,$0001
	dc	$000F,$0002,$0010,$0000
	dc	$0010,$0000,$0010,$0001
	dc	$0010,$0001,$0010,$0002
	dc	$0011,$0000,$0011,$0000
	dc	$0011,$0001,$0011,$0001
	dc	$0011,$0002,$0012,$0000
	dc	$0012,$0000,$0012,$0001
	dc	$0012,$0001,$0012,$0002
	dc	$0013,$0000,$0013,$0000
	dc	$0013,$0001,$0013,$0001
	dc	$0013,$0002,$0013,$0002
	dc	$0014,$0000,$0014,$0000
	dc	$0014,$0001,$0014,$0001
	dc	$0014,$0002,$0015,$0000
	dc	$0015,$0000,$0015,$0001
	dc	$0015,$0001,$0015,$0002
	dc	$0015,$0002,$0015,$0002
	dc	$0016,$0000,$0016,$0000
	dc	$0016,$0001,$0016,$0001
	dc	$0016,$0002,$0016,$0002
	dc	$0017,$0000,$0017,$0000
	dc	$0017,$0001,$0017,$0001
	dc	$0017,$0001,$0017,$0002
	dc	$0017,$0002,$0017,$0002
	dc	$0018,$0000,$0018,$0000
	dc	$0018,$0001,$0018,$0001
	dc	$0018,$0001,$0018,$0002
	dc	$0018,$0002,$0018,$0002
	dc	$0019,$0000,$0019,$0000
	dc	$0019,$0000,$0019,$0000
	dc	$0019,$0001,$0019,$0001
	dc	$0019,$0001,$0019,$0001
	dc	$0019,$0002,$0019,$0002
	dc	$0019,$0002,$0019,$0002
	dc	$001A,$0000,$001A,$0000
	dc	$001A,$0000,$001A,$0000
	dc	$001A,$0000,$001A,$0000
	dc	$001A,$0001,$001A,$0001
	dc	$001A,$0001,$001A,$0001
	dc	$001A,$0001,$001A,$0001
	dc	$001A,$0001,$001A,$0001
	dc	$001A,$0001,$001A,$0001
	dc	$001A,$0001,$001A,$0001
	dc	$001A,$0001,$001A,$0001
DATA_R2:
	rept	150
	dc.l	DATA_R0
	endr
DATA_R3:
	rept	450
	dc.l	TIMING_R
	endr
DATA_R4:	*	Courbe
	dc	$013C,$0138,$0138,$0138
	dc	$0134,$0134,$0130,$0130
	dc	$012C,$0128,$0124,$0124
	dc	$0120,$011C,$0118,$0114
	dc	$0110,$010C,$0108,$0104
	dc	$0100,$00FC,$00F8,$00F4
	dc	$00F0,$00EC,$00E4,$00E0
	dc	$00DC,$00D8,$00D4,$00D0
	dc	$00CC,$00C8,$00C4,$00C0
	dc	$00BC,$00B8,$00B4,$00B0
	dc	$00AC,$00A8,$00A8,$00A4
	dc	$00A0,$00A0,$009C,$0098
	dc	$0098,$0094,$0094,$0094
	dc	$0090,$0090,$0090,$0090
	dc	$0090,$0090,$0090,$0090
	dc	$0090,$0090,$0090,$0090
	dc	$0094,$0094,$0094,$0098
	dc	$0098,$009C,$009C,$00A0
	dc	$00A4,$00A4,$00A8,$00AC
	dc	$00B0,$00B0,$00B4,$00B8
	dc	$00BC,$00C0,$00C4,$00C8
	dc	$00C8,$00CC,$00D0,$00D4
	dc	$00D8,$00DC,$00E0,$00E0
	dc	$00E4,$00E8,$00EC,$00EC
	dc	$00F0,$00F4,$00F8,$00F8
	dc	$00FC,$00FC,$0100,$0100
	dc	$0104,$0104,$0104,$0108
	dc	$0108,$0108,$0108,$0108
	dc	$0108,$0108,$0108,$0108
	dc	$0104,$0104,$0104,$0100
	dc	$0100,$00FC,$00FC,$00F8
	dc	$00F8,$00F4,$00F0,$00EC
	dc	$00EC,$00E8,$00E4,$00E0
	dc	$00DC,$00D8,$00D4,$00D0
	dc	$00C8,$00C4,$00C0,$00BC
	dc	$00B8,$00B0,$00AC,$00A8
	dc	$00A4,$009C,$0098,$0094
	dc	$0090,$008C,$0084,$0080
	dc	$007C,$0078,$0074,$006C
	dc	$0068,$0064,$0060,$005C
	dc	$0058,$0054,$0050,$0050
	dc	$004C,$0048,$0044,$0044
	dc	$0040,$0040,$003C,$003C
	dc	$0038,$0038,$0038,$0034
	dc	$0034,$0034,$0034,$0034
	dc	$0034,$0034,$0034,$0034
	dc	$0038,$0038,$0038,$003C
	dc	$003C,$0040,$0040,$0044
	dc	$0044,$0048,$004C,$0050
	dc	$0050,$0054,$0058,$005C
	dc	$005C,$0060,$0064,$0068
	dc	$006C,$0070,$0074,$0074
	dc	$0078,$007C,$0080,$0084
	dc	$0088,$008C,$008C,$0090
	dc	$0094,$0098,$0098,$009C
	dc	$00A0,$00A0,$00A4,$00A4
	dc	$00A8,$00A8,$00A8,$00AC
	dc	$00AC,$00AC,$00AC,$00AC
	dc	$00AC,$00AC,$00AC,$00AC
	dc	$00AC,$00AC,$00AC,$00A8
	dc	$00A8,$00A8,$00A4,$00A4
	dc	$00A0,$00A0,$009C,$0098
	dc	$0094,$0094,$0090,$008C
	dc	$0088,$0084,$0080,$007C
	dc	$0078,$0074,$0070,$006C
	dc	$0068,$0064,$0060,$005C
	dc	$0058,$0050,$004C,$0048
	dc	$0044,$0040,$003C,$0038
	dc	$0034,$0030,$002C,$0028
	dc	$0024,$0020,$001C,$0018
	dc	$0018,$0014,$0010,$000C
	dc	$000C,$0008,$0008,$0004
	dc	$0004,$0004,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0004,$0004,$0004
	dc	$0008,$0008,$000C,$000C
	dc	$0010,$0014,$0018,$0018
	dc	$001C,$0020,$0024,$0028
	dc	$002C,$0030,$0034,$0038
	dc	$003C,$0040,$0044,$0048
	dc	$004C,$0050,$0058,$005C
	dc	$0060,$0064,$0068,$006C
	dc	$0070,$0074,$0078,$007C
	dc	$0080,$0084,$0088,$008C
	dc	$0090,$0094,$0094,$0098
	dc	$009C,$009C,$00A0,$00A4
	dc	$00A4,$00A8,$00A8,$00A8
	dc	$00AC,$00AC,$00AC,$00AC
	dc	$00AC,$00AC,$00AC,$00AC
	dc	$00AC,$00AC,$00AC,$00AC
	dc	$00A8,$00A8,$00A8,$00A4
	dc	$00A4,$00A0,$00A0,$009C
	dc	$0098,$0098,$0094,$0090
	dc	$008C,$008C,$0088,$0084
	dc	$0080,$007C,$0078,$0074
	dc	$0074,$0070,$006C,$0068
	dc	$0064,$0060,$005C,$005C
	dc	$0058,$0054,$0050,$0050
	dc	$004C,$0048,$0044,$0044
	dc	$0040,$0040,$003C,$003C
	dc	$0038,$0038,$0038,$0034
	dc	$0034,$0034,$0034,$0034
	dc	$0034,$0034,$0034,$0034
	dc	$0038,$0038,$0038,$003C
	dc	$003C,$0040,$0040,$0044
	dc	$0044,$0048,$004C,$0050
	dc	$0050,$0054,$0058,$005C
	dc	$0060,$0064,$0068,$006C
	dc	$0074,$0078,$007C,$0080
	dc	$0084,$008C,$0090,$0094
	dc	$0098,$009C,$00A4,$00A8
	dc	$00AC,$00B0,$00B8,$00BC
	dc	$00C0,$00C4,$00C8,$00D0
	dc	$00D4,$00D8,$00DC,$00E0
	dc	$00E4,$00E8,$00EC,$00EC
	dc	$00F0,$00F4,$00F8,$00F8
	dc	$00FC,$00FC,$0100,$0100
	dc	$0104,$0104,$0104,$0108
	dc	$0108,$0108,$0108,$0108
	dc	$0108,$0108,$0108,$0108
	dc	$0104,$0104,$0104,$0100
	dc	$0100,$00FC,$00FC,$00F8
	dc	$00F8,$00F4,$00F0,$00F0
	dc	$00EC,$00E8,$00E4,$00E0
	dc	$00E0,$00DC,$00D8,$00D4
	dc	$00D0,$00CC,$00C8,$00C8
	dc	$00C4,$00C0,$00BC,$00B8
	dc	$00B4,$00B0,$00B0,$00AC
	dc	$00A8,$00A4,$00A4,$00A0
	dc	$00A0,$009C,$0098,$0098
	dc	$0094,$0094,$0094,$0090
	dc	$0090,$0090,$0090,$0090
	dc	$0090,$0090,$0090,$0090
	dc	$0090,$0090,$0090,$0094
	dc	$0094,$0094,$0098,$0098
	dc	$009C,$009C,$00A0,$00A4
	dc	$00A8,$00A8,$00AC,$00B0
	dc	$00B4,$00B8,$00BC,$00C0
	dc	$00C4,$00C8,$00CC,$00D0
	dc	$00D4,$00D8,$00DC,$00E0
	dc	$00E4,$00EC,$00F0,$00F4
	dc	$00F8,$00FC,$0100,$0104
	dc	$0108,$010C,$0110,$0114
	dc	$0118,$011C,$0120,$0124
	dc	$0124,$0128,$012C,$0130
	dc	$0130,$0134,$0134,$0138
	dc	$0138,$0138,$013C,$013C
	dc	$013C,$013C,$013C,$0140
	dc	$013C,$013C,$013C,$013C
DATA_R5:
	rept	10
	dc.w	$0000,$0000,$0000,$0000
	endr
	
INIT_T0:
	dc	$0000
INIT_T1:
	dc	$0000,$0000
FONTE:
	dc	$0000,$0000,$0000,$3838
	dc	$3800,$3800,$6C24,$0000
	dc	$0000,$6CFE,$6CFE,$6C00
	dc	$7CD0,$7C16,$7C00,$CEDC
	dc	$3876,$E600,$7CD6,$70D6
	dc	$7C00,$3818,$0800,$0000
	dc	$1830,$3030,$1800,$3018
	dc	$1818,$3000,$5438,$FE38
	dc	$5400,$1010,$7C10,$1000
	dc	$0000,$3818,$0800,$0000
	dc	$7C00,$0000,$0000,$0038
	dc	$3800,$0E1C,$3870,$E000
	dc	$7CEE,$F6E6,$7C00,$3C7C
	dc	$1C1C,$1C00,$7C06,$7CE0
	dc	$FE00,$FC0E,$3E0E,$FC00
	dc	$EEEE,$FE0E,$0E00,$FCE0
	dc	$FC0E,$FC00,$7CE0,$FCE6
	dc	$7C00,$FE0C,$1838,$3800
	dc	$7CE6,$7CE6,$7C00,$7CE6
	dc	$7E06,$7C00,$0030,$0030
	dc	$0000,$0030,$0030,$1000
	dc	$1C38,$7038,$1C00,$007C
	dc	$007C,$0000,$7038,$1C38
	dc	$7000,$FC0E,$3C00,$3000
	dc	$7CEA,$EEE0,$7E00,$7CE6
	dc	$FEE6,$E600,$FCE6,$FCE6
	dc	$FC00,$7CE6,$E0E6,$7C00
	dc	$FCE6,$E6E6,$FC00,$FEE0
	dc	$F8E0,$FE00,$FEE0,$F8E0
	dc	$E000,$7EE0,$EEE6,$7E00
	dc	$E6E6,$FEE6,$E600,$7C38
	dc	$3838,$7C00,$0E0E,$0EEE
	dc	$7C00,$E6E6,$FCE6,$E600
	dc	$E0E0,$E0E0,$FE00,$C6EE
	dc	$F6E6,$E600,$E6F6,$EEE6
	dc	$E600,$7CE6,$E6E6,$7C00
	dc	$FCE6,$FCE0,$E000,$7CE6
	dc	$E6EC,$7600,$FCE6,$FCE6
	dc	$E600,$7EE0,$7C06,$FC00
	dc	$FE38,$3838,$3800,$E6E6
	dc	$E6E6,$7C00,$E6E6,$E66C
	dc	$3800,$E6E6,$F6EE,$C600
	dc	$E6E6,$7CE6,$E600,$E6E6
	dc	$7C38,$3800,$FE1C,$3870
	dc	$FE00,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000
TEXTE:
;			ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789-*:/!()?,.+
			DC.B	'      AL TEAM IS PROUD TO PRESENT       ',$00
			dc.b	$00	*	ligne suivante
			DC.B	'    DUNGEONLORD - THE WORDS OF POWER    ',$00
			DC.B	'    --------------------------------    ',$00
			dc.b	$00	*	ligne suivante
			DC.B	'      HERE THE GAME CODES TO PLAY :     ',$00
			dc.b	$00	*	ligne suivante
			DC.B	'CIRCLE 1: SPHERE (BLUE), DEATH (RED), ',$00
			DC.B	'WIND (GREEN) SUN (GREY), NIGHT (YELLOW) ',$00
			dc.b	$00	*	ligne suivante
			DC.B	'CIRCLE 2: DRAGON (GREEN), STAR (RED), ',$00
			DC.B	'MAGIC (BLUE), WATER (YELLOW), EVIL(GREY)',$00
			dc.b	$00	*	ligne suivante
			DC.B	'CIRCLE 3: FIRE (YELLOW), SPHERE (BLUE),',$00
			DC.B	'DRAGON (GREEN), MOON (RED), DARK (GREY) ',$00
			dc.b	$00	*	ligne suivante
			DC.B	'CIRCLE 4: LIFE (GREY), EARTH (RED),   ',$00
			DC.B	'WATER (BLUE), EVIL (GREEN), STAR(YELLOW)',$00
			dc.b	$00	*	ligne suivante
			DC.B	'CIRCLE 5: MAGIC (BLUE), SUN (YELLOW), ',$00
			DC.B	'WIND (GREY), FIRE (RED), DRAGON (GREEN) ',$00
			dc.b	$00	*	ligne suivante
			DC.B	'CIRCLE 6: STAR (RED), EVIL (GREEN),   ',$00
			DC.B	'NIGHT (YELLOW), MOON (GREY), WATER(BLUE)',$00
			dc.b	$00	*	ligne suivante
			DC.B	'CIRCLE 7: DEATH (GREEN), SPHERE (GREY),',$00
			DC.B	'FIRE (RED), LIFE (BLUE), EARTH (YELLOW) ',$00
			dc.b	$00	*	ligne suivante
			DC.B	'CIRCLE 8: EVIL (GREY), MOON (RED),    ',$00
			DC.B	'DARK (YELLOW), SUN (GREEN), LIFE (BLUE) ',$00
;			DC.B	'TEXTE TEXTE TEXTE TEXTE TEXTE TEXTE TEXT',$00
      DC.B	$00,$FF * fin
			even
			
compteur
	dc.b	0,$19,0,0
buffer1						
	rept 6
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	endr								
	dc.b	0,0,0,0,0,0
buffer2
	rept 85
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	endr								
	dc.b	0,0,0,0,0
textscroll
	dc.l	text8_8
text8_8 
	dc.b '                           '
	dc.b ' CODE : ZORRO 2, GFX AND DESIGN : MISTER A. OF NOEXTRA, MUZZAX : EIA.'
	DC.B '               ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789 :!()?,.     '
	dc.b ' BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA '
	dc.b ' BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA '
	dc.b ' BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA '
	DC.B ' ................ RE-START SCROLLING........................     ',0
	dc.l	font8_8
FONT8_8:
	dc	$0000,$0000,$0000,$0000
	dc	$3030,$3030,$0030,$3000
	dc	$6C48,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$3020,$0000,$0000,$0000
	dc	$0E18,$1818,$1818,$0E00
	dc	$E030,$3030,$3030,$E000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0030,$2000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0020,$3000
	dc	$0000,$0000,$0000,$0000
	dc	$FC06,$CED6,$E6C6,$7C00
	dc	$3818,$1818,$1818,$1800
	dc	$7CC6,$067C,$C0C0,$FE00
	dc	$7CC6,$063C,$06C6,$7C00
	dc	$C0D8,$D8FE,$1818,$1800
	dc	$FE06,$C0FC,$06C6,$7C00
	dc	$FC06,$C0FC,$C6C6,$7C00
	dc	$FE06,$0C18,$3060,$C000
	dc	$7C06,$C67E,$C6C6,$7C00
	dc	$7CC6,$C67E,$06C6,$7C00
	dc	$0030,$3000,$3030,$0000
	dc	$0030,$3000,$3020,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7CC6,$063C,$0030,$3000
	dc	$0000,$0000,$0000,$0000
	dc	$FC06,$C6FE,$C6C6,$C600
	dc	$FC06,$C6FC,$C6C6,$FC00
	dc	$FC06,$C0C0,$C0C6,$7E00
	dc	$FC06,$C6C6,$C6C6,$FE00
	dc	$FE00,$C0F8,$C0C0,$FE00
	dc	$FEC0,$C0F8,$C0C0,$C000
	dc	$FC06,$C0CE,$C6C6,$7E00
	dc	$C6C6,$C6FE,$C6C6,$C600
	dc	$FE00,$1030,$3030,$FE00
	dc	$0E06,$06E6,$C6C6,$7C00
	dc	$C6C6,$C0FC,$C6C6,$C600
	dc	$C0C0,$C0C0,$C0C0,$FE00
	dc	$EC3E,$D6C6,$C6C6,$C600
	dc	$FC06,$C6C6,$C6C6,$C600
	dc	$FC06,$C6C6,$C6C6,$7C00
	dc	$FC06,$C6FC,$C0C0,$C000
	dc	$FC06,$C6C6,$DECC,$7600
	dc	$FC06,$C6FC,$C6C6,$C600
	dc	$FC06,$C07C,$06C6,$7C00
	dc	$FE10,$3030,$3030,$3000
	dc	$C6C6,$C6C6,$C6C6,$7C00
	dc	$82C6,$C6C6,$C66C,$3800
	dc	$C6C6,$C6C6,$D6FE,$6C00
	dc	$E6C6,$4C38,$6CC6,$CE00
	dc	$C6C6,$C67C,$1030,$3000
	dc	$FE00,$1830,$60C0,$FE00
	even
                  
music:
	INCBIN	"smile.mus"
	even
			
******************************************************************

	SECTION	BSS

conterm		ds.w	1 

Vsync:	ds.b	1
       	ds.b	1
       	
Save_stack:	ds.l	1

Save_all:
	ds.b	5	* Mfp
	ds.b	3	* Video
Video	ds.b	1
	ds.b	1
	ds.l	1	* Vbl
	ds.l	1	* Kbd
	ds.l	1	* Timer b
	ds.l	1	* Timer a
	ds.l	1	* Timer c
	ds.l	1	* Timer d
	ds.w	16	* Palette

Turbo_scr1:	ds.l	1

Turbo_screen1:
	ds.b	256		; byte boundary
start_screen:
	ds.b	34*160		; top border area
	ds.b	32000		; main screen
	ds.b	35*160		; bottom border area
screen_len	equ	*-start_screen

BUFF_S0:DS.B      436 
BUFF_S1:DS.B      1436
BUF_FULL:	;	reserved zone !!!
	END
