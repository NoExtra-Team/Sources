****************
* MARTAAU3.PRG *
****************

* // Original code : Zorro 2/Noextra	// *
* // Gfx logo 	   : Mister.A/NoExtra	// *
* // Gfx font      : Magnum		// *
* // Music 	   : Ziggy Startdust	// *
* // Release date  : 06/08/2007		// *
* // Update date  : 10/12/2007		// *

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
BOTTOM_BORDER	equ 0	  ; 0 = I use it and 1 = no need !
* > Allow you to see the screen plan
PATTERN		equ $0 	  ; put $0 to see nothing
			  ; put $010f to see nothing
* > Allow to see the top of the VBL on the screen
SEEMYVBL	equ 1     ; if you press key ALT 
			  ; 0 = see cpu & 1 = see nothing
*****************************************************
gemdos        equ	1
crawcin       equ	7
cconws        equ	9
mshrink       equ	$4a
pexec         equ	$4b
*****************************************************

Start:

	jmp	ON_Y_VA

Emp	DC.B 'Z:\',0
	EVEN

PROG1		DC.B '1.BSW',0
PROG2		DC.B '2.BSW',0
PROG3		DC.B '3.BSW',0
PROG4		DC.B '4.BSW',0
PROG5		DC.B '5.BSW',0
PROG6		DC.B '6.BSW',0
PROG7		DC.B '7.BSW',0
PROG8		DC.B '8.BSW',0
PROG9		DC.B '9.BSW',0
PROGCRC		DC.B 'CRCCHECK.PRG',0
NOMPRG		DS.L	1

errtext:DC.B "PROBLEMS TO LOAD...          ",13,10,10,0
params: DC.B $0    ;AUCUN PARAMŠTRE ET
environ:DC.B $0    ;AUCUN ENVIRONNEMENT
	EVEN

NOTHING_BUT_SPACE:	
	DS.L	100
	
RUN:
	bsr	Restore_st

	move.l	Save_stack,-(sp)
	move.w	#32,-(sp)
	trap	#1
	addq.l	#6,sp
	
EXECUTE:
	move.w	#$19,-(a7)		* Dgetdrive
	trap	#1			* Recup le num‚ro
	addq.w	#2,a7			* du lecteur actif
	and.w	#$f,d0			* 0=A, B=1, etc...
	add.b	#"A",d0			* Additionne la lettre
	move.b	d0,Emp			* et on modifie Emp
					* pour qu'il pointe le bon
					* lecteur
	pea	Emp
	move.w #$3b,-(sp)
	trap #1
	addq.w	#6,a7

	movea.l    4(sp),a5      ;Donner espace m‚moire
	move.l     12(a5),d0     ;Longueur du code
	add.l      20(a5),d0     ;+ Longueur du segment donn‚es
	add.l      28(a5),d0     ;+ Longueur du segment BSS +
	addi.l     #$1100,d0     ;Basepage (256 Bytes)+ pile (4KB)
	move.l     d0,d1         ;Longueur plus
	add.l      a5,d1         ;adresse
	andi.l     #-2,d1        ;(arrondie)
	movea.l    d1,sp         ;donne pointeur pile
					
	move.l     d0,-(sp)      ;Longueur de l'espace m‚moire n‚cessaire
	move.l     a5,-(sp)      ;Adresse de la zone m‚moire
	clr.w      -(sp)         ;octet "dummy" sans importance
	move.w     #mshrink,-(sp)
	trap       #gemdos
	adda.l     #12,sp

	pea        environ       ;Postchargement du programme
	pea        params
	move.l	   NOMPRG,-(SP)
	clr.w      -(sp)         ;Nul -> Charger et lancer imm‚diatement
	move.w     #pexec,-(sp)
	trap       #gemdos
	adda.l     #16,sp
					
	tst.w      d0            ;Erreur?
	bmi.s      error
					
Reset:
	MOVE.L	4.W,A0
	JMP	(A0)

error:
	pea        errtext       ;Affichage du message d'erreur
	move.w     #cconws,-(sp)
	trap       #gemdos
	addq.l     #6,sp
					
	move.w     #crawcin,-(sp)          ;Attendre appui touche...
	trap       #gemdos
	addq.l     #2,sp

	bra.s	FIN						

EXIT:	
	bsr	Restore_st

	move.l	Save_stack,-(sp)
	move.w	#32,-(sp)
	trap	#1
	addq.l	#6,sp
FIN:
	CLR.W     -(A7) 	;PTERM0
	TRAP      #1

	*  FIN  *

ON_Y_VA:
	
	clr.l	-(sp)
	move.w	#32,-(sp)
	trap	#1
	addq.l	#6,sp
	move.l	d0,Save_stack

	bsr	clear_bss
	
	bsr	Init_screens

	bsr	Save_and_init_a_st

; Detournement des bombes
; sur le Reset.
	MOVE.L	#Reset,$8.W
	MOVE.L	#Reset,$C.W
	MOVE.L	#Reset,$10.W
	MOVE.L	#Reset,$14.W
	MOVE.L	#Reset,$18.W
	MOVE.L	#Reset,$1C.W
	MOVE.L	#Reset,$20.W
	MOVE	#$2300,sr

	bsr	fadein

	bsr	Init_screens_P1
	
	bsr	Put_Logo

	bsr	Init_P1

	bsr	delay

	BSR       PREPTXT

	bsr	fadeoff
	
	bsr	Init
	
******************************************************************************


Main_rout:

	bsr	Wait_vbl

	IFEQ	SEEMYVBL
	clr.b	$ffff8240.w
	ENDC


* Put your code here !
* >


	BSR       SCROLLER

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

KEYBOARD:
* -->
	cmpi.b	#$3B,$FFFFFC02.w	*	F1
	beq.s	Run1
	cmpi.b	#$3C,$FFFFFC02.w	*	F2
	beq.s	Run2
	cmpi.b	#$3D,$FFFFFC02.w	*	F3
	beq.s	Run3
	cmpi.b	#$3E,$FFFFFC02.w	*	F4
	beq.s	Run4
	cmpi.b	#$3F,$FFFFFC02.w	*	F5
	beq.s	Run5
	cmpi.b	#$40,$FFFFFC02.w	*	F6
	beq.s	Run6
	cmpi.b	#$41,$FFFFFC02.w	*	F7
	beq	Run7
	cmpi.b	#$42,$FFFFFC02.w	*	F8
	beq	Run8
	cmpi.b	#$43,$FFFFFC02.w	*	F9
	beq	Run9
	cmpi.b	#$39,$FFFFFC02.w	*	ESP
	beq	RunCrc
	cmpi.b	#$01,$fffffc02.w	* ESC
	beq	EXIT
* <--

	bne	Main_rout

******************************************************************************

Run1:
	move.l	#PROG1,NOMPRG
	bra	RUN
Run2:
	move.l	#PROG2,NOMPRG
	bra	RUN
Run3:
	move.l	#PROG3,NOMPRG
	bra	RUN
Run4:
	move.l	#PROG4,NOMPRG
	bra	RUN
Run5:
	move.l	#PROG5,NOMPRG
	bra	RUN
Run6:
	move.l	#PROG6,NOMPRG
	bra	RUN
Run7:
	move.l	#PROG7,NOMPRG
	bra	RUN
Run8:
	move.l	#PROG8,NOMPRG
	bra	RUN
Run9:
	move.l	#PROG9,NOMPRG
	bra	RUN
RunCrc:
	move.l	#PROGCRC,NOMPRG
	bra	RUN

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
	
Vbl:	movem.l	d0-d7/a0-a5,-(a7)

	st	Vsync

	IFEQ	BOTTOM_BORDER
      LEA       SPACE,A1
      LEA       (A1),A6 
      CMPI.L    #COLOR2,PTR_COLOR
      BLT       .continu 
      MOVE.L    #COLOR,PTR_COLOR
.continu:MOVEA.L   PTR_COLOR,A0
      CMPI.W    #$10,NB_TUBE
      BLE       .display 
      CLR.W     NB_TUBE 
      ADDI.L    #$1C,PTR_COLOR
.display:ADDQ.W    #1,NB_TUBE
      MOVEA.L   PTR_COURBE,A2
      
      MOVE.L    #$F9,D7 
      LEA       (A1),A3 
.loop:CLR.W     (A3)+ 
      DBF       D7,.loop
          
      MOVEQ     #$F,D7
      LEA       (A0),A3 
.remplir:LEA       (A1),A4 
      MOVE.L    (A2),D6 
      sub.l	#40,d6	* centrage des rasters !
      LEA       12(A2),A2 
      LSL.L     #1,D6 
      ADDA.W    D6,A4 
      MOVE.W    (A3)+,(A4)+ 
      MOVE.W    (A3)+,(A4)+ 
      MOVE.W    (A3)+,(A4)+ 
      MOVE.W    (A3)+,(A4)+ 
      MOVE.W    (A3)+,(A4)+ 
      MOVE.W    (A3)+,(A4)+ 
      MOVE.W    (A3)+,(A4)+ 
      MOVE.W    (A3)+,(A4)+ 
      MOVE.W    (A3)+,(A4)+ 
      MOVE.W    (A3)+,(A4)+ 
      MOVE.W    (A3)+,(A4)+ 
      MOVE.W    (A3)+,(A4)+ 
      MOVE.W    (A3)+,(A4)+ 
      MOVE.W    (A3)+,(A4)+ 
      DBF       D7,.remplir

      ADDQ.L    #4,PTR_COURBE
      CMPI.L    #COURBE2,PTR_COURBE
      BLE       .end 
      MOVE.L    #COURBE,PTR_COURBE
.end:
	ENDC

	jsr 	(MUSIC+8)			; call music

	movem.l	(a7)+,d0-d7/a0-a5
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

	IFEQ	BOTTOM_BORDER
	MOVE      #$2700,SR 
	MOVE.L    #HBL,$120.W 
	MOVE.B    #1,$FFFFFA07.W
	MOVE.B    #1,$FFFFFA13.W
	CLR.B     $FFFFFA09.W 
	CLR.B     $FFFFFA15.W 
	ANDI.B    #$F7,$FFFFFA17.W
	MOVE.B    #1,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W
	MOVE      #$2300,SR 
	ENDC

	movea.l	Zorro_scr2,a6
	move.w	#Zorro_screen2_len/4-1,d1
.fill:
	move.l	#PATTERN,(a6)+
	dbra	d1,.fill

ok equ 7999-4900-60

	movea.l	Zorro_scr2,a0
	lea	DECALH(a0),a0
	move.l	#Logo_Maartau,a1
	move.l	#ok,d0
.cpy:
	move.l	(a1)+,(a0)+
	dbf	d0,.cpy
		
	move.l	Zorro_scr1,d0
	move.b	d0,d1
	lsr.w	#8,d0
	move.b	d0,$ffff8203.w
	swap	d0
	move.b	d0,$ffff8201.w
	move.b	d1,$ffff820d.w

	lea	Vbl(pc),a0
	move.l	a0,$70.w

	lea	Pal_Maartau,a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

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
			
	bsr	hide_mouse

	bsr	flush
	move.b	#$12,d0
	bsr	setkeyboard
		
	rts

	IFEQ	BOTTOM_BORDER
***************************************************************
*                                                             *
***************************************************************

HBL:
	MOVE.W    (A6)+,$FFFF8240.W 
	bclr.b	#0,$fffa0f	;Timer B on again
	RTE 
      	
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

	MOVEA.L   $44E.W,A0 
	MOVE.W    #8000-1,D0 
.cls:
 CLR.L     (A0)+ 
  DBF       D0,.cls
	rts

************************************************
*                                              *
************************************************

Init_screens:	movem.l	d0-d7/a0-a6,-(a7)

	move.l	#Zorro_scr1,d0
	add.w	#$ff,d0
	sf	d0
	move.l	d0,Zorro_scr1

	move.l	#Zorro_scr2,d0
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

DECALH	equ	64*160

Put_Logo:
	movem.l	d0-d7/a0-a6,-(a7)
	
	movea.l	Zorro_scr1,a0
	lea	DECALH(a0),a0
	move.l	#Logo_Maartau,a1
	move.l	#ok,d0
.cpy:
	move.l	(a1)+,(a0)+
	dbf	d0,.cpy
	
	movem.l	(a7)+,d0-d7/a0-a6
	rts

Init_P1:	movem.l	d0-d7/a0-a6,-(a7)

	jsr	MUSIC+0			; init music

	lea	Vbl0(pc),a0
	move.l	a0,$70.w

	movem.l	(a7)+,d0-d7/a0-a6
	rts

Init_screens_P1:
	movem.l	d0-d7/a0-a6,-(a7)

	movea.l	Zorro_scr2,a1
	adda.l	#160*90,a1
	movea.l	#LogoNoeXtra,a0
	move.l	#7999-7070-10,d0
aff:	move.l	(a0)+,(a1)+
	dbf	d0,aff

	move.l	Zorro_scr2,d0
	move.b	d0,d1
	lsr.w	#8,d0
	move.b	d0,$ffff8203.w
	swap	d0
	move.b	d0,$ffff8201.w
	move.b	d1,$ffff820d.w

	lea	PalNoeXtra,a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)
	
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
  MOVE.W     #$09F/2,D0 
.synch:
	BSR       Wait_vbl
	sub.w	#$001,d0
	cmp.w	#$000,d0	
	bne.s	.synch
	rts	
	
************************************************
*                GRAND SCROLLING Y             *
*              16*16 1 PLAN SCROLLER           *
*                  ATOMUS/NOEXTRA              *
************************************************
POS_SCROLLING	equ	(160*0)+6

