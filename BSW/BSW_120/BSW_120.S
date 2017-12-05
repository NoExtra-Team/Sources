* BSW_120.PRG

; Code : Zorro2/MjjProd
; Loader : Atomus/NoExtra
; Low Border source : GT_Turbo/CV
; Music : CrawDaddy
; Gfx neochrome master : F.F.
; Fonte 8*8 1 plan : F.F.
; Fonte 8*8 4 plans : ripped by F.F.
; Release date : 25/09/2004

***********************************************
	opt	o+
***********************************************

	SECTION	TEXT

***********************************************
ACCES_DISQUE	equ	1	; 0 = C & 1 = A
pos_obj	equ	16*4+160*6+8
vitesse_compt	equ	4	; 2 for speedy
***********************************************

gemdos         equ	1
crawcin        equ	7
cconws         equ	9
mshrink        equ	$4a
pexec          equ	$4b

	movea.l    4(sp),a5      ;Donner espace mÇmoire
        move.l     12(a5),d0     ;Longueur du code
        add.l      20(a5),d0     ;+ Longueur du segment donnÇes
        add.l      28(a5),d0     ;+ Longueur du segment BSS +
        addi.l     #$1100,d0     ;Basepage (256 Bytes)+ pile (4KB)
        move.l     d0,d1         ;Longueur plus
        add.l      a5,d1         ;adresse
        andi.l     #-2,d1        ;(arrondie)
        movea.l    d1,sp         ;donne pointeur pile

        move.l     d0,-(sp)      ;Longueur de l'espace mÇmoire nÇcessaire
        move.l     a5,-(sp)      ;Adresse de la zone mÇmoire
        clr.w      -(sp)         ;octet "dummy" sans importance
        move.w     #mshrink,-(sp)
        trap       #gemdos
        adda.l     #12,sp
               
	clr.l	-(sp)
	move.w	#32,-(sp)
	trap	#1
	addq.l	#6,sp
	move.l	d0,Save_stack

	jsr	SaveVBI
	jsr	Init_screens
	jsr	Save_and_init_a_st
	jsr	Init(pc)

Init_Scrollup
	move.w 	#vitesse_compt,cmpt_vbl	* init compteur VBL pour texte
	move.l 	#txt2-1,ptr
	clr.w 	anim
	move.w	#pos_obj,adr_obj
	clr.w 	vitesse
	
******************************************************************************

Main_rout:
	jsr	Wait_vbl(pc)

	jsr	swapscreen
	
	*jsr	texto(pc)

	jsr	digit(pc)
       
* -->
	cmpi.b	#$39,$FFFFFC02.w	*	ESP
	beq	RunCrc
	cmpi.b	#$3B,$FFFFFC02.w	*	F1
	beq	Run1
	cmpi.b	#$3C,$FFFFFC02.w	*	F2
	beq	Run2
	cmpi.b	#$3D,$FFFFFC02.w	*	F3
	beq	Run3
	cmpi.b	#$3E,$FFFFFC02.w	*	F4
	beq	Run4
	cmpi.b	#$3F,$FFFFFC02.w	*	F5
	beq	Run5
	cmpi.b	#$40,$FFFFFC02.w	*	F6
	beq	Run6
	cmpi.b	#$41,$FFFFFC02.w	*	F7
	beq	Run7
	cmpi.b	#$42,$FFFFFC02.w	*	F8
	beq	Run8
	cmpi.b	#$43,$FFFFFC02.w	*	F9
	beq	Run9

	cmpi.b	#$62,$FFFFFC02.w	*	+
	bne.s	suivant1
	move.b 	#4,vitesse
suivant1	
	cmpi.b	#$61,$FFFFFC02.w	*	-
	bne.s	suivant2
	move.b 	#2,vitesse
suivant2
		
* <--	

	cmp.b	#$01,$fffffc02.w	* Wait
	bne	Main_rout		* Space

******************************************************************************

	jsr	RestoreVBI
	jsr	Cls_screens
	jsr	Restore_st
	jsr	SoundOff

	jsr	FlushKey

	move.l	Save_stack,-(sp)
	move.w	#32,-(sp)
	trap	#1
	addq.l	#6,sp

	clr.w	-(sp)
	trap	#1

************************************************
*                                              *
*               Sub Routines                   *
*                                              *
************************************************
	
Vbl:	movem.l	d0-d7/a0-a6,-(a7)

	st	Vsync

        lea 		Pal,a0
        movem.l 	(a0)+,d0-d7
        movem.l		d0-d7,$ffff8240.w
	
	jsr	music

	jsr	put_texte(pc)

      	jsr	scrolling(pc)
	jsr	scrolling(pc)
	
*******************************

	move.l	#Over_rout,$120.w
	move.b	#199,$fffffa21.w
	move.b	#8,$fffffa1b.w
		
	movem.l	(a7)+,d0-d7/a0-a6
	rte

Wait_vbl:
	move.l	a0,-(a7)
	lea	Vsync,a0
	sf	(a0)
Wait_label:	
	tst.b	(a0)
	beq.s	Wait_label
	move.l	(a7)+,a0
	rts

*********************************************
*                                           *
*********************************************

Init:	movem.l	d0-d7/a0-a6,-(a7)

	move.b	$484.w,conterm	; Sauve ce bidule.
	clr.b	$484.w		; No bip,no repeat.
	
	; --- Supprime souris ---
        pea	stop_mouse
        move.w 	#0,-(sp)
        move.w 	#$19,-(sp)
        trap 	#14
        addq.l 	#8,sp
	
	DC.W $A000
	DC.W $A00A
	
	moveq	#1,D0
	jsr     INIT_SND

	lea	Vbl(pc),a0
	move.l	a0,$70.w

	movem.l	(a7)+,d0-d7/a0-a6
	rts

************************************************
*                                              *
************************************************

Save_and_init_a_st:
	move	#$2700,sr

	sf	$ffff8260.w

	moveq	#0,d0
	lea	$fffffa00.w,a0
	movep.w	d0,$07(a0)
	movep.w	d0,$13(a0)

	bclr	#3,$fffffa17.w

	move.l	Turbo_scr1,d0
	move.b	d0,d1
	lsr.w	#8,d0
	move.b	d0,$ffff8203.w
	swap	d0
	move.b	d0,$ffff8201.w
	move.b	d1,$ffff820d.w

	sf	$fffffa21.w
	sf	$fffffa1b.w
	move.l	#Over_rout,$120.w

	bset	#0,$fffffa07.w	* Timer B on
	bset	#0,$fffffa13.w	* Timer B on

	stop	#$2300
	
	rts

***************************************************************
*                                                             *
*             < Here is the lower border rout >               *
*                                                             *
***************************************************************
	
Over_rout:
	bclr	#0,$fffffffa0f.w

	sf	$fffffa21.w	* Stop Timer B
	sf	$fffffa1b.w

	REPT	95	* Wait line end
	nop
	ENDR	
	sf	$ffff820a.w	* Modif Frequency 60 Hz !

	REPT	28	* Wait a little
	nop
	ENDR

	move.b	#$2,$ffff820a.w * 50 Hz !

	rte

***************************************************************
*                                                             *
***************************************************************

Restore_st:
* Sorry for the next lines, but sometimes there somes syncs error !!

	jsr	V_SYNC
	
	move.b	Video,$ffff8260.w
	move.w	#$25,-(a7)
	trap	#14
	addq.w	#2,a7
	move.b	Video,$ffff8260.w

	; --- Retablit la souris ---
        pea go_mouse
        move.w #0,-(sp)
        move.w #$19,-(sp)
        trap #14
        addq.l #8,sp
	
	DC.W $A000
	DC.W $A009
	rts

Cls_screens:
	move.l	Turbo_scr1,a0
	move.l	Turbo_scr2,a1
	move.w	#7999+400,d7
.clear:	clr.l	(a0)+
	clr.l	(a1)+
	dbf	d7,.clear
	rts
	
************************************************
*                                              *
************************************************

Init_screens:	movem.l	d0-d7/a0-a6,-(a7)

	jsr	fadein

	move.l	#Turbo_screen1,d0
	add.w	#$ff,d0
	sf	d0
	move.l	d0,Turbo_scr1

	move.l	#Turbo_screen1,d1
	add.w	#$ff,d1
	sf	d1
	move.l	d1,Turbo_scr2
	
	jsr	Cls_screens
		
	movea.l	Turbo_scr1,a1
	movea.l	#IMG_LOGO,a0
	move.l	#7999,d0
.aff:	move.l	(a0)+,(a1)+
	dbf	d0,.aff

	jsr	texto
	
	movem.l	(a7)+,d0-d7/a0-a6
	rts

SaveVBI
	lea	Save_all,a0
	move.b	$fffffa07.w,(a0)+
	move.b	$fffffa09.w,(a0)+
	move.b	$fffffa13.w,(a0)+
	move.b	$fffffa15.w,(a0)+
	move.b	$fffffa17.w,(a0)+
	move.b	$ffff8201.w,(a0)+
	move.b	$ffff8203.w,(a0)+
	move.b	$ffff820d.w,(a0)+
	move.b	$ffff8260.w,(a0)+
	move.b	$ffff820a.w,(a0)+

	move.l	$070.w,(a0)+	
	move.l	$118.w,(a0)+	
	move.l	$120.w,(a0)+	
	move.l	$134.w,(a0)+	
	move.l	$114.w,(a0)+	
	move.l	$110.w,(a0)+
		
	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,(a0)
	rts
	
RestoreVBI
	move.w	#$2700,sr
	lea	Save_all,a0
	move.b	(a0)+,$fffffa07.w
	move.b	(a0)+,$fffffa09.w
	move.b	(a0)+,$fffffa13.w
	move.b	(a0)+,$fffffa15.w
	move.b	(a0)+,$fffffa17.w
	move.b	(a0)+,$ffff8201.w
	move.b	(a0)+,$ffff8203.w
	move.b	(a0)+,$ffff820d.w
	move.b	(a0)+,$ffff8260.w
	move.b	(a0)+,$ffff820a.w

	move.l	(a0)+,$070.w
	move.l	(a0)+,$118.w
	move.l	(a0)+,$120.w
	move.l	(a0)+,$134.w
	move.l	(a0)+,$114.w
	move.l	(a0)+,$110.w

	movem.l	(a0),d0-d7
	movem.l	d0-d7,$ffff8240.w
	stop	#$2300
	rts

***************************************
                  
SoundOff:
	moveq	#0,d0
	jsr	music		; activate first tune

        move.b 	#8,$ffff8800.w        ; Sound OFF
        move.b 	#0,$ffff8802.w
        move.b 	#9,$ffff8800.w
        move.b 	#0,$ffff8802.w
        move.b 	#$a,$ffff8800.w
        move.b 	#0,$ffff8802.w
	RTS

put_texte:

; ***************************************************************
; Affichage du texte
; ***************************************************************

           subq.w 	#1,cmpt_vbl
           bne 		curseur
           cmp.b	#4,vitesse
           bne.s	vlente
vnormale           
           move.w 	#2,cmpt_vbl
           bra.s	suite
vlente
	   move.w 	#4,cmpt_vbl

suite
           moveq 	#0,d0

; ---< Pointeur texte >---

           addq.l 	#1,ptr               ; + 1
           move.l 	ptr,a0               ; Sauve a0

; ---< Teste si caractere ou code >---

           move.b 	(a0),d0              ; Code ou caract dans d0

; ---------------------------------------------------------------
; Retour en debut de texte 
; ---------------------------------------------------------------

           cmp.b 	#$fd,d0
           bne.s 	deb_lig
           move.l 	#txt2-1,ptr
           move.w	#pos_obj,adr_obj
           bra 		curseur

; ---------------------------------------------------------------
; Retour en debut de ligne
; ---------------------------------------------------------------
   
deb_lig    cmp.b 	#$ff,d0               ; Debut de ligne ?
           bne.s	pas_deb

           move.l 	Turbo_scr2,a3     
           add.w 	adr_obj,a3

i          set 	0
           rept 	7
           clr.b 	i(a3)
i          set 	i+160
           endr
	
	   add.w 	#80+8*160,adr_obj
           clr.w 	anim
           bra	 	curseur

pas_deb	   cmp.b	#$fe,d0
	   bne.s 	caract
           move.l 	Turbo_scr2,a3     
           add.w 	adr_obj,a3

i          set 	0
           rept 	7
           clr.b 	i(a3)
i          set 	i+160
           endr

	   move.w 	#pos_obj,adr_obj
	   clr.w	anim
	   bra.s 	curseur
           			
; ---------------------------------------------------------------
; Adresse du caractere a afficher
; ---------------------------------------------------------------

caract     asl.w 	#3,d0                 ; valeur * 8
           lea 		font,a0               ; Adresse de la fonte
           add.w 	d0,a0                 ; a0= adr caractere

; ---------------------------------------------------------------
; Caractere -> Ecran
; ---------------------------------------------------------------

           move.l 	Turbo_scr1,a2     
           add.w 	adr_obj,a2
           move.l 	Turbo_scr2,a3     
           add.w 	adr_obj,a3
           
i          set 	0
           rept 	7
           move.b 	(a0),i(a2)
           move.b 	(a0)+,i(a3)
i          set 	i+160
           endr
                      
; ---------------------------------------------------------------
; Adresse ecran du prochain caractere a afficher
; ---------------------------------------------------------------

           tst.w 	anim
           bne.s 	loc1
           move.b 	#1,anim
           addq.w 	#1,adr_obj           
           bra.s 	curseur
loc1       clr.w 	anim
           addq.w 	#7,adr_obj
    
; ---------------------------------------------------------------
; Gestion du curseur
; ---------------------------------------------------------------

curseur	   
	   lea		font+32*8,a0
	   *move.l 	Turbo_scr1,a2     
           move.l 	Turbo_scr2,a3     
           *add.w 	adr_obj,a2
           add.w 	adr_obj,a3

i          set 	0
           rept 	7
           *move.b 	(a0),i(a2)
           move.b 	(a0)+,i(a3)
i          set 	i+160
           endr
	rts

plus
	move.w 	#4,cmpt_vbl
	rts
	
moins
	move.w 	#2,cmpt_vbl
	rts

swapscreen:
	move.l	Turbo_scr1,d0
	move.l	Turbo_scr2,Turbo_scr1
	move.l	d0,Turbo_scr2
	MOVE.B	Turbo_scr1+1,$FFFF8201.W
	MOVE.B	Turbo_scr1+2,$FFFF8203.W
	rts

	section	data

font	incbin 	"FONT_8X8.DAT"
	even
	
cmpt_vbl   dc.w 2
vitesse	   ds.w 1
anim       ds.w 1
adr_obj    ds.l 1

; ------------------------------
; $fd = fin du texte
; $fe = retour en debut de ligne
; ------------------------------ 

;          ---< Page 1 >---

*	         a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t
*	   dc.b 00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,$ff
*	         u  v  w  x  y  z  ?  .  !  :  (  ) cur    -  0  1  2  3  4
*	   dc.b 20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,$ff
*	         5  6  7  8  9
*	   dc.b 40,41,42,43,44,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff

txt2       

;          ---< Page 1 >---

	   dc.b 33,19,07,04,33,01,24,19,04,33,14,05,33,19,27,02,27,04,27,33,$ff
           dc.b 15,17,14,20,03,11,24,33,15,17,04,18,04,13,19,18,33,07,08,18,$ff
           dc.b 33,13,04,22,33,02,14,12,15,08,11,33,01,18,22,33,03,02,03,33,$ff
	   dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,27,13,27,20,27,12,27,01,27,04,27,17,27,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,36,33,33,33,33,37,37,37,33,33,33,35,35,35,33,33,33,$ff
           dc.b 33,33,36,36,33,33,33,37,33,33,33,37,33,35,33,33,33,35,33,33,$ff
           dc.b 33,33,33,36,33,33,33,33,33,33,33,37,33,35,33,33,33,35,33,33,$ff
           dc.b 33,33,33,36,33,33,33,33,33,33,33,37,33,35,33,33,33,35,33,33,$ff
           dc.b 33,33,33,36,33,33,33,33,33,33,33,37,33,35,33,33,35,35,33,33,$ff
           dc.b 33,33,33,36,33,33,33,33,33,33,33,37,33,35,33,35,33,35,33,33,$ff
           dc.b 33,33,33,36,33,33,33,33,33,33,37,33,33,35,35,33,33,35,33,33,$ff
           dc.b 33,33,33,36,33,33,33,33,33,37,33,33,33,35,33,33,33,35,33,33,$ff
           dc.b 33,33,33,36,33,33,33,33,37,33,33,33,33,35,33,33,33,35,33,33,$ff
           dc.b 33,36,36,36,36,36,33,37,37,37,37,37,33,33,35,35,35,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,17,04,11,04,00,18,04,03,33,08,13,33,37,40,27,35,44,33,33,$fe

;          ---< Page 2 >---

           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$fe

;          ---< Page 3 >---

           dc.b 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,$ff
           dc.b 30,33,24,14,20,33,02,00,13,33,18,04,11,04,02,19,33,29,33,31,$ff
           dc.b 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,$ff
           dc.b 30,33,05,36,29,33,38,03,33,05,20,11,11,33,03,04,12,14,33,31,$ff	* F1
           dc.b 30,33,33,33,33,33,01,24,33,14,23,24,06,04,13,04,33,33,33,31,$ff
           dc.b 30,33,05,37,29,33,18,20,12,12,04,17,33,37,10,36,33,33,33,31,$ff	* F2
           dc.b 30,33,33,33,33,33,14,13,11,08,13,04,33,02,14,12,15,14,33,31,$ff
           dc.b 30,33,05,38,29,33,13,19,17,33,18,19,04,33,03,04,12,14,33,31,$ff	* F3
           dc.b 30,33,05,39,29,33,19,07,04,33,03,14,19,18,33,33,33,33,33,31,$ff	* F4
           dc.b 30,33,33,33,33,33,33,33,33,33,33,33,03,04,13,19,17,14,33,31,$ff
           dc.b 30,33,05,40,29,33,19,17,00,20,12,00,33,19,22,14,33,33,33,31,$ff	* F5
           dc.b 30,33,05,41,29,33,19,07,04,33,00,02,07,04,12,04,13,19,33,31,$ff	* F6
           dc.b 30,33,33,33,33,33,01,08,04,13,33,03,04,12,14,33,01,24,33,31,$ff
           dc.b 30,33,33,33,33,33,17,04,02,00,11,11,33,33,33,33,33,33,33,31,$ff
           dc.b 30,33,05,42,29,33,03,04,12,14,37,33,17,04,02,00,11,11,33,31,$ff	* F7
           dc.b 30,33,05,43,29,33,05,11,04,23,08,02,07,14,13,33,01,24,33,31,$ff	* F8
           dc.b 30,33,33,33,33,33,33,33,33,05,11,04,23,08,02,07,14,13,33,31,$ff
           dc.b 30,33,05,44,29,33,18,20,12,12,04,17,33,37,10,36,33,33,33,31,$ff	* F9
           dc.b 30,33,33,33,33,33,14,13,11,08,13,04,33,03,14,02,18,33,33,31,$ff        
           dc.b 30,33,18,15,00,02,04,29,33,03,08,18,10,02,07,04,02,10,33,31,$ff	* SPACE           
           dc.b 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,$fe
           
;          ---< Page 4 >---

           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$ff
           dc.b 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,$fe
           
           dc.b $fd
           
           even

	section	text
		
scrolling
      ADDQ.B    #1,nextc
      CMPI.B    #8,nextc
      BHI       PUT_CAR 
put:  MOVEA.L   Turbo_scr2,A0
      LEA       160*201(A0),A0
      LEA       BUFFER,A1
      MOVEq    #7,D0 
pass: MOVEq    #3,D1 
scroll:ROXL      (A1)+ 
      ROXL      152(A0) 
      ROXL      144(A0) 
      ROXL      136(A0) 
      ROXL      128(A0) 
      ROXL      120(A0) 
      ROXL      112(A0) 
      ROXL      104(A0) 
      ROXL      96(A0)
      ROXL      88(A0)
      ROXL      80(A0)
      ROXL      72(A0)
      ROXL      64(A0)
      ROXL      56(A0)
      ROXL      48(A0)
      ROXL      40(A0)
      ROXL      32(A0)
      ROXL      24(A0)
      ROXL      16(A0)
      ROXL      8(A0) 
      ROXL      (A0)
      LEA       2(A0),A0
      DBF       D1,scroll
      LEA       152(A0),A0
      DBF       D0,pass
      RTS 

raz:  MOVE.L    #TEXTE,PT_TEXT
PUT_CAR:MOVEA.L   PT_TEXT,A0
      MOVE.B    (A0),D2 
      CMP.B     #-1,D2
      BEQ.s     raz 
      ADDQ.L    #1,PT_TEXT
      LEA       pfonte,A0
      ANDI.L    #$FF,D2 
      LSL.L     #2,D2 
      ADDA.L    D2,A0 
      MOVE.L    (A0),D2 
      MOVE.B    #1,nextc
      LEA       BUFFER,A1
      LEA       pcarac,A2
      ADDA.L    D2,A2 

      MOVE.W    #7,D0 						*** ICI !!!
.loop0:MOVE.B    (A2),(A1) 
      MOVE.B    2(A2),2(A1) 
      MOVE.B    4(A2),4(A1) 
      MOVE.B    6(A2),6(A1) 
      LEA       160(A2),A2
      LEA       8(A1),A1
      DBF       D0,.loop0
      BRA       put

digit
	lea         $FFFF8800.w,A0 ;giselect
	move.b      #8,(A0)
	move.b      (A0),D0
	andi.w      #15,D0
	moveq       #0,D1
	bsr.b       aff_v
	move.b      #9,(A0)
	move.b      (A0),D0
	andi.w      #15,D0
	moveq       #8,D1
	bsr.b       aff_v
	move.b      #10,(A0)
	move.b      (A0),D0
	andi.w      #15,D0
	moveq       #$10,D1
	bsr.b       aff_v
	rts

