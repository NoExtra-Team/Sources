* BSW_136.PRG

* // Code & Ripp  	: Zorro2/MjjProd		// *
* // Loader 		: Atomus/NoExtra		// *
* // Gfx neochrome master: Mister. A/NoExtra		// *
* // Music 		: Shaft - Xerus spirits dentro	// *
* // Optimisation	: Gt_Turbo/Cerebral Vortex	// *
* // Release date 	: 13/03/2005			// *

***********************************************
	opt	o-,d-
***********************************************

	SECTION	TEXT

***********************************************
SEEMYVBL      equ	0	;	0 = ligne blanche & 1 = rien
gemdos        equ	1
crawcin       equ	7
cconws        equ	9
mshrink       equ	$4a
pexec         equ	$4b
***********************************************

DEBUT
	jmp	Start

*****************************************************************

RUN
									bsr	BYEBYE

RESERVE_MEMOIRE									
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

EXECUTE
									move.w	#$19,-(a7)		* Dgetdrive
									trap	#1							* Recup le num‚ro
									addq.w	#2,a7				  * du lecteur actif
									and.w	#$f,d0					* 0=A, B=1, etc...
									add.b	#"A",d0					* Additionne la lettre
									move.b	d0,Emp			  * et on modifie Emp
																				* pour qu'il pointe le bon
																				* lecteur
									pea	Emp
									move.w #$3b,-(sp)
									trap #1
									addq.w	#6,a7

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

error:					  pea        errtext       ;Affichage du message d'erreur
							    move.w     #cconws,-(sp)
					        trap       #gemdos
					        addq.l     #6,sp
					
					        move.w     #crawcin,-(sp)          ;Attendre appui touche...
					        trap       #gemdos
					        addq.l     #2,sp

									jmp	Fin

EXIT  						bsr				BYEBYE
FIN	
									move.l	Save_stack,-(sp)
									move.w	#32,-(sp)
									trap	#1
									addq.l	#6,sp

			            CLR.W     -(A7) 	;PTERM0
                  TRAP      #1

									*  FIN  *

music							INCBIN	"lack_of.snd"
									even

BYEBYE
								  moveq #0,d0
								  bsr music			; desactivate first tune
	
				          move.b 	#8,$ffff8800.w        ; Sound OFF
				          move.b 	#0,$ffff8802.w
				          move.b 	#9,$ffff8800.w
				          move.b 	#0,$ffff8802.w
				          move.b 	#$a,$ffff8800.w
			 	          move.b 	#0,$ffff8802.w

		  						bsr	RestoreVBI
                  
                  MOVEA.L   $44E.W,A0 
                  MOVE.W    #$1F3F,D0 
.loop2:           CLR.L     (A0)+ 
                  DBF       D0,.loop2

                	move.b	Video,$ffff8260.w
                	move.w	#$25,-(a7)
                	trap	#14
                	addq.w	#2,a7
                	
                	move.b	Video,$ffff8260.w
                
                	move.b	#$8,$fffffc02.w	* Retablit la souris	
                	DC.W $A000
                	DC.W $A009
                
                	move.b	conterm,$484.w	; Remettre ce bidule.

									RTS

*****************************************************************
																		
Start:
									clr.l	-(sp)
									move.w	#32,-(sp)
									trap	#1
									addq.l	#6,sp
									move.l	d0,Save_stack

                	move.b	$484.w,conterm	; Sauve ce bidule.
                	clr.b	$484.w		; No bip,no repeat.
                	
                	move.b	#$12,$fffffc02.w	* Couic la souris	
                	DC.W $A000
                	DC.W $A00A

                  MOVEA.L   $44E.W,A0 
                  MOVE.W    #$1F3F,D0 
.loop3:           CLR.L     (A0)+ 
                  DBF       D0,.loop3
*-->
	move.l	#Zorro_screen1,d0
	add.w	#$ff,d0
	sf	d0
	move.l	d0,Zorro_scr1

	move.l	#Zorro_screen2,d0
	add.w	#$ff,d0
	sf	d0
	move.l	d0,Zorro_scr2

	move.l	#Zorro_screen3,d0
	add.w	#$ff,d0
	sf	d0
	move.l	d0,Zorro_scr3
	
	movea.l	Zorro_scr1,a6
	move.w	#Zorro_screen1_len/4-1,d1
fill1:
	move.l	#$0,(a6)+
	dbra	d1,fill1

	movea.l	Zorro_scr2,a6
	move.w	#Zorro_screen2_len/4-1,d1
fill2:
	move.l	#$0,(a6)+
	dbra	d1,fill2

	movea.l	Zorro_scr3,a6
	move.w	#Zorro_screen3_len/4-1,d1
fill3:
	move.l	#$0,(a6)+
	dbra	d1,fill3
	
*<--	
		  						bsr	SaveVBI
									bsr	fadein

								  moveq #1,d0
								  bsr music			; activate first tune
	
	lea	Vbl0(pc),a0
	move.l	a0,$70.w

	movea.l	Zorro_scr3,a1
	adda.l	#160*76,a1
	movea.l	#LogoNoeXtra,a0
	move.l	#7999-6800+180,d0
aff:	move.l	(a0)+,(a1)+
	dbf	d0,aff

	move.l	Zorro_scr3,d0
	move.b	d0,d1
	lsr.w	#8,d0
	move.b	d0,$ffff8203.w
	swap	d0
	move.b	d0,$ffff8201.w
	move.b	d1,$ffff820d.w
	
	lea     PalNoeXtra,a2
	bsr     fadeon	

                	movem.l	a0-a6/d0-d7,-(sp)
                	bsr	Genere_code
                	movem.l	(sp)+,a0-a6/d0-d7

                  LEA       PIC,A0
									move.l	Zorro_scr1,a1
                  MOVE.W    #$1F3F,D0 
.duplic1:         MOVE.L    (A0)+,(A1)+ 
                  DBF       D0,.duplic1 
                  
                  LEA       PIC,A0
									move.l	Zorro_scr2,a1
                  MOVE.W    #$1F3F,D0 
.duplic2:         MOVE.L    (A0)+,(A1)+ 
                  DBF       D0,.duplic2

									move.l	Zorro_scr1,SCREEN
									bsr	texto
									
									move.l	Zorro_scr2,SCREEN
									bsr	texto

	bsr	delay

	bsr     fadeoff

	move.l	Zorro_scr1,d0
	move.b	d0,d1
	lsr.w	#8,d0
	move.b	d0,$ffff8203.w
	swap	d0
	move.b	d0,$ffff8201.w
	move.b	d1,$ffff820d.w
	
	lea	GO_RASTER,a0
	st	(a0)
	
	bsr	Wait_Vbl                

                	movem.l	a0-a6/d0-d7,-(sp)

                	lea	Vbl(pc),a0
                	move.l	a0,$70.w

                  MOVEM.L   PAL_PIC,D0-D7 
                  MOVEM.L   D0-D7,$FFFF8240.W 

                	movem.l	(sp)+,a0-a6/d0-d7

MAINLOOP:

                	IFEQ	SEEMYVBL
                	clr.w	$ffff8240.w
                	ENDC
                	
									CMPI.W    #$B,OBJ_OFF 
                  BEQ.S     SKIP
                  ADDQ.W    #1,OBJ_OFF
SKIP:             CLR.W     VBLFLAG 

									move.l	Zorro_scr2,a0
                  LEA     160*17-16*2(A0),A0 		**** position de la partie a effacer !!!
									moveq	#0,d0
									jsr Code_gen
                  
                  bSR       ROTATE
                  CLR.L     LINE_VAR
                  LEA       OBJ_OFF,A0
									lea				Tab_160,a4
                  MOVE.W    (A0),D0 
LN_LOOP:          MOVE.L    D0,-(A7)
                  MOVEQ     #0,D0 
                  MOVEQ     #0,D1 
                  MOVEQ     #0,D2 
                  MOVEQ     #0,D3 
                  MOVEQ     #0,D4 
                  MOVEQ     #0,D5 
                  MOVEQ     #0,D6 
                  MOVEQ     #0,D7 
                  LEA       MAPP,A0
                  ADDA.W    LINE_VAR,A0 
                  MOVEA.L   (A0),A1 
                  MOVE.W    (A1),D0 
                  MOVE.W    2(A1),D1
                  MOVEA.L   4(A0),A1
                  MOVE.W    (A1),D2 
                  MOVE.W    2(A1),D3
                  CMP.W     D0,D2 
                  BGT.S     XOK 
                  EXG       D2,D0 
                  EXG       D3,D1 
XOK:              CMP.W     D1,D3 
                  BGT.S     YOK 
                  EXG       D3,D1 
                  MOVE.W    D3,D7 
									add.w	d7,d7
									move.w	0(a4,d7.w),YPOS
                  MOVE.W    #1,UP_DN
                  BRA.S     EYFX
YOK:              MOVE.W    D1,D7 
									add.w	d7,d7
									move.w	0(a4,d7.w),YPOS
                  MOVE.W    #0,UP_DN
EYFX:             MOVE.W    D0,D7 
									add.w	d7,d7
                  MOVE.W    D7,XPOS
                  SUB.W     D0,D2 
                  SUB.W     D1,D3 
                  MOVE.W    D2,D7 
                  MOVE.W    D3,D6                 
                  DIVS      D6,D7 
                  CMPI.W    #1,UP_DN
                  BEQ.S     OPPOVER 
                  CMP.W     #1,D7 
                  BLT.S     UNDER 
                  bSR       OVER45N
                  BRA.S     END_LINE
UNDER:            bSR       UNDER45N
                  BRA.S     END_LINE
OPPOVER:          CMP.W     #1,D7 
                  BLT.S     UNDER2
                  bSR       OVER45O
                  BRA.S     END_LINE
UNDER2:           bSR       UNDER45O
END_LINE:         ADDQ.W    #8,LINE_VAR 
                  MOVE.L    (A7)+,D0
                  DBF       D0,LN_LOOP

									move.l	Zorro_scr1,d0
									move.l	Zorro_scr2,Zorro_scr1
									move.l	d0,Zorro_scr2

									move.l	Zorro_scr1,d0		;set screen address
									move.b	d0,d1			;
									lsr.w	#8,d0			;
									move.b	d0,$ffff8203.w		;
									swap	d0			;
									move.b	d0,$ffff8201.w		;

WAIT:             CMPI.W    #1,VBLFLAG
                  BNE.S     WAIT
KEYBOARD:
* -->
									cmpi.b	#$3B,$FFFFFC02.w	*	F1
									beq.s	Run1
									cmpi.b	#$3C,$FFFFFC02.w	*	F2
									beq.s	Run2
									cmpi.b	#$3D,$FFFFFC02.w	*	F3
									beq.s	Run3
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
									cmpi.b	#$39,$FFFFFC02.w	*	ESP
									beq	RunCrc
									cmpi.b	#$01,$fffffc02.w	* ESC
									beq	EXIT
* <--

                	IFEQ	SEEMYVBL
                	cmp.b	#$38,$fffffc02.w	* Wait
                	bne.s	Suite_rout		* Alt
                	move.b	#$7,$ffff8240.w
