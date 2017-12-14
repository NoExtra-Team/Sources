***************************************
* // PIBTRO.PRG                    // *
***************************************
* // Asm Intro Code Atari ST v0.43 // *
* // by Zorro 2/NoExtra (07/07/15) // *
* // http://www.noextra-team.com/  // *
***************************************
* // Original code : Zorro 2       // *
* // Gfx logo      : Mister.A      // *
* // Gfx font      : Mister.A      // *
* // Music         : LAP           // *
* // Release date  : 11/03/2016    // *
* // Update date   : 13/04/2016    // *
***************************************
  OPT c+ ; Case sensitivity ON        *
  OPT d- ; Debug OFF                  *
  OPT o- ; All optimisations OFF      *
  OPT w- ; Warnings OFF               *
  OPT x- ; Extended debug OFF         *
***************************************

***************************************************************
	SECTION	TEXT                                             // *
***************************************************************

**************************** OVERSCAN ******************************
BOTTOM_BORDER    equ 1         ; Use the bottom overscan           *
TOPBOTTOM_BORDER equ 1         ; Use the top and bottom overscan   *
NO_BORDER        equ 0         ; Use a standard Low-screen         *
********************************************************************
PATTERN          equ $00000000 ; Wears Screens with a plan pattern *
SEEMYVBL         equ 1         ; See CPU used if you press ALT key *
ERROR_SYS        equ 1         ; Manage Errors System              *
FADE_INTRO       equ 0         ; Fade White to black palette       *
TEST_STE         equ 1         ; Code only for Atari STE machine   *
STF_INITS        equ 0         ; STF compatibility MODE            *
********************************************************************
*              Notes : 0 = I use it / 1 = no need !                *
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
	lea     12(sp),sp                ;

	clr.l   -(sp)                    ; Supervisor mode
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

	bsr	Inits                        ; Initialisations

**************************** MAIN LOOP ************************>

default_loop:

	bsr	Wait_vbl                     ; Waiting after the VBL

 IFEQ	SEEMYVBL
	clr.b	$ffff8240.w                ; init line of CPU
 ENDC

* < Put your code here >

	lea     physique(pc),a0          ; swapping two screens
	move.l (a0)+,d0
	move.l (a0)+,d1
	not.w (a0)                       ; switch screens
	move.l d0,-(a0)
	move.l d1,-(a0)
	lsr #8,d0
	move.l d0,$ffff8200.w            ; set hardware...

	bsr	clear_stars
	bsr	plot_stars

* <

 IFEQ	SEEMYVBL
	cmp.b	#$38,$fffffc02.w           ; ALT key pressed ?
	bne.s	.next_key                  ;
	move.b	#7,$ffff8240.w           ; See the rest of CPU (pink color used)
.next_key:                         ;
 ENDC

	cmp.b	#$39,$fffffc02.w           ; SPACE key pressed ?
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
	jsr	fadein                       ; Fading white to black
 ENDC

	moveq	#1,d0                      ; Choice of the music (1 is default)
	jsr	MUSIC+0                      ; Init SNDH music

	lea	Vbl_Blanck(pc),a0            ; Launch VBL
	move.l	a0,$70.w                 ;

	movea.l	physique(pc),a1
	adda.l	#160*76,a1
	movea.l	#LogoNoeXtra,a0
	move.l	#160*35/4-1,d0
	move.l	(a0)+,(a1)+
	dbf	d0,*-2
                	
	lea     PalNoeXtra,a2
	bsr     fadeon	

	lea	PalNoeXtra,a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

	bsr	init_stars                   ; Inits....

	bsr	fadeoff

	move.l	physique(pc),a0
	move.w  #160*200/4-1,d7
	move.l  #PATTERN,(a0)+
	dbf	    d7,*-6

	jsr	print_text

	lea	Default_palette,a0           ; Put palette
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d7               ;
	movem.l	d0-d7,(a1)               ;

 IFEQ	NO_BORDER
	move #$2700,SR                   ; Interrupts OFF
	sf	$fffffa21.w                  ; Timer B data (number of scanlines to next interrupt)
	sf	$fffffa1b.w                  ; Timer B control (event mode (HBL))
	lea	Hbl_Intro(pc),a0             ; Launch HBL
	move.l	a0,$120.w                ;
	bset	#0,$fffffa07.w             ; Timer B vector
	bset	#0,$fffffa13.w             ; Timer B on
	bclr	#3,$fffffa17.w             ; Automatic End-Interrupt hbl ON
	stop	#$2300                     ; Interrupts ON
 ENDC

	lea	Vbl(pc),a0                   ; Launch VBL
	move.l	a0,$70.w                 ;

	movem.l	(a7)+,d0-d7/a0-a6
	rts

fadeon	
	move.w	#8-1,d0	8 stages
.loop1	move.w	#16-1,d1	16 colours
	move.l	#$ffff8240,a0	offset of palette
	move.l	a2,a1	a2 points to new colours
.loop2	move.w	(a0),d2
	andi.w	#$777,d2	Eliminate garbage
	move.w	d2,d3
	andi.w	#$F,d2	d2 contains B value
	lsr.w	#4,d3
	move.w	d3,d4
	andi.w	#$F,d3	d3 contains G value
	lsr.w	#4,d4
	andi.w	#$F,d4	d4 contains R value
	move.w	(a1)+,d5
	andi.w	#$777,d5	As above!
	move.w	d5,d6
	andi.w	#$F,d5	d5 contains B value
	lsr.w	#4,d6
	move.w	d6,d7
	andi.w	#$F,d6	d6 contains G value
	lsr.w	#4,d7
	andi.w	#$F,d7	d7 contains R value
	cmp.w	d2,d5
	beq.s	.end1	B already new colour
	addq.w	#1,d2
.end1	cmp.w	d3,d6
	beq.s	.end2	G already new colour
	addq.w	#1,d3
.end2	cmp.w	d4,d7
	beq.s	.end3	R already new colour
	addq.w	#1,d4
