***************************************
* // AL_21.PRG                     // *
***************************************
* // Asm Intro Code Atari ST v0.42 // *
* // by Zorro 2/NoExtra (05/12/11) // *
* // http://www.noextra-team.com/  // *
***************************************
* // Original code : Zorro 2       // *
* // Gfx logo      : Mister.A      // *
* // Gfx font      : Arjarn/VGT    // *
* // Music         : Big Alec      // *
* // Release date  : 02/01/2015    // *
* // Update date   : 04/01/2015    // *
***************************************
  OPT c+ ; Case sensitivity on        *
  OPT d- ; Debug off                  *
  OPT o- ; All optimisations off      *
  OPT w- ; Warnings off               *
  OPT x- ; Extended debug off         *
***************************************

***************************************************************
	SECTION	TEXT                                             // *
***************************************************************

**************************** OVERSCAN ******************************
BOTTOM_BORDER    equ 1         ; Use the bottom overscan           *
TOPBOTTOM_BORDER equ 0         ; Use the top and bottom overscan   *
NO_BORDER        equ 1         ; Use a standard screen             *
********************************************************************
PATTERN          equ $00000000 ; See the screen plan               *
SEEMYVBL         equ 1         ; See CPU used if you press ALT key *
ERROR_SYS        equ 1         ; Manage Errors System              *
FADE_INTRO       equ 0         ; Fade White to black palette       *
TEST_STE         equ 1         ; Code only for Atari STE machine   *
********************************************************************
*            Remarque : 0 = I use it / 1 = no need !               *
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
	move.w	#32,-(sp)                ;
	trap	#1                         ;
	addq.l	#6,sp                    ;
	move.l	d0,Save_stack            ; Save adress of stack
mode_super_yet:

 IFEQ TEST_STE
	move.l	$5a0,a0                  ; Test STE machine
	cmp.l	#$0,a0                     ;
	beq	EXIT                         ; Pas de cookie_jar donc un vieux ST.
	move.l	$14(a0),d0               ;
	cmp.l	#$0,d0                     ; _MCH=0 alors c' est un ST-STf.
	beq	EXIT                         ;
 ENDC

	bsr	wait_for_drive               ; Stop floppy driver

	bsr	clear_bss                    ; Clean BSS stack
	
	bsr	Save_and_init_st             ; Save system parameters

	bsr	Init_screens                 ; Screen initialisations

	jsr	Multi_boot                   ; Multi Atari Boot code

	bsr	Init                         ; Initialisations

**************************** MAIN LOOP ************************>

default_loop:

	bsr	Wait_vbl                     ; Waiting after the VBL

	IFEQ	SEEMYVBL
	clr.b	$ffff8240.w
	move.l	#$3C6079b,$ffff8240.w
	ENDC

* < Put your code here >

PLANcls equ 0
	jsr	Cls_1_plan

	bsr	DemoScroll
	bsr	DemoScroll

* <

	lea     physique(pc),a0          ; Swapping two Screens
	move.l	(a0),d0                  ;
	move.l	4(a0),(a0)+              ;
	move.l	d0,(a0)                  ;
	move.b  d0,$ffff820d.w           ;
	move    d0,-(sp)                 ;
	move.b  (sp)+,d0                 ;
	move.l  d0,$ffff8200.w           ;

	IFEQ	SEEMYVBL
	cmp.b	#$38,$fffffc02.w           ; ALT key pressed ?
	bne.s	next_key                   ;
	move.b	#7,$ffff8240.w           ; See the rest of CPU
next_key:                          ;
	ENDC

	cmp.b	#$39,$fffffc02.w           ; SPACE key pressed ?
	bne	default_loop

**************************** MAIN LOOP ************************<

SORTIE:
	bsr	Restore_st                   ; Restore all registers

EXIT:
	move.l	Save_stack,-(sp)         ; Restore adress of stack
	move.w	#32,-(sp)                ; Restore user Mode
	trap	#1                         ;
	addq.l	#6,sp                    ;

	clr.w	-(sp)                      ; Pterm()
	trap	#1                         ; EXIT program

***************************************************************
*                                                             *
*                 Initialisations Routines                    *
*                                                             *
***************************************************************
Init:	movem.l	d0-d7/a0-a6,-(a7)

	IFEQ	FADE_INTRO
	bsr	fadein                       ; Fading white to black
	ENDC

	lea	physique(pc),a6
	move.l	(a6)+,a0
	move.l	(a6)+,a1
	movea.l	#Colonnes,a4
	move.l	#160*267/4-1,d0
	move.l	(a4),(a0)+
	move.l	(a4)+,(a1)+
	dbf	d0,*-4

	bsr	print_text                   ; Affiche le texte

	moveq	#1,d0                      ; Choice of the music (1 is default)
	jsr	MUSIC+0                      ; Init SNDH music

	lea	Vbl(pc),a0                   ; Launch VBL
	move.l	a0,$70.w                 ;

  bsr     Genere_code_cls
	jsr	Cls_1_plan

	lea	Default_palette,a0           ; Put palette
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d7               ;
	movem.l	d0-d7,(a1)               ;

  bsr     InitDemo

	movem.l	(a7)+,d0-d7/a0-a6
	rts

