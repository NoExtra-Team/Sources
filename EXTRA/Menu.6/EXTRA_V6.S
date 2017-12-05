***************************************
* // EXTRA_V6.PRG                  // *
***************************************
* // Asm Intro Code Atari ST v0.42 // *
* // by Zorro 2/NoExtra (05/12/11) // *
* // http://www.noextra-team.com/  // *
***************************************
* // Original code : Zorro 2       // *
* // Gfx logo      : Mister.A      // *
* // Gfx font      : Mister.A      // *
* // Music         : TOMCHI        // *
* // Release date  : 12/11/2015    // *
* // Update date   : 27/11/2015    // *
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
	btst    #13,d0                   ; Specially for relocation
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

	bsr	Inits                        ; Initialisations

**************************** MAIN LOOP ************************>

	move.w	#0,idontwanttoseeNuages

default_loop:

	bsr	Wait_vbl                     ; Waiting after the VBL

	IFEQ	SEEMYVBL
	;clr.b	$ffff8240.w
	move.w	LOGO_EXTRA_Palette,$ffff8240.w
	ENDC

* < Put your code here >

	BSR	KEYPAD                       ; Mvt de la barre 
	BSR	MVT_BARRE                    ;

	cmp.w	#-1,idontwanttoseeNuages   ; If bugs appear...
	beq.s	.yopla
	bsr	Display_Nuages
.yopla:

	bsr	print_text_part
	bsr	Run_Scroll1p
	bsr	print_border_part
	bsr	Display_Rasters 

* <

	movem.l	d0/a0,-(a7)
	lea     physique(pc),a0          ; Swapping two Screens
	move.l	(a0),d0                  ;
	move.l	4(a0),(a0)+              ;
	move.l	d0,(a0)                  ;
	move.b  d0,$ffff820d.w           ;
	move    d0,-(sp)                 ;
	move.b  (sp)+,d0                 ;
	move.l  d0,$ffff8200.w           ;
	movem.l	(a7)+,d0/a0

	IFEQ	SEEMYVBL
	cmp.b	#$38,$fffffc02.w           ; ALT key pressed ?
	bne.s	next_key                   ;
	move.b	#7,$ffff8240.w           ; See the rest of CPU
next_key:                          ;
	ENDC

	cmp.b	#$30,$fffffc02.w		       * BUG KEY ?
	bne.s	.otherKey

	cmp.w	#0,idontwanttoseeNuages
	bne.s	.putPositive

.putNegative:
	move.w	#-1,idontwanttoseeNuages
	bra.s	.putNothing
.putPositive:
	move.w	#0,idontwanttoseeNuages
.putNothing:


.otherKey:
	cmp.b	#$1,$fffffc02.w		         * ESC KEY ?
	beq.s	EscapeKey

	cmp.b	#$39,$fffffc02.w	         * SPACE KEY ?
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

idontwanttoseeNuages:
	ds.w	1

***************************************************************
*                                                             *
*                 Initialisations Routines                    *
*                                                             *
***************************************************************
Inits:	movem.l	d0-d7/a0-a6,-(a7)

	IFEQ	FADE_INTRO
	bsr	fadein                       ; Fading white to black
	ENDC

	moveq	#1,d0                      ; Choice of the music (1 is default)
	jsr	MUSIC+0                      ; Init SNDH music

	lea	Vbl_Start(pc),a0             ; Launch VBL
	move.l	a0,$70.w                 ;

	bsr	init_Nuages                  ; Inits Effects
	bsr	Init_Rasters                 ;
	bsr	Init_Scroll1p                ;

	lea	physique(pc),a6              ; Put Logo NoExtra
	move.l	(a6)+,a0
	move.l	(a6)+,a1
	movea.l	#LOGO_EXTRA_Img,a4
	move.l	#160*74/4-1,d0
	move.l	(a4),(a0)+
	move.l	(a4)+,(a1)+
	dbf	d0,*-4

POINTEUR = 231
	lea	physique(pc),a6              ; bottom fond border
	move.l	(a6)+,a0
	add.l	#160*POINTEUR,a0
	move.l	(a6)+,a1
	add.l	#160*POINTEUR,a1
	movea.l	#BACKGROUND_Img,a4
	move.l	#160*38/4-1,d0
	move.l	(a4),(a0)+
	move.l	(a4)+,(a1)+
	dbf	d0,*-4

POINTEUR2 = 75
	lea	physique(pc),a6              ; Nuages
	move.l	(a6)+,a0
	add.l	#160*POINTEUR2,a0
	move.l	(a6)+,a1
	add.l	#160*POINTEUR2,a1
	movea.l	#NUAGE_Img+(160*40),a4
	move.l	#160*46/4-1,d0
	move.l	(a4),(a0)+
	move.l	(a4)+,(a1)+
	dbf	d0,*-4

	bsr	print_text                   ; Affiche le Texte

	CLR.W   POSITION_BARRE           ; initialise barre de navigation
	MOVE.B  #5-1,HBL_POS_1           ; debut de la barre
	MOVE.B  #11*10+11*3-4,HBL_POS_2  ; fin de la barre
	MOVE.W	#0,BAR_TEMPO             ; temporisation a chaque deplacement de la barre  
	CLR.L   $40.W

	MOVE.L	#TIMER_A,$134.W          ; Top Border
	MOVE.L	#HBL,$120.W              ;

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
	st	Vsync

	movem.l	d0-d7/a0-a6,-(a7)

	jsr	(MUSIC+8)                    ; Call music

	movem.l	(a7)+,d0-d7/a0-a6
	rte

Vbl:
	st	Vsync

	IFEQ	TOPBOTTOM_BORDER
	CLR.B   $FFFFFA1B.W              ; Timer B off
	MOVE.L    #HBL,$120.W            ; Go Timer B !
	MOVE.B    #$63,$FFFFFA1F.W
	MOVE.B    #4,$FFFFFA19.W
	MOVE.B    #1,$FFFFFA21.W         ; First position
	MOVE.B    #8,$FFFFFA1B.W
	ENDC

	MOVE.L    A0,-(A7)               ; Extra Palette
	MOVE.L    A1,-(A7)
	LEA       LOGO_EXTRA_Palette,A0 
	MOVEA.L   #$FF8240,A1 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A7)+,A1
	MOVE.L    (A7)+,A0
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

