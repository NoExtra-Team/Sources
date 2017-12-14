***************************************
* // FACE-B.PRG                    // *
***************************************
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

********************************************************************
SYNCHRO_WAIT    equ $900      ; Adresse de la synchro              *
********************************************************************
SEEMYVBL        equ 1         ; See CPU used if you press ALT key  *
TEST_STE        equ 0         ; Code only for Atari STE machine    *
********************************************************************
ECRAN_01        equ 0         ; Fullscreen Big LOGO                *
ECRAN_02        equ 0         ; Rasters Bars Big LOGO              *
ECRAN_03        equ 0         ; Etoiles 3D presentation            *
ECRAN_04        equ 0         ; Shade Screen TRIANGLE              *
ECRAN_05        equ 0         ; Greatings                          *
ECRAN_06        equ 0         ; Quadra effect !!!                  *
ECRAN_07        equ 0         ; Scrolltext de fin !                *
********************************************************************
TEMPO_ECRAN_01  equ $0100     ; Temporisation entre chaque effet   *
TEMPO_ECRAN_02  equ $0140     ;                                    *
TEMPO_ECRAN_03  equ $0470     ;                                    *
TEMPO_ECRAN_04  equ $0940     ;                                    *
TEMPO_ECRAN_05  equ $0400     ;                                    *
TEMPO_ECRAN_06  equ $0400-20  ;                                    *
TEMPO_ECRAN_07  equ $0b00+10  ;                                    *
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
	move.l $5a0.w,d0                 ; Détection du STE !
	beq .old_hardware
	movea.l d0,a0
.loop:
	move.l (a0)+,d0
	beq .old_hardware
	cmp.l #'_MCH',d0
	beq.s .find
	addq.w #4,a0
	bra.s .loop
.find:
	move.w	(a0)+,d0
	cmp.w	#$3,d0                     ; Falcon ?
	beq.s	.falcon
	cmp.w	#$1,d0                     ; STE ?
	bne.s	.old_hardware
	move.w	(a0),d0                  ; Mega STE ?
	bne.s	.old_hardware
	or.b	#2,$ffff820a.w             ; 50 Hz
	clr.b	$ffff8264.w                ; hscroll
	clr.b	$ffff820f.w                ; linewid
	bra.w	.STE_hard
.falcon:
.old_hardware:
	move.w	#$700,d0                 ; MSTE, STF or FALCON detected : RED message !!!
	move.w	#$ffff,d1
.loopHARD:
	dcb.w	2,$4e71
	move.w d0,$ffff8240.w            ; Effet raster
	dcb.w	2,$4e71
	move.w #0,$ffff8240.w
	dcb.w	2,$4e71
	dbra d1,.loopHARD
	move.w	#$777,$ffff8240.w * blanc
	bra	EXIT_PRG
.STE_hard:
 ENDC

	bsr	clear_bss                    ; Clean BSS stack
	
	bsr	Save_and_init_st             ; Save system parameters

	jsr	clear_blitter_Halftone       ; Init Blitter

	moveq	#1,d0                      ; Choice of the music (1 is default)
	jsr	MUSIC_INTRO+0                      ; Init SNDH music

	lea	Vbl_Intro(pc),a0             ; Launch VBL
	move.l	a0,$70.w                 ;

**************************** MAIN LOOP ************************>

	move.l	#Buffer_L7Z,d0           ; Set physical Screen #1
	add.w	#$ff,d0                    ;
	sf	d0                           ;
	move.l	d0,physique              ;

	bsr	Clear_Screen                 ; Clear 1 Screen Fast !

	bsr	First_screen

;--------------------------------------------------------------> ECRAN_01
 IFEQ ECRAN_01

	lea	Full_img,a0	;	datas vagues compressed
	movea.l	physique,a1
	lea	160*163(a1),a1
	jsr	d_lz77	; decompress data in a0 -> a1

	lea	Full_palette,a0           ; Put palette
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d7               ;
	movem.l	d0-d7,(a1)               ;

	move.w	#$2f,d7
	jsr	wait_more

	lea	Full_Logo_NoExtra_img,a0	;	datas vagues compressed
	lea	t_Buffer_L7Z,a1
	jsr	d_lz77	; decompress data in a0 -> a1

	jsr	init_zoom

	bsr	Clear_Screen                 ; Clear 1 Screen Fast !

	move.l	pointe,d4
	add.l	#2*20+640*20,d4
	move.l	d4,pointe
	move.l	#Vbl_Zoom,$70.w
	move.l	#mouvement_1,ptr_mouvement

Mvt1_Loop:
	bsr	Wait_vbl                     ; Waiting after the VBL
	move.l	ptr_mouvement,a0
	cmp.b	#-1,(a0)
	beq.s fin_mouvement_1
	move.b	(a0)+,d6
	move.l	a0,ptr_mouvement
	jsr	Deplace_M
	bra.s	Mvt1_Loop
fin_mouvement_1:

	move.w	#$1f,d7
	jsr	wait_more

	move.l	pointe,d4
	add.l	#640*140+2*90,d4
	move.l	d4,pointe
	move.l	#Vbl_Zoom,$70.w

	move.w	#$0f,d7
	jsr	wait_more

	move.l	pointe,d4
	add.l	#2*189-640*70,d4
	move.l	d4,pointe
	move.l	#Vbl_Zoom,$70.w
	move.l	#mouvement_2,ptr_mouvement