***************************************************************
*                                                             *
*                       Screen Routines                       *
*                                                             *
***************************************************************
 IFEQ	BOTTOM_BORDER
SIZE_OF_SCREEN equ 160*250        ; Screen + Lower Border size
 ENDC
 IFEQ	TOPBOTTOM_BORDER
SIZE_OF_SCREEN equ 160*300        ; Screen + Top & Lower Border size
 ENDC
 IFEQ	NO_BORDER
SIZE_OF_SCREEN equ 160*200        ; Only Screen size
 ENDC

Init_screens:
	movem.l	d0-d7/a0-a6,-(a7)

	move.l	#Screen_1,d0             ; Set physical Screen #1
	add.w	#$ff,d0                    ;
	sf	d0                           ;
	move.l	d0,physique              ;

	move.l	#Screen_2,d0             ; Set logical Screen #2
	add.w	#$ff,d0                    ;
	sf	d0                           ;
	move.l	d0,physique+4            ;

	move.l	physique(pc),a0          ; Put PATTERN in two Screens
	move.l	physique+4(pc),a1        ;
	move.w  #(SIZE_OF_SCREEN)/4-1,d7 ;
	move.l  #PATTERN,(a0)+           ;
	move.l  #PATTERN,(a1)+           ;
	dbf	    d7,*-12                  ;

	move.l	physique(pc),d0          ; Put physical Screen
	move.b	d0,d1                    ;
	lsr.w	#8,d0                      ;
	move.b	d0,$ffff8203.w           ;
	swap	d0                         ;
	move.b	d0,$ffff8201.w           ;
	move.b	d1,$ffff820d.w           ;

	movem.l	(a7)+,d0-d7/a0-a6
	rts

physique:
	ds.l 2                           ; Number of screens declared

***************************************************************
*                                                             *
*                        Vbl Routines                         *
*                                                             *
***************************************************************
Vbl:	st	Vsync                    ; Synchronisation

	movem.l	d0-d7/a0-a6,-(a7)

	IFEQ	BOTTOM_BORDER
	clr.b   $fffffa1b.w              ; Disable timer B
	lea	Over_rout(pc),a0             ; HBL
	move.l	a0,$120.w                ; Timer B vector
	move.b	#199,$fffffa21.w         ; At the position
	move.b	#8,$fffffa1b.w           ; Launch HBL
	ENDC

	IFEQ	TOPBOTTOM_BORDER
	move.l	a0,-(a7)
	clr.b	(tacr).w                   ; Stop timer A
	lea	topbord(pc),a0               ; Launch HBL
	move.l	a0,$134.w                ; Timer A vector
	move.b	#99,(tadr).w             ; Countdown value for timer A
	move.b	#4,(tacr).w              ; Delay mode, clock divided by 50
	move.l	(a7)+,a0
	ENDC

	IFEQ	NO_BORDER
* // Declarations here ...
	ENDC

	jsr 	(MUSIC+8)                  ; Play SNDH music

	movem.l	(a7)+,d0-d7/a0-a6
	rte

Wait_vbl:                          ; Test Synchronisation
	move.l	a0,-(a7)                 ;
	lea	Vsync,a0                     ;
	sf	(a0)                         ;
.loop:	tst.b	(a0)                 ;
	beq.s	.loop                      ;
	move.l	(a7)+,a0                 ;
	rts

 IFEQ	NO_BORDER
***************************************************************
*                                                             *
*               < Here is the no border rout >                *
*                                                             *
***************************************************************
* // Declarations here ...
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

my_hbl:
	rte

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

