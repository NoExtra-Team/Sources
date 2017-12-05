***************************************
* // EXTRA_V4.PRG                  // *
***************************************
* // Asm Intro Code Atari ST v0.42 // *
* // by Zorro 2/NoExtra (05/12/11) // *
* // http://www.noextra-team.com/  // *
***************************************
* // Original code : Zorro 2       // *
* // Gfx logo      : Mister.A      // *
* // Gfx font      : Mister.A      // *
* // Music         : TOMCHI        // *
* // Release date  : 11/12/2012    // *
* // Update date   : 11/03/2013    // *
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
FADE_INTRO       equ 1         ; Fade White to black palette       *
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
	ENDC

* < Put your code here >
	Bsr	Circle_effect                ; Les 2 cercles
	bsr	SCROLLH                      ; Petit Scrolling
	BSR	DIGITS                       ; Petits Digits
	BSR	KEYPAD                       ; Mvt de la barre 
	BSR	MVT_BARRE                    ;

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

	cmp.b	#$1,$fffffc02.w		* ESC KEY ?
	beq.s	EscapeKey

	cmp.b	#$39,$fffffc02.w	* SPACE KEY ?
	bne.s	default_loop

	add.l    #2,$40.w
	bra.s	SORTIE

EscapeKey:
	move.l   #1,$40.w

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

	moveq	#1,d0                      ; Choice of the music (1 is default)
	jsr	MUSIC+0                      ; Init SNDH music

	lea	Vbl_Start(pc),a0             ; Launch VBL
	move.l	a0,$70.w                 ;

	bsr	fadeoff                      ; Noirceur

	BSR	INIT_CIRCLE                  ; Init Circle
	BSR	PRETEXT                      ; Inits Scrolling
	BSR	PRESHIFT                     ;

	lea	physique(pc),a6              ; Put Logo
	move.l	(a6)+,a0
	move.l	(a6)+,a1
	movea.l	#LOGO_EXTRA_Img,a4
	move.l	#160*70/4-1,d0
	move.l	(a4),(a0)+
	move.l	(a4)+,(a1)+
	dbf	d0,*-4

	bsr	print_text                   ; Affiche les Textes
	BSR	PUT_TEXT                     ;
	
	CLR.W   POSITION_BARRE           ; initialise barre de navigation
	MOVE.B  #5,HBL_POS_1             ; debut de la barre
	MOVE.B  #11*10+11*3-4,HBL_POS_2  ; fin de la barre
	MOVE.W	#0,BAR_TEMPO             ; temporisation a chaque deplacement de la barre  
	CLR.L   $40.W

	lea	Vbl(pc),a0                   ; Launch VBL
	move.l	a0,$70.w                 ;

	bsr	Wait_vbl                     ; Synchro

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

Init_screens:	movem.l	d0-d7/a0-a6,-(a7)

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
Vbl_Start:
	IFEQ	TOPBOTTOM_BORDER
	CLR.B   $FFFFFA1B.W              ; Timer B off
	ENDC

	st	Vsync

	jsr	(MUSIC+8)                    ; Call music

	rte

Vbl:
	IFEQ	TOPBOTTOM_BORDER
	CLR.B   $FFFFFA1B.W              ; Timer B off
	ENDC

	MOVE.L    A0,-(A7)               ; Extra Palette
	MOVE.L    A1,-(A7)
	LEA       LOGO_EXTRA_Palette,A0 
	MOVEA.L   #$FF8240,A1 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A7)+,A1
	MOVE.L    (A7)+,A0

	st	Vsync

	IFEQ	TOPBOTTOM_BORDER
	MOVE.L    #HBL_blanc,$120.W      ; Go Timer B !
	MOVE.B    #$63,$FFFFFA1F.W
	MOVE.B    #4,$FFFFFA19.W
	MOVE.B    #71,$FFFFFA21.W        ; First position
	MOVE.B    #8,$FFFFFA1B.W
	ENDC

	jsr	(MUSIC+8)                    ; Call music

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
TIMER_A:        MOVE      #$2100,SR 
                STOP      #$2100
                MOVE      #$2700,SR 
                CLR.B     $FFFFFA19.W 
                MOVEM.L   A0-A1/D0-D7,-(A7) 
                DCB.W     60,$4E71
                MOVE.B    #0,$FFFF820A.W
                DCB.W     7,$4E71
                CLR.W     D1
                MOVEA.W   #$8209,A0 
                MOVE.B    #2,$FFFF820A.W
                MOVEM.L   (A7)+,A0-A1/D0-D7 
RTE:            RTE 

HBL_blanc:      CLR.B     $FFFFFA1B.W
                MOVE.B    #$ff,$ffff8240.w
                MOVE.L    #HBL_noir,$120.W 
                MOVE.B    #1,$FFFFFA21.W 
                MOVE.B    #8,$FFFFFA1B.W
                RTE 
      
HBL_noir:       CLR.B     $FFFFFA1B.W
                MOVE.w    #$012,$ffff8240.w
                MOVE.L    #HBL,$120.W 
                MOVE.B    #1,$FFFFFA21.W 
                MOVE.B    #8,$FFFFFA1B.W

                MOVE.L    A0,-(A7)
                MOVE.L    A1,-(A7)
                LEA       Default_palette,A0 
                MOVEA.L   #$FF8240,A1 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A7)+,A1
                MOVE.L    (A7)+,A0
                RTE 

