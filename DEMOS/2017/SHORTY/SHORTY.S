***************************************
* // SHORTY.PRG                    // *
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
SIZE_OF_SCREEN  equ 160*200  ; Only Screen size                    *
SYNCHRO_WAIT    equ $900     ; Adresse de la synchro               *
********************************************************************
ECRAN_001        equ 0       ; carre                               *
ECRAN_002        equ 0       ; VRaster Bars + textes               *
ECRAN_003        equ 0       ; VRaster Bars + scroll               *
ECRAN_004        equ 0       ; Split-lines                         *
ECRAN_005        equ 0       ; Checker                             *
ECRAN_006        equ 0       ; V Scrolling                         *
ECRAN_007        equ 0       ; LINE-A Scrolling                    *
ECRAN_008        equ 0       ; Hidden 3D cube                      *
ECRAN_009        equ 0       ; multi-dots                          *
ECRAN_010        equ 0       ; Rasters + greetz                    *
ECRAN_011        equ 0       ; Rasters + textes                    *
ECRAN_012        equ 0       ; HRaster Bars                        *
ECRAN_013        equ 0       ; Raster Bars                         *
ECRAN_014        equ 0       ; Rotozoom                            *
ECRAN_015        equ 0       ; Big ScrollText                      *
ECRAN_016        equ 0       ; Multicube                           *
ECRAN_017        equ 0       ; Circle dots Scrolling               *
ECRAN_018        equ 0       ; Scrolling finale                    *
********************************************************************
TEMPO_ECRAN_001  equ $020    ;                                     *
TEMPO_ECRAN_002  equ $0f0    ;                                     *
TEMPO_ECRAN_003  equ $210    ;                                     *
TEMPO_ECRAN_004  equ $160    ;                                     *
TEMPO_ECRAN_005  equ $160    ;                                     *
TEMPO_ECRAN_006  equ $200-10 ;                                     *
TEMPO_ECRAN_007  equ $100    ;                                     *
TEMPO_ECRAN_008  equ $238    ;                                     *
TEMPO_ECRAN_009  equ $160    ;                                     *
TEMPO_ECRAN_010  equ $0ff    ;                                     *
TEMPO_ECRAN_011  equ $0f0    ;                                     *
TEMPO_ECRAN_012  equ $160    ;                                     *
TEMPO_ECRAN_013  equ $200-60 ;                                     *
TEMPO_ECRAN_014  equ $200    ;                                     *
TEMPO_ECRAN_015  equ $200-20 ;                                     *
TEMPO_ECRAN_016  equ $140    ;                                     *
TEMPO_ECRAN_017  equ $200    ;                                     *
TEMPO_ECRAN_018  equ $120    ;                                     *
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

	move.w	#-1,-(sp)                ; Activate Blitter ...
	move.w	#64,-(sp)                ; ... mode BLIT
	trap	#14
	addq	#4,sp
	btst	#1,d0                      ; Check if blitter exists
	beq.s	.no_blit                   ; if not straight out
	bset	#0,d0                      ; Activated
	move	d0,-(sp)
	move.w	#64,-(sp)                ; Mode BLIT
	trap	#14
	addq	#4,sp
	lea.l $ffff8a00.w,a1             ; 32 bytes halftone ram to clear !
	rept 8
	clr.l (a1)+
	endr
.no_blit:

	bsr	clear_bss                    ; Clean BSS stack
	
	bsr	Save_and_init_st             ; Save system parameters

	bsr	fadein                       ; Fading White to Black Screen
	move.l	#$0,myColor
	bsr	clear_palette

	bsr	Init_screens                 ; Screen initialisations
	bsr	First_screen                 ; Disply screen...

	moveq	#1,d0                      ; Choice of the music (1 is default)
	jsr	MUSIC+0                      ; Init SNDH music

	lea	Vbl(pc),a0                   ; Launch VBL
	move.l	a0,$70.w                 ;

**************************** MAIN LOOP ************************>

;--------------------------------------------------------------> ECRAN_001
 IFEQ ECRAN_001

	move.l	#$00000777,$ffff8240.w

	jsr	init_carre.ok

	move.l	#TEMPO_ECRAN_001,SYNCHRO_WAIT

effet1_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	jsr	play_carre.ok

	bsr	Swap_screens

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet1_loop

	bsr	Clear_Screens

	bsr	First_screen

;	Display logo NoExtra
	move.l	#NoExtra_image,a0                ; FROM ADRESS DATA
	move.w	#0,d2                    ; LEFT FROM ADRESS DATA
	move.w	#0,d3                    ; TOP FROM ADRESS DATA
	move.w	#96,d4        ; WIDTH of bloc
	move.w	#54-1,d5       ; HEIGHT of bloc
	move.w	#4,d6       ; Number of plane
; Destination 1st Screen adress
	move.l	physique,a1          ; TO ADRESS SCREEN
	move.w	#112,d0      ; LEFT TO ADRESS SCREEN
	move.w	#73,d1      ; TOP TO ADRESS SCREEN
	bsr	DoBLiTTER__Operation       ; Launch blitter operation

	lea	NoExtra_image_palette,a0 
	bsr	fade_up

	lea	NoExtra_image_palette,a0            ; Put palette
	bsr	Assign_palette

	move.w	#$70,d7                  ; Temporisation
	bsr	wait_more

	jsr	INIT_DEMO2 <***

	bsr	Clear_Screens

	move.l	#$07770777,myColor
	bsr	clear_palette
	move.w	#1,d3
	jsr	flash_blanc

	bsr	First_screen

	bsr	Put_signature

	lea	Palette_Screen,a0            ; Put palette
	bsr	Assign_palette

 ENDC
