**************************************
* // Intro Code version 0.35      // *
* // Original code : Zorro 2      // *
* // Additional code : Atomus     // *
* // Graphisms     : Mister.A     // *
* // Music         : Tomchi       // *
* // Release date  : 16/05/2010   // *
* // Update date   : 01/04/2011   // *
* // Patch date    : 20/01/2012   // *
* // Version       : 2.0          // *
* // Name          : AC2011m1.PRG // *
**************************************
    OPT c+ ; Case sensitivity on.    *
    OPT d- ; Debug off.              *
    OPT o- ; All optimisations off.  *
    OPT w- ; Warnings off.           *
    OPT x- ; Extended debug off.     *
**************************************

	SECTION	TEXT

*********************************************
SYNCHRO_WAIT equ $900 ; Adress memory
SEEMYVBL equ 1 ; ALT key to press to see CPU
               ; 0 = TIMING & 1 = NOTHING
;--------------------------------------------
ECRAN_LOAD equ 1 ; Ecran Logo Inits
;--------------------------------------------
ECRAN_1    equ 1 ; Ecran Logo RGC Vague
ECRAN_2    equ 1 ; Ecran Etoiles 3D Présente
ECRAN_3    equ 1 ; Ecran Tubes Rasters
ECRAN_4    equ 1 ; Ecran Big Scrolling Raster
ECRAN_5    equ 1 ; Ecran Textes Fuzion
ECRAN_6    equ 1 ; Ecran Textes Cubes
ECRAN_7    equ 1 ; Ecran Cube 3d & Scroller
ECRAN_8    equ 1 ; Ecran Plasma
ECRAN_9    equ 1 ; Ecran de la carte de France
;--------------------------------------------
TEST_STE   equ 1 ; Test Si c'est un Atari STE
LANGUE_FR  equ 0 ; Langue francaise
LANGUE_EN  equ 1 ; Langue anglaise
*********************************************

Debut:          jmp	Begin
                dc.b	"YO ! CONTACT NOEXTRA-TEAM BY THE MAIL CONTACT@NOEXTRA-TEAM.COM. "
                dc.b	"WEBSITE OF NOEXTRA AT HTTP://WWW.NOEXTRA-TEAM.COM/. "
                dc.b	"NOEXTRA PRODUCTION (C) 2011 ON ATARI STE WITH 100% 68k ASSEMBLER CODE ! "
                even

Begin:          move.l  4(sp),a5                ; address to basepage
                move.l  $0c(a5),d0              ; length of text segment
                add.l   $14(a5),d0              ; length of data segment
                add.l   $1c(a5),d0              ; length of bss segment
                add.l   #$1000,d0               ; length of stackpointer
                add.l   #$100,d0                ; length of basepage
                move.l  a5,d1                   ; address to basepage
                add.l   d0,d1                   ; end of program
                and.l   #-2,d1                  ; make address even
                move.l  d1,sp                   ; new stackspace
                move.l  d0,-(sp)                ; mshrink()
                move.l  a5,-(sp)                ;
                move.w  d0,-(sp)                ;
                move.w  #$4a,-(sp)              ;
                trap    #1                      ;
                lea 	12(sp),sp                 ;

                clr.l	-(sp)
                move.w	#32,-(sp)
                trap	#1
                addq.l	#6,sp
                move.l	d0,Save_stack

 IFNE TEST_STE
                move.l	$5a0,a0   ; test STE
                cmp.l	#$0,a0
                beq	EXIT	; Pas de cookie_jar donc un vieux st.
                move.l	$14(a0),d0
                cmp.l	#$0,d0	; _MCH=0 alors c' est un ST-STf.
                beq	EXIT
 ENDC

                bsr	wait_for_drive

                bsr	clear_bss
                
                bsr	Init_screens
                
                bsr	Save_and_init_a_st

                movem.l no_palette,d0-d7    ; init palette
                movem.l d0-d7,$ffff8240.w

                lea	MUSIC_SNDH,a0                ; datas
                lea	adr_music,a1                 ; buffer destination
                jsr	d_lz77                       ; decompress data in a0 -> a1

                moveq	#1,d0                      ; Choice of the music (1 is default)
                jsr	adr_music+0                  ; Init SNDH music

                lea	Vbl_non_music(pc),a0
                move.l	a0,$70.w

                bsr     Wait_vbl

;--------------------------------------------------------------> ECRAN_LOAD
 IFNE ECRAN_LOAD

                bsr	DoBLiTTER__Copie_NOEXTRA_LOGO

                jsr	init_line_rout        ; dessine les lignes

                move.w	#28,nb_ligne
                move.l	#-1,flag_stop

                MOVE.W #$2700,SR                 ; it interdites
                move.b    #$21,$fffffa07.w
                move.b    #$21,$fffffa13.w
                clr.b     $fffffa09.w 
                clr.b     $fffffa15.w 
                clr.b     $fffffa1b.w
                MOVE.W #$2300,SR                 ; autorise interruptions

                movem.l Pal_logo_noex,d0-d7    ; init palette
                movem.l d0-d7,$ffff8240.w

                lea	Vbl_ligne(pc),a0
                move.l	a0,$70.w

                bsr     Wait_vbl

                bsr	clear_bss_datas

;-------------------------------------> INITS

                jsr	init_polygon_code

                jsr	InitRaster

                jsr create160tb		;	init rout cls 3d 1 plan

                move.l	#bufferZ,font_table
                bsr	make_fonts

;-------------------------------------< INITS

                bsr     Wait_vbl

                move.l	#0,flag_stop

                bsr	transfer

                clr.b     $fffffa1b.w

                bsr    fadeoff

                lea	Vbl_music(pc),a0
                move.l	a0,$70.w

                bsr	Clear_Zorro2_scr1
                bsr	Clear_Zorro2_scr2

                bsr     Wait_vbl

 ENDC
;--------------------------------------------------------------< ECRAN_LOAD

;--------------------------------------------------------------> ECRAN_1
 IFNE ECRAN_1

                movem.l Pal_logo_RGC,d0-d7    ; init palette
                movem.l d0-d7,$ffff8240.w

                lea	IMG_LOGO_RGC,a0	;	datas étoiles compressed
                lea	Buffer_LZ7,a1	;	buffer destination
                jsr	d_lz77	; decompress data in a0 -> a1

                move.l	#Buffer_LZ7,a0
                move.l	Zorro_scr1,a1
                lea	38*160(a1),a1
                move	#129*160,d3
munster:        moveq	#1,d1
                lea	(a0,d3.w),a3
                lea	(a1,d3.w),a4
move:           move	d1,d2
repeat:
                rept	40		;try 20 (needs fixing!)
                move.l	-(a3),-(a4)
                endr
                cmpa.l	a4,a1
                beq.s	vsync
                subq	#1,d2		; try 2 here...
                beq.s	nope
                lea	160(a3),a3	; try a -160 here & 19 above
                bra.s	repeat
nope:           addq	#3,d1		; speed (try 2..!!)
                bra.s	move
vsync:          bsr     Wait_vbl
                sub	#160,d3		; next line (zoom...try 320!)
                bne.s	munster
                move    #20,d7
                bsr     wait_more

                bsr	Flash_blanc

                MOVE.W #$2700,SR                 ; it interdites
                sf	$fffffa21.w
                sf	$fffffa1b.w
                move.l	#OverBorderHBL,$120.w
                bset	#0,$fffffa07.w	* Timer B on
                bset	#0,$fffffa13.w	* Timer B on
                MOVE.W #$2300,SR                 ; autorise interruptions

                lea     Vbl_border_bas(pc),a0      ; main VBL
                move.l  a0,$70.w

                move.l  #$00FF,SYNCHRO_WAIT

introloop:      bsr     Wait_vbl

                IFEQ	SEEMYVBL
                clr.b	$ffff8240.w
                ENDC

                bsr	sea_ripple

                IFEQ	SEEMYVBL
                cmp.b	#$38,$fffffc02.w	* ALT KEY ?
                bne.s	.altkey
                move.b	#7,$ffff8240.w
.altkey:	
                ENDC

                sub.l   #1,SYNCHRO_WAIT
                cmpi.l  #0,SYNCHRO_WAIT
                bne     introloop

                lea     Vbl_music(pc),a0      ; main VBL
                move.l  a0,$70.w

                clr.b     $fffffa1b.w

                bsr    fadeoff

                bsr	Clear_Zorro2_scr1
                bsr	Clear_Zorro2_scr2

 ENDC
;--------------------------------------------------------------< ECRAN_1

;--------------------------------------------------------------> ECRAN_2
 IFNE ECRAN_2

                bsr Random_gen
                bsr make160tab
                bsr crplotmasks
                bsr makeperstab

                movem.l Pal_logo_Presents,d0-d7    ; init palette
                movem.l d0-d7,$ffff8240.w

                move.l  #$03FF+$24,SYNCHRO_WAIT

starsloop:      bsr     Wait_vbl

                IFEQ	SEEMYVBL
                clr.b	$ffff8240.w
                ENDC

                bsr Clear_stars
                bsr DoBLiTTER__Copie_PRESENTS_LOGO
                bsr Matrix_make
                bsr Plot_stars

                IFEQ	SEEMYVBL
                cmp.b	#$38,$fffffc02.w	* ALT KEY ?
                bne.s	.altkey
                move.b	#7,$ffff8240.w
.altkey:	
                ENDC

                sub.l   #1,SYNCHRO_WAIT
                cmpi.l  #0,SYNCHRO_WAIT
                bne     starsloop

                bsr    fadeoff

                bsr     Wait_vbl

                bsr	Clear_Zorro2_scr1
                bsr	Clear_Zorro2_scr2

 ENDC
;--------------------------------------------------------------< ECRAN_2

;--------------------------------------------------------------> ECRAN_3
 IFNE ECRAN_3

                bsr	DoBLiTTER__Copie_BIG_AC_LOGO

                MOVE.W #$2700,SR                 ; it interdites
                clr.b     $fffffa07.w 
                clr.b     $fffffa09.w 
                clr.b     $fffffa1b.w 
                ori.b     #1,$fffffa07.w
                ori.b     #1,$fffffa13.w
                MOVE.W #$2300,SR                 ; autorise interruptions

                lea     Vbl_tube_raster_NOT(pc),a0      ; main VBL
                move.l  a0,$70.w

                LEA       BUFFER,A5
                ADDA.L    #$4E,A5 
                MOVE.L    A5,PTR_BUFFER

                lea     Pal_logo_AC,a2
                bsr     fadeon
                movem.l Pal_logo_AC,d0-d7    ; init palette
                movem.l d0-d7,$ffff8240.w

                move.l  #$020,SYNCHRO_WAIT

tune1loop:      bsr     Wait_vbl
                sub.l   #1,SYNCHRO_WAIT
                cmpi.l  #0,SYNCHRO_WAIT
                bne     tune1loop

                bsr     Wait_vbl

                lea     Vbl_tube_raster(pc),a0      ; main VBL
                move.l  a0,$70.w

                move.l  #$02FF-$50,SYNCHRO_WAIT

tune2loop:      bsr     Wait_vbl
                sub.l   #1,SYNCHRO_WAIT
                cmpi.l  #0,SYNCHRO_WAIT
                bne     tune2loop

                bsr    fadeoff

                movem.l no_palette,d0-d7    ; init palette
                movem.l d0-d7,$ffff8240.w

                lea     Vbl_music(pc),a0      ; main VBL
                move.l  a0,$70.w

                clr.b     $fffffa1b.w

                bsr     Wait_vbl

                bsr	Clear_Zorro2_scr1
                bsr	Clear_Zorro2_scr2

 ENDC
;--------------------------------------------------------------< ECRAN_3


;--------------------------------------------------------------> ECRAN_5
 IFNE ECRAN_5

                move.l  #$0170-8,SYNCHRO_WAIT

                bsr	Fuzion_text

                bsr    fadeoff

                lea     Vbl_music(pc),a0      ; main VBL
                move.l  a0,$70.w

                clr.b     $fffffa1b.w

                bsr     Wait_vbl

                bsr	Clear_Zorro2_scr1
                bsr	Clear_Zorro2_scr2

 ENDC
;--------------------------------------------------------------< ECRAN_5

;--------------------------------------------------------------> ECRAN_4
 IFNE ECRAN_4 ; AMIGA - AMSTRAD - ATARI

                lea	FONT,a0	;	datas étoiles compressed
                lea	Buffer_LZ7,a1	;	buffer destination
                jsr	d_lz77	; decompress data in a0 -> a1

                move.l  #$0060*4-20,SYNCHRO_WAIT

                bsr    Big_scrollerM

                bsr    fadeoff

                bsr	Clear_Zorro2_scr1
                bsr	Clear_Zorro2_scr2

                move.l	Zorro_scr1,d0
                move.b	d0,d1
                lsr.w	#8,d0
                move.b	d0,$ffff8203.w
                swap	d0
                move.b	d0,$ffff8201.w
                move.b	d1,$ffff820d.w

 ENDC
;--------------------------------------------------------------< ECRAN_4

;--------------------------------------------------------------> ECRAN_5
 IFNE ECRAN_5

                move.l  #440+8,SYNCHRO_WAIT

                bsr	Fuzion_text

                bsr    fadeoff

                lea     Vbl_music(pc),a0      ; main VBL
                move.l  a0,$70.w

                clr.b     $fffffa1b.w

                bsr     Wait_vbl

                bsr	Clear_Zorro2_scr1
                bsr	Clear_Zorro2_scr2

 ENDC
;--------------------------------------------------------------< ECRAN_5

;--------------------------------------------------------------> ECRAN_4
 IFNE ECRAN_4 ; ACORN - ARCHIMEDE

                move.l  #$0110,SYNCHRO_WAIT

                bsr    Big_scrollerF

                bsr    fadeoff

                bsr	Clear_Zorro2_scr1
                bsr	Clear_Zorro2_scr2

                move.l	Zorro_scr1,d0
                move.b	d0,d1
                lsr.w	#8,d0
                move.b	d0,$ffff8203.w
                swap	d0
                move.b	d0,$ffff8201.w
                move.b	d1,$ffff820d.w

 ENDC
;--------------------------------------------------------------< ECRAN_4

;--------------------------------------------------------------> ECRAN_5
 IFNE ECRAN_5

                move.l  #450,SYNCHRO_WAIT

                bsr	Fuzion_text

                bsr    fadeoff

                lea     Vbl_music(pc),a0      ; main VBL
                move.l  a0,$70.w

                clr.b     $fffffa1b.w

                bsr     Wait_vbl

                bsr	Clear_Zorro2_scr1
                bsr	Clear_Zorro2_scr2

 ENDC
;--------------------------------------------------------------< ECRAN_5

;--------------------------------------------------------------> ECRAN_4
 IFNE ECRAN_4 ; COMMODORE - MSX - OLDSCHOOL PLATEFORMS

                move.l  #$0210,SYNCHRO_WAIT

                bsr    Big_scrollerE

                bsr    fadeoff

                bsr	Clear_Zorro2_scr1
                bsr	Clear_Zorro2_scr2

                move.l	Zorro_scr1,d0
                move.b	d0,d1
                lsr.w	#8,d0
                move.b	d0,$ffff8203.w
                swap	d0
                move.b	d0,$ffff8201.w
                move.b	d1,$ffff820d.w

 ENDC
;--------------------------------------------------------------< ECRAN_4

;--------------------------------------------------------------> ECRAN_5
 IFNE ECRAN_5

                move.l  #440,SYNCHRO_WAIT

                bsr	Fuzion_text

                bsr    fadeoff

                lea     Vbl_music(pc),a0      ; main VBL
                move.l  a0,$70.w

                clr.b     $fffffa1b.w

                bsr     Wait_vbl

                bsr	Clear_Zorro2_scr1
                bsr	Clear_Zorro2_scr2

 ENDC
;--------------------------------------------------------------< ECRAN_5

;--------------------------------------------------------------> ECRAN_6
 IFNE ECRAN_6

                move.l	Zorro_scr1,a0
                bsr	DoBLiTTER__Copie_STAR_NES_LOGO
                move.l	Zorro_scr2,a0
                bsr	DoBLiTTER__Copie_STAR_NES_LOGO

                MOVE.W    #0,MINIFONTE_PTR

                LEA       MTEXTE1,A1
                movea.l   Zorro_scr1,A3
                lea       (160*23+6)(a3),a3
                BSR       PUT_MINITEXTE

                LEA       MTEXTE1,A1
                movea.l   Zorro_scr2,A3
                lea       (160*23+6)(a3),a3
                BSR       PUT_MINITEXTE

                jsr       init_pcarres

                move.l    #$0260,SYNCHRO_WAIT

                bsr       Texte_carre_etoile

                bsr    fadeoff

                bsr	Clear_Zorro2_scr1
                bsr	Clear_Zorro2_scr2

 ENDC
;--------------------------------------------------------------< ECRAN_6

;--------------------------------------------------------------> ECRAN_5
 IFNE ECRAN_5

                move.l  #450,SYNCHRO_WAIT

                bsr	Fuzion_text

                bsr    fadeoff

                lea     Vbl_music(pc),a0      ; main VBL
                move.l  a0,$70.w

                clr.b     $fffffa1b.w

                bsr     Wait_vbl

                bsr	Clear_Zorro2_scr1
                bsr	Clear_Zorro2_scr2

 ENDC
;--------------------------------------------------------------< ECRAN_5

;--------------------------------------------------------------> ECRAN_7
 IFNE ECRAN_7

                move.l  #900,SYNCHRO_WAIT

                bsr	Rotate_3d

                bsr    fadeoff

                bsr	Clear_Zorro2_scr1
                bsr	Clear_Zorro2_scr2

 ENDC
;--------------------------------------------------------------< ECRAN_7

;--------------------------------------------------------------> ECRAN_6
 IFNE ECRAN_6

                move.l	Zorro_scr1,a0
                bsr	DoBLiTTER__Copie_STAR_NES_LOGO
                move.l	Zorro_scr2,a0
                bsr	DoBLiTTER__Copie_STAR_NES_LOGO

                MOVE.W    #0,MINIFONTE_PTR

                LEA       MTEXTE2,A1
                movea.l   Zorro_scr1,A3
                lea       (160*23+6)(a3),a3
                BSR       PUT_MINITEXTE

                LEA       MTEXTE2,A1
                movea.l   Zorro_scr2,A3
                lea       (160*23+6)(a3),a3
                BSR       PUT_MINITEXTE

                move.l    #$0260,SYNCHRO_WAIT

                bsr       Texte_carre_etoile

                bsr    fadeoff

                bsr	Clear_Zorro2_scr1
                bsr	Clear_Zorro2_scr2

 ENDC
;--------------------------------------------------------------< ECRAN_6

;--------------------------------------------------------------> ECRAN_8
 IFNE ECRAN_8

                move.l  #$0300,SYNCHRO_WAIT

                bsr	Plasma

                bsr    fadeoff

                bsr	Clear_Zorro2_scr1
                bsr	Clear_Zorro2_scr2

 ENDC
;--------------------------------------------------------------< ECRAN_8

;--------------------------------------------------------------> ECRAN_5
 IFNE ECRAN_5

                move.l  #(450*4)-150,SYNCHRO_WAIT

                bsr	Fuzion_text

                move.l	Zorro_scr1,d0
                move.b	d0,d1
                lsr.w	#8,d0
                move.b	d0,$ffff8203.w
                swap	d0
                move.b	d0,$ffff8201.w
                move.b	d1,$ffff820d.w

                lea     wave,a2
mainloop:       bsr     Wait_vbl
                moveq   #0,d1
                move.l  Zorro_scr1,d0
                sub.w   scrn_offset,d0
                move.b  d0,d1
                lsr.l   #8,d0
                move.b  d0,$fffff8203.w
                lsr.w   #8,d0
                move.b  d0,$fffff8201.w
                move.b  d1,$fffff820d.w
                move	  (a2)+,d3
                cmpi	  #-1,(a2)
                beq	    finish_up
                muls    #160,d3
                move.w  d3,scrn_offset
                bra.s   mainloop
finish_up:
                move    #20,d7
                bsr     wait_more

                bsr    fadeoff

                lea     Vbl_music(pc),a0      ; main VBL
                move.l  a0,$70.w

                clr.b     $fffffa1b.w

                bsr     Wait_vbl

                bsr	Clear_Zorro2_scr1
                bsr	Clear_Zorro2_scr2

 ENDC
;--------------------------------------------------------------< ECRAN_5

;--------------------------------------------------------------> ECRAN_9
 IFNE ECRAN_9

                move.l	Zorro_scr1,d0
                move.b	d0,d1
                lsr.w	#8,d0
                move.b	d0,$ffff8203.w
                swap	d0
                move.b	d0,$ffff8201.w
                move.b	d1,$ffff820d.w

                move.l  #$0260+100,SYNCHRO_WAIT

                bsr	Display_carte_de_france

                bsr    fadeoff

                bsr	Clear_Zorro2_scr1
                bsr	Clear_Zorro2_scr2

 ENDC
;--------------------------------------------------------------< ECRAN_9

                lea	Vbl_music(pc),a0
                move.l	a0,$70.w

                bsr     Wait_vbl

                bsr    fadeoff

******************************************************************************

                bsr	Restore_st

 IFNE TEST_STE

EXIT:

 ENDC

                move.l	Save_stack,-(sp)
                move.w	#32,-(sp)
                trap	#1
                addq.l	#6,sp

                clr.w	-(sp)
                trap	#1

                * FIN *

************************************************
*                                              *
*               Sub Routines                   *
*                                              *
************************************************

Vbl_non_music:  st	Vsync
                rte

Vbl_music:      movem.l	d0-d7/a0-a6,-(a7)
                st	Vsync
                jsr 	(adr_music+8)			; call music
                movem.l	(a7)+,d0-d7/a0-a6
                rte

Wait_vbl:       move.l	a0,-(a7)
                lea	Vsync,a0
                sf	(a0)
.loop:          tst.b	(a0)
                beq.s	.loop
                move.l	(a7)+,a0
                rts

Vbl_ligne:      movem.l	d0-d7/a0-a6,-(a7)
                st	Vsync
                cmp.l	#0,flag_stop
                beq.s	.flag_ok
                cmp.w	#291,nb_ligne
                bgt.s	.flag_ok
                movea.l Zorro_scr1,a0
                lea 4(a0),a0
                move.w	nb_ligne,d0
                move.w	#133,d1
                move.w	nb_ligne,d2
                move.w	#145,d3
                jsr LINE
                add.w	#1,nb_ligne
.flag_ok:       movem.l	(a7)+,d0-d7/a0-a6
                clr.b     $fffffa1b.w 
                move.b    #74,$fffffa21.w
                move.l    #Hbl_ligne,$120.w 
                move.b    #8,$fffffa1b.w
                rte

nb_ligne:       dc.l	28
flag_stop:      dc.l	-1

Hbl_ligne:      clr.b     $fffffa1b.l
                move      #$2700,SR
                movem.l   a0-a1/d0-d1,-(a7)
                moveq     #$e,d0
                move.w    #9,d1
.loop:          dbf       d1,.loop
.sync:          move.b    $ffff8209.w,d1
                beq.s     .sync 
                sub.b     d1,d0 
                rol.w     d0,d0 
                lea       $ffff8242.w,a1
                lea       PAL_RAST,a0
                move.w    #9,d0 
.tempo:         dbf       d0,.tempo
                move.w    #6*5,d0 
.rast:
 rept	40	
                move.w    (a0)+,(a1)
 endr
                dcb.w	7+3,$4e71		; 7 nops
 rept	40	
                move.w    (a0)+,(a1)
 endr
                dcb.w	7+3,$4e71		; 7 nops

                dbf       d0,.rast
                movem.l	(a7)+,a0-a1/d0-d1
                move      #$2300,SR
                bclr      #0,$fffffa0f.w
                rte 

Fuzion_text:    bsr	DoBLiTTER__Copie_SMALL_AC_LOGO

                lea     Pal_plogo_RGC,a2
                bsr     fadeon
                movem.l Pal_plogo_RGC,d0-d7    ; init palette
                movem.l d0-d7,$ffff8240.w

                sf	$fffffa21.w
                sf	$fffffa1b.w
                move.l	#Over_rout,$120.w
                bset	#0,$fffffa07.w	* Timer B on
                bset	#0,$fffffa13.w	* Timer B on

                lea     Vbl_bottom_overscan(pc),a0      ; main VBL
                move.l  a0,$70.w

.texteloop:     bsr     Wait_vbl

                IFEQ	SEEMYVBL
                clr.b	$ffff8240.w
                ENDC

                bsr	clear_sprayer
                bsr	spray_text
                bsr	calc_new_spray

                IFEQ	SEEMYVBL
                cmp.b	#$38,$fffffc02.w	* ALT KEY ?
                bne.s	.altkey
                move.b	#7,$ffff8240.w
.altkey:	
                ENDC

                sub.l   #1,SYNCHRO_WAIT
                cmpi.l  #0,SYNCHRO_WAIT
                bne     .texteloop

                rts

Texte_carre_etoile:
                movem.l Pal_bubble,d0-d7    ; init palette
                movem.l d0-d7,$ffff8240.w

                MOVE.W #$2700,SR                 ; it interdites
                sf	$fffffa21.w
                sf	$fffffa1b.w
                move.l	#Hbl_raster_line,$120.w
                bset	#0,$fffffa07.w	* Timer B on
                bset	#0,$fffffa13.w	* Timer B on
                MOVE.W #$2300,SR                 ; autorise interruptions

                lea     Vbl_raster_line(pc),a0      ; main VBL
                move.l  a0,$70.w

.carreloop:     bsr     Wait_vbl

                IFEQ	SEEMYVBL
                clr.b	$ffff8240.w
                ENDC

                jsr	pcarres
                jsr	cls_pcarres
                bsr	DoBLiTTER__Copie_BUBBLE_square

                MOVE.L    Zorro_scr1,D0
                MOVE.L    Zorro_scr2,Zorro_scr1 
                MOVE.L    D0,Zorro_scr2
                LSR.W     #8,D0 
                MOVE.L    D0,$FFFF8200.W

                IFEQ	SEEMYVBL
                cmp.b	#$38,$fffffc02.w	* ALT KEY ?
                bne.s	.altkey
                move.b	#7,$ffff8240.w
.altkey:	
                ENDC

                sub.l   #1,SYNCHRO_WAIT
                cmpi.l  #0,SYNCHRO_WAIT
                bne     .carreloop

                move.l	Zorro_scr1,d0
                move.b	d0,d1
                lsr.w	#8,d0
                move.b	d0,$ffff8203.w
                swap	d0
                move.b	d0,$ffff8201.w
                move.b	d1,$ffff820d.w

                lea     Vbl_music(pc),a0      ; main VBL
                move.l  a0,$70.w

                clr.b     $fffffa1b.w

                bsr     Wait_vbl
                rts

Big_scrollerF:  movem.l no_palette,d0-d7    ; init palette
                movem.l d0-d7,$ffff8240.w

                lea	adr_sprite_F,a0
                bsr	shift_ball

* Rustine pour cacher l'effacement des sprites
 rept 2
                eor.w	#(MAX_BALLS*2),ball_off
                bsr	clear_sprites
                lea	adr_sprite_F,a3
                bsr	show_sprites
                bsr	SCROLLY
                move.l    Zorro_scr1,d0
                move.l    Zorro_scr2,Zorro_scr1 
                move.l    d0,Zorro_scr2
                lsr.w     #8,d0 
                move.l    d0,$ffff8200.w
 endr

                movem.l Pal_SPRITE_F,d0-d7    ; init palette
                movem.l d0-d7,$ffff8240.w

                MOVE.W #$2700,SR                 ; it interdites
                MOVE.B    #1,$FFFA07.L
                MOVE.B    #0,$FFFA09.L
                BSET      #0,$FFFA13.L
                MOVE.B    #8,$FFFA1B.L
                MOVE.B    #1,$FFFA21.L
                move.l	  #Hbl_raster_layer,$120.w
                MOVE.W #$2300,SR                 ; autorise interruptions

                lea     Vbl_layer_raster(pc),a0      ; main VBL
                move.l  a0,$70.w

