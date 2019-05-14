* AL_6a.PRG

* // Code & Ripp	 : Zorro2/NoExtra	// *
* // Gfx neochrome master: Mister. A/NoExtra	// *
* // Music 		 : Jedi			// *
* // Release date 	 : 10/06/2006		// *

***********************************************
	opt	o-,d-
***********************************************

	SECTION	TEXT

***********************************************
COLOR_RAST	EQU	$FFFF8242
SEEMYVBL	equ	1 ;	0 = see cpu & 1 = nothing
***********************************************

	move.l  4(sp),a5                ; address to basepage
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
	trap    #1                  	;
	lea 	12(sp),sp               ;  
	
	clr.l	-(sp)
	move.w	#32,-(sp)
	trap	#1
	addq.l	#6,sp
	move.l	d0,Save_stack

	bsr	Init_screens

	bsr	Save_and_init_a_st

	bsr	fadein
	
	bsr	Put_LogoNoEx
	
	bsr	Init

	jsr	MUSIC+0			; init music

******************************************************************************

	lea     PalNoeXtra,a2
	bsr     fadeon	
	
	bsr	Init_Courbe
	
	bsr	delay
	
	bsr	fadeoff

	lea	GO_RASTER,a0
	st	(a0)

	bsr	Cls_screens

	bsr	Put_TheHbl
	
	bsr	Put_TheScreen
		    
Main_rout:

	bsr	Wait_vbl

	IFEQ	SEEMYVBL
	move.w	#$100,$ffff8240.w
	ENDC
	
*

	MOVE.L    Zorro_scr1,D0
	MOVE.L    Zorro_scr2,Zorro_scr1 
	MOVE.L    D0,Zorro_scr2
	LSR.W     #8,D0 
	MOVE.L    D0,$FFFF8200.W

	move.l	a6,-(a7)
	bsr	logo_mover
	move.l	(a7)+,a6

	bsr	Lignes

	bsr	SCROLLING_s1
	bsr	SCROLLING_s2

*

	IFEQ	SEEMYVBL
	cmp.b	#$38,$fffffc02.w	* Wait
	bne.s	Suite_rout		* Alt
	move.b	#$7,$ffff8240.w
Suite_rout:	
	ENDC
	cmp.b	#$39,$fffffc02.w	* Wait
	bne.s	Main_rout		* Space

******************************************************************************

	jsr	MUSIC+4			; de-init music

	move.b 	#8,$ffff8800.w        ; Sound OFF
	move.b 	#0,$ffff8802.w
	move.b 	#9,$ffff8800.w
	move.b 	#0,$ffff8802.w
	move.b 	#$a,$ffff8800.w
	move.b 	#0,$ffff8802.w
  
	bsr	Restore_st

Kflush:
	btst	#0,$fffffc00.w
	beq.s	Flush_ok
	move.b	$fffffc02.w,d0
	bra.s	Kflush
Flush_ok:

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

GO_RASTER:
		ds.w	1

Vbl:

	st	Vsync

 	tst.b	(GO_RASTER)
	beq.s	.suite
	CLR.B     $FFFFFA1B.W 
	MOVE.W    PAL_RAST,COLOR_RAST.W
	MOVE.W    PAL_RAST,COLOR 
	MOVE.W    #2,PTR_RAST
	MOVE.B    #3,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W
.suite:
	
	jsr 	(MUSIC+8)			; call music

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

Put_TheHbl:
	movem.l	d0-d7/a0-a6,-(a7)

	ANDI.B    #$DF,$FFFFFA09.W
	ANDI.B    #$FE,$FFFFFA07.W
	lea	Hbl(pc),a0
	move.l	a0,$120.w
 	ORI.B     #1,$FFFFFA07.W
  ORI.B     #1,$FFFFFA13.W

	stop	#$2300

	movem.l	(a7)+,d0-d7/a0-a6
	rts

Init:	movem.l	d0-d7/a0-a6,-(a7)

	lea	Vbl(pc),a0
	move.l	a0,$70.w

	movem.l	(a7)+,d0-d7/a0-a6
	rts

************************************************
*                                              *
************************************************

Save_and_init_a_st:

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

	sf	$ffff8260.w

	moveq	#0,d0
	lea	$fffffa00.w,a0
	movep.w	d0,$07(a0)
	movep.w	d0,$13(a0)

	bclr	#3,$fffffa17.w

	move.l	Zorro_scr1,d0
	move.b	d0,d1
	lsr.w	#8,d0
	move.b	d0,$ffff8203.w
	swap	d0
	move.b	d0,$ffff8201.w
	move.b	d1,$ffff820d.w

	move.b	$484.w,conterm	; Sauve ce bidule.
	clr.b	$484.w		; No bip,no repeat.
			
	DC.W $A000
	DC.W $A00A

	move.b	#$12,$fffffc02.w	* Couic la souris	
		
	rts

***************************************************************
*                                                             *
*             < Here is the lower raster rout >               *
*                                                             *
***************************************************************

HBL:
		  	MOVE.W    #0,COLOR_RAST.W
COLOR:	EQU       *-4 
      	MOVE.W    COLOR,COLOR_RAST.W 
      	MOVE.W    D0,-(A7)
      	MOVE.L    A0,-(A7)
      	MOVE.W    PTR_RAST,D0
      	LEA       PAL_RAST,A0
      	MOVE.W    0(A0,D0.W),COLOR
      	MOVEA.L   (A7)+,A0
      	MOVE.W    (A7)+,D0
      	ADDQ.W    #2,PTR_RAST
      	RTE 

***************************************************************
*                                                             *
***************************************************************

Restore_st:
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

	move.b	#$8,$fffffc02.w	* Retablit la souris	
	
	DC.W $A000
	DC.W $A009

	move.b	conterm,$484.w	; Remettre ce bidule.
	
* Sorry for the next lines, but sometimes there somes syncs error !!

	move.b	Video,$ffff8260.w
	move.w	#$25,-(a7)
	trap	#14
	addq.w	#2,a7
	move.b	Video,$ffff8260.w

	rts

************************************************
*                                              *
************************************************

Init_screens:
	movem.l	d0-d7/a0-a6,-(a7)

	move.l	#Zorro_screen1,d0
	add.w	#$ff,d0
	sf	d0
	move.l	d0,Zorro_scr1

	move.l	#Zorro_screen2,d0
	add.w	#$ff,d0
	sf	d0
	move.l	d0,Zorro_scr2

	bsr.s	Cls_screens
	
	movem.l	(a7)+,d0-d7/a0-a6
	rts
	
Cls_screens:
	movem.l	d0-d7/a0-a6,-(a7)

	movea.l	Zorro_scr1,a6
	move.w	#Zorro_screen1_len/4-1,d1
fill:
	move.l	#$0,(a6)+
	dbra	d1,fill

	movea.l	Zorro_scr2,a6
	move.w	#Zorro_screen2_len/4-1,d1
fill2:
	move.l	#$0,(a6)+
	dbra	d1,fill2
	
	movem.l	(a7)+,d0-d7/a0-a6
	rts

Put_LogoNoEx:
	movem.l	d0-d7/a0-a6,-(a7)

	movea.l	Zorro_scr1,a1
	adda.l	#160*76,a1
	movea.l	#LogoNoeXtra,a0
	move.l	#7999-6800+180,d0
.aff:	move.l	(a0)+,(a1)+
	dbf	d0,.aff

	movem.l	(a7)+,d0-d7/a0-a6
	rts

bottom	equ	7999-7900+140

Put_LogoArtist:
	movea.l	Zorro_scr1,a1
	adda.l	#160*194,a1
	movea.l	#LOGO_ARTIST,a0
	move.l	#bottom,d0
.aff1:	move.l	(a0)+,(a1)+
	dbf	d0,.aff1

	movea.l	Zorro_scr2,a1
	adda.l	#160*194,a1
	movea.l	#LOGO_ARTIST,a0
	move.l	#bottom,d0
.aff2:	move.l	(a0)+,(a1)+
	dbf	d0,.aff2
	rts
		
Put_TheScreen:
	movem.l	d0-d7/a0-a6,-(a7)

	bsr	Put_LogoArtist	
	
	move.l	Zorro_scr1,d0
	move.b	d0,d1
	lsr.w	#8,d0
	move.b	d0,$ffff8203.w
	swap	d0
	move.b	d0,$ffff8201.w
	move.b	d1,$ffff820d.w

	lea	Pal(pc),a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

	move.w	#$100,$ffff8240.w
	
	movem.l	(a7)+,d0-d7/a0-a6
	rts
	
******************************************************************

go_courbe:
 move.w (a0)+,amplitude_x+2
 move.w (a0)+,coef_x+2
 move.w (a0)+,amplitude_y+2
 move.w (a0)+,coef_y+2
 move.w (a0)+,vit1+4
 lea.l courbe,a1
 bsr.s make_courbe
 move.w (a0)+,amplitude_x+2
 move.w (a0)+,coef_x+2
 move.w (a0)+,amplitude_y+2
 move.w (a0)+,coef_y+2
 move.w (a0)+,vit2+4
 lea.l courbe2,a1
 bsr.s make_courbe
 move.w (a0)+,nbre_points
 rts

make_courbe:
 pea (a0)
 lea.l cosinus,a0

 move.w #0,d0
make_courbe2

; traitement des X

amplitude_x
 move.w #80,d1

 move.w d0,d3
coef_x
 mulu.w #2,d3
test1 cmpi.w #1440,d3
 blo.s no_coef1
 subi.w #1440,d3
 bra.s test1
no_coef1

 muls.w (a0,d3.w),d1
 asr.w #7,d1
 addi.w #160,d1
 asr.w d1

; traitement des Y

amplitude_y
 move.w #80,d2

 move.w d0,d3
coef_y
 mulu.w #3,d3
test2 cmpi.w #1440,d3
 blo.s no_coef2
 subi.w #1440,d3
 bra.s test2
no_coef2

 muls.w 2(a0,d3.w),d2
 asr.w #7,d2
 addi.w #100,d2
 asr.w d2

 move.w d1,1440(a1)
 move.w d1,(a1)+
 
 mulu.w #160,d2		    ; evite le mulu #160 en cours de vbl !
 move.w d2,1440(a1) 	; (et on gagne beaucoup de cycles !)
 move.w d2,(a1)+

 addq.w #4,d0
 cmpi.w #1440,d0
 bne.s make_courbe2
 move.l (sp)+,a0
 rts
 
Lignes:
; efface les anciens points

 movea.l adr_buf1,a0
 movea.l Zorro_scr2,a1
 move.w nbre_points,d0
 moveq.w #0,d2
eff_points:
 move.w (a0)+,d1
 move.w d2,(a1,d1.w)
 dbf d0,eff_points

; transfere buffer d'effacement

 move.l adr_buf1,a0
 move.l adr_buf2,adr_buf1
 move.l a0,adr_buf2

; affiche les points

 move.w nbre_points,d0
 move.l a5,a0
 move.l a6,a2
 movea.l adr_buf2,a3
 movea.l Zorro_scr2,a4
 move.w #$ffff-7,d6
 move.w #32768,d7

aff_points
 
 move.l (a0)+,d1	; traite X et Y dans un meme reg.
 add.l (a2)+,d1

; routine d'affichage d'un point (bien optimisee,ouais !)

 move.w d1,d4		; d4=nbre de ligne-adr ecran
 swap d1
 move.w d1,d2
 lsr.w d1
 and.w d6,d1
 add.w d1,d4
 move.w d4,(a3)+
 lsl.w d1		; equivaut a lsr #3,d1 + lsl.w #4,d1
 sub.w d1,d2
 move.w d7,d1
 lsr.w d2,d1
 or.w d1,(a4,d4.w)
 
 dbf d0,aff_points

vit1 add.l #4,a5
 cmpa.l #courbe+720*2,a5
 blo.s nofin_a5 
 lea.l courbe,a5
nofin_a5

vit2 add.l #8,a6
 cmpa.l #courbe2+720*2,a6
 bne.s nofin_a6
 lea.l courbe2,a6
nofin_a6
	rts

Init_Courbe:
; definie les courbes de deformations
 lea.l mycourbe,a0
 bsr go_courbe

 lea.l courbe,a5
 lea.l courbe2,a6
 rts	 

logo_mover
	move.l Zorro_scr2,a0
	lea	160*30(a0),a0
	addq.w	#2,a0
	move.l logoptr,a1
	move.l (a1)+,d0
	bpl.s .ok
	lea logopos,a1
	move.l (a1)+,d0
.ok
	move.l a1,logoptr
	add.l d0,a0

	lea -160*9(a0),a6
	sub.l #160*9,d0
	moveq #8,d1
	moveq #0,d5
.hline
x	set 0
	rept 40
	move.l d5,x(a6)
x	set x+4
	endr
	add.l #160,d0
	lea 160(a6),a6
	dbra d1,.hline
	
	moveq	#36,d7		; lines
	lea LOGO_AL+2,a1
