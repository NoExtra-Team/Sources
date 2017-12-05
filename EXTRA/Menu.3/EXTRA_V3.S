***************************************
* // EXTRA_V3.PRG                  // *
***************************************
* // Asm Intro Code Atari ST v0.42 // *
* // by Zorro 2/NoExtra (05/12/11) // *
* // http://www.noextra-team.com/  // *
***************************************
* // Original code : Zorro 2       // *
* // Gfx logo      : Mister.A      // *
* // Gfx font      : Mister.A      // *
* // Music         : ANTICHRIST    // *
* // Release date  : 11/02/2010    // *
* // Update date   : 22/04/2012    // *
***************************************
  OPT c+ ; Case sensitivity on        *
  OPT d- ; Debug off                  *
  OPT o- ; All optimisations off      *
  OPT w- ; Warnings off               *
  OPT x- ; Extended debug off         *
***************************************

*/
; SPS : christophe.douy@laposte.net (CHRISTOPHE DOUY)
; JEDI : f@skyrok.com (FRANK DENIS)
; ODC : sebastienfaivre@gmail.com (SEBASTIEN FAIVRE)
; HELLO : hellosct1@hotmail.com (CHRISTOPHE VILLENEUVE)
*/

***************************************************************
	SECTION	TEXT                                             // *
***************************************************************

*************************** PARAMETERS *****************************
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

	bsr	Init                         ; Initialisations

**************************** MAIN LOOP ************************>

	move.w	#0,CPT_ANIMS
	move.l	#Buffer_L7z,Ptr_Buffer_L7z

MainLoop:

	bsr	Wait_vbl                     ; Waiting after the VBL

	IFEQ	SEEMYVBL
	move.w	#$0012,$ffff8240.w
	ENDC

* < Put your code here >

	move.l	Ptr_Buffer_L7z,a0
	movea.l	physique(pc),a1
	lea	160*144+6(a1),a1
	move	#124-1,d1                  ; number of lines
.loop;
i	set	0
	rept	20                         ; repeat chunks (1 chunk=16 pixels)
	move.w	i(a0),i(a1)              ; copy 1st half of a chunk (logical)
i	set	i+8                          ; next chunk
	endr                             ; end of copying chunks
	add.l	#160,a0                    ; next scanline line for logical
	add.l	#160,a1                    ; next scanline line for piccy
	dbf	d1,.loop                     ; end of copying lines
	move.l	a0,Ptr_Buffer_L7z

	bsr	draw_bottom_logo

	add.w	#1,CPT_ANIMS
	cmp.w	#32,CPT_ANIMS
	blt.s	do_wave
	move.w	#0,CPT_ANIMS
	move.l	#Buffer_L7z,Ptr_Buffer_L7z
do_wave:

	bsr	Run_Scroll1p

	BSR	KEYPAD                       ; mvt de la barre 
	BSR	MVT_BARRE 

* <

	lea     physique(pc),a2          ; Swapping two Screens
	move.l	(a2),d2                  ;
	move.l	4(a2),(a2)+              ;
	move.l	d2,(a2)                  ;
	move.b  d2,$ffff820d.w           ;
	move    d2,-(sp)                 ;
	move.b  (sp)+,d2                 ;
	move.l  d2,$ffff8200.w           ;

	IFEQ	SEEMYVBL
	cmp.b	#$38,$fffffc02.w           ; ALT key pressed ?
	bne.s	next_key                   ;
	move.b	#7,$ffff8240.w           ; See the rest of CPU
next_key:                          ;
	ENDC

	cmp.b	#$1,$fffffc02.w		* ESC KEY ?
	beq.s	EscapeKey

	cmp.b	#$39,$fffffc02.w	* SPACE KEY ?
	bne	MainLoop

	ADD.L    #2,$40.W
	bra.s	EXIT

EscapeKey:
	MOVE.L   #1,$40.W

**************************** MAIN LOOP ************************<

