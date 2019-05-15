* AL_5.PRG or the DCK style !

* // Code & Ripp	 : Atomus & Zorro2	// *
* // Gfx neochrome master: Mister. A/NoExtra	// *
* // Music 		 : Marcer		// *
* // Release date 	 : 12/02/2006		// *

***********************************************
	opt	o-,d-
***********************************************

	SECTION	TEXT

***********************************************
couleur_logo	equ	$0ddf	
SEEMYVBL	equ	1 ;	0 = see cpu & 1 = nothing
***********************************************
	
	clr.l	-(sp)
	move.w	#32,-(sp)
	trap	#1
	addq.l	#6,sp
	move.l	d0,Save_stack

	bsr	Init_screens

	bsr	Save_and_init_a_st

******************************************************************************

	bsr	fadein
	
	clr.w	$ffff8240.w

	jsr	MUSIC+0			; init music
	
	bsr	Init

	movea.l	Zorro_scr1,a1
	adda.l	#160*76,a1
	movea.l	#LogoNoeXtra,a0
	move.l	#7999-6800+180,d0
aff:	move.l	(a0)+,(a1)+
	dbf	d0,aff
	
	lea     PalNoeXtra,a2
	bsr     fadeon	
	
	bsr	MAKE_STARS

	bsr	INIT_SCROLLY 

	bsr     fadeoff
	
	lea	GO_RASTER,a0
	st	(a0)

	movea.l	Zorro_scr1,a6
	move.w	#Zorro_screen1_len/4-1,d1
fill:
	move.l	#$0,(a6)+
	dbra	d1,fill

	lea	Pal(pc),a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

Main_rout:

	bsr	Wait_vbl

	IFEQ	SEEMYVBL
	clr.w	$ffff8240.w
	ENDC

*
	bsr	DIGITS

	bsr	CLS_STARS
	bsr	STARS

	bsr	PUT_LOGO	

	bsr	CLEAR_BUG	
	bsr	SCROLLING
	
*
	MOVE.L    Zorro_scr1,D0
	MOVE.L    Zorro_scr2,Zorro_scr1 
	MOVE.L    D0,Zorro_scr2
	LSR.W     #8,D0 
	MOVE.L    D0,$FFFF8200.W
	
	IFEQ	SEEMYVBL
	cmp.b	#$38,$fffffc02.w	* Wait
	bne.s	Suite_rout		* Alt
	move.b	#$7,$ffff8240.w
Suite_rout:	
	ENDC
	
	cmp.b	#$39,$fffffc02.w	* Wait
	bne.s	Main_rout		* Space

******************************************************************************

	jsr	MUSIC+4			; de-init music

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

GO_RASTER:
		ds.w	1

Vbl:
	clr.b     $fffffa1b.w   
      
	move.l	a0,-(a7)
	lea	GO_RASTER,a0
	tst.b	(a0)
	beq.s	.suite
	MOVE.B    #1,$FFFA21.L
	MOVE.B    #8,$FFFFFA1B.W    
	MOVE.L    #PALETTE,PTR_PAL
.suite:
	move.l	(a7)+,a0
	
	st	Vsync

	jsr 	(MUSIC+8)			; call music
	
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

*********************************************
*                                           *
*********************************************

Init:	movem.l	d0-d7/a0-a6,-(a7)

	lea	Vbl(pc),a0
	move.l	a0,$70.w

	movem.l	(a7)+,d0-d7/a0-a6
	rts

************************************************
*                                              *
************************************************

Save_and_init_a_st:

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

	sf	$ffff8260.w

	moveq	#0,d0
	lea	$fffffa00.w,a0
	movep.w	d0,$07(a0)
	movep.w	d0,$13(a0)

	bclr	#3,$fffffa17.w

	move.l	Zorro_scr1,d0
	move.b	d0,d1
	lsr.w	#8,d0
	move.b	d0,$ffff8203.w
	swap	d0
	move.b	d0,$ffff8201.w
	move.b	d1,$ffff820d.w

	LEA       $FFFFFA07.W,A0
	ANDI.B    #$DF,2(A0)
	ANDI.B    #$FE,(A0) 
	MOVE.L    #HBL,$120.W 
	ORI.B     #1,(A0) 
	ORI.B     #1,12(A0) 

	stop	#$2300

	move.b	$484.w,conterm	; Sauve ce bidule.
	clr.b	$484.w		; No bip,no repeat.
			
	DC.W $A000
	DC.W $A00A

	move.b	#$12,$fffffc02.w	* Couic la souris	
		
	rts

***************************************************************
*                                                             *
***************************************************************

HBL:  MOVEM.L   A0,-(A7)
      MOVEA.L   PTR_PAL,A0
      MOVE.W    (A0)+,$FFFF8250.W 
      MOVE.L    A0,PTR_PAL
      CMPI.W    #PAL_LENGHT,(A0) 
      BNE.S     .next 
      MOVE.B    #0,$FFFA1B.L
.next:MOVEM.L   (A7)+,A0
      BCLR      #0,$FFFA0F.L
      RTE 

***************************************************************
*                                                             *
***************************************************************

Restore_st:
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

	move.b	#$8,$fffffc02.w	* Retablit la souris	
	
	DC.W $A000
	DC.W $A009

	move.b	conterm,$484.w	; Remettre ce bidule.
	
* Sorry for the next lines, but sometimes there somes syncs error !!

	move.b	Video,$ffff8260.w
	move.w	#$25,-(a7)
	trap	#14
	addq.w	#2,a7
	move.b	Video,$ffff8260.w

	rts

************************************************
*                                              *
************************************************

Init_screens:	movem.l	d0-d7/a0-a6,-(a7)

	move.l	#Zorro_screen1,d0
	add.w	#$ff,d0
	sf	d0
	move.l	d0,Zorro_scr1

	move.l	#Zorro_screen2,d0
	add.w	#$ff,d0
	sf	d0
	move.l	d0,Zorro_scr2
	
	movea.l	Zorro_scr1,a6
	move.w	#Zorro_screen1_len/4-1,d1
.fill:
	move.l	#$0,(a6)+
	dbra	d1,.fill

	movea.l	Zorro_scr2,a6
	move.w	#Zorro_screen2_len/4-1,d1
.fill2:
	move.l	#$0,(a6)+
	dbra	d1,.fill2
	
	movem.l	(a7)+,d0-d7/a0-a6
	rts

******************************************************************
PUTBUF:LEA       BUFFER_5,A0
      LEA       BUFFER_4,A1
 rept	43
      MOVE.L    (A0)+,(A1)+ 
 endr
      RTS 

INIT_SCROLLY:
      LEA       BUFFER_3,A0
      MOVE.L    #$BCDB,D0 
.loop:CLR.B     (A0)+ 
      DBF       D0,.loop
      
      LEA       FONTEs,A0
      LEA       BUFFER_4,A1
 rept	11 
      MOVE.L    (A0),(A1)+
      MOVE.L    4(A0),(A1)+ 
      MOVE.L    8(A0),(A1)+ 
      MOVE.L    12(A0),(A1)+
 endr
      bsr       ZYVA 
      MOVE.L    #DATA_2,DATA_3
      MOVE.L    #TEXTE,PTR_TEXTE
      MOVE.L    #COURBE,PTR_COURBE      
      RTS 

SCROLLING:
      bsr       PUT_DATA 
      ADDI.W    #1,CPT_TEXTE
      CMPI.W    #4,CPT_TEXTE
      BNE.s     .next 
      bsr.s     SCROLLY 
      MOVE.W    #0,CPT_TEXTE
.next:bsr       PUTBUF
      RTS

SCROLLY:MOVEA.L   PTR_TEXTE,A3
      CLR.W     D1
      MOVE.B    (A3)+,D1
      CMP.W     #$FF,D1 
      BEQ.S     NEW_TEXT 
      SUBI.W    #32,D1 
      MULS      #16,D1 
      MOVEA.L   #FONTEs,A0 
      ADDA.W    D1,A0 
      MOVEA.L   #BUFFER_6,A1 
      MOVE.L    (A0)+,(A1)+ 
      MOVE.L    (A0)+,(A1)+ 
      MOVE.L    (A0)+,(A1)+ 
      MOVE.L    (A0)+,(A1)+ 
      MOVE.L    A3,PTR_TEXTE
      RTS 
      
NEW_TEXT:MOVE.L    #TEXTE,PTR_TEXTE
      BRA.S     SCROLLY 
PUT_SCROLL:LEA       BUFFER_3,A0
      MOVEA.L   Zorro_scr1,A1
      MOVE.W    BUFFER_2,D0
      MULS      #160,D0 
      ADDA.L    D0,A1 
      MOVE.W    BUFFER_1,D0
      MOVE.W    D0,D1 
      ANDI.W    #$FFF0,D0 
      DIVU      #2,D0 
      ADDA.W    D0,A1 
      ANDI.W    #$F,D1
      MULS      #$8A4,D1
      ADDA.L    D1,A0 
      CLR.L     (A1)
      CLR.L     8(A1) 
      CLR.L     16(A1)
      CLR.L     24(A1)
      CLR.L     32(A1)
      CLR.L     40(A1)
      CLR.L     48(A1)
      ADDA.W    #160,A1 
      CLR.L     (A1)
      CLR.L     8(A1) 
      CLR.L     16(A1)
      CLR.L     24(A1)
      CLR.L     32(A1)
      CLR.L     40(A1)
      CLR.L     48(A1)
      ADDA.W    #160,A1 
      CLR.L     (A1)
      CLR.L     8(A1) 
      CLR.L     16(A1)
      CLR.L     24(A1)
      CLR.L     32(A1)
      CLR.L     40(A1)
      CLR.L     48(A1)
      ADDA.W    #160,A1 
      MOVE.L    #0,(A1) 
      ADDQ.W    #4,A0 
      MOVE.L    (A0)+,8(A1) 
      MOVE.L    (A0)+,16(A1)
      MOVE.L    (A0)+,24(A1)
      MOVE.L    (A0)+,32(A1)
      MOVE.L    (A0)+,40(A1)
      MOVE.L    (A0)+,48(A1)
 rept	78
      ADDA.W    #160,A1 
      MOVE.L    (A0)+,(A1)
      MOVE.L    (A0)+,8(A1) 
      MOVE.L    (A0)+,16(A1)
      MOVE.L    (A0)+,24(A1)
      MOVE.L    (A0)+,32(A1)
      MOVE.L    (A0)+,40(A1)
      MOVE.L    (A0)+,48(A1)
 endr
 rept	3
      ADDA.W    #$A0,A1 
      CLR.L     (A1)
      CLR.L     8(A1) 
      CLR.L     16(A1)
      CLR.L     24(A1)
      CLR.L     32(A1)
      CLR.L     40(A1)
      CLR.L     48(A1)
 endr
      RTS 

PUT_COURBE:MOVEA.L   PTR_COURBE,A0
      MOVE.W    (A0)+,D0
      MOVE.W    (A0)+,D1
      CMP.W     #-1,D0 
      BEQ.S     NEW_COURBE 
      SUBI.W    #40,D0 
      MOVE.W    D0,BUFFER_1
      MOVE.W    D1,BUFFER_2
      MOVE.L    A0,PTR_COURBE
      RTS 
      
NEW_COURBE:MOVE.L    #COURBE,PTR_COURBE
      BRA.S       PUT_COURBE 
ZYVA:
 rept	4
      bsr       SCROLL 
 endr
      LEA       BUFFER_3,A6
 rept	15
      bsr.s       LIGNE 
      bsr.s       LIGNEBIS 
 endr
      bsr.s       LIGNE 
      RTS 
      
LIGNE:MOVEA.L   Zorro_scr1,A0
      MOVE.W    #$4E,D0 
.loop:MOVE.L    (A0),(A6)+
      MOVE.L    8(A0),(A6)+ 
      MOVE.L    16(A0),(A6)+
      MOVE.L    24(A0),(A6)+
      MOVE.L    32(A0),(A6)+
      MOVE.L    40(A0),(A6)+
      MOVE.L    48(A0),(A6)+
      ADDA.W    #$A0,A0 
      DBF       D0,.loop
      RTS 
      
LIGNEBIS:MOVEA.L   Zorro_scr1,A0
      MOVE.W    #78,D0 
.loop:
 rept	9
      ROXR      (A0)
      ADDQ.W    #8,A0 
 endr
      SUBA.W    #72,A0 
 rept	9
      ROXR      2(A0) 
      ADDQ.W    #8,A0 
 endr
      ADDA.W    #88,A0 
      DBF       D0,.loop
      RTS 
      
SCROLL:MOVEA.L   Zorro_scr1,A0
      MOVE.W    #78,D0 
.loop:ROXL      64(A0)
      ROXL      56(A0)
      ROXL      48(A0)
      ROXL      40(A0)
      ROXL      32(A0)
      ROXL      24(A0)
      ROXL      16(A0)
      ROXL      8(A0) 
      ROXL      (A0)
      ROXL      66(A0)
      ROXL      58(A0)
      ROXL      50(A0)
      ROXL      42(A0)
      ROXL      34(A0)
      ROXL      26(A0)
      ROXL      18(A0)
      ROXL      10(A0)
      ROXL      2(A0) 
      ADDA.W    #160,A0 
      DBF       D0,.loop
      RTS 
      
PUT_DATA:MOVEA.L   #BUFFER_4,A6 
      MOVEA.L   Zorro_scr1,A2
      lea	      -160*14(a2),a2
      ADDQ.W    #6,A2 
      MOVE.L    DATA_3,DATA_4 
      bsr       SWAP_DATA 
      MOVEA.L   A2,A1 
      ADDA.W    D0,A1 
      MOVEA.L   (A6)+,A0
 rept	  17    
      bsr       PUT_MY_SCROLL 
      ADDQ.W    #1,A2 
      bsr       SWAP_DATA 
      MOVEA.L   A2,A1 
      ADDA.W    D0,A1 
      MOVEA.L   (A6)+,A0
      bsr       PUT_MY_SCROLL 
      ADDQ.W    #7,A2 
      bsr       SWAP_DATA 
      MOVEA.L   A2,A1 
      ADDA.W    D0,A1 
      MOVEA.L   (A6)+,A0
 endr
      bsr.s     PUT_MY_SCROLL 
      ADDQ.W    #1,A2 
      bsr       SWAP_DATA 
      MOVEA.L   A2,A1 
      ADDA.W    D0,A1 
      MOVEA.L   (A6)+,A0
      bsr.s     PUT_MY_SCROLL 
      ADDQ.W    #7,A2 
      bsr       SWAP_DATA 
      MOVEA.L   A2,A1 
      ADDA.W    D0,A1 
      MOVEA.L   (A6)+,A0
      bsr.s     PUT_MY_SCROLL 
      ADDQ.W    #1,A2 
      bsr       SWAP_DATA 
      MOVEA.L   A2,A1 
      ADDA.W    D0,A1 
      MOVEA.L   (A6)+,A0
      bsr.s     PUT_MY_SCROLL 
      ADDQ.W    #7,A2 
      bsr       SWAP_DATA 
      MOVEA.L   A2,A1 
      ADDA.W    D0,A1 
      MOVEA.L   (A6)+,A0
      bsr.s     PUT_MY_SCROLL 
      ADDQ.W    #1,A2 
      bsr       SWAP_DATA 
      MOVEA.L   A2,A1 
      ADDA.W    D0,A1 
      MOVEA.L   (A6)+,A0      	
      bsr.s     PUT_MY_SCROLL 
      ADDQ.W    #7,A2 
      SUBQ.L    #2,DATA_4
      CMPI.L    #DATA_1,DATA_4
      BNE.s     .init 
      MOVE.L    #DATA_2,DATA_4
.init:MOVE.L    DATA_4,DATA_3 
      RTS 
      
PUT_MY_SCROLL:
      CLR.B     -480(A1)
      CLR.B     -320(A1)
      CLR.B     -160(A1)
      MOVE.B    (A0)+,(A1)
      MOVE.B    (A0)+,160(A1) 
      MOVE.B    (A0)+,320(A1) 
      MOVE.B    (A0)+,480(A1) 
      MOVE.B    (A0)+,640(A1) 
      MOVE.B    (A0)+,800(A1) 
      MOVE.B    (A0)+,960(A1) 
      MOVE.B    (A0)+,1120(A1)
      MOVE.B    (A0)+,1280(A1)
      MOVE.B    (A0)+,1440(A1)
      MOVE.B    (A0)+,1600(A1)
      MOVE.B    (A0)+,1760(A1)
      MOVE.B    (A0)+,1920(A1)
      MOVE.B    (A0)+,2080(A1)
      MOVE.B    (A0)+,2240(A1)
      MOVE.B    (A0)+,2400(A1)
      MOVE.B    (A0)+,2560(A1)
      MOVE.B    (A0)+,2720(A1)
      MOVE.B    (A0)+,2880(A1)
      MOVE.B    (A0)+,3040(A1)
      MOVE.B    (A0)+,3200(A1)
      MOVE.B    (A0)+,3360(A1)
      MOVE.B    (A0)+,3520(A1)
      MOVE.B    (A0)+,3680(A1)
      MOVE.B    (A0)+,3840(A1)
      MOVE.B    (A0)+,4000(A1)
      MOVE.B    (A0)+,4160(A1)
      MOVE.B    (A0)+,4320(A1)
      MOVE.B    (A0)+,4480(A1)
      MOVE.B    (A0)+,4640(A1)
      MOVE.B    (A0)+,4800(A1)
      MOVE.B    (A0)+,4960(A1)
      CLR.B     5120(A1)
      CLR.B     5280(A1)
      RTS 
      
SWAP_DATA:MOVEA.L   DATA_3,A3
      MOVE.W    (A3)+,D0
      ADDI.W    #160*60,D0 
      MOVE.L    A3,DATA_3
      RTS 

*
MAKE_STARS:
      LEA       DATAI_2(PC),A0
      LEA       BUFFERI_2,A1
      LEA       BUFFERI_1,A2
      LEA       DATAI_3(PC),A3
      MOVE.W    #140-1,D7 
BIG_LOOP:SWAP      D7
      MOVEQ     #0,D0 
      MOVEQ     #0,D1 
      MOVE.W    (A0)+,D0
      MOVE.W    (A0)+,D1
      MOVE.L    A1,560(A2)
      MOVE.L    A1,(A2)+
      CLR.W     D7
END_LOOP:MOVEQ     #0,D2 
      MOVE.W    (A0)+,D2
      MOVE.L    D0,D3 
      MOVE.L    D1,D4 
      MULS      #$3E8,D3
      MULS      #$3E8,D4
      DIVS      D2,D3 
      DIVS      D2,D4 
      MOVE.L    D0,D5 
      MOVE.L    D1,D6 
      MULS      182(A3),D0
      MULS      2(A3),D6
      ADDI.L    #$8000,D0 
      ADDI.L    #$8000,D6 
      ADD.L     D0,D0 
      ADD.L     D6,D6 
      SWAP      D0
      SWAP      D6
      ADD.W     D6,D0 
      ANDI.L    #$FFFF,D0 
      NEG.W     D5
      MULS      2(A3),D5
      MULS      182(A3),D1
      ADDI.L    #$8000,D5 
      ADDI.L    #$8000,D1 
      ADD.L     D5,D5 
      ADD.L     D1,D1 
      SWAP      D5
      SWAP      D1
      ADD.W     D5,D1 
      ANDI.L    #$FFFF,D1 
      ADDI.W    #160,D3 
      ADDI.W    #100,D4 
      SUBI.W    #360,-(A0) 
      CMP.W     #320-1,D3
      BHI.S     INIT_ETOILE 
      CMP.W     #200-1,D4 
      BHI.S     INIT_ETOILE 
      MOVE.W    D3,D5 
      ANDI.W    #$F,D3
      SUB.W     D3,D5 
      LSR.W     #1,D5 
      MULU      #160,D4 
      ADD.W     D5,D4 
      CMP.W     #40,D7 
      BGT.S     .next 
      ADDQ.W    #4,D4 
.next:MOVE.W    D4,(A1)+
      ADD.W     D3,D3 
      MOVE.W    DATAI_4(PC,D3.W),(A1)+
      ADDQ.W    #1,D7 
      BRA       END_LOOP 
DATAI_4:DC.B      $80,$00,'@',$00,' ',$00,$10,$00 
      DC.B      $08,$00,$04,$00,$02,$00,$01,$00 
      DC.B      $00,$80,$00,'@',$00,' ',$00,$10 
      DC.B      $00,$08,$00,$04,$00,$02,$00,$01 
