***************************************
* // ELITE_11.PRG                  // *
***************************************
* // Asm Intro Code Atari ST v0.44 // *
* // by Zorro 2/NoExtra (01/12/16) // *
* // http://www.noextra-team.com/  // *
***************************************
* // Original code : Zorro2/NoExtra// *
* // Scoller code  : Xes/Zeal      // *
* // Gfx font      :               // *
* // Music         : TOMCHI        // *
* // Release date  : 27/11/2019    // *
* // Update date   : 02/12/2019    // *
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

**************************** MAIN LOOP ************************>

default_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

 IFEQ	SEEMYVBL
	clr.b $ffff8240.w                ; init line of CPU
 ENDC

* < Put your code here >

	bsr	display_damier

	bsr	scrolla_buffert

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

	bsr	print_text                   ; Print small text
	bsr	init_damier                  ; init false damier effect

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
	MOVE.L    #HBL_DEGRADE_DEPART,$120.W 
	MOVE.B    #1,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W
	MOVE.L    #PALETTE,PTR_PAL
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
HBL_DEGRADE_DEPART:
	CLR.B     $FFFFFA1B.W 
	MOVE.L    #HBL_DEGRADE,$120.W 
	MOVE.B    #4,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W
	RTE 

HBL_DEGRADE:
	MOVEM.L   A0,-(A7)
	MOVEA.L   PTR_PAL,A0
	MOVE.W    (A0)+,$FFFF8242.W 
	MOVE.L    A0,PTR_PAL
	CMPI.W    #PAL_LENGHT,(A0) 
	BNE.S     .next 
	MOVE.B    #0,$FFFA1B.L
.next:
	MOVEM.L   (A7)+,A0
	BCLR      #0,$FFFA0F.L
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
	CLR.B	    $FFFFFA07.W            ; Interrupt enable A (Timer-A & B)
	CLR.B	    $FFFFFA09.W            ; Interrupt enable B (Timer-C & D)
	LEA       $FFFFFA07.W,A0
	ANDI.B    #$DF,2(A0)
	ANDI.B    #$FE,(A0) 
	MOVE.L    #HBL_DEGRADE_DEPART,$120.W 
	ORI.B     #1,(A0) 
	ORI.B     #1,12(A0) 
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
*                   TEXTE FONT 8*8 ONE BITPLANE                     *
*                         ZORRO 2/NOEXTRA                           *
*********************************************************************
CHARS      equ 40  ; chars per line, 80=for med res, 40 for low res *
LINES      equ 33  ; 33 for 8x8 font, 45 with 6x6 font              *
FONTSIZE   equ 8   ; 8=8x8, 6=6x6 font                              *
SHIFTSIZE  equ 4   ; 2=MED RESOLUTION, 4=LOW RESOLUTION             *
*********************************************************************
print_text:     clr.w   x_curs
                clr.l   x_offset
                clr.l   y_offset
                lea     message(pc),a2
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
                move.w  #2,pointeur_plan
                bra.s   new_char
.fin_de_ligne:  cmpi.b  #$ff,d0
                bne.s   process_char
                rts

process_char:   asl.w   #3,d0                ; valeur * 8
                lea     fonts(pc),a1
                sub.w   #256,d0
                adda.w  d0,a1
                
                movea.l physique(pc),a0
                lea     160*190(a0),a0
                adda.w  pointeur_plan(pc),a0
                adda.l  y_offset(pc),a0
                adda.l  x_offset(pc),a0
                
                movea.l physique+4(pc),a3
                lea     160*190(a3),a3
                adda.w  pointeur_plan(pc),a3
                adda.l  y_offset(pc),a3
                adda.l  x_offset(pc),a3

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

_x_conversion:  move.w  x_curs(pc),d0
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

x_curs:
	ds.l 1
y_offset:
	ds.l 1
x_offset:
	ds.l 1
pointeur_plan:
	ds.w 1
	even