EXIT:
	bsr	Restore_st                   ; Restore all registers

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

	move.l	#adzic1,adzicp

	move.w	#0,play
	bsr	Init_musique_THK

	move.w	#1,play
	bsr	Init_musique_THK

	movea.l	physique+4(pc),a1
	adda.l	#160*82,a1
	movea.l	#IMG_INTRO,a0
	move.l	#160*32/4-1,d0
	move.l	(a0)+,(a1)+
	dbf	d0,*-2

	lea	Vbl0(pc),a0
	move.l	a0,$70.w

	lea	Pal_img_intro,a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

	; Initialisation(s)
	move.l	#ANIMS,a0                ; datas anims compressed
	move.l	#Buffer_L7z,a1           ; buffer destination
	bsr	d_lz77                       ; decompress data in a0 -> a1

	; Temporisation Falcon
	move.l	$44.w,d0                 ; Récupère la touche renvoyée par le menu
	cmp.l	#$12345678,d0              ; Test value
	bne.s	.no_falcon

	move.w	#50,d7                   ; Attente
.wait_more:
	bsr	Wait_vbl
	dbra	d7,.wait_more

.no_falcon:
	CLR.W   POSITION_BARRE           ; initialise barre de navigation
	MOVE.B  #10,HBL_POS_1            ; debut de la barre
	MOVE.B  #131,HBL_POS_2           ; fin de la barre
	MOVE.W	#0,BAR_TEMPO             ; temporisation a chaque deplacement de la barre  
	CLR.L   $40.W

	bsr	fadeoff

	move.l	physique+4(pc),a1
	move.w  #(SIZE_OF_SCREEN)/4-1,d7
	move.l  #PATTERN,(a1)+
	dbf	    d7,*-6

	bsr	draw_logo
	bsr	draw_bottom_logo

	bsr	print_text

	move.l	physique(pc),d0
	move.b	d0,d1
	lsr.w	#8,d0
	move.b	d0,$ffff8203.w
	swap	d0
	move.b	d0,$ffff8201.w
	move.b	d1,$ffff820d.w

	lea	Vbl_music2(pc),a0
	move.l	a0,$70.w

	bsr	Wait_vbl

	lea	Pal,a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

	bsr	Init_Scroll1p

	movem.l	(a7)+,d0-d7/a0-a6
	rts

***************************************************************
*                                                             *
*                       Screen Routines                       *
*                                                             *
***************************************************************
SIZE_OF_SCREEN equ 160*300        ; Screen + Top & Lower Border size

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

	move.l	physique+4(pc),d0          ; Put physical Screen
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
Vbl0:	movem.l	d0-d7/a0-a6,-(a7)

	st	Vsync

	bsr	Play_musique_THK
	
	movem.l	(a7)+,d0-d7/a0-a6
	rte

Vbl_music1:
	clr.b   $fffffa1b.w              ; Timer B off

	st	Vsync

	MOVE.L    #HBL_blanc,$120.W 
	MOVE.B    #$63,$FFFFFA1F.W
	MOVE.B    #4,$FFFFFA19.W
	MOVE.B    #62-27,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W

	bsr	Play_musique_THK

	rte

Vbl_music2:
	clr.b   $fffffa1b.w              ; Timer B off

	st	Vsync

	MOVE.L    #HBL_blanc,$120.W 
	MOVE.B    #$63,$FFFFFA1F.W
	MOVE.B    #4,$FFFFFA19.W
	MOVE.B    #62-27,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W

	bsr	Play_musique_THK

	rte

Wait_vbl:                          ; Test Synchronisation
	move.l	a0,-(a7)                 ;
	lea	Vsync,a0                     ;
	sf	(a0)                         ;
.loop:	tst.b	(a0)                 ;
	beq.s	.loop                      ;
	move.l	(a7)+,a0                 ;
	rts

***************************************************************
*                                                             *
*          < Here is the top and lower border rout >          *
*                                                             *
***************************************************************
palette_fond equ $ffff8250
couleur_fond equ $0012
couleur_fonte equ $0eff
couleur_barre equ $0303+$603
couleur1 equ $0603
couleur2 equ $0503
couleur3 equ $0403
couleur4 equ $0303
couleur5 equ $0203

TIMER_A:        MOVE      #$2100,SR 
                STOP      #$2100
                MOVE      #$2700,SR 
                CLR.B     $FFFFFA19.W 
                MOVEM.L   A0-A1/D0-D7,-(A7) 
                rept 60
                NOP 
                endr
                MOVE.B    #0,$FFFF820A.W
                rept 7
                NOP 
                endr
                CLR.W     D1
                MOVEA.W   #$8209,A0 
                MOVE.B    #2,$FFFF820A.W
                MOVEM.L   (A7)+,A0-A1/D0-D7 
RTE:            RTE 