SOLO_LOOP:SWAP      D7
      ADDQ.L    #2,A0 
      DBF       D7,BIG_LOOP
      MOVE.L    A1,DATAI_1
      BRA.S     NEXT_STAR 
INIT_ETOILE:MOVE.W    #-1,(A1)+
      BRA.S     SOLO_LOOP 
NEXT_STAR:LEA       BUFFERI_1,A0
      MOVEQ     #0,D0 
      MOVE.W    #140-1,D7 
LOOPA:MOVEA.L   (A0),A1 
      ADDA.L    D0,A1 
      CMPA.L    4(A0),A1
      BLT.S     .next1 
      MOVE.L    D0,D1 
      MOVEA.L   4(A0),A2
.next:LSR.L     #1,D1 
      ANDI.L    #$FFFFFFFC,D1 
      BEQ.S     .next0 
      SUBA.L    D1,A1 
      CMPA.L    A2,A1 
      BGE.S     .next 
      DIVU      D1,D0 
      ANDI.L    #$FFFFFFFC,D0 
      BRA.S     .next1 
.next0:MOVEA.L   (A0),A1 
.next1:MOVE.L    A1,(A0)+
      ADDI.L    #$10,D0 
      DBF       D7,LOOPA
      RTS 

CLS_STARS:MOVEM.L   PUSH_IT(PC),A0-A1 
      MOVEA.L   A0,A2 
      MOVEM.L   A1-A2,PUSH_IT 
      JMP       (A1)
STARS:MOVEA.L   Zorro_scr2,A0
      LEA       BUFFERI_1,A1
      MOVEA.L   PUSH_IT(PC),A2
      MOVE.L    A0,4(A2)
      LEA       10(A2),A2 
      MOVE.W    #140-1,D2 
.loop:MOVEA.L   (A1),A3 
      MOVE.W    (A3)+,D0
      BPL.S     .next 
      MOVEA.L   560(A1),A3
      MOVE.W    (A3)+,D0
.next:MOVE.W    (A3)+,D1
      MOVE.L    A3,(A1)+
      OR.W      D1,0(A0,D0.W) 
      MOVE.W    D0,(A2) 
      ADDQ.L    #4,A2 
      DBF       D2,.loop
      RTS 

CLEAR_TMP:MOVEQ     #0,D0 
      LEA       $F0600,A0 
 rept	140
      MOVE.W    D0,0(A0)
 endr
      RTS 

DIGITS:MOVEA.L   #DATA_DIGIT,A0 
      MOVEQ     #0,D1
      MOVEQ     #0,D0
      MOVE.B    #0,$FF8800.L
      MOVE.B    $FF8800.L,D1
      LSL.W     #4,D1 
      MOVE.B    #1,$FF8800.L
      ADD.B     $FF8800.L,D1
      ANDI.W    #$FFF,D1
      DIVU      #$33,D1 
      MOVE.B    #8,$FF8800.L
      MOVE.B    $FF8800.L,D0
      ANDI.W    #$F,D0
      TST.B     D0
      BNE.s     digi01 
      MOVE.B    #1,D0 
digi01:MOVE.B    D0,0(A0,D1.W) 
      MOVEQ     #0,D1
      MOVEQ     #0,D0
      MOVE.B    #2,$FF8800.L
      MOVE.B    $FF8800.L,D1
      LSL.W     #4,D1 
      MOVE.B    #3,$FF8800.L
      ADD.B     $FF8800.L,D1
      ANDI.W    #$FFF,D1
      DIVU      #$33,D1 
      MOVE.B    #9,$FF8800.L
      MOVE.B    $FF8800.L,D0
      ANDI.W    #$F,D0
      TST.B     D0
      BNE.s     digi02 
      MOVE.B    #1,D0 
digi02:MOVE.B    D0,0(A0,D1.W) 
      MOVEQ     #0,D1
      MOVEQ     #0,D0
      MOVE.B    #4,$FF8800.L
      MOVE.B    $FF8800.L,D1
      LSL.W     #4,D1 
      MOVE.B    #5,$FF8800.L
      ADD.B     $FF8800.L,D1
      ANDI.W    #$FFF,D1
      DIVU      #$33,D1 
      MOVE.B    #$A,$FF8800.L 
      MOVE.B    $FF8800.L,D0
      ANDI.W    #$F,D0
      TST.B     D0
      BNE.s     digi03 
      MOVE.B    #1,D0 
digi03:MOVE.B    D0,0(A0,D1.W) 
      MOVEA.L   Zorro_scr2,A1
      lea	      160*186(a1),a1
      addq.w    #6,a1
      MOVEA.L   #DATA_DIGIT,A0 
      MOVE.W    #$13,D3 
digi04:TST.B     (A0)
      BEQ.s     digi07 
      SUBI.B    #1,(A0) 
      MOVEQ     #0,D1
      MOVEQ     #0,D2
      MOVE.B    (A0),D1 
      MOVE.B    #$F,D2
      SUB.B     D1,D2 
      MOVE.W    #$960,D0
digi05:ORI.B     #$7E,0(A1,D0.W) 
      SUBI.W    #$A0,D0 
      DBF       D1,digi05
digi06:ANDI.B    #$81,0(A1,D0.W) 
      SUBI.W    #$A0,D0 
      DBF       D2,digi06
digi07:ADDA.L    #1,A0 
      TST.B     (A0)
      BEQ.s     digi10 
      SUBI.B    #1,(A0) 
      MOVEQ     #0,D1
      MOVEQ     #0,D2
      MOVE.B    (A0),D1 
      MOVE.B    #$F,D2
      SUB.B     D1,D2 
      MOVE.W    #$960,D0
digi08:ORI.B     #$7E,0(A1,D0.W) 
      SUBI.W    #$A0,D0 
      DBF       D1,digi08
digi09:ANDI.B    #$81,0(A1,D0.W) 
      SUBI.W    #$A0,D0 
      DBF       D2,digi09
digi10:ADDA.L    #1,A0 
      ADDA.L    #1,A1 
      MOVE.B    (A0),D1 
      TST.B     D1
      BEQ.s     digi13 
      SUBI.B    #1,(A0) 
      MOVEQ     #0,D1
      MOVEQ     #0,D2
      MOVE.B    (A0),D1 
      MOVE.B    #$F,D2
      SUB.B     D1,D2 
      MOVE.W    #$960,D0
digi11:ORI.B     #$7E,0(A1,D0.W) 
      SUBI.W    #$A0,D0 
      DBF       D1,digi11
digi12:ANDI.B    #$81,0(A1,D0.W) 
      SUBI.W    #$A0,D0 
      DBF       D2,digi12
digi13:ADDA.L    #1,A0 
      MOVE.B    (A0),D1 
      TST.B     D1
      BEQ.s     digi16 
      SUBI.B    #1,(A0) 
      MOVEQ     #0,D1
      MOVEQ     #0,D2
      MOVE.B    (A0),D1 
      MOVE.B    #$F,D2
      SUB.B     D1,D2 
      MOVE.W    #$960,D0
digi14:ORI.B     #$7E,0(A1,D0.W) 
      SUBI.W    #$A0,D0 
      DBF       D1,digi14
digi15:ANDI.B    #$81,0(A1,D0.W) 
      SUBI.W    #$A0,D0 
      DBF       D2,digi15
digi16:ADDA.L    #1,A0 
      ADDA.L    #7,A1 
      DBF       D3,digi04
      RTS 
      
PUT_LOGO:
	move.l Zorro_scr1,a0
	lea	160*2(a0),a0
	
	lea LOGO,a1
	moveq #15,d1
.line	movem.l (a1),d2-7/a2-5
	movem.l d2-7/a2-5,(a0)
	movem.l 40(a1),d2-7/a2-5
	movem.l d2-7/a2-5,40(a0)
	movem.l 80(a1),d2-7/a2-5
	movem.l d2-7/a2-5,80(a0)
	movem.l 120(a1),d2-7/a2-5
	movem.l d2-7/a2-5,120(a0)	
	add.l #160,d0
	lea 160(a0),a0
	lea 160(a1),a1
	dbra d1,.line

	lea	-160*16(a0),a0
.erase:
	moveq.l #1,d1
	moveq.l #0,d5
.wline:
x	set 0
 rept 5
	move.l d5,x(a0)
x	set x+4
 endr
	add.l #160,d0
	lea 160(a0),a0
	dbra d1,.wline
	RTS      

CLEAR_BUG
	* Part Scrolling Y
	MOVEA.L Zorro_scr1,A0
	lea	160*87(a0),a0
	ADDQ.L #6,A0
	MOVEQ #0,D1
	MOVEQ #7,D0
i	SET 0
.lp
 rept 160
	MOVE.W D1,i(A0)
i	SET i+8
 endr
	LEA 1280(A0),A0
	DBF D0,.lp

	* Part Digits
	MOVEa.L Zorro_scr1,A0
	lea	160*189(a0),a0
	ADDQ.L #6,A0
	moveq.l #10,d1
	moveq.l #0,d5
.lp2
j	set 0
 rept 40
	move.l d5,j(a0)
j	set j+4
 endr
	add.l #160,d0
	lea 160(a0),a0
	dbra d1,.lp2
	RTS

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
	rts

wart	
	move.l	d0,-(sp)
	move.l	$466.w,d0
att	
	cmp.l	$466.w,d0
	beq.s	att
	move.l	(sp)+,d0
	rts

fadeon	
	move.w	#8-1,d0	8 stages
.loop1	move.w	#16-1,d1	16 colours
	move.l	#$ffff8240,a0	offset of palette
	move.l	a2,a1	a2 points to new colours
.loop2	move.w	(a0),d2
	andi.w	#$777,d2	Eliminate garbage
	move.w	d2,d3
	andi.w	#$F,d2	d2 contains B value
	lsr.w	#4,d3
	move.w	d3,d4
	andi.w	#$F,d3	d3 contains G value
	lsr.w	#4,d4
	andi.w	#$F,d4	d4 contains R value
	move.w	(a1)+,d5
	andi.w	#$777,d5	As above!
	move.w	d5,d6
	andi.w	#$F,d5	d5 contains B value
	lsr.w	#4,d6
	move.w	d6,d7
	andi.w	#$F,d6	d6 contains G value
	lsr.w	#4,d7
	andi.w	#$F,d7	d7 contains R value
	cmp.w	d2,d5
	beq.s	.end1	B already new colour
	addq.w	#1,d2
.end1	cmp.w	d3,d6
	beq.s	.end2	G already new colour
	addq.w	#1,d3
.end2	cmp.w	d4,d7
	beq.s	.end3	R already new colour
	addq.w	#1,d4
.end3	lsl.w	#8,d4
	lsl.w	#4,d3
	or.w	d4,d2
	or.w	d3,d2	d2 now contains RGB value
	move.w	d2,(a0)+
	dbra	d1,.loop2	Next colour
	rept	6
	bsr	Wait_vbl
	endr
	dbra	d0,.loop1	Next stage
	rts

fadeoff	
	move.w	#8-1,d0	Maximum of 8 stages
.loop1 	move.w	#16-1,d1	16 colours!
	move.l	#$ffff8240,a0	offset of palette
.loop2	move.w	(a0),d2
	andi.w	#$777,d2	Eliminate garbage
	move.w	d2,d3
	andi.w	#$F,d2	d2 contains B value
	lsr.w	#4,d3
	move.w	d3,d4
	andi.w	#$F,d3	d3 contains G value
	lsr.w	#4,d4
	andi.w	#$F,d4	d4 contains R value
	tst.w	d2
	beq.s	.end1	B already zero
	subq.w	#1,d2
.end1	tst.w	d3
	beq.s	.end2	G already zero
	subq.w	#1,d3
.end2	tst.w	d4
	beq.s	.end3	R already zero
	subq.w	#1,d4
.end3	lsl.w	#8,d4
	lsl.w	#4,d3
	or.w	d4,d2
	or.w	d3,d2	D2 now contains RGB value
	move.w	d2,(a0)+
	dbra	d1,.loop2	Next colour
	rept	6
	bsr	Wait_vbl
	endr
	dbra	d0,.loop1	Next stage
	rts
		                      
	SECTION	DATA

Pal:	
	dc.w	$0000,$0777,$0fff,$0fff,$0444,$0fff,$0fff,$0fff
	dc.w	$0667,$0557,$0CCE,$0335,$0446,$0AAC,$0BBD,$0EEF

TEXTE:
	DC.B	'                            '
	DC.B	' ABCDEFGHIJKLMNOPQRSTUVWXYZ '
	DC.B	'0123456789 ',$27,'.()?:!,;+-'
	DC.B	$FF,$00
	
DATA_1:		dc	$1C20,$1CC0,$1E00,$1EA0
		dc	$1FE0,$2080,$21C0,$2260
		dc	$23A0,$2440,$2580,$2620
		dc	$2760,$2800,$28A0,$29E0
		dc	$2A80,$2B20,$2C60,$2D00
		dc	$2DA0,$2E40,$2EE0,$2F80
		dc	$3020,$30C0,$3160,$3200
		dc	$32A0,$3340,$3340,$33E0
		dc	$33E0,$3480,$3480,$3520
		dc	$3520,$35C0,$35C0,$35C0
		dc	$35C0,$35C0,$35C0,$35C0
		dc	$35C0,$35C0,$35C0,$35C0
		dc	$3520,$3520,$3520,$3480
		dc	$3480,$33E0,$33E0,$3340
		dc	$32A0,$32A0,$3200,$3160
		dc	$30C0,$30C0,$2F80,$2F80
		dc	$2EE0,$2E40,$2DA0,$2D00
		dc	$2BC0,$2B20,$2A80,$29E0
		dc	$2940,$28A0,$2800,$26C0
		dc	$2620,$2580,$24E0,$2440
		dc	$2300,$2260,$21C0,$2120
		dc	$1FE0,$1F40,$1EA0,$1E00
		dc	$1D60,$1CC0,$1C20,$1AE0
		dc	$1A40,$19A0,$1900,$1860
		dc	$17C0,$1720,$1680,$15E0
		dc	$15E0,$1540,$14A0,$1400
		dc	$1360,$1360,$12C0,$1220
		dc	$1220,$1180,$1180,$10E0
		dc	$10E0,$1040,$1040,$1040
		dc	$1040,$0FA0,$0FA0,$0FA0
		dc	$0FA0,$0FA0,$0FA0,$0FA0
		dc	$0FA0,$0FA0,$0FA0,$0FA0
		dc	$0FA0,$0FA0,$1040,$1040
		dc	$1040,$1040,$10E0,$10E0
		dc	$1180,$1180,$1180,$1220
		dc	$1220,$1220,$12C0,$12C0
		dc	$1360,$1360,$1400,$1400
		dc	$14A0,$1540,$1540,$15E0
		dc	$15E0,$1680,$1720,$1720
		dc	$17C0,$17C0,$1860,$1860
		dc	$1860,$1900,$1900,$19A0
		dc	$19A0,$19A0,$1A40,$1A40
		dc	$1AE0,$1AE0,$1AE0,$1AE0
		dc	$1B80,$1B80,$1B80,$1B80
		dc	$1B80,$1B80,$1B80,$1B80
		dc	$1C20,$1C20,$1B80,$1B80
		dc	$1B80,$1B80,$1B80,$1B80
		dc	$1B80,$1B80,$1AE0,$1AE0
		dc	$1AE0,$1A40,$1A40,$1A40
		dc	$19A0,$19A0,$1900,$1900
		dc	$1860,$1860,$1860,$17C0
		dc	$17C0,$1720,$1720,$1680
		dc	$15E0,$15E0,$1540,$1540
		dc	$14A0,$14A0,$1400,$1400
		dc	$1360,$1360,$12C0,$12C0
		dc	$1220,$1220,$1180,$1180
		dc	$1180,$1180,$10E0,$10E0
		dc	$1040,$1040,$1040,$1040
		dc	$0FA0,$1040,$0FA0,$0FA0
		dc	$0FA0,$0FA0,$0FA0,$0FA0
		dc	$0FA0,$0FA0,$0FA0,$1040
		dc	$1040,$1040,$1040,$10E0
		dc	$10E0,$1180,$1180,$1220
		dc	$1220,$12C0,$12C0,$1360
		dc	$1360,$1400,$14A0,$1540
		dc	$15E0,$1680,$1680,$1720
		dc	$17C0,$1860,$1900,$19A0
		dc	$1A40,$1AE0,$1B80,$1CC0
		dc	$1D60,$1E00,$1EA0,$1F40
		dc	$1FE0,$2120,$21C0,$2260
		dc	$2300,$23A0,$24E0,$2580
		dc	$2620,$26C0,$2800,$28A0
		dc	$2940,$29E0,$2A80,$2B20
		dc	$2BC0,$2C60,$2DA0,$2DA0
		dc	$2EE0,$2EE0,$2F80,$3020
		dc	$30C0,$3160,$3200,$3200
		dc	$32A0,$3340,$33E0,$33E0
		dc	$3480,$3480,$3520,$3520
		dc	$3520,$35C0,$35C0,$35C0
		dc	$35C0,$35C0,$35C0,$35C0
		dc	$35C0,$35C0,$35C0,$3520
		dc	$3520,$3520,$3480,$3480
		dc	$33E0,$33E0,$3340,$32A0
		dc	$32A0,$3200,$3160,$30C0
		dc	$3020,$2F80,$2EE0,$2E40
		dc	$2DA0,$2D00,$2C60,$2B20
		dc	$2A80,$29E0,$28A0,$2800
		dc	$2760,$2620,$2580,$2440
		dc	$23A0,$2260,$21C0,$2080
		dc	$1FE0,$1EA0,$1E00,$1CC0
		dc	$1C20,$1AE0,$19A0,$1900
		dc	$17C0,$1720,$15E0,$1540
		dc	$1400,$1360,$1220,$1180
		dc	$1040,$0FA0,$0F00,$0DC0
		dc	$0D20,$0C80,$0B40,$0AA0
		dc	$0A00,$0960,$08C0,$0820
		dc	$0780,$06E0,$0640,$05A0
		dc	$0500,$0460,$0460,$03C0
		dc	$03C0,$0320,$0320,$0280
		dc	$0280,$01E0,$01E0,$01E0
		dc	$01E0,$01E0,$01E0,$01E0
		dc	$01E0,$01E0,$01E0,$01E0
		dc	$0280,$0280,$0280,$0320
		dc	$0320,$03C0,$03C0,$0460
		dc	$0500,$0500,$05A0,$0640
		dc	$06E0,$06E0,$0820,$0820
		dc	$08C0,$0960,$0A00,$0AA0
		dc	$0BE0,$0C80,$0D20,$0DC0
		dc	$0E60,$0F00,$0FA0,$10E0
		dc	$1180,$1220,$12C0,$1360
		dc	$14A0,$1540,$15E0,$1680
		dc	$17C0,$1860,$1900,$19A0
		dc	$1A40,$1AE0,$1B80,$1CC0
		dc	$1D60,$1E00,$1EA0,$1F40
		dc	$1FE0,$2080,$2120,$21C0
		dc	$21C0,$2260,$2300,$23A0
		dc	$2440,$2440,$24E0,$2580
		dc	$2580,$2620,$2620,$26C0
		dc	$26C0,$2760,$2760,$2760
		dc	$2760,$2800,$2800,$2800
		dc	$2800,$2800,$2800,$2800
		dc	$2800,$2800,$2800,$2800
		dc	$2800,$2800,$2760,$2760
		dc	$2760,$2760,$26C0,$26C0
		dc	$2620,$2620,$2620,$2580
		dc	$2580,$2580,$24E0,$24E0
		dc	$2440,$2440,$23A0,$23A0
		dc	$2300,$2260,$2260,$21C0
		dc	$21C0,$2120,$2080,$2080
		dc	$1FE0,$1FE0,$1F40,$1F40
		dc	$1F40,$1EA0,$1EA0,$1E00
		dc	$1E00,$1E00,$1D60,$1D60
		dc	$1CC0,$1CC0,$1CC0,$1CC0
		dc	$1C20,$1C20,$1C20,$1C20
		dc	$1C20,$1C20,$1C20,$1C20
		dc	$1C20,$1B80,$1C20,$1C20
		dc	$1C20,$1C20,$1C20,$1C20
		dc	$1C20,$1C20,$1CC0,$1CC0
		dc	$1CC0,$1D60,$1D60,$1D60
		dc	$1E00,$1E00,$1EA0,$1EA0
		dc	$1F40,$1F40,$1F40,$1FE0
		dc	$1FE0,$2080,$2080,$2120
		dc	$21C0,$21C0,$2260,$2260
		dc	$2300,$2300,$23A0,$23A0
		dc	$2440,$2440,$24E0,$24E0
		dc	$2580,$2580,$2620,$2620
		dc	$2620,$2620,$26C0,$26C0
		dc	$2760,$2760,$2760,$2760
		dc	$2800,$2760,$2800,$2800
		dc	$2800,$2800,$2800,$2800
		dc	$2800,$2800,$2800,$2760
		dc	$2760,$2760,$2760,$26C0
		dc	$26C0,$2620,$2620,$2580
		dc	$2580,$24E0,$24E0,$2440
		dc	$2440,$23A0,$2300,$2260
		dc	$21C0,$2120,$2120,$2080
		dc	$1FE0,$1F40,$1EA0,$1E00
		dc	$1D60,$1CC0,$1C20,$1AE0
		dc	$1A40,$19A0,$1900,$1860
		dc	$17C0,$1680,$15E0,$1540
		dc	$14A0,$1400,$12C0,$1220
		dc	$1180,$10E0,$0FA0,$0F00
		dc	$0E60,$0DC0,$0D20,$0C80
		dc	$0BE0,$0B40,$0A00,$0A00
		dc	$08C0,$08C0,$0820,$0780
		dc	$06E0,$0640,$05A0,$05A0
		dc	$0500,$0460,$03C0,$03C0
		dc	$0320,$0320,$0280,$0280
		dc	$0280,$01E0,$01E0,$01E0
		dc	$01E0,$01E0,$01E0,$01E0
		dc	$01E0,$01E0,$01E0,$0280
		dc	$0280,$0280,$0320,$0320
		dc	$03C0,$03C0,$0460,$0500
		dc	$0500,$05A0,$0640,$06E0
		dc	$0780,$0820,$08C0,$0960
		dc	$0A00,$0AA0,$0B40,$0C80
		dc	$0D20,$0DC0,$0F00,$0FA0
		dc	$1040,$1180,$1220,$1360
		dc	$1400,$1540,$15E0,$1720
		dc	$17C0,$1900,$19A0,$1AE0
