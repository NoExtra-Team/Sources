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
PATTERN          equ $00010001   ; Fill Screens with a plan pattern  *
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

 bsr init_line
 bsr make_courbe

default_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

 IFEQ	SEEMYVBL
	clr.b $ffff8240.w                ; init line of CPU
 ENDC

* < Put your code here >

	bsr	hidden_square

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

hidden_square:
; efface ancien objet

 movea.l adr_clr1,a0
 move.l fin_clr1,d1
 moveq.w #0,d0
eff_object
 movem.l (a0)+,a1-a6
 move.b d0,(a1)
 move.b d0,(a2)
 move.b d0,(a3)
 move.b d0,(a4)
 move.b d0,(a5)
 move.b d0,(a6)
 cmp.l d1,a0
 blo.s eff_object

; calcul 3d pour la figure
 lea.l points,a0
 lea.l object,a1
courbe_reg
 lea.l courbe,a3
 move.w #nbre_points-1,d0			Six face de 4 points !
calcul
 move.w (a0)+,d1
 move.w (a0)+,d2
 move.w (a0)+,d3

; rotation X

 lea.l cosinus,a2
 add.w alpha,a2
 move.w (a2)+,d6
 move.w (a2),d7
 move.w d2,d4
 move.w d3,d5
 muls.w d6,d2
 muls.w d7,d3
 add.w d3,d2
 asr.w #7,d2
 muls.w d6,d5
 muls.w d7,d4
 sub.w d4,d5
 asr.w #7,d5
 move.w d5,d3

; rotation Y

 lea.l cosinus,a2
 add.w beta,a2
 move.w (a2)+,d6
 move.w (a2),d7
 move.w d1,d4
 move.w d3,d5
 muls.w d6,d1
 muls.w d7,d3
 add.w d3,d1
 asr.w #7,d1
 muls.w d6,d5
 muls.w d7,d4
 sub.w d4,d5
 asr.w #7,d5
 move.w d5,d3

; projection

 add.w 4(a3),d3
 asr.w d3
 add.w #250-100,d3
 muls.w d3,d1
 muls.w d3,d2
 asr.w #8,d1
 asr.w #8,d2

 add.w (a3),d1
 add.w #200/2,d2
 move.w d1,(a1)+
 move.w d2,(a1)+
 dbf d0,calcul

 add.w #6*2,a3
 cmp.l #courbe+6*360,a3
 blo.s nofin_courbe
 sub.l #6*360,a3
nofin_courbe
 move.l a3,courbe_reg+2

; affiche l'objet en 3d (face par face)

 lea.l face_data,a0
 lea.l object,a1
 movea.l adr_clr1,a3
 move.w #nbre_face-1,d7
aff_object

; test si face cache

 move.w (a0)+,d6
 move.w (a1,d6.w),d0		X1
 move.w 2(a1,d6.w),d1		Y1
 move.w (a0)+,d6
 move.w (a1,d6.w),d2		X2
 move.w 2(a1,d6.w),d3		Y2
 move.w (a0),d6
 move.w (a1,d6.w),d4		X3
 move.w 2(a1,d6.w),d5		Y3
 subq.l #4,a0
 sub.w d0,d4
 sub.w d1,d3 
 sub.w d0,d2
 sub.w d1,d5
 muls.w d4,d3
 muls.w d2,d5
 sub.w d5,d3
 tst.w d3
 bmi no_trace

 move.w (a0),d6
 move.w (a1,d6.w),d0
 move.w 2(a1,d6.w),d1
 move.w 2(a0),d6
 move.w (a1,d6.w),d2
 move.w 2(a1,d6.w),d3
 movem.l a0-a1/d7,-(sp)
 move.l physique+4,a0
 bsr line
 movem.l (sp)+,a0-a1/d7

 move.w 2(a0),d6
 move.w (a1,d6.w),d0
 move.w 2(a1,d6.w),d1
 move.w 4(a0),d6
 move.w (a1,d6.w),d2
 move.w 2(a1,d6.w),d3
 movem.l a0-a1/d7,-(sp)
 movea.l physique+4,a0
 bsr line
 movem.l (sp)+,a0-a1/d7

 move.w 4(a0),d6
 move.w (a1,d6.w),d0
 move.w 2(a1,d6.w),d1
 move.w 6(a0),d6
 move.w (a1,d6.w),d2
 move.w 2(a1,d6.w),d3
 movem.l a0-a1/d7,-(sp)
 movea.l physique+4,a0
 bsr line
 movem.l (sp)+,a0-a1/d7

 move.w 6(a0),d6
 move.w (a1,d6.w),d0
 move.w 2(a1,d6.w),d1
 move.w (a0),d6
 move.w (a1,d6.w),d2
 move.w 2(a1,d6.w),d3
 movem.l a0-a1/d7,-(sp)
 movea.l physique+4,a0
 bsr line
 movem.l (sp)+,a0-a1/d7

