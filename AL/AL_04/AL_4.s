* AL_4.PRG

* // Code & Ripp	 : Zorro2/NoExtra	// *
* // Gfx neochrome master: Mister. A/NoExtra	// *
* // Music 		 : Big Alec		// *
* // Release date 	 : 06/08/2006		// *

***********************************************
	opt	o-,d-
***********************************************

	SECTION	TEXT

***********************************************
COUL_RASTER	equ	$FFFF8242
NB_LIGNE_RAST	equ	198-58+1
SEEMYVBL	equ	1 ;	0 = see cpu & 1 = nothing
***********************************************

	move.l  4(sp),a5                ; address to basepage
	move.l  $0c(a5),d0              ; length of text segment
  add.l   $14(a5),d0              ; length of data segment
	add.l   $1c(a5),d0              ; length of bss segment
  add.l   #$1000,d0               ; length of stackpointer
	add.l   #$100,d0                ; length of basepage
	move.l  a5,d1                   ; address to basepage
	add.l   d0,d1                   ; end of program
	and.l   #-2,d1                  ; make address even
	move.l  d1,sp                   ; new stackspace

	move.l  d0,-(sp)                ; mshrink()
	move.l  a5,-(sp)                ;
	move.w  d0,-(sp)                ;
	move.w  #$4a,-(sp)              ;
	trap    #1                  	;
	lea 	12(sp),sp               ;  

	clr.l	-(sp)
	move.w	#32,-(sp)
	trap	#1
	addq.l	#6,sp
	move.l	d0,Save_stack

	MOVE.B    D0,SAV_D0
	MOVE.B    D1,SAV_D1
	MOVE.B    D2,SAV_D2
	MOVE.B    D3,SAV_D3
	MOVE.B    D4,SAV_D4
	MOVE.B    D5,SAV_D5
	MOVE.B    D6,SAV_D6
	MOVE.B    D7,SAV_D7
	MOVE.L    A0,SAV_A0
	MOVE.L    A1,SAV_A1
	MOVE.L    A2,SAV_A2
	MOVE.L    A3,SAV_A3
	MOVE.L    A4,SAV_A4
	MOVE.L    A5,SAV_A5
	MOVE.L    A6,SAV_A6
	CLR.B     D0
	CLR.B     D1
	CLR.B     D2
	CLR.B     D3
	CLR.B     D4
	CLR.B     D5
	CLR.B     D6
	CLR.B     D7
	SUBA.L    A0,A0 
	SUBA.L    A1,A1 
	SUBA.L    A2,A2 
	SUBA.L    A3,A3 
	SUBA.L    A4,A4 
	SUBA.L    A5,A5 
	SUBA.L    A6,A6 
      
	bsr	Init_screens

	bsr	Save_and_init_a_st

	bsr	fadein
	
	bsr	Init0
	
******************************************************************************

	bsr	InitRaster

	BSR INITSCROLL

	bsr	fadeoff
		
	bsr	Init_screens_logo

	bsr	Init

  MOVE.b     #$05,DELAY
  	
Main_rout:

	bsr	Wait_vbl

	IFEQ	SEEMYVBL
	clr.w	$ffff8240.w
	ENDC

*

	move.l	a0,-(sp)
  lea	GO_RASTER,a0
  tst.b	(a0)
	beq.s	.suite
	bsr	Raster
	BSR SCROLL
.suite:
	sub.b	#1,DELAY
	cmp.b	#$0,DELAY
	bne.s	.notyet
	lea	Pal(pc),a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)
	lea	GO_RASTER,a0
	st	(a0)
.notyet:
	move.l	(sp)+,a0

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


	bsr	Restore_st

	move.l  #$8080000,$FFFF8800.w ;giselect
	move.l  #$9090000,$FFFF8800.w ;giselect
	move.l  #$A0A0000,$FFFF8800.w ;giselect	

	MOVE.W  #0,D0
	bsr       MUSIC

	CLR.B     D0
	CLR.B     D1
	CLR.B     D2
	CLR.B     D3
	CLR.B     D4
	CLR.B     D5
	CLR.B     D6
	CLR.B     D7
	SUBA.L    A0,A0 
	SUBA.L    A1,A1 
	SUBA.L    A2,A2 
	SUBA.L    A3,A3 
	SUBA.L    A4,A4 
	SUBA.L    A5,A5 
	SUBA.L    A6,A6 
	MOVE.B    SAV_D0,D0
	MOVE.B    SAV_D1,D1
	MOVE.B    SAV_D2,D2
	MOVE.B    SAV_D3,D3
	MOVE.B    SAV_D4,D4
	MOVE.B    SAV_D5,D5
	MOVE.B    SAV_D6,D6
	MOVE.B    SAV_D7,D7
	MOVEA.L   SAV_A0,A0
	MOVEA.L   SAV_A1,A1
	MOVEA.L   SAV_A2,A2
	MOVEA.L   SAV_A3,A3
	MOVEA.L   SAV_A4,A4
	MOVEA.L   SAV_A5,A5
	MOVEA.L   SAV_A6,A6
      	
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

MUSIC:
 incbin "WICKED.MUS"
	even	

************************************************
*                                              *
*               Sub Routines                   *
*                                              *
************************************************

Vbl0:
	ST        VSYNC 

	movem.l	d0-d7/a0-a6,-(sp)
	bsr	(MUSIC+4)
	movem.l	(sp)+,d0-d7/a0-a6
	rte

Vbl:

	ST        VSYNC 

	ANDI.W    #$F1FF,(A7) 
	MOVE.W    D0,-(A7)
  MOVE      SR,D0 
  ANDI.W    #$F1FF,D0 
  move.w    #34,DATA_R09
	tst				DATA_R08
	bne.s			VBL_BIS      
  MOVE      D0,SR 
	MOVE.W    (A7)+,D0
	rte

VBL_BIS:	
	movem.l	d0-d7/a0-a6,-(sp)
	bsr	(MUSIC+4)
	movem.l	(sp)+,d0-d7/a0-a6
	
	move	d0,sr
	move	(a7)+,d0
	rte
	
Wait_vbl:	move.l	a0,-(a7)

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

Init0:	movem.l	d0-d7/a0-a6,-(a7)

	clr.w	$ffff8240.w

	movea.l	Zorro_scr1,a1
	adda.l	#160*76,a1
	movea.l	#LogoNoeXtra,a0
	move.l	#7999-6800+180,d0
aff:	move.l	(a0)+,(a1)+
	dbf	d0,aff
	
	lea	Vbl0(pc),a0
	move.l	a0,$70.w

	lea     PalNoeXtra,a2
	bsr     fadeon	
	
	movem.l	(a7)+,d0-d7/a0-a6
	rts

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

	MOVE.L    $068.W,PATCH
	
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

	clr.b	$FFFFFA07.w
	clr.b	$FFFFFA09.w
	bset	#0,$fffffa07.w	* Timer B on
	bset	#0,$fffffa13.w	* Timer B on
		
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

	MOVE.L    PATCH,$068.W
	
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

Init_screens_logo:
	movem.l	d0-d7/a0-a6,-(a7)
* logo AL
top	equ	2000+300-60

	movea.l	Zorro_scr1,a1
	movea.l	#IMG_LOGO,a0
	move.l	#7999-top,d0
.aff1:	move.l	(a0)+,(a1)+
	dbf	d0,.aff1

	movea.l	Zorro_scr2,a1
	movea.l	#IMG_LOGO,a0
	move.l	#7999-top,d0
.aff2:	move.l	(a0)+,(a1)+
	dbf	d0,.aff2

* url
top2	equ	7999-635

	movea.l	Zorro_scr1,a1
	lea	146*160(a1),a1
	movea.l	#AL_COM,a0
	move.l	#7999-top2,d0
.aff3:	move.l	(a0)+,(a1)+
	dbf	d0,.aff3

	movea.l	Zorro_scr2,a1
	lea	146*160(a1),a1
	movea.l	#AL_COM,a0
	move.l	#7999-top2,d0
.aff4:	move.l	(a0)+,(a1)+
	dbf	d0,.aff4
	movem.l	(a7)+,d0-d7/a0-a6
	rts

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
fill:
	move.l	#$0,(a6)+
	dbra	d1,fill

	movea.l	Zorro_scr2,a6
	move.w	#Zorro_screen2_len/4-1,d1
fill2:
	move.l	#$0,(a6)+
	dbra	d1,fill2

	movem.l	(a7)+,d0-d7/a0-a6
	rts


******************************************************************