.end3	lsl.w	#8,d4
	lsl.w	#4,d3
	or.w	d4,d2
	or.w	d3,d2	d2 now contains RGB value
	move.w	d2,(a0)+
	dbra	d1,.loop2	Next colour
	rept	6
	bsr	Wait_vbl
	endr
	dbra	d0,.loop1	Next stage
	rts

fadeoff	
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
	rept	6
	bsr	Wait_vbl
	endr
	dbra	d0,.loop1	Next stage
	rts

***************************************************************
*                                                             *
*                       Screen Routines                       *
*                                                             *
***************************************************************
 IFEQ	BOTTOM_BORDER
SIZE_OF_SCREEN equ 160*250         ; Screen + Lower Border size
 ENDC
 IFEQ	TOPBOTTOM_BORDER
SIZE_OF_SCREEN equ 160*300         ; Screen + Top & Lower Border size
 ENDC
 IFEQ	NO_BORDER
SIZE_OF_SCREEN equ 160*264         ; Only Screen size in Low Resolution
 ENDC

Init_screens:
	movem.l	d0-d7/a0-a6,-(a7)

	move.l	#Screen,d0             ; Set physical Screen #1
	add.w	#$ff,d0                    ;
	sf	d0                           ;
	move.l	d0,physique              ;
	add.l #SIZE_OF_SCREEN,d0         ; Set logical Screen #2
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
switch:
	ds.w	1


***************************************************************
*                                                             *
*                        Vbl Routines                         *
*                                                             *
***************************************************************
Vbl_Blanck:
	st	Vsync                    ; Synchronisation
	jsr 	(MUSIC+8)                  ; Play SNDH music
	rte

Vbl:	st	Vsync                    ; Synchronisation

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
	clr.b	(tacr).w                   ; Stop timer A
	lea	topbord(pc),a0               ; Launch HBL
	move.l	a0,$134.w                ; Timer A vector
	move.b	#99,(tadr).w             ; Countdown value for timer A
	move.b	#4,(tacr).w              ; Delay mode, clock divided by 50
	move.l	(a7)+,a0
 ENDC

 IFEQ	NO_BORDER
	CLR.B   $FFFFFA1B.W
	move.l	#Hbl_Intro,$120.w
	move.b	#36,$fffffa21.w
	move.b	#8,$fffffa1b.w
 ENDC

	jsr 	(MUSIC+8)                  ; Play SNDH music

; ---------------;
; Led du lecteur ;
; ---------------;
           lea $ffff8800,a0
           move.b #10-2,(a0)
           move.b (a0),d0
           cmpi.b #14,d0
           blt.s led_off
led_on:    move.b #14,(a0)
           move.b (a0),d0
           andi.b #$f9,d0
           move.b d0,2(a0)
           bra.s led_out
led_off:   move.b #14,(a0)
           move.b (a0),d0
           ori.b #6,d0
           move.b d0,2(a0)
led_out:

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
Hbl_Intro:
	move.w	#$f00,$ffff8240.w
	clr.b     $fffffa1b.w
	move.l    #RASTER_HAUT,$120.w 
	move.b    #8,$fffffa21.w 
	move.b    #8,$fffffa1b.w
	rte 
   
RASTER_HAUT:
	move.b	#$00,$ffff8240.w
	move.w	#$0f0,$ffff8250.w
	clr.b     $fffffa1b.w
	move.l    #RASTER_ENTRE,$120.w 
	move.b    #18,$fffffa21.w 
	move.b    #8,$fffffa1b.w
	rte

RASTER_ENTRE:
	move.w	#$760,$ffff8250.w
	clr.b	$fffffa1b.w
	move.l	#RASTER_BAS,$120.W
	move.b	#20,$fffffa21.w
	move.b	#8,$fffffa1b.w
	rte

RASTER_BAS:
	move.b	#$00,$ffff8240.w
	clr.b	$fffffa1b.w
	move.l	#RASTER_END,$120.W
	move.b	#10,$fffffa21.w
	move.b	#8,$fffffa1b.w
	rte

RASTER_END:
	move.b	#$ff,$ffff8250.w
	bclr	#0,$fffffa0f.w
	rte
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
herz = $FFFF820A
iera = $FFFFFA07
ierb = $FFFFFA09
isra = $FFFFFA0F
imra = $FFFFFA13
imrb = $FFFFFA15
tacr = $FFFFFA19
tadr = $FFFFFA1F

my_hbl:
	rte

topbord:
	move.l	a0,-(a7)
	move	#$2100,SR
	stop	#$2100                     ; Sync with interrupt
	clr.b	(tacr).w                   ; Stop timer A
	dcb.w	78,$4E71                   ; 78 nops
	clr.b	(herz).w                   ; 60 Hz
	dcb.w	18,$4E71                   ; 18 nops
	move.b	#2,(herz).w              ; 50 Hz
	lea	botbord(pc),a0
	move.l	a0,$134.w                ; Timer A vector
	move.b	#178,(tadr).w            ; Countdown value for timer A
	move.b	#7,(tacr).w              ; Delay mode, clock divided by 200
	move.l	(a7)+,a0                 ;
	bclr.b	#5,(isra).w              ; Clear end of interrupt flag
	rte

