***************************************
* // ELITE_6.PRG                   // *
***************************************
* // Asm Intro Code Atari ST v0.40 // *
* // by Zorro 2/NoExtra (31/08/11) // *
* // http://www.noextra-team.com/  // *
* // Hall of fame of supreme ST    // *
* // Debugger : Maartau.           // *
***************************************
* // Original code : Zorro2        // *
* // Gfx logo      : none          // *
* // Gfx font      : Miser.A       // *
* // Music         : New Frequency // *
* // Release date  : 31/08/2011    // *
* // Update date   : 17/02/2014    // *
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

	bsr	scroller

	bsr	Etoiles_1p

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

	bsr	mk_font
	bsr	Init_Etoiles
	bsr	print_text

	moveq	#1,d0                      ; Choice of the music (1 is default)
	jsr	MUSIC+0                      ; Init SNDH music

	lea	Vbl(pc),a0                   ; Launch VBL
	move.l	a0,$70.w

	lea	Default_palette(pc),a0                   ; Put palette
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
SIZE_OF_SCREEN equ 160*206
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
Vbl:
;	movem.l	d0-d7/a0-a6,-(a7)

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
      CLR.B     $FFFFFA1B.W 
      MOVE.B    #1,$FFFFFA21.W
      MOVE.L    #HBL,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      ADDQ.W    #2,PTR1_LINE_TOP
      CMPI.W    #$54,PTR1_LINE_TOP
      BLE.S     next_l1 
      CLR.W     PTR1_LINE_TOP 
next_l1:SUBQ.W    #2,PTR2_LINE_TOP
      TST.W     PTR2_LINE_TOP 
      BGE.S     next_l2 
      MOVE.W    #$54,PTR2_LINE_TOP
next_l2:MOVE.L    #COLOUR,PTR_COLOUR
      MOVE.B    #$42*2+57,NB_MID_LINE
 ENDC

; ----------------
; Led des lecteurs
; ----------------
           lea $ffff8800,a0
           move.b #10,(a0)
           move.b (a0),d0
           cmpi.b #14,d0
           blt.s led_off
led_on:    move.b #14,(a0)
           move.b (a0),d0
           andi.b #$f9,d0
           move.b d0,2(a0)
           bra.s led_out
led_off:   move.b #14,(a0)
           move.b (a0),d0
           ori.b #6,d0
           move.b d0,2(a0)
led_out:

	jsr 	(MUSIC+8)                  ; Play SNDH music

;	movem.l	(a7)+,d0-d7/a0-a6
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
*               < Here is the no border rout >                *
*                                                             *
***************************************************************
HBL_COULEUR equ $FFFF8250
HBL:  CLR.B     $FFFFFA1B.W 
      MOVE.L   A0,-(A7)
      LEA       COLOR_LINE_TOP(PC),A0
      ADDA.W    PTR1_LINE_TOP(PC),A0
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      MOVE.W    (A0)+,$FFFF8240.W 
      CLR.W     $FFFF8240.W 
      MOVEA.L   (A7)+,A0
      MOVE.L    #HBL_ENTRE,$120.W 
      MOVE.B    #7,$FFFFFA21.W
      MOVE.B    #8,$FFFFFA1B.W
      RTE 

HBL_ENTRE:
      MOVE.L   A0,-(A7)
      SUBQ.B    #1,NB_MID_LINE
      TST.B     NB_MID_LINE 
      BEQ.S     HBL_END 
      CLR.B     $FFFFFA1B.W 
      MOVEA.L   PTR_COLOUR(PC),A0
      MOVE.W    (A0)+,HBL_COULEUR.W 
      MOVE.L    A0,PTR_COLOUR
      MOVEA.L   (A7)+,A0
      MOVE.B    #1,$FFFFFA21.W
      MOVE.B    #8,$FFFFFA1B.W
      RTE 

HBL_END:
      MOVE.L   A1,-(A7)
      MOVE.W    D0,-(A7)
      MOVE.B    #$F0,$FFFFFA21.W
      LEA       COLOR_LINE_TOP(PC),A0
      ADDA.W    PTR2_LINE_TOP(PC),A0
      LEA       $FFFF8240.W,A1
      MOVE.B    $FFFFFA21.W,D0