Mvt2_Loop:
	bsr	Wait_vbl                     ; Waiting after the VBL
	move.l	ptr_mouvement,a0
	cmp.b	#-1,(a0)
	beq.s fin_mouvement_2
	move.b	(a0)+,d6
	move.l	a0,ptr_mouvement
	jsr	Deplace_M
	bra.s	Mvt2_Loop
fin_mouvement_2:

	move.w	#$1f,d7
	jsr	wait_more

 ENDC
;--------------------------------------------------------------< ECRAN_01

	lea	Vbl_Intro(pc),a0             ; Launch VBL
	move.l	a0,$70.w                 ;
	jsr	Replace_Hbl

	bsr	Clear_Screen                 ; Clear 1 Screen Fast !

	bsr	First_screen

;--------------------------------------------------------------> ECRAN_02
 IFEQ ECRAN_02

	lea	Full_Logo_NoExtra_img,a0	;	datas vagues compressed
	movea.l	physique,a1
	jsr	d_lz77	; decompress data in a0 -> a1

	jsr	init_Bars

	move.l	#TEMPO_ECRAN_02,SYNCHRO_WAIT

effet2_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet2_loop

 ENDC
;--------------------------------------------------------------< ECRAN_02

;	move #$2700,SR                   ; Interrupts OFF
	jsr	MUSIC_INTRO+4                ; Stop SNDH music
	lea       $ffff8800.w,a0         ; Cut sound
	move.l    #$8000000,(a0)         ; Voice A
	move.l    #$9000000,(a0)         ; Voice B
	move.l    #$a000000,(a0)         ; Voice C
;	stop	#$2300                     ; Interrupts ON

	lea	Vbl_Blanck(pc),a0            ; Stop VBL
	move.l	a0,$70.w                 ;

	moveq	#1,d0                      ; Choice of the music (1 is default)
	jsr	MUSIC+0                      ; Init SNDH music

	bsr	Replace_Vbl_Hbl

	move.l	#Buffer_L7Z,d0           ; Set physical Screen #1
	add.w	#$ff,d0                    ;
	sf	d0                           ;
	move.l	d0,physique              ;

	move.l	#Buffer_L7Z+160*200+256,d0   ; Set physical Screen #2
	sf	d0                           ;
	move.l	d0,physique+4            ;

	bsr	Clear_Screens                ; Clear 2 Screens Fast !

;--------------------------------------------------------------> ECRAN_03
 IFEQ ECRAN_03

	jsr init_stars
	jsr	print_text

	lea	Stars3d_palette,a0           ; Put palette
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d7               ;
	movem.l	d0-d7,(a1)               ;

	move.l	#TEMPO_ECRAN_03,SYNCHRO_WAIT

effet3_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	IFEQ	SEEMYVBL
	move.w	#$000,$ffff8240.w
	ENDC

	jsr	play_sequence_stars
	jsr clear_stars
	jsr play_stars

	bsr	Swap_screens

	IFEQ	SEEMYVBL
	move.b	#$2,$ffff8240.w           ; See the rest of CPU
	ENDC

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet3_loop

 ENDC
;--------------------------------------------------------------< ECRAN_03

	move.l	#Buffer_L7Z,d0           ; Set physical Screen #1
	add.w	#$ff,d0                    ;
	sf	d0                           ;
	move.l	d0,physique              ;

	move.l	#Buffer_L7Z+160*200+256,d0   ; Set physical Screen #2
	sf	d0                           ;
	move.l	d0,physique+4            ;

	bsr	Clear_Screens                ; Clear 2 Screens Fast !

	bsr	First_screen

;--------------------------------------------------------------> ECRAN_04
 IFEQ ECRAN_04

	jsr	init_shadbobs

	lea	LogoB_img,a0	;	datas vagues compressed
	movea.l	physique,a1
	lea	160*198(a1),a1
	jsr	d_lz77	; decompress data in a0 -> a1

	move.l	#TEMPO_ECRAN_04,SYNCHRO_WAIT

effet4_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	IFEQ	SEEMYVBL
	move.w	#$000,$ffff8240.w
	ENDC

	jsr	do_bobs
	jsr	mscroll

	IFEQ	SEEMYVBL
	move.b	#$2,$ffff8240.w           ; See the rest of CPU
	ENDC

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet4_loop

 ENDC
;--------------------------------------------------------------< ECRAN_04

	bsr	Replace_Vbl_Hbl

	move.l	#Buffer_L7Z,d0           ; Set physical Screen #1
	add.w	#$ff,d0                    ;
	sf	d0                           ;
	move.l	d0,physique              ;

	move.l	#Buffer_L7Z+160*200+256,d0   ; Set physical Screen #2
	sf	d0                           ;
	move.l	d0,physique+4            ;

	bsr	Clear_Screens                ; Clear 2 Screens Fast !

;--------------------------------------------------------------> ECRAN_05
 IFEQ ECRAN_05

	jsr	put_lines

	lea	Cadre_img,a0	;	datas vagues compressed
	movea.l	physique,a1
	lea	160*188(a1),a1
	jsr	d_lz77	; decompress data in a0 -> a1

	movea.l	physique,a0
	movea.l	physique+4,a1
	move.w	#0,d0
	move.w	#0,d1
	move.w	#320,d2
	move.w	#200,d3
	move.w	#4,d4
	jsr	DoBLiTTER__Copy_Buffer

	lea	Cadre_palette,a0             ; Put palette
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d7               ;
	movem.l	d0-d7,(a1)               ;

	jsr	init_greats

	move.l 	#greats_texte-1,ptr_texte      ; Texte #1
	jsr	init_texte

	move.l	#TEMPO_ECRAN_05/2,SYNCHRO_WAIT