HBL:            CLR.B     $FFFFFA1B.W
                MOVE.L    #HBL1,$120.W 
                MOVE.B    HBL_POS_1,$FFFFFA21.W
                MOVE.B    #8,$FFFFFA1B.W
                RTE 

HBL1:           CLR.B     $FFFFFA1B.W
                MOVE.W    #$037,$ffff8240.w
                MOVE.L    #HBL2,$120.W 
                MOVE.B    #11,$FFFFFA21.W 
                MOVE.B    #8,$FFFFFA1B.W
                RTE 
      
HBL2:           CLR.B     $FFFFFA1B.W
                MOVE.W    #$012,$ffff8240.w
                MOVE.L    #BORDER_BAS,$120.W 
                MOVE.B    HBL_POS_2,$FFFFFA21.W
                MOVE.B    #8,$FFFFFA1B.W     
                RTE 

SCROLL_COLOR equ $aee0aee/2
BORDER_BAS:     SF	$FFFFFA21.W    ; Stop Timer B
                SF	$FFFFFA1B.W    ;
                DCB.W	95,$4E71     ; 95 nops	Wait line end
                SF	$FFFF820A.W    ; Modif Frequency 60 Hz !
                DCB.W	28,$4E71     ; 28 nops	Wait line end
                MOVE.B	#$2,$FFFF820A.W	; 50 Hz !

                MOVE.L	#SCROLL_COLOR,$FFFF8250.W	; 5ème plan...
                MOVE.L	#SCROLL_COLOR,$FFFF8252.W
                MOVE.L	#SCROLL_COLOR,$FFFF8254.W
                RTE

FOND_TEXTE equ $777
Default_palette:
	dc.w	$012,$046,$024,$035,$0aff/2,$0aee/2,$0add/2,$0acc/2
	dc.w	FOND_TEXTE,FOND_TEXTE,FOND_TEXTE,FOND_TEXTE,FOND_TEXTE,FOND_TEXTE,FOND_TEXTE,FOND_TEXTE
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

	move	#4,-(sp)                   ; Save & Change Resolution (GetRez)
	trap	#14	                       ; Get Current Res.
	addq.l	#2,sp                    ;
	move	d0,Old_Resol+2             ; Save it

	move	#3,-(sp)                   ; Save Screen Address (Logical)
	trap	#14
	addq.l	#2,sp
	move.l	d0,Old_Screen+2

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

	IFEQ	NO_BORDER
	clr.b	$fffffa07.w                ; Interrupt enable A (Timer-A & B)
	clr.b	$fffffa09.w                ; Interrupt enable B (Timer-C & D)
	ENDC

	IFEQ	TOPBOTTOM_BORDER
	MOVE.B    #$21,$FFFFFA07.W
	MOVE.B    #$21,$FFFFFA13.W
	CLR.B     $FFFFFA09.W 
	CLR.B     $FFFFFA15.W 
	CLR.B     $FFFFFA19.W 
	CLR.B     $FFFFFA1B.W 
	MOVE.L    #RTE,$68.W
	MOVE.L    #TIMER_A,$134.W 
	MOVE.L    #HBL_blanc,$120.W 
	ENDC

	clr.b	$484.w                     ; No bip, no repeat

	stop	#$2300

	moveq #$11,d0                    ; Resume keyboard
	bsr	sendToKeyboard               ;

	moveq #$12,d0                    ; Kill mouse
	bsr	sendToKeyboard               ;

	bsr	flush                        ; Init keyboard

	sf	$ffff8260.w                  ; Basse resolution if you don't use Multi_boot

	bsr	black_out

	rts

Restore_st:

	bsr	black_out

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
	bsr	black_out
	rts

wart:	move.l	d0,-(sp)
	move.l	$466.w,d0
.att:	cmp.l	$466.w,d0
	beq.s	.att
	move.l	(sp)+,d0
	rts
	ENDC

black_out:
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

***************************************************************
; SUB-ROUTINES                                             // *
***************************************************************

***************************************************************
*          Fades all colours to black (ST FM only)            *
* ENTRY Colour palette holds current colours                  *
* EXIT  Colour palette set to all black                       *
***************************************************************
fadeoff:
	move.w	#8-1,d0	Maximum of 8 stages
.loop1 	move.w	#16-1,d1	16 colours!
	move.l	#$ffff8240,a0	offset of palette
.loop2	move.w	(a0),d2
	andi.w	#$777,d2	Eliminate garbage
	move.w	d2,d3
	andi.w	#$F,d2	d2 contains B value
	lsr.w	#4,d3
	move.w	d3,d4
	andi.w	#$F,d3	d3 contains G value
	lsr.w	#4,d4
	andi.w	#$F,d4	d4 contains R value
	tst.w	d2
	beq.s	.end1	B already zero
	subq.w	#1,d2
.end1	tst.w	d3
	beq.s	.end2	G already zero
	subq.w	#1,d3
