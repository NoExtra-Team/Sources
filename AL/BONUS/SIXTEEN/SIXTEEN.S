***************
* SIXTEEN.PRG *
***************

* // Loader Code version 0.31		// *
* // Original code : Zorro2/NoExtra	// *
* // Music 	   : Tomchi/NoExtra	// *
* // Release date  : 01/01/2008		// *
* // Update date   : 02/01/2008		// *

**************************************************
	OPT	c+	 ; Case sensitivity on.
	OPT	d-	 ; Debug off.
	OPT	o-	 ; All optimisations off.
	OPT	w-	 ; Warnings off.
	OPT	x-	 ; Extended debug off.
**************************************************

	SECTION	TEXT

**********************************************************
BOTTOM_BORDER	equ 0	  ; Using the bottom overscan
			  ; 0 = I use it and 1 = no need !
PATTERN		equ $0 	  ; To see the screen plan
			  ; put $0 to see nothing
			  ; put $010f to see lines
SEEMYVBL	equ 1     ; if you press ALT key
			  ; 0 = see CPU & 1 = see nothing
DEBUGGING	equ 0	  ; Detournement des bombes
			  ; sur le Reset.
RESET		equ 0	  ; 0 = cool reset and 1 = nop !
**********************************************************
gemdos		equ 1
crawcin		equ 7
cconws		equ 9
mshrink		equ $4a
pexec		equ $4b
**********************************************************

Start:

	jmp	ON_Y_VA

Label_Url:
	dc.b	'--> Visit our website at HTTP://WWW.NOEXTRA-TEAM.COM <--',0
	EVEN

Emp	DC.B 'Z:\',0
	EVEN

PROG1	DC.B 'Al_0.PRG',0
PROG2	DC.B 'Al_1.PRG',0
PROG3	DC.B 'Al_2.PRG',0
PROG4	DC.B 'Al_3.PRG',0
PROG5	DC.B 'Al_4.PRG',0
PROG6	DC.B 'Al_5.PRG',0
PROG7	DC.B 'Al_5.PRG',0
PROG8	DC.B 'Al_7.PRG',0
PROG9	DC.B 'Al_8.PRG',0
PROG10	DC.B 'Al_9.PRG',0
PROG11	DC.B 'Al_10.PRG',0
PROG12	DC.B 'Al_11.PRG',0
PROG13	DC.B 'Al_12.PRG',0
PROG14	DC.B 'Al_13.PRG',0
PROG15	DC.B 'Al_14.PRG',0
PROG16	DC.B 'Al_15.PRG',0

NOMPRG	DS.L 1

errtext:DC.B "PROBLEMS TO LOAD...          ",13,10,10,0
params: DC.B $0
environ:DC.B $0
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
	IFEQ	RESET
	MOVE.L	4.W,A0
	JMP	(A0)
	ELSEIF
	bra.s	FIN
	ENDC

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

	IFEQ	DEBUGGING
	MOVE.L	#Reset,$8.W
	MOVE.L	#Reset,$C.W
	MOVE.L	#Reset,$10.W
	MOVE.L	#Reset,$14.W
	MOVE.L	#Reset,$18.W
	MOVE.L	#Reset,$1C.W
	MOVE.L	#Reset,$20.W
	MOVE	#$2300,sr
	ENDC
	
	bsr	Init0

******************************************************************************

	bsr	Init

MainLoop:

	bsr	Wait_vbl

	IFEQ	SEEMYVBL
	clr.b	$ffff8240.w
	ENDC


* Put your code here !
* >
	BSR	PUT_TEXTE

* <

	MOVE.L    Zorro_scr1,D0
	;MOVE.L    Zorro_scr2,Zorro_scr1 
	;MOVE.L    D0,Zorro_scr2
	LSR.W     #8,D0 
	MOVE.L    D0,$FFFF8200.W
  	
	IFEQ	SEEMYVBL
	cmp.b	#$38,$fffffc02.w	* ALT KEY ?
	bne.s	MainNext
	move.b	#7,$ffff8240.w
MainNext:	
	ENDC

KEYBOARD:
* -->
	cmpi.b	#$3B,$FFFFFC02.w	* F1
	beq	Run1
	cmpi.b	#$3C,$FFFFFC02.w	* F2
	beq	Run2
	cmpi.b	#$3D,$FFFFFC02.w	* F3
	beq	Run3
	cmpi.b	#$3E,$FFFFFC02.w	* F4
	beq	Run4
	cmpi.b	#$3F,$FFFFFC02.w	* F5
	beq	Run5
	cmpi.b	#$40,$FFFFFC02.w	* F6
	beq	Run6
	cmpi.b	#$41,$FFFFFC02.w	* F7
	beq	Run7
	cmpi.b	#$42,$FFFFFC02.w	* F8
	beq	Run8
	cmpi.b	#$43,$FFFFFC02.w	* F9
	beq	Run9
	cmpi.b	#$02,$FFFFFC02.w	* 1
	beq	Run10
	cmpi.b	#$03,$FFFFFC02.w	* 2
	beq	Run11
	cmpi.b	#$04,$FFFFFC02.w	* 3
	beq	Run12
	cmpi.b	#$05,$FFFFFC02.w	* 4
	beq	Run13
	cmpi.b	#$06,$FFFFFC02.w	* 5
	beq	Run14
	cmpi.b	#$07,$FFFFFC02.w	* 6
	beq	Run15
	cmpi.b	#$08,$FFFFFC02.w	* 6
	beq	Run16

	cmpi.b	#$01,$fffffc02.w	* ESC
	beq	EXIT
* <--

	bne	MainLoop

******************************************************************************

Run1:	move.l	#PROG1,NOMPRG
	bra	RUN
Run2:	move.l	#PROG2,NOMPRG
	bra	RUN
Run3:	move.l	#PROG3,NOMPRG
	bra	RUN
Run4:	move.l	#PROG4,NOMPRG
	bra	RUN
Run5:	move.l	#PROG5,NOMPRG
	bra	RUN
Run6:	move.l	#PROG6,NOMPRG
	bra	RUN
Run7:	move.l	#PROG7,NOMPRG
	bra	RUN
Run8:	move.l	#PROG8,NOMPRG
	bra	RUN
Run9:	move.l	#PROG9,NOMPRG
	bra	RUN
Run10:	move.l	#PROG10,NOMPRG
	bra	RUN
Run11:	move.l	#PROG11,NOMPRG
	bra	RUN
Run12:	move.l	#PROG12,NOMPRG
	bra	RUN
Run13:	move.l	#PROG13,NOMPRG
	bra	RUN
Run14:	move.l	#PROG14,NOMPRG
	bra	RUN
Run15:	move.l	#PROG15,NOMPRG
	bra	RUN
Run16:	move.l	#PROG16,NOMPRG
	bra	RUN

************************************************
*                                              *
*               Sub Routines                   *
*                                              *
************************************************

Vbl0:
	movem.l	d0-d7/a0-a6,-(a7)
	st	Vsync
	jsr 	(MUSIC+8)			; call music
	movem.l	(a7)+,d0-d7/a0-a6
	rte
	
Vbl:	movem.l	d0-d7/a0-a6,-(a7)

	st	Vsync

	BSR	DISPLAY_TEXTE
	
	IFEQ	BOTTOM_BORDER
      CLR.W     $FFFF820A.W 
      MOVEQ     #1,D0 
.loop:DBF       D0,.loop
      MOVE.B    #2,$FFFF820A.W
      BSR       PUTHBL 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      MOVE.W    #0,$FFFF8240.W
	ENDC

	jsr 	(MUSIC+8)			; call music

	movem.l	(a7)+,d0-d7/a0-a6
	rte

NB_LIGNE_RAST equ 196
COULEUR_RASTER equ $FFFF8240

PUTHBL:MOVEQ     #$10,D3 
.synch:MOVE.B    $FFFF8209.W,D2
      BEQ.S     .synch 
      SUB.W     D2,D3 
      LSR.L     D3,D2 
      MOVEQ     #$13,D7 
.loop:DBF       D7,.loop
      LEA       COULEUR_RASTER,A0 
      MOVEQ     #1,D1 
      LEA       DATAS(PC),A6
      LEA       16(A6),A3 
      LEA       254(A3),A2
      LEA       4000(A2),A4 
      MOVE.W    #NB_LIGNE_RAST,D7 
      LEA       170(A4),A5
ETIQU:EQU       *-2 
      LEA       138(A4),A4
.rootl:LSR.W     D1,D1 
      MOVE.W    (A4)+,D0
      ADD.W     (A5)+,D0
      LEA       2(A4),A4
      LEA       4(A5),A5
      MOVE.L    0(A2,D0.W),D0 
      MOVEQ     #6,D1 
      SUB.W     D0,D1 
      LSR.W     D0,D0 
      SWAP      D0
      LEA       0(A3,D0.W),A1 
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      MOVE.W    (A1)+,(A0)
      DBF       D7,.rootl
      LEA       ETIQU(PC),A0
      MOVE.W    (A6),D0 
      SUBQ.W    #2,(A0) 
      BPL.S     mynext 
      ADD.W     D0,(A0) 
mynext:SUBQ.W    #6,4(A0)
      BPL.S     myrte 
      ADD.W     D0,4(A0)
myrte:RTS 

Wait_vbl:
	move.l	a0,-(a7)
	lea	Vsync,a0
	sf	(a0)
.loop:	tst.b	(a0)
	beq.s	.loop
	move.l	(a7)+,a0
	rts

*********************************************
*                                           *
*********************************************

Init:	movem.l	d0-d7/a0-a6,-(a7)

	lea	Vbl(pc),a0
	move.l	a0,$70.w

	lea	Pal(pc),a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

	movem.l	(a7)+,d0-d7/a0-a6
	rts

Init0:	movem.l	d0-d7/a0-a6,-(a7)

	bsr	fadein
	
	clr.w	$ffff8240.w
	
	jsr	MUSIC+0			; init music

	move.l	Zorro_scr2,d0
	move.b	d0,d1
	lsr.w	#8,d0
	move.b	d0,$ffff8203.w
	swap	d0
	move.b	d0,$ffff8201.w
	move.b	d1,$ffff820d.w
	
	movea.l	Zorro_scr2,a1
	adda.l	#160*36,a1
	movea.l	#Logo_Al,a0
	move.l	#7999-2800,d0
.aff:	move.l	(a0)+,(a1)+
	dbf	d0,.aff
                	
	lea	Vbl0(pc),a0
	move.l	a0,$70.w

	lea	Pal_Al,a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

	bsr	delay

	BSR	INIT_TEXTE

	bsr	fadeoff

	move.l	Zorro_scr1,d0
	move.b	d0,d1
	lsr.w	#8,d0
	move.b	d0,$ffff8203.w
	swap	d0
	move.b	d0,$ffff8201.w
	move.b	d1,$ffff820d.w

	bsr	delay2
	
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

	clr.b	$fffffa07.w 
	clr.b	$fffffa09.w 

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

	movea.l   $44e.w,a0 
	move.w    #8000-1,d0 
.cls:	clr.l     (a0)+ 
	dbf       d0,.cls

	move.b	Video,$ffff8260.w

	move.w	#$25,-(a7)
	trap	#14
	addq.w	#2,a7

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
	
	movea.l	Zorro_scr1,a6
	move.w	#Zorro_screen1_len/4-1,d1
.scr1:	move.l	#PATTERN,(a6)+
	dbra	d1,.scr1

	movea.l	Zorro_scr2,a6
	move.w	#Zorro_screen2_len/4-1,d1
.scr2:	move.l	#PATTERN,(a6)+
	dbra	d1,.scr2
	
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

flush:	lea	$FFFFFC00.w,a0
.flush:	move.b	2(a0),d0
	btst	#0,(a0)
	bne.s	.flush
	rts

setkeyboard:
.wait:	btst	#1,$fffffc00.w
	beq.s	.wait
	move.b	d0,$FFFFFC02.w
	rts

clear_bss:
	lea	bss_start,a0
.loop:	clr.l	(a0)+
	cmp.l	#bss_end,a0
	blt.s	.loop
	rts