***********************
* scrolla i bufferten *
***********************
scrolla_buffert
	moveq.l	#0,d0			; rensa d0 och d1
	move.l	d0,d1
	addq.b	#1,ny_bokstav
	cmp.b	#8,ny_bokstav
	bne	inte_ny_bokstav
	clr.b	ny_bokstav
	lea	text,a0			; h„mta text remsan
	add.l	vart_text,a0		; fram i texten
	addq.l	#1,vart_text
	cmp.b	#$ff,(a0)		; „r texten slut, ba?
	bne.s	inte_slut
	clr.l	vart_text
	bra.s	scrolla_buffert
inte_slut
	cmp.b	#$28,(a0)
	bne.s	.car1
	move.b	#$5b,(a0) * )
.car1:
	cmp.b	#$29,(a0)
	bne.s	.car2
	move.b	#$5d,(a0) * (
.car2:
	cmp.b	#$3a,(a0)
	bne.s	.car3
	move.b	#$5c,(a0) * :
.car3:
	cmp.b	#$2c,(a0)
	bne.s	.car4
	move.b	#$5e,(a0) * ,
.car4:
	cmp.b	#$3b,(a0)
	bne.s	.car5	
	move.b	#$5f,(a0) * ;
.car5:
	cmp.b	#$2e,(a0)
	bne.s	.car6
	move.b	#$60,(a0) * .
.car6:
	cmp.b	#$21,(a0)
	bne.s	.car7
	move.b	#$61,(a0) * !
.car7:
	cmp.b	#$3f,(a0)
	bne.s	.car8
	move.b	#$62,(a0) * ?
.car8:
	cmp.b	#$30,(a0)
	bne.s	.car_0
	move.b	#$63,(a0) * 0
.car_0:
	cmp.b	#$31,(a0)
	bne.s	.car_1
	move.b	#$64,(a0) * 1
.car_1:
	cmp.b	#$32,(a0)
	bne.s	.car_2
	move.b	#$65,(a0) * 2
.car_2:
	cmp.b	#$33,(a0)
	bne.s	.car_3
	move.b	#$66,(a0) * 3
.car_3:
	cmp.b	#$34,(a0)
	bne.s	.car_4
	move.b	#$67,(a0) * 4
.car_4:
	cmp.b	#$35,(a0)
	bne.s	.car_5
	move.b	#$68,(a0) * 5
.car_5:
	cmp.b	#$36,(a0)
	bne.s	.car_6
	move.b	#$69,(a0) * 6
.car_6:
	cmp.b	#$37,(a0)
	bne.s	.car_7
	move.b	#$6a,(a0) * 7
.car_7:
	cmp.b	#$38,(a0)
	bne.s	.car_8
	move.b	#$6b,(a0) * 8
.car_8:
	cmp.b	#$39,(a0)
	bne.s	.car_9
	move.b	#$6c,(a0) * 9
.car_9:
	cmp.b	#$20,(a0)
	bne.s	.esp
	move.b	#$6d,(a0) * ESPACE
.esp:

	move.b	(a0),d0
	sub.b	#65,d0			; subba och mulu:a font tecknet
	lsl	#6,d0
	lea	font,a5			; h„mta font och adda sedan fram
	add.l	d0,a5			; i den... 
	lea	bok_buffer,a0
	moveq.l	#55,d1			; att det blir en etta eller
ny_pix					; en nolla per byte
	tst.b	(a5)+
	bne.s	en_etta
	move.b	#0,(a0)+
	dbf	d1,ny_pix
	bra.s	inte_mera
en_etta
	move.b	#128,(a0)+
	dbf	d1,ny_pix
inte_mera
	addq.l	#8,a5
inte_ny_bokstav
	lea	buffer,a0
	lea	bok_buffer,a1
	moveq.l	#6,d0		