InitRaster:       LEA       PAL_RASTER,A0 
                  LEA       512(A0),A1
                  MOVEQ     #128-1,D0 
.loopa:           MOVE.W    (A0)+,-(A1) 
                  DBF       D0,.loopa 
                  LEA       PAL_RASTER,A0 
                  LEA       1024(A0),A1 
                  MOVE.W    #$FF,D0 
.loopa0:          MOVE.W    (A0)+,D1
                  MOVE.W    #$1FC,D2
                  SUB.W     D1,D2 
                  MOVE.W    D2,-(A1)
                  DBF       D0,.loopa0 
                  LEA       PAL_RASTER,A0 
                  LEA       1024(A0),A1 
                  MOVE.W    #$209,D0
.loopa1:          MOVE.W    (A0)+,(A1)+ 
                  DBF       D0,.loopa1 
                  LEA       DATA_R06,A0 
                  LEA       DATA_R07,A1 
                  MOVE.W    #$3FF,D0
                  CLR.W     D1
.loopa2:          MOVE.W    D1,D2 
                  LSR.W     #1,D2 
                  ANDI.W    #$FFFE,D2 
                  LEA       0(A1,D2.W),A2 
                  MOVE.L    A2,(A0)+
                  MOVE.W    D1,D2 
                  ANDI.W    #2,D2 
                  NEG.W     D2
                  ADDQ.W    #7,D2 
                  MOVE.W    D2,(A0)+
                  NEG.W     D2
                  ADDQ.W    #7,D2 
                  MOVE.W    D2,(A0)+
                  ADDQ.W    #1,D1 
                  DBF       D0,.loopa2 
									move	    #1,DATA_R08

									MOVE.W    #1,D0
									bsr       MUSIC

                  LEA       PARAM_RA,A0 
                  MOVE.W    (A0)+,D0
                  ADD.W     D0,D0 
                  ADD.W     D0,D0 
                  MOVE.W    D0,goback_0 
                  MOVE.W    (A0)+,D0
                  ADD.W     D0,D0 
                  EXT.L     D0
                  MOVE.L    D0,goback_2 
                  MOVE.W    (A0)+,D0
                  MOVE.W    D0,next0 
                  MOVE.W    (A0)+,D0
                  ADD.W     D0,D0 
                  ADD.W     D0,D0 
                  MOVE.W    D0,goback_1 
                  MOVE.W    (A0)+,D0
                  ADD.W     D0,D0 
                  EXT.L     D0
                  MOVE.L    D0,goback_4 
                  MOVE.W    (A0)+,D0
                  MOVE.W    D0,goback_3 
                  MOVE.W    (A0)+,data0
                  MOVE.W    (A0)+,data3
                  MOVE.W    (A0)+,data6
                  MOVE.W    (A0)+,data1
                  MOVE.W    (A0)+,data4
                  MOVE.W    (A0)+,data7
                  MOVE.W    (A0)+,data2
                  MOVE.W    (A0)+,data5
                  MOVE.W    (A0)+,data8
                  MOVE.W    (A0)+,D0
                  LEA       PAL_RASTER,A0 
                  LEA       DATA_R04,A1 
                  MOVE.W    #$3FF,D0
                  MOVE.W    #1,D3 
next0:            EQU       *-2 
.loop0:           MOVE.W    (A0),D1 
                  ADDA.L    #1,A0 
goback_2:         EQU       *-4 
                  LSR.W     D3,D1 
                  ANDI.B    #$FC,D1 
                  ADD.W     D1,D1 
                  ADD.W     D1,D1 
                  MOVE.W    D1,(A1)+
                  CMPA.L    #DATA_R00,A0
                  BCS.S     .next1
                  SUBA.L    #$400,A0
.next1:           DBF       D0,.loop0 
                  LEA       PAL_RASTER,A0 
                  LEA       DATA_R05,A1 
                  MOVE.W    #$3FF,D0
                  MOVE.W    #1,D3 
goback_3:         EQU       *-2 
.loop1:           MOVE.W    (A0),D1 
                  ADDA.L    #1,A0 
goback_4:         EQU       *-4 
                  LSR.W     D3,D1 
                  ANDI.B    #$FC,D1 
                  ADD.W     D1,D1 
                  ADD.W     D1,D1 
                  MOVE.W    D1,(A1)+
                  CMPA.L    #DATA_R00,A0
                  BCS.S     .next2
                  SUBA.L    #$400,A0
.next2:           DBF       D0,.loop1 
                  MOVE.W    #$C6,D3 
                  LEA       DATA_R07,A0 
loop2:            MOVEQ     #$7F,D0 
loop3:            MOVE.W    D0,D1 
                  ADDI.W    #1,D1 
data0:            EQU       *-2 
                  MOVE.W    #1,D4 
data1:            EQU       *-2 
                  LSR.W     D4,D1 
                  ANDI.W    #$F,D1
                  CMP.W     #7,D1 
                  BLS.S     .next3
                  NEG.W     D1
                  ADDI.W    #$F,D1
.next3:           MOVE.W    #1,D4 
data2:            EQU       *-2 
                  LSL.W     D4,D1 
                  MOVE.W    D0,D2 
                  ADDI.W    #2,D2 
data3:            EQU       *-2 
                  MOVE.W    #2,D4 
data4:            EQU       *-2 
                  LSR.W     D4,D2 
                  ANDI.W    #$F,D2
                  CMP.W     #7,D2 
                  BLS.S     .next4
                  NEG.W     D2
                  ADDI.W    #$F,D2
.next4:           MOVE.W    #2,D4 
data5:            EQU       *-2 
                  LSL.W     D4,D2 
                  ADD.W     D2,D1 
                  MOVE.W    D3,D2 
                  ADDI.W    #3,D2 
data6:            EQU       *-2 
                  MOVE.W    #3,D4 
data7:            EQU       *-2 
                  LSR.W     D4,D2 
                  ANDI.W    #$F,D2
                  CMP.W     #7,D2 
                  BLS.S     .next5
                  NEG.W     D2
                  ADDI.W    #$F,D2
.next5:           MOVE.W    #3,D4 
data8:            EQU       *-2 
                  LSL.W     D4,D2 
                  ADD.W     D2,D1 
                  MOVE.W    D1,(A0)+
                  DBF       D0,loop3 
                  DBF       D3,loop2 
									clr       DATA_R08
									RTS	

Raster:           LEA       COUL_RASTER.W,A1
                  LEA       DATA_R07,A0 
                  LEA       DATA_R04,A3 
                  LEA       DATA_R05,A5 
                  LEA       DATA_R06,A4 
                  MOVE.W    #NB_LIGNE_RAST,D0 
                  LEA       $FFFF8209.W,A6
                  MOVE.W    #$12,D7 
.loop:            TST.B     (A6)
                  BEQ.S     .loop
                  SUB.B     (A6),D7 
                  LSR.L     D7,D7 
                  MOVE      #$2700,SR 
                  NOP 
                  CLR.L     D4
                  MOVE.W    DATA_R01,D4 
                  ADDI.W    #4,DATA_R01 
goback_0:         EQU       *-6 
                  ANDI.W    #$3FF,DATA_R01
                  LEA       0(A3,D4.W),A3 
                  CLR.L     D4
                  MOVE.W    DATA_R02,D4 
                  ADDI.W    #4,DATA_R02 
goback_1:         EQU       *-6 
                  ANDI.W    #$3FF,DATA_R02
                  LEA       0(A5,D4.W),A5 
                  CLR.L     D1
                  CLR.L     D2
                  MOVE.L    #$100,D4
.loop0:           ADD.L     D4,D2 
                  MOVE.W    (A3)+,D1
                  ADD.W     (A5)+,D1
                  LEA       0(A4,D1.W),A6 
                  MOVEA.L   (A6)+,A0
                  ADDA.L    D2,A0 
                  MOVE.W    (A6)+,D1
                  LSR.W     D1,D3 
                  NOP 
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A6)+,D1
                  LSR.W     D1,D3 
                  DBF       D0,.loop0 
                  CLR.W     (A1)
                  move      #1,DATA_R08
                  MOVE      #$2300,SR
                  RTS

******************************************************************

INITSCROLL:
	MOVE.W #(20*160),D0
	LEA SCBUF1,A0
CLBUF1:	MOVE.L #0,(A0)+
	DBRA D0,CLBUF1
	MOVE.L #MESSAGE,MESPOS
	MOVE.L #FONT+$88,CHARADDR ; SPACE
	RTS
	
