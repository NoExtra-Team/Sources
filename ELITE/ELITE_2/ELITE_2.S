***************************************
* // ELITE_2.PRG                   // *
***************************************
* // Asm Intro Code Atari ST v0.40 // *
* // by Zorro 2/NoExtra (26/08/11) // *
* // http://www.noextra-team.com/  // *
* // Hall of fame of supreme ST    // *
* // Debugger : Maartau            // *
***************************************
* // Original code : Zorro2        // *
* // Gfx logo      : Mister.A      // *
* // Gfx font      : Mister.A      // *
* // Music         : Epic          // *
* // Release date  : 11/11/2010    // *
* // Update date   : 30/08/2011    // *
***************************************
  OPT c+ ; Case sensitivity on        *
  OPT d- ; Debug off                  *
  OPT o- ; All optimisations off      *
  OPT w- ; Warnings off               *
  OPT x- ; Extended debug off         *
***************************************

	SECTION	TEXT

********************************************************************
BOTTOM_BORDER    equ 1         ; Use the bottom overscan           *
TOPBOTTOM_BORDER equ 1         ; Use the top and bottom overscan   *
NO_BORDER        equ 0         ; Use a standard screen             *
PATTERN          equ $00000000 ; See the screen plan               *
SEEMYVBL         equ 1         ; See CPU used if you press ALT key *
ERROR_SYS        equ 1	       ; Manage Errors System              *
FADE_INTRO       equ 0	       ; Fade White to black palette       *
********************************************************************
* Remarque : 0 = I use it / 1 = no need !                          *
********************************************************************

Begin:
	move    SR,d0                    ; Test supervisor mode
	btst    #13,d0                   ; Specialy for relocation
	bne.s   mode_super_yet           ; programs
	move.l  4(sp),a5                 ; Address to basepage
	move.l  $0c(a5),d0               ; Length of TEXT segment
	add.l   $14(a5),d0               ; Length of DATA segment
	add.l   $1c(a5),d0               ; Length of BSS segment
	add.l   #$1000,d0                ; Length of stackpointer
	add.l   #$100,d0                 ; Length of basepage
	move.l  a5,d1                    ; Address to basepage
	add.l   d0,d1                    ; End of program
	and.l   #-2,d1                   ; Make address even
	move.l  d1,sp                    ; New stackspace

	move.l  d0,-(sp)                 ; Mshrink()
	move.l  a5,-(sp)                 ;
	move.w  d0,-(sp)                 ;
	move.w  #$4a,-(sp)               ;
	trap    #1                       ;
	lea 	12(sp),sp                  ;
	
	clr.l	-(sp)                      ; Supervisor mode
	move.w	#32,-(sp)
	trap	#1
	addq.l	#6,sp
	move.l	d0,Save_stack
mode_super_yet:

	bsr	wait_for_drive               ; Stop floppy driver

	bsr	clear_bss                    ; Clean BSS stack
	
	bsr	Init_screens                 ; Screens initialisation

	bsr	Save_and_init_st             ; Save system parameters

	jsr	Multi_boot                   ; Multi Atari Boot code.

	bsr	Init                         ; Inits

******************************************************************************

default_loop:

	bsr	Wait_vbl                     ; Waiting after the VBL

	IFEQ	SEEMYVBL
	clr.b	$ffff8240.w
	ENDC

* < Put your code here >
	bsr	TWISTSCROLLER

* <

	lea     physique(pc),a0          ; Swapping screens
	move.l	(a0),d0
	move.l	4(a0),(a0)+
	move.l	d0,(a0)
	move.b  d0,$ffff820d.w
	move    d0,-(sp)
	move.b  (sp)+,d0
	move.l  d0,$ffff8200.w
  	
	IFEQ	SEEMYVBL
	cmp.b	#$38,$fffffc02.w           ; ALT key
	bne.s	next_key
	move.b	#7,$ffff8240.w           ; See the rest of CPU
next_key:	
	ENDC

	cmp.b	#$39,$fffffc02.w           ; SPACE key
	bne	default_loop

******************************************************************************

SORTIE:
	bsr	Restore_st                   ; Restore all registers

	bsr	DeInit_screens               ; Restore allocation memory

	move.l	Save_stack,-(sp)         ; Restore user Mode
	move.w	#32,-(sp)
	trap	#1
	addq.l	#6,sp

	clr.w	-(sp)                      ; Pterm()
	trap	#1                         ; EXIT program

************************************************
*                                              *
*               Init Routines                  *
*                                              *
************************************************
Init:	movem.l	d0-d7/a0-a6,-(a7)

	IFEQ	FADE_INTRO
	bsr	fadein                       ; Fading white to black
	clr.w	$ffff8240.w
	ENDC
	
	MOVEQ	#1,D0
	LEA	MUSIC+$28D26-$260B0,A0
	jsr	MUSIC+0			; init music

	movea.l	physique(pc),a1
	adda.l	#160*76,a1
	movea.l	#LogoNoeXtra,a0
	move.l	#160*35/4-1,d0
	move.l	(a0)+,(a1)+
	dbf	d0,*-2

	lea	Vbl0(pc),a0
	move.l	a0,$70.w

	lea     PalNoeXtra,a2
	bsr     fadeon	

	lea	PalNoeXtra,a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

	; Initialisations
	bsr Init_rasters
	BSR	INIT_TWISTSCROLLER
	
	bsr	delay
	
	bsr	fadeoff

	move.l	physique(pc),a0
	move.w  #160*200/4-1,d7
	move.l  #PATTERN,(a0)+
	dbf	    d7,*-6

	bsr DoBLiTTER__Copie_LOGO_ELITE_SILVER
	bsr	print_text

	lea	Vbl(pc),a0                   ; Launch VBL
	move.l	a0,$70.w

	lea	PAL_ELITE_SILVER,a0      ; Put palette
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d7               ;
	movem.l	d0-d7,(a1)               ;

	movem.l	(a7)+,d0-d7/a0-a6
	rts

************************************************
*                                              *
*              Screen Routines                 *
*                                              *
************************************************
 IFEQ	BOTTOM_BORDER
SIZE_OF_SCREEN equ 160*250
 ENDC
 IFEQ	TOPBOTTOM_BORDER
SIZE_OF_SCREEN equ 160*300
 ENDC
 IFEQ	NO_BORDER
SIZE_OF_SCREEN equ 160*204
 ENDC

TOTAL_NUMBER_SCREEN equ 2
TOTAL_SIZEOF_SCREEN equ TOTAL_NUMBER_SCREEN*SIZE_OF_SCREEN

Init_screens:
	movem.l	d0-d7/a0-a6,-(a7)

	move.l	#(TOTAL_SIZEOF_SCREEN+256),-(sp)   ; Malloc()
	move.w	#72,-(sp)                ; Screen memory
	trap	#1                         ;
	addq.l	#6,sp                    ;
	tst.l	d0                         ;
	beq	SORTIE                       ; Test memory

	move.l	d0,mstart                ; Keep the adress for Mfree()

	move.l	d0,d1
	add.w	#256,d0                    ; Make screens
	clr.b	d0                         ; Even by 256 bytes
	lea.l	physique(pc),a0            ;
	move.l	d0,(a0)+                 ;
	add.l	#SIZE_OF_SCREEN,d1         ;
	clr.b	d1                         ;
	move.l	d1,(a0)                  ;

	move.b  d0,$ffff820d.w           ; Put physical screen
	move    d0,-(sp)                 ;
	move.b  (sp)+,d0                 ;
	move.l  d0,$ffff8200.w           ;

	move.l	physique(pc),a0          ; Put PATTERN on screens
	move.l	physique+4(pc),a1        ;
	move.w  #(SIZE_OF_SCREEN)/4-1,d7 ;
	move.l  #PATTERN,(a0)+           ;
	move.l  #PATTERN,(a1)+           ;
	dbf	    d7,*-12                  ;

	movem.l	(a7)+,d0-d7/a0-a6
	rts

DeInit_screens:
	movem.l	d0-d7/a0-a6,-(a7)

	move.l	#mstart,-(sp)            ; MFree()
	move.w	#73,-(sp)                ; Screen memory
	trap	#1                         ;
	addq.l	#6,sp                    ;

	movem.l	(a7)+,d0-d7/a0-a6	
	rts

physique:	ds.l TOTAL_NUMBER_SCREEN ; Nombre d'écrans déclarés

************************************************
*                                              *
*               Vbl Routines                   *
*                                              *
************************************************
Vbl0:	movem.l	d0-d7/a0-a6,-(a7)

	st	Vsync

	jsr 	(MUSIC+4)			; call music
	
	movem.l	(a7)+,d0-d7/a0-a6
	rte