************************************************
*           FADING WHITE TO BLACK              *
*         (Don't use VBL with it !)            *
************************************************

fadein:	move.l	#$777,d0
.deg:	bsr.s	wart
	bsr.s	wart
	bsr.s	wart
	lea	$ffff8240.w,a0
	moveq	#15,d1
.chg1:	move.w	d0,(a0)+
	dbf	d1,.chg1
	sub.w	#$111,d0
	bne.s	.deg
	clr.w	$ffff8240.w
	rts

wart:	move.l	d0,-(sp)
	move.l	$466.w,d0
.att:	cmp.l	$466.w,d0
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

delay2:
  MOVE.b     #$7F/4,D0 
	bra.s	synch
delay:
  MOVE.b     #$7F,D0 
synch:
	BSR       Wait_vbl
	sub.b	#1,d0
	cmp.b	#$0,d0	
	bne.s	synch
	rts	
	
************************************************
*                                              *
************************************************

INIT_TEXTE:
      MOVE.W    #1,PART_2
      MOVE.W    #2,PART_3
      MOVE.W    #6,PART_1
      MOVEA.L   PTR_LIGNE,A0
      MOVE.W    6(A0),BUF_LIGNE 
      ST        TEST_END 
      RTS

DISPLAY_TEXTE:
      SUBQ.W    #1,BUF_LIGNE
      BPL.S     .2_init 
      ADDQ.L    #8,PTR_LIGNE
      CMPI.L    #PTR_TEXTE,PTR_LIGNE
      BNE.S     .1_init 
      MOVE.L    #LIGNE_SUITE,PTR_LIGNE
.1_init:MOVEA.L   PTR_LIGNE,A0
      MOVE.W    6(A0),BUF_LIGNE 
.2_init:MOVEA.L   PTR_LIGNE,A0
			RTS

PUT_TEXTE:
			TST.W     TEST_END 
      BNE.S     .work 
      TST.W     TEST_CLS 
      BNE       CLEAR 
      SUBQ.W    #1,PART_2
      BPL       myEND 
      ST        TEST_CLS 
      BRA       myEND 
.work:MOVEQ     #0,D0 
      MOVEA.L   PTR_TEXTE,A0
      MOVEA.L   Zorro_scr1,A1
      MOVEA.L   PTR_CAR,A2
      SUBQ.W    #1,PART_3
      BPL.S     .next 
      MOVE.W    #2,PART_3
      ADDQ.W    #1,A0 
      ADDQ.W    #2,A2 
      MOVE.L    A2,PTR_CAR
.next:MOVE.B    (A0),D0 
      BPL.S     .put_c 
      ADDQ.W    #1,A0 
      CMPA.L    #PTR_CAR,A0 
      BNE.S     .texte 
      LEA       TEXTE,A0
.texte:MOVE.L    A0,PTR_TEXTE
      MOVE.W    #$64,PART_2
      CLR.W     TEST_END 
      MOVE.L    #CARAC,PTR_CAR
      BRA.S     myEND 
.put_c:MOVE.L    A0,PTR_TEXTE
      ADDA.W    (A2),A1 
      SUBI.B    #32,D0 
      MULU      #34,D0 
      LEA       FONTE,A2
      LEA       0(A2,D0.W),A2 
      MOVE.W    (A2)+,(A1)
      MOVE.W    (A2)+,160(A1) 
      MOVE.W    (A2)+,320(A1) 
      MOVE.W    (A2)+,480(A1) 
      MOVE.W    (A2)+,640(A1) 
      MOVE.W    (A2)+,800(A1) 
      MOVE.W    (A2)+,960(A1) 
      MOVE.W    (A2)+,1120(A1)
      MOVE.W    (A2)+,1280(A1)
      MOVE.W    (A2)+,1440(A1)
      MOVE.W    (A2)+,1600(A1)
      MOVE.W    (A2)+,1760(A1)
      MOVE.W    (A2)+,1920(A1)
      MOVE.W    (A2)+,2080(A1)
      MOVE.W    (A2)+,2240(A1)
      MOVE.W    (A2)+,2400(A1)
      MOVE.W    (A2)+,2560(A1)
myEND:RTS 

CLEAR:MOVEA.L   Zorro_scr1,A0
      MOVEA.L   Zorro_scr1,A1
      ADDA.W    PART_1,A0
      ADDA.W    PART_1,A1
      ADDI.W    #160,PART_1
      CMPI.W    #204*160+6,PART_1
      BNE.S     CLR_SCR 
      MOVE.W    #6,PART_1
      CLR.W     TEST_CLS 
      ST        TEST_END 
      RTS 

CLR_SCR:MOVEQ     #20-1,D0 
      MOVEQ     #0,D1 
.loop:MOVE.W    D1,(A0)+
      MOVE.W    D1,(A1)+
      ADDQ.W    #6,A0 
      ADDQ.W    #6,A1 
      DBF       D0,.loop
      RTS       
			
******************************************************************
	SECTION	DATA
******************************************************************

Pal:	
	dc.w	$000,$777,$111,$222,$333,$444,$555,$666
	dc.w	$777,$111,$222,$333,$444,$555,$666,$777

* Full data here :
* >
FONTE:
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$7000,$7000,$7000
	dc.w	$7000,$7000,$7000,$7000
	dc.w	$7000,$7000,$7000,$7000
	dc.w	$7000,$7000,$0000,$7000
	dc.w	$7000,$7000,$39C0,$39C0
	dc.w	$39C0,$0840,$1080,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$1C70
	dc.w	$1C70,$1C70,$1C70,$FFFE
	dc.w	$FFFE,$FFFE,$1C70,$1C70
	dc.w	$1C70,$FFFE,$FFFE,$FFFE
	dc.w	$1C70,$1C70,$1C70,$1C70
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$3800
	dc.w	$3800,$3800,$0800,$1000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$000E,$003E,$007E,$00F0
	dc.w	$00E0,$01C0,$01C0,$01C0
	dc.w	$01C0,$01C0,$01C0,$01C0
	dc.w	$00E0,$00F0,$007E,$003E
	dc.w	$000E,$3800,$3E00,$3F00
	dc.w	$0780,$0380,$01C0,$01C0
	dc.w	$01C0,$01C0,$01C0,$01C0
	dc.w	$01C0,$0380,$0780,$3F00
	dc.w	$3E00,$3800,$0380,$0380
	dc.w	$2388,$739C,$3BB8,$1FF0
	dc.w	$0FE0,$FFFE,$FFFE,$FFFE
	dc.w	$0FE0,$1FF0,$3BB8,$739C
	dc.w	$2388,$0380,$0380,$0380
	dc.w	$0380,$0380,$0380,$0380
	dc.w	$0380,$0380,$FFFE,$FFFE
	dc.w	$FFFE,$0380,$0380,$0380
	dc.w	$0380,$0380,$0380,$0380
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$3800,$3800,$3800,$0800
	dc.w	$1000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$FFFE,$FFFE,$FFFE,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$3800,$3800,$3800,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$07C0,$1FF0,$3FF8,$783C
	dc.w	$703C,$E07E,$E0EE,$E1CE
	dc.w	$E38E,$E70E,$EE0E,$FC0E
	dc.w	$781C,$783C,$3FF8,$1FF0
	dc.w	$07C0,$0060,$00E0,$01E0
	dc.w	$03E0,$07E0,$0FE0,$1FE0
	dc.w	$1EE0,$1CE0,$00E0,$00E0
	dc.w	$00E0,$00E0,$00E0,$00E0
	dc.w	$00E0,$00E0,$FFC0,$FFF0
	dc.w	$FFF8,$003C,$001C,$000E
	dc.w	$000E,$000E,$001C,$003C
	dc.w	$0FF8,$3FF0,$7FC0,$7800
	dc.w	$FFFE,$FFFE,$7FFE,$FFFE
	dc.w	$FFFC,$FFF8,$00F0,$01E0
	dc.w	$03F0,$07F8,$003C,$001C
	dc.w	$000E,$000E,$000E,$001C
	dc.w	$003C,$FFF8,$FFF0,$FFC0
	dc.w	$E0E0,$E0E0,$E0E0,$E0E0
	dc.w	$E0E0,$E0E0,$70E0,$78E0
	dc.w	$3FFE,$1FFE,$07FE,$00E0
	dc.w	$00E0,$00E0,$00E0,$00E0
	dc.w	$00E0,$FFFE,$FFFE,$7FFE
	dc.w	$7800,$3FC0,$1FF0,$07F8
	dc.w	$003C,$001C,$000E,$000E
	dc.w	$000E,$001C,$003C,$FFF8
	dc.w	$FFF0,$FFC0,$07FE,$1FFE
	dc.w	$3FFE,$7800,$7FC0,$FFF0
	dc.w	$FFF8,$F03C,$E01C,$E00E
	dc.w	$E00E,$E00E,$701C,$783C
	dc.w	$3FF8,$1FF0,$07C0,$FFC0
	dc.w	$FFF0,$FFF8,$003C,$001C
	dc.w	$000E,$000E,$000E,$000E
	dc.w	$000E,$000E,$000E,$000E
	dc.w	$000E,$000E,$000E,$000E
	dc.w	$07C0,$1FF0,$3FF8,$783C
	dc.w	$701C,$E00E,$E00E,$E00E
	dc.w	$701C,$783C,$7FFC,$FFFE
	dc.w	$FFFE,$E00E,$FFFE,$FFFE
	dc.w	$7FFC,$07C0,$1FF0,$3FF8
	dc.w	$783C,$701C,$E00E,$E00E
	dc.w	$E00E,$700E,$781E,$3FFE
	dc.w	$1FFE,$07FC,$003C,$FFF8
	dc.w	$FFF0,$FFC0,$0000,$0000
	dc.w	$0000,$0000,$3800,$3800
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$3800,$3800,$3800,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$3800
	dc.w	$3800,$3800,$0000,$3800
	dc.w	$3800,$3800,$0800,$1000
	dc.w	$0000,$0000,$0000,$0200
	dc.w	$0600,$0E08,$1E38,$3EF8
	dc.w	$7FF8,$3EF8,$1E38,$0E08
	dc.w	$0600,$0200,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$FFFE,$FFFE,$FFFE
	dc.w	$0000,$0000,$0000,$FFFE
	dc.w	$FFFE,$FFFE,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0080,$00C0,$20E0
	dc.w	$38F0,$3EF8,$3FFC,$3EF8
	dc.w	$38F0,$20E0,$00C0,$0080
	dc.w	$0000,$0000,$0000,$FFFC
	dc.w	$FFFE,$FFFE,$000E,$000E
	dc.w	$7FFE,$FFFE,$FFFC,$E000
	dc.w	$E000,$FFFE,$FFFE,$7FFE
	dc.w	$0000,$0380,$0380,$0380
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$FFC0,$FFF0,$FFF8
	dc.w	$E03C,$E01C,$E00E,$E00E
	dc.w	$E00E,$E00E,$E00E,$FFFE
	dc.w	$FFFE,$FFFE,$E00E,$E00E
	dc.w	$E00E,$E00E,$FFFE,$FFFE
	dc.w	$FFFE,$E03C,$FFF8,$FFF0
	dc.w	$FFF8,$E03C,$E01C,$E00E
	dc.w	$E00E,$E00E,$E01C,$E03C
	dc.w	$FFF8,$FFF0,$FFC0,$07E0
	dc.w	$1FF8,$3FFC,$781E,$700E
	dc.w	$E000,$E000,$E000,$E000
	dc.w	$E000,$E000,$E000,$700E
	dc.w	$781E,$3FFC,$1FF8,$07E0
	dc.w	$FFC0,$FFF0,$FFF8,$E03C
	dc.w	$E01C,$E00E,$E00E,$E00E
	dc.w	$E00E,$E00E,$E00E,$E00E
	dc.w	$E01C,$E03C,$FFF8,$FFF0
	dc.w	$FFC0,$FFFE,$FFFE,$FFFE
	dc.w	$E000,$FFFE,$FFFE,$FFFE
	dc.w	$E000,$E000,$E000,$E000
	dc.w	$E000,$7000,$7800,$3FFE
	dc.w	$1FFE,$07FE,$07FE,$1FFE
	dc.w	$3FFE,$7800,$7FFE,$FFFE
	dc.w	$FFFE,$E000,$E000,$E000
	dc.w	$E000,$E000,$E000,$E000
	dc.w	$E000,$E000,$E000,$07E0
	dc.w	$1FF8,$3FFC,$781E,$700E
	dc.w	$E000,$E000,$E000,$E000
	dc.w	$E000,$E00E,$E00E,$700E
	dc.w	$780E,$3FFE,$1FFE,$07FE
	dc.w	$E00E,$E00E,$E00E,$E00E
	dc.w	$FFFE,$FFFE,$FFFE,$E00E
	dc.w	$E00E,$E00E,$E00E,$E00E
	dc.w	$E00E,$E00E,$E00E,$E00E
	dc.w	$E00E,$FFFE,$FFFE,$FFFE
	dc.w	$0380,$0380,$0380,$0380
	dc.w	$0380,$0380,$0380,$0380
	dc.w	$0380,$0380,$0380,$FFFE
	dc.w	$FFFE,$FFFE,$03FE,$03FE
	dc.w	$03FE,$000E,$000E,$000E
	dc.w	$000E,$000E,$000E,$000E
	dc.w	$000E,$000E,$001C,$003C
	dc.w	$FFF8,$FFF0,$FFC0,$E00E
	dc.w	$E00E,$E01C,$E03C,$FFF8
	dc.w	$FFF0,$FFF8,$E03C,$E01C
	dc.w	$E00E,$E00E,$E00E,$E00E
	dc.w	$E00E,$E00E,$E00E,$E00E
	dc.w	$E000,$E000,$E000,$E000
	dc.w	$E000,$E000,$E000,$E000
	dc.w	$E000,$E000,$E000,$E000
	dc.w	$7000,$7800,$3FFE,$1FFE
	dc.w	$07FE,$C006,$E00E,$F01E
	dc.w	$F83E,$FC7E,$FEFE,$FFFE
	dc.w	$EFEE,$E7CE,$E38E,$E10E
	dc.w	$E00E,$E00E,$E00E,$E00E
	dc.w	$E00E,$E00E,$C00E,$E00E
	dc.w	$F00E,$F80E,$FC0E,$FE0E
	dc.w	$FF0E,$EF8E,$E7CE,$E3EE
	dc.w	$E1FE,$E0FE,$E07E,$E03E
	dc.w	$E01E,$E00E,$E006,$07C0
	dc.w	$1FF0,$3FF8,$783C,$701C
	dc.w	$E00E,$E00E,$E00E,$E00E
	dc.w	$E00E,$E00E,$E00E,$701C
	dc.w	$783C,$3FF8,$1FF0,$07C0
	dc.w	$FFC0,$FFF0,$FFF8,$E03C
	dc.w	$E01C,$E00E,$E00E,$E00E
	dc.w	$E01C,$E03C,$FFF8,$FFF0
	dc.w	$FFC0,$E000,$E000,$E000
	dc.w	$E000,$07C0,$1FF0,$3FF8
	dc.w	$783C,$701C,$E00E,$E00E
	dc.w	$E00E,$E00E,$E00E,$E00E
	dc.w	$E00E,$700E,$780E,$3FEE
	dc.w	$1FEE,$07EE,$FFC0,$FFF0
	dc.w	$FFF8,$E03C,$E01C,$E00E
	dc.w	$E00E,$E00E,$E01C,$E03C
	dc.w	$FFF8,$FFF0,$FFF8,$E03C
	dc.w	$E01C,$E00E,$E00E,$1FFE
	dc.w	$7FFE,$FFFE,$E000,$FFC0
	dc.w	$7FF0,$1FF8,$003C,$001C
	dc.w	$000E,$000E,$000E,$001C
	dc.w	$003C,$FFF8,$FFF0,$FFC0
	dc.w	$FFFE,$FFFE,$FFFE,$0380
	dc.w	$0380,$0380,$0380,$0380
	dc.w	$0380,$0380,$0380,$0380
	dc.w	$0380,$0380,$0380,$0380
	dc.w	$0380,$E00E,$E00E,$E00E
	dc.w	$E00E,$E00E,$E00E,$E00E
	dc.w	$E00E,$E00E,$E00E,$E00E
	dc.w	$E00E,$701C,$783C,$3FF8
	dc.w	$1FF0,$07C0,$C00E,$E00E
	dc.w	$F00E,$F80E,$7C0E,$3E0E
	dc.w	$1F0E,$0F8E,$07CE,$03EE
	dc.w	$01FE,$00FE,$007E,$003E
	dc.w	$001E,$000E,$0006,$E00E
	dc.w	$E00E,$E00E,$E00E,$E00E
	dc.w	$E00E,$E10E,$E38E,$E7CE
	dc.w	$EFEE,$FFFE,$FEFE,$FC7E
	dc.w	$F83E,$F01E,$E00E,$C006
	dc.w	$E00E,$E00E,$E00E,$701C
	dc.w	$783C,$3FF8,$1FF0,$3FF8
	dc.w	$783C,$701C,$E00E,$E00E
	dc.w	$E00E,$E00E,$E00E,$E00E
	dc.w	$E00E,$E00E,$E00E,$E00E
	dc.w	$E00E,$E00E,$E00E,$700E
	dc.w	$780E,$3FFE,$1FFE,$07FE
	dc.w	$000E,$000E,$000E,$000E
	dc.w	$000E,$000E,$FFFE,$FFFE
	dc.w	$FFFE,$003E,$007C,$00F8
	dc.w	$01F0,$03E0,$07C0,$0F80
	dc.w	$1F00,$3E00,$7C00,$F800
	dc.w	$FFFE,$FFFE,$FFFE,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
BUF_LIGNE:
	dc.w	$0
PTR_LIGNE:
	dc.l	LIGNE
LIGNE:
	dc.w	$0000,$0000,$0000,$017C
	dc.w	$0100,$0001,$0000,$0001
	dc.w	$0200,$0002,$0000,$0001
	dc.w	$0300,$0003,$0000,$0001
	dc.w	$0400,$0004,$0000,$0001
	dc.w	$0500,$0005,$0000,$0001
	dc.w	$0600,$0006,$0000,$0001
	dc.w	$0700,$0007,$0000,$0032
LIGNE_SUITE:
	dc.w	$0710,$0007,$0000,$0005
	dc.w	$0720,$0007,$0000,$0005
	dc.w	$0730,$0007,$0000,$0005
	dc.w	$0740,$0007,$0000,$0005
	dc.w	$0750,$0007,$0000,$0005
	dc.w	$0760,$0007,$0000,$0005
	dc.w	$0770,$0007,$0000,$0005
	dc.w	$0760,$0106,$0000,$0005
	dc.w	$0750,$0205,$0000,$0005
	dc.w	$0740,$0304,$0000,$0005
	dc.w	$0730,$0403,$0000,$0005
	dc.w	$0720,$0502,$0000,$0005
	dc.w	$0710,$0601,$0000,$0005
	dc.w	$0700,$0700,$0000,$0005
	dc.w	$0701,$0700,$0000,$0005
	dc.w	$0702,$0700,$0000,$0005
	dc.w	$0703,$0700,$0000,$0005
	dc.w	$0704,$0700,$0000,$0005
	dc.w	$0705,$0700,$0000,$0005
	dc.w	$0706,$0700,$0000,$0005
	dc.w	$0707,$0700,$0000,$0005
	dc.w	$0617,$0710,$0010,$0005
	dc.w	$0527,$0720,$0020,$0005
	dc.w	$0437,$0730,$0030,$0005
	dc.w	$0347,$0740,$0040,$0005
	dc.w	$0257,$0750,$0050,$0005
	dc.w	$0167,$0760,$0060,$0005
	dc.w	$0077,$0770,$0070,$0005
	dc.w	$0167,$0670,$0060,$0005
	dc.w	$0257,$0570,$0050,$0005
	dc.w	$0347,$0470,$0040,$0005
	dc.w	$0437,$0370,$0030,$0005
	dc.w	$0527,$0270,$0020,$0005
	dc.w	$0617,$0170,$0010,$0005
	dc.w	$0707,$0070,$0000,$0005
	dc.w	$0706,$0071,$0000,$0005
	dc.w	$0705,$0072,$0000,$0005
	dc.w	$0704,$0073,$0000,$0005
	dc.w	$0703,$0074,$0000,$0005
	dc.w	$0702,$0075,$0000,$0005
	dc.w	$0701,$0076,$0000,$0005
	dc.w	$0700,$0077,$0000,$0005
	dc.w	$0601,$0067,$0000,$0005
	dc.w	$0502,$0057,$0000,$0005
	dc.w	$0403,$0047,$0000,$0005
	dc.w	$0304,$0037,$0000,$0005
	dc.w	$0205,$0027,$0000,$0005
	dc.w	$0106,$0017,$0000,$0005
	dc.w	$0007,$0007,$0000,$0005
	dc.w	$0116,$0116,$0000,$0005
	dc.w	$0225,$0225,$0000,$0005
	dc.w	$0334,$0334,$0000,$0005
	dc.w	$0443,$0443,$0000,$0005
	dc.w	$0552,$0552,$0000,$0005
	dc.w	$0661,$0661,$0000,$0005
	dc.w	$0770,$0770,$0000,$0005
	dc.w	$0771,$0761,$0000,$0005
	dc.w	$0772,$0752,$0000,$0005
	dc.w	$0773,$0743,$0000,$0005
	dc.w	$0774,$0734,$0000,$0005
	dc.w	$0775,$0725,$0000,$0005
	dc.w	$0776,$0716,$0000,$0005
	dc.w	$0777,$0707,$0000,$0005
	dc.w	$0666,$0606,$0001,$0005
	dc.w	$0555,$0505,$0002,$0005
	dc.w	$0444,$0404,$0003,$0005
	dc.w	$0333,$0303,$0004,$0005
	dc.w	$0222,$0202,$0005,$0005
	dc.w	$0111,$0101,$0006,$0005
	dc.w	$0000,$0000,$0007,$0005
	dc.w	$0000,$0000,$0017,$0005
	dc.w	$0000,$0000,$0027,$0005
	dc.w	$0000,$0000,$0037,$0005
	dc.w	$0000,$0000,$0047,$0005
	dc.w	$0000,$0000,$0057,$0005
	dc.w	$0000,$0000,$0067,$0005
	dc.w	$0000,$0000,$0077,$0005
	dc.w	$0000,$0000,$0076,$0005
	dc.w	$0000,$0000,$0075,$0005
	dc.w	$0000,$0000,$0074,$0005
	dc.w	$0000,$0000,$0073,$0005
	dc.w	$0000,$0000,$0072,$0005
	dc.w	$0000,$0000,$0071,$0005
	dc.w	$0000,$0000,$0070,$0005
	dc.w	$0000,$0000,$0170,$0005
	dc.w	$0000,$0000,$0270,$0005
	dc.w	$0000,$0000,$0370,$0005
	dc.w	$0000,$0000,$0470,$0005
	dc.w	$0000,$0000,$0570,$0005
	dc.w	$0000,$0000,$0670,$0005
	dc.w	$0000,$0000,$0770,$0005
	dc.w	$0000,$0000,$0760,$0005
	dc.w	$0000,$0000,$0750,$0005
	dc.w	$0000,$0000,$0740,$0005
	dc.w	$0000,$0000,$0730,$0005
	dc.w	$0000,$0000,$0720,$0005
	dc.w	$0000,$0000,$0710,$0005
	dc.w	$0000,$0000,$0700,$0005
	dc.w	$0101,$0001,$0600,$0005
	dc.w	$0202,$0002,$0500,$0005
	dc.w	$0303,$0003,$0400,$0005
	dc.w	$0404,$0004,$0300,$0005
	dc.w	$0505,$0005,$0200,$0005
	dc.w	$0606,$0006,$0100,$0005
	dc.w	$0707,$0007,$0000,$0005
	dc.w	$0616,$0116,$0100,$0005
	dc.w	$0525,$0225,$0200,$0005
	dc.w	$0434,$0334,$0300,$0005
	dc.w	$0343,$0443,$0400,$0005
	dc.w	$0252,$0552,$0500,$0005
	dc.w	$0161,$0661,$0600,$0005
	dc.w	$0070,$0770,$0700,$0005
	dc.w	$0160,$0661,$0700,$0005
	dc.w	$0250,$0552,$0600,$0005
	dc.w	$0340,$0443,$0500,$0005
	dc.w	$0430,$0334,$0400,$0005
	dc.w	$0520,$0225,$0300,$0005
	dc.w	$0610,$0116,$0200,$0005
	dc.w	$0700,$0007,$0100,$0005
PTR_TEXTE:
	DC.L	TEXTE 
TEXTE:
;      DC.B      'ABCDEFGHIJKLMNOPQRST'
;      DC.B      'UVWXYZ 0123456789   '
;      DC.B      ',;:.!?()*-+        ',$27
;      DC.B      '                    '
;      DC.B      'ABCDEFGHIJKLMNOPQRST'
;      DC.B      'UVWXYZ 0123456789   '
;      DC.B      ',;:.!?()*-+        ',$27
;      DC.B      '                    '
;      DC.B      'ABCDEFGHIJKLMNOPQRST'
;      DC.B      'UVWXYZ 0123456789   '
;      DC.B      ',;:.!?()*-+        ',$27
;      DC.B      $FF
      
;      DC.B      '********************'
;      DC.B      '*                  *'
;      DC.B      '*                  *'
;      DC.B      '*                  *'
;      DC.B      '*                  *'
;      DC.B      '*                  *'
;      DC.B      '*                  *'
;      DC.B      '*                  *'
;      DC.B      '*                  *'
;      DC.B      '*                  *'
;      DC.B      '********************'
;      DC.B      $FF
      
      DC.B      '********************'
      DC.B      '*                  *'
      DC.B      '* NOEXTRA IS PROUD *'
      DC.B      '*                  *'
      DC.B      '*    TO PRESENT    *'
      DC.B      '*                  *'
      DC.B      '*   THIS LITTLE    *'
      DC.B      '*                  *'
      DC.B      '*       MENU       *'
      DC.B      '*                  *'
      DC.B      '********************'
      DC.B      $FF
      
			DC.B      '********************'
      DC.B      '*                  *'
      DC.B      '*   SINCE 2005     *'
      DC.B      '*                  *'
      DC.B      '*  WHO HAVE MADE   *'
      DC.B      '*                  *'
      DC.B      '*  SIXTEEN INTROS  *'
      DC.B      '*                  *'
      DC.B      '*       FOR        *'
      DC.B      '*                  *'
      DC.B      '********************'
      DC.B      $FF
      
      DC.B      '********************'
      DC.B      '*                  *'
      DC.B      '*        THE       *'
      DC.B      '*                  *'
      DC.B      '*       VERY       *'
      DC.B      '*                  *'
      DC.B      '*       BEST       *'
      DC.B      '*                  *'
      DC.B      '*   ATARI-LEGEND   *'
      DC.B      '*                  *'
      DC.B      '********************'
      DC.B      $FF

			DC.B      '********************'
      DC.B      '*                  *'
      DC.B      '*  TEXT MENU AND   *'
      DC.B      '*                  *'
      DC.B      '* IDEA FROM ATOMUS *'
      DC.B      '*                  *'
      DC.B      '* LITTLE CODE FROM *'
      DC.B      '*                  *'
      DC.B      '*     ZORRO 2      *'
      DC.B      '*                  *'
      DC.B      '********************'
      DC.B      $FF
      
      DC.B      '********************'
      DC.B      '*                  *'
      DC.B      '*                  *'
      DC.B      '*   GFX FROM THE   *'
      DC.B      '*                  *'
      DC.B      '*    SURNATURAL    *'
      DC.B      '*                  *'
      DC.B      '*     MISTER.A     *'
      DC.B      '*                  *'
      DC.B      '*                  *'
      DC.B      '********************'
      DC.B      $FF
      
			DC.B      '********************'
      DC.B      '*                  *'
      DC.B      '*   AND THE BEST   *'
      DC.B      '*                  *'
      DC.B      '*   PART FOR OUR   *'
      DC.B      '*                  *'
      DC.B      '*  GREAT MUSICIAN  *'
      DC.B      '*                  *'
      DC.B      '*      TOMCHI      *'
      DC.B      '*                  *'
      DC.B      '********************'
      DC.B      $FF
      
      DC.B      '********************'
      DC.B      '*                  *'
      DC.B      '* YOU CAN USE SOME *'
      DC.B      '*                  *'
      DC.B      '* KEYS TO SEE ALL  *'
      DC.B      '*                  *'
      DC.B      '*  THE INTROS ON   *'
      DC.B      '*                  *'
      DC.B      '* THIS EXTRA MENU  *'
      DC.B      '*                  *'
      DC.B      '********************'
      DC.B      $FF

      DC.B      '********************'
      DC.B      '*                  *'
      DC.B      '* F1: AL NUMBER 0  *'
      DC.B      '* F2: AL NUMBER 1  *'
      DC.B      '* F3: AL NUMBER 2  *'
      DC.B      '* F4: AL NUMBER 3  *'
      DC.B      '* F5: AL NUMBER 4  *'
      DC.B      '* F6: AL NUMBER 5  *'
      DC.B      '* F7: AL NUMBER 6  *'
      DC.B      '*                  *'
      DC.B      '********************'
      DC.B      $FF

      DC.B      '********************'
      DC.B      '*                  *'
      DC.B      '* F8: AL NUMBER 7  *'
      DC.B      '* F9: AL NUMBER 8  *'
      DC.B      '* 1 : AL NUMBER 9  *'
      DC.B      '* 2 : AL NUMBER 10 *'
      DC.B      '* 3 : AL NUMBER 11 *'
      DC.B      '* 4 : AL NUMBER 12 *'
      DC.B      '* 5 : AL NUMBER 13 *'
      DC.B      '*                  *'
      DC.B      '********************'
      DC.B      $FF

      DC.B      '********************'
      DC.B      '*                  *'
      DC.B      '* AND...           *'
      DC.B      '*                  *'
      DC.B      '* 6 : AL NUMBER 14 *'
      DC.B      '* 7 : AL NUMBER 15 *'
      DC.B      '*                  *'
      DC.B      '* SPECIAL INTROS   *'
      DC.B      '* STF-E : NO 0,2,3 *'
      DC.B      '*                  *'
      DC.B      '********************'
      DC.B      $FF

      DC.B      '********************'
      DC.B      '*                  *'
      DC.B      '*  SPECIAL THANKS  *'
      DC.B      '*                  *'
      DC.B      '*  FOR ALL ATARI-  *'
      DC.B      '*                  *'
      DC.B      '*  LEGEND MEMBERS  *'
      DC.B      '*                  *'
      DC.B      '* TO USE OUR PRODS *'
      DC.B      '*                  *'
      DC.B      '********************'
      DC.B      $FF

      DC.B      '********************'
      DC.B      '*                  *'
      DC.B      '*  2008 IS A GOOD  *'
      DC.B      '*                  *'
      DC.B      '* YEAR FOR THE CREW*'
      DC.B      '*                  *'
      DC.B      '* WE MEET YOU SOON *'
      DC.B      '*                  *'
      DC.B      '*    TO DOWNLOAD   *'
      DC.B      '*                  *'
      DC.B      '********************'
      DC.B      $FF

      DC.B      '********************'
      DC.B      '*                  *'
      DC.B      '*  SOME ATARI ST   *'
      DC.B      '*                  *'
      DC.B      '*  STUFFS ON YOUR  *'
      DC.B      '*                  *'
      DC.B      '*     WEBSITE      *'
      DC.B      '*                  *'
      DC.B      '*    BE PATIENT!   *'
      DC.B      '*                  *'
      DC.B      '********************'
      DC.B      $FF

      DC.B      '********************'
      DC.B      '*                  *'
      DC.B      '* MAIL :           *'
      DC.B      '*                  *'
      DC.B      '*     CONTACT      *'
      DC.B      '*        AT        *'
      DC.B      '*   NOEXTRA-TEAM   *'
      DC.B      '*       DOT        *'
      DC.B      '*       COM        *'
      DC.B      '*                  *'
      DC.B      '********************'
      DC.B      $FF

      DC.B      '********************'
      DC.B      '*                  *'
      DC.B      '* WEBSITE URL :    *'
      DC.B      '*                  *'
      DC.B      '*       WWW        *'
      DC.B      '*       DOT        *'
      DC.B      '*   NOEXTRA-TEAM   *'
      DC.B      '*       DOT        *'
      DC.B      '*       COM        *'
      DC.B      '*                  *'
      DC.B      '********************'
      DC.B      $FF

      DC.B      '********************'
      DC.B      '*                  *'
      DC.B      '*   BEST WISHES    *'
      DC.B      '*                  *'
      DC.B      '*   FOR THIS NEW   *'
      DC.B      '*                  *'
      DC.B      '*     Y.E.A.R      *'
      DC.B      '*                  *'
      DC.B      '*       2008       *'
      DC.B      '*                  *'
      DC.B      '********************'
      DC.B      $FF

      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      $FF

      DC.B      '                    '
      DC.B      ' QUE LA FORCE SOIT  '
      DC.B      '     AVEC VOUS!!    '
      DC.B      '                    '
      DC.B      '--------------------'
      DC.B      ' NOEXTRA PRODUCTION '
      DC.B      '    IN 01-01-2008   '
      DC.B      '--------------------'
      DC.B      '                    '
      DC.B      ' ATOMUS AKA DAVID.  '
      DC.B      '                    '
      DC.B      $FF

      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      ' PRESS ESCAPE KEY   '
      DC.B      ' TO RETURN ON LGD.. '
      DC.B      $FF     

      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      '                    '
      DC.B      $FF

      DC.B      '********************'
      DC.B      '*                  *'
      DC.B      '*                  *'
      DC.B      '*                  *'
      DC.B      '*                  *'
      DC.B      '*  SPECIAL TRICKS  *'
      DC.B      '*                  *'
      DC.B      '*                  *'
      DC.B      '*                  *'
      DC.B      '*                  *'
      DC.B      '********************'
      DC.B      $FF

      DC.B      '********************'
      DC.B      '*                  *'
      DC.B      '* USE KEYPAD 0 TO 9*'
      DC.B      '*                  *'
      DC.B      '* FOR CHANGE CURVE *'
      DC.B      '*                  *'
      DC.B      '* RASTER AT THE    *'
      DC.B      '*                  *'
      DC.B      '* INTRO NUMBER 7.  *'
      DC.B      '*                  *'
      DC.B      '********************'
      DC.B      $FF

      DC.B      '********************'
      DC.B      '*                  *'
      DC.B      '* USE KEYPAD 0 TO 9*'
      DC.B      '*                  *'
      DC.B      '* FOR CHANGE COLOR *'
      DC.B      '*                  *'
      DC.B      '* OF THE CUBE AT   *'
      DC.B      '*                  *'
      DC.B      '* INTRO NUMBER 9.  *'
      DC.B      '*                  *'
      DC.B      '********************'
      DC.B      $FF

      DC.B      'END END END END END '
      DC.B      ' END END END END END'
      DC.B      'D END END END END EN'
      DC.B      'ND END END END END E'
      DC.B      'END END END END END '
      DC.B      ' END END END END END'
      DC.B      'D END END END END EN'
      DC.B      'ND END END END END E'
      DC.B      'END END END END END '
      DC.B      ' END END END END END'
      DC.B      'D END END END END EN'
      DC.B      $FF
                        
      EVEN
      
PTR_CAR:
	dc.l	CARAC
CARAC:
	dc.w	$00A6,$00AE,$00B6,$00BE
	dc.w	$00C6,$00CE,$00D6,$00DE
	dc.w	$00E6,$00EE,$00F6,$00FE
	dc.w	$0106,$010E,$0116,$011E
	dc.w	$0126,$012E,$0136,$013E
	dc.w	$0BE6,$0BEE,$0BF6,$0BFE
	dc.w	$0C06,$0C0E,$0C16,$0C1E
	dc.w	$0C26,$0C2E,$0C36,$0C3E
	dc.w	$0C46,$0C4E,$0C56,$0C5E
	dc.w	$0C66,$0C6E,$0C76,$0C7E
	dc.w	$1726,$172E,$1736,$173E
	dc.w	$1746,$174E,$1756,$175E
	dc.w	$1766,$176E,$1776,$177E
	dc.w	$1786,$178E,$1796,$179E
	dc.w	$17A6,$17AE,$17B6,$17BE
	dc.w	$2266,$226E,$2276,$227E
	dc.w	$2286,$228E,$2296,$229E
	dc.w	$22A6,$22AE,$22B6,$22BE
	dc.w	$22C6,$22CE,$22D6,$22DE
	dc.w	$22E6,$22EE,$22F6,$22FE
	dc.w	$2DA6,$2DAE,$2DB6,$2DBE
	dc.w	$2DC6,$2DCE,$2DD6,$2DDE
	dc.w	$2DE6,$2DEE,$2DF6,$2DFE
	dc.w	$2E06,$2E0E,$2E16,$2E1E
	dc.w	$2E26,$2E2E,$2E36,$2E3E
	dc.w	$38E6,$38EE,$38F6,$38FE
	dc.w	$3906,$390E,$3916,$391E
	dc.w	$3926,$392E,$3936,$393E
	dc.w	$3946,$394E,$3956,$395E
	dc.w	$3966,$396E,$3976,$397E
	dc.w	$4426,$442E,$4436,$443E
	dc.w	$4446,$444E,$4456,$445E
	dc.w	$4466,$446E,$4476,$447E
	dc.w	$4486,$448E,$4496,$449E
	dc.w	$44A6,$44AE,$44B6,$44BE
	dc.w	$4F66,$4F6E,$4F76,$4F7E
	dc.w	$4F86,$4F8E,$4F96,$4F9E
	dc.w	$4FA6,$4FAE,$4FB6,$4FBE
	dc.w	$4FC6,$4FCE,$4FD6,$4FDE
	dc.w	$4FE6,$4FEE,$4FF6,$4FFE
	dc.w	$5AA6,$5AAE,$5AB6,$5ABE
	dc.w	$5AC6,$5ACE,$5AD6,$5ADE
	dc.w	$5AE6,$5AEE,$5AF6,$5AFE
	dc.w	$5B06,$5B0E,$5B16,$5B1E
	dc.w	$5B26,$5B2E,$5B36,$5B3E
	dc.w	$65E6,$65EE,$65F6,$65FE
	dc.w	$6606,$660E,$6616,$661E
	dc.w	$6626,$662E,$6636,$663E
	dc.w	$6646,$664E,$6656,$665E
	dc.w	$6666,$666E,$6676,$667E
	dc.w	$7126,$712E,$7136,$713E
	dc.w	$7146,$714E,$7156,$715E
	dc.w	$7166,$716E,$7176,$717E
	dc.w	$7186,$718E,$7196,$719E
	dc.w	$71A6,$71AE,$71B6,$71BE
	EVEN

DATAS:	dc.w	$0170,$0000,$0000,$A896
	dc.w	$000F,$8000,$00E0,$0DF4
	dc.w	$0700,$0710,$0720,$0730
	dc.w	$0740,$0750,$0760,$0770
	dc.w	$0670,$0570,$0470,$0370
	dc.w	$0270,$0170,$0070,$0071
	dc.w	$0072,$0073,$0074,$0075
	dc.w	$0076,$0077,$0067,$0057
	dc.w	$0047,$0037,$0027,$0017
	dc.w	$0007,$0107,$0207,$0307
	dc.w	$0407,$0507,$0607,$0707
	dc.w	$0706,$0705,$0704,$0703
	dc.w	$0702,$0701,$0700,$0710
	dc.w	$0720,$0730,$0740,$0750
	dc.w	$0760,$0770,$0670,$0570
	dc.w	$0470,$0370,$0270,$0170
	dc.w	$0070,$0071,$0072,$0073
	dc.w	$0074,$0075,$0076,$0077
	dc.w	$0067,$0057,$0047,$0037
	dc.w	$0027,$0017,$0007,$0107
	dc.w	$0207,$0307,$0407,$0507
	dc.w	$0607,$0707,$0706,$0705
	dc.w	$0704,$0703,$0702,$0701
	dc.w	$0700,$0710,$0720,$0730
	dc.w	$0740,$0750,$0760,$0770
	dc.w	$0670,$0570,$0470,$0370
	dc.w	$0270,$0170,$0070,$0071
	dc.w	$0072,$0073,$0074,$0075
	dc.w	$0076,$0077,$0067,$0057
	dc.w	$0047,$0037,$0027,$0017
	dc.w	$0007,$0107,$0207,$0307
	dc.w	$0407,$0507,$0607,$0707
	dc.w	$0706,$0705,$0704,$0703
	dc.w	$0702,$0701,$0700,$0054
	dc.w	$0005,$0054,$0003,$0054
	dc.w	$0001,$0056,$0005,$0056
	dc.w	$0003,$0056,$0001,$0058
	dc.w	$0005,$0058,$0003,$0058
	dc.w	$0001,$005A,$0005,$005A
	dc.w	$0003,$005A,$0001,$005C
	dc.w	$0005,$005C,$0003,$005C
	dc.w	$0001,$005E,$0005,$005E
	dc.w	$0003,$005E,$0001,$0060
	dc.w	$0005,$0060,$0003,$0060
	dc.w	$0001,$0062,$0005,$0062
	dc.w	$0003,$0062,$0001,$0064
	dc.w	$0005,$0064,$0003,$0064
	dc.w	$0001,$0066,$0005,$0066
	dc.w	$0003,$0066,$0001,$0068
	dc.w	$0005,$0068,$0003,$0068
	dc.w	$0001,$006A,$0005,$006A
	dc.w	$0003,$006A,$0001,$006C
	dc.w	$0005,$006C,$0003,$006C
	dc.w	$0001,$006E,$0005,$006E
	dc.w	$0003,$006E,$0001,$0070
	dc.w	$0005,$0070,$0003,$0070
	dc.w	$0001,$0072,$0005,$0072
	dc.w	$0003,$0072,$0001,$0074
	dc.w	$0005,$0074,$0003,$0074
	dc.w	$0001,$0076,$0005,$0076
	dc.w	$0003,$0076,$0001,$0078
	dc.w	$0005,$0078,$0003,$0078
	dc.w	$0001,$007A,$0005,$007A
	dc.w	$0003,$007A,$0001,$007C
	dc.w	$0005,$007C,$0003,$007C
	dc.w	$0001,$007E,$0005,$007E
	dc.w	$0003,$007E,$0001,$0080
	dc.w	$0005,$0080,$0003,$0080
	dc.w	$0001,$0082,$0005,$0082
	dc.w	$0003,$0082,$0001,$0084
	dc.w	$0005,$0084,$0003,$0084
	dc.w	$0001,$0086,$0005,$0086
	dc.w	$0003,$0086,$0001,$0088
	dc.w	$0005,$0088,$0003,$0088
	dc.w	$0001,$008A,$0005,$008A
	dc.w	$0003,$008A,$0001,$008C
	dc.w	$0005,$008C,$0003,$008C
	dc.w	$0001,$008E,$0005,$008E
	dc.w	$0003,$008E,$0001,$0090
	dc.w	$0005,$0090,$0003,$0090
	dc.w	$0001,$0092,$0005,$0092
	dc.w	$0003,$0092,$0001,$0094
	dc.w	$0005,$0094,$0003,$0094
	dc.w	$0001,$0096,$0005,$0096
	dc.w	$0003,$0096,$0001,$0098
	dc.w	$0005,$0098,$0003,$0098
	dc.w	$0001,$009A,$0005,$009A
	dc.w	$0003,$009A,$0001,$009C
	dc.w	$0005,$009C,$0003,$009C
	dc.w	$0001,$009E,$0005,$009E
	dc.w	$0003,$009E,$0001,$00A0
	dc.w	$0005,$00A0,$0003,$00A0
	dc.w	$0001,$00A2,$0005,$00A2
	dc.w	$0003,$00A2,$0001,$00A4
	dc.w	$0005,$00A4,$0003,$00A4
	dc.w	$0001,$00A6,$0005,$00A6
	dc.w	$0003,$00A6,$0001,$0054
	dc.w	$0005,$0054,$0003,$0054
	dc.w	$0001,$0056,$0005,$0056
	dc.w	$0003,$0056,$0001,$0058
	dc.w	$0005,$0058,$0003,$0058
	dc.w	$0001,$005A,$0005,$005A
	dc.w	$0003,$005A,$0001,$005C
	dc.w	$0005,$005C,$0003,$005C
	dc.w	$0001,$005E,$0005,$005E
	dc.w	$0003,$005E,$0001,$0060
	dc.w	$0005,$0060,$0003,$0060
	dc.w	$0001,$0062,$0005,$0062
	dc.w	$0003,$0062,$0001,$0064
	dc.w	$0005,$0064,$0003,$0064
	dc.w	$0001,$0066,$0005,$0066
	dc.w	$0003,$0066,$0001,$0068
	dc.w	$0005,$0068,$0003,$0068
	dc.w	$0001,$006A,$0005,$006A
	dc.w	$0003,$006A,$0001,$006C
	dc.w	$0005,$006C,$0003,$006C
	dc.w	$0001,$006E,$0005,$006E
	dc.w	$0003,$006E,$0001,$0070
	dc.w	$0005,$0070,$0003,$0070
	dc.w	$0001,$0072,$0005,$0072
	dc.w	$0003,$0072,$0001,$0074
	dc.w	$0005,$0074,$0003,$0074
	dc.w	$0001,$0076,$0005,$0076
	dc.w	$0003,$0076,$0001,$0078
	dc.w	$0005,$0078,$0003,$0078
	dc.w	$0001,$007A,$0005,$007A
	dc.w	$0003,$007A,$0001,$007C
	dc.w	$0005,$007C,$0003,$007C
	dc.w	$0001,$007E,$0005,$007E
	dc.w	$0003,$007E,$0001,$0080
	dc.w	$0005,$0080,$0003,$0080
	dc.w	$0001,$0082,$0005,$0082
	dc.w	$0003,$0082,$0001,$0084
	dc.w	$0005,$0084,$0003,$0084
	dc.w	$0001,$0086,$0005,$0086
	dc.w	$0003,$0086,$0001,$0088
	dc.w	$0005,$0088,$0003,$0088
	dc.w	$0001,$008A,$0005,$008A
	dc.w	$0003,$008A,$0001,$008C
	dc.w	$0005,$008C,$0003,$008C
	dc.w	$0001,$008E,$0005,$008E
	dc.w	$0003,$008E,$0001,$0090
	dc.w	$0005,$0090,$0003,$0090
	dc.w	$0001,$0092,$0005,$0092
	dc.w	$0003,$0092,$0001,$0094
	dc.w	$0005,$0094,$0003,$0094
	dc.w	$0001,$0096,$0005,$0096
	dc.w	$0003,$0096,$0001,$0098
	dc.w	$0005,$0098,$0003,$0098
	dc.w	$0001,$009A,$0005,$009A
	dc.w	$0003,$009A,$0001,$009C
	dc.w	$0005,$009C,$0003,$009C
	dc.w	$0001,$009E,$0005,$009E
	dc.w	$0003,$009E,$0001,$00A0
	dc.w	$0005,$00A0,$0003,$00A0
	dc.w	$0001,$00A2,$0005,$00A2
	dc.w	$0003,$00A2,$0001,$00A4
	dc.w	$0005,$00A4,$0003,$00A4
	dc.w	$0001,$00A6,$0005,$00A6
	dc.w	$0003,$00A6,$0001,$0054
	dc.w	$0005,$0054,$0003,$0054
	dc.w	$0001,$0056,$0005,$0056
	dc.w	$0003,$0056,$0001,$0058
	dc.w	$0005,$0058,$0003,$0058
	dc.w	$0001,$005A,$0005,$005A
	dc.w	$0003,$005A,$0001,$005C
	dc.w	$0005,$005C,$0003,$005C
	dc.w	$0001,$005E,$0005,$005E
	dc.w	$0003,$005E,$0001,$0060
	dc.w	$0005,$0060,$0003,$0060
	dc.w	$0001,$0062,$0005,$0062
	dc.w	$0003,$0062,$0001,$0064
	dc.w	$0005,$0064,$0003,$0064
	dc.w	$0001,$0066,$0005,$0066
	dc.w	$0003,$0066,$0001,$0068
	dc.w	$0005,$0068,$0003,$0068
	dc.w	$0001,$006A,$0005,$006A
	dc.w	$0003,$006A,$0001,$006C
	dc.w	$0005,$006C,$0003,$006C
	dc.w	$0001,$006E,$0005,$006E
	dc.w	$0003,$006E,$0001,$0070
	dc.w	$0005,$0070,$0003,$0070
	dc.w	$0001,$0072,$0005,$0072
	dc.w	$0003,$0072,$0001,$0074
	dc.w	$0005,$0074,$0003,$0074
	dc.w	$0001,$0076,$0005,$0076
	dc.w	$0003,$0076,$0001,$0078
	dc.w	$0005,$0078,$0003,$0078
	dc.w	$0001,$007A,$0005,$007A
	dc.w	$0003,$007A,$0001,$007C
	dc.w	$0005,$007C,$0003,$007C
	dc.w	$0001,$007E,$0005,$007E
	dc.w	$0003,$007E,$0001,$0080
	dc.w	$0005,$0080,$0003,$0080
	dc.w	$0001,$0082,$0005,$0082
	dc.w	$0003,$0082,$0001,$0084
	dc.w	$0005,$0084,$0003,$0084
	dc.w	$0001,$0086,$0005,$0086
	dc.w	$0003,$0086,$0001,$0088
	dc.w	$0005,$0088,$0003,$0088
	dc.w	$0001,$008A,$0005,$008A
	dc.w	$0003,$008A,$0001,$008C
	dc.w	$0005,$008C,$0003,$008C
	dc.w	$0001,$008E,$0005,$008E
	dc.w	$0003,$008E,$0001,$0090
	dc.w	$0005,$0090,$0003,$0090
	dc.w	$0001,$0092,$0005,$0092
	dc.w	$0003,$0092,$0001,$0094
	dc.w	$0005,$0094,$0003,$0094
	dc.w	$0001,$0096,$0005,$0096
	dc.w	$0003,$0096,$0001,$0098
	dc.w	$0005,$0098,$0003,$0098
	dc.w	$0001,$009A,$0005,$009A
	dc.w	$0003,$009A,$0001,$009C
	dc.w	$0005,$009C,$0003,$009C
	dc.w	$0001,$009E,$0005,$009E
	dc.w	$0003,$009E,$0001,$00A0
	dc.w	$0005,$00A0,$0003,$00A0
	dc.w	$0001,$00A2,$0005,$00A2
	dc.w	$0003,$00A2,$0001,$00A4
	dc.w	$0005,$00A4,$0003,$00A4
	dc.w	$0001,$00A6,$0005,$00A6
	dc.w	$0003,$00A6,$0001,$0054
	dc.w	$0005,$0054,$0003,$0054
	dc.w	$0001,$0056,$0005,$0056
	dc.w	$0003,$0056,$0001,$0058
	dc.w	$0005,$0058,$0003,$0058
	dc.w	$0001,$005A,$0005,$005A
	dc.w	$0003,$005A,$0001,$005C
	dc.w	$0005,$005C,$0003,$005C
	dc.w	$0001,$005E,$0005,$005E
	dc.w	$0003,$005E,$0001,$0060
	dc.w	$0005,$0060,$0003,$0060
	dc.w	$0001,$0062,$0005,$0062
	dc.w	$0003,$0062,$0001,$0064
	dc.w	$0005,$0064,$0003,$0064
	dc.w	$0001,$0066,$0005,$0066
	dc.w	$0003,$0066,$0001,$0068
	dc.w	$0005,$0068,$0003,$0068
	dc.w	$0001,$006A,$0005,$006A
	dc.w	$0003,$006A,$0001,$006C
	dc.w	$0005,$006C,$0003,$006C
	dc.w	$0001,$006E,$0005,$006E
	dc.w	$0003,$006E,$0001,$0070
	dc.w	$0005,$0070,$0003,$0070
	dc.w	$0001,$0072,$0005,$0072
	dc.w	$0003,$0072,$0001,$0074
	dc.w	$0005,$0074,$0003,$0074
	dc.w	$0001,$0076,$0005,$0076
	dc.w	$0003,$0076,$0001,$0078
	dc.w	$0005,$0078,$0003,$0078
	dc.w	$0001,$007A,$0005,$007A
	dc.w	$0003,$007A,$0001,$007C
	dc.w	$0005,$007C,$0003,$007C
	dc.w	$0001,$007E,$0005,$007E
	dc.w	$0003,$007E,$0001,$0080
	dc.w	$0005,$0080,$0003,$0080
	dc.w	$0001,$0082,$0005,$0082
	dc.w	$0003,$0082,$0001,$0084
	dc.w	$0005,$0084,$0003,$0084
	dc.w	$0001,$0086,$0005,$0086
	dc.w	$0003,$0086,$0001,$0088
	dc.w	$0005,$0088,$0003,$0088
	dc.w	$0001,$008A,$0005,$008A
	dc.w	$0003,$008A,$0001,$008C
	dc.w	$0005,$008C,$0003,$008C
	dc.w	$0001,$008E,$0005,$008E
	dc.w	$0003,$008E,$0001,$0090
	dc.w	$0005,$0090,$0003,$0090
	dc.w	$0001,$0092,$0005,$0092
	dc.w	$0003,$0092,$0001,$0094
	dc.w	$0005,$0094,$0003,$0094
	dc.w	$0001,$0096,$0005,$0096
	dc.w	$0003,$0096,$0001,$0098
	dc.w	$0005,$0098,$0003,$0098
	dc.w	$0001,$009A,$0005,$009A
	dc.w	$0003,$009A,$0001,$009C
	dc.w	$0005,$009C,$0003,$009C
	dc.w	$0001,$009E,$0005,$009E
	dc.w	$0003,$009E,$0001,$00A0
	dc.w	$0005,$00A0,$0003,$00A0
	dc.w	$0001,$00A2,$0005,$00A2
	dc.w	$0003,$00A2,$0001,$00A4
	dc.w	$0005,$00A4,$0003,$00A4
	dc.w	$0001,$00A6,$0005,$00A6
	dc.w	$0003,$00A6,$0001,$0054
	dc.w	$0005,$0054,$0003,$0054
	dc.w	$0001,$0056,$0005,$0056
	dc.w	$0003,$0056,$0001,$0058
	dc.w	$0005,$0058,$0003,$0058
	dc.w	$0001,$005A,$0005,$005A
	dc.w	$0003,$005A,$0001,$005C
	dc.w	$0005,$005C,$0003,$005C
	dc.w	$0001,$005E,$0005,$005E
	dc.w	$0003,$005E,$0001,$0060
	dc.w	$0005,$0060,$0003,$0060
	dc.w	$0001,$0062,$0005,$0062
	dc.w	$0003,$0062,$0001,$0064
	dc.w	$0005,$0064,$0003,$0064
	dc.w	$0001,$0066,$0005,$0066
	dc.w	$0003,$0066,$0001,$0068
	dc.w	$0005,$0068,$0003,$0068
	dc.w	$0001,$006A,$0005,$006A
	dc.w	$0003,$006A,$0001,$006C
	dc.w	$0005,$006C,$0003,$006C
	dc.w	$0001,$006E,$0005,$006E
	dc.w	$0003,$006E,$0001,$0070
	dc.w	$0005,$0070,$0003,$0070
	dc.w	$0001,$0072,$0005,$0072
	dc.w	$0003,$0072,$0001,$0074
	dc.w	$0005,$0074,$0003,$0074
	dc.w	$0001,$0076,$0005,$0076
	dc.w	$0003,$0076,$0001,$0078
	dc.w	$0005,$0078,$0003,$0078
	dc.w	$0001,$007A,$0005,$007A
	dc.w	$0003,$007A,$0001,$007C
	dc.w	$0005,$007C,$0003,$007C
	dc.w	$0001,$007E,$0005,$007E
	dc.w	$0003,$007E,$0001,$0080
	dc.w	$0005,$0080,$0003,$0080
	dc.w	$0001,$0082,$0005,$0082
	dc.w	$0003,$0082,$0001,$0084
	dc.w	$0005,$0084,$0003,$0084
	dc.w	$0001,$0086,$0005,$0086
	dc.w	$0003,$0086,$0001,$0088
	dc.w	$0005,$0088,$0003,$0088
	dc.w	$0001,$008A,$0005,$008A
	dc.w	$0003,$008A,$0001,$008C
	dc.w	$0005,$008C,$0003,$008C
	dc.w	$0001,$008E,$0005,$008E
	dc.w	$0003,$008E,$0001,$0090
	dc.w	$0005,$0090,$0003,$0090
	dc.w	$0001,$0092,$0005,$0092
	dc.w	$0003,$0092,$0001,$0094
	dc.w	$0005,$0094,$0003,$0094
	dc.w	$0001,$0096,$0005,$0096
	dc.w	$0003,$0096,$0001,$0098
	dc.w	$0005,$0098,$0003,$0098
	dc.w	$0001,$009A,$0005,$009A
	dc.w	$0003,$009A,$0001,$009C
	dc.w	$0005,$009C,$0003,$009C
	dc.w	$0001,$009E,$0005,$009E
	dc.w	$0003,$009E,$0001,$00A0
	dc.w	$0005,$00A0,$0003,$00A0
	dc.w	$0001,$00A2,$0005,$00A2
	dc.w	$0003,$00A2,$0001,$00A4
	dc.w	$0005,$00A4,$0003,$00A4
	dc.w	$0001,$00A6,$0005,$00A6
	dc.w	$0003,$00A6,$0001,$0054
	dc.w	$0005,$0054,$0003,$0054
	dc.w	$0001,$0056,$0005,$0056
	dc.w	$0003,$0056,$0001,$0058
	dc.w	$0005,$0058,$0003,$0058
	dc.w	$0001,$005A,$0005,$005A
	dc.w	$0003,$005A,$0001,$005C
	dc.w	$0005,$005C,$0003,$005C
	dc.w	$0001,$005E,$0005,$005E
	dc.w	$0003,$005E,$0001,$0060
	dc.w	$0005,$0060,$0003,$0060
	dc.w	$0001,$0062,$0005,$0062
	dc.w	$0003,$0062,$0001,$0064
	dc.w	$0005,$0064,$0003,$0064
	dc.w	$0001,$0066,$0005,$0066
	dc.w	$0003,$0066,$0001,$0068
	dc.w	$0005,$0068,$0003,$0068
	dc.w	$0001,$006A,$0005,$006A
	dc.w	$0003,$006A,$0001,$006C
	dc.w	$0005,$006C,$0003,$006C
	dc.w	$0001,$006E,$0005,$006E
	dc.w	$0003,$006E,$0001,$0070
	dc.w	$0005,$0070,$0003,$0070
	dc.w	$0001,$0072,$0005,$0072
	dc.w	$0003,$0072,$0001,$0074
	dc.w	$0005,$0074,$0003,$0074
	dc.w	$0001,$0076,$0005,$0076
	dc.w	$0003,$0076,$0001,$0078
	dc.w	$0005,$0078,$0003,$0078
	dc.w	$0001,$007A,$0005,$007A
	dc.w	$0003,$007A,$0001,$007C
	dc.w	$0005,$007C,$0003,$007C
	dc.w	$0001,$007E,$0005,$007E
	dc.w	$0003,$007E,$0001,$0080
	dc.w	$0005,$0080,$0003,$0080
	dc.w	$0001,$0082,$0005,$0082
	dc.w	$0003,$0082,$0001,$0084
	dc.w	$0005,$0084,$0003,$0084
	dc.w	$0001,$0086,$0005,$0086
	dc.w	$0003,$0086,$0001,$0088
	dc.w	$0005,$0088,$0003,$0088
	dc.w	$0001,$008A,$0005,$008A
	dc.w	$0003,$008A,$0001,$008C
	dc.w	$0005,$008C,$0003,$008C
	dc.w	$0001,$008E,$0005,$008E
	dc.w	$0003,$008E,$0001,$0090
	dc.w	$0005,$0090,$0003,$0090
	dc.w	$0001,$0092,$0005,$0092
	dc.w	$0003,$0092,$0001,$0094
	dc.w	$0005,$0094,$0003,$0094
	dc.w	$0001,$0096,$0005,$0096
	dc.w	$0003,$0096,$0001,$0098
	dc.w	$0005,$0098,$0003,$0098
	dc.w	$0001,$009A,$0005,$009A
	dc.w	$0003,$009A,$0001,$009C
	dc.w	$0005,$009C,$0003,$009C
	dc.w	$0001,$009E,$0005,$009E
	dc.w	$0003,$009E,$0001,$00A0
	dc.w	$0005,$00A0,$0003,$00A0
	dc.w	$0001,$00A2,$0005,$00A2
	dc.w	$0003,$00A2,$0001,$00A4
	dc.w	$0005,$00A4,$0003,$00A4
	dc.w	$0001,$00A6,$0005,$00A6
	dc.w	$0003,$00A6,$0001,$0054
	dc.w	$0005,$0054,$0003,$0054
	dc.w	$0001,$0056,$0005,$0056
	dc.w	$0003,$0056,$0001,$0058
	dc.w	$0005,$0058,$0003,$0058
	dc.w	$0001,$005A,$0005,$005A
	dc.w	$0003,$005A,$0001,$005C
	dc.w	$0005,$005C,$0003,$005C
	dc.w	$0001,$005E,$0005,$005E
	dc.w	$0003,$005E,$0001,$0060
	dc.w	$0005,$0060,$0003,$0060
	dc.w	$0001,$0062,$0005,$0062
	dc.w	$0003,$0062,$0001,$0064
	dc.w	$0005,$0064,$0003,$0064
	dc.w	$0001,$0066,$0005,$0066
	dc.w	$0003,$0066,$0001,$0068
	dc.w	$0005,$0068,$0003,$0068
	dc.w	$0001,$006A,$0005,$006A
	dc.w	$0003,$006A,$0001,$006C
	dc.w	$0005,$006C,$0003,$006C
	dc.w	$0001,$006E,$0005,$006E
	dc.w	$0003,$006E,$0001,$0070
	dc.w	$0005,$0070,$0003,$0070
	dc.w	$0001,$0072,$0005,$0072
	dc.w	$0003,$0072,$0001,$0074
	dc.w	$0005,$0074,$0003,$0074
	dc.w	$0001,$0076,$0005,$0076
	dc.w	$0003,$0076,$0001,$0078
	dc.w	$0005,$0078,$0003,$0078
	dc.w	$0001,$007A,$0005,$007A
	dc.w	$0003,$007A,$0001,$007C
	dc.w	$0005,$007C,$0003,$007C
	dc.w	$0001,$007E,$0005,$007E
	dc.w	$0003,$007E,$0001,$0080
	dc.w	$0005,$0080,$0003,$0080
	dc.w	$0001,$0082,$0005,$0082
	dc.w	$0003,$0082,$0001,$0084
	dc.w	$0005,$0084,$0003,$0084
	dc.w	$0001,$0086,$0005,$0086
	dc.w	$0003,$0086,$0001,$0088
	dc.w	$0005,$0088,$0003,$0088
	dc.w	$0001,$008A,$0005,$008A
	dc.w	$0003,$008A,$0001,$008C
	dc.w	$0005,$008C,$0003,$008C
	dc.w	$0001,$008E,$0005,$008E
	dc.w	$0003,$008E,$0001,$0090
	dc.w	$0005,$0090,$0003,$0090
	dc.w	$0001,$0092,$0005,$0092
	dc.w	$0003,$0092,$0001,$0094
	dc.w	$0005,$0094,$0003,$0094
	dc.w	$0001,$0096,$0005,$0096
	dc.w	$0003,$0096,$0001,$0098
	dc.w	$0005,$0098,$0003,$0098
	dc.w	$0001,$009A,$0005,$009A
	dc.w	$0003,$009A,$0001,$009C
	dc.w	$0005,$009C,$0003,$009C
	dc.w	$0001,$009E,$0005,$009E
	dc.w	$0003,$009E,$0001,$00A0
	dc.w	$0005,$00A0,$0003,$00A0
	dc.w	$0001,$00A2,$0005,$00A2
	dc.w	$0003,$00A2,$0001,$00A4
	dc.w	$0005,$00A4,$0003,$00A4
	dc.w	$0001,$00A6,$0005,$00A6
	dc.w	$0003,$00A6,$0001,$0054
	dc.w	$0005,$0054,$0003,$0054
	dc.w	$0001,$0056,$0005,$0056
	dc.w	$0003,$0056,$0001,$0058
	dc.w	$0005,$0058,$0003,$0058
	dc.w	$0001,$005A,$0005,$005A
	dc.w	$0003,$005A,$0001,$005C
	dc.w	$0005,$005C,$0003,$005C
	dc.w	$0001,$005E,$0005,$005E
	dc.w	$0003,$005E,$0001,$0060
	dc.w	$0005,$0060,$0003,$0060
	dc.w	$0001,$0062,$0005,$0062
	dc.w	$0003,$0062,$0001,$0064
	dc.w	$0005,$0064,$0003,$0064
	dc.w	$0001,$0066,$0005,$0066
	dc.w	$0003,$0066,$0001,$0068
	dc.w	$0005,$0068,$0003,$0068
	dc.w	$0001,$006A,$0005,$006A
	dc.w	$0003,$006A,$0001,$006C
	dc.w	$0005,$006C,$0003,$006C
	dc.w	$0001,$006E,$0005,$006E
	dc.w	$0003,$006E,$0001,$0070
	dc.w	$0005,$0070,$0003,$0070
	dc.w	$0001,$0072,$0005,$0072
	dc.w	$0003,$0072,$0001,$0074
	dc.w	$0005,$0074,$0003,$0074
	dc.w	$0001,$0076,$0005,$0076
	dc.w	$0003,$0076,$0001,$0078
	dc.w	$0005,$0078,$0003,$0078
	dc.w	$0001,$007A,$0005,$007A
	dc.w	$0003,$007A,$0001,$007C
	dc.w	$0005,$007C,$0003,$007C
	dc.w	$0001,$007E,$0005,$007E
	dc.w	$0003,$007E,$0001,$0080
	dc.w	$0005,$0080,$0003,$0080
	dc.w	$0001,$0082,$0005,$0082
	dc.w	$0003,$0082,$0001,$0084
	dc.w	$0005,$0084,$0003,$0084
	dc.w	$0001,$0086,$0005,$0086
	dc.w	$0003,$0086,$0001,$0088
	dc.w	$0005,$0088,$0003,$0088
	dc.w	$0001,$008A,$0005,$008A
	dc.w	$0003,$008A,$0001,$008C
	dc.w	$0005,$008C,$0003,$008C
	dc.w	$0001,$008E,$0005,$008E
	dc.w	$0003,$008E,$0001,$0090
	dc.w	$0005,$0090,$0003,$0090
	dc.w	$0001,$0092,$0005,$0092
	dc.w	$0003,$0092,$0001,$0094
	dc.w	$0005,$0094,$0003,$0094
	dc.w	$0001,$0096,$0005,$0096
	dc.w	$0003,$0096,$0001,$0098
	dc.w	$0005,$0098,$0003,$0098
	dc.w	$0001,$009A,$0005,$009A
	dc.w	$0003,$009A,$0001,$009C
	dc.w	$0005,$009C,$0003,$009C
	dc.w	$0001,$009E,$0005,$009E
	dc.w	$0003,$009E,$0001,$00A0
	dc.w	$0005,$00A0,$0003,$00A0
	dc.w	$0001,$00A2,$0005,$0030
	dc.w	$0038,$0040,$0044,$0048
	dc.w	$004C,$0050,$0050,$0054
	dc.w	$0054,$0058,$0058,$0058
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$005C,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$005C
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$0058,$0058,$0058,$0054
	dc.w	$0054,$0050,$0050,$004C
	dc.w	$0048,$0044,$0040,$0038
	dc.w	$0030,$0030,$002C,$0024
	dc.w	$001C,$0018,$0014,$0014
	dc.w	$0010,$0010,$000C,$000C
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0000
	dc.w	$0000,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$000C,$000C,$0010,$0010
	dc.w	$0014,$0014,$0018,$001C
	dc.w	$0024,$002C,$0030,$0030
	dc.w	$0038,$0040,$0044,$0048
	dc.w	$004C,$0050,$0050,$0054
	dc.w	$0054,$0058,$0058,$0058
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$005C,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$005C
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$0058,$0058,$0058,$0054
	dc.w	$0054,$0050,$0050,$004C
	dc.w	$0048,$0044,$0040,$0038
	dc.w	$0030,$0030,$002C,$0024
	dc.w	$001C,$0018,$0014,$0014
	dc.w	$0010,$0010,$000C,$000C
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0000
	dc.w	$0000,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$000C,$000C,$0010,$0010
	dc.w	$0014,$0014,$0018,$001C
	dc.w	$0024,$002C,$0030,$0030
	dc.w	$0038,$0040,$0044,$0048
	dc.w	$004C,$0050,$0050,$0054
	dc.w	$0054,$0058,$0058,$0058
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$005C,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$005C
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$0058,$0058,$0058,$0054
	dc.w	$0054,$0050,$0050,$004C
	dc.w	$0048,$0044,$0040,$0038
	dc.w	$0030,$0030,$002C,$0024
	dc.w	$001C,$0018,$0014,$0014
	dc.w	$0010,$0010,$000C,$000C
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0000
	dc.w	$0000,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$000C,$000C,$0010,$0010
	dc.w	$0014,$0014,$0018,$001C
	dc.w	$0024,$002C,$0030,$0030
	dc.w	$0038,$0040,$0044,$0048
	dc.w	$004C,$0050,$0050,$0054
	dc.w	$0054,$0058,$0058,$0058
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$005C,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$005C
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$0058,$0058,$0058,$0054
	dc.w	$0054,$0050,$0050,$004C
	dc.w	$0048,$0044,$0040,$0038
	dc.w	$0030,$0030,$002C,$0024
	dc.w	$001C,$0018,$0014,$0014
	dc.w	$0010,$0010,$000C,$000C
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0000
	dc.w	$0000,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$000C,$000C,$0010,$0010
	dc.w	$0014,$0014,$0018,$001C
	dc.w	$0024,$002C,$0030,$0030
	dc.w	$0038,$0040,$0044,$0048
	dc.w	$004C,$0050,$0050,$0054
	dc.w	$0054,$0058,$0058,$0058
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$005C,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$005C
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$0058,$0058,$0058,$0054
	dc.w	$0054,$0050,$0050,$004C
	dc.w	$0048,$0044,$0040,$0038
	dc.w	$0030,$0030,$002C,$0024
	dc.w	$001C,$0018,$0014,$0014
	dc.w	$0010,$0010,$000C,$000C
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0000
	dc.w	$0000,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$000C,$000C,$0010,$0010
	dc.w	$0014,$0014,$0018,$001C
	dc.w	$0024,$002C,$0030,$0030
	dc.w	$0038,$0040,$0044,$0048
	dc.w	$004C,$0050,$0050,$0054
	dc.w	$0054,$0058,$0058,$0058
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$005C,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$005C
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$0058,$0058,$0058,$0054
	dc.w	$0054,$0050,$0050,$004C
	dc.w	$0048,$0044,$0040,$0038
	dc.w	$0030,$0030,$002C,$0024
	dc.w	$001C,$0018,$0014,$0014
	dc.w	$0010,$0010,$000C,$000C
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0000
	dc.w	$0000,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$000C,$000C,$0010,$0010
	dc.w	$0014,$0014,$0018,$001C
	dc.w	$0024,$002C,$0030,$0030
	dc.w	$0038,$0040,$0044,$0048
	dc.w	$004C,$0050,$0050,$0054
	dc.w	$0054,$0058,$0058,$0058
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$005C,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$005C
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$0058,$0058,$0058,$0054
	dc.w	$0054,$0050,$0050,$004C
	dc.w	$0048,$0044,$0040,$0038
	dc.w	$0030,$0030,$002C,$0024
	dc.w	$001C,$0018,$0014,$0014
	dc.w	$0010,$0010,$000C,$000C
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0000
	dc.w	$0000,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$000C,$000C,$0010,$0010
	dc.w	$0014,$0014,$0018,$001C
	dc.w	$0024,$002C,$0030,$0030
	dc.w	$0038,$0040,$0044,$0048
	dc.w	$004C,$0050,$0050,$0054
	dc.w	$0054,$0058,$0058,$0058
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$005C,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$005C
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$0058,$0058,$0058,$0054
	dc.w	$0054,$0050,$0050,$004C
	dc.w	$0048,$0044,$0040,$0038
	dc.w	$0030,$0030,$002C,$0024
	dc.w	$001C,$0018,$0014,$0014
	dc.w	$0010,$0010,$000C,$000C
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0000
	dc.w	$0000,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$000C,$000C,$0010,$0010
	dc.w	$0014,$0014,$0018,$001C
	dc.w	$0024,$002C,$0030,$0030
	dc.w	$0038,$0040,$0044,$0048
	dc.w	$004C,$0050,$0050,$0054
	dc.w	$0054,$0058,$0058,$0058
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$005C,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$005C
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$0058,$0058,$0058,$0054
	dc.w	$0054,$0050,$0050,$004C
	dc.w	$0048,$0044,$0040,$0038
	dc.w	$0030,$0030,$002C,$0024
	dc.w	$001C,$0018,$0014,$0014
	dc.w	$0010,$0010,$000C,$000C
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0000
	dc.w	$0000,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$000C,$000C,$0010,$0010
	dc.w	$0014,$0014,$0018,$001C
	dc.w	$0024,$002C,$0030,$0030
	dc.w	$0038,$0040,$0044,$0048
	dc.w	$004C,$0050,$0050,$0054
	dc.w	$0054,$0058,$0058,$0058
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$005C,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$005C
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$0058,$0058,$0058,$0054
	dc.w	$0054,$0050,$0050,$004C
	dc.w	$0048,$0044,$0040,$0038
	dc.w	$0030,$0030,$002C,$0024
	dc.w	$001C,$0018,$0014,$0014
	dc.w	$0010,$0010,$000C,$000C
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0000
	dc.w	$0000,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$000C,$000C,$0010,$0010
	dc.w	$0014,$0014,$0018,$001C
	dc.w	$0024,$002C,$0030,$0030
	dc.w	$0038,$0040,$0044,$0048
	dc.w	$004C,$0050,$0050,$0054
	dc.w	$0054,$0058,$0058,$0058
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$005C,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$005C
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$0058,$0058,$0058,$0054
	dc.w	$0054,$0050,$0050,$004C
	dc.w	$0048,$0044,$0040,$0038
	dc.w	$0030,$0030,$002C,$0024
	dc.w	$001C,$0018,$0014,$0014
	dc.w	$0010,$0010,$000C,$000C
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0000
	dc.w	$0000,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$000C,$000C,$0010,$0010
	dc.w	$0014,$0014,$0018,$001C
	dc.w	$0024,$002C,$0030,$0030
	dc.w	$0038,$0040,$0044,$0048
	dc.w	$004C,$0050,$0050,$0054
	dc.w	$0054,$0058,$0058,$0058
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$005C,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$0060
	dc.w	$0060,$0060,$0060,$005C
	dc.w	$005C,$005C,$005C,$005C
	dc.w	$0058,$0058,$0058,$0054
	dc.w	$0054,$0050,$0050,$004C
	dc.w	$0048,$0044,$0040,$0038
	dc.w	$0030,$0030,$002C,$0024
	dc.w	$001C,$0018,$0014,$0014
	dc.w	$0010,$0010,$000C,$000C
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0000
	dc.w	$0000,$0004,$0004,$0004
	dc.w	$0004,$0004,$0004,$0004
	dc.w	$0008,$0008,$0008,$0008
	dc.w	$000C,$000C,$0010,$0010
	dc.w	$0014,$0014,$0018,$001C
	dc.w	$0024,$002C,$0030,$0003
	dc.w	$FFFF,$FFFF
	EVEN	
	
Pal_Al:
	dc.w      $0001,$0009,$00F0,$0DEE,$0566,$0ABB,$0899,$0CDD
	dc.w      $0455,$0BCC,$0344,$0233,$09AA,$0122,$0011,$0777

Logo_Al:
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00C0,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3F80,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0340,$0080,$0080,$0080,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$C060,$3F80,$3F80,$2080,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0D40,$0200,$0380,$0380,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$1F10,$D160,$EEE0,$B1A0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3540,$0900,$0E80,$0F80,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0001,$0001,$0000
		dc.w	$5BC8,$1A50,$E6B0,$8160,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$D6C0,$2680,$3900,$3F80,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0004,$0002,$0003,$0001
		dc.w	$FEE4,$7EA8,$B2D8,$3130,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0003,$0000,$0000,$0000
		dc.w	$5CC0,$9C80,$E300,$FF80,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0009,$0004,$0007,$0006
		dc.w	$7F52,$7F14,$FBEC,$783C,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$000D,$0002,$0003,$0003
		dc.w	$7EC0,$0A80,$F500,$8B80,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$000B,$0004,$0006,$0001
		dc.w	$7EEA,$7E8C,$FA74,$7938,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0035,$0008,$000F,$000E
		dc.w	$DFC0,$2780,$D800,$2780,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$000E,$0000,$0006,$0005
		dc.w	$79FE,$79C8,$B534,$327C,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00D4,$0023,$003C,$003B
		dc.w	$8EC0,$7280,$8D00,$7380,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0013,$0008,$000E,$000D
		dc.w	$36D9,$36AA,$0FF6,$C09E,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$015C,$0083,$00F0,$00EF
		dc.w	$5FC0,$A780,$5800,$A780,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0017,$000E,$0009,$000E
		dc.w	$AFCD,$0FFE,$8EB2,$704E,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0166,$0021,$00E0,$009F
		dc.w	$BEC0,$4280,$BD00,$4380,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0016,$000E,$0009,$000F
		dc.w	$714D,$01B6,$C77A,$B9C6,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$000F,$0000,$0000,$0000
		dc.w	$FFF0,$0000,$0000,$0000,$0192,$0091,$00FC,$0013
		dc.w	$5FC0,$A780,$5800,$A780,$001F,$0000,$0000,$0000
		dc.w	$FFE0,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0FFF,$0000,$0000,$0000,$F012,$000A,$000D,$000F
		dc.w	$6AD9,$82AA,$FC76,$11DE,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0034,$0009,$000E,$000F
		dc.w	$9F6C,$1ED0,$7E30,$9DE0,$01B9,$00B8,$00FC,$003B
		dc.w	$2EFF,$D280,$2D00,$D380,$0069,$0012,$001C,$001F
		dc.w	$3ED8,$3DA0,$FC60,$3BC0,$0000,$0000,$0000,$0000
		dc.w	$301F,$0D1F,$0E1F,$0BE0,$8F16,$300B,$F00C,$500F
		dc.w	$819D,$536A,$B8F6,$6F9E,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00C5,$0029,$0032,$003C
		dc.w	$96E3,$82D4,$43CC,$3C38,$01B8,$00B8,$00FC,$003B
		dc.w	$96FF,$686A,$1794,$E96A,$018B,$0053,$0064,$0078
		dc.w	$2DC6,$05A8,$8798,$7870,$0000,$0000,$0000,$0000
		dc.w	$C37F,$2B0B,$330B,$1CF4,$F8EB,$F306,$FF05,$0502
		dc.w	$6D72,$8494,$FBEC,$1778,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0154,$00A4,$00CA,$00F1
		dc.w	$EB58,$0355,$03F3,$FC0E,$8110,$0010,$00FF,$0010
		dc.w	$CE1D,$3004,$0FFA,$F1FE,$02A9,$0148,$0194,$01E3
		dc.w	$D6B1,$06AA,$07E6,$F81C,$0001,$0000,$0000,$0000
		dc.w	$0C7F,$AC05,$CC05,$F3FA,$FF98,$5F25,$5FE6,$A047
		dc.w	$964A,$6184,$9FFC,$6E7C,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$01D0,$0010,$00B8,$00D7
		dc.w	$BEAC,$46AA,$3FF9,$C007,$4102,$8002,$80FF,$0002
		dc.w	$6753,$1952,$06AC,$F9FE,$03A1,$0020,$0170,$01AF
		dc.w	$7D58,$8D55,$7FF3,$800E,$8002,$0001,$0001,$0000
		dc.w	$38F7,$7804,$B87A,$C78D,$FFEC,$2B92,$2BB3,$D451
		dc.w	$D5B6,$4A28,$BFD8,$75F8,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0181,$0083,$0070,$008F
		dc.w	$4C86,$3085,$FF7C,$F803,$2138,$4038,$C0FF,$8000
		dc.w	$4B7F,$3500,$0A80,$F580,$0302,$0106,$00E1,$011F
		dc.w	$990C,$610A,$FEF9,$F007,$4004,$8002,$8003,$0001
		dc.w	$69C0,$E81F,$78FF,$872E,$7FCC,$0513,$C533,$BAF2
		dc.w	$2AAA,$1494,$FF74,$EBF4,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$01C5,$004C,$00A3,$001F
		dc.w	$754B,$894A,$8EBE,$8C01,$110F,$A00F,$60FF,$C000
		dc.w	$27C0,$1800,$0780,$F800,$038A,$0099,$0147,$003F
		dc.w	$EA96,$1295,$1D7C,$1803,$2008,$4005,$C006,$8003
		dc.w	$92FF,$9000,$F0E0,$0F00,$8FD2,$6021,$7861,$5781
		dc.w	$035E,$8320,$FCEC,$7FE8,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$01C5,$00D2,$000E,$00BE
		dc.w	$8997,$0596,$077E,$0411,$8931,$5031,$30FF,$E030
		dc.w	$63C0,$1D00,$0280,$FD00,$038B,$01A4,$001C,$017C
		dc.w	$132F,$0B2C,$0EFC,$0823,$1011,$A00B,$600D,$C006
		dc.w	$C970,$C880,$F800,$C7E0,$6391,$1820,$1EE0,$1560
		dc.w	$8D3E,$6CC0,$73F0,$5F6C,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$01B6,$0028,$00D8,$0038
		dc.w	$062B,$022B,$03DF,$0008,$C579,$2879,$18FF,$F078
		dc.w	$A540,$9A80,$8500,$7A80,$036C,$0050,$01B0,$0070
		dc.w	$0C57,$0456,$07BE,$0011,$8823,$5017,$301B,$E01D
		dc.w	$7370,$7080,$F240,$4DA0,$18A0,$0640,$07C0,$0500
		dc.w	$60EE,$1F10,$1FC8,$1FB4,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$01F8,$0040,$00A0,$0060
		dc.w	$0AD3,$06D3,$07EF,$00C0,$FDF9,$80F9,$98FF,$6878
		dc.w	$93C0,$8C00,$8380,$7C00,$03F0,$0080,$0140,$00C0
		dc.w	$15A7,$0DA7,$0FDF,$0180,$F837,$000F,$3017,$D01B
		dc.w	$95F0,$9200,$F1C0,$8E20,$0620,$0140,$01C0,$01C0
		dc.w	$1BBE,$0440,$0738,$06C4,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$01E0,$0080,$0040,$00C0
		dc.w	$34D9,$08D9,$0DFF,$06D8,$EBB3,$5CB3,$44FF,$B830
		dc.w	$B140,$8E80,$8100,$7E80,$03C0,$0100,$0080,$0180
		dc.w	$69B3,$11B2,$1BFE,$0DB1,$D449,$B829,$883F,$7011
		dc.w	$34F0,$3300,$F0C0,$2F20,$0140,$0080,$0080,$0080
		dc.w	$6D9E,$1060,$1C18,$1BE4,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$01C3,$0000,$0080,$0080
		dc.w	$CE13,$3613,$3BEF,$2C00,$FFDF,$80DF,$8CFF,$7400
		dc.w	$98C0,$8700,$8000,$7F80,$0387,$0000,$0100,$0100
		dc.w	$9C27,$6C27,$77DF,$5800,$FC6C,$001C,$182F,$E83C
		dc.w	$D670,$D180,$7040,$4FA0,$0081,$0000,$0000,$0000
		dc.w	$B4CE,$4430,$7408,$6BF4,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$018C,$0003,$0003,$0003
		dc.w	$61B1,$B1B1,$C1FF,$7E80,$FDFD,$C6FD,$C2FF,$3C01
		dc.w	$8FC0,$8000,$8300,$7C80,$0318,$0007,$0007,$0006
		dc.w	$C363,$6363,$83FF,$FD00,$FA5D,$8C1D,$843F,$782D
		dc.w	$93F0,$9000,$70C0,$0F20,$0006,$0001,$0001,$0001
		dc.w	$CC7E,$0C00,$DC18,$ABE4,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0133,$000D,$000E,$000B
		dc.w	$02BA,$82BA,$02F7,$FD80,$FF73,$A073,$A67F,$5A83
		dc.w	$D5C0,$C200,$C100,$BE80,$0266,$001B,$001C,$0017
		dc.w	$0575,$0575,$05EF,$FB00,$FE50,$4030,$4C1F,$B430
		dc.w	$F570,$F080,$F040,$EFA0,$000B,$0004,$0007,$0006
		dc.w	$1EAE,$1E10,$7E08,$9DF4,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00D8,$002C,$0030,$003F
		dc.w	$0131,$0D31,$01CF,$FE00,$F959,$C459,$C277,$3E91
		dc.w	$2EC0,$2100,$E200,$1D80,$01B0,$0058,$0060,$007F
		dc.w	$0263,$1A63,$039F,$FC00,$F27E,$883E,$8431,$7C10
		dc.w	$4BB0,$4840,$F880,$4760,$000C,$0000,$0005,$0002
		dc.w	$C976,$C908,$BF10,$88EC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0161,$00B1,$00C9,$00F7
		dc.w	$077A,$137A,$0FA7,$FC20,$FB3C,$E63C,$E073,$1EB0
		dc.w	$A5C0,$A200,$6100,$1E80,$02C2,$0162,$0192,$01EF
		dc.w	$0EF5,$26F5,$1F4F,$F840,$F64F,$CC0F,$C01C,$3C2C
		dc.w	$2970,$2880,$D840,$07A0,$0009,$0001,$0003,$0005
		dc.w	$E52E,$E510,$9B08,$80F4,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0293,$0153,$019F,$01F3
		dc.w	$85F1,$A9F1,$990F,$F200,$F33D,$EC3D,$E242,$1C80
		dc.w	$1240,$1180,$F000,$0F80,$0527,$02A7,$033F,$03E7
		dc.w	$0BE3,$53E3,$321F,$E400,$E64F,$D80F,$C410,$3820
		dc.w	$4490,$4460,$BC00,$03E0,$0009,$0001,$0002,$0004
		dc.w	$E892,$E88C,$1780,$007C,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$053F,$02BB,$033B,$03FD
		dc.w	$CEEA,$B2EA,$93D7,$60C0,$F118,$CE18,$C067,$3E80
		dc.w	$B240,$B180,$5000,$0F80,$0A7F,$0577,$0677,$07FA
		dc.w	$9DD5,$65D5,$27AF,$C180,$E246,$9C06,$8019,$7C20
		dc.w	$2C90,$2C60,$D400,$03E0,$0008,$0000,$0003,$0004
		dc.w	$C592,$C58C,$3A80,$007C,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0A5F,$055F,$067F,$07D0
		dc.w	$D7E1,$23E1,$02DF,$E0C0,$E905,$D605,$C07E,$3E84
		dc.w	$7440,$7380,$B000,$0F80,$14BF,$0ABE,$0CFE,$0FA1
		dc.w	$AFC3,$47C3,$05BF,$C180,$D242,$AC02,$801D,$7C20
		dc.w	$2C90,$2C60,$D400,$03E0,$0008,$0000,$0003,$0004
		dc.w	$2BA2,$2B9C,$F580,$207C,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1437,$0A37,$0CFF,$0F33
		dc.w	$94C3,$E0C3,$81FF,$62C0,$A130,$9E30,$806F,$7EA0
		dc.w	$E640,$E180,$6200,$1D80,$286F,$146F,$19FF,$1E66
		dc.w	$2987,$C187,$03FF,$C580,$424D,$3C0D,$001B,$FC29
		dc.w	$5D10,$5CE0,$AC00,$03E0,$0009,$0001,$0003,$0005
		dc.w	$8732,$870C,$7B10,$00EC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$2877,$1477,$19FF,$1E73
		dc.w	$B4CB,$E0CB,$813F,$6200,$2332,$1E32,$004F,$FE80
		dc.w	$CAC0,$C580,$C200,$3D80,$50EF,$28EF,$33FF,$3CE6
		dc.w	$6996,$C196,$027E,$C401,$464C,$3C0C,$0013,$FC20
		dc.w	$3990,$3860,$D880,$0760,$0009,$0001,$0002,$0004
		dc.w	$9656,$962C,$7E10,$01EC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$5087,$2887,$33FF,$3C80
		dc.w	$D5D4,$41D4,$21FC,$E203,$5F75,$2675,$087F,$F680
		dc.w	$15C0,$0980,$0200,$FF80,$A10F,$510E,$67FE,$7901
		dc.w	$ABA8,$83A8,$43F8,$C407,$BE5C,$4C1C,$101F,$EC20
		dc.w	$B2B0,$B160,$F080,$0F60,$000B,$0003,$0003,$0004
		dc.w	$A8AE,$A84C,$F810,$07FC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$53EF,$23E4,$37E4,$181B
		dc.w	$B6FE,$00FE,$E0FE,$E301,$FBBF,$063F,$0C3F,$F2C0
		dc.w	$BEC0,$8180,$8300,$7E80,$A7DF,$47C8,$6FC9,$3037
		dc.w	$6DFD,$01FC,$C1FC,$C603,$F66D,$0C0D,$180F,$E430
		dc.w	$4570,$4260,$C080,$3FE0,$000D,$0001,$0001,$0006
		dc.w	$FDF6,$FC0C,$FC18,$03F4,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$402F,$3218,$2409,$3BF6
		dc.w	$7502,$0001,$E000,$E3FF,$F940,$0600,$1E00,$E0FF
		dc.w	$BC40,$4180,$0780,$FA00,$805E,$6430,$4813,$77ED
		dc.w	$EA05,$0002,$C000,$C7FF,$F253,$0C03,$3C03,$C03C
		dc.w	$EFB0,$E060,$E0C0,$1FA0,$000A,$0000,$0000,$0007
		dc.w	$05E2,$020C,$003C,$FFD0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$40CE,$3234,$2005,$1FFB
		dc.w	$D6AC,$2003,$E000,$C3FF,$FDAB,$0200,$1E00,$E4FF
		dc.w	$3B40,$C080,$0780,$FF00,$819D,$6468,$400B,$3FF7
		dc.w	$AD59,$4006,$C000,$87FF,$FA68,$0400,$3C00,$C83F
		dc.w	$2F10,$1060,$01E0,$FE80,$000D,$0000,$0000,$0007
		dc.w	$59DA,$0604,$003C,$FFF8,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$61BE,$0400,$22F3,$3F4D
		dc.w	$D55B,$2000,$E0EF,$C3F4,$F56E,$0212,$3601,$CCFF
		dc.w	$FB40,$8080,$4F80,$B700,$C37D,$0800,$45E7,$7E9B
		dc.w	$AAB7,$4000,$C1DE,$87E9,$EA5A,$0404,$6C00,$983F
		dc.w	$CED0,$3020,$01E0,$FFC0,$000B,$0000,$0000,$0007
		dc.w	$77DA,$9404,$0A7C,$FDB8,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$533D,$3C40,$13EB,$3EB7
		dc.w	$B733,$00C4,$E0FE,$E32B,$F380,$007D,$B603,$4EFE
		dc.w	$76C0,$0000,$AF80,$DF80,$A67B,$7880,$27D7,$7D6F
		dc.w	$6E67,$0188,$C1FD,$C656,$E673,$000C,$6C00,$9C3F
		dc.w	$BED0,$A020,$53E0,$EDC0,$000E,$0001,$0000,$0007
		dc.w	$03B6,$E800,$1D7C,$F6FC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$55DE,$1001,$1FF7,$3E6A
		dc.w	$D65D,$4100,$A0FF,$E3E6,$FD42,$04A6,$7A19,$86FF
		dc.w	$FB40,$0500,$DE80,$2B80,$ABBD,$2002,$3FEF,$7CD5
		dc.w	$ACBB,$8200,$41FE,$C7CD,$FA60,$081B,$F404,$0C3F
		dc.w	$1DB0,$4000,$EBE0,$B7E0,$000C,$0003,$0000,$0007
		dc.w	$17DA,$3028,$CEF4,$F95C,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$5FB8,$1783,$287F,$0FC4
		dc.w	$F6FB,$21F8,$C007,$A3FC,$8F05,$225D,$FC3A,$52E7
		dc.w	$E3C0,$0C80,$FF00,$1280,$BF71,$2F06,$50FF,$1F89
		dc.w	$EDF7,$43F0,$800F,$47F8,$1E60,$4415,$F80E,$A43B
		dc.w	$BED0,$8140,$77A0,$CAE0,$000C,$0002,$0001,$0007
		dc.w	$2F1E,$E864,$D7F8,$3894,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$5554,$1103,$2EFF,$0FEC
		dc.w	$F655,$0110,$E0EF,$83FE,$4740,$301A,$FE3F,$C8E5
		dc.w	$D3C0,$0C00,$FF80,$3200,$AAA9,$2206,$5DFF,$1FD9
		dc.w	$ECAA,$0220,$C1DF,$07FD,$8E61,$6017,$FC0E,$9039
		dc.w	$78F0,$4320,$BFC0,$C4A0,$000C,$0002,$0001,$0007
		dc.w	$069E,$D060,$FFFC,$2990,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$6A89,$2486,$1F7F,$0BF9
		dc.w	$B428,$43C8,$A0F7,$C33F,$9B20,$6427,$FA9F,$9C78
		dc.w	$26C0,$1900,$FE80,$E700,$D513,$490C,$3EFF,$17F3
		dc.w	$6851,$8790,$41EF,$867F,$3648,$C83A,$F407,$383D
		dc.w	$34F0,$8300,$FFE0,$4C80,$0009,$0007,$0000,$0007
		dc.w	$0136,$38C8,$FFF4,$C738,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$57A2,$119D,$2E7F,$0FE2
		dc.w	$D67A,$2199,$C0E7,$A37E,$2DA0,$D29A,$FCFF,$2A05
		dc.w	$01C0,$FE00,$FF80,$0000,$AF45,$233A,$5CFF,$1FC5
		dc.w	$ACF4,$4333,$81CF,$46FC,$5A6C,$A41D,$F803,$543E
		dc.w	$09B0,$C640,$FFA0,$39C0,$000D,$0003,$0000,$0007
		dc.w	$C45A,$D3A4,$3FF8,$EC54,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$5100,$10FF,$1FFF,$2FD0
		dc.w	$7448,$8307,$E0FF,$03F9,$1B00,$E43F,$FA5F,$1CA3
		dc.w	$01C0,$FE00,$FF80,$4000,$A200,$21FF,$3FFF,$5FA0
		dc.w	$E890,$060F,$C1FF,$07F2,$364E,$C83E,$F401,$383F
		dc.w	$22D0,$9D20,$FFC0,$62A0,$0009,$0007,$0000,$0007
		dc.w	$D036,$CFC8,$3FF4,$F238,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$5A00,$31FF,$1FFF,$26C0
		dc.w	$F4A0,$439F,$A07F,$C3ED,$3560,$C2DF,$FC5F,$BAE3
		dc.w	$03C0,$FD00,$FE80,$0300,$B401,$63FE,$3FFF,$4D81
		dc.w	$E940,$873F,$40FF,$87DB,$6A4A,$843A,$F805,$743F
		dc.w	$81B0,$7E40,$FFA0,$91C0,$0009,$0007,$0000,$0007
		dc.w	$406A,$3F84,$FFF8,$DB74,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$7C01,$03FE,$2FFF,$3401
		dc.w	$7780,$A07F,$C3FF,$209E,$5FB0,$A03F,$FEEF,$5890
		dc.w	$05C0,$FA80,$FF00,$0480,$F802,$07FD,$5FFF,$6802
		dc.w	$EF00,$40FF,$87FF,$413C,$BE7A,$4005,$FC3F,$B00A
		dc.w	$0350,$FC20,$FFC0,$DBA0,$000F,$0000,$0007,$0001
		dc.w	$00BE,$FF40,$FFFC,$3CB0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$4C0A,$37F5,$23FF,$3C8A
		dc.w	$F500,$60FF,$83FF,$E31E,$3730,$C4EF,$FABF,$3CE2
		dc.w	$2BC0,$D580,$FE00,$2B80,$9815,$6FEA,$47FF,$7915
		dc.w	$EA00,$C1FF,$07FF,$C63C,$6E50,$880F,$F43F,$7831
		dc.w	$05F0,$FA00,$FFE0,$E580,$000A,$0001,$0007,$0006
		dc.w	$006E,$FF88,$FFF4,$3C78,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$5E15,$31EA,$27FF,$3BD5
		dc.w	$9600,$00FF,$E3FF,$E32C,$5F50,$A6CF,$F8AF,$5ED7
		dc.w	$5640,$A800,$FF80,$5780,$BC2B,$63D4,$4FFF,$77AB
		dc.w	$2C00,$01FF,$C7FF,$C658,$BE60,$4C0F,$F03F,$BC32
		dc.w	$05F0,$FA60,$FF80,$C5E0,$000C,$0001,$0007,$0006
		dc.w	$00BE,$FF4C,$FFF0,$58BC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$362F,$0BD0,$11FF,$1EAF
		dc.w	$5480,$417F,$A2FF,$E382,$B7D8,$4437,$FA5F,$BC62
		dc.w	$BD40,$4100,$FE80,$BF80,$6C5E,$17A0,$23FF,$3D5F
		dc.w	$A901,$82FE,$45FF,$C705,$6E48,$8817,$F42F,$7838
		dc.w	$0B70,$F440,$FFA0,$2BC0,$0009,$0002,$0005,$0007
		dc.w	$016E,$FE88,$FFF4,$0578,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$231A,$14E0,$1BFF,$1D1F
		dc.w	$9440,$02BF,$E0FF,$E347,$7F8C,$8653,$F86F,$7E74
		dc.w	$6A40,$8000,$FF80,$7F80,$4635,$29C0,$37FF,$3A3F
		dc.w	$2880,$057F,$C1FF,$C68E,$FE44,$0C2B,$F00F,$FC34
		dc.w	$07F0,$F860,$FF80,$77E0,$0008,$0005,$0001,$0006
		dc.w	$80FE,$7F0C,$FFF0,$8EFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1FBC,$0540,$0AFF,$0DBF
		dc.w	$2C80,$327F,$D1FF,$F282,$F77E,$0615,$F82B,$FE36
		dc.w	$F0C0,$0080,$FF00,$FF80,$7F78,$0A80,$15FF,$1B7F
		dc.w	$5901,$64FE,$A3FF,$E505,$EE48,$0C27,$F01F,$FC28
		dc.w	$0F70,$F060,$FF80,$2FE0,$0009,$0004,$0003,$0005
		dc.w	$01EE,$FE0C,$FFF0,$05FC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$17DA,$0AA0,$0D7F,$06DF
		dc.w	$CCD5,$502A,$B1FF,$F2D5,$6D5F,$842A,$FA35,$7E1B
		dc.w	$6B20,$8140,$FEC0,$7FC0,$AFB5,$5540,$5AFF,$0DBF
		dc.w	$99AA,$A055,$63FF,$E5AA,$DA4D,$0802,$F41F,$FC2D
		dc.w	$56D0,$A840,$FFA0,$57E0,$0009,$0000,$0003,$0005
		dc.w	$AADA,$5508,$FFF4,$AAFC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0AD4,$0440,$07BF,$037F
		dc.w	$2C6B,$3014,$D1FF,$E2EB,$F32B,$0211,$FC1E,$FE0D
		dc.w	$50A3,$00C0,$FF40,$FF80,$55A8,$A880,$EF7F,$46FF
		dc.w	$58D7,$6028,$A3FF,$C5D7,$E646,$0401,$F83F,$FC0E
		dc.w	$BF30,$4020,$FFC0,$BFE0,$0008,$0000,$0007,$0001
		dc.w	$D7E6,$2804,$FFF8,$D7FC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0579,$0221,$03DE,$01BF
		dc.w	$74DF,$6AA0,$987F,$F3DF,$A115,$4008,$FE0F,$BE06
		dc.w	$E5DD,$85A2,$7A63,$FFC1,$6AF2,$5442,$B7BD,$E37F
		dc.w	$E9BF,$D540,$30FF,$E7BF,$426D,$802A,$FC17,$7C0D
		dc.w	$FA10,$0400,$FFE0,$FBE0,$000D,$0005,$0002,$0001
		dc.w	$BF42,$4080,$FFFC,$BF7C,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$02BA,$011A,$01E5,$00DF
		dc.w	$B6BD,$B302,$4CFF,$FF7D,$530A,$8004,$FE07,$7E03
		dc.w	$EADD,$6AC1,$953E,$7FFF,$F575,$AA35,$5BCA,$B1BF
		dc.w	$6D7A,$6605,$99FF,$FEFA,$A67B,$0030,$FC0F,$FC07
		dc.w	$D270,$2C00,$FFE0,$D3E0,$000F,$0006,$0001,$0000
		dc.w	$7A4E,$0580,$FFFC,$FA7C,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$015F,$009F,$00E0,$007F
		dc.w	$FBDA,$FB45,$04BF,$FF7A,$A505,$0002,$FE03,$FE01
		dc.w	$7FE8,$7FE8,$8017,$FFFF,$BEBF,$D13F,$29C0,$D8FF
		dc.w	$F7B5,$F68A,$097F,$FEF5,$4A7D,$003C,$FC1B,$FC17
		dc.w	$8470,$7800,$FFE0,$87E0,$000F,$0007,$0003,$0002
		dc.w	$B08E,$8F00,$7FFC,$F0FC,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0097,$0066,$0079,$005E
		dc.w	$F6EF,$3520,$CADF,$3D3F,$52E2,$0101,$FF01,$FE01
		dc.w	$5FD7,$98D6,$E729,$78FE,$152F,$A8CC,$18F3,$E0BC
		dc.w	$EDDE,$6A40,$95BF,$7A7F,$A5FE,$023A,$FE3D,$FC33
		dc.w	$7230,$0200,$FDE0,$FFE0,$000F,$0007,$0007,$0006
		dc.w	$CE46,$4040,$BFBC,$7FFC,$8A77,$0000,$0000,$0000
		dc.w	$7381,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0065,$0018,$001F,$0016
		dc.w	$980D,$6042,$8000,$7FFF,$73A1,$F040,$0FC0,$FF80
		dc.w	$9668,$6180,$7E00,$59FF,$34CB,$4830,$383F,$D82C
		dc.w	$301A,$C085,$0000,$FFFF,$E77F,$E0B3,$1FBC,$FF23
		dc.w	$D550,$D500,$2AE0,$FFE0,$000F,$0006,$0007,$0004
		dc.w	$FAAA,$7AA0,$855C,$7FFC,$D8E2,$0000,$0000,$0000
		dc.w	$6242,$0000,$0000,$0000,$8000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$001C,$0003,$0003,$0002
		dc.w	$C406,$7121,$80C0,$FFFF,$3960,$F800,$07C0,$FFC0
		dc.w	$7311,$0DC6,$0E01,$0BFE,$9839,$6006,$E007,$A005
		dc.w	$880C,$E243,$0180,$FFFF,$72FF,$F035,$0FAA,$FF95
		dc.w	$E830,$6800,$97E0,$7FE0,$000F,$0006,$0005,$0002
		dc.w	$FD06,$AD00,$52FC,$AFFC,$AA12,$0000,$0000,$0000
		dc.w	$4387,$0000,$0000,$0000,$C000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0003,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFE0,$0000,$0000,$0000
		dc.w	$0FFF,$0000,$0000,$0000,$E007,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFF0,$0000,$0000,$0000,$000F,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$8AE2,$0000,$0000,$0000
		dc.w	$7A54,$0000,$0000,$0000,$4000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0600,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1800,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1A00,$0400,$0400,$0400
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$6800,$1000,$1000,$1000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$6A00,$1000,$1C00,$1C00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0001,$0000,$0000,$0000,$A800,$4000,$7000,$7000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0001,$0000,$0000,$0000,$AA00,$4800,$7400,$7C00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0006,$0001,$0001,$0001,$A800,$2000,$D000,$F000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0006,$0001,$0001,$0001,$B600,$3400,$C800,$FC00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$001A,$0004,$0007,$0007,$D800,$D000,$2000,$F000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$001A,$0004,$0007,$0007,$E600,$E400,$1800,$FC00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$006B,$0013,$001C,$001F,$9800,$9000,$6000,$F000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$006B,$0010,$001F,$001C,$F600,$5400,$A800,$5C00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01AF,$0041,$007E,$0071,$D800,$5000,$A000,$7000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01AE,$0041,$007E,$0071,$FE00,$3C00,$C000,$3C00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$06BB,$0104,$01FB,$01C4,$F800,$F000,$0000,$F000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$06A4,$011B,$01E4,$01DB,$7600,$9400,$6800,$9C00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1A91,$046E,$0791,$076E,$D800,$5000,$A000,$7000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0AE2,$041D,$0782,$077D,$FE00,$3C00,$C000,$3C00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$2B8B,$1074,$1E0B,$1DF4,$F800,$F000,$0000,$F000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0B35,$010A,$0705,$04FA,$F600,$1400,$E800,$1C00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$2CD7,$0428,$1C17,$13E8,$D800,$5000,$A000,$7000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0C92,$048D,$07E2,$009D,$FE00,$3C00,$C000,$3C00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0003,$0000,$0000,$0000
		dc.w	$F000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$324B,$1234,$1F8B,$0274,$F800,$F000,$0000,$F000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0DC9,$05C6,$07E1,$01DE,$7E00,$9400,$6800,$9400
		dc.w	$0FFF,$0000,$0000,$0000,$8000,$0000,$0000,$0000
		dc.w	$003F,$0000,$0000,$0000,$FE1C,$0003,$0003,$0002
		dc.w	$9000,$6000,$A000,$4000,$FFF8,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$03FF,$0000,$0000,$0000
		dc.w	$E000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3725,$171A,$1F85,$077A,$F800,$5000,$A000,$5000
		dc.w	$3FFE,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0DC4,$05C3,$07E0,$01DF,$BE00,$4800,$B400,$4800
		dc.w	$700B,$0A06,$0C01,$07FF,$6000,$8000,$8000,$0000
		dc.w	$01C0,$0028,$0030,$001F,$2DE5,$1A19,$061C,$FC12
		dc.w	$5007,$6000,$E000,$2000,$00B6,$A068,$C018,$7FF0
		dc.w	$0000,$0000,$0000,$0000,$1C02,$0281,$0300,$01FF
		dc.w	$D800,$A000,$6000,$C000,$0000,$0000,$0000,$0000
		dc.w	$3712,$170D,$1F82,$077D,$F801,$2000,$D000,$2000
		dc.w	$C02D,$281A,$3006,$1FFC,$8000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0886,$0081,$07F8,$0087,$7E01,$8C00,$7000,$8C00
		dc.w	$8677,$5676,$667E,$3981,$1800,$A000,$6000,$C000
		dc.w	$0619,$0159,$0199,$00E6,$DC17,$DAC7,$F9F4,$072C
		dc.w	$E018,$C005,$8006,$4003,$6771,$676A,$67E6,$981C
		dc.w	$8000,$0000,$0000,$0000,$619D,$159D,$199F,$0E60
		dc.w	$C600,$A800,$9800,$7000,$0000,$0000,$0000,$0000
		dc.w	$2219,$0206,$1FE1,$021E,$F806,$3001,$C001,$3000
		dc.w	$19DC,$59DA,$99F9,$E607,$6000,$8000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0813,$0010,$07F8,$0017,$3E02,$C801,$3401,$C801
		dc.w	$18DA,$581A,$981F,$E7E0,$C400,$A800,$9800,$7000
		dc.w	$0863,$0560,$0660,$079F,$6BBF,$6A1F,$7EF3,$8140
		dc.w	$2021,$4015,$C019,$C01E,$8DAC,$81AA,$81F9,$7E07
		dc.w	$4000,$8000,$8000,$0000,$8636,$5606,$6607,$79F8
		dc.w	$B100,$AA00,$E600,$1C00,$0000,$0000,$0000,$0000
		dc.w	$204C,$0043,$1FE0,$005F,$F808,$2005,$D006,$2007
		dc.w	$636B,$606A,$607E,$9F81,$1000,$A000,$6000,$C000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$09C2,$01C1,$07F8,$0007,$5E04,$A802,$5403,$A801
		dc.w	$71A5,$F005,$70EF,$8F50,$6200,$5400,$CC00,$3800
		dc.w	$11C6,$0BC0,$0DC3,$063D,$95F5,$1516,$BF4D,$40A3
		dc.w	$C047,$002F,$0037,$0018,$1A56,$0055,$0EFC,$F503
		dc.w	$2001,$4000,$C000,$8000,$1C69,$BC01,$DC3B,$63D4
		dc.w	$5880,$5500,$F300,$0E00,$0000,$0000,$0000,$0000
		dc.w	$2709,$0706,$1FE1,$001E,$7811,$A00B,$500D,$A006
		dc.w	$C695,$C015,$C3BF,$3D40,$8800,$5000,$3000,$E000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0879,$0078,$07F8,$0007,$3E08,$C005,$3C06,$C003
		dc.w	$D3E4,$D004,$F0AB,$0FB0,$3100,$2A00,$E600,$1C00
		dc.w	$234F,$1740,$1BC2,$0C3E,$90B7,$10B0,$AFF6,$C00A
		dc.w	$008D,$005D,$006F,$0030,$3E43,$0042,$0ABE,$FB01
		dc.w	$1002,$A001,$6001,$C000,$34F9,$7401,$BC2A,$C3EC
		dc.w	$0C40,$0A80,$F980,$0700,$0000,$0000,$0000,$0000
		dc.w	$21E4,$01E3,$1FE0,$001F,$F823,$0017,$F01B,$000C
		dc.w	$4F90,$4010,$C2AF,$3EC0,$C400,$A800,$9800,$7000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$098B,$0188,$07F8,$0187,$1E11,$E80B,$140D,$E806
		dc.w	$25AA,$200A,$E005,$1F10,$5880,$5500,$F300,$0E00
		dc.w	$4496,$2C80,$3780,$187C,$A802,$280C,$17E4,$4018
		dc.w	$0112,$00B2,$00DE,$0061,$5AA5,$00A5,$005F,$F100
		dc.w	$8804,$5002,$3003,$E001,$496A,$C802,$7801,$87C4
		dc.w	$9620,$9540,$7CC0,$0380,$0000,$0000,$0000,$0000
		dc.w	$262C,$0623,$1FE0,$061F,$7844,$A02C,$5037,$A018
		dc.w	$96A9,$8029,$8017,$7C40,$6200,$5400,$CC00,$3800
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0BCD,$03CC,$07FC,$03C3,$2A23,$D417,$281B,$D40D
		dc.w	$92AC,$910C,$F00B,$8F10,$B440,$B280,$F180,$8F00
		dc.w	$8E4A,$5E44,$6FC0,$363C,$B2D1,$32CA,$2FC6,$423C
		dc.w	$0239,$0179,$01BF,$00D8,$2ACB,$10CB,$00BF,$F108
		dc.w	$4408,$2805,$1806,$F003,$E4AB,$E443,$FC02,$63C4
		dc.w	$2D10,$2CA0,$FC60,$23C0,$0000,$0000,$0000,$0000
		dc.w	$315E,$1159,$1EF8,$0047,$A88E,$505E,$A06F,$5036
		dc.w	$4AB2,$4432,$C02F,$3C42,$D100,$CA00,$C600,$3C00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0FCC,$07CC,$07FC,$03C3,$9E46,$602E,$1C37,$E03A
		dc.w	$E7A1,$E001,$E00E,$9F10,$5621,$5140,$F0C0,$4F80
		dc.w	$1B9E,$BB80,$DF80,$EA7C,$8558,$0545,$3BC3,$413E
		dc.w	$846E,$02EE,$037E,$03A9,$7A15,$0015,$00EF,$F104
		dc.w	$6211,$140B,$0C0D,$F80E,$B9E8,$B800,$F803,$A7C4
		dc.w	$5588,$5450,$BC30,$13E0,$0000,$0000,$0000,$0000
		dc.w	$569E,$369D,$3F7C,$0603,$791B,$80BB,$70DF,$80EA
		dc.w	$9E85,$8005,$803B,$7C41,$5880,$4500,$C300,$3E00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0D9D,$059C,$07FC,$0183,$8A6F,$741F,$082F,$F437
		dc.w	$2AB6,$2116,$E01F,$1F06,$9BE1,$9800,$78C0,$0740
		dc.w	$BCAA,$7C84,$BF80,$DC7C,$DA6F,$5A60,$7DE3,$181D
		dc.w	$86F2,$01F2,$02FE,$0371,$AB69,$1169,$01F7,$F060
		dc.w	$BE1B,$8007,$8C0B,$740D,$CAAD,$C845,$F807,$C7C1
		dc.w	$A6F8,$A600,$DE30,$81D0,$0001,$0000,$0000,$0000
		dc.w	$A6CE,$46CB,$6FFA,$36C5,$29BC,$D07C,$20BF,$D0DC
		dc.w	$AADA,$845A,$807D,$7C18,$6F80,$6000,$E300,$1D00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0EFC,$06FC,$07FC,$0003,$C692,$3852,$007F,$FC22
		dc.w	$65A6,$6206,$E00F,$5F16,$C152,$C0E1,$F021,$CFC0
		dc.w	$4996,$4988,$FF80,$897C,$9B05,$1B03,$3FC0,$5B3F
		dc.w	$4926,$8526,$87FE,$0225,$5A6C,$206C,$00FF,$F16C
		dc.w	$1524,$0E14,$021F,$FC08,$9969,$9881,$F803,$97C5
		dc.w	$B054,$B038,$FC08,$B3F0,$001E,$0001,$0001,$0001
		dc.w	$709F,$B09C,$DF7C,$6003,$1A49,$E149,$01FF,$F089
		dc.w	$969B,$881B,$803F,$7C5B,$0540,$0380,$C080,$3F00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0FEC,$07EC,$07FC,$000B,$7ED9,$0039,$185E,$E478
		dc.w	$AEB0,$A110,$E01F,$9F00,$9AF3,$9800,$7861,$07A1
		dc.w	$66BA,$E684,$7B80,$E27C,$C26B,$4260,$7DE1,$001E
		dc.w	$CD9A,$039A,$85EE,$8789,$EB09,$1109,$01F7,$F000
		dc.w	$AF36,$800E,$8617,$7A1E,$6BA8,$6844,$B803,$27C4
		dc.w	$26BC,$2600,$DE18,$01E8,$0063,$001D,$001E,$001B
		dc.w	$0D8F,$8D8E,$0FFE,$F401,$FB66,$00E6,$617B,$91E2
		dc.w	$BAC2,$8442,$807D,$7C00,$6BC0,$6000,$E180,$1E80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0B9E,$039E,$03FE,$041D,$AF3B,$10BB,$08FE,$F45A
		dc.w	$24AD,$230D,$E00F,$1F14,$8D6C,$8C32,$FC13,$03E1
		dc.w	$EC92,$EC8C,$FB80,$687C,$B635,$3630,$3FF0,$500F
		dc.w	$B3B2,$CBB2,$4FEE,$85A1,$4AD8,$30D8,$00FF,$F140
		dc.w	$D6CE,$C32E,$C13F,$3E16,$C92B,$C8C7,$B803,$87C5
		dc.w	$635A,$630C,$FF04,$00F8,$0198,$006C,$0070,$005F
		dc.w	$15D6,$15D4,$17BC,$EC03,$BCEC,$42EC,$23FB,$D168
		dc.w	$92B6,$8C36,$803F,$7C50,$35A0,$30C0,$F040,$0F80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0AC9,$02C9,$03BF,$0488,$37A3,$0863,$50BC,$ACE0
		dc.w	$A4B5,$A315,$E017,$9F0C,$D0FE,$D001,$B832,$07D3
		dc.w	$8E92,$8E8C,$F380,$827C,$D743,$5740,$5EE0,$301F
		dc.w	$FA3A,$063A,$CBCE,$4E09,$4B5D,$315D,$017B,$F0C0
		dc.w	$0FE8,$0018,$832F,$7D38,$E929,$E8C5,$3801,$27C7
		dc.w	$743E,$7400,$EE0C,$01F4,$06C0,$0160,$0180,$01FF
		dc.w	$098E,$698E,$0E7F,$F000,$DE8E,$218E,$42F3,$B382
		dc.w	$92D7,$8C57,$805E,$7C30,$43E0,$4000,$E0C0,$1F40
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$09E5,$01E5,$039B,$0580,$0E7D,$117D,$29E2,$D4A0
		dc.w	$4CA9,$4B09,$C80E,$3710,$8D4B,$8C27,$7C15,$03F6
		dc.w	$F532,$F52C,$8B20,$80DC,$A635,$2630,$39F0,$400F
		dc.w	$27D4,$97D4,$5E2C,$CA03,$CA98,$B098,$80E7,$7100
		dc.w	$D49F,$C25F,$C178,$3F28,$5329,$52C5,$B203,$0DC5
		dc.w	$E52E,$E510,$9B0C,$80F4,$0B08,$0588,$0648,$07BF
		dc.w	$3BD6,$9BD6,$7D3E,$E101,$39F5,$45F5,$A78B,$5280
		dc.w	$32A6,$2C26,$2039,$DC40,$3520,$3080,$F040,$0FC0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$09E8,$01E8,$0217,$0400,$B37A,$ACFA,$C105,$1D80
		dc.w	$24B3,$2313,$E01D,$1F01,$D69B,$D675,$3E06,$01F0
		dc.w	$E892,$E88C,$1780,$007C,$9F5A,$1F59,$64F8,$0407
		dc.w	$77A2,$CFA2,$105E,$D801,$4B3D,$313D,$01D3,$F010
		dc.w	$69DE,$673E,$E041,$1F60,$8929,$88C1,$7802,$07C4
		dc.w	$E892,$E888,$1784,$007C,$149C,$0A9D,$0CFC,$0F9F
		dc.w	$2F8F,$4F8F,$C87F,$9000,$9DE8,$63E8,$1417,$E600
		dc.w	$92CF,$8C4F,$8074,$7C04,$5A60,$59C0,$F800,$07C0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$08C5,$00C5,$033A,$0400,$93B1,$8C31,$814E,$7D80
		dc.w	$66A7,$6307,$A018,$1F00,$8CDC,$8C32,$7C05,$03F6
		dc.w	$C59A,$C58C,$3A80,$007C,$8F80,$0F80,$7074,$000B
		dc.w	$3B16,$C316,$14EA,$D801,$6A78,$3078,$0187,$F000
		dc.w	$CDEC,$C30C,$C053,$3F60,$59A8,$58C0,$A803,$07C4
		dc.w	$C592,$C58C,$3A80,$007C,$29FE,$15DD,$19DC,$1FEB
		dc.w	$7757,$9756,$9EBE,$0601,$8EC5,$70C5,$053A,$F600
		dc.w	$9A9E,$8C1E,$8061,$7C00,$3360,$30C0,$F000,$0FC0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$082B,$002B,$03F5,$0420,$A28A,$9C0A,$817D,$7D88
		dc.w	$E9AF,$E70F,$6016,$1F06,$578C,$5662,$BE15,$01F6
		dc.w	$2BA6,$2B9C,$F580,$207C,$9740,$1740,$28A8,$4017
		dc.w	$68AE,$80AE,$57D6,$9881,$9AF5,$70F5,$016B,$F060
		dc.w	$78A2,$6602,$E15F,$1F62,$BA68,$B9C0,$5803,$07C4
		dc.w	$4592,$458C,$BA80,$007C,$52FE,$2AF9,$33F8,$3E87
		dc.w	$BF0F,$1F0E,$16FE,$0601,$4A2B,$B02B,$05F5,$F620
		dc.w	$A6BD,$9C3D,$805A,$7C18,$5E20,$5980,$F840,$07C0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0987,$0187,$037B,$0500,$32E1,$0DE1,$10DE,$ED40
		dc.w	$CFB7,$C317,$C40E,$3B06,$AD5D,$ACA3,$5C15,$03F7
		dc.w	$873E,$870C,$7B10,$00EC,$8A82,$0A80,$7570,$000F
		dc.w	$AE1C,$5E1C,$8DEC,$5403,$FB7A,$317A,$40E5,$B060
		dc.w	$D5B8,$CA78,$C137,$3F50,$73E9,$70C1,$B103,$0EC5
		dc.w	$ABA2,$AB9C,$7580,$207C,$A1BC,$51BF,$67FC,$799B
		dc.w	$A61D,$061C,$0FFC,$1603,$0B87,$F787,$037B,$F500
		dc.w	$3EDE,$0C5E,$1039,$EC18,$B560,$B280,$7040,$0FC0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0996,$0196,$027E,$0401,$57E5,$2CE5,$109F,$ED00
		dc.w	$95AF,$890F,$8616,$7B06,$468D,$4653,$BE34,$01E6
		dc.w	$9656,$9624,$7E18,$01EC,$8403,$0400,$3BE1,$401E
		dc.w	$7E59,$8E58,$49F8,$9007,$5AF4,$90F4,$616B,$B060
		dc.w	$68F9,$6539,$E327,$1E40,$6569,$6241,$E182,$1EC4
		dc.w	$8733,$870C,$7B10,$00EC,$C3BD,$23BF,$4FFC,$739B
		dc.w	$A659,$0658,$09F8,$1007,$1F96,$F396,$027E,$F401
		dc.w	$56BD,$243D,$185A,$EC18,$1A20,$1940,$F8C0,$0780
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0BA8,$03A8,$03F8,$0407,$AFEA,$4C6A,$107E,$FD81
		dc.w	$29A7,$1007,$0708,$FF10,$A41D,$A4A3,$5C65,$03C6
		dc.w	$A8A6,$A840,$F81C,$07FC,$800F,$0000,$5FC3,$203C
		dc.w	$BEA2,$06A1,$C7E0,$581F,$9A7A,$007A,$7085,$F100
		dc.w	$41FA,$4A1A,$C61F,$3C60,$8A6B,$8403,$81C3,$7FC4
		dc.w	$9657,$962C,$FE10,$01EC,$043E,$C43A,$9FF9,$E407
		dc.w	$AEA2,$0EA1,$0FE0,$101F,$FFA8,$31A8,$41F8,$B607
		dc.w	$A69E,$401E,$1C21,$FC40,$9040,$9280,$7180,$0F00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0DFD,$01FC,$01FC,$0603,$D7FF,$2CFF,$18FF,$F500
		dc.w	$76CB,$082B,$0736,$FF02,$4869,$4A87,$B985,$0702
		dc.w	$FDDA,$FC20,$FC1C,$03FC,$801E,$0000,$2A86,$5579
		dc.w	$BFF7,$4FF0,$CFF0,$100F,$6CB4,$82B4,$736B,$F020
		dc.w	$86FF,$A83F,$983F,$7040,$DDAD,$C201,$C1C1,$3FC6
		dc.w	$A8AE,$A84D,$F811,$07FD,$9F7D,$1F20,$BF27,$C0DF
		dc.w	$B7F7,$07F0,$07F0,$180F,$DFFD,$33FC,$63FC,$9403
		dc.w	$DB2D,$20AD,$1CDA,$FC08,$2180,$2A00,$E600,$1C00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0A05,$0002,$0000,$07FF,$E381,$0D00,$3D00,$D0FF
		dc.w	$7BA0,$8040,$0F6F,$F730,$A18A,$AA05,$6606,$1C05
		dc.w	$05EE,$0210,$007C,$FF8C,$803C,$0000,$141C,$6BE3
		dc.w	$B817,$D008,$5000,$CFFF,$BA0A,$040A,$F6F6,$7301
		dc.w	$18E0,$A040,$6040,$C03F,$5EEA,$2000,$03C0,$FDC7
		dc.w	$7DF7,$7C0C,$7C19,$83F5,$017B,$90C0,$204F,$DFB7
		dc.w	$A817,$0008,$0000,$1FFF,$CE05,$3402,$F400,$03FF
		dc.w	$EE82,$0102,$3DBD,$DCC0,$8600,$A800,$9800,$7000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0D59,$0006,$0000,$07FF,$9BD6,$4481,$3C80,$F97F
		dc.w	$6350,$9420,$0FC7,$FFB8,$8606,$A801,$9802,$7003
		dc.w	$184E,$C790,$007C,$FFBC,$C0C3,$0019,$407E,$3FBD
		dc.w	$3D66,$4819,$C800,$97FF,$3508,$420A,$FC79,$FB87
		dc.w	$60F5,$8020,$8020,$005F,$98ED,$6500,$03C0,$FFC7
		dc.w	$05E2,$020D,$003D,$FFD0,$0676,$91A1,$002F,$FFDE
		dc.w	$B567,$0018,$0000,$1FFF,$EF59,$1206,$F200,$25FF
		dc.w	$8D42,$5082,$3F1E,$FEE1,$1800,$A000,$6000,$C000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0B75,$0096,$0008,$07FF,$DBDD,$0420,$7C07,$B9FA
		dc.w	$72AA,$8511,$1FE0,$EEDF,$9805,$2002,$E003,$4000
		dc.w	$C4CA,$3B30,$C4FC,$3B1C,$A302,$007E,$21FD,$5EBB
		dc.w	$3DD7,$C208,$C071,$5FAE,$2AA9,$5112,$FE0E,$EDF4
		dc.w	$80F7,$0008,$0001,$007E,$5CAB,$2140,$C7C0,$BB87
		dc.w	$59DB,$8604,$003D,$FFF9,$0DF6,$2001,$179F,$FA6E
		dc.w	$AADF,$0000,$0779,$1FA6,$AF75,$1082,$B01C,$67EB
		dc.w	$CAAA,$1444,$7F83,$BB7D,$6000,$8000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0E00,$01EB,$001C,$07F7,$1680,$A17A,$7C07,$DDFD
		dc.w	$001E,$EFD0,$1FEF,$F431,$6004,$8002,$8003,$0003
		dc.w	$BF02,$0070,$FFFC,$40BC,$CC04,$01F8,$4FFF,$3217
		dc.w	$6800,$97AE,$8071,$9FDF,$01E6,$FD08,$FEF8,$4310
		dc.w	$00A0,$005E,$0001,$007F,$002E,$BBC1,$C7C0,$7D07
		dc.w	$77DA,$9405,$0A7C,$FDB9,$99ED,$E200,$9F5F,$F5BF
		dc.w	$B99F,$0620,$07F5,$195A,$9A00,$05EB,$B01C,$77F7
		dc.w	$0079,$BF42,$7FBE,$D0C4,$8000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0C16,$0331,$00CE,$07F9,$DB05,$28CC,$F433,$7DFE
		dc.w	$F281,$0D72,$BFFE,$5A8C,$8002,$0001,$0001,$0000
		dc.w	$C00A,$03F0,$FFFC,$3DFC,$E808,$07F1,$7FFF,$188E
		dc.w	$F05F,$0CC0,$033B,$1FE5,$2818,$D720,$FFE0,$A8C0
		dc.w	$00C1,$0033,$000C,$007F,$7CAC,$0343,$EFC0,$9687
		dc.w	$03B6,$6800,$9D7C,$F6FD,$AEF6,$800A,$FFBD,$F357
		dc.w	$B2EF,$0800,$07FB,$1F34,$EC17,$2330,$D0CE,$37F9
		dc.w	$CA06,$35C8,$FFF8,$6A30,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0C2F,$02E8,$01D7,$0738,$1E0B,$65BA,$F875,$B5CE
		dc.w	$C376,$1C88,$FFF8,$3F70,$0002,$0001,$0001,$0001
		dc.w	$6702,$00F0,$FFFC,$9F5C,$B012,$4FE1,$3FFF,$561F
		dc.w	$A0BC,$1BA1,$075F,$1CE3,$3760,$C880,$FF80,$F700
		dc.w	$0082,$006E,$001D,$0073,$F0EC,$8702,$7FC1,$8FC7
		dc.w	$17DA,$B028,$CEF5,$795C,$FDC7,$BC19,$43FE,$7E25
		dc.w	$B7DC,$0FC1,$003F,$1FE2,$782F,$16E8,$E1D7,$9738
		dc.w	$0DD8,$7220,$FFE0,$FDC0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0C06,$02D0,$01FF,$0729,$9F01,$60B4,$FC7F,$F1CA
		dc.w	$82D8,$3D20,$FFE0,$5AC0,$0001,$0000,$0000,$0000
		dc.w	$100E,$87FC,$FFF0,$482C,$B159,$4E82,$3FFE,$5764
		dc.w	$B018,$0B43,$07FF,$1CA5,$2D80,$D200,$FE00,$AC00
		dc.w	$00C0,$002D,$001F,$0072,$60AC,$0F42,$FFC1,$9687
		dc.w	$2F1E,$E864,$D7F9,$3894,$AAA7,$8818,$77FF,$7F64
		dc.w	$B2AA,$0881,$077F,$1FF6,$3C06,$82D0,$F1FF,$4729
		dc.w	$0B60,$F480,$FF80,$6B00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0901,$0738,$00FF,$07C7,$1640,$E9CE,$F43F,$59F1
		dc.w	$0360,$7C80,$FF80,$BF00,$0001,$0000,$0000,$0000
		dc.w	$180E,$D3FC,$FFF0,$A41C,$96B1,$6906,$1FFE,$76CA
		dc.w	$2400,$1CE7,$03FF,$1F1B,$3600,$C800,$F800,$F000
		dc.w	$0090,$0073,$000F,$007C,$00E9,$9F07,$FFC0,$6FC7
		dc.w	$069F,$5061,$FFFC,$A990,$544D,$2432,$FBFD,$5FCE
		dc.w	$A144,$1E43,$07BF,$19FC,$D900,$2739,$D0FF,$E7C6
		dc.w	$0D80,$F200,$FE00,$FC00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0DC4,$03D3,$003F,$07EC,$1BC0,$E575,$F83F,$B5CA
		dc.w	$0380,$FD00,$FE00,$7B00,$0001,$0000,$0000,$0000
		dc.w	$100F,$87FC,$DFF0,$682C,$9EC2,$60AC,$1F5C,$7FB4
		dc.w	$3C00,$175F,$03FF,$1CA7,$3800,$D000,$E000,$B000
		dc.w	$00F0,$005D,$000F,$0072,$00ED,$7F43,$FF80,$9EC7
		dc.w	$813E,$B8D4,$7FE1,$C73C,$BD16,$8CE9,$73FE,$7F15
		dc.w	$B3D1,$0CCE,$073F,$1BF1,$6F00,$95D7,$E0FF,$5729
		dc.w	$0E00,$F400,$F800,$EC00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$09D0,$07CF,$003F,$07F2,$1700,$E97F,$F43F,$59C6
		dc.w	$0380,$FD00,$FE00,$D300,$0002,$0001,$0001,$0001
		dc.w	$2004,$0FFF,$BFF0,$D22F,$138C,$E230,$1DF0,$FE50
		dc.w	$3000,$17FF,$03FF,$1C6D,$3800,$D000,$E000,$3000
		dc.w	$00C0,$005F,$000F,$0071,$00E9,$FF47,$FF80,$B4C7
		dc.w	$C446,$D3B4,$3FE0,$EC5D,$8803,$87FC,$FFFF,$7E80
		dc.w	$A240,$183F,$07FF,$1FC8,$DC00,$25FF,$D0FF,$E71B
		dc.w	$0E00,$F400,$F800,$4C00,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0940,$073F,$00FF,$07DB,$0AE0,$E49F,$F9BF,$1566
		dc.w	$0780,$FA00,$FD00,$0600,$0002,$0001,$0001,$0000
		dc.w	$0060,$1F97,$3FF8,$E76F,$3F10,$E060,$1FE0,$E0A0
		dc.w	$2E00,$09FF,$1BFF,$1660,$7800,$A000,$D000,$6000
		dc.w	$00B8,$0027,$006F,$0059,$01E9,$FE87,$FF40,$8187
		dc.w	$503A,$4FC9,$BFEC,$F235,$D007,$8FFA,$FFFD,$3606
		dc.w	$A501,$1CFE,$03FF,$1F6D,$AB80,$127F,$E6FF,$D598
		dc.w	$1E00,$E800,$F400,$1800,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0F00,$00FF,$07FF,$013C,$9FE0,$607F,$FD5F,$91A0
		dc.w	$0B80,$F500,$FE00,$0900,$0002,$0000,$0001,$0001
		dc.w	$4800,$3780,$7FFF,$8A7F,$FC60,$E180,$1F80,$E280
		dc.w	$3E00,$07FF,$15FF,$1A00,$B800,$5000,$E000,$9000
		dc.w	$00F8,$001F,$0057,$0068,$02EF,$FD40,$FF87,$0241
		dc.w	$407F,$BFB0,$FFD5,$5B6D,$E00B,$1FF5,$7FFE,$A009
		dc.w	$BC02,$03FD,$1FFF,$04F2,$FF80,$01FF,$F57F,$C680
		dc.w	$2E00,$D400,$F800,$2400,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0A00,$01FF,$07FF,$063C,$0EB0,$E98F,$F55F,$18B4
		dc.w	$5780,$AB00,$FC00,$5700,$0044,$0003,$0002,$0003
		dc.w	$373D,$8801,$7FFE,$F7FF,$6180,$5E00,$BE00,$E600
		dc.w	$2B05,$18FA,$15FF,$0B45,$7800,$B000,$C000,$7000
		dc.w	$04AC,$0063,$0057,$002D,$15EA,$EAC1,$FF07,$15C6
		dc.w	$00AA,$FF4D,$FFD5,$3CA9,$6057,$BFAB,$1FFC,$E457
		dc.w	$A801,$07FE,$1FFF,$18F1,$BAC1,$263E,$D57F,$E2D1
		dc.w	$5E00,$AC00,$F000,$5C00,$0100,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0C00,$01FF,$07FF,$0658,$8ED0,$7D1F,$F1AF,$8DDE
		dc.w	$AC80,$5000,$FF00,$AF00,$00A4,$0043,$0042,$0041
		dc.w	$CE73,$306C,$FF9C,$4FF4,$FE00,$0000,$0000,$0000
		dc.w	$2D0A,$11F5,$1AFF,$1DEA,$C800,$0000,$F000,$F000
		dc.w	$0AB4,$0447,$046B,$0477,$2B2C,$D401,$FFC7,$ABC6
		dc.w	$00DA,$FF45,$FFAD,$58DD,$F0AC,$8F50,$3FFF,$DEAF
		dc.w	$B002,$07FD,$1FFF,$1962,$FB42,$347D,$C6BF,$F77A
		dc.w	$B200,$4000,$FC00,$BC00,$0280,$0100,$0100,$0100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0901,$02FE,$05FF,$0705,$6F49,$88D6,$F4AF,$785D
		dc.w	$7A80,$8200,$FD00,$7F00,$0324,$00C1,$00C2,$0083
		dc.w	$CDD7,$30AA,$FF55,$4FAB,$3E00,$C000,$C000,$4000
		dc.w	$3497,$0D68,$0AFF,$05D7,$A800,$2000,$D000,$F000
		dc.w	$3252,$0C35,$0C2B,$0817,$5EA9,$A082,$FF45,$5FC7
		dc.w	$0197,$FE58,$FFA8,$05D0,$B17A,$5E82,$8FFD,$F57F
		dc.w	$A405,$0BFA,$17FF,$1C15,$BD25,$235A,$D2BF,$E175
		dc.w	$EA00,$0800,$F400,$FC00,$0C80,$0300,$0300,$0200
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0880,$057F,$01FF,$068E,$FF68,$0C8F,$F0C7,$FCF8
		dc.w	$FC80,$0000,$FF00,$FF00,$0CD5,$0320,$03E3,$02E2
		dc.w	$FAE0,$0418,$FFE0,$7B1F,$39C0,$1600,$2E00,$DA00
		dc.w	$168E,$08F0,$0C7F,$0F8F,$C800,$0000,$F000,$F000
		dc.w	$CD5A,$3223,$3E31,$2E3E,$3F28,$C005,$FFC1,$3FC6
		dc.w	$80B5,$7F88,$FF18,$8EF8,$18D4,$A700,$DFFF,$E8FF
		dc.w	$A203,$15FC,$07FF,$1A3B,$FDA3,$323C,$C31F,$F3E3
		dc.w	$B200,$0000,$FC00,$FC00,$3340,$0C80,$0F80,$0B80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0901,$04FE,$03FF,$0505,$EEB5,$0C6A,$F047,$FC3D
		dc.w	$E840,$0080,$FF80,$FF80,$3295,$0CA0,$0F63,$0BC2
		dc.w	$B8C0,$06B4,$FF40,$79BF,$C730,$C2C0,$C5C0,$FB40
		dc.w	$0B5F,$06A0,$047F,$03DF,$8403,$0800,$F800,$F800
		dc.w	$292D,$CA1A,$F611,$BC0F,$7A29,$8004,$FFC3,$7FC5
		dc.w	$0168,$FEB0,$FF10,$05E0,$FDE1,$2A01,$57FE,$6DFF
		dc.w	$6407,$93F8,$8FFF,$9417,$BAD7,$31A8,$C11F,$F0F7
		dc.w	$E100,$0200,$FE00,$FE00,$CA40,$3280,$3D80,$2F00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$09AA,$0055,$03FF,$05AA,$DABA,$0851,$F46F,$FC76
		dc.w	$F440,$0080,$FF80,$FF80,$CB55,$3282,$3D63,$2EA0
		dc.w	$F860,$461A,$BFE0,$799F,$D1CC,$D2B0,$D170,$FED0
		dc.w	$0BA3,$0510,$06FF,$076F,$440C,$0803,$F803,$F802
		dc.w	$B52E,$2814,$D61B,$EA1D,$BD29,$4000,$FFC3,$BFC5
		dc.w	$AAE8,$5450,$FFB0,$AB70,$BED6,$5502,$6BFD,$36FF
		dc.w	$66AB,$8154,$8FFF,$96AB,$6AE8,$2144,$D1BF,$F1DB
		dc.w	$D103,$0200,$FE00,$FE00,$2D40,$CA00,$F580,$BA80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$08D7,$0028,$07FF,$01D7,$E65D,$0428,$F837,$FC3B
		dc.w	$E047,$0080,$FF80,$FF00,$2E2C,$CD12,$F233,$BDD3
		dc.w	$5D30,$802D,$7FD0,$BFEF,$0072,$412C,$005C,$FFB4
		dc.w	$05D2,$0280,$037F,$03BF,$8472,$080C,$F80F,$F00B
		dc.w	$E297,$D10A,$230D,$DD0E,$7828,$0000,$FFC7,$FFC1
		dc.w	$D5D0,$28A0,$FF60,$D6E0,$56A1,$2201,$3DFE,$1BFF
		dc.w	$635F,$80A0,$8FFF,$175F,$9974,$10A0,$E0DF,$F0EF
		dc.w	$A11C,$0203,$FE03,$FC02,$B8A0,$3440,$C8C0,$F740
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0DBF,$0540,$02FF,$01BF,$422E,$8014,$FC1B,$7C1D
		dc.w	$F6B9,$0246,$FDC7,$FF85,$782A,$7451,$8831,$F7F0
		dc.w	$16BC,$703B,$8FC4,$FFFB,$003D,$AACA,$0036,$FFCE
		dc.w	$02EC,$0140,$01BF,$01DF,$2B97,$2467,$DC78,$F85F
		dc.w	$828B,$4505,$8306,$7F07,$BDAD,$0085,$FF42,$7FC1
		dc.w	$BBA0,$4140,$FEC0,$BDC0,$2BCB,$110B,$1EF4,$0DFF
		dc.w	$A6FD,$5502,$C3FF,$9EFD,$08BB,$0050,$F06F,$F077
		dc.w	$0AE5,$0919,$F71E,$FE17,$E0A0,$D140,$20C0,$DFC0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0F7A,$0605,$01FF,$00FA,$4E15,$8008,$FC0F,$7C0E
		dc.w	$A9A8,$8190,$7E7F,$FFEF,$A0D2,$9121,$60E1,$DF61
		dc.w	$0217,$A614,$C1EB,$7FFC,$000F,$FFF4,$000A,$FFF6
		dc.w	$0158,$0088,$00F7,$00EF,$1A8A,$1909,$E7F6,$FEFD
		dc.w	$0D05,$1202,$0E03,$F603,$6A6F,$2046,$DF81,$BFC0
		dc.w	$6D40,$0880,$F780,$FB80,$15D5,$08D5,$0F2A,$06FF
		dc.w	$B5EA,$9814,$67FF,$FBEB,$9856,$0022,$F03D,$F03B
		dc.w	$06A2,$0642,$F9FD,$FFBF,$8340,$4480,$8380,$7D80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0EB0,$078F,$027F,$03F0,$8A09,$0006,$FC07,$FC05
		dc.w	$E0F4,$E0F4,$1F0B,$FFFF,$8321,$44C0,$83C0,$7D40
		dc.w	$85BF,$655F,$7520,$5ADF,$F554,$0AA9,$F557,$0AAB
		dc.w	$809E,$006E,$0071,$005F,$0F48,$0F44,$F0B8,$FFF7
		dc.w	$3302,$4C01,$3C01,$D401,$782F,$B807,$C7C3,$7FC2
		dc.w	$BC80,$BB00,$4700,$FD00,$0AFF,$04FF,$0700,$03FF
		dc.w	$DED5,$DA28,$25FF,$FBD7,$2827,$001B,$F01C,$F017
		dc.w	$83D2,$83D1,$7C2E,$FFFD,$0CC0,$1300,$0F00,$F500
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0FCE,$0740,$07BF,$067F,$4604,$4003,$BC03,$FC02
		dc.w	$BFFC,$30F3,$CF0C,$F0F3,$0DC0,$1200,$0E00,$F400
		dc.w	$B5FF,$68C1,$5FCA,$7635,$FEFF,$A102,$5EFD,$A103
		dc.w	$804B,$0033,$003C,$002F,$FFC0,$0F31,$F0C0,$0F3F
		dc.w	$DC01,$2000,$E000,$4000,$2FEF,$CC07,$F3C7,$BC06
		dc.w	$E900,$6600,$9E00,$7A00,$04BF,$0331,$03CE,$02F1
		dc.w	$B77A,$A900,$56FF,$E9FF,$9812,$000C,$F00F,$F00B
		dc.w	$FFF0,$C3CC,$3C30,$C3CF,$3700,$4800,$3800,$D000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0FFA,$067A,$0785,$047F,$AA03,$A000,$5C00,$FC00
		dc.w	$2CD0,$C300,$FC00,$B3FF,$6600,$9800,$7800,$A800
		dc.w	$BB5F,$5480,$6CF7,$1C68,$FFFE,$D416,$2BE9,$D417
		dc.w	$8032,$000C,$000F,$000B,$CD06,$3009,$C007,$3FFA
		dc.w	$6000,$8000,$8000,$8000,$CB29,$30C6,$3F01,$2CC6
		dc.w	$A600,$1800,$F800,$6800,$032C,$00C3,$00FC,$00B3
		dc.w	$C06B,$0217,$0000,$FFFF,$980C,$8003,$7003,$F002
		dc.w	$B341,$0C02,$F001,$CFFE,$9800,$6000,$E000,$A000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0FFD,$06AD,$0552,$02AF,$0600,$0000,$FC00,$FC00
		dc.w	$E6A3,$1B04,$1C03,$17FD,$3801,$C000,$C000,$4000
		dc.w	$5DFA,$8A04,$F607,$EE03,$7FFE,$7ABE,$8541,$FABF
		dc.w	$800E,$0001,$0001,$0001,$6A33,$B04C,$C03C,$7FD4
		dc.w	$8000,$0000,$0000,$0000,$39AB,$06C6,$0701,$05C7
		dc.w	$3800,$C000,$C000,$4000,$00E6,$001B,$001C,$0017
		dc.w	$2031,$890F,$0600,$FFFF,$C803,$C000,$3000,$F000
		dc.w	$9A8C,$6C13,$700F,$5FF5,$E000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0FFF,$0000,$0000,$0000,$FE00,$0000,$0000,$0000
		dc.w	$1FFF,$0000,$0000,$0000,$C001,$0000,$0000,$0000
		dc.w	$3EC7,$8500,$FB00,$4700,$3FFB,$BFFA,$C005,$7FFF
		dc.w	$8001,$0000,$0000,$0000,$FFFC,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$07EF,$0000,$0000,$0000
		dc.w	$E000,$0000,$0000,$0000,$001F,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$F800,$0000,$0000,$0000
		dc.w	$7FFF,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0001,$0001,$0001
		dc.w	$97B0,$0140,$FEC0,$E9C0,$95D4,$15D5,$6A2B,$7FFF
		dc.w	$8000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0001,$0001,$0000
		dc.w	$8BEF,$0050,$FFB0,$F470,$2AAB,$AAA8,$D556,$7FFE
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0005,$0002,$0003,$0003
		dc.w	$41FC,$000B,$FFF7,$FE0E,$1005,$1002,$EFFE,$FFFE
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0005,$0002,$0003,$0001
		dc.w	$E85F,$0000,$FFFF,$FFA0,$400A,$0004,$FFFC,$BFFC
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$000B,$0004,$0007,$0007
		dc.w	$F500,$0000,$FFFF,$FFFF,$8154,$0008,$FFF8,$7FF8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0006,$0001,$0001,$0001
		dc.w	$7EA8,$8000,$FFFF,$7FFF,$0AE8,$0010,$FFF0,$FFF0
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$CFF5,$3000,$3FFF,$2FFF,$5730,$00C0,$FFC0,$FF40
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$38FF,$0700,$07FF,$06FF,$F8C0,$0700,$FF00,$F900
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$07C3,$003C,$003F,$0033,$8F00,$7000,$F000,$9000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003F,$0000,$0000,$0000,$F000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		
* <

MUSIC: 		; Not compressed please !
	incbin	*.THK
	even

******************************************************************
	SECTION	BSS
******************************************************************

bss_start:

* Full data here :
* >
TEST_END:DS.W      1 
TEST_CLS:DS.W      1 
PART_1:DS.W      1 
PART_2:DS.W      1 
PART_3:DS.L      1 

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

bss_end:

******************************************************************
	END
******************************************************************