.layerloop:     bsr     Wait_vbl

                IFEQ	SEEMYVBL
                clr.b	$ffff8240.w
                ENDC

                eor.w	#(MAX_BALLS*2),ball_off
                bsr	clear_sprites
                lea	adr_sprite_F,a3
                bsr	show_sprites
                bsr	SCROLLY

                IFEQ	SEEMYVBL
                cmp.b	#$38,$fffffc02.w	* ALT KEY ?
                bne.s	.altkey
                move.b	#7,$ffff8240.w
.altkey:	
                ENDC

                move.l    Zorro_scr1,d0
                move.l    Zorro_scr2,Zorro_scr1 
                move.l    d0,Zorro_scr2
                lsr.w     #8,d0 
                move.l    d0,$ffff8200.w

                sub.l   #1,SYNCHRO_WAIT
                cmpi.l  #0,SYNCHRO_WAIT
                bne     .layerloop

                lea     Vbl_music(pc),a0      ; main VBL
                move.l  a0,$70.w

                clr.b     $fffffa1b.w

                bsr     Wait_vbl
                rts

Big_scrollerE:  movem.l no_palette,d0-d7    ; init palette
                movem.l d0-d7,$ffff8240.w

                lea	adr_sprite_E,a0
                bsr	shift_ball

* Rustine pour cacher l'effacement des sprites
 rept 2
                eor.w	#(MAX_BALLS*2),ball_off
                bsr	clear_sprites
                lea	adr_sprite_E,a3
                bsr	show_sprites
                bsr	SCROLLY
                move.l    Zorro_scr1,d0
                move.l    Zorro_scr2,Zorro_scr1 
                move.l    d0,Zorro_scr2
                lsr.w     #8,d0 
                move.l    d0,$ffff8200.w
 endr

                movem.l Pal_SPRITE_E,d0-d7    ; init palette
                movem.l d0-d7,$ffff8240.w

                MOVE.W #$2700,SR                 ; it interdites
                MOVE.B    #1,$FFFA07.L
                MOVE.B    #0,$FFFA09.L
                BSET      #0,$FFFA13.L
                MOVE.B    #8,$FFFA1B.L
                MOVE.B    #1,$FFFA21.L
                move.l	  #Hbl_raster_layer,$120.w
                MOVE.W #$2300,SR                 ; autorise interruptions

                lea     Vbl_layer_raster(pc),a0      ; main VBL
                move.l  a0,$70.w

.layerloop:     bsr     Wait_vbl

                IFEQ	SEEMYVBL
                clr.b	$ffff8240.w
                ENDC

                eor.w	#(MAX_BALLS*2),ball_off
                bsr	clear_sprites
                lea	adr_sprite_E,a3
                bsr	show_sprites
                bsr	SCROLLY

                IFEQ	SEEMYVBL
                cmp.b	#$38,$fffffc02.w	* ALT KEY ?
                bne.s	.altkey
                move.b	#7,$ffff8240.w
.altkey:	
                ENDC

                move.l    Zorro_scr1,d0
                move.l    Zorro_scr2,Zorro_scr1 
                move.l    d0,Zorro_scr2
                lsr.w     #8,d0 
                move.l    d0,$ffff8200.w

                sub.l   #1,SYNCHRO_WAIT
                cmpi.l  #0,SYNCHRO_WAIT
                bne     .layerloop

                lea     Vbl_music(pc),a0      ; main VBL
                move.l  a0,$70.w

                clr.b     $fffffa1b.w

                bsr     Wait_vbl
                rts

Big_scrollerM:  movem.l no_palette,d0-d7    ; init palette
                movem.l d0-d7,$ffff8240.w

                lea	adr_sprite_M,a0
                bsr	shift_ball

* Rustine pour cacher l'effacement des sprites
 rept 2
                eor.w	#(MAX_BALLS*2),ball_off
                bsr	clear_sprites
                lea	adr_sprite_M,a3
                bsr	show_sprites
                bsr	SCROLLY
                move.l    Zorro_scr1,d0
                move.l    Zorro_scr2,Zorro_scr1 
                move.l    d0,Zorro_scr2
                lsr.w     #8,d0 
                move.l    d0,$ffff8200.w
 endr

                movem.l Pal_SPRITE_M,d0-d7    ; init palette
                movem.l d0-d7,$ffff8240.w

                MOVE.W #$2700,SR                 ; it interdites
                MOVE.B    #1,$FFFA07.L
                MOVE.B    #0,$FFFA09.L
                BSET      #0,$FFFA13.L
                MOVE.B    #8,$FFFA1B.L
                MOVE.B    #1,$FFFA21.L
                move.l	  #Hbl_raster_layer,$120.w
                MOVE.W #$2300,SR                 ; autorise interruptions

                lea     Vbl_layer_raster(pc),a0      ; main VBL
                move.l  a0,$70.w

.layerloop:     bsr     Wait_vbl

                IFEQ	SEEMYVBL
                clr.b	$ffff8240.w
                ENDC

                eor.w	#(MAX_BALLS*2),ball_off
                bsr	clear_sprites
                lea	adr_sprite_M,a3
                bsr	show_sprites
                bsr	SCROLLY

                IFEQ	SEEMYVBL
                cmp.b	#$38,$fffffc02.w	* ALT KEY ?
                bne.s	.altkey
                move.b	#7,$ffff8240.w
.altkey:	
                ENDC

                move.l    Zorro_scr1,d0
                move.l    Zorro_scr2,Zorro_scr1 
                move.l    d0,Zorro_scr2
                lsr.w     #8,d0 
                move.l    d0,$ffff8200.w

                sub.l   #1,SYNCHRO_WAIT
                cmpi.l  #0,SYNCHRO_WAIT
                bne     .layerloop

                lea     Vbl_music(pc),a0      ; main VBL
                move.l  a0,$70.w

                clr.b     $fffffa1b.w

                bsr     Wait_vbl
                rts

Rotate_3d:      jsr	put_big_square

                move.l	Zorro_scr1,a0
                bsr	DoBLiTTER__Copie_SONIC_IMG
                move.l	Zorro_scr2,a0
                bsr	DoBLiTTER__Copie_SONIC_IMG

                bsr	Clear_halftone

                MOVE.W #$2700,SR                 ; it interdites
                sf	$fffffa21.w
                sf	$fffffa1b.w
                move.l	#OverDose3dHBL,$120.w
                bset	#0,$fffffa07.w	* Timer B on
                bset	#0,$fffffa13.w	* Timer B on
                MOVE.W #$2300,SR                 ; autorise interruptions

                movem.l Pal_ice,d0-d7    ; init palette
                movem.l d0-d7,$ffff8240.w

                lea     Vbl_cube_raster(pc),a0      ; main VBL
                move.l  a0,$70.w

.cubeloop:      bsr     Wait_vbl

                IFEQ	SEEMYVBL
                clr.b	$ffff8240.w
                ENDC

                jsr	cls_square	; efface

                move.l	Zorro_scr1,d0
                move.b	d0,d1
                lsr.w	#8,d0
                move.b	d0,$ffff8203.w
                swap	d0
                move.b	d0,$ffff8201.w
                move.b	d1,$ffff820d.w

                jsr	calcul_3d

                jsr	Do_bufscroll

                MOVE.L    Zorro_scr1,D0
                MOVE.L    Zorro_scr2,Zorro_scr1 
                MOVE.L    D0,Zorro_scr2

                IFEQ	SEEMYVBL
                cmp.b	#$38,$fffffc02.w	* ALT KEY ?
                bne.s	.altkey
                move.b	#7,$ffff8240.w
.altkey:	
                ENDC

                sub.l   #1,SYNCHRO_WAIT
                cmpi.l  #0,SYNCHRO_WAIT
                bne     .cubeloop

                lea     Vbl_music(pc),a0      ; main VBL
                move.l  a0,$70.w

                clr.b     $fffffa1b.w

                bsr     Wait_vbl
                rts

Display_carte_de_france:
                move.l	Zorro_scr1,a0
                bsr	DoBLiTTER__Copie_BOARD_IMG
                move.l	Zorro_scr2,a0
                bsr	DoBLiTTER__Copie_BOARD_IMG

                bsr	Clear_halftone

                lea     Pal_board,a2
                bsr     fadeon
                movem.l Pal_board,d0-d7    ; init palette
                movem.l d0-d7,$ffff8240.w

.maploop:       bsr     Wait_vbl

                bsr clear1plscreen
                bsr Show_obj

                move.l	Zorro_scr1,a0
                bsr	DoBLiTTER__Copie_TEXTE
                move.l	Zorro_scr2,a0
                bsr	DoBLiTTER__Copie_TEXTE

                move.l    Zorro_scr1,d0
                move.l    Zorro_scr2,Zorro_scr1 
                move.l    d0,Zorro_scr2
                lsr.w     #8,d0 
                move.l    d0,$ffff8200.w

                sub.l   #1,SYNCHRO_WAIT
                cmpi.l  #0,SYNCHRO_WAIT
                bne.s   .maploop

                bsr     Wait_vbl
                rts

Plasma:         MOVE.W    #-1,MINIFONTE_PTR
                LEA       MTEXTE3,A1
                movea.l   Zorro_scr1,A3
                lea       (160*0+4+8)(a3),a3
                BSR       PUT_MINITEXTE

                bsr       DoBLiTTER__Copie_FONTE

                jsr       put_squares

                movem.l Pal_plasma,d0-d7    ; init palette
                movem.l d0-d7,$ffff8240.w

                bsr     Wait_vbl

                lea     Vbl_plasma(pc),a0      ; main VBL
                move.l  a0,$70.w

.plasmaloop:    jsr	Raster

                sub.l   #1,SYNCHRO_WAIT
                cmpi.l  #0,SYNCHRO_WAIT
                bne.s   .plasmaloop

                lea     Vbl_music(pc),a0      ; main VBL
                move.l  a0,$70.w

                bsr     Wait_vbl
                rts

Vbl_plasma:     andi.w    #$f1ff,(a7) 
                jsr 	(adr_music+8)			; call music
                rte

Vbl_cube_raster:st	Vsync

                move.l	#$1010532,$ffff8240.w
                move.l	#$8000003,$ffff824e.w

                move.l	#OverDose3dHBL,$120.w
                move.b	#199,$fffffa21.w
                move.b	#8,$fffffa1b.w

                jsr 	(adr_music+8)			; call music

                rte

OverDose3dHBL:  clr.b	$fffffa1b.w		;DI all other interrupts
                
                move.l	#$2020fff,$ffff8240.w
                move.l	#$fff0fff,$ffff824e.w
                
                dcb.w	60,$4E71		; 60 nops
.loop:          tst.b	$ffff8209.w		;check low video pos
                bne.s	.loop
                dcb.w	6,$4E71				; 6 nops
                clr.b	$ffff820a.w		;60Hz
                dcb.w	16,$4E71		; 16 nops
                MOVE.B	#2,$FFFF820A.W

                move.l	a0,-(a7)
                lea	colours(pc),a0
                rept	26+1
                move.w	(a0)+,$ffff8240.w
                dcb.w	124,$4e71
                endr
                move.l	(a7)+,a0

                BCLR      #0,$FFFFFA0F.W

                RTE

colours:        dcb.w	4,$313
                dc.w	$fff
                dcb.w	20,$535
                dc.w	$fff
                dc.w	$313
                even

Vbl_border_bas: movem.l	d0-d7/a0-a6,-(a7)
                st	Vsync

                lea	Pal_logo_RGC,a0
                lea	$ffff8240.w,a1
                movem.l	(a0),d0-d7
                movem.l	d0-d7,(a1)

                move.l	#OverBorderHBL,$120.w
                move.b	#199-29,$fffffa21.w
                move.b	#8,$fffffa1b.w

                jsr 	(adr_music+8)			; call music

                movem.l	(a7)+,d0-d7/a0-a6
                rte

OverBorderHBL:  clr.b     $fffffa1b.w 
                move.l	a0,-(a7)
                move.l	a1,-(a7)
                lea   Pal_logo_RGC_fade,a0 
                movea.l   #$ff8240,a1 
                move.l    (a0)+,(a1)+ 
                move.l    (a0)+,(a1)+ 
                move.l    (a0)+,(a1)+ 
                move.l    (a0)+,(a1)+
                move.l    (a0)+,(a1)+ 
                move.l    (a0)+,(a1)+ 
                move.l    (a0)+,(a1)+ 
                move.l    (a0)+,(a1)+ 
                move.l	(a7)+,a1
                move.l	(a7)+,a0
                rte

Vbl_tube_raster_NOT:
                MOVE      SR,-(A7)
                MOVE      #$2700,SR 
                LEA       $FFFF8209.W,A0
                LEA       $FFFF8240.W,A3
                MOVE.W    #$0110,(A3) 
                MOVEQ     #0,D0 
                MOVEQ     #1,D1 
                MOVEQ     #2,D2 
                MOVEQ     #$10,D3 
                MOVEQ     #0,D4 
                MOVE.W    #$593,D5
.tempo:         DBF       D5,.tempo
                MOVE.B    #0,$FFFF820A.W
                dcb.w	7,$4E71		; 7 nops
                MOVE.B    #2,$FFFF820A.W
.tempo2:        MOVE.B    (A0),D4 
                BEQ.S     .tempo2 
                SUB.B     D4,D3 
                LSL.W     D3,D4 
                dcb.w	92,$4E71		; 92 nops
                MOVEA.L   PTR_BUFFER,A5
                MOVE.W    #$EC,D3 
                LEA       $FF8250.L,A6
.loop:          NOP 
 rept 40
                MOVE.W    (A5)+,(A6)
 endr
                ADDA.L    #$50,A5 
                DBF       D3,.loop 
*--> ligne de fin      
                MOVE.B    #$FF,$FFFF8240.W 
                dcb.w	110,$4E71		; 110 nops
*<-- ligne de fin
                MOVE.B    #0,$FFFF8240.W 
                MOVE.W    #0,(A6) 
                MOVEA.L   PTR_BUFFER,A5
                SUBI.W    #1,COMPTEUR
                BPL.S     .buf_next 
                MOVE.W    #$28,COMPTEUR
                LEA       BUFFER,A5
                ADDA.L    #$50,A5 
.buf_next:      SUBA.L    #2,A5 
                MOVE.L    A5,PTR_BUFFER
                LEA       COURBE,A6
                MOVE.W    FIN_COURBE,D7
                MOVE.B    0(A6,D7.W),D7 
                ADDI.W    #1,FIN_COURBE
                CMPI.W    #$2EE,FIN_COURBE 
                BNE       .cur_next 
                MOVE.W    #$32,FIN_COURBE
.cur_next:      LEA       COULEURS,A6
                ANDI.W    #$FF,D7 
                ADDA.W    D7,A6 
i set 0
 rept 200
                MOVE.W    (A6),i(A5)
                MOVE.W    (A6)+,i+82(A5)
i set i+160
 endr
                ADDA.L    #$7D00,A5 
i set 0
 rept 70
                MOVE.W    (A6),i(A5)
                MOVE.W    (A6)+,i+82(A5)
i set i+160
 endr
                MOVE      (A7)+,SR

                st	Vsync
                movem.l	d0-d7/a0-a6,-(a7)
                jsr 	(adr_music+8)			; call music
                movem.l	(a7)+,d0-d7/a0-a6
                rte

Vbl_tube_raster:
                MOVE      SR,-(A7)
                MOVE      #$2700,SR 
                LEA       $FFFF8209.W,A0
                LEA       $FFFF8240.W,A3
                MOVE.W    #$0010,(A3) 
                MOVEQ     #0,D0 
                MOVEQ     #1,D1 
                MOVEQ     #2,D2 
                MOVEQ     #$10,D3 
                MOVEQ     #0,D4 
                MOVE.W    #$593,D5
.tempo:         DBF       D5,.tempo
                MOVE.B    #0,$FFFF820A.W
                dcb.w	7,$4E71		; 7 nops
                MOVE.B    #2,$FFFF820A.W
.tempo2:        MOVE.B    (A0),D4 
                BEQ.S     .tempo2 
                SUB.B     D4,D3 
                LSL.W     D3,D4 
                dcb.w	92,$4E71		; 92 nops
                MOVEA.L   PTR_BUFFER,A5
                MOVE.W    #$EC,D3 
                LEA       $FF8240.L,A6
.loop:          NOP 
 rept 40
                MOVE.W    (A5)+,(A6)
 endr
                ADDA.L    #$50,A5 
                DBF       D3,.loop
*--> ligne de fin      
                MOVE.B    #$FF,$FFFF8240.W 
                dcb.w	110,$4E71		; 110 nops
*<-- ligne de fin
                MOVE.W    #0,(A6) 
                MOVEA.L   PTR_BUFFER,A5
                SUBI.W    #1,COMPTEUR
                BPL.S     .buf_next 
                MOVE.W    #$28,COMPTEUR
                LEA       BUFFER,A5
                ADDA.L    #$50,A5 
.buf_next:      SUBA.L    #2,A5 
                MOVE.L    A5,PTR_BUFFER
                LEA       COURBE,A6
                MOVE.W    FIN_COURBE,D7
                MOVE.B    0(A6,D7.W),D7 
                ADDI.W    #1,FIN_COURBE
                CMPI.W    #$2EE,FIN_COURBE 
                BNE       .cur_next 
                MOVE.W    #$32,FIN_COURBE
.cur_next:      LEA       COULEURS,A6
                ANDI.W    #$FF,D7 
                ADDA.W    D7,A6 
i set 0
 rept 200
                MOVE.W    (A6),i(A5)
                MOVE.W    (A6)+,i+82(A5)
i set i+160
 endr
                ADDA.L    #$7D00,A5 
i set 0
 rept 70
                MOVE.W    (A6),i(A5)
                MOVE.W    (A6)+,i+82(A5)
i set i+160
 endr
                MOVE      (A7)+,SR

                st	Vsync
                movem.l	d0-d7/a0-a6,-(a7)
                jsr 	(adr_music+8)			; call music
                movem.l	(a7)+,d0-d7/a0-a6
                rte

Vbl_bottom_overscan:
                movem.l	d0-d7/a0-a6,-(a7)

                st	Vsync

                move.l	#Over_rout,$120.w
                move.b	#199,$fffffa21.w
                move.b	#8,$fffffa1b.w

                jsr 	(adr_music+8)			; call music

                movem.l	(a7)+,d0-d7/a0-a6
                rte

Over_rout:      sf	$fffffa21.w	* Stop Timer B
                sf	$fffffa1b.w

                dcb.w	95,$4E71		; 95 nops
                sf	$ffff820a.w	* Modif Frequency 60 Hz !
                dcb.w	28,$4E71		; 28 nops
                move.b	#$2,$ffff820a.w * 50 Hz !
                rte

Vbl_layer_raster:movem.l	d0-d7/a0-a6,-(a7)

                st	Vsync

                MOVE.L	#PTR_PALETTE+2,POINTER     Initialise pointer in colour table
                bsr	PUT_RASTER

                jsr 	(adr_music+8)			; call music

                movem.l	(a7)+,d0-d7/a0-a6
                rte

PTR: dc.l $0

Hbl_raster_layer:MOVE.L A0,-(A7)               Save A0
                MOVE.L POINTER,A0             A0=address of next colour for colour 0
                MOVE.W (A0)+,$FFFF8244.W      New colour 0
                MOVE.L A0,POINTER             Save address of next colour 0
                MOVE.L (A7)+,A0               Restore A0
                BCLR #0,$FFFFFA0F.W   
                rte

POINTER: DS.L 1
	
PUT_RASTER:     MOVEA.L   TAB1,A0
                MOVEA.L   TAB2,A1
                MOVEA.L   TAB3,A2
                MOVEA.L   #ADR_PALETTE,A3 
                MOVE.L    #$C7,D0 
.loop:          MOVE.W    (A0)+,D1
                ADD.W     (A1)+,D1
                ADD.W     (A2)+,D1
                MOVE.W    D1,(A3)+
                DBF       D0,.loop
                BSR       CYCLING 
                RTS 

CYCLING:        MOVE.L    TAB1,D0
                ADDQ.L    #2,D0 
                CMP.L     #SUITE1,D0 
                BNE.S     .NX1 
                MOVE.L    #PTR_TAB1,D0 
.NX1:           MOVE.L    D0,TAB1
                MOVE.L    TAB2,D0
                ADDQ.L    #4,D0 
                CMP.L     #SUITE2,D0 
                BNE.S     .NX2 
                MOVE.L    #PTR_TAB2,D0 
.NX2:           MOVE.L    D0,TAB2
                MOVE.L    TAB3,D0
                SUBQ.L    #2,D0 
                CMP.L     #SUITE3,D0 
                BNE.S     .NX3 
                MOVE.L    #PTR_TAB3,D0 
.NX3:           MOVE.L    D0,TAB3
                RTS 

Vbl_raster_line:movem.l	d0-d7/a0-a6,-(a7)

                st	Vsync

                CLR.B     $FFFFFA1B.W 
                MOVE.B    #1,$FFFFFA21.W
                MOVE.L    #Hbl_raster_line,$120.W 
                MOVE.B    #8,$FFFFFA1B.W
                ADDQ.W    #2,PTR1_LINE_TOP
                CMPI.W    #$54,PTR1_LINE_TOP
                BLE.S     .next_l1 
                CLR.W     PTR1_LINE_TOP 
.next_l1:       SUBQ.W    #2,PTR2_LINE_TOP
                TST.W     PTR2_LINE_TOP 
                BGE.S     .next_l2 
                MOVE.W    #$54,PTR2_LINE_TOP
.next_l2:       movem.l	(a7)+,d0-d7/a0-a6
                rte

Hbl_raster_line:
                CLR.B     $FFFFFA1B.W 
                MOVE.L    A0,-(A7)
                LEA       COLOR_LINE_TOP(pc),A0
                ADDA.W    PTR1_LINE_TOP(pc),A0
 rept 28
                MOVE.W    (A0)+,$FFFF8240.W 
 endr
                MOVE.L    (A7)+,A0
                MOVE.W    #$0114-2,$FFFF8240.W 
                MOVE.L    #HBL_ENTRE,$120.W 
                MOVE.B    #50,$FFFFFA21.W
                MOVE.B    #8,$FFFFFA1B.W
                RTE 

HBL_ENTRE:      CLR.B     $FFFFFA1B.W 
                MOVE.L    #HBL_END,$120.W
                MOVE.B    #144,$FFFFFA21.W
                MOVE.B    #8,$FFFFFA1B.W
                RTE 

HBL_END:        MOVEM.L   D0/A0/A1,-(A7)
                LEA       COLOR_LINE_TOP(pc),A0
                ADDA.W    PTR2_LINE_TOP(pc),A0
                LEA       $FFFF8240.W,A1
                MOVE.B    $FFFFFA21.W,D0
.loop:          CMP.B     $FFFFFA21.W,D0
                BEQ.S     .loop 
                CLR.B     $FFFFFA1B.W
 rept 42
                MOVE.W    (A0)+,(A1)
 endr
                MOVE.W    #$0113,(A1) 
                MOVEM.L   (A7)+,D0/A0/A1
                
                jsr 	(adr_music+8)			; call music
                
                RTE

CFOND equ	$0113
PTR1_LINE_TOP:  dc.w	0
PTR2_LINE_TOP:  dc.w	0
COLOR_LINE_TOP: dc.w	CFOND,CFOND,CFOND,$0003
                dc.w	$0004,$0005,$0006,$0007
                dc.w	$0107,$0207,$0307,$0407
                dc.w	$0507,$0607,$0707,$0706
                dc.w	$0705,$0704,$0703,$0702
                dc.w	$0701,$0700,$0710,$0720
                dc.w	$0730,$0740,$0750,$0760
                dc.w	$0770,$0670,$0570,$0470
                dc.w	$0370,$0270,$0170,$0070
                dc.w	$0060,$0050,$0040,$0030
                dc.w	$0020,$0010,$0000,$0001
                dc.w	$0003,$0004,$0005,$0006
                dc.w	$0007,$0107,$0207,$0307
                dc.w	$0407,$0507,$0607,$0707
                dc.w	$0706,$0705,$0704,$0703
                dc.w	$0702,$0701,$0700,$0710
                dc.w	$0720,$0730,$0740,$0750
                dc.w	$0760,$0770,$0670,$0570
                dc.w	$0470,$0370,$0270,$0170
                dc.w	$0070,$0060,$0050,$0040
                dc.w	$0030,$0020,$0010,CFOND
                EVEN

************************************************
*        FASTLY DISPLAY 8*8 FONT 1 PLAN        *
************************************************

PUT_MINITEXTE:  MOVEA.L   A3,A4 
                BRA.S     GREPT 
NEXT_C:         ADDA.L    #6,A3 
GREPT:          MOVEQ     #1,D0 
GLOOP:          CLR.L     D1
                MOVEA.L   A3,A2 
                CMPI.W    #-1,MINIFONTE_PTR
                BEQ.S     .BIG_FONTE
                LEA       MINIFONTE,A0 ; MINIFONTE_PTR = 0
                BRA.S     .FOUND_FONTE
.BIG_FONTE:     LEA       BIGFONTE,A0 ; MINIFONTE_PTR = -1
.FOUND_FONTE:   MOVE.B    (A1)+,D1
                TST.B     D1
                BNE.S     PUT_CAR 
                RTS 

PUT_CAR:        CMPI.B    #$72,D1 
                BEQ.S     .next 
                SUBI.L    #$20,D1 
                MULU      #8,D1 
                ADDA.W    D1,A0 ; found caractere
                MOVEQ     #7,D2 
.loop:          MOVE.B    (A0)+,(A2)
                ADDA.L    #160,A2 
                DBF       D2,.loop
                ADDA.L    #1,A3 
                DBF       D0,GLOOP
                BRA.S     NEXT_C 
.next:          ADDA.L    #160*12,A4 ; next line
                MOVEA.L   A4,A3 
                BRA.S     GREPT 

************************************************
*            SAVE ALL INTERRUPTS               *
************************************************
Save_and_init_a_st:
                move	#4,-(sp)
                trap	#14	Get Current Res.
                addq.l	#2,sp
                move	d0,Old_Resol+2

                move	#2,-(sp)
                trap	#14
                addq.l	#2,sp
                move.l	d0,Old_Screen+2

                move #$2700,sr

                lea	Save_all,a0
                move.b	$fffffa03.w,(a0)+
                move.b	$fffffa07.w,(a0)+
                move.b	$fffffa09.w,(a0)+
                move.b	$fffffa11.w,(a0)+
                move.b	$fffffa13.w,(a0)+
                move.b	$fffffa15.w,(a0)+
                move.b	$fffffa17.w,(a0)+
                move.b	$fffffa19.w,(a0)+
                move.b	$fffffa1b.w,(a0)+
                move.b	$fffffa1d.w,(a0)+
                move.b	$fffffa1f.w,(a0)+
                move.b	$fffffa21.w,(a0)+
                move.b	$ffff8201.w,(a0)+
                move.b	$ffff8203.w,(a0)+
                move.b	$ffff820a.w,(a0)+
                move.b	$ffff820d.w,(a0)+
                move.b	$ffff8260.w,(a0)+
                lea	Save_rest,a0
                move.l	$068.w,(a0)+	
                move.l	$070.w,(a0)+	
                move.l	$110.w,(a0)+	
                move.l	$114.w,(a0)+	
                move.l	$118.w,(a0)+	
                move.l	$120.w,(a0)+	
                move.l	$134.w,(a0)+	
                move.l	$484.w,(a0)+	
                movem.l	$ffff8240.w,d0-d7
                movem.l	d0-d7,(a0)

                bclr	#3,$fffffa17.w
                sf	$ffff8260.w
                clr.b	$fffffa07.w 
                clr.b	$fffffa09.w 

                move.l	Zorro_scr1,d0
                move.b	d0,d1
                lsr.w	#8,d0
                move.b	d0,$ffff8203.w
                swap	d0
                move.b	d0,$ffff8201.w
                move.b	d1,$ffff820d.w
                
                stop	#$2300

                jsr	Multi_boot

                clr.b	$484.w		; No bip,no repeat.
                bsr	hide_mouse
                bsr	flush
                move.b	#$12,d0
                bsr	setkeyboard
                rts

************************************************
*           RESTORE ALL INTERRUPTS             *
************************************************

