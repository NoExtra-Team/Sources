***************************************
* // ELITE_0.PRG                   // *
***************************************
* // Asm Intro Code Atari ST v0.40 // *
* // by Zorro 2/NoExtra (26/08/11) // *
* // http://www.noextra-team.com/  // *
* // Hall of fame of supreme ST    // *
* // Debugger : Maartau            // *
***************************************
* // Original code : Zorro2        // *
* // Gfx logo      : Zorro2        // *
* // Gfx font      : Mister.A      // *
* // Music         : E.I.A.        // *
* // Release date  : 04/12/2008    // *
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
	movea.l	physique(pc),a6
	
  move.w	bitplane,d7	; d7 indique sur quel biplan on est.
  add.w	#$1,d7
  cmp.w	#$3,d7
  beq.s	.bitplane_0	; Bitplan 0?
  cmp.w	#$1,d7
  beq	.bitplane_1

.bitplane_2:
  move.w	d7,bitplane
  addq.l	#$2,a6

.bitplane_0:
  moveq.l	#$0,d7
  move.w	d7,bitplane
*  addq.l	#$0,a6
  
.bitplane_1:
  move.w	d7,bitplane
  addq.l	#$4,a6

	move.l	a6,screen

	BSR       EFFACE 
	BSR       EFFET3D
	
	bsr	Wait_vbl

	movea.l	physique(pc),a6
	
  move.w	bitplane,d7	; d7 indique sur quel biplan on est.
  add.w	#$1,d7
  cmp.w	#$3,d7
  beq.s	.bitplane_0_1	; Bitplan 0?
  cmp.w	#$1,d7
  beq	.bitplane_1_1

.bitplane_2_1:
  move.w	d7,bitplane
  addq.l	#$2,a6

.bitplane_0_1:
  moveq.l	#$0,d7
  move.w	d7,bitplane
*  addq.l	#$0,a6
  
.bitplane_1_1:
  move.w	d7,bitplane
  addq.l	#$4,a6

	move.l	a6,screen

	BSR       EFFACE 
	BSR       EFFET3D 

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

	moveq	#1,d0
	jsr	MUSIC+0			; init music

	movea.l	physique(pc),a1
	adda.l	#160*76,a1
	movea.l	#LogoNoeXtra,a0
	move.l	#160*35/4-1,d0
	move.l	(a0)+,(a1)+
	dbf	d0,*-2

	lea	Vbl0(pc),a0
	move.l	a0,$70.w

	lea	PalNoeXtra,a2
	bsr	fadeon	

	lea	PalNoeXtra,a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

	BSR	INIT3D	

	bsr	fadeoff

	move.l	physique(pc),a0
	move.w  #160*200/4-1,d7
	move.l  #PATTERN,(a0)+
	dbf	    d7,*-6

	bsr print_text

	lea	Vbl(pc),a0                   ; Launch VBL
	move.l	a0,$70.w

	lea	Default_palette(pc),a0       ; Put palette
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

	jsr 	(MUSIC+8)			; call music
	
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

	IFEQ	TOPBOTTOM_BORDER
	;move.l	a0,-(a7)
	clr.b	(tacr).w                   ; Stop timer A
	lea	topbord(pc),a0               ; Launch HBL
	move.l	a0,$134.w                ; Timer A vector
	move.b	#99,(tadr).w             ; Countdown value for timer A
	move.b	#4,(tacr).w              ; Delay mode, clock divided by 50
	;move.l	(a7)+,a0
	ENDC

	IFEQ	NO_BORDER
	clr.b	$fffffa1b.w
	move.l	#timerb,$120.w
	move.b	#1,$fffffa21.w
	move.b	#8,$fffffa1b.w
	ENDC

	jsr 	(MUSIC+8)                  ; Play SNDH music

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
***************************************************************
*                                                             *
*             < Here is the lower border rout >               *
*                                                             *
***************************************************************
timerb:
	move.w	#$34,$ffff8240.w
	clr.b	$fffffa1b.w
	move.l	#tim2,$120.w
	move.b	#1,$fffffa21.w
	move.b	#8,$fffffa1b.w	
	rte

tim2:
	move.w	#$23,$ffff8240.w
	clr.b	$fffffa1b.w
	move.l	#tim3,$120.w
	move.b	#1,$fffffa21.w
	move.b	#8,$fffffa1b.w	
	rte

tim3:
	move.w	#$12,$ffff8240.w
	clr.b	$fffffa1b.w
	move.l	#tim4,$120.w
	move.b	#193,$fffffa21.w
	move.b	#8,$fffffa1b.w
	rte

tim4:
	move.w	#$23,$ffff8240.w
	clr.b	$fffffa1b.w
	move.l	#tim5,$120.w
	move.b	#1,$fffffa21.w
	move.b	#8,$fffffa1b.w
	rte

tim5:
	move.w	#$34,$ffff8240.w
	move.l	#tim6,$120.w
	rte

tim6:
	move.b	#0,$ffff8240.w
	clr.b	$fffffa1b.w
	bclr	#0,$fffffa0f.w
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
	sf	$fffffa21.w
	sf	$fffffa1b.w
	move.l	#timerb,$120.w
	bset	#0,$fffffa07.w	* Timer B on
	bset	#0,$fffffa13.w	* Timer B on
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
	
************************************************
*                TEXT ROUTINE                  *
*           Using C64 font 8*8 1 plan          *
*          Done by AVENGER/ATARI LEGEND        *
************************************************
no		equ	0
yes		equ	1
MED		equ	1
LOW		equ	0

CHARS		equ	40	;chars per line, 80=for med res, 40 for low res
LINES		equ	33	;33 for 8x8 font, 45 with 6x6 font 
FONTSIZE	equ	8	;8=8x8, 6=6x6 font
SHIFTSIZE	equ	4	;2=MED RESOLUTION, 4=FOR LOW RESOLUTION
RESOLUTION	equ	LOW	;if no, then its low resolution
C64_FNT		equ	yes	;c64 font files works directly :)
ATARI_FNT	equ	no	;

print_text:
		clr.w	x_curs
		clr.l	x_offset
		clr.l	y_offset
		lea     message(pc),a2
new_char: 
		bsr     _x_conversion

		moveq   #0,d0    
		move.b  (a2)+,d0	;if zero, stop routine
		cmp.b	#27,d0
		beq	esc_E
		cmp.b	#0,d0
		beq	LF
		cmp.b	#$ff,d0
		bne.s   process_char
                rts
process_char:
		cmp.b	#$60,d0	 	;if its not a  capital letter, ignore it
		bhs.s	new_char

		lea     fonts(pc),a1	

* >>>> ATARI ROUTINE >>>>
		ifne	ATARI_FNT		
		sub.w	#$20,d0
		mulu    #FONTSIZE,d0
		endc
* <<<< ATARI ROUTINE <<<<

* >>>> C64 routine >>>>	;faster than earlier, no loops
		ifne	C64_FNT
		btst	#6,d0
		bne.s	_letter	
		and.w	#$1f,d0		
		adda.l	#$100,a1	;special chars starts at +$100
		bra	_mul
_letter:	subi.w	#$40,d0
_mul:		mulu	#FONTSIZE,d0
		adda.l	#2,a1		;skip the header
		endc
* <<<< C64 routine <<<<

		adda.w  d0,a1

		movea.l physique(pc),a0
		lea	2(a0),a0
		adda.l  y_offset,a0
		adda.l  x_offset,a0

		movea.l physique+4(pc),a3
		lea	2(a3),a3
		adda.l  y_offset,a3
		adda.l  x_offset,a3

		rept	FONTSIZE
		move.b  (a1),(a0)	
		move.b  (a1)+,(a3)	
		lea	160(a0),a0
		lea	160(a3),a3
		endr

		addq.w  #1,x_curs           
		cmpi.w  #CHARS,x_curs      ;79 for MED res
		bls     new_char
		move.w  #CHARS,x_curs	   ;79 for MED res
		bra   	new_char

