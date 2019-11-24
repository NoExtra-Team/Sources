***************************************
* // ELITE_8.PRG                   // *
***************************************
* // Asm Intro Code Atari ST v0.44 // *
* // by Zorro 2/NoExtra (01/12/16) // *
* // http://www.noextra-team.com/  // *
***************************************
* // Original code : Zorro2/NoExtra// *
* // Gfx logo      :               // *
* // Gfx font      :               // *
* // Music         : CELTIC        // *
* // Release date  : 21/11/2019    // *
* // Update date   : 21/11/2019    // *
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
NB_OF_SCREEN     equ TWO_SCREENS ; Number of Screen used             *
*************************** PARAMETERS *******************************
SEEMYVBL         equ 0           ; See CPU used if you press ALT key *
ERROR_SYS        equ 1           ; Manage Errors System              *
FADE_INTRO       equ 0           ; Fade White to black palette       *
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

**************************** MAIN p_buf ************************>

default:
	bsr	Wait_vbl                     ; Waiting after the VBL

 IFEQ	SEEMYVBL
	clr.b $ffff8240.w                ; init line of CPU
 ENDC

* < Put your code here >

	bsr	scroll_Boules 

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
.next_key:                           ;
 ENDC

	cmp.b #$39,$fffffc02.w           ; SPACE key pressed ?
	bne	default

**************************** MAIN p_buf ************************<

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

	bsr	display_Boules               ; Display gfxs...
	bsr	display_Noextra
	bsr	print_text

	moveq #1,d0                      ; Choice of the music (1 is default)
	jsr	MUSIC+0                      ; Init SNDH music

	lea	Vbl(pc),a0                   ; Launch VBL
	move.l	a0,$70.w                 ;

	lea	Default_palette,a0           ; Put Default palette
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d7               ;
	movem.l	d0-d7,(a1)               ;

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
      CLR.B     $FFFFFA1B.W 
      MOVE.B    #1,$FFFFFA21.W
      MOVE.L    #HBL,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
.ligne:
      ADDQ.W    #2,PTR1_LINE_TOP
      CMPI.W    #$54,PTR1_LINE_TOP
      BLE.S     next_l1 
      CLR.W     PTR1_LINE_TOP 
next_l1:
      SUBQ.W    #2,PTR2_LINE_TOP
      TST.W     PTR2_LINE_TOP 
      BGE.S     next_l2 
      MOVE.W    #$54,PTR2_LINE_TOP
next_l2:
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
HBL:  CLR.B     $FFFFFA1B.W 
      MOVE.L    A0,-(A7)
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
      MOVE.L    (A7)+,A0
      MOVE.L    #HBL_ENTRE,$120.W 
      MOVE.B    #55,$FFFFFA21.W
      MOVE.B    #8,$FFFFFA1B.W
      MOVE.L    #$00000FFF,$ffff8240.w
      RTE 

HBL_ENTRE:
      CLR.B     $FFFFFA1B.W 
      MOVE.L    #HBL_ENTRE2,$120.W 
      MOVE.B    #135,$FFFFFA21.W
      MOVE.B    #8,$FFFFFA1B.W
      MOVE.L    #$00000000,$ffff8240.w
      RTE

HBL_ENTRE2:
      CLR.B     $FFFFFA1B.W 
      MOVE.L    #HBL_END,$120.W 
      MOVE.B    #5+1,$FFFFFA21.W
      MOVE.B    #8,$FFFFFA1B.W
      MOVE.L    #$00000FFF,$ffff8240.w
      RTE

