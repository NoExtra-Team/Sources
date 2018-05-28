***************************************
* // AL_22.PRG                     // *
***************************************
* // Asm Intro Code Atari ST v0.42 // *
* // by Zorro 2/NoExtra (05/12/11) // *
* // http://www.noextra-team.com/  // *
***************************************
* // Original code : Zorro 2       // *
* // Gfx logo      :               // *
* // Gfx font      : unknow        // *
* // Music         : Mad Max       // *
* // Release date  : 14/11/2013    // *
* // Update date   : 09/01/2015    // *
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
TOPBOTTOM_BORDER equ 1         ; Use the top and bottom overscan   *
NO_BORDER        equ 0         ; Use a standard screen             *
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

	bsr	print

	bsr	mk_font

default_loop:

	bsr	Wait_vbl                     ; Waiting after the VBL

	IFEQ	SEEMYVBL
	clr.b	$ffff8240.w
	ENDC

* < Put your code here >

	bsr	scroller
	bsr	glissement

* <

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

	moveq	#6,d0                      ; Choice of the music (1 is default)
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

	move.l	physique(pc),a0          ; Put PATTERN in two Screens
	move.w  #(SIZE_OF_SCREEN)/4-1,d7 ;
	move.l  #PATTERN,(a0)+           ;
	dbf	    d7,*-6                   ;

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
	ds.l 1                           ; Number of screens declared

***************************************************************
*                                                             *
*                        Vbl Routines                         *
*                                                             *
***************************************************************
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
	CLR.B     $FFFFFA1B.W 
	MOVE.W    PAL_RAST,D0
	MOVE.W    D0,$FFFF8250.W
	MOVE.W    PAL_RAST,COLOR 
	MOVE.W    #2,PTR_RAST
	MOVE.B    #3,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W
	ENDC

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
HBL:
	MOVE.W    COLOR,$FFFF8250.W ; target Color bitplane
	MOVE.W    D0,-(A7)
	MOVE.L    A0,-(A7)
	MOVE.W    PTR_RAST,D0
	LEA       PAL_RAST,A0
	MOVE.W    0(A0,D0.W),COLOR
	MOVEA.L   (A7)+,A0
	MOVE.W    (A7)+,D0
	ADDQ.W    #2,PTR_RAST
	RTE 

COLOR:
	ds.l	1
PTR_RAST:
	ds.w	1 
PAL_RAST:
	dc.w	$0009,$0002,$000A,$0003
	dc.w	$000B,$0004,$000C,$0005
	dc.w	$000D,$0006,$000E,$0007
	dc.w	$000F,$008F,$001F,$009F
	dc.w	$002F,$00AF,$003F,$00BF
	dc.w	$004F,$00CF,$005F,$00DF
	dc.w	$006F,$00EF,$007F,$00FF
	dc.w	$08F7,$01FE,$09F6,$02FD
	dc.w	$0AF5,$03FC,$0BF4,$04FB
	dc.w	$0CF3,$05FA,$0DF2,$06F9
	dc.w	$0EF1,$07F8,$0FF0,$0F70
	dc.w	$0FE0,$0F60,$0FD0,$0F50
	dc.w	$0FC0,$0F40,$0FB0,$0F30
	dc.w	$0FA0,$0F20,$0F90,$0F10
	dc.w	$0F80,$0F00,$0700,$0E00
	dc.w	$0600,$0D00,$0500,$0C00
	dc.w	$0400,$0B00
	even
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
isrb = $FFFFFA11
imra = $FFFFFA13
imrb = $FFFFFA15
tacr = $FFFFFA19
tadr = $FFFFFA1F

my_hbl:
	rte

