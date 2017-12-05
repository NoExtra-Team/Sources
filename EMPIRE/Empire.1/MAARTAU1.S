* MAARTAU1.	PRG

* // Original code : Zorro 2/NoExtra 	// *
* // Gfx logo 	   : Mister.A/NoExtra 	// *
* // Music 	   : Sally 	   	// *
* // Release date  : 27/04/2007		// *

***********************************************
	OPT	o-,d-
***********************************************

	SECTION	TEXT

***********************************************
BOTTOM_BORDER	equ	0	; 0 = I use it and 1 = no need !
PATTERN		equ	$0	; put $0 to see nothing
DEBUG	equ	1	; permit the reset if pbl...
gemdos        equ	1
crawcin       equ	7
cconws        equ	9
mshrink       equ	$4a
pexec         equ	$4b
***********************************************

begin		bra	start
		ds.l	100
ustack		ds.l	1

EXECUTE
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

	pea        environ       ;Postchargement du programme
	pea        params
	move.l	  NOMPRG,-(SP)
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
	bsr	BYEBYE
FIN	
	CLR.W     -(A7) 	;PTERM0
	TRAP      #1

	*  FIN  *

start		move.l	4(a7),a0
		move.l	#ustack,a7
		move.l	#start-begin+$100,-(a7)	;keep only EXEC routine
		move.l	a0,-(a7)
		clr.w	-(a7)
		move.w	#$4a,-(a7)
		trap	#1
		lea	12(a7),a7
	
	clr.l	-(sp)
	move.w	#32,-(sp)
	trap	#1
	addq.l	#6,sp
	move.l	d0,Save_stack

	bsr	clear_bss
	
	bsr	Init_screens

	bsr	Save_and_init_a_st

	IFEQ DEBUG	;Le detournement des bombes.
	MOVE.L	#Reset,$8.W
	MOVE.L	#Reset,$C.W
	MOVE.L	#Reset,$10.W
	MOVE.L	#Reset,$14.W
	MOVE.L	#Reset,$18.W
	MOVE.L	#Reset,$1C.W
	MOVE.L	#Reset,$20.W
	MOVE	#$2300,sr
	ENDC
	
	bsr	fadein

	bsr	Init_screens_P1
	
	bsr	Put_MyTexte

	bsr	Put_Logo

	bsr	Init_P1
	
	bsr	delay

	bsr	fadeoff
	
	bsr	Init


******************************************************************************

Loop:

	bsr	Wait_vbl

	bra.s	Loop

******************************************************************************
BYEBYE:

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

Vbl:

	st	Vsync

	IFEQ	BOTTOM_BORDER
                  CLR.B     $FFFFFA1B.W 
                  MOVE.B    #$C7,$FFFFFA21.W
                  MOVE.L    #HBL,$120.W 
                  MOVE.B    #8,$FFFFA1B.L 
                  
                  BSR       KEY_READ
                  
                  jsr 	(MUSIC+8)			; call music
                	
                  BSR       COPY_LEFT 
                  BSR       COPY_RIGHT
                  BSR       COPY_DOWN 
                  BSR       COLOURS_COUNT 
                  MOVE      #$2700,SR 
                  MOVE.W    #$100,D1
                  LEA       $FFFF8209.W,A3
TEST:             TST.B     (A3)
                  BEQ.S     TEST
                  MOVEQ     #0,D0 
                  MOVE.B    (A3),D0 
                  LEA       JUMP,A3 
                  ADDA.L    D0,A3 
                  JMP       (A3)
JUMP:             NOP 
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
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  MOVE      #$2300,SR 
                  MOVE.W    #$15,D0 
                  LEA       COLR_BANK,A0
                  LEA       $FF8240.L,A1
COLP:             MOVE.W    Y_SIZE,D1 
COLOUR_LOOP:      NOP 
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
                  NOP 
                  NOP 
                  NOP 
                  SUBA.W    #$40,A0 
                  DBF       D1,COLOUR_LOOP
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
                  NOP 
                  LEA       2(A0),A0
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
                  DBF       D0,COLP 
	rte
	ENDC

KEY_READ:         CLR.B     D0
                  MOVE.B    $FFFC02.L,D0
                  CMPI.B    #$39+$80,D0 * SPACE + RELACHE
                  BEQ       EXIT
                  CMPI.B    #2,D0 * 1
                  BEQ.S     Run1
                  CMPI.B    #109,D0 * 1 KEYPAD
                  BEQ.S     Run1
                  CMPI.B    #3,D0 * 2
                  BEQ.S     Run2
                  CMPI.B    #110,D0 * 2 KEYPAD
                  BEQ.S     Run2
                  RTS

Run1:
	move.l	#PROG1,NOMPRG
	bra	BYEBYE
Run2:
	move.l	#PROG2,NOMPRG
	bra	BYEBYE

Emp	dc.b 'Z:\',0
	EVEN

Prog1							dc.b '1.BSW',0
Prog2							dc.b '2.BSW',0
NOMPRG						ds.l	1
	even
	
errtext:DC.b "PROBLEMS TO LOAD...          ",13,10,10,0
params: DC.b 0    ;aucun paramŠtre et
environ:DC.b 0    ;aucun environnement
	even
	
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

	movea.l	Zorro_scr2,a6
	move.w	#Zorro_screen2_len/4-1,d1
.fill:
	move.l	#PATTERN,(a6)+
	dbra	d1,.fill
	
	move.l	Zorro_scr1,d0
	move.b	d0,d1
	lsr.w	#8,d0
	move.b	d0,$ffff8203.w
	swap	d0
	move.b	d0,$ffff8201.w
	move.b	d1,$ffff820d.w
	
	lea	Vbl(pc),a0
	move.l	a0,$70.w

	lea	Pal_Maartau(pc),a0
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

	IFEQ	BOTTOM_BORDER
	MOVE.L    #HBL,$120.W 
  CLR.B     $FFFFFA09.W 
  MOVE.B    #1,$FFFFFA07.L
  MOVE.B    #1,$FFFFFA13.W
  CLR.B     $FFFFFA1B.W 
  BCLR      #6,$FFFFFA15.L
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

HBL:              CLR.B     $FFFFFA1B.W 
                  MOVEM.L   A0/D0,-(A7) 
                  MOVEA.W   #$FA21,A0 
                  MOVE.B    #$C8,(A0) 
                  MOVE.B    #8,$FFFFFA1B.W
                  MOVE.B    (A0),D0 
WAIT_2:           CMP.B     (A0),D0 
                  BEQ.S     WAIT_2
                  CLR.B     $FFFF820A.W 
                  MOVEQ     #2,D0 
LOOP_1:           NOP 
                  DBF       D0,LOOP_1 
                  MOVE.B    #2,$FFFF820A.W
                  MOVEM.L   (A7)+,A0/D0 
                  LEA       Pal_Maartau,A0
                  LEA       $FF8240.L,A1
                  MOVE.W    (A0)+,(A1)+ 
                  MOVE.W    (A0)+,(A1)+ 
                  MOVE.W    (A0)+,(A1)+ 
                  MOVE.W    (A0)+,(A1)+ 
                  MOVE.W    (A0)+,(A1)+ 
                  MOVE.W    (A0)+,(A1)+ 
                  MOVE.W    (A0)+,(A1)+ 
                  MOVE.W    (A0)+,(A1)+ 
                  MOVE.W    (A0)+,(A1)+ 
                  MOVE.W    (A0)+,(A1)+ 
                  MOVE.W    (A0)+,(A1)+ 
                  MOVE.W    (A0)+,(A1)+ 
                  MOVE.W    (A0)+,(A1)+ 
                  MOVE.W    (A0)+,(A1)+ 
                  MOVE.W    (A0)+,(A1)+ 
                  MOVE.W    (A0)+,(A1)+ 
                  BCLR      #0,$FFFFFA0F.W
                  MOVE      #$2700,SR 
                  LEA       $FFFF8209.W,A3
TEST2:            TST.B     (A3)
                  BEQ.S     TEST2 
                  MOVEQ     #0,D0 
                  MOVE.B    (A3),D0 
                  LEA       JUMP2,A3
                  ADDA.L    D0,A3 
                  JMP       (A3)
JUMP2:            NOP 
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
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  MOVE      #$2300,SR 
                  BRA.S     GER_ERE_AND_FUNK
                  RTE 
GER_ERE_AND_FUNK: NOP 
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
                  NOP 
                  NOP 
                  NOP 
                  NOP 
                  MOVE.W    #7,D0 
                  LEA       COLR_BANK2,A0 
                  LEA       $FF8240.L,A1
COLP2:            MOVE.W    Y_SIZE2,D1
COLOUR_LOOP2:     NOP 
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
                  NOP 
                  SUBA.W    #$44,A0 
                  DBF       D1,COLOUR_LOOP2 
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
                  LEA       2(A0),A0
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
                  DBF       D0,COLP2
                  MOVE.B    #0,$FF8240.L                
                  BSR.S     SCROLL_ROUT 
                  BSR.S     SCROLL_MAIN 
                  RTE 

SCROLL_ROUT:      ADDQ.W    #1,BIT_COUNT
                  CMPI.W    #9,BIT_COUNT
                  BNE.S     OUT_SCROLL
                  CLR.W     BIT_COUNT 
                  ADDQ.W    #1,LETTER 
                  LEA       TEXT,A0 
                  ADDA.W    LETTER,A0 
                  CMPI.B    #$FF,(A0) 
                  BNE.S     SCROLL_NEXT_LETT
                  LEA       TEXT,A0 
                  CLR.W     LETTER
SCROLL_NEXT_LETT: MOVEQ     #0,D0 
                  MOVE.B    (A0)+,D0
                  SUBI.W    #$20,D0 
                  MULU      #$10,D0 
                  LEA       FONT,A0 
                  ADDA.W    D0,A0 
                  LEA       TEMP_BUFFER,A1
                  MOVE.W    (A0)+,(A1)+ 
                  MOVE.W    (A0)+,(A1)+ 
                  MOVE.W    (A0)+,(A1)+ 
                  MOVE.W    (A0)+,(A1)+ 
                  MOVE.W    (A0)+,(A1)+ 
                  MOVE.W    (A0)+,(A1)+ 
                  MOVE.W    (A0)+,(A1)+ 
                  MOVE.W    (A0)+,(A1)+ 