Vbl:
	movem.l	d0-d7/a0-a6,-(a7)

	st	Vsync                        ; Synchronisation

	IFEQ	BOTTOM_BORDER
	lea	Over_rout(pc),a0             ; HBL
	move.l	a0,$120.w                ; Timer B vector
	move.b	#199,$fffffa21.w         ; At the position
	move.b	#8,$fffffa1b.w           ; Launch HBL
	ENDC

	IFEQ	NO_BORDER
      MOVEM.L   A0/D0,-(A7) 
      MOVEQ     #0,D0 
      MOVE.B    #0,$FFFFFA1B.W
      MOVE.B    #1,$FFFFFA21.W
      MOVE.B    #8,$FFFFFA1B.W
      MOVE.L    PTR_PAL_RASTER,COUNT_1 
      MOVEA.L   COUNT_2,A0
      MOVE.B    (A0)+,D0
      ADD.L     D0,D0 
      ADD.L     D0,COUNT_1
      MOVE.L    A0,COUNT_2
      CMPI.B    #$FF,(A0) 
      BNE       .end 
      LEA       COURBE,A0
      MOVE.L    A0,COUNT_2
.end: MOVEM.L   (A7)+,A0/D0 
	ENDC

	jsr 	(MUSIC+4)                  ; Play music

	movem.l	(a7)+,d0-d7/a0-a6
	rte

Wait_vbl:                          ; Test Synchronisation
	move.l	a0,-(a7)
	lea	Vsync,a0
	sf	(a0)
.loop:	tst.b	(a0)
	beq.s	.loop
	move.l	(a7)+,a0
	rts

	IFEQ	NO_BORDER
Init_rasters:
      LEA       COURBE,A0
      MOVE.L    A0,COUNT_2
      rts

HBL:  MOVE.L    A6,-(A7)
      MOVEA.L   COUNT_1,A6
      MOVE.W    (A6),$FF8240.L
      ADDI.L    #2,COUNT_1
      SUBQ.B    #1,COMPTEUR
      TST.B     COMPTEUR 
      BEQ       HBL_TRANS 
      MOVEA.L   (A7)+,A6
      BCLR      #0,$FFFFFA0F.W
      RTE 

HBL_TRANS:
      MOVE.L    #HBL_END,$120.L 
      MOVEA.L   (A7)+,A6
      BCLR      #0,$FFFFFA0F.W
      RTE

HBL_END:
      clr.w	$FF8240.l
      move.b	#200-1,COMPTEUR.l
      move.l	#HBL,$120.L
      bclr	#$0,$FA0F  
      rte

TIMER:MOVE      #$2500,SR 
      rte
	ENDC

	IFEQ	BOTTOM_BORDER
***************************************************************
*                                                             *
*             < Here is the lower border rout >               *
*                                                             *
***************************************************************
Over_rout:
	sf	$fffffa21.w                  ; Stop Timer B
	sf	$fffffa1b.w                  ;
	dcb.w	95,$4e71                   ; 95 nops	Wait line end
	sf	$ffff820a.w                  ; Modif Frequency 60 Hz !
	dcb.w	28,$4e71                   ; 28 nops	Wait line end
	move.b	#$2,$ffff820a.w          ; 50 Hz !
	rte
	ENDC

	IFEQ	TOPBOTTOM_BORDER
***************************************************************
*                                                             *
*          < Here is the top and lower border rout >          *
*                                                             *
***************************************************************
herz = $FFFF820A
iera = $FFFFFA07
ierb = $FFFFFA09
isra = $FFFFFA0F
isrb = $FFFFFA11
imra = $FFFFFA13
imrb = $FFFFFA15
tacr = $FFFFFA19
tadr = $FFFFFA1F
my_hbl:rte

topbord:
	move.l	a0,-(a7)
	move	#$2100,sr
	stop	#$2100                     ; Sync with interrupt
	clr.b	(tacr).w                   ; Stop timer A
	dcb.w	78,$4E71                   ; 78 nops
	clr.b	(herz).w                   ; 60 Hz
	dcb.w	18,$4E71                   ; 18 nops
	move.b	#2,(herz).w              ; 50 Hz
	lea	botbord(pc),a0
	move.l	a0,$134.w                ; Timer A vector
	move.b	#178,(tadr).w            ; Countdown value for timer A
	move.b	#7,(tacr).w              ; Delay mode, clock divided by 200
	move.l	(a7)+,a0                 ;
	bclr.b	#5,(isra).w              ; Clear end of interrupt flag
	rte

botbord:
	move	#$2100,SR                  ;
	stop	#$2100                     ; sync with interrupt
	clr.b	(tacr).w                   ; stop timer A
	dcb.w	78,$4E71                   ; 78 nops
	clr.b	(herz).w                   ; 60 Hz
	dcb.w	18,$4E71                   ; 18 nops
	move.b	#2,(herz).w              ; 50 Hz
	bclr.b	#5,(isra).w              ;
	rte
	ENDC

************************************************
*                                              *
*         Save/Restore System Routines         *
*                                              *
************************************************
Save_and_init_st:

	move #$2700,sr
		
	lea	Save_all,a0                  ; Save adresses parameters
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
	
	lea	Save_rest,a0                  ; Save adresses parameters
	move.l	$068.w,(a0)+	
	move.l	$070.w,(a0)+	
	move.l	$110.w,(a0)+	
	move.l	$114.w,(a0)+	
	move.l	$118.w,(a0)+	
	move.l	$120.w,(a0)+	
	move.l	$134.w,(a0)+	
	move.l	$484.w,(a0)+	

	movem.l	$ffff8240.w,d0-d7        ; Save palette GEM system
	movem.l	d0-d7,(a0)

	bclr	#3,$fffffa17.w             ; Clear Timers
	clr.b	$fffffa07.w
	clr.b	$fffffa09.w 
	clr.b	$484.w                     ; No bip, no repeat

	stop	#$2300

	move	#4,-(sp)                   ; Save & Change Resolution (GetRez)
	trap	#14	                       ; Get Current Res.
	addq.l	#2,sp
	move	d0,Old_Resol+2

	move	#3,-(sp)                   ; Save Screen Address (Logical)
	trap	#14
	addq.l	#2,sp
	move.l	d0,Old_Screen+2

	bsr	hide_mouse                   ; Keyboard and mouse
	bsr	flush
	move.b	#$12,d0
	bsr	setkeyboard

	IFEQ	BOTTOM_BORDER
	sf	$fffffa21.w                  ; Stop the Timer B
	sf	$fffffa1b.w                  ;
	lea	Over_rout(pc),a0             ; Launch HBL
	move.l	a0,$120.w                ;
	bset	#0,$fffffa07.w             ; Timer B vector
	bset	#0,$fffffa13.w             ; Timer B on
	ENDC

	IFEQ	TOPBOTTOM_BORDER
	move.b	#%00100000,(iera).w      ; Enable timer A
	move.b	#%00100000,(imra).w
	and.b	#%00010000,(ierb).w        ; Disable all except timer D
	and.b	#%00010000,(imrb).w
	or.b	#%01000000,(ierb).w        ; Enable keyboard
	or.b	#%01000000,(imrb).w
	clr.b	(tacr).w                   ; Timer A off
	lea	my_hbl(pc),a0
	move.l	a0,$68.w                 ; Horizontal blank
	lea	topbord(pc),a0
	move.l	a0,$134.w                ; Timer A vector
	ENDC

	IFEQ	NO_BORDER
      ANDI.B    #$DF,$FFFFFA09.W
      ANDI.B    #$FE,$FFFFFA07.W
      MOVE.L    #HBL,$120.W 
      MOVE.L    #TIMER,$118.W 
      ORI.B     #1,$FFFFFA07.W
      ORI.B     #1,$FFFFFA13.W
	ENDC

	rts

Restore_st:

	move #$2700,sr

	jsr	MUSIC+4                      ; Stop SNDH music

	lea       $ffff8800.w,a0         ; Cut sound
	move.l    #$8000000,(a0)
	move.l    #$9000000,(a0)
	move.l    #$a000000,(a0)

	IFEQ	ERROR_SYS
	bsr	OUTPUT_TRACE_ERROR
	ENDC

	lea	Save_all,a0                  ; Restore adresses parameters
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
	
	lea	Save_rest,a0                 ; Restore adresses parameters
	move.l	(a0)+,$068.w
	move.l	(a0)+,$070.w
	move.l	(a0)+,$110.w
	move.l	(a0)+,$114.w
	move.l	(a0)+,$118.w
	move.l	(a0)+,$120.w
	move.l	(a0)+,$134.w
	move.l	(a0)+,$484.w

	movem.l	(a0),d0-d7               ; Restore palette GEM system
	movem.l	d0-d7,$ffff8240.w

	bset.b #3,$fffffa17.w            ; Re-active Timer C

	stop	#$2300

	bsr	flush                        ; Restore keyboard and mouse
	move.b	#8,d0
	bsr	setkeyboard	
	bsr	show_mouse