;--------------------------------------------------------------< ECRAN_001
;--------------------------------------------------------------> ECRAN_002
 IFEQ ECRAN_002

	move.l	#FondRas_Screen,a0
	bsr	Paint_Screens

	move.l	#$00000777,$ffff8244.w

	lea	texte_intro,a0
	jsr	Little_texte

	jsr	init_rasterTexte.ok

	move.w	#TEMPO_ECRAN_002,d7                  ; Temporisation
	bsr	wait_more

	move.l	#$0,$ffff8244.w

	bsr	Replace_Vbl_Hbl

 ENDC
;--------------------------------------------------------------< ECRAN_002
;--------------------------------------------------------------> ECRAN_003
 IFEQ ECRAN_003

	move.l	#TEMPO_ECRAN_003,SYNCHRO_WAIT

	move.l	#FondRas_Screen,a0
	bsr	Paint_Screens

	bsr	First_screen

	move.l	#$07770000,$ffff8246.w

	jsr	init_scroll_8

	jsr	init_rlignes.ok

effet3_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	jsr	Effet_Escalier

	jsr	scroll_8

	jsr	Efface_signature
	jsr	Bounce_signature

	bsr	Swap_screens

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet3_loop

	jsr	Efface_DEUX_signature
	jsr	Put_signature

	move.l	#$0,$ffff8246.w

	bsr	Replace_Vbl_Hbl

 ENDC
;--------------------------------------------------------------< ECRAN_003
;--------------------------------------------------------------> ECRAN_004
 IFEQ ECRAN_004

	move.l	#TEMPO_ECRAN_004,SYNCHRO_WAIT                  ; Tempo finale !

	move.l	#FondRas_Screen,a0
	bsr	Paint_Screens

	move.l	#$01130777,$ffff8244.w

	jsr	Init_Courbe

effet4_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	jsr	Lignes

	bsr	Swap_screens

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet4_loop

	move.l	#$0,$ffff8244.w

 ENDC
;--------------------------------------------------------------< ECRAN_004
;--------------------------------------------------------------> ECRAN_005
 IFEQ ECRAN_005

	move.l	#TEMPO_ECRAN_005,SYNCHRO_WAIT

	move.l	#Fond_Screen,a0
	bsr	Paint_Screens

***>	jsr	INIT_DEMO2

effet5_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	jsr	UPDATE_DEMO2

	bsr	Swap_screens

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet5_loop

 ENDC
;--------------------------------------------------------------< ECRAN_005
;--------------------------------------------------------------> ECRAN_006
 IFEQ ECRAN_006

	move.l	#TEMPO_ECRAN_006,SYNCHRO_WAIT

	move.l	#FondRas_Screen,a0
	bsr	Paint_Screens

	move.l	#$01130000,$ffff8244.w

	move.l	#Buffer_L7Z,a0
	bsr	clear_blit

	jsr	init_courbe_V 
	jsr	init_texte 
	jsr	generate_code 

effet6_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	jsr	play_generated_code

	bsr	Swap_screens

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet6_loop

	move.l	#$0,$ffff8244.w

	bsr	Replace_Vbl_Hbl

 ENDC
;--------------------------------------------------------------< ECRAN_006
;--------------------------------------------------------------> ECRAN_007
 IFEQ ECRAN_007

	move.l	#TEMPO_ECRAN_007,SYNCHRO_WAIT

	move.l	#Fond_Screen,a0
	bsr	Paint_Screens

	lea	montagnes_palette,a0         ; Put palette
	bsr	Assign_palette

	bsr	First_screen

	jsr	Display_Montagne
	move.w	#$35,d7                  ; Temporisation
	bsr	wait_more

effet7_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	jsr	ScrollBlit
	
	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet7_loop

	lea	Palette_Screen,a0            ; Put palette
	bsr	Assign_palette

 ENDC
;--------------------------------------------------------------< ECRAN_007
;--------------------------------------------------------------> ECRAN_008
 IFEQ ECRAN_008

	move.l	#TEMPO_ECRAN_008,SYNCHRO_WAIT

	lea	hidden_palette,a0            ; Put palette
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d3               ;
	movem.l	d0-d3,(a1)               ;

	move.l	#FondRas_Screen,a0
	bsr	Paint_Screens

	jsr init_line
	jsr make_courbe
	jsr	init_mscroll

effet8_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	jsr	hidden_square

	bsr	Swap_screens

	jsr	mscroll

	jsr	patch_Scroll

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet8_loop

	lea	Palette_Screen,a0            ; Put palette
	bsr	Assign_palette

 ENDC
;--------------------------------------------------------------< ECRAN_008
;--------------------------------------------------------------> ECRAN_009
 IFEQ ECRAN_009

	move.l	#TEMPO_ECRAN_009,SYNCHRO_WAIT

	move.l	#Fond_Screen,a0
	bsr	Paint_Screens

	move.l	#$01130000,$ffff8250.w

effet9_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	jsr	play_field.ok

	bsr	Swap_screens

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet9_loop

	move.l	#$0,$ffff8250.w

 ENDC
;--------------------------------------------------------------< ECRAN_009
;--------------------------------------------------------------> ECRAN_010
 IFEQ ECRAN_010

	move.l	#TEMPO_ECRAN_010-100,SYNCHRO_WAIT

	move.l	#$07770777,$ffff8244.w

	move.l	#FondRas_Screen,a0
	bsr	Paint_Screens

	bsr	First_screen

	jsr	init_raster.ok

	move.l	#vert,ptr_red_bar

	movem.l	null,d0-a6               ; Texte Screen #1
	movea.l	physique,a5          ;
	add.l	#160*77+8*7,a5
	lea	title,a1
	jsr	print_text  

effet10a_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	jsr	raster

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet10a_loop