PREPTXT:          LEA       CODING,A0 
                  LEA       NEWASKY,A1
                  LEA       RAP,A2
                  MOVEQ     #0,D0 
                  MOVEQ     #0,D1 
.loop0:           MOVE.B    (A0)+,D0
                  MOVE.B    D1,0(A1,D0.W) 
                  ADDQ.L    #1,D1 
                  CMPA.L    A2,A0 
                  BLT.S     .loop0 
                  MOVE.L    #FNTBUF1,FNTPTR1
                  MOVE.L    #FNTBUF2,FNTPTR2
                  MOVE.L    #RAP,TXTPTR 
                  MOVE.L    #$80000,LETADR
                  MOVE.L    #WAVE,WAVPTR
                  RTS 
SCROLLER:         MOVE.W    TXTPHASE,D0 
                  BEQ       PHASE0
                  CMP.W     #2,D0 
                  BLT       PHASE1
                  BEQ       PHASE2
                  MOVE.W    #0,TXTPHASE 
                  MOVEA.L   LETADR,A0 
                  MOVEA.L   FNTPTR1,A1
                  MOVE.L    (A0)+,(A1)+ 
                  MOVE.L    (A0)+,(A1)+ 
                  MOVE.L    (A0)+,(A1)+ 
                  MOVE.L    (A0)+,(A1)+ 
                  MOVE.L    (A0)+,(A1)+ 
                  MOVE.L    (A0)+,(A1)+ 
                  MOVE.L    (A0)+,(A1)+ 
                  MOVE.L    (A0)+,(A1)+ 
                  CMPA.L    #FNTBUF2,A1 
                  BLT.S     .next0 
                  LEA       FNTBUF1,A1
.next0:            MOVE.L    A1,FNTPTR1
                  LEA       FNTBUF1,A0
                  LEA       FNTBUF2,A2
                  BSR       SCROLL
                  RTS 
PHASE1:           MOVE.W    #2,TXTPHASE 
                  MOVEA.L   LETADR,A0 
                  MOVEA.L   FNTPTR1,A1
                  MOVE.L    (A0)+,(A1)+ 
                  MOVE.L    (A0)+,(A1)+ 
                  MOVE.L    (A0)+,(A1)+ 
                  MOVE.L    (A0)+,(A1)+ 
                  MOVE.L    (A0)+,(A1)+ 
                  MOVE.L    (A0)+,(A1)+ 
                  MOVE.L    (A0)+,(A1)+ 
                  MOVE.L    (A0)+,(A1)+ 
                  CMPA.L    #FNTBUF2,A1 
                  BLT.S     .next0 
                  LEA       FNTBUF1,A1
.next0:           MOVE.L    A1,FNTPTR1
                  LEA       FNTBUF1,A0
                  LEA       FNTBUF2,A2
                  BSR       SCROLL
                  RTS 
PHASE2:           MOVE.W    #3,TXTPHASE 
                  MOVEA.L   LETADR,A0 
                  LEA       32(A0),A2 
                  MOVE.L    A2,LETADR 
                  ADDQ.L    #1,A0 
                  MOVEA.L   FNTPTR2,A1
                  MOVE.B    0(A0),(A1)+ 
                  MOVE.B    0(A2),(A1)+ 
                  MOVE.B    2(A0),(A1)+ 
                  MOVE.B    2(A2),(A1)+ 
                  MOVE.B    4(A0),(A1)+ 
                  MOVE.B    4(A2),(A1)+ 
                  MOVE.B    6(A0),(A1)+ 
                  MOVE.B    6(A2),(A1)+ 
                  MOVE.B    8(A0),(A1)+ 
                  MOVE.B    8(A2),(A1)+ 
                  MOVE.B    10(A0),(A1)+
                  MOVE.B    10(A2),(A1)+
                  MOVE.B    12(A0),(A1)+
                  MOVE.B    12(A2),(A1)+
                  MOVE.B    14(A0),(A1)+
                  MOVE.B    14(A2),(A1)+
                  MOVE.B    16(A0),(A1)+
                  MOVE.B    16(A2),(A1)+
                  MOVE.B    18(A0),(A1)+
                  MOVE.B    18(A2),(A1)+
                  MOVE.B    20(A0),(A1)+
                  MOVE.B    20(A2),(A1)+
                  MOVE.B    22(A0),(A1)+
                  MOVE.B    22(A2),(A1)+
                  MOVE.B    24(A0),(A1)+
                  MOVE.B    24(A2),(A1)+
                  MOVE.B    26(A0),(A1)+
                  MOVE.B    26(A2),(A1)+
                  MOVE.B    28(A0),(A1)+
                  MOVE.B    28(A2),(A1)+
                  MOVE.B    30(A0),(A1)+
                  MOVE.B    30(A2),(A1)+
                  CMPA.L    #FNTEND2,A1 
                  BLT.S     .next0 
                  LEA       FNTBUF2,A1
.next0:           MOVE.L    A1,FNTPTR2
                  LEA       FNTBUF2,A0
                  LEA       FNTEND2,A2
                  BSR       SCROLL
                  RTS

PHASE0:           MOVEA.L   TXTPTR,A0 
                  ADDQ.L    #1,A0 
                  TST.B     (A0)
                  BNE.S     .next0 
                  LEA       RAP,A0
.next0:            MOVE.L    A0,TXTPTR 
                  MOVEQ     #0,D0 
                  MOVE.B    (A0),D0 
                  LEA       NEWASKY,A0
                  MOVE.B    0(A0,D0.W),D0 
                  LSL.W     #6,D0 
                  LEA       FONT,A0 
                  ADDA.W    D0,A0 
                  MOVEA.L   LETADR,A2 
                  ADDQ.L    #1,A2 
                  MOVE.L    A0,LETADR 
                  MOVE.W    #1,TXTPHASE 
                  MOVEA.L   FNTPTR2,A1
                  MOVE.B    0(A2),(A1)+ 
                  MOVE.B    0(A0),(A1)+ 
                  MOVE.B    2(A2),(A1)+ 
                  MOVE.B    2(A0),(A1)+ 
                  MOVE.B    4(A2),(A1)+ 
                  MOVE.B    4(A0),(A1)+ 
                  MOVE.B    6(A2),(A1)+ 
                  MOVE.B    6(A0),(A1)+ 
                  MOVE.B    8(A2),(A1)+ 
                  MOVE.B    8(A0),(A1)+ 
                  MOVE.B    10(A2),(A1)+
                  MOVE.B    10(A0),(A1)+
                  MOVE.B    12(A2),(A1)+
                  MOVE.B    12(A0),(A1)+
                  MOVE.B    14(A2),(A1)+
                  MOVE.B    14(A0),(A1)+
                  MOVE.B    16(A2),(A1)+
                  MOVE.B    16(A0),(A1)+
                  MOVE.B    18(A2),(A1)+
                  MOVE.B    18(A0),(A1)+
                  MOVE.B    20(A2),(A1)+
                  MOVE.B    20(A0),(A1)+
                  MOVE.B    22(A2),(A1)+
                  MOVE.B    22(A0),(A1)+
                  MOVE.B    24(A2),(A1)+
                  MOVE.B    24(A0),(A1)+
                  MOVE.B    26(A2),(A1)+
                  MOVE.B    26(A0),(A1)+
                  MOVE.B    28(A2),(A1)+
                  MOVE.B    28(A0),(A1)+
                  MOVE.B    30(A2),(A1)+
                  MOVE.B    30(A0),(A1)+
                  CMPA.L    #FNTEND2,A1 
                  BLT.S     .next1 
                  LEA       FNTBUF2,A1
.next1:           MOVE.L    A1,FNTPTR2
                  LEA       FNTBUF2,A0
                  LEA       FNTEND2,A2
                  BSR       SCROLL
                  RTS

SCROLL:
                  MOVE.L	A6,-(SP)
	                MOVEA.L   WAVPTR,A5 
                  ADDQ.L    #2,A5 
                  TST.W     40(A5)
                  BNE.S     .next0 
                  LEA       WAVE,A5 
.next0:           MOVE.L    A5,WAVPTR 
                  MOVEA.L   A1,A4 
                  MOVEA.L   Zorro_scr1,A6 
                  lea	POS_SCROLLING(a6),a6
                  MOVEQ     #0,D0 
.next1:           MOVEA.L   A6,A3 
                  ADDA.W    (A5)+,A3
                  MOVE.W    D0,-640(A3) 
                  MOVE.W    D0,-480(A3) 
                  MOVE.W    D0,-320(A3) 
                  MOVE.W    D0,-160(A3) 
                  MOVE.W    (A1)+,(A3)
                  MOVE.W    (A1)+,160(A3) 
                  MOVE.W    (A1)+,320(A3) 
                  MOVE.W    (A1)+,480(A3) 
                  MOVE.W    (A1)+,640(A3) 
                  MOVE.W    (A1)+,800(A3) 
                  MOVE.W    (A1)+,960(A3) 
                  MOVE.W    (A1)+,1120(A3)
                  MOVE.W    (A1)+,1280(A3)
                  MOVE.W    (A1)+,1440(A3)
                  MOVE.W    (A1)+,1600(A3)
                  MOVE.W    (A1)+,1760(A3)
                  MOVE.W    (A1)+,1920(A3)
                  MOVE.W    (A1)+,2080(A3)
                  MOVE.W    (A1)+,2240(A3)
                  MOVE.W    (A1)+,2400(A3)
                  MOVE.W    D0,2560(A3) 
                  MOVE.W    D0,2720(A3) 
                  MOVE.W    D0,2880(A3) 
                  MOVE.W    D0,3040(A3) 
                  ADDQ.L    #8,A6 
                  CMPA.L    A2,A1 
                  BLT       .next1 
.loop1:           CMPA.L    A4,A0 
                  BGE       .rts 
                  MOVEA.L   A6,A3 
                  ADDA.W    (A5)+,A3
                  MOVE.W    D0,-640(A3) 
                  MOVE.W    D0,-480(A3) 
                  MOVE.W    D0,-320(A3) 
                  MOVE.W    D0,-160(A3) 
                  MOVE.W    (A0)+,(A3)
                  MOVE.W    (A0)+,160(A3) 
                  MOVE.W    (A0)+,320(A3) 
                  MOVE.W    (A0)+,480(A3) 
                  MOVE.W    (A0)+,640(A3) 
                  MOVE.W    (A0)+,800(A3) 
                  MOVE.W    (A0)+,960(A3) 
                  MOVE.W    (A0)+,1120(A3)
                  MOVE.W    (A0)+,1280(A3)
                  MOVE.W    (A0)+,1440(A3)
                  MOVE.W    (A0)+,1600(A3)
                  MOVE.W    (A0)+,1760(A3)
                  MOVE.W    (A0)+,1920(A3)
                  MOVE.W    (A0)+,2080(A3)
                  MOVE.W    (A0)+,2240(A3)
                  MOVE.W    (A0)+,2400(A3)
                  MOVE.W    D0,2560(A3) 
                  MOVE.W    D0,2720(A3) 
                  MOVE.W    D0,2880(A3) 
                  MOVE.W    D0,3040(A3) 
                  ADDQ.L    #8,A6 
                  BRA       .loop1 
.rts:             MOVE.L	(SP)+,A6
                  RTS 
	
			
******************************************************************
	SECTION	DATA
******************************************************************

Pal:	
	dc.w    $0000,$0FFF,$0111,$0999,$0222,$0AAA,$0333,$0BBB
	dc.w    $0444,$0CCC,$0555,$0DDD,$0666,$0EEE,$0888,$0777

* Full data here :
* >
**
PTR_COURBE:
	dc.l	COURBE
COURBE:
	dc.w	$0000,$0082,$0000,$0084
	dc.w	$0000,$0087,$0000,$008A
	dc.w	$0000,$008D,$0000,$0090
	dc.w	$0000,$0093,$0000,$0096
	dc.w	$0000,$0099,$0000,$009B
	dc.w	$0000,$009E,$0000,$00A0
	dc.w	$0000,$00A2,$0000,$00A5
	dc.w	$0000,$00A7,$0000,$00A9
	dc.w	$0000,$00AA,$0000,$00AC
	dc.w	$0000,$00AE,$0000,$00AF
	dc.w	$0000,$00B0,$0000,$00B1
	dc.w	$0000,$00B2,$0000,$00B3
	dc.w	$0000,$00B3,$0000,$00B3
	dc.w	$0000,$00B3,$0000,$00B3
	dc.w	$0000,$00B3,$0000,$00B3
	dc.w	$0000,$00B2,$0000,$00B1
	dc.w	$0000,$00B0,$0000,$00AF
	dc.w	$0000,$00AE,$0000,$00AD
	dc.w	$0000,$00AB,$0000,$00A9
	dc.w	$0000,$00A7,$0000,$00A5
	dc.w	$0000,$00A3,$0000,$00A1
	dc.w	$0000,$009F,$0000,$009C
	dc.w	$0000,$009A,$0000,$0097
	dc.w	$0000,$0094,$0000,$0091
	dc.w	$0000,$008E,$0000,$008C
	dc.w	$0000,$0089,$0000,$0086
	dc.w	$0000,$0083,$0000,$0080
	dc.w	$0000,$007D,$0000,$007A
	dc.w	$0000,$0077,$0000,$0074
	dc.w	$0000,$0071,$0000,$006E
	dc.w	$0000,$006B,$0000,$0069
	dc.w	$0000,$0066,$0000,$0064
	dc.w	$0000,$0061,$0000,$005F
	dc.w	$0000,$005D,$0000,$005B
	dc.w	$0000,$0059,$0000,$0057
	dc.w	$0000,$0056,$0000,$0055
	dc.w	$0000,$0053,$0000,$0052
	dc.w	$0000,$0051,$0000,$0051
	dc.w	$0000,$0050,$0000,$0050
	dc.w	$0000,$0050,$0000,$0050
	dc.w	$0000,$0050,$0000,$0050
	dc.w	$0000,$0051,$0000,$0051
	dc.w	$0000,$0052,$0000,$0053
	dc.w	$0000,$0054,$0000,$0056
	dc.w	$0000,$0057,$0000,$0059
	dc.w	$0000,$005B,$0000,$005D
	dc.w	$0000,$005F,$0000,$0061
	dc.w	$0000,$0064,$0000,$0066
	dc.w	$0000,$0069,$0000,$006B
	dc.w	$0000,$006E,$0000,$0071
	dc.w	$0000,$0074,$0000,$0076
	dc.w	$0000,$0079,$0000,$007C