Old_Resol:                         ; Restore Old Screen & Resolution
	move	#0,-(sp)
Old_Screen:
	move.l	#0,-(sp)
	move.l	(sp),-(sp)
	move	#5,-(sp)
	trap	#14
	lea	12(sp),sp

	move.w	#$25,-(a7)               ; VSYNC
	trap	#14
	addq.w	#2,a7

	rts

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

wait_for_drive:
	move.w	$ffff8604.w,d0
	btst	#7,d0
	bne.s	wait_for_drive
	rts

clear_bss:
	lea	bss_start,a0
.loop:	clr.l	(a0)+
	cmp.l	#bss_end,a0
	blt.s	.loop
	rts

	IFEQ	FADE_INTRO
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
	ENDC

************************************************
*                                              *
*               Sub Routines                   *
*                                              *
************************************************

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

************************************************
*                                              *
************************************************

DoBLiTTER__Copie_LOGO_ELITE_SILVER:
                movea.l	physique(pc),a1
                adda.l	#160*2,a1
                movea.l	physique+4(pc),a2
                adda.l	#160*2,a2
                movea.l	#LOGO_ELITE_SILVER,a0
                move.l	#160*$32/4-1,d0
                move.l	(a0),(a1)+
                move.l	(a0)+,(a2)+
                dbf	d0,*-4
                rts				;and return.

***************************************************************
*                 TEXTE FONT 8*8 1 PLAN                       *
***************************************************************
MED equ 1
LOW equ 0
CHARS      equ 40  ; chars per line, 80=for med res, 40 for low res
LINES      equ 33  ; 33 for 8x8 font, 45 with 6x6 font 
FONTSIZE   equ 8   ; 8=8x8, 6=6x6 font
SHIFTSIZE  equ 4   ; 2=MED RESOLUTION, 4=FOR LOW RESOLUTION
RESOLUTION equ LOW ; if no, then its low resolution

print_text:     clr.w	x_curs
                clr.l	x_offset
                clr.l	y_offset
                lea     message(pc),a2
new_char:       bsr     _x_conversion
                moveq   #0,d0    
                move.b  (a2)+,d0	;if zero, stop routine
                cmp.b	#0,d0
                beq	LF
                cmp.b	#$ff,d0
                bne.s   process_char
                rts

process_char:   asl.w 	#3,d0                ; valeur * 8
                lea     fonte1(pc),a1	
                sub.w	#256,d0         
                adda.w  d0,a1
                
                movea.l physique(pc),a0
                lea     160*54(a0),a0
                add.w   #6,a0
                adda.l  y_offset(pc),a0
                adda.l  x_offset(pc),a0
                
                movea.l physique+4(pc),a3
                lea     160*54(a3),a3
                add.w   #6,a3
                adda.l  y_offset(pc),a3
                adda.l  x_offset(pc),a3
                
                rept	FONTSIZE
                move.b  (a1),(a0)	
                move.b  (a1)+,(a3)	
                lea	160(a0),a0
                lea	160(a3),a3
                endr
                
                addq.w  #1,x_curs           
                cmpi.w  #CHARS,x_curs        ; 79 for MED res
                bls     new_char
                move.w  #CHARS,x_curs        ; 79 for MED res
                bra   	new_char

LF:             clr.w	x_curs                 ; back to first char
                addi.l  #FONTSIZE*160+160,y_offset ; linefeed when reached ',0'
                cmpi.l  #LINES*FONTSIZE*160,y_offset
                bls     new_char
                move.l  #LINES*FONTSIZE*160,y_offset
                bra     new_char

_x_conversion:  move.w	x_curs(pc),d0
                and.l	#$ffff,d0
                btst	#0,d0
                beq.s	_even
                subq.w	#1,d0
                mulu	#SHIFTSIZE,d0          ; 2=med res, 4=low
                addq.w	#1,d0
                bra	_done_conv
_even:          mulu	#SHIFTSIZE,d0          ; 2=med res, 4=low
_done_conv:     move.l	d0,x_offset
                rts
	
************************************************
*           TWIST SCROLLER 1 PLAN              *
************************************************
NO_LIGNE	equ	164

TWISTSCROLLER:
      ; Routine d'effacement 1 plan
      MOVE.L physique(pc),A0
		  ADDQ.L #6,A0
		  lea 160*163(a0),a0
		  MOVEQ #0,D1
		  MOVEQ #4,D0
i		  SET 0
.lp	  	
		  REPT 160
		  MOVE.W D1,i(A0)
i		  SET i+8
		  ENDR
		  LEA 160*8(A0),A0
		  DBF D0,.lp
		
      MOVE.L    #PTR_COURBE_S,SAV_COURBE_S
      LEA       COURBE_S,A0
      LEA       PTR_COURBE_S,A1
      MOVE.W    (A1),D1 
      MOVEQ     #$30,D0 
.loop:MOVE.W    (A0)+,(A1)+ 
      DBF       D0,.loop
      MOVE.W    D1,(A1) 
      MOVEA.L   PTR_BUFFER_S2,A0
      MOVE.L    (A0),BEGIN_BUFFER_S2
      ADDA.L    PAS_CAR,A0
      CMPI.L    #$FFFFFFFF,(A0) 
      BNE.S     .not_end_car 
      LEA       BUFFER_S2,A0
      MOVE.b    #1,TEST_FIN
      MOVE.L    #BUFFER_S1,PTR_BUFFER_S1
.not_end_car:
			MOVE.L    A0,PTR_BUFFER_S2
      MOVEA.L   PTR_BUFFER_S1,A0
      MOVE.L    (A0),BEGIN_BUFFER_S1
      MOVE.L    PAS_CAR,D0
      ADD.L     D0,PTR_BUFFER_S1
      BSR.s       COPY_LIGNE 
			TST.B	TEST_FIN
			BEQ.S	RTS
			MOVE.B	#0,TEST_FIN
			LEA 	PTR_BUFFER_S,A4
			MOVE.L	4(A4),(A4)
			LEA 	REBOND_S,A3
			MOVEA.L	PTR_TEXTE,A0
			MOVE.B	(A0)+,D0
			CMPI.B	#$7E,(A0)
			BNE.S	.NEXT_CAR
			LEA 	TEXTE,A0
.NEXT_CAR:
			MOVE.L	A0,PTR_TEXTE
			EXT.W	D0
			ADD.W	D0,D0
			ADD.W	D0,D0
			MOVE.L	0(A3,D0.W),4(A4)
RTS:  RTS 

COPY_LIGNE:
			MOVEA.L   BEGIN_BUFFER_S2,A0
      LEA       PTR_BUFFER_S,A1
      MOVE.L    (A1)+,D1
      MOVE.L    (A1),D2 
      LEA       0(A0,D1.L),A3 
      LEA       0(A0,D2.L),A4 
      MOVEA.L   BEGIN_BUFFER_S1,A0
      MOVEQ     #$F,D0
.lop0:MOVEM.L   2(A0),A1-A2/D1-D7 
      MOVEM.L   A1-A2/D1-D7,(A0)
      MOVE.W    38(A0),36(A0) 
      MOVE.W    2(A3),38(A0)
      MOVE.W    (A4),D1 
      OR.W      D1,38(A0) 
      LEA       40(A0),A0 
      ADDQ.L    #4,A3 
      ADDQ.L    #4,A4 
      DBF       D0,.lop0
      MOVEA.L   BEGIN_BUFFER_S1,A0
      MOVEA.L   physique(pc),A1
      MOVE.W    #NO_LIGNE,D6
      MOVEQ     #$13,D1 
.lop1:LEA       (A0),A2 
      LEA       (A1),A3 
      MOVEA.L   SAV_COURBE_S,A4
      MOVE.W    (A4),D2 
      MOVE.W    2(A4),D3
      ADD.W     D6,D2 
      ADD.W     D6,D3 
      MULU      #$A0,D2 
      MULU      #$A0,D3 
      ADDQ.L    #4,SAV_COURBE_S
      ADDA.L    D2,A3 
 rept 2
			MOVE.B    (A2),6(A3)
      MOVE.B    40(A2),166(A3)
      MOVE.B    80(A2),326(A3)
      MOVE.B    120(A2),486(A3) 
      MOVE.B    160(A2),646(A3) 
      MOVE.B    200(A2),806(A3) 
      MOVE.B    240(A2),966(A3) 
      MOVE.B    280(A2),1126(A3)
      MOVE.B    320(A2),1286(A3)
      MOVE.B    360(A2),1446(A3)
      MOVE.B    400(A2),1606(A3)
      MOVE.B    440(A2),1766(A3)
      MOVE.B    480(A2),1926(A3)
      MOVE.B    520(A2),2086(A3)
      MOVE.B    560(A2),2246(A3)
      MOVE.B    600(A2),2406(A3)
      LEA       1(A0),A2
      LEA       1(A1),A3
      ADDA.L    D3,A3 
 endr
      ADDQ.L    #2,A0 
      ADDQ.L    #8,A1 
      DBF       D1,.lop1
      RTS 