LF:
		clr.w	x_curs				;back to first char
		addi.l  #FONTSIZE*160,y_offset		;linefeed when reached ',0'
		cmpi.l  #LINES*FONTSIZE*160,y_offset
		bls     new_char
		move.l  #LINES*FONTSIZE*160,y_offset
		bra     new_char

esc_E:
		move.b  (a2)+,d0
		cmpi.b  #"E",d0 
		bne.s   not_esc_E
		bsr.s   cls_screen
		clr.w   x_curs
		clr.l   y_offset
not_esc_E:	bra     new_char

_x_conversion:
		move.w	x_curs(pc),d0
		and.l	#$ffff,d0
		btst	#0,d0
		beq.s	_even
		subq.w	#1,d0
		mulu	#SHIFTSIZE,d0		;2=med res, 4=low
		addq.w	#1,d0
		bra	_done_conv				
_even:		mulu	#SHIFTSIZE,d0		;2=med res, 4=low
_done_conv:	move.l	d0,x_offset
		rts

cls_screen:
	movea.l physique(pc),a0
  move.l  #160*200/4-1,d7	;size of the whole screen
cls:
	clr.l   (a0)
  addq.l  #4,a0
  dbra    d7,cls
  rts

************************************************
*      3D ELITE ripped from BBS Intro          *
*          New version by Zorro 2 :            *
*        - Special CLS 1 plan routs            *
*        - Use plans 2,4 and 6 very fast       *
*        - Use simply 2 screens                *
************************************************

EFFACE:MOVEQ     #0,D0 
      MOVE.W    #$63,D1 
.loop:MOVE.W    D0,24(A6) 
      MOVE.W    D0,32(A6) 
      MOVE.W    D0,40(A6) 
      MOVE.W    D0,48(A6) 
      MOVE.W    D0,56(A6) 
      MOVE.W    D0,64(A6) 
      MOVE.W    D0,72(A6) 
      MOVE.W    D0,80(A6) 
      MOVE.W    D0,88(A6) 
      MOVE.W    D0,96(A6) 
      MOVE.W    D0,104(A6)
      MOVE.W    D0,112(A6)
      MOVE.W    D0,120(A6)
      MOVE.W    D0,128(A6)
      MOVE.W    D0,136(A6)
      MOVE.W    D0,144(A6)
      MOVE.W    D0,152(A6)
      MOVE.W    D0,160(A6)
      MOVE.W    D0,168(A6)
      MOVE.W    D0,176(A6)
      MOVE.W    D0,184(A6)
      MOVE.W    D0,192(A6)
      MOVE.W    D0,200(A6)
      MOVE.W    D0,208(A6)
      MOVE.W    D0,216(A6)
      MOVE.W    D0,224(A6)
      MOVE.W    D0,232(A6)
      MOVE.W    D0,240(A6)
      MOVE.W    D0,248(A6)
      MOVE.W    D0,256(A6)
      MOVE.W    D0,264(A6)
      MOVE.W    D0,272(A6)
      MOVE.W    D0,280(A6)
      MOVE.W    D0,288(A6)
      LEA       320(A6),A6
      DBF       D1,.loop
      RTS 

EFFET3D:MOVEA.L   PTR_COORD,A0
      MOVE.W    (A0)+,D0
      ADDQ.W    #1,D0 
      ADD.W     D0,D0 
      MOVE.W    D0,D1 
      ADD.W     D1,D1 
      ADD.W     D1,D0 
      ADDA.W    D0,A0 
      MOVEA.L   PTR_BUFFER,A1
      MOVE.W    (A0)+,D0
      LEA       L0039,A2
      MOVE.L    screen,(A2)+ 
      MOVEA.L   A2,A3 
L001C:MOVE.W    (A0)+,D1
      MOVE.W    D1,(A2)+
      ANDI.W    #$F,D1
L001D:MOVE.W    (A0)+,D2
      ADD.W     D2,D2 
      ADD.W     D2,D2 
      MOVE.L    0(A1,D2.W),(A2)+
      DBF       D1,L001D
      MOVEM.L   A3/A0-A1/D0,-(A7) 
      BSR       L0037 
      MOVEM.L   (A7)+,A3/A0-A1/D0 
      MOVEA.L   A3,A2 
      DBF       D0,L001C
      MOVE.L    PTR_BUFFER,D0
      ADDI.L    #$9C,D0 	*	9c = 156
      CMP.L     #END_PTR_BUFFER,D0 
      BLT.S     L001E 
      MOVE.L    #BUFFER,D0 
L001E:MOVE.L    D0,PTR_BUFFER
      RTS 

INIT3D:
      LEA       $E0000,A0 
      BSR       L0038 
      BSR       MAKE_BUFFER 
      MOVE.L    #BUFFER,PTR_BUFFER
      RTS
	
MAKE_BUFFER:
      MOVE.W    #$1FF,D0	*	1ff = 511
      MOVE.L    #BUFFER,PTR_BUFFER
.loop:MOVE.L    D0,-(A7)
      BSR.s     L0018 
      BSR.s     L0017 
      BSR       L0019 
      MOVE.L    (A7)+,D0
      DBF       D0,.loop
      RTS 

L0017:MOVEM.W   SWAP0,D0-D2 
      MOVEM.W   SEQUENCE,D3-D5 
      MOVE.W    #$3FF,D6
      ADD.W     D3,D0 
      ADD.W     D4,D1 
      ADD.W     D5,D2 
      AND.W     D6,D0 
      AND.W     D6,D1 
      AND.W     D6,D2 
      MOVEM.W   D0-D2,SWAP0 
      RTS 
      
L0018:LEA       COSINUS,A0
      LEA       512(A0),A1
      LEA       BUFFER_COS,A2
      MOVEM.W   SWAP0,D0-D2 
      ADD.W     D0,D0 
      ADD.W     D1,D1 
      ADD.W     D2,D2 
      MOVE.W    0(A1,D2.W),D5 
      MOVE.W    0(A0,D2.W),D4 
      MOVE.W    0(A1,D1.W),D3 
      MOVE.W    0(A0,D1.W),D2 
      MOVE.W    0(A1,D0.W),D1 
      MOVE.W    0(A0,D0.W),D0 
      MOVE.W    D3,D6 
      MULS      D5,D6 
      MOVEA.L   D6,A3 
      MOVE.W    D0,D7 
      MULS      D2,D7 
      ADD.L     D7,D7 
      SWAP      D7
      MOVEA.W   D7,A4 
      MULS      D4,D7 
      SUB.L     D7,D6 
      ADD.L     D6,D6 
      SWAP      D6
      MOVE.W    D6,(A2)+
      MOVE.W    D1,D6 
      MULS      D4,D6 
      ADD.L     D6,D6 
      SWAP      D6
      NEG.W     D6
      MOVE.W    D6,(A2)+
      MOVE.W    D2,D6 
      MULS      D5,D6 
      MOVE.W    D3,D7 
      MULS      D4,D7 
      MOVEA.L   D7,A5 
      ADD.L     D7,D7 
      SWAP      D7
      MULS      D0,D7 
      ADD.L     D7,D6 
      ADD.L     D6,D6 
      SWAP      D6
      NEG.W     D6
      MOVE.W    A4,D6 
      MULS      D5,D6 
      ADD.L     A5,D6 
      ADD.L     D6,D6 
      SWAP      D6
      MOVE.W    D6,(A2)+
      MOVE.W    D5,D6 
      MULS      D1,D6 
      ADD.L     D6,D6 
      SWAP      D6
      MOVE.W    D6,(A2)+
      MOVE.L    A3,D6 
      ADD.L     D6,D6 
      SWAP      D6
      MULS      D0,D6 
      MOVE.W    D2,D7 
      MULS      D4,D7 
      SUB.L     D7,D6 
      ADD.L     D6,D6 
      SWAP      D6
      MULS      D1,D2 
      ADD.L     D2,D2 
      SWAP      D2
      MOVE.W    D2,(A2)+
      NEG.W     D0
      MOVE.W    D0,(A2)+
      MULS      D3,D1 
      ADD.L     D1,D1 
      SWAP      D1
      RTS 
      