COURBE2:
	dc.w	$0000,$007F,$0000,$0082
	dc.w	$0000,$0085,$0000,$0088
	dc.w	$0000,$008B,$0000,$008E
	dc.w	$0000,$0091,$0000,$0094
	dc.w	$0000,$0097,$0000,$0099
	dc.w	$0000,$009C,$0000,$009E
	dc.w	$0000,$00A1,$0000,$00A3
	dc.w	$0000,$00A5,$0000,$00A7
	dc.w	$0000,$00A9,$0000,$00AB
	dc.w	$0000,$00AD,$0000,$00AE
	dc.w	$0000,$00AF,$0000,$00B0
	dc.w	$0000,$00B1,$0000,$00B2
	dc.w	$0000,$00B3,$0000,$00B3
	dc.w	$0000,$00B3,$0000,$00B3
	dc.w	$0000,$00B3,$0000,$00B3
	dc.w	$0000,$00B3,$0000,$00B2
	dc.w	$0000,$00B1,$0000,$00B0
	dc.w	$0000,$00AF,$0000,$00AE
	dc.w	$0000,$00AC,$0000,$00AB
	dc.w	$0000,$00A9,$0000,$00A7
	dc.w	$0000,$00A5,$0000,$00A3
	dc.w	$0000,$00A0,$0000,$009E
	dc.w	$0000,$009B,$0000,$0099
	dc.w	$0000,$0096,$0000,$0093
	dc.w	$0000,$0091,$0000,$008E
	dc.w	$0000,$008B,$0000,$0088
	dc.w	$0000,$0085,$0000,$0082
	dc.w	$0000,$0082,$0000,$0084
	dc.w	$0000,$0087,$0000,$008A
	dc.w	$0000,$008D,$0000,$0090
	dc.w	$0000,$0093,$0000,$0096
	dc.w	$0000,$0099,$0000,$009B
	dc.w	$0000,$009E,$0000,$00A0
	dc.w	$0000,$00A2,$0000,$00A5
	dc.w	$0000,$00A7,$0000,$00A9
	dc.w	$0000,$00AA,$0000,$00AC
	dc.w	$0000,$00AE,$0000,$00AF
	dc.w	$0000,$00B0,$0000,$00B1
	dc.w	$0000,$00B2,$0000,$00B3
	dc.w	$0000,$00B3,$0000,$00B3
	dc.w	$0000,$00B3,$0000,$00B3
	dc.w	$0000,$00B3,$0000,$00B3
	dc.w	$0000,$00B2,$0000,$00B1
	dc.w	$0000,$00B0,$0000,$00AF
	dc.w	$0000,$00AE,$0000,$00AD
	dc.w	$0000,$00AB,$0000,$00A9
	dc.w	$0000,$00A7,$0000,$00A5
	dc.w	$0000,$00A3,$0000,$00A1
	dc.w	$0000,$009F,$0000,$009C
	dc.w	$0000,$009A,$0000,$0097
	dc.w	$0000,$0094,$0000,$0091
	dc.w	$0000,$008E,$0000,$008C
	dc.w	$0000,$0089,$0000,$0086
	dc.w	$0000,$0083,$0000,$0080
	dc.w	$0000,$007D,$0000,$007A
	dc.w	$0000,$0077,$0000,$0074
	dc.w	$0000,$0071,$0000,$006E
	dc.w	$0000,$006B,$0000,$0069
	dc.w	$0000,$0066,$0000,$0064
	dc.w	$0000,$0061,$0000,$005F
	dc.w	$0000,$005D,$0000,$005B
	dc.w	$0000,$0059,$0000,$0057
	dc.w	$0000,$0056,$0000,$0055
	dc.w	$0000,$0053,$0000,$0052
	dc.w	$0000,$0051,$0000,$0051
	dc.w	$0000,$0050,$0000,$0050
	dc.w	$0000,$0050,$0000,$0050
	dc.w	$0000,$0050,$0000,$0050
	dc.w	$0000,$0051,$0000,$0051
	dc.w	$0000,$0052,$0000,$0053
	dc.w	$0000,$0054,$0000,$0056
	dc.w	$0000,$0057,$0000,$0059
	dc.w	$0000,$005B,$0000,$005D
	dc.w	$0000,$005F,$0000,$0061
	dc.w	$0000,$0064,$0000,$0066
	dc.w	$0000,$0069,$0000,$006B
	dc.w	$0000,$006E,$0000,$0071
	dc.w	$0000,$0074,$0000,$0076
	dc.w	$0000,$0079,$0000,$007C
	dc.w	$0000,$007F,$0000,$0082
	dc.w	$0000,$0085,$0000,$0088
	dc.w	$0000,$008B,$0000,$008E
	dc.w	$0000,$0091,$0000,$0094
	dc.w	$0000,$0097,$0000,$0099
	dc.w	$0000,$009C,$0000,$009E
	dc.w	$0000,$00A1,$0000,$00A3
	dc.w	$0000,$00A5,$0000,$00A7
	dc.w	$0000,$00A9,$0000,$00AB
	dc.w	$0000,$00AD,$0000,$00AE
	dc.w	$0000,$00AF,$0000,$00B0
	dc.w	$0000,$00B1,$0000,$00B2
	dc.w	$0000,$00B3,$0000,$00B3
	dc.w	$0000,$00B3,$0000,$00B3
	dc.w	$0000,$00B3,$0000,$00B3
	dc.w	$0000,$00B3,$0000,$00B2
	dc.w	$0000,$00B1,$0000,$00B0
	dc.w	$0000,$00AF,$0000,$00AE
	dc.w	$0000,$00AC,$0000,$00AB
	dc.w	$0000,$00A9,$0000,$00A7
	dc.w	$0000,$00A5,$0000,$00A3
	dc.w	$0000,$00A0,$0000,$009E
	dc.w	$0000,$009B,$0000,$0099
	dc.w	$0000,$0096,$0000,$0093
	dc.w	$0000,$0091,$0000,$008E
	dc.w	$0000,$008B,$0000,$0088
	dc.w	$0000,$0085,$0000,$0082
NB_TUBE:
	dc.w	$0000
PTR_COLOR:
	dc.l	COLOR
COLOR:
	dc.w	$0001,$0002,$0003,$0004
	dc.w	$0005,$0006,$0007,$0007
	dc.w	$0006,$0005,$0004,$0003
	dc.w	$0002,$0001,$0001,$0002
	dc.w	$0003,$0014,$0015,$0016
	dc.w	$0017,$0017,$0016,$0015
	dc.w	$0014,$0003,$0002,$0001
	dc.w	$0001,$0002,$0013,$0014
	dc.w	$0015,$0026,$0027,$0027
	dc.w	$0026,$0015,$0014,$0013
	dc.w	$0002,$0001,$0001,$0012
	dc.w	$0013,$0024,$0025,$0026
	dc.w	$0037,$0037,$0026,$0025
	dc.w	$0024,$0013,$0012,$0001
	dc.w	$0001,$0012,$0013,$0024
	dc.w	$0035,$0036,$0047,$0047
	dc.w	$0036,$0035,$0024,$0013
	dc.w	$0012,$0001,$0001,$0012
	dc.w	$0023,$0034,$0035,$0046
	dc.w	$0057,$0057,$0046,$0035
	dc.w	$0034,$0023,$0012,$0001
	dc.w	$0001,$0012,$0023,$0034
	dc.w	$0045,$0056,$0067,$0067
	dc.w	$0056,$0045,$0034,$0023
	dc.w	$0012,$0001,$0011,$0022
	dc.w	$0033,$0044,$0055,$0066
	dc.w	$0077,$0077,$0066,$0055
	dc.w	$0044,$0033,$0022,$0011
	dc.w	$0010,$0021,$0032,$0043
	dc.w	$0054,$0065,$0076,$0076
	dc.w	$0065,$0054,$0043,$0032
	dc.w	$0021,$0001,$0010,$0021
	dc.w	$0032,$0043,$0053,$0064
	dc.w	$0075,$0075,$0064,$0053
	dc.w	$0043,$0032,$0021,$0010
	dc.w	$0010,$0021,$0031,$0042
	dc.w	$0053,$0063,$0074,$0074
	dc.w	$0063,$0053,$0042,$0031
	dc.w	$0021,$0010,$0010,$0021
	dc.w	$0031,$0042,$0052,$0062
	dc.w	$0073,$0073,$0062,$0052
	dc.w	$0042,$0031,$0021,$0010
	dc.w	$0010,$0020,$0031,$0041
	dc.w	$0051,$0062,$0072,$0072
	dc.w	$0062,$0051,$0041,$0031
	dc.w	$0002,$0010,$0010,$0020
	dc.w	$0030,$0041,$0051,$0061
	dc.w	$0071,$0071,$0061,$0051
	dc.w	$0041,$0030,$0020,$0010
	dc.w	$0010,$0020,$0030,$0040
	dc.w	$0050,$0060,$0070,$0070
	dc.w	$0060,$0050,$0040,$0030
	dc.w	$0020,$0010,$0010,$0020
	dc.w	$0030,$0140,$0150,$0160
	dc.w	$0170,$0170,$0160,$0150
	dc.w	$0140,$0030,$0020,$0010
	dc.w	$0010,$0020,$0130,$0140
	dc.w	$0150,$0260,$0270,$0270
	dc.w	$0260,$0150,$0140,$0030
	dc.w	$0020,$0010,$0010,$0120
	dc.w	$0130,$0240,$0250,$0260
	dc.w	$0370,$0370,$0260,$0250
	dc.w	$0240,$0130,$0120,$0010
	dc.w	$0010,$0120,$0130,$0240
	dc.w	$0350,$0360,$0470,$0470
	dc.w	$0360,$0350,$0240,$0130
	dc.w	$0120,$0010,$0010,$0120
	dc.w	$0230,$0340,$0350,$0460
	dc.w	$0570,$0570,$0460,$0350
	dc.w	$0340,$0230,$0120,$0010
	dc.w	$0010,$0120,$0230,$0340
	dc.w	$0450,$0560,$0670,$0670
	dc.w	$0560,$0450,$0340,$0230
	dc.w	$0120,$0010,$0110,$0220
	dc.w	$0330,$0440,$0550,$0660
	dc.w	$0770,$0770,$0660,$0550
	dc.w	$0440,$0330,$0220,$0110
	dc.w	$0100,$0210,$0320,$0430
	dc.w	$0540,$0650,$0760,$0760
	dc.w	$0650,$0540,$0430,$0320
	dc.w	$0210,$0100,$0100,$0210
	dc.w	$0320,$0430,$0530,$0640
	dc.w	$0750,$0750,$0640,$0530
	dc.w	$0430,$0320,$0210,$0100
	dc.w	$0100,$0210,$0310,$0420
	dc.w	$0530,$0630,$0740,$0740
	dc.w	$0630,$0530,$0420,$0310
	dc.w	$0210,$0100,$0100,$0210
	dc.w	$0310,$0420,$0520,$0620
	dc.w	$0730,$0730,$0620,$0520
	dc.w	$0420,$0310,$0210,$0100
	dc.w	$0100,$0200,$0310,$0410
	dc.w	$0510,$0620,$0720,$0720
	dc.w	$0620,$0510,$0410,$0310
	dc.w	$0200,$0100,$0100,$0200
	dc.w	$0300,$0410,$0510,$0610
	dc.w	$0710,$0710,$0610,$0510
	dc.w	$0410,$0300,$0200,$0100
	dc.w	$0100,$0200,$0300,$0400
	dc.w	$0500,$0600,$0700,$0700
	dc.w	$0600,$0500,$0400,$0300
	dc.w	$0200,$0100,$0100,$0200
	dc.w	$0300,$0401,$0501,$0601
	dc.w	$0701,$0701,$0601,$0501
	dc.w	$0401,$0300,$0200,$0100
	dc.w	$0100,$0200,$0301,$0401
	dc.w	$0501,$0602,$0702,$0702
	dc.w	$0602,$0501,$0401,$0301
	dc.w	$0200,$0100,$0100,$0201
	dc.w	$0301,$0402,$0502,$0602
	dc.w	$0703,$0703,$0602,$0502
	dc.w	$0402,$0301,$0201,$0100
	dc.w	$0100,$0201,$0301,$0402
	dc.w	$0503,$0603,$0704,$0704
	dc.w	$0603,$0503,$0402,$0301
	dc.w	$0201,$0100,$0100,$0201
	dc.w	$0302,$0403,$0503,$0604
	dc.w	$0705,$0705,$0604,$0503
	dc.w	$0403,$0302,$0201,$0100
	dc.w	$0100,$0201,$0302,$0403
	dc.w	$0504,$0605,$0706,$0706
	dc.w	$0605,$0504,$0403,$0302
	dc.w	$0201,$0100,$0101,$0202
	dc.w	$0303,$0404,$0505,$0606
	dc.w	$0707,$0707,$0606,$0505
	dc.w	$0404,$0303,$0202,$0101
	dc.w	$0001,$0102,$0203,$0304
	dc.w	$0405,$0506,$0607,$0607
	dc.w	$0506,$0405,$0304,$0203
	dc.w	$0102,$0001,$0001,$0102
	dc.w	$0203,$0304,$0305,$0406
	dc.w	$0507,$0507,$0406,$0305
	dc.w	$0304,$0203,$0102,$0001
	dc.w	$0001,$0102,$0103,$0204
	dc.w	$0305,$0306,$0407,$0407
	dc.w	$0306,$0305,$0204,$0103
	dc.w	$0102,$0001,$0001,$0102
	dc.w	$0103,$0204,$0205,$0206
	dc.w	$0307,$0307,$0206,$0205
	dc.w	$0204,$0103,$0102,$0001
	dc.w	$0001,$0002,$0103,$0104
	dc.w	$0105,$0206,$0207,$0207
	dc.w	$0106,$0105,$0104,$0103
	dc.w	$0002,$0001,$0001,$0002
	dc.w	$0003,$0104,$0105,$0106
	dc.w	$0107,$0107,$0106,$0105
	dc.w	$0104,$0003,$0002,$0001