HBL:            CLR.B     $FFFFFA1B.W
                *MOVE.W    #$012,$ffff8240.w
                MOVE.L    #HBL_ENTRE,$120.W 
                MOVE.B    #1,$FFFFFA21.W
                MOVE.B    #8,$FFFFFA1B.W
                RTE 

NUMBER = 2
HBL_ENTRE:      CLR.B     $FFFFFA1B.W

                MOVEM.L   A0-A6/D1-D2,-(A7) 
                LEA       $FFFF8250.W,A0
                LEA       Repeat_R1,A4
                LEA       Repeat_R0,A6
                dcb.w	12+20-5,$4E71
                LEA       $FFFF8209.W,A1
                MOVEQ     #0,D1 
                SUB.B     (A1),D1 
                LSR.L     D1,D1 
                dcb.w	40,$4E71
                MOVE.W    #30*NUMBER,D2 
.loop:          MOVEA.L   (A4)+,A2
                MOVEA.L   (A6)+,A3
                JSR       (A2)
                DBF       D2,.loop
                MOVEM.L   (A7)+,A0-A6/D1-D2 

                MOVE.L    #HBL0,$120.W 
                MOVE.B    #9+1,$FFFFFA21.W
                MOVE.B    #8,$FFFFFA1B.W
                RTE 

HBL0:           CLR.B     $FFFFFA1B.W
                MOVE.L    #HBL1,$120.W 
                MOVE.B    HBL_POS_1,$FFFFFA21.W
                MOVE.B    #8,$FFFFFA1B.W

                dcb.w	110-30+6,$4e71 ; synchro

                MOVE.L    A0,-(A7)               ; Extra Palette
                MOVE.L    A1,-(A7)
                LEA       NUAGE_Palette,A0 
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

HBL1:           CLR.B     $FFFFFA1B.W
                MOVE.W    #$0ec,$ffff8240.w ; couleur de la barre !
                MOVE.L    #HBL2,$120.W 
                MOVE.B    #11,$FFFFFA21.W 
                MOVE.B    #8,$FFFFFA1B.W
                RTE 
      
HBL2:           CLR.B     $FFFFFA1B.W
                MOVE.W    #$0B55,$ffff8240.w
                MOVE.L    #BORDER_BAS,$120.W 
                MOVE.B    HBL_POS_2,$FFFFFA21.W
                MOVE.B    #8,$FFFFFA1B.W     
                RTE 

BORDER_BAS:     SF	$FFFFFA21.W    ; Stop Timer B
                SF	$FFFFFA1B.W    ;
                DCB.W	95,$4E71     ; 95 nops	Wait line end
                SF	$FFFF820A.W    ; Modif Frequency 60 Hz !
                DCB.W	28,$4E71     ; 28 nops	Wait line end
                MOVE.B	#$2,$FFFF820A.W	; 50 Hz !

                dcb.w	116,$4e71 ; synchro

                MOVE.L    A0,-(A7)               ; Extra Palette
                MOVE.L    A1,-(A7)
                LEA       BACKGROUND_Palette,A0 
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

                BCLR      #0,$FFFFFA0F.W

                jsr	(MUSIC+8)                    ; Call music

                RTE

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
                bsr	print_all
                rts

process_char:   asl.w 	#3,d0                ; valeur * 8
                lea     FONT_NOEX(pc),a1
                sub.w	#256,d0         
                adda.w  d0,a1
                
                lea Buffer_Texte,a0
                adda.l  y_offset(pc),a0
                adda.l  x_offset(pc),a0
                
                rept	FONT_SIZE
                move.b  (a1)+,(a0)
                lea	160(a0),a0
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

print_all:      lea Buffer_Texte,a0
                move.l	physique,a1
                add.l	#160*80+6,a1
                move.l	physique+4,a2
                add.l	#160*80+6,a2
                move.w	#140,d0
.loop
x	set	0
 rept 20
                move.w	x(a0),x(a1)
                move.w	x(a0),x(a2)
x set x+8
 endr
                lea	160(a0),a0
                lea	160(a1),a1
                lea	160(a2),a2
                dbf	d0,.loop
                rts

***************************************************************
*                                                             *
*            DISPLAY BACKGROUND ZORRO2/NOEXTRA-TEAM           *
*                                                             *
***************************************************************
Plan_Texte     equ 6
print_text_part:
StartX_display set 48
Hauteur_nuages set 16
                lea Buffer_Texte,a0
                add.l	#160*StartX_display,a0
                move.l	physique,a1
                add.l	#160*(StartX_display+80)+Plan_Texte,a1
                move.w	#Hauteur_nuages,d0
                bsr.s	.loop
StartX_display set 80
Hauteur_nuages set 13
                lea Buffer_Texte,a0
                add.l	#160*StartX_display,a0
                move.l	physique,a1
                add.l	#160*(StartX_display+80)+Plan_Texte,a1
                move.w	#Hauteur_nuages,d0    
                bsr.s	.loop                 
StartX_display set 108                     
Hauteur_nuages set 11                     
                lea Buffer_Texte,a0
                add.l	#160*StartX_display,a0
                move.l	physique,a1
                add.l	#160*(StartX_display+80)+Plan_Texte,a1
                move.w	#Hauteur_nuages,d0               
.loop
x	set	0
 rept 20
                move.w	x(a0),x(a1)
x set x+8
 endr
                lea	160(a0),a0
                lea	160(a1),a1
                dbf	d0,.loop
                rts

print_border_part:
                lea BACKGROUND_Img,a1
                move.l	physique,a0
                add.l	#160*231,a0
                moveq	#5,d7		; lines
