***************************************
* // EXTRA_V5.PRG                  // *
***************************************
* // Asm Intro Code Atari ST v0.42 // *
* // by Zorro 2/NoExtra (05/12/11) // *
* // http://www.noextra-team.com/  // *
***************************************
* // Original code : Zorro 2       // *
* // Gfx logo      : S!nk/HMD      // *
* // Gfx font      : Mister.A      // *
* // Music         : Hellrazor     // *
* // Release date  : 07/03/2013    // *
* // Update date   : 05/12/2017    // *
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
COLOR_TOP_BOTTOM equ $224/2

p_tbase		move.l	sp,save_sp
		move.l	4(sp),save4sp
;--------------------------------------------------------------------------------
supexec		pea	intro(pc)
		move.w	#$26,-(sp)		;supexec
		trap	#14
		addq.l	#6,sp
;--------------------------------------------------------------------------------
		move.l	save_sp(pc),sp
		move.l	save4sp(pc),4(sp)
;================================================================================
load		move.l	#prg_n_1,f_name
		bsr.s	ld_file
		tst.b	flagerr
		bne.s	pterm0
;--------------------------------------------------------------------------------
reloc		jmp	relog(pc)
jump		jmp	(sp)
;--------------------------------------------------------------------------------
pterm0		clr.w	-(sp)			;pterm
		trap	#1
;================================================================================
save_sp		ds.l	1
save4sp		ds.l	1
;================================================================================
ld_file
;--------------------------------------------------------------------------------
fopen		move.w	#2,-(sp)
		move.l	f_name(pc),-(sp)
		move.w	#$3d,-(sp)		;fopen
		trap	#1
		addq.l	#8,sp
		tst.l	d0
		bmi.s	f_error

		move.w	d0,handle

fread		pea	buffer(pc)
		move.l	#$fffff,-(sp)
		move.w	handle(pc),-(sp)
		move.w	#$3f,-(sp)		;fread
		trap	#1
		lea	12(sp),sp
		tst.l	d0
		bmi.s	f_error

		move.l	d0,f_size

fclose		move.w	handle(pc),-(sp)
		move.w	#$3e,-(sp)		;fclose
		trap	#1
		addq.l	#4,sp
		tst.w	d0
		bmi.s	f_error
		rts
;================================================================================
f_error		st	flagerr
		rts

flagerr		ds.b	1
		even
;================================================================================
f_name		ds.l	1

prg_n_1		dc.b	"_boot.prg"
		dc.b	0
		even
;================================================================================
handle		ds.w	1
f_size		ds.l	1
;================================================================================
relog		move.l	f_size(pc),d2
		lea	buffer(pc),a4
		lea	p_tbase(pc),a5
		move.l	a5,d4
		move.l	2(a4),d3
		add.l	6(a4),d3
		tst.w	$1a(a4)
		bne.s	calc_bp
		lea	$1c(a4),a1
		movea.l	a1,a2
		adda.l	2(a4),a2
		adda.l	6(a4),a2
		adda.l	$e(a4),a2
		clr.l	d1
		move.l	(a2)+,d0
		beq.s	calc_bp
.bcle1		add.l	d4,0(a1,d0.l)
.bcle2		move.b	(a2)+,d1
		beq.s	calc_bp
		add.l	d1,d0
		cmp.b	#1,d1
		bne.s	.bcle1
		addi.l	#$fd,d0
		bra.s	.bcle2
calc_bp		movea.l	4(sp),a0
		move.l	2(a4),$c(a0)
		add.l	$c(a0),d4
		move.l	d4,$10(a0)
		move.l	6(a4),$14(a0)
		add.l	$14(a0),d4
		move.l	d4,$18(a0)
		move.l	$a(a4),$1c(a0)
		movea.l	$18(a0),a2
		movea.l	a2,a3
		adda.l	$1c(a0),a3
		movea.l	a4,a0
		adda.l	d2,a0
		cmpa.l	a3,a0
		ble.s	.lbl1
		movea.l	a0,a3
