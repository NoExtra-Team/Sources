*************
* AL_12.PRG *
*************

* // Intro Code version 0.3	// *
* // Original code : Zorro 2/NoExtra	// *
* // Gfx logo 	   : Mister.A/NoExtra	// *
* // Music 	   : Sally	// *
* // Release date  : 04/03/2007		// *
* // Update date   : 13/12/2007		// *

*************************************
	OPT	c+	; Case sensitivity on.
	OPT	d-	; Debug off.
	OPT	o-	; All optimisations off.
	OPT	w-	; Warnings off.
	OPT	x-	; Extended debug off.
*************************************

	SECTION	TEXT

******************************************************
* > For use the bottom overscan effect
BOTTOM_BORDER	equ 1	  ; 0 = I use it and 1 = no need !
* > Allow you to see the screen plan
PATTERN		equ $0 	  ; put $0 to see nothing
			  ; put $010f to see nothing
* > Allow to see the top of the VBL on the screen
SEEMYVBL	equ 1     ; if you press key ALT 
			  ; 0 = see cpu & 1 = see nothing
*****************************************************

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

	bsr	clear_bss
	
	bsr	Init_screens

	bsr	Save_and_init_a_st

	bsr	Init0
	
******************************************************************************

	bsr	Init

Main_rout:

	bsr	Wait_vbl

	IFEQ	SEEMYVBL
	clr.b	$ffff8240.w
	ENDC

* Put your code here !
* >

	bsr	Boule3D

	bsr	CLS_LIGNE

	bsr	SCROL8Y

	bsr	Fade3D

* <

	MOVE.L    Zorro_scr1,D0
	MOVE.L    Zorro_scr2,Zorro_scr1 
	MOVE.L    D0,Zorro_scr2
	LSR.W     #8,D0 
	MOVE.L    D0,$FFFF8200.W
  	
	IFEQ	SEEMYVBL
	cmp.b	#$38,$fffffc02.w	* Wait
	bne.s	Suite_rout		* Alt
	move.b	#7,$ffff8240.w
Suite_rout:	
	ENDC

	cmp.b	#$39,$fffffc02.w	* Wait
	bne.s	Main_rout		* Space

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

Vbl0:	movem.l	d0-d7/a0-a6,-(a7)

	st	Vsync

	jsr 	(MUSIC+8)			; call music
	
	movem.l	(a7)+,d0-d7/a0-a6
	rte
	
Vbl:	movem.l	d0-d7/a0-a6,-(a7)

	st	Vsync

	IFEQ	BOTTOM_BORDER
	move.l	#Over_rout,$120.w
	move.b	#199,$fffffa21.w
	move.b	#8,$fffffa1b.w
	ENDC

	jsr 	(MUSIC+8)			; call music

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

	bsr	PUT_LINES

depart equ (160*190)+8*15

	movea.l	Zorro_scr1,a1
	adda.l	#depart,a1
	movea.l	Zorro_scr2,a2
	adda.l	#depart,a2
	movea.l	#Petit_Logo_NoEx,a0
	move.l	#7999-7700-20,d0
.aff:	move.l	(a0),(a1)+
	move.l	(a0)+,(a2)+
	dbf	d0,.aff
	
	lea	Vbl(pc),a0
	move.l	a0,$70.w

	lea	Pal(pc),a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

  MOVEQ     #8*0,D0
  LEA       TABLEAU(PC),A2 ; Met les couleurs des sprites 8242.w et 8244.w
  LEA       0(A2,D0.W),A0
  LEA       $FFFF8242.W,A1
  MOVE.W    (A0)+,(A1)+ 
  MOVE.L    (A0),(A1) 

	move.w	#0,CPT_FADE
	move.w	#8*0,INDEX 
	
	movem.l	(a7)+,d0-d7/a0-a6
	rts

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

	bsr	Precalcul 
	
	bsr	fadeoff

	movea.l	Zorro_scr1,a6
	move.w	#Zorro_screen1_len/4-1,d1
.fill:	move.l	#PATTERN,(a6)+
	dbra	d1,.fill
	
	movem.l	(a7)+,d0-d7/a0-a6
	rts
	
************************************************
*                                              *
************************************************

Save_and_init_a_st:

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

	clr.b     $fffffa07.w 
	clr.b     $fffffa09.w 

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
	
	move.b	#$13,$ffff8240.w

	rte
	ENDC
	
***************************************************************
*                                                             *
***************************************************************

Restore_st:

	move #$2700,sr

	jsr	MUSIC+4			; de-init music

	lea       $ffff8800.w,a0
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

	move.b	Video,$ffff8260.w

	move.w	#$25,-(a7)
	trap	#14
	addq.w	#2,a7

	rts

