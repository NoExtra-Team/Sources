***************************************
* // EXTRA_V7.PRG                  // *
***************************************
* // Asm Intro Code Atari ST v0.44 // *
* // by Zorro 2/NoExtra (01/12/16) // *
* // http://www.noextra-team.com/  // *
***************************************
* // Original code : Zorro 2       // *
* // Gfx logo      : n/a           // *
* // Gfx font      : Mister.A      // *
* // Music         : JEDI          // *
* // Release date  : 03/10/2016    // *
* // Update date   : 09/01/2017    // *
***************************************
  OPT c+ ; Case sensitivity ON        *
  OPT d- ; Debug OFF                  *
  OPT o- ; All optimisations OFF      *
  OPT w- ; Warnings OFF               *
  OPT x- ; Extended debug OFF         *
***************************************

***************************************************************
	SECTION	TEXT                                           // *
***************************************************************

************************* OVERSCAN MODE ******************************
BOTTOM_BORDER    equ 1           ; Use the bottom overscan           *
TOPBOTTOM_BORDER equ 1           ; Use the top and bottom overscan   *
NO_BORDER        equ 0           ; Use a standard Low-screen         *
***************************** SCREENS ********************************
PATTERN          equ $00000000   ; Fill Screens with a plan pattern  *
ONE_SCREEN       equ 0           ; One Screen used                   *
TWO_SCREENS      equ 1           ; Two Screens used                  *
NB_OF_SCREEN     equ ONE_SCREEN  ; Number of Screen used             *
*************************** PARAMETERS *******************************
SEEMYVBL         equ 1           ; See CPU used if you press ALT key *
ERROR_SYS        equ 1           ; Manage Errors System              *
FADE_INTRO       equ 1           ; Fade White to black palette       *
TEST_STE         equ 1           ; Code only for Atari STE machine   *
STF_INITS        equ 0           ; STF compatibility MODE            *
**********************************************************************
*              Notes : 0 = I use it / 1 = no need !                  *
**********************************************************************

Begin:
	move    SR,d0                    ; Test supervisor mode detected ?
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
	lea     12(sp),sp                ;

	clr.l   -(sp)                    ; Supervisor mode set
	move.w  #32,-(sp)                ;
	trap    #1                       ;
	addq.l  #6,sp                    ;
	move.l  d0,Save_stack            ; Save adress of stack
mode_super_yet:

 IFEQ TEST_STE
	move.l	$5a0,a0                  ; Test if STE computer
	cmp.l	#$0,a0                     ;
	beq	EXIT_PRG                     ; No cookie_jar inside an old ST
	move.l	$14(a0),d0               ;
	cmp.l	#$0,d0                     ; _MCH=0 then it's an ST-STF-STFM
	beq	EXIT_PRG                     ;
 ENDC

	bsr	clear_bss                    ; Clean BSS stack
	
	bsr	Save_and_init_st             ; Save system parameters

	bsr	Init_screens                 ; Screen initialisations

 IFEQ STF_INITS
	jsr	Multi_boot                   ; Multi Atari Boot code from LEONARD/OXG
 ENDC

	bsr	Inits                        ; Other Initialisations

**************************** MAIN LOOP ************************>

  move.l	#Buffer_l7z,a0

default_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

 IFEQ	SEEMYVBL
	clr.b $ffff8240.w                ; init line of CPU
 ENDC

* < Put your code here >

	bsr	display_tunnel
	bsr	miniscroll

; Seek Function Key from the keyboard (59 .. 68 / $3B .. $44)
	moveq	#0,d0
	move.l	#1,$40.w                 ; ESCAPE Key setted by default
	moveq	#59,d1                     ;
	move.b	$fffffc02.w,d0
	cmp.b	#59,d0                     ; F1 .. F10 pressed ?
	blt.s	.noFunctionKey
	cmp.b	#68,d0
	bgt.s	.noFunctionKey
.loopF:                            ; Yep !
	add.l	#1,$40.w
	cmp.b	d0,d1
	beq.w	ESCAPE_PRG                 ; Find it !
	add		#1,d1
	bra.s	.loopF
.noFunctionKey:

* <

 IFGT NB_OF_SCREEN                 * Test if more than one Screen
	lea     physique(pc),a0          ; Swapping Screens
	move.l	(a0),d0                  ;
	move.l	4(a0),(a0)+              ;
	move.l	d0,(a0)                  ;
	move.b  d0,$ffff820d.w           ;
	move    d0,-(sp)                 ;
	move.b  (sp)+,d0                 ;
	move.l  d0,$ffff8200.w           ;
 ENDC

 IFEQ	SEEMYVBL
	cmp.b #$38,$fffffc02.w           ; ALT key pressed ?
	bne.s .next_key                  ;
	move.b	#7,$ffff8240.w           ; See the rest of CPU (pink color used)
.next_key:                         ;
 ENDC

	cmp.b	#$1,$fffffc02.w            ; ESCAPE Key pressed ?
	beq.s	ESCAPE_PRG

	bra	default_loop

**************************** MAIN LOOP ************************<

ESCAPE_PRG:
	bsr	Restore_st                   ; Restore all registers

EXIT_PRG:
	move.l  Save_stack,-(sp)         ; Restore adress of stack
	move.w  #32,-(sp)                ; Restore user Mode
	trap    #1                       ;
	addq.l  #6,sp                    ;

	clr.w   -(sp)                    ; Pterm()
	trap    #1                       ; EXIT program

