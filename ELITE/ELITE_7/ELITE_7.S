***************************************
* // ELITE_7.PRG                  // *
***************************************
* // Asm Intro Code Atari ST v0.42 // *
* // by Zorro 2/NoExtra (05/12/11) // *
* // http://www.noextra-team.com/  // *
***************************************
* // Original code : Zorro 2       // *
* // Gfx logo      : n/a           // *
* // Gfx font      : Mister.A      // *
* // Music         : Mad Max       // *
* // Release date  : 27/01/2014    // *
* // Update date   : 17/02/2014    // *
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
FADE_INTRO       equ 0         ; Fade White to black palette       *
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
	bsr	display_cubes

	bsr cls_ecran ; effacement du buffer du cube

	bsr anim_rotation ; animation des angles 
		;rotation de tous les points
	bsr rotation
		; remplissage de tout les faces (ext:ligne...)
	bsr remplissage

	bsr	mscroll	;	scrolling....
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

	cmp.b	#$39,$fffffc02.w           ; SPACE key pressed ?
	bne	default_loop

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
	clr.w	$ffff8240.w                ; Set black background
	ENDC
*
	bsr init_buffer                  ; Inits 3D
	bsr Init_Trame
	bsr init_offset_buffer

	bsr	print_text                   ; Affiche le texte

	jsr	init_line_rout               ; Dessine les lignes
	jsr	put_squares

	bsr	init_mscroll
*
	moveq	#5,d0                      ; Choice of the music (1 is default)
	jsr	MUSIC+0                      ; Init SNDH music

	lea	Vbl(pc),a0                   ; Launch VBL
	move.l	a0,$70.w                 ;

	lea	Default_palette,a0           ; Put palette
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
SIZE_OF_SCREEN equ 160*250        ; Screen + Lower Border size
 ENDC
 IFEQ	TOPBOTTOM_BORDER
SIZE_OF_SCREEN equ 160*300        ; Screen + Top & Lower Border size
 ENDC
 IFEQ	NO_BORDER
SIZE_OF_SCREEN equ 160*200        ; Only Screen size
 ENDC

Init_screens:
	movem.l	d0-d7/a0-a6,-(a7)

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
Vbl:	st	Vsync                    ; Synchronisation

	IFEQ	BOTTOM_BORDER
	clr.b   $fffffa1b.w              ; Disable timer B
	lea	Over_rout(pc),a0             ; HBL
	move.l	a0,$120.w                ; Timer B vector
	move.b	#199,$fffffa21.w         ; At the position
	move.b	#8,$fffffa1b.w           ; Launch HBL
	ENDC

	IFEQ	TOPBOTTOM_BORDER
      MOVE.L    D0,-(A7) 
      MOVE      SR,-(A7)
      MOVE      #$2700,SR 
      MOVE.L    #$592-1,D0		* 1426
.rien:DBF       D0,.rien
      MOVE.B    #0,$FFFF820A.W
      MOVEQ     #4,D0 
.null:DBF       D0,.null
      MOVE.B    #2,$FFFF820A.W
      MOVE      (A7)+,SR
      MOVE.L    (A7)+,D0 
      CLR.B     $FFFFFA1B.W 
      MOVE.B    #54,$FFFFFA21.W
      MOVE.L    #HBL_carre1,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
	ENDC

	IFEQ	NO_BORDER
* // Declarations here ...
	ENDC

	movem.l	d0-d7/a0-a6,-(a7)
	jsr 	(MUSIC+8)                  ; Play SNDH music
	movem.l	(a7)+,d0-d7/a0-a6
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
HBL_carre1:
  move.l	a0,-(a7)
  move.l	a1,-(a7)
	MOVE.L    #PAL_ETAGE1,A0
  LEA       $FFFF8240.W,A1
  MOVE.W    (A0)+,8(A1)	*	color 8
  MOVE.W    (A0)+,16(A1)	*	color 16
  MOVE.W    (A0)+,24(A1)	*	color 24
  move.l	(a7)+,a1
  move.l	(a7)+,a0

	CLR.B     $FFFFFA1B.W 
	MOVE.B    #54,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W
	MOVE.L    #HBL_carre2,$120.W
	RTE 

HBL_carre2:
  move.l	a0,-(a7)
  move.l	a1,-(a7)
	MOVE.L    #PAL_ETAGE2,A0
  LEA       $FFFF8240.W,A1
  MOVE.W    (A0)+,8(A1)	*	color 8
  MOVE.W    (A0)+,16(A1)	*	color 16
  MOVE.W    (A0)+,24(A1)	*	color 24
  move.l	(a7)+,a1
  move.l	(a7)+,a0

	CLR.B     $FFFFFA1B.W 
	MOVE.B    #54,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W
	MOVE.L    #HBL_carre3,$120.W
	RTE 

HBL_carre3:
  move.l	a0,-(a7)
  move.l	a1,-(a7)
	MOVE.L    #PAL_ETAGE3,A0
  LEA       $FFFF8240.W,A1
  MOVE.W    (A0)+,8(A1)	*	color 8
  MOVE.W    (A0)+,16(A1)	*	color 16
  MOVE.W    (A0)+,24(A1)	*	color 24
  move.l	(a7)+,a1
  move.l	(a7)+,a0

	CLR.B     $FFFFFA1B.W 
	MOVE.B    #54-1,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W
	MOVE.L    #HBL_carre4,$120.W
	RTE 

HBL_carre4:
  move.l	a0,-(a7)
  move.l	a1,-(a7)
	MOVE.L    #PAL_ETAGE4,A0
  LEA       $FFFF8240.W,A1
  MOVE.W    (A0)+,8(A1)	*	color 8
  MOVE.W    (A0)+,16(A1)	*	color 16
  MOVE.W    (A0)+,24(A1)	*	color 24
  move.l	(a7)+,a1
  move.l	(a7)+,a0

	CLR.B     $FFFFFA1B.W 
	MOVE.B    #12+1,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W
	MOVE.L    #HBL_finale,$120.W
	RTE 

HBL_finale:
	CLR.B     $FFFFFA1B.W 
	MOVEM.L   A0/D0,-(A7) 
	MOVEA.W   #$FA21,A0 
	MOVE.B    #$28,(A0) 
	MOVE.L    #hblfin,$120.W 
	MOVE.B    #8,$FFFFFA1B.W
	MOVE.B    (A0),D0 
.wait:
	CMP.B     (A0),D0 
	BEQ       .wait 
	CLR.B     $FFFF820A.W 
	MOVEQ     #2,D0 
.att:
	NOP 
	DBF       D0,.att
	MOVE.B    #2,$FFFF820A.W
	MOVEM.L   (A7)+,A0/D0 
	BCLR      #0,$FFFFFA0F.W
	RTE 

