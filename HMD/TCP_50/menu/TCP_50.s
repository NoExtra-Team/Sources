***************************************
* // TCP_50.PRG                    // *
***************************************
* // Asm Intro Code Atari ST v0.47 // *
* // by Zorro 2/NoExtra (23/11/23) // *
***************************************
* // Original code : ANGEL/HMD     // *
* // Add. code     : KELLY.X/HMD   // *
* // Add. code     : ATOMUS/NOEX   // *
* // Gfx logo      : MISTER.A/NOEX // *
* // Gfx font      : unknow        // *
* // Music         : YQN/HMD       // *
* // Text          : STC/HMD       // *
* // Text          : SINK/HMD      // *
* // Text          : STRANGER/HMD  // *
* // Text          : ANGEL/HMD     // *
* // Release date  : 26/11/2025    // *
* // Update date   : 23/12/2025    // *
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
NB_OF_SCREEN     equ ONE_SCREEN  ; Number of Screen used             *
*************************** PARAMETERS *******************************
SEEMYVBL         equ 1           ; See CPU used if you press ALT key *
ERROR_SYS        equ 1           ; Manage exit system errors         *
FADE_INTRO       equ 1           ; Fade White to black palette       *
TEST_STE         equ 1           ; Code only for Atari STE machine   *
STF_INITS        equ 0           ; STF compatibility MODE            *
BLITTER          equ 1           ; Sync effect with Blitter          *
CLEAN_TIMERS     equ 1           ; Clean Timers for...               *
**********************************************************************
*              Notes : 0 = I use it / 1 = no need !                  *
**********************************************************************

Begin:
	clr.l   -(sp)                    ; Supervisor mode set
	move.w  #32,-(sp)                ;
	trap    #1                       ;
	addq.l  #6,sp                    ;
	move.l  d0,Save_stack            ; Save adress of stack

 IFEQ TEST_STE
	move #37,-(sp)                   ; Wait the beginning of the next VBL
	trap #14
	addq.l #2,sp
	lea $ffff8209.w,a0               ; Lower byte of the video counter
	moveq #74,d0                     ; Randomized value
	move.b d0,(a0)                   ; Write it
	cmp.b (a0),d0                    ; Equality test ?
	bne.w EXIT_PRG                   ; Failed ? => it's a STFM hardware!
 ENDC

	bsr	clear_bss                    ; Clean BSS stack
	
	bsr	Save_and_init_st             ; Save system parameters

	bsr	Init_screens                 ; Screen initialisations

 IFEQ STF_INITS
	jsr	Multi_boot                   ; Multi Atari Boot code from LEONARD/OXG
 ENDC

 IFEQ BLITTER
SyncBlitterToRestart macro         ; Macro must be used with blitter effect outside the VBL for synchronisations
	bset	#7,$ffff8a3c.w             ; Fast Blitter Restart
	nop
	bne.s	*-4
	endm
.Clear_Blitter_instructions:
	lea.l $ffff8a00.w,a1             ; 32 bytes halftone ram to clear !
	rept 8
	clr.l (a1)+
	endr
.Launch_Blitter:
	move.w	#$80,$ffff8a3c.w         ; Launch the Blitter !
	nop
.restart:
	bset	#7,$ffff8a3c.w
	nop
	bne.s	.restart
 ENDC

	bsr	Inits                        ; Other Initialisations

**************************** MAIN LOOP ************************>

default_loop:
 IFEQ CLEAN_TIMERS
	move.w	#$2300,SR
 ENDC

	bsr	Wait_vbl                     ; Waiting after the VBL

 IFEQ	SEEMYVBL
	move.l Logo_palette,$ffff8240.w ; init line of CPU
 ENDC

* < Put your code here >

	jsr	SinusWave
	jsr	Scrolling
	jsr	Scrolling

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

 IFEQ CLEAN_TIMERS
	move.w	#$2700,SR
 ENDC

 IFEQ	SEEMYVBL
	cmp.b #$38,$fffffc02.w           ; ALT key pressed ?
	bne.s .next_key                  ;
	move.b	#7,$ffff8240.w           ; See the rest of CPU (pink color used)
.next_key:                         ;
 ENDC

	cmp.b	#$1,$fffffc02.w		* ESC KEY ?
	beq.s	EscapeKey

	cmp.b #$39,$fffffc02.w           ; SPACE key pressed ?
	bne	default_loop

	add.l	#2,$40.w
	bra.s	ESCAPE_PRG

EscapeKey:
	move.l	#1,$40.w

**************************** MAIN LOOP ************************<

