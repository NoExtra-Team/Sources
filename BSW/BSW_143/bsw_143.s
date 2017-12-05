* BSW_143.PRG

* // Original code : Zorro2/NoExtra 	// *
* // Gfx logo 	   : Mister.A/NoExtra 	// *
* // Music 	   : 	// *
* // Release date  : 11/05/2007		// *

***********************************************
	opt	o-,d-
***********************************************

	SECTION	TEXT

***********************************************
BOTTOM_BORDER	equ	0	; 0 = I use it and 1 = no need !
PATTERN		equ	$0	; put $0 to see nothing
SEEMYVBL	equ	0   	; if you press ALT : 0 = see cpu & 1 = see nothing
DECAL_STAR	equ	160*38
DECAL_HBL	equ	112-5
POS_SCROLLING	equ	((160*145)+0)
DECAL_TEXT	equ	((160*147)+0)
gemdos        equ	1
crawcin       equ	7
cconws        equ	9
mshrink       equ	$4a
pexec         equ	$4b
*adresse des differentes donnees
screens	=	$90000
sizscr	=	100*160
dekrast	=	screens+2*sizscr
curve1	=	dekrast+16*32
curve2	=	curve1+2048*2
*parametre de la courbe
amp1	=	110
phi1	=	2
amp2	=	40
phi2        =	12
*essayer aussi 110,2,40,256;130,2,16,16,...
*parametres de la routine de rasters
nbrast	=	85
rastoff	=	1
hborder	=	39
bltline	reg d0-d6/a2-a6
***********************************************

Start

	jmp	ON_Y_VA

RUN
	bsr	BYEBYE

EXECUTE
	move.w	#$19,-(a7)		* Dgetdrive
	trap	#1			* Recup le numÇro
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

	pea        environ       ;Postchargement du programme
	pea        params
	move.l	  NOMPRG,-(SP)
	clr.w      -(sp)         ;Nul -> Charger et lancer immÇdiatement
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

	bra.s	Fin						

EXIT	
	bsr	BYEBYE
FIN	
	CLR.W     -(A7) 	;PTERM0
	TRAP      #1

	*  FIN  *

ON_Y_VA:
	
	clr.l	-(sp)
	move.w	#32,-(sp)
	trap	#1
	addq.l	#6,sp
	move.l	d0,Save_stack

	bsr	Init_screens

	bsr	Save_and_init_a_st

	bsr	fadein

;Le detournement des bombes.
	MOVE.L	#Reset,$8.W
	MOVE.L	#Reset,$C.W
	MOVE.L	#Reset,$10.W
	MOVE.L	#Reset,$14.W
	MOVE.L	#Reset,$18.W
	MOVE.L	#Reset,$1C.W
	MOVE.L	#Reset,$20.W
	MOVE	#$2300,sr
	
	bsr	Init_screens_P1

	bsr	Init_P1
	
	lea     PalNoeXtra,a2
	bsr     fadeon	

	movem.l	d0-d7/a0-a6,-(a7)
*precalculer les tables sinus
	bsr	fixsintab
*predecaler les rasters
	bsr	vrastshift	
	BSR       SCRTXT
	MOVE.B    TREIZE,ZERO     
	movem.l	(a7)+,d0-d7/a0-a6
	
	bsr	delay

	bsr     fadeoff
	
	bsr	Init_screens_P2

	BSR	PUT_TEXT
	
	bsr	Init_P2
	
******************************************************************************
		
Main_rout:

	bsr	Wait_vbl

	IFEQ	SEEMYVBL
	clr.b	$ffff8240.w
	ENDC

*
	Bsr	clear1plscreen

	bsr	vrast
	BSR	SCROLL

*

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
	cmpi.b	#$39,$FFFFFC02.w	*	ESP
	beq	RunCrc
	cmpi.b	#$01,$fffffc02.w	* ESC
	beq	EXIT
* <--
	bra	Main_rout

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
RunCRC:
	move.l	#PROGCRC,NOMPRG
	bra	RUN

BYEBYE
	bsr	Restore_st
                  
	MOVEA.L   $44E.W,A0 
	MOVE.W    #$1F3F,D0 
.loop2: CLR.L     (A0)+ 
  DBF       D0,.loop2

	move.l	Save_stack,-(sp)
	move.w	#32,-(sp)
	trap	#1
	addq.l	#6,sp
	RTS

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
	
	LEA   Pal,A0 
  MOVEA.L   #$FF8240,A1 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
  MOVE.L    (A0)+,(A1)+ 
	
	IFEQ	BOTTOM_BORDER
	CLR.B   $FFFFFA1B.W
	move.l	#HBL_H,$120.w
	move.b	#35,$fffffa21.w
	move.b	#8,$fffffa1b.w
	ENDC

	jsr 	(MUSIC+8)			; call music

	movem.l	(a7)+,d0-d7/a0-a6
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

Init_P1:	movem.l	d0-d7/a0-a6,-(a7)

	jsr	MUSIC+0			; init music

	lea	Vbl0(pc),a0
	move.l	a0,$70.w

	movem.l	(a7)+,d0-d7/a0-a6
	rts

Init_P2:	movem.l	d0-d7/a0-a6,-(a7)

	lea	Vbl(pc),a0
	move.l	a0,$70.w

	lea	Pal(pc),a0
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

	IFEQ	BOTTOM_BORDER
	sf	$fffffa21.w
	sf	$fffffa1b.w
	move.l	#HBL_H,$120.w
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

HBL_H:
      MOVE.B    #0,$FFFFFA1B.W
      MOVEM.L   A0-A2/D0-D1,-(A7) 
      MOVEA.L   DATA_R1,A0
      LEA       $FFFF8240.W,A1
      LEA       $FFFFFA21.W,A2
      BCLR      #0,-18(A2)
      MOVE.L    #HBL_B,$120.W 
      MOVE.B    #DECAL_HBL,(A2) * 132
      MOVE.B    #8,-6(A2) 
      MOVE.B    (A2),D0 
.loop:CMP.B     (A2),D0 
      BEQ.S     .loop 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
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
      MOVE.W    (A0)+,(A1)
      MOVE.W    (A0)+,(A1)
      MOVE.W    (A0)+,(A1)
      MOVE.W    (A0)+,(A1)
      MOVE.W    #0,(A1) 
      MOVEM.L   (A7)+,A0-A2/D0-D1 
      ADDQ.L    #2,DATA_R0
      CMPI.L    #DATA_R4,DATA_R0
      BNE.S     .end 
      MOVE.L    #DATA_R2,DATA_R0
.end: RTE 

HBL_B:MOVE.B    #0,$FFFFFA1B.W
      MOVEM.L   A0-A2/D0-D1,-(A7) 
      MOVEA.L   DATA_R1,A0
      LEA       $FFFF8240.W,A1
      LEA       $FFFFFA21.W,A2
      BCLR      #0,-18(A2)
      MOVE.L    #RASTER_HAUT,$120.W 
      MOVE.B    #32-30,(A2) * 
      MOVE.B    #8,-6(A2) 
      MOVE.B    (A2),D0 
.loop:CMP.B     (A2),D0 
      BEQ.S     .loop 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    -(A0),(A1)
      MOVE.W    #0,(A1) 
      MOVEM.L   (A7)+,A0-A2/D0-D1 
      ADDQ.L    #2,DATA_R1
      CMPI.L    #DATA_R4,DATA_R1
      BNE.S     .end 
      MOVE.L    #DATA_R2,DATA_R1
.end: RTE 

RASTER_HAUT:

      CLR.B     $FFFFFA1B.W 

      move.l	#$0000334,$ffff8240.w ; text color
      
      move.l	#$4340656,$ffff8250.w	; scrolltext color
	
      BCLR      #0,$FFFFFA0F.W 

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
.fill:
	move.l	#PATTERN,(a6)+
	dbra	d1,.fill

	movea.l	Zorro_scr2,a6
	move.w	#Zorro_screen2_len/4-1,d1
.fill2:
	move.l	#PATTERN,(a6)+
	dbra	d1,.fill2

	movem.l	(a7)+,d0-d7/a0-a6
	rts
	
Init_screens_P1:	movem.l	d0-d7/a0-a6,-(a7)

	movea.l	Zorro_scr1,a1
	adda.l	#160*76,a1
	movea.l	#LogoNoeXtra,a0
	move.l	#7999-6800+180,d0
aff:	move.l	(a0)+,(a1)+
	dbf	d0,aff

	move.l	Zorro_scr1,d0
	move.b	d0,d1
	lsr.w	#8,d0
	move.b	d0,$ffff8203.w
	swap	d0
	move.b	d0,$ffff8201.w
	move.b	d1,$ffff820d.w
	
	movem.l	(a7)+,d0-d7/a0-a6
	rts	

Init_screens_P2:	movem.l	d0-d7/a0-a6,-(a7)

	movea.l	Zorro_scr1,a6
	move.w	#Zorro_screen1_len/4-1,d1
.fill:
	move.l	#PATTERN,(a6)+
	dbra	d1,.fill

	movea.l	Zorro_scr2,a6
	move.w	#Zorro_screen2_len/4-1,d1
.fill2:
	move.l	#PATTERN,(a6)+
	dbra	d1,.fill2

DECALH	equ	0*160

	movea.l	Zorro_scr1,a0
	lea	DECALH(a0),a0
	movea.l	Zorro_scr2,a1
	lea	DECALH(a1),a1
	move.l	#Image_Logo,a2
	move.l	#7999-6600,d0
.cpy:
	move.l	(a2),(a0)+
	move.l	(a2)+,(a1)+
	dbf	d0,.cpy

	move.l	Zorro_scr1,d0
	move.b	d0,d1
	lsr.w	#8,d0
	move.b	d0,$ffff8203.w
	swap	d0
	move.b	d0,$ffff8201.w
	move.b	d1,$ffff820d.w
		
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