***************************************************************
*                                                             *
*                 Initialisations Routines                    *
*                                                             *
***************************************************************
Inits:
	movem.l	d0-d7/a0-a6,-(a7)

 IFEQ	FADE_INTRO
	bsr	fadein                       ; Fading White to Black Screen
 ENDC

	clr.l   $40.w                    ; Clean n° of intro if there are !

	bsr	init_miniscroll              ; Inits...
	bsr	Init_tunnel

	moveq #1,d0                      ; Choice of the music (1 is default)
	jsr	MUSIC+0                      ; Init SNDH music

	lea	Vbl(pc),a0                   ; Launch VBL
	move.l	a0,$70.w                 ;

	lea	Default_palette,a0           ; Put Default palette
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d7               ;
	movem.l	d0-d7,(a1)               ;

	bsr	print_text                   ; Display text

	movem.l	(a7)+,d0-d7/a0-a6
	rts

***************************************************************
*                                                             *
*                       Screen Routines                       *
*                                                             *
***************************************************************
 IFEQ	BOTTOM_BORDER
SIZE_OF_SCREEN equ 160*250         ; Size of Screen + Lower Border Size
 ENDC
 IFEQ	TOPBOTTOM_BORDER
SIZE_OF_SCREEN equ 160*300         ; Size of Screen + Top & Lower Border Size
 ENDC
 IFEQ	NO_BORDER
SIZE_OF_SCREEN equ 160*200         ; Only Screen Size in Low Resolution
 ENDC

Init_screens:
	movem.l	d0-d7/a0-a6,-(a7)

	move.l #Screen+256,d0            ; Set physical Screen #1
	clr.b d0                         ;
	move.l d0,physique               ;

	move.l	physique(pc),a0          ; Fill PATTERN in Screen #1
	move.w  #(SIZE_OF_SCREEN)/4-1,d7 ;
	move.l  #PATTERN,(a0)+           ;
	dbf	    d7,*-6                   ;

 IFGT NB_OF_SCREEN                 * Test if more than one Screen
	add.l #SIZE_OF_SCREEN,d0         ; Set logical Screen #2
	clr.b d0                         ;
	move.l d0,physique+4             ;

	move.l	physique+4(pc),a0        ; Fill PATTERN in Screen #2
	move.w  #(SIZE_OF_SCREEN)/4-1,d7 ;
	move.l  #PATTERN,(a0)+           ;
	dbf	    d7,*-6                   ;
 ENDC

 IFEQ NB_OF_SCREEN                 * Test if one Screen to display
	move.l	physique(pc),d0          ; Put physical Screen
	move.b	d0,d1                    ;
	lsr.w #8,d0                      ;
	move.b	d0,$ffff8203.w           ;
	swap d0                          ;
	move.b	d0,$ffff8201.w           ;
	move.b	d1,$ffff820d.w           ;
 ENDC

	movem.l	(a7)+,d0-d7/a0-a6
	rts

physique:
	ds.l (NB_OF_SCREEN+1)            ; Number of screens declared

***************************************************************
*                                                             *
*                        Vbl Routines                         *
*                                                             *
***************************************************************
Vbl:
	st	Vsync                        ; Synchronisation

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
	clr.b (tacr).w                   ; Stop timer A
	lea	topbord(pc),a0               ; Launch HBL
	move.l	a0,$134.w                ; Timer A vector
	move.b	#99,(tadr).w             ; Countdown value for timer A
	move.b	#4,(tacr).w              ; Delay mode, clock divided by 50
	move.l	(a7)+,a0
 ENDC

 IFEQ	NO_BORDER
	CLR.B   $FFFFFA1B.W              ; Timer B off
	MOVE.L    #HBL_blanc,$120.W      ; Go Timer B !
	MOVE.B    #1,$FFFFFA21.W        ; First position
	MOVE.B    #8,$FFFFFA1B.W
 ENDC

	movem.l	(a7)+,d0-d7/a0-a6
	rte

Wait_vbl:
	move.l	a0,-(a7)                 ; Test Synchronisation
	lea	Vsync,a0                     ;
	sf	(a0)                         ;
.loop:	tst.b	(a0)                 ;
	beq.s .loop                      ;
	move.l	(a7)+,a0                 ;
	rts

 IFEQ	NO_BORDER
***************************************************************
*                                                             *
*               < Here is the no border rout >                *
*                                                             *
***************************************************************
COULEUR equ $08ae/2

HBL_blanc:
	CLR.B     $FFFFFA1B.W
	MOVE.w    #COULEUR,$ffff8240.w
	MOVE.L    #HBL_1,$120.W 
	MOVE.B    #1,$FFFFFA21.W 
	MOVE.B    #8,$FFFFFA1B.W
	RTE 

HBL_1:
	CLR.B     $FFFFFA1B.W
	MOVE.L    #$0020003,$ffff8240.w
	MOVE.L    #HBL_1bis,$120.W 
	MOVE.B    #100-3,$FFFFFA21.W 
	MOVE.B    #8,$FFFFFA1B.W
	RTE

HBL_1bis:
	CLR.B     $FFFFFA1B.W
	MOVE.L    #$0020004,$ffff8240.w
	MOVE.L    #HBL_2,$120.W 
	MOVE.B    #100-2,$FFFFFA21.W 
	MOVE.B    #8,$FFFFFA1B.W
	RTE

HBL_2:
	CLR.B     $FFFFFA1B.W
	MOVE.w    #COULEUR,$ffff8240.w
	MOVE.L    #HBL_end,$120.W 
	MOVE.B    #1,$FFFFFA21.W 
	MOVE.B    #8,$FFFFFA1B.W
	RTE 

