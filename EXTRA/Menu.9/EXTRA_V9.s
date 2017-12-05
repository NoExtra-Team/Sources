***************************************
* // EXTRA_V9.PRG                  // *
***************************************
* // Asm Intro Code Atari ST v0.44 // *
* // by Zorro 2/NoExtra (01/12/16) // *
* // http://www.noextra-team.com/  // *
***************************************
* // Original code : Zorro 2       // *
* // Gfx logo      : Mister.A      // *
* // Gfx font      : Mister.A      // *
* // Music         : TOMCHI        // *
* // Release date  : 26/08/2017    // *
* // Update date   : 19/11/2017    // *
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
	move.l	Default_palette,$ffff8240.w                ; init line of CPU
 ENDC

* < Put your code here >

	bsr	play_Effect

	bsr	scroll12x8_1p
	bsr	scroll12x8_1p

	BSR	KEYPAD                       ; Mvt de la barre 
	BSR	MVT_BARRE                    ;

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

	cmp.b	#$1,$fffffc02.w		* ESC KEY ?
	beq.s	EscapeKey

	cmp.b	#$39,$fffffc02.w	* SPACE KEY ?
	bne.s	default_loop

	add.l	#2,$40.w
	bra.s	ESCAPE_PRG

EscapeKey:
	move.l   #1,$40.w

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
NB_LIGNE equ 10-1

Inits:
	movem.l	d0-d7/a0-a6,-(a7)

	IFEQ	FADE_INTRO
	bsr	fadein                       ; Fading white to black
	ENDC

	bsr	Display_LOADING              ; Display texte LOADING

	moveq	#1,d0                      ; Choice of the music (1 is default)
	jsr	MUSIC+0                      ; Init SNDH music

	bsr	init_Effect
	bsr	print_text                   ; Affiche les Textes
	
	CLR.W   POSITION_BARRE           ; initialise barre de navigation
	MOVE.B  #5,HBL_POS_1             ; debut de la barre
	MOVE.B  #NB_LIGNE*10+NB_LIGNE*3-4,HBL_POS_2  ; fin de la barre
	MOVE.W	#0,BAR_TEMPO             ; temporisation a chaque deplacement de la barre  
	CLR.L   $40.W                    ; Numéro de la démo initialisé

	lea	Vbl(pc),a0                   ; Launch VBL
	move.l	a0,$70.w                 ;

	lea	Default_palette,a0           ; Put Default palette
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d7               ;
	movem.l	d0-d7,(a1)               ;

	movem.l	(a7)+,d0-d7/a0-a6
	rts

Display_LOADING:
	movea.l	physique(pc),a0       ; Put LOADING Logo
	lea     160*((200-5)/2)(a0),a0
	movea.l	#LOAD_Img,a1
	move.l	#160*5/4-1,d0
	move.l	(a1)+,(a0)+
	dbf	d0,*-2
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

; IFEQ NB_OF_SCREEN                 * Test if one Screen to display
	move.l	physique(pc),d0          ; Put physical Screen
	move.b	d0,d1                    ;
	lsr.w #8,d0                      ;
	move.b	d0,$ffff8203.w           ;
	swap d0                          ;
	move.b	d0,$ffff8201.w           ;
	move.b	d1,$ffff820d.w           ;
; ENDC

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
	MOVE.L    #HBL_Launch,$120.W     ; Go Timer B !
	MOVE.B    #$63,$FFFFFA1F.W
	MOVE.B    #4,$FFFFFA19.W
	MOVE.B    #30+3,$FFFFFA21.W        ; First position
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
HBL_Launch:     CLR.B     $FFFFFA1B.W
	*move.b #$ff,$ffff8240.w
	
	              MOVE.L    A0,-(A7)               ; Extra Palette
	              MOVE.L    A1,-(A7)
	              LEA       Default_palette,A0 
	              MOVEA.L   #$FF8240,A1 
	              MOVE.L    (A0)+,(A1)+ 
	              MOVE.L    (A0)+,(A1)+ 
	              MOVE.L    (A0)+,(A1)+ 
	              MOVE.L    (A0)+,(A1)+ 
	              MOVE.L    (A7)+,A1
	              MOVE.L    (A7)+,A0
                MOVE.L    #HBL1,$120.W 
                MOVE.B    HBL_POS_1,$FFFFFA21.W
                MOVE.B    #8,$FFFFFA1B.W
                RTE 