ESCAPE_PRG:

	lea	Pal_Nul(pc),a0               ; Put palette
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d7               ;
	movem.l	d0-d7,(a1)               ;

	move.l	physique(pc),d0        ; Put physical Screen
	move.b	d0,d1                    ;
	lsr.w #8,d0                      ;
	move.b	d0,$ffff8203.w           ;
	swap d0                          ;
	move.b	d0,$ffff8201.w           ;
	move.b	d1,$ffff820d.w           ;

	move.l	physique(pc),a0          ; Fill PATTERN in Screen #1
	move.w  #(SIZE_OF_SCREEN)/4-1,d7 ;
	move.l  #PATTERN,(a0)+           ;
	dbf	    d7,*-6                   ;

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

	lea	Pal_Nul(pc),a0               ; Put palette
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d7               ;
	movem.l	d0-d7,(a1)               ;

 	move.l	#Logo_img,a0             ; source
	movea.l	physique(pc),a1          ; destination
	jsr	lz4_depack                   ; Depack to Screen!

	move.w	#50,d7
.fill:	
	jsr	SinusWave
	dbra	d7,.fill

	jsr	print_text                   ; Print texts

	jsr	FadeTOwhite                  ; Special fade to white palette colors

	lea	start_vbl(pc),a0             ; Launch VBL
	move.l	a0,$70.w                 ;

	bsr	Wait_vbl

	CLR.W   POSITION_BARRE           ; initialise barre de navigation
	MOVE.B  #10+4,HBL_POS_1            ; debut de la barre
	MOVE.B  #131-80+40-3,HBL_POS_2   ; fin de la barre
	MOVE.W	#0,BAR_TEMPO             ; temporisation a chaque deplacement de la barre  
	CLR.L   $40.W

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
SIZE_OF_SCREEN equ 160*300         ; Size of Screen + Top & Lower Border Size

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
	move.l	physique(pc),d0        ; Put physical Screen
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
start_vbl:
	clr.b   $fffffa1b.w          ; Timer B off
	st      Vsync
	rte

Vbl:
	clr.b   $fffffa1b.w              ; Timer B off

 IFEQ BLITTER
.sync_Blitter:                     ; Sync Blitter with effect
	bclr.b	#7,$ffff8a3c.w
	nop
	btst.b	#7,$ffff8a3c.w
	bne.s	.sync_Blitter
 ENDC

	st	Vsync

	MOVE.L    #TIMER_B,$120.W 
	MOVE.B    #$63,$FFFFFA1F.W
	MOVE.B    #4,$FFFFFA19.W
	MOVE.B    #35+80-46,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W

	jsr (MUSIC+8)                    ; Play SNDH music

	bsr	KEYPAD                       ; mvt de la barre 
	bsr	MVT_BARRE 

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

***************************************************************
*          < Here is the top and lower border rout >          *
***************************************************************
palette_fond equ $ffff8240
couleur_fond equ $0fff
couleur_barre equ $0675

TIMER_A:        MOVE      #$2100,SR 
                STOP      #$2100
                MOVE      #$2700,SR 
                CLR.B     $FFFFFA19.W 
                MOVEM.L   A0-A1/D0-D7,-(A7) 
                dcb.w     60,$4e71
                MOVE.B    #0,$FFFF820A.W
                dcb.w     7,$4e71
                CLR.W     D1
                MOVEA.W   #$8209,A0 
                MOVE.B    #2,$FFFF820A.W
                MOVEM.L   (A7)+,A0-A1/D0-D7 
RTE:            RTE 

*

TIMER_B:        CLR.B     $FFFFFA1B.W
                ;MOVE.W    #couleur_fond,palette_fond.W
                MOVE.L    #HBL0,$120.W 
                MOVE.B    #1,$FFFFFA21.W 
                MOVE.B    #8,$FFFFFA1B.W

                move.l	a0,-(a7)
                move.l	a1,-(a7)
                LEA   Pal_Rasters,A0 
                MOVEA.L   #$FF8240,A1 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                move.l	(a7)+,a1
                move.l	(a7)+,a0

                RTE 

HBL0:           CLR.B     $FFFFFA1B.W
                MOVE.L    #HBL,$120.W 
                MOVE.B    #46-1,$FFFFFA21.W 
                MOVE.B    #8,$FFFFFA1B.W
                RTE 

HBL:            CLR.B     $FFFFFA1B.W
                MOVE.L    #HBL1,$120.W 
                MOVE.B    HBL_POS_1,$FFFFFA21.W
                MOVE.B    #8,$FFFFFA1B.W
                RTE 

HBL1:           CLR.B     $FFFFFA1B.W
                MOVE.w    #couleur_barre,palette_fond.w

                move.l	a0,-(a7)
                move.l	a1,-(a7)
                LEA   Fond_color,A0 
                MOVEA.L   #$FF8250,A1 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                move.l	(a7)+,a1
                move.l	(a7)+,a0

                MOVE.L    #HBL2,$120.W 
                MOVE.B    #10,$FFFFFA21.W 
                MOVE.B    #8,$FFFFFA1B.W
                RTE 