HBL_end:
	CLR.B     $FFFFFA1B.W
	MOVE.b    #0,$ffff8240.w
	BCLR      #0,$FFFFFA0F.W
	jsr 	(MUSIC+8)                  ; Play SNDH music
	rte
 ENDC

 IFEQ	BOTTOM_BORDER
***************************************************************
*                                                             *
*             < Here is the lower border rout >               *
*                                                             *
***************************************************************
Over_rout:
	sf $fffffa21.w                   ; Stop Timer B
	sf $fffffa1b.w                   ;
	dcb.w 95,$4e71                   ; 95 nops - Wait line end
	sf	$ffff820a.w                  ; Modif Frequency 60 Hz !
	dcb.w 28,$4e71                   ; 28 nops - Wait line end
	move.b #$2,$ffff820a.w           ; 50 Hz !
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
imra = $FFFFFA13
imrb = $FFFFFA15
tacr = $FFFFFA19
tadr = $FFFFFA1F

topbord:
	move.l	a0,-(a7)
	move #$2100,SR
	stop #$2100                    ; Sync with interrupt
	clr.b (tacr).w                 ; Stop timer A
	dcb.w 78,$4E71                 ; 78 nops
	clr.b (herz).w                 ; 60 Hz
	dcb.w 18,$4E71                 ; 18 nops
	move.b #2,(herz).w             ; 50 Hz
	lea	botbord(pc),a0
	move.l a0,$134.w               ; Timer A vector
	move.b #178,(tadr).w           ; Countdown value for timer A
	move.b #7,(tacr).w             ; Delay mode, clock divided by 200
	move.l (a7)+,a0                ;
	bclr.b #5,(isra).w             ; Clear end of interrupt flag
my_hbl:
	rte

botbord:
	move #$2100,SR                 ;
	stop #$2100                    ; sync with interrupt
	clr.b (tacr).w                 ; stop timer A
	dcb.w 78,$4E71                 ; 78 nops
	clr.b (herz).w                 ; 60 Hz
	dcb.w 18,$4E71                 ; 18 nops
	move.b #2,(herz).w             ; 50 Hz
	bclr.b #5,(isra).w             ;
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

	move #$2700,SR                   ; Interrupts OFF
		
	lea	Save_all,a0                  ; Save adresses parameters
	move.b $fffffa01.w,(a0)+         ; Datareg
	move.b $fffffa03.w,(a0)+         ; Active edge
	move.b $fffffa05.w,(a0)+         ; Data direction
	move.b $fffffa07.w,(a0)+         ; Interrupt enable A
	move.b $fffffa13.w,(a0)+         ; Interupt Mask A
	move.b $fffffa09.w,(a0)+         ; Interrupt enable B
	move.b $fffffa15.w,(a0)+         ; Interrupt mask B
	move.b $fffffa17.w,(a0)+         ; Automatic/software end of Interupt
	move.b $fffffa19.w,(a0)+         ; Timer A control
	move.b $fffffa1b.w,(a0)+         ; Timer B control
	move.b $fffffa1d.w,(a0)+         ; Timer C & D control
	move.b $fffffa27.w,(a0)+         ; Sync character
	move.b $fffffa29.w,(a0)+         ; USART control
	move.b $fffffa2b.w,(a0)+         ; Receiver status
	move.b $fffffa2d.w,(a0)+         ; Transmitter status
	move.b $fffffa2f.w,(a0)+         ; USART data
          
	move.b $ffff8201.w,(a0)+         ; Save Video addresses
	move.b $ffff8203.w,(a0)+         ;
	move.b $ffff820a.w,(a0)+         ;
	move.b $ffff820d.w,(a0)+         ;
	
	lea	Save_rest,a0                 ; Save adresses parameters
	move.l $068.w,(a0)+              ; HBL
	move.l $070.w,(a0)+              ; VBL
	move.l $110.w,(a0)+              ; TIMER D
	move.l $114.w,(a0)+              ; TIMER C
	move.l $118.w,(a0)+              ; ACIA
	move.l $120.w,(a0)+              ; TIMER B
	move.l $134.w,(a0)+              ; TIMER A
	move.l $484.w,(a0)+              ; Conterm

	movem.l	$ffff8240.w,d0-d7        ; Save palette GEM system
	movem.l	d0-d7,(a0)

 IFEQ	ERROR_SYS
	bsr	INPUT_TRACE_ERROR            ; Save vectors list
 ENDC

	clr.b $fffffa07.w                ; Interrupt enable A (Timer-A & B)
	clr.b $fffffa09.w                ; Interrupt enable B (Timer-C & D)
	clr.b $fffffa13.w                ; Interrupt mask A (Timer-A & B)
	clr.b $fffffa15.w                ; Interrupt mask B (Timer-C & D)
	clr.b $fffffa19.w                ; Stop Timer A
	clr.b $fffffa1b.w                ; Stop Timer B
	clr.b $fffffa21.w                ; Timer B data at zero
	clr.b $fffffa1d.w                ; Stop Timer C & D

 IFEQ	BOTTOM_BORDER
	sf $fffffa21.w                   ; Timer B data (number of scanlines to next interrupt)
	sf $fffffa1b.w                   ; Timer B control (event mode (HBL))
	lea	Over_rout(pc),a0             ; Launch HBL
	move.l a0,$120.w                 ;
	bset #0,$fffffa07.w              ; Timer B vector
	bset #0,$fffffa13.w              ; Timer B on
	bclr #3,$fffffa17.w              ; Automatic End-Interrupt hbl ON
 ENDC

 IFEQ	TOPBOTTOM_BORDER
	move.b #%00100000,(iera).w       ; Enable Timer A
	move.b #%00100000,(imra).w       ;
	and.b #%00010000,(ierb).w        ; Disable all except Timer D
	and.b #%00010000,(imrb).w        ;
	or.b #%01000000,(ierb).w         ; Enable keyboard
	or.b #%01000000,(imrb).w         ;
	clr.b (tacr).w                   ; Timer A off
	lea	my_hbl(pc),a0                ;
	move.l	a0,$68.w                 ; Horizontal blank
	lea	topbord(pc),a0               ;
	move.l a0,$134.w                 ; Timer A vector
	bclr #3,$fffffa17.w              ; Automatic End-Interrupt hbl ON
 ENDC

 IFEQ	NO_BORDER
	clr.b	$fffffa07.w                ; Interrupt enable A (Timer-A & B)
	clr.b	$fffffa09.w                ; Interrupt enable B (Timer-C & D)
	sf	$fffffa21.w                  ; Timer B data (number of scanlines to next interrupt)
	sf	$fffffa1b.w                  ; Timer B control (event mode (HBL))
	lea	HBL_blanc(pc),a0             ; Launch HBL
	move.l	a0,$120.w                ;
	bset	#0,$fffffa07.w             ; Timer B vector
	bset	#0,$fffffa13.w             ; Timer B on
	bclr #3,$fffffa17.w              ; Automatic End-Interrupt hbl ON
 ENDC

	stop #$2300                      ; Interrupts ON

	clr.b $484.w                     ; No bip, no repeat

	move #4,-(sp)                    ; Save & Change Resolution (GetRez)
	trap #14	                     ; Get Current Res.
	addq.l #2,sp                     ;
	move d0,Old_Resol+2              ; Save it

	move #3,-(sp)                    ; Save Screen Address (Logical)
	trap #14                         ;
	addq.l #2,sp                     ;
	move.l d0,Old_Screen+2           ;

	moveq #$11,d0                    ; Resume keyboard
	bsr	sendToKeyboard               ;

	moveq #$12,d0                    ; Kill mouse
	bsr	sendToKeyboard               ;

	bsr	flush                        ; Clear buffer keyboard