effet5_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	IFEQ	SEEMYVBL
	move.w	#$000,$ffff8250.w
	ENDC

	jsr	rotojedi
	jsr	put_texte

	bsr	Swap_screens

	IFEQ	SEEMYVBL
	move.b	#$2,$ffff8250.w           ; See the rest of CPU
	ENDC

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet5_loop

	move.l 	#greats_texte2-1,ptr_texte      ; Texte #2
	jsr	init_texte

	move.l	#TEMPO_ECRAN_05/2+20,SYNCHRO_WAIT

effet5a_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	IFEQ	SEEMYVBL
	move.w	#$000,$ffff8250.w
	ENDC

	jsr	rotojedi
	jsr	put_texte

	bsr	Swap_screens

	IFEQ	SEEMYVBL
	move.b	#$2,$ffff8250.w           ; See the rest of CPU
	ENDC

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet5a_loop

 ENDC
;--------------------------------------------------------------< ECRAN_05

	move.l	#Buffer_L7Z,d0           ; Set physical Screen #1
	add.w	#$ff,d0                    ;
	sf	d0                           ;
	move.l	d0,physique              ;

	move.l	#Buffer_L7Z+160*200+256,d0   ; Set physical Screen #2
	sf	d0                           ;
	move.l	d0,physique+4            ;

	bsr	Clear_Screens                ; Clear 2 Screens Fast !

	bsr	First_screen

	lea	Warning_img,a0	;	datas vagues compressed
	movea.l	physique,a1
	lea	160*167(a1),a1
	jsr	d_lz77	; decompress data in a0 -> a1

	lea	Warning_palette,a0              ; Put palette
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d7               ;
	movem.l	d0-d7,(a1)               ;

	move.w	#$3f,d7
	jsr	wait_more

;--------------------------------------------------------------> ECRAN_06
 IFEQ ECRAN_06

	lea	QUADRA_DATA,a0	;	datas vagues compressed
	lea	t_Buffer_L7Z,a1	;	buffer destination
	jsr	d_lz77	; decompress data in a0 -> a1

	bsr	Clear_Screen                 ; Clear 1 Screen Fast !

	lea	Quadra_palette,a0            ; Put palette
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d7               ;
	movem.l	d0-d7,(a1)               ;

	move.l	#TEMPO_ECRAN_06,SYNCHRO_WAIT

effet6_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	IFEQ	SEEMYVBL
	move.w	#$000,$ffff8260.w
	ENDC

	move.l	PTR_QUADRA,a2
	cmp.l	#-1,(a2)
	bne.s	.continue
	move.l	#QUADRA,PTR_QUADRA
	move.l	PTR_QUADRA,a2
.continue:
	move.l	(a2)+,a0
	move.l	a2,PTR_QUADRA
	movea.l	physique,a1
	move.w	#0,d0
	move.w	#0,d1
	move.w	#320,d2
	move.w	#200,d3
	move.w	#3,d4
	bsr	DoBLiTTER__Copy_Buffer

* Logo Mister.A
; From adress
	move.l	#NoExtraL_img,a0                ; FROM ADRESS DATA
	move.w	#0,d2                    ; LEFT FROM ADRESS DATA
	move.w	#0,d3                    ; TOP FROM ADRESS DATA
	move.w	#61,d4        ; WIDTH of bloc
	move.w	#17,d5       ; HEIGHT of bloc
	move.w	#4,d6       ; Number of plane
; Destination 1st Screen adress
	move.l	physique,a1          ; TO ADRESS SCREEN
*	addq.w	#6,a1
	move.w	#0,d0      ; LEFT TO ADRESS SCREEN
	move.w	#200-17,d1      ; TOP TO ADRESS SCREEN
	jsr	DoBLiTTER__Operation       ; Launch blitter operation

	bsr	Swap_screens

	IFEQ	SEEMYVBL
	move.b	#$2,$ffff8260.w           ; See the rest of CPU
	ENDC

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne	effet6_loop

 ENDC
;--------------------------------------------------------------< ECRAN_06

	bsr	Clear_Screens                ; Clear 2 Screens Fast !

;--------------------------------------------------------------> ECRAN_07
 IFEQ ECRAN_07

	move.l #t_Buffer_L7Z,a0         ; Adress of screen dest
  move.w	#0,d0                    ; Number of line to clear
  move.w	#0,d1
  move.w	#320,d2
  move.w	#200,d3
  jsr	clear_screen_4_bitplanes     ; Clear Screen

	jsr	INIT_MONSCROL

	lea	Zoby_img,a0	;	datas vagues compressed
	movea.l	physique,a1
	jsr	d_lz77	; decompress data in a0 -> a1

	movea.l	physique,a0
	movea.l	physique+4,a1
	move.w	#0,d0
	move.w	#0,d1
	move.w	#320,d2
	move.w	#200,d3
	move.w	#4,d4
	jsr	DoBLiTTER__Copy_Buffer

	lea	Zoby_palette,a0              ; Put palette
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d7               ;
	movem.l	d0-d7,(a1)               ;

	move.l	#TEMPO_ECRAN_07,SYNCHRO_WAIT