botbord:
	move	#$2100,SR                  ;
	stop	#$2100                     ; sync with interrupt
	clr.b	(tacr).w                   ; stop timer A
	dcb.w	78,$4E71                   ; 78 nops
	clr.b	(herz).w                   ; 60 Hz
	dcb.w	18,$4E71                   ; 18 nops
	move.b	#2,(herz).w              ; 50 Hz
	bclr.b	#5,(isra).w              ;
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

	move.b	$ffff8201.w,(a0)+        ; Save Video addresses
	move.b	$ffff8203.w,(a0)+        ;
	move.b	$ffff820a.w,(a0)+        ;
	move.b	$ffff820d.w,(a0)+        ;
	
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

 IFEQ	ERROR_SYS
	jsr	INPUT_TRACE_ERROR            ; Save vectors list
 ENDC

	clr.b	$fffffa07.w                ; Interrupt enable A (Timer-A & B)
	clr.b	$fffffa09.w                ; Interrupt enable B (Timer-C & D)
	clr.b	$fffffa13.w                ; Interrupt mask A (Timer-A & B)
	clr.b	$fffffa15.w                ; Interrupt mask B (Timer-C & D)
	clr.b	$fffffa19.w                ; Stop Timer A
	clr.b	$fffffa1b.w                ; Stop Timer B
	clr.b	$fffffa21.w                ; Timer B data at zero
	clr.b	$fffffa1d.w                ; Stop Timer C & D

 IFEQ	BOTTOM_BORDER
	sf	$fffffa21.w                  ; Timer B data (number of scanlines to next interrupt)
	sf	$fffffa1b.w                  ; Timer B control (event mode (HBL))
	lea	Over_rout(pc),a0             ; Launch HBL
	move.l	a0,$120.w                ;
	bset	#0,$fffffa07.w             ; Timer B vector
	bset	#0,$fffffa13.w             ; Timer B on
	bclr	#3,$fffffa17.w             ; Automatic End-Interrupt hbl ON
 ENDC

 IFEQ	TOPBOTTOM_BORDER
	move.b	#%00100000,(iera).w      ; Enable Timer A
	move.b	#%00100000,(imra).w      ;
	and.b	#%00010000,(ierb).w        ; Disable all except Timer D
	and.b	#%00010000,(imrb).w        ;
	or.b	#%01000000,(ierb).w        ; Enable keyboard
	or.b	#%01000000,(imrb).w        ;
	clr.b	(tacr).w                   ; Timer A off
	lea	my_hbl(pc),a0                ;
	move.l	a0,$68.w                 ; Horizontal blank
	lea	topbord(pc),a0               ;
	move.l	a0,$134.w                ; Timer A vector
	bclr	#3,$fffffa17.w             ; Automatic End-Interrupt hbl ON
 ENDC

	stop	#$2300                     ; Interrupts ON

	clr.b	$484.w                     ; No bip, no repeat

	move	#4,-(sp)                   ; Save & Change Resolution (GetRez)
	trap	#14	                       ; Get Current Res.
	addq.l	#2,sp                    ;
	move	d0,Old_Resol+2             ; Save it

	move	#3,-(sp)                   ; Save Screen Address (Logical)
	trap	#14                        ;
	addq.l	#2,sp                    ;
	move.l	d0,Old_Screen+2          ;

 IFEQ TEST_STE
	move	$ffff8264.w,Old_Shift+2    ; Save Screen Shifting
	move	$ffff820e.w,Old_Modulo+2   ; Save Screen Modulo
 ENDC

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

	lea       $ffff8800.w,a0         ; Cut sound
	move.l    #$8000000,(a0)         ; Voice A
	move.l    #$9000000,(a0)         ; Voice B
	move.l    #$a000000,(a0)         ; Voice C

 IFEQ	ERROR_SYS
	jsr	OUTPUT_TRACE_ERROR           ; Restore vectors list
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
	
	move.b	(a0)+,$ffff8201.w        ; Restore Video addresses
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

	bset.b #3,$fffffa17.w            ; Re-activate Timer C

	stop	#$2300                     ; Interrupts ON

	moveq #$11,d0                    ; Resume keyboard
	bsr	sendToKeyboard               ;

	moveq #$8,d0                     ; Restore mouse
	bsr	sendToKeyboard               ;

	bsr	flush                        ; Clear buffer keyboard

 IFEQ TEST_STE
Old_Modulo:
	move	#0,$ffff820e.w             ; Restore Screen Modulo
Old_Shift:
	move	#0,$ffff8264.w             ; Restore Old Shift
 ENDC

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
	moveq     #0,d0
	moveq     #0,d1
	moveq     #0,d2
	moveq     #0,d3
	moveq     #0,d4
	moveq     #0,d5
	moveq     #0,d6
	moveq     #0,d7
	movem.l   d0-d7,$ffff8240.w
	rts

***************************************************************
; SUB-ROUTINES                                             // *
***************************************************************

;-----------------------------------------------------------------------;
; 'Wraparound' Starfield. (a sort of fake 3d starfield using modulos..)	;
; Programmed by Griff of Electronic Images September 1991.              ;
; Very Fast Table Version (no multiplies so could be used in fullscreen);
; Improvements by Jedi / Sector One and Zorro 2 / NoExtra               ;
;-----------------------------------------------------------------------;
no_strs EQU 1024

init_stars:
	bsr	Random_gen
	bsr	makeperstab
	bsr	gen_masks
	bsr	Init_StarSeq
	rts

; Routines for Initialision of Starfield.

makeperstab:
    LEA humungus_table,A1
		LEA mul_160+(384),A3
		MOVE.L #(350*32767/512)*384,D7
		MOVE #350+$200,D1
		MOVE.W #$100-1,D2
.lp		MOVE.L D7,D6
		DIVS D1,D6
		MOVE.W #-256,D4
		MOVE.W #512-1,D3
.lp2		MOVE.W D4,D5
		MULS D6,D5
		ADD.L D5,D5
		SWAP D5
		ADD.W D5,D5
		MOVE.W (A3,D5),(A1)+
		ADD.W D5,D5
		MOVE.W D5,(A1)+
		ADDQ #1,D4
		DBF D3,.lp2
		SUBQ #2,D1
		DBF D2,.lp
		RTS

Random_gen:
    LEA stars,A3
		LEA (no_strs*4)(A3),A4
		MOVE #no_strs-1,D4
		MOVE.W #$2354,D0		;seed
.f_rand_x	BSR Rand
		MOVE.W D0,D1
		AND #$7FC,D1
		MOVE D1,(A3)+
.f_rand_y	BSR Rand
		MOVE.W D0,D1
		AND #$7FC,D1
		MOVE D1,(A3)+
		MOVE.L -4(A3),(A4)+
		DBF D4,.f_rand_x
Mul_160_crt:
    LEA mul_160,A0			;create *160 table
		MOVEQ #32-1,D0