no_trace
 addq.l #8,a0
 dbf d7,aff_object 
 move.l a3,fin_clr1

; swappe les buffers correspondant

 move.l adr_clr1,d0
 move.l adr_clr2,adr_clr1
 move.l d0,adr_clr2

 move.l fin_clr1,d0
 move.l fin_clr2,fin_clr1
 move.l d0,fin_clr2

; augmente rotation

 add.w #4*3,alpha
 cmp.w #360*4,alpha
 blo.s nofin_alpha
 sub.w #360*4,alpha
nofin_alpha

 add.w #4*2,beta
 cmp.w #360*4,beta
 blo.s nofin_beta
 sub.w #360*4,beta
nofin_beta
	rts

make_courbe
 lea.l cosinus,a0
 lea.l courbe,a1
 lea.l cosinus,a2
 move.w #0,d0
make_courbe2
 move.w #50/2-4,d1
 move.w d0,d2
 mulu.w #1,d2
 divu.w #360,d2
 swap d2
 lsl.w #2,d2
 muls.w (a2,d2.w),d1
 asr.w #7,d1
 add.w #160,d1
 move.w d1,(a1)+

 move.w #30,d1
 move.w d0,d2
 mulu.w #3,d2
 divu.w #360,d2
 swap d2
 lsl.w #2,d2
 muls.w 2(a2,d2.w),d1
 asr.w #7,d1
 add.w #100,d1
 move.w d1,(a1)+

 move.w #40,d1
 move.w d0,d2
 mulu.w #2,d2
 divu.w #360,d2
 swap d2
 lsl.w #2,d2
 muls.w (a2,d2.w),d1
 asr.w #7,d1
 add.w #110,d1
 move.w d1,(a1)+
 
 addq.w #1,d0
 cmp.w #360,d0
 bne.s make_courbe2
 rts

;;;;;;;;;;;;;;;;;;;;
; routine de ligne ;
;;;;;;;;;;;;;;;;;;;;

line
 add.w #200,d0			On augmente toute les coord.
 add.w #200,d1			Pour rester positifs pour
 add.w #200,d2			Que les test du clipping se verifient
 add.w #200,d3
 cmp.w d0,d2			Tracage de gauche a droite
 bhi.s sens_x_ok
 exg d0,d2
 exg d1,d3
sens_x_ok
 cmpi.w #199,d2			On teste si la ligne est contenue
 bhi.s no_clip1			Dans l'ecran
 rts
no_clip1
 cmpi.w #320+200,d0
 blo.s no_clip2
 rts
no_clip2
 cmp.w #199,d1
 bhi.s no_clip3
 cmp.w #199,d3
 bhi.s no_clip3
 rts
no_clip3
 cmp.w #200+200,d1
 blo.s no_clip4
 cmp.w #200+200,d3
 blo.s no_clip4
 rts
no_clip4
 move.w d2,d4
 move.w d3,d5
 sub.w d0,d4			Dx
 sub.w d1,d5			Dy
 move.w #$a0,a2			Sens arbitraire de la pente
 cmp.w d1,d3
 bhi.s sens_y_ok
; move.w #$005,$ffff8240.w
 move.w #-$a0,a2		Inverse sens de la pente
 neg.w d5
sens_y_ok
 cmp.w d4,d5
 bhi line_y

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; routine de ligne horizontale (Dx>Dy) ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

line_x
 cmp.w d4,d5			Traitement des diagonales
 bne.s no_diag
 addq.w #1,d4
no_diag
 swap d5
 divu.w d4,d5			D5=pente

 cmp.w #199,d1 			Clipping haut
 bhi.s ok_clip3
 move.w #200,d6
 sub.w d1,d6
 swap d6
 divu.w d5,d6
 add.w d6,d0
 move.w #200,d1
ok_clip3

 cmp.w #199,d3			Clipping haut II
 bhi.s ok_clip4
 move.w #200,d6
 sub.w d3,d6
 swap d6
 divu.w d5,d6
 sub.w d6,d2
 move.w #200,d3