aff_v:  lea         panneau,A1
	movea.l     Turbo_scr1,A2
	muls        #$100,D0
	adda.w      D0,A1
	adda.w      D1,A2
	adda.w      #$6400,A2
	adda.w      #160*49,A2		***	ICI !!!
	movem.l     D1/D2,-(SP)
	movem.l     (A1)+,D1/D2
	movem.l     D1/D2,8(A2)
	movem.l     D1/D2,$20(A2)
	movem.l     D1/D2,$38(A2)
	movem.l     D1/D2,$50(A2)
	movem.l     D1/D2,$68(A2)
	movem.l     D1/D2,$80(A2)
	movem.l     (A1)+,D1/D2
	movem.l     D1/D2,$148(A2)
	movem.l     D1/D2,$160(A2)
	movem.l     D1/D2,$178(A2)
	movem.l     D1/D2,$190(A2)
	movem.l     D1/D2,$1A8(A2)
	movem.l     D1/D2,$1C0(A2)
	movem.l     (A1)+,D1/D2
	movem.l     D1/D2,$288(A2)
	movem.l     D1/D2,$2A0(A2)
	movem.l     D1/D2,$2B8(A2)
	movem.l     D1/D2,$2D0(A2)
	movem.l     D1/D2,$2E8(A2)
	movem.l     D1/D2,$300(A2)
	movem.l     (A1)+,D1/D2
	movem.l     D1/D2,$3C8(A2)
	movem.l     D1/D2,$3E0(A2)
	movem.l     D1/D2,$3F8(A2)
	movem.l     D1/D2,$410(A2)
	movem.l     D1/D2,$428(A2)
	movem.l     D1/D2,$440(A2)
	movem.l     (A1)+,D1/D2
	movem.l     D1/D2,$508(A2)
	movem.l     D1/D2,$520(A2)
	movem.l     D1/D2,$538(A2)
	movem.l     D1/D2,$550(A2)
	movem.l     D1/D2,$568(A2)
	movem.l     D1/D2,$580(A2)
	movem.l     (A1)+,D1/D2
	movem.l     D1/D2,$648(A2)
	movem.l     D1/D2,$660(A2)
	movem.l     D1/D2,$678(A2)
	movem.l     D1/D2,$690(A2)
	movem.l     D1/D2,$6A8(A2)
	movem.l     D1/D2,$6C0(A2)
	movem.l     (A1)+,D1/D2
	movem.l     D1/D2,$788(A2)
	movem.l     D1/D2,$7A0(A2)
	movem.l     D1/D2,$7B8(A2)
	movem.l     D1/D2,$7D0(A2)
	movem.l     D1/D2,$7E8(A2)
	movem.l     D1/D2,$800(A2)
	movem.l     (A1)+,D1/D2
	movem.l     D1/D2,$8C8(A2)
	movem.l     D1/D2,$8E0(A2)
	movem.l     D1/D2,$8F8(A2)
	movem.l     D1/D2,$910(A2)
	movem.l     D1/D2,$928(A2)
	movem.l     D1/D2,$940(A2)
	movem.l     (A1)+,D1/D2
	movem.l     D1/D2,$A08(A2)
	movem.l     D1/D2,$A20(A2)
	movem.l     D1/D2,$A38(A2)
	movem.l     D1/D2,$A50(A2)
	movem.l     D1/D2,$A68(A2)
	movem.l     D1/D2,$A80(A2)
	movem.l     (A1)+,D1/D2
	movem.l     D1/D2,$B48(A2)
	movem.l     D1/D2,$B60(A2)
	movem.l     D1/D2,$B78(A2)
	movem.l     D1/D2,$B90(A2)
	movem.l     D1/D2,$BA8(A2)
	movem.l     D1/D2,$BC0(A2)
	movem.l     (A1)+,D1/D2
	movem.l     D1/D2,$C88(A2)
	movem.l     D1/D2,$CA0(A2)
	movem.l     D1/D2,$CB8(A2)
	movem.l     D1/D2,$CD0(A2)
	movem.l     D1/D2,$CE8(A2)
	movem.l     D1/D2,$D00(A2)
	movem.l     (A1)+,D1/D2
	movem.l     D1/D2,$DC8(A2)
	movem.l     D1/D2,$DE0(A2)
	movem.l     D1/D2,$DF8(A2)
	movem.l     D1/D2,$E10(A2)
	movem.l     D1/D2,$E28(A2)
	movem.l     D1/D2,$E40(A2)
	movem.l     (A1)+,D1/D2
	movem.l     D1/D2,$F08(A2)
	movem.l     D1/D2,$F20(A2)
	movem.l     D1/D2,$F38(A2)
	movem.l     D1/D2,$F50(A2)
	movem.l     D1/D2,$F68(A2)
	movem.l     D1/D2,$F80(A2)
	movem.l     (A1)+,D1/D2
	movem.l     D1/D2,$1048(A2)
	movem.l     D1/D2,$1060(A2)
	movem.l     D1/D2,$1078(A2)
	movem.l     D1/D2,$1090(A2)
	movem.l     D1/D2,$10A8(A2)
	movem.l     D1/D2,$10C0(A2)
	movem.l     (A1)+,D1/D2
	movem.l     D1/D2,$1188(A2)
	movem.l     D1/D2,$11A0(A2)
	movem.l     D1/D2,$11B8(A2)
	movem.l     D1/D2,$11D0(A2)
	movem.l     D1/D2,$11E8(A2)
	movem.l     D1/D2,$1200(A2)
	movem.l     (A1)+,D1/D2
	movem.l     D1/D2,$12C8(A2)
	movem.l     D1/D2,$12E0(A2)
	movem.l     D1/D2,$12F8(A2)
	movem.l     D1/D2,$1310(A2)
	movem.l     D1/D2,$1328(A2)
	movem.l     D1/D2,$1340(A2)
	movem.l     (SP)+,D1/D2
	rts         

Run1:	move.l	#PROG1,NOMPRG
	bra.s	RUN
Run2:	move.l	#PROG2,NOMPRG
	bra.s	RUN
Run3:	move.l	#PROG3,NOMPRG
	bra.s	RUN
Run4:	move.l	#PROG4,NOMPRG
	bra.s	RUN
Run5:	move.l	#PROG5,NOMPRG
	bra.s	RUN
Run6:	move.l	#PROG6,NOMPRG
	bra.s	RUN
Run7:	move.l	#PROG7,NOMPRG
	bra.s	RUN
Run8:	move.l	#PROG8,NOMPRG
	bra.s	RUN
Run9:	move.l	#PROG9,NOMPRG
	bra.s	RUN
RunCRC:	move.l	#PROGCRC,NOMPRG

Run:

	jsr	RestoreVBI
	jsr	Cls_screens
	jsr	Restore_st
	jsr	SoundOff
	
	jsr	FlushKey	
	
*--
	move.l	#Emp,d5		; racine disk
	move.l d5,-(sp)
	move.w #$3b,-(sp)
	trap #1


	pea        environ       ;Postchargement du programme
        pea        params
        move.l	  NOMPRG,-(SP)
        clr.w      -(sp)         ;Nul -> Charger et lancer immÇdiatement
        move.w     #pexec,-(sp)
        trap       #gemdos
        adda.l     #16,sp

        tst.w      d0            ;Erreur?
        bmi.s      error

	jmp	finito

error:  pea        errtext       ;Affichage du message d'erreur
fin:    move.w     #cconws,-(sp)
        trap       #gemdos
        addq.l     #6,sp

        move.w     #crawcin,-(sp)          ;Attendre appui touche...
        trap       #gemdos
        addq.l     #2,sp

finito               
*// Reset obligatoire a la fin               
*               bsr	Reset
*finito
*               clr.w      -(sp)         ;... et quitter le programme
*               trap       #gemdos

Reset
	MOVE.L	4.W,A0
	JMP	(A0)
	rts

fadein
 	move.l	#$777,d0
deg	bsr.s	wart
	bsr.s	wart
	bsr.s	wart
	lea	$ffff8240.w,a0
	moveq	#15,d1
chg1	move.w	d0,(a0)+
	dbf	d1,chg1
	sub.w	#$111,d0
	bne.s	deg
	rts

wart	move.l	d0,-(sp)
	move.l	$466.w,d0
att	cmp.l	$466.w,d0
	beq.s	att
	move.l	(sp)+,d0
	rts
	
texto
	movem.l	mem,d0-a6
	move.l	Turbo_scr1,a5
	lea	160*116+6+8(a5),a5	***
	lea	txt,a1
chg	move.l	a5,a4
wrp	move.l	a4,a0
	lea	place,a2
	lea	fonte,a3
	move.b	(a1)+,d0
	beq	bcl1
	cmpi.b	#1,d0
	bne.s	nch
	lea	160*6(a5),a5
	moveq	#0,d5
	bra.s	chg
nch	cmp.b	(a2)+,d0
	beq.s	post				
	addq.l	#4,d6
	bra.s	nch

post	move.l	(a3,d6.w),d0
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

pos1	lsl.w	#4,d0
	lsl.w	#4,d1
	lsl.w	#4,d2
	lsl.w	#4,d3
	lsl.w	#4,d4
pos2	lsl.w	#4,d0
	lsl.w	#4,d1
	lsl.w	#4,d2
	lsl.w	#4,d3
	lsl.w	#4,d4
pos3	lsl.w	#4,d0
	lsl.w	#4,d1
	lsl.w	#4,d2
	lsl.w	#4,d3
	lsl.w	#4,d4
rin	or.w	d4,(a0)
	or.w	d3,160(a0)
	or.w	d2,320(a0)
	or.w	d1,480(a0)
	or.w	d0,640(a0)
	bra	wrp
bcl1
	rts	

V_SYNC
	move.w	#$25,-(sp)
	trap	#$e		; Vsync
	addq.l	#$2,sp
	RTS

FlushKey
Kflush:
	btst	#0,$fffffc00.w
	beq.s	Flush_ok
	move.b	$fffffc02.w,d0
	bra.s	Kflush
Flush_ok:
	rts
	
******************************************************************

	SECTION	BSS

ptr	ds.l 	1

Vsync:	ds.b	1
               	ds.b	1
Save_stack:	ds.l	1

Save_all:
	ds.b	5	* Mfp
	ds.b	3	* Video
Video	ds.b	1
	ds.b	1
	ds.l	1	* Vbl
	ds.l	1	* Kbd
	ds.l	1	* Timer b
	ds.l	1	* Timer a
	ds.l	1	* Timer c
	ds.l	1	* Timer d
	ds.w	16	* Palette

Turbo_scr1:	ds.l	1
Turbo_scr2:	ds.l	1

Turbo_screen1:	ds.b	(160*250)+256
	
******************************************************************

	SECTION	DATA
	
fonte	dc.l	$4aeaa,$cacac,$68886,$caaac,$e8c8e,$e8c88
	dc.l	$68aa6,$aaeaa,$44444,$222a4,$ac8ca,$8888e
	dc.l	$aeeaa,$aeaaa,$4aaa4,$cac88,$caaa6,$cacaa
	dc.l	$6842c,$e4444,$aaaae,$aaaa4,$aaaea,$aa4aa
	dc.l	$aa444,$e248e,$0
	dc.l	$eaaae,$26a22,$6a24e,$c242c,$88ae2,$e8c2c
	dc.l	$68ca4,$e2488,$ea4ae,$4a62c
	dc.l	$04040,$44404,$00448,$04048,$00004,$4a244
	dc.l	$44000

place	dc.b	"abcdefghijklmnopqrstuvwxyz 0123456789"
	dc.b	":!,;.?'",0
	
txt	dc.b	"c0de....................",1
	dc.b	".................z0rr0 2",1,1
	dc.b	"design by...............",1
	dc.b	"....................f.f.",1,1
	dc.b	"music fr0m..............",1
	dc.b	".......excellence in art",1,1
	dc.b	"scr0lltext hardly tape  ",1
	dc.b	"   by the byte of t.c.e.",1,1
	dc.b	":: st release in 2oo4 ::",1
	dc.b	0
mem	ds.l	16

	even
	
Pal:	dc.w	$0000,$0666,$0CCC,$0899,$0033,$08AA,$0022,$0212
	dc.w	$0112,$0223,$0334,$0445,$0556,$0556,$0667,$0777

