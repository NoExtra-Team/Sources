***************************************
* // EXTRA_V8.PRG                  // *
***************************************
* // Asm Intro Code Atari ST v0.44 // *
* // by Zorro 2/NoExtra (01/12/16) // *
* // http://www.noextra-team.com/  // *
***************************************
* // Original code : Zorro 2       // *
* // Gfx logo      : n/a           // *
* // Gfx font      : ripped        // *
* // Module        : HeatBeat      // *
* // Release date  : 16/01/2017    // *
* // Update date   : 18/11/2017    // *
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
SEEMYVBL         equ 1           ; See CPU used if you press ALT key *
ERROR_SYS        equ 1           ; Manage Errors System              *
FADE_INTRO       equ 1           ; Fade White to black palette       *
TEST_STE         equ 1           ; Code only for Atari STE machine   *
STF_INITS        equ 0           ; STF compatibility MODE            *
**********************************************************************
*              Notes : 0 = I use it / 1 = no need !                  *
**********************************************************************

Begin:
	jmp	ON_Y_VA

*--------------------------------------------------------------------------
TOTO:
	DC.B	"COMPILE EXTRA VOLUME -9- BY NOEXTRA TEAM IN 2017. "
	DC.B	"MEMBERS ARE : ATOMUS - ZORRO 2 - MISTER.A - MAARTAU - HYLST - YOGI."
	EVEN
*--------------------------------------------------------------------------

ON_Y_VA:
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

	jsr	test_4_ste                   ; Test STF or STE computer

	bsr	clear_bss                    ; Clean BSS stack
	
	bsr	Save_and_init_st             ; Save system parameters

	bsr	Init_screens                 ; Screen initialisations

 IFEQ STF_INITS
	jsr	Multi_boot                   ; Multi Atari Boot code from LEONARD/OXG
 ENDC

	bsr	Inits                        ; Other Initialisations

**************************** MAIN LOOP ************************>

	bsr	Play__Module                 ; Launch the Module Player

	bsr	init_scrolltext

default_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

 IFEQ	SEEMYVBL
	move.l	Default_palette,$ffff8240.w
 ENDC

* < Put your code here >

	tst.w	ste_flag               ; Install Music
	beq.s	.not_for_ste
	bsr	play_sphere_3d               ; 3d effects
.not_for_ste:

	bsr	scrolltext                   ; Scrolltext effects
	bsr	scrolltext                   ; Twice for more speed ...

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
	beq.w	functionKeyPressed         ; Find it !
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
	beq.s	functionKeyPressed

	bra	default_loop                 ; Loop...

functionKeyPressed:                ; Function Keys pressed

	bsr	Stop__Module                 ; Stop the Module Player

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
	jsr	fadein                       ; Fading White to Black Screen
 ENDC

	jsr	print_text                   ; Display Text Menu

	bsr	init_sphere                  ; Init 3d effect

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
* // Declarations here ...
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
* // Declarations here ...
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
* // Code here....
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

***************************************************************
***           SCROLLING WITH FONT 8x8 ONE BITPLANE          ***
***                     ZORRO2/NOEXTRA-TEAM                 ***
***************************************************************
PLAN_SCROLL EQU 2 ; Bitplane used for the scrolling           *
***************************************************************

init_scrolltext:move.l	#mtexte,ptr_mtexte
                rts
                
scrolltext:     move.w 	decal,d0
                cmp.w 	#8,d0
                bne.s 	scroll_it
                clr.w 	decal
                move.l 	ptr_mtexte,a1
                move.b 	(a1),d0
                cmp.b 	#$ff,d0               ; End of the sentences ?
                bne.s 	.no_re_init
                bsr     init_scrolltext
                move.l 	ptr_mtexte,a1
                move.b 	(a1),d0
.no_re_init:    addq.l 	#1,ptr_mtexte
                asl.l 	#3,d0
                lea     fonts_8x8,a1         ; Load font
                sub.w   #256,d0
                add.w 	d0,a1                ; Find the character in the font
                lea     buffer_carac,a2      ; Put in the Buffer