.end2	tst.w	d4
	beq.s	.end3	R already zero
	subq.w	#1,d4
.end3	lsl.w	#8,d4
	lsl.w	#4,d3
	or.w	d4,d2
	or.w	d3,d2	D2 now contains RGB value
	move.w	d2,(a0)+
	dbra	d1,.loop2	Next colour
 rept 2
  bsr     Wait_vbl
 endr
	dbra	d0,.loop1	Next stage
	rts

***************************************************************
*                                                             *
*          CIRCLE ONE PLANE BY ATOMUS/NOEXTRA-TEAM            *
*                                                             *
***************************************************************
INIT_CIRCLE:
*> On recopie le motif du cercle dans le buffer
      LEA       MOTIF_CIRCLE(PC),A0
      MOVEA.L   #Buffer_Cercle_part1,A1
      MOVE.W    #18368/4-1,D7
      MOVE.L    (A0)+,(A1)+ 
      DBF       D7,*-2
*> On positionne le cercle dans les buffers
      MOVEA.L   #Buffer_Cercle_part1,A0
      MOVEA.L   #Buffer_Cercle_part2,A1
      LEA       END_DATA_CIRCLE(PC),A3
      MOVE.L    A0,-(A3)
      MOVEQ     #6,D7              ; On positionne 7 fois
.ligne:MOVE.L    A1,-(A3)
      MOVE.W    #320+7,D6 
.bloc:MOVE.L    (A0)+,(A1)+ 
      MOVE.L    (A0)+,(A1)+ 
      MOVE.L    (A0)+,(A1)+ 
      MOVE.L    (A0)+,(A1)+ 
      MOVE.L    (A0)+,(A1)+ 
      MOVE.L    (A0)+,(A1)+ 
      MOVE.L    (A0)+,(A1)+ 
      MOVE.L    (A0)+,(A1)+ 
      MOVE.L    (A0)+,(A1)+ 
      MOVE.L    (A0)+,(A1)+ 
      MOVE.L    (A0)+,(A1)+ 
      MOVE.L    (A0)+,(A1)+ 
      MOVE.L    (A0)+,(A1)+ 
      MOVE.L    (A0)+,(A1)+ 
      LEA       -56(A1),A1
      DCB.W     28,$E4D9           ; ROXR      (A1)+
      LEA       -56(A1),A1
      DCB.W     28,$E4D9           ; ROXR      (A1)+
      DBF       D6,.bloc
      DBF       D7,.ligne
*> Construit la seconde courbe pour le deuxième cercle
      LEA       COURBE_CIRCLE(PC),A0
      LEA       512(A0),A1
      LEA       courbe,A2
      move.w    #8*32-1,d0
.rep0:move.w    (a1)+,(a2)+
      dbf	d0,.rep0
      move.w    #8*32-1,d0
.rep1:move.w    (a0)+,(a2)+
      dbf	d0,.rep1

*> Code Generé pour afficher les cercles
      lea	Code_genere,a0           ; Adresse du Buffer
      move.w	#196-1,d7            ; 200 lignes
.Genere_toutes_les_lignes:
      move.w	#$3298,(a0)+         ; Genere un move.w	(a0)+,(a1)
      moveq	#8,d5                  ; offset initialisé à 8
      moveq	#19-1,d6               ; nb ligne
.Genere_une_ligne:
      move.w	#$3358,(a0)+         ; Genere un move.w	(a0)+,xx(a1)
      move.w	d5,(a0)+             ; et voila l'offset $xx
      addq.w	#8,d5                ; offset + 8
      dbra	d6,.Genere_une_ligne
      move.l	#$43E900A0,(a0)+     ; Genere un lea	160(a1),a1
      move.l	#$41E80010,(a0)+     ; Genere un lea	16(a0),a0
      dbra	d7,.Genere_toutes_les_lignes
      move.w	#$4e75,(a0)          ; Et un RTS !!!
      RTS 

Circle_effect:
*> First Circle Effect
      LEA       PARAMS_CIRCLE(PC),A0
      MOVE.W    (A0),D3 
      MOVE.W    2(A0),D5
      MOVE.W    4(A0),D4
      ADDI.L    #$60004,(A0)       ; Vitesse X set
      ADDQ.W    #8,4(A0)           ; Vitesse Y set
      ANDI.W    #$3FE,(A0)         ; Normalizations...
      ANDI.W    #$3FE,4(A0)        ;
      CMPI.W    #$3F0,2(A0)        ; Test la fin
      BCS.S     .not_the_end1
      SUBI.W    #$3F0,2(A0) 