IMG_LOGO:
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$1FFF,$1FFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFF0,$FFF0
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FE00,$FFFF,$01FF,$0000
		dc.w	$7F07,$FFFF,$80F8,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FE00,$FFFF,$01FF,$0000
		dc.w	$7F07,$FFFF,$80F8,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FE00,$FFFF,$01FF,$0000
		dc.w	$7F07,$FFFF,$80F8,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FE00,$FFFF,$01FF,$0000
		dc.w	$7FFF,$FFFF,$8000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FE00,$FFFF,$01FF,$0000
		dc.w	$7FFF,$FFFF,$8000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$C440,$C440,$0000,$0000
		dc.w	$421F,$421F,$0000,$0000,$E080,$E0E0,$0060,$0000
		dc.w	$21E0,$21E0,$0000,$0000,$38F8,$38F8,$0000,$0000
		dc.w	$203F,$203F,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$DF5F,$DF5F,$1F1F,$1B1F
		dc.w	$5ADF,$5ADF,$18C0,$18C0,$EECF,$EFEF,$0EAF,$0E0F
		dc.w	$ADEF,$ADEF,$8C0F,$8C0F,$BAFB,$BFFF,$8A8B,$8203
		dc.w	$AFBF,$AFBF,$8F80,$8F80,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$DB58,$DF58,$1B18,$1B18
		dc.w	$5ADF,$5ADF,$18C0,$18C0,$ED0C,$EDAC,$0D2C,$0D0C
		dc.w	$2DEC,$2DEC,$0C0C,$0C0C,$2524,$2DAC,$0504,$0504
		dc.w	$2C21,$2C21,$0C00,$0C00,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$DF5B,$DF5B,$1F18,$1F18
		dc.w	$DADF,$DADF,$18C0,$18C0,$ED8C,$EDAD,$0DAD,$0D8C
		dc.w	$6DED,$EDED,$8C0C,$0C0C,$EDAD,$EDAC,$0D8D,$0D8C
		dc.w	$EDED,$0C0D,$EDEC,$0C0C,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$DB5B,$DF5B,$1B18,$1B18
		dc.w	$DADF,$DADF,$18C0,$18C0,$EDAD,$EDAD,$0D8C,$0D8C
		dc.w	$EDED,$EDED,$0C0C,$0C0C,$EDAD,$EDAC,$0D8D,$0D8C
		dc.w	$EDED,$0C0D,$EDEC,$0C0C,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$DF58,$DF58,$1F18,$1B18
		dc.w	$DADF,$DADF,$18C0,$18C0,$ED2C,$EDAC,$0D0C,$0D0C
		dc.w	$6DEC,$6DEC,$0C0C,$0C0C,$6DA4,$6DAC,$0D84,$0D84
		dc.w	$EC61,$8C01,$6C60,$0C00,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$DB5E,$DB5E,$1B1E,$1B1E
		dc.w	$DADF,$DADF,$18C0,$18C0,$EEEF,$EFEF,$0E8F,$0E0F
		dc.w	$6DEF,$6DEF,$0C0F,$0C0F,$6FBA,$6FAF,$0F9A,$0F82
		dc.w	$EF7F,$CF07,$AF78,$0F00,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$DB18,$DB58,$1B58,$1B18
		dc.w	$DADF,$DADF,$1AC0,$18C0,$ED2C,$EDAC,$0D0C,$0D0C
		dc.w	$6DEC,$6DEC,$0C0C,$0C0C,$6DB9,$6DA1,$0D99,$0D81
		dc.w	$2C61,$8C01,$2C60,$0C00,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$DB19,$DB5B,$1B5A,$1B18
		dc.w	$DDDF,$DFDF,$1DC0,$18C0,$EDAD,$EDAD,$0D8C,$0D8C
		dc.w	$EDED,$EDED,$0C0C,$0C0C,$EDBD,$EDA1,$0D9D,$0D81
		dc.w	$ADED,$8C0D,$ADEC,$8C0C,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$DB19,$DB5B,$1B5A,$1B18
		dc.w	$DADF,$DFDF,$1AC0,$1AC0,$EDAD,$EDAD,$0D8C,$0D8C
		dc.w	$EDED,$EDED,$0C0C,$0C0C,$EDBD,$EDA1,$0D9D,$0D81
		dc.w	$ADED,$8C0D,$ADEC,$8C0C,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$DB18,$DB58,$1B58,$1B18
		dc.w	$5DDF,$5FDF,$1DC0,$1DC0,$EDAC,$EDAC,$0D8C,$0D8C
		dc.w	$2C2C,$2C2C,$0C0C,$0C0C,$2DA1,$2DA1,$0D81,$0D81
		dc.w	$2C21,$8C01,$2C20,$0C00,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$DB1F,$DB5F,$1B5F,$1B1F
		dc.w	$5ADF,$5FDF,$1AC0,$18C0,$EDAF,$EDAF,$0D8F,$0D8F
		dc.w	$AFAF,$AFAF,$8F8F,$8F8F,$ADAE,$ADAF,$8D8E,$8D8E
		dc.w	$EFBF,$CF87,$AFB8,$0F80,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$C000,$C040,$0040,$0000
		dc.w	$421F,$421F,$0000,$0000,$E020,$E020,$0000,$0000
		dc.w	$2020,$2020,$0000,$0000,$2020,$2020,$0000,$0000
		dc.w	$E03F,$8007,$6038,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$F801,$FFFF,$07FE,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFE0,$001F,$0000
		dc.w	$FFFF,$0007,$FFF8,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$C000,$C000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0001,$0001,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$DFFF,$DFFF,$1FFF,$1FFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFD,$FFFD,$FFFC,$FFFC,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$C000,$C000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0001,$0001,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFE0,$001F,$0000
		dc.w	$FFFF,$0007,$FFF8,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFE0,$001F,$0000
		dc.w	$FFFF,$0007,$FFF8,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFF8,$0007,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFE0,$001F,$0000
		dc.w	$FFFF,$0007,$FFF8,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFF8,$0007,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFF8,$0007,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFF8,$0007,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$003F,$003F,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FC00,$FC00
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFF8,$FFFF,$0000
		dc.w	$0000,$0000,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFF8,$FFFF,$0000
		dc.w	$0000,$0000,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFF8,$FFFF,$0000
		dc.w	$0000,$0000,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFF8,$FFFF,$0000
		dc.w	$0000,$0000,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFF8,$FFFF,$0000
		dc.w	$0000,$0000,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$000F,$FFF0,$FFFF,$0000,$FC00,$03FF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$C4FF,$FF00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FE20,$01FF,$0020,$0000,$7FF8,$FFFF,$0000
		dc.w	$0000,$0000,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$000F,$FFF0,$FFFF,$0000,$FC00,$03FF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$C4FF,$FF00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FE20,$01FF,$0020,$0000,$7FF8,$FFFF,$0000
		dc.w	$0000,$0000,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$000F,$FFF0,$FFFF,$0000,$FC00,$03FF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$C4FF,$FF00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FE20,$01FF,$0020,$0000,$7FE0,$FFE0,$0000
		dc.w	$0000,$0000,$3F01,$0000,$0000,$820F,$820F,$0000
		dc.w	$000F,$E030,$E03F,$0000,$0400,$0380,$0780,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$C4FF,$FF00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FE20,$01FF,$0020,$000F,$7FEF,$FFEF,$000F
		dc.w	$A17C,$E1FC,$BF7D,$807C,$38E0,$BAEF,$BAEF,$38E0
		dc.w	$0FAF,$EFF1,$EFBF,$0F80,$743E,$FFBF,$77BE,$703E
		dc.w	$8000,$FFFF,$FFFF,$0000,$07FF,$C4FF,$FF00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FE20,$01FF,$0020,$000E,$7FEE,$FFEE,$000E
		dc.w	$C0C0,$E1C0,$CCC1,$C0C0,$38E0,$BAEF,$BAEF,$38E0
		dc.w	$0ECC,$EEE1,$EECC,$0EC0,$D83B,$DDBB,$D9BB,$D83B
		dc.w	$0000,$BFFF,$3FFF,$0000,$07FF,$C4FF,$FF00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FE20,$01FF,$0020,$000E,$7FEE,$FFEE,$000E
		dc.w	$E1C0,$E1C0,$EDDF,$E1C0,$38E0,$BAEF,$BAEF,$38E0
		dc.w	$0EED,$EEE1,$EEED,$0EE1,$DC3B,$DDBB,$DDBB,$DC3B
		dc.w	$8000,$BFFF,$BFFF,$8000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FE20,$01FF,$0020,$000E,$7FEE,$FFEE,$000E
		dc.w	$E1C0,$E1C0,$EDDF,$E1C0,$38E0,$BAEF,$BAEF,$38E0
		dc.w	$0EED,$EEE1,$EEED,$0EE1,$DC3B,$DDBB,$DDBB,$DC3B
		dc.w	$8000,$BFFF,$BFFF,$8000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FE20,$01FF,$0020,$000E,$7FEE,$FFEE,$000E
		dc.w	$E1C0,$E1C0,$EDDF,$E1C0,$38E0,$BAEF,$BAEF,$38E0
		dc.w	$0EED,$EEE1,$EEED,$0EE1,$DC3B,$DDBB,$DDBB,$DC3B
		dc.w	$8000,$BFFF,$BFFF,$8000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FE20,$01FF,$0020,$000E,$7FEE,$FFEE,$000E
		dc.w	$E1C0,$E1C0,$EDDF,$E1C0,$38E0,$BAEF,$BAEF,$38E0
		dc.w	$0EED,$EEE1,$EEED,$0EE1,$DC3B,$DDBB,$DDBB,$DC3B
		dc.w	$8000,$BFFF,$BFFF,$8000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FE20,$01FF,$0020,$000E,$7FEE,$FFEE,$000E
		dc.w	$E1C0,$EDDF,$EDDF,$E1C0,$38E0,$BAEF,$BAEF,$38E0
		dc.w	$0EE1,$EEED,$EEED,$0EE1,$C03B,$C1BB,$C1BB,$C03B
		dc.w	$8000,$BFFF,$BFFF,$8000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$000E,$FFEE,$FFEE,$000E
		dc.w	$C0C0,$EDC7,$CCC7,$C0C0,$38E0,$BAEF,$BAEF,$38E0
		dc.w	$0EE1,$EEED,$EEED,$0EE1,$C03B,$DFBB,$DFBB,$C03B
		dc.w	$8000,$800F,$BFFF,$8000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$000F,$FFEF,$FFEF,$000F
		dc.w	$A174,$FFFF,$BF77,$8070,$38E0,$BAEF,$BAEF,$38E0
		dc.w	$0EE1,$EEED,$EEED,$0EE1,$C03B,$DFBB,$DFBB,$C03B
		dc.w	$8000,$800F,$BFFF,$8000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$000E,$FFEE,$FFEE,$000E
		dc.w	$C018,$EF1D,$CF19,$C018,$38E0,$BAEF,$BAEF,$38E0
		dc.w	$0EE1,$EEED,$EEED,$0EE1,$C03B,$DFBB,$DFBB,$C03B
		dc.w	$8000,$800F,$BFFF,$8000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$000E,$F00E,$FFEE,$000E
		dc.w	$E01C,$E3DD,$EFDD,$E01C,$38E0,$BAEF,$BAEF,$38E0
		dc.w	$0EE1,$EEED,$EEED,$0EE1,$C03B,$DFBB,$DFBB,$C03B
		dc.w	$8000,$800F,$BFFF,$8000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$000E,$F00E,$FFEE,$000E
		dc.w	$E01C,$E3DD,$EFDD,$E01C,$38E0,$BAEF,$BAEF,$38E0
		dc.w	$0EE1,$EEED,$EEED,$0EE1,$C03B,$C1BB,$C1BB,$C03B
		dc.w	$8000,$800F,$BFFF,$8000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$000E,$F00E,$FFEE,$000E
		dc.w	$E01C,$E3DD,$EFDD,$E01C,$38E0,$BAEF,$BAEF,$38E0
		dc.w	$0EE1,$EEED,$EEED,$0EE1,$DC3B,$DDBB,$DDBB,$DC3B
		dc.w	$8000,$800F,$BFFF,$8000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$000E,$F00E,$FFEE,$000E
		dc.w	$E01C,$E3DD,$EFDD,$E01C,$3AE0,$BAEF,$BAEF,$38E0
		dc.w	$0EE1,$EEED,$EEED,$0EE1,$DC3B,$DDBB,$DDBB,$DC3B
		dc.w	$8000,$800F,$BFFF,$8000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$000E,$F00E,$FFEE,$000E
		dc.w	$E01C,$E3DD,$EFDD,$E01C,$3DE0,$BFEF,$BDEF,$38E0
		dc.w	$0EE1,$EEED,$EEED,$0EE1,$DC3B,$DDBB,$DDBB,$DC3B
		dc.w	$8000,$800F,$BFFF,$8000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$000E,$F00E,$FFEE,$000E
		dc.w	$E01C,$E3DD,$EFDD,$E01C,$3AE0,$BFEF,$BAEF,$3AE0
		dc.w	$0EE1,$EEED,$EEED,$0EE1,$DC3B,$DDBB,$DDBB,$DC3B
		dc.w	$8000,$800F,$BFFF,$8000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$000E,$F00E,$FFEE,$000E
		dc.w	$C018,$E01D,$CC19,$C018,$3DE0,$BFEF,$BDEF,$3DE0
		dc.w	$0EC0,$EEED,$EECC,$0EC0,$D83B,$DDBB,$D9BB,$D83B
		dc.w	$0000,$800F,$3FFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$000F,$F00F,$FFEF,$000F
		dc.w	$A1F4,$E1FF,$BDF7,$81F0,$3AE0,$BFEF,$BAEF,$38E0
		dc.w	$0FA1,$EFFF,$EFBF,$0F80,$743E,$FFBF,$77BE,$703E
		dc.w	$8000,$800F,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$F000,$FFE0,$0000
		dc.w	$0000,$0007,$3C07,$0000,$0000,$820F,$820F,$0000
		dc.w	$0000,$E03F,$E03F,$0000,$0000,$0780,$0780,$0000
		dc.w	$0000,$000F,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$F000,$FFFF,$0000
		dc.w	$0000,$03FF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FF80,$FFFF,$0000
		dc.w	$0000,$000F,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$F000,$FFFF,$0000
		dc.w	$0000,$03FF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FF80,$FFFF,$0000
		dc.w	$0000,$000F,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$F000,$FFFF,$0000
		dc.w	$0000,$03FF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FF80,$FFFF,$0000
		dc.w	$0000,$000F,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$F000,$FFFF,$0000
		dc.w	$0000,$03FF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FF80,$FFFF,$0000
		dc.w	$0000,$000F,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$F000,$FFFF,$0000
		dc.w	$0000,$03FF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FF80,$FFFF,$0000
		dc.w	$0000,$000F,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$F000,$FFFF,$0000
		dc.w	$0000,$03FF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FF80,$FFFF,$0000
		dc.w	$0000,$000F,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$F000,$FFFF,$0000
		dc.w	$0000,$03FF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FF80,$FFFF,$0000
		dc.w	$0000,$000F,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$F000,$FF80,$0000
		dc.w	$0000,$003F,$E03F,$0000,$0000,$F01C,$F01C,$0000
		dc.w	$00C0,$0100,$01C0,$0000,$4000,$001C,$401C,$0000
		dc.w	$0000,$07FF,$07FF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$003E,$F03F,$FFBE,$003E
		dc.w	$8FA0,$8FFF,$EFBF,$0F80,$07D1,$F7FD,$F7DD,$07C1
		dc.w	$FCDF,$FD7F,$FDDF,$FC1F,$5DC5,$1DDF,$5DDD,$1DC1
		dc.w	$F000,$F7FF,$F7FF,$F000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$003B,$FFBB,$FFBB,$003B
		dc.w	$0EC0,$AEEF,$2ECF,$0EC0,$0760,$F774,$F764,$0760
		dc.w	$7030,$7170,$7130,$7030,$5DC3,$1DD7,$5DD3,$1DC3
		dc.w	$0000,$07FF,$07FF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$003B,$FFBB,$FFBB,$003B
		dc.w	$8EE0,$AEEF,$AEEF,$8EE0,$0770,$F777,$F777,$0770
		dc.w	$7077,$7770,$7777,$7070,$DDC7,$1DD7,$DDD7,$1DC7
		dc.w	$0000,$7FFF,$7FFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$003B,$FFBB,$FFBB,$003B
		dc.w	$8EE0,$AEEF,$AEEF,$8EE0,$0770,$F777,$F777,$0770
		dc.w	$7077,$7770,$7777,$7070,$DDC7,$1DD7,$DDD7,$1DC7
		dc.w	$0000,$7FFF,$7FFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$003B,$FFBB,$FFBB,$003B
		dc.w	$8EE0,$AEEF,$AEEF,$8EE0,$0770,$F777,$F777,$0770
		dc.w	$7077,$7770,$7777,$7070,$DDC7,$1DD7,$DDD7,$1DC7
		dc.w	$0000,$7FFF,$7FFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$01BB,$FE3B,$FFBB,$003B
		dc.w	$8EE0,$AEEF,$AEEF,$8EE0,$0770,$F777,$F777,$0770
		dc.w	$7077,$7770,$7777,$7070,$DDC7,$1DD7,$DDD7,$1DC7
		dc.w	$0000,$7FFF,$7FFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$01BB,$FE3B,$FFBB,$003B
		dc.w	$8EE0,$AEEF,$AEEF,$8EE0,$0770,$F777,$F777,$0770
		dc.w	$7077,$7770,$7777,$7070,$DDC7,$1DD7,$DDD7,$1DC7
		dc.w	$0000,$7FFF,$7FFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$01BB,$FE3B,$FFBB,$003B
		dc.w	$0EE0,$AEEF,$2EEF,$0EE0,$0770,$F777,$F777,$0770
		dc.w	$7031,$7770,$7731,$7030,$DD83,$1DD7,$DD93,$1D83
		dc.w	$0000,$1FFF,$1FFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$01BE,$FE3F,$FFBE,$003E
		dc.w	$8EE0,$EEE8,$EEE8,$0EE0,$0770,$1777,$1777,$0770
		dc.w	$70DD,$777F,$77DD,$701C,$DF45,$1FFF,$DF7D,$1F01
		dc.w	$D000,$FFFF,$DFFF,$C000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0038,$FFB8,$FFB8,$0038
		dc.w	$0EE3,$EEEB,$EEEB,$0EE3,$C770,$D777,$D777,$C770
		dc.w	$7006,$77C7,$77C6,$7006,$1D80,$5DDC,$5D9C,$1D80
		dc.w	$6000,$77FF,$67FF,$6000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0038,$FFBB,$FFBB,$0038
		dc.w	$0EE0,$EEE8,$EEE8,$0EE0,$0770,$1777,$1777,$0770
		dc.w	$7007,$77F7,$77F7,$7007,$1DC0,$5DDF,$5DDF,$1DC0
		dc.w	$7000,$77FF,$77FF,$7000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0038,$FFBB,$FFBB,$0038
		dc.w	$0EE0,$EEEF,$EEEF,$0EE0,$0770,$F777,$F777,$0770
		dc.w	$7007,$77F7,$77F7,$7007,$1DC0,$5DDF,$5DDF,$1DC0
		dc.w	$7000,$77FF,$77FF,$7000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0038,$FFBB,$FFBB,$0038
		dc.w	$0EE0,$EEEF,$EEEF,$0EE0,$0770,$F777,$F777,$0770
		dc.w	$7007,$77F7,$77F7,$7007,$1DC0,$5DDF,$5DDF,$1DC0
		dc.w	$7000,$77FF,$77FF,$7000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0038,$FFBB,$FFBB,$0038
		dc.w	$0EE0,$EEEF,$EEEF,$0EE0,$0770,$F777,$F777,$0770
		dc.w	$7007,$77F7,$77F7,$7007,$1DC0,$5DDF,$5DDF,$1DC0
		dc.w	$7000,$77FF,$77FF,$7000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0038,$FFBB,$FFBB,$0038
		dc.w	$0EE0,$EEEF,$EEEF,$0EE0,$0770,$F777,$F777,$0770
		dc.w	$7007,$77F7,$77F7,$7007,$1DC0,$5DDF,$5DDF,$1DC0
		dc.w	$70F0,$770F,$77FF,$7000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0038,$FFBB,$FFBB,$0038
		dc.w	$0EE0,$EEEF,$EEEF,$0EE0,$0770,$F777,$F777,$0770
		dc.w	$7007,$77F7,$77F7,$7007,$1DC0,$5DDF,$5DDF,$1DC0
		dc.w	$70F0,$770F,$77FF,$7000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0038,$FFBB,$FFBB,$0038
		dc.w	$0EC0,$EEEF,$EECF,$0EC0,$0760,$F774,$F764,$0760
		dc.w	$7006,$7107,$7106,$7006,$1DC0,$5DD0,$5DD0,$1DC0
		dc.w	$60F0,$770F,$67FF,$6000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0038,$FFBB,$FFBB,$0038
		dc.w	$0FA0,$EFFF,$EFBF,$0F80,$07D1,$F7FD,$F7DD,$07C1
		dc.w	$FC7D,$FD7F,$FD7D,$FC7C,$1DC7,$DDD7,$DDD7,$1DC7
		dc.w	$D0F0,$FF0F,$DFFF,$C000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FF83,$FF83,$0000
		dc.w	$0000,$E03F,$E03F,$0000,$0000,$F01C,$F01C,$0000
		dc.w	$0000,$0101,$0101,$0000,$0000,$C010,$C010,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFC0,$FFFF,$0000,$0000,$000F,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFC0,$FFFF,$0000,$0000,$000F,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFC0,$FFFF,$0000,$0000,$000F,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFC0,$FFFF,$0000,$0000,$000F,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFC0,$FFFF,$0000,$0000,$000F,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFC0,$FFFF,$0000,$0000,$000F,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFC0,$FFFF,$0000,$0000,$000F,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$003F,$003F,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FC00,$FC00
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFC0,$003F,$0000,$FFFF,$000F,$FFF0,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFC0,$003F,$0000,$FFFF,$000F,$FFF0,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFC0,$003F,$0000,$FFFF,$000F,$FFF0,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFC0,$003F,$0000,$FFFF,$000F,$FFF0,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFC0,$003F,$0000,$FFFF,$000F,$FFF0,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFC0,$003F,$0000,$FFFF,$000F,$FFF0,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFC0,$003F,$0000,$FFFF,$000F,$FFF0,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFC0,$003F,$0000,$FFFF,$000F,$FFF0,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FE3F,$FFC0,$01FF,$0000,$FFFF,$000F,$FFF0,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FE3F,$FFC0,$01FF,$0000,$FFFF,$000F,$FFF0,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FE07,$FFFF,$01F8,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FE07,$FFFF,$01F8,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFE,$0001,$0000
		dc.w	$FF87,$007F,$FFF8,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFE,$0001,$0000
		dc.w	$FF87,$007F,$FFF8,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFE,$0001,$0000
		dc.w	$FFFF,$007F,$FF80,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFE,$0001,$0000
		dc.w	$FFFF,$007F,$FF80,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$003F,$003F,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FC00,$FC00
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFE,$FFFF,$0000
		dc.w	$0000,$007F,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFE,$FFFF,$0000
		dc.w	$0000,$007F,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFE,$FFFF,$0000
		dc.w	$0000,$007F,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFE,$FFFF,$0000
		dc.w	$0000,$007F,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFE,$FFFF,$0000
		dc.w	$0000,$007F,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FE3C,$FFE3,$01FF,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FE3C,$FFE3,$01FF,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FE3C,$FFE3,$01FF,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FE3C,$FFE3,$01FF,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FE3C,$FFE3,$01FF,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FE38,$FFE0,$01FF,$0020,$0000,$0FFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FE38,$FFE0,$01FF,$0020,$0000,$0FFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FE38,$FFE0,$01FF,$0020,$0000,$0FFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$001F,$FFE0,$FFFF,$0000,$E7FF,$1FFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFF8,$003F,$0020,$0000,$0FFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$001F,$FFE0,$FFFF,$0000,$E7FF,$1FFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFF8,$003F,$0020,$0000,$0FFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$001F,$FFE0,$FFFF,$0000,$E7FF,$1FFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFF8,$003F,$0020,$0000,$0FFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$001F,$FFE0,$FFFF,$0000,$E7FF,$1FFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFF8,$003F,$0020,$0000,$0FFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$001F,$FFE0,$FFFF,$0000,$E7FF,$1FFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$001F,$FFE0,$FFFF,$0000,$E7FF,$1FFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$001F,$FFE0,$FFFF,$0000,$E7FF,$1FFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$001F,$FFE0,$FFFF,$0000,$E7FF,$1FFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$03FF,$FC00,$FFFF,$0000,$E000,$1FFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$03FF,$FC00,$FFFF,$0000,$E000,$1FFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$03FF,$FC00,$FFFF,$0000,$E000,$1FFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$03FF,$FC00,$FFFF,$0000,$E000,$1FFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$03FF,$FC00,$FFFF,$0000,$E000,$1FFF,$FFFF,$0000
		dc.w	$003C,$FFC3,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$03FF,$FC00,$FFFF,$0000,$E000,$1FFF,$FFFF,$0000
		dc.w	$003C,$FFC3,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$03FF,$FC00,$FFFF,$0000,$E000,$1FFF,$FFFF,$0000
		dc.w	$003C,$FFC3,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$03FF,$FC00,$FFFF,$0000,$E000,$1FFF,$FFFF,$0000
		dc.w	$003C,$FFC3,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$03FF,$FC00,$FFFF,$0000,$E000,$1FFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$03FF,$FC00,$FFFF,$0000,$E000,$1FFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$03FF,$FC00,$FFFF,$0000,$E000,$1FFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$03FF,$FC00,$FFFF,$0000,$E000,$1FFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FF00,$FFFF,$0000,$0000,$01FF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FF00,$FFFF,$0000,$0000,$01FF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FF00,$FFFF,$0000,$0000,$01FF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FF00,$FFFF,$0000,$0000,$01FF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$3C00,$C3FF,$FFFF,$0000
		dc.w	$0000,$FF00,$FFFF,$0000,$0000,$01FF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$E4FF,$FF00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$3C00,$C3FF,$FFFF,$0000
		dc.w	$0000,$FF00,$FFFF,$0000,$0000,$01FF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$E4FF,$FF00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$3C00,$C3FF,$FFFF,$0000
		dc.w	$0000,$FF00,$FFFF,$0000,$0000,$01FF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$E4FF,$FF00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$3C00,$C3FF,$FFFF,$0000
		dc.w	$0000,$FF00,$FFFF,$0000,$0000,$01FF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$E4FF,$FF00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FF00,$FFFF,$0000,$0000,$01FF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$E4FF,$FF00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FF00,$FFFF,$0000,$0000,$01FF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$000F,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FF00,$FFFF,$0000,$0000,$01FF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$000F,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FF00,$FFFF,$0000,$0000,$01FF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$000F,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$E020,$1FFF,$0020,$0000,$3FFF,$FFFF,$0000
		dc.w	$0000,$FF00,$FFFF,$0000,$0000,$01FF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$000F,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$E020,$1FFF,$0020,$0000,$3FFF,$FFFF,$0000
		dc.w	$0000,$FF00,$FFFF,$0000,$0000,$01FF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$000F,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$E020,$1FFF,$0020,$0000,$3FFF,$FFFF,$0000
		dc.w	$0000,$FF00,$FFFF,$0000,$0000,$01FF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$000F,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$E020,$1FFF,$0020,$0000,$3FFF,$FFFF,$0000
		dc.w	$0000,$FF00,$FFFF,$0000,$0000,$01FF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$000F,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$E020,$1FFF,$0020,$0000,$3FFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$000F,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$E020,$1FFF,$0020,$0000,$3FFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$000F,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$E020,$1FFF,$0020,$0000,$3FFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$000F,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$E020,$1FFF,$0020,$0000,$3FFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$000F,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$E020,$1FFF,$0020,$0000,$3FFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$000F,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$E020,$1FFF,$0020,$0000,$3FFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$E020,$1FFF,$0020,$0000,$3FFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$E020,$1FFF,$0020,$01FF,$3E00,$FFFF,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0FF0,$F00F,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$E020,$1FFF,$0020,$01FF,$3E00,$FFFF,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0FF0,$F00F,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$E020,$1FFF,$0020,$01FF,$3E00,$FFFF,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0FF0,$F00F,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$E020,$1FFF,$0020,$01FF,$3E00,$FFFF,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0FF0,$F00F,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$E020,$1FFF,$0020,$01FF,$3E00,$FFFF,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0FF0,$F00F,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$E020,$1FFF,$0020,$01FF,$3E00,$FFFF,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0FF0,$F00F,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$E020,$1FFF,$0020,$01FF,$3E00,$FFFF,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0FF0,$F00F,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$01FF,$FE00,$FFFF,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0FF0,$F00F,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$01FF,$FE00,$FFFF,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$01FF,$FE00,$FFFF,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$01FE,$FE01,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$01FE,$FE01,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$01FE,$FE01,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$01FE,$FE01,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$01FE,$FE01,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$01FE,$FE01,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$01FE,$FE01,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$01FE,$FE01,$FFFF,$0000
		dc.w	$FF00,$00FF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$FF00,$00FF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$FF00,$00FF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFE0,$FFFF,$003F,$0020,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$FF00,$00FF,$FFFF,$0000,$07FF,$FFFF,$FC00,$0400
		dc.w	$F000,$F000,$1000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$001F,$0010,$0010
		dc.w	$FFFF,$FFFF,$003F,$003F,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FC00,$FC00
		dc.w	$FFFF,$FFFF,$1FFF,$1FFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFF0,$FFF0
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$00FF,$FFFF,$FF00,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$00FF,$FFFF,$FF00,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$00FF,$FFFF,$FF00,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
	even

stop_mouse 	dc.b 	$12
go_mouse   	dc.b 	$8
conterm		ds.w	1 
         
nextc:DC.B      $00,$00 
PT_TEXT:DC.L      TEXTE 
pfonte:DC.B      $00,$00,$05,'P',$00,$00,$05,'P' 
      DC.B      $00,$00,$05,'P',$00,$00,$05,'P' 
      DC.B      $00,$00,$05,'P',$00,$00,$05,'P' 
      DC.B      $00,$00,$05,'P',$00,$00,$05,'P' 
      DC.B      $00,$00,$05,'P',$00,$00,$05,'P' 
      DC.B      $00,$00,$05,'P',$00,$00,$05,'P' 
      DC.B      $00,$00,$05,'P',$00,$00,$05,'P' 
      DC.B      $00,$00,$05,'P',$00,$00,$05,'P' 
      DC.B      $00,$00,$05,'P',$00,$00,$05,'P' 
      DC.B      $00,$00,$05,'P',$00,$00,$05,'P' 
      DC.B      $00,$00,$05,'P',$00,$00,$05,'P' 
      DC.B      $00,$00,$05,'P',$00,$00,$05,'P' 
      DC.B      $00,$00,$05,'P',$00,$00,$05,'P' 
      DC.B      $00,$00,$05,'P',$00,$00,$05,'P' 
      DC.B      $00,$00,$05,'P',$00,$00,$05,'P' 
      DC.B      $00,$00,$05,'P',$00,$00,$05,'P' 
      DC.B      $00,$00,$05,'P',$00,$00,$00,'x' 
      DCB.W      11,0
      DC.B      $00,'q',$00,$00,$00,$81,$00,$00 
      DC.B      $00,$88,$00,$00,$00,$00,$00,$00 
      DCB.W      2,0 
      DC.B      $00,'i',$00,$00,$00,$80,$00,$00 
      DC.B      $00,'h',$00,$00,$00,$00,$00,$00 
      DC.B      $00,$89,$00,$00,$00,$90,$00,$00 
      DC.B      $00,$91,$00,$00,$00,$98,$00,$00 
      DC.B      $00,$99,$00,$00,$05,$00,$00,$00 
      DC.B      $05,$01,$00,$00,$05,$08,$00,$00 
      DC.B      $05,$09,$00,$00,$05,$10,$00,$00 
      DC.B      $00,'p',$00,$00,$00,$00,$00,$00 
      DCB.W      6,0 
      DC.B      $00,'y',$00,$00,$00,$00,$00,$00 
      DCB.W      2,0 
      DC.B      $00,$01,$00,$00,$00,$08,$00,$00 
      DC.B      $00,$09,$00,$00,$00,$10,$00,$00 
      DC.B      $00,$11,$00,$00,$00,$18,$00,$00 
      DC.B      $00,$19,$00,$00,$00,' ',$00,$00 
      DC.B      $00,'!',$00,$00,$00,'(',$00,$00 
      DC.B      $00,')',$00,$00,$00,'0',$00,$00 
      DC.B      $00,'1',$00,$00,$00,'8',$00,$00 
      DC.B      $00,'9',$00,$00,$00,'@',$00,$00 
      DC.B      $00,'A',$00,$00,$00,'H',$00,$00 
      DC.B      $00,'I',$00,$00,$00,'P',$00,$00 
      DC.B      $00,'Q',$00,$00,$00,'X',$00,$00 
      DC.B      $00,'Y',$00,$00,$00,'`',$00,$00 
      DC.B      $00,'a',$00,$00,$05,'P',$00,$00 
      DC.B      $05,'P',$00,$00,$05,'P',$00,$00 
      DC.B      $05,'P',$00,$00,$05,'P',$00,$00 
      DC.B      $05,'P',$00,$00,$05,'P',$00,$00 
      DC.B      $05,'P',$00,$00,$05,'P',$00,$00 
      DC.B      $05,'P' 