INIT_TWISTSCROLLER:
			LEA       FONTE_16_16,A0
      LEA       BUF_SCROL1,A1
      MOVEQ     #4,D0 
.lop0:MOVEQ     #$13,D1 
.lop1:MOVEQ     #$F,D2
      MOVE.L    A0,-(A7)
.lop2:MOVE.W    (A0),D3 
      MOVE.W    D3,(A1) 
      LEA       160(A0),A0
      ADDQ.L    #4,A1 
      DBF       D2,.lop2
      MOVEA.L   (A7)+,A0
      ADDQ.L    #8,A0 
      DBF       D1,.lop1
      LEA       2400(A0),A0 
      DBF       D0,.lop0
      
			LEA       BUF_SCROL0,A0
      LEA       BUF_SCROL2,A1
      BSR.S     REMPLI_BUFFER 
      LEA       BUF_SCROL2,A0
      LEA       BUF_SCROL3,A1
      BSR.S     REMPLI_BUFFER 
      LEA       BUF_SCROL3,A0
      LEA       BUF_SCROL4,A1
      BSR.S     REMPLI_BUFFER 
      RTS 

REMPLI_BUFFER:
			MOVEQ     #$31,D0 
.lop0:MOVEQ     #$F,D1
.lop1:MOVE.L    (A0)+,D5
      MOVE.L    D5,(A1) 
      MOVEQ     #3,D2 
.lop2:MOVE      #0,CCR
      ROXL      2(A1) 
      ROXL      (A1)
      DBF       D2,.lop2
      ADDQ.L    #4,A1 
      DBF       D1,.lop1
      DBF       D0,.lop0
      RTS 

******************************************************************
	SECTION	DATA
******************************************************************

* Full data here :
* >
message:
		DC.B      "    ELITE AND NOEXTRA PRESENT IN 2010   ",0
		DC.B      "       GAME NAME (C) COMPANY NAME       ",0
		DC.B      "                                        ",0
		DC.B      "    CRACKED/TRAINED.........XXXXXXX     ",0
		DC.B      "    CODE....................ZORRO 2     ",0
		DC.B      "    GRAPHISM...............MISTER.A     ",0
		DC.B      "    MUSIC......................EPIC     ",0
		DC.B      "                                        ",0
		DC.B      " GREETINGS ARE SENT TO FOLLOWING CREWS: ",0
		DC.B      "  DBUG.ELITE.ICS.RG.PARADIZE.TSCC.ZUUL  ",0
		DC.B      "  POV.PULSION.HMD.IMPACT.EUROSWAP.STAX  ",0
		DC.B      " FUZION.THE LEMMINGS.SECTOR ONE.X-TROLL ",$ff
		even
x_curs:         dc.l 0
y_offset:       dc.l 0
x_offset:       dc.l 0
fonte1:
	incbin 	"FONT88*.DAT"
	EVEN
*
TEST_FIN:DC.W $0 
SAV_COURBE_S:
	DC.L      PTR_COURBE_S 
PTR_COURBE_S:
	dc.w	$0
COURBE_S:
	dc.w	$0000,$0000,$0001,$0002
	dc.w	$0003,$0004,$0006,$0008
	dc.w	$000A,$000C,$000E,$000F
	dc.w	$0010,$0011,$0012,$0013
	dc.w	$0014,$0014,$0014,$0012
	dc.w	$0010,$000E,$000C,$000A
	dc.w	$0008,$0006,$0004,$0002
	dc.w	$0001,$0001,$0000,$0000
	dc.w	$0000,$0000,$0001,$0002
	dc.w	$0004,$0006,$0009,$0008
	dc.w	$0006,$0004,$0002,$0001
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000

PTR_BUFFER_S1:
	DC.L      BUFFER_S1 
BUFFER_S1:
	dc.l	BUF_SCROL5
	dc.l	BUF_SCROL5
	dc.l	BUF_SCROL5
	dc.l	BUF_SCROL5
	dc.l	BUF_SCROL6
	dc.l	BUF_SCROL6
	dc.l	BUF_SCROL6
	dc.l	BUF_SCROL6
	dc.l	BUF_SCROL7
	dc.l	BUF_SCROL7
	dc.l	BUF_SCROL7
	dc.l	BUF_SCROL7
	dc.l	BUF_SCROL8
	dc.l	BUF_SCROL8
	dc.l	BUF_SCROL8
	dc.l	BUF_SCROL8
	dc.l	-1
PTR_BUFFER_S2:
	DC.L      BUFFER_S2 
BUFFER_S2:
	dc.l	BUF_SCROL0
	dc.l	BUF_SCROL0
	dc.l	BUF_SCROL0
	dc.l	BUF_SCROL0
	dc.l	BUF_SCROL2
	dc.l	BUF_SCROL2
	dc.l	BUF_SCROL2
	dc.l	BUF_SCROL2
	dc.l	BUF_SCROL3
	dc.l	BUF_SCROL3
	dc.l	BUF_SCROL3
	dc.l	BUF_SCROL3
	dc.l	BUF_SCROL4
	dc.l	BUF_SCROL4
	dc.l	BUF_SCROL4
	dc.l	BUF_SCROL4
	dc.l	-1
BEGIN_BUFFER_S2:
	DC.L      BUF_SCROL0 
PTR_BUFFER_S:
	DC.W      $0000,$0C40,$0000,$0C40 
BEGIN_BUFFER_S1:
	DC.L      BUF_SCROL5 
PTR_TEXTE:DC.L      TEXTE 
TEXTE:
	DC.B      '        '
	DC.B      'ABCDEFGHIJKLMNOPQRST'
  DC.B      'UVWXYZ 0123456789 :().'
	DC.B      '        '
  DC.B      $7E,$00
 	even

rien:	dcb.w	1000,0
 	