effet7_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	IFEQ	SEEMYVBL
	move.w	#$000,$ffff8270.w
	ENDC

	jsr	MONSCROL

	bsr	Swap_screens

	IFEQ	SEEMYVBL
	move.b	#$2,$ffff8270.w           ; See the rest of CPU
	ENDC

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet7_loop

 ENDC
;--------------------------------------------------------------< ECRAN_07

	move.w	#$cf,d7
	jsr	wait_more

	moveq   #20-1,D7                 ; Temporisation
.end_fadeE:
	lea     $ffff8240.w,A0           ; Palette Logo
	moveq   #15,D2
	jsr     fade_down
	bsr	Wait_vbl                     ; Waiting after the VBL
	dbra    D7,.end_fadeE

	move.l	#$0,myColor
	bsr	clear_palette

	bsr	Clear_Screens

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
*                       Screen Routines                       *
*                                                             *
***************************************************************

First_screen:
	move.l	physique(pc),d0          ; Put physical Screen
	move.b	d0,d1                    ;
	lsr.w	#8,d0                      ;
	move.b	d0,$ffff8203.w           ;
	swap	d0                         ;
	move.b	d0,$ffff8201.w           ;
	move.b	d1,$ffff820d.w           ;
	rts

physique:
	ds.l 2                           ; Number of screens declared

Swap_screens:
	lea     physique(pc),a0          ; Swapping two Screens
	move.l	(a0),d0                  ;
	move.l	4(a0),(a0)+              ;
	move.l	d0,(a0)                  ;
	move.b  d0,$ffff820d.w           ;
	move    d0,-(sp)                 ;
	move.b  (sp)+,d0                 ;
	move.l  d0,$ffff8200.w           ;
	rts

Clear_Screens:
	move.l physique+4(pc),a0         ; Adress of screen dest
  move.w	#0,d0                    ; Number of line to clear
  move.w	#0,d1
  move.w	#320,d2
  move.w	#200,d3
  jsr	clear_screen_4_bitplanes     ; Clear Screen
Clear_Screen:
	move.l physique(pc),a0           ; Adress of screen dest
  move.w	#0,d0                    ; Number of line to clear
  move.w	#0,d1
  move.w	#320,d2
  move.w	#200,d3
  jsr	clear_screen_4_bitplanes     ; Clear Screen
	rts

***************************************************************
*                                                             *
*                        Vbl Routines                         *
*                                                             *
***************************************************************
Vbl_Blanck:
	st	Vsync                        ; Synchronisation
	rte

Vbl_Intro:
	st	Vsync                        ; Synchronisation
	jsr 	(MUSIC_INTRO+8)                  ; Play SNDH music
	rte

Vbl:
	st	Vsync                        ; Synchronisation
	jsr 	(MUSIC+8)                  ; Play SNDH music
myrte:
	rte

Wait_vbl:                          ; Test Synchronisation
	move.l	a0,-(a7)                 ;
	lea	Vsync,a0                     ;
	sf	(a0)                         ;
.loop:	tst.b	(a0)                 ;
	beq.s	.loop                      ;
	move.l	(a7)+,a0                 ;
	rts

Replace_Vbl_Hbl:
	lea	Vbl(pc),a0                   ; Launch VBL
	move.l	a0,$70.w                 ;
Replace_Hbl:
	clr.b	$fffffa1b.w                ; Stop Timer B
	lea	myrte(pc),a0                 ; Stop HBL
	move.l	a0,$120.w                ;
	rts

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

	clr.b	$fffffa07.w                ; Interrupt enable A (Timer-A & B)
	clr.b	$fffffa09.w                ; Interrupt enable B (Timer-C & D)
	clr.b	$fffffa13.w                ; Interrupt mask A (Timer-A & B)
	clr.b	$fffffa15.w                ; Interrupt mask B (Timer-C & D)
	clr.b	$fffffa19.w                ; Stop Timer A
	clr.b	$fffffa1b.w                ; Stop Timer B
	clr.b	$fffffa21.w                ; Timer B data at zero
	clr.b	$fffffa1d.w                ; Stop Timer C & D

	bclr	#3,$fffffa17.w             ; Automatic End-Interrupt hbl ON

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

	moveq #$11,d0                    ; Resume keyboard
	bsr	sendToKeyboard               ;

	moveq #$12,d0                    ; Kill mouse
	bsr	sendToKeyboard               ;

	bsr	flush                        ; Clear buffer keyboard

	sf	$ffff8260.w                  ; Low resolution
	move.b	#$2,$ffff820a.w          ; 50 Hz !
	rts

Restore_st:
	moveq #$13,d0                    ; Pause keyboard
	bsr	sendToKeyboard               ;

	move #$2700,SR                   ; Interrupts OFF

	jsr	MUSIC+4                      ; Stop SNDH music

	lea       $ffff8800.w,a0         ; Cut sound
	move.l    #$8000000,(a0)         ; Voice A
	move.l    #$9000000,(a0)         ; Voice B
	move.l    #$a000000,(a0)         ; Voice C

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

***************************************************************
; SUB-ROUTINES                                             // *
***************************************************************

 include	"\FACE-B\UTILS.ASM"
 include	"\FACE-B\includes\INTROFUL.ASM"
 include	"\FACE-B\includes\3RASTERS.ASM"
 include	"\FACE-B\includes\STARS3D.ASM"
 include	"\FACE-B\includes\SHADBOBS.ASM"
 include	"\FACE-B\includes\GREATS.ASM"
 include	"\FACE-B\includes\SCROLEND.ASM"
 include  "\FACE-B\includes\ASMLINE.ASM"
 even