.lp1:
    MOVE.W #-160,(A0)+
		DBF D0,.lp1
		MOVE.L #$A000,D2
		MOVEQ #0,D0
		MOVE #320-1,D1
.mul_lp:
    ADD.L D2,D0
		MOVE.L D0,D3
		SWAP D3
		MULU #160,D3
		MOVE.W D3,(A0)+
		DBF D1,.mul_lp
		MOVEQ #32-1,D0
.lp2:
    MOVE.W #32160,(A0)+
		DBF D0,.lp2
		RTS

gen_masks:
 	LEA plot_masks,A0
		MOVEQ #16-1,D0
.lp1:
    CLR.L (A0)+
		DBF D0,.lp1
		MOVEQ #0,D0
		MOVE.L #$E8BA,D2
		MOVE #352-1,D7
.masklp:
		ADD.L D2,D0
		MOVE.L D0,D3
		SWAP D3
		MOVE.W D3,D4
		CLR D5
		NOT D3
		AND #15,D3
		BSET D3,D5
		MOVE.W D5,(A0)+
		LSR #1,D4
		AND.W #$FFF8,D4
		MOVE.W D4,(A0)+
		DBF D7,.masklp
		
		MOVEQ #16-1,D0
.lp2:
    CLR.L (A0)+
		DBF D0,.lp2
		RTS

Rand:
    ADD D4,D0
		ADD.W #$573,D0
		MULU #$45F7,D0
		ROR.W #6,D0
		RTS

clear_stars:
    MOVE.L physique(pc),A0		; screen base
		MOVEQ #0,D0
		TST switch
		BNE old_pos1
old_pos2:	
		REPT 84*4
		MOVE.W D0,2(A0)
		ENDR
		ADDQ.W #2,A0
		REPT 86*4
		MOVE.W D0,2(A0)
		ENDR
		ADDQ.W #2,A0
		REPT 86*4
		MOVE.W D0,2(A0)
		ENDR
		RTS
old_pos1:
		REPT 84*4
		MOVE.W D0,2(A0)
		ENDR
		ADDQ.W #2,A0
		REPT 86*4
		MOVE.W D0,2(A0)
		ENDR
		ADDQ.W #2,A0
		REPT 86*4
		MOVE.W D0,2(A0)
		ENDR
		RTS

Init_StarSeq:
    LEA starfield_struc(PC),A0
		MOVE.L #star_seq,starseq_ptr(A0)
		MOVE.L #star_seq,starresseq_ptr(A0)
		MOVE.W #1,star_seqtimer(A0)
		RTS

star_seq:
    DC.W 128,0,0,56,0,80
		DC.W 256,4,4,56,0,96
		DC.W 256,4,4,0,56,96
		DC.W 256,4,4,56,56,96
		DC.W -1
		
; Do Starfield sequence and plot them.

		RSRESET
star_seqtimer	RS.W 1
starseq_ptr	RS.L 1
starresseq_ptr	RS.L 1
xyz		RS.B 0
x		RS.W 1
y		RS.W 1
z		RS.W 1
xyzang		RS.B 0
xang		RS.W 1
zang		RS.W 1
xspeed		RS.W 1
yspeed		RS.W 1
zspeed		RS.W 1
xang_inc	RS.W 1
zang_inc	RS.W 1
star_strucsize	RS.B 1

starfield_struc:
	DS.B star_strucsize

plot_stars:
    LEA starfield_struc(PC),A6
		SUBQ #1,star_seqtimer(A6)	; next sequence?
		BNE.S .nonew
		MOVE.L starseq_ptr(A6),A0	; ok...
		MOVE.W (A0)+,star_seqtimer(A6)
		MOVE.W (A0)+,xang_inc(A6)
		MOVE.W (A0)+,zang_inc(A6)
		MOVE.W (A0)+,xspeed(A6)		; read next seq
		MOVE.W (A0)+,yspeed(A6)		; vals
		MOVE.W (A0)+,zspeed(A6)
		CMP.W #-1,(A0)			; end of seq?
		BNE.S .notendseq
		MOVE.L starresseq_ptr(A6),A0	; yes then restart
.notendseq:
    MOVE.L A0,starseq_ptr(A6)	; store seq ptr
.nonew:
    MOVEM.W xyzang(A6),D0-D1
		ADD xang_inc(A6),D0
		ADD zang_inc(A6),D1
		AND.W #$7FE,D0
		AND.W #$7FE,D1
		MOVEM.W D0-D1,xyzang(A6)
		LEA trig_tab,A1
		LEA $200(A1),A2
		MOVE.W (A2,D1),D2
		MOVE.W (A1,D0),D1
		MOVE.W (A1,D0),D0
		MULS xspeed(A6),D0
		MULS yspeed(A6),D1
		MULS zspeed(A6),D2
		ADD.L D0,D0
		SWAP D0
		ADD.L D1,D1		
		SWAP D1
		ADD.L D2,D2
		SWAP D2
		MOVEM.W xyz(A6),D3-D5
		ADD D0,D3
		ADD D1,D4
		ADD D2,D5
		AND.W #$FFC,D5
		MOVEM.W D3-D5,xyz(A6)

		MOVE.L physique(pc),A0		; screen base
		LEA stars,A1			; star co-ords
		ADD D5,A1
		LEA old_pos1(PC),A3		
		LEA old_pos2(PC),A4
		MOVE.W switch,D0
		BNE .cse2
.cse1:
    MOVE.L A4,A3
.cse2:
    LEA plot_masks+(384*2),A5	; point masks
		LEA humungus_table,A2
		MOVE.W #$7FC,D7
		MOVE.L (A3),D2

