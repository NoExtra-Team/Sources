* AL_0_vb.PRG

* // Code & Ripp	 : Zorro2		// *
* // Gfx neochrome master: Mister. A/NoExtra	// *
* // Music 		 : Antichrist (chip)	// *
* // Music 		 : Virgill (mod)	// *
* // Release date 	 : 26/01/2006		// *

***********************************************
	opt	o-,W-,d-
***********************************************

	SECTION	TEXT

***********************************************
SEEMACHINE	equ	1 ;	0 = texte & 1 = rien
SEEMYVBL	equ	1 ;	0 = ligne rose & 1 = rien
ok	equ	20*160-40-4
mycolor	equ	$000
decalB	equ	$20
coul0		equ	$730
coul1		equ	$740
coul2		equ	$750
coul3		equ	$760
coul4		equ	$770
coul5		equ	$670
coul6		equ	$570
coul7		equ	$470
coul8		equ	$370
coul9		equ	$270
coul10	equ	$170
coul11	equ	$070
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
	
Begin
	clr.l	-(sp)
	move.w	#32,-(sp)
	trap	#1
	addq.l	#6,sp
	move.l	d0,Save_stack

	bsr	ResetKeyboard

	bsr	Ste_Test
	
	IFEQ	SEEMACHINE
	bsr	AfficheResult
	ENDC
	
	bsr	Init_screens
	bsr	SaveVBI
	bsr	fadein
	bsr	Save_and_init_a_st

* # Part 0 :

	bsr	Init_Part0
	
* # Part 1 :

	move.w	#1,TestScreen
	
	bsr	Init_Part1

	bsr	PutSmallTexte
	
	BSR	CLEAR_POSITION
	BSR	INIT_TEXTE

******************************************************************************
Main_rout:
	bsr	Wait_vbl
	
	IFEQ	SEEMYVBL
	clr.w	$ffff8240.w
	ENDC

	cmp.b	#$45,MACHINE
	beq	ste_play
	movem.l	a0-a6/d0-d7,-(sp)
	jsr (musik+8)
	movem.l	(sp)+,a0-a6/d0-d7
	bra	next_mus
ste_play:
	jsr	mod_rout+4
	jsr	mod_rout+6
next_mus:
	
	BSR       Check
	BSR       PutPosition
	BSR       PutBuffer

	bsr	effetmirroir

	IFEQ	SEEMYVBL
	cmp.b	#$38,$fffffc02.w	* Wait
	bne.s	Suite_rout		* Alt
	move.b	#$7,$ffff8240.w
Suite_rout:	
	ENDC
	cmp.b	#$39,$fffffc02.w	* Wait
	bne.s	Main_rout		* Space
	
******************************************************************************

	bsr	RestoreVBI
	bsr	Restore_st
	bsr	SoundOff

	bsr	ResetKeyboard

falcon:
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
      MOVE.W    #0,$FFFF8240.W    
      MOVEM.L   A0/D0,-(A7) 
      MOVE      SR,-(A7)
      MOVE      #$2700,SR 
      MOVE.L    #1426-1,D0
.loop:DBF       D0,.loop
      MOVE.B    #0,$FFFF820A.W
      MOVEQ     #4,D0 
.sync:DBF       D0,.sync
      MOVE.B    #2,$FFFF820A.W
      MOVE      (A7)+,SR
      MOVEM.L   (A7)+,A0/D0 

      st	      Vsync

      CLR.B     $FFFFFA1B.W 

      cmp.w	    #1,TestScreen
      bne.s	    .NoGood
      MOVE.B    #$3B-decalB+40+8,$FFFFFA21.W
      MOVE.L    #HBL,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
.NoGood:    
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

debut	equ	160*70
ok2	  equ	15*160-10

PalLogo:
	dc.w	$0000,$0FFF,$0677,$0DEE,$0566,$0CDD,$0455,$0BCC
	dc.w	$0344,$0ABB,$0233,$09AA,$0122,$0899,$0011,$0FFF

Init_Part0:
	movem.l	d0-d7/a0-a6,-(a7)

	cmp.b	#$45,MACHINE
	beq	ste_activate
	lea	PalLogo(pc),a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)
	bra	end_fx
ste_activate:
	lea     PalLogo,a2
	bsr     fadeon	
end_fx:		

	movea.l	Zorro_scr1,a1
	lea	debut(a1),a1
	movea.l	#IMG_INTRO,a0
	move.l	#ok2,d0
.aff:	move.l	(a0)+,(a1)+
	dbf	d0,.aff

	clr.w	$ffff8240.w

	cmp.b	#$45,MACHINE
	beq	ste_on

	moveq #1,d0
	jsr musik		; activate first tune

	move.l	#$BF,d0
.att0:	
	bsr	wart
	cmp.b	#$39,$fffffc02.w	* Wait
	beq.s	.suite		* Space	
	dbf	d0,.att0
.suite:	
	
	bra	end_init
ste_on:
	moveq	#1,d0		* 6.25 Khz
	moveq	#0,d1		* double frequency
	jsr	mod_rout
	lea	module,a0
	lea	modulend,a1
	jsr	mod_rout+2
end_init:

	STOP      #$2300

	move.w	#$25,-(a7)
	trap	#14
	addq.w	#2,a7
		
	lea	Vbl(pc),a0
	move.l	a0,$70.w
	
	movem.l	(a7)+,d0-d7/a0-a6	
	
	rts

Init_Part1:
	movem.l	d0-d7/a0-a6,-(a7)
	
* // fill screen with junk, to show effect
	movea.l	Zorro_scr1,a0
	move.w	#screen_len/4-1,d1
fill:
	move.l	#$0,(a0)+
	dbra	d1,fill

	movea.l	Zorro_scr1,a1
	movea.l	#IMG_LOGO,a0
	move.l	#ok,d0
.aff:	move.l	(a0)+,(a1)+
	dbf	d0,.aff

	lea	Pal,a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

	movem.l	(a7)+,d0-d7/a0-a6
		
	rts
		
************************************************
*                                              *
************************************************

Save_and_init_a_st:
	move	#$2700,sr

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

	CLR.B     $FFFFFA07.W 
	CLR.B     $FFFFFA09.W 
	CLR.B     $FFFFFA1B.W 
	ORI.B     #1,$FFFFFA07.W
	ORI.B     #1,$FFFFFA13.W

	stop	#$2300

	move.b	$484.w,conterm	; Sauve ce bidule.
	clr.b	$484.w		; No bip,no repeat.
	
	move.b	#$12,$fffffc02.w	* Couic la souris	
	
	DC.W $A000 ; lineA
	DC.W $A00A
		
	rts

ResetKeyboard:
	btst	#0,$fffffc00.w
	beq.s	Flush_ok
	move.b	$fffffc02.w,d0
	bra.s	ResetKeyboard
Flush_ok:
	rts

MACHINE:
	ds.b	$0

Ste_Test:
	move.l	$5a0,a0
	cmp.l	#$0,a0
	beq.s	stf	; Pas de cookie_jar donc un vieux st.
	move.l	$14(a0),d0
	cmp.l	#$0,d0	; _MCH=0 alors c' est un ST-STf.
	beq.s	stf
	cmp.l	#$30000,d0	; _MCH=$30000 alors c' est un Falcon.
	beq	falcon	
ste:
	move.b	#$45,MACHINE
	bra.s	other
stf:
	move.b	#$46,MACHINE
other:
	rts

	IFEQ	SEEMACHINE
gemdos        equ	1
crawcin       equ	7
cconws        equ	9
label	dc.b	'I SEE AN ATARI ST',$0
	even

AfficheResult:
	pea        label       ;Affichage du message
	move.w     #cconws,-(sp)
	trap       #gemdos
	addq.l     #6,sp

	pea        MACHINE       ;Affichage du message
	move.w     #cconws,-(sp)
	trap       #gemdos
	addq.l     #6,sp
					
	move.w     #crawcin,-(sp) ;Attendre appui touche...
	trap       #gemdos
	addq.l     #2,sp
	rts
	ENDC
	
***************************************************************
*                                                             *
*             < Here is the lower border rout >               *
*                                                             *
***************************************************************

HBL:  CLR.B     $FFFFFA1B.W 
      MOVE.B    #8,$FFFFFA21.W
      MOVE.L    #hbl06,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      MOVE      #$2700,SR 
      MOVEM.L   A0/D0,-(A7) 
      LEA       $FFFFFA21.W,A0
      MOVE.B    (A0),D0 
.wait:CMP.B     (A0),D0 
      BEQ.S     .wait 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      MOVE.W    #coul0,$FFFF8248.W *	debut
      MOVE.B    (A0),D0 
.att:CMP.B     (A0),D0 
      BEQ.S     .att 
      MOVEM.L   (A7)+,A0/D0 
      MOVE      #$2300,SR 
      BCLR      #0,$FFFFFA0F.W
      RTE 
      
hbl06:CLR.B     $FFFFFA1B.W 
      MOVE.B    #8,$FFFFFA21.W
      MOVE.L    #hbl07,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      MOVE      #$2700,SR 
      MOVEM.L   A0/D0,-(A7) 
      LEA       $FFFFFA21.W,A0
      MOVE.B    (A0),D0 
.wait:CMP.B     (A0),D0 
      BEQ.S     .wait 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      MOVE.W    #coul1,$FFFF8248.W 
      MOVE.B    (A0),D0 
.att:CMP.B     (A0),D0 
      BEQ.S     .att 
      MOVEM.L   (A7)+,A0/D0 
      MOVE      #$2300,SR 
      BCLR      #0,$FFFFFA0F.W
      RTE 
      
hbl07:CLR.B     $FFFFFA1B.W 
      MOVE.B    #8,$FFFFFA21.W
      MOVE.L    #hbl08,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      MOVE      #$2700,SR 
      MOVEM.L   A0/D0,-(A7) 
      LEA       $FFFFFA21.W,A0
      MOVE.B    (A0),D0 
.wait:CMP.B     (A0),D0 
      BEQ.S     .wait 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      MOVE.W    #coul2,$FFFF8248.W 
      MOVE.B    (A0),D0 
.att:CMP.B     (A0),D0 
      BEQ.S     .att 
      MOVEM.L   (A7)+,A0/D0 
      MOVE      #$2300,SR 
      BCLR      #0,$FFFFFA0F.W
      RTE 
      
hbl08:CLR.B     $FFFFFA1B.W 
      MOVE.B    #8,$FFFFFA21.W
      MOVE.L    #hbl09,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      MOVE      #$2700,SR 
      MOVEM.L   A0/D0,-(A7) 
      LEA       $FFFFFA21.W,A0
      MOVE.B    (A0),D0 
.wait:CMP.B     (A0),D0 
      BEQ.S     .wait 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      MOVE.W    #coul3,$FFFF8248.W 
      MOVE.B    (A0),D0 
.att:CMP.B     (A0),D0 
      BEQ.S     .att 
      MOVEM.L   (A7)+,A0/D0 
      MOVE      #$2300,SR 
      BCLR      #0,$FFFFFA0F.W
      RTE 
      
hbl09:CLR.B     $FFFFFA1B.W 
      MOVE.B    #8,$FFFFFA21.W
      MOVE.L    #hbl10,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      MOVE      #$2700,SR 
      MOVEM.L   A0/D0,-(A7) 
      LEA       $FFFFFA21.W,A0
      MOVE.B    (A0),D0 
.wait:CMP.B     (A0),D0 
      BEQ.S     .wait 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      MOVE.W    #coul4,$FFFF8248.W 
      MOVE.B    (A0),D0 
.att:CMP.B     (A0),D0 
      BEQ.S     .att 
      MOVEM.L   (A7)+,A0/D0 
      MOVE      #$2300,SR 
      BCLR      #0,$FFFFFA0F.W
      RTE 
      
hbl10:CLR.B     $FFFFFA1B.W 
      MOVE.B    #8,$FFFFFA21.W
      MOVE.L    #hbl11,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      MOVE      #$2700,SR 
      MOVEM.L   A0/D0,-(A7) 
      LEA       $FFFFFA21.W,A0
      MOVE.B    (A0),D0 
.wait:CMP.B     (A0),D0 
      BEQ.S     .wait 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      MOVE.W    #coul5,$FFFF8248.W 
      MOVE.B    (A0),D0 
.att:CMP.B     (A0),D0 
      BEQ.S     .att 
      MOVEM.L   (A7)+,A0/D0 
      MOVE      #$2300,SR 
      BCLR      #0,$FFFFFA0F.W
      RTE 
      
hbl11:CLR.B     $FFFFFA1B.W 
      MOVE.B    #8,$FFFFFA21.W
      MOVE.L    #hbl12,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      MOVE      #$2700,SR 
      MOVEM.L   A0/D0,-(A7) 
      LEA       $FFFFFA21.W,A0
      MOVE.B    (A0),D0 
.wait:CMP.B     (A0),D0 
      BEQ.S     .wait 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      MOVE.W    #coul6,$FFFF8248.W 
      MOVE.B    (A0),D0 
.att:CMP.B     (A0),D0 
      BEQ.S     .att 
      MOVEM.L   (A7)+,A0/D0 
      MOVE      #$2300,SR 
      BCLR      #0,$FFFFFA0F.W
      RTE 
      
hbl12:CLR.B     $FFFFFA1B.W 
      MOVE.B    #8,$FFFFFA21.W
      MOVE.L    #hbl13,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      MOVE      #$2700,SR 
      MOVEM.L   A0/D0,-(A7) 
      LEA       $FFFFFA21.W,A0
      MOVE.B    (A0),D0 
.wait:CMP.B     (A0),D0 
      BEQ.S     .wait 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      MOVE.W    #coul7,$FFFF8248.W 
      MOVE.B    (A0),D0 
.att:CMP.B     (A0),D0 
      BEQ.S     .att 
      MOVEM.L   (A7)+,A0/D0 
      MOVE      #$2300,SR 
      BCLR      #0,$FFFFFA0F.W
      RTE 
      
hbl13:CLR.B     $FFFFFA1B.W 
      MOVE.B    #8,$FFFFFA21.W
      MOVE.L    #hbl14,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      MOVE      #$2700,SR 
      MOVEM.L   A0/D0,-(A7) 
      LEA       $FFFFFA21.W,A0
      MOVE.B    (A0),D0 
.wait:CMP.B     (A0),D0 
      BEQ.S     .wait 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      MOVE.W    #coul8,$FFFF8248.W 
      MOVE.B    (A0),D0 
.att:CMP.B     (A0),D0 
      BEQ.S     .att 
      MOVEM.L   (A7)+,A0/D0 
      MOVE      #$2300,SR 
      BCLR      #0,$FFFFFA0F.W
      RTE 
      
hbl14:CLR.B     $FFFFFA1B.W 
      MOVE.B    #8,$FFFFFA21.W
      MOVE.L    #hbl15,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      MOVE      #$2700,SR 
      MOVEM.L   A0/D0,-(A7) 
      LEA       $FFFFFA21.W,A0
      MOVE.B    (A0),D0 
.wait:CMP.B     (A0),D0 
      BEQ.S     .wait 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      MOVE.W    #coul9,$FFFF8248.W 
      MOVE.B    (A0),D0 
.att:CMP.B     (A0),D0 
      BEQ.S     .att 
      MOVEM.L   (A7)+,A0/D0 
      MOVE      #$2300,SR 
      BCLR      #0,$FFFFFA0F.W
      RTE 
      
hbl15:CLR.B     $FFFFFA1B.W 
      MOVE.B    #8,$FFFFFA21.W
      MOVE.L    #hbl16,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      MOVE      #$2700,SR 
      MOVEM.L   A0/D0,-(A7) 
      LEA       $FFFFFA21.W,A0
      MOVE.B    (A0),D0 
.wait:CMP.B     (A0),D0 
      BEQ.S     .wait 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      MOVE.W    #coul10,$FFFF8248.W 
      MOVE.B    (A0),D0 
.att:CMP.B     (A0),D0 
      BEQ.S     .att 
      MOVEM.L   (A7)+,A0/D0 
      MOVE      #$2300,SR 
      BCLR      #0,$FFFFFA0F.W
      RTE 
      
hbl16:CLR.B     $FFFFFA1B.W 
      MOVE.B    #8+25+decalB,$FFFFFA21.W
      MOVE.L    #hbl21,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      MOVE      #$2700,SR 
      MOVEM.L   A0/D0,-(A7) 
      LEA       $FFFFFA21.W,A0
      MOVE.B    (A0),D0 
.wait:CMP.B     (A0),D0 
      BEQ.S     .wait 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      MOVE.W    #coul11,$FFFF8248.W 
      MOVE.B    (A0),D0 
.att:CMP.B     (A0),D0 
      BEQ.S     .att 
      MOVEM.L   (A7)+,A0/D0 
      MOVE      #$2300,SR 
      BCLR      #0,$FFFFFA0F.W
      RTE     
            
hbl21:MOVE.W    #$001,$FFFF8240.W
      CLR.B     $FFFFFA1B.W 
      MOVEM.L   A0/D0,-(A7) 
      MOVEA.W   #$FA21,A0 
      MOVE.B    #$28,(A0) 
      MOVE.L    #hblfin,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      MOVE.B    (A0),D0 
.wait:CMP.B     (A0),D0 
      BEQ       .wait 
      CLR.B     $FFFF820A.W 
      MOVEQ     #2,D0 
.att:NOP 
      DBF       D0,.att
      MOVE.B    #2,$FFFF820A.W
      MOVEM.L   (A7)+,A0/D0 
      
      dcb.w     2280,$4e71                   ; 2280 nops
	
      move.l	  #$0010223,$ffff8240.w
      RTE 

hblfin:
      movem.l	d0-d7,-(sp)
      MOVEM.L   PAL,D0-D7 
      MOVEM.L   D0-D7,$FFFF8240.W 
      movem.l	(sp)+,d0-d7
      CLR.B     $FFFFFA1B.W 
      BCLR      #0,$FFFFFA0F.W
      RTE 

***************************************************************
*                                                             *
***************************************************************

Restore_st:
* Sorry for the next lines, but sometimes there somes syncs error !!

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

************************************************
*                                              *
************************************************