***************************************************************
*                                                             *
*                Save/Restore System Routines                 *
*                                                             *
***************************************************************
Save_and_init_st:

	moveq #$13,d0                    ; Pause keyboard
	bsr	sendToKeyboard               ;

	move #$2700,sr
		
	lea	Save_all,a0                  ; Save adresses parameters
	move.b	$fffffa01.w,(a0)+        ; Datareg
	move.b	$fffffa03.w,(a0)+        ; Active edge
	move.b	$fffffa05.w,(a0)+        ; Data direction
	move.b	$fffffa07.w,(a0)+        ; Interrupt enable A
	move.b	$fffffa13.w,(a0)+        ; Interupt Mask A
	move.b	$fffffa09.w,(a0)+        ; Interrupt enable B
	move.b	$fffffa15.w,(a0)+        ; Interrupt mask B
	move.b	$fffffa17.w,(a0)+        ; Automatic/software end of interupt
	move.b	$fffffa19.w,(a0)+        ; Timer A control
	move.b	$fffffa1b.w,(a0)+        ; Timer B control
	move.b	$fffffa1d.w,(a0)+        ; Timer C & D control
	move.b	$fffffa27.w,(a0)+        ; Sync character
	move.b	$fffffa29.w,(a0)+        ; USART control
	move.b	$fffffa2b.w,(a0)+        ; Receiver status
	move.b	$fffffa2d.w,(a0)+        ; Transmitter status
	move.b	$fffffa2f.w,(a0)+        ; USART data

	move.b	$ffff8201.w,(a0)+        ; Save screen addresses
	move.b	$ffff8203.w,(a0)+
	move.b	$ffff820a.w,(a0)+
	move.b	$ffff820d.w,(a0)+
	
	lea	Save_rest,a0                 ; Save adresses parameters
	move.l	$068.w,(a0)+             ; HBL
	move.l	$070.w,(a0)+             ; VBL
	move.l	$110.w,(a0)+             ; TIMER D
	move.l	$114.w,(a0)+             ; TIMER C
	move.l	$118.w,(a0)+             ; ACIA
	move.l	$120.w,(a0)+             ; TIMER B
	move.l	$134.w,(a0)+             ; TIMER A
	move.l	$484.w,(a0)+             ; Conterm

	movem.l	$ffff8240.w,d0-d7        ; Save palette GEM system
	movem.l	d0-d7,(a0)

	bclr	#3,$fffffa17.w             ; Stop Timer C

	IFEQ	BOTTOM_BORDER
	clr.b	$fffffa07.w                ; Interrupt enable A (Timer-A & B)
	clr.b	$fffffa09.w                ; Interrupt enable B (Timer-C & D)
	sf	$fffffa21.w                  ; Timer B data (number of scanlines to next interrupt)
	sf	$fffffa1b.w                  ; Timer B control (event mode (HBL))
	lea	Over_rout(pc),a0             ; Launch HBL
	move.l	a0,$120.w                ;
	bset	#0,$fffffa07.w             ; Timer B vector
	bset	#0,$fffffa13.w             ; Timer B on
	ENDC

	IFEQ	TOPBOTTOM_BORDER
	move.b	#%00100000,(iera).w      ; Enable Timer A
	move.b	#%00100000,(imra).w
	and.b	#%00010000,(ierb).w        ; Disable all except Timer D
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
	clr.b	$fffffa07.w                ; Interrupt enable A (Timer-A & B)
	clr.b	$fffffa09.w                ; Interrupt enable B (Timer-C & D)
	ENDC

	stop	#$2300

	clr.b	$484.w                     ; No bip, no repeat

	move	#4,-(sp)                   ; Save & Change Resolution (GetRez)
	trap	#14	                       ; Get Current Res.
	addq.l	#2,sp                    ;
	move	d0,Old_Resol+2             ; Save it

	move	#3,-(sp)                   ; Save Screen Address (Logical)
	trap	#14
	addq.l	#2,sp
	move.l	d0,Old_Screen+2

	moveq #$11,d0                    ; Resume keyboard
	bsr	sendToKeyboard               ;

	moveq #$12,d0                    ; Kill mouse
	bsr	sendToKeyboard               ;

	bsr	flush                        ; Init keyboard

	sf	$ffff8260.w                  ; Basse resolution if you don't use Multi_boot

	rts

Restore_st:

	moveq #$13,d0                    ; Pause keyboard
	bsr	sendToKeyboard               ;

	move #$2700,sr

	jsr	MUSIC+4                      ; Stop SNDH music

	lea       $ffff8800.w,a0         ; Cut sound
	move.l    #$8000000,(a0)         ; Voice A
	move.l    #$9000000,(a0)         ; Voice B
	move.l    #$a000000,(a0)         ; Voice C

	IFEQ	ERROR_SYS
	bsr	OUTPUT_TRACE_ERROR
	ENDC

	lea	Save_all,a0                  ; Restore adresses parameters
	move.b	(a0)+,$fffffa01.w        ; Datareg
	move.b	(a0)+,$fffffa03.w        ; Active edge
	move.b	(a0)+,$fffffa05.w        ; Data direction
	move.b	(a0)+,$fffffa07.w        ; Interrupt enable A
	move.b	(a0)+,$fffffa13.w        ; Interupt Mask A
	move.b	(a0)+,$fffffa09.w        ; Interrupt enable B
	move.b	(a0)+,$fffffa15.w        ; Interrupt mask B
	move.b	(a0)+,$fffffa17.w        ; Automatic/software end of interupt
	move.b	(a0)+,$fffffa19.w        ; Timer A control
	move.b	(a0)+,$fffffa1b.w        ; Timer B control
	move.b	(a0)+,$fffffa1d.w        ; Timer C & D control
	move.b	(a0)+,$fffffa27.w        ; Sync character
	move.b	(a0)+,$fffffa29.w        ; USART control
	move.b	(a0)+,$fffffa2b.w        ; Receiver status
	move.b	(a0)+,$fffffa2d.w        ; Transmitter status
	move.b	(a0)+,$fffffa2f.w        ; USART data
	
	move.b	(a0)+,$ffff8201.w        ; Restore screen addresses
	move.b	(a0)+,$ffff8203.w        ;
	move.b	(a0)+,$ffff820a.w        ;
	move.b	(a0)+,$ffff820d.w        ;
	
	lea	Save_rest,a0                 ; Restore adresses parameters
	move.l	(a0)+,$068.w             ; HBL
	move.l	(a0)+,$070.w             ; VBL
	move.l	(a0)+,$110.w             ; TIMER D
	move.l	(a0)+,$114.w             ; TIMER C
	move.l	(a0)+,$118.w             ; ACIA
	move.l	(a0)+,$120.w             ; TIMER B
	move.l	(a0)+,$134.w             ; TIMER A
	move.l	(a0)+,$484.w             ; Conterm

	movem.l	(a0),d0-d7               ; Restore palette GEM system
	movem.l	d0-d7,$ffff8240.w        ;

	bset.b #3,$fffffa17.w            ; Re-active Timer C

	stop	#$2300

	moveq #$11,d0                    ; Resume keyboard
	bsr	sendToKeyboard               ;

	moveq #$8,d0                     ; Restore mouse
	bsr	sendToKeyboard               ;

	bsr	flush                        ; Init keyboard