L0019:MOVEA.L   PTR_COORD,A0
      MOVEA.L   PTR_BUFFER,A1
      LEA       BUFFER_COS,A3
      MOVE.W    (A0)+,D0
.loop:MOVEA.L   A3,A2 
      MOVEM.W   (A0),D1-D3
      MULS      (A2)+,D1
      MULS      (A2)+,D2
      ADD.L     D2,D1 
      MOVEM.W   (A0),D2-D4
      MULS      (A2)+,D2
      MULS      (A2)+,D3
      ADD.L     D3,D2 
      MOVEM.W   (A0)+,D3-D5 
      MULS      (A2)+,D3
      MULS      (A2)+,D4
      ADD.L     D4,D3 
      ADD.L     D3,D3 
      SWAP      D3
      ASR.L     #7,D1 
      ASR.L     #7,D2 
      ADD.W     COEFF_ZOOM,D3
      DIVS      D3,D1 
      DIVS      D3,D2 
      ADDI.W    #160,D1 	* pos X initiale
      ADDI.W    #100,D2		* pos Y initiale
      MOVE.W    D1,(A1)+	* point X
      MOVE.W    D2,(A1)+	* point Y
      DBF       D0,.loop
      MOVE.L    A1,PTR_BUFFER
      RTS 

SEQUENCE:
	dc.w	$4    * X
	dc.w	$8   * Y
	dc.w	$FFFA * Z
SWAP0:
	dcb.w	3,0
COEFF_ZOOM:
	dc.w	$0096+60
BUFFER_COS:
	DCB.W     521,$0 
PTR_COORD:
	dc.l	COORD
COORD:	; 39 points au total
*      NUMERO,  X  ,  Y
	dc.w	$0026,$FFB0,$FFF6  * 1
	dc.w	$0000,$FFC4,$FFEC  * 2
	dc.w	$0000,$FFC4,$FFF6  * 3
	dc.w	$0000,$FFB0,$FFFB  * 4
	dc.w	$0000,$FFBF,$0000  * 5
	dc.w	$0000,$FFB0,$0005  * 6
	dc.w	$0000,$FFB0,$000A  * 7
	dc.w	$0000,$FFC4,$000A  * 8
	dc.w	$0000,$FFC4,$0014  * 9
	dc.w	$0000,$FFCE,$FFEC  * 10
	dc.w	$0000,$FFD8,$FFEC  * 11
	dc.w	$0000,$FFD8,$0014  * 12
	dc.w	$0000,$FFCE,$0014  * 13
	dc.w	$0000,$FFDD,$0014  * 14
	dc.w	$0000,$FFE7,$000A  * 15
	dc.w	$0000,$FFE7,$0014  * 16
	dc.w	$0000,$FFF1,$FFEC  * 17
	dc.w	$0000,$FFFB,$FFEC  * 18
	dc.w	$0000,$FFFB,$0014  * 19
	dc.w	$0000,$FFF1,$0014  * 20
	dc.w	$0000,$0005,$FFEC  * 21
	dc.w	$0000,$000F,$FFEC  * 22
	dc.w	$0000,$0005,$FFF6  * 23
	dc.w	$0000,$0014,$FFEC  * 24
	dc.w	$0000,$001E,$FFEC  * 25
	dc.w	$0000,$001E,$0014  * 26
	dc.w	$0000,$0014,$0014  * 27
	dc.w	$0000,$0023,$FFEC  * 28
	dc.w	$0000,$002D,$FFEC  * 29
	dc.w	$0000,$002D,$FFF6  * 30
	dc.w	$0000,$0037,$FFF6  * 31
	dc.w	$0000,$004B,$FFEC  * 32
	dc.w	$0000,$004B,$FFF6  * 33
	dc.w	$0000,$0037,$FFFB  * 34
	dc.w	$0000,$0046,$0000  * 35
	dc.w	$0000,$0037,$0005  * 36
	dc.w	$0000,$0037,$000A  * 37
	dc.w	$0000,$004B,$000A  * 38
	dc.w	$0000,$004B,$0014  * 39
POSITION:
	dc.w	$0000,$0017,$0002
	dc.w	$0000,$0001,$0002,$0002
	dc.w	$0003,$0004,$0005,$0002
	dc.w	$0006,$0007,$0008,$0003
	dc.w	$0009,$000A,$000B,$000C
	dc.w	$0002,$000D,$000E,$000F
	dc.w	$0003,$0010,$0011,$0012
	dc.w	$0013,$0002,$0014,$0015
	dc.w	$0016,$0003,$0017,$0018
	dc.w	$0019,$001A,$0002,$001B
	dc.w	$001C,$001D,$0002,$001E
	dc.w	$001F,$0020,$0002,$0021
	dc.w	$0022,$0023,$0002,$0024
	dc.w	$0025,$0026,$0002,$0002
	dc.w	$0001,$0000,$0002,$0005
	dc.w	$0004,$0003,$0002,$0008
	dc.w	$0007,$0006,$0003,$000C
	dc.w	$000B,$000A,$0009,$0002
	dc.w	$000F,$000E,$000D,$0003
	dc.w	$0013,$0012,$0011,$0010
	dc.w	$0002,$0016,$0015,$0014
	dc.w	$0003,$001A,$0019,$0018
	dc.w	$0017,$0002,$001D,$001C
	dc.w	$001B,$0002,$0020,$001F
	dc.w	$001E,$0002,$0023,$0022
	dc.w	$0021,$0002,$0026,$0025
	dc.w	$0024