Init_screens:	movem.l	d0-d7/a0-a6,-(a7)

	move.l	#Zorro_screen1,d0
	add.w	#$ff,d0
	sf	d0
	move.l	d0,Zorro_scr1

* // fill screen with junk, to show effect
	movea.l	Zorro_scr1,a0
	move.w	#screen_len/4-1,d1
.fill:
	move.l	#$0,(a0)+
	dbra	d1,.fill

	movem.l	(a7)+,d0-d7/a0-a6
	rts

SaveVBI:
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
	
RestoreVBI:
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

***************************************
SoundOff:

	cmp.b	#$45,MACHINE
	beq	ste_off

	moveq #0,d0
	jsr musik		; desactivate tune
	
	bra	end_init_end
ste_off:
	jsr	mod_rout+8			* Zik off
end_init_end:

	lea	$ffff8800.w,a0
	move.l	#$8080000,(a0)
	move.l	#$9090000,(a0)
	move.l	#$a0a0000,(a0)
	rts

* # Texte ecran :
PutSmallTexte
      LEA       TEXTE,A0
      MOVEA.L   Zorro_scr1,A1
      lea       160*48(a1),a1
      ADDA.L    #160*32,A1
      LEA       BUFFER2,A4
      MOVE.L    A1,(A4) 
      LEA       BUFFER1,A4
      MOVE.L    #1,(A4) 
NEW_C:MOVEQ     #0,D2
      MOVEQ     #0,D3
      MOVE.B    (A0),D2 
      ADDA.L    #1,A0 
      CMP.B     #1,D2 
      BNE.S     CAL_C 
      LEA       BUFFER2,A4
      ADDI.L    #160*8,(A4)
      MOVEA.L   (A4),A1 
      LEA       BUFFER1,A4
      MOVE.L    #1,(A4) 
      BRA.S     NEW_C 
CAL_C:CMP.B     #0,D2 
      BEQ       FinDuTexte 
      CMP.B     #90+1,D2
      BGE.S     NEXT_C 
      CMP.B     #64,D2 
      BLE.S     LIG2_C 
      SUBI.B    #64+1,D2 
      MOVE.B    D2,D3 
      ADDI.B    #1,D3 
      DIVU      #2,D2 
      DIVU      #2,D3 
      CMP.B     D2,D3 
      BNE.S     LIG_C 
      MULU      #8,D2 
      ADDI.L    #160*8,D2
      BRA.S     PUT_C 
LIG_C:MULU      #8,D2 
      ADDI.L    #160*8+1,D2
      BRA.S     PUT_C 
LIG2_C:CMP.B    #32,D2 
      BLE.S     NEXT_C 
      SUBI.B    #32+1,D2 
      MOVE.B    D2,D3 
      ADDI.B    #1,D3 
      DIVU      #2,D2 
      DIVU      #2,D3 
      CMP.B     D2,D3 
      BNE.S     PREP_C 
      MULU      #8,D2 
      BRA.S     PUT_C 
PREP_C:MULU      #8,D2 
      ADDI.L    #1,D2 
      BRA.S     PUT_C 
NEXT_C:MOVE.L    #144,D2
PUT_C:LEA       FONTE8_8,A2
      ADDA.L    D2,A2 
      MOVEA.L   A1,A3 
      MOVEQ     #7,D2 
.loop:MOVE.B    (A2),(A3) 
      MOVE.B    2(A2),2(A3) 
      MOVE.B    4(A2),4(A3) 
      MOVE.B    6(A2),6(A3) 
      LEA       160(A2),A2
      LEA       160(A3),A3
      DBF       D2,.loop
      LEA       BUFFER1,A4
      ADDA.L    (A4),A1 
      EORI.L    #6,(A4) 
      BRA       NEW_C
FinDuTexte:      
	rts

* # Scrolling Y :
CLEAR_POSITION:
      LEA       POSITION,A0
      MOVE.W    #160*30+15*8,D0
.loop:CLR.B     (A0)+ 
      DBF       D0,.loop
      RTS 

INIT_TEXTE:
      LEA       TEXTEs,A0
      LEA       CARAC1,A1
      SUBA.W    A0,A1 
      MOVE.W    A1,ADR_TEXTE
      ADDQ.W    #1,ADR_TEXTE
      LEA       TEXTEs,A0
.loop:MOVE.B    (A0),D0 
      SUBI.B    #$20,D0 
      MOVE.B    D0,(A0)+
      CMPI.B    #$3B,D0 
      BNE       .loop 
      RTS 

Check:CMPI.W    #0,CPT_0
      BNE.S     PutCarac 
      RTS 

PutCarac:
      CMPI.W    #0,CPT_1
      BNE.S     .next 
      MOVE.W    CPT_0(PC),D1
      MOVEQ.W   #16,D2 
      DIVU      D1,D2 
      MOVE.W    D2,CPT_1
      CMPI.W    #1,CPT_2
      BEQ.S     IncCompteur 
      BSR       Vague_1 
.next:SUBI.W    #1,CPT_1
      RTS 
      
IncCompteur:
      BSR       Vague_2 
      SUBI.W    #1,CPT_1
      RTS 

      
Vague_1:
      LEA       TEXTEs,A0
      LEA       FONTE,A1
      LEA       POSITION,A2
      MOVE.W    CARAC(PC),D0
      SUBI.W    #24-1,D0 
      MOVEQ     #0,D1 
      MOVE.B    0(A0,D0.W),D1 
      CMPI.W    #0,CARAC
      BNE.S     .next 
      MOVE.W    ADR_TEXTE,CARAC 
.next:SUBQ.W    #1,CARAC
      ADD.W D1,D1
      ADD.W D1,D1
      MOVEA.L   0(A1,D1.W),A3 
      MOVE.W    (A3),(A2) 
      MOVE.W    160(A3),164(A2) 
      MOVE.W    320(A3),328(A2) 
      MOVE.W    480(A3),492(A2) 
      MOVE.W    640(A3),656(A2) 
      MOVE.W    800(A3),820(A2) 
      MOVE.W    960(A3),984(A2) 
      MOVE.W    1120(A3),1148(A2) 
      MOVE.W    1280(A3),1312(A2) 
      MOVE.W    1440(A3),1476(A2) 
      MOVE.W    1600(A3),1640(A2) 
      MOVE.W    1760(A3),1804(A2) 
      MOVE.W    1920(A3),1968(A2) 
      MOVE.W    2080(A3),2132(A2) 
      MOVE.W    2240(A3),2296(A2) 
      MOVE.W    2400(A3),2460(A2) 
      RTS 
      
Vague_2:LEA       TEXTEs,A0
      LEA       FONTE,A1
      LEA       POSITION,A2
.raz: MOVE.W CARAC(PC),D0
      MOVEQ     #0,D1 
      MOVE.B    0(A0,D0.W),D1 
      CMPI.B    #60-1,D1 
      BNE.s     .next 
      CLR.W     CARAC 
      BRA.s     .raz 
.next:ADDQ.W    #1,CARAC
      ADD.W     D1,D1
      ADD.W     D1,D1    
      MOVEA.L   0(A1,D1.W),A3 
      LEA       162(A2),A2
      MOVE.W    (A3),(A2) 
      MOVE.W    160(A3),164(A2) 
      MOVE.W    320(A3),328(A2) 
      MOVE.W    480(A3),492(A2) 
      MOVE.W    640(A3),656(A2) 
      MOVE.W    800(A3),820(A2) 
      MOVE.W    960(A3),984(A2) 
      MOVE.W    1120(A3),1148(A2) 
      MOVE.W    1280(A3),1312(A2) 
      MOVE.W    1440(A3),1476(A2) 
      MOVE.W    1600(A3),1640(A2) 
      MOVE.W    1760(A3),1804(A2) 
      MOVE.W    1920(A3),1968(A2) 
      MOVE.W    2080(A3),2132(A2) 
      MOVE.W    2240(A3),2296(A2) 
      MOVE.W    2400(A3),2460(A2) 
      RTS 
      
PutBuffer:
      CMPI.W    #8,CPT_0
      BEQ       ScrollText 
      LEA       BUFFER,A0
      MOVEQ     #16-1,D0
      MOVE.W CPT_0(PC),D2
.loop:MOVE.W    0(A0),D1
      SWAP      D1
      MOVE.W    -2(A0),D1 
      ROL.L     D2,D1 
      MOVE.W    D1,-2(A0) 
      MOVE.W    8(A0),D1
      SWAP      D1
      MOVE.W    0(A0),D1
      ROL.L     D2,D1 
      MOVE.W    D1,0(A0)
      MOVE.W    16(A0),D1 
      SWAP      D1
      MOVE.W    8(A0),D1
      ROL.L     D2,D1 
      MOVE.W    D1,8(A0)
      MOVE.W    24(A0),D1 
      SWAP      D1
      MOVE.W    16(A0),D1 
      ROL.L     D2,D1 
      MOVE.W    D1,16(A0) 
      MOVE.W    32(A0),D1 
      SWAP      D1
      MOVE.W    24(A0),D1 
      ROL.L     D2,D1 
      MOVE.W    D1,24(A0) 
      MOVE.W    40(A0),D1 
      SWAP      D1
      MOVE.W    32(A0),D1 
      ROL.L     D2,D1 
      MOVE.W    D1,32(A0) 
      MOVE.W    48(A0),D1 
      SWAP      D1
      MOVE.W    40(A0),D1 
      ROL.L     D2,D1 
      MOVE.W    D1,40(A0) 
      MOVE.W    56(A0),D1 
      SWAP      D1
      MOVE.W    48(A0),D1 
      ROL.L     D2,D1 
      MOVE.W    D1,48(A0) 
      MOVE.W    64(A0),D1 
      SWAP      D1
      MOVE.W    56(A0),D1 
      ROL.L     D2,D1 
      MOVE.W    D1,56(A0) 
      MOVE.W    72(A0),D1 
      SWAP      D1
      MOVE.W    64(A0),D1 
      ROL.L     D2,D1 
      MOVE.W    D1,64(A0) 
      MOVE.W    80(A0),D1 
      SWAP      D1
      MOVE.W    72(A0),D1 
      ROL.L     D2,D1 
      MOVE.W    D1,72(A0) 
      MOVE.W    88(A0),D1 
      SWAP      D1
      MOVE.W    80(A0),D1 
      ROL.L     D2,D1 
      MOVE.W    D1,80(A0) 
      MOVE.W    96(A0),D1 
      SWAP      D1
      MOVE.W    88(A0),D1 
      ROL.L     D2,D1 
      MOVE.W    D1,88(A0) 
      MOVE.W    104(A0),D1
      SWAP      D1
      MOVE.W    96(A0),D1 
      ROL.L     D2,D1 
      MOVE.W    D1,96(A0) 
      MOVE.W    112(A0),D1
      SWAP      D1
      MOVE.W    104(A0),D1
      ROL.L     D2,D1 
      MOVE.W    D1,104(A0)
      MOVE.W    120(A0),D1
      SWAP      D1
      MOVE.W    112(A0),D1
      ROL.L     D2,D1 
      MOVE.W    D1,112(A0)
      MOVE.W    128(A0),D1
      SWAP      D1
      MOVE.W    120(A0),D1
      ROL.L     D2,D1 
      MOVE.W    D1,120(A0)
      MOVE.W    136(A0),D1
      SWAP      D1
      MOVE.W    128(A0),D1
      ROL.L     D2,D1 
      MOVE.W    D1,128(A0)
      MOVE.W    144(A0),D1
      SWAP      D1
      MOVE.W    136(A0),D1
      ROL.L     D2,D1 
      MOVE.W    D1,136(A0)
      MOVE.W    152(A0),D1
      SWAP      D1
      MOVE.W    144(A0),D1
      ROL.L     D2,D1 
      MOVE.W    D1,144(A0)
      MOVE.W    160(A0),D1
      SWAP      D1
      MOVE.W    152(A0),D1
      ROL.L     D2,D1 
      MOVE.W    D1,152(A0)
      MOVE.W    160(A0),D1
      ROL.L     D2,D1 
      MOVE.W    D1,160(A0)
      LEA       164(A0),A0
      DBF       D0,.loop
      RTS 

ScrollText:
      LEA       BUFFER,A0
      MOVEQ     #16-1,D0
.loop:MOVE.B    -1(A0),-2(A0) 
      MOVE.B    0(A0),-1(A0)
      MOVE.B    1(A0),0(A0) 
      MOVE.B    8(A0),1(A0) 
      MOVE.B    9(A0),8(A0) 
      MOVE.B    16(A0),9(A0)
      MOVE.B    17(A0),16(A0) 
      MOVE.B    24(A0),17(A0) 
      MOVE.B    25(A0),24(A0) 
      MOVE.B    32(A0),25(A0) 
      MOVE.B    33(A0),32(A0) 
      MOVE.B    40(A0),33(A0) 
      MOVE.B    41(A0),40(A0) 
      MOVE.B    48(A0),41(A0) 
      MOVE.B    49(A0),48(A0) 
      MOVE.B    56(A0),49(A0) 
      MOVE.B    57(A0),56(A0) 
      MOVE.B    64(A0),57(A0) 
      MOVE.B    65(A0),64(A0) 
      MOVE.B    72(A0),65(A0) 
      MOVE.B    73(A0),72(A0) 
      MOVE.B    80(A0),73(A0) 
      MOVE.B    81(A0),80(A0) 
      MOVE.B    88(A0),81(A0) 
      MOVE.B    89(A0),88(A0) 
      MOVE.B    96(A0),89(A0) 
      MOVE.B    97(A0),96(A0) 
      MOVE.B    104(A0),97(A0)
      MOVE.B    105(A0),104(A0) 
      MOVE.B    112(A0),105(A0) 
      MOVE.B    113(A0),112(A0) 
      MOVE.B    120(A0),113(A0) 
      MOVE.B    121(A0),120(A0) 
      MOVE.B    128(A0),121(A0) 
      MOVE.B    129(A0),128(A0) 
      MOVE.B    136(A0),129(A0) 
      MOVE.B    137(A0),136(A0) 
      MOVE.B    144(A0),137(A0) 
      MOVE.B    145(A0),144(A0) 
      MOVE.B    152(A0),145(A0) 
      MOVE.B    153(A0),152(A0) 
      MOVE.B    160(A0),153(A0) 
      MOVE.B    161(A0),160(A0) 
      LEA       164(A0),A0
      DBF       D0,.loop
      RTS 

PutPosition:
      MOVEA.L   PTR_COURBE,A4
      LEA       4(A4),A4
      CMPI.W    #-1,(A4) 
      BNE.S     .next 
      LEA       COURBE,A4
.next:MOVE.L    A4,PTR_COURBE
      MOVEA.L   Zorro_scr1,A3
      LEA       160*193(A3),A3
      LEA       POSITION,A2
      MOVEQ     #20-1,D0 
      MOVEQ     #0,D6 
.loop:LEA       0(A3,D6.W),A1 
      MOVEA.L   A1,A5 
      LEA       1(A5),A5
      ADDA.W    (A4)+,A1
      CMPI.W    #-1,(A4) 
      BNE.S     .suivant 
      LEA       COURBE,A4
.suivant:
      ADDA.W    (A4)+,A5
      CLR.B     0(A1) 
      CLR.B     0(A5) 
      CLR.B     160(A1) 
      CLR.B     160(A5) 
      CLR.B     320(A1) 
      CLR.B     320(A5) 
      CLR.B     480(A1) 
      CLR.B     480(A5) 
      CLR.B     640(A1) 
      CLR.B     640(A5) 
      CLR.B     800(A1) 
      CLR.B     800(A5) 
      MOVE.B    2(A2),960(A1) 
      MOVE.B    3(A2),960(A5) 
      MOVE.B    166(A2),1120(A1)
      MOVE.B    167(A2),1120(A5)
      MOVE.B    330(A2),1280(A1)
      MOVE.B    331(A2),1280(A5)
      MOVE.B    494(A2),1440(A1)
      MOVE.B    495(A2),1440(A5)
      MOVE.B    658(A2),1600(A1)
      MOVE.B    659(A2),1600(A5)
      MOVE.B    822(A2),1760(A1)
      MOVE.B    823(A2),1760(A5)
      MOVE.B    986(A2),1920(A1)
      MOVE.B    987(A2),1920(A5)
      MOVE.B    1150(A2),2080(A1) 
      MOVE.B    1151(A2),2080(A5) 
      MOVE.B    1314(A2),2240(A1) 
      MOVE.B    1315(A2),2240(A5) 
      MOVE.B    1478(A2),2400(A1) 
      MOVE.B    1479(A2),2400(A5) 
      MOVE.B    1642(A2),2560(A1) 
      MOVE.B    1643(A2),2560(A5) 
      MOVE.B    1806(A2),2720(A1) 
      MOVE.B    1807(A2),2720(A5) 
      MOVE.B    1970(A2),2880(A1) 
      MOVE.B    1971(A2),2880(A5) 
      MOVE.B    2134(A2),3040(A1) 
      MOVE.B    2135(A2),3040(A5) 
      MOVE.B    2298(A2),3200(A1) 
      MOVE.B    2299(A2),3200(A5) 
      MOVE.B    2462(A2),3360(A1) 
      MOVE.B    2463(A2),3360(A5) 
      MOVE.B    2626(A2),3520(A1) 
      MOVE.B    2627(A2),3520(A5) 
      CLR.B     3680(A1)
      CLR.B     3680(A5)
      CLR.B     3840(A1)
      CLR.B     3840(A5)
      CLR.B     4000(A1)
      CLR.B     4000(A5)
      CLR.B     4160(A1)
      CLR.B     4160(A5)
      CLR.B     4320(A1)
      CLR.B     4320(A5)
      LEA       8(A2),A2
      ADDQ.W    #8,D6 
      DBF       D0,.loop
      RTS 

* # Effet mirroir sur le texte :
effetmirroir:
	movem.l	d0-a6,-(sp)
	movea.l	Zorro_scr1,a0
	lea	160*200(a0),a0
	lea	160*47(a0),a0
	movea.l	a0,a1
	moveq.w	#20,d6
.boucle:
	rept	40
	move.l	(a0)+,(a1)+
	endr
	lea	-$140(a0),a0
	dbra	d6,.boucle
	movem.l	(sp)+,d0-a6
	rts