Suite_rout:	
                	ENDC 

									BRA       MAINLOOP

Run1:							move.l	#PROG1,NOMPRG
									bra	RUN
Run2:							move.l	#PROG2,NOMPRG
									bra	RUN
Run3:							move.l	#PROG3,NOMPRG
									bra	RUN
Run4:							move.l	#PROG4,NOMPRG
									bra	RUN
Run5:							move.l	#PROG5,NOMPRG
									bra	RUN
Run6:							move.l	#PROG6,NOMPRG
									bra	RUN
Run7:							move.l	#PROG7,NOMPRG
									bra	RUN
Run8:							move.l	#PROG8,NOMPRG
									bra	RUN
Run9:							move.l	#PROG9,NOMPRG
									bra	RUN
RunCRC:						move.l	#PROGCRC,NOMPRG
									bra	RUN
									
Genere_code:	movem.l	d0-d7/a0-a6,-(a7)
							lea Code_gen,a0
							move.w	#166,d7
							moveq	#0,d4
Genere_pour_toutes_les_lignes:					
							moveq	#12-1,d6
							move.w	d4,d5
							add.w	#38,d5	
Genere_une_ligne:
							move.w	#$3140,(a0)+		* Genere un move.w  d0,$xx(a0)
							move.w	d5,(a0)+				* et voila l'offset $xx
							addq.w	#8,d5
							dbra	d6,Genere_une_ligne
							add.w	#160,d4
							dbra	d7,Genere_pour_toutes_les_lignes
							move.w	#$4e75,(a0)			* Et un RTS !!
							lea	Tab_160,a0
							move.w	#199,d7
							moveq	#0,d0
Genere_table_ligne_160:
							move.w	d0,(a0)+
							add.w	#160,d0
							dbra	d7,Genere_table_ligne_160
							movem.l	(a7)+,d0-d7/a0-a6
							rts

fadein
								 	move.l	#$777,d0
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

								  moveq	#0,d0
								  lea	$fffffa00.w,a0
									sf	$07(a0)
									sf	$09(a0)
									sf	$13(a0)
									sf	$15(a0)

								  bclr	#3,$fffffa17.w

								  sf	$ffff8260.w
								  sf	$fffffa21.w
								  sf	$fffffa1b.w
								  bset	#0,$fffffa07.w	* Timer B on
								  bset	#0,$fffffa13.w	* Timer B on

                  MOVE      #$2300,SR 

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

Scrolling
									cmpi.w	#8,compteur
									blt.b	nonew
									bsr	put_texte
nonew							lea	buffer1,a3
									movea.l	a3,a0
									addq.w	#1,compteur
									lea	buffer2,a1
									moveq	#7,d7
.loop0						lsl.w	(a0)+
									addq.l	#2,a0
									roxl.w	$98(a1)
									roxl.w	$90(a1)
									roxl.w	$88(a1)
									roxl.w	$80(a1)
									roxl.w	$78(a1)
									roxl.w	$70(a1)
									roxl.w	$68(a1)
									roxl.w	$60(a1)
									roxl.w	$58(a1)
									roxl.w	$50(a1)
									roxl.w	$48(a1)
									roxl.w	$40(a1)
									roxl.w	$38(a1)
									roxl.w	$30(a1)
									roxl.w	$28(a1)
									roxl.w	$20(a1)
									roxl.w	$18(a1)
									roxl.w	$10(a1)
									roxl.w	8(a1)
									roxl.w	(a1)
									lea	$a0(a1),a1
									dbra	d7,.loop0
									lea	buffer2,a0
									move.l	Zorro_scr2,a1
									lea	160*200(a1),a1						*** ICI !!!
									moveq	#6,d7
.loop1						move.w	(a0),(a1)
									move.w	8(a0),8(a1)
									move.w	$10(a0),$10(a1)
									move.w	$18(a0),$18(a1)
									move.w	$20(a0),$20(a1)
									move.w	$28(a0),$28(a1)
									move.w	$30(a0),$30(a1)
									move.w	$38(a0),$38(a1)
									move.w	$40(a0),$40(a1)
									move.w	$48(a0),$48(a1)
									move.w	$50(a0),$50(a1)
									move.w	$58(a0),$58(a1)
									move.w	$60(a0),$60(a1)
									move.w	$68(a0),$68(a1)
									move.w	$70(a0),$70(a1)
									move.w	$78(a0),$78(a1)
									move.w	$80(a0),$80(a1)
									move.w	$88(a0),$88(a1)
									move.w	$90(a0),$90(a1)
									move.w	$98(a0),$98(a1)
									lea	$a0(a0),a0
									lea	$a0(a1),a1
									dbra	d7,.loop1
									rts

put_texte
									moveq	#0,d0
									movea.l	textscroll,a0
									move.b	(a0)+,d0
									tst.b	(a0)
									bne.b	norecharge
									lea	text8_8,a0
norecharge			  move.l	a0,textscroll
									clr.w	compteur
									lea	font8_8,a0
									lea	buffer1,a1
									subi.w	#$20,d0
									lsl.w	#3,d0
									adda.w	d0,a0
									move.b	(a0)+,(a1)+
									clr.b	(a1)+
									addq.w	#2,a1
									move.b	(a0)+,(a1)+
									clr.b	(a1)+
									addq.w	#2,a1
									move.b	(a0)+,(a1)+
									clr.b	(a1)+
									addq.w	#2,a1
									move.b	(a0)+,(a1)+
									clr.b	(a1)+
									addq.w	#2,a1
									move.b	(a0)+,(a1)+
									clr.b	(a1)+
									addq.w	#2,a1
									move.b	(a0)+,(a1)+
									clr.b	(a1)+
									addq.w	#2,a1
									move.b	(a0)+,(a1)+
									clr.b	(a1)+
									addq.w	#2,a1
									move.b	(a0)+,(a1)+
									clr.b	(a1)+
									addq.w	#2,a1
									rts

VBL0:              
                  ADDQ.W    #1,VBLFLAG
	
								  bsr (music+8)

	move.l	a0,-(sp)
  lea	GO_RASTER,a0
  tst.b	(a0)
	beq.s	.suite
								  move.l	#HBL0,$120.w
								  move.b	#103-1,$fffffa21.w
								  move.b	#8,$fffffa1b.w
.suite:
	move.l	(sp)+,a0								  
									RTE 
VBL:              
                  ADDQ.W    #1,VBLFLAG
	
								  bsr (music+8)

								  bsr	Scrolling

								  move.l	#HBL0,$120.w
								  move.b	#103-1,$fffffa21.w
								  move.b	#8,$fffffa1b.w
												
									RTE 

HBL0:							* 104
									sf	$fffffa21.w	* Stop Timer B
									sf	$fffffa1b.w
								
									move.l	#$0010000,$ffff8240.w
								
									move.l	#HBL1,$120.w
									move.b	#1,$fffffa21.w
									move.b	#8,$fffffa1b.w
									rte

HBL1:							* 105
									sf	$fffffa21.w	* Stop Timer B
									sf	$fffffa1b.w
								
									move.l	#$0020000,$ffff8240.w
								
									move.l	#HBL2,$120.w
									move.b	#1,$fffffa21.w
									move.b	#8,$fffffa1b.w
									rte

HBL2:							* 106
									sf	$fffffa21.w	* Stop Timer B
									sf	$fffffa1b.w
								
									move.l	#$88A088A,$ffff8240.w
									
									move.l	#HBL3,$120.w
									move.b	#92,$fffffa21.w
									move.b	#8,$fffffa1b.w
									rte

HBL3:							* 197
									sf	$fffffa21.w	* Stop Timer B
									sf	$fffffa1b.w
								
									move.l	#$0020000,$ffff8240.w
									
									move.l	#HBL4,$120.w
									move.b	#1,$fffffa21.w
									move.b	#8,$fffffa1b.w
									rte

HBL4:							* 198
									sf	$fffffa21.w	* Stop Timer B
									sf	$fffffa1b.w
								
									move.l	#$0010000,$ffff8240.w
								
									move.l	#HBL5,$120.w
									move.b	#1,$fffffa21.w
									move.b	#8,$fffffa1b.w
									
									rte

HBL5:							* 199
									sf	$fffffa21.w	* Stop Timer B
									sf	$fffffa1b.w
								
									move.l	#$0000FFF,$ffff8240.w

									move.l	#HBL,$120.w
									move.b	#1,$fffffa21.w
									move.b	#8,$fffffa1b.w
									
									rte

HBL:							* 200
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
	
texto
									movem.l	mem,d0-a6
									movea.l	SCREEN,a5
									lea	160*14+8*3+2(a5),a5
									lea	txt,a1
chg								move.l	a5,a4
wrp								move.l	a4,a0
									lea	place,a2
									lea	minifonte,a3
									move.b	(a1)+,d0
									beq	bcl1
									cmpi.b	#1,d0
									bne.s	nch
									lea	160*6(a5),a5
									moveq	#0,d5
									bra.s	chg
nch								cmp.b	(a2)+,d0
									beq.s	post				
									addq.l	#4,d6
									bra.s	nch
post							move.l	(a3,d6.w),d0
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
pos1							lsl.w	#4,d0
									lsl.w	#4,d1
									lsl.w	#4,d2
									lsl.w	#4,d3
									lsl.w	#4,d4
pos2							lsl.w	#4,d0
									lsl.w	#4,d1
									lsl.w	#4,d2
									lsl.w	#4,d3
									lsl.w	#4,d4
pos3							lsl.w	#4,d0
									lsl.w	#4,d1
									lsl.w	#4,d2
									lsl.w	#4,d3
									lsl.w	#4,d4
rin								or.w	d4,(a0)
									or.w	d3,160(a0)
									or.w	d2,320(a0)
									or.w	d1,480(a0)
									or.w	d0,640(a0)
									bra	wrp
bcl1
									rts	

adr	equ	-8*4+6
                  
UNDER45N:         MOVE.W    D3,D5 
                  LSL.W     #7,D2 
                  DIVS      D3,D2 
                  MOVE.W    D2,D4 
                  LSR.W     #7,D4 
                  MOVE.W    D4,D6 
                  MOVE.W    D2,D4 
									add.w	d4,d4
                  MOVE.B    D4,D7 
                  MOVEQ     #0,D1 
                  MOVE.W    #$140,D4
                  SUB.W     D5,D4 
                  LEA       MASKS,A0
                  LEA       WORDS,A1
									move.l	Zorro_scr2,a2
                  LEA       adr(A2),A2
                  ADDA.W    YPOS,A2 
                  MULS      #$18,D4 
                  JMP       SLOOPLOO(PC,D4.W) 