Restore_st:     move #$2700,sr

                jsr	adr_music+4                     ; de-init music
                lea       $ffff8800.w,a0        ; sound off
                move.l    #$8000000,(a0)
                move.l    #$9000000,(a0)
                move.l    #$a000000,(a0)

                lea	Save_all,a0
                move.b	(a0)+,$fffffa03.w
                move.b	(a0)+,$fffffa07.w
                move.b	(a0)+,$fffffa09.w
                move.b	(a0)+,$fffffa11.w
                move.b	(a0)+,$fffffa13.w
                move.b	(a0)+,$fffffa15.w
                move.b	(a0)+,$fffffa17.w
                move.b	(a0)+,$fffffa19.w
                move.b	(a0)+,$fffffa1b.w
                move.b	(a0)+,$fffffa1d.w
                move.b	(a0)+,$fffffa1f.w
                move.b	(a0)+,$fffffa21.w
                move.b	(a0)+,$ffff8201.w
                move.b	(a0)+,$ffff8203.w
                move.b	(a0)+,$ffff820a.w
                move.b	(a0)+,$ffff820d.w
                move.b	(a0)+,$ffff8260.w
                lea	Save_rest,a0
                move.l	(a0)+,$068.w
                move.l	(a0)+,$070.w
                move.l	(a0)+,$110.w
                move.l	(a0)+,$114.w
                move.l	(a0)+,$118.w
                move.l	(a0)+,$120.w
                move.l	(a0)+,$134.w
                move.l	(a0)+,$484.w

                movem.l	(a0),d0-d7
                movem.l	d0-d7,$ffff8240.w

                bset.b #3,$fffffa17.w

                stop	#$2300

                bsr	flush
                move.b	#8,d0
                bsr	setkeyboard	
                bsr	show_mouse

                movea.l	$44e.w,a0
                bsr	clear4plscreen

Old_Resol:      move	#0,-(sp)
Old_Screen:     move.l	#0,-(sp)
                move.l	(sp),-(sp)
                move	#5,-(sp)
                trap	#14	Restore Old Screen & Resol
                lea	12(sp),sp

                move.w	#$25,-(a7)
                trap	#14
                addq.w	#2,a7

                rts

************************************************
*           INITIALISATION SCREENS             *
************************************************

Init_screens:   move.l	#Zorro_screen1,d0
                add.w	#$ff,d0
                sf	d0
                move.l	d0,Zorro_scr1

                bsr	Clear_Zorro2_scr1

                move.l	#Zorro_screen2,d0
                add.w	#$ff,d0
                sf	d0
                move.l	d0,Zorro_scr2

                bsr	Clear_Zorro2_scr2
                rts

Clear_Zorro2_scr1:movea.l	Zorro_scr1,a0
                bsr	clear4plscreen
                rts

Clear_Zorro2_scr2:movea.l	Zorro_scr2,a0
                bsr	clear4plscreen
                rts

************************************************
*    Clear four plane screen with Blitter      *
*              Dracula/Positivity.             *
************************************************
* Parameters:	a0.l = adress of the ramvideo.   *
* d0.w = x1.                                   *
* d1.w = y1.                                   *
* d2.w = x2.                                   *
* d3.w = y2.                                   *
************************************************
clear4plscreen: move.w	#0,d0	;	X1
                move.w	#0,d1	;	Y1
                move.w	#320,d2	; X2
                move.w	#290,d3	;	Y2
                sub.w	d1,d3	; d3=dy=y2-y1.
                addq.w	#$1,d3	; d3=nb of h_lines to clear.
                move.w	d1,d4	; Multiply y1 by $a0.
                add.w	d1,d1
                add.w	d1,d1
                add.w	d4,d1
                lsl.w	#$5,d1
                add.w	d1,a0	; a0 points on the first line to clear.
.x_size:        moveq.l	#-$10,d4	; inc_y_dest.
                and.w	d4,d0	; Care only about the words.
                and.w	d4,d2
                sub.w	d0,d2	; d2=(nb of words-1)*16.
                lsr.w	#$1,d0
                add.w	d0,a0	; a0 points on the first word.
                lsr.w	#$2,d2	; d2=nb of words-4.
                addq.w	#$4,d2	; d2=nb of words to clear.
                move.w	#$51,d0
                sub.w	d2,d0	; d0=inc_y_dest.
                lsl.w	#$1,d0	; It must be given in bytes.
.clear_it:      move.w	#$8a28,a1	; Base adress for the blitter.
                moveq.l	#-$1,d4
                move.l	d4,(a1)+	; Set all masks.
                move.w	d4,(a1)+
                move.w	#$2,(a1)+	; Inc_x_dest=2.
                move.w	d0,(a1)+	; Inc_y_dest=d0.
                move.l	a0,(a1)	; Adress for dest.
                move.w	d2,$4(a1)	; Nb of words per line.
                move.w	d3,$6(a1)	; Nb of h_lines per bitblock.
                move.w	#$200,$8(a1)	; Put everything to zero.
                move.b	#$c0,$a(a1)	; Launch the blitter.
	              rts

*************************************************************************
***            Routine which clear a box, in two bitplanes.           ***
***                         Dracula/Positivity.                       ***
*************************************************************************
* Parameters:	a0.l = adress of the ramvideo.                            *
* d0.w = x1.                                                            *
* d1.w = y1.                                                            *
* d2.w = x2.                                                            *
* d3.w = y2.                                                            *
*************************************************************************
clear2plscreen: sub.w	d1,d3	; d3=dy=y2-y1.
                addq.w	#$1,d3	; d3=nb of h_lines to clear.
                move.w	d1,d4	; Multiply y1 by $a0.
                add.w	d1,d1
                add.w	d1,d1
                add.w	d4,d1
                lsl.w	#$5,d1
                add.w	d1,a0	; a0 points on the first line to clear.
.x_size:        moveq.l	#-$10,d4	; inc_y_dest.
                and.w	d4,d0	; Care only about the words.
                and.w	d4,d2
                sub.w	d0,d2	; d2=(nb of words-1)*16.
                lsr.w	#$1,d0
                add.w	d0,a0	; a0 points on the first word.
                lsr.w	#$4,d2	; d2=nb of words-1.
                addq.w	#$1,d2	; d2=nb of words to clear.
                move.w	#$15,d0
                sub.w	d2,d0	; d0=inc_y_dest.
                lsl.w	#$3,d0	; It must be given in bytes.
.clear_it:      move.w	#$8a28,a1	; Base adress for the blitter.
                moveq.l	#-$1,d4
                move.l	d4,(a1)+	; Set all masks.
                move.w	d4,(a1)+
                move.w	#$8,(a1)+	; Inc_x_dest=8.
                move.w	d0,(a1)+	; Inc_y_dest=d0.
                move.l	a0,(a1)	; Adress for bpl1.
                move.w	d2,$4(a1)	; Nb of words per line.
                move.w	d3,$6(a1)	; Nb of h_lines per bitblock.
                move.w	#$200,$8(a1)	; Put everything to zero.
                move.b	#$c0,$a(a1)	; Launch the blitter.
                addq.l	#$2,a0	; Do the same with bpl2.
                move.l	a0,(a1)+
                move.w	d3,$2(a1)	; Nb of h_lines per bitblock.
                move.b	#$c0,$6(a1)	; Launch the blitter.
                rts

; *************************************************************************
; **       Routine d'effacement 1 Plan Blitter avec coordonnées          **
; **                         Dracula/Positivity.                         **
; *************************************************************************
; a0.l = adresse ramvideo.                                                *
; d0.w = x1.                                                              *
; d1.w = y1.                                                              *
; d2.w = x2.                                                              *
; d3.w = y2.                                                              *
; *************************************************************************
clear1plscreen: move.l	Zorro_scr1,a0	; Clear screen.
                lea	2(a0),a0
                move.w	#90,d0
                move.w	#10,d1
                move.w	#250,d2
                move.w	#180,d3
  movem.l	d0-d4/a0-a1,-(sp)
  
.clip_box:		; Clipper la boite.
  cmp.w	#$0,d1	; y1<0?
  bgt	.not_y1_clipped
  moveq.l	#$0,d1	; Si oui y1=0.
.not_y1_clipped:
  cmp.w	#$c7,d3	; y2>199?
  blt	.not_y2_clipped
  move.l	#$c7,d3	; Si oui y2=199.
.not_y2_clipped:
  cmp.w	#$0,d0	; x1<0?
  bgt	.not_x1_clipped
  moveq.l	#$0,d0	; Si oui x1=0.
.not_x1_clipped:
  cmp.w	#$13f,d2	; x2>319?
  blt	.not_x2_clipped
  move.l	#$13f,d2	; Si oui x2=319.
.not_x2_clipped:

  sub.w	d1,d3	; d3.w=y2-y1=dy.
  addq.w	#$1,d3	; d3=nombre de lignes.
  move.w	d1,d4
  add.w	d1,d1
  add.w	d1,d1
  add.w	d4,d1
  lsl.w	#$5,d1	; d1=y1*$a0.
  add.w	d1,a0	; a0 pointe sur la premiere ligne.
  and.w	#$fff0,d0	; d0=x1-x1 mod(16).
  and.w	#$fff0,d2	; d2=x2-x2 mod(16).
  sub.w	d0,d2
  lsr.w	#$1,d0
  add.w	d0,a0	; a0 pointe sur le premier mot.
  lsr.w	#$1,d2
  move.w	d2,d4	; d4 sera le nb d' octets a passer.
  lsr.w	#$3,d2
  add.w	#$1,d2	; d2=nombre de mots par ligne.  

.init_blitter:
  move.w	#$8a28,a1
  moveq.l	#-$1,d0
  move.l	d0,(a1)+	; Tous les masques pleins.
  move.w	d0,(a1)+
  move.w	#$8,(a1)+	; Increment x.
  neg.w	d4
  add.w	#$a0,d4	; d4=nb d' octets a passer.
  move.w	d4,(a1)+
  move.l	a0,(a1)+	; Adresse destination.
  move.w	d2,(a1)+	; Taille horizontale.
  move.w	d3,(a1)+	; Taille verticale.
  move.w	#$200,(a1)+	; Remplir avec des 0.
  move.b	#$c0,(a1)	; Lancer le blitter.
  
.end:
  movem.l	(sp)+,d0-d4/a0-a1
  rts

************************************************
*            ROUTINES STANDARD                 *
************************************************

hide_mouse:     movem.l	d0-d2/a0-a2,-(sp)
                dc.w	$a00a
                movem.l	(sp)+,d0-d2/a0-a2
                rts

show_mouse:     movem.l	d0-d2/a0-a2,-(sp)
                dc.w	$A009
                movem.l	(sp)+,d0-d2/a0-a2
                rts

flush:          lea	$FFFFFC00.w,a0
.flush:         move.b	2(a0),d0
                btst	#0,(a0)
                bne.s	.flush
                rts

setkeyboard:    btst	#1,$fffffc00.w
                beq.s	setkeyboard
                move.b	d0,$FFFFFC02.w
                rts

clear_bss_datas:lea	bss_start,a0
.loop:          clr.l	(a0)+
                cmp.l	#bss_datas,a0
                blt.s	.loop
                rts

clear_bss:      lea	bss_datas,a0
.loop:          clr.l	(a0)+
                cmp.l	#bss_end,a0
                blt.s	.loop
                rts

wait_for_drive: move.w	$ffff8604.w,d0
                btst	#7,d0
                bne.s	wait_for_drive
                rts

wait_more:      bsr	Wait_vbl
                dbra	d7,wait_more
                rts

Flash_blanc:    move.l	#7,d0
                move	#$777,d7	; white into background
.loop:          bsr     Wait_vbl
                move	d7,$ffff8240.w
                subi.w	#$111,d7
                dbf	d0,.loop
                rts

***************************************************************
*           Fades all colours to black (ST FM only)           *
***************************************************************
* ENTRY Colour palette holds current colours                  *
* EXIT  Colour palette set to all black                       *
***************************************************************
fadeoff:        movem.l d0-a6,-(a7)
                move.w	#8-1,d0	Maximum of 8 stages
.loop1:         move.w	#16-1,d1	16 colours!
                move.l	#$ffff8240,a0	offset of palette
.loop2:         move.w	(a0),d2
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
.end1:          tst.w	d3
                beq.s	.end2	G already zero
                subq.w	#1,d3
.end2:          tst.w	d4
                beq.s	.end3	R already zero
                subq.w	#1,d4
.end3:          lsl.w	#8,d4
                lsl.w	#4,d3
                or.w	d4,d2
                or.w	d3,d2	D2 now contains RGB value
                move.w	d2,(a0)+
                dbra	d1,.loop2	Next colour
 rept 2
                bsr     Wait_vbl
 endr
                dbra	d0,.loop1	Next stage
                movem.l (a7)+,d0-a6
                rts

***************************************************************
*           Fade on colours to values in new palette          *
***************************************************************
* ENTRY a2=address of new palette                             *
* EXIT  Palette changed to new values                         *
***************************************************************
fadeon:         move.w	#8-1,d0	8 stages
.loop1:         move.w	#16-1,d1	16 colours
                move.l	#$ffff8240,a0	offset of palette
                move.l	a2,a1	a2 points to new colours
.loop2:         move.w	(a0),d2
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
.end1:          cmp.w	d3,d6
                beq.s	.end2	G already new colour
                addq.w	#1,d3
.end2:          cmp.w	d4,d7
                beq.s	.end3	R already new colour
                addq.w	#1,d4
.end3:          lsl.w	#8,d4
                lsl.w	#4,d3
                or.w	d4,d2
                or.w	d3,d2	d2 now contains RGB value
                move.w	d2,(a0)+
                dbra	d1,.loop2	Next colour
 rept 2
                bsr     Wait_vbl
 endr
                dbra	d0,.loop1	Next stage
                rts

************************************************
*              WAVE LOGO EFFECT                *
************************************************
sea_ripple:     move.l	Zorro_scr1,a0
                lea	170*160(a0),a0
                move.l	a0,a2
                move.l	sea_wave_pointer,a1
                move.w	#30-1,d7		;ripple length
.loop:          movem.l	(a2),d0-d6/a3-a5
                movem.l	d0-d6/a3-a5,(a0)
                movem.l	40(a2),d0-d6/a3-a5
                movem.l	d0-d6/a3-a5,40(a0)
                movem.l	80(a2),d0-d6/a3-a5
                movem.l	d0-d6/a3-a5,80(a0)
                movem.l	120(a2),d0-d6/a3-a5
                movem.l	d0-d6/a3-a5,120(a0)
                move.w	(a1)+,d0
                bpl.s	.no_reset
                move.l	#sea_waves,sea_wave_pointer
                move.w	(a1)+,d0
.no_reset:      sub.w	d0,a2
                lea	160(a0),a0
                dbf	d7,.loop
                addq.l	#2,sea_wave_pointer
                rts

************************************************
*              CLEAR LOGO EFFECT               *
************************************************
transfer:       move.l	Zorro_scr2,a0
                move.l	Zorro_scr1,a1
                move.w	#20-1,d7
.loop:          move.l	a0,a5
                move.l	a1,a6
                move.w	#8-1,d5
.loop3:         move.w	#200/8-1,d6
.loop2:         move.l	(a0),(a1)
                move.l	4(a0),4(a1)
                add.w	#8*160,a0
                add.w	#8*160,a1
                bsr	pause
                dbf	d6,.loop2
                sub.w	#200*160,a0
                sub.w	#200*160,a1
                add.w	#160,a0
                add.w	#160,a1
                dbf	d5,.loop3
                move.l	a5,a0
                move.l	a6,a1
                add.w	#8,a0
                add.w	#8,a1
                dbf	d7,.loop
                rts

pause:          move.w	d0,-(sp)
                move.w	#200,d0
.loop:          nop
                dbf	d0,.loop
                move.w	(sp)+,d0
                rts

************************************************
*             BLITTER PROCEDURES               *
************************************************

DoBLiTTER__Copie_TEXTE:
                move.l	#TEXTEP,a1
                lea	160*1(a1),a1
                move.w	#0,d0 ; _LEFT
                move.w	#95+1,d1 ; _TOP
                move.w	#320,d2 ; _WIDTH
                move.w	#6-1,d3 ; _HEIGHT
                move.w	#2,d4 ; _PLAN
                bsr	DoBLiTTER__Copie_Picture
                rts

DoBLiTTER__Copie_BOARD_IMG:
                move.l	a0,-(sp)
                lea	IMG_BOARD,a0	;	datas étoiles compressed
                lea	Buffer_LZ7,a1	;	buffer destination
                jsr	d_lz77	; decompress data in a0 -> a1
                move.l (sp)+,a0

                move.l	#Buffer_LZ7,a1
                move.w	#0,d0 ; _LEFT
                move.w	#0,d1 ; _TOP
                move.w	#320,d2 ; _WIDTH
                move.w	#200,d3 ; _HEIGHT
                move.w	#4,d4 ; _PLAN
                bsr	DoBLiTTER__Copie_Picture
                rts

DoBLiTTER__Copie_SONIC_IMG:
                move.l	a0,-(sp)
                lea	SONIC,a0	;	datas étoiles compressed
                lea	Buffer_LZ7,a1	;	buffer destination
                jsr	d_lz77	; decompress data in a0 -> a1
                move.l (sp)+,a0

                move.l	#Buffer_LZ7,a1
                move.w	#0,d0 ; _LEFT
                move.w	#121,d1 ; _TOP
                move.w	#80,d2 ; _WIDTH
                move.w	#78,d3 ; _HEIGHT
                move.w	#4,d4 ; _PLAN
                bsr	DoBLiTTER__Copie_Picture
                rts				;and return.

DoBLiTTER__Copie_STAR_NES_LOGO:
                move.l	a0,-(sp)
                lea	IMG_DRD,a0	;	datas étoiles compressed
                lea	Buffer_LZ7,a1	;	buffer destination
                jsr	d_lz77	; decompress data in a0 -> a1
                move.l (sp)+,a0

                move.l	#Buffer_LZ7,a1
                move.w	#0,d0 ; _LEFT
                move.w	#24,d1 ; _TOP
                move.w	#320,d2 ; _WIDTH
                move.w	#150,d3 ; _HEIGHT
                move.w	#2,d4 ; _PLAN
                bsr	DoBLiTTER__Copie_Picture
                rts

DoBLiTTER__Copie_SMALL_AC_LOGO:
                move.l	Zorro_scr1,a0
                move.l	#P_LOGO_RGC,a1
                move.w	#0,d0 ; _LEFT
                move.w	#0,d1 ; _TOP
                move.w	#320,d2 ; _WIDTH
                move.w	#44,d3 ; _HEIGHT
                move.w	#4,d4 ; _PLAN
                bsr	DoBLiTTER__Copie_Picture
                rts

DoBLiTTER__Copie_NOEXTRA_LOGO:
                lea	NOEXTRA_LOGO,a0	;	datas étoiles compressed
                lea	Buffer_LZ7,a1	;	buffer destination
                jsr	d_lz77	; decompress data in a0 -> a1

                move.l	Zorro_scr1,a0
                move.l	#Buffer_LZ7,a1
                move.w	#0,d0 ; _LEFT
                move.w	#75,d1 ; _TOP
                move.w	#320,d2 ; _WIDTH
                move.w	#74,d3 ; _HEIGHT
                move.w	#4,d4 ; _PLAN
                bsr	DoBLiTTER__Copie_Picture
                rts

DoBLiTTER__Copie_BIG_AC_LOGO:
                lea	IMG_AC,a0	;	datas étoiles compressed
                lea	Buffer_LZ7,a1	;	buffer destination
                jsr	d_lz77	; decompress data in a0 -> a1

                move.l	Zorro_scr1,a0
                move.l	#Buffer_LZ7,a1
                move.w	#0,d0 ; _LEFT
                move.w	#36,d1 ; _TOP
                move.w	#320,d2 ; _WIDTH
                move.w	#160,d3 ; _HEIGHT
                move.w	#4,d4 ; _PLAN
                bsr	DoBLiTTER__Copie_Picture
                rts

DoBLiTTER__Copie_PRESENTS_LOGO:
                move.l	Zorro_scr1,a0
                move.l	#IMG_PRESENT,a1
                move.w	#85,d0 ; _LEFT
                move.w	#89,d1 ; _TOP
                move.w	#147,d2 ; _WIDTH
                move.w	#16,d3 ; _HEIGHT
                move.w	#2,d4 ; _PLAN
                bsr	DoBLiTTER__Copie_Picture
                rts

DoBLiTTER__Copie_FONTE:
                move.l	Zorro_scr1,a1
                move.l	Zorro_scr1,a0
                lea	-2(a0),a0
                move.w	#1,d0 ; _LEFT
                move.w	#1,d1 ; _TOP
                move.w	#256,d2 ; _WIDTH
                move.w	#193,d3 ; _HEIGHT
                move.w	#3,d4 ; _PLAN
                bsr	DoBLiTTER__Copie_Picture
                rts

DoBLiTTER__Copie_BUBBLE_square:
                move.l	Zorro_scr1,a0
                move.l	Zorro_scr1,a1
                lea	160*3(a1),a1
                move.w	#0,d0 ; _LEFT
                move.w	#179,d1 ; _TOP
                move.w	#320,d2 ; _WIDTH
                move.w	#17,d3 ; _HEIGHT
                move.w	#2,d4 ; _PLAN
                bsr	DoBLiTTER__Copie_Picture
                rts

DoBLiTTER__Copie_Picture:
                move.l	a6,-(sp)	;preserve registers
                lea	bitblt(pc),a6		;address of blit table
                move.l	a1,18(a6)		;store 'from' address
                move.l	a0,32(a6)		;store 'to' address
                move.w	#0,14(a6)		;store left from position
                move.w	#0,16(a6)		;store top from position
                move.w	d0,28(a6)		;store left to position
                move.w	d1,30(a6)		;store top to position
                move.w	d2,0(a6)		;store width. 
                move.w	d3,2(a6)		;store height.
                move.w	d4,4(a6)		;set up number of plan
                move.w	#8,22(a6)		;for low resolution
                move.w	#8,36(a6)
                move.l	#0,42(a6)		;set up blit variables 
                move.b	#3,10(a6)		;for any resolution
                move.w	#0,6(a6)
                move.w	#0,8(a6)
                dc.w	$a007			;do the blit!
                move.l	(sp)+,a6	;restore registers
                rts				;and return.

*****************************
* Data for the Blit Routine *
*****************************
bitblt:         DC.W	0	;Width
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
                DCB.W	100,$0
                EVEN
*************************
* End of BLIT Data      *
*************************

Clear_halftone: lea.l $ffff8a00.w,a0 ;32 byte halftone ram
                rept 16
                clr.l (a0)+
                endr
                rts

************************************************
*      3D lines by Griff of InnerCircle        *
************************************************

Show_obj:
		LEA Stack,A5
		LEA seqdata(PC),A3
		SUBQ #1,seq_timer(A3)
		BNE.S .nonew
		MOVE.L seq_ptr(A3),A1
		TST (A1)
		BPL.S .notendseq
		MOVE.L restart_ptr(A3),A1 
.notendseq:
    MOVE.W (A1)+,seq_timer(A3)
		MOVE.W (A1)+,addangx(A3)
		MOVE.W (A1)+,addangy(A3)
		MOVE.W (A1)+,addangz(A3)	; store new incs..
		MOVE.W (A1)+,bzspeed
		MOVE.L A1,seq_ptr(A3)
.nonew:
    LEA trig_tab,A0		; sine table
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
		LEA bM11+2(PC),A1
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
		MOVE D6,bM21-bM11(A1)
* Matrix(3,1) -cosz*sinx
		MOVE D5,D6			cosz
		MULS D0,D6			cosz*sinx
		ADD.L D6,D6
		SWAP D6
		NEG D6				-cosz*sinx
		MOVE D6,bM31-bM11(A1)
* Matrix(1,2) -siny*cosz
		MOVE D2,D6			siny
		MULS D5,D6			siny*cosz
		ADD.L D6,D6
		SWAP D6
		NEG D6				-siny*cosz
		MOVE D6,bM12-bM11(A1)
* Matrix(2,2) cosy*cosz		
		MOVE D3,D6			cosy
		MULS D5,D6			cosy*cosz
		ADD.L D6,D6
		SWAP D6
		MOVE D6,bM22-bM11(A1)
* Matrix(3,2) sinz 
		MOVE D4,bM32-bM11(A1)
* Matrix(1,3) cosy*sinx+siny*sinz*cosx
		MOVE D3,D6			cosy
		MULS D0,D6			cosy*sinx
		MOVE A4,D7			sinz*cosx
		MULS D2,D7
		ADD.L D7,D6
		ADD.L D6,D6
		SWAP D6				siny*(sinz*cosx)
		MOVE D6,bM13-bM11(A1)
* Matrix(2,3) siny*sinx-cosy*sinz*cosx
		MULS D0,D2			siny*sinx
		MOVE A4,D7
		MULS D3,D7
		SUB.L D7,D2 
		ADD.L D2,D2
		SWAP D2
		MOVE D2,bM23-bM11(A1)
* Matrix(3,3) cosz*cosx
		MULS D1,D5 
		ADD.L D5,D5
		SWAP D5				cosz*cosx
		MOVE D5,bM33-bM11(A1)
; Transform and perspect co-ords.
; A5 -> x,y,z.w offsets for co-ords,D7 source co-ords x,y,z.w
; A1 -> to a storage place for the resultant x,y co-ords.
; D0-D7/A0-A4 smashed.
		MOVE (A5)+,D7			get no of verts
		LEA new_coords(PC),A1		storage place new x,y co-ords
		MOVE.L bzspeed(PC),D6
