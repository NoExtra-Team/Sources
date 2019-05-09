* AL_10.PRG

* // Code & Ripp	 : Zorro2/NoExtra	// *
* // Gfx neochrome master: Mister. A/NoExtra	// *
* // Music 		 : JB 007 		// *
* // Release date 	 : 01/01/2007		// *

***********************************************
	opt	o-,d-
***********************************************

	SECTION	TEXT

***********************************************
NB_LIGNE	equ	161
RASTER_START	equ	160*39
BACKGROUNDCOLOR	equ	$0020567
SEEMYVBL	equ	0 ;	0 = see cpu & 1 = nothing
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

	bsr	Init_screens

	bsr	Save_and_init_a_st

	bsr	Init0

******************************************************************************

	bsr	Init

Main_rout:

	bsr	Wait_vbl

	move.l	#BACKGROUNDCOLOR,$ffff8240.w

*

	BSR	FXTUBE

	BSR	SCROLLING

	jsr 	(MUSIC+8)			; call music

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

	move.b 	#8,$ffff8800.w        ; Sound OFF
	move.b 	#0,$ffff8802.w
	move.b 	#9,$ffff8800.w
	move.b 	#0,$ffff8802.w
	move.b 	#$a,$ffff8800.w
	move.b 	#0,$ffff8802.w

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

Vbl0:	

	st	Vsync

  CLR.B     $FFFFFA1B.W 
  MOVE.B    #70-2,$FFFFFA21.W
  MOVE.L    #SET_FONTPAL,$120.W 
	MOVE.B    #8,$FFFFFA1B.W
                  
	jsr 	(MUSIC+8)			; call music
	
	rte
	
Vbl:	

  move.l	a0,-(a7)
  move.l	a1,-(a7)
  LEA   Pal_Logo,A0 
  MOVEA.L   #$FF8240,A1 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 	
  move.l	(a7)+,a1
  move.l	(a7)+,a0
  
  CLR.B     $FFFFFA1B.W 
  MOVE.B    #35,$FFFFFA21.W
  MOVE.L    #HBL0,$120.W 
  MOVE.B    #8,$FFFFFA1B.W

  st	Vsync

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

ok	equ	7999-6800+320

	movea.l	Zorro_scr1,a1
	movea.l	#IMG_LOGO,a0
	move.l	#ok,d0
aff0:	move.l	(a0)+,(a1)+
	dbf	d0,aff0
	
	movea.l	Zorro_scr2,a1
	movea.l	#IMG_LOGO,a0
	move.l	#ok,d0
aff1:	move.l	(a0)+,(a1)+
	dbf	d0,aff1	
	
ok2	equ	7999-6800+80

	movea.l	Zorro_scr1,a1
	lea	200*160(a1),a1
	lea	4*160(a1),a1
	movea.l	#LOGO_DIST,a0
	move.l	#ok2,d0
aff00:	move.l	(a0)+,(a1)+
	dbf	d0,aff00
	
	movea.l	Zorro_scr2,a1
	lea	200*160(a1),a1
	lea	4*160(a1),a1
	movea.l	#LOGO_DIST,a0
	move.l	#ok2,d0
aff01:	move.l	(a0)+,(a1)+
	dbf	d0,aff01	
	
	lea	Vbl(pc),a0
	move.l	a0,$70.w

	movem.l	(a7)+,d0-d7/a0-a6
	rts

Init0:	movem.l	d0-d7/a0-a6,-(a7)

	bsr	fadein
	
	clr.w	$ffff8240.w
	
	jsr	MUSIC+0			; init music

	movea.l	Zorro_scr1,a1
	adda.l	#160*76,a1
	movea.l	#LogoNoeXtra,a0
	move.l	#7999-6800+640+40,d0
aff:	move.l	(a0)+,(a1)+
	dbf	d0,aff
                	
	lea	Vbl0(pc),a0
	move.l	a0,$70.w

	BSR       FADE_IN

	lea	PalNoeXtra,a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

	bsr	delay

	BSR     INIT_SCROL
	
	bsr     fadeoff

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

	sf	$fffffa21.w
	sf	$fffffa1b.w
	;move.l	#HBL0,$120.w
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
*             < Here is the lower border rout >               *
*                                                             *
***************************************************************

HBL0: CLR.B     $FFFFFA1B.W 
      move.l	#$0040004,$ffff8240.w
      MOVE.B    #1,$FFFFFA21.W
      MOVE.L    #HBL1,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      RTE 
      
HBL1: CLR.B     $FFFFFA1B.W 
      move.l	#$0270016,$ffff8240.w
      MOVE.B    #1,$FFFFFA21.W
      MOVE.L    #HBL2,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      RTE 

HBL2: CLR.B     $FFFFFA1B.W 
      move.l	#$0040004,$ffff8240.w
      MOVE.B    #1,$FFFFFA21.W
      MOVE.L    #HBL3,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      RTE 

HBL3:
  CLR.B     $FFFFFA1B.W 

  move.l	a0,-(a7)
  move.l	a1,-(a7)
  LEA   Pal_Tube(pc),A0 
  MOVEA.L   #$FF8240,A1 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  LEA   Pal_Scroll(pc),A0 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  move.l	(a7)+,a1
  move.l	(a7)+,a0

  MOVE.B    #162-1,$FFFFFA21.W
  MOVE.L    #HBL_FONT,$120.W 
  MOVE.B    #8,$FFFFFA1B.W
    	  		
      RTE 
            
HBL_FONT:
	clr.b	$fffffa1b.w		;DI all other interrupts

	REPT 60				;wait for 1/2 a screen width
	nop
	ENDR

.loop	tst.b	$ffff8209.w		;check low video pos
	bne.s	.loop
	nop				;do fuck all for a while
	nop
	nop
	nop
	nop
	nop
	clr.b	$ffff820a.w		;60Hz

	REPT 16
	nop
	ENDR
	MOVE.B	#2,$FFFF820A.W

  move.l	a0,-(a7)
  move.l	a1,-(a7)

  LEA   Pal_Dist(pc),A0 
  MOVEA.L   #$FF8240,A1 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  	
	lea	colours(pc),a0
	rept	36
	move.w	(a0)+,$ffff8242.w
	dcb.w	124,$4e71
	endr
	
	move.l	(a7)+,a1
	move.l	(a7)+,a0

	BCLR      #0,$FFFFFA0F.W    
	
  RTE 
      
colours
 dc.w	0,0,0,0
 dc.w	$708,$f00,$f80,$f10,$f90,$f20,$fa0,$f30,$fb0,$f40,$fc0,$f50,$fd0,$f60
 dc.w	$fe0,$f70,$ff0,$7f0,$ef0,$6f0,$df0,$5f0,$cf0,$4f0,$bf0,$3f0,$af0,$2f0
 dc.w	$9f0,$1f0,$0f0,$070,$070,$070

SET_FONTPAL:      MOVE      #$2700,SR 
                  MOVEM.L   A0-A1/D0,-(A7)
                  CLR.B     $FFFFFA1B.W 
                  LEA       $FFFFFA21.W,A0
                  MOVE.B    #60-1,(A0) 
                  MOVE.L    #SET_LINE,$120.W
                  MOVE.B    #8,$FFFFFA1B.W
                  MOVE.B    (A0),D0 
W_LN:             CMP.B     (A0),D0 
                  BEQ.S     W_LN
                  MOVEA.L   SYNCPALPNT(PC),A0 
                  LEA       $FFFF8240.W,A1
                  MOVE.W    #$14,D0 
WAIT_LOOP:        DBF       D0,WAIT_LOOP
                  MOVEQ     #0,D0 
WHAA:             MOVE.B    $FFFF8209.W,D0
                  BEQ.S     WHAA
                  JMP       JUMPTOWER(PC,D0.W)
JUMPTOWER:        NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
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
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVEM.L   (A7)+,A0-A1/D0
                  
                  move.b	#0,$FFFF8240.W

                  RTE 

SET_LINE:         MOVE      #$2700,SR 
                  MOVEM.L   A0-A1/D0,-(A7)
                  CLR.B     $FFFFFA1B.W 
                  LEA       $FFFFFA21.W,A0
                  MOVE.B    #$28,(A0) 
                  MOVE.L    #LOWERBORDER,$120.W 
                  MOVE.B    #8,$FFFFFA1B.W
                  MOVE.B    (A0),D0 
W_LN2:            CMP.B     (A0),D0 
                  BEQ.S     W_LN2 
                  MOVEA.L   SYNCPALPNT(PC),A0 
                  ADDQ.L    #2,A0 
                  CMPA.L    #PALEND,A0
                  BMI.S     GO_ON2
                  LEA       SYNCPAL(PC),A0
GO_ON2:           MOVE.L    A0,SYNCPALPNT 
                  LEA       $FFFF8240.W,A1
                  MOVE.W    #$14,D0 
WAIT_LOOP2:       DBF       D0,WAIT_LOOP2 
                  MOVEQ     #0,D0 
WHAA2:            MOVE.B    $FFFF8209.W,D0
                  BEQ.S     WHAA2 
                  JMP       JUMPTOWER2(PC,D0.W) 
JUMPTOWER2:       NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  NOP 
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
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVEM.L   (A7)+,A0-A1/D0
                  
                  move.b	#0,$FFFF8240.W
                  
                  RTE 

LOWERBORDER:      CLR.B     $FFFFFA1B.W
									BCLR      #0,$FFFFFA0F.W
                  RTE 

SYNCPALPNT:
	DC.L	PALEND
SYNCPAL:
	rept	3
	dc.w	$0710,$0720,$0730,$0740
	dc.w	$0750,$0760,$0770,$0670
	dc.w	$0570,$0470,$0370,$0270
	dc.w	$0170,$0070,$0071,$0072
	dc.w	$0073,$0074,$0075,$0076
	dc.w	$0077,$0067,$0057,$0047
	dc.w	$0037,$0027,$0017,$0007
	dc.w	$0107,$0207,$0307,$0407
	dc.w	$0507,$0607,$0707,$0706
	dc.w	$0705,$0704,$0703,$0702
	dc.w	$0701,$0700,$0710,$0720
	dc.w	$0730,$0740,$0750,$0760
	dc.w	$0770,$0670,$0570,$0470
	dc.w	$0370,$0270,$0170,$0070
	dc.w	$0071,$0072,$0073,$0074
	dc.w	$0075,$0076,$0077,$0067
	dc.w	$0057,$0047,$0037,$0027
	dc.w	$0017,$0007,$0107,$0207
	dc.w	$0307,$0407,$0507,$0607
	dc.w	$0707,$0706,$0705,$0704
	dc.w	$0703,$0702,$0701,$0700
	endr
	dc.w	$0710,$0720,$0730,$0740
	dc.w	$0750,$0760,$0770,$0670
	dc.w	$0570,$0470,$0370,$0270
	dc.w	$0170,$0070,$0071,$0072
	dc.w	$0073,$0074,$0075,$0076
	dc.w	$0077,$0067,$0057,$0047
	dc.w	$0037,$0027,$0017,$0007
	dc.w	$0107,$0207,$0307,$0407
	dc.w	$0507,$0607,$0707,$0706
	dc.w	$0705,$0704,$0703,$0702
PALEND:
	DCB.W	40,$0  
       
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

remplissage	equ	$0

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
	move.l	#remplissage,(a6)+
	dbra	d1,fill

	movea.l	Zorro_scr2,a6
	move.w	#Zorro_screen2_len/4-1,d1
fill2:
	move.l	#remplissage,(a6)+
	dbra	d1,fill2
	
	movem.l	(a7)+,d0-d7/a0-a6
	rts

******************************************************************

FXTUBE:
      ADDQ.W    #2,SENS
      LEA       COURBE,A0
      ADDA.W    SENS,A0
      CMPI.W    #$FFFF,(A0) 
      BNE.S     .next 
      CLR.W     SENS 
      LEA       COURBE,A0
.next:LEA       LIMITE,A1
      MOVE.W    (A0),D0 
      ADD.W     D0,(A1) 
      TST.W     D0
      BMI.S     .next1 
      CMPI.W    #$2800,(A1) 
      BCS.S     .next0 
      SUBI.W    #$2800,(A1) 
.next0:BRA.S     .next2 
.next1:CMPI.W    #0,(A1) 
      BPL.S     .next2 
      ADDI.W    #$2800,(A1) 
.next2:LEA       TUBE_4PLAN,A0
      ADDA.W    (A1),A0 
      MOVEA.L   Zorro_scr1,A1	***
      LEA       RASTER_START(A1),A1 

      MOVE.L    A7,BUFFER
      MOVEM.L   (A0)+,A2-A7/D0-D7 
nbline	set	0
      rept	NB_LIGNE
      MOVEM.L   A2-A7/D0-D7,nbline(A1)
nbline	set	nbline+160
      endr
      
      LEA       56(A1),A1 
      MOVEM.L   (A0)+,A2-A7/D0-D7 
nbline	set	0
      rept	NB_LIGNE
      MOVEM.L   A2-A7/D0-D7,nbline(A1)
nbline	set	nbline+160
      endr    

      LEA       56(A1),A1 
      MOVEA.L   BUFFER,A7
      MOVEM.L   (A0)+,A2-A5/D0-D7 
nbline	set	0
      rept	NB_LIGNE
      MOVEM.L   A2-A5/D0-D7,nbline(A1)
nbline	set	nbline+160
      endr
      
      RTS 

SCROLLING:
      MOVEA.L   DATA_S3(PC),A0
      TST.W     80(A0)
      BPL.S     .next 
      MOVE.L    #DATA_S0,DATA_S3
.next:ADDQ.L    #2,DATA_S3
      LEA       CLS_CAR(PC),A1
      LEA       PUT_CAR(PC),A2
      MOVEQ     #0,D0 
      MOVE.W    (A0)+,D1
      ADD.W     D0,D1 
      MOVE.W    D1,2(A1)
      MOVE.W    D1,2(A2)
plan1	set 6
plan2	set 10
	rept	19
      ADDQ.W    #1,D0 
      MOVE.W    (A0)+,D1
      ADD.W     D0,D1 
      MOVE.W    D1,plan1(A1)
      MOVE.W    D1,plan1(A2)
      ADDQ.W    #7,D0 
      MOVE.W    (A0)+,D1
      ADD.W     D0,D1 
      MOVE.W    D1,plan2(A1) 
      MOVE.W    D1,plan2(A2) 
plan1	set plan1+8
plan2	set plan2+8
	endr
      ADDQ.W    #1,D0 
      MOVE.W    (A0)+,D1
      ADD.W     D0,D1 
      MOVE.W    D1,158(A1)
      MOVE.W    D1,158(A2)
      ADDQ.W    #7,D0 
      MOVEA.L   Zorro_scr1,A0
      lea	160*3(a0),a0
      ADDQ.w    #6,A0 
      JMP       SCROLL_ET0 
SCROLL_ET1 EQU       *-4 
SCROLL_ET0:MOVE.L    #SCROLL_ET2,SCROLL_ET1
      MOVEA.L   PTR_TEXTE(PC),A1
      CLR.W     D0
      MOVE.B    (A1),D0 
      CMP.B     #$FF,D0 
      BNE.S     .next0 
      LEA       TEXTE(PC),A1
      MOVE.L    A1,PTR_TEXTE
      MOVE.B    (A1),D0 
.next0:ADDQ.L    #1,PTR_TEXTE
      LEA       DATA_S4(PC),A1
      MOVE.L    0(A1,D0.W),DATA_S5
      BRA.S     LOOPZ0 
SCROLL_ET2:MOVE.L    #SCROLL_ET3,SCROLL_ET1
      BRA       LOOPZ2 
SCROLL_ET3:MOVE.L    #SCROLL_ET4,SCROLL_ET1
      BRA       LOOPZ3 
SCROLL_ET4:MOVE.L    #SCROLL_ET5,SCROLL_ET1
      BRA       LOOPZ4 
SCROLL_ET5:MOVE.L    #SCROLL_ET6,SCROLL_ET1
      ADDQ.L    #2,DATA_S5
      BRA.S     LOOPZ0 
SCROLL_ET6:MOVE.L    #SCROLL_ET7,SCROLL_ET1
      BRA       LOOPZ2 
SCROLL_ET7:MOVE.L    #SCROLL_ET8,SCROLL_ET1
      BRA       LOOPZ3 
SCROLL_ET8:MOVE.L    #SCROLL_ET0,SCROLL_ET1
      BRA       LOOPZ4 
LOOPZ0:LEA       BUFF_S0,A1
      LEA       -2(A1),A5 
      LEA       BUFF_S6,A2
      MOVEA.L   DATA_S5(PC),A3

bloc	set	0
	rept	24
      MOVEM.L   (A1)+,A4/D0-D7
      MOVEM.L   A4/D0-D7,-38(A1)
      MOVE.W    (A1),-2(A1) 
      MOVE.W    bloc(A2),D0 
      SWAP      D0
      MOVE.W    bloc(A3),D0 
      LSL.L     #4,D0 
      SWAP      D0
      MOVE.W    D0,(A1) 
      ADDQ.L    #4,A1 
bloc	set bloc+40
	endr
	
      BRA       LOOPZ5 
LOOPZ2:LEA       BUFF_S2,A1
      LEA       -2(A1),A5 
      LEA       BUFF_S1,A2
      MOVEA.L   DATA_S5(PC),A3
bloc2	set	0
	rept	24
      MOVEM.L   (A1)+,A4/D0-D7
      MOVEM.L   A4/D0-D7,-38(A1)
      MOVE.W    (A1),-2(A1) 
      MOVE.W    bloc2(A2),D0 
      SWAP      D0
      MOVE.W    bloc2(A3),D0 
      LSL.W     #4,D0 
      LSL.L     #4,D0 
      SWAP      D0
      MOVE.W    D0,(A1) 
      ADDQ.L    #4,A1 
bloc2	set bloc2+40
	endr
      BRA       LOOPZ5 
LOOPZ3:LEA       BUFF_S4,A1
      LEA       -2(A1),A5 
      LEA       BUFF_S3,A2
      MOVEA.L   DATA_S5(PC),A3
bloc3	set	0
	rept	24
      MOVEM.L   (A1)+,A4/D0-D7
      MOVEM.L   A4/D0-D7,-38(A1)
      MOVE.W    (A1),-2(A1) 
      MOVE.W    bloc3(A2),D0 
      SWAP      D0
      MOVE.W    bloc3(A3),D0 
      LSL.W     #8,D0 
      LSL.L     #4,D0 
      SWAP      D0
      MOVE.W    D0,(A1) 
      ADDQ.L    #4,A1 
bloc3	set bloc3+40
	endr
      BRA       LOOPZ5 
LOOPZ4:LEA       BUFF_S5,A1
      LEA       -2(A1),A5 
      MOVEA.L   DATA_S5(PC),A3
bloc4	set	0
	rept	24
      MOVEM.L   (A1)+,A4/D0-D7
      MOVEM.L   A4/D0-D7,-38(A1)
      MOVE.W    (A1),-2(A1) 
      MOVE.W    bloc4(A3),(A1) 
      ADDQ.L    #4,A1 
bloc4	set bloc4+40
	endr
LOOPZ5:BSR       LOOPZ6 
      MOVEQ     #$17,D0 
PUT_CAR:
	rept	40
	MOVE.B    (A5)+,8(A0) 
	endr
      LEA       160(A0),A0
      DBF       D0,PUT_CAR
LOOPZ6:MOVEQ     #2,D0 
CLS_CAR:
	rept	40
	CLR.B     8(A0) 
	endr
      LEA       160(A0),A0
      DBF       D0,CLS_CAR
      RTS 

INIT_SCROL:
      LEA       DATA_S2(PC),A0
      LEA       DATA_S4(PC),A1
      MOVEQ     #4,D0 
.loop:MOVEQ     #9,D1 
.loopa:MOVE.L    A0,(A1)+
      ADDQ.L    #4,A0 
      DBF       D1,.loopa
      ADDA.W    #$398,A0
      DBF       D0,.loop
      LEA       TEXTE(PC),A0
      CLR.W     D0
.loopb:MOVE.B    (A0),D0 
      BMI.S     SUITE 
      BSR.S     COMP_SCROL 
      ADD.B     D0,D0 
      ADD.B     D0,D0 
      MOVE.B    D0,(A0)+
      BRA.S     .loopb
SUITE:RTS 

COMP_SCROL:CMP.W     #$2E,D0 
      BNE.S     .next0 
      MOVE.W    #$24,D0 
      BRA.S     NEXT_CAR 
.next0:CMP.W     #$2C,D0 
      BNE.S     .next1 
      MOVE.W    #$25,D0 
      BRA.S     NEXT_CAR 
.next1:CMP.W     #$27,D0 
      BNE.S     .next2 
      MOVE.W    #$26,D0 
      BRA.S     NEXT_CAR 
.next2:CMP.W     #$3A,D0 
      BNE.S     .next3 
      MOVE.W    #$27,D0 
      BRA.S     NEXT_CAR 
.next3:CMP.W     #$2D,D0 
      BNE.S     .next4 
      MOVE.W    #$28,D0 
      BRA.S     NEXT_CAR 
.next4:CMP.W     #$3F,D0 
      BNE.S     .next5 
      MOVE.W    #$29,D0 
      BRA.S     NEXT_CAR 
.next5:CMP.W     #$21,D0 
      BNE.S     .next6 
      MOVE.W    #$2A,D0 
      BRA.S     NEXT_CAR 
.next6:CMP.W     #$28,D0 
      BNE.S     .next7 
      MOVE.W    #$2B,D0 
      BRA.S     NEXT_CAR 
.next7:CMP.W     #$29,D0 
      BNE.S     .next8 
      MOVE.W    #$2C,D0 
      BRA.S     NEXT_CAR 
.next8:CMP.W     #$20,D0 
      BNE.S     .next9 
      MOVE.W    #$2D,D0 
      BRA.S     NEXT_CAR 
.next9:CMP.W     #$39,D0 
      BGT.S     .next10 
      SUBI.W    #$16,D0 
      BRA.S     NEXT_CAR 
.next10:SUBI.W    #$41,D0 
NEXT_CAR:RTS 

*

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

FADE_IN:           
	LEA       PalNoeXtra,A0
  LEA       48(A0),A0 
  LEA       $FFFF8240.W,A1
  CLR.W     (A1)
  MOVE.W    #$30,D0
  MOVE.W    #7,D7 
FDIN:             
a	set	0
b	set	2
	rept	14-2
  MOVE.W    a(A0),b(A1)
a	set	a+2                  
b	set	b+2
	endr                  
	SUBQ.W    #6,D0 
  LEA       PalNoeXtra,A0
  ADDA.W    D0,A0 
	rept	4*2
  BSR       Wait_vbl 
  endr
  DBF       D7,FDIN 
  RTS 

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

delay:
  MOVE.b     #$AF,D0 
.synch:
	BSR       WAIT_VBL
	sub.b	#1,d0
	cmp.b	#$0,d0	
	bne.s	.synch
	rts	

			                  
	SECTION	DATA

Pal_Logo:
	dc.w	$0002,$0567,$0557,$0457,$0457,$0347,$0247,$0237
	dc.w	$0137,$0027,$0027,$0016,$0015,$0004,$0003,$0003

Pal_Scroll:
	dc.w	$000,$111,$222,$333,$444,$555,$666,$777

Pal_Tube:
	dc.w	$000,$767,$656,$545,$434,$323,$212,$101

Pal_Dist:
	dc.w  $0000,$0676,$0565,$0454,$0121,$0232,$0010,$0342