************************************************
*                                              *
************************************************
PUT_TEXT:
      MOVE.W    #0,INIT_T0
      MOVE.W    #0,INIT_T1
      LEA       PTEXTE,A5
PUT_LINES:
      MOVEQ     #0,D1 
      MOVE.B    (A5)+,D1
      CMPI.B    #$FF,D1 
      BEQ     END_TEXT 
      CMPI.B    #0,D1 
      BNE.S     .no_end 
      CLR.W     INIT_T0 
      ADDI.W    #1,INIT_T1
      BRA.S     PUT_LINES 
.no_end:
      SUBI.B    #$20,D1 
      MULS      #6,D1 
      LEA       FONTE,A0
      ADDA.W    D1,A0 
      MOVEA.L   Zorro_scr1,A1
      LEA       DECAL_TEXT(A1),A1	*	no plan    
      MOVE.W    INIT_T0,D1
      BTST      #0,D1 
      BEQ.S     .putc 
      LEA       1(A1),A1
.putc:DIVS      #2,D1 
      MULS      #8,D1 
      ADDA.W    D1,A1 
      MOVE.W    INIT_T1,D1
      MULS      #$3C0,D1
      ADDA.W    D1,A1 
      MOVE.B    (A0)+,(A1)
      MOVE.B    (A0)+,160(A1) 
      MOVE.B    (A0)+,320(A1) 
      MOVE.B    (A0)+,480(A1) 
      MOVE.B    (A0)+,640(A1) 
      MOVE.B    (A0)+,800(A1) 
      ADDI.W    #1,INIT_T0
      BRA	PUT_LINES 
END_TEXT:
	movea.l Zorro_scr1,a1
	LEA       DECAL_TEXT(A1),A1	*	no plan    
	movea.l Zorro_scr2,a0
	LEA       DECAL_TEXT(A0),A0	*	no plan    
	moveq	#64,d7		; lines
.loop:
a set 0
b set 0
	rept 20
	move.w	a(a1),b(a0)
a set a+8
b set b+8
	endr	
	lea	160(a1),a1
	lea	160(a0),a0
	dbf	d7,.loop
			RTS 

fixsintab
	lea	sintab,a0
	lea	curve1,a1
	lea	curve2,a2
	moveq	#0,d1
	moveq	#0,d2
	move	#512-1,d0
.fix
	moveq	#0,d1
	moveq	#0,d2
	move	(a0)+,d1
	move	d1,d2
	muls	#amp1,d1
	muls	#amp2,d2
	move.l	d1,(a1)
	move.l	d1,2048(a1)
	lea	4(a1),a1
	move.l	d2,(a2)
	move.l	d2,2048(a2)
	lea	4(a2),a2
	dbf	d0,.fix
	rts
*
*ici on decale les petits sprites
*et on calcule leurs masques
vrastshift
	lea	dekrast,a0
	moveq	#0,d6
	move	#16-1,d7
.rastshift
	lea	rast,a1
*d0-d3 contiennent les donnees du
*sprite, et d4 le mot de masque,
*le meme sur les 4 plans.
	movem.l	myzero,d0-d4
	move	(a1)+,d0
	move	(a1)+,d1
	move	(a1)+,d2
	move	(a1)+,d3
*calcul du masque
	move	d0,d4
	or	d1,d4
	or	d2,d4
	or	d3,d4
	not.l	d4
*decalage et sauvegarde de la
*premiere moitie du sprite. on
*interlace le masque et les
*donnees pour pouvoir les caser
*2 plans par 2 plans avec des .l
	ror.l	d6,d0
	ror.l	d6,d1
	ror.l	d6,d2
	ror.l	d6,d3
	ror.l	d6,d4
	move	d4,(a0)+
	move	d4,(a0)+
	move	d0,(a0)+
	move	d1,(a0)+
	move	d4,(a0)+
	move	d4,(a0)+
	move	d2,(a0)+
	move	d3,(a0)+
*on swappe et on sauve la
*deuxieme moitie...
	swap	d0
	swap	d1
	swap	d2
	swap	d3
	swap	d4
	move	d4,(a0)+
	move	d4,(a0)+
	move	d0,(a0)+
	move	d1,(a0)+
	move	d4,(a0)+
	move	d4,(a0)+
	move	d2,(a0)+
	move	d3,(a0)+
	addq	#1,d6
	dbf	d7,.rastshift
	rts

vrast
	movea.l	Zorro_scr1,a1
	lea	hborder*160(a1),a1
*effacer la ligne a afficher
	lea linebuf,a0
	moveq	#0,d0
	rept	40
	move.l	d0,(a0)+
	endr
*charger les valeurs courantes
*des angles
	move	ang1,curang1
	move	ang2,curang2
*calcul et affichage...
	move	#nbrast-1,d7
.aff
*calcul de l'abscisse du sprite
	lea	dekrast,a2
	lea	linebuf,a0
	move	#10,d6
	moveq	#0,d0
	moveq	#0,d2
	lea	curve1,a5
	move	curang1,d0
	move.l	0(a5,d0.w),d0
	add.w	#phi1*4,curang1
	lea	curve2,a5
	move	curang2,d2
	move.l	0(a5,d2.w),d2
	add.w	#phi1*4,curang1
	lea	curve2,a5
	move	curang2,d2
	move.l	0(a5,d2.w),d2
	add.w	#phi2*4,curang2
	andi.w	#511*4,curang2
	add.l	d2,d0
	asr.l	d6,d0
	addi.w	#160,d0
	move	d0,d1
	andi	#$f,d1
	andi	#$fff0,d0
	lsr.w	#1,d0
	adda.w	d0,a0
	lsl.w	#5,d1
	adda.w	d1,a2
*affiche le bout de raster
	movem.l	(a0),d0-d3
	and.l	(a2)+,d0
	or.l	(a2)+,d0
	and.l	(a2)+,d1
	or.l	(a2)+,d1
	and.l	(a2)+,d2
	or.l	(a2)+,d2
	and.l	(a2)+,d3
	or.l	(a2)+,d3
	movem.l	d0-d3,(a0)
*afficher la ligne
	lea	linebuf,a0
	movem.l	(a0),bltline
n set 0
	rept	rastoff
	movem.l	bltline,n(a1)
m set n+160
	endr
	movem.l	48(a0),bltline
n set 0
	rept rastoff
	movem.l	bltline,n+48(a1)
n set n+160
	endr
	movem.l	96(a0),bltline
n set 0
	rept rastoff
	movem.l	bltline,n+96(a1)
n set n+160
	endr
	movem.l	144(a0),d0-d3
n set 0
	rept	rastoff
	movem.l	d0-d3,n+144(a1)
n set n+160
	endr
	lea	rastoff*160(a1),a1
	dbf	d7,.aff
	
*	jmp	non

nbline	equ	18
			
*et on remplit la fin de l'ecran
	lea linebuf,a0

	movem.l	(a0),bltline
n set 0
	rept	nbline
	movem.l	bltline,n(a1)
n set n+160
	endr

	movem.l	48(a0),bltline
n set 0
	rept	nbline
	movem.l	bltline,n+48(a1)
n set n+160
	endr

	movem.l	96(a0),bltline
n set 0
	rept	nbline
	movem.l	bltline,n+96(a1)
n set n+160
	endr

	movem.l	144(a0),d0-d3
n set 0
	rept	nbline
	movem.l	d0-d3,n+144(a1)
n set n+160
	endr
non:
	
	add.w	#2*4,ang1
	andi.w	#511*4,ang1
	add.w	#3*4,ang2
	andi.w	#511*4,ang2
	
	rts

clear1plscreen
		MOVE.L Zorro_scr1,A0
		lea	((160*145)+6)(a0),a0
		MOVEQ #0,D1
		MOVEQ #6,D0
i		SET 0
.lp		
		REPT 160/1
		MOVE.W D1,i(A0)
i		SET i+8
		ENDR
		LEA (160*8)(A0),A0
		DBF D0,.lp
		RTS
							
SCRTXT:           LEA       TEXTE,A0
.repeat:          MOVE.B    (A0)+,D0
                  BMI.S     .rts 
                  LEA       ASCII,A1
.nok:             MOVE.B    (A1)+,D1
                  BMI.S     .neg 
                  MOVE.B    (A1)+,D2
                  CMP.B     D0,D1 
                  BNE.S     .nok 
                  MOVE.B    D2,-1(A0) 
                  BRA.S     .repeat 
.neg:             MOVE.B    #0,-1(A0) 
                  BRA.S     .repeat 
.rts:             RTS 

SCROLL:           MOVEA.L   Zorro_scr1,A1
                  LEA       POS_SCROLLING(A1),A1
                  MOVEA.L   A1,A2 
                  MOVEA.L   PTR_MOUVEMENT,A0
                  MOVEQ     #0,D0 
                  MOVE.B    (A0),D0 
                  MULU      #$A0,D0 
                  ADDA.L    D0,A1 
                  ADDQ.L    #1,A0 
                  CMPA.L    #MYEND,A0 
                  BLT.S     .next 
                  MOVEA.L   #MOUVEMENT,A0 
.next:            MOVE.L    A0,PTR_MOUVEMENT
                  LEA       BUFFER,A0
                  MOVEQ     #0,D0 
                  MOVE.W    COMPTEUR1,D0
                  MULU      #$460,D0
                  ADDA.L    D0,A0 
                  ADDA.L    COMPTEUR2,A0
                  
                  MOVE.W    #$D,D7