***************************************************************
 SECTION	DATA                                             // *
***************************************************************
*

Full_palette:
	dc.w	$03A3,$0777,$0101,$0434,$0555,$0063,$0070,$0070
	dc.w	$0770,$0776,$0660,$0000,$0733,$0744,$0755,$0777
Full_img:
	incbin	"\FACE-B\graphs\FULL.L7Z"
	even
***************** [ECRAN_01] *****************
ptr_mouvement:
	dc.l	mouvement_1
mouvement_1:
i set $4d
 rept 60
	dc.b	i,i,i,i
 endr
	dc.w	-1
	even
mouvement_2:
i set $4b
 rept 70-16
	dc.b	i,i,i,i
 endr
	dc.w	-1
	even
Full_Logo_NoExtra_img:
	incbin	"\FACE-B\graphs\GROSLOGO.L7Z"
	even
***************** [ECRAN_02] *****************
Couleurs_rasters:
	dc.w	$0100,$0200,$0300,$0400,$0500,$0600,$0700,$0600,$0500,$0400,$0300,$0200,$0100
	dc.w	$0010,$0020,$0030,$0040,$0050,$0060,$0070,$0060,$0050,$0040,$0030,$0020,$0010
	dc.w	$0001,$0002,$0003,$0004,$0005,$0006,$0007,$0006,$0005,$0004,$0003,$0002,$0001
Courbes_rasters:
	incbin	"\FACE-B\datas\C_BARS.DAT"
	even
***************** [ECRAN_03] *****************
Stars3d_palette:
	dc.w	$0000,$0777,$0444,$0777,$0222,$0777,$0444,$0777
	dc.w	$0fff,$0fff,$0fff,$0fff,$0fff,$0fff,$0fff,$0000
*> !",$22,"#$%&",$27,"()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_
message:
*       +                       +
	dc.b	"NOEXTRA PRESENT IN 2016",0
	dc.b	"   A SHORT DEMO CALL   ",0
	dc.b	"       \ FACE-B \      ",0,0
	dc.b	"        CODED BY       ",0
	dc.b	"   ATOMUS AND ZORRO2   ",0,0
	dc.b	"       GRAPHISMS       ",0
	dc.b	"   MISTER.A AND YOGI   ",0,0
	dc.b	"   MUSIC JEDI/SECT1    ",$ff
	even
fonte12:
	incbin 	"\FACE-B\datas\FONT16_2.DAT"
	EVEN
*
zw set z_max*2
t set zw/3
q:
 rept t
 dc.w 0,0
 endr
 rept t
 dc.w 2,0
 endr
 rept zw-t*2
 dc.w 4,0
 endr
mul160:
y set -100
 rept 200
 dc.w y*160
y set y+1
 endr
offset:
x set -160
 rept 320
 dc.w $8000>>(x&$f),(x&$fffffff0)/2
x set x+1
 endr
***************** [ECRAN_04] *****************
pal_Haut:
	dc.w	$0008,$091A,$0293,$0A24,$03AC,$04BD,$0CC6,$0DD7
pal_Bas:
	dc.w	$0008,$0DC4,$0ED5,$0B22,$04AA,$05BB,$0211,$0A99
pal_Shade:
	dc.w	$0008,$0081,$0819,$0192,$092A,$02A3,$0A3B,$03B4
	dc.w	$0B4C,$04C5,$0C5D,$05D6,$0D6E,$06E7,$0E7F,$077F
pal_Raster:
	dc.w	$0000,$0753,$0EB3,$06A3,$0513,$06A3,$0EB3,$0753
*
mtexte: 
* < !'#$%&"()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyzCUR> *
	dc.b	"                      "
	dc.b "THIS DEMO HAS BEEN RELEASED FOR THE VERY IMPORTANT PARTY 2016 ORGANIZED BY THE POPSY-TEAM IN FRANCE. "
	dc.b	"NOEXTRA ARE HERE AGAIN TO PRESENT AN ANOTHER SHORT PRODUCTION. "
	dc.b	"THIS DEMO SHOULD RUN ON ATARI STE WITH 2 MEGA OF MEMORY. "
;	dc.b	"THIS EFFECT CALL SHADE-BOB AND WE DON'T FINISH TO TURN AROUND ! VERY AMAZING WITH THE STE COLOR PALLET."
	dc.b	"YOU SAW THE CREDITS BEFORE, NO SURPRISE ! "
;	dc.b	"I ADMIT ! IT'S ZORRO 2 WHO WRITTEN THIS STUPID SCROLLTEXT ... "
	dc.b	"                      "
	dc.b	-1
	even
fonts_8x8:
	incbin	"\FACE-B\datas\OPUS2.DAT"
	even
*
sine_x:
	incbin	"\FACE-B\datas\SINE_X.DAT"
	even
sine_y:
	incbin	"\FACE-B\datas\SINE_Y.DAT"
	even
bob_timer:
	dc.w	500
bob_data:
	dc.l	0
	dc.l	24/2
	dc.l	4
	dc.l	14
bob1_offset:
	dc.w	0
bob1:
	dc.w	2,4,800,0
	dc.w	32,10,600,0
	dc.w	4,14,500,0
	dc.w	10,26,400,0
	dc.w	4,2,600,0
	dc.w	40,10,800,0
	dc.w	60,100,800,0
	dc.w	8,24,600,0