SLOOPLOO:         
									ADD.B     D7,D1 
                  ADDX.W    D6,D0 
									add.w	d0,d0

	rept	32
                  MOVE.W    0(A0,D0.W),D3 
                  MOVE.W    0(A1,D0.W),D4 
                  LSR.W     #1,D0 
                  OR.W      D3,0(A2,D4.W) 
                  LEA       160(A2),A2
                  ADD.B     D7,D1 
                  ADDX.W    D6,D0 
									add.w	d0,d0
	endr

	rept	199
                  MOVE.W    0(A0,D0.W),D3 
                  MOVE.W    0(A1,D0.W),D4 
                  LSR.W     #1,D0 
                  OR.W      D3,0(A2,D4.W) 
                  LEA       160(A2),A2
                  ADD.B     D7,D1 
                  ADDX.W    D6,D0 
                  add.w	d0,d0
	endr

	rept	87
                  MOVE.W    0(A0,D0.W),D3 
                  MOVE.W    0(A1,D0.W),D4 
                  LSR.W     #1,D0 
                  OR.W      D3,0(A2,D4.W) 
                  LEA       160(A2),A2
                  ADD.B     D7,D1 
                  ADDX.W    D6,D0 
                  add.w	d0,d0 
	endr	                  
									
                  MOVE.W    0(A0,D0.W),D3 
                  MOVE.W    0(A1,D0.W),D4 
                  LSR.W     #1,D0 
                  OR.W      D3,0(A2,D4.W) 
                  LEA       160(A2),A2
                  RTS 

OVER45N:          MOVE.W    D2,D5 
                  CMP.W     #0,D3 
                  BEQ.S     N_DIVN
                  LSL.W     #7,D3 
                  DIVS      D2,D3 
N_DIVN:           MOVE.W    D3,D4 
                  LSR.W     #7,D4 
                  MOVE.W    D4,D6 
                  MOVE.W    D3,D4 
                  *LSL.W     #1,D4 
                  add.w	d4,d4
                  MOVE.B    D4,D7 
                  EXG       D0,D1 
                  MOVE.W    #$140,D4
                  SUB.W     D5,D4 
                  LEA       MASKS,A0
                  ADDA.W    XPOS,A0 
                  LEA       WORDS,A1
                  ADDA.W    XPOS,A1 
									move.l	Zorro_scr2,a2
                  LEA       adr(A2),A2
                  LEA       Y_TAB,A3
                  MULS      #$16,D4 
                  MOVEQ     #0,D2 
                  JMP       L0017(PC,D4.W)
L0017:            ADD.B     D7,D1 
                  ADDX.W    D6,D0 
                  add.w	d0,d0 

	rept	319
                  MOVE.W    0(A3,D0.W),D5 
                  LSR.W     #1,D0 
                  MOVE.W    (A0)+,D3
                  MOVE.W    (A1)+,D4
                  ADD.W     D5,D4 
                  OR.W      D3,0(A2,D4.W) 
                  ADD.B     D7,D1 
                  ADDX.W    D6,D0 
                  add.w	d0,d0 
	endr

                  MOVE.W    0(A3,D0.W),D5 
                  LSR.W     #1,D0 
                  MOVE.W    (A0)+,D3
                  MOVE.W    (A1)+,D4
                  ADD.W     D5,D4 
                  OR.W      D3,0(A2,D4.W) 
                  RTS 
                  
UNDER45O:         MOVE.W    D3,D5 
                  LSL.W     #7,D2 
                  DIVS      D3,D2 
                  MOVE.W    D2,D4 
                  LSR.W     #7,D4 
                  MOVE.W    D4,D6 
                  MOVE.W    D2,D4 
                  *LSL.W     #1,D4 
                  add.w	d4,d4
                  MOVE.B    D4,D7 
                  MOVEQ     #0,D1 
                  MOVE.W    #$140,D4
                  SUB.W     D5,D4 
                  LEA       MASKS,A0
                  LEA       WORDS,A1
									move.l	Zorro_scr2,a2
                  LEA       adr(A2),A2
                  ADDA.W    YPOS,A2 
                  MULS      #$18,D4 
                  JMP       L0019(PC,D4.W)
L0019:            ADD.B     D7,D1 
                  ADDX.W    D6,D0 
                  add.w	d0,d0 
                  
	rept 319
                  MOVE.W    0(A0,D0.W),D3 
                  MOVE.W    0(A1,D0.W),D4 
                  LSR.W     #1,D0 
                  OR.W      D3,0(A2,D4.W) 
                  LEA       -160(A2),A2 
                  ADD.B     D7,D1 
                  ADDX.W    D6,D0 
                  add.w	d0,d0 
	endr
	
                  MOVE.W    0(A0,D0.W),D3 
                  MOVE.W    0(A1,D0.W),D4 
                  LSR.W     #1,D0 
                  OR.W      D3,0(A2,D4.W) 
                  LEA       -160(A2),A2 
                  RTS 
                  
OVER45O:          MOVE.W    D2,D5 
                  CMP.W     #0,D3 
                  BEQ.S     N_DIVO
                  LSL.W     #7,D3 
                  DIVS      D2,D3 
N_DIVO:           MOVE.W    D3,D4 
                  LSR.W     #7,D4 
                  MOVE.W    D4,D6 
                  MOVE.W    D3,D4 
                  *LSL.W     #1,D4 
                  add.w	d4,d4
                  MOVE.B    D4,D7 
                  MOVE.W    #$140,D4
                  SUB.W     D5,D4 
                  LEA       MASKS,A0
                  ADDA.W    XPOS,A0 
                  LEA       WORDS,A1
                  ADDA.W    XPOS,A1 
                  MOVEQ     #0,D0 
									move.l	Zorro_scr2,a2
                  LEA       adr(A2),A2
                  ADDA.W    YPOS,A2 
                  LEA       Y_TAB,A3
                  MULS      #$16,D4 
                  JMP       L001C(PC,D4.W)
L001C:            
								  ADD.B     D7,D1
                  ADDX.W    D6,D0
                  add.w	d0,d0
                  MOVE.W    0(A3,D0.W),D5
                  LSR.W     #1,D0
                  MOVE.W    (A0)+,D3
                  MOVE.W    (A1)+,D4
                  SUB.W     D5,D4 
                  OR.W      D3,0(A2,D4.W)
                  ADD.B     D7,D1
                  ADDX.W    D6,D0 
                  add.w	d0,d0 
	rept 206
                  MOVE.W    0(A3,D0.W),D5 
                  LSR.W     #1,D0 
                  MOVE.W    (A0)+,D3
                  MOVE.W    (A1)+,D4
                  SUB.W     D5,D4 
                  OR.W      D3,0(A2,D4.W) 
                  ADD.B     D7,D1 
                  ADDX.W    D6,D0 
                  add.w	d0,d0 	
	endr                  

                  MOVE.W    0(A3,D0.W),D5 
                  LSR.W     #1,D0 
                  MOVE.W    (A0)+,D3
                  MOVE.W    (A1)+,D4
L001D:            SUB.W     D5,D4 
                  OR.W      D3,0(A2,D4.W) 
                  ADD.B     D7,D1 
                  ADDX.W    D6,D0 
                  add.w	d0,d0 
                  
	rept 111
                  MOVE.W    0(A3,D0.W),D5 
                  LSR.W     #1,D0 
                  MOVE.W    (A0)+,D3
                  MOVE.W    (A1)+,D4
                  SUB.W     D5,D4 
                  OR.W      D3,0(A2,D4.W) 
                  ADD.B     D7,D1 
                  ADDX.W    D6,D0 
                  add.w	d0,d0 
	endr
	
                  MOVE.W    0(A3,D0.W),D5 
                  LSR.W     #1,D0 
                  MOVE.W    (A0)+,D3
                  MOVE.W    (A1)+,D4
                  SUB.W     D5,D4 
                  OR.W      D3,0(A2,D4.W) 
                  RTS 

ROTATE:           CMPI.W    #$2D0,TELLV 
                  BLT.S     NORESETV
                  CLR.L     TELLV 
NORESETV:         CMPI.W    #$2D0,TELLU 
                  BLT.S     NORESETU
                  CLR.L     TELLU 
NORESETU:         CMPI.W    #$2D0,TELLT 
                  BLT.S     NORESETT
                  CLR.L     TELLT 
NORESETT:         MOVE.W    TELLV,D1
                  LEA       SINUS,A0
                  MOVE.W    0(A0,D1.W),D2 
                  LEA       COSINUS,A0
                  MOVE.W    0(A0,D1.W),D5 
                  MOVEM.W   D5/D2,SAVEV 
                  MOVE.W    TELLU,D1
                  LEA       SINUS,A0
                  MOVE.W    0(A0,D1.W),D2 
                  LEA       COSINUS,A0
                  MOVE.W    0(A0,D1.W),D5 
                  MOVEM.W   D5/D2,SAVEU 
                  MOVE.W    TELLT,D1
                  LEA       SINUS,A0
                  MOVE.W    0(A0,D1.W),D2 
                  LEA       COSINUS,A0
                  MOVE.W    0(A0,D1.W),D5 
                  MOVEM.W   D5/D2,SAVET 
                  LEA       COORDS,A6 
                  
                  LEA       OBJ,A5
                  MOVE.W    (A5)+,D4
BOB_LOOP:         CLR.L     X 
                  CLR.L     Y 
                  CLR.L     Z 
                  MOVE.W    (A5)+,X 
                  MOVE.W    (A5)+,Y 
                  MOVE.W    (A5)+,Z 
                  
                  MOVE.W    X,D2
                  ASL.W     #6,D2 
                  MOVE.W    D2,X
                  
                  MOVE.W    Y,D2
                  ASL.W     #6,D2 
                  MOVE.W    D2,Y
                  
                  MOVE.W    Z,D2
                  ASL.W     #6,D2 
                  MOVE.W    D2,Z
                  
                  MOVEM.W   SAVET,D5/D2 
                  MULS      Y,D5
                  ASR.L     #8,D5 
                  MULS      Z,D2
                  ASR.L     #8,D2 
                  ADD.W     D2,D5 
                  MOVE.L    D5,D0 
                  MOVEM.W   SAVET,D5/D2 
                  MULS      Z,D5
                  ASR.L     #8,D5 
                  MULS      Y,D2
                  ASR.L     #8,D2 
                  SUB.W     D2,D5 
                  MOVE.W    D5,D1 
                  MOVEM.W   SAVEU,D5/D2 
                  MULS      X,D5
                  ASR.L     #8,D5 
                  MULS      D1,D2 
                  ASR.L     #8,D2 
                  SUB.W     D2,D5 
                  MOVE.W    D5,D6 
                  MOVEM.W   SAVEU,D5/D2 
                  MULS      D1,D5 
                  ASR.L     #8,D5 
                  MULS      X,D2
                  ASR.L     #8,D2 
                  ADD.W     D2,D5 
                  MOVE.W    D5,Z
                  MOVEM.W   SAVEV,D5/D2 
                  MULS      D6,D5 
                  ASR.L     #8,D5 
                  MULS      D0,D2 
                  ASR.L     #8,D2 
                  SUB.W     D2,D5 
                  MOVE.W    D5,D7 
                  MOVEM.W   SAVEV,D5/D2 
                  MULS      D0,D5 
                  ASR.L     #8,D5 
                  MULS      D6,D2 
                  ASR.L     #8,D2 
                  ADD.W     D2,D5 
                  MOVE.W    Z,D3
                  ASR.W     #6,D3 
                  ADDI.W    #$100,D3	*	TAILLE DE L'OBJET
                  MULS      D3,D7 
                  ASR.L     #8,D7 
                  ASR.L     #6,D7 
                  ADDI.W    #$A0,D7 
                  MOVE.W    D7,(A6)+
                  MOVE.W    Z,D3
                  ASR.W     #6,D3 
                  ADDI.W    #$100,D3	*	TAILLE DE L'OBJET
                  MULS      D3,D5 
                  ASR.L     #8,D5 
                  ASR.L     #6,D5 
                  ADDI.W    #$64,D5 
                  MOVE.W    D5,(A6)+
                  DBF       D4,BOB_LOOP 
                  ADDQ.W    #4,TELLT		*** VITESSE DE ROTATION ***
                  ADDQ.W    #6,TELLU
                  ADDQ.W    #4,TELLV
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