SCROLL:
	MOVE.W SCROLLX,D0
	ADDQ.W #2,SCROLLX
	CMP.W #$54,SCROLLX
	BLT.S SCOK1
	CLR.W SCROLLX
SCOK1:
	MOVE.W D0,D1
	ANDI.W #3,D0
	ADD.W D0,D0
	ADD.W D0,D0 ;=0,8
	MOVE.W D0,NSHIFTS
	LEA SCRTABLE,A0
	MOVE.L (A0,D0.W),A1
	ANDI.W #$FFFC,D1
	ADD.W D1,D1
	ADD.W D1,A1 ;ADD OFFSET OT BUF ADDR
	TST.W D0
	BNE SCRSKIP
	CMPI.W #2,CHARCNT
	BNE LETOK
	MOVEQ #0,D1
	MOVE.W D1,CHARCNT
;GETLET
	MOVE.L MESPOS,A2
TRYAGAIN:
	MOVE.B (A2)+,D1
	BPL.S SCOK2
	LEA MESSAGE,A2
	BRA TRYAGAIN
SCOK2:
	MOVE.L A2,MESPOS
	CMP.B #32,D1
	BLT TRYAGAIN
	SUB.B #32,D1
	ADD.W D1,D1
	LEA CHARTAB,A2
	MOVE.W (A2,D1),D1
	MOVE.L #FONT+128,CHARADDR
	ADD.L D1,CHARADDR
	BRA SCRCONT
LETOK:
	ADDQ.L #8,CHARADDR
SCRCONT:
	ADDQ.W #1,CHARCNT
SCRSKIP:
	MOVE.L CHARADDR,A0
	MOVE.L A1,A2 ; BUF ADDR
	MOVEQ #31,D1 ; HEIGHT
	MOVE.W NSHIFTS,D2
UPDATE:
	MOVEQ #0,D0
	MOVE.W (A0),D0
	LSL.L D2,D0
	MOVE.W D0,$08(A2)
	MOVE.W D0,$B0(A2)
	SWAP D0
	OR.W D0,$00(A2)
	OR.W D0,$A8(A2)
	
	MOVEQ #0,D0
	MOVE.W 2(A0),D0
	LSL.L D2,D0
	MOVE.W D0,$0A(A2)
	MOVE.W D0,$B2(A2)
	SWAP D0
	OR.W D0,$02(A2)
	OR.W D0,$AA(A2)
	
	MOVEQ #0,D0
	MOVE.W 4(A0),D0
	LSL.L D2,D0
	MOVE.W D0,$0C(A2)
	MOVE.W D0,$B4(A2)
	SWAP D0
	OR.W D0,$04(A2)
	OR.W D0,$AC(A2)
	
	MOVEQ #0,D0
	MOVE.W 6(A0),D0
	LSL.L D2,D0
	MOVE.W D0,$0E(A2)
	MOVE.W D0,$B6(A2)
	SWAP D0
	OR.W D0,$06(A2)
	OR.W D0,$AE(A2)
	
	LEA $A0(A0),A0
	LEA $150(A2),A2
	DBRA D1,UPDATE
	 
;NOTE A1 ADDR, A0=DEST
	MOVE.L Zorro_scr1,A0
	lea		160*200(a0),a0

	LEA 16(A1),A1
OFFSET	SET $28B0
	REPT 32
	MOVE.L $9C+OFFSET(A1),-(A0)
	MOVEM.L $68+OFFSET(A1),D0-D7/A2-A6
	MOVEM.L D0-D7/A2-A6,-(A0)
	MOVEM.L $34+OFFSET(A1),D0-D7/A2-A6
	MOVEM.L D0-D7/A2-A6,-(A0)
	MOVEM.L OFFSET(A1),D0-D7/A2-A6
	MOVEM.L D0-D7/A2-A6,-(A0)
OFFSET	SET OFFSET-$150
	ENDR
	RTS	

fadein
	movem.l	d0-d7/a0-a6,-(a7)
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
	movem.l	(a7)+,d0-d7/a0-a6
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
		dc.w	$0000,$000F,$0111,$0444,$0222,$0555,$0333,$0DDD
		dc.w	$0011,$0122,$0344,$0455,$0566,$0677,$0233,$0FFF

SAV_D0:DC.B      $00 
SAV_D1:DC.B      $00 
SAV_D2:DC.B      $00 
SAV_D3:DC.B      $00 
SAV_D4:DC.B      $00 
SAV_D5:DC.B      $00 
SAV_D6:DC.B      $00 
SAV_D7:DC.B      $00 
SAV_A0:DCB.W     2,0 
SAV_A1:DCB.W     2,0 
SAV_A2:DCB.W     2,0 
SAV_A3:DCB.W     2,0 
SAV_A4:DCB.W     2,0 
SAV_A5:DCB.W     2,0 
SAV_A6:DCB.W     2,0 
PATCH:DCB.W      2,0 

DELAY:	ds.b	1
		ds.b	1
GO_RASTER:	ds.b	1
		ds.b	1