************************************************
*                                              *
************************************************

Init_screens:	movem.l	d0-d7/a0-a6,-(a7)

	move.l	#Zorro_screen1,d0
	add.w	#$ff,d0
	sf	d0
	move.l	d0,Zorro_scr1

	move.l	#Zorro_screen2,d0
	add.w	#$ff,d0
	sf	d0
	move.l	d0,Zorro_scr2
	
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

************************************************
*                                              *
************************************************

hide_mouse:
	movem.l	d0-d2/a0-a2,-(sp)
	dc.w	$a00a
	movem.l	(sp)+,d0-d2/a0-a2
	rts

show_mouse:
	movem.l	d0-d2/a0-a2,-(sp)
	dc.w	$A009
	movem.l	(sp)+,d0-d2/a0-a2
	rts

flush:
	lea	$FFFFFC00.w,a0
.flush:
	move.b	2(a0),d0
	btst	#0,(a0)
	bne.s	.flush
	rts

setkeyboard:
.wait:
	btst	#1,$fffffc00.w
	beq.s	.wait
	move.b	d0,$FFFFFC02.w
	rts

clear_bss:
	lea	bss_start,a0
.loop:
	clr.l	(a0)+
	cmp.l	#bss_end,a0
	blt.s	.loop
	rts


************************************************
*                                              *
************************************************

fadein
	move.l	#$777,d0
.deg:
	bsr.s	wart
	bsr.s	wart
	bsr.s	wart
	lea	$ffff8240.w,a0
	moveq	#15,d1
.chg1:
	move.w	d0,(a0)+
	dbf	d1,.chg1
	sub.w	#$111,d0
	bne.s	.deg
	clr.w	$ffff8240.w
	rts

wart	
	move.l	d0,-(sp)
	move.l	$466.w,d0
.att:
	cmp.l	$466.w,d0
	beq.s	.att
	move.l	(sp)+,d0
	rts

************************************************
*           TRACE DES LIGNES 1 PLAN            *
************************************************
LINE_PLAN equ 6

* HAUT
HX1 equ 8*4
HY1 equ 8*2
HX2 equ 8*40-HX1
HY2 equ HY1
* BAS
BX1 equ HX1
BY1 equ 190
BX2 equ HX2
BY2 equ BY1
* GAUCHE
GX1 equ HX1
GY1 equ HY1
GX2 equ GX1
GY2 equ BY1
* DROITE
DX1 equ HX2
DY1 equ HY1
DX2 equ DX1
DY2 equ BY1

PUT_LINES:

	JSR	LINE ; Init !
	
	MOVE.L	Zorro_scr1,A0	; haut
	addq.w	#LINE_PLAN,a0
	MOVE	#HX1,D0
	MOVE	#HY1,D1
	MOVE	#HX2,D2
	MOVE	#HY2,D3
	jsr	LINE+78

	MOVE.L	Zorro_scr2,A0
	addq.w	#LINE_PLAN,a0
	MOVE	#HX1,D0
	MOVE	#HY1,D1
	MOVE	#HX2,D2
	MOVE	#HY2,D3
	jsr	LINE+78

	MOVE.L	Zorro_scr1,A0	; bas
	addq.w	#LINE_PLAN,a0
	MOVE	#BX1,D0
	MOVE	#BY1,D1
	MOVE	#BX2,D2
	MOVE	#BY2,D3
	jsr	LINE+78

	MOVE.L	Zorro_scr2,A0
	addq.w	#LINE_PLAN,a0
	MOVE	#BX1,D0
	MOVE	#BY1,D1
	MOVE	#BX2,D2
	MOVE	#BY2,D3
	jsr	LINE+78

	MOVE.L	Zorro_scr1,A0	; gauche
	addq.w	#LINE_PLAN,a0
	MOVE	#GX1,D0
	MOVE	#GY1,D1
	MOVE	#GX2,D2
	MOVE	#GY2,D3
	jsr	LINE+78

	MOVE.L	Zorro_scr2,A0
	addq.w	#LINE_PLAN,a0
	MOVE	#GX1,D0
	MOVE	#GY1,D1
	MOVE	#GX2,D2
	MOVE	#GY2,D3
	jsr	LINE+78

	MOVE.L	Zorro_scr1,A0	; droite
	addq.w	#LINE_PLAN,a0
	MOVE	#DX1,D0
	MOVE	#DY1,D1
	MOVE	#DX2,D2
	MOVE	#DY2,D3
	jsr	LINE+78

	MOVE.L	Zorro_scr2,A0
	addq.w	#LINE_PLAN,a0
	MOVE	#DX1,D0
	MOVE	#DY1,D1
	MOVE	#DX2,D2
	MOVE	#DY2,D3
	jsr	LINE+78
		
	RTS