Wait_vbl:
	CLR.W     VBLFLAG
.WAIT:
	CMPI.W    #1,VBLFLAG
  BNE.S     .WAIT	
  rts
  
delay:
  MOVE.W     #$09F-80-11,D0 
.synch:
	BSR       WAIT_VBL
	sub.w	#$001,d0
	cmp.w	#$000,d0	
	bne.s	.synch
	rts	
	
*************************************************************
                  
	SECTION	DATA 

GO_RASTER:	ds.b	1
		ds.b	1

minifonte					dc.l	$4aeaa,$cacac,$68886,$caaac,$e8c8e,$e8c88
									dc.l	$68aa6,$aaeaa,$44444,$222a4,$ac8ca,$8888e
									dc.l	$aeeaa,$aeaaa,$4aaa4,$cac88,$caaa6,$cacaa
									dc.l	$6842c,$e4444,$aaaae,$aaaa4,$aaaea,$aa4aa
									dc.l	$aa444,$e248e,$0
									dc.l	$eaaae,$26a22,$6a24e,$c242c,$88ae2,$e8c2c
									dc.l	$68ca4,$e2488,$ea4ae,$4a62c
									dc.l	$04040,$44404,$00448,$04048,$00004,$4a244
									dc.l	$44000

place							dc.b	"abcdefghijklmnopqrstuvwxyz 0123456789"
									dc.b	":!,;.?'",0
	
txt								dc.b	"new bsw dcd number 12x details :",1,1
									dc.b	"f1 : program 1..................",1
									dc.b	"     by.........................",1,1
									dc.b	"f2 : program 2..................",1
									dc.b	"     by.........................",1,1
									dc.b	"f3 : program 3..................",1
									dc.b	"     by.........................",1,1
									dc.b	"f4 : program 4..................",1
									dc.b	"     by.........................",1,1
									dc.b	"f5 : program 5..................",1
									dc.b	"     by.........................",1,1
									dc.b	"f6 : program 6..................",1
									dc.b	"     by.........................",1,1
									dc.b	"f7 : program 7..................",1
									dc.b	"     by.........................",1,1
									dc.b	"f8 : program 8..................",1
									dc.b	"     by.........................",1,1
									dc.b	"f9 : program 9..................",1
									dc.b	"     by.........................",1,1
									dc.b	"space : program check...........",1,1
									*dc.b	"esc : return to the desktop.....",1
									dc.b	0
mem								ds.l	16
									even

compteur					dc.b	0,$19,0,0
buffer1						
	rept 6
									dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	endr								
									dc.b	0,0,0,0,0,0
buffer2
	rept 85
									dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	endr								
									dc.b	0,0,0,0,0
textscroll				dc.l	text8_8
text8_8 
      DC.B      '                    '	*	horizontal scroll
      DC.B      'ABCDEFGHIJKLMNOPQRST'
      DC.B      'UVWXYZ 0123456789   '
      DC.B      '()!?,;.:',$27
      DC.B      '                    '
      DC.B			0
								  dc.l	font8_8
font8_8:          dc	$0000,$0000,$0000,$0000
              		dc	$3030,$3030,$0030,$3000
              		dc	$6C48,$0000,$0000,$0000
              		dc	$0000,$0000,$0000,$0000
              		dc	$0000,$0000,$0000,$0000
              		dc	$0000,$0000,$0000,$0000
              		dc	$0000,$0000,$0000,$0000
              		dc	$3020,$0000,$0000,$0000
              		dc	$0E18,$1818,$1818,$0E00
              		dc	$E030,$3030,$3030,$E000
              		dc	$0000,$0000,$0000,$0000
              		dc	$0000,$0000,$0000,$0000
              		dc	$0000,$0000,$0030,$2000
              		dc	$0000,$0000,$0000,$0000
              		dc	$0000,$0000,$0020,$3000
              		dc	$0000,$0000,$0000,$0000
              		dc	$FC06,$CED6,$E6C6,$7C00
              		dc	$3818,$1818,$1818,$1800
              		dc	$7CC6,$067C,$C0C0,$FE00
              		dc	$7CC6,$063C,$06C6,$7C00
              		dc	$C0D8,$D8FE,$1818,$1800
              		dc	$FE06,$C0FC,$06C6,$7C00
              		dc	$FC06,$C0FC,$C6C6,$7C00
              		dc	$FE06,$0C18,$3060,$C000
              		dc	$7C06,$C67E,$C6C6,$7C00
              		dc	$7CC6,$C67E,$06C6,$7C00
              		dc	$0030,$3000,$3030,$0000
              		dc	$0030,$3000,$3020,$0000
              		dc	$0000,$0000,$0000,$0000
              		dc	$0000,$0000,$0000,$0000
              		dc	$0000,$0000,$0000,$0000
              		dc	$7CC6,$063C,$0030,$3000
              		dc	$0000,$0000,$0000,$0000
              		dc	$FC06,$C6FE,$C6C6,$C600
              		dc	$FC06,$C6FC,$C6C6,$FC00
              		dc	$FC06,$C0C0,$C0C6,$7E00
              		dc	$FC06,$C6C6,$C6C6,$FE00
              		dc	$FE00,$C0F8,$C0C0,$FE00
              		dc	$FEC0,$C0F8,$C0C0,$C000
              		dc	$FC06,$C0CE,$C6C6,$7E00
              		dc	$C6C6,$C6FE,$C6C6,$C600
              		dc	$FE00,$1030,$3030,$FE00
              		dc	$0E06,$06E6,$C6C6,$7C00
              		dc	$C6C6,$C0FC,$C6C6,$C600
              		dc	$C0C0,$C0C0,$C0C0,$FE00
              		dc	$EC3E,$D6C6,$C6C6,$C600
              		dc	$FC06,$C6C6,$C6C6,$C600
              		dc	$FC06,$C6C6,$C6C6,$7C00
              		dc	$FC06,$C6FC,$C0C0,$C000
              		dc	$FC06,$C6C6,$DECC,$7600
              		dc	$FC06,$C6FC,$C6C6,$C600
              		dc	$FC06,$C07C,$06C6,$7C00
              		dc	$FE10,$3030,$3030,$3000
              		dc	$C6C6,$C6C6,$C6C6,$7C00
              		dc	$82C6,$C6C6,$C66C,$3800
              		dc	$C6C6,$C6C6,$D6FE,$6C00
              		dc	$E6C6,$4C38,$6CC6,$CE00
              		dc	$C6C6,$C67C,$1030,$3000
              		dc	$FE00,$1830,$60C0,$FE00
	
SINUS:        		dc	$0000,$0004,$0008,$000D
              		dc	$0011,$0016,$001A,$001F
              		dc	$0023,$0028,$002C,$0030
              		dc	$0035,$0039,$003D,$0042
              		dc	$0046,$004A,$004F,$0053
              		dc	$0057,$005B,$005F,$0064
              		dc	$0068,$006C,$0070,$0074
              		dc	$0078,$007C,$0080,$0083
              		dc	$0087,$008B,$008F,$0092
              		dc	$0096,$009A,$009D,$00A1
              		dc	$00A4,$00A7,$00AB,$00AE
              		dc	$00B1,$00B5,$00B8,$00BB
              		dc	$00BE,$00C1,$00C4,$00C6
              		dc	$00C9,$00CC,$00CF,$00D1
              		dc	$00D4,$00D6,$00D9,$00DB
              		dc	$00DD,$00DF,$00E2,$00E4
              		dc	$00E6,$00E8,$00E9,$00EB
              		dc	$00ED,$00EE,$00F0,$00F2
              		dc	$00F3,$00F4,$00F6,$00F7
              		dc	$00F8,$00F9,$00FA,$00FB
              		dc	$00FC,$00FC,$00FD,$00FE
              		dc	$00FE,$00FF,$00FF,$00FF
              		dc	$00FF,$00FF