TUBE_4PLAN:
	dc	$E667,$7878,$FF80,$0000
	dc	$CCCE,$3C3E,$03FF,$0000
	dc	$CCE7,$F0F8,$FF00,$0000
	dc	$CCE7,$3C1F,$03FF,$0000
	dc	$3E66,$C1E1,$001F,$0000
	dc	$7999,$F787,$F07F,$0000
	dc	$CCE7,$F0F8,$FF00,$0000
	dc	$CCE7,$3C1F,$03FF,$0000
	dc	$33E7,$0F9F,$FFFF,$0000
	dc	$9B7F,$7FFF,$FFFF,$0000
	dc	$CCE7,$F0F8,$FF00,$0000
	dc	$CCE7,$3C1F,$03FF,$0000
	dc	$D533,$FFDD,$FFFF,$0000
	dc	$3333,$C3C3,$FFFC,$0000
	dc	$CCE7,$F0F8,$FF00,$0000
	dc	$CCE7,$3C1F,$03FF,$0000
	dc	$CCF9,$0F1E,$F01F,$0000
	dc	$99F3,$1E0F,$E000,$0000
	dc	$CCE7,$F0F8,$FF00,$0000
	dc	$CCE7,$3C1F,$03FF,$0000
	dc	$F333,$BC3C,$FFC0,$0000
	dc	$E667,$1E1F,$01FF,$0000
	dc	$E673,$F87C,$7F80,$0000
	dc	$E673,$1E0F,$01FF,$0000
	dc	$9F33,$E0F0,$800F,$0000
	dc	$3CCC,$FBC3,$F83F,$0000
	dc	$E673,$F87C,$FF80,$0000
	dc	$E673,$1E0F,$01FF,$0000
	dc	$99F3,$87CF,$FFFF,$0000
	dc	$99FF,$FFFF,$FFFF,$0000
	dc	$E673,$F87C,$FF80,$0000
	dc	$E673,$1E0F,$01FF,$0000
	dc	$B493,$FFFC,$FFFF,$0000
	dc	$9999,$E1E1,$FFFE,$0000
	dc	$E673,$F87C,$7F80,$0000
	dc	$E673,$1E0F,$01FF,$0000
	dc	$CCFC,$8F0F,$F00F,$0000
	dc	$CCF9,$0F07,$F000,$0000
	dc	$E673,$F87C,$7F80,$0000
	dc	$E673,$1E0F,$01FF,$0000
	dc	$F333,$FC3C,$FFC0,$0000
	dc	$E667,$1E1F,$01FF,$0000
	dc	$7339,$7C3E,$BFC0,$0000
	dc	$F339,$0F07,$00FF,$0000
	dc	$CF99,$F078,$C007,$0000
	dc	$9E66,$7DE1,$FC1F,$0000
	dc	$7339,$FC3E,$FFC0,$0000
	dc	$F339,$0F07,$00FF,$0000
	dc	$CCF3,$C3EF,$FFFF,$0000
	dc	$CDBB,$BFFF,$FFFF,$0000
	dc	$B339,$BC3E,$BFC0,$0000
	dc	$F339,$0F07,$00FF,$0000
	dc	$F299,$FFEE,$FFFF,$0000
	dc	$CD99,$71E1,$FFFE,$0000
	dc	$B339,$FC3E,$3FC0,$0000
	dc	$F339,$0F07,$00FF,$0000
	dc	$E67E,$C787,$F807,$0000
	dc	$667C,$8783,$F800,$0000
	dc	$F339,$FC3E,$3FC0,$0000
	dc	$F339,$0F07,$00FF,$0000
	dc	$F999,$FE1E,$FFE0,$0000
	dc	$F333,$0F0F,$00FF,$0000
	dc	$B99C,$BE1F,$DFE0,$0000
	dc	$F99C,$0783,$007F,$0000
	dc	$EF99,$F078,$E007,$0000
	dc	$9E66,$7DE1,$FC1F,$0000
	dc	$799C,$FE1F,$FFE0,$0000
	dc	$F99C,$0783,$007F,$0000
	dc	$E679,$E1F7,$FFFF,$0000
	dc	$CCFF,$FFFF,$FFFF,$0000
	dc	$999C,$DE1F,$DFE0,$0000
	dc	$F99C,$0783,$007F,$0000
	dc	$EA49,$FFFE,$FFFF,$0000
	dc	$CCCC,$70F0,$FFFF,$0000
	dc	$D99C,$FE1F,$1FE0,$0000
	dc	$F99C,$0783,$007F,$0000
	dc	$F33E,$E3C7,$FC07,$0000
	dc	$667C,$8783,$F800,$0000
	dc	$D99C,$DE1F,$3FE0,$0000
	dc	$F99C,$0783,$007F,$0000
	dc	$7CCC,$FF0F,$FFF0,$0000
	dc	$F999,$0787,$007F,$0000
	dc	$FCCE,$FF0F,$CFF0,$0000
	dc	$7CCE,$83C1,$003F,$0000
	dc	$77CC,$F83C,$F003,$0000
	dc	$CF33,$3EF0,$FE0F,$0000
	dc	$3CCE,$FF0F,$FFF0,$0000
	dc	$7CCE,$83C1,$003F,$0000
	dc	$733C,$F0FB,$FFFF,$0000
	dc	$E6DD,$FFFF,$FFFF,$0000
	dc	$CCCE,$CF0F,$CFF0,$0000
	dc	$7CCE,$83C1,$003F,$0000
	dc	$794C,$FFF7,$FFFF,$0000
	dc	$E666,$3878,$FFFF,$0000
	dc	$6CCE,$7F0F,$8FF0,$0000
	dc	$7CCE,$83C1,$003F,$0000
	dc	$799F,$F1E3,$FE03,$0000
	dc	$333E,$C3C1,$FC00,$0000
	dc	$6CCE,$EF0F,$1FF0,$0000
	dc	$7CCE,$83C1,$003F,$0000
	dc	$3E66,$FF87,$FFF8,$0000
	dc	$7CCC,$83C3,$003F,$0000
	dc	$FE67,$FF87,$E7F8,$0000
	dc	$3E67,$C1E0,$001F,$0000
	dc	$3BE6,$FC1E,$F801,$0000
	dc	$6799,$1F78,$FF07,$0000
	dc	$9E67,$7F87,$FFF8,$0000
	dc	$3E67,$C1E0,$001F,$0000
	dc	$3B3C,$F8FB,$FFFF,$0000
	dc	$F37F,$EFFF,$FFFF,$0000
	dc	$C667,$C787,$C7F8,$0000
	dc	$3E67,$C1E0,$001F,$0000
	dc	$3D26,$FFFB,$FFFF,$0000
	dc	$7333,$9C3C,$FFFF,$0000
	dc	$3667,$3F87,$C7F8,$0000
	dc	$3E67,$C1E0,$001F,$0000
	dc	$399F,$F9E1,$FE01,$0000
	dc	$999F,$E1E0,$FE00,$0000
	dc	$3667,$F787,$0FF8,$0000
	dc	$3E67,$C1E0,$001F,$0000
	dc	$9F33,$7FC3,$FFFC,$0000
	dc	$3E66,$C1E1,$001F,$0000
	dc	$7F33,$FFC3,$F3FC,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$9DF3,$7E0F,$FC00,$0000
	dc	$33CC,$0FBC,$FF83,$0000
	dc	$CF33,$3FC3,$FFFC,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$9D9E,$7C7D,$FFFF,$0000
	dc	$736F,$FFFF,$FFFF,$0000
	dc	$C733,$E7C3,$E7FC,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$9CA6,$7FFB,$FFFF,$0000
	dc	$7339,$9C3E,$FFDF,$0000
	dc	$9B33,$1FC3,$E3FC,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$9CCF,$7CF0,$FF00,$0000
	dc	$CCCF,$F0F0,$FF00,$0000
	dc	$9B33,$7BC3,$07FC,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$CF99,$3FE1,$FFFE,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$3F99,$FFE1,$F9FE,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$CEF9,$3F07,$FE00,$0000
	dc	$99CC,$87FC,$7FC3,$0000
	dc	$CF99,$3FE1,$FFFE,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$CECF,$3E3E,$FFFF,$0000
	dc	$39BF,$FFFF,$FFFF,$0000
	dc	$E399,$E3E1,$E3FE,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$CE93,$3FFD,$FFFF,$0000
	dc	$399C,$CE1F,$FFEF,$0000
	dc	$CD99,$0FE1,$F1FE,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$CE67,$3E78,$FF80,$0000
	dc	$E667,$7878,$7F80,$0000
	dc	$CD99,$3DE1,$03FE,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$E799,$1FE1,$FFFE,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$3ECC,$FFF0,$F8FF,$0000
	dc	$E7CC,$F83C,$0003,$0000
	dc	$E77C,$1F83,$FF00,$0000
	dc	$CCE6,$C3FE,$3FE1,$0000
	dc	$67CC,$1FF0,$FFFF,$0000
	dc	$E7CC,$F83C,$0003,$0000
	dc	$E767,$1F1F,$FFFF,$0000
	dc	$9CF7,$7FFF,$FFFF,$0000
	dc	$E1CC,$E1F0,$E1FF,$0000
	dc	$E7CC,$F83C,$0003,$0000
	dc	$E753,$1FFC,$FFFF,$0000
	dc	$9CCC,$E70F,$FFFF,$0000
	dc	$CCCC,$0FF0,$F0FF,$0000
	dc	$E7CC,$F83C,$0003,$0000
	dc	$E767,$1F78,$FF80,$0000
	dc	$B333,$7C3C,$3FC0,$0000
	dc	$E6CC,$1EF0,$01FF,$0000
	dc	$E7CC,$F83C,$0003,$0000
	dc	$73CC,$0FF0,$FFFF,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$9F66,$7FF8,$FC7F,$0000
	dc	$73E6,$7C1E,$8001,$0000
	dc	$73FC,$0F83,$FF80,$0000
	dc	$CCF3,$C3EF,$3FE0,$0000
	dc	$33E6,$0FF8,$FFFF,$0000
	dc	$73E6,$7C1E,$8001,$0000
	dc	$73B3,$0F8F,$FFFF,$0000
	dc	$9CDF,$FFFF,$FFFF,$0000
	dc	$E0E6,$E0F8,$E0FF,$0000
	dc	$73E6,$7C1E,$8001,$0000
	dc	$73C9,$0FFE,$FFFF,$0000
	dc	$9A66,$E387,$FFFF,$0000
	dc	$6666,$87F8,$F87F,$0000
	dc	$73E6,$7C1E,$8001,$0000
	dc	$73B3,$0FBC,$FFC0,$0000
	dc	$F333,$3C3C,$3FC0,$0000
	dc	$E666,$1E78,$01FF,$0000
	dc	$73E6,$7C1E,$8001,$0000
	dc	$39E6,$07F8,$FFFF,$0000
	dc	$67CC,$783C,$8003,$0000
	dc	$CFB3,$3FFC,$FE3F,$0000
	dc	$39F3,$3E0F,$C000,$0000
	dc	$39FE,$07C1,$FFC0,$0000
	dc	$6673,$E1FF,$1FF0,$0000
	dc	$33F3,$0FFC,$FFBF,$0000
	dc	$39F3,$3E0F,$C000,$0000
	dc	$39D9,$07C7,$FFFF,$0000
	dc	$CE6F,$FFFF,$FFFF,$0000
	dc	$F073,$F07C,$F07F,$0000
	dc	$39F3,$3E0F,$C000,$0000
	dc	$39E4,$07FF,$FFFF,$0000
	dc	$CE67,$7387,$FFFB,$0000
	dc	$3333,$C3FC,$FC3F,$0000
	dc	$39F3,$3E0F,$C000,$0000
	dc	$39D9,$07DE,$FFE0,$0000
	dc	$F999,$1E1E,$1FE0,$0000
	dc	$F333,$0F3C,$00FF,$0000
	dc	$39F3,$3E0F,$C000,$0000
	dc	$9CF3,$83FC,$7FFF,$0000
	dc	$33E6,$3C1E,$C001,$0000
	dc	$6799,$1FFE,$FF1F,$0000
	dc	$9CF9,$1F07,$E000,$0000
	dc	$9CFF,$83E0,$7FE0,$0000
	dc	$3339,$F0FF,$0FF8,$0000
	dc	$99F9,$87FE,$7FDF,$0000
	dc	$9CF9,$1F07,$E000,$0000
	dc	$9CF9,$83E7,$7FFF,$0000
	dc	$E76F,$DFFF,$FFFF,$0000
	dc	$F079,$F07E,$F07F,$0000
	dc	$9CF9,$1F07,$E000,$0000
	dc	$9CE4,$83FF,$7FFF,$0000
	dc	$CD33,$71C3,$FFFD,$0000
	dc	$9999,$E1FE,$FE1F,$0000
	dc	$9CF9,$1F07,$E000,$0000
	dc	$9CEC,$83EF,$7FF0,$0000
	dc	$FCCC,$0F0F,$0FF0,$0000
	dc	$F999,$079E,$007F,$0000
	dc	$9CF9,$1F07,$E000,$0000
	dc	$CE79,$C1FE,$3FFF,$0000
	dc	$99F3,$1E0F,$E000,$0000
	dc	$33CC,$0FFF,$FF8F,$0000
	dc	$CE7C,$0F83,$F000,$0000
	dc	$CE7F,$C1F0,$3FF0,$0000
	dc	$999C,$787F,$07FC,$0000
	dc	$CCFC,$C3FF,$3FEF,$0000
	dc	$CE7C,$0F83,$F000,$0000
	dc	$CE7C,$C1F3,$3FFF,$0000
	dc	$E737,$FFFF,$FFFF,$0000
	dc	$F03C,$F03F,$F03F,$0000
	dc	$CE7C,$0F83,$F000,$0000
	dc	$CE72,$C1FF,$3FFF,$0000
	dc	$6699,$B8E1,$FFFE,$0000
	dc	$CCCC,$F0FF,$FF0F,$0000
	dc	$CE7C,$0F83,$F000,$0000
	dc	$CE7C,$C1FF,$3FF0,$0000
	dc	$F666,$0F87,$07F8,$0000
	dc	$7CCC,$83CF,$003F,$0000
	dc	$CE7C,$0F83,$F000,$0000
	dc	$673C,$E0FF,$1FFF,$0000
	dc	$CCF9,$0F07,$F000,$0000
	dc	$99E6,$87FF,$7FC7,$0000
	dc	$673E,$87C1,$F800,$0000
	dc	$673F,$E0F8,$1FF8,$0000
	dc	$CCCE,$3C3F,$03FE,$0000
	dc	$667E,$E1FF,$1FF7,$0000
	dc	$673E,$87C1,$F800,$0000
	dc	$673E,$E0F9,$1FFF,$0000
	dc	$739F,$FFFF,$FFFF,$0000
	dc	$F81E,$F81F,$F81F,$0000
	dc	$673E,$87C1,$F800,$0000
	dc	$673A,$E0FF,$1FFF,$0000
	dc	$7399,$9CE1,$FFFE,$0000
	dc	$E666,$F87F,$7F87,$0000
	dc	$673E,$87C1,$F800,$0000
	dc	$673E,$E0FF,$1FF8,$0000
	dc	$7B33,$87C3,$03FC,$0000
	dc	$3E66,$C1E7,$001F,$0000
	dc	$673E,$87C1,$F800,$0000
	dc	$339C,$F07F,$0FFF,$0000
	dc	$CCF9,$0F07,$F000,$0000
	dc	$99F3,$87FF,$7FC3,$0000
	dc	$339F,$C3E0,$FC00,$0000
	dc	$339F,$F07C,$0FFC,$0000
	dc	$E667,$1E1F,$01FF,$0000
	dc	$667B,$E1FB,$1FF7,$0000
	dc	$339F,$C3E0,$FC00,$0000
	dc	$339F,$F07C,$0FFF,$0000
	dc	$39DB,$FFFF,$FFFF,$0000
	dc	$F81F,$F81F,$F81F,$0000
	dc	$339F,$C3E0,$FC00,$0000
	dc	$339D,$F07F,$0FFF,$0000
	dc	$334C,$DC70,$FFFF,$0000
	dc	$E667,$F87B,$7F83,$0000
	dc	$339F,$C3E0,$FC00,$0000
	dc	$339F,$F07F,$0FFC,$0000
	dc	$3D99,$C3E1,$01FE,$0000
	dc	$9F33,$E0F3,$000F,$0000
	dc	$339F,$C3E0,$FC00,$0000
	dc	$99CE,$783F,$07FF,$0000
	dc	$667C,$8783,$F800,$0000
	dc	$CCF3,$C3FD,$3FE1,$0000
	dc	$99CF,$E1F0,$FE00,$0000
	dc	$99CF,$783E,$07FE,$0000
	dc	$E667,$1E1F,$01FF,$0000
	dc	$333D,$F0FD,$0FFB,$0000
	dc	$99CF,$E1F0,$FE00,$0000
	dc	$99CF,$783E,$07FF,$0000
	dc	$9CEF,$7FFF,$FFFF,$0000
	dc	$F80F,$F80F,$F80F,$0000
	dc	$99CF,$E1F0,$FE00,$0000
	dc	$99CF,$783F,$07FF,$0000
	dc	$39A6,$CE38,$FFFF,$0000
	dc	$7333,$7C3D,$BFC1,$0000
	dc	$99CF,$E1F0,$FE00,$0000
	dc	$99CF,$783F,$07FE,$0000
	dc	$3D99,$C3E1,$01FE,$0000
	dc	$9F33,$E0F1,$000F,$0000
	dc	$99CF,$E1F0,$FE00,$0000
	dc	$CCE7,$3C1F,$03FF,$0000
	dc	$333E,$C3C1,$FC00,$0000
	dc	$6679,$E1FE,$1FF0,$0000
	dc	$CCE7,$F0F8,$FF00,$0000
	dc	$CCE7,$3C1F,$03FF,$0000
	dc	$F333,$0F0F,$00FF,$0000
	dc	$999E,$F87E,$87FD,$0000
	dc	$CCE7,$F0F8,$FF00,$0000
	dc	$CCE7,$3C1F,$03FF,$0000
	dc	$CEE7,$3FFF,$FFFF,$0000
	dc	$FC0F,$FC0F,$FC0F,$0000
	dc	$CCE7,$F0F8,$FF00,$0000
	dc	$CCE7,$3C1F,$03FF,$0000
	dc	$9CD3,$E71C,$FFFF,$0000
	dc	$3999,$3E1E,$DFE0,$0000
	dc	$CCE7,$F0F8,$FF00,$0000
	dc	$CCE7,$3C1F,$03FF,$0000
	dc	$9ECC,$E1F0,$00FF,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$CCE7,$F0F8,$FF00,$0000
	dc	$E673,$1E0F,$01FF,$0000
	dc	$999F,$E1E0,$FE00,$0000
	dc	$333C,$F0FF,$0FF8,$0000
	dc	$E673,$787C,$7F80,$0000
	dc	$E673,$1E0F,$01FF,$0000
	dc	$F999,$8787,$807F,$0000
	dc	$D99E,$F87E,$C7FD,$0000
	dc	$6673,$787C,$FF80,$0000
	dc	$E673,$1E0F,$01FF,$0000
	dc	$CE77,$BFFF,$FFFF,$0000
	dc	$FC07,$FC07,$FC07,$0000
	dc	$E673,$F87C,$FF80,$0000
	dc	$E673,$1E0F,$01FF,$0000
	dc	$9CD3,$E71C,$FFFF,$0000
	dc	$3CCC,$3F0F,$CFF0,$0000
	dc	$E673,$787C,$7F80,$0000
	dc	$E673,$1E0F,$01FF,$0000
	dc	$CF66,$F0F8,$807F,$0000
	dc	$67CC,$783C,$8003,$0000
	dc	$E673,$787C,$FF80,$0000
	dc	$F339,$0F07,$00FF,$0000
	dc	$CCCF,$F0F0,$FF00,$0000
	dc	$999C,$787F,$07FC,$0000
	dc	$F339,$3C3E,$3FC0,$0000
	dc	$F339,$0F07,$00FF,$0000
	dc	$FCCC,$C3C3,$C03F,$0000
	dc	$ECCF,$FC3F,$E3FE,$0000
	dc	$3339,$3C3E,$FFC0,$0000
	dc	$F339,$0F07,$00FF,$0000
	dc	$E73B,$DFFF,$FFFF,$0000
	dc	$FC07,$FC07,$FC07,$0000
	dc	$B339,$FC3E,$FFC0,$0000
	dc	$F339,$0F07,$00FF,$0000
	dc	$CE69,$F38E,$FFFF,$0000
	dc	$9E66,$1F87,$E7F8,$0000
	dc	$7339,$BC3E,$3FC0,$0000
	dc	$F339,$0F07,$00FF,$0000
	dc	$E7B3,$F87C,$C03F,$0000
	dc	$33E6,$3C1E,$C001,$0000
	dc	$7339,$3C3E,$FFC0,$0000
	dc	$F99C,$0783,$007F,$0000
	dc	$E667,$F878,$FF80,$0000
	dc	$CCCE,$3C3F,$03FE,$0000
	dc	$799C,$9E1F,$1FE0,$0000
	dc	$F99C,$0783,$007F,$0000
	dc	$FE66,$E1E1,$E01F,$0000
	dc	$7667,$FE1F,$F1FF,$0000
	dc	$399C,$1E1F,$FFE0,$0000
	dc	$F99C,$0783,$007F,$0000
	dc	$F3BB,$EFFF,$FFFF,$0000
	dc	$7E03,$FE03,$FE03,$0000
	dc	$D99C,$FE1F,$FFE0,$0000
	dc	$F99C,$0783,$007F,$0000
	dc	$E664,$FB87,$FFFF,$0000
	dc	$CF33,$0FC3,$F3FC,$0000
	dc	$399C,$DE1F,$1FE0,$0000
	dc	$F99C,$0783,$007F,$0000
	dc	$E799,$F87E,$E01F,$0000
	dc	$99F3,$1E0F,$E000,$0000
	dc	$399C,$1E1F,$FFE0,$0000
	dc	$7CCE,$83C1,$003F,$0000
	dc	$7667,$F878,$FF80,$0000
	dc	$CCCF,$3C3F,$03FE,$0000
	dc	$3CCE,$CF0F,$0FF0,$0000
	dc	$7CCE,$83C1,$003F,$0000
	dc	$7F33,$F0F0,$F00F,$0000
	dc	$3B33,$FF0F,$F8FF,$0000
	dc	$9CCE,$8F0F,$FFF0,$0000
	dc	$7CCE,$83C1,$003F,$0000
	dc	$79DD,$F7FF,$FFFF,$0000
	dc	$FE01,$FE01,$FE01,$0000
	dc	$ECCE,$FF0F,$FFF0,$0000
	dc	$7CCE,$83C1,$003F,$0000
	dc	$7734,$F9C7,$FFFF,$0000
	dc	$CF33,$0FC3,$F3FC,$0000
	dc	$3CCE,$CF0F,$0FF0,$0000
	dc	$7CCE,$83C1,$003F,$0000
	dc	$73CC,$FC3F,$F00F,$0000
	dc	$CCF9,$0F07,$F000,$0000
	dc	$9CCE,$8F0F,$7FF0,$0000
	dc	$3E67,$C1E0,$001F,$0000
	dc	$3B33,$FC3C,$FFC0,$0000
	dc	$E667,$1E1F,$01FF,$0000
	dc	$9E67,$E787,$07F8,$0000
	dc	$3E67,$C1E0,$001F,$0000
	dc	$3F33,$F8F0,$F80F,$0000
	dc	$3B33,$FF0F,$F8FF,$0000
	dc	$CE67,$C787,$BFF8,$0000
	dc	$3E67,$C1E0,$001F,$0000
	dc	$3CEE,$FBFF,$FFFF,$0000
	dc	$FE01,$FE01,$FE01,$0000
	dc	$B667,$FF87,$FFF8,$0000
	dc	$3E67,$C1E0,$001F,$0000
	dc	$3B9A,$FCE3,$FFFF,$0000
	dc	$6799,$87E1,$F9FE,$0000
	dc	$9E67,$E787,$07F8,$0000
	dc	$3E67,$C1E0,$001F,$0000
	dc	$39EC,$FE1F,$F80F,$0000
	dc	$CCF9,$0F07,$F000,$0000
	dc	$9E67,$8787,$7FF8,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$9D99,$7E1E,$FFE0,$0000
	dc	$F333,$0F0F,$00FF,$0000
	dc	$9F33,$E3C3,$83FC,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$9F99,$7C78,$FC07,$0000
	dc	$9D99,$7F87,$FC7F,$0000
	dc	$CF33,$C3C3,$FFFC,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$9E77,$7DFF,$FFFF,$0000
	dc	$FF01,$FF01,$FF01,$0000
	dc	$DB33,$FFC3,$FFFC,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$9F99,$7CE1,$FFFF,$0000
	dc	$33CC,$C3F0,$FCFF,$0000
	dc	$CF33,$F3C3,$03FC,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$9DE6,$7E1F,$FC07,$0000
	dc	$667C,$8783,$F800,$0000
	dc	$CF33,$C3C3,$3FFC,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$CECC,$3F0F,$FFF0,$0000
	dc	$F999,$0787,$007F,$0000
	dc	$CF99,$F1E1,$C1FE,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$CFCC,$3E3C,$FE03,$0000
	dc	$CECC,$3FC3,$FE3F,$0000
	dc	$E799,$E1E1,$FFFE,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$CE77,$3FFF,$FFFF,$0000
	dc	$7F00,$FF00,$FF00,$0000
	dc	$ED99,$FFE1,$FFFE,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$CFCC,$3E70,$FFFF,$0000
	dc	$99E6,$E1F8,$FE7F,$0000
	dc	$6799,$79E1,$81FE,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$CEF3,$3F0F,$FE03,$0000
	dc	$333E,$C3C1,$FC00,$0000
	dc	$6799,$E1E1,$1FFE,$0000
	dc	$E7CC,$F83C,$0003,$0000
	dc	$E766,$1F87,$FFF8,$0000
	dc	$7CCC,$83C3,$003F,$0000
	dc	$E7CC,$F8F0,$E0FF,$0000
	dc	$E7CC,$F83C,$0003,$0000
	dc	$E7E6,$1F1E,$FF01,$0000
	dc	$67CC,$1FC3,$FF3F,$0000
	dc	$F3CC,$F0F0,$EFFF,$0000
	dc	$E7CC,$F83C,$0003,$0000
	dc	$E73B,$1FFF,$FFFF,$0000
	dc	$BF00,$FF00,$FF00,$0000
	dc	$FCCC,$FFF0,$FFFF,$0000
	dc	$E7CC,$F83C,$0003,$0000
	dc	$E7A6,$1F38,$FFFF,$0000
	dc	$99B3,$E1FC,$FE3F,$0000
	dc	$33CC,$3CF0,$C0FF,$0000
	dc	$E7CC,$F83C,$0003,$0000
	dc	$E779,$1F87,$FF01,$0000
	dc	$999F,$E1E0,$FE00,$0000
	dc	$33CC,$F0F0,$0FFF,$0000
	dc	$73E6,$7C1E,$8001,$0000
	dc	$73B3,$0FC3,$FFFC,$0000
	dc	$3E66,$C1E1,$001F,$0000
	dc	$77E6,$F878,$F07F,$0000
	dc	$73E6,$7C1E,$8001,$0000
	dc	$73F3,$0F8F,$FF80,$0000
	dc	$33E6,$0FE1,$FF9F,$0000
	dc	$7366,$F0F8,$FFFF,$0000
	dc	$73E6,$7C1E,$8001,$0000
	dc	$739D,$0FFF,$FFFF,$0000
	dc	$FF80,$FF80,$FF80,$0000
	dc	$7666,$7FF8,$7FFF,$0000
	dc	$73E6,$7C1E,$8001,$0000
	dc	$73E6,$0FB8,$FFFF,$0000
	dc	$4CD9,$70FE,$FF1F,$0000
	dc	$99E6,$1E78,$E07F,$0000
	dc	$73E6,$7C1E,$8001,$0000
	dc	$73BC,$0FC3,$FF80,$0000
	dc	$CCCF,$F0F0,$FF00,$0000
	dc	$99E6,$7878,$07FF,$0000
	dc	$39F3,$3E0F,$C000,$0000
	dc	$39F3,$07C3,$FFFC,$0000
	dc	$3E66,$C1E1,$001F,$0000
	dc	$73F3,$FC3C,$F03F,$0000
	dc	$39F3,$3E0F,$C000,$0000
	dc	$39F9,$07C7,$FFC0,$0000
	dc	$99F3,$87F0,$7FCF,$0000
	dc	$39B3,$F87C,$FFFF,$0000
	dc	$39F3,$3E0F,$C000,$0000
	dc	$39CF,$07FF,$FFFF,$0000
	dc	$DF80,$FF80,$FF80,$0000
	dc	$7B33,$7FFC,$7FFF,$0000
	dc	$39F3,$3E0F,$C000,$0000
	dc	$39D3,$07DC,$FFFF,$0000
	dc	$2679,$387E,$FF9F,$0000
	dc	$99F3,$1E3C,$E03F,$0000
	dc	$39F3,$3E0F,$C000,$0000
	dc	$39FC,$07C3,$FFC0,$0000
	dc	$E667,$F878,$7F80,$0000
	dc	$CCF3,$3C3C,$03FF,$0000
	dc	$9CF9,$1F07,$E000,$0000
	dc	$9CF9,$83E1,$7FFE,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$39F9,$FE1E,$F81F,$0000
	dc	$9CF9,$1F07,$E000,$0000
	dc	$9CF9,$83E7,$7FE0,$0000
	dc	$99F3,$87F0,$7FCF,$0000
	dc	$3999,$F87E,$FFFF,$0000
	dc	$9CF9,$1F07,$E000,$0000
	dc	$9CE7,$83FF,$7FFF,$0000
	dc	$FF80,$FF80,$FF80,$0000
	dc	$3599,$3FFE,$3FFF,$0000
	dc	$9CF9,$1F07,$E000,$0000
	dc	$9CF3,$83FC,$7FFF,$0000
	dc	$266C,$387F,$FF8F,$0000
	dc	$CCF9,$0F1E,$F01F,$0000
	dc	$9CF9,$1F07,$E000,$0000
	dc	$9CFE,$83E1,$7FE0,$0000
	dc	$6667,$F878,$7F80,$0000
	dc	$CCD9,$3C3E,$03FF,$0000
	dc	$CE7C,$0F83,$F000,$0000
	dc	$CE7C,$C1F0,$3FFF,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$9CFC,$7F0F,$FC0F,$0000
	dc	$CE7C,$0F83,$F000,$0000
	dc	$CE7C,$C1F3,$3FF0,$0000
	dc	$CCF9,$C3F8,$3FE7,$0000
	dc	$9CCC,$7C3F,$FFFF,$0000
	dc	$CE7C,$0F83,$F000,$0000
	dc	$CE73,$C1FF,$3FFF,$0000
	dc	$FFC0,$FFC0,$FFC0,$0000
	dc	$3CCC,$3FFF,$3FFF,$0000
	dc	$CE7C,$0F83,$F000,$0000
	dc	$CE79,$C1FE,$3FFF,$0000
	dc	$9336,$1C3F,$FFC7,$0000
	dc	$667C,$878F,$F80F,$0000
	dc	$CE7C,$0F83,$F000,$0000
	dc	$CE7F,$C1F0,$3FF0,$0000
	dc	$3333,$FC3C,$3FC0,$0000
	dc	$E66C,$1E1F,$01FF,$0000
	dc	$673E,$87C1,$F800,$0000
	dc	$673E,$E0F8,$1FFF,$0000
	dc	$67CC,$783C,$8003,$0000
	dc	$CEF6,$3F0F,$FE07,$0000
	dc	$673E,$87C1,$F800,$0000
	dc	$673E,$E0F9,$1FF8,$0000
	dc	$667C,$E1FC,$1FF3,$0000
	dc	$CE66,$3E1F,$FFFF,$0000
	dc	$673E,$87C1,$F800,$0000
	dc	$673B,$E0FF,$1FFF,$0000
	dc	$BFC0,$FFC0,$FFC0,$0000
	dc	$1E66,$1FFF,$1FFF,$0000
	dc	$673E,$87C1,$F800,$0000
	dc	$673C,$E0FF,$1FFF,$0000
	dc	$C99B,$0E1F,$FFE3,$0000
	dc	$333E,$C3C7,$FC07,$0000
	dc	$673E,$87C1,$F800,$0000
	dc	$673F,$E0F8,$1FF8,$0000
	dc	$3999,$FE1E,$1FE0,$0000
	dc	$F336,$0F0F,$00FF,$0000
	dc	$339F,$C3E0,$FC00,$0000
	dc	$339F,$F07C,$0FFF,$0000
	dc	$33E6,$3C1E,$C001,$0000
	dc	$677B,$1F87,$FF03,$0000
	dc	$339F,$C3E0,$FC00,$0000
	dc	$339F,$F07C,$0FFC,$0000
	dc	$333E,$F0FE,$0FF9,$0000
	dc	$6767,$1F1F,$FFFF,$0000
	dc	$339F,$C3E0,$FC00,$0000
	dc	$339D,$F07F,$0FFF,$0000
	dc	$FFC0,$FFC0,$FFC0,$0000
	dc	$1D67,$1FFB,$1FFF,$0000
	dc	$339F,$C3E0,$FC00,$0000
	dc	$339C,$F07F,$0FFF,$0000
	dc	$CCCD,$0F0F,$F7F1,$0000
	dc	$999F,$E1E3,$FE03,$0000
	dc	$339F,$C3E0,$FC00,$0000
	dc	$339F,$F07C,$0FFC,$0000
	dc	$9CCC,$7F0F,$0FF0,$0000
	dc	$F99B,$0787,$007F,$0000
	dc	$99CF,$E1F0,$FE00,$0000
	dc	$99CF,$783E,$07FF,$0000
	dc	$99F3,$1E0F,$E000,$0000
	dc	$33BD,$0FC3,$FF81,$0000
	dc	$99CF,$E1F0,$FE00,$0000
	dc	$99CF,$783E,$07FE,$0000
	dc	$999E,$787E,$07FD,$0000
	dc	$6733,$1F0F,$FFFF,$0000
	dc	$99CF,$E1F0,$FE00,$0000
	dc	$99CE,$783F,$07FF,$0000
	dc	$FFE0,$FFE0,$FFE0,$0000
	dc	$1EB3,$1FFD,$1FFF,$0000
	dc	$99CF,$E1F0,$FE00,$0000
	dc	$99CE,$783F,$07FF,$0000
	dc	$64CC,$870F,$FFF0,$0000
	dc	$CCCF,$F0F1,$FF01,$0000
	dc	$99CF,$E1F0,$FE00,$0000
	dc	$99CF,$783E,$07FE,$0000
	dc	$CE66,$3F87,$07F8,$0000
	dc	$7CCD,$83C3,$003F,$0000
	dc	$CCE7,$F0F8,$FF00,$0000
	dc	$CCE7,$3C1F,$03FF,$0000
	dc	$99F3,$1E0F,$E000,$0000
	dc	$33BC,$0FC3,$FF80,$0000
	dc	$CCE7,$F0F8,$FF00,$0000
	dc	$CCE7,$3C1F,$03FF,$0000
	dc	$CCCF,$3C3F,$03FE,$0000
	dc	$3399,$0F87,$FFFF,$0000
	dc	$CCE7,$F0F8,$FF00,$0000
	dc	$CCE7,$3C1F,$03FF,$0000
	dc	$7FE0,$FFE0,$FFE0,$0000
	dc	$0D99,$0FFE,$0FFF,$0000
	dc	$CCE7,$F0F8,$FF00,$0000
	dc	$CCE7,$3C1F,$03FF,$0000
	dc	$3266,$C387,$FFF8,$0000
	dc	$CCCF,$F0F0,$FF00,$0000
	dc	$CCE7,$F0F8,$FF00,$0000
	dc	$CCE7,$3C1F,$03FF,$0000
	dc	$E733,$1FC3,$03FC,$0000
	dc	$3E66,$C1E1,$001F,$0000
	dc	$6673,$F87C,$FF80,$0000
	dc	$E673,$1E0F,$01FF,$0000
	dc	$CCF9,$8F07,$F000,$0000
	dc	$99DE,$87E1,$7FC0,$0000
	dc	$6673,$F87C,$7F80,$0000
	dc	$E673,$1E0F,$01FF,$0000
	dc	$CCCF,$BC3F,$83FE,$0000
	dc	$99D9,$87C7,$7FFF,$0000
	dc	$E673,$F87C,$FF80,$0000
	dc	$E673,$1E0F,$01FF,$0000
	dc	$BFF0,$FFF0,$FFF0,$0000
	dc	$0F4C,$0FFF,$0FFF,$0000
	dc	$E673,$787C,$FF80,$0000
	dc	$E673,$1E0F,$01FF,$0000
	dc	$B333,$C3C3,$FDFC,$0000
	dc	$6667,$F878,$7F80,$0000
	dc	$E673,$787C,$7F80,$0000
	dc	$E673,$1E0F,$01FF,$0000
	dc	$E733,$9FC3,$83FC,$0000
	dc	$3E66,$C1E1,$001F,$0000
	dc	$B339,$7C3E,$FFC0,$0000
	dc	$F339,$0F07,$00FF,$0000
	dc	$E67C,$C783,$F800,$0000
	dc	$CCEF,$C3F0,$3FE0,$0000
	dc	$3339,$FC3E,$3FC0,$0000
	dc	$F339,$0F07,$00FF,$0000
	dc	$E667,$DE1F,$C1FF,$0000
	dc	$99CC,$87C3,$7FFF,$0000
	dc	$F339,$FC3E,$FFC0,$0000
	dc	$F339,$0F07,$00FF,$0000
	dc	$DFF0,$FFF0,$FFF0,$0000
	dc	$06A6,$07FF,$07FF,$0000
	dc	$7339,$BC3E,$FFC0,$0000
	dc	$F339,$0F07,$00FF,$0000
	dc	$D933,$E1C3,$FFFC,$0000
	dc	$3333,$FC3C,$3FC0,$0000
	dc	$F339,$3C3E,$3FC0,$0000
	dc	$F339,$0F07,$00FF,$0000
	dc	$F399,$CFE1,$C1FE,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$D99C,$3E1F,$FFE0,$0000
	dc	$F99C,$0783,$007F,$0000
	dc	$F33E,$E3C1,$FC00,$0000
	dc	$6677,$E1F8,$1FF0,$0000
	dc	$999C,$7E1F,$1FE0,$0000
	dc	$F99C,$0783,$007F,$0000
	dc	$F333,$EF0F,$E0FF,$0000
	dc	$CCEC,$C3E3,$BFFF,$0000
	dc	$D99C,$DE1F,$FFE0,$0000
	dc	$F99C,$0783,$007F,$0000
	dc	$FFF0,$FFF0,$FFF0,$0000
	dc	$07A7,$07FB,$07FF,$0000
	dc	$399C,$DE1F,$FFE0,$0000
	dc	$F99C,$0783,$007F,$0000
	dc	$F999,$E1E1,$FEFE,$0000
	dc	$9999,$FE1E,$1FE0,$0000
	dc	$F99C,$1E1F,$1FE0,$0000
	dc	$F99C,$0783,$007F,$0000
	dc	$F9CC,$E7F0,$E0FF,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$CCCE,$3F0F,$FFF0,$0000
	dc	$7CCE,$83C1,$003F,$0000
	dc	$799F,$F1E0,$FE00,$0000
	dc	$333F,$F0F8,$0FF8,$0000
	dc	$9CCE,$7F0F,$0FF0,$0000
	dc	$7CCE,$83C1,$003F,$0000
	dc	$7999,$F787,$F07F,$0000
	dc	$E676,$E1F1,$DFFF,$0000
	dc	$7CCE,$EF0F,$FFF0,$0000
	dc	$7CCE,$83C1,$003F,$0000
	dc	$7FF8,$FFF8,$FFF8,$0000
	dc	$0753,$07FF,$07FF,$0000
	dc	$3CCE,$CF0F,$FFF0,$0000
	dc	$7CCE,$83C1,$003F,$0000
	dc	$7CCC,$F0F0,$FF7F,$0000
	dc	$CCCC,$FF0F,$0FF0,$0000
	dc	$FCCE,$0F0F,$0FF0,$0000
	dc	$7CCE,$83C1,$003F,$0000
	dc	$79E6,$F7F8,$F07F,$0000
	dc	$67CC,$783C,$8003,$0000
	dc	$6667,$1F87,$FFF8,$0000
	dc	$3E67,$C1E0,$001F,$0000
	dc	$3CCF,$F8F0,$FF00,$0000
	dc	$999F,$787C,$07FC,$0000
	dc	$CE67,$3F87,$07F8,$0000
	dc	$3E67,$C1E0,$001F,$0000
	dc	$3CCC,$FBC3,$F83F,$0000
	dc	$F33B,$F0F8,$EFFF,$0000
	dc	$3E67,$F787,$FFF8,$0000
	dc	$3E67,$C1E0,$001F,$0000
	dc	$3FF8,$FFF8,$FFF8,$0000
	dc	$03A9,$03FF,$03FF,$0000
	dc	$9E67,$E787,$FFF8,$0000
	dc	$3E67,$C1E0,$001F,$0000
	dc	$3E66,$F878,$FFBF,$0000
	dc	$6666,$7F87,$87F8,$0000
	dc	$7E67,$8787,$07F8,$0000
	dc	$3E67,$C1E0,$001F,$0000
	dc	$3CF3,$FBFC,$F83F,$0000
	dc	$33E6,$3C1E,$C001,$0000
	dc	$3333,$0FC3,$FFFC,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$9CCF,$7CF0,$FF00,$0000
	dc	$999D,$787E,$07FC,$0000
	dc	$E733,$1FC3,$03FC,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$9E66,$7DE1,$FC1F,$0000
	dc	$733B,$F0F8,$FFFF,$0000
	dc	$3733,$F3C3,$FFFC,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$9FFC,$7FFC,$FFFC,$0000
	dc	$03E4,$03FF,$03FF,$0000
	dc	$CF33,$F3C3,$FFFC,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$9E66,$7C78,$FFBF,$0000
	dc	$6666,$7F87,$87F8,$0000
	dc	$7F33,$83C3,$03FC,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$9E79,$7DFE,$FC1F,$0000
	dc	$99F3,$1E0F,$E000,$0000
	dc	$9999,$87E1,$7FFE,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$CE67,$3E78,$FF80,$0000
	dc	$CCCF,$3C3E,$03FE,$0000
	dc	$E799,$1FE1,$01FE,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$CE66,$3FE1,$FE1F,$0000
	dc	$799D,$F87C,$F7FF,$0000
	dc	$9D99,$7BE1,$FFFE,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$CFFC,$3FFC,$FFFC,$0000
	dc	$03D4,$03FF,$03FF,$0000
	dc	$E799,$79E1,$FFFE,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$CF33,$3E3C,$FFDF,$0000
	dc	$3333,$3FC3,$C3FC,$0000
	dc	$3F99,$C1E1,$01FE,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$CF39,$3EFE,$FE1F,$0000
	dc	$99F3,$1E0F,$E000,$0000
	dc	$CCCC,$C3F0,$3FFF,$0000
	dc	$E7CC,$F83C,$0003,$0000
	dc	$E733,$1F3C,$FFC0,$0000
	dc	$E667,$1E1F,$01FF,$0000
	dc	$F3CC,$0FF0,$00FF,$0000
	dc	$E7CC,$F83C,$0003,$0000
	dc	$E733,$1FF0,$FF0F,$0000
	dc	$3CCE,$FC3E,$FBFF,$0000
	dc	$CECC,$3DF0,$FFFF,$0000
	dc	$E7CC,$F83C,$0003,$0000
	dc	$E7FE,$1FFE,$FFFE,$0000
	dc	$01EA,$01FF,$01FF,$0000
	dc	$73CC,$BCF0,$FFFF,$0000
	dc	$E7CC,$F83C,$0003,$0000
	dc	$E799,$1F1E,$FFEF,$0000
	dc	$9999,$1FE1,$E1FE,$0000
	dc	$9FCC,$E0F0,$00FF,$0000
	dc	$E7CC,$F83C,$0003,$0000
	dc	$E73C,$1FFF,$FF0F,$0000
	dc	$CCF9,$0F07,$F000,$0000
	dc	$6666,$E1F8,$1FFF,$0000
	dc	$73E6,$7C1E,$8001,$0000
	dc	$7399,$0F9E,$FFE0,$0000
	dc	$F333,$0F0F,$00FF,$0000
	dc	$F9E6,$87F8,$807F,$0000
	dc	$73E6,$7C1E,$8001,$0000
	dc	$7399,$0FF8,$FF87,$0000
	dc	$9CCE,$7C3E,$FFFF,$0000
	dc	$CE66,$3DF8,$FFFF,$0000
	dc	$73E6,$7C1E,$8001,$0000
	dc	$73FE,$0FFE,$FFFE,$0000
	dc	$01E9,$01FF,$01FF,$0000
	dc	$39E6,$DE78,$FFFF,$0000
	dc	$73E6,$7C1E,$8001,$0000
	dc	$7399,$0F9E,$FFEF,$0000
	dc	$99CC,$1EF0,$E0FF,$0000
	dc	$CFE6,$F078,$007F,$0000
	dc	$73E6,$7C1E,$8001,$0000
	dc	$739E,$0FFF,$FF87,$0000
	dc	$667C,$8783,$F800,$0000
	dc	$6673,$E1FC,$1FFF,$0000
	dc	$39F3,$3E0F,$C000,$0000
	dc	$39CC,$07CF,$FFF0,$0000
	dc	$F999,$0787,$007F,$0000
	dc	$FCF3,$C3FC,$C03F,$0000
	dc	$39F3,$3E0F,$C000,$0000
	dc	$39CC,$07FC,$FFC3,$0000
	dc	$CE67,$3E1F,$FFFF,$0000
	dc	$6733,$1EFC,$FFFF,$0000
	dc	$39F3,$3E0F,$C000,$0000
	dc	$39FF,$07FF,$FFFF,$0000
	dc	$01F5,$01FF,$01FF,$0000
	dc	$39B3,$DE3C,$FFFF,$0000
	dc	$39F3,$3E0F,$C000,$0000
	dc	$39CC,$07CF,$FFF7,$0000
	dc	$CCE6,$0F78,$F07F,$0000
	dc	$67F3,$783C,$803F,$0000
	dc	$39F3,$3E0F,$C000,$0000
	dc	$39CF,$07FF,$FFC3,$0000
	dc	$333E,$C3C1,$FC00,$0000
	dc	$3339,$F0FE,$0FFF,$0000
	dc	$9CF9,$1F07,$E000,$0000
	dc	$9CE6,$83E7,$7FF8,$0000
	dc	$7CCC,$83C3,$003F,$0000
	dc	$FCD9,$E3DE,$E03F,$0000
	dc	$9CF9,$1F07,$E000,$0000
	dc	$9CE6,$83FE,$7FE1,$0000
	dc	$6733,$1F0F,$FFFF,$0000
	dc	$E739,$9EFE,$FFFF,$0000
	dc	$9CF9,$1F07,$E000,$0000
	dc	$9CFF,$83FF,$7FFF,$0000
	dc	$00F4,$00FF,$00FF,$0000
	dc	$9CD9,$EF1E,$FFFF,$0000
	dc	$9CF9,$1F07,$E000,$0000
	dc	$9CEE,$83EF,$7FF3,$0000
	dc	$6673,$87BC,$F83F,$0000
	dc	$33F9,$3C1E,$C01F,$0000
	dc	$9CF9,$1F07,$E000,$0000
	dc	$9CED,$83FD,$7FE3,$0000
	dc	$999F,$E1E0,$FE00,$0000
	dc	$999C,$787F,$07FF,$0000
	dc	$CE7C,$0F83,$F000,$0000
	dc	$CE76,$C1F7,$3FF8,$0000
	dc	$7CCC,$83C3,$003F,$0000
	dc	$FE6C,$E1EF,$E01F,$0000
	dc	$CE7C,$0F83,$F000,$0000
	dc	$CE73,$C1FF,$3FF0,$0000
	dc	$3399,$0F87,$FFFF,$0000
	dc	$F39C,$CF7F,$FFFF,$0000
	dc	$CE7C,$0F83,$F000,$0000
	dc	$CE7F,$C1FF,$3FFF,$0000
	dc	$80DA,$80FF,$80FF,$0000
	dc	$4E6C,$F78F,$FFFF,$0000
	dc	$CE7C,$0F83,$F000,$0000
	dc	$CE76,$C1F7,$3FFB,$0000
	dc	$6673,$87BC,$F83F,$0000
	dc	$33EC,$3C1F,$C00F,$0000
	dc	$CE7C,$0F83,$F000,$0000
	dc	$CE76,$C1FE,$3FF1,$0000
	dc	$CCCF,$F0F0,$FF00,$0000
	dc	$CCCE,$3C3F,$03FF,$0000
	dc	$673E,$87C1,$F800,$0000
	dc	$673B,$E0FB,$1FFC,$0000
	dc	$3E66,$C1E1,$001F,$0000
	dc	$7F36,$F0F7,$F00F,$0000
	dc	$673E,$87C1,$F800,$0000
	dc	$673B,$E0FF,$1FF8,$0000
	dc	$3399,$0F87,$FFFF,$0000
	dc	$D99E,$C7FF,$FFFF,$0000
	dc	$673E,$87C1,$F800,$0000
	dc	$673F,$E0FF,$1FFF,$0000
	dc	$80F9,$80FF,$80FF,$0000
	dc	$2736,$FBC7,$FFFF,$0000
	dc	$673E,$87C1,$F800,$0000
	dc	$673B,$E0FB,$1FFD,$0000
	dc	$3339,$C3DE,$FC1F,$0000
	dc	$99F6,$1E0F,$E007,$0000
	dc	$673E,$87C1,$F800,$0000
	dc	$673B,$E0FF,$1FF8,$0000
	dc	$CCCF,$F0F0,$FF00,$0000
	dc	$E667,$1E1F,$01FF,$0000
	dc	$339F,$C3E0,$FC00,$0000
	dc	$339D,$F07D,$0FFE,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$3F33,$F8F3,$F80F,$0000
	dc	$339F,$C3E0,$FC00,$0000
	dc	$339D,$F07F,$0FFC,$0000
	dc	$99CC,$87C3,$7FFF,$0000
	dc	$F9CF,$E7BF,$FFFF,$0000
	dc	$339F,$C3E0,$FC00,$0000
	dc	$339F,$F07F,$0FFF,$0000
	dc	$C06D,$C07F,$C07F,$0000
	dc	$279B,$F9E3,$FFFF,$0000
	dc	$339F,$C3E0,$FC00,$0000
	dc	$339F,$F07F,$0FFC,$0000
	dc	$999C,$E1EF,$FE0F,$0000
	dc	$CCFB,$0F07,$F003,$0000
	dc	$339F,$C3E0,$FC00,$0000
	dc	$339D,$F07F,$0FFC,$0000
	dc	$E667,$F878,$7F80,$0000
	dc	$F333,$0F0F,$00FF,$0000
	dc	$99CF,$E1F0,$FE00,$0000
	dc	$99CE,$783E,$07FF,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$9F99,$7C79,$FC07,$0000
	dc	$99CF,$E1F0,$FE00,$0000
	dc	$99CE,$783F,$07FE,$0000
	dc	$CCE6,$C3E1,$3FFF,$0000
	dc	$7CE7,$F3DF,$FFFF,$0000
	dc	$99CF,$E1F0,$FE00,$0000
	dc	$99CF,$783F,$07FF,$0000
	dc	$C07A,$C07F,$C07F,$0000
	dc	$93CD,$FCF1,$FFFF,$0000
	dc	$99CF,$E1F0,$FE00,$0000
	dc	$99CF,$783F,$07FE,$0000
	dc	$CCCE,$F0F7,$7F07,$0000
	dc	$667D,$8783,$F801,$0000
	dc	$99CF,$E1F0,$FE00,$0000
	dc	$99CF,$783F,$07FE,$0000
	dc	$B333,$BC3C,$7FC0,$0000
	dc	$F333,$0F0F,$00FF,$0000
	dc	$CCE7,$F0F8,$FF00,$0000
	dc	$CCE7,$3C1F,$03FF,$0000
	dc	$67CC,$783C,$8003,$0000
	dc	$CFCC,$3E3C,$FE03,$0000
	dc	$CCE7,$F0F8,$FF00,$0000
	dc	$CCE7,$3C1F,$03FF,$0000
	dc	$6676,$E1F1,$1FFF,$0000
	dc	$7667,$F1FE,$FFFF,$0000
	dc	$CCE7,$F0F8,$FF00,$0000
	dc	$CCE7,$3C1F,$03FF,$0000
	dc	$E076,$E07F,$E07F,$0000
	dc	$49CC,$FEF0,$FFFF,$0000
	dc	$CCE7,$F0F8,$FF00,$0000
	dc	$CCE7,$3C1F,$03FF,$0000
	dc	$CCCF,$F0F3,$7F03,$0000
	dc	$333E,$C3C1,$FC00,$0000
	dc	$CCE7,$F0F8,$FF00,$0000
	dc	$CCE7,$3C1F,$03FF,$0000
	dc	$D999,$DE1E,$3FE0,$0000
	dc	$F999,$0787,$007F,$0000
	dc	$E673,$F87C,$FF80,$0000
	dc	$E673,$1E0F,$01FF,$0000
	dc	$B3E6,$BC1E,$C001,$0000
	dc	$67E6,$1F1E,$FF01,$0000
	dc	$6673,$787C,$FF80,$0000
	dc	$E673,$1E0F,$01FF,$0000
	dc	$B33B,$F0F8,$8FFF,$0000
	dc	$3E73,$F9EF,$FFFF,$0000
	dc	$6673,$F87C,$FF80,$0000
	dc	$E673,$1E0F,$01FF,$0000
	dc	$E03D,$E03F,$E03F,$0000
	dc	$49E6,$FE78,$FFFF,$0000
	dc	$6673,$787C,$FF80,$0000
	dc	$E673,$1E0F,$01FF,$0000
	dc	$E667,$F879,$BF81,$0000
	dc	$999F,$E1E0,$FE00,$0000
	dc	$6673,$F87C,$7F80,$0000
	dc	$E673,$1E0F,$01FF,$0000
	dc	$ECCC,$EF0F,$9FF0,$0000
	dc	$7CCC,$83C3,$003F,$0000
	dc	$F339,$FC3E,$FFC0,$0000
	dc	$F339,$0F07,$00FF,$0000
	dc	$F3E6,$FC1E,$C001,$0000
	dc	$67E6,$1F1E,$FF01,$0000
	dc	$7339,$3C3E,$FFC0,$0000
	dc	$F339,$0F07,$00FF,$0000
	dc	$D99D,$F87C,$C7FF,$0000
	dc	$9F33,$7CFF,$FFFF,$0000
	dc	$B339,$7C3E,$FFC0,$0000
	dc	$F339,$0F07,$00FF,$0000
	dc	$F03B,$F03F,$F03F,$0000
	dc	$24F3,$FF3C,$FFFF,$0000
	dc	$3339,$3C3E,$FFC0,$0000
	dc	$F339,$0F07,$00FF,$0000
	dc	$F333,$FC3D,$DFC1,$0000
	dc	$999F,$E1E0,$FE00,$0000
	dc	$3339,$FC3E,$3FC0,$0000
	dc	$F339,$0F07,$00FF,$0000
	dc	$E666,$E787,$DFF8,$0000
	dc	$3E66,$C1E1,$001F,$0000
	dc	$799C,$FE1F,$FFE0,$0000
	dc	$F99C,$0783,$007F,$0000
	dc	$F9F3,$FE0F,$E000,$0000
	dc	$33F3,$0F8F,$FF80,$0000
	dc	$399C,$1E1F,$FFE0,$0000
	dc	$F99C,$0783,$007F,$0000
	dc	$F99C,$F87C,$E7FF,$0000
	dc	$CF39,$3EF7,$FFFF,$0000
	dc	$B99C,$FE1F,$FFE0,$0000
	dc	$F99C,$0783,$007F,$0000
	dc	$F03E,$F03F,$F03F,$0000
	dc	$A679,$FB9E,$FFFF,$0000
	dc	$999C,$1E1F,$FFE0,$0000
	dc	$F99C,$0783,$007F,$0000
	dc	$F333,$FC3C,$FFC0,$0000
	dc	$CCCF,$F0F0,$FF00,$0000
	dc	$999C,$7E1F,$1FE0,$0000
	dc	$F99C,$0783,$007F,$0000
	dc	$F666,$F787,$EFF8,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$3CCE,$FF0F,$FFF0,$0000
	dc	$7CCE,$83C1,$003F,$0000
	dc	$7CF9,$FF07,$F000,$0000
	dc	$99F9,$87C7,$7FC0,$0000
	dc	$9CCE,$8F0F,$7FF0,$0000
	dc	$7CCE,$83C1,$003F,$0000
	dc	$7CCE,$FC3E,$F3FF,$0000
	dc	$CF99,$3E7F,$FFFF,$0000
	dc	$DCCE,$BF0F,$FFF0,$0000
	dc	$7CCE,$83C1,$003F,$0000
	dc	$781D,$F81F,$F81F,$0000
	dc	$933C,$FDCF,$FFFF,$0000
	dc	$CCCE,$0F0F,$FFF0,$0000
	dc	$7CCE,$83C1,$003F,$0000
	dc	$7999,$FE1E,$FFE0,$0000
	dc	$E667,$7878,$7F80,$0000
	dc	$CCCE,$3F0F,$0FF0,$0000
	dc	$7CCE,$83C1,$003F,$0000
	dc	$7B33,$FBC3,$F7FC,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$9E67,$7F87,$FFF8,$0000
	dc	$3E67,$C1E0,$001F,$0000
	dc	$3E7C,$FF83,$F800,$0000
	dc	$CCF9,$C3E7,$3FE0,$0000
	dc	$9E67,$8787,$7FF8,$0000
	dc	$3E67,$C1E0,$001F,$0000
	dc	$3E67,$FE1F,$F9FF,$0000
	dc	$67CC,$1F3F,$FFFF,$0000
	dc	$DE67,$FF87,$FFF8,$0000
	dc	$3E67,$C1E0,$001F,$0000
	dc	$3C1F,$FC1F,$FC1F,$0000
	dc	$4936,$FFC7,$FFFF,$0000
	dc	$6667,$8787,$FFF8,$0000
	dc	$3E67,$C1E0,$001F,$0000
	dc	$3CCC,$FF0F,$FFF0,$0000
	dc	$F333,$3C3C,$3FC0,$0000
	dc	$E667,$1F87,$07F8,$0000
	dc	$3E67,$C1E0,$001F,$0000
	dc	$3D99,$FDE1,$FBFE,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$9F33,$7FC3,$FFFC,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$9F3E,$7FC1,$FC00,$0000
	dc	$667C,$E1F3,$1FF0,$0000
	dc	$CF33,$C3C3,$3FFC,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$9F33,$7F0F,$FCFF,$0000
	dc	$B3CC,$8FBF,$FFFF,$0000
	dc	$EF33,$DFC3,$FFFC,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$9C1E,$7C1F,$FC1F,$0000
	dc	$C99E,$FEE7,$FFFF,$0000
	dc	$6733,$87C3,$FBFC,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$9E66,$7F87,$FFF8,$0000
	dc	$7999,$9E1E,$1FE0,$0000
	dc	$F333,$0FC3,$03FC,$0000
	dc	$9F33,$E0F0,$000F,$0000
	dc	$9CCC,$7CF0,$FFFF,$0000
	dc	$67CC,$783C,$8003,$0000
	dc	$CF99,$3FE1,$FFFE,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$CF9F,$3FE0,$FE00,$0000
	dc	$333E,$F0F9,$0FF8,$0000
	dc	$6799,$E1E1,$1FFE,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$CF99,$3F87,$FE7F,$0000
	dc	$F3E6,$CF9F,$FFFF,$0000
	dc	$6F99,$FFE1,$FFFE,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$CE0E,$3E0F,$FE0F,$0000
	dc	$A4CF,$FF73,$FFFF,$0000
	dc	$3399,$C3E1,$FDFE,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$CE66,$3F87,$FFF8,$0000
	dc	$7CCC,$8F0F,$0FF0,$0000
	dc	$F999,$07E1,$01FE,$0000
	dc	$CF99,$F078,$0007,$0000
	dc	$CE66,$3E78,$FFFF,$0000
	dc	$33E6,$3C1E,$C001,$0000
	dc	$67CC,$1FF0,$FFFF,$0000
	dc	$E7CC,$F83C,$0003,$0000
	dc	$E79F,$1FE0,$FF00,$0000
	dc	$333F,$F0F8,$0FF8,$0000
	dc	$33CC,$F0F0,$0FFF,$0000
	dc	$E7CC,$F83C,$0003,$0000
	dc	$E7CC,$1FC3,$FF3F,$0000
	dc	$F9F3,$E7CF,$FFFF,$0000
	dc	$37CC,$FFF0,$FFFF,$0000
	dc	$E7CC,$F83C,$0003,$0000
	dc	$E70F,$1F0F,$FF0F,$0000
	dc	$524D,$FFF1,$FFFF,$0000
	dc	$99CC,$E1F0,$FEFF,$0000
	dc	$E7CC,$F83C,$0003,$0000
	dc	$E733,$1FC3,$FFFC,$0000
	dc	$3CCC,$CF0F,$0FF0,$0000
	dc	$F9CC,$07F0,$00FF,$0000
	dc	$E7CC,$F83C,$0003,$0000
	dc	$E733,$1F3C,$FFFF,$0000
	dc	$99F3,$1E0F,$E000,$0000
	dc	$33E6,$0FF8,$FFFF,$0000
	dc	$73E6,$7C1E,$8001,$0000
	dc	$73CF,$0FF0,$FF80,$0000
	dc	$999F,$787C,$07FC,$0000
	dc	$3366,$F0F8,$0FFF,$0000
	dc	$73E6,$7C1E,$8001,$0000
	dc	$73CC,$0FC3,$FFBF,$0000
	dc	$ECF3,$E3EF,$FFFF,$0000
	dc	$37E6,$FFF8,$FFFF,$0000
	dc	$73E6,$7C1E,$8001,$0000
	dc	$738F,$0F8F,$FF8F,$0000
	dc	$5266,$FFB8,$FFFF,$0000
	dc	$CCE6,$F0F8,$FF7F,$0000
	dc	$73E6,$7C1E,$8001,$0000
	dc	$7399,$0FE1,$FFFE,$0000
	dc	$9E66,$E787,$07F8,$0000
	dc	$7CE6,$83F8,$007F,$0000
	dc	$73E6,$7C1E,$8001,$0000
	dc	$73B3,$0FBC,$FFFF,$0000
	dc	$CCF9,$0F07,$F000,$0000
	dc	$99F3,$87FC,$7FFF,$0000
	dc	$39F3,$3E0F,$C000,$0000
	dc	$39E7,$07F8,$FFC0,$0000
	dc	$CCCF,$3C3E,$03FE,$0000
	dc	$99B3,$787C,$07FF,$0000
	dc	$39F3,$3E0F,$C000,$0000
	dc	$39E6,$07E1,$FFDF,$0000
	dc	$7679,$F1F7,$FFFF,$0000
	dc	$9BF3,$FFFC,$FFFF,$0000
	dc	$39F3,$3E0F,$C000,$0000
	dc	$39CF,$07CF,$FFCF,$0000
	dc	$A933,$FFDC,$FFFF,$0000
	dc	$6673,$787C,$FFBF,$0000
	dc	$39F3,$3E0F,$C000,$0000
	dc	$39D9,$07E1,$FFFE,$0000
	dc	$9F33,$E3C3,$03FC,$0000
	dc	$3E73,$C1FC,$003F,$0000
	dc	$39F3,$3E0F,$C000,$0000
	dc	$39D9,$07DE,$FFFF,$0000
	dc	$667C,$8783,$F800,$0000
	dc	$CCF9,$C3FE,$3FFF,$0000
	dc	$9CF9,$1F07,$E000,$0000
	dc	$9CF3,$83FC,$7FE0,$0000
	dc	$E667,$1E1F,$01FF,$0000
	dc	$CCD9,$3C3E,$03FF,$0000
	dc	$9CF9,$1F07,$E000,$0000
	dc	$9CF3,$83F0,$7FEF,$0000
	dc	$3E79,$F9F7,$FFFF,$0000
	dc	$9BD9,$FFFE,$FFFF,$0000
	dc	$9CF9,$1F07,$E000,$0000
	dc	$9CE7,$83E7,$7FE7,$0000
	dc	$A939,$FFCE,$FFFF,$0000
	dc	$B339,$3C3E,$FFDF,$0000
	dc	$9CF9,$1F07,$E000,$0000
	dc	$9CEC,$83F0,$7FFF,$0000
	dc	$CF99,$F1E1,$01FE,$0000
	dc	$9F39,$E0FE,$001F,$0000
	dc	$9CF9,$1F07,$E000,$0000
	dc	$9CEC,$83EF,$7FFF,$0000
	dc	$667C,$8783,$F800,$0000
	dc	$CCEC,$C3EF,$3FFF,$0000
	dc	$CE7C,$0F83,$F000,$0000
	dc	$CE79,$C1FE,$3FF0,$0000
	dc	$F333,$0F0F,$00FF,$0000
	dc	$CCCC,$BC3F,$83FF,$0000
	dc	$CE7C,$0F83,$F000,$0000
	dc	$CE79,$C1F8,$3FF7,$0000
	dc	$9F3C,$7CFB,$FFFF,$0000
	dc	$CDFC,$FFFF,$FFFF,$0000
	dc	$CE7C,$0F83,$F000,$0000
	dc	$CE77,$C1F7,$3FF7,$0000
	dc	$5499,$FFEE,$FFFF,$0000
	dc	$B33C,$3C3F,$FFCF,$0000
	dc	$CE7C,$0F83,$F000,$0000
	dc	$CE76,$C1F8,$3FFF,$0000
	dc	$67CC,$78F0,$80FF,$0000
	dc	$CF9C,$F07F,$000F,$0000
	dc	$CE7C,$0F83,$F000,$0000
	dc	$CE76,$C1F7,$3FFF,$0000
	dc	$333E,$C3C1,$FC00,$0000
	dc	$6676,$E1F7,$1FFF,$0000
	dc	$673E,$87C1,$F800,$0000
	dc	$673C,$E0FF,$1FF8,$0000
	dc	$F999,$0787,$007F,$0000
	dc	$E666,$DE1F,$C1FF,$0000
	dc	$673E,$87C1,$F800,$0000
	dc	$673C,$E0FC,$1FFB,$0000
	dc	$CF9E,$3E7D,$FFFF,$0000
	dc	$6DEE,$FFFF,$FFFF,$0000
	dc	$673E,$87C1,$F800,$0000
	dc	$673F,$E0FF,$1FFF,$0000
	dc	$D4CC,$FF77,$FFFF,$0000
	dc	$D99E,$1E1F,$FFE7,$0000
	dc	$673E,$87C1,$F800,$0000
	dc	$673B,$E0FC,$1FFF,$0000
	dc	$33E6,$3C78,$C07F,$0000
	dc	$67CE,$783F,$8007,$0000
	dc	$673E,$87C1,$F800,$0000
	dc	$673F,$E0FB,$1FFF,$0000
	dc	$999F,$E1E0,$FE00,$0000
	dc	$333B,$F0FB,$0FFF,$0000
	dc	$339F,$C3E0,$FC00,$0000
	dc	$339C,$F07F,$0FFC,$0000
	dc	$F999,$0787,$007F,$0000
	dc	$F333,$CF0F,$C0FF,$0000
	dc	$339F,$C3E0,$FC00,$0000
	dc	$339E,$F07E,$0FFD,$0000
	dc	$679E,$1F7D,$FFFF,$0000
	dc	$66FF,$FFFF,$FFFF,$0000
	dc	$339F,$C3E0,$FC00,$0000
	dc	$339F,$F07F,$0FFF,$0000
	dc	$AA4E,$FFF3,$FFFF,$0000
	dc	$6CCF,$8F0F,$FFF3,$0000
	dc	$339F,$C3E0,$FC00,$0000
	dc	$339F,$F07C,$0FFF,$0000
	dc	$33E6,$3C78,$C07F,$0000
	dc	$67CF,$783F,$8003,$0000
	dc	$339F,$C3E0,$FC00,$0000
	dc	$339F,$F07D,$0FFF,$0000
	dc	$CCCF,$F0F0,$FF00,$0000
	dc	$999D,$787D,$07FF,$0000
	dc	$99CF,$E1F0,$FE00,$0000
	dc	$99CE,$783F,$07FE,$0000
	dc	$7CCC,$83C3,$003F,$0000
	dc	$F999,$E787,$E07F,$0000
	dc	$99CF,$E1F0,$FE00,$0000
	dc	$99CE,$783E,$07FF,$0000
	dc	$67CF,$1F3E,$FFFF,$0000
	dc	$36FB,$FFFF,$FFFF,$0000
	dc	$99CF,$E1F0,$FE00,$0000
	dc	$99CF,$783F,$07FF,$0000
	dc	$EA66,$FFBB,$FFFF,$0000
	dc	$6667,$8787,$FFF9,$0000
	dc	$99CF,$E1F0,$FE00,$0000
	dc	$99CF,$783E,$07FF,$0000
	dc	$99F3,$1E3C,$E03F,$0000
	dc	$33E7,$3C1F,$C001,$0000
	dc	$99CF,$E1F0,$FE00,$0000
	dc	$99CF,$783F,$07FF,$0000
	rept	760
	dc	$0000,$0000,$0000,$0000
	endr
	rept	245
	dc	$FFFF,$FFFF,$FFFF,$FFFF
	endr
	rept	5
	dc	$0000,$0000,$0000,$0000
	endr
