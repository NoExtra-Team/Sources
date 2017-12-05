* EXTRA_V1.PRG

* // Code & Ripp	 : Zorro2/NoExtra	// *
* // Optimisation	 : Atomus/NoExtra	// *
* // Gfx neochrome master: Mister.A/NoExtra	// *
* // Music 		 : Tomchi/NoExtra	// *
* // Release date 	 : 10/02/2007		// *
* // Update date 	 : 24/01/2008		// *

***********************************************
	OPT	c+	; Case sensitivity on.
	OPT	d-	; Debug off.
	OPT	o-	; All optimisations off.
	OPT	w-	; Warnings off.
	OPT	x-	; Extended debug off.
***********************************************

	SECTION	TEXT

*****************************************************
coul_pal_rast	equ	$ffff8242
coul_a1	equ	$434
coul_a2	equ	$545
coul_a3	equ	$656
coul_a4	equ	$767
coul_a5	equ	$767
coul_a6	equ	$656
coul_a7	equ	$545
coul_a8	equ	$434
SEEMYVBL	equ	1 ; 0 = see cpu & 1 = nothing
RESET	equ	0 ; 0 = reset & 1 = return to LGD
DEBUG equ 1 ;
*****************************************************
gemdos        equ	1
crawcin       equ	7
cconws        equ	9
mshrink       equ	$4a
pexec         equ	$4b
*****************************************************

Start:

	jmp	ON_Y_VA

*--------------------------------------------------------------------------
TOTO:
	DC.B	"COMPILE EXTRA VOLUME 1 BY NOEXTRA TEAM IN 2007. "
	DC.B	"MEMBERS ARE : ATOMUS - ZORRO 2 - MISTER.A AND A "
	DC.B	"NEW MEMBER : TOMCHI FOR THE MUSIC. "
	DC.B	"IF YOU SEE THIS CODE, YOU ARE A LAMER !!! OR A SIMPLE TOURISTE ?"
	EVEN
*--------------------------------------------------------------------------

Emp	DC.B 'Z:\',0
	EVEN

PROG0	DC.B 'TRSI00.PRG',0
PROG1	DC.B 'TRSI01.PRG',0
PROG2	DC.B 'TRSI02.PRG',0
PROG3	DC.B 'TRSI03.PRG',0
PROG4	DC.B 'TRSI04.PRG',0
PROG5	DC.B 'TRSI05.PRG',0
PROG6	DC.B 'TRSI06.PRG',0
PROG7	DC.B 'TRSI07.PRG',0
PROG8	DC.B 'TRSI08.PRG',0
PROG9	DC.B 'TRSI09.PRG',0
PROG10	DC.B 'TRSI_STE.PRG',0
NOMPRG	DS.L 1
	EVEN

errtext:DC.B "PROBLEMS TO LOAD...          ",13,10,10,0
params: DC.B $0    ;AUCUN PARAMŠTRE ET
environ:DC.B $0    ;AUCUN ENVIRONNEMENT
	EVEN

NOTHING_BUT_SPACE:	
	DS.L	100
	
RUN:
	bsr	Restore_st

	bsr	Loading

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
		
	tst.l      d0            ;Erreur?
	bne.s   	 error
		
Reset:	
	IFNE	RESET
	NOP
	ELSEIF
	MOVE.L	4.W,A0
	JMP	(A0)
	ENDC
	
error:

	bsr	Restore_st
	
	pea        errtext       ;Affichage du message d'erreur
	move.w     #cconws,-(sp)
	trap       #gemdos
	addq.l     #6,sp

	move.w     #crawcin,-(sp)          ;Attendre appui touche...
	trap       #gemdos
	addq.l     #2,sp
	
	bra.s			FIN

EXIT:	
	bsr	Restore_st
	
FIN:
	move.l	Save_stack,-(sp)
	move.w	#32,-(sp)
	trap	#1
	addq.l	#6,sp

	CLR.W     -(A7)
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

	IFNE	DEBUG
	MOVE.L	#Reset,$08.W	; Detournement des bombes sur le label Reset.
	MOVE.L	#Reset,$0C.W
	MOVE.L	#Reset,$10.W
	MOVE.L	#Reset,$14.W
	MOVE.L	#Reset,$18.W
	MOVE.L	#Reset,$1C.W
	MOVE.L	#Reset,$20.W
	MOVE	#$2300,sr
	ENDC

	bsr	Init0
	
******************************************************************************

	bsr	Init1
					
Main_rout:

	BSR       Wait_vbl

	IFEQ	SEEMYVBL
	clr.w	$ffff8240.w
	ENDC
	
*

	BSR	KEYPAD	; mvt de la barre 
	BSR	MVT_BARRE 

	BSR	LOGO_DIST	; logo distort 3 plans

	BSR	SCROLLING_8x8	; scrolling 8*8 1 plan

 	BSR	SCROLL		; scrolling 16*16 1 plan

	jsr 	(MUSIC+8)	; call music

*

	MOVE.L	Zorro_scr1,D0	; swapping d'ecran
	MOVE.L  Zorro_scr2,Zorro_scr1 
	MOVE.L  D0,Zorro_scr2
	LSR.W   #8,D0 
	MOVE.L  D0,$FFFF8200.W
  	
	IFEQ	SEEMYVBL
	cmp.b	#$38,$fffffc02.w	* Alt Key
	bne.s	Suite_rout
	move.b	#$7,$ffff8240.w
Suite_rout:	
	ENDC
	
On_sort_du_menu:
	cmp.b	#$1,$fffffc02.w		* Escape Key
	beq	EXIT	

Selection_du_programme:	
	cmp.b	#$39,$fffffc02.w	* Space Key
	bne.s	Main_rout

******************************************************************************

KEYBOARD:
	move.w	#$123,$40.w	; info pour l'intro ???

	cmpi.w	#0,POSITION_BARRE
	beq.s	Run0
	cmpi.w	#1,POSITION_BARRE
	beq.s	Run1
	cmpi.w	#2,POSITION_BARRE
	beq.s	Run2
	cmpi.w	#3,POSITION_BARRE
	beq.s	Run3
	cmpi.w	#4,POSITION_BARRE
	beq	Run4
	cmpi.w	#5,POSITION_BARRE
	beq	Run5
	cmpi.w	#6,POSITION_BARRE
	beq	Run6
	cmpi.w	#7,POSITION_BARRE
	beq	Run7
	cmpi.w	#8,POSITION_BARRE
	beq	Run8
	cmpi.w	#9,POSITION_BARRE
	beq	Run9
	cmpi.w	#10,POSITION_BARRE
	beq	Run10

Run0:
	move.l	#PROG0,NOMPRG
	bra	RUN
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
	;move.l	#PROG9,NOMPRG
	;bra	RUN
	beq	EXIT
Run10:
	move.l	#PROG10,NOMPRG
	bra	RUN

*--------------------------------------------------------------------------
YOPLA:
	DC.B	"IF YOU USE SOME INTROS FOR WEBSITES LIKE PUUETE OUTSIDE THIS VOLUME 1 "
	DC.B	"COMPILATION, YOU ARE A BIG BASTARD AND A LAMER WHO SUCKS !!! "
	EVEN
*--------------------------------------------------------------------------
	
************************************************
*                                              *
*               Sub Routines                   *
*                                              *
************************************************

Vbl0:	movem.l	d0-d7/a0-a6,-(a7)
  	
  	CLR.B     $FFFFFA1B.W 
  	;MOVE.L    #HBL,$120.W 
  	MOVE.B    #$63,$FFFFFA1F.W
  	MOVE.B    #4,$FFFFFA19.W
  	MOVE.B    #8,$FFFFFA21.W
  	MOVE.B    #8,$FFFFFA1B.W
  	
	st	Vsync

	jsr 	(MUSIC+8)			; call music
	
	movem.l	(a7)+,d0-d7/a0-a6
	rte
	
Vbl:
  	CLR.B     $FFFFFA1B.W 
  	MOVE.L    #HBL,$120.W 
  	MOVE.B    #$63,$FFFFFA1F.W
  	MOVE.B    #4,$FFFFFA19.W
  	MOVE.B    #8,$FFFFFA21.W
  	MOVE.B    #8,$FFFFFA1B.W

	st	Vsync

	rte

Wait_vbl:	
	move.l	a0,-(a7)
	lea	Vsync,a0
	sf	(a0)
.wait:	tst.b	(a0)
	beq.s	.wait
	move.l	(a7)+,a0
	rts

***************************************************************
*                                                             *
*             < Here is the lower border rout >               *
*                                                             *
***************************************************************

TIMER_A:MOVE      #$2100,SR 
      STOP      #$2100
      MOVE      #$2700,SR 
      CLR.B     $FFFFFA19.W 
      MOVEM.L   A0-A1/D0-D7,-(A7) 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      MOVE.B    #0,$FFFF820A.W
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      CLR.W     D1
      MOVEA.W   #$8209,A0 
      MOVE.B    #2,$FFFF820A.W
      MOVEM.L   (A7)+,A0-A1/D0-D7 
RTE:  RTE 

HBL:  CLR.B     $FFFFFA1B.W * 99
      MOVE.L    #HBL1,$120.W 
      MOVE.B    HBL_POS_1,$FFFFFA21.W * 79
      MOVE.B    #8,$FFFFFA1B.W
      RTE 
      
HBL1: CLR.B     $FFFFFA1B.W * 178
      MOVE.B    #02,$ffff8240.w
      MOVE.L    #HBL2,$120.W 
      MOVE.B    #10,$FFFFFA21.W 
      MOVE.B    #8,$FFFFFA1B.W
      RTE 
      
HBL2: CLR.B     $FFFFFA1B.W * 188
      MOVE.B    #0,$ffff8240.w
      MOVE.L    #HBLA1,$120.W 
      MOVE.B    HBL_POS_2,$FFFFFA21.W * 119
      MOVE.B    #8,$FFFFFA1B.W     
      RTE 

HBLA1:CLR.B     $FFFFFA1B.W
      MOVE.W    #coul_a1,coul_pal_rast.w
      MOVE.L    #HBLA2,$120.W 
      MOVE.B    #1,$FFFFFA21.W * 120
      MOVE.B    #8,$FFFFFA1B.W  
      RTE

HBLA2:CLR.B     $FFFFFA1B.W
      MOVE.W    #coul_a2,coul_pal_rast.w
      MOVE.L    #HBLA3,$120.W 
      MOVE.B    #1,$FFFFFA21.W * 121
      MOVE.B    #8,$FFFFFA1B.W  
      RTE

HBLA3:CLR.B     $FFFFFA1B.W
      MOVE.W    #coul_a3,coul_pal_rast.w
      MOVE.L    #HBLA4,$120.W 
      MOVE.B    #1,$FFFFFA21.W * 122
      MOVE.B    #8,$FFFFFA1B.W  
      RTE

HBLA4:CLR.B     $FFFFFA1B.W
      MOVE.W    #coul_a4,coul_pal_rast.w
      MOVE.L    #HBLA5,$120.W 
      MOVE.B    #1,$FFFFFA21.W * 123
      MOVE.B    #8,$FFFFFA1B.W  
      RTE

HBLA5:CLR.B     $FFFFFA1B.W
      MOVE.W    #coul_a5,coul_pal_rast.w
      MOVE.L    #HBLA6,$120.W 
      MOVE.B    #1,$FFFFFA21.W * 124
      MOVE.B    #8,$FFFFFA1B.W  
      RTE

HBLA6:CLR.B     $FFFFFA1B.W
      MOVE.W    #coul_a6,coul_pal_rast.w
      MOVE.L    #HBLA7,$120.W 
      MOVE.B    #1,$FFFFFA21.W * 125
      MOVE.B    #8,$FFFFFA1B.W  
      RTE

HBLA7:CLR.B     $FFFFFA1B.W
      MOVE.W    #coul_a7,coul_pal_rast.w
      MOVE.L    #HBLA8,$120.W 
      MOVE.B    #1,$FFFFFA21.W * 126
      MOVE.B    #8,$FFFFFA1B.W  
      RTE

HBLA8:CLR.B     $FFFFFA1B.W
      MOVE.W    #coul_a8,coul_pal_rast.w
      MOVE.L    #HBLA9,$120.W 
      MOVE.B    #1,$FFFFFA21.W * 127
      MOVE.B    #8,$FFFFFA1B.W  
      RTE

HBLA9:CLR.B     $FFFFFA1B.W
      MOVE.B    #0,coul_pal_rast.w
      MOVE.L    #HBL3,$120.W 
      MOVE.B    #4,$FFFFFA21.W * 128
      MOVE.B    #8,$FFFFFA1B.W  
      RTE

HBL3:
	or.w	#$700,sr
	clr.b	$fffffa1b.w
	movem.l	d0/a0,-(sp)
.wait	cmp.b	#$60,$ffff8209.w
	blo.s	.wait
	dbt	d0,*
	dbt	d0,*
	lea	.nops(pc),a0
	moveq	#0,d0
	move.b	$ffff8209.w,d0
	sub.b	#$62,d0
	add.w	d0,a0
	jmp	(a0)
.nops	
	REPT	$62
	nop
	ENDR
	dbt	d0,*
	dbt	d0,*
	clr.b	$ffff820a.w	;60 hertz
	nop
	nop
	nop
	nop
	nop
	move.l	(sp)+,d0
	move.b	#2,$ffff820a.w

	lea	col_rast,a0
	rept	32
	move.w	(a0)+,$ffff8242.w
	dcb.w	124,$4e71
	endr
	move.l	(sp)+,a0

	clr.w	$ffff8242.w
		
	BCLR      #0,$FFFFFA0F.W
	      
	rte

col_rast:
	dc.w	0
	dc.w	$0740,$0740,$0750,$0740
	dc.w	$0750,$0750,$0760,$0750
	dc.w	$0760,$0760,$0770,$0760
	dc.w	$0770,$0770,$0670,$0770
	dc.w	$0670,$0670,$0570,$0670
	dc.w	$0570,$0570,$0470,$0570
	dc.w	$0470,$0470,$0370,$0470
	dc.w	$0370,$0370,$0270,$0370
	even

************************************************
*                                              *
************************************************

Save_and_init_a_st:

	MOVEQ #$13,D0			; pause keyboard
	BSR Writeikbd			; (stop from sending)
	
	MOVE #$2700,SR
		
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

	MOVE.B    #$21,$FFFFFA07.W
	MOVE.B    #$21,$FFFFFA13.W
	CLR.B     $FFFFFA09.W 
	CLR.B     $FFFFFA15.W 
	CLR.B     $FFFFFA19.W 
	CLR.B     $FFFFFA1B.W 
	MOVE.L    #RTE,$68.W
	MOVE.L    #TIMER_A,$134.W 
	MOVE.L    #HBL,$120.W 
	
	stop	#$2300

	clr.b	$484.w		; No bip,no repeat.
			
	MOVE #$2300,SR
	MOVEQ #$11,D0			; resume sending
	BSR Writeikbd
	MOVEQ #$12,D0			; kill mouse
	BSR Writeikbd
	BSR flush
		
	rts
		 
***************************************************************
*                                                             *
***************************************************************

Restore_st:

	MOVEQ #$13,D0			; pause keyboard
	BSR Writeikbd			; (stop from sending)
	
	MOVE #$2700,SR

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

* Sorry for the next lines, but sometimes there somes syncs error !!

	move.b	Video,$ffff8260.w
	
	move.w	#$25,-(a7)
	trap	#14
	addq.w	#2,a7

	MOVEQ #$11,D0			; resume
	BSR Writeikbd		
	MOVEQ #$8,D0			; restore mouse.
	BSR Writeikbd
	BSR flush

	rts

Loading:
	lea	Pal_GEM(pc),a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

	move.l	Zorro_scr1,d0
	move.b	d0,d1
	lsr.w	#8,d0
	move.b	d0,$ffff8203.w
	swap	d0
	move.b	d0,$ffff8201.w
	move.b	d1,$ffff820d.w
	
	movea.l	Zorro_scr1,a6
	move.w	#Zorro_screen1_len/4-1,d1
.fill:
	move.l	#$0,(a6)+
	dbra	d1,.fill
	
	movea.l	Zorro_scr1,a1
	lea	160*192(a1),a1
	movea.l	#Gfx_Loading,a0
	move.l	#320-1,d0
.aff0:	move.l	(a0)+,(a1)+
	dbf	d0,.aff0
	rts
	
Pal_GEM:
	dc.w  $0000,$0F00,$0FD0,$0FDC,$0FFC,$0005,$0E65,$083F
	dc.w	$00E7,$0FC7,$0E07,$01F2,$0E25,$0AD1,$0DED,$0FFF

************************************************
*            Keyboard and Mouse                *
************************************************

; Flush IKBD

flush:	BTST.B #0,$FFFFFC00.W		; any waiting?
	BEQ.S .flok			; exit if none waiting.
	MOVE.B $FFFFFC02.W,D0		; get next in queue
	BRA.S flush			; and continue
.flok:	RTS

; Write d0 to IKBD

Writeikbd:	
	BTST.B #1,$FFFFFC00.W
	BEQ.S Writeikbd			; wait for ready
	MOVE.B D0,$FFFFFC02.W		; and send...
	RTS

clear_bss:
	lea	bss_start,a0
.loop:	clr.l	(a0)+
	cmp.l	#bss_end,a0
	blt.s	.loop
	rts
	
************************************************
*                                              *
************************************************

Init1:	movem.l	d0-d7/a0-a6,-(a7)

	lea	Vbl(pc),a0
	move.l	a0,$70.w

	lea     Pal_Logo,a2
	bsr     fadeon	

	lea	Pal_Logo(pc),a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

	movem.l	(a7)+,d0-d7/a0-a6
	rts

Pal_Noir:
	dc.w	$0,$0,$0,$0,$0,$0,$0,$0
	dc.w	$0,$0,$0,$0,$0,$0,$0,$0
	EVEN

Init0:	movem.l	d0-d7/a0-a6,-(a7)

	bsr	fadein
	
	lea	Pal_Noir,a0	; Bug du fade palié ici !
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)	
	
	moveq	#1,d0		; initialise la music
	jsr	MUSIC

	movea.l	Zorro_scr1,a1
	adda.l	#160*96,a1
	movea.l	#LogIntro,a0
	move.l	#7999-5700+300,d0
.aff:	move.l	(a0)+,(a1)+
	dbf	d0,.aff

	lea	Vbl0(pc),a0
	move.l	a0,$70.w

	lea     Pal_LogIntro,a2
	bsr     fadeon	

	lea	Pal_LogIntro,a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

	bsr	delay

	BSR	INIT_LOGO_DIST	; initialise logodist

	CLR.W   POSITION_BARRE	; initialise barre de navigation
	MOVE.B  #69+10,HBL_POS_1	; debut de la barre
	MOVE.B  #119,HBL_POS_2	; fin de la barre
	MOVE.W	#0,BAR_TEMPO          ; temporisation a chaque deplacement de la barre  

	bsr     fadeoff

top	equ	1800-80
depart	equ	160*68

	movea.l	Zorro_scr1,a1
	lea	depart(a1),a1
	movea.l	#IMG_MENU,a0
	move.l	#7999-top,d0
.aff0:	move.l	(a0)+,(a1)+
	dbf	d0,.aff0

	movea.l	Zorro_scr2,a1
	lea	depart(a1),a1
	movea.l	#IMG_MENU,a0
	move.l	#7999-top,d0
.aff1:	move.l	(a0)+,(a1)+
	dbf	d0,.aff1

	lea	Pal_Noir,a0	; Bug du fade palié ici !
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)	
			
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

********* LOGO DISTORT *******************************>>>

DIST_NB_LIGNE	equ	54

LOGO_DIST:
      BSR.s     NO_INIT 
      LEA       BUFF_DIST,A1
      MOVE.W    #DIST_NB_LIGNE,D0 
.loop:MOVEA.L   (A1)+,A0
      MOVEA.L   (A1)+,A2
      MOVE.L    #0,-8(A2) 
      MOVE.L    #0,-4(A2) 
      MOVEM.L   (A0)+,A3-A6/D1-D7 
      MOVEM.L   A3-A6/D1-D7,(A2)
      MOVEM.L   (A0)+,A3-A6/D1-D7 
      MOVEM.L   A3-A6/D1-D7,44(A2)
      MOVEM.L   (A0)+,A3/D1-D7
      MOVEM.L   A3/D1-D7,88(A2) 
      MOVE.L    #0,120(A2)
      MOVE.L    #0,124(A2)
      DBF       D0,.loop
      RTS 
      
COURBE1:
      LEA       COURBE,A3
      BRA.s     COURBE1_GO 
COURBE2:
      LEA       COURBE,A3
      BRA.s     COURBE2_GO 
NO_INIT:
      LEA       BUFF_C0,A0
      LEA       BUFF_C1,A1
      LEA       BUFF_DIST,A2
      movea.l	Zorro_scr1,a6
      lea	-(160*44)(a6),a6
      move.l	a6,d3
      MOVEQ     #0,D1 
      MOVEQ     #0,D6 
      MOVEQ     #0,D7 
      MOVEq     #$4D,D0 
      MOVEA.L   PTR_COURBE,A3
COURBE1_GO:
      MOVE.L    (A3)+,D4
      BMI.s     COURBE1 
      MOVE.L    A3,PTR_COURBE
LOOP: MOVE.L    D4,D2 
      LSL.L     #2,D2 
      MOVE.L    0(A0,D2.L),(A2) 
      ADD.L     D6,(A2) 
      ADDI.L    #buffer_de_fin,(A2)+
      MOVE.L    0(A1,D2.L),(A2) 
      ADD.L     D7,(A2) 
      ADD.L     D3,(A2) 
      ADDI.L    #$1F40,(A2)+
      ADDI.L    #$A0,D7 
      ADDI.L    #$78,D6 
COURBE2_GO:
      MOVE.L    (A3)+,D4
      BMI.s     COURBE2 
      DBF       D0,LOOP
      RTS 

PRESHIFT:
      LEA       buffer_de_fin,A1
      MOVEq     #$F,D0
.loop:LEA       IMG_LOGO,A0
      MOVEq     #DIST_NB_LIGNE,D1 
.loop0:MOVEq    #$D,D6
      MOVE.W    #0,(A1) 
      MOVE.W    #0,2(A1)
      MOVE.W    #0,4(A1)
      MOVE.W    #0,6(A1)
.loop1:MOVEQ     #0,D2 
      MOVEQ     #0,D3 
      MOVEQ     #0,D4 
      MOVEQ     #0,D5 
      MOVE.W    (A0)+,D2
      MOVE.W    (A0)+,D3
      MOVE.W    (A0)+,D4
      MOVE.W    (A0)+,D5
      LSL.L     D0,D2 
      LSL.L     D0,D3 
      LSL.L     D0,D4 
      LSL.L     D0,D5 
      MOVE.W    D2,8(A1)
      MOVE.W    D3,10(A1) 
      MOVE.W    D4,12(A1) 
      MOVE.W    D5,14(A1) 
      SWAP      D2
      SWAP      D3
      SWAP      D4
      SWAP      D5
      OR.W      D2,(A1) 
      OR.W      D3,2(A1)
      OR.W      D4,4(A1)
      OR.W      D5,6(A1)
      ADDA.L    #8,A1 
      DBF       D6,.loop1
      ADDA.L    #8,A1 
      DBF       D1,.loop0
      DBF       D0,.loop
      RTS 

REMPLIR_BUF:
      LEA       BUFF_C0,A0
      LEA       BUFF_C1,A1
      MOVE.W    #$13F,D0
      MOVEQ     #0,D1 
      MOVEQ     #0,D2 
.loop:MOVE.L    D1,D2 
      MOVE.L    D2,D3 
      ANDI.L    #$F,D2
      MULU      #$19C8,D2 
      LSR.L     #4,D3 
      LSL.L     #3,D3 
      MOVE.L    D2,(A0)+
      MOVE.L    D3,(A1)+
      ADDQ.L    #1,D1 
      DBF       D0,.loop
      RTS 

INIT_LOGO_DIST:
      BSR       PRESHIFT 
      BSR.S     REMPLIR_BUF 
      RTS
	
********* LOGO DISTORT *******************************<<<

********* BAR MENU ***********************************>>>

KEYPAD:CMPI.B    #$48,$FFFFFC02.W	; CURSEUR HAUT
      BNE.s     .suite 
      CMPI.W    #0,POSITION_BARRE
      BEQ.s     .suite 
      MOVE.W    #1,SENS_BARRE
.suite:CMPI.B   #$50,$FFFFFC02.W	; CURSEUR BAS
      BNE.s     .fin 
      CMPI.W    #10,POSITION_BARRE
      BEQ.s     .fin 
      MOVE.W    #2,SENS_BARRE
.fin: RTS 

MVT_BARRE:
      CMPI.W    #1,SENS_BARRE
      BNE.s     .bas 
.haut:
      SUBQ.B    #1,HBL_POS_1
      ADDQ.B    #1,HBL_POS_2
      ADD.W	#1,BAR_TEMPO

      CMPI.W    #10-1,BAR_TEMPO
      BlE.S	.fin

      CLR.W     SENS_BARRE 
      MOVE.W	#0,BAR_TEMPO
      SUBI.W    #1,POSITION_BARRE    

.bas: CMPI.W    #2,SENS_BARRE
      BNE.s    .fin 
      
      ADDQ.B    #1,HBL_POS_1
      SUBQ.B    #1,HBL_POS_2
      ADD.W	#1,BAR_TEMPO

      CMPI.W    #10-1,BAR_TEMPO
      BlE.S	.fin

      CLR.W     SENS_BARRE 
      MOVE.W	#0,BAR_TEMPO
      ADDI.W    #1,POSITION_BARRE
     
.fin:RTS 

********* BAR MENU ***********************************<<<

********* PETIT SCROLLING ***********************************>>>

SCROLL_8x8:
	lea	fin_BUF,a0
	moveq	#7,d0
.loop:	move	#0,ccr
	rept	21
	roxl	-(a0)
	endr
	lea	84(a0),a0
	dbf	d0,.loop
	rts

SCROLLING_8x8:	
	bsr.s	SCROLL_8x8		
	bsr.s	SCROLL_8x8
	addi.w	#1,COMPTEUR
	cmpi.w	#4,COMPTEUR
	bne.s	.next
	move.w	#0,COMPTEUR
	movea.l	DEBUT_TEXTE,a0
	moveq	#0,d0
	move.b	(a0)+,d0
	tst.b	d0
	bpl.s	.next0
	lea	TEXTE,a0
	move.b	(a0)+,d0
.next0:	move.l	a0,DEBUT_TEXTE
	lea	FONT8_8,a0
	adda	d0,a0
	lea	milieu_BUF,a1
	move.b	(a0),(a1)
	move.b	256(a0),42(a1)
	move.b	512(a0),84(a1)
	move.b	768(a0),126(a1)
	move.b	1024(a0),168(a1)
	move.b	1280(a0),210(a1)
	move.b	1536(a0),252(a1)
	move.b	1792(a0),294(a1)
.next:	lea	deb_BUF,a0
	movea.l	Zorro_scr1,a1
	lea	160*200(a1),a1
	lea	160*16(a1),a1
	add.w	#4*8,a1
	moveq	#1,d1
	moveq	#7,d0
.loop:	move	(a0)+,(a1)
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
	move	(a0)+,96(a2)
	move	(a0)+,104(a2)
	move	(a0)+,112(a2)
	move	(a0)+,120(a2)
	move	(a0)+,128(a2)
	move	(a0)+,136(a2)
	move	(a0)+,144(a2)
	move	(a0)+,152(a2)
	lea	160(a1),a1
	addq	#2,a0
	dbf	d0,.loop
	rts

********* PETIT SCROLLING ***********************************<<<

********* GRAND SCROLLING ***********************************>>>

DEPTH	equ	32

SCROLL:
	move.l	Zorro_scr1,a1
	lea	160*200(a1),a1
	lea	160*30(a1),a1
	lea	font_offsets,a2		;font lookup table
	lea	font,a3			;font itself
	move.l	scroll_pointer,a4	;pointer into text
	move.l	a4,a5

	moveq	#40,d5			;40 words across screen
	move.w	char_offset,d6		;char offset is a toggle
					;for bytes/words
	moveq	#0,d4
next_char
	move.b	(a5),d7		;get a letter
	sub.b	#32,d7		;rid of ASCII
	ext.w	d7

	moveq	#0,d0
	move.l	a3,a0
	move.b	(a2,d7),d0	;find correct offset
	lsl.w	#7,d0
	add.w	d0,a0		;add to font start
	move.w	d6,d0		;char offset
	lsl.w	#5,d0
	add.w	d0,a0		;we now point to character in A0

** this bit prints 1 byte wide blocks of the font, this method makes
** it possible to redraw the scroller every screen refresh and makes
** it so the we do not have to shift the scroller. The bad part is that
** it scrolls bloody fast at 8 bits every screen refresh.

.column
OFF	set	0
	REPT	DEPTH
	move.b	(a0)+,OFF(a1)
OFF	set	OFF+160		;go down a line
	ENDR

	subq.w	#1,d5		;column value
	beq.s	.finish		;last column then finish

	addq.w	#1,a1		;lower byte of word
	tst.w	d4
	beq.s	.skip		;if D4=0 then do next byte
	addq.w	#6,a1		;else goto next word on screen
.skip	not.w	d4
	addq.w	#1,d6		;character offset
	and.w	#3,d6
	bne	.column

	addq.w	#1,a5		;scroll pointer
	tst.b	(a5)		;is end of text?
	bpl	next_char	;NO!
	lea	scroll_text,a5	;do reset scrolline
	bra	next_char

.finish
	addq.w	#1,char_offset
	and.w	#3,char_offset
	bne.s	.end
	addq.w	#1,a4
	tst.b	(a4)		;is scroll text end?
	bpl.s	.end		;NO!
	lea	scroll_text,a4	;reset scroll text
.end	move.l	a4,scroll_pointer
	rts

********* GRAND SCROLLING ***********************************<<<
	
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
	rept	6-2
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

	SECTION	DATA

Pal_Logo:	
	dc.w	$0000,$0800,$0100,$0988,$0211,$0A99,$0A29,$03A2
	dc.w	$0B3A,$04B3,$0C4B,$05C4,$0554,$0DDC,$0665,$0EED

********* PETIT SCROLLING ***********************************>>>