.lp
	movem.l	(a1)+,d0-d6/a2-a4	; get 40 bytes
	movem.l	d0-d6/a2-a4,(a0)	; put 40 bytes
	movem.l	(a1)+,d0-d6/a2-a4	; and again
	movem.l	d0-d6/a2-a4,40(a0)
	movem.l	(a1)+,d0-d6/a2-a4	; and again
	movem.l	d0-d6/a2-a4,80(a0)
	movem.l	(a1)+,d0-d6/a2-a4	; and again
	movem.l	d0-d6/a2-a4,120(a0)
	lea	160(a0),a0		; next line down
	dbf	d7,.lp

	move.l a0,a6
	moveq #8,d1
	moveq #0,d5
.bline
x	set 0
	rept 40
	move.l d5,x(a6)
x	set x+4
	endr
	add.l #160,d0
	lea 160(a6),a6
	dbra d1,.bline
	rts

SCROLL_s:
	lea	BUFFER_s,a0
	moveq	#7,d0
.loop:
	move	#0,ccr
 rept	21
	roxl	-(a0)
 endr
	lea	84(a0),a0
	dbf	d0,.loop
	rts

SCROLLING_s1:	
	bsr.s	SCROLL_s		
	bsr.s	SCROLL_s
	addi	#1,TAMPON_s
	cmpi	#4,TAMPON_s
	bne.s	.next
	clr	TAMPON_s
	movea.l	DEBUT_TEXTE_s1,a0
	moveq	#0,d0
	move.b	(a0)+,d0
	tst.b	d0
	bpl.s	.next0
	lea	TEXTE_s1,a0
	move.b	(a0)+,d0
.next0:
	move.l	a0,DEBUT_TEXTE_s1
	lea	FONT8_8,a0
	adda	d0,a0
	lea	BUFFER0_s,a1
	move.b	(a0),(a1)
	move.b	256(a0),42(a1)
	move.b	512(a0),84(a1)
	move.b	768(a0),126(a1)
	move.b	1024(a0),168(a1)
	move.b	1280(a0),210(a1)
	move.b	1536(a0),252(a1)
	move.b	1792(a0),294(a1)
.next:	lea	BUFFER1_s,a0
	movea.l	Zorro_scr2,a1
	lea	160*20(a1),a1
	addq.w	#2,a1
	moveq	#1,d1
	moveq	#7,d0
.loop:
	move	(a0)+,(a1)
	move	(a0)+,8(a1)
	move	(a0)+,16(a1)
	move	(a0)+,24(a1)
	move	(a0)+,32(a1)
	move	(a0)+,40(a1)
	move	(a0)+,48(a1)
	move	(a0)+,56(a1)
	move	(a0)+,64(a1)
	move	(a0)+,72(a1)
	move	(a0)+,80(a1)
	move	(a0)+,88(a1)
	move	(a0)+,96(a1)
	move	(a0)+,104(a1)
	move	(a0)+,112(a1)
	move	(a0)+,120(a1)
	move	(a0)+,128(a1)
	move	(a0)+,136(a1)
	move	(a0)+,144(a1)
	move	(a0)+,152(a1)
	lea	160(a1),a1
	addq	#2,a0
	dbf	d0,.loop
	rts

SCROLLING_s2:	
	bsr	SCROLL_s		
	bsr	SCROLL_s
	addi	#1,TAMPON_s
	cmpi	#4,TAMPON_s
	bne.s	.next
	clr	TAMPON_s
	movea.l	DEBUT_TEXTE_s1,a0
	moveq	#0,d0
	move.b	(a0)+,d0
	tst.b	d0
	bpl.s	.next0
	lea	TEXTE_s1,a0
	move.b	(a0)+,d0
.next0:
	move.l	a0,DEBUT_TEXTE_s1
	lea	FONT8_8,a0
	adda	d0,a0
	lea	BUFFER0_s,a1
	move.b	(a0),(a1)
	move.b	256(a0),42(a1)
	move.b	512(a0),84(a1)
	move.b	768(a0),126(a1)
	move.b	1024(a0),168(a1)
	move.b	1280(a0),210(a1)
	move.b	1536(a0),252(a1)
	move.b	1792(a0),294(a1)
.next:	lea	BUFFER1_s,a0
	movea.l	Zorro_scr2,a1
	lea	160*168(a1),a1
	addq.w	#2,a1
	moveq	#1,d1
	moveq	#7,d0
.loop:
	move	(a0)+,(a1)
	move	(a0)+,8(a1)
	move	(a0)+,16(a1)
	move	(a0)+,24(a1)
	move	(a0)+,32(a1)
	move	(a0)+,40(a1)
	move	(a0)+,48(a1)
	move	(a0)+,56(a1)
	move	(a0)+,64(a1)
	move	(a0)+,72(a1)
	move	(a0)+,80(a1)
	move	(a0)+,88(a1)
	move	(a0)+,96(a1)
	move	(a0)+,104(a1)
	move	(a0)+,112(a1)
	move	(a0)+,120(a1)
	move	(a0)+,128(a1)
	move	(a0)+,136(a1)
	move	(a0)+,144(a1)
	move	(a0)+,152(a1)
	lea	160(a1),a1
	addq	#2,a0
	dbf	d0,.loop
	rts

fadein
	movem.l	d0-d7/a0-a6,-(a7)
	move.l	#$777,d0
deg	
	bsr.s	wart
	bsr.s	wart
	bsr.s	wart
	lea	$ffff8240.w,a0
	moveq	#15,d1
chg1	
	move.w	d0,(a0)+
	dbf	d1,chg1
	sub.w	#$111,d0
	bne.s	deg
	clr.w	$ffff8240.w
	movem.l	(a7)+,d0-d7/a0-a6
	rts

wart	
	move.l	d0,-(sp)
	move.l	$466.w,d0
att	
	cmp.l	$466.w,d0
	beq.s	att
	move.l	(sp)+,d0
	rts

fadeon	
	movem.l	d0-d7/a0-a6,-(a7)
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
	movem.l	(a7)+,d0-d7/a0-a6	
	rts

fadeoff	
	movem.l	d0-d7/a0-a6,-(a7)
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
	movem.l	(a7)+,d0-d7/a0-a6	
	rts

delay:
	move.l	d0,-(sp)
 	MOVE.b     #$7F,D0 
.synch:
	BSR       WAIT_VBL
	sub.b	#1,d0
	cmp.b	#$0,d0	
	bne.s	.synch
	move.l	(sp)+,d0	
	rts	
	
	SECTION	DATA

Pal:	
	dc.w	$0000,$00F0,$0765,$0200,$0654,$0644,$0543,$0532
	dc.w	$0292,$0CA9,$0421,$0B98,$0310,$0A88,$0FFF,$0FFF

adr_buf1:
	dc.l old_data
adr_buf2:
	dc.l old_data2

nbre_points even
 dc.w 0

old_data even
 ds.l 300

old_data2 even
 ds.l 300

mycourbe even

 dc.w 120	amplitude_x1
 dc.w 2		coef_x1
 dc.w 100	amplitude_y1
 dc.w 3		coef_y1
 dc.w 4		vitesse courbe 1

 dc.w 130	amplitude_x2
 dc.w 6		coef_x2
 dc.w 100	amplitude_y2
 dc.w 2		coef_y2
 dc.w 8	vitesse courbe 2

 dc.w 359	nbre dans point dans la split-line-1 (0 a 360)

sprite even
 dc.l $38000000,$78000c00,$b6004c00
 dc.l $be004000,$be004000,$44003800

courbe
 ds.w 720*2
 
courbe2
 ds.w 720*2
 
 ds.l 5000
pile:
	ds.l 100

cosinus even
	dc	$0080,$0000,$0080,$0002
	dc	$0080,$0004,$0080,$0007
	dc	$0080,$0009,$0080,$000B
	dc	$007F,$000D,$007F,$0010
	dc	$007F,$0012,$007E,$0014
	dc	$007E,$0016,$007E,$0018
	dc	$007D,$001B,$007D,$001D
	dc	$007C,$001F,$007C,$0021
	dc	$007B,$0023,$007A,$0025
	dc	$007A,$0028,$0079,$002A
	dc	$0078,$002C,$0077,$002E
	dc	$0077,$0030,$0076,$0032
	dc	$0075,$0034,$0074,$0036
	dc	$0073,$0038,$0072,$003A
	dc	$0071,$003C,$0070,$003E
	dc	$006F,$0040,$006E,$0042
	dc	$006D,$0044,$006B,$0046
	dc	$006A,$0048,$0069,$0049
	dc	$0068,$004B,$0066,$004D
	dc	$0065,$004F,$0063,$0051
	dc	$0062,$0052,$0061,$0054
	dc	$005F,$0056,$005E,$0057
	dc	$005C,$0059,$005B,$005B
	dc	$0059,$005C,$0057,$005E
	dc	$0056,$005F,$0054,$0061
	dc	$0052,$0062,$0051,$0063
	dc	$004F,$0065,$004D,$0066
	dc	$004B,$0068,$0049,$0069
	dc	$0048,$006A,$0046,$006B
	dc	$0044,$006D,$0042,$006E
	dc	$0040,$006F,$003E,$0070
	dc	$003C,$0071,$003A,$0072
	dc	$0038,$0073,$0036,$0074
	dc	$0034,$0075,$0032,$0076
	dc	$0030,$0077,$002E,$0077
	dc	$002C,$0078,$002A,$0079
	dc	$0028,$007A,$0025,$007A
	dc	$0023,$007B,$0021,$007C
	dc	$001F,$007C,$001D,$007D
	dc	$001B,$007D,$0018,$007E
	dc	$0016,$007E,$0014,$007E
	dc	$0012,$007F,$0010,$007F
	dc	$000D,$007F,$000B,$0080
	dc	$0009,$0080,$0007,$0080
	dc	$0004,$0080,$0002,$0080
	dc	$0000,$0080,$FFFE,$0080
	dc	$FFFC,$0080,$FFF9,$0080
	dc	$FFF7,$0080,$FFF5,$0080
	dc	$FFF3,$007F,$FFF0,$007F
	dc	$FFEE,$007F,$FFEC,$007E
	dc	$FFEA,$007E,$FFE8,$007E
	dc	$FFE5,$007D,$FFE3,$007D
	dc	$FFE1,$007C,$FFDF,$007C
	dc	$FFDD,$007B,$FFDB,$007A
	dc	$FFD8,$007A,$FFD6,$0079
	dc	$FFD4,$0078,$FFD2,$0077
	dc	$FFD0,$0077,$FFCE,$0076
	dc	$FFCC,$0075,$FFCA,$0074
	dc	$FFC8,$0073,$FFC6,$0072
	dc	$FFC4,$0071,$FFC2,$0070
	dc	$FFC0,$006F,$FFBE,$006E
	dc	$FFBC,$006D,$FFBA,$006B
	dc	$FFB8,$006A,$FFB7,$0069
	dc	$FFB5,$0068,$FFB3,$0066
	dc	$FFB1,$0065,$FFAF,$0063
	dc	$FFAE,$0062,$FFAC,$0061
	dc	$FFAA,$005F,$FFA9,$005E
	dc	$FFA7,$005C,$FFA5,$005B
	dc	$FFA4,$0059,$FFA2,$0057
	dc	$FFA1,$0056,$FF9F,$0054
	dc	$FF9E,$0052,$FF9D,$0051
	dc	$FF9B,$004F,$FF9A,$004D
	dc	$FF98,$004B,$FF97,$0049
	dc	$FF96,$0048,$FF95,$0046
	dc	$FF93,$0044,$FF92,$0042
	dc	$FF91,$0040,$FF90,$003E
	dc	$FF8F,$003C,$FF8E,$003A
	dc	$FF8D,$0038,$FF8C,$0036
	dc	$FF8B,$0034,$FF8A,$0032
	dc	$FF89,$0030,$FF89,$002E
	dc	$FF88,$002C,$FF87,$002A
	dc	$FF86,$0028,$FF86,$0025
	dc	$FF85,$0023,$FF84,$0021
	dc	$FF84,$001F,$FF83,$001D
	dc	$FF83,$001B,$FF82,$0018
	dc	$FF82,$0016,$FF82,$0014
	dc	$FF81,$0012,$FF81,$0010
	dc	$FF81,$000D,$FF80,$000B
	dc	$FF80,$0009,$FF80,$0007
	dc	$FF80,$0004,$FF80,$0002
	dc	$FF80,$0000,$FF80,$FFFE
	dc	$FF80,$FFFC,$FF80,$FFF9
	dc	$FF80,$FFF7,$FF80,$FFF5
	dc	$FF81,$FFF3,$FF81,$FFF0
	dc	$FF81,$FFEE,$FF82,$FFEC
	dc	$FF82,$FFEA,$FF82,$FFE8
	dc	$FF83,$FFE5,$FF83,$FFE3
	dc	$FF84,$FFE1,$FF84,$FFDF
	dc	$FF85,$FFDD,$FF86,$FFDB
	dc	$FF86,$FFD8,$FF87,$FFD6
	dc	$FF88,$FFD4,$FF89,$FFD2
	dc	$FF89,$FFD0,$FF8A,$FFCE
	dc	$FF8B,$FFCC,$FF8C,$FFCA
	dc	$FF8D,$FFC8,$FF8E,$FFC6
	dc	$FF8F,$FFC4,$FF90,$FFC2
	dc	$FF91,$FFC0,$FF92,$FFBE
	dc	$FF93,$FFBC,$FF95,$FFBA
	dc	$FF96,$FFB8,$FF97,$FFB7
	dc	$FF98,$FFB5,$FF9A,$FFB3
	dc	$FF9B,$FFB1,$FF9D,$FFAF
	dc	$FF9E,$FFAE,$FF9F,$FFAC
	dc	$FFA1,$FFAA,$FFA2,$FFA9
	dc	$FFA4,$FFA7,$FFA5,$FFA5
	dc	$FFA7,$FFA4,$FFA9,$FFA2
	dc	$FFAA,$FFA1,$FFAC,$FF9F
	dc	$FFAE,$FF9E,$FFAF,$FF9D
	dc	$FFB1,$FF9B,$FFB3,$FF9A
	dc	$FFB5,$FF98,$FFB7,$FF97
	dc	$FFB8,$FF96,$FFBA,$FF95
	dc	$FFBC,$FF93,$FFBE,$FF92
	dc	$FFC0,$FF91,$FFC2,$FF90
	dc	$FFC4,$FF8F,$FFC6,$FF8E
	dc	$FFC8,$FF8D,$FFCA,$FF8C
	dc	$FFCC,$FF8B,$FFCE,$FF8A
	dc	$FFD0,$FF89,$FFD2,$FF89
	dc	$FFD4,$FF88,$FFD6,$FF87
	dc	$FFD8,$FF86,$FFDB,$FF86
	dc	$FFDD,$FF85,$FFDF,$FF84
	dc	$FFE1,$FF84,$FFE3,$FF83
	dc	$FFE5,$FF83,$FFE8,$FF82
	dc	$FFEA,$FF82,$FFEC,$FF82
	dc	$FFEE,$FF81,$FFF0,$FF81
	dc	$FFF3,$FF81,$FFF5,$FF80
	dc	$FFF7,$FF80,$FFF9,$FF80
	dc	$FFFC,$FF80,$FFFE,$FF80
	dc	$0000,$FF80,$0002,$FF80
	dc	$0004,$FF80,$0007,$FF80
	dc	$0009,$FF80,$000B,$FF80
	dc	$000D,$FF81,$0010,$FF81
	dc	$0012,$FF81,$0014,$FF82
	dc	$0016,$FF82,$0018,$FF82
	dc	$001B,$FF83,$001D,$FF83
	dc	$001F,$FF84,$0021,$FF84
	dc	$0023,$FF85,$0025,$FF86
	dc	$0028,$FF86,$002A,$FF87
	dc	$002C,$FF88,$002E,$FF89
	dc	$0030,$FF89,$0032,$FF8A
	dc	$0034,$FF8B,$0036,$FF8C
	dc	$0038,$FF8D,$003A,$FF8E
	dc	$003C,$FF8F,$003E,$FF90
	dc	$0040,$FF91,$0042,$FF92
	dc	$0044,$FF93,$0046,$FF95
	dc	$0048,$FF96,$0049,$FF97
	dc	$004B,$FF98,$004D,$FF9A
	dc	$004F,$FF9B,$0051,$FF9D
	dc	$0052,$FF9E,$0054,$FF9F
	dc	$0056,$FFA1,$0057,$FFA2
	dc	$0059,$FFA4,$005B,$FFA5
	dc	$005C,$FFA7,$005E,$FFA9
	dc	$005F,$FFAA,$0061,$FFAC
	dc	$0062,$FFAE,$0063,$FFAF
	dc	$0065,$FFB1,$0066,$FFB3
	dc	$0068,$FFB5,$0069,$FFB7
	dc	$006A,$FFB8,$006B,$FFBA
	dc	$006D,$FFBC,$006E,$FFBE
	dc	$006F,$FFC0,$0070,$FFC2
	dc	$0071,$FFC4,$0072,$FFC6
	dc	$0073,$FFC8,$0074,$FFCA
	dc	$0075,$FFCC,$0076,$FFCE
	dc	$0077,$FFD0,$0077,$FFD2
	dc	$0078,$FFD4,$0079,$FFD6
	dc	$007A,$FFD8,$007A,$FFDB
	dc	$007B,$FFDD,$007C,$FFDF
	dc	$007C,$FFE1,$007D,$FFE3
	dc	$007D,$FFE5,$007E,$FFE8
	dc	$007E,$FFEA,$007E,$FFEC
	dc	$007F,$FFEE,$007F,$FFF0
	dc	$007F,$FFF3,$0080,$FFF5
	dc	$0080,$FFF7,$0080,$FFF9
	dc	$0080,$FFFC,$0080,$FFFE

