***************************************
* // AL_19.PRG                     // *
***************************************
* // Asm Intro Code Atari ST v0.42 // *
* // by Zorro 2/NoExtra (05/12/11) // *
* // http://www.noextra-team.com/  // *
***************************************
* // Original code : Zorro 2       // *
* // Gfx logo      : Mister.A      // *
* // Gfx font      : unknow        // *
* // Music         : Mad Max       // *
* // Release date  : 04/10/2014    // *
* // Update date   : 15/12/2014    // *
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

default_loop:

	bsr	Wait_vbl                     ; Waiting after the VBL

	IFEQ	SEEMYVBL
	move.w	#$0CCE,$ffff8240.w
	ENDC

* < Put your code here >

PLANcls equ 6
	jsr	Cls_1_plan
PLAN3d equ 0
	BSR Show_obj		;	let's show AL

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

	bsr create160tb		;	init rout cls 3d 1 plan
	
	bsr	Genere_code_cls

	lea	physique(pc),a6
	move.l	(a6)+,a0
	lea	160*124(a0),a0
	move.l	(a6)+,a1
	lea	160*124(a1),a1
	movea.l	#Al_NoEx_Logo_img,a4
	move.l	#160*76/4-1,d0
	move.l	(a4),(a0)+
	move.l	(a4)+,(a1)+
	dbf	d0,*-4

	bsr	print_text                   ; Affiche le texte

	moveq	#1,d0                      ; Choice of the music (1 is default)
	jsr	MUSIC+0                      ; Init SNDH music

	lea	Vbl(pc),a0                   ; Launch VBL
	move.l	a0,$70.w                 ;

	lea	Al_NoEx_Logo_palette,a0           ; Put palette
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
* // Declarations here ...
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

flush:	lea	$fffffc00.w,a0
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
                lea     20*160(a0),a0
                adda.w  pointeur_plan,a0
                adda.l  y_offset,a0
                adda.l  x_offset,a0
                
                movea.l physique+4(pc),a3
                lea     20*160(a3),a3
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
*                     3D ONE BITPLANE by GRIFF                      *
*********************************************************************

Show_obj
		LEA Stack,A5
		LEA seqdata(PC),A3
		SUBQ #1,seq_timer(A3)
		BNE.S .nonew
		MOVE.L seq_ptr(A3),A1
		TST (A1)
		BPL.S .notendseq
		MOVE.L restart_ptr(A3),A1 
.notendseq	MOVE.W (A1)+,seq_timer(A3)
		MOVE.W (A1)+,addangx(A3)
		MOVE.W (A1)+,addangy(A3)
		MOVE.W (A1)+,addangz(A3)	; store new incs..
		MOVE.W (A1)+,zspeed
		MOVE.L A1,seq_ptr(A3)
.nonew		LEA trig_tab,A0		; sine table
		LEA 512(A0),A2			; cosine table
		MOVEM.W (A5)+,D5-D7    		; get current x,y,z ang	
		ADD addangx(A3),D5
		ADD addangy(A3),D6		; add increments
		ADD addangz(A3),D7
		AND #$7FE,D5
		AND #$7FE,D6
		AND #$7FE,D7
		MOVEM.W D5-D7,-6(A5)   	
		MOVE (A0,D5),D0			sin(xd)
		MOVE (A2,D5),D1			cos(xd)
		MOVE (A0,D6),D2			sin(yd)
		MOVE (A2,D6),D3			cos(yd)
		MOVE (A0,D7),D4			sin(zd)
		MOVE (A2,D7),D5			cos(zd)
		LEA M11+2(PC),A1
* sinz*sinx(used twice) - A3
		MOVE D0,D6			sinx
		MULS D4,D6			sinz*sinx
		ADD.L D6,D6
		SWAP D6
		MOVE D6,A3
* sinz*cosx(used twice) - A4
		MOVE D1,D6			cosx
		MULS D4,D6			sinz*cosx
		ADD.L D6,D6
		SWAP D6
		MOVE D6,A4