hblfin:
  move.l	a0,-(a7)
  move.l	a1,-(a7)
	MOVE.L    #PAL_ETAGE5,A0
  LEA       $FFFF8240.W,A1
  MOVE.W    (A0)+,8(A1)	*	color 8
  MOVE.W    (A0)+,16(A1)	*	color 16
  MOVE.W    (A0)+,24(A1)	*	color 24
  move.l	(a7)+,a1
  move.l	(a7)+,a0

	BCLR      #0,$FFFFFA0F.W
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

	IFEQ	TOPBOTTOM_BORDER
	CLR.B     $FFFFFA07.W 
	CLR.B     $FFFFFA09.W 
	CLR.B     $FFFFFA1B.W 
	ORI.B     #1,$FFFFFA07.W
	ORI.B     #1,$FFFFFA13.W
	ENDC

	IFEQ	NO_BORDER
	clr.b	$fffffa07.w                ; Interrupt enable A (Timer-A & B)
	clr.b	$fffffa09.w                ; Interrupt enable B (Timer-C & D)
	ENDC

	stop	#$2300

	clr.b	$484.w                     ; No bip, no repeat

	move	#4,-(sp)                   ; Save & Change Resolution (GetRez)
	trap	#14	                       ; Get Current Res.
	addq.l	#2,sp                    ;
	move	d0,Old_Resol+2             ; Save it

	move	#3,-(sp)                   ; Save Screen Address (Logical)
	trap	#14
	addq.l	#2,sp
	move.l	d0,Old_Screen+2

	moveq #$11,d0                    ; Resume keyboard
	bsr	sendToKeyboard               ;

	moveq #$12,d0                    ; Kill mouse
	bsr	sendToKeyboard               ;

	bsr	flush                        ; Init keyboard

	sf	$ffff8260.w                  ; Basse resolution if you don't use Multi_boot

	rts

Restore_st:

	moveq #$13,d0                    ; Pause keyboard
	bsr	sendToKeyboard               ;

	move #$2700,sr

	jsr	MUSIC+0                      ; Stop SNDH music

	lea       $ffff8800.w,a0         ; Cut sound
	move.l    #$8000000,(a0)         ; Voice A
	move.l    #$9000000,(a0)         ; Voice B
	move.l    #$a000000,(a0)         ; Voice C

	IFEQ	ERROR_SYS
	jsr	OUTPUT_TRACE_ERROR
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
	clr.w	$ffff8240.w
	rts

wart:	move.l	d0,-(sp)
	move.l	$466.w,d0
.att:	cmp.l	$466.w,d0
	beq.s	.att
	move.l	(sp)+,d0
	rts
	ENDC

***************************************************************
; SUB-ROUTINES                                             // *
***************************************************************

*********************************************************************
*                   TEXTE FONT 8*8 ONE BITPLANE                     *
*********************************************************************
CHARS      equ 40  ; chars per line, 80=for med res, 40 for low res *
LINES      equ 33  ; 33 for 8x8 font, 45 with 6x6 font              *
FONTSIZE   equ 8   ; 8=8x8, 6=6x6 font                              *
SHIFTSIZE  equ 4   ; 2=MED RESOLUTION, 4=LOW RESOLUTION             *
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
                lea     58*160(a0),a0
                adda.w  pointeur_plan,a0
                adda.l  y_offset,a0
                adda.l  x_offset,a0
                
                movea.l physique+4(pc),a3
                lea     58*160(a3),a3
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

*********************************************************************
*                  SMALL SCROLL FONT - 1 BITPLANE                   *
*                          ZORRO 2/NOEXTRA                          *
*********************************************************************
init_mscroll:
	move.l	#mtexte,ptr_mtexte
	rts

mscroll:
	move.w 	pas_car,d0
	cmp.w 	#8,d0
	bne.s 	plusloin3
	clr.w 	pas_car
	move.l 	ptr_mtexte,a1
	move.b 	(a1),d0
	cmp.b 	#255,d0
	bne.s 	lsuite
	move.l 	#mtexte,ptr_mtexte
	move.l 	ptr_mtexte,a1
	move.b 	(a1),d0
lsuite:
	addq.l 	#1,ptr_mtexte
	asl.l 	#3,d0
	lea 	smallfonts,a1
	sub.w	#256,d0
	add.w 	d0,a1
	lea 	buffer_car,a2

i set 0
 rept 8-2
	move.b 	(a1)+,i(a2)	;	Caracter to Buffer
i set i+2
 endr

plusloin3:
	addq.w 	#1,pas_car
	lea 	buffer_mscrol,a1	;	Display buffer + left scroll
	lea 	buffer_car,a2
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
i set i+40
 endr

	move.l 	physique(pc),a1	;	buffer to screen
	add.l	#204*160+2+8*4,a1
	lea 	buffer_mscrol,a2
i set 2
 rept 10-2-2	*	hauteur du scroll
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
	move.w 	(a2)+,d0
	move.w 	(a2)+,d0
	move.w 	(a2)+,d0
	move.w 	(a2)+,d0
	move.w 	(a2)+,d0
	move.w 	(a2)+,d0
	move.w 	(a2)+,d0
	move.w 	(a2)+,d0
i set 	i+160
 endr
	rts

*********************************************************************
*                     3D BUFFERISED - 2 BITPLANES                   *
*                          ZORRO 2/NOEXTRA                          *
*********************************************************************
SIZE     equ 1024 ; Size of the buffer                              *
plancube equ 4    ; bitplane of square                              *
*********************************************************************
Init_Trame
	move.W t1+2,val_tram
	move.W t2+2,val_tram+2
	move.W t3+2,val_tram2
	move.w t4+2,val_tram2+2
	rts

init_buffer:
	lea bigbuf,a0
ret_eff_buf
	move.W #(SIZE/2)-1,d0
eff_buf
	clr.W (a0)+
	dbra d0,eff_buf
	rts

display_cubes:
	move.l 	physique,A1 ; ligne du haut
	bsr	Copie_une_ligne_de_cube

	move.l 	physique(pc),A1 ; carre gauche
	add.l	#54*160,a1
	bsr Copie_un_cube

	move.l 	physique(pc),A1 ; carre gauche
	add.l	#54*2*160,a1
	bsr Copie_un_cube

	move.l 	physique(pc),A1 ; carre gauche
	add.l	#54*3*160,a1
	bsr Copie_un_cube

	move.l 	physique(pc),A1 ; carre droit
	add.l	#54*160+8*16,a1
	bsr Copie_un_cube

	move.l 	physique(pc),A1 ; carre droit
	add.l	#54*2*160+8*16,a1
	bsr Copie_un_cube

	move.l 	physique(pc),A1 ; carre droit
	add.l	#54*3*160+8*16,a1
	bsr Copie_un_cube

	move.l 	physique,A1 ; ligne du bas
	add.l	#215*160,a1
	bsr	Copie_une_ligne_de_cube
	rts