.lbl1		moveq	#(transf-transd)/2-1,d0
		lea	transf(pc),a0
		move.l	a5,-(sp)
.bcle1		move.w	-(a0),-(sp)
		dbf	d0,.bcle1
		lea	$1c(a4),a4
		jmp	jump(pc)
;--------------------------------------------------------------------------------
transd
.bcle2		move.l	(a4)+,(a5)+
		subq.l	#4,d3
		bpl.s	.bcle2
.bcle3		clr.l	(a2)+
		cmpa.l	a2,a3
		bgt.s	.bcle3
		lea	$12(sp),sp
		rts
transf
;================================================================================
buffer
;--------------------------------------------------------------------------------
intro

 IFEQ TEST_STE
	move.l	$5a0,a0                  ; Test if STE computer
	cmp.l	#$0,a0                     ;
	beq	EXIT_PRG                     ; No cookie_jar inside an old ST
	move.l	$14(a0),d0               ;
	cmp.l	#$0,d0                     ; _MCH=0 then it's an ST-STF-STFM
	beq	EXIT_PRG                     ;
 ENDC

	jsr	test_4_ste

	bsr	clear_bss                    ; Clean BSS stack
	
	bsr	Save_and_init_st             ; Save system parameters

	bsr	Init_screens                 ; Screen initialisations

 IFEQ STF_INITS
	jsr	Multi_boot                   ; Multi Atari Boot code from LEONARD/OXG
 ENDC

**************************** MAIN LOOP ************************>

	bsr	Inits                        ; Initialisations

default_loop:

	bsr	Wait_vbl                     ; Waiting after the VBL

 IFEQ	SEEMYVBL
 move.w		#COLOR_TOP_BOTTOM,$ffff8240.w        ; init line of CPU
 ENDC

* < Put your code here >

	bsr	SCROLL16_16

* <

 IFEQ	SEEMYVBL
	cmp.b	#$38,$fffffc02.w           ; ALT key pressed ?
	bne.s	.next_key                  ;
	move.b	#7,$ffff8240.w           ; See the rest of CPU (pink color used)
.next_key:                         ;
 ENDC

	cmp.b	#$39,$fffffc02.w           ; SPACE key pressed ?
	bne	default_loop

	bsr	Stop__Module

**************************** MAIN LOOP ************************<

ESCAPE_PRG:
	bsr	Restore_st                   ; Restore all registers

EXIT_PRG:
	rts

***************************************************************
*                                                             *
*                 Initialisations Routines                    *
*                                                             *
***************************************************************
Inits:
	movem.l	d0-d7/a0-a6,-(a7)

 IFEQ	FADE_INTRO
	bsr	fadein                       ; Fading white to black
 ENDC
	bsr	black_out                    ; Palette colors to zero

	move.l	physique(pc),a0          ; Place le logo
	add.w	#(200-45)*160,a0
	lea	Logo_Noextra,a2
	move.w  #45-1,d7
display:
 rept 8
	move.l	(a2)+,(a0)+
 endr
	lea	160-32(a0),a0
	dbf	d7,display

	movem.l	null,d0-a6               ; Texte Screen #1
	movea.l	physique(pc),a5          ;
	lea	160*2(a5),a5                 ;
	bsr	print_text                   ;

	move.l	physique(pc),a0          ; Texte effet ombre
	bsr	DoBLiTTER__Copy_Buffer       ; with or without Blitter !

	bsr	Play__Module

	lea	Logo_Noextra_palette,a0      ; Put palette
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d7               ;
	movem.l	d0-d7,(a1)               ;

	lea	Vbl(pc),a0                   ; Launch VBL
	move.l	a0,$70.w                 ;

	movem.l	(a7)+,d0-d7/a0-a6
	rts

null:
	ds.l	16

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
SIZE_OF_SCREEN equ 160*200         ; Only Screen size in Low Resolution
 ENDC