IMG_LOGO:
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$000F,$005F,$0030,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$F000,$F900,$0E00,$0000
		dc.w	$0FFF,$5FFF,$3000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFF0,$FFFA,$000C,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0000,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0340,$0180,$0000
		dc.w	$3FFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFC,$0000,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FF00,$00B0,$0060,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFC,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0043,$004C,$0000,$00BF,$CC00,$F000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFC0,$0038,$0010,$0000
		dc.w	$3F00,$43CC,$4CF0,$0000,$BFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003E,$0044,$004E,$0000,$7FFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFE0,$0018,$0008,$0000
		dc.w	$3E7F,$4400,$4E00,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0000,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003D,$0048,$0044,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F007,$0BE8,$07F0,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFF0,$0004,$0008,$0000
		dc.w	$3DFF,$4800,$4400,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003B,$0048,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F007,$0410,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFF0,$0008,$0004,$0000
		dc.w	$3BFF,$4800,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0033,$0048,$0048,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F007,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFF8,$0006,$0004,$0000
		dc.w	$33FF,$4800,$4800,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0037,$0048,$0048,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0008,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFC,$0004,$0002,$0000
		dc.w	$37FF,$4800,$4800,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0037,$0040,$0048,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0008,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFC,$0002,$0002,$0000
		dc.w	$37FF,$4000,$4800,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0037,$0040,$0048,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0000,$0000
		dc.w	$37FF,$4000,$4800,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0037,$0048,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0000,$0002,$0000
		dc.w	$37FF,$4800,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0037,$0048,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$37FF,$4800,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0037,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$37FF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0037,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$37FF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0037,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$37FF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$8000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0003,$0000,$0000,$0003,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$000A,$0004,$0004,$000B,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0004,$0018,$0000,$001E,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFC9,$0007,$0005,$003A,$6800,$3000,$F000,$8C00
		dc.w	$2030,$0038,$0038,$2004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFD,$0000,$0000,$0003,$3900,$CE00,$BA00,$4580
		dc.w	$8018,$4010,$4070,$C068,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$5880,$2701,$0501,$7AC2
		dc.w	$40E0,$8030,$80E0,$C018,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0080,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0941,$1082,$0083,$1F44
		dc.w	$8020,$8070,$01B0,$0040,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0002
		dc.w	$003F,$0040,$0040,$0080,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0443,$0805,$0806,$04E8
		dc.w	$8060,$0030,$0330,$80C8,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0002
		dc.w	$00BF,$0040,$0040,$0080,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$082F,$0402,$0405,$0A78
		dc.w	$0600,$0038,$0628,$8054,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0002,$0002,$0000
		dc.w	$00BF,$0040,$0040,$0080,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0007,$0405,$040B,$0A10
		dc.w	$8008,$003C,$0C2C,$DC52,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0002,$0002,$0000
		dc.w	$00BF,$0040,$0040,$0080,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$040B,$0817,$081F,$1610
		dc.w	$785A,$9828,$9834,$6046,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0002,$0002,$0001
		dc.w	$003F,$0040,$0040,$0080,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$180E,$0031,$0031,$3C2E
		dc.w	$402E,$B066,$007A,$F091,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0003,$0002,$0002,$0003
		dc.w	$003F,$0040,$0040,$0080,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$2040,$0020,$0020,$7041
		dc.w	$20A3,$C07E,$C026,$20DF,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0003,$0002,$0003
		dc.w	$003F,$0040,$0040,$0080,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0041,$0040,$0000,$C083
		dc.w	$801F,$00E6,$0086,$817B,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0003,$0003,$0003,$0000
		dc.w	$803F,$0040,$0040,$8180,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0080,$0000,$0000,$8086
		dc.w	$012B,$00C6,$00C2,$013F,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0003,$0000,$0003,$0000
		dc.w	$413F,$8040,$0040,$C300,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0001,$0000,$0000,$0000,$8080
		dc.w	$01D0,$000E,$000C,$03F3,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0003,$0002,$0003,$0000
		dc.w	$223F,$C040,$8040,$6700,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0001,$0000,$0000,$0000,$0000
		dc.w	$03E2,$0000,$0000,$03F2,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0003,$0001,$0002
		dc.w	$563F,$A040,$A040,$5E00,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0001,$0000,$0000,$0000,$0000
		dc.w	$0380,$0000,$0000,$07C2,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0003,$0002,$0001
		dc.w	$3C3F,$8040,$8040,$7E00,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0700,$0000,$0000,$0790,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0001,$0001,$0002
		dc.w	$003F,$8040,$0040,$DC00,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0500,$0210,$0210,$05A0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0003
		dc.w	$403F,$8040,$8040,$4000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$01D0,$0330,$0330,$04D0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0001
		dc.w	$803F,$4040,$4040,$A000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0030,$01F0,$0170,$02B0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0020,$0020,$0020,$0000
		dc.w	$603F,$0040,$0040,$F000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0090,$0050,$0060,$01A0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0020,$0000,$0020,$0020
		dc.w	$103F,$0040,$0040,$3000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0060,$0030,$0030,$00C0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0020,$0030,$0030,$0020
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0060,$0040,$00A4,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0034,$0038,$0038,$0024
		dc.w	$04BF,$0340,$0140,$0E80,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0024,$0040,$0040,$00AC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0031,$002E,$003E,$0001
		dc.w	$083F,$03C0,$06C0,$9B00,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$004C,$0004,$0004,$7CDC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0032,$002F,$003D,$0000
		dc.w	$45BF,$9C40,$8A40,$5F80,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0001,$0000,$0000,$0003
		dc.w	$E01C,$000C,$000C,$F07C,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0026,$0000,$0018,$003F
		dc.w	$0E3F,$2B40,$1740,$BC80,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0004,$0003,$0003,$000C
		dc.w	$802C,$0000,$001C,$C070,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001E,$000C,$000C,$0013
		dc.w	$05BF,$0940,$0F40,$1280,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$000A,$0004,$0000,$001F
		dc.w	$0038,$0014,$001C,$0060,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0009,$0006,$0000,$000F
		dc.w	$023F,$04C0,$03C0,$0D00,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$001C,$0008,$0008,$0036
		dc.w	$0010,$0038,$0018,$0060,$0000,$0000,$0000,$0400
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0001,$0001,$0002
		dc.w	$473F,$82C0,$8340,$6480,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0038,$0010,$0010,$002C
		dc.w	$0060,$0030,$0030,$00C8,$0000,$0400,$0400,$0800
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$88BF,$72C0,$71C0,$8F00,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0010,$0020,$0000,$0078
		dc.w	$0000,$0060,$0040,$00B0,$0800,$0000,$0400,$0E00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$08BF,$02C0,$03C0,$1D00,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0040,$0020,$0000,$0070
		dc.w	$0000,$0060,$0060,$0090,$0400,$0E00,$0E00,$1500
		dc.w	$0000,$8000,$0000,$8000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$043F,$02C0,$03C0,$0500,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0020,$0040,$0040,$0020
		dc.w	$0060,$0000,$0000,$00F0,$1C00,$0F00,$0F00,$3681
		dc.w	$8000,$4000,$8000,$4000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$02BF,$0740,$0640,$0980,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0040,$0040,$00A0
		dc.w	$0020,$0000,$0000,$0070,$2000,$1C81,$0B81,$3542
		dc.w	$A000,$C000,$C000,$6000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01BF,$0A40,$0C40,$1780,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$00C0,$0000,$0000,$00C0
		dc.w	$0010,$0000,$0000,$0070,$1525,$2342,$23C1,$5CBE
		dc.w	$5200,$0000,$E000,$9220,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$073F,$1440,$1C40,$2B80,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0080,$0000,$0000,$00C0
		dc.w	$0000,$0000,$0000,$0038,$4346,$00FC,$0077,$EF89
		dc.w	$8D20,$B200,$E000,$7F60,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$023F,$3440,$3C40,$5300,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0080,$0000,$0000,$0080
		dc.w	$0000,$0000,$0000,$001F,$0185,$0041,$003F,$C7FA
		dc.w	$4140,$BE20,$9000,$6F70,$0000,$0000,$0000,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$00F1
		dc.w	$343F,$B840,$F040,$7E00,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0080
		dc.w	$0000,$0000,$0000,$0007,$00D9,$003E,$003A,$05C5
		dc.w	$50A0,$2F60,$2A20,$D7D0,$0000,$0000,$0000,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0244,$01F8,$0158,$06A6
		dc.w	$503F,$3840,$3840,$C400,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0080
		dc.w	$0000,$0000,$0000,$0000,$000E,$0000,$0000,$003F
		dc.w	$28D0,$07C0,$04E0,$FB18,$0200,$0000,$0000,$0700
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0020,$0020,$0000,$0623,$0240,$03C0,$0DBF
		dc.w	$143F,$0840,$0040,$BC00,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$000E
		dc.w	$042C,$0340,$03C0,$2CEE,$0A00,$0400,$0400,$3A00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0020,$0020,$0020,$0000,$0F80,$0500,$0700,$08C1
		dc.w	$C83F,$0440,$0440,$DA00,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0004
		dc.w	$0243,$0100,$0080,$07C7,$E800,$1C00,$1C00,$E200
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0020,$0020,$0780,$0A00,$0600,$09E0
		dc.w	$023F,$0040,$0040,$3F00,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0280,$0100,$0000,$0783,$3800,$6800,$7800,$8400
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0020,$0020,$0020,$0030,$0DC0,$0A00,$0E00,$01F0
		dc.w	$003F,$0040,$0040,$0300,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0200,$0000,$0000,$0701,$E000,$4000,$7000,$9800
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0030,$0020,$0020,$0030,$0F20,$0400,$0C00,$03F0
		dc.w	$003F,$0040,$0040,$0180,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0001,$0000,$0000,$0603,$0000,$E000,$A000,$5000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0020,$0010,$0030,$0008,$0810,$0C00,$0C00,$0A38
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0003,$0000,$0000,$0007,$8000,$0000,$0000,$C000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0028,$0030,$0010,$0008,$0810,$0800,$0800,$0018
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$001E,$0000,$0000,$0000,$0400
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0020,$0018,$0028,$0014,$0810,$0000,$0000,$0818
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0800
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0014,$0018,$0038,$0026,$0010,$0000,$0000,$0038
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0800
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$001A,$0034,$0014,$002B,$0020,$0000,$0000,$00F0
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$4200,$3C00,$2C00,$5300,$0000,$0000,$0000,$1000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$000C,$0033,$0023,$001C,$81C0,$0000,$0000,$C7E0
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0001
		dc.w	$9880,$7900,$5E00,$A780,$0000,$0000,$0000,$1000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0021,$0018,$0018,$0023,$0600,$F800,$F800,$0780
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0003
		dc.w	$3300,$CC80,$CB00,$34C0,$0000,$0000,$0000,$1800
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0014,$0008,$0008,$0014,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0003,$0000,$0000,$0007
		dc.w	$85C0,$0000,$0380,$CE40,$0000,$0000,$0000,$1C00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$000A,$0004,$0004,$000A,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0007
		dc.w	$0380,$02C0,$03C0,$8400,$0409,$0006,$0006,$0E19
		dc.w	$0000,$0000,$0000,$8000,$0000,$0000,$0000,$0000
		dc.w	$0007,$0000,$0000,$0007,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0800,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$000C
		dc.w	$0780,$0240,$03C0,$0400,$0525,$021D,$0217,$0DEA
		dc.w	$4000,$8000,$8000,$6000,$0000,$0000,$0000,$0000
		dc.w	$000F,$0007,$0007,$000B,$9000,$E000,$8000,$F000
		dc.w	$003F,$0040,$0040,$0800,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$03C0,$0480,$0780,$0840,$0200,$01FE,$01FD,$0603
		dc.w	$9000,$6000,$A000,$5800,$0000,$0000,$0000,$0000
		dc.w	$001C,$0007,$000C,$0017,$8000,$0000,$0000,$C000
		dc.w	$003F,$0040,$0040,$1800,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0280,$0F00,$0A00,$1580,$01F1,$000F,$000D,$03F2
		dc.w	$4800,$7000,$9000,$EC00,$0000,$0000,$0000,$0000
		dc.w	$0012,$003C,$0030,$000E,$4000,$0000,$0000,$E000
		dc.w	$103F,$0040,$0040,$1800,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$2200,$1C00,$1C00,$6200,$0001,$001E,$0012,$002D
		dc.w	$0000,$0000,$0000,$E000,$0000,$0000,$0000,$0000
		dc.w	$0074,$0028,$0030,$004C,$3000,$0000,$0000,$7800
		dc.w	$103F,$0040,$0040,$3800,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$7000,$0000,$0000,$F800,$0020,$0018,$0008,$7C74
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$000C,$0050,$0020,$00FE,$1800,$0000,$0000,$3C00
		dc.w	$303F,$0040,$0040,$3000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0001
		dc.w	$0001,$0000,$0000,$E003,$C010,$0020,$0020,$E058
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0052,$0064,$0044,$00BB,$0C00,$0000,$0000,$0C00
		dc.w	$103F,$2040,$2040,$5000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0001,$0006,$0006,$0009,$0060,$0000,$0000,$80F0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00C4,$0063,$0063,$0094,$8400,$0000,$0000,$CC00
		dc.w	$403F,$2040,$2040,$D000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0012,$000C,$0000,$003F,$0040,$0000,$0000,$00E0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00A1,$0040,$0000,$00E3,$0800,$F000,$F000,$0C01
		dc.w	$A03F,$4040,$0040,$E000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0024,$0008,$0010,$007E,$0040,$0000,$0000,$00F0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0080,$0040,$0000,$00E1,$0001,$0000,$0000,$F803
		dc.w	$C03F,$8040,$8040,$6000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0060,$0030,$0030,$00C8,$0020,$0000,$0000,$0070
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0080,$0040,$0040,$00A0,$0003,$0001,$0001,$0006
		dc.w	$803F,$0040,$0040,$C000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0080,$0060,$0020,$00D0,$0030,$0000,$0000,$0078
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00A0,$0040,$0040,$00A0,$0009,$0006,$0000,$001F
		dc.w	$003F,$0040,$0040,$8000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0040,$0080,$0080,$0160,$0008,$0010,$0010,$002C
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0040,$0020,$0020,$00D0,$0024,$0018,$0018,$0066
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0180,$0000,$0000,$01C0,$0004,$0018,$0010,$002C
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0050,$0020,$0020,$0058,$00E0,$0000,$0000,$07F0
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0008,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$82AB,$4447,$0000
		dc.w	$0004,$AAAE,$C71B,$0000,$0401,$AE8B,$1B06,$0000
		dc.w	$0100,$A000,$C000,$0380,$0014,$000C,$0004,$007A
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0028,$0010,$0010,$006C,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0008,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$2802,$6C06,$C60C,$0000
		dc.w	$0208,$0718,$0530,$0000,$0802,$1906,$318C,$0000
		dc.w	$0200,$4000,$6000,$0300,$0034,$000E,$000C,$00F2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003C,$0000,$0000,$003E,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F007,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$7442,$D6E6,$B2AC,$0000
		dc.w	$0718,$0530,$0228,$0000,$1906,$398C,$208A,$0000
		dc.w	$4200,$6000,$2000,$0700,$0185,$007C,$0076,$038B
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0090,$0060,$0060,$009F,$4800,$3000,$3000,$CE00
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F007,$0000,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$E6E0,$A2AB,$6447,$0000
		dc.w	$073F,$A22D,$C71E,$0000,$398E,$308A,$0906,$0000
		dc.w	$6000,$2000,$4000,$0600,$060A,$0007,$0002,$0F1D
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0241,$0180,$0080,$0363,$2000,$C000,$C000,$3800
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F007,$0808,$07F0,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$6440,$C6E0,$A2A0,$0000
		dc.w	$8718,$C530,$6228,$0000,$1F07,$3B0D,$240B,$0000
		dc.w	$C000,$6000,$A000,$0600,$0802,$0001,$0000,$0C07
		dc.w	$8000,$0000,$0000,$8000,$0000,$0000,$0000,$0000
		dc.w	$0D02,$0601,$0401,$0B86,$8000,$0000,$0000,$E000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$2000,$6440,$C6E0,$0000
		dc.w	$8208,$C718,$6530,$0000,$0802,$1906,$318C,$0000
		dc.w	$0000,$4000,$6000,$0400,$0000,$0000,$0000,$1801
		dc.w	$8000,$0000,$0000,$8000,$0000,$0000,$0000,$0000
		dc.w	$1209,$0406,$0804,$1F3B,$0000,$0000,$0000,$8000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$A2AB,$6447,$0000
		dc.w	$0004,$A22E,$C71B,$0000,$0000,$A88A,$1926,$0000
		dc.w	$0000,$2000,$4000,$0400,$0000,$0000,$0000,$1000
		dc.w	$0000,$0000,$0000,$8000,$0000,$0000,$0000,$0000
		dc.w	$3432,$080C,$1808,$26F7,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$6A04,$0DF8,$3D10,$52EE,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$F728,$3DD0,$6340,$BCBC,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F007,$0BE8,$07F0,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$007F,$02FF,$0180,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$F000,$FA00,$0C00,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$7258,$F420,$6C00,$FA7F,$0000,$0000,$0000,$F000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F007,$0000,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$01FF,$0000,$0200,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FC00,$0000,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$E80E,$3071,$E011,$786E,$0E00,$F000,$F000,$0F00
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F007,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$01FF,$0200,$0200,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FC00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$D080,$E07F,$E039,$D0C6,$8000,$0000,$0000,$C1C0
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0008,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$01FF,$0200,$0200,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$A01A,$C0FC,$803C,$E0C3,$0040,$0000,$0000,$00E0
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0008,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$01FF,$0200,$0200,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0000,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$C108,$80D0,$8070,$41AC,$01C0,$0000,$0000,$03E0
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0002,$0000,$01FF,$0200,$0200,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$8040,$0120,$01E0,$8090,$0280,$0100,$0100,$06C0
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0000,$0002,$0000,$01FF,$0200,$0200,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0080,$00C0,$0140,$01A0,$0500,$0200,$0200,$0580
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0002,$0000,$0000,$01FF,$0200,$0200,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0140,$0100,$0080,$01C0,$0000,$0600,$0600,$0900
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFC,$0002,$0002,$0000,$01FF,$0200,$0200,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0100,$0180,$0100,$01C0,$0A00,$0400,$0000,$0F07
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFC,$0000,$0002,$0000,$01FF,$0000,$0200,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0080,$0000,$0100,$0180,$021C,$0C00,$0800,$063E
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFC,$0002,$0001,$0000,$01FF,$FA00,$FC00,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0100,$0000,$0180,$0270,$0C00,$0400,$0B78
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0100,$0000,$0000,$0100,$0B40,$0C80,$0C80,$0360
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0100,$0080,$0700,$0B00,$0CC0
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0900,$0600,$0800,$0780
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0C00,$0600,$0E00,$0100
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0E00,$0000,$0C00,$0200
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0C00,$0000,$0C00,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0C00,$0800,$0000,$0400
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0800,$0000,$0800
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0800,$0000,$0000,$0800
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0000,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0000,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0200,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FC00,$0200,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FC00,$0000,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FC00,$0400,$0200,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$F800,$0600,$0400,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$F000,$0800,$0400,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$F000,$0400,$0800,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0008,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0000,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$E000,$1800,$0800,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F807,$0808,$0008,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0002,$0000,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$C000,$3800,$1000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F007,$0808,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFC,$0002,$0002,$0000
		dc.w	$3FFF,$4000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$0000,$B000,$6000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0000,$0040,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F007,$0000,$0808,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFC,$0000,$0002,$0000
		dc.w	$3FFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0003,$0001,$0000,$0000,$4000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$000F,$0058,$0037,$0000,$FFFF,$0000,$FFFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFFF,$0000,$FFFF,$0000
		dc.w	$C001,$680B,$B006,$0000,$FFFF,$0000,$FFFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFF0,$001A,$FFEC,$0000
		dc.w	$0FFF,$5800,$37FF,$0000,$FFFF,$0000,$FFFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFFF,$0000,$FFFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFFF,$0000,$FFFF,$0000
		dc.w	$FFF0,$0019,$FFEE,$0000,$0000,$0000,$0000,$0000
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
		dc.w	$0044,$00C6,$0044,$0044,$1104,$318C,$1104,$1104
		dc.w	$4007,$600F,$4007,$4007,$C1F0,$E3F8,$C0E0,$C0E0
		dc.w	$7C3F,$FE3F,$383E,$383E,$0F8C,$8F8E,$070C,$070C
		dc.w	$01F8,$03F8,$00F8,$00F8,$7E1F,$FE3F,$3E0F,$3E0F
		dc.w	$8FC3,$8FE3,$8F83,$8F83,$F001,$F803,$E000,$E000
		dc.w	$F87C,$F8FE,$F838,$F838,$3180,$3B80,$2080,$2080
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0044,$0044,$00C6,$0044,$1104,$1104,$318C,$1104
		dc.w	$400F,$400F,$600F,$400F,$E3F8,$E3F8,$E1F0,$E1F0
		dc.w	$FE3F,$FE3F,$7C3F,$7C3F,$800C,$8F8E,$000C,$000C
		dc.w	$03F8,$03F8,$01F8,$01F8,$FE3F,$FE3F,$7E1F,$7E1F
		dc.w	$8FE3,$8FE3,$8FC3,$8FC3,$F803,$F803,$F001,$F001
		dc.w	$F8FE,$F8FE,$F87C,$F87C,$3B80,$3F80,$3180,$3180
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00C6,$00C6,$00C6,$0044,$318C,$318C,$318C,$1104
		dc.w	$600F,$600F,$600F,$400F,$63F8,$E3F8,$63F8,$63F8
		dc.w	$F63D,$FE3F,$F63D,$F63D,$8F8C,$8F8E,$8F8C,$8F8C
		dc.w	$03C0,$03E0,$03C0,$03C0,$C03C,$E03E,$C03C,$C03C
		dc.w	$0FE3,$0FE3,$0FE3,$0FE3,$D803,$F803,$D803,$D803
		dc.w	$E0F6,$E0FE,$E0F6,$E0F6,$3F80,$3F80,$3B80,$3B80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00C6,$00C6,$00C6,$00C6,$318C,$318C,$318C,$318C
		dc.w	$600F,$600F,$600F,$600F,$63F8,$E3F8,$63F8,$63F8
		dc.w	$F63D,$FE3F,$F63D,$F63D,$8F8C,$8F8E,$8F8C,$8F8C
		dc.w	$03C0,$03E0,$03C0,$03C0,$DE3C,$FE3E,$DE3C,$DE3C
		dc.w	$0FE3,$0FE3,$0FE3,$0FE3,$D803,$F803,$D803,$D803
		dc.w	$E0F6,$E0FE,$E0F6,$E0F6,$3F80,$3F80,$3F80,$3F80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00C6,$00C6,$00C6,$00C6,$318C,$318C,$318C,$318C
		dc.w	$600F,$600F,$600F,$600F,$63F8,$E3F8,$63F8,$63F8
		dc.w	$F63D,$FE3F,$F63D,$F63D,$8F8C,$8F8E,$8F8C,$8F8C
		dc.w	$03F8,$03F8,$03F8,$03F8,$DE3F,$FE3F,$DE3F,$DE3F
		dc.w	$8FE3,$8FE3,$8FE3,$8FE3,$D803,$F803,$D803,$D803
		dc.w	$E0F6,$E0FE,$E0F6,$E0F6,$3F80,$3F80,$3F80,$3F80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00C6,$00C6,$00C6,$00C6,$318C,$318C,$318C,$318C
		dc.w	$600F,$600F,$600F,$600F,$63F8,$E3F8,$63F8,$63F8
		dc.w	$F63D,$FE3F,$F63D,$F63D,$8F8C,$8F8E,$8F8C,$8F8C
		dc.w	$03F8,$03F8,$03F8,$03F8,$DE3F,$FE3F,$DE3F,$DE3F
		dc.w	$8FE3,$8FE3,$8FE3,$8FE3,$D803,$F803,$D803,$D803
		dc.w	$E0F6,$E0FE,$E0F6,$E0F6,$3F80,$3F80,$3F80,$3F80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00C6,$00C6,$00C6,$00C6,$318C,$318C,$318C,$318C
		dc.w	$600F,$600F,$600F,$600F,$E3F8,$E3F8,$E3F8,$E3F8
		dc.w	$FE3D,$FE3F,$FE3D,$FE3D,$8F8F,$8F8F,$8F8F,$8F8F
		dc.w	$E3C0,$E3E0,$E3C0,$E3C0,$DE3C,$FE3E,$DE3C,$DE3C
		dc.w	$0FE3,$0FE3,$0FE3,$0FE3,$D803,$F803,$D803,$D803
		dc.w	$E0F6,$E0FE,$E0F6,$E0F6,$3F80,$3F80,$3F80,$3F80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00C6,$00C6,$00C6,$00C6,$318C,$318C,$318C,$318C
		dc.w	$600F,$600F,$600F,$600F,$E3F8,$E3F8,$E3F8,$E3F8
		dc.w	$FE3D,$FE3F,$FE3D,$FE3D,$8F8F,$8F8F,$8F8F,$8F8F
		dc.w	$E3C0,$E3E0,$E3C0,$E3C0,$DE3C,$FE3E,$DE3C,$DE3C
		dc.w	$0FE3,$0FE3,$0FE3,$0FE3,$F803,$F803,$F803,$F803
		dc.w	$F8F6,$F8FE,$F8F6,$F8F6,$3F80,$3F80,$3F80,$3F80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00C6,$00D6,$00C6,$00C6,$318C,$358D,$318C,$318C
		dc.w	$600F,$600F,$600F,$600F,$E3F8,$E3F8,$E3F8,$E3F8
		dc.w	$FE3D,$FE3F,$FE3D,$FE3D,$8F8F,$8F8F,$8F8F,$8F8F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$FE3F,$FE3F,$FE3F,$FE3F
		dc.w	$8FE3,$8FE3,$8FE3,$8FE3,$F803,$F803,$F803,$F803
		dc.w	$F8F6,$F8FE,$F8F6,$F8F6,$3F80,$3F80,$3F80,$3F80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00C6,$00C6,$00D6,$00C6,$318C,$318C,$358D,$318C
		dc.w	$600F,$600F,$600F,$600F,$E3F8,$E3F8,$E3F8,$E3F8
		dc.w	$FE3F,$FE3F,$FE3F,$FE3F,$8F8F,$8F8F,$0F8F,$0F8F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$FE3F,$FE3F,$FE3F,$FE3F
		dc.w	$8FE3,$8FE3,$8FE3,$8FE3,$F803,$F803,$F803,$F803
		dc.w	$F8FE,$F8FE,$F8FE,$F8FE,$3F80,$3F80,$3F80,$3F80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00D6,$00D6,$00D6,$00D6,$358D,$358D,$358D,$358D
		dc.w	$600F,$600F,$600F,$600F,$E3F8,$E3F8,$E3F8,$E3F8
		dc.w	$FE3F,$FE3F,$FE3E,$FE3E,$0F8F,$8F8F,$0F8F,$0F8F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$FE3F,$FE3F,$FE3F,$FE3F
		dc.w	$8FE3,$8FE3,$8FE3,$8FE3,$F803,$F803,$F803,$F803
		dc.w	$F8FE,$F8FE,$F8FE,$F8FE,$3F80,$3F80,$3F80,$3F80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00FE,$00FE,$00D6,$00D6,$3F8F,$3F8F,$358D,$358D
		dc.w	$E00F,$E00F,$600F,$600F,$60E0,$E1F0,$6040,$6040
		dc.w	$F63F,$FE3F,$F63F,$F63F,$8F8F,$8F8F,$0F8F,$0F8F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$FE3F,$FE3F,$FE3F,$FE3F
		dc.w	$8EE3,$8FE3,$8EE3,$8EE3,$F803,$F803,$F803,$F803
		dc.w	$F8FE,$F8FE,$F8FE,$F8FE,$3580,$3F80,$3580,$3580
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00FE,$00FE,$00FE,$00FE,$3F8F,$3F8F,$3F8F,$3F8F
		dc.w	$E00F,$E00F,$E00F,$E00F,$60E0,$E1F0,$60E0,$60E0
		dc.w	$F63D,$FE3F,$F63D,$F63D,$8F8F,$8F8F,$8F8F,$8F8F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$FE3F,$FE3F,$FE3F,$FE3F
		dc.w	$8EE3,$8FE3,$8EE3,$8EE3,$F803,$F803,$F803,$F803
		dc.w	$F8FE,$F8FE,$F8FE,$F8FE,$3580,$3F80,$3580,$3580
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00FE,$00FE,$00FE,$00EE,$3F8F,$3F8F,$3F8F,$3B8E
		dc.w	$E00F,$E00F,$E00F,$E00F,$60E0,$E1F0,$60E0,$60E0
		dc.w	$F63D,$FE3F,$F63D,$F63D,$8F8F,$8F8F,$8F8F,$8F8F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$FE3F,$FE3F,$FE3F,$FE3F
		dc.w	$8EE3,$8FE3,$8EE3,$8EE3,$F803,$F803,$F803,$F803
		dc.w	$F8FE,$F8FE,$F8FE,$F8FE,$3580,$3F80,$3580,$3180
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00EE,$00FE,$00EE,$00C6,$3B8E,$3F8F,$3B8E,$318C
		dc.w	$E10F,$E10F,$E38F,$610F,$60E0,$E1F0,$60E0,$60E0
		dc.w	$F63D,$FE3F,$F63D,$F63D,$8F8F,$8F8F,$8787,$8787
		dc.w	$E3F8,$E3F8,$E1F8,$E1F8,$FE3F,$FE3F,$7E1F,$7E1F
		dc.w	$8EE3,$8FE3,$8EE3,$8EE3,$F843,$F843,$F0E1,$F041
		dc.w	$F8FE,$F8FE,$F87C,$F87C,$3180,$3180,$3180,$3180
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00C6,$00EE,$00C6,$0082,$318C,$3B8E,$318C,$2088
		dc.w	$638F,$E38F,$638F,$238F,$60E0,$E1F0,$60E0,$60E0
		dc.w	$F63D,$FE3F,$F63D,$F63D,$8787,$8F8F,$8383,$8383
		dc.w	$E1F8,$E3F8,$E0F8,$E0F8,$7E1F,$FE3F,$3E0F,$3E0F
		dc.w	$8EE3,$8FE3,$8EE3,$8EE3,$F0E1,$F8E3,$E0E0,$E0E0
		dc.w	$F87C,$F8FE,$F838,$F838,$3180,$3180,$3180,$3180
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
				