COSINUS:        	dc	$0100,$00FF,$00FF,$00FF
              		dc	$00FF,$00FF,$00FE,$00FE
              		dc	$00FD,$00FC,$00FC,$00FB
              		dc	$00FA,$00F9,$00F8,$00F7
              		dc	$00F6,$00F4,$00F3,$00F2
              		dc	$00F0,$00EE,$00ED,$00EB
              		dc	$00E9,$00E8,$00E6,$00E4
              		dc	$00E2,$00DF,$00DD,$00DB
              		dc	$00D9,$00D6,$00D4,$00D1
              		dc	$00CF,$00CC,$00C9,$00C6
              		dc	$00C4,$00C1,$00BE,$00BB
              		dc	$00B8,$00B5,$00B1,$00AE
              		dc	$00AB,$00A7,$00A4,$00A1
              		dc	$009D,$009A,$0096,$0092
              		dc	$008F,$008B,$0087,$0083
              		dc	$0080,$007C,$0078,$0074
              		dc	$0070,$006C,$0068,$0064
              		dc	$005F,$005B,$0057,$0053
              		dc	$004F,$004A,$0046,$0042
              		dc	$003D,$0039,$0035,$0030
              		dc	$002C,$0028,$0023,$001F
              		dc	$001A,$0016,$0011,$000D
              		dc	$0008,$0004,$0000,$FFFC
              		dc	$FFF8,$FFF3,$FFEF,$FFEA
              		dc	$FFE6,$FFE1,$FFDD,$FFD8
              		dc	$FFD4,$FFD0,$FFCB,$FFC7
              		dc	$FFC3,$FFBE,$FFBA,$FFB6
              		dc	$FFB1,$FFAD,$FFA9,$FFA5
              		dc	$FFA1,$FF9C,$FF98,$FF94
              		dc	$FF90,$FF8C,$FF88,$FF84
              		dc	$FF80,$FF7D,$FF79,$FF75
              		dc	$FF71,$FF6E,$FF6A,$FF66
              		dc	$FF63,$FF5F,$FF5C,$FF59
              		dc	$FF55,$FF52,$FF4F,$FF4B
              		dc	$FF48,$FF45,$FF42,$FF3F
              		dc	$FF3C,$FF3A,$FF37,$FF34
              		dc	$FF31,$FF2F,$FF2C,$FF2A
              		dc	$FF27,$FF25,$FF23,$FF21
              		dc	$FF1E,$FF1C,$FF1A,$FF18
              		dc	$FF17,$FF15,$FF13,$FF12
              		dc	$FF10,$FF0E,$FF0D,$FF0C
              		dc	$FF0A,$FF09,$FF08,$FF07
              		dc	$FF06,$FF05,$FF04,$FF04
              		dc	$FF03,$FF02,$FF02,$FF01
              		dc	$FF01,$FF01,$FF01,$FF01
              		dc	$FF00,$FF01,$FF01,$FF01
              		dc	$FF01,$FF01,$FF02,$FF02
              		dc	$FF03,$FF04,$FF04,$FF05
              		dc	$FF06,$FF07,$FF08,$FF09
              		dc	$FF0A,$FF0C,$FF0D,$FF0E
              		dc	$FF10,$FF12,$FF13,$FF15
              		dc	$FF17,$FF18,$FF1A,$FF1C
              		dc	$FF1E,$FF21,$FF23,$FF25
              		dc	$FF27,$FF2A,$FF2C,$FF2F
              		dc	$FF31,$FF34,$FF37,$FF3A
              		dc	$FF3C,$FF3F,$FF42,$FF45
              		dc	$FF48,$FF4B,$FF4F,$FF52
              		dc	$FF55,$FF59,$FF5C,$FF5F
              		dc	$FF63,$FF66,$FF6A,$FF6E
              		dc	$FF71,$FF75,$FF79,$FF7D
              		dc	$FF80,$FF84,$FF88,$FF8C
              		dc	$FF90,$FF94,$FF98,$FF9C
              		dc	$FFA1,$FFA5,$FFA9,$FFAD
              		dc	$FFB1,$FFB6,$FFBA,$FFBE
              		dc	$FFC3,$FFC7,$FFCB,$FFD0
              		dc	$FFD4,$FFD8,$FFDD,$FFE1
              		dc	$FFE6,$FFEA,$FFEF,$FFF3
              		dc	$FFF8,$FFFC,$0000,$0004
              		dc	$0008,$000D,$0011,$0016
              		dc	$001A,$001F,$0023,$0028
              		dc	$002C,$0030,$0035,$0039
              		dc	$003D,$0042,$0046,$004A
              		dc	$004F,$0053,$0057,$005B
              		dc	$005F,$0064,$0068,$006C
              		dc	$0070,$0074,$0078,$007C
              		dc	$0080,$0083,$0087,$008B
              		dc	$008F,$0092,$0096,$009A
              		dc	$009D,$00A1,$00A4,$00A7
              		dc	$00AB,$00AE,$00B1,$00B5
              		dc	$00B8,$00BB,$00BE,$00C1
              		dc	$00C4,$00C6,$00C9,$00CC
              		dc	$00CF,$00D1,$00D4,$00D6
              		dc	$00D9,$00DB,$00DD,$00DF
              		dc	$00E2,$00E4,$00E6,$00E8
              		dc	$00E9,$00EB,$00ED,$00EE
              		dc	$00F0,$00F2,$00F3,$00F4
              		dc	$00F6,$00F7,$00F8,$00F9
              		dc	$00FA,$00FB,$00FC,$00FC
              		dc	$00FD,$00FE,$00FE,$00FF
              		dc	$00FF,$00FF,$00FF,$00FF
              		dc	$0100,$00FF,$00FF,$00FF
              		dc	$00FF,$00FF,$00FE,$00FE
              		dc	$00FD,$00FC,$00FC,$00FB
              		dc	$00FA,$00F9,$00F8,$00F7
              		dc	$00F6,$00F4,$00F3,$00F2
              		dc	$00F0,$00EE,$00ED,$00EB
              		dc	$00E9,$00E8,$00E6,$00E4
              		dc	$00E2,$00DF,$00DD,$00DB
              		dc	$00D9,$00D6,$00D4,$00D1
              		dc	$00CF,$00CC,$00C9,$00C6
              		dc	$00C4,$00C1,$00BE,$00BB
              		dc	$00B8,$00B5,$00B1,$00AE
              		dc	$00AB,$00A7,$00A4,$00A1
              		dc	$009D,$009A,$0096,$0092
              		dc	$008F,$008B,$0087,$0083
              		dc	$0080
TELLU:            DCB.W     2,0 
TELLT:            DCB.W     2,0 
TELLV:            DCB.W     2,0 
SAVEU:            DCB.W     8,0 
SAVET:            DCB.W     8,0 
SAVEV:            DCB.W     8,0 
X:                DCB.W     2,0 
Y:                DCB.W     2,0 
Z:                DCB.W     2,0 
MASKS:        		dc	$8000,$4000,$2000,$1000
              		dc	$0800,$0400,$0200,$0100
              		dc	$0080,$0040,$0020,$0010
              		dc	$0008,$0004,$0002,$0001
              		dc	$8000,$4000,$2000,$1000
              		dc	$0800,$0400,$0200,$0100
              		dc	$0080,$0040,$0020,$0010
              		dc	$0008,$0004,$0002,$0001
              		dc	$8000,$4000,$2000,$1000
              		dc	$0800,$0400,$0200,$0100
              		dc	$0080,$0040,$0020,$0010
              		dc	$0008,$0004,$0002,$0001
              		dc	$8000,$4000,$2000,$1000
              		dc	$0800,$0400,$0200,$0100
              		dc	$0080,$0040,$0020,$0010
              		dc	$0008,$0004,$0002,$0001
              		dc	$8000,$4000,$2000,$1000
              		dc	$0800,$0400,$0200,$0100
              		dc	$0080,$0040,$0020,$0010
              		dc	$0008,$0004,$0002,$0001
              		dc	$8000,$4000,$2000,$1000
              		dc	$0800,$0400,$0200,$0100
              		dc	$0080,$0040,$0020,$0010
              		dc	$0008,$0004,$0002,$0001
              		dc	$8000,$4000,$2000,$1000
              		dc	$0800,$0400,$0200,$0100
              		dc	$0080,$0040,$0020,$0010
              		dc	$0008,$0004,$0002,$0001
              		dc	$8000,$4000,$2000,$1000
              		dc	$0800,$0400,$0200,$0100
              		dc	$0080,$0040,$0020,$0010
              		dc	$0008,$0004,$0002,$0001
              		dc	$8000,$4000,$2000,$1000
              		dc	$0800,$0400,$0200,$0100
              		dc	$0080,$0040,$0020,$0010
              		dc	$0008,$0004,$0002,$0001
              		dc	$8000,$4000,$2000,$1000
              		dc	$0800,$0400,$0200,$0100
              		dc	$0080,$0040,$0020,$0010
              		dc	$0008,$0004,$0002,$0001
              		dc	$8000,$4000,$2000,$1000
              		dc	$0800,$0400,$0200,$0100
              		dc	$0080,$0040,$0020,$0010
              		dc	$0008,$0004,$0002,$0001
              		dc	$8000,$4000,$2000,$1000
              		dc	$0800,$0400,$0200,$0100
              		dc	$0080,$0040,$0020,$0010
              		dc	$0008,$0004,$0002,$0001
              		dc	$8000,$4000,$2000,$1000
              		dc	$0800,$0400,$0200,$0100
              		dc	$0080,$0040,$0020,$0010
              		dc	$0008,$0004,$0002,$0001
              		dc	$8000,$4000,$2000,$1000
              		dc	$0800,$0400,$0200,$0100
              		dc	$0080,$0040,$0020,$0010
              		dc	$0008,$0004,$0002,$0001
              		dc	$8000,$4000,$2000,$1000
              		dc	$0800,$0400,$0200,$0100
              		dc	$0080,$0040,$0020,$0010
              		dc	$0008,$0004,$0002,$0001
              		dc	$8000,$4000,$2000,$1000
              		dc	$0800,$0400,$0200,$0100
              		dc	$0080,$0040,$0020,$0010
              		dc	$0008,$0004,$0002,$0001
              		dc	$8000,$4000,$2000,$1000
              		dc	$0800,$0400,$0200,$0100
              		dc	$0080,$0040,$0020,$0010
              		dc	$0008,$0004,$0002,$0001
              		dc	$8000,$4000,$2000,$1000
              		dc	$0800,$0400,$0200,$0100
              		dc	$0080,$0040,$0020,$0010
              		dc	$0008,$0004,$0002,$0001
              		dc	$8000,$4000,$2000,$1000
              		dc	$0800,$0400,$0200,$0100
              		dc	$0080,$0040,$0020,$0010
              		dc	$0008,$0004,$0002,$0001
              		dc	$8000,$4000,$2000,$1000
              		dc	$0800,$0400,$0200,$0100
              		dc	$0080,$0040,$0020,$0010
              		dc	$0008,$0004,$0002,$0001
WORDS:        		dc	$0000,$0000,$0000,$0000
              		dc	$0000,$0000,$0000,$0000
              		dc	$0000,$0000,$0000,$0000
              		dc	$0000,$0000,$0000,$0000
              		dc	$0008,$0008,$0008,$0008
              		dc	$0008,$0008,$0008,$0008
              		dc	$0008,$0008,$0008,$0008
              		dc	$0008,$0008,$0008,$0008
              		dc	$0010,$0010,$0010,$0010
              		dc	$0010,$0010,$0010,$0010
              		dc	$0010,$0010,$0010,$0010
              		dc	$0010,$0010,$0010,$0010
              		dc	$0018,$0018,$0018,$0018
              		dc	$0018,$0018,$0018,$0018
              		dc	$0018,$0018,$0018,$0018
              		dc	$0018,$0018,$0018,$0018
              		dc	$0020,$0020,$0020,$0020
              		dc	$0020,$0020,$0020,$0020
              		dc	$0020,$0020,$0020,$0020
              		dc	$0020,$0020,$0020,$0020
              		dc	$0028,$0028,$0028,$0028
              		dc	$0028,$0028,$0028,$0028
              		dc	$0028,$0028,$0028,$0028
              		dc	$0028,$0028,$0028,$0028
              		dc	$0030,$0030,$0030,$0030
              		dc	$0030,$0030,$0030,$0030
              		dc	$0030,$0030,$0030,$0030
              		dc	$0030,$0030,$0030,$0030
              		dc	$0038,$0038,$0038,$0038
              		dc	$0038,$0038,$0038,$0038
              		dc	$0038,$0038,$0038,$0038
              		dc	$0038,$0038,$0038,$0038
              		dc	$0040,$0040,$0040,$0040
              		dc	$0040,$0040,$0040,$0040
              		dc	$0040,$0040,$0040,$0040
              		dc	$0040,$0040,$0040,$0040
              		dc	$0048,$0048,$0048,$0048
              		dc	$0048,$0048,$0048,$0048
              		dc	$0048,$0048,$0048,$0048
              		dc	$0048,$0048,$0048,$0048
              		dc	$0050,$0050,$0050,$0050
              		dc	$0050,$0050,$0050,$0050
              		dc	$0050,$0050,$0050,$0050
              		dc	$0050,$0050,$0050,$0050
              		dc	$0058,$0058,$0058,$0058
              		dc	$0058,$0058,$0058,$0058
              		dc	$0058,$0058,$0058,$0058
              		dc	$0058,$0058,$0058,$0058
              		dc	$0060,$0060,$0060,$0060
              		dc	$0060,$0060,$0060,$0060
              		dc	$0060,$0060,$0060,$0060
              		dc	$0060,$0060,$0060,$0060
              		dc	$0068,$0068,$0068,$0068
              		dc	$0068,$0068,$0068,$0068
              		dc	$0068,$0068,$0068,$0068
              		dc	$0068,$0068,$0068,$0068
              		dc	$0070,$0070,$0070,$0070
              		dc	$0070,$0070,$0070,$0070
              		dc	$0070,$0070,$0070,$0070
              		dc	$0070,$0070,$0070,$0070
              		dc	$0078,$0078,$0078,$0078
              		dc	$0078,$0078,$0078,$0078
              		dc	$0078,$0078,$0078,$0078
              		dc	$0078,$0078,$0078,$0078
              		dc	$0080,$0080,$0080,$0080
              		dc	$0080,$0080,$0080,$0080
              		dc	$0080,$0080,$0080,$0080
              		dc	$0080,$0080,$0080,$0080
              		dc	$0088,$0088,$0088,$0088
              		dc	$0088,$0088,$0088,$0088
              		dc	$0088,$0088,$0088,$0088
              		dc	$0088,$0088,$0088,$0088
              		dc	$0090,$0090,$0090,$0090
              		dc	$0090,$0090,$0090,$0090
              		dc	$0090,$0090,$0090,$0090
              		dc	$0090,$0090,$0090,$0090
              		dc	$0098,$0098,$0098,$0098
              		dc	$0098,$0098,$0098,$0098
              		dc	$0098,$0098,$0098,$0098
              		dc	$0098,$0098,$0098,$0098