.loop:CMP.B     $FFFFFA21.W,D0
      BEQ.S     .loop 
      MOVE.W    (A7)+,D0
      CLR.B     $FFFFFA1B.W 
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
      MOVE.W    (A0)+,(A1)
      MOVE.W    (A0)+,(A1)
      CLR.W     (A1)
      MOVEA.L   (A7)+,A1
      MOVEA.L   (A7)+,A0
      RTE 

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

	IFEQ	NO_BORDER
	sf	$fffffa21.w
	sf	$fffffa1b.w
	move.l	#HBL,$120.w
	bset	#0,$fffffa07.w	* Timer B on
	bset	#0,$fffffa13.w	* Timer B on
	ENDC

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

***************************************************************
*         STARS 320*200 ONE BITPLANE / TWO SCREENS            *
*                      ZORRO 2 / NOEXTRA                      *
***************************************************************
Init_Etoiles:
      LEA       Buffer_Etoiles,A6
      MOVE.W    #$C6,D7 
.loop:BSR.S     Rand_Etoiles 
      ANDI.L    #$FFFF,D0 
      DIVU      #$A0,D0 
      SWAP      D0
      ANDI.W    #$FFF8,D0 
      MOVE.W    D0,(A6)+
      BSR.S     Rand_Etoiles 
      ANDI.W    #$F,D0
      CLR.W     D1
      BSET      D0,D1 
      MOVE.W    D1,(A6)+
      DBF       D7,.loop
      RTS

Rand_Etoiles:
      MOVE.W    #$11,-(A7) 	;RANDOM 
      TRAP      #$E 
      ADDQ.L    #2,A7 
      RTS 

Etoiles_1p:
      MOVEA.L   physique(PC),A5
      ADDA.L    #160*5,A5 
      MOVEA.L   physique+4(PC),A6
      ADDA.L    #160*5,A6
      LEA       Buffer_Etoiles,A0
      MOVE.W    #$C6,D0 
      CLR.L     D4
      MOVE.B    #$A0-8,D4 
loopE:MOVE.W    (A0)+,D1
      CLR.L     D2
      MOVE.W    (A0),D2 
      MOVE.W    D0,D3 
      ANDI.W    #3,D3 
      ADDQ.W    #1,D3 
      ROR.L     D3,D2 
      TST.W     D2
      BNE.S     .plus 
      SWAP      D2
      CLR.W     0(A5,D1.W)
      CLR.W     0(A6,D1.W)
      ADDQ.W    #8,D1 
      CMP.W     D4,D1 
      BLT.S     .moins 
      CLR.W     D1
.moins:MOVE.W    D1,-2(A0) 
.plus:MOVE.W    D2,(A0)+
      MOVE.W    D2,0(A5,D1.W) 
      ADDA.L    D4,A5 
      MOVE.W    D2,0(A6,D1.W) 
      ADDA.L    D4,A6 
      DBF       D0,loopE
      RTS 

***************************************************************
*                 TEXTE FONT 8*8 ONE PLAN                     *
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
                lea     fonte(pc),a1	
                sub.w	#256,d0         
                adda.w  d0,a1
                
                movea.l physique(pc),a0
                ;lea     160*54(a0),a0
                add.w   #6,a0
                adda.l  y_offset(pc),a0
                adda.l  x_offset(pc),a0
                
                movea.l physique+4(pc),a3
                ;lea     160*54(a3),a3
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
*       SCROLLING font 1 bitplane 40x24        *
*             ZORRO 2 / NOEXTRA                *
************************************************
PLAN_SCROLLER equ 6
scroller:
	addi.w	#1,sc
	cmpi.w	#4,sc
	bne.s	nofnt
	clr.w	sc
	bsr.s	newfontw
nofnt:
	bsr 	scroll
	bra	bendbuff
end:
	move.l	#text_scrol,ptr_text_scrol
newfontw:
	movea.l	ptr_text_scrol,a0
	move.b	(a0)+,d0
	move.l	a0,ptr_text_scrol
	cmpi.b	#$ff,d0
	beq.s	end

* 0 à 9
	cmpi.b	#"0",d0
	bne.s	.1
	move.b	#30,d0	
	bra	funt
.1:
	cmpi.b	#"1",d0
	bne.s	.2
	move.b	#31,d0	
	bra.s	funt
.2:
	cmpi.b	#"2",d0
	bne.s	.3
	move.b	#32,d0	
	bra.s	funt
.3:
	cmpi.b	#"3",d0
	bne.s	.4
	move.b	#33,d0	
	bra.s	funt
.4:
	cmpi.b	#"4",d0
	bne.s	.5
	move.b	#34,d0	
	bra.s	funt
.5:
	cmpi.b	#"5",d0
	bne.s	.6
	move.b	#35,d0	
	bra.s	funt
.6:
	cmpi.b	#"6",d0
	bne.s	.7
	move.b	#36,d0	
	bra.s	funt