* # Fade noir -> pal logo :
fadeon:
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
	bsr.s	wart
	dbra	d0,.loop1	Next stage
	rts
	
* # Fade blanc -> noir en intro :
fadein:
	move.l	#$777,d0
deg	
	rept	3
	bsr.s	wart
	endr
	lea	$ffff8240.w,a0
	moveq	#15,d1
chg1	
	move.w	d0,(a0)+
	dbf	d1,chg1
	sub.w	#$111,d0
	bne.s	deg
	rts

wart:	
	move.l	d0,-(sp)
	move.l	$466.w,d0
.att:	
	cmp.l	$466.w,d0
	beq.s	.att
	move.l	(sp)+,d0
	rts

******************************************************************

	SECTION	DATA

TestScreen:	
	dc.w	$0

Pal:
	dc.w	$0000,$0EEE,$0889,$0012,$0556,$0123,$0001,$0233
	dc.w	$0344,$0ABB,$0234,$0800,$089A,$0000,$0BCC,$0223

IMG_LOGO:
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0007,$0007,$0007,$0007,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$8000,$8000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0007,$0007,$0004,$0004,$7FFF,$FFFF,$0000,$8000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$8000,$0000,$8000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0004,$0007,$0004,$0007,$1400,$6780,$9880,$6800
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$8000,$0000,$8000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$8000,$0000,$8000
		dc.w	$0000,$0000,$0000,$0000,$004F,$0063,$001F,$0053
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$E427,$8C31,$F00F,$9429
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$F213,$C618,$F807,$CA14
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$F909,$E30C,$FC03,$E50A
		dc.w	$FFFF,$7FFF,$FFFF,$7FFF,$FC8F,$F18F,$FE0F,$F28F
		dc.w	$FFE0,$FFE0,$FFE0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$8000,$0000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00FF,$00DF,$003F,$009F
		dc.w	$FF3F,$FF3F,$FF3F,$FEDF,$FE7F,$F66F,$F81F,$F24F
		dc.w	$FF9F,$FF9F,$FF9F,$FF6F,$FF3F,$FB37,$FC0F,$F927
		dc.w	$FFCF,$FFCF,$FFCF,$FFB7,$FF9F,$FD9B,$FE07,$FC93
		dc.w	$FFE7,$FFE7,$FFE7,$FFDB,$FFCF,$FECF,$FF0F,$FE4F
		dc.w	$FFE0,$FFE0,$FFE0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$8000,$8000
		dc.w	$0000,$0000,$0000,$0000,$007F,$00BF,$007F,$003F
		dc.w	$FF5F,$FE7F,$FF9F,$FE9F,$FC3F,$FA5F,$FC3F,$F81F
		dc.w	$FFAF,$FF3F,$FFCF,$FF4F,$FE1F,$FD2F,$FE1F,$FC0F
		dc.w	$FFD7,$FF9F,$FFE7,$FFA7,$FF0F,$FE97,$FF0F,$FE07
		dc.w	$FFEB,$FFCF,$FFF3,$FFD3,$FF8F,$FF4F,$FF8F,$FF0F
		dc.w	$FFE0,$FFE0,$FFE0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$8000,$8000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$007F,$007F,$00FF,$00FF
		dc.w	$FF5F,$FE7F,$FF9F,$FE9F,$FC3F,$FC3F,$FE7F,$FE7F
		dc.w	$FFAF,$FF3F,$FFCF,$FF4F,$FE1F,$FE1F,$FF3F,$FF3F
		dc.w	$FFD7,$FF9F,$FFE7,$FFA7,$FF0F,$FF0F,$FF9F,$FF9F
		dc.w	$FFEB,$FFCF,$FFF3,$FFD3,$FF8F,$FF8F,$FFCF,$FFCF
		dc.w	$FFE0,$FFE0,$FFE0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$8000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00FF,$007F,$00FF,$007F
		dc.w	$FF5F,$FE7F,$FF9F,$FE9F,$FE7F,$FC3F,$FE7F,$FC3F
		dc.w	$FFAF,$FF3F,$FFCF,$FF4F,$FF3F,$FE1F,$FF3F,$FE1F
		dc.w	$FFD7,$FF9F,$FFE7,$FFA7,$FF9F,$FF0F,$FF9F,$FF0F
		dc.w	$FFEB,$FFCF,$FFF3,$FFD3,$FFCF,$FF8F,$FFCF,$FF8F
		dc.w	$FFE0,$FFE0,$FFE0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$8000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00FF,$007F,$00FF,$007F
		dc.w	$FF5F,$FE7F,$FF9F,$FE9F,$FE58,$FC73,$FE53,$FC6F
		dc.w	$06AF,$333F,$F2CF,$3D4F,$FF3F,$FE1F,$FF3F,$FE1F
		dc.w	$FFD7,$FF9F,$FFE7,$FFA7,$FF9F,$FF0F,$FF9F,$FF0F
		dc.w	$FFEB,$FFCF,$FFF3,$FFD3,$FFCF,$FF8F,$FFCF,$FF8F
		dc.w	$FFE0,$FFE0,$FFE0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$8000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00FF,$00FF,$00FF,$00FF
		dc.w	$FF5F,$FE7F,$FF9F,$FE9F,$FE66,$FE07,$FE78,$FE18
		dc.w	$00AF,$FF3F,$00CF,$004F,$FF3F,$FF3F,$FF3F,$FF3F
		dc.w	$FFD7,$FF9F,$FFE7,$FFA7,$FF9F,$FF9F,$FF9F,$FF9F
		dc.w	$FFEB,$FFCF,$FFF3,$FFD3,$FF8F,$FF8F,$FFCF,$FFCF
		dc.w	$FFE0,$FFE0,$FFE0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00FF,$00FF,$00FF,$00FF
		dc.w	$FE9F,$FEFF,$FF3F,$FF1F,$FE4C,$FE0F,$FE70,$FE30
		dc.w	$00AF,$FF3F,$00CF,$004F,$FF3F,$FF3F,$FF3F,$FF3F
		dc.w	$FFA7,$FFBF,$FFCF,$FFC7,$FF9F,$FF9F,$FF9F,$FF9F
		dc.w	$FFD3,$FFDF,$FFE7,$FFE3,$FF8F,$FF4F,$FF8F,$FF0F
		dc.w	$FFE0,$FFE0,$FFE0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00FF,$00FF,$00FF,$00FF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FE66,$FE07,$FE78,$FE18
		dc.w	$00AF,$FF3F,$00CF,$004F,$FF3F,$FF3F,$FF3F,$FF3F
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FF9F,$FF9F,$FF9F,$FF9F
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFCF,$FECF,$FF0F,$FE4F
		dc.w	$FFE0,$FFE0,$FFE0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00FF,$00FF,$00FF,$00FF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FE4C,$FE0F,$FE70,$FE30
		dc.w	$00AF,$FF3F,$00CF,$004F,$FF3F,$FF3F,$FF3F,$FF3F
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FF9F,$FF9F,$FF9F,$FF9F
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FC8F,$F18F,$FE0F,$F28F
		dc.w	$FFE0,$FFE0,$FFE0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00FF,$00FF,$00FF,$00FF
		dc.w	$FF3F,$FF3F,$FF3F,$FEDF,$FE66,$FE07,$FE78,$FE18
		dc.w	$004F,$FF7F,$009F,$008F,$FF3F,$FF3F,$FF3F,$FF3F
		dc.w	$FFCF,$FFCF,$FFCF,$FFB7,$FF9F,$FF9F,$FF9F,$FF9F
		dc.w	$FFE7,$FFE7,$FFE7,$FFDB,$FFCF,$FECF,$FF0F,$FE4F
		dc.w	$FFE0,$FFE0,$FFE0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00FF,$00FF,$00FF,$00FF
		dc.w	$FF5F,$FE7F,$FF9F,$FE9F,$FE4C,$FE0F,$FE70,$FE30
		dc.w	$000F,$FF0F,$000F,$000F,$FF3F,$FF3F,$FF3F,$FF3F
		dc.w	$FFD7,$FF9F,$FFE7,$FFA7,$FF9F,$FF9F,$FF9F,$FF9F
		dc.w	$FFEB,$FFCF,$FFF3,$FFD3,$FF8F,$FF4F,$FF8F,$FF0F
		dc.w	$FFE0,$FFE0,$FFE0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00FF,$00FF,$00FF,$00FF
		dc.w	$FF5F,$FE7F,$FF9F,$FE9F,$FE66,$FE07,$FE78,$FE18
		dc.w	$000F,$FF0F,$000F,$000F,$FF3F,$FF3F,$FF3F,$FF3F
		dc.w	$FFD7,$FF9F,$FFE7,$FFA7,$FF9F,$FF9F,$FF9F,$FF9F
		dc.w	$FFEB,$FFCF,$FFF3,$FFD3,$FF8F,$FF8F,$FFCF,$FFCF
		dc.w	$FFE0,$FFE0,$FFE0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00FF,$00FF,$00FF,$00FF
		dc.w	$FF5F,$FE7F,$FF9F,$FE9F,$FE4C,$FE0F,$FE70,$FE30
		dc.w	$000F,$FF0F,$000F,$000F,$FF3F,$FF3F,$FF3F,$FF3F
		dc.w	$FFD7,$FF9F,$FFE7,$FFA7,$FF9F,$FF9F,$FF9F,$FF9F
		dc.w	$FFEB,$FFCF,$FFF3,$FFD3,$FFCF,$FF8F,$FFCF,$FF8F
		dc.w	$FFE0,$FFE0,$FFE0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00FF,$00FF,$00FF,$00FF
		dc.w	$FF5F,$FE7F,$FF9F,$FE9F,$FE66,$FE07,$FE78,$FE18
		dc.w	$000F,$FF0F,$000F,$000F,$FF3F,$FF3F,$FF3F,$FF3F
		dc.w	$FFD7,$FF9F,$FFE7,$FFA7,$FF9F,$FF9F,$FF9F,$FF9F
		dc.w	$FFEB,$FFCF,$FFF3,$FFD3,$FFCF,$FF8F,$FFCF,$FF8F
		dc.w	$FFE0,$FFE0,$FFE0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00FF,$00FF,$00FF,$00FF
		dc.w	$FF5F,$FE7F,$FF9F,$FE9F,$FE00,$FE7F,$FE7F,$FE00
		dc.w	$000F,$FF0F,$FF0F,$000F,$FF3F,$FF3F,$FF3F,$FF3F
		dc.w	$FFD7,$FF9F,$FFE7,$FFA7,$FF9F,$FF9F,$FF9F,$FF9F
		dc.w	$FFEB,$FFCF,$FFF3,$FFD3,$FFCF,$FFCF,$FFCF,$FFCF
		dc.w	$FFE0,$FFE0,$FFE0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00FF,$00FF,$00FF,$00FF
		dc.w	$FF5F,$FE7F,$FF9F,$FE9F,$FE00,$FE00,$FE00,$FE00
		dc.w	$000F,$000F,$000F,$000F,$FF3F,$FF3F,$FF3F,$FF3F
		dc.w	$FFD7,$FF9F,$FFE7,$FFA7,$FF9F,$FF9F,$FF9F,$FF9F
		dc.w	$FFEB,$FFCF,$FFF3,$FFD3,$FFCF,$FFCF,$FFCF,$FFCF
		dc.w	$FFE0,$FFE0,$FFE0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00FF,$00FF,$00FF,$00FF
		dc.w	$FF5F,$FE7F,$FF9F,$FE9F,$FE00,$FE00,$FE00,$FE00
		dc.w	$000F,$000F,$000F,$000F,$FF3F,$FF3F,$FF3F,$FF3F
		dc.w	$FFD7,$FF9F,$FFE7,$FFA7,$FF9F,$FF9F,$FF9F,$FF9F
		dc.w	$FFEB,$FFCF,$FFF3,$FFD3,$FFCF,$FFCF,$FFCF,$FFCF
		dc.w	$FFE0,$FFE0,$FFE0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00FF,$00FF,$00FF,$00FF
		dc.w	$FF5F,$FE7F,$FF9F,$FE9F,$FE00,$FE00,$FE00,$FE00
		dc.w	$000F,$000F,$000F,$000F,$FF3F,$FF3F,$FF3F,$FF3F
		dc.w	$FFD7,$FF9F,$FFE7,$FFA7,$FF9F,$FF9F,$FF9F,$FF9F
		dc.w	$FFEB,$FFCF,$FFF3,$FFD3,$FFCF,$FFCF,$FFCF,$FFCF
		dc.w	$FFE0,$FFE0,$FFE0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00B0,$00E6,$00A7,$00DE
		dc.w	$1A9F,$4EFF,$CB3F,$771F,$FE00,$FE00,$FE00,$FE00
		dc.w	$000F,$000F,$000F,$000F,$FF2C,$FF39,$FF29,$FF37
		dc.w	$06A7,$93BF,$F2CF,$9DC7,$FF96,$FF9C,$FF94,$FF9B
		dc.w	$0193,$CCDF,$FCA7,$CF63,$FFCF,$FFCF,$FFCF,$FFCF
		dc.w	$FFE0,$FFE0,$FFE0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00CC,$000F,$00F0,$0030
		dc.w	$001F,$FE1F,$001F,$001F,$FE00,$FE00,$FE00,$FE00
		dc.w	$000F,$000F,$000F,$000F,$FF33,$FF03,$FF3C,$FF0C
		dc.w	$0007,$FF87,$0007,$0007,$FF99,$FF81,$FF9E,$FF86
		dc.w	$8003,$FFC3,$0003,$0003,$FFCB,$FFCE,$FFCA,$FFCD
		dc.w	$00C0,$6660,$7E40,$E7A0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0098,$001F,$00E0,$0060
		dc.w	$001F,$FE1F,$001F,$001F,$FE00,$FE00,$FE00,$FE00
		dc.w	$000F,$000F,$000F,$000F,$FF26,$FF07,$FF38,$FF18
		dc.w	$0007,$FF87,$0007,$0007,$FF93,$FF83,$FF9C,$FF8C
		dc.w	$0003,$FFC3,$0003,$0003,$FFCC,$FFC0,$FFCF,$FFC3
		dc.w	$C000,$FFE0,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00CC,$000F,$00F0,$0030
		dc.w	$001F,$FE1F,$001F,$001F,$FE00,$FE00,$FE00,$FE00
		dc.w	$000F,$000F,$000F,$000F,$FF33,$FF03,$FF3C,$FF0C
		dc.w	$0007,$FF87,$0007,$0007,$FF99,$FF81,$FF9E,$FF86
		dc.w	$8003,$FFC3,$0003,$0003,$FFC9,$FFC1,$FFCE,$FFC6
		dc.w	$8000,$FFE0,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0098,$001F,$00E0,$0060
		dc.w	$0016,$FE1C,$0014,$001B,$1A00,$CE00,$CA00,$F600
		dc.w	$000B,$000E,$000A,$000D,$0D26,$6707,$6538,$FB18
		dc.w	$0005,$FF87,$0005,$0006,$8693,$3383,$329C,$FD8C
		dc.w	$0002,$FFC3,$0002,$0003,$C34C,$99C0,$994F,$7EC3
		dc.w	$C000,$FFE0,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00CC,$000F,$00F0,$0030
		dc.w	$0019,$FE01,$001E,$0006,$8000,$FE00,$0000,$0000
		dc.w	$000C,$0000,$000F,$0003,$C033,$FF03,$003C,$000C
		dc.w	$0006,$FF80,$0007,$0001,$6019,$7F81,$801E,$8006
		dc.w	$8003,$FFC0,$0003,$0000,$3009,$3FC1,$C00E,$C006
		dc.w	$8000,$FFE0,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0098,$001F,$00E0,$0060
		dc.w	$0013,$FE03,$001C,$000C,$0000,$FE00,$0000,$0000
		dc.w	$0009,$0001,$000E,$0006,$8026,$FF07,$0038,$0018
		dc.w	$0004,$FF80,$0007,$0003,$C013,$FF83,$001C,$000C
		dc.w	$0002,$FFC0,$0003,$0001,$600C,$7FC0,$800F,$8003
		dc.w	$C000,$FFE0,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00CC,$000F,$00F0,$0030
		dc.w	$0019,$FE01,$001E,$0006,$8000,$FE00,$0000,$0000
		dc.w	$000C,$0000,$000F,$0003,$C033,$FF03,$003C,$000C
		dc.w	$0006,$FF80,$0007,$0001,$6019,$7F81,$801E,$8006
		dc.w	$8003,$FFC0,$0003,$0000,$3009,$3FC1,$C00E,$C006
		dc.w	$8000,$FFE0,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0098,$001F,$00E0,$0060
		dc.w	$0013,$FE03,$001C,$000C,$0000,$FE00,$0000,$0000
		dc.w	$0009,$0001,$000E,$0006,$8026,$FF07,$0038,$0018
		dc.w	$0004,$FF80,$0007,$0003,$C013,$FF83,$001C,$000C
		dc.w	$0002,$FFC0,$0003,$0001,$600C,$7FC0,$800F,$8003
		dc.w	$C000,$FFE0,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00CC,$000F,$00F0,$0030
		dc.w	$0019,$FE01,$001E,$0006,$8000,$FE00,$0000,$0000
		dc.w	$000C,$0000,$000F,$0003,$C033,$FF03,$003C,$000C
		dc.w	$0006,$FF80,$0007,$0001,$6019,$7F81,$801E,$8006
		dc.w	$8003,$FFC0,$0003,$0000,$3009,$3FC1,$C00E,$C006
		dc.w	$8000,$FFE0,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$00FF,$00FF,$0000
		dc.w	$0013,$FE03,$FE1C,$000C,$0000,$FE00,$0000,$0000
		dc.w	$0009,$0001,$000E,$0006,$8000,$FF3F,$003F,$0000
		dc.w	$0004,$FF80,$FF87,$0003,$C000,$FF9F,$001F,$0000
		dc.w	$0002,$FFC0,$FFC3,$0001,$600C,$7FC0,$800F,$8003
		dc.w	$C000,$FFE0,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0019,$0001,$001E,$0006,$8000,$FE00,$0000,$0000
		dc.w	$000C,$0000,$000F,$0003,$C000,$FF00,$0000,$0000
		dc.w	$0006,$0000,$0007,$0001,$6000,$7F80,$8000,$8000
		dc.w	$0003,$0000,$0003,$0000,$3000,$3FCF,$C00F,$C000
		dc.w	$0000,$FFE0,$FFE0,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0013,$0003,$001C,$000C,$0000,$FE00,$0000,$0000
		dc.w	$0009,$0001,$000E,$0006,$8000,$FF00,$0000,$0000
		dc.w	$0004,$0000,$0007,$0003,$C000,$FF80,$0000,$0000
		dc.w	$0002,$0000,$0003,$0001,$6000,$7FC0,$8000,$8000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0019,$0001,$001E,$0006,$8000,$FE00,$0000,$0000
		dc.w	$000C,$0000,$000F,$0003,$C000,$FF00,$0000,$0000
		dc.w	$0006,$0000,$0007,$0001,$6000,$7F80,$8000,$8000
		dc.w	$0003,$0000,$0003,$0000,$3000,$3FC0,$C000,$C000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$001F,$001F,$0000,$0000,$FE00,$FE00,$0000
		dc.w	$0000,$000F,$000F,$0000,$0000,$FF00,$FF00,$0000
		dc.w	$0000,$0007,$0007,$0000,$0000,$FF80,$FF80,$0000
		dc.w	$0000,$0003,$0003,$0000,$0000,$FFC0,$FFC0,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0007,$0007,$0007
		dc.w	$FFF0,$FFF0,$FFF0,$FFF0,$0001,$0001,$0000,$0001
		dc.w	$3FFF,$8FFF,$7FFF,$4FFF,$FFF8,$FFF8,$FFF8,$FFF8
		dc.w	$9FFF,$C7FF,$3FFF,$A7FF,$FFFC,$FFFC,$FFFC,$FFFC
		dc.w	$4FFF,$63FF,$1FFF,$53FF,$FFFE,$FFFE,$FFFE,$FFFE
		dc.w	$27FF,$31FF,$0FFF,$29FF,$FFF2,$FFC6,$FFF8,$FFCA
		dc.w	$3FFF,$3FFF,$3FFF,$3FFF,$FFF9,$FFE3,$FFFC,$FFE5
		dc.w	$0000,$0000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0007,$0007,$0007
		dc.w	$FFF0,$FFF0,$FFF0,$FFF0,$0003,$0003,$0000,$0002
		dc.w	$FFFC,$7FFC,$FFFC,$7FFB,$FFF9,$FFF9,$FFF8,$7FF9
		dc.w	$FFFE,$BFFE,$7FFE,$3FFD,$7FFC,$7FFC,$7FFC,$BFFC
		dc.w	$FFFF,$DFFF,$3FFF,$9FFE,$3FFE,$3FFE,$3FFE,$DFFE
		dc.w	$7FFF,$6FFF,$1FFF,$4FFF,$9FFF,$9FFB,$9FFC,$6FF9
		dc.w	$3FFF,$3FFF,$3FFF,$3FFF,$CFFF,$CFFD,$CFFE,$B7FC
		dc.w	$8000,$8000,$0000,$8000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0007,$0007,$0007
		dc.w	$FFF0,$FFF0,$FFF0,$FFF0,$0001,$0002,$0001,$0000
		dc.w	$FFFD,$FFF9,$FFFE,$FFFA,$7FF8,$FFF9,$7FF8,$7FF8
		dc.w	$FFFE,$7FFC,$FFFF,$7FFD,$BFFC,$FFFC,$3FFC,$3FFC
		dc.w	$7FFF,$BFFE,$7FFF,$3FFE,$5FFE,$7FFE,$9FFE,$9FFE
		dc.w	$3FFF,$5FFF,$3FFF,$1FFF,$AFFE,$3FFD,$CFFE,$4FFC
		dc.w	$3FFF,$3FFF,$3FFF,$3FFF,$D7FF,$9FFE,$E7FF,$A7FE
		dc.w	$0000,$8000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0007,$0007,$0007
		dc.w	$FFF0,$FFF0,$FFF0,$FFF0,$0001,$0001,$0003,$0003
		dc.w	$FFFD,$FFF9,$FFFE,$FFFA,$7FF8,$FFF8,$7FF9,$7FF9
		dc.w	$FFFE,$FFFC,$FFFF,$FFFD,$BFFC,$FFFC,$3FFC,$3FFC
		dc.w	$7FFF,$7FFE,$FFFF,$FFFE,$5FFE,$7FFE,$9FFE,$9FFE
		dc.w	$3FFF,$3FFF,$7FFF,$7FFF,$AFFE,$3FFE,$CFFF,$4FFF
		dc.w	$3FFF,$3FFF,$3FFF,$3FFF,$D7FF,$9FFF,$E7FF,$A7FF
		dc.w	$0000,$0000,$8000,$8000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0007,$0007,$0007
		dc.w	$FFF0,$FFF0,$FFF0,$FFF0,$0003,$0001,$0003,$0001
		dc.w	$FFFD,$FFF9,$FFFE,$FFFA,$7FF9,$FFF8,$7FF9,$7FF8
		dc.w	$FFFE,$FFFC,$FFFF,$FFFD,$BFFC,$FFFC,$3FFC,$3FFC
		dc.w	$FFFF,$7FFE,$FFFF,$7FFE,$5FFE,$7FFE,$9FFE,$9FFE
		dc.w	$7FFF,$3FFF,$7FFF,$3FFF,$AFFF,$3FFE,$CFFF,$4FFE
		dc.w	$3FFF,$3FFF,$3FFF,$3FFF,$D7FF,$9FFF,$E7FF,$A7FF
		dc.w	$8000,$0000,$8000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0007,$0007,$0007
		dc.w	$FFF0,$FFF0,$FFF0,$FFF0,$0003,$0001,$0003,$0001
		dc.w	$FFFD,$FFF9,$FFFE,$FFFA,$5869,$F338,$5329,$6FD8
		dc.w	$FFFE,$FFFC,$FFFF,$FFFD,$AC34,$F99C,$2994,$37EC
		dc.w	$FFFF,$7FFE,$FFFF,$7FFE,$561A,$7CCE,$94CA,$9BF6
		dc.w	$7FFF,$3FFF,$7FFF,$3FFF,$AFFF,$3FFE,$CFFF,$4FFE
		dc.w	$3FFF,$3FFF,$3FFF,$3FFF,$D7FF,$9FFF,$E7FF,$A7FF
		dc.w	$8000,$0000,$8000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0007,$0007,$0007
		dc.w	$FFF0,$FFF0,$FFF0,$FFF0,$0003,$0003,$0003,$0003
		dc.w	$FFFD,$FFF9,$FFFE,$FFFA,$6601,$87F9,$7801,$1801
		dc.w	$FFFE,$FFFC,$FFFF,$FFFD,$B300,$C3FC,$3C00,$0C00
		dc.w	$FFFF,$FFFE,$FFFF,$FFFE,$5980,$61FE,$9E00,$8600
		dc.w	$7FFF,$7FFF,$7FFF,$7FFF,$AFFF,$3FFF,$CFFF,$4FFF
		dc.w	$3FFF,$3FFF,$3FFF,$3FFF,$D7FF,$9FFF,$E7FF,$A7FF
		dc.w	$8000,$8000,$8000,$8000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0007,$0007,$0007
		dc.w	$FFF0,$FFF0,$FFF0,$FFF0,$0003,$0003,$0003,$0003
		dc.w	$FFFA,$FFFB,$FFFC,$FFFC,$4C01,$8FF9,$F001,$3001
		dc.w	$FFFF,$FFFD,$FFFE,$FFFC,$6600,$C7FC,$3800,$5800
		dc.w	$FFFE,$FFFE,$FFFF,$FFFF,$9300,$E3FE,$3C00,$0C00
		dc.w	$7FFF,$7FFF,$7FFF,$7FFF,$AFFF,$3FFF,$CFFF,$4FFF
		dc.w	$3FFF,$3FFF,$3FFF,$3FFF,$D7FF,$9FFF,$E7FF,$A7FF
		dc.w	$8000,$8000,$8000,$8000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0007,$0007,$0007
		dc.w	$FFF0,$FFF0,$FFF0,$FFF0,$0003,$0003,$0003,$0003
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$E601,$87F9,$F801,$9801
		dc.w	$FFFF,$FFFD,$FFFF,$FFFD,$FFFC,$FFFC,$FFFC,$FFFC
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$F980,$E1FE,$FE00,$E600
		dc.w	$7FFF,$7FFF,$7FFF,$7FFF,$AFFF,$3FFF,$CFFF,$4FFF
		dc.w	$3FFF,$3FFF,$3FFF,$3FFF,$D7FF,$9FFF,$E7FF,$A7FF
		dc.w	$8000,$8000,$8000,$8000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0007,$0007,$0007
		dc.w	$FFF0,$FFF0,$FFF0,$FFF0,$0003,$0003,$0003,$0003
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$CC01,$8FF9,$F001,$B001
		dc.w	$FFFF,$FFFD,$FFFF,$FFFD,$FFFC,$FFFC,$FFFC,$FFFC
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$F300,$E3FE,$FC00,$EC00
		dc.w	$7FFF,$7FFF,$7FFF,$7FFF,$AFFF,$3FFF,$CFFF,$4FFF
		dc.w	$3FFF,$3FFF,$3FFF,$3FFF,$D7FF,$9FFF,$E7FF,$A7FF
		dc.w	$8000,$8000,$8000,$8000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0007,$0007,$0007
		dc.w	$FFF0,$FFF0,$FFF0,$FFF0,$0003,$0003,$0003,$0003
		dc.w	$FFFC,$FFFC,$FFFC,$FFFB,$E601,$87F9,$F801,$1801
		dc.w	$FFFD,$FFFD,$FFFF,$FFFE,$7FFC,$7FFC,$7FFC,$BFFC
		dc.w	$FFFF,$FFFF,$FFFF,$FFFE,$3980,$21FE,$3E00,$C600
		dc.w	$7FFF,$7FFF,$7FFF,$7FFF,$4FFF,$7FFF,$9FFF,$8FFF
		dc.w	$3FFF,$3FFF,$3FFF,$3FFF,$A7FF,$BFFF,$CFFF,$C7FF
		dc.w	$8000,$8000,$8000,$8000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0007,$0007,$0007
		dc.w	$FFF0,$FFF0,$FFF0,$FFF0,$0003,$0003,$0003,$0003
		dc.w	$FFFD,$FFF9,$FFFE,$FFFA,$4C01,$8FF9,$7001,$3001
		dc.w	$FFFD,$FFFC,$FFFD,$FFFC,$7FFC,$7FFC,$BFFC,$BFFC
		dc.w	$FFFF,$FFFE,$FFFF,$FFFE,$5300,$63FE,$9C00,$8C00
		dc.w	$7FFF,$7FFF,$7FFF,$7FFF,$0FFF,$0FFF,$0FFF,$0FFF
		dc.w	$3FFF,$3FFF,$3FFF,$3FFF,$87FF,$87FF,$87FF,$87FF
		dc.w	$8000,$8000,$8000,$8000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0007,$0007,$0007
		dc.w	$FFF0,$FFF0,$FFF0,$FFF0,$0003,$0003,$0003,$0003
		dc.w	$FFFD,$FFF9,$FFFE,$FFFA,$6601,$87F9,$7801,$1801
		dc.w	$FFFD,$FFFC,$FFFD,$FFFC,$7FFC,$7FFC,$BFFC,$BFFC
		dc.w	$FFFF,$FFFE,$FFFF,$FFFE,$5980,$61FE,$9E00,$8600
		dc.w	$7FFF,$7FFF,$7FFF,$7FFF,$0FFF,$0FFF,$0FFF,$0FFF
		dc.w	$3FFF,$3FFF,$3FFF,$3FFF,$87FF,$87FF,$87FF,$87FF
		dc.w	$8000,$8000,$8000,$8000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0007,$0007,$0007
		dc.w	$FFF0,$FFF0,$FFF0,$FFF0,$0003,$0003,$0003,$0003
		dc.w	$FFFD,$FFF9,$FFFE,$FFFA,$4C01,$8FF9,$7001,$3001
		dc.w	$FFFD,$FFFC,$FFFD,$FFFC,$7FFC,$7FFC,$BFFC,$BFFC
		dc.w	$FFFF,$FFFE,$FFFF,$FFFE,$5300,$63FE,$9C00,$8C00
		dc.w	$7FFF,$7FFF,$7FFF,$7FFF,$0FFF,$0FFF,$0FFF,$0FFF
		dc.w	$3FFF,$3FFF,$3FFF,$3FFF,$87FF,$87FF,$87FF,$87FF
		dc.w	$8000,$8000,$8000,$8000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0007,$0007,$0007
		dc.w	$FFF0,$FFF0,$FFF0,$FFF0,$0003,$0003,$0003,$0003
		dc.w	$FFFD,$FFF9,$FFFE,$FFFA,$7FF9,$FFF9,$7FF9,$7FF9
		dc.w	$FFFD,$FFFC,$FFFD,$FFFC,$7FFC,$7FFC,$BFFC,$BFFC
		dc.w	$FFFF,$FFFE,$FFFF,$FFFE,$5FFE,$7FFE,$9FFE,$9FFE
		dc.w	$7FFF,$7FFF,$7FFF,$7FFF,$0FFF,$0FFF,$0FFF,$0FFF
		dc.w	$3FFF,$3FFF,$3FFF,$3FFF,$87FF,$87FF,$87FF,$87FF
		dc.w	$8000,$8000,$8000,$8000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0007,$0007,$0007
		dc.w	$FFF0,$FFF0,$FFF0,$FFF0,$0003,$0001,$0003,$0001
		dc.w	$FFFD,$FFF9,$FFFE,$FFFA,$7FF9,$FFF8,$7FF9,$7FF8
		dc.w	$FFFD,$FFFC,$FFFD,$FFFC,$7FFC,$7FF8,$BFFC,$BFF8
		dc.w	$FFFF,$7FFE,$FFFF,$7FFE,$5FFE,$7FFE,$9FFE,$9FFE
		dc.w	$7FFF,$7FFF,$7FFF,$7FFF,$0FFF,$0FFF,$0FFF,$0FFF
		dc.w	$3FFF,$3FFF,$3FFF,$3FFF,$87FF,$87FF,$87FF,$87FF
		dc.w	$8000,$0000,$8000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0007,$0007,$0007
		dc.w	$FFF0,$FFF0,$FFF0,$FFF0,$0003,$0001,$0003,$0001
		dc.w	$FFFD,$FFF9,$FFFE,$FFFA,$7FF9,$FFF8,$7FF9,$7FF8
		dc.w	$FFFD,$FFFC,$FFFD,$FFFC,$7FF8,$7FF8,$BFFC,$BFFC
		dc.w	$FFFF,$7FFE,$FFFF,$7FFE,$5FFE,$7FFE,$9FFE,$9FFE
		dc.w	$7FFF,$7FFF,$7FFF,$7FFF,$0FFF,$0FFF,$0FFF,$0FFF
		dc.w	$3FFF,$3FFF,$3FFF,$3FFF,$87FF,$87FF,$87FF,$87FF
		dc.w	$0000,$0000,$8000,$8000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0007,$0007,$0007
		dc.w	$FFF0,$FFF0,$FFF0,$FFF0,$0003,$0000,$0003,$0000
		dc.w	$FFFA,$FFFB,$FFFC,$FFFC,$7FF9,$FFF8,$FFF9,$7FF8
		dc.w	$FFFC,$7FFC,$FFFD,$7FFD,$BFFC,$FFF4,$3FF8,$3FF0
		dc.w	$FFFE,$3FFE,$FFFF,$3FFF,$9FFE,$FFFE,$3FFE,$1FFE
		dc.w	$7FFF,$7FFF,$7FFF,$7FFF,$0FFF,$0FFF,$0FFF,$0FFF
		dc.w	$3FFF,$3FFF,$3FFF,$3FFF,$87FF,$87FE,$87FF,$87FE
		dc.w	$8000,$8000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0007,$0007,$0007
		dc.w	$FFF0,$FFF0,$FFF0,$FFF0,$FFF3,$FFF0,$FFF3,$FFF0
		dc.w	$FFFF,$7FFF,$FFFF,$7FFF,$FFF9,$FFF8,$FFF9,$FFF8
		dc.w	$FFFF,$3FFF,$FFFF,$3FFF,$FFF8,$FFEC,$FFF0,$FFE0
		dc.w	$FFFF,$1FFF,$FFFF,$1FFF,$FFFE,$FFFE,$FFFE,$FFFE
		dc.w	$7FFF,$7FFF,$7FFF,$7FFF,$0FFF,$0FFF,$0FFF,$0FFF
		dc.w	$3FFF,$3FFF,$3FFF,$3FFF,$FFFF,$FFFD,$FFFE,$FFFC
		dc.w	$0000,$8000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0003,$0007,$0003
		dc.w	$FFF0,$FFF0,$FFF0,$FFF0,$FFF2,$FFE0,$FFF3,$FFE1
		dc.w	$6780,$3E30,$E63F,$B9F0,$03C9,$18F8,$F8C9,$1F38
		dc.w	$33C0,$1F18,$F31F,$DCF8,$1E50,$C7DC,$C660,$F9E0
		dc.w	$99E0,$0F8C,$F98F,$6E7C,$00F2,$063E,$FE32,$07CE
		dc.w	$5806,$7333,$53F2,$6F3D,$0FFF,$0FFF,$0FFF,$0FFF
		dc.w	$2780,$3E30,$263F,$39F0,$03CA,$18F3,$F8CC,$1F34
		dc.w	$0000,$8000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0003,$0007,$0003
		dc.w	$FFF0,$FFF0,$FFF0,$FFF0,$FFE3,$FFE0,$FFF3,$FFF0
		dc.w	$7000,$7FFF,$8000,$8000,$0001,$FFF8,$0001,$0000
		dc.w	$B800,$3FFF,$C000,$4000,$0000,$FFFC,$0000,$0000
		dc.w	$DC00,$1FFF,$E000,$2000,$0000,$FFFE,$0000,$0000
		dc.w	$6600,$07FF,$7800,$1800,$0FFF,$0FFF,$0FFF,$0FFF
		dc.w	$3300,$03FF,$3C00,$0C00,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$8000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0001,$0007,$0001
		dc.w	$FFF0,$FFF0,$FFF0,$FFF0,$FFF2,$FFD0,$FFE3,$FFC1
		dc.w	$2000,$3FFF,$C000,$C000,$0001,$FFF8,$0001,$0000
		dc.w	$1000,$1FFF,$E000,$E000,$0000,$FFFC,$0000,$0000
		dc.w	$8800,$0FFF,$F000,$7000,$0000,$FFFE,$0000,$0000
		dc.w	$4C00,$0FFF,$7000,$3000,$0FFF,$0FFF,$0FFF,$0FFF
		dc.w	$2600,$07FF,$3800,$1800,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$8000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0007,$0000,$0007,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFE3,$FFB0,$FFC3,$FF80
		dc.w	$7000,$7FFF,$8000,$8000,$0001,$FFF8,$0001,$0000
		dc.w	$B800,$3FFF,$C000,$4000,$0000,$FFFC,$0000,$0000
		dc.w	$DC00,$1FFF,$E000,$2000,$0000,$FFFE,$0000,$0000
		dc.w	$6600,$07FF,$7800,$1800,$0FFF,$0FFF,$0FFF,$0FFF
		dc.w	$3300,$03FF,$3C00,$0C00,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$8000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0004,$0000,$0007,$0003
		dc.w	$CF00,$7C63,$CC7F,$73E3,$7940,$1F70,$1983,$E783
		dc.w	$2000,$3FFF,$C000,$C000,$0000,$FFF8,$0001,$0001
		dc.w	$1000,$1FFF,$E000,$E000,$0000,$FFFC,$0000,$0000
		dc.w	$0800,$0FFF,$F000,$F000,$0000,$FFFE,$0000,$0000
		dc.w	$4C00,$0FFF,$7000,$3000,$0B0D,$0E67,$0A65,$0DFB
		dc.w	$2600,$07FF,$3800,$1800,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$8000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0006,$0000,$0007,$0001
		dc.w	$E000,$FFFF,$0000,$0000,$0003,$FFF2,$0001,$0000
		dc.w	$7000,$7FFF,$8000,$8000,$0001,$FFF9,$0000,$0000
		dc.w	$B800,$3FFF,$C000,$4000,$0000,$FFFC,$0000,$0000
		dc.w	$DC00,$9FFF,$6000,$2000,$0000,$FFFE,$0000,$0000
		dc.w	$6600,$07FF,$7800,$1800,$0CC0,$00FF,$0F00,$0300
		dc.w	$3300,$03FF,$3C00,$0C00,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$8000,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0004,$0000,$0007,$0003
		dc.w	$4000,$7FFF,$8000,$8000,$0000,$FFF2,$0001,$0001
		dc.w	$2000,$3FFF,$C000,$C000,$0000,$FFF9,$0000,$0000
		dc.w	$1000,$1FFF,$E000,$E000,$0000,$FFFC,$0004,$0000
		dc.w	$0800,$8FFF,$7000,$7000,$0000,$FFFE,$0000,$0000
		dc.w	$4C00,$0FFF,$7000,$3000,$0980,$01FF,$0E00,$0600
		dc.w	$2600,$07FF,$3800,$1800,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$8000,$8000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0006,$0000,$0007,$0001
		dc.w	$E000,$FFFF,$0000,$0000,$0003,$FFF3,$0000,$0002
		dc.w	$7000,$7FFF,$8000,$8000,$0001,$FFF9,$0000,$0001
		dc.w	$B800,$BFFF,$4000,$4000,$0004,$FFFC,$0000,$0004
		dc.w	$DC00,$DFFF,$2000,$A000,$0000,$FFFE,$0000,$0000
		dc.w	$6600,$07FF,$7800,$1800,$0CC0,$00FF,$0F00,$0300
		dc.w	$3300,$03FF,$3C00,$0C00,$0000,$FFFF,$0000,$0000
		dc.w	$8000,$8002,$0002,$8000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0007,$0007
		dc.w	$4000,$7FFF,$8000,$8000,$0000,$FFF1,$0001,$0000
		dc.w	$A000,$BFFF,$4000,$4000,$0000,$FFF8,$0000,$0000
		dc.w	$5000,$DFFF,$A000,$2000,$0008,$FFF8,$0000,$0008
		dc.w	$2800,$6FFF,$5000,$1000,$0000,$FFFE,$0000,$0000
		dc.w	$4C00,$0FFF,$7000,$3000,$0980,$01FF,$0E00,$0600
		dc.w	$2600,$07FF,$3800,$1800,$0001,$FFFF,$0000,$0001
		dc.w	$0000,$0002,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0006,$0004,$0003,$0001
		dc.w	$E000,$FFFF,$0000,$0000,$0000,$FFF0,$0000,$0000
		dc.w	$B000,$FFFF,$0000,$8000,$0000,$FFF8,$0000,$0000
		dc.w	$5800,$7FFF,$0000,$4000,$0010,$FFF0,$0020,$0010
		dc.w	$2C00,$3FFF,$0000,$2000,$0000,$FFFE,$0000,$0000
		dc.w	$6600,$07FF,$7800,$1800,$0CC0,$00FF,$0F00,$0300
		dc.w	$3300,$03FF,$3C00,$0C00,$0002,$FFFE,$0004,$0002
		dc.w	$0000,$0002,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0004,$0003,$0003
		dc.w	$4000,$7FFF,$8000,$8000,$0000,$FFF0,$0010,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$0000,$FFF8,$FFF8,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFC0,$FFC0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$0000,$FFFE,$FFFE,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0980,$01FF,$0E00,$0600
		dc.w	$0000,$3FFF,$3FFF,$0000,$0000,$FFF8,$FFF8,$0000
		dc.w	$0002,$0002,$0000,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0006,$0006,$0001,$0005
		dc.w	$E000,$FFFF,$0000,$0000,$0010,$FFF0,$0000,$0010
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0CC0,$00FF,$0F00,$0300
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0002,$0002,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0001,$0003,$0002,$0000
		dc.w	$4000,$7FFF,$8000,$8000,$0020,$FFE0,$0000,$0020
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0980,$01FF,$0E00,$0600
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0002,$0000,$0002,$0000,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0001,$0001,$0000,$0001
		dc.w	$6000,$FFFF,$0000,$0000,$0040,$FFC0,$0080,$0040
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0CC0,$00FF,$0F00,$0300
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0002,$0000,$0002,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0000,$FF00,$FF00,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0FFF,$0FFF,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0002,$0000,$0002,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0050,$03CD,$0232,$002D,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0006,$0006,$0004,$0004,$0000,$0000,$0000,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0002,$0000,$0002,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0007,$0007,$0007,$0007,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$C000,$C000,$8000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0003,$0003,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$C000,$C000,$0000,$0000
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
	rept	10
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr

IMG_INTRO:
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$01C0,$01C0,$01C0,$0000,$0000,$0000,$0000
		dc.w	$0000,$000F,$000F,$000F,$0000,$FFF8,$FFF8,$FFF8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01C0,$02A0,$0360,$0220,$0000,$0000,$0000,$0000
		dc.w	$0007,$000F,$0008,$0008,$FFF0,$F6C8,$0938,$0008
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0060,$0040,$0140,$02A0,$0000,$0000,$0000,$0000
		dc.w	$0006,$000E,$0009,$0008,$92E0,$8DF8,$7FF8,$0008
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$02C0,$07F0,$05F0,$0410,$0000,$0000,$0000,$0000
		dc.w	$0006,$000E,$0008,$0009,$2480,$2378,$DFF8,$0008
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0450,$0470,$0260,$0590,$0000,$0000,$0000,$0000
		dc.w	$0000,$000F,$000F,$000F,$E400,$1CF8,$FCF8,$0378
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0050,$0868,$0A68,$0D98,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0001,$0001,$E380,$6340,$E3C0,$1C40
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$05E0,$0FF8,$0BF8,$0808,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0001,$0001,$1E00,$5FC0,$1FC0,$E040
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0988,$09F8,$05F0,$0A08,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1D80,$FF40,$9FC0,$E040
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0108,$11F0,$15F0,$1A08,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$4600,$9FC0,$EFC0,$F040
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0A00,$1FF0,$17C8,$1038,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$01C0,$6F00,$77C0,$7840
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1180,$1250,$0BB0,$1470,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0001,$0001,$9200,$05C0,$1BC0,$9C40
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0200,$2078,$2B38,$34F8,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0001,$0001,$2080,$3140,$B7C0,$5440
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1400,$3C58,$2F38,$20F8,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0001,$0001,$2200,$61C0,$FFC0,$0040
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$2400,$26AC,$179C,$287C,$0000,$0000,$0000,$0000
		dc.w	$0001,$0000,$0001,$0001,$1980,$6F40,$FFC0,$0040
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0400,$405A,$51C6,$6E3E,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0001,$0001,$3200,$3FC0,$BFC0,$4040
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$2C00,$7D27,$5DE1,$421F,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0001,$0001,$0740,$3F80,$BFC0,$4040
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$4D00,$4C98,$2CF9,$5307,$0000,$0000,$0000,$0000
		dc.w	$0001,$0000,$0001,$0001,$C080,$9F40,$1FC0,$5040
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0100,$8646,$A67E,$D981,$0000,$8000,$8000,$8000
		dc.w	$0000,$0001,$0001,$0001,$9900,$ABC0,$37C0,$3840
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$5AE0,$FC11,$BC1F,$83E0,$0000,$8000,$8000,$8000
		dc.w	$0000,$0001,$0001,$0001,$B880,$D340,$67C0,$7840
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$8AB8,$9E04,$5D07,$A2F8,$8000,$8000,$0000,$8000
		dc.w	$0000,$0001,$0001,$0001,$F200,$A6C0,$0EC0,$7140
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0001,$0001,$0001
		dc.w	$1964,$1FE2,$5EE3,$A21C,$8000,$4000,$4000,$C000
		dc.w	$0000,$0001,$0001,$0001,$8680,$8EC0,$3EC0,$4140
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0001,$0001,$0001
		dc.w	$B41B,$FA30,$7AB0,$074F,$0000,$C000,$C000,$4000
		dc.w	$0000,$0001,$0001,$0001,$0D00,$3DC0,$BDC0,$4240
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0001,$0000,$0001
		dc.w	$253A,$3D38,$B8B8,$4547,$4000,$C000,$8000,$4000
		dc.w	$0000,$0001,$0001,$0001,$BEC0,$BF00,$3FC0,$4040
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0002,$0002,$0003
		dc.w	$10AA,$3DFF,$BD7F,$4500,$4000,$A000,$A000,$6000
		dc.w	$0001,$0000,$0001,$0001,$B3C0,$B600,$37C0,$4840
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0003,$0002,$0002
		dc.w	$6815,$F51F,$F55F,$0DA0,$0000,$E000,$E000,$2000
		dc.w	$0000,$0001,$0001,$0001,$95C0,$9E00,$1FC0,$6040
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0002,$0001,$0002
		dc.w	$4880,$789F,$705F,$88A0,$A000,$E000,$C000,$2000
		dc.w	$0000,$0001,$0001,$0001,$2AC0,$3C00,$BFC0,$4040
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0004,$0005,$0006
		dc.w	$2055,$78F8,$78B9,$8885,$2000,$D000,$D000,$3000
		dc.w	$0000,$0001,$0001,$0001,$F580,$F840,$7FC0,$0040
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0003,$0005,$0004
		dc.w	$D001,$E88A,$E8AB,$18D3,$0000,$B000,$7000,$9000
		dc.w	$0000,$0001,$0001,$0001,$CA80,$F140,$7FC0,$0040
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0020,$0050,$0076,$0075
		dc.w	$5047,$F049,$E02E,$1057,$1000,$B000,$6000,$9000
		dc.w	$0000,$0000,$0000,$0000,$DE80,$2340,$BFC0,$C040
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0050,$00D6,$0084,$00F7
		dc.w	$C024,$E02B,$E008,$0017,$1000,$6800,$E800,$1800
		dc.w	$0000,$0000,$0000,$0000,$6C80,$1340,$5FC0,$6040
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00D8,$0041,$00CA,$00BB
		dc.w	$A000,$D04C,$D04F,$3070,$6000,$F800,$F800,$0800
		dc.w	$0000,$0000,$0000,$0000,$2800,$0740,$3FC0,$2040
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00B8,$000E,$0087,$00FF
		dc.w	$2178,$FEBF,$5FDF,$BFE0,$2800,$F800,$F000,$0800
		dc.w	$0000,$0000,$0000,$0000,$2500,$0E40,$3FC0,$2040
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0070,$0089,$00F9,$00F9
		dc.w	$0016,$C01F,$7FFF,$8000,$6800,$F400,$F400,$0C00
		dc.w	$0000,$0000,$0000,$0000,$2000,$0E40,$3FC0,$2040
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0006,$0007,$0007
		dc.w	$401C,$C01E,$401E,$BFE1,$D000,$FC00,$FC00,$0400
		dc.w	$0000,$0000,$0000,$0000,$4A40,$1C00,$7FC0,$4040
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0014,$0019,$001E
		dc.w	$C0DB,$FFFF,$FFFF,$0000,$B800,$E000,$E800,$1800
		dc.w	$0000,$0000,$0000,$0000,$1880,$FCC0,$3F40,$C040
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0003,$0003,$000B,$0014
		dc.w	$248A,$DB7F,$FFF7,$7FF0,$F000,$C800,$D800,$3800
		dc.w	$0000,$0001,$0001,$0001,$B700,$BBC0,$3CC0,$4040
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0016,$003F,$002F,$0020
		dc.w	$8001,$4011,$4015,$C01A,$F000,$8E00,$B600,$7A00
		dc.w	$0000,$0001,$0001,$0001,$EE80,$B740,$79C0,$0040
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0020,$0027,$0017,$0028
		dc.w	$8009,$C009,$4005,$C00A,$C200,$0E00,$5C00,$D200
		dc.w	$0000,$0001,$0001,$0001,$FC40,$8E00,$7240,$01C0
		dc.w	$0000,$03C0,$03C0,$03C0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0006,$0047,$0057,$0068
		dc.w	$0005,$800C,$8008,$800B,$8200,$1500,$AD00,$B300
		dc.w	$0001,$0000,$0001,$0001,$7880,$1C40,$E4C0,$0340
		dc.w	$0780,$03C0,$0440,$0440,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$002D,$007E,$005E,$0041
		dc.w	$0001,$8008,$800B,$800D,$0C00,$5300,$7F00,$6100
		dc.w	$0000,$0001,$0001,$0001,$F100,$B9C0,$49C0,$0640
		dc.w	$0380,$0740,$01C0,$0440,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0045,$004F,$002E,$0051
		dc.w	$0007,$0006,$0003,$0005,$8900,$2780,$DE80,$E180
		dc.w	$0000,$0001,$0001,$0001,$E280,$F340,$13C0,$0C40
		dc.w	$0380,$0340,$01C0,$0440,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$000C,$008E,$00AE,$00D0
		dc.w	$0003,$0003,$0002,$0001,$9900,$2680,$FE80,$C180
		dc.w	$0000,$0001,$0001,$0001,$4740,$6680,$A7C0,$1840
		dc.w	$0F80,$0640,$0BC0,$0840,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0052,$00FD,$00BD,$0083
		dc.w	$0001,$0005,$0005,$0006,$9400,$4F80,$BF80,$C080
		dc.w	$1801,$2400,$3C01,$3C01,$8D80,$C940,$4EC0,$3040
		dc.w	$1780,$0740,$13C0,$1840,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$050A,$029F,$07DD,$07A3
		dc.w	$0003,$C01F,$C01C,$C01E,$A200,$9BF0,$3BF0,$C4F0
		dc.w	$0800,$420F,$660F,$7E0F,$1A12,$106D,$9FFF,$607F
		dc.w	$2E00,$D740,$EF40,$F0C0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00CC,$04B4,$077F,$0400
		dc.w	$0010,$4000,$C01F,$4010,$D300,$2C10,$7FF0,$8010
		dc.w	$4603,$100B,$520C,$6E08,$369F,$22FF,$3D00,$C000
		dc.w	$F100,$FE00,$0E80,$0180,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0153,$050D,$06FF,$0400
		dc.w	$4000,$8010,$C018,$4017,$8E94,$F00A,$FFFF,$001F
		dc.w	$2E2C,$8156,$C3FA,$FFF9,$F920,$E1F8,$FE07,$0000
		dc.w	$B200,$0C00,$FD00,$0300,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0434,$0003,$07FF,$0400
		dc.w	$0004,$C017,$C01F,$4010,$AA00,$4010,$FFF0,$0010
		dc.w	$1802,$420B,$660F,$7E08,$5550,$05FD,$FA02,$0000
		dc.w	$6800,$0000,$FA00,$0600,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0641,$01BE,$07FF,$07FF
		dc.w	$0009,$C016,$C01F,$C01F,$8200,$7DF0,$FFF0,$FFF0
		dc.w	$1802,$240D,$3C0F,$3C0F,$0784,$F87B,$FFFF,$FFFF
		dc.w	$0000,$DC00,$FC00,$FC00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$2000,$2000,$0000,$2000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$2000,$2000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$2000,$7000,$5000,$7000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$7000,$5000,$0000,$7000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$2000,$7000,$5000,$7000,$0000,$0000,$0000,$0000
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
		dc.w	$0000,$0000,$0000,$0000,$0A0B,$1392,$1383,$1D9C
		dc.w	$8A0A,$9393,$1383,$1D9D,$0A01,$9202,$8200,$9C03
		dc.w	$0161,$0252,$0272,$0393,$6161,$5252,$7272,$9393
		dc.w	$4140,$7270,$7070,$B3B0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1104,$1D80,$0580,$1E86
		dc.w	$1111,$1D9D,$0585,$1E9E,$0402,$9A03,$9200,$9E03
		dc.w	$0202,$0303,$0000,$0303,$0202,$3303,$3000,$3303
		dc.w	$2220,$B3B0,$B0B0,$D3D0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0A82,$0C84,$1080,$1F06
		dc.w	$0A8A,$0C8C,$1090,$1F1F,$0801,$9E01,$9202,$9E03
		dc.w	$0141,$01A1,$0222,$03E3,$1141,$11A1,$1222,$23E3
		dc.w	$1110,$1110,$1210,$2320,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1104,$0006,$1800,$1986
		dc.w	$1111,$0000,$1818,$1999,$0402,$1620,$1A23,$9E23
		dc.w	$0202,$0000,$0303,$0303,$2202,$0000,$0303,$3303
		dc.w	$0220,$2000,$0300,$3330,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0882,$1102,$1804,$1986
		dc.w	$0888,$1111,$1818,$1999,$8A21,$1252,$1C73,$9E73
		dc.w	$5151,$6262,$8383,$F3F3,$5151,$6262,$8383,$F3F3
		dc.w	$2140,$3270,$0390,$33F0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0020,$0020,$0020
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
				