.loop:          movem.l	(a1)+,d0-d6/a2-a4	; get 40 bytes
                movem.l	d0-d6/a2-a4,(a0)	; put 40 bytes
                movem.l	(a1)+,d0-d6/a2-a4	; and again
                movem.l	d0-d6/a2-a4,40(a0)
                movem.l	(a1)+,d0-d6/a2-a4	; and again
                movem.l	d0-d6/a2-a4,80(a0)
                movem.l	(a1)+,d0-d6/a2-a4	; and again
                movem.l	d0-d6/a2-a4,120(a0)
                lea	160(a0),a0		; next line down
                dbf	d7,.loop
                rts

***************************************************************
*                                                             *
*        GENERATED DISPLAY PLASMA ZORRO2/NOEXTRA-TEAM         *
*                                                             *
***************************************************************
Init_Rasters:
      LEA       DATA_Generate,A1
.loop:MOVEQ     #0,D0 
      MOVEQ     #0,D1 
      MOVE.W    (A1),D0 
      MOVE.W    2(A1),D1
      ADD.W     D0,D0 
      MOVE.W    D0,(A1) 
      MULU      #80,D1 
      MOVE.W    D1,2(A1)
      ADDQ.W    #4,A1 
      CMPA.L    #Repeat_R0,A1 
      BNE.S     .loop 
      rts

Display_Rasters:
      MOVEA.L   #Courbe,A0
      lea	160(a0),a0 
      LEA       Repeat_R0,A2
      LEA       Repeat_R1,A3
      LEA       DATA_Generate,A1
      MOVE.L    #$80010,D4	;	vitesse
      MOVE.W    #30*NUMBER+1,D7 
loop_R:MOVEQ     #0,D2 
      MOVEQ     #0,D3 
      MOVE.W    (A0),D0 
      MOVE.W    0(A1,D0.W),D2 
      MOVE.W    2(A1,D0.W),D3 
      ADD.W     D4,D0 
      CMP.W     #1600,D0
      BLT.S     .next0 
      SUBI.W    #1600,D0
.next0:MOVE.W    D0,(A0)+
      CMPA.L    #end_Courbe,A0 
      BNE.S     .next1 
      MOVEA.L   #Courbe,A0 
.next1:ADDI.L    #Couleurs_Rasters,D2 
      MOVE.L    D2,(A2)+
      ADDI.L    #generate_Courbe,D3 
      MOVE.L    D3,(A3)+
      SWAP      D4
      DBF       D7,loop_R
      rts 

***************************************************************
*                                                             *
*    SCROLLING 16x16 - ONE BITPLANE - ATOMUS/NOEXTRA-TEAM     *
*                                                             *
***************************************************************
Init_Scroll1p:
      LEA       TEXTEs,A0
      LEA       end_TEXTEs,A1
      SUBA.W    A0,A1 
      MOVE.W    A1,ADR_TEXTE
      ADDQ.W    #1,ADR_TEXTE
      LEA       TEXTEs,A0
.loop:MOVE.B    (A0),D0 
      SUBI.B    #$20,D0 
      MOVE.B    D0,(A0)+
      CMPI.B    #$3B,D0 
      BNE       .loop 
      RTS 

Run_Scroll1p:
      BSR.S     Check
      BSR       ClearPosition
      BSR       PutBuffer
      RTS

Check:CMPI.W    #0,CPT_0
      BNE.S     PutCarac 
      RTS 

PutCarac:
      CMPI.W    #0,CPT_1
      BNE.S     .next 
      MOVE.W    CPT_0(PC),D1
      MOVEq.W   #$10,D2 
      DIVU      D1,D2 
      MOVE.W    D2,CPT_1
      CMPI.W    #1,CPT_2
      BEQ.S     IncCompteur 
      BSR       Vague_1 
.next:SUBI.W    #1,CPT_1
      RTS 
      
IncCompteur:
      BSR       Vague_2 
      SUBI.W    #1,CPT_1
      RTS 

Vague_1:LEA       TEXTEs,A0
      LEA       FONTE,A1
      LEA       POSITION,A2
      MOVE.W    CARAC(PC),D0
      SUBI.W    #$17,D0 
      MOVEQ     #0,D1 
      MOVE.B    0(A0,D0.W),D1 
      CMPI.W    #0,CARAC
      BNE.S     .next 
      MOVE.W    ADR_TEXTE,CARAC 
.next:SUBQ.W    #1,CARAC
      ADD.W     D1,D1
      ADD.W     D1,D1
      MOVEA.L   0(A1,D1.W),A3 
      MOVE.W    (A3),(A2) 
      MOVE.W    160(A3),164(A2) 
      MOVE.W    320(A3),328(A2) 
      MOVE.W    480(A3),492(A2) 
      MOVE.W    640(A3),656(A2) 
      MOVE.W    800(A3),820(A2) 
      MOVE.W    960(A3),984(A2) 
      MOVE.W    1120(A3),1148(A2) 
      MOVE.W    1280(A3),1312(A2) 
      MOVE.W    1440(A3),1476(A2) 
      MOVE.W    1600(A3),1640(A2) 
      MOVE.W    1760(A3),1804(A2) 
      MOVE.W    1920(A3),1968(A2) 
      MOVE.W    2080(A3),2132(A2) 
      MOVE.W    2240(A3),2296(A2) 
      MOVE.W    2400(A3),2460(A2) 
      RTS 
      
Vague_2:LEA       TEXTEs,A0
      LEA       FONTE,A1
      LEA       POSITION,A2
.raz: MOVE.W    CARAC(PC),D0
      MOVEQ     #0,D1 
      MOVE.B    0(A0,D0.W),D1 
      CMPI.B    #$3B,D1 
      BNE.s     .next 
      CLR.W     CARAC 
      BRA.s     .raz 