* Matrix(1,1) cosy*cosx-siny*sinz*sinx
		MOVE D3,D6			cosy
		MULS D1,D6			cosy*cosx
		MOVE A3,D7			sinz*sinx
		MULS D2,D7			siny*sinz*sinx					
		SUB.L D7,D6
		ADD.L D6,D6
		SWAP D6			
		MOVE D6,(A1)
* Matrix(2,1) siny*cosx+cosy*sinz*sinx 
		MOVE D2,D6
		MULS D1,D6			siny*cosx
		MOVE A3,D7			sinz*sinx
		MULS D3,D7			cosy*sinz*sinx			
		ADD.L D7,D6
		ADD.L D6,D6
		SWAP D6			
		MOVE D6,M21-M11(A1)
* Matrix(3,1) -cosz*sinx
		MOVE D5,D6			cosz
		MULS D0,D6			cosz*sinx
		ADD.L D6,D6
		SWAP D6
		NEG D6				-cosz*sinx
		MOVE D6,M31-M11(A1)
* Matrix(1,2) -siny*cosz
		MOVE D2,D6			siny
		MULS D5,D6			siny*cosz
		ADD.L D6,D6
		SWAP D6
		NEG D6				-siny*cosz
		MOVE D6,M12-M11(A1)
* Matrix(2,2) cosy*cosz		
		MOVE D3,D6			cosy
		MULS D5,D6			cosy*cosz
		ADD.L D6,D6
		SWAP D6
		MOVE D6,M22-M11(A1)
* Matrix(3,2) sinz 
		MOVE D4,M32-M11(A1)
* Matrix(1,3) cosy*sinx+siny*sinz*cosx
		MOVE D3,D6			cosy
		MULS D0,D6			cosy*sinx
		MOVE A4,D7			sinz*cosx
		MULS D2,D7
		ADD.L D7,D6
		ADD.L D6,D6
		SWAP D6				siny*(sinz*cosx)
		MOVE D6,M13-M11(A1)
* Matrix(2,3) siny*sinx-cosy*sinz*cosx
		MULS D0,D2			siny*sinx
		MOVE A4,D7
		MULS D3,D7
		SUB.L D7,D2 
		ADD.L D2,D2
		SWAP D2
		MOVE D2,M23-M11(A1)
* Matrix(3,3) cosz*cosx
		MULS D1,D5 
		ADD.L D5,D5
		SWAP D5				cosz*cosx
		MOVE D5,M33-M11(A1)

; Transform and perspect co-ords.
; A5 -> x,y,z.w offsets for co-ords,D7 source co-ords x,y,z.w
; A1 -> to a storage place for the resultant x,y co-ords.
; D0-D7/A0-A4 smashed.

		MOVE (A5)+,D7			get no of verts
		LEA new_coords(PC),A1		storage place new x,y co-ords
		MOVE.L zspeed(PC),D6