Trans_verts:
    MOVE.L (A5)+,addoffx+2
		MOVE.L (A5)+,addoffy+2
		ADD.L D6,(A5)
		MOVE.L (A5)+,addoffz+2		(after this a5-> d7 x,y,z co-ords
		MOVEA #160-14,A3			centre x
		MOVEA #100-16,A4			centre y
		SUBQ #1,D7				verts-1
trans_lp:
    MOVEM.W (A5)+,D0-D2		x,y,z
		MOVE D0,D3	
		MOVE D1,D4				dup
		MOVE D2,D5
; Calculate x co-ordinate		
bM11		MULS #0,D0			
bM21		MULS #0,D4				mat mult
bM31		MULS #0,D5
		ADD.L D4,D0
		ADD.L D5,D0
		MOVE D3,D6
		MOVE D1,D4
		MOVE D2,D5
; Calculate y co-ordinate		
bM12		MULS #0,D3
bM22		MULS #0,D1				mat mult
bM32		MULS #0,D5
		ADD.L D3,D1
		ADD.L D5,D1
; Calculate z co-ordinate
bM13		MULS #0,D6
bM23		MULS #0,D4				mat mult
bM33		MULS #0,D2
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
drawlines:
    MOVE (A5)+,D7
		SUBQ #1,D7
; A5 -> line list
		MOVE.L Zorro_scr1,A1
		lea	4(a1),a1 ***
		LEA bit_offs(PC),A2
		LEA mul_tab,A3
		LEA new_coords(PC),A6		co-ords
drawline_lp:
    MOVE (A5)+,D1			;1st offset to vertex list
		MOVE (A5)+,D2			;2nd offset to vertex list
		MOVEM (A6,D1),D0-D1		;get x1,y1
		MOVEM (A6,D2),D2-D3		;"  x2,y2
xmax		EQU 319
ymax		EQU 199
Drawline	MOVE.L A1,A0
clipony:
    CMP.W D1,D3			; y2>=y1?(Griff superclip)!
		BGE.S y2big
		EXG D1,D3			; re-order
		EXG D0,D2
y2big:
    TST D3				; CLIP ON Y
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
okmaxy:
    TST.W	D1			; CLIP TO YMIN
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
cliponx:
    CMP.W	D0,D2			; CLIP ON X				
		BGE.S	x2big
		EXG	D0,D2			; reorder
		EXG	D1,D3
x2big:
    TST.W	D2			; totally outside <xmim
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
okmaxx:
    TST.W	D0
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
.gofordraw:
    MOVE.W D2,D4
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
bottotop:
    CMP.W	D4,D5			; dy>dx?
		BLT.S	dxbiggerdy
dybiggerdx:
    MOVE.W D5,D1			; yes!
		BEQ nodraw			; dy=0 nothing to draw(!)
		ASR.W	#1,D1			; e=2/dy
		MOVE.W D5,D2
		SUBQ.W #1,D2			; lines to draw-1(dbf)
.lp:OR.W D6,(A0)
		ADDA.W D3,A0
		SUB.W	D4,D1
		BGT.S	.nostep
		ADD.W	D5,D1
		ADD.W	D6,D6
		DBCS D2,.lp
		BCC.S .drawn
		SUBQ.W #8,A0
		MOVEQ	#1,D6
.nostep:
    DBF D2,.lp
.drawn:
    OR.W	D6,(A0)
nodraw:
    DBF D7,drawline_lp
		RTS

dxbiggerdy	CLR.W	D2
		MOVE.W D4,D1
		ASR.W	#1,D1			; e=2/dx
		MOVE.W D4,D0
		SUBQ.W #1,D0
.lp:OR.W	D6,D2
		SUB.W	D5,D1
		BGE.S	.nostep
		OR.W D2,(A0)
		ADDA.W D3,A0
		ADD.W	D4,D1
		CLR.W	D2
.nostep:
    ADD.W	D6,D6
		DBCS	D0,.lp
		BCC.S	.drawn
.wrchnk:
    OR.W	D2,(A0)
		SUBQ.W #8,A0
		CLR.W	D2
		MOVEQ	#1,D6
		DBF	D0,.lp
.drawn:
    OR.W D6,D2
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

new_coords:
	DS.W 200
bzspeed:
	dc.l 0
; Sequence data 

		RSRESET

seq_timer	RS.W 1
seq_ptr		RS.L 1
addangx		RS.W 1
addangy		RS.W 1
addangz		RS.W 1
restart_ptr	RS.L 1

seqdata:
    DC.W 1
		DC.L sequence 
		DS.W 3
		DC.L restart
sequence:
    DC.W 138+8	* timer
		DC.W -7		* add angle X
		DC.W 0		* add angle Y
		DC.W 0		* add angle Z
		DC.W -31	* speed Z
restart:
		DC.W 400,10,1,1,0
		DC.W 140,10,-2,-2,30
		DC.W -1

nbpoint	equ	52-1

Stack:
    DC.W 0,1024,0
		DC.W nbpoint+1		*	nb de points apres...
		DC.L 0,0,$1200*65536
.France:
	dc.w	+00,+80,0	;0
	dc.w	-10,+78,0	;1
	dc.w	-12,+65,0	;2
	dc.w	-28,+58,0	;3
	dc.w	-21,+55,0	;4
	dc.w	-30,+52,0	;5
	dc.w	-40,+54,0	;6
	dc.w	-42,+60,0	;7
	dc.w	-47,+58,0	;8
	dc.w	-45,+44,0	;9
	dc.w	-58,+45,0	;10
	dc.w	-61,+50,0	;11
	dc.w	-80,+47,0	;12
	dc.w	-75,+42,0	;13
	dc.w	-80,+40,0	;14
	dc.w	-75,+38,0	;15
	dc.w	-80,+36,0	;16
	dc.w	-76,+32,0	;17
	dc.w	-72,+34,0	;18
	dc.w	-57,+24,0	;19
	dc.w	-52,+10,0	;20
	dc.w	-46,+05,0	;21
	dc.w	-57,-43,0	;22
	dc.w	-62,-48,0	;23
	dc.w	-33,-61,0	;24
	dc.w	-31,-58,0	;25
	dc.w	+00,-65,0	;26
	dc.w	-03,-55,0	;27
	dc.w	+14,-47,0	;28
	dc.w	+34,-56,0	;29
	dc.w	+58,-40,0	;30
	dc.w	+42,-21,0	;31
	dc.w	+50,-19,0	;32
	dc.w	+47,+03,0	;33
	dc.w	+37,-03,0	;34
	dc.w	+49,+18,0	;35
	dc.w	+54,+20,0	;36
	dc.w	+62,+48,0	;37
	dc.w	+26,+58,0	;38
	dc.w	+27,+64,0	;39
	dc.w	+20,+60,0	;40
.Corse:
	dc.w	+58,-56,0	;41
	dc.w	+57,-60,0	;42
	dc.w	+50,-65,0	;43
	dc.w	+52,-76,0	;44
	dc.w	+57,-80,0	;45
	dc.w	+62,-68,0	;46
	dc.w	+61,-55,0	;47
.Meaux:
	dc.w	+03,+40,0	;48
	dc.w	+06,+40,0	;49
	dc.w	+06,+38,0	;50
	dc.w	+03,+38,0	;51

	DC.W nbpoint+1		*	nb de lignes apres...

.pFrance:
	dc.w	00*4,01*4
	dc.w	01*4,02*4
	dc.w	02*4,03*4
	dc.w	03*4,04*4
	dc.w	04*4,05*4
	dc.w	05*4,06*4
	dc.w	06*4,07*4
	dc.w	07*4,08*4
	dc.w	08*4,09*4
	dc.w	09*4,10*4
	dc.w	10*4,11*4
	dc.w	11*4,12*4
	dc.w	12*4,13*4
	dc.w	13*4,14*4
	dc.w	14*4,15*4
	dc.w	15*4,16*4
	dc.w	16*4,17*4
	dc.w	17*4,18*4
	dc.w	18*4,19*4
	dc.w	19*4,20*4
	dc.w	20*4,21*4
	dc.w	21*4,22*4
	dc.w	22*4,23*4
	dc.w	23*4,24*4
	dc.w	24*4,25*4
	dc.w	25*4,26*4
	dc.w	26*4,27*4
	dc.w	27*4,28*4
	dc.w	28*4,29*4
	dc.w	29*4,30*4
	dc.w	30*4,31*4
	dc.w	31*4,32*4
	dc.w	32*4,33*4
	dc.w	33*4,34*4
	dc.w	34*4,35*4
	dc.w	35*4,36*4
	dc.w	36*4,37*4
	dc.w	37*4,38*4
	dc.w	38*4,39*4
	dc.w	39*4,40*4
	dc.w	40*4,00*4
.pCorse:
	dc.w	41*4,42*4
	dc.w	42*4,43*4
	dc.w	43*4,44*4
	dc.w	44*4,45*4
	dc.w	45*4,46*4
	dc.w	46*4,47*4
	dc.w	47*4,41*4
.pMeaux:
	dc.w	48*4,49*4
	dc.w	49*4,50*4
	dc.w	50*4,51*4
	dc.w	51*4,48*4

; Create *160 table

create160tb:
		LEA mul_tab,A0
		MOVEQ #0,D0					;create *160 table
		MOVE #200-1,D1
mke_t160_lp:
    MOVE D0,(A0)+
		ADD #160,D0
		DBF D1,mke_t160_lp
		RTS

************************************************
*                  3D STARS                    *
************************************************

no_strs		EQU 120
perstab		DS.W $400

; Clear stars

Clear_stars:
    MOVE.L Zorro_scr1,A0
	  addq.w	#4,a0
		MOVEQ #0,D0
		TST frame_switch
		BNE clearstrs2
clearstrs1:
		REPT no_strs
		MOVE.W D0,2(A0)
		ENDR
		RTS
clearstrs2:
		REPT no_strs
		MOVE.W D0,2(A0)
		ENDR
		RTS

; Calculate a translation matrix (and do rotation sequence!)
; D0-D7/A0-A6 smashed. (which basically means all of them!)

Matrix_make	LEA ballseqdata,A3
		SUBQ #1,ballseq_timer(A3)
		BNE.S .nonew
		MOVE.L ballseq_ptr(A3),A1
		TST (A1)
		BPL.S .notendseq
		MOVE.L ballrestart_ptr(A3),A1 
.notendseq	MOVE.W (A1)+,ballseq_timer(A3)
		MOVE.W (A1)+,balladdangx(A3)
		MOVE.W (A1)+,balladdangy(A3)
		MOVE.W (A1)+,balladdangz(A3)	; store new incs..
		MOVE.W (A1)+,zspeed+2
		MOVE.L A1,ballseq_ptr(A3)
.nonew		LEA angles,a5
		LEA trig_tab,A0			; sine table
		LEA 512(A0),A2			; cosine table
		MOVEM.W (A5),D5-D7    		; get current x,y,z ang	
		ADD balladdangx(A3),D5
		ADD balladdangy(A3),D6		; add increments
		ADD balladdangz(A3),D7
		AND #$7FE,D5
		AND #$7FE,D6
		AND #$7FE,D7
		MOVEM.W D5-D7,(A5)   	
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
		RTS				

; Sequence data for ball starfield
		
		RSRESET

ballseq_timer	RS.W 1
ballseq_ptr		RS.L 1
balladdangx		RS.W 1
balladdangy		RS.W 1
balladdangz		RS.W 1
ballrestart_ptr	RS.L 1

; Translate and plot stars.

Plot_stars	LEA stars,A0		; star co-ords
		MOVE #160,A1
		MOVE #100,A2
		LEA ztable(PC),A3
		LEA clearstrs2+2(PC),A4
		TST frame_switch
		BNE.S .case2
		LEA clearstrs1+2(PC),A4
.case2		MOVE.L Zorro_scr1,A5
	addq.w	#4,a5
		LEA masks,A6
		MOVE #no_strs-1,D7		; no of stars
star_lp		MOVE.W (A0)+,D0
		MOVE.W (A0)+,D1
		MOVE.W (A0),D2
zspeed		SUB #6,D2			; z-zspeed
		CMP #-256,D2
		BLE Star_off
		MOVE D2,(A0)+
conts		MOVE D0,D3	
		MOVE D1,D4			; dup
		MOVE D2,D5
* Calculate x co-ordinate		
M11		MULS #0,D0			
M21		MULS #0,D4			; mat mult
M31		MULS #0,D5 
		ADD.L D4,D0
		ADD.L D5,D0
		MOVE D3,D6
		MOVE D1,D4
		MOVE D2,D5
* Calculate y co-ordinate		
M12		MULS #0,D3
M22		MULS #0,D1			; mat mult
M32		MULS #0,D5
		ADD.L D3,D1
		ADD.L D5,D1
* Calculate z co-ordinate
M13		MULS #0,D6
M23		MULS #0,D4			; mat mult
M33		MULS #0,D2
		ADD.L D6,D2
		ADD.L D4,D2
		ASR.L #8,D0						
		ASR.L #8,D1			
		SWAP D2
		ADD #128,D2
		CMP #256,D2
		BHI noplot
		DIVS D2,D0			; x/z
		ADD A1,D0
		CMP #319,D0	* D0 = X
		BHI noplot
		DIVS D2,D1			; y/z
		ADD A2,D1
		CMP #199,D1	*	D1 = Y
		BHI noplot
		ADD D1,D1
		MOVE mul_160(PC,D1),D1
		ADD D2,D2
		ADD (A3,D2),D1	
		ADD D0,D0
		ADD D0,D0
		MOVE.L (A6,D0),D0
		ADD D0,D1
		SWAP D0
		OR D0,(A5,D1)		
		MOVE D1,(A4)	
		ADDQ.W #4,A4
noplot		DBF D7,star_lp			; do all points
		RTS

mul_160		DS.W 200
		DCB.W 64,4
		DCB.W 64,4
ztable		DCB.W 86,4
		DCB.W 85,2
		DCB.W 85,0
		DCB.W 64,0
		DCB.W 64,0

Star_off	BSR Rand
		MOVE.L D0,D1
		DIVU #270,D1
		SWAP D1
		SUB #135,D1			; rnd for y
		BSR Rand
		DIVU #440,D0
		SWAP D0
		SUB #220,D0			; rnd for x
		ADD #512,D2			; star off z plane so reset
		MOVEM D0-D1,-4(A0)
		MOVE.W D2,(A0)+
		BRA conts

makeperstab	LEA perstab(PC),A0
		MOVEQ #0,D0
		MOVE.L #32767*500,D7
.lp		MOVE.W D0,D1
		MOVE.L D7,D6
		ADD #500,D1
		DIVS D1,D6
		MOVE.W D6,(A0)+
		ADDQ #1,D0
		CMP #$400,D0
		BNE.S .lp
		RTS

; Create plot masks

crplotmasks	LEA masks,A0
		MOVEQ #0,D0
		MOVEQ #19,D6
.bloop		MOVE #$8000,D1
		MOVEQ #15,D7
.aloop		MOVE.W D1,(A0)+
		MOVE.W D0,(A0)+
		LSR #1,D1
		DBF D7,.aloop
		ADDQ #8,D0
		DBF D6,.bloop
		RTS

; Rout to generate *160 table for screen lookup

make160tab	LEA mul_160(PC),A0
		SUB.L A1,A1
		MOVE #199,D0
.makelp		MOVE.W A1,(A0)+
		LEA 160(A1),A1
		DBF D0,.makelp
		RTS

; Rout to generate initial Random star positions.

Random_gen	LEA stars,A3
		MOVE #no_strs-1,D7
f_rand_x	BSR Rand
		DIVU #440,D0
		SWAP D0
		SUB #220,D0
		MOVE D0,(A3)+
f_rand_y	BSR Rand
		DIVU #270,D0
		SWAP D0
		SUB #135,D0
		MOVE D0,(A3)+
		BSR Rand
		AND #$1FF,D0
		SUB #$100,D0
		MOVE D0,(A3)+
		DBF D7,f_rand_x
		RTS

; Random number generator. Returns with number in D0.
; This is a tad slooow... it takes about 650 cycles.

Rand:movem.l	d1-d2/d7,-(sp)
		move.l	rndseed,d1
		move.l	#2147001325,d2
		bsr	mul		; 32 bit multiply
		add.l d6,d7
		move.l d7,d0
		addi.l	#715136305,d0
		move.l	d0,rndseed
		swap d0
		clr.w d0
		swap d0
		movem.l	(sp)+,d1-d2/d7
		rts

; 32 bit multiply.  <540 cycles MAX.  Faster than the 'other' methods.
; Multiply D1 by D2; 64-bit result in D6 & D7.  D6 is MSL and D7 LSL.
; Returns with most significant in D6 and least significant in D7.

mul:move.l	d1,d3
		move.l	d2,d4
		swap	d3
		swap	d4
		move.w	d1,d7
		mulu	d2,d7
		move.w	d3,d6
		mulu	d4,d6
		mulu	d1,d4
		mulu	d2,d3
		add.l	d3,d4
		move.w	d4,d3
		swap	d3
		clr.w	d3
		clr.w	d4
		addx.w	d3,d4
		swap	d4
		add.l	d3,d7
		addx.l	d4,d6
		tst.l	d1
		bpl.s	lmul1
		sub.l	d2,d6
lmul1:		tst.l	d2
		bpl.s	lmul2
		sub.l	d1,d6
lmul2:		rts

****************************************************
*    Written and done specially by Orion/Fuzion    *
*    Special "Amiga" font by Mister.A              *
****************************************************
SPRAYER_OFFSET_DOWN_SCREEN equ (160*66)+2

clear_sprayer:  lea	spray_pos,a1
                move.l	Zorro_scr1,a2
                add.w	#SPRAYER_OFFSET_DOWN_SCREEN,a2
                moveq	#15-1,d0
.loop:          move.l	(a1),d1
                lea	0(a2,d1.l),a3
                clr.w	0(a3)
                clr.w	8(a3)
                clr.w	160(a3)
                clr.w	168(a3)
                clr.w	320(a3)
                clr.w	328(a3)
                clr.w	480(a3)
                clr.w	488(a3)
                clr.w	640(a3)
                clr.w	648(a3)
                clr.w	800(a3)
                clr.w	808(a3)
                clr.w	960(a3)
                clr.w	968(a3)
                clr.w	1120(a3)
                clr.w	1128(a3)
                clr.w	1280(a3)
                clr.w	1288(a3)
                clr.w	1440(a3)
                clr.w	1448(a3)
                clr.w	1600(a3)
                clr.w	1608(a3)
                clr.w	1760(a3)
                clr.w	1768(a3)
                clr.w	1920(a3)
                clr.w	1928(a3)
                clr.w	2080(a3)
                clr.w	2088(a3)
                clr.w	2240(a3)
                clr.w	2248(a3)
                clr.w	2400(a3)
                clr.w	2408(a3)
                lea	10(a1),a1
                dbf	d0,.loop
                rts

spray_text:     move.l	pos_in_pattern,a0
                lea	spray_count,a2
                cmp.l	#215,(a2)
                beq	.end
                add.l	(a2),a0
                addq.l	#1,(a2)
                lea	spray_pos,a1
                addq.l	#2,(a1)
                moveq	#0,d0
                move.b	15(a0),d0
                subq.b	#1,d0
                divu	#20,d0
                move.w	d0,d1
                sub.w	#5,d1
                swap	d0
                sub.w	#9,d0
                ext.l	d1
                mulu	#160,d1
                ext.l	d1
                move.l	#SPRAYER_OFFSET_DOWN_SCREEN+70,150(a1)
                move.b	#0,154(a1)
                move.b	d0,155(a1)
                move.l	d1,156(a1)
                move.l	spray_ascii_pos,d6
                move.l	Zorro_scr1,a2
                add.w	#SPRAYER_OFFSET_DOWN_SCREEN,a2
                move.l	font_table,a3
                moveq	#16-1,d7
.loop:          moveq	#0,d0
                move.b	(a0)+,d0
                beq	.null
                exg.l	a0,d6
                move.b	-1(a0,d0.l),d0	;get char
                exg	a0,d6
                sub.b	#32,d0		;rid of ASCII
                mulu	#512,d0		;calc pos of letter
                move.l	d7,d1
                mulu	#32,d1
                add.l	d1,d0
                move.l	(a1),d1
                moveq	#0,d2
                move.b	4(a1),d2
                add.b	5(a1),d2
                tst.b	d2
                bge.s	.byte
                subq.w	#8,d1
                add.b	#16,d2
                bra.s	.word
.byte:          cmp.b	#15,d2
                ble.s	.word
                addq.w	#8,d1
                sub.b	#16,d2
.word:          add.l	6(a1),d1
                move.l	d1,-10(a1)
                move.b	d2,-6(a1)
                move.b	5(a1),-5(a1)
                move.l	6(a1),-4(a1)
                lea	0(a3,d0.l),a4
                lea	0(a2,d1.l),a5
                divu	#8,d2
                move.w	d2,d3
                mulu	#8,d3
                swap	d2
OFF	set	0
 rept	16
                moveq	#0,d0
                move.w	(a4)+,d0
                swap	d0
                lsr.l	d2,d0
                lsr.l	d3,d0
                or.w	d0,OFF+8(a5)
                swap	d0
                or.w	d0,OFF(a5)
OFF	set	OFF+160
 endr
.null:          lea	10(a1),a1
                dbf	d7,.loop
.end:           rts

calc_new_spray: lea	spray_count,a0	;have we sprayed all letters?
                cmp.l	#215,(a0)
                bne	.not_finished_spraying
                lea	stay_on_screen_timer,a1
                tst.w	(a1)		;has it run out?
                beq.s	.no		;yes
                subq.w	#1+1,(a1)	;	INCREMENTATION + 1
.not_finished_spraying:
                rts

.no:            lea	clear_text_line_offset,a2	;clear text routine....
                move.l	(a2),d1
                cmp.l	#79*160,d1	;top of spray area
                bne.s	cont_clearing
                move.l	#160*160,(a2)
                move.l	#160*160,4(a2)
                move.w	#300,(a1)	;set time to stay on screen
                clr.l	(a0)
                lea	page_no,a0
                move.l	no_pages,d0	;number of pages to spray
                cmp.l	(a0),d0		;compare present page with max
                bne.s	.no_reset
                clr.l	(a0)		;restart pages
.no_reset:      move.l	(a0),d0
                mulu	#200,d0		;each page is 200 bytes long
                lea	spray_ascii,a1
                adda.l	d0,a1
                move.l	a1,spray_ascii_pos
                addq.l	#1,(a0)
                lea	present_spray_pattern,a0
                move.l	max_spray_patterns,d0
                cmp.l	(a0),d0			;have we reached the max
                bne.s	.no_pattern_reset	;no
                clr.l	(a0)
.no_pattern_reset:
                move.l	(a0),d0
                mulu	#232,d0		;length of pattern
                lea	spray_patterns,a1
                add.l	d0,a1
                move.l	a1,pos_in_pattern
                addq.l	#1,(a0)		;increase present spray pattern
                rts

cont_clearing:  moveq	#0,d5
                move.l	4(a2),d2	;get clear area for lower screen
                move.l	Zorro_scr1,a3
                sub.w	#160*30,a3
                add.w	#4,a3
                lea	0(a3,d1.l),a4
                move.w	d5,0(a4)
                move.w	d5,8(a4)
                move.w	d5,16(a4)
                move.w	d5,24(a4)
                move.w	d5,32(a4)
                move.w	d5,40(a4)
                move.w	d5,48(a4)
                move.w	d5,56(a4)
                move.w	d5,64(a4)
                move.w	d5,72(a4)
                move.w	d5,80(a4)
                move.w	d5,88(a4)
                move.w	d5,96(a4)
                move.w	d5,104(a4)
                move.w	d5,112(a4)
                move.w	d5,120(a4)
                move.w	d5,128(a4)
                move.w	d5,136(a4)
                move.w	d5,144(a4)
                move.w	d5,152(a4)
                lea	0(a3,d2.l),a4
                move.w	d5,0(a4)
                move.w	d5,8(a4)
                move.w	d5,16(a4)
                move.w	d5,24(a4)
                move.w	d5,32(a4)
                move.w	d5,40(a4)
                move.w	d5,48(a4)
                move.w	d5,56(a4)
                move.w	d5,64(a4)
                move.w	d5,72(a4)
                move.w	d5,80(a4)
                move.w	d5,88(a4)
                move.w	d5,96(a4)
                move.w	d5,104(a4)
                move.w	d5,112(a4)
                move.w	d5,120(a4)
                move.w	d5,128(a4)
                move.w	d5,136(a4)
                move.w	d5,144(a4)
                move.w	d5,152(a4)
                sub.l	#160,(a2)
                add.l	#160,4(a2)
                rts

make_fonts:     lea	font,a0		;setup shift and shrunk chars
                move.l	font_table,a3
                move.l	#160*230,d0
                add.l	a3,d0
                move.l	d0,timerb
                moveq	#72-1,d0
.loop:          lea	offset_tab,a1
                move.l	a1,a5
                moveq	#8,d7
                moveq	#1,d6
.loop2:         moveq	#16-1,d1
                sub.b	d7,d1
                asl.w	#1,d1
                lea	0(a3,d1.l),a6
.loop3:         move.l	a5,a2
                moveq	#0,d1
                move.b	(a1)+,d1
                asl.w	#1,d1
                lea	-2(a0,d1.l),a4
                move.w	(a4),d4
                moveq	#0,d5
                move.l	d7,d2
.loop4:         moveq	#16,d3
                sub.b	(a2)+,d3
                btst	d3,d4
                beq.s	.no
                bset	d2,d5
.no:            subq.b	#1,d2
                tst.b	(a2)
                bne.s	.loop4
                move.w	d5,(a6)+
                tst.b	(a1)
                bne.s	.loop3
                eor.b	#1,d6
                add.l	d6,d7
                lea	1(a1),a1
                move.l	a1,a5
                lea	32(a3),a3
                cmp.b	#$7f,(a1)
                bne.s	.loop2
                lea	32(a0),a0
                dbf	d0,.loop
                rts

************************************************
* ROUTINES SPRITES 16x16 MASQUED WITH 3 COLORS *
* Special NES Sprites 3 colors                 *
************************************************
MAX_BALLS	equ	14-1 ; 24	; If raster more than 1 vbl, decrease this by 1.

shift_ball:     lea	(16*4*4)(a0),a1
                move.w	#(16*15)-1,d0
.loop:
 rept	4
                move.w	(a0),d1
                swap	d1
                move.w	8(a0),d1
                asr.l	#1,d1
                move.w	d1,8(a1)
                swap	d1
                move.w	d1,(a1)
                addq.w	#2,a0
                addq.w	#2,a1
 endr
                addq.w	#8,a0
                addq.w	#8,a1
                dbf	d0,.loop
                rts

show_sprites:   move.l	Zorro_scr1,a0
                addq.w	#4,a0
                addq.w	#8,a0
                lea	ball_addrs,a5
                add.w	ball_off,a5
                lea	first_path,a4
                move.w	first_ptr,d4
                lea	second_path,a6
                move.w	second_ptr,d6
                moveq	#8,d5
                moveq	#(MAX_BALLS-1),d0
.loop:          move.l	a3,a2
                move.l	a0,a1
                move.l	(a4,d4),d2
                add.l	(a6,d6),d2
                move.w	d2,d1
                swap	d2
                move.w	d1,d3
                lsr.w	#1,d1
                and.w	#$fff8,d1
                add.w	d1,d2
                and.w	#15,d3
                lsl.w	d5,d3
                move.w	d2,(a5)+
                add.w	d2,a1
                add.w	d3,a2
 rept	16
                move.l	(a1),d1
                move.l	(a2)+,d2
                and.l	d2,d1
                or.l	(a2)+,d1
                move.l	d1,(a1)+
                and.l	d2,(a1)+
                move.l	(a1),d1
                move.l	(a2)+,d2
                and.l	d2,d1
                or.l	(a2)+,d1
                move.l	d1,(a1)+
                and.l	d2,(a1)+
                lea	144(a1),a1
 endr
                sub.w	#(4*9),d4
                and.w	#(4*1024)-1,d4
                add.w	#(4*7),d6
                and.w	#(4*1024)-1,d6
                dbf	d0,.loop
                subq.w	#8,first_ptr
                and.w	#(4*1024)-1,first_ptr
                subq.w	#4,second_ptr
                and.w	#(4*1024)-1,second_ptr
                rts

clear_sprites:  move.l	Zorro_scr1,a0
                addq.l	#8,a0
                lea	ball_addrs,a1
                add.w	ball_off,a1
                moveq #0,d0
                moveq #0,d1
                moveq #0,d2
                moveq #0,d3
                moveq	#(MAX_BALLS-1),d0
.loop:          move.l a0,a2
                add (a1)+,a2
i set 0
 rept 8
                movem.l d0-d3,i(a2)
                movem.l d0-d3,i+160(a2)
i set i+320
 endr
                dbf	d0,.loop
                rts

************************************************
*        ROUTINES BIG SCROLLING 1 PLANE        *
************************************************
NEWCHAR:        MOVE.B #0,(TCOUNT)
NC1:            MOVE.L (TPOS),A2
                CLR.L D0
                MOVE.B (A2),D0
                CMP.B #$FF,D0
                BEQ WRAP
                SUB.B #32,D0
NC2:            ADDQ.L #1,(TPOS)
                MULU #416,D0
                lea	Buffer_LZ7,A1
                ADD.L D0,A1
                BRA LETPRIN
WRAP:           MOVE.L #TEXT,(TPOS)
                BRA NC1
LETPRIN:        MOVE.L #SCRBAC+40,A0
 REPT 15
                MOVEM.W (A1)+,D0-D7
                MOVEM.W D0-D7,(A0)
                ADD.L #16,A0
                MOVEM.W (A1)+,D0-D4
                MOVEM.W D0-D4,(A0)
                ADD.L #66-26+10,A0
 ENDR
                BRA.S SCROLL

SCROLLY:        MOVE.B (TCOUNT),D0
                CMP.B #12,D0
                BEQ NEWCHAR
                ADD.B #1,(TCOUNT)
SCROLL:         MOVE.L #SCRBAC,A0
SC1             MACRO
                MOVEM.L 2(A0),D0-D7
                MOVEM.L D0-D7,(A0)
                ADD.L #32,A0
                MOVEM.L 2(A0),D0-D7
                MOVEM.L D0-D7,(A0)
                ADD.L #34,A0
 ENDM
 REPT 15
                SC1
 ENDR

FLICK:          MOVE.L #SCRBAC,A0
                MOVE.L Zorro_scr1,A1
                add.l  #3*160+2,a1
FL1:            MACRO
                MOVEM.W (A0)+,D0-D7
LD              SET 0
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 160
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 320
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 480
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 640
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 800
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 960
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 1120
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 1280
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 1440
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 1600
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 1760
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 1920
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
                MOVEM.W (A0)+,D0-D7
LD              SET 64+0
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 64+160
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 64+320
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 64+480
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 64+640
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 64+800
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 64+960
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 64+1120
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 64+1280
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 64+1440
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 64+1600
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 64+1760
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
LD              SET 64+1920
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                MOVE.W D4,LD+32(A1)
                MOVE.W D5,LD+40(A1)
                MOVE.W D6,LD+48(A1)
                MOVE.W D7,LD+56(A1)
                MOVEM.W (A0)+,D0-D3
LD              SET 128+0
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
LD              SET 128+160
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
LD              SET 128+320
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
LD              SET 128+480
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
LD              SET 128+640
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
LD              SET 128+800
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
LD              SET 128+960
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
LD              SET 128+1120
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
LD              SET 128+1280
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
LD              SET 128+1440
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
LD              SET 128+1600
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
LD              SET 128+1760
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
LD              SET 128+1920
                MOVE.W D0,LD(A1)
                MOVE.W D1,LD+8(A1)
                MOVE.W D2,LD+16(A1)
                MOVE.W D3,LD+24(A1)
                ADD.L #26,A0
                ADD.L #2080,A1
 ENDM
 REPT 15
                FL1
 ENDR
                RTS

************************************************
*     ROUTINES DISPLAY 3D SQUARE ANIMATES      *
************************************************
init_pcarres:   move.l	#cubes,ptrcube
                rts

ptrcube:        ds.l	1

PLOT:           move.l	ptrcube,a0	;source
                move.l	Zorro_scr1,a1	;dest
                mulu	#160,d1
                add	d1,a1
                moveq	#15,d1		;shifting
                and	d0,d1
                eor	d1,d0
                lsr	#1,d0
                add	d0,a1
                moveq	#16-1,d0
.aff:           move	(a0)+,d2
                swap	d2
                clr	d2
                lsr.l	d1,d2
                move	(a0)+,d3
                swap	d3
                clr	d3
                lsr.l	d1,d3
                move.l	d2,d4
                or.l	d3,d4
                not.l	d4
                swap	d2
                swap	d3
                swap	d4
                and	d4,(a1)
                or	d2,(a1)
                and	d4,2(a1)
                or	d3,2(a1)
                swap	d2
                swap	d3
                swap	d4
                and	d4,8(a1)
                or	d2,8(a1)
                and	d4,8+2(a1)
                or	d3,8+2(a1)
                lea	160(a1),a1
                dbra	d0,.aff
                rts

display:        move.l	ptrcube,a0	;source
                moveq	#16-1,d0
.copy:          move.l	(a0)+,(a1)
                lea	160(a1),a1
                dbra	d0,.copy
                lea	-16*160(a1),a1
                addq	#8,a1
                rts
	
DISP            MACRO
                MOVE	#\1,D0
                MOVE	#\2,D1
                BSR	PLOT
 ENDM

pcarres:        move.l	Zorro_scr1,a1	;dest
coord_x set 0
 rept 10+1
                DISP	coord_x,3
coord_x set coord_x+16+4+10
 endr
                add.l	#64,ptrcube
                cmp.l	#fincubes,ptrcube
                blo.s	.ok
                move.l	#cubes,ptrcube
.ok:            rts

cls_pcarres:    move.l	Zorro_scr2,a0	; Clear screen.
                lea	160*3(a0),a0
                move.w	#0,d0
                move.w	#0,d1
                move.w	#320-1,d2
                move.w	#16-1,d3
                bsr	clear2plscreen
                rts

************************************************
*          ROUTINES RASTER SINUSOIDAL          *
************************************************
; Création des données avec paramètres
InitRaster:       movem.l	d0-d7/a0-a6,-(a7)
*> CALCUL PHASE 1 : Calcul des couleurs
                  LEA       PALETTE512,A0 
                  LEA       512(A0),A1
                  MOVEQ     #$7F,D0 
.R1:              MOVE.W    (A0)+,-(A1) 
                  DBF       D0,.R1 
                  LEA       PALETTE512,A0 
                  LEA       1024(A0),A1 
                  MOVE.W    #$FF,D0 
.R2:              MOVE.W    (A0)+,D1
                  MOVE.W    #$1FC,D2
                  SUB.W     D1,D2 
                  MOVE.W    D2,-(A1)
                  DBF       D0,.R2 
                  LEA       PALETTE512,A0 
                  LEA       1024(A0),A1 
                  MOVE.W    #$209,D0
.R3:              MOVE.W    (A0)+,(A1)+ 
                  DBF       D0,.R3 
                  LEA       BUFFER_R4,A0 
                  LEA       BUFFER_R1,A1 
                  MOVE.W    #$3FF,D0
                  CLR.W     D1
.R4:              MOVE.W    D1,D2 
                  LSR.W     #1,D2 
                  ANDI.W    #$FFFE,D2 
                  LEA       0(A1,D2.W),A2 
                  MOVE.L    A2,(A0)+
                  MOVE.W    D1,D2 
                  ANDI.W    #2,D2 
                  NEG.W     D2
                  ADDQ.W    #7,D2 
                  MOVE.W    D2,(A0)+
                  NEG.W     D2
                  ADDQ.W    #7,D2 
                  MOVE.W    D2,(A0)+
                  ADDQ.W    #1,D1 
                  DBF       D0,.R4 
*< CALCUL PHASE 1

*> CALCUL PHASE 2 : Calcul des courbes avec paramètres
                  LEA       PARAM_RASTER,A0 
                  MOVE.W    (A0)+,D0
                  LSL.W     #2,D0 
                  MOVE.W    D0,PARAM_R1 
                  MOVE.W    (A0)+,D0
                  LSL.W     #1,D0 
                  EXT.L     D0
                  MOVE.L    D0,PARAM_R2 
                  MOVE.W    (A0)+,D0
                  MOVE.W    D0,PARAM_R3 
                  MOVE.W    (A0)+,D0
                  LSL.W     #2,D0 
                  MOVE.W    D0,PARAM_R4 
                  MOVE.W    (A0)+,D0
                  LSL.W     #1,D0 
                  EXT.L     D0
                  MOVE.L    D0,PARAM_R5 
                  MOVE.W    (A0)+,D0
                  MOVE.W    D0,PARAM_R6 
                  MOVE.W    (A0)+,PARAM_R7
                  MOVE.W    (A0)+,PARAM_R8
                  MOVE.W    (A0)+,PARAM_R9
                  MOVE.W    (A0)+,PARAM_R10
                  MOVE.W    (A0)+,PARAM_R11
                  MOVE.W    (A0)+,PARAM_R12
                  MOVE.W    (A0)+,PARAM_R13
                  MOVE.W    (A0)+,PARAM_R14
                  MOVE.W    (A0)+,PARAM_R15
                  MOVE.W    (A0)+,D0
                  MOVE.W    D0,TIMING_RASTER 
                  LEA       PALETTE512,A0 
                  LEA       BUFFER_R2,A1 
                  MOVE.W    #$3FF,D0
                  MOVE.W    #1,D3 
PARAM_R3          EQU       *-2 
LOOPRA:           MOVE.W    (A0),D1 
                  ADDA.L    #1,A0 
PARAM_R2          EQU       *-4 
                  LSR.W     D3,D1 
                  ANDI.B    #$FC,D1 
                  ADD.W     D1,D1 
                  ADD.W     D1,D1 
                  MOVE.W    D1,(A1)+
                  CMPA.L    #TAS_R,A0
                  BCS.S     NOTRA
                  SUBA.L    #$400,A0
NOTRA:            DBF       D0,LOOPRA
                  LEA       PALETTE512,A0 
                  LEA       BUFFER_R3,A1 
                  MOVE.W    #$3FF,D0
                  MOVE.W    #1,D3 
PARAM_R6          EQU       *-2 
LOOPRB:           MOVE.W    (A0),D1 
                  ADDA.L    #1,A0 
PARAM_R5          EQU       *-4 
                  LSR.W     D3,D1 
                  ANDI.B    #$FC,D1 
                  ADD.W     D1,D1 
                  ADD.W     D1,D1 
                  MOVE.W    D1,(A1)+
                  CMPA.L    #TAS_R,A0
                  BCS.S     NOTRB
                  SUBA.L    #$400,A0
NOTRB:            DBF       D0,LOOPRB 
                  MOVE.W    #$10D,D3
                  LEA       BUFFER_R1,A0 
BIGRA:            MOVEQ     #$7F,D0 
BIGRB:            MOVE.W    D0,D1 
                  ADDI.W    #1,D1 
PARAM_R7          EQU       *-2 
                  MOVE.W    #1,D4 
PARAM_R10         EQU       *-2 
                  LSR.W     D4,D1 
                  ANDI.W    #$F,D1
                  CMP.W     #7,D1 
                  BLS.S     NOTRC
                  NEG.W     D1
                  ADDI.W    #$F,D1
NOTRC:            MOVE.W    #1,D4 
PARAM_R13         EQU       *-2 
                  LSL.W     D4,D1 
                  MOVE.W    D0,D2 
                  ADDI.W    #2,D2 
PARAM_R8          EQU       *-2 
                  MOVE.W    #2,D4 
PARAM_R11         EQU       *-2 
                  LSR.W     D4,D2 
                  ANDI.W    #$F,D2
                  CMP.W     #7,D2 
                  BLS.S     NOTRD
                  NEG.W     D2
                  ADDI.W    #$F,D2
NOTRD:            MOVE.W    #2,D4 
PARAM_R14         EQU       *-2 
                  LSL.W     D4,D2 
                  ADD.W     D2,D1 
                  MOVE.W    D3,D2 
                  ADDI.W    #3,D2 
PARAM_R9          EQU       *-2 
                  MOVE.W    #3,D4 
PARAM_R12         EQU       *-2 
                  LSR.W     D4,D2 
                  ANDI.W    #$F,D2
                  CMP.W     #7,D2 
                  BLS.S     NOTRE
                  NEG.W     D2
                  ADDI.W    #$F,D2
NOTRE:            MOVE.W    #3,D4 
PARAM_R15         EQU       *-2 
                  LSL.W     D4,D2 
                  ADD.W     D2,D1 
                  MOVE.W    D1,(A0)+
                  DBF       D0,BIGRB 
                  DBF       D3,BIGRA 
*< CALCUL PHASE 2
                  movem.l	(a7)+,d0-d7/a0-a6
                  RTS

Raster:           LEA       $FFFF8250.W,A1
                  LEA       BUFFER_R1,A0 
                  LEA       BUFFER_R2,A3 
                  LEA       BUFFER_R3,A5 
                  LEA       BUFFER_R4,A4 
                  MOVE.W    #$10D,D0
                  LEA       $FFFF8209.W,A6
                  MOVE.W    #$12,D7 
.SYNCHRO:         TST.B     (A6)
                  BEQ.S     .SYNCHRO
                  SUB.B     (A6),D7 
                  LSR.L     D7,D7 
                  MOVE      #$2700,SR 
                  NOP 
                  CLR.L     D4
                  MOVE.W    CURSOR_R1,D4 
                  ADDI.W    #4,CURSOR_R1 
PARAM_R1          EQU       *-6 
                  ANDI.W    #$3FF,CURSOR_R1
                  LEA       0(A3,D4.W),A3 
                  CLR.L     D4
                  MOVE.W    CURSOR_R2,D4 
                  ADDI.W    #4,CURSOR_R2 
PARAM_R4          EQU       *-6 
                  ANDI.W    #$3FF,CURSOR_R2
                  LEA       0(A5,D4.W),A5 
                  CLR.L     D1
                  CLR.L     D2
                  MOVE.L    #256,D4 : Interleave
.loop:            ADD.L     D4,D2 
                  MOVE.W    (A3)+,D1
                  ADD.W     (A5)+,D1
                  LEA       0(A4,D1.W),A6 
                  MOVEA.L   (A6)+,A0
                  ADDA.L    D2,A0 
                  MOVE.W    (A6)+,D1
                  LSR.W     D1,D3 
                  NOP 
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A0)+,(A1)
                  MOVE.W    (A6)+,D1
                  LSR.W     D1,D3 
                  DBF       D0,.loop 
                  CLR.W     (A1)
                  SUBQ.W    #1,TIMING_RASTER 
                  MOVE      #$2300,SR
                  RTS