conterm:
	ds.w	1 

* Donnees Texte

TEXTE:
	DC.B      'BLAH BLAH BLAH BLAH BLAH BLAH BLAH BLAH ',$01,$01
	DC.B      'ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789   ',$01
	DC.B      '!#()*+,.:;-?',$27,'                           ',$01
	DC.B      'BLAH BLAH BLAH BLAH BLAH BLAH BLAH BLAH ',$01
	DC.B      'BLAH BLAH BLAH BLAH BLAH BLAH BLAH BLAH ',$01
	DC.B      'BLAH BLAH BLAH BLAH BLAH BLAH BLAH BLAH ',$01
	DC.B      'BLAH BLAH BLAH BLAH BLAH BLAH BLAH BLAH ',$01
	DC.B      'BLAH BLAH BLAH BLAH BLAH BLAH BLAH BLAH ',$01
	DC.B      'BLAH BLAH BLAH BLAH BLAH BLAH BLAH BLAH ',$01
	DC.B      'BLAH BLAH BLAH BLAH BLAH BLAH BLAH BLAH ',$01		
	DC.B      $01,$00,$FF,$00
	even

BUFFER1:
	DCB.W	2,0 
BUFFER2:
	DCB.W	4,0 
FONTE8_8:
	dc	$0000,$0000,$0C00,$0000
	dc	$0000,$0000,$6C00,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0018,$0000
	dc	$0000,$0000,$3000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$00F8,$0000
	dc	$0000,$0000,$6038,$0000
	dc	$0000,$0000,$381C,$0000
	dc	$0000,$0000,$FC1C,$0000
	dc	$0000,$0000,$FE78,$0000
	dc	$0000,$0000,$3C00,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$3C00,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$1800,$0000
	dc	$0000,$0000,$6C00,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$1830,$0000
	dc	$0000,$0000,$18B4,$0000
	dc	$0000,$0000,$1800,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$000C,$0000
	dc	$0000,$0000,$306C,$0000
	dc	$0000,$0000,$6C3C,$0000
	dc	$0000,$0000,$0030,$0000
	dc	$0000,$0000,$00CC,$0000
	dc	$0000,$0000,$6600,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$6600,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$3000,$0000
	dc	$0000,$0000,$FE00,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$3030,$0000
	dc	$0000,$0000,$1878,$0000
	dc	$0000,$0000,$1800,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$00C6,$0000
	dc	$0000,$0000,$300C,$0000
	dc	$0000,$0000,$006C,$0000
	dc	$0000,$0000,$C060,$0000
	dc	$0000,$0000,$06C4,$0000
	dc	$0000,$0000,$C600,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0600,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$6000,$0000
	dc	$0000,$0000,$6C00,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0030,$0000
	dc	$0000,$0000,$18FC,$0000
	dc	$0000,$0000,$7E00,$0000
	dc	$0000,$0000,$FE00,$0000
	dc	$0000,$0000,$00DE,$0000
	dc	$0000,$0000,$301C,$0000
	dc	$0000,$0000,$1ECC,$0000
	dc	$0000,$0000,$FED8,$0000
	dc	$0000,$0000,$0EEC,$0000
	dc	$0000,$0000,$F618,$0000
	dc	$0000,$0000,$3000,$0000
	dc	$0000,$0000,$FE00,$0000
	dc	$0000,$0000,$0E00,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$6000,$0000
	dc	$0000,$0000,$FE00,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0030,$0000
	dc	$0000,$0000,$18B4,$0000
	dc	$0000,$0000,$1800,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$00E6,$0000
	dc	$0000,$0000,$3030,$0000
	dc	$0000,$0000,$86C0,$0000
	dc	$0000,$0000,$06CC,$0000
	dc	$0000,$0000,$78C6,$0000
	dc	$0000,$0000,$0600,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$FE00,$0000
	dc	$0000,$0000,$1800,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$6C00,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0030,$0000
	dc	$0000,$0000,$1800,$0000
	dc	$0000,$0000,$0018,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$00C6,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$C6FE,$0000
	dc	$0000,$0000,$0CCC,$0000
	dc	$0000,$0000,$30C6,$0000
	dc	$0000,$0000,$0600,$0000
	dc	$0000,$0000,$3000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$6000,$0000
	dc	$0000,$0000,$6C00,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0018,$0000
	dc	$0000,$0000,$3000,$0000
	dc	$0000,$0000,$0030,$0000
	dc	$0000,$0000,$0018,$0000
	dc	$0000,$0000,$007C,$0000
	dc	$0000,$0000,$FEFE,$0000
	dc	$0000,$0000,$7C0C,$0000
	dc	$0000,$0000,$F878,$0000
	dc	$0000,$0000,$607C,$0000
	dc	$0000,$0000,$FC18,$0000
	dc	$0000,$0000,$6000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$1800,$0000
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
	dc	$0000,$0000,$F0F0,$0000
	dc	$0000,$0000,$F0F0,$0000
	dc	$0000,$0000,$F0F8,$0000
	dc	$0000,$0000,$F8C6,$0000
	dc	$0000,$0000,$FC7E,$0000
	dc	$0000,$0000,$C630,$0000
	dc	$0000,$0000,$F8F8,$0000
	dc	$0000,$0000,$F8F8,$0000
	dc	$0000,$0000,$F8F8,$0000
	dc	$0000,$0000,$78FC,$0000
	dc	$0000,$0000,$C6C6,$0000
	dc	$0000,$0000,$C6CC,$0000
	dc	$0000,$0000,$C6F6,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$1818,$0000
	dc	$0000,$0000,$1818,$0000
	dc	$0000,$0000,$180C,$0000
	dc	$0000,$0000,$0CC6,$0000
	dc	$0000,$0000,$06C0,$0000
	dc	$0000,$0000,$0C60,$0000
	dc	$0000,$0000,$1C0C,$0000
	dc	$0000,$0000,$0C0C,$0000
	dc	$0000,$0000,$0C0C,$0000
	dc	$0000,$0000,$0C06,$0000
	dc	$0000,$0000,$C6C6,$0000
	dc	$0000,$0000,$C6C6,$0000
	dc	$0000,$0000,$C606,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$CCCC,$0000
	dc	$0000,$0000,$CCCC,$0000
	dc	$0000,$0000,$C8C6,$0000
	dc	$0000,$0000,$C4C6,$0000
	dc	$0000,$0000,$3286,$0000
	dc	$0000,$0000,$C8C0,$0000
	dc	$0000,$0000,$D6C6,$0000
	dc	$0000,$0000,$C6C6,$0000
	dc	$0000,$0000,$C6C6,$0000
	dc	$0000,$0000,$C032,$0000
	dc	$0000,$0000,$C6C6,$0000
	dc	$0000,$0000,$C6C6,$0000
	dc	$0000,$0000,$C60C,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$C6D8,$0000
	dc	$0000,$0000,$C4C6,$0000
	dc	$0000,$0000,$C0C2,$0000
	dc	$0000,$0000,$C0C6,$0000
	dc	$0000,$0000,$3006,$0000
	dc	$0000,$0000,$E0C0,$0000
	dc	$0000,$0000,$D6C6,$0000
	dc	$0000,$0000,$C6C6,$0000
	dc	$0000,$0000,$D6C6,$0000
	dc	$0000,$0000,$7830,$0000
	dc	$0000,$0000,$C6C6,$0000
	dc	$0000,$0000,$C66C,$0000
	dc	$0000,$0000,$6C18,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$C6CC,$0000
	dc	$0000,$0000,$C0C6,$0000
	dc	$0000,$0000,$D0D0,$0000
	dc	$0000,$0000,$DCDE,$0000
	dc	$0000,$0000,$3006,$0000
	dc	$0000,$0000,$F0C0,$0000
	dc	$0000,$0000,$C6C6,$0000
	dc	$0000,$0000,$C6C6,$0000
	dc	$0000,$0000,$DEC6,$0000
	dc	$0000,$0000,$0C30,$0000
	dc	$0000,$0000,$C6CC,$0000
	dc	$0000,$0000,$D638,$0000
	dc	$0000,$0000,$1830,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$DEC6,$0000
	dc	$0000,$0000,$C0C6,$0000
	dc	$0000,$0000,$C0C0,$0000
	dc	$0000,$0000,$C6C6,$0000
	dc	$0000,$0000,$3006,$0000
	dc	$0000,$0000,$DCC0,$0000
	dc	$0000,$0000,$C6C6,$0000
	dc	$0000,$0000,$C6FC,$0000
	dc	$0000,$0000,$6EFC,$0000
	dc	$0000,$0000,$0630,$0000
	dc	$0000,$0000,$C6F8,$0000
	dc	$0000,$0000,$DEEE,$0000
	dc	$0000,$0000,$70E0,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$C6FE,$0000
	dc	$0000,$0000,$FEFC,$0000
	dc	$0000,$0000,$FEC0,$0000
	dc	$0000,$0000,$FCC6,$0000
	dc	$0000,$0000,$FEFC,$0000
	dc	$0000,$0000,$CEFE,$0000
	dc	$0000,$0000,$C6C6,$0000
	dc	$0000,$0000,$7CC0,$0000
	dc	$0000,$0000,$3EC6,$0000
	dc	$0000,$0000,$FC30,$0000
	dc	$0000,$0000,$7EF0,$0000
	dc	$0000,$0000,$FCC6,$0000
	dc	$0000,$0000,$C0DE,$0000
	rept	27
	dc	$0000,$0000,$0000,$0000
	endr
	dc	$0000
	