LIMITE:DCB.W     2,0 
SENS:DCB.W     2,0 
COURBE:
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$00A0,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$00A0
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$00A0,$0140
	dc	$0140,$0140,$0140,$00A0
	dc	$0140,$0140,$0140,$00A0
	dc	$0140,$0140,$00A0,$0140
	dc	$0140,$00A0,$0140,$0140
	dc	$00A0,$0140,$00A0,$0140
	dc	$00A0,$0140,$00A0,$0140
	dc	$00A0,$00A0,$0140,$00A0
	dc	$00A0,$0140,$00A0,$00A0
	dc	$00A0,$00A0,$00A0,$0140
	dc	$00A0,$00A0,$00A0,$00A0
	dc	$00A0,$00A0,$00A0,$00A0
	dc	$0000,$00A0,$00A0,$00A0
	dc	$0000,$00A0,$00A0,$00A0
	dc	$0000,$00A0,$0000,$00A0
	dc	$0000,$00A0,$0000,$0000
	dc	$00A0,$0000,$0000,$00A0
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$FF60
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$FF60,$0000
	dc	$0000,$FF60,$0000,$0000
	dc	$FF60,$0000,$FF60,$0000
	dc	$FF60,$0000,$FF60,$FF60
	dc	$FF60,$0000,$FF60,$FF60
	dc	$FF60,$0000,$FF60,$FF60
	dc	$FF60,$FF60,$FF60,$FF60
	dc	$FF60,$FF60,$FEC0,$FF60
	dc	$FF60,$FF60,$FF60,$FF60
	dc	$FEC0,$FF60,$FF60,$FEC0
	dc	$FF60,$FF60,$FEC0,$FF60
	dc	$FEC0,$FF60,$FEC0,$FF60
	dc	$FEC0,$FF60,$FEC0,$FEC0
	dc	$FF60,$FEC0,$FF60,$FEC0
	dc	$FEC0,$FEC0,$FF60,$FEC0
	dc	$FEC0,$FEC0,$FF60,$FEC0
	dc	$FEC0,$FEC0,$FF60,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FF60,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FF60
	dc	$FEC0,$FEC0,$FEC0,$FEC0
	dc	$FEC0,$FEC0,$FF60,$FEC0
	dc	$FEC0,$FEC0,$FEC0,$FF60
	dc	$FEC0,$FEC0,$FEC0,$FF60
	dc	$FEC0,$FEC0,$FF60,$FEC0
	dc	$FEC0,$FF60,$FEC0,$FEC0
	dc	$FF60,$FEC0,$FF60,$FEC0
	dc	$FF60,$FEC0,$FF60,$FEC0
	dc	$FF60,$FF60,$FEC0,$FF60
	dc	$FF60,$FEC0,$FF60,$FF60
	dc	$FF60,$FF60,$FF60,$FEC0
	dc	$FF60,$FF60,$FF60,$FF60
	dc	$FF60,$FF60,$FF60,$FF60
	dc	$0000,$FF60,$FF60,$FF60
	dc	$0000,$FF60,$FF60,$FF60
	dc	$0000,$FF60,$0000,$FF60
	dc	$0000,$FF60,$0000,$0000
	dc	$FF60,$0000,$0000,$FF60
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$00A0,$0000
	dc	$0000,$00A0,$0000,$0000
	dc	$00A0,$0000,$00A0,$0000
	dc	$00A0,$0000,$00A0,$00A0
	dc	$00A0,$0000,$00A0,$00A0
	dc	$00A0,$0000,$00A0,$00A0
	dc	$00A0,$00A0,$00A0,$00A0
	dc	$00A0,$00A0,$00A0,$0140
	dc	$00A0,$00A0,$00A0,$00A0
	dc	$0140,$00A0,$00A0,$0140
	dc	$00A0,$00A0,$0140,$00A0
	dc	$0140,$00A0,$0140,$00A0
	dc	$0140,$00A0,$0140,$0140
	dc	$00A0,$0140,$00A0,$0140
	dc	$0140,$0140,$00A0,$0140
	dc	$0140,$0140,$00A0,$0140
	dc	$0140,$0140,$00A0,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$00A0,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$0140,$0140,$0140,$0140
	dc	$FFFF