LINE	INCBIN	"LINE.BIN"
	even
	
************************************************
*              3D AL by Zorro 2                *
*           original code by ArKam             *
************************************************

* precalcul des positions des boules
Precalcul:
 lea.l buffer,a1
 moveq.w #15,d0
.precal:
 lea.l ball,a0
 moveq.w #7,d1
.precal2:
 move.l (a0),(a1)+
 move.l 4(a0),(a1)+
 roxr.w (a0)
 roxr.w 4(a0)
 roxr.w 2(a0) 
 roxr.w 6(a0)
 addq.l #8,a0
 dbf d1,.precal2
 dbf d0,.precal
 rts

Boule3D:
; efface ancienne boules

 movea.l adr_clr2,a0
 move.w #nbre-1,d0
 moveq.l #0,d2
.clr_ball
 movea.l Zorro_scr1,a1
 adda.w (a0)+,a1
n set 0
 rept 8
 move.l d2,n(a1)
 move.l d2,n+8(a1)
n set n+$a0
 endr
 dbf d0,.clr_ball

; echange buffer d'effacement

 move.l adr_clr1,d0
 move.l adr_clr2,adr_clr1
 move.l d0,adr_clr2

; rotation de l'objet

 lea.l object,a0
 lea.l final,a1
 lea.l cosinus,a6
 movea.l adr_clr1,a5
 move.w #nbre-1,d0
rotation
 move.w (a0)+,d1
 move.w (a0)+,d2
 move.w (a0)+,d3

; rotation X

 move.w d2,d4
 move.w d3,d5
 move.w alpha,d6
 muls.w (a6,d6.w),d2
 muls.w 2(a6,d6.w),d3
 add.w d3,d2
 asr.w #7,d2
 muls.w (a6,d6.w),d5
 muls.w 2(a6,d6.w),d4
 sub.w d4,d5
 asr.w #7,d5
 move.w d5,d3

; rotation Y

 move.w d1,d4
 move.w d3,d5
 move.w beta,d6
 muls.w (a6,d6.w),d1
 muls.w 2(a6,d6.w),d3
 add.w d3,d1
 asr.w #7,d1
 muls.w (a6,d6.w),d5
 muls.w 2(a6,d6.w),d4
 sub.w d4,d5
 asr.w #7,d5
 move.w d5,d3

; rotation Z

 move.w d1,d4
 move.w d2,d5
 move.w gamma,d6
 muls.w (a6,d6.w),d1
 muls.w 2(a6,d6.w),d2
 add.w d2,d1
 asr.w #7,d1
 muls.w (a6,d6.w),d5
 muls.w 2(a6,d6.w),d4
 sub.w d4,d5
 asr.w #7,d5
 move.w d5,d2

 addi.w #160,d1
 addi.w #100,d2

 moveq.l #0,d4
 mulu.w #160,d2
 add.w d2,d4
 move.w d1,d2
 lsr.w d2
 andi.w #$ffff-7,d2
 add.w d2,d4
 lsl.w d2
 sub.w d2,d1
 mulu.w #8*8,d1

 move.w d4,(a1)+
 move.w d4,(a5)+
 move.w d1,(a1)+  

 dbf d0,rotation

; affiche un beau carre de 7*7

 lea.l final,a0
 move.w #nbre-1,d0
aff_object
 movea.l Zorro_scr1,a1
 adda.w (a0)+,a1
 lea.l buffer,a2
 adda.w (a0)+,a2
n set 0
 rept 8
 move.l (a2)+,d1
 or.l d1,n(a1)
 move.l (a2)+,d1
 or.l d1,n+8(a1)
n set n+160
 endr

 dbf d0,aff_object

 add.w #4*3,alpha
 cmpi.w #1440,alpha
 blo nofin_alpha
 sub.w #1440,alpha
nofin_alpha

 add.w #4*1,beta
 cmpi.w #1440,beta
 blo nofin_beta
 sub.w #1440,beta
nofin_beta

 add.w #4*1,gamma
 cmpi.w #1440,gamma
 blo nofin_gamma
 sub.w #1440,gamma
nofin_gamma
 rts

************************************************
*   Fade Color 2 plans selon Zorro 2^NoExtra   *
*     avec un tableau indexé de 7 couleurs     *
************************************************

Fade3D:
	move.w	CPT_FADE,D7
	cmp.w	#$400,D7
	bne.s	no_reset ; != $300
	moveq	#0,D7
	move.w	D7,CPT_FADE
