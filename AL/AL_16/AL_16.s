*************
* AL_16.PRG *
*************

* // Intro Code version 0.31		// *
* // Original code : Zorro 2/NoeXtra	// *
* // 3d code       : Dracula/Positivity // *
* // Gfx logo 	   : Mister.A/NoeXtra	// *
* // Gfx font      : ripped		// *
* // Music 	   : Rhino		// *
* // Release date  : 09/11/2008		// *
* // Update date   : 08/01/2009		// *

**************************************************
	OPT	c+	 ; Case sensitivity on.
	OPT	d-	 ; Debug off.
	OPT	o-	 ; All optimisations off.
	OPT	w-	 ; Warnings off.
	OPT	x-	 ; Extended debug off.
**************************************************

	SECTION	TEXT

***********************************************************
BOTTOM_BORDER	equ 0	  ; Using the bottom overscan
			  ; 0 = I use it and 1 = no need !
PATTERN		equ $0    ; To see the screen plan
			  ; put $0 to see nothing
			  ; put $010f to see lines
SEEMYVBL	equ 0     ; if you press ALT key
			  ; 0 = see CPU & 1 = see nothing
TEMPO equ $9F	; Time between 2 screens with cursor text
***********************************************************

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

	bsr	clear_bss
	
	bsr	Init_screens

	bsr	Save_and_init_a_st

	bsr	Init0

******************************************************************************

	bsr	Init
	
MainLoop:

	bsr	Wait_vbl

	IFEQ	SEEMYVBL
	move.w	#$0100,$ffff8240.w
	ENDC

* Put your code here !
* >
	* 3D part
	bsr	efface_poly
	bsr	draw_polygon
	* Texts part
	bsr	put_texte
	bsr	ScrollH
	* Swapping screen
	move.l	Zorro_scr1,d0
	move.l	Zorro_scr2,Zorro_scr1
	move.l	d0,Zorro_scr2
	lsr.w   #8,d0 
	move.l  d0,$ffff8200.w
	* Accelerate and slow the cursor text
	cmpi.b	#$4E,$FFFFFC02.w	*	keypad +
	bne.s	.nextp
	move.b 	#4,vitesse
.nextp:
	cmpi.b	#$4A,$FFFFFC02.w	*	keypad -
	bne.s	.nextm
	move.b 	#2,vitesse
.nextm:

* <
	
	IFEQ	SEEMYVBL
	cmp.b	#$38,$fffffc02.w	* ALT KEY ?
	bne.s	MainNext
	move.b	#7,$ffff8240.w
MainNext:	
	ENDC

	cmp.b	#$39,$fffffc02.w	* SPACE KEY ?
	bne	MainLoop

******************************************************************************

	bsr	Restore_st

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
	movem.l	d0-d7/a0-a6,-(a7)
	st	Vsync
	jsr 	(MUSIC+8)			; call music
	movem.l	(a7)+,d0-d7/a0-a6
	rte
	
Vbl:

	IFEQ	BOTTOM_BORDER
	
      MOVEM.L   A0/D0,-(A7) 
      MOVE      SR,-(A7)
      MOVE      #$2700,SR 
      MOVE.L    #$592,D0
.loop:DBF       D0,.loop
      MOVE.B    #0,$FFFF820A.W
      MOVEQ     #4,D0 
.wait:DBF       D0,.wait
      MOVE.B    #2,$FFFF820A.W
      MOVE      (A7)+,SR
      MOVEM.L   (A7)+,A0/D0 

	st	Vsync

  move.l	a0,-(a7)
  move.l	a1,-(a7)
  LEA   Pal,A0 
  MOVEA.L   #$FF8240,A1 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  move.l	(a7)+,a1
  move.l	(a7)+,a0
  
      CLR.B     $FFFFFA1B.W 
      MOVE.B    #54,$FFFFFA21.W
      MOVE.L    #HBL,$120.W 
      MOVE.B    #8,$FFFFFA1B.W

	ENDC
	
	jsr 	(MUSIC+8)			; call music
	
	rte

Wait_vbl:
	move.l	a0,-(a7)
	lea	Vsync,a0
	sf	(a0)
.loop:	tst.b	(a0)
	beq.s	.loop
	move.l	(a7)+,a0
	rts

*********************************************
*                                           *
*********************************************

Init0:	movem.l	d0-d7/a0-a6,-(a7)

	bsr	fadein
	
	clr.w	$ffff8240.w
	
	jsr	MUSIC+0			; init music

	movea.l	Zorro_scr1,a1
	adda.l	#160*76,a1
	movea.l	#LogoNoeXtra,a0
	move.l	#7999-6800+180,d0
.aff:	move.l	(a0)+,(a1)+
	dbf	d0,.aff
                	
	lea	Vbl0(pc),a0
	move.l	a0,$70.w

	lea     PalNoeXtra,a2
	bsr     fadeon	

	lea	PalNoeXtra,a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

	bsr	delay

	* Precalc 
	bsr	Genere_code
	* Inits for cursor text
	bsr	Init_texte
	* Precalc the little scroll down
	bsr	Init_ScrollH
	* No 3d inits : realtime used !

	bsr	fadeoff

	move.l Zorro_scr1,a0
	bsr clear_screen
		
	movem.l	(a7)+,d0-d7/a0-a6
	rts

Init:	movem.l	d0-d7/a0-a6,-(a7)

	lea	Vbl(pc),a0
	move.l	a0,$70.w

	lea	Pal(pc),a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

ok	equ	11*160-80-2
dep equ 160*6

	movea.l	Zorro_scr1,a1
	lea	dep(a1),a1
	movea.l	Zorro_scr2,a2
	lea	dep(a2),a2
	movea.l	#Logo_Al,a0
	move.l	#ok,d0
.aff:
	move.l	(a0),(a1)+
	move.l	(a0)+,(a2)+
	dbf	d0,.aff

HEIGHT equ 7999-7800+280
POSITION equ 160*220

	movea.l	Zorro_scr1,a1
	adda.l	#POSITION,a1
	movea.l	Zorro_scr2,a2
	adda.l	#POSITION,a2
	movea.l	#Logo_NoeX,a0
	move.l	#HEIGHT,d0
.aff1:	move.l	(a0),(a1)+
	move.l	(a0)+,(a2)+
	dbf	d0,.aff1

	movem.l	(a7)+,d0-d7/a0-a6
	rts

************************************************
*                                              *
************************************************

Save_and_init_a_st:

	move #$2700,sr
		
	lea	Save_all,a0

	move.b	$fffffa03.w,(a0)+
	move.b	$fffffa07.w,(a0)+
	move.b	$fffffa09.w,(a0)+
	move.b	$fffffa11.w,(a0)+
	move.b	$fffffa13.w,(a0)+
	move.b	$fffffa15.w,(a0)+
	move.b	$fffffa17.w,(a0)+
	move.b	$fffffa19.w,(a0)+

	move.b	$fffffa1b.w,(a0)+
	move.b	$fffffa1d.w,(a0)+
	move.b	$fffffa1f.w,(a0)+
	move.b	$fffffa21.w,(a0)+

	move.b	$ffff8201.w,(a0)+
	move.b	$ffff8203.w,(a0)+
	move.b	$ffff820a.w,(a0)+
	move.b	$ffff820d.w,(a0)+
	
	move.b	$ffff8260.w,(a0)+

	lea	Save_rest,a0

	move.l	$068.w,(a0)+	
	move.l	$070.w,(a0)+	
	move.l	$110.w,(a0)+	
	move.l	$114.w,(a0)+	
	move.l	$118.w,(a0)+	
	move.l	$120.w,(a0)+	
	move.l	$134.w,(a0)+	
	move.l	$484.w,(a0)+	

	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,(a0)

	bclr	#3,$fffffa17.w

	sf	$ffff8260.w

	clr.b	$fffffa07.w 
	clr.b	$fffffa09.w 

	move.l	Zorro_scr1,d0
	move.b	d0,d1
	lsr.w	#8,d0
	move.b	d0,$ffff8203.w
	swap	d0
	move.b	d0,$ffff8201.w
	move.b	d1,$ffff820d.w

	IFEQ	BOTTOM_BORDER
	CLR.B     $FFFFFA07.W 
	CLR.B     $FFFFFA09.W 
	CLR.B     $FFFFFA1B.W 
	ORI.B     #1,$FFFFFA07.W
	ORI.B     #1,$FFFFFA13.W
	ENDC

	stop	#$2300

	clr.b	$484.w		; No bip,no repeat.
			
	bsr	hide_mouse

	bsr	flush
	move.b	#$12,d0
	bsr	setkeyboard
		
	rts

	IFEQ	BOTTOM_BORDER
***************************************************************
*                                                             *
*             < Here is the lower border rout >               *
*                                                             *
***************************************************************

Pal_Sprite:	dc.w	$0312,$0503,$0FFF,$0FFF,$0,$0,$0FFF,$0FFF

HBL:  MOVE.B    #$FF,$FFFF8240.W * blanc
      CLR.B     $FFFFFA1B.W 
      MOVE.B    #1,$FFFFFA21.W
      MOVE.B    #8,$FFFFFA1B.W
      MOVE.L    #HBL_debut,$120.W
      RTE 
      