OUT_SCROLL:       RTS 

SCROLL_MAIN:      LEA       COLR_BANK2,A0 
                  MOVE.W    2(A0),(A0)
                  MOVE.W    4(A0),2(A0) 
                  MOVE.W    6(A0),4(A0) 
                  MOVE.W    8(A0),6(A0) 
                  MOVE.W    10(A0),8(A0)
                  MOVE.W    12(A0),10(A0) 
                  MOVE.W    14(A0),12(A0) 
                  MOVE.W    16(A0),14(A0) 
                  MOVE.W    18(A0),16(A0) 
                  MOVE.W    20(A0),18(A0) 
                  MOVE.W    22(A0),20(A0) 
                  MOVE.W    24(A0),22(A0) 
                  MOVE.W    26(A0),24(A0) 
                  MOVE.W    28(A0),26(A0) 
                  MOVE.W    30(A0),28(A0) 
                  MOVE.W    32(A0),30(A0) 
                  MOVE.W    34(A0),32(A0) 
                  MOVE.W    36(A0),34(A0) 
                  MOVE.W    38(A0),36(A0) 
                  MOVE.W    40(A0),38(A0) 
                  MOVE.W    42(A0),40(A0) 
                  MOVE.W    44(A0),42(A0) 
                  MOVE.W    46(A0),44(A0) 
                  MOVE.W    48(A0),46(A0) 
                  MOVE.W    50(A0),48(A0) 
                  MOVE.W    52(A0),50(A0) 
                  MOVE.W    54(A0),52(A0) 
                  MOVE.W    56(A0),54(A0) 
                  MOVE.W    58(A0),56(A0) 
                  MOVE.W    60(A0),58(A0) 
                  MOVE.W    62(A0),60(A0) 
                  MOVE.W    64(A0),62(A0) 
                  MOVE.W    66(A0),64(A0) 
                  LEA       68(A0),A0 
                  MOVE.W    2(A0),(A0)
                  MOVE.W    4(A0),2(A0) 
                  MOVE.W    6(A0),4(A0) 
                  MOVE.W    8(A0),6(A0) 
                  MOVE.W    10(A0),8(A0)
                  MOVE.W    12(A0),10(A0) 
                  MOVE.W    14(A0),12(A0) 
                  MOVE.W    16(A0),14(A0) 
                  MOVE.W    18(A0),16(A0) 
                  MOVE.W    20(A0),18(A0) 
                  MOVE.W    22(A0),20(A0) 
                  MOVE.W    24(A0),22(A0) 
                  MOVE.W    26(A0),24(A0) 
                  MOVE.W    28(A0),26(A0) 
                  MOVE.W    30(A0),28(A0) 
                  MOVE.W    32(A0),30(A0) 
                  MOVE.W    34(A0),32(A0) 
                  MOVE.W    36(A0),34(A0) 
                  MOVE.W    38(A0),36(A0) 
                  MOVE.W    40(A0),38(A0) 
                  MOVE.W    42(A0),40(A0) 
                  MOVE.W    44(A0),42(A0) 
                  MOVE.W    46(A0),44(A0) 
                  MOVE.W    48(A0),46(A0) 
                  MOVE.W    50(A0),48(A0) 
                  MOVE.W    52(A0),50(A0) 
                  MOVE.W    54(A0),52(A0) 
                  MOVE.W    56(A0),54(A0) 
                  MOVE.W    58(A0),56(A0) 
                  MOVE.W    60(A0),58(A0) 
                  MOVE.W    62(A0),60(A0) 
                  MOVE.W    64(A0),62(A0) 
                  MOVE.W    66(A0),64(A0) 
                  LEA       68(A0),A0 
                  MOVE.W    2(A0),(A0)
                  MOVE.W    4(A0),2(A0) 
                  MOVE.W    6(A0),4(A0) 
                  MOVE.W    8(A0),6(A0) 
                  MOVE.W    10(A0),8(A0)
                  MOVE.W    12(A0),10(A0) 
                  MOVE.W    14(A0),12(A0) 
                  MOVE.W    16(A0),14(A0) 
                  MOVE.W    18(A0),16(A0) 
                  MOVE.W    20(A0),18(A0) 
                  MOVE.W    22(A0),20(A0) 
                  MOVE.W    24(A0),22(A0) 
                  MOVE.W    26(A0),24(A0) 
                  MOVE.W    28(A0),26(A0) 
                  MOVE.W    30(A0),28(A0) 
                  MOVE.W    32(A0),30(A0) 
                  MOVE.W    34(A0),32(A0) 
                  MOVE.W    36(A0),34(A0) 
                  MOVE.W    38(A0),36(A0) 
                  MOVE.W    40(A0),38(A0) 
                  MOVE.W    42(A0),40(A0) 
                  MOVE.W    44(A0),42(A0) 
                  MOVE.W    46(A0),44(A0) 
                  MOVE.W    48(A0),46(A0) 
                  MOVE.W    50(A0),48(A0) 
                  MOVE.W    52(A0),50(A0) 
                  MOVE.W    54(A0),52(A0) 
                  MOVE.W    56(A0),54(A0) 
                  MOVE.W    58(A0),56(A0) 
                  MOVE.W    60(A0),58(A0) 
                  MOVE.W    62(A0),60(A0) 
                  MOVE.W    64(A0),62(A0) 
                  MOVE.W    66(A0),64(A0) 
                  LEA       68(A0),A0 
                  MOVE.W    2(A0),(A0)
                  MOVE.W    4(A0),2(A0) 
                  MOVE.W    6(A0),4(A0) 
                  MOVE.W    8(A0),6(A0) 
                  MOVE.W    10(A0),8(A0)
                  MOVE.W    12(A0),10(A0) 
                  MOVE.W    14(A0),12(A0) 
                  MOVE.W    16(A0),14(A0) 
                  MOVE.W    18(A0),16(A0) 
                  MOVE.W    20(A0),18(A0) 
                  MOVE.W    22(A0),20(A0) 
                  MOVE.W    24(A0),22(A0) 
                  MOVE.W    26(A0),24(A0) 
                  MOVE.W    28(A0),26(A0) 
                  MOVE.W    30(A0),28(A0) 
                  MOVE.W    32(A0),30(A0) 
                  MOVE.W    34(A0),32(A0) 
                  MOVE.W    36(A0),34(A0) 
                  MOVE.W    38(A0),36(A0) 
                  MOVE.W    40(A0),38(A0) 
                  MOVE.W    42(A0),40(A0) 
                  MOVE.W    44(A0),42(A0) 
                  MOVE.W    46(A0),44(A0) 
                  MOVE.W    48(A0),46(A0) 
                  MOVE.W    50(A0),48(A0) 
                  MOVE.W    52(A0),50(A0) 
                  MOVE.W    54(A0),52(A0) 
                  MOVE.W    56(A0),54(A0) 
                  MOVE.W    58(A0),56(A0) 
                  MOVE.W    60(A0),58(A0) 
                  MOVE.W    62(A0),60(A0) 
                  MOVE.W    64(A0),62(A0) 
                  MOVE.W    66(A0),64(A0) 
                  LEA       68(A0),A0 
                  MOVE.W    2(A0),(A0)
                  MOVE.W    4(A0),2(A0) 
                  MOVE.W    6(A0),4(A0) 
                  MOVE.W    8(A0),6(A0) 
                  MOVE.W    10(A0),8(A0)
                  MOVE.W    12(A0),10(A0) 
                  MOVE.W    14(A0),12(A0) 
                  MOVE.W    16(A0),14(A0) 
                  MOVE.W    18(A0),16(A0) 
                  MOVE.W    20(A0),18(A0) 
                  MOVE.W    22(A0),20(A0) 
                  MOVE.W    24(A0),22(A0) 
                  MOVE.W    26(A0),24(A0) 
                  MOVE.W    28(A0),26(A0) 
                  MOVE.W    30(A0),28(A0) 
                  MOVE.W    32(A0),30(A0) 
                  MOVE.W    34(A0),32(A0) 
                  MOVE.W    36(A0),34(A0) 
                  MOVE.W    38(A0),36(A0) 
                  MOVE.W    40(A0),38(A0) 
                  MOVE.W    42(A0),40(A0) 
                  MOVE.W    44(A0),42(A0) 
                  MOVE.W    46(A0),44(A0) 
                  MOVE.W    48(A0),46(A0) 
                  MOVE.W    50(A0),48(A0) 
                  MOVE.W    52(A0),50(A0) 
                  MOVE.W    54(A0),52(A0) 
                  MOVE.W    56(A0),54(A0) 
                  MOVE.W    58(A0),56(A0) 
                  MOVE.W    60(A0),58(A0) 
                  MOVE.W    62(A0),60(A0) 
                  MOVE.W    64(A0),62(A0) 
                  MOVE.W    66(A0),64(A0) 
                  LEA       68(A0),A0 
                  MOVE.W    2(A0),(A0)
                  MOVE.W    4(A0),2(A0) 
                  MOVE.W    6(A0),4(A0) 
                  MOVE.W    8(A0),6(A0) 
                  MOVE.W    10(A0),8(A0)
                  MOVE.W    12(A0),10(A0) 
                  MOVE.W    14(A0),12(A0) 
                  MOVE.W    16(A0),14(A0) 
                  MOVE.W    18(A0),16(A0) 
                  MOVE.W    20(A0),18(A0) 
                  MOVE.W    22(A0),20(A0) 
                  MOVE.W    24(A0),22(A0) 
                  MOVE.W    26(A0),24(A0) 
                  MOVE.W    28(A0),26(A0) 
                  MOVE.W    30(A0),28(A0) 
                  MOVE.W    32(A0),30(A0) 
                  MOVE.W    34(A0),32(A0) 
                  MOVE.W    36(A0),34(A0) 
                  MOVE.W    38(A0),36(A0) 
                  MOVE.W    40(A0),38(A0) 
                  MOVE.W    42(A0),40(A0) 
                  MOVE.W    44(A0),42(A0) 
                  MOVE.W    46(A0),44(A0) 
                  MOVE.W    48(A0),46(A0) 
                  MOVE.W    50(A0),48(A0) 
                  MOVE.W    52(A0),50(A0) 
                  MOVE.W    54(A0),52(A0) 
                  MOVE.W    56(A0),54(A0) 
                  MOVE.W    58(A0),56(A0) 
                  MOVE.W    60(A0),58(A0) 
                  MOVE.W    62(A0),60(A0) 
                  MOVE.W    64(A0),62(A0) 
                  MOVE.W    66(A0),64(A0) 
                  LEA       68(A0),A0 
                  MOVE.W    2(A0),(A0)
                  MOVE.W    4(A0),2(A0) 
                  MOVE.W    6(A0),4(A0) 
                  MOVE.W    8(A0),6(A0) 
                  MOVE.W    10(A0),8(A0)
                  MOVE.W    12(A0),10(A0) 
                  MOVE.W    14(A0),12(A0) 
                  MOVE.W    16(A0),14(A0) 
                  MOVE.W    18(A0),16(A0) 
                  MOVE.W    20(A0),18(A0) 
                  MOVE.W    22(A0),20(A0) 
                  MOVE.W    24(A0),22(A0) 
                  MOVE.W    26(A0),24(A0) 
                  MOVE.W    28(A0),26(A0) 
                  MOVE.W    30(A0),28(A0) 
                  MOVE.W    32(A0),30(A0) 
                  MOVE.W    34(A0),32(A0) 
                  MOVE.W    36(A0),34(A0) 
                  MOVE.W    38(A0),36(A0) 
                  MOVE.W    40(A0),38(A0) 
                  MOVE.W    42(A0),40(A0) 
                  MOVE.W    44(A0),42(A0) 
                  MOVE.W    46(A0),44(A0) 
                  MOVE.W    48(A0),46(A0) 
                  MOVE.W    50(A0),48(A0) 
                  MOVE.W    52(A0),50(A0) 
                  MOVE.W    54(A0),52(A0) 
                  MOVE.W    56(A0),54(A0) 
                  MOVE.W    58(A0),56(A0) 
                  MOVE.W    60(A0),58(A0) 
                  MOVE.W    62(A0),60(A0) 
                  MOVE.W    64(A0),62(A0) 
                  MOVE.W    66(A0),64(A0) 
                  LEA       68(A0),A0 
                  MOVE.W    2(A0),(A0)
                  MOVE.W    4(A0),2(A0) 
                  MOVE.W    6(A0),4(A0) 
                  MOVE.W    8(A0),6(A0) 
                  MOVE.W    10(A0),8(A0)
                  MOVE.W    12(A0),10(A0) 
                  MOVE.W    14(A0),12(A0) 
                  MOVE.W    16(A0),14(A0) 
                  MOVE.W    18(A0),16(A0) 
                  MOVE.W    20(A0),18(A0) 
                  MOVE.W    22(A0),20(A0) 
                  MOVE.W    24(A0),22(A0) 
                  MOVE.W    26(A0),24(A0) 
                  MOVE.W    28(A0),26(A0) 
                  MOVE.W    30(A0),28(A0) 
                  MOVE.W    32(A0),30(A0) 
                  MOVE.W    34(A0),32(A0) 
                  MOVE.W    36(A0),34(A0) 
                  MOVE.W    38(A0),36(A0) 
                  MOVE.W    40(A0),38(A0) 
                  MOVE.W    42(A0),40(A0) 
                  MOVE.W    44(A0),42(A0) 
                  MOVE.W    46(A0),44(A0) 
                  MOVE.W    48(A0),46(A0) 
                  MOVE.W    50(A0),48(A0) 
                  MOVE.W    52(A0),50(A0) 
                  MOVE.W    54(A0),52(A0) 
                  MOVE.W    56(A0),54(A0) 
                  MOVE.W    58(A0),56(A0) 
                  MOVE.W    60(A0),58(A0) 
                  MOVE.W    62(A0),60(A0) 
                  MOVE.W    64(A0),62(A0) 
                  MOVE.W    66(A0),64(A0) 
                  LEA       68(A0),A0 
                  LEA       COLR_BANK2,A0 
                  LEA       TEMP_BUFFER,A1
                  MOVE.W    #7,D0 
