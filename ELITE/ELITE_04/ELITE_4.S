***************************************
* // ELITE4.PRG                    // *
***************************************
* // Asm Intro Code Atari ST v0.40 // *
* // by Zorro 2/NoExtra (26/08/11) // *
* // http://www.noextra-team.com/  // *
* // Hall of fame of supreme ST    // *
* // Debugger : Maartau            // *
***************************************
* // Original code : Zorro 2       // *
* // Gfx logo      : none          // *
* // Gfx font      : Mister.A      // *
* // Music         : Mad Max       // *
* // Release date  : 29/08/2011    // *
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
	bsr	DISPLAY

	bsr	Copy_Buffer_to_screen

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

	bsr	PRE_DECAL

	CLR.B     $FFFFFA07.W 
	CLR.B     $FFFFFA09.W 
	CLR.B     $FFFFFA1B.W 
	ORI.B     #1,$FFFFFA07.W
	ORI.B     #1,$FFFFFA13.W

	bsr	print_text

	moveq	#1,d0                      ; Choice of the music (1 is default)
	jsr	MUSIC+0                      ; Init SNDH music

	lea	Vbl(pc),a0                   ; Launch VBL
	move.l	a0,$70.w

	lea	Default_palette(pc),a0   ; Put palette
	lea	$ffff8240.w,a1           ;
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

  move.l	a0,-(a7)
  move.l	a1,-(a7)
  LEA   pal_haut,A0 
  MOVEA.L   #$FF8240,A1 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  move.l	(a7)+,a1
  move.l	(a7)+,a0

      CLR.B     $FFFFFA1B.W 
      MOVE.B    #49,$FFFFFA21.W
      MOVE.L    #HBL,$120.W 
      MOVE.B    #8,$FFFFFA1B.W

	movem.l	d0-a6,-(a7)
	jsr 	(MUSIC+8)                  ; Play SNDH music
	movem.l	(a7)+,d0-a6

	rte

HBL:  CLR.B     $FFFFFA1B.W 
      MOVE.B    #1,$FFFFFA21.W
      MOVE.B    #8,$FFFFFA1B.W
      MOVE.L    #HBL_debut,$120.W
      RTE 
      
HBL_debut:
      move.l	a0,-(a7)
      move.l	a1,-(a7)
      LEA   pal_milieu,A0 
      MOVEA.L   #$FF8240,A1 
      MOVE.L    (A0)+,(A1)+ 
      MOVE.L    (A0)+,(A1)+ 
      move.l	(a7)+,a1
      move.l	(a7)+,a0
      CLR.B     $FFFFFA1B.W 
      MOVE.B    #100,$FFFFFA21.W
      MOVE.B    #8,$FFFFFA1B.W
      MOVE.L    #HBL_noir,$120.W
      RTE 

HBL_noir:
      CLR.B     $FFFFFA1B.W 
      MOVE.B    #1,$FFFFFA21.W
      MOVE.B    #8,$FFFFFA1B.W
      MOVE.L    #HBL_blanc,$120.W
      RTE 

HBL_blanc:
      move.l	a0,-(a7)
      move.l	a1,-(a7)
      LEA   pal_bas,A0 
      MOVEA.L   #$FF8240,A1 
      MOVE.L    (A0)+,(A1)+ 
      MOVE.L    (A0)+,(A1)+ 
      move.l	(a7)+,a1
      move.l	(a7)+,a0
      CLR.B     $FFFFFA1B.W 
      MOVE.B    #1,$FFFFFA21.W
      MOVE.B    #8,$FFFFFA1B.W
      MOVE.L    #HBL_finale,$120.W
      RTE 

HBL_finale:
      CLR.B     $FFFFFA1B.W 
      BCLR      #0,$FFFFFA0F.W
      RTE

pal_haut:
	dc.w	$0000,$0055/2,$0099/2,$0000

pal_milieu:
	dc.w	$0000,$0635/2,$0957/2,$0000

pal_bas:
	dc.w	$0000,$0208/2,$040e/2,$0000

Wait_vbl:                          ; Test Synchronisation
	move.l	a0,-(a7)
	lea	Vsync,a0
	sf	(a0)
.loop:	tst.b	(a0)
	beq.s	.loop
	move.l	(a7)+,a0
	rts

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
*                  SCROLLING DE FOND 4 PLANS                  *
*                        ATOMUS/NOEXTRA                       *
***************************************************************
MEMORY_BASE equ $37800 ; Memoire où on recopie notre vignette *
LARGEUR equ 62  ; WIDTH picto                                 *
HAUTEUR equ 49  ; HEIGHT picto                                *
***************************************************************
PRE_DECAL:
      LEA       MEMORY_BASE,A0
      LEA       LOGO_IMG(PC),A1
      MOVEQ     #HAUTEUR,D0