FONT8_8:
	dc.w	$0018,$0008,$103E,$7F77
	dc.w	$007E,$1808,$7CF0,$05A0
	dc.w	$3E03,$3E3E,$633E,$3E3E
	dc.w	$3E3E,$007C,$07F0,$1104
	dc.w	$0038,$EE6C,$10C2,$3838
	dc.w	$1E78,$C638,$0000,$0002
	dc.w	$7C38,$FCFC,$E0FE,$7EFC
	dc.w	$7C7C,$0000,$0E00,$70FC
	dc.w	$7C7C,$FC7C,$FC7E,$7E7C
	dc.w	$EEFE,$0EE6,$E06C,$7C7C
	dc.w	$7C7C,$FC7E,$FEEE,$EEEE
	dc.w	$EEEE,$FE3C,$803C,$1000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$000C,$1830,$0000
	dc.w	$0066,$0C18,$6618,$1800
	dc.w	$1866,$1866,$1830,$6618
	dc.w	$0C00,$3F18,$6630,$1830
	dc.w	$0066,$660C,$0000,$1C00
	dc.w	$0C0C,$0C0C,$3434,$0000
	dc.w	$0000,$00C6,$C600,$1BD8
	dc.w	$3434,$0200,$007F,$3034
	dc.w	$3466,$0C00,$7C7E,$7EF1
	dc.w	$337B,$0000,$0000,$0000
	dc.w	$0000,$6000,$0060,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$000E,$0000
	dc.w	$001C,$0000,$7F00,$0000
	dc.w	$3C00,$000E,$0C00,$3E3C
	dc.w	$0018,$300C,$0018,$1800
	dc.w	$1C1C,$0078,$0038,$7800
	dc.w	$003C,$3C0C,$301C,$7E63
	dc.w	$01C3,$3C0C,$60C0,$05A0
	dc.w	$6303,$0303,$6360,$6003
	dc.w	$6363,$0060,$0FF8,$0B28
	dc.w	$0038,$EE6C,$FEC6,$3838
	dc.w	$381C,$6C38,$0000,$0006
	dc.w	$EE38,$0E0E,$E0E0,$E00E
	dc.w	$EEEE,$3800,$1E00,$78FE
	dc.w	$C6EE,$EEEE,$EEE0,$E0EE
	dc.w	$EE38,$0EEE,$E0FE,$EEEE
	dc.w	$EEEE,$EEE0,$38EE,$EEEE
	dc.w	$EEEE,$FE30,$C00C,$3800
	dc.w	$C000,$0000,$0E00,$0000
	dc.w	$0038,$0EC0,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0018,$1818,$3018
	dc.w	$3C00,$1866,$000C,$1800
	dc.w	$6600,$0C00,$6618,$0000
	dc.w	$1800,$7866,$0018,$6618
	dc.w	$6600,$000C,$1C66,$361E
	dc.w	$1818,$1818,$5858,$7C7C
	dc.w	$1800,$00CC,$CC18,$366C
	dc.w	$5858,$3C02,$00D8,$1858
	dc.w	$5800,$1810,$CCC3,$C35B
	dc.w	$0033,$667C,$1E7E,$7C1C
	dc.w	$1E7E,$6E3C,$3C7E,$6C0E
	dc.w	$3E36,$7E66,$7E7C,$D67C
	dc.w	$1C3E,$FE7E,$3619,$0866
	dc.w	$0036,$3F00,$6300,$0000
	dc.w	$183C,$3C1B,$1810,$7066
	dc.w	$7E18,$1818,$0E18,$1832
	dc.w	$363E,$006C,$006C,$0C00
	dc.w	$007E,$3C7E,$7E49,$7C41
	dc.w	$03D3,$3C0E,$7FDF,$05A0
	dc.w	$6303,$0303,$6360,$6003
	dc.w	$6363,$7C78,$18EC,$0DD8
	dc.w	$0038,$EEFE,$D0CC,$3870
	dc.w	$381C,$38FE,$0000,$000E
	dc.w	$EE38,$0E7C,$F8FC,$FC7E
	dc.w	$7CEE,$3838,$3CFE,$3C0E
	dc.w	$CEEE,$FCE0,$EEFC,$FCE0
	dc.w	$FE38,$0EFC,$E0FE,$EEEE
	dc.w	$EEEE,$FCFC,$38EE,$EEEE
	dc.w	$7CEE,$1C30,$600C,$6C00
	dc.w	$60FC,$FC7C,$7E7E,$7E7E
	dc.w	$E038,$0ECE,$E06C,$FC7C
	dc.w	$FC7C,$FC7E,$70EE,$EEEE
	dc.w	$EEEE,$FE18,$1818,$7918
	dc.w	$6600,$0000,$7C00,$003C
	dc.w	$007C,$0000,$0000,$1818
	dc.w	$7E7E,$D800,$0000,$0000
	dc.w	$003C,$661E,$3A66,$6630
	dc.w	$0000,$0000,$0000,$06C6
	dc.w	$0000,$00D8,$D800,$6C36
	dc.w	$0000,$663C,$7ED8,$0000
	dc.w	$3C00,$3038,$CCBD,$BD55
	dc.w	$7333,$760C,$060C,$060C
	dc.w	$0C36,$660C,$0606,$3E06
	dc.w	$3636,$6666,$0606,$D66C
	dc.w	$0C06,$6666,$363C,$1CF7
	dc.w	$3B66,$337F,$301E,$6C7E
	dc.w	$3C66,$663C,$387C,$6066
	dc.w	$007E,$0C30,$1B18,$004C
	dc.w	$1C1C,$006C,$0F18,$1800
	dc.w	$00FF,$3C7F,$FE63,$7800
	dc.w	$06D3,$3C0A,$6CDB,$0DB0
	dc.w	$0000,$3E3E,$3E3E,$3E00
	dc.w	$3E3E,$0660,$1804,$0628
	dc.w	$0038,$006C,$FE18,$FE00
	dc.w	$381C,$FEFE,$00FE,$001C
	dc.w	$EE38,$1C0E,$FEFE,$EE0E
	dc.w	$EEFE,$3838,$78FE,$1E3E
	dc.w	$D2FE,$EEE0,$EEE0,$E0FE
	dc.w	$EE38,$0EF8,$E0EE,$EEEE
	dc.w	$FEE6,$EEFE,$38EE,$EEEE
	dc.w	$38EE,$3830,$300C,$C600
	dc.w	$30FE,$EEEE,$FEE0,$E0E0
	dc.w	$E000,$00DC,$E0FE,$FEFE
	dc.w	$FEEC,$FEF0,$F8EE,$EEEE
	dc.w	$EEEE,$FE30,$180C,$4F34
	dc.w	$6066,$3C3C,$063C,$3C60
	dc.w	$3CC6,$3C38,$3838,$3C3C
	dc.w	$601B,$DE3C,$3C3C,$6666
	dc.w	$6666,$6630,$303C,$7C7C
	dc.w	$3C38,$3C66,$7C66,$7EC6
	dc.w	$183E,$7C36,$3618,$D81B
	dc.w	$3C3C,$6E6E,$DBDE,$1818
	dc.w	$6600,$0010,$7CB1,$A555
	dc.w	$3333,$3C0C,$0E0C,$660C
	dc.w	$0636,$660C,$0606,$6606
	dc.w	$3636,$763C,$6606,$D66C
	dc.w	$0C06,$6676,$1C66,$3E99
	dc.w	$6E7C,$3136,$1838,$6C18
	dc.w	$667E,$666E,$54D6,$7E66
	dc.w	$7E18,$1818,$1B18,$7E00
	dc.w	$0000,$006C,$1830,$0C00
	dc.w	$003C,$FF7F,$FE49,$7141
	dc.w	$CCDB,$7E0A,$6FFF,$0DB0
	dc.w	$6303,$6003,$0303,$6303
	dc.w	$6303,$7E7E,$1004,$07D0
	dc.w	$0038,$006C,$1630,$FE00
	dc.w	$381C,$38FE,$00FE,$0038
	dc.w	$EE38,$380E,$FEFE,$EE0E
	dc.w	$EE7E,$0000,$7800,$1E3C
	dc.w	$CEEE,$EEE0,$EEE0,$E0EE
	dc.w	$EE38,$0EF8,$E0EE,$EEEE
	dc.w	$FCEA,$EE7E,$38EE,$EEEE
	dc.w	$7C7E,$7030,$180C,$0000
	dc.w	$00EE,$FCE0,$EEFC,$FCEE
	dc.w	$FC38,$0EF8,$E0FE,$EEEE
	dc.w	$EEEC,$EE7C,$70EE,$EEEE
	dc.w	$7C7E,$3C18,$1818,$0634
	dc.w	$6666,$7E06,$7E06,$0660
	dc.w	$7EFC,$7E18,$1818,$6666
	dc.w	$7C7F,$F866,$6666,$6666
	dc.w	$6666,$6630,$7C18,$6630
	dc.w	$0618,$6666,$6676,$C6C6
	dc.w	$3030,$0C6B,$6E18,$6C36
	dc.w	$0666,$7676,$DFD8,$3C3C
	dc.w	$6600,$0010,$0CB1,$B951
	dc.w	$3333,$6E0C,$1E0C,$660C
	dc.w	$0636,$6600,$0606,$6606
	dc.w	$3636,$0606,$6606,$D66C
	dc.w	$0C06,$6606,$0C66,$7799
	dc.w	$6466,$3036,$306C,$6C18
	dc.w	$6666,$6666,$54D6,$6066
	dc.w	$0018,$300C,$18D8,$0032
	dc.w	$0000,$186C,$D87C,$7800
	dc.w	$003C,$7E7E,$7E1C,$6363
	dc.w	$78C3,$1038,$0C1E,$1998
	dc.w	$6303,$6003,$0303,$6303
	dc.w	$6303,$6618,$1004,$2E10
	dc.w	$0000,$00FE,$FE66,$3800
	dc.w	$381C,$6C38,$1C00,$3870
	dc.w	$EE38,$700E,$381E,$EE0E
	dc.w	$EE0E,$3838,$3CFE,$3C00
	dc.w	$C0EE,$EEEE,$EEE0,$E0EE
	dc.w	$EE38,$0EFC,$E0EE,$EEEE
	dc.w	$E0FC,$EE0E,$38EE,$EEFE
	dc.w	$FE0E,$FE30,$0C0C,$0000
	dc.w	$00FE,$EEEE,$EEE0,$E0EE
	dc.w	$FE38,$0EF8,$E0FE,$EEFE
	dc.w	$FE7C,$E01E,$70FE,$FEFE
	dc.w	$7C0E,$7818,$1818,$0062
	dc.w	$3C66,$607E,$C67E,$7E3C
	dc.w	$60C0,$6018,$1818,$7E7E
	dc.w	$60D8,$D866,$6666,$6666
	dc.w	$3E66,$661E,$303C,$6630
	dc.w	$7E18,$6666,$666E,$7E7C
	dc.w	$6030,$0CC3,$D618,$366C
	dc.w	$7E66,$6666,$D8D8,$6666
	dc.w	$6600,$0010,$1EBD,$AD00
	dc.w	$7B7B,$667E,$360C,$660C
	dc.w	$0636,$7E00,$3C0E,$6E3E
	dc.w	$1C7E,$7E7E,$6406,$FEEC
	dc.w	$0C06,$7E06,$0C3C,$63EF
	dc.w	$6E66,$3036,$636C,$6C18
	dc.w	$3C66,$2476,$38D6,$7066
	dc.w	$7E00,$0000,$18D8,$184C
	dc.w	$0000,$1800,$7000,$0000
	dc.w	$003C,$3C0C,$303E,$4777
	dc.w	$30C3,$3878,$0C1B,$799E
	dc.w	$3E03,$3E3E,$033E,$3E03
	dc.w	$3E3E,$3C18,$1E3C,$39E0
	dc.w	$0038,$006C,$FEC6,$3800
	dc.w	$3E7C,$C638,$1C00,$38E0
	dc.w	$FE38,$FEFE,$38FE,$FE0E
	dc.w	$FE0E,$3838,$1EFE,$7838
	dc.w	$7EEE,$FEFE,$FEFE,$E0FE
	dc.w	$EEFE,$FEEE,$FEEE,$EEFE
	dc.w	$E0EE,$EEFE,$38FE,$7CFE
	dc.w	$EEFE,$FE3C,$063C,$00FF
	dc.w	$00EE,$FEFE,$FEFE,$E0FE
	dc.w	$EE38,$FEDC,$FCEE,$EEFE
	dc.w	$FC0E,$E0FE,$7EFE,$7CFE
	dc.w	$EEFE,$FE0C,$1830,$007E
	dc.w	$083E,$3C3E,$7E3E,$3E08
	dc.w	$3C7C,$3C3C,$3C3C,$6666
	dc.w	$7E7E,$DF3C,$3C3C,$3E3E
	dc.w	$063C,$3E0C,$7E18,$7C30
	dc.w	$3E3C,$3C3E,$6666,$0000
	dc.w	$6330,$0C86,$9F18,$1BD8
	dc.w	$3E3C,$3C3C,$7E7F,$7E7E
	dc.w	$6600,$0000,$0CC3,$C300
	dc.w	$0303,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$6000,$0000
	dc.w	$0C06,$0006,$0C98,$4126
	dc.w	$3B7C,$3036,$7F38,$7F18
	dc.w	$183C,$663C,$307C,$3E66
	dc.w	$007E,$7E7E,$1870,$1800
	dc.w	$0000,$0000,$3000,$0000
	dc.w	$0000,$1808,$1000,$0000
	dc.w	$007E,$1030,$0000,$718E
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$001E,$1754,$3800
	dc.w	$0038,$0000,$1086,$3800
	dc.w	$1E78,$0000,$3800,$38C0
	dc.w	$7C38,$FE7C,$38FC,$7C0E
	dc.w	$7C0E,$3870,$0E00,$7038
	dc.w	$00EE,$FC7C,$FC7E,$E07C
	dc.w	$EEFE,$FCE6,$7EEE,$EE7C
	dc.w	$E074,$EEFC,$387C,$386C
	dc.w	$EEFC,$FE00,$0000,$0000
	dc.w	$00EE,$FC7C,$7E7E,$E07C
	dc.w	$EE38,$7CCE,$7CEE,$EE7C
	dc.w	$E00E,$E0FC,$3E7C,$386C
	dc.w	$EEFC,$FE00,$0000,$0000
	dc.w	$3800,$0000,$0000,$0038
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$3C00,$000C,$0000,$6060
	dc.w	$0000,$0000,$0000,$7C7C
	dc.w	$3E00,$000F,$0618,$0000
	dc.w	$0000,$4040,$0000,$6666
	dc.w	$3C00,$0000,$0C7E,$7E00
	dc.w	$0E0E,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0070,$0000
	dc.w	$0060,$7C24,$0000,$C010
	dc.w	$3C00,$0000,$6010,$0000
	dc.w	$0000,$0000,$1800,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000

COMPTEUR:	dc.w	0
DEBUT_TEXTE:	dc.l	TEXTE
TEXTE:    
	dc.b	'        '
	dc.b	'        '
	dc.b	'        '
	dc.b	'TO CHOOSE AN INTRO : USE KEYBOARD WITH ARROWKEYS TO SELECT AND TAPE SPACEBAR TO SEE IT.'
	dc.b	'        '
	dc.b	'        '
	dc.b	'        '
	dc.b	'TO QUIT AND RETURN TO THE DESKTOP : ESCAPE KEY.                                        '
	dc.b	'        '
	dc.b	'        '
	dc.b	'        '
	dc.b	'WE HAVE A LITTLE PROBLEM WITH THE INTRO NUMBER TEN TO USE IT WITH THE MENU. SORRY TO SEE THE INTRO ON THE LGD DESKTOP.'
	dc.b	'        '
	dc.b	'        '
	dc.b	'        '
	dc.b	'I FORGOT : THE INTRO NUMBER EIGHT WHO RUN ONLY ON A REAL ATARI STF ;)                                             '
	dc.b	'        '
	dc.b	'        '
	dc.b	'        '
	dc.b	'THIS IS THE BEST ALL ATARI ST CREWS REVIEW : '
	DC.B  '007 - '
	DC.B  '1984 - '
	DC.B  '1ST CREW - '
	DC.B  '42-CREW - '
	DC.B  '49',$27,'ERS - '
	DC.B  'ABCS 85 - '
	DC.B  'ABSCENCE - '
	DC.B  'ABSTRACT - '
	DC.B  'ACCS - '
	DC.B  'ADMIRABLES - '
	DC.B  'ADRENALIN UK - '
	DC.B  'ADRENALINE - '
	DC.B  'ADRENALYN - '
	DC.B  'AEC - '
	DC.B  'AENIGMATICA - '
	DC.B  'AGGRESSION - '
	DC.B  'AIDS - '
	DC.B  'ALBEDO 0.12 - '
	DC.B  'ALEXANDER THE GREAT - '
	DC.B  'ALIEN CRACKING FORMATION - '
	DC.B  'ALIEN NATION - '
	DC.B  'ALIENS (THE) - '
	DC.B  'ALLIANCE (THE GERMAN) - '
	DC.B  'ALLIANCE (THE) - '
	DC.B  'ALPHA FLIGHT - '
	DC.B  'ALYSSA - '
	DC.B  'AMNESIC CACTUS - '
	DC.B  'ANARCHY - '
	DC.B  'ANATOMICA - '
	DC.B  'ANCIENT CELTS - '
	DC.B  'ANGEL OF DARKNESS - '
	DC.B  'ANIMAL MINE - '
	DC.B  'ANIMI DUX - '
	DC.B  'ANTI AMIGA CREW - '
	DC.B  'ANTI ASSEMBLEUR TEAM - '
	DC.B  'ANTIC - '
	DC.B  'ARAKIS - '
	DC.B  'ARGANOID - '
	DC.B  'ARGONAUTS - '
	DC.B  'ARKHAM - '
	DC.B  'ARSENIC - '
	DC.B  'ART MACHINE (THE) - '
	DC.B  'ART OF CODE - '
	DC.B  'ARTIS MAGIA - '
	DC.B  'ASTRA - '
	DC.B  'ASYLUM (THE) - '
	DC.B  'ATARI BOYS - '
	DC.B  'ATARIFORCE - '
	DC.B  'A-TEAM - '
	DC.B  'ATLANTIDE - '
	DC.B  'ATLANTIS - '
	DC.B  'ATROCITY - '
	DC.B  'AURA - '
	DC.B  'AUTOMATION - '
	DC.B  'AVENA - '
	DC.B  'AVENDESORA - '
	DC.B  'AVENGERS (THE) - '
	DC.B  'AWESOME - '
	DC.B  'AXIOM - '
	DC.B  'AXXIS - '
	DC.B  'B.O.A. - '
	DC.B  'B.O.S.S. - '
	DC.B  'BAC - '
	DC.B  'BAD BOYS BELGIUM - '
	DC.B  'BAD BREW CREW - '
	DC.B  'BAD INFLUENCE - '
	DC.B  'BAD STARS - '
	DC.B  'BALD EAGLE (THE) - '
	DC.B  'BARBARIANS (THE) - '
	DC.B  'BASSMENT (THE) - '
	DC.B  'BASTARDS INTERNATIONAL - '
	DC.B  'BAT BOYS (THE) - '
	DC.B  'BERLIN CHAOTS (THE) - '
	DC.B  'BIG BOSSMAN (THE) - '
	DC.B  'BIG FOUR (THE) - '
	DC.B  'BINARIS - '
	DC.B  'BITS CLUB (THE) - '
	DC.B  'BITSTOPPERS (THE) - '
	DC.B  'BLABLA - '
	DC.B  'BLACK BOXES (THE) - '
	DC.B  'BLACK BYTE - '
	DC.B  'BLACK CATS (THE) - '
	DC.B  'BLACK LOTUS (THE) - '
	DC.B  'BLACK MONOLITH TEAM - '
	DC.B  'BLACK PANTHERS - '
	DC.B  'BLACK WIZARDS (THE) - '
	DC.B  'BLADE RUNNERS - '
	DC.B  'BLANK - '
	DC.B  'BLIND IO - '
	DC.B  'BLT - '
	DC.B  'BLUE ADEPT - '
	DC.B  'BLUE BOYS - '
	DC.B  'BLUE HARVEST - '
	DC.B  'BLUE SOFTWARE - '
	DC.B  'BLUE SYSTEM - '
	DC.B  'BLUES BROTHERS - '
	DC.B  'BO! - '
	DC.B  'BODGE UP SOFTWARE TEAM - '
	DC.B  'BOG BROTHERS - '
	DC.B  'BRAIN - '
	DC.B  'BRAIN BUSTERS (THE) - '
	DC.B  'BRAIN WASHERS CO (THE) - '
	DC.B  'BRAINIACS - '
	DC.B  'BRAINLESS INSTITUTE - '
	DC.B  'BRAINPOWER - '
	DC.B  'BUSHWACKERS - '
	DC.B  'BXC - '
	DC.B  'C.I.R.A. HACKERS - '
	DC.B  'CAREBEARS (THE) - '
	DC.B  'CARTOONS - '
	DC.B  'CAT DEVELOPMENT - '
	DC.B  'CELL - '
	DC.B  'CEREBRAL VORTEX - '
	DC.B  'CHAOS - '
	DC.B  'CHAOS ENGINE (THE) - '
	DC.B  'CHAOTIC MOTION - '
	DC.B  'CHECKPOINT - '
	DC.B  'CHESIRE CAT (THE) - '
	DC.B  'CHIMERIC DESIRES - '
	DC.B  'CHRONICLE - '
	DC.B  'CLAN - '
	DC.B  'CLIMATICS - '
	DC.B  'CLOCKWORK ORANGE - '
	DC.B  'CLONE - '
	DC.B  'COBRA TEAM - '
	DC.B  'COCKNEY REJECTS - '
	DC.B  'CODERS (THE) - '
	DC.B  'CONCEPTORS (THE) - '
	DC.B  'CONDEMNED - '
	DC.B  'CONFUSIONS - '
	DC.B  'CONSPIRACY - '
	DC.B  'CONSTELLATIONS - '
	DC.B  'CONSTRUCT CREW - '
	DC.B  'COOL CREW - '
	DC.B  'COOL GIRLS - '
	DC.B  'COPY SERVICE STUTTGART - '
	DC.B  'COR BLIMEY NOT ARF - '
	DC.B  'CORPORATION (THE) - '
	DC.B  'CRACK CONNEXION (THE) - '
	DC.B  'CRACKING SERVICE HAVRAIS - '
	DC.B  'CRACKODILES (THE) - '
	DC.B  'CRAZY BOY - '
	DC.B  'CREAM - '
	DC.B  'CRIME - '
	DC.B  'CRIMINAL IN DISGUISE - '
	DC.B  'CRUSADERS - '
	DC.B  'CRUSADERS (THE) - '
	DC.B  'CRYSTALIC - '
	DC.B  'CYBERNETICS - '
	DC.B  'CYBORG - '
	DC.B  'CYCLADES - '
	DC.B  'CYCLEMASTERS (THE) - '
	DC.B  'CYCLONE - '
	DC.B  'CYNIX - '
	DC.B  'DA BOOSTERS - '
	DC.B  'DARK ANGELS - '
	DC.B  'D-BUG - '
	DC.B  'DCS - '
	DC.B  'DEAD HACKERS SOCIETY - '
	DC.B  'DEEP THOUGHT',$27,'S - '
	DC.B  'DEFCON 4 - '
	DC.B  'DEFLECT - '
	DC.B  'DELIGHT - '
	DC.B  'DELIVERANCE (THE) - '
	DC.B  'DELTA FORCE - '
	DC.B  'DELTA PIRATS - '
	DC.B  'DEPRESSION - '
	DC.B  'DETONATORS - '
	DC.B  'DEVIANT CORPORATION (THE) - '
	DC.B  'DEVIANT DESIGNERS - '
	DC.B  'DEWEY - '
	DC.B  'DIAMOND DESIGN - '
	DC.B  'DIGET - '
	DC.B  'DIGI TALLIS - '
	DC.B  'DIGITAL CHAOS - '
	DC.B  'DIGITAL CREW - '
	DC.B  'DIGITAL VISION - '
	DC.B  'DIGITAL WIZARDS - '
	DC.B  'DIGITECH - '
	DC.B  'DILDO FATWA - '
	DC.B  'DIMENSION ZERO - '
	DC.B  'DIRTY TRICKS BRIGADE - '
	DC.B  'DISASTER AREA - '
	DC.B  'DISK BUSTERS ASSOCIATION - '
	DC.B  'DISKMAP CREW - '
	DC.B  'DISNEY WORLD - '
	DC.B  'DIZZIDENCE - '
	DC.B  'DMA - '
	DC.B  'DNT CREW - '
	DC.B  'DOUAI MAIN ASSOCIATION - '
	DC.B  'DOUBLE DUTCH CREW - '
	DC.B  'DOUBLE TROUBLE - '
	DC.B  'DREAM WEAVERS - '
	DC.B  'DUNE - '
	DC.B  'DYNAMIC DUO - '
	DC.B  'DYNAMITE DYNASTIE - '
	DC.B  'EAGLES (THE) - '
	DC.B  'ECLIPSE - '
	DC.B  'ECLIPSIS - '
	DC.B  'EDGE OF SANITY - '
	DC.B  'EFFECT - '
	DC.B  'EGO TRIPPERS - '
	DC.B  'EGOMANIACS - '
	DC.B  'ELECTRA - '
	DC.B  'ELECTRICITY - '
	DC.B  'ELECTRONIC - '
	DC.B  'ELECTRONIC IMAGE - '
	DC.B  'ELITE - '
	DC.B  'ELLIPSE - '
	DC.B  'EMPIRE (THE) - '
	DC.B  'ENIGMA - '
	DC.B  'EPSILON - '
	DC.B  'EQUINOX - '
	DC.B  'ESCAPE - '
	DC.B  'ETERNAL - '
	DC.B  'ETERNITY - '
	DC.B  'EUPHORIA - '
	DC.B  'EUROPEAN SWAPPING CREW - '
	DC.B  'EUROSWAP - '
	DC.B  'EVIL FORCE - '
	DC.B  'EVOLUTION - '
	DC.B  'EXA - '
	DC.B  'EXCELLENCE IN ART - '
	DC.B  'EXCEPTIONS (THE) - '
	DC.B  'EXPLORER - '
	DC.B  'EXTACY - '
	DC.B  'EXTRACT - '
	DC.B  'EXTREAM - '
	DC.B  'EXTREME - '
	DC.B  'EXTREMLY KRIMINAL ORGANISATION - '
	DC.B  'FACTORY - '
	DC.B  'FALCON USERS NETHERLANDS - '
	DC.B  'FALLEN ANGELS (THE) - '
	DC.B  'FANATICS - '
	DC.B  'FANATICS (THE) - '
	DC.B  'FANTASY - '
	DC.B  'FANTASY CRACKERS (THE) - '
	DC.B  'FASHION - '
	DC.B  'FEDERATION AGAINST LAMER AND LOSER - '
	DC.B  'FEDERATION OF FREE TRADERS - '
	DC.B  'FINAL SPACECODERS - '
	DC.B  'FINGERBOBS - '
	DC.B  'FIRE CRACKERS - '
	DC.B  'FIREHAWKS (THE) - '
	DC.B  'FIRESOFT - '
	DC.B  'FIRM (THE) - '
	DC.B  'FIRSTE - '
	DC.B  'FISK KOMPANIET - '
	DC.B  'FISSION - '
	DC.B  'FIT - '
	DC.B  'FLAMES OF FINLAND - '
	DC.B  'FLASH - '
	DC.B  'FLAT LINERS - '
	DC.B  'FLEXIBLE FRONT - '
	DC.B  'FLEXICRON - '
	DC.B  'FORCE (THE) - '
	DC.B  'FORCE 69 - '
	DC.B  'FOREST FOLK - '
	DC.B  'FORMATION CREW (THE) - '
	DC.B  'FOUNDATION TWO - '
	DC.B  'FOXX - '
	DC.B  'FRAGGLE',$27,'S (THE) - '
	DC.B  'FRONT DE LIBERATION ATARISTE - '
	DC.B  'FRONTLINE - '
	DC.B  'FULL METAL COMPUTERS CONNEXION - '
	DC.B  'FUN - '
	DC.B  'FUN INDUSTRIES - '
	DC.B  'FUNVISION - '
	DC.B  'FUTURE MINDS - '
	DC.B  'FUZION - '
	DC.B  'GALTAN 6 - '
	DC.B  'GAME OVER - '
	DC.B  'GAMEMASTERS (THE) - '
	DC.B  'GANJA KID - '
	DC.B  'GARLIC EATERS (THE) - '
	DC.B  'GENESIS - '
	DC.B  'GENESIS INC (THE) - '
	DC.B  'GERMS (THE) - '
	DC.B  'G-FORCE - '
	DC.B  'GHOST - '
	DC.B  'GHOST GENIUS (THE) - '
	DC.B  'GIANTS (THE) - '
	DC.B  'GIGABYTE CREW (THE) - '
	DC.B  'GOLDEN DAWN - '
	DC.B  'GRAVATICS - '
	DC.B  'GREUH! - '
	DC.B  'GUARDIANS OF LOGIK - '
	DC.B  'GUDUL CORPORATION - '
	DC.B  'GUILD (THE) - '
	DC.B  'H.A.C - '
	DC.B  'HCC - '
	DC.B  'HEMOROIDS - '
	DC.B  'HIDDEN STRENGHT - '
	DC.B  'HIGH VOLTAGE - '
	DC.B  'HIGHLANDER GUILD (THE) - '
	DC.B  'HIJACKERS (THE) - '
	DC.B  'HITCHICKER (THE) - '
	DC.B  'HOFA - '
	DC.B  'HOLOCAUST - '
	DC.B  'HOPELESS LAMERS - '
	DC.B  'HORIZON - '
	DC.B  'HOTLINE - '
	DC.B  'HOWDY - '
	DC.B  'HYDROXID - '
	DC.B  'HYPNOSIS - '
	DC.B  'HYSTERIA - '
	DC.B  'I.C.E - '
	DC.B  'ICARUS - '
	DC.B  'ICARUZ - '
	DC.B  'ICEBIRD - '
	DC.B  'IDEMLINE - '
	DC.B  'ILLEGAL EXCEPTION - '
	DC.B  'IMA - '
	DC.B  'IMAGINA - '
	DC.B  'IMMORTAL IMAGINATION CREW - '
	DC.B  'IMPACT - '
	DC.B  'IMPULSE - '
	DC.B  'INNER CIRCLE - '
	DC.B  'INSANITY - '
	DC.B  'INSOMNIA - '
	DC.B  'INTER - '
	DC.B  'INTER DEVELOPMENTS - '
	DC.B  'INTERGALACTIC - '
	DC.B  'INTERNATIONAL CRACKING SERVICE - '
	DC.B  'INTRUDERS (THE) - '
	DC.B  'INVIZIBLES OF FLEXICRON (THE) - '
	DC.B  'IRATA - '
	DC.B  'IRON TEAM - '
	DC.B  'JMP - '
	DC.B  'JSD - '
	DC.B  'JUSTICE DEPARTMENT - '
	DC.B  'KAT PROJECTS - '
	DC.B  'KEMPSOFT - '
	DC.B  'KICK IT IN SOFTWARE - '
	DC.B  'KIDS GHOSTS BROTHERS (THE) - '
	DC.B  'KNIGHT TEAM (THE) - '
	DC.B  'KOPA - '
	DC.B  'KRS - '
	DC.B  'KRUZ - '
	DC.B  'LAMERS FOUNDATION (THE) - '
	DC.B  'LAZER - '
	DC.B  'LEGACY - '
	DC.B  'LEGEND OF DOOM - '
	DC.B  'LEGION - '
	DC.B  'LEMMINGS - '
	DC.B  'LENGAME - '
	DC.B  'LES NULS - '
	DC.B  'LEVEL 16 - '
	DC.B  'LIGHT - '
	DC.B  'LIGHT TEAM (THE) - '
	DC.B  'LINEOUT - '
	DC.B  'LONEWOLF - '
	DC.B  'LORD HACKBEAR - '
	DC.B  'LOST BOYS (THE) - '
	DC.B  'LOUD! - '
	DC.B  'LOWER LEVEL - '
	DC.B  'LOWLIFE INC. - '
	DC.B  'LSD - '
	DC.B  'LUZAK TEAM - '
	DC.B  'LYNX - '
	DC.B  'M.D.K. - '
	DC.B  'MAD - '
	DC.B  'MAD DOGS (THE) - '
	DC.B  'MAD VISION - '
	DC.B  'MANGA MANIACS - '
	DC.B  'MANTRONIX - '
	DC.B  'MARVELLOUS V8 (THE) - '
	DC.B  'MARVELS CORPORATION (THE) - '
	DC.B  'MASTER CRACKING SERVICE - '
	DC.B  'MASTERS (THE) - '
	DC.B  'MASTERS OF CAVALCADE - '
	DC.B  'MEAN MACHINES UNITED - '
	DC.B  'MEDWAY BOYS (THE) - '
	DC.B  'MEGA FOUR (THE) - '
	DC.B  'MEGABUSTER (THE) - '
	DC.B  'MEGACREW - '
	DC.B  'MEGALAMERS (THE) - '
	DC.B  'MEGAWOT AND JAILHOUSE - '
	DC.B  'MENACING CRACKING ALLIANCE (THE) - '
	DC.B  'MFC NEWS - '
	DC.B  'MIND-DESIGN - '
	DC.B  'MISFITS - '
	DC.B  'MISFITS SOFTWARE (THE) - '
	DC.B  'MJJ PROD - '
	DC.B  'MLP - '
	DC.B  'MONARCH - '
	DC.B  'MR CHIPS CRACKING CORPORATED - '
	DC.B  'MST - '
	DC.B  'MUGWUMPS - '
	DC.B  'MYSTERONS - '
	DC.B  'MYSTERONS - '
	DC.B  'MYSTIC - '
	DC.B  'MYSTIC BYTES - '
	DC.B  'NAOS - '
	DC.B  'NASTY BOYS (THE) - '
	DC.B  'NATO - '
	DC.B  'NATURE ATARI DIVISION - '
	DC.B  'NAUGHTY BYTES (THE) - '
	DC.B  'NEON LIGHTS - '
	DC.B  'NERVE CENTER (THE) - '
	DC.B  'NETWORK (THE) - '
	DC.B  'NEW BEAT DEVELOPMENTS - '
	DC.B  'NEW CORE - '
	DC.B  'NEW GENERATION (THE) - '
	DC.B  'NEW ORDER - '
	DC.B  'NEW PIRATES - '
	DC.B  'NEW POWER GENERATION - '
	DC.B  'NEW SYSTEM - '
	DC.B  'NEW TREND - '
	DC.B  'NEWLINE - '
	DC.B  'NEXT - '
	DC.B  'NEXT GENERATION - '
	DC.B  'NGC - '
	DC.B  'NO CREW - '
	DC.B  'NO LIMIT CODING - '
	DC.B  'NO TEAM - '
	DC.B  'NOEXTRA - '
	DC.B  'NOKTURNAL - '
	DC.B  'NORDIK CODERS - '
	DC.B  'NORTHSIDE - '
	DC.B  'NOTEC - '
	DC.B  'NOTHING PERSONAL - '
	DC.B  'NOW 5 - '
	DC.B  'NUN! - '
	DC.B  'O.U.C.H - '
	DC.B  'ODYSSEY - '
	DC.B  'OFF BASE - '
	DC.B  'OFFBEAT - '
	DC.B  'OMEGA - '
	DC.B  'OMNICRON - '
	DC.B  'OPPOSITION (THE) - '
	DC.B  'ORION - '
	DC.B  'OUT OF ORDER - '
	DC.B  'OUTLAW - '
	DC.B  'OVERLANDERS (THE) - '
	DC.B  'OVERLORDS - '
	DC.B  'OXYGENE - '
	DC.B  'OXYTHAN - '
	DC.B  'OZONE - '
	DC.B  'PAPY BOOM  - '
	DC.B  'PARADISE - '
	DC.B  'PARADOX - '
	DC.B  'PARANOIA - '
	DC.B  'PASSION - '
	DC.B  'PASSWORDS - '
	DC.B  'PAULO SIMOES AND CARLOS DIAS - '
	DC.B  'PENDRAGONS (THE) - '
	DC.B  'PERSISTENCE OF VISION - '
	DC.B  'PHALANX - '
	DC.B  'PHENIX - '
	DC.B  'PHOBYX - '
	DC.B  'PHYSICS - '
	DC.B  'PIXEL TWINS (THE) - '
	DC.B  'POETS OF DECAY - '
	DC.B  'POLTERGEIST - '
	DC.B  'POMPEY PIRATES - '
	DC.B  'POPSY TEAM - '
	DC.B  'POSITIVITY - '
	DC.B  'PREDATORS (THE) - '
	DC.B  'PRIESTS OF PLEASURE - '
	DC.B  'PRISM - '
	DC.B  'PROBYTE - '
	DC.B  'PROPHANATOR - '
	DC.B  'PROPHECY - '
	DC.B  'PSYCHO HACKING FORCE - '
	DC.B  'PSYCHONOMIX - '
	DC.B  'PUBLIC DOMAIN PACKING CREW - '
	DC.B  'PUBLIC ENEMIES (THE) - '
	DC.B  'PULSE - '
	DC.B  'PULSION - '
	DC.B  'PURE ENERGY - '
	DC.B  'PYJAMA - '
	DC.B  'PYROTECHNICS - '
	DC.B  'QUARTET (THE) - '
	DC.B  'QUARTEX - '
	DC.B  'QUATERMASS XPERIMENT (THE) - '
	DC.B  'R.B.C.G. - '
	DC.B  'RAD RAVERS (THE) - '
	DC.B  'RADIATION - '
	DC.B  'RADICAL BANDITS (THE) - '
	DC.B  'RADICAL SYSTEMS - '
	DC.B  'RAGA TWINS - '
	DC.B  'RAIDERS OF THE LOST LOCK & CO (THE) - '
	DC.B  'RAM-KILLER - '
	DC.B  'RANDOM ACCESS - '
	DC.B  'RASERO TEAM - '
	DC.B  'REANIMATORS (THE) - '
	DC.B  'REBELS - '
	DC.B  'RED HERRINGS (THE) - '
	DC.B  'REDLITE - '
	DC.B  'REFLECTION - '
	DC.B  'REGRESSION THERAPY  - '
	DC.B  'REJECT - '
	DC.B  'REMOVERS (THE) - '
	DC.B  'REPLICANTS (THE) - '
	DC.B  'REPROBATES (THE) - '
	DC.B  'RESERVOIR FROGS - '
	DC.B  'RESERVOIR GODS - '
	DC.B  'RESPECTABLES (THE) - '
	DC.B  'REVOLUTION - '
	DC.B  'RIBBON - '
	DC.B  'RIPP OF MERCHANT - '
	DC.B  'RIPPED OFF - '
	DC.B  'RISK - '
	DC.B  'ROUND TABLE (THE) - '
	DC.B  'ROYAL INSTANT PUDDING - '
	DC.B  'S.C.A - '
	DC.B  'SAFARI - '
	DC.B  'SANITY - '
	DC.B  'SATANTRONIC - '
	DC.B  'SCOOBY DOO CREW - '
	DC.B  'SCOTTISH CRACKING CREW (THE) - '
	DC.B  'SCSI - '
	DC.B  'SCUM OF THE EARTH - '
	DC.B  'SECTION 9 - '
	DC.B  'SECTION ONE - '
	DC.B  'SECTION X - '
	DC.B  'SECTOR ONE - '
	DC.B  'SEDMA - '
	DC.B  'SENIOR DADS - '
	DC.B  'SENTRY - '
	DC.B  'SERENADE - '
	DC.B  'SERIAL KILLERS (THE) - '
	DC.B  'SERVAL - '
	DC.B  'SEWER SOFTWARE - '
	DC.B  'SHADOWS - '
	DC.B  'SHAOLIN MASTERS - '
	DC.B  'SHARE WARES - '
	DC.B  'SHOGUN - '
	DC.B  'SIGMA - '
	DC.B  'SILVER BULLET FORCE - '
	DC.B  'SILVER GHOSTS (THE) - '
	DC.B  'SILVERS - '
	DC.B  'SINISTER - '
	DC.B  'SIRIUS CYBERNETICS CORPORATION (THE) - '
	DC.B  'SIXTEEN BIT CREW - '
	DC.B  'SKUNK (THE) - '
	DC.B  'SLAYTANIC CULT - '
	DC.B  'SOFTRUNNER GROUP - '
	DC.B  'SOURCE (THE) - '
	DC.B  'SPACE MARINES (THE) - '
	DC.B  'SPECIAL FX - '
	DC.B  'SPECTRE - '
	DC.B  'SPHERICAL - '
	DC.B  'SPHINX - '
	DC.B  'SPICE BOYS - '
	DC.B  'SPIRITS - '
	DC.B  'SPIRITS OF DOOM - '
	DC.B  'SPL CREW - '
	DC.B  'SPYJACK - '
	DC.B  'ST ACTION - '
	DC.B  'ST AMIGOS - '
	DC.B  'ST APOCALYPSE - '
	DC.B  'ST CONNEXION - '
	DC.B  'ST CRACKING SERVICE - '
	DC.B  'ST FACTORY - '
	DC.B  'ST FORCE - '
	DC.B  'ST KNIGHTS - '
	DC.B  'ST NEWS - '
	DC.B  'ST SPIRIT - '
	DC.B  'ST SQUAD - '
	DC.B  'STARFIRES - '
	DC.B  'STAX - '
	DC.B  'STEELWINGS - '
	DC.B  'STEW - '
	DC.B  'STORM BROTHERS (THE) - '
	DC.B  'STORMBRINGERS (THE) - '
	DC.B  'STRANGER - '
	DC.B  'STRANGLERS (THE) - '
	DC.B  'ST-REBELS  - '
	DC.B  'SUB HUMANS IN TURKEY - '
	DC.B  'SUBLIME - '
	DC.B  'SUN GODESSES - '
	DC.B  'SUPER BIDON’S CRACK GANG - '
	DC.B  'SUPERIOR - '
	DC.B  'SUPREMACY - '
	DC.B  'SWEDISH CRACKING SERVICE INTERNATIONAL - '
	DC.B  'SYNC - '
	DC.B  'SYNCHRON OF LEGACY - '
	DC.B  'SYNCRO SYSTEMS - '
	DC.B  'SYNDICATE (THE) - '
	DC.B  'SYNERGY - '
	DC.B  'SYNTAX - '
	DC.B  'T.O.I - '
	DC.B  'T.O.Y.S. - '
	DC.B  'TBL - '
	DC.B  'TBT - '
	DC.B  'TDA - '
	DC.B  'TEARDROP - '
	DC.B  'TEC - '
	DC.B  'TECHNO GANGSTERS (THE) - '
	DC.B  'TEENAGE - '
	DC.B  'TEETH SHAKERS (THE) - '
	DC.B  'TEKNIX - '
	DC.B  'TEQUE - '
	DC.B  'TERMINATORS - '
	DC.B  'TERRABYTE CREW (THE) - '
	DC.B  'THERAPY - '
	DC.B  'THUNDER FORCE - '
	DC.B  'TIME WARP - '
	DC.B  'TIMELORDS - '
	DC.B  'TITANIUM - '
	DC.B  'TKU - '
	DC.B  'TNT-CREW - '
	DC.B  'TOONS - '
	DC.B  'TOP NOTCH - '
	DC.B  'TORMENT - '
	DC.B  'TOS CREW - '
	DC.B  'TOTAL VISION INCORPORATED - '
	DC.B  'TOUR DE FORCE - '
	DC.B  'TOYS - '
	DC.B  'TPN - '
	DC.B  'TRACK 41 - '
	DC.B  'TRASH SECTION - '
	DC.B  'TRIO - '
	DC.B  'TRIPPLE H - '
	DC.B  'TRISOMIC DEVELOPMENTS - '
	DC.B  'TRISTAR & RED SECTOR INCORPORATED - '
	DC.B  'TRITON - '
	DC.B  'TRONIC - '
	DC.B  'TRP - '
	DC.B  'TUMULT - '
	DC.B  'TWINS (THE) - '
	DC.B  'TYPHOON - '
	DC.B  'ULTIMATE (THE) - '
	DC.B  'ULTRA CREW (THE) - '
	DC.B  'UNDEAD - '
	DC.B  'UNDERFORCE (THE) - '
	DC.B  'UNDERGROUND - '
	DC.B  'UNION (THE) - '
	DC.B  'UNIT 17 - '
	DC.B  'UNITED FORCES - '
	DC.B  'UNIVERSAL CODERS - '
	DC.B  'UNLIMITED MATRIX - '
	DC.B  'UN-NAMEABLES (THE) - '
	DC.B  'UNSENSIBLE SOFTWARE - '
	DC.B  'UNTOUCHABLES (THE) - '
	DC.B  'VECTOR - '
	DC.B  'VECTRONIX - '
	DC.B  'VEGETABLES - '
	DC.B  'VISUALIZERS - '
	DC.B  'VMAX - '
	DC.B  'VORTEX - '
	DC.B  'VOYAGERS (THE) - '
	DC.B  'WAIKIKI - '
	DC.B  'WATCHMEN (THE) - '
	DC.B  'WEST OF EUROPE - '
	DC.B  'WHITE STATUS - '
	DC.B  'WILD BOYS (THE) - '
	DC.B  'WILDFIRE - '
	DC.B  'WIZARDS (THE) - '
	DC.B  'WIZZFROG - '
	DC.B  'WORLD’S PICTURE COLLECTION (THE) - '
	DC.B  'XENEX - '
	DC.B  'X-FACTOR - '
	DC.B  'X-STATIC - '
	DC.B  'XTC - '
	DC.B  'X-TREAM - '
	DC.B  'X-TROLL - '
	DC.B  'XXX INTERNATIONAL - '
	DC.B  'YAK - '
	DC.B  'YESCREW - '
	DC.B  'YPSILON - '
	DC.B  'ZEAL - '
	DC.B  'ZODIAC AND '
	DC.B  'ZUUL.'
	dc.b	'        '
	dc.b	'        '
	dc.b	'HUM... HOW MANY CREWS ARE IN THIS BIG LIST ?'
	dc.b	'        '
	dc.b	'        '
	dc.b	'THANKS TO NOVA/EQX FOR HELP ME TO FINISH THIS BIGGEST LIST.'
	dc.b	'        '
	dc.b	'        '
	dc.b	'        '
	dc.b	'        '
	dc.b	'        '
	dc.w $FF00
	
	even