; If you don't use Multi_boot...
	sf	$ffff8260.w                  ; Low resolution
	move.b	#$2,$ffff820a.w          ; 50 Hz !
	rts

Restore_st:
	bsr	black_out                    ; palette color to zero

	moveq #$13,d0                    ; Pause keyboard
	bsr	sendToKeyboard               ;

	move #$2700,SR                   ; Interrupts OFF

	jsr	MUSIC+4                      ; Stop SNDH music

	lea $ffff8800.w,a0               ; Cut sound
	move.l #$8000000,(a0)            ; Voice A
	move.l #$9000000,(a0)            ; Voice B
	move.l #$a000000,(a0)            ; Voice C

 IFEQ	ERROR_SYS
	bsr	OUTPUT_TRACE_ERROR           ; Restore vectors list
 ENDC

	lea	Save_all,a0                  ; Restore adresses parameters
	move.b (a0)+,$fffffa01.w         ; Datareg
	move.b (a0)+,$fffffa03.w         ; Active edge
	move.b (a0)+,$fffffa05.w         ; Data direction
	move.b (a0)+,$fffffa07.w         ; Interrupt enable A
	move.b (a0)+,$fffffa13.w         ; Interupt Mask A
	move.b (a0)+,$fffffa09.w         ; Interrupt enable B
	move.b (a0)+,$fffffa15.w         ; Interrupt mask B
	move.b (a0)+,$fffffa17.w         ; Automatic/software end of interupt
	move.b (a0)+,$fffffa19.w         ; Timer A control
	move.b (a0)+,$fffffa1b.w         ; Timer B control
	move.b (a0)+,$fffffa1d.w         ; Timer C & D control
	move.b (a0)+,$fffffa27.w         ; Sync character
	move.b (a0)+,$fffffa29.w         ; USART control
	move.b (a0)+,$fffffa2b.w         ; Receiver status
	move.b (a0)+,$fffffa2d.w         ; Transmitter status
	move.b (a0)+,$fffffa2f.w         ; USART data
	                                 
	move.b (a0)+,$ffff8201.w         ; Restore Video addresses
	move.b (a0)+,$ffff8203.w         ;
	move.b (a0)+,$ffff820a.w         ;
	move.b (a0)+,$ffff820d.w         ;
	
	lea	Save_rest,a0                 ; Restore adresses parameters
	move.l (a0)+,$068.w              ; HBL
	move.l (a0)+,$070.w              ; VBL
	move.l (a0)+,$110.w              ; TIMER D
	move.l (a0)+,$114.w              ; TIMER C
	move.l (a0)+,$118.w              ; ACIA
	move.l (a0)+,$120.w              ; TIMER B
	move.l (a0)+,$134.w              ; TIMER A
	move.l (a0)+,$484.w              ; Conterm

	movem.l	(a0),d0-d7               ; Restore palette GEM system
	movem.l	d0-d7,$ffff8240.w        ;

	bset.b #3,$fffffa17.w            ; Re-activate Timer C

	stop #$2300                      ; Interrupts ON

	moveq #$11,d0                    ; Resume keyboard
	bsr	sendToKeyboard               ;

	moveq #$8,d0                     ; Restore mouse
	bsr	sendToKeyboard               ;

	bsr	flush                        ; Clear buffer keyboard

Old_Resol:                         ; Restore Old Screen & Resolution
	move	#0,-(sp)                   ;