.rep1:MOVEQ     #7,D1 
.rep2:MOVE.L    (A1)+,(A0)+ 
      DBF       D1,.rep2
      DBF       D0,.rep1
      LEA       MEMORY_BASE,A1 
      BSR.S     NEXT_LINE 
      MOVEQ     #LARGEUR,D0
      LEA       MEMORY_BASE,A1 
mloop:BSR.S     NEXT_LINE 
      LEA       -(160*10)(A0),A0
      MOVEQ     #HAUTEUR,D2 
mrep3:MOVEQ     #3,D1 
.rep4:MOVE.W    (A0),D3 
      MOVE      #0,CCR
      ROXL.W    #1,D3 
      ROXL      24(A0)
      ROXL      16(A0)
      ROXL      8(A0) 
      ROXL      (A0)
      ADDQ.L    #2,A0 
      DBF       D1,.rep4
      LEA       24(A0),A0 
      DBF       D2,mrep3
      LEA       (160*10)(A1),A1 
      BSR.S     NEXT_LINE 
      LEA       -(160*10)(A1),A1
      DBF       D0,mloop
      RTS 
      
NEXT_LINE:
      MOVE.W    #400-1,D1
.loop:MOVE.L    (A1)+,(A0)+ 
      DBF       D1,.loop
      RTS 

DISPLAY:
      LEA       DATAC03(PC),A1
      LEA       DATAC04(PC),A2
      LEA       DATAC02(PC),A3
      LEA       DATAC01(PC),A4
      MOVEQ     #0,D1 
      MOVEQ     #0,D2 
      MOVEQ     #0,D3 
      MOVE.W    (A1),D1 
      ADD.W     (A2)+,D1
      CMP.W     #360,D1
      BCS.S     .next 
      SUBI.W    #360,D1
.next:MOVE.W    D1,(A1)+
      ADD.W     D1,D1 
      ADDI.B    #6,(A4) 
      MOVE.B    0(A3,D1.W),D2 
      ADD.B     (A4),D2 
      MOVE.W    (A1),D1 
      ADD.W     (A2)+,D1
      CMP.W     #360,D1
      BCS.S     .suite 
      SUBI.W    #360,D1
.suite:MOVE.W    D1,(A1)+
      ADD.W     D1,D1 
      MOVE.B    1(A3,D1.W),D3 
      ANDI.L    #64-1,D2 
      MULU      #20*160,D2
      LEA       MEMORY_BASE,A0 
      ADDA.L    D2,A0 
      LSL.L     #5,D3 
      ADDA.L    D3,A0 
      BSR.S     PUT_DECAL      
      RTS
      
PUT_DECAL:
      MOVEA.L   physique(pc),A1
      MOVEQ     #HAUTEUR,D0
.loop:MOVEM.L   (A0)+,A2/D1-D7
      MOVEM.L   A2/D1-D7,(A1) 
      MOVEM.L   A2/D1-D7,32(A1) 
      MOVEM.L   A2/D1-D7,64(A1) 
      MOVEM.L   A2/D1-D7,96(A1) 
      MOVEM.L   A2/D1-D7,128(A1)
      
      MOVEM.L   A2/D1-D7,8000+160(A1) 
      MOVEM.L   A2/D1-D7,8032+160(A1) 
      MOVEM.L   A2/D1-D7,8064+160(A1) 
      MOVEM.L   A2/D1-D7,8096+160(A1) 
      MOVEM.L   A2/D1-D7,8128+160(A1) 
      
      MOVEM.L   A2/D1-D7,16000+160(A1)
      MOVEM.L   A2/D1-D7,16032+160(A1)
      MOVEM.L   A2/D1-D7,16064+160(A1)
      MOVEM.L   A2/D1-D7,16096+160(A1)
      MOVEM.L   A2/D1-D7,16128+160(A1)
      
      MOVEM.L   A2/D1-D7,24000+320(A1)
      MOVEM.L   A2/D1-D7,24032+320(A1)
      MOVEM.L   A2/D1-D7,24064+320(A1)
      MOVEM.L   A2/D1-D7,24096+320(A1)
      MOVEM.L   A2/D1-D7,24128+320(A1)
      
      LEA       160(A1),A1
      DBF       D0,.loop
      RTS 		