DATA_2:
		dc	$1C20,$1CC0,$1E00,$1EA0
		dc	$1FE0,$2080,$21C0,$2260
		dc	$23A0,$2440,$2580,$2620
		dc	$2760,$2800,$28A0,$29E0
		dc	$2A80,$2B20,$2C60,$2D00
		dc	$2DA0,$2E40,$2EE0,$2F80
		dc	$3020,$30C0,$3160,$3200
		dc	$32A0,$3340,$3340,$33E0
		dc	$33E0,$3480,$3480,$3520
		dc	$3520,$35C0,$35C0,$35C0
		dc	$FFFF,$FFFF
		even
FONTE_D:DCB.W     16,0
ptrFNT_05D:DCB.W     16,0
ptrFNT_05E:DCB.W     16,0
ptrFNT_05F:DCB.W     16,0
ptrFNT_060:DCB.W     16,0
ptrFNT_061:		dc	$070F,$1F3F,$7FFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$7F00,$7FFF
		dc	$FFFF,$FFFF,$FFFF,$7F00
ptrFNT_062:		dc	$0080,$8080,$8080,$8080
		dc	$8080,$8080,$8080,$8080
		dc	$8080,$8080,$0000,$0080
		dc	$8080,$8080,$8080,$0000
ptrFNT_063:DCB.W     16,0
ptrFNT_064:		dc	$1F3F,$3F3F,$3F3F,$3F3F
		dc	$1F00,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_065:		dc	$C7EF,$EFEF,$EFEF,$EFEF
		dc	$C700,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_066:		dc	$F0F8,$F8F8,$F8F8,$F8F8
		dc	$F000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_067:DCB.W     16,0
ptrFNT_068:DCB.W     16,0
ptrFNT_069:DCB.W     16,0
ptrFNT_06A:DCB.W     16,0
ptrFNT_06B:DCB.W     16,0
ptrFNT_06C:DCB.W     16,0
ptrFNT_06D:		dc	$7FFF,$FFFF,$FFFF,$FFFF
		dc	$7F00,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_06E:		dc	$C0E0,$E0E0,$E0E0,$E0E0
		dc	$C000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_06F:DCB.W     16,0
ptrFNT_070:DCB.W     16,0
ptrFNT_071:DCB.W     16,0
ptrFNT_072:DCB.W     16,0
ptrFNT_073:DCB.W     16,0
ptrFNT_074:DCB.W     16,0
ptrFNT_075:DCB.W     16,0
ptrFNT_076:DCB.W     16,0
ptrFNT_077:DCB.W     16,0
ptrFNT_078:DCB.W     16,0
ptrFNT_079:		dc	$0007,$0F1F,$3F7F,$7FFF
		dc	$FFFF,$FFFF,$FFFE,$FC78
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_07A:		dc	$00C0,$E0E0,$E0E0,$E0E0
		dc	$E0C0,$C080,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_07B:DCB.W     16,0
ptrFNT_07C:		dc	$0000,$0000,$0103,$0707
		dc	$0F0F,$0F0F,$0F0F,$0F0F
		dc	$0F0F,$0F0F,$0F0F,$0F0F
		dc	$0707,$0301,$0000,$0000
ptrFNT_07D:		dc	$001F,$7FFF,$FFFF,$FFFF
		dc	$FFFF,$FFFC,$FCFC,$FCFC
		dc	$FCFC,$FCFC,$FCFF,$FFFF
		dc	$FFFF,$FFFF,$FF7F,$1F00
ptrFNT_07E:		dc	$00FE,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FE00,$0000,$0000
		dc	$0000,$0000,$00FE,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FE00
ptrFNT_07F:DCB.W     16,0
ptrFNT_080:		dc	$0000,$0101,$0101,$0101
		dc	$0101,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0101
		dc	$0101,$0101,$0101,$0000
ptrFNT_081:		dc	$00FF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FF00,$0000,$0000
		dc	$0000,$0000,$00FF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FF00
ptrFNT_082:		dc	$00F0,$FCFE,$FFFF,$FFFF
		dc	$FFFF,$FF7F,$7F7F,$7F7F
		dc	$7F7F,$7F7F,$7FFF,$FFFF
		dc	$FFFF,$FFFF,$FEFC,$F000
ptrFNT_083:		dc	$0000,$0000,$0080,$C0C0
		dc	$E0E0,$E0E0,$E0E0,$E0E0
		dc	$E0E0,$E0E0,$E0E0,$E0E0
		dc	$C0C0,$8000,$0000,$0000
ptrFNT_084:		dc	$0000,$0000,$0000,$0000
		dc	$0101,$0101,$080E,$0300
		dc	$0000,$0000,$0001,$0306
		dc	$0000,$0000,$0000,$0000
ptrFNT_085:		dc	$0000,$0000,$0000,$0000
		dc	$0202,$0286,$85C7,$E67C
		dc	$1E1B,$784C,$CE8B,$0908
		dc	$0800,$0000,$0000,$0000
ptrFNT_086:		dc	$0000,$0000,$0000,$070C
		dc	$1830,$60C0,$8000,$0000
		dc	$00FC,$0000,$0000,$C060
		dc	$3000,$0000,$0000,$0000
ptrFNT_087:DCB.W     16,0
ptrFNT_088:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$1F3F,$3F3F,$3F3F
		dc	$3F3F,$3F1F,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_089:		dc	$0000,$0000,$3F7F,$7F7F
		dc	$7F7F,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$7F7F,$7F7F
		dc	$7F3F,$0000,$0000,$0000
ptrFNT_08A:		dc	$0000,$0000,$80C0,$C0C0
		dc	$C0C0,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$C0C0,$C0C0
		dc	$C080,$0000,$0000,$0000
ptrFNT_08B:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0080,$8080,$8080
		dc	$8080,$8000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_08C:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0101
		dc	$0101,$0101,$0101,$0000
ptrFNT_08D:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$071F,$3F7F,$FFFF,$FFFF
		dc	$FFFF,$FFFE,$FCF8,$E000
ptrFNT_08E:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$80C0,$C0C0,$C0C0,$C0C0
		dc	$8080,$0000,$0000,$0000
ptrFNT_08F:DCB.W     16,0
ptrFNT_090:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0F1F,$1F1F,$1F1F
		dc	$1F1F,$0F00,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_091:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FF00,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_092:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FF00,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_093:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$E0F0,$F0F0,$F0F0
		dc	$F0F0,$E000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_094:DCB.W     16,0
ptrFNT_095:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$001F,$3F3F
		dc	$3F3F,$3F3F,$3F1F,$0000
ptrFNT_096:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$00F0,$F8F8
		dc	$F8F8,$F8F8,$F8F0,$0000
ptrFNT_097:DCB.W     16,0
ptrFNT_098:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0103
		dc	$070F,$1F3F,$7F7F,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$7F00
ptrFNT_099:		dc	$0000,$0000,$0000,$0103
		dc	$070F,$1F3F,$7FFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FEFC,$F8F0,$E0C0,$0000
ptrFNT_09A:		dc	$0000,$0F3F,$7FFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FEFC,$F8F0,$E0C0,$8000
		dc	$0000,$0000,$0000,$0000
ptrFNT_09B:		dc	$0000,$FCFE,$FEFE,$FEFE
		dc	$FCFC,$F8F0,$E0C0,$8000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_09C:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0001,$0101,$0103
		dc	$0303,$0303,$0303,$0303
		dc	$0301,$0100,$0000,$0000
ptrFNT_09D:		dc	$0000,$0000,$0107,$0F1F
		dc	$3F7C,$F8F0,$F0E0,$E0E0
		dc	$C0C1,$C3C7,$CFDF,$DFFE
		dc	$FEFC,$F8FE,$FF7F,$1F07
ptrFNT_09E:		dc	$0000,$007C,$FFFF,$FFCF
		dc	$0103,$0303,$0F1F,$3F7E
		dc	$F8F8,$F0E0,$C080,$0000
		dc	$0000,$010F,$FFFF,$FFFC
ptrFNT_09F:		dc	$0000,$0000,$C0E0,$F0F8
		dc	$FCFE,$FEDF,$DF8F,$0F0F
		dc	$1F1E,$1E1E,$3E3C,$7C78
		dc	$F8F0,$F0E0,$E0C0,$0000
ptrFNT_0A0:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0001,$0100
ptrFNT_0A1:		dc	$0000,$0000,$0000,$0001
		dc	$070F,$1F1F,$0C00,$0001
		dc	$0101,$0103,$0303,$0307
		dc	$0707,$070F,$FFFF,$FFFF
ptrFNT_0A2:		dc	$0000,$0000,$187C,$FCFC
		dc	$F8F8,$F8F8,$F0F0,$F0F0
		dc	$E0E0,$E0E0,$C0C0,$C0C0
		dc	$8080,$00FC,$FEFE,$FC00
ptrFNT_0A3:DCB.W     16,0
ptrFNT_0A4:		dc	$0000,$0000,$0003,$070F
		dc	$1F1E,$0C00,$0000,$0000
		dc	$0000,$0001,$070F,$1F3E
		dc	$7FFF,$FFFE,$F860,$0000
ptrFNT_0A5:		dc	$0000,$073F,$7FFF,$FEF0
		dc	$C000,$0000,$0000,$030F
		dc	$1F7F,$FFF8,$F0C0,$3FFF
		dc	$FFFF,$C000,$0000,$0000
ptrFNT_0A6:		dc	$0000,$E0FC,$FEFE,$7F0F
		dc	$0F0F,$0F1F,$3EFE,$FCF0
		dc	$E080,$0000,$0000,$E0FC
		dc	$FFFF,$7F07,$0300,$0000
ptrFNT_0A7:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0080,$8080,$0000,$0000
ptrFNT_0A8:		dc	$0000,$010F,$1F1F,$1F0C
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$1E3F
		dc	$3F1F,$0703,$0000,$0000
ptrFNT_0A9:		dc	$0007,$FFFF,$FFFC,$0000
		dc	$0000,$0000,$1F3F,$3F1F
		dc	$0000,$0000,$0000,$0000
		dc	$C7FF,$FFFF,$FE00,$0000
ptrFNT_0AA:		dc	$00F8,$FEFF,$FF0F,$0707
		dc	$070F,$1F7F,$FEFC,$FEFF
		dc	$FF1F,$0F0F,$0F1F,$3FFE
		dc	$FEFC,$F0C0,$0000,$0000
ptrFNT_0AB:		dc	$0000,$0000,$8080,$C0C0
		dc	$C080,$8000,$0000,$0000
		dc	$0080,$8080,$8000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_0AC:		dc	$0000,$0000,$0000,$0001
		dc	$0103,$0707,$0F1F,$1F3F
		dc	$7F7F,$3F00,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_0AD:		dc	$0000,$0038,$7CFC,$F8F0
		dc	$F0E0,$C080,$8000,$00FF
		dc	$FFFF,$FF00,$0303,$0707
		dc	$0F0F,$0F06,$0000,$0000
ptrFNT_0AE:		dc	$0000,$0000,$060F,$0F1F
		dc	$1F3E,$3E3C,$7C78,$30FF
		dc	$FFFF,$FFE0,$E0E0,$C0C0
		dc	$8080,$0000,$0000,$0000
ptrFNT_0AF:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0080
		dc	$C0C0,$8000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_0B0:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0101,$0303,$0307
		dc	$0703,$0000,$000E,$1F1F
		dc	$0F07,$0100,$0000,$0000
ptrFNT_0B1:		dc	$0000,$060F,$1F3F,$3F7C
		dc	$78F8,$F0EF,$DFFF,$FFF8
		dc	$E080,$0000,$0000,$80E0
		dc	$FFFF,$FF3F,$0000,$0000
ptrFNT_0B2:		dc	$0000,$00FE,$FFFF,$FF03
		dc	$0000,$00FC,$FFFF,$FF07
		dc	$0303,$0303,$070F,$1F3F
		dc	$FCFC,$F8F0,$0000,$0000
ptrFNT_0B3:		dc	$0000,$0000,$E0F0,$F0E0
		dc	$0000,$0000,$0080,$80C0
		dc	$C0C0,$C0C0,$C080,$8000
		dc	$0000,$0000,$0000,$0000
ptrFNT_0B4:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0101,$0303,$0307
		dc	$0707,$0707,$0707,$0707
		dc	$0301,$0000,$0000,$0000
ptrFNT_0B5:		dc	$0000,$000E,$1F3F,$7E7C
		dc	$F8F0,$F0E0,$E0C7,$CFBF
		dc	$7FFE,$F8E0,$C080,$40E0
		dc	$FFFF,$FF3F,$0000,$0000
ptrFNT_0B6:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$00F8,$FEFF
		dc	$FF1F,$0707,$0F0F,$1F3F
		dc	$FEFC,$F8E0,$0000,$0000
ptrFNT_0B7:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$8080,$8080,$8080,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_0B8:		dc	$0000,$0000,$0007,$0F0F
		dc	$0700,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0101,$0000,$0000,$0000
ptrFNT_0B9:		dc	$0000,$0003,$FFFF,$FFFE
		dc	$8000,$0000,$003F,$7F7F
		dc	$3F07,$1F3E,$3C7C,$F8F0
		dc	$F0E0,$C000,$0000,$0000
ptrFNT_0BA:		dc	$0000,$0FFF,$FFFF,$FF3E
		dc	$3C7C,$F8F0,$F0E0,$F8F8
		dc	$F000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_0BB:		dc	$0000,$0080,$8000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_0BC:		dc	$0000,$0000,$0000,$0103
		dc	$0307,$0707,$0703,$0003
		dc	$070F,$0F0F,$1F1F,$1F0F
		dc	$0703,$0100,$0000,$0000
ptrFNT_0BD:		dc	$0007,$1F3F,$7FFC,$F0F0
		dc	$E0C0,$C0C0,$E0FF,$FFFF
		dc	$FFF0,$8000,$0000,$80E0
		dc	$FFFF,$FF3F,$0000,$0000
ptrFNT_0BE:		dc	$00F8,$FEFF,$FF1F,$0707
		dc	$0303,$030F,$7FFF,$FEFE
		dc	$FF0F,$0707,$0707,$0F3F
		dc	$FEFC,$F8E0,$0000,$0000
ptrFNT_0BF:		dc	$0000,$0000,$8080,$80C0
		dc	$C0C0,$C0C0,$8000,$0000
		dc	$0080,$8080,$8080,$8000
		dc	$0000,$0000,$0000,$0000
ptrFNT_0C0:		dc	$0000,$0000,$0103,$0307
		dc	$0707,$0707,$0703,$0100
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_0C1:		dc	$001F,$7FFF,$FFF0,$E0C0
		dc	$C080,$80E1,$FFFF,$FF7F
		dc	$0000,$0000,$0000,$0103
		dc	$0301,$0000,$0000,$0000
ptrFNT_0C2:		dc	$00F0,$FCFE,$FF1F,$0B07
		dc	$0F1F,$7FFF,$FBF7,$CF8F
		dc	$1F1E,$3E3C,$7CF8,$F8F0
		dc	$E0C0,$0000,$0000,$0000
ptrFNT_0C3:		dc	$0000,$0000,$0080,$8080
		dc	$8080,$8080,$8080,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_0C4:DCB.W     16,0
ptrFNT_0C5:		dc	$0000,$0000,$0000,$001F
		dc	$3F3F,$3F3F,$3F3F,$3F1F
		dc	$0000,$1F3F,$3F3F,$3F3F
		dc	$3F3F,$1F00,$0000,$0000
ptrFNT_0C6:		dc	$0000,$0000,$0000,$00C0
		dc	$E0E0,$E0E0,$E0E0,$E0C0
		dc	$0000,$C0E0,$E0E0,$E0E0
		dc	$E0E0,$C000,$0000,$0000
ptrFNT_0C7:DCB.W     16,0
ptrFNT_0C8:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0101,$0303
		dc	$0303,$0303,$0303,$0100
ptrFNT_0C9:		dc	$0000,$0000,$0000,$003F
		dc	$7F7F,$7F7F,$7F7F,$7F3F
		dc	$0000,$3FFF,$FFFF,$FFFF
		dc	$FFFF,$FEFC,$F8F0,$E000
ptrFNT_0CA:		dc	$0000,$0000,$0000,$0080
		dc	$C0C0,$C0C0,$C0C0,$C080
		dc	$0000,$0080,$8080,$8080
		dc	$0000,$0000,$0000,$0000
ptrFNT_0CB:DCB.W     16,0
ptrFNT_0CC:DCB.W     16,0
ptrFNT_0CD:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0103,$060C,$1870
		dc	$6038,$0C06,$0203,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_0CE:		dc	$0000,$0000,$0000,$0020
		dc	$2060,$C000,$0000,$0000
		dc	$0000,$0000,$00C0,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_0CF:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_0D0:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0001,$0000,$0000
		dc	$0001,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_0D1:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0080,$FF00,$0000
		dc	$00FC,$0700,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_0D2:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$80F8,$0000
		dc	$0000,$F000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_0D3:DCB.W     16,0
ptrFNT_0D4:DCB.W     16,0
ptrFNT_0D5:		dc	$0000,$0000,$0000,$0406
		dc	$0203,$0000,$0000,$0000
		dc	$0000,$0103,$0206,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_0D6:		dc	$0000,$0000,$0000,$0000
		dc	$0080,$C070,$1808,$0C1C
		dc	$3060,$C000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_0D7:DCB.W     16,0
ptrFNT_0D8:		dc	$7FFF,$FFFF,$7F3F,$1F0F
		dc	$0700,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0101
		dc	$0101,$0101,$0100,$0000
ptrFNT_0D9:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FF00,$007F,$FFFF,$FFFF
		dc	$FFFE,$FE7C,$00FE,$FFFF
		dc	$FFFF,$FFFF,$FFFE,$0000
ptrFNT_0DA:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FF03,$03FF,$FFFF,$FFFF
		dc	$FF00,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_0DB:		dc	$F8FC,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCFC
		dc	$F800,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_0DC:DCB.W     16,0
ptrFNT_0DD:		dc	$0000,$0000,$0000,$0000
		dc	$0006,$043C,$0040,$F84E
		dc	$4240,$4040,$4070,$4040
		dc	$417F,$0000,$0000,$0000