**********************************************
*           ROUTINE LINE 1 PLANE             *
**********************************************
put_big_square: move.w	#1,d4	* Grand carré
.loop:          movea.l Zorro_scr1,a0
                lea 6(a0),a0
                move.w	#112,d0
                move.w	d4,d1
                move.w	#286+1,d2
                move.w	d4,d3
                move.l	d4,-(a7)
                jsr LINE
                move.l	(a7)+,d4
                movea.l Zorro_scr2,a0
                lea 6(a0),a0
                move.w	#112,d0
                move.w	d4,d1
                move.w	#286+1,d2
                move.w	d4,d3
                move.l	d4,-(a7)
                jsr LINE
                move.l	(a7)+,d4
                add.w	#1,d4
                cmp.w	#175+1,d4
                bne.s	.loop
                movea.l Zorro_scr1,a0	* Ligne Haut
                lea 2(a0),a0
                move.w	#112-1,d0
                move.w	#0,d1
                move.w	#286+1,d2
                move.w	#0,d3
                jsr LINE
                movea.l Zorro_scr2,a0
                lea 2(a0),a0
                move.w	#112-1,d0
                move.w	#0,d1
                move.w	#286+1,d2
                move.w	#0,d3
                jsr LINE
                movea.l Zorro_scr1,a0	* Ligne Bas
                lea 2(a0),a0
                move.w	#112-1,d0
                move.w	#176,d1
                move.w	#286+1,d2
                move.w	#176,d3
                jsr LINE
                movea.l Zorro_scr2,a0
                lea 2(a0),a0
                move.w	#112-1,d0
                move.w	#176,d1
                move.w	#286+1,d2
                move.w	#176,d3
                jsr LINE
                movea.l Zorro_scr1,a0	* Ligne Gauche
                lea 2(a0),a0
                move.w	#112-1,d0
                move.w	#0,d1
                move.w	#112-1,d2
                move.w	#176,d3
                jsr LINE
                movea.l Zorro_scr2,a0
                lea 2(a0),a0
                move.w	#112-1,d0
                move.w	#0,d1
                move.w	#112-1,d2
                move.w	#176,d3
                jsr LINE
                movea.l Zorro_scr1,a0	* Ligne Droite
                lea 2(a0),a0
                move.w	#286+2,d0
                move.w	#0,d1
                move.w	#286+2,d2
                move.w	#176,d3
                jsr LINE
                movea.l Zorro_scr2,a0
                lea 2(a0),a0
                move.w	#286+2,d0
                move.w	#0,d1
                move.w	#286+2,d2
                move.w	#176,d3
                jsr LINE
                rts

put_squares:    move.w	#2,d4	* Grand carré
.loop:          movea.l Zorro_scr1,a0
                lea 6(a0),a0
                move.w	#14,d0
                move.w	d4,d1
                move.w	#256,d2
                move.w	d4,d3
                move.l	d4,-(a7)
                jsr LINE
                move.l	(a7)+,d4
                add.w	#1,d4
                cmp.w	#196,d4
                bne.s	.loop
                movea.l Zorro_scr1,a0	* Ligne Haut
                lea 2(a0),a0
                move.w	#14-1,d0
                move.w	#1,d1
                move.w	#256+1,d2
                move.w	#1,d3
                jsr LINE
                movea.l Zorro_scr1,a0	* Ligne Bas
                lea 2(a0),a0
                move.w	#14-1,d0
                move.w	#196,d1
                move.w	#256+1,d2
                move.w	#196,d3
                jsr LINE
                movea.l Zorro_scr1,a0	* Ligne Gauche
                lea 2(a0),a0
                move.w	#13,d0
                move.w	#2,d1
                move.w	#13,d2
                move.w	#196,d3
                jsr LINE
                movea.l Zorro_scr1,a0	* Ligne Droite
                lea 2(a0),a0
                move.w	#257,d0
                move.w	#2,d1
                move.w	#257,d2
                move.w	#196,d3
                jsr LINE
                rts

init_line_rout:
* ROUTINE HORIZONTALE * 20
	LEA	DEB_1(PC),A1
	LEA	FIN_1(PC),A2
	MOVE.W	#18,D1
.0:	MOVE.W	#((FIN_1-DEB_1)/2)-1,D0
	MOVE.L	A1,A3
.1:	MOVE.W	(A3)+,(A2)+
	DBRA.W	D0,.1
	DBRA.W	D1,.0
* REPERTORATION DES 320 OR ET BSET
	LEA	DEB_1(PC),A0
	LEA	FIN_H(PC),A2
	LEA	TAB320(PC),A1
.2:	MOVE.W	(A0)+,D0
	CMPI.W	#$DE4A,D0
	BNE.S	.3
	LEA	-4(A0),A3
	MOVE.L	A3,(A1)+
.3:	CMP.L	A0,A2
	BNE.S	.2
* ROUTINE VERTICALE * 200
	LEA	DEB_2(PC),A1
	LEA	FIN_2(PC),A2
	MOVE.W	#198,D1
.4:	MOVE.W	#((FIN_2-DEB_2)/2)-1,D0
	MOVE.L	A1,A3
.5:	MOVE.W	(A3)+,(A2)+
	DBRA.W	D0,.5
	DBRA.W	D1,.4
* REPERTORATION DES 200 BSET
	LEA	DEB_2(PC),A0
	LEA	FIN_V(PC),A2
	LEA	TAB200(PC),A1
.6:	MOVE.W	(A0)+,D0
	CMPI.W	#$DC4A,D0
	BNE.S	.7
	LEA	-4(A0),A3
	MOVE.L	A3,(A1)+
.7:	CMP.L	A0,A2
	BNE.S	.6
* TABLE DE MULTIPLICATION DE 160
	LEA	TAB160(PC),A0
	CLR.W	D1
	MOVE.W	#199,D0
.9:	MOVE.W	D1,(A0)+
	ADD.W	#160,D1
	DBRA.W	D0,.9
* ROUTINE D'EFFACEMENT 1
	LEA	SC_FILL1(PC),A0
	MOVE.W	#(200*20)-2,D0
	CLR.W	D6
.A:	MOVE.W	#$3140,(A0)+
	ADDQ.W	#8,D6
	MOVE.W	D6,(A0)+
	DBRA.W	D0,.A
* ROUTINE D'EFFACEMENT 2
	LEA	SC_FILL2(PC),A0
	MOVE.W	#99,D0
	MOVE.W	#(50*160)+32,D6
.D:	MOVE.W	#9,D1
.C:	MOVE.W	#$3140,(A0)+
	ADDQ.W	#8,D6
	MOVE.W	D6,(A0)+
	DBRA.W	D1,.C
	ADD.L	#80,D6
	DBRA.W	D0,.D
	RTS
***************************************
* ADRESSE ECRAN: A0                   *
* POINT 1 :      X1: D0  / Y1: D1     *
* POINT 2 :      X2: D2  / Y2: D3     *
***************************************
LINE:
* ON S'ASSURE QUE X1 < X2
	CMP.W	D0,D2
	BPL.S	.NEXT1
	EXG	D0,D2
	EXG	D1,D3
.NEXT1:	LEA	TAB160(PC),A6
	LEA	160.W,A3	* A3=160 (ON DESCEND)
* DX
	MOVE.W	D2,A1	* A1=X2-X1
	SUB.W	D0,A1
* ON MONTE OU ON DESCEND ?
	CMP.W	D1,D3
	BPL.S	.NEXT2
	LEA	-160.W,A3	* A3=-160 (ON MONTE)
* DY (ON MONTE)
	MOVE.W	D1,A2	* A2=Y1-Y2
	SUB.W	D3,A2
	BRA.S	.NEXT3
.NEXT2:
* DY (ON DESCEND)
	MOVE.W	D3,A2	* A2=Y2-Y1
	SUB.W	D1,A2
* DX > DY ?
.NEXT3:	CMP.W	A1,A2
	BLS.S	XVERSION
YVERSION:
* DETERMINATION DE LA LIGNE DE DEPART
	MOVE.W	D1,D4
	LSL.W	#1,D4
	MOVE.W	(A6,D4.W),D4
	ADD.W	D4,A0
* DE L'OCTET EXACTE DE DEPART
	MOVE.W	D0,D4
	AND.W	#$FFF0,D4
	LSR.W	#1,D4
	ADD.W	D4,A0
	MOVE.W	D0,D4
	AND.W	#$000F,D4
	CMPI.W	#8,D4
	BMI.S	.NEXT4
	ADDQ.L	#1,A0
	SUBQ.W	#8,D4	
* ON POSE LE RTS ET ON CALCUL L'ADRESSE DE BRANCHEMENT
.NEXT4:	MOVE.W	#7,-(SP)
	SUB.W	D4,(SP)
	MOVE.W	A3,D4
	BPL.S	.NEXT6
	EXG	D1,D3
.NEXT6:	LEA	TAB200(PC),A4
	MOVE.W	D1,D4
	LSL.W	#2,D4
	MOVE.L	(A4,D4.W),A5
	MOVE.W	D3,D4
	LSL.W	#2,D4
	MOVE.L	(A4,D4.W),A4
	ADDQ.L	#2,A4
	MOVE.W	(A4),A6
	MOVE.W	#$4E75,(A4)
* ON CALCULE LE PAS
	CLR.L	D7
	MOVE.W	A1,D7
	SWAP	D7
	MOVE.W	A2,D1
	BEQ.S	.NEXT5
	DIVU	D1,D7
	MOVE.W	D7,A2
	BRA.S	CONT1
.NEXT5:	MOVE.W	#0,A2
* ON PREPARE LES REGISTRES
CONT1:	
	MOVE.W	(SP)+,D7
	MOVE.L	#$00070001,D0
	MOVE.W	A0,D1
	AND.W	#1,D1
	BEQ.S	CONT5
	SWAP	D0
CONT5	MOVE.W	#$7FFF,D6
	JSR	(A5)
	MOVE.W	A6,(A4)
	RTS
XVERSION:
* DETERMINATION DE LA LIGNE DE DEPART
	MOVE.W	D1,D4
	LSL.W	#1,D4
	MOVE.W	(A6,D4.W),D4
	ADD.W	D4,A0
* DE L'OCTET EXACTE DE DEPART
	MOVE.W	D0,D4
	AND.W	#$FFF0,D4
	LSR.W	#1,D4
	ADD.W	D4,A0
	MOVE.W	D0,D4
	AND.W	#$000F,D4
	CMPI.W	#8,D4
	BMI.S	.NEXT6
	ADDQ.L	#1,A0
* ON POSE LE RTS ET ON CALCUL L'ADRESSE DE BRANCHEMENT
.NEXT6:	LEA	TAB320(PC),A4
	MOVE.W	D0,D4
	LSL.W	#2,D4
	MOVE.L	(A4,D4.W),A5
	MOVE.W	D2,D4
	LSL.W	#2,D4
	MOVE.L	(A4,D4.W),A4
	ADDQ.L	#2,A4
	MOVE.W	(A4),A6
	MOVE.W	#$4E75,(A4)
* ON CALCULE LE PAS
	CMP.W	A2,A1
	BEQ.S	.NEXT8
	CLR.L	D7
	MOVE.W	A2,D7
	SWAP	D7
	MOVE.W	A1,D1
	BEQ.S	.NEXT7
	DIVU	D1,D7
	MOVE.W	D7,A2
	BRA.S	CONT2
.NEXT8:	MOVE.W	#-1,A2
	BRA.S	CONT2
.NEXT7:	MOVE.W	#0,A2
* ON PREPARE LES REGISTRES
CONT2:	MOVE.W	#001,D0	* D0 SERT 2 FOIS
	MOVE.W	#004,D1
	MOVE.W	#008,D2
	MOVE.W	#016,D3
	MOVE.W	#032,D4
	MOVE.W	#064,D5
	MOVE.W	#128,D6
	MOVE.W	#$7FFF,D7
	JSR	(A5)
	MOVE.W	A6,(A4)
	RTS
* LET'S GO !
* ROUTINE DE LIGNE HORIZONTALE
DEB_1:	OR.B	D6,(A0)
	ADD.W	A2,D7
	BCC.S	.CONT1
	ADD.W	A3,A0
.CONT1:	OR.B	D5,(A0)
	ADD.W	A2,D7
	BCC.S	.CONT2
	ADD.W	A3,A0
.CONT2:	OR.B	D4,(A0)
	ADD.W	A2,D7
	BCC.S	.CONT3
	ADD.W	A3,A0
.CONT3:	OR.B	D3,(A0)
	ADD.W	A2,D7
	BCC.S	.CONT4
	ADD.W	A3,A0
.CONT4:	OR.B	D2,(A0)
	ADD.W	A2,D7
	BCC.S	.CONT5
	ADD.W	A3,A0
.CONT5:	OR.B	D1,(A0)
	ADD.W	A2,D7
	BCC.S	.CONT6
	ADD.W	A3,A0
.CONT6:	BSET.B	D0,(A0)
	ADD.W	A2,D7
	BCC.S	.CONT7
	ADD.W	A3,A0
.CONT7:	OR.B	D0,(A0)+
	ADD.W	A2,D7
	BCC.S	.CONT8
	ADD.W	A3,A0
.CONT8:	OR.B	D6,(A0)
	ADD.W	A2,D7
	BCC.S	.CONT9
	ADD.W	A3,A0
.CONT9:	OR.B	D5,(A0)
	ADD.W	A2,D7
	BCC.S	.CONT10
	ADD.W	A3,A0
.CONT10:	OR.B	D4,(A0)
	ADD.W	A2,D7
	BCC.S	.CONT11
	ADD.W	A3,A0
.CONT11:	OR.B	D3,(A0)
	ADD.W	A2,D7
	BCC.S	.CONT12
	ADD.W	A3,A0
.CONT12:	OR.B	D2,(A0)
	ADD.W	A2,D7
	BCC.S	.CONT13
	ADD.W	A3,A0
.CONT13:	OR.B	D1,(A0)
	ADD.W	A2,D7
	BCC.S	.CONT14
	ADD.W	A3,A0
.CONT14:	BSET.B	D0,(A0)
	ADD.W	A2,D7
	BCC.S	.CONT15
	ADD.W	A3,A0
.CONT15:	OR.B	D0,(A0)
	ADD.W	A2,D7
	BCC.S	.CONT16
	ADD.W	A3,A0
.CONT16:	ADDQ.W	#7,A0
FIN_1:	DS.B	(FIN_1-DEB_1)*19
FIN_H:	RTS
DEB_2:	BSET	D7,(A0)
	ADD.W	A2,D6
	BCC.S	JUMP
	DBF.W	D7,JUMP
	ADDA.W	D0,A0
	SWAP	D0
	MOVEQ.W	#7,D7
JUMP:	ADDA.W	A3,A0
FIN_2:	DS.B	(FIN_2-DEB_2)*199
FIN_V:	RTS
* L'ADRESSE DES 320 OR ET BSET POUR LA ROUTINE HORIZONTALE
TAB320:	DS.L	320
* L'ADRESSE DES 320 BSET POUR LA ROUTINE VERTICALE
TAB200:	DS.L	320
* TABLE DE MULTIPLICATION DE 160
TAB160:	DS.W	200

SPEED_CLEAR1:	CLR.W	D0
	MOVE.W	D0,(A0)
SC_FILL1:	DS.L	(200*20)-1	* $3140 + OFFSET
	RTS

SPEED_CLEAR2:	CLR.W	D0
SC_FILL2:	DS.L	(100*10)	* $3140 + OFFSET
	RTS

************************************************
*         3D faces pleines from OMEGA          *
*      (Not the best and bugged for STF!)      *
*    Strongly modified and adapted by Atomus   *
************************************************
init_polygon_code:lea.l	parameters,a0
                jsr	polygon_mupp
                move.l	a0,variabler
                move.l	a1,hoppa
                rts

calcul_3d:      move.w	xang,d0	* Ajout des coefficients pour la courbe
                move.w	yang,d1
                move.w	zang,d2
                add.w	#2*4,d0
                add.w	#2*2,d1
                add.w	#2*1,d2
                andi.w	#$3FF,d0
                andi.w	#$3FF,d1
                andi.w	#$3FF,d2
                move.w	d0,xang
                move.w	d1,yang
                move.w	d2,zang

                lea.l	sintab,a0	* Chargement des paramêtres
                move.l	a0,a3
                move.l	a0,a4
                add.w	d0,a0
                add.w	d1,a3
                add.w	d2,a4
                lea.l	coords,a1
                lea.l	newco,a2
                move.w	#14,d7
	
 rept 8
                move.w	(a1)+,d0	* Recupere les coordonnées d'un point
                move.w	(a1)+,d1
                move.w	(a1)+,d2