; x offset, y offset, time to stay on same offsets,0
bob:
	incbin	"\FACE-B\datas\TRIANGLE.IMG"
	even
LogoB_img:
	incbin	"\FACE-B\graphs\LOGOC.L7Z"
	even
***************** [ECRAN_05] *****************
*> !",$22,"#$%&",$27,"()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_
greats_texte:
*       +                            +
	dc.b	" ACF AENIGMATICA AGGRESSION ",$ff 
	dc.b	"  ATARI-BOYS  ATARI-LEGEND  ",$ff 
	dc.b	"  AVENA BLABLA CYBERNETICS  ",$ff 
	dc.b	" CREAM CHECKPOINT CYCLADES  ",$ff 
	dc.b	"  DBA D-BUG DHS DUNE EFFECT ",$ff 
	dc.b	"   ELECTRA ELITE EXO7 HMD   ",$ff 
	dc.b	" EXCEPTIONS LEVEL16 LINEOUT ",$ff 
	dc.b	"  LIVE! MUG.UK MAGGIE-TEAM  ",$ff 
	dc.b	" MJJ MYSTIC-BYTES NEW-BEAT  ",$ff
	dc.b	"   NEWLINE NEXT OMEGA OVR   ",$ff
	dc.b $fd	* -> End of the entire text
	even
greats_texte2:
*       +                            +
	dc.b	"    OXYGENE PARADISE PHF    ",$ff 
	dc.b	"     PARADOX PENDRAGONS     ",$ff 
	dc.b	" POPSY-TEAM  REPLICANTS RG  ",$ff
	dc.b	" RESPECTABLES ST-CONNEXION  ",$ff 
	dc.b	" SECTOR-ONE ST-KNIGHTS STAX ",$ff 
	dc.b	" SYNC SYNERGY SUPREMACY TEX ",$ff 
	dc.b	"   THE LOST BOYS TORMENT    ",$ff 
	dc.b	" TOS-CREW TRIPLE-A T.S.C.C. ",$ff 
	dc.b	"    ULM VITALMOTION X-MEN   ",$ff
	dc.b	"          AND ZUUL!         ",$ff
	dc.b $fd	* -> End of the entire text
	even
*
zonka:
	incbin "\FACE-B\datas\MAP1.SCT"
	even
zonkaf:	
	ds.b (zonkaf-zonka)*3
map:
	ds.b (zonkaf-zonka)*4
moves:
	incbin "\FACE-B\datas\MOVES.SCT"
	even
movesf:
	even
Cadre_palette:
	dc.w	$098A,$0000,$0213,$0FFF,$0324,$0BAC,$0A9B,$0FFF
	dc.w	$0424,$0424,$0624,$0000,$0524,$0000,$0000,$0000
Cadre_img:
	incbin	"\FACE-B\graphs\CADRE2.L7Z"
	even
Warning_palette:
	dc.w	$098A,$0000,$0102,$0434,$0555,$0063,$0576,$0070
	dc.w	$0070,$0770,$0776,$0660,$0733,$0744,$0755,$0777
Warning_img:
	incbin	"\FACE-B\graphs\WARNING.L7Z"
	even
***************** [ECRAN_06] *****************
Quadra_palette:
	dc.w	$0808,$0F7F,$07E7,$05C5,$04B4,$03A3,$0292,$0000
	dc.w	$0FB0,$0F00,$0F04,$0F0E,$060F,$0B0F,$004F,$0000
PTR_QUADRA:
	dc.l	QUADRA
QUADRA:
	dc.l	D00
	dc.l	D01
	dc.l	D02
	dc.l	D03
	dc.l	D04
	dc.l	D05
	dc.l	D06
	dc.l	D07
	dc.l	D08
	dc.l	D09
	dc.l	D10
	dc.l	D11
	dc.l	D12
	dc.l	D13
	dc.l	D14
	dc.l	D15
	dc.l	D16
	dc.l	D17
	dc.l	D18
	dc.l	D19
	dc.l	D20
	dc.l	D21
	dc.l	D22
	dc.l	-1
QUADRA_DATA:
	incbin "\FACE-B\datas\QUADRA.L7Z"
	even
NoExtraL_img:
	incbin	"\FACE-B\graphs\NOEXTRAL.IMG"
	even
***************** [ECRAN_07] *****************
COPYADDR:
	dc.l	$0
LINECNT:
	dc.w	10
MSPNT:
	dc.l	MESS