.next:ADDQ.W    #1,CARAC
      ADD.W     D1,D1
      ADD.W     D1,D1    
      MOVEA.L   0(A1,D1.W),A3 
      LEA       162(A2),A2
      MOVE.W    (A3),(A2) 
      MOVE.W    160(A3),164(A2) 
      MOVE.W    320(A3),328(A2) 
      MOVE.W    480(A3),492(A2) 
      MOVE.W    640(A3),656(A2) 
      MOVE.W    800(A3),820(A2) 
      MOVE.W    960(A3),984(A2) 
      MOVE.W    1120(A3),1148(A2) 
      MOVE.W    1280(A3),1312(A2) 
      MOVE.W    1440(A3),1476(A2) 
      MOVE.W    1600(A3),1640(A2) 
      MOVE.W    1760(A3),1804(A2) 
      MOVE.W    1920(A3),1968(A2) 
      MOVE.W    2080(A3),2132(A2) 
      MOVE.W    2240(A3),2296(A2) 
      MOVE.W    2400(A3),2460(A2) 
      RTS 
      
PutBuffer:
      CMPI.W    #8,CPT_0
      BEQ       ScrollText 
      LEA       BUFFER,A0
      MOVEQ     #$F,D0
      MOVE.W    CPT_0(PC),D2
.loop:MOVE.W    0(A0),D1
      SWAP      D1
      MOVE.W    -2(A0),D1 
      ROL.L     D2,D1 
      MOVE.W    D1,-2(A0) 
i set 8
j set 0
 rept 20
      MOVE.W    i(A0),D1
      SWAP      D1
      MOVE.W    j(A0),D1
      ROL.L     D2,D1 
      MOVE.W    D1,j(A0)
i set i+8
j set j+8
 endr
      MOVE.W    160(A0),D1
      ROL.L     D2,D1 
      MOVE.W    D1,160(A0)
      LEA       164(A0),A0
      DBF       D0,.loop
      RTS 

ScrollText:
      LEA       BUFFER,A0
      MOVEQ     #$F,D0
.loop:MOVE.B    -1(A0),-2(A0) 
      MOVE.B    0(A0),-1(A0)
      MOVE.B    1(A0),0(A0) 
      MOVE.B    8(A0),1(A0) 
      MOVE.B    9(A0),8(A0) 
      MOVE.B    16(A0),9(A0)
      MOVE.B    17(A0),16(A0) 
      MOVE.B    24(A0),17(A0) 
      MOVE.B    25(A0),24(A0) 
      MOVE.B    32(A0),25(A0) 
      MOVE.B    33(A0),32(A0) 
      MOVE.B    40(A0),33(A0) 
      MOVE.B    41(A0),40(A0) 
      MOVE.B    48(A0),41(A0) 
      MOVE.B    49(A0),48(A0) 
      MOVE.B    56(A0),49(A0) 
      MOVE.B    57(A0),56(A0) 
      MOVE.B    64(A0),57(A0) 
      MOVE.B    65(A0),64(A0) 
      MOVE.B    72(A0),65(A0) 
      MOVE.B    73(A0),72(A0) 
      MOVE.B    80(A0),73(A0) 
      MOVE.B    81(A0),80(A0) 
      MOVE.B    88(A0),81(A0) 
      MOVE.B    89(A0),88(A0) 
      MOVE.B    96(A0),89(A0) 
      MOVE.B    97(A0),96(A0) 
      MOVE.B    104(A0),97(A0)
      MOVE.B    105(A0),104(A0) 
      MOVE.B    112(A0),105(A0) 
      MOVE.B    113(A0),112(A0) 
      MOVE.B    120(A0),113(A0) 
      MOVE.B    121(A0),120(A0) 
      MOVE.B    128(A0),121(A0) 
      MOVE.B    129(A0),128(A0) 
      MOVE.B    136(A0),129(A0) 
      MOVE.B    137(A0),136(A0) 
      MOVE.B    144(A0),137(A0) 
      MOVE.B    145(A0),144(A0) 
      MOVE.B    152(A0),145(A0) 
      MOVE.B    153(A0),152(A0) 
      MOVE.B    160(A0),153(A0) 
      MOVE.B    161(A0),160(A0) 
      LEA       164(A0),A0
      DBF       D0,.loop
      RTS 

ClearPosition:
      MOVEA.L   PTR_COURBE,A4
      LEA       4(A4),A4
      CMPI.W    #$FFFF,(A4) 
      BNE.S     .next 
      LEA       COURBE_SCROLLY,A4
.next:MOVE.L    A4,PTR_COURBE
      MOVEA.L   physique(pc),A3
      LEA       160*178+4(A3),A3
      LEA       POSITION,A2
      MOVEQ     #$13,D0 
      MOVEQ     #0,D6 
.loop:LEA       0(A3,D6.W),A1 
      MOVEA.L   A1,A5 
      LEA       1(A5),A5
      ADDA.W    (A4)+,A1
      CMPI.W    #$FFFF,(A4) 
      BNE.S     .suivant 
      LEA       COURBE_SCROLLY,A4