COME_HERE:        ROXL      (A1)+ 
                  BCS.S     SLAP_DOWN 
                  MOVE.W    #0,66(A0) 
                  BRA.S     OUT_REP 
SLAP_DOWN:        MOVE.W    (A6),66(A0) 
OUT_REP:          LEA       2(A6),A6
                  LEA       68(A0),A0 
                  DBF       D0,COME_HERE
                  RTS 
COLOURS_COUNT:    ADDQ.W    #2,COLOR_PNT
                  CMPI.W    #$72,COLOR_PNT
                  BNE.S     OUT_COLOR 
                  CLR.W     COLOR_PNT 
OUT_COLOR:        LEA       COLORS,A6 
                  ADDA.W    COLOR_PNT,A6
                  RTS 
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

DECALH	equ	0*160

Put_Logo:
	movem.l	d0-d7/a0-a6,-(a7)
	
	movea.l	Zorro_scr1,a0
	lea	DECALH(a0),a0
	move.l	#Logo_Maartau,a1
	move.l	#7999-6600+500,d0
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

	lea	PalNoeXtra(pc),a0
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

COPY_LEFT:        LEA       COLR_BANK,A0
	rept 25
                  MOVE.W    2(A0),(A0)
                  MOVE.W    4(A0),2(A0) 
                  MOVE.W    6(A0),4(A0) 
                  MOVE.W    8(A0),6(A0) 
                  MOVE.W    10(A0),8(A0)
                  MOVE.W    12(A0),10(A0) 
                  MOVE.W    14(A0),12(A0) 
                  MOVE.W    16(A0),14(A0) 
                  MOVE.W    18(A0),16(A0) 
                  MOVE.W    20(A0),18(A0) 
                  MOVE.W    22(A0),20(A0) 
                  MOVE.W    24(A0),22(A0) 
                  MOVE.W    26(A0),24(A0) 
                  MOVE.W    28(A0),26(A0) 
                  MOVE.W    30(A0),28(A0) 
                  MOVE.W    32(A0),30(A0) 
                  LEA       64(A0),A0 
	endr                  
                  RTS 
                  
COPY_RIGHT:       LEA       COLR_BANK,A0
	rept	25
                  MOVE.W    60(A0),62(A0) 
                  MOVE.W    58(A0),60(A0) 
                  MOVE.W    56(A0),58(A0) 
                  MOVE.W    54(A0),56(A0) 
                  MOVE.W    52(A0),54(A0) 
                  MOVE.W    50(A0),52(A0) 
                  MOVE.W    48(A0),50(A0) 
                  MOVE.W    46(A0),48(A0) 
                  MOVE.W    44(A0),46(A0) 
                  MOVE.W    42(A0),44(A0) 
                  MOVE.W    40(A0),42(A0) 
                  MOVE.W    38(A0),40(A0) 
                  MOVE.W    36(A0),38(A0) 
                  MOVE.W    34(A0),36(A0) 
                  MOVE.W    32(A0),34(A0) 
                  MOVE.W    30(A0),32(A0) 
                  LEA       64(A0),A0 
	endr
                  RTS 

COPY_DOWN:        LEA       COLR_BANK,A0
                  ADDA.W    #$20,A0 
                  MOVE.W    1216(A0),1280(A0) 
                  MOVE.W    1152(A0),1216(A0) 
                  MOVE.W    1088(A0),1152(A0) 
                  MOVE.W    1024(A0),1088(A0) 
                  MOVE.W    960(A0),1024(A0)
                  MOVE.W    896(A0),960(A0) 
                  MOVE.W    832(A0),896(A0) 
                  MOVE.W    768(A0),832(A0) 
                  MOVE.W    704(A0),768(A0) 
                  MOVE.W    640(A0),704(A0) 
                  MOVE.W    576(A0),640(A0) 
                  MOVE.W    512(A0),576(A0) 
                  MOVE.W    448(A0),512(A0) 
                  MOVE.W    384(A0),448(A0) 
                  MOVE.W    320(A0),384(A0) 
                  MOVE.W    256(A0),320(A0) 
                  MOVE.W    192(A0),256(A0) 
                  MOVE.W    128(A0),192(A0) 
                  MOVE.W    64(A0),128(A0)
                  MOVE.W    (A0),64(A0) 
                  RTS 

DECAL_TXT	equ	((160*48)+6)

Put_MyTexte:
	movem.l	d0-d7/a0-a6,-(a7)
	
	MOVEA.L	Zorro_scr1,A3 
	LEA	DECAL_TXT(A3),A3
	BSR.S       PUT_TEXTE

	movem.l	(a7)+,d0-d7/a0-a6
  RTS
  	
PUT_TEXTE:
      LEA       TEXTE(PC),A1
      MOVEA.L   A3,A4 
      BRA.S     REPEAT 
NEXT_POS:ADDA.L    #6,A3 
REPEAT:MOVEQ     #1,D0 
NEXT_CAR:CLR.L     D1
      MOVEA.L   A3,A2 
      LEA       FONTE(PC),A0
      MOVE.B    (A1)+,D1
      TST.B     D1
      BNE.S     COPY_CAR 
      RTS 
      
COPY_CAR:CMPI.B    #$72,D1 
      BEQ.S     NEXT_LINE 
      SUBI.L    #$20,D1 
      MULU      #8,D1 
      ADDA.W    D1,A0 
      MOVEQ     #7,D2 
.loop:MOVE.B    (A0)+,(A2)
      LEA       160(A2),A2
      DBF       D2,.loop
      ADDA.L    #1,A3 
      DBF       D0,NEXT_CAR
      BRA.S     NEXT_POS 
NEXT_LINE:ADDA.L    #$500,A4
      MOVEA.L   A4,A3 
      BRA.S     REPEAT 

fadein:
		  move.l	#$777,d0