* Rotation X
                move.w	d1,d3			* copy y
                move.w	d2,d4			* copy z
                muls.w	256(a0),d1		* y.cos
                muls.w	(a0),d4			* z.sin
                sub.l	d4,d1			* y.cos - z.sin
                asr.l	d7,d1			* new y --> d1
                muls.w	(a0),d3			* y.sin
                muls.w	256(a0),d2		* z.cos
                add.l	d3,d2			* y.sin + z.cos
                asr.l	d7,d2			* new z --> d2

* Rotation Y
                move.w	d0,d3			* copy x 
                move.w	d2,d4			* copy z
                muls.w	256(a3),d0		* x.cos
                muls.w	(a3),d4			* z.sin
                add.l	d4,d0			* x.cos + y.sin
                asr.l	d7,d0			* new x --> d0
                muls.w	(a3),d3			* x.sin
                muls.w	256(a3),d2		* z.cos
                sub.l	d3,d2			* z.cos - x.sin
                asr.l	d7,d2			* new z --> d2

* Rotation Z
                move.w	d0,d3			* copy x
                move.w	d1,d4			* copy z
                muls.w	256(a4),d0		* x.cos
                muls.w	(a4),d4			* y.sin
                sub.l	d4,d0			* x.cos - y.sin
                asr.l	d7,d0			* new x --> d0
                muls.w	(a4),d3			* x.sin
                muls.w	256(a4),d1		* y.cos
                add.l	d3,d1			* x.sin + y.cos
                asr.l	d7,d1			* new y --> d1

                bsr	pourcent	* Coefficient multiplicateur des coordonnées
                move.w	#2000,d4
                sub.l	d2,d3
                muls.w	d3,d0
                divs.w	d4,d0
                muls.w	d3,d1
                divs.w	d4,d1

* Centre au milieu
                add.w	#100-11,d1			* Center Ypos
                add.w	#160+40,d0			* Center Xpos

                move.w	d0,(a2)+	* Ajout des coordonnées calculés
                move.w	d1,(a2)+
 endr

                bsr.s	draw_side1	* Dessine les six côtés
                bsr.s	draw_side2
                bsr	draw_side3
                bsr	draw_side4
                bsr	draw_side5
                bsr	draw_side6
                rts

pourcent:       move.w	coeff,d3
                cmp.w	#1000,d3
                bge.s	.percent
                add.w	#1,d3
.percent:       move.w	d3,coeff
                rts
	
draw_side1:     move.l	variabler,a0
                lea.l	newco,a2
                move.w	#%1100000110,(a0)+
                move.w	#%0100000000,(a0)+
                move.l	(a2),(a0)+
                move.l	4(a2),(a0)+
                move.l	8(a2),(a0)+
                move.l	12(a2),(a0)+
                move.l	hoppa,a1
                jsr	(a1)
                rts

draw_side2:     move.l	variabler,a0
                lea.l	newco,a2
                move.w	#%1100000101,(a0)+
                move.w	#%0100000000,(a0)+
                move.l	16(a2),(a0)+
                move.l	20(a2),(a0)+
                move.l	24(a2),(a0)+
                move.l	28(a2),(a0)+
                move.l	hoppa,a1
                jsr	(a1)
                rts

draw_side3:     move.l	variabler,a0
                lea.l	newco,a2
                move.w	#%1100000101,(a0)+
                move.w	#%1000000000,(a0)+
                move.l	(a2),(a0)+
                move.l	16(a2),(a0)+
                move.l	28(a2),(a0)+
                move.l	12(a2),(a0)+
                move.l	hoppa,a1
                jsr	(a1)
                rts

draw_side4:     move.l	variabler,a0
                lea.l	newco,a2
                move.w	#%1100000101,(a0)+
                move.w	#%1000000000,(a0)+
                move.l	4(a2),(a0)+
                move.l	8(a2),(a0)+
                move.l	24(a2),(a0)+
                move.l	20(a2),(a0)+
                move.l	hoppa,a1
                jsr	(a1)
                rts

draw_side5:     move.l	variabler,a0
                lea.l	newco,a2
                move.w	#%1100000101,(a0)+
                move.w	#%1100000000,(a0)+
                move.l	(a2),(a0)+
                move.l	4(a2),(a0)+
                move.l	20(a2),(a0)+
                move.l	16(a2),(a0)+
                move.l	hoppa,a1
                jsr	(a1)
                rts

draw_side6:     move.l	variabler,a0
                lea.l	newco,a2
                move.w	#%1100000101,(a0)+
                move.w	#%1100000000,(a0)+
                move.l	28(a2),(a0)+
                move.l	24(a2),(a0)+
                move.l	8(a2),(a0)+
                move.l	12(a2),(a0)+
                move.l	hoppa,a1
                jsr	(a1)
                rts

cls_square:     move.l	Zorro_scr1,a0	; Clear screen1.
                move.w	#120,d0	;	X1
                move.w	#12-11,d1	;	Y1
                move.w	#280-7,d2	; X2
                move.w	#186-11,d3	;	Y2
                jsr	clear2plscreen
                rts

*********************************************
*      ONE PLANE BUFFER SCROLLER 16*16      *
*********************************************
nolines		EQU 16
linewid		EQU 104
phbufsize	EQU nolines*linewid

Do_bufscroll	LEA ovscr_point(PC),A1		; ->some variables
		MOVE.L (A1)+,A0			; curr text ptr
		MOVE (A1)+,D6			; pixel offset
		ADD ovscrlspeed(PC),D6		; pix offset+speed
		AND #15,D6			; next 16 pix?
		BNE.S .notnchar			; no then skip
		ADDQ.W #2,(A1)			; onto next chunk 
		CMP #linewid/2,(A1)		; in pix buffer.
		BNE.S .noreset			; reached end of buffer?		
		CLR (A1)			; if yes reset buffer position
.noreset	ADDQ.L #1,A0			; next letter...
		MOVE.W ovthischar+2(PC),ovthischar ; cycle characters.
		MOVEQ #0,D0
.fetchchar	MOVE.B (A0),D0	
		BNE.S .notwrap			; end of text?
		LEA ovtext(PC),A0		; yes restart text
		MOVE.B (A0),D0
.notwrap	CMP.B #1,D0
		BNE.S .notsetspeed
		MOVE.B 1(A0),ovscrlspeed+1
		ADDQ.L #2,A0
		BRA.S .fetchchar
.notsetspeed	ADD.W D0,D0
		MOVE.W D0,ovthischar+2
.notnchar	MOVE D6,-(A1)			; otherwise restore
		MOVE.L A0,-(A1)
		LEA phfontbuf(PC),A5     	; character addr    
		LEA (A5),A6
		ADDA.W ovthischar(PC),A5
		ADDA.W ovthischar+2(PC),A6
		MOVE.W ovscx(PC),D0
		MULU #phbufsize,d0
		LEA (phscbuffer)-2,A3
		ADD.L D0,A3
		ADD ovscrlpos(PC),A3
		LEA 2(A3),A1
		MOVE.W ovscrlspeed(PC),D4	; scroll speed
		SUBQ #1,D4
		MULU #12,D4			; *14(for jmp thru)
		LEA .jmpthru(PC),A4
		SUB.W D4,A4			; jmp address
		MOVEQ #nolines-1,D1
.updatebuflp	MOVE.W (A6),D3
		SWAP D3
		MOVE.W (A5),D3 
		LEA 120(A5),A5
		LEA 120(A6),A6
		ROL.L D6,D3
		MOVE.W D3,(linewid/2)(A3)	; update the buffers		
		MOVE.W D3,(A3)
		MOVE.L A3,A2
		JMP (A4)
		REPT 15				; e.g number of buffers
		LEA phbufsize(A2),A2		; to update = speed!
		ROL.L #1,D3
		MOVE.W D3,(linewid/2)(A2)
		MOVE.W D3,(A2)
		ENDR
.jmpthru	LEA linewid(A3),A3
		DBF D1,.updatebuflp
set_bufcopyptrs	MOVE.L A1,bufsource_ptr
		MOVE.L Zorro_scr1,A4
		ADD.L #(207*160)+6,A4
		MOVEQ #16-1,D0
.LP		MOVE.L (A1)+,(A4)
		MOVE.L (A1)+,16(A4)
		MOVE.L (A1)+,32(A4)
		MOVE.L (A1)+,48(A4)
		MOVE.L (A1)+,64(A4)
		MOVE.L (A1)+,80(A4)
		MOVE.L (A1)+,96(A4)
		MOVE.L (A1)+,112(A4) 
		MOVE.L (A1)+,128(A4)
		MOVE.L (A1)+,144(A4)
		LEA linewid-40(A1),A1		; next buf line
		LEA 160(A4),A4
		DBRA D0,.LP
		RTS

******************************************
*                                        *
* Very! fast lz77 decompression routine  *
* 68000 version                          *
*                                        *
******************************************
 include "\RGC\include\lz77_130.s"

******************************************************************
	SECTION	DATA
******************************************************************

no_palette: dcb.w 16,$0

COULEUR_M_1 equ $0f00
COULEUR_M_2 equ $0bbb
COULEUR_M_3 equ $0fff
Pal_SPRITE_M:	
	dc.w	$000,$F00,$F00,$F00,COULEUR_M_1,$F00,COULEUR_M_1,$F00
	dc.w	COULEUR_M_2,$F00,COULEUR_M_2,$F00,COULEUR_M_3,$F00,COULEUR_M_3,$0FFF

COULEUR_E_1 equ $0c20/2
COULEUR_E_2 equ $0e60/2
COULEUR_E_3 equ $0ee6/2
Pal_SPRITE_E:	
	dc.w	$000,$F00,$F00,$F00,COULEUR_E_1,$F00,COULEUR_E_1,$F00
	dc.w	COULEUR_E_2,$F00,COULEUR_E_2,$F00,COULEUR_E_3,$F00,COULEUR_E_3,$0FFF

COULEUR_F_1 equ $00c0/2
COULEUR_F_2 equ $0c52/2
COULEUR_F_3 equ $0fff
Pal_SPRITE_F:	
	dc.w	$000,$F00,$F00,$F00,COULEUR_F_1,$F00,COULEUR_F_1,$F00
	dc.w	COULEUR_F_2,$F00,COULEUR_F_2,$F00,COULEUR_F_3,$F00,COULEUR_F_3,$0FFF

Pal_logo_RGC:
	dc.w	$0000,$0707,$0EEE,$0666,$0DD6,$055D,$0CC5,$0FFF
	dc.w	$0C4C,$04B4,$0B3B,$03AB,$0A23,$029A,$0912,$0FFF

fa equ -$0111
Pal_logo_RGC_fade:
	dc.w	$0001,$0707+fa,$0EEE+fa,$0666+fa,$0DD6+fa,$055D+fa,$0CC5+fa,$0FFF+fa
	dc.w	$0C4C+fa,$04B4+fa,$0B3B+fa,$03AB+fa,$0A23+fa,$029A+fa,$0912+fa,$0FFF

Pal_logo_Presents:
  DC.W $0000,$0334,$441,$663,$cc6,$0fff,$771,$771
  DC.W $aa4,$771,$771,$771,$cc6,$771,$771,$0777

Pal_logo_AC:
	dc.w	$0000,$0FFF,$0EEE,$0DDD,$0666,$0000,$0080,$0700
	dc.w	$0000,$0CB9,$0753,$0000,$0000,$0000,$0000,$0777

Pal_plogo_RGC:
	dc.w	$0081,$09A3,$0019,$03B4,$0FF7,$0A3B,$0FF7,$0B4C
	dc.w	$04CC,$0C55,$05DD,$0D66,$06EE,$0E77,$0892,$012A

aqa equ $0FFF
Pal_bubble:	
	dc.w	$0113,$050e,$040e,$030e,$060e,$0,$0,$0
	dc.w	aqa,aqa,aqa,aqa,$0,$0,$0,$0000

Pal_logo_noex:
	dc.w	$0100,$0000,$0400,$0410,$0529,$0520,$0632,$0743
	dc.w	$0753,$0447,$0223,$0800,$0666,$0777,$0300,$0042

Pal_ice:	
	dc.w	$0101,$0532,$0fff,$0754,$0447,$0700,$0400,$0200
	dc.w	$0003,$0114,$0225,$0336,$0222,$0444,$0666,$0643

Pal_plasma:	
	dc.w	$0010,$777,$0fff,$0,$0,$0,$0,$0
	dc.w	$0000,$0,$0100,$0,$0fff,$0,$0fff,$0

Pal_board:	
	dc.w	$0000,$0310,$0222,$03BB,$02AA,$0111,$0420,$0332
	dc.w	$0530,$0A33,$0666,$0750,$0FFF,$0119,$0750,$0199
	even

* Full data here :
* >

************ BARRE RASTER *************>
PAL_RAST:
	dcb.w	40,$0
 rept 15*5
	dc.w	$0700
	dc.w	$0710
	dc.w	$0720
	dc.w	$0730
	dc.w	$0740
	dc.w	$0750
	dc.w	$0760
	dc.w	$0770
	dc.w	$0670
	dc.w	$0570
	dc.w	$0470
	dc.w	$0370
	dc.w	$0270
	dc.w	$0170
	dc.w	$0070
	dc.w	$0071
	dc.w	$0075
	dc.w	$0076
	dc.w	$0077
	dc.w	$0067
	dc.w	$0057
	dc.w	$0047
	dc.w	$0037
	dc.w	$0027
	dc.w	$0017
	dc.w	$0007
	dc.w	$0107
	dc.w	$0207
	dc.w	$0307
	dc.w	$0407
	dc.w	$0507
	dc.w	$0607
	dc.w	$0707
	dc.w	$0706
	dc.w	$0705
	dc.w	$0704
	dc.w	$0703
	dc.w	$0702
	dc.w	$0701
 endr
	dcb.w	40,$0
************ BARRE RASTER *************<

************ MAP FRANCE *************>
mul_tab		DS.W 200
************ MAP FRANCE *************>

************ SCROLLING *************>
bufsource_ptr	DC.L 0
bufdest_ptr	DC.L 0
ovscr_point	DC.L ovtext
ovscx		DC.W 0
ovscrlpos	DC.W 0
ovscrlspeed	DC.W 4
ovthischar	DC.W 64,64
ovtext
;	dc.b " !",$22,"#$%&",$27,"()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 IFNE LANGUE_FR
	dc.b " L",$27,"ASSOCIATION RGC ORGANISE CETTE ANNEE UNE SPEED-CODING (PETIT JEU SUR UN THEME A REALISER). "
	dc.b "LE PRINCIPE DE CETTE CODING EST LA CREATION D",$27,"UN JEU SUR LA PLATEFORME DE VOTRE CHOIX ET SUR UN THEME PRECIS. "
	dc.b "                  "
 ENDC
 IFNE LANGUE_EN
	dc.b " RGC ASSOCIATION ORGANIZED THIS YEAR ONE-SPEED CODING (LITTLE GAME ON A THEME TO ACHIEVE). "
	dc.b "THE MAINLY PART OF CODING IS THE CREATION OF A GAME ON THE PLATFORM OF YOUR CHOICE AND ON A SPECIFIC TOPIC. "
	dc.b "                                  "
 ENDC
	DC.B $0
	EVEN
phfontbuf:
	incbin "\RGC\datas\ENIG161P.FNT"
	even
************ SCROLLING *************<

************ 3D EFFECT *************>
ballseqdata:
		DC.W 1
		DC.L ballsequence 
		DC.W 0,0,0
		DC.L ballrestart
ballsequence:
		DC.W 128/2,4,0,0,6
		DC.W 128/2-26,6,0,0,6
		DC.W 128,8,0,0,6
		DC.W 100,6,0,0,6
ballrestart:
		DC.W 128,8,2,2,6
		DC.W 128,8,4,4,6
		DC.W 128,8,6,6,6
		DC.W 128,8,8,8,6
		DC.W 128,6,8,8,6
		DC.W 128,4,8,6,6
		DC.W 128,4,8,6,6
		DC.W -1
frame_switch	DC.W 0
rndseed 	dc.l $446457456
angles		DC.W 512,0,0
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
************ 3D EFFECT *************<

************ TUBES RASTER *************>
COULEURS:
	dcb.w	72,$0010
	dc.w	$0020,$0831,$0142
	dc.w	$0020,$0831,$0142,$0253
	dc.w	$0020,$0831,$0142,$0253,$0364,$0475
	dc.w	$0020,$0831,$0142,$0253,$0364,$0475,$05F6
	dc.w	$0FE6
	dc.w	$0020,$0831,$0142,$0253,$0364,$0475,$05F6
	dc.w	$0FE6,$0FE6
	rept 2
	dc.w	$0020,$0831,$0142,$0253,$0364,$0475,$05F6
	dc.w	$0FE6,$0FE6,$0FF5
	endr
	dc.w	$0020,$0831,$0142,$0253,$0364,$0475,$05F6
	dc.w	$0FE6,$0FE6,$0FF5,$0774
; MILIEU ----------------->	
	dc.w	$0020,$0831,$0142,$0253,$0364,$0475,$05F6
	dc.w	$0FE6,$0FE6,$0FF5,$0774,$0663,$0552,$0441,$0330,$0220 
; MILIEU -----------------<
	rept 3
	dc.w	$0475,$05F6
	dc.w	$0FE6,$0FE6,$0FF5,$0774,$0663,$0552,$0441,$0330,$0220 
	endr
	dc.w	$0FE6,$0FE6,$0FF5,$0774,$0663,$0552,$0441,$0330,$0220 
	dc.w	$0FE6,$0FF5,$0774,$0663,$0552,$0441,$0330,$0220 
	dc.w	$0FF5,$0774,$0663,$0552,$0441,$0330,$0220 
	dc.w	$0774,$0663,$0552,$0441,$0330,$0220 
	dc.w	$0663,$0552,$0441,$0330,$0220 
	dc.w	$0552,$0441,$0330,$0220 
	dc.w	$0441,$0330,$0220,$0220
; NOIR
	dcb.w	88,$0110
	EVEN
FIN_COURBE:DC.W      $0 
COURBE:
	dc.w	$1416,$181A,$1C1E,$2022
	dc.w	$2426,$282A,$2C2E,$3032
	dc.w	$3436,$383A,$3C3E,$4042
	dc.w	$4444,$4444,$4444,$4444
	dc.w	$4444,$4444,$4446,$4646
	dc.w	$4646,$4646,$4648,$4848
	dc.w	$4848,$4848,$4848,$4848
	dc.w	$4848,$4848,$4846,$4646
	dc.w	$4646,$4444,$4444,$4242
	dc.w	$4240,$403E,$3E3E,$3C3C
	dc.w	$3C3A,$3A3A,$3838,$3838
	dc.w	$3636,$3636,$3636,$3636
	dc.w	$3636,$3636,$3636,$3838
	dc.w	$383A,$3A3C,$3C3E,$3E40
	dc.w	$4042,$4244,$4646,$484A
	dc.w	$4A4C,$4E4E,$5052,$5254
	dc.w	$5456,$5656,$5858,$585A
	dc.w	$5A5A,$5A5A,$5A5A,$5858
	dc.w	$5858,$5656,$5454,$5250
	dc.w	$504E,$4C4A,$4846,$4444
	dc.w	$4240,$3E3C,$3A38,$3634
	dc.w	$3230,$2E2E,$2C2A,$2A28
	dc.w	$2626,$2624,$2424,$2424
	dc.w	$2424,$2424,$2626,$2828
	dc.w	$2A2C,$2E2E,$3032,$3438
	dc.w	$3A3C,$3E40,$4246,$484A
	dc.w	$4E50,$5254,$565A,$5C5E
	dc.w	$6062,$6464,$6668,$686A
	dc.w	$6A6A,$6C6C,$6C6C,$6A6A
	dc.w	$6A68,$6866,$6462,$605E
	dc.w	$5C5A,$5854,$5250,$4C4A
	dc.w	$4644,$403C,$3A36,$3430
	dc.w	$2E2A,$2824,$2220,$1E1C
	dc.w	$1A18,$1614,$1412,$1212
	dc.w	$1212,$1212,$1414,$1616
	dc.w	$181A,$1C20,$2224,$282A
	dc.w	$2E30,$3438,$3C40,$4246
	dc.w	$4A4E,$5256,$5A5E,$6064
	dc.w	$666A,$6C70,$7274,$7678
	dc.w	$7A7C,$7C7C,$7E7E,$7E7E
	dc.w	$7C7C,$7A78,$7674,$7270
	dc.w	$6E6A,$6664,$605C,$5854
	dc.w	$504C,$4844,$3E3A,$3632
	dc.w	$2E28,$2420,$1C1A,$1612
	dc.w	$100C,$0A08,$0604,$0202
	dc.w	$0000,$0000,$0000,$0204
	dc.w	$0608,$0A0C,$1012,$161A
	dc.w	$1E22,$262A,$3034,$3A3E
	dc.w	$4448,$4C52,$565C,$6064
	dc.w	$686C,$7074,$767A,$7C7E
	dc.w	$8082,$8486,$8686,$8686
	dc.w	$8684,$8482,$807E,$7C7A
	dc.w	$7674,$706C,$6A66,$625E
	dc.w	$5854,$504C,$4844,$3E3A
	dc.w	$3632,$2E2A,$2622,$201C
	dc.w	$1816,$1412,$100E,$0C0A
	dc.w	$0A08,$0808,$080A,$0A0A
	dc.w	$0C0E,$1012,$1416,$1A1C
	dc.w	$2022,$2628,$2C30,$3438
	dc.w	$3C40,$4246,$4A4E,$5256
	dc.w	$585C,$5E62,$6466,$6A6C
	dc.w	$6E70,$7072,$7274,$7474
	dc.w	$7474,$7474,$7272,$706E
	dc.w	$6C6A,$6866,$6462,$5E5C
	dc.w	$5856,$5250,$4C4A,$4644
	dc.w	$403C,$3A36,$3432,$2E2C
	dc.w	$2A28,$2624,$2220,$1E1E
	dc.w	$1C1C,$1C1A,$1A1A,$1A1C
	dc.w	$1C1C,$1E1E,$2022,$2224
	dc.w	$2628,$2A2C,$3032,$3436
	dc.w	$383C,$3E40,$4246,$484A
	dc.w	$4C4E,$5254,$5658,$585A
	dc.w	$5C5E,$5E60,$6062,$6262
	dc.w	$6262,$6262,$6262,$6060
	dc.w	$605E,$5C5C,$5A58,$5856
	dc.w	$5452,$504E,$4C4A,$4846
	dc.w	$4444,$4240,$3E3C,$3A38
	dc.w	$3636,$3432,$3230,$302E
	dc.w	$2E2E,$2E2C,$2C2C,$2C2C
	dc.w	$2C2C,$2E2E,$2E30,$3030
	dc.w	$3232,$3434,$3638,$383A
	dc.w	$3C3C,$3E40,$4042,$4244
	dc.w	$4646,$4848,$4A4A,$4C4C
	dc.w	$4E4E,$4E50,$5050,$5050
	dc.w	$5050,$5050,$5050,$5050
	dc.w	$504E,$4E4E,$4E4C,$4C4C
	dc.w	$4A4A,$4A48,$4848,$4646
	dc.w	$4444,$4444,$4242,$4240
	dc.w	$4040,$4040,$3E3E,$3E3E
	dc.w	$3E3E,$3E3E,$3E3E,$3E3E
	dc.w	$3E3E,$3E3E,$4040,$4040
	dc.w	$4040,$4040,$4242,$4242
	dc.w	$4242,$4242,$4242,$4242
	dc.w	$4444,$4444,$4444
COMPTEUR:DC.W      $0028 
	even
************ TUBES RASTER *************<

************ TEXTES FUZION *************>
offset_tab:
	dc.b	8
	dc.b	0,1,8,16
	dc.b	0,1,4,8,16
	dc.b	0,1,4,8,12,16
	dc.b	0,1,2,4,8,12,16
	dc.b	0,1,2,4,8,12,14,16
	dc.b	0,1,2,4,6,8,12,14,16
	dc.b	0,1,2,4,6,8,10,12,14,16
	dc.b	0,1,2,3,4,6,8,10,12,14,16
	dc.b	0,1,2,3,4,6,8,10,12,14,15,16
	dc.b	0,1,2,3,4,5,6,8,10,12,14,15,16
	dc.b	0,1,2,3,4,5,6,8,10,12,13,14,15,16
	dc.b	0,1,2,3,4,5,6,7,8,10,12,13,14,15,16
	dc.b	0,1,2,3,4,5,6,7,8,10,11,12,13,14,15,16
	dc.b	0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
	dc.b	0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
	dc.b	0,127,0
present_spray_pattern	dc.l	1
max_spray_patterns	dc.l	9
pos_in_pattern	dc.l	spray_patterns
spray_patterns:
*1
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	;15 nulls
	dc.b	1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
	dc.b	40,60,80,100,120,140,160,180,200,199,198,197,196
	DC.B	$C3,$C2,$C1,$C0,$BF,$BE,$BD,$BC
	DC.B	$BB,$BA,$B9,$B8,$B7,$B6,$B5,$A1
	DC.B	$8D,$79,$65,$51,$3D,$29,$15,$16
	DC.B	$17,$18,$19,$1A,$1B,$1C,$1D,$1E
	DC.B	$1F,$20,$21,$22,$23,$24,$25,$26
	DC.B	$27,$3B,$4F,$63,$77,$8B,$9F,$B3
	DC.B	$B2,$B1,$B0,$AF,$AE,$AD,$AC,$AB
	DC.B	$AA,$A9,$A8,$A7,$A6,$A5,$A4,$A3
	DC.B	$A2,$8E,$7A,$66,$52,$3E,$2A,$2B
	DC.B	$2C,$2D,$2E,$2F,$30,$31,$32,$33
	DC.B	$34,$35,$36,$37,$38,$39,$3A,$4E
	DC.B	$62,$76,$8A,$9E,$9D,$9C,$9B,$9A
	DC.B	$99,$98,$97,$96,$95,$94,$93,$92
	DC.B	$91,$90,$8F,$7B,$67,$53,$3F,$40
	DC.B	$41,$42,$43,$44,$45,$46,$47,$48
	DC.B	$49,$4A,$4B,$4C,$4D,$61,$75,$89
	DC.B	$88,$87,$86,$85,$84,$83,$82,$81
	DC.B	$80,$7F,$7E,$7D,$7C,$68,$54,$55
	DC.B	$56,$57,$58,$59,$5A,$5B,$5C,$5D
	DC.B	$5E,$5F,$60,$74,$73,$72,$71,$70
	DC.B	$6F,$6E,$6D,$6C,$6B,$6A,$69,$C9
	DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	;end in 16 nulls
*2
 rept 6
	DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	DC.B	1,2,3,4,5,6,7,8,9,$A,$B,$C,$D,$E,$F,$10,$11
	DC.B	$12,$13,$14,$28,$27,$26,$25,$24
	DC.B	$23,$22,$21,$20,$1F,$1E,$1D,$1C
	DC.B	$1B,$1A,$19,$18,$17,$16,$15,$29
	DC.B	$2A,$2B,$2C,$2D,$2E,$2F,$30,$31
	DC.B	$32,$33,$34,$35,$36,$37,$38,$39
	DC.B	$3A,$3B,$3C,$50,$4F,$4E,$4D,$4C
	DC.B	$4B,$4A,$49,$48,$47,$46,$45,$44
	DC.B	$43,$42,$41,$40,$3F,$3E,$3D,$51
	DC.B	$52,$53,$54,$55,$56,$57,$58,$59
	DC.B	$5A,$5B,$5C,$5D,$5E,$5F,$60,$61
	DC.B	$62,$63,$64,$78,$77,$76,$75,$74
	DC.B	$73,$72,$71,$70,$6F,$6E,$6D,$6C
	DC.B	$6B,$6A,$69,$68,$67,$66,$65,$79
	DC.B	$7A,$7B,$7C,$7D,$7E,$7F,$80,$81
	DC.B	$82,$83,$84,$85,$86,$87,$88,$89
	DC.B	$8A,$8B,$8C,$A0,$9F,$9E,$9D,$9C
	DC.B	$9B,$9A,$99,$98,$97,$96,$95,$94
	DC.B	$93,$92,$91,$90,$8F,$8E,$8D,$A1
	DC.B	$A2,$A3,$A4,$A5,$A6,$A7,$A8,$A9
	DC.B	$AA,$AB,$AC,$AD,$AE,$AF,$B0,$B1
	DC.B	$B2,$B3,$B4,$C8,$C7,$C6,$C5,$C4
	DC.B	$C3,$C2,$C1,$C0,$BF,$BE,$BD,$BC
	DC.B	$BB,$BA,$B9,$B8,$B7,$B6,$B5,$C9
	DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 endr