***************************************************************
*                   TEXTE FONT 8*8 sur 1 PLAN                 *
*                           AVENGER/AL                        *
***************************************************************
MED equ 1
LOW equ 0

CHARS      equ 40  ; chars per line, 80=for med res, 40 for low res
LINES      equ 33  ; 33 for 8x8 font, 45 with 6x6 font 
FONTSIZE   equ 8  ; 12=12x12 8=8x8, 6=6x6 font
SHIFTSIZE  equ 4   ; 2=MED RESOLUTION, 4=FOR LOW RESOLUTION
RESOLUTION equ LOW ; if no, then its low resolution

print_text:     clr.w	x_curs
                clr.l	x_offset
                clr.l	y_offset
                lea     message,a2
new_char:       bsr     _x_conversion
                moveq   #0,d0    
                move.b  (a2)+,d0	;if zero, stop routine
                cmp.b	#0,d0
                beq	LF
                cmp.b	#$ff,d0
                bne.s   process_char
                rts

process_char:   asl.w 	#3,d0                ; valeur * 8
                lea     fonte,a1	
                sub.w	#256,d0         
                adda.w  d0,a1
                
                move.l #BUFFER8,a3
                adda.l  y_offset,a3
                adda.l  x_offset,a3
                
                rept	FONTSIZE
                move.b  (a1)+,(a3)	
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

_x_conversion:  move.w	x_curs,d0
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

***************************************************************
*          COPIE LE BUFFER SUR 1 PLAN SUR 2 ÉCRANS            *
*                        ATOMUS/NOEXTRA                       *
***************************************************************
Copy_Buffer_to_screen:
                LEA	BUFFER8,A0
                MOVE.L	physique(pc),A1
                lea	160*60+4(a1),a1
                MOVE.L	physique+4(pc),A2
                lea	160*60+4(a2),a2
                MOVEQ	#9*9-2,D7
.loop:
x	SET	0
                REPT	20
                MOVE.W	x(A0),x(A1)
                MOVE.W	x(A0),x(A2)
x	SET	x+8
                ENDR
                LEA	160(A0),A0
                LEA	160(A1),A1
                LEA	160(A2),A2
                DBRA	D7,.loop
                RTS

******************************************************************
	SECTION	DATA
******************************************************************

Default_palette:	
	dc.w	$0000,$0244/2,$0488/2,$0,$0,$0FFF,$0FFF,$0
	dc.w	$0,$0,$0,$0,$0,$0,$0,$0FFF

* Full data here :
* >
message:
;		DC.B      " !",$22,"#$%&",$27,"()*+,-./0123456789:;<=>?",0
;		DC.B      "@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_",0
		DC.B      "    ELITE AND NOEXTRA PRESENT IN 2011   ",0
		DC.B      "       GAME NAME (C) COMPANY NAME       ",0
		DC.B      0
		DC.B      "    CRACKED/TRAINED.........MAARTAU     ",0
		DC.B      "    FAST INTRO..............ZORRO2      ",0
		DC.B      "    MUSIC...................MAD MAX     ",0
		DC.B      0
		DC.B      "BEST REGARD: DBUG.ELITE.ICS.ZUUL.POV.DHS",0
		DC.B      "PULSION.HMD.IMPACT.EUROSWAP.STAX.FUZION.",0
		DC.B      $ff
		even
x_curs:         dc.l 0
y_offset:       dc.l 0
x_offset:       dc.l 0
fonte:
	incbin 	"FONT88V.DAT"
	even
*
DATAC01:
	DC.W	$0000,$0032