Copie_un_cube:
	LEA	bigbuf+2*48,A0
	add.w	#plancube,a1

I	SET 0
 rept 18 * Hauteur du CUBE !

	movem.L (a0)+,d0-d7/A2-A5

	move.L d0,I(a1)
	move.L d1,I+8(a1)
	move.L d2,I+16(a1)
	move.L d3,I+24(a1)
I	SET I+160
	move.L d4,I(a1)
	move.L d5,I+8(a1)
	move.L d6,I+16(a1)
	move.L d7,I+24(a1)
I	SET I+160
	move.L A2,I(a1)
	move.L A3,I+8(a1)
	move.L A4,I+16(a1)
	move.L A5,I+24(a1)
I	SET I+160
 endr

	rts

Copie_une_ligne_de_cube:
	LEA	bigbuf+2*48,A0
	add.w	#plancube,a1

I	SET 0
 rept 18 * Hauteur du CUBE !

	movem.L (a0)+,d0-d7/A2-A5
	move.l d0,I(a1)
	move.L d1,I+8(a1)
	move.L d2,I+16(a1)
	move.L d3,I+24(a1)
	
	move.l d0,I+32(a1)
	move.L d1,I+8+32(a1)
	move.L d2,I+16+32(a1)
	move.L d3,I+24+32(a1)

	move.l d0,I+32+32(a1)
	move.L d1,I+8+32+32(a1)
	move.L d2,I+16+32+32(a1)
	move.L d3,I+24+32+32(a1)

	move.l d0,I+32+32+32(a1)
	move.L d1,I+8+32+32+32(a1)
	move.L d2,I+16+32+32+32(a1)
	move.L d3,I+24+32+32+32(a1)

	move.l d0,I+32+32+32+32(a1)
	move.L d1,I+8+32+32+32+32(a1)
	move.L d2,I+16+32+32+32+32(a1)
	move.L d3,I+24+32+32+32+32(a1)

I	SET I+160
	move.L d4,I(a1)
	move.L d5,I+8(a1)
	move.L d6,I+16(a1)
	move.L d7,I+24(a1)
	
	move.l d4,I+32(a1)
	move.L d5,I+8+32(a1)
	move.L d6,I+16+32(a1)
	move.L d7,I+24+32(a1)
	
	move.l d4,I+32+32(a1)
	move.L d5,I+8+32+32(a1)
	move.L d6,I+16+32+32(a1)
	move.L d7,I+24+32+32(a1)
	
	move.l d4,I+32+32+32(a1)
	move.L d5,I+8+32+32+32(a1)
	move.L d6,I+16+32+32+32(a1)
	move.L d7,I+24+32+32+32(a1)


	move.l d4,I+32+32+32+32(a1)
	move.L d5,I+8+32+32+32+32(a1)
	move.L d6,I+16+32+32+32+32(a1)
	move.L d7,I+24+32+32+32+32(a1)

I	SET I+160
	move.L A2,I(a1)
	move.L A3,I+8(a1)
	move.L A4,I+16(a1)
	move.L A5,I+24(a1)

	move.l A2,I+32(a1)
	move.L A3,I+8+32(a1)
	move.L A4,I+16+32(a1)
	move.L A5,I+24+32(a1)

	move.l A2,I+32+32(a1)
	move.L A3,I+8+32+32(a1)
	move.L A4,I+16+32+32(a1)
	move.L A5,I+24+32+32(a1)

	move.l A2,I+32+32+32(a1)
	move.L A3,I+8+32+32+32(a1)
	move.L A4,I+16+32+32+32(a1)
	move.L A5,I+24+32+32+32(a1)

	move.l A2,I+32+32+32+32(a1)
	move.L A3,I+8+32+32+32+32(a1)
	move.L A4,I+16+32+32+32+32(a1)
	move.L A5,I+24+32+32+32+32(a1)
I	SET I+160
 endr

	rts

***************************
*** efface_ecran **********	
***************************
cls_ecran
	lea	bigbuf,a0 
	lea SIZE-4*16(a0),a0
	movem.l register(pc),d0-d7/a1-a6
	rept 16
	movem.l d0-d7/a1-a6,-(a0) ;60 octets
	endr
	rts

register
	ds.l 30

ptr_rotation
	dc.l table_rotation

table_rotation
	dc.w 10-8,6,4	; dc.w x,y,z,pt_fuite
	dc.w 2,12,4
	dc.w 6,6-2,2
	dc.w -1

anim_rotation
	move.l ptr_rotation,a0
restart
	move.w (a0)+,d0
	bpl.s cont_t
	lea table_rotation,a0
	move.l a0,ptr_rotation
	bra.s restart
cont_t
	move.w (a0)+,d1
	move.w (a0)+,d2 
	move.l a0,ptr_rotation
	
	move.w d0,no_rotx+2
	move.w d1,no_roty+2
	move.w d2,no_rotz+2
no_chg
	move.w x_angle,d0
no_rotx
	add.w #0,d0

	cmpi.w #720,d0
	blo.s no_rotxr
	sub.w #720,d0
no_rotxr
	move.w d0,x_angle

	
	move.w y_angle,d0
no_roty
	add.w #0,d0
	cmpi.w #720,d0
	blo.s no_rotyr
	sub.w #720,d0	
no_rotyr
	move.w d0,y_angle
	

	move.w z_angle,d0
no_rotz
	add.w #0,d0
	cmpi.w #720,d0
	blo.s no_rotzr
	sub.w #720,d0
no_rotzr
	move.w d0,z_angle
	rts
*********************
******* fin animation **
************************

************************
**** rotation de tous **
** les points **********
************************
rotation
	lea objet,a6
	lea new_objet_x,a2
	lea new_objet_y,a3

	lea sin_tab,a0
	lea cos_tab,a1
	
	move.w (a6)+,d7
trigo
	
	move.w x_angle,d0
	move.w y_angle,d1
	move.w z_angle,d2
	
	move.w (a0,d0),sinx+2
	move.w (a0,d1),siny+2
	move.w (a0,d2),sinz+2
	move.w (a1,d0),cosx+2
	move.w (a1,d1),cosy+2
	move.w (a1,d2),cosz+2
	
rot0	movem.w (a6)+,d0-d2
	
sinz	move.w #0,d4
cosz	move.w #0,d5
	move.w d0,d3
	move.w d1,d6
	muls d5,d0
	muls d4,d6
	sub.l d6,d0
	lsl.l #2,d0
	swap	d0

	muls d4,d3
	muls d5,d1
	add.l d3,d1
	lsl.l #2,d1
	swap	d1