.not_the_end1:
      LEA       COURBE_CIRCLE(PC),A0 ; Calcul la courbe
      MOVE.W    0(A0,D3.W),D3 
      ADD.W     0(A0,D5.W),D3 
      ASR.W     #1,D3 
      MOVE.W    0(A0,D4.W),D4 
      ADDI.W    #512,D3
      ADDI.W    #512,D4
      LSR.W     #3,D3 
      LSR.W     #3,D4 
      MOVE.W    D3,D0 
      MOVE.W    D0,D1 
      ANDI.W    #$E,D0
      SUB.W     D0,D1 
      ADD.W     D0,D0 
      LSR.W     #3,D1 
      MULU      #56,D4 
      ADD.W     D4,D1 
      LEA       DATA_CIRCLE(PC),A0 ; Dessine le premier Cercle
      MOVEA.L   0(A0,D0.W),A0 
      ADD.W     #2+8,D1            ; Cache la misère à gauche
      ADDA.W    D1,A0 
      MOVEA.L   physique,A1
      LEA       160*73(A1),A1
      LEA       4*20*2(A0),A0      ; On zappe les 4 permières lignes
      JSR       Code_genere        ; Appel du code généré pour afficher le cercle
*> Second Circle Effect
      LEA       PARAMS_CIRCLE(PC),A0
      MOVE.W    (A0),D3 
      MOVE.W    2(A0),D5
      MOVE.W    4(A0),D4
      ADDI.L    #$60004,(A0)       ; Vitesse X set
      ADDQ.W    #8,4(A0)           ; Vitesse Y set
      ANDI.W    #$3FE,(A0)         ; Normalizations...
      ANDI.W    #$3FE,4(A0)        ;
      CMPI.W    #$3F0,2(A0)        ; Test la fin
      BCS.S     .not_the_end2
      SUBI.W    #$3F0,2(A0) 
.not_the_end2:
      LEA       courbe,A0         ; Calcul la deuxième courbe fabriqué
      MOVE.W    0(A0,D3.W),D3 
      ADD.W     0(A0,D5.W),D3 
      ASR.W     #1,D3 
      MOVE.W    0(A0,D4.W),D4 
      ADDI.W    #512,D3
      ADDI.W    #512,D4
      LSR.W     #3,D3 
      LSR.W     #3,D4 
      MOVE.W    D3,D0 
      MOVE.W    D0,D1 
      ANDI.W    #$E,D0
      SUB.W     D0,D1 
      ADD.W     D0,D0 
      LSR.W     #3,D1 
      MULU      #56,D4 
      ADD.W     D4,D1 
      LEA       DATA_CIRCLE(PC),A0 ; Dessine le deuxième Cercle
      MOVEA.L   0(A0,D0.W),A0 
      ADD.W     #2+8,D1            ; Cache la misère à gauche
      ADDA.W    D1,A0 
      MOVEA.L   physique,A1
      LEA       160*73+2(A1),A1
      LEA       4*20*2(A0),A0      ; On zappe les 4 permières lignes
      JSR       Code_genere        ; Appel du code généré pour afficher le cercle
      RTS 

***************************************************************
*                                                             *
*         BARS RASTER MOVEMENT BY ZORRO2/NOEXTRA-TEAM         *
*                                                             *
***************************************************************
KEYPAD:         CMPI.B    #$48,$FFFFFC02.W ; CURSEUR HAUT
                BNE.S     .suite 
                CMPI.W    #0,POSITION_BARRE
                BEQ.S     .suite 
                MOVE.W    #1,SENS_BARRE
.suite:         CMPI.B    #$50,$FFFFFC02.W ; CURSEUR BAS
                BNE.S     .fin 
                CMPI.W    #11,POSITION_BARRE
                BEQ.S     .fin 
                MOVE.W    #2,SENS_BARRE
.fin:           RTS 

MVT_BARRE:      CMPI.W    #1,SENS_BARRE
                BNE.S     .bas 
.haut:          SUBQ.B    #1,HBL_POS_1
                ADDQ.B    #1,HBL_POS_2
                ADD.W     #1,BAR_TEMPO
                CMPI.W    #11,BAR_TEMPO
                BLE.S     .fin
                CLR.W     SENS_BARRE 
                MOVE.W    #0,BAR_TEMPO
                SUBI.W    #1,POSITION_BARRE
                SUB.L     #1,$40.W
.bas:           CMPI.W    #2,SENS_BARRE
                BNE.S     .fin 
                ADDQ.B    #1,HBL_POS_1
                SUBQ.B    #1,HBL_POS_2
                ADD.W     #1,BAR_TEMPO
                CMPI.W    #11,BAR_TEMPO
                BLE.S     .fin
                CLR.W     SENS_BARRE 
                MOVE.W    #0,BAR_TEMPO
                ADDI.W    #1,POSITION_BARRE
                ADD.L     #1,$40.W
.fin:           RTS 

***************************************************************
*                                                             *
*         TEXT FONT 8*8 ONE PLANE BY ATOMUS/NOEXTRA           *
*                                                             *
***************************************************************
PUT_TEXT:
      MOVE.W    #0,COMPT_T
      MOVE.W    #0,DECAL_T
      LEA       TEXTE,A5
      MOVEA.L   physique(pc),A2
      ADD.L     #(160*257)+4,A2
      BSR.S     PUT_LINES
      MOVE.W    #0,COMPT_T
      MOVE.W    #0,DECAL_T
      LEA       TEXTE,A5
      MOVEA.L   physique+4(pc),A2
      ADD.L     #(160*257)+4,A2