deg	  bsr.s	wart
		  bsr.s	wart
		  bsr.s	wart
		  lea	$ffff8240.w,a0
		  moveq	#15,d1
chg1  move.w	d0,(a0)+
		  dbf	d1,chg1
		  sub.w	#$111,d0
		  bne.s	deg
		  clr.w	$ffff8240.w
		  rts
      
wart  move.l	d0,-(sp)
		  move.l	$466.w,d0
att	  cmp.l	$466.w,d0
		  beq.s	att
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
	      		
******************************************************************

	SECTION	DATA

BIT_COUNT:
	DC.B	$00,$00 
TEMP_BUFFER:
	DCB.W     32,$0
LETTER:
	DC.W      $0 
Y_SIZE2:
	DC.W      $1 
TEXT:
	DC.B      '        '
	DC.B      'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
	DC.B	  ' 0123456789 '
	DC.B      ' (),:!?./*-+',$27
  DC.B      '        '

  DC.B      $FF,$FF,$FF,$00 
  EVEN
                  
FONT:
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$CC00,$CC00,$CC00,$CC00
	dc.w	$CC00,$CC00,$0000,$CC00
	dc.w	$6600,$CC00,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$6600,$FF00,$FF00,$6600
	dc.w	$6600,$FF00,$FF00,$6600
	dc.w	$7F00,$FF00,$D800,$FE00
	dc.w	$7F00,$1B00,$FF00,$FE00
	dc.w	$C300,$C700,$0E00,$1C00
	dc.w	$3800,$7000,$E300,$C300
	dc.w	$FF00,$FF00,$FF00,$FF00
	dc.w	$FF00,$FF00,$FF00,$FF00
	dc.w	$3000,$6000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$3000,$6000,$6000,$6000
	dc.w	$6000,$6000,$6000,$3000
	dc.w	$0C00,$0600,$0600,$0600
	dc.w	$0600,$0600,$0600,$0C00
	dc.w	$D600,$FE00,$7C00,$FE00
	dc.w	$FE00,$7C00,$FE00,$D600
	dc.w	$3000,$3000,$3000,$FC00
	dc.w	$FC00,$3000,$3000,$3000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$3000,$6000
	dc.w	$0000,$0000,$0000,$FF00
	dc.w	$FF00,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$6000,$6000
	dc.w	$0300,$0700,$0E00,$1C00
	dc.w	$3800,$7000,$E000,$C000
	dc.w	$7E00,$FF00,$CF00,$DF00
	dc.w	$FB00,$F300,$FF00,$7E00
	dc.w	$3800,$7800,$7800,$1800
	dc.w	$1800,$1800,$7E00,$7E00
	dc.w	$7E00,$FF00,$C700,$0E00
	dc.w	$3C00,$7000,$FF00,$FF00
	dc.w	$FE00,$FF00,$0700,$3E00
	dc.w	$3E00,$0700,$FF00,$FE00
	dc.w	$C000,$D800,$D800,$FF00
	dc.w	$FF00,$1800,$1800,$1800
	dc.w	$FF00,$FF00,$C000,$FE00
	dc.w	$FF00,$0300,$FF00,$FE00
	dc.w	$C000,$C000,$C000,$FE00
	dc.w	$FF00,$C300,$FF00,$7E00
	dc.w	$FF00,$FF00,$0E00,$1C00
	dc.w	$3800,$7000,$E000,$C000
	dc.w	$7E00,$FF00,$E700,$7E00
	dc.w	$7E00,$E700,$FF00,$7E00
	dc.w	$7E00,$FF00,$C300,$FF00
	dc.w	$7F00,$0300,$0300,$0300
	dc.w	$0000,$1800,$1800,$0000
	dc.w	$0000,$1800,$1800,$0000
	dc.w	$0000,$1800,$1800,$0000
	dc.w	$0000,$1800,$1800,$3000
	dc.w	$0C00,$1C00,$3800,$7000
	dc.w	$7000,$3800,$1C00,$0C00
	dc.w	$0000,$FF00,$FF00,$0000
	dc.w	$0000,$FF00,$FF00,$0000
	dc.w	$3000,$3800,$1C00,$0E00
	dc.w	$0E00,$1C00,$3800,$3000
	dc.w	$7E00,$FF00,$C300,$1F00
	dc.w	$1E00,$0000,$1800,$1800
	dc.w	$FF00,$9900,$9900,$FF00
	dc.w	$C300,$8100,$BD00,$FF00
	dc.w	$7E00,$FF00,$C300,$FF00
	dc.w	$FF00,$C300,$C300,$C300
	dc.w	$FE00,$FF00,$C300,$FE00
	dc.w	$FE00,$C300,$FF00,$FE00
	dc.w	$7E00,$FF00,$C300,$C000
	dc.w	$C000,$C300,$FF00,$7E00
	dc.w	$F800,$FC00,$CE00,$C700
	dc.w	$C300,$C300,$FF00,$FE00
	dc.w	$FF00,$FF00,$C000,$F800
	dc.w	$F800,$C000,$FF00,$FF00
	dc.w	$FF00,$FF00,$C000,$F800
	dc.w	$F800,$C000,$C000,$C000
	dc.w	$7F00,$FF00,$C000,$CF00
	dc.w	$CF00,$C300,$FF00,$7F00
	dc.w	$C300,$C300,$C300,$FF00
	dc.w	$FF00,$C300,$C300,$C300
	dc.w	$FF00,$FF00,$1800,$1800
	dc.w	$1800,$1800,$FF00,$FF00
	dc.w	$FF00,$FF00,$0600,$0600
	dc.w	$C600,$C600,$FE00,$7C00
	dc.w	$C300,$C700,$CE00,$FC00
	dc.w	$FC00,$CE00,$C700,$C300
	dc.w	$C000,$C000,$C000,$C000
	dc.w	$C000,$C000,$FF00,$FF00
	dc.w	$C300,$E700,$FF00,$FF00
	dc.w	$DB00,$C300,$C300,$C300
	dc.w	$C300,$E300,$F300,$FB00
	dc.w	$DF00,$CF00,$C700,$C300
	dc.w	$7E00,$FF00,$C300,$C300
	dc.w	$C300,$C300,$FF00,$7E00
	dc.w	$FE00,$FF00,$C300,$FF00
	dc.w	$FE00,$C000,$C000,$C000
	dc.w	$7E00,$FF00,$C300,$DB00
	dc.w	$DF00,$CF00,$FF00,$7F00
	dc.w	$FE00,$FF00,$C300,$FF00
	dc.w	$FE00,$CE00,$C700,$C300
	dc.w	$7F00,$FF00,$C000,$FE00
	dc.w	$7F00,$0300,$FF00,$FE00
	dc.w	$FF00,$FF00,$1800,$1800
	dc.w	$1800,$1800,$1800,$1800
	dc.w	$C300,$C300,$C300,$C300
	dc.w	$C300,$C300,$FF00,$7E00
	dc.w	$C300,$C300,$C300,$E700
	dc.w	$6600,$7E00,$3C00,$3C00
	dc.w	$C300,$C300,$C300,$DB00
	dc.w	$FF00,$FF00,$E700,$C300
	dc.w	$C300,$E700,$7E00,$3C00
	dc.w	$3C00,$7E00,$E700,$C300
	dc.w	$C300,$E700,$7E00,$3C00
	dc.w	$1800,$1800,$1800,$1800
	dc.w	$FF00,$FF00,$0E00,$1C00
	dc.w	$3800,$7000,$FF00,$FF00
COLR_BANK2:
	DCB.W     680,0 
COLORS:
	dc.w	$0777,$0776,$0775,$0774
	dc.w	$0773,$0772,$0771,$0671
	dc.w	$0571,$0471,$0371,$0271
	dc.w	$0171,$0071,$0072,$0073
	dc.w	$0074,$0075,$0076,$0077
	dc.w	$0066,$0055,$0044,$0033
	dc.w	$0333,$0444,$0555,$0666
	dc.w	$0777,$0776,$0775,$0774
	dc.w	$0764,$0754,$0744,$0734
	dc.w	$0724,$0714,$0704,$0703
	dc.w	$0702,$0603,$0504,$0405
	dc.w	$0306,$0207,$0127,$0137
	dc.w	$0147,$0157,$0167,$0177
	dc.w	$0277,$0377,$0477,$0577
	dc.w	$0677,$0777,$0776,$0775
	dc.w	$0774,$0773,$0772,$0771
	dc.w	$0671,$0571,$0471,$0371
	dc.w	$0271,$0171,$0071,$0072
	dc.w	$0073,$0074,$0075,$0076
	dc.w	$0077,$0066,$0055,$0044
	dc.w	$0033,$0333,$0444,$0555
	dc.w	$0666,$0777,$0776,$0775
	dc.w	$0774,$0764,$0754,$0744
	dc.w	$0734,$0724,$0714,$0704
	dc.w	$0703,$0702,$0603,$0504
	dc.w	$0405,$0306,$0207,$0127
	dc.w	$0137,$0147,$0157,$0167
	dc.w	$0177,$0277,$0377,$0477
	dc.w	$0577,$0677,$0777,$0776
	dc.w	$0775,$0774,$0773,$0772
	dc.w	$0771,$0671,$0571,$0471
	dc.w	$0371,$0271,$0171,$0071
	dc.w	$0072,$0073,$0074,$0075
	dc.w	$0076,$0077,$0066,$0055
	dc.w	$0044,$0033,$0333,$0444
	dc.w	$0555,$0666,$0777,$0776
	dc.w	$0775,$0774,$0764,$0754
	dc.w	$0744,$0734,$0724,$0714
	dc.w	$0704,$0703,$0702,$0603
	dc.w	$0504,$0405,$0306,$0207
	dc.w	$0127,$0137,$0147,$0157
	dc.w	$0167,$0177,$0277,$0377
	dc.w	$0477,$0577,$0677,$0000
	dc.w	$0000
COLOR_PNT:
	dc.w	$0000,$0020,$0020,$0020
	rept	24
	dc.w	$0020,$0020,$0020,$0020
	endr
	dc.w	$0020,$0000,$0002,$0000