DATAC02:
	dc.w	$0000,$0403,$0806,$0D0A
	dc.w	$110D,$1611,$1A14,$1F18
	dc.w	$231B,$281F,$2C22,$3026
	dc.w	$3529,$392C,$3D30,$0201
	dc.w	$0605,$0A08,$0F0B,$130F
	dc.w	$1712,$1B15,$1F18,$241C
	dc.w	$281F,$2C22,$3025,$3428
	dc.w	$382B,$3C2E,$0000,$0303
	dc.w	$0705,$0B08,$0F0B,$120E
	dc.w	$1611,$1A14,$1D17,$2119
	dc.w	$241C,$271F,$2B21,$2E24
	dc.w	$3126,$3529,$382B,$3B2E
	dc.w	$3E30,$0100,$0403,$0605
	dc.w	$0907,$0C09,$0F0B,$110D
	dc.w	$140F,$1611,$1913,$1B15
	dc.w	$1D17,$1F18,$221A,$241C
	dc.w	$261D,$281F,$2920,$2B22
	dc.w	$2D23,$2E24,$3025,$3227
	dc.w	$3328,$3429,$362A,$372B
	dc.w	$382C,$392C,$3A2D,$3B2E
	dc.w	$3C2E,$3C2F,$3D30,$3E30
	dc.w	$3E30,$3F31,$3F31,$3F31
	dc.w	$3F31,$3F31,$0000,$3F31
	dc.w	$3F31,$3F31,$3F31,$3F31
	dc.w	$3E30,$3E30,$3D30,$3C2F
	dc.w	$3C2E,$3B2E,$3A2D,$392C
	dc.w	$382C,$372B,$362A,$3429
	dc.w	$3328,$3227,$3025,$2E24
	dc.w	$2D23,$2B22,$2920,$281F
	dc.w	$261D,$241C,$221A,$1F18
	dc.w	$1D17,$1B15,$1913,$1611
	dc.w	$140F,$110D,$0F0B,$0C09
	dc.w	$0907,$0605,$0403,$0100
	dc.w	$3E30,$3B2E,$382B,$3529
	dc.w	$3126,$2E24,$2B21,$271F
	dc.w	$241C,$2119,$1D17,$1A14
	dc.w	$1611,$120E,$0F0B,$0B08
	dc.w	$0705,$0303,$0000,$3C2E
	dc.w	$382B,$3428,$3025,$2C22
	dc.w	$281F,$241C,$1F18,$1B15
	dc.w	$1712,$130F,$0F0B,$0A08
	dc.w	$0605,$0201,$3D30,$392C
	dc.w	$3529,$3026,$2C22,$281F
	dc.w	$231B,$1F18,$1A14,$1611
	dc.w	$110D,$0D0A,$0806,$0403
	dc.w	$0000,$3B2E,$372B,$3227
	dc.w	$2E24,$2920,$251D,$2019
	dc.w	$1C16,$1712,$130F,$0F0B
	dc.w	$0A08,$0605,$0201,$3D30
	dc.w	$392C,$3529,$3026,$2C22
	dc.w	$281F,$241C,$2019,$1B15
	dc.w	$1712,$130F,$0F0C,$0B09
	dc.w	$0706,$0303,$0000,$3C2E
	dc.w	$382C,$3429,$3026,$2D23
	dc.w	$2920,$251D,$221A,$1E18
	dc.w	$1B15,$1812,$1410,$110D
	dc.w	$0E0B,$0A08,$0706,$0403
	dc.w	$0101,$3E31,$3B2E,$392C
	dc.w	$362A,$3328,$3026,$2E24
	dc.w	$2B22,$2920,$261E,$241C
	dc.w	$221A,$2019,$1D17,$1B15
	dc.w	$1914,$1712,$1611,$140F
	dc.w	$120E,$110D,$0F0C,$0D0A
	dc.w	$0C09,$0B08,$0907,$0806
	dc.w	$0705,$0605,$0504,$0403
	dc.w	$0303,$0302,$0201,$0101
	dc.w	$0101,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0101,$0101,$0201,$0302
	dc.w	$0303,$0403,$0504,$0605
	dc.w	$0705,$0806,$0907,$0B08
	dc.w	$0C09,$0D0A,$0F0C,$110D
	dc.w	$120E,$140F,$1611,$1712
	dc.w	$1914,$1B15,$1D17,$2019
	dc.w	$221A,$241C,$261E,$2920
	dc.w	$2B22,$2E24,$3026,$3328
	dc.w	$362A,$392C,$3B2E,$3E31
	dc.w	$0101,$0403,$0706,$0A08
	dc.w	$0E0B,$110D,$1410,$1812
	dc.w	$1B15,$1E18,$221A,$251D
	dc.w	$2920,$2D23,$3026,$3429
	dc.w	$382C,$3C2E,$3F31,$0303
	dc.w	$0706,$0B09,$0F0C,$130F
	dc.w	$1712,$1B15,$2019,$241C
	dc.w	$281F,$2C22,$3026,$3529
	dc.w	$392C,$3D30,$0201,$0605
	dc.w	$0A08,$0F0B,$130F,$1712
	dc.w	$1C16,$2019,$251D,$2920
	dc.w	$2E24,$3227,$372B,$3B2E
DATAC03:
	dc.w	$0000,$005A
DATAC04:
	dc.w	$0001,$0001
LOGO_IMG:	* Taille 64*50
	incbin	"VIGNETTE.IMG"
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
BUFFER8: ds.b	9*9*160	;	9 lignes de 9 pixels de haut

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