scrolla
	move.b	#0,(a0)			; shifta bytesen (scrollur)
	move.b	2(a0),1(a0)
	move.b	3(a0),2(a0)
	move.b	4(a0),3(a0)
	move.b	5(a0),4(a0)
	move.b	6(a0),5(a0)
	move.b	7(a0),6(a0)
	move.b	8(a0),7(a0)
	move.b	9(a0),8(a0)
	move.b	10(a0),9(a0)
	move.b	11(a0),10(a0)
	move.b	12(a0),11(a0)
	move.b	13(a0),12(a0)
	move.b	14(a0),13(a0)
	move.b	15(a0),14(a0)
	move.b	16(a0),15(a0)
	move.b	17(a0),16(a0)
	move.b	18(a0),17(a0)
	move.b	19(a0),18(a0)
	move.b	20(a0),19(a0)
	move.b	21(a0),20(a0)
	move.b	22(a0),21(a0)
	move.b	23(a0),22(a0)
	move.b	24(a0),23(a0)
	move.b	25(a0),24(a0)
	move.b	26(a0),25(a0)
	move.b	27(a0),26(a0)
	move.b	28(a0),27(a0)
	move.b	29(a0),28(a0)
	move.b	30(a0),29(a0)
	move.b	31(a0),30(a0)
	move.b	32(a0),31(a0)
	move.b	33(a0),32(a0)
	move.b	34(a0),33(a0)
	move.b	35(a0),34(a0)
	move.b	36(a0),35(a0)
	move.b	37(a0),36(a0)
	move.b	38(a0),37(a0)
	move.b	39(a0),38(a0)
	move.b	(a1),39(a0)		; scrolla bokstavsbufferten
	move.b	1(a1),(a1)		; ocks†
	move.b	2(a1),1(a1)
	move.b	3(a1),2(a1)
	move.b	4(a1),3(a1)
	move.b	5(a1),4(a1)
	move.b	6(a1),5(a1)
	move.b	7(a1),6(a1)
	move.b	8(a1),7(a1)
	add.l	#40,a0			; hoppa ned en rad i bufferten
	addq.l	#8,a1			; hoppa ned en rad i bokstavs bufferten
	dbf	d0,scrolla

	moveq.l	#0,d0
	moveq.l	#0,d1
	moveq.l	#0,d5
	moveq.l	#0,d6

	lea	sinus,a2
	move.l	#139,d7
ut_put
	move.w	(a2)+,d1		; yposition till d1

	add.l	#24*160,d1

	move.l	physique(pc),a5
	lea	-160*28(a5),a5
	addq.w	#6,a5
	move.l	a5,a0
	add.w	d1,a0			; fixa y-positionen
	add.l	d5,a0			; adda till x-positionen
	lea	buffer,a1		; fixa bufferten
	add.l	d6,a1
	addq.l	#1,d6
	move.b	(a1)+,d0
	and.b	#255-128,(a0)
	or.b	d0,(a0)			; ut med f”rsta
	move.w	(a2)+,d1

	add.l	#24*160,d1

	move.l	a5,a0			; fixa den nya ypositionen
	add.w	d1,a0			; f”r den andre pixeln
	add.l	d5,a0
	move.b	(a1)+,d0		; och sen det andra
	lsr	#4,d0
	and.b	#255-8,(a0)
	or.b	d0,(a0)
	move.w	(a2)+,d1

	add.l	#24*160,d1

	move.l	a5,a0
	add.w	d1,a0			; fixa y-positionen
	add.l	d5,a0			; adda till x-positionen
	addq.l	#1,a0
	lea	buffer,a1		; fixa bufferten
	add.l	d6,a1
	addq.l	#1,d6
	move.b	(a1)+,d0
	and.b	#255-128,(a0)					
	or.b	d0,(a0)			; ut med f”rsta
	move.w	(a2)+,d1

	add.l	#24*160,d1

	move.l	a5,a0		; fixa den nya ypositionen
	add.w	d1,a0			; f”r den andre pixeln
	add.l	d5,a0			
	addq.l	#1,a0
	move.b	(a1)+,d0		; och sen det andra
	lsr	#4,d0
	and.b	#255-8,(a0)					
	or.b	d0,(a0)
	addq.l	#8,d5			; adda p† x
	dbf	d7,ut_put	
	rts