siny	move.w #0,d4
cosy	move.w #0,d5
	move.w d0,d3
	move.w d2,d6
	muls d5,d0
	muls d4,d6
	sub.l d6,d0
	lsl.l #2,d0
	swap	d0
	muls d3,d4
	muls d5,d2
	add.l d4,d2
	lsl.l #2,d2
	swap	d2
sinx	move.w #0,d4
cosx	move.w #0,d5
	move.w d1,d3
	move.w d2,d6
	muls d5,d1
	muls d4,d6
	sub.l d6,d1
	lsl.l #2,d1
	swap	d1
	muls d3,d4
	muls d5,d2
	add.l d4,d2

	lsl.l	#2,d2
	swap	d2

	ext.l d0
	ext.l d1
	asl.l #8,d0 ***pour le pt de fuite**
	asl.l #8,d1	**pour le pt de fuite**

	add.w #256,d2
	divs d2,d0 ***on obtient le pt de fuite**
	divs d2,d1
	addi.w #32,d0 	;96
	addi.w #32,d1 	;96
	move.w d0,(a2)+
	move.w d1,(a3)+
	;move.w d2,(a4)+
	dbra d7,rot0
	rts
*******************
*** fin rotation **
*******************

table_point:
	ds.w 2*40

ok_visib	dc.b 0
	even
remplissage
	
	move.w def_surface,d7
a_face
	move.w d7,-(sp)
ptr_def_surface
	lea def_surface+2,a0
	
	lea new_objet_x,a1
	lea new_objet_y,a3

	lea table_point,a2
	bsr test_visib	
	tst.b ok_visib ; visible ?
	bne.s ya
	move.w (a0)+,d2
	addq.w #1,d2
	lsl.w #2,d2
	addq.w #2,d2
	lea (a0,d2),a0
	move.l a0,ptr_def_surface+2
	move.w (sp)+,d7
	dbra d7,a_face
	move.l #def_surface+2,ptr_def_surface+2
	rts

ya
	move.w (a0)+,d2
	move.w d2,n_point+2
	move.w d2,d7
rempl_1
	move.w (a0)+,d3
	add d3,d3
	move.w (a1,d3),(a2)+
	move.w (a3,d3),(a2)+
	addq.w #2,a0
	dbra d2,rempl_1
	move.w d7,d2
	lea table_point,a1
recop_table_point
	move.l (a1)+,(a2)+
	dbra d2,recop_table_point
		
	move.w (a0)+,couleur
	move.l a0,ptr_def_surface+2

	bsr tri_rapide
***** numero du point dans d2***
	lea table_point(pc),a4
	add.w d2,a4
n_point	move.w #0,d1
nll_line	
	move.w d1,-(sp)
	move.w (a4)+,d0
	move.w (a4)+,d1
	move.w (a4),d2
	move.w 2(a4),d3
	bsr trace_line	
	move.w (sp)+,d1
	dbra d1,nll_line
	;move.w #$7,$fff8240
n_hrz_line
	move.w #0,d7
	bsr trace_lineh
	move.w (sp)+,d7
	dbra d7,a_face
	move.l #def_surface+2,ptr_def_surface+2
	rts

*********************************
********** test de visibilite****
*********************************
test_visib
	move	2(a0),d0
	add.w d0,d0	
	move.w (a1,d0.w),d1
	move.w (a3,d0),d2
	
	move	6(a0),d0
	add.w d0,d0	
	move.w (a1,d0.w),d3
	move.w (a3,d0),d4
	
	move	10(a0),d0
	add.w d0,d0	
	move.w (a1,d0.w),d5
	move.w (a3,d0),d6

	sub	d1,d3
	sub	d2,d4
	sub	d1,d5
	sub	d2,d6
	muls	d3,d6
	muls	d4,d5
	sub.l	d6,d5
	smi	ok_visib
	rts
***************************
* fin test de visibilite **
***************************

************************************
**** tri pour le trace de surface***
************************************
tri_rapide
	addq.w #1,d2
	subq.w #1,d7
	move.w d7,d6
***********trix*********
	move.l base_cls_ecran+4,a1
	lea table_point+4(pc),a0
	move.w -4(a0),d3
	move.w d3,d4
tri
	move.w (a0),d1
	cmp.w d3,d1
	bhi.s no_pp
	addq.w #4,d2
	move.w d1,d3
no_pp
	cmp.w d4,d1
	blo.s cont_trix
	move.w d1,d4
cont_trix
	addq.w #4,a0
	dbra d7,tri
	cmp.w (a1)+,d3
	bhi.s no_exg
	move.w d3,-2(a1)
no_exg
	cmp.w (a1)+,d4
	blo.s no_exg2
	move.w d4,-2(a1)
no_exg2
***********triy********
	lea table_point+6(pc),a0
	move.w -4(a0),d3
	move.w d3,d5
triy
	move.w (a0),d1
	cmp.w d3,d1
	bhi.s no_ppy
	move.w d1,d3
no_ppy
	cmp.w d5,d1
	blo.s no_ppy2
	move.w d1,d5	
no_ppy2
	addq.w #4,a0
	dbra d6,triy	
	cmp.w (a1)+,d3
	bhi.s no_exg3
	move.w d3,-2(a1)
no_exg3
	cmp.w (a1)+,d5
	blo.s no_exg4
	move.w d5,-2(a1)
no_exg4
	sub.w d3,d5 **nb_ligne**
	subq.w #1,d5
	bpl.s plg
	moveq.w #0,d5
plg
	lea table_20(pc),a2 ;largeur_buf
	move.w d5,n_hrz_line+2
	add d3,d3
	move.w d3,offset_xmin+2
	move.l	d0,-(a7)
	lea 	bigbuf,a1
	move	cu,d0
	mulu	#SIZE,d0
	add.l	d0,a1
	move.l	(a7)+,d0
	add.w (a2,d3.w),a1
	move.l a1,phys+2		
	rts
table_20
s	set 0
	rept 200
	dc.w s
s	set s+16 ;;;
	endr

cu	dc.w	0
**********************************
**** fin tri pour le trace de surface**
***************************************

**************************
**** routine de replissage
**************************
;avec trace ligne virtuel et trace de faces**
*********************************************
return_from_line
	rts
trace_line
	clr.l d4
	cmp.w d1,d3
	beq.s return_from_line
	bgt.s no_swap 
	exg d0,d2
	exg d1,d3
	lea table_xmax,a6
	bra.s suite_trace_line
no_swap
	lea table_xmin,a6