HBL_debut:CLR.B     $FFFFFA1B.W 
      MOVE.B    #160,$FFFFFA21.W
      MOVE.L    #HBL_noir,$120.W 
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
      MOVE.B    #$0,$FFFF8240.W *	debut
      MOVE.B    (A0),D0 
.att:CMP.B     (A0),D0 
      BEQ.S     .att 
      MOVEM.L   (A7)+,A0/D0 
      MOVE      #$2300,SR 

  move.l	a0,-(a7)
  move.l	a1,-(a7)
  LEA   Pal_Sprite,A0 
  MOVEA.L   #$FF8240,A1 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  move.l	(a7)+,a1
  move.l	(a7)+,a0
  
      BCLR      #0,$FFFFFA0F.W
      RTE 

HBL_noir:MOVE.B    #$0,$FFFF8240.W * 1 ligne noir
      CLR.B     $FFFFFA1B.W 
      MOVE.B    #1,$FFFFFA21.W
      MOVE.B    #8,$FFFFFA1B.W
      MOVE.L    #HBL_blanc,$120.W
      RTE 

HBL_blanc:MOVE.B    #$FF,$FFFF8240.W * 2 lignes blanches
      CLR.B     $FFFFFA1B.W 
      MOVE.B    #1,$FFFFFA21.W
      MOVE.B    #8,$FFFFFA1B.W
      MOVE.L    #HBL_finale,$120.W
      RTE 

HBL_finale:CLR.B     $FFFFFA1B.W 
      MOVE.B    #11,$FFFFFA21.W
      MOVE.L    #hblFin,$120.W 
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
      MOVE.W    #$0100,$FFFF8240.W * 1 ligne de fond
      MOVE.B    (A0),D0 
.att:CMP.B     (A0),D0 
      BEQ.S     .att 
      MOVEM.L   (A7)+,A0/D0 
      MOVE      #$2300,SR 

  move.l	a0,-(a7)
  move.l	a1,-(a7)
  LEA   Pal_NoeX,A0 
  MOVEA.L   #$FF8240,A1 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  move.l	(a7)+,a1
  move.l	(a7)+,a0
  
      BCLR      #0,$FFFFFA0F.W
      RTE
      
hblFin:CLR.B     $FFFFFA1B.W 
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
      BCLR      #0,$FFFFFA0F.W
      RTE 

hblfin:
      BCLR      #0,$FFFFFA0F.W
      RTE

	ENDC
	
***************************************************************
*                                                             *
***************************************************************

Restore_st:

	move #$2700,sr

	jsr	MUSIC+4			; de-init music

	lea       $ffff8800.w,a0
	move.l    #$8000000,(a0)
	move.l    #$9000000,(a0)
	move.l    #$a000000,(a0)
	
	lea	Save_all,a0
	
	move.b	(a0)+,$fffffa03.w
	move.b	(a0)+,$fffffa07.w
	move.b	(a0)+,$fffffa09.w
	move.b	(a0)+,$fffffa11.w
	move.b	(a0)+,$fffffa13.w
	move.b	(a0)+,$fffffa15.w
	move.b	(a0)+,$fffffa17.w
	move.b	(a0)+,$fffffa19.w

	move.b	(a0)+,$fffffa1b.w
	move.b	(a0)+,$fffffa1d.w
	move.b	(a0)+,$fffffa1f.w
	move.b	(a0)+,$fffffa21.w
	
	move.b	(a0)+,$ffff8201.w
	move.b	(a0)+,$ffff8203.w
	move.b	(a0)+,$ffff820a.w
	move.b	(a0)+,$ffff820d.w
	
	move.b	(a0)+,$ffff8260.w

	lea	Save_rest,a0

	move.l	(a0)+,$068.w
	move.l	(a0)+,$070.w
	move.l	(a0)+,$110.w
	move.l	(a0)+,$114.w
	move.l	(a0)+,$118.w
	move.l	(a0)+,$120.w
	move.l	(a0)+,$134.w
	move.l	(a0)+,$484.w

	movem.l	(a0),d0-d7
	movem.l	d0-d7,$ffff8240.w

	bset.b #3,$fffffa17.w

	stop	#$2300

	bsr	flush
	move.b	#8,d0
	bsr	setkeyboard	
	
	bsr	show_mouse

	movea.l   $44e.w,a0 
	move.w    #8000-1,d0 
.cls:	clr.l     (a0)+ 
	dbf       d0,.cls

	move.b	Video,$ffff8260.w

	move.w	#$25,-(a7)
	trap	#14
	addq.w	#2,a7

	rts

************************************************
*                                              *
************************************************

Init_screens:
	movem.l	d0-d7/a0-a6,-(a7)

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
.scr1:	move.l	#PATTERN,(a6)+
	dbra	d1,.scr1

	movea.l	Zorro_scr2,a6
	move.w	#Zorro_screen2_len/4-1,d1
.scr2:	move.l	#PATTERN,(a6)+
	dbra	d1,.scr2
	
	movem.l	(a7)+,d0-d7/a0-a6
	rts

************************************************
*                                              *
************************************************

hide_mouse:
	movem.l	d0-d2/a0-a2,-(sp)
	dc.w	$a00a
	movem.l	(sp)+,d0-d2/a0-a2
	rts

show_mouse:
	movem.l	d0-d2/a0-a2,-(sp)
	dc.w	$A009
	movem.l	(sp)+,d0-d2/a0-a2
	rts

flush:	lea	$FFFFFC00.w,a0
.flush:	move.b	2(a0),d0
	btst	#0,(a0)
	bne.s	.flush
	rts

setkeyboard:
.wait:	btst	#1,$fffffc00.w
	beq.s	.wait
	move.b	d0,$FFFFFC02.w
	rts

clear_bss:
	lea	bss_start,a0
.loop:	clr.l	(a0)+
	cmp.l	#bss_end,a0
	blt.s	.loop
	rts