*********************************************************************
*                  DISPLAY ANIMATION ONE BITPLANE                   *
*                         ZORRO 2/NOEXTRA                           *
*********************************************************************
init_damier:
; Decompact datas
	lea	DAMIER_DATA,a0	;	datas vagues compressed
	lea	Buffer_L7Z,a1	  ;	buffer destination
	jsr	d_lz77	        ; decompress data in a0 -> a1
  rts

display_damier:
; 320*82 one bitplane
	move.l	PTR_DAMIER,a2
	cmp.l	#-1,(a2)
	bne.s	.continue
	move.l	#DAMIER,PTR_DAMIER
	move.l	PTR_DAMIER,a2
.continue:
	move.l	(a2)+,a0
	move.l	a2,PTR_DAMIER
	movea.l	physique,a1
	lea	160*5(a1),a1
	move.w	#0,d0
	move.w	#0,d1
	move.w	#320,d2
	move.w	#82,d3
	move.w	#1,d4
	bsr	DoBLiTTER__Copy_Buffer
; Mirroring
	movea.l	physique(pc),a0
	lea	160*86(a0),a0
	movea.l	physique(pc),a1
	lea	160*118(a1),a1
	move	#82,d1                     ; number of lines
.loop;
i	set	0
	rept	20                         ; repeat chunks (1 chunk=16 pixels)
	move.w	i(a0),i(a1)              ; copy 1st half of a chunk (logical)
i	set	i+8                          ; next chunk
	endr                             ; end of copying chunks
	sub.l	#160,a0                    ; next scanline line for logical
	add.l	#160,a1                    ; next scanline line for piccy
	dbf	d1,.loop                     ; end of copying lines
	rts

DoBLiTTER__Copy_Buffer:
  move.l	a6,-(sp)	;preserve registers
  lea	bitblt(pc),a6		;address of blit table
  move.l	a0,18(a6)		;store 'from' address
  move.l	a1,32(a6)		;store 'to' address
  move.w	#0,14(a6)		;store left from position
  move.w	#0,16(a6)		;store top from position
  move.w	d0,28(a6)		;store left to position
  move.w	d1,30(a6)		;store top to position
  move.w	d2,0(a6)	  ;store width. 
  move.w	d3,2(a6)	  ;store height.
  move.w	d4,4(a6)		;set up number of plan
  move.w	#8,22(a6)		;for low resolution
  move.w	#8,36(a6)
  move.l	#0,42(a6)		;set up blit variables 
  move.b	#3,10(a6)		;for any resolution
  move.w	#0,6(a6)
  move.w	#0,8(a6)
  dc.w	$a007			    ;do the blit!
  move.l	(sp)+,a6	  ;restore registers
  rts				          ;and return.
  
*****************************
* Data for the Blit Routine *
*****************************
bitblt:
  DC.W	0	;Width
  DC.W	0	;Height
  DC.W	0	;No. Planes
  DC.W	0	;fg_col
  DC.W	0	;bg_col
  DC.B	0,0,0,0	;log. ops
  DC.W	0	;left source x
  DC.W	0	;top source y
  DC.L	0	;Source screen top address
  DC.W	8	;word in line (8=low 4=med)
  DC.W	160	;160 for med/low
  DC.W	2
  DC.W	0	;left dest x
  DC.W	0	;top dest y
  DC.L	0	;dest screen top address
  DC.W	8	;word in line
  DC.W	160	;line in plane
  DC.W	2
  DC.L	0	;Pattern Address
  DC.W	0
  DC.W	0
  DC.W	0
  DC.W	0
	EVEN

******************************************
*                                        *
* Very! fast lz77 decompression routine  *
* 68000 version                          *
*                                        *
******************************************
 include "LZ77_130.ASM"
 even

***************************************************************
 SECTION	DATA                                             // *
***************************************************************

Default_palette:
	dc.w	$0,$0,$557,$557,$0,$0,$0,$0
	dc.w	$777,$777,$0,$0,$0,$0,$0,$0