COLOR2:
	dc.w	$0001,$0002,$0003,$0004
	dc.w	$0005,$0006,$0007,$0007
	dc.w	$0006,$0005,$0004,$0003
	dc.w	$0002,$0001,$0001,$0002
	dc.w	$0003,$0014,$0015,$0016
	dc.w	$0017,$0017,$0016,$0015
	dc.w	$0014,$0003,$0002,$0001
	dc.w	$0001,$0002,$0013,$0014
	dc.w	$0015,$0026,$0027,$0027
	dc.w	$0026,$0015,$0014,$0013
	dc.w	$0002,$0001,$0001,$0012
	dc.w	$0013,$0024,$0025,$0026
	dc.w	$0037,$0037,$0026,$0025
	dc.w	$0024,$0013,$0012,$0001
	dc.w	$0001,$0012,$0013,$0024
	dc.w	$0035,$0036,$0047,$0047
	dc.w	$0036,$0035,$0024,$0013
	dc.w	$0012,$0001,$0001,$0012
	dc.w	$0023,$0034,$0035,$0046
	dc.w	$0057,$0057,$0046,$0035
	dc.w	$0034,$0023,$0012,$0001
	dc.w	$0001,$0012,$0023,$0034
	dc.w	$0045,$0056,$0067,$0067
	dc.w	$0056,$0045,$0034,$0023
	dc.w	$0012,$0001,$0011,$0022
	dc.w	$0033,$0044,$0055,$0066
	dc.w	$0077,$0077,$0066,$0055
	dc.w	$0044,$0033,$0022,$0011
	dc.w	$0010,$0021,$0032,$0043
	dc.w	$0054,$0065,$0076,$0076
	dc.w	$0065,$0054,$0043,$0032
	dc.w	$0021,$0001,$0010,$0021
	dc.w	$0032,$0043,$0053,$0064
	dc.w	$0075,$0075,$0064,$0053
	dc.w	$0043,$0032,$0021,$0010
	dc.w	$0010,$0021,$0031,$0042
	dc.w	$0053,$0063,$0074,$0074
	dc.w	$0063,$0053,$0042,$0031
	dc.w	$0021,$0010,$0010,$0021
	dc.w	$0031,$0042,$0052,$0062
	dc.w	$0073,$0073,$0062,$0052
	dc.w	$0042,$0031,$0021,$0010
	dc.w	$0010,$0020,$0031,$0041
	dc.w	$0051,$0062,$0072,$0072
	dc.w	$0062,$0051,$0041,$0031
	dc.w	$0002,$0010,$0010,$0020
	dc.w	$0030,$0041,$0051,$0061
	dc.w	$0071,$0071,$0061,$0051
	dc.w	$0041,$0030,$0020,$0010
	dc.w	$0010,$0020,$0030,$0040
	dc.w	$0050,$0060,$0070,$0070
	dc.w	$0060,$0050,$0040,$0030
	dc.w	$0020,$0010,$0010,$0020
	dc.w	$0030,$0140,$0150,$0160
	dc.w	$0170,$0170,$0160,$0150
	dc.w	$0140,$0030,$0020,$0010
SPACE:	DCB.W     500,0 
	EVEN
**	

CODING:
	DC.B	'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
	DC.B	'1234567890 ().:!?,;',$27,'[]',$94,$84,'+-'
RAP:
	DC.B	'                           '
	DC.B	'ABCDEFGHIJKLMNOPQRSTUVWXYZ '
	DC.B	'0123456789 ().:!?;',$27,'- '
	DC.B	'                           '
	DC.W	$0 

WAVE:
	dc	$3980,$3A20,$3B60,$3CA0
	dc	$3D40,$3E80,$3FC0,$4100
	dc	$41A0,$42E0,$4420,$44C0
	dc	$4600,$46A0,$47E0,$4920
	dc	$49C0,$4A60,$4BA0,$4C40
	dc	$4D80,$4E20,$4EC0,$4F60
	dc	$50A0,$5140,$51E0,$5280
	dc	$5320,$53C0,$5460,$5500
	dc	$5500,$55A0,$5640,$5640
	dc	$56E0,$5780,$5780,$5780
	dc	$5820,$5820,$5820,$5820
	dc	$5820,$58C0,$5820,$5820
	dc	$5820,$5820,$5820,$5780
	dc	$5780,$5780,$56E0,$5640
	dc	$5640,$55A0,$5500,$5500
	dc	$5460,$53C0,$5320,$5280
	dc	$51E0,$5140,$50A0,$4F60
	dc	$4EC0,$4E20,$4D80,$4C40
	dc	$4BA0,$4A60,$49C0,$4920
	dc	$47E0,$46A0,$4600,$44C0
	dc	$4420,$42E0,$41A0,$4100
	dc	$3FC0,$3E80,$3D40,$3CA0
	dc	$3B60,$3A20,$3980,$3840
	dc	$3700,$35C0,$3520,$33E0
	dc	$32A0,$3160,$30C0,$2F80
	dc	$2E40,$2DA0,$2C60,$2BC0
	dc	$2A80,$2940,$28A0,$2800
	dc	$26C0,$2620,$24E0,$2440
	dc	$23A0,$2300,$21C0,$2120
	dc	$2080,$1FE0,$1F40,$1EA0
	dc	$1E00,$1D60,$1D60,$1CC0
	dc	$1C20,$1C20,$1B80,$1AE0
	dc	$1AE0,$1AE0,$1A40,$1A40
	dc	$1A40,$1A40,$1A40,$1A40
	dc	$1A40,$1A40,$1A40,$1A40
	dc	$1A40,$1AE0,$1AE0,$1AE0
	dc	$1B80,$1C20,$1C20,$1CC0
	dc	$1D60,$1D60,$1E00,$1EA0
	dc	$1F40,$1FE0,$2080,$2120
	dc	$21C0,$2300,$23A0,$2440
	dc	$24E0,$2620,$26C0,$2800
	dc	$28A0,$2940,$2A80,$2BC0
	dc	$2C60,$2DA0,$2E40,$2F80
	dc	$30C0,$3160,$32A0,$33E0
	dc	$3520,$35C0,$3700,$3840
	dc	$3980,$3A20,$3B60,$3CA0
	dc	$3D40,$3E80,$3FC0,$4100
	dc	$41A0,$42E0,$4420,$44C0
	dc	$4600,$46A0,$47E0,$4920
	dc	$49C0,$4A60,$4BA0,$4C40
	dc	$0000