plot1 MACRO
		MOVE.W (A1)+,D0
		MOVE.W (A1)+,D1
		ADD D3,D0
		ADD D4,D1
		AND.W D7,D0
		AND.W D7,D1
		MOVE.W 2(A2,D0),D0
		MOVE.W (A2,D1),D2
		MOVE.L (A5,D0),D0
		ADD D0,D2
		MOVE.L D2,(A3)+			; store pos
		SWAP D0
		OR D0,(A0,D2)

		MOVE.W (A1)+,D0
		MOVE.W (A1)+,D1
		ADD D3,D0
		ADD D4,D1
		AND.W D7,D0
		AND.W D7,D1
		MOVE.W 2(A2,D0),D0
		MOVE.W (A2,D1),D2
		MOVE.L (A5,D0),D0
		ADD D0,D2
		MOVE.L D2,(A3)+			; store pos
		SWAP D0
		OR D0,(A0,D2)

		MOVE.W (A1)+,D0
		MOVE.W (A1)+,D1
		ADD D3,D0
		ADD D4,D1
		AND.W D7,D0
		AND.W D7,D1
		MOVE.W 2(A2,D0),D0
		MOVE.W (A2,D1),D2
		MOVE.L (A5,D0),D0
		ADD D0,D2
		MOVE.L D2,(A3)+			; store pos
		SWAP D0
		OR D0,(A0,D2)

		MOVE.W (A1)+,D0
		MOVE.W (A1)+,D1
		ADD D3,D0
		ADD D4,D1
		AND.W D7,D0
		AND.W D7,D1
		MOVE.W 2(A2,D0),D0
		MOVE.W (A2,D1),D2
		MOVE.L (A5,D0),D0
		ADD D0,D2
		MOVE.L D2,(A3)+			; store pos
		SWAP D0
		OR D0,(A0,D2)

		LEA 2048(A2),A2
		ENDM

		REPT 84
		plot1 0
		ENDR
		ADDQ.L #2,A0
		ADDQ.L #2,A3
		REPT 86
		plot1
		ENDR
		ADDQ.L #2,A0
		ADDQ.L #2,A3
		REPT 86
		plot1
		ENDR
		RTS

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
                move.w  #6,pointeur_plan
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
                lea     fonts(pc),a1
                sub.w   #256,d0
                adda.w  d0,a1
                
                movea.l physique,a0
                adda.w  pointeur_plan(pc),a0
                adda.l  y_offset(pc),a0
                adda.l  x_offset(pc),a0
                
                movea.l physique+4,a3
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

***************************************************************
 SECTION	DATA                                             // *
***************************************************************

CBLANC_1 equ $222
CBLANC_2 equ $444
CBLANC_3 equ $666
CFONT    equ $fff
Default_palette:
	DC.W $000,CBLANC_1,CBLANC_2,CBLANC_2,CBLANC_3,CBLANC_3,CBLANC_3,CBLANC_3
	DC.W CFONT,CFONT,CFONT,CFONT,CFONT,$000,$000,$000

* < Full data here >