i               set 0
                rept 8
                move.b 	(a1)+,i(a2)
i               set i+2
                endr
scroll_it:      addq.w 	#1,decal             ; Put shifting character in the buffer
                lea     buffer_scroll,a1
                lea     buffer_carac,a2
i               set 0
                rept 8
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
i               set i+40
                endr
                move.l  physique(pc),a1      ; Put on the physical screen
                lea     160*188+PLAN_SCROLL(a1),a1 ; At this position and bitplane
                lea 	  buffer_scroll,a2     ; From the buffer
i               set 2
                rept 8
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
i               set i+160
                endr
                rts

*********************************************************************
***                  DISPLAY TEXT FONT 8x8 or 6x6                 ***
***              MED OR LOW RESOLUTION - ONE BITPLANE             ***
***                       ZORRO2/NOEXTRA-TEAM                     ***
*********************************************************************
CHARS      EQU 40  ; chars per line, 80=for med res, 40 for low res *
LINES      EQU 33  ; 33 for 8x8 font, 45 with 6x6 font              *
FONTSIZE   EQU 8   ; 8=8x8, 6=6x6 font                              *
SHIFTSIZE  EQU 4   ; 2=MED RESOLUTION, 4=LOW RESOLUTION             *
POS_SCR    EQU 160*46 ; Top Position in the Screens                 *
PLAN_SCR   EQU 4   ; Bitplane used to display the text              *
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
                lea     fonts,a1             ; and choose character font
                sub.w   #256,d0
                adda.w  d0,a1
                moveq   #0,d1                ; Position of the letter
                add.w   pointeur_plan,d1     ; in the two Screens
                add.l   y_offset,d1
                add.l   x_offset,d1
                movea.l physique,a0          ; In First screen
                lea     POS_SCR+PLAN_SCR(a0),a0
                adda.l  d1,a0
                movea.l physique+4,a3        ; In Second screen
                lea     POS_SCR+PLAN_SCR(a3),a3
                adda.l  d1,a3
                rept FONTSIZE                ; Print letter on Screens
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

line_feed:      clr.w   x_curs               ; back to first char
                addi.l  #FONTSIZE*160+160,y_offset ; when u reached ',0'
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
***                DISPLAY 3D POINTS ROUTINES               ***
***                 ROTATION X - 2 BITPLANES                ***
***************************************************************
NBRE_POINTS EQU 780/2+80-1 ; Number of dots displayed         *
***************************************************************

init_sphere:    lea.l cosinus,a0             ; Make Cosinus curve
                lea.l courbe,a1
                move.w #0,d0
.make_courbe:   move.w #50,d1
                muls.w (a0,d0.w),d1
                asr.w #7,d1
                addi.w #160,d1
                move.w d1,(a1)+
                move.w #10,d1
                muls.w 2(a0,d0.w),d1
                asr.w #7,d1
                muls.w #160,d1
                move.w d1,(a1)+
                addq.l #8,d0
                cmpi.w #1440,d0
                bne .make_courbe

                moveq.w #0,d7                ; X coordonates
                lea.l x_table,a0
.make_x_table:  move.w d7,d0
                move.w d0,d1
                lsr.w d0
                andi.w #$ffff-7,d0
                move.w d0,(a0)+
                lsl.w d0
                sub.w d0,d1
                move.w #32768,d0
                lsr.w d1,d0
                move.w d0,(a0)+
                addq.w #1,d7
                cmpi.w #320,d7
                bne .make_x_table
               
                lea.l sphere,a0              ; Make a sphere object
.make_object:   move.w (a0),d0
                asl.w #2,d0
                move.w d0,(a0)+
                move.w (a0),d0
                addi.w #100,d0
                mulu.w #160,d0
                move.w d0,(a0)+
                move.w (a0),d0
                asl.w #2,d0
                move.w d0,(a0)+
                cmpa.l #sphere_end,a0
                bne .make_object

                lea.l table,a0               ; Precalculate COS and SIN
                lea.l cosinus,a1
                move.w #0,d0