COSINUS:
	dc.w	$0000,$00C9,$0192,$025B
	dc.w	$0324,$03ED,$04B6,$057E
	dc.w	$0647,$0710,$07D9,$08A1
	dc.w	$096A,$0A32,$0AFB,$0BC3
	dc.w	$0C8B,$0D53,$0E1B,$0EE3
	dc.w	$0FAB,$1072,$1139,$1200
	dc.w	$12C7,$138E,$1455,$151B
	dc.w	$15E1,$16A7,$176D,$1833
	dc.w	$18F8,$19BD,$1A82,$1B46
	dc.w	$1C0B,$1CCF,$1D93,$1E56
	dc.w	$1F19,$1FDC,$209F,$2161
	dc.w	$2223,$22E4,$23A6,$2467
	dc.w	$2527,$25E7,$26A7,$2767
	dc.w	$2826,$28E5,$29A3,$2A61
	dc.w	$2B1E,$2BDB,$2C98,$2D54
	dc.w	$2E10,$2ECC,$2F86,$3041
	dc.w	$30FB,$31B4,$326D,$3326
	dc.w	$33DE,$3496,$354D,$3603
	dc.w	$36B9,$376F,$3824,$38D8
	dc.w	$398C,$3A3F,$3AF2,$3BA4
	dc.w	$3C56,$3D07,$3DB7,$3E67
	dc.w	$3F16,$3FC5,$4073,$4120
	dc.w	$41CD,$4279,$4325,$43D0
	dc.w	$447A,$4523,$45CC,$4674
	dc.w	$471C,$47C3,$4869,$490E
	dc.w	$49B3,$4A57,$4AFA,$4B9D
	dc.w	$4C3F,$4CE0,$4D80,$4E20
	dc.w	$4EBF,$4F5D,$4FFA,$5097
	dc.w	$5133,$51CE,$5268,$5301
	dc.w	$539A,$5432,$54C9,$555F
	dc.w	$55F4,$5689,$571D,$57B0
	dc.w	$5842,$58D3,$5963,$59F3
	dc.w	$5A81,$5B0F,$5B9C,$5C28
	dc.w	$5CB3,$5D3D,$5DC6,$5E4F
	dc.w	$5ED6,$5F5D,$5FE2,$6067
	dc.w	$60EB,$616E,$61F0,$6271
	dc.w	$62F1,$6370,$63EE,$646B
	dc.w	$64E7,$6562,$65DD,$6656
	dc.w	$66CE,$6745,$67BC,$6831
	dc.w	$68A5,$6919,$698B,$69FC
	dc.w	$6A6C,$6ADB,$6B4A,$6BB7
	dc.w	$6C23,$6C8E,$6CF8,$6D61
	dc.w	$6DC9,$6E30,$6E95,$6EFA
	dc.w	$6F5E,$6FC0,$7022,$7082
	dc.w	$70E1,$7140,$719D,$71F9
	dc.w	$7254,$72AE,$7306,$735E
	dc.w	$73B5,$740A,$745E,$74B1
	dc.w	$7503,$7554,$75A4,$75F3
	dc.w	$7640,$768D,$76D8,$7722
	dc.w	$776B,$77B3,$77F9,$783F
	dc.w	$7883,$78C6,$7908,$7949
	dc.w	$7989,$79C7,$7A04,$7A41
	dc.w	$7A7C,$7AB5,$7AEE,$7B25
	dc.w	$7B5C,$7B91,$7BC4,$7BF7
	dc.w	$7C29,$7C59,$7C88,$7CB6
	dc.w	$7CE2,$7D0E,$7D38,$7D61
	dc.w	$7D89,$7DB0,$7DD5,$7DF9
	dc.w	$7E1C,$7E3E,$7E5E,$7E7E
	dc.w	$7E9C,$7EB9,$7ED4,$7EEF
	dc.w	$7F08,$7F20,$7F37,$7F4C
	dc.w	$7F61,$7F74,$7F86,$7F96
	dc.w	$7FA6,$7FB4,$7FC1,$7FCD
	dc.w	$7FD7,$7FE0,$7FE8,$7FEF
	dc.w	$7FF5,$7FF9,$7FFC,$7FFE
	dc.w	$7FFF,$7FFE,$7FFC,$7FF9
	dc.w	$7FF5,$7FEF,$7FE8,$7FE0
	dc.w	$7FD7,$7FCD,$7FC1,$7FB4
	dc.w	$7FA6,$7F96,$7F86,$7F74
	dc.w	$7F61,$7F4C,$7F37,$7F20
	dc.w	$7F08,$7EEF,$7ED4,$7EB9
	dc.w	$7E9C,$7E7E,$7E5E,$7E3E
	dc.w	$7E1C,$7DF9,$7DD5,$7DB0
	dc.w	$7D89,$7D61,$7D38,$7D0E
	dc.w	$7CE2,$7CB6,$7C88,$7C59
	dc.w	$7C29,$7BF7,$7BC4,$7B91
	dc.w	$7B5C,$7B25,$7AEE,$7AB5
	dc.w	$7A7C,$7A41,$7A04,$79C7
	dc.w	$7989,$7949,$7908,$78C6
	dc.w	$7883,$783F,$77F9,$77B3
	dc.w	$776B,$7722,$76D8,$768D
	dc.w	$7640,$75F3,$75A4,$7554
	dc.w	$7503,$74B1,$745E,$740A
	dc.w	$73B5,$735E,$7306,$72AE
	dc.w	$7254,$71F9,$719D,$7140
	dc.w	$70E1,$7082,$7022,$6FC0
	dc.w	$6F5E,$6EFA,$6E95,$6E30
	dc.w	$6DC9,$6D61,$6CF8,$6C8E
	dc.w	$6C23,$6BB7,$6B4A,$6ADB
	dc.w	$6A6C,$69FC,$698B,$6919
	dc.w	$68A5,$6831,$67BC,$6745
	dc.w	$66CE,$6656,$65DD,$6562
	dc.w	$64E7,$646B,$63EE,$6370
	dc.w	$62F1,$6271,$61F0,$616E
	dc.w	$60EB,$6067,$5FE2,$5F5D
	dc.w	$5ED6,$5E4F,$5DC6,$5D3D
	dc.w	$5CB3,$5C28,$5B9C,$5B0F
	dc.w	$5A81,$59F3,$5963,$58D3
	dc.w	$5842,$57B0,$571D,$5689
	dc.w	$55F4,$555F,$54C9,$5432
	dc.w	$539A,$5301,$5268,$51CE
	dc.w	$5133,$5097,$4FFA,$4F5D
	dc.w	$4EBF,$4E20,$4D80,$4CE0
	dc.w	$4C3F,$4B9D,$4AFA,$4A57
	dc.w	$49B3,$490E,$4869,$47C3
	dc.w	$471C,$4674,$45CC,$4523
	dc.w	$447A,$43D0,$4325,$4279
	dc.w	$41CD,$4120,$4073,$3FC5
	dc.w	$3F16,$3E67,$3DB7,$3D07
	dc.w	$3C56,$3BA4,$3AF2,$3A3F
	dc.w	$398C,$38D8,$3824,$376F
	dc.w	$36B9,$3603,$354D,$3496
	dc.w	$33DE,$3326,$326D,$31B4
	dc.w	$30FB,$3041,$2F86,$2ECC
	dc.w	$2E10,$2D54,$2C98,$2BDB
	dc.w	$2B1E,$2A61,$29A3,$28E5
	dc.w	$2826,$2767,$26A7,$25E7
	dc.w	$2527,$2467,$23A6,$22E4
	dc.w	$2223,$2161,$209F,$1FDC
	dc.w	$1F19,$1E56,$1D93,$1CCF
	dc.w	$1C0B,$1B46,$1A82,$19BD
	dc.w	$18F8,$1833,$176D,$16A7
	dc.w	$15E1,$151B,$1455,$138E
	dc.w	$12C7,$1200,$1139,$1072
	dc.w	$0FAB,$0EE3,$0E1B,$0D53
	dc.w	$0C8B,$0BC3,$0AFB,$0A32
	dc.w	$096A,$08A1,$07D9,$0710
	dc.w	$0647,$057E,$04B6,$03ED
	dc.w	$0324,$025B,$0192,$00C9
	dc.w	$0000,$FF37,$FE6E,$FDA5
	dc.w	$FCDC,$FC13,$FB4A,$FA82
	dc.w	$F9B9,$F8F0,$F827,$F75F
	dc.w	$F696,$F5CE,$F505,$F43D
	dc.w	$F375,$F2AD,$F1E5,$F11D
	dc.w	$F055,$EF8E,$EEC7,$EE00
	dc.w	$ED39,$EC72,$EBAB,$EAE5
	dc.w	$EA1F,$E959,$E893,$E7CD
	dc.w	$E708,$E643,$E57E,$E4BA
	dc.w	$E3F5,$E331,$E26D,$E1AA
	dc.w	$E0E7,$E024,$DF61,$DE9F
	dc.w	$DDDD,$DD1C,$DC5A,$DB99
	dc.w	$DAD9,$DA19,$D959,$D899
	dc.w	$D7DA,$D71B,$D65D,$D59F
	dc.w	$D4E2,$D425,$D368,$D2AC
	dc.w	$D1F0,$D134,$D07A,$CFBF
	dc.w	$CF05,$CE4C,$CD93,$CCDA
	dc.w	$CC22,$CB6A,$CAB3,$C9FD
	dc.w	$C947,$C891,$C7DC,$C728
	dc.w	$C604,$C5C1,$C50E,$C45C
	dc.w	$C3AA,$C2F9,$C249,$C199
	dc.w	$C0EA,$C03B,$BF8D,$BEE0
	dc.w	$BE33,$BD87,$BCDB,$BC30
	dc.w	$BB86,$BADD,$BA34,$B98C
	dc.w	$B8E4,$B83D,$B797,$B6F2
	dc.w	$B64D,$B5A9,$B506,$B463
	dc.w	$B3C1,$B320,$B280,$B1E0
	dc.w	$B141,$B0A3,$B006,$AF69
	dc.w	$AECD,$AE32,$AD98,$ACFF
	dc.w	$AC66,$ABCE,$AB37,$AAA1
	dc.w	$AA0C,$A977,$A8E3,$A850
	dc.w	$A7BE,$A72D,$A69D,$A60D
	dc.w	$A57F,$A4F1,$A464,$A3D8
	dc.w	$A34D,$A2C3,$A23A,$A1B1
	dc.w	$A12A,$A0A3,$A01E,$9F99
	dc.w	$9F15,$9E92,$9E10,$9D8F
	dc.w	$9D0F,$9C90,$9C12,$9B95
	dc.w	$9B19,$9A9E,$9A23,$99AA
	dc.w	$9932,$98BB,$9844,$97CF
	dc.w	$975B,$96E7,$9675,$9604
	dc.w	$9594,$9525,$94B6,$9449
	dc.w	$93DD,$9372,$9308,$929F
	dc.w	$9237,$91D0,$916B,$9106
	dc.w	$90A2,$9040,$8FDE,$8F7E
	dc.w	$8F1F,$8EC0,$8E63,$8E07
	dc.w	$8DAC,$8D52,$8CFA,$8CA2
	dc.w	$8C4B,$8BF6,$8BA2,$8B4F
	dc.w	$8AFD,$8AAC,$8A5C,$8A0D
	dc.w	$89C0,$8973,$8928,$88DE
	dc.w	$8895,$884D,$8807,$87C1
	dc.w	$877D,$873A,$86F8,$86B7
	dc.w	$8677,$8639,$85FC,$85BF
	dc.w	$8584,$854B,$8512,$84DB
	dc.w	$84A4,$846F,$843C,$8409
	dc.w	$83D7,$83A7,$8378,$834A
	dc.w	$831E,$82F2,$82C8,$829F
	dc.w	$8277,$8250,$822B,$8207
	dc.w	$81E4,$81C2,$81A2,$8182
	dc.w	$8164,$8147,$812C,$8111
	dc.w	$80F8,$80E0,$80C9,$80B4
	dc.w	$809F,$808C,$807A,$806A
	dc.w	$805A,$804C,$803F,$8033
	dc.w	$8029,$8020,$8018,$8011
	dc.w	$800B,$8007,$8004,$8002
	dc.w	$8001,$8002,$8004,$8007
	dc.w	$800B,$8011,$8018,$8020
	dc.w	$8029,$8033,$803F,$804C
	dc.w	$805A,$806A,$807A,$808C
	dc.w	$809F,$80B4,$80C9,$80E0
	dc.w	$80F8,$8111,$812C,$8147
	dc.w	$8164,$8182,$81A2,$81C2
	dc.w	$81E4,$8207,$822B,$8250
	dc.w	$8277,$829F,$82C8,$82F2
	dc.w	$831E,$834A,$8378,$83A7
	dc.w	$83D7,$8409,$843C,$846F
	dc.w	$84A4,$84DB,$8512,$854B
	dc.w	$8584,$85BF,$85FC,$8639
	dc.w	$8677,$86B7,$86F8,$873A
	dc.w	$877D,$87C1,$8807,$884D
	dc.w	$8895,$88DE,$8928,$8973
	dc.w	$89C0,$8A0D,$8A5C,$8AAC
	dc.w	$8AFD,$8B4F,$8BA2,$8BF6
	dc.w	$8C4B,$8CA2,$8CFA,$8D52
	dc.w	$8DAC,$8E07,$8E63,$8EC0
	dc.w	$8F1F,$8F7E,$8FDE,$9040
	dc.w	$90A2,$9106,$916B,$91D0
	dc.w	$9237,$929F,$9308,$9372
	dc.w	$93DD,$9449,$94B6,$9525
	dc.w	$9594,$9604,$9675,$96E7
	dc.w	$975B,$97CF,$9844,$98BB
	dc.w	$9932,$99AA,$9A23,$9A9E
	dc.w	$9B19,$9B95,$9C12,$9C90
	dc.w	$9D0F,$9D8F,$9E10,$9E92
	dc.w	$9F15,$9F99,$A01E,$A0A3
	dc.w	$A12A,$A1B1,$A23A,$A2C3
	dc.w	$A34D,$A3D8,$A464,$A4F1
	dc.w	$A57F,$A60D,$A69D,$A72D
	dc.w	$A7BE,$A850,$A8E3,$A977
	dc.w	$AA0C,$AAA1,$AB37,$ABCE
	dc.w	$AC66,$ACFF,$AD98,$AE32
	dc.w	$AECD,$AF69,$B006,$B0A3
	dc.w	$B141,$B1E0,$B280,$B320
	dc.w	$B3C1,$B463,$B506,$B5A9
	dc.w	$B64D,$B6F2,$B797,$B83D
	dc.w	$B8E4,$B98C,$BA34,$BADD
	dc.w	$BB86,$BC30,$BCDB,$BD87
	dc.w	$BE33,$BEE0,$BF8D,$C03B
	dc.w	$C0EA,$C199,$C249,$C2F9
	dc.w	$C3AA,$C45C,$C50E,$C5C1
	dc.w	$C674,$C728,$C7DC,$C891
	dc.w	$C947,$C9FD,$CAB3,$CB6A
	dc.w	$CC22,$CCDA,$CD93,$CE4C
	dc.w	$CF05,$CFBF,$D07A,$D134
	dc.w	$D1F0,$D2AC,$D368,$D425
	dc.w	$D4E2,$D59F,$D65D,$D71B
	dc.w	$D7DA,$D899,$D959,$DA19
	dc.w	$DAD9,$DB99,$DC5A,$DD1C
	dc.w	$DDDD,$DE9F,$DF61,$E024
	dc.w	$E0E7,$E1AA,$E26D,$E331
	dc.w	$E3F5,$E4BA,$E57E,$E643
	dc.w	$E708,$E7CD,$E893,$E959
	dc.w	$EA1F,$EAE5,$EBAB,$EC72
	dc.w	$ED39,$EE00,$EEC7,$EF8E
	dc.w	$F055,$F11D,$F1E5,$F2AD
	dc.w	$F375,$F43D,$F505,$F5CE
	dc.w	$F696,$F75F,$F827,$F8F0
	dc.w	$F9B9,$FA82,$FB4A,$FC13
	dc.w	$FCDC,$FDA5,$FE6E,$FF37
	dc.w	$0000,$00C9,$0192,$025B
	dc.w	$0324,$03ED,$04B6,$057E
	dc.w	$0647,$0710,$07D9,$08A1
	dc.w	$096A,$0A32,$0AFB,$0BC3
	dc.w	$0C8B,$0D53,$0E1B,$0EE3
	dc.w	$0FAB,$1072,$1139,$1200
	dc.w	$12C7,$138E,$1455,$151B
	dc.w	$15E1,$16A7,$176D,$1833
	dc.w	$18F8,$19BD,$1A82,$1B46
	dc.w	$1C0B,$1CCF,$1D93,$1E56
	dc.w	$1F19,$1FDC,$209F,$2161
	dc.w	$2223,$22E4,$23A6,$2467
	dc.w	$2527,$25E7,$26A7,$2767
	dc.w	$2826,$28E5,$29A3,$2A61
	dc.w	$2B1E,$2BDB,$2C98,$2D54
	dc.w	$2E10,$2ECC,$2F86,$3041
	dc.w	$30FB,$31B4,$326D,$3326
	dc.w	$33DE,$3496,$354D,$3603
	dc.w	$36B9,$376F,$3824,$38D8
	dc.w	$398C,$3A3F,$3AF2,$3BA4
	dc.w	$3C56,$3D07,$3DB7,$3E67
	dc.w	$3F16,$3FC5,$4073,$4120
	dc.w	$41CD,$4279,$4325,$43D0
	dc.w	$447A,$4523,$45CC,$4674
	dc.w	$471C,$47C3,$4869,$490E
	dc.w	$49B3,$4A57,$4AFA,$4B9D
	dc.w	$4C3F,$4CE0,$4D80,$4E20
	dc.w	$4EBF,$4F5D,$4FFA,$5097
	dc.w	$5133,$51CE,$5268,$5301
	dc.w	$539A,$5432,$54C9,$555F
	dc.w	$55F4,$5689,$571D,$57B0
	dc.w	$5842,$58D3,$5963,$59F3
	dc.w	$5A81,$5B0F,$5B9C,$5C28
	dc.w	$5CB3,$5D3D,$5DC6,$5E4F
	dc.w	$5ED6,$5F5D,$5FE2,$6067
	dc.w	$60EB,$616E,$61F0,$6271
	dc.w	$62F1,$6370,$63EE,$646B
	dc.w	$64E7,$6562,$65DD,$6656
	dc.w	$66CE,$6745,$67BC,$6831
	dc.w	$68A5,$6919,$698B,$69FC
	dc.w	$6A6C,$6ADB,$6B4A,$6BB7
	dc.w	$6C23,$6C8E,$6CF8,$6D61
	dc.w	$6DC9,$6E30,$6E95,$6EFA
	dc.w	$6F5E,$6FC0,$7022,$7082
	dc.w	$70E1,$7140,$719D,$71F9
	dc.w	$7254,$72AE,$7306,$735E
	dc.w	$73B5,$740A,$745E,$74B1
	dc.w	$7503,$7554,$75A4,$75F3
	dc.w	$7640,$768D,$76D8,$7722
	dc.w	$776B,$77B3,$77F9,$783F
	dc.w	$7883,$78C6,$7908,$7949
	dc.w	$7989,$79C7,$7A04,$7A41
	dc.w	$7A7C,$7AB5,$7AEE,$7B25
	dc.w	$7B5C,$7B91,$7BC4,$7BF7
	dc.w	$7C29,$7C59,$7C88,$7CB6
	dc.w	$7CE2,$7D0E,$7D38,$7D61
	dc.w	$7D89,$7DB0,$7DD5,$7DF9
	dc.w	$7E1C,$7E3E,$7E5E,$7E7E
	dc.w	$7E9C,$7EB9,$7ED4,$7EEF
	dc.w	$7F08,$7F20,$7F37,$7F4C
	dc.w	$7F61,$7F74,$7F86,$7F96
	dc.w	$7FA6,$7FB4,$7FC1,$7FCD
	dc.w	$7FD7,$7FE0,$7FE8,$7FEF
	dc.w	$7FF5,$7FF9,$7FFC,$7FFE