.loop:            MOVE.W    (A0)+,6(A1) 
                  MOVE.W    (A0)+,14(A1)
                  MOVE.W    (A0)+,22(A1)
                  MOVE.W    (A0)+,30(A1)
                  MOVE.W    (A0)+,38(A1)
                  MOVE.W    (A0)+,46(A1)
                  MOVE.W    (A0)+,54(A1)
                  MOVE.W    (A0)+,62(A1)
                  MOVE.W    (A0)+,70(A1)
                  MOVE.W    (A0)+,78(A1)
                  MOVE.W    (A0)+,86(A1)
                  MOVE.W    (A0)+,94(A1)
                  MOVE.W    (A0)+,102(A1) 
                  MOVE.W    (A0)+,110(A1) 
                  MOVE.W    (A0)+,118(A1) 
                  MOVE.W    (A0)+,126(A1) 
                  MOVE.W    (A0)+,134(A1) 
                  MOVE.W    (A0)+,142(A1) 
                  MOVE.W    (A0)+,150(A1) 
                  MOVE.W    (A0)+,158(A1) 
                  LEA       40(A0),A0 
                  LEA       160(A1),A1
                  DBF       D7,.loop
                  
                  LEA       BUFFER,A0
                  MOVEQ     #0,D3 
                  MOVE.W    COMPTEUR1,D3
                  MOVE.L    D3,D4 
                  MULU      #$460,D4
                  ADDA.L    D4,A0 
                  ADDA.L    COMPTEUR2,A0
                  MOVEA.L   A0,A1 
                  ADDA.L    #$28,A1 
                  MOVEA.L   PTR_TEXTE,A2
                  MOVEQ     #0,D0 
                  MOVEQ     #0,D1 
                  MOVE.B    -1(A2),D0 
                  MOVE.B    (A2),D1 
                  MOVE.L    D3,D4 
                  LSL.W     #1,D4 
                  LEA       POSITION,A2
                  MOVE.W    0(A2,D4.L),D3 
                  MULU      #$1C,D0 
                  MULU      #$1C,D1 
                  LEA       FONT_VGT,A2
                  MOVEA.L   A2,A6 
                  ADDA.L    D0,A2 
                  ADDA.L    D1,A6 
                  MOVE.W    #$D,D7
.loop0:           MOVE.W    (A6)+,D4
                  SWAP      D4
                  MOVE.W    (A2)+,D4
                  ROL.L     D3,D4 
                  MOVE.W    D4,(A0) 
                  MOVE.W    D4,(A1) 
                  LEA       80(A0),A0 
                  LEA       80(A1),A1 
                  DBF       D7,.loop0
                  ADDI.W    #1,COMPTEUR1
                  CMPI.W    #3,COMPTEUR1
                  BLE.S     rts
                  MOVE.W    #0,COMPTEUR1
                  MOVEA.L   PTR_TEXTE,A0
                  ADDA.L    #1,A0 
                  CMPI.B    #$FF,(A0) 
                  BNE.S     .next0 
                  MOVEA.L   #TEXTE,A0 
.next0:           MOVE.L    A0,PTR_TEXTE
                  ADDI.L    #2,COMPTEUR2
                  CMPI.L    #$26,COMPTEUR2
                  BLE.S     rts 
                  MOVE.L    #0,COMPTEUR2
rts:              RTS

fadein:					 	move.l	#$777,d0
deg								bsr.s	wart
									bsr.s	wart
									bsr.s	wart
									lea	$ffff8240.w,a0
									moveq	#15,d1
chg1							move.w	d0,(a0)+
									dbf	d1,chg1
									sub.w	#$111,d0
									bne.s	deg
									clr.w	$ffff8240.w
									rts

wart							move.l	d0,-(sp)
									move.l	$466.w,d0
att								cmp.l	$466.w,d0
									beq.s	att
									move.l	(sp)+,d0
									rts

fadeon:
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

delay:
  MOVE.W     #$09F/2,D0 
.synch:
	BSR       Wait_vbl
	sub.w	#1,d0
	cmp.w	#0,d0	
	bne.s	.synch
	rts	
													
******************************************************************

	SECTION	DATA

Pal:	
	dc.w	$0000,$0001,$0889,$0112,$0192,$092A,$02A3,$0A3B
	dc.w	$03B4,$0B4C,$04C5,$0455,$0CDD,$0566,$0DEE,$0677

; Rasters datas
DATA_R0:
	dc.l	DATA_R2
DATA_R1:
	dc.l	DATA_R3
	dc.l	DATA_R4
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0001,$0001
	dc.w	$0002,$0002,$0003,$0003
	dc.w	$0004,$0004,$0005,$0005
	dc.w	$0006,$0006,$0007,$0007
	dc.w	$0017,$0017,$0027,$0027
	dc.w	$0037,$0037,$0047,$0047
	dc.w	$0057,$0057,$0067,$0067
	dc.w	$0077,$0077,$0076,$0076
	dc.w	$0277,$0277,$0267,$0267
	dc.w	$0257,$0257,$0247,$0247
	dc.w	$0347,$0347,$0447,$0447
	dc.w	$0547,$0547,$0647,$0647
	dc.w	$0747,$0747,$0737,$0737
	dc.w	$0727,$0727,$0717,$0717
	dc.w	$0707,$0707,$0705,$0705
	dc.w	$0704,$0704,$0703,$0703
	dc.w	$0702,$0702,$0701,$0701
	dc.w	$0700,$0700,$0710,$0710
	dc.w	$0720,$0720,$0730,$0730
	dc.w	$0740,$0740,$0750,$0750
	dc.w	$0760,$0760,$0770,$0770
	dc.w	$0771,$0771,$0772,$0772
	dc.w	$0773,$0773,$0774,$0774
	dc.w	$0775,$0775,$0776,$0776
	dc.w	$0777,$0777,$0677,$0677
	dc.w	$0577,$0577,$0477,$0477
	dc.w	$0377,$0377,$0267,$0267
	dc.w	$0157,$0157,$0047,$0047
	dc.w	$0037,$0037,$0027,$0027
	dc.w	$0017,$0017,$0027,$0027
	dc.w	$0037,$0037,$0047,$0047
	dc.w	$0057,$0057,$0067,$0067
	dc.w	$0077,$0077,$0076,$0076
	dc.w	$0277,$0277,$0267,$0267
	dc.w	$0257,$0257,$0247,$0247
	dc.w	$0347,$0347,$0447,$0447
	dc.w	$0547,$0547,$0647,$0647
	dc.w	$0747,$0747,$0737,$0737
	dc.w	$0727,$0727,$0717,$0717
	dc.w	$0707,$0707,$0705,$0705
	dc.w	$0604,$0604,$0503,$0503
	dc.w	$0402,$0402,$0301,$0301
	dc.w	$0200,$0200,$0100,$0100
DATA_R2:
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0001,$0001
	dc.w	$0002,$0002,$0003,$0003
	dc.w	$0004,$0004,$0005,$0005
	dc.w	$0006,$0006,$0007,$0007
	dc.w	$0017,$0017,$0027,$0027
	dc.w	$0037,$0037,$0047,$0047
	dc.w	$0057,$0057,$0067,$0067
	dc.w	$0077,$0077,$0076,$0076
	dc.w	$0277,$0277,$0267,$0267
	dc.w	$0257,$0257,$0247,$0247
	dc.w	$0347,$0347,$0447,$0447
	dc.w	$0547,$0547,$0647,$0647
	dc.w	$0747,$0747,$0737,$0737
	dc.w	$0727,$0727,$0717,$0717
	dc.w	$0707,$0707,$0705,$0705
	dc.w	$0704,$0704,$0703,$0703
	dc.w	$0702,$0702,$0701,$0701
	dc.w	$0700,$0700,$0710,$0710
	dc.w	$0720,$0720,$0730,$0730
	dc.w	$0740,$0740,$0750,$0750
	dc.w	$0760,$0760,$0770,$0770
	dc.w	$0771,$0771,$0772,$0772
	dc.w	$0773,$0773,$0774,$0774
	dc.w	$0775,$0775,$0776,$0776
	dc.w	$0777,$0777,$0677,$0677
	dc.w	$0577,$0577,$0477,$0477
	dc.w	$0377,$0377,$0267,$0267
	dc.w	$0157,$0157,$0047,$0047
	dc.w	$0037,$0037,$0027,$0027
	dc.w	$0017,$0017,$0027,$0027
	dc.w	$0037,$0037,$0047,$0047
	dc.w	$0057,$0057,$0067,$0067
	dc.w	$0077,$0077,$0076,$0076
	dc.w	$0277,$0277,$0267,$0267
	dc.w	$0257,$0257,$0247,$0247
	dc.w	$0347,$0347,$0447,$0447
	dc.w	$0547,$0547,$0647,$0647
	dc.w	$0747,$0747,$0737,$0737
	dc.w	$0727,$0727,$0717,$0717
	dc.w	$0707,$0707,$0705,$0705
	dc.w	$0604,$0604,$0503,$0503
	dc.w	$0402,$0402,$0301,$0301
	dc.w	$0200,$0200,$0100,$0100