* Donnees Scrolltext

CARAC:
	DC.W	$0
PTR_COURBE:
	DC.L	COURBE 
CPT_1:
	DC.W	$0
CPT_3:
	DC.W	$0
ADR_TEXTE:
	DC.W	$0
CPT_2:
	DC.W	$1
CPT_0:
	DC.W	$4
COURBE:
	dc	$12C0,$12C0,$12C0,$12C0
	dc	$1220,$1220,$1220,$1180
	dc	$1180,$10E0,$1040,$1040
	dc	$0FA0,$0F00,$0E60,$0DC0
	dc	$0D20,$0C80,$0BE0,$0AA0
	dc	$0A00,$0960,$08C0,$0780
	dc	$06E0,$05A0,$0500,$0460
	dc	$0320,$0280,$0140,$00A0
	dc	$0000,$FF60,$FE20,$FD80
	dc	$FC40,$FBA0,$FA60,$F9C0
	dc	$F880,$F7E0,$F740,$F600
	dc	$F560,$F4C0,$F420,$F380
	dc	$F240,$F1A0,$F1A0,$F100
	dc	$F060,$EFC0,$EF20,$EF20
	dc	$EE80,$EE80,$EDE0,$EDE0
	dc	$ED40,$ED40,$ED40,$ED40
	dc	$ED40,$ED40,$ED40,$ED40
	dc	$EDE0,$EDE0,$EDE0,$EE80
	dc	$EE80,$EF20,$EFC0,$EFC0
	dc	$F060,$F100,$F1A0,$F240
	dc	$F2E0,$F380,$F420,$F560
	dc	$F600,$F6A0,$F740,$F880
	dc	$F920,$FA60,$FB00,$FBA0
	dc	$FCE0,$FD80,$FEC0,$FF60
	dc	$0000,$00A0,$01E0,$0280
	dc	$03C0,$0460,$05A0,$0640
	dc	$0780,$0820,$08C0,$0A00
	dc	$0AA0,$0B40,$0BE0,$0C80
	dc	$0DC0,$0E60,$0E60,$0F00
	dc	$0FA0,$1040,$10E0,$10E0
	dc	$1180,$1180,$1220,$1220
	dc	$12C0,$12C0,$12C0,$12C0
	dc	$12C0,$12C0,$12C0,$12C0
	dc	$12C0,$1220,$1220,$1220
	dc	$1180,$1180,$1180,$10E0
	dc	$10E0,$1040,$0FA0,$0FA0
	dc	$0F00,$0E60,$0E60,$0DC0
	dc	$0D20,$0C80,$0BE0,$0B40
	dc	$0AA0,$0A00,$0960,$08C0
	dc	$0820,$0780,$06E0,$0640
	dc	$05A0,$0460,$03C0,$0320
	dc	$0280,$01E0,$0140,$0000
	dc	$0000,$FF60,$FEC0,$FD80
	dc	$FCE0,$FC40,$FBA0,$FB00
	dc	$FA60,$F920,$F880,$F7E0
	dc	$F740,$F6A0,$F600,$F560
	dc	$F4C0,$F420,$F380,$F2E0
	dc	$F240,$F240,$F1A0,$F100
	dc	$F060,$F060,$EFC0,$EFC0
	dc	$EF20,$EE80,$EE80,$EE80
	dc	$EDE0,$EDE0,$EDE0,$ED40
	dc	$ED40,$ED40,$ED40,$ED40
	dc	$ED40,$ED40,$ED40,$ED40
	dc	$ED40,$EDE0,$EDE0,$EDE0
	dc	$EE80,$EE80,$EE80,$EF20
	dc	$EF20,$EFC0,$F060,$F060
	dc	$F100,$F1A0,$F1A0,$F240
	dc	$F2E0,$F380,$F420,$F4C0
	dc	$F560,$F600,$F6A0,$F740
	dc	$F7E0,$F880,$F920,$F9C0
	dc	$FA60,$FBA0,$FC40,$FCE0
	dc	$FD80,$FE20,$FEC0,$0000
	dc	$0000,$00A0,$0140,$0280
	dc	$0320,$03C0,$0460,$0500
	dc	$05A0,$06E0,$0780,$0820
	dc	$08C0,$0960,$0A00,$0AA0
	dc	$0B40,$0BE0,$0C80,$0D20
	dc	$0DC0,$0DC0,$0E60,$0F00
	dc	$0FA0,$0FA0,$1040,$1040
	dc	$10E0,$1180,$1180,$1180
	dc	$1220,$1220,$1220,$12C0
	dc	$12C0,$12C0,$12C0,$12C0
	dc	$12C0,$12C0,$12C0,$12C0
	dc	$12C0,$12C0,$12C0,$1220
	dc	$1220,$1220,$1220,$1180
	dc	$1180,$1180,$10E0,$10E0
	dc	$10E0,$1040,$1040,$0FA0
	dc	$0FA0,$0F00,$0F00,$0E60
	dc	$0E60,$0DC0,$0D20,$0D20
	dc	$0C80,$0BE0,$0BE0,$0B40
	dc	$0AA0,$0A00,$0A00,$0960
	dc	$08C0,$0820,$0820,$0780
	dc	$06E0,$0640,$05A0,$0500
	dc	$0460,$0460,$03C0,$0320
	dc	$0280,$01E0,$0140,$00A0
	dc	$0000,$0000,$FF60,$FEC0
	dc	$FE20,$FD80,$FD80,$FCE0
	dc	$FC40,$FBA0,$FB00,$FA60
	dc	$F9C0,$F920,$F920,$F880
	dc	$F7E0,$F740,$F6A0,$F6A0
	dc	$F600,$F560,$F4C0,$F4C0
	dc	$F420,$F380,$F380,$F2E0
	dc	$F240,$F240,$F1A0,$F1A0
	dc	$F100,$F060,$F060,$EFC0
	dc	$EFC0,$EFC0,$EF20,$EF20
	dc	$EE80,$EE80,$EE80,$EDE0
	dc	$EDE0,$EDE0,$EDE0,$EDE0
	dc	$ED40,$ED40,$ED40,$ED40
	dc	$ED40,$ED40,$ED40,$ED40
	dc	$ED40,$ED40,$ED40,$ED40
	dc	$ED40,$EDE0,$EDE0,$EDE0
	dc	$EDE0,$EE80,$EE80,$EE80
	dc	$EF20,$EF20,$EF20,$EFC0
	dc	$EFC0,$F060,$F060,$F100
	dc	$F100,$F1A0,$F1A0,$F240
	dc	$F2E0,$F2E0,$F380,$F420
	dc	$F420,$F4C0,$F560,$F600
	dc	$F600,$F6A0,$F740,$F7E0
	dc	$F7E0,$F880,$F920,$F9C0
	dc	$FA60,$FB00,$FBA0,$FBA0
	dc	$FC40,$FCE0,$FD80,$FE20
	dc	$FEC0,$FF60,$0000,$0000
	dc	$00A0,$0140,$01E0,$0280
	dc	$0280,$0320,$03C0,$0460
	dc	$0500,$05A0,$0640,$06E0
	dc	$06E0,$0780,$0820,$08C0
	dc	$0960,$0960,$0A00,$0AA0
	dc	$0B40,$0B40,$0BE0,$0C80
	dc	$0C80,$0D20,$0DC0,$0DC0
	dc	$0E60,$0E60,$0F00,$0FA0
	dc	$0FA0,$1040,$1040,$1040
	dc	$10E0,$10E0,$1180,$1180
	dc	$1180,$1220,$1220,$1220
	dc	$1220,$1220,$12C0,$12C0
	dc	$12C0,$12C0,$12C0,$12C0
	dc	$12C0,$12C0,$12C0,$12C0
	dc	$12C0,$12C0,$12C0,$12C0
	dc	$12C0,$12C0,$12C0,$12C0
	dc	$12C0,$12C0,$12C0,$FFFF
	dc	$FFFF,$0000

