***************************************
* // UNIVITED.PRG                  // *
***************************************
* // Asm Intro Code Atari ST v0.45 // *
* // by Zorro 2/NoExtra (01/12/21) // *
***************************************
* // Original code : ANGEL/HMD     // *
* // Gfx intro     : PANDAFOX/HMD  // *
* // Gfx logo      : DIEU/HMD      // *
* // Gfx font      : DIEU/HMD      // *
* // Gfx other     : JADE/HMD      // *
* // Music         : YQN/HMD       // *
* // Texts         : STRANGER/HMD  // *
* // Texts         : SINK/HMD      // *
* // Release date  : 13/01/2022    // *
* // Update date   : 16/05/2023    // *
***************************************
  OPT c+ ; Case sensitivity ON        *
  OPT d- ; Debug OFF                  *
  OPT o- ; All optimisations OFF      *
  OPT w- ; Warnings OFF               *
  OPT x- ; Extended debug OFF         *
***************************************

**********************************************************************
	SECTION	TEXT                                                    // *
**********************************************************************

************************* OVERSCAN MODE ******************************
BOTTOM_BORDER    equ 1           ; Use the bottom overscan           *
TOPBOTTOM_BORDER equ 1           ; Use the top and bottom overscan   *
NO_BORDER        equ 0           ; Use a standard Low-screen         *
***************************** SCREENS ********************************
PATTERN          equ $00000000   ; Fill Screens with a plan pattern  *
ONE_SCREEN       equ 0           ; One Screen used                   *
TWO_SCREENS      equ 1           ; Two Screens used                  *
NB_OF_SCREEN     equ TWO_SCREENS ; Number of Screen used             *
*************************** PARAMETERS *******************************
SEEMYVBL         equ 1           ; See CPU used if you press ALT key *
ERROR_SYS        equ 1           ; Manage exit system errors         *
FADE_INTRO       equ 0           ; Fade White to black palette       *
TEST_STE         equ 1           ; Code only for Atari STE machine   *
STF_INITS        equ 0           ; STF compatibility MODE            *
BLITTER          equ 1           ; Sync effect with Blitter          *
**********************************************************************
*              Notes : 0 = I use it / 1 = no need !                  *
**********************************************************************

Begin:
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

 IFEQ BLITTER
	move.w	#$80,$ffff8a3c.w         ; Launch Blitter !
	nop
.restart:
	bset	#7,$ffff8a3c.w
	nop
	bne.s	.restart
 ENDC

 IFEQ	FADE_INTRO
	bsr	fadein                       ; Fading White to Black Screen
 ENDC

*************************** INTRO LOOP ************************>

	jsr	Launch_introfx

*************************** INTRO LOOP ************************<

**************************** MAIN LOOP ************************>

	jsr	Launch_scrollfx

	bsr	Inits                        ; Other Initialisations

default_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

 IFEQ	SEEMYVBL
	move.l hmd_palette,$ffff8240.w ; init line of CPU
 ENDC

* < Put your code here >

	jsr	Display_Stars
	jsr	Display_Vagues
	jsr	Play_digits
	jsr	Scroll_Full

 rept 2
	jsr	Mscroll
 endr

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

	cmp.b #$39,$fffffc02.w           ; SPACE key pressed ?
	bne	default_loop

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

 IFEQ	NO_BORDER
* // Declarations here ...
	move #$2700,SR                   ; Interrupts OFF
	bset	#0,$fffffa07.w             ; enable timer b
	bclr	#0,$fffffa0f.w             ; enable timer b
	bset	#0,$fffffa13.w             ; enable timer b
	and.b	#%00100000,$fffffa09.w	   ; leave timer c enabled (for the tune)
	bclr	#3,$fffffa17.w             ; enable auto A-INTERRUPT IN SERVICE clear
	clr.b	$fffffa1b.w                ; disable timer b
	clr.b	$fffffa21.w                ; clear timer b data
	stop	#$2300                     ; Interrupts ON
 ENDC

	moveq #1,d0                      ; Choice of the music (1 is default)
	jsr	MUSIC+0                      ; Init SNDH music

	lea	Vbl(pc),a0                   ; Launch VBL
	move.l	a0,$70.w                 ;

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
SIZE_OF_SCREEN equ 160*270         ; Only Screen Size in Low Resolution
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
 IFEQ BLITTER