HBL_blanc:      CLR.B     $FFFFFA1B.W
                MOVE.W    #couleur2,palette_fond.W
                MOVE.L    #HBL,$120.W 
                MOVE.B    #1,$FFFFFA21.W 
                MOVE.B    #8,$FFFFFA1B.W
                RTE 

HBL:            CLR.B     $FFFFFA1B.W
                MOVE.L    #HBL1,$120.W 
                MOVE.B    HBL_POS_1,$FFFFFA21.W
                MOVE.B    #8,$FFFFFA1B.W
                RTE 

HBL1:           CLR.B     $FFFFFA1B.W
                MOVE.w    #couleur_barre,$ffff8240.w
                MOVE.L    #HBL2,$120.W 
                MOVE.B    #10,$FFFFFA21.W 
                MOVE.B    #8,$FFFFFA1B.W
                RTE 
      
HBL2:           CLR.B     $FFFFFA1B.W
                MOVE.W    #couleur_fond,$ffff8240.W
                MOVE.L    #HBL_blanc2,$120.W 
                MOVE.B    HBL_POS_2,$FFFFFA21.W
                MOVE.B    #8,$FFFFFA1B.W     
                RTE 

HBL_blanc2:     CLR.B     $FFFFFA1B.W
                MOVE.W    #couleur3,palette_fond.W
                MOVE.L    #HBL_noir2,$120.W 
                MOVE.B    #22,$FFFFFA21.W 
                MOVE.B    #8,$FFFFFA1B.W
                RTE 
      
HBL_noir2:      CLR.B     $FFFFFA1B.W
                MOVE.W    #couleur4,palette_fond.W
                MOVE.W    #couleur_fond,$ffff8240.W
                MOVE.W    #couleur_fonte,$ffff8242.W
                MOVE.L    #BORDER_END,$120.W 
                MOVE.B    #19,$FFFFFA21.W 
                MOVE.B    #8,$FFFFFA1B.W
                RTE 

BORDER_END:     CLR.B     $FFFFFA1B.W 
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
                MOVE.W    #couleur5,palette_fond.W
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

	MOVE.B    #$21,$FFFFFA07.W
	MOVE.B    #$21,$FFFFFA13.W
	CLR.B     $FFFFFA09.W 
	CLR.B     $FFFFFA15.W 
	CLR.B     $FFFFFA19.W 
	CLR.B     $FFFFFA1B.W 
	MOVE.L    #RTE,$68.W
	MOVE.L    #TIMER_A,$134.W 
	MOVE.L    #HBL_blanc,$120.W 

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

	sf	$ffff8260.w                  ; Low resolution

	rts

Restore_st:

	moveq #$13,d0                    ; Pause keyboard
	bsr	sendToKeyboard               ;

	move #$2700,sr

	move.w	#0,play
	bsr	Stop_musique_THK

	move.w	#1,play
	bsr	Stop_musique_THK

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

***************************************************************
*                                                             *
*       MEGATIZER MUSICS VIA VBL BY ATOMUS/NOEXTRA-TEAM       *
*                                                             *
***************************************************************
Init_musique_THK:
	move.w	play(pc),d0
	movea.l	adzicp(pc),a0
	add.w	d0,d0
	add.w	d0,d0
	movea.l	0(a0,d0.w),a0
	moveq	#1,d0
	jsr	(a0)
	rts

Play_musique_THK:
	move.w	play(pc),d0
	movea.l	adzicp(pc),a0
	add.w	d0,d0
	add.w	d0,d0
	movea.l	0(a0,d0.w),a0
	jsr	8(a0)
	rts

Stop_musique_THK:
	move.w	play(pc),d0
	movea.l	adzicp(pc),a0
	add.w	d0,d0
	add.w	d0,d0
	movea.l	0(a0,d0.w),a0
	jsr	4(a0)
	rts

Play_musique_1_THK:
	move.w	#0,play
	lea	Vbl_music1(pc),a0
	move.l	a0,$70.w
	rts

Play_musique_2_THK:
	move.w	#1,play
	lea	Vbl_music2(pc),a0
	move.l	a0,$70.w
	rts

************************************************
*           FADING COLOR TO BLACK              *
************************************************
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
	rept	6
	bsr	Wait_vbl
	endr
	dbra	d0,.loop1	Next stage
	rts

***************************************************************
*                                                             *
*         BARS RASTER MOVEMENT BY ZORRO2/NOEXTRA-TEAM         *
*                                                             *
***************************************************************
KEYPAD:         CMPI.B    #$48,$FFFFFC02.W	; CURSEUR HAUT
                BNE.s     .suite 
                CMPI.W    #0,POSITION_BARRE
                BEQ.s     .suite 
                MOVE.W    #1,SENS_BARRE