.suivant:ADDA.W    (A4)+,A5
      CLR.B     0(A1) 
      CLR.B     0(A5) 
      CLR.B     160(A1) 
      CLR.B     160(A5) 
      CLR.B     320(A1) 
      CLR.B     320(A5) 
      CLR.B     480(A1) 
      CLR.B     480(A5) 
      CLR.B     640(A1) 
      CLR.B     640(A5) 
      CLR.B     800(A1) 
      CLR.B     800(A5) 
      MOVE.B    2(A2),960(A1) 
      MOVE.B    3(A2),960(A5) 
      MOVE.B    166(A2),1120(A1)
      MOVE.B    167(A2),1120(A5)
      MOVE.B    330(A2),1280(A1)
      MOVE.B    331(A2),1280(A5)
      MOVE.B    494(A2),1440(A1)
      MOVE.B    495(A2),1440(A5)
      MOVE.B    658(A2),1600(A1)
      MOVE.B    659(A2),1600(A5)
      MOVE.B    822(A2),1760(A1)
      MOVE.B    823(A2),1760(A5)
      MOVE.B    986(A2),1920(A1)
      MOVE.B    987(A2),1920(A5)
      MOVE.B    1150(A2),2080(A1) 
      MOVE.B    1151(A2),2080(A5) 
      MOVE.B    1314(A2),2240(A1) 
      MOVE.B    1315(A2),2240(A5) 
      MOVE.B    1478(A2),2400(A1) 
      MOVE.B    1479(A2),2400(A5) 
      MOVE.B    1642(A2),2560(A1) 
      MOVE.B    1643(A2),2560(A5) 
      MOVE.B    1806(A2),2720(A1) 
      MOVE.B    1807(A2),2720(A5) 
      MOVE.B    1970(A2),2880(A1) 
      MOVE.B    1971(A2),2880(A5) 
      MOVE.B    2134(A2),3040(A1) 
      MOVE.B    2135(A2),3040(A5) 
      MOVE.B    2298(A2),3200(A1) 
      MOVE.B    2299(A2),3200(A5) 
      MOVE.B    2462(A2),3360(A1) 
      MOVE.B    2463(A2),3360(A5) 
      MOVE.B    2626(A2),3520(A1) 
      MOVE.B    2627(A2),3520(A5) 
      CLR.B     3680(A1)
      CLR.B     3680(A5)
      CLR.B     3840(A1)
      CLR.B     3840(A5)
      CLR.B     4000(A1)
      CLR.B     4000(A5)
      CLR.B     4160(A1)
      CLR.B     4160(A5)
      CLR.B     4320(A1)
      CLR.B     4320(A5)
      LEA       8(A2),A2
      ADDQ.W    #8,D6 
      DBF       D0,.loop
      RTS 

***************************************************************
*                                                             *
*        GENERATED DISPLAY CLOUD - ZORRO2/NOEXTRA-TEAM        *
*                                                             *
***************************************************************
init_Nuages:
	move.l	physique+4,buffer_screen    ; buffer from/to for shift

; Nuages #1 HAUT
HEIGHT_Nuages_Haut EQU 16

	bsr	efface_Nuages

	movea.l	buffer_screen,a1
	movea.l	#NUAGE_Img,a0
	move.l	#160*HEIGHT_Nuages_Haut/4-1,d0
	move.l	(a0)+,(a1)+
	dbf	d0,*-2

  lea	Buffer_Nuages_Haut,a4           ; buffer de la nuage to shift
	move.w	#HEIGHT_Nuages_Haut,nb_ligne ; nombre de ligne de nuage to shift

	bsr	preshift_Nuages

; Nuages #2 MILIEU
HEIGHT_Nuages_Milieu EQU 13

	bsr	efface_Nuages

	movea.l	buffer_screen,a1
	movea.l	#NUAGE_Img+(160*HEIGHT_Nuages_Haut),a0
	move.l	#160*HEIGHT_Nuages_Milieu/4-1,d0
	move.l	(a0)+,(a1)+
	dbf	d0,*-2

  lea	Buffer_Nuages_Milieu,a4           ; buffer de la nuage to shift
	move.w	#HEIGHT_Nuages_Milieu,nb_ligne ; nombre de ligne de nuage to shift

	bsr	preshift_Nuages

; Nuages #3 BAS
HEIGHT_Nuages_Bas EQU 11

	bsr	efface_Nuages

	movea.l	buffer_screen,a1
	movea.l	#NUAGE_Img+(160*HEIGHT_Nuages_Haut)+(160*HEIGHT_Nuages_Milieu),a0
	move.l	#160*HEIGHT_Nuages_Bas/4-1,d0
	move.l	(a0)+,(a1)+
	dbf	d0,*-2

  lea	Buffer_Nuages_Bas,a4           ; buffer de la nuage to shift
	move.w	#HEIGHT_Nuages_Bas,nb_ligne ; nombre de ligne de nuage to shift

	bsr	preshift_Nuages

	bsr	efface_Nuages
	rts

efface_Nuages:
	move.l	physique(pc),a0          ;
	move.l	physique+4(pc),a1        ;
	move.w  #(160*HEIGHT_Nuages_Haut)/4-1,d7         ;
	move.l  #0,(a0)+                 ;
	move.l  #0,(a1)+                 ;
	dbf	    d7,*-12                  ;
	rts

preshift_Nuages:
  MOVEQ     #16-1,D7
to_shift:
  BSR       copy_Screen 
  MOVEA.L   buffer_screen,A0
  MOVE.w    nb_ligne,D6 
twice:
  MOVEQ     #1,D5 
.roxl:
  MOVE.W    (A0),D0 
  ADDX.W    D0,D0 
  ROXL      72(A0)
  ROXL      64(A0)
  ROXL      56(A0)
  ROXL      48(A0)
  ROXL      40(A0)
  ROXL      32(A0)
  ROXL      24(A0)
  ROXL      16(A0)
  ROXL      8(A0) 
  ROXL      (A0)+ 
  DBF       D5,.roxl
  LEA       156(A0),A0
  DBF       D6,twice
  DBF       D7,to_shift
  rts 

copy_Screen:
  MOVEM.L   A0/D6-D7,-(A7)
  MOVEA.L   buffer_screen,A0
  MOVE.w    nb_ligne,D7 
.to_shift:
  MOVEQ     #9,D6 
.loop:
  MOVE.L    (A0)+,(A4)+ 
  ADDQ.W    #4,A0 
  DBF       D6,.loop
  LEA       80(A0),A0 
  DBF       D7,.to_shift
  MOVEM.L   (A7)+,A0/D6-D7
  rts 

Display_Nuages:
  movea.l	physique,a4
  lea	160*128(a4),a4
  lea	Buffer_Nuages_Haut,a5
	bsr	Move_Nuages_Haut

  movea.l	physique,a4
  lea	160*160(a4),a4
  lea	Buffer_Nuages_Milieu,a5
	bsr	Move_Nuages_Milieu

  movea.l	physique,a4
  lea	160*188(a4),a4
  lea	Buffer_Nuages_Bas,a5
	bsr	Move_Nuages_Bas

	sub.w	#2,deplacement_Nuages_Haut
	sub.w	#4,deplacement_Nuages_Milieu
	sub.w	#6,deplacement_Nuages_Bas
	rts