*3
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	;15 null start
	dc.b	1,21,41,61,$51,$65,$79,$8D,$A1
	dc.b	$B5,$B6,$A2,$8E,$7A,$66,$52,$3E
	dc.b	$2A,$16,2,3,$17,$2B,$3F,$53
	dc.b	$67,$7B,$8F,$A3,$B7,$B8,$A4,$90
	DC.B	$7C,$68,$54,$40,$2C,$18,4,5
	DC.B	$19,$2D,$41,$55,$69,$7D,$91,$A5
	DC.B	$B9,$BA,$A6,$92,$7E,$6A,$56,$42
	DC.B	$2E,$1A,6,7,$1B,$2F,$43,$57
	DC.B	$6B,$7F,$93,$A7,$BB,$BC,$A8,$94
	DC.B	$80,$6C,$58,$44,$30,$1C,8,9
	DC.B	$1D,$31,$45,$59,$6D,$81,$95,$A9
	DC.B	$BD,$BE,$AA,$96,$82,$6E,$5A,$46
	DC.B	$32,$1E,$A,$B,$1F,$33,$47,$5B
	DC.B	$6F,$83,$97,$AB,$BF,$C0,$AC,$98
	DC.B	$84,$70,$5C,$48,$34,$20,$C,$D
	DC.B	$21,$35,$49,$5D,$71,$85,$99,$AD
	DC.B	$C1,$C2,$AE,$9A,$86,$72,$5E,$4A
	DC.B	$36,$22,$E,$F,$23,$37,$4B,$5F
	DC.B	$73,$87,$9B,$AF,$C3,$C4,$B0,$9C
	DC.B	$88,$74,$60,$4C,$38,$24,$10,$11
	DC.B	$25,$39,$4D,$61,$75,$89,$9D,$B1
	DC.B	$C5,$C6,$B2,$9E,$8A,$76,$62,$4E
	DC.B	$3A,$26,$12,$13,$27,$3B,$4F,$63
	DC.B	$77,$8B,$9F,$B3,$C7,$C8,$B4,$A0
	DC.B	$8C,$78,$64,$50,$3C,$28,$14,$C9
	DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
*9
	DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	DC.B	$b5,$A1,$B6,$B7,$A2,$8D,$79,$8E,$A3
	DC.B	$B8,$B9,$A4,$8F,$7A,$65,$51,$66
	DC.B	$7B,$90,$A5,$BA,$BB,$A6,$91,$7C
	DC.B	$67,$52,$3D,$29,$3E,$53,$68,$7D
	DC.B	$92,$A7,$BC,$BD,$A8,$93,$7E,$69
	DC.B	$54,$3F,$2A,$15,1,$16,$2B,$40
	DC.B	$55,$6A,$7F,$94,$A9,$BE,$BF,$AA
	DC.B	$95,$80,$6B,$56,$41,$2C,$17,2
	DC.B	3,$18,$2D,$42,$57,$6C,$81,$96
	DC.B	$AB,$C0,$C1,$AC,$97,$82,$6D,$58
	DC.B	$43,$2E,$19,4,5,$1A,$2F,$44
	DC.B	$59,$6E,$83,$98,$AD,$C2,$C3,$AE
	DC.B	$99,$84,$6F,$5A,$45,$30,$1B,6
	DC.B	7,$1C,$31,$46,$5B,$70,$85,$9A
	DC.B	$AF,$C4,$C5,$B0,$9B,$86,$71,$5C
	DC.B	$47,$32,$1D,8,9,$1E,$33,$48
	DC.B	$5D,$72,$87,$9C,$B1,$C6,$C7,$B2
	DC.B	$9D,$88,$73,$5E,$49,$34,$1F,$A
	DC.B	$B,$20,$35,$4A,$5F,$74,$89,$9E
	DC.B	$B3,$C8,$B4,$9F,$8A,$75,$60,$4B
	DC.B	$36,$21,$C,$D,$22,$37,$4C,$61
	DC.B	$76,$8B,$A0,$8C,$77,$62,$4D,$38
	DC.B	$23,$E,$F,$24,$39,$4E,$63,$78
	DC.B	$64,$4F,$3A,$25,$10,$11,$26,$3B
	DC.B	$50,$3C,$27,$12,$13,$28,$14,$C9
	DC.B	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
page_no		dc.l	1 
spray_ascii_pos	dc.l	spray_ascii 
no_pages	dc.l	10		;number of screens to spray
spray_ascii
 IFNE LANGUE_FR
* 1
      DC.B      'aaaaaaaaaaaaaaaaaaaa'
      DC.B      'a  16 ET 17 AVRIL  a'
      DC.B      'a                  a'
      DC.B      'a aaa  aaa   a   a a'
      DC.B      'a   a  a a  aa  aa a'
      DC.B      'a aaa  a a a a a a a'
      DC.B      'a a    a a   a   a a'
      DC.B      'a aaa  aaa   a   a a'
      DC.B      'a                  a'
      DC.B      'aaaaaaaaaaaaaaaaaaaa'
* 2
      DC.B      '````````````````````'
      DC.B      '` AC2011 AURA LIEU `'
      DC.B      '` LE 16 ET 17 AVRIL`'
      DC.B      '` 2011 A CONGIS EN `'
      DC.B      '` FRANCE (77440).  `'
      DC.B      '` VOUS POUVEZ VOUS `'
      DC.B      '` INSCRIRE SUR LE  `'
      DC.B      '` SITEWEB EN LIGNE `'
      DC.B      '` WWW.RETRO-GC.ORG `'
      DC.B      '````````````````````'
* 3
      DC.B      '   LE TEMPS D',$27,'UN    '
      DC.B      'WEEK-END ET DANS UNE'
      DC.B      'AMBIANCE CONVIVIALE,'
      DC.B      ' VOUS POURREZ VOUS  '
      DC.B      'RENCONTRER,DISCUTER,'
      DC.B      '  ECHANGER,VENDRE,  '
      DC.B      ' JOUER,CODER,AUTOUR '
      DC.B      'DE VIEILLES CONSOLES'
      DC.B      'ATARI,COMMODORE,MSX '
      DC.B      ' AMIGA,AMSTRAD,ETC. '
* 4
      DC.B      'PROGRAMME : CONCOURS'
      DC.B      'MEDIEVAL MAYHEM SUR '
      DC.B      '    ATARI 2600.     '
      DC.B      '  PRESENTATIONS DE  '
      DC.B      ' PROJETS (ESTRADE), '
      DC.B      ' FREEPLAY,ORGANISA- '
      DC.B      'TION D',$27,'UNE SPEED-CO '
      DC.B      'DING POUR LA REALI- '
      DC.B      '  SATION D',$27,'UN JEU   '
      DC.B      ' (VOIR NOTRE FORUM) '
* 5
      DC.B      'aaaaaaaaaaaaaaaaaaaa'
      DC.B      'a      OU CA ?     a'
      DC.B      'a                  a'
      DC.B      'a SALLE DES FETES  a'
      DC.B      'a DE CONGIS A COTE a'
      DC.B      'a   DE LA MAIRIE.  a'
      DC.B      'a 77440 CONGIS-SUR a'
      DC.B      'a   THEROUANNE EN  a'
      DC.B      'a      FRANCE.     a'
      DC.B      'aaaaaaaaaaaaaaaaaaaa'
* 6
      DC.B      'cccccccccccccccccccc'
      DC.B      'c   LES HORAIRES   c'
      DC.B      'c                  c'
      DC.B      'c    \ SAMEDI \    c'
      DC.B      'c10H00 JUSQUE TARD c'
      DC.B      'c( FERMETURE DE L',$27,' c'
      DC.B      'c ACCUEIL A 18H00 )c'
      DC.B      'c   \ DIMANCHE \   c'
      DC.B      'c   10H00 A 18H00  c'
      DC.B      'cccccccccccccccccccc'
* 7
      DC.B      'POUR VOUS INSCRIRE, '
      DC.B      'PASSEZ PAR LE SITE :'
      DC.B      '` WWW.RETRO-GC.ORG `'
      DC.B      '17 EUROS LES 2 JOURS'
      DC.B      '(11 EUROS LE SAMEDI,'
      DC.B      '9 EUROS LE DIMANCHE)'
      DC.B      'REPAS NON COMPRIS DA'
      DC.B      'NS LE PRIX D’ENTREE.'
      DC.B      'LIMITE DES INSCRIP- '
      DC.B      'TIONS : 8 AVRIL 2011'
* 8
      DC.B      'cccc ccccccccccccccc'
      DC.B      'ca c c    ]`   c\c`c'
      DC.B      'c  c c    []   c c c'
      DC.B      'c  c ccccccccccc c c'
      DC.B      'c  c             c[c'
      DC.B      'c  cccccccc cccccc c'
      DC.B      'c        bc c      c'
      DC.B      'c````     c c      c'
      DC.B      'c`^_`     c ca     c'
      DC.B      'ccccccccccc cccccccc'
* 9
      DC.B      '````````````````````'
      DC.B      '` INVI',$27,'TRO AC 2011 `'
      DC.B      '`POWERED BY NOEXTRA`'
      DC.B      '`                  `'
      DC.B      '`  ^_ ATOMUS   ^_  `'
      DC.B      '`  ^_ ZORRO 2  ^_  `'
      DC.B      '`  ^_ MISTER.A ^_  `'
      DC.B      '`  ^_ TOMCHI   ^_  `'
      DC.B      '`                  `'
      DC.B      '````````````````````'
 ENDC
 IFNE LANGUE_EN
* 1
      DC.B      'aaaaaaaaaaaaaaaaaaaa'
      DC.B      'a 16 AND 17 APRIL  a'
      DC.B      'a                  a'
      DC.B      'a aaa  aaa   a   a a'
      DC.B      'a   a  a a  aa  aa a'
      DC.B      'a aaa  a a a a a a a'
      DC.B      'a a    a a   a   a a'
      DC.B      'a aaa  aaa   a   a a'
      DC.B      'a                  a'
      DC.B      'aaaaaaaaaaaaaaaaaaaa'
* 2
      DC.B      '````````````````````'
      DC.B      '` AC 2011 WILL BE  `'
      DC.B      '` HELD ON 16 AND 17`'
      DC.B      '`  APRIL 2011 TO   `'
      DC.B      '` LEAVE IN FRANCE. `'
      DC.B      '` YOU CAN REGISTER `'
      DC.B      '` NOW ON OUR ONLINE`'
      DC.B      '`     WEBSITE AT   `'
      DC.B      '` WWW.RETRO-GC.ORG `'
      DC.B      '````````````````````'
* 3
      DC.B      'ON THE SHORT TIME OF'
      DC.B      'A WEEK-END,IN A COOL'
      DC.B      'VIBES,YOU COULD HAVE'
      DC.B      '  OPPORTUNITIES TO  '
      DC.B      ' MEET,DISCUSS,TRADE,'
      DC.B      ' SELL,BUY,PLAY,CODE '
      DC.B      ' AROUND THE AMIGA,  '
      DC.B      '   AMSTRAD,ATARI,   '
      DC.B      ' COMMODORE,MSX AND  '
      DC.B      'OLDSCHOOL PLATFORMS.'
* 4
      DC.B      ' PROGRAM : MEDIEVAL '
      DC.B      'CONTEST (ATARI 2600)'
      DC.B      'PRESENTATIONS OF PRO'
      DC.B      '-JECTS ON A PLATFORM'
      DC.B      '  FREEPLAY,VARIOUS  '
      DC.B      '  DEVELOPMENT AND   '
      DC.B      ' ORGANIZATION OF A  '
      DC.B      '  SPEED-CODING FOR  '
      DC.B      '   MAKING A GAME.   '
      DC.B      '  (SEE OUR FORUM)   '
* 5
      DC.B      'aaaaaaaaaaaaaaaaaaaa'
      DC.B      'a    WHERE IS ?    a'
      DC.B      'a                  a'
      DC.B      'aCONGIS HALL (NEXT a'
      DC.B      'a TO THE CITY HALL)a'
      DC.B      'a                  a'
      DC.B      'a 77440 CONGIS-SUR a'
      DC.B      'a  THEROUANNE IN   a'
      DC.B      'a      FRANCE.     a'
      DC.B      'aaaaaaaaaaaaaaaaaaaa'
* 6
      DC.B      'cccccccccccccccccccc'
      DC.B      'c      HOURS       c'
      DC.B      'c                  c'
      DC.B      'c   \ SATURDAY \   c'
      DC.B      'c 10:00 TILL LATE  c'
      DC.B      'c(CLOSING RECEP-   c'
      DC.B      'c   -TION AT 18:00)c'
      DC.B      'c    \ SUNDAY \    c'
      DC.B      'c10:00AM TO 6:00PM.c'
      DC.B      'cccccccccccccccccccc'
* 7
      DC.B      ' TO REGISTER, VISIT '
      DC.B      '   OUR WEBSITE AT   '
      DC.B      '` WWW.RETRO-GC.ORG `'
      DC.B      '  2 DAYS 17 EUROS   '
      DC.B      '(11 EUR ON SATURDAY,'
      DC.B      '  SUNDAY 9 EUROS).  '
      DC.B      ' MEALS NOT INCLUDED '
      DC.B      'IN THE PRICE OF ADM.'
      DC.B      '  DEADLINE FOR THE  '
      DC.B      '   APRIL 8, 2011.   '
* 8
      DC.B      'ccccccccccc cccccccc'
      DC.B      'c`^_`     c ca     c'
      DC.B      'c````     c c      c'
      DC.B      'c        bc c      c'
      DC.B      'c  cccccccc cccccc c'
      DC.B      'c  c             c[c'
      DC.B      'c  c ccccccccccc c c'
      DC.B      'c  c c    []   c c c'
      DC.B      'ca c c    ]`   c\c`c'
      DC.B      'cccc ccccccccccccccc'
* 9
      DC.B      '````````````````````'
      DC.B      '` INVI',$27,'TRO AC 2011 `'
      DC.B      '`POWERED BY NOEXTRA`'
      DC.B      '`                  `'
      DC.B      '`  ^_ ATOMUS   ^_  `'
      DC.B      '`  ^_ ZORRO 2  ^_  `'
      DC.B      '`  ^_ MISTER.A ^_  `'
      DC.B      '`  ^_ TOMCHI   ^_  `'
      DC.B      '`                  `'
      DC.B      '````````````````````'
 ENDC
	EVEN
usp_save	dc.l	0 	;keep in data seg not bss
clear_text_line_offset
	dc.l	160*160
	dc.l	161*160
stay_on_screen_timer	dc.w	65*2		;length of time text stays on screen
spray_count	dc.l	0
font_table	dc.l	0
timerb	dc.l	0
	dc.l	0
	dc.l	0
	dc.w	0
spray_pos	dcb.w	80,$0
font incbin "\RGC\datas\MED_FONT.DAT"
	even
************ TEXTES FUZION *************<

************ SCROLLTEXTES *************>
SCRBAC:	DS.B 66*15
	EVEN
TCOUNT:	DC.B 0
	EVEN
TEXT:	
	dc.b ' AMIGA - AMSTRAD - ATARI   '
	dc.b ' ACORN - ARCHIMEDE   '
 IFNE LANGUE_FR
	dc.b ' COMMODORE - MSX - OLDSCHOOL PLATEFORMES     '
 ENDC
 IFNE LANGUE_EN
	dc.b ' COMMODORE - MSX - OLDSCHOOL PLATEFORMS     '
 ENDC
	DC.B $FF
	EVEN
TPOS:	DC.L TEXT
FONT:
	INCBIN "\RGC\lz7\MEGAFONT.LZ7"
	EVEN
TAB1:DC.L      PTR_TAB1 
TAB2:DC.L      PTR_TAB2 
TAB3:DC.L      PTR_TAB3 
ADR_PALETTE:DCB.W     2,$0 
PTR_PALETTE:DCB.W     198,$0 
PTR_TAB1:
	dc.w	$0000,$0001,$0000,$0001
	dc.w	$0001,$0002,$0001,$0002
	dc.w	$0002,$0003,$0002,$0003
	dc.w	$0003,$0004,$0003,$0004
	dc.w	$0004,$0005,$0004,$0005
	dc.w	$0005,$0006,$0005,$0006
	dc.w	$0006,$0007,$0006,$0007
	dc.w	$0007,$0006,$0007,$0006
	dc.w	$0006,$0005,$0006,$0005
	dc.w	$0005,$0004,$0005,$0004
	dc.w	$0004,$0003,$0004,$0003
	dc.w	$0003,$0002,$0003,$0002
	dc.w	$0002,$0001,$0002,$0001
	dc.w	$0001,$0000,$0001,$0000
SUITE1:
	dc.w	$0000,$0001,$0000,$0001
	dc.w	$0001,$0002,$0001,$0002
	dc.w	$0002,$0003,$0002,$0003
	dc.w	$0003,$0004,$0003,$0004
	dc.w	$0004,$0005,$0004,$0005
	dc.w	$0005,$0006,$0005,$0006
	dc.w	$0006,$0007,$0006,$0007
	dc.w	$0007,$0006,$0007,$0006
	dc.w	$0006,$0005,$0006,$0005
	dc.w	$0005,$0004,$0005,$0004
	dc.w	$0004,$0003,$0004,$0003
	dc.w	$0003,$0002,$0003,$0002
	dc.w	$0002,$0001,$0002,$0001
	dc.w	$0001,$0000,$0001,$0000
	dc.w	$0000,$0001,$0000,$0001
	dc.w	$0001,$0002,$0001,$0002
	dc.w	$0002,$0003,$0002,$0003
	dc.w	$0003,$0004,$0003,$0004
	dc.w	$0004,$0005,$0004,$0005
	dc.w	$0005,$0006,$0005,$0006
	dc.w	$0006,$0007,$0006,$0007
	dc.w	$0007,$0006,$0007,$0006
	dc.w	$0006,$0005,$0006,$0005
	dc.w	$0005,$0004,$0005,$0004
	dc.w	$0004,$0003,$0004,$0003
	dc.w	$0003,$0002,$0003,$0002
	dc.w	$0002,$0001,$0002,$0001
	dc.w	$0001,$0000,$0001,$0000
	dc.w	$0000,$0001,$0000,$0001
	dc.w	$0001,$0002,$0001,$0002
	dc.w	$0002,$0003,$0002,$0003
	dc.w	$0003,$0004,$0003,$0004
	dc.w	$0004,$0005,$0004,$0005
	dc.w	$0005,$0006,$0005,$0006
	dc.w	$0006,$0007,$0006,$0007
	dc.w	$0007,$0006,$0007,$0006
	dc.w	$0006,$0005,$0006,$0005
	dc.w	$0005,$0004,$0005,$0004
	dc.w	$0004,$0003,$0004,$0003
	dc.w	$0003,$0002,$0003,$0002
	dc.w	$0002,$0001,$0002,$0001
	dc.w	$0001,$0000,$0001,$0000
	dc.w	$0000,$0001,$0000,$0001
	dc.w	$0001,$0002,$0001,$0002
	dc.w	$0002,$0003,$0002,$0003
	dc.w	$0003,$0004,$0003,$0004
	dc.w	$0004,$0005,$0004,$0005
	dc.w	$0005,$0006,$0005,$0006
	dc.w	$0006,$0007,$0006,$0007
	dc.w	$0007,$0006,$0007,$0006
	dc.w	$0006,$0005,$0006,$0005
	dc.w	$0005,$0004,$0005,$0004
	dc.w	$0004,$0003,$0004,$0003
	dc.w	$0003,$0002,$0003,$0002
	dc.w	$0002,$0001,$0002,$0001
	dc.w	$0001,$0000,$0001,$0000
PTR_TAB2:
	dc.w	$0000,$0010,$0000,$0010
	dc.w	$0010,$0020,$0010,$0020
	dc.w	$0020,$0030,$0020,$0030
	dc.w	$0030,$0040,$0030,$0040
	dc.w	$0040,$0050,$0040,$0050
	dc.w	$0050,$0060,$0050,$0060
	dc.w	$0060,$0070,$0060,$0070
	dc.w	$0070,$0060,$0070,$0060
	dc.w	$0060,$0050,$0060,$0050
	dc.w	$0050,$0040,$0050,$0040
	dc.w	$0040,$0030,$0040,$0030
	dc.w	$0030,$0020,$0030,$0020
	dc.w	$0020,$0010,$0020,$0010
	dc.w	$0010,$0000,$0010,$0000
	dcb.w	8,$0
SUITE2:
	dc.w	$0000,$0010,$0000,$0010
	dc.w	$0010,$0020,$0010,$0020
	dc.w	$0020,$0030,$0020,$0030
	dc.w	$0030,$0040,$0030,$0040
	dc.w	$0040,$0050,$0040,$0050
	dc.w	$0050,$0060,$0050,$0060
	dc.w	$0060,$0070,$0060,$0070
	dc.w	$0070,$0060,$0070,$0060
	dc.w	$0060,$0050,$0060,$0050
	dc.w	$0050,$0040,$0050,$0040
	dc.w	$0040,$0030,$0040,$0030
	dc.w	$0030,$0020,$0030,$0020
	dc.w	$0020,$0010,$0020,$0010
	dc.w	$0010,$0000,$0010,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0010,$0000,$0010
	dc.w	$0010,$0020,$0010,$0020
	dc.w	$0020,$0030,$0020,$0030
	dc.w	$0030,$0040,$0030,$0040
	dc.w	$0040,$0050,$0040,$0050
	dc.w	$0050,$0060,$0050,$0060
	dc.w	$0060,$0070,$0060,$0070
	dc.w	$0070,$0060,$0070,$0060
	dc.w	$0060,$0050,$0060,$0050
	dc.w	$0050,$0040,$0050,$0040
	dc.w	$0040,$0030,$0040,$0030
	dc.w	$0030,$0020,$0030,$0020
	dc.w	$0020,$0010,$0020,$0010
	dc.w	$0010,$0000,$0010,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0010,$0000,$0010
	dc.w	$0010,$0020,$0010,$0020
	dc.w	$0020,$0030,$0020,$0030
	dc.w	$0030,$0040,$0030,$0040
	dc.w	$0040,$0050,$0040,$0050
	dc.w	$0050,$0060,$0050,$0060
	dc.w	$0060,$0070,$0060,$0070
	dc.w	$0070,$0060,$0070,$0060
	dc.w	$0060,$0050,$0060,$0050
	dc.w	$0050,$0040,$0050,$0040
	dc.w	$0040,$0030,$0040,$0030
	dc.w	$0030,$0020,$0030,$0020
	dc.w	$0020,$0010,$0020,$0010
	dc.w	$0010,$0000,$0010,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0010,$0000,$0010
	dc.w	$0010,$0020,$0010,$0020
	dc.w	$0020,$0030,$0020,$0030
	dc.w	$0030,$0040,$0030,$0040
	dc.w	$0040,$0050,$0040,$0050
	dc.w	$0050,$0060,$0050,$0060
	dc.w	$0060,$0070,$0060,$0070
	dc.w	$0070,$0060,$0070,$0060
	dc.w	$0060,$0050,$0060,$0050
	dc.w	$0050,$0040,$0050,$0040
	dc.w	$0040,$0030,$0040,$0030
	dc.w	$0030,$0020,$0030,$0020
	dc.w	$0020,$0010,$0020,$0010
	dc.w	$0010,$0000,$0010,$0000
SUITE3:
	dc.w	$0000,$0100,$0000,$0100
	dc.w	$0100,$0200,$0100,$0200
	dc.w	$0200,$0300,$0200,$0300
	dc.w	$0300,$0400,$0300,$0400
	dc.w	$0400,$0500,$0400,$0500
	dc.w	$0500,$0600,$0500,$0600
	dc.w	$0600,$0700,$0600,$0700
	dc.w	$0700,$0600,$0700,$0600
	dc.w	$0600,$0500,$0600,$0500
	dc.w	$0500,$0400,$0500,$0400
	dc.w	$0400,$0300,$0400,$0300
	dc.w	$0300,$0200,$0300,$0200
	dc.w	$0200,$0100,$0200,$0100
	dc.w	$0100,$0000,$0100,$0000
	dcb.w	16,$0
PTR_TAB3:
	dc.w	$0000,$0100,$0000,$0100
	dc.w	$0100,$0200,$0100,$0200
	dc.w	$0200,$0300,$0200,$0300
	dc.w	$0300,$0400,$0300,$0400
	dc.w	$0400,$0500,$0400,$0500
	dc.w	$0500,$0600,$0500,$0600
	dc.w	$0600,$0700,$0600,$0700
	dc.w	$0700,$0600,$0700,$0600
	dc.w	$0600,$0500,$0600,$0500
	dc.w	$0500,$0400,$0500,$0400
	dc.w	$0400,$0300,$0400,$0300
	dc.w	$0300,$0200,$0300,$0200
	dc.w	$0200,$0100,$0200,$0100
	dc.w	$0100,$0000,$0100,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0100,$0000,$0100
	dc.w	$0100,$0200,$0100,$0200
	dc.w	$0200,$0300,$0200,$0300
	dc.w	$0300,$0400,$0300,$0400
	dc.w	$0400,$0500,$0400,$0500
	dc.w	$0500,$0600,$0500,$0600
	dc.w	$0600,$0700,$0600,$0700
	dc.w	$0700,$0600,$0700,$0600
	dc.w	$0600,$0500,$0600,$0500
	dc.w	$0500,$0400,$0500,$0400
	dc.w	$0400,$0300,$0400,$0300
	dc.w	$0300,$0200,$0300,$0200
	dc.w	$0200,$0100,$0200,$0100
	dc.w	$0100,$0000,$0100,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0100,$0000,$0100
	dc.w	$0100,$0200,$0100,$0200
	dc.w	$0200,$0300,$0200,$0300
	dc.w	$0300,$0400,$0300,$0400
	dc.w	$0400,$0500,$0400,$0500
	dc.w	$0500,$0600,$0500,$0600
	dc.w	$0600,$0700,$0600,$0700
	dc.w	$0700,$0600,$0700,$0600
	dc.w	$0600,$0500,$0600,$0500
	dc.w	$0500,$0400,$0500,$0400
	dc.w	$0400,$0300,$0400,$0300
	dc.w	$0300,$0200,$0300,$0200
	dc.w	$0200,$0100,$0200,$0100
	dc.w	$0100,$0000,$0100,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0100,$0000,$0100
	dc.w	$0100,$0200,$0100,$0200
	dc.w	$0200,$0300,$0200,$0300
	dc.w	$0300,$0400,$0300,$0400
	dc.w	$0400,$0500,$0400,$0500
	dc.w	$0500,$0600,$0500,$0600
	dc.w	$0600,$0700,$0600,$0700
	dc.w	$0700,$0600,$0700,$0600
	dc.w	$0600,$0500,$0600,$0500
	dc.w	$0500,$0400,$0500,$0400
	dc.w	$0400,$0300,$0400,$0300
	dc.w	$0300,$0200,$0300,$0200
	dc.w	$0200,$0100,$0200,$0100
	dc.w	$0100,$0000,$0100,$0000
************ SCROLLTEXTES *************<

************ INVADER SCREEN *************>
cubes:	incbin	"\RGC\datas\CUBES.BIN"
fincubes:
	even
*
MINIFONTE_PTR
	dc.w	0
BIGFONTE:
	incbin	"\RGC\datas\FONT88F.DAT"
	even