Y_TAB:        		dc	$0000,$00A0,$0140,$01E0
              		dc	$0280,$0320,$03C0,$0460
              		dc	$0500,$05A0,$0640,$06E0
              		dc	$0780,$0820,$08C0,$0960
              		dc	$0A00,$0AA0,$0B40,$0BE0
              		dc	$0C80,$0D20,$0DC0,$0E60
              		dc	$0F00,$0FA0,$1040,$10E0
              		dc	$1180,$1220,$12C0,$1360
              		dc	$1400,$14A0,$1540,$15E0
              		dc	$1680,$1720,$17C0,$1860
              		dc	$1900,$19A0,$1A40,$1AE0
              		dc	$1B80,$1C20,$1CC0,$1D60
              		dc	$1E00,$1EA0,$1F40,$1FE0
              		dc	$2080,$2120,$21C0,$2260
              		dc	$2300,$23A0,$2440,$24E0
              		dc	$2580,$2620,$26C0,$2760
              		dc	$2800,$28A0,$2940,$29E0
              		dc	$2A80,$2B20,$2BC0,$2C60
              		dc	$2D00,$2DA0,$2E40,$2EE0
              		dc	$2F80,$3020,$30C0,$3160
              		dc	$3200,$32A0,$3340,$33E0
              		dc	$3480,$3520,$35C0,$3660
              		dc	$3700,$37A0,$3840,$38E0
              		dc	$3980,$3A20,$3AC0,$3B60
              		dc	$3C00,$3CA0,$3D40,$3DE0
              		dc	$3E80,$3F20,$3FC0,$4060
              		dc	$4100,$41A0,$4240,$42E0
              		dc	$4380,$4420,$44C0,$4560
              		dc	$4600,$46A0,$4740,$47E0
              		dc	$4880,$4920,$49C0,$4A60
              		dc	$4B00,$4BA0,$4C40,$4CE0
              		dc	$4D80,$4E20,$4EC0,$4F60
              		dc	$5000,$50A0,$5140,$51E0
              		dc	$5280,$5320,$53C0,$5460
              		dc	$5500,$55A0,$5640,$56E0
              		dc	$5780,$5820,$58C0,$5960
              		dc	$5A00,$5AA0,$5B40,$5BE0
              		dc	$5C80,$5D20,$5DC0,$5E60
              		dc	$5F00,$5FA0,$6040,$60E0
              		dc	$6180,$6220,$62C0,$6360
              		dc	$6400,$64A0,$6540,$65E0
              		dc	$6680,$6720,$67C0,$6860
              		dc	$6900,$69A0,$6A40,$6AE0
              		dc	$6B80,$6C20,$6CC0,$6D60
              		dc	$6E00,$6EA0,$6F40,$6FE0
              		dc	$7080,$7120,$71C0,$7260
              		dc	$7300,$73A0,$7440,$74E0
              		dc	$7580,$7620,$76C0,$7760
              		dc	$7800,$78A0,$7940,$79E0
              		dc	$7A80,$7B20,$7BC0,$7C60
              		dc	$7D00,$7DA0,$7E40,$7EE0
              		dc	$7F80,$8020,$80C0,$8160
              		dc	$8200,$82A0,$8340,$83E0
              		dc	$8480,$8520,$85C0,$8660
              		dc	$8700,$87A0,$8840,$88E0
              		dc	$8980,$8A20,$8AC0,$8B60
              		dc	$8C00,$8CA0,$8D40,$8DE0
              		dc	$8E80,$8F20,$8FC0,$9060
              		dc	$9100,$91A0,$9240,$92E0
              		dc	$9380,$9420,$94C0,$9560
              		dc	$9600,$96A0,$9740,$97E0
              		dc	$9880,$9920,$99C0,$9A60
              		dc	$9B00,$9BA0,$9C40,$9CE0
              		dc	$9D80,$9E20,$9EC0,$9F60
              		dc	$A000,$A0A0,$A140,$A1E0
              		dc	$A280,$A320,$A3C0,$A460
              		dc	$A500,$A5A0,$A640,$A6E0
              		dc	$A780,$A820,$A8C0,$A960
              		dc	$AA00,$AAA0,$AB40,$ABE0
              		dc	$AC80,$AD20,$ADC0,$AE60
              		dc	$AF00,$AFA0,$B040,$B0E0
              		dc	$B180,$B220,$B2C0,$B360
              		dc	$B400,$B4A0,$B540,$B5E0
              		dc	$B680,$B720,$B7C0,$B860
              		dc	$B900,$B9A0,$BA40,$BAE0
              		dc	$BB80,$BC20,$BCC0,$BD60
              		dc	$BE00,$BEA0,$BF40,$BFE0
              		dc	$C080,$C120,$C1C0,$C260
              		dc	$C300,$C3A0,$C440,$C4E0
              		dc	$C580
OBJ:
		  						* NOMBRE DE FACE
	          			DC.W      $007

								  * 0
								  DC.W      $FFD3		* X
								  DC.W      $FFD3		* Y
								  DC.W      $0032		* Z

								  * 1	  
						      DC.W      $002D		* X
						      DC.W      $FFD3		* Y
						      DC.W      $0032		* Z

								  * 2		  
						      DC.W      $FFD3		* X
						      DC.W      $002D		* Y
						      DC.W      $0032		* Z

		  						* 3
                  DC.W      $002D		* X
                  DC.W      $002D		* Y
                  DC.W      $0032		* Z

								  * 4
                  DC.W      $FFD3		* X
                  DC.W      $FFD3		* Y
                  DC.W      $FFD8		* Z

								  * 5
                  DC.W      $002D		* X
                  DC.W      $FFD3		* Y
                  DC.W      $FFD8		* Z

								  * 6
                  DC.W      $FFD3		* X
                  DC.W      $002D		* Y
                  DC.W      $FFD8		* Z

								  * 7
                  DC.W      $002D		* X
                  DC.W      $002D		* Y
                  DC.W      $FFD8		* Z
                  
OBJ_OFF:          DC.W      $FFFF
 
MAPP:	            DC.L      COORDS
                  DC.L      memo0 
                  DC.L      memo1 
                  DC.L      memo2 
                  DC.L      COORDS
                  DC.L      memo1 
                  DC.L      memo0 
                  DC.L      memo2 
                  DC.L      memo3 
                  DC.L      memo4 
                  DC.L      memo5 
                  DC.L      memo6 
                  DC.L      memo3 
                  DC.L      memo5 
                  DC.L      memo4 
                  DC.L      memo6 
                  DC.L      COORDS
                  DC.L      memo3 
                  DC.L      memo0 
                  DC.L      memo4 
                  DC.L      memo1 
                  DC.L      memo5 
                  DC.L      memo2 
                  DC.L      memo6 
                  DC.L      COORDS
                  DC.L      memo6 
                  DC.L      memo0 
                  DC.L      memo5 
                  DC.L      memo1 
                  DC.L      memo4 
                  DC.L      memo2 
                  DC.L      memo3 
COORDS:           DCB.W     2,0 
memo0:            DCB.W     2,0 
memo1:            DCB.W     2,0 
memo2:            DCB.W     2,0 
memo3:            DCB.W     2,0 
memo4:            DCB.W     2,0 
memo5:            DCB.W     2,0 
memo6:            DCB.W     26,0
YPOS:             DCB.W     4,0 
XPOS:             DCB.W     2,0 
UP_DN:            DCB.W     2,0 
HVEM:             DCB.W     2,0 
LINE_VAR:         DCB.W     2,0 
SCREEN:           DCB.W     2,0 
VBLFLAG:          DCB.W     2,0 

Emp								dc.b 'Z:\',0
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

errtext:       		DC.b "PROBLEMS TO LOAD...          ",13,10,10,0
params:        		DC.b 0    ;aucun paramŠtre et
environ:       		DC.b 0    ;aucun environnement
									EVEN

PAL_PIC:					dc.w	$0000,$088A,$0A9A,$0BAA,$0882,$0FDB,$0001,$099A
									dc.w	$0BAA,$0DBA,$0EBA,$0643,$0BA9,$0F00,$0DCB,$0FFF
									