PUT_LINES:
      MOVEQ     #0,D1 
      MOVE.B    (A5)+,D1
      CMPI.B    #$FF,D1 
      BEQ.S     END_TEXT 
      CMPI.B    #0,D1 
      BNE.S     .no_end 
      CLR.W     COMPT_T 
      ADDI.W    #1,DECAL_T
      BRA.S     PUT_LINES 
.no_end:
      SUBI.B    #32,D1 
      MULS      #6,D1 
      LEA       SMALL_FONT_08_08,A0
      ADDA.W    D1,A0 
      MOVE.L    A2,A1
      MOVE.W    COMPT_T,D1
      BTST      #0,D1 
      BEQ.S     .putc 
      LEA       1(A1),A1
.putc:DIVS      #2,D1 
      MULS      #8,D1 
      ADDA.W    D1,A1 
      MOVE.W    DECAL_T,D1
      MULS      #160*6,D1
      ADDA.W    D1,A1 
      MOVE.B    (A0)+,(A1)
      MOVE.B    (A0)+,160(A1) 
      MOVE.B    (A0)+,320(A1) 
      MOVE.B    (A0)+,480(A1) 
      MOVE.B    (A0)+,640(A1) 
      MOVE.B    (A0)+,800(A1) 
      ADDI.W    #1,COMPT_T
      BRA.S     PUT_LINES 
END_TEXT:RTS 

***************************************************************
*                                                             *
*         TEXT FONT 8*8 ONE PLANE BY AVENGER/AL TEAM          *
*  ADAPTED FOR EXTRA FONT OF MISTER.A BY ZORRO2/NOEXTRA-TEAM  *
*                                                             *
***************************************************************
no  equ 0
yes equ 1
MED equ 1
LOW equ 0
CHARS      equ 40  ; chars per line, 80=for med res, 40 for low res
LINES      equ 33  ; 33 for 8x8 FONT, 45 with 6x6 FONT 
INNERLINE  equ 4   ; Pas between each line
FONT_SIZE  equ 8   ; 8=8x8, 6=6x6 FONT
SHIFTSIZE  equ 4   ; 2=MED RESOLUTION, 4=FOR LOW RESOLUTION
RESOLUTION equ LOW ; if no, then its low resolution

print_text:     clr.w	x_curs
                clr.l	x_offset
                clr.l	y_offset
                lea     message(pc),a2
new_char:       bsr     _x_conversion
                moveq   #0,d0    
                move.b  (a2)+,d0	;if zero, stop routine
                cmp.b	#0,d0
                beq	LF
                cmp.b	#$ff,d0
                bne.s   process_char
                rts

process_char:   asl.w 	#3,d0                ; valeur * 8
                lea     FONT_NOEX(pc),a1	
                sub.w	#256,d0         
                adda.w  d0,a1
                
                movea.l physique,a0
                lea     160*80+6(a0),a0
                adda.l  y_offset(pc),a0
                adda.l  x_offset(pc),a0
                
                movea.l physique+4,a3
                lea     160*80+6(a3),a3
                adda.l  y_offset(pc),a3
                adda.l  x_offset(pc),a3
                
                rept	FONT_SIZE
                move.b  (a1),(a0)	
                move.b  (a1)+,(a3)	
                lea	160(a0),a0
                lea	160(a3),a3
                endr
                
                addq.w  #1,x_curs           
                cmpi.w  #CHARS,x_curs        ; 79 for MED res
                bls     new_char
                move.w  #CHARS,x_curs        ; 79 for MED res
                bra   	new_char

LF:             clr.w	x_curs                 ; back to first char
                addi.l  #(FONT_SIZE*160)+160*INNERLINE,y_offset ; linefeed when reached ',0'
                cmpi.l  #LINES*FONT_SIZE*160,y_offset
                bls     new_char
                move.l  #LINES*FONT_SIZE*160,y_offset
                bra     new_char

_x_conversion:  move.w	x_curs(pc),d0
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
*                                                             *
*         SCROLLING 12*12 1 PLANE BY ATOMUS/NOEXTRA           *
*                                                             *
***************************************************************
SCROLLH:
      MOVEA.L   PAS,A0
      LEA       BIGBUF,A1
      ADDA.W    LIGNE,A1
      MOVEA.L   physique,A2
      ADD.L     #(160*233)+6,A2
      MOVEQ     #20-1,D2 
      MOVE.W    (A0)+,D0
      LEA       16(A1,D0.W),A3
.loop:MOVE.W    (A0)+,D0
      LEA       0(A1,D0.W),A5 
      MOVE.W    (A3)+,D1
      OR.W      (A5)+,D1
      MOVE.W    D1,(A2) 
      MOVE.W    (A3)+,D1
      OR.W      (A5)+,D1
      MOVE.W    D1,160(A2)
      MOVE.W    (A3)+,D1
      OR.W      (A5)+,D1
      MOVE.W    D1,320(A2)
      MOVE.W    (A3)+,D1
      OR.W      (A5)+,D1
      MOVE.W    D1,480(A2)
      MOVE.W    (A3)+,D1
      OR.W      (A5)+,D1
      MOVE.W    D1,640(A2)
      MOVE.W    (A3)+,D1
      OR.W      (A5)+,D1
      MOVE.W    D1,800(A2)
      MOVE.W    (A3)+,D1
      OR.W      (A5)+,D1
      MOVE.W    D1,960(A2)
      MOVE.W    (A3)+,D1
      OR.W      (A5)+,D1
      MOVE.W    D1,1120(A2) 
      MOVEA.L   A5,A3 
      ADDQ.W    #8,A2 
      DBF       D2,.loop
      SUBI.W    #4896,LIGNE
      BPL.S     .rts 
      ADDI.W    #26112,LIGNE
      ADDQ.L    #2,PAS
      CMPI.L    #ENDLINE,PAS
      BLT.S     .rts 
      MOVE.L    #BUFFER,PAS