TEXTE:DC.B      '                             '
      DC.B      'TCE PRESENTS IN COOPERATION W'
      DC.B	'ITH ZORRO2 OF MJJ PROD THE BS'
      DC.B	'W DEMO COMPACT DISK 120. THE '
      DC.B	'CREDITS FOR THIS INTRO ..... '
      DC.B	'CODING: ZORRO 2 OF MJJ PROD .'
      DC.B	'.... GFX: F.F. ..... CHIPMUZA'
      DC.B	'X FROM EXCELLENCE IN ART ..... SCROLLT'
      DC.B	'EXT, COMPILATION, PACKING AND'
      DC.B	' REPACKING DEMOSTUFF BY THE B'
      DC.B	'YTE OF TCE ..... CRC CHECK BY'
      DC.B	' MSD (POV) ..... RELEASE DATE'
      DC.B	': 25.09.2004 ..... THE FOLLOW'
      DC.B	'ING DEMO CONDITION ITSELF ON '
      DC.B	'THIS COMPILATION KEY F1 - 3D '
      DC.B	'FULL DEMO BY OXYGENE (LEONARD'
      DC.B	'S FIRST STE SCREEN) KEY F2 - '
      DC.B	'SUMMER 2K1 ONLINE COMPETITION'
      DC.B	' DEMO KEY F3 - NTR STE SCREEN'
      DC.B	' KEY F4 - THE DOTS DANCE DENT'
      DC.B	'RO F5 - TRAUMA 2 BY RECALL F6'
      DC.B	' - THE ACHEMENT BIEN DEMO BY '
      DC.B	'RECALL KEY F7 - OSMOZE DEMO I'
      DC.B	'I BY RECALL KEY F8 - FLEXICHR'
      DC.B	'ON DEMO BY FLEXICHRON AND LAS'
      DC.B	'T BUT NOT LEAST KEY F9 - THE '
      DC.B	'SUMMER 2K1 ONLINE COMPO DOCFI'
      DC.B	'LE (COMPORESULTS AND THE CRED'
      DC.B	'ITSFILE FOR THE ONLINE COMPO '
      DC.B	'DEMO). BASH THE SPACE KEY FOR'
      DC.B	' THE CRC DISKCHECK PROGRAM. N'
      DC.B	'OW FAST THE THANK SAYING.....'
      DC.B	' BIG THANX AT MARCER FOR THE '
      DC.B	'MANY DEMO DISKS AND FILES, WI'
      DC.B	'THOUT WHICH THIS COMPILATIONS'
      DC.B	'ERIES WOULD BE NO LONGER CONC'
      DC.B	'EIVABLE ..... BRUME FOR THE E'
      DC.B	'XCELLENT SUPPORT AND ITS WORK'
      DC.B	' IN THE WORLD WIDE WEB ..... '
      DC.B	'ZORRO 2 FOR THE PROGRAMMING O'
      DC.B	'F THIS INTRO ..... C-REM FOR '
      DC.B	'THE FORWARDING OF THE UNRELEA'
      DC.B	'SED STE FULLSCREEN DEMO FROM '
      DC.B	'DCD 117 ..... SIMON SUNNYBOY '
      DC.B	'FOR THE ASSISTANCE WHEN PROGR'
      DC.B	'AMMING ..... AND ALL ACTIVE M'
      DC.B	'EMBERS OF WWW.ATARI-FORUM.COM'
      DC.B	' FOR THE SUGGESTIONS, CRITICI'
      DC.B	'SMS AND REACTIONS, FAR ONES T'
      DC.B	'O MAKING. WITHOUT YOU THE COM'
      DC.B	'PILATION SERIES WOULD NOT HAV'
      DC.B	'E BEEN LED FAR ONES!!!! OK, GU'
      DC.B	'YS! HERE COMES THE OFFICIAL G'
      DC.B	'REETINGS IN MORE OR LITTLE AL'
      DC.B	'PHABETICAL ORDER ..... GREETS'
      DC.B	' GO TO.... ACF, ANARCHY, AUTO'
      DC.B	'MATION, ADRENALINE, ANIMAL MI'
      DC.B	'NE, ADMIRABLES, ANATOMICA, AL'
      DC.B	'LIANCE (GERMAN AND FRENCH), A'
      DC.B	'TARI FORCE, ATOMIC, AWESOME, '
      DC.B	'BLACK CATS, BLIND BASTARD, BU'
      DC.B	'DGIE UK, BRUME, BODKINZ, BBC,'
      DC.B	' BLUES BROTHERS, CONCEPTORS, '
      DC.B	'CRACK CONNEXION, CRAZY BOYS, '
      DC.B	'CYNIX, CRIME, D-BUG, DEATH, D'
      DC.B	'ISK MAP CREW, DODGYSOFT, DREA'
      DC.B	'MWEAVERS, DELTA FORCE, DETONA'
      DC.B	'TORS, ENERGETIC, EAGLES, EFFE'
      DC.B	'CT, ELECTRONIC IMAGES, ELITE,'
      DC.B	' ENIGMA, EUROSWAP, EQUINOX, F'
      DC.B	'REDDY, FUTURE MINDS, FUSION, '
      DC.B	'FUZION, FOFT, FOF, G-FORCE, G'
      DC.B	'ENESIS INC., GOLDEN DAWN, GRI'
      DC.B	'NDER, GRAVATICS, HACKBEAR, HE'
      DC.B	'MOROIDS, IMAGINA, INTERSTELLA'
      DC.B	'R, INNER CIRCLE, IMPACT, KUBA'
      DC.B	', KGB, KLAPAUZIUS, LEMMINGS, '
      DC.B	'LEGION, LOTEK STYLE, MAD VISI'
      DC.B	'ON, MJJ PROD, MUG UK, MEDWAY '
      DC.B	'BOYS, NAPALM SOLDIERS, NEW TR'
      DC.B	'END, NEON LIGHTS, NEW ORDER, '
      DC.B	'NEXT, NOTHING PERSONAL, NOW 5'
      DC.B	', OFFBEAT, OVERLANDERS, PARAD'
      DC.B	'IZE, PAYBAX, PHF, POV, PIXEL '
      DC.B	'TWINS, PULSE, PULSION, POMPEY'
      DC.B	' PIRATES, PROPHECY PD, PURE E'
      DC.B	'NERGY, REPLICANTS, RIPPED OFF'
      DC.B	', REANIMATORS, REVOLUTION, SE'
      DC.B	'WER SOFTWARE, SECTION ONE, SE'
      DC.B	'RENADE, SPECIAL FX, SLAYTANIC'
      DC.B	' CULT, ST CNX, STRANGER, STAX'
      DC.B	', SUPREMACY, SHAOLIN MASTERS,'
      DC.B	' TBB, TBE, TCC ,TCB, THE SOUR'
      DC.B	'CE, TDC, THE GERMS, TNB, TUMU'
      DC.B	'LT, TSB, TSN, TSCC, TWB, TYPH'
      DC.B	'OON, THE SYNDICATE, UNITY, UN'
      DC.B	'DERGROUND, UTOS, XENEX DEMOZO'
      DC.B	'NE, XSTATIC, ZARMI AND ZUUL..'
      DC.B	'.... THAT IS EVERYTHING.... U'
      DC.B	'P TO THE NEXT ONE COMPILATION'
      DC.B	' IT IS NOT LONG WE MAKING OF '
      DC.B	'FAR ONES..... BYE BYE AND MUC'
      DC.B	'H FUN STILL WITH THIS DEMO CO'
      DC.B	'MPACT DISK....               '
      DC.B      $FF,$00
BUFFER:DCB.W      34,0
      DC.B      $01,$10,$02,'!',$03,'1',$04,'B' 
      DC.B      $05,'R',$06,'c',$07,'t' 
pcarac:DC.B      '|',$E4,$A2,$FA,'|',$FC,$FE,$FE 
      DC.B      ',',$B8,$D2,'n~',$FC,$FE,$FE
      DC.B      '\,',$F6,$D6,'~~',$FE,$FE 
      DC.B      ':F',$FC,$80,'~',$C6,$FE,$C6
      DC.B      '0',$06,$00,$04,'0',$06,'0',$06 
      DC.B      $C4,$C0,$02,'@',$C6,$C0,$C6,$C0 
      DC.B      ' ',$00,$FE,$FE,'||',$FE,$FE
      DC.B      $00,$F0,$FE,$EE,'|',$FC,$FE,$FE 
      DC.B      $10,$00,$EE,$FE,'|',$FC,$FE,$FE 
      DC.B      '^',$FE,$EA,$C0,'~',$FC,$FE,$FE 
      DC.B      $06,$C2,$C6,$06,$C6,$C6,$C6,$C6 
      DC.B      $84,$82,$C2,$C6,$C6,$C6,$C6,$C6 
      DC.B      $02,'*',$C4,$D4,$C6,$FE,$C6,$FE 
      DCB.W      4,0 
      DC.B      $00,' ',$00,'0',$00,'0',$00,'0' 
      DC.B      ' ',$A8,$10,'~0',$FC,'0',$FE
      DC.B      $00,$02,$00,$1E,$00,$0E,$00,$1E 
      DC.B      '`@',$B0,$BE,$E0,'|',$F0,$FE
      DC.B      '8',$B8,'@Fp',$FC,'x',$FE 
      DC.B      $E8,$86,$96,$C0,$FC,$C6,$FE,$C6 
      DC.B      $86,'B',$C6,$C6,$84,$84,$C6,$C6 
      DC.B      $C0,$06,'@',$C2,$80,$84,$C0,$C6 
      DC.B      '@',$00,$C0,$C0,$80,$80,$C0,$C0 
      DC.B      $80,'B@',$C6,$80,$84,$C0,$C6
      DC.B      $10,$02,'0',$06,' ',$04,'0',$06 
      DC.B      'F',$C0,$C6,$C0,$84,$80,$C6,$C0 
      DC.B      $C6,'FV',$C2,$94,$84,$D6,$C6
      DC.B      'B',$C6,$C6,'F',$84,$84,$C6,$C6 
      DC.B      'F',$82,$C2,$C6,$84,$84,$C6,$C6 
      DC.B      $00,$00,$C0,$06,$80,$04,$C0,$06 
      DC.B      'BB',$C6,$C6,$84,$84,$C6,$C6
      DC.B      $C2,$C6,'F',$C2,$84,$84,$C6,$C6 
      DC.B      $C2,$02,'F',$06,$84,$04,$C6,$06 
      DCB.W      4,0 
      DC.B      ' 00',$10,'0 00'
      DC.B      ' ',$02,'0',$06,' ',$04,'0',$06 
      DC.B      $00,$08,$00,$18,$00,$10,$00,$18 
      DC.B      $10,$C6,'0N ',$8C,'0',$CE 
      DC.B      $10,$06,$08,$02,$10,$04,$18,$06 
      DC.B      $06,$86,$02,$C2,$04,$84,$06,$C6 
      DC.B      $86,'~',$FE,$C0,$BC,$BC,$FE,$FE 
      DC.B      $80,$82,$C0,$C6,$80,$84,$C0,$C6 
      DC.B      $B0,$B0,$E8,'h',$B8,$B8,$F8,$F8 
      DC.B      $80,'N',$DE,$F6,$9E,$BC,$DE,$FE 
      DC.B      ' ',$00,$10,$06,' ',$04,'0',$06 
      DC.B      $D2,$C0,'|',$C0,$B8,$80,$FE,$C0 
      DC.B      $C4,$C2,'VF',$94,$84,$D6,$C6
      DC.B      $02,$94,$C6,'~',$84,$BC,$C6,$FE 
      DC.B      $82,$EE,$C6,'t',$84,$B8,$C6,$FE 
      DC.B      $BE,$02,'P',$06,'<',$04,$FE,$06 
      DC.B      $C4,$06,$C2,$C6,$84,$84,$C6,$C6 
      DC.B      $C6,'dB',$BE,$84,'x',$C6,$FE
      DC.B      $B6,$04,'z',$FE,'<x',$FE,$FE
      DCB.W      4,0 
      DC.B      $10,'00',$10,' ',$00,'00' 
      DC.B      '0|0û x0',$FE 
      DC.B      'x',$08,'\',$18,'|',$10,'|',$18 
      DC.B      $10,$DA,'0^ î0',$DE 
      DC.B      $00,'|',$18,$EE,$10,'x',$18,$FE 
      DC.B      $1E,$BE,'4R8<>',$FE 
      DC.B      'B',$C0,$C6,'F',$84,$84,$C6,$C6 
      DC.B      $C0,$C6,'@',$C6,$80,$84,$C0,$C6 
      DC.B      $C0,$C0,$C0,$C0,$80,$80,$C0,$C0 
      DC.B      'D',$06,$C2,$C6,$84,$84,$C6,$C6 
      DC.B      $10,$06,'0',$06,' ',$04,'0',$06 
      DC.B      $C4,'@B',$C0,$84,$80,$C6,$C0
      DC.B      $C4,$C4,'BB',$84,$84,$C6,$C6
      DC.B      $C2,'@',$C6,$C0,$84,$80,$C6,$C0 
      DC.B      $C0,$C6,'F',$C6,$84,$84,$C6,$C6 
      DC.B      $00,$02,$06,$06,$04,$04,$06,$06 
      DC.B      $C2,'FF',$C2,$84,$84,$C6,$C6
      DC.B      $C6,$02,$C2,$C6,$84,$84,$C6,$C6 
      DC.B      $06,$C0,$06,'@',$04,$80,$06,$C0 
      DCB.W      4,0 
      DC.B      $00,' ',$00,$10,$00,' ',$00,'0' 
      DC.B      $10,$C0,'0@ ',$80,'0',$C0 
      DC.B      $00,$18,$00,$18,$00,$10,$00,$18 
      DC.B      '0h0',$D6,' ',$A4,'0',$FE 
      DC.B      $10,$80,$18,$C0,$10,$80,$18,$C0 
      DC.B      $04,$00,$06,$06,$04,$04,$06,$06 
      DC.B      $C4,$86,'B',$C6,$84,$84,$C6,$C6 
      DC.B      '@',$82,$C0,$C6,$80,$84,$C0,$C6 
      DC.B      $80,$C0,$C0,'@',$80,$80,$C0,$C0 
      DC.B      'B',$C6,$C6,'F',$84,$84,$C6,$C6 
      DC.B      ' ',$04,$10,$06,' ',$04,'0',$06 
      DC.B      $80,$C0,$C6,$C0,$84,$80,$C6,$C0 
      DC.B      'BB',$C6,$C6,$84,$84,$C6,$C6
      DC.B      $06,$C0,$C6,'@',$84,$80,$C6,$C0 
      DC.B      $82,'FF',$C6,$84,$84,$C6,$C6
      DC.B      $00,$06,$06,$06,$04,$04,$06,$06 
      DC.B      'F,',$C2,$EE,$84,'H',$C6,$EE
      DC.B      $C0,$06,$D6,$C6,$94,$84,$D6,$C6 
      DC.B      $00,$80,$06,'@',$04,$80,$06,$C0 
      DC.B      $00,$00,$00,'0',$00,'0',$00,'0' 
      DC.B      ' ',$00,$10,$00,'0',$00,'0',$00 
      DC.B      '0@',$10,$C0,' ',$80,'0',$C0
      DC.B      $00,$18,$00,$08,$00,$10,$00,$18 
      DC.B      $10,$F6,'0',$E2,' Ñ0',$F6 
      DC.B      $18,$00,$18,$C0,$10,$80,$18,$C0 
      DC.B      $02,$06,$06,$02,$04,$04,$06,$06 
      DC.B      $86,$C2,$C6,$C6,$84,$84,$C6,$C6 
      DC.B      '@F',$C0,$C6,$80,$84,$C0,$C6
      DC.B      $C0,'@@',$C0,$80,$80,$C0,$C0
      DC.B      $C0,'D',$C6,$C2,$84,$84,$C6,$C6 
      DC.B      $10,$80,'0',$C6,' ',$C4,'0',$C6 
      DC.B      $C6,$00,$C6,$C0,$84,$80,$C6,$C0 
      DC.B      'F',$C2,$C6,$C6,$84,$84,$C6,$C6 
      DC.B      $82,$C0,$C6,$C0,$84,$80,$C6,$C0 
      DC.B      $00,$86,$C0,'F',$80,$84,$C0,$C6 
      DC.B      $06,$04,$06,$02,$04,$04,$06,$06 
      DC.B      'B',$08,$C6,'|Ñ0',$C6,'|' 
      DC.B      $C0,'D',$D6,$C6,$94,$84,$D6,$C6 
      DC.B      $02,'@',$06,$C0,$04,$80,$06,$C0 
      DC.B      ' ',$10,'000 00'
      DC.B      '0',$00,$10,$00,' ',$00,'0',$00 
      DCB.W      4,0 
      DC.B      $00,$10,$00,$08,$00,$10,$00,$18 
      DC.B      '0',$A6,$10,'B Ñ0',$E6
      DC.B      $18,$80,$18,$C0,$10,$80,$18,$C0 
      DC.B      $02,$02,$06,$06,$04,$04,$06,$06 
      DC.B      $84,$F2,$C6,'l',$84,$BC,$C6,$FE 
      DC.B      'n(',$FE,$FE,'>',$BC,$FE,$FE
      DC.B      'F@',$FE,$C0,'>',$80,$FE,$C0
      DC.B      '~B',$F6,$C6,'<',$84,$FE,$C6
      DC.B      ' j0',$F4,' <0',$FE 
      DC.B      'BF',$C6,$F8,$84,'>',$C6,$FE
      DC.B      'B',$84,$C6,'B',$84,$84,$C6,$C6 
      DC.B      'L@',$FE,$C0,'<',$80,$FE,$C0
      DC.B      'j',$02,$D4,$C6,'>',$84,$FE,$C6 
      DC.B      $98,$06,$FE,$02,$FC,$04,$FE,$06 
      DC.B      'X',$00,$FE,'8<',$10,$FE,'8'
      DC.B      '~',$06,$C4,$C2,'<',$84,$FE,$C6 
      DC.B      $8C,'r',$F2,$CE,$FC,$BE,$FE,$FE 
      DC.B      '  0',$10,' ',$00,'00'
      DCB.W      4,0 
      DC.B      '0',$80,$10,'@0',$C0,'0',$C0
      DC.B      $00,$0E,$00,$1C,$00,$06,$00,$1E 
      DC.B      $C0,'T0',$FE,$E0,'<',$F0,$FE
      DC.B      $18,'|',$08,$FA,$10,$BE,$18,$FE 
      DC.B      $AC,$02,'r',$06,$FC,$04,$FE,$06 
      DC.B      $C0,$00,$C0,$00,$80,$00,$C0,$00 
      DCB.W      4,0 
      DC.B      $00,$C0,$00,$C0,$00,$80,$00,$C0 
      DC.B      $00,$C0,$00,'@',$00,$80,$00,$C0 
      DC.B      '0',$00,'0',$00,' ',$00,'0',$00 
      DC.B      $00,$00,$C0,$00,$80,$00,$C0,$00 
      DC.B      $C0,'@',$C0,$C0,$80,$80,$C0,$C0 
      DC.B      $00,'@',$00,$C0,$00,$80,$00,$C0 
      DC.B      $00,$80,$00,$C0,$00,$80,$00,$C0 
      DC.B      $00,$06,$00,$02,$00,$04,$00,$06 
      DCB.W      5,0 
      DC.B      $00,$C0,$00,$80,$00,$C0,$00,$00 
      DCB.W      3,0 
      DC.B      $00,'0',$00,$00,$00,' ',$00,'0' 
      DCB.W      16,0
      DC.B      $08,$00,$18,$00,$10,$00,$18,$00 
      DC.B      $00,$06,$00,$06,$00,$04,$00,$06 
      DC.B      $9C,'0~',$FE,$FE,'~',$FE,$FE
      DC.B      $DC,'nj',$DC,$FC,'|',$FE,$FE
      DC.B      '\',$00,$F2,$00,'|',$00,$FE,$00 
      DCB.W      68,0
      DC.B      $00,$80,$C0,'@',$80,$80,$C0,$C0 
      DC.B      $02,$C0,$06,'F',$04,$84,$06,$C6 
      DC.B      'B',$00,$C6,$00,$84,$00,$C6,$00 
      DCB.W      68,0
      DC.B      $B8,$EE,$F6,'p',$BC,$BC,$FE,$FE 
      DC.B      '>~',$1E,$80,'<|>',$FE
      DC.B      'z',$00,$F6,$00,'<',$00,$FE,$00 
      DCB.W      68,0
      DC.B      $06,$C0,$02,$C6,$04,$84,$06,$C6 
      DC.B      $00,'F',$06,$C2,$04,$84,$06,$C6 
      DC.B      $02,$00,$06,$00,$04,$00,$06,$00 
      DCB.W      68,0
      DC.B      $00,$C6,$06,'F',$04,$84,$06,$C6 
      DC.B      $02,$C6,$06,$C2,$04,$84,$06,$C6 
      DC.B      $06,$00,$06,$00,$04,$00,$06,$00 
      DCB.W      68,0
      DC.B      $06,$C6,$02,'F',$04,$84,$06,$C6 
      DC.B      $06,'@',$02,$C6,$04,$84,$06,$C6 
      DC.B      $02,$00,$06,$00,$04,$00,$06,$00 
      DCB.W      68,0
      DC.B      'X',$AC,$A6,'R',$FC,'<',$FE,$FE 
      DC.B      $02,$BE,$06,'`',$04,'<',$06,$FE 
      DC.B      $A4,$00,$DA,$00,$FC,$00,$FE,$00 
      DCB.W      72,0
      DC.B      $04,$00,$02,$00,$04,$00,$06,$00 
      DCB.W      217,0 
      DC.B      $02,$11,$03,'"',$04,'3',$05,'D' 
      DC.B      $06,'U',$07,'f',$07,'w',$03,'3' 
      DC.B      $07,'3',$03,'s',$07,'s',$03,'7' 
      DC.B      $07,'7',$07,$00,$07,'w' 
	even