.sync_blitter:                     ; Sync Blitter with effect
	bclr.b	#7,$ffff8a3c.w
	nop
	btst.b	#7,$ffff8a3c.w
	bne.s	.sync_blitter
 ENDC

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
* // Declarations here ...
	movem.l   hmd_palette,d0-d7 
	movem.l   d0-d7,$ffff8240.w 
	clr.b	$fffffa1b.w 
	move.l	#timerb,$120.w
	move.b	#199-DELTA,$fffffa21.w	;next interrupt to occur 199 lines down
	move.b	#8,$fffffa1b.w		;set interrupt method
 ENDC

	jsr (MUSIC+8)                    ; Play SNDH music

	movem.l	(a7)+,d0-d7/a0-a6

 IFEQ BLITTER
	bset.b	#7,$ffff8a3c.w           ; Launch Blitter
	nop
 ENDC
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
* // Declarations here ...
DELTA equ 86+27
timerb:
	clr.b	$fffffa1b.w
	move.b	#DELTA,$fffffa21.w
	move.l	#timerbas,$120.w 
	move.b	#8,$fffffa1b.w
	move	#$2700,sr 
	movem.l	a0/d0,-(a7) 
	lea	$fffffa21.w,a0
	move.b	(a0),d0 
.wait:
	cmp.b	(a0),d0 
	beq.s	.wait 
	dcb.w	6,$4e71
	move.l	a1,-(sp)
	move.l	a2,-(sp)
	movea.l	#spectrum_palette,a1 ; 3 bitplanes displayed
	movea.l	#$ff8240,a2
	move.l	(a1)+,(a2)+ 
	move.l	(a1)+,(a2)+ 
	move.l	(a1)+,(a2)+ 
	move.l	(a1)+,(a2)+ 
	move.l	(a1)+,(a2)+ 
	move.l	(a1)+,(a2)+ 
	move.l	(a1)+,(a2)+ 
	move.l	(a1)+,(a2)+ 
	move.l	(sp)+,a2
	move.l	(sp)+,a1	
	movem.l	(a7)+,a0/d0 
	move	#$2300,sr 
	bclr	#0,$fffffa0f.w
	rte

timerbas:
	move.w	#$2700,sr
	bclr	#5,$fffffa15.w		; stop timerc (digidrum) to stop flicker
	dcb.w 50-30,$4e71
	clr.b	$fffffa1b.w
	movem.l	d0/a0,-(sp)
	lea	$ffff8209.w,a0
	moveq	#0,d0
	move.b	(a0),d0
	sub.b	#$60,d0
	jmp	nops(pc,d0)
nops:
	dcb.w 97,$4e71
	move.b	#0,$ffff820A.w
	move.b	#2,$ffff8260.w
	move.b	#0,$ffff8260.w
	move.b	#2,$ffff820A.w

	move.l	fond_palette+00,$ffff8240.w	; scroller font colours
	move.l	fond_palette+04,$ffff8244.w
	move.l	fond_palette+08,$ffff8248.w
	move.l	fond_palette+12,$ffff824c.w
	move.l	fond_palette+16,$ffff8250.w
	move.l	fond_palette+20,$ffff8254.w
	move.l	fond_palette+24,$ffff8258.w
	move.l	fond_palette+28,$ffff825c.w

	bset	#5,$fffffa15.w

	dcb.w 12,$4e71		;-12 for colour changes
	move.b	#0,$ffff820A.w		;-7 for bset command
	move.b	#2,$ffff820A.w		;-16 for scroll pal MOVE.Ls
	dcb.w 8,$4e71
	move.b	#1,$ffff8260.w
	move.b	#0,$ffff8260.w
	dcb.w 8,$4e71

	moveq	#32-1,d0	;	31 lignes in overscan