.suite:         CMPI.B    #$50,$FFFFFC02.W	; CURSEUR BAS
                BNE.s     .f1
                CMPI.W    #10,POSITION_BARRE
                BEQ.s     .f1
                MOVE.W    #2,SENS_BARRE
.f1:            CMPI.B    #$3B,$FFFFFC02.W	; F1
                BNE.s     .f2
                BSR       Play_musique_1_THK
                BRA.s     .fin
.f2:            CMPI.B    #$3C,$FFFFFC02.W	; F2
                BNE.s     .fin
                BSR       Play_musique_2_THK
.fin:           RTS 

MVT_BARRE:      CMPI.W    #1,SENS_BARRE
                BNE.s     .bas 
.haut:          SUBQ.B    #1,HBL_POS_1
                ADDQ.B    #1,HBL_POS_2
                ADD.W     #1,BAR_TEMPO
                CMPI.W    #12,BAR_TEMPO
                BlE.S    .fin
                CLR.W     SENS_BARRE 
                MOVE.W	  #0,BAR_TEMPO
                SUBI.W    #1,POSITION_BARRE
                SUB.L     #1,$40.W
.bas:           CMPI.W    #2,SENS_BARRE
                BNE.s     .fin 
                ADDQ.B    #1,HBL_POS_1
                SUBQ.B    #1,HBL_POS_2
                ADD.W     #1,BAR_TEMPO
                CMPI.W    #12,BAR_TEMPO
                BlE.S     .fin
                CLR.W     SENS_BARRE 
                MOVE.W    #0,BAR_TEMPO
                ADDI.W    #1,POSITION_BARRE
                ADD.L     #1,$40.W
.fin:           RTS 

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
      
IncCompteur:BSR       Vague_2 
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
      LEA       COURBE,A4
.next:MOVE.L    A4,PTR_COURBE
      MOVEA.L   physique(pc),A3
      add.l     #160*216,A3
      LEA       POSITION,A2
      MOVEQ     #$13,D0 
      MOVEQ     #0,D6 
.loop:LEA       0(A3,D6.W),A1 
      MOVEA.L   A1,A5 
      LEA       1(A5),A5
      ADDA.W    (A4)+,A1
      CMPI.W    #$FFFF,(A4) 
      BNE.S     .suivant 
      LEA       COURBE,A4
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
*         DISPLAY LOGO NOEXTRA - ZORRO2/NOEXTRA-TEAM          *
*                                                             *
***************************************************************
draw_logo:
	move.l	#LOGO_NO,a3
	movea.l	physique(pc),a4		copy to the right
	lea	160*4(a4),a4
	movea.l	physique+4(pc),a5		copy to the right
	lea	160*4(a5),a5
	move	#136,d1		;lines
.loop;
i	set	0		set to 0
	rept	4			repeat chunks (1 chunk=16 pixels)
	move.l	i(a3),i(a4)	copy 1st half of a chunk (logical)
	move.l	i+4(a3),i+4(a4)	copy 1st half of a chunk (logical)
	move.l	i(a3),i(a5)	copy 1st half of a chunk (logical)
	move.l	i+4(a3),i+4(a5)	copy 1st half of a chunk (logical)
i	set	i+8		next chunk
	endr			end of copying chunks
	add.l	#160,a3		next scanline line for logical
	add.l	#160,a4		next scanline line for piccy
	add.l	#160,a5		next scanline line for piccy
	dbf	d1,.loop		end of copying lines
	rts

draw_bottom_logo:
*> Reste du logo
	move.l	#LOGO_NO,a3
	lea	160*(143-7)(a3),a3
	movea.l	physique(pc),a4		copy to the right
	lea	160*140(a4),a4
	movea.l	physique+4(pc),a5		copy to the right
	lea	160*140(a5),a5
	move	#8,d1		;lines
.loopZ:
i	set	0		set to 0
	rept	4			repeat chunks (1 chunk=16 pixels)
	move.l	i(a3),i(a4)	copy 1st half of a chunk (logical)
	move.l	i+4(a3),i+4(a4)	copy 1st half of a chunk (logical)
	move.l	i(a3),i(a5)	copy 1st half of a chunk (logical)
	move.l	i+4(a3),i+4(a5)	copy 1st half of a chunk (logical)