DATA_R3:
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0001,$0001
	dc.w	$0002,$0002,$0003,$0003
	dc.w	$0004,$0004,$0005,$0005
	dc.w	$0006,$0006,$0007,$0007
	dc.w	$0017,$0017,$0027,$0027
	dc.w	$0037,$0037,$0047,$0047
	dc.w	$0057,$0057,$0067,$0067
	dc.w	$0077,$0077,$0076,$0076
	dc.w	$0277,$0277,$0267,$0267
	dc.w	$0257,$0257,$0247,$0247
	dc.w	$0347,$0347,$0447,$0447
	dc.w	$0547,$0547,$0647,$0647
	dc.w	$0747,$0747,$0737,$0737
	dc.w	$0727,$0727,$0717,$0717
	dc.w	$0707,$0707,$0705,$0705
	dc.w	$0704,$0704,$0703,$0703
	dc.w	$0702,$0702,$0701,$0701
	dc.w	$0700,$0700,$0710,$0710
	dc.w	$0720,$0720,$0730,$0730
	dc.w	$0740,$0740,$0750,$0750
	dc.w	$0760,$0760,$0770,$0770
	dc.w	$0771,$0771,$0772,$0772
	dc.w	$0773,$0773,$0774,$0774
	dc.w	$0775,$0775,$0776,$0776
	dc.w	$0777,$0777,$0677,$0677
	dc.w	$0577,$0577,$0477,$0477
	dc.w	$0377,$0377,$0267,$0267
	dc.w	$0157,$0157,$0047,$0047
	dc.w	$0037,$0037,$0027,$0027
	dc.w	$0017,$0017,$0027,$0027
	dc.w	$0037,$0037,$0047,$0047
	dc.w	$0057,$0057,$0067,$0067
	dc.w	$0077,$0077,$0076,$0076
	dc.w	$0277,$0277,$0267,$0267
	dc.w	$0257,$0257,$0247,$0247
	dc.w	$0347,$0347,$0447,$0447
	dc.w	$0547,$0547,$0647,$0647
	dc.w	$0747,$0747,$0737,$0737
	dc.w	$0727,$0727,$0717,$0717
	dc.w	$0707,$0707,$0705,$0705
	dc.w	$0604,$0604,$0503,$0503
	dc.w	$0402,$0402,$0301,$0301
	dc.w	$0200,$0200,$0100,$0100
DATA_R4:
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0001,$0001
	dc.w	$0002,$0002,$0003,$0003
	dc.w	$0004,$0004,$0005,$0005
	dc.w	$0006,$0006,$0007,$0007
	dc.w	$0017,$0017,$0027,$0027
	dc.w	$0037,$0037,$0047,$0047
	dc.w	$0057,$0057,$0067,$0067
	dc.w	$0077,$0077,$0076,$0076
	dc.w	$0277,$0277,$0267,$0267
	dc.w	$0257,$0257,$0247,$0247
	dc.w	$0347,$0347,$0447,$0447
	dc.w	$0547,$0547,$0647,$0647
	dc.w	$0747,$0747,$0737,$0737
	dc.w	$0727,$0727,$0717,$0717
	dc.w	$0707,$0707,$0705,$0705
	dc.w	$0704,$0704,$0703,$0703
	dc.w	$0702,$0702,$0701,$0701
	dc.w	$0700,$0700,$0710,$0710
	dc.w	$0720,$0720,$0730,$0730
	dc.w	$0740,$0740,$0750,$0750
	dc.w	$0760,$0760,$0770,$0770
	dc.w	$0771,$0771,$0772,$0772
	dc.w	$0773,$0773,$0774,$0774
	dc.w	$0775,$0775,$0776,$0776
	dc.w	$0777,$0777,$0677,$0677
	dc.w	$0577,$0577,$0477,$0477
	dc.w	$0377,$0377,$0267,$0267
	dc.w	$0157,$0157,$0047,$0047
	dc.w	$0037,$0037,$0027,$0027
	dc.w	$0017,$0017,$0027,$0027
	dc.w	$0037,$0037,$0047,$0047
	dc.w	$0057,$0057,$0067,$0067
	dc.w	$0077,$0077,$0076,$0076
	dc.w	$0277,$0277,$0267,$0267
	dc.w	$0257,$0257,$0247,$0247
	dc.w	$0347,$0347,$0447,$0447
	dc.w	$0547,$0547,$0647,$0647
	dc.w	$0747,$0747,$0737,$0737
	dc.w	$0727,$0727,$0717,$0717
	dc.w	$0707,$0707,$0705,$0705
	dc.w	$0604,$0604,$0503,$0503
	dc.w	$0402,$0402,$0301,$0301
	dc.w	$0200,$0200,$0100,$0100
	dc.w	$6000,$0014

; Scroll VGT datas
FONT_VGT:
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0FC0,$3FF0
	dc.w	$7CF8,$7CF8,$FCFC,$FCFC
	dc.w	$FFFC,$FFFC,$FCFC,$FCFC
	dc.w	$FCFC,$FCFC,$FCFC,$FCFC
	dc.w	$FFC0,$FFF0,$FCF8,$FCF8
	dc.w	$FCFC,$FCFC,$FFF8,$FFF8
	dc.w	$FCFC,$FCFC,$FCF8,$FCF8
	dc.w	$FFF0,$FFC0,$0FC0,$3FF0
	dc.w	$7FF8,$7FF8,$FCFC,$FCFC
	dc.w	$FC00,$FC00,$FCFC,$FCFC
	dc.w	$7FF8,$7FF8,$3FF0,$0FC0
	dc.w	$FFC0,$FFF0,$FFF8,$FFF8
	dc.w	$FCFC,$FCFC,$FCFC,$FCFC
	dc.w	$FCFC,$FCFC,$FFF8,$FFF8
	dc.w	$FFF0,$FFC0,$FFFC,$FFFC
	dc.w	$FFFC,$FFFC,$FC00,$FC00
	dc.w	$FFC0,$FFC0,$FC00,$FC00
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$FC00,$FC00,$FFC0,$FFC0
	dc.w	$FC00,$FC00,$FC00,$FC00
	dc.w	$FC00,$FC00,$0FC0,$3FF0
	dc.w	$7FF8,$7FF8,$FCFC,$FCFC
	dc.w	$FC00,$FC00,$FCFC,$FCFC
	dc.w	$7FFC,$7FFC,$3FFC,$0FFC
	dc.w	$FCFC,$FCFC,$FCFC,$FCFC
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$FFFC,$FFFC,$FCFC,$FCFC
	dc.w	$FCFC,$FCFC,$0FC0,$0FC0
	dc.w	$0FC0,$0FC0,$0FC0,$0FC0
	dc.w	$0FC0,$0FC0,$0FC0,$0FC0
	dc.w	$0FC0,$0FC0,$0FC0,$0FC0
	dc.w	$00FC,$00FC,$00FC,$00FC
	dc.w	$00FC,$00FC,$FCFC,$FCFC
	dc.w	$FCFC,$FCFC,$7FF8,$7FF8
	dc.w	$3FF0,$0FC0,$FCFC,$FCFC
	dc.w	$FCFC,$FCFC,$FFF8,$FFF0
	dc.w	$FFE0,$FFE0,$FFF0,$FFF8
	dc.w	$FCFC,$FCFC,$FCFC,$FCFC
	dc.w	$FC00,$FC00,$FC00,$FC00
	dc.w	$FC00,$FC00,$FC00,$FC00
	dc.w	$FC00,$FC00,$FFFC,$FFFC
	dc.w	$FFFC,$FFFC,$F03C,$F87C
	dc.w	$FCFC,$FFFC,$FFFC,$FFFC
	dc.w	$FFFC,$FFFC,$FCFC,$FCFC
	dc.w	$FCFC,$FCFC,$FCFC,$FCFC
	dc.w	$F0FC,$F8FC,$FCFC,$FEFC
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$FFFC,$FFFC,$FDFC,$FCFC
	dc.w	$FC7C,$FC3C,$0FC0,$3FF0
	dc.w	$7FF8,$7FF8,$FCFC,$FCFC
	dc.w	$FCFC,$FCFC,$FCFC,$FCFC
	dc.w	$7FF8,$7FF8,$3FF0,$0FC0
	dc.w	$FFC0,$FFF0,$FFF8,$FFF8
	dc.w	$FC3C,$FC3C,$FFF8,$FFF8
	dc.w	$FFF0,$FFC0,$FC00,$FC00
	dc.w	$FC00,$FC00,$0FC0,$3FF0
	dc.w	$7FF8,$7FF8,$FCFC,$FCFC
	dc.w	$FCFC,$FCFC,$FCFC,$FCFC
	dc.w	$7FFC,$7FFC,$3FFC,$0FFC
	dc.w	$FFC0,$FFF0,$FFF8,$FFF8
	dc.w	$FCFC,$FCFC,$FFFC,$FFF0
	dc.w	$FFF0,$FFFC,$FCFC,$FCFC
	dc.w	$FCFC,$FCFC,$0FFC,$3FFC
	dc.w	$7FFC,$7FFC,$FC00,$FC00
	dc.w	$FFFC,$FFFC,$00FC,$00FC
	dc.w	$FFF8,$FFF8,$FFF0,$FFC0
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$0FC0,$0FC0,$0FC0,$0FC0
	dc.w	$0FC0,$0FC0,$0FC0,$0FC0
	dc.w	$0FC0,$0FC0,$FCFC,$FCFC
	dc.w	$FCFC,$FCFC,$FCFC,$FCFC
	dc.w	$FCFC,$FCFC,$FCFC,$FCFC
	dc.w	$7FF8,$7FF8,$3FF0,$0FC0
	dc.w	$FCFC,$FCFC,$FCFC,$FCFC
	dc.w	$FCFC,$FCFC,$FCFC,$FCFC
	dc.w	$7FF8,$3FF0,$1FE0,$0FC0
	dc.w	$0780,$0300,$FCFC,$FCFC
	dc.w	$FCFC,$FCFC,$FCFC,$FCFC
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$FFFC,$FCFC,$F87C,$F03C
	dc.w	$FCFC,$FCFC,$FCFC,$FCFC
	dc.w	$7FF8,$3FF0,$1FE0,$1FE0
	dc.w	$3FF0,$7FF8,$FCFC,$FCFC
	dc.w	$FCFC,$FCFC,$FCFC,$FCFC
	dc.w	$FCFC,$FCFC,$FCFC,$FCFC
	dc.w	$7FF8,$3FF0,$1FE0,$0FC0
	dc.w	$0FC0,$0FC0,$0FC0,$0FC0
	dc.w	$FFFC,$FFFC,$FFFC,$FFFC
	dc.w	$03F8,$07F0,$0FE0,$1FC0
	dc.w	$3F80,$7F00,$FFFC,$FFFC
	dc.w	$FFFC,$FFFC,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$3F00,$3F00
	dc.w	$3F00,$3F00,$3F00,$3F00
	dc.w	$3F00,$3F00,$3F00,$3F00
	dc.w	$3F00,$3F00,$0000,$0000
	dc.w	$3F00,$3F00,$3F00,$3F00
	dc.w	$3F00,$3F00,$0FC0,$0FC0
	dc.w	$0FC0,$0FC0,$0FC0,$0FC0
	dc.w	$0FC0,$0FC0,$0FC0,$0FC0
	dc.w	$0000,$0000,$0FC0,$0FC0
	dc.w	$0FC0,$3FF0,$7FF8,$7FF8
	dc.w	$F0FC,$F1FC,$03F8,$07F8
	dc.w	$0FF0,$0FC0,$0000,$0000
	dc.w	$0FC0,$0FC0,$0FC0,$0FC0
	dc.w	$0FC0,$0FC0,$0FC0,$1FC0
	dc.w	$3F80,$3F00,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0FC0,$0FC0
	dc.w	$0FC0,$0FC0,$0FC0,$1FC0
	dc.w	$3F80,$3F00,$0300,$0700
	dc.w	$0F00,$1F00,$3FFC,$7FFC
	dc.w	$FFFC,$FFFC,$7FFC,$3FFC
	dc.w	$1F00,$0F00,$0700,$0300
	dc.w	$0300,$0380,$03C0,$03E0
	dc.w	$FFF0,$FFF8,$FFFC,$FFFC
	dc.w	$FFF8,$FFF0,$03E0,$03C0
	dc.w	$0380,$0300,$0000,$0000
	dc.w	$0000,$0000,$3FF0,$3FF0
	dc.w	$3FF0,$3FF0,$3FF0,$3FF0
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$03C0,$0FC0,$1FC0,$1FC0
	dc.w	$3F80,$3F00,$3F00,$3F00
	dc.w	$3F00,$3F80,$1FC0,$1FC0
	dc.w	$0FC0,$03C0,$0F00,$0FC0
	dc.w	$0FE0,$0FE0,$07F0,$03F0
	dc.w	$03F0,$03F0,$03F0,$07F0
	dc.w	$0FE0,$0FE0,$0FC0,$0F00
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
BUFFER:
	DCB.W	2240,$0