* next...

	move.l	#FondRas_Screen,a0
	bsr	Paint_Screens

	move.l	#TEMPO_ECRAN_010+44,SYNCHRO_WAIT

	move.l	#violet,ptr_red_bar

	movem.l	null,d0-a6               ; Texte Screen #1
	movea.l	physique,a5              ;
	add.l	#160*77+8*7,a5
	lea	message,a1
	jsr	print_text  

effet10b_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	cmpi.l	#TEMPO_ECRAN_010/2+20,SYNCHRO_WAIT
	bne.s	.no_change_col_ras__1
	move.l	#bleu,ptr_red_bar
.no_change_col_ras__1:

	jsr	raster

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet10b_loop

	bsr	Replace_Vbl_Hbl

	move.l	#$0,$ffff8244.w

 ENDC
;--------------------------------------------------------------< ECRAN_010
;--------------------------------------------------------------> ECRAN_011
 IFEQ ECRAN_011

	move.l	#FondRas_Screen,a0
	bsr	Paint_Screens

	move.l	#$00000777,$ffff8244.w

	lea	texte_color,a0
	jsr	Little_texte

	jsr	init_rasterTexte.ok

	move.w	#TEMPO_ECRAN_011,d7                  ; Temporisation
	bsr	wait_more

	jsr	init_rotojedi <***

	move.l	#$0,$ffff8244.w

	bsr	Replace_Vbl_Hbl

 ENDC
;--------------------------------------------------------------< ECRAN_011
;--------------------------------------------------------------> ECRAN_012
 IFEQ ECRAN_012

	move.l	#TEMPO_ECRAN_012,SYNCHRO_WAIT

	lea	palette_tube,a0              ; Put palette
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d3               ;
	movem.l	d0-d3,(a1)               ;

	move.l	#Fond_Screen,a0
	bsr	Paint_Screens

	bsr	First_screen

effet12_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	jsr	TUBES

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet12_loop

	bsr	Clear_two_bitplanes

	lea	Palette_Screen,a0            ; Put palette
	bsr	Assign_palette

 ENDC
;--------------------------------------------------------------< ECRAN_012
;--------------------------------------------------------------> ECRAN_013
 IFEQ ECRAN_013

	move.l	#TEMPO_ECRAN_013,SYNCHRO_WAIT

	move.l	#Fond_Screen,a0
	bsr	Paint_Screens
	bsr	First_screen

	jsr	GENERATE_RB

	lea	RastBars_palette,a0            ; Put palette
	bsr	Assign_palette

effet13_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	jsr	PLAY_RB

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet13_loop

	lea	Palette_Screen,a0            ; Put palette
	bsr	Assign_palette

 ENDC
;--------------------------------------------------------------< ECRAN_013
;--------------------------------------------------------------> ECRAN_014
 IFEQ ECRAN_014

	move.l	#TEMPO_ECRAN_014,SYNCHRO_WAIT

	move.l	#Fond_Screen,a0
	bsr	Paint_Screens

***>	jsr	init_rotojedi

effet14_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	jsr	rotojedi

	bsr	Swap_screens

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet14_loop

 ENDC
;--------------------------------------------------------------< ECRAN_014
;--------------------------------------------------------------> ECRAN_015
 IFEQ ECRAN_015

	move.l	#TEMPO_ECRAN_015,SYNCHRO_WAIT                  ; Tempo finale !

	move.l	#Fond_Screen,a0
	bsr	Paint_Screens

	bsr	First_screen	

	bsr	Clear_two_bitplanes
	
	move.l	#okitext,pt_text           ; Or restart the text

effet15_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	jsr	Scrolling
	jsr	Scrolling

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet15_loop

 ENDC
;--------------------------------------------------------------< ECRAN_015
;--------------------------------------------------------------> ECRAN_016
 IFEQ ECRAN_016

	move.l	#TEMPO_ECRAN_016,SYNCHRO_WAIT

	move.l	#FondRas_Screen,a0
	bsr	Paint_Screens

	bsr	First_screen	

	jsr	init_squares.ok

	jsr	init_play_squares

effet16_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	jsr	play_squares

	bsr	Swap_screens

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet16_loop

	bsr	Replace_Vbl_Hbl

 ENDC
;--------------------------------------------------------------< ECRAN_016
;--------------------------------------------------------------> ECRAN_017
 IFEQ ECRAN_017

	move.l	#TEMPO_ECRAN_017,SYNCHRO_WAIT

	move.l	#Buffer_L7Z,a0
	bsr	clear_blit

	move.l	#$01130777,$ffff8244.w

	move.l	#FondRas_Screen,a0
	bsr	Paint_Screens

effet17_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	jsr	play_Texte_Circle

	bsr	Swap_screens

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet17_loop

	move.l	#$0,$ffff8244.w

 ENDC
;--------------------------------------------------------------< ECRAN_017
;--------------------------------------------------------------> ECRAN_018
 IFEQ ECRAN_018

	move.l	#TEMPO_ECRAN_018,SYNCHRO_WAIT

	move.l	#Fond_Screen,a0
	bsr	Paint_Screens

	bsr	Clear_two_bitplanes

	bsr	First_screen	

	jsr	init_rastapla

	move.l	#fintext,pt_text           ; Or restart the text

effet18_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s	effet18_loop

	bsr	Replace_Vbl_Hbl

	move.l	#$0,$ffff8244.w

 ENDC
;--------------------------------------------------------------< ECRAN_018

	move.w	#3,d3
	jsr	flash_blanc

	move.l	#Fond_Screen,a0
	bsr	Paint_Screens

	bsr	First_screen

	move.l	#Girl_image,a0                ; FROM ADRESS DATA
	move.w	#0,d2                    ; LEFT FROM ADRESS DATA
	move.w	#0,d3                    ; TOP FROM ADRESS DATA
	move.w	#96,d4        ; WIDTH of bloc
	move.w	#54,d5       ; HEIGHT of bloc
	move.w	#4,d6       ; Number of plane