MESS:
*> !"#',$27,'(),-.0123456789:;?@ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
*      +          +
	dc.b "face.b was",$0D,$0D
	dc.b "presented ",$0D,$0D
	dc.b "to you by ",$0D,$0D
	dc.b " noextra  ",$0D,$0D,$0D,$0D
	dc.b " we hope  ",$0D,$0D
	dc.b " that you ",$0D,$0D
	dc.b "like this ",$0D,$0D
	dc.b "superb and",$0D,$0D
	dc.b "short demo",$0D,$0D
	dc.b " we begin ",$0D,$0D
	dc.b " with the ",$0D,$0D
	dc.b " credits  ",$0D,$0D,$0D
	dc.b "assembler ",$0D,$0D
	dc.b " code by  ",$0D,$0D
	dc.b "atomus and",$0D,$0D
	dc.b " zorro 2  ",$0D,$0D,$0D
	dc.b "pixels and",$0D,$0D
	dc.b "graphic by",$0D,$0D
	dc.b " mister.a ",$0D,$0D
	dc.b " and yogi ",$0D,$0D,$0D
	dc.b "all music ",$0D,$0D
	dc.b " made by  ",$0D,$0D
	dc.b " jedi of  ",$0D,$0D
	dc.b "sector one",$0D,$0D,$0D,$0D
	dc.b "and sorry ",$0D,$0D
	dc.b " for lake ",$0D,$0D
	dc.b "of effect ",$0D,$0D
	dc.b " we took  ",$0D,$0D
	dc.b " the rest ",$0D,$0D
	dc.b "for a next",$0D,$0D
	dc.b "  party?  ",$0D,$0D
	dc.b " i won't  ",$0D,$0D
	dc.b "write more",$0D,$0D
	dc.b " because  ",$0D,$0D
	dc.b "   i let  ",$0D,$0D
	dc.b " members  ",$0D,$0D
	dc.b "  explain ",$0D,$0D
	dc.b " more and ",$0D,$0D
	dc.b "  hope a  ",$0D,$0D
	dc.b "   short  ",$0D,$0D
	dc.b " scroller?",$0D,$0D,$0D
	dc.b "many thanx",$0D
	dc.b "to zorro 2",$0D
	dc.b "to take my",$0D
	dc.b "old graphs",$0D
	dc.b "  for the ",$0D
	dc.b "  stniccc ",$0D
	dc.b "hope that ",$0D
	dc.b " you like ",$0D
	dc.b "football ?",$0D
	dc.b " italian  ",$0D
	dc.b "  soccer  ",$0D
	dc.b " team are ",$0D
	dc.b " going to ",$0D
	dc.b " win the  ",$0D
	dc.b " european ",$0D
	dc.b "  cup in  ",$0D
	dc.b " france ! ",$0D
	dc.b "    my    ",$0D
	dc.b " nickname ",$0D
	dc.b "    is    ",$0D
	dc.b " mister.a ",$0D
	dc.b " 'a' like ",$0D
	dc.b "   amiga  ",$0D,$0D
	dc.b "   hylst  ",$0D
	dc.b "   would  ",$0D
	dc.b "  like to ",$0D
	dc.b "   thank  ",$0D
	dc.b " fedepete ",$0D
	dc.b " for his  ",$0D
	dc.b "great work",$0D
	dc.b "    on    ",$0D
	dc.b " st paint ",$0D
	dc.b "  a cool  ",$0D
	dc.b "pixel art ",$0D
	dc.b "win proggy",$0D
	dc.b " specially",$0D
	dc.b " done for ",$0D
	dc.b "  st low  ",$0D
	dc.b "painting !",$0D
	dc.b " my last  ",$0D
	dc.b "picture on",$0D
	dc.b " ste done ",$0D
	dc.b "   with   ",$0D
	dc.b " st paint ",$0D,$0D
	dc.b "  hello ! ",$0D
	dc.b "  then we ",$0D
	dc.b "  did it. ",$0D
	dc.b "   here   ",$0D
	dc.b " yopib33r ",$0D
	dc.b "  at the  ",$0D
	dc.b "vip 2016 !",$0D
	dc.b "   some   ",$0D
	dc.b "  awfull  ",$0D
	dc.b "  pics i  ",$0D
	dc.b " done are ",$0D
	dc.b "  in the  ",$0D
	dc.b " demo, i  ",$0D
	dc.b " hope you ",$0D
	dc.b "liked it ?",$0D
	dc.b "so regards",$0D
	dc.b "and greets",$0D
	dc.b " to vital-",$0D
	dc.b   "motion! ",$0D
	dc.b "and x.men ",$0D
	dc.b "all people",$0D
	dc.b "  at the  ",$0D
	dc.b "party and ",$0D
	dc.b " atari, i ",$0D
	dc.b " begin to ",$0D
	dc.b "loooove as",$0D
	dc.b "  if my   ",$0D
	dc.b "amigaaa :)",$0D
	dc.b "i go make ",$0D
	dc.b "some other",$0D
	dc.b " pics one ",$0D
	dc.b "day, going",$0D
	dc.b " to party ",$0D
	dc.b " now with ",$0D
	dc.b " friends !",$0D
	dc.b "  special ",$0D
	dc.b "greets to ",$0D
	dc.b "shen of vm",$0D
	dc.b " who will ",$0D
	dc.b " perhaps  ",$0D
	dc.b "read this ",$0D
	dc.b "  text :) ",$0D
	dc.b "logg of ! ",$0D,$0D
	dc.b "  we are  ",$0D
	dc.b "late about",$0D
	dc.b "temptation",$0D
	dc.b "demo given",$0D
	dc.b "  at the  ",$0D
	dc.b "  stniccc ",$0D
	dc.b "party the ",$0D
	dc.b "last year ",$0D
	dc.b "project.a ",$0D
	dc.b "launched  ",$0D
	dc.b "there are ",$0D
	dc.b "few years ",$0D
	dc.b " and this ",$0D
	dc.b "multipart ",$0D
	dc.b "  is not  ",$0D
	dc.b "finish yet",$0D
	dc.b "we have a ",$0D
	dc.b "  lot of  ",$0D
	dc.b "  bunch   ",$0D
	dc.b "oldschool ",$0D
	dc.b "effects to",$0D
	dc.b "finish and",$0D
	dc.b " assemble ",$0D
	dc.b "for a next",$0D
	dc.b "  event?  ",$0D
	dc.b "  out of  ",$0D
	dc.b "   time   ",$0D
	dc.b " without  ",$0D
	dc.b "millestone",$0D
	dc.b " noextra! ",$0D
	dc.b "  signed  ",$0D
	dc.b "  atomus  ",$0D,$0D
	dc.b "come back ",$0D
	dc.b " from the ",$0D
	dc.b " stniccc  ",$0D
	dc.b "with a lot",$0D
	dc.b "  of good ",$0D
	dc.b " memories ",$0D
	dc.b "  but we  ",$0D
	dc.b "didn't win",$0D
	dc.b "something ",$0D
	dc.b "hope that ",$0D
	dc.b "vip people",$0D
	dc.b " like our ",$0D
	dc.b "   last   ",$0D
	dc.b "production",$0D
	dc.b " this is  ",$0D
	dc.b "our third ",$0D
	dc.b "attempt in",$0D
	dc.b " france ;)",$0D
	dc.b "last info ",$0D,$0D
	dc.b "  tomchi  ",$0D
	dc.b "decided to",$0D
	dc.b "leave the ",$0D
	dc.b " team one ",$0D
	dc.b "  month   ",$0D
	dc.b "before the",$0D
	dc.b "    vip   ",$0D
	dc.b " deadline ",$0D
	dc.b "thanks for",$0D
	dc.b " your job ",$0D
	dc.b "mate with ",$0D
	dc.b " noextra  ",$0D
	dc.b "good luck ",$0D
	dc.b " for the  ",$0D
	dc.b "  next !  ",$0D

	dc.b $0D,$0D,$0D,$0D,$0D,$0D,$0D
	dc.b $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D

	dc.b "   hope   ",$0D
	dc.b "people at ",$0D
	dc.b " the vip  ",$0D
	dc.b "liked the ",$0D
	dc.b " begin of ",$0D
	dc.b "this atari",$0D
	dc.b " ste demo ",$0D

	dc.b $0D,$0D,$0D,$0D,$0D,$0D,$0D

	dc.b " NOEXTRA  ",$0D,$0D
	dc.b "june  2016",$0D

	dc.b $0D,$0D,$0D,$FF
	even