COMPTEUR1:
	DC.W	0
COMPTEUR2:
	DC.L	0
PTR_MOUVEMENT:
	DC.L	MOUVEMENT 
ZERO:
	DC.B	0
MOUVEMENT:
	dc.w	$1415,$1516,$1717,$1819
	dc.w	$1A1A,$1B1B,$1C1D,$1D1E
	dc.w	$1F1F,$2020,$2121,$2222
	dc.w	$2323,$2424,$2525,$2526
	dc.w	$2626,$2727,$2727,$2728
	dc.w	$2828,$2828,$2828,$2828
	dc.w	$2828,$2828,$2727,$2727
	dc.w	$2726,$2626,$2525,$2524
	dc.w	$2423,$2322,$2221,$2120
	dc.w	$201F,$1F1E,$1D1D,$1C1B
	dc.w	$1B1A,$1A19,$1817,$1716
	dc.w	$1515,$1413,$1312,$1111
	dc.w	$100F,$0E0E,$0D0D,$0C0B
	dc.w	$0B0A,$0909,$0808,$0707
	dc.w	$0606,$0505,$0404,$0303
	dc.w	$0302,$0202,$0101,$0101
	dc.w	$0100,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0101
	dc.w	$0101,$0102,$0202,$0303
	dc.w	$0304,$0405,$0506,$0607
	dc.w	$0708,$0809,$090A,$0B0B
	dc.w	$0C0D,$0D0E,$0E0F,$1011
	dc.w	$1112,$1313
TREIZE:
	DC.B	$13 
MYEND:
	DC.B	0
TEXTE:
	DC.B  '             '
	DC.B  'ABCDEFGHIJKLMNOPQRSTUVWXYZ '
	DC.B  '-().:!?<>',$27
	DC.B  '             '
	DC.B  -1
PTR_TEXTE:
	DC.L	TEXTE 
POSITION:
	dc.w	4,8,12,16
ASCII:
	dc.w	$2000,$4101,$4202,$4303
	dc.w	$4404,$4505,$4606,$4707
	dc.w	$4808,$4909,$4A0A,$4B0B
	dc.w	$4C0C,$4D0D,$4E0E,$4F0F
	dc.w	$5010,$5111,$5212,$5313
	dc.w	$5414,$5515,$5616,$5717
	dc.w	$5818,$5919,$5A1A,$2E1B
	dc.w	$3A1C,$211D,$3F1E,$271F
	dc.w	$2C20,$3C21,$3E22,$2D23
	dc.w	$2824,$2925,$FF00