************************************************
*           FADING WHITE TO BLACK              *
*         (Don't use VBL with it !)            *
************************************************

fadein:	move.l	#$777,d0
.deg:	bsr.s	wart
	bsr.s	wart
	bsr.s	wart
	lea	$ffff8240.w,a0
	moveq	#15,d1
.chg1:	move.w	d0,(a0)+
	dbf	d1,.chg1
	sub.w	#$111,d0
	bne.s	.deg
	clr.w	$ffff8240.w
	rts

wart:	move.l	d0,-(sp)
	move.l	$466.w,d0
.att:	cmp.l	$466.w,d0
	beq.s	.att
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

delay:
  MOVE.b     #$7F,D0 
.synch:
	BSR       Wait_vbl
	sub.b	#1,d0
	cmp.b	#$0,d0	
	bne.s	.synch
	rts	

clear_screen:
		movem.l	d0-d7/a0-a6,-(a7)
		moveq #PATTERN,d0
		move #1999,d1
.cls		move.l d0,(a0)+
		move.l d0,(a0)+
		move.l d0,(a0)+
		move.l d0,(a0)+
		dbf d1,.cls
		movem.l	(a7)+,d0-d7/a0-a6
		rts
		
************************************************
*            Displaying cursor text            *
*             1 plan 8*8 + cursor              *
*      Display + clear Fx done by Zorro 2      *
*           Special font by Mister.A           *
************************************************
pos_obj	equ	(160*70)+8*6
retour_obj equ (160*11-(8*13))
vitesse_compt	equ	4	; 2 for speedy
POSH equ 160*70
POSB equ 160*129

Init_texte:
           move.w 	#vitesse_compt,cmpt_vbl	* init compteur VBL pour texte
           move.l 	#ptexte-1,ptr
           clr.w 	anim
           move.w	#pos_obj,adr_obj
           move.w 	#vitesse_compt,vitesse
initCLS:   move.w	clsL,d7
           moveq.w		#$0,d7
           move.w	d7,clsL
           move.w	d7,totalL
           move.w	d7,tempoL
           move.l Zorro_scr1,a5
           lea	POSH(a5),a5
           move.l	a5,posHscr1
           move.l a5,a6
           lea	POSB(a6),a6
           move.l	a6,posBscr1
           move.l Zorro_scr2,a5
           lea	POSH(a5),a5
           move.l	a5,posHscr2
           move.l a5,a6
           lea	POSB(a6),a6
           move.l	a6,posBscr2
           rts

put_texte: move.w	clsL,d7
           cmp.w #$FFF,d7 
           beq	CLS_TEXTE
           subq.w 	#1,cmpt_vbl
           bne 		nocurseur
           cmp.b	#4,vitesse
           bne.s	vlente
vnormale:  move.w 	#2,cmpt_vbl
           bra.s	suite
vlente:    move.w 	#4,cmpt_vbl
suite:     moveq 	#0,d0
           addq.l 	#1,ptr
           move.l 	ptr,a0
           move.b 	(a0),d0
           ; End of the text
           cmp.b 	#$fd,d0
           bne.s 	.deb_lig
           move.l #ptexte-1,ptr
           move.w	#pos_obj,adr_obj
           move.w	clsL,d7
           move.w		#$FFF,d7
           move.w	d7,clsL
           bra 		nocurseur
           ; End of the text line
.deb_lig:  cmp.b 	#$ff,d0
           bne	.pas_deb
           bsr	screens
i set 0
           rept 8
           clr.b 	i(a3)
           clr.b 	i+160*2+2(a3)
           clr.b 	i(a4)
           clr.b 	i+160*2+2(a4)
i set i+160
           endr
           add.w 	#retour_obj,adr_obj
           clr.w 	anim
           bra	 	nocurseur
.pas_deb:  cmp.b	#$fe,d0
           bne 	.caract
           bsr	screens
i set 0
           rept 8
           clr.b 	i(a3)
           clr.b 	i+160*2+2(a3)
           clr.b 	i(a4)
           clr.b 	i+160*2+2(a4)
i set i+160
           endr
           move.w 	#pos_obj,adr_obj
           clr.w	anim
           move.w	clsL,d7
           move.w		#$FFF,d7
           move.w	d7,clsL
           bra 		nocurseur
           ; Character to display
.caract:   asl.w 	#3,d0
           lea 		font,a0
           sub.w	#256,d0
           add.w 	d0,a0
           bsr	screens
i set 0
           rept	8
           move.b 	(a0),i(a3)
           move.b 	(a0),i+160*2+2(a3)
           move.b 	(a0),i(a4)
           move.b 	(a0)+,i+160*2+2(a4)
i set i+160
           endr
           ; Find the next character
           tst.w 	anim
           bne.s 	.next_car
           move.b 	#1,anim
           addq.w 	#1,adr_obj
           bra.s 	curseur
.next_car: clr.w 	anim
           addq.w 	#7,adr_obj
           ; Display cursor
curseur:   
           lea		font,a0
           lea	728(a0),a0
           bsr	screens
i set 0
           rept	8
           move.b 	(a0),i(a3)
           move.b 	(a0),i+160*2+2(a3)
           move.b 	(a0),i(a4)
           move.b 	(a0)+,i+160*2+2(a4)
i set i+160
           endr
nocurseur: rts

screens:   move.l 	Zorro_scr1,a3
           lea	2(a3),a3
           add.w 	adr_obj,a3
           move.l 	Zorro_scr2,a4
           lea	2(a4),a4
           add.w 	adr_obj,a4
           rts

plus:      move.w 	#4,cmpt_vbl
           rts

moins:     move.w 	#2,cmpt_vbl
           rts

NB_LIGNE_CLS equ 64

CLS_TEXTE:
           move.w	tempoL,d7
           cmp.w	#TEMPO,d7
           bne.s	.end
           move.w	totalL,d7
           cmp.w #NB_LIGNE_CLS,d7 
           ble.s	EFF_TEXTE
           cmp.w #NB_LIGNE_CLS,d7 
           ble.s	.end
           bra	initCLS
.end:      move.w	tempoL,d7
           add.w	#1,d7
           move.w	d7,tempoL
           RTS 

LONGEUR_CLS equ 13
POSITION_CLS equ 48

EFF_TEXTE:
           add.w	#1,d7
           move.w	d7,totalL
           move.l posHscr1,a3
           move.l posBscr1,a4
           move.l posHscr2,a5
           move.l posBscr2,a6
           MOVEQ     #0,D0 
i set POSITION_CLS
           rept LONGEUR_CLS
           MOVE.L    D0,i(A3)
           MOVE.L    D0,i+160*2+2(A3)
           MOVE.L    D0,i(A4)
           MOVE.L    D0,i+160*2+2(A4)
           MOVE.L    D0,i(A5)
           MOVE.L    D0,i+160*2+2(A5)
           MOVE.L    D0,i(A6)
           MOVE.L    D0,i+160*2+2(A6)
i set i+8
           endr
           lea.l $a0*2(a3),a3
           move.l a3,posHscr2
           suba.l #2*$a0,a4
           move.l a4,posBscr2
           lea.l $a0*2(a5),a5
           move.l a5,posHscr1
           suba.l #2*$a0,a6
           move.l a6,posBscr1
           RTS

************************************************
*               3D from XMAS 93                *
*                STF code used                 *
*             Dracula/Positivity               *
*           Modifications by Zorro 2           *
*            Star design by Juliane :)         *
************************************************
nb_coord equ $4 ; <-- pas touche !!!
nb_solide equ $5 ; Une étoile à cinq branches

draw_polygon:
  move.w	alpha,d0
  addq.w	#$4,d0	; Incrementer l' angle.
  cmp.w	#$200,d0	; alpha=512?
  bne	.alpha_ok
  moveq.l	#$0,d0	; Alors c' est equivalent a 0.
.alpha_ok:
  move.w	d0,alpha
  move.l	#sin_cos,a0
  add.w	d0,d0	; 1 sinus=1 mot.
  move.w	(a0,d0.w),d1	; d1=sin(alpha).
  add.w	#$100,a0
  move.w	(a0,d0.w),d0	; d0=cos(alpha).

  * position du solide par d‚faut
  move.w	#85,d6	; d6=incx.
  move.w	#85,d7	; d7=incy.
  
  move.l	#coords,a0
  move.l	#new_coords,a1

  rept	(nb_coord*nb_solide)
  move.w	(a0)+,d2	; d2=x.
  move.w	(a0)+,d3	; d3=y.
  move.w	d2,d4
  move.w	d3,d5
  muls.w	d0,d2	; d2=x*cos.
  add.l	d2,d2
  add.l	d2,d2
  swap.w	d2
  muls.w	d1,d4	; d4=x*sin.
  add.l	d4,d4
  add.l	d4,d4
  swap.w	d4
  muls.w	d0,d3	; d3=y*cos.
  add.l	d3,d3
  add.l	d3,d3
  swap.w	d3
  muls.w	d1,d5	; d5=y*sin.
  add.l	d5,d5
  add.l	d5,d5
  swap.w	d5
  sub.w	d5,d2	; d2=x*cos-y*sin.
  add.w	d4,d3	; d3=x*sin+y*cos.
  add.w	d6,d2	; d2=d2+incx.
  add.w	d7,d3	; d3=d3+incy.
  move.w	d2,(a1)+
  move.w	d3,(a1)+
  endr

  move.l	Zorro_scr1,a0	
  lea	160*57(a0),a0
  move.l	#new_coords+(16*0),a1
  moveq.l	#nb_coord,d0
  jsr	polygone	; Affichage du premier triangle.

  move.l	#new_coords+(16*1),a1
  moveq.l	#nb_coord,d0	; Affichage du second triangle.
  jsr	polygone

  move.l	#new_coords+(16*2),a1
  moveq.l	#nb_coord,d0	; Affichage du troisieme triangle.
  jsr	polygone

  move.l	#new_coords+(16*3),a1
  moveq.l	#nb_coord,d0	; Affichage du quatrieme triangle.
  jsr	polygone

  move.l	#new_coords+(16*4),a1
  moveq.l	#nb_coord,d0	; Affichage du cinquieme triangle.
  jsr	polygone
	rts

polygone:
 include "POLYGONE.ASM"

***************************************************
* Génération du bloc d'effacement 1 plan de la 3D *
***************************************************
NB_LIGNE_GENERE	equ	169
NB_BLOC_SUPP	equ	10
PLAN_CLS	equ	0

efface_poly:
	move.l	Zorro_scr1,a0
	lea 160*57(a0),a0
	moveq	#0,d0
	jsr Code_gen
	RTS 
	
* Clear last plane of screen - reasonably quickly...
Genere_code:
	lea Code_gen,a0
	move.w	#NB_LIGNE_GENERE,d7
	moveq	#0,d4
Genere_pour_toutes_les_lignes:	
	moveq	#NB_BLOC_SUPP,d6
	move.w	d4,d5
	add.w	#PLAN_CLS,d5 * position du cadre
Genere_une_ligne:
	move.w	#$3140,(a0)+		 * Genere un move.w  d0,$xx(a0)
	move.w	d5,(a0)+				 * et voila l'offset $xx
	addq.w	#8,d5            * pixel suivant
	dbra	d6,Genere_une_ligne
	add.w	#160,d4            * ligne suivante
	dbra	d7,Genere_pour_toutes_les_lignes
	move.w	#$4e75,(a0)			 * Et un RTS !!
	rts

************************************************
*            Scrolling 12*12 1 plan            *
*                 from Atomus                  *
************************************************
Init_ScrollH:
      BSR       PRETEXT 
      BSR       PRESHIFT 
	RTS

ScrollH:
      MOVEA.L   PAS(PC),A0
      LEA       BIGBUF(PC),A1
      ADDA.W    LIGNE(PC),A1
      MOVEA.L   Zorro_scr1,A2
      LEA       160*200(A2),A2
      LEA       (160*38)+6(A2),A2
      MOVEQ     #20-1,D2 
      MOVE.W    (A0)+,D0
      LEA       16(A1,D0.W),A3