HBL_END:
      MOVE.L    A0,-(A7)
      MOVE.L    A1,-(A7)
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
      MOVE.L    (A7)+,A1
      MOVE.L    (A7)+,A0
      
      BCLR      #0,$FFFFFA0F.W
     	
      jsr (MUSIC+8)                    ; Play SNDH music
      RTE 
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
	sf	$fffffa21.w
	sf	$fffffa1b.w
	lea	HBL(pc),a0                   ; Launch HBL
	move.l a0,$120.w                 ;
	bset	#0,$fffffa07.w	* Timer B on
	bset	#0,$fffffa13.w	* Timer B on
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
*                    AMIGA SCROLLER - 3 BITPLANES                   *
*                          ZORRO 2/NOEXTRA                          *
*********************************************************************
POSITION_BOULES equ 160*60 ; Position of the scroller               *
*********************************************************************
display_Boules:
	movea.l	physique(pc),a1
	adda.l	#POSITION_BOULES,a1
	movea.l	physique+4(pc),a2
	adda.l	#POSITION_BOULES,a2
	move.w	#7,d1
.loop:
	movea.l	#IMG_BOULES,a0
	move.l	#160*16/4-1,d0
	move.l	(a0),(a1)+
	move.l	(a0)+,(a2)+
	dbf	d0,*-2*2
	dbf	d1,.loop
	rts

display_Noextra:
	movea.l	physique(pc),a1
	adda.l	#192*160,a1
	movea.l	physique+4(pc),a2
	adda.l	#192*160,a2
	movea.l	#IMG_NOEXTRA,a0
	move.l	#160*5/4-1,d0
	move.l	(a0),(a1)+
	move.l	(a0)+,(a2)+
	dbf	d0,*-2*2
	rts

scroll_Boules:
      SUBI.W    #1,count
      BNE.S     p_buf 
      MOVE.W    #9,count
      MOVEQ     #0,D0 
      MOVEA.L   ptr_num,A0
      MOVE.B    (A0)+,D0
      BPL.S     .next 
      LEA       texte,A0
      MOVE.B    (A0)+,D0
.next:MOVE.L    A0,ptr_num
      SUBI.B    #32,D0 
      LSL.L     #3,D0 
      LEA       font,A1
      ADDA.L    D0,A1 
      LEA       buff2,A0
      MOVE.B    (A1)+,0(A0)
      MOVE.B    (A1)+,8(A0) 
      MOVE.B    (A1)+,16(A0)
      MOVE.B    (A1)+,24(A0)
      MOVE.B    (A1)+,32(A0)
      MOVE.B    (A1)+,40(A0)
      MOVE.B    (A1)+,48(A0)
      MOVE.B    (A1)+,56(A0)