FONT	INCBIN FONT.NEO

MESSAGE
	DC.B      '                            '
	DC.B      ' ABCDEFGHIJKLMNOPQRSTUVWXYZ '
	DC.B      ' 0123456789 /*-+.,;:!?()$',$27,' '
	DC.B      '                            '
	
	DC.B $FF
	EVEN

SCROLLX	DC.W 0
CHARCNT	DC.W 0
NSHIFTS	DC.W 0
CHARADDR	DC.L 0

SCRTABLE	DC.L SCBUF1,SCBUF1,SCBUF2,SCBUF2
	
CHARTAB	DC.W $0010,$0080,$0000
	DC.W $0010,$0010,$0010,$0040,$0040,$0050,$0060,$0070,$0080,$2850
	DC.W $1400,$1410,$0090,$1430,$1440,$1450,$1460,$1470,$1480,$1490
	DC.W $2800,$2810,$2820,$2830,$2840,$2850,$2860,$2870,$2880,$2890
	DC.W $3C00,$3C10,$3C20,$3C30,$3C40,$3C50,$3C60,$3C70,$3C80,$3C90
	DC.W $5000,$5010,$5020,$5030,$5040,$5050,$5060,$5070,$5080,$5090
	DC.W $6400,$6410,$6420,$6430,$6440,$6450,$6460,$6470,$6480,$6490