Init_screens:
	movem.l	d0-d7/a0-a6,-(a7)

	move.l	#Screen,d0               ; Set physical Screen #1
	add.w	#$ff,d0                    ;
	sf	d0                           ;
	move.l	d0,physique              ;

	move.l	physique(pc),a0          ; Put PATTERN in two Screens
	move.w  #(SIZE_OF_SCREEN)/4-1,d7 ;
	move.l  #PATTERN,(a0)+           ;
	dbf	    d7,*-6                  ;

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

;	movem.l	d0-d7/a0-a6,-(a7)

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
	CLR.B   $FFFFFA1B.W              ; Timer B off
	MOVE.L    #HBL_blanc,$120.W      ; Go Timer B !
	MOVE.B    #4,$FFFFFA21.W        ; First position
	MOVE.B    #8,$FFFFFA1B.W
 ENDC

;	movem.l	(a7)+,d0-d7/a0-a6
RTE:
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
COULEUR equ $0FFF

HBL_blanc:
	CLR.B     $FFFFFA1B.W
	MOVE.w    #COULEUR,$ffff8240.w
	MOVE.L    #HBL_1,$120.W 
	MOVE.B    #1,$FFFFFA21.W 
	MOVE.B    #8,$FFFFFA1B.W
	RTE 

HBL_1:
	CLR.B     $FFFFFA1B.W
	MOVE.w    #$0AA4,$ffff8240.w
	MOVE.L    #HBL_2,$120.W 
	MOVE.B    #186-2,$FFFFFA21.W 
	MOVE.B    #8,$FFFFFA1B.W
	RTE

HBL_2:
	CLR.B     $FFFFFA1B.W
	MOVE.w    #COULEUR,$ffff8240.w
	MOVE.L    #HBL_end,$120.W 
	MOVE.B    #1,$FFFFFA21.W 
	MOVE.B    #8,$FFFFFA1B.W
	RTE 

HBL_end:
	CLR.B     $FFFFFA1B.W
	MOVE.b    #0,$ffff8240.w
	BCLR      #0,$FFFFFA0F.W
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
	bsr	INPUT_TRACE_ERROR            ; Save vectors list
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

 IFEQ	NO_BORDER
	clr.b	$fffffa07.w                ; Interrupt enable A (Timer-A & B)
	clr.b	$fffffa09.w                ; Interrupt enable B (Timer-C & D)
	sf	$fffffa21.w                  ; Timer B data (number of scanlines to next interrupt)
	sf	$fffffa1b.w                  ; Timer B control (event mode (HBL))
	lea	HBL_blanc(pc),a0             ; Launch HBL
	move.l	a0,$120.w                ;
	bset	#0,$fffffa07.w             ; Timer B vector
	bset	#0,$fffffa13.w             ; Timer B on
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

	lea       $ffff8800.w,a0         ; Cut sound
	move.l    #$8000000,(a0)         ; Voice A
	move.l    #$9000000,(a0)         ; Voice B
	move.l    #$a000000,(a0)         ; Voice C

 IFEQ	ERROR_SYS
	bsr	OUTPUT_TRACE_ERROR           ; Restore vectors list
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


***************************************************************
*               PRINT TEXT FONT 3*5 ONE BITPLANE              *
***************************************************************
print_text:
	lea	message,a1
chg:
	move.l	a5,a4
wrp:
	move.l	a4,a0
	lea	ascii,a2
	lea	petite_fonte,a3
	move.b	(a1)+,d0
	beq	bcl1
	cmpi.b	#1,d0
	bne.s	nch
	lea	160*6(a5),a5
	moveq	#0,d5
	bra.s	chg
nch:
	cmp.b	(a2)+,d0
	beq.s	post
	addq.l	#4,d6
	bra.s	nch