ok_clip4

 cmp.w #200+200,d3		Clipping Bas I
 blo.s ok_clip5
 sub.w #400,d3
 swap d3
 divu.w d5,d3
 sub.w d3,d2
 move.w #199+200,d3
ok_clip5

 cmp.w #200+200,d1		Clipping bas II
 blo.s ok_clip6
 sub.w #400,d1
 swap d1
 divu.w d5,d1
 add.w d1,d0
 move.w #199+200,d1
ok_clip6

 cmp.w #199,d0			Clipping gauche
 bhi.s ok_clip2
; move.w #$310,$ffff8240.w
 move.w #200,d6
 sub.w d0,d6
 mulu.w d5,d6
 swap d6
 cmp.w #$a0,a2
 beq.s ok_a2
 sub.w d6,d1
 bra.s ok_a2_2
ok_a2
 add.w d6,d1
ok_a2_2
 move.w #200,d0
ok_clip2

 sub.w #200,d0			On remet les coordonnes
 sub.w #200,d1			En etat car clipping termine
 sub.w #200,d2
 sub.w #200,d3

 lea.l table_y,a1		Trouve adresse ecran
 add.w d1,d1
 add.w d1,a1
 add.w (a1),a0
 lea.l table_x,a1
 add.w d0,d0
 add.w d0,a1
 add.w (a1),a0

 lea.l offset_x,a1		Pose adresse de saut et RTS
 add.w d0,d0			Feinte:d0 ‚tait dej… *2
 add.w d0,a1			
 move.l (a1),a1
 move.l a1,saut+2		Adresse de saut

 lea.l offset_x,a1
 add.w d2,d2
 add.w d2,d2
 add.w d2,a1
 cmp.l #offset_x2,a1		Clipping droite
 blo.s ok_clip1
 lea.l offset_x2-4,a1
ok_clip1
 move.l (a1),a1
 move.w (a1),r_rts+2		Ancien Contenu
 move.l a1,r_rts+4		Adresse de Rts
 move.w #$4e75,(a1)		Pose le rts
 
 move.w d5,a1			a1=pente 
 moveq.w #-128,d0		Valeur de chaque point
 moveq.w #64,d1			Composant l'octet d'ecran
 moveq.w #32,d2
 moveq.w #16,d3
 moveq.w #8,d4
 moveq.w #2,d5
 moveq.w #1,d6
 moveq.w #0,d7			Compteur de pente
saut  jsr code_x
 move.l a0,(a3)+ 
r_rts move.w #0,code_x
 rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; routine de ligne verticale (Dy>Dx) ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

line_y
 swap d4
 divu.w d5,d4

 cmp.w #199,d0			Clipping gauche
 bhi.s ok_clip7
 move.w #200,d6
 sub.w d0,d6
 swap d6
 divu.w d4,d6
 sub.w d6,d5
 cmp.w #$a0,a2
 beq.s ok_a2_3
 sub.w d6,d1
 bra.s ok_a2_4
ok_a2_3
 add.w d6,d1 
ok_a2_4
 move.w #200,d0
ok_clip7

 cmp.w #320+200,d2		Clipping droite
 blo.s ok_clip8
 sub.w #320+200,d2
 swap d2
 divu.w d4,d2
 sub.w d2,d3
 sub.w d2,d5
 move.w #319+200,d2
ok_clip8

 cmp.w #199,d3			Clipping haut I
 bhi.s ok_clip9
 move.w #200,d6
 sub.w d3,d6
 sub.w d6,d5
 swap d6
 tst.w d4
 bne.s ok_d4_1
 moveq.w #0,d6
 bra.s ok_d4_2
ok_d4_1
 divu.w d4,d6
ok_d4_2
 sub.w d6,d2
 move.w #200,d3
ok_clip9 

 cmp.w #199,d1			Clipping haut II
 bhi.s ok_clip10
; move.w #$324,$ffff8240.w
 move.w #200,d6
 sub.w d1,d6
 sub.w d6,d5
 mulu.w d4,d6
 swap d6
 add.w d6,d0
 move.w #200,d1
ok_clip10 

 cmp.w #200+200,d1		Clipping bas I
 blo.s ok_clip11
 sub.w #400,d1
 sub.w d1,d5
 mulu.w d4,d1
 swap d1
 add.w d1,d0
 move.w #199+200,d1
ok_clip11

 cmp.w #200+200,d3		Clipping bas II
 blo.s ok_clip12
 sub.w #400,d3
 sub.w d3,d5
 mulu.w d4,d3
 swap d3
 sub.w d3,d2
 move.w #199+200,d3