BUFFER:
	DCB.W	2,0 
DATA_S0:
	dc	$FFFF
DATA_S1:
	dc	$3E80,$3F20,$4060,$4100
	dc	$4240,$42E0,$4420,$44C0
	dc	$4600,$46A0,$4740,$4880
	dc	$4920,$49C0,$4B00,$4BA0
	dc	$4C40,$4CE0,$4E20,$4EC0
	dc	$4F60,$5000,$50A0,$5140
	dc	$51E0,$5280,$5320,$5320
	dc	$53C0,$5460,$5500,$5500
	dc	$55A0,$55A0,$5640,$5640
	dc	$56E0,$56E0,$56E0,$5780
	dc	$5780,$5780,$5780,$5780
	dc	$5780,$5780,$5780,$5780
	dc	$56E0,$56E0,$56E0,$5640
	dc	$5640,$55A0,$55A0,$5500
	dc	$5460,$5460,$53C0,$5320
	dc	$5280,$51E0,$5140,$50A0
	dc	$5000,$4F60,$4EC0,$4E20
	dc	$4D80,$4CE0,$4C40,$4B00
	dc	$4A60,$49C0,$4880,$47E0
	dc	$4740,$4600,$4560,$4420
	dc	$4380,$42E0,$41A0,$4100
	dc	$3FC0,$3F20,$3DE0,$3D40
	dc	$3C00,$3B60,$3A20,$3980
	dc	$38E0,$37A0,$3700,$35C0
	dc	$3520,$3480,$3340,$32A0
	dc	$3200,$30C0,$3020,$2F80
	dc	$2EE0,$2E40,$2DA0,$2D00
	dc	$2C60,$2BC0,$2B20,$2A80
	dc	$29E0,$2940,$28A0,$28A0
	dc	$2800,$2760,$2760,$26C0
	dc	$26C0,$2620,$2620,$2620
	dc	$2580,$2580,$2580,$2580
	dc	$2580,$2580,$2580,$2580
	dc	$2580,$2620,$2620,$2620
	dc	$26C0,$26C0,$2760,$2760
	dc	$2800,$2800,$28A0,$2940
	dc	$29E0,$29E0,$2A80,$2B20
	dc	$2BC0,$2C60,$2D00,$2DA0
	dc	$2E40,$2EE0,$3020,$30C0
	dc	$3160,$3200,$3340,$33E0
	dc	$3480,$35C0,$3660,$3700
	dc	$3840,$38E0,$3A20,$3AC0
	dc	$3C00,$3CA0,$3DE0,$3E80
	dc	$3F20,$4060,$4100,$4240
	dc	$42E0,$4420,$44C0,$4600
	dc	$46A0,$4740,$4880,$4920
	dc	$49C0,$4B00,$4BA0,$4C40
	dc	$4CE0,$4E20,$4EC0,$4F60
	dc	$5000,$50A0,$5140,$51E0
	dc	$5280,$5320,$5320,$53C0
	dc	$5460,$5500,$5500,$55A0
	dc	$55A0,$5640,$5640,$56E0
	dc	$56E0,$56E0,$FFFF