********* PETIT SCROLLING ***********************************<<<

********* BAR MENU ***********************************>>>

SENS_BARRE:	DC.W      $0
HBL_POS_1:	DC.W      $0
HBL_POS_2:	DC.W      $0
POSITION_BARRE:	DC.W      $0
BAR_TEMPO:	DC.W      $0

********* BAR MENU ***********************************<<<

********* LOGO DISTORT *******************************>>>

BUFF_DIST:DCB.W     320,$0 

PTR_COURBE:
	dc.l	COURBE
COURBE:
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0028,$0000,$002A
	dc.w	$0000,$002C,$0000,$002F
	dc.w	$0000,$0031,$0000,$0033
	dc.w	$0000,$0036,$0000,$0038
	dc.w	$0000,$003A,$0000,$003D
	dc.w	$0000,$0040,$0000,$0042
	dc.w	$0000,$0045,$0000,$0047
	dc.w	$0000,$004A,$0000,$004D
	dc.w	$0000,$0050,$0000,$0052
	dc.w	$0000,$0055,$0000,$0058
	dc.w	$0000,$005B,$0000,$005E
	dc.w	$0000,$0061,$0000,$0064
	dc.w	$0000,$0067,$0000,$006A
	dc.w	$0000,$006D,$0000,$0070
	dc.w	$0000,$0073,$0000,$0076
	dc.w	$0000,$0079,$0000,$007C
	dc.w	$0000,$007F,$0000,$0082
	dc.w	$0000,$0086,$0000,$0089
	dc.w	$0000,$008C,$0000,$008F
	dc.w	$0000,$0092,$0000,$0095
	dc.w	$0000,$0099,$0000,$009C
	dc.w	$0000,$009F,$0000,$00A0
	dc.w	$0000,$00A3,$0000,$00A6
	dc.w	$0000,$00A9,$0000,$00AC
	dc.w	$0000,$00AF,$0000,$00B3
	dc.w	$0000,$00B6,$0000,$00B9
	dc.w	$0000,$00BC,$0000,$00BF
	dc.w	$0000,$00C2,$0000,$00C6
	dc.w	$0000,$00C9,$0000,$00CC
	dc.w	$0000,$00CF,$0000,$00D2
	dc.w	$0000,$00D5,$0000,$00D8
	dc.w	$0000,$00DB,$0000,$00DE
	dc.w	$0000,$00E1,$0000,$00E4
	dc.w	$0000,$00E7,$0000,$00E9
	dc.w	$0000,$00EC,$0000,$00EF
	dc.w	$0000,$00F2,$0000,$00F4
	dc.w	$0000,$00F7,$0000,$00FA
	dc.w	$0000,$00FC,$0000,$00FF
	dc.w	$0000,$0102,$0000,$0104
	dc.w	$0000,$0107,$0000,$0109
	dc.w	$0000,$010B,$0000,$010E
	dc.w	$0000,$0110,$0000,$0112
	dc.w	$0000,$0114,$0000,$0117
	dc.w	$0000,$0119,$0000,$011B
	dc.w	$0000,$011D,$0000,$011F
	dc.w	$0000,$0121,$0000,$0123
	dc.w	$0000,$0124,$0000,$0126
	dc.w	$0000,$0128,$0000,$0129
	dc.w	$0000,$012B,$0000,$012D
	dc.w	$0000,$012E,$0000,$0130
	dc.w	$0000,$0131,$0000,$0132
	dc.w	$0000,$0133,$0000,$0135
	dc.w	$0000,$0136,$0000,$0137
	dc.w	$0000,$0138,$0000,$0139
	dc.w	$0000,$013A,$0000,$013A
	dc.w	$0000,$013B,$0000,$013C
	dc.w	$0000,$013D,$0000,$013D
	dc.w	$0000,$013E,$0000,$013E
	dc.w	$0000,$013F,$0000,$013F
	dc.w	$0000,$013F,$0000,$013F
	dc.w	$0000,$013F,$0000,$013F
	dc.w	$0000,$013F,$0000,$013F
	dc.w	$0000,$013F,$0000,$013F
	dc.w	$0000,$013F,$0000,$013F
	dc.w	$0000,$013E,$0000,$013E
	dc.w	$0000,$013D,$0000,$013D
	dc.w	$0000,$013C,$0000,$013B
	dc.w	$0000,$013B,$0000,$013A
	dc.w	$0000,$0139,$0000,$0138
	dc.w	$0000,$0137,$0000,$0136
	dc.w	$0000,$0135,$0000,$0134
	dc.w	$0000,$0132,$0000,$0131
	dc.w	$0000,$0130,$0000,$012E
	dc.w	$0000,$012D,$0000,$012B
	dc.w	$0000,$012A,$0000,$0128
	dc.w	$0000,$0126,$0000,$0125
	dc.w	$0000,$0123,$0000,$0121
	dc.w	$0000,$011F,$0000,$011D
	dc.w	$0000,$011B,$0000,$0119
	dc.w	$0000,$0117,$0000,$0115
	dc.w	$0000,$0112,$0000,$0110
	dc.w	$0000,$010E,$0000,$010C
	dc.w	$0000,$0109,$0000,$0107
	dc.w	$0000,$0104,$0000,$0102
	dc.w	$0000,$00FF,$0000,$00FD
	dc.w	$0000,$00FA,$0000,$00F7
	dc.w	$0000,$00F5,$0000,$00F2
	dc.w	$0000,$00EF,$0000,$00EC
	dc.w	$0000,$00EA,$0000,$00E7
	dc.w	$0000,$00E4,$0000,$00E1
	dc.w	$0000,$00DE,$0000,$00DB
	dc.w	$0000,$00D8,$0000,$00D5
	dc.w	$0000,$00D2,$0000,$00CF
	dc.w	$0000,$00CC,$0000,$00C9
	dc.w	$0000,$00C6,$0000,$00C3
	dc.w	$0000,$00C0,$0000,$00BC
	dc.w	$0000,$00B9,$0000,$00B6
	dc.w	$0000,$00B3,$0000,$00B0
	dc.w	$0000,$00AD,$0000,$00A9
	dc.w	$0000,$00A6,$0000,$00A3
	dc.w	$0000,$00A0,$0000,$009D
	dc.w	$0000,$0099,$0000,$0096
	dc.w	$0000,$0093,$0000,$0090
	dc.w	$0000,$008D,$0000,$0089
	dc.w	$0000,$0086,$0000,$0083
	dc.w	$0000,$0080,$0000,$007D
	dc.w	$0000,$007A,$0000,$0077
	dc.w	$0000,$0074,$0000,$0070
	dc.w	$0000,$006D,$0000,$006A
	dc.w	$0000,$0067,$0000,$0064
	dc.w	$0000,$0061,$0000,$005E
	dc.w	$0000,$005C,$0000,$0059
	dc.w	$0000,$0056,$0000,$0053
	dc.w	$0000,$0050,$0000,$004D
	dc.w	$0000,$004B,$0000,$0048
	dc.w	$0000,$0045,$0000,$0043
	dc.w	$0000,$0040,$0000,$003E
	dc.w	$0000,$003B,$0000,$0039
	dc.w	$0000,$0036,$0000,$0034
	dc.w	$0000,$0031,$0000,$002F
	dc.w	$0000,$002D,$0000,$002B
	dc.w	$0000,$0029,$0000,$0026
	dc.w	$0000,$0024,$0000,$0022
	dc.w	$0000,$0020,$0000,$001E
	dc.w	$0000,$001D,$0000,$001B
	dc.w	$0000,$0019,$0000,$0017
	dc.w	$0000,$0016,$0000,$0014
	dc.w	$0000,$0013,$0000,$0011
	dc.w	$0000,$0010,$0000,$000E
	dc.w	$0000,$000D,$0000,$000C
	dc.w	$0000,$000A,$0000,$0009
	dc.w	$0000,$0008,$0000,$0007
	dc.w	$0000,$0006,$0000,$0005
	dc.w	$0000,$0005,$0000,$0004
	dc.w	$0000,$0003,$0000,$0002
	dc.w	$0000,$0002,$0000,$0001
	dc.w	$0000,$0001,$0000,$0001
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0001
	dc.w	$0000,$0001,$0000,$0002
	dc.w	$0000,$0002,$0000,$0003
	dc.w	$0000,$0004,$0000,$0004
	dc.w	$0000,$0005,$0000,$0006
	dc.w	$0000,$0007,$0000,$0008
	dc.w	$0000,$0009,$0000,$000A
	dc.w	$0000,$000B,$0000,$000D
	dc.w	$0000,$000E,$0000,$000F
	dc.w	$0000,$0011,$0000,$0012
	dc.w	$0000,$0014,$0000,$0015
	dc.w	$0000,$0017,$0000,$0019
	dc.w	$0000,$001A,$0000,$001C
	dc.w	$0000,$001E,$0000,$0020
	dc.w	$0000,$0022,$0000,$0024
	dc.w	$0000,$0026,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0029,$0000,$002C
	dc.w	$0000,$0030,$0000,$0038
	dc.w	$0000,$003C,$0000,$0046
	dc.w	$0000,$003C,$0000,$0038
	dc.w	$0000,$0030,$0000,$002C
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0028,$0000,$0029
	dc.w	$0000,$002C,$0000,$0030
	dc.w	$0000,$0038,$0000,$003C
	dc.w	$0000,$0046,$0000,$003C
	dc.w	$0000,$0038,$0000,$0030
	dc.w	$0000,$002C,$0000,$0029
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0029,$0000,$002C
	dc.w	$0000,$0030,$0000,$0038
	dc.w	$0000,$003C,$0000,$0046
	dc.w	$0000,$003C,$0000,$0038
	dc.w	$0000,$0030,$0000,$002C
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0028,$0000,$0029
	dc.w	$0000,$002C,$0000,$0030
	dc.w	$0000,$0038,$0000,$003C
	dc.w	$0000,$0046,$0000,$003C
	dc.w	$0000,$0038,$0000,$0030
	dc.w	$0000,$002C,$0000,$0029
	dc.w	$0000,$0028,$0000,$0028
	dc.w	$0000,$0029,$0000,$002A
	dc.w	$0000,$002B,$0000,$002D
	dc.w	$0000,$002E,$0000,$002F
	dc.w	$0000,$0031,$0000,$0032
	dc.w	$0000,$0033,$0000,$0034
	dc.w	$0000,$0036,$0000,$0037
	dc.w	$0000,$0038,$0000,$0039
	dc.w	$0000,$003B,$0000,$003C
	dc.w	$0000,$003D,$0000,$003E
	dc.w	$0000,$003F,$0000,$0040
	dc.w	$0000,$0041,$0000,$0042
	dc.w	$0000,$0043,$0000,$0044
	dc.w	$0000,$0045,$0000,$0046
	dc.w	$0000,$0047,$0000,$0047
	dc.w	$0000,$0048,$0000,$0049
	dc.w	$0000,$004A,$0000,$004A
	dc.w	$0000,$004B,$0000,$004C
	dc.w	$0000,$004C,$0000,$004D
	dc.w	$0000,$004D,$0000,$004E
	dc.w	$0000,$004E,$0000,$004E
	dc.w	$0000,$004F,$0000,$004F
	dc.w	$0000,$004F,$0000,$004F
	dc.w	$0000,$004F,$0000,$004F
	dc.w	$0000,$004F,$0000,$004F
	dc.w	$0000,$004F,$0000,$004F
	dc.w	$0000,$004F,$0000,$004F
	dc.w	$0000,$004F,$0000,$004F
	dc.w	$0000,$004E,$0000,$004E
	dc.w	$0000,$004E,$0000,$004D
	dc.w	$0000,$004D,$0000,$004C
	dc.w	$0000,$004C,$0000,$004B
	dc.w	$0000,$004A,$0000,$004A
	dc.w	$0000,$0049,$0000,$0048
	dc.w	$0000,$0048,$0000,$0047
	dc.w	$0000,$0046,$0000,$0045
	dc.w	$0000,$0044,$0000,$0043
	dc.w	$0000,$0042,$0000,$0041
	dc.w	$0000,$0040,$0000,$003F
	dc.w	$0000,$003E,$0000,$003D
	dc.w	$0000,$003C,$0000,$003B
	dc.w	$0000,$003A,$0000,$0038
	dc.w	$0000,$0037,$0000,$0036
	dc.w	$0000,$0035,$0000,$0033
	dc.w	$0000,$0032,$0000,$0031
	dc.w	$0000,$0030,$0000,$002E
	dc.w	$0000,$002D,$0000,$002C
	dc.w	$0000,$002A,$0000,$0029
	dc.w	$0000,$0028,$0000,$0026
	dc.w	$0000,$0025,$0000,$0024
	dc.w	$0000,$0022,$0000,$0021
	dc.w	$0000,$0020,$0000,$001F
	dc.w	$0000,$001D,$0000,$001C
	dc.w	$0000,$001B,$0000,$001A
	dc.w	$0000,$0018,$0000,$0017
	dc.w	$0000,$0016,$0000,$0015
	dc.w	$0000,$0014,$0000,$0012
	dc.w	$0000,$0011,$0000,$0010
	dc.w	$0000,$000F,$0000,$000E
	dc.w	$0000,$000D,$0000,$000C
	dc.w	$0000,$000B,$0000,$000A
	dc.w	$0000,$0009,$0000,$0009
	dc.w	$0000,$0008,$0000,$0007
	dc.w	$0000,$0006,$0000,$0005
	dc.w	$0000,$0005,$0000,$0004
	dc.w	$0000,$0004,$0000,$0003
	dc.w	$0000,$0002,$0000,$0002
	dc.w	$0000,$0002,$0000,$0001
	dc.w	$0000,$0001,$0000,$0001
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0001
	dc.w	$0000,$0001,$0000,$0001
	dc.w	$0000,$0002,$0000,$0002
	dc.w	$0000,$0003,$0000,$0003
	dc.w	$0000,$0004,$0000,$0004
	dc.w	$0000,$0005,$0000,$0006
	dc.w	$0000,$0007,$0000,$0007
	dc.w	$0000,$0008,$0000,$0009
	dc.w	$0000,$000A,$0000,$000B
	dc.w	$0000,$000C,$0000,$000D
	dc.w	$0000,$000E,$0000,$000F
	dc.w	$0000,$0010,$0000,$0011
	dc.w	$0000,$0012,$0000,$0013
	dc.w	$0000,$0014,$0000,$0015
	dc.w	$0000,$0016,$0000,$0018
	dc.w	$0000,$0019,$0000,$001A
	dc.w	$0000,$001B,$0000,$001D
	dc.w	$0000,$001E,$0000,$001F
	dc.w	$0000,$0020,$0000,$0022
	dc.w	$0000,$0023,$0000,$0024
	dc.w	$0000,$0026,$0000,$0027
	dc.w	$0000,$0028,$0000,$0029
	dc.w	$0000,$002A,$0000,$002B
	dc.w	$0000,$002D,$0000,$002E
	dc.w	$0000,$002F,$0000,$0031
	dc.w	$0000,$0032,$0000,$0033
	dc.w	$0000,$0034,$0000,$0036
	dc.w	$0000,$0037,$0000,$0038
	dc.w	$0000,$0039,$0000,$003B
	dc.w	$0000,$003C,$0000,$003D
	dc.w	$0000,$003E,$0000,$003F
	dc.w	$0000,$0040,$0000,$0041
	dc.w	$0000,$0042,$0000,$0043
	dc.w	$0000,$0044,$0000,$0045
	dc.w	$0000,$0046,$0000,$0047
	dc.w	$0000,$0047,$0000,$0048
	dc.w	$0000,$0049,$0000,$004A
	dc.w	$0000,$004A,$0000,$004B
	dc.w	$0000,$004C,$0000,$004C
	dc.w	$0000,$004D,$0000,$004D
	dc.w	$0000,$004E,$0000,$004E
	dc.w	$0000,$004E,$0000,$004F
	dc.w	$0000,$004F,$0000,$004F
	dc.w	$0000,$004F,$0000,$004F
	dc.w	$0000,$004F,$0000,$004F
	dc.w	$0000,$004F,$0000,$004F
	dc.w	$0000,$004F,$0000,$004F
	dc.w	$0000,$004F,$0000,$004F
	dc.w	$0000,$004F,$0000,$004E
	dc.w	$0000,$004E,$0000,$004E
	dc.w	$0000,$004D,$0000,$004D
	dc.w	$0000,$004C,$0000,$004C
	dc.w	$0000,$004B,$0000,$004A
	dc.w	$0000,$004A,$0000,$0049
	dc.w	$0000,$0048,$0000,$0048
	dc.w	$0000,$0047,$0000,$0046
	dc.w	$0000,$0045,$0000,$0044
	dc.w	$0000,$0043,$0000,$0042
	dc.w	$0000,$0041,$0000,$0040
	dc.w	$0000,$003F,$0000,$003E
	dc.w	$0000,$003D,$0000,$003C
	dc.w	$0000,$003B,$0000,$003A
	dc.w	$0000,$0038,$0000,$0037
	dc.w	$0000,$0036,$0000,$0035
	dc.w	$0000,$0033,$0000,$0032
	dc.w	$0000,$0031,$0000,$0030
	dc.w	$0000,$002E,$0000,$002D
	dc.w	$0000,$002C,$0000,$002A
	dc.w	$0000,$0029,$0000,$0028
	dc.w	$0000,$0026,$0000,$0025
	dc.w	$0000,$0024,$0000,$0022
	dc.w	$0000,$0021,$0000,$0020
	dc.w	$0000,$001F,$0000,$001D
	dc.w	$0000,$001C,$0000,$001B
	dc.w	$0000,$001A,$0000,$0018
	dc.w	$0000,$0017,$0000,$0016
	dc.w	$0000,$0015,$0000,$0014
	dc.w	$0000,$0012,$0000,$0011
	dc.w	$0000,$0010,$0000,$000F
	dc.w	$0000,$000E,$0000,$000D
	dc.w	$0000,$000C,$0000,$000B
	dc.w	$0000,$000A,$0000,$0009
	dc.w	$0000,$0009,$0000,$0008
	dc.w	$0000,$0007,$0000,$0006
	dc.w	$0000,$0005,$0000,$0005
	dc.w	$0000,$0004,$0000,$0004
	dc.w	$0000,$0003,$0000,$0002
	dc.w	$0000,$0002,$0000,$0002
	dc.w	$0000,$0001,$0000,$0001
	dc.w	$0000,$0001,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0001,$0000,$0001
	dc.w	$0000,$0001,$0000,$0002
	dc.w	$0000,$0002,$0000,$0003
	dc.w	$0000,$0003,$0000,$0004
	dc.w	$0000,$0004,$0000,$0005
	dc.w	$0000,$0006,$0000,$0007
	dc.w	$0000,$0007,$0000,$0008
	dc.w	$0000,$0009,$0000,$000A
	dc.w	$0000,$000B,$0000,$000C
	dc.w	$0000,$000D,$0000,$000E
	dc.w	$0000,$000F,$0000,$0010
	dc.w	$0000,$0011,$0000,$0012
	dc.w	$0000,$0013,$0000,$0014
	dc.w	$0000,$0015,$0000,$0016
	dc.w	$0000,$0018,$0000,$0019
	dc.w	$0000,$001A,$0000,$001B
	dc.w	$0000,$001D,$0000,$001E
	dc.w	$0000,$001F,$0000,$0020
	dc.w	$0000,$0022,$0000,$0023
	dc.w	$0000,$0024,$0000,$0026
	dc.w	$0000,$0027,$0000,$0028
	dc.w	$0000,$0028,$0000,$0026
	dc.w	$0000,$0029,$0000,$0024
	dc.w	$0000,$002A,$0000,$0022
	dc.w	$0000,$002B,$0000,$0020
	dc.w	$0000,$002D,$0000,$001E
	dc.w	$0000,$002E,$0000,$001C
	dc.w	$0000,$002F,$0000,$001A
	dc.w	$0000,$0031,$0000,$0018
	dc.w	$0000,$0032,$0000,$0016
	dc.w	$0000,$0033,$0000,$0014
	dc.w	$0000,$0034,$0000,$0012
	dc.w	$0000,$0036,$0000,$0010
	dc.w	$0000,$0037,$0000,$000E
	dc.w	$0000,$0038,$0000,$000C
	dc.w	$0000,$0039,$0000,$000A
	dc.w	$0000,$003B,$0000,$0008
	dc.w	$0000,$003C,$0000,$0006
	dc.w	$0000,$003D,$0000,$0004
	dc.w	$0000,$003E,$0000,$0002
	dc.w	$0000,$003F,$0000,$0000
	dc.w	$0000,$0040,$0000,$0000
	dc.w	$0000,$0041,$0000,$0000
	dc.w	$0000,$0042,$0000,$0000
	dc.w	$0000,$0043,$0000,$0000
	dc.w	$0000,$0044,$0000,$0000
	dc.w	$0000,$0045,$0000,$0000
	dc.w	$0000,$0046,$0000,$0000
	dc.w	$0000,$0047,$0000,$0000
	dc.w	$0000,$0047,$0000,$0000
	dc.w	$0000,$0048,$0000,$0000
	dc.w	$0000,$0049,$0000,$0000
	dc.w	$0000,$004A,$0000,$0000
	dc.w	$0000,$004A,$0000,$0000
	dc.w	$0000,$004B,$0000,$0000
	dc.w	$0000,$004C,$0000,$0000
	dc.w	$0000,$004C,$0000,$0000
	dc.w	$0000,$004D,$0000,$0000
	dc.w	$0000,$004D,$0000,$0000
	dc.w	$0000,$004E,$0000,$0000
	dc.w	$0000,$004E,$0000,$0000
	dc.w	$0000,$004E,$0000,$0000
	dc.w	$0000,$004F,$0000,$0000
	dc.w	$0000,$004F,$0000,$0000
	dc.w	$0000,$004F,$0000,$0000
	dc.w	$0000,$004F,$0000,$0000
	dc.w	$0000,$004F,$0000,$0000
	dc.w	$0000,$004F,$0000,$0000
	dc.w	$0000,$004F,$0000,$0000
	dc.w	$0000,$004F,$0000,$0000
	dc.w	$0000,$004F,$0000,$0000
	dc.w	$0000,$004F,$0000,$0000
	dc.w	$0000,$004F,$0000,$0000
	dc.w	$0000,$004F,$0000,$0000
	dc.w	$0000,$004F,$0000,$0000
	dc.w	$0000,$004F,$0000,$0000
	dc.w	$0000,$004E,$0000,$0000
	dc.w	$0000,$004E,$0000,$0000
	dc.w	$0000,$004E,$0000,$0000
	dc.w	$0000,$004D,$0000,$0000
	dc.w	$0000,$004D,$0000,$0000
	dc.w	$0000,$004C,$0000,$0000
	dc.w	$0000,$004C,$0000,$0000
	dc.w	$0000,$004B,$0000,$0000
	dc.w	$0000,$004A,$0000,$0000
	dc.w	$0000,$004A,$0000,$0000
	dc.w	$0000,$0049,$0000,$0000
	dc.w	$0000,$0048,$0000,$0000
	dc.w	$0000,$0048,$0000,$0000
	dc.w	$0000,$0047,$0000,$0000
	dc.w	$0000,$0046,$0000,$0000
	dc.w	$0000,$0045,$0000,$0000
	dc.w	$0000,$0044,$0000,$0000
	dc.w	$0000,$0043,$0000,$0000
	dc.w	$0000,$0042,$0000,$0000
	dc.w	$0000,$0041,$0000,$0000
	dc.w	$0000,$0040,$0000,$0000
	dc.w	$0000,$003F,$0000,$0000
	dc.w	$0000,$003E,$0000,$0000
	dc.w	$0000,$003D,$0000,$0000
	dc.w	$0000,$003C,$0000,$0000
	dc.w	$0000,$003B,$0000,$0000
	dc.w	$0000,$003A,$0000,$0000
	dc.w	$0000,$0038,$0000,$0000
	dc.w	$0000,$0037,$0000,$0000
	dc.w	$0000,$0036,$0000,$0000
	dc.w	$0000,$0035,$0000,$0000
	dc.w	$0000,$0033,$0000,$0000
	dc.w	$0000,$0032,$0000,$0000
	dc.w	$0000,$0031,$0000,$0000
	dc.w	$0000,$0030,$0000,$0000
	dc.w	$0000,$002E,$0000,$0000
	dc.w	$0000,$002D,$0000,$0000
	dc.w	$0000,$002C,$0000,$0000
	dc.w	$0000,$002A,$0000,$0000
	dc.w	$0000,$0029,$0000,$0000
	dc.w	$0000,$0028,$0000,$0000
	dc.w	$0000,$0026,$0000,$0000
	dc.w	$0000,$0025,$0000,$0000
	dc.w	$0000,$0024,$0000,$0000
	dc.w	$0000,$0022,$0000,$0000
	dc.w	$0000,$0021,$0000,$0000
	dc.w	$0000,$0020,$0000,$0000
	dc.w	$0000,$001F,$0000,$0000
	dc.w	$0000,$001D,$0000,$0000
	dc.w	$0000,$001C,$0000,$0000
	dc.w	$0000,$001B,$0000,$0000
	dc.w	$0000,$001A,$0000,$0000
	dc.w	$0000,$0018,$0000,$0000
	dc.w	$0000,$0017,$0000,$0000
	dc.w	$0000,$0016,$0000,$0000
	dc.w	$0000,$0015,$0000,$0000
	dc.w	$0000,$0014,$0000,$0000
	dc.w	$0000,$0012,$0000,$0000
	dc.w	$0000,$0011,$0000,$0000
	dc.w	$0000,$0010,$0000,$0000
	dc.w	$0000,$000F,$0000,$0000
	dc.w	$0000,$000E,$0000,$0000
	dc.w	$0000,$000D,$0000,$0000
	dc.w	$0000,$000C,$0000,$0000
	dc.w	$0000,$000B,$0000,$0000
	dc.w	$0000,$000A,$0000,$0000
	dc.w	$0000,$0009,$0000,$0000
	dc.w	$0000,$0009,$0000,$0000
	dc.w	$0000,$0008,$0000,$0000
	dc.w	$0000,$0007,$0000,$0000
	dc.w	$0000,$0006,$0000,$0000
	dc.w	$0000,$0005,$0000,$0000
	dc.w	$0000,$0005,$0000,$0000
	dc.w	$0000,$0004,$0000,$0000
	dc.w	$0000,$0004,$0000,$0000
	dc.w	$0000,$0003,$0000,$0000
	dc.w	$0000,$0002,$0000,$0000
	dc.w	$0000,$0002,$0000,$0000
	dc.w	$0000,$0002,$0000,$0000
	dc.w	$0000,$0001,$0000,$0000
	dc.w	$0000,$0001,$0000,$0000
	dc.w	$0000,$0001,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0001,$0000,$0000
	dc.w	$0000,$0001,$0000,$0000
	dc.w	$0000,$0001,$0000,$0000
	dc.w	$0000,$0002,$0000,$0000
	dc.w	$0000,$0002,$0000,$0000
	dc.w	$0000,$0003,$0000,$0000
	dc.w	$0000,$0003,$0000,$0000
	dc.w	$0000,$0004,$0000,$0000
	dc.w	$0000,$0004,$0000,$0000
	dc.w	$0000,$0005,$0000,$0000
	dc.w	$0000,$0006,$0000,$0000
	dc.w	$0000,$0007,$0000,$0000
	dc.w	$0000,$0007,$0000,$0000
	dc.w	$0000,$0008,$0000,$0000
	dc.w	$0000,$0009,$0000,$0000
	dc.w	$0000,$000A,$0000,$0000
	dc.w	$0000,$000B,$0000,$0000
	dc.w	$0000,$000C,$0000,$0000
	dc.w	$0000,$000D,$0000,$0000
	dc.w	$0000,$000E,$0000,$0000
	dc.w	$0000,$000F,$0000,$0001
	dc.w	$0000,$0010,$0000,$0003
	dc.w	$0000,$0011,$0000,$0005
	dc.w	$0000,$0012,$0000,$0007
	dc.w	$0000,$0013,$0000,$0009
	dc.w	$0000,$0014,$0000,$000B
	dc.w	$0000,$0015,$0000,$000D
	dc.w	$0000,$0016,$0000,$000F
	dc.w	$0000,$0018,$0000,$0011
	dc.w	$0000,$0019,$0000,$0013
	dc.w	$0000,$001A,$0000,$0015
	dc.w	$0000,$001B,$0000,$0017
	dc.w	$0000,$001D,$0000,$0019
	dc.w	$0000,$001E,$0000,$001B
	dc.w	$0000,$001F,$0000,$001D
	dc.w	$0000,$0020,$0000,$001F
	dc.w	$0000,$0022,$0000,$0021
	dc.w	$0000,$0023,$0000,$0023
	dc.w	$0000,$0024,$0000,$0025
	dc.w	$0000,$0026,$0000,$0027
	dc.w	$0000,$0027,$FFFF,$FFFF
	dc.w	$FFFF,$FFFF