suite_trace_line
	add.w d1,a6 
	add.w d1,a6 
	add.w d0,d0
	add.w d0,d0
	add.w d2,d2
	add.w d2,d2
	move.w d3,d7
	move.w d2,d4
	sub.w d0,d4
clip  	
	move.w d3,d5
	sub.w d1,d5
	beq.s return_from_line
	bmi.s return_from_line
	sub.w d1,d7
	tst.w d1
	bge.s clip2
	move.w d1,d6
	moveq.w #0,d1
	neg.w d6
	muls d4,d6
	divs d5,d6
	add.w d6,d0
clip2
	ext.l d4
	asl.l #5,d4
	divs d5,d4
	ext.l d4
	asl.l #8,d4
	asl.l #3,d4
	swap d0
	move.w d4,d0
	beq.s clip3
	addi.w #$8000,d0
	swap d0
	swap d4
	lea list1(pc),a1
	move.w #$c8,d6
	sub.w d7,d6
	
	add.w d6,d6
	add.w d6,d6
	jmp (a1,d6)
clip3
	swap d4
	beq.s clip4
	swap d0
	lea list2(pc),a1
	move.w #$c8,d6
	sub.w d7,d6
	add.w d6,d6
	add.w d6,d6
	jmp (a1,d6)
clip4
	swap d0
	lea list3(pc),a1
	move.w #$c8,d6
	sub.w d7,d6
	add.w d6,d6
	jmp (a1,d6)
	rts

trace_lineh
	lea table_xmin,a5
offset_xmin
	add.w #0,a5
phys
	lea $0,a0	
	move.w #$fffc,d6
	clr.l d3
	clr.l d4
	lea offset_ecran,a4
	lea motif,a1
	move.w couleur,d0 ;motif_et_couleur
	cmp.w #3,d0
	bgt init_trace_line2 
init_trace_line1
	btst #0,d0
	beq.s *+4
	addq.l #2,a0
	lsl.w #3,d0
	move.l val_tram,d1
	move.w d1,t2+2
	swap d1
	move.w d1,t1+2
	move.w (a1,d0),d2
	move.w 2(a1,d0),trace_line1+2
	bne.s trame_yes
	addq.w #4,t2+2
	addq.w #4,t1+2
trame_yes
	lea mask,a1
	lea mask2,a3
vb
trace_line1
	eor.w #0,d2
	move.w d2,d0
	move.w d0,d1
	move.w (a5)+,d3
	move.w table_xmax-table_xmin-2(a5),d4 
	and.w d6,d3
	and.w d6,d4
	cmp.w d3,d4
	bhi.s suite_line_1
	exg d3,d4
suite_line_1	
	and.w (a1,d3),d0 ;mask_debut
	and.w (a3,d4),d1 ;mask_fin
	move.w (a4,d3),d3
	move.w (a4,d4),d4
	lea 16(a0),a2 ;largeur_buffer;;;;;
	add.l d3,a0
	sub d4,d3
	beq.s m_mask1
	jmp genere1(pc,d3) ;jmp (a1)
s	set 32
	rept 8
	move.w d2,s(a0)
s	set s-4
	endr
	or.w d0,(a0)
	neg d3
genere1
	or.w d1,(a0,d3)
	move.l a2,a0
t1
	dbra d7,vb
	rts
m_mask1
	and.w d0,d1
	or.w d1,(a0)
	move.l a2,a0
t2
	dbra d7,vb
	rts

val_tram:
	ds.w 2
val_tram2:
	ds.w 2

init_trace_line2
	lsl.w #3,d0
	move.l val_tram2,d1
	move.w d1,t4+2
	swap d1
	move.w d1,t3+2
	move.l (a1,d0),d2
	move.l 4(a1,d0),trace_line2+2
	bne.s trame_yes2
	addq.w #6,t3+2
trame_yes2
	lea mask,a1
	lea mask2,a3
	move.l #160,d5
vg
trace_line2
	eor.l #0,d2
	move.l d2,d0
	move.l d0,d1
	
	move.w (a5)+,d3
	and.w d6,d3
	move.w table_xmax-table_xmin-2(a5),d4 
	and.w d6,d4
	cmp.w d3,d4
	bhi.s suite_line_2
	exg d3,d4
suite_line_2
	
	and.l (a1,d3),d0 ;mask_debut
	and.l (a3,d4),d1 ;mask_fin
	move.w (a4,d3),d3
	move.w (a4,d4),d4
	lea 16(a0),a2 ;largeur_buffer ;;;;
	add.l d3,a0
	sub d4,d3
	beq.s m_mask2
	asr.w #1,d3
	or.l d0,(a0)+
	jmp genere2(pc,d3) ;jmp (a1)
	rept 9
	move.l d2,(a0)+
	endr
	or.l d1,(a0)+
genere2
	move.l a2,a0
t3
	dbra d7,vg
	rts

m_mask2
	and.l d0,d1
	or.l d1,(a0)
	move.l a2,a0
t4
	dbra d7,vg
	rts

list1
	rept 200
	move.w d0,(a6)+
	addx.l d4,d0
	endr
	rts
list2
	rept 200
	move.w d0,(a6)+
	add.w d4,d0
	endr
	rts
list3
	rept 200
	move.w d0,(a6)+
	endr
	rts

*********************************
***** init_offset bloc **********
*********************************
init_offset_buffer
	lea offset_ecran,a0
	clr.l d0
	move.w #19,d1
calc_o_e
	move.w #15,d2	
calc_o_e_
	move.w d0,(a0)+
	clr.w (a0)+
	dbra d2,calc_o_e_
	addq.l #4,d0
	dbra d1,calc_o_e
retour
	rts

********************************
**** fin init_offset bloc ******
********************************

***************************************************************
 SECTION	DATA                                             // *
***************************************************************

PAL_ETAGE5:
	dc.w	$0407
	dc.w	$0507
	dc.w	$0607

PAL_ETAGE1:
	dc.w	$0706
	dc.w	$0705
	dc.w	$0704

PAL_ETAGE2:
	dc.w	$0740
	dc.w	$0750
	dc.w	$0760

PAL_ETAGE3:
	dc.w	$0570
	dc.w	$0470
	dc.w	$0370

PAL_ETAGE4:
	dc.w	$0074
	dc.w	$0075
	dc.w	$0076

face0 equ 0
face1 equ 0
face2 equ 0
Default_palette:
	dc.w	$000,$fff,$102,$fff,face0,$0,$42e,$0
	dc.w	face1,$0,$ddd,$0,face2,$0,$0,$0

MUSIC:	* SNDH music -> Not compressed please !!!
	incbin	"SEVEN.MUS"
	even