logoptr:
	dc.l logopos
logopos:
	dc	$0000,$3E80,$0000,$3C00
	dc	$0000,$3980,$0000,$3700
	dc	$0000,$3480,$0000,$3200
	dc	$0000,$2F80,$0000,$2DA0
	dc	$0000,$2B20,$0000,$28A0
	dc	$0000,$26C0,$0000,$2440
	dc	$0000,$2260,$0000,$1FE0
	dc	$0000,$1E00,$0000,$1B80
	dc	$0000,$19A0,$0000,$17C0
	dc	$0000,$15E0,$0000,$1400
	dc	$0000,$1220,$0000,$10E0
	dc	$0000,$0F00,$0000,$0DC0
	dc	$0000,$0BE0,$0000,$0AA0
	dc	$0000,$0960,$0000,$0820
	dc	$0000,$06E0,$0000,$0640
	dc	$0000,$0500,$0000,$0460
	dc	$0000,$0320,$0000,$0280
	dc	$0000,$01E0,$0000,$0140
	dc	$0000,$0140,$0000,$00A0
	dc	$0000,$00A0,$0000,$00A0
	dc	$0000,$00A0,$0000,$00A0
	dc	$0000,$00A0,$0000,$00A0
	dc	$0000,$0140,$0000,$0140
	dc	$0000,$01E0,$0000,$0280
	dc	$0000,$0320,$0000,$0460
	dc	$0000,$0500,$0000,$0640
	dc	$0000,$06E0,$0000,$0820
	dc	$0000,$0960,$0000,$0AA0
	dc	$0000,$0BE0,$0000,$0DC0
	dc	$0000,$0F00,$0000,$10E0
	dc	$0000,$1220,$0000,$1400
	dc	$0000,$15E0,$0000,$17C0
	dc	$0000,$19A0,$0000,$1B80
	dc	$0000,$1E00,$0000,$1FE0
	dc	$0000,$2260,$0000,$2440
	dc	$0000,$26C0,$0000,$28A0
	dc	$0000,$2B20,$0000,$2DA0
	dc	$0000,$2F80,$0000,$3200
	dc	$0000,$3480,$0000,$3700
	dc	$0000,$3980,$0000,$3C00
	dc	$0000,$3E80,$0000,$3CA0
	dc	$0000,$3AC0,$0000,$38E0
	dc	$0000,$3700,$0000,$3520
	dc	$0000,$3340,$0000,$3160
	dc	$0000,$3020,$0000,$2E40
	dc	$0000,$2C60,$0000,$2B20
	dc	$0000,$2940,$0000,$2760
	dc	$0000,$2620,$0000,$2440
	dc	$0000,$2300,$0000,$21C0
	dc	$0000,$1FE0,$0000,$1EA0
	dc	$0000,$1D60,$0000,$1C20
	dc	$0000,$1AE0,$0000,$19A0
	dc	$0000,$1900,$0000,$17C0
	dc	$0000,$1680,$0000,$15E0
	dc	$0000,$1540,$0000,$1400
	dc	$0000,$1360,$0000,$12C0
	dc	$0000,$1220,$0000,$1180
	dc	$0000,$1180,$0000,$10E0
	dc	$0000,$1040,$0000,$1040
	dc	$0000,$1040,$0000,$1040
	dc	$0000,$1040,$0000,$1040
	dc	$0000,$1040,$0000,$1040
	dc	$0000,$1040,$0000,$10E0
	dc	$0000,$1180,$0000,$1180
	dc	$0000,$1220,$0000,$12C0
	dc	$0000,$1360,$0000,$1400
	dc	$0000,$1540,$0000,$15E0
	dc	$0000,$1680,$0000,$17C0
	dc	$0000,$1900,$0000,$19A0
	dc	$0000,$1AE0,$0000,$1C20
	dc	$0000,$1D60,$0000,$1EA0
	dc	$0000,$1FE0,$0000,$21C0
	dc	$0000,$2300,$0000,$2440
	dc	$0000,$2620,$0000,$2760
	dc	$0000,$2940,$0000,$2B20
	dc	$0000,$2C60,$0000,$2E40
	dc	$0000,$3020,$0000,$3160
	dc	$0000,$3340,$0000,$3520
	dc	$0000,$3700,$0000,$38E0
	dc	$0000,$3AC0,$0000,$3CA0
	dc	$0000,$3E80,$0000,$3D40
	dc	$0000,$3C00,$0000,$3AC0
	dc	$0000,$3980,$0000,$3840
	dc	$0000,$3700,$0000,$35C0
	dc	$0000,$3480,$0000,$33E0
	dc	$0000,$32A0,$0000,$3160
	dc	$0000,$3020,$0000,$2F80
	dc	$0000,$2E40,$0000,$2D00
	dc	$0000,$2C60,$0000,$2B20
	dc	$0000,$2A80,$0000,$2940
	dc	$0000,$28A0,$0000,$2800
	dc	$0000,$26C0,$0000,$2620
	dc	$0000,$2580,$0000,$24E0
	dc	$0000,$2440,$0000,$23A0
	dc	$0000,$2300,$0000,$2260
	dc	$0000,$21C0,$0000,$21C0
	dc	$0000,$2120,$0000,$2080
	dc	$0000,$2080,$0000,$1FE0
	dc	$0000,$1FE0,$0000,$1FE0
	dc	$0000,$1FE0,$0000,$1FE0
	dc	$0000,$1FE0,$0000,$1FE0
	dc	$0000,$1FE0,$0000,$1FE0
	dc	$0000,$1FE0,$0000,$1FE0
	dc	$0000,$2080,$0000,$2080
	dc	$0000,$2120,$0000,$21C0
	dc	$0000,$21C0,$0000,$2260
	dc	$0000,$2300,$0000,$23A0
	dc	$0000,$2440,$0000,$24E0
	dc	$0000,$2580,$0000,$2620
	dc	$0000,$26C0,$0000,$2800
	dc	$0000,$28A0,$0000,$2940
	dc	$0000,$2A80,$0000,$2B20
	dc	$0000,$2C60,$0000,$2D00
	dc	$0000,$2E40,$0000,$2F80
	dc	$0000,$3020,$0000,$3160
	dc	$0000,$32A0,$0000,$33E0
	dc	$0000,$3480,$0000,$35C0
	dc	$0000,$3700,$0000,$3840
	dc	$0000,$3980,$0000,$3AC0
	dc	$0000,$3C00,$0000,$3D40
	dc	$0000,$3E80,$0000,$3DE0
	dc	$0000,$3D40,$0000,$3CA0
	dc	$0000,$3C00,$0000,$3B60
	dc	$0000,$3AC0,$0000,$3A20
	dc	$0000,$3980,$0000,$38E0
	dc	$0000,$3840,$0000,$37A0
	dc	$0000,$37A0,$0000,$3700
	dc	$0000,$3660,$0000,$35C0
	dc	$0000,$3520,$0000,$3520
	dc	$0000,$3480,$0000,$33E0
	dc	$0000,$33E0,$0000,$3340
	dc	$0000,$32A0,$0000,$32A0
	dc	$0000,$3200,$0000,$3200
	dc	$0000,$3160,$0000,$3160
	dc	$0000,$30C0,$0000,$30C0
	dc	$0000,$3020,$0000,$3020
	dc	$0000,$3020,$0000,$2F80
	dc	$0000,$2F80,$0000,$2F80
	dc	$0000,$2F80,$0000,$2F80
	dc	$0000,$2F80,$0000,$2F80
	dc	$0000,$2F80,$0000,$2F80
	dc	$0000,$2F80,$0000,$2F80
	dc	$0000,$2F80,$0000,$2F80
	dc	$0000,$2F80,$0000,$2F80
	dc	$0000,$3020,$0000,$3020
	dc	$0000,$3020,$0000,$30C0
	dc	$0000,$30C0,$0000,$3160
	dc	$0000,$3160,$0000,$3200
	dc	$0000,$3200,$0000,$32A0
	dc	$0000,$32A0,$0000,$3340
	dc	$0000,$33E0,$0000,$33E0
	dc	$0000,$3480,$0000,$3520
	dc	$0000,$3520,$0000,$35C0
	dc	$0000,$3660,$0000,$3700
	dc	$0000,$37A0,$0000,$37A0
	dc	$0000,$3840,$0000,$38E0
	dc	$0000,$3980,$0000,$3A20
	dc	$0000,$3AC0,$0000,$3B60
	dc	$0000,$3C00,$0000,$3CA0
	dc	$0000,$3D40,$0000,$3DE0
	dc	$FFFF,$FFFF,$FFFF,$FFFF
	dc	$FFFF,$FFFF
	even

