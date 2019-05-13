* Al_9.PRG --> V 2.0 (22/05/2007)

* // Original code : Zorro2/NoExtra   // *
* // Gfx logo 	   : Mister A/NoExtra // *
* // Music 	   : Frazer	      // *
* // Release date  : 14/04/2007	      // *

***********************************************
	opt	o-,d-,W-
	opt	X+ ; for mister Kr@zyK
***********************************************

	SECTION	TEXT

***********************************************
BOTTOM_BORDER	equ	0	; 0 = I use it and 1 = no need !
PATTERN		equ	$0	; put $0 to see nothing $010f
SEEMYVBL	equ	1   	; if you press ALT : 0 = see cpu & 1 = see nothing
DECAL_OBJ	equ	160*11	; Decale le flat cube en bas
TRANSIT1	equ	$324	;	Temorisation de la transition vers l'apparence du cube et du scrolling
TRANSIT2	equ	$082	;	Temorisation vers la palette du logo AL
***********************************************

***********************************************
scr	macro				; Hang on a mo!
	move.l	\1+8+(\2*2)(a0),d0	; This is ( slightly )
	move.w	\1+(\2*2)(a0),d0	; more efficient.
	rol.l	#2,d0
	move.w	d0,\1+(\2*2)(a0)	; = 52 cycles
	endm
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
	
	bsr	Init0

******************************************************************************

	bsr	Cls_Screen

	bsr	Copy_Screen
	
	bsr	Init
  
  MOVE.L	#COLOR_TAB1,PTR_COLOR_TAB
  
Main_rout:

	bsr	Wait_vbl

	move.w	#$011,$ffff8240.w

*----------------- SCROLLING 8*8 1 plan ------------------------>

	bsr	draw_it
	
*<----------------- SCROLLING 8*8 1 plan ------------------------

*----------------- CUBE 3D ------------------------>

	bsr	CUBE3D

*<----------------- CUBE 3D ------------------------

*----------------- SCROLLING 8*8 1 plan ------------------------>

	bsr	rescroll
	
*<----------------- SCROLLING 8*8 1 plan ------------------------

*----------------- ANIMATIONS SCREEN ONLY WITH THIS MUSIC ------------------------>

* Avec tempo percution sound	
	cmp.w	#$78,TEMPO_PAL	
	bne.s pal_next0
 	MOVE.L	#COLOR_TAB2,PTR_COLOR_TAB
pal_next0:
	cmp.w	#$100,TEMPO_PAL
	bne.s pal_next1
	MOVE.L	#COLOR_TAB3,PTR_COLOR_TAB
pal_next1:
	cmp.w	#$185,TEMPO_PAL
	bne.s pal_next2
	MOVE.L	#COLOR_TAB4,PTR_COLOR_TAB
pal_next2:
	cmp.w	#$1BA,TEMPO_PAL
	bne.s pal_next3
	MOVE.L	#COLOR_TAB5,PTR_COLOR_TAB
pal_next3:
	cmp.w	#$1F4,TEMPO_PAL
	bne.s pal_next4
	MOVE.L	#COLOR_TAB6,PTR_COLOR_TAB
pal_next4:
	cmp.w	#$230,TEMPO_PAL
	bne.s pal_next5
	MOVE.L	#COLOR_TAB7,PTR_COLOR_TAB
pal_next5:
	cmp.w	#$276,TEMPO_PAL
	bne.s pal_next6
	MOVE.L	#COLOR_TAB8,PTR_COLOR_TAB
pal_next6:
	cmp.w	#$2BC,TEMPO_PAL
	bne.s pal_next7
	MOVE.L	#COLOR_TAB9,PTR_COLOR_TAB
pal_next7:
	cmp.w	#$2F8,TEMPO_PAL
	bne.s pal_next8
	MOVE.L	#COLOR_TAB10,PTR_COLOR_TAB
pal_next8:

*<----------------- ANIMATIONS SCREEN ONLY WITH THIS MUSIC ------------------------

*----------------- KEYPAD COLORS FOR FLAT CUBE ------------------------>

* Avec les touches du keypad
	cmp.b	#113,$fffffc02.w	*	Touche Pad Point
	bne.s	not_point
  MOVE.L	#COLOR_TAB,PTR_COLOR_TAB
not_point:
	cmp.b	#112,$fffffc02.w	*	Touche Pad 0
	bne.s	not_0
  MOVE.L	#COLOR_TAB1,PTR_COLOR_TAB
not_0:
	cmp.b	#109,$fffffc02.w	*	Touche Pad 1
	bne.s	not_1
  MOVE.L	#COLOR_TAB2,PTR_COLOR_TAB
not_1:
	cmp.b	#110,$fffffc02.w	*	Touche Pad 2
	bne.s	not_2
  MOVE.L	#COLOR_TAB3,PTR_COLOR_TAB
not_2:
	cmp.b	#111,$fffffc02.w	*	Touche Pad 3
	bne.s	not_3
  MOVE.L	#COLOR_TAB4,PTR_COLOR_TAB
not_3:
	cmp.b	#106,$fffffc02.w	*	Touche Pad 4
	bne.s	not_4
  MOVE.L	#COLOR_TAB5,PTR_COLOR_TAB
not_4:
	cmp.b	#107,$fffffc02.w	*	Touche Pad 5
	bne.s	not_5
  MOVE.L	#COLOR_TAB6,PTR_COLOR_TAB
not_5:
	cmp.b	#108,$fffffc02.w	*	Touche Pad 6
	bne.s	not_6
  MOVE.L	#COLOR_TAB7,PTR_COLOR_TAB
not_6:
	cmp.b	#103,$fffffc02.w	*	Touche Pad 7
	bne.s	not_7
  MOVE.L	#COLOR_TAB8,PTR_COLOR_TAB
not_7:
	cmp.b	#104,$fffffc02.w	*	Touche Pad 8
	bne.s	not_8
  MOVE.L	#COLOR_TAB9,PTR_COLOR_TAB
not_8:
	cmp.b	#105,$fffffc02.w	*	Touche Pad 9
	bne.s	not_9
  MOVE.L	#COLOR_TAB10,PTR_COLOR_TAB
not_9:

*<----------------- KEYPAD COLORS FOR FLAT CUBE ------------------------

	MOVE.L    Zorro_scr1,D0
	MOVE.L    Zorro_scr2,Zorro_scr1 
	MOVE.L    D0,Zorro_scr2
	LSR.W     #8,D0 
	MOVE.L    D0,$FFFF8200.W
  	
	IFEQ	SEEMYVBL
	cmp.b	#$38,$fffffc02.w	* Wait
	bne.s	Suite_rout		* Alt
	move.b	#$7,$ffff8240.w
Suite_rout:	
	ENDC

	cmp.b	#$39,$fffffc02.w	* Wait
	bne	Main_rout		* Space

******************************************************************************

	bsr	Restore_st

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
; VBL Zero : lance la musique + effet transition logo NoEx
Vbl0:	movem.l	d0-d7/a0-a6,-(a7)

	st	Vsync

	jsr 	(MUSIC+8)			; call music
	
	movem.l	(a7)+,d0-d7/a0-a6
	rte

; VBL transition : recopie l'écran (c'est obligatoire !) + couleur sur 1 plan
VblT:	movem.l	d0-d7/a0-a6,-(a7)

	st	Vsync

	jsr 	(MUSIC+8)			; call music

	SUB.W	#1,TEMPO
	CMP.W	#0,TEMPO
	BNE.S	.notOK
	MOVE.W	#TRANSIT2,TEMPO
	bsr	Copy_Screen
	lea	VblE(pc),a0
	move.l	a0,$70.w
.notOK

	movem.l	(a7)+,d0-d7/a0-a6
	rte

; VBL End : je finis par mettre la ligne blanche + palette du flat cube
VblE:	movem.l	d0-d7/a0-a6,-(a7)

	st	Vsync

	LEA   PalT(pc),A0 
  MOVEA.L   #$FF8240,A1 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 

	SUB.W	#1,TEMPO
	CMP.W	#0,TEMPO
	BNE.S	.notOK
	lea	Vbl(pc),a0
	move.l	a0,$70.w
	lea	Pal(pc),a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)	
.notOK
  
	IFEQ	BOTTOM_BORDER
	move.l	#Over_rout,$120.w
	move.b	#33,$fffffa21.w
	move.b	#8,$fffffa1b.w
	ENDC

	jsr 	(MUSIC+8)			; call music

	movem.l	(a7)+,d0-d7/a0-a6
	rte

; VBL : enfin la VBL !
Vbl:	

	st	Vsync

	LEA   Pal(pc),A0 
  MOVEA.L   #$FF8240,A1 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  
	IFEQ	BOTTOM_BORDER
	move.l	#Over_rout,$120.w
	move.b	#33,$fffffa21.w
	move.b	#8,$fffffa1b.w
	ENDC

	jsr 	(MUSIC+8)			; call music

	add.w	#1,TEMPO_PAL

	rte
	
Wait_vbl:	move.l	a0,-(a7)

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

	MOVE.W	#TRANSIT1,TEMPO
	
	lea	VblT(pc),a0
	move.l	a0,$70.w

	movem.l	(a7)+,d0-d7/a0-a6
	rts

TEMPO:
	DC.W	$0
TEMPO_PAL:
	DC.W	$0
	
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

	IFEQ	BOTTOM_BORDER
	sf	$fffffa21.w
	sf	$fffffa1b.w
	move.l	#Over_rout,$120.w
	bset	#0,$fffffa07.w	* Timer B on
	bset	#0,$fffffa13.w	* Timer B on
	ENDC

	stop	#$2300

	move.b	$484.w,conterm	; Sauve ce bidule.
	clr.b	$484.w		; No bip,no repeat.
			
	bsr	hide_mouse

	bsr	flush
	move.b	#$12,d0
	bsr	setkeyboard
		
	rts

	IFEQ	BOTTOM_BORDER
***************************************************************
*                                                             *
*             < Here is the lower border rout >               *
*                                                             *
***************************************************************

Over_rout:

	clr.b	$fffffa1b.w
	
	move.b	#$ff,$ffff8240.w

	move.l	#HBL_1,$120.w	
	move.b	#1,$fffffa21.w
	move.b	#8,$fffffa1b.w

	rte
	
HBL_1:

	clr.b	$fffffa1b.w
	
	move.b	#0,$ffff8240.w

	move.l	a0,-(a7)
	move.l	a1,-(a7)
	LEA       NEW_PAL,A0
  LEA       $FFFF8240.W,A1
  MOVE.W    (A0),2(A1)
  MOVE.W    2(A0),4(A1) 
  MOVE.W    4(A0),8(A1) 
	move.l	(a7)+,a1
	move.l	(a7)+,a0
		
	move.l	#END_HBL,$120.w	
	move.b	#199-33-8,$fffffa21.w
	move.b	#8,$fffffa1b.w

	rte
	
END_HBL:

	clr.b	$fffffa1b.w
	
	move.b	#$ff,$ffff8242.w

	bclr	#0,$fffffa0f.w

	rte
	ENDC
	
***************************************************************
*                                                             *
***************************************************************

Restore_st:
	move.w	#$2700,sr

	jsr	MUSIC+4			; de-init music

	move.b 	#8,$ffff8800.w        ; Sound OFF
	move.b 	#0,$ffff8802.w
	move.b 	#9,$ffff8800.w
	move.b 	#0,$ffff8802.w
	move.b 	#$a,$ffff8800.w
	move.b 	#0,$ffff8802.w
	
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

	bsr	flush
	move.b	#8,d0
	bsr	setkeyboard	
	
	bsr	show_mouse

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

Init0:	movem.l	d0-d7/a0-a6,-(a7)

	bsr	fadein
	
	clr.w	$ffff8240.w
	
	jsr	MUSIC+0			; init music

	movea.l	Zorro_scr1,a1
	adda.l	#160*76,a1
	movea.l	#LogoNoeXtra,a0
	move.l	#7999-6800+180,d0