; Destination 1st Screen adress
	move.l	physique,a1          ; TO ADRESS SCREEN
	move.w	#112,d0      ; LEFT TO ADRESS SCREEN
	move.w	#73,d1      ; TOP TO ADRESS SCREEN
	bsr	DoBLiTTER__Operation       ; Launch blitter operation

	lea	Girl_image_palette,a0 
	bsr	fade_up

	lea	Girl_image_palette,a0            ; Put palette
	bsr	Assign_palette

	move.w	#$ad,d7                  ; Temporisation
	bsr	wait_more

	moveq   #20-1,D7                 ; Temporisation
.end_fadeE:
	lea     $ffff8240.w,A0           ; Palette Logo
	moveq   #15,D2
	jsr     fade_down
	bsr	Wait_vbl                     ; Waiting after the VBL
	dbra    D7,.end_fadeE

	move.l	#$0,myColor
	bsr	clear_palette

	bsr	First_screen
	bsr	Clear_Screens

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

Init_screens:
	move.l	#Screen_1,d0             ; Set physical Screen #1
	add.w	#$ff,d0                    ;
	sf	d0                           ;
	move.l	d0,physique              ;
	move.l	#Screen_2,d0             ; Set logical Screen #2
	sf	d0                           ;
	move.l	d0,physique+4            ;
Clear_Screens:                     ; Cleare 2 Screens Fast !
	move.l	physique(pc),a0
	bsr.s	clear_blit
	move.l	physique+4(pc),a0
	bsr.s	clear_blit
	rts

clear_blit:
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	moveq	#0,d7
	move.l	d1,a1
	move.l	d1,a2
	move.l	d1,a3
	move.l	d1,a4
	move.l	d1,a5
	move.l	d1,a6
	move	#152,d0
	add.l	#SIZE_OF_SCREEN,a0
.clr_scr:
	movem.l	d1-d7/a1-a6,-(a0)
	movem.l	d1-d7/a1-a6,-(a0)
	movem.l	d1-d7/a1-a6,-(a0)
	movem.l	d1-d7/a1-a6,-(a0)
	dbra	d0,.clr_scr
	movem.l	d1-d7/a1-a6,-(a0)
	movem.l	d1-d7/a1-a6,-(a0)
	movem.l	d1-d7/a1-a6,-(a0)
	movem.l	d1-d5,-(a0)
	rts

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

Paint_Screens:
	move.l	a0,adr_sav
	move.w	#110,d2                    ; LEFT FROM ADRESS DATA
	move.w	#0,d3                    ; TOP FROM ADRESS DATA
	move.w	#100,d4        ; WIDTH of bloc
	move.w	#58,d5       ; HEIGHT of bloc
	move.w	#4,d6       ; Number of plane
; Destination 1st Screen adress
	move.l	physique,a1          ; TO ADRESS SCREEN
	move.w	#110,d0      ; LEFT TO ADRESS SCREEN
	move.w	#71,d1      ; TOP TO ADRESS SCREEN
	bsr	DoBLiTTER__Operation       ; Launch blitter operation
	move.l	adr_sav,a0
	move.w	#110,d2                    ; LEFT FROM ADRESS DATA
	move.w	#0,d3                    ; TOP FROM ADRESS DATA
	move.w	#100,d4        ; WIDTH of bloc
	move.w	#58,d5       ; HEIGHT of bloc
	move.w	#4,d6       ; Number of plane
; Destination 1st Screen adress
	move.l	physique+4,a1          ; TO ADRESS SCREEN
	move.w	#110,d0      ; LEFT TO ADRESS SCREEN
	move.w	#71,d1      ; TOP TO ADRESS SCREEN
	bsr	DoBLiTTER__Operation       ; Launch blitter operation
	rts
adr_sav:
	ds.l	1

Put_signature:
	move.l	#Signature_image,a0                ; FROM ADRESS DATA
	move.w	#0,d2                    ; LEFT FROM ADRESS DATA
	move.w	#0,d3                    ; TOP FROM ADRESS DATA
	move.w	#320,d4        ; WIDTH of bloc
	move.w	#7,d5       ; HEIGHT of bloc
	move.w	#4,d6       ; Number of plane
; Destination 1st Screen adress
	move.l	physique,a1          ; TO ADRESS SCREEN
	move.w	#0,d0      ; LEFT TO ADRESS SCREEN
	move.w	#200-7,d1      ; TOP TO ADRESS SCREEN
	bsr	DoBLiTTER__Operation       ; Launch blitter operation
	move.l	#Signature_image,a0                ; FROM ADRESS DATA
	move.w	#0,d2                    ; LEFT FROM ADRESS DATA
	move.w	#0,d3                    ; TOP FROM ADRESS DATA
	move.w	#320,d4        ; WIDTH of bloc
	move.w	#7,d5       ; HEIGHT of bloc
	move.w	#4,d6       ; Number of plane
; Destination 1st Screen adress
	move.l	physique+4,a1          ; TO ADRESS SCREEN
	move.w	#0,d0      ; LEFT TO ADRESS SCREEN
	move.w	#200-7,d1      ; TOP TO ADRESS SCREEN
	bsr	DoBLiTTER__Operation       ; Launch blitter operation
	rts