FONTE_16_16:
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$FFE0,$FFE0,$FFE0,$FFE0
	dc.w	$07FE,$07FE,$07FE,$07FE
	dc.w	$FFC0,$FFC0,$FFC0,$FFC0
	dc.w	$07FE,$07FE,$07FE,$07FE
	dc.w	$07FE,$07FE,$07FE,$07FE
	dc.w	$07E0,$07E0,$07E0,$07E0
	dc.w	$FC3E,$FC3E,$FC3E,$FC3E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$003E,$003E,$003E,$003E
	dc.w	$F81E,$F81E,$F81E,$F81E
	dc.w	$FC00,$FC00,$FC00,$FC00
	dc.w	$0FE0,$0FE0,$0FE0,$0FE0
	dc.w	$0FE0,$0FE0,$0FE0,$0FE0
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$FFE0,$FFE0,$FFE0,$FFE0
	dc.w	$0FE0,$0FE0,$0FE0,$0FE0
	dc.w	$FFE0,$FFE0,$FFE0,$FFE0
	dc.w	$1FFE,$1FFE,$1FFE,$1FFE
	dc.w	$FFE0,$FFE0,$FFE0,$FFE0
	dc.w	$1FF0,$1FF0,$1FF0,$1FF0
	dc.w	$FFF8,$FFF8,$FFF8,$FFF8
	dc.w	$1FFE,$1FFE,$1FFE,$1FFE
	dc.w	$FFF0,$FFF0,$FFF0,$FFF0
	dc.w	$1FFE,$1FFE,$1FFE,$1FFE
	dc.w	$1FFE,$1FFE,$1FFE,$1FFE
	dc.w	$1FF8,$1FF8,$1FF8,$1FF8
	dc.w	$FC3E,$FC3E,$FC3E,$FC3E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$003E,$003E,$003E,$003E
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$FC00,$FC00,$FC00,$FC00
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$1FF0,$1FF0,$1FF0,$1FF0
	dc.w	$FFF8,$FFF8,$FFF8,$FFF8
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$FFF8,$FFF8,$FFF8,$FFF8
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$FFF8,$FFF8,$FFF8,$FFF8
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$3FFE,$3FFE,$3FFE,$3FFE
	dc.w	$FFF8,$FFF8,$FFF8,$FFF8
	dc.w	$3FFE,$3FFE,$3FFE,$3FFE
	dc.w	$3FFE,$3FFE,$3FFE,$3FFE
	dc.w	$3FFC,$3FFC,$3FFC,$3FFC
	dc.w	$FC3E,$FC3E,$FC3E,$FC3E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$003E,$003E,$003E,$003E
	dc.w	$F87E,$F87E,$F87E,$F87E
	dc.w	$FC00,$FC00,$FC00,$FC00
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$FC3E,$FC3E,$FC3E,$FC3E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$003E,$003E,$003E,$003E
	dc.w	$F8FC,$F8FC,$F8FC,$F8FC
	dc.w	$FC00,$FC00,$FC00,$FC00
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$FC3E,$FC3E,$FC3E,$FC3E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$003E,$003E,$003E,$003E
	dc.w	$F9F8,$F9F8,$F9F8,$F9F8
	dc.w	$FC00,$FC00,$FC00,$FC00
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$F87E,$F87E,$F87E,$F87E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$FE00,$FE00,$FE00,$FE00
	dc.w	$FE00,$FE00,$FE00,$FE00
	dc.w	$FE1E,$FE1E,$FE1E,$FE1E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$003E,$003E,$003E,$003E
	dc.w	$FBF0,$FBF0,$FBF0,$FBF0
	dc.w	$FC00,$FC00,$FC00,$FC00
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$FE00,$FE00,$FE00,$FE00
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FF00,$FF00,$FF00,$FF00
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFF8,$FFF8,$FFF8,$FFF8
	dc.w	$FC00,$FC00,$FC00,$FC00
	dc.w	$FC00,$FC00,$FC00,$FC00
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$003E,$003E,$003E,$003E
	dc.w	$FFE0,$FFE0,$FFE0,$FFE0
	dc.w	$FC00,$FC00,$FC00,$FC00
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$7FF0,$7FF0,$7FF0,$7FF0
	dc.w	$007E,$007E,$007E,$007E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FE00,$FE00,$FE00,$FE00
	dc.w	$F0FE,$F0FE,$F0FE,$F0FE
	dc.w	$FFF8,$FFF8,$FFF8,$FFF8
	dc.w	$FFF8,$FFF8,$FFF8,$FFF8
	dc.w	$FC00,$FC00,$FC00,$FC00
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$003E,$003E,$003E,$003E
	dc.w	$FFC0,$FFC0,$FFC0,$FFC0
	dc.w	$FC00,$FC00,$FC00,$FC00
	dc.w	$FBBE,$FBBE,$FBBE,$FBBE
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$F9BE,$F9BE,$F9BE,$F9BE
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$003E,$003E,$003E,$003E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FF00,$FF00,$FF00,$FF00
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFF8,$FFF8,$FFF8,$FFF8
	dc.w	$FFF8,$FFF8,$FFF8,$FFF8
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$FC3E,$FC3E,$FC3E,$FC3E
	dc.w	$FFE0,$FFE0,$FFE0,$FFE0
	dc.w	$FC00,$FC00,$FC00,$FC00
	dc.w	$FBBE,$FBBE,$FBBE,$FBBE
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$F9FE,$F9FE,$F9FE,$F9FE
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$1FFC,$1FFC,$1FFC,$1FFC
	dc.w	$003E,$003E,$003E,$003E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FE00,$FE00,$FE00,$FE00
	dc.w	$FFF8,$FFF8,$FFF8,$FFF8
	dc.w	$FE3E,$FE3E,$FE3E,$FE3E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$FE7E,$FE7E,$FE7E,$FE7E
	dc.w	$FBF0,$FBF0,$FBF0,$FBF0
	dc.w	$FE00,$FE00,$FE00,$FE00
	dc.w	$FBBE,$FBBE,$FBBE,$FBBE
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$FCFE,$FCFE,$FCFE,$FCFE
	dc.w	$FFF8,$FFF8,$FFF8,$FFF8
	dc.w	$00FE,$00FE,$00FE,$00FE
	dc.w	$003E,$003E,$003E,$003E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$F87E,$F87E,$F87E,$F87E
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$FFF8,$FFF8,$FFF8,$FFF8
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$FC3E,$FC3E,$FC3E,$FC3E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$F9F8,$F9F8,$F9F8,$F9F8
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FBBE,$FBBE,$FBBE,$FBBE
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$FFF8,$FFF8,$FFF8,$FFF8
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$FFF8,$FFF8,$FFF8,$FFF8
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$003E,$003E,$003E,$003E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$FC00,$FC00,$FC00,$FC00
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$FC3E,$FC3E,$FC3E,$FC3E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$F8FC,$F8FC,$F8FC,$F8FC
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$FFE0,$FFE0,$FFE0,$FFE0
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$FCFC,$FCFC,$FCFC,$FCFC
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$003E,$003E,$003E,$003E
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$3FFE,$3FFE,$3FFE,$3FFE
	dc.w	$FFF8,$FFF8,$FFF8,$FFF8
	dc.w	$3FFE,$3FFE,$3FFE,$3FFE
	dc.w	$FC00,$FC00,$FC00,$FC00
	dc.w	$3FFE,$3FFE,$3FFE,$3FFE
	dc.w	$FC3E,$FC3E,$FC3E,$FC3E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$F87E,$F87E,$F87E,$F87E
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$FC00,$FC00,$FC00,$FC00
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$FCFE,$FCFE,$FCFE,$FCFE
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$003E,$003E,$003E,$003E
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$FFF8,$FFF8,$FFF8,$FFF8
	dc.w	$1FFE,$1FFE,$1FFE,$1FFE
	dc.w	$FFF0,$FFF0,$FFF0,$FFF0
	dc.w	$1FFE,$1FFE,$1FFE,$1FFE
	dc.w	$FC00,$FC00,$FC00,$FC00
	dc.w	$1FF6,$1FF6,$1FF6,$1FF6
	dc.w	$FC3E,$FC3E,$FC3E,$FC3E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$3FFE,$3FFE,$3FFE,$3FFE
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$1FF0,$1FF0,$1FF0,$1FF0
	dc.w	$FC00,$FC00,$FC00,$FC00
	dc.w	$3FFE,$3FFE,$3FFE,$3FFE
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$003E,$003E,$003E,$003E
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$FFE0,$FFE0,$FFE0,$FFE0
	dc.w	$07FE,$07FE,$07FE,$07FE
	dc.w	$FFC0,$FFC0,$FFC0,$FFC0
	dc.w	$07FE,$07FE,$07FE,$07FE
	dc.w	$FC00,$FC00,$FC00,$FC00
	dc.w	$07E6,$07E6,$07E6,$07E6
	dc.w	$FC3E,$FC3E,$FC3E,$FC3E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$0FE0,$0FE0,$0FE0,$0FE0
	dc.w	$F81E,$F81E,$F81E,$F81E
	dc.w	$0FFE,$0FFE,$0FFE,$0FFE
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$FC00,$FC00,$FC00,$FC00
	dc.w	$0FCE,$0FCE,$0FCE,$0FCE
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$FFF0,$FFF0,$FFF0,$FFF0
	dc.w	$003E,$003E,$003E,$003E
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$F81E,$F81E,$F81E,$F81E
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$01F0,$01F0,$01F0,$01F0
	dc.w	$7FC0,$7FC0,$7FC0,$7FC0
	dc.w	$7FC0,$7FC0,$7FC0,$7FC0
	dc.w	$7C7C,$7C7C,$7C7C,$7C7C
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$07E0,$07E0,$07E0,$07E0
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$03E0,$03E0,$03E0,$03E0
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$F81E,$F81E,$F81E,$F81E
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0FE0,$0FE0,$0FE0,$0FE0
	dc.w	$03F0,$03F0,$03F0,$03F0
	dc.w	$7FF0,$7FF0,$7FF0,$7FF0
	dc.w	$7FF0,$7FF0,$7FF0,$7FF0
	dc.w	$7C7C,$7C7C,$7C7C,$7C7C
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$0FC0,$0FC0,$0FC0,$0FC0
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$1FF0,$1FF0,$1FF0,$1FF0
	dc.w	$1FF0,$1FF0,$1FF0,$1FF0
	dc.w	$1FC0,$1FC0,$1FC0,$1FC0
	dc.w	$03F8,$03F8,$03F8,$03F8
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$FC3E,$FC3E,$FC3E,$FC3E
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$FEFE,$FEFE,$FEFE,$FEFE
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$1FF0,$1FF0,$1FF0,$1FF0
	dc.w	$07F0,$07F0,$07F0,$07F0
	dc.w	$7FF8,$7FF8,$7FF8,$7FF8
	dc.w	$7FF8,$7FF8,$7FF8,$7FF8
	dc.w	$7C7C,$7C7C,$7C7C,$7C7C
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$0FC0,$0FC0,$0FC0,$0FC0
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$3FC0,$3FC0,$3FC0,$3FC0
	dc.w	$03FC,$03FC,$03FC,$03FC
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$FC3E,$FC3E,$FC3E,$FC3E
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FC3E,$FC3E,$FC3E,$FC3E
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$0FF0,$0FF0,$0FF0,$0FF0
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$7C7C,$7C7C,$7C7C,$7C7C
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$1F80,$1F80,$1F80,$1F80
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$7FC0,$7FC0,$7FC0,$7FC0
	dc.w	$03FE,$03FE,$03FE,$03FE
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$FE7E,$FE7E,$FE7E,$FE7E
	dc.w	$FBBE,$FBBE,$FBBE,$FBBE
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$1FF0,$1FF0,$1FF0,$1FF0
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$7E7C,$7E7C,$7E7C,$7E7C
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$1F80,$1F80,$1F80,$1F80
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$7FC0,$7FC0,$7FC0,$7FC0
	dc.w	$03FE,$03FE,$03FE,$03FE
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$7E7C,$7E7C,$7E7C,$7E7C
	dc.w	$FBBE,$FBBE,$FBBE,$FBBE
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$01FE,$01FE,$01FE,$01FE
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$7EFC,$7EFC,$7EFC,$7EFC
	dc.w	$3FF0,$3FF0,$3FF0,$3FF0
	dc.w	$01FC,$01FC,$01FC,$01FC
	dc.w	$007C,$007C,$007C,$007C
	dc.w	$3FFE,$3FFE,$3FFE,$3FFE
	dc.w	$7000,$7000,$7000,$7000
	dc.w	$3F00,$3F00,$3F00,$3F00
	dc.w	$00FC,$00FC,$00FC,$00FC
	dc.w	$7C7C,$7C7C,$7C7C,$7C7C
	dc.w	$7C7C,$7C7C,$7C7C,$7C7C
	dc.w	$FF00,$FF00,$FF00,$FF00
	dc.w	$00FF,$00FF,$00FF,$00FF
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$FBBE,$FBBE,$FBBE,$FBBE
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$3FFE,$3FFE,$3FFE,$3FFE
	dc.w	$03FC,$03FC,$03FC,$03FC
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$7C7C,$7C7C,$7C7C,$7C7C
	dc.w	$01F0,$01F0,$01F0,$01F0
	dc.w	$00FC,$00FC,$00FC,$00FC
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$3FFE,$3FFE,$3FFE,$3FFE
	dc.w	$7FF0,$7FF0,$7FF0,$7FF0
	dc.w	$3FE0,$3FE0,$3FE0,$3FE0
	dc.w	$01FC,$01FC,$01FC,$01FC
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$3FFC,$3FFC,$3FFC,$3FFC
	dc.w	$FE00,$FE00,$FE00,$FE00
	dc.w	$007F,$007F,$007F,$007F
	dc.w	$FEFE,$FEFE,$FEFE,$FEFE
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$FBBE,$FBBE,$FBBE,$FBBE
	dc.w	$1FF0,$1FF0,$1FF0,$1FF0
	dc.w	$0FFE,$0FFE,$0FFE,$0FFE
	dc.w	$07F8,$07F8,$07F8,$07F8
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$7C7C,$7C7C,$7C7C,$7C7C
	dc.w	$01F0,$01F0,$01F0,$01F0
	dc.w	$01F8,$01F8,$01F8,$01F8
	dc.w	$7FF8,$7FF8,$7FF8,$7FF8
	dc.w	$1FFE,$1FFE,$1FFE,$1FFE
	dc.w	$7FF8,$7FF8,$7FF8,$7FF8
	dc.w	$7FF8,$7FF8,$7FF8,$7FF8
	dc.w	$03F8,$03F8,$03F8,$03F8
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$3FFC,$3FFC,$3FFC,$3FFC
	dc.w	$FE00,$FE00,$FE00,$FE00
	dc.w	$007F,$007F,$007F,$007F
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$003E,$003E,$003E,$003E
	dc.w	$0FF0,$0FF0,$0FF0,$0FF0
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$7C7C,$7C7C,$7C7C,$7C7C
	dc.w	$01F0,$01F0,$01F0,$01F0
	dc.w	$03F0,$03F0,$03F0,$03F0
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$07FE,$07FE,$07FE,$07FE
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$7FF8,$7FF8,$7FF8,$7FF8
	dc.w	$07F0,$07F0,$07F0,$07F0
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$0FF8,$0FF8,$0FF8,$0FF8
	dc.w	$FE00,$FE00,$FE00,$FE00
	dc.w	$007F,$007F,$007F,$007F
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$1FF0,$1FF0,$1FF0,$1FF0
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$1FE0,$1FE0,$1FE0,$1FE0
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$7EFC,$7EFC,$7EFC,$7EFC
	dc.w	$01F0,$01F0,$01F0,$01F0
	dc.w	$07E0,$07E0,$07E0,$07E0
	dc.w	$007C,$007C,$007C,$007C
	dc.w	$007C,$007C,$007C,$007C
	dc.w	$007C,$007C,$007C,$007C
	dc.w	$7C7C,$7C7C,$7C7C,$7C7C
	dc.w	$0FE0,$0FE0,$0FE0,$0FE0
	dc.w	$7C7C,$7C7C,$7C7C,$7C7C
	dc.w	$01F8,$01F8,$01F8,$01F8
	dc.w	$FF00,$FF00,$FF00,$FF00
	dc.w	$00FF,$00FF,$00FF,$00FF
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$1FF0,$1FF0,$1FF0,$1FF0
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$3FFE,$3FFE,$3FFE,$3FFE
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$01F0,$01F0,$01F0,$01F0
	dc.w	$0FC0,$0FC0,$0FC0,$0FC0
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$007C,$007C,$007C,$007C
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$1FC0,$1FC0,$1FC0,$1FC0
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$03F0,$03F0,$03F0,$03F0
	dc.w	$7FC0,$7FC0,$7FC0,$7FC0
	dc.w	$03FE,$03FE,$03FE,$03FE
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$0FE0,$0FE0,$0FE0,$0FE0
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$01F0,$01F0,$01F0,$01F0
	dc.w	$1FFE,$1FFE,$1FFE,$1FFE
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$007C,$007C,$007C,$007C
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$3F80,$3F80,$3F80,$3F80
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$03F0,$03F0,$03F0,$03F0
	dc.w	$7FC0,$7FC0,$7FC0,$7FC0
	dc.w	$03FE,$03FE,$03FE,$03FE
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$0FE0,$0FE0,$0FE0,$0FE0
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$FEFE,$FEFE,$FEFE,$FEFE
	dc.w	$7FFC,$7FFC,$7FFC,$7FFC
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$1FF0,$1FF0,$1FF0,$1FF0
	dc.w	$01F0,$01F0,$01F0,$01F0
	dc.w	$3FFE,$3FFE,$3FFE,$3FFE
	dc.w	$7FF8,$7FF8,$7FF8,$7FF8
	dc.w	$007C,$007C,$007C,$007C
	dc.w	$7FF8,$7FF8,$7FF8,$7FF8
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$3F00,$3F00,$3F00,$3F00
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$07E0,$07E0,$07E0,$07E0
	dc.w	$3FC0,$3FC0,$3FC0,$3FC0
	dc.w	$03FC,$03FC,$03FC,$03FC
	dc.w	$1FF0,$1FF0,$1FF0,$1FF0
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$FC7E,$FC7E,$FC7E,$FC7E
	dc.w	$3FF8,$3FF8,$3FF8,$3FF8
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0FE0,$0FE0,$0FE0,$0FE0
	dc.w	$01F0,$01F0,$01F0,$01F0
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$7FF0,$7FF0,$7FF0,$7FF0
	dc.w	$007C,$007C,$007C,$007C
	dc.w	$7FF0,$7FF0,$7FF0,$7FF0
	dc.w	$1FF0,$1FF0,$1FF0,$1FF0
	dc.w	$3F00,$3F00,$3F00,$3F00
	dc.w	$1FF0,$1FF0,$1FF0,$1FF0
	dc.w	$07E0,$07E0,$07E0,$07E0
	dc.w	$1FC0,$1FC0,$1FC0,$1FC0
	dc.w	$03F8,$03F8,$03F8,$03F8
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$0380,$0380,$0380,$0380
	dc.w	$0FE0,$0FE0,$0FE0,$0FE0
	dc.w	$F83E,$F83E,$F83E,$F83E
	dc.w	$0FE0,$0FE0,$0FE0,$0FE0
	dc.w	$FFFE,$FFFE,$FFFE,$FFFE
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$01F0,$01F0,$01F0,$01F0
	dc.w	$7FFE,$7FFE,$7FFE,$7FFE
	dc.w	$7FC0,$7FC0,$7FC0,$7FC0
	dc.w	$007C,$007C,$007C,$007C
	dc.w	$7FC0,$7FC0,$7FC0,$7FC0
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$3F00,$3F00,$3F00,$3F00
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$0FC0,$0FC0,$0FC0,$0FC0
	dc.w	$07C0,$07C0,$07C0,$07C0
	dc.w	$03E0,$03E0,$03E0,$03E0
	DCB.W     13520,0 