make_table:     move.w #-90,d1
.make_it:       move.w d1,d2
                move.w d1,d3
                muls.w (a1,d0.w),d2
                asr.w #7,d2
                muls.w 2(a1,d0.w),d3
                asr.w #7,d3
                move.w d2,(a0)+
                move.w d3,(a0)+
                addq.w #1,d1
                cmpi.w #90,d1
                bne .make_it
                addq.w #8,d0
                cmpi.w #1440,d0
                bne make_table  
                rts

play_sphere_3d: movea.l adr_buf1,a0          ; Clean old Dots
                moveq.w #0,d1
                rept (NBRE_POINTS/6)
                movem.l (a0)+,a1-a6
                move.w d1,(a1)
                move.w d1,(a2)
                move.w d1,(a3)
                move.w d1,(a4)
                move.w d1,(a5)
                move.w d1,(a6)
                endr
                move.l adr_buf1,a0 ; Swap clean Buffer
                move.l adr_buf2,adr_buf1
                move.l a0,adr_buf2

courbe_reg:     lea.l courbe,a0              ; 3d coordonates
                move.w (a0)+,d7
                move.w (a0)+,d1
                addq.l #4,a0
                cmpa.l #courbe+180*4,a0
                blo .nofin_courbe
                lea.l courbe,a0
.nofin_courbe:  move.l a0,courbe_reg+2
alpha_reg:      lea.l table+90*4,a6
                adda.l #180*4,a6
                cmpa.l #table+90*4+180*180*4,a6
                bne .nofin_table
                lea.l table+90*4,a6
.nofin_table:   move.l a6,alpha_reg+2
                movea.l a6,a3

                lea.l sphere,a0              ; Display Dots
                movea.l adr_buf2,a1
                lea.l x_table,a5
                move.w #NBRE_POINTS-1,d0
                move.l physique(pc),d6 
.traite_3d:     move.w (a0)+,a6
                move.w (a0)+,a4
                move.w (a0)+,a2
                adda.l a3,a6
                adda.l a3,a2
                move.w (a6)+,d4
                move.w (a2)+,d5
                add.w (a2)+,d4
                add.w d7,d4
                add.w d4,d4
                add.w d4,d4
                adda.w (a5,d4.w),a4
                add.l d6,a4
                move.w 2(a5,d4.w),d2
                sub.w (a6)+,d5
                bmi.s .no_bleme
                addq.w #2,a4
.no_bleme:      or.w d2,(a4)
                move.l a4,(a1)+
                dbf d0,.traite_3d
                rts

; *************************************************************************
; ***                      Replayer Mods for ST and STe                 ***
; ***                    by WizzCat the 21st of May 1991                ***
; *************************************************************************
Play__Module:  	tst.w	ste_flag               ; Install Music
               	bne.s	.init_ste
               	bsr	muson_stfm
               	bra.s	.init_stfm_ok
.init_ste:      bsr	muson_ste
.init_stfm_ok:  rts

Stop__Module:  	tst.w	ste_flag               ; Stop Music
               	bne.s	.shut_down_ste
               	bsr	musoff_stfm
               	bra.s	.musoff_stfm_e
.shut_down_ste:	bsr	musoff_ste
.musoff_stfm_e: rts

*******************************
*       Replay Frequency      *
*******************************
* STE = 25.036 Khz (Option 2) *
* STF = 16.384 Khz (Option 3) *
*******************************
 include	"PLAYER.ASM"             ; Librairies
 even

mod_data:
	incbin	"BUBBLEG.MOD"
	even
	ds.b	64000/4	                     ; Workspace (Size of the module div 4)
workspc:
	ds.w	1
	even

***************************************************************
 SECTION	DATA                                             // *
***************************************************************