post:
	move.l	(a3,d6.w),d0
	moveq	#0,d6
	move.l	d0,d4
	swap	d4
	move.l	d0,d1
	lsr.w	#4,d1
	move.l	d1,d2
	lsr.w	#4,d2
	move.l	d2,d3
	lsr.w	#4,d3
	andi.l	#$f,d0
	andi.l	#$f,d1
	andi.l	#$f,d2
	andi.l	#$f,d3
	andi.l	#$f,d4
	addq.b	#1,d5
	cmpi.b	#1,d5
	beq.s	pos1
	cmpi.b	#2,d5
	beq.s	pos2
	cmpi.b	#3,d5
	beq.s	pos3
	moveq	#0,d5
	addq.l	#8,a4	
	bra.s	rin

pos1:
	lsl.w	#4,d0
	lsl.w	#4,d1
	lsl.w	#4,d2
	lsl.w	#4,d3
	lsl.w	#4,d4
pos2:
	lsl.w	#4,d0
	lsl.w	#4,d1
	lsl.w	#4,d2
	lsl.w	#4,d3
	lsl.w	#4,d4
pos3:
	lsl.w	#4,d0
	lsl.w	#4,d1
	lsl.w	#4,d2
	lsl.w	#4,d3
	lsl.w	#4,d4
rin:
	or.w	d4,(a0)
	or.w	d3,160(a0)
	or.w	d2,320(a0)
	or.w	d1,480(a0)
	or.w	d0,640(a0)
	bra	wrp
bcl1:
	rts

***************************************************************
*              SCROLLTEXT FONT 16*16 ONE BITPLAN              *
***************************************************************
SCROLL16_16:
      BSR       .next1 
      BSR       .next1 
      ADDQ.W    #1,count_pas
      CMPI.W    #8,count_pas
      BNE.S     .next0 
      CLR.W     count_pas 
      ADDQ.L    #1,CPT_CARAC
      MOVEA.L   CPT_CARAC,A0
      CMPI.B    #$F0,(A0) 
      BNE.S     .next 
      MOVE.L    #TEXTE,CPT_CARAC
      LEA       TEXTE,A0
.next:CLR.W     D0
      MOVE.B    (A0),D0 
      ROL.W     #5,D0 
      LEA       FONTE_16x16,A0
      ADDA.W    D0,A0 
      LEA       buffer_font,A1
      MOVE.W    (A0)+,0(A1)
      MOVE.W    (A0)+,42(A1)
      MOVE.W    (A0)+,84(A1)
      MOVE.W    (A0)+,126(A1) 
      MOVE.W    (A0)+,168(A1) 
      MOVE.W    (A0)+,210(A1) 
      MOVE.W    (A0)+,252(A1) 
      MOVE.W    (A0)+,294(A1) 
      MOVE.W    (A0)+,336(A1) 
      MOVE.W    (A0)+,378(A1) 
      MOVE.W    (A0)+,420(A1) 
      MOVE.W    (A0)+,462(A1) 
      MOVE.W    (A0)+,504(A1) 
      MOVE.W    (A0)+,546(A1) 
      MOVE.W    (A0)+,588(A1) 
      MOVE.W    (A0)+,630(A1) 
.next0:
      movea.l   physique(pc),A1
      lea	160*164+8*1(a1),a1
      LEA       ptr_buffer_font,A0
      BSR       PUT_CARAC 
      RTS 
.next1:LEA       count_pas,A0
      dcb.w	8*40,$E5E0	; ROXL      -(A0)
      RTS 

PUT_CARAC:
 rept	16
      MOVE.W    (A0)+,(A1)
      MOVE.W    (A0)+,8(A1) 
      MOVE.W    (A0)+,16(A1)
      MOVE.W    (A0)+,24(A1)
      MOVE.W    (A0)+,32(A1)
      MOVE.W    (A0)+,40(A1)
      MOVE.W    (A0)+,48(A1)
      MOVE.W    (A0)+,56(A1)
      MOVE.W    (A0)+,64(A1)
      MOVE.W    (A0)+,72(A1)
      MOVE.W    (A0)+,80(A1)
      MOVE.W    (A0)+,88(A1)
      MOVE.W    (A0)+,96(A1)
      MOVE.W    (A0)+,104(A1) 
      MOVE.W    (A0)+,112(A1) 
      MOVE.W    (A0)+,120(A1) 
      MOVE.W    (A0)+,128(A1) 
      MOVE.W    (A0)+,136(A1) 
      MOVE.W    (A0)+,144(A1) 
      ADDQ.L    #4,A0 
      LEA       160(A1),A1	
 endr
      RTS 