no_reset:

	move.w	INDEX,D7
	cmp.w	#8*8,D7
	bne.s	no_init_index
	moveq	#0,D7
	move.w	D7,INDEX
no_init_index:

	add.w	#1,CPT_FADE

	cmp.w	#$190,CPT_FADE
	bgt.s	no_fad0 ; > $190
	bra.s	suit0
no_fad0:	

	cmp.w	#$198,CPT_FADE
	blt.s	no_fad1 ; < $198
	bra.s	suit0
no_fad1:
	bsr	FADEBLACK

suit0:
	cmp.w	#$199,CPT_FADE
	beq.s	index_p_1 ; = $199
	bra.s	suit1
index_p_1:
	move.w	INDEX,D7
	addq.w	#8,D7
	move.w	D7,INDEX
	
suit1:
	cmp.w	#$200,CPT_FADE
	bgt.s	no_fad2 ; > $200
	bra.s	suit2
no_fad2:

	cmp.w	#$210,CPT_FADE
	blt.s	no_fad3 ; < $210
	bra.s	suit2
no_fad3:

	bsr	FADECOLOR

suit2:
	rts
	
************************************************
*               Scrolling H-Y                  *
************************************************
LIGNE_EN_MOINS equ 11
PLAN_SCROLL equ 4
LIGNE_SCROLL equ 49-36+1
POS_SCROLL equ ((160*LIGNE_SCROLL)+PLAN_SCROLL)+8*2
POS_SCROLL_EFF equ ((160*(LIGNE_SCROLL-LIGNE_EN_MOINS))+PLAN_SCROLL)

SCROL8Y:MOVEA.L   PTR_COURBE(PC),A0
      MOVE.W    (A0)+,D0
      TST.W     (A0)
      BPL.S     .next 
      LEA       COURBE(PC),A0
.next:MOVE.L    A0,PTR_COURBE
      MULU      #160,D0 
      BSR       SCROLLIT 
      BSR       SCROLLIT ; twice pleaze !
      LEA       BUFFER,A0

      MOVEA.L   Zorro_scr1,A1
      LEA       POS_SCROLL_EFF(A1),A1
      ADDA.L    D0,A1
      MOVEQ			#0,D1
      MOVEQ			#LIGNE_EN_MOINS,D6
i SET 0
.clean		
      REPT 160/4
      MOVE.W D1,i(A1)
i SET i+8
      ENDR
      LEA (160/4*8)(A1),A1
      DBF D6,.clean
     
      MOVEA.L   Zorro_scr1,A1
      LEA       POS_SCROLL(A1),A1
      ADDA.L    D0,A1 
      MOVE.W    #10,D0
.loop:MOVE.W    0(A0),0(A1) 
      MOVE.W    8(A0),8(A1) 
      MOVE.W    16(A0),16(A1) 
      MOVE.W    24(A0),24(A1) 
      MOVE.W    32(A0),32(A1) 
      MOVE.W    40(A0),40(A1) 
      MOVE.W    48(A0),48(A1) 
      MOVE.W    56(A0),56(A1) 
      MOVE.W    64(A0),64(A1) 
      MOVE.W    72(A0),72(A1) 
      MOVE.W    80(A0),80(A1) 
      MOVE.W    88(A0),88(A1) 
      MOVE.W    96(A0),96(A1) 
      MOVE.W    104(A0),104(A1) 
      MOVE.W    112(A0),112(A1) 
      MOVE.W    120(A0),120(A1) 
      LEA       160(A0),A0
      LEA       160(A1),A1
      DBF       D0,.loop
      RTS 
      
SCROLLIT:TST.W     MAX_CARAC 
      BNE.S     can_rol 
      MOVEA.L   PTR_TEXT(PC),A0
      MOVE.B    (A0)+,D1
      BNE.S     .text
      MOVE.L    #TEXT,PTR_TEXT
      BRA.S     SCROLLIT 
.text:MOVE.L    A0,PTR_TEXT
      LEA       FONT(PC),A0
      LEA       BUFCAR,A1
      ANDI.L    #$FF,D1 
      SUB.L     #32,D1 
      BEQ.S     .next 
      DIVU      #20,D1 
      MOVE.W    D1,POS
      SWAP      D1
      EXT.L     D1
      LSL.L     #3,D1 
      ADDA.L    D1,A0 
      MOVE.W    POS(PC),D1
      MULU      #$A00,D1
      ADDA.L    D1,A0 
.next:MOVE.W    #6,D1 
.loop:MOVE.L    (A0)+,(A1)+ 
      MOVE.L    (A0)+,(A1)+ 
      ADDA.L    #152,A0 
      DBF       D1,.loop
      MOVE.W    #9,MAX_CARAC