.7:
	cmpi.b	#"7",d0
	bne.s	.8
	move.b	#37,d0	
	bra.s	funt
.8:
	cmpi.b	#"8",d0
	bne.s	.9
	move.b	#38,d0	
	bra.s	funt
.9:
	cmpi.b	#"9",d0
	bne.s	.nop
	move.b	#39,d0	
	bra.s	funt
.nop:

	cmpi.b	#".",d0
	bne.s	point
	move.b	#26,d0	
	bra.s	funt
point:
	cmpi.b	#" ",d0
	bne.s	space
	move.b	#27,d0	
	bra.s	funt
space:
	subi.b	#"A",d0
funt:
	andi.w	#$ff,d0
	muls	#4*32,d0		*128
	lea	font,a0
	adda.w	d0,a0
	lea	puffer+40,a1
	move.w	#31,d0
lllp:
	move.w	(a0)+,00(a1)
	move.w	(a0)+,02(a1)
	lea	48(a1),a1
	dbf	d0,lllp
	rts
scroll:
	lea	puffer,a0
	move.w	#31,d0
scrl1
i set 01
 rept 44
	move.b	i(a0),i-1(a0)
i set i+1
 endr
	lea	48(a0),a0
	dbf	d0,scrl1
	rts

bendbuff:
	cmpi.w	#0,wpos
	bne.s	notend
	move.w	#720,wpos
notend	subi.w	#4,wpos
	lea	wave,a2
	adda.w	wpos,a2
	lea	self1(pc),a0
	moveq	#19,d7
	move.w	#76,d2
	moveq	#0,d3
	moveq	#0,d4
pre_do:
	move.w	d2,d0
	move.w	d2,d1
	add.w	(a2)+,d0
	add.w	(a2)+,d1
	muls	#160,d0
	muls	#160,d1
	addq.w	#1,d1
	add.w	d3,d0
	add.w	d3,d1
	move.w	d4,2(a0)
	move.w	d4,8(a0)
	addq.w	#1,8(a0)
	move.w	d0,4(a0)	
	move.w	d1,10(a0)	
	addq.w	#8,d3
	addq.w	#2,d4
	lea	12(a0),a0
	dbf	d7,pre_do
	movea.l	physique(pc),a0
	addq.w	#PLAN_SCROLLER,a0
	lea	160*50(a0),a0
	lea	blnk,a1
	move.w	#32,d0
self1:
 rept 40
	move.b	0(a1),0(a0)
 endr
	lea	48(a1),a1
	lea	160(a0),a0
	dbf	d0,self1
	rts

mk_font:
	lea	font,a0	get start of font
	lea	fontpic,a1	get start of picture
	moveq	#0,d1		y=0
loop1:
	moveq	#0,d0		x=0
loop2:
	movea.l	a1,a2
	move.w	d0,d2
	muls	#16,d2
	adda.l	d2,a2
	move.w	d1,d2
	muls	#160*32,d2
	adda.l	d2,a2
value	set	0
	rept	32
	move.w	value*160+0(a2),(a0)+
	move.w	value*160+8(a2),(a0)+
value	set	value+1
	endr
	addq.w	#1,d0
	cmpi.w	#10,d0
	bne	loop2
	addq.w	#1,d1
	cmpi.w	#3+1,d1
	bne	loop1
	rts

******************************************************************
	SECTION	DATA
******************************************************************

Default_palette:	
	dc.w	$0,$0FFF,$0,$0,$0,$0,$0,$0
	dc.w	$0,$0FFF,$0,$0,$0,$0,$0,$0

* Full data here :
* >
message:
;	DC.B	" !",$22,"#$%&",$27,"()*+,-./0123456789:;<=>?",0
;	DC.B	"@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_",0
;	DC.B	"`abcdefghijklmnopqrstuvwxyz",0
	DC.B	0
	DC.B	"                * ELITE *               ",0
	DC.B	"             PRESENT IN 2014            ",0
	DC.B	"      GAME NAME (+X) COMPANY NAME       ",0
	DC.B	"  ------------------------------------  ",0
	DC.B	"    CREDITS FOR THIS NOEXTRA INTRO:     ",0
	DC.B	"     CRACKED/TRAINED.....MAARTAU        ",0
	DC.B	"     ALL CODE............ZORRO2         ",0
	DC.B	"     FONTS...............MISTER.A       ",0
	DC.B	"     MUSIC...............FREQUENCY      ",0
	DC.B	$ff
	even
x_curs:
	ds.l 1