i	set	i+8		next chunk
	endr			end of copying chunks
	add.l	#160,a3		next scanline line for logical
	add.l	#160,a4		next scanline line for piccy
	add.l	#160,a5		next scanline line for piccy
	dbf	d1,.loopZ		end of copying lines
*> Bas du logo
	move.l	#LOGO_NO,a3
	lea	4*8(a3),a3
	movea.l	physique(pc),a4		copy to the right
	lea	160*149(a4),a4
	movea.l	physique+4(pc),a5		copy to the right
	lea	160*149(a5),a5
	move	#77,d1		;lines
.loopA:
i	set	0		set to 0
	rept	4			repeat chunks (1 chunk=16 pixels)
	move.l	i(a3),i(a4)	copy 1st half of a chunk (logical)
	move.l	i+4(a3),i+4(a4)	copy 1st half of a chunk (logical)
	move.l	i(a3),i(a5)	copy 1st half of a chunk (logical)
	move.l	i+4(a3),i+4(a5)	copy 1st half of a chunk (logical)
i	set	i+8		next chunk
	endr			end of copying chunks
	add.l	#160,a3		next scanline line for logical
	add.l	#160,a4		next scanline line for piccy
	add.l	#160,a5		next scanline line for piccy
	dbf	d1,.loopA		end of copying lines
	rts

***************************************************************
*                                                             *
*         TEXT FONT 8*8 ONE PLANE BY AVENGER/AL TEAM          *
*  ADAPTED FOR EXTRA FONT OF MISTER.A BY ZORRO2/NOEXTRA-TEAM  *
*                                                             *
***************************************************************
CHARS      equ 40  ; chars per line, 80=for med res, 40 for low res
LINES      equ 33  ; 33 for 8x8 font, 45 with 6x6 font 
FONTSIZE   equ 8   ; 8=8x8, 6=6x6 font
SHIFTSIZE  equ 4   ; 2=MED RESOLUTION, 4=FOR LOW RESOLUTION

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
                lea     fonte1(pc),a1	
                sub.w	#256,d0         
                adda.w  d0,a1
                
                movea.l physique(pc),a0
                lea     160*8(a0),a0
                add.w   #0+8*4,a0
                adda.l  y_offset(pc),a0
                adda.l  x_offset(pc),a0
                
                movea.l physique+4(pc),a3
                lea     160*8(a3),a3
                add.w   #0+8*4,a3
                adda.l  y_offset(pc),a3
                adda.l  x_offset(pc),a3
                
                rept	FONTSIZE
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
                addi.l  #(FONTSIZE*160)+160*5,y_offset ; linefeed when reached ',0'
                cmpi.l  #LINES*FONTSIZE*160,y_offset
                bls     new_char
                move.l  #LINES*FONTSIZE*160,y_offset
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

******************************************
*                                        *
* Very! fast lz77 decompression routine  *
* 68000 version                          *
*                                        *
******************************************
 include "LZ77_130.ASM"

***************************************************************
 SECTION	DATA                                             // *
***************************************************************

Pal:	
	dc.w	$0012,$07FF,$06EE,$0BDD,$0C66,$0566,$04DD,$0892
	dc.w	$0F00,$0E77,$0355,$0677,$013B,$0DEE,$0777,$0FFF
Pal_img_intro:
	dc.w	$099A,$09AB,$0112,$0234,$0345,$0456,$0567,$0577
	dc.w	$0022,$00BA,$08C3,$09D4,$03EB,$0574,$0EFD,$0123
* Full data here :
* >
*> Musics
play:
	dc.w	$0
adzicp:
	dc.l	adzic1
adzic1:
	dc.l	music1
	dc.l	music2
*> Barres
SENS_BARRE:	DC.W	$0
HBL_POS_1:	DC.W	$0
HBL_POS_2:	DC.W	$0
POSITION_BARRE:	DC.W	$0
BAR_TEMPO:	DC.W	$0
	even
*>  Scrolling 1 plan
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
	DC.L	COURBE 