topbord:
	move.l	a0,-(a7)
	move	#$2100,sr
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
	move.b	#%00100000,(iera).w      ; Enable Timer A
	move.b	#%00100000,(imra).w
	and.b	#%00010000,(ierb).w        ; Disable all except Timer D
	and.b	#%00010000,(imrb).w
	or.b	#%01000000,(ierb).w        ; Enable keyboard
	or.b	#%01000000,(imrb).w
	clr.b	(tacr).w                   ; Timer A off
	lea	my_hbl(pc),a0
	move.l	a0,$68.w                 ; Horizontal blank
	lea	topbord(pc),a0
	move.l	a0,$134.w                ; Timer A vector
	ENDC

	IFEQ	NO_BORDER
	ANDI.B    #$DF,$FFFFFA09.W
	ANDI.B    #$FE,$FFFFFA07.W
	MOVE.L    #HBL,$120.W 
	ORI.B     #1,$FFFFFA07.W
	ORI.B     #1,$FFFFFA13.W
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

************************************************
*        SCROLLING - font 1 plan 40x24         *
************************************************
PLAN_SCROLLER equ 4

scroller:
	addi.w	#1,sc
	cmpi.w	#4,sc
	bne.s	nofnt
	clr.w	sc
	bsr.s	newfontw
nofnt:
	bsr	scroll
	bra	bendbuff
end:
	move.l	#texts,txt
newfontw:
	movea.l	txt,a0
	move.b	(a0)+,d0
	move.l	a0,txt
	cmpi.b	#$ff,d0
	beq.s	end
; Adding forgot text 0..9 in the font :)
* 0 à 9
	cmpi.b	#"0",d0
	bne.s	.1
	move.b	#30,d0	
	bra	funt
.1:
	cmpi.b	#"1",d0
	bne.s	.2
	move.b	#31,d0	
	bra.s	funt
.2:
	cmpi.b	#"2",d0
	bne.s	.3
	move.b	#32,d0	
	bra.s	funt
.3:
	cmpi.b	#"3",d0
	bne.s	.4
	move.b	#33,d0	
	bra.s	funt
.4:
	cmpi.b	#"4",d0
	bne.s	.5
	move.b	#34,d0	
	bra.s	funt
.5:
	cmpi.b	#"5",d0
	bne.s	.6
	move.b	#35,d0	
	bra.s	funt
.6:
	cmpi.b	#"6",d0
	bne.s	.7
	move.b	#36,d0	
	bra.s	funt
.7:
	cmpi.b	#"7",d0
	bne.s	.8
	move.b	#37,d0	
	bra.s	funt
.8:
	cmpi.b	#"8",d0
	bne.s	.9
	move.b	#38,d0	
	bra.s	funt
.9:
	cmpi.b	#"9",d0
	bne.s	.nop
	move.b	#39,d0	
	bra.s	funt
.nop:
	cmpi.b	#".",d0
	bne.s	point
	move.b	#26,d0	
	bra.s	funt
point:
	cmpi.b	#" ",d0
	bne.s	space
	move.b	#27,d0	
	bra.s	funt
space:
	subi.b	#"A",d0
funt:
	andi.w	#$ff,d0
	muls	#4*32,d0
	lea	font,a0
	adda.w	d0,a0
	lea	puffer+40,a1
	move.w	#31,d0
lllp:
	move.w	(a0)+,00(a1)
	move.w	(a0)+,02(a1)
	lea	48(a1),a1
	dbf	d0,lllp
	rts
scroll:
	lea	puffer,a0
	move.w	#31,d0
scrl1
i set 01
 rept 44
	move.b	i(a0),i-1(a0)
i set i+1
 endr
	lea	48(a0),a0
	dbf	d0,scrl1
	rts

bendbuff:
	cmpi.w	#0,wpos
	bne.s	notend
	move.w	#720,wpos
notend	subi.w	#4,wpos
	lea	wave,a2
	adda.w	wpos,a2
	lea	self1(pc),a0
	moveq	#19,d7
	move.w	#76,d2
	moveq	#0,d3
	moveq	#0,d4