ok_clip12

 subi.w #200,d0
 subi.w #200,d1
 subi.w #200,d2
 subi.w #200,d3

 move.l #$00010007,d2
 lea.l table_x2,a1		Calcul adresse ecran
 add.w d0,d0
 add.w d0,d0
 add.w d0,a1
 add.w (a1)+,a0
 move.w (a1),d0
 cmpi.w #8,d0
 blo.s ok_d2
 subq.w #8,d0
 swap d2
 subq.w #1,a0
ok_d2
 addq.w #1,a0
 lea.l table_y,a1
 add.w d1,d1
 add.w d1,a1
 add.w (a1),a0

 lea.l offset_y,a1
 add.w d5,d5
 add.w d5,d5
 add.w d5,a1
 cmp.l #offset_y2,a1
 blo.s clip_bas
 lea.l offset_y2-4,a1
clip_bas
 move.l (a1),a1
 move.w (a1),r_rts2+2
 move.l a1,r_rts2+4
 move.w #$4e75,(a1)

 moveq.w #0,d7
 move.w a2,d1
 jsr code_y
r_rts2
 move.w #0,code_y
 move.l a0,(a3)+
 rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; code genere pour routine verticale ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

code_y
 move.l a0,(a3)+
 bset.b d0,(a0)
 add.w d1,a0
 add.w d4,d7
 bcc.s code_y2
 dbf d0,code_y2
 moveq.w #7,d0
 add.w d2,a0
 swap d2
code_y2
 ds.b 199*(code_y2-code_y)
y_rts
 rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; code genere pour routine horizontale ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

code_x
 or.b d0,(a0)			; 128
 add.w a1,d7
 bcc.s code_x1
 move.l a0,(a3)+
 add.w a2,a0
code_x1
 or.b d1,(a0)			; 64	
 add.w a1,d7
 bcc.s code_x2
 move.l a0,(a3)+
 add.w a2,a0
code_x2
 or.b d2,(a0)			; 32	
 add.w a1,d7
 bcc.s code_x3
 move.l a0,(a3)+
 add.w a2,a0
code_x3
 or.b d3,(a0)			; 16	
 add.w a1,d7
 bcc.s code_x4
 move.l a0,(a3)+
 add.w a2,a0
code_x4
 or.b d4,(a0)			; 08
 add.w a1,d7
 bcc.s code_x5
 move.l a0,(a3)+
 add.w a2,a0
code_x5
 bset.b d5,(a0)			; 04
 add.w a1,d7
 bcc.s code_x6
 move.l a0,(a3)+
 add.w a2,a0
code_x6
 or.b d5,(a0)			; 02
 add.w a1,d7
 bcc.s code_x7
 move.l a0,(a3)+
 add.w a2,a0
code_x7
 move.l a0,(a3)+
 or.b d6,(a0)+			; 01
 add.w a1,d7
 bcc.s code_x8
 add.w a2,a0
code_x8
 or.b d0,(a0)			; 128
 add.w a1,d7
 bcc.s code_x9
 move.l a0,(a3)+
 add.w a2,a0
code_x9
 or.b d1,(a0)			; 64	
 add.w a1,d7
 bcc.s code_x10
 move.l a0,(a3)+
 add.w a2,a0
code_x10
 or.b d2,(a0)			; 32	
 add.w a1,d7
 bcc.s code_x11
 move.l a0,(a3)+
 add.w a2,a0
code_x11
 or.b d3,(a0)			; 16	
 add.w a1,d7
 bcc.s code_x12
 move.l a0,(a3)+
 add.w a2,a0
code_x12
 or.b d4,(a0)			; 08
 add.w a1,d7
 bcc.s code_x13
 move.l a0,(a3)+
 add.w a2,a0
code_x13
 bset.b d5,(a0)			; 04
 add.w a1,d7
 bcc.s code_x14
 move.l a0,(a3)+
 add.w a2,a0
code_x14
 or.b d5,(a0)			; 02
 add.w a1,d7
 bcc.s code_x15
 move.l a0,(a3)+
 add.w a2,a0
code_x15
 move.l a0,(a3)+
 or.b d6,(a0)+			; 01
 add.w a1,d7
 bcc.s code_x16
 add.w a2,a0
code_x16
 move.l a0,(a3)+
 addq.w #6,a0
code_x17
 ds.b 19*(code_x17-code_x)