FONT:
	dc	$03FF,$0FFF,$1FFF,$3FFF
	dc	$3FFF,$7FFF,$7FC0,$7F80
	dc	$7F80,$7FFF,$7FFF,$7FFF
	dc	$7FFF,$7FFF,$7F80,$3F00
	dc	$FFC0,$FFF0,$FFF8,$FFFC
	dc	$FFFC,$FFFE,$03FE,$01FE
	dc	$01FE,$FFFE,$FFFE,$FFFE
	dc	$FFFE,$FFFE,$01FE,$00FC
	dc	$3FFF,$7FFF,$7FFF,$7FFF
	dc	$7FFF,$7F80,$7F80,$7FFF
	dc	$7FFF,$7FFF,$7F80,$7F80
	dc	$7FFF,$7FFF,$7FFF,$3FFF
	dc	$FFE0,$FFF8,$FFFC,$FFFC
	dc	$FFFE,$00FE,$007E,$FFFC
	dc	$FFFC,$FFFE,$007E,$00FE
	dc	$FFFC,$FFFC,$FFF8,$FFE0
	dc	$03FF,$0FFF,$1FFF,$3FFF
	dc	$3FFF,$7FFF,$7FFF,$7F80
	dc	$7F80,$7FFF,$7FFF,$3FFF
	dc	$3FFF,$1FFF,$0FFF,$03FF
	dc	$FFFC,$FFFE,$FFFE,$FFFE
	dc	$FFFE,$FFFE,$FFFC,$0000
	dc	$0000,$FFFC,$FFFE,$FFFE
	dc	$FFFE,$FFFE,$FFFE,$FFFC
	dc	$3FFF,$7FFF,$7FFF,$7FFF
	dc	$7FFF,$7FFF,$7FFF,$7F80
	dc	$7F80,$7FFF,$7FFF,$7FFF
	dc	$7FFF,$7FFF,$7FFF,$3FFF
	dc	$FFC0,$FFF0,$FFF8,$FFFC
	dc	$FFFC,$FFFE,$FFFE,$01FE
	dc	$01FE,$FFFE,$FFFE,$FFFC
	dc	$FFFC,$FFF8,$FFF0,$FFC0
	dc	$3FFF,$7FFF,$7FFF,$7FFF
	dc	$7FFF,$7F80,$7FFF,$7FFF
	dc	$7FFF,$7FFF,$7F80,$7FFF
	dc	$7FFF,$7FFF,$7FFF,$3FFF
	dc	$FFFC,$FFFE,$FFFE,$FFFE
	dc	$FFFC,$0000,$FFF0,$FFF8
	dc	$FFF8,$FFF0,$0000,$FFFC
	dc	$FFFE,$FFFE,$FFFE,$FFFC
	dc	$3FFF,$7FFF,$7FFF,$7FFF
	dc	$7FFF,$7F80,$7FFF,$7FFF
	dc	$7FFF,$7FFF,$7F80,$7F80
	dc	$7F80,$7F80,$7F80,$3F00
	dc	$FFFC,$FFFE,$FFFE,$FFFE
	dc	$FFFC,$0000,$FFF0,$FFF8
	dc	$FFF8,$FFF0,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$03FF,$0FFF,$1FFF,$3FFF
	dc	$7FFF,$7FFF,$7F80,$7F01
	dc	$7F03,$7F03,$7F01,$7F80
	dc	$3FFF,$3FFF,$1FFF,$07FF
	dc	$FFFC,$FFFE,$FFFE,$FFFE
	dc	$FFFE,$FFFC,$0000,$FFFC
	dc	$FFFE,$FFFE,$FFFE,$007E
	dc	$FFFE,$FFFE,$FFFE,$FFFC
	dc	$3F00,$7F80,$7F80,$7F80
	dc	$7F80,$7F80,$7FFF,$7FFF
	dc	$7FFF,$7FFF,$7F80,$7F80
	dc	$7F80,$7F80,$7F80,$3F00
	dc	$00FC,$01FE,$01FE,$01FE
	dc	$01FE,$01FE,$FFFE,$FFFE
	dc	$FFFE,$FFFE,$01FE,$01FE
	dc	$01FE,$01FE,$01FE,$00FC
	dc	$0FFF,$1FFF,$1FFF,$1FFF
	dc	$1FFF,$0FFF,$001F,$001F
	dc	$001F,$001F,$0FFF,$1FFF
	dc	$1FFF,$1FFF,$1FFF,$0FFF
	dc	$FFF0,$FFF8,$FFF8,$FFF8
	dc	$FFF8,$FFF0,$F000,$F000
	dc	$F000,$F000,$FFF0,$FFF8
	dc	$FFF8,$FFF8,$FFF8,$FFF0
	dc	$3FFF,$7FFF,$7FFF,$7FFF
	dc	$7FFF,$7FFF,$3FFF,$0000
	dc	$0000,$3FFF,$7FFF,$7FFF
	dc	$7FFF,$7FFF,$7FFF,$3FFF
	dc	$FFFC,$FFFE,$FFFE,$FFFE
	dc	$FFFE,$FFFE,$FFFE,$01FE
	dc	$01FE,$FFFE,$FFFE,$FFFC
	dc	$FFFC,$FFF8,$FFF0,$FFC0
	dc	$3F00,$7F80,$7F80,$7F80
	dc	$7F80,$7FFF,$7FFF,$7FFF
	dc	$7FFF,$7FFF,$7FFF,$7F80
	dc	$7F80,$7F80,$7F80,$3F00
	dc	$01F8,$07FC,$0FF8,$1FF0
	dc	$3FE0,$FFC0,$FF80,$FF00
	dc	$FF00,$FF80,$FFC0,$3FE0
	dc	$1FF0,$0FF8,$07FC,$01F8
	dc	$3F80,$7FC0,$7FC0,$7FC0
	dc	$7FC0,$7FC0,$7FC0,$7FC0
	dc	$7FC0,$7FC0,$7FFF,$7FFF
	dc	$7FFF,$7FFF,$7FFF,$3FFF
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$FFFC,$FFFE
	dc	$FFFE,$FFFE,$FFFE,$FFFC
	dc	$3F00,$7FC0,$7FE0,$7FF0
	dc	$7FF8,$7FFC,$7FFE,$7FFF
	dc	$7FFF,$7FFF,$7FBF,$7F9F
	dc	$7F8F,$7F87,$7F81,$3F00
	dc	$00FC,$03FE,$07FE,$0FFE
	dc	$1FFE,$3FFE,$7FFE,$FFFE
	dc	$FFFE,$FFFE,$FDFE,$F9FE
	dc	$F1FE,$E1FE,$81FE,$00FC
	dc	$3FF8,$7FFE,$7FFF,$7FFF
	dc	$7FFF,$7FFF,$7FFF,$7FBF
	dc	$7F9F,$7F8F,$7F87,$7F83
	dc	$7F81,$7F80,$7F80,$3F00
	dc	$00FC,$01FE,$01FE,$81FE
	dc	$C1FE,$E1FE,$F1FE,$F9FE
	dc	$FDFE,$FFFE,$FFFE,$FFFE
	dc	$FFFE,$FFFE,$7FFE,$1FFC
	dc	$03FF,$0FFF,$1FFF,$3FFF
	dc	$3FFF,$7FFF,$7FC0,$7F80
	dc	$7F80,$7FC0,$7FFF,$3FFF
	dc	$3FFF,$1FFF,$0FFF,$03FF
	dc	$FFC0,$FFF0,$FFF8,$FFFC
	dc	$FFFC,$FFFE,$03FE,$01FE
	dc	$01FE,$03FE,$FFFE,$FFFC
	dc	$FFFC,$FFF8,$FFF0,$FFC0
	dc	$3FFF,$7FFF,$7FFF,$7FFF
	dc	$7FFF,$7F80,$7FFF,$7FFF
	dc	$7FFF,$7FFF,$7FFF,$7F80
	dc	$7F80,$7F80,$7F80,$3F00
	dc	$FFE0,$FFF8,$FFFC,$FFFC
	dc	$FFFE,$00FE,$FFFE,$FFFC
	dc	$FFFC,$FFF8,$FFE0,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$03FF,$0FFF,$1FFF,$3FFF
	dc	$3FFF,$7FFF,$7F80,$7F00
	dc	$7F00,$7F80,$7FFF,$3FFF
	dc	$3FFF,$1FFF,$0FFF,$03FF
	dc	$FFC0,$FFF0,$FFF8,$FFFC
	dc	$FFFC,$FFFE,$01FE,$00FE
	dc	$007E,$7FBE,$BFDE,$DFEE
	dc	$EFF4,$F7F8,$FBFC,$FDFE
	dc	$3FFF,$7FFF,$7FFF,$7FFF
	dc	$7FFF,$7F80,$7FFF,$7FFF
	dc	$7FFF,$7FFF,$7FFF,$7F80
	dc	$7F80,$7F80,$7F80,$3F00
	dc	$FFE0,$FFF8,$FFFC,$FFFC
	dc	$FFFE,$007E,$FFFE,$FFFE
	dc	$FFFC,$FFFC,$FFF8,$3FE0
	dc	$1FF0,$0FF8,$07FC,$01F8
	dc	$0FFF,$3FFF,$7FFF,$7FFF
	dc	$7FFF,$7FFF,$3FFF,$1FFF
	dc	$07FF,$00FF,$3FFF,$7FFF
	dc	$7FFF,$7FFF,$7FFF,$3FFF
	dc	$FFFC,$FFFE,$FFFE,$FFFE
	dc	$FFFE,$FFFC,$F000,$FE00
	dc	$FFC0,$FFF8,$FFFC,$FFFE
	dc	$FFFE,$FFFE,$FFFC,$FFF0
	dc	$3FFF,$7FFF,$7FFF,$7FFF
	dc	$7FFF,$7FFF,$3FFF,$001F
	dc	$001F,$001F,$001F,$001F
	dc	$001F,$001F,$001F,$000F
	dc	$FFFC,$FFFE,$FFFE,$FFFE
	dc	$FFFE,$FFFE,$FFFC,$F000
	dc	$F000,$F000,$F000,$F000
	dc	$F000,$F000,$F000,$E000
	dc	$3F00,$7F80,$7F80,$7F80
	dc	$7F80,$7F80,$7F80,$7F80
	dc	$7FC0,$7FFF,$7FFF,$3FFF
	dc	$3FFF,$1FFF,$0FFF,$03FF
	dc	$00FC,$01FE,$01FE,$01FE
	dc	$01FE,$01FE,$01FE,$01FE
	dc	$03FE,$FFFE,$FFFE,$FFFC
	dc	$FFFC,$FFF8,$FFF0,$FFC0
	dc	$3F00,$7FC0,$3FE0,$1FF0
	dc	$0FF8,$07FC,$03FE,$01FF
	dc	$00FF,$007F,$003F,$001F
	dc	$000F,$0007,$0003,$0001
	dc	$00FC,$03FE,$07FC,$0FF8
	dc	$1FF0,$3FE0,$7FC0,$FF80
	dc	$FF00,$FE00,$FC00,$F800
	dc	$F000,$E000,$C000,$8000
	dc	$3F00,$7F80,$7F81,$7F83
	dc	$7F87,$7F8F,$7F9F,$7FBF
	dc	$7FFF,$7FFF,$7FFF,$3FFE
	dc	$3FFC,$1FF8,$0FF0,$03C0
	dc	$00FC,$01FE,$81FE,$C1FE
	dc	$E1FE,$F1FE,$F9FE,$FDFE
	dc	$FFFE,$FFFE,$FFFE,$7FFC
	dc	$3FFC,$1FF8,$0FF0,$03C0
	dc	$1F80,$3FE0,$1FF0,$0FF8
	dc	$07FC,$03FF,$01FF,$00FF
	dc	$00FF,$01FF,$03FF,$07FC
	dc	$0FF8,$1FF0,$3FE0,$1F80
	dc	$01F8,$07FC,$0FF8,$1FF0
	dc	$3FE0,$FFC0,$FF80,$FF00
	dc	$FF00,$FF80,$FFC0,$3FE0
	dc	$1FF0,$0FF8,$07FC,$01F8
	dc	$3F00,$7FC0,$3FE0,$1FF0
	dc	$0FF8,$07FC,$03FE,$01FF
	dc	$00FF,$007F,$003F,$001F
	dc	$001F,$001F,$001F,$000F
	dc	$00FC,$03FE,$07FC,$0FF8
	dc	$1FF0,$3FE0,$7FC0,$FF80
	dc	$FF00,$FE00,$FC00,$F800
	dc	$F800,$F800,$F800,$F000
	dc	$3FFF,$7FFF,$7FFF,$7FFF
	dc	$7FFF,$7FFF,$3FFF,$007F
	dc	$00FF,$01FF,$03FF,$07FF
	dc	$0FFF,$1FFF,$3FFF,$7FFF
	dc	$FFFE,$FFFC,$FFF8,$FFF0
	dc	$FFE0,$FFC0,$FF80,$FF00
	dc	$FE00,$FFFC,$FFFE,$FFFE
	dc	$FFFE,$FFFE,$FFFE,$FFFC
	dc	$0007,$000F,$000F,$000F
	dc	$000F,$000F,$0007,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$FFE0,$FFF0,$FFF0,$FFF0
	dc	$FFF0,$FFF0,$FFF0,$0FF0
	dc	$0FF0,$0FF0,$0FF0,$0FF0
	dc	$0FF0,$0FF0,$0FF0,$07E0
	dc	$3FFF,$7FFF,$7FFF,$7FFF
	dc	$7FFF,$7FFF,$3FFF,$007F
	dc	$00FF,$01FF,$03FF,$07FF
	dc	$0FFF,$1FFF,$3FFF,$7FFF
	dc	$FFF8,$FFFC,$FFFE,$FFFE
	dc	$FFFE,$FFFC,$FFF8,$FFF0
	dc	$FFE0,$FFFC,$FFFE,$FFFE
	dc	$FFFE,$FFFE,$FFFE,$FFFC
	dc	$3FFF,$7FFF,$7FFF,$7FFF
	dc	$3FFF,$0000,$0FFF,$1FFF
	dc	$1FFF,$0FFF,$0000,$3FFF
	dc	$7FFF,$7FFF,$7FFF,$3FFF
	dc	$FFC0,$FFF0,$FFF8,$FFFC
	dc	$FFFC,$01FE,$FFFE,$FFFE
	dc	$FFFE,$FFFE,$01FE,$FFFC
	dc	$FFFC,$FFF8,$FFF0,$FFC0
	dc	$0007,$001F,$003F,$007F
	dc	$00FF,$01FF,$03FF,$07FF
	dc	$0FFF,$1FFF,$1FFF,$0FFF
	dc	$0000,$0000,$0000,$0000
	dc	$E000,$F000,$E000,$C7E0
	dc	$8FF0,$0FF0,$FFFC,$FFFE
	dc	$FFFE,$FFFE,$FFFE,$FFFC
	dc	$0FF0,$0FF0,$0FF0,$07E0
	dc	$3FFF,$7FFF,$7FFF,$7FFF
	dc	$7FFF,$7F80,$7FFF,$7FFF
	dc	$7FFF,$3FFF,$0000,$3FFF
	dc	$7FFF,$7FFF,$7FFF,$3FFF
	dc	$FFFC,$FFFE,$FFFE,$FFFE
	dc	$FFFC,$0000,$FFF8,$FFFC
	dc	$FFFC,$FFFE,$00FE,$FFFE
	dc	$FFFE,$FFFC,$FFFC,$FFF8
	dc	$007F,$01FF,$03FF,$07FE
	dc	$0FFC,$1FFF,$3FFF,$3FFF
	dc	$7FFF,$7FFF,$7FC0,$7FFF
	dc	$3FFF,$3FFF,$1FFF,$07FF
	dc	$8000,$8000,$0000,$0000
	dc	$0000,$FFE0,$FFF8,$FFFC
	dc	$FFFC,$FFFE,$00FE,$FFFE
	dc	$FFFC,$FFFC,$FFF8,$FFE0
	dc	$007F,$01FF,$03FF,$07FF
	dc	$0FFF,$0FFF,$07FF,$0003
	dc	$0007,$000F,$001F,$003F
	dc	$007F,$00FF,$01FF,$01FE
	dc	$FFF0,$FFF8,$FFF8,$FFF0
	dc	$FFE0,$FFC0,$FF80,$FF00
	dc	$FE00,$FC00,$F800,$F000
	dc	$E000,$C000,$8000,$0000
	dc	$0000,$03FF,$0FFF,$1FFF
	dc	$1F80,$1FFF,$0FFF,$0FFF
	dc	$3FFF,$7FFF,$7F00,$7F80
	dc	$3FFF,$3FFF,$1FFF,$07FF
	dc	$0000,$FFC0,$FFF0,$FFF8
	dc	$01F8,$FFF8,$FFF0,$FFF0
	dc	$FFFC,$FFFE,$007E,$00FE
	dc	$FFFC,$FFFC,$FFF8,$FFE0
	dc	$07FF,$1FFF,$3FFF,$3FFF
	dc	$7FFF,$7E00,$7FFF,$3FFF
	dc	$3FFF,$1FFF,$07FF,$0000
	dc	$0000,$0001,$0003,$0003
	dc	$FFC0,$FFF0,$FFF8,$FFF8
	dc	$FFFC,$03FC,$FFFC,$FFFC
	dc	$FFF8,$FFF8,$FFF0,$7FE0
	dc	$FFC0,$FF80,$FF00,$FC00
	dc	$07FF,$1FFF,$3FFF,$7FFF
	dc	$7FFF,$FFFF,$FF87,$FF0F
	dc	$FF1F,$FFBF,$FFFF,$7FFF
	dc	$7FFF,$3FFF,$1FFF,$07FF
	dc	$FF80,$FFE0,$FFF0,$FFF8
	dc	$FFF8,$FFFC,$F7FC,$E3FC
	dc	$C3FC,$87FC,$FFFC,$FFF8
	dc	$FFF8,$FFF0,$FFE0,$FF80
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
	dc	$0007,$001F,$003F,$007F
	dc	$007F,$00FF,$00FE,$00FC
	dc	$00FC,$00FE,$00FF,$007F
	dc	$007F,$003F,$001F,$0007
	dc	$3800,$3E00,$3F00,$3F80
	dc	$3F80,$3FC0,$1FC0,$0FC0
	dc	$0FC0,$1FC0,$3FC0,$3F80
	dc	$3F80,$3F00,$3E00,$3800
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$03C0,$07E0
	dc	$07E0,$07E0,$07E0,$03C0
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0780,$0FC0
	dc	$0FC0,$0FC0,$0FC0,$0780
	dc	$0000,$0000,$0780,$0FC0
	dc	$0FC0,$0FC0,$0FC0,$0780
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$03F0,$07F8,$07F8,$07F8
	dc	$07F8,$07F8,$07F8,$07F8
	dc	$07F8,$03F0,$0000,$03F0
	dc	$07F8,$07F8,$07F8,$03F0
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$3FFF,$7FFF,$7FFF,$3FFF
	dc	$0000,$3FFF,$7FFF,$7FFF
	dc	$7FFF,$3FFF,$0000,$3FFE
	dc	$7FFF,$7FFF,$7FFF,$3FFE
	dc	$FFC0,$FFE0,$FFE0,$FFF0
	dc	$03F0,$FFF0,$FFE0,$FFE0
	dc	$FFC0,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0780,$0FC0,$0FC0,$0FC0
	dc	$0FC0,$07C0,$0F80,$1F00
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0780,$0FC0,$0FC0
	dc	$0FC0,$0FC0,$0780,$0000
	dc	$0780,$0FC0,$0FC0,$0FC0
	dc	$0FC0,$07C0,$0F80,$1F00
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0007,$000F,$000F
	dc	$000F,$000F,$0007,$000F
	dc	$001F,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$8000,$C000,$C000
	dc	$C000,$C000,$C000,$8000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0787,$0FCF,$0FCF,$0FCF
	dc	$0FCF,$07C7,$0F8F,$1F1F
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$8000,$C000,$C000,$C000
	dc	$C000,$C000,$8000,$0000
	dc	$0000,$0787,$0FCF,$0FCF
	dc	$0FCF,$0FCF,$07C7,$0F8F
	dc	$1F1F,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$8000,$C000,$C000
	dc	$C000,$C000,$C000,$8000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$000F,$003F,$007F,$007F
	dc	$00FF,$00FF,$00FF,$00FF
	dc	$00FF,$00FF,$00FF,$00FF
	dc	$00FF,$00FF,$00FF,$00FF
	dc	$FFFF,$FFFF,$FFFF,$FFFF
	dc	$FFFF,$FFFF,$FFFF,$83FE
	dc	$03FF,$03FF,$03FF,$03FF
	dc	$01FF,$01FF,$00FF,$003F
	dc	$FFF8,$FFFC,$FFFE,$FFFF
	dc	$FFFF,$FFFF,$FFFF,$001F
	dc	$FFBF,$FF7F,$FEFF,$01FF
	dc	$FFFE,$FFFC,$FFF8,$FFF0
	dc	$3FE0,$7FC0,$FF80,$FF00
	dc	$FE00,$FC00,$F800,$F000
	dc	$F800,$FC00,$FE00,$FF00
	dc	$FF80,$7FC0,$3FE0,$1FF0
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$C000,$E000,$E000
	dc	$E000,$FF00,$FF80,$FF80
	dc	$FF80,$FF80,$FF80,$FF00
	dc	$E000,$E000,$E000,$C000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$01FF,$03FF,$03FF
	dc	$03FF,$03FF,$03FF,$01FF
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$0000,$0000,$0000
	dc	$0000,$FF00,$FF80,$FF80
	dc	$FF80,$FF80,$FF80,$FF00
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
	EVEN