* Full data here :
* >
message:
	DC.B      $fd ; en 1er plan
	DC.B      "            ELITE AND NOEXTRA",0
	DC.B      "             PRESENT IN 2014",0,0
	DC.B      "                GAME NAME",0
	DC.B      "             (C)COMPANY NAME",0,0
	DC.B      "         CRACKED BY.....",$fc,"MAARTAU",$fd,0
	DC.B      "         CODE...........",$fc,"ZORRO 2",$fd,0
	DC.B      "         MUSIC..........",$fc,"MAD MAX",$fd,0
	DC.B      "         SUPPLIER.......",$fc,"AL-TEAM",$fd,0,0
	DC.B      "         GREETS:AL.DBUG.ELITE",0
	DC.B      "         ICS.RG.PARADIZE.TSCC",0
	DC.B      "         ZUUL.POV.PULSION.HMD",0
	DC.B      "         IMPACT.EUROSWAP.STAX",0
	DC.B      "         FUZION.LEMMINGS.XTROLL",$ff
	even
fonts:
	incbin	"font890.DAT"
	even

mtexte:
* < !'#$%&"()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyzCUR> *
	dc.b " !",$22,"#$%&",$27,"()*+,-./0123456789:;<=>?@"
	dc.b "ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`"
	dc.b "abcdefghijklmnopqrstuvwxyz"
	dc.b "                          "
	dc.b "ZORRO2 ON THE KEYBOARD AND BIG WELCOME TO THE LAST PRODUCTION OF NOEXTRA-TEAM IN 2014 ! "
	dc.b "THANKS BRUME TO GIVE WORKS AT MAARTAU TO CRACK AND TRAINE OLD AND RARE GAMES AND THANKS TO USE OUR PRODUCTIONS TO SPREAD. "
	dc.b "SILLYVENTURE 2013 HAS GIVEN US A GOOD YEAR OF ATARI PRODUCTIONS, INCREDIBLE TO SEE ALL GOOD AND FINE PRODUCTIONS AND HOPE IN 2014. "
	dc.b "THANKS MICHAL... AND A REAL GOOD REVIVAL FROM HEMOROIDS FRENCH TEAM :) THANKS GUYS AND NICE TO SEE YOU ON ATARI ST AND JS !!! "
	dc.b "HEY DOUG ! YOU ASK ME FOR THE NEXT EMISSION TV FOR NOLIFE SPECIAL ATARI ST CUSTOMIZED, I'M WAITING FOR YOU.....       "
	dc.b "VERY GREAT WORK BY LOTEK OF TSCC WITH THE ATARI SECTION OF DEMOZOO.ORG, THERE ARE A LOT OF GOODIES INSIDE THIS NEW WEBSITE ! "
	dc.b "OK ! OK ! OK !    ABOUT THE CODE : LINE ROUTS USED, TWO SPECIAL SIZE FONTS USED, 3D CUBE CALCULATED AND BUFFERISED AND DISPLAY IN REALTIME WITH REMOVAL TOP AND BOTTOM BORDER, "
	dc.b "NO LOGO BY MISTER.A THIS YEAR BUT NICE 6X6 FONT USED FOR THE SCROLLTEXT AND OF COURSE, A SPECIAL SOUNDCHIP BY MAD MAX USED.                       "
	dc.b "WE WANT TO CHALLENGE ALL CODER OF WAB.COM TO HELP US TO CODE ON ATARI ST PLEASE * * * * * * * * *                             "
	dc.b "MEMBERS OF NOEXTRA : ATOMUS - MISTER.A - TOMCHI - MAARTAU - HYLST - .... AND ZORRO 2. GEOFFROY, GIVES YOU GOOD AND GO BACK SOON ! "
	dc.b "A NEW PRODUCTION CALL ",$22,"UNINVITED VERSION",$22," WILL BE PRESENTED AT THE VIP 2014 AND WE CROSS OUR FINGERS THAT WILL A TRACKMO :)      "
	dc.b "                            THIS INTRO WAS FINISHED AND TESTED ON REAL ATARI ST THE 29/01/2014.              "
	dc.b "............................... IT'S TIME TO WARP ! ...................................."
	dc.b "                              "
	dc.b	$ff
	even
smallfonts:
	incbin	"fontsmall.DAT"
	even

motif	
	dc.W -1 ;0 ;plan1
	dc.w 0
	dc.L 0	

	dc.W -1 ;1 ;plan1
	dc.w 0
	dc.l 0
	
	dc.w $aaaa ;2 ;plan1
	dc.w $ffff
	dc.l 0

	dc.W $aaaa ;3 ;plan2
	dc.w $ffff
	dc.l 0

	dc.W -1,0 ;4
	dc.l 0
	
	dc.W 0,-1 ;5
	dc.l 0
	
	dc.W -1,-1 ;6
	dc.L 0
	
	dc.W $aaaa,0 ;7
	dc.L $ffff0000
	
	dc.w 0,$aaaa ;8
	dc.l $0000ffff
	
	dc.W $aaaa,$aaaa ;9
	dc.l $ffffffff
	
	dc.W $aaaa,$5555 ;10
	dc.L $ffffffff
	
	dc.W $aaaa,$ffff ;11
	dc.L $ffff0000

	dc.W $ffff,$5555 ;12
	dc.L $0000ffff

mask
	rept 20
	dc.W $ffff,$ffff
	dc.W $7fff,$7fff
	dc.W $3fff,$3fff
	dc.W $1fff,$1fff

	dc.W $fff,$fff
	dc.W $7ff,$7ff
	dc.W $3ff,$3ff
	dc.W $1ff,$1ff

	dc.W $ff,$ff
	dc.W $7f,$7f
	dc.W $3f,$3f
	dc.W $1f,$1f

	dc.W $f,$f
	dc.W $7,$7
	dc.W $3,$3
	dc.W $1,$1
	endr
mask2
	rept 20
	dc.W $0,$0
	dc.W $8000,$8000
	dc.W $C000,$C000
	dc.W $E000,$E000

	dc.W $F000,$F000
	dc.W $F800,$F800
	dc.W $FC00,$FC00
	dc.W $FE00,$FE00

	dc.W $ff00,$ff00
	dc.W $FF80,$FF80
	dc.W $FFC0,$FFC0
	dc.W $FFE0,$FfE0

	dc.W $FFf0,$FFf0
	dc.W $FFF8,$FFF8
	dc.W $FFFC,$FFFC
	dc.W $FFFE,$FFFE
	endr

x_angle
	dc.w 180
y_angle
	dc.W 0
z_angle 
	dc.W 0
;z_pt_fuite
;	dc.W 1800