HBL1:           CLR.B     $FFFFFA1B.W
	*move.b #$0f,$ffff8240.w

	              MOVE.L    A0,-(A7)               ; Extra Palette
	              MOVE.L    A1,-(A7)
	              LEA       Surligne_palette,A0 
	              MOVEA.L   #$FF8240,A1 
	              MOVE.L    (A0)+,(A1)+ 
	              MOVE.L    (A0)+,(A1)+ 
	              MOVE.L    (A0)+,(A1)+ 
	              MOVE.L    (A0)+,(A1)+ 
	              MOVE.L    (A7)+,A1
	              MOVE.L    (A7)+,A0
                MOVE.L    #HBL2,$120.W 
                MOVE.B    #11,$FFFFFA21.W 
                MOVE.B    #8,$FFFFFA1B.W
                RTE 
      
HBL2:           CLR.B     $FFFFFA1B.W
	*move.b #$ff,$ffff8240.w

                MOVE.L    A0,-(A7)               ; Extra Palette
                MOVE.L    A1,-(A7)
                LEA       Default_palette,A0 
                MOVEA.L   #$FF8240,A1 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A7)+,A1
                MOVE.L    (A7)+,A0
                MOVE.L    #BORDER_BAS,$120.W 
                MOVE.B    HBL_POS_2,$FFFFFA21.W
                MOVE.B    #8,$FFFFFA1B.W     
                RTE 

BORDER_BAS:	    CLR.B     $FFFFFA1B.W
                BCLR      #0,$FFFFFA0F.W
               	JSR (MUSIC+8)                    ; Play SNDH music
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
	sf	$fffffa21.w                  ; Timer B data (number of scanlines to next interrupt)
	sf	$fffffa1b.w                  ; Timer B control (event mode (HBL))
	lea	HBL_Launch,a0                ; Launch HBL
	move.l	a0,$120.w                ;
	bset	#0,$fffffa07.w             ; Timer B vector
	bset	#0,$fffffa13.w             ; Timer B on
	bclr #3,$fffffa17.w              ; Automatic End-Interrupt hbl ON
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
                CMPI.W    #NB_LIGNE,POSITION_BARRE
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

*********************************************************************
*                   SCROLL FONT 13x8 - 1 BITPLANE                   *
*                          ZORRO 2/NOEXTRA                          *
*********************************************************************
HAUTEUR equ 13 ; Taille de le fonte / Hauteur du scrolling          *
*********************************************************************
scroll12x8_1p:
           move.w 	bit,d0
           cmp.w 	#8,d0
           bne.s 	countdown
           clr.w 	bit
           move.l 	ptr_mtexte,a1
           move.b 	(a1),d0
           cmp.b 	#-1,d0
           bne.s 	.reset
           move.l 	#mtexte,ptr_mtexte
           move.l 	ptr_mtexte,a1
           move.b 	(a1),d0
.reset:    addq.l 	#1,ptr_mtexte
           mulu.w 	#13,d0
           lea 	fonts12,a1
           sub.w	#256+158+2,d0
           add.w 	d0,a1
           lea 	buffer,a2
.put_character:
i          set 	0
           rept 	HAUTEUR
           move.b 	(a1)+,i(a2)
i          set 	i+2
           endr
countdown: addq.w 	#1,bit
.put_buffer:
           lea 	buffer_scrol,a1
           lea 	buffer,a2
i          set 	0
           rept	 HAUTEUR
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
i          set 	i+40
           endr
.put_in_screen:
           move.l 	physique(pc),a1
           lea		160*180-8*2+2(a1),a1
           lea 	buffer_scrol,a2
i          set 	2
           rept 	HAUTEUR
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

print_text:   clr.w	x_curs
              clr.l	x_offset
              clr.l	y_offset
              lea     message(pc),a2
new_char:     bsr     _x_conversion
              moveq   #0,d0    
              move.b  (a2)+,d0	           ;if zero, stop routine
              cmp.b	#0,d0
              beq	LF
              cmp.b	#$ff,d0
              bne.s   process_char
              rts

process_char: asl.w 	#3,d0                ; valeur * 8
              lea     FONT_NOEX(pc),a1	
              sub.w	#256,d0         
              adda.w  d0,a1
              
              movea.l physique,a0          ; Two screens
              lea     160*18+4(a0),a0
              adda.l  y_offset(pc),a0
              adda.l  x_offset(pc),a0
              
              movea.l physique+4,a3
              lea     160*18+4(a3),a3
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