trig_tab:
	dc.w	$0000,$00C9,$0192,$025B,$0324,$03ED,$04B6,$057E 
	dc.w	$0647,$0710,$07D9,$08A1,$096A,$0A32,$0AFB,$0BC3 
	dc.w	$0C8B,$0D53,$0E1B,$0EE3,$0FAB,$1072,$1139,$1200 
	dc.w	$12C7,$138E,$1455,$151B,$15E1,$16A7,$176D,$1833 
	dc.w	$18F8,$19BD,$1A82,$1B46,$1C0B,$1CCF,$1D93,$1E56 
	dc.w	$1F19,$1FDC,$209F,$2161,$2223,$22E4,$23A6,$2467 
	dc.w	$2527,$25E7,$26A7,$2767,$2826,$28E5,$29A3,$2A61 
	dc.w	$2B1E,$2BDB,$2C98,$2D54,$2E10,$2ECC,$2F86,$3041 
	dc.w	$30FB,$31B4,$326D,$3326,$33DE,$3496,$354D,$3603 
	dc.w	$36B9,$376F,$3824,$38D8,$398C,$3A3F,$3AF2,$3BA4 
	dc.w	$3C56,$3D07,$3DB7,$3E67,$3F16,$3FC5,$4073,$4120 
	dc.w	$41CD,$4279,$4325,$43D0,$447A,$4523,$45CC,$4674 
	dc.w	$471C,$47C3,$4869,$490E,$49B3,$4A57,$4AFA,$4B9D 
	dc.w	$4C3F,$4CE0,$4D80,$4E20,$4EBF,$4F5D,$4FFA,$5097 
	dc.w	$5133,$51CE,$5268,$5301,$539A,$5432,$54C9,$555F 
	dc.w	$55F4,$5689,$571D,$57B0,$5842,$58D3,$5963,$59F3 
	dc.w	$5A81,$5B0F,$5B9C,$5C28,$5CB3,$5D3D,$5DC6,$5E4F 
	dc.w	$5ED6,$5F5D,$5FE2,$6067,$60EB,$616E,$61F0,$6271 
	dc.w	$62F1,$6370,$63EE,$646B,$64E7,$6562,$65DD,$6656 
	dc.w	$66CE,$6745,$67BC,$6831,$68A5,$6919,$698B,$69FC 
	dc.w	$6A6C,$6ADB,$6B4A,$6BB7,$6C23,$6C8E,$6CF8,$6D61 
	dc.w	$6DC9,$6E30,$6E95,$6EFA,$6F5E,$6FC0,$7022,$7082 
	dc.w	$70E1,$7140,$719D,$71F9,$7254,$72AE,$7306,$735E 
	dc.w	$73B5,$740A,$745E,$74B1,$7503,$7554,$75A4,$75F3 
	dc.w	$7640,$768D,$76D8,$7722,$776B,$77B3,$77F9,$783F 
	dc.w	$7883,$78C6,$7908,$7949,$7989,$79C7,$7A04,$7A41 
	dc.w	$7A7C,$7AB5,$7AEE,$7B25,$7B5C,$7B91,$7BC4,$7BF7 
	dc.w	$7C29,$7C59,$7C88,$7CB6,$7CE2,$7D0E,$7D38,$7D61 
	dc.w	$7D89,$7DB0,$7DD5,$7DF9,$7E1C,$7E3E,$7E5E,$7E7E 
	dc.w	$7E9C,$7EB9,$7ED4,$7EEF,$7F08,$7F20,$7F37,$7F4C 
	dc.w	$7F61,$7F74,$7F86,$7F96,$7FA6,$7FB4,$7FC1,$7FCD 
	dc.w	$7FD7,$7FE0,$7FE8,$7FEF,$7FF5,$7FF9,$7FFC,$7FFE 
	dc.w	$7FFF,$7FFE,$7FFC,$7FF9,$7FF5,$7FEF,$7FE8,$7FE0 
	dc.w	$7FD7,$7FCD,$7FC1,$7FB4,$7FA6,$7F96,$7F86,$7F74 
	dc.w	$7F61,$7F4C,$7F37,$7F20,$7F08,$7EEF,$7ED4,$7EB9 
	dc.w	$7E9C,$7E7E,$7E5E,$7E3E,$7E1C,$7DF9,$7DD5,$7DB0 
	dc.w	$7D89,$7D61,$7D38,$7D0E,$7CE2,$7CB6,$7C88,$7C59 
	dc.w	$7C29,$7BF7,$7BC4,$7B91,$7B5C,$7B25,$7AEE,$7AB5 
	dc.w	$7A7C,$7A41,$7A04,$79C7,$7989,$7949,$7908,$78C6 
	dc.w	$7883,$783F,$77F9,$77B3,$776B,$7722,$76D8,$768D 
	dc.w	$7640,$75F3,$75A4,$7554,$7503,$74B1,$745E,$740A 
	dc.w	$73B5,$735E,$7306,$72AE,$7254,$71F9,$719D,$7140 
	dc.w	$70E1,$7082,$7022,$6FC0,$6F5E,$6EFA,$6E95,$6E30 
	dc.w	$6DC9,$6D61,$6CF8,$6C8E,$6C23,$6BB7,$6B4A,$6ADB 
	dc.w	$6A6C,$69FC,$698B,$6919,$68A5,$6831,$67BC,$6745 
	dc.w	$66CE,$6656,$65DD,$6562,$64E7,$646B,$63EE,$6370 
	dc.w	$62F1,$6271,$61F0,$616E,$60EB,$6067,$5FE2,$5F5D 
	dc.w	$5ED6,$5E4F,$5DC6,$5D3D,$5CB3,$5C28,$5B9C,$5B0F 
	dc.w	$5A81,$59F3,$5963,$58D3,$5842,$57B0,$571D,$5689 
	dc.w	$55F4,$555F,$54C9,$5432,$539A,$5301,$5268,$51CE 
	dc.w	$5133,$5097,$4FFA,$4F5D,$4EBF,$4E20,$4D80,$4CE0 
	dc.w	$4C3F,$4B9D,$4AFA,$4A57,$49B3,$490E,$4869,$47C3 
	dc.w	$471C,$4674,$45CC,$4523,$447A,$43D0,$4325,$4279 
	dc.w	$41CD,$4120,$4073,$3FC5,$3F16,$3E67,$3DB7,$3D07 
	dc.w	$3C56,$3BA4,$3AF2,$3A3F,$398C,$38D8,$3824,$376F 
	dc.w	$36B9,$3603,$354D,$3496,$33DE,$3326,$326D,$31B4 
	dc.w	$30FB,$3041,$2F86,$2ECC,$2E10,$2D54,$2C98,$2BDB 
	dc.w	$2B1E,$2A61,$29A3,$28E5,$2826,$2767,$26A7,$25E7 
	dc.w	$2527,$2467,$23A6,$22E4,$2223,$2161,$209F,$1FDC 
	dc.w	$1F19,$1E56,$1D93,$1CCF,$1C0B,$1B46,$1A82,$19BD 
	dc.w	$18F8,$1833,$176D,$16A7,$15E1,$151B,$1455,$138E 
	dc.w	$12C7,$1200,$1139,$1072,$0FAB,$0EE3,$0E1B,$0D53 
	dc.w	$0C8B,$0BC3,$0AFB,$0A32,$096A,$08A1,$07D9,$0710 
	dc.w	$0647,$057E,$04B6,$03ED,$0324,$025B,$0192,$00C9 
	dc.w	$0000,$FF37,$FE6E,$FDA5,$FCDC,$FC13,$FB4A,$FA82 
	dc.w	$F9B9,$F8F0,$F827,$F75F,$F696,$F5CE,$F505,$F43D 
	dc.w	$F375,$F2AD,$F1E5,$F11D,$F055,$EF8E,$EEC7,$EE00 
	dc.w	$ED39,$EC72,$EBAB,$EAE5,$EA1F,$E959,$E893,$E7CD 
	dc.w	$E708,$E643,$E57E,$E4BA,$E3F5,$E331,$E26D,$E1AA 
	dc.w	$E0E7,$E024,$DF61,$DE9F,$DDDD,$DD1C,$DC5A,$DB99 
	dc.w	$DAD9,$DA19,$D959,$D899,$D7DA,$D71B,$D65D,$D59F 
	dc.w	$D4E2,$D425,$D368,$D2AC,$D1F0,$D134,$D07A,$CFBF 
	dc.w	$CF05,$CE4C,$CD93,$CCDA,$CC22,$CB6A,$CAB3,$C9FD 
	dc.w	$C947,$C891,$C7DC,$C728,$C674,$C5C1,$C50E,$C45C 
	dc.w	$C3AA,$C2F9,$C249,$C199,$C0EA,$C03B,$BF8D,$BEE0 
	dc.w	$BE33,$BD87,$BCDB,$BC30,$BB86,$BADD,$BA34,$B98C 
	dc.w	$B8E4,$B83D,$B797,$B6F2,$B64D,$B5A9,$B506,$B463 
	dc.w	$B3C1,$B320,$B280,$B1E0,$B141,$B0A3,$B006,$AF69 
	dc.w	$AECD,$AE32,$AD98,$ACFF,$AC66,$ABCE,$AB37,$AAA1 
	dc.w	$AA0C,$A977,$A8E3,$A850,$A7BE,$A72D,$A69D,$A60D 
	dc.w	$A57F,$A4F1,$A464,$A3D8,$A34D,$A2C3,$A23A,$A1B1 
	dc.w	$A12A,$A0A3,$A01E,$9F99,$9F15,$9E92,$9E10,$9D8F 
	dc.w	$9D0F,$9C90,$9C12,$9B95,$9B19,$9A9E,$9A23,$99AA 
	dc.w	$9932,$98BB,$9844,$97CF,$975B,$96E7,$9675,$9604 
	dc.w	$9594,$9525,$94B6,$9449,$93DD,$9372,$9308,$929F 
	dc.w	$9237,$91D0,$916B,$9106,$90A2,$9040,$8FDE,$8F7E 
	dc.w	$8F1F,$8EC0,$8E63,$8E07,$8DAC,$8D52,$8CFA,$8CA2 
	dc.w	$8C4B,$8BF6,$8BA2,$8B4F,$8AFD,$8AAC,$8A5C,$8A0D 
	dc.w	$89C0,$8973,$8928,$88DE,$8895,$884D,$8807,$87C1 
	dc.w	$877D,$873A,$86F8,$86B7,$8677,$8639,$85FC,$85BF 
	dc.w	$8584,$854B,$8512,$84DB,$84A4,$846F,$843C,$8409 
	dc.w	$83D7,$83A7,$8378,$834A,$831E,$82F2,$82C8,$829F 
	dc.w	$8277,$8250,$822B,$8207,$81E4,$81C2,$81A2,$8182 
	dc.w	$8164,$8147,$812C,$8111,$80F8,$80E0,$80C9,$80B4 
	dc.w	$809F,$808C,$807A,$806A,$805A,$804C,$803F,$8033 
	dc.w	$8029,$8020,$8018,$8011,$800B,$8007,$8004,$8002 
	dc.w	$8001,$8002,$8004,$8007,$800B,$8011,$8018,$8020 
	dc.w	$8029,$8033,$803F,$804C,$805A,$806A,$807A,$808C 
	dc.w	$809F,$80B4,$80C9,$80E0,$80F8,$8111,$812C,$8147 
	dc.w	$8164,$8182,$81A2,$81C2,$81E4,$8207,$822B,$8250 
	dc.w	$8277,$829F,$82C8,$82F2,$831E,$834A,$8378,$83A7 
	dc.w	$83D7,$8409,$843C,$846F,$84A4,$84DB,$8512,$854B 
	dc.w	$8584,$85BF,$85FC,$8639,$8677,$86B7,$86F8,$873A 
	dc.w	$877D,$87C1,$8807,$884D,$8895,$88DE,$8928,$8973 
	dc.w	$89C0,$8A0D,$8A5C,$8AAC,$8AFD,$8B4F,$8BA2,$8BF6 
	dc.w	$8C4B,$8CA2,$8CFA,$8D52,$8DAC,$8E07,$8E63,$8EC0 
	dc.w	$8F1F,$8F7E,$8FDE,$9040,$90A2,$9106,$916B,$91D0 
	dc.w	$9237,$929F,$9308,$9372,$93DD,$9449,$94B6,$9525 
	dc.w	$9594,$9604,$9675,$96E7,$975B,$97CF,$9844,$98BB 
	dc.w	$9932,$99AA,$9A23,$9A9E,$9B19,$9B95,$9C12,$9C90 
	dc.w	$9D0F,$9D8F,$9E10,$9E92,$9F15,$9F99,$A01E,$A0A3 
	dc.w	$A12A,$A1B1,$A23A,$A2C3,$A34D,$A3D8,$A464,$A4F1 
	dc.w	$A57F,$A60D,$A69D,$A72D,$A7BE,$A850,$A8E3,$A977 
	dc.w	$AA0C,$AAA1,$AB37,$ABCE,$AC66,$ACFF,$AD98,$AE32 
	dc.w	$AECD,$AF69,$B006,$B0A3,$B141,$B1E0,$B280,$B320 
	dc.w	$B3C1,$B463,$B506,$B5A9,$B64D,$B6F2,$B797,$B83D 
	dc.w	$B8E4,$B98C,$BA34,$BADD,$BB86,$BC30,$BCDB,$BD87 
	dc.w	$BE33,$BEE0,$BF8D,$C03B,$C0EA,$C199,$C249,$C2F9 
	dc.w	$C3AA,$C45C,$C50E,$C5C1,$C674,$C728,$C7DC,$C891 
	dc.w	$C947,$C9FD,$CAB3,$CB6A,$CC22,$CCDA,$CD93,$CE4C 
	dc.w	$CF05,$CFBF,$D07A,$D134,$D1F0,$D2AC,$D368,$D425 
	dc.w	$D4E2,$D59F,$D65D,$D71B,$D7DA,$D899,$D959,$DA19 
	dc.w	$DAD9,$DB99,$DC5A,$DD1C,$DDDD,$DE9F,$DF61,$E024 
	dc.w	$E0E7,$E1AA,$E26D,$E331,$E3F5,$E4BA,$E57E,$E643 
	dc.w	$E708,$E7CD,$E893,$E959,$EA1F,$EAE5,$EBAB,$EC72 
	dc.w	$ED39,$EE00,$EEC7,$EF8E,$F055,$F11D,$F1E5,$F2AD 
	dc.w	$F375,$F43D,$F505,$F5CE,$F696,$F75F,$F827,$F8F0 
	dc.w	$F9B9,$FA82,$FB4A,$FC13,$FCDC,$FDA5,$FE6E,$FF37 
	dc.w	$0000,$00C9,$0192,$025B,$0324,$03ED,$04B6,$057E 
	dc.w	$0647,$0710,$07D9,$08A1,$096A,$0A32,$0AFB,$0BC3 
	dc.w	$0C8B,$0D53,$0E1B,$0EE3,$0FAB,$1072,$1139,$1200 
	dc.w	$12C7,$138E,$1455,$151B,$15E1,$16A7,$176D,$1833 
	dc.w	$18F8,$19BD,$1A82,$1B46,$1C0B,$1CCF,$1D93,$1E56 
	dc.w	$1F19,$1FDC,$209F,$2161,$2223,$22E4,$23A6,$2467 
	dc.w	$2527,$25E7,$26A7,$2767,$2826,$28E5,$29A3,$2A61 
	dc.w	$2B1E,$2BDB,$2C98,$2D54,$2E10,$2ECC,$2F86,$3041 
	dc.w	$30FB,$31B4,$326D,$3326,$33DE,$3496,$354D,$3603 
	dc.w	$36B9,$376F,$3824,$38D8,$398C,$3A3F,$3AF2,$3BA4 
	dc.w	$3C56,$3D07,$3DB7,$3E67,$3F16,$3FC5,$4073,$4120 
	dc.w	$41CD,$4279,$4325,$43D0,$447A,$4523,$45CC,$4674 
	dc.w	$471C,$47C3,$4869,$490E,$49B3,$4A57,$4AFA,$4B9D 
	dc.w	$4C3F,$4CE0,$4D80,$4E20,$4EBF,$4F5D,$4FFA,$5097 
	dc.w	$5133,$51CE,$5268,$5301,$539A,$5432,$54C9,$555F 
	dc.w	$55F4,$5689,$571D,$57B0,$5842,$58D3,$5963,$59F3 
	dc.w	$5A81,$5B0F,$5B9C,$5C28,$5CB3,$5D3D,$5DC6,$5E4F 
	dc.w	$5ED6,$5F5D,$5FE2,$6067,$60EB,$616E,$61F0,$6271 
	dc.w	$62F1,$6370,$63EE,$646B,$64E7,$6562,$65DD,$6656 
	dc.w	$66CE,$6745,$67BC,$6831,$68A5,$6919,$698B,$69FC 
	dc.w	$6A6C,$6ADB,$6B4A,$6BB7,$6C23,$6C8E,$6CF8,$6D61 
	dc.w	$6DC9,$6E30,$6E95,$6EFA,$6F5E,$6FC0,$7022,$7082 
	dc.w	$70E1,$7140,$719D,$71F9,$7254,$72AE,$7306,$735E 
	dc.w	$73B5,$740A,$745E,$74B1,$7503,$7554,$75A4,$75F3 
	dc.w	$7640,$768D,$76D8,$7722,$776B,$77B3,$77F9,$783F 
	dc.w	$7883,$78C6,$7908,$7949,$7989,$79C7,$7A04,$7A41 
	dc.w	$7A7C,$7AB5,$7AEE,$7B25,$7B5C,$7B91,$7BC4,$7BF7 
	dc.w	$7C29,$7C59,$7C88,$7CB6,$7CE2,$7D0E,$7D38,$7D61 
	dc.w	$7D89,$7DB0,$7DD5,$7DF9,$7E1C,$7E3E,$7E5E,$7E7E 
	dc.w	$7E9C,$7EB9,$7ED4,$7EEF,$7F08,$7F20,$7F37,$7F4C 
	dc.w	$7F61,$7F74,$7F86,$7F96,$7FA6,$7FB4,$7FC1,$7FCD 
	dc.w	$7FD7,$7FE0,$7FE8,$7FEF,$7FF5,$7FF9,$7FFC,$7FFE 
	even