cpoint equ 16+0
objet
	dc.W 8-1	*nombre de point*

	dc.W -cpoint,-cpoint,cpoint
	dc.W -cpoint,cpoint,cpoint
	dc.W cpoint,cpoint,cpoint
	dc.W cpoint,-cpoint,cpoint

	dc.W -cpoint,cpoint,-cpoint
	dc.W cpoint,cpoint,-cpoint
	dc.W cpoint,-cpoint,-cpoint
	dc.W -cpoint,-cpoint,-cpoint

def_surface
	dc.W 5
************surface1*********
	dc.W 4-1
	dc.W 0,1
	dc.W 1,2
	dc.W 2,3
	dc.W 3,0	
	dc.W 0

	DC.W 4-1
	DC.W 3,2
	DC.W 2,5
	DC.W 5,6
	DC.W 6,3
	DC.W 1

	DC.W 4-1
	DC.W 6,5
	DC.W 5,4
	DC.W 4,7
	DC.W 7,6
	DC.W 0

	DC 4-1
	DC.W 7,4
	DC.W 4,1
	DC.W 1,0
	DC.W 0,7
	DC.W 1

	DC.W 4-1
	DC.W 1,4
	DC.W 4,5
	DC.W 5,2
	DC.W 2,1
	DC.W 6
	
	DC.W 4-1
	DC.W 7,0
	DC.W 0,3
	DC.W 3,6
	DC.W 6,7
	DC.W 6

base_cls1
	dc.W 0
	dc.W 0
	dc.W 0
	dc.W 0

base_cls2
	dc.w 0
	dc.W 0
	dc.W 0
	dc.W 0 

cos_tab:
	incbin COSINUS3.DAT
	even

sin_tab	equ cos_tab+722
	DS.L 40
couleur
	DC.L 0

base_cls_ecran
	dc.L base_cls2,base_cls1

* <


***************************************************************
 SECTION	BSS                                              // *
***************************************************************

bss_start:

* < Full data here >
new_objet_x
	ds.w 50
new_objet_y
	ds.w 50
;new_objet_z
;	ds.w 50

ptr_mtexte:
	ds.l	1
pas_car:
	ds.w 	1
buffer_car:
	ds.w 	8
buffer_mscrol:
	ds.w	120

table_xmin
	ds.w 320
table_xmax
	ds.w 320

bigbuf
	ds.b SIZE

offset_ecran
	ds.l 20*17

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

plan_carre equ 2
plan_ligne equ 0
X1c equ 61+2
X2c equ 258
Y1c equ 55
Y2c equ 173-1
Ydepart equ 15
put_squares:
	move.w	#Ydepart,d4	;	Grand carré
.loop:
	move.w	#X1c,d0
	move.w	d4,d1
	move.w	#X2c,d2
	move.w	d4,d3
	move.l	d4,-(a7)
	movea.l physique(pc),a0
	lea plan_carre+(160*40)(a0),a0
	bsr	FastLine	; draw!
	move.l	(a7)+,d4
	move.w	#X1c,d0
	move.w	d4,d1
	move.w	#X2c,d2
	move.w	d4,d3
	move.l	d4,-(a7)
	movea.l physique+4(pc),a0
	lea plan_carre+(160*40)(a0),a0
	bsr	FastLine	; draw!
	move.l	(a7)+,d4
	add.w	#1,d4
	cmp.w	#Y2c,d4
	bne.s	.loop

	movea.l physique(pc),a0 ; Ligne Haut
	lea plan_ligne(a0),a0
	move.w	#X1c-1,d0
	move.w	#Y1c,d1
	move.w	#X2c-1,d2
	move.w	#Y1c,d3
	bsr	FastLine	; draw!
	movea.l physique+4(pc),a0 ; Ligne Haut
	lea plan_ligne(a0),a0
	move.w	#X1c-1,d0
	move.w	#Y1c,d1
	move.w	#X2c-1,d2
	move.w	#Y1c,d3
	bsr	FastLine	; draw!

	movea.l physique(pc),a0 ; Ligne Bas
	lea plan_ligne+(160*40)(a0),a0
	move.w	#X1c-1,d0
	move.w	#Y2c,d1
	move.w	#X2c-1,d2
	move.w	#Y2c,d3
	bsr	FastLine	; draw!
	movea.l physique+4(pc),a0 ; Ligne Bas
	lea plan_ligne+(160*40)(a0),a0
	move.w	#X1c-1,d0
	move.w	#Y2c,d1
	move.w	#X2c-1,d2
	move.w	#Y2c,d3
	bsr	FastLine	; draw!

	movea.l physique(pc),a0 ; Ligne Gauche
	lea plan_ligne+(160*40)(a0),a0
	move.w	#X1c-1,d0
	move.w	#Ydepart,d1
	move.w	#X1c-1,d2
	move.w	#Y2c,d3
	bsr	FastLine	; draw!
	movea.l physique+4(pc),a0 ; Ligne Gauche
	lea plan_ligne+(160*40)(a0),a0
	move.w	#X1c-1,d0
	move.w	#Ydepart,d1
	move.w	#X1c-1,d2
	move.w	#Y2c,d3
	bsr	FastLine	; draw!

	movea.l physique(pc),a0 ; Ligne Droite
	lea plan_ligne+(160*40)(a0),a0
	move.w	#X2c-1,d0
	move.w	#Ydepart,d1
	move.w	#X2c-1,d2
	move.w	#Y2c,d3
	bsr	FastLine	; draw!
	movea.l physique+4(pc),a0 ; Ligne Droite
	lea plan_ligne+(160*40)(a0),a0
	move.w	#X2c-1,d0
	move.w	#Ydepart,d1
	move.w	#X2c-1,d2
	move.w	#Y2c,d3
	bsr	FastLine	; draw!
	rts

*********************************************************************
*                   LINE ROUTINE BY AXEL/HMD (ST)                   *
*********************************************************************
Ht         equ 199 ; screen height -1                               *
Wd         equ 319 ; screen width -1                                *
*********************************************************************
init_line_rout:
	lea	Offset,a0 ; Plane and offset conversion table for X coordinates
	lea	(Wd+1)*4(a0),a1
	moveq	#0,d0
lp
	moveq	#$f,d1
	and.w	d0,d1
	move.w	#$8000,d2
	lsr.w	d1,d2
	move.w	d2,(a0)+
	moveq	#-1,d2
	lsr.w	d1,d2
	move.w	d2,(a1)+	
	moveq	#$f0,d1
	and.w	d0,d1
	asr.w	d1
	move.w	d1,(a0)+
	move.w	d1,(a1)+
	addq.w	#1,d0
	cmp.w	#Wd+1,d0
	blo.s	lp

	lea	MulY,a0 ; Conversion table for Y coordinates
	move.w	#Ht,d0
	moveq	#0,d1