can_rol:SUBQ.W    #1,MAX_CARAC
      LEA       BUFCAR,A1
      LEA       BUFFER,A0
      ADDA.L    #160*2,A0
      MOVE.W    #6,D1 
.roxl:MOVE      #0,CCR
      ROXL      (A1)+ 
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
      ROXL      (A0)+ 
      ADDQ.L    #6,A0 
      ADDQ.L    #6,A1 
      LEA       152(A0),A0
      DBF       D1,.roxl
      RTS 

; Supprime la bavure du scrolling en bas sur 2 lignes
CLS_LIGNE:
	MOVEM.L   D0-D1,-(A7)
	movea.l Zorro_scr1,a0
	lea	((160*183)+4)(a0),a0
	moveq #$0,d1
	move.w	d1,152(A0) 
	move.w	d1,144(A0) 
	move.w	d1,136(A0) 
	move.w	d1,128(A0) 
	move.w	d1,120(A0) 
	move.w	d1,112(A0) 
	move.w	d1,104(A0) 
	move.w	d1,96(A0)
	move.w	d1,88(A0)
	move.w	d1,80(A0)
	move.w	d1,72(A0)
	move.w	d1,64(A0)
	move.w	d1,56(A0)
	move.w	d1,48(A0)
	move.w	d1,40(A0)
	move.w	d1,32(A0)
	move.w	d1,24(A0)
	move.w	d1,16(A0)
	move.w	d1,8(A0) 
	move.w	d1,(A0)
	lea.l 160(a0),a0
	move.w	d1,152(A0) 
	move.w	d1,144(A0) 
	move.w	d1,136(A0) 
	move.w	d1,128(A0) 
	move.w	d1,120(A0) 
	move.w	d1,112(A0) 
	move.w	d1,104(A0) 
	move.w	d1,96(A0)
	move.w	d1,88(A0)
	move.w	d1,80(A0)
	move.w	d1,72(A0)
	move.w	d1,64(A0)
	move.w	d1,56(A0)
	move.w	d1,48(A0)
	move.w	d1,40(A0)
	move.w	d1,32(A0)
	move.w	d1,24(A0)
	move.w	d1,16(A0)
	move.w	d1,8(A0) 
	move.w	d1,(A0)
	MOVEM.L   (A7)+,D0-D1
	RTS 

************************************************
*              Fade in/out color               *
*          modified by Zorro 2 for AL          *
************************************************
; couleur -> black
FADEBLACK:
      MOVEM.L   A0/D0-D3,-(A7)
      MOVEQ     #2,D3 
      LEA       $ffff8242.w,A0
loopRGB: 
      MOVE.W    (A0),D0 
      ANDI.W    #$777,D0
      MOVE.W    D0,D1 
      MOVE.W    D0,D2 
      ANDI.W    #$F00,D0
      ANDI.W    #$F0,D1 
      ANDI.W    #$F,D2
      SUBI.W    #$100,D0
      BPL.S     lR 
      MOVEQ     #0,D0 
lR:   SUBI.W    #$10,D1 
      BPL.S     lG 
      MOVEQ     #0,D1 
lG:   SUBQ.W    #1,D2 
      BPL.S     lB 
      MOVEQ     #0,D2 
lB:   ADD.W     D1,D0 
      ADD.W     D2,D0 
      MOVE.W    D0,(A0)+
      DBF       D3,loopRGB
      MOVEM.L   (A7)+,A0/D0-D3
      RTS 

; black -> couleur      
FADECOLOR:
      MOVEM.L   A0-A1/D0-D3,-(A7) 
      MOVEQ     #2,D3 
      LEA       $FFFF8242.W,A0
      MOVE.W    INDEX,D0
      LEA       TABLEAU(PC),A2 ; Met couleur des sprites 8242.w et 8244.w
      LEA       0(A2,D0.W),A1       
loopRVB:
      MOVE.W    (A1)+,D0
      ANDI.W    #$777,D0
      MOVE.W    D0,D1 
      MOVE.W    D0,D2 
      ANDI.W    #$F00,D0
      ANDI.W    #$F0,D1 
      ANDI.W    #$F,D2
      MOVE.W    D0,llR
      MOVE.W    D1,llV
      MOVE.W    D2,llB
      MOVE.W    (A0),D0 
      ANDI.W    #$777,D0
      MOVE.W    D0,D1 
      MOVE.W    D0,D2 
      ANDI.W    #$F00,D0
      ANDI.W    #$F0,D1 
      ANDI.W    #$F,D2
      CMP.W     #0,D0 