LOGO_AL:
		dc.w	$00A0,$0060,$001F,$00FF,$0001,$0000,$FC00,$FC01
		dc.w	$4000,$C000,$3FFF,$FFFF,$02A8,$0318,$FC07,$FFBF
		dc.w	$0000,$0000,$FF00,$FF00,$0050,$0030,$000F,$007F
		dc.w	$0000,$0000,$FE00,$FE00,$0028,$0018,$0007,$003F
		dc.w	$5002,$6001,$8000,$F003,$8500,$8600,$7800,$FF00
		dc.w	$0002,$0001,$0000,$0003,$8005,$8006,$7FF8,$FFFF
		dc.w	$000A,$0006,$0001,$000F,$0000,$0000,$FFC0,$FFC0
		dc.w	$0014,$000C,$0003,$001F,$0028,$0030,$FFC0,$FFF8
		dc.w	$0050,$0030,$000F,$007F,$8300,$C100,$3E00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007F,$00FF,$007F,$00FF,$F500,$FA01,$F500,$F301
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FF1F,$FFBF,$FF1F,$FFBF
		dc.w	$FD40,$FE80,$FD40,$FCC0,$003F,$007F,$003F,$007F
		dc.w	$FA80,$FD00,$FA80,$F980,$001F,$003F,$001F,$003F
		dc.w	$E001,$F003,$E001,$F003,$FE00,$FF00,$FE00,$FF00
		dc.w	$0001,$0003,$0001,$0003,$FFFE,$FFFF,$FFFE,$FFFF
		dc.w	$0007,$000F,$0007,$000F,$FF50,$FFA0,$FF50,$FF30
		dc.w	$000F,$001F,$000F,$001F,$FFF0,$FFF8,$FFF0,$FFF8
		dc.w	$003F,$007F,$003F,$007F,$F880,$FB00,$FE80,$F980
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00FF,$00FF,$007F,$00FF,$FD81,$FD01,$FF80,$FC81
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFBF,$FFBF,$FF1F,$FFBF
		dc.w	$FF60,$FF40,$FFE0,$FF20,$007F,$007F,$003F,$007F
		dc.w	$FEC0,$FE80,$FFC0,$FE40,$003F,$003F,$001F,$003F
		dc.w	$F003,$F003,$E001,$F003,$FF00,$FF00,$FE00,$FF00
		dc.w	$0003,$0003,$0001,$0003,$FFFF,$FFFF,$FFFE,$FFFF
		dc.w	$000F,$000F,$0007,$000F,$FFD8,$FFD0,$FFF8,$FFC8
		dc.w	$001F,$001F,$000F,$001F,$FFF8,$FFF8,$FFF0,$FFF8
		dc.w	$007F,$007F,$003F,$007F,$FF80,$FE80,$FFC0,$FE40
		dc.w	$0001,$07FE,$0001,$0000,$C000,$0000,$4000,$C000
		dc.w	$007F,$007F,$00FF,$00FF,$FE80,$FF80,$FEC1,$FE41
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FF1F,$FF1F,$FFBF,$FFBF
		dc.w	$FFA0,$FFE0,$FFB0,$FF90,$003F,$003F,$007F,$007F
		dc.w	$FF40,$FFC0,$FF60,$FF20,$001F,$001F,$003F,$003F
		dc.w	$E001,$E001,$F003,$F003,$FE00,$FE00,$FF00,$FF00
		dc.w	$0001,$0001,$0003,$0003,$FFFE,$FFFE,$FFFF,$FFFF
		dc.w	$0007,$0007,$000F,$000F,$FFE8,$FFF8,$FFEC,$FFE4
		dc.w	$000F,$000F,$001F,$001F,$FFF0,$FFF0,$FFF8,$FFF8
		dc.w	$003F,$003F,$007F,$007F,$FFA0,$FFC0,$FFE0,$FFA0
		dc.w	$07FF,$07FF,$07FF,$07FF,$2000,$E000,$4000,$2000
		dc.w	$007F,$007F,$00FF,$00FF,$FF60,$FFC0,$FF61,$FF21
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FF1F,$FF1F,$FFBF,$FFBF
		dc.w	$FFD8,$FFF0,$FFD8,$FFC8,$003F,$003F,$007F,$007F
		dc.w	$FFB0,$FFE0,$FFB0,$FF90,$001F,$001F,$003F,$003F
		dc.w	$E001,$E001,$F003,$F003,$FE00,$FE00,$FF00,$FF00
		dc.w	$0001,$0001,$0003,$0003,$FFFE,$FFFE,$FFFF,$FFFF
		dc.w	$0007,$0007,$000F,$000F,$FFF6,$FFFC,$FFF6,$FFF2
		dc.w	$000F,$000F,$001F,$001F,$FFF0,$FFF0,$FFF8,$FFF8
		dc.w	$003F,$003F,$007F,$007F,$FFA0,$FFE0,$FFB0,$FF90
		dc.w	$00FF,$00FF,$07FF,$07FF,$E000,$D000,$E000,$D000
		dc.w	$007F,$007F,$00FF,$00FF,$9B80,$87E0,$FBB1,$F391
		dc.w	$00FF,$00FF,$FFFF,$FFFF,$001F,$001F,$FFBF,$FFBF
		dc.w	$E6E0,$E1F8,$FEEC,$FCE4,$003F,$003F,$007F,$007F
		dc.w	$C5C0,$C3F0,$FDD8,$F9C8,$0007,$0007,$003F,$003F
		dc.w	$8001,$8001,$F003,$F003,$FE00,$FE00,$FF00,$FF00
		dc.w	$0001,$0001,$0003,$0003,$FE00,$FE00,$FFFF,$FFFF
		dc.w	$0007,$0007,$000F,$000F,$F0B8,$F07E,$FFBB,$FF39
		dc.w	$000F,$000F,$001F,$001F,$F000,$F000,$FFF8,$FFF8
		dc.w	$003F,$003F,$007F,$007F,$A9D8,$B7F0,$C5D8,$F9C8
		dc.w	$00FF,$00FF,$01FF,$01FF,$E000,$E800,$F000,$E800
		dc.w	$007F,$007F,$00FF,$00FF,$81F8,$87F0,$C1F8,$C5E8
		dc.w	$00FF,$00FF,$01FF,$01FF,$001F,$001F,$803F,$803F
		dc.w	$E07E,$E1FC,$F07E,$F17A,$003F,$003F,$007F,$007F
		dc.w	$C0FC,$C3F8,$E0FC,$E2F4,$001F,$001F,$003F,$003F
		dc.w	$E001,$E001,$F003,$F003,$FE00,$FE00,$FF00,$FF00
		dc.w	$0001,$0001,$0003,$0003,$FE00,$FE00,$FF00,$FF00
		dc.w	$0007,$0007,$000F,$000F,$F01F,$F07F,$F81F,$F85E
		dc.w	$800F,$000F,$801F,$801F,$F000,$F000,$F800,$F800
		dc.w	$003F,$003F,$007F,$007F,$8EEC,$89F8,$C4EC,$C6E4
		dc.w	$00FF,$00FF,$01FF,$01FF,$F000,$F400,$F800,$F400
		dc.w	$007F,$007F,$00FF,$00FF,$80EC,$83F4,$C0E0,$C2E8
		dc.w	$00FF,$00FF,$01FF,$01FF,$001F,$001F,$803F,$803F
		dc.w	$E03B,$E0FD,$F038,$F0BA,$003F,$003F,$007F,$007F
		dc.w	$C07A,$C1F6,$E078,$E174,$001F,$001F,$003F,$003F
		dc.w	$E001,$E001,$F003,$F003,$FE00,$FE00,$FF00,$FF00
		dc.w	$0001,$0001,$0003,$0003,$FE00,$FE00,$FF00,$FF00
		dc.w	$0007,$0007,$000F,$000F,$F00E,$F03F,$F80E,$F82E
		dc.w	$C00F,$400F,$001F,$801F,$F000,$F000,$F800,$F800
		dc.w	$003F,$003F,$007F,$007F,$8270,$83F4,$C078,$C174
		dc.w	$00FF,$00FF,$01FF,$01FF,$F800,$FA00,$FC00,$FA00
		dc.w	$007F,$007F,$00FF,$00FF,$817C,$80F0,$C07C,$C174
		dc.w	$00FF,$00FF,$01FF,$01FF,$001F,$001F,$803F,$803F
		dc.w	$E05F,$E03C,$F01F,$F05D,$003F,$003F,$007F,$007F
		dc.w	$C0BA,$C07C,$E03E,$E0BA,$001F,$001F,$003F,$003F
		dc.w	$E001,$E001,$F003,$F003,$FE00,$FE00,$FF00,$FF00
		dc.w	$0001,$0001,$0003,$0003,$FE00,$FE00,$FFF0,$FFF0
		dc.w	$0007,$0007,$000F,$000F,$F017,$F00F,$F807,$F817
		dc.w	$C00F,$000F,$C01F,$401F,$F000,$F000,$FF80,$FF80
		dc.w	$003F,$003F,$007F,$007F,$813C,$80F8,$C13E,$C1BA
		dc.w	$00FF,$00FF,$01FF,$01FF,$FC00,$FD00,$FE00,$FD00
		dc.w	$007F,$007F,$00FF,$00FF,$8078,$80F8,$C0FC,$C07C
		dc.w	$00FF,$00FF,$01FF,$01FF,$001F,$001F,$803F,$803F
		dc.w	$E01E,$E03E,$F03F,$F01F,$003F,$003F,$007F,$007F
		dc.w	$C038,$C078,$E07E,$E03A,$001F,$001F,$003F,$003F
		dc.w	$E001,$E001,$F003,$F003,$FE00,$FE00,$FF00,$FF00
		dc.w	$0001,$0001,$0003,$0003,$FFE0,$FFE0,$FFF0,$FFF0
		dc.w	$0007,$0007,$000F,$000F,$F007,$F00F,$F80F,$F807
		dc.w	$800F,$800F,$C01F,$C01F,$FF00,$FF00,$FF80,$FF80
		dc.w	$003F,$003F,$007F,$007F,$80F8,$80BC,$C07A,$C03A
		dc.w	$00FF,$00FF,$01FF,$01FF,$FE00,$FE80,$FF00,$FE80
		dc.w	$007F,$00FF,$007F,$00FF,$8078,$8078,$C0FC,$C0FC
		dc.w	$00FF,$01FF,$00FF,$01FF,$001F,$003F,$801F,$803F
		dc.w	$E01E,$E01E,$F03F,$F03F,$003F,$007F,$003F,$007F
		dc.w	$C07C,$C03C,$E03E,$E07E,$001F,$003F,$001F,$003F
		dc.w	$E001,$E003,$F001,$F003,$FE00,$FE00,$FF00,$FF00
		dc.w	$0001,$0003,$0001,$0003,$FFE0,$FFE0,$FFF0,$FFF0
		dc.w	$0007,$000F,$0007,$000F,$F007,$F007,$F80F,$F80F
		dc.w	$800F,$801F,$C00F,$C01F,$FF00,$FF00,$FF80,$FF80
		dc.w	$003F,$007F,$003F,$007F,$807C,$803C,$C03E,$C07E
		dc.w	$00FF,$00FF,$01FF,$01FF,$17C0,$1740,$3F80,$2740
		dc.w	$01FF,$01FF,$00FF,$007F,$8078,$8078,$C0FC,$C0FC
		dc.w	$03FF,$03FF,$01FF,$00FF,$007F,$007F,$803F,$801F
		dc.w	$E01E,$E01E,$F03F,$F03F,$00FF,$00FF,$007F,$003F
		dc.w	$C03C,$C07C,$E03E,$E07E,$007F,$007F,$003F,$001F
		dc.w	$E007,$E007,$F003,$F001,$FE00,$FE00,$FF00,$FF00
		dc.w	$0007,$0007,$0003,$0001,$FFE0,$FFE0,$FFF0,$FFF0
		dc.w	$001F,$001F,$000F,$0007,$F003,$F003,$F807,$F807
		dc.w	$803F,$803F,$C01F,$C00F,$FF00,$FF00,$FF80,$FF80
		dc.w	$00FF,$00FF,$007F,$003F,$807C,$807C,$C03E,$C07E
		dc.w	$00FF,$01FF,$00FF,$01FF,$0300,$0BC0,$0760,$0B20
		dc.w	$01FF,$017F,$00FF,$017F,$8078,$8078,$C0FC,$C0FC
		dc.w	$03FF,$02FF,$01FF,$02FF,$007F,$005F,$803F,$805F
		dc.w	$E01E,$E01E,$F03F,$F03F,$00FF,$00BF,$007F,$00BF
		dc.w	$C07C,$C07C,$E03E,$E07E,$007F,$005F,$003F,$005F
		dc.w	$E007,$E005,$F003,$F005,$FE00,$FE00,$FF00,$FF00
		dc.w	$0007,$0005,$0003,$0005,$FFE0,$FFE0,$FFF0,$FFF0
		dc.w	$001F,$0017,$000F,$0017,$F000,$F000,$F803,$F803
		dc.w	$003F,$002F,$C01F,$C02F,$FF00,$FF00,$FF80,$FF80
		dc.w	$00FF,$00BF,$007F,$00BF,$803C,$803C,$C07E,$C07E
		dc.w	$03FF,$03FF,$01FF,$00FF,$01B0,$05F0,$03A0,$0580
		dc.w	$017F,$01FF,$037F,$027F,$8078,$8078,$C0FC,$C0FC
		dc.w	$02FF,$03FF,$06FF,$04FF,$005F,$007F,$80DF,$809F
		dc.w	$E01E,$E01E,$F03F,$F03F,$00BF,$00FF,$01BF,$013F
		dc.w	$C07C,$C07C,$E03E,$E07E,$005F,$007F,$00DF,$009F
		dc.w	$E005,$E007,$F00D,$F009,$FE00,$FE00,$FF00,$FF00
		dc.w	$0005,$0007,$000D,$0009,$FE00,$FE00,$FFF0,$FFF0
		dc.w	$0017,$001F,$0037,$0027,$F000,$F000,$F800,$F800
		dc.w	$002F,$003F,$006F,$004F,$F000,$F000,$FF80,$FF80
		dc.w	$00BF,$00FF,$01BF,$013F,$803C,$803C,$C07E,$C07E
		dc.w	$03FF,$02FF,$01FF,$02FF,$00F0,$03D0,$00E0,$02D0
		dc.w	$00FF,$03FF,$06FF,$04FF,$8078,$8078,$C0FC,$C0FC
		dc.w	$01FF,$07FF,$0DFF,$09FF,$003F,$00FF,$81BF,$813F
		dc.w	$E01E,$E01E,$F03F,$F03F,$007F,$01FF,$037F,$027F
		dc.w	$C038,$C07C,$E03A,$E07A,$003F,$00FF,$01BF,$013F
		dc.w	$E003,$E00F,$F01B,$F013,$FE00,$FE00,$FF00,$FF00
		dc.w	$0003,$000F,$001B,$0013,$FE00,$FE00,$FF00,$FF00
		dc.w	$000F,$003F,$006F,$004F,$F000,$F000,$F800,$F800
		dc.w	$001F,$007F,$00DF,$009F,$F000,$F000,$F800,$F800
		dc.w	$007F,$01FF,$037F,$027F,$803C,$803C,$C07E,$C07E
		dc.w	$02FF,$03FF,$06FF,$04FF,$02D8,$01F8,$03D0,$02C0
		dc.w	$05FF,$07FF,$0DFF,$09FF,$8078,$8078,$C0FC,$C0FC
		dc.w	$0BFF,$0FFF,$1BFF,$13FF,$017F,$01FF,$817F,$807F
		dc.w	$E01E,$E01E,$F03F,$F03F,$02FF,$03FF,$06FF,$04FF
		dc.w	$C03C,$C078,$E07E,$E03A,$017F,$01FF,$037F,$027F
		dc.w	$E017,$E01F,$F037,$F027,$FE00,$FE00,$FF00,$FF00
		dc.w	$0017,$001F,$0037,$0027,$FE00,$FE00,$FF00,$FF00
		dc.w	$005F,$007F,$00DF,$009F,$F000,$F000,$F800,$F800
		dc.w	$00BF,$00FF,$01BF,$013F,$F000,$F000,$F800,$F800
		dc.w	$02FF,$03FF,$06FF,$04FF,$803C,$803C,$C07E,$C07E
		dc.w	$01FF,$07FF,$0DFF,$09FF,$01F8,$01E8,$00F0,$01E8
		dc.w	$0BFF,$0FFF,$1BFF,$13FF,$8078,$8078,$C0FC,$C0FC
		dc.w	$17FF,$1FFF,$37FF,$27FF,$02FF,$03FF,$86FF,$84FF
		dc.w	$E01E,$E01E,$F03F,$F03F,$05FF,$07FF,$0DFF,$09FF
		dc.w	$C034,$C0FC,$E036,$E0B2,$02FF,$03FF,$06FF,$04FF
		dc.w	$E02F,$E03F,$F06F,$F04F,$FE00,$FE00,$FF00,$FF00
		dc.w	$002F,$003F,$006F,$004F,$FE00,$FE00,$FF00,$FF00
		dc.w	$00BF,$00FF,$01BF,$013F,$F051,$F031,$F80E,$F87F
		dc.w	$417F,$81FF,$037F,$C27F,$F000,$F000,$F800,$F800
		dc.w	$05FF,$07FF,$0DFF,$09FF,$803C,$803C,$C07E,$C07E
		dc.w	$0BFF,$0FFF,$1BFF,$13FF,$01FC,$01FC,$00F8,$00F0
		dc.w	$37FF,$1FFF,$37FF,$27FF,$8078,$8078,$C0FC,$C0FC
		dc.w	$6FFF,$3FFF,$6FFF,$4FFF,$0DFF,$07FF,$8DFF,$89FF
		dc.w	$E01E,$E01E,$F03F,$F03F,$1BFF,$0FFF,$1BFF,$13FF
		dc.w	$C070,$C1F4,$E078,$E174,$0DFF,$07FF,$0DFF,$09FF
		dc.w	$E0DF,$E07F,$F0DF,$F09F,$FE00,$FE00,$FF00,$FF00
		dc.w	$00DF,$007F,$00DF,$009F,$FE00,$FE00,$FF00,$FF00
		dc.w	$037F,$01FF,$037F,$027F,$F03F,$F07F,$F83F,$F87F
		dc.w	$86FF,$C3FF,$86FF,$C4FF,$F000,$F000,$F800,$F800
		dc.w	$1BFF,$0FFF,$1BFF,$13FF,$803C,$803C,$C07E,$C07E
		dc.w	$17FF,$1FFF,$37FF,$27FF,$00FC,$00F4,$00F8,$00F4
		dc.w	$6FFF,$1FFF,$4FFF,$6FFF,$8078,$8078,$C0FC,$C0FC
		dc.w	$DFFF,$3FFF,$9FFF,$DFFF,$1BFF,$07FF,$93FF,$9BFF
		dc.w	$E01E,$E01E,$F03F,$F03F,$37FF,$0FFF,$27FF,$37FF
		dc.w	$C2EC,$C1F8,$E0EC,$E2E4,$1BFF,$07FF,$13FF,$1BFF
		dc.w	$E1BF,$E07F,$F13F,$F1BF,$FE00,$FE00,$FF00,$FF00
		dc.w	$01BF,$007F,$013F,$01BF,$FE00,$FE00,$FF00,$FF00
		dc.w	$06FF,$01FF,$04FF,$06FF,$F07F,$F07F,$F83F,$F87F
		dc.w	$CDFF,$C3FF,$89FF,$CDFF,$F000,$F000,$F800,$F800
		dc.w	$37FF,$0FFF,$27FF,$37FF,$803C,$803C,$C07E,$C07E
		dc.w	$6FFF,$3FFF,$6FFF,$4FFF,$00F6,$00FE,$00F4,$00F0
		dc.w	$9FFF,$5FFF,$BFFF,$DFFF,$8079,$8078,$C0FD,$C0FD
		dc.w	$3FFF,$BFFF,$7FFF,$BFFF,$27FF,$17FF,$AFFF,$B7FF
		dc.w	$E01E,$E01E,$F03F,$F03F,$4FFF,$2FFF,$5FFF,$6FFF
		dc.w	$C1D8,$CFF0,$F5D8,$F9C8,$27FF,$17FF,$2FFF,$37FF
		dc.w	$E07F,$E17F,$F2FF,$F37F,$FE00,$FE00,$FF00,$FF00
		dc.w	$007F,$017F,$02FF,$037F,$FE00,$FE00,$FF00,$FF00
		dc.w	$09FF,$0DFF,$03FF,$05FF,$F03F,$F03F,$F87F,$F87F
		dc.w	$83FF,$8BFF,$D7FF,$DBFF,$F000,$F000,$F800,$F800
		dc.w	$4FFF,$2FFF,$5FFF,$6FFF,$803C,$803C,$C07E,$C07E
		dc.w	$DFFF,$3FFF,$9FFF,$DFFF,$00FE,$00FA,$00FC,$00FA
		dc.w	$7FFF,$3FFF,$FFFF,$BFFF,$8078,$8078,$FFFD,$FFFD
		dc.w	$FFFF,$7FFF,$FFFF,$7FFF,$1FFF,$0FFF,$BFFF,$AFFF
		dc.w	$E01E,$E01E,$FFFF,$FFFF,$3FFF,$1FFF,$7FFF,$5FFF
		dc.w	$FFA0,$FFE0,$FFB0,$FF90,$1FFF,$0FFF,$3FFF,$2FFF
		dc.w	$E1FF,$E0FF,$F3FF,$F2FF,$FE00,$FE00,$FF00,$FF00
		dc.w	$01FF,$00FF,$03FF,$02FF,$FE00,$FE00,$FF00,$FF00
		dc.w	$07FF,$03FF,$0FFF,$0BFF,$F03F,$F03F,$F87F,$F87F
		dc.w	$8FFF,$87FF,$DFFF,$D7FF,$F000,$F000,$F800,$F800
		dc.w	$3FFF,$1FFF,$7FFF,$5FFF,$803C,$803C,$C07E,$C07E
		dc.w	$3FFF,$BFFF,$7FFF,$BFFF,$00FA,$00FE,$00FA,$00F8
		dc.w	$3FFF,$7FFF,$BFFF,$BFFF,$FFF8,$FFF8,$FFFD,$FFFD
		dc.w	$7FFF,$FFFF,$7FFF,$7FFF,$0FFF,$1FFF,$AFFF,$AFFF
		dc.w	$FFFE,$FFFE,$FFFF,$FFFF,$1FFF,$3FFF,$5FFF,$5FFF
		dc.w	$FFA0,$FFC0,$FFE0,$FFA0,$0FFF,$1FFF,$2FFF,$2FFF
		dc.w	$E0FF,$E1FF,$F2FF,$F2FF,$FE00,$FE00,$FF00,$FF00
		dc.w	$00FF,$01FF,$02FF,$02FF,$FE00,$FE00,$FF00,$FF00
		dc.w	$03FF,$07FF,$0BFF,$0BFF,$F02F,$F037,$F847,$F87F
		dc.w	$87FF,$8FFF,$D7FF,$D7FF,$F000,$F000,$F800,$F800
		dc.w	$1FFF,$3FFF,$5FFF,$5FFF,$803C,$803C,$C07E,$C07E
		dc.w	$FFFF,$7FFF,$FFFF,$7FFF,$00FB,$00FC,$00FB,$00F9
		dc.w	$3FFF,$7FFF,$BFFF,$BFFF,$FFF8,$FFF8,$FFFD,$FFFD
		dc.w	$7FFF,$FFFF,$7FFF,$7FFF,$0FFF,$1FFF,$AFFF,$AFFF
		dc.w	$FFFE,$FFFE,$FFFF,$FFFF,$1FFF,$3FFF,$5FFF,$5FFF
		dc.w	$FE80,$FF80,$FEC0,$FE40,$0FFF,$1FFF,$2FFF,$2FFF
		dc.w	$E0FF,$E1FF,$F2FF,$F2FF,$FE00,$FE00,$FF00,$FF00
		dc.w	$00FF,$01FF,$02FF,$02FF,$FE00,$FE00,$FF00,$FF00
		dc.w	$03FF,$07FF,$0BFF,$0BFF,$F007,$F00F,$F807,$F80F
		dc.w	$87FF,$8FFF,$D7FF,$D7FF,$F000,$F000,$F800,$F800
		dc.w	$1FFF,$3FFF,$5FFF,$5FFF,$803C,$803C,$C07E,$C07E
		dc.w	$7FFF,$FFFF,$7FFF,$7FFF,$00FD,$00FF,$00FC,$00FD
		dc.w	$7FFF,$7FFF,$FFFF,$FFFF,$FFF8,$FFF8,$FFFD,$FFFD
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$1FFF,$1FFF,$BFFF,$BFFF
		dc.w	$FFFE,$FFFE,$FFFF,$FFFF,$3FFF,$3FFF,$7FFF,$7FFF
		dc.w	$FF00,$FF00,$FFC0,$FF40,$1FFF,$1FFF,$3FFF,$3FFF
		dc.w	$E1FF,$E1FF,$F3FF,$F3FF,$FE00,$FE00,$FF00,$FF00
		dc.w	$01FF,$01FF,$03FF,$03FF,$FE00,$FE00,$FF00,$FF00
		dc.w	$07FF,$07FF,$0FFF,$0FFF,$F00F,$F00F,$F807,$F80F
		dc.w	$8FFF,$8FFF,$DFFF,$DFFF,$F000,$F000,$F800,$F800
		dc.w	$3FFF,$3FFF,$7FFF,$7FFF,$803C,$803C,$C07E,$C07E
		dc.w	$7FFF,$FFFF,$7FFF,$7FFF,$00FD,$00FE,$00FC,$00FD
		dc.w	$7FFF,$7FFF,$FFFF,$FFFF,$FFF8,$FFF8,$FFFD,$FFFD
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$1FFF,$1FFF,$BFFF,$BFFF
		dc.w	$FFFE,$FFFE,$FFFF,$FFFF,$3FFF,$3FFF,$7FFF,$7FFF
		dc.w	$C190,$C790,$FDE0,$F9A0,$1FFF,$1FFF,$3FFF,$3FFF
		dc.w	$E1FF,$E1FF,$F3FF,$F3FF,$FE00,$FE00,$FFFF,$FFFF
		dc.w	$29FF,$31FF,$C3FF,$FBFF,$FE00,$FE00,$FFFF,$FFFF
		dc.w	$A7FF,$C7FF,$0FFF,$EFFF,$F007,$F007,$FFFF,$FFFF
		dc.w	$8FFF,$8FFF,$DFFF,$DFFF,$F005,$F006,$FFF8,$FFFF
		dc.w	$3FFF,$3FFF,$7FFF,$7FFF,$803C,$803C,$C07E,$C07E
		dc.w	$7FFF,$7FFF,$FFFF,$7FFF,$00FD,$00FF,$00FD,$00FC
		dc.w	$7FFF,$7FFF,$FFFF,$FFFF,$8078,$8078,$FFFD,$FFFD
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$1FFF,$1FFF,$BFFF,$BFFF
		dc.w	$E01E,$E01E,$FFFF,$FFFF,$3FFF,$3FFF,$7FFF,$7FFF
		dc.w	$CCE8,$CFC8,$E2F0,$E0D0,$1FFF,$1FFF,$3FFF,$3FFF
		dc.w	$E1FF,$E1FF,$F3FF,$F3FF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$F1FF,$F9FF,$F3FF,$FBFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$C7FF,$E7FF,$CFFF,$EFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$8FFF,$8FFF,$DFFF,$DFFF,$FFFE,$FFFF,$FFFE,$FFFF
		dc.w	$3FFF,$3FFF,$7FFF,$7FFF,$803C,$803C,$C07E,$C07E
		dc.w	$3FFF,$FFFF,$FFFF,$7FFF,$00FF,$00FE,$00FF,$00FE
		dc.w	$7FFF,$7FFF,$FFFF,$FFFF,$8078,$8078,$C0FD,$C0FD
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$1FFF,$1FFF,$BFFF,$BFFF
		dc.w	$E01E,$E01E,$F03F,$F03F,$3FFF,$3FFF,$7FFF,$7FFF
		dc.w	$C274,$C1E4,$E378,$E268,$1FFF,$1FFF,$3FFF,$3FFF
		dc.w	$E1FF,$E1FF,$F3FF,$F3FF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$F1FF,$F1FF,$FBFF,$FBFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$C7FF,$C7FF,$EFFF,$EFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$8FFF,$8FFF,$DFFF,$DFFF,$FFFE,$FFFE,$FFFF,$FFFF
		dc.w	$3FFF,$3FFF,$7FFF,$7FFF,$803C,$803C,$C07E,$C07E
		dc.w	$FFFF,$FFFF,$FFFF,$7FFF,$FFFE,$FFFE,$FFFF,$FFFE
		dc.w	$FFFF,$FFFF,$7FFF,$FFFF,$C079,$C079,$80FC,$C0FD
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$BFFF,$BFFF,$1FFF,$BFFF
		dc.w	$F01E,$F01E,$E03F,$F03F,$7FFF,$7FFF,$3FFF,$7FFF
		dc.w	$C1B8,$C0F0,$E1BC,$E134,$3FFF,$3FFF,$1FFF,$3FFF
		dc.w	$F3FF,$F3FF,$E1FF,$F3FF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FBFF,$FBFF,$F1FF,$FBFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$EFFF,$EFFF,$C7FF,$EFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$9FFF,$9FFF,$CFFF,$DFFF,$FFFF,$FFFF,$FFFE,$FFFF
		dc.w	$7FFF,$7FFF,$3FFF,$7FFF,$C07E,$C07E,$803C,$C07E
		dc.w	$FFFF,$7FFF,$7FFF,$FFFF,$FFFE,$FFFF,$FFFE,$FFFE
		dc.w	$7FFF,$FFFF,$7FFF,$FFFF,$8078,$C079,$80FC,$C0FD
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$1FFF,$BFFF,$1FFF,$BFFF
		dc.w	$E01E,$F01E,$E03F,$F03F,$3FFF,$7FFF,$3FFF,$7FFF
		dc.w	$C0DF,$C07B,$E0DC,$E09A,$1FFF,$3FFF,$1FFF,$3FFF
		dc.w	$E1FF,$F3FF,$E1FF,$F3FF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$F1FF,$FBFF,$F1FF,$FBFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$C7FF,$EFFF,$C7FF,$EFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$8FFF,$9FFF,$CFFF,$DFFF,$FFFE,$FFFF,$FFFE,$FFFF
		dc.w	$3FFF,$7FFF,$3FFF,$7FFF,$803C,$C07E,$803C,$C07E
		dc.w	$7FFF,$FFFF,$7FFF,$FFFF,$FFFE,$FFFE,$FFFF,$FFFE
		dc.w	$A001,$6001,$1FFE,$FFFF,$4079,$8078,$00FC,$C0FD
		dc.w	$4002,$C003,$3FFC,$FFFF,$A800,$1800,$07FF,$BFFF
		dc.w	$501E,$601E,$803F,$F03F,$5000,$3000,$0FFF,$7FFF
		dc.w	$006E,$003C,$E06F,$E04D,$A800,$9800,$07FF,$3FFF
		dc.w	$5280,$6180,$807F,$F3FF,$0000,$0000,$FFFF,$FFFF
		dc.w	$2A80,$3180,$C07F,$FBFF,$0000,$0000,$FFFF,$FFFF
		dc.w	$AA00,$C600,$01FF,$EFFF,$0000,$0000,$FFFF,$FFFF
		dc.w	$5400,$4C00,$83FF,$DFFF,$0005,$0006,$FFF8,$FFFF
		dc.w	$5001,$3001,$0FFE,$7FFF,$4052,$8034,$0008,$C07E
		dc.w	$A000,$6000,$1FFF,$FFFF,$0005,$0006,$FFF8,$FFFF
		dc.w	$0000,$0000,$0000,$0000,$0078,$0078,$00FC,$00FC
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$001E,$001E,$003F,$003F,$0000,$0000,$0000,$0000
		dc.w	$0037,$001E,$0037,$0026,$4000,$4000,$8000,$8000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00F8,$00F8,$007C,$00FC
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003E,$003E,$001F,$003F,$0000,$0000,$0000,$0000
		dc.w	$000B,$000F,$001B,$0013,$A000,$2000,$C000,$4000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0078,$00F8,$007C,$00FC
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$001E,$003E,$001F,$003F,$0000,$0000,$0000,$0000
		dc.w	$000D,$000F,$0005,$0001,$F000,$B000,$C000,$A000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00A0,$0060,$001C,$00FC
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0028,$0018,$0007,$003F,$0000,$0000,$0000,$0000
		dc.w	$0002,$0002,$0001,$0002,$D800,$D000,$F800,$C800
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0001,$0001,$0000,$0000,$BE00,$7400,$3A00,$B600
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$60C0,$3A80,$6540,$4340
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1070,$0F90,$1040,$1830
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