ptrFNT_0DE:DCB.W     16,0
ptrFNT_0DF:DCB.W     16,0
ptrFNT_0E0:		dc	$030F,$1F3F,$7F7F,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FF7F,$0000
ptrFNT_0E1:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$F0E0,$E0E0,$E0F0
		dc	$FFFF,$FFFF,$FFFF,$F0E0
		dc	$E0E0,$E0E0,$E0C0,$0000
ptrFNT_0E2:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$1F0F,$0F0F,$0F1F
		dc	$FFFF,$FFFF,$FFFF,$0F0F
		dc	$0F0F,$0F0F,$0F06,$0000
ptrFNT_0E3:		dc	$F8FC,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCF8
		dc	$F0E0,$C080,$0000,$0000
ptrFNT_0E4:		dc	$030F,$1F3F,$7F7F,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FF7F,$0000
ptrFNT_0E5:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$E0C0,$C0C0,$E0FF,$FFFF
		dc	$FFFF,$FFE0,$C0C0,$C0E0
		dc	$FFFF,$FFFF,$FFFF,$0000
ptrFNT_0E6:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$7F3F,$3F3F,$7FFF,$FFFF
		dc	$FFFF,$FF7F,$3F3F,$3F7F
		dc	$FFFF,$FFFF,$FFFE,$0000
ptrFNT_0E7:		dc	$F8FC,$FCFC,$FCFC,$FCFC
		dc	$FCF8,$F8F0,$E0C0,$80C0
		dc	$E0F0,$F8F8,$FCFC,$FCFC
		dc	$F8F0,$E0C0,$8000,$0000
ptrFNT_0E8:		dc	$0307,$0F1F,$3F7F,$7FFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FF7F
		dc	$7F3F,$1F0F,$0703,$0000
ptrFNT_0E9:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$E0C0,$C0C0,$C0C0
		dc	$C0C0,$C0E0,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$0000
ptrFNT_0EA:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$0000,$0000,$0000
		dc	$0000,$0000,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$0000
ptrFNT_0EB:		dc	$0080,$C0E0,$F0F8,$FCFC
		dc	$FCF8,$0000,$0000,$0000
		dc	$0000,$0000,$F8FC,$FCFC
		dc	$F8F0,$E0C0,$8000,$0000
ptrFNT_0EC:		dc	$7FFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FF7F,$0000
ptrFNT_0ED:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$CFC7,$C3C1,$C0C0,$C0C0
		dc	$C0C0,$C0C0,$E0FF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$0000
ptrFNT_0EE:		dc	$F8FE,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FF7F,$3F1F
		dc	$0F0F,$0F0F,$1FFF,$FFFF
		dc	$FFFF,$FFFF,$FFFE,$0000
ptrFNT_0EF:		dc	$0000,$0080,$C0E0,$F0F8
		dc	$F8FC,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCF8
		dc	$F8F0,$E0C0,$8000,$0000
ptrFNT_0F0:		dc	$0307,$0F1F,$3F7F,$7FFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FF7F,$0000
ptrFNT_0F1:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$C0FF,$FFFF,$FFFF
		dc	$FFC0,$E0FF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$0000
ptrFNT_0F2:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$00F8,$FCFC,$FCFC
		dc	$F800,$00FF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$0000
ptrFNT_0F3:		dc	$0080,$C0E0,$F0F8,$FCFC
		dc	$FCF8,$0000,$0000,$0000
		dc	$0000,$00F8,$FCFC,$FCFC
		dc	$F8F0,$E0C0,$8000,$0000
ptrFNT_0F4:		dc	$0107,$0F1F,$3F7F,$7FFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FF7F,$0000
ptrFNT_0F5:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$F0F8,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$F8F0
		dc	$F0F0,$F0F0,$F0E0,$0000
ptrFNT_0F6:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$0000,$C0E0,$F0F8
		dc	$FCFE,$FFFF,$FFFE,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_0F7:		dc	$F8FC,$FCFC,$FCF8,$F0E0
		dc	$C080,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_0F8:		dc	$0107,$0F1F,$3F7F,$7FFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$7F3F,$1F0F,$0701,$0000
ptrFNT_0F9:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$E0C0,$C7CF,$CFCF
		dc	$CFC7,$C0E0,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$0000
ptrFNT_0FA:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$0000,$FFFF,$FFFF
		dc	$FFFF,$0F1F,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFE,$0000
ptrFNT_0FB:		dc	$F8FC,$FCFC,$FCF8,$F0E0
		dc	$C000,$0000,$F8FC,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCFC
		dc	$F8F0,$E0C0,$8000,$0000
ptrFNT_0FC:		dc	$70F8,$FCFE,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FF7F,$0000
ptrFNT_0FD:		dc	$0000,$0000,$0080,$C0C0
		dc	$C0C0,$C0E0,$FFFF,$FFFF
		dc	$FFFF,$E0C0,$C0C0,$C0C0
		dc	$C0C0,$C0C0,$C080,$0000
ptrFNT_0FE:		dc	$070F,$0F0F,$0F0F,$0F0F
		dc	$0F0F,$0F1F,$FFFF,$FFFF
		dc	$FFFF,$1F0F,$0F0F,$0F0F
		dc	$0F0F,$0F0F,$0F07,$0000
ptrFNT_0FF:		dc	$0080,$C0E0,$F0F8,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCFC
		dc	$F8F0,$E0C0,$8000,$0000
ptrFNT_100:		dc	$7FFF,$FFFF,$FFFF,$FF7F
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$070F
		dc	$1F3F,$7FFF,$FF7F,$0000
ptrFNT_101:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FF7F,$7F7F,$7F7F,$7F7F
		dc	$7F7F,$7F7F,$7FFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$0000
ptrFNT_102:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$F8F0,$F0F0,$F0F0,$F0F0
		dc	$F0F0,$F0F0,$F0F8,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$0000
ptrFNT_103:		dc	$80C0,$E0F0,$F8FC,$FCFC
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$F8FC
		dc	$FCFC,$FCFC,$FCF8,$0000
ptrFNT_104:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$60F0,$F8FC,$FEFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FF7F,$0000
ptrFNT_105:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$80C0,$C0E0,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$0000
ptrFNT_106:		dc	$0000,$0001,$0307,$070F
		dc	$0F0F,$0F0F,$0F0F,$0F0F
		dc	$0F0F,$0F1F,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFE,$0000
ptrFNT_107:		dc	$387C,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCF8
		dc	$F8F0,$E0C0,$8000,$0000
ptrFNT_108:		dc	$0307,$0F1F,$3F7F,$7FFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FF7F,$0000
ptrFNT_109:		dc	$80C0,$C0C0,$C0C0,$C0C0
		dc	$C0C0,$C0E0,$FFFF,$FFFF
		dc	$FFFF,$E0C0,$C0C0,$C0C0
		dc	$C0C0,$C0C0,$C080,$0000
ptrFNT_10A:		dc	$0000,$0001,$0307,$0F0F
		dc	$1F1F,$1F1F,$FFFF,$FFFF
		dc	$FFFF,$3F1F,$1F1F,$1F1F
		dc	$1F1F,$1F1F,$1F0F,$0000
ptrFNT_10B:		dc	$387C,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCF8,$F8F0,$E0F0
		dc	$F8F8,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCFC,$FCF8,$0000
ptrFNT_10C:		dc	$0307,$0F1F,$3F7F,$7FFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FF7F,$0000
ptrFNT_10D:		dc	$80C0,$C0C0,$C0C0,$C0C0
		dc	$C0C0,$C0C0,$C0C0,$C0C0
		dc	$C0C0,$C0E0,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$0000
ptrFNT_10E:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$0000
ptrFNT_10F:		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$F8FC,$FCFC
		dc	$FCF8,$F0E0,$C000,$0000
ptrFNT_110:		dc	$0307,$0F1F,$3F7F,$7FFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FF7F,$0000
ptrFNT_111:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$BF9F,$9F9F,$9F9F
		dc	$9F9F,$9F9F,$9F9E,$9C98
		dc	$9080,$8080,$8000,$0000
ptrFNT_112:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$EFCF,$CFCF,$CFCF
		dc	$CFCF,$CF8F,$0F0F,$0F0F
		dc	$0F0F,$0F0F,$0E04,$0000
ptrFNT_113:		dc	$F8FC,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$F8F0
		dc	$E0C0,$8000,$0000,$0000
ptrFNT_114:		dc	$0107,$0F1F,$3F7F,$7FFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FF7F,$0000
ptrFNT_115:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$E0C0,$C0C0,$C0C0
		dc	$C0C0,$C0C0,$C0C0,$C0C0
		dc	$C0C0,$C0C0,$C080,$0000
ptrFNT_116:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$1F0F,$0F0F,$0F0F
		dc	$0F0F,$0F0F,$0F0F,$0F0F
		dc	$0F0F,$0F0F,$0F06,$0000
ptrFNT_117:		dc	$F8FC,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCF8
		dc	$F0E0,$C080,$0000,$0000
ptrFNT_118:		dc	$0107,$0F1F,$3F7F,$7FFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FF7F,$0000
ptrFNT_119:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$E0C0,$C0C0,$C0C0
		dc	$C0C0,$C0E0,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$0000
ptrFNT_11A:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$1F0F,$0F0F,$0F0F
		dc	$0F0F,$0F1F,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFE,$0000
ptrFNT_11B:		dc	$F8FC,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCF8
		dc	$F8F0,$E0C0,$8000,$0000
ptrFNT_11C:		dc	$0107,$0F1F,$3F7F,$7FFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FF7F
		dc	$3F1F,$0F07,$0301,$0000
ptrFNT_11D:		dc	$FFFF,$FFFF,$FFFF,$FFE0
		dc	$C0C0,$C0C0,$C0C0,$E0FF
		dc	$FFFF,$FFFF,$FFFF,$C0C0
		dc	$C0C0,$C0C0,$C080,$0000
ptrFNT_11E:		dc	$FFFF,$FFFF,$FFFF,$FF1F
		dc	$0F0F,$0F0F,$0F0F,$1FFF
		dc	$FFFF,$FFFF,$FFFE,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_11F:		dc	$F8FC,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCF8
		dc	$F8F0,$E0C0,$8000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_120:		dc	$0307,$0F1F,$3F7F,$7FFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FF7F,$0000
ptrFNT_121:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$E0C0,$C0C0,$C0C0
		dc	$C0C0,$C0E0,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$0000
ptrFNT_122:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$1F0F,$0F0F,$0F0F
		dc	$0F0F,$0F1F,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFE,$0000
ptrFNT_123:		dc	$F8FC,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCF8
		dc	$F8F0,$E0C0,$8000,$0000
ptrFNT_124:		dc	$0107,$0F1F,$3F7F,$7FFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FF7F,$0000
ptrFNT_125:		dc	$FFFF,$FFFF,$FFFF,$E0C0
		dc	$C0C0,$C0E0,$FFFF,$FFFF
		dc	$FFFF,$E0C0,$C0C0,$C0C0
		dc	$C0C0,$C0C0,$C080,$0000
ptrFNT_126:		dc	$FFFF,$FFFF,$FFFF,$3F1F
		dc	$1F1F,$1F3F,$FFFF,$FFFF
		dc	$FFFF,$3F1F,$1F1F,$1F1F
		dc	$1F1F,$1F1F,$1F0F,$0000
ptrFNT_127:		dc	$F8FC,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCF8,$F0E0,$C0E0
		dc	$F0F8,$FCFC,$FCFC,$FCFC
		dc	$F8F0,$E0C0,$8000,$0000
ptrFNT_128:		dc	$0107,$0F1F,$3F7F,$7FFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FF7F,$0000,$7FFF,$FFFF
		dc	$FFFF,$FFFF,$FF7F,$0000
ptrFNT_129:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$F0E0,$FFFF,$FFFF
		dc	$FFFF,$0000,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$0000
ptrFNT_12A:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFE,$0000,$FFFF,$FFFF
		dc	$FFFF,$1F0F,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFE,$0000
ptrFNT_12B:		dc	$FCFC,$FCF8,$F8F0,$E0C0
		dc	$8000,$0000,$F8FC,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCF8
		dc	$F8F0,$E0C0,$8000,$0000
ptrFNT_12C:		dc	$7FFF,$FFFF,$FFFF,$FFFF
		dc	$FF7F,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_12D:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FF7F,$7F7F,$7F7F
		dc	$7F7F,$7F7F,$7F7F,$7F7F
		dc	$7F7F,$7F7F,$7F3F,$0000
ptrFNT_12E:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFE,$F0E0,$E0E0,$E0E0
		dc	$E0E0,$E0E0,$E0E0,$E0E0
		dc	$E0E0,$E0E0,$E0C0,$0000
ptrFNT_12F:		dc	$F8FC,$FCFC,$F8F0,$E0C0
		dc	$8000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_130:		dc	$70F8,$FCFE,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FF7F,$0000
ptrFNT_131:		dc	$0000,$0000,$0080,$80C0
		dc	$C0C0,$C0C0,$C0C0,$C0C0
		dc	$C0C0,$C0E0,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$0000
ptrFNT_132:		dc	$070F,$0F0F,$0F0F,$0F0F
		dc	$0F0F,$0F0F,$0F0F,$0F0F
		dc	$0F0F,$0F1F,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$0000
ptrFNT_133:		dc	$0080,$C0E0,$F0F8,$F8FC
		dc	$FCFC,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCFC
		dc	$F8F0,$E0C0,$8000,$0000
ptrFNT_134:		dc	$70F8,$FCFE,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$7F7F,$3F1F,$0F07
		dc	$0301,$0000,$0000,$0000
ptrFNT_135:		dc	$0000,$0000,$0080,$C0C0
		dc	$C0C0,$C0C0,$C0E0,$F0F8
		dc	$FCFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FF7F,$3F0F,$0000
ptrFNT_136:		dc	$070F,$0F0F,$0F0F,$0F0F
		dc	$0F0F,$0F0F,$0F1F,$3F7F
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFE,$FCF8,$F0C0,$0000
ptrFNT_137:		dc	$0080,$C0E0,$F0F8,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$F8F8,$F0E0,$C080
		dc	$0000,$0000,$0000,$0000
ptrFNT_138:		dc	$60F0,$F8FC,$FEFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FF7F,$0000
ptrFNT_139:		dc	$0000,$0000,$0000,$8080
		dc	$9098,$9C9E,$9F9F,$9F9F
		dc	$9F9F,$9FBF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$0000
ptrFNT_13A:		dc	$070F,$0F0F,$0F0F,$0F0F
		dc	$0F0F,$0F0F,$0F8F,$CFCF
		dc	$CFCF,$CFEF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFE,$0000
ptrFNT_13B:		dc	$0080,$C0E0,$F0F8,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCF8
		dc	$F8F0,$E0C0,$8000,$0000
ptrFNT_13C:		dc	$0307,$0F1F,$3F7F,$FFFF
		dc	$FFFF,$FF7F,$3F1F,$0F1F
		dc	$3F7F,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FF7F,$0000
ptrFNT_13D:		dc	$80C0,$C0C0,$C0C0,$C0C0
		dc	$E0FF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FFE0,$C0C0,$C0C0
		dc	$C0C0,$C0C0,$C080,$0000
ptrFNT_13E:		dc	$070F,$0F0F,$0F0F,$0F0F
		dc	$1FFF,$FFFF,$FFFF,$FFFF
		dc	$FFFF,$FF1F,$0F0F,$0F0F
		dc	$0F0F,$0F0F,$0F07,$0000
ptrFNT_13F:		dc	$0080,$C0E0,$F0F8,$FCFC
		dc	$FCFC,$FCF8,$F0E0,$C0E0
		dc	$F0F8,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCFC,$FCF8,$0000
ptrFNT_140:		dc	$070F,$1F3F,$7FFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$7F00,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_141:		dc	$80C0,$C0C0,$C0C0,$C0E0
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FF7F,$3F3F,$3F3F,$3F3F
		dc	$3F3F,$3F3F,$3F1F,$0000
ptrFNT_142:		dc	$070F,$0F0F,$0F0F,$0F1F
		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FFF8,$F0F0,$F0F0,$F0F0
		dc	$F0F0,$F0F0,$F0E0,$0000
ptrFNT_143:		dc	$0080,$C0E0,$F0F8,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCFC
		dc	$F800,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
ptrFNT_144:		dc	$7FFF,$FFFF,$7F3F,$1F0F
		dc	$0300,$007F,$FFFF,$FFFF
		dc	$FFFE,$FEFF,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FF7F,$0000
ptrFNT_145:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FF00,$00FF,$FFFF,$FFFF
		dc	$FF00,$0000,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$0000
ptrFNT_146:		dc	$FFFF,$FFFF,$FFFF,$FFFF
		dc	$FF03,$07FF,$FFFF,$FFFF
		dc	$FF00,$0000,$FFFF,$FFFF
		dc	$FFFF,$FFFF,$FFFF,$0000
ptrFNT_147:		dc	$F8FC,$FCFC,$FCFC,$FCFC
		dc	$FCFC,$FCFC,$FCFC,$FCFC
		dc	$F800,$0000,$F8FC,$FCFC
		dc	$FCFC,$FCFC,$FCF8,$0000
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
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000,$0000,$0000,$0000
		dc	$0000