message:
*> !",$22,"#$%&",$27,"()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz
	DC.B      $fd ; en 1er plan
	DC.B      0
	DC.B      "    NOEXTRA PRESENT A PUBTRO IN 2016    ",0,0,0
	DC.B      "              | ZEUSDAZ |               ",0,0
	DC.B      "    THE UNEMULATED RETRO GAME CHANNEL   ",0,0
	DC.B      "  HTTPS://WWW.YOUTUBE.COM/USER/ZEUSDAZ  ",0,0,0
	DC.B      "        CODE.............ZORRO 2        ",0
	DC.B      "        GRAPH............MISTER.A       ",0
	DC.B      "        MUSIC............LAP            ",0,0,0
	DC.B      " GREETINGS:ATARI-LEGEND.AUTOMATION.NEXT ",0
	DC.B      " SOURCE.BSW.SUPREMACY.POV.VMAX.TLT.PHF  ",0
	DC.B      " CYNIX.EFFECT.IMPACT.FUZION.REPLICANTS  ",0
	DC.B      " D-BUG.ELITE.ICS.PULSION.ZUUL.EMPIRE.V8 ",0
	DC.B      $ff
	even

fonts:
	incbin	"AMIGA4F.DAT"
	even

PalNoeXtra:
	dc.w	$0000,$0666,$0555,$0444,$0333,$0222,$0111,$00F0
	dc.w	$0766,$0655,$0544,$0667,$0556,$0445,$0777,$0FFF