BUFF_C0:DCB.W     640,$0 
BUFF_C1:DCB.W     640,$0 

********* LOGO DISTORT *******************************<<<

IMG_MENU:
		dc.w	$B55F,$C4DF,$FBDF,$0020,$87C1,$F800,$FFFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$F800,$0000,$FFFF,$0000
		dc.w	$0FF0,$0FF0,$F00F,$0000,$7C00,$0000,$FFFF,$0000
		dc.w	$F8C0,$0700,$FFFF,$0000,$3C1E,$001E,$FFE1,$0000
		dc.w	$8BFD,$8000,$7FFF,$0000,$02F1,$000F,$FFFF,$0000
		dc.w	$A617,$9817,$8017,$7FE8,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$CC2E,$DBE1,$D01F,$2000,$9262,$6DFF,$FFFF,$0000
		dc.w	$EA2F,$FFD0,$FFFF,$0000,$61C0,$81C0,$FE3F,$0000
		dc.w	$7EBF,$7E7F,$81FF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFDA,$FFD6,$FFD0,$002F
		dc.w	$61E8,$C1F7,$FE00,$7FFF,$B450,$4050,$0050,$FFAF
		dc.w	$0002,$0000,$0000,$FFFF,$1E01,$1FFE,$1FFF,$E000
		dc.w	$2878,$F800,$F800,$07FF,$3FFE,$3FFE,$3FFE,$C001
		dc.w	$D02E,$D001,$D000,$2FFF,$84DD,$7FFD,$0002,$FFFF
		dc.w	$1F38,$0E3F,$FFC0,$FFFF,$E0E3,$001F,$0000,$FFFF
		dc.w	$90F0,$80FF,$7F00,$FFFF,$7EF1,$800F,$0000,$FFFF
		dc.w	$6C28,$87D7,$0810,$F00F,$00EF,$FFFF,$0000,$FFFF
		dc.w	$83E0,$FC1F,$0000,$FFFF,$CE0F,$F00F,$000F,$FFF0
		dc.w	$F81E,$F800,$F800,$07FF,$1F83,$007F,$0000,$FFFF
		dc.w	$FC03,$FC00,$03FF,$FFFF,$FFFF,$1FFE,$FFFE,$FFFF
		dc.w	$E9E3,$4E1F,$CFFF,$7000,$1FBE,$E000,$FFFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFFA,$0000,$FFFF,$0000
		dc.w	$17FF,$17FF,$E800,$0000,$EA0C,$EA0C,$15F3,$0000
		dc.w	$4AEA,$0015,$FFFF,$0000,$A5D4,$5FFB,$FFFF,$0000
		dc.w	$9569,$6FE8,$FFE8,$0017,$FCAF,$008F,$008F,$FF70
		dc.w	$5AAA,$3D00,$0000,$FFFF,$5515,$5515,$5515,$AAEA
		dc.w	$5239,$43C7,$441F,$B800,$12A2,$FFFF,$FFFF,$0000
		dc.w	$A053,$FFAC,$FFFF,$0000,$6145,$0145,$FEBA,$0000
		dc.w	$FD5F,$7C4F,$83BF,$0000,$FEA8,$FEA8,$FEA8,$0157
		dc.w	$8AD6,$8001,$8000,$7FFF,$8A16,$700E,$0002,$FFFF
		dc.w	$5487,$1880,$DF7F,$6000,$1504,$0000,$FFFF,$0000
		dc.w	$45FF,$0000,$FFFF,$0000,$F9CD,$07F0,$FFFF,$0000
		dc.w	$0BED,$0BED,$F412,$0000,$5004,$5004,$AFFB,$0000
		dc.w	$1FF5,$000A,$FFFF,$0000,$42A1,$BFFE,$FFFF,$0000
		dc.w	$42FC,$BFFC,$FFFC,$0003,$B985,$0123,$017F,$FEC0
		dc.w	$29DC,$1E00,$0000,$FFFF,$2AAA,$2AAA,$2AAA,$D555
		dc.w	$AF3E,$A1D1,$A40F,$5800,$4848,$FFFF,$FFFF,$0000
		dc.w	$45EB,$FA14,$FFFF,$0000,$D28B,$028A,$FD75,$0000
		dc.w	$464F,$C687,$B9FF,$0000,$FFF5,$FFF5,$FFF5,$000A
		dc.w	$416D,$4000,$4000,$BFFF,$D44B,$2845,$0043,$FFBE
		dc.w	$2812,$3010,$FFEF,$4000,$0000,$0000,$FFFF,$0000
		dc.w	$0BFF,$0000,$FFFF,$0000,$DFFB,$3FFC,$FFFF,$0000
		dc.w	$857F,$057F,$FA80,$0000,$A014,$A014,$5FEB,$0000
		dc.w	$2FAA,$0055,$FFFF,$0000,$B453,$5FFC,$FFFF,$0000
		dc.w	$A5FE,$5FFE,$FFFE,$0001,$7916,$01CD,$017F,$FE80
		dc.w	$ABEE,$9C10,$8000,$7FFF,$1555,$1555,$1555,$EAAA
		dc.w	$5531,$54D0,$550F,$AA00,$0405,$FFFF,$FFFF,$0000
		dc.w	$2AF5,$F508,$FFFF,$0000,$A556,$0555,$FAAB,$0000
		dc.w	$6FC3,$5F67,$B0FF,$0000,$F6AA,$F6AA,$F6AA,$0955
		dc.w	$A820,$A800,$A800,$57FF,$BEA6,$00A1,$00A3,$FF5E
		dc.w	$D140,$E140,$3EBF,$4000,$8000,$8000,$7FFF,$0000
		dc.w	$47FF,$0000,$FFFF,$0000,$7FFD,$FFFE,$FFFF,$0000
		dc.w	$C0AC,$00AC,$FF53,$0000,$5400,$5400,$ABFF,$0000
		dc.w	$5F55,$00AA,$FFFF,$0000,$5AA5,$BFFA,$FFFF,$0000
		dc.w	$C375,$3FF5,$FFF5,$000A,$39AC,$0119,$017B,$FE84
		dc.w	$AD45,$9EB8,$8000,$7FFF,$2AAA,$2AAA,$2AAA,$D555
		dc.w	$AAAE,$AA5E,$AA81,$5500,$A120,$7FFF,$FFFF,$0000
		dc.w	$C5AB,$FA54,$FFFF,$0000,$4AA9,$0AAA,$F557,$0000
		dc.w	$FEB7,$BEE3,$617F,$0000,$FFFD,$FFFF,$FFFF,$0000
		dc.w	$556A,$D56A,$D56A,$2A95,$1757,$0054,$0057,$FFAA
		dc.w	$8A90,$EA90,$356F,$4000,$0200,$0000,$FFFF,$0000
		dc.w	$07FD,$0003,$FFFF,$0000,$FFFF,$FFFE,$FFFF,$0000
		dc.w	$8003,$0000,$FFFF,$0000,$3A11,$3A10,$C5EF,$0000
		dc.w	$36BA,$0145,$FFFF,$0000,$A7D2,$5FFD,$FFFF,$0000
		dc.w	$E1FA,$1FFA,$FFFA,$0005,$591E,$0155,$0173,$FE8C
		dc.w	$5A8E,$3F70,$0000,$FFFF,$0555,$0555,$0555,$FAAA
		dc.w	$55A5,$54DC,$5503,$AA00,$0412,$FFFF,$FFFF,$0000
		dc.w	$1354,$ECAE,$FFFF,$0000,$0559,$0557,$FAAE,$0000
		dc.w	$F679,$7633,$E9FF,$0000,$FF52,$FFFF,$FFFF,$0000
		dc.w	$8BC5,$FBC5,$FBC5,$043A,$0FB8,$0038,$003F,$FFC2
		dc.w	$3535,$4E35,$BFCA,$4000,$9144,$8010,$7FFF,$0000
		dc.w	$500F,$0FFF,$FFFF,$0000,$A5CB,$FA3F,$FFFF,$0000
		dc.w	$52F3,$D003,$D003,$2FFC,$FAF5,$19FF,$F800,$07FF
		dc.w	$5D4B,$A00B,$000B,$FFF4,$C3E9,$FFFE,$FFFF,$0000
		dc.w	$72D4,$8FF4,$FFF4,$000B,$BC7C,$00C3,$00FF,$FF00
		dc.w	$BD57,$7FE8,$0000,$FFFF,$52AA,$02AA,$02AA,$FD55
		dc.w	$AA25,$ABDC,$AB03,$5400,$B043,$C603,$C9FC,$3FFF
		dc.w	$D575,$FE80,$0000,$FFFF,$2E0F,$2FFF,$2FFF,$D000
		dc.w	$A5CB,$FA3F,$FFFF,$0000,$FFDF,$FFFF,$FFFF,$0000
		dc.w	$8800,$FFFF,$FFFF,$0000,$41A5,$BFB5,$FFBA,$0042
		dc.w	$EAF5,$1CFF,$B8FF,$4700,$F0A1,$FF5F,$FFFF,$0000
		dc.w	$7CFF,$FC00,$FC00,$03FF,$F38F,$0380,$0380,$FC7F
		dc.w	$8F42,$00BD,$0000,$FFFF,$B7FF,$4FFF,$0000,$FFFF
		dc.w	$5180,$51FF,$AE00,$FFFF,$7FFC,$8000,$0000,$FFFF
		dc.w	$E3E3,$E000,$E000,$1FFF,$D0AD,$2F53,$0000,$FFFF
		dc.w	$FFD4,$FFD4,$002B,$FFFF,$7CE3,$7FE3,$801C,$FFFF
		dc.w	$1825,$67DE,$8003,$FF80,$7ADF,$053F,$8000,$7FFF
		dc.w	$FD47,$FD47,$02B8,$FFFF,$CEFF,$FC00,$0000,$FFFF
		dc.w	$F38F,$0380,$0380,$FC7F,$7FD0,$8000,$0000,$FFFF
		dc.w	$BE80,$0000,$0000,$FFFF,$F759,$F0D5,$F03A,$0FE2
		dc.w	$7521,$11C1,$B1FE,$4E00,$0055,$0000,$FFFF,$0000
		dc.w	$D00A,$2FFF,$FFFF,$0000,$85D2,$FA2F,$FFFF,$0000
		dc.w	$AFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$82A1,$FFFE,$FFFF,$0000
		dc.w	$74AB,$8BFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FCA7,$FC58,$FC03,$0300,$6FFF,$6FFF,$EFFF,$1000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FE0A,$FFFF,$FFFF,$0000
		dc.w	$85D2,$FA2F,$FFFF,$0000,$FFFE,$FFFF,$FFFF,$0000
		dc.w	$B000,$FFFF,$FFFF,$0000,$7D7D,$80F5,$FFDA,$0022
		dc.w	$EACA,$1AF5,$BB00,$4400,$028E,$FFFE,$0001,$0000
		dc.w	$A0AD,$A000,$5FFF,$0000,$28AD,$00AD,$FF52,$0000
		dc.w	$5155,$5000,$AFFF,$0000,$4AA4,$0000,$FFFF,$0000
		dc.w	$BA05,$0000,$FFFF,$0000,$2B4A,$0000,$FFFF,$0000
		dc.w	$2B54,$2B54,$D4AB,$0000,$5552,$0000,$FFFF,$0000
		dc.w	$A92E,$0000,$FFFF,$0000,$815C,$0003,$FFFF,$0000
		dc.w	$8BA7,$7B58,$F803,$0400,$552A,$4000,$7FFF,$8000
		dc.w	$92E8,$0000,$FFFF,$0000,$14AD,$0000,$FFFF,$0000
		dc.w	$28AD,$00AD,$FF52,$0000,$55FE,$AA00,$FFFF,$0000
		dc.w	$A4AF,$0000,$FFFF,$0000,$1502,$15F7,$EAD8,$0022
		dc.w	$D4F5,$0F0A,$BE00,$4000,$5157,$AFFF,$0000,$0000
		dc.w	$F402,$F400,$0BFF,$0000,$807F,$007F,$FF80,$0000
		dc.w	$B802,$B800,$47FF,$0000,$B557,$0AA8,$FFFF,$0000
		dc.w	$D402,$2800,$FFFF,$0000,$80A0,$0000,$FFFF,$0000
		dc.w	$1FEE,$1FEE,$E011,$0000,$00AD,$0002,$FFFF,$0000
		dc.w	$55F5,$AA0A,$FFFF,$0000,$00BA,$0005,$FFFF,$0000
		dc.w	$71A6,$D35A,$F400,$0801,$EAD5,$802A,$FFFF,$0000
		dc.w	$5F50,$A0A0,$FFFF,$0000,$0A02,$0000,$FFFF,$0000
		dc.w	$817F,$007F,$FF80,$0000,$0AB5,$F540,$FFFF,$0000
		dc.w	$0000,$0000,$FFFF,$0000,$02C3,$03B7,$FDD8,$0022
		dc.w	$BA6A,$2595,$9E00,$4000,$FA8A,$057F,$0000,$0000
		dc.w	$BEA4,$FEA4,$015B,$0000,$7ABF,$0540,$FFFF,$0000
		dc.w	$E8A5,$175A,$FFFF,$0000,$FBAA,$0455,$FFFF,$0000
		dc.w	$FAA2,$055D,$FFFF,$0000,$A91E,$2901,$D6FF,$0000
		dc.w	$AFFA,$5005,$FFFF,$0000,$297E,$D681,$FFFF,$0000
		dc.w	$EABF,$1540,$FFFF,$0000,$FFFF,$0000,$FFFF,$0000
		dc.w	$57A6,$A55A,$F000,$0801,$B7EE,$C811,$FFFF,$0000
		dc.w	$ABFF,$5400,$FFFF,$0000,$FEA4,$00A4,$FF5B,$0000
		dc.w	$7ABF,$06C0,$FEFF,$0100,$FFFE,$0001,$FFFF,$0000
		dc.w	$A255,$5DAA,$FFFF,$0000,$493E,$070E,$FF51,$00A2
		dc.w	$0B10,$15E0,$BE00,$4000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0100,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0A37,$0607,$0258,$01A2
		dc.w	$BAE5,$34C3,$9F00,$4000,$9800,$E000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0100,$0000,$0000,$0000,$0000,$0000
		dc.w	$02AE,$0001,$0000,$0000,$A6A8,$C20A,$0255,$01A2
		dc.w	$16C8,$1CC5,$BF03,$4000,$59A0,$9E00,$E000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0100,$0000,$0100,$0000,$0003,$0000,$0000,$0000
		dc.w	$FA5B,$05F8,$0007,$0000,$1204,$A206,$C259,$01A2
		dc.w	$36D5,$3CCA,$9F07,$4000,$4800,$7000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0100,$0300,$0000,$0000,$0000,$0000,$0000
		dc.w	$000A,$0006,$0001,$0000,$A888,$500A,$E055,$03A2
		dc.w	$5A81,$5895,$FB4E,$0400,$4000,$8000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0200,$0100,$0380,$0000,$0000,$0000,$0000,$0000
		dc.w	$0002,$0001,$0000,$0000,$80B4,$A836,$7069,$0382
		dc.w	$F816,$FA1B,$5BCC,$0400,$8000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0280,$0300,$0780,$0000,$0000,$0000,$0000,$0000
		dc.w	$0001,$0000,$0000,$0000,$6AA2,$DA20,$327D,$0182
		dc.w	$7B89,$7892,$DB4C,$0400,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0680,$0080,$05C0,$0300,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$8937,$5834,$3069,$0382
		dc.w	$E85E,$FA04,$5BC8,$0400,$0000,$0000,$0002,$0001
		dc.w	$0000,$E070,$0904,$F0F8,$0000,$7803,$0200,$FC07
		dc.w	$0000,$C0C1,$1210,$E1E3,$0000,$F878,$0002,$FCFC
		dc.w	$1004,$1074,$390C,$38FC,$2000,$20E0,$7208,$71F1
		dc.w	$0000,$F000,$0400,$F800,$0000,$0FC7,$0000,$1FE7
		dc.w	$0082,$708A,$01C6,$71CE,$0100,$0107,$0390,$038F
		dc.w	$0000,$0EC7,$4000,$8ECF,$0000,$E000,$0000,$F000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$03C0,$0580,$07C0,$0300,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$72E3,$2A20,$127D,$0182
		dc.w	$7890,$7A04,$DBC8,$0400,$0000,$0001,$0000,$0003
		dc.w	$0000,$B0D8,$0000,$B9DC,$0000,$EC07,$0000,$EE07
		dc.w	$0000,$61A0,$0000,$73B0,$0000,$F0EC,$0000,$F0EE
		dc.w	$0000,$00D8,$4004,$39DC,$0000,$01B1,$8000,$73B9
		dc.w	$0000,$D800,$0000,$DC00,$0000,$0787,$0000,$0787
		dc.w	$0000,$700C,$0202,$71CE,$0000,$000D,$0400,$039D
		dc.w	$0000,$8EC3,$0000,$CEC3,$0000,$C000,$0000,$C000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$02C0,$02C0,$0BE0,$0700,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$012E,$282C,$1071,$0382
		dc.w	$B15C,$FA08,$5BC0,$0400,$0000,$0003,$0004,$0003
		dc.w	$0000,$B9C0,$0201,$B9C0,$0000,$EE07,$0008,$EE07
		dc.w	$0000,$73B0,$0409,$73B0,$0000,$F0EE,$0100,$F0EE
		dc.w	$0800,$2818,$9801,$781C,$1000,$5381,$3402,$F381
		dc.w	$0000,$DC00,$0000,$DC00,$0000,$0787,$0808,$0787
		dc.w	$0040,$714E,$84D0,$73CE,$0080,$029C,$09A0,$079C
		dc.w	$0000,$0EC3,$1024,$0EC3,$0000,$C000,$0000,$C000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0DA0,$0580,$0BA0,$0640,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1BC3,$3020,$007D,$0382
		dc.w	$70C8,$7A08,$DBC0,$0400,$0000,$0003,$0000,$0007
		dc.w	$0020,$B9A0,$0060,$BBE1,$0000,$EE07,$0000,$EE0F
		dc.w	$0000,$73B0,$0000,$77B9,$0000,$F0EE,$0000,$F1EE
		dc.w	$0000,$70F0,$0A04,$F9F9,$0040,$E341,$10C0,$F7C3
		dc.w	$0000,$DC00,$0000,$DC00,$0000,$0787,$0000,$0F8F
		dc.w	$0000,$738E,$0040,$F7DE,$0000,$071C,$0080,$0FBC
		dc.w	$0000,$0EC3,$0000,$1EE7,$0000,$C000,$0000,$C000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0380,$0500,$0920,$06C0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$3B0D,$102C,$0071,$0382
		dc.w	$D150,$DA08,$7BC0,$0400,$0000,$0003,$0004,$0007
		dc.w	$0000,$B9C0,$0201,$BBC1,$0000,$EC07,$0008,$EE0F
		dc.w	$0000,$63B8,$0401,$77B9,$0000,$F0EC,$0100,$F1EE
		dc.w	$0000,$7BC0,$8021,$FBC1,$0000,$F381,$0402,$F783
		dc.w	$0001,$D801,$0067,$DC1F,$8000,$8787,$8808,$8F8F
		dc.w	$0000,$F3CE,$0410,$F7DE,$0000,$079D,$0820,$0FBD
		dc.w	$4000,$4FE3,$D004,$DFE7,$0000,$C000,$0000,$C000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0A20,$0A20,$0280,$05C0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$02D5,$1034,$0069,$0382
		dc.w	$FE88,$F248,$5BC0,$0400,$0004,$0007,$0004,$0007
		dc.w	$0201,$BBDD,$0201,$BBDD,$0008,$F80F,$0208,$FC0F
		dc.w	$0401,$C7B9,$1441,$E7F9,$0100,$F1F8,$0102,$F1FC
		dc.w	$8201,$FBDD,$8201,$FBDD,$0402,$F7BB,$0402,$F7BB
		dc.w	$0000,$F000,$0400,$F800,$0808,$0F8F,$0808,$0F8F
		dc.w	$0410,$77DE,$0410,$F7DE,$0820,$EFBD,$0820,$EFBD
		dc.w	$1004,$9EE7,$5004,$DEE7,$0000,$C000,$0000,$C000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0280,$0280,$06C0,$0100,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0304,$1025,$0079,$0382
		dc.w	$CF50,$D248,$7BC0,$0400,$0004,$0005,$0006,$0007
		dc.w	$0201,$B2D9,$0301,$BBDD,$0008,$6C0B,$800C,$EE0F
		dc.w	$0401,$05B9,$0601,$07B9,$0100,$716C,$8180,$F1EE
		dc.w	$8201,$BAD9,$C301,$FBDD,$0402,$75B2,$8603,$F7BB
		dc.w	$0000,$D800,$0000,$DC00,$0808,$0B8B,$0C0C,$0F8F
		dc.w	$0410,$75D6,$8618,$77DE,$0820,$CBAD,$0C30,$EFBD
		dc.w	$1004,$96E5,$1806,$DEE7,$0000,$C000,$0000,$C000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0540,$0440,$0380,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1182,$0023,$007F,$0380
		dc.w	$9F80,$C248,$7BC0,$0400,$0006,$0006,$0007,$0007
		dc.w	$0301,$E371,$0B85,$F3F9,$800C,$AE0D,$C00E,$EE0F
		dc.w	$0601,$06B9,$0701,$07B9,$8180,$B1AE,$C1C0,$F1EE
		dc.w	$C301,$DB71,$E385,$FBF9,$8603,$B6E3,$C70B,$F7F3
		dc.w	$0000,$5C00,$8000,$DC00,$0C0C,$0D8D,$0E0E,$0F8F
		dc.w	$0618,$76DB,$071C,$77DF,$0C30,$8DB7,$2E38,$CFBF
		dc.w	$1806,$1AE6,$5C07,$9EE7,$0000,$C000,$0000,$C000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0380,$0380,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1327,$0026,$007B,$0380
		dc.w	$BF58,$E240,$5BC0,$0400,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0172,$0063,$003F,$0380
		dc.w	$97C0,$CA48,$7BC0,$0400,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1306,$0027,$007B,$0380
		dc.w	$B688,$EA40,$5BC0,$0400,$0000,$0000,$0002,$0001
		dc.w	$0000,$E060,$0908,$F0F0,$0010,$7850,$0230,$FC70
		dc.w	$0080,$0280,$0181,$0380,$0000,$70EE,$0400,$F8EE
		dc.w	$1000,$1070,$3904,$38F8,$0000,$0387,$0820,$07C7
		dc.w	$0000,$60C1,$0210,$61E1,$4020,$40A0,$C060,$C0E0
		dc.w	$0000,$1C1E,$4100,$3E3F,$0000,$0703,$9048,$0F87
		dc.w	$0000,$8000,$2000,$C000,$0200,$C21C,$0641,$EE3E
		dc.w	$0000,$0E0F,$2080,$1F1F,$0000,$0381,$4824,$87C3
		dc.w	$0080,$8281,$2180,$C381,$4000,$4000,$C000,$C000
		dc.w	$0000,$0000,$0000,$0000,$01D1,$0072,$002F,$0380
		dc.w	$8E48,$C240,$7BC0,$0400,$0000,$0001,$0000,$0003
		dc.w	$0000,$B0D0,$0000,$B9D8,$0000,$EC60,$0010,$EE70
		dc.w	$0000,$0300,$0080,$0381,$0000,$D8EE,$0000,$DCEE
		dc.w	$0000,$00D8,$4000,$39DC,$0000,$06C7,$0000,$0EE7
		dc.w	$0000,$61A1,$0000,$63B1,$0000,$80C0,$4020,$C0E0
		dc.w	$0000,$363B,$0000,$773B,$0000,$0D86,$0000,$9DCE
		dc.w	$0000,$C000,$0000,$E000,$0200,$EE36,$1200,$EE77
		dc.w	$0000,$1B1D,$0000,$3B9D,$0000,$86C3,$0000,$CEE7
		dc.w	$0000,$4301,$0080,$6381,$0000,$8000,$4000,$C000
		dc.w	$0000,$0000,$0000,$0000,$0348,$006B,$0037,$0380
		dc.w	$E488,$A240,$5BC0,$0400,$0000,$0003,$0004,$0003
		dc.w	$0000,$81D8,$0205,$81D8,$0000,$EE70,$0080,$EE70
		dc.w	$0000,$0381,$0402,$0381,$0000,$C0EE,$0110,$C0EE
		dc.w	$0800,$28C0,$9800,$79C0,$0000,$0E07,$1008,$0E07
		dc.w	$0000,$63B1,$140A,$63B1,$0000,$C0E0,$0100,$C0E0
		dc.w	$0000,$703B,$8040,$703B,$0000,$9C0E,$2010,$9C0E
		dc.w	$0000,$0000,$0001,$0000,$0000,$EC77,$0280,$FE77
		dc.w	$0000,$3B9D,$4020,$3B9D,$0000,$CE07,$1008,$CE07
		dc.w	$0000,$6381,$1402,$6381,$0000,$C000,$0000,$C000
		dc.w	$0000,$0000,$0000,$0000,$02F4,$0053,$002F,$0380
		dc.w	$F3C8,$B140,$4AC0,$0400,$0000,$0003,$0000,$0007
		dc.w	$0000,$81D8,$0000,$83DD,$0000,$EE70,$0000,$EEF0
		dc.w	$0000,$0381,$0000,$0783,$2000,$A0EE,$6000,$E1FE
		dc.w	$0000,$7070,$0904,$F8F8,$0000,$0E07,$0000,$1E0F
		dc.w	$0000,$63B1,$0000,$77BB,$0000,$C0E0,$0000,$C1E0
		dc.w	$0800,$683B,$1800,$F87B,$0001,$9C0D,$0003,$BC1F
		dc.w	$0000,$0000,$0000,$0001,$0000,$FC77,$0200,$FEF7
		dc.w	$0000,$3B9D,$0000,$7BBD,$0000,$CE07,$0000,$DE0F
		dc.w	$0000,$6381,$0000,$7783,$0000,$C000,$0000,$C000
		dc.w	$0000,$0000,$0000,$0000,$02F6,$0159,$002F,$0380
		dc.w	$F988,$B940,$42C0,$0400,$0000,$0003,$0004,$0007
		dc.w	$0800,$A9DC,$1A01,$BBDD,$0000,$EC70,$0080,$EEF0
		dc.w	$0000,$0381,$0402,$0783,$0000,$C0FE,$0100,$C1FE
		dc.w	$0000,$7818,$8000,$F81C,$0020,$0EA7,$1068,$1EEF
		dc.w	$0000,$F3B9,$0402,$F7BB,$0000,$C0E0,$0100,$C1E0
		dc.w	$0000,$703B,$8040,$F07B,$0040,$9D4E,$20D0,$BDDE
		dc.w	$0018,$0018,$0679,$01F9,$0000,$EE77,$0080,$FEF7
		dc.w	$0000,$3B9D,$4020,$7BBD,$0040,$CF47,$10C8,$DFCF
		dc.w	$0000,$7381,$0402,$7783,$0000,$C000,$0000,$C000
		dc.w	$0000,$0000,$0000,$0000,$0172,$00D9,$002F,$0380
		dc.w	$F9C8,$A940,$52C0,$0400,$0004,$0007,$0004,$0007
		dc.w	$0201,$B3DD,$0A21,$BBFD,$0080,$F8F7,$0280,$FCF7
		dc.w	$0402,$07BB,$0402,$07BB,$0100,$DDEE,$0100,$DDFE
		dc.w	$8040,$FB58,$80C4,$FBDC,$1008,$1ECF,$1028,$1EEF
		dc.w	$0402,$77BB,$0442,$77FB,$0100,$DDEE,$0100,$DDEE
		dc.w	$8040,$F77B,$8040,$F77B,$2010,$BD9E,$2050,$BDDE
		dc.w	$0001,$E001,$0001,$E001,$0080,$EEF7,$1080,$EEF7
		dc.w	$4020,$7BBD,$4020,$7BBD,$1008,$DE0F,$1008,$DE0F
		dc.w	$0402,$77BB,$8402,$F7BB,$0000,$DC00,$0000,$DC00
		dc.w	$0000,$0000,$0000,$0000,$02BE,$0111,$006F,$0380
		dc.w	$F888,$A940,$52C0,$0400,$0004,$0005,$0006,$0007
		dc.w	$0201,$B2DD,$0301,$BBDD,$0080,$6CB6,$80C0,$EEF7
		dc.w	$0402,$05B2,$0603,$07BB,$0100,$D96E,$0190,$DDEE
		dc.w	$8000,$B998,$C040,$FBDC,$1008,$16CB,$180C,$1EEF
		dc.w	$0402,$75BA,$0603,$77BB,$0100,$D96C,$0180,$DDEE
		dc.w	$8040,$B65B,$C060,$F77B,$2010,$AD96,$3018,$BDDE
		dc.w	$0001,$C001,$0001,$E001,$0080,$6EB6,$80C0,$EEF7
		dc.w	$4020,$5B2D,$6030,$7BBD,$1008,$D60B,$180C,$DE0F
		dc.w	$0402,$75B2,$0603,$77BB,$0000,$D800,$0000,$DC00
		dc.w	$0000,$0000,$0000,$0000,$0175,$00DB,$002F,$0380
		dc.w	$F040,$A1C0,$5AC0,$0400,$0006,$0006,$0007,$0007
		dc.w	$0301,$E35D,$0B81,$F3DD,$80C0,$AEDC,$C0E1,$EEFE
		dc.w	$0603,$06E3,$070B,$07F3,$0180,$71AE,$85C0,$F9EE
		dc.w	$C000,$D8F0,$E204,$F9F8,$180C,$1B8D,$1C2E,$1FCF
		dc.w	$0603,$76BB,$0703,$77BB,$0180,$71B8,$85C2,$F9FC
		dc.w	$C060,$DC6B,$E170,$FE7B,$3018,$B71B,$385C,$BF9F
		dc.w	$0001,$8001,$2001,$C001,$80C0,$AEDC,$C0E1,$EEFE
		dc.w	$6030,$6E35,$70B8,$7F3D,$180C,$DA0D,$1C0E,$DE0F
		dc.w	$0603,$76E3,$070B,$77F3,$0000,$7000,$8400,$F800
		dc.w	$0000,$0000,$0000,$0000,$029E,$0139,$006F,$0380
		dc.w	$EAC0,$A140,$5AC0,$0400,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0354,$00FB,$002F,$0380
		dc.w	$A840,$E1C0,$5AC0,$0400,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0298,$013F,$006F,$0380
		dc.w	$A380,$E940,$5AC0,$0400,$0000,$0000,$0002,$0001
		dc.w	$0000,$E1F8,$0800,$F3FC,$0000,$781C,$0241,$FC3E
		dc.w	$0000,$0E1F,$2080,$1F3F,$0000,$8038,$0082,$C07C
		dc.w	$1000,$1070,$3904,$38F8,$0000,$EC7E,$0000,$ECFF
		dc.w	$0000,$0E0F,$2080,$1F1F,$0002,$003A,$4086,$807E
		dc.w	$0000,$000F,$0000,$001F,$0000,$C770,$0001,$E771
		dc.w	$8201,$8A01,$C603,$CE03,$0000,$070E,$9040,$8F8E
		dc.w	$0000,$C7E0,$0000,$CFF0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0051,$03BF,$006F,$0380
		dc.w	$2140,$6BC0,$DAC0,$0400,$0000,$0001,$0000,$0003
		dc.w	$0000,$B0F0,$0000,$B8F0,$0000,$EC36,$0000,$EE77
		dc.w	$0000,$1B0F,$0000,$3B8F,$0000,$006C,$0000,$00EE
		dc.w	$0000,$00D8,$4000,$39DC,$0000,$EC3C,$0000,$EC3C
		dc.w	$0000,$1B1D,$0000,$3B9D,$0000,$806C,$0002,$C0EE
		dc.w	$0000,$0007,$0000,$0007,$0000,$8770,$0002,$8771
		dc.w	$0000,$0C00,$0204,$CE03,$0000,$0D8E,$0000,$9DCE
		dc.w	$0000,$C3C0,$0000,$C3C0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001A,$03BF,$006F,$0380
		dc.w	$2080,$6A40,$DBC0,$0400,$0000,$0001,$0000,$0003
		dc.w	$0000,$80F0,$0101,$80F0,$0000,$EE70,$0080,$EE70
		dc.w	$0000,$380F,$4010,$380F,$0000,$00E0,$0100,$00E0
		dc.w	$0800,$29C0,$9A01,$79C0,$0000,$EC3C,$0240,$EC3C
		dc.w	$0000,$381D,$4020,$381D,$0000,$C00C,$0000,$C00E
		dc.w	$0000,$0007,$0008,$0007,$0000,$8771,$0884,$8773
		dc.w	$4000,$4E02,$D009,$CE07,$8000,$9C0E,$A010,$9C0E
		dc.w	$0000,$C3C0,$2400,$C3C0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$003F,$03BF,$006F,$0380
		dc.w	$2440,$6AC0,$DBC0,$0400,$0000,$0000,$0002,$0001
		dc.w	$0000,$E0F0,$0800,$F1F1,$0008,$EE68,$0018,$EEF8
		dc.w	$0400,$340F,$0C00,$7C1F,$0000,$00E0,$0000,$01E0
		dc.w	$0000,$71C0,$0800,$FBC1,$0000,$EC3C,$0000,$EE7C
		dc.w	$0400,$341D,$0C00,$7C3D,$0000,$C078,$0102,$C0FC
		dc.w	$0000,$0007,$0000,$000F,$0000,$8773,$0000,$8FF7
		dc.w	$0000,$8E07,$4000,$DE0F,$0000,$1C0E,$8000,$BC1E
		dc.w	$0000,$C3C0,$0000,$E7C0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$002A,$03AF,$007F,$0380
		dc.w	$8C00,$4AC0,$FBC0,$0400,$0000,$0000,$0000,$0000
		dc.w	$0000,$30F0,$0101,$39F1,$0000,$EC70,$0080,$EEF0
		dc.w	$0000,$380F,$4010,$781F,$0004,$00F4,$010C,$01FC
		dc.w	$0004,$79D4,$820D,$FBDD,$0000,$FE3C,$0040,$FE7C
		dc.w	$0000,$381D,$4020,$783D,$0000,$81E0,$0010,$C1E0
		dc.w	$0180,$0187,$6788,$1F8F,$0000,$87F3,$0804,$8FF7
		dc.w	$0000,$CE07,$1008,$DE0F,$0040,$9D4F,$20D0,$BDDF
		dc.w	$0000,$E3C0,$0400,$E7C0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00EF,$03AF,$007F,$0380
		dc.w	$8540,$4BC0,$FAC0,$0400,$0000,$0006,$0001,$0007
		dc.w	$8101,$B1F1,$8901,$B9F1,$0080,$F8F7,$0280,$FCF7
		dc.w	$4010,$7B9F,$4010,$7B9F,$0100,$01E0,$0100,$01E0
		dc.w	$8201,$FBD9,$8205,$FBDD,$0040,$EE7C,$0040,$EE7C
		dc.w	$4020,$7BBF,$4020,$7BBF,$0100,$01EE,$4100,$81EE
		dc.w	$0008,$000F,$0008,$000F,$0804,$8F77,$0804,$8FF7
		dc.w	$1008,$DEEF,$1008,$DEEF,$2010,$BD9E,$2050,$BDDE
		dc.w	$0400,$E7C0,$0400,$E7C0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$008F,$03AF,$007F,$0380
		dc.w	$8FC0,$4BC0,$FAC0,$0400,$0000,$0003,$0000,$0007
		dc.w	$0101,$3171,$8181,$B9F1,$0080,$6CB6,$80C0,$EEF7
		dc.w	$4010,$5B17,$6018,$7B9F,$0100,$0160,$0180,$01E0
		dc.w	$8201,$BAD9,$C301,$FBDD,$0040,$6E5C,$8060,$EE7C
		dc.w	$4020,$5B2D,$6030,$7BBD,$0100,$816C,$0180,$C1EE
		dc.w	$0008,$000B,$000C,$000F,$0804,$8B75,$0C86,$8F77
		dc.w	$1008,$D6CB,$180C,$DEEF,$2010,$AD96,$3018,$BDDE
		dc.w	$0400,$E5C0,$0600,$E7C0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$024C,$03AD,$007D,$0382
		dc.w	$8740,$4BC0,$FAC0,$0400,$0000,$0001,$0004,$0003
		dc.w	$0181,$E1B1,$09C1,$F1F1,$80C0,$AEDC,$C0E1,$EEFE
		dc.w	$6018,$6E1B,$709C,$7F1F,$0180,$01A0,$01C0,$01E0
		dc.w	$C301,$DB71,$E385,$FBF9,$8060,$AE6C,$C070,$EE7C
		dc.w	$6030,$6E35,$70B8,$7F3D,$0180,$C1B8,$01C2,$C1FC
		dc.w	$000C,$000D,$000E,$000F,$0C06,$8D76,$0E07,$8F77
		dc.w	$180C,$DB8D,$1C2E,$DFCF,$3018,$B71A,$385C,$BF9E
		dc.w	$0600,$E6C0,$0700,$E7C0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00C9,$03AD,$007D,$0382
		dc.w	$2F00,$4B80,$FA80,$0440,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$028D,$03AD,$007D,$0382
		dc.w	$0E40,$4AC0,$FBC0,$0400,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$02CC,$03AD,$007D,$0382
		dc.w	$2080,$6A40,$DBC0,$0400,$0000,$0001,$0000,$0003
		dc.w	$0000,$E070,$0904,$F0F8,$0000,$7877,$0200,$FC77
		dc.w	$0800,$2807,$1810,$380F,$0000,$0EE1,$4004,$8EE3
		dc.w	$0000,$C00E,$1021,$E01F,$8000,$8003,$8000,$8003
		dc.w	$0800,$0870,$1904,$B8F8,$0000,$383C,$8201,$7C7E
		dc.w	$0000,$0E06,$2090,$1F0F,$0201,$0A05,$8603,$0E07
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$03AD,$038D,$007D,$0382
		dc.w	$2440,$6AC0,$DBC0,$0400,$0000,$0003,$0000,$0003
		dc.w	$0000,$B0D8,$0000,$B9DC,$0000,$EC77,$0000,$EE77
		dc.w	$0000,$300D,$0800,$381D,$0000,$8EE3,$0000,$CEE7
		dc.w	$0000,$601B,$0000,$703B,$0000,$0003,$8000,$8003
		dc.w	$0800,$B8D8,$4800,$B9DC,$0000,$6C76,$0000,$EE77
		dc.w	$0000,$1B0D,$0000,$3B9D,$0000,$0C06,$0201,$8E07
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$02AD,$038D,$007D,$0382
		dc.w	$8C00,$4AC0,$FBC0,$0400,$0000,$0003,$0004,$0003
		dc.w	$0000,$B9DC,$0201,$B9DC,$0000,$EE77,$0080,$EE77
		dc.w	$0000,$381D,$4020,$381D,$0000,$CEE3,$1000,$CEE7
		dc.w	$0000,$0003,$0000,$0003,$0000,$0003,$0004,$8003
		dc.w	$0000,$B1DC,$0A01,$F9DC,$0000,$EE77,$0080,$EE77
		dc.w	$0000,$381D,$4020,$381D,$0000,$8E07,$5008,$8E07
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$002A,$03AF,$007F,$0380
		dc.w	$8540,$4BC0,$FAC0,$0400,$0000,$0003,$0000,$0007
		dc.w	$0000,$B9DC,$0000,$BBDD,$0000,$EE77,$0000,$EEF7
		dc.w	$0000,$381D,$0000,$783D,$0000,$CEE1,$0004,$DEE3
		dc.w	$0000,$C01E,$1040,$E03F,$0000,$0003,$8000,$0007
		dc.w	$0000,$F1DC,$0800,$FBDD,$0000,$EE77,$0000,$EEF7
		dc.w	$0000,$381D,$0000,$783D,$0000,$8E07,$0000,$DE0F
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00EF,$03AF,$007F,$0380
		dc.w	$8FC0,$4BC0,$FAC0,$0400,$0000,$0003,$0004,$0007
		dc.w	$0000,$B1DC,$0201,$BBDD,$0000,$EC77,$0080,$EEF7
		dc.w	$0000,$381D,$4020,$783D,$0000,$CEE0,$1000,$DEE0
		dc.w	$0000,$6078,$0004,$7078,$0060,$0063,$19E4,$07E7
		dc.w	$0000,$B9DC,$0201,$FBDD,$0000,$EE77,$0080,$EEF7
		dc.w	$0100,$3D1D,$4320,$7F3D,$0000,$CE07,$1008,$DE0F
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$008F,$03AF,$007F,$0380
		dc.w	$8740,$4BC0,$FAC0,$0400,$0004,$0007,$0004,$0007
		dc.w	$0201,$E3DD,$0A01,$F3DD,$0080,$F8F7,$0280,$FCF7
		dc.w	$4020,$7BBD,$4020,$7BBD,$1001,$DEED,$1003,$DEEF
		dc.w	$0040,$607B,$1040,$707B,$0004,$8007,$0004,$8007
		dc.w	$0201,$BBDD,$4201,$BBDD,$0080,$EEF7,$0080,$EEF7
		dc.w	$4020,$783D,$4022,$783F,$1008,$DEEF,$1008,$DEEF
		dc.w	$0000,$7000,$0000,$7000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$024C,$03AD,$007D,$0382
		dc.w	$2F00,$4B80,$FA80,$0440,$0004,$0005,$0006,$0007
		dc.w	$0201,$82D9,$0301,$83DD,$0080,$60B6,$80C0,$E0F7
		dc.w	$4020,$5B2D,$6030,$7BBD,$1000,$96C6,$1801,$DEEF
		dc.w	$0040,$605B,$0060,$707B,$0004,$0005,$0006,$8007
		dc.w	$0201,$BAD9,$0301,$BBDD,$0080,$6CB7,$80C0,$EEF7
		dc.w	$4020,$582D,$6030,$783D,$1008,$D6CB,$180C,$DEEF
		dc.w	$0000,$6000,$0000,$7000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00C9,$03AD,$007D,$0382
		dc.w	$0E40,$4AC0,$FBC0,$0400,$0006,$0006,$0007,$0007
		dc.w	$0301,$8371,$0385,$83F9,$8040,$A05C,$C061,$E07E
		dc.w	$6030,$6E37,$70B8,$7F3F,$0800,$0B83,$4C28,$8FC7
		dc.w	$0060,$C06E,$1070,$E07F,$0006,$0006,$8007,$0007
		dc.w	$0301,$BB71,$0385,$BBF9,$80C0,$B8D7,$C2E0,$FCF7
		dc.w	$6030,$6835,$7038,$783D,$180C,$DB8D,$1C2E,$DFCF
		dc.w	$0000,$C000,$1000,$E000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$028D,$03AD,$007D,$0382
		dc.w	$2A80,$4E40,$FBC0,$0400,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$02CC,$03AD,$007D,$0382
		dc.w	$A180,$C540,$70C0,$0E00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$03AD,$038D,$007D,$0382
		dc.w	$B100,$C540,$70C0,$0E00,$0000,$0000,$0002,$0001
		dc.w	$0040,$E047,$08E0,$F0E7,$0082,$708A,$01C6,$71CE
		dc.w	$0100,$0107,$0390,$038F,$0000,$0307,$4840,$878F
		dc.w	$0080,$E083,$01C8,$F1C7,$0000,$83C0,$2010,$C7E0
		dc.w	$0001,$0061,$0003,$0077,$0000,$0E07,$2090,$1F0F
		dc.w	$0000,$0781,$4024,$8FC3,$0000,$C0C1,$1210,$E1E1
		dc.w	$4020,$40A0,$C060,$C0E0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$02AD,$038D,$007D,$0382
		dc.w	$BA40,$CD00,$78C0,$0600,$0000,$0001,$0000,$0003
		dc.w	$0000,$B007,$0100,$B8E7,$0000,$700C,$0202,$71CE
		dc.w	$0000,$000D,$0400,$039D,$0000,$8683,$0000,$CEC3
		dc.w	$0000,$C006,$0200,$C1CE,$0000,$C760,$0000,$E770
		dc.w	$0001,$0077,$0009,$0077,$0000,$1B0D,$0000,$3B9D
		dc.w	$0000,$8EC3,$0000,$CEE7,$0000,$61A1,$0000,$73B1
		dc.w	$0000,$80C0,$4020,$C0E0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$03BD,$039D,$006D,$0382
		dc.w	$1080,$E580,$7040,$0E00,$0000,$0003,$0004,$0003
		dc.w	$0020,$80A7,$0268,$81E7,$0040,$714E,$04D0,$73CE
		dc.w	$0080,$028C,$0980,$079C,$0000,$0EC3,$1024,$0EC3
		dc.w	$0040,$C14E,$04D0,$C3CE,$0000,$E770,$0800,$E770
		dc.w	$0000,$0076,$0081,$007F,$0000,$3B9D,$4020,$3B9D
		dc.w	$0000,$CEE7,$1008,$CEE7,$0000,$03B1,$040A,$03B1
		dc.w	$0000,$C0E0,$0100,$C0E0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$01DD,$03FD,$002D,$0382
		dc.w	$02C0,$E580,$7040,$0E00,$0000,$0003,$0000,$0007
		dc.w	$0000,$81C7,$0020,$83EF,$0000,$738E,$0040,$77DE
		dc.w	$0000,$0707,$0090,$0F8F,$0000,$0EC3,$4000,$9EE7
		dc.w	$0000,$C38E,$0040,$C7DE,$0000,$E770,$0000,$EF70
		dc.w	$0000,$007E,$0001,$00FF,$0000,$3B9D,$0000,$7BBD
		dc.w	$0000,$CEE7,$0000,$DEEF,$0000,$03B1,$0000,$07BB
		dc.w	$0000,$C0E0,$0000,$C1E0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0297,$03BD,$006D,$0382
		dc.w	$0840,$ED00,$78C0,$0600,$0000,$0003,$0004,$0007
		dc.w	$0800,$A9E7,$1A08,$BBEF,$0000,$73CE,$0410,$77DE
		dc.w	$0000,$0781,$0800,$0F81,$0000,$8EE3,$1004,$DEE7
		dc.w	$0000,$C3CE,$0410,$C7DE,$0000,$E770,$0803,$EF70
		dc.w	$0C00,$0C77,$3C80,$FCFF,$0000,$3B9D,$4020,$7BBD
		dc.w	$0000,$CEE7,$1008,$DEEF,$2000,$A3B9,$6402,$E7BB
		dc.w	$0000,$C0E0,$0100,$C1E0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$035F,$03FD,$002D,$0382
		dc.w	$5300,$B540,$60C0,$0E00,$0004,$0007,$0004,$0007
		dc.w	$0208,$B3EF,$0A08,$BBEF,$0410,$67DE,$0410,$77DE
		dc.w	$0804,$EFB5,$080C,$EFBD,$1004,$9EE7,$5104,$DFE7
		dc.w	$0410,$C7DE,$0410,$C7DE,$0800,$EF70,$0800,$EF70
		dc.w	$0080,$00F7,$0088,$00F7,$4020,$7BBD,$4020,$7BBD
		dc.w	$1008,$DEEF,$1008,$DEEF,$0402,$07BB,$0442,$07FB
		dc.w	$0100,$DDEE,$0100,$DDEE,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0397,$03BD,$006D,$0382
		dc.w	$5980,$BD40,$68C0,$0600,$0004,$0005,$0006,$0007
		dc.w	$0208,$B2EB,$030C,$BBEF,$0410,$45D6,$1618,$67DE
		dc.w	$0800,$CB99,$0C04,$EFBD,$1004,$96E5,$1806,$DEE7
		dc.w	$0410,$C5D6,$0618,$C7DE,$0800,$CB70,$0C00,$EF70
		dc.w	$0080,$00B7,$00C0,$00F7,$4020,$5B2D,$6030,$7BBD
		dc.w	$1008,$96EB,$180C,$DEEF,$0402,$05BA,$0603,$07BB
		dc.w	$0100,$D96C,$0180,$DDEE,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0173,$03DD,$002D,$0382
		dc.w	$D2C0,$3440,$61C0,$0E00,$0006,$0006,$0007,$0007
		dc.w	$030C,$E36D,$0B8E,$F3EF,$0618,$86DB,$271C,$C7DF
		dc.w	$0C00,$8D8F,$2E20,$CF9F,$1806,$1AE6,$5C07,$9EE7
		dc.w	$0618,$C6DB,$071C,$C7DF,$0C00,$8D70,$2E00,$CF70
		dc.w	$00C0,$00D7,$00E0,$00F7,$6030,$6E37,$70B8,$7F3F
		dc.w	$180C,$1AED,$5C0E,$9EEF,$0603,$06BB,$0703,$07BB
		dc.w	$0180,$71B8,$85C2,$F9FC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00A3,$039D,$006D,$0382
		dc.w	$AB40,$2CC0,$79C0,$0600,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0163,$039D,$006D,$0382
		dc.w	$A340,$24C0,$71C0,$0E00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0033,$039D,$006D,$0382
		dc.w	$AD40,$28C0,$79C0,$0600,$0000,$0000,$0002,$0001
		dc.w	$0000,$E1D8,$0800,$F1D8,$0000,$301C,$8441,$783E
		dc.w	$0000,$0E00,$2081,$1F00,$0000,$7078,$0402,$F8FC
		dc.w	$0008,$1C08,$411C,$3E1C,$0000,$781C,$0241,$FC3E
		dc.w	$0000,$0006,$0000,$0007,$1000,$10E0,$3209,$71F0
		dc.w	$0000,$7078,$0402,$F8FC,$0000,$1C0C,$4121,$3E1E
		dc.w	$0402,$140A,$0C06,$1C0E,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$015B,$0395,$006D,$0382
		dc.w	$AB40,$2CC0,$79C0,$0600,$0000,$0001,$0000,$0003
		dc.w	$0000,$B1D8,$0000,$B9D8,$0000,$6836,$0000,$EC77
		dc.w	$0000,$1B00,$0000,$3B81,$0000,$D8EC,$0000,$DCEE
		dc.w	$0000,$3600,$0020,$771C,$0000,$EC36,$0000,$EE77
		dc.w	$0000,$0007,$0000,$0007,$1000,$71B0,$9000,$73B9
		dc.w	$0000,$D8EC,$0000,$DCEE,$0000,$361A,$0000,$773B
		dc.w	$0000,$180C,$0402,$1C0E,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$007D,$0391,$006D,$0382
		dc.w	$BFC0,$38C0,$69C0,$0600,$0000,$0003,$0004,$0003
		dc.w	$0000,$81D8,$0205,$81D8,$0000,$EC77,$0280,$EC77
		dc.w	$0000,$1801,$0002,$3801,$0000,$C0EE,$0100,$C0EE
		dc.w	$0004,$7014,$804D,$703C,$0000,$EE70,$0080,$EE70
		dc.w	$0000,$0007,$0008,$0007,$0000,$63B9,$1402,$F3B9
		dc.w	$0000,$DCEE,$0100,$DCEE,$0000,$703B,$8040,$703B
		dc.w	$0000,$1C0E,$A010,$1C0E,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0049,$0385,$007D,$0382
		dc.w	$1BC0,$BCC0,$69C0,$0600,$0000,$0003,$0000,$0007
		dc.w	$0000,$81D8,$0000,$83DD,$0000,$EC77,$0000,$EEF7
		dc.w	$0000,$0E01,$2080,$1F03,$2000,$A0EE,$6000,$E1EE
		dc.w	$0000,$7038,$0004,$F07D,$0008,$EE68,$0018,$EEF8
		dc.w	$0000,$0007,$0000,$000F,$0000,$E3B9,$1000,$F7BB
		dc.w	$0000,$DCEE,$0000,$DDEE,$0000,$703B,$0000,$F07B
		dc.w	$0000,$1C0E,$0000,$BC1E,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$006D,$0381,$007D,$0382
		dc.w	$1540,$B9C0,$69C0,$0600,$0000,$0003,$0004,$0007
		dc.w	$0800,$A9FC,$1A01,$BBFD,$0000,$EE77,$0080,$EEF7
		dc.w	$0000,$0301,$0002,$0383,$0000,$C0EE,$0100,$C1EE
		dc.w	$0100,$753C,$8341,$F77D,$0000,$EE70,$0080,$EEF0
		dc.w	$00C0,$00C7,$33C8,$0FCF,$0000,$73B9,$0402,$F7BB
		dc.w	$0000,$DCEE,$0100,$DDEE,$0200,$7A3B,$8640,$FE7B
		dc.w	$0000,$9C0E,$2010,$BC1E,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$004D,$03A1,$007D,$0382
		dc.w	$5A80,$BDC0,$69C0,$0600,$0004,$0007,$0004,$0007
		dc.w	$0201,$B3DD,$0A01,$BBDD,$0080,$EEF7,$1080,$FEF7
		dc.w	$0802,$6B03,$1882,$7B83,$0100,$DDEE,$0100,$DDEE
		dc.w	$8041,$F67D,$8141,$F77D,$0080,$EEF7,$0080,$EEF7
		dc.w	$0008,$000F,$0008,$000F,$0402,$77BB,$8402,$77BB
		dc.w	$0100,$DDEE,$0100,$DDEE,$8040,$F07B,$8044,$F07F
		dc.w	$2010,$BDDE,$2010,$BDDE,$0000,$E000,$0000,$E000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001F,$03E1,$007D,$0382
		dc.w	$5540,$B9C0,$69C0,$0600,$0004,$0005,$0006,$0007
		dc.w	$0201,$B2DD,$0301,$BBDD,$0080,$6EB6,$80C0,$EEF7
		dc.w	$0002,$3302,$0803,$7B83,$0100,$D96E,$0180,$DDEE
		dc.w	$8041,$B65D,$C061,$F77D,$0080,$6EB6,$80C0,$EEF7
		dc.w	$0008,$000B,$000C,$000F,$0402,$75B2,$0603,$77BB
		dc.w	$0100,$D96E,$0180,$DDEE,$8040,$B05B,$C060,$F07B
		dc.w	$2010,$AD96,$3018,$BDDE,$0000,$C000,$0000,$E000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$005B,$03A5,$007D,$0382
		dc.w	$5A80,$BDC0,$69C0,$0600,$0006,$0006,$0007,$0007
		dc.w	$0301,$E35D,$0B81,$F3DD,$80C0,$AEDC,$C0E1,$EEFE
		dc.w	$0003,$1E03,$4083,$3F03,$0180,$71AE,$85C0,$F9EE
		dc.w	$C061,$DC6D,$E171,$FE7D,$80C0,$AEDC,$C0E1,$EEFE
		dc.w	$000C,$000D,$000E,$000F,$0603,$76E3,$070B,$77F3
		dc.w	$0180,$71AE,$85C0,$F9EE,$C060,$D06B,$E070,$F07B
		dc.w	$3018,$B71B,$385C,$BF9F,$0000,$8000,$2000,$C000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$000F,$03F1,$007D,$0382
		dc.w	$0600,$99C0,$79C0,$0600,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001B,$03E5,$007D,$0382
		dc.w	$4A40,$9D80,$79C0,$0600,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0137,$03E9,$007D,$0382
		dc.w	$1600,$89C0,$79C0,$0600,$0000,$0000,$0002,$0001
		dc.w	$0040,$E047,$08E0,$F0E7,$0082,$708A,$01C6,$71CE
		dc.w	$0100,$0107,$0390,$038F,$0000,$0307,$4840,$878F
		dc.w	$0080,$E083,$01C8,$F1C7,$0000,$83C0,$2010,$C7E0
		dc.w	$0004,$0E04,$208E,$1F0E,$0000,$7700,$0002,$7701
		dc.w	$0000,$E060,$0908,$F0F0,$2000,$A01C,$6041,$E03E
		dc.w	$0000,$0E0F,$2080,$1F1F,$0000,$0001,$4000,$8001
		dc.w	$0400,$8438,$0C82,$DC7C,$0000,$1C1E,$4100,$3E3F
		dc.w	$0000,$0703,$9048,$0F87,$0100,$0502,$4301,$8703
		dc.w	$8000,$8000,$8000,$8000,$007B,$03A5,$007D,$0382
		dc.w	$BB00,$2CC0,$59C0,$0600,$0000,$0001,$0000,$0003
		dc.w	$0000,$B007,$0100,$B8E7,$0000,$700C,$0202,$71CE
		dc.w	$0000,$000D,$0400,$039D,$0000,$8683,$0000,$CEC3
		dc.w	$0000,$C006,$0200,$C1CE,$0000,$C760,$0000,$E770
		dc.w	$0000,$1B00,$0010,$3B8E,$0000,$7701,$0000,$7703
		dc.w	$0000,$B0D0,$0000,$B9D8,$0000,$C036,$2000,$E077
		dc.w	$0000,$1B1D,$0000,$3B9D,$0000,$8001,$0000,$C001
		dc.w	$0400,$DC6C,$2400,$DCEE,$0000,$363B,$0000,$773B
		dc.w	$0000,$0D86,$0000,$9DCE,$0000,$8603,$0100,$C703
		dc.w	$0000,$0000,$8000,$8000,$0031,$03EF,$007D,$0382
		dc.w	$BE40,$2980,$59C0,$0600,$0000,$0003,$0004,$0003
		dc.w	$0020,$80A7,$0268,$81E7,$0040,$714E,$04D0,$73CE
		dc.w	$0080,$028C,$0980,$079C,$0000,$0EC3,$1024,$0EC3
		dc.w	$0040,$C14E,$04D0,$C3CE,$0000,$E770,$0800,$E770
		dc.w	$0002,$380A,$4026,$381E,$0000,$7603,$8004,$7703
		dc.w	$0000,$81D8,$0205,$81D8,$0000,$E070,$0080,$E070
		dc.w	$0000,$3B9D,$4020,$3B9D,$0000,$C001,$0002,$C001
		dc.w	$0000,$D8EE,$0500,$FCEE,$0000,$773B,$8040,$773B
		dc.w	$0000,$9C0E,$2010,$9C0E,$0000,$C703,$2804,$C703
		dc.w	$0000,$8000,$0000,$8000,$0035,$03EB,$007D,$0382
		dc.w	$9200,$25C0,$51C0,$0E00,$0000,$0003,$0000,$0007
		dc.w	$0000,$81C7,$0020,$83EF,$0000,$738E,$0040,$77DE
		dc.w	$0000,$0707,$0090,$0F8F,$0000,$0EC3,$4000,$9EE7
		dc.w	$0000,$C38E,$0040,$C7DE,$0000,$E770,$0000,$EF70
		dc.w	$0000,$381C,$0002,$783E,$0000,$3C03,$4100,$FE07
		dc.w	$0000,$81D8,$0000,$83DD,$0000,$E070,$0000,$E0F0
		dc.w	$0000,$3B9D,$0000,$7BBD,$0000,$C001,$0000,$C003
		dc.w	$0000,$F8EE,$0400,$FDEE,$0000,$773B,$0000,$F77B
		dc.w	$0000,$9C0E,$0000,$BC1E,$0000,$C703,$0000,$EF07
		dc.w	$0000,$8000,$0000,$8000,$0165,$03FF,$007D,$0382
		dc.w	$2F40,$1880,$79C0,$0600,$0000,$0003,$0004,$0007
		dc.w	$0800,$A9E7,$1A08,$BBEF,$0000,$73CE,$0410,$77DE
		dc.w	$0000,$0781,$0800,$0F81,$0000,$8EE3,$1004,$DEE7
		dc.w	$0000,$C3CE,$0410,$C7DE,$0000,$E770,$0800,$EF70
		dc.w	$0100,$3D1E,$4320,$7F3E,$0000,$7603,$8004,$F707
		dc.w	$1000,$D1DC,$3201,$F3DD,$0001,$E075,$0083,$E0F7
		dc.w	$0000,$3B9D,$4020,$7BBD,$0030,$C031,$0CF2,$C3F3
		dc.w	$0000,$DCEE,$0100,$FDEE,$0000,$773B,$8040,$F77B
		dc.w	$0080,$9E8E,$2190,$BF9E,$0000,$E703,$0804,$EF07
		dc.w	$0000,$8000,$0000,$8000,$0049,$03DB,$0059,$03A6
		dc.w	$32C0,$0500,$71C0,$0E00,$0004,$0007,$0004,$0007
		dc.w	$0208,$B3EF,$0A08,$BBEF,$0410,$67DE,$0410,$77DE
		dc.w	$0804,$EFB5,$080C,$EFBD,$1004,$9EE7,$5104,$DFE7
		dc.w	$0410,$C7DE,$0410,$C7DE,$0800,$EF70,$0800,$EF70
		dc.w	$4020,$783E,$4020,$783E,$8004,$F707,$8004,$F707
		dc.w	$0201,$83DD,$0221,$83FD,$0080,$EEF6,$0081,$EEF7
		dc.w	$4020,$7BBD,$4020,$7BBD,$0002,$C003,$0002,$C003
		dc.w	$0100,$DDEE,$2100,$DDEE,$8040,$F77B,$8040,$F77B
		dc.w	$2010,$BC1E,$2011,$BC1F,$0804,$EF77,$0804,$EF77
		dc.w	$0000,$B800,$0000,$B800,$0057,$03DF,$005D,$03A2
		dc.w	$6740,$1080,$71C0,$0E00,$0004,$0005,$0006,$0007
		dc.w	$0208,$B2EB,$030C,$BBEF,$0410,$45D6,$1618,$67DE
		dc.w	$0800,$CB99,$0C04,$EFBD,$1004,$96E5,$1806,$DEE7
		dc.w	$0410,$C5D6,$0618,$C7DE,$0800,$CB70,$0C00,$EF70
		dc.w	$4020,$582E,$6030,$783E,$8004,$B705,$C006,$F707
		dc.w	$0201,$82DD,$0301,$83DD,$0080,$6CB6,$80C0,$EEF7
		dc.w	$4020,$5B2D,$6030,$7BBD,$0002,$C002,$0003,$C003
		dc.w	$0100,$DD6C,$0180,$DDEE,$8040,$B65B,$C060,$F77B
		dc.w	$2010,$AC16,$3018,$BC1E,$0804,$EB65,$0C06,$EF77
		dc.w	$0000,$B000,$0000,$B800,$015B,$03DB,$0059,$03A6
		dc.w	$10C0,$0500,$71C0,$0E00,$0006,$0006,$0007,$0007
		dc.w	$030C,$E36D,$0B8E,$F3EF,$0618,$86DB,$271C,$C7DF
		dc.w	$0C00,$8D8F,$2E20,$CF9F,$1806,$1AE6,$5C07,$9EE7
		dc.w	$0618,$C6DB,$071C,$C7DF,$0C00,$8D70,$2E00,$CF70
		dc.w	$6030,$6836,$7038,$783E,$C006,$D706,$E007,$F707
		dc.w	$0301,$835D,$0381,$83DD,$80C0,$B8DC,$C2E1,$FCFE
		dc.w	$6030,$6E35,$70B8,$7F3D,$0003,$C003,$0003,$C003
		dc.w	$0180,$5DB8,$81C2,$DDFC,$C060,$DC6B,$E170,$FE7B
		dc.w	$3018,$B41A,$381C,$BC1E,$0C06,$EDC6,$0E17,$EFE7
		dc.w	$0000,$E000,$0800,$F000,$00D3,$03DB,$0059,$03A6
		dc.w	$CFC0,$1800,$79C0,$0600,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$015B,$03DB,$0059,$03A6
		dc.w	$C5C0,$1000,$71C0,$0E00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$02F5,$03D9,$005B,$03A6
		dc.w	$5F40,$8800,$79C0,$0600,$0000,$0002,$0001,$0003
		dc.w	$8000,$8070,$8104,$80F8,$0000,$381C,$8241,$7C3E
		dc.w	$0000,$0E01,$2080,$1F01,$0000,$DC78,$0002,$DCFC
		dc.w	$1000,$11F8,$3800,$3BFC,$0000,$381C,$8241,$7C3E
		dc.w	$0000,$0006,$0000,$0007,$1000,$10E0,$3209,$71F0
		dc.w	$0000,$7078,$0402,$F8FC,$0000,$1C0C,$4121,$3E1E
		dc.w	$0402,$140A,$0C06,$1C0E,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0379,$03D9,$005B,$03A6
		dc.w	$6DC0,$9800,$79C0,$0600,$0000,$0003,$0000,$0003
		dc.w	$0000,$00D8,$8000,$81DC,$0000,$6C36,$0000,$EE77
		dc.w	$0000,$1B01,$0000,$3B81,$0000,$DCEC,$0000,$DCEE
		dc.w	$0000,$00F0,$4000,$38F0,$0000,$6C36,$0000,$EE77
		dc.w	$0000,$0007,$0000,$0007,$1000,$71B0,$9000,$73B9
		dc.w	$0000,$D8EC,$0000,$DCEE,$0000,$361A,$0000,$773B
		dc.w	$0000,$180C,$0402,$1C0E,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$03F5,$03D9,$005B,$03A6
		dc.w	$72C0,$8000,$71C0,$0E00,$0000,$0003,$0004,$0003
		dc.w	$0000,$81C0,$0201,$81C0,$0000,$E077,$0080,$E077
		dc.w	$0000,$1801,$0002,$3801,$0000,$DCEE,$0100,$DCEE
		dc.w	$0800,$28F0,$9901,$78F0,$0000,$E077,$0080,$E077
		dc.w	$0000,$0007,$0008,$0007,$0000,$63B9,$1402,$F3B9
		dc.w	$0000,$DCEE,$0100,$DCEE,$0000,$703B,$8040,$703B
		dc.w	$0000,$1C0E,$A010,$1C0E,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$03F9,$03DD,$005B,$03A6
		dc.w	$6D40,$8800,$79C0,$0600,$0000,$0003,$0000,$0007
		dc.w	$0020,$81A0,$0060,$83E1,$1000,$D077,$3000,$F0F7
		dc.w	$0000,$0E01,$2080,$1F03,$0000,$DCEE,$0000,$DDEE
		dc.w	$0000,$70F0,$0800,$F9F1,$1000,$D077,$3000,$F0F7
		dc.w	$0000,$0007,$0000,$000F,$0000,$E3B9,$1000,$F7BB
		dc.w	$0000,$DCEE,$0000,$DDEE,$0000,$703B,$0000,$F07B
		dc.w	$0000,$1C0E,$0000,$BC1E,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$03F7,$03D9,$005B,$03A6
		dc.w	$78C0,$8800,$79C0,$0600,$0000,$0003,$0004,$0007
		dc.w	$0000,$81C0,$0201,$83C1,$0000,$E077,$0080,$E0F7
		dc.w	$0000,$0301,$0002,$0383,$0000,$DCEE,$0100,$DDEE
		dc.w	$0000,$78F0,$8101,$F9F1,$0000,$E077,$0080,$E0F7
		dc.w	$00C0,$00C7,$33C8,$0FCF,$0000,$73B9,$0402,$F7BB
		dc.w	$0000,$DCEE,$0100,$DDEE,$0200,$7A3B,$8640,$FE7B
		dc.w	$0000,$9C0E,$2010,$BC1E,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$03FB,$03DD,$005B,$03A6
		dc.w	$FD40,$8800,$79C0,$0600,$0004,$0007,$0004,$0007
		dc.w	$0201,$BBDD,$0201,$BBDD,$0080,$EEF7,$0080,$EEF7
		dc.w	$0802,$6B03,$1882,$7B83,$0100,$DDEE,$0100,$DDEE
		dc.w	$8101,$F9F1,$8101,$F9F1,$0080,$EEF7,$0080,$EEF7
		dc.w	$0008,$000F,$0008,$000F,$0402,$77BB,$8402,$77BB
		dc.w	$0100,$DDEE,$0100,$DDEE,$8040,$F07B,$8044,$F07F
		dc.w	$2010,$BDDE,$2010,$BDDE,$0000,$E000,$0000,$E000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$03F9,$03DD,$005B,$03A6
		dc.w	$FA40,$8A00,$7BC0,$0400,$0004,$0005,$0006,$0007
		dc.w	$0201,$B2D9,$0301,$BBDD,$0080,$6CB6,$80C0,$EEF7
		dc.w	$0002,$3302,$0803,$7B83,$0100,$D96E,$0180,$DDEE
		dc.w	$8101,$B971,$C181,$F9F1,$0080,$6CB6,$80C0,$EEF7
		dc.w	$0008,$000B,$000C,$000F,$0402,$75B2,$0603,$77BB
		dc.w	$0100,$D96E,$0180,$DDEE,$8040,$B05B,$C060,$F07B
		dc.w	$2010,$AD96,$3018,$BDDE,$0000,$C000,$0000,$E000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$03DD,$03F9,$005B,$03A6
		dc.w	$D540,$8000,$71C0,$0E00,$0006,$0006,$0007,$0007
		dc.w	$0301,$E371,$0B85,$F3F9,$80C0,$B8DC,$C2E1,$FCFE
		dc.w	$0001,$1E01,$4081,$3F01,$0180,$71AE,$85C0,$F9EE
		dc.w	$C181,$D9B1,$E1C1,$F9F1,$80C0,$B8DC,$C2E1,$FCFE
		dc.w	$000C,$000D,$000E,$000F,$0603,$76E3,$070B,$77F3
		dc.w	$0180,$71AE,$85C0,$F9EE,$C060,$D06B,$E070,$F07B
		dc.w	$3018,$B71B,$385C,$BF9F,$0000,$8000,$2000,$C000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$03D9,$03FD,$005B,$03A6
		dc.w	$C840,$8800,$79C0,$0600,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$03DD,$03F9,$005B,$03A6
		dc.w	$AD40,$C800,$79C0,$0600,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$035D,$03F9,$005B,$03A6
		dc.w	$EE40,$8A00,$7BC0,$0400,$0000,$0003,$0000,$0007
		dc.w	$0000,$F0F0,$0004,$F9F8,$0000,$303C,$8401,$787E
		dc.w	$0000,$0E06,$2090,$1F0F,$0000,$0787,$8020,$0FCF
		dc.w	$0080,$E083,$01C8,$F1C7,$0000,$8180,$2420,$C3C0
		dc.w	$0001,$0061,$0003,$0077,$0000,$0E07,$2090,$1F0F
		dc.w	$0000,$0781,$4024,$8FC3,$0000,$C0C1,$1210,$E1E1
		dc.w	$4020,$40A0,$C060,$C0E0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$02D9,$03F9,$005B,$03A6
		dc.w	$2400,$4800,$F9C0,$0600,$0000,$0001,$0000,$0001
		dc.w	$0000,$E1D8,$0000,$E1DC,$0000,$6876,$0000,$EC77
		dc.w	$0000,$1B0D,$0000,$3B9D,$0000,$0EC3,$0000,$8EE3
		dc.w	$0000,$C006,$0200,$C1CE,$0000,$C340,$0000,$E760
		dc.w	$0001,$0077,$0009,$0077,$0000,$1B0D,$0000,$3B9D
		dc.w	$0000,$8EC3,$0000,$CEE7,$0000,$61A1,$0000,$73B1
		dc.w	$0000,$80C0,$4020,$C0E0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$035D,$03F9,$005B,$03A6
		dc.w	$1840,$6C00,$F9C0,$0600,$0000,$0001,$0002,$0001
		dc.w	$0000,$E1DC,$0201,$E1DC,$0000,$EC77,$0280,$EC77
		dc.w	$0000,$181D,$0020,$381D,$0000,$8EE3,$5004,$8EE3
		dc.w	$0040,$C14E,$04D0,$C3CE,$0000,$0760,$0810,$0760
		dc.w	$0000,$0076,$0081,$007F,$0000,$3B9D,$4020,$3B9D
		dc.w	$0000,$CEE7,$1008,$CEE7,$0000,$03B1,$040A,$03B1
		dc.w	$0000,$C0E0,$0100,$C0E0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$02DB,$03FB,$0059,$03A6
		dc.w	$1C40,$6800,$F9C0,$0600,$0000,$0001,$0000,$0003
		dc.w	$0000,$E1DC,$0000,$E3DD,$0000,$EC77,$0000,$EEF7
		dc.w	$0000,$0E1D,$2080,$1F3D,$0000,$8EE3,$0000,$DEE7
		dc.w	$0000,$C38E,$0040,$C7DE,$0000,$0760,$0000,$0F70
		dc.w	$0000,$007E,$0001,$00FF,$0000,$3B9D,$0000,$7BBD
		dc.w	$0000,$CEE7,$0000,$DEEF,$0000,$03B1,$0000,$07BB
		dc.w	$0000,$C0E0,$0000,$C1E0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$037B,$03DB,$0059,$03A6
		dc.w	$BA40,$4E00,$FBC0,$0400,$0000,$0001,$0002,$0003
		dc.w	$0000,$E1D8,$0201,$E3DD,$0000,$EE77,$0080,$EEF7
		dc.w	$0000,$031D,$0020,$03BD,$0000,$CEC3,$1004,$DEE7
		dc.w	$0000,$C3CE,$0410,$C7DE,$2000,$A770,$6803,$EF70
		dc.w	$0C00,$0C77,$3C80,$FCFF,$0000,$3B9D,$4020,$7BBD
		dc.w	$0000,$CEE7,$1008,$DEEF,$2000,$A3B9,$6402,$E7BB
		dc.w	$0000,$C0E0,$0100,$C1E0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$02FB,$03DB,$0059,$03A6
		dc.w	$A040,$4C00,$F9C0,$0600,$0002,$0003,$0002,$0003
		dc.w	$0201,$E3F1,$0205,$E3F9,$0080,$EEF7,$1080,$FEF7
		dc.w	$0820,$6B3D,$18A2,$7BBF,$1004,$DF87,$1024,$DFC7
		dc.w	$0410,$C7DE,$0410,$C7DE,$0800,$CF70,$2880,$EFF0
		dc.w	$0080,$00F7,$0088,$00F7,$4020,$7BBD,$4020,$7BBD
		dc.w	$1008,$DEEF,$1008,$DEEF,$0402,$07BB,$0442,$07FB
		dc.w	$0100,$DDEE,$0100,$DDEE,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$037F,$03DB,$0059,$03A6
		dc.w	$9A40,$4E00,$FBC0,$0400,$0002,$0002,$0003,$0003
		dc.w	$0201,$E2D9,$0301,$E3DD,$0080,$6EB7,$80C0,$EEF7
		dc.w	$0020,$332D,$0830,$7BBD,$1004,$D6C5,$1806,$DEE7
		dc.w	$0410,$C5D6,$0618,$C7DE,$0800,$CB70,$0C00,$EF70
		dc.w	$0080,$00B7,$00C0,$00F7,$4020,$5B2D,$6030,$7BBD
		dc.w	$1008,$96EB,$180C,$DEEF,$0402,$05BA,$0603,$07BB
		dc.w	$0100,$D96C,$0180,$DDEE,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$03FB,$03DB,$0059,$03A6
		dc.w	$8D00,$5D00,$F8C0,$0600,$0003,$0003,$0003,$0003
		dc.w	$0301,$635D,$8381,$E3DD,$80C0,$AED7,$C0E0,$EEF7
		dc.w	$0030,$1E35,$40B8,$3F3D,$1806,$DAE6,$1C07,$DEE7
		dc.w	$0618,$C6DB,$071C,$C7DF,$0C00,$8D70,$2E00,$CF70
		dc.w	$00C0,$00D7,$00E0,$00F7,$6030,$6E37,$70B8,$7F3F
		dc.w	$180C,$1AED,$5C0E,$9EEF,$0603,$06BB,$0703,$07BB
		dc.w	$0180,$71B8,$85C2,$F9FC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$015B,$03DB,$0059,$03A6
		dc.w	$D2C0,$4E80,$FB40,$0400,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$025B,$03DB,$0059,$03A6
		dc.w	$9D40,$4D00,$F8C0,$0600,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$005F,$03DF,$005D,$03A2
		dc.w	$F680,$4E80,$FB40,$0400,$0000,$0001,$0000,$0003
		dc.w	$0000,$C070,$1104,$E0F8,$0000,$7818,$0242,$FC3C
		dc.w	$0000,$1E07,$0090,$3F0F,$4000,$4300,$C840,$C780
		dc.w	$0000,$381E,$0200,$7C3F,$0000,$070F,$9040,$0F9F
		dc.w	$0000,$C760,$0002,$E761,$0000,$E0F0,$0804,$F1F8
		dc.w	$0000,$3800,$8200,$7C00,$0010,$0610,$0032,$0771
		dc.w	$0000,$E070,$0904,$F0F8,$0000,$781C,$0241,$FC3E
		dc.w	$0004,$0C14,$210C,$1E1C,$0200,$0A00,$0600,$0E00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$02DB,$035B,$0059,$03A6
		dc.w	$C740,$4F00,$FAC0,$0400,$0000,$0003,$0000,$0003
		dc.w	$0000,$20D8,$0000,$31DC,$0000,$EC34,$0000,$EE76
		dc.w	$0000,$3B0D,$0000,$3B9D,$0000,$8680,$4000,$CEC0
		dc.w	$0000,$643B,$0000,$663B,$0000,$0D87,$0000,$9DC7
		dc.w	$0000,$8761,$0000,$8763,$0000,$B1D8,$0000,$B9DC
		dc.w	$0000,$6C00,$0000,$EE00,$0010,$0771,$0090,$0773
		dc.w	$0000,$B0D8,$0000,$B9DC,$0000,$EC36,$0000,$EE77
		dc.w	$0000,$1A18,$0004,$3B1C,$0000,$0C00,$0200,$0E00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$005F,$03DF,$005D,$03A2
		dc.w	$EF80,$4780,$FA40,$0400,$0000,$0003,$0004,$0003
		dc.w	$0000,$31DC,$0A01,$31DC,$0000,$EE76,$0081,$EE76
		dc.w	$0000,$3B81,$4000,$3B81,$0000,$8EC0,$1020,$CEC0
		dc.w	$0000,$663B,$8140,$663B,$0000,$9DC7,$2008,$9DC7
		dc.w	$0000,$8763,$0814,$8763,$0000,$81DC,$0200,$81DC
		dc.w	$0000,$6000,$0000,$E000,$0000,$0763,$0814,$07F3
		dc.w	$0000,$B9DC,$0201,$B9DC,$0000,$EE70,$0080,$EE70
		dc.w	$0000,$3B1C,$40A0,$3B1C,$0000,$0E00,$1000,$0E00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$12DF,$015F,$005D,$03A2
		dc.w	$6580,$4F80,$FA40,$0400,$0000,$0003,$0000,$0007
		dc.w	$0000,$31DC,$0800,$33DD,$0000,$EE76,$0000,$EEF7
		dc.w	$0000,$3B8F,$0020,$7B9F,$0000,$0EC0,$4000,$9EE0
		dc.w	$0000,$663B,$0100,$E67B,$0000,$9DC7,$0000,$BDCF
		dc.w	$0000,$8763,$0000,$8F77,$4000,$41DC,$C000,$C3DC
		dc.w	$0000,$3800,$8200,$7C00,$0000,$07E3,$0010,$0FF7
		dc.w	$0000,$B9DC,$0000,$BBDD,$0000,$EE70,$0000,$EEF0
		dc.w	$0000,$3B1C,$0000,$7BBC,$0000,$0E00,$0000,$1E00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$11FD,$025F,$005D,$03A2
		dc.w	$7DC0,$57C0,$EA00,$0400,$0000,$0003,$0004,$0007
		dc.w	$0000,$A1DC,$4201,$F3DD,$0000,$EE77,$0080,$EEF7
		dc.w	$0000,$3BBC,$4002,$7BBC,$0000,$0EE0,$1000,$1EE0
		dc.w	$0000,$743B,$8840,$FE7B,$0000,$1DC7,$2008,$BDCF
		dc.w	$0000,$87F3,$0804,$8FF7,$0000,$81D8,$0200,$83DC
		dc.w	$0000,$0C00,$0033,$0E0F,$C000,$C773,$C804,$CFF7
		dc.w	$0000,$B9DC,$0201,$BBDD,$0002,$EE7A,$0086,$EEFE
		dc.w	$0000,$3B9C,$4020,$7BBC,$0000,$0E00,$1000,$1E00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$12FC,$015F,$005D,$03A2
		dc.w	$7C80,$5680,$EB40,$0400,$0004,$0007,$0004,$0007
		dc.w	$0201,$B3DD,$0201,$BBDD,$0080,$EEF7,$0088,$EEFF
		dc.w	$4020,$7BBD,$4020,$7BBD,$1000,$DEE0,$1100,$DFE0
		dc.w	$8040,$F67E,$8040,$F77F,$2008,$3DCF,$A008,$3DCF
		dc.w	$0804,$8F77,$0804,$8F77,$0200,$BBF1,$0204,$BBF9
		dc.w	$2000,$AC00,$6200,$EE00,$0804,$0F77,$0884,$0F77
		dc.w	$0201,$BBDD,$0201,$BBDD,$0080,$EEF0,$0080,$EEF0
		dc.w	$4020,$7BBD,$4420,$7FBD,$1000,$DEE0,$1000,$DEE0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1174,$025F,$005D,$03A2
		dc.w	$5740,$7500,$EAC0,$0400,$0004,$0005,$0006,$0007
		dc.w	$0201,$B2D9,$0301,$BBDD,$0080,$6EB7,$80C0,$EEF7
		dc.w	$4020,$5BAD,$6030,$7BBD,$1000,$96E0,$1800,$DEE0
		dc.w	$8040,$B65B,$C060,$F77B,$2008,$2D8B,$300C,$BDCF
		dc.w	$0804,$8B75,$0C06,$8F77,$0200,$B2D8,$0300,$BBDD
		dc.w	$0000,$CC00,$2000,$EE00,$0804,$0B75,$0C06,$0F77
		dc.w	$0201,$B2D9,$0301,$BBDD,$0080,$6EB0,$80C0,$EEF0
		dc.w	$4020,$5BAD,$6030,$7BBD,$1000,$96C0,$1800,$DEE0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$13F0,$005F,$005D,$03A2
		dc.w	$6EC0,$4480,$FB40,$0400,$0006,$0006,$0007,$0007
		dc.w	$0301,$E371,$0B85,$F3F9,$80C0,$AED7,$C0E0,$EEF7
		dc.w	$6030,$6BB7,$7038,$7BBF,$1800,$1AE0,$5C00,$9EE0
		dc.w	$C060,$DC6B,$E170,$FE7B,$300C,$B70D,$384E,$BF8F
		dc.w	$0C06,$8D76,$0E07,$8F77,$0300,$E35C,$0B81,$F3DC
		dc.w	$0000,$7800,$0200,$FC00,$0C06,$0D76,$0E07,$0F77
		dc.w	$0301,$E371,$0B85,$F3F9,$80C0,$AED0,$C0E0,$EEF0
		dc.w	$6030,$6BB7,$7038,$7BBF,$1800,$1B80,$5C20,$9FC0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$117B,$0254,$005D,$03A2
		dc.w	$4200,$6000,$FFC0,$0400,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$13FD,$0052,$005D,$03A2
		dc.w	$4EC8,$6480,$FB40,$0400,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0159,$127A,$005D,$03A2
		dc.w	$5840,$6200,$FFC0,$0400,$0000,$0000,$0002,$0001
		dc.w	$0040,$E140,$08C0,$F1C0,$0000,$381C,$8241,$7C3E
		dc.w	$0000,$1E1D,$0080,$3F1D,$0001,$C305,$0843,$C787
		dc.w	$0200,$02B0,$0301,$03B0,$0000,$7078,$0402,$F8FC
		dc.w	$0000,$0007,$0000,$000F,$0000,$E3B8,$0000,$F3B8
		dc.w	$4100,$4500,$E301,$E701,$8000,$8387,$C820,$C7C7
		dc.w	$0000,$63F0,$0000,$67F8,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1ACA,$0179,$005D,$03A2
		dc.w	$4B48,$6100,$FEC0,$0400,$0000,$0001,$0000,$0003
		dc.w	$0000,$B180,$0040,$B9C0,$0000,$6C36,$0000,$EE77
		dc.w	$0000,$3B1D,$0000,$3B9D,$0000,$C686,$0001,$CEC7
		dc.w	$0000,$01B0,$0200,$03B1,$0000,$D8EC,$0000,$DCEE
		dc.w	$0000,$0003,$0000,$0003,$0000,$C3B8,$0001,$C3B8
		dc.w	$0000,$0600,$0102,$E701,$0000,$06C7,$0000,$CEE7
		dc.w	$0000,$61E0,$0000,$61E0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$01DA,$1279,$005D,$03A2
		dc.w	$FC08,$E600,$7BC0,$0400,$0000,$0001,$0000,$0003
		dc.w	$0000,$81C0,$0201,$81C0,$0000,$E070,$0080,$E070
		dc.w	$0000,$3B9D,$4022,$3B9D,$0000,$CEC7,$1028,$CEC7
		dc.w	$0000,$03A1,$0402,$03B1,$0000,$C0EE,$0100,$C0EE
		dc.w	$0000,$0003,$0004,$0003,$0000,$C3B8,$0442,$C3B9
		dc.w	$2000,$A701,$6804,$E703,$4000,$4E07,$D008,$CE07
		dc.w	$0000,$61E0,$1200,$61E0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$08CE,$1379,$005D,$03A2
		dc.w	$C840,$E208,$7FC0,$0400,$0000,$0000,$0002,$0001
		dc.w	$0000,$E1C0,$0800,$F3C1,$1008,$D068,$3018,$F0F8
		dc.w	$0000,$3B9D,$0000,$7BBF,$0000,$CEC7,$0000,$DEEF
		dc.w	$0000,$03C1,$0010,$07E3,$2000,$A0EE,$6000,$E1EE
		dc.w	$0000,$0003,$0000,$0007,$0000,$C3B9,$0000,$C7FB
		dc.w	$0000,$C703,$2000,$EF07,$0000,$8E07,$4000,$DE0F
		dc.w	$0000,$61E0,$0000,$73E0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$105E,$13F9,$005D,$03A2
		dc.w	$BAC0,$A208,$3FC0,$4400,$0000,$0000,$0000,$0000
		dc.w	$0000,$31C0,$0201,$3BC1,$0000,$E070,$0080,$E0F0
		dc.w	$0000,$3B1F,$4020,$7BBF,$0000,$CEE7,$1008,$DEEF
		dc.w	$0000,$03A1,$040A,$07B3,$0000,$C0EC,$0100,$C1EE
		dc.w	$00C0,$00C3,$33C4,$0FC7,$0000,$C3F9,$0402,$C7FB
		dc.w	$0000,$E703,$0804,$EF07,$0020,$CEA7,$1068,$DEEF
		dc.w	$0000,$F1E0,$0200,$F3E0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0AEA,$135D,$005D,$03A2
		dc.w	$B85C,$A208,$3FC0,$4400,$0000,$0006,$0001,$0007
		dc.w	$8201,$B3DD,$8A01,$BBDD,$0080,$EEF7,$0080,$EEF7
		dc.w	$4020,$7E3D,$40A0,$7F3F,$1008,$DEEF,$1108,$DFEF
		dc.w	$0402,$77B3,$0402,$77BB,$0100,$DDF8,$0102,$DDFC
		dc.w	$0004,$0007,$0004,$0007,$0402,$C7BB,$0402,$C7FB
		dc.w	$0804,$EF77,$0804,$EF77,$1008,$DECF,$1028,$DEEF
		dc.w	$0200,$73E0,$0200,$73E0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1074,$13DD,$005D,$03A2
		dc.w	$2AD8,$B20C,$3FC0,$4400,$0000,$0003,$0000,$0007
		dc.w	$0201,$32D9,$8301,$BBDD,$0080,$6CB6,$80C0,$EEF7
		dc.w	$4020,$582D,$6032,$783D,$1008,$D6EB,$180C,$DEEF
		dc.w	$0402,$65BA,$0603,$77BB,$0100,$D96C,$0180,$DDEE
		dc.w	$0004,$0005,$0006,$0007,$0402,$C5BA,$0643,$C7BB
		dc.w	$0804,$EB65,$0C06,$EF77,$1008,$D6CB,$180C,$DEEF
		dc.w	$0200,$72E0,$0300,$73E0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$3AE9,$135C,$005D,$03A2
		dc.w	$1340,$BA14,$3FC8,$4400,$0000,$0001,$0004,$0003
		dc.w	$0301,$E371,$0B85,$F3F9,$80C0,$B8DC,$C2E1,$FCFE
		dc.w	$6030,$6835,$7038,$783D,$180C,$DAED,$1C0E,$DEEF
		dc.w	$0603,$C6BB,$1703,$E7BB,$0180,$71AE,$85C0,$F9EE
		dc.w	$0006,$0006,$0007,$0007,$0603,$C6BB,$0703,$C7BB
		dc.w	$0C06,$6DC6,$8E17,$EFE7,$180C,$DB8D,$1C2E,$DFCF
		dc.w	$0300,$7360,$0380,$73E0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0855,$23D8,$105D,$03A2
		dc.w	$7ACE,$BA14,$3FC8,$4400,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$7ACC,$2358,$105D,$03A2
		dc.w	$2F51,$AA1A,$2FCC,$5400,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$91C0,$4B58,$305D,$03A2
		dc.w	$60D6,$A01B,$25CC,$5E00,$8000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0001,$0000,$0000,$0000,$6A89,$DB58,$305D,$03A2
		dc.w	$6F41,$AA15,$2FCE,$5400,$4000,$8000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0002,$0001,$0000,$0000,$8367,$ABDE,$705B,$03A0
		dc.w	$45D5,$980A,$1DC7,$6600,$5000,$6000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$54DD,$0000,$0000,$0000
		dc.w	$D830,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0012,$000E,$0001,$0000,$AAAB,$535A,$E05F,$03A0
		dc.w	$4D48,$9805,$1DC3,$6600,$DA5F,$1FA0,$E000,$0000
		dc.w	$C000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$7189,$0000,$0000,$0000
		dc.w	$9450,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$059A,$0079,$0007,$0000,$1367,$A3DE,$C05B,$03A0
		dc.w	$D7E5,$9003,$15C0,$6E00,$7540,$8000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$5449,$0000,$0000,$0000
		dc.w	$1870,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0019,$0007,$0000,$0000,$A68A,$C37A,$005F,$03A0
		dc.w	$C790,$8060,$05C0,$7E00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$5589,$0000,$0000,$0000
		dc.w	$D554,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0B80,$077A,$005F,$03A0
		dc.w	$DD55,$86CF,$05C0,$7E3F,$6A8A,$FA8A,$0575,$FFFF
		dc.w	$0A82,$0AFF,$F500,$FFFF,$BFA8,$FFFF,$0000,$FFFF
		dc.w	$AFAA,$FFAA,$0055,$FFFF,$16AA,$17FF,$E800,$FFFF
		dc.w	$057D,$FFFF,$0000,$FFFF,$50AF,$FFFF,$0000,$FFFF
		dc.w	$EA2B,$FFFF,$0000,$FFFF,$EA85,$EA85,$157A,$FFFF
		dc.w	$AA81,$FFFF,$0000,$FFFF,$5F55,$FFFF,$0000,$FFFF
		dc.w	$55F5,$FFFF,$0000,$FFFF,$02AB,$FFFF,$0000,$FFFF
		dc.w	$42AF,$42AF,$BD50,$FFFF,$A9FD,$FFFF,$0000,$FFFF
		dc.w	$5158,$FEA7,$0000,$FFFF,$1A8A,$E57F,$0000,$FFFF
		dc.w	$BA80,$FA80,$057F,$FFFF,$2D88,$017A,$FE5F,$FFA0
		dc.w	$C66A,$9F3F,$0500,$7EFF,$FD55,$FD55,$02AA,$FFFF
		dc.w	$5740,$57FF,$A800,$FFFF,$7D05,$FFFF,$0000,$FFFF
		dc.w	$5FFD,$FFFD,$0002,$FFFF,$2F50,$2FFF,$D000,$FFFF
		dc.w	$2BEA,$FFFF,$0000,$FFFF,$281F,$D7FF,$0000,$FFFF
		dc.w	$4157,$FFFF,$0000,$FFFF,$FF4B,$FF4B,$00B4,$FFFF
		dc.w	$D40A,$FFFF,$0000,$FFFF,$FA8A,$FFF5,$0000,$FFFF
		dc.w	$A2BE,$5FFF,$0000,$FFFF,$A057,$FFFF,$0000,$FFFF
		dc.w	$A5FF,$A5FF,$5A00,$FFFF,$D7D2,$FFFD,$0000,$FFFF
		dc.w	$B6AA,$4800,$0000,$FFFF,$556D,$0012,$0000,$FFFF
		dc.w	$4BE8,$BFE8,$0017,$FFFF,$16B0,$007A,$FF5F,$FFA0
		dc.w	$7DCF,$3C30,$A600,$5FFF,$E1FE,$1E02,$0001,$FFFF
		dc.w	$AB80,$AFFF,$5000,$FFFF,$00BA,$FF45,$0000,$FFFF
		dc.w	$BF03,$40FF,$0000,$FFFF,$FD8A,$FFF5,$0000,$FFFF
		dc.w	$817D,$7FFF,$0000,$FFFF,$1000,$EFFF,$0000,$FFFF
		dc.w	$2EAF,$D150,$0000,$FFFF,$C0FF,$3FFF,$0000,$FFFF
		dc.w	$62A0,$FD5F,$0000,$FFFF,$5F45,$FFFA,$0000,$FFFF
		dc.w	$45F4,$BFFF,$0000,$FFFF,$0A8D,$F57F,$0000,$FFFF
		dc.w	$FE07,$FFF8,$0000,$FFFF,$E1FF,$1E00,$0000,$FFFF
		dc.w	$FF40,$0000,$0000,$FFFF,$02FF,$0000,$0000,$FFFF
		dc.w	$FF87,$0078,$0000,$FFFF,$F380,$0C4A,$006F,$FFB0
		dc.w	$5EC2,$1F02,$8402,$7FFD,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFEA,$FFEA,$FFEA,$0015
		dc.w	$34BF,$00BF,$00BF,$FF40,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FA8D,$FA80,$FA80,$057F,$2FFF,$2FFF,$2FFF,$D000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$F41B,$FFCA,$FFEF,$0030
		dc.w	$787C,$387F,$A780,$5FFF,$3A5F,$C000,$0000,$FFFF
		dc.w	$EBD0,$0000,$0000,$FFFF,$BFE9,$0017,$0000,$FFFF
		dc.w	$7400,$FFFF,$0000,$FFFF,$BD04,$4004,$0004,$FFFB
		dc.w	$5550,$5550,$5550,$AAAF,$F42F,$0800,$0000,$FFFF
		dc.w	$FA5D,$05FF,$0000,$FFFF,$002F,$FFD0,$0000,$FFFF
		dc.w	$4115,$0115,$0115,$FEEA,$543C,$5403,$5400,$ABFF
		dc.w	$7855,$8055,$0055,$FFAA,$5105,$5100,$5100,$AEFF
		dc.w	$E801,$17FF,$0000,$FFFF,$03FC,$FC00,$0000,$FFFF
		dc.w	$007F,$0000,$0000,$FFFF,$FEEF,$0150,$0040,$FFBF
		dc.w	$FFC0,$003F,$0000,$FFFF,$F867,$F812,$07E7,$FFF8
		dc.w	$FEB4,$BF40,$2000,$5FFF,$5FFF,$5FFF,$5FFF,$A000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$4AFF,$1FFF,$13FF,$E400
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FEEF,$FE5F,$FEBF,$0100
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$F542,$FF2A,$FF0F,$00F0
		dc.w	$9A7F,$BC7F,$207F,$5F80,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$C3FF,$9FFF,$93FF,$6400
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFF9,$FFF9,$FFF9,$0006,$FEB7,$FFEF,$FE1F,$0100
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FABE,$FF92,$FF9F,$0060
		dc.w	$0BFF,$BFFF,$3FFF,$4000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFD,$FFFD,$FFFD,$0002,$0FA5,$1BFD,$13FA,$E400
		dc.w	$47A9,$4000,$BFFF,$0000,$2A3D,$0A00,$F5FF,$0000
		dc.w	$49FF,$0000,$FFFF,$0000,$5507,$AAF8,$FFFF,$0000
		dc.w	$502E,$0000,$FFFF,$0000,$92AA,$0000,$FFFF,$0000
		dc.w	$A92E,$0000,$FFFF,$0000,$815C,$0003,$FFFF,$0000
		dc.w	$155F,$EAA0,$FFFF,$0000,$EA4A,$0000,$FFFF,$0000
		dc.w	$F152,$0140,$FEBF,$0000,$554A,$000A,$FFF5,$0000
		dc.w	$AFF6,$BBF0,$5BF0,$040F,$FC37,$FCEF,$FD1F,$0300
		dc.w	$FF7F,$FFFF,$FFFF,$0000,$F40A,$FFF2,$FFFF,$0000
		dc.w	$35B7,$0FBF,$BFB6,$4040,$FDEF,$FFFF,$CC2D,$0000
		dc.w	$77FA,$FFFA,$1182,$0005,$C3CA,$9FFE,$93FD,$6400
		dc.w	$0000,$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000
		dc.w	$005A,$0005,$FFFF,$0000,$A02B,$5FD4,$FFFF,$0000
		dc.w	$A015,$000A,$FFFF,$0000,$F555,$0AAA,$FFFF,$0000
		dc.w	$55F5,$AA0A,$FFFF,$0000,$00BA,$0005,$FFFF,$0000
		dc.w	$80AB,$7F54,$FFFF,$0000,$5000,$0000,$FFFF,$0000
		dc.w	$0000,$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000
		dc.w	$53E8,$73E3,$BBE4,$0C1F,$7D1B,$7FD5,$7D2F,$8300
		dc.w	$FEB8,$FFF8,$FF78,$0007,$FA96,$FFEA,$FFFF,$0000
		dc.w	$22FA,$1FFA,$BFF7,$4000,$4254,$D2B4,$090F,$B5E9
		dc.w	$8871,$9A65,$E509,$36B6,$0FE4,$1BF7,$13F7,$E408
		dc.w	$9552,$02AD,$FFFF,$0000,$24AA,$D815,$FFFF,$0000
		dc.w	$91FF,$6E00,$FFFF,$0000,$FFFF,$0000,$FFFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$AAEE,$5511,$FFFF,$0000
		dc.w	$EABF,$1540,$FFFF,$0000,$FFFF,$0000,$FFFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$EA25,$15DA,$FFFF,$0000
		dc.w	$5491,$A06E,$FFFF,$0000,$2AA9,$D540,$FFFF,$0000
		dc.w	$27A1,$E7A6,$EFA0,$185F,$BD48,$3DC5,$3F3F,$C300
		dc.w	$FFF1,$FEB6,$FF70,$000F,$7F4D,$7FF0,$7FFD,$8002
		dc.w	$B9FC,$87FC,$3FF3,$4004,$53F4,$F7FD,$18E6,$A509
		dc.w	$9A42,$BEE6,$D30A,$24B5,$A7E2,$BDF2,$B5F2,$420C
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$4B69,$4B08,$4308,$3CF7,$FF0A,$BBDE,$BA3D,$4700
		dc.w	$FB57,$FFF0,$FC30,$020F,$3FA5,$3FF8,$3FFD,$C002
		dc.w	$B2FA,$8FFC,$3FF1,$4006,$52F0,$F6F1,$19FC,$A403
		dc.w	$9845,$B8C1,$D671,$218E,$22EA,$3FF2,$32F2,$C10C
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$5A8B,$4A33,$4243,$3DFC,$F735,$04DF,$0238,$FF00
		dc.w	$7C78,$FDD8,$FE38,$0207,$76D1,$7FFC,$7FFD,$8002
		dc.w	$E5BA,$9FBE,$3FB3,$4044,$52F4,$F670,$1862,$A58D
		dc.w	$9A50,$BC40,$D108,$26B7,$17E2,$0B72,$1572,$E08C
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$4109,$4870,$4080,$3FFF,$7D51,$E8DF,$0720,$FE00
		dc.w	$3E2F,$7FBF,$FA5F,$0600,$FFE6,$FFFD,$FFFD,$0002
		dc.w	$4AFA,$3EFE,$BEF3,$4104,$52F4,$F7FD,$18E6,$A509
		dc.w	$9A40,$BEE4,$D308,$24B7,$3CB8,$2EB0,$37B0,$C04E
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1139,$08C8,$0008,$7FF7,$2F59,$B9DF,$4420,$FE00
		dc.w	$9A97,$BB8F,$7E7F,$0600,$DFB6,$FFFD,$FFFD,$0002
		dc.w	$1FBA,$3FBE,$BFB3,$4044,$52F4,$F7FD,$18E6,$A509
		dc.w	$9A40,$BEE4,$D308,$24B7,$7378,$6A50,$73D0,$842E
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1B6F,$030F,$030F,$7CF0,$AA49,$59CF,$0630,$FC00
		dc.w	$5E03,$D587,$367F,$0E00,$FBEA,$FFFA,$FFF8,$0007
		dc.w	$357A,$357E,$B573,$4A84,$4A34,$CE3D,$79E6,$8409
		dc.w	$9A50,$BEF4,$D318,$24A7,$C3DA,$EFE2,$F302,$043C
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1B9F,$039F,$039F,$7C60,$D85B,$B1CF,$8E30,$7C00
		dc.w	$3C19,$F19F,$0A63,$0600,$F6D7,$FFF2,$FFF0,$000F
		dc.w	$A9F2,$29F2,$A9F6,$560D,$5BC4,$4204,$C22D,$BDFB
		dc.w	$9203,$9203,$B6A7,$6DFC,$DFA4,$9B70,$EBA0,$041E
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3692,$0002,$0002,$7FFD,$BA43,$63D7,$1C38,$FC00
		dc.w	$06B2,$83BF,$7C41,$0200,$D93E,$C003,$C000,$3FFF
		dc.w	$357F,$F57F,$F57F,$0A80,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FF4D,$FF4E,$FF4F,$00B0,$5F8A,$77D2,$97A2,$081C
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$5FFD,$07FC,$07FC,$7803,$71D4,$E5D4,$1A3B,$FC00
		dc.w	$36F1,$0DBF,$FC40,$0200,$FFF7,$7FF2,$FFF0,$000F
		dc.w	$7D49,$C000,$FFFF,$0000,$51EA,$5000,$AFFF,$0000
		dc.w	$4FFE,$0000,$FFFF,$0000,$2852,$E06E,$6F9E,$1000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3815,$1000,$1FFF,$6000,$5549,$0000,$FFFF,$0000
		dc.w	$5092,$5000,$AFFF,$0000,$BC50,$0055,$FFAC,$0003
		dc.w	$0000,$4000,$FFFF,$0000,$0000,$0000,$FFFF,$0000
		dc.w	$02D6,$002B,$FFFC,$0000,$5D6C,$E026,$FFDA,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$700A,$2000,$3FFF,$4000,$28AA,$0000,$FFFF,$0000
		dc.w	$2400,$0000,$FFFF,$0000,$0000,$0002,$FFFE,$0001
		dc.w	$2A91,$956E,$7FFF,$0000,$2554,$C0AB,$FFFF,$0000
		dc.w	$8FF5,$7006,$FFF9,$0000,$EAC2,$8012,$FFEC,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$7A5E,$405E,$7FA1,$0000,$AEB3,$AEB3,$514C,$0000
		dc.w	$3289,$3076,$CFFF,$0000,$5525,$A81A,$FFFF,$0000