; Logo BSW
Image_Logo:
		dc.w	$0000,$0000,$0000,$0000,$0388,$03F0,$03FF,$03FF
		dc.w	$E633,$FE03,$01FC,$FFFF,$2000,$A000,$0000,$C000
		dc.w	$1C47,$1F87,$1FF8,$1FFF,$3199,$F01D,$0FE0,$FFFE
		dc.w	$0000,$0000,$0000,$0000,$0720,$C7C0,$7800,$8000
		dc.w	$0000,$0006,$0003,$0004,$3900,$3E00,$C000,$0000
		dc.w	$00E2,$00FC,$00FF,$00FF,$398C,$3F80,$C07F,$FFFF
		dc.w	$C000,$F800,$0000,$F000,$0711,$07E1,$07FE,$07FF
		dc.w	$CC66,$FC07,$03F8,$FFFF,$8000,$4000,$0000,$8000
		dc.w	$388E,$3F0F,$3FF0,$3FFF,$6330,$E03E,$1FC0,$FFFC
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$03CC,$03F0,$03FF,$03FF
		dc.w	$E33B,$FF03,$00FC,$FFFF,$1000,$D000,$0000,$E000
		dc.w	$1E67,$1F87,$1FF8,$1FFF,$19D8,$F81E,$07E0,$FFFF
		dc.w	$8000,$8000,$0000,$0000,$0360,$E380,$3C00,$C000
		dc.w	$0000,$0007,$0001,$0006,$1B00,$1C00,$E000,$0000
		dc.w	$00F3,$00FC,$00FF,$00FF,$38CE,$3FC0,$C03F,$FFFF
		dc.w	$C000,$FC00,$0000,$F800,$0799,$07E1,$07FE,$07FF
		dc.w	$C676,$FE07,$01F8,$FFFF,$4000,$A000,$0000,$C000
		dc.w	$3CCE,$3F0F,$3FF0,$3FFF,$33B0,$F03F,$0FC0,$FFFE
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00E0,$03E0,$03FF,$03E0
		dc.w	$0000,$0000,$FFFF,$0000,$F800,$9800,$9000,$6000
		dc.w	$0700,$1F00,$1FFF,$1F00,$0007,$0004,$FFFC,$0003
		dc.w	$C000,$C000,$8000,$0000,$C2E0,$F300,$1C00,$E000
		dc.w	$0006,$0007,$0000,$0007,$1700,$9800,$E000,$0000
		dc.w	$0038,$00F8,$00FF,$00F8,$0000,$0000,$FFFF,$0000
		dc.w	$3C00,$2200,$E000,$1C00,$01C0,$07C0,$07FF,$07C0
		dc.w	$0001,$0001,$FFFF,$0000,$E000,$3000,$2000,$C000
		dc.w	$0E00,$3E00,$3FFF,$3E00,$000F,$0008,$FFF8,$0007
		dc.w	$0000,$8000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0201,$01E0,$03F0,$03E0
		dc.w	$E31C,$1F03,$00FF,$0000,$6000,$4C00,$C800,$3000
		dc.w	$100F,$0F00,$1F80,$1F00,$18E3,$F81A,$07FE,$0001
		dc.w	$0000,$6000,$4000,$8000,$E3E0,$F800,$0C00,$F000
		dc.w	$0007,$0007,$0000,$0007,$1F00,$C000,$6000,$8000
		dc.w	$0080,$0078,$00FC,$00F8,$78D7,$07C7,$0038,$0000
		dc.w	$1800,$D100,$3000,$0E00,$0403,$03C0,$07E0,$07C0
		dc.w	$C638,$3E06,$01FF,$0000,$D000,$9800,$9000,$6000
		dc.w	$201E,$1E01,$3F00,$3E00,$35C6,$F1F4,$0E0C,$0003
		dc.w	$0000,$4000,$0000,$8000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$03C8,$0020,$03F0,$03E0
		dc.w	$631B,$1F07,$00FF,$0000,$9C00,$BA00,$FC00,$0000
		dc.w	$1E43,$0100,$1F80,$1F00,$18DC,$F83D,$07FF,$0000
		dc.w	$6000,$B000,$C000,$0000,$3BE0,$3800,$C400,$F800
		dc.w	$0001,$0001,$0006,$0007,$DF00,$C000,$2000,$C000
		dc.w	$00F2,$0008,$00FC,$00F8,$18D7,$07C7,$0038,$0000
		dc.w	$0700,$EF80,$1F00,$0000,$0790,$0040,$07E0,$07C0
		dc.w	$C637,$3E0F,$01FF,$0000,$1800,$6C00,$F000,$0000
		dc.w	$3C86,$0201,$3F00,$3E00,$35C1,$F1FB,$0E07,$0000
		dc.w	$C000,$E000,$C000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$006F,$0000,$03F0,$03E0
		dc.w	$000A,$000E,$0006,$0001,$C000,$5D00,$7E00,$8000
		dc.w	$0378,$0000,$1F80,$1F00,$0056,$0072,$0033,$000C
		dc.w	$1000,$1800,$E000,$0000,$0B60,$0800,$F400,$F800
		dc.w	$0000,$0000,$0007,$0007,$5B00,$4000,$A000,$C000
		dc.w	$001B,$0000,$00FC,$00F8,$C001,$0001,$0000,$0000
		dc.w	$3000,$F7C0,$0F80,$0000,$00DE,$0000,$07E0,$07C0
		dc.w	$0005,$000C,$000C,$0003,$8400,$8600,$F800,$0000
		dc.w	$06F0,$0000,$3F00,$3E00,$004C,$007D,$0003,$0000
		dc.w	$0000,$F000,$E000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$000F,$0000,$03F0,$03E0
		dc.w	$8007,$0000,$0004,$0003,$AF00,$6180,$3E00,$C000
		dc.w	$007C,$0000,$1F80,$1F00,$003F,$0003,$0021,$001E
		dc.w	$7800,$7C00,$8000,$0000,$03E0,$0000,$FC00,$F800
		dc.w	$0000,$0000,$0007,$0007,$1F00,$0000,$E000,$C000
		dc.w	$0003,$0000,$00FC,$00F8,$E000,$0000,$0000,$0000
		dc.w	$F3C0,$F020,$0FC0,$0000,$001F,$0000,$07E0,$07C0
		dc.w	$0007,$0000,$0000,$0007,$DE00,$DF00,$6000,$8000
		dc.w	$00F8,$0000,$3F00,$3E00,$003C,$003C,$0003,$0000
		dc.w	$F000,$0800,$F000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0300,$030F,$00F0,$03E0
		dc.w	$8000,$0003,$0002,$0001,$0000,$E0C0,$1F00,$E000
		dc.w	$1804,$1878,$0780,$1F00,$000D,$001B,$0016,$000F
		dc.w	$0000,$3E00,$C000,$0000,$FBC0,$0020,$FC00,$F800
		dc.w	$0007,$0000,$0007,$0007,$DE00,$0100,$E000,$C000
		dc.w	$00C0,$00C3,$003C,$00F8,$2000,$C000,$0000,$0000
		dc.w	$6010,$6020,$1FC0,$0000,$0601,$061E,$01E0,$07C0
		dc.w	$0003,$0002,$0001,$0003,$4000,$CF80,$B000,$C000
		dc.w	$3008,$30F0,$0F00,$3E00,$0018,$0018,$0007,$0000
		dc.w	$0400,$0800,$F000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$038E,$038F,$0070,$03E0
		dc.w	$0001,$8001,$0000,$0001,$EF80,$EFC0,$1000,$E000
		dc.w	$1C70,$1C7C,$0380,$1F00,$0002,$000E,$000C,$000F
		dc.w	$BC00,$C200,$0000,$0000,$F800,$03E0,$FC00,$F800
		dc.w	$0007,$0000,$0007,$0007,$C000,$1F00,$E000,$C000
		dc.w	$00E0,$00E3,$001C,$00F8,$0000,$E000,$0000,$0000
		dc.w	$22E8,$20F0,$1F00,$0000,$0700,$071F,$00E0,$07C0
		dc.w	$0000,$0003,$0003,$0003,$AF00,$B080,$0000,$C000
		dc.w	$3800,$38F8,$0700,$3E00,$0008,$0008,$0007,$0000
		dc.w	$BA00,$3C00,$C000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$03E0,$03E0,$001F,$03E0
		dc.w	$8000,$0000,$0001,$0001,$0FC0,$0FC0,$F000,$E000
		dc.w	$1F04,$1F00,$00F8,$1F00,$0009,$000F,$0002,$000C
		dc.w	$8E00,$F000,$0000,$0000,$8000,$FBE0,$FC00,$F800
		dc.w	$0004,$0007,$0007,$0007,$0000,$DF00,$E000,$C000
		dc.w	$00F8,$00FB,$0004,$00F8,$2000,$C000,$0000,$0000
		dc.w	$1F64,$1078,$0F80,$0000,$07C1,$07DE,$0020,$07C0
		dc.w	$0002,$0003,$0000,$0003,$6380,$FC00,$8000,$0000
		dc.w	$3E08,$3EF0,$0100,$3E00,$0007,$0004,$0003,$0000
		dc.w	$D900,$1E00,$E000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$006E,$03E1,$001E,$03E0
		dc.w	$0001,$0000,$0001,$0001,$E000,$0FC0,$F000,$E000
		dc.w	$0370,$1F08,$00F0,$1F00,$0007,$0001,$0006,$0008
		dc.w	$0600,$F800,$0000,$0000,$03E0,$F800,$FC00,$F800
		dc.w	$0000,$0007,$0007,$0007,$0000,$DF00,$E000,$C000
		dc.w	$0018,$00FB,$0004,$00F8,$E000,$0000,$0000,$0000
		dc.w	$0E06,$09B8,$07C0,$0000,$00C7,$07D8,$0020,$07C0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0638,$3EC0,$0100,$3E00,$0003,$0002,$0001,$0000
		dc.w	$8180,$6E00,$F000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$002E,$03E2,$001C,$03E0
		dc.w	$0001,$0001,$0001,$0001,$8000,$EFC0,$F000,$E000
		dc.w	$0170,$1F10,$00E0,$1F00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$F3E0,$F800,$FC00,$F800
		dc.w	$0007,$0007,$0007,$0007,$1F00,$DF00,$E000,$C000
		dc.w	$000B,$00F8,$0004,$00F8,$C000,$0000,$0000,$0000
		dc.w	$00CF,$07D0,$07E0,$0000,$005E,$07C0,$0020,$07C0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$02F0,$3E00,$0100,$3E00,$0000,$0001,$0001,$0000
		dc.w	$33C0,$F400,$F800,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0383,$0068,$0018,$03E7
		dc.w	$3C66,$03E1,$001F,$FFFF,$EC00,$EE00,$F000,$E000
		dc.w	$1C19,$0340,$00C0,$1F3F,$D653,$319C,$0FE0,$FFFF
		dc.w	$9000,$0000,$1000,$E000,$7800,$FBE0,$FC00,$F800
		dc.w	$0001,$0007,$0007,$0007,$DF00,$DF00,$E000,$C000
		dc.w	$00E3,$0018,$0004,$00F8,$E000,$0000,$0000,$0000
		dc.w	$021F,$0600,$0620,$01C0,$071F,$00C0,$0020,$07C0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$38F8,$0600,$0100,$3E00,$0000,$0001,$0001,$0000
		dc.w	$87C0,$8000,$8800,$7000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$03E0,$0000,$001F,$03E0
		dc.w	$0000,$0000,$FFFF,$0000,$0E00,$0F00,$F000,$0000
		dc.w	$1F00,$0000,$00FF,$1F00,$0000,$0000,$FFFF,$0000
		dc.w	$3000,$7000,$F800,$0000,$3800,$FBE0,$FC00,$F800
		dc.w	$0000,$0007,$0007,$0007,$C000,$C000,$FF00,$C000
		dc.w	$00FB,$0000,$0004,$00F8,$E000,$0000,$0000,$0000
		dc.w	$009F,$0000,$0020,$07C0,$07DF,$0000,$0020,$07C0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3EF8,$0000,$0100,$3E00,$0000,$0000,$0000,$0001
		dc.w	$27C0,$0000,$0800,$F000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0080,$03E0,$0010,$03E0
		dc.w	$FE38,$01F8,$0007,$0000,$F300,$0080,$FF00,$0000
		dc.w	$0F47,$1900,$0180,$1E00,$F1C7,$0FC0,$003F,$0000
		dc.w	$8800,$3400,$F800,$0000,$07E0,$FFE0,$F800,$F800
		dc.w	$0000,$0007,$0007,$0007,$1F00,$DF00,$E000,$C000
		dc.w	$0020,$00F8,$0004,$00F8,$2000,$0000,$0000,$0000
		dc.w	$06DF,$0000,$0020,$07C0,$0101,$07C0,$0020,$07C0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0808,$3E00,$0100,$3E00,$0001,$0000,$0000,$0001
		dc.w	$B7C0,$0000,$0800,$F000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$000C,$03E0,$0010,$03E0
		dc.w	$7E38,$01F8,$0007,$0000,$EA00,$11C0,$FF80,$0000
		dc.w	$08E3,$0D00,$0E00,$1000,$F1C7,$0FC0,$003F,$0000
		dc.w	$5C00,$8200,$FC00,$0000,$FBE0,$03E0,$FC00,$F800
		dc.w	$0006,$0801,$0007,$0007,$1F00,$DF00,$E000,$C000
		dc.w	$0003,$00F8,$0004,$00F8,$0000,$0000,$0000,$0000
		dc.w	$05DF,$0000,$0020,$07C0,$0018,$07C0,$0020,$07C0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00C0,$3E00,$0100,$3E00,$0001,$0000,$0000,$0001
		dc.w	$77C0,$0000,$0800,$F000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$01EF,$03E0,$0010,$03E0
		dc.w	$8000,$0000,$0000,$0000,$5840,$BDA0,$7FC0,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0005,$0003,$0000
		dc.w	$CC00,$E100,$FE00,$0000,$F800,$03E0,$FC00,$F800
		dc.w	$0007,$1400,$0807,$0007,$0000,$DF00,$E000,$C000
		dc.w	$007B,$00F8,$0004,$00F8,$E000,$0000,$0000,$0000
		dc.w	$03D8,$0007,$0020,$07C0,$03DF,$07C0,$0020,$07C0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1EF8,$3E00,$0100,$3E00,$0000,$0000,$0000,$0001
		dc.w	$F600,$01C0,$0800,$F000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$03EB,$03E0,$0010,$03E0
		dc.w	$8000,$0000,$0000,$0000,$7AC0,$7A10,$3BE0,$0400
		dc.w	$0000,$0000,$0000,$0000,$0003,$0003,$0001,$0000
		dc.w	$D000,$D080,$DF00,$2000,$E000,$03E0,$FC00,$F800
		dc.w	$1003,$2200,$1C07,$0007,$8000,$5F00,$E000,$C000
		dc.w	$00FA,$00F8,$0004,$00F8,$E000,$0000,$0000,$0000
		dc.w	$0780,$00DF,$0020,$07C0,$07D7,$07C0,$0020,$07C0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3EB8,$3E00,$0100,$3E00,$0001,$0000,$0000,$0001
		dc.w	$E000,$37C0,$0800,$F000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$020F,$0200,$01F0,$03E0
		dc.w	$8000,$0000,$0000,$0000,$0310,$0118,$21E0,$1E00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0001,$0000
		dc.w	$1880,$08C0,$0F00,$F000,$83E0,$0000,$FC00,$F800
		dc.w	$7201,$4300,$3C07,$0007,$DF00,$0000,$E000,$C000
		dc.w	$0083,$0080,$007C,$00F8,$E000,$0000,$0000,$0000
		dc.w	$0600,$01DF,$0020,$07C0,$041F,$0400,$03E0,$07C0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$20F8,$2000,$1F00,$3E00,$0001,$0000,$0000,$0001
		dc.w	$8000,$77C0,$0800,$F000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$000F,$0000,$03F0,$03E0
		dc.w	$8000,$0000,$0000,$0000,$1F78,$007C,$0080,$1F00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FBC0,$03E0,$0400,$F800,$0BE0,$0800,$F400,$F800
		dc.w	$9600,$E700,$7807,$0007,$5F00,$0000,$E000,$C000
		dc.w	$0003,$0000,$00FC,$00F8,$E000,$0000,$0000,$0000
		dc.w	$001F,$07DF,$0020,$07C0,$001F,$0000,$07E0,$07C0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00F8,$0000,$3F00,$3E00,$0000,$0001,$0000,$0001
		dc.w	$07C0,$F7C0,$0800,$F000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00E0,$000F,$03F0,$03E0
		dc.w	$0000,$8000,$0000,$0000,$187C,$077C,$0080,$1F00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$C3E0,$3BE0,$0400,$F800,$3BE1,$3801,$C400,$F800
		dc.w	$1480,$E700,$F807,$0007,$1F00,$0000,$E000,$C000
		dc.w	$0038,$0003,$00FC,$00F8,$0000,$E000,$0000,$0000
		dc.w	$01C0,$07C0,$003F,$07C0,$01C0,$001F,$07E0,$07C0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0E00,$00F8,$3F00,$3E00,$0000,$0001,$0000,$0001
		dc.w	$7000,$F000,$0FC0,$F000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$03E0,$000F,$03F0,$03E0
		dc.w	$0000,$8000,$0000,$0000,$037C,$1F7C,$0080,$1F00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1BE0,$FBE0,$0400,$F800,$F3E3,$F803,$0401,$F800
		dc.w	$81C6,$EA06,$F401,$0007,$1F00,$0000,$E000,$C000
		dc.w	$00F8,$0003,$00FC,$00F8,$0000,$E000,$0000,$0000
		dc.w	$039F,$079F,$0060,$07C0,$07C0,$001F,$07E0,$07C0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3E00,$00F8,$3F00,$3E00,$0000,$0001,$0000,$0001
		dc.w	$E7C0,$E7C0,$1800,$F000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$002F,$03EF,$03F0,$03E0
		dc.w	$0000,$8000,$0000,$0000,$1C00,$1C7C,$0380,$1F00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$E000,$E3E0,$1C00,$F800,$8806,$F806,$0402,$F801
		dc.w	$15C7,$5837,$6200,$8407,$9F00,$8000,$6000,$C000
		dc.w	$000B,$00FB,$00FC,$00F8,$C000,$E000,$0000,$0000
		dc.w	$0600,$061F,$01E0,$07C0,$005E,$07DF,$07E0,$07C0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$02F0,$3EF8,$3F00,$3E00,$0001,$0001,$0000,$0001
		dc.w	$8000,$87C0,$7800,$F000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$01EE,$03EF,$03F0,$03E0
		dc.w	$0000,$0000,$0000,$0000,$0000,$007C,$1F80,$1F00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$03E0,$FC00,$F800,$30EC,$F00C,$0C04,$F803
		dc.w	$0E93,$887F,$F100,$0607,$C000,$DF00,$2000,$C000
		dc.w	$007B,$00FB,$00FC,$00F8,$8000,$C000,$0000,$0000
		dc.w	$0000,$001F,$07E0,$07C0,$03DC,$07DE,$07E0,$07C0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1EE0,$3EF0,$3F00,$3E00,$0000,$0000,$0001,$0001
		dc.w	$0000,$07C0,$F800,$F000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0200,$03E2,$03FC,$03E0
		dc.w	$0000,$0000,$0000,$0000,$1F00,$007C,$1F80,$1F00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$F800,$03E0,$FC00,$F800,$E3F4,$E01D,$1C0D,$F802
		dc.w	$4F6D,$0863,$F098,$0707,$C000,$DF00,$2000,$C000
		dc.w	$0080,$00F8,$00FF,$00F8,$0000,$8000,$0000,$0000
		dc.w	$07C0,$001F,$07E0,$07C0,$0400,$07C4,$07F8,$07C0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$2000,$3E20,$3FC0,$3E00,$0001,$0000,$0001,$0001
		dc.w	$F000,$07C0,$F800,$F000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$03E4,$0006,$03FA,$03E1
		dc.w	$8E33,$7FF0,$000F,$FFFF,$1F7C,$FC00,$FF80,$FF00
		dc.w	$1C71,$1F81,$1FFE,$1FFF,$F198,$FF87,$007F,$FFFF
		dc.w	$FBE0,$E000,$FC00,$F800,$C3E4,$C00E,$3C1F,$F800
		dc.w	$768A,$9501,$E478,$0387,$DF00,$DF00,$2000,$C000
		dc.w	$00F9,$0001,$00FE,$00F8,$238C,$9FFC,$8003,$7FFF
		dc.w	$C7DF,$3F00,$FFE0,$FFC0,$07C9,$000C,$07F4,$07C3
		dc.w	$1C66,$FFE1,$001F,$FFFF,$3650,$F860,$FF80,$FFF8
		dc.w	$3E48,$0067,$3FA0,$3E1F,$E331,$FF0F,$00FF,$FFFF
		dc.w	$F7C0,$C000,$F800,$F000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$03E9,$000C,$03F4,$03E3
		dc.w	$1C33,$FFF0,$000F,$FFFF,$9F7C,$7F00,$FF80,$FF00
		dc.w	$1E31,$07C1,$1FFE,$1FFF,$E19C,$FF83,$007F,$FFFF
		dc.w	$FBE0,$F800,$FC00,$F800,$0BA5,$0069,$FC1F,$F800
		dc.w	$025D,$C384,$E23C,$01C3,$1F00,$DF00,$2000,$C000
		dc.w	$00FA,$0003,$00FD,$00F8,$470C,$3FFC,$0003,$FFFF
		dc.w	$E7DF,$1FC0,$FFE0,$FFC0,$07D2,$0019,$07E8,$07C7
		dc.w	$3867,$FFE0,$001F,$FFFF,$36A0,$F8C0,$FF08,$FFF0
		dc.w	$3E91,$00CF,$3F40,$3E3F,$C339,$FF07,$00FF,$FFFF
		dc.w	$F7C0,$F000,$F800,$F000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0009,$03F8,$03E7
		dc.w	$3C31,$FFF0,$000F,$FFFF,$C77C,$3F00,$FF80,$FF00
		dc.w	$0719,$03E1,$1FFE,$1FFF,$E18E,$FF81,$007F,$FFFF
		dc.w	$3BE0,$F800,$FC00,$F800,$1B49,$00D3,$FC3F,$F800
		dc.w	$814E,$81C2,$C11E,$00E1,$8000,$4000,$3F00,$C000
		dc.w	$0000,$0002,$00FE,$00F9,$8F0C,$7FFC,$0003,$FFFF
		dc.w	$71DF,$0FC0,$FFE0,$FFC0,$0004,$0013,$07F0,$07CF
		dc.w	$7863,$FFE0,$001F,$FFFF,$82C8,$7C80,$FF10,$FFE0
		dc.w	$0023,$009F,$3F80,$3E7F,$C31C,$FF03,$00FF,$FFFF
		dc.w	$77C0,$F000,$F800,$F000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0024,$0021,$03D0,$03EF
		dc.w	$7870,$FFF0,$000F,$FFFF,$E37C,$1F00,$FF80,$FF00
		dc.w	$0319,$01E1,$1FFE,$1FFF,$C387,$FF80,$007F,$FFFF
		dc.w	$1BE0,$F800,$FC00,$F800,$F234,$0984,$FC7C,$F803
		dc.w	$0055,$0043,$802F,$00F0,$5000,$0000,$3F00,$C000
		dc.w	$0009,$0008,$00F4,$00FB,$1E1C,$7FFC,$0003,$FFFF
		dc.w	$38DF,$07C0,$FFE0,$FFC0,$0048,$0043,$07A0,$07DF
		dc.w	$F0E1,$FFE0,$001F,$FFFF,$C218,$3C80,$FF20,$FFC0
		dc.w	$0247,$021F,$3D00,$3EFF,$870E,$FF01,$00FF,$FFFF
		dc.w	$37C8,$F010,$F800,$F000,$85A0,$43C0,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00E0,$00E0,$031F,$03E0
		dc.w	$0000,$0000,$FFFF,$0000,$007C,$0000,$FF80,$0000
		dc.w	$0000,$0100,$1EFF,$1F00,$0000,$0000,$FFFF,$0000
		dc.w	$03E0,$0000,$FC00,$0000,$E28D,$1988,$FC79,$F806
		dc.w	$0019,$0003,$0037,$0078,$9C00,$8000,$BF00,$4000
		dc.w	$0038,$0038,$00C7,$00F8,$0000,$0000,$FFFF,$0000
		dc.w	$001F,$0000,$FFE0,$0000,$01C0,$01C0,$063F,$07C0
		dc.w	$0000,$0000,$FFFF,$0000,$0038,$0080,$FFC0,$0000
		dc.w	$0E00,$0E00,$31FF,$3E00,$0000,$0000,$FFFF,$0000
		dc.w	$07D5,$0018,$F800,$0000,$4240,$C660,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0387,$03E7,$0038,$03C0
		dc.w	$3FE3,$C01F,$0000,$0000,$8F9C,$F000,$0000,$0000
		dc.w	$1C39,$1F3E,$01C0,$1E00,$FF1C,$00FF,$0000,$0000
		dc.w	$7CE0,$8000,$0000,$0000,$8814,$781A,$FFF2,$F80C
		dc.w	$0014,$0008,$001B,$003C,$0F00,$1000,$FF00,$0000
		dc.w	$00E1,$00F9,$000E,$00F0,$CFF8,$F007,$0000,$0000
		dc.w	$E3E7,$FC00,$0000,$0000,$070E,$07CF,$0070,$0780
		dc.w	$7FC7,$803F,$0000,$0000,$1F58,$E0E0,$0000,$0000
		dc.w	$3873,$3E7C,$0380,$3C00,$FE38,$01FF,$0000,$0000
		dc.w	$F9C8,$000F,$0010,$0000,$85A0,$8420,$43C0,$0000
		dc.w	$0000,$0000,$0000,$0000,$030E,$03CF,$0070,$0380
		dc.w	$3FE3,$C01F,$0000,$0000,$8F8C,$F000,$0000,$0000
		dc.w	$1871,$1E7E,$0380,$1C00,$FF1C,$00FF,$0000,$0000
		dc.w	$7C60,$8000,$0000,$0000,$18D8,$FF14,$FFE4,$FFF8
		dc.w	$0013,$000F,$000F,$001F,$BD00,$2E00,$CF00,$F000
		dc.w	$00C3,$00F3,$001C,$00E0,$8FF8,$F007,$0000,$0000
		dc.w	$E3E3,$FC00,$0000,$0000,$061C,$079F,$00E0,$0700
		dc.w	$7FC7,$803F,$0000,$0000,$1F28,$E070,$0000,$0000
		dc.w	$30E3,$3CFC,$0700,$3800,$FE38,$01FF,$0000,$0000
		dc.w	$F8D2,$0002,$0018,$0000,$4240,$0000,$C660,$0000
		dc.w	$0000,$0000,$0000,$0000,$000E,$038F,$00F0,$0300
		dc.w	$7BE3,$801F,$0000,$0000,$8FC4,$F000,$0000,$0000
		dc.w	$0073,$1C7C,$0780,$1800,$DF1C,$00FF,$0000,$0000
		dc.w	$7E20,$8000,$0000,$0000,$78F0,$FF08,$FFE8,$FFF0
		dc.w	$000B,$0007,$0007,$000F,$B700,$3B00,$C300,$FC00
		dc.w	$0003,$00E3,$003C,$00C0,$9EF8,$E007,$0000,$0000
		dc.w	$E3F1,$FC00,$0000,$0000,$001C,$071F,$01E0,$0600
		dc.w	$F7C7,$003F,$0000,$0000,$1F90,$E038,$0000,$0000
		dc.w	$00E7,$38F8,$0F00,$3000,$BE38,$01FF,$0000,$0000
		dc.w	$FC48,$0010,$0018,$0000,$8420,$4240,$C660,$0000
		dc.w	$0000,$0000,$0000,$0000,$001C,$031F,$01E0,$0200
		dc.w	$7FE3,$801F,$0000,$0000,$8FA0,$F000,$0000,$0000
		dc.w	$00E3,$18FC,$0F00,$1000,$FF1C,$00FF,$0000,$0000
		dc.w	$7D00,$8000,$0000,$0000,$F8F0,$FF10,$FFD0,$FFE0
		dc.w	$0007,$0003,$0003,$0007,$D800,$1F00,$E000,$FF00
		dc.w	$0007,$00C7,$0078,$0080,$1FF8,$E007,$0000,$0000
		dc.w	$E3E8,$FC00,$0000,$0000,$0038,$063F,$03C0,$0400
		dc.w	$FFC7,$003F,$0000,$0000,$1F48,$E018,$0000,$0000
		dc.w	$01C7,$31F8,$1E00,$2000,$FE38,$01FF,$0000,$0000
		dc.w	$FA10,$0018,$0018,$0000,$4240,$C660,$C660,$1008
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$8000,$8000,$8000,$4000
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