pre_do:
	move.w	d2,d0
	move.w	d2,d1
	add.w	(a2)+,d0
	add.w	(a2)+,d1
	muls	#160,d0
	muls	#160,d1
	addq.w	#1,d1
	add.w	d3,d0
	add.w	d3,d1
	move.w	d4,2(a0)
	move.w	d4,8(a0)
	addq.w	#1,8(a0)
	move.w	d0,4(a0)	
	move.w	d1,10(a0)	
	addq.w	#8,d3
	addq.w	#2,d4
	lea	12(a0),a0
	dbf	d7,pre_do
	movea.l	physique(pc),a0
	addq.w	#PLAN_SCROLLER,a0
	*adda.l	#160*100,a0
	lea	blnk,a1
	move.w	#32,d0
self1:
 rept 40
	move.b	0(a1),0(a0)
 endr
	lea	48(a1),a1
	lea	160(a0),a0
	dbf	d0,self1
	rts

mk_font:
	lea	font,a0	get start of font
	lea	fontpic,a1	get start of picture
	moveq	#0,d1		y=0
loop1:
	moveq	#0,d0		x=0
loop2:
	movea.l	a1,a2
	move.w	d0,d2
	muls	#16,d2
	adda.l	d2,a2
	move.w	d1,d2
	muls	#160*32,d2
	adda.l	d2,a2
value	set	0
	rept	32
	move.w	value*160+0(a2),(a0)+
	move.w	value*160+8(a2),(a0)+
value	set	value+1
	endr
	addq.w	#1,d0
	cmpi.w	#10,d0
	bne	loop2
	addq.w	#1,d1
	cmpi.w	#3+1,d1
	bne	loop1
	rts

************************************************
*          BLOCK MOVER - 1 bitplane            *
************************************************
glissement:
	MOVEA.L   ptr_Sinus,A6
	CMPI.w    #-1,(A6) 
	BNE.S     .not_reloop 
	MOVE.L    #Sinus,ptr_Sinus
	MOVEA.L   ptr_Sinus,A6
.not_reloop:
	lea	text_buff+4,a0
	move.l	physique,a1
	addq.w	#2,a1
	ADDA.w    (A6)+,A1
	MOVE.L    A6,ptr_Sinus
	MOVEA.L   text_buff+4,A6

	lea	4(a1),a1
	move.w	#172,d0
.l6
x	set	0
	rept	20
	move.w	x(a0),x(a1)
x	set	x+8
	endr
	lea	160(a0),a0
	lea	160(a1),a1
	dbf	d0,.l6
	RTS

************************************************
*       PRINT TEXT - font 1 plan 16x16         *
************************************************
PLAN_FONT equ 4

print:
	lea	text,a0
	lea	text_buff+(8*10)-160*4+PLAN_FONT,a1
	move.l	a0,a4
.l2	moveq	#0,d0
	moveq	#0,d1
	move.l	#$00070001,d6
.l1	move.b	(a0)+,d0
	cmp.b	#1,d0
	beq.s	.e1
	cmp.b	#-1,d0
	beq.s	.e1
	addq.w	#1,d1
	bra.s	.l1
.e1
	tst.w	d1
	beq.s	.s5
	move.w	d1,d2
	move.w	d1,d3
	and.w	#1,d3
	move.l	a1,a3
	move.l	d6,d4
	tst.w	d3
	beq.s	.s4
	swap	d4
.s4	subq.w	#1,d1
.l5	sub.w	d4,a3
	swap	d4
	dbf	d1,.l5
	move.l	d6,d4
	tst.w	d3
	beq.s	.s1
	swap	d4
.s1	move.l	a4,a0

.l3	moveq	#0,d0
	move.b	(a0)+,d0
	cmp.b	#-1,d0
	beq.s	.e2
.n0	cmp.b	#1,d0
	bne.s	.n1
.s5	lea	160*20(a1),a1
	move.l	a0,a4
	bra.s	.l2