.line:
	move.b	#2,$ffff8260.w
	move.b	#0,$ffff8260.w
	dcb.w 87,$4e71
	move.b	#0,$ffff820A.w
	move.b	#2,$ffff820A.w
	dcb.w 8,$4e71
	move.b	#1,$ffff8260.w
	move.b	#0,$ffff8260.w
	dcb.w 6,$4e71
	dbf	d0,.line

	move.l	#$00010001,d0	; cache la misère !!!
	move.l	d0,$ffff8240.w
	move.l	d0,$ffff8244.w
	move.l	d0,$ffff8248.w
	move.l	d0,$ffff824c.w
	move.l	d0,$ffff8250.w
	move.l	d0,$ffff8254.w
	move.l	d0,$ffff8258.w
	move.l	d0,$ffff825c.w

	dcb.w 35,$4e71
	movem.l	(sp)+,d0/a0

	move.l	back_palette+00,$ffff8240.w	; scroller font colours
	move.l	back_palette+04,$ffff8244.w
	move.l	back_palette+08,$ffff8248.w
	move.l	back_palette+12,$ffff824c.w
	move.l	back_palette+16,$ffff8250.w
	move.l	back_palette+20,$ffff8254.w
	move.l	back_palette+24,$ffff8258.w
	move.l	back_palette+28,$ffff825c.w
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
	stop #$2100                      ; Sync with interrupt
	clr.b (tacr).w                   ; Stop timer A
	dcb.w 78,$4E71                   ; 78 nops
	clr.b (herz).w                   ; 60 Hz
	dcb.w 18,$4E71                   ; 18 nops
	move.b #2,(herz).w               ; 50 Hz
	lea	timerb(pc),a0
	move.l a0,$134.w                 ; Timer A vector
	move.b #199-DELTA,(tadr).w             ; Countdown value for timer A
	move.b #7,(tacr).w               ; Delay mode, clock divided by 200
	move.l (a7)+,a0                  ;
	bclr.b #5,(isra).w               ; Clear end of interrupt flag
my_hbl:
	rte

botbord:
	move #$2100,SR                   ;
	stop #$2100                      ; sync with interrupt
	clr.b (tacr).w                   ; stop timer A
	dcb.w 78,$4E71                   ; 78 nops
	clr.b (herz).w                   ; 60 Hz
	dcb.w 18,$4E71                   ; 18 nops
	move.b #2,(herz).w               ; 50 Hz
	bclr.b #5,(isra).w               ;
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

* Available interrupt commands for music if needed...
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
* // Code here....
 ENDC

	stop #$2300                      ; Interrupts ON

	clr.b $484.w                     ; No bip, no repeat

	move #4,-(sp)                    ; Save & Change Resolution (GetRez)
	trap #14	                       ; Get Current Res.
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

; If you don't use Multi_boot option...
	sf	$ffff8260.w                  ; Low resolution
	move.b	#$2,$ffff820a.w          ; 50 Hz !
	rts

Restore_st:
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
.flush:
	move.b	2(a0),d0           
	btst	#0,(a0)                    
	bne.s	.flush                     
	rts

sendToKeyboard:                    ; Keyboard access
.wait:
	btst	#1,$fffffc00.w
	beq.s	.wait
	move.b	d0,$FFFFFC02.w
	rts

clear_bss:                         ; Init BSS stack with zero
	lea	bss_start,a0
	moveq	#0,d0
.clr:
	move.l	d0,(a0)+
	cmp.l	#bss_end,a0
	blt.s	.clr
	rts

***************************************************************
; SUB-ROUTINES                                             // *
***************************************************************