L00CF:MOVE.W    (A0)+,D0
      LEA       0(A1,D0.W),A5 
      MOVE.W    (A3)+,D1
      OR.W      (A5)+,D1
      MOVE.W    D1,160*0(A2) 
      MOVE.W    (A3)+,D1
      OR.W      (A5)+,D1
      MOVE.W    D1,160*1(A2)
      MOVE.W    (A3)+,D1
      OR.W      (A5)+,D1
      MOVE.W    D1,160*2(A2)
      MOVE.W    (A3)+,D1
      OR.W      (A5)+,D1
      MOVE.W    D1,160*3(A2)
      MOVE.W    (A3)+,D1
      OR.W      (A5)+,D1
      MOVE.W    D1,160*4(A2)
      MOVE.W    (A3)+,D1
      OR.W      (A5)+,D1
      MOVE.W    D1,160*5(A2)
      MOVE.W    (A3)+,D1
      OR.W      (A5)+,D1
      MOVE.W    D1,160*6(A2)
      MOVE.W    (A3)+,D1
      OR.W      (A5)+,D1
      MOVE.W    D1,160*7(A2) 
      MOVEA.L   A5,A3 
      ADDQ.W    #8,A2 
      DBF       D2,L00CF
      SUBI.W    #160*30+8*12,LIGNE
      BPL.S     .end 
      ADDI.W    #160*163+8*4,LIGNE
      ADDQ.L    #2,PAS
      CMPI.L    #ENDLINE,PAS
      BLT.S     .end 
      MOVE.L    #BUFFER,PAS
.end:RTS 

PRETEXT:LEA       TEXTH(PC),A0
      LEA       BUFFER(PC),A1
      MOVE.W    #NB_CARAC_TO_BUFFER,D1
.loop:MOVEQ     #0,D0 
      MOVE.B    (A0)+,D0
      MOVE.B    ASCII(PC,D0.W),D0 
      MULU      #$20,D0 
      MOVE.W    D0,(A1)+
      DBF       D1,.loop
      RTS 

ASCII:DCB.W     16,0
      DC.B      $00,$1E,$1F,$00,$00,$00,$00,'-' 
      DC.B      ' !',$00,$00,$1C,$00,$1B,'"'
      DC.B      '#$%&',$27,'()*'
      DC.B      '+,',$00,$00,$00,$00,$00,$1D
      DC.B      $00,$01,$02,$03,$04,$05,$06,$07 
      DC.B      $08,$09,$0A,$0B,$0C,$0D,$0E,$0F 
      DC.B      $10,$11,$12,$13,$14,$15,$16,$17 
      DC.B      $18,$19,$1A,$00,$00,$00,$00,$00 
      
PRESHIFT:LEA       FONT(PC),A0
      LEA       BIGBUF(PC),A1
      MOVEQ     #$32,D0 
.loop:MOVE.W    (A0)+,(A1)+ 
      MOVE.W    (A0)+,(A1)+ 
      MOVE.W    (A0)+,(A1)+ 
      MOVE.W    (A0)+,(A1)+ 
      MOVE.W    (A0)+,(A1)+ 
      MOVE.W    (A0)+,(A1)+ 
      MOVE.W    (A0)+,(A1)+ 
      MOVE.W    (A0)+,(A1)+ 
      CLR.W     (A1)+ 
      CLR.W     (A1)+ 
      CLR.W     (A1)+ 
      CLR.W     (A1)+ 
      CLR.W     (A1)+ 
      CLR.W     (A1)+ 
      CLR.W     (A1)+ 
      CLR.W     (A1)+ 
      DBF       D0,.loop
      MOVE.W    #$2FC,D0
.gener:MOVE.W    (A0),D1 
	rept 7
      SWAP      D1
      MOVE.W    16(A0),D1 
      LSR.L     #1,D1 
      MOVE.W    D1,16(A1) 
      SWAP      D1
      MOVE.W    D1,(A1)+
      ADDQ.W    #2,A0 
      MOVE.W    (A0),D1 
	endr
      SWAP      D1
      MOVE.W    16(A0),D1 
      LSR.L     #1,D1 
      MOVE.W    D1,16(A1) 
      SWAP      D1
      MOVE.W    D1,(A1)+
      ADDQ.W    #2,A0 
      LEA       16(A0),A0 
      LEA       16(A1),A1 
      DBF       D0,.gener
      RTS 
      
******************************************************************
	SECTION	DATA
******************************************************************

Pal:	
	dc.w	$0100,$0EEE,$0666,$0DDD,$0555,$0CCC,$0444,$0BBB
	dc.w	$0333,$0222,$032A,$0A92,$0219,$0981,$0108,$0777

* Full data here :
* >
; -> Données scrolling 12*12
* VERY IMPORTANT !!!
* You need to assigne the two values NOMBRE_DE_LIGNE and NOMBRE_DE_CARACTERE_PAR_LIGNE
* to input the correct value in NB_CARAC_TO_BUFFER.
* Each line have 40 characters in default !
NOMBRE_DE_LIGNE equ 6	*	Number of line to display in the scrolltext
NOMBRE_DE_CARACTERE_PAR_LIGNE equ 40 * Number of character into the line of the scrolltext

PAS:
	DC.L	BUFFER
TEXTH:
		  DC.B      '                                        '
		  DC.B      '                    ABCDEFGHIJKLMOPQRSTU'
		  DC.B      'VWXYZ .,!?()/      ',$27,'0123456789          '

		  DC.B      '                    ABCDEFGHIJKLMOPQRSTU'
		  DC.B      'VWXYZ .,!?()/      ',$27,'0123456789          '
		  DC.B      '                                        '

      DCB.W     NOMBRE_DE_CARACTERE_PAR_LIGNE,$0

NB_CARAC_TO_BUFFER equ NOMBRE_DE_CARACTERE_PAR_LIGNE*NOMBRE_DE_LIGNE

BUFFER:
	DCB.W	NB_CARAC_TO_BUFFER,$0
ENDLINE:
	DCB.L	NOMBRE_DE_CARACTERE_PAR_LIGNE,$0
LIGNE:
	DC.W	0 
FONT:
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$7FFC,$F83E,$FFFE,$F83E
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$FFFC,$F83E,$FFFC,$F83E
	dc.w	$F83E,$FFFE,$FFFE,$FFFC
	dc.w	$7FFE,$F800,$F800,$F800
	dc.w	$F800,$FFFE,$FFFE,$7FFE
	dc.w	$FFFC,$F83E,$F83E,$F83E
	dc.w	$F83E,$FFFE,$FFFE,$FFFC
	dc.w	$7FFC,$F83E,$FFFE,$F800
	dc.w	$F83E,$FFFE,$FFFE,$7FFC
	dc.w	$FFFE,$F800,$FF80,$F800
	dc.w	$F800,$F800,$F800,$F800
	dc.w	$7FFE,$F800,$FBFE,$F83E
	dc.w	$F83E,$FFFE,$FFFE,$7FFE
	dc.w	$F83E,$F83E,$FFFE,$F83E
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$07E0,$07E0,$07E0,$07E0
	dc.w	$07E0,$07E0,$07E0,$03E0
	dc.w	$003E,$003E,$003E,$003E
	dc.w	$F83E,$FFFE,$FFFE,$7FFC
	dc.w	$F83E,$F83E,$FFFC,$F83E
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$F800,$F800,$F800,$F800
	dc.w	$F83E,$FFFE,$FFFE,$7FFC
	dc.w	$7FFC,$FBBE,$FBBE,$FBBE
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$7FFC,$F83E,$F83E,$F83E
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$7FFC,$F83E,$F83E,$F83E
	dc.w	$F83E,$FFFE,$FFFE,$7FFC
	dc.w	$FFFC,$F83E,$FFFC,$F800
	dc.w	$F800,$F800,$F800,$F800
	dc.w	$7FFC,$F83E,$F83E,$FBBE
	dc.w	$FBFE,$FFFE,$FFFE,$7FFC
	dc.w	$FFFC,$F83E,$FFFC,$F83E
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$7FFE,$F800,$7FFC,$003E
	dc.w	$003E,$FFFE,$FFFE,$FFFC
	dc.w	$FFFC,$003E,$003E,$003E
	dc.w	$003E,$003E,$003E,$003E
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$F83E,$FFFE,$FFFE,$7FFC
	dc.w	$F83E,$F83E,$F83E,$FC7E
	dc.w	$FEFE,$7FFC,$3FF8,$1FF0
	dc.w	$F83E,$F83E,$FBBE,$FBBE
	dc.w	$FBBE,$FFFE,$FFFE,$7FFC
	dc.w	$F83E,$F83E,$7FFC,$F83E
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$F83E,$F83E,$7FFE,$003E
	dc.w	$F83E,$FFFE,$FFFE,$7FFC
	dc.w	$FFFE,$007E,$7FFC,$F800
	dc.w	$F800,$FFFE,$FFFE,$FFFE
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$F800,$F800,$F800
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$F800,$F800,$F800,$F000
	dc.w	$FFFC,$007E,$7FFC,$F800
	dc.w	$0000,$F800,$F800,$F800
	dc.w	$F800,$F800,$F800,$F800
	dc.w	$0000,$F800,$F800,$F800
	dc.w	$3EF8,$3EF8,$3EF8,$3CF0
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$00FE,$01F0,$01F0,$01F0
	dc.w	$01F0,$01FE,$01FE,$00FE
	dc.w	$FE00,$1F00,$1F00,$1F00
	dc.w	$1F00,$FF00,$FF00,$FE00
	dc.w	$003E,$00FE,$03F8,$0FE0
	dc.w	$3F80,$FE00,$F800,$E000
	dc.w	$7FFC,$F83E,$F83E,$F83E
	dc.w	$F83E,$FFFE,$FFFE,$7FFC
	dc.w	$1FE0,$01F0,$01F0,$01F0
	dc.w	$01F0,$01F0,$01F0,$01F0
	dc.w	$FFFC,$003E,$7FFC,$F800
	dc.w	$F800,$FFFE,$FFFE,$FFFE
	dc.w	$FFFC,$007E,$03FC,$F87E
	dc.w	$F87E,$FFFE,$FFFE,$7FFC
	dc.w	$F83E,$F83E,$7FFE,$003E
	dc.w	$003E,$003E,$003E,$003E
	dc.w	$FFFE,$F800,$FFFC,$003E
	dc.w	$F83E,$FFFE,$FFFE,$7FFC
	dc.w	$7FFE,$F800,$FFFC,$F83E
	dc.w	$F83E,$FFFE,$FFFE,$7FFC
	dc.w	$FFFC,$003E,$003E,$003E
	dc.w	$003E,$003E,$003E,$003E
	dc.w	$7FFC,$F83E,$7FFC,$F83E
	dc.w	$F83E,$FFFE,$FFFE,$7FFC
	dc.w	$7FFC,$F83E,$7FFE,$003E
	dc.w	$F83E,$FFFE,$FFFE,$7FFC
	dc.w	$1F00,$1F00,$1F00,$1E00
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$3E00,$3E00,$0000
	dc.w	$3E00,$3E00,$3E00,$0000
	dc.w	$0000,$0000,$7FFC,$7FFC
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$3E00,$3E00,$0000
	dc.w	$3E00,$3E00,$0600,$3C00
	dc.w	$0000,$0000,$3FE0,$0000
	dc.w	$3FE0,$3FE0,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