Old_Resol:                         ; Restore Old Screen & Resolution
	move	#0,-(sp)                   ;
Old_Screen:                        ;
	move.l	#0,-(sp)                 ;
	move.l	(sp),-(sp)               ;
	move	#5,-(sp)                   ;
	trap	#14                        ;
	lea	12(sp),sp                    ;

	move.w	#$25,-(a7)               ; VSYNC()
	trap	#14                        ;
	addq.w	#2,a7                    ;

	rts

flush:	lea	$FFFFFC00.w,a0
.flush:	move.b	2(a0),d0
	btst	#0,(a0)
	bne.s	.flush
	rts

sendToKeyboard:
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
***************************************************************
*                                                             *
*                    FADING WHITE TO BLACK                    *
*                  (Don't use VBL with it !)                  *
*                                                             *
***************************************************************
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
	moveq     #0,d0                  ; Clear Palette
	moveq     #0,d1                  ;
	moveq     #0,d2                  ;
	moveq     #0,d3                  ;
	moveq     #0,d4                  ;
	moveq     #0,d5                  ;
	moveq     #0,d6                  ;
	moveq     #0,d7                  ;
	movem.l   d0-d7,$ffff8240.w      ;
	rts

wart:	move.l	d0,-(sp)
	move.l	$466.w,d0
.att:	cmp.l	$466.w,d0
	beq.s	.att
	move.l	(sp)+,d0
	rts

	ENDC

***************************************************************
; SUB-ROUTINES                                             // *
***************************************************************

InitDemo:
    movem.l d0-a6,-(sp)

    lea     database(pc),a0
    adda.l  #demoscrolltxt-database,a0
    movea.l a0,a1
    lea     12+fontsdisplayed(a1),a1
    move.l  a1,(a0)+
    clr.l   (a0)+
    clr.l   (a0)+

    bsr     CircleCalcul
    bsr     GenereFonts

    movem.l (sp)+,d0-a6
    rts

fontsdisplayed equ 23

DemoScroll:
; imprime le scrolling
    movea.l physique(pc),a0
    lea	160*38(a0),a0
    lea     database(pc),a1
    adda.l  #wavebuffer-database,a1
    lea     database(pc),a2
    adda.l  #demoscrolltxt-database,a2
    movea.l (a2),a3
    move.l  4(a2),d0
    add.l   #(hauteur*4)*2,d0
    cmp.l   #(hauteur*4)*32,d0
    blt.s   nonewletter
    moveq   #0,d0
    addq.l  #1,a3
    tst.b   (a3)
    bne.s   nonewscroll
    lea     12+fontsdisplayed(a2),a3
nonewscroll:
    move.l  a3,(a2)
nonewletter:
    move.l  d0,4(a2)
    lea     database(pc),a1
    adda.l  #wavebuffer-database,a1
    lea     database(pc),a2
    adda.l  #demoscrolltxt-database,a2
    movea.l (a2),a2
    adda.l  d0,a1
    lea     database(pc),a3
    adda.l  #fontsgenerated-database,a3
    movea.l a1,a4
    moveq   #fontsdisplayed-1,d2
printfont:
    moveq   #0,d0
    move.b  -(a2),d0
    sub.b   #' ',d0
    add.w   d0,d0
    move.w  0(a3,d0.w),d0
    jsr     0(a3,d0.w)
    lea     (hauteur*4)*32(a4),a4
    movea.l a4,a1
    dbra    d2,printfont
    rts


; routine qui precalcule la courbe decrite par le scrolling
TablePlot:
    dc.w 1,2,4,8,16,32,64,128
    dc.w 256,512,1024,2048,4096,8192,16384,32768
CircleCalcul:
    lea     database(pc),a0
    adda.l  #democosinus-database,a0
    lea     database(pc),a1
    adda.l  #demosinus-database,a1
    lea     database(pc),a2
    adda.l  #wavebuffer-database,a2
    move.w  #719,d7
calcul0:
    moveq   #0,d0
    move.w  (a0)+,d0
    moveq   #0,d1
    move.w  (a1)+,d1
    moveq   #hauteur-1,d6
calcul1:
    move.l  d0,d2
    move.l  #85,d5
    add.w   d6,d5
    muls    d5,d2
    lsl.l   #2,d2
    clr.w   d2
    swap    d2
    move.l  d2,d3
    ext.l   d3
    lsr.l   #4,d3
    lsl.l   #3,d3
    and.w   #$0f,d2
    neg.b   d2
    add.b   #15,d2
    add.w   d2,d2
    move.w  TablePlot(pc,d2.w),d2
    swap    d2
    move.w  d3,d2
    move.l  d1,d3
    move.l  #85,d5
    add.w   d6,d5
    muls    d5,d3
    lsl.l   #2,d3
    clr.w   d3
    swap    d3
    ext.l   d3
    muls    #160,d3
    add.w   #80+99*160,d3
    add.w   d2,d3
    move.w  d3,(a2)+
    swap    d2
    move.w  d2,(a2)+
    dbra    d6,calcul1
    dbra    d7,calcul0
; cree un effet de disparition et d'effacement des caracteres
    move.w  #25*12-1,d0
fill1:
    clr.l   (a2)+
    dbra    d0,fill1
    lea     database(pc),a0
    adda.l  #wavebuffer-database,a0
    move.w  #26*2,d0
rnd0:
    clr.w   2(a0)
    addq.l  #8,a0
    clr.w   2(a0)
    addq.l  #4,a0
    clr.w   2(a0)
    addq.l  #8,a0
    dbra    d0,rnd0
    lea     database(pc),a0
    adda.l  #wavebuffer-database+33520,a0
    move.w  #26*2,d0
rnd1:
    clr.w   2(a0)
    addq.l  #8,a0
    clr.w   2(a0)
    addq.l  #4,a0
    clr.w   2(a0)
    addq.l  #8,a0
    dbra    d0,rnd1
    rts

; genere le code de fonts 1 plan (-90ø) de 16 de large et de x de hauteur
; ici, on sait que les 4 premieres colonnes des fonts sont vides.
nbrfonts equ 59
hauteur equ 12
largeur equ 13

GenereFonts:
    lea     database(pc),a0
    adda.l  #fontsgraphix-database,a0
    lea     database(pc),a1
    adda.l  #fontsgenerated-database,a1
    lea     nbrfonts*2(a1),a2
    moveq   #nbrfonts-1,d0
gen1font:
    lea     database(pc),a3
    adda.l  #fontsgenerated-database,a3
    move.l  a3,d4
    neg.l   d4
    add.l   a2,d4
    move.w  d4,(a1)+
;codefont-fontsgenerated
    moveq   #0,d4
    moveq   #largeur-1,d1
gen1line:
    move.w  (a0)+,d3
    moveq   #hauteur-1,d2
gen1column:
    roxr.w  #1,d3
    bcc.s   nopixel
    tst.w   d4
    beq.s   addok
    cmp.w   #4,d4
    bne.s   add8
    move.w  #$5889,(a2)+
;addq.l #4,a1
    bra.s   addok
add8:cmp.w  #8,d4
    bne.s   addw
    move.w  #$5089,(a2)+
;addq.l #8,a1
    bra.s   addok
addw:cmp.w  #8,d4
    bmi.s   addw
    move.w  #$43e9,(a2)+
;lea xxxx(a1),a1
    move.w  d4,(a2)+
;xxxx
addok:moveq #0,d4
    move.l  #$30193219,(a2)+
;move.w (a1)+,d0/move.w (a1)+,d1
    move.l  #$83700000,(a2)+
;or.w d1,(a0,d0.w)
    bra.s   gen1columnend
nopixel:
    addq.w  #4,d4
gen1columnend:
    dbra    d2,gen1column
    dbra    d1,gen1line
    move.w  #$4e75,(a2)+
;rts
    dbra    d0,gen1font

    lea     database(pc),a0
    adda.l  #fontsgraphix-database,a0
    lea     database(pc),a1
    adda.l  #fontsclrgenerated-database,a1
    lea     nbrfonts*2(a1),a2
    moveq   #nbrfonts-1,d0
gen1fontclr:
    lea     database(pc),a3
    adda.l  #fontsclrgenerated-database,a3
    move.l  a3,d4
    neg.l   d4
    add.l   a2,d4
    move.w  d4,(a1)+
;codefontclr-fontsclrgenerated
    moveq   #0,d4
    moveq   #largeur-1,d1
gen1lineclr:
    move.w  (a0)+,d3
    moveq   #hauteur-1,d2
gen1columnclr:
    roxr.w  #1,d3
    bcc.s   nopixelclr
    move.w  #$3029,(a2)+
;move.w xxxx(a1),d0
    move.w  d4,(a2)+
;xxxx
    move.l  #$31810000,(a2)+
;move.w d1,(a0,d0.w)
nopixelclr:
    addq.w  #4,d4
    dbra    d2,gen1columnclr
    dbra    d1,gen1lineclr
    move.w  #$4e75,(a2)+
;rts
    dbra    d0,gen1fontclr
    rts

*********************************************************************
*                   TEXTE FONT 8*8 ONE BITPLANE                     *
*********************************************************************
CHARS      equ 40  ; chars per line, 80=for med res, 40 for low res *
LINES      equ 33  ; 33 for 8x8 font, 45 with 6x6 font              *
FONTSIZE   equ 8   ; 8=8x8, 6=6x6 font                              *
SHIFTSIZE  equ 4   ; 2=MED RESOLUTION, 4=LOW RESOLUTION             *
*********************************************************************
print_text:     clr.w   x_curs
                clr.l   x_offset
                clr.l   y_offset
                lea     message,a2
new_char:       bsr     _x_conversion
                moveq   #0,d0    
                move.b  (a2)+,d0	;if zero, stop routine
                cmp.b   #0,d0
                beq     LF
.test_plan_1:   cmpi.b  #$fd,d0 ; plan #0
                bne.s   .test_plan_2
                move.w  #0,pointeur_plan
                bra.s   new_char
                bra.s   .fin_de_ligne
.test_plan_2:   cmpi.b  #$fc,d0 ; plan #1
                bne.s   .fin_de_ligne
                move.w  #4,pointeur_plan
                bra.s   new_char
.fin_de_ligne:  cmpi.b  #$ff,d0
                bne.s   process_char
                rts

process_char:   asl.w   #3,d0                ; valeur * 8
                lea     fonts,a1
                sub.w   #256,d0
                adda.w  d0,a1

pas equ 4
                movea.l physique(pc),a0
                lea     61*160+8*pas+2(a0),a0
                adda.w  pointeur_plan,a0
                adda.l  y_offset,a0
                adda.l  x_offset,a0
                
                movea.l physique+4(pc),a3
                lea     61*160+8*pas+2(a3),a3
                adda.w  pointeur_plan,a3
                adda.l  y_offset,a3
                adda.l  x_offset,a3

                rept	FONTSIZE               ; Copy letter
                move.b  (a1),(a0)
                move.b  (a1)+,(a3)
                lea     160(a0),a0
                lea     160(a3),a3
                endr
                
                addq.w  #1,x_curs           
                cmpi.w  #CHARS,x_curs        ; 79 for MED res
                bls     new_char
                move.w  #CHARS,x_curs        ; 79 for MED res
                bra     new_char

LF:             clr.w   x_curs               ; back to first char
                addi.l  #FONTSIZE*160+160,y_offset ; linefeed when reached ',0'
                cmpi.l  #LINES*FONTSIZE*160,y_offset
                bls     new_char
                move.l  #LINES*FONTSIZE*160,y_offset
                bra     new_char

_x_conversion:  move.w  x_curs,d0
                and.l   #$ffff,d0
                btst    #0,d0
                beq.s   _even
                subq.w  #1,d0
                mulu    #SHIFTSIZE,d0        ; 2=med res, 4=low
                addq.w  #1,d0
                bra     _done_conv
_even:          mulu    #SHIFTSIZE,d0        ; 2=med res, 4=low
_done_conv:     move.l  d0,x_offset
                rts

; Clear last plane of screen - reasonably quickly...

Cls_1_plan:
	move.l	physique(pc),a0
	lea	160*41+4*8(a0),a0
	moveq	#0,d0
	jsr Code_gen
	rts

* Clear last plane of screen - reasonably quickly...
NB_LIGNE_GENERE	equ	191
NB_BLOC_SUPP	equ	12

Genere_code_cls:
	lea Code_gen,a0
	move.w	#NB_LIGNE_GENERE,d7
	moveq	#0,d4
Genere_pour_toutes_les_lignes:	
	moveq	#NB_BLOC_SUPP,d6
	move.w	d4,d5
	add.w	#PLANcls,d5 * position du cadre
Genere_une_ligne:
	move.w	#$3140,(a0)+		 * Genere un move.w  d0,$xx(a0)
	move.w	d5,(a0)+				 * et voila l'offset $xx
	addq.w	#8,d5            * pixel suivant
	dbra	d6,Genere_une_ligne
	add.w	#160,d4            * ligne suivante
	dbra	d7,Genere_pour_toutes_les_lignes
	move.w	#$4e75,(a0)			 * Et un RTS !!
	rts

***************************************************************
 SECTION	DATA                                             // *
***************************************************************

pal_scroll equ $0fff	;$079b
Default_palette:
	dc.w	$03C6,pal_scroll,$0eef,$0eef,$0eef,$0000,$0FF7,$0667
	dc.w	$0edf,$0EEF,$0C56,$07EF,$0BCD,$00FF,$0DDE,$0FF7

* Full data here :
* >

message:
	DC.B      $fd ; en 1er plan
	DC.B      "NOEXTRA PRESENTS IN 2014",0,0
	DC.B      "        GAME NAME",0
	DC.B      "     (C)COMPANY NAME",0,0
	DC.B      "CRACKED BY......",$fc,"MAARTAU",$fd,0
	DC.B      "CODE............",$fc,"ZORRO 2",$fd,0
	DC.B      "GFX.............",$fc,"MISTER.A",$fd,0
	DC.B      "MUSIC...........",$fc,"BIG ALEC",$fd,0
	DC.B      "SUPPLIER........",$fc,"AL-TEAM",$fd,0,0
	DC.B      "GREETS:DHS.DBUG.ELITE.",0
	DC.B      "ICS.RG.PARADIZE.TSCC.",0
	DC.B      "ZUUL.POV.PULSION.HMD.",0
	DC.B      "IMPACT.EUROSWAP.STAX.",0
	DC.B      "ST KNIGHTS.CV.SECTOR ONE",0
	DC.B      "FUZION.LEMMINGS.XTROLL.",$ff
	even
fonts:
	incbin	"FONT891.DAT"
	even

database:
democosinus:
    incbin 'COSINUS.CNX'
demosinus:
    incbin 'SINUS.CNX'
demoscrolltxt:
    dc.l 0,0,0
    dcb.b fontsdisplayed,' '

    dc.b " !",$22,"$'(),-.0123456789:;?ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    dcb.b fontsdisplayed,' '
    dc.w 0
    even

fontsgraphix:
;cette police de caractŠre a ‚t‚ dessin‚e
;par Arjarn/The Vegetables que je tiens
;… remercier.
    ds.w 13
    dc.w $0,$0,$00,$00,$00,$0dff,$0dff,$00,$00,$00,$00,$00,$00
    dc.w $00,$00,$00,$00,$00,$0f,$00,$0f,$00,$00,$00,$00,$00
    ds.w 13
    dc.w $0c00,$0c00,$0e00,$0780,$01ff,$00,$0fff,$00,$01ff,$0780,$0e00,$0c00,$0c00
    ds.w 26
    dc.w $00,$00,$00,$00,$00,$00,$0f,$00,$00,$00,$00,$00,$00
    dc.w $0801,$0801,$0402,$030c,$f0,$00,$00,$00,$00,$00,$00,$00,$00
    dc.w $00,$00,$00,$00,$00,$00,$00,$00,$f0,$030c,$0402,$0801,$0801
    ds.w 26
    dc.w $00,$00,$00,$00,$0600,$0800,$00,$00,$00,$00,$00,$00,$00
    dc.w $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    dc.w $00,$00,$00,$00,$0600,$0600,$00,$00,$00,$00,$00,$00,$00
    ds.w 13
    dc.w $f0,$030c,$0402,$0402,$0801,$0801,$0801,$0801,$0801,$0402,$0402,$030c,$f0
    dc.w $00,$00,$00,$00,$0800,$0800,$0fff,$0802,$0804,$00,$00,$00,$00
    dc.w $080c,$0812,$0821,$0821,$0841,$0841,$0881,$0901,$0901,$0a01,$0a02,$0c0c,$00
    dc.w $01d8,$0224,$0422,$0422,$0422,$0821,$0801,$0801,$0801,$0801,$0801,$0402,$00
    dc.w $80,$80,$80,$80,$0fe0,$81,$82,$84,$88,$90,$a0,$c0,$80
    dc.w $01c1,$0221,$0421,$0421,$0821,$0821,$0821,$0821,$0821,$0821,$0821,$0821,$083f
    dc.w $01c0,$0221,$0421,$0421,$0821,$0821,$0821,$0821,$0821,$0821,$0821,$0422,$03fc
    dc.w $13,$15,$19,$11,$31,$51,$91,$0f01,$01,$01,$01,$01,$07
    dc.w $0380,$0440,$082e,$0831,$0821,$0821,$0821,$0821,$0821,$0831,$082e,$0440,$0380
    dc.w $01fc,$0222,$0421,$0421,$0421,$0821,$0821,$0821,$0821,$0821,$0821,$0813,$040c
    dc.w $00,$00,$00,$00,$00,$060c,$060c,$00,$00,$00,$00,$00,$00
    dc.w $00,$00,$00,$00,$06c0,$08c0,$00,$00,$00,$00,$00,$00,$00
    ds.w 39
    dc.w $0c,$12,$21,$21,$41,$0d81,$01,$01,$01,$02,$0c,$00,$00
    ds.w 13
    dc.w $0800,$0fff,$0882,$84,$88,$90,$a0,$c0,$80,$0100,$0a00,$0c00,$0800
    dc.w $0380,$0440,$0820,$082c,$0832,$0821,$0821,$0821,$0821,$0821,$0821,$0fff,$0801
    dc.w $0606,$0402,$0402,$0801,$0801,$0801,$0801,$0801,$0801,$0402,$0402,$030c,$f0
    dc.w $60,$0198,$0204,$0402,$0402,$0801,$0801,$0801,$0801,$0801,$0801,$0fff,$0801
    dc.w $0c03,$0801,$0801,$0801,$0871,$0821,$0821,$0821,$0821,$0821,$0821,$0fff,$0801
    dc.w $03,$01,$01,$01,$71,$21,$21,$21,$21,$21,$0821,$0fff,$0801
    dc.w $c0,$0344,$0442,$0442,$0801,$0801,$0801,$0801,$0801,$0402,$0402,$030c,$f0
    dc.w $0801,$0fff,$0821,$20,$20,$20,$20,$20,$20,$20,$0821,$0fff,$0801
    dc.w $00,$00,$00,$00,$0801,$0801,$0fff,$0801,$0801,$00,$00,$00,$00
    dc.w $01,$01,$03ff,$0401,$0801,$0800,$0800,$0800,$0800,$0800,$0480,$0380,$80
    dc.w $0800,$0800,$0c01,$0202,$0104,$88,$50,$20,$40,$0881,$0fff,$0801,$00
    dc.w $0c00,$0800,$0800,$0800,$0800,$0800,$0800,$0800,$0800,$0800,$0800,$0fff,$0801
    dc.w $0801,$0fff,$0801,$02,$04,$08,$10,$08,$04,$02,$0801,$0fff,$0801
    dc.w $0fff,$0401,$0200,$0100,$80,$40,$20,$10,$08,$04,$0802,$0fff,$0801
    dc.w $f0,$030c,$0402,$0402,$0801,$0801,$0801,$0801,$0801,$0402,$0402,$030c,$f0
    dc.w $00,$00,$1c,$22,$41,$41,$41,$41,$41,$41,$0841,$0fff,$0801
    dc.w $08f0,$070c,$0602,$0502,$0801,$0801,$0801,$0801,$0801,$0402,$0402,$030c,$f0
    dc.w $0800,$0800,$0c1c,$0222,$0141,$c1,$41,$41,$41,$41,$0841,$0fff,$0801
    dc.w $0383,$0441,$0821,$0821,$0821,$0821,$0821,$0821,$0821,$0821,$0821,$0812,$0c0c
    dc.w $03,$01,$01,$01,$01,$0801,$0fff,$0801,$01,$01,$01,$01,$03
    dc.w $01,$03ff,$0401,$0800,$0800,$0800,$0800,$0800,$0800,$0800,$0401,$03ff,$01
    dc.w $01,$03,$0d,$30,$c0,$0300,$0c00,$0300,$c0,$30,$0d,$03,$01
    dc.w $0801,$0fff,$0801,$0400,$0200,$0100,$80,$0100,$0200,$0400,$0801,$0fff,$0801
    dc.w $0801,$0803,$0c04,$0208,$0110,$a0,$40,$a0,$0110,$0208,$0c04,$0803,$0801
    dc.w $01,$03,$04,$08,$10,$0820,$0fc0,$0820,$10,$08,$04,$03,$01
    dc.w $0c00,$0801,$0803,$0805,$0809,$0811,$0821,$0841,$0881,$0901,$0a01,$0c01,$0803

Colonnes:
	incbin	"COL-HAUT.IMG"
	incbin	"COL-BAS.IMG"
	even


* <

MUSIC:	* SNDH music -> Not compressed please !!!
	incbin	"*.SND"
	even

***************************************************************
 SECTION	BSS                                              // *
***************************************************************

bss_start:

* < Full data here >
x_curs:
	ds.l 1
y_offset:
	ds.l 1
x_offset:
	ds.l 1
pointeur_plan:
	ds.w 1

fontsgenerated:
    ds.w nbrfonts
    ds.l 3600
fontsclrgenerated:
    ds.w nbrfonts
    ds.l 2900
wavebuffer:
    ds.l (720+80)*hauteur

Code_gen:         ds.w	(2*NB_BLOC_SUPP)*NB_LIGNE_GENERE		* Place pour le code genere
									   									* pour l'effacement de l'elt 3d
								  ds.w	1							* Place pour le rts
rien            	ds.b	10000
* <
Vsync:
	ds.w	1

Save_stack:
	ds.l	1

Save_all:
	ds.b	16 * MFP
	ds.b	4	 * Video : f8201.w -> f820d.w

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
	ds.w	16 * Palette System

bss_end:

Screen_1:
	ds.b	256
	ds.b	SIZE_OF_SCREEN
Screen_2:
	ds.b	256
	ds.b	SIZE_OF_SCREEN

***************************************************************
	SECTION	TEXT                                             // *
***************************************************************

	IFEQ	ERROR_SYS
***************************************************************
*                                                             *
*               Error Routines (Dbug 2/Next)                  *
*          http://www.defence-force.org/index.htm             *
*                                                             *
***************************************************************
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
*                                                                         *
* Multi Atari Boot code.                                                  *
* If you have done an ST demo, use that boot to run it on these machines: *
* ST, STe, Mega-ST,TT,Falcon,CT60                                         *
* More info:                                                              *
* http://leonard.oxg.free.fr/articles/multi_atari/multi_atari.html        *
*                                                                         *
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
; => here TT or FALCON

 IFEQ TEST_STE
; Mode STE on Falcon
	bclr.b	#5,$FFFF8007.w
; Blitter at 8Mhz
	bclr.b	#2,$FFFF8007.w
 ENDC

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
	END                                                         // *
******************************************************************