y_offset:
	ds.l 1
x_offset:
	ds.l 1
fonte:
	incbin 	"font88*.DAT"
	EVEN
*
NB_MID_LINE:
	dc.w	$4200*2+57
PTR_COLOUR:
	dc.l	COLOUR
COLOUR:
	dc.w	$300,$410,$520,$630,$740,$630,$520,$410,$300 * orange
	dc.w	$320,$430,$540,$650,$760,$650,$540,$430,$320 * jaune
	dc.w	$030,$040,$050,$060,$070,$060,$050,$040,$030 * vert 3
	dc.w	$030,$041,$052,$063,$074,$063,$052,$041,$030 * vert 2
	dc.w	$032,$043,$054,$065,$076,$065,$054,$043,$032 * vert 1
	dc.w	$013,$024,$035,$046,$057,$046,$035,$024,$013 * bleu claire
	dc.w	$003,$004,$005,$006,$007,$006,$005,$004,$003 * bleu fonce
	dc.w	$103,$204,$305,$406,$507,$406,$305,$204,$103 * violet fonce
	dc.w	$302,$403,$504,$605,$706,$605,$504,$403,$302 * violet claire
	dcb.w	8,$0
	dc.w	$0710,$0710,$0720,$0710
	dc.w	$0720,$0720,$0730,$0720
	dc.w	$0730,$0730,$0740,$0730
	dc.w	$0740,$0740,$0750,$0740
	dc.w	$0750,$0750,$0760,$0750
	dc.w	$0760,$0760,$0770,$0760
	dc.w	$0770,$0770,$0670,$0770
	dc.w	$0670,$0670,$0570,$0670
	dc.w	$0570,$0570,$0470,$0570
	dc.w	$0470,$0470,$0370,$0470
	dc.w	$0370,$0370,$0270,$0370
	dc.w	$0270,$0270,$0170,$0270
	dc.w	$0170,$0170,$0070,$0170
	dc.w	$0070,$0070,$0071,$0070
	dc.w	$0071,$0071,$0072,$0070
	dc.w	$0072,$0072,$0073,$0072
	dc.w	$0073,$0073,$0074,$0073
	dc.w	$0074,$0074,$0075,$0074
	dc.w	$0075,$0075,$0076,$0075
	dc.w	$0076,$0076,$0077,$0076
	dc.w	$0077,$0077,$0067,$0077
	dc.w	$0067,$0067,$0057,$0067
	dc.w	$0057,$0057,$0047,$0057
	dc.w	$0047,$0047,$0037,$0047
	dc.w	$0037,$0037,$0027

*
CFOND equ	$0000
PTR1_LINE_TOP:
	dc.w	0
PTR2_LINE_TOP:
	dc.w	0
COLOR_LINE_TOP:
	dc.w	CFOND,CFOND,CFOND,$0003
	dc.w	$0004,$0005,$0006,$0007
	dc.w	$0107,$0207,$0307,$0407
	dc.w	$0507,$0607,$0707,$0706
	dc.w	$0705,$0704,$0703,$0702
	dc.w	$0701,$0700,$0710,$0720
	dc.w	$0730,$0740,$0750,$0760
	dc.w	$0770,$0670,$0570,$0470
	dc.w	$0370,$0270,$0170,$0070
	dc.w	$0060,$0050,$0040,$0030
	dc.w	$0020,$0010,$0000,$0001
	dc.w	$0003,$0004,$0005,$0006
	dc.w	$0007,$0107,$0207,$0307
	dc.w	$0407,$0507,$0607,$0707
	dc.w	$0706,$0705,$0704,$0703
	dc.w	$0702,$0701,$0700,$0710
	dc.w	$0720,$0730,$0740,$0750
	dc.w	$0760,$0770,$0670,$0570
	dc.w	$0470,$0370,$0270,$0170
	dc.w	$0070,$0060,$0050,$0040
	dc.w	$0030,$0020,$0010,CFOND
*
sc:
	dc.w	0
ptr_text_scrol:
	dc.l	text_scrol
text_scrol:
	DC.B	'ABCDEFGHIJKLMNOPQRSTUVWXYZ.'
	DC.B	'0123456789                 '
	dc.b	$ff
	even
wpos:
	dc.w	0
wave:
	incbin	"sin30.dat"
	even
blnk:
	ds.b	48*2
puffer:
	ds.b	48*33
	even
font:
	ds.b	128*30
	even
fontpic
	incbin	"FONT*.IMG
	ds.b	160*3
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
Buffer_Etoiles:
	ds.b	13000 

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