BIGBUF:
	DCB.W	13056,$0 
	EVEN
; <- 

;-> Données texte 8*8
font	
	incbin 	"FONT88F.DAT"
	even
cmpt_vbl   dc.w 2
clsL	     dc.w	0
totalL	   dc.w	0
posHscr1	 dc.l	0
posBscr1	 dc.l	0
posHscr2	 dc.l	0
posBscr2	 dc.l	0
tempoL	   dc.w	0
ptexte:
* Character ASCII only !
*-> !'#$%&"()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyzCUR<-*

	   dc.b "Welcome to the new intro  ",$ff	* Page 1
	   dc.b "of the best great website:",$ff
	   dc.b "                          ",$ff
	   dc.b "     * ATARI-LEGEND *     ",$ff
	   dc.b "                          ",$ff
	   dc.b "This intro was coding by  ",$ff
	   dc.b "the Atari ST crew NOEXTRA.",$ff
	   dc.b "Code...............ZORRO 2",$ff
	   dc.b "Gfx...............MISTER.A",$ff
	   dc.b "Music................RHINO",$ff
	   dc.b "                          ",$ff
	   dc.b "NOEXTRA (C)PRODUCTION 2009",$fe

	   dc.b " !",$22,"#$%&",$27,"()*+,-./0123456789",$ff	*	Page 2
	   dc.b ":;<=>?@ABCDEFGHIJKLMNOPQRS",$ff
	   dc.b "TUVWXYZ[\]^_`abcdefghijklm",$ff
	   dc.b "nopqrstuvwxyz             ",$ff
	   dc.b "ECRAN1 FE                 ",$ff
	   dc.b "UN TEXTE POUR ATARI LEGEND",$ff
	   dc.b "UN TEXTE POUR ATARI LEGEND",$ff
	   dc.b "UN TEXTE POUR ATARI LEGEND",$ff
	   dc.b "UN TEXTE POUR ATARI LEGEND",$ff
	   dc.b "UN TEXTE POUR ATARI LEGEND",$ff
	   dc.b "UN TEXTE POUR ATARI LEGEND",$ff
	   dc.b "UN TEXTE POUR ATARI LEGEND",$fe

	   dc.b " !",$22,"#$%&",$27,"()*+,-./0123456789",$ff	*	Page 3
	   dc.b ":;<=>?@ABCDEFGHIJKLMNOPQRS",$ff
	   dc.b "TUVWXYZ[\]^_`abcdefghijklm",$ff
	   dc.b "nopqrstuvwxyz             ",$ff
	   dc.b "ECRAN2 FD                 ",$ff
	   dc.b "UN TEXTE POUR ATARI LEGEND",$ff
	   dc.b "UN TEXTE POUR ATARI LEGEND",$ff
	   dc.b "UN TEXTE POUR ATARI LEGEND",$ff
	   dc.b "UN TEXTE POUR ATARI LEGEND",$ff
	   dc.b "UN TEXTE POUR ATARI LEGEND",$ff
	   dc.b "UN TEXTE POUR ATARI LEGEND",$ff
	   dc.b "UN TEXTE POUR ATARI LEGEND",$ff

		 dc.b $fd	* -> End of the entire text

		 even
; <-

; -> Données 3D
sin_cos:
  incbin	"SIN_COS.DAT"
	even
alpha:
	dc.w	0
coords:
  dc.w	0,0    ; face 1
  dc.w	-25,35
  dc.w	0,84
  dc.w	25,35

	dc.w	0,0    ; face 2
	dc.w	-40,-15
	dc.w	-80,25
	dc.w	-25,35
	
	dc.w	0,0    ; face 3
	dc.w	0,-40
	dc.w	-50,-65
	dc.w	-40,-15

	dc.w	0,0    ; face 4
	dc.w	40,-15
	dc.w	50,-65
	dc.w	0,-40

	dc.w	0,0    ; face 5
	dc.w	25,35
	dc.w	80,25
	dc.w	40,-15
* <-