PIC:
	rept	70
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$07FF,$07FF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$E000,$E000,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$07FF,$07FF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$E000,$E000,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$07FF,$07FF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$E000,$E000,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3FFF,$3FFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FC00,$FC00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3FFF,$3FFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FC00,$FC00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3FFF,$3FFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FC00,$FC00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002B,$0026,$0035,$001E,$A800,$C800,$5800,$F000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0040,$00FF,$00C0,$FC00,$0000,$FA00,$0600
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$03FF,$03FF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$E000,$E000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01FF,$0200,$00FF,$0100,$FF00,$0080,$FE00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$03FF,$03FF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$E000,$E000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$03FF,$0200,$05FF,$0600,$FF80,$0080,$FF40,$00C0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$03FF,$03FF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$E000,$E000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$07FF,$0400,$0BFF,$0C00,$FFC0,$0040,$FFA0,$0060
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0FFF,$0800,$17FF,$1800,$FFE0,$0020,$FFD0,$0030
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1FFF,$3000,$0FFF,$1000,$FFF0,$0018,$FFE0,$0010
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3FFF,$0000,$1FFF,$2000,$FFF8,$0000,$FFF0,$0008
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3FFF,$0000,$7FFF,$4000,$FFF8,$0000,$FFFC,$0004
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$07FF,$07FF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$E000,$E000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$7FFF,$0000,$3FFF,$4000,$FFFC,$0000,$FFF8,$0004
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$07FF,$07FF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$E000,$E000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FFFF,$8000,$FFFF,$0000,$FFFE,$0002,$FFFE,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$07FF,$07FF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$E000,$E000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$7FFF,$0000,$FFFF,$8000,$FFFC,$0000,$FFFE,$0002
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$7FFF,$8000,$FFFE,$0000,$FFFC,$0002
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$7FFF,$8000,$FFFF,$8000,$FFFC,$0002,$FFFE,$0002
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FFFF,$8000,$7FFF,$8000,$FFFE,$0002,$FFFC,$0002
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFFE,$0000,$FFFE,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FFFF,$8000,$7FFF,$8000,$FFFE,$0002,$FFFC,$0002
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$7FFF,$8000,$FFFF,$8000,$FFFC,$0002,$FFFE,$0002
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$7FFF,$8000,$FFFE,$0000,$FFFC,$0002
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$7FFF,$0000,$FFFF,$8000,$FFFC,$0000,$FFFE,$0002
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FFFF,$8000,$FFFF,$0000,$FFFE,$0002,$FFFE,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$7FFF,$0000,$3FFF,$4000,$FFFC,$0000,$FFF8,$0004
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3FFF,$0000,$7FFF,$4000,$FFF8,$0000,$FFFC,$0004
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3FFF,$0000,$1FFF,$2000,$FFF8,$0000,$FFF0,$0008
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1FFF,$3000,$0FFF,$1000,$FFF0,$0018,$FFE0,$0010
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0FFF,$0800,$17FF,$1800,$FFE0,$0020,$FFD0,$0030
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$07FF,$0400,$0BFF,$0C00,$FFC0,$0040,$FFA0,$0060
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$03FF,$0200,$05FF,$0600,$FF80,$0080,$FF40,$00C0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01FF,$0200,$00FF,$0100,$FF00,$0080,$FE00,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007F,$0000,$00BF,$00C0,$FC00,$0000,$FA00,$0600
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$002B,$0026,$0035,$001E,$A800,$C800,$5800,$F000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$3800,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1C00,$1C00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3FFF,$3FFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FC00,$FC00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3FFF,$3FFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FC00,$FC00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3FFF,$3FFF,$0000,$0000,$FFFF,$FFFF,$0000,$0000
		dc.w	$FC00,$FC00,$0000,$0000,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0004,$0004,$0004,$0000,$0000,$0001,$0000,$0000
		dc.w	$09FE,$F800,$0000,$07FF,$07FF,$0000,$0000,$FFFF
		dc.w	$8070,$007F,$0000,$FF80,$D800,$FFFF,$D800,$0000
		dc.w	$E3FF,$E3FF,$E3FF,$0000,$FF80,$FF80,$FF80,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$01FF,$01FF,$0000,$FFFF,$FFFF,$FFFF,$0000
		dc.w	$FFE0,$FFFF,$FFE0,$0000,$0630,$FE0F,$0000,$01FF
		dc.w	$0FFF,$F000,$0FFF,$F000,$0208,$FC0F,$0000,$FFF0
		dc.w	$000E,$FFFF,$000E,$0000,$2601,$FFFF,$2601,$0000
		dc.w	$FFFF,$FE00,$FE00,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0001,$0001,$0000,$FFFF,$FF80,$FF80,$0000
		dc.w	$FC01,$FFFF,$FC00,$0000,$81F0,$801F,$0000,$7FE0
		dc.w	$C409,$C3F1,$0000,$3FFE,$FC23,$FC3F,$0000,$03C0
		dc.w	$87F0,$FFFF,$07F0,$0000,$FFEF,$E010,$E000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C000,$3FFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$03FF,$FC00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0007,$0007,$0000
		dc.w	$DFFF,$FFFF,$DFFF,$0000,$FC20,$FFFF,$FC00,$0000
		dc.w	$07FE,$FC01,$00FE,$0301,$2019,$C01F,$0000,$FFE0
		dc.w	$CFC0,$FFFF,$0FC0,$0000,$3FFF,$C030,$0030,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C000,$3FFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$03FF,$FC00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FF80,$C1FF,$C180,$0000,$3C39,$FFFF,$3C00,$0000
		dc.w	$307F,$0F80,$007F,$FF80,$8218,$7CFF,$8000,$7F00
		dc.w	$01FF,$FF80,$0180,$0000,$FFFF,$01FF,$01FF,$0000
		dc.w	$FFFF,$C000,$C000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C000,$3FFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$03FF,$FC00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0FC0,$0FC0,$0000
		dc.w	$FFF0,$007F,$0070,$0000,$FF81,$EAFF,$EA80,$0000
		dc.w	$0810,$0FF0,$0000,$F00F,$0082,$00FF,$0002,$FF00
		dc.w	$0FFF,$FB00,$0B00,$0000,$FFFF,$0180,$0180,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$1FFF,$E000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$00C0,$00C0,$0000
		dc.w	$FF07,$03FC,$0304,$0000,$E7F0,$3C7F,$2470,$0000
		dc.w	$0084,$FF83,$0000,$007F,$5001,$9FFF,$0001,$E000
		dc.w	$FFFF,$FE00,$FE00,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$1FFF,$E000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$007F,$007F,$0000
		dc.w	$FFFF,$E000,$E000,$0000,$FFFE,$001F,$001E,$0000
		dc.w	$0002,$FE03,$0000,$01FC,$03F0,$FFFF,$0000,$0000
		dc.w	$9FFF,$FF83,$9F83,$0000,$FFFF,$F800,$F800,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$1FFF,$E000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$003F,$003F,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFEF,$001F,$000F,$0000
		dc.w	$F13F,$FCC0,$F03F,$03C0,$2183,$C7FF,$0003,$F800
		dc.w	$1FFF,$F800,$1800,$0000,$FFFF,$1CF7,$1CF7,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFF8,$0007,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$000E,$000E,$0000
		dc.w	$FFFE,$0007,$0006,$0000,$11C3,$FFFF,$01C3,$0000
		dc.w	$F19C,$F063,$E01C,$0FE3,$10C7,$E0FF,$0007,$FF00
		dc.w	$0FFF,$F000,$0000,$0000,$FFFF,$001F,$001F,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFF8,$0007,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0F00,$0F00,$0000
		dc.w	$FFFF,$7F01,$7F01,$0000,$E0FF,$FFFF,$E0FF,$0000
		dc.w	$8400,$FC00,$8000,$03FF,$600F,$7FFF,$000F,$8000
		dc.w	$FFFF,$FF80,$FF80,$0000,$FFFF,$0018,$0018,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFF8,$0007,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0700,$0700,$0000
		dc.w	$FFFF,$5F80,$5F80,$0000,$FFFE,$07E7,$07E6,$0000
		dc.w	$0060,$FC7F,$0000,$0380,$0000,$FFFF,$0000,$0000
		dc.w	$007F,$FF90,$0010,$0000,$FFFF,$0030,$0030,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFC7,$0038,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$000F,$000F,$0000
		dc.w	$C001,$FFFF,$C000,$0000,$8081,$9E01,$0000,$7FFE
		dc.w	$87FF,$FF80,$0780,$0000,$FFFF,$3E00,$3E00,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFC7,$0038,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE00,$07FF,$0600,$0000
		dc.w	$0013,$FFF4,$0003,$000C,$C383,$3C03,$C000,$3FFC
		dc.w	$07FF,$FE00,$0600,$0000,$FFFF,$0307,$0307,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE07,$01F8,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0003,$0003,$0000
		dc.w	$F1E1,$EFDE,$E000,$003F,$CC2E,$FBF0,$0808,$0017
		dc.w	$3181,$3FBF,$0000,$C07E,$00C0,$FFFF,$0000,$0000
		dc.w	$1E03,$FFFF,$1E03,$0000,$FFFF,$81FE,$81FE,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE3F,$01C0,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0020,$0020,$0000
		dc.w	$FF1F,$00FF,$0000,$0000,$2E2F,$FFE0,$2E07,$0018
		dc.w	$8000,$7FFF,$0000,$8000,$0CC3,$FCFF,$0003,$0300
		dc.w	$F90C,$FF0F,$F800,$00F0,$7FFF,$E038,$6038,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE3F,$01C0,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$003C,$003C,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FF80,$3FFF,$3F80,$0000
		dc.w	$7FFF,$FFFF,$0000,$0000,$001F,$FFFF,$001F,$0000
		dc.w	$C607,$FFFE,$C606,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE07,$01F8,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$003E,$003E,$0000
		dc.w	$FFFF,$E7FC,$E7FC,$0000,$B9FE,$FE0F,$800E,$0000
		dc.w	$3C60,$FFE0,$3C00,$001F,$0401,$07FF,$0001,$F800
		dc.w	$C7FF,$F800,$C000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFC7,$0038,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0002,$0002,$0000
		dc.w	$FFFF,$6F00,$6F00,$0000,$DDFC,$7E03,$4000,$0000
		dc.w	$3D00,$FF0F,$3C00,$00FF,$8200,$03FF,$0000,$FC00
		dc.w	$FFFF,$0001,$0001,$0000,$FFFF,$809F,$809F,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFC7,$0038,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$4000,$4000,$0000,$FFFF,$007F,$007F,$0000
		dc.w	$C01A,$FFFB,$C000,$0004,$003F,$FFFE,$003E,$0000
		dc.w	$FFFF,$00CF,$00CF,$0000,$FFFF,$E0FE,$E0FE,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFF8,$0007,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FF83,$03FF,$0383,$0000
		dc.w	$18C5,$F83A,$0005,$07FA,$8337,$7C3F,$8007,$7FC0
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFF8,$0007,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FF83,$007F,$0003,$0000,$FE7D,$FFFF,$FE01,$0000
		dc.w	$021F,$FEE0,$001F,$01E0,$FB38,$043F,$C000,$3FC0
		dc.w	$FEFF,$FF00,$FE00,$0000,$FFFF,$0600,$0600,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFF8,$0007,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$20FF,$20E0,$0000,$1E03,$E1FD,$0001,$0000
		dc.w	$0008,$FFF8,$0000,$0007,$8000,$FFFF,$0000,$0000
		dc.w	$37C3,$FFFE,$3002,$0000,$FFFF,$3C00,$3C00,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$1FFF,$E000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$001C,$001C,$0000
		dc.w	$FFE8,$703F,$7020,$0000,$7FFF,$E000,$6000,$0000
		dc.w	$F880,$1F87,$1800,$007F,$0078,$F1FF,$0000,$FE00
		dc.w	$19FF,$FFF0,$19F0,$0000,$FFFF,$7F80,$7F80,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$1FFF,$E000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$000C,$000C,$0000
		dc.w	$FFFF,$401F,$401F,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F041,$7FFF,$7040,$0000,$107F,$287F,$1000,$EF80
		dc.w	$1FFF,$F800,$1800,$0000,$FFFF,$7800,$7800,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$1FFF,$E000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0004,$0004,$0000
		dc.w	$FFFF,$CFC1,$CFC1,$0000,$07FF,$FF03,$0703,$0000
		dc.w	$C9E0,$FFFF,$C9E0,$0000,$B900,$C5FF,$3800,$4600
		dc.w	$3FFF,$E000,$2000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C000,$3FFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$03FF,$FC00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$09C1,$09C1,$0000,$FFF8,$FE07,$FE00,$0000
		dc.w	$FFC6,$C3FE,$C3C0,$0001,$7800,$007F,$7800,$8780
		dc.w	$FFFF,$F800,$F800,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C000,$3FFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$03FF,$FC00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFC,$000F,$000C,$0000,$0FFF,$FC18,$0C18,$0000
		dc.w	$FF8C,$007D,$0000,$0003,$001F,$FEFF,$001F,$FF00
		dc.w	$C1FF,$FE00,$C000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C000,$3FFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$03FF,$FC00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FE0C,$03D0,$0200,$003F,$03E0,$FFFF,$03E0,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$7007,$FFFF,$0007,$0000
		dc.w	$87FF,$FF80,$8780,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0003,$0003,$0000
		dc.w	$FE0C,$C1E0,$C000,$001F,$0F80,$FFFF,$0F80,$0000
		dc.w	$40C8,$C0F8,$0000,$3F07,$0281,$00FF,$0001,$FF00
		dc.w	$FF79,$FF06,$FC00,$00F8,$FFFF,$0300,$0300,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$7870,$7870,$0000,$FC2C,$0FE1,$0C00,$001F
		dc.w	$020D,$FC32,$0005,$FFCA,$0130,$FDFF,$0000,$FE00
		dc.w	$8FD1,$F01F,$8001,$0FE0,$FFFF,$FF00,$FF00,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$F810,$0FF0,$0800,$000F
		dc.w	$21BC,$3E43,$003C,$C1C3,$3807,$3FFF,$0007,$C000
		dc.w	$8FF8,$FFFF,$8FF8,$0000,$FFFF,$E000,$E000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$F800,$07FF,$0000,$0000
		dc.w	$1FFF,$E000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$381F,$381F,$0000,$F800,$0FFF,$0800,$0000
		dc.w	$0980,$F970,$0000,$06FF,$900F,$FFF9,$0009,$0000
		dc.w	$FFFF,$FC00,$FC00,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$F800,$07FF,$0000,$0000
		dc.w	$1FFF,$E000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0CFF,$0CFF,$0000,$FF80,$FFFF,$FF80,$0000
		dc.w	$0087,$FC47,$0000,$03F8,$1DFF,$FFE0,$01E0,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$F800,$07FF,$0000,$0000
		dc.w	$1FFF,$E000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$001F,$001F,$0000,$83FF,$FC18,$8018,$0000
		dc.w	$FE0E,$0F0F,$0E00,$00F0,$1C3F,$FFC0,$1C00,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0003,$0002,$0000
		dc.w	$0E06,$FE07,$0E00,$01F8,$3FFF,$FFC1,$3FC1,$0000
		dc.w	$80FF,$FFC0,$80C0,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0010,$0010,$0000,$FFFE,$0003,$0002,$0000
		dc.w	$18A2,$F69D,$1002,$017D,$381C,$DFFF,$181C,$E000
		dc.w	$003F,$CFFF,$003F,$3000,$FFFF,$E000,$E000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$00FC,$00FC,$0000,$FFFF,$0001,$0001,$0000
		dc.w	$BB4E,$FF31,$B80E,$00F1,$201C,$C3FF,$001C,$FC00
		dc.w	$01FF,$FF81,$0181,$0000,$FFFF,$C000,$C000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$001E,$001E,$0000,$FFFF,$00FF,$00FF,$0000
		dc.w	$01C0,$9E20,$01C0,$7E3F,$41FF,$FEFC,$40FC,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FF6F,$0FFF,$0F0F,$0000
		dc.w	$FDA0,$87BF,$8400,$0040,$3F8F,$FFF0,$3F80,$0000
		dc.w	$AFFF,$FC00,$AC00,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$EFFB,$FCFF,$E003,$0300
		dc.w	$F828,$07E7,$0000,$001F,$8FFF,$FFFB,$0FFB,$0000
		dc.w	$FFDF,$F078,$C018,$0F80,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FE3F,$01FF,$000F,$0000
		dc.w	$8C11,$FFF6,$8C01,$000E,$11FF,$EFFC,$01FC,$F000
		dc.w	$DBF7,$3EF8,$0000,$0100,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0007,$0006,$0000
		dc.w	$0F00,$FFFF,$0F00,$0000,$0003,$FFFE,$0002,$0000
		dc.w	$FF6F,$0FFF,$0F0F,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFE0,$00FF,$00E0,$0000,$C338,$BC3F,$0000,$7FC0
		dc.w	$7FCF,$FE30,$7E00,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0003,$0003,$0000
		dc.w	$E3F8,$EFF8,$03F0,$1007,$0C1C,$0FEF,$000C,$F000
		dc.w	$3FFF,$F800,$3800,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0003,$0002,$0000
		dc.w	$39E1,$FFFC,$01E0,$0003,$08BC,$F0DF,$001C,$FF00
		dc.w	$1FFF,$F000,$1000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FF00,$01FF,$0100,$0000,$8780,$87FF,$0000,$7800
		dc.w	$7FFF,$F000,$7000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FF06,$00FF,$0000,$0001,$A3FF,$5F00,$8300,$6000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0001,$0001,$0000
		dc.w	$CF8C,$F1FC,$C180,$0003,$53FF,$AF00,$4300,$B000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0001,$0001,$0000
		dc.w	$8786,$F9FD,$8180,$0003,$18FF,$EF80,$0080,$F000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFF0,$00FF,$00F0,$0000,$040F,$87F8,$0008,$7800
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0FF8,$0FF8,$0000
		dc.w	$FFFE,$07FF,$07FE,$0000,$001F,$C3F8,$0018,$3C00
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFDF,$0FF9,$0FC0,$0006
		dc.w	$D80A,$FFFE,$1808,$0001,$7C3E,$7FFF,$003E,$8000
		dc.w	$FFFF,$E000,$E000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFF7,$01FF,$01F0,$0000
		dc.w	$7332,$FFF1,$7000,$000F,$11E0,$DFFF,$01E0,$E000
		dc.w	$3FFF,$F000,$3000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$001F,$001F,$0000
		dc.w	$FE7E,$E387,$E206,$0000,$0FF3,$F00F,$0003,$0000
		dc.w	$FFFF,$F000,$F000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F800,$07FF,$0000,$0000,$07FF,$F800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FCFF,$0707,$0407,$0000,$C3FF,$FC00,$C000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F800,$07FF,$0000,$0000,$07FF,$F800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F078,$0FFF,$0078,$0000,$03FF,$EE00,$0200,$1000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F800,$07FF,$0000,$0000,$07FF,$F800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$007F,$007F,$0000
		dc.w	$F6C0,$3FFF,$36C0,$0000,$FBFF,$FF00,$0B00,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$000E,$000E,$0000
		dc.w	$FFCC,$0FFC,$0FC0,$0003,$00E0,$1FFF,$00E0,$E000
		dc.w	$7FFF,$C000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$041F,$041F,$0000
		dc.w	$FFE0,$011F,$0100,$0000,$03F0,$FFF3,$0200,$000C
		dc.w	$7FFF,$C000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0100,$0100,$0000,$FC00,$1FFF,$1C00,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0720,$0720,$0000,$FF83,$047C,$0400,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F800,$07FF,$0000,$0000,$3800,$C7FF,$0000,$0000
		dc.w	$1FFF,$E000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F3A0,$7FFF,$7020,$0000,$03FF,$FC00,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F800,$07FF,$0000,$0000,$3800,$C7FF,$0000,$0000
		dc.w	$1FFF,$E000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F0F7,$3FFF,$30F0,$0000,$9C3F,$9FF0,$0030,$6000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$F800,$07FF,$0000,$0000,$3800,$C7FF,$0000,$0000
		dc.w	$1FFF,$E000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFE,$0007,$0006,$0001,$003F,$CFC0,$0000,$F000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFF0,$001F,$0010,$0000,$4FFF,$7F00,$0F00,$8000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFE7,$007F,$0067,$0000,$01FF,$FF00,$0100,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$380F,$380F,$0000,$C09F,$FFF0,$C090,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0007,$0007,$0000,$039F,$FFF0,$0390,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FF07,$03F8,$0300,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$F803,$1FFE,$1802,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFF0,$1F1F,$1F10,$0000,$F87F,$FFFF,$F87F,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$1FE0,$1FE0,$0000,$9FFF,$7E00,$1E00,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$CFFF,$3000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFF8,$000F,$0008,$0000,$0FFF,$FC00,$0C00,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$C7FF,$EFC0,$C7C0,$1000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0001,$0001,$0000,$C7FF,$F800,$C000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C7FF,$3800,$0000,$0000,$C7FF,$3800,$0000,$0000
		dc.w	$E3FF,$1C00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$C000,$3FFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$03FF,$FC00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFE,$0003,$0000,$0000
		dc.w	$7631,$DBDE,$4000,$0000,$8C79,$F78F,$0001,$0000
		dc.w	$C000,$3FFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$03FF,$FC00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFC,$0003,$0000,$0000
		dc.w	$A5F3,$5A0C,$0000,$0000,$3972,$C68D,$0000,$0000
		dc.w	$C000,$3FFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$03FF,$FC00,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFC,$0003,$0000,$0000
		dc.w	$A433,$5BCC,$0000,$0000,$18F0,$E78F,$0080,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFC,$0003,$0000,$0000
		dc.w	$A7B3,$584C,$0000,$0000,$3972,$C68D,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFC,$0003,$0000,$0000
		dc.w	$A473,$5BCC,$0000,$0000,$8D52,$F6AD,$0000,$0000
	rept	40	
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr

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
  
  even

*************************************************************
			
	SECTION	BSS

conterm       		ds.w	1 

Save_stack:				ds.l	1
	
Save_all:
									ds.b	5	* Mfp
									ds.b	3	* Video
Video							ds.b	1
									ds.b	1
									ds.l	1	* Vbl
									ds.l	1	* Kbd
									ds.l	1	* Timer b
									ds.l	1	* Timer a
									ds.l	1	* Timer c
									ds.l	1	* Timer d
									ds.w	16	* Palette

Tab_160:				  ds.w	200

Code_gen:         ds.w			(2*12)*166		* Place pour le code genere
									   											* pour l'effacement du cube
								  ds.w			1							* Place pour le rts
								  
rien            	ds.b	10000

Zorro_scr1:	ds.l	1

Zorro_screen1:	
	ds.b	256
start1:	
	ds.b	160*250
Zorro_screen1_len:	equ	*-start1

Zorro_scr2:	ds.l	1

Zorro_screen2:	
	ds.b	256
start2:	
	ds.b	160*250
Zorro_screen2_len:	equ	*-start2

Zorro_scr3:	ds.l	1

Zorro_screen3:	
	ds.b	256
start3:	
	ds.b	160*200
Zorro_screen3_len:	equ	*-start3

	END