MINIFONTE:
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$1818,$1818,$0018,$1800
	dc.w	$6666,$CC00,$0000,$0000
	dc.w	$6CFE,$6C6C,$FE6C,$0000
	dc.w	$3C50,$3814,$7810,$0000
	dc.w	$0064,$6810,$2C4C,$0000
	dc.w	$386C,$3870,$DECC,$7600
	dc.w	$1818,$3000,$0000,$0000
	dc.w	$1830,$3030,$3030,$1800
	dc.w	$3018,$1818,$1818,$3000
	dc.w	$9254,$38FE,$3854,$9200
	dc.w	$0010,$107C,$1010,$0000
	dc.w	$0000,$0000,$1818,$3000
	dc.w	$0000,$00FC,$0000,$0000
	dc.w	$0000,$0000,$0018,$1800
	dc.w	$1010,$1818,$1818,$1800
	dc.w	$7C44,$64D6,$CEC6,$FE00
	dc.w	$1838,$0818,$1818,$1800
	dc.w	$7C44,$04FC,$C0C6,$FE00
	dc.w	$3C24,$041E,$0646,$7E00
	dc.w	$8888,$88FC,$0C0C,$0C00
	dc.w	$FCCC,$C0FC,$0CCC,$FC00
	dc.w	$7C4C,$40FE,$C6C6,$FE00
	dc.w	$FCC4,$0C18,$3030,$3000
	dc.w	$7C44,$44FE,$C6C6,$FE00
	dc.w	$F888,$88FC,$0C0C,$0C00
	dc.w	$0030,$3000,$3030,$0000
	dc.w	$0030,$3000,$3030,$6000
	dc.w	$0018,$3060,$3018,$0000
	dc.w	$00FC,$0000,$FC00,$0000
	dc.w	$0030,$180C,$1830,$0000
	dc.w	$78CC,$0C18,$3000,$3000
	dc.w	$3844,$5C58,$403C,$0000
	dc.w	$7C44,$44FE,$C6E6,$E600
	dc.w	$FC84,$C4FE,$C6C6,$FE00
	dc.w	$7C44,$44C0,$C6C6,$FE00
	dc.w	$FCC4,$C4C6,$C6C6,$FE00
	dc.w	$7E46,$40F0,$C0C6,$FE00
	dc.w	$7E46,$40F0,$C0C0,$C000
	dc.w	$7C44,$44C0,$CEC6,$FE00
	dc.w	$4444,$44FE,$C6C6,$C600
	dc.w	$0808,$0818,$1818,$1800
	dc.w	$0404,$0406,$C6C6,$FE00
	dc.w	$C8C8,$C8FE,$C6C6,$C600
	dc.w	$4040,$40C0,$C6C6,$FE00
	dc.w	$7C44,$44D6,$D6D6,$C600
	dc.w	$6474,$5CCE,$C6C6,$C600
	dc.w	$7C44,$44C6,$C6C6,$FE00
	dc.w	$7E42,$42FE,$C0C0,$C000
	dc.w	$7C4C,$4CC6,$C6FE,$FE00
	dc.w	$7E42,$42FE,$CCC6,$C600
	dc.w	$7C44,$407E,$06C6,$FE00
	dc.w	$FED6,$1010,$3030,$3000
	dc.w	$4444,$44C6,$C6C6,$FE00
	dc.w	$2222,$2262,$666C,$7800
	dc.w	$C6D6,$D6D6,$4444,$7C00
	dc.w	$4444,$6C38,$EEC6,$C600
	dc.w	$4646,$C6FE,$1010,$1000
	dc.w	$FECE,$1C38,$70FE,$FE00
	dcb.w	76,$0
MTEXTE1:	;	Ecran STAR avec Carré
 IFNE LANGUE_FR
	DC.B      'L',$27,'ASSOCIATION RGC ORGANISE LA 6EME',$72
	DC.B      'EDITION DE L',$27,'AC LES 16 ET 17 AVRIL A',$72
	DC.B      'CONGIS (FRANCE). IL S',$27,'AGIT D',$27,'UN ',$72
  DC.B      'RASSEMBLEMENT AUTOUR DES MARQUES ATARI -',$72
	DC.B      'COMMODORE - AMIGA - AMSTRAD ET MSX.',$72
	DC.B      'AU PROGRAMME : CONCOURS MEDIEVAL MAYHEM',$72
	DC.B      '(ATARI 2600), PRESENTATIONS DE PROJETS',$72
	DC.B      'SUR L',$27,'ESTRADE, FREEPLAY, DEVELOPPEMENT',$72
	DC.B      'DIVERS ET ORGANISATION D',$27,'UNE SPEED-',$72
	DC.B      'CODING POUR LA REALISATION D',$27,'UN JEU',$72
	DC.B      '(VOIR NOTRE FORUM). L',$27,'AC EST UNE',$72
	DC.B      'CONVENTION CONVIVIALE RASSEMBLANT',$72
	DC.B      'ENVIRONS 70 PERSONNES SUR UN WEEK-END.',$72
	DC.B      $0
 ENDC
 IFNE LANGUE_EN
	DC.B      'THE RETRO GAMING CONNEXION ASSOCIATION',$72
	DC.B      'ORGANIZE THE 6TH EDITION OF AC MEETING',$72
	DC.B      '16 AND 17 APRIL 2011 AT CONGIS (FRANCE).',$72
  DC.B      'IT IS A GATHERING AROUND THE BRAND ATARI',$72
	DC.B      '- COMMODORE - AMIGA - AMSTRAD ET MSX.',$72
	DC.B      'PROGRAM : MEDIEVAL MAYHEM CONTEST (ATARI',$72
	DC.B      '2600), PRESENTATIONS OF PROJECTS ON THE',$72
	DC.B      'PLATFORM, FREEPLAY, VARIOUS DEVELOPMENT AND',$72
	DC.B      'ORGANIZATION OF SPEED-CODING FOR MAKING',$72
	DC.B      'A GAME. (SEE OUR FORUM)',$72
	DC.B      'THE AC IS A FRIENDLY CONVENTION ATTENDED',$72
	DC.B      'BY APPROXIMATELY 70 PEOPLE ON A WEEKEND.',$72
	DC.B      $0
 ENDC
 	EVEN
MTEXTE2:	;	Ecran STAR avec Carré
 IFNE LANGUE_FR
	DC.B      'L',$27,'ASSOCIATION RETRO-GAMING CONNEXION:',$72
	DC.B      'CETTE ASSOCIATION DE LOI 1901 DONT LE',$72
	DC.B      'BUT EST DE PROMOUVOIR ET SAUVEGARDER',$72
  DC.B      'LE PATRIMOINE VIDEOLUDIQUE AINSI QUE',$72
	DC.B      'METTRE EN RELATION LES UTILISATEURS,',$72
	DC.B      'A ETE CREEE EN 2005 PAR SIX PASSIONNES',$72
	DC.B      'DE CULTURE VIDEOLUDIQUE AUX ORIGINES',$72
	DC.B      'DIVERSES. L',$27,'ASSO S',$27,'EST FAIT CONNAITRE',$72
	DC.B      'POUR ORGANISER LA ',$22,'JAGUAR CONNEXION',$22,$72
	DC.B      '(QUI A CONNU CINQ EDITIONS) PUIS L',$27,'AC ET',$72
	DC.B      'LA RETRO-GAMING CONNEXION. CES DEUX ',$72
	DC.B      'DERNIERES CONVENTIONS SE SONT RAPIDEMENT',$72
	DC.B      'IMPOSEES COMME DES REFERENCES DU GENRE.',$72
	DC.B      $0
 ENDC
 IFNE LANGUE_EN
	DC.B      'THE ASSOCIATION RETRO-GAMING CONNEXION :',$72
	DC.B      'THIS ASSOCIATION OF LAW 1901, WHICH AIMS',$72
	DC.B      'TO PROMOTE AND SAFEGUARD THE HERITAGE AND',$72
  DC.B      'GAMING TO CONNECT USERS, WAS CREATED',$72
	DC.B      'IN 2005 BY SIX VIDEOGAME CULTURE',$72
	DC.B      'ENTHUSIASTS WITH DIVERSE ORIGINS.',$72
	DC.B      'THE ASSOCIATION HAS BECOME KNOWN FOR',$72
	DC.B      'ORGANIZING THE ',$22,'JAGUAR CONNECTION',$22,$72
	DC.B      '(WHICH WENT THROUGH FIVE EDITIONS) AND',$72
	DC.B      'THE AC AND THE RETRO-GAMING CONNEXION.',$72
	DC.B      'THESE TWO RECENT CONVENTIONS HAVE',$72
	DC.B      'QUICKLY EMERGED AS REFERENCES OF',$72
	DC.B      'THE GENRE.',$72
	DC.B      $0
 ENDC
	EVEN
MTEXTE3:	;	Ecran Plasma
 IFNE LANGUE_FR
	DC.B      $72
	DC.B      ' MEMBRES ET ORGANISATEURS:',$72
	DC.B      $72
	DC.B      '         * ARETHIUS',$72
	DC.B      '         * ICEMAN',$72
	DC.B      '         * ODIE_ONE',$72
	DC.B      '         * PTIT',$27,'BAMBOU',$72
	DC.B      '         * XIRIUS_THIR',$72
	DC.B      $72
	DC.B      ' MEMBRES ACTIFS:',$72
	DC.B      $72
	DC.B      '         * FEI',$72
	DC.B      '         * JEFFREY',$72
	DC.B      '         * NTRS',$72
	DC.B      '         * SUPAFLOW',$72
	DC.B      '         * X3L',$72
	DC.B      $0
 ENDC
 IFNE LANGUE_EN
	DC.B      $72
	DC.B      ' MEMBERS AND ORGANIZERS:',$72
	DC.B      $72
	DC.B      '         * ARETHIUS',$72
	DC.B      '         * ICEMAN',$72
	DC.B      '         * ODIE_ONE',$72
	DC.B      '         * PTIT',$27,'BAMBOU',$72
	DC.B      '         * XIRIUS_THIR',$72
	DC.B      $72
	DC.B      ' ACTIVE MEMBERS:',$72
	DC.B      $72
	DC.B      '         * FEI',$72
	DC.B      '         * JEFFREY',$72
	DC.B      '         * NTRS',$72
	DC.B      '         * SUPAFLOW',$72
	DC.B      '         * X3L',$72
	DC.B      $0
 ENDC
 EVEN
************ INVADER SCREEN *************<

************ SEA EFFECT *************>
sea_wave_pointer:
	dc.l	sea_waves
sea_waves:
	dc.w	160
	dc.w	160
	dc.w	160
	dc.w	320
	dc.w	320
	dc.w	480
	dc.w	480
	dc.w	480
	dc.w	480
	dc.w	320
	dc.w	320
	dc.w	320
	dc.w	320
	dc.w	160
	dc.w	160
	dc.w	160
	dc.w	0
	dc.w	0
	dc.w	160
	dc.w	160
	dc.w	160
	dc.w	160
	dc.w	160
	dc.w	320
	dc.w	320
	dc.w	320
	dc.w	320
	dc.w	320
	dc.w	320
	dc.w	480
	dc.w	480
	dc.w	480
	dc.w	480
	dc.w	480
	dc.w	640
	dc.w	640
	dc.w	640
	dc.w	480
	dc.w	480
	dc.w	480
	dc.w	480
	dc.w	320
	dc.w	320
	dc.w	320
	dc.w	320
	dc.w	160
	dc.w	160
	dc.w	160
	dc.w	160
	dc.w	160
	dc.w	320
	dc.w	320
	dc.w	320
	dc.w	160
	dc.w	160
	dc.w	160
	dc.w	320
	dc.w	320
	dc.w	320
	dc.w	320
	dc.w	160
	dc.w	160
	dc.w	320
	dc.w	320
	dc.w	320
	dc.w	160
	dc.w	160
	dc.w	160
	dc.w	160
	dc.w	160
	dc.w	320
	dc.w	320
	dc.w	320
	dc.w	480
	dc.w	480
	dc.w	480
	dc.w	480
	dc.w	480
	dc.w	320
	dc.w	320
	dc.w	320
	dc.w	320
	dc.w	320
	dc.w	160
	dc.w	160
	dc.w	160
	dc.w	320
	dc.w	320
	dc.w	480
	dc.w	480
	dc.w	480
	dc.w	480
	dc.w	320
	dc.w	320
	dc.w	320
	dc.w	320
	dc.w	160
	dc.w	160
	dc.w	160
	dc.w	0
	dc.w	0
	dc.w	160
	dc.w	160
	dc.w	160
	dc.w	160
	dc.w	160
	dc.w	320
	dc.w	320
	dc.w	320
	dc.w	320
	dc.w	320
	dc.w	320
	dc.w	-1
	even	
************ SEA EFFECT *************<

************ SPRITE 16*16 *************>
adr_sprite_M:
	incbin	"\RGC\datas\SPRITE_M.DAT"
	even
adr_sprite_E:
	incbin	"\RGC\datas\SPRITE_E.DAT"
	even
adr_sprite_F:
	incbin	"\RGC\datas\SPRITE_F.DAT"
	even
first_ptr	dc.w	0
second_ptr	dc.w	0
first_path	incbin	"\RGC\datas\FIRST.PTH"
second_path	incbin	"\RGC\datas\SECOND.PTH"
	even
************ SPRITE 16*16 *************<

************ RASTERS *************>
COMPTEUR_COULEUR:DC.W      $0
COULEUR:dc.w	$0101,$0000,$0101,$0101
	dc.w	$0212,$0101,$0212,$0212
	dc.w	$0323,$0212,$0323,$0323
	dc.w	$0434,$0323,$0434,$0434
	dc.w	$0545,$0434,$0545,$0545
	dc.w	$0656,$0545,$0656,$0656
	dc.w	$0767,$0656,$0767,$0767
	dc.w	$0656,$0767,$0656,$0656
	dc.w	$0545,$0656,$0545,$0545
	dc.w	$0434,$0545,$0434,$0434
	dc.w	$0323,$0434,$0323,$0323
	dc.w	$0212,$0323,$0212,$0212
	dc.w	$0101,$0212,$0101,$0101
	dc.w	$0000,$0101,$0101,$0000
	dc.w	$0101,$0101,$0212,$0101
	dc.w	$0212,$0212,$0323,$0212
	dc.w	$0323,$0323,$0434,$0323
	dc.w	$0434,$0434,$0545,$0434
	dc.w	$0545,$0545,$0656,$0545
	dc.w	$0656,$0656,$0767,$0656
	dc.w	$0767,$0767,$0656,$0767
	dc.w	$0656,$0656,$0545,$0656
	dc.w	$0545,$0545,$0434,$0545
	dc.w	$0434,$0434,$0323,$0434
	dc.w	$0323,$0323,$0212,$0323
	dc.w	$0212,$0212,$0101,$0212
	dc.w	$0101,$0101,$0000,$0101
	dcb.w	115,$0
	dc.w	$0000,$0000,$0000,$0010
	dc.w	$0000,$0010,$0010,$0121
	dc.w	$0010,$0121,$0121,$0232
	dc.w	$0121,$0232,$0232,$0343
	dc.w	$0232,$0343,$0343,$0454
	dc.w	$0343,$0454,$0454,$0565
	dc.w	$0454,$0565,$0565,$0676
	dc.w	$0565,$0676,$0676,$0565
	dc.w	$0676,$0565,$0565,$0454
	dc.w	$0565,$0454,$0454,$0343
	dc.w	$0454,$0343,$0343,$0232
	dc.w	$0343,$0232,$0232,$0121
	dc.w	$0232,$0121,$0121,$0010
	dc.w	$0121,$0010,$0010,$0000
	dc.w	$0010,$0000,$0000,$0000
	dcb.w	120,$0
************ RASTERS *************<

************ PLASMA *************>
PARAM_RASTER:
	dc.w	3,1,2-1,3+2
	dc.w	4-3,2,0,1
	dc.w	0,0,0,10
	dc.w	8,4,1,9999
PALETTE512: ; 4*32 = 128
	dc.w	256,256,260,264
	dc.w	268,268,272,276
	dc.w	280,284,284,288
	dc.w	292,296,296,300
	dc.w	304,308,312,312
	dc.w	316,320,324,324
	dc.w	328,332,336,336
	dc.w	340,344,348,348
	dc.w	352,356,356,360
	dc.w	364,368,368,372
	dc.w	376,376,380,384
	dc.w	384,388,392,392
	dc.w	396,400,400,404
	dc.w	408,408,412,412
	dc.w	416,420,420,424
	dc.w	424,428,432,432
	dc.w	436,436,440,440
	dc.w	444,444,448,448
	dc.w	452,452,456,456
	dc.w	460,460,464,464
	dc.w	468,468,472,472
	dc.w	472,476,476,480
	dc.w	480,480,484,484
	dc.w	484,488,488,488
	dc.w	492,492,492,492
	dc.w	496,496,496,500
	dc.w	500,500,500,500
	dc.w	504,504,504,504
	dc.w	504,504,508,508
	dc.w	508,508,508,508
	dc.w	508,508,508,508
	dc.w	508,508,508,508
	dcb.w	2000,$0
************ PLASMA *************<

************ SCREEN END *************>
scrn_offset: dc.w 0 ; Effet tremblement
wave:	dc.l	1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,3,4,5,5,7,8,9
		dc.l	-1
	even
************ SCREEN END *************<

************************************************
*          IMAGES NEOCHROME MASTER             *
*                by Mister.A                   *
************************************************
IMG_LOGO_RGC: ; 320*128
	incbin	"\RGC\lz7\LOGO_RGC.LZ7"
	even
IMG_PRESENT: ; 320*19
	incbin	"\RGC\images\PRESENT.IMG"
	even
IMG_AC: ; 320*200
	incbin	"\RGC\lz7\AC.LZ7"
	even
P_LOGO_RGC: ; 320*128
	incbin	"\RGC\images\P_LOGO.IMG"
	even
IMG_DRD: ; 320*176
	incbin	"\RGC\lz7\DRD.LZ7"
	even
NOEXTRA_LOGO: ; 320*77
	incbin	"\RGC\lz7\NOEXTRA.LZ7"
	even
SONIC:
	incbin	"\RGC\lz7\SONIC.LZ7"
	even
IMG_BOARD: ;	320*200
	incbin	"\RGC\lz7\BOARD.LZ7"
	even
TEXTEP: ;	320*6
	incbin "\RGC\datas\TEXTEP.DAT"
	even
* <

************************************************
*             MAXIMYSER SOUNDCHIP              *
*                  by TomChi                   *
************************************************
MUSIC_SNDH:
	incbin	"\RGC\music\RGCSTEEM.LZ7"
	even

* 3d
xang	dc.w	0
yang	dc.w	0
zang	dc.w	0
sintab	dc.w	0,201,402,603,803,1004,1205,1405,1605
	dc.w	1805,2005,2204,2404,2602,2801,2998,3196,3393
	dc.w	3589,3785,3980,4175,4369,4563,4756,4948,5139
	dc.w	5329,5519,5708,5896,6083,6269,6455,6639,6822
	dc.w	7005,7186,7366,7545,7723,7900,8075,8249,8423
	dc.w	8594,8765,8934,9102,9268,9434,9597,9759,9920
	dc.w	10079,10237,10393,10548,10701,10853,11002,11150,11297
	dc.w	11442,11585,11726,11866,12003,12139,12273,12406,12536
	dc.w	12665,12791,12916,13038,13159,13278,13395,13510,13622
	dc.w	13733,13842,13948,14053,14155,14255,14353,14449,14543
	dc.w	14634,14723,14810,14895,14978,15058,15136,15212,15286
	dc.w	15357,15426,15492,15557,15618,15678,15735,15790,15842
	dc.w	15892,15940,15985,16028,16069,16107,16142,16175,16206
	dc.w	16234,16260,16284,16305,16323,16339,16353,16364,16372
	dc.w	16379,16382,16384,16382,16379,16372,16364,16353,16339
	dc.w	16323,16305,16284,16260,16234,16206,16175,16142,16107
	dc.w	16069,16028,15985,15940,15892,15842,15790,15735,15678
	dc.w	15618,15557,15492,15426,15357,15286,15212,15136,15058
	dc.w	14978,14895,14810,14723,14634,14543,14449,14353,14255
	dc.w	14155,14053,13948,13842,13733,13622,13510,13395,13278
	dc.w	13159,13038,12916,12791,12665,12536,12406,12273,12139
	dc.w	12003,11866,11726,11585,11442,11297,11150,11002,10853
	dc.w	10701,10548,10393,10237,10079,9920,9759,9597,9434
	dc.w	9268,9102,8934,8765,8594,8423,8249,8075,7900
	dc.w	7723,7545,7366,7186,7005,6822,6639,6455,6269
	dc.w	6083,5896,5708,5519,5329,5139,4948,4756,4563
	dc.w	4369,4175,3980,3785,3589,3393,3196,2998,2801
	dc.w	2602,2404,2204,2005,1805,1605,1405,1205,1004
	dc.w	803,603,402,201,0,-202,-403,-604,-804
	dc.w	-1005,-1206,-1406,-1606,-1806,-2006,-2205,-2405,-2603
	dc.w	-2802,-2999,-3197,-3394,-3590,-3786,-3981,-4176,-4370
	dc.w	-4564,-4757,-4949,-5140,-5330,-5520,-5709,-5897,-6084
	dc.w	-6270,-6456,-6640,-6823,-7006,-7187,-7367,-7546,-7724
	dc.w	-7901,-8076,-8250,-8424,-8595,-8766,-8935,-9103,-9269
	dc.w	-9435,-9598,-9760,-9921,-10080,-10238,-10394,-10549,-10702
	dc.w	-10854,-11003,-11151,-11298,-11443,-11586,-11727,-11867,-12004
	dc.w	-12140,-12274,-12407,-12537,-12666,-12792,-12917,-13039,-13160
	dc.w	-13279,-13396,-13511,-13623,-13734,-13843,-13949,-14054,-14156
	dc.w	-14256,-14354,-14450,-14544,-14635,-14724,-14811,-14896,-14979
	dc.w	-15059,-15137,-15213,-15287,-15358,-15427,-15493,-15558,-15619
	dc.w	-15679,-15736,-15791,-15843,-15893,-15941,-15986,-16029,-16070
	dc.w	-16108,-16143,-16176,-16207,-16235,-16261,-16285,-16306,-16324
	dc.w	-16340,-16354,-16365,-16373,-16380,-16383,-16384,-16383,-16380
	dc.w	-16373,-16365,-16354,-16340,-16324,-16306,-16285,-16261,-16235
	dc.w	-16207,-16176,-16143,-16108,-16070,-16029,-15986,-15941,-15893
	dc.w	-15843,-15791,-15736,-15679,-15619,-15558,-15493,-15427,-15358
	dc.w	-15287,-15213,-15137,-15059,-14979,-14896,-14811,-14724,-14635
	dc.w	-14544,-14450,-14354,-14256,-14156,-14054,-13949,-13843,-13734
	dc.w	-13623,-13511,-13396,-13279,-13160,-13039,-12917,-12792,-12666
	dc.w	-12537,-12407,-12274,-12140,-12004,-11867,-11727,-11586,-11443
	dc.w	-11298,-11151,-11003,-10854,-10702,-10549,-10394,-10238,-10080
	dc.w	-9921,-9760,-9598,-9435,-9269,-9103,-8935,-8766,-8595
	dc.w	-8424,-8250,-8076,-7901,-7724,-7546,-7367,-7187,-7006
	dc.w	-6823,-6640,-6456,-6270,-6084,-5897,-5709,-5520,-5330
	dc.w	-5140,-4949,-4757,-4564,-4370,-4176,-3981,-3786,-3590
	dc.w	-3394,-3197,-2999,-2802,-2603,-2405,-2205,-2006,-1806
	dc.w	-1606,-1406,-1206,-1005,-804,-604,-403,-202,0
	dc.w	201,402,603,803,1004,1205,1405,1605,1805
	dc.w	2005,2204,2404,2602,2801,2998,3196,3393,3589
	dc.w	3785,3980,4175,4369,4563,4756,4948,5139,5329
	dc.w	5519,5708,5896,6083,6269,6455,6639,6822,7005
	dc.w	7186,7366,7545,7723,7900,8075,8249,8423,8594
	dc.w	8765,8934,9102,9268,9434,9597,9759,9920,10079
	dc.w	10237,10393,10548,10701,10853,11002,11150,11297,11442
	dc.w	11585,11726,11866,12003,12139,12273,12406,12536,12665
	dc.w	12791,12916,13038,13159,13278,13395,13510,13622,13733
	dc.w	13842,13948,14053,14155,14255,14353,14449,14543,14634
	dc.w	14723,14810,14895,14978,15058,15136,15212,15286,15357
	dc.w	15426,15492,15557,15618,15678,15735,15790,15842,15892
	dc.w	15940,15985,16028,16069,16107,16142,16175,16206,16234
	dc.w	16260,16284,16305,16323,16339,16353,16364,16372,16379
	dc.w	16382,16384
 EVEN
coeff	dc.w	250
delta	equ	100
coords	
	dc.w	-delta,-delta,delta,delta
	dc.w	-delta,delta,delta,delta
	dc.w	delta,-delta,delta,delta
	dc.w	-delta,-delta,-delta,delta
	dc.w	-delta,-delta,delta,delta
	dc.w	-delta,-delta,delta,-delta
variabler
	dc.l	0
hoppa	dc.l	0
parameters
	dc.w	0
	dc.l	buffert
	dc.l	Zorro_scr1
	dc.w	0,0,-1000
	dc.w	319,199,1000
polygon_mupp	*	Routine 3D d'OMEGA
	incbin	"\RGC\bin\POLY.BIN"
 EVEN
* <

******************************************************************
	SECTION	BSS
******************************************************************

bss_start:

* 3D
nothing ds.l	4096
buffert	ds.l	131*256
        ds.l	8
newco	  ds.l	1000
phscbuffer	
		REPT 16
		DS.B phbufsize
		ENDR
		DS.W 8
*
masks		DS.W 32*20
stars 		DS.W no_strs*3
*
PTR_BUFFER:DS.L      1 
	DS.B      60
BUFFER:DS.B      48000 
*
BUFFER_TEXTE:DS.B      149760
*
ball_off	ds.w	1
ball_addrs	ds.w	(MAX_BALLS*2)
*
TAS_R:	DS.B	2048
TIMING_RASTER:	DS.W	1
CURSOR_R1:	DS.W	1
CURSOR_R2:	DS.W	1
BUFFER_R2:	DS.B	2048
BUFFER_R3:	DS.B	2048
BUFFER_R4:	DS.B	8192
BUFFER_R1:	DS.B	69376

************ TEXTES FUZION *************>
bufferZ:
	ds.b	160*248
	ds.b	512*215
************ TEXTES FUZION *************<

* <
bss_datas:

Vsync:	ds.b	1
		ds.b	1
Save_stack:	ds.l	1

Save_all:
	ds.b	8	* Mfp : fa03.w -> fa19.w
	ds.b	4	* Mfp : fa1b.w -> fa21.w
	ds.b	4	* Video : f8201.w -> f820d.w
Video:	ds.b	1	* Video : f8260.w
	ds.w	1	* coolness guys !

Save_rest:
	ds.l	1	* Autovector (HBL)
	ds.l	1	* Autovector (VBL)
	ds.l	1	* Timer D (USART timer)
	ds.l	1	* Timer C (200hz Clock)
	ds.l	1	* Keyboard/MIDI (ACIA) 
	ds.l	1	* Timer B (HBL)
	ds.l	1	* Timer A
	ds.l	1	* Output Bip Bop
Palette:ds.w	16	* Palette
* > PATCH
ANC_TIMEA: DS.L 1
ANC_TIMEB: DS.L 1
ANC_HBL: DS.B 1
ANC_IERA: DS.B 1
ANC_IERB: DS.B 1
ANC_IMRA: DS.B 1
ANC_IMRB: DS.B 1
ANC_VR: DS.B 1
	even
* < PATCH
Zorro_scr1:	ds.l	1
Zorro_scr2:	ds.l	1
null:	ds.b	160*10

bss_end:

Zorro_screen1:	
	ds.b	256
start1:	
	ds.b	160*300
Zorro_screen1_len:	equ	*-start1

Zorro_screen2:	
	ds.b	256
start2:	
	ds.b	160*300
Zorro_screen2_len:	equ	*-start2

***************
* Buffers LZ7  *
***************
adr_music:
	ds.b	46000

Buffer_LZ7:
	ds.b 32000

******************************************************************************* // END *

	SECTION	TEXT
	
; Multi Atari Boot code.
; If you have done an ST demo, use that boot to run it on these machines:
;
; ST, STe, Mega-ST,TT,Falcon,CT60
;
; More info:
; http://leonard.oxg.free.fr/articles/multi_atari/multi_atari.html

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
; here TT or FALCON

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

bCT60: dc.b 0
	even

******************************************************************
	END
******************************************************************