llR   EQU       *-2 
      BEQ.S     .next0 
      ADDI.W    #$100,D0
.next0:CMP.W     #0,D1 
llV   EQU       *-2 
      BEQ.S     .next1 
      ADDI.W    #$10,D1 
.next1:CMP.W     #0,D2 
llB   EQU       *-2 
      BEQ.S     .next2 
      ADDQ.W    #1,D2 
.next2:ADD.W     D1,D0 
      ADD.W     D2,D0 
      MOVE.W    D0,(A0)+
      DBF       D3,loopRVB
      MOVEM.L   (A7)+,A0-A1/D0-D3 
      RTS 

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
					
******************************************************************
	SECTION	DATA
******************************************************************

Pal:	
	dc.w	$0000,$0fff,$0fff,$0fff,$0fff,$0fff,$0fff,$0fff
	dc.w	$0BBB,$0333,$0AAA,$0111,$0222,$0888,$0999,$0fff

TABLEAU:	; tableau indexé des couleurs
	dc.w	$0303,$0505,$0767,$0	; 0
	dc.w	$0033,$0055,$0677,$0	; 1
	dc.w	$0330,$0550,$0776,$0	; 2
	dc.w	$0300,$0500,$0700,$0	; 3
	dc.w	$0037,$0057,$0077,$0	; 4
	dc.w	$0030,$0050,$0070,$0	; 5
	dc.w	$0003,$0005,$0007,$0	; 6
	dc.w	$0303,$0515,$0737,$0	; 7

INDEX:
	DC.W	$0 
CPT_FADE:
	dc.w	$0

* Full data here :
* >
adr_clr1 even
 dc.l clr_buf

adr_clr2 even
 dc.l clr_buf2

clr_buf even
 ds.w 400

clr_buf2 even
 ds.w 400

nbre equ 60

object even

.A:
	dc.w	-27,33,0	;1
	dc.w	-18,37,0	;1+
	dc.w	-10,40,0	;2

x set -10+4+2
y set 40-4-2
 rept 7
 dc.w x,y,0
x set x+4-1 
y set y-5-7
 endr
	
	dc.w	5,-40,0		;3
	dc.w	-5,-42,0	;3+
	dc.w	-15,-45,0	;4
	dc.w	-17,-37,0	;4+
	dc.w	-20,-30,0	;5
	dc.w	-27,-30,0	;5+
	dc.w	-35,-30,0	;6
	dc.w	-40,-37,0	;6+
	dc.w	-45,-43,0	;6+
	dc.w	-50,-50,0	;7
	dc.w	-57-2,-45-2,0	;7+
	dc.w	-64-2,-40-2,0	;7+
	dc.w	-71-2,-35-2,0	;8

x set -71+4-2
y set -35+6
 rept 7
 dc.w x,y,0
x set x+4+2 
y set y+5+4
 endr

.triangle:	
	dc.w	-20,5,0		;9
	dc.w	-20,-5,0	;10
	dc.w	-30+2,-10+2,0	;11

.Ll:	
	dc.w	35,45,0	;12
	dc.w	45,47,0	;12+
	dc.w	55,48,0	;12+
	dc.w	65,50,0	;13

x set 65
y set 50-8
 rept 4
 dc.w x,y,0
x set x+4-5
y set y-8-4
 endr


x set 42-8
y set 50-14
 rept 7
 dc.w x,y,0
x set x-4+4-1 
y set y-5-6-1
 endr
	
	dc.w	65,-5,0;14
	dc.w	77,-7,0;14+
	dc.w	87,-8,0;14+
	dc.w	100,-10,0	;15
	dc.w	97,-18,0	;15+
	dc.w	93,-25,0	;15+
	dc.w	90,-35,0;16
	
x set 90-12+5
y set -35-10
 rept 5
 dc.w x,y,0
x set x-11
y set y+2
 endr
	
final even
 ds.w 400

alpha even
 dc.w 0

beta even
 dc.w 0

gamma even
 dc.w 0

cosinus even
 incbin "cosinus.dat"
ball even
	dc.w	$0800,$3000,$0000,$0000,$5C00,$3800,$0000,$0000
	dc.w	$EA00,$1C00,$0000,$0000,$F200,$0C00,$0000,$0000
	dc.w	$9E00,$6000,$0000,$0000,$2C00,$7000,$0000,$0000
	dc.w	$0800,$3000,$0000,$0000
	ds.l	5000

PTR_TEXT:
	DC.L	TEXT 
TEXT:
	DC.B	'ABCDEFGHIJKLMNOPQRSTUVWXYZ '
	DC.B	'0123456789 .,!?-:()        ',$27
	DC.W	$FF00