***************************************************************
*                                                             *
*                        Vbl Routines                         *
*                                                             *
***************************************************************
Vbl:
	st	Vsync                        ; Synchronisation
	movem.l	d0-d7/a0-a6,-(a7)
	jsr 	(MUSIC+8)                  ; Play SNDH music
	movem.l	(a7)+,d0-d7/a0-a6
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
	move.l	a0,-(a7)                 ;
	lea	Vbl(pc),a0                   ; Launch VBL
	move.l	a0,$70.w                 ;
	clr.b	$fffffa1b.w                ; Stop Timer B
	lea	myrte(pc),a0                 ; Stop HBL
	move.l	a0,$120.w                ;
	move.l	(a7)+,a0                 ;
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

	bclr #3,$fffffa17.w              ; Automatic End-Interrupt hbl ON

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

 include "E:\SHORTY\UTILS.ASM"
 include "E:\SHORTY\carre.ok\include.s"
 include "E:\SHORTY\checkers.ok\include.s"
 include "E:\SHORTY\damiers.ok\include.s"
 include "E:\SHORTY\field.ok\include.s"
 include "E:\SHORTY\hidden.ok\include.s"
 include "E:\SHORTY\montagne.ok\include.s"
 include "E:\SHORTY\rastbars.ok\include.s"
 include "E:\SHORTY\raster.tim\include.s"
 include "E:\SHORTY\rlignes.tim\include.s"
 include "E:\SHORTY\scroll_v.ok\include.s"
 include "E:\SHORTY\squares.tim\include.s"
 include "E:\SHORTY\textcir.ok\include.s"
 include "E:\SHORTY\tube.ok\include.s"
 include "E:\SHORTY\curve.ok\include.s"
 include "E:\SHORTY\rastext.tim\include.s"
 include "E:\SHORTY\greetz.txt\include.s"
 include "E:\SHORTY\scrollp.txt\include.s"
 include "E:\SHORTY\bgscroll.txt\include.s"
 include "E:\SHORTY\scrol8x8.ok\include.s"
 include "E:\SHORTY\bounce.ok\include.s"
 include "E:\SHORTY\rastapla.tim\include.s"
	even

***************************************************************
 SECTION	DATA                                             // *
***************************************************************

***************** [ECRAN_001] *****************
sin_cos:
  incbin	"E:\SHORTY\carre.ok\SIN_COS.xxx"
	even
alphaC:
 dc.w	0
a equ 100+00
b equ 100+20
coords:
  dc.w	-a,-b
  dc.w	-a,+b
  dc.w	+a,+b
  dc.w	+a,-b
	even
***************** [ECRAN_005] *****************
FILL23:
	incbin	"E:\SHORTY\checkers.ok\FILL23.DAT"
	even
SINES:
	incbin	"E:\SHORTY\checkers.ok\SINES.DAT"
	even
YBIT_MAPS:
	incbin	"E:\SHORTY\checkers.ok\YBIT_MAPS.DAT"
	even
***************** [ECRAN_014] *****************
zonka:
	incbin "E:\SHORTY\damiers.ok\map1.sct"
	even
zonkaf:	
	ds.b (zonkaf-zonka)*3
map:
	ds.b (zonkaf-zonka)*4
moves:
	incbin "E:\SHORTY\damiers.ok\moves.sct"
	even
movesf:
	even
***************** [ECRAN_009] *****************
Dots_D00:
	incbin	"E:\SHORTY\field.ok\DOTS01.DAT"
	even
Dots_D01:
	incbin	"E:\SHORTY\field.ok\DOTS02.DAT"
	even
Dots_D02:
	incbin	"E:\SHORTY\field.ok\DOTS03.DAT"
	even
Dots_D03:
	incbin	"E:\SHORTY\field.ok\DOTS04.DAT"
	even
Dots_D04:
	incbin	"E:\SHORTY\field.ok\DOTS05.DAT"
	even
Dots_D05:
	incbin	"E:\SHORTY\field.ok\DOTS06.DAT"
	even
all_dots:
  DC.W	74
size_dots:
  DC.W	400+14 
numb_dots:
  DC.W	55
d_axe_X:
  DC.W	$0 
d_axe_Y:
  DC.W	$0 
d_axe_Z:
  DC.W	$0 
L1_dots:
  DC.L	$0
L2_dots:
  DC.L	$0
L3_dots:
  DC.L	$0
L4_dots:
  DC.L	$0
L5_dots:
  DC.L	$0
L6_dots:
  DC.L	$0
buffer_dots:
  DCB.W	60,$0
***************** [ECRAN_008] *****************
nbre_points	equ 8
nbre_face	  equ 6
object:
	ds.w 2*nbre_points
alpha:
	dc.w 50*4
beta:
	dc.w 20*4
adr_clr1:
	dc.l clr_buf
adr_clr2:
	dc.l clr_buf2
fin_clr1:
	dc.l clr_buf2
fin_clr2:
	dc.l clr_buf3
courbe:
	ds.w 360*3
cosinus:
	incbin "E:\SHORTY\hidden.ok\cosinus.dat"
	even
ESP equ 20
points:
 dc.w -ESP,-ESP,-ESP
 dc.w ESP,-ESP,-ESP
 dc.w ESP,ESP,-ESP
 dc.w -ESP,ESP,-ESP
 dc.w -ESP,-ESP,ESP
 dc.w ESP,-ESP,ESP
 dc.w ESP,ESP,ESP
 dc.w -ESP,ESP,ESP
face_data
 dc.w 0*4,1*4,2*4,3*4
 dc.w 1*4,5*4,6*4,2*4
 dc.w 4*4,7*4,6*4,5*4 
 dc.w 0*4,3*4,7*4,4*4
 dc.w 0*4,4*4,5*4,1*4
 dc.w 3*4,2*4,6*4,7*4
clr_buf	
 rept 1200
 dc.l $78000
 endr
clr_buf2
 rept 1200
 dc.l $78000
 endr
clr_buf3
hidden_palette:
	dc.w	$0012,$0000,$0113,$0000,$0000,$0000,$0777,$0000
*
mtexte:
* < !'#$%&"()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyzCUR> *
	dc.b "  it's not easy to make large effects in this small area..               "
	dc.b	-1
	even