LOGO_ARTIST:
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0004,$006C,$000D,$0000
		dc.w	$0610,$ACB5,$9C73,$0200,$C202,$9606,$8E0E,$4000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$000C,$0058,$0038,$0004
		dc.w	$0020,$1062,$3066,$0000,$0002,$0909,$1818,$0103
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$000D,$0021,$0061,$000C
		dc.w	$9863,$3646,$3046,$8E21,$0909,$191B,$1818,$0103
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0029,$0064,$0060,$000D
		dc.w	$0246,$8624,$0004,$8662,$1A1B,$1617,$1010,$0E0F
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0064,$004D,$0040,$002D
		dc.w	$2424,$1462,$8200,$B666,$1012,$080A,$0101,$191B
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0048,$0028,$0005,$006D
		dc.w	$9A42,$3846,$8621,$BE67,$C949,$5818,$8143,$995B
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
												
PAL_RAST:
	dc.w 	$710,$720,$730,$740,$750,$760,$770,$670,$570,$470,$370
	dc.w 	$270,$170,$70,$71,$72,$73,$74,$75,$76,$77,$67,$57,$47,$37
	dc.w 	$27,$17,$7,$107,$207,$307,$407,$507,$607,$707,$706,$705
	dc.w 	$704,$703,$702,$701,$700,$710,$720,$730,$740,$750,$760
	dc.w 	$770,$670,$570,$470,$370,$270,$170,$70,$71,$72,$73,$74
	dc.w 	$75,$76,$77,$67,$57,$47,$37,$27,$17,$7,$107,$207,$307
	dc.w 	$407,$507,$607,$707,$706,$705,$704,$703,$702,$701,$700
	dc.w 	$710,$720,$730,$740,$750,$760,$770,$670,$570,$470,$370
	dc.w 	$270,$170,$70,$71,$72,$73,$74,$75,$76,$77,$67,$57,$47
	dc.w 	$37,$27,$17,$7,$107,$207,$307,$407,$507,$607,$707,$706
	dc.w 	$705,$704,$703,$702,$701,$700