.aff:	move.l	(a0)+,(a1)+
	dbf	d0,.aff
                	
	lea	Vbl0(pc),a0
	move.l	a0,$70.w

	lea     PalNoeXtra,a2
	bsr     fadeon	

	lea	PalNoeXtra,a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

	bsr	delay

	bsr	init_scroller
	MOVE.L	#0,AXE_X_OK
	
	bsr     fadeoff

	movem.l	(a7)+,d0-d7/a0-a6
	rts

Init_screens:	movem.l	d0-d7/a0-a6,-(a7)

	move.l	#Zorro_screen1,d0
	add.w	#$ff,d0
	sf	d0
	move.l	d0,Zorro_scr1

	move.l	#Zorro_screen2,d0
	add.w	#$ff,d0
	sf	d0
	move.l	d0,Zorro_scr2
	
	bsr	Cls_Screen
	
	movem.l	(a7)+,d0-d7/a0-a6
	rts

Cls_Screen:
	movem.l	d0-d7/a0-a6,-(a7)

	movea.l	Zorro_scr1,a6
	move.w	#Zorro_screen1_len/4-1,d1
fill:
	move.l	#PATTERN,(a6)+
	dbra	d1,fill

	movea.l	Zorro_scr2,a6
	move.w	#Zorro_screen2_len/4-1,d1
fill2:
	move.l	#PATTERN,(a6)+
	dbra	d1,fill2

	movem.l	(a7)+,d0-d7/a0-a6
	rts
	
Copy_Screen:
	movem.l	d0-d7/a0-a6,-(a7)

	movea.l	Zorro_scr1,a0
	movea.l	Zorro_scr2,a1
	move.l	#IMG_AL,a2
	move.l	#7999-6700-60,d0
.cpy:
	move.l	(a2),(a0)+
	move.l	(a2)+,(a1)+
	dbf	d0,.cpy
		
	movem.l	(a7)+,d0-d7/a0-a6
	rts

************************************************
*                                              *
************************************************

hide_mouse	movem.l	d0-d2/a0-a2,-(sp)
	dc.w	$a00a
	movem.l	(sp)+,d0-d2/a0-a2
	rts

show_mouse	movem.l	d0-d2/a0-a2,-(sp)
	dc.w	$A009
	movem.l	(sp)+,d0-d2/a0-a2
	rts

flush	lea	$FFFFFC00.w,a0
.flush	move.b	2(a0),d0
	btst	#0,(a0)
	bne.s	.flush
	rts

setkeyboard
.wait	btst	#1,$fffffc00.w
	beq	.wait
	move.b	d0,$FFFFFC02.w
	rts

fadein
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
	rts

fadeoff	
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

delay:
  MOVE.b     #$7F,D0 
.synch:
	BSR       Wait_vbl
	sub.b	#1,d0
	cmp.b	#$0,d0	
	bne.s	.synch
	rts	
	
************************************************
*             SCROLL 8*8 / SFX                 *
************************************************

;
; Init Scroller
;
init_scroller
	move.b	#0,slice	; Init scroller
	bsr	restart2
	rts
	
;
; Display scroller
;
draw_it
	lea	scroll_buffer+6,a0
	move.l	Zorro_scr2,a1
	lea	((160*192)+0)(a1),a1
	move.w	#8-1,d7
.loop:
count	set	0
 rept	20
	move.w	count(a0),count(a1)
count	set	8+count
 endr
	lea	$a0(a0),a0
	lea	$a0(a1),a1
	dbf	d7,.loop
	rts

;
; Scroller routine 
;
rescroll
	lea	scroll_buffer,a0	
	move.w	#8-1,d7		
	move.l	#this_char,a1	
scloop:
	scr	$00,3		
	scr	$08,3		
	scr	$10,3
	scr	$18,3
	scr	$20,3
	scr	$28,3
	scr	$30,3
	scr	$38,3
	scr	$40,3
	scr	$48,3
	scr	$50,3
	scr	$58,3
	scr	$60,3
	scr	$68,3
	scr	$70,3
	scr	$78,3
	scr	$80,3
	scr	$88,3
	scr	$90,3
	move.w	$98+(2*3)(a0),d1
	move.b	(a1),d0
	roxl.b	d0		
	roxl.w	d1
	roxl.b	d0
	roxl.w	d1
	move.w	d1,$98+(2*3)(a0)
	move.b	d0,(a1)+	
	adda.l	#$a0,a0		
	dbra	d7,scloop
	addq.b	#1,slice	
	andi.b	#%11,slice
	tst.b	slice
	beq	next_letter	
return:
	rts
		
next_letter
	bsr	do_letter	;Deal with letter
	bra	return		;back to scroller
restart2
	move.l	#message-1,here	;Point to character before
do_letter
	addq.l	#1,here		;Point to next char
	move.l	here,a0
	clr.l	d0
	move.b	(a0),d0		;Get letter
	cmpi.b	#0,d0		;Is it Restart?
	beq	restart2	;Yes then restart!!
	subi.w	#32,d0		;Take away ascii offset
	asl.w	#3,d0		;Multiply by 8 to get table offset
	lea	charset,a0	;Get base of char data
	adda.l	d0,a0		;Find letter we want
	lea	this_char,a1	;Copy it to 
	move.l	(a0)+,(a1)+	;This_char
	move.l	(a0)+,(a1)+	;buffer
	rts
	
************************************************
*              FLAT 3D / NOEXTRA               *
************************************************
*            Amiga code : Atomus               *
*            Optimisation : Zorro 2            *
*            Debugging : Maartau               *
************************************************
CUBE3D:           SUBQ.W    #1,COMPT
                  BNE.S     OK_COMPT
                  LEA       TRAJET,A0 
retour:           MOVE.W    (A0)+,L002A
                  tst.b     (AXE_X_OK)
                  beq.s     NO_MVT
                  MOVE.W    (A0)+,increm
NO_MVT:           MOVE.W    (A0)+,COMPT 
                  CMPI.W    #-1,(A0) 
                  BNE.S     OK_TRAJET 
                  LEA       TRAJET,A0 
OK_TRAJET:        MOVE.L    A0,retour+2	*	<-- Thanks mister Maartau !!!
OK_COMPT:         MOVEA.L   Zorro_scr1,A0 
                  lea       DECAL_OBJ(a0),a0
                  MOVE.W    XMINIMUM2,D0
                  TST.W     D0
                  BMI.S     OK_XMIN 
                  LSR.W     #1,D0 
                  ANDI.W    #$FFF8,D0 
                  ADDA.W    D0,A0 