panneau:    dc.b        $0,$0,$0,$0,$0,$0,$0,$0,'ˇ',$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,'ˇ',$0,$0,$0,$0,'ˇˇ',$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,'ˇ',$0,$0,'ˇ',$0,$0,'ˇ',$0,$0
	dc.b        $0,$0,'ˇˇ',$0,$0,'ˇˇˇ',$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,'ˇˇ',$0,$0,$0,$0,'ˇ',$0,$0,'ˇ',$0
	dc.b        $0,'ˇˇˇ',$0,$0,'ˇ',$0,$0,$0,$0,'ˇˇˇ',$0
	dc.b        $0,'ˇˇ',$0,$0,'ˇˇˇˇˇˇˇˇˇˇˇ',$0
	dc.b        $0,'ˇˇˇˇ',$0,$0,'ˇˇ',$0,$0,$0,$0,'ˇ'
	dc.b        'ˇˇˇ',$0,$0,'ˇ',$0,$0,'ˇ',$0,$0,'ˇˇ',$0
	dc.b        $0,$0,$0,'ˇ',$0,$0,$0,$0,$0,$0,'ˇˇˇˇ',$0
	dc.b        $0,$0,$0,'ˇˇ',$0,$0,'ˇ',$0,$0,'ˇ',$0,$0
	dc.b        $0,$0,$0,$0,'ˇ',$0,$0,'ˇˇ',$0,$0,$0,$0,$0
	dc.b        $0,'ˇ',$0,$0,$0,$0,'ˇ',$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,'ˇ',$0,$0,$0
	dc.b        $0,'ˇˇ',$0,$0,$0,$0,$0,$0,$0,$0,'ˇ',$0,$0
	dc.b        'ˇ',$0,$0,'ˇ',$0,$0,$0,$0,'ˇˇ',$0,$0,''
	dc.b        'ˇˇˇ',$0,$0,$0,$0,$0,$0,$0,$0,'ˇˇ',$0,$0
	dc.b        $0,$0,'ˇ',$0,$0,'ˇ',$0,$0,'ˇˇˇ',$0,$0,''
	dc.b        'ˇ',$0,$0,$0,$0,'ˇˇˇ',$0,$0,'ˇˇ',$0,$0
	dc.b        'ˇˇˇˇˇˇˇˇˇˇˇ',$0,$0,'ˇˇˇˇ',$0
	dc.b        $0,'ˇˇ',$0,$0,$0,$0,'ˇˇˇˇ',$0,$0,'ˇ',$0
	dc.b        $0,'ˇ',$0,$0,'ˇˇ',$0,$0,$0,$0,'ˇ',$0,$0
	dc.b        $0,$0,$0,$0,'ˇˇˇˇ',$0,$0,$0,$0,'ˇˇ',$0
	dc.b        $0,'ˇ',$0,$0,'ˇ',$0,$0,$0,$0,$0,$0,'ˇ',$0
	dc.b        $0,'ˇˇ',$0,$0,$0,$0,$0,$0,'ˇ',$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,'ˇˇ',$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,'ˇ',$0,$0,'ˇ',$0,$0,'ˇ',$0
	dc.b        $0,$0,$0,'ˇˇ',$0,$0,'ˇˇˇ',$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,'ˇˇ',$0,$0,$0,$0,'ˇ',$0,$0,'ˇ',$0
	dc.b        $0,'ˇˇˇ',$0,$0,'ˇ',$0,$0,$0,$0,'ˇˇˇ',$0
	dc.b        $0,'ˇˇ',$0,$0,'ˇˇˇˇˇˇˇˇˇˇˇ',$0
	dc.b        $0,'ˇˇˇˇ',$0,$0,'ˇˇ',$0,$0,$0,$0,'ˇ'
	dc.b        'ˇˇˇ',$0,$0,'ˇ',$0,$0,'ˇ',$0,$0,'ˇˇ',$0
	dc.b        $0,$0,$0,'ˇ',$0,$0,$0,$0,$0,$0,'ˇˇˇˇ',$0
	dc.b        $0,$0,$0,'ˇˇ',$0,$0,'ˇ',$0,$0,'ˇ',$0,$0
	dc.b        $0,$0,$0,$0,'ˇ',$0,$0,'ˇˇ',$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,''
	dc.b        'ˇ',$0,$0,'ˇ',$0,$0,'ˇ',$0,$0,$0,$0,'ˇˇ'
	dc.b        $0,$0,'ˇˇˇ',$0,$0,$0,$0,$0,$0,$0,$0,'ˇ'
	dc.b        'ˇ',$0,$0,$0,$0,'ˇ',$0,$0,'ˇ',$0,$0,'ˇˇ'
	dc.b        'ˇ',$0,$0,'ˇ',$0,$0,$0,$0,'ˇˇˇ',$0,$0,''
	dc.b        'ˇˇ',$0,$0,'ˇˇˇˇˇˇˇˇˇˇˇ',$0,$0,''
	dc.b        'ˇˇˇˇ',$0,$0,'ˇˇ',$0,$0,$0,$0,'ˇˇˇ'
	dc.b        'ˇ',$0,$0,'ˇ',$0,$0,'ˇ',$0,$0,'ˇˇ',$0,$0
	dc.b        $0,$0,'ˇ',$0,$0,$0,$0,$0,$0,'ˇˇˇˇ',$0,$0
	dc.b        $0,$0,'ˇˇ',$0,$0,'ˇ',$0,$0,'ˇ',$0,$0,$0
	dc.b        $0,$0,$0,'ˇ',$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,'ˇ',$0,$0,'ˇ',$0,$0,$0,$0,'ˇ'
	dc.b        'ˇ',$0,$0,'ˇˇˇ',$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        'ˇˇ',$0,$0,$0,$0,'ˇ',$0,$0,'ˇ',$0,$0,''
	dc.b        'ˇˇˇ',$0,$0,'ˇ',$0,$0,$0,$0,'ˇˇˇ',$0,$0
	dc.b        'ˇˇ',$0,$0,'ˇˇˇˇˇˇˇˇˇˇˇ',$0,$0
	dc.b        'ˇˇˇˇ',$0,$0,'ˇˇ',$0,$0,$0,$0,'ˇˇˇ'
	dc.b        'ˇ',$0,$0,'ˇ',$0,$0,'ˇ',$0,$0,'ˇˇ',$0,$0
	dc.b        $0,$0,'ˇ',$0,$0,$0,$0,$0,$0,'ˇˇˇˇ',$0,$0
	dc.b        $0,$0,'ˇˇ',$0,$0,'ˇ',$0,$0,'ˇ',$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,''
	dc.b        'ˇˇ',$0,$0,'ˇˇˇ',$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        'ˇˇ',$0,$0,$0,$0,'ˇ',$0,$0,'ˇ',$0,$0,''
	dc.b        'ˇˇˇ',$0,$0,'ˇ',$0,$0,$0,$0,'ˇˇˇ',$0,$0
	dc.b        'ˇˇ',$0,$0,'ˇˇˇˇˇˇˇˇˇˇˇ',$0,$0
	dc.b        'ˇˇˇˇ',$0,$0,'ˇˇ',$0,$0,$0,$0,'ˇˇˇ'
	dc.b        'ˇ',$0,$0,'ˇ',$0,$0,'ˇ',$0,$0,'ˇˇ',$0,$0
	dc.b        $0,$0,'ˇ',$0,$0,$0,$0,$0,$0,'ˇˇˇˇ',$0,$0
	dc.b        $0,$0,'ˇˇ',$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,'ˇˇˇ',$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,'ˇˇ',$0,$0,$0,$0,'ˇ',$0,$0,'ˇ',$0,$0
	dc.b        'ˇˇˇ',$0,$0,'ˇ',$0,$0,$0,$0,'ˇˇˇ',$0
	dc.b        $0,'ˇˇ',$0,$0,'ˇˇˇˇˇˇˇˇˇˇˇ',$0
	dc.b        $0,'ˇˇˇˇ',$0,$0,'ˇˇ',$0,$0,$0,$0,'ˇ'
	dc.b        'ˇˇˇ',$0,$0,'ˇ',$0,$0,'ˇ',$0,$0,'ˇˇ',$0
	dc.b        $0,$0,$0,'ˇ',$0,$0,$0,$0,$0,$0,'ˇˇˇˇ',$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,'ˇˇ',$0,$0,$0,$0,'ˇ'
	dc.b        $0,$0,'ˇ',$0,$0,'ˇˇˇ',$0,$0,'ˇ',$0,$0,$0
	dc.b        $0,'ˇˇˇ',$0,$0,'ˇˇ',$0,$0,'ˇˇˇˇˇ'
	dc.b        'ˇˇˇˇˇˇ',$0,$0,'ˇˇˇˇ',$0,$0,'ˇˇ',$0
	dc.b        $0,$0,$0,'ˇˇˇˇ',$0,$0,'ˇ',$0,$0,'ˇ',$0
	dc.b        $0,'ˇˇ',$0,$0,$0,$0,'ˇ',$0,$0,$0,$0,$0,$0
	dc.b        'ˇ',$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,'ˇ',$0,$0,$0,$0,'ˇ',$0,$0,'ˇ',$0
	dc.b        $0,'ˇˇˇ',$0,$0,'ˇ',$0,$0,$0,$0,'ˇˇˇ',$0
	dc.b        $0,'ˇˇ',$0,$0,'ˇˇˇˇˇˇˇˇˇˇˇ',$0
	dc.b        $0,'ˇˇˇˇ',$0,$0,'ˇˇ',$0,$0,$0,$0,'ˇ'
	dc.b        'ˇˇˇ',$0,$0,'ˇ',$0,$0,'ˇ',$0,$0,'ˇˇ',$0
	dc.b        $0,$0,$0,'ˇ',$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,'ˇ',$0,$0,'ˇˇ'
	dc.b        'ˇ',$0,$0,'ˇ',$0,$0,$0,$0,'ˇˇˇ',$0,$0,''
	dc.b        'ˇˇ',$0,$0,'ˇˇˇˇˇˇˇˇˇˇˇ',$0,$0,''
	dc.b        'ˇˇˇˇ',$0,$0,'ˇˇ',$0,$0,$0,$0,'ˇˇˇ'
	dc.b        'ˇ',$0,$0,'ˇ',$0,$0,'ˇ',$0,$0,'ˇ',$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        'ˇˇ',$0,$0,'ˇ',$0,$0,$0,$0,'ˇˇˇ',$0,$0
	dc.b        'ˇˇ',$0,$0,'ˇˇˇˇˇˇˇˇˇˇˇ',$0,$0
	dc.b        'ˇˇˇˇ',$0,$1,'ˇˇ',$0,$0,$0,$0,'ˇˇˇ'
	dc.b        'ˇ',$0,$0,'ˇ',$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,'ˇ'
	dc.b        'ˇˇ',$0,$0,'ˇˇ',$0,$0,'ˇˇˇˇˇˇˇˇ'
	dc.b        'ˇˇˇ',$0,$0,'ˇˇˇˇ',$0,$0,'ˇˇ',$0,$0
	dc.b        $0,$0,'ˇˇ',$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,'ˇ',$0,$0,'ˇˇ'
	dc.b        $0,$0,'ˇˇˇˇˇˇˇˇˇˇˇ',$0,$0,'ˇˇ'
	dc.b        'ˇˇ',$0,$0,'ˇˇ',$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,''
	dc.b        'ˇˇˇˇˇˇˇˇˇˇˇ',$0,$0,'ˇˇˇ',$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,'ˇˇˇˇˇˇˇˇ',$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,'Ä',$0,'Ä',$0
	dc.b        'Ä',$0,'Ä',$0,'Ä',$0,'Ä',$0,'Ä',$0,'Ä',$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	even