Logo_Al:
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$17FF,$0FFF,$0BFF,$13FF,$E3FF,$E3FF,$E3FF,$E3FF
		dc.w	$FF81,$FF80,$FF80,$FF81,$7FFE,$FFFE,$BFFE,$3FFE
		dc.w	$3FFF,$3FFF,$3FFE,$3FFE,$60FF,$80FF,$80FF,$60FF
		dc.w	$0000,$0000,$0000,$0000,$0000,$4000,$4000,$4000
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$0005,$0003,$0002,$0004
		dc.w	$FFF8,$FFF8,$FFF8,$FFF8,$17FF,$0FFF,$0BFF,$13FF
		dc.w	$E05F,$E03F,$E02F,$E04F,$FF8F,$FF8F,$FF8F,$FF8F
		dc.w	$FFD0,$FFE0,$FFA0,$FF90,$3FFF,$3FFF,$3FFE,$3FFE
		dc.w	$4280,$8000,$8280,$4280,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3FFF,$1FFF,$0FFF,$2FFF,$E00F,$E00F,$E00F,$E00F
		dc.w	$E003,$E001,$E000,$E002,$FFFE,$FFFE,$FFFE,$FFFE
		dc.w	$3FFF,$3FFF,$3FFF,$3FFF,$F000,$C000,$8000,$B000
		dc.w	$0000,$0000,$0000,$0000,$0000,$8000,$C000,$C000
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$000F,$0007,$0003,$000B
		dc.w	$FFF8,$FFF8,$FFF8,$FFF8,$3FFF,$1FFF,$0FFF,$2FFF
		dc.w	$E0FF,$E07F,$E03F,$E0BF,$FF8F,$FF8F,$FF8F,$FF8F
		dc.w	$FFF8,$FFF0,$FFE0,$FFE8,$3FFF,$3FFF,$3FFF,$3FFF
		dc.w	$E380,$C000,$8380,$A380,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$7E8F,$3F8F,$1E8F,$5E0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E007,$E003,$E001,$E005,$E8FE,$F8FE,$E8FE,$E0FE
		dc.w	$3F8B,$3F8F,$3F8B,$3F83,$F0FF,$E0FF,$C0FF,$D0FF
		dc.w	$0000,$0000,$0000,$0000,$8000,$2000,$E000,$E000
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$001F,$000F,$0007,$0017
		dc.w	$A000,$E000,$A000,$8000,$7E80,$3F80,$1E80,$5E00
		dc.w	$01FA,$00FE,$007A,$0178,$000F,$000F,$000F,$000F
		dc.w	$E2FC,$E3F8,$E2F0,$E0F4,$3F8B,$3F8F,$3F8B,$3F83
		dc.w	$F280,$E000,$C280,$D280,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$7F8F,$7E0F,$7F0F,$3E8F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E007,$E007,$E007,$E003,$F8FE,$E0FE,$F0FE,$E8FE
		dc.w	$3F8F,$3F83,$3F87,$3F8B,$F8FF,$F0FF,$F0FF,$E8FF
		dc.w	$0000,$0000,$0000,$0000,$2000,$0000,$E000,$E000
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$001F,$001F,$001F,$000F
		dc.w	$C000,$8000,$C000,$8000,$7F00,$7E00,$7F00,$3E00
		dc.w	$01FC,$01F8,$01FC,$00F8,$000F,$000F,$000F,$000F
		dc.w	$E3FC,$E0FC,$E1FC,$E2F8,$3F8F,$3F83,$3F87,$3F8B
		dc.w	$F280,$F000,$F280,$E280,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$BE0F,$7E0F,$3E0F,$BF0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00B,$E007,$E003,$E00B,$E0FE,$E0FE,$E0FE,$F0FE
		dc.w	$3F83,$3F83,$3F83,$3F87,$E8FF,$F0FF,$E0FF,$E8FF
		dc.w	$0000,$0001,$0001,$0001,$0000,$0000,$E000,$E000
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$002F,$001F,$000F,$002F
		dc.w	$8000,$8000,$8000,$C000,$BE00,$7E00,$3E00,$BF00
		dc.w	$02F8,$01F8,$00F8,$02FC,$000F,$000F,$000F,$000F
		dc.w	$E0FA,$E0FC,$E0F8,$E1FA,$3F83,$3F83,$3F83,$3F87
		dc.w	$E880,$F000,$E080,$E880,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FF0F,$FE0F,$FE0F,$7F0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E007,$F0FE,$E0FE,$E0FE,$F0FE
		dc.w	$3F87,$3F83,$3F83,$3F87,$F8FF,$F8FF,$F8FF,$F0FF
		dc.w	$0001,$0000,$0001,$0001,$0000,$1000,$F000,$F000
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$003F,$003F,$003F,$001F
		dc.w	$8000,$8000,$8000,$8000,$FE00,$FE00,$FE00,$7E00
		dc.w	$03F8,$03F8,$03F8,$01F8,$000F,$000F,$000F,$000F
		dc.w	$E1FE,$E0FE,$E0FE,$E1FC,$3F87,$3F83,$3F83,$3F87
		dc.w	$FB00,$F800,$FB00,$F300,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$7E0F,$7E0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E007,$E007,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F83,$3F83,$3F83,$3F83,$F8FF,$F8FF,$F0FF,$F0FF
		dc.w	$0000,$0002,$0003,$0003,$1000,$0000,$F000,$F000
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$003F,$003F,$001F,$001F
		dc.w	$8000,$8000,$8000,$8000,$FE00,$FE00,$7E00,$7E00
		dc.w	$03F8,$03F8,$01F8,$01F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FC,$E0FC,$3F83,$3F83,$3F83,$3F83
		dc.w	$F900,$F800,$F100,$F100,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$7E0F,$FE0F,$7E0F,$7E0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E007,$E00F,$E007,$E007,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F83,$3F83,$3F83,$3F83,$F0FF,$F8FF,$F0FF,$F0FF
		dc.w	$0000,$0002,$0003,$0003,$0000,$0000,$F000,$F000
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$001F,$003F,$001F,$001F
		dc.w	$8000,$8000,$8000,$8000,$7E00,$FE00,$7E00,$7E00
		dc.w	$01F8,$03F8,$01F8,$01F8,$000F,$000F,$000F,$000F
		dc.w	$E0FC,$E0FE,$E0FC,$E0FC,$3F83,$3F83,$3F83,$3F83
		dc.w	$F100,$F800,$F100,$F100,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F83,$3F83,$3F83,$3F83,$F8FF,$F8FF,$F8FF,$F8FF
		dc.w	$0000,$0000,$0003,$0003,$0000,$0800,$F800,$F800
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$003F,$003F,$003F,$003F
		dc.w	$8000,$8000,$8000,$8000,$FE00,$FE00,$FE00,$FE00
		dc.w	$03F8,$03F8,$03F8,$03F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$FB80,$F800,$FB80,$FB80,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F83,$3F83,$3F83,$3F83,$F8FF,$F8FF,$F8FF,$F8FF
		dc.w	$0000,$0004,$0007,$0007,$0800,$0000,$F800,$F800
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$003F,$003F,$003F,$003F
		dc.w	$8000,$8000,$8000,$8000,$FE00,$FE00,$FE00,$FE00
		dc.w	$03F8,$03F8,$03F8,$03F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$F800,$F800,$F800,$F800,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F87,$3F83,$3F83,$3F87,$F8FF,$F8FF,$F8FF,$F8FF
		dc.w	$0004,$0000,$0007,$0007,$0000,$0400,$FC00,$FC00
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$003F,$003F,$003F,$003F
		dc.w	$8000,$8000,$8000,$8000,$FE00,$FE00,$FE00,$FE00
		dc.w	$03F8,$03F8,$03F8,$03F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$F980,$F800,$F980,$F980,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F83,$3F83,$3F83,$3F87,$F8FF,$F8FF,$F8FF,$F0FF
		dc.w	$0000,$0000,$0007,$0007,$0000,$0400,$FC00,$FC00
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$003F,$003F,$003F,$003F
		dc.w	$8000,$8000,$8000,$8000,$FE00,$FE00,$FE00,$FE00
		dc.w	$03F8,$03F8,$03F8,$03F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$FA00,$F800,$FA00,$FA00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F97,$3F87,$3F83,$3F9B,$F8FF,$F0FF,$E0FF,$E8FF
		dc.w	$0000,$0008,$000F,$000F,$0000,$0000,$FC00,$FC00
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$003F,$003F,$003F,$003F
		dc.w	$8000,$8000,$8000,$8000,$FE00,$FE00,$FE00,$FE00
		dc.w	$03F8,$03F8,$03F8,$03F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$FB80,$F800,$FB80,$FB80,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$FFFE,$FFFE,$FFFE,$FFFE
		dc.w	$3FFF,$3FFF,$3FFF,$3FFF,$F0FF,$E0FF,$A0FF,$90FF
		dc.w	$0008,$0000,$000F,$000F,$0000,$0200,$FE00,$FE00
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$003F,$003F,$003F,$003F
		dc.w	$8000,$8000,$8000,$8000,$FE00,$FE00,$FE00,$FE00
		dc.w	$03F8,$03F8,$03F8,$03F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$F880,$F800,$F880,$F880,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$FFFE,$FFFE,$FFFE,$FFFE
		dc.w	$3FFF,$3FFF,$3FFF,$3FFF,$F8FF,$F0FF,$E0FF,$E8FF
		dc.w	$0000,$0000,$000F,$000F,$0200,$0000,$FE00,$FE00
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$003F,$003F,$003F,$003F
		dc.w	$FC00,$FC00,$FC00,$FC00,$FEFF,$FEFF,$FEFF,$FEFF
		dc.w	$E3FF,$E3FF,$E3FF,$E3FF,$C00F,$C00F,$C00F,$C00F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$FB00,$F800,$FB00,$FB00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F97,$3F87,$3F83,$3F9B,$F8FF,$F8FF,$F8FF,$F0FF
		dc.w	$0000,$0010,$001F,$001F,$0000,$0100,$FF00,$FF00
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$003F,$003F,$003F,$003F
		dc.w	$FC00,$FC00,$FC00,$FC00,$FEFF,$FEFF,$FEFF,$FEFF
		dc.w	$E3FF,$E3FF,$E3FF,$E3FF,$C00F,$C00F,$C00F,$C00F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$F800,$F800,$F800,$F800,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F83,$3F83,$3F83,$3F87,$F8D0,$F8F0,$F0CF,$F0BF
		dc.w	$0000,$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF
		dc.w	$0160,$01E0,$FE60,$FFA0,$003F,$003F,$003F,$003F
		dc.w	$8000,$8000,$8000,$8000,$FE0F,$FE0F,$FE0F,$FE0F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$FB80,$F800,$FB80,$FB80,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F87,$3F83,$3F83,$3F87,$F8C8,$F8D8,$F8E7,$F8DF
		dc.w	$0000,$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF
		dc.w	$0260,$0360,$FCE0,$FF60,$003F,$003F,$003F,$003F
		dc.w	$8000,$8000,$8000,$8000,$FE0F,$FE0F,$FE0F,$FE0F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$F900,$F800,$F900,$F900,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F83,$3F83,$3F83,$3F83,$F8F4,$F8E4,$F8E3,$F8EF
		dc.w	$0000,$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF
		dc.w	$05E0,$04E0,$F8E0,$FEE0,$003F,$003F,$003F,$003F
		dc.w	$8000,$8000,$8000,$8000,$FE0F,$FE0F,$FE0F,$FE0F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$F900,$F800,$F900,$F900,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F83,$3F83,$3F83,$3F83,$F8F8,$F8FA,$F8FD,$F8FB
		dc.w	$0000,$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF
		dc.w	$03E0,$0BE0,$F7E0,$FBE0,$003F,$003F,$003F,$003F
		dc.w	$8000,$8000,$8000,$8000,$FE0F,$FE0F,$FE0F,$FE0F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$F900,$F800,$F900,$F900,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F83,$3F83,$3F83,$3F83,$F8FF,$F8FF,$F8FF,$F8FE
		dc.w	$0000,$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF
		dc.w	$2FE0,$1FE0,$FFE0,$FFE0,$003F,$003F,$003F,$003F
		dc.w	$8000,$8000,$8000,$8000,$FE0F,$FE0F,$FE0F,$FE0F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$F800,$F800,$F800,$F800,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F83,$3F83,$3F83,$3F83,$F8FF,$F8FF,$F8FF,$F8FF
		dc.w	$4000,$8000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF
		dc.w	$4FE0,$2FE0,$EFE0,$EFE0,$003F,$003F,$003F,$003F
		dc.w	$8000,$8000,$8000,$8000,$FE0F,$FE0F,$FE0F,$FE0F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$F980,$F800,$F980,$F980,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F83,$3F83,$3F83,$3F83,$F8FF,$F8FF,$F8FF,$F8FF
		dc.w	$0000,$2000,$3FFF,$3FFF,$0001,$0000,$FFFF,$FFFF
		dc.w	$0FE0,$8FE0,$8FE0,$8FE0,$003F,$003F,$003F,$003F
		dc.w	$8000,$8000,$8000,$8000,$FE0F,$FE0F,$FE0F,$FE0F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$FA00,$F800,$FA00,$FA00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F83,$3F83,$3F83,$3F83,$F8FF,$F8FF,$F8FF,$F8FF
		dc.w	$0800,$1000,$1FFF,$1FFF,$0002,$0001,$FFFF,$FFFF
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$003F,$003F,$003F,$003F
		dc.w	$8000,$8000,$8000,$8000,$FE0F,$FE0F,$FE0F,$FE0F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$FB00,$F800,$FB00,$FB00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F83,$3F83,$3F83,$3F83,$F8FF,$F8FF,$F8FF,$F8FF
		dc.w	$0000,$0400,$07FF,$07FF,$0000,$0004,$FFFC,$FFFC
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$003F,$003F,$003F,$003F
		dc.w	$8000,$8000,$8000,$8000,$FE0F,$FE0F,$FE0F,$FE0F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$FA00,$F800,$FA00,$FA00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F83,$3F83,$3F83,$3F83,$F8FF,$F8FF,$F8FF,$F8FF
		dc.w	$0100,$0200,$03FF,$03FF,$0010,$0008,$FFF8,$FFF8
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$003F,$003F,$003F,$003F
		dc.w	$8000,$8000,$8000,$8000,$FE0F,$FE0F,$FE0F,$FE0F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$F980,$F800,$F980,$F980,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F83,$3F83,$3F83,$3F83,$F8FF,$F8FF,$F8FF,$F8FF
		dc.w	$0000,$0100,$01FF,$01FF,$0000,$0000,$FFE0,$FFE0
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$003F,$003F,$003F,$003F
		dc.w	$8000,$8000,$8000,$8000,$FE0F,$FE0F,$FE0F,$FE0F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$F800,$F800,$F800,$F800,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F83,$3F83,$3F83,$3F83,$F8FF,$F8FF,$F8FF,$F8FF
		dc.w	$0000,$0100,$01FF,$01FF,$0000,$0010,$FFF0,$FFF0
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$003F,$003F,$003F,$003F
		dc.w	$8000,$8000,$8000,$8000,$FE0F,$FE0F,$FE0F,$FE0F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$FB00,$F800,$FB00,$FB00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F83,$3F83,$3F83,$3F83,$F8FF,$F8FF,$F8FF,$F8FF
		dc.w	$0000,$0000,$01FF,$01FF,$0000,$0000,$FFF0,$FFF0
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$003F,$003F,$003F,$003F
		dc.w	$8000,$8000,$8000,$8000,$FE0F,$FE0F,$FE0F,$FE0F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$FA80,$F800,$FA80,$FA80,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F83,$3F83,$3F83,$3F83,$F8FF,$F8FF,$F8FF,$F8FF
		dc.w	$0000,$0200,$03FF,$03FF,$0000,$0008,$FFF8,$FFF8
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$003F,$003F,$003F,$003F
		dc.w	$8000,$8000,$8000,$8000,$FE0F,$FE0F,$FE0F,$FE0F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$FB00,$F800,$FB00,$FB00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F83,$3F83,$3F83,$3F83,$F8FF,$F8FF,$F8FF,$F8FF
		dc.w	$0200,$0000,$03FF,$03FF,$0008,$0000,$FFF8,$FFF8
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$003F,$003F,$003F,$003F
		dc.w	$8000,$8000,$8000,$8000,$FE0F,$FE0F,$FE0F,$FE0F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$FA80,$F800,$FA80,$FA80,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F83,$3F83,$3F83,$3F83,$F8FF,$F8FF,$F8FF,$F8FF
		dc.w	$0000,$0000,$03FF,$03FF,$0000,$0000,$FFF8,$FFF8
		dc.w	$0FE0,$0FE0,$0FE0,$0FE0,$003F,$003F,$003F,$003F
		dc.w	$8000,$8000,$8000,$8000,$FE0F,$FE0F,$FE0F,$FE0F
		dc.w	$E3F8,$E3F8,$E3F8,$E3F8,$000F,$000F,$000F,$000F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3F83,$3F83,$3F83,$3F83
		dc.w	$FA80,$F800,$FA80,$FA80,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$BE0B,$BE0B,$BE0B,$E00F,$E00B,$E00B,$E00B
		dc.w	$E00F,$E00B,$E00B,$E00B,$E0FE,$E0BE,$E0BE,$E0BE
		dc.w	$3F83,$2F82,$2F82,$2F82,$F8FF,$F8BF,$F8BF,$F8BF
		dc.w	$0000,$0400,$07FF,$07FF,$A000,$4004,$FFFC,$FFFC
		dc.w	$0FE0,$0BE0,$0BE0,$0BE0,$003F,$002F,$002F,$002F
		dc.w	$8000,$8000,$8000,$8000,$FE0F,$BE0F,$BE0F,$BE0F
		dc.w	$E3F8,$E2F8,$E2F8,$E2F8,$000F,$000B,$000B,$000B
		dc.w	$E0FE,$E0BE,$E0BE,$E0BE,$3F83,$2F83,$2F83,$2F83
		dc.w	$F880,$F800,$F880,$F880,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$BE0B,$BE0B,$BE0B,$E00F,$E00B,$E00B,$E00B
		dc.w	$E00F,$E00B,$E00B,$E00B,$E0FE,$E0BE,$E0BE,$E0BE
		dc.w	$3F83,$2F82,$2F82,$2F82,$F8FF,$F8BF,$F8BF,$F8BF
		dc.w	$0401,$0000,$07FF,$07FF,$1004,$0000,$1FFC,$1FFC
		dc.w	$0FE0,$0BE0,$0BE0,$0BE0,$003F,$002F,$002F,$002F
		dc.w	$8000,$8000,$8000,$8000,$FE0F,$BE0F,$BE0F,$BE0F
		dc.w	$E3F8,$E2F8,$E2F8,$E2F8,$000F,$000B,$000B,$000B
		dc.w	$E0FE,$E0BE,$E0BE,$E0BE,$3F83,$2F83,$2F83,$2F83
		dc.w	$F800,$F800,$F800,$F800,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$BE0B,$DE0D,$9E09,$9E09,$E00B,$E00D,$E009,$E009
		dc.w	$E00B,$E00D,$E009,$E009,$E0BE,$E0DE,$E09E,$E09E
		dc.w	$2F82,$3783,$2782,$2782,$F8BF,$78DF,$789F,$789F
		dc.w	$0004,$0802,$0FFE,$0FFE,$0400,$0802,$0FFE,$0FFE
		dc.w	$0BE0,$0DE0,$09E0,$09E0,$002F,$0037,$0027,$0027
		dc.w	$8000,$8000,$8000,$8000,$BE0F,$DE0F,$9E0F,$9E0F
		dc.w	$E2F8,$E378,$E278,$E278,$000B,$000D,$0009,$0009
		dc.w	$E0BE,$E0DE,$E09E,$E09E,$2F83,$3783,$2783,$2783
		dc.w	$F900,$F800,$F900,$F900,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$BE0B,$DE0D,$9E09,$9E09,$E00B,$E00D,$E009,$E009
		dc.w	$E00B,$E00D,$E009,$E009,$E0BE,$E0DE,$E09E,$E09E
		dc.w	$2F82,$3783,$2782,$2782,$F8BF,$78DF,$789F,$789F
		dc.w	$0800,$0008,$0FF8,$0FF8,$0002,$0200,$03FE,$03FE
		dc.w	$0BE0,$0DE0,$09E0,$09E0,$002F,$0037,$0027,$0027
		dc.w	$8000,$8000,$8000,$8000,$BE0F,$DE0F,$9E0F,$9E0F
		dc.w	$E2F8,$E378,$E278,$E278,$000B,$000D,$0009,$0009
		dc.w	$E0BE,$E0DE,$E09E,$E09E,$2F83,$3783,$2783,$2783
		dc.w	$F800,$F800,$F800,$F800,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$9E09,$BE0B,$DE0D,$9E09,$E009,$E00B,$E00D,$E009
		dc.w	$E009,$E00B,$E00D,$E009,$E09E,$E0BE,$E0DE,$E09E
		dc.w	$2782,$2F82,$3783,$2782,$789F,$F8BF,$78DF,$789F
		dc.w	$0020,$0000,$0FE0,$0FE0,$0080,$0000,$00FE,$00FE
		dc.w	$09E0,$0BE0,$0DE0,$09E0,$0027,$002F,$0037,$0027
		dc.w	$8000,$8000,$8000,$8000,$9E0F,$BE0F,$DE0F,$9E0F
		dc.w	$E278,$E2F8,$E378,$E278,$0009,$000B,$000D,$0009
		dc.w	$E09E,$E0BE,$E0DE,$E09E,$2783,$2F83,$3783,$2783
		dc.w	$F900,$F800,$F900,$F900,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$DE0D,$AE0A,$CE0C,$8E08,$E00D,$E00A,$E00C,$E008
		dc.w	$E00D,$E00A,$E00C,$E008,$E0DE,$E0AE,$E0CE,$E08E
		dc.w	$3783,$2B82,$3383,$2382,$78DF,$B8AF,$38CF,$388F
		dc.w	$0000,$1040,$1FC0,$1FC0,$0000,$0041,$007F,$007F
		dc.w	$0DE0,$0AE0,$0CE0,$08E0,$0037,$002B,$0033,$0023
		dc.w	$8000,$8000,$8000,$8000,$DE0F,$AE0F,$CE0F,$8E0F
		dc.w	$E378,$E2B8,$E338,$E238,$000D,$000A,$000C,$0008
		dc.w	$E0DE,$E0AE,$E0CE,$E08E,$3787,$2B83,$3383,$2387
		dc.w	$FA80,$F800,$FA80,$FA80,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$CE0C,$D60D,$E60E,$8608,$E00C,$600D,$600E,$6008
		dc.w	$E00C,$600D,$600E,$6008,$E0CE,$60D6,$60E6,$6086
		dc.w	$3383,$3583,$3983,$2182,$38CF,$58D7,$98E7,$1887
		dc.w	$1100,$0000,$1F00,$1F00,$0011,$0000,$001F,$001F
		dc.w	$0CE0,$0D60,$0E60,$0860,$0033,$0035,$0039,$0021
		dc.w	$8000,$8000,$8000,$8000,$CE0F,$D60F,$E60F,$860F
		dc.w	$E338,$E358,$E398,$E218,$000C,$000D,$000E,$0008
		dc.w	$E0CE,$60D6,$60E6,$6086,$3383,$3583,$3983,$2187
		dc.w	$FB80,$F800,$FB80,$FB80,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$8608,$AA0A,$B20B,$C20C,$6008,$A00A,$200B,$200C
		dc.w	$6008,$A00A,$200B,$200C,$6086,$A0AA,$20B2,$20C2
		dc.w	$2182,$2A82,$2C82,$3083,$1887,$A8AB,$C8B3,$08C3
		dc.w	$0400,$0200,$1E00,$1E00,$0004,$0008,$000F,$000F
		dc.w	$0860,$0AA0,$0B20,$0C20,$0021,$002A,$002C,$0030
		dc.w	$8000,$8000,$8000,$8000,$860F,$AA0F,$B20F,$C20F
		dc.w	$E218,$E2A8,$E2C8,$E308,$0008,$000A,$000B,$000C
		dc.w	$6086,$A0AA,$20B2,$20C2,$2197,$2A87,$2C83,$309B
		dc.w	$FA80,$F800,$FA80,$FA80,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$DE0D,$9409,$9809,$E00E,$E00D,$4009,$8009,$000E
		dc.w	$E00D,$4009,$8009,$000E,$E0DE,$4094,$8098,$00E0
		dc.w	$3783,$2502,$2602,$3803,$78DF,$5094,$6098,$80E0
		dc.w	$0800,$2000,$3800,$3800,$0000,$0006,$0007,$0007
		dc.w	$0DFF,$895F,$899F,$8E1F,$FE37,$FE25,$FE26,$FE38
		dc.w	$FFF8,$7FF8,$7FF8,$7FF8,$DFFF,$95FF,$99FF,$E1FF
		dc.w	$E37F,$E257,$E267,$E387,$FF8D,$FF89,$FF89,$FF8E
		dc.w	$E0DE,$4094,$8098,$00E0,$37FF,$257F,$267F,$387F
		dc.w	$FA80,$F800,$FA80,$FA80,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FE0F,$FE0F,$FE0F,$FE0F,$E00F,$E00F,$E00F,$E00F
		dc.w	$E00F,$E00F,$E00F,$E00F,$E0FE,$E0FE,$E0FE,$E0FE
		dc.w	$3F83,$3F83,$3F83,$3F83,$F8FF,$F8FF,$F8FF,$F8FF
		dc.w	$3000,$0000,$3000,$3000,$0001,$0000,$0001,$0001
		dc.w	$8FFF,$0FFF,$8FFF,$8FFF,$FE3F,$FE3F,$FE3F,$FE3F
		dc.w	$FFF8,$FFF8,$FFF8,$FFF8,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$E3FF,$E3FF,$E3FF,$E3FF,$FF8F,$FF8F,$FF8F,$FF8F
		dc.w	$E0FE,$E0FE,$E0FE,$E0FE,$3FFF,$3FFF,$3FFF,$3FFF
		dc.w	$F880,$F800,$F880,$F880,$0000,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FFFE,$0000,$FFFE,$FFFE