L0037:BRA       L0048 
L0038:BRA       L005A 
L0039:DCB.W     3,0 
L003A:DCB.W     34,0
L003B:DCB.W     2,0 
L003C:DCB.W     2,0 
L003D:DCB.W     2,0 
L003E:DCB.W     2,0 
L003F:DCB.W     2,0 
L0040:DCB.W     2,0 
L0041:DCB.W     1600,0
L0042:DCB.W     1600,0
L0043:DCB.W     2,0 
L0044:DCB.W     498,0 
L0045:DC.B      $01,$00,$00,$00,$01,'?' 
L0046:DC.B      $00,$00 
L0047:DC.B      $00,$C7 

L0048:LEA       L003A(PC),A0
      MOVEM.W   (A0),D0-D5
      SUB.W     D2,D0 
      SUB.W     D2,D4 
      SUB.W     D3,D1 
      SUB.W     D3,D5 
      MULS      D0,D5 
      MULS      D1,D4 
      SUB.L     D4,D5 
      BPL       L0069 
      LEA       L0039(PC),A0
      MOVEA.L   (A0)+,A6
      MOVE.W    (A0)+,D0
      MOVE.W    D0,D2 
      ANDI.W    #$F,D0
      LSR.W     #4,D2 
      ANDI.W    #7,D2 
      ADDA.W    D2,A6 
      MOVE.W    D0,D2 
      ADD.W     D0,D0 
      ADD.W     D0,D0 
      MOVE.L    (A0),4(A0,D0.W) 
      MOVE.L    (A0)+,L003B 
      LEA       L0041(PC),A2
      LEA       L0042(PC),A3
      LEA       L0043(PC),A4
      MOVE.W    #$C8,D6 
      MOVEQ     #0,D7 
      MOVE.W    D2,D0 