OK_XMIN:          MOVE.W    YMINIMUM2,D1
                  MOVE.W    YMAXIMUM2,D0
                  SUB.W     D1,D0 
                  BMI.S     NO_CLR
                  MOVE.W    D1,D2
                  ADD.W     D1,D1
                  ADD.W     D1,D1       ; D1=NB*4.
                  ADD.W     D2,D1       ; D1=NB*5.
                  LSL.W     #$5,D1      ; D1=(NB*5)*32.                 
                  ADDA.W    D1,A0 
                  MOVEQ     #0,D1 
CLR_OBJECT:       MOVE.L    D1,(A0) 
                  MOVE.W    D1,4(A0)
                  MOVE.L    D1,8(A0)
                  MOVE.W    D1,12(A0) 
                  MOVE.L    D1,16(A0) 
                  MOVE.W    D1,20(A0) 
                  MOVE.L    D1,24(A0) 
                  MOVE.W    D1,28(A0) 
                  MOVE.L    D1,32(A0) 
                  MOVE.W    D1,36(A0) 
                  MOVE.L    D1,40(A0) 
                  MOVE.W    D1,44(A0) 
                  MOVE.L    D1,48(A0) 
                  MOVE.W    D1,52(A0) 
                  MOVE.L    D1,56(A0) 
                  MOVE.W    D1,60(A0) 
                  LEA       160(A0),A0
                  DBF       D0,CLR_OBJECT 
NO_CLR:           LEA       POINTS,A0 
                  LEA       OBJECT,A1 
                  LEA       COSINUS,A2
                  MOVEA.L   A2,A3 
                  ADDA.W    ALPHA,A2
                  ADDA.W    BETA,A3 
                  MOVE.W    #7,D0 
CALCUL:           MOVE.W    (A0)+,D1
                  MOVE.W    (A0)+,D2
                  MOVE.W    (A0)+,D3
                  MOVE.W    D1,D4 
                  MOVE.W    D3,D5 
                  MULS      (A2),D1 
                  MULS      2(A2),D3
                  ADD.L     D3,D1 
                  MULS      (A2),D5 
                  MULS      2(A2),D4
                  SUB.W     D4,D5 
                  MOVE.W    D5,D3 
                  ASR.W     #8,D3 
                  MOVE.W    D2,D4 
                  MOVE.W    D3,D5 
                  MULS      (A3),D2 
                  MULS      2(A3),D3
                  ADD.L     D3,D2 
                  MULS      (A3),D5 
                  MULS      2(A3),D4
                  SUB.W     D4,D5 
                  MOVE.W    D5,D3 
                  ASR.W     #8,D3 
                  SUBI.W    #$100,D3
                  NEG.W     D3
                  DIVS      D3,D1 
                  DIVS      D3,D2 
                  ADDI.W    #$FFBA/2,D1 
VITESSE:          EQU       *-2 
                  addi.W    #100,D2 
                  MOVE.W    D1,(A1)+
                  MOVE.W    D2,(A1)+
                  DBF       D0,CALCUL 
                  ADDI.W    #0,VITESSE
                  CMPI.W    #150,VITESSE
                  BGT       STOP_IT                  
                  BRA.S     OK_X_ORG
STOP_IT:          MOVE.W    #150,VITESSE
                  ST        AXE_X_OK
OK_X_ORG:         MOVE.W    #0,YMAXIMUM2
                  MOVE.W    #$FFF,YMINIMUM2 
                  MOVE.W    #$FFF,XMINIMUM2 
                  LEA       FACE_DATA,A3
                  LEA       OBJECT,A1 
                  MOVE.W    #5,D7 
                  MOVE.W    #4,NBRE_SOMMETS 
AFF_OBJECT:       LEA       SOMMETS,A2
                  MOVE.W    (A3)+,D0
                  MOVE.L    0(A1,D0.W),(A2) 
                  MOVE.W    (A3)+,D0
                  MOVE.L    0(A1,D0.W),4(A2)
                  MOVE.W    (A3)+,D0
                  MOVE.L    0(A1,D0.W),8(A2)
                  MOVE.W    (A3)+,D0
                  MOVE.L    0(A1,D0.W),12(A2) 
                  MOVEM.W   (A2),D0-D5
                  SUB.W     D0,D4 
                  SUB.W     D1,D3 
                  SUB.W     D0,D2 
                  SUB.W     D1,D5 
                  MULS      D4,D3 
                  MULS      D5,D2 
                  SUB.W     D2,D3 
                  BMI.S     NO_AFF
                  EXT.L     D3
                  LEA       COLOR_TAB,A6
PTR_COLOR_TAB     EQU       *-4                 
                  LEA       NEW_PAL,A5
                  DIVU      #418-1,D3
                  ADD.W     D3,D3 
                  MOVE.W    0(A6,D3.W),D3 
                  MOVE.W    (A3),D4 
                  MOVE.W    D3,0(A5,D4.W) 
                  MOVEA.L   Zorro_scr1,A0 
                  lea       DECAL_OBJ(a0),a0                
                  ADDA.W    (A3),A0 
                  MOVEM.L   A3/A1/D7,-(A7)
                  BSR       POLYGONE
                  MOVEM.L   (A7)+,A3/A1/D7
NO_AFF:           ADDQ.W    #2,A3 
                  DBF       D7,AFF_OBJECT 
                  ADDI.W    #0,ALPHA
L002A             EQU       *-6 
                  CMPI.W    #$5A0,ALPHA 
                  BCS.S     INC_BETA
                  SUBI.W    #160*9,ALPHA 
INC_BETA:         ADDI.W    #0,BETA 
increm:           EQU       *-6 
                  CMPI.W    #160*9,BETA
                  BCS.S     OK_BETA 
                  SUBI.W    #160*9,BETA