*

* -> Merci Mister.A !
Pal_Maartau:
	dc.w      $0000,$09AA,$0233,$0344,$0455,$0566,$0677,$0777
	dc.w      $0FFF,$09AA,$0233,$0344,$0455,$0566,$0677,$0777
	
Logo_Maartau:
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
		dc.w	$0007,$000F,$0000,$000F,$F007,$F80F,$0000,$F80F
		dc.w	$F000,$F800,$0000,$F800,$2001,$6001,$1FFE,$7FFF
		dc.w	$0020,$8060,$001F,$807F,$0101,$0183,$FE00,$FF83
		dc.w	$FF02,$FF83,$007C,$FFFF,$0300,$07FF,$0000,$07FF
		dc.w	$0001,$FC03,$0380,$FF83,$0008,$000C,$FFF0,$FFFC
		dc.w	$0000,$0000,$0000,$0000,$0F00,$1F40,$0080,$1FC0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0010,$0030,$000F,$003F,$0410,$0630,$F80F,$FE3F
		dc.w	$0400,$0600,$F800,$FE00,$BFFF,$8000,$7FFF,$FFFF
		dc.w	$40BF,$4080,$807F,$C0FF,$FF42,$0042,$FF81,$FFC3
		dc.w	$00FE,$0080,$FF7F,$FFFF,$84C0,$84C0,$033F,$87FF
		dc.w	$0785,$0404,$FB83,$FF87,$FFFA,$0002,$FFFC,$FFFE
		dc.w	$0F80,$1FC0,$0000,$1FC0,$20C0,$6040,$1F80,$7FC0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002F,$0020,$001F,$003F,$FA2F,$0220,$FC1F,$FE3F
		dc.w	$FA01,$0201,$FC00,$FE01,$4000,$3FFF,$FFFF,$FFFF
		dc.w	$A140,$213F,$C0FF,$E1FF,$00A3,$FF22,$FFC1,$FFE3
		dc.w	$FF81,$00FE,$FF7F,$FFFF,$47FF,$44C0,$833F,$C7FF
		dc.w	$FC0A,$0789,$FB87,$FF8F,$0005,$FFF9,$FFFE,$FFFF
		dc.w	$0540,$1240,$0F80,$1FC0,$5F40,$40C0,$3F80,$7FC0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0018,$0047,$003F,$007F,$0C18,$F147,$FE3F,$FF7F
		dc.w	$0C00,$F102,$FE01,$FF03,$BFFF,$7FFF,$FFFF,$FFFF
		dc.w	$40BF,$927F,$E1FF,$F3FF,$FF42,$FF93,$FFE1,$FFF3
		dc.w	$00FE,$FFFF,$FF7F,$FFFF,$84C0,$27FF,$C33F,$E7FF
		dc.w	$0785,$FF93,$FB8F,$FF9F,$FFFA,$FFFC,$FFFF,$FFFF
		dc.w	$0540,$9240,$0F80,$9FC0,$30C0,$8FC0,$7F80,$FFC0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0053,$004C,$003F,$007F,$E553,$194C,$FE3F,$FF7F
		dc.w	$E503,$1902,$FE01,$FF03,$6001,$FFFF,$FFFF,$FFFF
		dc.w	$B360,$D2FF,$E1FF,$F3FF,$01B3,$FFD2,$FFE1,$FFF3
		dc.w	$8F83,$70FF,$FF7F,$FFFF,$67FC,$A4C3,$C33F,$E7FF
		dc.w	$7C1B,$8797,$FB8F,$FF9F,$000D,$FFFE,$FFFF,$FFFF
		dc.w	$8F80,$9FC0,$0000,$9FC0,$A740,$98C0,$7F80,$FFC0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0056,$0048,$003F,$007F,$3556,$0948,$FE3F,$FF7F
		dc.w	$3501,$0900,$FE03,$FF03,$5FFE,$E001,$FFFF,$FFFF
		dc.w	$A15F,$C0E0,$F3FF,$F3FF,$FEA2,$01C2,$FFF1,$FFF3
		dc.w	$D8FD,$2083,$FF7F,$FFFF,$44C6,$84C1,$E33F,$E7FF
		dc.w	$C78A,$0407,$FB9F,$FF9F,$FFF5,$000E,$FFFF,$FFFF
		dc.w	$0A80,$0700,$9FC0,$9FC0,$ACC0,$9040,$7F80,$FFC0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0055,$0049,$003E,$007F,$D555,$C949,$3E3E,$FF7F
		dc.w	$D501,$C900,$3E03,$FF03,$5002,$E001,$FFFF,$FFFF
		dc.w	$A150,$C0E0,$F3FF,$F3FF,$02A1,$01C3,$FFF0,$FFF3
		dc.w	$5705,$2783,$F87F,$FFFF,$403A,$87F9,$E007,$E7FF
		dc.w	$B80A,$3C07,$C39F,$FF9F,$8015,$000E,$FFFF,$FFFF
		dc.w	$0A80,$0700,$9FC0,$9FC0,$AB00,$9340,$7C80,$FFC0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0055,$0049,$003E,$007F,$5555,$4949,$3E3E,$7F7F
		dc.w	$5501,$4900,$3E03,$7F03,$540A,$E619,$F807,$FE1F
		dc.w	$A154,$C0E6,$F3F8,$F3FE,$0AA1,$19C1,$07F0,$1FF1
		dc.w	$5415,$2433,$F80F,$FC3F,$400A,$8009,$E007,$E00F
		dc.w	$A00A,$2007,$C01F,$E01F,$A055,$30CE,$C03F,$F0FF
		dc.w	$0A80,$0700,$9FC0,$9FC0,$AA00,$9200,$7C00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0055,$0049,$003E,$007F,$5555,$4949,$3E3E,$7F7F
		dc.w	$5501,$4900,$3E03,$7F03,$5002,$E409,$F807,$FC0F
		dc.w	$A150,$C0E4,$F3F8,$F3FC,$02A1,$09C1,$07F0,$0FF1
		dc.w	$5405,$2413,$F80F,$FC1F,$400A,$8009,$E007,$E00F
		dc.w	$A00A,$2007,$C01F,$E01F,$8015,$204E,$C03F,$E07F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$AA00,$9200,$7C00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003E,$007F,$0000,$007F,$3E3E,$7F7F,$0000,$7F7F
		dc.w	$3E01,$7F00,$0003,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C1,$07F0,$07F1
		dc.w	$F805,$FC03,$000F,$FC0F,$4007,$800F,$E000,$E00F
		dc.w	$C00A,$E007,$001F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$7C00,$FE00,$0000,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C03,$7F00,$7F03,$F003,$F807,$0000,$F807
		dc.w	$E1F0,$F3F8,$0000,$F3F8,$03E0,$07F1,$0000,$07F1
		dc.w	$F805,$FC03,$000F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400F,$801F,$E000,$E01F,$801F,$C03F,$0000,$C03F
		dc.w	$0A80,$8700,$1FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A00,$1C02,$7F01,$7F03,$A805,$4804,$F003,$F807
		dc.w	$40A8,$9248,$E1F0,$F3F8,$0540,$0491,$03E0,$07F1
		dc.w	$5405,$2413,$F80F,$FC1F,$4005,$8003,$E00F,$E00F
		dc.w	$4005,$8012,$E00F,$E01F,$402A,$4024,$801F,$C03F
		dc.w	$0A80,$8700,$1FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A00,$1C02,$7F01,$7F03,$A805,$4804,$F003,$F807
		dc.w	$40A8,$9248,$E1F0,$F3F8,$0540,$0491,$03E0,$07F1
		dc.w	$5415,$2433,$F80F,$FC3F,$4005,$8003,$E00F,$E00F
		dc.w	$4005,$8012,$E00F,$E01F,$402A,$4024,$801F,$C03F
		dc.w	$0A80,$8700,$1FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A00,$1C02,$7F01,$7F03,$AE1D,$4F3C,$F0C3,$FFFF
		dc.w	$40AE,$924F,$E1F0,$F3FF,$1D40,$3C91,$C3E0,$FFF1
		dc.w	$5705,$2783,$F87F,$FFFF,$4005,$8003,$E00F,$E00F
		dc.w	$4005,$8012,$E00F,$E01F,$70EA,$79E4,$861F,$FFFF
		dc.w	$0A80,$8700,$1FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A00,$1C02,$7F01,$7F03,$B1E3,$4120,$FEDF,$FFFF
		dc.w	$40B1,$9241,$E1FE,$F3FF,$E340,$2091,$DFE0,$FFF1
		dc.w	$58FD,$2083,$FF7F,$FFFF,$4005,$8003,$E00F,$E00F
		dc.w	$4005,$8012,$E00F,$E01F,$8F1A,$0904,$F6FF,$FFFF
		dc.w	$0A80,$8700,$1FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A00,$1C02,$7F01,$7F03,$9F3E,$61E1,$FEDF,$FFFF
		dc.w	$409F,$9261,$E1FE,$F3FF,$3E40,$E191,$DFE0,$FFF1
		dc.w	$4F83,$30FF,$FF7F,$FFFF,$6005,$A003,$C00F,$E00F
		dc.w	$4004,$8013,$E00F,$E01F,$F9F2,$0F0C,$F6FF,$FFFF
		dc.w	$0A80,$8700,$1FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A00,$1C02,$7F01,$7F03,$81E0,$7FFF,$FEDF,$FFFF
		dc.w	$4081,$927F,$E1FE,$F3FF,$E040,$FF91,$DFE0,$FFF1
		dc.w	$40FE,$3FFF,$FF7F,$FFFF,$8005,$2003,$C00F,$E00F
		dc.w	$4004,$8013,$E00F,$E01F,$0F02,$FFFC,$F6FF,$FFFF
		dc.w	$0A80,$8700,$1FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A00,$1C02,$7F01,$7F03,$9F3E,$61E1,$FEDF,$FFFF
		dc.w	$409F,$9261,$E1FE,$F3FF,$3E40,$E191,$DFE0,$FFF1
		dc.w	$4F81,$30FE,$FF7F,$FFFF,$6005,$6003,$800F,$E00F
		dc.w	$4004,$8013,$E00F,$E01F,$F9F2,$0F0C,$F6FF,$FFFF
		dc.w	$0A80,$8700,$1FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A00,$1C02,$7F01,$7F03,$B1E3,$4120,$FEDF,$FFFF
		dc.w	$40B1,$9241,$E1FE,$F3FF,$E340,$2091,$DFE0,$FFF1
		dc.w	$58FE,$2080,$FF7F,$FFFF,$C005,$8003,$600F,$E00F
		dc.w	$4005,$8012,$E00F,$E01F,$8F1A,$0904,$F6FF,$FFFF
		dc.w	$0A80,$8700,$1FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A00,$1C02,$7F01,$7F03,$AE1D,$4F3C,$F0C3,$FFFF
		dc.w	$40AE,$924F,$E1F0,$F3FF,$1D40,$3C91,$C3E0,$FFF1
		dc.w	$5702,$2783,$F87C,$FFFF,$4005,$8003,$E00F,$E00F
		dc.w	$4005,$8012,$E00F,$E01F,$70EA,$79E4,$861F,$FFFF
		dc.w	$0A80,$8700,$1FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A00,$1C02,$7F01,$7F03,$A805,$4804,$F003,$F807
		dc.w	$40A8,$9248,$E1F0,$F3F8,$0540,$0491,$03E0,$07F1
		dc.w	$5415,$2433,$F80F,$FC3F,$4005,$8003,$E00F,$E00F
		dc.w	$4005,$8012,$E00F,$E01F,$402A,$4024,$801F,$C03F
		dc.w	$0A80,$8700,$1FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A00,$1C02,$7F01,$7F03,$A805,$4804,$F003,$F807
		dc.w	$40A8,$9248,$E1F0,$F3F8,$0540,$0491,$03E0,$07F1
		dc.w	$5405,$2413,$F80F,$FC1F,$4005,$8003,$E00F,$E00F
		dc.w	$4005,$8012,$E00F,$E01F,$402A,$4024,$801F,$C03F
		dc.w	$0A80,$8700,$1FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C03,$7F00,$7F03,$F003,$F807,$0000,$F807
		dc.w	$E1F0,$F3F8,$0000,$F3F8,$03E0,$07F1,$0000,$07F1
		dc.w	$F805,$FC03,$000F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400F,$801F,$E000,$E01F,$801F,$C03F,$0000,$C03F
		dc.w	$0A80,$8700,$1FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2A2A,$1C1C,$7F7F,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$3E3E,$7F7F,$0000,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$5555,$4949,$3E3E,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$5555,$4949,$3E3E,$7F7F
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$55D5,$49C9,$3E3E,$7FFF
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$5635,$4809,$3FFE,$7FFF
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$53E5,$4C19,$3FFE,$7FFF
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$180C,$47F1,$3FFE,$7FFF
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$2FFA,$2002,$1FFC,$3FFE
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$1004,$3006,$0FF8,$3FFE
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$07F0,$0FF8,$0000,$0FF8
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$0000,$0000,$0000,$0000
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$0000,$0000,$0000,$0000
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$0000,$0000,$0000,$0000
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$0000,$0000,$0000,$0000
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002A,$001C,$007F,$007F,$0000,$0000,$0000,$0000
		dc.w	$2A01,$1C00,$7F03,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A805,$7003,$FC0F,$FC0F,$4005,$8003,$E00F,$E00F
		dc.w	$400A,$8007,$E01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003E,$007F,$0000,$007F,$0000,$0000,$0000,$0000
		dc.w	$3E01,$7F00,$0003,$7F03,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A807,$700F,$FC00,$FC0F,$C007,$E00F,$0000,$E00F
		dc.w	$C00A,$E007,$001F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FC0,$9FC0,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0055,$00C9,$003E,$00FF,$0000,$3E3E,$0000,$3E3E
		dc.w	$5501,$4980,$3E03,$7F83,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A80A,$7009,$FC07,$FC0F,$A00A,$3009,$C007,$F00F
		dc.w	$A00A,$2007,$C01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0721,$9FC0,$9FE1,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00D5,$00C9,$003E,$00FF,$7F07,$7F07,$0000,$7F07
		dc.w	$5581,$4980,$3E03,$7F83,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A80A,$7009,$FC07,$FC0F,$B00A,$3009,$C007,$F00F
		dc.w	$A00A,$2007,$C01F,$E01F,$8015,$000E,$C03F,$C03F
		dc.w	$0AA1,$0733,$9FC0,$9FF3,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00D5,$05C9,$023E,$07FF,$0000,$0000,$777F,$777F
		dc.w	$5581,$49D0,$3E23,$7FF3,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A80A,$7009,$FC07,$FC0F,$B03A,$3879,$C007,$F87F
		dc.w	$B80A,$3C07,$C01F,$FC1F,$8015,$000E,$C03F,$C03F
		dc.w	$0A80,$0700,$9FFF,$9FFF,$5400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0735,$0509,$02FE,$07FF,$7777,$0000,$7777,$7777
		dc.w	$5671,$4850,$3FA3,$7FF3,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A80A,$7009,$FC07,$FC0F,$C846,$0841,$F03F,$F87F
		dc.w	$C40A,$0407,$F81F,$FC1F,$8015,$000E,$C03F,$C03F
		dc.w	$0AFF,$0700,$9FFF,$9FFF,$D400,$3800,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$05E5,$0719,$02FE,$07FF,$0000,$7777,$7777,$7777
		dc.w	$53D1,$4C70,$3FA3,$7FF3,$5002,$E001,$F807,$F807
		dc.w	$A150,$C0E0,$F3F8,$F3F8,$02A0,$01C0,$07F1,$07F1
		dc.w	$A80A,$7009,$FC07,$FC0F,$787C,$8843,$F03F,$F87F
		dc.w	$7C0A,$8407,$F81F,$FC1F,$8015,$000E,$C03F,$C03F
		dc.w	$1B00,$17FF,$8FFF,$9FFF,$3600,$FA00,$FC00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$070C,$07F1,$02FE,$07FF,$7417,$7777,$7777,$7777
		dc.w	$1871,$47F3,$3FA0,$7FF3,$F003,$F807,$0000,$F807
		dc.w	$E1F0,$F3F8,$0000,$F3F8,$03E0,$07F1,$0000,$07F1
		dc.w	$F803,$FC08,$0007,$FC0F,$0840,$F87F,$F03F,$F87F
		dc.w	$040F,$FC1F,$F800,$FC1F,$801F,$C03F,$0000,$C03F
		dc.w	$05FF,$93FF,$0FFF,$9FFF,$E800,$F200,$FC00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$05FA,$0702,$02FC,$07FE,$0220,$0360,$0360,$0360
		dc.w	$2FD2,$2072,$1FA1,$3FF3,$A001,$4804,$F003,$F807
		dc.w	$52A0,$9248,$E1F0,$F3F8,$0151,$0491,$03E0,$07F1
		dc.w	$5005,$2404,$F803,$FC07,$F87F,$0840,$F03F,$F87F
		dc.w	$FC15,$0412,$F80F,$FC1F,$000A,$4024,$801F,$C03F
		dc.w	$8A00,$89FF,$07FF,$8FFF,$1400,$E400,$F800,$FC00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0704,$0506,$02F8,$07FE,$0140,$0140,$0140,$0140
		dc.w	$1072,$3052,$0FA1,$3FF3,$A001,$4804,$F003,$F807
		dc.w	$52A0,$9248,$E1F0,$F3F8,$0151,$0491,$03E0,$07F1
		dc.w	$5002,$2406,$F801,$FC07,$0840,$0840,$F03F,$F87F
		dc.w	$0415,$0412,$F80F,$FC1F,$000A,$4024,$801F,$C03F
		dc.w	$85FF,$8400,$03FF,$87FF,$E800,$0800,$F000,$F800
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00F0,$05F8,$0200,$07F8,$0000,$0000,$0000,$0000
		dc.w	$0781,$0FD3,$0020,$0FF3,$F003,$F807,$0000,$F807
		dc.w	$E1F0,$F3F8,$0000,$F3F8,$03E0,$07F1,$0000,$07F1
		dc.w	$F800,$FC01,$0000,$FC01,$F400,$FC7F,$0000,$FC7F
		dc.w	$000F,$FC1F,$0000,$FC1F,$801F,$C03F,$0000,$C03F
		dc.w	$0100,$8100,$00FF,$81FF,$2000,$2000,$C000,$E000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0400,$0000,$0000,$0400
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0200,$0400,$0000,$0600
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0C00,$0400,$0200,$0E00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0A00,$0600,$0000,$0E00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0400,$0000,$0000,$0400
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000