FONT8_8:
	dc	$0018,$0008,$103E,$7F77
	dc	$007E,$1808,$7CF0,$05A0
	dc	$3E03,$3E3E,$633E,$3E3E
	dc	$3E3E,$007C,$07F0,$1104
	dc	$0038,$EE6C,$10C2,$3838
	dc	$1E78,$C638,$0000,$0002
	dc	$7C38,$FCFC,$E0FE,$7EFC
	dc	$7C7C,$0000,$0E00,$70FC
	dc	$7C7C,$FC7C,$FC7E,$7E7C
	dc	$EEFE,$0EE6,$E06C,$7C7C
	dc	$7C7C,$FC7E,$FEEE,$EEEE
	dc	$EEEE,$FE3C,$803C,$1000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$000C,$1830,$0000
	dc	$0066,$0C18,$6618,$1800
	dc	$1866,$1866,$1830,$6618
	dc	$0C00,$3F18,$6630,$1830
	dc	$0066,$660C,$0000,$1C00
	dc	$0C0C,$0C0C,$3434,$0000
	dc	$0000,$00C6,$C600,$1BD8
	dc	$3434,$0200,$007F,$3034
	dc	$3466,$0C00,$7C7E,$7EF1
	dc	$337B,$0000,$0000,$0000
	dc	$0000,$6000,$0060,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$000E,$0000
	dc	$001C,$0000,$7F00,$0000
	dc	$3C00,$000E,$0C00,$3E3C
	dc	$0018,$300C,$0018,$1800
	dc	$1C1C,$0078,$0038,$7800
	dc	$003C,$3C0C,$301C,$7E63
	dc	$01C3,$3C0C,$60C0,$05A0
	dc	$6303,$0303,$6360,$6003
	dc	$6363,$0060,$0FF8,$0B28
	dc	$0038,$EE6C,$FEC6,$3838
	dc	$381C,$6C38,$0000,$0006
	dc	$EE38,$0E0E,$E0E0,$E00E
	dc	$EEEE,$3800,$1E00,$78FE
	dc	$C6EE,$EEEE,$EEE0,$E0EE
	dc	$EE38,$0EEE,$E0FE,$EEEE
	dc	$EEEE,$EEE0,$38EE,$EEEE
	dc	$EEEE,$FE30,$C00C,$3800
	dc	$C000,$0000,$0E00,$0000
	dc	$0038,$0EC0,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0018,$1818,$3018
	dc	$3C00,$1866,$000C,$1800
	dc	$6600,$0C00,$6618,$0000
	dc	$1800,$7866,$0018,$6618
	dc	$6600,$000C,$1C66,$361E
	dc	$1818,$1818,$5858,$7C7C
	dc	$1800,$00CC,$CC18,$366C
	dc	$5858,$3C02,$00D8,$1858
	dc	$5800,$1810,$CCC3,$C35B
	dc	$0033,$667C,$1E7E,$7C1C
	dc	$1E7E,$6E3C,$3C7E,$6C0E
	dc	$3E36,$7E66,$7E7C,$D67C
	dc	$1C3E,$FE7E,$3619,$0866
	dc	$0036,$3F00,$6300,$0000
	dc	$183C,$3C1B,$1810,$7066
	dc	$7E18,$1818,$0E18,$1832
	dc	$363E,$006C,$006C,$0C00
	dc	$007E,$3C7E,$7E49,$7C41
	dc	$03D3,$3C0E,$7FDF,$05A0
	dc	$6303,$0303,$6360,$6003
	dc	$6363,$7C78,$18EC,$0DD8
	dc	$0038,$EEFE,$D0CC,$3870
	dc	$381C,$38FE,$0000,$000E
	dc	$EE38,$0E7C,$F8FC,$FC7E
	dc	$7CEE,$3838,$3CFE,$3C0E
	dc	$CEEE,$FCE0,$EEFC,$FCE0
	dc	$FE38,$0EFC,$E0FE,$EEEE
	dc	$EEEE,$FCFC,$38EE,$EEEE
	dc	$7CEE,$1C30,$600C,$6C00
	dc	$60FC,$FC7C,$7E7E,$7E7E
	dc	$E038,$0ECE,$E06C,$FC7C
	dc	$FC7C,$FC7E,$70EE,$EEEE
	dc	$EEEE,$FE18,$1818,$7918
	dc	$6600,$0000,$7C00,$003C
	dc	$007C,$0000,$0000,$1818
	dc	$7E7E,$D800,$0000,$0000
	dc	$003C,$661E,$3A66,$6630
	dc	$0000,$0000,$0000,$06C6
	dc	$0000,$00D8,$D800,$6C36
	dc	$0000,$663C,$7ED8,$0000
	dc	$3C00,$3038,$CCBD,$BD55
	dc	$7333,$760C,$060C,$060C
	dc	$0C36,$660C,$0606,$3E06
	dc	$3636,$6666,$0606,$D66C
	dc	$0C06,$6666,$363C,$1CF7
	dc	$3B66,$337F,$301E,$6C7E
	dc	$3C66,$663C,$387C,$6066
	dc	$007E,$0C30,$1B18,$004C
	dc	$1C1C,$006C,$0F18,$1800
	dc	$00FF,$3C7F,$FE63,$7800
	dc	$06D3,$3C0A,$6CDB,$0DB0
	dc	$0000,$3E3E,$3E3E,$3E00
	dc	$3E3E,$0660,$1804,$0628
	dc	$0038,$006C,$FE18,$FE00
	dc	$381C,$FEFE,$00FE,$001C
	dc	$EE38,$1C0E,$FEFE,$EE0E
	dc	$EEFE,$3838,$78FE,$1E3E
	dc	$D2FE,$EEE0,$EEE0,$E0FE
	dc	$EE38,$0EF8,$E0EE,$EEEE
	dc	$FEE6,$EEFE,$38EE,$EEEE
	dc	$38EE,$3830,$300C,$C600
	dc	$30FE,$EEEE,$FEE0,$E0E0
	dc	$E000,$00DC,$E0FE,$FEFE
	dc	$FEEC,$FEF0,$F8EE,$EEEE
	dc	$EEEE,$FE30,$180C,$4F34
	dc	$6066,$3C3C,$063C,$3C60
	dc	$3CC6,$3C38,$3838,$3C3C
	dc	$601B,$DE3C,$3C3C,$6666
	dc	$6666,$6630,$303C,$7C7C
	dc	$3C38,$3C66,$7C66,$7EC6
	dc	$183E,$7C36,$3618,$D81B
	dc	$3C3C,$6E6E,$DBDE,$1818
	dc	$6600,$0010,$7CB1,$A555
	dc	$3333,$3C0C,$0E0C,$660C
	dc	$0636,$660C,$0606,$6606
	dc	$3636,$763C,$6606,$D66C
	dc	$0C06,$6676,$1C66,$3E99
	dc	$6E7C,$3136,$1838,$6C18
	dc	$667E,$666E,$54D6,$7E66
	dc	$7E18,$1818,$1B18,$7E00
	dc	$0000,$006C,$1830,$0C00
	dc	$003C,$FF7F,$FE49,$7141
	dc	$CCDB,$7E0A,$6FFF,$0DB0
	dc	$6303,$6003,$0303,$6303
	dc	$6303,$7E7E,$1004,$07D0
	dc	$0038,$006C,$1630,$FE00
	dc	$381C,$38FE,$00FE,$0038
	dc	$EE38,$380E,$FEFE,$EE0E
	dc	$EE7E,$0000,$7800,$1E3C
	dc	$CEEE,$EEE0,$EEE0,$E0EE
	dc	$EE38,$0EF8,$E0EE,$EEEE
	dc	$FCEA,$EE7E,$38EE,$EEEE
	dc	$7C7E,$7030,$180C,$0000
	dc	$00EE,$FCE0,$EEFC,$FCEE
	dc	$FC38,$0EF8,$E0FE,$EEEE
	dc	$EEEC,$EE7C,$70EE,$EEEE
	dc	$7C7E,$3C18,$1818,$0634
	dc	$6666,$7E06,$7E06,$0660
	dc	$7EFC,$7E18,$1818,$6666
	dc	$7C7F,$F866,$6666,$6666
	dc	$6666,$6630,$7C18,$6630
	dc	$0618,$6666,$6676,$C6C6
	dc	$3030,$0C6B,$6E18,$6C36
	dc	$0666,$7676,$DFD8,$3C3C
	dc	$6600,$0010,$0CB1,$B951
	dc	$3333,$6E0C,$1E0C,$660C
	dc	$0636,$6600,$0606,$6606
	dc	$3636,$0606,$6606,$D66C
	dc	$0C06,$6606,$0C66,$7799
	dc	$6466,$3036,$306C,$6C18
	dc	$6666,$6666,$54D6,$6066
	dc	$0018,$300C,$18D8,$0032
	dc	$0000,$186C,$D87C,$7800
	dc	$003C,$7E7E,$7E1C,$6363
	dc	$78C3,$1038,$0C1E,$1998
	dc	$6303,$6003,$0303,$6303
	dc	$6303,$6618,$1004,$2E10
	dc	$0000,$00FE,$FE66,$3800
	dc	$381C,$6C38,$1C00,$3870
	dc	$EE38,$700E,$381E,$EE0E
	dc	$EE0E,$3838,$3CFE,$3C00
	dc	$C0EE,$EEEE,$EEE0,$E0EE
	dc	$EE38,$0EFC,$E0EE,$EEEE
	dc	$E0FC,$EE0E,$38EE,$EEFE
	dc	$FE0E,$FE30,$0C0C,$0000
	dc	$00FE,$EEEE,$EEE0,$E0EE
	dc	$FE38,$0EF8,$E0FE,$EEFE
	dc	$FE7C,$E01E,$70FE,$FEFE
	dc	$7C0E,$7818,$1818,$0062
	dc	$3C66,$607E,$C67E,$7E3C
	dc	$60C0,$6018,$1818,$7E7E
	dc	$60D8,$D866,$6666,$6666
	dc	$3E66,$661E,$303C,$6630
	dc	$7E18,$6666,$666E,$7E7C
	dc	$6030,$0CC3,$D618,$366C
	dc	$7E66,$6666,$D8D8,$6666
	dc	$6600,$0010,$1EBD,$AD00
	dc	$7B7B,$667E,$360C,$660C
	dc	$0636,$7E00,$3C0E,$6E3E
	dc	$1C7E,$7E7E,$6406,$FEEC
	dc	$0C06,$7E06,$0C3C,$63EF
	dc	$6E66,$3036,$636C,$6C18
	dc	$3C66,$2476,$38D6,$7066
	dc	$7E00,$0000,$18D8,$184C
	dc	$0000,$1800,$7000,$0000
	dc	$003C,$3C0C,$303E,$4777
	dc	$30C3,$3878,$0C1B,$799E
	dc	$3E03,$3E3E,$033E,$3E03
	dc	$3E3E,$3C18,$1E3C,$39E0
	dc	$0038,$006C,$FEC6,$3800
	dc	$3E7C,$C638,$1C00,$38E0
	dc	$FE38,$FEFE,$38FE,$FE0E
	dc	$FE0E,$3838,$1EFE,$7838
	dc	$7EEE,$FEFE,$FEFE,$E0FE
	dc	$EEFE,$FEEE,$FEEE,$EEFE
	dc	$E0EE,$EEFE,$38FE,$7CFE
	dc	$EEFE,$FE3C,$063C,$00FF
	dc	$00EE,$FEFE,$FEFE,$E0FE
	dc	$EE38,$FEDC,$FCEE,$EEFE
	dc	$FC0E,$E0FE,$7EFE,$7CFE
	dc	$EEFE,$FE0C,$1830,$007E
	dc	$083E,$3C3E,$7E3E,$3E08
	dc	$3C7C,$3C3C,$3C3C,$6666
	dc	$7E7E,$DF3C,$3C3C,$3E3E
	dc	$063C,$3E0C,$7E18,$7C30
	dc	$3E3C,$3C3E,$6666,$0000
	dc	$6330,$0C86,$9F18,$1BD8
	dc	$3E3C,$3C3C,$7E7F,$7E7E
	dc	$6600,$0000,$0CC3,$C300
	dc	$0303,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$6000,$0000
	dc	$0C06,$0006,$0C98,$4126
	dc	$3B7C,$3036,$7F38,$7F18
	dc	$183C,$663C,$307C,$3E66
	dc	$007E,$7E7E,$1870,$1800
	dc	$0000,$0000,$3000,$0000
	dc	$0000,$1808,$1000,$0000
	dc	$007E,$1030,$0000,$718E
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$001E,$1754,$3800
	dc	$0038,$0000,$1086,$3800
	dc	$1E78,$0000,$3800,$38C0
	dc	$7C38,$FE7C,$38FC,$7C0E
	dc	$7C0E,$3870,$0E00,$7038
	dc	$00EE,$FC7C,$FC7E,$E07C
	dc	$EEFE,$FCE6,$7EEE,$EE7C
	dc	$E074,$EEFC,$387C,$386C
	dc	$EEFC,$FE00,$0000,$0000
	dc	$00EE,$FC7C,$7E7E,$E07C
	dc	$EE38,$7CCE,$7CEE,$EE7C
	dc	$E00E,$E0FC,$3E7C,$386C
	dc	$EEFC,$FE00,$0000,$0000
	dc	$3800,$0000,$0000,$0038
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$3C00,$000C,$0000,$6060
	dc	$0000,$0000,$0000,$7C7C
	dc	$3E00,$000F,$0618,$0000
	dc	$0000,$4040,$0000,$6666
	dc	$3C00,$0000,$0C7E,$7E00
	dc	$0E0E,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0070,$0000
	dc	$0060,$7C24,$0000,$C010
	dc	$3C00,$0000,$6010,$0000
	dc	$0000,$0000,$1800,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000