Old_Screen:                        ;
	move.l #0,-(sp)                  ;
	move.l (sp),-(sp)                ;
	move #5,-(sp)                    ;
	trap #14                         ;
	lea	12(sp),sp                    ;

	move.w #$25,-(a7)                ; VSYNC()
	trap #14                         ;
	addq.w #2,a7                     ;
	rts

flush:                             ; Empty buffer
	lea	$FFFFFC00.w,a0               
.flush:	move.b	2(a0),d0           
	btst	#0,(a0)                    
	bne.s	.flush                     
	rts

sendToKeyboard:                    ; Keyboard access
.wait:	btst	#1,$fffffc00.w
	beq.s	.wait
	move.b	d0,$FFFFFC02.w
	rts

clear_bss:                         ; Init BSS stack with zero
	lea	bss_start,a0
.loop:	clr.l	(a0)+
	cmp.l	#bss_end,a0
	blt.s	.loop
	rts

black_out:                         ; Clear Palette colors
	moveq  #0,d0
	moveq  #0,d1
	moveq  #0,d2
	moveq  #0,d3
	moveq  #0,d4
	moveq  #0,d5
	moveq  #0,d6
	moveq  #0,d7
	movem.l d0-d7,$ffff8240.w
	rts

***************************************************************
; SUB-ROUTINES                                             // *
***************************************************************

*********************************************************************
***                  DISPLAY TEXT FONT 8x8 or 6x6                 ***
***              MED OR LOW RESOLUTION - ONE BITPLANE             ***
***                       ZORRO2/NOEXTRA-TEAM                     ***
*********************************************************************
CHARS      EQU 40  ; chars per line, 80=for med res, 40 for low res *
LINES      EQU 33  ; 33 for 8x8 font, 45 with 6x6 font              *
FONTSIZE   EQU 8   ; 8=8x8, 6=6x6 font                              *
SHIFTSIZE  EQU 4   ; 2=MED RESOLUTION, 4=LOW RESOLUTION             *
INNERLINE  equ 4   ; Pas between each line                          *
POS_SCR    EQU 160*24 ; Top Position in the Screens                 *
PLAN_SCR   EQU 2   ; Bitplane used to display the text              *
*********************************************************************
print_text:     lea     message,a2           ; Read the text or hexa
new_char:       bsr     _x_conversion        ; Convert / Resolution
                moveq   #0,d0    
                move.b  (a2)+,d0             ; If zero, stop routine
                cmp.b   #0,d0
                beq     line_feed            ; Next line / RC
.test_plan_1:   cmpi.b  #$fd,d0              ; Bitplane + 0
                bne.s   .test_plan_2
                move.w  #0,pointeur_plan
                bra.s   new_char
                bra.s   .end_of_line
.test_plan_2:   cmpi.b  #$fc,d0              ; Bitplane + 2
                bne.s   .end_of_line
                move.w  #2,pointeur_plan
                bra.s   new_char
.end_of_line:   cmpi.b  #$ff,d0              ; End of the text ?
                bne.s   process_char
                rts

process_char:   asl.w   #3,d0                ; Find ASCII value
                lea     FONT_NOEX,a1         ; and choose character font
                sub.w   #256,d0
                adda.w  d0,a1
                moveq   #0,d1                ; Position of the letter
                add.w   pointeur_plan,d1     ; in the two Screens
                add.l   y_offset,d1
                add.l   x_offset,d1
                movea.l physique,a0          ; In First screen
                lea     POS_SCR+PLAN_SCR(a0),a0
                adda.l  d1,a0
                rept FONTSIZE                ; Print letter on Screens
                move.b  (a1)+,(a0)
                lea     160(a0),a0
                endr
                addq.w  #1,x_curs           
                cmpi.w  #CHARS,x_curs        ; 79 for MED res
                bls     new_char
                move.w  #CHARS,x_curs        ; 79 for MED res
                bra     new_char

line_feed:      clr.w   x_curs               ; back to first char
                addi.l  #FONTSIZE*160+160*INNERLINE,y_offset ; when u reached ',0'
                cmpi.l  #LINES*FONTSIZE*160,y_offset
                bls     new_char
                move.l  #LINES*FONTSIZE*160,y_offset
                bra     new_char

_x_conversion:  move.w  x_curs,d0            ; Cursor moves calculation
                and.l   #$ffff,d0
                btst    #0,d0
                beq.s   .even
                subq.w  #1,d0
                mulu    #SHIFTSIZE,d0        ; 2=MED res, 4=LOW res
                addq.w  #1,d0
                bra     .done_conv
.even:          mulu    #SHIFTSIZE,d0        ; 2=MED res, 4=LOW res
.done_conv:     move.l  d0,x_offset
                rts

***************************************************************
*                                                             *
*              SCROLLING WITH FONT 8*8 ONE PLANE              *
*                     ZORRO2/NOEXTRA-TEAM                     *
*                                                             *
***************************************************************

init_miniscroll:
           move.l	#mtexte,ptr_mtexte
           rts

miniscroll:move.w 	bit,d0
           cmp.w 	#8,d0
           bne.s 	plusloin3
           clr.w 	bit
           move.l 	ptr_mtexte,a1
           move.b 	(a1),d0
           cmp.b 	#255,d0
           bne.s 	.lsuite
           move.l 	#mtexte,ptr_mtexte
           move.l 	ptr_mtexte,a1
           move.b 	(a1),d0
.lsuite:   addq.l 	#1,ptr_mtexte
           asl.l 	#3,d0
           lea 	fonts_8x8,a1
           sub.w	#256,d0
           add.w 	d0,a1
           lea 	buffer,a2

i          set 	0
           rept 	8
           move.b 	(a1)+,i(a2)
i          set 	i+2
           endr