* New NoExtra logo !
PalNoeXtra:
	dc.w	$0000,$0BDA,$046A,$0810,$0190,$0128,$09A8,$0231
	dc.w	$02B1,$0AB9,$0A49,$0F00,$0B52,$0F00,$03C2,$0777

LogoNoeXtra:
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0040,$0000,$00FF,$0000,$0001,$0000,$FFFF,$0000
		dc.w	$5200,$0200,$FC00,$0000,$E000,$E000,$1FFF,$0000
		dc.w	$0A90,$0010,$FFE0,$0000,$0600,$0600,$01FF,$0000
		dc.w	$1401,$0000,$FC03,$0000,$0000,$0000,$FFF0,$0000
		dc.w	$0AAA,$0001,$0FFF,$0000,$8F68,$4000,$CFFF,$0000
		dc.w	$0060,$0060,$FF80,$0000,$4000,$0000,$FFFF,$0000
		dc.w	$0152,$0002,$FFFC,$0000,$00E0,$00E0,$001F,$0000
		dc.w	$000A,$0000,$FFFF,$0000,$9000,$1000,$E000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00A8,$0000,$00FF,$0000,$00AA,$0000,$FFFF,$0000
		dc.w	$F943,$0643,$FF80,$0000,$0005,$0000,$FFFF,$0000
		dc.w	$57CA,$0032,$FFFC,$0000,$1002,$1000,$0FFF,$0000
		dc.w	$BC02,$0000,$FC03,$0000,$A000,$0000,$FFF0,$0000
		dc.w	$0555,$000A,$0FFF,$0000,$05FD,$CA00,$CFFF,$0000
		dc.w	$4008,$0008,$FFF0,$0000,$A800,$0000,$FFFF,$0000
		dc.w	$AAF9,$0006,$FFFF,$0000,$4300,$4300,$80FF,$0000
		dc.w	$0557,$0000,$FFFF,$0000,$CA00,$3200,$FC00,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00D5,$0000,$00FF,$0000,$555F,$0000,$FFFF,$0000
		dc.w	$5024,$AFA4,$FFC3,$0000,$0AAA,$0000,$FFFF,$0000
		dc.w	$FA81,$057D,$FFFE,$0000,$2055,$2000,$1FFF,$0000
		dc.w	$E803,$1400,$FC03,$0000,$5550,$0000,$FFF0,$0000
		dc.w	$0AA5,$055F,$0FFF,$0000,$4297,$CD68,$CFFF,$0000
		dc.w	$AA04,$0004,$FFF8,$0000,$D555,$0000,$FFFF,$0000
		dc.w	$5F50,$00AF,$FFFF,$0000,$240A,$A400,$C3FF,$0000
		dc.w	$AAFA,$0005,$FFFF,$0000,$8100,$7D00,$FE00,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00FA,$0000,$00FF,$0000,$BFEA,$0015,$FFFF,$0000
		dc.w	$8521,$7FC0,$FFE7,$0000,$55FF,$0000,$FFFF,$0000
		dc.w	$5429,$ABFE,$FFFF,$0000,$0AAF,$0000,$3FFF,$0000
		dc.w	$5403,$A800,$FC03,$0000,$EAF0,$0000,$FFF0,$0000
		dc.w	$04AA,$0BFF,$0FFF,$0000,$C42A,$CFD5,$CFFF,$0000
		dc.w	$F550,$0000,$FFFC,$0000,$FABF,$0000,$FFFF,$0000
		dc.w	$EA85,$157F,$FFFF,$0000,$2155,$C000,$E7FF,$0000
		dc.w	$FF54,$00AB,$FFFF,$0000,$2900,$FE00,$FF00,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0057,$00A8,$00FF,$0000,$56B8,$A807,$FFFF,$0000
		dc.w	$AE82,$FEA0,$FEA7,$0140,$FAB5,$0540,$FFFF,$0000
		dc.w	$C574,$3FF5,$FFF5,$000A,$157A,$0005,$3FFF,$0000
		dc.w	$AC01,$0002,$FC03,$0000,$5D50,$A2A0,$FFF0,$0000
		dc.w	$05FA,$0FFA,$0FFA,$0005,$8D55,$8000,$8FFF,$4000
		dc.w	$5EA8,$A000,$FFFC,$0000,$5756,$A8A8,$FFFF,$0000
		dc.w	$B8AE,$07FE,$FFFE,$0001,$82FA,$A005,$A7FF,$4000
		dc.w	$B5C5,$403F,$FFFF,$0000,$7400,$F500,$F500,$0A00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00AA,$0055,$00FF,$0000,$9B45,$7C3F,$FFFF,$0010
		dc.w	$7527,$F520,$F527,$0AC0,$54DA,$ABE1,$FFFF,$0000
		dc.w	$2BA9,$FFA9,$FFA9,$8056,$2F54,$00AB,$3FFF,$0000
		dc.w	$5802,$0401,$FC03,$0000,$AA60,$55F0,$FFF0,$0000
		dc.w	$0F50,$0F50,$0F50,$00AF,$46AA,$0800,$0FFF,$C000
		dc.w	$2AF4,$D500,$FFFC,$0000,$AA9B,$557C,$FFFF,$0000
		dc.w	$4575,$3FF5,$FFF5,$100A,$2754,$20AB,$27FF,$C000
		dc.w	$DA2B,$E1FF,$FFFF,$0080,$A900,$A900,$A900,$5600
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0041,$00BF,$00FF,$0000,$5EBE,$FC06,$FFFE,$0001
		dc.w	$A0A2,$A005,$A007,$5FE0,$0AF5,$FFE0,$FFFF,$0000
		dc.w	$F505,$3500,$F500,$0AFF,$2A82,$157F,$3FFF,$0000
		dc.w	$A001,$0802,$F803,$0400,$0570,$FFF0,$FFF0,$0000
		dc.w	$0000,$0000,$0000,$0FFF,$0155,$0400,$07FF,$C800
		dc.w	$4154,$FEA8,$FFFC,$0000,$415E,$BFFC,$FFFF,$0000
		dc.w	$BEA0,$06A0,$FEA0,$015F,$A20A,$05FF,$07FF,$E000
		dc.w	$F5F5,$E035,$FFF5,$000A,$0500,$0000,$0000,$FF00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00AB,$00FF,$00FF,$0000,$F405,$F405,$F405,$0802
		dc.w	$0BE5,$0007,$0007,$FFE0,$5FA0,$FFA0,$FFA0,$0040
		dc.w	$285F,$2800,$2800,$17FF,$1157,$2FFF,$3FFF,$0000
		dc.w	$0002,$0003,$0003,$0000,$2FD0,$FFD0,$FFD0,$0020
		dc.w	$0500,$0500,$0500,$0AFF,$4000,$4000,$4000,$8000
		dc.w	$EA88,$FFF4,$FFFC,$0000,$ABF4,$FFF4,$FFF4,$0008
		dc.w	$050B,$0500,$0500,$02FF,$E55F,$07FF,$07FF,$E000
		dc.w	$A028,$A028,$A028,$4017,$5F00,$0000,$0000,$FF00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007A,$00FA,$00FA,$0005,$A004,$A000,$A000,$5C07
		dc.w	$BAA3,$0547,$0007,$FFE0,$D500,$D500,$D500,$2AE0
		dc.w	$25D5,$002A,$0000,$3FFF,$2AEA,$3FEA,$3FEA,$0015
		dc.w	$AF01,$0003,$0003,$FF00,$EA80,$EA80,$EA80,$1570
		dc.w	$0AA0,$0AA0,$0AA0,$055F,$0000,$4000,$4000,$8000
		dc.w	$5754,$57FC,$57FC,$A800,$7AA0,$FAA0,$FAA0,$055C
		dc.w	$04BA,$0005,$0000,$07FF,$A3D5,$47D5,$07D5,$E02A
		dc.w	$0025,$0000,$0000,$E03F,$D500,$2A00,$0000,$FF00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00D4,$00D4,$00D4,$002B,$2803,$0000,$0000,$FC07
		dc.w	$5006,$AFE6,$0006,$FFE1,$A140,$A000,$A000,$5FE0
		dc.w	$1A80,$057F,$0000,$3FFF,$3D45,$3D40,$3D40,$02BF
		dc.w	$AA00,$5501,$0003,$FF00,$F0A1,$F001,$F001,$0FFE
		dc.w	$E550,$FF50,$FF50,$00AF,$0000,$8000,$C000,$0000
		dc.w	$A2BC,$02BC,$02BC,$FD40,$D429,$D400,$D400,$2BFF
		dc.w	$7B50,$00AF,$0000,$FFFF,$06A1,$E6A0,$06A0,$E15F
		dc.w	$6BDA,$0005,$0000,$FFFF,$8000,$7F00,$0000,$FF00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0081,$0080,$0080,$007F,$7C02,$0005,$0000,$FC07
		dc.w	$8004,$7FE4,$02E4,$FFE3,$0BE0,$0000,$0000,$FFE0
		dc.w	$1400,$2BFF,$0017,$3FFF,$28AD,$2802,$2800,$17FF
		dc.w	$4000,$BF00,$0001,$FF00,$A5F1,$600E,$E000,$1FFF
		dc.w	$3A2B,$3A02,$3A03,$C5FC,$0000,$0000,$8000,$0000
		dc.w	$B514,$4014,$0014,$FFE8,$817D,$8002,$8000,$7FFF
		dc.w	$5280,$AD7F,$0002,$FFFF,$040B,$E400,$E400,$E3FF
		dc.w	$EA94,$156B,$0000,$FFFF,$0000,$FF00,$1700,$FF00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$001F,$0000,$0000,$00FF,$E800,$1407,$0000,$FC07
		dc.w	$0000,$FF40,$5FE0,$FFE7,$FF40,$00A0,$0000,$FFE0
		dc.w	$0000,$3FFA,$02FF,$3FFF,$15EA,$0015,$0000,$3FFF
		dc.w	$0000,$FF00,$0F01,$FF00,$BFAF,$6050,$E000,$1FFF
		dc.w	$C57B,$0002,$0003,$FFFC,$0000,$0000,$8000,$0000
		dc.w	$57A8,$A800,$0000,$FFFC,$1FEA,$0015,$0000,$FFFF
		dc.w	$0000,$FFFF,$005F,$FFFF,$00FF,$4000,$E000,$E7FF
		dc.w	$5000,$AFFF,$0002,$FFFF,$0000,$FA00,$FF00,$FF00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007D,$0002,$0000,$00FF,$5000,$AC07,$0003,$FC07
		dc.w	$0023,$F400,$FFC0,$FFC7,$EA80,$1560,$0000,$FFE0
		dc.w	$0001,$3FA0,$1FFE,$3FFE,$1540,$2ABF,$0000,$3FFF
		dc.w	$8D00,$F001,$FF03,$0000,$3540,$4ABF,$0000,$FFFF
		dc.w	$0550,$FAAE,$0000,$FFFF,$8000,$8000,$C000,$0000
		dc.w	$02A8,$FD54,$0000,$FFFC,$7D50,$02AF,$0000,$FFFF
		dc.w	$0000,$FFF4,$7BFF,$FFFF,$23EA,$0015,$C000,$C7FF
		dc.w	$8000,$7FFF,$03DF,$FFFF,$0100,$A000,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00A8,$0057,$0000,$00FF,$0000,$FC02,$0007,$FC07
		dc.w	$0AC5,$0022,$F500,$F507,$4000,$BFE0,$0000,$FFE0
		dc.w	$0056,$1001,$3FA9,$3FA9,$2000,$1FFF,$002B,$3FFF
		dc.w	$A602,$B903,$BF02,$4001,$2001,$DFFE,$400F,$FFF0
		dc.w	$9800,$07FF,$F00A,$0FFF,$4000,$C000,$4000,$8000
		dc.w	$0004,$FFF8,$D400,$FFFC,$A800,$57FF,$0003,$FFFC
		dc.w	$600A,$8200,$FFF5,$07F5,$C540,$22BF,$0000,$07FF
		dc.w	$0300,$FC10,$1FFF,$E03F,$5600,$0100,$A800,$A800
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$00FF,$0002,$00FF,$0000,$FC00,$FC07,$FC07
		dc.w	$7B00,$04E7,$8000,$8007,$0000,$FFE0,$17E0,$FFE0
		dc.w	$03D8,$0027,$3C00,$3C01,$0000,$3FEA,$15FF,$3FFF
		dc.w	$9502,$EA01,$FE01,$0103,$0000,$7FFF,$CBFF,$FFF0
		dc.w	$E000,$0FFA,$F57F,$0FFF,$4000,$8000,$8000,$C000
		dc.w	$0000,$57FC,$FFA8,$FFFC,$0000,$FFFF,$02FF,$FFFC
		dc.w	$387B,$C004,$FF80,$0780,$0000,$E7FD,$02BF,$07FF
		dc.w	$01C3,$5E00,$FFFC,$E03C,$D800,$2700,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$00FF,$003F,$00FF,$0003,$A004,$FC00,$FC00
		dc.w	$4020,$BFC3,$0001,$0007,$0000,$FD00,$FFE0,$FFE0
		dc.w	$1A00,$25FC,$0002,$0003,$0000,$3D40,$3FFF,$3FFF
		dc.w	$0000,$0003,$0000,$0003,$000B,$FE84,$FFFF,$FFF0
		dc.w	$5000,$0F50,$FFFF,$0FFF,$0000,$0000,$C000,$C000
		dc.w	$0000,$02BC,$FFFC,$FFFC,$0002,$FFA1,$3FFF,$FFFC
		dc.w	$D340,$04BF,$F800,$0000,$2000,$C7A8,$07FF,$07FF
		dc.w	$169A,$0825,$FFC0,$E000,$0100,$FE00,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$00E8,$00FF,$00FF,$A400,$0007,$5800,$5800
		dc.w	$4FE4,$B007,$0007,$0003,$053F,$4000,$FAC0,$FAC0
		dc.w	$827D,$7D82,$0001,$0002,$00AF,$2800,$3F50,$3F50
		dc.w	$E0E0,$1F03,$0013,$0013,$0290,$A000,$FD60,$FD60
		dc.w	$002B,$0A00,$0FD4,$0FD4,$C000,$0000,$0000,$0000
		dc.w	$F500,$0014,$0AFC,$0AFC,$00A4,$E800,$FF58,$FF58
		dc.w	$004F,$07B0,$0000,$0000,$E015,$0500,$07EA,$07EA
		dc.w	$E002,$003D,$0000,$0000,$7F00,$8000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0003,$0000,$00FC,$00FC,$F400,$0807,$0000,$0000
		dc.w	$F804,$00E0,$07E5,$07E3,$1FB0,$004F,$E000,$E000
		dc.w	$07C2,$F806,$003B,$003C,$0FEA,$0015,$3000,$3000
		dc.w	$0380,$FC10,$0073,$0073,$0FD0,$0020,$F000,$F000
		dc.w	$03FA,$0005,$0C00,$0C00,$8000,$4000,$0000,$0000
		dc.w	$57F0,$A800,$000C,$000C,$03F4,$0008,$FC00,$FC00
		dc.w	$00F8,$0700,$0007,$0007,$01FD,$E002,$E600,$E600
		dc.w	$4007,$A038,$0000,$0000,$C000,$0700,$3F00,$3F00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00FF,$0000,$0000,$0000,$8007,$7C00,$0000,$0000
		dc.w	$0002,$15E0,$FFA6,$FFE1,$7C07,$83F8,$0000,$8000
		dc.w	$F80E,$00A4,$07F7,$07F8,$3A00,$05FF,$0000,$0000
		dc.w	$3E03,$C030,$01F0,$01F0,$FE00,$01F0,$0000,$0000
		dc.w	$0E80,$017F,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$005C,$FFA0,$0000,$0000,$FF80,$007C,$0000,$0000
		dc.w	$0700,$0015,$00FF,$00FF,$0740,$E0BF,$A000,$E000
		dc.w	$0038,$E000,$0007,$0007,$0000,$AF00,$FD00,$FF00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0080,$007F,$0000,$0000,$0404,$F800,$0003,$0003
		dc.w	$0004,$AFE4,$FE03,$FFE0,$A03F,$5FC0,$C800,$3800
		dc.w	$6035,$0559,$9FDE,$9FE0,$0001,$3FFE,$0000,$0000
		dc.w	$F002,$00F1,$0FE0,$0FF0,$0010,$FFE0,$0000,$0000
		dc.w	$0000,$0FFF,$0000,$0000,$4000,$8000,$0000,$0000
		dc.w	$8000,$7FFC,$0000,$0000,$8004,$7FF8,$0000,$0000
		dc.w	$0400,$00AF,$03FE,$03FF,$0000,$E7FF,$0000,$E000
		dc.w	$2020,$C005,$001F,$001F,$0030,$7F10,$F030,$FF02
		dc.w	$0472,$6214,$4A17,$6A60,$0200,$0000,$0600,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0055,$002C,$00FC,$0003,$5805,$7805,$7805,$8402
		dc.w	$D562,$9E82,$9FE1,$6000,$58D0,$07CF,$FFC6,$003F
		dc.w	$AEA8,$2CF0,$2CFE,$D300,$2DAA,$0C3F,$0C3F,$33C0
		dc.w	$A2B1,$FD40,$FFF3,$0000,$5560,$B1E0,$F1E0,$0E10
		dc.w	$0B6A,$030F,$030F,$0CF0,$8000,$0000,$C000,$0000
		dc.w	$55B4,$FC30,$FC30,$03CC,$5558,$2C78,$FC78,$0384
		dc.w	$05D5,$059E,$059F,$0260,$65B5,$8187,$E187,$0678
		dc.w	$402E,$802C,$E02C,$0013,$AB48,$F428,$FF68,$0000
		dc.w	$4004,$0066,$0486,$C4E0,$0500,$0000,$8D00,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00AC,$0013,$00FF,$0000,$A002,$5C02,$FC02,$0005
		dc.w	$08A3,$EF43,$0FE0,$B000,$AD1A,$82F9,$7FF8,$0007
		dc.w	$5052,$9762,$107C,$ED80,$1014,$13DF,$101F,$2E60
		dc.w	$17A2,$E810,$FFF3,$0000,$B280,$4D70,$FFF0,$0000
		dc.w	$0405,$04F6,$0407,$0B98,$8000,$0000,$C000,$0000
		dc.w	$2808,$FBC8,$F808,$0674,$ACA0,$135C,$FFFC,$0000
		dc.w	$0208,$02EF,$020F,$05B0,$A202,$427B,$E203,$05CC
		dc.w	$C010,$0017,$E010,$002D,$4522,$7A0A,$7F6A,$8000
		dc.w	$0002,$0483,$00C3,$24C4,$0B00,$0500,$0F00,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$004A,$0005,$00FF,$0000,$2805,$8401,$FC01,$0006
		dc.w	$1460,$5F80,$1FE0,$E000,$E54B,$E03F,$1FFF,$0000
		dc.w	$694C,$0B8C,$09F0,$F600,$29A0,$283F,$283F,$17C0
		dc.w	$BD41,$4030,$FFF3,$0000,$28A0,$1610,$FFF0,$0000
		dc.w	$0A6B,$0A0C,$0A0F,$05F0,$0000,$0000,$C000,$0000
		dc.w	$0594,$FC14,$FC14,$03E8,$4A28,$0584,$FFFC,$0000
		dc.w	$0514,$015F,$011F,$06E0,$6535,$8506,$E507,$02F8
		dc.w	$8028,$000A,$E008,$0037,$A348,$FC42,$FF2A,$0000
		dc.w	$8004,$8450,$8460,$6476,$2400,$A800,$8C00,$0100
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
		EVEN
* <

MUSIC: 		; Not compressed please !
	incbin	*.mus
	even

******************************************************************
	SECTION	BSS
******************************************************************

bss_start:

* Full data here :
* >
TXTPTR:           DS.L      1 
TXTPHASE:         DS.W      1 
WAVPTR:           DS.L      1 
LETADR:           DS.B      8 
NEWASKY:          DS.B      256 
FNTPTR1:          DS.L      1 
FNTPTR2:          DS.L      1 
FNTBUF1:          DS.B      640 
FNTBUF2:          DS.B      640 
FNTEND2:          DS.B      50

* <

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

bss_end:

******************************************************************
	END
******************************************************************