HBL2:           CLR.B     $FFFFFA1B.W
                MOVE.W    #couleur_fond,palette_fond.W

                move.l	a0,-(a7)
                move.l	a1,-(a7)
                LEA   Pal_Rasters,A0 
                MOVEA.L   #$FF8240,A1 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                move.l	(a7)+,a1
                move.l	(a7)+,a0

                MOVE.L    #HBL_blanc,$120.W 
                MOVE.B    HBL_POS_2,$FFFFFA21.W
                MOVE.B    #8,$FFFFFA1B.W     
                RTE 

HBL_blanc:      CLR.B     $FFFFFA1B.W
                MOVE.L    #BORDER_END,$120.W 
                MOVE.B    #1,$FFFFFA21.W 
                MOVE.B    #8,$FFFFFA1B.W
                RTE 
      
BORDER_END:     CLR.B     $FFFFFA1B.W 

                move.l	a0,-(a7)
                move.l	a1,-(a7)
                LEA   Logo_palette,A0 
                MOVEA.L   #$FF8240,A1 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                move.l	(a7)+,a1
                move.l	(a7)+,a0

                MOVEM.L   A0/D0,-(A7) 
                MOVEA.W   #$FA21,A0 
                MOVE.B    #$28,(A0) 
                MOVE.L    #hblfin,$120.W 
                MOVE.B    #8,$FFFFFA1B.W
                MOVE.B    (A0),D0 
.wait:          CMP.B     (A0),D0 
                BEQ       .wait 
                CLR.B     $FFFF820A.W 
                MOVEQ     #2,D0 
.att:           NOP 
                DBF       D0,.att
                MOVE.B    #2,$FFFF820A.W
                MOVEM.L   (A7)+,A0/D0 

                BCLR      #0,$FFFFFA0F.W
                RTE 

hblfin:         BCLR      #0,$FFFFFA0F.W
                RTE

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

 IFEQ CLEAN_TIMERS
* Available interrupt commands for music if needed...
	clr.b $fffffa07.w                ; Interrupt enable A (Timer-A & B)
	clr.b $fffffa09.w                ; Interrupt enable B (Timer-C & D)
	clr.b $fffffa13.w                ; Interrupt mask A (Timer-A & B)
	clr.b $fffffa15.w                ; Interrupt mask B (Timer-C & D)
	clr.b $fffffa19.w                ; Stop Timer A
	clr.b $fffffa1b.w                ; Stop Timer B
	clr.b $fffffa21.w                ; Timer B data at zero
	clr.b $fffffa1d.w                ; Stop Timer C & D
 ENDC

	bclr	#3,$fffffa17.w             ; Stop Timer C
	MOVE.B	#$21,$FFFFFA07.W
	MOVE.B	#$21,$FFFFFA13.W
	CLR.B		$FFFFFA09.W 
	CLR.B		$FFFFFA15.W 
	CLR.B		$FFFFFA19.W 
	CLR.B		$FFFFFA1B.W 
	MOVE.L	#RTE,$68.W
	MOVE.L	#TIMER_A,$134.W 
	MOVE.L	#TIMER_B,$120.W 

 IFEQ BLITTER
	move	$ffff8264.w,Old_Shift+2    ; Save Screen Shifting
	move	$ffff820e.w,Old_Modulo+2   ; Save Screen Modulo
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

 IFEQ BLITTER
Old_Modulo:
	move	#0,$ffff820e.w             ; Restore Screen Modulo
Old_Shift:
	move	#0,$ffff8264.w             ; Restore Old Shift
 ENDC

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

 include	"BAR-MENU.ASM"
 include	"FADEWHIT.ASM"
 include	"PRINT.ASM"
 include	"SCROLL2.ASM"
 include	"SINUSW.ASM"
 include "D:\0_EXTRA_\TCP_50\samples\LZ4_183.ASM"  ; Decompress file

***************************************************************
 SECTION	DATA                                             // *
***************************************************************

* << Full data here >>

Fond_color:
	dcb.w	8,$0334
Logo_img:	even
	incbin	"LOGO.LZ4"
Logo_palette:
	dc.w	$0FFF,$0EE7,$066E,$055D,$0CC5,$044C,$0BB4,$033B
	dc.w	$022A,$0119,$0FFF,$0FFF,$0FFF,$0FFF,$0FFF,$0FFF
Pal_Rasters:
	dc.w	$0FFF,$0EEF,$0EFE,$06E6,$0F7E,$0FFE,$0FEE,$0F6F
	dc.w	$0CC5,$0CC5,$0CC5,$0CC5,$0CC5,$0CC5,$0CC5,$0CC5
Pal_Nul:
	dcb.w	16,$0099
* <

MUSIC:
	incbin "SQURMENZ.SND"	           ; SNDH Music played at the VBL
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