plusloin3: addq.w 	#1,bit
           lea 	trav,a1
           lea 	buffer,a2
i          set 	0
           rept	 8
           roxl 	(a2)+
           roxl 	i+38(a1)
           roxl 	i+36(a1)
           roxl 	i+34(a1)
           roxl 	i+32(a1)
           roxl 	i+30(a1)
           roxl 	i+28(a1)
           roxl 	i+26(a1)
           roxl 	i+24(a1)
           roxl 	i+22(a1)
           roxl 	i+20(a1)
           roxl 	i+18(a1)
           roxl 	i+16(a1)
           roxl 	i+14(a1)
           roxl 	i+12(a1)
           roxl 	i+10(a1)
           roxl 	i+8(a1)
           roxl 	i+6(a1)
           roxl 	i+4(a1)
           roxl 	i+2(a1)
           roxl 	i+0(a1)
i          set 	i+40
           endr

aff_scr:   move.l 	physique(pc),a1
           lea	160*182+2(a1),a1
           lea 	trav,a2
i          set 	2
           rept 	9-1	*	hauteur du scroll
           move.w 	(a2)+,i+2(a1)
           move.w 	(a2)+,i+10(a1)
           move.w 	(a2)+,i+18(a1)
           move.w 	(a2)+,i+26(a1)
           move.w 	(a2)+,i+34(a1)
           move.w 	(a2)+,i+42(a1)
           move.w 	(a2)+,i+50(a1)
           move.w 	(a2)+,i+58(a1)
           move.w 	(a2)+,i+66(a1)
           move.w 	(a2)+,i+74(a1)
           move.w 	(a2)+,i+82(a1)
           move.w 	(a2)+,i+90(a1)
           move.w 	(a2)+,i+98(a1)
           move.w 	(a2)+,i+106(a1)
           move.w 	(a2)+,i+114(a1)
           move.w 	(a2)+,i+122(a1)
           move.w 	(a2)+,i+130(a1)
           move.w 	(a2)+,i+138(a1)
           move.w 	(a2)+,i+146(a1)
           move.w 	(a2)+,i+154(a1)
i          set 	i+160
           endr
           rts

ptr_mtexte:
	ds.l	1
bit:
	ds.w 	1
buffer:
	ds.w 	8
trav:
	ds.l	21*8
	even

***************************************************************
*                                                             *
*         GIF ANIMATED -  ONE PLANE - DECOMPRESSED            *
*                     ZORRO2/NOEXTRA-TEAM                     *
*                                                             *
***************************************************************

Init_tunnel:
	lea	TUNNEL_L7Z,a0                ; datas TUNNEL compressed
	lea	Buffer_l7z,a1                ; buffer destination
	jsr	d_lz77                       ; decompress data in a0 -> a1
	move.w	#0,CPT_TUNNEL            ; inits...
	move.w	#0,REPEAT_TUNNEL         ;
  rts

display_tunnel:
	cmpi.w	#-1,REPEAT_TUNNEL        ; Repeat twice... smoothly !
	beq	no_repeat
	move.w	#-1,REPEAT_TUNNEL

; Display mode STF
	movea.l	physique(pc),a1
	lea	160*2(a1),a1
	move	#98-1,d1                   ; number of lines
.loop;
i	set	0
	rept	20                         ; repeat chunks (1 chunk=16 pixels)
	move.w	i(a0),i(a1)              ; copy 1st half of a chunk (logical)
i	set	i+8                          ; next chunk
	endr                             ; end of copying chunks
	add.l	#160,a0                    ; next scanline line for logical
	add.l	#160,a1                    ; next scanline line for 
	dbf	d1,.loop                     ; end of copying lines

; Mirroring
	movea.l	physique(pc),a2
	lea	160*99(a2),a2
	movea.l	physique(pc),a1
	lea	160*99(a1),a1
	move	#98-1,d1                   ; number of lines
.loop2;
i	set	0
	rept	20                         ; repeat chunks (1 chunk=16 pixels)
	move.w	i(a2),i(a1)              ; copy 1st half of a chunk (logical)
i	set	i+8                          ; next chunk
	endr                             ; end of copying chunks
	sub.l	#160,a2                    ; next scanline line for logical
	add.l	#160,a1                    ; next scanline line for 
	dbf	d1,.loop2                    ; end of copying lines

	add.w	#1,CPT_TUNNEL
	cmp.w	#(10*2-1)-1,CPT_TUNNEL
	blt.s	do_wave
	move.w	#0,CPT_TUNNEL
  move.l	#Buffer_l7z,a0
	bra.s	do_wave
no_repeat:
	move.w	#0,REPEAT_TUNNEL
do_wave:
	rts

******************************************
*                                        *
* Very! fast lz77 decompression routine  *
* 68000 version                          *
*                                        *
******************************************
 include "LZ77_130.ASM"

***************************************************************
 SECTION	DATA                                             // *
***************************************************************

Default_palette:
	dc.w	$0002,$0004,$0346,$0346,$0000,$0000,$0000,$0000
	dc.w	$0046,$0046,$0000,$0000,$0000,$0000,$0000,$0000

* << Full data here >>

message:
	dc.b	"       COMPILATION EXTRA VOLUME 7",0,0
	dc.b	"  F1 AENIGMATICA.....MCA PHALEON INTRO",0
	dc.b	"  F2 TBC.....................BONO DEMO",0
	dc.b	"  F3 FUZION................CD-200 MENU",0
	dc.b	"  F4 FUZION..................CD-6 MENU",0
	dc.b	"  F5 NEXT............ZE ANTI-MIT INTRO",0
	dc.b	"  F6 TCB................SPRITES RECORD",0
	dc.b	"  F7 TCB...........ONE-BIT-PLANE-MANIA",0
	dc.b	"  F8 TCB..................SWEDISH DEMO",0
	dc.b	"  F9 TLB.............PHALEON DETH ORGY",0
	dc.b	"  F10 BONUS......HEMOROIDS GUEST INTRO",$ff
	even