LF:           clr.w	x_curs                 ; back to first char
              addi.l  #(FONT_SIZE*160)+160*INNERLINE,y_offset ; linefeed when reached ',0'
              cmpi.l  #LINES*FONT_SIZE*160,y_offset
              bls     new_char
              move.l  #LINES*FONT_SIZE*160,y_offset
              bra     new_char

_x_conversion:move.w	x_curs(pc),d0
              and.l	#$ffff,d0
              btst	#0,d0
              beq.s	_even
              subq.w	#1,d0
              mulu	#SHIFTSIZE,d0          ; 2=med res, 4=low
              addq.w	#1,d0
              bra	_done_conv
_even:        mulu	#SHIFTSIZE,d0          ; 2=med res, 4=low
_done_conv:   move.l	d0,x_offset
              rts

init_Effect:
	lea	data_GRILLE,a0               ; Datas effect compressed
	lea	buffer_GRILLE,a1             ; Buffer destination
	bsr	d_lz77                       ; Decompressed data in a0 -> a1
	rts

 include "LZ77_130.ASM"
 even

play_Effect:
	move.l	ptr_COORD_X,a2
	cmp.l	#-1,(a2)
	bne.s	.noreinit
	
	move.l	#COORD_X,ptr_COORD_X
	move.l	ptr_COORD_X,a2
.noreinit:

	move.l	(a2)+,a0
	move.l	a2,ptr_COORD_X

	movea.l	physique(pc),a1
	move	#200-1,d1                  ; number of lines
.loop;
i	set	0
	rept	20                         ; repeat chunks (1 chunk=16 pixels)
	move.l	i(a0),i(a1)              ; copy 1st half of a chunk (logical)
i	set	i+8                          ; next chunk
	endr                             ; end of copying chunks
	add.l	#160,a0                    ; next scanline line for logical
	add.l	#160,a1                    ; next scanline line for piccy
	dbf	d1,.loop                     ; end of copying lines
	rts

***************************************************************
 SECTION	DATA                                             // *
***************************************************************

Default_palette:
		dc.w	$0223,$0645,$0434,$0655,$0000,$0776,$0776,$0000
		dc.w	$0000,$0777,$0766,$0000,$0000,$0000,$0000,$0000

Surligne_palette:
		dc.w	$0223,$0645,$0434,$0655,$0000,$664,$664,$0000

* << Full data here >>

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

********* TEXTE ***********************************>>>
message:
	dc.b	"       COMPILATION EXTRA VOLUME 9   ",0,0
	dc.b	"    ACS.................INTRO SCREEN",0
	dc.b	"    DMA...........SPEEDBALL CRACKTRO",0
	dc.b	"    FACTORY..THUNDER BURNER CRACKTRO",0
	dc.b	"    FANATICS........TRIAL CHESSPLANE",0
	dc.b	"    FIRE CRACKER.........BALLS INTRO",0
	dc.b	"    FUSION.................POWER OFF",0
	dc.b	"    GAMBLERS........MEGA SWAPP INTRO",0
	dc.b	"    MEGABUB...WORLD SNOOKER CRACKTRO",0
	dc.b	"    NEXT................MEGA 3D DEMO",0
	dc.b	"    OUCH.......ULTIMATE MUSICAL MENU",$ff
	even       
x_curs:
	dc.l $0
y_offset:
	dc.l $0
x_offset:
	dc.l $0
FONT_NOEX:
	incbin 	"BOBBLE.DAT"
	EVEN
********* TEXTE ***********************************<<<

********* SCROLLTEXTE ***********************************>>>
bit:
	ds.w 	1
buffer:
	ds.w 	HAUTEUR
buffer_scrol:
	ds.w	256+HAUTEUR
ptr_mtexte:
	dc.l	mtexte
mtexte:
* < !'#$%&"()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyzCUR> *
	dc.b	"          "
	dc.b "WELCOME TO THE NINTH EXTRA VOLUME BY NOEXTRA-TEAM IN 2017. "
	dc.b "MENU CODED BY ZORRO2, LOADER CODED BY ZORRO2 AND MAARTAU, GFX INTRO BY MISTER.A AND SOUNDCHIP BY TOMCHI. "
	dc.b "ENJOY ALL PREVIEW INSIDE THIS DELICIOUS MENU ! "
	dc.b "DON'T FORGET TO USE THE KEYBOARD KEYS LEVEL UP AND DOWN TO CHOOSE AN ITEM AND PRESS SPACE TO SEE IT. "
	dc.b " NOW IT'S TIME TO LET OUR GUEST, DBUG OF NEXT TO TALK ABOUT HIS OLD UNRELEASE.....                   "