scroll_pointer	dc.l	scroll_text
scroll_text
text:
	;DC.B      '                            '
	;DC.B      ' ABCDEFGHIJKLMNOPQRSTUVWXYZ '
	;DC.B      ' 0123456789 /*-.,;:!?()',$27
	;DC.B      '                            '

	DC.B      '             '
	DC.B      'HELLO GUYS ! IT',$27,'S ATOMUS FROM THE NOEXTRA TEAM ! '
	DC.B      'I',$27,'M VERY GLAD TO PRESENT YOU OUR FIRST COMPILATION '
	DC.B      'RELEASED THIS YEAR BY ALL MEMBERS OF NOEXTRA. '
	DC.B      'THE PIECE OF THE CODE WAS DONE BY ZORRO 2 AND ME. '
	DC.B      'THE BRILLIANT CHIPPY SOUND WAS MADE BY TOMCHI ON MEGATISER. '
	DC.B      'AND THE BIG GRAPHISMS WAS DONE AND REDONE BY OUR FAMOUS GFXMAN MISTER.A ! '
	DC.B      '                            '
	DC.B      'BUT NOW LET',$27,'S TALK SOME ADDICT ST MEMBERS ;)                    '
	DC.B      '                            '
; Zorro 2
	DC.B      'ZORRO 2, THE MORE ACTIVE MEMBER THAN US SAID :'
	DC.B      ' I THINK THERE',$27,'S A LONG TIME THAT WE BUILD SOME MENUS/COMPILATIONS FOR OTHERS BUT NOT FOR US.'
	DC.B      ' WHY NOT ! BUT WHAT DO SOMETHING NEW THAN OTHERS ??? MAYBE FIND TO DO COLLECTORS COMPLATIONS ?!?'
	DC.B      ' BUT WE NEED TO WORK A LOT OF COURSE THEN PATIENT BECAUSE THE NEXT VOLUME IS BEGIN TO BE ACHIEVE SOON !'
	DC.B      ' ALL SCREENS INCLUDED INSIDE PROMISES A LOT, SOME RARETY AND NEVER SEEN BEFORE (I KNOW THAT I SAID OF COURSE !)'
	DC.B      ' MORE INFORMATIONS ABOUT THIS FIRST VOLUME AND THE NEXT ON YOUR OFFICIAL WEBSITE AT HTTP://WWW.NOEXTRA-TEAM.COM/'
	DC.B      '                                              '