; VGT raster datas
linebuf	ds.b	160
sintab	incbin	sin1024.vgt
ang1	dc.w	0
curang1	dc.w	0
ang2	dc.w	0
curang2	dc.w	0
rast	dc.w	%101010101010101
	dc.w	%011001100110011
	dc.w	%000111100001111
	dc.w	%000000011111111
myzero	ds.l	15

; Small bottom text
INIT_T0:DC.W      $0000 
INIT_T1:DCB.W     2,0 
FONTE:
	dc.w	$0000,$0000,$0000,$3838
	dc.w	$3800,$3800,$6C24,$0000
	dc.w	$0000,$6CFE,$6CFE,$6C00
	dc.w	$7CD0,$7C16,$7C00,$CEDC
	dc.w	$3876,$E600,$7CD6,$70D6
	dc.w	$7C00,$3818,$0800,$0000
	dc.w	$1830,$3030,$1800,$3018
	dc.w	$1818,$3000,$5438,$FE38
	dc.w	$5400,$1010,$7C10,$1000
	dc.w	$0000,$3818,$0800,$0000
	dc.w	$7C00,$0000,$0000,$0038
	dc.w	$3800,$0E1C,$3870,$E000
	dc.w	$7CEE,$F6E6,$7C00,$3C7C
	dc.w	$1C1C,$1C00,$7C06,$7CE0
	dc.w	$FE00,$FC0E,$3E0E,$FC00
	dc.w	$EEEE,$FE0E,$0E00,$FCE0
	dc.w	$FC0E,$FC00,$7CE0,$FCE6
	dc.w	$7C00,$FE0C,$1838,$3800
	dc.w	$7CE6,$7CE6,$7C00,$7CE6
	dc.w	$7E06,$7C00,$0030,$0030
	dc.w	$0000,$0030,$0030,$1000
	dc.w	$1C38,$7038,$1C00,$007C
	dc.w	$007C,$0000,$7038,$1C38
	dc.w	$7000,$FC0E,$3C00,$3000
	dc.w	$7CEA,$EEE0,$7E00,$7CE6
	dc.w	$FEE6,$E600,$FCE6,$FCE6
	dc.w	$FC00,$7CE6,$E0E6,$7C00
	dc.w	$FCE6,$E6E6,$FC00,$FEE0
	dc.w	$F8E0,$FE00,$FEE0,$F8E0
	dc.w	$E000,$7EE0,$EEE6,$7E00
	dc.w	$E6E6,$FEE6,$E600,$7C38
	dc.w	$3838,$7C00,$0E0E,$0EEE
	dc.w	$7C00,$E6E6,$FCE6,$E600
	dc.w	$E0E0,$E0E0,$FE00,$C6EE
	dc.w	$F6E6,$E600,$E6F6,$EEE6
	dc.w	$E600,$7CE6,$E6E6,$7C00
	dc.w	$FCE6,$FCE0,$E000,$7CE6
	dc.w	$E6EC,$7600,$FCE6,$FCE6
	dc.w	$E600,$7EE0,$7C06,$FC00
	dc.w	$FE38,$3838,$3800,$E6E6
	dc.w	$E6E6,$7C00,$E6E6,$E66C
	dc.w	$3800,$E6E6,$F6EE,$C600
	dc.w	$E6E6,$7CE6,$E600,$E6E6
	dc.w	$7C38,$3800,$FE1C,$3870
	dc.w	$FE00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000
	