* Mickael's sentences...
	dc.b	"DBUG ON THE KEYBOARD...                     "
	dc.b	"THE ETERNAL GRAVE DIGGING HAS LOCATED EVEN MORE LOST PARTS, EVEN MORE FORGOTTEN BITS... "      
	dc.b	"IN 2008 I RELEASED 'FORGOTTEN BITS' AT THE SOLSKOGEN DEMO PARTY. "
	dc.b	"I KNEW IT WAS INCOMPLETE, BUT I COULD NOT FIND THE MISSING EFFECTS IN MY ARCHIVES. "
	dc.b	"WHEN I MOVED FROM FRANCE TO NORWAY IN 2005, I GAVE AWAY MOST OF MY ATARI HARDWARE AND FLOPPIES "
	dc.b	"TO FELLOW ATARIANS, HOPING IT WOULD BE USED FOR GOOD THINGS. "
	dc.b	"SOMEWHAT, MY OLD FLOPPIES ENDED UP AT THE GRAVE DIGGERS'S HQ, WHERE THE CARETAKER TOOK THE TIME "
	dc.b	"TO BREAK THE COFFINS OPEN TO EXAMINE THE STATE OF THE DECAYING FILES... "
	dc.b	"THIS IS WHY YOU REGULARLY SEE SOME OLD NEXT PRODUCTIONS APPEARING IN THESE NOEXTRA COMPILATIONS. "
	dc.b	"WHEN I GO ON DEMOZOO AND LOOK AT THE NEXT, DEFENCE-FORCE, OR DBUG PRODS LISTS, I'M SIMPLY AMAZED "
	dc.b	"BY THE SHEER NUMBER OF STUFF WE HAVE BEEN RELEASING OVER THE YEARS, "
	dc.b	"SPECIALLY CONSIDERING NEITHER NEXT OR DEFENCE-FORCE HAVE BEEN SUPER LARGE GROUPS. "
	dc.b	"ENJOY, AND I GUESS EXPECT SOME MORE STUFF NOW AND THEN. "
	dc.b	"DBUG DROPPING THE KEYBOARD... "
*
	dc.b	"                                                           "
	dc.b	"ATTENTION! ACS INTRO WORKS ONLY ON ATARI STF AND NEXT AND OUCH! PRODUCTIONS WORK ONLY ON ATARI STE. DON'T FORGET THIS ! "
	dc.b	"           BONUS : LISTING OF FLOPPYS FROM THE FANATICS BY REBEL MC HIMSELF ! "
	dc.b	"                                                           "
	dc.b	"THIS IS THE BEFORE LATEST RELEASE OF DEMOPACK EDITION BY NOEXTRA, THE NEXT RELEASE SHOULD WORK ONLY ON ATARI STE ! "
	dc.b	"                                  LET'S WRAP AGAIN !!!!                                 "
	dc.b	"                                                           "
	dc.b	-1
	even
fonts12:
	incbin 	"FONT12_5.DAT"
	even
********* SCROLLTEXTE ***********************************<<<

ptr_COORD_X:
	dc.l	COORD_X
COORD_X:
	dc.l	buffer_GRILLE+0*200*160
	dc.l	buffer_GRILLE+1*200*160
	dc.l	buffer_GRILLE+2*200*160
	dc.l	buffer_GRILLE+3*200*160
	dc.l	buffer_GRILLE+4*200*160
	dc.l	buffer_GRILLE+5*200*160
	dc.l	buffer_GRILLE+6*200*160
	dc.l	buffer_GRILLE+7*200*160
	dc.l	-1

data_GRILLE:
	incbin	"GRILLE.L7Z"
	even

LOAD_Img:
	incbin	"LOAD.IMG"
	even

* <

MUSIC:
	incbin "LTC08VBL.SND"            ; SNDH Music played at the VBL
	even

***************************************************************
 SECTION	BSS                                              // *
***************************************************************

bss_start:

* << Full data here >>

buffer_GRILLE:
	ds.b	256000

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