mfonts:
	incbin	"E:\SHORTY\scrollp.txt\fontsmall.DAT"
	even
***************** [ECRAN_007] *****************
montagnes_palette:
	dc.w	$0012,$0312,$0212,$0432,$0532,$0543,$0643,$0422
	dc.w	$0322,$0000,$0337,$0447,$0557,$0667,$0777,$0333
montagnes:
	incbin	"E:\SHORTY\montagne.ok\MONTAGN2.IMG"
	even
***************** [ECRAN_013] *****************
RastBars_palette:
	dc.w	$0012,$0047,$0057,$0067,$0077,$0076,$0277,$0267
	dc.w	$0257,$0247,$0337,$0447,$0557,$0667,$0677,$0777
buffer_display:
	DCB.W	80,$0
courbe_RB:
	incbin	"E:\SHORTY\rastbars.ok\datarb.dat"
	even
swap1_RB:
	DC.L	$0
swap2_RB:
	DC.L	$0
mask_RB:
	dc.w	%101010101010101
	dc.w	%011001100110011
	dc.w	%000111100001111
	dc.w	%000000011111111
points_RB:
	DCB.W	30,$0
	even
***************** [ECRAN_010] *****************
wave_offset:
	dc.w	$0
the_col:
	dc.l	$0
vert:
	dc.w	$030,$030,$040,$040,$050,$050,$060,$060,$070,$070,$060,$060,$050,$050,$040,$040,$030,$030 * vert 3
bleu:
	dc.w	$013,$013,$024,$024,$035,$035,$046,$046,$057,$057,$046,$046,$035,$035,$024,$024,$013,$013 * bleu claire
violet:
	dc.w	$103,$103,$204,$204,$305,$305,$406,$406,$507,$507,$406,$406,$305,$305,$204,$204,$103,$103 * violet fonce
wave:
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	2,2,2,4
	dc.w	6,6,8,$A
	dc.w	$C,$E,$10,$14
	dc.w	$16,$18,$1C,$1E
	dc.w	$22,$26,$2A,$2E
	dc.w	$32,$36,$3A,$3E
	dc.w	$42,$48,$4C,$50
	dc.w	$56,$5C,$62,$66
	dc.w	$6C,$72,$78,$80
	dc.w	$86,$8C,$92,$9A
	dc.w	$A2,$A8,$B0,$B8
	dc.w	$C0,$C8,$D0,$D8
	dc.w	$E0,$E8,$F2,$FA
	dc.w	$102,$10C,$116,$120
	dc.w	$128,$132,$13C,$146
	dc.w	$13C,$132,$128,$120
	dc.w	$116,$10C,$102,$FA
	dc.w	$F2,$E8,$E0,$D8
	dc.w	$D0,$C8,$C0,$B8
	dc.w	$B0,$A8,$A2,$9A
	dc.w	$92,$8C,$86,$80
	dc.w	$78,$72,$6C,$66
	dc.w	$62,$5C,$56,$50
	dc.w	$4C,$48,$42,$3E
	dc.w	$3A,$36,$32,$2E
	dc.w	$2A,$26,$22,$1E
	dc.w	$1C,$18,$16,$14
	dc.w	$10,$E,$C,$A
	dc.w	8,6,6,4
	dc.w	2,2
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
*
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
title:
 DC.B "                       ",1,1
 DC.B "                       ",1,1
 DC.B "  shorty greetings...  ",1,1
 DC.B "                       ",1,1
 DC.B "                       ",1,1
 DC.B "                       ",0
message:
 DC.B " .phf.elite.tscc.zuul.",1,1
 DC.B ".reps!.dhs.eqx.pulsion.",1,1
 DC.B ".hmd.impact.sector one.",1,1
 DC.B ".dune.tce.fuzion.effect.",1,1
 DC.B ".triplea.msb.live!.sync.",1,1
 DC.B " .pdx.checkpoint.cream.",0
 even
***************** [ECRAN_003] *****************
Pointeurs_colors:
  DC.L	Buffer_colors 
Buffer_colors:
  DC.W	$0100 
Rasters_colors:
*        bleu-rouge-jaune
	dc.w	$0110,$0008,$0100
	dc.w	$0990,$0001,$0100
	dc.w	$0220,$0009,$0100
	dc.w	$0002,$0AA0,$0100
	dc.w	$000A,$0AA0,$0200
	dc.w	$0003,$0330,$0200
	dc.w	$0BB0,$000B,$0200
	dc.w	$0440,$0004,$0300
	dc.w	$0CC0,$0004,$0300
	dc.w	$000C,$0550,$0400
	dc.w	$0005,$0DD0,$0400
	dc.w	$000D,$0DD0,$0400
	dc.w	$0660,$0006,$0500
	dc.w	$0EE0,$000E,$0500
	dc.w	$0770,$0007,$0600
	dc.w	$000F,$0FF0,$0600
	dc.w	$001F,$0FF1,$0700
	dc.w	$002F,$0FF2,$0700
	dc.w	$0FF3,$003F,$0800
	dc.w	$0FF4,$004F,$0800
	dc.w	$0FF5,$005F,$0900
	dc.w	$006F,$0FF6,$0A00
	dc.w	$007F,$0FF7,$0000
	DCB.W	6,0
Pointeur_stairs:
  DC.W	$0
*
texte_8:
* < !'#$%&"()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyzCUR> *
	dc.b "  a special tribute of the Big Border demo by Delta Force.........     "
	dc.b "                    "
	dc.b	-1
	even
font_8:
	incbin	"E:\SHORTY\scrol8x8.ok\KLEIN.DAT"
	even
***************** [ECRAN_006] *****************
curve_V1:
	dc.w	$0000,$010D,$0000,$000E,$0000,$0007,$0000,$0004,$0000,$0001