text:
	DC.B      '                            '
	DC.B      ' ABCDEFGHIJKLMNOPQRSTUVWXYZ '
	DC.B      ' 0123456789 /*-+.,;:!?()$',$27,' '
	DC.B      '                            '
	DC.B      $00
      		
AL_COM:
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0044,$00C6,$0044,$0044,$1104,$318C,$1104,$1104
		dc.w	$4007,$600F,$4003,$4003,$C1F0,$E2E8,$81F0,$80E0
		dc.w	$7C3F,$BA3E,$7C3F,$383E,$0F8C,$870E,$0F8C,$070C
		dc.w	$01F8,$02F8,$01F8,$00F8,$7E1F,$BE2F,$7E1F,$3E0F
		dc.w	$8FC3,$8FA3,$8FC3,$8F83,$F001,$E802,$F001,$E000
		dc.w	$F87C,$F8BA,$F87C,$F838,$3180,$2A80,$3180,$2080
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0044,$00C6,$00C6,$0044,$1104,$318C,$318C,$1104
		dc.w	$400F,$600F,$6007,$4007,$E3F8,$E1F0,$C3F8,$C1F0
		dc.w	$FE3F,$7C3F,$FE3F,$7C3F,$800C,$0F8C,$800E,$000C
		dc.w	$03F8,$01F8,$03F8,$01F8,$FE3F,$7E1F,$FE3F,$7E1F
		dc.w	$8FE3,$8FC3,$8FE3,$8FC3,$F803,$F001,$F803,$F001
		dc.w	$F8FE,$F87C,$F8FE,$F87C,$3B80,$3580,$3B80,$3180
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00C6,$0044,$00C6,$0044,$318C,$1104,$318C,$1104
		dc.w	$600F,$400F,$600F,$400F,$63F8,$63F8,$E3F8,$63F8
		dc.w	$F63D,$FE3F,$F63D,$F63D,$8F8C,$8F8C,$8F8E,$8F8C
		dc.w	$03C0,$03E0,$03C0,$03C0,$C03C,$E03E,$C03C,$C03C
		dc.w	$0FE3,$0FE3,$0FE3,$0FE3,$D803,$F803,$D803,$D803
		dc.w	$E0F6,$E0FE,$E0F6,$E0F6,$3F80,$3B80,$3F80,$3B80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00C6,$00C6,$00C6,$00C6,$318C,$318C,$318C,$318C
		dc.w	$600F,$600F,$600F,$600F,$63F8,$E3F8,$63F8,$63F8
		dc.w	$F63D,$F63D,$FE3F,$F63D,$8F8C,$8F8C,$8F8E,$8F8C
		dc.w	$03C0,$03C0,$03E0,$03C0,$DE3C,$DE3C,$FE3E,$DE3C
		dc.w	$0FE3,$0FE3,$0FE3,$0FE3,$D803,$D803,$F803,$D803
		dc.w	$E0F6,$E0F6,$E0FE,$E0F6,$3F80,$3F80,$3F80,$3F80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00C6,$00C6,$00C6,$00C6,$318C,$318C,$318C,$318C
		dc.w	$600F,$600F,$600F,$600F,$63F8,$E3F8,$63F8,$63F8
		dc.w	$F63D,$F63D,$FE3F,$F63D,$8F8C,$8F8C,$8F8E,$8F8C
		dc.w	$03F8,$03F8,$03F8,$03F8,$DE3F,$DE3F,$FE3F,$DE3F
		dc.w	$8FE3,$8FE3,$8FE3,$8FE3,$D803,$D803,$F803,$D803
		dc.w	$E0F6,$E0F6,$E0FE,$E0F6,$3F80,$3F80,$3F80,$3F80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00C6,$00C6,$00C6,$00C6,$318C,$318C,$318C,$318C
		dc.w	$600F,$600F,$600F,$600F,$63F8,$63F8,$E3F8,$63F8
		dc.w	$F63D,$F63D,$FE3F,$F63D,$8F8C,$8F8C,$8F8E,$8F8C
		dc.w	$03F8,$03F8,$03F8,$03F8,$DE3F,$DE3F,$FE3F,$DE3F
		dc.w	$8FE3,$8FE3,$8FE3,$8FE3,$D803,$D803,$F803,$D803
		dc.w	$E0F6,$E0F6,$E0FE,$E0F6,$3F80,$3F80,$3F80,$3F80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00C6,$00C6,$00C6,$00C6,$318C,$318C,$318C,$318C
		dc.w	$600F,$600F,$600F,$600F,$E3F8,$E3F8,$E3F8,$E3F8
		dc.w	$FE3D,$FE3D,$FE3F,$FE3D,$8F8F,$8F8F,$8F8F,$8F8F
		dc.w	$E3C0,$E3E0,$E3C0,$E3C0,$DE3C,$DE3E,$FE3C,$DE3C
		dc.w	$0FE3,$0FE3,$0FE3,$0FE3,$D803,$D803,$F803,$D803
		dc.w	$E0F6,$E0F6,$E0FE,$E0F6,$3F80,$3F80,$3F80,$3F80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00C6,$00C6,$00C6,$00C6,$318C,$318C,$318C,$318C
		dc.w	$600F,$600F,$600F,$600F,$E3F8,$E3F8,$E3F8,$E3F8
		dc.w	$FE3D,$FE3D,$FE3F,$FE3D,$8F8F,$8F8F,$8F8F,$8F8F
		dc.w	$E3C0,$E3C0,$E3E0,$E3C0,$DE3C,$DE3C,$FE3E,$DE3C
		dc.w	$0FE3,$0FE3,$0FE3,$0FE3,$F803,$F803,$F803,$F803
		dc.w	$F8F6,$F8F6,$F8FE,$F8F6,$3F80,$3F80,$3F80,$3F80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00C6,$00D6,$00C6,$00C6,$318C,$358D,$318C,$318C
		dc.w	$600F,$600F,$600F,$600F,$E3F8,$E3F8,$E3F8,$E3F8
		dc.w	$FE3D,$FE3D,$FE3F,$FE3D,$8F8F,$8F8F,$8F8F,$8F8F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$FE3F,$FE3F,$FE3F,$FE3F
		dc.w	$8FE3,$8FE3,$8FE3,$8FE3,$F803,$F803,$F803,$F803
		dc.w	$F8F6,$F8F6,$F8FE,$F8F6,$3F80,$3F80,$3F80,$3F80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00C6,$00C6,$00D6,$00C6,$318C,$318C,$358D,$318C
		dc.w	$600F,$600F,$600F,$600F,$E3F8,$E3F8,$E3F8,$E3F8
		dc.w	$FE3F,$FE3F,$FE3F,$FE3F,$8F8F,$0F8F,$8F8F,$0F8F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$FE3F,$FE3F,$FE3F,$FE3F
		dc.w	$8FE3,$8FE3,$8FE3,$8FE3,$F803,$F803,$F803,$F803
		dc.w	$F8FE,$F8FE,$F8FE,$F8FE,$3F80,$3F80,$3F80,$3F80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00D6,$00C6,$00D6,$00C6,$358D,$318C,$358D,$318C
		dc.w	$600F,$600F,$600F,$600F,$E3F8,$E3F8,$E3F8,$E3F8
		dc.w	$FE3F,$FE3E,$FE3F,$FE3E,$0F8F,$8F8F,$0F8F,$0F8F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$FE3F,$FE3F,$FE3F,$FE3F
		dc.w	$8FE3,$8FE3,$8FE3,$8FE3,$F803,$F803,$F803,$F803
		dc.w	$F8FE,$F8FE,$F8FE,$F8FE,$3F80,$3F80,$3F80,$3F80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00FE,$00D6,$00FE,$00D6,$3F8F,$358D,$3F8F,$358D
		dc.w	$E00F,$600F,$E00F,$600F,$60E0,$E150,$60E0,$6040
		dc.w	$F63F,$FE3F,$F63F,$F63F,$8F8F,$0F8F,$8F8F,$0F8F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$FE3F,$FE3F,$FE3F,$FE3F
		dc.w	$8EE3,$8FE3,$8EE3,$8EE3,$F803,$F803,$F803,$F803
		dc.w	$F8FE,$F8FE,$F8FE,$F8FE,$3580,$3F80,$3580,$3580
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00FE,$00FE,$00FE,$00FE,$3F8F,$3F8F,$3F8F,$3F8F
		dc.w	$E00F,$E00F,$E00F,$E00F,$60E0,$60E0,$E1F0,$60E0
		dc.w	$F63D,$F63F,$FE3D,$F63D,$8F8F,$8F8F,$8F8F,$8F8F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$FE3F,$FE3F,$FE3F,$FE3F
		dc.w	$8EE3,$8EE3,$8FE3,$8EE3,$F803,$F803,$F803,$F803
		dc.w	$F8FE,$F8FE,$F8FE,$F8FE,$3580,$3580,$3F80,$3580
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00FE,$00FE,$00EE,$00EE,$3F8F,$3F8F,$3B8E,$3B8E
		dc.w	$E00F,$E00F,$E00F,$E00F,$60E0,$60E0,$E1F0,$60E0
		dc.w	$F63D,$F63D,$FE3F,$F63D,$8F8F,$8F8F,$8F8F,$8F8F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$FE3F,$FE3F,$FE3F,$FE3F
		dc.w	$8EE3,$8EE3,$8FE3,$8EE3,$F803,$F803,$F803,$F803
		dc.w	$F8FE,$F8FE,$F8FE,$F8FE,$3580,$3580,$3F80,$3580
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00EE,$00FE,$00C6,$00C6,$3B8E,$3F8F,$318C,$318C
		dc.w	$E38F,$E38F,$610F,$610F,$60E0,$60E0,$E1F0,$60E0
		dc.w	$F63D,$F63D,$FE3F,$F63D,$8F8F,$8787,$8F8F,$8787
		dc.w	$E3F8,$E1F8,$E3F8,$E1F8,$FE3F,$7E1F,$FE3F,$7E1F
		dc.w	$8EE3,$8EE3,$8FE3,$8EE3,$F8E3,$F0E1,$F843,$F041
		dc.w	$F8FE,$F87C,$F8FE,$F87C,$3180,$3180,$3180,$3180
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00C6,$00EE,$0082,$0082,$318C,$3B8E,$2088,$2088
		dc.w	$638F,$E38F,$238F,$238F,$60E0,$60E0,$E1F0,$60E0
		dc.w	$F63D,$F63D,$FE3F,$F63D,$8787,$8B8B,$8787,$8383
		dc.w	$E1F8,$E2F8,$E1F8,$E0F8,$7E1F,$BE2F,$7E1F,$3E0F
		dc.w	$8EE3,$8EE3,$8FE3,$8EE3,$F0E1,$E8E2,$F0E1,$E0E0
		dc.w	$F87C,$F8BA,$F87C,$F838,$3180,$3180,$3180,$3180
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000

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