PTEXTE:
* 11 lines MAXI please !
	DC.B	'# THE BYTE PRESENTS COMPILE NUMBER XX2 #',0	* 1
	DC.B	'----------------------------------------',0	*	2
	DC.B	' F1..................PROGRAM NUMBER ONE ',0	*	3
	DC.B	' F2..................PROGRAM NUMBER TWO ',0	*	4
	DC.B	' F3................PROGRAM NUMBER THREE ',0	*	5
	DC.B	' F4.................PROGRAM NUMBER FOUR ',0	*	6
	DC.B	' F5.................PROGRAM NUMBER FIVE ',0	*	7
	DC.B	' F6..................PROGRAM NUMBER SIX ',0	*	8
	DC.B	' SPACE.............PROGRAM NUMBER SEVEN ',0	*	9
	DC.B  -1
	EVEN

; Loader datas
Emp	dc.b 'Z:\',0
	EVEN

Prog1							dc.b '1.BSW',0
Prog2							dc.b '2.BSW',0
Prog3							dc.b '3.BSW',0
Prog4							dc.b '4.BSW',0
Prog5							dc.b '5.BSW',0
Prog6							dc.b '6.BSW',0
Prog7							dc.b '7.BSW',0
Prog8							dc.b '8.BSW',0
Prog9							dc.b '9.BSW',0
ProgCrc						dc.b 'CRCCHECK.PRG',0
NOMPRG						ds.l	1

errtext:DC.b "PROBLEMS TO LOAD...          ",13,10,10,0
params: DC.b 0    ;aucun paramätre et
environ:DC.b 0    ;aucun environnement
	even

; Logo in intro
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
		      
MUSIC: * not compress please !
	incbin	*.snd
	even
      
******************************************************************

	SECTION	BSS

counter		ds.b	1

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