; Mister.A
	DC.B      'MISTER.A IS NOT A GOOSIP BUT HE TALKS A LOT :'
	DC.B      ' I HAVE NOTHING TO SAY BUT..  WE ARE CHAMPION OF THE WORLD : VIVA ITALIA !!!!! VIVA IL MUNDIAL 2006 !!! '
	DC.B      ' OK!OK!OK! I ONLY PREFER TO DRAW WITH NEOCHROME OR DELUXE PAINT..... SO SORRY I RETURN ON MY SUPERB MACHINA : MY AMIGA 500.....   '
	DC.B      '                                              '

; Tomchi
	DC.B      'TOMCHI SUPERPRO-MEGATIZER SAID :'
	DC.B      ' WHAT DO YOU WANT ME TO DO WITH THAT FU..BEEP.. KEYBOARD ? AHEM .. HELLO'
	DC.B      ' LADIES AND GENTLEMEN ! THIS IS TOMCHI WONDERING WHAT TO TELL YOU.'
	DC.B      ' WELL, LET',$27,'S START WITH THE BASIS: I AM THE LATEST MEMBER OF NOEXTRA, YOU'
	DC.B      ' PROBABLY DON',$27,'T KNOW ME UNLESS YOU GAVE A GO TO MY OLDCKOOL SCREENS.'
	DC.B      ' NOEXTRA GUYS HELPED ME IN ACHEIVING THIS PROJECT AND AS IT SEEMS THEY',$27,'RE'
	DC.B      ' DEF, THEY ENGAGED ME AS A CHIPMUSIC MAN IN THE TEAM ! JOKE ASIDE, I AM'
	DC.B      ' VERY HAPPY OF THE TRUST THEY PUT IN ME. THE TUNE YOU',$27,'RE LISTENNING TO WAS'
	DC.B      ' COMPOSED USING MEGATIZER 2.4, THE ONLY CHIPTRACKER I HAVE USED YET'
	DC.B      ' INCLUDING THE 2.95 VERSION TOO. WHAT ELSE ? WELL, I JUST KEEP ON SWITCHING'
	DC.B      ' MY ATARI ON JUST FOR THE FUN OF IT SO I DO HOPE THAT YOU LIKE WHAT YOU'
	DC.B      ' HEAR ! TOMCHI SIGNING OFF .........                                         '
	DC.B      '                                              '
	