p_buf:LEA       buff1,A0           ; ZooM the character...
      MOVEQ     #0,D0 
      MOVEQ     #0,D1 
      MOVE.W    4(A0),D0
      LSL.L     #1,D0 
      MOVE.W    D0,4(A0)
      SWAP      D0
      MOVE.W    2(A0),D1
      LSL.L     #1,D1 
      OR.W      D0,D1 
      MOVE.W    D1,2(A0)
      SWAP      D1
      MOVEQ     #0,D0 
      MOVE.W    0(A0),D0
      LSL.L     #1,D0 
      OR.W      D1,D0 
      MOVE.W    D0,0(A0)
      MOVEQ     #0,D0 
      MOVEQ     #0,D1 
      MOVE.W    12(A0),D0 
      LSL.L     #1,D0 
      MOVE.W    D0,12(A0) 
      SWAP      D0
      MOVE.W    10(A0),D1 
      LSL.L     #1,D1 
      OR.W      D0,D1 
      MOVE.W    D1,10(A0) 
      SWAP      D1
      MOVEQ     #0,D0 
      MOVE.W    8(A0),D0
      LSL.L     #1,D0 
      OR.W      D1,D0 
      MOVE.W    D0,8(A0)
      MOVEQ     #0,D0 
      MOVEQ     #0,D1 
      MOVE.W    20(A0),D0 
      LSL.L     #1,D0 
      MOVE.W    D0,20(A0) 
      SWAP      D0
      MOVE.W    18(A0),D1 
      LSL.L     #1,D1 
      OR.W      D0,D1 
      MOVE.W    D1,18(A0) 
      SWAP      D1
      MOVEQ     #0,D0 
      MOVE.W    16(A0),D0 
      LSL.L     #1,D0 
      OR.W      D1,D0 
      MOVE.W    D0,16(A0) 
      MOVEQ     #0,D0 
      MOVEQ     #0,D1 
      MOVE.W    28(A0),D0 
      LSL.L     #1,D0 
      MOVE.W    D0,28(A0) 
      SWAP      D0
      MOVE.W    26(A0),D1 
      LSL.L     #1,D1 
      OR.W      D0,D1 
      MOVE.W    D1,26(A0) 
      SWAP      D1
      MOVEQ     #0,D0 
      MOVE.W    24(A0),D0 
      LSL.L     #1,D0 
      OR.W      D1,D0 
      MOVE.W    D0,24(A0) 
      MOVEQ     #0,D0 
      MOVEQ     #0,D1 
      MOVE.W    36(A0),D0 
      LSL.L     #1,D0 
      MOVE.W    D0,36(A0) 
      SWAP      D0
      MOVE.W    34(A0),D1 
      LSL.L     #1,D1 
      OR.W      D0,D1 
      MOVE.W    D1,34(A0) 
      SWAP      D1
      MOVEQ     #0,D0 
      MOVE.W    32(A0),D0 
      LSL.L     #1,D0 
      OR.W      D1,D0 
      MOVE.W    D0,32(A0) 
      MOVEQ     #0,D0 
      MOVEQ     #0,D1 
      MOVE.W    44(A0),D0 
      LSL.L     #1,D0 
      MOVE.W    D0,44(A0) 
      SWAP      D0
      MOVE.W    42(A0),D1 
      LSL.L     #1,D1 
      OR.W      D0,D1 
      MOVE.W    D1,42(A0) 
      SWAP      D1
      MOVEQ     #0,D0 
      MOVE.W    40(A0),D0 
      LSL.L     #1,D0 
      OR.W      D1,D0 
      MOVE.W    D0,40(A0) 
      MOVEQ     #0,D0 
      MOVEQ     #0,D1 
      MOVE.W    52(A0),D0 
      LSL.L     #1,D0 
      MOVE.W    D0,52(A0) 
      SWAP      D0
      MOVE.W    50(A0),D1 
      LSL.L     #1,D1 
      OR.W      D0,D1 
      MOVE.W    D1,50(A0) 
      SWAP      D1
      MOVEQ     #0,D0 
      MOVE.W    48(A0),D0 
      LSL.L     #1,D0 
      OR.W      D1,D0 
      MOVE.W    D0,48(A0) 
      MOVEQ     #0,D0 
      MOVEQ     #0,D1 
      MOVE.W    60(A0),D0 
      LSL.L     #1,D0 
      MOVE.W    D0,60(A0) 
      SWAP      D0
      MOVE.W    58(A0),D1 
      LSL.L     #1,D1 
      OR.W      D0,D1 
      MOVE.W    D1,58(A0) 
      SWAP      D1
      MOVEQ     #0,D0 
      MOVE.W    56(A0),D0 
      LSL.L     #1,D0 
      OR.W      D1,D0 
      MOVE.W    D0,56(A0) 

; Scrolling...      
      MOVEQ     #$FF,D0 
      MOVEQ     #0,D1 
      MOVEQ     #7,D5 
      LEA       buff1,A0
      MOVE.L    physique(pc),A1
      ADDA.L    #POSITION_BOULES+6,a1
loop1:MOVE.L    (A0),D6 
      ADDQ.L    #8,A0 
      MOVEQ     #20-1,D7 