.rts: RTS 

PRETEXT:
      LEA       TEXTH,A0
      LEA       BUFFER,A1
      MOVE.W    #NB_CARAC_TO_BUFFER,D1
.loop:MOVEQ     #0,D0 
      MOVE.B    (A0)+,D0
      MOVE.B    ASCII(PC,D0.W),D0 
      MULU      #32,D0 
      MOVE.W    D0,(A1)+
      DBF       D1,.loop
      RTS 

ASCII:INCBIN	"ASCII.DAT"
      EVEN

PRESHIFT:
      LEA       FONT_12_12,A0
      LEA       BIGBUF,A1
      MOVEQ     #50,D0 
.loop:MOVE.W    (A0)+,(A1)+ 
      MOVE.W    (A0)+,(A1)+ 
      MOVE.W    (A0)+,(A1)+ 
      MOVE.W    (A0)+,(A1)+ 
      MOVE.W    (A0)+,(A1)+ 
      MOVE.W    (A0)+,(A1)+ 
      MOVE.W    (A0)+,(A1)+ 
      MOVE.W    (A0)+,(A1)+ 
      CLR.W     (A1)+ 
      CLR.W     (A1)+ 
      CLR.W     (A1)+ 
      CLR.W     (A1)+ 
      CLR.W     (A1)+ 
      CLR.W     (A1)+ 
      CLR.W     (A1)+ 
      CLR.W     (A1)+ 
      DBF       D0,.loop
      MOVE.W    #764,D0
.loopa:MOVE.W    (A0),D1 
 rept 7
      SWAP      D1
      MOVE.W    16(A0),D1 
      LSR.L     #1,D1 
      MOVE.W    D1,16(A1) 
      SWAP      D1
      MOVE.W    D1,(A1)+
      ADDQ.W    #2,A0 
      MOVE.W    (A0),D1 
 endr
      SWAP      D1
      MOVE.W    16(A0),D1 
      LSR.L     #1,D1 
      MOVE.W    D1,16(A1) 
      SWAP      D1
      MOVE.W    D1,(A1)+
      ADDQ.W    #2,A0 
      LEA       16(A0),A0 
      LEA       16(A1),A1 
      DBF       D0,.loopa
      RTS 

************************************************
*         Little Vumeters by FANTOMAS          *
************************************************
DIGITS:         lea $ff8800,a0
                move.l physique(pc),a1
                add.l #(160*261)+8*9+4,a1
                lea (a1),a2
i               set 0
                rept 16/8
                clr.w i(a1)
i               set i-160
                endr
                moveq #0,d0                 ; Voie 1
                move.b #11,(a0)
                move.b (a0),d0
                cmp.b #16/4+2,d0
                blt.s ok1
                move.b #15/4+2,d0
ok1:            move.w #%11100000000000,(a1)
                lea -160(a1),a1
                dbf d0,ok1
                move.l a2,a1                ; Voie 2
                moveq #0,d0
                move.b #9,(a0)
                move.b (a0),d0
                cmp.b #16/4+2,d0
                blt.s ok2
                move.b #15/4+2,d0
ok2:            or.w #%000000111000000,(a1)
                lea -160(a1),a1
                dbf d0,ok2
                move.l a2,a1                ; Voie 3
                moveq #0,d0
                move.b #10,(a0)
                move.b (a0),d0
                cmp.b #16/4+2,d0
                blt.s ok3
                move.b #15/4+2,d0
ok3:            or.w #%0000000000001110,(a1)
                lea -160(a1),a1
                dbf d0,ok3
                RTS

***************************************************************
 SECTION	DATA                                             // *
***************************************************************

* Full data here :
* >
********* BAR MENU ***********************************>>>
SENS_BARRE:
	DC.W	$0
HBL_POS_1:
	DC.W	$0
HBL_POS_2:
	DC.W	$0
POSITION_BARRE:
	DC.W	$0
BAR_TEMPO:
	DC.W	$0
********* BAR MENU ***********************************<<<

********* CIRCLE ***********************************>>>
DATA_CIRCLE:
	DC.L	$0	; Adresse Buffer_Cercle_part2 - position 0
	DC.L	$0	; Adresse Buffer_Cercle_part2 - position 1
	DC.L	$0	; Adresse Buffer_Cercle_part2 - position 2
	DC.L	$0	; Adresse Buffer_Cercle_part2 - position 3
	DC.L	$0	; Adresse Buffer_Cercle_part2 - position 4
	DC.L	$0	; Adresse Buffer_Cercle_part2 - position 5
	DC.L	$0	; Adresse Buffer_Cercle_part2 - position 6
	DC.L	$0	; Adresse Buffer_Cercle_part1