OK_BETA:          MOVE.W    YMINIMUM1,D0
                  MOVE.W    YMINIMUM2,YMINIMUM1 
                  MOVE.W    D0,YMINIMUM2
                  MOVE.W    YMAXIMUM1,D0
                  MOVE.W    YMAXIMUM2,YMAXIMUM1 
                  MOVE.W    D0,YMAXIMUM2
                  MOVE.W    XMINIMUM1,D0
                  MOVE.W    XMINIMUM2,XMINIMUM1 
                  MOVE.W    D0,XMINIMUM2
                  RTS
              
POLYGONE:         MOVE.L    A0,RELOC
                  LEA       SOMMETS,A0
                  MOVE.W    NBRE_SOMMETS,D7 
                  SUBQ.W    #1,D7 
                  MOVE.W    #400,D0
                  MOVEQ     #0,D1 
FIND_Y:           MOVE.L    (A0)+,D2
                  CMP.W     D2,D0 
                  BLT.S     FIND_Y2 
                  MOVE.W    D2,D0 
FIND_Y2:          CMP.W     D2,D1 
                  BGT.S     FIND_Y3 
                  MOVE.W    D2,D1 
FIND_Y3:          DBF       D7,FIND_Y 
                  MOVE.W    D0,Y_MIN
                  MOVE.W    D1,Y_MAX
                  TST.W     Y_MAX 
                  BMI       FIN_POLYGONE
                  CMPI.W    #200-1,Y_MIN
                  BGT       FIN_POLYGONE
                  CMPI.W    #200,Y_MAX
                  BLT.S     OK_D1 
                  MOVE.W    #200-1,Y_MAX
OK_D1:            MOVE.W    Y_MIN,D0
                  CMP.W     YMINIMUM2,D0
                  BGT.S     NO_MIN
                  MOVE.W    D0,YMINIMUM2
NO_MIN:           MOVE.W    Y_MAX,D0
                  CMP.W     YMAXIMUM2,D0
                  BLT.S     NO_MAX
                  MOVE.W    D0,YMAXIMUM2
NO_MAX:           LEA       TABLEAU,A0
                  MOVE.W    D1,D7 
                  MOVE.W    Y_MIN,D0
                  MOVE.W    Y_MAX,D7
                  SUB.W     D0,D7 
                  ADD.W     D0,D0 
                  ADD.W     D0,D0 
                  ADDA.W    D0,A0 
                  MOVE.L    #$FFF0000,D0
INIT_TABLEAU:     MOVE.L    D0,(A0)+
                  DBF       D7,INIT_TABLEAU 
                  LEA       SOMMETS,A0
                  MOVE.L    (A0),D1 
                  MOVE.W    NBRE_SOMMETS,D0 
                  ADD.W     D0,D0 
                  ADD.W     D0,D0 
                  MOVE.L    D1,0(A0,D0.W) 
                  LEA       SOMMETS,A1
                  MOVE.W    NBRE_SOMMETS,D7 
                  SUBQ.W    #1,D7 
TRACE_LINE:       MOVE.W    (A1)+,D0
                  MOVE.W    (A1)+,D1
                  MOVE.W    (A1),D2 
                  MOVE.W    2(A1),D3
                  BSR       LINE
                  DBF       D7,TRACE_LINE 
                  TST.W     Y_MIN 
                  BPL.S     OK_OO 
                  LEA       TABLEAU,A5
                  MOVEA.L   RELOC,A4
                  MOVE.W    #0,D0 
                  BRA.S     AFF_POLY
OK_OO:            LEA       TABLEAU,A5
                  LEA       $1F8000,A4
RELOC             EQU       *-4 
                  MOVE.W    Y_MIN,D0
                  MOVE.W		D0,D2
                  ADD.W			D0,D0
                  ADD.W			D0,D0       ; D0=NB*4.
                  ADD.W			D2,D0       ; D0=NB*5.
                  LSL.W			#$5,D0      ; D0=(NB*5)*32.                 
                  ADDA.W    D0,A4 
                  MOVE.W    Y_MIN,D0
AFF_POLY:         MOVE.W    Y_MAX,D7
                  SUB.W     D0,D7 
                  SUBQ.W    #1,D7 
                  BMI.S     FIN_POLYGONE
                  ADD.W     D0,D0 
                  ADD.W     D0,D0 
                  ADDA.W    D0,A5 
                  LEA       MOTIF,A1
                  LEA       MOTIF2,A6 
                  LEA       ROUT_TABLE,A2 
                  MOVEQ     #$FF,D1 
                  MOVE.W    #160,D6 
FILL_FACE:        MOVEA.L   A4,A0 
                  ADDA.W    D6,A4 
                  MOVE.L    (A5)+,D3
                  MOVE.L    0(A6,D3.W),D2 
                  SWAP      D3
                  MOVE.L    0(A1,D3.W),D0 
                  ADDA.W    D0,A0 
                  SUB.W     D0,D2 
                  MOVEA.L   0(A2,D2.W),A3 
                  SWAP      D0
                  SWAP      D2
                  JMP       (A3)
FIN_POLYGONE:     RTS 

LINE:             CMP.W     XMINIMUM2,D0
                  BGT.S     NO_XMIN 
                  MOVE.W    D0,XMINIMUM2
NO_XMIN:          CMP.W     XMINIMUM2,D2
                  BGT.S     NO_XMIN2
                  MOVE.W    D2,XMINIMUM2
NO_XMIN2:         CMP.W     D1,D3 
                  BGT.S     LINE2 
                  EXG       D2,D0 
                  EXG       D3,D1 
LINE2:            LEA       TABLEAU,A0
                  MOVE.W    D1,D4 
                  ADD.W     D4,D4 
                  ADD.W     D4,D4 
                  ADDA.W    D4,A0 
                  SUB.W     D1,D3 
                  MOVEQ     #4,D4 
                  SUB.W     D0,D2 
                  BPL.S     LINE3 
                  NEG.W     D2
                  NEG.W     D4
LINE3:            TST.W     D3
                  BEQ.S     FIN_LINE_X
                  CMP.W     D2,D3 
                  BCC.S     LINE_Y
                  ADD.W     D0,D0 
                  ADD.W     D0,D0 
                  MOVE.W    D3,D1 
                  SUBQ.W    #1,D1 
                  BMI.S     FIN_LINE_X
                  MOVE.W    D2,D6 
                  LSR.W     #1,D6 