loop2:BTST      D7,D6 
      BEQ.S     .next1 
      MOVE.W    D0,(A1) 
      MOVE.W    D0,160(A1)
      MOVE.W    D0,320(A1)
      MOVE.W    D0,480(A1)
      MOVE.W    D0,640(A1)
      MOVE.W    D0,800(A1)
      MOVE.W    D0,960(A1)
      MOVE.W    D0,1120(A1) 
      MOVE.W    D0,1280(A1) 
      MOVE.W    D0,1440(A1) 
      MOVE.W    D0,1600(A1) 
      MOVE.W    D0,1760(A1) 
      MOVE.W    D0,1920(A1) 
      MOVE.W    D0,2080(A1) 
      MOVE.W    D0,2240(A1) 
      MOVE.W    D0,2400(A1) 
      BRA.S     .next2 
.next1:MOVE.W    D1,(A1) 
      MOVE.W    D1,160(A1)
      MOVE.W    D1,320(A1)
      MOVE.W    D1,480(A1)
      MOVE.W    D1,640(A1)
      MOVE.W    D1,800(A1)
      MOVE.W    D1,960(A1)
      MOVE.W    D1,1120(A1) 
      MOVE.W    D1,1280(A1) 
      MOVE.W    D1,1440(A1) 
      MOVE.W    D1,1600(A1) 
      MOVE.W    D1,1760(A1) 
      MOVE.W    D1,1920(A1) 
      MOVE.W    D1,2080(A1) 
      MOVE.W    D1,2240(A1) 
      MOVE.W    D1,2400(A1) 
.next2:ADDQ.L    #8,A1 
      DBF       D7,loop2
      LEA       15*160(A1),A1 
      DBF       D5,loop1
      RTS 

*********************************************************************
*                   TEXTE FONT 8*8 ONE BITPLANE                     *
*                          ZORRO 2/NOEXTRA                          *
*********************************************************************
CHARS      equ 40  ; chars per line, 80=for med res, 40 for low res *
LINES      equ 33  ; 33 for 8x8 font, 45 with 6x6 font              *
FONTSIZE   equ 8   ; 8=8x8, 6=6x6 font                              *
SHIFTSIZE  equ 4   ; 2=MED RESOLUTION, 4=LOW RESOLUTION             *
POS_TEXTE  equ 9*160  ; Position on the screen                      *
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
                
                movea.l physique(pc),a0
                lea     POS_TEXTE(a0),a0
                adda.w  pointeur_plan,a0
                adda.l  y_offset,a0
                adda.l  x_offset,a0
                
                movea.l physique+4(pc),a3
                lea     POS_TEXTE(a3),a3
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

***************************************************************
 SECTION	DATA                                             // *
***************************************************************

Default_palette:
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$0000,$0112,$0113,$0114,$0115,$0126,$0136,$0147

* << Full data here >>
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
	even
*
message:
	dc.b	$fd ; en 1er plan
	dc.b	"          ELITE AND NOEXTRA",0
	dc.b	"           PRESENT IN 2019",0,0
	dc.b	"              GAME NAME",0
	dc.b	"           (C)COMPANY NAME",$ff
	even
fonts:
	incbin	"8BITSF.DAT"
	even
*
count:
	dc.w	$1 
ptr_num:
	dc.l	num 
num:
	dc.l	-1
font:
	incbin	"FONT88D.DAT"
	even

texte:
	DC.B	" !",$22,"#$%&",$27,"()*+,-./0123456789:;<=>?ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	DC.W	-1
IMG_BOULES:
	incbin	"BOULEB.IMG"
IMG_NOEXTRA:
	incbin	"NOEXTRA.IMG"
	even

* <

MUSIC:
	incbin "TLT.SND"            ; SNDH Music played at the VBL
	even

***************************************************************
 SECTION	BSS                                              // *
***************************************************************

bss_start:

* << Full data here >>

buff1:
	ds.b	5 
buff2:
	ds.b	9995
	even
*
x_curs:
	ds.l 1
y_offset:
	ds.l 1
x_offset:
	ds.l 1
pointeur_plan:
	ds.w 1

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