POS:
	DCB.W	2,$0 
MAX_CARAC:
	DC.W	$0
PTR_COURBE:
	dc.l	COURBE
COURBE:
	dc.w	$0000,$0000,$0000,$0001
	dc.w	$0001,$0002,$0002,$0003
	dc.w	$0004,$0005,$0006,$0007
	dc.w	$0008,$0009,$000A,$000C
	dc.w	$000E,$0010,$0012,$0014
	dc.w	$0016,$0018,$001A,$001C
	dc.w	$001E,$0020,$0022,$0024
	dc.w	$0026,$0028,$002A,$002C
	dc.w	$002E,$0030,$0032,$0034
	dc.w	$0036,$0038,$003A,$003C
	dc.w	$003E,$0040,$0042,$0044
	dc.w	$0046,$0048,$004A,$004C
	dc.w	$004E,$0050,$0052,$0054
	dc.w	$0056,$0058,$005A,$005C
	dc.w	$005E,$0060,$0062,$0064
	dc.w	$0066,$0068,$006A,$006C
	dc.w	$006E,$0070,$0072,$0074
	dc.w	$0076,$0078,$007A,$007C
	dc.w	$007E,$0080,$0082,$0084
	dc.w	$0086

nb_repete equ 12
i set $0088
	rept nb_repete
	dc.w	i
i set i+2	
	endr
	dc.w	i+2
j set i-2	
	rept nb_repete
	dc.w	j
j set j-2	
	endr

	dc.w	$0086,$0084
	dc.w	$0082,$0080,$007E,$007C
	dc.w	$007A,$0078,$0076,$0074
	dc.w	$0072,$0070,$006E,$006C
	dc.w	$006A,$0068,$0066,$0064
	dc.w	$0062,$0060,$005E,$005C
	dc.w	$005A,$0058,$0056,$0054
	dc.w	$0052,$0050,$004E,$004C
	dc.w	$004A,$0048,$0046,$0044
	dc.w	$0042,$0040,$003E,$003C
	dc.w	$003A,$0038,$0036,$0034
	dc.w	$0032,$0030,$002E,$002C
	dc.w	$002A,$0028,$0026,$0024
	dc.w	$0022,$0020,$001E,$001C
	dc.w	$001A,$0018,$0016,$0014
	dc.w	$0012,$0010,$000E,$000C
	dc.w	$000A,$0009,$0008,$0007
	dc.w	$0006,$0005,$0004,$0003
	dc.w	$0002,$0002,$0001,$0001
	dc.w	$0000,$0000,$0000,$FFFF