Pal_NoeX:
	dc.w      $0100,$0503,$0036,$0677,$0525,$0fff,$0fff,$0fff

Logo_NoeX:
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$07FF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FC00,$03FF,$0000,$0000,$0000,$FFFF,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$07FF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FC00,$03FF,$0000,$0000,$0000,$FFFF,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$07FF,$0000,$0000,$F801,$FFFF,$0000,$0000
		dc.w	$DC01,$FC01,$03FE,$0000,$F800,$F800,$07FF,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00F9,$07FF,$0000,$0000,$DCFD,$FFFF,$0000,$0000
		dc.w	$DDFD,$FDFD,$0202,$0000,$DCF8,$DCF8,$2307,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01DD,$07FF,$0000,$0000,$DDC1,$FFFF,$0000,$0000
		dc.w	$DC71,$FC71,$038E,$0000,$DDDC,$DDDC,$2223,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01DD,$07FF,$0000,$0000,$DDC0,$FFFF,$0000,$0000
		dc.w	$F871,$FC71,$038E,$0000,$F9DC,$F9DC,$0623,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01DD,$07FF,$0000,$0000,$DDF1,$FFFF,$0000,$0000
		dc.w	$DC71,$FC71,$038E,$0000,$DDFC,$DDFC,$2203,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01DD,$07FF,$0000,$0000,$DDC1,$FFFF,$0000,$0000
		dc.w	$DC71,$FC71,$038E,$0000,$DDDC,$DDDC,$2223,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01DC,$07FF,$0000,$0000,$F9C1,$FFFF,$0000,$0000
		dc.w	$DC71,$FC71,$038E,$0000,$DDDC,$DDDC,$2223,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01DC,$07FF,$0000,$0000,$00FC,$FFFF,$0000,$0000
		dc.w	$0070,$FC70,$038F,$0000,$01DC,$01DC,$FE23,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$07FF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FC00,$03FF,$0000,$0000,$0000,$FFFF,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$07FF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FC00,$03FF,$0000,$0000,$0000,$FFFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFFF,$0000,$FFFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFFF,$0000,$FFFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFFF,$0000,$FFFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFFF,$0000,$FFFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFFF,$0000,$FFFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFFF,$0000,$FFFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFFF,$0000,$FFFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFFF,$0000,$FFFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFFF,$0000,$FFFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFFF,$0000,$FFFF,$0000