REBOND_S:
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0980,$0000,$09C0
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0680,$0000,$0C40
	dc.w	$0000,$0700,$0000,$0740
	dc.w	$0000,$0780,$0000,$07C0
	dc.w	$0000,$0800,$0000,$0840
	dc.w	$0000,$0880,$0000,$08C0
	dc.w	$0000,$0900,$0000,$0940
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0000
	dc.w	$0000,$0040,$0000,$0080
	dc.w	$0000,$00C0,$0000,$0100
	dc.w	$0000,$0140,$0000,$0180
	dc.w	$0000,$01C0,$0000,$0200
	dc.w	$0000,$0240,$0000,$0280
	dc.w	$0000,$02C0,$0000,$0300
	dc.w	$0000,$0340,$0000,$0380
	dc.w	$0000,$03C0,$0000,$0400
	dc.w	$0000,$0440,$0000,$0480
	dc.w	$0000,$04C0,$0000,$0500
	dc.w	$0000,$0540,$0000,$0580
	dc.w	$0000,$05C0,$0000,$0600
	dc.w	$0000,$0640,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40,$0000,$0C40
	dc.w	$0000,$0C40
PAS_CAR:
	dc.w	$0000,$0010 
*
COMPTEUR:
	dc.b	200-1,00
PTR_PAL_RASTER:
	DC.L      PAL_RASTER 