FONTEs:
	dcb.w	4,0 
CAR_B7:
	dc	$7800,$0000,$0000,$0000
CAR_B8:
	dc	$0000,$0000,$0000,$0000
CAR_B9:
	dc	$0000,$0000,$0000,$0000
CAR_BA:
	dc	$0000,$0000,$0000,$0000
CAR_BB:
	dc	$0000,$0000,$0000,$0000
CAR_BC:
	dc	$0000,$0000,$0000,$0000
CAR_BD:
	dc	$7000,$0000,$0000,$0000
CAR_BE:
	dc	$01F8,$0000,$0000,$0000
CAR_BF:
	dc	$3F00,$0000,$0000,$0000
CAR_C0:
	dc	$0000,$0000,$0000,$0000
CAR_C1:
	dc	$0000,$0000,$0000,$0000
CAR_C2:
	dc	$0000,$0000,$0000,$0000
CAR_C3:
	dc	$0000,$0000,$0000,$0000
CAR_C4:
	dc	$0000,$0000,$0000,$0000
CAR_C5:
	dc	$0000,$0000,$0000,$0000
CAR_C6:
	dc	$3FF8,$0000,$0000,$0000
CAR_C7:
	dc	$07E0,$0000,$0000,$0000
CAR_C8:
	dc	$7FF8,$0000,$0000,$0000
CAR_C9:
	dc	$FFF8,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7800,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$6000,$0000,$0000,$0000
	dc	$03F8,$0000,$0000,$0000
	dc	$3F80,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$07E0,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7800,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$E000,$0000,$0000,$0000
	dc	$03F8,$0000,$0000,$0000
	dc	$3F80,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$0FE0,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7800,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$C000,$0000,$0000,$0000
	dc	$07C0,$0000,$0000,$0000
	dc	$07C0,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$F87E,$0000,$0000,$0000
	dc	$0FE0,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$003E,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7800,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0780,$0000,$0000,$0000
	dc	$03C0,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$F0FE,$0000,$0000,$0000
	dc	$1FE0,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7800,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0780,$0000,$0000,$0000
	dc	$03C0,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$FFFE,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$F1FE,$0000,$0000,$0000
	dc	$3FE0,$0000,$0000,$0000
	dc	$0FFC,$0000,$0000,$0000
	dc	$03FE,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7800,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0780,$0000,$0000,$0000
	dc	$03C0,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$FFFE,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$F3DE,$0000,$0000,$0000
	dc	$3FE0,$0000,$0000,$0000
	dc	$3FFC,$0000,$0000,$0000
	dc	$03FC,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7800,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0780,$0000,$0000,$0000
	dc	$03C0,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$FFFE,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$F79E,$0000,$0000,$0000
	dc	$03E0,$0000,$0000,$0000
	dc	$7FF8,$0000,$0000,$0000
	dc	$03FC,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7800,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0780,$0000,$0000,$0000
	dc	$03C0,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$FFFE,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$FF1E,$0000,$0000,$0000
	dc	$03E0,$0000,$0000,$0000
	dc	$7FE0,$0000,$0000,$0000
	dc	$03FE,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7800,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0780,$0000,$0000,$0000
	dc	$03C0,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$FE1E,$0000,$0000,$0000
	dc	$03E0,$0000,$0000,$0000
	dc	$F800,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$07C0,$0000,$0000,$0000
	dc	$07C0,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$FC3E,$0000,$0000,$0000
	dc	$03E0,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$003E,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7800,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$03F8,$0000,$0000,$0000
	dc	$3F80,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$03E0,$0000,$0000,$0000
	dc	$FFFE,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7800,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$03F8,$0000,$0000,$0000
	dc	$3F80,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$03E0,$0000,$0000,$0000
	dc	$FFFE,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7800,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$01F8,$0000,$0000,$0000
	dc	$3F00,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$6000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$3FF8,$0000,$0000,$0000
	dc	$03E0,$0000,$0000,$0000
	dc	$FFFE,$0000,$0000,$0000
	dc	$FFF8,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7800,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0078,$0000,$0000,$0000
	dc	$3C00,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$E000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0FE0,$0000,$0000,$0000
	dc	$03E0,$0000,$0000,$0000
	dc	$FFFE,$0000,$0000,$0000
	dc	$FFE0,$0000,$0000,$0000
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
CAR_CA:
	dc	$780F,$0000,$0000,$0000
CAR_CB:
	dc	$7FFF,$0000,$0000,$0000
CAR_CC:
	dc	$07FF,$0000,$0000,$0000
CAR_CD:
	dc	$7FFF,$0000,$0000,$0000
CAR_CE:
	dc	$07F0,$0000,$0000,$0000
CAR_CF:
	dc	$07F0,$0000,$0000,$0000
CAR_D0:
	dc	$0000,$0000,$0000,$0000
CAR_D1:
	dc	$0000,$0000,$0000,$0000
CAR_D2:
	dc	$0000,$0000,$0000,$0000
CAR_D3:
	dc	$0000,$0000,$0000,$0000
CAR_D4:
	dc	$0001,$0000,$0000,$0000
CAR_D5:
	dc	$FF80,$0000,$0000,$0000
CAR_D6:
	dc	$0000,$0000,$0000,$0000
CAR_D7:
	dc	$0FE0,$0000,$0000,$0000
CAR_D8:
	dc	$FFE0,$0000,$0000,$0000
CAR_D9:
	dc	$0FFE,$0000,$0000,$0000
CAR_DA:
	dc	$FFE0,$0000,$0000,$0000
CAR_DB:
	dc	$0FFE,$0000,$0000,$0000
CAR_DC:
	dc	$0FFE,$0000,$0000,$0000
CAR_DD:
	dc	$0FE0,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$7FFF,$0000,$0000,$0000
	dc	$1FFF,$0000,$0000,$0000
	dc	$7FFF,$0000,$0000,$0000
	dc	$1FFC,$0000,$0000,$0000
	dc	$1FFC,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0001,$0000,$0000,$0000
	dc	$FFC0,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$3FF8,$0000,$0000,$0000
	dc	$FFF8,$0000,$0000,$0000
	dc	$3FFE,$0000,$0000,$0000
	dc	$FFF8,$0000,$0000,$0000
	dc	$3FFE,$0000,$0000,$0000
	dc	$3FFE,$0000,$0000,$0000
	dc	$3FF8,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$7FFF,$0000,$0000,$0000
	dc	$3FFF,$0000,$0000,$0000
	dc	$7FFF,$0000,$0000,$0000
	dc	$3FFE,$0000,$0000,$0000
	dc	$3FFE,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0001,$0000,$0000,$0000
	dc	$FFC0,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$7FFF,$0000,$0000,$0000
	dc	$3FFF,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$3FFE,$0000,$0000,$0000
	dc	$3FFE,$0000,$0000,$0000
	dc	$0F00,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$01C0,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$7800,$0000,$0000,$0000
	dc	$7C00,$0000,$0000,$0000
	dc	$003E,$0000,$0000,$0000
	dc	$7C1F,$0000,$0000,$0000
	dc	$7C1F,$0000,$0000,$0000
	dc	$0F00,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$FFC0,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$F83E,$0000,$0000,$0000
	dc	$F03E,$0000,$0000,$0000
	dc	$F800,$0000,$0000,$0000
	dc	$F03E,$0000,$0000,$0000
	dc	$F800,$0000,$0000,$0000
	dc	$F800,$0000,$0000,$0000
	dc	$F83E,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$7800,$0000,$0000,$0000
	dc	$7800,$0000,$0000,$0000
	dc	$007C,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$0F00,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0001,$0000,$0000,$0000
	dc	$FFC0,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$7C0F,$0000,$0000,$0000
	dc	$7FF0,$0000,$0000,$0000
	dc	$7FF0,$0000,$0000,$0000
	dc	$007C,$0000,$0000,$0000
	dc	$3C1E,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$0F00,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0001,$0000,$0000,$0000
	dc	$FF80,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$FF80,$0000,$0000,$0000
	dc	$FF80,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$3FFF,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$00F8,$0000,$0000,$0000
	dc	$1FFC,$0000,$0000,$0000
	dc	$7C0F,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0001,$0000,$0000,$0000
	dc	$C000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F03C,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$FF80,$0000,$0000,$0000
	dc	$FF80,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$3FFF,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$00F8,$0000,$0000,$0000
	dc	$1FFC,$0000,$0000,$0000
	dc	$3FFF,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0001,$0000,$0000,$0000
	dc	$FFC0,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$FFFE,$0000,$0000,$0000
	dc	$F078,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$FF80,$0000,$0000,$0000
	dc	$FF80,$0000,$0000,$0000
	dc	$F0FE,$0000,$0000,$0000
	dc	$1FFF,$0000,$0000,$0000
	dc	$3FFE,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$01F0,$0000,$0000,$0000
	dc	$3C1E,$0000,$0000,$0000
	dc	$3FFF,$0000,$0000,$0000
	dc	$0F00,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0001,$0000,$0000,$0000
	dc	$FFC0,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$FFFE,$0000,$0000,$0000
	dc	$F03C,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$FF80,$0000,$0000,$0000
	dc	$FF80,$0000,$0000,$0000
	dc	$F0FE,$0000,$0000,$0000
	dc	$07FF,$0000,$0000,$0000
	dc	$000F,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$01F0,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$1FFF,$0000,$0000,$0000
	dc	$0F00,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$FFC0,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$FFFE,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$F0FE,$0000,$0000,$0000
	dc	$000F,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$01E0,$0000,$0000,$0000
	dc	$7C1F,$0000,$0000,$0000
	dc	$07FF,$0000,$0000,$0000
	dc	$0F00,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$FFFE,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F800,$0000,$0000,$0000
	dc	$F03E,$0000,$0000,$0000
	dc	$F800,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$F83E,$0000,$0000,$0000
	dc	$000F,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$01E0,$0000,$0000,$0000
	dc	$3FFE,$0000,$0000,$0000
	dc	$000F,$0000,$0000,$0000
	dc	$0F00,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$3C00,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$000F,$0000,$0000,$0000
	dc	$3FFE,$0000,$0000,$0000
	dc	$3FFE,$0000,$0000,$0000
	dc	$01E0,$0000,$0000,$0000
	dc	$3FFE,$0000,$0000,$0000
	dc	$000F,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$3C00,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$000F,$0000,$0000,$0000
	dc	$3FFC,$0000,$0000,$0000
	dc	$3FFC,$0000,$0000,$0000
	dc	$01E0,$0000,$0000,$0000
	dc	$1FFC,$0000,$0000,$0000
	dc	$000F,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$3C00,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$FFF8,$0000,$0000,$0000
	dc	$3FFE,$0000,$0000,$0000
	dc	$FFF8,$0000,$0000,$0000
	dc	$3FFE,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$3FFE,$0000,$0000,$0000
	dc	$000F,$0000,$0000,$0000
	dc	$0FF0,$0000,$0000,$0000
	dc	$0FF0,$0000,$0000,$0000
	dc	$01E0,$0000,$0000,$0000
	dc	$07F0,$0000,$0000,$0000
	dc	$000F,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$3C00,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$FFE0,$0000,$0000,$0000
	dc	$0FFE,$0000,$0000,$0000
	dc	$FFE0,$0000,$0000,$0000
	dc	$0FFE,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$0FEE,$0000,$0000,$0000
	rept	20
	dc	$0000,$0000,$0000,$0000
	endr
CAR_DE:
	dc	$780F,$0000,$0000,$0000
CAR_DF:
	dc	$7FFE,$0000,$0000,$0000
CAR_E0:
	dc	$001E,$0000,$0000,$0000
CAR_E1:
	dc	$F03E,$0000,$0000,$0000
CAR_E2:
	dc	$F000,$0000,$0000,$0000
CAR_E3:
	dc	$0FE0,$0000,$0000,$0000
CAR_E4:
	dc	$0FE0,$0000,$0000,$0000
CAR_E5:
	dc	$0FE0,$0000,$0000,$0000
CAR_E6:
	dc	$FFE0,$0000,$0000,$0000
CAR_E7:
	dc	$0FE0,$0000,$0000,$0000
CAR_E8:
	dc	$FFE0,$0000,$0000,$0000
CAR_E9:
	dc	$0FF0,$0000,$0000,$0000
CAR_EA:
	dc	$FFE0,$0000,$0000,$0000
CAR_EB:
	dc	$F01E,$0000,$0000,$0000
CAR_EC:
	dc	$F01E,$0000,$0000,$0000
CAR_ED:
	dc	$F01E,$0000,$0000,$0000
CAR_EE:
	dc	$F01E,$0000,$0000,$0000
CAR_EF:
	dc	$F01E,$0000,$0000,$0000