calc
	move.w	d1,(a0)+
	add.w	#160,d1
	dbra	d0,calc
	rts

X1	Equr	d0
Y1	Equr	d1
X2	Equr	d2
Y2	Equr	d3

ret	rts
FastLine:
	lea	MulY,a2
	lea	Offset,a3
	lea	(Wd+1)*4(a3),a1

	cmp.w	Y1,Y2
	bge.s	.skip4
	exg	Y1,Y2
	exg	X1,X2
; Y1<Y2		
.skip4
	cmp.w	#Ht,Y1
	bgt.s	ret
	bls.s	.skip5
 
; Y1<0 => clipping

	muls	Y2,X1
	move.w	X2,d4
	muls	Y1,d4
	sub.l	d4,X1
	move.w	Y2,d4
	bmi.s	ret
	sub.w	Y1,d4
	divs	d4,X1
	sub.w	Y1,Y1

.skip5
	cmp.w	#Ht,Y2
	ble.s	.skip6

; Y2>Ht => clipping

	move.w	Y2,d4
	muls	X1,d4
	move.w	X2,d5
	muls	Y1,d5
	sub.l	d5,d4
	sub.w	X1,X2
	muls	#Ht,X2
	add.l	d4,X2
	sub.w	Y1,Y2
	divs	Y2,X2
	move.w	#Ht,Y2

.skip6
	cmp.w	X1,X2
	ble.s	.skip1
	exg	X1,X2
	exg	Y1,Y2
; X2<X1
.skip1
	cmp.w	#Wd,X2
	bgt.s	ret
	bls.s	.skip2
 
; X2<0 => clipping

	muls	X1,Y2
	move.w	Y1,d4
	muls	X2,d4
	sub.l	d4,Y2
	move.w	X1,d4
	bmi.s	ret
	sub.w	X2,d4
	divs	d4,Y2
	sub.w	X2,X2

.skip2
	cmp.w	#Wd,X1
	ble.s	.skip3

; X1>Wd => clipping

	move.w	X1,d4
	muls	Y2,d4
	move.w	Y1,d5
	muls	X2,d5
	sub.l	d5,d4
	sub.w	Y2,Y1
	muls	#Wd,Y1
	add.l	d4,Y1
	sub.w	X2,X1
	divs	X1,Y1
	move.w	#Wd,X1

.skip3
	sub.w	Y1,Y2		; Dy
	beq	HLine

	sub.w	X1,X2		; Dx
	beq	VLine

	neg.w	d2
	add.w	d0,d0
	add.w	d0,d0
	move.l	(a3,d0.w),d0
	add.w	d1,d1
	add.w	(a2,d1.w),d0
	add.w	d0,a0
	swap	d0
	move.w	#160,d1
 
	tst.w	d3
	bpl.s	.skip9
	neg.w	d3
	neg.w	d1
 
.skip9
	cmp.w	d3,d2
	bgt	DxGtDy
	beq	DxEqDy
	
DxLtDy
	swap	d2		; Dx/Dy*65536
	clr.w	d2
	divu	d3,d2
	
	lsl.w	#4,d3
	neg.w	d3
	add.w	#16*Ht,d3
	moveq	#0,d4
	or.w	d0,(a0)
	jmp	.line(pc,d3.w)
.line
	rept	Ht
	add.w	d2,d4
	bcc.s	*+10		;.skip
	add.w	d0,d0
	bcc.s	*+6		;.skip
	subq.w	#8,a0
	moveq	#1,d0
;.skip	
	add.w	d1,a0
	or.w	d0,(a0)
	endr
	rts
	
DxGtDy
	swap	d3		; Dy/Dx*65536
	clr.w	d3
	divu	d2,d3

	lsl.w	#3,d2
	move.w	d2,d4
	add.w	d4,d4
	add.w	d4,d2
	neg.w	d2
	add.w	#24*Wd,d2
	moveq	#0,d4
	move.w	(a0),d5
	or.w	d0,d5
	jmp	.line(pc,d2.w)
.line
	rept	Wd
	add.w	d3,d4
	bcc.s	*+8		;.skip1
	move.w	d5,(a0)
	add.w	d1,a0
	move.w	(a0),d5
;.skip1
	add.w	d0,d0
	bcc.s	*+10		;.skip2
	move.w	d5,(a0)
	moveq	#1,d0
	subq.w	#8,a0
	move.w	(a0),d5
;.skip2
	or.w	d0,d5
	endr
	move.w	d5,(a0)
	rts
	
DxEqDy
	add.w	d2,d2
	add.w	d2,d2
	move.w	d2,d3
	add.w	d3,d3
	add.w	d3,d2
	neg.w	d2
	add.w	#12*Ht,d2
	or.w	d0,(a0)
	jmp	.line(pc,d2.w)
.line
	rept	Ht
	add.w	d0,d0
	bcc.s	*+6		;.skip
	subq.w	#8,a0
	moveq	#1,d0
;.skip	
	add.w	d1,a0
	or.w	d0,(a0)
	endr
	rts
	
VLine		
	add.w	d0,d0
	add.w	d0,d0
	move.l	(a3,d0.w),d0
	
	tst.w	d3
	bpl.s	.skip
	add.w	d3,d1
	neg.w	d3
.skip
	add.w	d1,d1
	add.w	(a2,d1.w),d0
	add.w	d0,a0
	swap	d0
 
 	neg.w	d3
	add.w	d3,d3
	add.w	d3,d3
	add.w	#4*Ht,d3
	or.w	d0,(a0)
	jmp	.line(pc,d3.w)
.line
k	set	Ht*160
	rept	Ht
	or.w	d0,k(a0)
k	set	k-160
	endr
	rts

HLine
	add.w	d0,d0
	add.w	d0,d0
	move.l	(a1,d0.w),d0
	add.w	d2,d2
	add.w	d2,d2
	move.l	(a1,d2.w),d2
	add.w	d1,d1
	move.w	(a2,d1.w),d1
	add.w	d0,d1
	add.w	d1,a0

	sub.w	d0,d2
	bmi.s	.cont
	swap	d0
	swap	d2
	not.w	d0
	and.w	d2,d0
	or.w	d0,(a0)
	rts
.cont
	swap	d0
	not.w	d0
	or.w	d0,(a0)
	add.w	d2,a0
	moveq	#-1,d0
	asr.w	d2
	jmp	.line+4(pc,d2.w)
k	set	18*8
	rept	18
	move.w	d0,k(a0)
k	set	k-8
	endr
.line	
	swap	d2
	or.w	d2,(a0)
	rts

Offset:
	ds.l	(Wd+1)*2
MulY:
	ds.w	Ht+1
	even

******************************************************************
	END                                                         // *
******************************************************************