L0049:MOVEM.W   L003B(PC),D1-D2 
      MOVEM.W   (A0)+,D3-D4 
      MOVEM.W   D3-D4,L003B 
      CMP.W     D2,D4 
      BEQ       L0051 
      BGT       L004E 
      EXG       D3,D1 
      EXG       D4,D2 
      CMP.W     L0046(PC),D2
      BGE.S     L004A 
      CMP.W     L0046(PC),D4
      BLT       L0051 
      MOVE.W    D6,-(A7)
      MOVE.W    D7,-(A7)
      MOVE.W    D3,D5 
      MOVE.W    D4,D6 
      SUB.W     D1,D5 
      SUB.W     D2,D6 
      MOVE.W    L0046(PC),D7
      SUB.W     D2,D7 
      MULS      D7,D5 
      DIVS      D6,D5 
      ADD.W     D5,D1 
      MOVE.W    L0046(PC),D2
      MOVE.W    (A7)+,D7
      MOVE.W    (A7)+,D6
      CMP.W     D2,D4 
      BEQ       L0051 
L004A:CMP.W     L0047(PC),D4
      BLE.S     L004B 
      CMP.W     L0047(PC),D2
      BGT       L0051 
      MOVE.W    D6,-(A7)
      MOVE.W    D7,-(A7)
      MOVE.W    D3,D5 
      MOVE.W    D4,D6 
      SUB.W     D1,D5 
      SUB.W     D2,D6 
      MOVE.W    L0047(PC),D7
      SUB.W     D2,D7 
      MULS      D7,D5 
      DIVS      D6,D5 
      MOVE.W    D1,D3 
      ADD.W     D5,D3 
      MOVE.W    L0047(PC),D4
      MOVE.W    (A7)+,D7
      MOVE.W    (A7)+,D6
      CMP.W     D2,D4 
      BEQ       L0051 
L004B:CMP.W     D2,D6 
      BLE.S     L004C 
      MOVE.W    D2,D6 
L004C:CMP.W     D4,D7 
      BGE.S     L004D 
      MOVE.W    D4,D7 
L004D:MOVE.W    D2,D5 
      LSL.W     #4,D5 
      MOVEM.W   D1-D4,0(A2,D5.W)
      SUB.W     D1,D3 
      SUB.W     D2,D4 
      ADD.W     D4,D4 
      ADD.W     D4,D4 
      MOVEM.W   0(A4,D4.W),D4/D2
      MULS      D3,D2 
      MULS      D3,D4 
      ASL.L     #4,D2 
      ASL.L     #5,D4 
      SWAP      D4
      EXT.L     D4
      ADD.L     D2,D4 
      MOVE.L    D4,8(A2,D5.W) 
      DBF       D0,L0049
      BRA       L0052 