END_DATA_CIRCLE:
PARAMS_CIRCLE:
	DC.W     $0	; X
	DC.W     $0	; Compteur
	DC.W     $0	; Y
COURBE_CIRCLE:
	incbin	"COURBE.DAT"
	even
MOTIF_CIRCLE:
	incbin	"MOTIF.DAT"
	even
********* CIRCLE ***********************************<<<

********* TEXTE ***********************************>>>
message:
	dc.b	" REPLICANTS.......AIR WARRIORS CRACKTRO",0
	dc.b	" FUZION......NEW INTRODUCTION OF FUZION",0
	dc.b	" UNKNOW?...............REPLICANTS INTRO",0
	dc.b	" INVIZIBLES....INVIZIBLES OF FLEXICHRON",0
	dc.b	" ALTAIR.................3615-MC3 PUBTRO",0
	dc.b	" MJJPROD...................LOUSY SCREEN",0
	dc.b	" RADIATION..............DRAWIN",$27," CD MENU",0
	dc.b	" PULSION/REPLICANTS.......HOOK CRACKTRO",0
	dc.b	" OVERLANDERS...................OVERTOWN",0
	dc.b	" CYG.....................SPHERICAL DEMO",0
	dc.b	" ST KNIGHTS..........STE PHALEON SCREEN",0
	dc.b	" TTZP INC...................HIGH SCROLL",$ff
	even
x_curs:
	dc.l $0
y_offset:
	dc.l $0
x_offset:
	dc.l $0
FONT_NOEX:
	incbin 	"FONT88Z.DAT"            ; Special RAZOR 1991 by M.A 
	EVEN
********* TEXTE ***********************************<<<

********* LITTLE TEXT *****************************>>>
COMPT_T:
	DC.W	$0
DECAL_T:
	DC.L	$0 
TEXTE:
* ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789-*:/!()?,.+
  DC.B	'VOL.4-CODE:ZORRO2-  :TOMCHI-GFX:MISTER.A'
  DC.W	$FFFF
  even
SMALL_FONT_08_08:
	incbin	"SFONT_08.DAT"
	even

********* LITTLE TEXT *****************************<<<

********* SCROLLTEXT ******************************>>>
* VERY IMPORTANT !!!
* You need to assigne the two values NOMBRE_DE_LIGNE and NOMBRE_DE_CARACTERE_PAR_LIGNE
* to input the correct value in NB_CARAC_TO_BUFFER.
* Each line have 116 characters in default !
NOMBRE_DE_LIGNE equ 19+3+3	;	Number of line to display in the scrolltext
NOMBRE_DE_CARACTERE_PAR_LIGNE equ 116 ; Number of character into the line of the scrolltext
PAS:
	DC.L	BUFFER
TEXTH:
* ABCDEFGHIJKLMOPQRSTUVWXYZ .,!?()/$270123456789 
; Text from Jace/St Knights
	dc.b	'                       '
	dc.b	'HI THIS IS JACE ON KEYBOARD. I WANT TO THANK ZORRO2 FOR INCLUDING MY TWO OLD SCREENS IN THIS NEW NOEXTRA COMPIL.  '
	dc.b	'THESE TWO OLD SCREENS ARE NOT THE FINAL ONES, COZ I',$27,'VE LOST THE SOURCE CODE DUE TO DISK FAILS. SOME INFOS ABOUT TH'
	dc.b	'E FUZION INTRO. THIS LITTLE PIECE OF CODE WAS SUPPOSED TO INCLUDE A SWINGING GAME SELECTOR IN THE FOURTH PLANE, AN'
	dc.b	'D STILL GOT ABOUT 20 PERCENT CPU LEFT (THE SCROLLTEXT NOPS) FOR THIS. IT HAS NEVER BEEN USED JUST BECAUSE WE (ST K'
	dc.b	'NIGHTS MEMBERS) MOVED TO HEMOROIDS AS SOON AS WE ENTERED FUZION! DRAGON OF FUZION TOLD US TO JOIN HIS CREW TO MAKE'
	dc.b	' A BIG MEGADEMO WITH SOME OF THEIR MEMBERS (KELVIN AND KASAR ...). BUT THESE TWO GUYS LEFT FUZION TO CREATE A TRUE'
	dc.b	' DEMO CREW CALLED ',$27,'POSITIVITY',$27,' SO WE BECAME WERE THE ONLY DEMO CODING ORIENTED MEMBERS, THE REST OF THE CREW WAS G'
	dc.b	'AME ACTIVITIES. FINALLY, AFTER A FEW MONTH, WE DECIDED TO MOVE TO HEMOROIDS. SOME PARTS OF THE FUSION MEGADEMO BEC'
	dc.b	'AME NRJ FOR YOU, SOME OTHER THE COLORZ DEMO. BUT THE NRJ SOUNDEMO WAS SUPPOSED TO BE RELEASED BY FUZION. WE NEVER '
	dc.b	'SEEN IT PRODUCED. IN 1992, I DECIDED TO MAKE IT BACK TO LIFE. LET',$27,'S TALK NOW ABOUT THE STE DEMO. THIS DEMO WAS MAD'
	dc.b	'E FOR THE PHALEON GIGADEMO. I DECIDED TO BORROW ALDYN',$27,'S STE FOR A WEEK TO MAKE SOMETHING DIFFERENT. AFTER TWO OR T'
	dc.b	'HREE DAYS OF HARD CODE, I',$27,'VE SENT A PREVIEW TO MIT OF NEXT (WITHOUT THE FINAL LOGO AND SOUND). THEN I PHONED TO HE'
	dc.b	'AR WHAT HE THOUGHT ABOUT IT. HE TOLDS ME THIS WAS A PURE SHIT, EVEN WITH THE LOGO AND SOUNDTRACK MUSIC ADDED. AS D'
	dc.b	'IEU OF ST KNIGHTS WAS ONE OF THE BEST GFX ON ST, I THOUGHT MY CODE WAS TOO POOR. SO I DIDN',$27,'T FINISH IT AND NEVER R'
	dc.b	'ELEASED IT. BUT AFTER SEEING THE PHALEON, I CAME ANGRY AND I UNDERSTAND WHY HE REFUSED OUR PRODUCTION. HE WANTED N'
	dc.b	'O ONE ELSE TO MAKE A STE DEMO. THERE ONLY COULD BE ONE! HIS ONE. SO MIT, FUCK OFF!!! OKAY AFTER THIS PARTS OF HIST'
	dc.b	'ORY. HERE ARE SOME GREETS, HI TO ALL MY FRIENDS AROUND ON ATARI ST. NOEXTRA, HAD, DUNE, SECTOR ONE, DHS, OXYGENE, '
	dc.b	'MJJ PRODS, ORB, CHECKPOINT, MYSTICS BYTES, TSCC, POPSY, PARADOX, BOMB, TRSI,TRIPLE A, DBFINTERRACTIVE.COM FRIENDS '
	dc.b	'AND ALL THAT I HAVE FORGOTTEN!                                                                                    '