DATA_S2:
	dc	$3FFF,$FFF0,$FFFF,$FFF0
	dc	$3FFF,$FFF0,$FFFF,$FFF0
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$3FFF,$FFF0,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$7FFF,$FFF8,$FFFF,$FFF8
	dc	$7FFF,$FFF8,$FFFF,$FFF8
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$7FFF,$FFF8,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$0000,$FFF0,$3FFC
	dc	$FFF0,$0000,$FFF0,$0000
	dc	$FFF0,$0000,$FFF0,$3FFC
	dc	$003F,$F000,$003F,$F000
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$0000,$FFF0,$3FFC
	dc	$FFF0,$0000,$FFF0,$0000
	dc	$FFF0,$0000,$FFF0,$3FFC
	dc	$003F,$F000,$003F,$F000
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$0000,$FFF0,$3FFC
	dc	$FFF0,$0000,$FFF0,$0000
	dc	$FFF0,$0000,$FFFF,$FFFC
	dc	$003F,$F000,$003F,$F000
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF0,$0000,$FFF0,$3FFC
	dc	$FFFF,$C000,$FFFF,$C000
	dc	$FFF0,$0000,$FFFF,$FFFC
	dc	$003F,$F000,$003F,$F000
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF0,$0000,$FFF0,$3FFC
	dc	$FFFF,$C000,$FFFF,$C000
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$003F,$F000,$003F,$F000
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF0,$0000,$FFF0,$3FFC
	dc	$FFFF,$C000,$FFFF,$C000
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$003F,$F000,$003F,$F000
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF0,$0000,$FFF0,$3FFC
	dc	$FFFF,$C000,$FFFF,$C000
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$003F,$F000,$003F,$F000
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$0000,$FFF0,$3FFC
	dc	$FFF0,$0000,$FFF0,$0000
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$003F,$F000,$003F,$F000
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF0,$0000,$FFF0,$0000
	dc	$FFFF,$FFFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$F000
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF0,$0000,$FFF0,$0000
	dc	$FFFF,$FFFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$F000
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFF0,$0000
	dc	$FFFF,$FFFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$F000
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFF0,$0000
	dc	$FFFF,$FFFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$F000
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFF0,$0000
	dc	$FFFF,$FFFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$F000
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFF0,$0000
	dc	$FFFF,$FFFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$F000
	dc	$FFF0,$3FFC,$FFFF,$FFF8
	dc	$7FFF,$FFF8,$FFFF,$FFF8
	dc	$FFFF,$FFFC,$FFF0,$0000
	dc	$7FFF,$FFF8,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$E000
	dc	$FFF0,$3FFC,$FFFF,$FFF0
	dc	$3FFF,$FFF0,$FFFF,$FFF0
	dc	$FFFF,$FFFC,$FFF0,$0000
	dc	$3FFF,$FFF0,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$C000
	dc	$FFF0,$0FFC,$FFF0,$0000
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$3FFF,$FFF0,$FFFF,$FFF0
	dc	$3FFF,$FFF0,$FFFF,$FFF0
	dc	$3FFF,$FFF0,$FFFF,$FFFC
	dc	$FFF0,$1FFC,$FFF0,$0000
	dc	$FFF8,$7FFC,$FFF8,$3FFC
	dc	$7FFF,$FFF8,$FFFF,$FFF8
	dc	$7FFF,$FFF8,$FFFF,$FFF8
	dc	$7FFF,$FFF8,$FFFF,$FFFC
	dc	$FFF0,$3FF8,$FFF0,$0000
	dc	$FFFC,$FFFC,$FFFC,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF0,$7FF0,$FFF0,$0000
	dc	$FFFF,$FFFC,$FFFE,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF0,$FFE0,$FFF0,$0000
	dc	$FFFF,$FFFC,$FFFF,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF1,$FFC0,$FFF0,$0000
	dc	$FFFF,$FFFC,$FFFF,$BFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF3,$FF80,$FFF0,$0000
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF7,$FF00,$FFF0,$0000
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF0,$0000,$FFFF,$FFFC
	dc	$FFFF,$FE00,$FFF0,$0000
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$0000,$003F,$F000
	dc	$FFFF,$FC00,$FFF0,$0000
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFFF,$FFF0,$003F,$F000
	dc	$FFFF,$F800,$FFF0,$0000
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFFF,$FFF8,$003F,$F000
	dc	$FFFF,$F000,$FFF0,$0000
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$003F,$F000
	dc	$FFFF,$E000,$FFF0,$0000
	dc	$FFF7,$BFFC,$FFF7,$FFFC
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$003F,$F000
	dc	$FFFF,$F000,$FFF0,$0000
	dc	$FFF3,$3FFC,$FFF3,$FFFC
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$003F,$F000
	dc	$FFFF,$F800,$FFF0,$0000
	dc	$FFF0,$3FFC,$FFF1,$FFFC
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$7FFF,$FFFC,$003F,$F000
	dc	$FFFF,$FC00,$FFF0,$0000
	dc	$FFF0,$3FFC,$FFF0,$FFFC
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$0000,$3FFC,$003F,$F000
	dc	$FFF7,$FE00,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$7FFC
	dc	$FFFF,$FFFC,$FFFF,$FFF8
	dc	$FFFF,$FFFC,$FFFF,$FFF8
	dc	$0000,$3FFC,$003F,$F000
	dc	$FFF3,$FF00,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFF0
	dc	$FFFF,$FFFC,$FFFF,$FFF0
	dc	$FFFF,$FFFC,$003F,$F000
	dc	$FFF1,$FF80,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFF0,$0000
	dc	$FFFF,$FFFC,$FFF1,$FF80
	dc	$FFFF,$FFFC,$003F,$F000
	dc	$FFF0,$FFC0,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFF0,$0000
	dc	$FFFF,$FFFC,$FFF0,$FFC0
	dc	$FFFF,$FFFC,$003F,$F000
	dc	$FFF0,$7FE0,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFF0,$0000
	dc	$FFFF,$FFFC,$FFF0,$7FE0
	dc	$FFFF,$FFFC,$003F,$F000
	dc	$FFF0,$3FF0,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFF0,$0000
	dc	$FFFF,$FFFC,$FFF0,$3FF0
	dc	$FFFF,$FFFC,$003F,$F000
	dc	$FFF0,$1FF8,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$7FFF,$FFF8,$FFF0,$0000
	dc	$7FFF,$FFF8,$FFF0,$1FF8
	dc	$7FFF,$FFF8,$003F,$F000
	dc	$FFF0,$0FFC,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$3FFF,$FFF0,$FFF0,$0000
	dc	$3FFF,$FFF8,$FFF0,$0FFC
	dc	$3FFF,$FFF0,$003F,$F000
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$03FF,$FF00
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$07FF,$FF00
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0FFF,$FF00
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0FFF,$FF00
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0FFF,$FF00
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0FFF,$FF00
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0FFF,$FF00
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$3FFC,$FFF8,$7FFC
	dc	$FFF8,$7FFC,$FFFF,$FFF8
	dc	$FFFF,$FFFC,$0FFF,$FF00
	dc	$0000,$3FFC,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFF0
	dc	$FFF0,$3FFC,$0003,$FF00
	dc	$0000,$3FFC,$0000,$3FFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF0,$3FFC,$7FFF,$FFF8
	dc	$7FFF,$FFF8,$00FF,$FFE0
	dc	$FFF0,$3FFC,$0003,$FF00
	dc	$FFFF,$FFFC,$0000,$3FFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF3,$3FFC,$3FFF,$FFF0
	dc	$3FFF,$FFF0,$01FF,$FFC0
	dc	$FFF0,$3FFC,$0003,$FF00
	dc	$FFFF,$FFFC,$0000,$3FFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFF7,$BFFC,$1FFF,$FFE0
	dc	$1FFF,$FFE0,$03FF,$FF80
	dc	$FFF0,$3FFC,$0003,$FF00
	dc	$FFFF,$FFFC,$000F,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$1FFF,$FFE0
	dc	$0FFF,$FFC0,$07FF,$FF00
	dc	$FFF0,$3FFC,$0003,$FF00
	dc	$FFFF,$FFFC,$000F,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$3FFF,$FFF0
	dc	$07FF,$FF80,$0FFF,$FE00
	dc	$FFF0,$3FFC,$0003,$FF00
	dc	$FFFF,$FFFC,$000F,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$7FFF,$FFF8
	dc	$03FF,$FF00,$1FFF,$FC00
	dc	$FFF0,$3FFC,$0003,$FF00
	dc	$FFFF,$FFFC,$000F,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$01FF,$FE00,$3FFF,$FFFC
	dc	$FFF0,$3FFC,$0003,$FF00
	dc	$FFF0,$0000,$0000,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFF8,$7FFC
	dc	$00FF,$FC00,$7FFF,$FFFC
	dc	$FFFF,$FFFC,$0003,$FF00
	dc	$FFF0,$0000,$0000,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFF0,$3FFC
	dc	$007F,$F800,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0003,$FF00
	dc	$FFFF,$FFFC,$0000,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFF0,$3FFC
	dc	$003F,$F000,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0003,$FF00
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFF0,$3FFC
	dc	$003F,$F000,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0003,$FF00
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFF0,$3FFC
	dc	$003F,$F000,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0003,$FF00
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFC,$FFFC,$FFF0,$3FFC
	dc	$003F,$F000,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0003,$FF00
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$7FFF,$FFF8,$7FFF,$FFFC
	dc	$7FF8,$7FF8,$FFF0,$3FFC
	dc	$003F,$F000,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0003,$FF00
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$3FFF,$FFF0,$3FFF,$FFFC
	dc	$3FF0,$3FF0,$FFF0,$3FFC
	dc	$003F,$F000,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0003,$FF00
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$0000,$0000,$0000,$0000
	dc	$003F,$F000,$0000,$0000
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$0000,$0000,$0000,$0000
	dc	$003F,$F000,$0000,$0000
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$0000,$0000,$0000,$0000
	dc	$003F,$F000,$0000,$0000
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$0000,$0000,$0000,$0000
	dc	$003F,$F000,$0000,$0000
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$0000,$0000,$0000,$0000
	dc	$003F,$F000,$0000,$0000
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$0000,$0000,$0000,$0000
	dc	$003F,$F000,$0000,$0000
	dc	$FFF0,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$0000,$0000,$0000,$0000
	dc	$003F,$F000,$0000,$0000
	dc	$FFF0,$3FFC,$FFF0,$0000
	dc	$FFF0,$0000,$FFFF,$FFFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$0000,$0000,$0000,$0000
	dc	$003F,$F000,$003F,$F000
	dc	$FFF0,$3FFC,$FFF0,$0000
	dc	$FFF0,$0000,$0000,$3FFC
	dc	$FFF0,$3FFC,$FFF0,$3FFC
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$003F,$F000
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0000,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$003F,$F000
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0000,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$003F,$F000
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0000,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$003F,$F000
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0000,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$003F,$F000
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0000,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$003F,$F000
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0000,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$003F,$F000
	dc	$0000,$3FFC,$0000,$3FFC
	dc	$FFF0,$3FFC,$0000,$3FFC
	dc	$FFF0,$3FFC,$0000,$3FFC
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$3FFC,$0000,$3FFC
	dc	$FFF0,$3FFC,$0000,$3FFC
	dc	$FFF0,$3FFC,$0000,$3FFC
	dc	$003F,$F000,$003F,$F000
	dc	$0000,$0000,$003F,$F000
	dc	$0000,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0000,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$003F,$F000,$003F,$F000
	dc	$0000,$0000,$003F,$F000
	dc	$0000,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0000,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$003F,$F000,$003F,$F000
	dc	$0000,$0000,$003F,$F000
	dc	$0000,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0000,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$003F,$F000,$003F,$F000
	dc	$0000,$0000,$003F,$F000
	dc	$0000,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0000,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$003F,$F000,$003F,$F000
	dc	$0000,$0000,$003F,$F000
	dc	$0000,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0000,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$003F,$F000,$003F,$F000
	dc	$0000,$0000,$003F,$F000
	dc	$0000,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0000,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$003F,$F000,$003F,$E000
	dc	$0000,$0000,$003F,$F000
	dc	$0000,$3FFC,$FFFF,$FFFC
	dc	$FFFF,$FFFC,$0000,$3FFC
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$003F,$F000,$003F,$C000
	dc	$0000,$0000,$003F,$F000
	dc	$0000,$0000,$FFFF,$FFFC
	dc	$001F,$F800,$3FFF,$C000
	dc	$000F,$FFF0,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$FFFF,$FFFC
	dc	$001F,$F800,$7FFF,$C000
	dc	$000F,$FFF8,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$FFFF,$FFFC
	dc	$001F,$F800,$FFFF,$C000
	dc	$000F,$FFFC,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$FFFF,$FFFC
	dc	$001F,$F800,$FFFF,$C000
	dc	$000F,$FFFC,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$FFFF,$FFFC
	dc	$001F,$F800,$FFFF,$C000
	dc	$000F,$FFFC,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$FFFF,$FFFC
	dc	$001F,$F800,$FFFF,$C000
	dc	$000F,$FFFC,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$FFFF,$FFFC
	dc	$001F,$F800,$FFFF,$C000
	dc	$000F,$FFFC,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$3FFC
	dc	$001F,$F800,$FFFF,$C000
	dc	$000F,$FFFC,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$3FFC
	dc	$001F,$F800,$FFF0,$0000
	dc	$0000,$3FFC,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$001F,$F800,$FFF0,$0000
	dc	$0000,$3FFC,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$001F,$F800,$FFF0,$0000
	dc	$0000,$3FFC,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$001F,$F800,$FFF0,$0000
	dc	$0000,$3FFC,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$001F,$F800,$FFF0,$0000
	dc	$0000,$3FFC,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$001F,$F800,$FFF0,$0000
	dc	$0000,$3FFC,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$FFFF,$FFFC,$FFFF,$FFFC
	dc	$001F,$F800,$FFF0,$0000
	dc	$0000,$3FFC,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$FFF0,$0000
	dc	$001F,$F800,$FFF0,$0000
	dc	$0000,$3FFC,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$FFFF,$C000
	dc	$000F,$FFFC,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$FFF0,$0000
	dc	$001F,$F800,$FFFF,$C000
	dc	$000F,$FFFC,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$FFF0,$0000
	dc	$001F,$F800,$FFFF,$C000
	dc	$000F,$FFFC,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$FFF0,$0000
	dc	$001F,$F800,$FFFF,$C000
	dc	$000F,$FFFC,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$FFF0,$0000
	dc	$001F,$F800,$FFFF,$C000
	dc	$000F,$FFFC,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$FFF0,$0000
	dc	$001F,$F800,$FFFF,$C000
	dc	$000F,$FFFC,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$FFF0,$0000
	dc	$001F,$F800,$7FFF,$C000
	dc	$000F,$FFF8,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$FFF0,$0000
	dc	$001F,$F800,$3FFF,$C000
	dc	$000F,$FFF0,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
DATA_S3:
	dc.l	DATA_S1
DATA_S4:
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
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
DATA_S5:
	dc	$0000,$0000,$0000,$0000
PTR_TEXTE:
	dc.l	TEXTE
TEXTE:
	DC.B	'        '
	DC.B	'ABCDEFGHIJKLMNOPQRST'
  DC.B	'UVWXYZ 0123456789   '
	DC.B	'()!,-.:?',$27
	DC.B	'        '
	DC.B	$FF,$00
	even

IMG_LOGO:
		dc.w	$0001,$0002,$0003,$0003,$FDFE,$AA03,$3001,$C000
		dc.w	$4140,$A180,$61FF,$E1FF,$0000,$0001,$FFFD,$FFFD
		dc.w	$FEFF,$5501,$9800,$E000,$2005,$D006,$B007,$7007
		dc.w	$0014,$000C,$FFFC,$FFFC,$0001,$0000,$0000,$0000
		dc.w	$F001,$0001,$0001,$0001,$4000,$8000,$FFF8,$FFF8
		dc.w	$01FD,$02AA,$0330,$03C0,$FFFE,$0000,$0000,$0000
		dc.w	$2500,$2600,$27FF,$27FF,$0547,$054A,$FA8C,$FFCF
		dc.w	$F7FF,$A800,$C000,$0000,$F80A,$000C,$000F,$000F
		dc.w	$0005,$0045,$FFCA,$FFCF,$51FD,$52AA,$AB30,$FBC0
		dc.w	$FF20,$01D0,$00B0,$0070,$0630,$0000,$0000,$0630
		dc.w	$0200,$0200,$0200,$0200,$5555,$64AA,$7900,$7E00
		dc.w	$A033,$3023,$903C,$703F,$FFFC,$FFFC,$0000,$FFFC
		dc.w	$2AAA,$3255,$3C80,$3F00,$D000,$1800,$4800,$3800
		dc.w	$CFF4,$8FF2,$F00E,$FFFE,$0000,$0001,$0000,$0000
		dc.w	$A000,$5000,$0000,$0000,$33F8,$23F8,$3C00,$3FF8
		dc.w	$0055,$0064,$0079,$007E,$5554,$AAAA,$0000,$0000
		dc.w	$70CF,$508F,$70F0,$70FF,$FFC1,$FFC1,$0001,$FFC1
		dc.w	$5555,$92AA,$E400,$F800,$5001,$A801,$0001,$0001
		dc.w	$9FEF,$1FCF,$E020,$FFEF,$F855,$F864,$0079,$F87E
		dc.w	$52D0,$AD18,$0048,$0038,$0000,$0000,$0000,$0770
		dc.w	$0700,$0500,$0700,$0700,$07E2,$051D,$0640,$0780
		dc.w	$080D,$F009,$280E,$180F,$FFFC,$FFFC,$0000,$FFFC
		dc.w	$03F1,$028E,$0320,$03C0,$0400,$F880,$1480,$0C80
		dc.w	$37FC,$27FD,$3803,$3FFF,$0000,$0001,$0000,$0000
		dc.w	$0000,$F000,$0000,$0000,$0DF8,$09F8,$0E00,$0FF8
		dc.w	$0007,$0005,$0006,$0007,$E020,$1FDE,$4000,$8000
		dc.w	$2037,$2027,$2038,$203F,$FFC0,$FFC0,$0000,$FFC0
		dc.w	$1F80,$147F,$1900,$1E00,$8000,$7800,$0000,$0000
		dc.w	$6FFF,$4FEF,$7010,$7FFF,$F807,$F805,$0006,$F807
		dc.w	$E004,$1FF8,$4014,$800C,$07F0,$07F0,$07F0,$0000
		dc.w	$0200,$0200,$0200,$0200,$01F4,$017B,$01A0,$01C0
		dc.w	$5C00,$A002,$1403,$0C03,$FB7C,$FFFC,$0000,$FFFC
		dc.w	$00FA,$00BD,$00D0,$00E0,$2E02,$D002,$0A02,$0602
		dc.w	$03EE,$0BFE,$0C01,$0FFF,$0000,$8000,$8000,$8000
		dc.w	$0000,$0000,$0000,$0000,$00F8,$02F8,$0300,$03F8
		dc.w	$0001,$0001,$0001,$0001,$F444,$7BBA,$A000,$C000
		dc.w	$0003,$000B,$000C,$000F,$DFC0,$FFC0,$0000,$FFC0
		dc.w	$07D1,$05EE,$0680,$0700,$1000,$E800,$0000,$0000
		dc.w	$077F,$17FF,$1800,$1FFF,$7801,$F801,$0001,$F801
		dc.w	$F22E,$7DD0,$A00A,$C006,$07F0,$0080,$07F0,$0080
		dc.w	$0000,$0000,$0000,$0000,$001C,$0007,$0028,$0030
		dc.w	$1C00,$E200,$0A00,$0600,$1200,$1F80,$0000,$1F80
		dc.w	$000E,$0003,$0014,$0018,$0E05,$F105,$0507,$0307
		dc.w	$0555,$05FF,$0600,$07FF,$4000,$4001,$C000,$C000
		dc.w	$0000,$F000,$0000,$0000,$0150,$0178,$0180,$01F8
		dc.w	$0100,$0100,$0100,$0100,$1000,$0FFE,$2800,$3000
		dc.w	$0005,$0005,$0006,$0007,$AA80,$FFC0,$0000,$FFC0
		dc.w	$0040,$003F,$00A0,$00C0,$0000,$F800,$0000,$0000
		dc.w	$0AAA,$0BFF,$0C00,$0FFF,$A800,$F800,$0000,$F800
		dc.w	$180E,$07F1,$2805,$3003,$0100,$0100,$0100,$0100
		dc.w	$0000,$0000,$0000,$0000,$001C,$000D,$0016,$0018
		dc.w	$B400,$EB00,$0500,$0300,$1680,$0900,$0000,$1F80
		dc.w	$000E,$0006,$000B,$000C,$5A02,$F582,$0282,$0182
		dc.w	$0100,$01FF,$0000,$01FF,$8001,$A001,$6000,$E000
		dc.w	$5040,$F040,$0040,$0040,$0040,$0078,$0000,$0078
		dc.w	$0380,$0380,$0280,$0380,$12AA,$0FFE,$1400,$1800
		dc.w	$0001,$0001,$0000,$0001,$0000,$FFC0,$0000,$FFC0
		dc.w	$104A,$103F,$1050,$1060,$A800,$F800,$0000,$0000
		dc.w	$0200,$03FF,$0000,$03FF,$0000,$F800,$0000,$F800
		dc.w	$0552,$17FD,$1C02,$1801,$05E0,$8140,$8190,$8602
		dc.w	$0000,$0000,$0000,$0000,$207F,$207F,$2000,$2000
		dc.w	$FB80,$FD84,$0284,$0184,$0900,$1680,$0000,$1F80
		dc.w	$003F,$003F,$0000,$0000,$FDC0,$FEC0,$0140,$00C0
		dc.w	$02AA,$0355,$0000,$03FF,$D001,$5001,$3000,$F000
		dc.w	$F0A0,$F0A0,$00E0,$00E0,$0048,$0070,$0000,$0078
		dc.w	$0100,$0100,$0100,$0100,$3FFE,$3FFE,$0000,$0000
		dc.w	$0005,$0004,$0006,$0007,$B540,$4A84,$0004,$FFC4
		dc.w	$00FF,$00FF,$0000,$0000,$F820,$F821,$0021,$0021
		dc.w	$0555,$06AA,$0000,$07FF,$5000,$A800,$0000,$F800
		dc.w	$3FFD,$3FFE,$0001,$0000,$C5E2,$C140,$4190,$C605
		dc.w	$0000,$0000,$0000,$0000,$703F,$507F,$7000,$7000
		dc.w	$BF00,$FF00,$0180,$0080,$1F80,$0000,$0000,$1F80
		dc.w	$001F,$003F,$0000,$0000,$DF80,$FF80,$00C0,$0040
		dc.w	$0A55,$09AA,$0C00,$0FFF,$7081,$A081,$1080,$F080
		dc.w	$7040,$F040,$0040,$0040,$0150,$0128,$0180,$01F8
		dc.w	$0000,$0000,$0000,$0000,$3BFA,$3FFE,$0000,$0000
		dc.w	$0002,$0001,$0004,$0007,$4A80,$B540,$0000,$FFC0
		dc.w	$00EF,$00FF,$0000,$0000,$E800,$F800,$0000,$0000
		dc.w	$14AA,$1355,$1800,$1FFF,$A800,$5000,$0000,$F800
		dc.w	$3DFD,$3FFF,$0000,$0000,$85E0,$8140,$C190,$4602
		dc.w	$0000,$0000,$0000,$0000,$207E,$207E,$2000,$2001
		dc.w	$FF80,$FE40,$0140,$00C0,$1F80,$0000,$0000,$1F80
		dc.w	$003F,$003F,$0000,$0000,$7FC0,$7F20,$00A0,$8060
		dc.w	$05BB,$0244,$0800,$0FFF,$A141,$4141,$11C0,$F1C0
		dc.w	$F000,$F000,$0000,$0000,$00A8,$0050,$0100,$01F8
		dc.w	$0000,$0000,$0000,$0000,$3FFE,$3FFE,$0000,$0000
		dc.w	$0007,$0000,$0000,$0007,$F740,$0880,$0000,$FFC0
		dc.w	$00FF,$00FF,$0000,$0000,$F800,$F800,$0000,$0000
		dc.w	$0BED,$0432,$1040,$1FFF,$D820,$2020,$0020,$F820
		dc.w	$3FFF,$3FFF,$0000,$0000,$C000,$2000,$A000,$6000
		dc.w	$0100,$0100,$0100,$0100,$0014,$0014,$006B,$0001
		dc.w	$D520,$D4A0,$ABE0,$0060,$0900,$0000,$0000,$1F80
		dc.w	$020A,$020A,$0235,$0200,$6A90,$6A50,$D5F0,$8030
		dc.w	$03FF,$0C10,$0020,$0FFF,$F080,$1080,$0081,$F080
		dc.w	$A000,$A000,$5000,$0000,$7078,$5180,$7000,$71F8
		dc.w	$0000,$0000,$0000,$0000,$1500,$1500,$2A00,$0000
		dc.w	$0007,$0000,$0000,$0007,$E000,$0000,$0000,$E000
		dc.w	$0054,$0054,$00A8,$0000,$0000,$0000,$0000,$0000
		dc.w	$07BF,$1810,$0020,$1FBF,$F850,$0050,$0070,$F870
		dc.w	$0A6A,$0A6A,$3515,$0080,$93F0,$5000,$F000,$33F0
		dc.w	$0380,$0380,$0280,$0380,$0000,$0000,$007E,$0000
		dc.w	$00C0,$4020,$FFA0,$8060,$1204,$0004,$0004,$1F84
		dc.w	$0000,$0000,$003F,$0000,$0060,$2010,$7FD0,$4030
		dc.w	$075D,$0800,$0010,$0FDF,$4000,$1000,$0001,$F000
		dc.w	$0000,$0000,$F000,$0000,$70F0,$0100,$5000,$71F8
		dc.w	$0000,$0080,$0080,$0080,$0000,$0000,$3F00,$0000
		dc.w	$0002,$0000,$0000,$0007,$4000,$0000,$0000,$E000
		dc.w	$4000,$4000,$40FC,$4000,$0000,$0000,$0000,$0000
		dc.w	$0E9A,$1000,$0010,$1F9F,$A820,$0020,$0020,$F820
		dc.w	$0060,$0060,$3FDF,$0080,$6000,$1000,$D000,$3780
		dc.w	$0100,$0100,$0100,$0100,$0080,$0000,$00FE,$0080
		dc.w	$00E0,$0040,$7FE0,$4020,$200A,$200A,$200E,$3F8E
		dc.w	$0040,$0000,$007F,$0040,$0070,$0020,$3FF0,$2010
		dc.w	$0508,$0800,$0008,$0FCF,$3002,$1000,$0003,$F002
		dc.w	$0000,$0000,$F000,$0000,$70A0,$5100,$7000,$71F8
		dc.w	$0000,$0000,$0000,$0000,$4000,$0000,$7F00,$4000
		dc.w	$0004,$0000,$0000,$0007,$8000,$0000,$0000,$E000
		dc.w	$A100,$A000,$E1FC,$E100,$0000,$0000,$0000,$0000
		dc.w	$0B01,$1000,$0000,$1F8F,$0000,$0000,$0000,$F800
		dc.w	$4000,$0020,$7F7F,$4040,$77F0,$27F0,$F7F0,$1000
		dc.w	$0000,$0000,$0000,$0000,$0080,$0180,$01FE,$0100
		dc.w	$00A0,$0060,$3FC0,$0020,$6004,$6004,$4004,$7F84
		dc.w	$0040,$00C0,$00FF,$0080,$0050,$0030,$1FE0,$0010
		dc.w	$1200,$1800,$1000,$1FC7,$7002,$2006,$1007,$F004
		dc.w	$0000,$0000,$F000,$0000,$0240,$0300,$0200,$03F8
		dc.w	$0000,$0000,$0000,$0000,$4000,$C000,$FF00,$8000
		dc.w	$0009,$0209,$0209,$020E,$2000,$2000,$2000,$C000
		dc.w	$4100,$4300,$43FC,$4200,$0000,$0000,$0000,$0000
		dc.w	$2400,$3000,$2000,$3F8F,$4000,$4000,$4000,$B800
		dc.w	$4000,$C000,$FF3F,$8020,$5030,$3000,$E030,$1000
		dc.w	$0038,$0028,$0038,$0038,$002A,$0200,$02FF,$0300
		dc.w	$AAE0,$0000,$FFC0,$0020,$F680,$D680,$9680,$E900
		dc.w	$0015,$0100,$017F,$0180,$5570,$0000,$FFE0,$0010
		dc.w	$3404,$3004,$2004,$3FFB,$D001,$5008,$300B,$F00C
		dc.w	$5000,$0000,$F000,$0000,$0690,$0610,$0410,$07E8
		dc.w	$0000,$0001,$0001,$0001,$2AA0,$0000,$7FE0,$8000
		dc.w	$0018,$0018,$0010,$001F,$0008,$0008,$0008,$E7F7
		dc.w	$00AA,$0400,$05FF,$0600,$8000,$0080,$8080,$0080
		dc.w	$6800,$6000,$4000,$7F8F,$2000,$2001,$2001,$D801
		dc.w	$1515,$0000,$7F1F,$8000,$77F0,$07F0,$E000,$1000
		dc.w	$0038,$0000,$0028,$0038,$01FF,$0400,$05FF,$0600
		dc.w	$FFE1,$0021,$FFE1,$0001,$9F80,$9F80,$1F80,$E000
		dc.w	$00FF,$0200,$02FF,$0300,$FFF0,$0010,$FFF0,$0000
		dc.w	$70AB,$60AA,$40AA,$7F55,$8007,$0010,$8017,$8018
		dc.w	$F000,$0000,$F000,$0000,$0E08,$0C08,$0808,$0FF0
		dc.w	$0000,$0002,$0002,$0003,$FFE0,$0000,$FFE0,$0000
		dc.w	$003D,$003D,$002D,$0032,$A555,$A555,$A555,$42AA
		dc.w	$03FF,$0800,$0BFF,$0C00,$8000,$0000,$8000,$0000
		dc.w	$E105,$C105,$8105,$FE8A,$5000,$5002,$5002,$A803
		dc.w	$FF1F,$0000,$FF1F,$0000,$F000,$1000,$F000,$0000
		dc.w	$0038,$0228,$0238,$0238,$03FD,$0802,$0BFF,$0C00
		dc.w	$FDC2,$0223,$FFE2,$0003,$6900,$7F80,$7F80,$8000
		dc.w	$01FE,$0401,$05FF,$0600,$FEE0,$0110,$FFF0,$0000
		dc.w	$CAFF,$CAFF,$8AFF,$F500,$100B,$5024,$302F,$F030
		dc.w	$F000,$0000,$F000,$0000,$1958,$1958,$1158,$1EA0
		dc.w	$0001,$0004,$0005,$0006,$DFC0,$2020,$FFE0,$0000
		dc.w	$007F,$007F,$005F,$0060,$E7FF,$E7FF,$E7FF,$0000
		dc.w	$077F,$1080,$17FF,$1800,$0001,$8001,$8001,$0001
		dc.w	$958F,$958F,$158F,$EA00,$F801,$F804,$F805,$0006
		dc.w	$EF0F,$1010,$FF1F,$0000,$E7F0,$1000,$F000,$07F0
		dc.w	$0000,$0000,$0000,$0000,$06FE,$1100,$17FE,$1800
		dc.w	$3EC5,$0127,$3FE5,$0006,$B680,$FF80,$FF80,$0000
		dc.w	$037F,$0880,$0BFF,$0C00,$1F61,$0091,$1FF1,$0001
		dc.w	$3F45,$BFC7,$3FC7,$C000,$501D,$D842,$C85F,$3860
		dc.w	$F000,$0000,$F000,$0000,$27F0,$37F8,$27F8,$3800
		dc.w	$0003,$0008,$000B,$000C,$EF00,$1000,$FF00,$0000
		dc.w	$0092,$00FF,$00BF,$00C0,$402A,$E07F,$E07F,$0000
		dc.w	$0FBC,$2040,$2FFC,$3000,$0002,$0003,$0002,$0003
		dc.w	$7E8A,$7F8F,$7F8F,$8000,$A803,$F808,$F80B,$000C
		dc.w	$F717,$0808,$FF1F,$0000,$E000,$1000,$F000,$01C0
		dc.w	$0000,$0000,$0000,$0000,$0D54,$02AA,$0FFE,$1000
		dc.w	$1563,$2A87,$3FE3,$0004,$4900,$FF80,$FF80,$0000
		dc.w	$06AA,$0155,$07FF,$0800,$0AB2,$1543,$1FF2,$0003
		dc.w	$D582,$FFC7,$FFC7,$0000,$A82A,$EC95,$E4BF,$1CC0
		dc.w	$A000,$5020,$F020,$0020,$5AAA,$7FFF,$5FFF,$6000
		dc.w	$AA85,$FFC2,$FFC7,$0008,$5555,$AAAA,$FFFF,$0000
		dc.w	$5124,$A9FF,$F97F,$0180,$8055,$E07F,$E07F,$0000
		dc.w	$1555,$0AAA,$1FFF,$2000,$5545,$AAA7,$FFE5,$0006
		dc.w	$AB05,$FF8F,$FF8F,$0000,$5006,$F801,$F807,$0008
		dc.w	$AA0A,$5515,$FF1F,$0000,$B1C0,$41C0,$F1C0,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$1FFE,$1FFE,$0000
		dc.w	$0002,$3FE7,$3FE7,$0000,$2000,$FF80,$FF80,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$0001,$1FF3,$1FF1,$0002
		dc.w	$AA01,$FFC7,$FFC7,$0000,$1400,$F47F,$F07F,$0C80
		dc.w	$0000,$F000,$F000,$0000,$3544,$7FFF,$3FFF,$4000
		dc.w	$4440,$FFCF,$FFCF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0092,$F9FF,$F8FF,$0100,$4222,$FFFF,$FFFF,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$0003,$FFE7,$FFE3,$0004
		dc.w	$5488,$FF8F,$FF8F,$0000,$8800,$F80F,$F80F,$0000
		dc.w	$0000,$FF1F,$FF1F,$0000,$01C0,$F000,$F1C0,$0000
		dc.w	$0000,$0000,$0000,$0000,$0222,$1FFE,$1FFE,$0000
		dc.w	$2200,$3FE7,$3FE7,$0000,$0000,$FF80,$FF80,$0000
		dc.w	$0111,$0FFF,$0FFF,$0000,$1101,$1FF3,$1FF3,$0000
		dc.w	$1100,$FFC7,$FFC7,$0000,$0444,$F8FF,$F8FF,$0400
		dc.w	$4000,$F000,$F000,$0000,$2220,$7FFF,$7FFF,$0000
		dc.w	$0002,$FFCF,$FFCF,$0000,$2222,$FFFF,$FFFF,$0000
		dc.w	$2000,$F9FF,$F9FF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0888,$3FFF,$3FFF,$0000,$8882,$FFE7,$FFE7,$0000
		dc.w	$2200,$FF8F,$FF8F,$0000,$0001,$F80F,$F80F,$0000
		dc.w	$1111,$FF1F,$FF1F,$0000,$1000,$F000,$F000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1110,$1FFE,$1FFE,$0000
		dc.w	$1105,$3FE2,$3FE7,$0000,$5500,$AA80,$FF80,$0000
		dc.w	$0888,$0FFF,$0FFF,$0000,$0880,$1FF3,$1FF3,$0000
		dc.w	$0082,$FF45,$FFC7,$0000,$AC22,$54FF,$FCFF,$0000
		dc.w	$2000,$F000,$F000,$0000,$000A,$7FF5,$7FFF,$0000
		dc.w	$AA81,$554F,$FFCF,$0000,$1111,$FFFF,$FFFF,$0000
		dc.w	$1155,$F8AA,$F9FF,$0000,$5555,$AAAA,$FFFF,$0000
		dc.w	$0444,$3FFF,$3FFF,$0000,$4440,$FFE7,$FFE7,$0000
		dc.w	$0105,$FE8A,$FF8F,$0000,$5008,$A80F,$F80F,$0000
		dc.w	$8808,$FF1F,$FF1F,$0000,$83F0,$F000,$F000,$03F0
		dc.w	$0000,$0000,$0000,$0000,$0AAA,$1FFE,$1FFE,$0000
		dc.w	$2AA7,$3FE0,$3FE7,$0000,$FF80,$0000,$FF80,$0000
		dc.w	$0555,$0FFF,$0FFF,$0000,$1552,$1FF1,$1FF3,$0000
		dc.w	$AAC7,$5500,$FFC7,$0000,$F855,$04FF,$FCFF,$0000
		dc.w	$5000,$F000,$F000,$0000,$555F,$2AA0,$7FFF,$0000
		dc.w	$FFCA,$000F,$FFCF,$0000,$AAAA,$FFFF,$FFFF,$0000
		dc.w	$A9FF,$F800,$F9FF,$0000,$FFFF,$0000,$FFFF,$0000
		dc.w	$2AAA,$3FFF,$3FFF,$0000,$AAA5,$FFE2,$FFE7,$0000
		dc.w	$558F,$AA00,$FF8F,$0000,$F805,$000F,$F80F,$0000
		dc.w	$5515,$FF1F,$FF1F,$0000,$5000,$F000,$F000,$07C0
		dc.w	$0010,$0010,$0010,$0010,$1FFE,$1FFE,$1FFE,$0000
		dc.w	$3FE7,$3FE0,$3FE7,$0000,$BF80,$0000,$FF80,$0000
		dc.w	$0FFF,$0FFF,$0FFF,$0000,$1FF3,$1FF0,$1FF3,$0000
		dc.w	$FFC5,$0000,$FFC7,$0000,$F8FF,$04FF,$FCFF,$0000
		dc.w	$F000,$F000,$F000,$0000,$7FF7,$0000,$7FFF,$0000
		dc.w	$F7CF,$000F,$FFCF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$F9FB,$F800,$F9FF,$0000,$FBFB,$0000,$FFFF,$0000
		dc.w	$3FFF,$3FFF,$3FFF,$0000,$FFE7,$FFE0,$FFE7,$0000
		dc.w	$FF8F,$0000,$FF8F,$0000,$E80F,$000F,$F80F,$0000
		dc.w	$FF1F,$FF1F,$FF1F,$0000,$F700,$F700,$F700,$0000
		dc.w	$0028,$0028,$0038,$0038,$1DDC,$1DDC,$1DDC,$0222
		dc.w	$1DC5,$1DC0,$1DC7,$2220,$DD80,$0000,$FF80,$0000
		dc.w	$0EEE,$0EEE,$0EEE,$0111,$0EE3,$0EE0,$0EE3,$1110
		dc.w	$DFC6,$0000,$FFC7,$0000,$E8BB,$04BB,$FCBB,$0044
		dc.w	$B008,$B008,$B008,$4008,$7BFB,$0000,$7FFF,$0000
		dc.w	$BB8D,$000D,$FFCD,$0002,$DDDD,$DDDD,$DDDD,$2222
		dc.w	$D9DD,$D800,$D9FF,$2000,$DDDD,$0000,$FFFF,$0000
		dc.w	$3777,$3777,$3777,$0888,$7767,$7760,$7767,$8880
		dc.w	$BF07,$0000,$FF8F,$0000,$700E,$000E,$F80E,$0001
		dc.w	$EE0E,$EE0E,$EE0E,$1111,$E3F0,$E000,$E3F0,$1000
		dc.w	$0010,$0010,$0010,$0010,$0EEE,$0EEE,$0EEE,$1110
		dc.w	$2EE2,$2EE0,$2EE7,$1100,$AA80,$0000,$FF80,$0000
		dc.w	$0777,$0777,$0777,$0888,$1772,$1770,$1773,$0880
		dc.w	$EE45,$0000,$FFC7,$0000,$50DD,$04DD,$FCDD,$0022
		dc.w	$D014,$D014,$D01C,$201C,$5DD5,$0000,$7FFF,$0000
		dc.w	$554E,$000E,$FFCE,$0001,$EEEE,$EEEE,$EEEE,$1111
		dc.w	$E8AA,$E800,$E9FF,$1000,$AAAA,$0000,$FFFF,$0000
		dc.w	$3BBB,$3BBB,$3BBB,$0444,$BBA5,$BBA0,$BBA7,$4440
		dc.w	$DC8A,$0000,$FF8F,$0000,$A807,$0007,$F807,$0008
		dc.w	$7717,$7717,$7717,$8808,$7000,$7000,$7000,$8000
		dc.w	$0000,$0000,$0000,$0000,$1554,$1554,$1554,$0AAA
		dc.w	$1540,$1540,$1547,$2AA0,$0000,$0000,$FF80,$0000
		dc.w	$0AAA,$0AAA,$0AAA,$0555,$0AA1,$0AA0,$0AA3,$1550
		dc.w	$5500,$0000,$FFC7,$0000,$04AA,$00AA,$FCAA,$0055
		dc.w	$A008,$A008,$A008,$5008,$2AA0,$0000,$7FFF,$0000
		dc.w	$0005,$0005,$FFC5,$000A,$5555,$5555,$5555,$AAAA
		dc.w	$5000,$5000,$51FF,$A800,$0000,$0000,$FFFF,$0000
		dc.w	$1555,$1555,$1555,$2AAA,$5542,$5540,$5547,$AAA0
		dc.w	$AA00,$0000,$FF8F,$0000,$000A,$000A,$F80A,$0005
		dc.w	$AA0A,$AA0A,$AA0A,$5515,$A7F0,$A000,$A000,$57F0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$1FFE
		dc.w	$0005,$0005,$0002,$3FE0,$5500,$5500,$AA80,$0000
		dc.w	$0000,$0000,$0000,$0FFF,$0002,$0002,$0001,$1FF0
		dc.w	$AA82,$AA82,$5545,$0000,$A800,$A800,$5400,$00FF
		dc.w	$0000,$0000,$0000,$F000,$2AAA,$2AAA,$5555,$0000
		dc.w	$AA80,$AA80,$5540,$000F,$0000,$0000,$0000,$FFFF
		dc.w	$0155,$0155,$00AA,$F800,$5555,$5555,$AAAA,$0000
		dc.w	$0000,$0000,$0000,$3FFF,$0005,$0005,$0002,$FFE0
		dc.w	$5505,$5505,$AA8A,$0000,$5000,$5000,$A800,$000F
		dc.w	$0000,$0000,$0000,$FF1F,$0000,$0000,$0000,$F738
		dc.w	$0000,$0000,$0000,$0000,$0222,$0000,$0000,$1FFE
		dc.w	$2223,$0003,$0004,$3FE0,$BB80,$BB80,$4400,$0000
		dc.w	$0111,$0000,$0000,$0FFF,$1111,$0001,$0002,$1FF0
		dc.w	$DDC5,$DDC5,$2202,$0000,$DC44,$DC00,$2000,$00FF
		dc.w	$4000,$0000,$0000,$F000,$7777,$7777,$0888,$0000
		dc.w	$7742,$7740,$8880,$000F,$2222,$0000,$0000,$FFFF
		dc.w	$21BB,$01BB,$0044,$F800,$BBBB,$BBBB,$4444,$0000
		dc.w	$0888,$0000,$0000,$3FFF,$8886,$0006,$0001,$FFE0
		dc.w	$EE8E,$EE8E,$1101,$0000,$E801,$E800,$1000,$000F
		dc.w	$1111,$0000,$0000,$FF1F,$17F0,$07F0,$07F0,$F000
		dc.w	$0000,$0000,$0000,$0000,$1110,$0000,$0000,$1FFE
		dc.w	$1107,$0007,$0000,$3FE0,$7700,$7700,$8880,$0000
		dc.w	$0888,$0000,$0000,$0FFF,$0883,$0003,$0000,$1FF0
		dc.w	$BB83,$BB83,$4444,$0000,$B882,$B800,$4400,$00FF
		dc.w	$2000,$0000,$0000,$F000,$6EEE,$6EEE,$1111,$0000
		dc.w	$EEC1,$EEC0,$1100,$000F,$1111,$0000,$0000,$FFFF
		dc.w	$1177,$0177,$0088,$F800,$7776,$7776,$8889,$0000
		dc.w	$0444,$0000,$0000,$3FFF,$4445,$0005,$0002,$FFE0
		dc.w	$DD8D,$DD8D,$2202,$0000,$D808,$D800,$2000,$000F
		dc.w	$8808,$0000,$0000,$FF1F,$1738,$0000,$0738,$F000
		dc.w	$0000,$0000,$0000,$0000,$0AAA,$0000,$0000,$1FFE
		dc.w	$2AA7,$0007,$0000,$3FE0,$FF80,$FF80,$0000,$0000
		dc.w	$0555,$0000,$0000,$0FFF,$1553,$0003,$0000,$1FF0
		dc.w	$FFC7,$FFC7,$0000,$0000,$FCD5,$FC80,$0000,$00FF
		dc.w	$5000,$0000,$0000,$F000,$7FFF,$7FFF,$0000,$0000
		dc.w	$FFCA,$FFC0,$0000,$000F,$AAAA,$0000,$0000,$FFFF
		dc.w	$A9FF,$01FF,$0000,$F800,$FFFE,$FFFF,$0001,$0000
		dc.w	$2AAA,$0000,$0000,$3FFF,$AAA7,$0007,$0000,$FFE0
		dc.w	$FF8F,$FF8F,$0000,$0000,$F80D,$F808,$0000,$000F
		dc.w	$5515,$0000,$0000,$FF1F,$B000,$1000,$0000,$F000
		dc.w	$0000,$0000,$0000,$0000,$1FFE,$0000,$0000,$1FFE
		dc.w	$3FE2,$0005,$0000,$3FE0,$AA80,$FF80,$0000,$0000
		dc.w	$0FFF,$0000,$0000,$0FFF,$1FF1,$0003,$0000,$1FF0
		dc.w	$5545,$FFC7,$0000,$0000,$543F,$FC40,$0080,$00FF
		dc.w	$F000,$0000,$0000,$F000,$5555,$7FFF,$0000,$0000
		dc.w	$554F,$FFC0,$0000,$000F,$FFFF,$0000,$0000,$FFFF
		dc.w	$F8AA,$01FF,$0000,$F800,$AAA8,$FFFD,$0002,$0001
		dc.w	$3FFF,$0000,$0000,$3FFF,$FFE2,$0007,$0000,$FFE0
		dc.w	$AA8A,$FF8F,$0000,$0000,$A803,$F804,$0008,$000F
		dc.w	$FF1F,$0000,$0000,$FF1F,$C3F0,$2000,$13F0,$F000
		dc.w	$0000,$0000,$0000,$0000,$1DDC,$0222,$0000,$1FFE
		dc.w	$1DC2,$2225,$0000,$3FE0,$0000,$FF80,$0000,$0000
		dc.w	$0EEE,$0111,$0000,$0FFF,$0EE0,$1113,$0000,$1FF0
		dc.w	$0000,$FFC7,$0000,$0000,$008B,$FCB4,$00C0,$00FF
		dc.w	$B000,$4000,$0000,$F000,$0000,$7FFF,$0000,$0000
		dc.w	$000D,$FFC2,$0000,$000F,$DDDD,$2222,$0000,$FFFF
		dc.w	$D800,$21FF,$0000,$F800,$0001,$FFF8,$0005,$0003
		dc.w	$3777,$0888,$0000,$3FFF,$7760,$8887,$0000,$FFE0
		dc.w	$0000,$FF8F,$0000,$0000,$0008,$F80B,$000C,$000F
		dc.w	$EEEE,$1111,$0000,$FFFF,$1738,$D708,$3738,$F000
		dc.w	$0000,$0000,$0000,$0000,$0EEE,$1110,$0000,$1FFE
		dc.w	$2EE3,$1104,$0000,$3FE0,$1100,$EE80,$0000,$0000
		dc.w	$0777,$0888,$0000,$0FFF,$1770,$0883,$0000,$1FF0
		dc.w	$8880,$7747,$0000,$0000,$887D,$7452,$0060,$007F
		dc.w	$C000,$2000,$0000,$E000,$2222,$5DDD,$0000,$0000
		dc.w	$220E,$DDC1,$0000,$000F,$EEEE,$1111,$0000,$FFFF
		dc.w	$E911,$10EE,$0000,$F800,$1104,$EEEE,$001A,$0006
		dc.w	$3BBB,$0444,$0000,$3FFF,$BBA4,$4443,$0000,$FFE0
		dc.w	$4404,$BB8B,$0000,$0000,$4007,$B805,$0006,$0007
		dc.w	$7777,$8888,$0000,$FFFF,$E000,$A000,$6000,$E7F8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0738,$0000,$0000,$0738
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
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$0001,$FFFE,$0000,$FFFF,$FFFF,$0000,$0000,$FFFF
		dc.w	$F802,$07FC,$0000,$FFFF,$C200,$91FF,$F000,$0FFF
		dc.w	$1FFF,$E000,$0000,$FFFF,$FF80,$007F,$0000,$FFFF
		dc.w	$0000,$FFFF,$0000,$FFFF,$00FF,$FF00,$0000,$FFFF
		dc.w	$FFFC,$0003,$0000,$FFFF,$018F,$FE0F,$000F,$FFF0
		dc.w	$2A71,$C9F0,$F7F0,$000F,$0000,$FFFF,$0000,$FFFF
		dc.w	$0000,$FFFF,$0000,$FFFF,$0000,$FFFF,$0000,$FFFF
		dc.w	$0000,$FFFF,$0000,$FFFF,$FFFF,$0000,$0000,$FFFF
		dc.w	$FC00,$03FF,$0000,$FFFF,$0000,$FFFF,$0000,$FFFF
		dc.w	$1FFF,$E000,$0000,$FFFF,$FF80,$007F,$0000,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF

LOGO_DIST:
		dc.w	$0000,$0001,$0000,$0000,$0804,$F8FC,$0000,$0000
		dc.w	$3060,$BFE8,$E038,$0000,$3060,$BFE8,$E038,$0000
		dc.w	$3060,$BFE9,$E038,$0000,$0000,$FDFC,$0000,$0000
		dc.w	$0000,$003F,$0000,$0000,$0C06,$FD17,$071C,$0000
		dc.w	$009F,$FFBF,$0000,$0000,$0F80,$1F80,$0000,$0000
		dc.w	$0000,$07F7,$0000,$0000,$00C0,$F2FF,$0380,$0000
		dc.w	$10C1,$F2FF,$0380,$0000,$8001,$A7FF,$E000,$0000
		dc.w	$8000,$A000,$E000,$0000,$C006,$7FFC,$C006,$0000
		dc.w	$1830,$5FF4,$701C,$0000,$1830,$5FF4,$701C,$0000
		dc.w	$0010,$FFF4,$001C,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$F87C,$0885,$0001,$0000
		dc.w	$FFF8,$4015,$800D,$0000,$FFF8,$4C15,$800D,$0000
		dc.w	$FFF8,$4C15,$800C,$0000,$FCFC,$0504,$0000,$0000
		dc.w	$001F,$0020,$0000,$0000,$FF1F,$02A8,$01B0,$0000
		dc.w	$FF9F,$00A1,$0080,$0000,$0F80,$1080,$0000,$0000
		dc.w	$03F3,$0414,$0000,$0000,$F3FF,$1500,$0600,$0000
		dc.w	$F3FF,$1500,$1600,$0000,$E3FF,$5430,$3000,$0000
		dc.w	$E000,$5000,$3000,$0000,$FFFE,$8002,$8002,$0000
		dc.w	$7FFC,$A00A,$C006,$0000,$7FFC,$A00A,$C006,$0000
		dc.w	$7FFC,$800A,$0006,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$F87C,$0884,$0001,$0000
		dc.w	$FFF8,$8008,$0005,$0000,$FFF8,$9E08,$0005,$0000
		dc.w	$FFF8,$9E09,$0004,$0000,$FCFC,$0504,$0000,$0000
		dc.w	$001F,$0020,$0000,$0000,$FF1F,$0110,$00A0,$0000
		dc.w	$FF9F,$00A1,$0080,$0000,$0F80,$1080,$0000,$0000
		dc.w	$03F3,$0414,$0000,$0000,$F3FF,$1200,$0400,$0000
		dc.w	$F3FF,$1200,$1400,$0000,$E3FF,$2478,$1000,$0000
		dc.w	$E000,$2000,$1000,$0000,$7FFE,$8002,$0000,$0000
		dc.w	$7FFC,$4004,$8002,$0000,$7FFC,$4004,$8002,$0000
		dc.w	$7FFC,$8184,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$F87D,$0884,$0001,$0000
		dc.w	$FFFD,$0600,$0005,$0000,$FFFD,$1E00,$0005,$0000
		dc.w	$FFFC,$1E01,$0004,$0000,$FCFC,$0504,$0000,$0000
		dc.w	$001F,$0026,$0000,$0000,$FFBF,$0000,$00A0,$0000
		dc.w	$FF9F,$00A1,$0080,$0000,$0F80,$1080,$0000,$0000
		dc.w	$03F3,$0414,$0000,$0000,$F7FF,$1000,$0400,$0000
		dc.w	$F7FF,$1018,$1400,$0000,$F3FF,$0478,$1000,$0000
		dc.w	$F000,$0000,$1000,$0000,$7FFE,$8062,$0000,$0000
		dc.w	$FFFE,$0000,$8002,$0000,$FFFE,$0000,$8002,$0000
		dc.w	$7FFE,$83C0,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$F87D,$0885,$0001,$0000
		dc.w	$FFFD,$0F05,$0005,$0000,$FFFD,$0C05,$0005,$0000
		dc.w	$FFFC,$0C05,$0004,$0000,$FCFC,$0504,$0000,$0000
		dc.w	$001F,$002F,$0000,$0000,$FFBF,$00A0,$00A0,$0000
		dc.w	$FF9F,$00A1,$0080,$0000,$0F80,$1080,$0000,$0000
		dc.w	$03F3,$0414,$0000,$0000,$F7FF,$1400,$0400,$0000
		dc.w	$F7FF,$143C,$1400,$0000,$F3FF,$1430,$1000,$0000
		dc.w	$F000,$1000,$1000,$0000,$7FFE,$80F2,$0000,$0000
		dc.w	$FFFE,$8002,$8002,$0000,$FFFE,$8002,$8002,$0000
		dc.w	$7FFE,$83CE,$0002,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$F87D,$0885,$0000,$0000
		dc.w	$FFFD,$0605,$0000,$0000,$FFFD,$01E5,$0004,$0000
		dc.w	$FFFC,$01E5,$0004,$0000,$FCFC,$0504,$0000,$0000
		dc.w	$001F,$002F,$0000,$0000,$FFBF,$00A0,$0000,$0000
		dc.w	$FF9F,$00A1,$0080,$0000,$0F80,$1080,$0000,$0000
		dc.w	$03F3,$0414,$0000,$0000,$F7FF,$1400,$0000,$0000
		dc.w	$F7FF,$1418,$1000,$0000,$F3FF,$1407,$0000,$0000
		dc.w	$F000,$9000,$1000,$0000,$7FFE,$80F2,$0000,$0000
		dc.w	$FFFE,$8002,$0000,$0000,$FFFE,$8002,$0000,$0000
		dc.w	$7FFE,$919E,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$F87C,$0885,$0000,$0000
		dc.w	$FFFC,$3805,$0000,$0000,$FFFC,$33F5,$0004,$0000
		dc.w	$FFFC,$33F5,$0004,$0000,$FCFC,$0504,$0000,$0000
		dc.w	$001F,$0026,$0000,$0000,$FFBF,$00A0,$0000,$0000
		dc.w	$FF9F,$00A1,$0080,$0000,$0F80,$1080,$0000,$0000
		dc.w	$03F3,$0414,$0000,$0000,$F7FF,$1400,$0000,$0000
		dc.w	$F3FF,$14E0,$1000,$0000,$F3FF,$14CF,$0000,$0000
		dc.w	$F000,$D000,$1000,$0000,$7FFE,$8C62,$0000,$0000
		dc.w	$7FFC,$8302,$0000,$0000,$7FFC,$8302,$0000,$0000
		dc.w	$7FFE,$B81E,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$F87C,$0885,$0000,$0000
		dc.w	$FFFC,$7D85,$0000,$0000,$FFFC,$7BF5,$0004,$0000
		dc.w	$FFFC,$7BF5,$0004,$0000,$FCFC,$0504,$0000,$0000
		dc.w	$001F,$0020,$0000,$0000,$FFBF,$F0A0,$0000,$0000
		dc.w	$FF9F,$00A1,$0080,$0000,$0F80,$1080,$0000,$0000
		dc.w	$03F3,$0414,$0000,$0000,$F7FF,$1400,$0000,$0000
		dc.w	$F3FF,$15F6,$1000,$0000,$F3FF,$15EF,$0000,$0000
		dc.w	$F000,$D000,$1000,$0000,$7DFE,$8F82,$0000,$0000
		dc.w	$7FFC,$8782,$0000,$0000,$7FFC,$8782,$0000,$0000
		dc.w	$7FFE,$FFCE,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$F87C,$0885,$0000,$0000
		dc.w	$FFFC,$7D85,$0000,$0000,$FFFC,$7BF5,$0004,$0000
		dc.w	$FFFC,$7BF5,$0004,$0000,$FCFC,$0504,$0000,$0000
		dc.w	$001F,$0039,$0000,$0000,$FFBF,$F8A0,$0000,$0000
		dc.w	$FF9F,$00A1,$0080,$0000,$0F80,$1080,$0000,$0000
		dc.w	$03F3,$0414,$0000,$0000,$F7FF,$1400,$0000,$0000
		dc.w	$F3FF,$15F6,$1000,$0000,$F3FF,$15EF,$0000,$0000
		dc.w	$F000,$D000,$1000,$0000,$7CFE,$84F2,$0000,$0000
		dc.w	$7FFC,$8782,$0000,$0000,$7FFC,$8782,$0000,$0000
		dc.w	$03FE,$01E2,$0700,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$F87C,$0885,$0000,$0000
		dc.w	$FFFC,$7C05,$0000,$0000,$FFFC,$33F5,$0004,$0000
		dc.w	$FFFC,$33F5,$0004,$0000,$FCFC,$0504,$0000,$0000
		dc.w	$003F,$003D,$0000,$0000,$FFBF,$F8A0,$0000,$0000
		dc.w	$FF9F,$00A1,$0080,$0000,$0F80,$1080,$0000,$0000
		dc.w	$03F3,$0414,$0000,$0000,$F7FF,$1400,$0000,$0000
		dc.w	$F3FF,$15F0,$1000,$0000,$F3FF,$14CF,$0000,$0000
		dc.w	$F000,$D000,$1000,$0000,$7CFE,$87FA,$0300,$0000
		dc.w	$7FFC,$8302,$0000,$0000,$7FFC,$8302,$0000,$0000
		dc.w	$00FE,$00E2,$0180,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$F87D,$0884,$0000,$0000
		dc.w	$FAFC,$7F05,$0000,$0000,$FFFC,$01E5,$0004,$0000
		dc.w	$FFFC,$01E5,$0004,$0000,$FCFC,$0504,$0000,$0000
		dc.w	$003F,$003D,$0000,$0000,$FFBF,$F8A0,$0000,$0000
		dc.w	$FF9F,$00A1,$0080,$0000,$0F80,$1080,$0000,$0000
		dc.w	$03F3,$0414,$0000,$0000,$F7FF,$1400,$0000,$0000
		dc.w	$F7EB,$11FC,$1000,$0000,$F3FF,$1407,$0000,$0000
		dc.w	$F000,$9000,$1000,$0000,$7CFE,$84FA,$0100,$0000
		dc.w	$7FFC,$807A,$0000,$0000,$7FFC,$807A,$0000,$0000
		dc.w	$00FE,$0062,$0080,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$F87D,$0884,$0000,$0000
		dc.w	$FFFC,$3D05,$0700,$0000,$FFFC,$0F05,$0004,$0000
		dc.w	$FFFC,$0F05,$0004,$0000,$FCFC,$0504,$0000,$0000
		dc.w	$001E,$0039,$0000,$0000,$FFBF,$F8A0,$0000,$0000
		dc.w	$7F9F,$FFA1,$7F80,$0000,$0F80,$1080,$0000,$0000
		dc.w	$03F3,$0414,$0000,$0000,$F7EF,$141F,$000F,$0000
		dc.w	$F7FF,$F0F4,$F01C,$0000,$F3FF,$143C,$0000,$0000
		dc.w	$F000,$1000,$1000,$0000,$FDFA,$FDFE,$0100,$0000
		dc.w	$7D7C,$8FFE,$0100,$0000,$7D7C,$8FFE,$0100,$0000
		dc.w	$007E,$0062,$0080,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$F87D,$0884,$0000,$0000
		dc.w	$F57C,$0885,$0700,$0000,$F97C,$0985,$0704,$0000
		dc.w	$F97C,$0985,$0704,$0000,$FCFC,$0504,$0000,$0000
		dc.w	$001F,$0021,$0000,$0000,$7FBE,$30A1,$C000,$0000
		dc.w	$801F,$8021,$C000,$0000,$0F80,$1080,$0000,$0000
		dc.w	$03F3,$0414,$0000,$0000,$F7D0,$1430,$0018,$0000
		dc.w	$07D5,$0022,$001C,$0000,$F3E7,$1424,$0004,$0000
		dc.w	$F000,$1000,$1000,$0000,$03FA,$01FC,$0202,$0000
		dc.w	$7EBC,$9EFE,$0380,$0000,$7EBC,$9EFE,$0380,$0000
		dc.w	$003E,$0042,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$F87D,$0884,$0000,$0000
		dc.w	$F07C,$0A85,$0700,$0000,$F97C,$0985,$0704,$0000
		dc.w	$F97C,$0985,$0704,$0000,$FCFC,$0504,$0000,$0000
		dc.w	$001F,$0023,$0000,$0000,$2FBE,$10A1,$2000,$0000
		dc.w	$001F,$0021,$8000,$0000,$0F80,$1080,$0000,$0000
		dc.w	$03F3,$0414,$0000,$0000,$F7C0,$1420,$0010,$0000
		dc.w	$07C1,$002A,$001C,$0000,$F3E7,$1424,$0000,$0000
		dc.w	$F000,$0000,$1000,$0000,$07F4,$03FC,$0404,$0000
		dc.w	$7C3C,$9C7E,$0280,$0000,$7C3C,$9C7E,$0280,$0000
		dc.w	$003E,$0042,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$FF7D,$0D84,$0700,$0000
		dc.w	$F07C,$0D85,$0500,$0000,$F8FC,$0F05,$0004,$0000
		dc.w	$F8FC,$0F05,$0004,$0000,$FCFC,$0504,$0200,$0000
		dc.w	$001F,$0027,$0000,$0000,$0FBE,$10A1,$2000,$0000
		dc.w	$101F,$F021,$0000,$0000,$0F80,$1080,$0000,$0000
		dc.w	$03F3,$0414,$0008,$0000,$F7C2,$143E,$0000,$0000
		dc.w	$07C1,$0036,$0014,$0000,$F3E7,$1438,$0000,$0000
		dc.w	$C000,$2000,$1000,$0000,$0FF8,$05F8,$0804,$0000
		dc.w	$7C7C,$8C7E,$0000,$0000,$7C7C,$8C7E,$0000,$0000
		dc.w	$003E,$0042,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$FBFD,$0784,$0000,$0000
		dc.w	$F87C,$0885,$0000,$0000,$FFFC,$0005,$0004,$0000
		dc.w	$FFFC,$0005,$0004,$0000,$FEFC,$0D04,$0200,$0000
		dc.w	$001F,$0023,$0000,$0000,$0FBF,$10A0,$0000,$0000
		dc.w	$F01F,$1021,$1000,$0000,$0F80,$1080,$0000,$0000
		dc.w	$03FB,$0434,$0008,$0000,$F7FE,$1402,$0002,$0000
		dc.w	$07E1,$0022,$0000,$0000,$F3FF,$1400,$0000,$0000
		dc.w	$E000,$3000,$1000,$0000,$1FE8,$0810,$1008,$0000
		dc.w	$7C7C,$847A,$0000,$0000,$7C7C,$847A,$0000,$0000
		dc.w	$003E,$0042,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$FFFD,$0104,$0000,$0000
		dc.w	$F87C,$0885,$0000,$0000,$FFFC,$0001,$0004,$0000
		dc.w	$FFFC,$0001,$0004,$0000,$FFFC,$0F04,$0000,$0000
		dc.w	$001F,$0021,$0000,$0000,$0FBF,$10A1,$0000,$0000
		dc.w	$F01F,$D021,$1000,$0000,$0F80,$5080,$4000,$0000
		dc.w	$03FF,$043C,$0000,$0000,$F7FE,$143A,$0002,$0000
		dc.w	$07E1,$0022,$0000,$0000,$F3FF,$1400,$0000,$0000
		dc.w	$C000,$2000,$1000,$0000,$3FD0,$1020,$2010,$0000
		dc.w	$7C7C,$8442,$0000,$0000,$7C7C,$8442,$0000,$0000
		dc.w	$003E,$0042,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$FFFD,$3C04,$0000,$0000
		dc.w	$F87C,$0885,$0000,$0000,$FFF8,$0009,$0004,$0000
		dc.w	$FFF9,$0009,$0005,$0000,$7FF4,$C60C,$0004,$0000
		dc.w	$001F,$0021,$0000,$0000,$0FBF,$10A3,$0000,$0000
		dc.w	$F01E,$F021,$1000,$0000,$4F80,$B080,$E000,$0000
		dc.w	$05FF,$0718,$0400,$0000,$D7FE,$347E,$1002,$0000
		dc.w	$07E1,$0022,$0000,$0000,$F3FF,$1400,$0000,$0000
		dc.w	$F000,$0000,$1000,$0000,$3FE0,$2040,$4020,$0000
		dc.w	$7C7C,$8442,$0000,$0000,$7C7C,$8442,$0000,$0000
		dc.w	$003E,$0042,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$FFFD,$7E64,$0000,$0000
		dc.w	$F87C,$0885,$0000,$0000,$FFF8,$0015,$000C,$0000
		dc.w	$FFF9,$0014,$000D,$0000,$FFFC,$C008,$0004,$0000
		dc.w	$001F,$0021,$0000,$0000,$0FBF,$10BB,$0000,$0000
		dc.w	$F01E,$F021,$1000,$0000,$EF80,$5080,$A000,$0000
		dc.w	$07FF,$0300,$0400,$0000,$F7FE,$277E,$1002,$0000
		dc.w	$07E1,$0022,$0000,$0000,$F3F7,$1418,$0000,$0000
		dc.w	$F000,$1000,$1000,$0000,$5FC0,$6080,$4040,$0000
		dc.w	$7C7C,$8442,$0000,$0000,$7C7C,$8442,$0000,$0000
		dc.w	$003E,$0042,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$FFFD,$7EF4,$0000,$0000
		dc.w	$F87C,$0885,$0000,$0000,$FFE0,$0FC9,$0078,$0000
		dc.w	$FFE0,$0FC9,$0079,$0000,$DFF8,$7F34,$800C,$0000
		dc.w	$001F,$0021,$0000,$0000,$0FBF,$10BB,$0000,$0000
		dc.w	$F01E,$F021,$F000,$0000,$EF80,$B080,$0000,$0000
		dc.w	$037F,$05FC,$0600,$0000,$E7FE,$D77E,$301E,$0000
		dc.w	$07E1,$0022,$0000,$0000,$F3FF,$143C,$0000,$0000
		dc.w	$F000,$1000,$0000,$0000,$BE80,$4100,$8080,$0000
		dc.w	$7C7C,$8442,$0000,$0000,$7C7C,$8442,$0000,$0000
		dc.w	$003E,$0042,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$FFFD,$7EF4,$0000,$0000
		dc.w	$F87C,$0885,$0000,$0000,$F800,$0801,$0000,$0000
		dc.w	$F800,$0800,$0000,$0000,$3FE0,$9FC8,$E038,$0000
		dc.w	$001F,$0021,$0000,$0000,$0FBF,$10A1,$0000,$0000
		dc.w	$001E,$0021,$0000,$0000,$EF80,$1080,$0000,$0000
		dc.w	$00FF,$027F,$0380,$0000,$87E0,$2420,$E000,$0000
		dc.w	$07E1,$0022,$0000,$0000,$F3E3,$1424,$0000,$0000
		dc.w	$F000,$1000,$0000,$0000,$BF00,$C100,$0100,$0000
		dc.w	$7C7C,$8442,$0280,$0000,$7C7C,$8442,$0280,$0000
		dc.w	$003E,$0042,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$FFFD,$7E64,$0000,$0000
		dc.w	$F87C,$0885,$0000,$0000,$F800,$0801,$0000,$0000
		dc.w	$F800,$0800,$0000,$0000,$1FC0,$1FC0,$0000,$0000
		dc.w	$001F,$0021,$0000,$0000,$0FBE,$10A7,$0000,$0000
		dc.w	$801F,$0020,$8000,$0000,$FF80,$1880,$0000,$0000
		dc.w	$007F,$007F,$0000,$0000,$07D0,$04E0,$0010,$0000
		dc.w	$07E1,$0022,$0000,$0000,$F3E3,$1424,$0000,$0000
		dc.w	$F000,$1000,$0000,$0000,$7C00,$8200,$0000,$0000
		dc.w	$7ABC,$8442,$0280,$0000,$7ABC,$8442,$0280,$0000
		dc.w	$003E,$0042,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$FFFD,$3C04,$0000,$0000
		dc.w	$F87C,$0885,$0000,$0000,$F800,$0801,$0000,$0000
		dc.w	$F800,$0800,$0000,$0000,$1FC0,$1FC0,$0000,$0000
		dc.w	$001F,$0021,$0000,$0000,$0FBF,$10AF,$0000,$0000
		dc.w	$801F,$8020,$C000,$0000,$FF80,$1880,$0000,$0000
		dc.w	$007F,$007F,$0000,$0000,$07F0,$05F0,$0018,$0000
		dc.w	$07E1,$0022,$0000,$0000,$F3E3,$1424,$0000,$0000
		dc.w	$F000,$1000,$0000,$0000,$7E00,$8200,$0000,$0000
		dc.w	$7EFC,$8282,$0380,$0000,$7EFC,$8282,$0380,$0000
		dc.w	$003E,$0042,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$FFFD,$0184,$0000,$0000
		dc.w	$F87C,$0885,$0000,$0000,$F800,$0801,$0000,$0000
		dc.w	$F800,$0800,$0000,$0000,$1FC0,$1FC0,$0000,$0000
		dc.w	$001F,$0021,$0000,$0000,$0FBF,$10A6,$0000,$0000
		dc.w	$601F,$C027,$7000,$0000,$FF80,$C080,$0000,$0000
		dc.w	$007F,$007F,$0000,$0000,$07EC,$04D8,$000E,$0000
		dc.w	$07E1,$0022,$0000,$0000,$F3E3,$1424,$0000,$0000
		dc.w	$F000,$9000,$0000,$0000,$7C00,$8200,$0000,$0000
		dc.w	$7D7C,$8382,$0100,$0000,$7D7C,$8382,$0100,$0000
		dc.w	$003E,$0042,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$FFFD,$03C4,$0000,$0000
		dc.w	$F8FC,$0705,$0000,$0000,$F800,$0801,$0000,$0000
		dc.w	$F800,$0800,$0000,$0000,$1FC0,$1FC0,$0000,$0000
		dc.w	$001F,$0021,$0000,$0000,$0FBF,$10A0,$0000,$0000
		dc.w	$FF9F,$00AF,$0000,$0000,$FF80,$E080,$0000,$0000
		dc.w	$007F,$007F,$0000,$0000,$07FF,$0400,$0000,$0000
		dc.w	$F7E3,$101C,$0000,$0000,$F3E3,$1425,$0000,$0000
		dc.w	$F000,$9000,$0000,$0000,$7C02,$83FE,$0000,$0000
		dc.w	$7FFC,$8002,$0000,$0000,$7FFC,$8002,$0000,$0000
		dc.w	$003E,$0042,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$FAFD,$07C4,$0000,$0000
		dc.w	$FFFC,$0005,$0000,$0000,$F800,$0801,$0000,$0000
		dc.w	$F800,$0800,$0000,$0000,$0FC0,$1F40,$0000,$0000
		dc.w	$001F,$0021,$0000,$0000,$0FBF,$10A0,$0000,$0000
		dc.w	$FF9F,$00AF,$0000,$0000,$FF80,$E680,$0000,$0000
		dc.w	$003F,$007D,$0000,$0000,$07FF,$0400,$0000,$0000
		dc.w	$F7FF,$1000,$0000,$0000,$F3E3,$1424,$0000,$0000
		dc.w	$F000,$1000,$0000,$0000,$7FFE,$8002,$0000,$0000
		dc.w	$7FFC,$8002,$0000,$0000,$7FFC,$8002,$0000,$0000
		dc.w	$003E,$0042,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$FF7D,$0D84,$0700,$0000
		dc.w	$FFFC,$0005,$0000,$0000,$F800,$0801,$0000,$0000
		dc.w	$F800,$0800,$0000,$0000,$0FC0,$1040,$0000,$0000
		dc.w	$001F,$0021,$0000,$0000,$0FBF,$10A0,$0000,$0000
		dc.w	$FF9F,$00AF,$0000,$0000,$FF80,$EF80,$0000,$0000
		dc.w	$003F,$0041,$0000,$0000,$07FF,$0400,$0000,$0000
		dc.w	$F7FF,$1000,$0000,$0000,$F3E3,$1424,$0000,$0000
		dc.w	$F000,$1000,$0000,$0000,$7FFE,$8002,$0000,$0000
		dc.w	$FFFE,$8002,$0000,$0000,$FFFE,$8002,$0000,$0000
		dc.w	$003E,$0042,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$F87D,$0884,$0000,$0000
		dc.w	$FFFC,$0005,$0000,$0000,$F800,$0801,$0000,$0000
		dc.w	$F800,$0800,$0000,$0000,$0FC0,$1040,$0000,$0000
		dc.w	$001F,$0021,$0000,$0000,$0FBF,$10A0,$0020,$0000
		dc.w	$FF9F,$00AF,$0000,$0000,$FF80,$EF80,$0000,$0000
		dc.w	$003F,$0041,$0000,$0000,$07FF,$0400,$0400,$0000
		dc.w	$F7FF,$1000,$0000,$0000,$F3E3,$1424,$0000,$0000
		dc.w	$F000,$D000,$0000,$0000,$7FFE,$8002,$0000,$0000
		dc.w	$FFFE,$8002,$8002,$0000,$FFFE,$8002,$8002,$0000
		dc.w	$003E,$0042,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$F87D,$0884,$0000,$0000
		dc.w	$FFFC,$0F05,$0000,$0000,$F800,$0801,$0000,$0000
		dc.w	$F800,$0800,$0000,$0000,$0FC0,$1040,$0000,$0000
		dc.w	$001F,$0021,$0000,$0000,$0FBF,$1080,$0020,$0000
		dc.w	$FF9F,$00AF,$0000,$0000,$FF80,$E680,$0000,$0000
		dc.w	$003F,$0041,$0000,$0000,$07FF,$0000,$0400,$0000
		dc.w	$F7FF,$103C,$0000,$0000,$F3E3,$1425,$0000,$0000
		dc.w	$F000,$F000,$0000,$0000,$7FFE,$8002,$0000,$0000
		dc.w	$FFFE,$0000,$8002,$0000,$FFFE,$0000,$8002,$0000
		dc.w	$003E,$0042,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$F87D,$0884,$0000,$0000
		dc.w	$F8FC,$0805,$0000,$0000,$F800,$0801,$0000,$0000
		dc.w	$F800,$0800,$0000,$0000,$0FC0,$1040,$0000,$0000
		dc.w	$001F,$0021,$0000,$0000,$0F9F,$1090,$0020,$0000
		dc.w	$FF9F,$00A7,$0000,$0000,$FF80,$C080,$0000,$0000
		dc.w	$003F,$0041,$0000,$0000,$03FF,$0200,$0400,$0000
		dc.w	$F7E3,$1020,$0000,$0000,$F3E3,$1425,$0000,$0000
		dc.w	$F000,$F000,$0000,$0000,$7FFE,$8002,$0000,$0000
		dc.w	$7FFC,$4004,$8002,$0000,$7FFC,$4004,$8002,$0000
		dc.w	$003E,$0042,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$F87D,$0884,$0000,$0000
		dc.w	$F8FC,$0805,$0000,$0000,$F800,$0801,$0000,$0000
		dc.w	$F800,$0800,$0000,$0000,$0FC0,$1040,$0000,$0000
		dc.w	$001F,$0021,$0000,$0000,$0F9F,$10A8,$0030,$0000
		dc.w	$FF9F,$00A0,$0000,$0000,$5F80,$E080,$0000,$0000
		dc.w	$003F,$0041,$0000,$0000,$03FF,$0500,$0600,$0000
		dc.w	$F7E3,$1020,$0000,$0000,$F3E3,$1424,$0000,$0000
		dc.w	$F000,$D000,$0000,$0000,$FFFE,$8002,$8002,$0000
		dc.w	$7FFC,$A00A,$C006,$0000,$7FFC,$A00A,$C006,$0000
		dc.w	$003E,$0042,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$F87D,$F8FC,$0000,$0000
		dc.w	$78FD,$F87D,$0000,$0000,$F801,$F801,$0000,$0000
		dc.w	$F800,$F800,$0000,$0000,$0FC0,$1FC0,$0000,$0000
		dc.w	$001F,$003F,$0000,$0000,$1F87,$1F97,$001C,$0000
		dc.w	$FF83,$FFBF,$0001,$0000,$BF80,$1880,$F000,$0000
		dc.w	$003F,$007F,$0000,$0000,$00FF,$02FF,$0380,$0000
		dc.w	$F5E3,$F3E1,$0000,$0000,$F7E3,$F7E7,$0000,$0000
		dc.w	$F000,$F000,$0000,$0000,$FFFE,$7FFC,$C006,$0000
		dc.w	$1FF0,$5FF4,$701C,$0000,$1FF0,$5FF4,$701C,$0000
		dc.w	$007E,$007E,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		