COURBE:
	dc.w	$12C0,$12C0,$12C0,$12C0
	dc.w	$1220,$1220,$1220,$1180
	dc.w	$1180,$10E0,$1040,$1040
	dc.w	$0FA0,$0F00,$0E60,$0DC0
	dc.w	$0D20,$0C80,$0BE0,$0AA0
	dc.w	$0A00,$0960,$08C0,$0780
	dc.w	$06E0,$05A0,$0500,$0460
	dc.w	$0320,$0280,$0140,$00A0
	dc.w	$0000,$FF60,$FE20,$FD80
	dc.w	$FC40,$FBA0,$FA60,$F9C0
	dc.w	$F880,$F7E0,$F740,$F600
	dc.w	$F560,$F4C0,$F420,$F380
	dc.w	$F240,$F1A0,$F1A0,$F100
	dc.w	$F060,$EFC0,$EF20,$EF20
	dc.w	$EE80,$EE80,$EDE0,$EDE0
	dc.w	$ED40,$ED40,$ED40,$ED40
	dc.w	$ED40,$ED40,$ED40,$ED40
	dc.w	$EDE0,$EDE0,$EDE0,$EE80
	dc.w	$EE80,$EF20,$EFC0,$EFC0
	dc.w	$F060,$F100,$F1A0,$F240
	dc.w	$F2E0,$F380,$F420,$F560
	dc.w	$F600,$F6A0,$F740,$F880
	dc.w	$F920,$FA60,$FB00,$FBA0
	dc.w	$FCE0,$FD80,$FEC0,$FF60
	dc.w	$0000,$00A0,$01E0,$0280
	dc.w	$03C0,$0460,$05A0,$0640
	dc.w	$0780,$0820,$08C0,$0A00
	dc.w	$0AA0,$0B40,$0BE0,$0C80
	dc.w	$0DC0,$0E60,$0E60,$0F00
	dc.w	$0FA0,$1040,$10E0,$10E0
	dc.w	$1180,$1180,$1220,$1220
	dc.w	$12C0,$12C0,$12C0,$12C0
	dc.w	$12C0,$12C0,$12C0,$12C0
	dc.w	$12C0,$1220,$1220,$1220
	dc.w	$1180,$1180,$1180,$10E0
	dc.w	$10E0,$1040,$0FA0,$0FA0
	dc.w	$0F00,$0E60,$0E60,$0DC0
	dc.w	$0D20,$0C80,$0BE0,$0B40
	dc.w	$0AA0,$0A00,$0960,$08C0
	dc.w	$0820,$0780,$06E0,$0640
	dc.w	$05A0,$0460,$03C0,$0320
	dc.w	$0280,$01E0,$0140,$0000
	dc.w	$0000,$FF60,$FEC0,$FD80
	dc.w	$FCE0,$FC40,$FBA0,$FB00
	dc.w	$FA60,$F920,$F880,$F7E0
	dc.w	$F740,$F6A0,$F600,$F560
	dc.w	$F4C0,$F420,$F380,$F2E0
	dc.w	$F240,$F240,$F1A0,$F100
	dc.w	$F060,$F060,$EFC0,$EFC0
	dc.w	$EF20,$EE80,$EE80,$EE80
	dc.w	$EDE0,$EDE0,$EDE0,$ED40
	dc.w	$ED40,$ED40,$ED40,$ED40
	dc.w	$ED40,$ED40,$ED40,$ED40
	dc.w	$ED40,$EDE0,$EDE0,$EDE0
	dc.w	$EE80,$EE80,$EE80,$EF20
	dc.w	$EF20,$EFC0,$F060,$F060
	dc.w	$F100,$F1A0,$F1A0,$F240
	dc.w	$F2E0,$F380,$F420,$F4C0
	dc.w	$F560,$F600,$F6A0,$F740
	dc.w	$F7E0,$F880,$F920,$F9C0
	dc.w	$FA60,$FBA0,$FC40,$FCE0
	dc.w	$FD80,$FE20,$FEC0,$0000
	dc.w	$0000,$00A0,$0140,$0280
	dc.w	$0320,$03C0,$0460,$0500
	dc.w	$05A0,$06E0,$0780,$0820
	dc.w	$08C0,$0960,$0A00,$0AA0
	dc.w	$0B40,$0BE0,$0C80,$0D20
	dc.w	$0DC0,$0DC0,$0E60,$0F00
	dc.w	$0FA0,$0FA0,$1040,$1040
	dc.w	$10E0,$1180,$1180,$1180
	dc.w	$1220,$1220,$1220,$12C0
	dc.w	$12C0,$12C0,$12C0,$12C0
	dc.w	$12C0,$12C0,$12C0,$12C0
	dc.w	$12C0,$12C0,$12C0,$1220
	dc.w	$1220,$1220,$1220,$1180
	dc.w	$1180,$1180,$10E0,$10E0
	dc.w	$10E0,$1040,$1040,$0FA0
	dc.w	$0FA0,$0F00,$0F00,$0E60
	dc.w	$0E60,$0DC0,$0D20,$0D20
	dc.w	$0C80,$0BE0,$0BE0,$0B40
	dc.w	$0AA0,$0A00,$0A00,$0960
	dc.w	$08C0,$0820,$0820,$0780
	dc.w	$06E0,$0640,$05A0,$0500
	dc.w	$0460,$0460,$03C0,$0320
	dc.w	$0280,$01E0,$0140,$00A0
	dc.w	$0000,$0000,$FF60,$FEC0
	dc.w	$FE20,$FD80,$FD80,$FCE0
	dc.w	$FC40,$FBA0,$FB00,$FA60
	dc.w	$F9C0,$F920,$F920,$F880
	dc.w	$F7E0,$F740,$F6A0,$F6A0
	dc.w	$F600,$F560,$F4C0,$F4C0
	dc.w	$F420,$F380,$F380,$F2E0
	dc.w	$F240,$F240,$F1A0,$F1A0
	dc.w	$F100,$F060,$F060,$EFC0
	dc.w	$EFC0,$EFC0,$EF20,$EF20
	dc.w	$EE80,$EE80,$EE80,$EDE0
	dc.w	$EDE0,$EDE0,$EDE0,$EDE0
	dc.w	$ED40,$ED40,$ED40,$ED40
	dc.w	$ED40,$ED40,$ED40,$ED40
	dc.w	$ED40,$ED40,$ED40,$ED40
	dc.w	$ED40,$EDE0,$EDE0,$EDE0
	dc.w	$EDE0,$EE80,$EE80,$EE80
	dc.w	$EF20,$EF20,$EF20,$EFC0
	dc.w	$EFC0,$F060,$F060,$F100
	dc.w	$F100,$F1A0,$F1A0,$F240
	dc.w	$F2E0,$F2E0,$F380,$F420
	dc.w	$F420,$F4C0,$F560,$F600
	dc.w	$F600,$F6A0,$F740,$F7E0
	dc.w	$F7E0,$F880,$F920,$F9C0
	dc.w	$FA60,$FB00,$FBA0,$FBA0
	dc.w	$FC40,$FCE0,$FD80,$FE20
	dc.w	$FEC0,$FF60,$0000,$0000
	dc.w	$00A0,$0140,$01E0,$0280
	dc.w	$0280,$0320,$03C0,$0460
	dc.w	$0500,$05A0,$0640,$06E0
	dc.w	$06E0,$0780,$0820,$08C0
	dc.w	$0960,$0960,$0A00,$0AA0
	dc.w	$0B40,$0B40,$0BE0,$0C80
	dc.w	$0C80,$0D20,$0DC0,$0DC0
	dc.w	$0E60,$0E60,$0F00,$0FA0
	dc.w	$0FA0,$1040,$1040,$1040
	dc.w	$10E0,$10E0,$1180,$1180
	dc.w	$1180,$1220,$1220,$1220
	dc.w	$1220,$1220,$12C0,$12C0
	dc.w	$12C0,$12C0,$12C0,$12C0
	dc.w	$12C0,$12C0,$12C0,$12C0
	dc.w	$12C0,$12C0,$12C0,$12C0
	dc.w	$12C0,$12C0,$12C0,$12C0
	dc.w	$12C0,$12C0,$12C0,$FFFF
	dc.w	$FFFF,$0000