* << Full data here >>
message:
* !",$22,"#$%&",$27,"()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz
	dc.b	$fc ; en 1er plan
	dc.b	"                                  ELITE!",$ff
	even
fonts:
	incbin 	"FONT88C.DAT"
	even
*
font:
	incbin	"FONT88Z.DAT"
	even
sinus:
	include	"SINUS_P1.SIN"
	even
text:
; 0123456789 (),;.:!? ABCDEFGHIJKLMNOPQRSTUVWXYZ
	dc.b	"               "
	dc.b	"ALL ASM SOURCES ARE AVAILABLE IN OUR GITHUB.COM WEBSITE AT NOEXTRA-TEAM SOURCES. "
	dc.b	"             ENJOY !             "
	dc.b	-1
	even
*
PTR_DAMIER:
	dc.l	DAMIER
DAMIER: ; Séquence de l'animation
 rept 5
	dc.l	D01,D02,D03,D04,D05,D06,D07,D08,D09,D10,D11,D12,D01,D02,D03,D04,D05,D06,D07,D08,D09,D10,D11,D12
	dc.l	D01,D02,D03,D04,D05,D06,D07,D08,D09,D10,D11,D12,D01,D02,D03,D04,D05,D06,D07,D08,D09,D10,D11,D12
 endr
	dc.l	D01,D02,D02,D03,D03,D04,D04,D05,D05,D06,D06,D07,D07,D08,D08,D09,D09,D10,D11,D12
	dc.l	D01,D02,D02,D03,D03,D04,D04,D05,D05,D06,D06,D07,D07,D08,D08,D09,D09,D10,D11,D12
 rept 5
	dc.l	D12,D11,D10,D09,D08,D07,D06,D05,D04,D03,D02,D01,D12,D11,D10,D09,D08,D07,D06,D05,D04,D03,D02,D01
	dc.l	D12,D11,D10,D09,D08,D07,D06,D05,D04,D03,D02,D01,D12,D11,D10,D09,D08,D07,D06,D05,D04,D03,D02,D01
	dc.l	D12,D11,D10,D09,D08,D07,D06,D05,D04,D03,D02,D01,D12,D11,D10,D09,D08,D07,D06,D05,D04,D03,D02,D01
 endr
	dc.l	D01,D01,D01,D01,D01
	dc.l	-1
DAMIER_DATA:
	incbin "DAMIER.L7Z"	;	320 x 82 x 12
	even
*
PTR_PAL:
	dc.l	PALETTE
PALETTE:
i set $0700           ; Red color
 rept 10-2
	dcb.w	3,i
i set i-$0100
 endr
	dcb.w	5,$0000
i set $0100
 rept 10-2
	dcb.w	3,i
i set i+$0100
 endr
PAL_LENGHT equ	*-PALETTE
	even
* <

MUSIC:
	incbin "TVOU.THK"            ; SNDH Music played at the VBL
	even

***************************************************************
 SECTION	BSS                                              // *
***************************************************************

bss_start:

* << Full data here >>
vart_text:
	ds.l	1
buffer:
	ds.b	320
bok_buffer:
	ds.b	64
ny_bokstav:
	ds.b	1
	even
*
Buffer_L7Z:
	ds.b	160*82*12	;	157440
; Découpage des 12 images de l'animation du damier
D01	equ Buffer_L7Z+160*82*0
D02	equ Buffer_L7Z+160*82*1
D03	equ Buffer_L7Z+160*82*2
D04	equ Buffer_L7Z+160*82*3
D05	equ Buffer_L7Z+160*82*4
D06	equ Buffer_L7Z+160*82*5
D07	equ Buffer_L7Z+160*82*6
D08	equ Buffer_L7Z+160*82*7
D09	equ Buffer_L7Z+160*82*8
D10	equ Buffer_L7Z+160*82*9
D11	equ Buffer_L7Z+160*82*10
D12	equ Buffer_L7Z+160*82*11
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
