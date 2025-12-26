***************************************
* // SQUAREV2.PRG                  // *
***************************************
* // Asm Intro Code Atari ST v0.47 // *
* // by Zorro 2/NoExtra (23/11/23) // *
***************************************
* // Original code : MISTER.A/NOEX // *
* // Add. code     : ANGEL/HMD     // *
* // Add. code     : ZERKMAN/SCT1  // *
* // Gfx logo      : ANGEL/HMD     // *
* // Gfx font      : unknow        // *
* // Music         : WIECZOR/HMD   // *
* // Text          : ANGEL/HMD     // *
* // Release date  : 17/12/2025    // *
***************************************
  OPT c+ ; Case sensitivity ON        *
  OPT d- ; Debug OFF                  *
  OPT o- ; All optimisations OFF      *
  OPT w- ; Warnings OFF               *
  OPT x- ; Extended debug OFF         *
***************************************

SYNCHRO_WAIT   equ $900            ; Adresse de la synchro

Begin:
 include "STARTEUP.S"

*

	moveq		#0,d0                    ; Get out the menu!
	move.w	#$A,d0                   ;
	move.l	d0,$40.w                 ;

*

SIZE_OF_SCREEN equ 160*200         ; Only Screen size
PATTERN        equ $00000000       ; See the screen plan

	move.l	#Screen_1,d0             ; Set physical Screen #1
	add.l		#$ff,d0                  ;
	sf			d0                       ;
	move.l	d0,physique              ;

	move.l	#Screen_2,d0             ; Set logical Screen #2
	add.l		#$ff,d0                  ;
	sf			d0                       ;
	move.l	d0,physique+4            ;

	move.l	physique(pc),a0          ; Put PATTERN in two Screens
	move.l	physique+4(pc),a1        ;
	move.w  #(SIZE_OF_SCREEN)/4-1,d7 ;
	move.l  #PATTERN,(a0)+           ;
	move.l  #PATTERN,(a1)+           ;
	dbf	    d7,*-12                  ;

*

	moveq	#1,d0                      ; Choice of the music (1 is default)
	jsr	MUSIC+0                      ; Init SNDH music

*

	move #$2700,sr
;	bclr	#3,$fffffa17.w             ; Stop Timer C
	lea	start_vbl(pc),a0             ; Launch VBL
	move.l	a0,$70.w                 ;
	stop	#$2300

*

	move.l	#$0000000,$ffff8240.w
	move.l	#$3330000,$ffff8242.w
	move.l	#$5550000,$ffff8248.w

	move.l	physique(pc),d0          ; Put physical Screen
	move.b	d0,d1                    ;
	lsr.w		#8,d0                    ;
	move.b	d0,$ffff8203.w           ;
	swap		d0                       ;
	move.b	d0,$ffff8201.w           ;
	move.b	d1,$ffff820d.w           ;

	jsr	init_texte1

	move.l  #$030-8,SYNCHRO_WAIT
texte_intro1:
	bsr	Wait_vbl                     ; Waiting after the VBL

	jsr	put_texte                    ; Put text

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s		texte_intro1

	jsr	temporisation

**************************** MAIN LOOP ************************>

	jsr	FadeTOblack

	jsr	mpp_init

	lea	my_mpp_str,a1
	move.l	physique(pc),a0
	add			#$a0,a0
	move.l	a0,picp0(a1)             ; picp0
	move.l	physique+4(pc),a0
	add			#$a0,a0
	move.l	a0,picp1(a1)		         ; picp1
	move.l	#Palette_1,palp0(a1)	   ; palp0
	move.l	#Palette_2,palp1(a1)	   ; palp1

	lea	image_MPP,a0                 ;	file address
	jsr	mpp_decode                   ; Decode a MPP file

	jsr	mpp_setup_img                ; Setup image for display

	move.l  #$170-5,SYNCHRO_WAIT
main_loop:
	bsr	Wait_vbl                     ; Waiting after the VBL

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s		main_loop

**************************** MAIN LOOP ************************<

	jsr	FadeTOblack

*

	move #$2700,sr
;	bset.b #3,$fffffa17.w            ; Re-activate Timer C
	lea	start_vbl(pc),a0             ; Launch VBL
	move.l	a0,$70.w                 ;
	stop	#$2300

*

	move.l	physique(pc),a0
	jsr	clear_blit                   ; clear logical screen

	move.l	#$0000000,$ffff8240.w
	move.l	#$3330000,$ffff8242.w
	move.l	#$5550000,$ffff8248.w

	move.l	physique(pc),d0          ; Put physical Screen
	move.b	d0,d1                    ;
	lsr.w		#8,d0                    ;
	move.b	d0,$ffff8203.w           ;
	swap		d0                       ;
	move.b	d0,$ffff8201.w           ;
	move.b	d1,$ffff820d.w           ;

	jsr	init_texte2

	move.l  #$030-8,SYNCHRO_WAIT
texte_intro2:
	bsr	Wait_vbl                     ; Waiting after the VBL

	jsr	put_texte                    ; Put text

	sub.l   #1,SYNCHRO_WAIT
	cmpi.l  #0,SYNCHRO_WAIT
	bne.s		texte_intro2

	jsr	temporisation

*

	jsr	FadeTOblack

*

	jsr	MUSIC+4                      ; Stop SNDH music

	lea $ffff8800.w,a0               ; Cut sound
	move.l #$8000000,(a0)            ; Voice A
	move.l #$9000000,(a0)            ; Voice B
	move.l #$a000000,(a0)            ; Voice C

*

EXIT:
	rts

physique:
	ds.l 2                           ; Number of screens declared

***************************************************************
*                                                             *
*                        Vbl Routines                         *
*                                                             *
***************************************************************
start_vbl:
	st	Vsync                        ; Synchronisation
	jsr	MUSIC+8                      ; Play SNDH music
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
*                           PAUSE-TIMER                       *
***************************************************************
* d7 : timing ($0..$fff)                                      *
***************************************************************
temporisation:
	move.w	#$070,d7
.wait_more:
	bsr	Wait_vbl                     ; Waiting after the VBL
	dbra	d7,.wait_more
	rts

***************************************************************
; SUB-ROUTINES                                             // *
***************************************************************

	include	"TEXTE.ASM"
	include "CLEARFUL.ASM"
	include "FADETOBK.ASM"
	include	"mppdec.s"

***************************************************************
 SECTION	DATA                                             // *
***************************************************************

image_MPP:
	incbin	"PERSOHMD.MPP"
	even

MUSIC:	* SNDH music -> Not compressed please !!!
	incbin	"SQ_INT01.SND"
	even

***************************************************************
 SECTION	BSS                                              // *
***************************************************************

Vsync:
	ds.w	1

my_mpp_str:
	ds.b	mppstrsize
Palette_1:
	ds.w	48*273		; maximum MPP palette size (mode 3)
Palette_2:
	ds.w	48*273

Screen_1:
	ds.b	256+230*273	; alignment + maximum MPP image size (mode 3)
Screen_2:
	ds.b	256+230*273
	even

***************************************************************
	END                                                      // *
***************************************************************