Trans_verts	MOVE.L (A5)+,addoffx+2
		MOVE.L (A5)+,addoffy+2
		ADD.L D6,(A5)
		MOVE.L (A5)+,addoffz+2		(after this a5-> d7 x,y,z co-ords
		MOVEA #160,A3			centre x
		MOVEA #100,A4			centre y
		SUBQ #1,D7				verts-1
trans_lp	MOVEM.W (A5)+,D0-D2		x,y,z
		MOVE D0,D3	
		MOVE D1,D4				dup
		MOVE D2,D5
; Calculate x co-ordinate		
M11		MULS #0,D0			
M21		MULS #0,D4				mat mult
M31		MULS #0,D5
		ADD.L D4,D0
		ADD.L D5,D0
		MOVE D3,D6
		MOVE D1,D4
		MOVE D2,D5
; Calculate y co-ordinate		
M12		MULS #0,D3
M22		MULS #0,D1				mat mult
M32		MULS #0,D5
		ADD.L D3,D1
		ADD.L D5,D1
; Calculate z co-ordinate
M13		MULS #0,D6
M23		MULS #0,D4				mat mult
M33		MULS #0,D2
		ADD.L D6,D2
		ADD.L D4,D2
; Combine and Perspect
addoffx		ADD.L #0,D0
addoffy		ADD.L #0,D1
addoffz		ADD.L #0,D2
		ADD.L D2,D2
		SWAP D2
		ASR.L #8,D0
		ASR.L #8,D1
		DIVS D2,D0
		DIVS D2,D1
		ADD A3,D0				x scr centre
		ADD A4,D1				y scr centre
		MOVE D0,(A1)+			new x co-ord
		MOVE D1,(A1)+			new y co-ord
		DBF D7,trans_lp
; A5 -> total no of lines to draw. 
drawlines	MOVE (A5)+,D7
		SUBQ #1,D7
; A5 -> line list
		MOVE.L physique(pc),A1
		sub.w	#PLAN3d,a1
		LEA bit_offs(PC),A2
		LEA mul_tab,A3
		LEA new_coords(PC),A6		co-ords
drawline_lp	MOVE (A5)+,D1			;1st offset to vertex list
		MOVE (A5)+,D2			;2nd offset to vertex list
		MOVEM (A6,D1),D0-D1		;get x1,y1
		MOVEM (A6,D2),D2-D3		;"  x2,y2

xmax		EQU 319
ymax		EQU 199

Drawline	MOVE.L A1,A0
clipony		CMP.W D1,D3			; y2>=y1?(Griff superclip)!
		BGE.S y2big
		EXG D1,D3			; re-order
		EXG D0,D2
y2big		TST D3				; CLIP ON Y
		BLT	nodraw			; totally below window? <ymin
		CMP.W #ymax,D1
		BGT	nodraw			; totally above window? >ymax
		CMP.W #ymax,D3			; CLIP ON YMAX
		BLE.S okmaxy			; check that y2<=ymax 
		MOVE #ymax,D5
		SUB.W	D3,D5			; ymax-y
		MOVE.W D2,D4
		SUB.W	D0,D4			; dx=x2-x1
		MULS	D5,D4			; (ymax-y)*(x2-x1)
		MOVE.W D3,D5
		SUB.W	D1,D5			; dy
		DIVS	D5,D4			; (ymax-y)*(x2-x1)/(y2-y1)
		ADD.W	D4,D2
		MOVE #ymax,D3			; y1=0
okmaxy		TST.W	D1			; CLIP TO YMIN
		BGE.S cliponx
		MOVEQ #0,D5
		SUB.W	D1,D5			; ymin-y
		MOVE.W D2,D4
		SUB.W	D0,D4			; dx=x2-x1
		MULS	D5,D4			; (ymin-y1)*(x2-x1)
		MOVE.W D3,D5
		SUB.W	D1,D5			; dy
		DIVS	D5,D4			; (ymin-y)*(x2-x1)/(y2-y1)
		ADD.W	D4,D0
		MOVEQ #0,D1			; y1=0
cliponx		CMP.W	D0,D2			; CLIP ON X				
		BGE.S	x2big
		EXG	D0,D2			; reorder
		EXG	D1,D3
x2big		TST.W	D2			; totally outside <xmim
		BLT	nodraw
		CMP.W #xmax,D0			; totally outside >xmax
		BGT	nodraw
		CMP.W #xmax,D2			; CLIP ON XMAX
		BLE.S	okmaxx	
		MOVE.W #xmax,D5
		SUB.W	D2,D5			; xmax-x2
		MOVE.W D3,D4
		SUB.W	D1,D4			; y2-y1
		MULS D5,D4			; (xmax-x1)*(y2-y1)
		MOVE.W D2,D5
		SUB.W	D0,D5			; x2-x1
		DIVS D5,D4			; (xmax-x1)*(y2-y1)/(x2-x1)
		ADD.W	D4,D3
		MOVE.W #xmax,D2
okmaxx		TST.W	D0
		BGE.S	.gofordraw
		MOVEQ #0,D5			; CLIP ON XMIN
		SUB.W	D0,D5			; xmin-x
		MOVE.W D3,D4
		SUB.W	D1,D4			; y2-y1
		MULS D5,D4			; (xmin-x)*(y2-y1)
		MOVE.W D2,D5
		SUB.W	D0,D5			; x2-x1
		DIVS D5,D4			; (xmin-x)*(y2-y1)/(x2-x1)
		ADD.W	D4,D1
		MOVEQ #0,D0			; x=xmin
.gofordraw	MOVE.W D2,D4
		SUB.W	D0,D4			; dx
		MOVE.W D3,D5
		SUB.W	D1,D5			; dy
		ADD D2,D2
		ADD D2,D2
		MOVE.L (A2,D2),D6		; mask/chunk offset
		ADD D3,D3
		ADD (A3,D3),D6			; add scr line
		ADDA.W D6,A0			; a0 -> first chunk of line
		SWAP D6				; get mask
		MOVE.W #-160,D3
		TST.W	D5			; draw from top to bottom?
		BGE.S	bottotop
		NEG.W	D5			; no so negate vals
		NEG.W	D3
bottotop	CMP.W	D4,D5			; dy>dx?
		BLT.S	dxbiggerdy

dybiggerdx	MOVE.W D5,D1			; yes!
		BEQ nodraw			; dy=0 nothing to draw(!)
		ASR.W	#1,D1			; e=2/dy
		MOVE.W D5,D2
		SUBQ.W #1,D2			; lines to draw-1(dbf)
.lp		OR.W D6,(A0)
		ADDA.W D3,A0
		SUB.W	D4,D1
		BGT.S	.nostep
		ADD.W	D5,D1
		ADD.W	D6,D6
		DBCS D2,.lp
		BCC.S .drawn
		SUBQ.W #8,A0
		MOVEQ	#1,D6
.nostep		DBF D2,.lp
.drawn		OR.W	D6,(A0)
nodraw		DBF D7,drawline_lp
		RTS

dxbiggerdy	CLR.W	D2
		MOVE.W D4,D1
		ASR.W	#1,D1			; e=2/dx
		MOVE.W D4,D0
		SUBQ.W #1,D0
.lp		OR.W	D6,D2
		SUB.W	D5,D1
		BGE.S	.nostep
		OR.W D2,(A0)
		ADDA.W D3,A0
		ADD.W	D4,D1
		CLR.W	D2
.nostep		ADD.W	D6,D6
		DBCS	D0,.lp
		BCC.S	.drawn
.wrchnk		OR.W	D2,(A0)
		SUBQ.W #8,A0
		CLR.W	D2
		MOVEQ	#1,D6
		DBF	D0,.lp
.drawn		OR.W D6,D2
		OR.W	D2,(A0)
		DBF D7,drawline_lp
		RTS

i		SET 6
bit_offs
	REPT 20
	DC.W $8000,i
	DC.W $4000,i
	DC.W $2000,i
	DC.W $1000,i
	DC.W $0800,i
	DC.W $0400,i
	DC.W $0200,i
	DC.W $0100,i
	DC.W $0080,i
	DC.W $0040,i
	DC.W $0020,i
	DC.W $0010,i
	DC.W $0008,i
	DC.W $0004,i
	DC.W $0002,i
	DC.W $0001,i
i		SET i+8
	ENDR

new_coords	DS.W 200

zspeed		dc.l 0

; Sequence data 
		
		RSRESET

seq_timer	RS.W 1
seq_ptr		RS.L 1
addangx		RS.W 1
addangy		RS.W 1
addangz		RS.W 1
restart_ptr	RS.L 1

seqdata		DC.W 1
		DC.L sequence 
		DS.W 3
		DC.L restart

sequence	DC.W 10	* timer
		DC.W 9	* add angle X
		DC.W 35	* add angle Y
		DC.W 50	* add angle Z
		DC.W -460+2	* zoom
restart		
		DC.W 256,0,-20,0,0
		DC.W -1

nb_surface	equ	17
nbpoint	equ	(nb_surface*4)-1

Stack		Dc.W 0,1024,0
		DC.W nbpoint+1		*	nb de point apres...
		DC.L 0,0,$1200*65536

iPas equ 6
i set -30

.c00:
  dc.w	-30,-30,i	;9   = 5
  dc.w	-30,-10,i	;10
  dc.w	-10,-10,i	;11
  dc.w	-10,-30,i	;12
i set i+iPas
.c01:
  dc.w	-30,-10,i	;13  = 4
  dc.w	-30,+10,i	;14
  dc.w	-10,+10,i	;15
  dc.w	-10,-10,i	;16
i set i+iPas
.c02:
  dc.w	-30,+10,i ;41 = 11
  dc.w	-30,+30,i ;42
  dc.w	-10,+30,i ;43
  dc.w	-10,+10,i ;44
i set i+iPas
.c03:
  dc.w	-10,+10,i	;37 = 10
  dc.w	-10,+30,i	;38
  dc.w	+10,+30, i	;39
  dc.w	+10,+10,i	;40
i set i+iPas
.c04:
  dc.w	+10,+10,i	;33 = 9
  dc.w	+10,+30,i	;34
  dc.w	+30,+30,i	;35
  dc.w	+30,+10,i	;36
i set i+iPas
.c05:
  dc.w	+10,-10,i	;29 = 8
  dc.w	+10,+10,i	;30
  dc.w	+30,+10,i	;31
  dc.w	+30,-10,i	;32
i set i+iPas
.c06:
  dc.w	+10,-30,i	;1  = 1
  dc.w	+10,-10,i	;2
  dc.w	+30,-10,i	;3
  dc.w	+30,-30,i	;4
i set i+iPas
.c07:
  dc.w	-10,-30,i	;5 = 2
  dc.w	-10,-10,i	;6
  dc.w	+10,-10,i	;7
  dc.w	+10,-30,i	;8
i set i+iPas
.c08:
  dc.w	-30,-30,i	;9 = 3
  dc.w	-30,-10,i	;10
  dc.w	-10,-10,i	;11
  dc.w	-10,-30,i	;12
i set i+iPas
.c09:
  dc.w	-30,-10,i	;13  = 4
  dc.w	-30,+10,i	;14
  dc.w	-10,+10,i	;15
  dc.w	-10,-10,i	;16
i set i+iPas
.c10:
  dc.w	-30,+10,i	;17  = 5
  dc.w	-30,+30,i	;18
  dc.w	-10,+30,i	;19
  dc.w	-10,+10,i	;20
i set i+iPas
.c11:
  dc.w	-10,+10,i	;21  = 6
  dc.w	-10,+30,i	;22
  dc.w	+10,+30,i	;23
  dc.w	+10,+10,i	;24
i set i+iPas
.c12:
  dc.w	+10,+10,i	;25  = 7
  dc.w	+10,+30,i	;26
  dc.w	+30,+30,i	;27
  dc.w	+30,+10,i	;28
i set i+iPas
.c13:
  dc.w	+10,-10,i	;29 = 8
  dc.w	+10,+10,i	;30
  dc.w	+30,+10,i	;31
  dc.w	+30,-10,i	;32
i set i+iPas
.c14:
  dc.w	+10,-30,i	;1  = 1
  dc.w	+10,-10,i	;2
  dc.w	+30,-10,i	;3
  dc.w	+30,-30,i	;4
i set i+iPas
.c15:
  dc.w	-10,-30,i	;5 = 2
  dc.w	-10,-10,i	;6
  dc.w	+10,-10,i	;7
  dc.w	+10,-30,i	;8
i set i+iPas
.c16:
  dc.w	-30,-30,i	;9 = 3
  dc.w	-30,-10,i	;10
  dc.w	-10,-10,i	;11
  dc.w	-10,-30,i	;12

	DC.W nbpoint+1		*	nb de ligne apres...

pt_pos_0 set 00
pt_pos_1 set 01
pt_pos_2 set 02
pt_pos_3 set 03
  rept  nb_surface
  dc.w	4*pt_pos_0,4*pt_pos_1,4*pt_pos_1,4*pt_pos_2,4*pt_pos_2,4*pt_pos_3,4*pt_pos_3,4*pt_pos_0
pt_pos_0 set pt_pos_0+4
pt_pos_1 set pt_pos_1+4
pt_pos_2 set pt_pos_2+4
pt_pos_3 set pt_pos_3+4
  endr  

; Create *160 table

create160tb:
		LEA mul_tab,A0
		MOVEQ #0,D0					;create *160 table
		MOVE #199,D1
.loop:
		MOVE D0,(A0)+
		ADD #160,D0
		DBF D1,.loop
		RTS

; Clear last plane of screen - reasonably quickly...

Cls_1_plan:
	move.l	physique(pc),a0
	moveq	#0,d0
	jsr Code_gen
	rts

* Clear last plane of screen - reasonably quickly...
NB_LIGNE_GENERE	equ	200-1
NB_BLOC_SUPP	equ	20-1

Genere_code_cls:
	lea Code_gen,a0
	move.w	#NB_LIGNE_GENERE,d7
	moveq	#0,d4
Genere_pour_toutes_les_lignes:	
	moveq	#NB_BLOC_SUPP,d6
	move.w	d4,d5
	add.w	#PLANcls,d5 * position du cadre
Genere_une_ligne:
	move.w	#$3140,(a0)+		 * Genere un move.w  d0,$xx(a0)
	move.w	d5,(a0)+				 * et voila l'offset $xx
	addq.w	#8,d5            * pixel suivant
	dbra	d6,Genere_une_ligne
	add.w	#160,d4            * ligne suivante
	dbra	d7,Genere_pour_toutes_les_lignes
	move.w	#$4e75,(a0)			 * Et un RTS !!
	rts

***************************************************************
 SECTION	DATA                                             // *
***************************************************************

Al_NoEx_Logo_palette:
	dc.w	$0CCE,$07DF,$0E5E,$0D5E,$0FFF,$055D,$0CCD,$0000
	dc.w	$0557,$07DF,$0E5E,$0D5E,$0FFF,$055D,$0CCD,$0FFF

* Full data here :
* >
message:
	DC.B      $fd ; en 1er plan
	DC.B      "      NOEXTRA PRESENTS IN 2014",0,0
	DC.B      "             GAME NAME",0
	DC.B      "          (C)COMPANY NAME",0,0
	DC.B      "      CRACKED BY.....",$fc,"MAARTAU",$fd,0
	DC.B      "      CODE...........",$fc,"ZORRO 2",$fd,0
	DC.B      "      GFX............",$fc,"MISTER.A",$fd,0
	DC.B      "      MUSIC..........",$fc,"MAD MAX",$fd,0
	DC.B      "      SUPPLIER.......",$fc,"AL-TEAM",$fd,0,0
	DC.B      "      GREETS:DHS.DBUG.ELITE",0
	DC.B      "      ICS.RG.PARADIZE.TSCC",0
	DC.B      "      ZUUL.POV.PULSION.HMD",0
	DC.B      "      IMPACT.EUROSWAP.STAX",0
	DC.B      "      ST KNIGHTS.CV.SECTORONE",0
	DC.B      "      FUZION.LEMMINGS.XTROLL",$ff
	even
fonts:
	incbin	"FONTREPS.DAT"
	even

trig_tab:
	incbin	"TRIGTAB.DAT"
	even

Al_NoEx_Logo_img:
	incbin	"CAPRICO7.IMG"
	even
* <

MUSIC:	* SNDH music -> Not compressed please !!!
	incbin	"*.SND"
	even

***************************************************************
 SECTION	BSS                                              // *
***************************************************************

bss_start:

* < Full data here >

mul_tab:
	ds.w 200

Code_gen:         ds.w	(2*NB_BLOC_SUPP)*NB_LIGNE_GENERE		* Place pour le code genere
									   									* pour l'effacement de l'elt 3d
								  ds.w	1							* Place pour le rts
rien            	ds.b	10000

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

******************************************************************
	END                                                         // *
******************************************************************