Move_Nuages_Haut:
  MOVE.W   deplacement_Nuages_Haut,D0
  NEG.L     D0
  LSR.L     #2,D0 
  EXT.L     D0
  BPL.S     .its_ok 
.inc:
  ADDI.L    #(HEIGHT_Nuages_Haut+1)*160*2,D0
  BMI.S     .inc 
.its_ok:
  DIVS      #160,D0 
  CLR.W     D0
  SWAP      D0
  MOVE.W    D0,D1 
  ANDI.W    #$F,D0
  MULU      #40*(HEIGHT_Nuages_Haut+1),D0
  ADDA.L    D0,A5 
  LSR.W     #4,D1 
  ADD.W     D1,D1 
  ADD.W     D1,D1 
  LEA       genere_Mouvements_Montagnes,A0
  MOVE.L    0(A0,D1.W),D1 
  LEA       adressA,A0
 rept HEIGHT_Nuages_Haut+1
  MOVE.L    D1,(A0)+
  ADDQ.W    #6,A0 
 endr
  MOVEM.W   clean_Buffer,A3/A1/D7/D5/D3/D1 
  JSR       0.L 
adressA EQU *-4 
 rept HEIGHT_Nuages_Haut ; nombre de lignes
  LEA       160(A4),A4
  JSR       0.L 
 endr
  rts 

Move_Nuages_Milieu:
  MOVE.W   deplacement_Nuages_Milieu,D0
  NEG.L     D0
  LSR.L     #2,D0 
  EXT.L     D0
  BPL.S     .its_ok 
.inc:
  ADDI.L    #(HEIGHT_Nuages_Milieu+1)*160*2,D0
  BMI.S     .inc 
.its_ok:
  DIVS      #160,D0 
  CLR.W     D0
  SWAP      D0
  MOVE.W    D0,D1 
  ANDI.W    #$F,D0
  MULU      #40*(HEIGHT_Nuages_Milieu+1),D0
  ADDA.L    D0,A5 
  LSR.W     #4,D1 
  ADD.W     D1,D1 
  ADD.W     D1,D1 
  LEA       genere_Mouvements_Montagnes,A0
  MOVE.L    0(A0,D1.W),D1 
  LEA       adressB,A0
 rept HEIGHT_Nuages_Milieu+1
  MOVE.L    D1,(A0)+
  ADDQ.W    #6,A0 
 endr
  MOVEM.W   clean_Buffer,A3/A1/D7/D5/D3/D1 
  JSR       0.L 
adressB EQU *-4 
 rept HEIGHT_Nuages_Milieu ; nombre de lignes
  LEA       160(A4),A4
  JSR       0.L 
 endr
  rts 

Move_Nuages_Bas:
  MOVE.W   deplacement_Nuages_Bas,D0
  NEG.L     D0
  LSR.L     #2,D0 
  EXT.L     D0
  BPL.S     .its_ok 
.inc:
  ADDI.L    #(HEIGHT_Nuages_Bas+1)*160*2,D0
  BMI.S     .inc 
.its_ok:
  DIVS      #160,D0 
  CLR.W     D0
  SWAP      D0
  MOVE.W    D0,D1 
  ANDI.W    #$F,D0
  MULU      #40*(HEIGHT_Nuages_Bas+1),D0
  ADDA.L    D0,A5 
  LSR.W     #4,D1 
  ADD.W     D1,D1 
  ADD.W     D1,D1 
  LEA       genere_Mouvements_Montagnes,A0
  MOVE.L    0(A0,D1.W),D1 
  LEA       adressC,A0
 rept HEIGHT_Nuages_Bas+1
  MOVE.L    D1,(A0)+
  ADDQ.W    #6,A0 
 endr
  MOVEM.W   clean_Buffer,A3/A1/D7/D5/D3/D1 
  JSR       0.L 
adressC EQU *-4 
 rept HEIGHT_Nuages_Bas ; nombre de lignes
  LEA       160(A4),A4
  JSR       0.L 
 endr
  rts 

genere_Mouvements_Montagnes:
	dc.l	generation_01 
	dc.l	generation_02 
	dc.l	generation_03 
	dc.l	generation_04 
	dc.l	generation_05 
	dc.l	generation_06 
	dc.l	generation_07 
	dc.l	generation_08 
	dc.l	generation_09 
	dc.l	generation_10 

generation_01:
  MOVEM.L   (A5)+,A2/A0/D6/D4/D2/D0 
  MOVEM.L   A0-A3/D0-D7,(A4)
  MOVEM.L   A0-A3/D0-D7,80(A4)
  MOVEM.L   (A5)+,D6/D4/D2/D0 
  MOVEM.L   D0-D7,48(A4)
  MOVEM.L   D0-D7,128(A4) 
  RTS 
generation_02:
  MOVEM.L   (A5)+,A2/A0/D6/D4/D2/D0 
  MOVEM.L   A0-A3/D2-D7,(A4)
  MOVEM.L   D0-D1,72(A4)
  MOVEM.L   A0-A3/D2-D7,80(A4)
  MOVEM.L   D0-D1,152(A4) 
  MOVEM.L   (A5)+,D6/D4/D2/D0 
  MOVEM.L   D0-D7,40(A4)
  MOVEM.L   D0-D7,120(A4) 
  RTS 
generation_03:
  MOVEM.L   (A5)+,A2/A0/D6/D4/D2/D0 
  MOVEM.L   A0-A3/D4-D7,(A4)
  MOVEM.L   D0-D3,64(A4)
  MOVEM.L   A0-A3/D4-D7,80(A4)
  MOVEM.L   D0-D3,144(A4) 
  MOVEM.L   (A5)+,D6/D4/D2/D0 
  MOVEM.L   D0-D7,32(A4)
  MOVEM.L   D0-D7,112(A4) 
  RTS 