x_curs:
	ds.l 1
y_offset:
	ds.l 1
x_offset:
	ds.l 1
pointeur_plan:
	ds.w 1
FONT_NOEX:
	incbin 	"AMIGA3F.DAT"            ; Special RAZOR 1991 by M.A 
	EVEN

mtexte: 
* < !'#$%&"()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyzCUR> *
	dc.b "WELCOME TO THE SEVENTH VOLUME EXTRA BY NOEXTRA-TEAM IN 2017. "
	dc.b "CODED BY ZORRO2, GFX INTRO BY HYLST AND MUSIC BY JEDI/SECTOR ONE. "
	dc.b "ENJOY ALL PREVIEW INSIDE THIS DELICIOUS MENU ! "
	dc.b "I LET SINK/HMD AND ORION/FUZION TO FINISH THIS SCROLLTEXT AND SEE YOU SOON FOR THE NEXT TIME !!!"
	dc.b "                        "
*/ Sink^HMD
	dc.b	"HELLO AND HAPPY NEW YEAR. IT IS SINK ON THE KEYBOARD FOR TALKING ABOUT THE INTRO "
	dc.b	"OF NO EXTRA WHICH WOULD  TO FIND IN THE SQUARE DEMO AS A GUEST INTRO BUT AFTER A "
	dc.b	"CHANGE OF IDEA WE DECIDE BY MUTUAL AGREEMENT TO NOT USE IT. BUT I'LL STILL YOU "
	dc.b	"TELL MORE ON THIS INTRO. SHE HAS BEEN CARRIED OUT TO MARK THE ANNIVERSARY OF THE "
	dc.b	"AMIGA. YOU CAN LISTEN AN OLD MODULE OF TOMCHI WHICH HAS NEVER BEEN USED BUT I "
	dc.b	"THINK NICE AND HYPNOTIC. AND FINALLY YOU CAN SEE WHAT I WOULD CALL A RAW INTRO, "
	dc.b	"IT MEANS THAT THE DESIGN WAS NOT FINISHED YET AND THAT THE TEXT WAS A FIRST TEST. " 
	dc.b	"HOWEVER THE RENDERING IS BEAUTIFUL ON A REAL ATARI MONITOR. "
	dc.b	"I WOULD ALSO LIKE TO WISH A HAPPY BIRTHDAY TO AYOROS AND CONGRATULATE HIM ON ALL HIS "
	dc.b	"GREAT DEMOS UNDER WAB.COM (AS WELL AS TOTORMAN). I ALSO REMIND YOU THAT YOU CAN VISIT "
	dc.b	"OUR SITE WEB WWW.HEMOROIDS.EU TO LEARN MORE ABOUT THE GROUP (HISTORY, DEMOS AND "
	dc.b	"MEMBERS). SEE YA LATER !                                    "