* Routines
 include "E:\UNIVITED.HMD\include\COPYBLIT.ASM"
 include "E:\UNIVITED.HMD\include\LZ4_183.ASM"
 include "E:\UNIVITED.HMD\include\CLEARFUL.ASM"
* Effects
 include "E:\UNIVITED.HMD\include\SCROLLIN.ASM"
 include "E:\UNIVITED.HMD\include\SCROL32F.ASM"
 include "E:\UNIVITED.HMD\include\SPECTRUM.ASM"
 include "E:\UNIVITED.HMD\include\STARS_H.ASM"
 include "E:\UNIVITED.HMD\include\SIN_WAVE.ASM"
 include "E:\UNIVITED.HMD\include\SMALL_S.ASM"
 include "E:\UNIVITED.HMD\include\INTRO.ASM"
 include "E:\UNIVITED.HMD\include\FIZZMAIN.ASM"
 include "E:\UNIVITED.HMD\include\FADE_IN.ASM

***************************************************************
 SECTION	DATA                                             // *
***************************************************************

* << Full data here >>

* SCROLL 4 BITPLANES 32 x 32
scroll_pointer:
	dc.l	scroll_text+7
scroll_text:
	incbin	"E:\UNIVITED.HMD\_text\STRANGER.DAT"
	even
font_offsets:
;    ESP !  '  #  $  %  &  "  (  )  *  +  ,  -  .  /
 dc.b	60,39,46,49,50,51,52,48,41,42,53,54,38,60,37,45
;     0  1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ?  @
 dc.b	27,28,29,30,31,32,33,34,35,36,44,55,60,56,60,40,57
;     A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q
 dc.b	01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17