TAMPON_s:
	dc.w	0
DEBUT_TEXTE_s1:
	dc.l	TEXTE_s1
TEXTE_s1:    
	dc.b        'ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789 '
	dc.b        ',;:!?./*-+                            '
	dc.w        $FF00
	even

PalNoeXtra:
	dc.w	$0000,$0666,$0555,$0444,$0333,$0222,$0111,$00F0
	dc.w	$0766,$0655,$0544,$0667,$0556,$0445,$0777,$0FFF

LogoNoeXtra:
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0008,$0008,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$8000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0008,$0000,$0008,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$8000,$0000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0008,$0000,$0008,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$8000,$0000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0008,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0010,$0018,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0001,$0000,$0000,$0000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0018,$000C,$0014,$0000,$0000,$0000,$0000,$0000
		dc.w	$0001,$0000,$0001,$0000,$8000,$C000,$4000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0014,$0020,$003C,$0000,$0000,$0000,$0000,$0000
		dc.w	$0001,$0002,$0003,$0000,$4000,$0000,$C000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0024,$000A,$0036,$0000,$0000,$0000,$0000,$0000
		dc.w	$0002,$0000,$0003,$0000,$4000,$A000,$6000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003A,$0058,$0066,$0000,$0000,$0000,$0000,$0000
		dc.w	$0003,$0005,$0006,$0000,$2000,$0000,$E000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00F6,$013D,$01C3,$0000,$0000,$0000,$0000,$0000
		dc.w	$0008,$0010,$001F,$0000,$2000,$9000,$7000,$8000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$005C,$009C,$00E3,$0000,$852C,$0478,$FB87,$0104
		dc.w	$8005,$4009,$C00E,$0000,$F554,$F559,$0AA3,$0003
		dc.w	$2800,$E400,$1C00,$0000,$594E,$9EB1,$E011,$0011
		dc.w	$AA90,$5580,$5470,$5600,$37AB,$2854,$0054,$1256
		dc.w	$5283,$A1C6,$1039,$0204,$0058,$0098,$00E7,$0000
		dc.w	$E4AE,$05FF,$FA00,$0110,$9037,$8031,$700E,$0000
		dc.w	$7434,$8B43,$01C8,$01C8,$D000,$C802,$3801,$0001
		dc.w	$5343,$A434,$0C9C,$0C9C,$4D00,$3C80,$8380,$8000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007E,$0156,$01A9,$0028,$0BF9,$0957,$F6A8,$02A8
		dc.w	$A005,$0017,$E018,$8000,$FBFC,$735E,$8CA1,$88A1
		dc.w	$5A00,$F001,$0E01,$0800,$1407,$2F8D,$C070,$100A
		dc.w	$5540,$FFC0,$0030,$8800,$1D65,$37DF,$0000,$2800
		dc.w	$13A9,$E112,$107D,$0280,$0058,$0178,$0187,$0020
		dc.w	$4055,$02FF,$FF00,$02A2,$0012,$8019,$7026,$8020
		dc.w	$D45D,$7FF7,$8000,$8008,$5001,$F401,$0C02,$0002
		dc.w	$2545,$DFFF,$2000,$2000,$5500,$7740,$88C0,$8800
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00D4,$0294,$036B,$0040,$5D08,$59EF,$A650,$0450
		dc.w	$800F,$D02A,$3035,$0005,$770E,$37EE,$C851,$4051
		dc.w	$B800,$ED02,$1303,$1000,$8652,$DB26,$20F9,$5500
		dc.w	$0010,$0000,$FFF0,$0000,$02EB,$1B9E,$2400,$0071
		dc.w	$31CE,$62F2,$903D,$0110,$00B0,$02F0,$034F,$0040
		dc.w	$0237,$0268,$FD80,$0050,$602F,$A039,$1006,$4004
		dc.w	$0CAA,$DCFF,$2300,$0040,$2802,$FA03,$0600,$4000
		dc.w	$289E,$3EEB,$C104,$4004,$AA80,$FBA0,$0460,$0400
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0378,$01D8,$0227,$0020,$3F05,$3407,$CB08,$0A08
		dc.w	$7036,$C01C,$3023,$2002,$F801,$5001,$A802,$A002
		dc.w	$5603,$9D01,$2302,$2200,$498D,$E7E6,$1079,$2220
		dc.w	$0000,$0000,$0000,$0000,$1405,$1FEF,$2230,$0228
		dc.w	$7337,$8188,$1075,$220A,$037E,$017E,$0281,$0000
		dc.w	$8E00,$8E00,$7100,$0000,$0007,$003E,$0001,$0000
		dc.w	$0750,$F060,$0F90,$0000,$D600,$5C03,$2200,$8000
		dc.w	$5D45,$97FE,$2881,$2880,$0560,$1FC0,$0020,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00D0,$01D0,$022F,$0000,$7307,$6A0A,$9505,$1405
		dc.w	$202B,$E01E,$1021,$0001,$0801,$F002,$0801,$0001
		dc.w	$0B00,$BE01,$4102,$4000,$A64F,$E302,$18F9,$4414
		dc.w	$0000,$0000,$0000,$0000,$2A8E,$1FFB,$2000,$1154
		dc.w	$B0FB,$E3C2,$103D,$0000,$00BD,$01FD,$0202,$0000
		dc.w	$1F00,$1E00,$E100,$0000,$001E,$002E,$0011,$0010
		dc.w	$26B0,$3060,$CD90,$4000,$2A01,$FC02,$1201,$1001
		dc.w	$AEFB,$FBAA,$0445,$0444,$0E80,$0AC0,$1520,$1500
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$03FA,$037A,$0085,$0080,$F304,$DC05,$2B0A,$2A0A
		dc.w	$C03F,$6015,$902A,$800A,$5801,$F001,$0802,$0002
		dc.w	$E703,$6401,$9B00,$8202,$57F4,$F586,$0879,$2202
		dc.w	$0000,$0000,$0000,$0000,$0575,$2FDF,$3000,$0200
		dc.w	$595C,$F7D5,$0023,$8008,$037B,$03FB,$0004,$0000
		dc.w	$AF00,$AE00,$5100,$0000,$0018,$0012,$002D,$0028
		dc.w	$F490,$5160,$AE90,$2000,$F601,$5C01,$0202,$A802
		dc.w	$E77D,$65D6,$9A29,$8228,$0140,$1DC0,$0220,$0200
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$02FD,$03E9,$0016,$0014,$DF00,$8A0A,$7505,$5405
		dc.w	$A03F,$E00B,$1034,$0014,$F800,$A002,$5801,$5000
		dc.w	$B300,$8A03,$7D00,$0000,$88BB,$FFAF,$4040,$5510
		dc.w	$E800,$9400,$1000,$1000,$128A,$07FF,$1800,$0410
		dc.w	$AA28,$FFFA,$0006,$0100,$02F0,$03F7,$0008,$0004
		dc.w	$DF00,$DE00,$2100,$0000,$001C,$0029,$0016,$0014
		dc.w	$1731,$6062,$9F90,$1000,$A801,$FA02,$0601,$0001
		dc.w	$B3CB,$8A9E,$7D61,$0140,$41C0,$2A80,$5560,$5540
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01F8,$0342,$00AF,$00AA,$FD05,$5607,$A908,$A808
		dc.w	$403F,$E01F,$1020,$0000,$F800,$5000,$2803,$2002
		dc.w	$B903,$0601,$ED00,$8002,$3247,$DBED,$0410,$A8A2
		dc.w	$4000,$E000,$1C00,$2000,$0405,$08EF,$0F10,$008A
		dc.w	$5568,$FFE4,$001C,$8000,$016A,$03E4,$001F,$0000
		dc.w	$7700,$FE00,$0100,$0800,$0017,$003D,$0002,$0002
		dc.w	$7A50,$51E1,$8E12,$0A00,$5001,$F403,$0C00,$8000
		dc.w	$B8AD,$0616,$EDE9,$80A8,$2740,$5DC0,$0220,$0200
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$03D1,$0280,$017F,$0151,$3F01,$6A0C,$9503,$1401
		dc.w	$203F,$E00F,$1030,$0010,$F800,$F002,$0801,$0000
		dc.w	$9D02,$AA03,$7500,$0001,$A094,$F5D1,$0A2A,$4405
		dc.w	$9400,$D000,$2C00,$4000,$128E,$07FF,$1800,$0551
		dc.w	$AAA8,$FFFA,$0006,$4500,$00A7,$03EA,$001D,$0100
		dc.w	$6700,$BA00,$0100,$5400,$001E,$002B,$0014,$0014
		dc.w	$3D10,$0841,$D6B2,$3540,$D001,$C802,$3801,$0001
		dc.w	$9D45,$AA10,$75EF,$0144,$4A80,$0AC0,$3520,$1100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01EF,$014D,$02B2,$02A2,$9503,$7E00,$810F,$8008
		dc.w	$803F,$201F,$D020,$0000,$7800,$5000,$A803,$A002
		dc.w	$A901,$1203,$FD00,$8002,$0019,$A292,$5D65,$A20A
		dc.w	$0000,$0000,$0000,$0000,$050D,$2FAF,$3050,$0282
		dc.w	$5554,$FFFD,$0003,$02A8,$036E,$01E1,$001B,$0200
		dc.w	$5100,$FE00,$0900,$2A00,$001D,$0031,$000A,$000A
		dc.w	$1551,$B7E3,$4810,$02A0,$6801,$E403,$1C00,$0000
		dc.w	$A8AF,$9214,$7DEB,$00AA,$0F40,$1840,$07A0,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01CF,$0218,$0175,$0155,$AF02,$BA08,$4507,$4400
		dc.w	$C037,$A007,$5038,$0010,$9800,$E002,$5801,$5000
		dc.w	$D100,$8C01,$7302,$5001,$8139,$D12C,$2EC3,$5014
		dc.w	$0000,$0000,$0000,$0000,$2A2A,$1F6F,$2090,$1504
		dc.w	$A62B,$F77E,$0881,$0144,$00AC,$03E2,$001F,$0140
		dc.w	$CB00,$9E00,$2100,$4400,$0039,$003A,$0005,$0005
		dc.w	$3C72,$B923,$4290,$0041,$A803,$FA03,$0600,$0000
		dc.w	$D35B,$CF02,$30F5,$1054,$0480,$0100,$1EE0,$1140
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00DB,$0059,$03A6,$0282,$B503,$5E00,$A10E,$A008
		dc.w	$403A,$201A,$D025,$0000,$1801,$5001,$A802,$2002
		dc.w	$D501,$7E01,$8102,$8000,$40A1,$E81A,$17C5,$A82A
		dc.w	$0000,$0000,$0000,$0000,$152D,$1F8F,$2050,$0AA2
		dc.w	$5305,$E1AE,$1051,$22A0,$0359,$01F9,$0006,$02A0
		dc.w	$1500,$FE00,$0100,$A200,$003E,$003D,$0002,$0002
		dc.w	$A611,$0EE3,$D110,$A8A2,$5403,$FD03,$0300,$A800
		dc.w	$BEA3,$B4A4,$4B5B,$0A0A,$0CC0,$1A40,$07A0,$0200
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01FE,$02FB,$0104,$0104,$C903,$AA08,$1507,$1400
		dc.w	$A01B,$202F,$D030,$0010,$B801,$E002,$1801,$1001
		dc.w	$DB02,$8E01,$7102,$5001,$8120,$D464,$2B9B,$5404
		dc.w	$0000,$0000,$0000,$0000,$0BA0,$1CE5,$201A,$0505
		dc.w	$31C3,$63D6,$9029,$4010,$00EA,$03BF,$0000,$0050
		dc.w	$FB00,$AE00,$0100,$1000,$001D,$0018,$0027,$0005
		dc.w	$82B2,$87E3,$7810,$0541,$2B01,$7E01,$8102,$4400
		dc.w	$DD0F,$9D1A,$62E5,$4004,$0700,$0040,$1FA0,$1000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$017D,$01C7,$02AA,$02AA,$4106,$9606,$2909,$2808
		dc.w	$4007,$602D,$9032,$0002,$EFD7,$CFD7,$3028,$2000
		dc.w	$BC00,$1500,$EB01,$A800,$4B4C,$E8CE,$1731,$2002
		dc.w	$CD80,$F260,$0210,$0720,$1628,$1D8A,$2055,$0A82
		dc.w	$5305,$A18A,$1071,$A28A,$0201,$01FF,$0080,$02A0
		dc.w	$0D00,$F600,$0300,$0A00,$001F,$001F,$0020,$0000
		dc.w	$88F3,$8AE1,$7510,$0202,$0501,$AE01,$5102,$A000
		dc.w	$EA6F,$EA3E,$15C1,$0000,$00C0,$1840,$07A0,$0080
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$008A,$02DB,$0124,$0000,$0302,$EE0F,$5100,$5000
		dc.w	$A017,$E002,$101D,$0005,$DFEB,$8FEB,$7014,$5000
		dc.w	$E801,$BA00,$4601,$4000,$2387,$7187,$8E78,$5000
		dc.w	$AAC0,$FFC0,$0030,$4400,$0E04,$1F05,$20FA,$1101
		dc.w	$9009,$C31C,$30E3,$4114,$00BC,$02EB,$0100,$0010
		dc.w	$6B00,$BA00,$0500,$0000,$003F,$001A,$0025,$0005
		dc.w	$04D0,$05C3,$FA30,$0101,$0903,$1C01,$E302,$1400
		dc.w	$C495,$C424,$3BDB,$0010,$0E80,$0BC0,$1420,$1400
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00B5,$010A,$024A,$024A,$6903,$9604,$8108,$8008
		dc.w	$0004,$8008,$F00F,$E000,$AAAB,$0AAB,$F554,$A000
		dc.w	$E800,$E400,$1C00,$0000,$4483,$8083,$FF7C,$0000
		dc.w	$5110,$FB80,$0470,$AA00,$2492,$0E82,$317D,$0A00
		dc.w	$222A,$1009,$F1F7,$0200,$02A5,$015A,$000A,$000A
		dc.w	$6A00,$9400,$8100,$8200,$002E,$0006,$0039,$0008
		dc.w	$20A2,$0290,$FD71,$0202,$2A02,$0900,$F703,$0000
		dc.w	$8352,$8091,$7FEF,$0000,$0180,$1640,$0A20,$0A00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1640,$2620,$39E0,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$EB76,$EB76,$0000,$0000,$0180,$0180,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1300,$0280,$1D80,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$AA72,$0070,$EB06,$EB76,$A080,$8000,$6180,$E180
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0900,$1400,$1B00,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0020,$4924,$EB06,$A222,$8000,$C100,$6180,$A080
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0A00,$0100,$0F00,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$A3AE,$E3AE,$4800,$ABAE,$A380,$8380,$6000,$E380
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0600,$0C00,$0A00,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$A8A8,$EBAE,$4306,$A8A8,$8280,$C380,$6100,$A280
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0200,$0600,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$A920,$E926,$428E,$ABA8,$0100,$4100,$E280,$A380
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0400,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$AAAA,$FC71,$57DF,$ABAE,$AA80,$5C00,$F780,$AB80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0400,$0000,$0400,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0400,$0000,$0400,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0400,$0400,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF

MUSIC:
	incbin	"Shadow.snd"
	even
	
******************************************************************

	SECTION	BSS

conterm		ds.w	1 

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

Zorro_scr1:	ds.l	1

Zorro_screen1:	
	ds.b	256
start:	
	ds.b	160*220
Zorro_screen1_len:	equ	*-start

Zorro_scr2:	ds.l	1

Zorro_screen2:	
	ds.b	256
start2:	
	ds.b	160*220
Zorro_screen2_len:	equ	*-start2

PTR_RAST:DS.W      1 

BUFFER1_s:	ds.b	41
BUFFER0_s:	ds.b	1
BUFFER_s:	ds.b	3494

	END