* noting after here !        

PARAM_RA:
	dc	1,2,0,65535
	dc	3,1,8,0
	dc	0,0,4,5
	dc	8,4,0,500

PAL_RASTER:
		dc	$0100,$0100,$0104,$0108
		dc	$010C,$010C,$0110,$0114
		dc	$0118,$011C,$011C,$0120
		dc	$0124,$0128,$0128,$012C
		dc	$0130,$0134,$0138,$0138
		dc	$013C,$0140,$0144,$0144
		dc	$0148,$014C,$0150,$0150
		dc	$0154,$0158,$015C,$015C
		dc	$0160,$0164,$0164,$0168
		dc	$016C,$0170,$0170,$0174
		dc	$0178,$0178,$017C,$0180
		dc	$0180,$0184,$0188,$0188
		dc	$018C,$0190,$0190,$0194
		dc	$0198,$0198,$019C,$019C
		dc	$01A0,$01A4,$01A4,$01A8
		dc	$01A8,$01AC,$01B0,$01B0
		dc	$01B4,$01B4,$01B8,$01B8
		dc	$01BC,$01BC,$01C0,$01C0
		dc	$01C4,$01C4,$01C8,$01C8
		dc	$01CC,$01CC,$01D0,$01D0
		dc	$01D4,$01D4,$01D8,$01D8
		dc	$01D8,$01DC,$01DC,$01E0
		dc	$01E0,$01E0,$01E4,$01E4
		dc	$01E4,$01E8,$01E8,$01E8
		dc	$01EC,$01EC,$01EC,$01EC
		dc	$01F0,$01F0,$01F0,$01F4
		dc	$01F4,$01F4,$01F4,$01F4
		dc	$01F8,$01F8,$01F8,$01F8
		dc	$01F8,$01F8,$01FC,$01FC
		dc	$01FC,$01FC,$01FC,$01FC
		dc	$01FC,$01FC,$01FC,$01FC
		dc	$01FC,$01FC,$01FC,$01FC
		even
                                    
******************************************************************

	SECTION	BSS

RIEN:			DS.B 768 
DATA_R00: DS.B 2048
DATA_R01: DS.W 1 
DATA_R02: DS.W 1 
DATA_R04: DS.B 2048
DATA_R05: DS.B 2048
DATA_R06: DS.B 8192
DATA_R07: DS.B 69376 
DATA_R08:	DS.L 1
DATA_R09:	DS.W 1
MESPOS:   DS.L 1
SCBUF1:   DS.B $150*32
SCBUF2:   DS.B $150*32
          DS.L 100

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
	ds.b	160*200
Zorro_screen1_len:	equ	*-start

Zorro_scr2:	ds.l	1

Zorro_screen2:	
	ds.b	256
start2:	
	ds.b	160*200
Zorro_screen2_len:	equ	*-start2

	END