***************************************************************
*                 LINE-A BITBLT Instructions                  *
***************************************************************
DoBLiTTER__Copy_Buffer:
  movem.l	d0-d7/a0-a6,-(sp)	;preserve registers
  lea	bitblt(pc),a6		;address of blit table
  move.l	a0,18(a6)		;store 'from' address
  lea	6(a0),a1
  move.l	a1,32(a6)		;store 'to' address
  move.w	#0,14(a6)		;store left from position
  move.w	#0,16(a6)		;store top from position
  move.w	#0+1,28(a6)		;store left to position
  move.w	#0+1,30(a6)		;store top to position
  move.w	#320,0(a6)	;store width. 
  move.w	#150,2(a6)	;store height.
  move.w	#1,4(a6)		;set up number of plan
  move.w	#8,22(a6)		;for low resolution
  move.w	#8,36(a6)
  move.l	#0,42(a6)		;set up blit variables 
  move.b	#3,10(a6)		;for any resolution
  move.w	#0,6(a6)
  move.w	#0,8(a6)
  dc.w	$a007			;do the blit!
  movem.l	(sp)+,d0-d7/a0-a6	;restore registers
  rts				;and return.
  
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

; *************************************************************************
; ***                      Replayer Mods for ST and STe                 ***
; ***                    by WizzCat the 21st of May 1991                ***
; *************************************************************************
Play__Module:
	tst.w	ste_flag                   ; Install Music
	bne.s	init_ste
	bsr	muson_stfm
	bra.s	init_stfm_ok
init_ste:
	bsr	muson_ste
init_stfm_ok:
	rts

Stop__Module:
	tst.w	ste_flag                   ; Stop Music
	bne.s	.shut_down_ste
	bsr	musoff_stfm
	bra.s	musoff_stfm_e
.shut_down_ste:
	bsr	musoff_ste
musoff_stfm_e:
	rts

 include	"PLAYER.ASM"
 even

***************************************************************
 SECTION	DATA                                             // *
***************************************************************

* < Full data here >

petite_fonte:
	dc.l	$0004aeaa ; a
	dc.l	$000cacac ; b
	dc.l	$00068886 ; c
	dc.l	$000caaac ; d
	dc.l	$00068c86 ; e
	dc.l	$000e8c88 ; f
	dc.l	$00068aa6 ; g
	dc.l	$000aaeaa ; h
	dc.l	$00040c4e ; i
	dc.l	$000222a4 ; j
	dc.l	$000aacaa ; k
	dc.l	$00088886 ; l
	dc.l	$000aeeaa ; m
	dc.l	$000aeaaa ; n
	dc.l	$0006aaae ; o
	dc.l	$000cac88 ; p
	dc.l	$000caaa6 ; q
	dc.l	$000cacaa ; r
	dc.l	$0006842c ; s
	dc.l	$000e4444 ; t
	dc.l	$000aaaa4 ; u
	dc.l	$000aaaa4 ; v
	dc.l	$000aaaea ; w
	dc.l	$000aa4aa ; x
	dc.l	$000aa444 ; y
	dc.l	$000e248e ; z
	dc.l	$00000000 ; ESPACE
	dc.l	$0004aaa4 ; 0
	dc.l	$000c444e ; 1
	dc.l	$000ea2ce ; 2
	dc.l	$000e242e ; 3
	dc.l	$00088ae2 ; 4
	dc.l	$000e8c2c ; 5
	dc.l	$00068eae ; 6
	dc.l	$000e2488 ; 7
	dc.l	$000ea4ae ; 8
	dc.l	$000eae2c ; 9
	dc.l	$00004040 ; :
	dc.l	$00044404 ; !
	dc.l	$00000448 ; ,
	dc.l	$00004048 ; ;
	dc.l	$00000004 ; .
	dc.l	$0004a244 ; ?
	dc.l	$00044000 ; '
	dc.l	$00024488 ; /
	dc.l	$00088442 ; \
	dc.l	$0000000e ; _
	dc.l	$00000e00 ; -
	dc.l	$00024842 ; (
	dc.l	$00084248 ; )
	dc.l	$00044444 ; |
	dc.l	$000cc000 ; #
	dc.l	$000a4e4a ; *
	dc.l	$0008cec8 ; >
	dc.l	$00026e62 ; <
	dc.l	$000c888c ; [
	dc.l	$00062226 ; ]