*/ Orion^Fuzion
	dc.b	"HELLO ATARI SCENERS !!! THIS IS ORION FROM THE REPLICANTS AND FUZION EMERGING FROM THE PAST, "
	dc.b	"23 YEARS AND 6 MONTHS AFTER MY LAST TWO CRACKS IN SUMMER 1993 (",$27,"ZOOL",$27," AND ",$27,"THE ANCIENT ART "
	dc.b	"OF WAR IN THE SKIES",$27,") !!! I'M NOW 43 YEARS OLD, MARRIED, I LIVE IN PARIS (FRANCE) AND I "
	dc.b	"WORK AS A SOFTWARE ENGINEER AND ARCHITECT SPECIALIZED IN VIRTUALIZATION AND EMBEDDED SYSTEMS "
	dc.b	"(VERY EXCITING JOB INDEED, AND MUCH MORE COMPLICATED THAN EVERYTHING I'VE DONE ON THE ATARI "
	dc.b	"ST !!!). I'M STILL IN TOUCH WITH MOST OF THE FUZION MEMBERS AND WITH SEVERAL REPLICANTS "
	dc.b	"MEMBERS TOO, AND I CAN TELL YOU THAT EVERYBODY IS FINE, SOME OF THEM ALSO WORK IN HIGH TECH "
	dc.b	"AREAS (KASAR, SQUAT, KELVIN, ILLEGAL, DOM, EXCALIBUR, FURY) BUT SOME OTHERS NOW WORK IN AREAS "
	dc.b	"WHICH HAVE NOTHING TO DO WITH COMPUTING OR HIGH TECH (ELLFIRE, CAMEO, SNAKE). HOWEVER WE ALL "
	dc.b	"SHARE THE SAME FEELING : THE ATARI ST WAS AN ENCHANTED INTERLUDE IN OUR LIVES AND WE HAD A "
	dc.b	"GREAT CHANCE TO BE PART OF THIS UNDERGROUND AND GENERATIONAL PHENOMENON... FOR MANY OF US THE "
	dc.b	"ATARI ST HAD AN IMPACT ON OUR LIVES. IN MY CASE, I KNOW THAT I WOULD NOT HAVE HAD THE SAME "
	dc.b	"LIFE IF I HAD NOT EXPERIENCED THIS FUZION AND REPLICANTS ADVENTURE : MY STUDIES, MY JOB AND EVEN "
	dc.b	"MY WIFE... ALL THE IMPORTANT THINGS IN MY LIFE WOULD NOT HAVE HAPPENED THE SAME WAY IF I HAD "
	dc.b	"NOT LIVED THESE 4 ATARI ST YEARS FROM 89 TO 93.... THREE MONTHS AGO, I  MADE A COMEBACK ON THE "
	dc.b	"ATARI ST SCENE, JUST FOR THE FUN AND BECAUSE OF A BIT OF NOSTALGIA. I DEVELOPED A TOOL CALLED "
	dc.b	"",$27,"DEC0DE",$27," AIMED AT DECRYPTING PROGRAMS WHICH WERE ENCRYPTED/PROTECTED AGAINST REVERSE-ENGINEERING "
	dc.b	"USING TOOLS LIKE ANTIBITOS FROM ILLEGAL OR COOPER FROM CAMEO. THE DEC0DE TOOL SUPPORTS A DOZEN "
	dc.b	"OF ENCRYPTION SYSTEMS, BUT WITH THE HELP OF MAARTAU FROM ELITE, I AM CURRENTLY WORKING ON THE "
	dc.b	"NEXT RELEASE OF DEC0DE WHICH SHOULD BE ABLE TO DECRYPT (OR CRACK) ROB NORTHEN PROTECTED PROGRAMS... "
	dc.b	"THIS IS AN INTERESTING AND FUNNY CHALLENGE !!! IF YOU WANT TO GET IN TOUCH WITH ME, YOU CAN FIND ME "
	dc.b	"ON FACEBOOK AS ",$27,"ORION.FUZION",$27," OR YOU CAN DIRECTLY SEND AN EMAIL TO ORION.FUZION@GMAIL.COM. IT'S NOW "
	dc.b	"TIME FOR GREETINGS... I JUST WANT TO GREET ALL ATARI ST ENTHUSIASTS WHO CONTRIBUTE TO KEEP THE ATARI "
	dc.b	"ST SCENE AND SPIRIT STILL ALIVE AFTER SO MANY YEARS.... I ALSO SEND WARM HELLOS TO ALL FUZION AND "
	dc.b	"REPLICANTS MEMBERS AND I THANK YOU FOR READING THIS SCROLLTEXT TILL THE END !!! NO ",$27,"FUCKS",$27," IN THIS "
	dc.b	"SCROLLTEXT, BECAUSE ",$27,"FUCKS",$27," TIME IS FAR BEHIND US... IT IS RATHER TIME FOR SHARING AND CHERISHING "
	dc.b	"THOSE GREAT MEMORIES....... AND ALSO TIME TO....... WRAP.........                                 "
	dc.b	-1
	even
fonts_8x8:
	incbin	"AMIGA4F.DAT"
	even

REPEAT_TUNNEL:
	dc.w	0
CPT_TUNNEL:
	dc.w	0
TUNNEL_L7Z:
	incbin "TUNNEL.L7Z"
	even

* <

MUSIC:
	incbin "*.SND"              ; SNDH Music played at the VBL
	even

***************************************************************
 SECTION	BSS                                              // *
***************************************************************

bss_start:

* << Full data here >>

Buffer_l7z:                   ; gif-animated...
	ds.b	297920

* <

Vsync:
	ds.w	1

Save_stack:
	ds.l	1

Save_all:
	ds.b 16 * MFP
	ds.b 4	* Video : f8201.w -> f820d.w

Save_rest:
	ds.l 1	* Autovector (HBL)
	ds.l 1	* Autovector (VBL)
	ds.l 1	* Timer D (USART timer)
	ds.l 1	* Timer C (200hz Clock)
	ds.l 1	* Keyboard/MIDI (ACIA) 
	ds.l 1	* Timer B (HBL)
	ds.l 1	* Timer A
	ds.l 1	* Output Bip Bop

Palette:
	ds.w 16 * Palette System

bss_end:

Screen:
	ds.b 256
	ds.b SIZE_OF_SCREEN*(NB_OF_SCREEN+1)

***************************************************************
	SECTION	TEXT                                           // *
***************************************************************

 IFEQ	FADE_INTRO
***************************************************************
*                                                             *
*                    FADING WHITE TO BLACK                    *
*                  (Don't use VBL with it !)                  *
*                                                             *
***************************************************************
fadein:
	move.l	#$777,d0
.deg:	bsr.s	wart
	bsr.s	wart
	bsr.s	wart
	lea	$ffff8240.w,a0
	moveq	#15,d1
.chg1:
	move.w	d0,(a0)+
	dbf	d1,.chg1
	sub.w	#$111,d0
	bne.s	.deg
	bsr	black_out                    ; Palette colors to zero
	rts

wart:                              ; VSYNC()
	move.l	d0,-(sp)
	move.l	$466.w,d0
.att:	cmp.l	$466.w,d0
	beq.s	.att
	move.l	(sp)+,d0
	rts
 ENDC

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
	move.w #$2700,SR                  ; Deux erreurs à suivre... non mais !

	move.w	#$0FF,d1
.loop:
	move.w d0,$ffff8240.w             ; Effet raster
	move.w #0,$ffff8240.w
	cmp.b #$3b,$fffffc02.w
	dbra d1,.loop

	pea ESCAPE_PRG                    ; Put the return adress
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

 IFEQ STF_INITS
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
	bclr.b	#5,$FFFF8007.w ; Mode STE on Falcon
	bclr.b	#2,$FFFF8007.w ; Blitter at 8Mhz

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

bCT60:
	dc.b 0
	even
 ENDC

******************************************************************
	END                                                       // *
******************************************************************