COUNT_1:DCB.W     2,0 
COUNT_2:DCB.W     2,0 
COURBE:
	dc.w	$6363,$6363,$6262,$6160
	dc.w	$5F5E,$5D5B,$5A58,$5655
	dc.w	$5351,$4F4C,$4A48,$4543
	dc.w	$413E,$3B39,$3634,$312E
	dc.w	$2C29,$2724,$221F,$1D1A
	dc.w	$1816,$1412,$100E,$0C0A
	dc.w	$0907,$0605,$0403,$0201
	dc.w	$0100,$0000,$0000,$0000
	dc.w	$0101,$0203,$0405,$0608
	dc.w	$090B,$0D0E,$1012,$1417
	dc.w	$191B,$1E20,$2225,$282A
	dc.w	$2D2F,$3235,$373A,$3C3F
	dc.w	$4144,$4649,$4B4D,$4F51
	dc.w	$5355,$5759,$5A5C,$5D5E
	dc.w	$5F60,$6162,$6263,$6363
	dc.w	$6363,$6363,$6363,$6262
	dc.w	$6161,$605F,$5F5E,$5D5C
	dc.w	$5B5A,$5958,$5756,$5453
	dc.w	$5251,$4F4E,$4D4C,$4A49
	dc.w	$4846,$4544,$4341,$403F
	dc.w	$3E3D,$3C3B,$3A39,$3837
	dc.w	$3635,$3534,$3433,$3332
	dc.w	$3232,$3232,$3232,$3232
	dc.w	$3232,$3333,$3434,$3536
	dc.w	$3637,$3839,$3A3B,$3C3D
	dc.w	$3E3F,$4142,$4344,$4647
	dc.w	$4849,$4B4C,$4D4F,$5051
	dc.w	$5254,$5556,$5758,$595A
	dc.w	$5B5C,$5D5E,$5F60,$6061
	dc.w	$6162,$6263,$6363,$63FF
*
PAL_RASTER:
* violet
;	dc.w	$0101,$0000,$0101,$0101
*	dc.w	$0212,$0101,$0212,$0212
*	dc.w	$0323,$0212,$0323,$0323
*	dc.w	$0434,$0323,$0434,$0434
	dc.w	$0545,$0434,$0545,$0545
	dc.w	$0656,$0545,$0656,$0656
	dc.w	$0767,$0656,$0767,$0767
	dc.w	$0656,$0767,$0656,$0656
	dc.w	$0545,$0656,$0545,$0545
	dc.w	$0434,$0545,$0434,$0434
	dc.w	$0323,$0434,$0323,$0323
	dc.w	$0212,$0323,$0212,$0212
	dc.w	$0101,$0212,$0101,$0101
;	dc.w	$0000,$0101,$0101,$0000
* bleu fonce
	dc.w	$0001,$0012,$0001,$0012
	dc.w	$0012,$0123,$0012,$0123
	dc.w	$0123,$0234,$0123,$0234
	dc.w	$0234,$0345,$0234,$0345
	dc.w	$0345,$0456,$0345,$0456
	dc.w	$0456,$0567,$0456,$0567
	dc.w	$0567,$0677,$0567,$0677
	dc.w	$0677,$0567,$0677,$0567
	dc.w	$0567,$0456,$0567,$0456
	dc.w	$0456,$0345,$0456,$0345
	dc.w	$0345,$0234,$0345,$0234
	dc.w	$0234,$0123,$0234,$0123
	dc.w	$0123,$0012,$0123,$0012
	dc.w	$0012,$0001,$0012,$0001
* bleu clair
	dc.w	$0010,$0011,$0022,$0011
	dc.w	$0022,$0022,$0133,$0022
	dc.w	$0133,$0133,$0244,$0133
	dc.w	$0244,$0244,$0355,$0244
	dc.w	$0355,$0355,$0466,$0355
	dc.w	$0466,$0466,$0577,$0466
	dc.w	$0577,$0577,$0677,$0577
	dc.w	$0677,$0677,$0577,$0677
	dc.w	$0577,$0577,$0466,$0577
	dc.w	$0466,$0466,$0355,$0466
	dc.w	$0355,$0355,$0244,$0355
	dc.w	$0244,$0244,$0133,$0244
	dc.w	$0133,$0133,$0022,$0133
	dc.w	$0022,$0022,$0011,$0022
	dc.w	$0011,$0011,$0100,$0000
* vert clair
add_v equ $0008
	dc.w	$0010,$0120,$0010,$0120
	dc.w	$0120+add_v,$0120+add_v,$0230+add_v,$0120
	dc.w	$0230+add_v,$0230+add_v,$0341+add_v,$0230
	dc.w	$0341+add_v,$0341+add_v,$0452+add_v,$0341
	dc.w	$0452+add_v,$0452+add_v,$0563+add_v,$0452
	dc.w	$0563+add_v,$0563+add_v,$0674+add_v,$0563
	dc.w	$0674+add_v,$0674+add_v,$0775+add_v,$0674
	dc.w	$0775+add_v,$0775+add_v,$0674+add_v,$0775
	dc.w	$0674+add_v,$0674+add_v,$0563+add_v,$0674
	dc.w	$0563+add_v,$0563+add_v,$0452+add_v,$0563
	dc.w	$0452+add_v,$0452+add_v,$0341+add_v,$0452
	dc.w	$0341+add_v,$0341+add_v,$0230+add_v,$0341
	dc.w	$0230+add_v,$0230+add_v,$0120+add_v,$0230
	dc.w	$0120+add_v,$0120+add_v,$0010+add_v,$0120
	dc.w	$0010+add_v,$0010+add_v,$0011,$0210
* marron clair
	dc.w	$0210,$0100,$0210,$0210
	dc.w	$0321,$0210,$0321,$0321
	dc.w	$0432,$0321,$0432,$0432
	dc.w	$0543,$0432,$0543,$0543
	dc.w	$0654,$0543,$0654,$0654
	dc.w	$0765,$0654,$0765,$0765
	dc.w	$0776,$0765,$0776,$0776
	dc.w	$0765,$0776,$0765,$0765
	dc.w	$0654,$0765,$0654,$0654
	dc.w	$0543,$0654,$0543,$0543
	dc.w	$0432,$0543,$0432,$0432
	dc.w	$0321,$0432,$0321,$0321
	dc.w	$0210,$0321,$0210,$0210
	dc.w	$0100,$0210,$0100,$0100
* magenta
	dc.w	$0100,$0200,$0200,$0311
	dc.w	$0200,$0311,$0311,$0422
	dc.w	$0311,$0422,$0422,$0533
	dc.w	$0422,$0533,$0533,$0644
	dc.w	$0533,$0644,$0644,$0755
	dc.w	$0644,$0755,$0755,$0766
	dc.w	$0755,$0766,$0766,$0755
	dc.w	$0766,$0755,$0755,$0644
	dc.w	$0755,$0644,$0644,$0533
	dc.w	$0644,$0533,$0533,$0422
	dc.w	$0533,$0422,$0422,$0311
	dc.w	$0422,$0311,$0311,$0200
	dc.w	$0311,$0200,$0200,$0100
	dc.w	$0200,$0100,$0100,$0100