COLR_BANK:
	DCB.W	1233,0
  DC.B	$07,'w',$00,$00,$00,$00,$00,$00 
  DCB.W	97,0
  DC.B	$00,$FF,$00,$FF,$00,$00 
Y_SIZE:
	dc.w	$0006,$0000

*
FONTE:
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$6060,$6060,$6000,$6000
	dc.w	$CC66,$0000,$0000,$0000
	dc.w	$66CC,$0000,$0000,$0000
	dc.w	$107C,$D078,$14F8,$1000
	dc.w	$00CC,$D830,$60CC,$8C00
	dc.w	$386C,$3870,$DECC,$7600
	dc.w	$0C0C,$1800,$0000,$0000
	dc.w	$3870,$6060,$6070,$3800
	dc.w	$381C,$0C0C,$0C1C,$3800
	dc.w	$005A,$3C7E,$3C5A,$0000
	dc.w	$0030,$30FC,$3030,$0000
	dc.w	$0000,$0000,$6060,$C000
	dc.w	$0000,$FCFC,$0000,$0000
	dc.w	$0000,$0000,$0060,$6000
	dc.w	$060E,$1C38,$70E0,$C000
	dc.w	$6CC6,$C6C6,$C6C6,$6C00
	dc.w	$7030,$3030,$3030,$FC00
	dc.w	$6CCE,$1C38,$70E2,$CE00
	dc.w	$6CC6,$061C,$06C6,$6C00
	dc.w	$1636,$66C6,$F706,$1600
	dc.w	$EEC2,$C0EC,$06C6,$6C00
	dc.w	$6CC6,$C0EC,$C6C6,$6C00
	dc.w	$F68E,$1C38,$70E0,$C000
	dc.w	$6CC6,$C66C,$C6C6,$6C00
	dc.w	$6CC6,$C66E,$06C6,$6C00
	dc.w	$0000,$3030,$0030,$3000
	dc.w	$0000,$3030,$0030,$6000
	dc.w	$1830,$60E0,$6030,$1800
	dc.w	$00FC,$FC00,$FCFC,$0000
	dc.w	$C060,$3038,$3060,$C000
	dc.w	$78FC,$CC18,$3000,$3000
	dc.w	$78CC,$DCD4,$DCC0,$7C00
	dc.w	$1038,$1C4C,$4C6C,$CE00
	dc.w	$D8CC,$CCD8,$CCCC,$D800
	dc.w	$6CC6,$C0C0,$C0C6,$6C00
	dc.w	$EC66,$6666,$6666,$EC00
	dc.w	$EE62,$646C,$6462,$EE00
	dc.w	$EE62,$646C,$6460,$F000
	dc.w	$6CC6,$C0CE,$C6C6,$6E00
	dc.w	$EE64,$646C,$6464,$EE00
	dc.w	$3C18,$1818,$1818,$3C00
	dc.w	$1E0C,$0C0C,$0CCC,$6800
	dc.w	$F664,$686C,$6464,$F600
	dc.w	$F060,$6060,$6062,$EE00
	dc.w	$C366,$763A,$1242,$E700
	dc.w	$CE64,$7038,$1C4C,$E400
	dc.w	$6CC6,$C6C6,$C6C6,$6C00
	dc.w	$EC66,$666C,$6060,$F000
	dc.w	$6CC6,$C6C6,$D6DA,$6C00
	dc.w	$EC66,$666C,$6466,$F600
	dc.w	$6CC6,$F07C,$1EC6,$6C00
	dc.w	$DB99,$1818,$1818,$3C00
	dc.w	$EE64,$6464,$6464,$2800
	dc.w	$7632,$323A,$181C,$0800
	dc.w	$DBD9,$CC6C,$6636,$3300
	dc.w	$C6EE,$5C38,$74EE,$C600
	dc.w	$EE64,$7430,$3030,$7800
	dc.w	$F68E,$1C38,$70E2,$DE00
TEXTE:
;	DC.B      'ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789 ..r'
;	DC.B      '()!,-+:?;/',$27,'                             r'

	DC.B      '----------------------------------------r'
	DC.B      '!        MAARTAU AND CO. PRESENT       !r'
	DC.B      '----------------------------------------r'
	DC.B      '!         THE NAME OF THE GAME         !r'
	DC.B      '----------------------------------------r'
	DC.B      '!                                      !r'
	DC.B      '!        1) FRENCH VERSION             !r'
	DC.B      '!        2) ENGLISH VERSION            !r'
	DC.B      '!                                      !r'
	DC.B      '----------------------------------------r'
	DC.B      '! GREETS :                             !r'
	DC.B      '! TOTO                                 !r'
	DC.B      '!     TOTO                             !r'
	DC.B      '!         TOTO                         !r'
	DC.B      '!             TOTO                     !r'
	DC.B      '!                 TOTO                 !r'
	DC.B      '!                     TOTO             !r'
	DC.B      '!                         TOTO         !r'
	DC.B      '----------------------------------------r'
			
	DC.W      $0000
  	EVEN

* -> Merci Mister.A !
Pal_Maartau:
	dc.w      $0000,$0888,$0111,$0999,$0222,$0AAA,$0333,$0BBB
	dc.w      $0444,$0CCC,$0555,$0DDD,$0666,$0EEE,$0777,$0777
	