FONT:
	incbin	"\FACE-B\datas\FONT.DAT"
	even
Zoby_palette:
	dc.w	$0F64,$0000,$09AB,$0B45,$0D66,$0FFF,$0000,$0000
	dc.w	$0012,$0012,$0012,$0012,$0012,$0012,$0000,$0000
Zoby_img:
	incbin	"\FACE-B\graphs\ZOBY.L7Z"
	even
*
MUSIC_INTRO:
	incbin	"\FACE-B\music\JUS2WAIT.SND"
	even
MUSIC:
	incbin	"\FACE-B\music\GENIOUS.SND"
	even

***************************************************************
 SECTION	BSS                                              // *
***************************************************************
*
***************** [ECRAN_01] *****************
***************** [ECRAN_02] *****************
param_0_Bars:
	ds.w	1
param_1_Bars:
	ds.w	1
param_2_Bars:
	ds.w	1
param_3_Bars:
	ds.w	1
param_4_Bars:
	ds.w	1
param_5_Bars:
	ds.w	1
***************** [ECRAN_03] *****************
xyz:
 ds.w 3*nb_stars
***************** [ECRAN_04] *****************
shifted:
	ds.w	34*10*16
*
ptr_mtexte:
	ds.l	1
bit:
	ds.w 	1
buffer:
	ds.w 	8
trav:
	ds.l	220
***************** [ECRAN_05] *****************
nbre_carac:
 ds.w	1
ptr_texte:
	ds.l 1
anim:
	ds.w 1
adr_obj:
	ds.l 1
continu_curseur:
	ds.w	1
***************** [ECRAN_06] *****************
***************** [ECRAN_07] *****************
FONTTAB:
	ds.b	384 
*
bss_start:

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

Buffer_L7Z:
	ds.b	256
	ds.b	200*160*2
t_Buffer_L7Z:
	ds.b	160*200*23	;	736000

D00 equ t_Buffer_L7Z+160*200*00
D01 equ t_Buffer_L7Z+160*200*01
D02 equ t_Buffer_L7Z+160*200*02
D03 equ t_Buffer_L7Z+160*200*03
D04 equ t_Buffer_L7Z+160*200*04
D05 equ t_Buffer_L7Z+160*200*05
D06 equ t_Buffer_L7Z+160*200*06
D07 equ t_Buffer_L7Z+160*200*07
D08 equ t_Buffer_L7Z+160*200*08
D09 equ t_Buffer_L7Z+160*200*09
D10 equ t_Buffer_L7Z+160*200*10
D11 equ t_Buffer_L7Z+160*200*11
D12 equ t_Buffer_L7Z+160*200*12
D13 equ t_Buffer_L7Z+160*200*13
D14 equ t_Buffer_L7Z+160*200*14
D15 equ t_Buffer_L7Z+160*200*15
D16 equ t_Buffer_L7Z+160*200*16
D17 equ t_Buffer_L7Z+160*200*17
D18 equ t_Buffer_L7Z+160*200*18
D19 equ t_Buffer_L7Z+160*200*19
D20 equ t_Buffer_L7Z+160*200*20
D21 equ t_Buffer_L7Z+160*200*21
D22 equ t_Buffer_L7Z+160*200*22

******************************************************************
	END                                                         // *
******************************************************************