ascii:
	dc.b	"abcdefghijklmnopqrstuvwxyz 0123456789:!,;.?'/\_-()|#*><[]",0
	even
message:
 DC.B "                                                                                ",1
 DC.B "                                      __ ____ _ _______________                 ",1
 DC.B "                        ______. ________________         /     \                ",1
 DC.B "                ________\_    |______    _     / _      /   _   \               ",1
 DC.B "              _/    _____/    |     /    \ ___/ _/   __/    |    \              ",1
 DC.B "             /    _____/_     _  __/      \     \     \__         \             ",1
 DC.B "           _/      /     \_   |    \_      \     \      /   |      \_           ",1
 DC.B "           \      /      _/___|     /       \ ____\    /____:_______/           ",1
 DC.B "            \____________/ -- |    /_________\   --\  /---   - ----             ",1
 DC.B "                              :___/-extra-          \/                          ",1,1
 DC.B "                     /\/ noextra presents extra volume 5 \/\",1,1
 DC.B "               > the bluesie megademo from the black moon's group <",1
 DC.B "                     code and graph : strix * music : stephy",1,1
 DC.B "          [code] fast intro by zorro2    [supplier] jace of st knights",1,1
 DC.B "            [muzik] hellrazor of trsi    [logo] sink of hemoroids",1,1
 DC.B "                  [extra code] all asm code redid by maartau",1,1
 DC.B "greetings:dbug.elite.ics.rg.paradize.st knights.tscc.zuul.replicants.dhs.eqx.",1
 DC.B "pulsion.hmd.impact.euroswap.stax.oxygene.lemmings.sector one.x-troll.dune.tce.",1
 DC.B "bsw.fuzion.atari-legend.effect.xmen.supremacy.typhoon.pdx.checkpoint.pov.cv.",0
 even

FONTE_16x16:
	incbin	"CHAR16.RAW"
	even
CPT_CARAC:
	DC.L	TEXTE
* ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789 /*-+.,;:!?()$',$27
TEXTE:
	DC.B	"          A FEW YEARS AGO BUT...    NOW IT'S TIME TO PRESENT YOU THE EXTRA MENU V !!! "
	DC.B	"A SPECIAL MENU DEDICATED TO THE BLACK MOON'S GROUP WITH THEIR MEGADEMO CALL BLUESIE. "
	DC.B	"SPECIAL THANKS TO A MEMBER OF NOEXTRA : MAARTAU WHO HAS GIVEN A BUNCH OF TIME TO  "
	DC.B	"MAKE THIS DEMO MUCH COMFORTABLE TO SEE TODAY, NO RESET AND MUSIC REPLAYER "
	DC.B	"VERY OPTIMISED FOR A BETTER SOUND !                                        "
	DC.B	"I LET STRIX (CODER) AND STEPHY (MUSICIAN) OF THE BLACK MOON'S GROUP TO TALK ABOUT OUR PAST AND "
	DC.B	"THANK YOU SO MUCH MATES TO GIVE US A GOOD PLEASURE TO COME BACK IN 90'S.                                  "
* Codeur
	DC.B	"THE BLUESIE DEMO, OR HOW GEEKS SPENT THEIR TIME NAIVELY IN THE EARLY 90S. AS TEENAGERS, "
	DC.B	"WE SPENT AN INCREDIBLE AMOUNT OF TIME CODING ASSEMBLER, DRAWING OR CREATING MUSIC ON THE "
	DC.B	"ATARI ST. BACK IN 1991, I ALSO WASN'T REALLY AWARE OF WHAT RIPPING OTHERS FONTS OR MUSICS "
	DC.B	"MEANT, SO I LAMELY INCLUDED OTHERS WORKS IN MINE. SHAME ON US ?? ANYWAY, THE DEMO WAS "
	DC.B	"BASICALLY GIVEN TO VERY FEW  FRIENDS BUT WE WERE ALWAYS VERY PROUD OF WHAT WE CREATED. "
	DC.B	"WHEN I LOOK BACK, I FIND IT AMAZING THAN BEFORE THE INTERNET (BUT THANKS TO ST MAG!) I "
	DC.B	"MANAGED TO LEARN CODING THE 68000. WHILE I OFTEN STARTED CREATING GAMES BUT RARELY FINISHED "
	DC.B	"CODING THEM, DEMOS WERE MUCH EASIER TO FINALIZE... AND I EVEN NAMED THIS ONE FROM MY "
	DC.B	"GIRLFRIEND NICKNAME, BACK THEN! IT WAS ALSO A GREAT PLEASURE TO INCLUDE MY FRIENDS GRAPHIC "
	DC.B	"AND MUSIC IN THESE. I'M SURE THAT THE BLACK MOON'S GROUP ARE THE LEAST KNOW DEMO MAKERS AND "
	DC.B	"MAYBE THAT'S THE FOR THE BEST ;)                     "
* Musicien
	DC.B	"STEPHY FROM BMG SPEAKING : AFTER ALL THESE YEARS....MY FIRST QUARTET SONGS SEEMS "
	DC.B	"COMPLETELY OUTDATED....BUT IT WAS SOME GLORIOUS DAYS OF OUR LIVES. ALL OUR FREE TIME "
	DC.B	"SPENT DOING THIS. CODING, COMPOSING....HAPPY AND LONG LIFE TO THE BLUESIE DEMO 2017 !! "
	DC.B	"STEPHY/BMG AKA HI$C@N/BMK                                                              "
*
	DC.B	"THIS IS THE LAST MENU AND PROJECT OF NOEXTRA-TEAM IN 2017 ! ENJOY ! ATARI FOR FUN !    "
	DC.B	"                                                                                       "
	DC.B	"ALL ASM SOURCES ARE READY ON YOUR GITHUB AT THSI ADRESS : HTTPS://GITHUB.COM/NOEXTRA-TEAM/SOURCES. "
	DC.B	"                                  ENJOY !                                              "
	DC.W	$F000
	even

Logo_Noextra_palette:
	dc.w	$0223,$0fff,$0888,$0000,$0312,$0422,$0553,$0000
	dc.w	$0111,$0fff,$0000,$0000,$0000,$0000,$0000,$0777
 	
Logo_Noextra:
	incbin	"LOGO.IMG" ; 64x44 
	even

mod_data:
	incbin	"feedyour.mod"
	even
	ds.b	18000*1	; Workspace
workspc:
	ds.w	1

* <

***************************************************************
 SECTION	BSS                                              // *
***************************************************************

bss_start:

* < Full data here >

ptr_buffer_font:
	ds.w	20
buffer_font:
	ds.w	316 
count_pas:
	ds.l	1

* <

Vsync:
	ds.w	1

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

Screen:
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
	moveq #10-1,d0                    ; On dtourne toutes les erreur possibles...
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
	move.w #$2700,SR                  ; Deux erreurs  suivre... non mais !

	move.w	#$0FF,d1
.loop:
	move.w d0,$ffff8240.w             ; Effet raster
	move.w #0,$ffff8240.w
	cmp.b #$3b,$fffffc02.w
	dbra d1,.loop

	pea ESCAPE_PRG                        ; Put the return adress
	move.w #$2700,-(sp)               ; J'espre !!!...
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