; Text from Cyg/BlaBla
	dc.b	'                       '
	dc.b	'SPHERICAL INTRO BY CYG AKA GRAF7 IN THE 90',$27,'S. AT LAST RELEASED IN 2013 BUT FINISHED IN 92, 21 YEARS BEFORE....... '
	dc.b	'DON',$27,'T READ THE TEXT, I WAS YOUNG AND HOPEFULLY I STOPPED WRITTING SCROLLTEXT SINCE :) AS YOU CAN SEE, THE ROUTINE '
	dc.b	'WAS THE HIGHESTCOLOR PROMISES !           SEE U SOON FOR OTHER DEMOS !              CYG AKA GRAF7 AKA FABRICE     '
; Text from Zorro2/NoExtra
	dc.b	'                       '
	dc.b	'THANKS TO LAURENT AND FABRICE TO PUT SOME WORDS ON THIS LONG LONG LONG SCROLLTEXT INSIDE THIS EXTRA COMPILATION VO'
	dc.b	'LUME 4 IN 2013.             MEMBERS OF NOEXTRA TEAM ARE ATOMUS, MISTER.A, TOMCHI, ZORRO2, HYLST AND MAARTAU.      '
	dc.b	'(C)PRODUCTION NOEXTRA TEAM.........FEBRUARY 2013.........LETS WRAP !'
; End Text....
  dcb.w	NOMBRE_DE_CARACTERE_PAR_LIGNE,$0
	even
NB_CARAC_TO_BUFFER equ NOMBRE_DE_CARACTERE_PAR_LIGNE*NOMBRE_DE_LIGNE
BUFFER:
	DCB.W	NB_CARAC_TO_BUFFER,$0
ENDLINE:
	DCB.L	NOMBRE_DE_CARACTERE_PAR_LIGNE,$0
LIGNE:
	DC.W	$0 
FONT_12_12:
	incbin	"FONT1212.DAT"
	even
BIGBUF:
	DCB.W	820*8*2,$0 
	EVEN
********* SCROLLTEXT ******************************<<<
LOGO_EXTRA_Palette:
	dc.w	$0811,$0FF0,$0A32,$03B2,$0B4A,$04C3,$07F7,$02A9
	dc.w	$0199,$0E76,$0FFF,$0929,$0C5B,$05D4,$0D6C,$06ED
LOGO_EXTRA_Img:
	incbin	"MISTERA.IMG"	;	Logo 69*200
	even
* <

MUSIC:	* SNDH music -> Not compressed please !!!
	incbin	"T*.THK"
	even

***************************************************************
 SECTION	BSS                                              // *
***************************************************************

bss_start:

* < Full data here >
Buffer_Cercle_part1:
	ds.b	18368
Buffer_Cercle_part2:
	ds.b	18368*7
courbe:
	ds.b	1024
*
Code_genere:
	ds.w	1*196                      ; Place pour le code
	ds.w	(2*19)*196                 ; genere word
	ds.l	2*196                      ; genere long
	ds.w	1                          ; Place pour le rts
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
	even

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