; Atomus
	DC.B      'AFTER ALL MEMBERS TEXTS, I (ATOMUS) WANT TO ADD SOME PERSONAL GREETINGS TO :'
	DC.B      ' THE BYTE/TCE FOR ASK US THE FRIST TO MAKE SOME MENU-COMPILATIONS FOR HIM, THANKS A LOT TORSTEN !'
	DC.B      ' THE ATARILEGEND TEAM : I LIKE TO SEE OUR INTROS WITH YOUR RARE GAMES, THANKS GUYS TO WORK WITH US SINCE A LONG TIME !'
	DC.B      ' GT TURBO/CV : THERE',$27,'S A LONG TIME WHEN I TALK WITH YOU GT TURBO, I NEED TIME TO VISIT FORUMS BUT I DON',$27,'T'
	DC.B      ' KNOW WHY TO LOOK SULKY WITH ZORRO 2 ?'
	DC.B      ' SHW/D-BUG : PHIL, WILL YOU KNOW THAT OUR CREW MAKE THE INTRO OF OUR COMPILE NUMBER XXXX ? IT WILL BE VERY FUNNY TO DO THAT ;)'
	DC.B      ' EVIL/DHS : THE CREW IS VERY SATISFIED TO HAVE PARTICIPATED AT HIS FIRST MEGADEMO FOR THE ATARI ST TWENTY YEAR'
	DC.B      ' CELEBRATION COMPO, MANY THANKS EVIL !'
	DC.B      ' MAARTAU : THANKS A LOT GUY, YOUR LAST SENDING IS VERY COOL, MANY THANKS !!!'
	DC.B      '                                              '
	DC.B      'AND I KEEP A LITTLE MOMENT FOR OUR MEMBER CREW : '
	DC.B      ' THANKS FREDDO FOR HIS COMPLICITY, WE ARE OLD FRIENDS BUT I',$27,'M AN AMIGA FANA FIRST !'
	DC.B      ' HE WAS VERY DISAPOINTED SINCE HIS LAST AFFAIR WITH HIS OLD BOSS OF OLD CREW.'
	DC.B      ' HE CAN',$27,'T FINISH LIKE THAT AND IT',$27,'S FOR THAT WE DECIDED TO CREATE THE CREW NOEXTRA TOGETHER.'
	DC.B      ' FREDERICO AKA F.F. JOIN THE CREW FASTLY BECAUSE HE STILL MADE SOME LOGOS FOR THE OLD SUCKING CREW.'
	DC.B      ' HE RENAME HIS PESUDO BY MISTER.A BECAUSE ZORRO 2 ALWAYS TALK BY HELLO MISTER...'
	DC.B      ' FINALLY, FREDDO WHO LIKE DCK PROGRAMER FOUND ON TOMCHI THE REAL FEELING THAT THE CREW'
	DC.B      ' NEED TO MAKE ATARI STUFF ALL THE TIME ! HE MADE SOME SO MUSICS THAT NOW WE NEED TIME TO MAKE SOME'
	DC.B      ' RELEASES TO GO AROUND :)                     I THANKS ALL THE MEMBERS !                          '
	DC.B      '                                              '
	DC.B      ' NOW IT',$27,'S TIME FOR THE PUB AND THE REST OF THE TEXT........................... '
;	
	DC.B      '                                              '
	DC.B      'A NOEXTRA PRODUCTION 2007 - HTTP://WWW.NOEXTRA-TEAM.COM/ - CONTACT0NOEXTRA-TEAM.COM                  '
	DC.B      'MEMBERS ARE ATOMUS AND ZORRO 2 FOR THE ASM/ROUTS CODE, MISTER.A FOR THE GRAPHISM AND TOMCHI FOR THE BEST MUSIC.'
	DC.B      '                            '
	DC.B      'THIS COMPILE WAS DONE IN JANUARY 2008 AND WORK ON ATARI STF AND ATARI STE .'
	DC.B      'FOR THE RESTS OF ATARI MACHINE, YOU CAN TESTED ON THEM AND DON',$27,'T FORGET THAT',$27,'S THIS COMPILE NEED A BLITTER SOMETIMES ? '
	DC.B      '                                                           '
	DC.B      'OK ! LET',$27,'S WRAPP THE SCROLLTEXT....                                                           '
	
	dc.b $ff
	even

font	
	dcb.b	DEPTH*4,0
	incbin	1PLANE.FNT
	even

font_offsets
;          !  "  #  $  %  &  '  (  )  *  +  ,  -  .  /
 dc.b	0,46,48,00,00,00,00,48,41,42,44,00,27,43,28,45

;        0  1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ?  @
 dc.b	31,32,33,34,35,36,37,38,39,40,30,29,00,00,00,47,00

;        A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q
 dc.b	01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17