; <-

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
		
MUSIC: 		; Not compressed please !
	incbin	*.snd
	even

******************************************************************
	SECTION	BSS
******************************************************************

bss_start:

* Full data here :
* >
Code_gen:         ds.w	(2*NB_BLOC_SUPP)*NB_LIGNE_GENERE		* Place pour le code genere
									   									* pour l'effacement de l'elt 3d
								  ds.w	1							* Place pour le rts
rien            	ds.b	10000

ptr	       ds.l 1
vitesse	   ds.w 1
anim       ds.w 1
adr_obj    ds.l 1
new_coords:ds.w	5*4
aucasou:   ds.w	100
* <

Vsync:	ds.b	1
        ds.b	1
Save_stack:
        ds.l	1

Save_all:
	ds.b	8	* Mfp : fa03.w -> fa19.w
	ds.b	4	* Mfp : fa1b.w -> fa21.w
	ds.b	4	* Video : f8201.w -> f820d.w
Video:	ds.b	1	* Video : f8260.w
	ds.w	1	* coolness guys !

Save_rest:
	ds.l	1	* Autovector (HBL)
	ds.l	1	* Autovector (VBL)
	ds.l	1	* Timer D (USART timer)
	ds.l	1	* Timer C (200hz Clock)
	ds.l	1	* Keyboard/MIDI (ACIA) 
	ds.l	1	* Timer B (HBL)
	ds.l	1	* Timer A
	ds.l	1	* Output Bip Bop
Palette:ds.w	16	* Palette

Zorro_scr1:	ds.l	1

Zorro_screen1:	
	ds.b	256
start1:	
	ds.b	160*40
	ds.b	160*200
	IFEQ	BOTTOM_BORDER
	ds.b	160*50
	ENDC
Zorro_screen1_len:	equ	*-start1

Zorro_scr2:	ds.l	1

Zorro_screen2:	
	ds.b	256
start2:	
	ds.b	160*40
	ds.b	160*200
	IFEQ	BOTTOM_BORDER
	ds.b	160*50
	ENDC
Zorro_screen2_len:	equ	*-start2

bss_end:

******************************************************************
	END
******************************************************************