L004E:CMP.W     L0046(PC),D2
      BGE.S     L004F 
      CMP.W     L0046(PC),D4
      BLT       L0051 
      MOVE.W    D6,-(A7)
      MOVE.W    D7,-(A7)
      MOVE.W    D3,D5 
      MOVE.W    D4,D6 
      SUB.W     D1,D5 
      SUB.W     D2,D6 
      MOVE.W    L0046(PC),D7
      SUB.W     D2,D7 
      MULS      D7,D5 
      DIVS      D6,D5 
      ADD.W     D5,D1 
      MOVE.W    L0046(PC),D2
      MOVE.W    (A7)+,D7
      MOVE.W    (A7)+,D6
      CMP.W     D2,D4 
      BEQ.S     L0051 
L004F:CMP.W     L0047(PC),D4
      BLE.S     L0050 
      CMP.W     L0047(PC),D2
      BGT.S     L0051 
      MOVE.W    D6,-(A7)
      MOVE.W    D7,-(A7)
      MOVE.W    D3,D5 
      MOVE.W    D4,D6 
      SUB.W     D1,D5 
      SUB.W     D2,D6 
      MOVE.W    L0047(PC),D7
      SUB.W     D2,D7 
      MULS      D7,D5 
      DIVS      D6,D5 
      MOVE.W    D1,D3 
      ADD.W     D5,D3 
      MOVE.W    L0047(PC),D4
      MOVE.W    (A7)+,D7
      MOVE.W    (A7)+,D6
      CMP.W     D2,D4 
      BEQ.S     L0051 
L0050:MOVE.W    D2,D5 
      LSL.W     #4,D5 
      MOVEM.W   D1-D4,0(A3,D5.W)
      SUB.W     D1,D3 
      SUB.W     D2,D4 
      ADD.W     D4,D4 
      ADD.W     D4,D4 
      MOVEM.W   0(A4,D4.W),D4/D2
      MULS      D3,D2 
      MULS      D3,D4 
      ASL.L     #4,D2 
      ASL.L     #5,D4 
      SWAP      D4
      EXT.L     D4
      ADD.L     D2,D4 
      MOVE.L    D4,8(A3,D5.W) 
L0051:DBF       D0,L0049
L0052:CMP.W     #$C8,D6 
      BEQ       L0069 
      MOVE.W    D6,L003C
      MOVE.W    D6,D0 
      MULU      #$A0,D0 
      ADDA.W    D0,A6 
      LSL.W     #4,D6 
      ADDA.W    D6,A2 
      ADDA.W    D6,A3 
      MOVE.W    D7,L003E
      MOVE.L    A2,L003F
      MOVE.L    A3,L0040
      MOVEQ     #0,D2 
      MOVE.W    (A2),D3 
      ADD.W     D3,D3 
      ADD.W     D3,D3 
      ADDI.W    #$502,D3
      MOVE.W    8(A2),D0
      MOVEA.W   10(A2),A0 
      MOVEQ     #0,D4 
      MOVE.W    (A3),D5 
      ADD.W     D5,D5 
      ADD.W     D5,D5 
      ADDI.W    #$1402,D5 
      MOVE.W    8(A3),D1
      MOVEA.W   10(A3),A1 
L0053:LEA       L0045(PC),A4
      MOVE.W    6(A2),D6
      CMP.W     6(A3),D6
      BGE.S     L0054 
      MOVE.W    L003C(PC),D7
      MOVE.W    D6,L003C
      SUB.W     D7,D6 
      SUBA.W    D6,A4 
      BRA.S     L0055 
L0054:MOVE.W    6(A3),D6
      MOVE.W    L003C(PC),D7
      MOVE.W    D6,L003C
      SUB.W     D7,D6 
      SUBA.W    D6,A4 
L0055:MOVE.L    L003D(PC),D6
      MOVE.W    #$FFFC,D6 
      MOVEA.L   D6,A5 
      MOVEQ     #$FF,D7 
      ANDI.W    #$1FFF,SR 
      MOVE.L    A5,D6 
      AND.W     D3,D6 
      MOVEA.L   D6,A2 
      MOVE.L    A5,D6 
      AND.W     D5,D6 
      MOVEA.L   D6,A3 
      MOVE.W    (A2)+,D6
      ADD.W     (A3)+,D6
      OR.B      (A4)+,D6
      MOVEA.L   D6,A7 
      JMP       (A7)
L0056:LEA       14(A7),A7 
      MOVEA.L   L003F(PC),A2
      MOVEA.L   L0040(PC),A3
      MOVE.W    L003E(PC),D6
      CMP.W     6(A2),D6
      BNE.S     L0057 
      CMP.W     6(A3),D6
      BNE.S     L0057 
      RTS 
L0057:MOVE.W    L003C(PC),D6
      CMP.W     6(A3),D6
      BEQ.S     L0058 
      MOVE.W    6(A2),D6
      LEA       L0041(PC),A2
      LSL.W     #4,D6 
      ADDA.W    D6,A2 
      MOVEQ     #0,D2 
      MOVE.W    (A2),D3 
      ADD.W     D3,D3 
      ADD.W     D3,D3 
      ADDI.W    #$502,D3
      MOVE.W    8(A2),D0
      MOVEA.W   10(A2),A0 
      MOVE.L    A2,L003F
      BRA       L0053 
L0058:CMP.W     6(A2),D6
      BEQ.S     L0059 
      MOVE.W    6(A3),D6
      LEA       L0042(PC),A3
      LSL.W     #4,D6 
      ADDA.W    D6,A3 
      MOVEQ     #0,D4 
      MOVE.W    (A3),D5 
      ADD.W     D5,D5 
      ADD.W     D5,D5 
      ADDI.W    #$1402,D5 
      MOVE.W    8(A3),D1
      MOVEA.W   10(A3),A1 
      MOVE.L    A3,L0040
      BRA       L0053 
L0059:MOVE.W    6(A2),D6
      LEA       L0041(PC),A2
      LSL.W     #4,D6 
      ADDA.W    D6,A2 
      MOVEQ     #0,D2 
      MOVE.W    (A2),D3 
      ADD.W     D3,D3 
      ADD.W     D3,D3 
      ADDI.W    #$502,D3
      MOVE.W    8(A2),D0
      MOVEA.W   10(A2),A0 
      MOVE.L    A2,L003F
      MOVE.W    6(A3),D6
      LEA       L0042(PC),A3
      LSL.W     #4,D6 
      ADDA.W    D6,A3 
      MOVEQ     #0,D4 
      MOVE.W    (A3),D5 
      ADD.W     D5,D5 
      ADD.W     D5,D5 
      ADDI.W    #$1402,D5 
      MOVE.W    8(A3),D1
      MOVEA.W   10(A3),A1 
      MOVE.L    A3,L0040
      BRA       L0053 
L005A:MOVE.L    A0,L003D
      MOVE.W    #$FFFF,D0 
      MOVE.W    #$1E00,D1 
      MOVE.W    #$13F,D2
L005B:MOVE.W    D1,(A0)+
      MOVE.W    D0,(A0)+
      DBF       D2,L005B
      MOVE.W    #$9D8,D2
      MOVEQ     #$13,D3 
L005C:MOVE.W    #$FFFF,D0 
      MOVEQ     #$F,D4
L005D:MOVE.W    D1,(A0)+
      MOVE.W    D0,(A0)+
      LSR.W     #1,D0 
      DBF       D4,L005D
      ADD.W     D2,D1 
      DBF       D3,L005C
      MOVEQ     #0,D0 
      SUB.W     D2,D1 
      MOVE.W    #$13F,D2