CAR_F0:
	dc	$FFFC,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$F07C,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$3FF8,$0000,$0000,$0000
	dc	$3FF8,$0000,$0000,$0000
	dc	$3FF8,$0000,$0000,$0000
	dc	$FFF8,$0000,$0000,$0000
	dc	$3FF8,$0000,$0000,$0000
	dc	$FFF8,$0000,$0000,$0000
	dc	$3FFC,$0000,$0000,$0000
	dc	$FFF8,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$783C,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$FFFE,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$F0F8,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$783C,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$783C,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$FFFE,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$F1F0,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$783C,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$3C78,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$03C0,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$F3E0,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$FBBE,$0000,$0000,$0000
	dc	$F83E,$0000,$0000,$0000
	dc	$F83E,$0000,$0000,$0000
	dc	$F03E,$0000,$0000,$0000
	dc	$F83E,$0000,$0000,$0000
	dc	$F03E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$003E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$383C,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$1EF0,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$00FC,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$03C0,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$F7C0,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$F39E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$3C38,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$0FE0,$0000,$0000,$0000
	dc	$F81E,$0000,$0000,$0000
	dc	$01F8,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7FFF,$0000,$0000,$0000
	dc	$03C0,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$FF80,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$F39E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$7FE0,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$3C78,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$0FE0,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$03F0,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7FFF,$0000,$0000,$0000
	dc	$03C0,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$FF00,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$F39E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F03E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F03E,$0000,$0000,$0000
	dc	$7FF8,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$1E78,$0000,$0000,$0000
	dc	$F39E,$0000,$0000,$0000
	dc	$07C0,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$07E0,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7FFF,$0000,$0000,$0000
	dc	$03C0,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$FF00,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$F39E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$3FFC,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$1E70,$0000,$0000,$0000
	dc	$F39E,$0000,$0000,$0000
	dc	$07C0,$0000,$0000,$0000
	dc	$3FFE,$0000,$0000,$0000
	dc	$0FC0,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$7FFF,$0000,$0000,$0000
	dc	$03C0,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$FF80,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$F0DE,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$0FFC,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$0E70,$0000,$0000,$0000
	dc	$F39E,$0000,$0000,$0000
	dc	$0FE0,$0000,$0000,$0000
	dc	$0FFE,$0000,$0000,$0000
	dc	$1F80,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$03C0,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F7C0,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$FFF8,$0000,$0000,$0000
	dc	$F0FE,$0000,$0000,$0000
	dc	$FFF8,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$0FF0,$0000,$0000,$0000
	dc	$F39E,$0000,$0000,$0000
	dc	$0FE0,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$3F00,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$03C0,$0000,$0000,$0000
	dc	$F83E,$0000,$0000,$0000
	dc	$F3E0,$0000,$0000,$0000
	dc	$F800,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F83E,$0000,$0000,$0000
	dc	$FFE0,$0000,$0000,$0000
	dc	$F87E,$0000,$0000,$0000
	dc	$FFF8,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$F83E,$0000,$0000,$0000
	dc	$0FE0,$0000,$0000,$0000
	dc	$FBBE,$0000,$0000,$0000
	dc	$1EF0,$0000,$0000,$0000
	dc	$F03E,$0000,$0000,$0000
	dc	$7E00,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$F1F0,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$F07C,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$07E0,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$3C78,$0000,$0000,$0000
	dc	$FFFC,$0000,$0000,$0000
	dc	$FFFE,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$F0F8,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$F03C,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$07E0,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$783C,$0000,$0000,$0000
	dc	$7FFC,$0000,$0000,$0000
	dc	$FFFE,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$3FF8,$0000,$0000,$0000
	dc	$F07C,$0000,$0000,$0000
	dc	$3FFE,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$3FF8,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$3FFE,$0000,$0000,$0000
	dc	$F03E,$0000,$0000,$0000
	dc	$7FF8,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$3FF8,$0000,$0000,$0000
	dc	$03C0,$0000,$0000,$0000
	dc	$3FF8,$0000,$0000,$0000
	dc	$783C,$0000,$0000,$0000
	dc	$7FF8,$0000,$0000,$0000
	dc	$FFFE,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$780F,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	dc	$0FE0,$0000,$0000,$0000
	dc	$F03E,$0000,$0000,$0000
	dc	$0FFE,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$0FE0,$0000,$0000,$0000
	dc	$F000,$0000,$0000,$0000
	dc	$0FE6,$0000,$0000,$0000
	dc	$F03E,$0000,$0000,$0000
	dc	$1FE0,$0000,$0000,$0000
	dc	$001E,$0000,$0000,$0000
	dc	$0FE0,$0000,$0000,$0000
	dc	$03C0,$0000,$0000,$0000
	dc	$0FE0,$0000,$0000,$0000
	dc	$F01E,$0000,$0000,$0000
	dc	$1FE0,$0000,$0000,$0000
	dc	$7FFE,$0000,$0000,$0000
	rept	141
	dc	$0000,$0000,$0000,$0000
	endr
	dc	$0000,$FFF8,$FFF8,$0000
	dc	$0004,$0578,$7A80,$057C
	dc	$0000,$07FF,$07FF,$0000
	dc	$0000,$E817,$FFE8,$0017
	dc	$0000,$E00F,$000F,$E000
	dc	$0000,$FE00,$FE01,$0000
	dc	$0040,$5780,$A800,$57C0
	dc	$0000,$7FFD,$7FFF,$0000
	dc	$0002,$42BC,$FD40,$02BE
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
	dc	$5500,$8080,$8078,$7F80
	dc	$0000,$17D4,$7FF8,$0004
	dc	$000B,$07F4,$0400,$03FF
	dc	$6B10,$140A,$0005,$FFFA
	dc	$2006,$0009,$C008,$2007
	dc	$DC00,$0200,$0203,$FC00
	dc	$0000,$F4C0,$FF00,$00C0
	dc	$11FE,$6E00,$4000,$3FFF
	dc	$AC00,$037A,$00BC,$FF42
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
	dc	$2000,$8328,$80F8,$7F00
	dc	$0004,$3B88,$7FF0,$000C
	dc	$0016,$07E8,$0400,$03FF
	dc	$FE30,$000C,$0003,$FFFC
	dc	$0005,$600A,$8008,$6007
	dc	$BC00,$0201,$0207,$FC00
	dc	$0040,$E780,$F800,$07C0
	dc	$3BFD,$4400,$4000,$3FFF
	dc	$D802,$041C,$03FC,$FC02
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
	dc	$0800,$8650,$81F8,$7E00
	dc	$0008,$3F44,$7FF0,$000C
	dc	$000D,$07B0,$0440,$03BF
	dc	$5D18,$0006,$0001,$FFFE
	dc	$2003,$C00C,$0008,$E007
	dc	$DC00,$2003,$020F,$FC00
	dc	$0280,$CD40,$F000,$0FC0
	dc	$3DEA,$4200,$4000,$3FFF
	dc	$F000,$0EBE,$03FC,$FC02
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
	dc	$0000,$8CA8,$83F8,$7C00
	dc	$0004,$7E18,$3FE0,$401C
	dc	$0018,$0760,$0480,$037F
	dc	$B20C,$0003,$0000,$FFFF
	dc	$6007,$8008,$0008,$E007
	dc	$FC00,$0207,$021F,$FC00
	dc	$06C0,$9800,$E000,$1FC0
	dc	$1FD5,$4000,$4000,$3FFF
	dc	$A002,$59DC,$07FC,$F802
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
	dc	$0000,$9950,$87F8,$7800
	dc	$002C,$3E10,$7FC0,$003C
	dc	$0031,$0780,$0440,$03BF
	dc	$515B,$0004,$0000,$FFFF
	dc	$E007,$0008,$0008,$E007
	dc	$B400,$430D,$013F,$FE00
	dc	$0D40,$3000,$C000,$3FC0
	dc	$3E83,$4000,$4000,$3FFF
	dc	$0002,$D2FC,$2FFC,$D002
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
	dc	$4000,$B020,$8FF8,$7000
	dc	$001C,$7A60,$3F80,$407C
	dc	$0064,$0580,$0604,$01FB
	dc	$AA8E,$0000,$0000,$FFFF
	dc	$A007,$0008,$0008,$E007
	dc	$6C00,$801A,$03FF,$FC00
	dc	$5A40,$2000,$8000,$7FC0
	dc	$3D16,$4001,$4000,$3FFF
	dc	$0002,$957C,$7FFC,$8002
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
	dc	$0000,$E150,$9FFC,$6000
	dc	$002C,$30D0,$7F00,$00FC
	dc	$00CB,$0700,$070A,$00F5
	dc	$1D45,$0000,$0000,$FFFF
	dc	$6002,$000D,$000C,$E003
	dc	$D800,$003F,$07FC,$F803
	dc	$3440,$C000,$0000,$FFC0
	dc	$2A8C,$4003,$4000,$3FFF
	dc	$0002,$2EF8,$FFFC,$0002
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
	dc	$0000,$EA20,$FFFE,$0000
	dc	$0018,$6BE0,$3C00,$43FC
	dc	$009C,$0100,$011C,$00E3
	dc	$0020,$1780,$6800,$97FF
	dc	$A001,$0006,$0006,$E001
	dc	$B001,$0CAA,$03FC,$FC03
	dc	$2B80,$8000,$0000,$FFC0
	dc	$1018,$4046,$40E1,$3F1E
	dc	$0200,$5DF0,$F8FC,$0702
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
	dc	$0000,$3406,$3FFF,$0000
	dc	$0290,$4960,$3400,$4BF0
	dc	$00AA,$0100,$01AA,$0055
	dc	$0040,$0080,$4000,$80FF
	dc	$0000,$0003,$0003,$E000
	dc	$4003,$1954,$07F8,$F807
	dc	$5600,$0000,$0000,$FE00
	dc	$0210,$408C,$40A3,$3F1C
	dc	$0502,$A8E8,$F8FC,$0502
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
	dc	$0000,$222A,$3FFF,$0000
	dc	$0000,$DFE0,$2000,$DFF0
	dc	$005D,$0100,$015D,$00A2
	dc	$005F,$40A0,$0000,$C0FF
	dc	$A000,$0000,$0001,$E000
	dc	$3007,$8000,$8FF8,$7007
	dc	$AC00,$0000,$0000,$FC00
	dc	$1500,$4018,$40A7,$3F18
	dc	$0000,$1DC0,$F8FC,$0502
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
	dc	$0000,$0015,$3FFF,$0000
	dc	$0A10,$35E0,$C000,$3FF0
	dc	$00BE,$0100,$01BE,$0041
	dc	$8000,$0000,$C000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$000F,$5800,$C7F0,$380F
	dc	$5800,$0000,$0000,$F800
	dc	$0010,$6A0C,$7FA3,$001C
	dc	$05EA,$B800,$F800,$05FE
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
	dc	$0000,$202B,$3FFE,$0001
	dc	$1400,$6BE0,$8000,$7FF0
	dc	$007F,$0010,$017F,$0080
	dc	$0140,$7E80,$0000,$FFC0
	dc	$0000,$0000,$0000,$0000
	dc	$001E,$1C60,$6380,$1C7F
	dc	$3000,$0000,$0000,$F000
	dc	$0000,$002A,$0015,$002A
	dc	$0000,$7C00,$F800,$0400
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
	dc	$0000,$0813,$37FC,$0803
	dc	$2010,$DFE0,$0000,$FFF0
	dc	$00FE,$0128,$01FE,$0001
	dc	$9540,$0000,$8000,$7FC0
	dc	$0000,$0000,$0000,$0000
	dc	$00B7,$0B40,$3400,$0BFF
	dc	$6000,$0000,$0000,$E000
	dc	$0000,$0002,$003F,$0000
	dc	$0400,$B800,$F800,$0400
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
	dc	$0001,$3D46,$22B8,$1D47
	dc	$4000,$BFE0,$0000,$FFF0
	dc	$00FD,$0050,$01FD,$0002
	dc	$0040,$0000,$0000,$FFC0
	dc	$0000,$0000,$0000,$0000
	dc	$01EE,$1E00,$0000,$1FFF
	dc	$C000,$0000,$0000,$C000
	dc	$0000,$0025,$001F,$0020
	dc	$0400,$F800,$F800,$0400
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
	dc	$0A00,$148F,$2170,$1E8F
	dc	$8020,$7FC0,$0000,$FFF0
	dc	$00FE,$00A8,$01FE,$0001
	dc	$8040,$0000,$8000,$7FC0
	dc	$0000,$0000,$0000,$0000
	dc	$0BDD,$2400,$1000,$2FFF
	dc	$8000,$0000,$0000,$8000
	dc	$0000,$0008,$003F,$0000
	dc	$0400,$F800,$F800,$0400
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
	dc	$1C15,$03CA,$2020,$1FDF
	dc	$0000,$FF60,$0080,$FF70
	dc	$00FF,$0054,$01FF,$0000
	dc	$0040,$0000,$0000,$FFC0
	dc	$0000,$0000,$0000,$0000
	dc	$0EF9,$4000,$2000,$5FFF
	dc	$8000,$0000,$0000,$8000
	dc	$0000,$0020,$001F,$0020
	dc	$0400,$F000,$F800,$0400
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
	dc	$1E0A,$01B5,$2040,$1FBF
	dc	$0000,$FE20,$01C0,$FE30
	dc	$00FE,$00A8,$01FE,$0001
	dc	$1040,$0000,$0000,$FFC0
	dc	$0000,$0000,$0000,$0000
	dc	$0550,$8000,$4000,$BFFF
	dc	$4000,$0000,$0000,$C000
	dc	$0000,$0033,$000F,$0030
	dc	$0000,$9000,$E800,$1400
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
	dc	$0D14,$02EB,$2000,$1FFF
	dc	$5030,$AD40,$0290,$FD60
	dc	$00FC,$0050,$01FC,$0003
	dc	$0100,$0000,$0100,$FEC0
	dc	$0000,$0001,$0000,$0001
	dc	$0020,$0000,$8000,$7FFF
	dc	$A000,$0000,$8000,$6000
	dc	$0000,$002D,$0017,$0028
	dc	$0400,$3800,$C000,$3C00
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
	dc	$0628,$21D7,$0000,$3FFF
	dc	$A040,$5A80,$0500,$FAF0
	dc	$00F8,$0000,$01F8,$0007
	dc	$3F40,$4000,$0000,$FFC0
	dc	$0000,$0002,$0001,$0002
	dc	$0100,$0000,$0000,$FFFF
	dc	$C000,$0000,$C000,$3000
	dc	$0000,$0031,$000E,$0031
	dc	$0000,$7000,$8800,$7400
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
	dc	$0F55,$00AA,$2000,$1FFF
	dc	$0050,$F780,$0810,$F7E0
	dc	$00F0,$0100,$00F0,$010F
	dc	$C000,$0000,$0000,$C000
	dc	$0001,$0004,$0002,$0005
	dc	$8001,$0000,$0001,$FFFE
	dc	$E000,$0000,$E000,$1800
	dc	$0028,$0007,$0010,$002F
	dc	$0400,$F800,$0000,$FC00
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
	dc	$1EEE,$2111,$0000,$3FFF
	dc	$0320,$8000,$7C20,$83D0
	dc	$00E0,$0000,$01E0,$001F
	dc	$4002,$0000,$0002,$C0FD
	dc	$E003,$0008,$E004,$000B
	dc	$4222,$0000,$0222,$FDDD
	dc	$F800,$0000,$F800,$0400
	dc	$001F,$0020,$0000,$003F
	dc	$5000,$A800,$0000,$FC00
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
	dc	$1B7A,$0081,$2000,$1FFB
	dc	$0250,$0400,$F850,$07A0
	dc	$0040,$0100,$0040,$01BF
	dc	$4057,$0000,$0057,$C0A8
	dc	$E002,$0000,$E008,$0007
	dc	$A157,$0000,$0157,$FEA8
	dc	$FC00,$0000,$FC00,$0200
	dc	$003E,$0001,$0000,$003F
	dc	$8000,$7800,$0000,$FC00
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
	dc	$17A9,$A050,$4000,$BFF9
	dc	$043C,$2800,$D03C,$2FC0
	dc	$0010,$0300,$0400,$03FF
	dc	$742A,$0000,$002A,$FFD5
	dc	$A005,$0008,$A000,$400F
	dc	$02AF,$0002,$02AF,$FD50
	dc	$EBC0,$0000,$EBC0,$1400
	dc	$005D,$00A2,$0000,$00FF
	dc	$4100,$B800,$0100,$FE00
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
	dc	$6F08,$00F0,$8000,$7FF8
	dc	$897C,$7004,$017C,$FE80
	dc	$0308,$0400,$0300,$04FF
	dc	$1554,$0000,$1554,$EAAB
	dc	$A000,$0000,$2008,$C007
	dc	$051F,$0005,$051F,$FAE0
	dc	$D440,$0040,$D440,$2B80
	dc	$00FB,$0004,$0000,$00FF
	dc	$8000,$7E00,$0000,$FF00
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
	dc	$5600,$8180,$0070,$FF88
	dc	$32FC,$0008,$02FC,$7D00
	dc	$0210,$0400,$0200,$05FF
	dc	$2AA9,$0000,$2AA8,$D557
	dc	$E000,$2008,$2000,$C00F
	dc	$0A5F,$0008,$0A1F,$F5E0
	dc	$A8C0,$8000,$A840,$5780
	dc	$0074,$008B,$0000,$00FF
	dc	$0100,$FE00,$0100,$FE00
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
	dc	$2A08,$81A0,$0070,$FF88
	dc	$29FC,$0014,$01FC,$7E00
	dc	$0020,$0400,$0000,$07FF
	dc	$5553,$0000,$5550,$AAAF
	dc	$A000,$0008,$2000,$C00F
	dc	$142F,$0000,$140F,$EB30
	dc	$D640,$40C0,$D440,$2B80
	dc	$00A0,$005F,$0000,$00FF
	dc	$0000,$AE00,$5000,$AF00
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
	dc	$7600,$8150,$00F0,$FF08
	dc	$1FFC,$0028,$03FC,$7C00
	dc	$0042,$0400,$0002,$07FD
	dc	$AAA3,$0004,$AAA0,$555F
	dc	$2002,$2008,$2002,$C00D
	dc	$2807,$0000,$2807,$D618
	dc	$E840,$0180,$E840,$1780
	dc	$00C0,$003D,$0002,$00FD
	dc	$0500,$5200,$A900,$5600
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
	dc	$3408,$8A00,$01F0,$FE08
	dc	$6FFC,$0054,$47FC,$3800
	dc	$0005,$0400,$0005,$07FA
	dc	$554C,$0002,$5540,$AABF
	dc	$2005,$0008,$2005,$C00A
	dc	$5607,$0000,$5407,$AA08
	dc	$5240,$0040,$51C0,$AE00
	dc	$0080,$0068,$0017,$00E8
	dc	$0300,$BC00,$4100,$BE00
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
	dc	$E000,$1B70,$05F0,$FA08
	dc	$0FFC,$02A8,$0FFC,$7000
	dc	$002A,$0400,$002A,$07D5
	dc	$AA60,$0008,$AA14,$55EB
	dc	$200A,$2000,$2002,$C00D
	dc	$A803,$0000,$A803,$5604
	dc	$E040,$0700,$E1C0,$1E00
	dc	$0080,$0050,$002F,$00D0
	dc	$0500,$5A00,$A100,$5E00
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
	dc	$4000,$B2E0,$0FF0,$F008
	dc	$67FC,$0154,$47FC,$3800
	dc	$0555,$0000,$0155,$06AA
	dc	$54C8,$0030,$5400,$ABFF
	dc	$2001,$0008,$2001,$C00E
	dc	$5601,$0000,$5401,$AA02
	dc	$C040,$06C0,$CBC0,$3400
	dc	$0000,$0000,$007F,$0080
	dc	$0300,$BC00,$4100,$BE00
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
	dc	$BD40,$4000,$0000,$FFF8
	dc	$3FFC,$02A8,$3FFC,$4000
	dc	$03F4,$0400,$0000,$07FF
	dc	$0BFF,$000A,$0BFF,$F400
	dc	$E00B,$A004,$E000,$000F
	dc	$D401,$0000,$0001,$FE00
	dc	$FFC0,$2A80,$FFC0,$0000
	dc	$00A1,$0000,$0001,$00FE
	dc	$5F00,$0100,$5F00,$A000
	rept	2251	
	dc	$0000,$0000,$0000,$0000
	endr
	dc	$0000,$0004,$0008,$000C
	dc	$0003,$0007,$000B,$000F
	dc	$0001,$0001,$0001,$0001
	dc	$0080,$0054,$002A,$0000


FONTE:
	DC.L      FONTEs 
	DC.L      CAR_B7 
	DC.L      CAR_B8 
	DC.L      CAR_B9 
	DC.L      CAR_BA 
	DC.L      CAR_BB 
	DC.L      CAR_BC 
	DC.L      CAR_BD 
	DC.L      CAR_BE 
	DC.L      CAR_BF 
	DC.L      CAR_C0 
	DC.L      CAR_C1 
	DC.L      CAR_C2 
	DC.L      CAR_C3 
	DC.L      CAR_C4 
	DC.L      CAR_C5 
	DC.L      CAR_C6 
	DC.L      CAR_C7 
	DC.L      CAR_C8 
	DC.L      CAR_C9 
	DC.L      CAR_CA 
	DC.L      CAR_CB 
	DC.L      CAR_CC 
	DC.L      CAR_CD 
	DC.L      CAR_CE 
	DC.L      CAR_CF 
	DC.L      CAR_D0 
	DC.L      CAR_D1 
	DC.L      CAR_D2 
	DC.L      CAR_D3 
	DC.L      CAR_D4 
	DC.L      CAR_D5 
	DC.L      CAR_D6 
	DC.L      CAR_D7 
	DC.L      CAR_D8 
	DC.L      CAR_D9 
	DC.L      CAR_DA 
	DC.L      CAR_DB 
	DC.L      CAR_DC 
	DC.L      CAR_DD 
	DC.L      CAR_DE 
	DC.L      CAR_DF 
	DC.L      CAR_E0 
	DC.L      CAR_E1 
	DC.L      CAR_E2 
	DC.L      CAR_E3 
	DC.L      CAR_E4 
	DC.L      CAR_E5 
	DC.L      CAR_E6 
	DC.L      CAR_E7 
	DC.L      CAR_E8 
	DC.L      CAR_E9 
	DC.L      CAR_EA 
	DC.L      CAR_EB 
	DC.L      CAR_EC 
	DC.L      CAR_ED 
	DC.L      CAR_EE 
	DC.L      CAR_EF 
	DC.L      CAR_F0 
	even
	
TEXTEs:
	DC.B	'ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789'
	DC.B	'!(),.:-?',$27,' BLAH BLAH BLAH BLAH BLAH BLAH '
CARAC1:
	DC.B	'    [',$00 
	even
	
musik
	INCBIN	"NEWHIST.SND"
	;INCBIN	"crapman8.snd"
	even

mod_rout
  incbin	"sndtrck.bin"
  even

module:
  ;incbin 	her1.mod	*	estrayk/Paradox
  incbin 	virgill2.mod	*	by Virgill
	even
	
******************************************************************

	SECTION	BSS

rien:
  ds.b	16000*8		* Workspace
modulend:
  ds.w	1

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
	ds.b	256		; byte boundary
start_screen:
	ds.b	34*160		; top border area
	ds.b	32000		; main screen
	ds.b	35*160		; bottom border area
screen_len	equ	*-start_screen

POSITION:
	DS.W	1 
BUFFER:
	DS.B	4918

	END