.n1	sub.b	#$20,d0

	add.w	d0,d0
	add.w	d0,d0

	lea	font_tab2(pc),a2
	move.l	(a2,d0.w),a2

	moveq	#2-1,d5
.l4	move.l	a3,a5

x	set	0
	rept	15
	move.b	(a2)+,x(a5)
x	set	x+160
	endr

	add.w	d4,a3
	swap	d4
	dbf	d5,.l4

	bra.s	.l3
.e2
	rts


***************************************************************
 SECTION	DATA                                             // *
***************************************************************

ccoul_font equ $fff
Default_palette:
	dc.w	$000,$777,0,0,ccoul_font,0,0,0
	dc.w	0,0,0,0,ccoul_font,0,0,0

* Full data here :
* >
sc	dc.w	0
txt	dc.l	texts
texts
	DC.B	"ABCDEFGHIJKLMNOPQRSTUVWXYZ.   "
	DC.B	"0123456789           "
	dc.b	$ff
	even	even
wpos:
	dc.w	0
wave:
	incbin	sin30.dat
	even
fontpic
	incbin	FONT01.IMG
	ds.b	160*3
	even
*
font_tab2:
	dc.l	text_font+(30*0),text_font+(30*1),text_font+(30*0),text_font+(30*2),text_font+(30*0)
	dc.l	text_font+(30*0),text_font+(30*0),text_font+(30*3),text_font+(30*4),text_font+(30*5)
	dc.l	text_font+(30*6),text_font+(30*0),text_font+(30*7),text_font+(30*8),text_font+(30*9)
	dc.l	text_font+(30*10),text_font+(30*11),text_font+(30*12),text_font+(30*13),text_font+(30*14)
	dc.l	text_font+(30*15),text_font+(30*16),text_font+(30*17),text_font+(30*18),text_font+(30*19)
	dc.l	text_font+(30*20),text_font+(30*21),text_font+(30*0),text_font+(30*0),text_font+(30*0)	
	dc.l	text_font+(30*0),text_font+(30*22),text_font+(30*0),text_font+(30*23),text_font+(30*24)
	dc.l	text_font+(30*25),text_font+(30*26),text_font+(30*27),text_font+(30*28),text_font+(30*29)
	dc.l	text_font+(30*30),text_font+(30*31),text_font+(30*32),text_font+(30*33),text_font+(30*34)
	dc.l	text_font+(30*35),text_font+(30*36),text_font+(30*37),text_font+(30*38),text_font+(30*39)
	dc.l	text_font+(30*40),text_font+(30*41),text_font+(30*42),text_font+(30*43),text_font+(30*44)
	dc.l	text_font+(30*45),text_font+(30*46),text_font+(30*47),text_font+(30*48)
; 10 lines of text (1=next line, -1=end of text)
;        01234567890123456789
text:
	dc.b	1
	dc.b	"  NOEXTRA PRESENTS  ",1
	dc.b	"--------------------",1
	dc.b	"-*-     GAME     -*-",1
	dc.b	"--------------------",1
	dc.b	"GREETS:ELITE.AL.DBUG",1
	dc.b	"EMPIRE.ZUUL.IMPACT. ",1
	dc.b	"HMD.ST KNIGHTS.SECT1",1
	dc.b	"STAX.FUZION.PULSION.",-1
	even
text_font:
	incbin	metalion.fon
	even
*
ptr_Sinus:
	DC.L	Sinus 
Sinus:
	incbin	"SINWAVE.DAT"
	even
*


* <

MUSIC:	* SNDH music -> Not compressed please !!!
	incbin	"*.SND"
	even

***************************************************************
 SECTION	BSS                                              // *
***************************************************************

bss_start:

* < Full data here >

	ds.b	160*10
text_buff:
	ds.b	160*170
	ds.b	160*3
*
blnk:
	ds.b	48*2
puffer:
	ds.b	48*33
font:
	ds.b	128*4*10
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

Screen_1:
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