LINE_X2:          CMP.W     (A0),D0 
                  BGE.S     LINE_X3 
                  MOVE.W    (A0),2(A0)
                  MOVE.W    D0,(A0)+
                  ADDQ.W    #2,A0 
                  BRA.S     LINE_X4 
LINE_X3:          ADDQ.W    #2,A0 
                  MOVE.W    D0,(A0)+
LINE_X4:          ADD.W     D4,D0 
                  SUB.W     D3,D6 
                  BGT.S     LINE_X4 
                  ADD.W     D2,D6 
                  DBF       D1,LINE_X2
FIN_LINE_X:       RTS 

LINE_Y:           ADD.W     D0,D0 
                  ADD.W     D0,D0 
                  MOVE.W    D3,D1 
                  SUBQ.W    #1,D1 
                  BMI.S     FIN_LINE_Y
                  MOVE.W    D3,D6 
                  LSR.W     #1,D6 
LINE_Y2:          CMP.W     (A0),D0 
                  BGE.S     LINE_Y3 
                  MOVE.W    (A0),2(A0)
                  MOVE.W    D0,(A0)+
                  ADDQ.W    #2,A0 
                  BRA.S     LINE_Y4 
LINE_Y3:          ADDQ.W    #2,A0 
                  MOVE.W    D0,(A0)+
LINE_Y4:          SUB.W     D2,D6 
                  BGT.S     LINE_Y5 
                  ADD.W     D4,D0 
                  ADD.W     D3,D6 
LINE_Y5:          DBF       D1,LINE_Y2
FIN_LINE_Y:       RTS 

ROUT1:            AND.W     D2,D0 
                  OR.W      D0,(A0) 
                  DBF       D7,FILL_FACE
                  RTS 
ROUT2:            OR.W      D0,(A0) 
                  OR.W      D2,8(A0)
                  DBF       D7,FILL_FACE
                  RTS 
ROUT3:            OR.W      D0,(A0) 
                  MOVE.W    D1,8(A0)
                  OR.W      D2,16(A0) 
                  DBF       D7,FILL_FACE
                  RTS 
ROUT4:            OR.W      D0,(A0) 
n	set	8
	rept	2
                  MOVE.W    D1,n(A0)
n	set	n+8
	endr
                  OR.W      D2,24(A0) 
                  DBF       D7,FILL_FACE
                  RTS 
ROUT5:            OR.W      D0,(A0) 
n	set	8
	rept	3
                  MOVE.W    D1,n(A0)
n	set	n+8
	endr
                  OR.W      D2,32(A0) 
                  DBF       D7,FILL_FACE
                  RTS 
ROUT6:            OR.W      D0,(A0)
n	set	8
	rept	4
                  MOVE.W    D1,n(A0)
n	set	n+8
	endr
                  OR.W      D2,40(A0) 
                  DBF       D7,FILL_FACE
                  RTS 
ROUT7:            OR.W      D0,(A0) 
n	set	8
	rept	5
                  MOVE.W    D1,n(A0)
n	set	n+8
	endr
                  OR.W      D2,48(A0) 
                  DBF       D7,FILL_FACE
                  RTS 
ROUT8:            OR.W      D0,(A0) 
n	set	8
	rept	6
                  MOVE.W    D1,n(A0)
n	set	n+8
	endr
                  OR.W      D2,56(A0) 
                  DBF       D7,FILL_FACE
                  RTS 
ROUT9:            OR.W      D0,(A0) 
n	set	8
	rept	7
                  MOVE.W    D1,n(A0)
n	set	n+8
	endr
                  OR.W      D2,64(A0) 
                  DBF       D7,FILL_FACE
                  RTS 
ROUT10:           OR.W      D0,(A0) 
n	set	8
	rept	8
                  MOVE.W    D1,n(A0)
n	set	n+8
	endr
                  OR.W      D2,72(A0) 
                  DBF       D7,FILL_FACE
                  RTS 
ROUT11:           OR.W      D0,(A0) 
n	set	8
	rept	9
                  MOVE.W    D1,n(A0)
n	set	n+8
	endr
                  OR.W      D2,80(A0) 
                  DBF       D7,FILL_FACE
                  RTS 
ROUT12:           OR.W      D0,(A0) 
n	set	8
	rept	10
                  MOVE.W    D1,n(A0)
n	set	n+8
	endr
                  OR.W      D2,88(A0) 
                  DBF       D7,FILL_FACE
                  RTS 
ROUT13:           OR.W      D0,(A0) 
n	set	8
	rept	11
                  MOVE.W    D1,n(A0)
n	set	n+8
	endr
                  OR.W      D2,96(A0) 
                  DBF       D7,FILL_FACE
                  RTS 
ROUT14:           OR.W      D0,(A0) 
n	set	8
	rept	12
                  MOVE.W    D1,n(A0)
n	set	n+8
	endr
                  OR.W      D2,104(A0)
                  DBF       D7,FILL_FACE
                  RTS 
ROUT15:           OR.W      D0,(A0) 
n	set	8
	rept	13
                  MOVE.W    D1,n(A0)
n	set	n+8
	endr
                  OR.W      D2,112(A0)
                  DBF       D7,FILL_FACE
                  RTS 
ROUT16:           OR.W      D0,(A0) 
n	set	8
	rept	14
                  MOVE.W    D1,n(A0)
n	set	n+8
	endr
                  OR.W      D2,120(A0)
                  DBF       D7,FILL_FACE
                  RTS 
ROUT17:           OR.W      D0,(A0) 
n	set	8
	rept	15
                  MOVE.W    D1,n(A0)
n	set	n+8
	endr
                  OR.W      D2,128(A0)
                  DBF       D7,FILL_FACE
                  RTS 
ROUT18:           OR.W      D0,(A0) 
n	set	8
	rept	16
                  MOVE.W    D1,n(A0)
n	set	n+8
	endr
                  OR.W      D2,136(A0)
                  DBF       D7,FILL_FACE
                  RTS 
ROUT19:           OR.W      D0,(A0) 
n	set	8
	rept	17
                  MOVE.W    D1,n(A0)
n	set	n+8
	endr
                  OR.W      D2,144(A0)
                  DBF       D7,FILL_FACE
                  RTS 