LogoNoeXtra:
	incbin	"NOEXTRA.IMG"	;	160*35
	even
* <

MUSIC:	* SNDH music -> Not compressed please !!!
	incbin	"ph*.SND"
	even

***************************************************************
 SECTION	BSS                                              // *
***************************************************************

bss_start:

* < Full data here >

mul_160:
	ds.l 384
plot_masks:
	ds.l 384
stars:
	ds.l no_strs*2
humungus_table:
	ds.w 512*256*2
	even

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

	ds.l	400
Screen:
	ds.b	256
	ds.b	SIZE_OF_SCREEN
	ds.b	SIZE_OF_SCREEN

***************************************************************
	SECTION	TEXT                                             // *
***************************************************************

 IFEQ	FADE_INTRO
***************************************************************
*                                                             *
*                    FADING WHITE TO BLACK                    *
*                  (Don't use VBL with it !)                  *
*                                                             *
***************************************************************
fadein:                            ; Fading effect
	move.l	#$777,d0
.deg:	bsr.s	wart
	bsr.s	wart
	bsr.s	wart
	lea	$ffff8240.w,a0
	moveq	#15,d1
.chg1:	move.w	d0,(a0)+
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

	pea ESCAPE_PRG                        ; Put the return adress
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
	END                                                         // *
******************************************************************