FONTEs:
	include	"FONTE.S"
TEXTEs:
*> ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789!(),.:-?'
;	DC.B	'                             '
	DC.B	' HELLO OF SECTOR ONE IS PLEASED TO PRESENT YOU A SPECIAL COMPILATION FROM SECTOR ONE AND THE HEAVY KILLERS (THK),'
	DC.B	' RELEASED BY THE CREW NOEXTRA CALLED : EXTRA COMPILATION VOLUME 3.                                    '
	DC.B	' THE COMPILATION IS PRESENTED AT THE VIP (VERY IMPORTANT PARTY) IN 2012 AT THOISSEY IN FRANCE ORGANIZED'
	DC.B	' BY THE POPSY TEAM.                                 '
	DC.B	' SECTOR ONE HAS A LOT OF SCREENS IN BOXES THAT WERE NEVER PUBLISHED !                                  '
	DC.B	' AND THIS RELEASE CAN ONLY SHOW THAT SOME LITTLE FUN ACHIEVEMENTS ON ATARI ST SUPPLIED BY ZORRO 2 AND JEDI.'
	DC.B	'                    OF COURSE, THE SECTOR ONE CREW IS STILL ACTIVE AND CONTINUE TO PRODUCE ON ATARI ST,'
	DC.B	' BUT ALSO ON MANY PLATFORMS AND ENVIRONMENTS.                '
	DC.B	' MOREOVER, MANY NEW PROJECTS ARE UNDERWAY ON VARIOUS PLATFORMS.                                        '
	DC.B	' PEOPLE WHO PARTICIPATED AT THIS COMPILATION ARE : ZORRO 2 - MISTER.A - MAARTAU'
	DC.B	' AND SECTOR ONE : JEDI - SPS - ODC - HELLO - AQUARIUM - ANTICHRIST - DRABOB - PULSAR - ETC...                  '
	DC.B	' GREETINGS..............THE UNION, TEX, ST NEWS, DHS, DUNE, EQUINOX, NEXT, X-MEN, POPSY TEAM, OYGENE, MJJ PROD,'
	DC.B	' OMEGA, DELTA FORCE, ST CONNEXION, THE REPLICANTS, INNER CIRCLE, OVERLANDERS, ELECTRA, AGRESSION, PARADOX,'
	DC.B	' IMPACT, EKO, FANTASY... AND ALL OTHERS SCENERS.                         '
	DC.B	' AND WE HOPE YOU ENJOYED THIS REALIZATION.                               '
	DC.B	'                     USE ARROW KEYS TO SELECT AND SPACE TO RUN THE INTRO SELECTED              '
	DC.B	'                     SPECIAL RARE MUSICS FROM JEDI AND ANTICHRIST : PUSH F1 OR F2 KEY TO CHOOSE TO PLAY        '
	DC.B	'                     MEMBERS OF NOEXTRA : ATOMUS, MISTER.A, ZORRO2, TOMCHI AND HYLST.                          '
	DC.B	'                     COMPILATION RELEASED BY NOEXTRA TEAM THE 22 APRIL 2012                                    '
	DC.B	'                     LET',$27,'S WARP!                                     '