generation_04:
  MOVEM.L   (A5)+,A2/A0/D6/D4/D2/D0 
  MOVEM.L   A0-A3/D6-D7,(A4)
  MOVEM.L   D0-D5,56(A4)
  MOVEM.L   A0-A3/D6-D7,80(A4)
  MOVEM.L   D0-D5,136(A4) 
  MOVEM.L   (A5)+,D6/D4/D2/D0 
  MOVEM.L   D0-D7,24(A4)
  MOVEM.L   D0-D7,104(A4) 
  RTS 
generation_05:
  MOVEM.L   (A5)+,A2/A0/D6/D4/D2/D0 
  MOVEM.L   A0-A3,(A4)
  MOVEM.L   D0-D7,48(A4)
  MOVEM.L   A0-A3,80(A4)
  MOVEM.L   D0-D7,128(A4) 
  MOVEM.L   (A5)+,D6/D4/D2/D0 
  MOVEM.L   D0-D7,16(A4)
  MOVEM.L   D0-D7,96(A4)
  RTS 
generation_06:
  MOVEM.L   (A5)+,A2/A0/D6/D4/D2/D0 
  MOVEM.L   A2-A3,(A4)
  MOVEM.L   A0-A1/D0-D7,40(A4)
  MOVEM.L   A2-A3,80(A4)
  MOVEM.L   A0-A1/D0-D7,120(A4) 
  MOVEM.L   (A5)+,D6/D4/D2/D0 
  MOVEM.L   D0-D7,8(A4) 
  MOVEM.L   D0-D7,88(A4)
  RTS 
generation_07:
  MOVEM.L   (A5)+,A2/A0/D6/D4/D2/D0 
  MOVEM.L   A0-A3/D0-D7,32(A4)
  MOVEM.L   A0-A3/D0-D7,112(A4) 
  MOVEM.L   (A5)+,D6/D4/D2/D0 
  MOVEM.L   D0-D7,(A4)
  MOVEM.L   D0-D7,80(A4)
  RTS 
generation_08:
  MOVEM.L   (A5)+,A2/A0/D6/D4/D2/D0 
  MOVEM.L   A0-A3/D0-D7,24(A4)
  MOVEM.L   A0-A3/D0-D7,104(A4) 
  MOVEM.L   (A5)+,D6/D4/D2/D0 
  MOVEM.L   D2-D7,(A4)
  MOVEM.L   D0-D1,72(A4)
  MOVEM.L   D2-D7,80(A4)
  MOVEM.L   D0-D1,152(A4) 
  RTS 
generation_09:
  MOVEM.L   (A5)+,A2/A0/D6/D4/D2/D0 
  MOVEM.L   A0-A3/D0-D7,16(A4)
  MOVEM.L   A0-A3/D0-D7,96(A4)
  MOVEM.L   (A5)+,D6/D4/D2/D0 
  MOVEM.L   D4-D7,(A4)
  MOVEM.L   D0-D3,64(A4)
  MOVEM.L   D4-D7,80(A4)
  MOVEM.L   D0-D3,144(A4) 
  RTS 
generation_10:
  MOVEM.L   (A5)+,A2/A0/D6/D4/D2/D0 
  MOVEM.L   A0-A3/D0-D7,8(A4) 
  MOVEM.L   A0-A3/D0-D7,88(A4)
  MOVEM.L   (A5)+,D6/D4/D2/D0 
  MOVEM.L   D6-D7,(A4)
  MOVEM.L   D0-D5,56(A4)
  MOVEM.L   D6-D7,80(A4)
  MOVEM.L   D0-D5,136(A4) 
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

********* TEXTE ***********************************>>>
message:
*       +                                       +
	dc.b	" IMAGINA............THE BIG SPRITE DEMO",0
	dc.b	" MOODST/AL.........DCK PACIDEMO CONTEST",0
	dc.b	" C-REM/MJJ..............DCK SCREEN INFO",0
	dc.b	" MR NOURS/MJJ......DCK PACIDEMO CONTEST",0
	dc.b	" EQUINOX......................DMC INTRO",0
	dc.b	" THE INVISIBLES........VERMINATOR INTRO",0
	dc.b	" THE JACOB'S.....CHAMPION MANAGER INTRO",0
	dc.b	" RADIATION.........DOMPUB COMPILATION 4",0
	dc.b	" STRIDER/MJJ.......DCK PACIDEMO CONTEST",0
	dc.b	" AVENGERS..............HAPPY HALLOWEEN!",0
	dc.b	" DMA................1ST VECTORBALL DEMO",0
	dc.b	" CYG/BLABLA................ZOVOGMA DEMO",$ff
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
	incbin 	"BOBBLE.DAT"            ; Special RAZOR 1991 by M.A 
	EVEN
********* TEXTE ***********************************<<<

Couleurs_Rasters:
	dc.w	$300,$410,$520,$630,$740,$630,$520,$410,$300 * orange
	dc.w	$320,$430,$540,$650,$760,$650,$540,$430,$320 * jaune
	dc.w	$032,$043,$054,$065,$076,$065,$054,$043,$032 * vert 1
	dc.w	$013,$024,$035,$046,$057,$046,$035,$024,$013 * bleu claire
	dc.w	$003,$004,$005,$006,$007,$006,$005,$004,$003 * bleu fonce
	dc.w	$103,$204,$305,$406,$507,$406,$305,$204,$103 * violet fonce
	dc.w	$302,$403,$504,$605,$706,$605,$504,$403,$302 * violet claire
DATA_Generate:
	incbin	"GENPLASM.DAT"
	even
Repeat_R0:
 rept 150*(NUMBER/2)
	dc.l	Couleurs_Rasters 
 endr
Repeat_R1:
 rept 150*NUMBER
	dc.l	generate_Courbe 
 endr
ptr_Courbe:
	dc.l	Courbe