*
PAL_ELITE_SILVER:
	dc.w	$0000,$0192,$092A,$02A3,$0A33,$033B,$0BB4,$044C
	dc.w	$0777,$0C55,$05DD,$0D66,$06EE,$0E77,$07FF,$04CC
LOGO_ELITE_SILVER:
	incbin	"ELITESIL.IMG"
	even
*
PalNoeXtra:
	dc.w	$0000,$0666,$0555,$0444,$0333,$0222,$0111,$00F0
	dc.w	$0766,$0655,$0544,$0667,$0556,$0445,$0777,$0FFF

LogoNoeXtra:
	incbin	"SUPPLEX0.IMG"
	even
* <

MUSIC:
	incbin	MISFIT9.MUS
	even

******************************************************************
	SECTION	BSS
******************************************************************

bss_start:

* < Full data here >
BUF_SCROL0:DS.W      1 
BUF_SCROL1:DS.B      3198
BUF_SCROL2:DS.B      3200
BUF_SCROL3:DS.B      3200
BUF_SCROL4:DS.B      3200
BUF_SCROL5:DS.B      640 
BUF_SCROL6:DS.B      640 
BUF_SCROL7:DS.B      640 
BUF_SCROL8:DS.B      640 

* <
Vsync:	ds.w	1
Save_stack:	ds.l	1

Save_all:
	ds.b	8	* Mfp : fa03.w -> fa19.w
	ds.b	4	* Mfp : fa1b.w -> fa21.w
	ds.b	4	* Video : f8201.w -> f820d.w

Save_rest:
	ds.l	1	* Autovector (HBL)
	ds.l	1	* Autovector (VBL)
	ds.l	1	* Timer D (USART timer)
	ds.l	1	* Timer C (200hz Clock)
	ds.l	1	* Keyboard/MIDI (ACIA) 
	ds.l	1	* Timer B (HBL)
	ds.l	1	* Timer A
	ds.l	1	* Output Bip Bop
Palette:
	ds.w	16	* Palette
mstart:	ds.l	1 * location memory adress

bss_end:

	SECTION	TEXT

	IFEQ	ERROR_SYS
************************************************
*                                              *
*               Error Routines                 *
*                Dbug 2/Next                   *
*                                              *
************************************************
INPUT_TRACE_ERROR:
	lea $8.w,a0                       ; Adresse de base des vecteurs (Erreur de Bus)
	lea liste_vecteurs,a1             ;
	moveq #10-1,d0                    ; On détourne toutes les erreur possibles...
.b_sauve_exceptions:
	move.l (a1)+,d1                   ; Adresse de la nouvelle routine
	move.l (a0)+,-4(a1)               ; Sauve l'ancienne
	move.l d1,-4(a0)                  ; Installe la mienne
	dbra d0,.b_sauve_exceptions
	rts

OUTPUT_TRACE_ERROR:
	lea $8.w,a0
	lea liste_vecteurs,a1
	moveq #10-1,d0
.restaure_illegal:
	move.l (a1)+,(a0)+
	dbra d0,.restaure_illegal
	rts

routine_bus:
	move.w #$070,d0
	bra.s execute_detournement
routine_adresse:
	move.w #$007,d0
	bra.s execute_detournement
routine_illegal:
	move.w #$700,d0
	bra.s execute_detournement
routine_div:
	move.w #$770,d0
	bra.s execute_detournement
routine_chk:
	move.w #$077,d0
	bra.s execute_detournement
routine_trapv:
	move.w #$777,d0
	bra.s execute_detournement
routine_viole:
	move.w #$707,d0
	bra.s execute_detournement
routine_trace:
	move.w #$333,d0
	bra.s execute_detournement
routine_line_a:
	move.w #$740,d0
	bra.s execute_detournement
routine_line_f:
	move.w #$474,d0
execute_detournement:
	move.w #$2700,sr                  ; Deux erreurs à suivre... non mais !

	move.w	#$0FF,d1
.loop:
	move.w d0,$ffff8240.w             ; Effet raster
	move.w #0,$ffff8240.w
	cmp.b #$3b,$fffffc02.w
	dbra d1,.loop

	pea SORTIE                        ; Put the return adress
	move.w #$2700,-(sp)               ; J'espère !!!...
	addq.l #2,2(sp)                   ; 24/6
	rte                               ; 20/5 => Total hors tempo = 78-> 80/20 nops

liste_vecteurs:
	dc.l routine_bus	Vert
	dc.l routine_adresse	Bleu
	dc.l routine_illegal	Rouge
	dc.l routine_div	Jaune
	dc.l routine_chk	Ciel
	dc.l routine_trapv	Blanc
	dc.l routine_viole	Violet
	dc.l routine_trace	Gris
	dc.l routine_line_a	Orange
	dc.l routine_line_f	Vert pale
	even
	ENDC

***************************************************************************
* Multi Atari Boot code.                                                  *
* If you have done an ST demo, use that boot to run it on these machines: *
*                                                                         *
* ST, STe, Mega-ST,TT,Falcon,CT60                                         *
*                                                                         *
* More info:                                                              *
* http://leonard.oxg.free.fr/articles/multi_atari/multi_atari.html        *
***************************************************************************

Multi_boot:
	sf $1fe.w
	move.l $5a0.w,d0
	beq noCookie
	move.l d0,a0
.loop:
	move.l (a0)+,d0
	beq noCookie
	cmp.l #'_MCH',d0
	beq.s .find
	cmp.l #'CT60',d0
	bne.s .skip

; CT60, switch off the cache
	pea (a0)

	lea bCT60(pc),a0
	st (a0)

	clr.w -(a7) ; param = 0 ( switch off all caches )
	move.w #5,-(a7) ; opcode
	move.w #160,-(a7)
	trap #14
	addq.w #6,a7
	move.l (a7)+,a0
.skip:
	addq.w #4,a0
	bra.s .loop

.find:
	move.w (a0)+,d7
	beq noCookie ; STF
	move.b d7,$1fe.w

	cmpi.w #1,d7
	bne.s .noSTE
	btst.b #4,1(a0)
	beq.s .noMegaSTE
	clr.b $ffff8e21.w ; 8Mhz MegaSTE

.noMegaSTE:
	bra noCookie

.noSTE:
; here TT or FALCON

; Always switch off the cache on these machines.
	move.b bCT60(pc),d0
	bne.s .noMovec

	moveq #0,d0
	dc.l $4e7b0002 ; movec d0,cacr ; switch off cache
.noMovec:

	cmpi.w #3,d7
	bne.s noCookie

; Here FALCON
	move.w #$59,-(a7) ;check monitortype (falcon)
	trap #14
	addq.l #2,a7
	lea rgb50(pc),a0
	subq.w #1,d0
	beq.s .setRegs
	subq.w #2,d0
	beq.s .setRegs
	lea vga50(pc),a0

.setRegs:
	move.l (a0)+,$ffff8282.w
	move.l (a0)+,$ffff8286.w
	move.l (a0)+,$ffff828a.w
	move.l (a0)+,$ffff82a2.w
	move.l (a0)+,$ffff82a6.w
	move.l (a0)+,$ffff82aa.w
	move.w (a0)+,$ffff820a.w
	move.w (a0)+,$ffff82c0.w
	move.w (a0)+,$ffff8266.w
	clr.b $ffff8260.w
	move.w (a0)+,$ffff82c2.w
	move.w (a0)+,$ffff8210.w

noCookie:

; Set res for all machines exept falcon or ct60
	cmpi.b #3,$1fe.w
	beq letsGo

	clr.w -(a7) ;set stlow (st/tt)
	moveq #-1,d0
	move.l d0,-(a7)
	move.l d0,-(a7)
	move.w #5,-(a7)
	trap #14
	lea 12(a7),a7

	cmpi.b #2,$1fe.w ; enough in case of TT
	beq.s letsGo

	move.w $468.w,d0
.vsync:
	cmp.w $468.w,d0
	beq.s .vsync

	move.b #2,$ffff820a.w
	clr.b $ffff8260.w

letsGo:
	IFEQ	ERROR_SYS
	bsr	INPUT_TRACE_ERROR
	ENDC
	rts

vga50:
	dc.l $170011
	dc.l $2020E
	dc.l $D0012
	dc.l $4EB04D1
	dc.l $3F00F5
	dc.l $41504E7
	dc.w $0200
	dc.w $186
	dc.w $0
	dc.w $5
	dc.w $50

rgb50:
	dc.l $300027
	dc.l $70229
	dc.l $1e002a
	dc.l $2710265
	dc.l $2f0081
	dc.l $211026b
	dc.w $0200
	dc.w $185
	dc.w $0
	dc.w $0
	dc.w $50

bCT60: dc.b 0
	even

******************************************************************
	END
******************************************************************