end_TEXTEs:
	dc.w	$5b00
	ds.b	1000
	even
*> Texte 1 plan 8*8
message:
	DC.B 	"  COMPILATION EXTRA VOLUME 3",0
	DC.B 	"  SPECIAL SECTOR ONE AND THK.",0,0
	DC.B 	"  DNT PAPER 4 INTRO BY JEDI",0
	DC.B 	"  THAT",$27,"S THE WAY I LIKE IT",0
	DC.B 	"  PREVIEW OF ACID INTRO",0
	DC.B 	"  NOTHING IS MORE... BY JEDI",0
	DC.B 	"  SHOOT PREVIEW BY DRABOB",0
	DC.B 	"  SO LAME INTRO BY JEDI",0
	DC.B 	"  TRACKER STE",0
	DC.B 	"  ZOOMER BY JEDI",0
	DC.B 	"  MENU INTROS BY PULSTAR",0
	DC.B 	"  MINEFIELD GAME BY PULSTAR",0
	DC.B 	"  AQUABOOT ANTIVIRUS BY AQUARIUM",$ff
	even
x_curs:	dc.l 0
y_offset:	dc.l 0
x_offset:	dc.l 0
fonte1:
	incbin 	"FONT88P.DAT"
	even
* Files
CPT_ANIMS: dc.w	0
ANIMS:
	incbin "CDI.LZ7" ; 124 x 320
	even
LOGO_NO:
	incbin	"LOGO_NO6.IMG"
	even
IMG_INTRO:
	incbin	"NOEXTRA.IMG"
	even
* <

music1:
	incbin	"1.THK"	; Rip Jedi
	even
music2:
	incbin	"2.THK" ; Rip AntiChrist
	even

***************************************************************
 SECTION	BSS                                              // *
***************************************************************

bss_start:

* < Full data here >
POSITION:
	DS.W	1 
BUFFER:
	DS.B	4918
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

Ptr_Buffer_L7z:
	ds.l	1
Buffer_L7z:
	ds.b	634880

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

	pea EXIT                          ; Put the return adress
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

******************************************************************
	END                                                         // *
******************************************************************