ROUT20:           OR.W      D0,(A0) 
n	set	8
	rept	18
                  MOVE.W    D1,n(A0)
n	set	n+8
	endr
                  OR.W      D2,152(A0)
                  DBF       D7,FILL_FACE
                  RTS 

******************************************************************

	SECTION	DATA

Pal:
	dc.w	$0011,$0811,$0300,$0677,$0DEE,$0566,$0CDD,$0455
	dc.w	$0BCC,$0344,$0ABB,$0233,$09AA,$0122,$0899,$0777

PalT:
	dc.w	$0011,$0811,$0,$0,$0,$0

ALPHA:            DC.W      $000 
BETA:             DC.W      $000 
Y_MIN:            DC.W      $000 
Y_MAX:            DC.W      $000 
NBRE_SOMMETS:     DC.W      $000 
SOMMETS:          DCB.W     14,$0
TABLEAU:          DCB.W     400,$0 
OBJECT:           DCB.W     16,$0
COSINUS:
	incbin	"COSINUS.DAT"
	even
YMINIMUM1:        DC.W      $0 
YMINIMUM2:        DC.W      $0 
YMAXIMUM1:        DC.W      $0 
YMAXIMUM2:        DC.W      $0 
XMINIMUM1:        DC.W      $0 
XMINIMUM2:        DC.W      $0 
NEW_PAL:          DCB.W     3,$0 
COMPT:            DC.W      $0001
ROUT_TABLE:       DC.L      ROUT1 
                  DCB.W     2,$0 
                  DC.L      ROUT2 
                  DCB.W     2,$0 
                  DC.L      ROUT3 
                  DCB.W     2,$0 
                  DC.L      ROUT4 
                  DCB.W     2,$0 
                  DC.L      ROUT5 
                  DCB.W     2,$0 
                  DC.L      ROUT6 
                  DCB.W     2,$0 
                  DC.L      ROUT7 
                  DCB.W     2,$0 
                  DC.L      ROUT8 
                  DCB.W     2,$0 
                  DC.L      ROUT9 
                  DCB.W     2,$0 
                  DC.L      ROUT10
                  DCB.W     2,$0 
                  DC.L      ROUT11
                  DCB.W     2,$0 
                  DC.L      ROUT12
                  DCB.W     2,$0 
                  DC.L      ROUT13
                  DCB.W     2,$0 
                  DC.L      ROUT14
                  DCB.W     2,$0 
                  DC.L      ROUT15
                  DCB.W     2,$0 
                  DC.L      ROUT16
                  DCB.W     2,$0 
                  DC.L      ROUT17
                  DCB.W     2,$0 
                  DC.L      ROUT18
                  DCB.W     2,$0 
                  DC.L      ROUT19
                  DCB.W     2,$0 
                  DC.L      ROUT20
MOTIF0:
	incbin	"MOTIF0.DAT"
	even
MOTIF:
	incbin	"MOTIF1.DAT"
	even
MOTIF2:
	incbin	"MOTIF2.DAT"
	even
PT_NULL	equ	$FFDD
PT_POS	equ	35
POINTS:
	dc.w	PT_NULL,PT_NULL,PT_NULL,PT_POS
	dc.w	PT_NULL,PT_NULL,PT_POS,PT_POS
	dc.w	PT_NULL,PT_NULL,PT_POS,PT_NULL
	dc.w	PT_NULL,PT_NULL,PT_POS,PT_POS
	dc.w	PT_NULL,PT_POS,PT_POS,PT_POS
	dc.w	PT_POS,PT_NULL,PT_POS,PT_POS
FACE_DATA:
	dc.w	$0000,$0004,$0008,$000C
	dc.w	$0000,$0010,$001C,$0018
	dc.w	$0014,$0000,$0000,$000C
	dc.w	$001C,$0010,$0002,$0004
	dc.w	$0014,$0018,$0008,$0002
	dc.w	$0000,$0010,$0014,$0004
	dc.w	$0004,$000C,$0008,$0018
	dc.w	$001C,$0004
	
COLOR_TAB: * ROUGE
	dc.w	$0000,$0800,$0100,$0900,$0200,$0A00,$0300,$0B00
	dc.w	$0400,$0C00,$0500,$0D00,$0600,$0E00,$0700,$0F00
	dc.w	$0F01
COLOR_TAB1: * BLEU
	dc.w	$0000,$0008,$0001,$0009,$0002,$000A,$0003,$000B
	dc.w	$0004,$000C,$0005,$000D,$0006,$000E,$0007,$000F
	dc.w	$010F
COLOR_TAB2: * VERT
	dc.w	$0000,$0080,$0010,$0090,$0020,$00A0,$0030,$00B0
	dc.w	$0040,$00C0,$0050,$00D0,$0060,$00E0,$0070,$00F0
	dc.w	$001F
blue = $330
COLOR_TAB3: * VERT BLEU
	dc.w	$0000+blue,$0008+blue,$0001+blue,$0009+blue,$0002+blue,$000A+blue,$0003+blue,$000B+blue
	dc.w	$0004+blue,$000C+blue,$0005+blue,$000D+blue,$0006+blue,$000E+blue,$0007+blue,$000F+blue
	dc.w	$0
red = $033
COLOR_TAB4: * ORANGE VERT
	dc.w	$0000+red,$0800+red,$0100+red,$0900+red,$0200+red,$0A00+red,$0300+red,$0B00+red
	dc.w	$0400+red,$0C00+red,$0500+red,$0D00+red,$0600+red,$0E00+red,$0700+red,$0F00+red
	dc.w	$0
blue1 = $660
COLOR_TAB5: * JAUNE BLANC
	dc.w	$0000+blue1,$0008+blue1,$0001+blue1,$0009+blue1,$0002+blue1,$000A+blue1,$0003+blue1,$000B+blue1
	dc.w	$0004+blue1,$000C+blue1,$0005+blue1,$000D+blue1,$0006+blue1,$000E+blue1,$0007+blue1,$000F+blue1
	dc.w	$0