Logo_Maartau:
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0100,$0000,$0000,$0000
		dc.w	$0040,$0000,$0000,$0000,$0007,$001F,$0017,$000F
		dc.w	$F800,$FC00,$FD00,$FE00,$0003,$000F,$000B,$0007
		dc.w	$FC00,$FE00,$FE80,$FF00,$003F,$003F,$003F,$003F
		dc.w	$FF80,$FFC0,$FF40,$FF80,$07FF,$0FFF,$0BFF,$07FF
		dc.w	$FBE0,$E400,$F000,$FFF0,$003F,$00FF,$00BF,$007F
		dc.w	$C000,$E000,$E800,$F000,$03FC,$03FC,$03FC,$03FC
		dc.w	$1B30,$0ED0,$712C,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0080,$0100,$0180,$0000
		dc.w	$0080,$0040,$00C0,$0000,$001D,$0039,$0059,$003E
		dc.w	$E140,$E1C0,$E280,$1F00,$000E,$001C,$002C,$001F
		dc.w	$F0A0,$F0E0,$F140,$0F80,$003F,$003F,$003F,$003F
		dc.w	$FFC0,$FFE0,$FFD0,$FFE0,$0FFF,$1FFF,$2FFF,$1FFF
		dc.w	$F720,$EB00,$F300,$FCF0,$00EF,$01CF,$02CF,$01F0
		dc.w	$0A00,$0E00,$1400,$F800,$03FC,$03FC,$03FC,$03FC
		dc.w	$657C,$7FFC,$7B6C,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$01C0,$0040,$0180
		dc.w	$0000,$01C0,$0100,$00C0,$007C,$0023,$002E,$0070
		dc.w	$0B80,$F740,$0F40,$0080,$003E,$0011,$0017,$0038
		dc.w	$05C0,$FBA0,$07A0,$0040,$003F,$003F,$003F,$003F
		dc.w	$FFF0,$FFF0,$FFE0,$FFF0,$3FFF,$3FFF,$1FFF,$3FFF
		dc.w	$FF90,$E770,$F710,$F8E0,$03E0,$011F,$0170,$0380
		dc.w	$5C00,$BA00,$7A00,$0400,$03FC,$03FC,$03FC,$03FC
		dc.w	$6D7C,$7FFC,$7B6C,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0080,$0060,$01A0,$01C0
		dc.w	$0080,$0300,$02C0,$01C0,$00FD,$0043,$00DE,$0060
		dc.w	$BE20,$11A0,$0F80,$0040,$007E,$0021,$006F,$0030
		dc.w	$DF10,$88D0,$07C0,$0020,$003F,$003F,$003F,$003F
		dc.w	$C7F0,$C7F8,$C7F8,$CFF0,$3FFF,$7FFF,$7FFF,$3FFF
		dc.w	$FAA0,$E380,$F360,$FCF0,$07ED,$0218,$06F0,$0300
		dc.w	$F100,$8D00,$7C00,$0200,$03FC,$03FC,$03FC,$03FC
		dc.w	$7D6C,$7BEC,$7F7C,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00C0,$00B0,$01D0,$01E0
		dc.w	$0180,$0680,$05C0,$03C0,$007C,$00C2,$007F,$00C0
		dc.w	$0F20,$1080,$1FA0,$0040,$003E,$0061,$003F,$0060
		dc.w	$0790,$0840,$8FD0,$0020,$003F,$003F,$003F,$003F
		dc.w	$C7F0,$C7F8,$C7F0,$C7F8,$3FFF,$7FFF,$3FFF,$7FFF
		dc.w	$FB80,$E300,$F360,$FCF0,$03E0,$0610,$03F8,$0600
		dc.w	$7900,$8400,$FD00,$0200,$03FC,$03FC,$03FC,$03FC
		dc.w	$7D6C,$7B6C,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00A0,$00D8,$01E8,$01F0
		dc.w	$0280,$0D80,$0BC0,$07C0,$00FD,$0082,$00BF,$00C0
		dc.w	$1780,$0840,$0FC0,$1020,$007E,$0041,$005F,$0060
		dc.w	$8BC0,$0420,$87E0,$0810,$003F,$003F,$003F,$003F
		dc.w	$C7F8,$C7F8,$C7F8,$C7F8,$7FFF,$7FFF,$7FFF,$7FFF
		dc.w	$F9C0,$E140,$F120,$FEF0,$07E8,$0410,$05F8,$0600
		dc.w	$BC00,$4200,$7E00,$8100,$03FC,$03FC,$03FC,$03FC
		dc.w	$7C7C,$7B6C,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0010,$00EC,$01F4,$01F8
		dc.w	$0400,$1B80,$17C0,$0FC0,$00BC,$0083,$00BF,$00C0
		dc.w	$0F80,$0840,$1FC0,$1020,$005E,$0041,$005F,$0060
		dc.w	$07C0,$8420,$8FE0,$0810,$003F,$003F,$003F,$003F
		dc.w	$C7F8,$C7F8,$C7F8,$C7F8,$0000,$0000,$0000,$0000
		dc.w	$0D80,$0340,$0020,$0FF0,$05E0,$0418,$05F8,$0600
		dc.w	$7C00,$4200,$FE00,$8100,$02FC,$03FC,$03FC,$03FC
		dc.w	$7C7C,$7F6C,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$01E8,$0116,$00FA,$01FC
		dc.w	$0F00,$3080,$2FC0,$1FC0,$00BD,$0083,$00BF,$00C0
		dc.w	$1780,$1040,$17C0,$1820,$005E,$0041,$005F,$0060
		dc.w	$8BC0,$8820,$8BE0,$0C10,$203F,$003F,$003F,$003F
		dc.w	$C7F8,$C7F8,$C7F8,$C7F8,$0000,$0000,$0000,$0000
		dc.w	$0B90,$0590,$03B0,$0F60,$05E8,$0418,$05F8,$0600
		dc.w	$BC00,$8200,$BE00,$C100,$03FC,$03FC,$03FC,$03FC
		dc.w	$7FFC,$7F6C,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00FD,$0103,$00FD,$01FE
		dc.w	$0E00,$6080,$5FC0,$3FC0,$00BC,$0082,$00BE,$00C1
		dc.w	$1780,$1040,$17C0,$1820,$105E,$1041,$005F,$0060
		dc.w	$0BC0,$0820,$0BE0,$8C10,$003F,$403F,$003F,$003F
		dc.w	$C7F8,$C7F8,$C7F8,$C7F8,$0000,$0000,$0000,$0000
		dc.w	$0D20,$0190,$01B0,$0E60,$05E0,$0410,$05F0,$0608
		dc.w	$BC00,$8200,$BE00,$C100,$02FC,$03FC,$03FC,$03FC
		dc.w	$7FFC,$7F7C,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$017F,$0001,$00FE,$01FF
		dc.w	$9FC0,$4140,$3E80,$FFC0,$00BC,$0082,$00BE,$00C1
		dc.w	$1780,$1040,$17C0,$1820,$085E,$0041,$085F,$0060
		dc.w	$0BC0,$0820,$0BE0,$8C10,$803F,$803F,$003F,$003F
		dc.w	$C7F8,$C7F8,$C7F8,$C7F8,$0000,$0000,$0000,$0000
		dc.w	$0860,$0000,$0010,$0FE0,$05E0,$0410,$05F0,$0608
		dc.w	$BC00,$8200,$BE00,$C100,$02FC,$03FC,$03FC,$03FC
		dc.w	$7FFC,$7F7C,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$017F,$0000,$00FF,$01FF
		dc.w	$3F80,$0140,$FE80,$FFC0,$00BC,$0082,$00BE,$00C1
		dc.w	$1780,$1040,$17C0,$1820,$045E,$0441,$045F,$0060
		dc.w	$0BC0,$0820,$0BE1,$8C10,$003F,$003F,$003F,$003F
		dc.w	$C7F8,$C7F8,$C7F8,$C7F8,$0000,$0000,$0000,$0000
		dc.w	$0B90,$01C0,$0010,$0FE0,$05E0,$0410,$05F0,$0608
		dc.w	$BC00,$8200,$BE00,$C100,$02FC,$03FC,$03FC,$03FC
		dc.w	$7FFC,$7F7C,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0100,$0000,$00FF,$01FF
		dc.w	$0240,$0300,$FC80,$FFC0,$00BC,$0082,$00BE,$00C1
		dc.w	$1780,$1040,$17C0,$1820,$025E,$0041,$005F,$0260
		dc.w	$0BC2,$0820,$0BE2,$8C10,$003F,$003F,$003F,$003F
		dc.w	$C7F8,$C7F8,$C7F8,$C7F8,$0000,$0000,$0000,$0000
		dc.w	$0B00,$0170,$00B0,$0FC0,$05E0,$0410,$05F0,$0608
		dc.w	$BC00,$8200,$BE00,$C100,$02FC,$03FC,$03FC,$03FC
		dc.w	$7FFC,$7F7C,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0103,$0002,$00FC,$01FF
		dc.w	$E140,$2280,$1C00,$FFC0,$00BC,$0082,$00BE,$00C1
		dc.w	$1780,$1040,$17C0,$1820,$015E,$0141,$005F,$0160
		dc.w	$0BC0,$0824,$0BE4,$8C10,$003F,$003F,$003F,$003F
		dc.w	$C7F8,$C7F8,$C7F8,$C7F8,$0000,$0000,$0000,$0000
		dc.w	$0A40,$0060,$0180,$0FF0,$05E0,$0410,$05F0,$0608
		dc.w	$BC00,$8200,$BE00,$C100,$02FC,$03FC,$03FC,$03FC
		dc.w	$7F7C,$7F7C,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0102,$00FC,$01FE
		dc.w	$0280,$2440,$9800,$3FC0,$00BC,$0082,$00BE,$00C1
		dc.w	$1FA0,$B840,$7FC0,$F020,$00DE,$0041,$00DF,$00E0
		dc.w	$0FD8,$5C28,$3FE8,$F810,$003F,$003F,$003F,$003F
		dc.w	$C7F8,$C7F8,$C7F8,$C7F8,$0000,$0000,$0000,$0000
		dc.w	$0120,$0A00,$01E0,$0FF0,$05E0,$0415,$05F3,$060F
		dc.w	$FD00,$C200,$FE00,$8100,$02FC,$03FC,$03FC,$03FC
		dc.w	$7FFC,$7FFC,$7F7C,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$018C,$018C,$0270,$01FE
		dc.w	$33A0,$1460,$0830,$3FC0,$03BC,$0283,$01BF,$03C0
		dc.w	$37B0,$F868,$FFC8,$0030,$1FDE,$1541,$0CDF,$03E0
		dc.w	$1BDA,$FC34,$FFE7,$0018,$A07F,$C0FF,$00BF,$007F
		dc.w	$C79C,$C7FE,$C7FA,$C7FC,$0000,$0000,$0000,$0000
		dc.w	$1660,$1C00,$0DE0,$03F0,$1DE1,$041F,$0DFF,$1E00
		dc.w	$BD80,$C340,$FE40,$0180,$06FC,$0FFC,$0BFC,$07FC
		dc.w	$7FFC,$7FFC,$7F7C,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$11FC,$19FC,$0F00,$00FE
		dc.w	$1754,$17EC,$0A08,$3FF0,$033C,$0743,$0B7E,$0780
		dc.w	$07BE,$F87A,$0FF8,$001C,$019E,$03A1,$05BF,$03C0
		dc.w	$03DF,$FC3D,$07FC,$000E,$00FA,$01F8,$02FC,$01FF
		dc.w	$C5CE,$C6DF,$073E,$C7FF,$0000,$0000,$8000,$0000
		dc.w	$D0E0,$F580,$6C60,$03F0,$19E0,$3A1F,$1BF0,$3C00
		dc.w	$3DF0,$C3D0,$7FC0,$00E0,$0EFC,$1FFC,$2FFC,$1FFC
		dc.w	$77FC,$7FFC,$7F7C,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0EFC,$1FFC,$1380,$0C7E
		dc.w	$39F0,$18FC,$0704,$3FF8,$0EFD,$0483,$04FE,$0F00
		dc.w	$17C0,$1822,$0FE6,$001C,$077E,$0241,$027F,$0780
		dc.w	$8BE0,$8C11,$07F3,$000E,$03FE,$03F0,$01FB,$03FC
		dc.w	$06DF,$C60F,$C0DF,$073F,$8000,$8000,$0000,$8000
		dc.w	$DEA0,$C140,$9F60,$60F0,$77E8,$2418,$27F0,$7800
		dc.w	$BE00,$C110,$7F30,$00E0,$3E7C,$3FFC,$1FFC,$3FFC
		dc.w	$7FFC,$7FFC,$7F7C,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0FD0,$1F4C,$21C0,$1E3E
		dc.w	$1A06,$3FFA,$2000,$1FFC,$1FFC,$0A02,$1BFF,$0C00
		dc.w	$07F5,$180D,$1FFC,$0002,$0FFE,$0501,$0DFF,$0600
		dc.w	$03FA,$0C06,$8FFE,$0001,$83E2,$87FF,$07F4,$03F8
		dc.w	$C00F,$C6EF,$073F,$001F,$8000,$C000,$C001,$8000
		dc.w	$92E0,$BCC0,$3DA0,$C370,$FFE0,$5010,$DFF8,$6000
		dc.w	$3FA8,$C068,$FFE0,$0010,$3E7C,$7FFC,$7FFC,$3FFC
		dc.w	$777C,$7F7C,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$007A,$3E86,$2082,$1F7C
		dc.w	$01E6,$1E18,$2002,$1FFC,$0BFD,$1802,$0BFF,$1C00
		dc.w	$17F9,$0804,$0FFD,$1002,$05FE,$0C01,$05FF,$0E00
		dc.w	$8BFC,$0402,$87FE,$0801,$83F0,$07E3,$83F4,$07F8
		dc.w	$061F,$C7FF,$002F,$001F,$8001,$C001,$8001,$C000
		dc.w	$4B60,$DAA0,$4980,$B7F0,$5FE8,$C010,$5FF8,$E000
		dc.w	$BFC8,$4020,$7FE8,$8010,$3E7C,$7FFC,$3FFC,$7FFC
		dc.w	$7F7C,$7F7C,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1C6E,$02D2,$00C2,$3F3C
		dc.w	$2DE2,$321E,$1002,$0FFC,$1FFC,$1403,$17FF,$1800
		dc.w	$0FF8,$0806,$1FFE,$1001,$0FFE,$0A01,$0BFF,$0C00
		dc.w	$07FC,$8403,$8FFF,$0800,$07C8,$07F7,$07E8,$87F0
		dc.w	$000F,$C7DF,$002F,$001F,$C000,$C001,$C000,$C001
		dc.w	$17E0,$7820,$4BC0,$B7F0,$FFE0,$A018,$BFF8,$C000
		dc.w	$7FC0,$4030,$FFF0,$8008,$7E7C,$7FFC,$7FFC,$7FFC
		dc.w	$777C,$7F7C,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$3DDE,$22C2,$20C2,$1F3C
		dc.w	$0DFE,$2A02,$1802,$07FC,$17FD,$1003,$17FF,$1800
		dc.w	$17FC,$1002,$17FE,$1801,$0BFE,$0801,$0BFF,$0C00
		dc.w	$8BFE,$8801,$8BFF,$0C00,$05C0,$07C7,$03E8,$87F0
		dc.w	$003F,$C7FF,$001F,$000F,$C001,$C000,$C000,$C001
		dc.w	$C4A0,$FC80,$CB60,$37F0,$BFE8,$8018,$BFF8,$C000
		dc.w	$BFE0,$8010,$BFF0,$C008,$7E7C,$7FFC,$7FFC,$7FFC
		dc.w	$77FC,$7F7C,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$3F7E,$2062,$2062,$1F9C
		dc.w	$03FE,$0802,$3802,$07FC,$17FC,$1002,$17FE,$1801
		dc.w	$17FC,$1002,$17FE,$1801,$0BFE,$0801,$0BFF,$0C00
		dc.w	$0BFE,$0801,$0BFF,$8C00,$02F0,$078F,$05D0,$83E0
		dc.w	$0027,$C7F7,$001F,$000F,$C001,$C000,$C000,$C001
		dc.w	$1AE0,$2F80,$0860,$F7F0,$BFE0,$8010,$BFF0,$C008
		dc.w	$BFE0,$8010,$BFF0,$C008,$7E7C,$7FFC,$7FFC,$7FFC
		dc.w	$77FC,$7FFC,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$3FCE,$2062,$2062,$1F9C
		dc.w	$2F8E,$1402,$3C02,$03FC,$17FC,$1002,$17FE,$1801
		dc.w	$17FC,$1002,$17FE,$1801,$0BFE,$0801,$0BFF,$0C00
		dc.w	$0BFE,$0801,$0BFF,$8C00,$0690,$07FF,$0220,$81C0
		dc.w	$001D,$C7E3,$0017,$000F,$C001,$C000,$C000,$C001
		dc.w	$C8A0,$DF80,$D860,$27F0,$BFE0,$8010,$BFF0,$C008
		dc.w	$BFE0,$8010,$BFF0,$C008,$7E7C,$7FFC,$7FFC,$7FFC
		dc.w	$7FFC,$7F7C,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$3D10,$2032,$2032,$1FCC
		dc.w	$3900,$1C02,$3C02,$03FC,$17FC,$1002,$17FE,$1801
		dc.w	$17FC,$1002,$17FE,$1801,$0BFE,$0801,$0BFF,$0C00
		dc.w	$0BFE,$0801,$0BFF,$8C00,$0360,$06BF,$01C0,$8000
		dc.w	$000F,$C7EF,$0019,$0007,$C001,$C000,$C000,$C001
		dc.w	$FC40,$D3C0,$D820,$27F0,$BFE0,$8010,$BFF0,$C008
		dc.w	$BFE0,$8010,$BFF0,$C008,$7E7C,$7FFC,$7FFC,$7FFC
		dc.w	$7FFC,$7F7C,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0030,$2032,$2032,$1FCC
		dc.w	$0200,$2602,$2602,$19FC,$17FC,$1002,$17FE,$1801
		dc.w	$17FC,$1002,$17FE,$1801,$0BFE,$0801,$0BFF,$0C00
		dc.w	$0BFE,$0801,$0BFF,$8C00,$0000,$07FF,$0000,$8000
		dc.w	$0003,$C7FB,$0007,$0001,$C001,$C000,$C000,$C001
		dc.w	$8BC0,$B580,$8FA0,$7070,$BFE0,$8010,$BFF0,$C008
		dc.w	$BFE0,$8010,$BFF0,$C008,$7E7C,$7FFC,$7FFC,$7FFC
		dc.w	$7FFC,$7FFC,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$3FF8,$1FFA,$3FFA,$0004
		dc.w	$1DF8,$3FFA,$3FFA,$0004,$17FC,$1002,$17FE,$1801
		dc.w	$17FC,$1002,$17FE,$1801,$0BFE,$0801,$0BFF,$0C00
		dc.w	$0BFE,$0801,$0BFF,$8C00,$0001,$07FE,$0001,$8000
		dc.w	$0004,$87FE,$C003,$0001,$C001,$C000,$C000,$C001
		dc.w	$0B40,$3F60,$0F40,$F0B0,$BFE0,$8010,$BFF0,$C008
		dc.w	$BFE0,$8010,$BFF0,$C008,$7E7C,$7FFC,$7FFC,$7FFC
		dc.w	$7FFC,$7FFC,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$237E,$1FFC,$3FFE,$0000
		dc.w	$131E,$3FFC,$3FFE,$0000,$17FC,$1002,$17FE,$1801
		dc.w	$17FC,$1002,$17FE,$1801,$0BFE,$0801,$0BFF,$0C00
		dc.w	$0BFE,$0801,$0BFF,$8C00,$0001,$07FC,$0002,$8001
		dc.w	$0007,$47FC,$8002,$C001,$8001,$4000,$8000,$C001
		dc.w	$0520,$3360,$0700,$F8F0,$BFE0,$8010,$BFF0,$C008
		dc.w	$BFE0,$8010,$BFF0,$C008,$783C,$7FFC,$7FFC,$7FFC
		dc.w	$7FFC,$7FFC,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$2602,$1FFC,$3FFE,$0000
		dc.w	$2606,$1FFC,$3FFE,$0000,$17FC,$1002,$17FE,$1801
		dc.w	$17FC,$1002,$17FE,$1801,$0BFE,$0801,$0BFF,$0C00
		dc.w	$0BFE,$0801,$0BFF,$8C00,$02C1,$067F,$0182,$8001
		dc.w	$C300,$C67D,$C183,$C000,$0001,$0000,$4000,$8001
		dc.w	$0CC0,$2A40,$0E20,$F1F0,$BFE0,$8010,$BFF0,$C008
		dc.w	$BFE0,$8010,$BFF0,$C008,$7C3C,$7FFC,$7FFC,$7FFC
		dc.w	$7FFC,$7FFC,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$2F42,$1FBC,$3FFE,$0000
		dc.w	$2E62,$1F9C,$3FFE,$0000,$17FC,$1002,$17FE,$1801
		dc.w	$17FC,$1002,$17FE,$1801,$0BFE,$0801,$0BFF,$0C00
		dc.w	$0BFE,$0801,$0BFF,$8C00,$0581,$007C,$0441,$8383
		dc.w	$C280,$C6FF,$C080,$C100,$0001,$C000,$0000,$0001
		dc.w	$3740,$1AC0,$1E20,$E1F0,$BFE0,$8010,$BFF0,$C008
		dc.w	$BFE0,$8010,$BFF0,$C008,$7C1C,$7FFC,$7FFC,$7FFC
		dc.w	$7FFC,$7FFC,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$3F62,$1F9C,$3FFE,$0000
		dc.w	$2C62,$1F9C,$3FFE,$0000,$17FC,$1002,$17FE,$1801
		dc.w	$17FC,$1002,$17FE,$1801,$0BFE,$0801,$0BFF,$0C00
		dc.w	$0BFE,$0801,$0BFF,$8C00,$03E0,$041F,$03A1,$87C3
		dc.w	$C240,$C53F,$C2C0,$C180,$0001,$C000,$0000,$0001
		dc.w	$A6C0,$FB40,$FE20,$01F0,$BFE0,$8010,$BFF0,$C008
		dc.w	$BFE0,$8010,$BFF0,$C008,$781C,$7FFC,$7FFC,$7FFC
		dc.w	$7FFC,$7FFC,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$20FC,$1F00,$3FFE,$0000
		dc.w	$20FC,$1F00,$3FFE,$0000,$17FC,$1002,$17FE,$1801
		dc.w	$17FC,$1002,$17FE,$1801,$0BFE,$0801,$0BFF,$0C00
		dc.w	$0BFE,$0801,$0BFF,$8C00,$0742,$07FF,$07A1,$87C3
		dc.w	$C14F,$C1DF,$C4E0,$C380,$0001,$C000,$0000,$0001
		dc.w	$B6C0,$F240,$F620,$09F0,$BFE0,$8010,$BFF0,$C008
		dc.w	$BFE0,$8010,$BFF0,$C008,$781C,$7FFC,$7FFC,$7FFC
		dc.w	$7FFC,$7FFC,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00FC,$1F00,$3FFE,$0000
		dc.w	$20FC,$1F00,$3FFE,$0000,$17FC,$1002,$17FE,$1801
		dc.w	$17FC,$1002,$17FE,$1801,$0BFE,$0801,$0BFF,$0C00
		dc.w	$0BFE,$0801,$0BFF,$8C00,$0782,$07BF,$07E1,$87C3
		dc.w	$C2FC,$C5E0,$C3FF,$C7C0,$C001,$0000,$C000,$0001
		dc.w	$AF20,$E280,$E660,$19F0,$BFE0,$8010,$BFF0,$C008
		dc.w	$BFE0,$8010,$BFF0,$C008,$780C,$7FFC,$7FFC,$7FFC
		dc.w	$7FFC,$7FFC,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1DFC,$0200,$3FFE,$0000
		dc.w	$19FC,$0600,$3FFE,$0000,$17FC,$1002,$17FE,$1801
		dc.w	$17FC,$1002,$17FE,$1801,$0BFE,$0801,$0BFF,$0C00
		dc.w	$0BFE,$0801,$0BFF,$8C00,$07C0,$07FB,$07A5,$87C3
		dc.w	$C7FD,$C7FD,$C7F1,$C7EE,$C001,$0000,$0000,$C001
		dc.w	$F8E0,$CE80,$CE60,$31F0,$BFE0,$8010,$BFF0,$C008
		dc.w	$BFE0,$8010,$BFF0,$C008,$7A0C,$7FFC,$7FFC,$7FFC
		dc.w	$7F7C,$7FFC,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$267C,$2000,$1FFE,$0000
		dc.w	$1EFC,$0000,$3FFE,$0000,$17FC,$1002,$17FE,$1801
		dc.w	$17FC,$1002,$17FE,$1801,$0BFE,$0801,$0BFF,$0C00
		dc.w	$0BFE,$0801,$0BFF,$8C00,$0703,$07DF,$07A5,$87C3
		dc.w	$C7FD,$C7EC,$C7EC,$C7FF,$4001,$4000,$C000,$C001
		dc.w	$A2E0,$8C80,$8E60,$71F0,$BFE0,$8010,$BFF0,$C008
		dc.w	$BFE0,$8010,$BFF0,$C008,$780C,$7FFC,$7FFC,$7FFC
		dc.w	$7F7C,$7FFC,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$2432,$2002,$1FFC,$0000
		dc.w	$04B2,$0002,$3FFC,$0000,$17FC,$1002,$17FE,$1801
		dc.w	$17FC,$1002,$17FE,$1801,$0BFE,$0801,$0BFF,$0C00
		dc.w	$0BFE,$0801,$0BFF,$8C00,$0783,$07B9,$07E3,$87C7
		dc.w	$C7F1,$C7EB,$C7F0,$C7FF,$C001,$C000,$C000,$C001
		dc.w	$17A0,$3D80,$1F60,$E0F0,$BFE0,$8010,$BFF0,$C008
		dc.w	$BFE0,$8010,$BFF0,$C008,$780C,$7FFC,$7FFC,$7FFC
		dc.w	$7F3C,$7FFC,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$2102,$2102,$1EFC,$0000
		dc.w	$0182,$0102,$3EFC,$0000,$17FC,$1002,$17FE,$1801
		dc.w	$17FC,$1002,$17FE,$1801,$0BFE,$0801,$0BFF,$0C00
		dc.w	$0BFE,$0801,$0BFF,$8C00,$07C1,$07BF,$07C3,$87E7
		dc.w	$C7F9,$C7F1,$C7FF,$C7FF,$C001,$C000,$C000,$C001
		dc.w	$49E0,$0F80,$2360,$FCF0,$BFE0,$8010,$BFF0,$C008
		dc.w	$BFE0,$8010,$BFF0,$C008,$700C,$7FFC,$7FFC,$7FFC
		dc.w	$7F3C,$7FFC,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$27FE,$27FE,$1800,$0000
		dc.w	$277E,$277E,$1880,$0000,$17FC,$1002,$17FE,$1801
		dc.w	$17FC,$1002,$17FE,$1801,$0BFE,$0801,$0BFF,$0C00
		dc.w	$0BFE,$0801,$0BFF,$8C00,$07B7,$07CF,$07F3,$87E7
		dc.w	$C7FF,$C7FF,$C7FF,$C7FF,$C001,$C000,$C000,$C001
		dc.w	$3F60,$4D00,$2DE0,$FEF0,$BFE0,$8010,$BFF0,$C008
		dc.w	$BFE0,$8010,$BFF0,$C008,$7E1C,$7FFC,$7FFC,$7FFC
		dc.w	$7F3C,$7FFC,$7FFC,$7FFC,$0000,$0000,$0000,$0000
		dc.w	$1044,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$2FFE,$2FFE,$1000,$0000
		dc.w	$2F7E,$2F7E,$1080,$0000,$17FC,$1002,$17FE,$1801
		dc.w	$17FC,$1002,$17FE,$1801,$0BFE,$0801,$0BFF,$0C00
		dc.w	$0BFE,$0801,$0BFF,$8C00,$07EB,$07F3,$07EF,$87E7
		dc.w	$C7FF,$C7FF,$C7FF,$C7FF,$C001,$C000,$C000,$C001
		dc.w	$F580,$5BC0,$2360,$FCF0,$BFE0,$8010,$BFF0,$C008
		dc.w	$BFE0,$8010,$BFF0,$C008,$7E7C,$7FFC,$7FFC,$7FFC
		dc.w	$7E1C,$7FFC,$7FFC,$7FFC,$0448,$0000,$0000,$0000
		dc.w	$4882,$1044,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$33FC,$3FFE,$0000,$0000
		dc.w	$337C,$3F7E,$0080,$0000,$17FD,$1003,$17FF,$1800
		dc.w	$17FD,$1003,$17FF,$1800,$0BFE,$0801,$0BFF,$0C00
		dc.w	$8BFE,$8801,$8BFF,$0C00,$87E7,$87FF,$87F7,$07E7
		dc.w	$C7FF,$C7FF,$C7FF,$C7FF,$C001,$C000,$C000,$C001
		dc.w	$86A0,$4BA0,$3240,$FDF0,$BFE8,$8018,$BFF8,$C000
		dc.w	$BFE8,$8018,$BFF8,$C000,$7FFC,$7FFC,$7FFC,$7FFC
		dc.w	$7E0C,$7FFC,$7FFC,$7FFC,$111C,$0440,$0000,$0000
		dc.w	$9145,$58C6,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$03B8,$3FFE,$0000,$0000
		dc.w	$0338,$3F7E,$0080,$0000,$17FC,$1003,$17FF,$1800
		dc.w	$17FC,$1003,$17FF,$1800,$0BFE,$0801,$0BFF,$0C00
		dc.w	$0BFE,$8801,$8BFF,$0C00,$07EF,$87FF,$87EF,$07E7
		dc.w	$C7FF,$C7FF,$C7FF,$C7FF,$C001,$C000,$C000,$C001
		dc.w	$4580,$0220,$3FC0,$FFF0,$BFE0,$8018,$BFF8,$C000
		dc.w	$BFE0,$8018,$BFF8,$C000,$7FFE,$7FFE,$7FFF,$7FFC
		dc.w	$BE18,$BFFC,$FFF8,$7FFC,$04C8,$155D,$0000,$0000
		dc.w	$4C82,$C983,$1044,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$3810,$07FE,$0000,$0000
		dc.w	$3890,$073E,$00C0,$0000,$17FD,$1002,$17FF,$1800
		dc.w	$17FD,$1002,$17FF,$1800,$0BFE,$0801,$0BFF,$0C00
		dc.w	$8BFE,$0801,$8BFF,$0C00,$87F7,$07F7,$87F7,$07EF
		dc.w	$C7FF,$C7FF,$C7FF,$C7FF,$C001,$C000,$C000,$C001
		dc.w	$4B50,$07C0,$3F90,$FFE0,$BFE8,$8010,$BFF8,$C000
		dc.w	$BFE8,$8010,$BFF8,$C000,$7FFF,$7FFF,$7FFD,$7FFE
		dc.w	$7E18,$BFFC,$7FFC,$FFF8,$010D,$0008,$015D,$1480
		dc.w	$D080,$9482,$CCC6,$0101,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$387E,$0780,$0000,$0000
		dc.w	$38BE,$0720,$00C0,$0000,$17FC,$1002,$17FF,$1800
		dc.w	$17FC,$1002,$17FF,$1800,$0BFE,$0801,$0BFF,$0C00
		dc.w	$0BFE,$0801,$8BFF,$0C00,$07F7,$07FF,$87FF,$07E7
		dc.w	$C7FF,$C7FF,$C7FF,$C7FF,$C001,$C000,$C000,$C001
		dc.w	$3650,$4F30,$3FA0,$FFC0,$BFE0,$8010,$BFF8,$C000
		dc.w	$BFE0,$8010,$BFF8,$C000,$7FFE,$7FFC,$7FFF,$7FFF
		dc.w	$BE30,$7FD8,$FFF0,$FFF8,$0010,$1410,$1C10,$0000
		dc.w	$9000,$8101,$9145,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$34FE,$0B00,$0000,$0000
		dc.w	$343E,$0AA0,$01C0,$0000,$1D01,$1601,$17FE,$1800
		dc.w	$1D01,$1601,$17FE,$1800,$0E80,$0B00,$0BFF,$0C00
		dc.w	$8E80,$8B00,$0BFF,$0C00,$87A3,$87C3,$07E7,$07FF
		dc.w	$C7FF,$C7FF,$C7FF,$C7FF,$C001,$C000,$C000,$C001
		dc.w	$2E80,$2950,$1660,$FF80,$E808,$B008,$BFF0,$C000
		dc.w	$E808,$B008,$BFF0,$C000,$7FFC,$7FFF,$7FFF,$7FFF
		dc.w	$7FF0,$FFF0,$FFE8,$FFF0,$0508,$10C0,$15CC,$0000
		dc.w	$0087,$9055,$9987,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$3FFE,$0000,$0000,$0000
		dc.w	$3C7E,$05D0,$0360,$0080,$1500,$13FF,$1A00,$1C00
		dc.w	$1500,$13FF,$1A00,$1C00,$0A80,$09FF,$0D00,$0E00
		dc.w	$0A80,$89FF,$0D00,$0E00,$07BF,$87AF,$07CF,$07F3
		dc.w	$C7FF,$C7FF,$C7FF,$C7FF,$C001,$C001,$C001,$C000
		dc.w	$8C40,$2E60,$E580,$1E00,$A800,$9FF8,$D000,$E000
		dc.w	$A800,$9FF8,$D000,$E000,$7FFE,$7FF9,$7FFF,$7FFF
		dc.w	$FF80,$3FE0,$FFA0,$FFC0,$15DC,$15DC,$1000,$0000
		dc.w	$9854,$9854,$1D01,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00F0,$02E0,$01C0,$0080,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0078,$0018,$005C,$0030
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0C00,$1200,$1200,$0C00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0005,$0007,$0005,$0003
		dc.w	$0000,$C000,$4000,$8000,$0108,$15D4,$0000,$0000
		dc.w	$8540,$9955,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0100,$0040,$0080,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0050,$0064,$0028,$0010
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0E00,$0C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0002,$0001
		dc.w	$8000,$0000,$8000,$0000,$04D4,$0100,$0000,$0000
		dc.w	$1815,$8140,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0028,$0028,$0010,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0104,$0000,$0000,$0000
		dc.w	$8141,$0000,$0000,$0000,$0000,$0000,$0000,$0000
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

MUSIC: * not compress please !
	incbin	*.snd
	even

******************************************************************

	SECTION	BSS

bss_start:

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
	END