L005E:MOVE.W    D1,(A0)+
      MOVE.W    D0,(A0)+
      DBF       D2,L005E
      MOVEQ     #0,D1 
      MOVE.W    #$13F,D2
L005F:MOVE.L    D1,(A0)+
      DBF       D2,L005F
      MOVEQ     #$13,D2 
L0060:MOVEQ     #0,D0 
      MOVEQ     #$F,D3
L0061:MOVE.W    D1,(A0)+
      MOVE.W    D0,(A0)+
      LSR.W     #1,D0 
      ORI.W     #$8000,D0 
      DBF       D3,L0061
      ADDI.W    #$7E,D1 
      DBF       D2,L0060
      MOVEQ     #$FE,D0 
      SUBI.W    #$7E,D1 
      MOVE.W    #$13F,D2
L0062:MOVE.W    D1,(A0)+
      MOVE.W    D0,(A0)+
      DBF       D2,L0062
      MOVEQ     #0,D0 
      MOVEQ     #0,D1 
L0063:MOVEA.L   A0,A2 
      MOVE.W    D1,D2 
      SUB.W     D0,D2 
      BMI.S     L0067 
      BNE.S     L0064 
      MOVE.L    L006D(PC),(A2)+ 
      MOVE.W    L006E(PC),(A2)+ 
      MOVE.W    D0,(A2)+
      BRA.S     L0067 
L0064:MOVE.L    L006B(PC),(A2)+ 
      MOVE.W    D0,(A2)+
      MOVE.W    D0,D3 
L0065:SUBQ.W    #8,D2 
      BEQ.S     L0066 
      ADDQ.W    #8,D3 
      MOVE.W    L006F(PC),(A2)+ 
      MOVE.W    D3,(A2)+
      BRA.S     L0065 
L0066:MOVE.L    L006C(PC),(A2)+ 
      MOVE.W    D1,(A2)+
L0067:LEA       L006A(PC),A4
      MOVE.L    (A4)+,(A2)+ 
      MOVE.L    (A4)+,(A2)+ 
      MOVE.L    (A4)+,(A2)+ 
      MOVE.L    (A4)+,(A2)+ 
      MOVE.L    (A4)+,(A2)+ 
      MOVE.L    (A4)+,(A2)+ 
      MOVE.L    (A4)+,(A2)+ 
      MOVE.L    (A4)+,(A2)+ 
      MOVE.W    (A4)+,(A2)+ 
      LEA       126(A0),A0
      ADDQ.W    #8,D1 
      CMP.W     #$A0,D1 
      BLT.S     L0063 
      ADDQ.W    #8,D0 
      MOVEQ     #0,D1 
      CMP.W     #$A0,D0 
      BLT.S     L0063 
      LEA       L0044,A0
      MOVEQ     #1,D0 
      MOVE.W    #$C6,D1 
L0068:MOVEQ     #0,D2 
      MOVE.W    D0,D2 
      EXT.L     D2
      ADDQ.W    #1,D0 
      MOVE.L    #$100,D3
      DIVS      D2,D3 
      SWAP      D3
      MOVEQ     #0,D4 
      MOVE.W    D3,D4 
      SWAP      D3
      ASL.L     #8,D4 
      EXT.L     D3
      DIVS      D2,D4 
      ASL.L     #8,D3 
      MOVE.W    D4,D5 
      EXT.L     D5
      ADD.L     D5,D3 
      SWAP      D4
      EXT.L     D4
      ASL.L     #8,D4 
      DIVS      D2,D4 
      ASL.L     #8,D3 
      MOVE.W    D4,D5 
      EXT.L     D5
      ADD.L     D5,D3 
      SWAP      D4
      EXT.L     D4
      ASL.L     #6,D3 
      MOVE.W    D4,D5 
      EXT.L     D5
      ADD.L     D5,D3 
      LSR.W     #1,D3 
      MOVE.L    D3,(A0)+
      DBF       D1,L0068
      MOVE.L    #L0056,$C.W 
L0069:RTS 

L006A:LEA       160(A6),A6
      ADD.W     A0,D2 
      ADDX.W    D0,D3 
      ADD.W     A1,D4 
      ADDX.W    D1,D5 
      MOVE.L    A5,D6 
      AND.W     D3,D6 
      MOVEA.L   D6,A2 
      MOVE.L    A5,D6 
      AND.W     D5,D6 
      MOVEA.L   D6,A3 
      MOVE.W    (A2)+,D6
      ADD.W     (A3)+,D6
      OR.B      (A4)+,D6
      MOVEA.L   D6,A7 
      JMP       (A7)

******************************************************************
	SECTION	DATA
******************************************************************

devant equ $043	* fonc‚e
fondt  equ $464	* milieu
fond   equ $474	* claire
Default_palette:	
	dc.w	$000,$777,$fff,$fff,devant,$fff,$fff,$fff
	dc.w	fondt,$fff,$fff,$fff,fond,$fff,$fff,$fff

* Full data here :
* >
bitplane:
  dc.w	0
screen:
	dc.l	0
*	
L006B:
	dc.w	$3C12,$8D6E,$FFFF
L006C:
	dc.w	$3C13,$8D6E,$FFFF
L006D:
	dc.w	$3C12,$CC53
L006E:
	dc.w	$8D6E,$FFFF
L006F:
	dc.w	$3D47,$FFFF
* <

* >
c64_set: ;this is for using C64 font files found from the web
	dc.b 	"@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_"	;$40-$5f
	dc.b 	" ! #$%&'()*+,-./0123456789:;<=>?",0	;$20-$3f
	even

message:
;		dc.b 27,"E"
		DC.B      "                                        ",0
		DC.B      "    ELITE AND NOEXTRA PRESENT IN 2009   ",0
		DC.B      "                                        ",0
		DC.B      "                                        ",0
		DC.B      "       GAME NAME (C) COMPANY NAME       ",0
		DC.B      "                                        ",0
		DC.B      "                                        ",0
		DC.B      "                                        ",0
		DC.B      "    CRACKED/TRAINED.........XXXXXXX     ",0
		DC.B      "                                        ",0
		DC.B      "    CODE....................ZORRO 2     ",0
		DC.B      "                                        ",0
		DC.B      "    GRAPHISM................MISTER.A    ",0
		DC.B      "                                        ",0
		DC.B      "    MUSIC...................E.I.A       ",0
		DC.B      "                                        ",0
		DC.B      "                                        ",0
		DC.B      "                                        ",0
		DC.B      "GREETINGS ARE SENT TO FOLLOWING CREWS : ",0
		DC.B      "DBUG.ELITE.ICS.RESERVOIR GODS.PARADIZE  ",0
		dc.b      "MJJ PROD.NOEXTRA.ST KNIGHTS.TSCC.ZUUL   ",0
		DC.B      "POV.PULSION.HMD.IMPACT.EUROSWAP.STAX    ",0
		dc.b      "OXYGENE.THE LEMMINGS.SECTOR ONE.X-TROLL ",0
		DC.B      "                                        ",$ff
		even

x_curs:         DC.L 0

fonts:
	INCBIN "*.64c"
	EVEN

PalNoeXtra:
	dc.w	$0000,$0666,$0555,$0444,$0333,$0222,$0111,$00F0
	dc.w	$0766,$0655,$0544,$0667,$0556,$0445,$0777,$0FFF

LogoNoeXtra:
	incbin	"SUPPLEX0.IMG"
	even

* <

MUSIC:
	incbin	*.snd                    ; SNDH music -> Not compressed please !!!
	even

******************************************************************
	SECTION	BSS
******************************************************************

bss_start:

* < Full data here >
y_offset:       ds.l	1
x_offset:       ds.l	1

PTR_BUFFER:DS.L      1 
BUFFER:DS.B      79872 
END_PTR_BUFFER:DS.L      1 

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