x_rts
 rts
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; routine d'initialisation ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

init_line
 lea.l code_x,a0
 lea.l code_x17,a1
 move.w #19*(code_x17-code_x)-1,d0
rempli_code_x
 move.b (a0)+,(a1)+
 dbf d0,rempli_code_x
 
 lea.l offset_x,a0
n set 0
 rept 20
 move.l #code_x+n,(a0)+
 move.l #code_x1+n,(a0)+
 move.l #code_x2+n,(a0)+
 move.l #code_x3+n,(a0)+
 move.l #code_x4+n,(a0)+
 move.l #code_x5+n,(a0)+
 move.l #code_x6+n,(a0)+
 move.l #code_x7+n,(a0)+
 move.l #code_x8+n,(a0)+
 move.l #code_x9+n,(a0)+
 move.l #code_x10+n,(a0)+
 move.l #code_x11+n,(a0)+
 move.l #code_x12+n,(a0)+
 move.l #code_x13+n,(a0)+
 move.l #code_x14+n,(a0)+
 move.l #code_x15+n,(a0)+
n set n+(code_x17-code_x)
 endr

 lea.l code_y,a0
 lea.l code_y2,a1
 move.w #199*(code_y2-code_y)-1,d0
rempli_code_y
 move.b (a0)+,(a1)+
 dbf d0,rempli_code_y

 lea.l offset_y,a0
 lea.l code_y,a1
 move.w #199,d0
r_offset_y
 move.l a1,(a0)+
 adda.l #(code_y2-code_y),a1
 dbf d0,r_offset_y

 lea.l table_y,a0
 move.w #199,d1
 moveq.w #0,d0
rempli_table_y
 move.w d0,(a0)+
 addi.w #160,d0
 dbf d1,rempli_table_y

 lea.l table_x,a0
 move.w #19,d0
 move.w #0,d1
rempli_table_x
 rept 8
 move.w d1,(a0)+
 endr
 addq.l #1,d1
 rept 8
 move.w d1,(a0)+
 endr
 addq.l #7,d1
 dbf d0,rempli_table_x

 lea.l table_x2,a0
 move.w #19,d0
 move.w #0,d1
rempli_table_x2
n set 15
 rept 16
 move.w d1,(a0)+
 move.w #n,(a0)+
n set n-1
 endr
 addq.l #8,d1
 dbf d0,rempli_table_x2
 rts 

offset_x	ds.l 320
offset_x2
offset_y	ds.l 200
offset_y2
table_x		ds.w 320
table_x2	ds.l 320
table_y		ds.w 200
	even

***************************************************************
 SECTION	DATA                                             // *
***************************************************************

Default_palette:
	dc.w	$000,$700,$111,$222,$333,$444,$555,$666
	dc.w	$777,$111,$222,$333,$444,$555,$666,$777

* << Full data here >>

nbre_points	equ 8
nbre_face	equ 6
object		ds.w 2*nbre_points
alpha		dc.w 50*4
beta		dc.w 20*4
adr_clr1	dc.l clr_buf
adr_clr2	dc.l clr_buf2
fin_clr1	dc.l clr_buf2
fin_clr2	dc.l clr_buf3
courbe		ds.w 360*3
cosinus
	incbin cosinus.dat
	even

; objet=cube
ESP equ 20
points:
 dc.w -ESP,-ESP,-ESP
 dc.w ESP,-ESP,-ESP
 dc.w ESP,ESP,-ESP
 dc.w -ESP,ESP,-ESP
 dc.w -ESP,-ESP,ESP
 dc.w ESP,-ESP,ESP
 dc.w ESP,ESP,ESP
 dc.w -ESP,ESP,ESP

face_data
 dc.w 0*4,1*4,2*4,3*4
 dc.w 1*4,5*4,6*4,2*4
 dc.w 4*4,7*4,6*4,5*4 
 dc.w 0*4,3*4,7*4,4*4
 dc.w 0*4,4*4,5*4,1*4
 dc.w 3*4,2*4,6*4,7*4
 
clr_buf	
 rept 1200
 dc.l $78000
 endr
clr_buf2
 rept 1200
 dc.l $78000
 endr
clr_buf3

* <

MUSIC:
	incbin "JEDIFUN.SND"            ; SNDH Music played at the VBL
	even

fond_img:
	incbin	"96x54.pi1"
	even

***************************************************************
 SECTION	BSS                                              // *
***************************************************************

bss_start:

* << Full data here >>


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