;     R  S  T  U  V  W  X  Y  Z  [  \  ]  ^  _  `  a  b  c
 dc.b	18,19,20,21,22,23,24,25,26,60,43,60,58,47,60,01,02,03
;     d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u
 dc.b	04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21
;     v  w  x  y  z  {  |  }  ~
 dc.b	22,23,24,25,26,60,60,60,60
	even
char_offset:
	dc.w	0
fond_palette:
	dc.w	$0001,$0112,$0223,$0233,$0243,$0454,$0565,$0676
	dc.w	$0003,$0311,$0422,$0632,$0642,$0753,$0764,$0777
font_32:
	dcb.b	31*4*4,0
	incbin	"E:\UNIVITED.HMD\data\DFONT.FNT"
	even

* Sinus Wave
Pos_Vagues:
	incbin	"E:\UNIVITED.HMD\data\POSVAGUE.DAT"
	even
Courbe_Vagues:
	incbin	"E:\UNIVITED.HMD\data\COURBE.DAT"
Fin_Courbe_Vagues:
	even

* Small Fonts
smtext:
	incbin	"E:\UNIVITED.HMD\_text\SINK.DAT"
	even
small_font:
	INCBIN	"E:\UNIVITED.HMD\data\FONTSMALL.DAT"
	even

* Pictures
greg_palette:
	dc.w	$0112,$0112,$0223,$0334,$0445,$0456,$0666,$0212
	dc.w	$0454,$0423,$0313,$0534,$0326,$0537,$0314,$0777
greg_picture:
	INCBIN	"E:\UNIVITED.HMD\data\GREGHMD.LZ4" ;	320x200
	even

hmd_palette:
	dc.w	$0000,$0111,$0750,$0740,$0630,$0420,$0310,$0200
	dc.w	$0223,$0333,$0744,$0444,$0413,$0303,$0203,$0102
hmd_picture:	even
	INCBIN	"E:\UNIVITED.HMD\data\HMDLOGO.IMG"	;	320x86
  
back_palette:
	dc.w	$0001,$0001,$0001,$0001,$0001,$0001,$0001,$0001
	dc.w	$0777,$0666,$0555,$0444,$0333,$0222,$0111,$0001
back_picture:	even
	INCBIN	"E:\UNIVITED.HMD\data\BACK.LZ4" ;	320x6

reflet_palette:
		dc.w	$0001,$0467,$0356,$0245,$0034,$0113,$0002,$0070
		dc.w	$0070,$0070,$0070,$0070,$0070,$0070,$0070,$0070
reflet_picture:	even
	INCBIN	"E:\UNIVITED.HMD\data\REFLETM.IMG" ;	320x87

spectrum_palette:
	dc.w	$0001,$0467,$0356,$0245,$0034,$0113,$0110,$0221
	dc.w	$0111,$0112,$0113,$0114,$0573,$0452,$0342,$0332
spectrum_picture:	even
	INCBIN	"E:\UNIVITED.HMD\data\SPECTRUM.LZ4" ;	320x112
	even

* <

MUSIC:
	INCBIN	"E:\UNIVITED.HMD\data\OLDSCOOK.SND"            ; SNDH Music played at the VBL
	even

***************************************************************
 SECTION	BSS                                              // *
***************************************************************

bss_start:

* << Full data here >>

* SINUS WAVE
Buffer_waveS:
	ds.b	160*87
	even

* SINUS WAVE
Tabs_Vagues:
	ds.b	SIZEL
	even
Ptr_Vagues:
	ds.l	1 
Buffer_Vagues:
	ds.b	12*SIZEL*160
	even

* LITTLE SCROLLTEXT
ptr_smtext:
	ds.l	1
pas_car:
	ds.w 	1
buffer_car:
	ds.w 	8
buffer_mscrol:
	ds.w	200
	even

* INTRO buffers
Buffer_Screen:
	ds.b	160*nb_line
Buffer_Random:
	ds.b	nb_line
	even

* <

Vsync:
	ds.w	1

Save_stack:
	ds.l	1

Save_all:
	ds.b 16 * MFP Interrupts
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
.deg:
 rept 3
	bsr.s	wart
 endr
	lea	$ffff8240.w,a0
	moveq	#15,d1
.chg1:
	move.w	d0,(a0)+
	dbf	d1,.chg1
	sub.w	#$111,d0
	bne.s	.deg
	bsr.s	black_out                  ; All palette colors to zero
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
	moveq #10-1,d0                    ; On d�tourne toutes les erreur possibles...
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

routine_bus: ; BUS - GREEN
	move.w #$070,d0
	bra.s execute_detournement
routine_adresse:	;	ADDRESS - BLUE
	move.w #$007,d0
	bra.s execute_detournement
routine_illegal:	;	ILLEGAL - RED
	move.w #$700,d0
	bra.s execute_detournement
routine_div:	;	DIV ERROR - YELLOW
	move.w #$770,d0
	bra.s execute_detournement
routine_chk:	;	CHECK - LIGHT BLUE
	move.w #$077,d0
	bra.s execute_detournement
routine_trapv:	;	TRAP ERROR - WHITE
	move.w #$777,d0
	bra.s execute_detournement
routine_viole:	;	VIOLATION ACCESS - PURPLE
	move.w #$707,d0
	bra.s execute_detournement
routine_trace:	;	TRACE ERROR - DARK BLACK
	move.w #$333,d0
	bra.s execute_detournement
routine_line_a:	;	LINE A ERROR - ORANGE
	move.w #$740,d0
	bra.s execute_detournement
routine_line_f:	;	LINE F ERROR - LIGHT GREEN
	move.w #$474,d0
execute_detournement:
	move.w #$2700,SR                  ; Deux erreurs � suivre... non mais !

	move.w	#$0FF,d1
.loop:
	move.w d0,$ffff8240.w             ; Effet raster
	move.w #0,$ffff8240.w
	cmp.b #$3b,$fffffc02.w
	dbra d1,.loop

	pea ESCAPE_PRG                    ; Put the return adress
	move.w #$2700,-(sp)               ; J'esp�re !!!...
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
	dc.l routine_line_f	Vert clair
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
	END                                                         // *
******************************************************************