FONTEs:DC.L      FONTE_D 
      DC.L      ptrFNT_05D 
      DC.L      ptrFNT_05E 
      DC.L      ptrFNT_05F 
      DC.L      ptrFNT_060 
      DC.L      ptrFNT_061 
      DC.L      ptrFNT_062 
      DC.L      ptrFNT_063 
      DC.L      ptrFNT_064 
      DC.L      ptrFNT_065 
      DC.L      ptrFNT_066 
      DC.L      ptrFNT_067 
      DC.L      ptrFNT_068 
      DC.L      ptrFNT_069 
      DC.L      ptrFNT_06A 
      DC.L      ptrFNT_06B 
      DC.L      ptrFNT_06C 
      DC.L      ptrFNT_06D 
      DC.L      ptrFNT_06E 
      DC.L      ptrFNT_06F 
      DC.L      ptrFNT_070 
      DC.L      ptrFNT_071 
      DC.L      ptrFNT_072 
      DC.L      ptrFNT_073 
      DC.L      ptrFNT_074 
      DC.L      ptrFNT_075 
      DC.L      ptrFNT_076 
      DC.L      ptrFNT_077 
      DC.L      ptrFNT_078 
      DC.L      ptrFNT_079 
      DC.L      ptrFNT_07A 
      DC.L      ptrFNT_07B 
      DC.L      ptrFNT_07C 
      DC.L      ptrFNT_07D 
      DC.L      ptrFNT_07E 
      DC.L      ptrFNT_07F 
      DC.L      ptrFNT_080 
      DC.L      ptrFNT_081 
      DC.L      ptrFNT_082 
      DC.L      ptrFNT_083 
      DC.L      ptrFNT_084 
      DC.L      ptrFNT_085 
      DC.L      ptrFNT_086 
      DC.L      ptrFNT_087 
      DC.L      ptrFNT_088 
      DC.L      ptrFNT_089 
      DC.L      ptrFNT_08A 
      DC.L      ptrFNT_08B 
      DC.L      ptrFNT_08C 
      DC.L      ptrFNT_08D 
      DC.L      ptrFNT_08E 
      DC.L      ptrFNT_08F 
      DC.L      ptrFNT_090 
      DC.L      ptrFNT_091 
      DC.L      ptrFNT_092 
      DC.L      ptrFNT_093 
      DC.L      ptrFNT_094 
      DC.L      ptrFNT_095 
      DC.L      ptrFNT_096 
      DC.L      ptrFNT_097 
      DC.L      ptrFNT_098 
      DC.L      ptrFNT_099 
      DC.L      ptrFNT_09A 
      DC.L      ptrFNT_09B 
      DC.L      ptrFNT_09C 
      DC.L      ptrFNT_09D 
      DC.L      ptrFNT_09E 
      DC.L      ptrFNT_09F 
      DC.L      ptrFNT_0A0 
      DC.L      ptrFNT_0A1 
      DC.L      ptrFNT_0A2 
      DC.L      ptrFNT_0A3 
      DC.L      ptrFNT_0A4 
      DC.L      ptrFNT_0A5 
      DC.L      ptrFNT_0A6 
      DC.L      ptrFNT_0A7 
      DC.L      ptrFNT_0A8 
      DC.L      ptrFNT_0A9 
      DC.L      ptrFNT_0AA 
      DC.L      ptrFNT_0AB 
      DC.L      ptrFNT_0AC 
      DC.L      ptrFNT_0AD 
      DC.L      ptrFNT_0AE 
      DC.L      ptrFNT_0AF 
      DC.L      ptrFNT_0B0 
      DC.L      ptrFNT_0B1 
      DC.L      ptrFNT_0B2 
      DC.L      ptrFNT_0B3 
      DC.L      ptrFNT_0B4 
      DC.L      ptrFNT_0B5 
      DC.L      ptrFNT_0B6 
      DC.L      ptrFNT_0B7 
      DC.L      ptrFNT_0B8 
      DC.L      ptrFNT_0B9 
      DC.L      ptrFNT_0BA 
      DC.L      ptrFNT_0BB 
      DC.L      ptrFNT_0BC 
      DC.L      ptrFNT_0BD 
      DC.L      ptrFNT_0BE 
      DC.L      ptrFNT_0BF 
      DC.L      ptrFNT_0C0 
      DC.L      ptrFNT_0C1 
      DC.L      ptrFNT_0C2 
      DC.L      ptrFNT_0C3 
      DC.L      ptrFNT_0C4 
      DC.L      ptrFNT_0C5 
      DC.L      ptrFNT_0C6 
      DC.L      ptrFNT_0C7 
      DC.L      ptrFNT_0C8 
      DC.L      ptrFNT_0C9 
      DC.L      ptrFNT_0CA 
      DC.L      ptrFNT_0CB 
      DC.L      ptrFNT_0CC 
      DC.L      ptrFNT_0CD 
      DC.L      ptrFNT_0CE 
      DC.L      ptrFNT_0CF 
      DC.L      ptrFNT_0D0 
      DC.L      ptrFNT_0D1 
      DC.L      ptrFNT_0D2 
      DC.L      ptrFNT_0D3 
      DC.L      ptrFNT_0D4 
      DC.L      ptrFNT_0D5 
      DC.L      ptrFNT_0D6 
      DC.L      ptrFNT_0D7 
      DC.L      ptrFNT_0D8 
      DC.L      ptrFNT_0D9 
      DC.L      ptrFNT_0DA 
      DC.L      ptrFNT_0DB 
      DC.L      ptrFNT_0DC 
      DC.L      ptrFNT_0DD 
      DC.L      ptrFNT_0DE 
      DC.L      ptrFNT_0DF 
      DC.L      ptrFNT_0E0 
      DC.L      ptrFNT_0E1 
      DC.L      ptrFNT_0E2 
      DC.L      ptrFNT_0E3 
      DC.L      ptrFNT_0E4 
      DC.L      ptrFNT_0E5 
      DC.L      ptrFNT_0E6 
      DC.L      ptrFNT_0E7 
      DC.L      ptrFNT_0E8 
      DC.L      ptrFNT_0E9 
      DC.L      ptrFNT_0EA 
      DC.L      ptrFNT_0EB 
      DC.L      ptrFNT_0EC 
      DC.L      ptrFNT_0ED 
      DC.L      ptrFNT_0EE 
      DC.L      ptrFNT_0EF 
      DC.L      ptrFNT_0F0 
      DC.L      ptrFNT_0F1 
      DC.L      ptrFNT_0F2 
      DC.L      ptrFNT_0F3 
      DC.L      ptrFNT_0F4 
      DC.L      ptrFNT_0F5 
      DC.L      ptrFNT_0F6 
      DC.L      ptrFNT_0F7 
      DC.L      ptrFNT_0F8 
      DC.L      ptrFNT_0F9 
      DC.L      ptrFNT_0FA 
      DC.L      ptrFNT_0FB 
      DC.L      ptrFNT_0FC 
      DC.L      ptrFNT_0FD 
      DC.L      ptrFNT_0FE 
      DC.L      ptrFNT_0FF 
      DC.L      ptrFNT_100 
      DC.L      ptrFNT_101 
      DC.L      ptrFNT_102 
      DC.L      ptrFNT_103 
      DC.L      ptrFNT_104 
      DC.L      ptrFNT_105 
      DC.L      ptrFNT_106 
      DC.L      ptrFNT_107 
      DC.L      ptrFNT_108 
      DC.L      ptrFNT_109 
      DC.L      ptrFNT_10A 
      DC.L      ptrFNT_10B 
      DC.L      ptrFNT_10C 
      DC.L      ptrFNT_10D 
      DC.L      ptrFNT_10E 
      DC.L      ptrFNT_10F 
      DC.L      ptrFNT_110 
      DC.L      ptrFNT_111 
      DC.L      ptrFNT_112 
      DC.L      ptrFNT_113 
      DC.L      ptrFNT_114 
      DC.L      ptrFNT_115 
      DC.L      ptrFNT_116 
      DC.L      ptrFNT_117 
      DC.L      ptrFNT_118 
      DC.L      ptrFNT_119 
      DC.L      ptrFNT_11A 
      DC.L      ptrFNT_11B 
      DC.L      ptrFNT_11C 
      DC.L      ptrFNT_11D 
      DC.L      ptrFNT_11E 
      DC.L      ptrFNT_11F 
      DC.L      ptrFNT_120 
      DC.L      ptrFNT_121 
      DC.L      ptrFNT_122 
      DC.L      ptrFNT_123 
      DC.L      ptrFNT_124 
      DC.L      ptrFNT_125 
      DC.L      ptrFNT_126 
      DC.L      ptrFNT_127 
      DC.L      ptrFNT_128 
      DC.L      ptrFNT_129 
      DC.L      ptrFNT_12A 
      DC.L      ptrFNT_12B 
      DC.L      ptrFNT_12C 
      DC.L      ptrFNT_12D 
      DC.L      ptrFNT_12E 
      DC.L      ptrFNT_12F 
      DC.L      ptrFNT_130 
      DC.L      ptrFNT_131 
      DC.L      ptrFNT_132 
      DC.L      ptrFNT_133 
      DC.L      ptrFNT_134 
      DC.L      ptrFNT_135 
      DC.L      ptrFNT_136 
      DC.L      ptrFNT_137 
      DC.L      ptrFNT_138 
      DC.L      ptrFNT_139 
      DC.L      ptrFNT_13A 
      DC.L      ptrFNT_13B 
      DC.L      ptrFNT_13C 
      DC.L      ptrFNT_13D 
      DC.L      ptrFNT_13E 
      DC.L      ptrFNT_13F 
      DC.L      ptrFNT_140 
      DC.L      ptrFNT_141 
      DC.L      ptrFNT_142 
      DC.L      ptrFNT_143 
      DC.L      ptrFNT_144 
      DC.L      ptrFNT_145 
      DC.L      ptrFNT_146 
      DC.L      ptrFNT_147
      even

COURBE:
		dc	$00A0,$003C,$00A4,$003D
		dc	$00A8,$003F,$00AC,$0041
		dc	$00B0,$0042,$00B4,$0044
		dc	$00B8,$0046,$00BC,$0048
		dc	$00C0,$0049,$00C4,$004B
		dc	$00C8,$004D,$00CC,$004E
		dc	$00D0,$0050,$00D3,$0051
		dc	$00D7,$0053,$00DA,$0054
		dc	$00DE,$0056,$00E1,$0057
		dc	$00E4,$0059,$00E7,$005A
		dc	$00EA,$005C,$00ED,$005D
		dc	$00EF,$005E,$00F2,$005F
		dc	$00F4,$0061,$00F6,$0062
		dc	$00F8,$0063,$00FA,$0064
		dc	$00FC,$0065,$00FD,$0066
		dc	$00FF,$0067,$0100,$0068
		dc	$0101,$0068,$0102,$0069
		dc	$0102,$006A,$0103,$006A
		dc	$0103,$006B,$0103,$006C
		dc	$0103,$006C,$0103,$006C
		dc	$0103,$006D,$0102,$006D
		dc	$0102,$006D,$0101,$006D
		dc	$0100,$006D,$00FF,$006E
		dc	$00FD,$006D,$00FC,$006D
		dc	$00FA,$006D,$00F8,$006D
		dc	$00F6,$006D,$00F4,$006C
		dc	$00F2,$006C,$00EF,$006C
		dc	$00ED,$006B,$00EA,$006A
		dc	$00E7,$006A,$00E4,$0069
		dc	$00E1,$0068,$00DE,$0068
		dc	$00DA,$0067,$00D7,$0066
		dc	$00D3,$0065,$00D0,$0064
		dc	$00CC,$0063,$00C8,$0062
		dc	$00C4,$0061,$00C0,$005F
		dc	$00BC,$005E,$00B8,$005D
		dc	$00B4,$005C,$00B0,$005A
		dc	$00AC,$0059,$00A8,$0057
		dc	$00A4,$0056,$00A0,$0055
		dc	$009B,$0053,$0097,$0051
		dc	$0093,$0050,$008F,$004E
		dc	$008B,$004D,$0087,$004B
		dc	$0083,$0049,$007F,$0048
		dc	$007B,$0046,$0077,$0044
		dc	$0073,$0042,$006F,$0041
		dc	$006C,$003F,$0068,$003D
		dc	$0065,$003C,$0061,$003A
		dc	$005E,$0038,$005B,$0036
		dc	$0058,$0035,$0055,$0033
		dc	$0052,$0031,$0050,$002F
		dc	$004D,$002E,$004B,$002C
		dc	$0049,$002A,$0047,$0029
		dc	$0045,$0027,$0043,$0026
		dc	$0042,$0024,$0040,$0023
		dc	$003F,$0021,$003E,$0020
		dc	$003D,$001E,$003D,$001D
		dc	$003C,$001B,$003C,$001A
		dc	$003C,$0019,$003C,$0018
		dc	$003C,$0016,$003C,$0015
		dc	$003D,$0014,$003D,$0013
		dc	$003E,$0012,$003F,$0011
		dc	$0040,$0010,$0042,$000F
		dc	$0043,$000F,$0045,$000E
		dc	$0047,$000D,$0049,$000D
		dc	$004B,$000C,$004D,$000B
		dc	$0050,$000B,$0052,$000B
		dc	$0055,$000A,$0058,$000A
		dc	$005B,$000A,$005E,$000A
		dc	$0061,$000A,$0065,$000A
		dc	$0068,$000A,$006C,$000A
		dc	$006F,$000A,$0073,$000A
		dc	$0077,$000A,$007B,$000B
		dc	$007F,$000B,$0083,$000B
		dc	$0087,$000C,$008B,$000D
		dc	$008F,$000D,$0093,$000E
		dc	$0097,$000F,$009B,$000F
		dc	$00A0,$0010,$00A4,$0011
		dc	$00A8,$0012,$00AC,$0013
		dc	$00B0,$0014,$00B4,$0015
		dc	$00B8,$0016,$00BC,$0018
		dc	$00C0,$0019,$00C4,$001A
		dc	$00C8,$001B,$00CC,$001D
		dc	$00D0,$001E,$00D3,$0020
		dc	$00D7,$0021,$00DA,$0022
		dc	$00DE,$0024,$00E1,$0026
		dc	$00E4,$0027,$00E7,$0029
		dc	$00EA,$002A,$00ED,$002C
		dc	$00EF,$002E,$00F2,$002F
		dc	$00F4,$0031,$00F6,$0033
		dc	$00F8,$0035,$00FA,$0036
		dc	$00FC,$0038,$00FD,$003A
		dc	$00FF,$003C,$0100,$003D
		dc	$0101,$003F,$0102,$0041
		dc	$0102,$0042,$0103,$0044
		dc	$0103,$0046,$0103,$0048
		dc	$0103,$0049,$0103,$004B
		dc	$0103,$004D,$0102,$004E
		dc	$0102,$0050,$0101,$0051
		dc	$0100,$0053,$00FF,$0054
		dc	$00FD,$0056,$00FC,$0057
		dc	$00FA,$0059,$00F8,$005A
		dc	$00F6,$005C,$00F4,$005D
		dc	$00F2,$005E,$00EF,$005F
		dc	$00ED,$0061,$00EA,$0062
		dc	$00E7,$0063,$00E4,$0064
		dc	$00E1,$0065,$00DE,$0066
		dc	$00DA,$0067,$00D7,$0068
		dc	$00D3,$0068,$00D0,$0069
		dc	$00CC,$006A,$00C8,$006A
		dc	$00C4,$006B,$00C0,$006C
		dc	$00BC,$006C,$00B8,$006C
		dc	$00B4,$006D,$00B0,$006D
		dc	$00AC,$006D,$00A8,$006D
		dc	$00A4,$006D,$00A0,$006E
		dc	$009B,$006D,$0097,$006D
		dc	$0093,$006D,$008F,$006D
		dc	$008B,$006D,$0087,$006C
		dc	$0083,$006C,$007F,$006C
		dc	$007B,$006B,$0077,$006A
		dc	$0073,$006A,$006F,$0069
		dc	$006C,$0068,$0068,$0068
		dc	$0065,$0067,$0061,$0066
		dc	$005E,$0065,$005B,$0064
		dc	$0058,$0063,$0055,$0062
		dc	$0052,$0061,$0050,$005F
		dc	$004D,$005E,$004B,$005D
		dc	$0049,$005C,$0047,$005A
		dc	$0045,$0059,$0043,$0057
		dc	$0042,$0056,$0040,$0055
		dc	$003F,$0053,$003E,$0051
		dc	$003D,$0050,$003D,$004E
		dc	$003C,$004D,$003C,$004B
		dc	$003C,$0049,$003C,$0048
		dc	$003C,$0046,$003C,$0044
		dc	$003D,$0042,$003D,$0041
		dc	$003E,$003F,$003F,$003D
		dc	$0040,$003C,$0042,$003A
		dc	$0043,$0038,$0045,$0036
		dc	$0047,$0035,$0049,$0033
		dc	$004B,$0031,$004D,$002F
		dc	$0050,$002E,$0052,$002C
		dc	$0055,$002A,$0058,$0029
		dc	$005B,$0027,$005E,$0026
		dc	$0061,$0024,$0065,$0023
		dc	$0068,$0021,$006C,$0020
		dc	$006F,$001E,$0073,$001D
		dc	$0077,$001B,$007B,$001A
		dc	$007F,$0019,$0083,$0018
		dc	$0087,$0016,$008B,$0015
		dc	$008F,$0014,$0093,$0013
		dc	$0097,$0012,$009B,$0011
		dc	$00A0,$0010,$00A4,$000F
		dc	$00A8,$000F,$00AC,$000E
		dc	$00B0,$000D,$00B4,$000D
		dc	$00B8,$000C,$00BC,$000B
		dc	$00C0,$000B,$00C4,$000B
		dc	$00C8,$000A,$00CC,$000A
		dc	$00D0,$000A,$00D3,$000A
		dc	$00D7,$000A,$00DA,$000A
		dc	$00DE,$000A,$00E1,$000A
		dc	$00E4,$000A,$00E7,$000A
		dc	$00EA,$000A,$00ED,$000B
		dc	$00EF,$000B,$00F2,$000B
		dc	$00F4,$000C,$00F6,$000D
		dc	$00F8,$000D,$00FA,$000E
		dc	$00FC,$000F,$00FD,$000F
		dc	$00FF,$0010,$0100,$0011
		dc	$0101,$0012,$0102,$0013
		dc	$0102,$0014,$0103,$0015
		dc	$0103,$0016,$0103,$0018
		dc	$0103,$0019,$0103,$001A
		dc	$0103,$001B,$0102,$001D
		dc	$0102,$001E,$0101,$0020
		dc	$0100,$0021,$00FF,$0022
		dc	$00FD,$0024,$00FC,$0026
		dc	$00FA,$0027,$00F8,$0029
		dc	$00F6,$002A,$00F4,$002C
		dc	$00F2,$002E,$00EF,$002F
		dc	$00ED,$0031,$00EA,$0033
		dc	$00E7,$0035,$00E4,$0036
		dc	$00E1,$0038,$00DE,$003A
		dc	$00DA,$003C,$00D7,$003D
		dc	$00D3,$003F,$00D0,$0041
		dc	$00CC,$0042,$00C8,$0044
		dc	$00C4,$0046,$00C0,$0048
		dc	$00BC,$0049,$00B8,$004B
		dc	$00B4,$004D,$00B0,$004E
		dc	$00AC,$0050,$00A8,$0051
		dc	$00A4,$0053,$00A0,$0054
		dc	$009B,$0056,$0097,$0057
		dc	$0093,$0059,$008F,$005A
		dc	$008B,$005C,$0087,$005D
		dc	$0083,$005E,$007F,$005F
		dc	$007B,$0061,$0077,$0062
		dc	$0073,$0063,$006F,$0064
		dc	$006C,$0065,$0068,$0066
		dc	$0065,$0067,$0061,$0068
		dc	$005E,$0068,$005B,$0069
		dc	$0058,$006A,$0055,$006A
		dc	$0052,$006B,$0050,$006C
		dc	$004D,$006C,$004B,$006C
		dc	$0049,$006D,$0047,$006D
		dc	$0045,$006D,$0043,$006D
		dc	$0042,$006D,$0040,$006E
		dc	$003F,$006D,$003E,$006D
		dc	$003D,$006D,$003D,$006D
		dc	$003C,$006D,$003C,$006C
		dc	$003C,$006C,$003C,$006C
		dc	$003C,$006B,$003C,$006A
		dc	$003D,$006A,$003D,$0069
		dc	$003E,$0068,$003F,$0068
		dc	$0040,$0067,$0042,$0066
		dc	$0043,$0065,$0045,$0064
		dc	$0047,$0063,$0049,$0062
		dc	$004B,$0061,$004D,$005F
		dc	$0050,$005E,$0052,$005D
		dc	$0055,$005C,$0058,$005A
		dc	$005B,$0059,$005E,$0057
		dc	$0061,$0056,$0065,$0055
		dc	$0068,$0053,$006C,$0051
		dc	$006F,$0050,$0073,$004E
		dc	$0077,$004D,$007B,$004B
		dc	$007F,$0049,$0083,$0048
		dc	$0087,$0046,$008B,$0044
		dc	$008F,$0042,$0093,$0041
		dc	$0097,$003F,$009B,$003D
		dc	$00A0,$003C,$00A4,$003A
		dc	$00A8,$0038,$00AC,$0036
		dc	$00B0,$0035,$00B4,$0033
		dc	$00B8,$0031,$00BC,$002F
		dc	$00C0,$002E,$00C4,$002C
		dc	$00C8,$002A,$00CC,$0029
		dc	$00D0,$0027,$00D3,$0026
		dc	$00D7,$0024,$00DA,$0023
		dc	$00DE,$0021,$00E1,$0020
		dc	$00E4,$001E,$00E7,$001D
		dc	$00EA,$001B,$00ED,$001A
		dc	$00EF,$0019,$00F2,$0018
		dc	$00F4,$0016,$00F6,$0015
		dc	$00F8,$0014,$00FA,$0013
		dc	$00FC,$0012,$00FD,$0011
		dc	$00FF,$0010,$0100,$000F
		dc	$0101,$000F,$0102,$000E
		dc	$0102,$000D,$0103,$000D
		dc	$0103,$000C,$0103,$000B
		dc	$0103,$000B,$0103,$000B
		dc	$0103,$000A,$0102,$000A
		dc	$0102,$000A,$0101,$000A
		dc	$0100,$000A,$00FF,$000A
		dc	$00FD,$000A,$00FC,$000A
		dc	$00FA,$000A,$00F8,$000A
		dc	$00F6,$000A,$00F4,$000B
		dc	$00F2,$000B,$00EF,$000B
		dc	$00ED,$000C,$00EA,$000D
		dc	$00E7,$000D,$00E4,$000E
		dc	$00E1,$000F,$00DE,$000F
		dc	$00DA,$0010,$00D7,$0011
		dc	$00D3,$0012,$00D0,$0013
		dc	$00CC,$0014,$00C8,$0015
		dc	$00C4,$0016,$00C0,$0018
		dc	$00BC,$0019,$00B8,$001A
		dc	$00B4,$001B,$00B0,$001D
		dc	$00AC,$001E,$00A8,$0020
		dc	$00A4,$0021,$00A0,$0022
		dc	$009B,$0024,$0097,$0026
		dc	$0093,$0027,$008F,$0029
		dc	$008B,$002A,$0087,$002C
		dc	$0083,$002E,$007F,$002F
		dc	$007B,$0031,$0077,$0033
		dc	$0073,$0035,$006F,$0036
		dc	$006C,$0038,$0068,$003A
		dc	$0065,$003C,$0061,$003D
		dc	$005E,$003F,$005B,$0041
		dc	$0058,$0042,$0055,$0044
		dc	$0052,$0046,$0050,$0048
		dc	$004D,$0049,$004B,$004B
		dc	$0049,$004D,$0047,$004E
		dc	$0045,$0050,$0043,$0051
		dc	$0042,$0053,$0040,$0054
		dc	$003F,$0056,$003E,$0057
		dc	$003D,$0059,$003D,$005A
		dc	$003C,$005C,$003C,$005D
		dc	$003C,$005E,$003C,$005F
		dc	$003C,$0061,$003C,$0062
		dc	$003D,$0063,$003D,$0064
		dc	$003E,$0065,$003F,$0066
		dc	$0040,$0067,$0042,$0068
		dc	$0043,$0068,$0045,$0069
		dc	$0047,$006A,$0049,$006A
		dc	$004B,$006B,$004D,$006C
		dc	$0050,$006C,$0052,$006C
		dc	$0055,$006D,$0058,$006D
		dc	$005B,$006D,$005E,$006D
		dc	$0061,$006D,$0065,$006E
		dc	$0068,$006D,$006C,$006D
		dc	$006F,$006D,$0073,$006D
		dc	$0077,$006D,$007B,$006C
		dc	$007F,$006C,$0083,$006C
		dc	$0087,$006B,$008B,$006A
		dc	$008F,$006A,$0093,$0069
		dc	$0097,$0068,$009B,$0068
		dc	$00A0,$0067,$00A4,$0066
		dc	$00A8,$0065,$00AC,$0064
		dc	$00B0,$0063,$00B4,$0062
		dc	$00B8,$0061,$00BC,$005F
		dc	$00C0,$005E,$00C4,$005D
		dc	$00C8,$005C,$00CC,$005A
		dc	$00D0,$0059,$00D3,$0057
		dc	$00D7,$0056,$00DA,$0055
		dc	$00DE,$0053,$00E1,$0051
		dc	$00E4,$0050,$00E7,$004E
		dc	$00EA,$004D,$00ED,$004B
		dc	$00EF,$0049,$00F2,$0048
		dc	$00F4,$0046,$00F6,$0044
		dc	$00F8,$0042,$00FA,$0041
		dc	$00FC,$003F,$00FD,$003D
		dc	$00FF,$003C,$0100,$003A
		dc	$0101,$0038,$0102,$0036
		dc	$0102,$0035,$0103,$0033
		dc	$0103,$0031,$0103,$002F
		dc	$0103,$002E,$0103,$002C
		dc	$0103,$002A,$0102,$0029
		dc	$0102,$0027,$0101,$0026
		dc	$0100,$0024,$00FF,$0023
		dc	$00FD,$0021,$00FC,$0020
		dc	$00FA,$001E,$00F8,$001D
		dc	$00F6,$001B,$00F4,$001A
		dc	$00F2,$0019,$00EF,$0018
		dc	$00ED,$0016,$00EA,$0015
		dc	$00E7,$0014,$00E4,$0013
		dc	$00E1,$0012,$00DE,$0011
		dc	$00DA,$0010,$00D7,$000F
		dc	$00D3,$000F,$00D0,$000E
		dc	$00CC,$000D,$00C8,$000D
		dc	$00C4,$000C,$00C0,$000B
		dc	$00BC,$000B,$00B8,$000B
		dc	$00B4,$000A,$00B0,$000A
		dc	$00AC,$000A,$00A8,$000A
		dc	$00A4,$000A,$00A0,$000A
		dc	$009B,$000A,$0097,$000A
		dc	$0093,$000A,$008F,$000A
		dc	$008B,$000A,$0087,$000B
		dc	$0083,$000B,$007F,$000B
		dc	$007B,$000C,$0077,$000D
		dc	$0073,$000D,$006F,$000E
		dc	$006C,$000F,$0068,$000F
		dc	$0065,$0010,$0061,$0011
		dc	$005E,$0012,$005B,$0013
		dc	$0058,$0014,$0055,$0015
		dc	$0052,$0016,$0050,$0018
		dc	$004D,$0019,$004B,$001A
		dc	$0049,$001B,$0047,$001D
		dc	$0045,$001E,$0043,$0020
		dc	$0042,$0021,$0040,$0022
		dc	$003F,$0024,$003E,$0026
		dc	$003D,$0027,$003D,$0029
		dc	$003C,$002A,$003C,$002C
		dc	$003C,$002E,$003C,$002F
		dc	$003C,$0031,$003C,$0033
		dc	$003D,$0035,$003D,$0036
		dc	$003E,$0038,$003F,$003A
		dc	$0040,$003C,$0042,$003D
		dc	$0043,$003F,$0045,$0041
		dc	$0047,$0042,$0049,$0044
		dc	$004B,$0046,$004D,$0048
		dc	$0050,$0049,$0052,$004B
		dc	$0055,$004D,$0058,$004E
		dc	$005B,$0050,$005E,$0051
		dc	$0061,$0053,$0065,$0054
		dc	$0068,$0056,$006C,$0057
		dc	$006F,$0059,$0073,$005A
		dc	$0077,$005C,$007B,$005D
		dc	$007F,$005E,$0083,$005F
		dc	$0087,$0061,$008B,$0062
		dc	$008F,$0063,$0093,$0064
		dc	$0097,$0065,$009B,$0066
		dc	$00A0,$0067,$00A4,$0068
		dc	$00A8,$0068,$00AC,$0069
		dc	$00B0,$006A,$00B4,$006A
		dc	$00B8,$006B,$00BC,$006C
		dc	$00C0,$006C,$00C4,$006C
		dc	$00C8,$006D,$00CC,$006D
		dc	$00D0,$006D,$00D3,$006D
		dc	$00D7,$006D,$00DA,$006E
		dc	$00DE,$006D,$00E1,$006D
		dc	$00E4,$006D,$00E7,$006D
		dc	$00EA,$006D,$00ED,$006C
		dc	$00EF,$006C,$00F2,$006C
		dc	$00F4,$006B,$00F6,$006A
		dc	$00F8,$006A,$00FA,$0069
		dc	$00FC,$0068,$00FD,$0068
		dc	$00FF,$0067,$0100,$0066
		dc	$0101,$0065,$0102,$0064
		dc	$0102,$0063,$0103,$0062
		dc	$0103,$0061,$0103,$005F
		dc	$0103,$005E,$0103,$005D
		dc	$0103,$005C,$0102,$005A
		dc	$0102,$0059,$0101,$0057
		dc	$0100,$0056,$00FF,$0055
		dc	$00FD,$0053,$00FC,$0051
		dc	$00FA,$0050,$00F8,$004E
		dc	$00F6,$004D,$00F4,$004B
		dc	$00F2,$0049,$00EF,$0048
		dc	$00ED,$0046,$00EA,$0044
		dc	$00E7,$0042,$00E4,$0041
		dc	$00E1,$003F,$00DE,$003D
		dc	$00DA,$003C,$00D7,$003A
		dc	$00D3,$0038,$00D0,$0036
		dc	$00CC,$0035,$00C8,$0033
		dc	$00C4,$0031,$00C0,$002F
		dc	$00BC,$002E,$00B8,$002C
		dc	$00B4,$002A,$00B0,$0029
		dc	$00AC,$0027,$00A8,$0026
		dc	$00A4,$0024,$00A0,$0023
		dc	$009B,$0021,$0097,$0020
		dc	$0093,$001E,$008F,$001D
		dc	$008B,$001B,$0087,$001A
		dc	$0083,$0019,$007F,$0018
		dc	$007B,$0016,$0077,$0015
		dc	$0073,$0014,$006F,$0013
		dc	$006C,$0012,$0068,$0011
		dc	$0065,$0010,$0061,$000F
		dc	$005E,$000F,$005B,$000E
		dc	$0058,$000D,$0055,$000D
		dc	$0052,$000C,$0050,$000B
		dc	$004D,$000B,$004B,$000B
		dc	$0049,$000A,$0047,$000A
		dc	$0045,$000A,$0043,$000A
		dc	$0042,$000A,$0040,$000A
		dc	$003F,$000A,$003E,$000A
		dc	$003D,$000A,$003D,$000A
		dc	$003C,$000A,$003C,$000B
		dc	$003C,$000B,$003C,$000B
		dc	$003C,$000C,$003C,$000D
		dc	$003D,$000D,$003D,$000E
		dc	$003E,$000F,$003F,$000F
		dc	$0040,$0010,$0042,$0011
		dc	$0043,$0012,$0045,$0013
		dc	$0047,$0014,$0049,$0015
		dc	$004B,$0016,$004D,$0018
		dc	$0050,$0019,$0052,$001A
		dc	$0055,$001B,$0058,$001D
		dc	$005B,$001E,$005E,$0020
		dc	$0061,$0021,$0065,$0022
		dc	$0068,$0024,$006C,$0026
		dc	$006F,$0027,$0073,$0029
		dc	$0077,$002A,$007B,$002C
		dc	$007F,$002E,$0083,$002F
		dc	$0087,$0031,$008B,$0033
		dc	$008F,$0035,$0093,$0036
		dc	$0097,$0038,$009B,$003A
		dc	$FFFF,$FFFF