curve_V2:
	dc.w	$0901,$00FF,$FF08,$0402,$0100
curve_V3:
	dc.w	$0B04,$0700,$011F,$FFFF,$001F
pos_V01:
	dc.w	$3953,0
pos_V02:
	dc.w	$395B,0
pos_V03:
	dc.w	$264E
pos_V04:
	dc.w	$284D
pos_V05:
	dc.w	$D6D8
fonte_V:
	incbin	"E:\SHORTY\scroll_v.ok\FONTEV.DAT"
	even
courbe_V: 
	incbin	"E:\SHORTY\scroll_v.ok\COURBEV.DAT"
	even
compteur_V:
	dc.l	$0
texte_V:
	dc.b	"     DREAM TO GO FAR AWAY ???        "
	dc.b	-1
	even 
add_V:
	dc.w	$0
***************** [ECRAN_016] *****************
cubes:
	incbin	"E:\SHORTY\squares.tim\cubes.bin"
fincubes:
	even
***************** [ECRAN_012] *****************
TUBE01:
	incbin	"E:\SHORTY\tube.ok\TUBE01.DAT"
	even
TUBE02:
	incbin	"E:\SHORTY\tube.ok\TUBE02.DAT"
	even
palette_tube:
	dc.w	$0012,$0703,$0702,$0602,$0503,$0403,$0303,$0203
***************** [ECRAN_017] *****************
PTR_ASCII:
	DC.L	ASCIIc
TEST_CARAC:
	DC.W	0
PTR_TEXTE_CIRCLE:
	DC.L	TEXTE_CIRCLE 
TEXTE_CIRCLE:
* ! "',$27,'(),-.:;?ABCDEFGHIJKLMNOPQRSTUVWXYZ
	DC.B	" CODE : ZORRO II     GRAPH : MIZTER.A     MUZAX : JEDI       "
	DC.B	$0
	even
COURBES:
	incbin	"E:\SHORTY\textcir.ok\COURBES.DAT"
	even
ASCIIc:
	incbin	"E:\SHORTY\textcir.ok\ASCII.DAT"
	even
CHARACTERS:
	incbin	"E:\SHORTY\textcir.ok\CHARS.DAT"
	even
***************** [ECRAN_015] *****************
sequence: ; 16 pixels synchro
	dc.w	$0
fonteB:
	INCBIN	"E:\SHORTY\bgscroll.txt\CHAR16.RAW"
	even
list_chr: ; All characters usable
	dc.b	" !     '()  ,-. 0123456789:    ? ABCDEFGHIJKLMNOPQRSTUVWXYZ",0
	even
pt_text: ; The Text of the Scrolling
	dc.l	okitext
okitext:
	dc.b	" OK! MORE SQUARES THAN HEMOROIDS? YES! IT",$27,"S POSSIBLE !!!!          ",0
	even
fintext:
	dc.b	" NOEXTRA-TEAM... IT'S FINISH...                                          ",0
	even
***************** [ECRAN_002] *****************
pointeur_plan:
	dc.w	$0
asciiRT:
	DC.B      $00,$00,$00,$01,$00,$08,$00,$09 
	DC.B      $00,$10,$00,$11,$00,$18,$00,$19 
	DC.B      $00,$20,$00,$21,$00,$28,$00,$29 
	DC.B      $00,$30,$00,$31,$00,$38,$00,$39 
	DC.B      $00,$40,$00,$41,$00,$48,$00,$49 
	DC.B      $00,$50,$00,$51,$00,$58,$00,$59 
	DC.B      $00,$60,$00,$61,$00,$68,$00,$69 
	DC.B      $00,$70,$00,$71,$00,$78,$00,$79 
	DC.B      $00,$80,$00,$81,$00,$88,$00,$89 
	DC.B      $00,$90,$00,$91,$00,$98,$00,$99 
	DC.B      $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF 
texte_intro:
; !",$22,"#&",$27,"()*+,-./0123456789:;<=>?ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz
	DC.B      $FD ; en 1er plan
	DC.B      $FE ; ligne suivante
	DC.B      " presents",$FE,$FE
	DC.B      "  A SHORTY",$FE
	DC.B      "   BORDER",$FE
	DC.B      "    DEMO",$FE
	DC.B      $FF ; fin du texte
texte_color:
	DC.B      $FD ; en 1er plan
	DC.B      $FE,$FE
	DC.B      " much more",$FE,$FE
	DC.B      "  COLORS ?",$FE
	DC.B      $FF ; fin du texte
	EVEN
fonte:
	incbin	"E:\SHORTY\rastext.tim\FONTE88.FNT"
	even
*
COULEUR:
	dc.w	$403,$504,$605,$706,$605,$504,$403 * violet claire
	dc.w	$204,$305,$406,$507,$406,$305,$204 * violet fonce
	dc.w	$004,$005,$006,$007,$006,$005,$004 * bleu fonce
	dc.w	$024,$035,$046,$057,$046,$035,$024 * bleu claire
	dc.w	$043,$054,$065,$076,$065,$054,$043 * vert
	dc.w	$430,$540,$650,$760,$650,$540,$430 * jaune
	dc.w	$410,$520,$630,$740,$630,$520,$410 * orange
LIGNE:
	dc.w	$1E20,$2325,$272A,$2C2E
	dc.w	$3032,$3435,$3738,$393A
	dc.w	$3B3B,$3B3B,$3B3B,$3A3A
	dc.w	$3937,$3635,$3331,$2F2D
	dc.w	$2B29,$2624,$211F,$1C1A
	dc.w	$1715,$1210,$0E0C,$0A08
	dc.w	$0605,$0402,$0101,$0000
	dc.w	$0000,$0000,$0102,$0304
	dc.w	$0607,$090B,$0D0F,$1114
	dc.w	$1618,$1B1D,$2023,$2527
	dc.w	$2A2C,$2E30,$3234,$3537
	dc.w	$3839,$3A3B,$3B3B,$3B3B
	dc.w	$3B3A,$3A39,$3736,$3533
	dc.w	$312F,$2D2B,$2926,$2421
	dc.w	$1F1C,$1A17,$1512,$100E
	dc.w	$0C0A,$0806,$0504,$0201
	dc.w	$0100,$0000,$0000,$0001
	dc.w	$0203,$0406,$0709,$0B0D
	dc.w	$0F11,$1416,$181B,$0000