PalNoeXtra:
	dc.w	$0000,$0777,$0776,$0766,$0665,$0655,$0554,$0554
	dc.w	$0443,$0443,$0333,$0232,$0222,$0121,$0121,$0010

LogoNoeXtra:
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0001,$0001,$2000,$0000,$A000,$E000
		dc.w	$0000,$0000,$0000,$0000,$006C,$0070,$007F,$007F
		dc.w	$3600,$0E00,$FE00,$FE00,$0040,$00E0,$00B0,$00D0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0018,$0018,$0018,$0018
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0003,$0003,$0003,$0003
		dc.w	$61B0,$8070,$FFF0,$FFF0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0007,$007F,$0000,$0000,$31E2,$F01E,$0FFE,$0001
		dc.w	$E000,$4000,$2000,$E000,$002C,$0103,$01BF,$01C0
		dc.w	$7180,$F480,$F380,$0F80,$00DB,$0FEC,$001F,$0000
		dc.w	$0180,$01F3,$FE04,$0004,$03D8,$FFD0,$0038,$0008
		dc.w	$0008,$007C,$004C,$0004,$0008,$0040,$0068,$0070
		dc.w	$0000,$0003,$0000,$0000,$018F,$FF80,$007F,$0000
		dc.w	$1700,$F200,$F100,$0F00,$0001,$0008,$000D,$000E
		dc.w	$638C,$1FA4,$FF9C,$007C,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$007F,$003F,$0000,$FFFF,$FFFF,$BFFF,$0000
		dc.w	$A000,$9000,$8800,$7800,$07BF,$019F,$047F,$0600
		dc.w	$FEA0,$FE20,$FE60,$01E0,$07EF,$0FAF,$07CF,$0010
		dc.w	$FFF0,$FFF1,$FFE2,$0000,$7FE8,$7FE8,$FFE0,$0018
		dc.w	$0018,$0058,$00B0,$0088,$01D0,$0050,$0130,$0188
		dc.w	$0000,$0003,$0000,$0000,$E7FF,$F7FF,$E7FF,$0800
		dc.w	$FD00,$FC80,$FC40,$03C0,$003D,$000C,$0023,$0030
		dc.w	$FFF5,$FFF1,$FFF3,$000F,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$007F,$003F,$0000,$FFFF,$BFFF,$FFFF,$0000
		dc.w	$FA00,$F400,$F200,$0E00,$0BFF,$16FF,$11FF,$1800
		dc.w	$FF90,$FFA0,$FF90,$0070,$078F,$0FBF,$07CF,$0010
		dc.w	$FFE3,$FFF1,$FFF2,$0002,$7FE8,$FFE4,$FFE4,$001C
		dc.w	$0028,$00F0,$00A8,$0018,$02F8,$05B8,$0470,$0600
		dc.w	$0001,$0002,$0001,$0000,$E7FF,$F7FF,$E7FF,$0800
		dc.w	$FFD0,$FFA0,$FF90,$0070,$005F,$00B7,$008F,$00C0
		dc.w	$FFFC,$FFFD,$FFFC,$0003,$8000,$0000,$8000,$8000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007F,$007F,$003F,$0000,$FC13,$BC1B,$FFE3,$03FC
		dc.w	$F800,$FA00,$F900,$0700,$27F2,$1BF6,$37F1,$200F
		dc.w	$4FE8,$6FE8,$8FE0,$F018,$0F07,$0F47,$0737,$0098
		dc.w	$F8C0,$E0E0,$FF00,$1FF1,$7FF8,$7FF0,$FFF4,$000C
		dc.w	$0040,$00A0,$0150,$0130,$09F8,$06F4,$0DFC,$0804
		dc.w	$0003,$0003,$0001,$0000,$E7E0,$E7E0,$F7FF,$081F
		dc.w	$9FC0,$DFD0,$1FC8,$E038,$013F,$00DF,$01BF,$0100
		dc.w	$927F,$B37F,$8C7F,$7F80,$4000,$4000,$0000,$C000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007F,$007F,$003F,$0000,$BC1B,$FC11,$FE1D,$021E
		dc.w	$FE80,$FF00,$FE80,$0180,$1FE7,$3FF3,$4FEF,$401F
		dc.w	$BFFC,$D7F4,$E7F0,$F80C,$0F37,$0F2F,$0777,$0098
		dc.w	$F001,$E000,$F001,$1001,$3FF0,$7FF4,$FFF0,$000C
		dc.w	$0060,$01F0,$0150,$0030,$07F8,$0FF0,$13FF,$1000
		dc.w	$6003,$7C03,$8001,$0000,$FFE0,$F7E0,$E7F0,$0810
		dc.w	$DFF4,$8FF8,$EFF4,$F00C,$00FF,$01FF,$027F,$0200
		dc.w	$3DFF,$9EBF,$7F3F,$FFC0,$E000,$A000,$8000,$6000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007F,$007F,$003F,$0000,$9C02,$DC06,$DE04,$2207
		dc.w	$FE00,$FE80,$FE00,$0180,$9FC0,$5FC8,$BFD8,$8038
		dc.w	$0BFE,$1BFA,$13F8,$1C06,$0FA7,$0FC7,$0797,$0078
		dc.w	$E000,$E000,$F000,$1000,$FFFC,$3FF8,$7FFA,$8006
		dc.w	$0020,$01C0,$02A0,$0260,$27FF,$17FF,$2FFF,$2000
		dc.w	$FC03,$FC03,$F801,$0000,$EFE0,$F7E0,$E7F0,$0810
		dc.w	$17F0,$37F4,$27F0,$380C,$04FE,$02FE,$05FE,$0401
		dc.w	$005F,$40DF,$C09F,$C0E0,$F000,$D000,$C000,$3000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007F,$007F,$003F,$0000,$DC03,$9C00,$DE02,$2203
		dc.w	$FF81,$FF01,$FF41,$00C1,$7FD0,$FFE0,$BFD0,$0030
		dc.w	$07FE,$03FC,$0BFD,$0C03,$0FCF,$0F9F,$078F,$0070
		dc.w	$E000,$E000,$F000,$1000,$9FF8,$7FFA,$FFF8,$8006
		dc.w	$0320,$0320,$0260,$00E0,$5FFF,$7FFF,$6FFF,$4000
		dc.w	$F803,$FC03,$FC01,$0000,$FFE0,$E7E0,$F7F0,$0810
		dc.w	$1FFC,$07F8,$17FA,$1806,$0BFE,$0FFF,$0DFE,$0801
		dc.w	$803F,$001F,$805F,$8060,$F000,$E000,$E800,$1800
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007F,$007F,$003F,$0000,$DC02,$DC03,$9E02,$2203
		dc.w	$FFC1,$FFC0,$FF80,$0041,$7FF0,$FFF0,$7FD0,$0030
		dc.w	$07FF,$0BFE,$0BFE,$0C01,$0FCF,$8FBF,$87AF,$8050
		dc.w	$E000,$E000,$F000,$1000,$1FFF,$7FFC,$3FFD,$4003
		dc.w	$03C0,$0380,$0540,$04C0,$5FF8,$3FF8,$1FF7,$400F
		dc.w	$3003,$3803,$C001,$FC00,$C7E0,$DFE0,$D7F0,$2810
		dc.w	$17FE,$1FFE,$17FC,$1802,$0BFF,$07FF,$03FE,$0801
		dc.w	$803F,$805F,$805F,$8060,$F800,$F400,$F400,$0C00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007F,$007F,$003F,$0000,$FC00,$DC01,$9E00,$2201
		dc.w	$FFE0,$FF82,$FFA3,$0062,$FFD0,$7FD0,$FFF0,$0030
		dc.w	$0BFE,$0BFE,$0BFE,$0C01,$8FAF,$8F9F,$07AF,$8050
		dc.w	$F000,$F000,$E000,$1000,$7FFF,$3FFD,$7FFC,$4003
		dc.w	$0540,$0440,$06C0,$01C0,$3FF4,$9FF2,$FFFE,$800E
		dc.w	$0003,$0003,$0001,$0000,$C7E0,$DFE0,$D7F0,$2810
		dc.w	$07FF,$0FFC,$07FD,$0803,$07FE,$13FE,$1FFF,$1001
		dc.w	$805F,$805F,$805F,$8060,$F400,$F400,$F000,$0C00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007F,$007F,$003F,$0000,$FC01,$9C00,$DE00,$2201
		dc.w	$FF83,$FF83,$FFA0,$0062,$FFC0,$FFC0,$FFE0,$0020
		dc.w	$03FF,$03FF,$03FF,$0400,$8FBF,$4FEF,$47CF,$C010
		dc.w	$F000,$F000,$E000,$1000,$2FFF,$2FFE,$0FFE,$3001
		dc.w	$8B80,$0300,$8E80,$8980,$FFF0,$FFF4,$3FFC,$800C
		dc.w	$0003,$0003,$0001,$0000,$D7E0,$CFE0,$D7F0,$2810
		dc.w	$0FFC,$07FC,$07FD,$0803,$1FFE,$1FFE,$07FF,$1001
		dc.w	$001F,$001F,$001F,$0020,$FC00,$FA00,$FA00,$0600
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$003F,$007F,$0000,$9C01,$9C00,$DE00,$2201
		dc.w	$FFC4,$FFC6,$FFE7,$0024,$FFC0,$FFC0,$FFE0,$0020
		dc.w	$03FF,$03FF,$03FF,$0400,$47DF,$47FF,$0F9F,$C000
		dc.w	$F220,$F220,$E220,$1220,$3FFF,$0FFE,$2FFE,$3001
		dc.w	$5E81,$5081,$D581,$DB81,$3FF0,$BFF0,$FFF8,$0008
		dc.w	$0001,$0001,$0003,$0000,$DFE0,$F7E0,$E7F0,$0810
		dc.w	$0FFE,$07FE,$07FF,$0801,$27FE,$37FE,$3FFF,$2001
		dc.w	$001F,$001F,$001F,$0020,$F800,$F800,$FA00,$0600
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$003F,$007F,$0000,$DC00,$DC00,$9E00,$2201
		dc.w	$FFC6,$FFC3,$FFE5,$0024,$FFC0,$FFC0,$FFE0,$0020
		dc.w	$03FF,$03FF,$03FF,$0400,$872F,$E77F,$AF8F,$6030
		dc.w	$F550,$F770,$E770,$1770,$07FF,$07FF,$17FF,$1800
		dc.w	$5701,$8E00,$5D01,$D301,$BFF0,$FFF0,$7FF8,$0008
		dc.w	$0001,$0001,$0003,$0000,$EFE0,$FFE0,$CFF0,$0010
		dc.w	$07FE,$07FE,$07FF,$0801,$37FE,$1FFE,$2FFF,$2001
		dc.w	$001F,$001F,$001F,$0020,$FC00,$FF00,$FD00,$0300
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$003F,$007F,$0000,$BC00,$FC00,$3E00,$0201
		dc.w	$FFC1,$FFC5,$FFE3,$0024,$FFC0,$FFC0,$FFE0,$0020
		dc.w	$07FF,$07FF,$07FF,$0000,$E6BF,$86C7,$AE27,$6138
		dc.w	$F6B0,$F410,$E6B0,$16B0,$1FFF,$07FF,$17FF,$1800
		dc.w	$C100,$7901,$2B00,$F701,$7FF0,$7FF0,$FFF8,$0008
		dc.w	$0001,$0001,$0003,$0000,$97E0,$BFE0,$C7F0,$1810
		dc.w	$07FC,$07FC,$07FD,$0803,$0FFE,$2FFE,$1FFF,$2001
		dc.w	$003F,$003F,$003F,$0000,$FF00,$FC00,$FD00,$0300
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003E,$003E,$007F,$0000,$5C01,$FC01,$1E01,$6200
		dc.w	$FFC7,$FFCD,$FFEF,$0028,$FFC0,$FFC0,$FFE0,$0020
		dc.w	$07FF,$07FF,$07FF,$0000,$8757,$8673,$AE9B,$616C
		dc.w	$E410,$F630,$E630,$1630,$07FF,$03FF,$0BFF,$0C00
		dc.w	$DE01,$DC03,$BA03,$6602,$FFF0,$7FF0,$FFF8,$0008
		dc.w	$0001,$0001,$0003,$0000,$5FE0,$63E0,$13F0,$9C10
		dc.w	$0FFB,$0FFA,$0FF9,$0007,$3FFE,$6FFE,$7FFF,$4001
		dc.w	$003F,$003F,$003F,$0000,$FC00,$FC00,$FD00,$0300
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007D,$003F,$007E,$0000,$7C00,$8C01,$4E01,$7200
		dc.w	$FFC5,$FFCB,$FFEF,$0028,$FFC0,$FFC0,$FFE0,$0020
		dc.w	$03FF,$07FF,$07FF,$0000,$CFA9,$C729,$EF3D,$20DE
		dc.w	$C220,$D220,$C220,$3220,$03FF,$0FFF,$0BFF,$0C00
		dc.w	$DA01,$9202,$9603,$6E02,$7FF0,$FFF0,$FFF8,$0008
		dc.w	$0003,$0001,$0003,$0000,$2BE0,$39E0,$4DF0,$B610
		dc.w	$07F8,$0FFE,$0FFA,$0006,$2FFE,$5FFE,$7FFF,$4001
		dc.w	$001F,$003F,$003F,$0000,$FE00,$FE00,$FF00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007C,$003E,$007F,$0000,$AC00,$E401,$3601,$DA00
		dc.w	$FFCB,$FFC7,$FFEF,$0028,$FFC0,$FFC0,$FFE0,$0020
		dc.w	$03FF,$07FF,$07FF,$0000,$EF89,$E7D1,$CFBD,$207E
		dc.w	$D000,$C000,$C000,$3000,$05FF,$03FF,$05FF,$0600
		dc.w	$FC02,$F801,$F403,$0C02,$FFF0,$FFF0,$FFF8,$0008
		dc.w	$0003,$0001,$0003,$0000,$D4E0,$94E0,$9EF0,$6F10
		dc.w	$07F4,$0FF0,$0FF4,$000C,$5FFE,$3FFE,$7FFF,$4001
		dc.w	$001F,$003F,$003F,$0000,$FF00,$FF00,$FE00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007F,$003E,$007E,$0001,$5001,$5000,$7A01,$BE00
		dc.w	$FFC3,$FFC7,$FFEF,$0028,$FFC0,$FFC0,$FFE0,$0020
		dc.w	$07FF,$03FF,$07FF,$0000,$EFE3,$E7E7,$CFDB,$203C
		dc.w	$C180,$C9F0,$CE00,$3000,$02FF,$06FF,$04FF,$0700
		dc.w	$E400,$E401,$EC03,$1C02,$FFF0,$FFF0,$FFF8,$0008
		dc.w	$0003,$0001,$0003,$0000,$C4E1,$E8E9,$DEEE,$3F10
		dc.w	$8FE8,$F7E8,$0FE0,$0018,$3FFE,$3FFE,$7FFF,$4001
		dc.w	$0C7F,$4F9F,$707F,$8000,$FF00,$FF00,$FE00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003E,$007E,$007E,$0001,$5001,$A000,$3A01,$FE00
		dc.w	$FFC7,$FFC7,$FFEF,$0028,$FFC0,$FFC0,$FFE0,$0020
		dc.w	$07FF,$03FF,$07FF,$0000,$E7FF,$EFE7,$CFE7,$2018
		dc.w	$FFF0,$FFF0,$FFE0,$0000,$00FF,$00FF,$02FF,$0300
		dc.w	$E801,$F001,$E803,$1802,$FFF0,$FFF0,$FFF8,$0008
		dc.w	$0001,$0003,$0003,$0000,$F1FF,$F3FF,$EDFF,$1E00
		dc.w	$FFD0,$FFD0,$FFC0,$0030,$3FFF,$7FFF,$3FFF,$4000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FF00,$FF00,$FE00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$007F,$007F,$0000,$4400,$4C00,$7601,$BA00
		dc.w	$FFC7,$FFC7,$FFEF,$0028,$FFC0,$FFC0,$FFE0,$0020
		dc.w	$03FF,$03FF,$07FF,$0000,$E7FF,$EFFF,$CFFF,$2000
		dc.w	$FFE0,$FFF0,$FFF0,$0000,$01FF,$07FF,$05FF,$0600
		dc.w	$E801,$F001,$E803,$1802,$FFF0,$FFF0,$FFF8,$0008
		dc.w	$0001,$0003,$0003,$0000,$FFFF,$F3FF,$F3FF,$0C00
		dc.w	$FFE0,$FFF0,$FFE8,$0018,$7FFF,$7FFF,$7FFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FF00,$FF00,$FE00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$007F,$007F,$0000,$3401,$4401,$4600,$BA00
		dc.w	$FFC3,$FFC3,$FFEB,$002C,$FFC0,$FFC0,$FFE0,$0020
		dc.w	$03FF,$03FF,$07FF,$0000,$E7FF,$EFFF,$CFFF,$2000
		dc.w	$E0C0,$C0E0,$DF00,$3FF0,$05FF,$05FF,$01FF,$0600
		dc.w	$E000,$E000,$E802,$1803,$FFF0,$FFF0,$FFF8,$0008
		dc.w	$0001,$0003,$0003,$0000,$FFE0,$FFE0,$FFFF,$001F
		dc.w	$CFE4,$EFE8,$07E4,$F01C,$7FFE,$7FFE,$7FFF,$0001
		dc.w	$067F,$077F,$F81F,$FF80,$FE00,$FE00,$FF00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007F,$007F,$007F,$0000,$9C00,$1C01,$5E00,$A200
		dc.w	$FFCB,$FFC3,$FFEB,$002C,$FFC0,$FFC0,$FFE0,$0020
		dc.w	$03FF,$03FF,$07FF,$0000,$EFFF,$EFFF,$CFFF,$2000
		dc.w	$F000,$C000,$D000,$3000,$073F,$0BBF,$0B3F,$0CC0
		dc.w	$F402,$F800,$F402,$0C03,$FFF0,$FFF0,$FFF8,$0008
		dc.w	$0003,$0003,$0003,$0000,$FFE0,$FFE0,$FFF0,$0010
		dc.w	$07F2,$0FF0,$07F6,$000E,$7FFE,$7FFE,$7FFF,$0001
		dc.w	$001F,$003F,$001F,$0000,$FE00,$FE00,$FF00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$003F,$003F,$0040,$9C00,$7C01,$3E00,$8200
		dc.w	$FFC3,$FFCB,$FFEB,$002C,$FFC0,$FFC0,$FFE0,$0020
		dc.w	$07FF,$07FF,$03FF,$0000,$87FF,$87FF,$A7FF,$6800
		dc.w	$F000,$C000,$D000,$3000,$0E7F,$0F3F,$06BF,$09C0
		dc.w	$F400,$F402,$F002,$0C03,$FFF0,$FFF0,$FFF8,$0008
		dc.w	$0001,$0001,$0001,$0002,$FFE0,$FFE0,$FFF0,$0010
		dc.w	$07F8,$0FF9,$07FB,$0007,$3FFE,$3FFE,$3FFF,$4001
		dc.w	$001F,$003F,$001F,$0000,$FE00,$FE00,$FF00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$003F,$003F,$0040,$3C01,$1C01,$7E00,$8200
		dc.w	$FFC5,$FFC9,$FFE9,$002E,$FFC0,$FFC0,$FFE0,$0020
		dc.w	$07FF,$07FF,$03FF,$0000,$E7FF,$87FF,$A7FF,$6800
		dc.w	$E000,$C000,$D000,$3000,$0A1F,$1E9F,$1FDF,$11E0
		dc.w	$FE01,$F802,$FA02,$0603,$7FF0,$7FF0,$7FF8,$8008
		dc.w	$0001,$0001,$0001,$0002,$FFE0,$FFE0,$FFF0,$0010
		dc.w	$0FFC,$0FFC,$07FD,$0003,$3FFE,$3FFE,$3FFF,$4001
		dc.w	$003F,$003F,$001F,$0000,$FE00,$FE00,$FF00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$003F,$003F,$0040,$5C01,$FC01,$BE00,$0200
		dc.w	$FFCD,$FFCD,$FFE9,$002E,$FFC0,$FFC0,$FFE0,$0020
		dc.w	$07FF,$07FF,$03FF,$0000,$C7FF,$E7FF,$A7FF,$6800
		dc.w	$C000,$C000,$D000,$3000,$075F,$1E3F,$0D5F,$1360
		dc.w	$FD03,$FF03,$FD02,$0303,$7FF0,$7FF0,$7FF8,$8008
		dc.w	$0001,$0001,$0001,$0002,$FFE0,$FFE0,$FFF0,$0010
		dc.w	$0FFE,$0FFE,$07FF,$0001,$3FFE,$3FFE,$3FFF,$4001
		dc.w	$003F,$003F,$001F,$0000,$FE00,$FE00,$FF00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007E,$003F,$003F,$0040,$0C01,$7C01,$BE00,$0200
		dc.w	$FFC7,$FFC1,$FFE5,$0026,$FFC0,$FFC0,$FFE0,$0020
		dc.w	$07FF,$07FF,$03FF,$0000,$0FFF,$07FF,$47FF,$C800
		dc.w	$C000,$C000,$D000,$3000,$0D6F,$356F,$3F4F,$2370
		dc.w	$FC01,$FC00,$FD01,$0301,$FFF0,$7FF0,$7FF8,$8008
		dc.w	$0003,$0001,$0001,$0002,$FFE0,$FFE0,$FFF0,$0010
		dc.w	$0FFE,$0FFE,$07FF,$0001,$7FFE,$3FFE,$3FFF,$4001
		dc.w	$003F,$003F,$001F,$0000,$FE00,$FE00,$FF00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007C,$003E,$003F,$0040,$3401,$EC01,$0E00,$3200
		dc.w	$FFC4,$FFC6,$FFE4,$0027,$FFE0,$FFE0,$FFC0,$0020
		dc.w	$07FF,$07FF,$03FF,$0000,$4FFF,$87FF,$47FF,$C800
		dc.w	$C1C0,$C1C0,$D1C0,$31C0,$0A3F,$2C0F,$1A2F,$2630
		dc.w	$FF01,$FE81,$FE81,$0181,$3FF8,$BFF8,$3FF0,$C008
		dc.w	$0003,$0001,$0001,$0002,$FFE0,$FFE0,$FFF0,$0010
		dc.w	$0FFE,$0FFE,$07FF,$0001,$7FFE,$3FFE,$3FFF,$4001
		dc.w	$003F,$003F,$001F,$0000,$FE00,$FE00,$FF00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007C,$003F,$003E,$0040,$5401,$AC01,$6E00,$7200
		dc.w	$FFC1,$FFC0,$FFE2,$0023,$FFE0,$FFE0,$FFC0,$0020
		dc.w	$07FE,$07FE,$03FE,$0001,$CFFF,$C7FF,$47FF,$C800
		dc.w	$E2A0,$E360,$F3E0,$13E0,$0A37,$6A37,$7E27,$4638
		dc.w	$FE80,$FE80,$FE00,$0180,$7FF8,$3FF8,$BFF0,$C008
		dc.w	$0003,$0001,$0001,$0002,$FFE0,$FFE0,$FFF0,$0010
		dc.w	$0FFE,$0FFE,$07FF,$0001,$7FFE,$3FFE,$3FFF,$4001
		dc.w	$003F,$003F,$001F,$0000,$FE00,$FE00,$FF00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003C,$007F,$003E,$0040,$5C01,$3401,$7600,$EA00
		dc.w	$FFC3,$FFC3,$FFE2,$0023,$FFE0,$7FE0,$7FC0,$8020
		dc.w	$07FF,$07FF,$03FE,$0001,$87FF,$0FFF,$87FF,$8800
		dc.w	$E410,$E630,$F630,$1630,$2417,$780F,$1417,$4C18
		dc.w	$FF40,$FF00,$FF40,$00C0,$FFF8,$DFF8,$9FF0,$E008
		dc.w	$0001,$0003,$0001,$0002,$FFE0,$FFE0,$FFF0,$0010
		dc.w	$0FFE,$0FFE,$07FF,$0001,$3FFE,$7FFE,$3FFF,$4001
		dc.w	$003F,$003F,$001F,$0000,$FE00,$FE00,$FF00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003C,$007D,$003D,$0042,$6C01,$6401,$AA00,$DE00
		dc.w	$FFC1,$FFC0,$FFE1,$0021,$3FC0,$BFF0,$3FD0,$C030
		dc.w	$03FE,$07FC,$03FD,$0003,$87FF,$8FFF,$87FF,$8800
		dc.w	$F7F0,$F550,$E7F0,$17F0,$341B,$F41B,$DC13,$8C1C
		dc.w	$FFA0,$FFE0,$FFA0,$0060,$4FF0,$2FFC,$4FF4,$700C
		dc.w	$0049,$0033,$0049,$0042,$FFE0,$FFE0,$FFF0,$0010
		dc.w	$0FFE,$0FFE,$07FF,$0001,$3FFE,$7FFE,$3FFF,$4001
		dc.w	$003F,$003F,$001F,$0000,$FE00,$FE00,$FF00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003E,$007F,$003E,$0041,$3800,$4800,$5E01,$BE00
		dc.w	$FFC0,$FFC0,$FFE0,$0020,$7FC0,$7FC0,$BFD0,$C030
		dc.w	$0BFC,$0FFD,$03FF,$0803,$07FF,$0FFF,$07FF,$0800
		dc.w	$E410,$F630,$E630,$1630,$A80F,$5003,$280B,$980C
		dc.w	$FF80,$FFC0,$FFE0,$0020,$1FF0,$1FF0,$2FF4,$300C
		dc.w	$0059,$007B,$0009,$0042,$FFE0,$FFE0,$FFF0,$0010
		dc.w	$07FE,$07FE,$0FFF,$0001,$3FFF,$7FFF,$3FFE,$4001
		dc.w	$001F,$001F,$003F,$0000,$FE00,$FE00,$FF00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007E,$007E,$003E,$0041,$BC00,$1400,$7A01,$FE00
		dc.w	$FFC0,$FFC0,$FFE0,$0020,$1FF8,$3FE0,$5FE8,$6018
		dc.w	$17FA,$0BF8,$17FE,$1006,$0FFF,$0FFF,$07FF,$0800
		dc.w	$E220,$F221,$E221,$1221,$280F,$A80F,$780B,$180C
		dc.w	$FF90,$FFC0,$FFD0,$0030,$07FE,$0FF8,$17FA,$1806
		dc.w	$0073,$0073,$0099,$008A,$FFE0,$FFE0,$FFF0,$0010
		dc.w	$07FE,$07FE,$0FFF,$0001,$7FFF,$7FFF,$3FFE,$4001
		dc.w	$001F,$001F,$003F,$0000,$FE00,$FE00,$FF00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007F,$007F,$003F,$0040,$D000,$8400,$BA01,$7E00
		dc.w	$FFC0,$FFC0,$FFE0,$0020,$1FEC,$17E6,$27E2,$381E
		dc.w	$6FF4,$1FE0,$47EC,$601C,$0FFF,$0FFF,$07FF,$0800
		dc.w	$E001,$E000,$E000,$1001,$4005,$B001,$5005,$3006
		dc.w	$FFF0,$FFD0,$FFE0,$0010,$07FB,$05F9,$09F8,$0E07
		dc.w	$06E3,$C3B3,$C561,$C612,$FFF0,$FFE0,$FFF0,$0010
		dc.w	$07FE,$07FE,$0FFF,$0001,$7FFF,$7FFF,$3FFE,$4001
		dc.w	$001F,$001F,$003F,$0000,$FE00,$FE00,$FF00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007F,$007F,$003F,$0040,$D800,$C000,$C201,$3E00
		dc.w	$FFC0,$FFC0,$FFE0,$0020,$11F9,$05FE,$19FF,$1E00
		dc.w	$7F88,$6F80,$9FB8,$0078,$0FFF,$0FFF,$07FF,$0800
		dc.w	$E180,$E9F3,$EE02,$1002,$C005,$C007,$6005,$2006
		dc.w	$FFC8,$FFE0,$FFE8,$0018,$047E,$017F,$067F,$0780
		dc.w	$66C3,$86E3,$F9C1,$0022,$FFE0,$FFE0,$FFF0,$0010
		dc.w	$07FE,$07FE,$0FFF,$0001,$7FFE,$7FFF,$3FFE,$4001
		dc.w	$001F,$001F,$003F,$0000,$FE00,$FE00,$FF00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$003F,$007F,$0040,$FC01,$FC00,$FE01,$0200
		dc.w	$FFC0,$FFC0,$FFE0,$0020,$047F,$097F,$0E7F,$0F80
		dc.w	$FEB0,$FE90,$FE70,$01F0,$07FF,$07FF,$0FFF,$0800
		dc.w	$FFF2,$FFF3,$FFE2,$0000,$C002,$2000,$A002,$6003
		dc.w	$FFE0,$FFE8,$FFF0,$0008,$011F,$025F,$039F,$03E0
		dc.w	$FF81,$FF01,$FF43,$00C2,$FFE0,$FFE0,$FFF0,$0010
		dc.w	$0FFE,$07FE,$0FFF,$0001,$3FFE,$3FFE,$7FFE,$4001
		dc.w	$003F,$001F,$003F,$0000,$FE00,$FE00,$FF00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$003F,$007F,$0040,$FC01,$FC00,$FE01,$0200
		dc.w	$FFE0,$FFC0,$FFE0,$0020,$016F,$024F,$038F,$03F0
		dc.w	$E6C0,$E240,$E1C0,$1FC0,$07FF,$07FF,$0FFF,$0800
		dc.w	$FFE1,$FFF3,$FFF0,$0000,$8002,$8003,$C002,$4003
		dc.w	$FFE0,$FFE0,$FFF0,$0008,$005B,$0093,$00E3,$00FC
		dc.w	$F701,$F201,$F103,$0F02,$FFE0,$FFE0,$FFF0,$0010
		dc.w	$0FFF,$07FE,$0FFF,$0001,$3FFF,$3FFE,$7FFE,$4001
		dc.w	$003F,$001F,$003F,$0000,$FF00,$FE00,$FF00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$000F,$0000,$007F,$007F,$8001,$0000,$FE01,$FE00
		dc.w	$3060,$3FE0,$C060,$0020,$002F,$004F,$0070,$007F
		dc.w	$EC00,$E200,$1E00,$FE00,$0C3F,$0000,$0FFF,$0FFF
		dc.w	$C0C3,$00E1,$FF00,$FFF3,$8000,$C000,$4001,$C001
		dc.w	$0E20,$FE38,$01C0,$FFF8,$000B,$0013,$001C,$001F
		dc.w	$C800,$C000,$3803,$F803,$0000,$0000,$FFF0,$FFF0
		dc.w	$0983,$01FF,$0E03,$0001,$0F81,$0000,$7FFF,$7FFF
		dc.w	$0026,$0007,$0038,$0000,$0300,$FF00,$0300,$0100
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
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$001F,$0000,$0000,$0000,$B1BF,$0000,$0000,$0000
		dc.w	$8786,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0C0F,$0000,$0000,$0000,$1FB0,$0000,$0000,$0000
		dc.w	$01E3,$0000,$0000,$0000,$E3F7,$0000,$0000,$0000
		dc.w	$C7EF,$0000,$0000,$0000,$C007,$0000,$0000,$0000
		dc.w	$38E0,$0000,$0000,$0000,$C6FE,$0000,$0000,$0000
		dc.w	$C6FE,$0000,$0000,$0000,$F83E,$0000,$0000,$0000
		dc.w	$0C00,$0000,$0000,$0000,$3000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0006,$0000,$0000,$0000,$31B0,$0000,$0000,$0000
		dc.w	$0CCF,$0000,$0000,$0000,$879F,$0000,$0000,$0000
		dc.w	$8018,$0000,$0000,$0000,$0630,$0000,$0000,$0000
		dc.w	$0303,$0000,$0000,$0000,$30C6,$0000,$0000,$0000
		dc.w	$6183,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$38E0,$0000,$0000,$0000,$E6C0,$0000,$0000,$0000
		dc.w	$C6C0,$0000,$0000,$0000,$CC33,$0000,$0000,$0000
		dc.w	$003C,$0000,$0000,$0000,$3000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0006,$0000,$0000,$0000,$31BF,$0000,$0000,$0000
		dc.w	$0C66,$0000,$0000,$0000,$00D8,$0000,$0000,$0000
		dc.w	$DC0F,$0000,$0000,$0000,$8667,$0000,$0000,$0000
		dc.w	$E1F3,$0000,$0000,$0000,$18C6,$0000,$0000,$0000
		dc.w	$3183,$0000,$0000,$0000,$0737,$0000,$0000,$0000
		dc.w	$38E0,$0000,$0000,$0000,$F6FC,$0000,$0000,$0000
		dc.w	$C6FC,$0000,$0000,$0000,$C631,$0000,$0000,$0000
		dc.w	$9C66,$0000,$0000,$0000,$3000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0006,$0000,$0000,$0000,$3FB0,$0000,$0000,$0000
		dc.w	$0FE6,$0000,$0000,$0000,$0FD8,$0000,$0000,$0000
		dc.w	$0C00,$0000,$0000,$0000,$C60E,$0000,$0000,$0000
		dc.w	$001B,$0000,$0000,$0000,$18C6,$0000,$0000,$0000
		dc.w	$3183,$0000,$0000,$0000,$0737,$0000,$0000,$0000
		dc.w	$38E0,$0000,$0000,$0000,$DEC0,$0000,$0000,$0000
		dc.w	$6CC0,$0000,$0000,$0000,$C631,$0000,$0000,$0000
		dc.w	$8C7E,$0000,$0000,$0000,$3000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0006,$0000,$0000,$0000,$31B0,$0000,$0000,$0000
		dc.w	$0C66,$0000,$0000,$0000,$18D8,$0000,$0000,$0000
		dc.w	$0C08,$0000,$0000,$0000,$C607,$0000,$0000,$0000
		dc.w	$C11B,$0000,$0000,$0000,$F0C7,$0000,$0000,$0000
		dc.w	$E183,$0000,$0000,$0000,$07F7,$0000,$0000,$0000
		dc.w	$38E0,$0000,$0000,$0000,$CEC0,$0000,$0000,$0000
		dc.w	$6CC0,$0000,$0000,$0000,$FC31,$0000,$0000,$0000
		dc.w	$8C60,$0000,$0000,$0000,$3000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0006,$0000,$0000,$0000,$31B0,$0000,$0000,$0000
		dc.w	$0C66,$0000,$0000,$0000,$58D8,$0000,$0000,$0000
		dc.w	$0C18,$0000,$0000,$0000,$C600,$0000,$0000,$0000
		dc.w	$E31B,$0000,$0000,$0000,$00C6,$0000,$0000,$0000
		dc.w	$C183,$0000,$0000,$0000,$0777,$0000,$0000,$0000
		dc.w	$38E0,$0000,$0000,$0000,$C6C0,$0000,$0000,$0000
		dc.w	$38C0,$0000,$0000,$0000,$D831,$0000,$0000,$0000
		dc.w	$8C63,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0006,$0000,$0000,$0000,$31BF,$0000,$0000,$0000
		dc.w	$8C63,$0000,$0000,$0000,$8FD8,$0000,$0000,$0000
		dc.w	$3F0F,$0000,$0000,$0000,$860F,$0000,$0000,$0000
		dc.w	$C1F3,$0000,$0000,$0000,$03F6,$0000,$0000,$0000
		dc.w	$67E3,$0000,$0000,$0000,$0637,$0000,$0000,$0000
		dc.w	$1E78,$0000,$0000,$0000,$C6FE,$0000,$0000,$0000
		dc.w	$38FE,$0000,$0000,$0000,$CC3F,$0000,$0000,$0000
		dc.w	$3F3E,$0000,$0000,$0000,$3000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0600,$0000,$0000,$0000
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
	incbin	jjblib6.snd
	even
			
******************************************************************

	SECTION	BSS

logopalette:    DS.L 8

BUFF_S0:DS.B      36
BUFF_S1:DS.B      924 
BUFF_S2:DS.B      36
BUFF_S3:DS.B      924 
BUFF_S4:DS.B      960 
BUFF_S5:DS.B      36
BUFF_S6:DS.B      922 

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
	ds.b	160*250
Zorro_screen1_len:	equ	*-start

Zorro_scr2:	ds.l	1

Zorro_screen2:	
	ds.b	256
start2:	
	ds.b	160*250
Zorro_screen2_len:	equ	*-start2

	END
