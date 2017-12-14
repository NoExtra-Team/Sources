***************************************
* // XXXXXXXX.PRG                  // *
***************************************
* // Asm Intro Code Atari ST v0.44 // *
* // by Zorro 2/NoExtra (01/12/16) // *
* // http://www.noextra-team.com/  // *
***************************************
* // Original code :               // *
* // Gfx logo      :               // *
* // Gfx font      :               // *
* // Music         : JEDI          // *
* // Release date  : xx/xx/2016    // *
* // Update date   : xx/xx/2016    // *
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
ERROR_SYS        equ 0           ; Manage Errors System              *
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

	movea.l	physique+4(pc),a2
	movea.l	physique(pc),a1
	move.l	#fond_img+34,a0
	move.l	#160*200/4-1,d0
	move.l	(a0),(a1)+
	move.l	(a0)+,(a2)+
	dbf	d0,*-2*2

	bsr	init_mscroll

default_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

 IFEQ	SEEMYVBL
	clr.b $ffff8240.w                ; init line of CPU
 ENDC

* < Put your code here >

	bsr	mscroll

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

 IFEQ	FADE_INTRO
	bsr	fadein                       ; Fading White to Black Screen
 ENDC

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
* // Declarations here ...
 ENDC

	jsr (MUSIC+8)                    ; Play SNDH music

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
*                  SMALL SCROLL FONT - 1 BITPLANE                   *
*                          ZORRO 2/NOEXTRA                          *
*********************************************************************
init_mscroll:
	move.l	#mtexte,Mptr_mtexte
	rts

mscroll:
	move.w 	Mpas_car,d0
	cmp.w 	#8,d0
	bne.s 	plusloin3
	clr.w 	Mpas_car
	move.l 	Mptr_mtexte,a1
	move.b 	(a1),d0
	cmp.b 	#255,d0
	bne.s 	lsuite
	move.l 	#mtexte,Mptr_mtexte
	move.l 	Mptr_mtexte,a1
	move.b 	(a1),d0
lsuite:
	addq.l 	#1,Mptr_mtexte
	asl.l 	#3,d0
	lea 	mfonts,a1
	sub.w	#256,d0
	add.w 	d0,a1
	lea 	Mbuffer_car,a2

i set 0
 rept 8-2
	move.b 	(a1)+,i(a2)	;	Caracter to Buffer
i set i+2
 endr

plusloin3:
	addq.w 	#1,Mpas_car
	lea 	Mbuffer_mscrol,a1	;	Display buffer + left scroll
	lea 	Mbuffer_car,a2
i set 0
 rept 8-2
	roxl 	(a2)+
;	roxl 	i+38(a1)
;	roxl 	i+36(a1)
;	roxl 	i+34(a1)
;	roxl 	i+32(a1)
;	roxl 	i+30(a1)
;	roxl 	i+28(a1)
;	roxl 	i+26(a1)
;	roxl 	i+24(a1)
;	roxl 	i+22(a1)
;	roxl 	i+20(a1)
;	roxl 	i+18(a1)
;	roxl 	i+16(a1)
;	roxl 	i+14(a1)
;	roxl 	i+12(a1)
	roxl 	i+10(a1)
	roxl 	i+8(a1)
	roxl 	i+6(a1)
	roxl 	i+4(a1)
	roxl 	i+2(a1)
	roxl 	i+0(a1)
i set i+40
 endr
	move.l 	physique(pc),a1	;	buffer to screen
	lea	160*97+8*7(a1),a1
	lea 	Mbuffer_mscrol,a2
i set 2
 rept 6	*	hauteur du scroll
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
i set 	i+160
 endr
	rts

***************************************************************
 SECTION	DATA                                             // *
***************************************************************

Default_palette:
	dc.w	$000,$777,$111,$222,$333,$444,$555,$666
	dc.w	$777,$111,$222,$333,$444,$555,$666,$077

* << Full data here >>

mtexte:
* < !'#$%&"()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyzCUR> *
	dc.b " !",$22,"#$%&",$27,"()*+,-./0123456789:;<=>?@"
	dc.b "ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`"
	dc.b "abcdefghijklmnopqrstuvwxyz"
	dc.b "        "
	dc.b	$ff
	even
mfonts:
	incbin	"fontsmall.DAT" * E:\0\scrollb.txt\
	even

fond_img:
	incbin	"96x54.pi1"
	even

* <

MUSIC:
	incbin "JEDIFUN.SND"            ; SNDH Music played at the VBL
	even

***************************************************************
 SECTION	BSS                                              // *
***************************************************************

bss_start:

* << Full data here >>

Mptr_mtexte:
	ds.l	1
Mpas_car:
	ds.w 	1
Mbuffer_car:
	ds.w 	8
Mbuffer_mscrol:
	ds.w	200
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