Default_palette:
	dc.w	$0001,$0417,$0103,$0204,$0777,$0777,$0777,$0777
	dc.w	$0456,$0456,$0456,$0456,$0700,$0700,$0700,$0676

* << Full data here >>

; Text datas
; ASCII character : ESP!'#$%&"()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyzCUR
; Character $ff = end of text / $fd = bitplane one / $fc = bitplane two
message:
	DC.B	$fd,"  EXTRA VOLUME 8 SPECIAL ATARI-LEGEND   ",0,0
	DC.B	$fd,"  F1  Intro ",$fc,"Advanced Tactical Fighter",0
	DC.B	$fd,"  F2  Intro ",$fc,"Bill Palmer",0
	DC.B	$fd,"  F3  Intro ",$fc,"Challenge",0
	DC.B	$fd,"  F4  Intro ",$fc,"Global Commander",0
	DC.B	$fd,"  F5  Intro ",$fc,"L'ange de Cristal",0
	DC.B	$fd,"  F6  Intro ",$fc,"Bently Bears 3",0
	DC.B	$fd,"  F7  Intro ",$fc,"Bently Bears 4",0
	DC.B	$fd,"  F8  Intro ",$fc,"Au Nom de l'Hermine",0
	DC.B	$fd,"  F9  Intro ",$fc,"Maternelle 4 et 5 ans",0
	DC.B	$fd,"  F10 Intro ",$fc,"Objectif monde",$ff
	even
fonts:
	incbin 	"FONT8_8.DAT"
	even

; Scrolling datas
mtexte: 
; ASCII character : ESP!'#$%&"()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyzCUR
; Character $ff = end of text
	dc.b	"          "
	dc.b "WELCOME TO THE EIGHTH EXTRA VOLUME BY NOEXTRA-TEAM IN 2017. "
	dc.b "MENU CODED BY ZORRO2, LOADER CODED BY ZORRO2 AND MAARTAU, GFX INTRO BY MISTER.A AND AMIGA MODULE BY HEATBEAT FROM REBELS. "
	dc.b "ENJOY ALL INTROS USED BY ATARI LEGEND INSIDE THIS DELICIOUS MENU ! AND DON'T FORGET TO USE FUNTION KEY 1 TO 10 TO SELECT OUR INTRO TO SEE. "
	dc.b "I LET MUG UK OF ATARI LEGEND TO FINISH THIS SCROLLTEXT AND SEE YOU SOON FOR THE NEXT TIME !!! "
	dc.b	"                                  "