FONT:
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$7000,$0000,$0000,$0000
	dc.w	$6600,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$3000,$0000,$0000,$0000
	dc.w	$1E00,$0000,$0000,$0000
	dc.w	$F000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$7C00,$0000,$0000,$0000
	dc.w	$7000,$0000,$0000,$0000
	dc.w	$7C00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$7000,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$3000,$0000,$0000,$0000
	dc.w	$3E00,$0000,$0000,$0000
	dc.w	$F800,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$F000,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$7000,$0000,$0000,$0000
	dc.w	$CC00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$6000,$0000,$0000,$0000
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0E00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$7000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$6000,$0000,$0000,$0000
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$C600,$0000,$0000,$0000
	dc.w	$7000,$0000,$0000,$0000
	dc.w	$1C00,$0000,$0000,$0000
	dc.w	$1C00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$E600,$0000,$0000,$0000
	dc.w	$7000,$0000,$0000,$0000
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$0E00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$7000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$3E00,$0000,$0000,$0000
	dc.w	$F800,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$1800,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$1800,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$FE01,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$7E00,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$7000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$1E00,$0000,$0000,$0000
	dc.w	$F000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$3000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$1800,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$7C01,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0E00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$7E00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$7C00,$0000,$0000,$0000
	dc.w	$7C00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$7C00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$7C00,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$7E00,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$7E00,$0000,$0000,$0000
	dc.w	$1E00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$0600,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0600,$0000,$0000,$0000
	dc.w	$8600,$0000,$0000,$0000
	dc.w	$1800,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0E00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0600,$0000,$0000,$0000
	dc.w	$0E00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0600,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$6600,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$7C00,$0000,$0000,$0000
	dc.w	$7E00,$0000,$0000,$0000
	dc.w	$1800,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$1C00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$C000,$0000,$0000,$0000
	dc.w	$E600,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$7F00,$0000,$0000,$0000
	dc.w	$0E00,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$7000,$0000,$0000,$0000
	dc.w	$C600,$0000,$0000,$0000
	dc.w	$0E00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$3000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$C600,$0000,$0000,$0000
	dc.w	$C000,$0000,$0000,$0000
	dc.w	$E600,$0000,$0000,$0000
	dc.w	$E000,$0000,$0000,$0000
	dc.w	$E000,$0000,$0000,$0000
	dc.w	$E600,$0000,$0000,$0000
	dc.w	$0E00,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$7000,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$1C00,$0000,$0000,$0000
	dc.w	$1800,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$E000,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$0E00,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$7C00,$0000,$0000,$0000
	dc.w	$7000,$0000,$0000,$0000
	dc.w	$7C00,$0000,$0000,$0000
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$1800,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$3000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$7E00,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$E000,$0000,$0000,$0000
	dc.w	$7E00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$7700,$0000,$0000,$0000
	dc.w	$7C00,$0000,$0000,$0000
	dc.w	$0E00,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$E000,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$C600,$0000,$0000,$0000
	dc.w	$7C00,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$7C00,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$7E00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$C600,$0000,$0000,$0000
	dc.w	$C600,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$7700,$0000,$0000,$0000
	dc.w	$7C00,$0000,$0000,$0000
	dc.w	$0E00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$E000,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$E600,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$C600,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$E000,$0000,$0000,$0000
	dc.w	$7E00,$0000,$0000,$0000
	dc.w	$7600,$0000,$0000,$0000
	dc.w	$0E00,$0000,$0000,$0000
	dc.w	$0E00,$0000,$0000,$0000
	dc.w	$0E00,$0000,$0000,$0000
	dc.w	$0E00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$D600,$0000,$0000,$0000
	dc.w	$7C00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$7F00,$0000,$0000,$0000
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$0E00,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$E000,$0000,$0000,$0000
	dc.w	$BE00,$0000,$0000,$0000
	dc.w	$BE00,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$7C00,$0000,$0000,$0000
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$BE00,$0000,$0000,$0000
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$7C00,$0000,$0000,$0000
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$7700,$0000,$0000,$0000
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$D600,$0000,$0000,$0000
	dc.w	$DE00,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$0E00,$0000,$0000,$0000
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$7E00,$0000,$0000,$0000
	dc.w	$7C00,$0000,$0000,$0000
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$7000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$7700,$0000,$0000,$0000
	dc.w	$7C00,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$C600,$0000,$0000,$0000
	dc.w	$CE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$E000,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$7C00,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$7700,$0000,$0000,$0000
	dc.w	$7C00,$0000,$0000,$0000
	dc.w	$7C00,$0000,$0000,$0000
	dc.w	$E600,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$C600,$0000,$0000,$0000
	dc.w	$C600,$0000,$0000,$0000
	dc.w	$7C00,$0000,$0000,$0000
	dc.w	$E000,$0000,$0000,$0000
	dc.w	$7E00,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$FC00,$0000,$0000,$0000
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$7E00,$0000,$0000,$0000
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$EE00,$0000,$0000,$0000
	dc.w	$C600,$0000,$0000,$0000
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000

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

Petit_Logo_NoEx:
		dc.w	$8000,$8000,$8000,$7FFF,$0000,$0000,$1FFF,$FFFF
		dc.w	$0000,$0100,$FF00,$FF00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$5AD7,$3DEF,$0000,$FFFF,$D210,$7A31,$0821,$FFFF
		dc.w	$8700,$CE00,$4900,$FF00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$7FFF,$2528,$0000,$FFFF,$B3D6,$77D6,$0400,$FFFF
		dc.w	$B700,$B600,$0100,$FF00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$7FFF,$252E,$0000,$FFFF,$CFD0,$2FD1,$0001,$FFFF
		dc.w	$8700,$8600,$0100,$FF00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$7FFF,$2528,$0000,$FFFF,$B3D6,$77D6,$0400,$FFFF
		dc.w	$B700,$B600,$0100,$FF00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$7ED7,$25EF,$0000,$FFFF,$D3D6,$7BD6,$0800,$FFFF
		dc.w	$B500,$B400,$0100,$FF00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$8000,$7FFF,$0000,$FFFF,$1FFF,$E000,$1FFF,$FFFF
		dc.w	$FF00,$0000,$FF00,$FF00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
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
						
* <

MUSIC: 		; Not compressed please !
	incbin	*.snd
	even

******************************************************************
	SECTION	BSS
******************************************************************

bss_start:

* Full data here :
* >
BUFFER:
	DS.B	6400
BUFCAR:
	DS.B	100 
	even

* <

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

buffer	ds.l	10000

bss_end:

******************************************************************
	END
******************************************************************