red1 = $066
COLOR_TAB6: * BLEU ROSE
	dc.w	$0000+red1,$0800+red1,$0100+red1,$0900+red1,$0200+red1,$0A00+red1,$0300+red1,$0B00+red1
	dc.w	$0400+red1,$0C00+red1,$0500+red1,$0D00+red1,$0600+red1,$0E00+red1,$0700+red1,$0F00+red1
	dc.w	$0
blue2 = $900
COLOR_TAB7: * ROUGE BLEU
	dc.w	$0000+blue2,$0008+blue2,$0001+blue2,$0009+blue2,$0002+blue2,$000A+blue2,$0003+blue2,$000B+blue2
	dc.w	$0004+blue2,$000C+blue2,$0005+blue2,$000D+blue2,$0006+blue2,$000E+blue2,$0007+blue2,$000F+blue2
	dc.w	$0
red2 = $099
COLOR_TAB8: * ROUGE GRIS
	dc.w	$0000+red2,$0800+red2,$0100+red2,$0900+red2,$0200+red2,$0A00+red2,$0300+red2,$0B00+red2
	dc.w	$0400+red2,$0C00+red2,$0500+red2,$0D00+red2,$0600+red2,$0E00+red2,$0700+red2,$0F00+red2
	dc.w	$0
blue3 = $160
COLOR_TAB9: * BLEU VERT
	dc.w	$0000+blue3,$0008+blue3,$0001+blue3,$0009+blue3,$0002+blue3,$000A+blue3,$0003+blue3,$000B+blue3
	dc.w	$0004+blue3,$000C+blue3,$0005+blue3,$000D+blue3,$0006+blue3,$000E+blue3,$0007+blue3,$000F+blue3
	dc.w	$0
red3 = $016
COLOR_TAB10: * BLEU ROSE
	dc.w	$0000+red3,$0800+red3,$0100+red3,$0900+red3,$0200+red3,$0A00+red3,$0300+red3,$0B00+red3
	dc.w	$0400+red3,$0C00+red3,$0500+red3,$0D00+red3,$0600+red3,$0E00+red3,$0700+red3,$0F00+red3
	dc.w	$0
TRAJET:
	dc.w	$000C,$0004,$00C8
	dc.w	$0004,$0008,$00C8
	dc.w	$000C,$0008,$012C
	dc.w	$000C,$000C,$0064
	dc.w	$000C,$0010,$0064
	dc.w	$0010,$0008,$012C
	dc.w	$000C,$0008,$0064
	dc.w	$0008,$0008,$0096
	dc.w	$0004,$0008,$0064
	dc.w	$0004,$0004,$00FA
	dc.w	$0008,$0004,$0096
	dc.w	$FFFF

AXE_X_OK:
	DC.W	$0 
	
IMG_AL:
	incbin	"LOGOAL.IMG"
	even

PalNoeXtra:
	dc.w	$0000,$0666,$0555,$0444,$0333,$0222,$0111,$00F0
	dc.w	$0766,$0655,$0544,$0667,$0556,$0445,$0777,$0FFF

LogoNoeXtra:
	incbin	"LOGONOEX.IMG"
	even

charset:
	incbin	"BLOCKY8.TFB"		; the scroller font
	even

message:
; Characters---ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789 ()!,-+.:?/;'"

 rept	10
	DC.B	'                    '
 endr

	DC.B	'HI GUYS ! IT',$27,'S ZORRO 2 FROM NOEXTRA ! '
	DC.B	'                    SURPISE !                     '
	DC.B	'YOU SEE FOR THE FIRST TIME AN EFFECT WHO DON',$27,'T USE BY THE NOEXTRA CREW. '
	DC.B	'IT SHOULD HAVE BEEN INTEGRATED IN THE FAMOUS SCREEN CALL ',$27,'ARE YOU SQUARE ?',$27,' '
	DC.B	'IN THE 20 YEARS COMPO OF DHS.                     '
	DC.B	'IN FACT, I',$27,'M NOT READY TO USE IT BECAUSE IT NEEDED OF OPTIMISATIONS AND COLORISATIONS '
	DC.B	'AND DEBUGGING (THANKS MISTER MAARTAU !!!)                                '
	DC.B	'IT HAD TO SERVE IN FACT FOR MAKING A SCREEN LIKE AN ',$27,'ALL OF FAMES',$27,' WITH '
	DC.B	'ALL THE NAMES OF ALL ATARI DEMOS',$27,'S GROUPS !                      '
	DC.B	'                    BUT THIS LAST WEEK...                      '
	DC.B	'I RECEIVE A MAIL THIS WEEK FROM TONTON BRUNO WHO WOULD INDEED LIKE TO PLAY AT THE GAME AU NOM DE L',$27
	DC.B	'HERMINE FROM THE AL WEBSITE. I CALL BRUME FOR THIS GAME WHO HAVE IT SINCE TWO YEARS BUT IT NEEDED '
	DC.B	'AN INTRO.                  THEN...                     I DID IT !                   '
	DC.B	'THIS INTRO IS DEDICATED FOR YOU MISTER TONTON BRUNO ! NOW YOU CAN PLAY WITH IT...........'
	DC.B	'                                                   '
	DC.B	'MESSAGE FOR FRENCH PEOPLE : NE PAS OUBLIER DE VOTER LA SEMAINE PROCHAINE !     '
	DC.B	'                                                   '
	DC.B	'LAST RELEASE IN 15/04/2007 FROM NOEXTRA TEAM.      '
	DC.B	'                                                   '

*--> Tu peux ecrire par ici Bruno...

	DC.B	' '

	dc.b	$0
	even
	
MUSIC: * not compress please !
	incbin	"AMAZ2.SND"
	even

******************************************************************

	SECTION	BSS

here:
	ds.l	1
this_char:
	ds.b	8
slice:
	ds.w	1
scroll_buffer:
	ds.b	1600

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
start1:	
	ds.b	160*200
	IFEQ	BOTTOM_BORDER
	ds.b	160*50
	ENDC
Zorro_screen1_len:	equ	*-start1

Zorro_scr2:	ds.l	1

Zorro_screen2:	
	ds.b	256
start2:	
	ds.b	160*200
	IFEQ	BOTTOM_BORDER
	ds.b	160*50
	ENDC
Zorro_screen2_len:	equ	*-start2

	
	END