;        R  S  T  U  V  W  X  Y  Z  [  \  ]  ^  _  `  a  b  c
 dc.b	18,19,20,21,22,23,24,25,26,41,00,42,00,00,48,01,02,03

;        d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u
 dc.b	04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21

;        v  w  x  y  z
 dc.b	22,23,24,25,26
	even

IMG_LOGO:
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0055,$00CC,$003C,$0003,$52AA,$CCCC,$3F0F,$FFF0
		dc.w	$8100,$C300,$0080,$0000,$AA90,$6660,$E1F0,$1FF0
		dc.w	$000A,$0019,$0007,$0000,$A800,$9800,$8400,$7C00
		dc.w	$5552,$CCCC,$3C3F,$03FF,$AA81,$CCC3,$0F00,$F000
		dc.w	$4002,$0002,$C002,$0001,$A955,$6666,$1F87,$FFF8
		dc.w	$4080,$6180,$8000,$0000,$02AA,$0199,$0387,$007F
		dc.w	$5550,$9998,$E1E0,$FE00,$2A00,$6600,$1E00,$0000
		dc.w	$01A0,$039F,$017F,$00FF,$0005,$FFF9,$FFFE,$FFFF
		dc.w	$4B00,$8741,$0040,$FF81,$0008,$FFF8,$FFF0,$FFF8
		dc.w	$0014,$0073,$004F,$003F,$0002,$FE11,$FE10,$FE0F
		dc.w	$A000,$9FFF,$7FFF,$FFFF,$054A,$F986,$FE01,$FFFF
		dc.w	$6008,$200B,$A00F,$C007,$0002,$FFFC,$FFFF,$FFFF
		dc.w	$A4C0,$C3A0,$00E0,$FF00,$0000,$07FF,$03FF,$07FF
		dc.w	$00A9,$FF30,$FFC0,$FFFF,$5300,$CE80,$3C00,$FF80
		dc.w	$0280,$0780,$0500,$0300,$0000,$0000,$0000,$0000
		dc.w	$0002,$0043,$0003,$0061,$8004,$8008,$0008,$000C
		dc.w	$00A0,$00E0,$00C0,$0040,$0108,$0238,$0310,$0300
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3012,$201E,$000C,$301C,$0000,$0000,$0000,$0000
		dc.w	$0000,$0060,$0040,$0070,$0A00,$0E00,$0C00,$0400
		dc.w	$0000,$0000,$0000,$0000,$0000,$0180,$01C0,$01C0
		dc.w	$0800,$0C00,$0E00,$0400,$0000,$0000,$0000,$0000
		dc.w	$00C0,$00C1,$00C1,$0003,$0002,$0006,$8006,$0004
		dc.w	$0100,$0180,$01C0,$0080,$000C,$010C,$0108,$0300
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$4000,$4010,$4038,$2030,$0000,$0000,$0000,$0000
		dc.w	$0000,$0018,$0010,$0018,$0000,$0400,$0600,$0C00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0060,$0060,$0060
		dc.w	$1400,$1BFF,$1C00,$0800,$0000,$FFFF,$0000,$0000
		dc.w	$0102,$FD01,$0101,$0083,$8001,$7FFA,$8003,$0002
		dc.w	$0280,$037F,$0380,$0100,$010A,$F80F,$0100,$0304
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFE,$0000,$0000
		dc.w	$8010,$802F,$8070,$4060,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFE8,$000C,$000C,$0A00,$05FF,$0600,$0C00
		dc.w	$0000,$FFFF,$0000,$0000,$0010,$FFA0,$0030,$0030
		dc.w	$27FF,$2FFF,$1800,$1000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FA02,$FA01,$0201,$0103,$7FFC,$7FFC,$8001,$0001
		dc.w	$84FF,$87FF,$0700,$0200,$F804,$F800,$0107,$0302
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFD,$FFFD,$0001,$0000
		dc.w	$001F,$007F,$0060,$80C0,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFF0,$FFF6,$0006,$0006,$01FF,$0FFF,$0600,$0C00
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFC8,$FFD8,$0010,$0018
		dc.w	$0800,$1800,$1FFF,$3000,$0000,$0000,$FFFF,$0000
		dc.w	$0401,$0401,$F400,$0201,$C000,$0000,$FFFE,$8000
		dc.w	$0A00,$8E00,$0FFF,$8400,$0403,$0402,$F403,$0201
		dc.w	$8000,$0000,$FFFF,$0000,$0002,$0002,$FFFA,$0001
		dc.w	$00A0,$0060,$00FF,$00C0,$0000,$0000,$FFFF,$0000
		dc.w	$0000,$0002,$FFF2,$0006,$0A00,$0E00,$07FF,$0C00
		dc.w	$0000,$0000,$FFFF,$0000,$0000,$0000,$FFC8,$0018
		dc.w	$2FFF,$0000,$6FFF,$3000,$FFFF,$0000,$FFFF,$0000
		dc.w	$E800,$0800,$E800,$0400,$DFFF,$2000,$FFFF,$C000
		dc.w	$13FF,$9800,$1BFF,$4C00,$E801,$0800,$E800,$0401
		dc.w	$BFFF,$4000,$FFFF,$8000,$FFF4,$0004,$FFF4,$0002
		dc.w	$013F,$0080,$00BF,$01C0,$FFFF,$0000,$FFFF,$0000
		dc.w	$FFF8,$0006,$FFFB,$0003,$01FF,$0400,$0DFF,$0E00
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFE0,$0018,$FFE8,$000C
		dc.w	$5000,$2FFF,$6FFF,$3000,$0000,$FFFF,$FFFF,$0000
		dc.w	$1000,$D000,$D000,$0800,$3000,$5FFF,$7FFF,$6000
		dc.w	$4800,$F7FF,$B7FF,$3800,$1000,$D000,$D000,$0800
		dc.w	$E000,$BFFF,$7FFF,$C000,$0008,$FFE8,$FFE8,$0004
		dc.w	$0040,$01BF,$00BF,$01C0,$0000,$FFFF,$FFFF,$0000
		dc.w	$0005,$FFFC,$FFF9,$0003,$0A00,$05FF,$0DFF,$0E00
		dc.w	$0000,$FFFF,$FFFF,$0000,$0014,$FFF0,$FFE0,$000C
		dc.w	$0FFF,$7FFF,$6FFF,$3000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$A000,$E000,$A000,$1000,$17FF,$27FF,$37FF,$3800
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$A000,$E000,$A000,$1000
		dc.w	$6FFF,$0FFF,$6FFF,$7000,$FFD0,$FFF0,$FFD0,$0008
		dc.w	$013F,$01FF,$00BF,$01C0,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFFC,$FFFD,$FFFF,$0001,$81FF,$0FFF,$0DFF,$8E00
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$FFE0,$FFE0,$FFF0,$000C
		dc.w	$5000,$7003,$6003,$3FFC,$0000,$FFFF,$FFFF,$0000
		dc.w	$C000,$C000,$4000,$2000,$0C00,$0000,$1800,$1FFF
		dc.w	$0000,$0000,$0000,$FFFF,$C000,$C000,$4000,$2000
		dc.w	$1800,$27C0,$37C0,$383F,$0060,$0FE0,$0FA0,$F010
		dc.w	$0140,$01BF,$00BF,$01C0,$0000,$FFFF,$FFFF,$0000
		dc.w	$0002,$E000,$E002,$1FFD,$0200,$8E00,$0C00,$8FFF
		dc.w	$0000,$FFFF,$FFFF,$0000,$0014,$8004,$8014,$7FE8
		dc.w	$0FFB,$2003,$3007,$7FF8,$D40A,$E619,$F807,$0000
		dc.w	$8000,$8000,$8000,$4000,$05FF,$0A00,$0400,$0FFF
		dc.w	$FFFE,$0000,$0001,$FFFE,$8000,$8000,$8000,$4000
		dc.w	$1FDF,$07C0,$1FE0,$183F,$E2C0,$19C0,$1FC0,$E020
		dc.w	$007F,$003F,$00FF,$00C0,$EA05,$F30C,$FC03,$0000
		dc.w	$6FFC,$F002,$E002,$1FFD,$81FE,$0C01,$0E01,$8FFE
		dc.w	$015F,$C33F,$80FF,$0000,$BFE0,$C014,$8014,$7FE8
		dc.w	$500D,$2FFD,$300C,$7FF3,$542A,$6666,$781E,$8001
		dc.w	$8000,$0000,$0000,$8000,$0300,$01FF,$0200,$07FF
		dc.w	$0003,$FFFD,$0003,$FFFC,$0000,$0000,$0000,$8000
		dc.w	$0D20,$0EDF,$0060,$0FFF,$1A80,$FA40,$1A00,$E5C0
		dc.w	$000A,$0073,$007C,$007F,$AA15,$3333,$3C0F,$C000
		dc.w	$5802,$07FE,$3802,$FFFD,$0201,$0DFF,$0E01,$8FFE
		dc.w	$8555,$0CCC,$C3C3,$003F,$601C,$9FF8,$E01C,$FFE0
		dc.w	$0FF2,$7FF2,$3000,$7FFE,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$017F,$037F,$0280,$01FF
		dc.w	$FFFA,$FFFE,$0006,$FFF9,$0000,$0000,$0000,$0000
		dc.w	$001F,$007F,$0060,$00FF,$E000,$E000,$0000,$FC00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$07FC,$1FFC,$3800,$3FFF,$81FE,$8FFE,$8E00,$0FFF
		dc.w	$0000,$4000,$8000,$0000,$1FE0,$FFE8,$E00C,$FFF0
		dc.w	$400A,$7000,$3FF0,$7FFE,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00C0,$0000,$017F,$00FF
		dc.w	$000C,$000C,$FFFC,$FFF2,$0000,$0000,$0000,$0000
		dc.w	$0080,$00E0,$00FF,$007F,$1400,$0000,$E000,$FC00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$2002,$1800,$3FFC,$3FFF,$0001,$8E00,$8FFE,$0FFF
		dc.w	$8000,$C000,$0000,$0000,$001C,$E004,$FFE8,$FFF0
		dc.w	$0FF0,$3008,$7FF0,$7FFE,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$005F,$00E0,$007F,$003F
		dc.w	$FFE8,$0008,$FFE8,$FFF4,$0000,$0000,$0000,$0000
		dc.w	$005F,$00A0,$00FF,$007F,$E000,$1400,$E000,$FC00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$07FD,$3803,$3FFD,$3FFE,$89FE,$0601,$8FFE,$0FFF
		dc.w	$C000,$C000,$0000,$0000,$1FE0,$E014,$FFE8,$FFF0
		dc.w	$400A,$3FFA,$7FF3,$7FFC,$8100,$C300,$0080,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$001F,$001F,$003F
		dc.w	$0030,$FFD0,$FFD0,$FFE8,$0000,$0000,$0000,$0000
		dc.w	$0080,$003F,$00FF,$007F,$1400,$F400,$E000,$FC00
		dc.w	$0055,$0066,$0007,$0078,$40AA,$6199,$8078,$0007
		dc.w	$C002,$BFFF,$7FFD,$FFFE,$0001,$07FF,$8FFE,$0FFF
		dc.w	$2AA9,$2666,$DE1F,$01FF,$0018,$FFFC,$FFE0,$FFF0
		dc.w	$0009,$7FFB,$7FF2,$7FFF,$4B00,$8740,$0040,$FF80
		dc.w	$0000,$0000,$0000,$0000,$0020,$003F,$000F,$001F
		dc.w	$0060,$FFA0,$FFA0,$FFD0,$0000,$0000,$0000,$0000
		dc.w	$0040,$007F,$00BF,$007F,$1000,$F000,$E400,$FC00
		dc.w	$0002,$00FC,$00FF,$00FF,$A540,$C33F,$00FF,$FFFF
		dc.w	$0003,$FFFE,$FFFD,$FFFE,$8801,$8FFF,$07FE,$0FFF
		dc.w	$5000,$0FFF,$7FFF,$FFFF,$801C,$7FFC,$FFE0,$FFF0
		dc.w	$0000,$7FFF,$7FFF,$7FFF,$0080,$FF40,$FF00,$FFE0
		dc.w	$0000,$0000,$0000,$0000,$0010,$0007,$001F,$000F
		dc.w	$00C0,$FF40,$FF40,$FFA0,$0000,$0000,$0000,$0000
		dc.w	$0080,$00FF,$003F,$007F,$1400,$F000,$E400,$FC00
		dc.w	$0100,$00FF,$01FF,$01FF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$0002,$FFFC,$FFFD,$FFFE,$0000,$8FFF,$07FF,$0FFF
		dc.w	$0001,$FFFE,$FFFE,$FFFF,$0010,$FFF0,$FFEC,$FFF0
		dc.w	$0000,$7FFF,$7FFF,$7FFF,$01C0,$FEC0,$FEC0,$FF00
		dc.w	$0000,$0000,$0000,$0000,$000C,$000B,$000F,$0007
		dc.w	$0180,$FE80,$FE80,$FF40,$0000,$0000,$0000,$0000
		dc.w	$0000,$00FF,$003F,$007F,$1000,$F400,$E400,$FC00
		dc.w	$0000,$00FF,$01FF,$01FF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$0004,$FFFC,$FFFA,$FFFC,$0800,$07FF,$07FF,$0FFF
		dc.w	$0003,$FFFD,$FFFD,$FFFE,$001C,$7FF0,$7FEC,$FFF0
		dc.w	$0FFF,$7000,$7FFF,$7FFF,$FD00,$0100,$FD00,$FE80
		dc.w	$0000,$0000,$0000,$0000,$0002,$0005,$0007,$0007
		dc.w	$FD00,$0300,$FD00,$FE80,$0000,$0000,$0000,$0000
		dc.w	$005F,$00E0,$003F,$007F,$E000,$1400,$E400,$FC00
		dc.w	$013F,$01C0,$00FF,$01FF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFFB,$0007,$FFF8,$FFFC,$01FF,$0600,$07FF,$0FFF
		dc.w	$FFFA,$0002,$FFFA,$FFFD,$9FE0,$601C,$FFEC,$FFF0
		dc.w	$0000,$7000,$7FFF,$7FFF,$0600,$0600,$FE00,$F900
		dc.w	$0000,$0000,$0000,$0000,$0000,$000E,$000F,$000F
		dc.w	$0100,$0080,$FE80,$FFC0,$0000,$0000,$0000,$0000
		dc.w	$0080,$00A0,$007F,$007F,$1000,$0400,$E400,$FC00
		dc.w	$0000,$01C0,$00FF,$01FF,$0000,$0000,$FFFF,$FFFF
		dc.w	$0007,$0007,$FFFC,$FFF8,$0800,$0E00,$0FFF,$07FF
		dc.w	$000C,$000C,$FFFC,$FFF2,$801C,$600C,$7FEC,$FFF0
		dc.w	$0FFF,$7FFF,$7000,$7FFF,$F400,$FC00,$0C00,$F200
		dc.w	$0000,$0000,$0000,$0000,$0003,$001F,$001C,$001F
		dc.w	$FF00,$FF60,$0060,$FFC0,$0000,$0000,$0000,$0000
		dc.w	$005F,$003F,$00E0,$007F,$E000,$E400,$0400,$FC00
		dc.w	$013F,$00FF,$00C0,$01FF,$FFFF,$FFFF,$0000,$FFFF
		dc.w	$FFF4,$FFF4,$0000,$FFF8,$05FF,$0BFF,$0E00,$07FF
		dc.w	$FFE8,$FFF8,$0018,$FFE4,$1FE0,$7FE0,$6000,$FFFC
		dc.w	$4000,$3000,$7FFF,$7FFF,$1800,$1800,$F800,$E400
		dc.w	$0000,$0000,$0000,$0000,$0000,$0038,$003F,$003F
		dc.w	$0060,$0000,$FFB0,$FFE0,$0000,$0000,$0000,$0000
		dc.w	$0080,$0060,$00FF,$007F,$1000,$0400,$E400,$FC00
		dc.w	$0000,$00C0,$00FF,$01FF,$0000,$0000,$FFFF,$FFFF
		dc.w	$000A,$0008,$FFFE,$FFF0,$0800,$0200,$0FFF,$07FF
		dc.w	$0030,$0030,$FFF0,$FFC8,$8014,$E000,$FFE0,$7FFC
		dc.w	$0FFF,$3000,$7FFF,$7FFF,$D000,$1000,$D000,$E800
		dc.w	$0000,$0000,$0000,$0000,$000F,$0070,$007F,$007F
		dc.w	$FFD0,$0038,$FFC0,$FFF0,$0000,$0000,$0000,$0000
		dc.w	$001F,$00E0,$00FF,$007F,$E000,$1400,$E400,$FC00
		dc.w	$013F,$01C0,$01FF,$00FF,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FFE0,$0004,$FFE8,$FFF0,$05FF,$0600,$0BFF,$07FF
		dc.w	$FFA0,$0020,$FFA0,$FFD0,$5FE0,$A014,$FFE0,$7FFC
		dc.w	$4000,$7FFF,$3FFF,$7FFF,$6000,$A000,$A000,$D000
		dc.w	$0000,$0000,$0000,$0000,$0000,$00FF,$00FF,$00FF
		dc.w	$0018,$FFF0,$FFE0,$FFF8,$0000,$0000,$0000,$0000
		dc.w	$0080,$00FF,$00FF,$007F,$1400,$F000,$E400,$FC00
		dc.w	$0080,$017F,$01FF,$00FF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$0020,$FF88,$FFD0,$FFE0,$0800,$0FFF,$03FF,$07FF
		dc.w	$00C0,$FF40,$FF40,$FFA0,$8014,$3FF4,$FFE0,$7FFC
		dc.w	$0000,$7FF8,$3FFF,$7FFF,$C000,$4000,$4000,$A000
		dc.w	$0000,$0000,$0000,$0000,$0000,$01FF,$01FF,$01FF
		dc.w	$0008,$FFF8,$FFF0,$FFFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$007F,$007F,$00FF,$1000,$F000,$E400,$FC00
		dc.w	$0100,$007F,$01FF,$00FF,$0000,$E3FF,$FFFF,$FFFF
		dc.w	$00C0,$F850,$FF00,$FF80,$0000,$0FFF,$03FF,$07FF
		dc.w	$0180,$0080,$FE80,$FF40,$4010,$7FF0,$BFE4,$7FFC
		dc.w	$400E,$3FFD,$3FF7,$7FF8,$8000,$8000,$8000,$4000
		dc.w	$0000,$0000,$0000,$0000,$0000,$03FF,$03FF,$03FF
		dc.w	$0005,$FFFF,$FFF8,$FFFE,$0000,$0000,$0000,$0000
		dc.w	$0080,$007F,$007F,$00FF,$1400,$F400,$E000,$FC00
		dc.w	$0080,$00FF,$017F,$00FF,$3C00,$FFFF,$DFFF,$E3FF
		dc.w	$0C20,$FC00,$F420,$F800,$0401,$0FFF,$03FE,$07FF
		dc.w	$FF00,$FF00,$FF00,$0080,$8014,$FFF0,$3FE4,$7FFC
		dc.w	$000A,$3FF8,$3FF0,$7FFF,$8000,$0000,$0000,$8000
		dc.w	$0000,$0000,$0000,$0000,$0000,$07FF,$07FF,$07FF
		dc.w	$0002,$FFFE,$FFFD,$FFFF,$8000,$0000,$8000,$0000
		dc.w	$0000,$00FF,$007F,$00FF,$1000,$F400,$E000,$FC00
		dc.w	$0100,$01FF,$007F,$00FF,$2200,$EDFF,$CFFF,$FFFF
		dc.w	$0600,$FC80,$F800,$FE00,$0801,$0BFF,$07FE,$07FF
		dc.w	$0A00,$7300,$7C00,$FF00,$0010,$FFF4,$3FE4,$7FFC
		dc.w	$4FF2,$7008,$7FF0,$3FFE,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$01FF,$0E00,$0FFF,$0FFF
		dc.w	$FFFE,$0001,$FFFE,$FFFF,$4000,$C000,$C000,$8000
		dc.w	$009F,$00E0,$007F,$00FF,$E400,$1000,$E000,$FC00
		dc.w	$003F,$01C0,$007F,$00FF,$C17F,$2A80,$CBFF,$FBFF
		dc.w	$FD00,$0280,$FC00,$FF00,$05FE,$0201,$0FFE,$07FF
		dc.w	$0000,$4000,$4000,$C000,$5FE0,$E014,$3FE4,$7FFC
		dc.w	$2008,$5002,$7FF0,$3FFE,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$1C00,$1FFF,$1FFF
		dc.w	$0000,$0000,$FFFF,$FFFF,$A000,$4000,$4000,$E000
		dc.w	$0000,$0060,$00FF,$00FF,$1000,$0000,$E000,$FC00
		dc.w	$0080,$01C0,$007F,$00FF,$20C0,$0900,$C9FF,$F9FF
		dc.w	$0180,$0080,$FE40,$FF80,$0801,$0600,$0FFE,$07FF
		dc.w	$0000,$4000,$4000,$C000,$8010,$A004,$7FE4,$7FFC
		dc.w	$4FF2,$1FF2,$7000,$3FFE,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$07FF,$3FFF,$3800,$3FFF
		dc.w	$FFFF,$CFFF,$0000,$FFFF,$9000,$B000,$2000,$F000
		dc.w	$009F,$007F,$00E0,$00FF,$E400,$E400,$0400,$F800
		dc.w	$013F,$017F,$00C0,$00FF,$C05F,$C81F,$08E0,$F8FF
		dc.w	$FF40,$FF20,$0060,$FFC0,$01FE,$0FFE,$0E00,$07FF
		dc.w	$0000,$4000,$4000,$C000,$5FE0,$3FE4,$E004,$7FFC
		dc.w	$3009,$2FF9,$500A,$3FF7,$4AA0,$3320,$FC20,$FFC0
		dc.w	$0000,$0000,$0000,$0000,$1000,$6FFF,$7000,$7FFF
		dc.w	$7800,$BFFF,$7000,$8FFF,$2800,$F000,$3800,$D800
		dc.w	$0020,$00DF,$00E0,$00FF,$1000,$F400,$1400,$E800
		dc.w	$00C0,$003F,$01C0,$00FF,$2030,$E85F,$2820,$D87F
		dc.w	$0040,$FFE0,$0060,$FFB0,$0A01,$0DFF,$0E01,$07FE
		dc.w	$4000,$0000,$4000,$C000,$A010,$5FF4,$E014,$7FEC
		dc.w	$4FF8,$6007,$1007,$3FFB,$0030,$FFC0,$FFD0,$FFE0
		dc.w	$0000,$0000,$0000,$0000,$1FFF,$C000,$E000,$FFFF
		dc.w	$63FF,$7400,$D000,$0FFF,$E000,$1C00,$1C00,$EC00
		dc.w	$001F,$00C0,$00E0,$00FF,$EC00,$1800,$1C00,$E000
		dc.w	$013F,$0080,$01C0,$00FF,$C017,$2808,$2810,$D83F
		dc.w	$FFC0,$0038,$0030,$FFD8,$01FE,$0401,$0601,$0FFE
		dc.w	$0000,$0000,$4000,$C000,$1FE0,$C014,$E014,$7FEC
		dc.w	$1000,$7000,$0000,$3FFF,$0028,$0018,$0020,$FFD0
		dc.w	$0000,$0001,$0001,$0001,$4001,$C001,$8000,$FFFE
		dc.w	$C600,$C400,$8400,$03FF,$0800,$0400,$0E00,$F600
		dc.w	$0020,$00E0,$00C0,$00FF,$1000,$0800,$1C00,$E000
		dc.w	$0040,$01C0,$0180,$00FF,$200C,$0818,$2810,$D80F
		dc.w	$0010,$0008,$001C,$FFEC,$0A01,$0600,$0401,$0FFE
		dc.w	$4000,$4000,$0000,$C000,$A014,$E000,$C014,$7FEC
		dc.w	$2FFF,$7FFF,$0FFF,$3000,$FFE0,$FFE8,$FFF0,$0008
		dc.w	$0000,$0003,$0001,$0003,$7FFD,$FFFF,$7FFD,$8000
		dc.w	$82FF,$84FF,$00FF,$0300,$F800,$FB00,$FE00,$0300
		dc.w	$001F,$00FF,$00DF,$00E0,$EC00,$E400,$F800,$0000
		dc.w	$013F,$01FF,$01BF,$00C0,$C805,$C001,$E809,$1806
		dc.w	$FFF0,$FFF6,$FFFE,$0006,$01FE,$0FFE,$05FF,$0E00
		dc.w	$0000,$4000,$0000,$C000,$1FE0,$7FE0,$5FF4,$E00C
		dc.w	$5000,$4FFF,$2FFF,$3000,$0008,$FFF8,$FFF0,$0004
		dc.w	$0002,$0003,$0001,$0003,$8003,$7FFB,$7FFA,$8000
		dc.w	$0180,$01FF,$02FF,$0100,$0500,$FD00,$F800,$0300
		dc.w	$0020,$00DF,$00DF,$00E0,$1000,$F400,$E800,$0000
		dc.w	$0040,$00BF,$00BF,$01C0,$2003,$E007,$C803,$1800
		dc.w	$0005,$FFFE,$FFFB,$0003,$0A01,$0DFF,$05FE,$0E00
		dc.w	$4000,$0000,$0000,$C000,$A014,$5FF4,$5FE0,$E00C
		dc.w	$6FFF,$5000,$1FFF,$2000,$FFFA,$0005,$FFF8,$0002
		dc.w	$0000,$0001,$0003,$0003,$7FF6,$0006,$7FF4,$8000
		dc.w	$00BF,$0140,$01FF,$0080,$F800,$0500,$F800,$0300
		dc.w	$001F,$00C0,$00DF,$00E0,$E800,$0C00,$E000,$0000
		dc.w	$013F,$0080,$00BF,$01C0,$C800,$2800,$C000,$1801
		dc.w	$7FF8,$8005,$FFF9,$0003,$01FE,$0401,$0DFE,$0E00
		dc.w	$0000,$0000,$0000,$C000,$1FE0,$C014,$5FE0,$E00C
		dc.w	$1800,$2800,$3FFF,$1000,$0001,$0001,$FFFC,$0001
		dc.w	$0002,$0001,$8003,$0003,$800C,$800C,$FFE8,$0000
		dc.w	$0060,$0000,$007F,$00C0,$0100,$0000,$F800,$0300
		dc.w	$00A0,$0060,$00FF,$00C0,$1000,$1000,$C000,$0000
		dc.w	$0040,$01C0,$00FF,$0180,$0001,$0801,$C000,$1800
		dc.w	$4001,$8000,$7FF9,$8003,$0A00,$0600,$0FFE,$0C00
		dc.w	$4000,$4000,$4000,$8000,$A004,$E000,$7FE0,$C00C
		dc.w	$07FF,$27FF,$3800,$1000,$FFFE,$FFFE,$0000,$0000
		dc.w	$8000,$4003,$C003,$8003,$7FD8,$FFD8,$8010,$0000
		dc.w	$002F,$004F,$0030,$0060,$F800,$F800,$0000,$0300
		dc.w	$001F,$007F,$00E0,$00C0,$D000,$D000,$0800,$0000
		dc.w	$013F,$01FF,$00C0,$0180,$C800,$C000,$0000,$1800
		dc.w	$9FF8,$1FF8,$E001,$4003,$01FE,$0FFE,$0E00,$0C00
		dc.w	$0000,$4000,$4000,$8000,$1FE0,$7FE0,$E000,$C00C
		dc.w	$0C00,$07FF,$0800,$1800,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$4003,$4003,$6003,$8030,$7FB0,$8020,$0000
		dc.w	$0018,$000F,$0030,$0030,$0100,$F900,$0100,$0200
		dc.w	$00A0,$00DF,$0060,$00C0,$2000,$A000,$0000,$0000
		dc.w	$0040,$00BF,$01C0,$0180,$0000,$C000,$0000,$1800
		dc.w	$7001,$5FF9,$6000,$2003,$0200,$0DFE,$0E00,$0C00
		dc.w	$C000,$8000,$C000,$0000,$A004,$5FE4,$E004,$C008
		dc.w	$0600,$0A00,$0400,$0C00,$0000,$0000,$0000,$0000
		dc.w	$0000,$3003,$2003,$3003,$0060,$0060,$8040,$0000
		dc.w	$000C,$0014,$0018,$0018,$0000,$0100,$0100,$0200
		dc.w	$0000,$00C0,$0060,$00C0,$4000,$4000,$0000,$0000
		dc.w	$0100,$0080,$01C0,$0180,$0800,$0800,$0800,$1000
		dc.w	$3800,$0801,$1000,$3003,$0000,$0C00,$0E00,$0C00
		dc.w	$0000,$8000,$C000,$0000,$0000,$C004,$E004,$C008
		dc.w	$0780,$0580,$0300,$0600,$0000,$0000,$0000,$0000
		dc.w	$0000,$1003,$1803,$1803,$80C0,$80C0,$0080,$0000
		dc.w	$0006,$000A,$000C,$000C,$0300,$0200,$0300,$0000
		dc.w	$0061,$0061,$0000,$00C0,$0000,$0000,$0000,$0000
		dc.w	$0140,$00C0,$0180,$0180,$0000,$0800,$0800,$1000
		dc.w	$1C01,$1400,$0800,$1803,$0200,$0E00,$0C00,$0C00
		dc.w	$C000,$4000,$8000,$0000,$200C,$E008,$C00C,$C000
		dc.w	$02FF,$017F,$03FF,$0380,$502B,$9867,$E01F,$0000
		dc.w	$E000,$E000,$E001,$1001,$FA80,$FC80,$7F00,$8000
		dc.w	$0001,$0001,$0007,$0006,$EA00,$F200,$FC00,$0000
		dc.w	$0040,$0008,$0060,$0000,$0000,$0000,$8000,$0000
		dc.w	$007F,$00BF,$00FF,$00C0,$A000,$C000,$F000,$0000
		dc.w	$07FE,$03FE,$0FFE,$0C00,$03EA,$03F3,$05FC,$0600
		dc.w	$0000,$0000,$0000,$0000,$3FA8,$5FC8,$7FF0,$6000
		dc.w	$00D5,$0019,$00E1,$00FE,$50AA,$9999,$E078,$0007
		dc.w	$A000,$8000,$6000,$E000,$2A00,$CC00,$0F00,$F000
		dc.w	$0000,$0003,$0000,$0003,$A800,$3000,$3C00,$C000
		dc.w	$0030,$0038,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$006A,$000C,$0070,$007F,$A000,$C000,$E000,$0000
		dc.w	$00A8,$0730,$07C0,$07FC,$00AA,$0333,$003C,$03C0
		dc.w	$0000,$0000,$0000,$0000,$0AA0,$0CC0,$30F0,$3F00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0033,$00F0,$000F,$0000,$3333,$F0F0,$F00F,$0FFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0005,$FFF9,$FFFE,$FFFF
		dc.w	$5500,$9980,$1E19,$E019,$0000,$1080,$8F18,$8F18
		dc.w	$0000,$0010,$198F,$198F,$0000,$9000,$0F0C,$0F0C
		dc.w	$0066,$01E1,$001F,$0000,$6666,$E1E1,$E01F,$1FFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0005,$FFF9,$FFFE,$FFFF
		dc.w	$5519,$9999,$1E00,$E019,$9998,$9998,$0000,$9998
		dc.w	$1999,$1999,$0000,$1999,$980C,$980C,$0000,$980C
		dc.w	$00CC,$03C3,$003F,$0000,$CCCC,$C3C3,$C03F,$3FFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0005,$FFF9,$FFFE,$FFFF
		dc.w	$5500,$9999,$1E00,$E019,$0000,$9998,$0000,$9998
		dc.w	$0000,$1999,$0000,$1999,$0000,$9E0C,$0000,$9E0C
		dc.w	$0199,$0787,$007F,$0000,$9998,$8787,$807F,$7FFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$ABBB,$5444,$FFFF,$FFFF,$B8E5,$4719,$FFFE,$FFFF
		dc.w	$5519,$9980,$1E00,$E019,$9999,$0000,$0000,$9999
		dc.w	$9999,$0000,$0000,$9999,$980C,$0000,$0000,$980C
		dc.w	$0333,$0F0F,$00FF,$0000,$3330,$0F0F,$00FF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$E008,$1FF7,$FFFF,$FFFF,$0825,$F7D9,$FFFE,$FFFF
		dc.w	$5500,$9980,$1E00,$E019,$0000,$0000,$0000,$9999
		dc.w	$0000,$0000,$0000,$9999,$0000,$0000,$0000,$998C
		dc.w	$0666,$1E1E,$01FE,$0001,$6660,$1E1F,$01FF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$AB8B,$5474,$FFFF,$FFFF,$30E5,$CF19,$FFFE,$FFFF
		dc.w	$5519,$9999,$1E19,$E000,$9999,$9999,$9999,$0000
		dc.w	$9999,$9999,$9999,$0000,$998C,$998C,$998C,$0000
		dc.w	$0CCC,$3C3C,$03FC,$0003,$CCC0,$3C3F,$03FF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$A88A,$5775,$FFFF,$FFFF,$28A5,$D759,$FFFE,$FFFF
		dc.w	$5500,$9999,$1E19,$E000,$0000,$9999,$9999,$0000
		dc.w	$0000,$9999,$9999,$0000,$0000,$998C,$998C,$0000
		dc.w	$1999,$7878,$07F8,$0007,$9980,$787F,$07FF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$0000,$FFFF,$FFFF,$FFFF,$0000,$FFFF,$FFFF,$FFFF
		dc.w	$AB8B,$5474,$FFFF,$FFFF,$AAA5,$5559,$FFFE,$FFFF
		dc.w	$551F,$9990,$1E0F,$E000,$9F9F,$9090,$0F0F,$0000
		dc.w	$9F99,$1000,$8F99,$0000,$9F8C,$1000,$8F8C,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

Pal_LogIntro:
		dc.w	$0110,$0fff,$0990,$0220,$02A8,$0AA8,$0338,$03B8
		dc.w	$0B48,$0448,$04C1,$0C51,$05D1,$0D69,$06E2,$0777

LogIntro:
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$2A00,$4C00,$7000,$7FFF,$0000,$0000,$0000,$FFFF
		dc.w	$0000,$0000,$0000,$FFFF,$0080,$0080,$0080,$FF00
		dc.w	$1500,$2600,$3800,$3FFF,$0000,$0000,$0000,$FFFF
		dc.w	$0000,$0000,$0000,$FFFF,$0040,$0040,$0040,$FF80
		dc.w	$0A80,$1300,$1C00,$1FFF,$0000,$0000,$0000,$FFFF
		dc.w	$0000,$0000,$0000,$FFFF,$0020,$0020,$0020,$FFC0
		dc.w	$0540,$0980,$0E00,$0FFF,$0000,$0000,$0000,$FFF8
		dc.w	$1000,$1000,$1000,$0FFF,$0010,$0010,$0010,$FFE0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$4000,$3FFF,$7FFF,$4000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0080,$FF00,$FF80,$0000
		dc.w	$2000,$1FFF,$3FFF,$2000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0040,$FF80,$FFC0,$0000
		dc.w	$1000,$0FFF,$1FFF,$1000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0020,$FFC0,$FFE0,$0000
		dc.w	$0800,$07FF,$0FFF,$0800,$0000,$FFF0,$FFF0,$0008
		dc.w	$1000,$0FFF,$1FFF,$0000,$0010,$FFE0,$FFF0,$0000
		dc.w	$0000,$6300,$6300,$6300,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$3FFF,$7FFF,$4000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$1FFF,$3FFF,$2000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$0FFF,$1FFF,$1000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$07FF,$0FFF,$0800,$0007,$FFF0,$FFF0,$0008
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$7700,$7700,$7700,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$4000,$7FFF,$3FFF,$4000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$2000,$3FFF,$1FFF,$2000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$1000,$1FFF,$0FFF,$1000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0800,$0FFF,$07FF,$0800,$0007,$FFF0,$FFF0,$0008
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$7F00,$7F00,$7F00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$3FFF,$3FFF,$4000,$03FF,$FC00,$FFFF,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$1FFF,$1FFF,$2000,$01FF,$FE00,$FFFF,$0000
		dc.w	$C000,$3FFF,$FFFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$0FFF,$0FFF,$1000,$00FF,$FF00,$FFFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFFC,$0000,$FFE0,$0000
		dc.w	$0000,$07FF,$07FF,$0800,$0007,$FFF0,$FFF0,$0008
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$6B00,$6B00,$6B00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$02FF,$FD00,$FE00,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$017F,$FE80,$FF00,$0000
		dc.w	$C000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$00BF,$FF40,$FF80,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFC,$0000,$0000,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$0007,$FFF0,$FFF0,$0008
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$6300,$6300,$6300,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$037F,$FD80,$FE00,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$01BF,$FEC0,$FF00,$0000
		dc.w	$C000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$00DF,$FF60,$FF80,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFC,$0000,$0000,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$0007,$FFF0,$FFF0,$0008
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$6000,$6000,$6000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$02A0,$FCC0,$FF00,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$0150,$FE60,$FF80,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$00A8,$FF30,$FFC0,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$0007,$FFF0,$FFF0,$0008
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$6300,$6300,$6300,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0270,$FD40,$FF80,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$0138,$FEA0,$FFC0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$009C,$FF50,$FFE0,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$0007,$FFF0,$FFF0,$0008
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$6000,$6000,$6000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0238,$FC80,$FEC0,$0100
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$011C,$FE40,$FF60,$0080
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0080,$FF00,$FF80,$007F
		dc.w	$0000,$0000,$0000,$FFFF,$0000,$0000,$0000,$F000
		dc.w	$0000,$07FF,$07FF,$0000,$0000,$FFF0,$FFF0,$000F
		dc.w	$1000,$0FFF,$1FFF,$E000,$001E,$FFE0,$FFE0,$0000
		dc.w	$0000,$0700,$0700,$0700,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0138,$FE40,$FF40,$0080
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$009C,$FF20,$FFA0,$0040
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$1000,$E000,$F000,$0000
		dc.w	$0000,$03FF,$03FF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003E,$FFC0,$FFC0,$0000
		dc.w	$0000,$6300,$6300,$6300,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$00B8,$FF00,$FF80,$0040
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$005C,$FF80,$FFC0,$0020
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$1E00,$E000,$F000,$0000
		dc.w	$0000,$07FF,$07FF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$001C,$FFE0,$FFE0,$0000
		dc.w	$0000,$0300,$0300,$0300,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$00FF,$FF00,$FFFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FE00,$0000,$F000,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFFF,$0000
		dc.w	$F000,$0FFF,$FFFF,$0000,$0018,$FFE0,$FFF0,$0000
		dc.w	$0000,$7F00,$7F00,$7F00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$00BF,$FF40,$FF80,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0000,$0000,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$F000,$0FFF,$1FFF,$0000,$001C,$FFE0,$FFF0,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$00DF,$FF60,$FF80,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$0000,$0000,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$F000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$3F00,$3F00,$3F00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$00A8,$FF30,$FFC0,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$7000,$7000,$7000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$009C,$FF50,$FFE0,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$3E00,$3E00,$3E00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0080,$FF00,$FF80,$007F
		dc.w	$0000,$0000,$0000,$FFFF,$0000,$0020,$0020,$FFC0
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$0300,$0300,$0300,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0020,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$6700,$6700,$6700,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$3E00,$3E00,$3E00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$0600,$0600,$0600,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$5F00,$5F00,$5F00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$0600,$0600,$0600,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$0600,$0600,$0600,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$0600,$0600,$0600,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$7600,$7600,$7600,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$3C00,$3C00,$3C00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$3E00,$3E00,$3E00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$6700,$6700,$6700,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$7F00,$7F00,$7F00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$6000,$6000,$6000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$6300,$6300,$6300,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$3E00,$3E00,$3E00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$7E00,$7E00,$7E00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$6300,$6300,$6300,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$6900,$6900,$6900,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$6300,$6300,$6300,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$7E00,$7E00,$7E00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$6200,$6200,$6200,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$6000,$6000,$6000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$6200,$6200,$6200,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$4000,$3FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$003F,$FFC0,$FFFF,$0000
		dc.w	$C000,$3FFF,$FFFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$7E00,$7E00,$7E00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$7F00,$7F00,$7F00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$2700,$2700,$2700,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$7FFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$8000,$7FFF,$FFFF,$0000,$00F0,$FF00,$FF80,$0000
		dc.w	$0000,$3FFF,$3FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0078,$FF80,$FFC0,$0000
		dc.w	$0000,$1FFF,$1FFF,$0000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$003C,$FFC0,$FFE0,$0000
		dc.w	$0000,$0FFF,$0FFF,$0000,$000F,$FFF0,$FFF8,$0000
		dc.w	$1000,$0FFF,$1FFF,$0000,$001E,$FFE0,$FFF0,$0000
		dc.w	$0000,$2300,$2300,$2300,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3FFF,$7FFF,$4000,$0000,$FFF8,$FFC0,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFF0,$FF00,$0080,$0000
		dc.w	$1FFF,$3FFF,$2000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFF8,$FF80,$0040,$0000
		dc.w	$0FFF,$1FFF,$1000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FFFF,$FFFF,$0000,$0000,$FFFC,$FFC0,$0020,$0000
		dc.w	$07FF,$0FFF,$0800,$0000,$FFFF,$FFF8,$0000,$0000
		dc.w	$1FFF,$1FFF,$0000,$0000,$FFFE,$FFE0,$0010,$0000
		dc.w	$0000,$2700,$2700,$2700,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0FFF,$0000,$0000,$0000,$FFF8,$0000,$0000,$0000
		dc.w	$1FFF,$0000,$0000,$0000,$FFF0,$0000,$0000,$0000
		dc.w	$07FF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFF8,$0000,$0000,$0000
		dc.w	$03FF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFC,$0000,$0000,$0000
		dc.w	$01FF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$03FF,$0000,$0000,$0000,$FFFE,$0000,$0000,$0000
		dc.w	$0000,$7F00,$7F00,$7F00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0FFF,$0000,$0000,$0000,$FFF8,$0000,$0000,$0000
		dc.w	$1FFF,$0000,$0000,$0000,$FFF0,$0000,$0000,$0000
		dc.w	$07FF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFF8,$0000,$0000,$0000
		dc.w	$03FF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFC,$0000,$0000,$0000
		dc.w	$01FF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$03FF,$0000,$0000,$0000,$FFFE,$0000,$0000,$0000
		dc.w	$0000,$7E00,$7E00,$7E00,$0000,$0000,$0000,$0000
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
		dc.w	$0000,$0000,$000E,$000E,$0000,$0000,$E7F3,$E7F3
		dc.w	$000C,$0008,$F9F8,$F9F0,$0092,$0010,$0071,$0061
		dc.w	$4000,$4000,$CEB9,$8EB9,$0000,$0000,$D73A,$D73A
		dc.w	$0063,$0022,$E03E,$E01C,$3198,$1108,$1F0F,$0E07
		dc.w	$0000,$0000,$CEE7,$CEE7,$0019,$0010,$F3F0,$F3E0
		dc.w	$8000,$8000,$FC01,$7C01,$00C0,$0040,$FC7E,$FC3E
		dc.w	$6032,$2010,$3F1D,$1F0D,$60C0,$4040,$C07E,$803E
		dc.w	$6332,$2210,$3E1D,$1C0D,$6000,$4000,$C000,$8000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$000E,$000E,$0000,$0000,$E1C0,$E1C0
		dc.w	$0004,$0004,$E1DC,$E1D8,$0092,$0082,$00E3,$0061
		dc.w	$4000,$0000,$8EB9,$8EB9,$0000,$0000,$D73A,$D73A
		dc.w	$0041,$0041,$E077,$E036,$2090,$2090,$3B9D,$1B0D
		dc.w	$0000,$0000,$CEE1,$CEE1,$0009,$0009,$C3B9,$C3B0
		dc.w	$0000,$0000,$DC00,$DC00,$0080,$0080,$70EE,$706E
		dc.w	$4020,$4020,$773A,$371A,$2080,$2080,$E0EE,$C06E
		dc.w	$4120,$4120,$773A,$361A,$2000,$2000,$E000,$C000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$000E,$000E,$0000,$0000,$E1C0,$E1C0
		dc.w	$0000,$0000,$E1DC,$E1DC,$0124,$0020,$00E3,$00C3
		dc.w	$8000,$8000,$8EB9,$0EB9,$0000,$0000,$D73A,$D73A
		dc.w	$0000,$0000,$E077,$E077,$0000,$0000,$3B9D,$3B9D
		dc.w	$0000,$0000,$CEE1,$CEE1,$0000,$0000,$C3B9,$C3B9
		dc.w	$0000,$0000,$DC00,$DC00,$0000,$0000,$70EE,$70EE
		dc.w	$0000,$0000,$773A,$773A,$0000,$0000,$E0EE,$E0EE
		dc.w	$0000,$0000,$773A,$773A,$0000,$0000,$E000,$E000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$000E,$000E,$0000,$0000,$E1C0,$E1C0
		dc.w	$0004,$0004,$E1DC,$E1D8,$C124,$0104,$C1C7,$C0C3
		dc.w	$8000,$0000,$0EB9,$0EB9,$0000,$0000,$D73A,$D73A
		dc.w	$0000,$0000,$E077,$E077,$0000,$0000,$3B9C,$3B9C
		dc.w	$0000,$0000,$0EE1,$0EE1,$0008,$0008,$C3B9,$C3B1
		dc.w	$0000,$0000,$DC00,$DC00,$0000,$0000,$70E0,$70E0
		dc.w	$0000,$0000,$773A,$773A,$0000,$0000,$E0EE,$E0EE
		dc.w	$0000,$0000,$773A,$773A,$0000,$0000,$E000,$E000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$000F,$000F,$0000,$0000,$E1C0,$E1C0
		dc.w	$000C,$0008,$E1F8,$E1F0,$C249,$0041,$C1C7,$C186
		dc.w	$0000,$0000,$0EB9,$0EB9,$0000,$0000,$D73A,$D73A
		dc.w	$0000,$0000,$E077,$E077,$0000,$0000,$3B9E,$3B9E
		dc.w	$0000,$0000,$07C1,$07C1,$0018,$0010,$C3F1,$C3E1
		dc.w	$0000,$0000,$FCF8,$FCF8,$0000,$0000,$70F0,$70F0
		dc.w	$0000,$0000,$7F3A,$7F3A,$0000,$0000,$E0E0,$E0E0
		dc.w	$0000,$0000,$773A,$773A,$0000,$0000,$E000,$E000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$000E,$000E,$0000,$0000,$E1C0,$E1C0
		dc.w	$0000,$0000,$E1C0,$E1C0,$0249,$0208,$038E,$0186
		dc.w	$0000,$0000,$0EB9,$0EB9,$0000,$0000,$D73A,$D73A
		dc.w	$0000,$0000,$E077,$E077,$0000,$0000,$3B9C,$3B9C
		dc.w	$0000,$0000,$0EE1,$0EE1,$0008,$0008,$C3B9,$C3B1
		dc.w	$0000,$0000,$DCF8,$DCF8,$0000,$0000,$70E0,$70E0
		dc.w	$0000,$0000,$773A,$773A,$0000,$0000,$E0EE,$E0EE
		dc.w	$0000,$0000,$773A,$773A,$0000,$0000,$E000,$E000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$000E,$000E,$0000,$0000,$E1C0,$E1C0
		dc.w	$0000,$0000,$E1C0,$E1C0,$C492,$0082,$C38E,$C30C
		dc.w	$0000,$0000,$0EB9,$0EB9,$0000,$0000,$D73A,$D73A
		dc.w	$0000,$0000,$E077,$E077,$0000,$0000,$3B9D,$3B9D
		dc.w	$0000,$0000,$CEE1,$CEE1,$0000,$0000,$C3B9,$C3B9
		dc.w	$0000,$0000,$DC00,$DC00,$0000,$0000,$70EE,$70EE
		dc.w	$0000,$0000,$773A,$773A,$0000,$0000,$E0EE,$E0EE
		dc.w	$0000,$0000,$773A,$773A,$0000,$0000,$E000,$E000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$000E,$000E,$0000,$0000,$E1C0,$E1C0
		dc.w	$0000,$0000,$E1C0,$E1C0,$C492,$0410,$C71C,$C30C
		dc.w	$0000,$0000,$0EB9,$0EB9,$0000,$0000,$D73A,$D73A
		dc.w	$0000,$0000,$E077,$E077,$0000,$0000,$3B9D,$3B9D
		dc.w	$0000,$0000,$CEE1,$CEE1,$0000,$0000,$C3B9,$C3B9
		dc.w	$0000,$0000,$DC00,$DC00,$0000,$0000,$70EE,$70EE
		dc.w	$0000,$0000,$773A,$773A,$0000,$0000,$E0EE,$E0EE
		dc.w	$0000,$0000,$773A,$773A,$0000,$0000,$E000,$E000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$000E,$000E,$0000,$0000,$E1C0,$E1C0
		dc.w	$0000,$0000,$E1C0,$E1C0,$0924,$0104,$071C,$0618
		dc.w	$0809,$0809,$0EB9,$06B0,$0120,$0120,$D73A,$D61A
		dc.w	$2000,$2000,$E677,$C677,$2090,$2090,$3B9D,$1B0D
		dc.w	$4000,$4000,$CEE1,$8EE1,$0000,$0000,$C3B9,$C3B9
		dc.w	$0000,$0000,$DC00,$DC00,$0082,$0082,$70EE,$706C
		dc.w	$0000,$0000,$773A,$773A,$0082,$0082,$ECEE,$EC6C
		dc.w	$4100,$4100,$773A,$363A,$0000,$0000,$E000,$E000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$000E,$000E,$0000,$0000,$E1C0,$E1C0
		dc.w	$0000,$0000,$E1C0,$E1C0,$0924,$0820,$0E38,$0618
		dc.w	$0C99,$0410,$0770,$0360,$9332,$8210,$EE1D,$6C0D
		dc.w	$6000,$4000,$C677,$8677,$3198,$1108,$1F0F,$0E07
		dc.w	$C000,$8000,$8EE1,$0EE1,$0000,$0000,$C3B9,$C3B9
		dc.w	$0000,$0000,$DC00,$DC00,$00C6,$0044,$707C,$7038
		dc.w	$0000,$0000,$773A,$773A,$00C6,$0044,$EC7C,$EC38
		dc.w	$6300,$2200,$3E3A,$1C3A,$0000,$0000,$E000,$E000
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

Gfx_Loading:
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$C07C,$C07C,$C07C,$C07C,$38F8,$38F8,$38F8,$38F8
		dc.w	$FEC6,$FEC6,$FEC6,$FEC6,$7C00,$7C00,$7C00,$7C00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$C0C6,$C0C6,$C0C6,$C0C6,$7CCC,$7CCC,$7CCC,$7CCC
		dc.w	$38E6,$38E6,$38E6,$38E6,$C000,$C000,$C000,$C000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$C0C6,$C0C6,$C0C6,$C0C6,$6CC6,$6CC6,$6CC6,$6CC6
		dc.w	$38F6,$38F6,$38F6,$38F6,$DC00,$DC00,$DC00,$DC00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$C0C6,$C0C6,$C0C6,$C0C6,$C6C6,$C6C6,$C6C6,$C6C6
		dc.w	$38DE,$38DE,$38DE,$38DE,$C200,$C200,$C200,$C200
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FEFE,$FEFE,$FEFE,$FEFE,$DEFE,$DEFE,$DEFE,$DEFE
		dc.w	$FECE,$FECE,$FECE,$FECE,$C200,$C200,$C200,$C200
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FEFE,$FEFE,$FEFE,$FEFE,$DEFE,$DEFE,$DEFE,$DEFE
		dc.w	$FEC6,$FEC6,$FEC6,$FEC6,$FE00,$FE00,$FE00,$FE00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FEFE,$FEFE,$FEFE,$FEFE,$DEFE,$DEFE,$DEFE,$DEFE
		dc.w	$FEC6,$FEC6,$FEC6,$FEC6,$FEDB,$FEDB,$FEDB,$FEDB
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$7C7C,$7C7C,$7C7C,$7C7C,$DEFE,$DEFE,$DEFE,$DEFE
		dc.w	$FEC6,$FEC6,$FEC6,$FEC6,$7CDB,$7CDB,$7CDB,$7CDB
						
MUSIC:
; INIT = start + 0	; d0 = 1 start music
; VBL  = start + 8
; OFF  = start + 4  	; Need this if tune is digi & chip
	incbin	*.thk	;
	even
	
******************************************************************

	SECTION	BSS

bss_start:

********* GRAND SCROLLING ***********************************>>>
char_offset:
	ds.w	1
********* GRAND SCROLLING ***********************************<<<

********* PETIT SCROLLING ***********************************>>>
BUFFER:
deb_BUF:
	ds.b	41
milieu_BUF:
	ds.b	1
fin_BUF:
	ds.b	3494
********* PETIT SCROLLING ***********************************<<<

Vsync:	ds.b	1
	ds.b	1

Save_stack:	
	ds.l	1

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

Zorro_scr1:	
	ds.l	1

Zorro_screen1:
	ds.b	256
start1:	
	ds.b	160*40
	ds.b	160*200
	ds.b	160*40
Zorro_screen1_len:	equ	*-start1

Zorro_scr2:
	ds.l	1

Zorro_screen2:	
	ds.b	256
start2:	
	ds.b	160*40
	ds.b	160*200
	ds.b	160*40
Zorro_screen2_len:	equ	*-start2

fix_bug_screen:
	ds.b	160*50

********* LOGO DISTORT *******************************>>>
buffer_de_fin:
	ds.b	10000
********* LOGO DISTORT *******************************<<<

bss_end:

******************************************************************
	END
******************************************************************