Courbe:
	incbin	"COURBEP.DAT"
	even
end_Courbe:
generate_Courbe:
.1
	dcb.w	3,$4E71
	dcb.w	36,$309B	;	MOVE.W	(A3)+,(A0)
	dc.w	$4E75
.2
	dcb.w	2,$4E71
	dcb.w	36,$309B	;	MOVE.W	(A3)+,(A0)
	dc.w	$4E71
	dc.w	$4E75
.3
	dc.w	$4E71
	dcb.w	36,$309B	;	MOVE.W	(A3)+,(A0)
	dcb.w	2,$4E71
	dc.w	$4E75
	even

CARAC:
	DC.W	$0
CPT_1:
	DC.W	$0
CPT_3:
	DC.W	$0
ADR_TEXTE:
	DC.W	$0
CPT_2:
	DC.W	$1 
CPT_0:
	DC.W	$4 
PTR_COURBE:
	DC.L	COURBE_SCROLLY 
COURBE_SCROLLY:
	incbin	"COURBE_S.DAT"
	even
FONTEs:
	include	"FONTE.S"
TEXTEs:
* ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789 !(),.:-?'
	dc.b	"                          "
	dc.b	" NOEXTRA-TEAM ARE PROUD TO PRESENT THE COMPILATION EXTRA VOLUME NUMBER SIX"
	dc.b	" WITH ANOTHER UNSEEN RELEASES ON ATARI ST AT THE ALCHIMIE 2015 EVENT IN FRANCE ."
	dc.b	"                          "
	dc.b	" SPECIAL SCROLLTEXTS BY MJJPROD MEMBERS TAKEN BY YOGI AT THIS PARTY :"

	dc.b	"                          "
; Mr Nours
	dc.b	" HI ALL HERE'S  MR NOURS FROM MJJ PROD WRITING SOME CRAPPY SCROLLTEXT ."
	dc.b	" MY DCK SCREEN WAS MADE YEARS AGO BEFORE I HAD LEARN ANY 68K ASM ."
	dc.b	" THANKS TO NOEXTRA TO DIG THIS PRG OUT ! AS USUAL I WOULD GREETS ALL THE DYING"
	dc.b	" ATARI DEMOSCENE AND STATE THAT MJJ WOULD SUCKS FOR FREE ( PLEASE SEE C-REM ABOUT THAT ... )"
	dc.b	" HEY BOSS , PLEASE COME BACK WE NEED YOU BADLY !"
	dc.b	"                          "
; Strider
	dc.b	" FROM ALCHIMIE OXB PARTY , HERE IS STRIDER ON THE KEYBOARD ."
	dc.b	" GREETINGS TO DHS , SECTOR ONE , DUNE , NO EXTRA , POPSY TEAM , TSCC , LAMERS , HMD , LIVE! , RNO , CHECKPOINT , EXCELLENCE IN ART ,"
	dc.b	" GENESIS PROJECT , CEREBRAL VORTEX , MYSTIC BYTES AND TO ALL THE ATARI DEMO SCENE ."
	dc.b	" KEEP THE ST ALIVE !"
	dc.b	"                          "

	dc.b	" INFORMATIONS : MENU CODED BY ZORRO 2 - GRAPHISM BY MISTER.A - MUSIC BY TOMCHI"
	dc.b	"            AND           LOADER CODED BY MAARTAU AND ZORRO 2 - GRAPHISM HYLST"
	dc.b	"                          "
	dc.b	" SPECIAL THANKS TO BRUME , CYG AKA GRAF7 :) , MOODST AND MJJPROD MEMBERS SPECIALLY C-REM , MR NOURS AND STRIDER ."
	dc.b	"                          "
	dc.b	" THIS MEGA COMPILATION HAS BEEN FINISHED THE 27 NOVEMBER 2015 ............"
	dc.b	"...................LET'S WRAP AGAIN AND AGAIN ............................"
	dc.b	"                          "
end_TEXTEs:
	dc.w	$5b00
	ds.b	1000
	even
***
LOGO_EXTRA_Palette:
	dc.w	$0882,$0012,$0123,$0234,$0345,$0456,$0567,$0777
LOGO_EXTRA_Img:
	incbin	"EXTRAV24.IMG"	;	Logo 320*74
	even
*
BACKGROUND_Palette:
	dc.w	$0B55,$0CBA,$0229,$0349,$05C3,$0AA2,$0B32,$0231
	dc.w	$0AB1,$0B32,$09A8,$0654,$03A9,$0FEC,$0332,$0B32
BACKGROUND_Img:
	incbin	"SOL.IMG"	;	Logo 320*48
	even
*
NUAGE_Palette:
	dc.w	$0B55,$0CDD,$045D,$056E,$0335,$0CDD,$045D,$056E
	dc.w	$0FFF,$0FFF,$0FFF,$0FFF,$0FFF,$0FFF,$0FFF,$0FFF
NUAGE_Img:
	incbin	"NUAGES-B.IMG"	; Logo 320*85
	even
* <

MUSIC:	* SNDH music -> Not compressed please !!!
	incbin	"1STEXTRA.THK"
	even

***************************************************************
 SECTION	BSS                                              // *
***************************************************************

bss_start:

* < Full data here >
Buffer_Texte:
	ds.b	160*145
*
POSITION:
	DS.W	1 
BUFFER:
	DS.B	4918
*
Buffer_Nuages_Haut:
	ds.b	160*(HEIGHT_Nuages_Haut+15*4)
Buffer_Nuages_Milieu:
	ds.b	160*(HEIGHT_Nuages_Milieu+15*4)
Buffer_Nuages_Bas:
	ds.b	160*(HEIGHT_Nuages_Bas+15*4)

clean_Buffer:
	ds.b	64

deplacement_Nuages_Haut:
	ds.w	1
deplacement_Nuages_Milieu:
	ds.w	1
deplacement_Nuages_Bas:
	ds.w	1

nb_ligne:
	ds.w	1
buffer_screen:
	ds.l	1
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