* Mike's Mee sentences
	dc.b	"WELCOME ONE AND ALL TO THE LATEST INTRO COMPILATION DISK FROM NO EXTRA. AS THIS DISK FEATURES "
	dc.b	"NOTHING BUT INTROS CODED FOR ATARI LEGEND, WE ASKED MUG UK TO WRITE THE SCROLLTEXT. AT LEAST WE "
	dc.b	"IT WAS HIM THAT WROTE IT, OR IT COULD BE HIS BEARD! "
	dc.b	"HI ALL! IT'S BEEN A LONG TIME SINCE I PUT TEXT INTO A SCROLLTEXT, SO BEAR WITH ME WHILST I GET "
	dc.b	"USED TO WRITING SOMETHING THAT IS USEFUL! THIS DISK CONTAINS NOTHING BUT INTROS BY THE EXCELLENT "
	dc.b	"NO EXTRA TEAM THAT WE (IN ATARI LEGEND) USED ON A NUMBER OF RELEASES, MOSTLY THE RARER TITLES THAT "
	dc.b	"OUR TEAM JUST KEEPS ON FINDING. THE INTROS ON THIS DISK ARE FROM ONE OF OUR PRODUCTIVE AGES "
	dc.b	"(UP UNTIL 2007), BEFORE ALL OF ATARI LEGEND TOOK THAT EXTRA LONG SLEEP AS WE ALL GOT ON WITH REAL LIFE STUFF. "
	dc.b	"WE WERE PRESERVING SO MANY TITLES THAT WERE A COMBINATION OF ODD, FRENCH, OR JUST NEVER-BEFORE-RELEASED TITLES, "
	dc.b	"THAT WE WERE VERY LUCKY TO HAVE NO EXTRA AVAILABLE TO CREATE THE INTROS. "
	dc.b	"THESE DAYS, IT IS STILL THE SAME TEAM WORK. YOU CAN SEE ON SOME OF OUR MORE RECENT (2017) RELEASES. YET MORE RARE "
	dc.b	"TITLES AND THEY FEATURE INTROS BY NO EXTRA. THERE'S PLENTY MORE TITLES TO COME, INCLUDING SOME TRANSLATION WORK THAT "
	dc.b	"MYSELF, BRUME AND MAARTAU ARE WORKING ON. I CAN'T SAY MORE THAN THAT, BUT I WILL TELL YOU THAT IT'S A LOT EASIER THESE "
	dc.b	"DAYS TO USE MODERN TOOLS, INCLUDING EXCEL, TO HELP GET OLD TITLES TRANSLATED INTO OTHER LANGUAGES. HAVING A CREW WITH "
	dc.b	"MULTIPLE LANGUAGE SKILLS ALSO HELPS AS WE FINE-TUNE THE FIRST PASS TRANSLATION INTO MORE READABLE TEXT. I RECENTLY GOT "
	dc.b	"A LESSON IN FRENCH HUMOUR AS SOME TEXT IN A GAME REALLY DIDN'T GEL IN MY HEAD. UNTIL BRUME POINTED OUT THAT THEY WERE "
	dc.b	"FAKE NAMES WHICH WERE ACTUALLY PLAYS ON WORDS. D'OH! I FELL FOR THAT ONE! SO LOOK OUT FOR OUR NEXT BATCH OF RELEASES "
	dc.b	"AND, AS ALWAYS, THANKS TO NO EXTRA FOR THE INTROS AND LETTING ME WRITE THIS TEXT. NOW I'M BACK OFF TO PLAY MORE FALLOUT 4 "
	dc.b	"ON MY XBOX ONE! CHEERIO! "
*
	dc.b	"                                                                             "
	dc.b	"BONUS : ALL ASM CODE SOURCE TO DO THIS MENU AND LOADER ARE AVAILABLE. KEEP INFORM OF ALL SOURCES FROM NOEXTRA IN OUR GITHUB WEBSITE AT HTTPS://GITHUB.COM/NOEXTRA-TEAM/. "
	dc.b	"                                                           "
	dc.b	"                       LET'S WRAP AGAIN !!!!                                 "
	dc.b	"                                                           "
	dc.b $ff
	even
fonts_8x8:
	incbin	"AMIGA4F.DAT"
	even

; 3d effect datas
adr_buf1:
 dc.l clr_table
adr_buf2:
 dc.l clr_table2
clr_table:
 rept NBRE_POINTS
 dc.l efface_point
 endr
clr_table2:
 rept NBRE_POINTS
 dc.l efface_point
 endr
sphere:
 incbin "DATA3D.DAT"
sphere_end:
	even
cosinus:
 incbin "cosinus.dat"
 even

* <

***************************************************************
 SECTION	BSS                                              // *
***************************************************************

bss_start:

* << Full data here >>

; Text datas
x_curs:
	ds.l 1
y_offset:
	ds.l 1
x_offset:
	ds.l 1
pointeur_plan:
	ds.w 1
	even

; Scroll datas
ptr_mtexte:
	ds.l	1
decal:
	ds.w 	1
buffer_carac:
	ds.w 	8
buffer_scroll:
	ds.l	8*10                                                                                              
	even

; 3d effect datas
x_table:
 ds.w 320*2
table:
 ds.l 180*180
table2:
courbe:
 ds.w 180*2
efface_point:
	ds.l	1
	even

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
	jsr	black_out                    ; Palette colors to zero
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