PTR_COURBE:
	DCB.W	2,0 
DATA_3:
	DCB.W	2,0 
DATA_4:
	DCB.W	2,0 
PTR_TEXTE:
	DCB.W	2,0 
CPT_TEXTE:
	DC.W	$0 
*
PUSH_IT:
 rept	2
	DC.L      CLEAR_TMP
	endr
DATAI_1:
    dc.l	BUFFERI_3
DATAI_2:
    dc	$007B,$FED0,$74B4,$0703
		dc	$FF48,$7D6F,$FAEC,$01B8
		dc	$7481,$FCCD,$02AB,$721C
		dc	$FECC,$0024,$713A,$FE7A
		dc	$FD9E,$7754,$010C,$FCCB
		dc	$6EA6,$FE84,$0648,$7549
		dc	$02C7,$05E5,$729D,$0207
		dc	$03B0,$6DEA,$047B,$0232
		dc	$6EE2,$079C,$FEBB,$7593
		dc	$08F1,$FF7E,$7499,$0697
		dc	$0271,$7A4B,$00C2,$FC70
		dc	$7000,$FFFC,$FD0A,$77C9
		dc	$FE66,$FEFA,$740F,$0060
		dc	$0767,$7A04,$FE9D,$FA2B
		dc	$7CC7,$05AB,$FDB0,$6E5D
		dc	$FB2F,$0141,$7B1D,$F9D0
		dc	$FF34,$730F,$FE33,$0478
		dc	$75C1,$03A9,$FCAC,$7A3A
		dc	$F6B9,$FF4D,$7879,$016D
		dc	$FAAF,$7CC1,$01D6,$FECB
		dc	$7531,$059C,$FE31,$7BCE
		dc	$FDFE,$FF4D,$6EA9,$06AF
		dc	$017F,$73FB,$FE44,$FCE0
		dc	$71B2,$05FC,$FE4A,$7700
		dc	$034F,$04D9,$6E8B,$F8CC
		dc	$FECC,$70BA,$FB03,$0548
		dc	$6D76,$FA7D,$0546,$7C24
		dc	$FCD9,$FB8F,$6EAC,$FFB1
		dc	$F8CC,$7A44,$FD7F,$FABD
		dc	$70C9,$FFFD,$FB71,$6DB9
		dc	$FA8A,$FEB3,$7A84,$FF44
		dc	$00E8,$701D,$FAE2,$002C
		dc	$72F9,$FFBA,$05AD,$75FD
		dc	$0231,$0687,$7841,$0056
		dc	$FADC,$6DFA,$FAF9,$00F3
		dc	$7806,$0712,$015F,$74CC
		dc	$0363,$FF23,$7B26,$FB1C
		dc	$0096,$6E61,$F84C,$011C
		dc	$798E,$FEE9,$0453,$752F
		dc	$FEEF,$073E,$77C2,$F739
		dc	$FFAB,$79E9,$F724,$FFF3
		dc	$72E1,$04D8,$010B,$731F
		dc	$0222,$01D8,$732C,$03C0
		dc	$F96A,$7E90,$002E,$FA88
		dc	$7EAA,$F9BA,$FA8D,$7932
		dc	$0560,$05E7,$7D84,$FD58
		dc	$FC4B,$6D69,$FEEA,$FE7F
		dc	$7992,$FE6C,$FFFF,$77F4
		dc	$0233,$FB1C,$77BA,$060F
		dc	$FD8C,$7B68,$0159,$0219
		dc	$77C7,$FF62,$04E1,$7525
		dc	$0357,$F8CA,$7787,$FD8B
		dc	$002A,$7DB7,$FA95,$0077
		dc	$7934,$0818,$FE4D,$74A2
		dc	$0373,$013B,$7B9E,$0150
		dc	$0296,$70D0,$047D,$049D
		dc	$7593,$0159,$FE1C,$72EF
		dc	$00D6,$00BA,$77C5,$0536
		dc	$017D,$7305,$F9AD,$019A
		dc	$7A15,$FF0B,$FE21,$7148
		dc	$03E6,$0160,$727A,$0250
		dc	$0061,$78B0,$07BF,$01AD
		dc	$6F2E,$FD32,$019F,$7020
		dc	$06FF,$FDFB,$6DE4,$FF90
		dc	$0610,$7B6E,$FDA3,$FE89
		dc	$7C8A,$07E6,$0133,$7B3E
		dc	$00C5,$F8A0,$73E9,$FA1D
		dc	$00CD,$74A4,$069A,$006D
		dc	$76ED,$0444,$FD68,$6F7B
		dc	$067F,$FEF8,$6D85,$03D5
		dc	$00B0,$7B28,$FE62,$003F
		dc	$78EF,$02F3,$FA5E,$7058
		dc	$FFDB,$05E2,$7533,$FF2B
		dc	$02E5,$7770,$FEE2,$FC9E
		dc	$7402,$0056,$FD79,$78FF
		dc	$FB25,$FAF6,$7987,$058D
		dc	$FE80,$75FF,$00F1,$0043
		dc	$7141,$064B,$0076,$79F3
		dc	$05F5,$FCE1,$7E05,$F6F8
		dc	$FFE1,$7EB4,$FAF9,$00E8
		dc	$7A65,$02FF,$029E,$76B7
		dc	$FC69,$FF6B,$7275,$0581
		dc	$FE22,$7DC2,$FEA7,$0094
		dc	$7117,$FC1B,$0403,$6EBE
		dc	$0134,$FDCF,$73B9,$FE49
		dc	$038B,$72E8,$062B,$FF2D
		dc	$72F1,$0115,$FE36,$7B11
		dc	$0255,$0493,$6E68,$FD92
		dc	$FE3D,$7D87,$F693,$0293
		dc	$7C13,$0375,$004A,$70F1
		dc	$0A04,$00BF,$7136,$02D7
		dc	$0121,$6DAE,$FC70,$0357
		dc	$7343,$005A,$03A5,$7A8A
		dc	$F873,$FC57,$72B9,$FBC5
		dc	$FECB,$6E63,$01AB,$FFC6
		dc	$7C4A,$0394,$03ED,$7341
		dc	$F98C,$FC8E,$6F10,$05FC
		dc	$01CF,$7384,$0536,$FFC9
		dc	$776F,$FEFF,$02B3,$6ED7
		dc	$08C0,$0035,$73FE,$0210
		dc	$FA9E,$7A98,$F95C,$003B
		dc	$7702,$0207,$022C,$6D99
		dc	$FF4D,$019B,$783F,$064A
		dc	$00CE,$73BF,$0175,$01A1
		dc	$7391,$08A4,$FE21,$7A0D
		dc	$FDCB,$0181,$7936,$046C
		dc	$0078,$70F0,$016B,$FC12
		dc	$7B20,$FB47,$FFAA,$6EB1
		dc	$0305,$FDB2,$756A,$00A2
		dc	$FBF1,$7D4D,$FD61,$0385
		dc	$76F6,$FE69,$0141,$7D27
		dc	$03EA,$FDDC,$789E,$FF2A
		dc	$0165,$7487,$01B2,$0643
		dc	$7DFC,$05D7,$00A3,$78E5
		dc	$061E,$FFD4,$732E,$02BC
		dc	$FFCC,$7860,$0217,$0628
		dc	$7760,$FA13,$0399,$6FF0
		dc	$026C,$FE5A,$7ADB,$03DC
		dc	$FEAB,$702B,$014A,$068D
		dc	$7E8C,$FC7E,$00CD,$70A0
		dc	$0338,$0432,$6D6B,$005E
		dc	$FCF8,$7E54,$058B,$FDF9
		dc	$742F,$0311,$F938,$728F
		dc	$FD38,$FD1A,$77CE,$0172
		dc	$0571,$6E42,$0181,$FD41
		dc	$73CE,$F668,$0109,$7441
		dc	$FD95,$FCF4,$7267,$FFF1
		dc	$049F,$7037,$FD7D,$0157
		dc	$765F,$02BD,$FCD1,$75A9
		dc	$FE44,$06F1,$79C3,$F89C
		dc	$002D,$759D,$F9F7,$0379
		dc	$6FF2,$FC26,$033C,$72A5
		dc	$00FE,$F9FD,$6E12,$FFE7
		dc	$F86D,$71D7,$FFC8,$0494
		dc	$7EF3,$FC0E,$03A1,$6F1A
		dc	$F6A2,$FF63,$7A43,$FA45
		dc	$0072,$77E9,$028E,$FC9C
		dc	$7D30,$FD15,$01AB,$7173
		dc	$0980,$FED1,$7056,$FC26
		dc	$FAE9,$6EB0,$01EA,$FFF2
		dc	$7567,$05D7,$FCAA,$7D20
		dc	$0051,$FB60,$73A8,$0527
		dc	$FF89,$74D4,$05E2,$0299
		dc	$7AA2,$FF6B,$FB6C,$7B89
		dc	$091E,$008C,$7860,$FACA
		dc	$FDEC,$71D7,$0179,$F891
		dc	$6DF9,$FC39,$FDC6,$7CDE
		dc	$03EC,$067A,$72B5,$00DA
		dc	$FAE8,$7A0D,$00E9,$FF31
		dc	$7425,$075E,$0082,$7DD9