***************** [ECRAN_004] *****************
Snbre_points:
 dc.w 0
adr_buf1:
 dc.l old_data
old_data
 ds.l 300
adr_buf2:
 dc.l old_data2
old_data2:
 ds.l 300
params_curve:
 dc.w 80/2+10,7,40,3,8+4
 dc.w 170/4,2,100/4-12,4,4
 dc.w 359
sprite:
 dc.l $38000000,$78000c00,$b6004c00
 dc.l $be004000,$be004000,$44003800
Scosinus:
 incbin "E:\SHORTY\curve.ok\cosinus.dat"
 even
***************** [ECRAN_018] *****************
COUNT_COLOR:
	DC.L	$0
PTR_THE_COLOR:
	DC.L	$0
PAL_COLOR:
	incbin	"E:\SHORTY\rastapla.tim\PALRASTA.DAT"
	even
COLORS:
	incbin	"E:\SHORTY\rastapla.tim\COLRASTA.DAT"
	even
***********************************************
Palette_Screen:
	dc.w	$0012,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0337,$0447,$0557,$0667,$0777,$0113
ImageFond_Screen:
	incbin	"E:\SHORTY\_gfx\CADRE3.IMG"
	even
Fond_Screen equ ImageFond_Screen
ImageFond_Raster_Screen:
	incbin	"E:\SHORTY\_gfx\CADRERAS.IMG"
	even
FondRas_Screen equ ImageFond_Raster_Screen
Signature_image:
	incbin	"E:\SHORTY\_gfx\SIGNATUR.IMG"
	even
Girl_image_palette:
	dc.w	$0112,$0114,$0224,$0334,$0444,$0554,$0664,$0774
	dc.w	$0776,$0000,$0337,$0447,$0557,$0667,$0777,$0113
Girl_image:
	incbin	"E:\SHORTY\_gfx\GFX1.IMG"
	even
NoExtra_image_palette:
	dc.w	$0002,$0016,$0116,$0114,$0216,$0316,$0416,$0516
	dc.w	$0616,$0716,$0717,$0727,$0000,$0000,$0000,$0112
NoExtra_image:
	incbin	"E:\SHORTY\_gfx\NOEX02.IMG"
	even
MUSIC:
	incbin	"INTERME2.SND" ; Jedi unrelease Music for Keops...
	even

***************************************************************
 SECTION	BSS                                              // *
***************************************************************

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

Screen_1:
	ds.b	256
	ds.b	SIZE_OF_SCREEN
Screen_2:
	ds.b	SIZE_OF_SCREEN
Buffer_L7Z: ; eXtra Buffer...
	ds.b	SIZE_OF_SCREEN
***************** [ECRAN_001] *****************
Code_gen:         ds.w	(2*NB_BLOC_SUPP)*NB_LIGNE_GENERE		* Place pour le code genere
									   									* pour l'effacement de l'elt 3d
								  ds.w	1							* Place pour le rts
rien:            	ds.b	10000/4
new_coords:
	ds.w	1*4
aucasou:
	ds.w	100
	even
pas_trace:
	ds.w	1
coords_old:
	ds.w	2
	ds.w	2
	ds.w	2
	ds.w	2
***************** [ECRAN_005] *****************
DEMO2_X:
	DS.W	1 
DEMO2_Y:
	DS.W	1 
CHECK_ADDRS:
	DS.B	65536 
CHECK_INDEX:
	DS.B	128 
CHECK_OFFSET:
	DS.B	128 
CHECK_MAX:
	DS.B	128 
CHECK_REV:
	DS.B	128 
***************** [ECRAN_014] *****************
***************** [ECRAN_009] *****************
***************** [ECRAN_008] *****************
Mptr_mtexte:
	ds.l	1
Mpas_car:
	ds.w 	1
Mbuffer_car:
	ds.w 	8
Mbuffer_mscrol:
	ds.w	200
***************** [ECRAN_007] *****************
***************** [ECRAN_013] *****************
buffer_gen_1_RB:
	DS.B	512 
buffer_gen_2_RB:
	DS.B	5280
***************** [ECRAN_010] *****************
ptr_red_bar:
	ds.l	1
bufferRas:
	ds.w	200
null:
	ds.l	16
***************** [ECRAN_003] *****************
ptr_texte_8:
	ds.l	1
pas_car_8:
	ds.w 	1
buffer_car_8:
	ds.w 	8
buffer_scrol_8:
	ds.w	200
***************** [ECRAN_006] *****************
Generate:
	DS.B	3000
***************** [ECRAN_016] *****************
***************** [ECRAN_012] *****************
BUFF_T0:
	DS.B	32
BUFF_T1:
	DS.L	1 
***************** [ECRAN_017] *****************
***************** [ECRAN_015] *****************
***************** [ECRAN_002] *****************
COMPTEUR_HBL
	ds.l	1
BUFFER_COLOR
	ds.b	4*8*8
COMPTEURRT
	ds.l	1
***************** [ECRAN_004] *****************
Scourbe:
 ds.w 720*2
Scourbe2:
 ds.w 720*2
***************** [ECRAN_018] *****************
THE_COLOR:
	DS.B	656 
	EVEN

******************************************************************
	END                                                         // *
******************************************************************