INIT_SND:    dc.b        '`',$0,$0,$A,'`',$0,$0,'“'
MUSIC:    dc.b        '`',$0,$1,'(HÁˇ˛a',$0,$0,'∆A˙',$C,'tC˙',$C,'0'
	dc.b        'E—&X∑¸ˇˇˇˇg&IÚ∏',$0,'&YKÚ∏',$0,'(ç`Ë',$C,$18
	dc.b        $0,'ˇf˙',$C,$10,$0,'TfÙRà',$C,$10,$0,'HfÏRà'
	dc.b        'NuA˙',$E,$A,'M˙',$C,'v,»a‹',$C,$10,$0,'?g',$C
	dc.b        $C,$10,$0,'KfÚRà,»`ÏRàM˙',$4,'>-H˝Haæ',$C,$10
	dc.b        $0,'Kf¯Rà,àa≤',$C,$10,$0,'Kf¯Rà-H',$2,'∂',$11
	dc.b        '¸',$0,$D,'à',$0,$11,'¸',$0,$A,'à',$2,'A˙',$9
	dc.b        'êC˙',$B,'n … … â z',$1,'J"z',$C,$1A,'$z',$3
	dc.b        '˙G—(z',$6,'™K”p',$0,'r',$0,'t',$0,'v',$0,'x'
	dc.b        $0,'z',$0,'|',$0,'~',$0,$8,'∏',$0,$0,$4,'Ñ`'
	dc.b        $0,$8,'‰HPA¯à',$0,'Bê º',$1,$1,$0,$0,' º',$2
	dc.b        $2,$0,$0,' º',$3,$3,$0,$0,' º',$4,$4,$0,$0,' '
	dc.b        'º',$5,$5,$0,$0,' º',$6,$6,$0,$0,' º',$7,$7
	dc.b        'ˇˇ º',$8,$8,$0,$0,' º',$9,$9,$0,$0,' º',$A
	dc.b        $A,$0,$0,' º',$B,$B,$0,$0,' º',$C,$C,$0,$0,' '
	dc.b        'º',$D,$D,$0,$0,' _NuHÁˇ˛L˙?ˇ',$8,'úM˙',$8,'‡'
	dc.b        'Q÷J@f',$0,$0,'¿r',$0,'M˙',$8,'’=|ˇˇ',$2,$5
	dc.b        'Bn',$0,$3,'Q÷',$12,$18,'"z',$8,'¥',$C,$1,$0
	dc.b        '˚e',$0,$0,'ò,<',$0,$0,$0,'ˇú',$1,'ÂN.;h',$6
	dc.b        'N˚x',$16,$0,$0,$0,'f',$0,$0,$0,'P',$0,$0,$0
	dc.b        'B',$0,$0,$0,',',$0,$0,$0,$0,'~',$0,$1C,$18
	dc.b        $1E,$18,$12,$10,'M˙',$8,'í',$1C,'áæ',$1,'e',$2
	dc.b        'D',$6,'M˙',$8,'}',$1C,'ÜM˙',$8,'∂ﬁG>6p',$0
	dc.b        'M˙',$A,'r<á`†M˙',$9,'dr',$0,$12,$18,'ÈAMˆ',$10
	dc.b        $0,'#Œ',$0,$0,$0,$0,'`ä',$12,$18,'D',$1,'M˙'
	dc.b        $8,'K',$1C,'Å`',$0,'ˇ~M˙',$A,'Í',$12,$18,'“'
	dc.b        'A“A#ˆ',$10,$0,$0,$0,$0,$0,'`',$0,'ˇVA˘',$0
	dc.b        $0,$0,$0,'`',$0,'ˇLp',$0,$10,$18,'¿¸',$0,$6
	dc.b        'S@',$C,$11,$0,'ˇg',$0,$1,'“M˙',$7,'∂',$1E,$19
	dc.b        $C,$7,$0,'ıe',$0,$1,':,<',$0,$0,$0,'˛ú',$7,'Â'
	dc.b        'N.;h',$6,'N˚x*',$0,$0,$0,$0,$0,$0,$0,$E,$0
	dc.b        $0,$0,$1C,$0,$0,$0,',',$0,$0,$0,'2',$0,$0,$0
	dc.b        '@',$0,$0,$0,'d',$0,$0,$0,'í',$0,$0,$0,'¿',$0
	dc.b        $0,$0,'$',$8,'Ó',$0,$3,$0,$7,$8,'Æ',$0,$0,$0
	dc.b        $7,'`Æ',$8,'Ó',$0,$0,$0,$7,$8,'Æ',$0,$3,$0,$7
	dc.b        '`†',$2,'.',$0,'ˆ',$0,$7,'`ò',$0,'.',$0,$9,$0
	dc.b        $7,'`ê',$1D,'Y',$0,$6,'`ä~',$0,$1E,$11,'"z',$7
	dc.b        'Ç”«`',$0,'ˇ~P˘',$0,$0,$0,$0,$1D,'Y',$0,$B,'Q'
	dc.b        'Ó',$0,$C,$1E,$19,'·O',$1E,$19,'·_3«',$0,$0
	dc.b        $0,$0,'QÓ',$0,$8,'`',$0,$1,':M˙',$9,'bPÓ˝˛',$1D
	dc.b        'Y',$0,$1,$1C,'ôM˙',$7,'î>',$1,'ﬁ',$19,'ﬁG>'
	dc.b        '6p',$0,'M˙',$6,'˘QÓˇ˝',$1C,'«‡O',$1C,'á`',$0
	dc.b        $1,$C,'M˙',$6,'ÁQÓˇ˝PÓ',$0,'K',$1D,'Y',$0,$1
	dc.b        $1C,'ô>',$1,'ﬁ',$19,'ﬁGM˙',$7,'\>6p',$0,'M˙'
	dc.b        $9,$14,$1C,'«‡O',$1C,'á`',$0,$0,'ﬁM˙',$7,'F'
	dc.b        'PÓˇæQÓˇp~',$0,'>',$1,'ﬁ',$19,'ﬁG>6p',$0,'M'
	dc.b        '˙',$8,'Ó<',$7,$1C,'Ü‡N',$1D,'F',$0,$1,'|',$0
	dc.b        $1C,$19,'Ïød',$2,'RG',$1D,'G˝≥‡O',$1D,'G˝¥`'
	dc.b        $0,$0,'†,z',$6,'÷Há',$13,'ˆp',$0,$0,$0,$0,$0
	dc.b        $1E,$19,'Há?',$1,'M˙',$6,'Ù“A26',$10,$0,'“G'
	dc.b        $1E,':',$6,'©HáM˙',$6,'¶ﬂV“V<:',$8,'†',$C,'F'
	dc.b        'ˇˇg',$1E,'JGk',$14,'≤Fe',$16,'2',$6,$1F,'z'
	dc.b        $6,'ê',$0,$1,'BVQÓˇ˝`',$6,'≤Fd',$2,'`Í2',$17
	dc.b        'M˙',$6,'∞“',$19,'“A26',$10,$0,$1E,')ˇ˛Há“G'
	dc.b        $1E,':',$6,']HáM˙',$6,'ZﬂV“VM˙',$5,'ˆ',$1C,'Å'
	dc.b        '‡I',$1D,'A',$0,$1,'2',$1F,'`',$14,'M˙',$5,'Ê'
	dc.b        '2',$16,'·Y',$1E,':',$6,'7Há“G?',$1,'`‡M˙',$6
	dc.b        '*Q÷JBf',$0,$0,'¿M˙',$6,' =|ˇˇ',$2,$6,'Bn',$0
	dc.b        $4,'Q÷v',$0,$16,$1A,'&z',$6,$4,$C,$3,$0,'˚e'
	dc.b        $0,$0,'ò,<',$0,$0,$0,'ˇú',$3,'ÂN.;h',$6,'N˚'
	dc.b        'x',$16,$0,$0,$0,'f',$0,$0,$0,'P',$0,$0,$0,'B'
	dc.b        $0,$0,$0,',',$0,$0,$0,$0,'~',$0,$1C,$1A,$1E
	dc.b        $1A,$16,$12,'M˙',$5,'€',$1C,'áæ',$3,'e',$2,'D'
	dc.b        $6,'M˙',$5,'∆',$1C,'ÜM˙',$5,'˛ﬁG>6p',$0,'M˙'
	dc.b        $7,'º<á`ûM˙',$6,'¨v',$0,$16,$1A,'ÈCMˆ0',$0,'#'
	dc.b        'Œ',$0,$0,$0,$0,'`à',$16,$1A,'D',$3,'M˙',$5
	dc.b        'î',$1C,'É`',$0,'ˇ|M˙',$8,'2',$16,$1A,'÷C÷C'
	dc.b        '#ˆ0',$0,$0,$0,$0,$0,'`',$0,'ˇVE˘',$0,$0,$0
	dc.b        $0,'`',$0,'ˇLt',$0,$14,$1A,'ƒ¸',$0,$6,'SB',$C
	dc.b        $13,$0,'ˇg',$0,$1,'–M˙',$5,$7,$1E,$1B,$C,$7
	dc.b        $0,'ıe',$0,$1,'8,<',$0,$0,$0,'˛ú',$7,'ÂN.;h'
	dc.b        $6,'N˚x*',$0,$0,$0,$0,$0,$0,$0,$E,$0,$0,$0,$1C
	dc.b        $0,$0,$0,',',$0,$0,$0,'2',$0,$0,$0,'@',$0,$0
	dc.b        $0,'b',$0,$0,$0,'ê',$0,$0,$0,'æ',$0,$0,$0,'$'
	dc.b        $8,'Ó',$0,$4,'ˇ˛',$8,'Æ',$0,$1,'ˇ˛`Æ',$8,'Ó'
	dc.b        $0,$1,'ˇ˛',$8,'Æ',$0,$4,'ˇ˛`†',$2,'.',$0,'Ì'
	dc.b        'ˇ˛`ò',$0,'.',$0,$12,'ˇ˛`ê',$1D,'[ˇ˝`ä~',$0
	dc.b        $1E,$13,'&z',$4,'“◊«`',$0,'ˇ~P˘',$0,$0,$0,$0
	dc.b        $1D,'[',$0,$2,'QÓ',$0,$3,$1E,$1B,'·O',$1E,$1B
	dc.b        '·_3«',$0,$0,$0,$0,'Q÷`',$0,$1,':M˙',$6,'ÆP'
	dc.b        'Ó˝˛',$1D,'[',$0,$1,$1C,'õM˙',$4,'ﬁ>',$3,'ﬁ'
	dc.b        $1B,'ﬁG>6p',$0,'M˙',$4,'CQÓˇ˛',$1C,'«‡O',$1C
	dc.b        'á`',$0,$1,$C,'M˙',$4,'1QÓˇ˛PÓ',$0,'M',$1D,'['
	dc.b        $0,$1,$1C,'õ>',$3,'ﬁ',$1B,'ﬁGM˙',$4,'¶>6p',$0
	dc.b        'M˙',$6,'`',$1C,'«‡O',$1C,'á`',$0,$0,'ﬁM˙',$4
	dc.b        'êPÓˇ¿QÓˇq~',$0,'>',$3,'ﬁ',$1B,'ﬁG>6p',$0,'M'
	dc.b        '˙',$6,':<',$7,$1C,'Ü‡N',$1D,'F',$0,$1,'|',$0
	dc.b        $1C,$1B,'Ïød',$2,'RG',$1D,'G˝±‡O',$1D,'G˝≤`'
	dc.b        $0,$0,'†,z',$4,'$Há',$13,'ˆp',$0,$0,$0,$0,$0
	dc.b        $1E,$1B,'Há?',$3,'M˙',$4,'>÷C660',$0,'÷G',$1E
	dc.b        ':',$3,'ÙHáM˙',$3,'ÚﬂV÷V<:',$5,'Ï',$C,'Fˇˇg'
	dc.b        $1E,'JGk',$14,'∂Fe',$16,'6',$6,$1F,'z',$3,'€'
	dc.b        $0,$1,'BVQÓˇ¸`',$6,'∂Fd',$2,'`Í6',$17,'M˙',$3
	dc.b        '˙÷',$1B,'÷C660',$0,$1E,'+ˇ˛Há÷G',$1E,':',$3
	dc.b        '®HáM˙',$3,'¶ﬂV÷VM˙',$3,'B',$1C,'É‡K',$1D,'C'
	dc.b        $0,$1,'6',$1F,'`',$14,'M˙',$3,'26',$16,'·[',$1E
	dc.b        ':',$3,'ÇHá÷G?',$3,'`‡M˙',$3,'sQ÷JDf',$0,$0
	dc.b        '¿M˙',$3,'k=|ˇˇ',$2,$7,'Bn',$0,$5,'Q÷z',$0,$1A
	dc.b        $1C,'*z',$3,'J',$C,$5,$0,'˚e',$0,$0,'ò,<',$0
	dc.b        $0,$0,'ˇú',$5,'ÂN.;h',$6,'N˚x',$16,$0,$0,$0
	dc.b        'f',$0,$0,$0,'P',$0,$0,$0,'B',$0,$0,$0,',',$0
	dc.b        $0,$0,$0,'~',$0,$1C,$1C,$1E,$1C,$1A,$14,'M˙'
	dc.b        $3,'&',$1C,'áæ',$5,'e',$2,'D',$6,'M˙',$3,$11
	dc.b        $1C,'ÜM˙',$3,'HﬁG>6p',$0,'M˙',$5,$8,'<á`ûM˙'
	dc.b        $3,'ˆz',$0,$1A,$1C,'ÈEMˆP',$0,'#Œ',$0,$0,$0
	dc.b        $0,'`à',$1A,$1C,'D',$5,'M˙',$2,'ﬂ',$1C,'Ö`',$0
	dc.b        'ˇ|M˙',$5,'|',$1A,$1C,'⁄E⁄E#ˆP',$0,$0,$0,$0
	dc.b        $0,'`',$0,'ˇVI˘',$0,$0,$0,$0,'`',$0,'ˇLx',$0
	dc.b        $18,$1C,'»¸',$0,$6,'SD',$C,$15,$0,'ˇg',$0,$1
	dc.b        '–M˙',$2,'R',$1E,$1D,$C,$7,$0,'ıe',$0,$1,'8'
	dc.b        ',<',$0,$0,$0,'˛ú',$7,'ÂN.;h',$6,'N˚x*',$0,$0
	dc.b        $0,$0,$0,$0,$0,$E,$0,$0,$0,$1C,$0,$0,$0,',',$0
	dc.b        $0,$0,'2',$0,$0,$0,'@',$0,$0,$0,'b',$0,$0,$0
	dc.b        'ê',$0,$0,$0,'æ',$0,$0,$0,'$',$8,'Ó',$0,$5,'ˇ'
	dc.b        '˝',$8,'Æ',$0,$2,'ˇ˝`Æ',$8,'Ó',$0,$2,'ˇ˝',$8
	dc.b        'Æ',$0,$5,'ˇ˝`†',$2,'.',$0,'€ˇ˝`ò',$0,'.',$0
	dc.b        '$ˇ˝`ê',$1D,']ˇ¸`ä~',$0,$1E,$15,'*z',$2,$18
	dc.b        '€«`',$0,'ˇ~P˘',$0,$0,$0,$0,$1D,']',$0,$1,'Q'
	dc.b        'Ó',$0,$2,$1E,$1D,'·O',$1E,$1D,'·_3«',$0,$0
	dc.b        $0,$0,'Q÷`',$0,$1,':M˙',$3,'˙PÓ˝˚',$1D,']',$0
	dc.b        $1,$1C,'ùM˙',$2,'(>',$5,'ﬁ',$1D,'ﬁG>6p',$0,'M'
	dc.b        '˙',$1,'çQÓˇˇ',$1C,'«‡O',$1C,'á`',$0,$1,$C,'M'
	dc.b        '˙',$1,'{QÓˇˇPÓ',$0,'L',$1D,']',$0,$1,$1C,'ù'
	dc.b        '>',$5,'ﬁ',$1D,'ﬁGM˙',$1,'>6p',$0,'M˙',$3,'¨'
	dc.b        $1C,'«‡O',$1C,'á`',$0,$0,'ﬁM˙',$1,'⁄PÓˇøQÓˇ'
	dc.b        'r~',$0,'>',$5,'ﬁ',$1D,'ﬁG>6p',$0,'M˙',$3,'Ü'
	dc.b        '<',$7,$1C,'Ü‡N',$1D,'F',$0,$1,'|',$0,$1C,$1D
	dc.b        'Ïød',$2,'RG',$1D,'G˝Ø‡O',$1D,'G˝∞`',$0,$0,'†'
	dc.b        ',z',$1,'rHá',$13,'ˆp',$0,$0,$0,$0,$0,$1E,$1D
	dc.b        'Há?',$5,'M˙',$1,'à⁄E:6P',$0,'⁄G',$1E,':',$1
	dc.b        '?HáM˙',$1,'>ﬂV⁄V<:',$3,'8',$C,'Fˇˇg',$1E,'J'
	dc.b        'Gk',$14,'∫Fe',$16,':',$6,$1F,'z',$1,'&',$0
	dc.b        $1,'BVQÓˇ˚`',$6,'∫Fd',$2,'`Í:',$17,'M˙',$1,'D'
	dc.b        '⁄',$1D,'⁄E:6P',$0,$1E,'-ˇ˛Há⁄G',$1E,':',$0
	dc.b        'ÛHáM˙',$0,'ÚﬂV⁄VM˙',$0,'é',$1C,'Ö‡M',$1D,'E'
	dc.b        $0,$1,':',$1F,'`',$14,'M˙',$0,'~:',$16,'·]',$1E
	dc.b        ':',$0,'ÕHá⁄G?',$5,'`‡M˙',$0,'n',$8,'ñ',$0,$4
	dc.b        'J.',$0,'Ng',$A,'=z',$2,'∞ˇ¯',$8,'÷',$0,$4,$8
	dc.b        'Æ',$0,$4,$0,$1,'J.',$0,'Pg',$C,'=z',$2,'úˇ'
	dc.b        '˙',$8,'Ó',$0,$4,$0,$1,$8,'Æ',$0,$4,$0,$2,'J'
	dc.b        '.',$0,'Og',$C,'=z',$2,'Üˇ¸',$8,'Ó',$0,$4,$0
	dc.b        $2,'~',$C,'M˙',$0,')',$11,'«à',$0,$11,'Êà',$2
	dc.b        'QœˇˆM˙',$0,$1A,'H÷?ˇLﬂˇNu',$0,$0,$0,$0,$0
	dc.b        $0,$0,'¯',$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,'Muzak-driver',$0,'done',$0,'by',$0
	dc.b        'Sector',$0,'One',$0,'from',$0,'The',$0,'He'
	dc.b        'avy',$0,'Killers',$E,'Ó',$E,$18,$D,'M',$C,'é'
	dc.b        $B,'⁄',$B,'/',$A,'è',$9,'˜',$9,'h',$8,'·',$8
	dc.b        'a',$7,'È',$7,'w',$7,$C,$6,'ß',$6,'G',$5,'Ì'
	dc.b        $5,'ò',$5,'G',$4,'¸',$4,'¥',$4,'p',$4,'1',$3
	dc.b        'Ù',$3,'º',$3,'Ü',$3,'S',$3,'$',$2,'ˆ',$2,'Ã'
	dc.b        $2,'§',$2,'~',$2,'Z',$2,'8',$2,$18,$1,'˙',$1
	dc.b        'ﬁ',$1,'√',$1,'™',$1,'í',$1,'{',$1,'f',$1,'R'
	dc.b        $1,'?',$1,'-',$1,$1C,$1,$C,$0,'˝',$0,'Ô',$0
	dc.b        '·',$0,'’',$0,'…',$0,'æ',$0,'≥',$0,'©',$0,'ü'
	dc.b        $0,'ñ',$0,'é',$0,'Ü',$0,'',$0,'w',$0,'q',$0
	dc.b        'j',$0,'d',$0,'_',$0,'Y',$0,'T',$0,'P',$0,'K'
	dc.b        $0,'G',$0,'C',$0,'?',$0,'<',$0,'8',$0,'5',$0
	dc.b        '2',$0,'/',$0,'-',$0,'*',$0,'(',$0,'&',$0,'$'
	dc.b        $0,'"',$0,' ',$0,$1E,$0,$1C,$0,$1B,$0,$19,$0
	dc.b        $18,$0,$16,$0,$15,$0,$14,$0,$13,$0,$12,$0,$11
	dc.b        $0,$10,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$1,$1,$1,$1
	dc.b        $1,$1,$1,$1,$0,$0,$0,$0,$1,$1,$1,$1,$1,$1,$1
	dc.b        $1,$2,$2,$2,$2,$0,$0,$0,$1,$1,$1,$1,$1,$2,$2
	dc.b        $2,$2,$2,$3,$3,$3,$0,$0,$1,$1,$1,$1,$2,$2,$2
	dc.b        $2,$3,$3,$3,$3,$4,$4,$0,$0,$1,$1,$1,$2,$2,$2
	dc.b        $3,$3,$3,$4,$4,$4,$5,$5,$0,$0,$1,$1,$2,$2,$2
	dc.b        $3,$3,$4,$4,$4,$5,$5,$6,$6,$0,$0,$1,$1,$2,$2
	dc.b        $3,$3,$4,$4,$5,$5,$6,$6,$7,$7,$0,$1,$1,$2,$2
	dc.b        $3,$3,$4,$4,$5,$5,$6,$6,$7,$7,$8,$0,$1,$1,$2
	dc.b        $2,$3,$4,$4,$5,$5,$6,$7,$7,$8,$8,$9,$0,$1,$1
	dc.b        $2,$3,$3,$4,$5,$5,$6,$7,$7,$8,$9,$9,$A,$0,$1
	dc.b        $1,$2,$3,$4,$4,$5,$6,$7,$7,$8,$9,$A,$A,$B,$0
	dc.b        $1,$2,$2,$3,$4,$5,$6,$6,$7,$8,$9,$A,$A,$B,$C
	dc.b        $0,$1,$2,$3,$3,$4,$5,$6,$7,$8,$9,$A,$A,$B,$C
	dc.b        $D,$0,$1,$2,$3,$4,$5,$6,$7,$7,$8,$9,$A,$B,$C
	dc.b        $D,$E,$0,$1,$2,$3,$4,$5,$6,$7,$8,$9,$A,$B,$C
	dc.b        $D,$E,$F,'Fanou',$0,'I',$0,'love',$0,'ya',$0
	dc.b        '!',$0,'-',$0,'Jedi',$0,'-',$0,'for',$0,'my'
	dc.b        $0,'baby...',$0,'ˇˇ˝‰ˇˇ˝»ˇˇ˝‘ˇˇˇ÷ˇˇ˝Üˇˇ˝–ˇˇ'
	dc.b        '˝÷ˇˇˇÿˇˇ˝áˇˇ˝Ãˇˇ˝’ˇˇˇ⁄ˇˇ˝àˇˇ˝Ëˇˇ˝ÏˇˇˇˇˇˇıÄ'
	dc.b        'ˇˇı¢ˇˇˆPˇˇˆfˇˇ˜',$16,'ˇˇ¯Zˇˇ˘',$8,'ˇˇ˘',$1E
	dc.b        'ˇˇ˘Ãˇˇ˚',$10,'ˇˇ˚æˇˇ˚‘ˇˇ¸Çˇˇ¯8ˇˇ˙Óˇˇˇˇ',$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
	dc.b        $0,$0,$0,$0,$0,$0,$0,$0,$0,'ı',$0,$0,$0,'ˇT'
	dc.b        'HK˝˚',$7,$D,$0,$18,'˛',$F,$0,$17,$F,$0,$13
	dc.b        $F,$0,$10,$D,$0,$8,$0,$0,$0,'ˇTHK¸˚',$11,$F
	dc.b        $0,'&˛',$F,$0,'"',$F,$0,$1F,$F,$0,$1D,'˝˚',$D
	dc.b        $D,$0,$1B,$B,$0,$19,$0,$0,$0,'ˇTHK˛ˆ',$18,$5
	dc.b        'ˆ',$18,$5,'ˆ',$0,$6,'ˆ',$0,$6,'˚',$0,'˙',$A
	dc.b        'ˇTHK˛',$F,$0,$0,$F,$0,$0,$E,$0,$0,$D,$0,$0
	dc.b        $D,$0,$0,$D,$3,$0,$D,$4,$0,$D,$5,$0,$D,$4,$0
	dc.b        $D,$3,$0,$D,$0,$0,$D,'˛',$0,$D,'¸',$0,$D,'˚'
	dc.b        $0,$D,'¸',$0,$D,'˛',$0,$D,$0,$0,$D,$3,$0,$D
	dc.b        $4,$0,$D,$5,$0,$D,$4,$0,$D,$3,$0,$D,$0,$0,$D
	dc.b        '˛',$0,$D,'¸',$0,$D,'˚',$0,$D,'¸',$0,$D,'˛',$0
	dc.b        $D,$0,$0,$D,$3,$0,$C,$4,$0,$B,$5,$0,$A,$4,$0
	dc.b        $9,$3,$0,$8,$0,$0,$7,'˛',$0,$6,'¸',$0,$5,'˚'
	dc.b        $0,$4,'¸',$0,$4,'˛',$0,$4,$0,$0,$4,$3,$0,$4
	dc.b        $4,$0,$4,$5,$0,$3,$4,$0,$2,$3,$0,$1,$0,$0,$0
	dc.b        $0,$0,'ˇTHK˛',$F,$0,$0,'˚',$0,'˙',$1,'ˇTHK˛'
	dc.b        $F,$0,$0,$F,$0,$3,$F,$0,$7,$E,$0,$0,$E,$0,$3
	dc.b        $E,$0,$7,$D,$0,$0,$D,$0,$3,$D,$0,$7,$C,$0,$0
	dc.b        $C,$0,$3,$C,$0,$7,'˚',$0,'˙',$1C,'ˇTHK˛ˆ',$18
	dc.b        $5,'ˆ',$0,$6,'ˆ',$0,$6,'ˆ',$0,$6,'ˆ',$0,$6,'ˆ'
	dc.b        $0,$6,'ˆ',$0,$6,'ˆ',$0,$6,'ˆ',$0,$6,'ˇTHK˛',$F
	dc.b        $0,$0,$F,$0,$3,$E,$0,$7,$E,$0,$0,$D,$0,$3,$D
	dc.b        $0,$7,$C,$0,$0,$C,$0,$3,$C,$0,$7,$C,$0,$0,$C
	dc.b        $0,$3,$C,$0,$7,$C,$0,$0,$C,$0,$3,$C,$0,$7,$C
	dc.b        $0,$0,$C,$0,$3,$C,$0,$7,$C,$0,$0,$C,$0,$3,$C
	dc.b        $0,$7,$C,$0,$0,$C,$0,$3,$C,$0,$7,$B,$0,$0,$A
	dc.b        $0,$3,$9,$0,$7,$8,$0,$0,$7,$0,$3,$6,$0,$7,$5
	dc.b        $0,$0,$4,$0,$3,$3,$0,$7,$2,$0,$0,$1,$0,$3,'ı'
	dc.b        $0,$0,$7,'ˇTHK˛',$F,$0,$0,$F,$0,$4,$E,$0,$7
	dc.b        $E,$0,$0,$D,$0,$4,$D,$0,$7,$C,$0,$0,$C,$0,$4
	dc.b        $C,$0,$7,$C,$0,$0,$C,$0,$4,$C,$0,$7,$C,$0,$0
	dc.b        $C,$0,$4,$C,$0,$7,$C,$0,$0,$C,$0,$4,$C,$0,$7
	dc.b        $C,$0,$0,$C,$0,$4,$C,$0,$7,$C,$0,$0,$C,$0,$4
	dc.b        $C,$0,$7,$B,$0,$0,$A,$0,$4,$9,$0,$7,$8,$0,$0
	dc.b        $7,$0,$4,$6,$0,$7,$5,$0,$0,$4,$0,$4,$3,$0,$7
	dc.b        $2,$0,$0,$1,$0,$4,'ı',$0,$0,$7,'ˇTH?˛',$3,'¸'
	dc.b        $F,$9,$10,$4,$10,$5,$10,$7,$10,$9,$10,$4,$10
	dc.b        $5,$10,$7,$10,'˛',$7,'¸',$D,$9,$1,'˛',$8,'-'
	dc.b        $1,'˛',$7,$9,$1,'˛',$8,'-',$1,'˛',$7,$9,$1,$9
	dc.b        $1,'˛',$8,'-',$1,'˛',$7,$9,$1,'˛',$8,'-',$1
	dc.b        '˛',$7,$9,$1,'˛',$8,'-',$1,'˛',$7,$9,$1,$15
	dc.b        $1,$15,$1,$9,$1,$9,$1,$4,$1,'˛',$8,'(',$1,'˛'
	dc.b        $7,$4,$1,'˛',$8,'(',$1,'˛',$7,$4,$1,$4,$1,'˛'
	dc.b        $8,'(',$1,'˛',$7,$4,$1,'˛',$8,'(',$1,'˛',$7
	dc.b        $4,$1,'˛',$8,'(',$1,'˛',$7,$4,$1,$10,$1,$10
	dc.b        $1,$4,$1,$4,$1,$5,$1,'˛',$9,')',$1,'˛',$7,$5
	dc.b        $1,'˛',$9,')',$1,'˛',$7,$5,$1,$5,$1,'˛',$9,')'
	dc.b        $1,'˛',$7,$5,$1,'˛',$9,')',$1,'˛',$7,$5,$1,'˛'
	dc.b        $9,')',$1,'˛',$7,$5,$1,$11,$1,$11,$1,$5,$1,$5
	dc.b        $1,$7,$1,'˛',$9,'+',$1,'˛',$7,$7,$1,'˛',$9,'+'
	dc.b        $1,'˛',$7,$7,$1,$7,$1,'˛',$9,'+',$1,'˛',$7,$7
	dc.b        $1,'˛',$9,'+',$1,'˛',$7,$7,$1,'˛',$9,'+',$1
	dc.b        '˛',$7,$7,$1,$13,$1,$13,$1,$7,$1,$7,$1,$9,$1
	dc.b        '˛',$8,'-',$1,'˛',$7,$9,$1,'˛',$8,'-',$1,'˛'
	dc.b        $7,$9,$1,$9,$1,'˛',$8,'-',$1,'˛',$7,$9,$1,'˛'
	dc.b        $8,'-',$1,'˛',$7,$9,$1,'˛',$8,'-',$1,'˛',$7
	dc.b        $9,$1,$15,$1,$15,$1,$9,$1,$9,$1,$4,$1,'˛',$8
	dc.b        '(',$1,'˛',$7,$4,$1,'˛',$8,'(',$1,'˛',$7,$4
	dc.b        $1,$4,$1,'˛',$8,'(',$1,'˛',$7,$4,$1,'˛',$8,'('
	dc.b        $1,'˛',$7,$4,$1,'˛',$8,'(',$1,'˛',$7,$4,$1,$10
	dc.b        $1,$10,$1,$4,$1,$4,$1,$5,$1,'˛',$9,')',$1,'˛'
	dc.b        $7,$5,$1,'˛',$9,')',$1,'˛',$7,$5,$1,$5,$1,'˛'
	dc.b        $9,')',$1,'˛',$7,$5,$1,'˛',$9,')',$1,'˛',$7
	dc.b        $5,$1,'˛',$9,')',$1,'˛',$7,$5,$1,$11,$1,$11
	dc.b        $1,$5,$1,$5,$1,$7,$1,'˛',$9,'+',$1,'˛',$7,$7
	dc.b        $1,'˛',$9,'+',$1,'˛',$7,$7,$1,$7,$1,'˛',$9,'+'
	dc.b        $1,'˛',$7,$7,$1,'˛',$9,'+',$1,'˛',$7,$7,$1,'˛'
	dc.b        $9,'+',$1,'˛',$7,$7,$1,$13,$1,$13,$1,$7,$1,$7
	dc.b        $1,'˛',$3,$9,' ˛',$7,$9,$1,'˛',$8,'-',$1,'˛'
	dc.b        $7,$9,$1,'˛',$8,'-',$1,'˛',$7,$9,$1,$9,$1,'˛'
	dc.b        $8,'-',$1,'˛',$7,$9,$1,'˛',$8,'-',$1,'˛',$7
	dc.b        $9,$1,'˛',$8,'-',$1,'˛',$7,$9,$1,$15,$1,$15
	dc.b        $1,$9,$1,$9,$1,$4,$1,'˛',$8,'(',$1,'˛',$7,$4
	dc.b        $1,'˛',$8,'(',$1,'˛',$7,$4,$1,$4,$1,'˛',$8,'('
	dc.b        $1,'˛',$7,$4,$1,'˛',$8,'(',$1,'˛',$7,$4,$1,'˛'
	dc.b        $8,'(',$1,'˛',$7,$4,$1,$10,$1,$10,$1,$4,$1,$4
	dc.b        $1,$5,$1,'˛',$9,')',$1,'˛',$7,$5,$1,'˛',$9,')'
	dc.b        $1,'˛',$7,$5,$1,$5,$1,'˛',$9,')',$1,'˛',$7,$5
	dc.b        $1,'˛',$9,')',$1,'˛',$7,$5,$1,'˛',$9,')',$1
	dc.b        '˛',$7,$5,$1,$11,$1,$11,$1,$5,$1,$5,$1,$7,$1
	dc.b        '˛',$9,'+',$1,'˛',$7,$7,$1,'˛',$9,'+',$1,'˛'
	dc.b        $7,$7,$1,$7,$1,'˛',$9,'+',$1,'˛',$7,$7,$1,'˛'
	dc.b        $9,'+',$1,'˛',$7,$7,$1,'˛',$9,'+',$1,'˛',$7
	dc.b        $7,$1,$13,$1,$13,$1,$7,$1,$7,$1,$9,$1,'˛',$8
	dc.b        '-',$1,'˛',$7,$9,$1,'˛',$8,'-',$1,'˛',$7,$9
	dc.b        $1,$9,$1,'˛',$8,'-',$1,'˛',$7,$9,$1,'˛',$8,'-'
	dc.b        $1,'˛',$7,$9,$1,'˛',$8,'-',$1,'˛',$7,$9,$1,$15
	dc.b        $1,$15,$1,$9,$1,$9,$1,$4,$1,'˛',$8,'(',$1,'˛'
	dc.b        $7,$4,$1,'˛',$8,'(',$1,'˛',$7,$4,$1,$4,$1,'˛'
	dc.b        $8,'(',$1,'˛',$7,$4,$1,'˛',$8,'(',$1,'˛',$7
	dc.b        $4,$1,'˛',$8,'(',$1,'˛',$7,$4,$1,$10,$1,$10
	dc.b        $1,$4,$1,$4,$1,$5,$1,'˛',$9,')',$1,'˛',$7,$5
	dc.b        $1,'˛',$9,')',$1,'˛',$7,$5,$1,$5,$1,'˛',$9,')'
	dc.b        $1,'˛',$7,$5,$1,'˛',$9,')',$1,'˛',$7,$5,$1,'˛'
	dc.b        $9,')',$1,'˛',$7,$5,$1,$11,$1,$11,$1,$5,$1,$5
	dc.b        $1,$7,$1,'˛',$9,'+',$1,'˛',$7,$7,$1,'˛',$9,'+'
	dc.b        $1,'˛',$7,$7,$1,$7,$1,'˛',$9,'+',$1,'˛',$7,$7
	dc.b        $1,'˛',$9,'+',$1,'˛',$7,$7,$1,'˛',$9,'+',$1
	dc.b        '˛',$7,$7,$1,$13,$1,$13,$1,$7,$1,$7,$1,'˛',$3
	dc.b        $9,$10,$4,$10,$5,$10,$7,$10,$9,$10,$4,$10,$5
	dc.b        $10,$7,$10,'˛',$7,$9,$1,'˛',$8,'-',$1,'˛',$7
	dc.b        $9,$1,'˛',$8,'-',$1,'˛',$7,$9,$1,$9,$1,'˛',$8
	dc.b        '-',$1,'˛',$7,$9,$1,'˛',$8,'-',$1,'˛',$7,$9
	dc.b        $1,'˛',$8,'-',$1,'˛',$7,$9,$1,$15,$1,$15,$1
	dc.b        $9,$1,$9,$1,$4,$1,'˛',$8,'(',$1,'˛',$7,$4,$1
	dc.b        '˛',$8,'(',$1,'˛',$7,$4,$1,$4,$1,'˛',$8,'(',$1
	dc.b        '˛',$7,$4,$1,'˛',$8,'(',$1,'˛',$7,$4,$1,'˛',$8
	dc.b        '(',$1,'˛',$7,$4,$1,$10,$1,$10,$1,$4,$1,$4,$1
	dc.b        $5,$1,'˛',$9,')',$1,'˛',$7,$5,$1,'˛',$9,')',$1
	dc.b        '˛',$7,$5,$1,$5,$1,'˛',$9,')',$1,'˛',$7,$5,$1
	dc.b        '˛',$9,')',$1,'˛',$7,$5,$1,'˛',$9,')',$1,'˛'
	dc.b        $7,$5,$1,$11,$1,$11,$1,$5,$1,$5,$1,$7,$1,'˛'
	dc.b        $9,'+',$1,'˛',$7,$7,$1,'˛',$9,'+',$1,'˛',$7
	dc.b        $7,$1,$7,$1,'˛',$9,'+',$1,'˛',$7,$7,$1,'˛',$9
	dc.b        '+',$1,'˛',$7,$7,$1,'˛',$9,'+',$1,'˛',$7,$7
	dc.b        $1,$13,$1,$13,$1,$7,$1,$7,$1,$9,$1,'˛',$8,'-'
	dc.b        $1,'˛',$7,$9,$1,'˛',$8,'-',$1,'˛',$7,$9,$1,$9
	dc.b        $1,'˛',$8,'-',$1,'˛',$7,$9,$1,'˛',$8,'-',$1
	dc.b        '˛',$7,$9,$1,'˛',$8,'-',$1,'˛',$7,$9,$1,$15
	dc.b        $1,$15,$1,$9,$1,$9,$1,$4,$1,'˛',$8,'(',$1,'˛'
	dc.b        $7,$4,$1,'˛',$8,'(',$1,'˛',$7,$4,$1,$4,$1,'˛'
	dc.b        $8,'(',$1,'˛',$7,$4,$1,'˛',$8,'(',$1,'˛',$7
	dc.b        $4,$1,'˛',$8,'(',$1,'˛',$7,$4,$1,$10,$1,$10
	dc.b        $1,$4,$1,$4,$1,$5,$1,'˛',$9,')',$1,'˛',$7,$5
	dc.b        $1,'˛',$9,')',$1,'˛',$7,$5,$1,$5,$1,'˛',$9,')'
	dc.b        $1,'˛',$7,$5,$1,'˛',$9,')',$1,'˛',$7,$5,$1,'˛'
	dc.b        $9,')',$1,'˛',$7,$5,$1,$11,$1,$11,$1,$5,$1,$5
	dc.b        $1,$7,$1,'˛',$9,'+',$1,'˛',$7,$7,$1,'˛',$9,'+'
	dc.b        $1,'˛',$7,$7,$1,$7,$1,'˛',$9,'+',$1,'˛',$7,$7
	dc.b        $1,'˛',$9,'+',$1,'˛',$7,$7,$1,'˛',$9,'+',$1
	dc.b        '˛',$7,$7,$1,$13,$1,$13,$1,$7,$1,$7,$1,'¸',$1
	dc.b        $9,$2,$9,$2,$9,$1,$9,$2,$9,$2,$9,$2,$9,$1,$9
	dc.b        $2,$9,$1,$9,$1,$9,$2,$9,$2,$9,$1,$9,$2,$9,$2
	dc.b        $9,$2,$9,$1,$9,$2,$9,$1,$9,$1,$9,$2,$9,$2,$9
	dc.b        $1,$9,$2,$9,$2,$9,$2,$9,$1,$9,$2,$9,$1,$9,$1
	dc.b        $9,$2,$9,$2,$9,$1,$9,$2,$9,$2,$9,$2,$9,$1,$9
	dc.b        $2,$9,$1,$9,$1,$9,$2,$9,$2,$9,$1,$9,$2,$9,$2
	dc.b        $9,$2,$9,$1,$9,$2,$9,$1,$9,$1,$9,$2,$9,$2,$9
	dc.b        $1,$9,$2,$9,$2,$9,$2,$9,$1,$9,$2,$9,$1,$9,$1
	dc.b        $9,$2,$9,$2,$9,$1,$9,$2,$9,$2,$9,$2,$9,$1,$9
	dc.b        $2,$9,$1,$9,$1,$9,$2,$9,$2,$9,$1,$9,$2,$9,$2
	dc.b        $9,$2,$9,$1,$9,$2,$9,$1,$9,$1,'˛',$8,'¸',$D
	dc.b        '-',$3,'¸',$B,'-',$3,'¸',$9,'-',$3,'¸',$7,'-'
	dc.b        $3,'¸',$5,'-',$3,'¸',$3,'-',$1,'¸',$D,'(',$3
	dc.b        '¸',$B,'(',$3,'¸',$9,'(',$3,'¸',$7,'(',$3,'¸'
	dc.b        $5,'(',$3,'¸',$3,'(',$1,'¸',$D,'-',$3,'¸',$B
	dc.b        '-',$3,'¸',$9,'-',$3,'¸',$7,'-',$3,'¸',$5,'-'
	dc.b        $3,'¸',$3,'-',$1,'¸',$D,'(',$3,'¸',$B,'(',$3
	dc.b        '¸',$9,'(',$3,'¸',$7,'(',$3,'¸',$5,'(',$3,'¸'
	dc.b        $3,'(',$1,'˛',$7,'¸',$D,$9,$1,'˛',$8,'-',$1
	dc.b        '˛',$7,$9,$1,'˛',$8,'-',$1,'˛',$7,$9,$1,$9,$1
	dc.b        '˛',$8,'-',$1,'˛',$7,$9,$1,'˛',$8,'-',$1,'˛'
	dc.b        $7,$9,$1,'˛',$8,'-',$1,'˛',$7,$9,$1,$15,$1,$15
	dc.b        $1,$9,$1,$9,$1,$4,$1,'˛',$8,'(',$1,'˛',$7,$4
	dc.b        $1,'˛',$8,'(',$1,'˛',$7,$4,$1,$4,$1,'˛',$8,'('
	dc.b        $1,'˛',$7,$4,$1,'˛',$8,'(',$1,'˛',$7,$4,$1,'˛'
	dc.b        $8,'(',$1,'˛',$7,$4,$1,$10,$1,$10,$1,$4,$1,$4
	dc.b        $1,$5,$1,'˛',$9,')',$1,'˛',$7,$5,$1,'˛',$9,')'
	dc.b        $1,'˛',$7,$5,$1,$5,$1,'˛',$9,')',$1,'˛',$7,$5
	dc.b        $1,'˛',$9,')',$1,'˛',$7,$5,$1,'˛',$9,')',$1
	dc.b        '˛',$7,$5,$1,$11,$1,$11,$1,$5,$1,$5,$1,$7,$1
	dc.b        '˛',$9,'+',$1,'˛',$7,$7,$1,'˛',$9,'+',$1,'˛'
	dc.b        $7,$7,$1,$7,$1,'˛',$9,'+',$1,'˛',$7,$7,$1,'˛'
	dc.b        $9,'+',$1,'˛',$7,$7,$1,'˛',$9,'+',$1,'˛',$7
	dc.b        $7,$1,$13,$1,$13,$1,$7,$1,$7,$1,$9,$1,'˛',$8
	dc.b        '-',$1,'˛',$7,$9,$1,'˛',$8,'-',$1,'˛',$7,$9
	dc.b        $1,$9,$1,'˛',$8,'-',$1,'˛',$7,$9,$1,'˛',$8,'-'
	dc.b        $1,'˛',$7,$9,$1,'˛',$8,'-',$1,'˛',$7,$9,$1,$15
	dc.b        $1,$15,$1,$9,$1,$9,$1,$4,$1,'˛',$8,'(',$1,'˛'
	dc.b        $7,$4,$1,'˛',$8,'(',$1,'˛',$7,$4,$1,$4,$1,'˛'
	dc.b        $8,'(',$1,'˛',$7,$4,$1,'˛',$8,'(',$1,'˛',$7
	dc.b        $4,$1,'˛',$8,'(',$1,'˛',$7,$4,$1,$10,$1,$10
	dc.b        $1,$4,$1,$4,$1,$5,$1,'˛',$9,')',$1,'˛',$7,$5
	dc.b        $1,'˛',$9,')',$1,'˛',$7,$5,$1,$5,$1,'˛',$9,')'
	dc.b        $1,'˛',$7,$5,$1,'˛',$9,')',$1,'˛',$7,$5,$1,'˛'
	dc.b        $9,')',$1,'˛',$7,$5,$1,$11,$1,$11,$1,$5,$1,$5
	dc.b        $1,$7,$1,'˛',$9,'+',$1,'˛',$7,$7,$1,'˛',$9,'+'
	dc.b        $1,'˛',$7,$7,$1,$7,$1,'˛',$9,'+',$1,'˛',$7,$7
	dc.b        $1,'˛',$9,'+',$1,'˛',$7,$7,$1,'˛',$9,'+',$1
	dc.b        '˛',$7,$7,$1,$13,$1,$13,$1,$7,$1,$7,$1,'˛',$3
	dc.b        $9,$10,$4,$10,$5,$10,$7,$10,$9,$10,$4,$10,$5
	dc.b        $10,$7,$10,'˛',$7,$9,$1,'˛',$8,'-',$1,'˛',$7
	dc.b        $9,$1,'˛',$8,'-',$1,'˛',$7,$9,$1,$9,$1,'˛',$8
	dc.b        '-',$1,'˛',$7,$9,$1,'˛',$8,'-',$1,'˛',$7,$9
	dc.b        $1,'˛',$8,'-',$1,'˛',$7,$9,$1,$15,$1,$15,$1
	dc.b        $9,$1,$9,$1,$4,$1,'˛',$8,'(',$1,'˛',$7,$4,$1
	dc.b        '˛',$8,'(',$1,'˛',$7,$4,$1,$4,$1,'˛',$8,'(',$1
	dc.b        '˛',$7,$4,$1,'˛',$8,'(',$1,'˛',$7,$4,$1,'˛',$8
	dc.b        '(',$1,'˛',$7,$4,$1,$10,$1,$10,$1,$4,$1,$4,$1
	dc.b        $5,$1,'˛',$9,')',$1,'˛',$7,$5,$1,'˛',$9,')',$1
	dc.b        '˛',$7,$5,$1,$5,$1,'˛',$9,')',$1,'˛',$7,$5,$1
	dc.b        '˛',$9,')',$1,'˛',$7,$5,$1,'˛',$9,')',$1,'˛'
	dc.b        $7,$5,$1,$11,$1,$11,$1,$5,$1,$5,$1,$7,$1,'˛'
	dc.b        $9,'+',$1,'˛',$7,$7,$1,'˛',$9,'+',$1,'˛',$7
	dc.b        $7,$1,$7,$1,'˛',$9,'+',$1,'˛',$7,$7,$1,'˛',$9
	dc.b        '+',$1,'˛',$7,$7,$1,'˛',$9,'+',$1,'˛',$7,$7
	dc.b        $1,$13,$1,$13,$1,$7,$1,$7,$1,$9,$1,'˛',$8,'-'
	dc.b        $1,'˛',$7,$9,$1,'˛',$8,'-',$1,'˛',$7,$9,$1,$9
	dc.b        $1,'˛',$8,'-',$1,'˛',$7,$9,$1,'˛',$8,'-',$1
	dc.b        '˛',$7,$9,$1,'˛',$8,'-',$1,'˛',$7,$9,$1,$15
	dc.b        $1,$15,$1,$9,$1,$9,$1,$4,$1,'˛',$8,'(',$1,'˛'
	dc.b        $7,$4,$1,'˛',$8,'(',$1,'˛',$7,$4,$1,$4,$1,'˛'
	dc.b        $8,'(',$1,'˛',$7,$4,$1,'˛',$8,'(',$1,'˛',$7
	dc.b        $4,$1,'˛',$8,'(',$1,'˛',$7,$4,$1,$10,$1,$10
	dc.b        $1,$4,$1,$4,$1,$5,$1,'˛',$9,')',$1,'˛',$7,$5
	dc.b        $1,'˛',$9,')',$1,'˛',$7,$5,$1,$5,$1,'˛',$9,')'
	dc.b        $1,'˛',$7,$5,$1,'˛',$9,')',$1,'˛',$7,$5,$1,'˛'
	dc.b        $9,')',$1,'˛',$7,$5,$1,$11,$1,$11,$1,$5,$1,$5
	dc.b        $1,$7,$1,'˛',$9,'+',$1,'˛',$7,$7,$1,'˛',$9,'+'
	dc.b        $1,'˛',$7,$7,$1,$7,$1,'˛',$9,'+',$1,'˛',$7,$7
	dc.b        $1,'˛',$9,'+',$1,'˛',$7,$7,$1,'˛',$9,'+',$1
	dc.b        '˛',$7,$7,$1,$13,$1,$13,$1,$7,$1,$7,$1,'¸',$1
	dc.b        $9,$2,$9,$2,$9,$1,$9,$2,$9,$2,$9,$2,$9,$1,$9
	dc.b        $2,$9,$1,$9,$1,$9,$2,$9,$2,$9,$1,$9,$2,$9,$2
	dc.b        $9,$2,$9,$1,$9,$2,$9,$1,$9,$1,$9,$2,$9,$2,$9
	dc.b        $1,$9,$2,$9,$2,$9,$2,$9,$1,$9,$2,$9,$1,$9,$1
	dc.b        $9,$2,$9,$2,$9,$1,$9,$2,$9,$2,$9,$2,$9,$1,$9
	dc.b        $2,$9,$1,$9,$1,$9,$2,$9,$2,$9,$1,$9,$2,$9,$2
	dc.b        $9,$2,$9,$1,$9,$2,$9,$1,$9,$1,$9,$2,$9,$2,$9
	dc.b        $1,$9,$2,$9,$2,$9,$2,$9,$1,$9,$2,$9,$1,$9,$1
	dc.b        $9,$2,$9,$2,$9,$1,$9,$2,$9,$2,$9,$2,$9,$1,$9
	dc.b        $2,$9,$1,$9,$1,$9,$2,$9,$2,$9,$1,$9,$2,$9,$2
	dc.b        $9,$2,$9,$1,$9,$2,$9,$1,$9,$1,'˛',$8,'¸',$D
	dc.b        '-',$3,'¸',$B,'-',$3,'¸',$9,'-',$3,'¸',$7,'-'
	dc.b        $3,'¸',$5,'-',$3,'¸',$3,'-',$1,'¸',$D,'(',$3
	dc.b        '¸',$B,'(',$3,'¸',$9,'(',$3,'¸',$7,'(',$3,'¸'
	dc.b        $5,'(',$3,'¸',$3,'(',$1,'¸',$D,'-',$3,'¸',$B
	dc.b        '-',$3,'¸',$9,'-',$3,'¸',$7,'-',$3,'¸',$5,'-'
	dc.b        $3,'¸',$3,'-',$1,'¸',$D,'(',$3,'¸',$B,'(',$3
	dc.b        '¸',$9,'(',$3,'¸',$7,'(',$3,'¸',$5,'(',$3,'¸'
	dc.b        $3,'(',$1,'ˇTHK˛',$5,'¸',$9,';',$10,'¸',$8,'˚'
	dc.b        $1,'(;',$9,'¸',$0,'0',$27,'˛',$6,'¸',$D,'-',$10
	dc.b        '-',$10,'-',$10,'-',$10,'˛',$1,'¸',$E,$0,$4
	dc.b        '˛',$2,$2,$3,'˛',$1,$0,$3,$0,$2,'˛',$2,$2,$2
	dc.b        '˛',$8,'¸',$D,'-',$1,'-',$1,'˛',$1,'¸',$E,$0
	dc.b        $4,'˛',$2,$2,$3,'˛',$1,$0,$3,$0,$2,'˛',$2,$2
	dc.b        $2,'˛',$8,'¸',$D,'(',$1,'(',$1,'˛',$1,'¸',$E
	dc.b        $0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3,$0,$2,'˛',$2
	dc.b        $2,$2,'˛',$9,'¸',$D,')',$1,')',$1,'˛',$1,'¸'
	dc.b        $E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3,$0,$2,'˛'
	dc.b        $2,$2,$2,'˛',$9,'¸',$D,'+',$1,'+',$1,'˛',$1
	dc.b        '¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3,$0,$2
	dc.b        '˛',$2,$2,$2,'˛',$8,'¸',$D,'-',$1,'-',$1,'˛'
	dc.b        $1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3,$0
	dc.b        $2,'˛',$2,$2,$2,'˛',$8,'¸',$D,'(',$1,'(',$1
	dc.b        '˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3
	dc.b        $0,$2,'˛',$2,$2,$2,'˛',$9,'¸',$D,')',$1,')',$1
	dc.b        '˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3
	dc.b        $0,$2,'˛',$2,$2,$2,'˛',$9,'¸',$D,'+',$1,'+',$1
	dc.b        '˛',$8,'-',$3,'¸',$B,'-',$3,'¸',$9,'-',$3,'¸'
	dc.b        $7,'-',$3,'¸',$5,'-',$14,'˛',$1,'¸',$E,$0,$4
	dc.b        '˛',$2,$2,$3,'˛',$1,$0,$3,$0,$2,'˛',$2,$2,$2
	dc.b        '˛',$8,'¸',$D,'-',$1,'-',$1,'˛',$1,'¸',$E,$0
	dc.b        $4,'˛',$2,$2,$3,'˛',$1,$0,$3,$0,$2,'˛',$2,$2
	dc.b        $2,'˛',$8,'¸',$D,'(',$1,'(',$1,'˛',$1,'¸',$E
	dc.b        $0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3,$0,$2,'˛',$2
	dc.b        $2,$2,'˛',$9,'¸',$D,')',$1,')',$1,'˛',$1,'¸'
	dc.b        $E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3,$0,$2,'˛'
	dc.b        $2,$2,$2,'˛',$9,'¸',$D,'+',$1,'+',$1,'˛',$1
	dc.b        '¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3,$0,$2
	dc.b        '˛',$2,$2,$2,'˛',$8,'¸',$D,'-',$1,'-',$1,'˛'
	dc.b        $1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3,$0
	dc.b        $2,'˛',$2,$2,$2,'˛',$8,'¸',$D,'(',$1,'(',$1
	dc.b        '˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3
	dc.b        $0,$2,'˛',$2,$2,$2,'˛',$9,'¸',$D,')',$1,')',$1
	dc.b        '˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3
	dc.b        $0,$2,'˛',$2,$2,$2,'˛',$9,'¸',$D,'+',$1,'+',$1
	dc.b        '˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3
	dc.b        $0,$2,'˛',$2,$2,$3,$2,$1,'˛',$1,$0,$4,'˛',$2
	dc.b        $2,$3,'˛',$1,$0,$3,$0,$2,'˛',$2,$2,$3,$2,$1
	dc.b        '˛',$1,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3,$0,$2
	dc.b        '˛',$2,$2,$3,$2,$1,'˛',$1,$0,$1,'˛',$2,$2,$2
	dc.b        '˛',$1,$0,$1,$0,$2,'˛',$2,$2,$1,$2,$2,$2,$1
	dc.b        $2,$2,$2,$1,$2,$2,$2,$1,'˛',$1,$0,$4,'˛',$2
	dc.b        $2,$3,'˛',$1,$0,$3,$0,$2,'˛',$2,$2,$3,$2,$1
	dc.b        '˛',$1,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3,$0,$2
	dc.b        '˛',$2,$2,$3,$2,$1,'˛',$1,$0,$4,'˛',$2,$2,$3
	dc.b        '˛',$1,$0,$3,$0,$2,'˛',$2,$2,$3,$2,$1,'˛',$1
	dc.b        $0,$1,'˛',$2,$2,$2,'˛',$1,$0,$1,$0,$2,'˛',$2
	dc.b        $2,$1,$2,$2,$2,$1,$2,$2,$2,$1,$2,$2,$2,$1,'˛'
	dc.b        $1,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3,$0,$2,'˛'
	dc.b        $2,$2,$2,'˛',$8,'¸',$D,'-',$1,'-',$1,'˛',$1
	dc.b        '¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3,$0,$2
	dc.b        '˛',$2,$2,$2,'˛',$8,'¸',$D,'(',$1,'(',$1,'˛'
	dc.b        $1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3,$0
	dc.b        $2,'˛',$2,$2,$2,'˛',$9,'¸',$D,')',$1,')',$1
	dc.b        '˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3
	dc.b        $0,$2,'˛',$2,$2,$2,'˛',$9,'¸',$D,'+',$1,'+',$1
	dc.b        '˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3
	dc.b        $0,$2,'˛',$2,$2,$2,'˛',$8,'¸',$D,'-',$1,'-',$1
	dc.b        '˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3
	dc.b        $0,$2,'˛',$2,$2,$2,'˛',$8,'¸',$D,'(',$1,'(',$1
	dc.b        '˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3
	dc.b        $0,$2,'˛',$2,$2,$2,'˛',$9,'¸',$D,')',$1,')',$1
	dc.b        '˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3
	dc.b        $0,$2,'˛',$2,$2,$2,'˛',$9,'¸',$D,'+',$1,'+',$1
	dc.b        '˛',$6,'-',$3,'¸',$B,'-',$3,'¸',$9,'-',$3,'¸'
	dc.b        $7,'-',$3,'¸',$5,'-',$3,'¸',$3,'-',$3,'¸',$1
	dc.b        '-',$E,'¸',$D,'-',$3,'¸',$B,'-',$3,'¸',$9,'-'
	dc.b        $3,'¸',$7,'-',$3,'¸',$5,'-',$3,'¸',$3,'-',$3
	dc.b        '¸',$1,'-',$E,'˛',$1,'¸',$E,$0,$4,'˛',$2,$2
	dc.b        $3,'˛',$1,$0,$3,$0,$2,'˛',$2,$2,$4,'˛',$1,$0
	dc.b        $4,'˛',$2,$2,$3,'˛',$1,$0,$3,$0,$2,'˛',$2,$2
	dc.b        $4,'˛',$1,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3,$0
	dc.b        $2,'˛',$2,$2,$4,'˛',$1,$0,$4,'˛',$2,$2,$3,'˛'
	dc.b        $1,$0,$3,$0,$2,'˛',$2,$2,$4,'˛',$1,'¸',$1,'9'
	dc.b        $4,'˛',$2,'_',$3,'˛',$1,'9',$3,'9',$2,'˛',$2
	dc.b        '_',$4,'˛',$1,'9',$4,'˛',$2,'_',$3,'˛',$1,'9'
	dc.b        $3,'9',$2,'˛',$2,'_',$4,'˛',$1,'9',$4,'˛',$2
	dc.b        '_',$3,'˛',$1,'9',$3,'9',$2,'˛',$2,'_',$4,'˛'
	dc.b        $1,'9',$1,'˛',$2,'_',$2,'˛',$1,'9',$1,'9',$2
	dc.b        '˛',$2,'_',$1,'_',$2,'_',$1,'_',$1,'_',$2,'_'
	dc.b        $2,'_',$1,'˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛'
	dc.b        $1,$0,$3,$0,$2,'˛',$2,$2,$2,'˛',$8,'¸',$D,'-'
	dc.b        $1,'-',$1,'˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛'
	dc.b        $1,$0,$3,$0,$2,'˛',$2,$2,$2,'˛',$8,'¸',$D,'('
	dc.b        $1,'(',$1,'˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛'
	dc.b        $1,$0,$3,$0,$2,'˛',$2,$2,$2,'˛',$9,'¸',$D,')'
	dc.b        $1,')',$1,'˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛'
	dc.b        $1,$0,$3,$0,$2,'˛',$2,$2,$2,'˛',$9,'¸',$D,'+'
	dc.b        $1,'+',$1,'˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛'
	dc.b        $1,$0,$3,$0,$2,'˛',$2,$2,$2,'˛',$8,'¸',$D,'-'
	dc.b        $1,'-',$1,'˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛'
	dc.b        $1,$0,$3,$0,$2,'˛',$2,$2,$2,'˛',$8,'¸',$D,'('
	dc.b        $1,'(',$1,'˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛'
	dc.b        $1,$0,$3,$0,$2,'˛',$2,$2,$2,'˛',$9,'¸',$D,')'
	dc.b        $1,')',$1,'˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛'
	dc.b        $1,$0,$3,$0,$2,'˛',$2,$2,$2,'˛',$9,'¸',$D,'+'
	dc.b        $1,'+',$1,'˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛'
	dc.b        $1,$0,$3,$0,$2,'˛',$2,$2,$3,$2,$1,'˛',$1,$0
	dc.b        $4,'˛',$2,$2,$3,'˛',$1,$0,$3,$0,$2,'˛',$2,$2
	dc.b        $3,$2,$1,'˛',$1,$0,$4,'˛',$2,$2,$3,'˛',$1,$0
	dc.b        $3,$0,$2,'˛',$2,$2,$3,$2,$1,'˛',$1,$0,$1,'˛'
	dc.b        $2,$2,$2,'˛',$1,$0,$1,$0,$2,'˛',$2,$2,$1,$2
	dc.b        $2,$2,$1,$2,$2,$2,$1,$2,$2,$2,$1,'˛',$1,$0,$4
	dc.b        '˛',$2,$2,$3,'˛',$1,$0,$3,$0,$2,'˛',$2,$2,$3
	dc.b        $2,$1,'˛',$1,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3
	dc.b        $0,$2,'˛',$2,$2,$3,$2,$1,'˛',$1,$0,$4,'˛',$2
	dc.b        $2,$3,'˛',$1,$0,$3,$0,$2,'˛',$2,$2,$3,$2,$1
	dc.b        '˛',$1,$0,$1,'˛',$2,$2,$2,'˛',$1,$0,$1,$0,$2
	dc.b        '˛',$2,$2,$1,$2,$2,$2,$1,$2,$2,$2,$1,$2,$2,$2
	dc.b        $1,'˛',$1,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3,$0
	dc.b        $2,'˛',$2,$2,$2,'˛',$8,'¸',$D,'-',$1,'-',$1
	dc.b        '˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3
	dc.b        $0,$2,'˛',$2,$2,$2,'˛',$8,'¸',$D,'(',$1,'(',$1
	dc.b        '˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3
	dc.b        $0,$2,'˛',$2,$2,$2,'˛',$9,'¸',$D,')',$1,')',$1
	dc.b        '˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3
	dc.b        $0,$2,'˛',$2,$2,$2,'˛',$9,'¸',$D,'+',$1,'+',$1
	dc.b        '˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3
	dc.b        $0,$2,'˛',$2,$2,$2,'˛',$8,'¸',$D,'-',$1,'-',$1
	dc.b        '˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3
	dc.b        $0,$2,'˛',$2,$2,$2,'˛',$8,'¸',$D,'(',$1,'(',$1
	dc.b        '˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3
	dc.b        $0,$2,'˛',$2,$2,$2,'˛',$9,'¸',$D,')',$1,')',$1
	dc.b        '˛',$1,'¸',$E,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3
	dc.b        $0,$2,'˛',$2,$2,$2,'˛',$9,'¸',$D,'+',$1,'+',$1
	dc.b        '˛',$6,'-',$3,'¸',$B,'-',$3,'¸',$9,'-',$3,'¸'
	dc.b        $7,'-',$3,'¸',$5,'-',$3,'¸',$3,'-',$3,'¸',$1
	dc.b        '-',$E,'¸',$D,'-',$3,'¸',$B,'-',$3,'¸',$9,'-'
	dc.b        $3,'¸',$7,'-',$3,'¸',$5,'-',$3,'¸',$3,'-',$3
	dc.b        '¸',$1,'-',$E,'˛',$1,'¸',$E,$0,$4,'˛',$2,$2
	dc.b        $3,'˛',$1,$0,$3,$0,$2,'˛',$2,$2,$4,'˛',$1,$0
	dc.b        $4,'˛',$2,$2,$3,'˛',$1,$0,$3,$0,$2,'˛',$2,$2
	dc.b        $4,'˛',$1,$0,$4,'˛',$2,$2,$3,'˛',$1,$0,$3,$0
	dc.b        $2,'˛',$2,$2,$4,'˛',$1,$0,$4,'˛',$2,$2,$3,'˛'
	dc.b        $1,$0,$3,$0,$2,'˛',$2,$2,$4,'˛',$1,'¸',$1,'9'
	dc.b        $4,'˛',$2,'_',$3,'˛',$1,'9',$3,'9',$2,'˛',$2
	dc.b        '_',$4,'˛',$1,'9',$4,'˛',$2,'_',$3,'˛',$1,'9'
	dc.b        $3,'9',$2,'˛',$2,'_',$4,'˛',$1,'9',$4,'˛',$2
	dc.b        '_',$3,'˛',$1,'9',$3,'9',$2,'˛',$2,'_',$4,'˛'
	dc.b        $1,'9',$1,'˛',$2,'_',$2,'˛',$1,'9',$1,'9',$2
	dc.b        '˛',$2,'_',$1,'_',$2,'_',$1,'_',$1,'_',$2,'_'
	dc.b        $2,'_',$1,'ˇTHK˛',$4,'¸',$D,'-',$2,'0',$2,'4'
	dc.b        $2,'5',$2,'4',$2,'0',$2,'-',$2,'(',$2,'-',$2
	dc.b        '0',$2,'4',$2,'5',$2,'4',$2,'0',$2,'-',$2,'('
	dc.b        $2,'-',$2,'0',$2,'4',$2,'5',$2,'4',$2,'0',$2
	dc.b        '-',$2,'(',$2,'-',$2,'0',$2,'4',$2,'5',$2,'4'
	dc.b        $2,'0',$2,'-',$2,'(',$2,'-',$2,'0',$2,'4',$2
	dc.b        '5',$2,'4',$2,'0',$2,'-',$2,'(',$2,'-',$2,'0'
	dc.b        $2,'4',$2,'5',$2,'4',$2,'0',$2,'-',$2,'(',$2
	dc.b        '-',$2,'0',$2,'4',$2,'5',$2,'4',$2,'0',$2,'-'
	dc.b        $2,'(',$2,'-',$2,'0',$2,'4',$2,'5',$2,'4',$2
	dc.b        '0',$2,'-',$2,'(',$2,'-',$2,'0',$2,'4',$2,'5'
	dc.b        $2,'4',$2,'0',$2,'-',$2,'(',$2,'-',$2,'0',$2
	dc.b        '4',$2,'5',$2,'4',$2,'0',$2,'-',$2,'(',$2,'-'
	dc.b        $2,'0',$2,'4',$2,'5',$2,'4',$2,'0',$2,'-',$2
	dc.b        '(',$2,'-',$2,'0',$2,'4',$2,'5',$2,'4',$2,'0'
	dc.b        $2,'-',$2,'(',$2,'-',$2,'0',$2,'4',$2,'5',$2
	dc.b        '4',$2,'0',$2,'-',$2,'(',$2,'-',$2,'0',$2,'4'
	dc.b        $2,'5',$2,'4',$2,'0',$2,'-',$2,'(',$2,'-',$2
	dc.b        '0',$2,'4',$2,'5',$2,'4',$2,'0',$2,'-',$2,'('
	dc.b        $2,'-',$2,'0',$2,'4',$2,'5',$2,'4',$2,'0',$2
	dc.b        '-',$2,'(',$2,'¸',$B,'(',$3,'¸',$9,'(',$3,'¸'
	dc.b        $7,'(',$3,'¸',$5,'(',$3,'¸',$3,'(',$3,'¸',$1
	dc.b        '(',$11,'¸',$D,'-',$4,'(',$2,'-',$2,'0',$1,'-'
	dc.b        $1,'0',$1,'4',$1,'9',$2,'7',$1,'9',$1,'7',$4
	dc.b        '2',$2,'0',$2,'/',$1,'-',$1,'+',$1,'-',$1,'/'
	dc.b        $2,'-',$1,'/',$1,'0',$4,'-',$2,'+',$2,'0',$1
	dc.b        '-',$1,'+',$1,'-',$3,'+',$1,'-',$1,'+',$4,'-'
	dc.b        $4,'/',$4,'4',$4,'-',$4,'(',$2,'-',$2,'0',$1
	dc.b        '-',$1,'0',$1,'4',$1,'9',$2,'7',$1,'9',$1,'7'
	dc.b        $4,'2',$2,'0',$2,'/',$1,'-',$1,'+',$1,'-',$1
	dc.b        '/',$2,'-',$1,'/',$1,'0',$4,'-',$2,'+',$2,'0'
	dc.b        $1,'-',$1,'+',$1,'-',$3,'+',$1,'-',$1,'+',$4
	dc.b        '-',$4,'/',$4,'4',$4,'˛',$8,'-',$1,'˛',$4,'4'
	dc.b        $1,'˛',$8,'-',$1,'˛',$4,'4',$1,'˛',$8,'-',$1
	dc.b        '-',$1,'˛',$4,'¸',$C,'4',$1,'˛',$8,'¸',$D,'-'
	dc.b        $1,'˛',$4,'¸',$B,'4',$1,'˛',$8,'¸',$D,'-',$1
	dc.b        '˛',$4,'¸',$B,'4',$1,'˛',$8,'¸',$D,'-',$1,'-'
	dc.b        $1,'˛',$4,'¸',$A,'4',$1,'˛',$8,'¸',$D,'-',$1
	dc.b        '-',$1,'(',$1,'˛',$4,'¸',$9,'4',$1,'˛',$8,'¸'
	dc.b        $D,'(',$1,'˛',$4,'¸',$9,'4',$1,'˛',$8,'¸',$D
	dc.b        '(',$1,'(',$1,'˛',$4,'¸',$7,'4',$1,'˛',$8,'¸'
	dc.b        $D,'(',$1,'˛',$4,'¸',$6,'4',$1,'˛',$8,'¸',$D
	dc.b        '(',$1,'˛',$4,'¸',$6,'4',$1,'˛',$8,'¸',$D,'('
	dc.b        $1,'(',$1,'˛',$4,'¸',$5,'4',$1,'˛',$8,'¸',$D
	dc.b        '(',$1,'(',$1,'˛',$9,')',$1,'˛',$4,'¸',$4,'4'
	dc.b        $1,'˛',$9,'¸',$D,')',$1,'˛',$4,'¸',$4,'4',$1
	dc.b        '˛',$9,'¸',$D,')',$1,')',$1,'˛',$4,'¸',$3,'4'
	dc.b        $1,'˛',$9,'¸',$D,')',$1,'˛',$4,'¸',$2,'4',$1
	dc.b        '˛',$9,'¸',$D,')',$1,'˛',$4,'¸',$2,'4',$1,'˛'
	dc.b        $9,'¸',$D,')',$1,')',$1,'˛',$4,'¸',$1,'4',$1
	dc.b        '˛',$9,'¸',$D,')',$1,')',$1,'+',$1,'˛',$4,'¸'
	dc.b        $1,'4',$1,'˛',$9,'¸',$D,'+',$1,'˛',$4,'¸',$1
	dc.b        '4',$1,'˛',$9,'¸',$D,'+',$1,'+',$1,'˛',$4,'¸'
	dc.b        $1,'4',$1,'˛',$9,'¸',$D,'+',$1,'˛',$4,'¸',$1
	dc.b        '4',$1,'˛',$9,'¸',$D,'+',$1,'˛',$4,'¸',$1,'4'
	dc.b        $1,'˛',$9,'¸',$D,'+',$1,'+',$1,'˛',$4,'¸',$1
	dc.b        '4',$1,'˛',$9,'¸',$D,'+',$1,'+',$1,'˛',$8,'-'
	dc.b        $1,'˛',$4,'¸',$1,'4',$1,'˛',$8,'¸',$D,'-',$1
	dc.b        '˛',$4,'¸',$1,'4',$1,'˛',$8,'¸',$D,'-',$1,'-'
	dc.b        $1,'˛',$4,'¸',$1,'4',$1,'˛',$8,'¸',$D,'-',$1
	dc.b        '˛',$4,'¸',$1,'4',$1,'˛',$8,'¸',$D,'-',$1,'˛'
	dc.b        $4,'¸',$1,'4',$1,'˛',$8,'¸',$D,'-',$1,'-',$1
	dc.b        '˛',$4,'¸',$1,'4',$1,'˛',$8,'¸',$D,'-',$1,'-'
	dc.b        $1,'(',$1,'˛',$4,'¸',$1,'4',$1,'˛',$8,'¸',$D
	dc.b        '(',$1,'˛',$4,'¸',$1,'4',$1,'˛',$8,'¸',$D,'('
	dc.b        $1,'(',$1,'˛',$4,'¸',$1,'4',$1,'˛',$8,'¸',$D
	dc.b        '(',$1,'˛',$4,'¸',$1,'4',$1,'˛',$8,'¸',$D,'('
	dc.b        $1,'˛',$4,'¸',$1,'4',$1,'˛',$8,'¸',$D,'(',$1
	dc.b        '(',$1,'˛',$4,'¸',$1,'4',$1,'˛',$8,'¸',$D,'('
	dc.b        $1,'(',$1,'˛',$9,')',$1,'˛',$4,'¸',$1,'4',$1
	dc.b        '˛',$9,'¸',$D,')',$1,'˛',$4,'¸',$1,'4',$1,'˛'
	dc.b        $9,'¸',$D,')',$1,')',$1,'˛',$4,'¸',$1,'4',$1
	dc.b        '˛',$9,'¸',$D,')',$1,'˛',$4,'¸',$1,'4',$1,'˛'
	dc.b        $9,'¸',$D,')',$1,'˛',$4,'¸',$1,'4',$1,'˛',$9
	dc.b        '¸',$D,')',$1,')',$1,'˛',$4,'¸',$1,'4',$1,'˛'
	dc.b        $9,'¸',$D,')',$1,')',$1,'+',$1,'˛',$4,'¸',$1
	dc.b        '4',$1,'˛',$9,'¸',$D,'+',$1,'˛',$4,'¸',$1,'4'
	dc.b        $1,'˛',$9,'¸',$D,'+',$1,'+',$1,'˛',$4,'¸',$1
	dc.b        '4',$1,'˛',$9,'¸',$D,'+',$1,'˛',$4,'¸',$1,'4'
	dc.b        $1,'˛',$9,'¸',$D,'+',$1,'˛',$4,'¸',$1,'4',$1
	dc.b        '˛',$9,'¸',$D,'+',$1,'+',$1,'˛',$4,'¸',$1,'4'
	dc.b        $1,'˛',$9,'¸',$D,'+',$1,'+',$1,'˛',$4,'-',$4
	dc.b        '(',$2,'-',$2,'0',$1,'-',$1,'0',$1,'4',$1,'9'
	dc.b        $2,'7',$1,'9',$1,'7',$4,'2',$2,'0',$2,'/',$1
	dc.b        '-',$1,'+',$1,'-',$1,'/',$2,'-',$1,'/',$1,'0'
	dc.b        $4,'-',$2,'+',$2,'0',$1,'-',$1,'+',$1,'-',$3
	dc.b        '+',$1,'-',$1,'+',$4,'-',$4,'/',$4,'4',$4,'-'
	dc.b        $4,'(',$2,'-',$2,'0',$1,'-',$1,'0',$1,'4',$1
	dc.b        '9',$2,'7',$1,'9',$1,'7',$4,'2',$2,'0',$2,'/'
	dc.b        $1,'-',$1,'+',$1,'-',$1,'/',$2,'-',$1,'/',$1
	dc.b        '0',$4,'-',$2,'+',$2,'0',$1,'-',$1,'+',$1,'-'
	dc.b        $3,'+',$1,'-',$1,'+',$4,'-',$4,'/',$4,'4',$4
	dc.b        '4',$4,'¸',$B,'4',$4,'¸',$9,'4',$4,'¸',$7,'4'
	dc.b        $4,'¸',$5,'4',$4,'¸',$3,'4',$4,'¸',$1,'4(¸',$D
	dc.b        '-',$2,'0',$2,'4',$2,'5',$2,'4',$2,'0',$2,'-'
	dc.b        $2,'(',$2,'(',$2,'+',$2,'/',$2,'0',$2,'/',$2
	dc.b        '+',$2,'(',$2,'#',$2,'-',$2,'0',$2,'4',$2,'5'
	dc.b        $2,'4',$2,'0',$2,'-',$2,'(',$2,'(',$2,'+',$2
	dc.b        '/',$2,'0',$2,'/',$2,'+',$2,'(',$2,'#',$2,'-'
	dc.b        $2,'0',$2,'4',$2,'5',$2,'4',$2,'0',$2,'-',$2
	dc.b        '(',$2,'(',$2,'+',$2,'/',$2,'0',$2,'/',$2,'+'
	dc.b        $2,'(',$2,'#',$2,'-',$2,'0',$2,'4',$2,'5',$2
	dc.b        '4',$2,'0',$2,'-',$2,'(',$2,'(',$2,'+',$2,'/'
	dc.b        $2,'0',$2,'/',$2,'+',$2,'(',$2,'#',$2,'-',$4
	dc.b        '(',$2,'-',$2,'0',$1,'-',$1,'0',$1,'4',$1,'9'
	dc.b        $2,'7',$1,'9',$1,'7',$4,'2',$2,'0',$2,'/',$1
	dc.b        '-',$1,'+',$1,'-',$1,'/',$2,'-',$1,'/',$1,'0'
	dc.b        $4,'-',$2,'+',$2,'0',$1,'-',$1,'+',$1,'-',$3
	dc.b        '+',$1,'-',$1,'+',$4,'-',$4,'/',$4,'4',$4,'-'
	dc.b        $4,'(',$2,'-',$2,'0',$1,'-',$1,'0',$1,'4',$1
	dc.b        '9',$2,'7',$1,'9',$1,'7',$4,'2',$2,'0',$2,'/'
	dc.b        $1,'-',$1,'+',$1,'-',$1,'/',$2,'-',$1,'/',$1
	dc.b        '0',$4,'-',$2,'+',$2,'0',$1,'-',$1,'+',$1,'-'
	dc.b        $3,'+',$1,'-',$1,'+',$4,'-',$4,'/',$4,'4',$4
	dc.b        '˛',$8,'-',$1,'˛',$4,'4',$1,'˛',$8,'-',$1,'˛'
	dc.b        $4,'4',$1,'˛',$8,'-',$1,'-',$1,'˛',$4,'¸',$C
	dc.b        '4',$1,'˛',$8,'¸',$D,'-',$1,'˛',$4,'¸',$B,'4'
	dc.b        $1,'˛',$8,'¸',$D,'-',$1,'˛',$4,'¸',$B,'4',$1
	dc.b        '˛',$8,'¸',$D,'-',$1,'-',$1,'˛',$4,'¸',$A,'4'
	dc.b        $1,'˛',$8,'¸',$D,'-',$1,'-',$1,'(',$1,'˛',$4
	dc.b        '¸',$9,'4',$1,'˛',$8,'¸',$D,'(',$1,'˛',$4,'¸'
	dc.b        $9,'4',$1,'˛',$8,'¸',$D,'(',$1,'(',$1,'˛',$4
	dc.b        '¸',$7,'4',$1,'˛',$8,'¸',$D,'(',$1,'˛',$4,'¸'
	dc.b        $6,'4',$1,'˛',$8,'¸',$D,'(',$1,'˛',$4,'¸',$6
	dc.b        '4',$1,'˛',$8,'¸',$D,'(',$1,'(',$1,'˛',$4,'¸'
	dc.b        $5,'4',$1,'˛',$8,'¸',$D,'(',$1,'(',$1,'˛',$9
	dc.b        ')',$1,'˛',$4,'¸',$4,'4',$1,'˛',$9,'¸',$D,')'
	dc.b        $1,'˛',$4,'¸',$4,'4',$1,'˛',$9,'¸',$D,')',$1
	dc.b        ')',$1,'˛',$4,'¸',$3,'4',$1,'˛',$9,'¸',$D,')'
	dc.b        $1,'˛',$4,'¸',$2,'4',$1,'˛',$9,'¸',$D,')',$1
	dc.b        '˛',$4,'¸',$2,'4',$1,'˛',$9,'¸',$D,')',$1,')'
	dc.b        $1,'˛',$4,'¸',$1,'4',$1,'˛',$9,'¸',$D,')',$1
	dc.b        ')',$1,'+',$1,'˛',$4,'¸',$1,'4',$1,'˛',$9,'¸'
	dc.b        $D,'+',$1,'˛',$4,'¸',$1,'4',$1,'˛',$9,'¸',$D
	dc.b        '+',$1,'+',$1,'˛',$4,'¸',$1,'4',$1,'˛',$9,'¸'
	dc.b        $D,'+',$1,'˛',$4,'¸',$1,'4',$1,'˛',$9,'¸',$D
	dc.b        '+',$1,'˛',$4,'¸',$1,'4',$1,'˛',$9,'¸',$D,'+'
	dc.b        $1,'+',$1,'˛',$4,'¸',$1,'4',$1,'˛',$9,'¸',$D
	dc.b        '+',$1,'+',$1,'˛',$8,'-',$1,'˛',$4,'¸',$1,'4'
	dc.b        $1,'˛',$8,'¸',$D,'-',$1,'˛',$4,'¸',$1,'4',$1
	dc.b        '˛',$8,'¸',$D,'-',$1,'-',$1,'˛',$4,'¸',$1,'4'
	dc.b        $1,'˛',$8,'¸',$D,'-',$1,'˛',$4,'¸',$1,'4',$1
	dc.b        '˛',$8,'¸',$D,'-',$1,'˛',$4,'¸',$1,'4',$1,'˛'
	dc.b        $8,'¸',$D,'-',$1,'-',$1,'˛',$4,'¸',$1,'4',$1
	dc.b        '˛',$8,'¸',$D,'-',$1,'-',$1,'(',$1,'˛',$4,'¸'
	dc.b        $1,'4',$1,'˛',$8,'¸',$D,'(',$1,'˛',$4,'¸',$1
	dc.b        '4',$1,'˛',$8,'¸',$D,'(',$1,'(',$1,'˛',$4,'¸'
	dc.b        $1,'4',$1,'˛',$8,'¸',$D,'(',$1,'˛',$4,'¸',$1
	dc.b        '4',$1,'˛',$8,'¸',$D,'(',$1,'˛',$4,'¸',$1,'4'
	dc.b        $1,'˛',$8,'¸',$D,'(',$1,'(',$1,'˛',$4,'¸',$1
	dc.b        '4',$1,'˛',$8,'¸',$D,'(',$1,'(',$1,'˛',$9,')'
	dc.b        $1,'˛',$4,'¸',$1,'4',$1,'˛',$9,'¸',$D,')',$1
	dc.b        '˛',$4,'¸',$1,'4',$1,'˛',$9,'¸',$D,')',$1,')'
	dc.b        $1,'˛',$4,'¸',$1,'4',$1,'˛',$9,'¸',$D,')',$1
	dc.b        '˛',$4,'¸',$1,'4',$1,'˛',$9,'¸',$D,')',$1,'˛'
	dc.b        $4,'¸',$1,'4',$1,'˛',$9,'¸',$D,')',$1,')',$1
	dc.b        '˛',$4,'¸',$1,'4',$1,'˛',$9,'¸',$D,')',$1,')'
	dc.b        $1,'+',$1,'˛',$4,'¸',$1,'4',$1,'˛',$9,'¸',$D
	dc.b        '+',$1,'˛',$4,'¸',$1,'4',$1,'˛',$9,'¸',$D,'+'
	dc.b        $1,'+',$1,'˛',$4,'¸',$1,'4',$1,'˛',$9,'¸',$D
	dc.b        '+',$1,'˛',$4,'¸',$1,'4',$1,'˛',$9,'¸',$D,'+'
	dc.b        $1,'˛',$4,'¸',$1,'4',$1,'˛',$9,'¸',$D,'+',$1
	dc.b        '+',$1,'˛',$4,'¸',$1,'4',$1,'˛',$9,'¸',$D,'+'
	dc.b        $1,'+',$1,'˛',$4,'-',$4,'(',$2,'-',$2,'0',$1
	dc.b        '-',$1,'0',$1,'4',$1,'9',$2,'7',$1,'9',$1,'7'
	dc.b        $4,'2',$2,'0',$2,'/',$1,'-',$1,'+',$1,'-',$1
	dc.b        '/',$2,'-',$1,'/',$1,'0',$4,'-',$2,'+',$2,'0'
	dc.b        $1,'-',$1,'+',$1,'-',$3,'+',$1,'-',$1,'+',$4
	dc.b        '-',$4,'/',$4,'4',$4,'-',$4,'(',$2,'-',$2,'0'
	dc.b        $1,'-',$1,'0',$1,'4',$1,'9',$2,'7',$1,'9',$1
	dc.b        '7',$4,'2',$2,'0',$2,'/',$1,'-',$1,'+',$1,'-'
	dc.b        $1,'/',$2,'-',$1,'/',$1,'0',$4,'-',$2,'+',$2
	dc.b        '0',$1,'-',$1,'+',$1,'-',$3,'+',$1,'-',$1,'+'
	dc.b        $4,'-',$4,'/',$4,'4',$4,'4',$4,'¸',$B,'4',$4
	dc.b        '¸',$9,'4',$4,'¸',$7,'4',$4,'¸',$5,'4',$4,'¸'
	dc.b        $3,'4',$4,'¸',$1,'4(¸',$D,'-',$2,'0',$2,'4',$2
	dc.b        '5',$2,'4',$2,'0',$2,'-',$2,'(',$2,'(',$2,'+'
	dc.b        $2,'/',$2,'0',$2,'/',$2,'+',$2,'(',$2,'#',$2
	dc.b        '-',$2,'0',$2,'4',$2,'5',$2,'4',$2,'0',$2,'-'
	dc.b        $2,'(',$2,'(',$2,'+',$2,'/',$2,'0',$2,'/',$2
	dc.b        '+',$2,'(',$2,'#',$2,'-',$2,'0',$2,'4',$2,'5'
	dc.b        $2,'4',$2,'0',$2,'-',$2,'(',$2,'(',$2,'+',$2
	dc.b        '/',$2,'0',$2,'/',$2,'+',$2,'(',$2,'#',$2,'-'
	dc.b        $2,'0',$2,'4',$2,'5',$2,'4',$2,'0',$2,'-',$2
	dc.b        '(',$2,'(',$2,'+',$2,'/',$2,'0',$2,'/',$2,'+'
	dc.b        $2,'(',$2,'#',$2,'ˇTHKEnd',$0,'of',$0,'the',$0
	dc.b        'muzak-file',$D,$A,$0
	even

	IFEQ	ACCES_DISQUE	; if ACCES_DISQUE = 0	
Emp	dc.b 'C:\dcd_120\',0
	ENDC
	IFNE	ACCES_DISQUE	; if ACCES_DISQUE = 1
Emp	dc.b 'A:\',0
	ENDC

Prog1	dc.b '1.BSW',0
Prog2	dc.b '2.BSW',0
Prog3	dc.b '3.BSW',0
Prog4	dc.b '4.BSW',0
Prog5	dc.b '5.BSW',0
Prog6	dc.b '6.BSW',0
Prog7	dc.b '7.BSW',0
Prog8	dc.b '8.BSW',0
Prog9	dc.b '9.BSW',0
ProgCrc	dc.b 'CRCCHECK.PRG',0
NOMPRG:	ds.l	1

errtext:       DC.b "PROBLEMS TO LOAD...",13,10,10,0
params:        DC.b 0    ;aucun paramätre et
environ:       DC.b 0    ;aucun environnement

******************************************************************

	END