DATAI_3:
    dc	$0000,$063B,$0477,$06B2
		dc	$08ED,$0B27,$0D61,$0F99
		dc	$11D0,$1405,$1639,$186C
		dc	$1A9C,$1CCA,$1EF7,$2120
		dc	$2347,$256C,$278D,$29AB
		dc	$2BC6,$2DDE,$2FF2,$3203
		dc	$340F,$3617,$381C,$3A1B
		dc	$3C17,$3E0D,$3FFF,$41EC
		dc	$43D3,$45B6,$4793,$496A
		dc	$4B3B,$4D07,$4ECD,$508C
		dc	$5246,$53F9,$55A5,$574B
		dc	$58E9,$5A81,$5C12,$5D9C
		dc	$5F1E,$6099,$620C,$6378
		dc	$64DC,$6638,$678D,$68D9
		dc	$6A1D,$6B58,$6C8B,$6DB6
		dc	$6ED9,$6FF2,$7103,$720B
		dc	$730A,$7400,$74EE,$75D2
		dc	$76AD,$777E,$7846,$7905
		dc	$79BB,$7A67,$7B09,$7BA2
		dc	$7C31,$7CB7,$7D32,$7DA4
		dc	$7E0D,$7E6B,$7EC0,$7F0A
		dc	$7F4B,$7F82,$7FAF,$7FD2
		dc	$7FEB,$7FFA,$7FFF,$7FFA
		dc	$7FEB,$7FD2,$7FAF,$7F82
		dc	$7F4B,$7F0A,$7EC0,$7E6B
		dc	$7E0D,$7DA4,$7D32,$7CB7
		dc	$7C31,$7BA2,$7B09,$7A67
		dc	$79BB,$7905,$7846,$777E
		dc	$76AD,$75D2,$74EE,$7400
		dc	$730A,$720B,$7103,$6FF2
		dc	$6ED9,$6DB6,$6C8B,$6B58
		dc	$6A1D,$68D9,$678D,$6638
		dc	$64DC,$6378,$620C,$6099
		dc	$5F1E,$5D9C,$5C12,$5A81
		dc	$58E9,$574B,$55A5,$53F9
		dc	$5246,$508C,$4ECD,$4D07
		dc	$4B3B,$496A,$4793,$45B6
		dc	$43D3,$41EC,$3FFF,$3E0D
		dc	$3C17,$3A1B,$381C,$3617
		dc	$340F,$3203,$2FF2,$2DDE
		dc	$2BC6,$29AB,$278D,$256C
		dc	$2347,$2120,$1EF7,$1CCA
		dc	$1A9C,$186C,$1639,$1405
		dc	$11D0,$0F99,$0D61,$0B27
		dc	$08ED,$06B2,$0477,$023B
		dc	$0000,$FDC4,$FB88,$F94D
		dc	$F712,$F4D8,$F29E,$F066
		dc	$EE2F,$EBFA,$E9C6,$E793
		dc	$E563,$E335,$E108,$DEDF
		dc	$DCB8,$DA93,$D872,$D654
		dc	$D439,$D221,$D00D,$CDFC
		dc	$CBF0,$C9E8,$C7E3,$C5E4
		dc	$C3E8,$C1F2,$C000,$BE13
		dc	$BC2C,$BA49,$B86C,$B695
		dc	$B4C4,$B2F8,$B132,$AF73
		dc	$ADB9,$AC06,$AA5A,$A8B4
		dc	$A716,$A57E,$A3ED,$A263
		dc	$A0E1,$9F66,$9DF3,$9C87
		dc	$9B23,$99C7,$9872,$9726
		dc	$95E2,$94A7,$9374,$9249
		dc	$9126,$900D,$8EFC,$8DF4
		dc	$8CF5,$8BFF,$8B11,$8A2D
		dc	$8952,$8881,$87B9,$86FA
		dc	$8644,$8598,$84F6,$845D
		dc	$83CE,$8348,$82CD,$825B
		dc	$81F2,$8194,$813F,$80F5
		dc	$80B4,$807D,$8050,$802D
		dc	$8014,$8005,$8001,$8005
		dc	$8014,$802D,$8050,$807D
		dc	$80B4,$80F5,$813F,$8194
		dc	$81F2,$825B,$82CD,$8348
		dc	$83CE,$845D,$84F6,$8598
		dc	$8644,$86FA,$87B9,$8881
		dc	$8952,$8A2D,$8B11,$8BFF
		dc	$8CF5,$8DF4,$8EFC,$900D
		dc	$9126,$9249,$9374,$94A7
		dc	$95E2,$9726,$9872,$99C7
		dc	$9B23,$9C87,$9DF3,$9F66
		dc	$A0E1,$A263,$A3ED,$A57E
		dc	$A716,$A8B4,$AA5A,$AC06
		dc	$ADB9,$AF73,$B132,$B2F8
		dc	$B4C4,$B695,$B86C,$BA49
		dc	$BC2C,$BE13,$C000,$C1F2
		dc	$C3E8,$C5E4,$C7E3,$C9E8
		dc	$CBF0,$CDFC,$D00D,$D221
		dc	$D439,$D654,$D872,$DA93
		dc	$DCB8,$DEDF,$E108,$E335
		dc	$E563,$E793,$E9C6,$EBFA
		dc	$EE2F,$F066,$F29E,$F4D8
		dc	$F712,$F94D,$FB88,$FDC4
		dc	$FFFF,$023B,$0477,$06B2
		dc	$08ED,$0B27,$0D61,$0F99
		dc	$11D0,$1405,$1639,$186C
		dc	$1A9C,$1CCA,$1EF7,$2120
		dc	$2347,$256C,$278D,$29AB
		dc	$2BC6,$2DDE,$2FF2,$3203
		dc	$340F,$3617,$381C,$3A1B
		dc	$3C17,$3E0D,$3FFF,$41EC
		dc	$43D3,$45B6,$4793,$496A
		dc	$4B3B,$4D07,$4ECD,$508C
		dc	$5246,$53F9,$55A5,$574B
		dc	$58E9,$5A81,$5C12,$5D9C
		dc	$5F1E,$6099,$620C,$6378
		dc	$64DC,$6638,$678D,$68D9
		dc	$6A1D,$6B58,$6C8B,$6DB6
		dc	$6ED9,$6FF2,$7103,$720B
		dc	$730A,$7400,$74EE,$75D2
		dc	$76AD,$777E,$7846,$7905
		dc	$79BB,$7A67,$7B09,$7BA2
		dc	$7C31,$7CB7,$7D32,$7DA4
		dc	$7E0D,$7E6B,$7EC0,$7F0A
		dc	$7F4B,$7F82,$7FAF,$7FD2
		dc	$7FEB,$7FFA,$7FFF,$7FFA
		dc	$7FEB,$7FD2,$7FAF,$7F82
		dc	$7F4B,$7F0A,$7EC0,$7E6B
		dc	$7E0D,$7DA4,$7D32,$7CB7
		dc	$7C31,$7BA2,$7B09,$7A67
		dc	$79BB,$7905,$7846,$777E
		dc	$76AD,$75D2,$74EE,$7400
		dc	$730A,$720B,$7103,$6FF2
		dc	$6ED9,$6DB6,$6C8B,$6B58
		dc	$6A1D,$68D9,$678D,$6638
		dc	$64DC,$6378,$620C,$6099
		dc	$5F1E,$5D9C,$5C12,$5A81
		dc	$58E9,$574B,$55A5,$53F9
		dc	$5246,$508C,$4ECD,$4D07
		dc	$4B3B,$496A,$4793,$45B6
		dc	$43D3,$41EC,$3FFF,$3E0D
		dc	$3C17,$3A1B,$381C,$3617
		dc	$340F,$3203,$2FF2,$2DDE
		dc	$2BC6,$29AB,$278D,$256C
		dc	$2347,$2120,$1EF7,$1CCA
		dc	$1A9C,$186C,$1639,$1405
		dc	$11D0,$0F99,$0D61,$0B27
		dc	$08ED,$06B2,$0477,$023B
		dc	$0000,$FDC4,$FB88,$F94D
		dc	$F712,$F4D8,$F29E,$F066
		dc	$EE2F,$EBFA,$E9C6,$E793
		dc	$E563,$E335,$E108,$DEDF
		dc	$DCB8,$DA93,$D872,$D654
		dc	$D439,$D221,$D00D,$CDFC
		dc	$CBF0,$C9E8,$C7E3,$C5E4
		dc	$C3E8,$C1F2,$C000,$BE13
		dc	$BC2C,$BA49,$B86C,$B695
		dc	$B4C4,$B2F8,$B132,$AF73
		dc	$ADB9,$AC06,$AA5A,$A8B4
		dc	$A716,$A57E,$A3ED,$A263
		dc	$A0E1,$9F66,$9DF3,$9C87
		dc	$9B23,$99C7,$9872,$9726
		dc	$95E2,$94A7,$9374,$9249
		dc	$9126,$900D,$8EFC,$8DF4
		dc	$8CF5,$8BFF,$8B11,$8A2D
		dc	$8952,$8881,$87B9,$86FA
		dc	$8644,$8598,$84F6,$845D
		dc	$83CE,$8348,$82CD,$825B
		dc	$81F2,$8194,$813F,$80F5
		dc	$80B4,$807D,$8050,$802D
		dc	$8014,$8005,$8001,$8005
		dc	$8014,$802D,$8050,$807D
		dc	$80B4,$80F5,$813F,$8194
		dc	$81F2,$825B,$82CD,$8348
		dc	$83CE,$845D,$84F6,$8598
		dc	$8644,$86FA,$87B9,$8881
		dc	$8952,$8A2D,$8B11,$8BFF
		dc	$8CF5,$8DF4,$8EFC,$900D
		dc	$9126,$9249,$9374,$94A7
		dc	$95E2,$9726,$9872,$99C7
		dc	$9B23,$9C87,$9DF3,$9F66
		dc	$A0E1,$A263,$A3ED,$A57E
		dc	$A716,$A8B4,$AA5A,$AC06
		dc	$ADB9,$AF73,$B132,$B2F8
		dc	$B4C4,$B695,$B86C,$BA49
		dc	$BC2C,$BE13,$C000,$C1F2
		dc	$C3E8,$C5E4,$C7E3,$C9E8
		dc	$CBF0,$CDFC,$D00D,$D221
		dc	$D439,$D654,$D872,$DA93
		dc	$DCB8,$DEDF,$E108,$E335
		dc	$E563,$E793,$E9C6,$EBFA
		dc	$EE2F,$F066,$F29E,$F4D8
		dc	$F712,$F94D,$FB88,$FDC4

*
PALETTE:	
			rept	9	
		dc	couleur_logo,couleur_logo,couleur_logo,couleur_logo
			endr		
		dc	couleur_logo,$0700,$0710,$0700
		dc	$0710,$0710,$0720,$0710
		dc	$0720,$0720,$0730,$0720
		dc	$0730,$0730,$0740,$0730
		dc	$0740,$0740,$0750,$0740
		dc	$0750,$0750,$0760,$0750
		dc	$0760,$0760,$0770,$0760
		dc	$0770,$0770,$0670,$0770
		dc	$0670,$0670,$0570,$0670
		dc	$0570,$0570,$0470,$0570
		dc	$0470,$0470,$0370,$0470
		dc	$0370,$0370,$0270,$0370
		dc	$0270,$0270,$0170,$0270
		dc	$0170,$0170,$0070,$0170
		dc	$0070,$0070,$0071,$0070
		dc	$0071,$0071,$0072,$0070
		dc	$0072,$0072,$0073,$0072
		dc	$0073,$0073,$0074,$0073
		dc	$0074,$0074,$0075,$0074
		dc	$0075,$0075,$0076,$0075
		dc	$0076,$0076,$0077,$0076
		dc	$0077,$0077,$0067,$0077
		dc	$0067,$0067,$0057,$0067
		dc	$0057,$0057,$0047,$0057
		dc	$0047,$0047,$0037,$0047
		dc	$0037,$0037,$0027,$0037
		dc	$0027,$0027,$0017,$0027
		dc	$0017,$0017,$0007,$0017
		dc	$0007,$0007,$0107,$0007
		dc	$0107,$0107,$0207,$0107
		dc	$0207,$0207,$0307,$0207
		dc	$0307,$0307,$0407,$0307
		dc	$0407,$0407,$0507,$0407
		dc	$0507,$0507,$0607,$0507
		dc	$0607,$0607,$0707,$0607
		dc	$0707,$0707,$0706,$0707
		dc	$0706,$0706,$0705,$0706
		dc	$0705,$0705,$0704,$0705
		dc	$0704,$0704,$0703,$0704
		dc	$0703,$0703,$0702,$0703
		dc	$0702,$0702,$0701,$0702
		dc	$0701,$0701,$0700,$0000
PAL_LENGHT	equ	*-PALETTE	
PTR_PAL:DC.L      PALETTE 

DATA_DIGIT:DCB.W     40,0

LOGO
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0008,$0000,$0008,$000F,$0080,$0000,$0080,$FF83
		dc.w	$0008,$0000,$0008,$FFF8,$0200,$0000,$0200,$03FF
		dc.w	$2000,$0000,$2000,$E0FF,$0200,$0000,$0200,$FE01
		dc.w	$0001,$0000,$0001,$F801,$0000,$0000,$0000,$0007
		dc.w	$0000,$0000,$0000,$E000,$0400,$0000,$0400,$07FF
		dc.w	$0020,$0000,$0020,$F03F,$0001,$0000,$0001,$FF81
		dc.w	$0000,$0000,$0000,$FFFC,$0080,$0000,$0080,$7F87
		dc.w	$0000,$0000,$0000,$E3FF,$0800,$0000,$0800,$F800
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0020,$0000,$0020,$003F,$9221,$0000,$9020,$9FE3
		dc.w	$2082,$0000,$0082,$F0FE,$0824,$0000,$0824,$0FE7
		dc.w	$8800,$0000,$0800,$F8FC,$2080,$0000,$2080,$3F81
		dc.w	$0001,$A001,$0000,$F801,$0000,$0000,$0000,$0007
		dc.w	$0000,$0000,$0000,$E000,$1041,$0000,$1040,$1FC3
		dc.w	$4082,$0000,$0082,$F0FE,$0A04,$0000,$0004,$1F87
		dc.w	$1050,$0000,$1000,$F0FC,$0042,$0000,$0040,$7FC7
		dc.w	$8000,$0000,$0000,$E3F0,$8200,$0000,$8200,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$0000,$001F,$001F
		dc.w	$0001,$0000,$0001,$003F,$0A83,$0000,$0800,$0FE3
		dc.w	$8051,$0000,$0041,$F07F,$0042,$0000,$0042,$0FC3
		dc.w	$A000,$0000,$0000,$F8FC,$1000,$0400,$1000,$1F81
		dc.w	$0001,$A000,$0000,$F801,$8400,$8400,$0000,$8407
		dc.w	$0000,$0000,$0000,$E000,$0081,$0000,$0080,$1F83
		dc.w	$4004,$0000,$0004,$F0FC,$0A00,$0000,$0000,$1F87
		dc.w	$2050,$0000,$2000,$E0FC,$0122,$0000,$0120,$7FE7
		dc.w	$8000,$0000,$0000,$E3F0,$5100,$0000,$4100,$7F00
		dc.w	$3E00,$0000,$3E00,$3E00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$004B,$0020,$0077,$007F
		dc.w	$C040,$0000,$C040,$C07E,$0291,$0000,$0010,$07F3
		dc.w	$4014,$0000,$0000,$F03F,$1000,$0000,$1000,$1F81
		dc.w	$A400,$0400,$0000,$FCFC,$1000,$0400,$1000,$1F81
		dc.w	$0000,$0001,$0000,$F801,$0800,$0C00,$8400,$8C07
		dc.w	$4000,$0000,$4000,$E000,$2001,$0000,$2000,$3F03
		dc.w	$4100,$0000,$0100,$F1F8,$0008,$0000,$0008,$1F8F
		dc.w	$0050,$0000,$0000,$C0FC,$0092,$0000,$0090,$7EF7
		dc.w	$8000,$0000,$0000,$E3F0,$1400,$0000,$0000,$3F00
		dc.w	$9780,$4000,$EF80,$FF80,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00B6,$0000,$00E3,$00FF
		dc.w	$E010,$4000,$A000,$E07E,$0000,$0280,$0000,$07F0
		dc.w	$0000,$0014,$0000,$003F,$8000,$0400,$8000,$9F81
		dc.w	$0000,$A000,$0000,$FCFC,$2080,$0000,$2480,$3F80
		dc.w	$0002,$0000,$0003,$0003,$0400,$5400,$D000,$DC07
		dc.w	$0000,$0000,$0000,$E000,$0000,$0000,$0400,$3F03
		dc.w	$0000,$0020,$0000,$F1F8,$0001,$0000,$0000,$000F
		dc.w	$0000,$0000,$0000,$C0FC,$0048,$0002,$0048,$7E7F
		dc.w	$1080,$8000,$1000,$F3F0,$0001,$1400,$0001,$3F01
		dc.w	$6DC0,$0080,$C740,$FFC0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$006B,$0023,$00D4,$00FF
		dc.w	$E000,$E000,$0000,$E07F,$0000,$0280,$0000,$FFF0
		dc.w	$0000,$0014,$0000,$003F,$0000,$0000,$0000,$9FFF
		dc.w	$0000,$A000,$0020,$FCFF,$0100,$0000,$0500,$FF01
		dc.w	$0000,$0003,$0002,$FC03,$0001,$4801,$A000,$F807
		dc.w	$0000,$0000,$0000,$E000,$0000,$0000,$1000,$3FF8
		dc.w	$0000,$0080,$0000,$01F9,$0204,$0000,$0200,$FE0F
		dc.w	$0000,$0000,$0000,$FE00,$1020,$0002,$0020,$7E3F
		dc.w	$0000,$8000,$0000,$F3F0,$0000,$1400,$0001,$3F81
		dc.w	$D7C0,$47C0,$A800,$FFC0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$01FF,$005F,$01A0,$01FF
		dc.w	$5000,$E008,$B000,$F07E,$0000,$02A0,$0000,$07F0
		dc.w	$0000,$0015,$0000,$003F,$0200,$0000,$0000,$9F81
		dc.w	$0000,$A800,$0008,$FCFC,$2040,$0000,$2440,$3FC1
		dc.w	$0002,$0003,$A800,$FC03,$1000,$6800,$8800,$F807
		dc.w	$0000,$4000,$4000,$E000,$0000,$0000,$0200,$3F03
		dc.w	$0000,$0010,$0000,$F9F8,$0080,$0800,$0080,$1F8F
		dc.w	$8000,$0000,$0000,$C0FE,$0010,$0402,$0010,$7E1F
		dc.w	$0020,$A000,$0000,$F3F0,$0003,$1500,$0003,$3F83
		dc.w	$FEA0,$BFC0,$4160,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$01DA,$009F,$0145,$01FF
		dc.w	$9000,$F000,$6000,$F07E,$0000,$0000,$02A0,$07F0
		dc.w	$0000,$0000,$0015,$003F,$0000,$0000,$0000,$9F81
		dc.w	$0000,$0000,$A800,$FCFC,$1000,$0000,$1500,$1FC1
		dc.w	$0004,$0005,$A800,$FC07,$E801,$1000,$0800,$F807
		dc.w	$0000,$0000,$0000,$E000,$0000,$0800,$0801,$3F03
		dc.w	$0000,$0000,$5040,$F9F8,$0002,$0000,$0A00,$1F8F
		dc.w	$0000,$0000,$0054,$C0FE,$0008,$0000,$000A,$7E0F
		dc.w	$0100,$0000,$A000,$F3F0,$0003,$0001,$1502,$3F83
		dc.w	$B520,$3FE0,$8AC0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$01D4,$017F,$00AB,$01FF
		dc.w	$1000,$F000,$E024,$F07E,$0000,$0000,$02A0,$07F0
		dc.w	$0000,$0000,$0015,$003F,$0800,$0100,$0000,$9F81
		dc.w	$0000,$0000,$A848,$FCFC,$0020,$0000,$0520,$0FE1
		dc.w	$0002,$0009,$A808,$FC0F,$A002,$5000,$0001,$F007
		dc.w	$9000,$0000,$1000,$F000,$0884,$1400,$1C85,$3F87
		dc.w	$0004,$0040,$50A4,$F9FC,$2047,$0000,$2A40,$3FCF
		dc.w	$2100,$0000,$2154,$E1FE,$2400,$0000,$0002,$7E07
		dc.w	$0020,$0000,$A000,$F3F0,$4003,$0002,$5501,$7F83
		dc.w	$A820,$FFE0,$57C0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$01A8,$00FF,$0157,$01FF
		dc.w	$B000,$E004,$500A,$F07E,$0000,$0000,$02A0,$07F0
		dc.w	$0000,$0000,$0015,$003F,$0000,$0280,$0180,$9F81
		dc.w	$0000,$0000,$A81C,$FCFC,$0000,$0000,$0500,$0FE1
		dc.w	$0000,$001F,$A810,$FC1F,$6001,$9800,$0800,$F807
		dc.w	$0800,$0000,$0800,$F800,$0048,$0800,$0849,$3FCF
		dc.w	$0002,$0000,$5042,$F9FE,$4002,$0000,$4A00,$7FCF
		dc.w	$1200,$0000,$1254,$F3FE,$0A00,$0400,$0002,$7E07
		dc.w	$0070,$0000,$A000,$F3F0,$8003,$0001,$9502,$FF83
		dc.w	$5160,$FFC0,$AEA0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0140,$00FE,$01BF,$01FF
		dc.w	$7000,$6000,$9004,$F07E,$0000,$02A0,$02A0,$1FF0
		dc.w	$0000,$0015,$0015,$00FF,$0000,$0100,$0100,$9F87
		dc.w	$0000,$A808,$A808,$FCFC,$0000,$0540,$0540,$3FE7
		dc.w	$0000,$A82B,$A836,$FC3F,$C001,$2C00,$1400,$FC07
		dc.w	$2000,$C000,$0000,$FFFF,$0600,$0001,$0601,$3FFF
		dc.w	$0000,$5010,$5020,$F9FF,$0002,$0A80,$0A81,$FFCF
		dc.w	$4000,$0054,$8054,$FFFE,$0400,$0002,$0002,$7E1F
		dc.w	$0020,$A000,$A000,$F3FF,$0002,$1501,$1503,$FF83
		dc.w	$80E0,$FCC0,$7F20,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$00FE,$00FD,$00FF
		dc.w	$6024,$4000,$A018,$E07E,$0800,$0AA0,$02A0,$1FF0
		dc.w	$0000,$0055,$0055,$00FF,$0900,$0602,$0602,$9F87
		dc.w	$0048,$A800,$A830,$FCFC,$0000,$1542,$1542,$3FE7
		dc.w	$0002,$A800,$A803,$FC03,$1000,$DA01,$2E00,$FE07
		dc.w	$0000,$E0AA,$00AA,$FFFF,$0F00,$0005,$0F05,$3FFF
		dc.w	$0008,$4030,$4040,$F9FF,$0000,$2A00,$2A03,$FFCF
		dc.w	$0000,$0150,$C150,$FFFE,$2400,$000A,$180A,$7E1F
		dc.w	$00C0,$A000,$A000,$F3FF,$0000,$5401,$5401,$FF81
		dc.w	$04C0,$FC80,$FB40,$FFC0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00D5,$0077,$00AA,$00FF
		dc.w	$E000,$8000,$603C,$E07E,$0800,$0AA0,$02A0,$1FF0
		dc.w	$0000,$0055,$0055,$00FF,$0000,$0F02,$0F02,$9F87
		dc.w	$0000,$A800,$A878,$FCFC,$0000,$1542,$1542,$3FE7
		dc.w	$0000,$A801,$A801,$FC01,$2004,$6001,$8004,$E007
		dc.w	$0000,$E0AA,$00AA,$FFFF,$2F00,$0005,$2F05,$3FFF
		dc.w	$0918,$4060,$4900,$F9FF,$0048,$2A00,$2A4B,$FFCF
		dc.w	$0002,$0150,$C152,$FFFE,$0000,$000A,$3C0A,$7E1F
		dc.w	$01E0,$A000,$A000,$F3FF,$0081,$5400,$5481,$FF81
		dc.w	$ABC0,$EF00,$54C0,$FFC0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$007F,$003F,$0040,$007F
		dc.w	$C000,$0000,$C03C,$C07E,$0AA0,$0AA0,$0000,$1FF0
		dc.w	$0055,$0055,$0000,$00FF,$0002,$0F02,$0F00,$9F87
		dc.w	$A800,$A800,$0078,$FCFC,$1542,$1542,$0000,$3FE7
		dc.w	$A800,$A801,$0001,$FC01,$4001,$8000,$4000,$C003
		dc.w	$20AA,$C0AA,$0000,$FFFF,$0605,$0005,$0600,$1FFF
		dc.w	$4030,$4000,$0000,$F0FF,$2A02,$2A00,$0001,$FF87
		dc.w	$4150,$0150,$8000,$FFFC,$000A,$000A,$3C00,$7E1F
		dc.w	$A1E0,$A000,$0000,$F3FF,$5400,$5400,$0000,$FF00
		dc.w	$FF80,$7E00,$8180,$FF80,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$0000,$001F,$001F
		dc.w	$0024,$0000,$0018,$007E,$0AA0,$0000,$0AA0,$1FF0
		dc.w	$0055,$0000,$0055,$00FF,$0902,$0600,$0602,$9F87
		dc.w	$A848,$0000,$A830,$FCFC,$1542,$0000,$1542,$3FE7
		dc.w	$A801,$0001,$A800,$FC01,$0002,$8000,$8002,$8003
		dc.w	$00AA,$0000,$00AA,$FFFF,$1005,$0000,$1005,$1FFF
		dc.w	$1080,$0000,$1080,$F0FF,$2884,$0000,$2884,$FF87
		dc.w	$0144,$0000,$0144,$FFFC,$240A,$0000,$180A,$7E1F
		dc.w	$A0C0,$0000,$A000,$F3FF,$5100,$0000,$5100,$FF00
		dc.w	$3E00,$0000,$3E00,$3E00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$007E,$0000,$0000,$0000,$1FF0
		dc.w	$0000,$0000,$0000,$00FF,$0000,$0000,$0000,$9F87
		dc.w	$0000,$0000,$0000,$FCFC,$0000,$0000,$0000,$3FE7
		dc.w	$0001,$0000,$0001,$FC01,$0000,$0000,$0000,$0000
		dc.w	$8000,$0000,$8000,$FFFF,$0400,$0000,$0400,$07FF
		dc.w	$4020,$0000,$4020,$C03F,$0201,$0000,$0201,$FE01
		dc.w	$0010,$0000,$0010,$FFF0,$0000,$0000,$0000,$7E1F
		dc.w	$0000,$0000,$0000,$F3FF,$0400,$0000,$0400,$FC00
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
		
PalNoeXtra:
	dc.w	$0000,$0666,$0555,$0444,$0333,$0222,$0111,$00F0
	dc.w	$0766,$0655,$0544,$0667,$0556,$0445,$0777,$0FFF

LogoNoeXtra:
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0008,$0008,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$8000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0008,$0000,$0008,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$8000,$0000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0008,$0000,$0008,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$8000,$0000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0008,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0010,$0018,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0001,$0000,$0000,$0000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0018,$000C,$0014,$0000,$0000,$0000,$0000,$0000
		dc.w	$0001,$0000,$0001,$0000,$8000,$C000,$4000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0014,$0020,$003C,$0000,$0000,$0000,$0000,$0000
		dc.w	$0001,$0002,$0003,$0000,$4000,$0000,$C000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0024,$000A,$0036,$0000,$0000,$0000,$0000,$0000
		dc.w	$0002,$0000,$0003,$0000,$4000,$A000,$6000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003A,$0058,$0066,$0000,$0000,$0000,$0000,$0000
		dc.w	$0003,$0005,$0006,$0000,$2000,$0000,$E000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00F6,$013D,$01C3,$0000,$0000,$0000,$0000,$0000
		dc.w	$0008,$0010,$001F,$0000,$2000,$9000,$7000,$8000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$005C,$009C,$00E3,$0000,$852C,$0478,$FB87,$0104
		dc.w	$8005,$4009,$C00E,$0000,$F554,$F559,$0AA3,$0003
		dc.w	$2800,$E400,$1C00,$0000,$594E,$9EB1,$E011,$0011
		dc.w	$AA90,$5580,$5470,$5600,$37AB,$2854,$0054,$1256
		dc.w	$5283,$A1C6,$1039,$0204,$0058,$0098,$00E7,$0000
		dc.w	$E4AE,$05FF,$FA00,$0110,$9037,$8031,$700E,$0000
		dc.w	$7434,$8B43,$01C8,$01C8,$D000,$C802,$3801,$0001
		dc.w	$5343,$A434,$0C9C,$0C9C,$4D00,$3C80,$8380,$8000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007E,$0156,$01A9,$0028,$0BF9,$0957,$F6A8,$02A8
		dc.w	$A005,$0017,$E018,$8000,$FBFC,$735E,$8CA1,$88A1
		dc.w	$5A00,$F001,$0E01,$0800,$1407,$2F8D,$C070,$100A
		dc.w	$5540,$FFC0,$0030,$8800,$1D65,$37DF,$0000,$2800
		dc.w	$13A9,$E112,$107D,$0280,$0058,$0178,$0187,$0020
		dc.w	$4055,$02FF,$FF00,$02A2,$0012,$8019,$7026,$8020
		dc.w	$D45D,$7FF7,$8000,$8008,$5001,$F401,$0C02,$0002
		dc.w	$2545,$DFFF,$2000,$2000,$5500,$7740,$88C0,$8800
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00D4,$0294,$036B,$0040,$5D08,$59EF,$A650,$0450
		dc.w	$800F,$D02A,$3035,$0005,$770E,$37EE,$C851,$4051
		dc.w	$B800,$ED02,$1303,$1000,$8652,$DB26,$20F9,$5500
		dc.w	$0010,$0000,$FFF0,$0000,$02EB,$1B9E,$2400,$0071
		dc.w	$31CE,$62F2,$903D,$0110,$00B0,$02F0,$034F,$0040
		dc.w	$0237,$0268,$FD80,$0050,$602F,$A039,$1006,$4004
		dc.w	$0CAA,$DCFF,$2300,$0040,$2802,$FA03,$0600,$4000
		dc.w	$289E,$3EEB,$C104,$4004,$AA80,$FBA0,$0460,$0400
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0378,$01D8,$0227,$0020,$3F05,$3407,$CB08,$0A08
		dc.w	$7036,$C01C,$3023,$2002,$F801,$5001,$A802,$A002
		dc.w	$5603,$9D01,$2302,$2200,$498D,$E7E6,$1079,$2220
		dc.w	$0000,$0000,$0000,$0000,$1405,$1FEF,$2230,$0228
		dc.w	$7337,$8188,$1075,$220A,$037E,$017E,$0281,$0000
		dc.w	$8E00,$8E00,$7100,$0000,$0007,$003E,$0001,$0000
		dc.w	$0750,$F060,$0F90,$0000,$D600,$5C03,$2200,$8000
		dc.w	$5D45,$97FE,$2881,$2880,$0560,$1FC0,$0020,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00D0,$01D0,$022F,$0000,$7307,$6A0A,$9505,$1405
		dc.w	$202B,$E01E,$1021,$0001,$0801,$F002,$0801,$0001
		dc.w	$0B00,$BE01,$4102,$4000,$A64F,$E302,$18F9,$4414
		dc.w	$0000,$0000,$0000,$0000,$2A8E,$1FFB,$2000,$1154
		dc.w	$B0FB,$E3C2,$103D,$0000,$00BD,$01FD,$0202,$0000
		dc.w	$1F00,$1E00,$E100,$0000,$001E,$002E,$0011,$0010
		dc.w	$26B0,$3060,$CD90,$4000,$2A01,$FC02,$1201,$1001
		dc.w	$AEFB,$FBAA,$0445,$0444,$0E80,$0AC0,$1520,$1500
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$03FA,$037A,$0085,$0080,$F304,$DC05,$2B0A,$2A0A
		dc.w	$C03F,$6015,$902A,$800A,$5801,$F001,$0802,$0002
		dc.w	$E703,$6401,$9B00,$8202,$57F4,$F586,$0879,$2202
		dc.w	$0000,$0000,$0000,$0000,$0575,$2FDF,$3000,$0200
		dc.w	$595C,$F7D5,$0023,$8008,$037B,$03FB,$0004,$0000
		dc.w	$AF00,$AE00,$5100,$0000,$0018,$0012,$002D,$0028
		dc.w	$F490,$5160,$AE90,$2000,$F601,$5C01,$0202,$A802
		dc.w	$E77D,$65D6,$9A29,$8228,$0140,$1DC0,$0220,$0200
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$02FD,$03E9,$0016,$0014,$DF00,$8A0A,$7505,$5405
		dc.w	$A03F,$E00B,$1034,$0014,$F800,$A002,$5801,$5000
		dc.w	$B300,$8A03,$7D00,$0000,$88BB,$FFAF,$4040,$5510
		dc.w	$E800,$9400,$1000,$1000,$128A,$07FF,$1800,$0410
		dc.w	$AA28,$FFFA,$0006,$0100,$02F0,$03F7,$0008,$0004
		dc.w	$DF00,$DE00,$2100,$0000,$001C,$0029,$0016,$0014
		dc.w	$1731,$6062,$9F90,$1000,$A801,$FA02,$0601,$0001
		dc.w	$B3CB,$8A9E,$7D61,$0140,$41C0,$2A80,$5560,$5540
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01F8,$0342,$00AF,$00AA,$FD05,$5607,$A908,$A808
		dc.w	$403F,$E01F,$1020,$0000,$F800,$5000,$2803,$2002
		dc.w	$B903,$0601,$ED00,$8002,$3247,$DBED,$0410,$A8A2
		dc.w	$4000,$E000,$1C00,$2000,$0405,$08EF,$0F10,$008A
		dc.w	$5568,$FFE4,$001C,$8000,$016A,$03E4,$001F,$0000
		dc.w	$7700,$FE00,$0100,$0800,$0017,$003D,$0002,$0002
		dc.w	$7A50,$51E1,$8E12,$0A00,$5001,$F403,$0C00,$8000
		dc.w	$B8AD,$0616,$EDE9,$80A8,$2740,$5DC0,$0220,$0200
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$03D1,$0280,$017F,$0151,$3F01,$6A0C,$9503,$1401
		dc.w	$203F,$E00F,$1030,$0010,$F800,$F002,$0801,$0000
		dc.w	$9D02,$AA03,$7500,$0001,$A094,$F5D1,$0A2A,$4405
		dc.w	$9400,$D000,$2C00,$4000,$128E,$07FF,$1800,$0551
		dc.w	$AAA8,$FFFA,$0006,$4500,$00A7,$03EA,$001D,$0100
		dc.w	$6700,$BA00,$0100,$5400,$001E,$002B,$0014,$0014
		dc.w	$3D10,$0841,$D6B2,$3540,$D001,$C802,$3801,$0001
		dc.w	$9D45,$AA10,$75EF,$0144,$4A80,$0AC0,$3520,$1100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01EF,$014D,$02B2,$02A2,$9503,$7E00,$810F,$8008
		dc.w	$803F,$201F,$D020,$0000,$7800,$5000,$A803,$A002
		dc.w	$A901,$1203,$FD00,$8002,$0019,$A292,$5D65,$A20A
		dc.w	$0000,$0000,$0000,$0000,$050D,$2FAF,$3050,$0282
		dc.w	$5554,$FFFD,$0003,$02A8,$036E,$01E1,$001B,$0200
		dc.w	$5100,$FE00,$0900,$2A00,$001D,$0031,$000A,$000A
		dc.w	$1551,$B7E3,$4810,$02A0,$6801,$E403,$1C00,$0000
		dc.w	$A8AF,$9214,$7DEB,$00AA,$0F40,$1840,$07A0,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01CF,$0218,$0175,$0155,$AF02,$BA08,$4507,$4400
		dc.w	$C037,$A007,$5038,$0010,$9800,$E002,$5801,$5000
		dc.w	$D100,$8C01,$7302,$5001,$8139,$D12C,$2EC3,$5014
		dc.w	$0000,$0000,$0000,$0000,$2A2A,$1F6F,$2090,$1504
		dc.w	$A62B,$F77E,$0881,$0144,$00AC,$03E2,$001F,$0140
		dc.w	$CB00,$9E00,$2100,$4400,$0039,$003A,$0005,$0005
		dc.w	$3C72,$B923,$4290,$0041,$A803,$FA03,$0600,$0000
		dc.w	$D35B,$CF02,$30F5,$1054,$0480,$0100,$1EE0,$1140
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00DB,$0059,$03A6,$0282,$B503,$5E00,$A10E,$A008
		dc.w	$403A,$201A,$D025,$0000,$1801,$5001,$A802,$2002
		dc.w	$D501,$7E01,$8102,$8000,$40A1,$E81A,$17C5,$A82A
		dc.w	$0000,$0000,$0000,$0000,$152D,$1F8F,$2050,$0AA2
		dc.w	$5305,$E1AE,$1051,$22A0,$0359,$01F9,$0006,$02A0
		dc.w	$1500,$FE00,$0100,$A200,$003E,$003D,$0002,$0002
		dc.w	$A611,$0EE3,$D110,$A8A2,$5403,$FD03,$0300,$A800
		dc.w	$BEA3,$B4A4,$4B5B,$0A0A,$0CC0,$1A40,$07A0,$0200
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01FE,$02FB,$0104,$0104,$C903,$AA08,$1507,$1400
		dc.w	$A01B,$202F,$D030,$0010,$B801,$E002,$1801,$1001
		dc.w	$DB02,$8E01,$7102,$5001,$8120,$D464,$2B9B,$5404
		dc.w	$0000,$0000,$0000,$0000,$0BA0,$1CE5,$201A,$0505
		dc.w	$31C3,$63D6,$9029,$4010,$00EA,$03BF,$0000,$0050
		dc.w	$FB00,$AE00,$0100,$1000,$001D,$0018,$0027,$0005
		dc.w	$82B2,$87E3,$7810,$0541,$2B01,$7E01,$8102,$4400
		dc.w	$DD0F,$9D1A,$62E5,$4004,$0700,$0040,$1FA0,$1000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$017D,$01C7,$02AA,$02AA,$4106,$9606,$2909,$2808
		dc.w	$4007,$602D,$9032,$0002,$EFD7,$CFD7,$3028,$2000
		dc.w	$BC00,$1500,$EB01,$A800,$4B4C,$E8CE,$1731,$2002
		dc.w	$CD80,$F260,$0210,$0720,$1628,$1D8A,$2055,$0A82
		dc.w	$5305,$A18A,$1071,$A28A,$0201,$01FF,$0080,$02A0
		dc.w	$0D00,$F600,$0300,$0A00,$001F,$001F,$0020,$0000
		dc.w	$88F3,$8AE1,$7510,$0202,$0501,$AE01,$5102,$A000
		dc.w	$EA6F,$EA3E,$15C1,$0000,$00C0,$1840,$07A0,$0080
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$008A,$02DB,$0124,$0000,$0302,$EE0F,$5100,$5000
		dc.w	$A017,$E002,$101D,$0005,$DFEB,$8FEB,$7014,$5000
		dc.w	$E801,$BA00,$4601,$4000,$2387,$7187,$8E78,$5000
		dc.w	$AAC0,$FFC0,$0030,$4400,$0E04,$1F05,$20FA,$1101
		dc.w	$9009,$C31C,$30E3,$4114,$00BC,$02EB,$0100,$0010
		dc.w	$6B00,$BA00,$0500,$0000,$003F,$001A,$0025,$0005
		dc.w	$04D0,$05C3,$FA30,$0101,$0903,$1C01,$E302,$1400
		dc.w	$C495,$C424,$3BDB,$0010,$0E80,$0BC0,$1420,$1400
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00B5,$010A,$024A,$024A,$6903,$9604,$8108,$8008
		dc.w	$0004,$8008,$F00F,$E000,$AAAB,$0AAB,$F554,$A000
		dc.w	$E800,$E400,$1C00,$0000,$4483,$8083,$FF7C,$0000
		dc.w	$5110,$FB80,$0470,$AA00,$2492,$0E82,$317D,$0A00
		dc.w	$222A,$1009,$F1F7,$0200,$02A5,$015A,$000A,$000A
		dc.w	$6A00,$9400,$8100,$8200,$002E,$0006,$0039,$0008
		dc.w	$20A2,$0290,$FD71,$0202,$2A02,$0900,$F703,$0000
		dc.w	$8352,$8091,$7FEF,$0000,$0180,$1640,$0A20,$0A00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1640,$2620,$39E0,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$EB76,$EB76,$0000,$0000,$0180,$0180,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1300,$0280,$1D80,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$AA72,$0070,$EB06,$EB76,$A080,$8000,$6180,$E180
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0900,$1400,$1B00,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0020,$4924,$EB06,$A222,$8000,$C100,$6180,$A080
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0A00,$0100,$0F00,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$A3AE,$E3AE,$4800,$ABAE,$A380,$8380,$6000,$E380
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0600,$0C00,$0A00,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$A8A8,$EBAE,$4306,$A8A8,$8280,$C380,$6100,$A280
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0200,$0600,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$A920,$E926,$428E,$ABA8,$0100,$4100,$E280,$A380
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0400,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$AAAA,$FC71,$57DF,$ABAE,$AA80,$5C00,$F780,$AB80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0400,$0000,$0400,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0400,$0000,$0400,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0400,$0400,$0000
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
							
MUSIC:
	incbin	"IMPOSBUZ.SND"		; SNDH file to include (this one needs 50Hz replay)
	even
			
******************************************************************

	SECTION	BSS

rien0	ds.b	1000

BUFFER_1:DS.W      1 
BUFFER_2:DS.W      1 
BUFFER_3:DS.B      48348 
BUFFER_4:DS.L      1 
BUFFER_5:DS.B      156 
BUFFER_6:DS.B      16

rien1	ds.b	1000
*
BUFFERI_1:DS.B      1120
BUFFERI_2:DS.B      140 
BUFFERI_3:DS.B      32200 

rien2	ds.b	1000

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

Zorro_scr1:	ds.l	1

Zorro_screen1:	
	ds.b	256
start:	
	ds.b	160*210
Zorro_screen1_len:	equ	*-start

Zorro_scr2:	ds.l	1

Zorro_screen2:	
	ds.b	256
start2:	
	ds.b	160*210
Zorro_screen2_len:	equ	*-start2

	END
