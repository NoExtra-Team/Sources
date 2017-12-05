* BSW_137.PRG

* // Original code : Zorro2/Atomus	// *
* // Gfx logo 	   : Mister.A		// *
* // Music 	   : Frazer		// *
* // Release date  : 29/05/2005		// *

***********************************************

	OPT	o-,d-

***********************************************

	SECTION	TEXT

***********************************************
SEEMYVBL      equ	1 ; 0 = I see VBL & 1 = nothing
SEE_INTRO     equ	0 ; 0 = I see it & 1 = nothing
gemdos        equ	1
crawcin       equ	7
cconws        equ	9
mshrink       equ	$4a
pexec         equ	$4b
timer_entre	equ	100+26
xmax		EQU 319
ymax		EQU 199
ok	equ	7999-4000+220
***********************************************

Start

	jmp	ON_Y_VA

	dc.b	"Code : AtomUS - "
	dc.b	"and Zorro 2 - "
	dc.b	"Gfx : Mister A. - "
	dc.b	"NoExtra Production 2005. "
	even
	
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
					
*	bra.s	FIN
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
	clr.w	$ffff8240.w

	lea	Palnoir,a0
	movem.l	(a0),d0-d7
	movem.l	d0-d7,$ffff8240.w

	MOVE.L	#Reset,$8.W	;Le detournement des bombes.
	MOVE.L	#Reset,$C.W
	MOVE.L	#Reset,$10.W
	MOVE.L	#Reset,$14.W
	MOVE.L	#Reset,$18.W
	MOVE.L	#Reset,$1C.W
	MOVE.L	#Reset,$20.W
	MOVE	#$2300,sr

	movem.l	d0-d7/a0-a6,-(a7)
	BSR	create160tb
	bsr	Genere_code
	movem.l	(a7)+,d0-d7/a0-a6

	moveq #1,d0
	jsr music		; activate first tune

	move	#$2700,sr

	lea	Vbl(pc),a0
	move.l	a0,$70.w

	stop	#$2300

	IFEQ	SEE_INTRO
	movea.l	Zorro_scr1,a1
	adda.l	#160*60,a1
	movea.l	#IMG_BSW0,a0
	move.l	#7999-5000+120,d0
.aff:	move.l	(a0)+,(a1)+
	dbf	d0,.aff
		
	lea     PalBsw0,a2
	bsr     fadeon	

	moveq	#timer_entre,d0
.att0:	
	bsr	Wait_vbl
	dbf	d0,.att0

	bsr	fadeoff
	
	movea.l	Zorro_scr1,a1
	adda.l	#160*50,a1
	movea.l	#IMG_BSW1,a0
	move.l	#7999-4280+120,d0
.aff_:	move.l	(a0)+,(a1)+
	dbf	d0,.aff_
		
	lea     PalBsw1,a2
	bsr     fadeon	

	moveq	#timer_entre,d0
.att1:	
	bsr	Wait_vbl
	dbf	d0,.att1

	bsr	fadeoff
	ENDC

	bsr	flush	*	reset tampon buffer du clavier
	
	st	go
*

	movem.l	d0-d7/a0-a6,-(a7)
	
	bsr	Efface_Zorro_scr1
	
	movea.l	Zorro_scr1,a1
	movea.l	#IMG_LOGO,a0
	move.l	#7999-6000,d0
.aff1:	move.l	(a0)+,(a1)+
	dbf	d0,.aff1

	movea.l	Zorro_scr1,a1
	lea	160*70(a1),a1
	movea.l	#IMG_TITLE,a0
	move.l	#ok,d0
.aff3:	move.l	(a0)+,(a1)+
	dbf	d0,.aff3

	movem.l	(a7)+,d0-d7/a0-a6
	
	bsr	Init

******************************************************************************

	move.l	$ffff8244.w,SAV_PAL

Main_rout:
	bsr	Wait_vbl

	IFEQ	SEEMYVBL
	clr.b	$ffff8240.w
	ENDC

	MOVE.L    Zorro_scr1,D0
	MOVE.L    Zorro_scr2,Zorro_scr1 
	MOVE.L    D0,Zorro_scr2
	LSR.W     #8,D0 
	MOVE.L    D0,$FFFF8200.W

	move.l	Zorro_scr2,a0
	lea	(160*50)(a0),a0
	moveq	#0,d0
	jsr Code_gen

	bSR	Show_obj

	BSR	SCROLLING

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
Run7:
	move.l	#PROG7,NOMPRG
	bra	RUN
Run8:
	move.l	#PROG8,NOMPRG
	bra	RUN
Run9:
	move.l	#PROG9,NOMPRG
	bra	RUN
RunCRC:
	move.l	#PROGCRC,NOMPRG
	bra	RUN

BYEBYE
	bsr	SoundOff
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

Vbl:	
	movem.l	d0-d7/a0-a6,-(a7)

	st	Vsync
       
	jsr (music+8)

	lea	go,a0
	tst.b	(a0)
	bne.s	.demo

	bra.s	.noviewdemo
.demo:

	move	#$2700,sr
	
	sf	$fffffa21.w
	sf	$fffffa1b.w
	move.l	#Over_rout,$120.w
	bset	#0,$fffffa07.w	* Timer B on
	bset	#0,$fffffa13.w	* Timer B on
	
	lea	Vbl_bis(pc),a0
	move.l	a0,$70.w
	
	stop	#$2300

.noviewdemo:
	movem.l	(a7)+,d0-d7/a0-a6
	rte

Vbl_bis

	st	Vsync

	move.l	SAV_PAL,$ffff8244.w

	movem.l	d0-d7/a0-a6,-(a7)
	jsr (music+8)
	movem.l	(a7)+,d0-d7/a0-a6
	
	move.l	#Over_rout,$120.w
	move.b	#199,$fffffa21.w
	move.b	#8,$fffffa1b.w

	rte
	
Wait_vbl:	
	move.l	a0,-(a7)
	lea	Vsync,a0
	sf	(a0)
Wait_label:	tst.b	(a0)
	beq.s	Wait_label
	move.l	(a7)+,a0
	rts

*********************************************
*                                           *
*********************************************

Init:	movem.l	d0-d7/a0-a6,-(a7)

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

	stop	#$2300

	move.b	$484.w,conterm	; Sauve ce bidule.
	clr.b	$484.w		; No bip,no repeat.
			
	bsr	hide_mouse

	bsr	flush
	move.b	#$12,d0
	bsr	setkeyboard
	
	rts

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

	move.b	#$ff,$ffff8244.w

	rte

SAV_PAL:	dc.l	0

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

	bsr	Efface_Zorro_scr1
	bsr	Efface_Zorro_scr2

	movea.l	Zorro_scr2,a1
	movea.l	#IMG_LOGO,a0
	move.l	#7999-6000,d0
.aff2:	move.l	(a0)+,(a1)+
	dbf	d0,.aff2

	movea.l	Zorro_scr2,a1
	lea	160*70(a1),a1
	movea.l	#IMG_TITLE,a0
	move.l	#ok,d0
.aff3:	move.l	(a0)+,(a1)+
	dbf	d0,.aff3

	movem.l	(a7)+,d0-d7/a0-a6
	rts

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

***************************************
SoundOff:
	moveq #0,d0
	jsr music		; desactivate tune

	move.b 	#8,$ffff8800.w        ; Sound OFF
	move.b 	#0,$ffff8802.w
  move.b 	#9,$ffff8800.w
  move.b 	#0,$ffff8802.w
  move.b 	#$a,$ffff8800.w
  move.b 	#0,$ffff8802.w
	RTS

******************************************************************

Show_obj
		LEA BSW,A5
		LEA seqdata(PC),A3
		SUBQ #1,seq_timer(A3)
		BNE.S .nonew
		MOVE.L seq_ptr(A3),A1
		TST (A1)
		BPL.S .notendseq
		MOVE.L restart_ptr(A3),A1 
.notendseq	MOVE.W (A1)+,seq_timer(A3)
		MOVE.W (A1)+,addangx(A3)
		MOVE.W (A1)+,addangy(A3)
		MOVE.W (A1)+,addangz(A3)	; store new incs..
		MOVE.W (A1)+,zspeed
		MOVE.L A1,seq_ptr(A3)
.nonew		LEA trig_tab,A0		; sine table
		LEA 512(A0),A2			; cosine table
		MOVEM.W (A5)+,D5-D7    		; get current x,y,z ang	
		ADD addangx(A3),D5
		ADD addangy(A3),D6		; add increments
		ADD addangz(A3),D7
		AND #$7FE,D5
		AND #$7FE,D6
		AND #$7FE,D7
		MOVEM.W D5-D7,-6(A5)   	
		MOVE (A0,D5),D0			sin(xd)
		MOVE (A2,D5),D1			cos(xd)
		MOVE (A0,D6),D2			sin(yd)
		MOVE (A2,D6),D3			cos(yd)
		MOVE (A0,D7),D4			sin(zd)
		MOVE (A2,D7),D5			cos(zd)
		LEA M11+2(PC),A1
* sinz*sinx(used twice) - A3
		MOVE D0,D6			sinx
		MULS D4,D6			sinz*sinx
		ADD.L D6,D6
		SWAP D6
		MOVE D6,A3
* sinz*cosx(used twice) - A4
		MOVE D1,D6			cosx
		MULS D4,D6			sinz*cosx
		ADD.L D6,D6
		SWAP D6
		MOVE D6,A4
* Matrix(1,1) cosy*cosx-siny*sinz*sinx
		MOVE D3,D6			cosy
		MULS D1,D6			cosy*cosx
		MOVE A3,D7			sinz*sinx
		MULS D2,D7			siny*sinz*sinx					
		SUB.L D7,D6
		ADD.L D6,D6
		SWAP D6			
		MOVE D6,(A1)
* Matrix(2,1) siny*cosx+cosy*sinz*sinx 
		MOVE D2,D6
		MULS D1,D6			siny*cosx
		MOVE A3,D7			sinz*sinx
		MULS D3,D7			cosy*sinz*sinx			
		ADD.L D7,D6
		ADD.L D6,D6
		SWAP D6			
		MOVE D6,M21-M11(A1)
* Matrix(3,1) -cosz*sinx
		MOVE D5,D6			cosz
		MULS D0,D6			cosz*sinx
		ADD.L D6,D6
		SWAP D6
		NEG D6				-cosz*sinx
		MOVE D6,M31-M11(A1)
* Matrix(1,2) -siny*cosz
		MOVE D2,D6			siny
		MULS D5,D6			siny*cosz
		ADD.L D6,D6
		SWAP D6
		NEG D6				-siny*cosz
		MOVE D6,M12-M11(A1)
* Matrix(2,2) cosy*cosz		
		MOVE D3,D6			cosy
		MULS D5,D6			cosy*cosz
		ADD.L D6,D6
		SWAP D6
		MOVE D6,M22-M11(A1)
* Matrix(3,2) sinz 
		MOVE D4,M32-M11(A1)
* Matrix(1,3) cosy*sinx+siny*sinz*cosx
		MOVE D3,D6			cosy
		MULS D0,D6			cosy*sinx
		MOVE A4,D7			sinz*cosx
		MULS D2,D7
		ADD.L D7,D6
		ADD.L D6,D6
		SWAP D6				siny*(sinz*cosx)
		MOVE D6,M13-M11(A1)
* Matrix(2,3) siny*sinx-cosy*sinz*cosx
		MULS D0,D2			siny*sinx
		MOVE A4,D7
		MULS D3,D7
		SUB.L D7,D2 
		ADD.L D2,D2
		SWAP D2
		MOVE D2,M23-M11(A1)
* Matrix(3,3) cosz*cosx
		MULS D1,D5 
		ADD.L D5,D5
		SWAP D5				cosz*cosx
		MOVE D5,M33-M11(A1)

; Transform and perspect co-ords.
; A5 -> x,y,z.w offsets for co-ords,D7 source co-ords x,y,z.w
; A1 -> to a storage place for the resultant x,y co-ords.
; D0-D7/A0-A4 smashed.

		MOVE (A5)+,D7			get no of verts
		LEA new_coords(PC),A1		storage place new x,y co-ords
		MOVE.L zspeed(PC),D6
Trans_verts	MOVE.L (A5)+,addoffx+2
		MOVE.L (A5)+,addoffy+2
		ADD.L D6,(A5)
		MOVE.L (A5)+,addoffz+2		(after this a5-> d7 x,y,z co-ords
		MOVEA #160,A3			centre x
		MOVEA #100,A4			centre y
		SUBQ #1,D7				verts-1
trans_lp	MOVEM.W (A5)+,D0-D2		x,y,z
		MOVE D0,D3	
		MOVE D1,D4				dup
		MOVE D2,D5
; Calculate x co-ordinate		
M11		MULS #0,D0			
M21		MULS #0,D4				mat mult
M31		MULS #0,D5
		ADD.L D4,D0
		ADD.L D5,D0
		MOVE D3,D6
		MOVE D1,D4
		MOVE D2,D5
; Calculate y co-ordinate		
M12		MULS #0,D3
M22		MULS #0,D1				mat mult
M32		MULS #0,D5
		ADD.L D3,D1
		ADD.L D5,D1
; Calculate z co-ordinate
M13		MULS #0,D6
M23		MULS #0,D4				mat mult
M33		MULS #0,D2
		ADD.L D6,D2
		ADD.L D4,D2
; Combine and Perspect
addoffx		ADD.L #0,D0
addoffy		ADD.L #0,D1
addoffz		ADD.L #0,D2
		ADD.L D2,D2
		SWAP D2
		ASR.L #8,D0
		ASR.L #8,D1
		DIVS D2,D0
		DIVS D2,D1
		ADD A3,D0				x scr centre
		ADD A4,D1				y scr centre
		MOVE D0,(A1)+			new x co-ord
		MOVE D1,(A1)+			new y co-ord
		DBF D7,trans_lp
; A5 -> total no of lines to draw. 
drawlines	MOVE (A5)+,D7
		SUBQ #1,D7
; A5 -> line list
		MOVE.L Zorro_scr2,A1
		lea	160*50(a1),a1
		LEA bit_offs(PC),A2
		LEA mul_tab,A3
		LEA new_coords(PC),A6		co-ords
drawline_lp	MOVE (A5)+,D1			;1st offset to vertex list
		MOVE (A5)+,D2			;2nd offset to vertex list
		MOVEM (A6,D1),D0-D1		;get x1,y1
		MOVEM (A6,D2),D2-D3		;"  x2,y2

Drawline	MOVE.L A1,A0
clipony		CMP.W D1,D3			; y2>=y1?(Griff superclip)!
		BGE.S y2big
		EXG D1,D3			; re-order
		EXG D0,D2
y2big		TST D3				; CLIP ON Y
		BLT	nodraw			; totally below window? <ymin
		CMP.W #ymax,D1
		BGT	nodraw			; totally above window? >ymax
		CMP.W #ymax,D3			; CLIP ON YMAX
		BLE.S okmaxy			; check that y2<=ymax 
		MOVE #ymax,D5
		SUB.W	D3,D5			; ymax-y
		MOVE.W D2,D4
		SUB.W	D0,D4			; dx=x2-x1
		MULS	D5,D4			; (ymax-y)*(x2-x1)
		MOVE.W D3,D5
		SUB.W	D1,D5			; dy
		DIVS	D5,D4			; (ymax-y)*(x2-x1)/(y2-y1)
		ADD.W	D4,D2
		MOVE #ymax,D3			; y1=0
okmaxy		TST.W	D1			; CLIP TO YMIN
		BGE.S cliponx
		MOVEQ #0,D5
		SUB.W	D1,D5			; ymin-y
		MOVE.W D2,D4
		SUB.W	D0,D4			; dx=x2-x1
		MULS	D5,D4			; (ymin-y1)*(x2-x1)
		MOVE.W D3,D5
		SUB.W	D1,D5			; dy
		DIVS	D5,D4			; (ymin-y)*(x2-x1)/(y2-y1)
		ADD.W	D4,D0
		MOVEQ #0,D1			; y1=0
cliponx		CMP.W	D0,D2			; CLIP ON X				
		BGE.S	x2big
		EXG	D0,D2			; reorder
		EXG	D1,D3
x2big		TST.W	D2			; totally outside <xmim
		BLT	nodraw
		CMP.W #xmax,D0			; totally outside >xmax
		BGT	nodraw
		CMP.W #xmax,D2			; CLIP ON XMAX
		BLE.S	okmaxx	
		MOVE.W #xmax,D5
		SUB.W	D2,D5			; xmax-x2
		MOVE.W D3,D4
		SUB.W	D1,D4			; y2-y1
		MULS D5,D4			; (xmax-x1)*(y2-y1)
		MOVE.W D2,D5
		SUB.W	D0,D5			; x2-x1
		DIVS D5,D4			; (xmax-x1)*(y2-y1)/(x2-x1)
		ADD.W	D4,D3
		MOVE.W #xmax,D2
okmaxx		TST.W	D0
		BGE.S	.gofordraw
		MOVEQ #0,D5			; CLIP ON XMIN
		SUB.W	D0,D5			; xmin-x
		MOVE.W D3,D4
		SUB.W	D1,D4			; y2-y1
		MULS D5,D4			; (xmin-x)*(y2-y1)
		MOVE.W D2,D5
		SUB.W	D0,D5			; x2-x1
		DIVS D5,D4			; (xmin-x)*(y2-y1)/(x2-x1)
		ADD.W	D4,D1
		MOVEQ #0,D0			; x=xmin
.gofordraw	MOVE.W D2,D4
		SUB.W	D0,D4			; dx
		MOVE.W D3,D5
		SUB.W	D1,D5			; dy
		ADD D2,D2
		ADD D2,D2
		MOVE.L (A2,D2),D6		; mask/chunk offset
		ADD D3,D3
		ADD (A3,D3),D6			; add scr line
		ADDA.W D6,A0			; a0 -> first chunk of line
		SWAP D6				; get mask
		MOVE.W #-160,D3
		TST.W	D5			; draw from top to bottom?
		BGE.S	bottotop
		NEG.W	D5			; no so negate vals
		NEG.W	D3
bottotop	CMP.W	D4,D5			; dy>dx?
		BLT.S	dxbiggerdy

dybiggerdx	MOVE.W D5,D1			; yes!
		BEQ.s nodraw			; dy=0 nothing to draw(!)
		ASR.W	#1,D1			; e=2/dy
		MOVE.W D5,D2
		SUBQ.W #1,D2			; lines to draw-1(dbf)
.lp		OR.W D6,(A0)
		ADDA.W D3,A0
		SUB.W	D4,D1
		BGT.S	.nostep
		ADD.W	D5,D1
		ADD.W	D6,D6
		DBCS D2,.lp
		BCC.S .drawn
		SUBQ.W #8,A0
		MOVEQ	#1,D6
.nostep		DBF D2,.lp
.drawn		OR.W	D6,(A0)
nodraw		DBF D7,drawline_lp
		RTS

dxbiggerdy	CLR.W	D2
		MOVE.W D4,D1
		ASR.W	#1,D1			; e=2/dx
		MOVE.W D4,D0
		SUBQ.W #1,D0
.lp		OR.W	D6,D2
		SUB.W	D5,D1
		BGE.S	.nostep
		OR.W D2,(A0)
		ADDA.W D3,A0
		ADD.W	D4,D1
		CLR.W	D2
.nostep		ADD.W	D6,D6
		DBCS	D0,.lp
		BCC.S	.drawn
.wrchnk		OR.W	D2,(A0)
		SUBQ.W #8,A0
		CLR.W	D2
		MOVEQ	#1,D6
		DBF	D0,.lp
.drawn		OR.W D6,D2
		OR.W	D2,(A0)
		DBF D7,drawline_lp
		RTS

; Create *160 table

create160tb
		LEA mul_tab,A0
		MOVEQ #0,D0					;create *160 table
		MOVE #199,D1
mke_t160_lp	MOVE D0,(A0)+
		ADD #160,D0
		DBF D1,mke_t160_lp
		RTS

* Clear last plane of screen - reasonably quickly...
NB_LIGNE_GENERE	equ	199
NB_BLOC_SUPP	equ	15
PLAN_CLS	equ	6

Genere_code:
	lea Code_gen,a0
	move.w	#NB_LIGNE_GENERE,d7
	moveq	#0,d4
Genere_pour_toutes_les_lignes:	
	moveq	#NB_BLOC_SUPP,d6
	move.w	d4,d5
	add.w	#(2*8)+PLAN_CLS,d5 * position du cadre
Genere_une_ligne:
	move.w	#$3140,(a0)+		 * Genere un move.w  d0,$xx(a0)
	move.w	d5,(a0)+				 * et voila l'offset $xx
	addq.w	#8,d5            * pixel suivant
	dbra	d6,Genere_une_ligne
	add.w	#160,d4            * ligne suivante
	dbra	d7,Genere_pour_toutes_les_lignes
	move.w	#$4e75,(a0)			 * Et un RTS !!
	rts
							
; --------------------------------------------------------------
;
;                        SCROLLTEXT
;
; --------------------------------------------------------------

SCROLL:
	lea	BUFF_P3,a0
	rept	8
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	lea	84(a0),a0
	endr
	rts

SCROLLING:	
	bsr	SCROLL		
	bsr	SCROLL
	addi.b	#1,TAMPON
	cmpi.b	#4,TAMPON
	bne.s	.put_car
	clr.b	TAMPON
	movea.l	PTR_TEXTE,a0
	moveq	#0,d0
	move.b	(a0)+,d0
	tst.b	d0
	bpl.s	.not_end
	lea	TEXTE,a0
	move.b	(a0)+,d0
.not_end:
	move.l	a0,PTR_TEXTE
	lea	FONT8_8,a0
	adda.w	d0,a0
	lea	BUFF_P2,a1
	move.b	(a0),(a1)
	move.b	256(a0),42(a1)
	move.b	512(a0),84(a1)
	move.b	768(a0),126(a1)
	move.b	1024(a0),168(a1)
	move.b	1280(a0),210(a1)
	move.b	1536(a0),252(a1)
	move.b	1792(a0),294(a1)
.put_car:
	lea	BUFF_P1,a0
	movea.l	Zorro_scr2,a1
	lea	((160*200)+2)(a1),a1
	moveq	#7,d0
.loop:
a set 0
	rept 20
	move.w	(a0)+,a(a1)
a set a+8
	endr	
	lea	160(a1),a1
	addq.w	#2,a0
	dbf	d0,.loop
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

PATTERN		equ	$0

Efface_Zorro_scr1:	
	movea.l	Zorro_scr1,a6
	move.w	#Zorro_screen1_len/4-1,d1
.fill:
	move.l	#PATTERN,(a6)+
	dbra	d1,.fill
	RTS
	
Efface_Zorro_scr2:
	movea.l	Zorro_scr2,a6
	move.w	#Zorro_screen2_len/4-1,d1
.fill:
	move.l	#PATTERN,(a6)+
	dbra	d1,.fill
	RTS

fadein
	move.l	#$777,d0
deg:
	rept	3
	bsr.s	wart
	endr
	lea	$ffff8240.w,a0
	moveq	#15,d1
chg1:	move.w	d0,(a0)+
	dbf	d1,chg1
	sub.w	#$111,d0
	bne.s	deg
	rts

wart
	move.l	d0,-(sp)
	move.l	$466.w,d0
att:	cmp.l	$466.w,d0
	beq.s	att
	move.l	(sp)+,d0
	rts
	
******************************************************************

	SECTION	DATA

Pal:	
	dc.w	$0000,$0002,$080A,$0103,$0203,$0556,$0204,$0001
	dc.w	$0324,$0314,$0425,$0008,$0546,$0435,$0B27,$0FFF

PalBsw0:
	dc.w	$0000,$0655,$0B8A,$0643,$0202,$0101,$0666,$0611
  dc.w	$0DA9,$0302,$0A8A,$0500,$0401,$0400,$0402,$0908	

PalBsw1:
	dc.w	$0000,$0224,$0556,$0777,$0113,$0335,$0446,$0776
  dc.w	$0556,$0112,$0667,$0665,$0544,$0332,$0221,$0443

Palnoir:
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

bit_offs
i		SET 6
		REPT 20
		DC.W $8000,i
		DC.W $4000,i
		DC.W $2000,i
		DC.W $1000,i
		DC.W $0800,i
		DC.W $0400,i
		DC.W $0200,i
		DC.W $0100,i
		DC.W $0080,i
		DC.W $0040,i
		DC.W $0020,i
		DC.W $0010,i
		DC.W $0008,i
		DC.W $0004,i
		DC.W $0002,i
		DC.W $0001,i
i		SET i+8
		ENDR

new_coords	DS.W 200

zspeed		dc.l 0

; Sequence data 
		
		RSRESET

seq_timer	RS.W 1
seq_ptr		RS.L 1
addangx		RS.W 1
addangy		RS.W 1
addangz		RS.W 1
restart_ptr	RS.L 1

seqdata
		DC.W 1
		DC.L sequence 
		DS.W 3
		DC.L restart
		DC.W -1

sequence	DC.W 140	* timer
		DC.W 8		* add angle X
		DC.W 12		* add angle Y
		DC.W 8		* add angle Z
		DC.W -31	* speed Z
restart		
		DC.W 256,0,12,12,0
		DC.W 128,12,12,0,0
		DC.W 256,8,0,8,0
		DC.W 128,24,0,0,0
		DC.W 30,4,0,0,10
		DC.W 30,4,0,0,-10
		DC.W 128,18,18,18,0
		DC.W 256,14,14,14,0
		DC.W 128,10,10,10,0
		DC.W 128,0,12,12,0
		DC.W 128,20,20,20,0
		DC.W 128,0,24,24,0
		DC.W -1

BSW		Dc.W 0,1024,0
		DC.W 37+1		*	nb de point apres...
		DC.L 0,0,$1200*65536

.bP	dc.w	-400+25+25,100,0;1
	dc.w	-400+25+25,-80,0;2
	dc.w	-200+25,-80,0	;3
	dc.w	-150+25,-40,0	;4
	dc.w	-150+25,40,0	;5
	dc.w	-200+25,80,0	;6
	dc.w	-300+25,80,0	;7
	dc.w	-300+25,100,0	;8
	dc.w	-350+25+25,50,0	;9
	dc.w	-350+25+25,-50,0;10
	dc.w	-250+25+25,-50,0;11
	dc.w	-250+25+25,50,0	;12
.sP	dc.w	-125+25,-30,0	;13
	dc.w	-125+25,-80,0	;14
	dc.w	125-25,-80,0	;15
	dc.w	125-25,20,0	;16
	dc.w	0,20,0		;17
	dc.w	0,60,0		;18
	dc.w	50,60,0		;19
	dc.w	50,40,0		;20
	dc.w	125-25,40,0	;21
	dc.w	125-25,80,0	;22
	dc.w	-50,80,0	;23
	dc.w	-50,0,0		;24
	dc.w	50,0,0		;25
	dc.w	50,-60,0	;26
	dc.w	-50,-60,0	;27
	dc.w	-50,-30,0	;28
.wP	dc.w	150-25,80,0	;29
	dc.w	150-25,-80,0	;30
	dc.w	275-25-25,0,0	;31
	dc.w	400-25-25-25,-80,0	;32
	dc.w	400-25-25-25,80,0	;33
	dc.w	325-25-25,80,0	;34
	dc.w	325-25-25,0,0	;35
	dc.w	275-25-25,30,0	;36
	dc.w	225-25-25,0,0	;37
	dc.w	225-25-25,80,0	;38

		DC.W 37+1		*	nb de ligne apres...

.bL	dc.w	00*4,01*4
	dc.w	01*4,02*4
	dc.w	02*4,03*4
	dc.w	03*4,04*4
	dc.w	04*4,05*4
	dc.w	05*4,06*4
	dc.w	06*4,07*4
	dc.w	07*4,00*4		*B
	dc.w	08*4,09*4
	dc.w	09*4,10*4
	dc.w	10*4,11*4
	dc.w	11*4,08*4		*CARRE
.sL	dc.w	12*4,13*4
	dc.w	13*4,14*4
	dc.w	14*4,15*4
	dc.w	15*4,16*4
	dc.w	16*4,17*4
	dc.w	17*4,18*4
	dc.w	18*4,19*4
	dc.w	19*4,20*4
	dc.w	20*4,21*4
	dc.w	21*4,22*4
	dc.w	22*4,23*4
	dc.w	23*4,24*4
	dc.w	24*4,25*4
	dc.w	25*4,26*4
	dc.w	26*4,27*4
	dc.w	27*4,12*4		*S
.wL	dc.w	28*4,29*4
	dc.w	29*4,30*4
	dc.w	30*4,31*4
	dc.w	31*4,32*4
	dc.w	32*4,33*4
	dc.w	33*4,34*4
	dc.w	34*4,35*4
	dc.w	35*4,36*4
	dc.w	36*4,37*4
	dc.w	37*4,28*4		*W
	
IMG_TITLE:
		dc.w	$0000,$0000,$0000,$0000,$0003,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0001,$FFF0,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0001,$FFF0,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$6063,$0000,$0000,$0000,$E320,$0000,$0000
		dc.w	$0000,$3FF0,$0000,$0000,$0000,$3060,$0000,$0000
		dc.w	$0000,$2023,$0000,$0000,$0000,$3060,$0000,$0000
		dc.w	$0000,$603F,$0000,$0000,$0000,$E060,$0000,$0000
		dc.w	$0000,$6030,$0000,$0000,$0000,$2023,$0000,$0000
		dc.w	$0000,$2030,$0000,$0000,$0000,$3FE0,$0000,$0000
		dc.w	$0000,$7060,$0000,$0000,$0000,$7FF2,$0000,$0000
		dc.w	$0000,$7860,$0000,$0000,$0001,$6030,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$6323,$0000,$0000,$0000,$E323,$0000,$0000
		dc.w	$0000,$FFE3,$0000,$0000,$0000,$E323,$0000,$0000
		dc.w	$0000,$F8E3,$0000,$0000,$0000,$2323,$0000,$0000
		dc.w	$0000,$23FF,$0000,$0000,$0000,$E323,$0000,$0000
		dc.w	$0000,$23E3,$0000,$0000,$0000,$E3E1,$0000,$0000
		dc.w	$0000,$38E3,$0000,$0000,$0000,$FFE3,$0000,$0000
		dc.w	$0000,$2323,$0000,$0000,$0000,$3FE0,$0000,$0000
		dc.w	$0000,$307E,$0000,$0000,$0001,$3E70,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$6063,$0000,$0000,$0000,$E320,$0000,$0000
		dc.w	$0000,$FFF0,$0000,$0000,$0000,$6320,$0000,$0000
		dc.w	$0000,$F8E1,$0000,$0000,$0000,$2020,$0000,$0000
		dc.w	$0000,$60FF,$0000,$0000,$0000,$E060,$0000,$0000
		dc.w	$0000,$60F0,$0000,$0000,$0000,$60E2,$0000,$0000
		dc.w	$0000,$38F0,$0000,$0000,$0000,$7FE3,$0000,$0000
		dc.w	$0000,$23E3,$0000,$0000,$0000,$3FF2,$0000,$0000
		dc.w	$0000,$7C78,$0000,$0000,$0001,$3CF0,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$6323,$0000,$0000,$0000,$E323,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$2323,$0000,$0000
		dc.w	$0000,$F8E2,$0000,$0000,$0000,$2323,$0000,$0000
		dc.w	$0000,$23FF,$0000,$0000,$0000,$E3E3,$0000,$0000
		dc.w	$0000,$23FF,$0000,$0000,$0000,$23E3,$0000,$0000
		dc.w	$0000,$38FF,$0000,$0000,$0000,$3FE3,$0000,$0000
		dc.w	$0000,$2323,$0000,$0000,$0000,$3FE0,$0000,$0000
		dc.w	$0000,$3C7E,$0000,$0000,$0001,$38F0,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$6060,$0000,$0000,$0000,$3060,$0000,$0000
		dc.w	$0000,$3FE0,$0000,$0000,$0000,$7063,$0000,$0000
		dc.w	$0000,$F8E7,$0000,$0000,$0000,$2323,$0000,$0000
		dc.w	$0000,$203F,$0000,$0000,$0000,$E3E3,$0000,$0000
		dc.w	$0000,$2020,$0000,$0000,$0000,$6023,$0000,$0000
		dc.w	$0000,$38E0,$0000,$0000,$0000,$7FE0,$0000,$0000
		dc.w	$0000,$7060,$0000,$0000,$0000,$7FF2,$0000,$0000
		dc.w	$0000,$7C60,$0000,$0000,$0001,$78F0,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0001,$FFF0,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$7FFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0001,$FFF0,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1FC7,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$001F,$0000,$0000,$0000,$DFDF,$0000,$0000
		dc.w	$0000,$DF9C,$0000,$0000,$0000,$CF9F,$0000,$0000
		dc.w	$0000,$DCC0,$0000,$0000,$0000,$0FCF,$0000,$0000
		dc.w	$0000,$98DF,$0000,$0000,$0000,$9C1F,$0000,$0000
		dc.w	$0000,$C00F,$0000,$0000,$0000,$9CDF,$0000,$0000
		dc.w	$0000,$DF8F,$0000,$0000,$0000,$CF8F,$0000,$0000
		dc.w	$0000,$9CC0,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C0F,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$071C,$0000,$0000
		dc.w	$0000,$1CDE,$0000,$0000,$0000,$C707,$0000,$0000
		dc.w	$0000,$1CC0,$0000,$0000,$0000,$1C1C,$0000,$0000
		dc.w	$0000,$DDDC,$0000,$0000,$0000,$DC1C,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$1CDC,$0000,$0000,$0000,$1CDC,$0000,$0000
		dc.w	$0000,$DEC0,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1F03,$0000,$0000,$0000,$800F,$0000,$0000
		dc.w	$0000,$801F,$0000,$0000,$0000,$071F,$0000,$0000
		dc.w	$0000,$1F9D,$0000,$0000,$0000,$C707,$0000,$0000
		dc.w	$0000,$0F80,$0000,$0000,$0000,$0F9F,$0000,$0000
		dc.w	$0000,$DEDF,$0000,$0000,$0000,$9C1F,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$DCDF,$0000,$0000
		dc.w	$0000,$1F8F,$0000,$0000,$0000,$9C1F,$0000,$0000
		dc.w	$0000,$DDC0,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C03,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$071C,$0000,$0000
		dc.w	$0000,$1CDC,$0000,$0000,$0000,$C707,$0000,$0000
		dc.w	$0000,$0700,$0000,$0000,$0000,$00DC,$0000,$0000
		dc.w	$0000,$DCDC,$0000,$0000,$0000,$1C1C,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$CD9C,$0000,$0000
		dc.w	$0000,$1CC0,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$DCC0,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C03,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$001F,$0000,$0000,$0000,$C71F,$0000,$0000
		dc.w	$0000,$DCDC,$0000,$0000,$0000,$CF87,$0000,$0000
		dc.w	$0000,$0700,$0000,$0000,$0000,$1F9C,$0000,$0000
		dc.w	$0000,$DCDC,$0000,$0000,$0000,$1FDF,$0000,$0000
		dc.w	$0000,$C00F,$0000,$0000,$0000,$871F,$0000,$0000
		dc.w	$0000,$DCDF,$0000,$0000,$0000,$8F9C,$0000,$0000
		dc.w	$0000,$DCC0,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$000F,$0000,$0000,$0000,$CF9F,$0000,$0000
		dc.w	$0000,$9FDF,$0000,$0000,$0000,$DCC0,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$1CDC,$0000,$0000
		dc.w	$0000,$DC1C,$0000,$0000,$0000,$1EC0,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$000F,$0000,$0000,$0000,$9C1F,$0000,$0000
		dc.w	$0000,$9F1F,$0000,$0000,$0000,$1DC0,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$DC1C,$0000,$0000,$0000,$1CC0,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$001F,$0000,$0000,$0000,$8F9C,$0000,$0000
		dc.w	$0000,$DFDF,$0000,$0000,$0000,$DCC0,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1FCF,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$001F,$0000,$0000,$0000,$CF9C,$0000,$0000
		dc.w	$0000,$CF9F,$0000,$0000,$0000,$CF8F,$0000,$0000
		dc.w	$0000,$8FC0,$0000,$0000,$0000,$1F9F,$0000,$0000
		dc.w	$0000,$DCDF,$0000,$0000,$0000,$DF8F,$0000,$0000
		dc.w	$0000,$8000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C00,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$1CDE,$0000,$0000
		dc.w	$0000,$DCC7,$0000,$0000,$0000,$071C,$0000,$0000
		dc.w	$0000,$DC00,$0000,$0000,$0000,$1CDC,$0000,$0000
		dc.w	$0000,$1EC7,$0000,$0000,$0000,$1CDC,$0000,$0000
		dc.w	$0000,$C000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1F0F,$0000,$0000,$0000,$800F,$0000,$0000
		dc.w	$0000,$801F,$0000,$0000,$0000,$1FDD,$0000,$0000
		dc.w	$0000,$DFC7,$0000,$0000,$0000,$071C,$0000,$0000
		dc.w	$0000,$0F80,$0000,$0000,$0000,$1CDF,$0000,$0000
		dc.w	$0000,$1DC7,$0000,$0000,$0000,$1F9C,$0000,$0000
		dc.w	$0000,$C000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C1C,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$1CDC,$0000,$0000
		dc.w	$0000,$DCC7,$0000,$0000,$0000,$071C,$0000,$0000
		dc.w	$0000,$C0C0,$0000,$0000,$0000,$1CDC,$0000,$0000
		dc.w	$0000,$1CC7,$0000,$0000,$0000,$1CDC,$0000,$0000
		dc.w	$0000,$C000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C1F,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$1CDC,$0000,$0000
		dc.w	$0000,$DCC7,$0000,$0000,$0000,$0F8F,$0000,$0000
		dc.w	$0000,$9F80,$0000,$0000,$0000,$1F9F,$0000,$0000
		dc.w	$0000,$DCC7,$0000,$0000,$0000,$1CCF,$0000,$0000
		dc.w	$0000,$8000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1FDF,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$000F,$0000,$0000,$0000,$9CDF,$0000,$0000
		dc.w	$0000,$DC0F,$0000,$0000,$0000,$9CDF,$0000,$0000
		dc.w	$0000,$C00F,$0000,$0000,$0000,$8F8F,$0000,$0000
		dc.w	$0000,$9F80,$0000,$0000,$0000,$0F9C,$0000,$0000
		dc.w	$0000,$DCCF,$0000,$0000,$0000,$9FDF,$0000,$0000
		dc.w	$0000,$8F80,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C01,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$DCC7,$0000,$0000
		dc.w	$0000,$1C07,$0000,$0000,$0000,$1EDC,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$DDDD,$0000,$0000
		dc.w	$0000,$DC00,$0000,$0000,$0000,$071E,$0000,$0000
		dc.w	$0000,$DCC7,$0000,$0000,$0000,$071C,$0000,$0000
		dc.w	$0000,$DCC0,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1F07,$0000,$0000,$0000,$C00F,$0000,$0000
		dc.w	$0000,$801C,$0000,$0000,$0000,$DCC7,$0000,$0000
		dc.w	$0000,$1C07,$0000,$0000,$0000,$1DDF,$0000,$0000
		dc.w	$0000,$000F,$0000,$0000,$0000,$9EDE,$0000,$0000
		dc.w	$0000,$DF80,$0000,$0000,$0000,$071D,$0000,$0000
		dc.w	$0000,$DCC7,$0000,$0000,$0000,$071F,$0000,$0000
		dc.w	$0000,$9CC0,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C01,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$DCC7,$0000,$0000
		dc.w	$0000,$1C07,$0000,$0000,$0000,$1CDC,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$1CDC,$0000,$0000
		dc.w	$0000,$C1C0,$0000,$0000,$0000,$071C,$0000,$0000
		dc.w	$0000,$CD87,$0000,$0000,$0000,$071C,$0000,$0000
		dc.w	$0000,$DCC0,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C1F,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$000F,$0000,$0000,$0000,$8F87,$0000,$0000
		dc.w	$0000,$1FCF,$0000,$0000,$0000,$9CDF,$0000,$0000
		dc.w	$0000,$C01F,$0000,$0000,$0000,$CF8F,$0000,$0000
		dc.w	$0000,$9F80,$0000,$0000,$0000,$0F9C,$0000,$0000
		dc.w	$0000,$C70F,$0000,$0000,$0000,$871C,$0000,$0000
		dc.w	$0000,$CF80,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1FDD,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$001F,$0000,$0000,$0000,$8F9F,$0000,$0000
		dc.w	$0000,$8F8F,$0000,$0000,$0000,$8F9C,$0000,$0000
		dc.w	$0000,$C00F,$0000,$0000,$0000,$800F,$0000,$0000
		dc.w	$0000,$9CDC,$0000,$0000,$0000,$CF9F,$0000,$0000
		dc.w	$0000,$DF8F,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C1D,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$DCDC,$0000,$0000,$0000,$DCDE,$0000,$0000
		dc.w	$0000,$C01C,$0000,$0000,$0000,$0007,$0000,$0000
		dc.w	$0000,$1EDC,$0000,$0000,$0000,$C707,$0000,$0000
		dc.w	$0000,$1CDC,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1F1F,$0000,$0000,$0000,$C00F,$0000,$0000
		dc.w	$0000,$801F,$0000,$0000,$0000,$9FDF,$0000,$0000
		dc.w	$0000,$9FDC,$0000,$0000,$0000,$1CDD,$0000,$0000
		dc.w	$0000,$C01F,$0000,$0000,$0000,$8007,$0000,$0000
		dc.w	$0000,$1DDC,$0000,$0000,$0000,$C707,$0000,$0000
		dc.w	$0000,$1F9C,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C01,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$1CDC,$0000,$0000
		dc.w	$0000,$DCDC,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$C01C,$0000,$0000,$0000,$C007,$0000,$0000
		dc.w	$0000,$1CCD,$0000,$0000,$0000,$8707,$0000,$0000
		dc.w	$0000,$1CDC,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C01,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$1CDC,$0000,$0000
		dc.w	$0000,$DCCF,$0000,$0000,$0000,$8F9C,$0000,$0000
		dc.w	$0000,$C00F,$0000,$0000,$0000,$800F,$0000,$0000
		dc.w	$0000,$9CC7,$0000,$0000,$0000,$0F87,$0000,$0000
		dc.w	$0000,$1CCF,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1FDF,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$001F,$0000,$0000,$0000,$9FDC,$0000,$0000
		dc.w	$0000,$DFCF,$0000,$0000,$0000,$8003,$0000,$0000
		dc.w	$0000,$0F80,$0000,$0000,$0000,$1CDF,$0000,$0000
		dc.w	$0000,$DCC0,$0000,$0000,$0000,$0FCF,$0000,$0000
		dc.w	$0000,$98DF,$0000,$0000,$0000,$C01F,$0000,$0000
		dc.w	$0000,$DF8F,$0000,$0000,$0000,$98C0,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C1C,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$DC1E,$0000,$0000
		dc.w	$0000,$C71C,$0000,$0000,$0000,$C006,$0000,$0000
		dc.w	$0000,$1CC0,$0000,$0000,$0000,$1EDC,$0000,$0000
		dc.w	$0000,$1CC0,$0000,$0000,$0000,$1C1C,$0000,$0000
		dc.w	$0000,$DDDC,$0000,$0000,$0000,$001C,$0000,$0000
		dc.w	$0000,$1CDC,$0000,$0000,$0000,$DDC0,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1F1F,$0000,$0000,$0000,$800F,$0000,$0000
		dc.w	$0000,$801F,$0000,$0000,$0000,$9F1D,$0000,$0000
		dc.w	$0000,$C71F,$0000,$0000,$0000,$C006,$0000,$0000
		dc.w	$0000,$1FC0,$0000,$0000,$0000,$1DDF,$0000,$0000
		dc.w	$0000,$1EC0,$0000,$0000,$0000,$1DDF,$0000,$0000
		dc.w	$0000,$DEDF,$0000,$0000,$0000,$001F,$0000,$0000
		dc.w	$0000,$1F9C,$0000,$0000,$0000,$DEC0,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C01,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$1C1C,$0000,$0000
		dc.w	$0000,$C71C,$0000,$0000,$0000,$C006,$0000,$0000
		dc.w	$0000,$1CC0,$0000,$0000,$0000,$1CDC,$0000,$0000
		dc.w	$0000,$1DC0,$0000,$0000,$0000,$1CDC,$0000,$0000
		dc.w	$0000,$DCDC,$0000,$0000,$0000,$001C,$0000,$0000
		dc.w	$0000,$1CDC,$0000,$0000,$0000,$DCC0,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C1F,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$1FDC,$0000,$0000
		dc.w	$0000,$C71C,$0000,$0000,$0000,$C003,$0000,$0000
		dc.w	$0000,$1CC0,$0000,$0000,$0000,$1CDF,$0000,$0000
		dc.w	$0000,$D8C0,$0000,$0000,$0000,$0FDC,$0000,$0000
		dc.w	$0000,$DCDF,$0000,$0000,$0000,$C01C,$0000,$0000
		dc.w	$0000,$1CCF,$0000,$0000,$0000,$9CC0,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$001F,$0000,$0000,$0000,$8F9F,$0000,$0000
		dc.w	$0000,$8F9F,$0000,$0000,$0000,$8F9F,$0000,$0000
		dc.w	$0000,$DFC6,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$DCDC,$0000,$0000,$0000,$C703,$0000,$0000
		dc.w	$0000,$9C03,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$001F,$0000,$0000,$0000,$9FDF,$0000,$0000
		dc.w	$0000,$9FDC,$0000,$0000,$0000,$C707,$0000,$0000
		dc.w	$0000,$1F03,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$1CDC,$0000,$0000
		dc.w	$0000,$DCDC,$0000,$0000,$0000,$C70E,$0000,$0000
		dc.w	$0000,$1C03,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$1CDC,$0000,$0000
		dc.w	$0000,$DCDF,$0000,$0000,$0000,$8F9F,$0000,$0000
		dc.w	$0000,$DFC6,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1FCF,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$0000,$CF8F,$0000,$0000
		dc.w	$0000,$DCCF,$0000,$0000,$0000,$9F80,$0000,$0000
		dc.w	$0000,$0F8F,$0000,$0000,$0000,$9CDC,$0000,$0000
		dc.w	$0000,$DFDC,$0000,$0000,$0000,$CF8F,$0000,$0000
		dc.w	$0000,$9CC0,$0000,$0000,$0000,$0F8F,$0000,$0000
		dc.w	$0000,$8F9F,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C1C,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$1CDC,$0000,$0000,$0000,$DCC0,$0000,$0000
		dc.w	$0000,$1CDC,$0000,$0000,$0000,$DEDE,$0000,$0000
		dc.w	$0000,$DC1C,$0000,$0000,$0000,$C71C,$0000,$0000
		dc.w	$0000,$DEC0,$0000,$0000,$0000,$00DD,$0000,$0000
		dc.w	$0000,$DDDC,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1F1F,$0000,$0000,$0000,$800F,$0000,$0000
		dc.w	$0000,$8001,$0000,$0000,$0000,$DFDD,$0000,$0000
		dc.w	$0000,$DCDF,$0000,$0000,$0000,$DF80,$0000,$0000
		dc.w	$0000,$1C1C,$0000,$0000,$0000,$DDDD,$0000,$0000
		dc.w	$0000,$DF0F,$0000,$0000,$0000,$871C,$0000,$0000
		dc.w	$0000,$DDC0,$0000,$0000,$0000,$0F9E,$0000,$0000
		dc.w	$0000,$DEDF,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C1C,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$001D,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$DCDC,$0000,$0000,$0000,$DCC0,$0000,$0000
		dc.w	$0000,$1CDC,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$DC1C,$0000,$0000,$0000,$C71C,$0000,$0000
		dc.w	$0000,$DCC0,$0000,$0000,$0000,$1C1C,$0000,$0000
		dc.w	$0000,$DCC1,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C0F,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$000F,$0000,$0000,$0000,$9CCF,$0000,$0000
		dc.w	$0000,$CF9C,$0000,$0000,$0000,$DCC0,$0000,$0000
		dc.w	$0000,$0F8F,$0000,$0000,$0000,$9CDC,$0000,$0000
		dc.w	$0000,$DFDC,$0000,$0000,$0000,$CF8F,$0000,$0000
		dc.w	$0000,$9CC0,$0000,$0000,$0000,$1FCF,$0000,$0000
		dc.w	$0000,$8F9F,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$000F,$0000,$0000,$0000,$9CDC,$0000,$0000
		dc.w	$0000,$CF9F,$0000,$0000,$0000,$DF8F,$0000,$0000
		dc.w	$0000,$8003,$0000,$0000,$0000,$1FDC,$0000,$0000
		dc.w	$0000,$CFDC,$0000,$0000,$0000,$0F8F,$0000,$0000
		dc.w	$0000,$DCC6,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0007,$0000,$0000,$0000,$1EDC,$0000,$0000
		dc.w	$0000,$C707,$0000,$0000,$0000,$1CDC,$0000,$0000
		dc.w	$0000,$C006,$0000,$0000,$0000,$1C1E,$0000,$0000
		dc.w	$0000,$DC1C,$0000,$0000,$0000,$071C,$0000,$0000
		dc.w	$0000,$1CC3,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0007,$0000,$0000,$0000,$1DDC,$0000,$0000
		dc.w	$0000,$C707,$0000,$0000,$0000,$1F9C,$0000,$0000
		dc.w	$0000,$C006,$0000,$0000,$0000,$1F1D,$0000,$0000
		dc.w	$0000,$DDDC,$0000,$0000,$0000,$070F,$0000,$0000
		dc.w	$0000,$9FC3,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0007,$0000,$0000,$0000,$1CCD,$0000,$0000
		dc.w	$0000,$8707,$0000,$0000,$0000,$1CDC,$0000,$0000
		dc.w	$0000,$C006,$0000,$0000,$0000,$1C1C,$0000,$0000
		dc.w	$0000,$DCDC,$0000,$0000,$0000,$0700,$0000,$0000
		dc.w	$0000,$DCC3,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$000F,$0000,$0000,$0000,$9CC7,$0000,$0000
		dc.w	$0000,$0F87,$0000,$0000,$0000,$1CCF,$0000,$0000
		dc.w	$0000,$8003,$0000,$0000,$0000,$1FDC,$0000,$0000
		dc.w	$0000,$CFDF,$0000,$0000,$0000,$CF9F,$0000,$0000
		dc.w	$0000,$9CC6,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1FDF,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$0000,$CF8F,$0000,$0000
		dc.w	$0000,$DCCF,$0000,$0000,$0000,$9F80,$0000,$0000
		dc.w	$0000,$0F8F,$0000,$0000,$0000,$9CDC,$0000,$0000
		dc.w	$0000,$DFDC,$0000,$0000,$0000,$CF8F,$0000,$0000
		dc.w	$0000,$9CC0,$0000,$0000,$0000,$0F8F,$0000,$0000
		dc.w	$0000,$8F9F,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C01,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$0001,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$1CDC,$0000,$0000,$0000,$DCC0,$0000,$0000
		dc.w	$0000,$1CDC,$0000,$0000,$0000,$DEDE,$0000,$0000
		dc.w	$0000,$DC1C,$0000,$0000,$0000,$C71C,$0000,$0000
		dc.w	$0000,$DEC0,$0000,$0000,$0000,$00DD,$0000,$0000
		dc.w	$0000,$DDDC,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1F03,$0000,$0000,$0000,$000F,$0000,$0000
		dc.w	$0000,$8001,$0000,$0000,$0000,$DFDD,$0000,$0000
		dc.w	$0000,$DCDF,$0000,$0000,$0000,$DF80,$0000,$0000
		dc.w	$0000,$1C1C,$0000,$0000,$0000,$DDDD,$0000,$0000
		dc.w	$0000,$DF0F,$0000,$0000,$0000,$871C,$0000,$0000
		dc.w	$0000,$DDC0,$0000,$0000,$0000,$0F9E,$0000,$0000
		dc.w	$0000,$DEDF,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C07,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$001D,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$DCDC,$0000,$0000,$0000,$DCC0,$0000,$0000
		dc.w	$0000,$1CDC,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$DC1C,$0000,$0000,$0000,$C71C,$0000,$0000
		dc.w	$0000,$DCC0,$0000,$0000,$0000,$1C1C,$0000,$0000
		dc.w	$0000,$DCC1,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C07,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$000F,$0000,$0000,$0000,$9CCF,$0000,$0000
		dc.w	$0000,$CF9C,$0000,$0000,$0000,$DCC0,$0000,$0000
		dc.w	$0000,$0F8F,$0000,$0000,$0000,$9CDC,$0000,$0000
		dc.w	$0000,$DFDC,$0000,$0000,$0000,$CF8F,$0000,$0000
		dc.w	$0000,$9CC0,$0000,$0000,$0000,$1FCF,$0000,$0000
		dc.w	$0000,$8F9F,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$000F,$0000,$0000,$0000,$9CDC,$0000,$0000
		dc.w	$0000,$CF9F,$0000,$0000,$0000,$DF8F,$0000,$0000
		dc.w	$0000,$8003,$0000,$0000,$0000,$1FDF,$0000,$0000
		dc.w	$0000,$9FDC,$0000,$0000,$0000,$CF9C,$0000,$0000
		dc.w	$0000,$C600,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0007,$0000,$0000,$0000,$1EDC,$0000,$0000
		dc.w	$0000,$C707,$0000,$0000,$0000,$1CDC,$0000,$0000
		dc.w	$0000,$C006,$0000,$0000,$0000,$1C1C,$0000,$0000
		dc.w	$0000,$DC1E,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$C300,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0007,$0000,$0000,$0000,$1DDC,$0000,$0000
		dc.w	$0000,$C707,$0000,$0000,$0000,$1F9C,$0000,$0000
		dc.w	$0000,$C006,$0000,$0000,$0000,$1F1F,$0000,$0000
		dc.w	$0000,$9F1D,$0000,$0000,$0000,$DC1F,$0000,$0000
		dc.w	$0000,$C300,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0007,$0000,$0000,$0000,$1CCD,$0000,$0000
		dc.w	$0000,$8707,$0000,$0000,$0000,$1CDC,$0000,$0000
		dc.w	$0000,$C006,$0000,$0000,$0000,$1C1C,$0000,$0000
		dc.w	$0000,$DC1C,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$C300,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$000F,$0000,$0000,$0000,$9CC7,$0000,$0000
		dc.w	$0000,$0F87,$0000,$0000,$0000,$1CCF,$0000,$0000
		dc.w	$0000,$8003,$0000,$0000,$0000,$1C1C,$0000,$0000
		dc.w	$0000,$DFDC,$0000,$0000,$0000,$CF9C,$0000,$0000
		dc.w	$0000,$C600,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1FCF,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$001F,$0000,$0000,$0000,$CF80,$0000,$0000
		dc.w	$0000,$0F9C,$0000,$0000,$0000,$DFDF,$0000,$0000
		dc.w	$0000,$8F80,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C1C,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$0007,$0000,$0000,$0000,$00C0,$0000,$0000
		dc.w	$0000,$071E,$0000,$0000,$0000,$C71C,$0000,$0000
		dc.w	$0000,$DCC0,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1F0F,$0000,$0000,$0000,$800F,$0000,$0000
		dc.w	$0000,$8007,$0000,$0000,$0000,$0F80,$0000,$0000
		dc.w	$0000,$071D,$0000,$0000,$0000,$C71F,$0000,$0000
		dc.w	$0000,$9CC0,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C1C,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$0007,$0000,$0000,$0000,$1C00,$0000,$0000
		dc.w	$0000,$071C,$0000,$0000,$0000,$C71C,$0000,$0000
		dc.w	$0000,$DCC0,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C0F,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$0007,$0000,$0000,$0000,$1FC0,$0000,$0000
		dc.w	$0000,$0F9C,$0000,$0000,$0000,$C71C,$0000,$0000
		dc.w	$0000,$CF80,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1FCF,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$001F,$0000,$0000,$0000,$8F9F,$0000,$0000
		dc.w	$0000,$801F,$0000,$0000,$0000,$8F8F,$0000,$0000
		dc.w	$0000,$8FC0,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C1C,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$C01C,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$DC00,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1F0F,$0000,$0000,$0000,$C00F,$0000,$0000
		dc.w	$0000,$801C,$0000,$0000,$0000,$DC1C,$0000,$0000
		dc.w	$0000,$C01C,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$0F80,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C00,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$C01C,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$C0C0,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C0F,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$001F,$0000,$0000,$0000,$8F9F,$0000,$0000
		dc.w	$0000,$801F,$0000,$0000,$0000,$8F8F,$0000,$0000
		dc.w	$0000,$9F80,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1FCF,$0000,$0000,$0000,$CF80,$0000,$0000
		dc.w	$0000,$000F,$0000,$0000,$0000,$9F8F,$0000,$0000
		dc.w	$0000,$800F,$0000,$0000,$0000,$9CDF,$0000,$0000
		dc.w	$0000,$CF9C,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C1C,$0000,$0000,$0000,$1CC0,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$C01C,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$1CDC,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1F0F,$0000,$0000,$0000,$9C00,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$1F9C,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$1FDF,$0000,$0000
		dc.w	$0000,$1C1F,$0000,$0000,$0000,$8000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1C00,$0000,$0000,$0000,$DCC0,$0000,$0000
		dc.w	$0000,$001C,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$C01C,$0000,$0000,$0000,$DCDC,$0000,$0000
		dc.w	$0000,$1CDC,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$1FDF,$0000,$0000,$0000,$8F80,$0000,$0000
		dc.w	$0000,$000F,$0000,$0000,$0000,$9CCF,$0000,$0000
		dc.w	$0000,$800F,$0000,$0000,$0000,$9CDF,$0000,$0000
		dc.w	$0000,$CF9C,$0000,$0000,$0000,$C000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0003,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
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
		
IMG_LOGO:
	rept	3
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0CC0,$0CC0,$0000,$0B40,$0000,$0000,$0000,$0000
	rept	9
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0840,$0840,$0480,$0B40,$0000,$0000,$0000,$0000	
	rept	9
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr			
		dc.w	$0840,$0B40,$0480,$0B40,$0000,$0000,$0000,$0000
	rept	9
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$1860,$17A0,$0480,$1320,$0000,$0000,$0000,$0000
	rept	9
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$1860,$17A0,$0780,$1320,$0000,$0000,$0000,$0000
	rept	9
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$1860,$17A0,$0780,$1320,$0000,$0000,$0000,$0000
	rept	9
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$1020,$1FE0,$07A0,$1300,$0000,$0000,$0000,$0000
	rept	9
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$14A0,$1B60,$1300,$07A0,$0000,$0000,$0000,$0000
	rept	9
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$1320,$1020,$0B60,$1780,$0000,$0000,$0000,$0000
	rept	9
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$1320,$1020,$1B60,$0780,$0000,$0000,$0000,$0000
	rept	9
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$2010,$3030,$2B50,$0780,$0000,$0000,$0000,$0000
	rept	8
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0400,$0206,$0200,$01FF,$0080,$0100,$0100,$FE00
		dc.w	$3030,$3CF0,$2B50,$0780,$0008,$0475,$0208,$01FF
		dc.w	$0204,$FD84,$0206,$FFF1,$4044,$BA44,$40C6,$FF01
		dc.w	$0458,$BA40,$04C0,$FF0F,$0000,$7E60,$0000,$FFFF
		dc.w	$8020,$6010,$4010,$800F,$0002,$1004,$0004,$FFF8
		dc.w	$0800,$007E,$0000,$0FFF,$0080,$6060,$0040,$FF80
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0AAC,$0355,$0402,$0000,$AE40,$F100,$0080,$0000
		dc.w	$2790,$2010,$37B0,$0CC0,$016E,$0B91,$0400,$0000
		dc.w	$DFE2,$E033,$0012,$0000,$D56E,$2BAB,$0028,$0000
		dc.w	$B697,$498C,$0088,$0000,$FF0F,$03F0,$0000,$0000
		dc.w	$4055,$F01A,$2020,$0000,$62B9,$B7C4,$0802,$0000
		dc.w	$07FF,$0C03,$0800,$0000,$0F40,$F0F0,$0020,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$13D6,$042C,$0805,$0000,$5760,$E8C0,$0000,$0000
		dc.w	$DFEC,$A014,$0FC0,$9864,$02B0,$1F40,$0800,$0000
		dc.w	$6FE0,$5001,$0010,$0000,$EAED,$15AB,$0028,$0000
		dc.w	$4A12,$B505,$0008,$0000,$FE37,$0218,$0000,$0000
		dc.w	$C89E,$2021,$1040,$0000,$E95D,$43A3,$0400,$0000
		dc.w	$82FE,$0502,$0800,$0000,$37C8,$1820,$0010,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$15E9,$1A18,$0008,$0000,$2F80,$5060,$8000,$0000
		dc.w	$8784,$D02C,$2FD0,$9864,$0D60,$0F90,$1000,$0000
		dc.w	$55F1,$7A11,$0001,$0000,$3D6D,$C2C6,$0000,$0000
		dc.w	$B119,$4F0E,$0100,$0000,$FC1F,$0208,$0000,$0000
		dc.w	$E8AF,$18D0,$0000,$0000,$C4BE,$8141,$0200,$0000
		dc.w	$09FC,$8E02,$0000,$0000,$1FE8,$0818,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$1BF0,$1400,$0000,$0000,$5FE0,$2020,$8000,$0000
		dc.w	$8FC4,$8004,$DFEC,$3030,$0AE0,$1D10,$1000,$0000
		dc.w	$6BF0,$7410,$0000,$0000,$6FEF,$5000,$0000,$0000
		dc.w	$EC1A,$140F,$0000,$0000,$FC03,$0204,$0008,$0000
		dc.w	$F8DF,$08A0,$0000,$0000,$017F,$0080,$8200,$0000
		dc.w	$8AFC,$8F02,$0000,$0000,$03F8,$0408,$0800,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$05F0,$0A00,$1000,$0000,$AFC1,$D021,$0000,$0001
		dc.w	$4FCA,$A016,$3FF0,$703A,$0170,$1B90,$1400,$0000
		dc.w	$15E0,$3A10,$4000,$0000,$17EF,$2800,$4000,$0000
		dc.w	$D01D,$280E,$0400,$0000,$7C05,$8206,$0008,$0000
		dc.w	$F8AF,$08D0,$0000,$0000,$02BF,$0340,$8000,$0000
		dc.w	$0AFC,$8D02,$0000,$0000,$05F8,$0608,$0800,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0AF0,$0F00,$1000,$0000,$5FC1,$A021,$0001,$0000
		dc.w	$3FF2,$400A,$BFF4,$601A,$12F0,$0710,$0800,$1000
		dc.w	$AAF0,$BD10,$C000,$0000,$2BEF,$3C00,$4000,$0000
		dc.w	$A812,$7807,$0408,$0000,$AC12,$D21F,$0018,$0000
		dc.w	$F057,$08F8,$0000,$0000,$417F,$C280,$C000,$0000
		dc.w	$05FC,$8A02,$0000,$0000,$02F0,$0F08,$0800,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$05F0,$0E00,$1000,$0000,$7FC1,$8021,$0001,$0000
		dc.w	$1FE2,$400A,$BFF6,$6018,$1153,$0AAC,$0408,$1010
		dc.w	$3068,$FFF8,$4010,$0000,$57EF,$3800,$0000,$4000
		dc.w	$D429,$3831,$0026,$0408,$A4ED,$FF16,$0200,$0008
		dc.w	$F02F,$08F0,$0000,$0000,$B92C,$47FC,$0203,$8000
		dc.w	$A7F5,$680E,$2002,$8000,$05F0,$0E08,$0800,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0AF0,$0D00,$1000,$0000,$FFC1,$8020,$0000,$0000
		dc.w	$1FE2,$4008,$BFF4,$6018,$12F0,$0710,$0800,$1000
		dc.w	$0000,$0000,$0000,$0000,$2BEF,$3400,$4000,$0000
		dc.w	$A800,$5800,$0400,$0000,$0002,$0005,$0008,$0000
		dc.w	$F07A,$0885,$0000,$0000,$0000,$0000,$8000,$0000
		dc.w	$0FFC,$0802,$0000,$0000,$02F0,$0508,$0800,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$05E0,$0610,$1800,$0000,$7FC0,$8021,$0000,$0000
		dc.w	$1FE0,$C00E,$FFFC,$6018,$01E0,$1A10,$1400,$0000
		dc.w	$0000,$0000,$0000,$0000,$17C7,$1828,$6000,$0000
		dc.w	$D000,$3000,$0C00,$0000,$0005,$0006,$0008,$0000
		dc.w	$F07D,$0883,$0000,$0000,$0000,$0000,$8000,$0000
		dc.w	$07FC,$0802,$0000,$0000,$05F0,$0608,$0800,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0AF0,$0F00,$1000,$0000,$FFE0,$8021,$0000,$0000
		dc.w	$DFEC,$0002,$7FF8,$E01C,$0BF0,$0C10,$1000,$0000
		dc.w	$0000,$0000,$0000,$0000,$2BEF,$3C00,$4000,$0000
		dc.w	$A800,$7800,$0400,$0000,$0003,$0004,$0008,$0000
		dc.w	$F07E,$0881,$0000,$0000,$0000,$0000,$8000,$0000
		dc.w	$0FFE,$0802,$0000,$0000,$0070,$0F88,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0560,$0790,$1800,$0000,$3FE0,$4021,$8000,$0000
		dc.w	$DFEC,$0002,$7FF8,$E01C,$05E6,$0A08,$1018,$0007
		dc.w	$2400,$1800,$1800,$E000,$15C7,$1E28,$6000,$0000
		dc.w	$5000,$F000,$0C00,$0000,$0005,$0006,$0008,$0000
		dc.w	$7075,$888B,$0000,$0000,$0000,$0000,$8000,$0000
		dc.w	$03FC,$0401,$0803,$0000,$C470,$0388,$0300,$FC00
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0AE0,$1B10,$1400,$0000,$DFE0,$A021,$0000,$0000
		dc.w	$FFFC,$0002,$7FF8,$C00C,$0FFE,$0001,$1000,$0000
		dc.w	$3400,$F800,$0800,$0000,$2BC6,$6C29,$5000,$0000
		dc.w	$A800,$6C00,$1400,$0000,$0002,$0005,$0008,$0000
		dc.w	$F07A,$0885,$0000,$0000,$0000,$0000,$8000,$0000
		dc.w	$0DFF,$0A00,$0000,$0000,$C670,$3F88,$0100,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$1570,$0790,$0800,$1000,$3FE1,$4021,$8000,$0000
		dc.w	$3FF2,$8006,$7FF8,$C00C,$0BF3,$141C,$1000,$0000
		dc.w	$E400,$1800,$0800,$0000,$55ED,$1E2A,$2000,$4000
		dc.w	$5400,$F000,$0800,$0400,$0007,$0000,$0008,$0000
		dc.w	$E8BF,$18C0,$0000,$0000,$0000,$0000,$8000,$0000
		dc.w	$03FE,$0403,$0800,$0000,$7C68,$8398,$0100,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$1AD0,$0BB0,$0400,$1000,$5FC7,$A006,$8024,$0001
		dc.w	$FFFF,$0001,$FFFC,$8006,$85E0,$9A00,$9010,$0000
		dc.w	$0000,$0000,$0000,$0000,$6BAA,$2E6D,$1000,$4000
		dc.w	$AC00,$E800,$1000,$0400,$0003,$000C,$0008,$0000
		dc.w	$F07E,$0001,$0880,$0000,$0000,$8000,$8000,$0000
		dc.w	$05FC,$0A00,$0802,$0000,$0FF0,$0F80,$0F88,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0571,$05D1,$0A01,$1000,$AB85,$545A,$0039,$8007
		dc.w	$7FFA,$0001,$FFFE,$8007,$9AE0,$6D10,$6010,$9000
		dc.w	$0000,$0200,$0000,$0000,$156F,$17AA,$2800,$4000
		dc.w	$5200,$D000,$2800,$0400,$0017,$0018,$0018,$0000
		dc.w	$A02F,$5050,$0880,$0000,$4000,$C000,$C000,$0000
		dc.w	$1AB9,$1546,$1002,$0800,$17A0,$1850,$1808,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$C82E,$9FF7,$A016,$1000,$3105,$3F58,$40C7,$803E
		dc.w	$FFFE,$0000,$FFFF,$0001,$864A,$67D5,$8820,$F018
		dc.w	$020A,$15C5,$8200,$7FF8,$2054,$7FFF,$8038,$4000
		dc.w	$0B49,$FFFE,$0000,$0400,$FF53,$BECB,$BE24,$0018
		dc.w	$2026,$E23E,$1541,$0880,$57FC,$9BEB,$23E8,$C000
		dc.w	$A311,$F3F5,$040C,$0802,$5321,$CBE2,$2414,$1808
		dc.w	$C000,$C000,$C000,$0000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$3571,$0E91,$0001,$1000,$3F8D,$4042,$8021,$001F
		dc.w	$7FFA,$0001,$FFFE,$8007,$C5D8,$1A20,$1000,$E010
		dc.w	$AA28,$7FE0,$4010,$0000,$EAA9,$3F6E,$0000,$4000
		dc.w	$AE00,$FA00,$0200,$0400,$0015,$000A,$0008,$0000
		dc.w	$5055,$B8EA,$0880,$0000,$4000,$8000,$8000,$0000
		dc.w	$13F9,$1405,$1803,$0000,$1550,$0AB8,$0808,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0AA0,$1F50,$1000,$0000,$FFC7,$8006,$0024,$0001
		dc.w	$FFFF,$0001,$FFFC,$8006,$8BE0,$8410,$9010,$0000
		dc.w	$1570,$3E90,$4000,$0000,$1502,$7EED,$4000,$0000
		dc.w	$5000,$FC00,$0400,$0000,$0007,$0000,$0008,$0000
		dc.w	$A02F,$58D0,$0880,$0000,$0000,$0000,$8000,$0000
		dc.w	$0FFC,$0800,$0002,$0000,$07A0,$0058,$0808,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$25E0,$2A10,$3000,$0000,$FFE1,$8021,$0000,$0000
		dc.w	$3FF2,$8006,$7FF8,$C00C,$07E0,$0800,$1010,$0000
		dc.w	$2BF0,$3C10,$4000,$0000,$6AC6,$7D29,$0000,$0000
		dc.w	$AC00,$7C00,$0000,$0000,$0007,$0000,$0008,$0000
		dc.w	$D05F,$2020,$0880,$0000,$0000,$0000,$8000,$0000
		dc.w	$0FFE,$0802,$0000,$0000,$07D0,$0020,$0808,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0BE0,$0410,$1000,$0000,$FFE0,$8021,$0000,$0000
		dc.w	$FFFC,$0002,$7FF8,$C00C,$1DE0,$1200,$0010,$0000
		dc.w	$55E0,$7A10,$0000,$0000,$55EF,$7A28,$0000,$0000
		dc.w	$5400,$BC00,$0000,$0000,$000F,$0008,$0000,$0000
		dc.w	$A02F,$5050,$0880,$0000,$8000,$8000,$0000,$0000
		dc.w	$0FFE,$0802,$0000,$0000,$0FA0,$0850,$0008,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$1FF0,$1010,$0000,$0000,$7FC0,$0021,$8000,$0000
		dc.w	$DFEC,$0002,$7FF8,$E01C,$17F0,$1810,$0000,$0000
		dc.w	$6BE0,$7410,$0000,$0000,$6BEF,$7428,$0000,$0000
		dc.w	$AC00,$5C00,$0000,$0000,$000F,$0008,$0000,$0000
		dc.w	$F8FF,$0880,$0000,$0000,$8000,$8000,$0000,$0000
		dc.w	$07FC,$0002,$0800,$0000,$0FF8,$0808,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$1FF0,$1010,$0000,$0000,$FFC0,$8021,$0000,$0000
		dc.w	$DFEC,$0002,$7FF8,$E01C,$1BF0,$1410,$0000,$0000
		dc.w	$17E0,$7810,$0000,$0000,$57C7,$7800,$0028,$0000
		dc.w	$D400,$3C00,$0000,$0000,$0007,$0008,$0000,$0000
		dc.w	$F07F,$0000,$0880,$0000,$0000,$8000,$0000,$0000
		dc.w	$0FFC,$0802,$0000,$0000,$07F0,$0800,$0008,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$1FE0,$1000,$0010,$0000,$7FC0,$0021,$8000,$0000
		dc.w	$1FE0,$C00E,$FFFC,$6018,$05E0,$0A10,$1000,$0000
		dc.w	$3FF0,$6000,$0000,$0000,$7FC7,$6000,$0028,$0000
		dc.w	$FC00,$0C00,$0000,$0000,$000B,$000C,$0000,$0000
		dc.w	$F8FE,$0881,$0000,$0000,$8000,$8000,$0000,$0000
		dc.w	$07FC,$0002,$0800,$0000,$0BF8,$0C08,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$17E0,$1800,$0010,$0000,$7FE1,$0000,$8000,$0000
		dc.w	$1FE2,$4008,$BFF4,$6018,$1BE0,$1410,$0000,$0000
		dc.w	$1FF0,$7000,$0000,$0000,$5FC7,$7028,$0028,$0000
		dc.w	$F400,$1C00,$0000,$0000,$000F,$0008,$0000,$0000
		dc.w	$F8FF,$0880,$0000,$0000,$8000,$8000,$0000,$0000
		dc.w	$07FE,$0000,$0800,$0000,$0FF8,$0808,$0000,$0000
	rept	3
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0000,$0001,$0000,$0000
		dc.w	$1BE0,$9410,$0010,$0000,$7FC1,$0021,$8001,$0000
		dc.w	$1FE2,$400A,$BFF6,$6018,$05E0,$0E10,$1000,$0000
		dc.w	$3FF0,$6000,$0000,$0000,$3FC7,$2028,$4028,$0000
		dc.w	$F800,$0800,$0400,$0000,$000B,$000C,$0000,$0000
		dc.w	$F8FE,$0881,$0000,$0000,$8000,$8000,$0000,$0000
		dc.w	$07FC,$0002,$0800,$0000,$0BF8,$0C09,$0000,$0000
		dc.w	$0000,$8000,$0000,$0000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0000,$0002,$0001,$0000
		dc.w	$07E0,$C810,$9010,$0000,$5FE1,$A001,$8000,$0001
		dc.w	$3FF2,$400A,$BFF4,$601A,$0AF0,$0D10,$1000,$0000
		dc.w	$2FF0,$5000,$0000,$0000,$6FC7,$5000,$0028,$0000
		dc.w	$EC00,$1400,$0000,$0000,$0005,$0002,$0008,$0000
		dc.w	$F8FD,$0882,$0000,$0000,$0000,$0000,$8000,$0000
		dc.w	$05FE,$0A00,$0800,$0000,$05F8,$020B,$0801,$0000
		dc.w	$0000,$4000,$8000,$0000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0007,$0003,$0000,$0000
		dc.w	$5AE0,$5D00,$0010,$8000,$2BE0,$5400,$8000,$0000
		dc.w	$CFCC,$2010,$3FF0,$7038,$0570,$0E90,$1000,$0000
		dc.w	$3FF0,$6000,$0000,$0000,$3FC7,$2028,$4028,$0000
		dc.w	$F800,$0800,$0400,$0000,$000B,$000E,$0000,$0000
		dc.w	$F8FE,$0883,$0000,$0000,$8000,$8000,$0000,$0000
		dc.w	$02BE,$0540,$0800,$0000,$0BFA,$0E0A,$0000,$0001
		dc.w	$E000,$C000,$0000,$0000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$00AD,$006B,$0028,$0000
		dc.w	$95E0,$2E10,$4010,$9000,$5FE1,$E001,$8001,$0000
		dc.w	$8FC4,$0004,$5FEC,$3030,$0AE8,$0D08,$1018,$0000
		dc.w	$1FF0,$6000,$0000,$0000,$1FC7,$2000,$4028,$0000
		dc.w	$F000,$0800,$0400,$0000,$0005,$0006,$0008,$0000
		dc.w	$7075,$888B,$0000,$0000,$0000,$0000,$8000,$0000
		dc.w	$05FE,$0E00,$0800,$0000,$0579,$0684,$0802,$0009
		dc.w	$B500,$D600,$1400,$0000,$0000,$0000,$0000,$0000
		dc.w	$0200,$0200,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$018B,$00A5,$0000,$0040
		dc.w	$1AE0,$5D00,$8010,$0000,$2FE0,$F000,$8000,$0000
		dc.w	$8784,$D02C,$2FD0,$9864,$1DE0,$1E18,$0010,$0000
		dc.w	$3FE1,$4010,$0000,$0000,$BEC6,$C145,$4028,$0000
		dc.w	$FB00,$0600,$0400,$0000,$0002,$0007,$0008,$0000
		dc.w	$F8FA,$0887,$0000,$0000,$0000,$0000,$8000,$0000
		dc.w	$02FE,$0F00,$0800,$0000,$02F8,$070A,$0801,$0000
		dc.w	$D180,$A500,$0000,$0200,$0000,$0000,$0000,$0000
		dc.w	$0000,$0004,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$180E,$11A0,$1041,$0000
		dc.w	$5560,$DE80,$4010,$0000,$5FE0,$E000,$8000,$0000
		dc.w	$DFEC,$A014,$0FC0,$9864,$12F3,$0D1F,$080B,$0000
		dc.w	$FFE1,$4011,$0000,$0000,$FD01,$42EE,$0044,$8000
		dc.w	$7F00,$8500,$0000,$0200,$0005,$0006,$0008,$0000
		dc.w	$5055,$A8AB,$0000,$0000,$0000,$0000,$8000,$0000
		dc.w	$05FE,$0E00,$0800,$0000,$055A,$06AB,$0802,$0000
		dc.w	$7018,$0588,$8208,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$1A6A,$2004,$0000,$0000,$6600,$8820,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1CAA,$11CF,$0008,$0800
		dc.w	$8AE1,$0F01,$1011,$0000,$2BC0,$7420,$8000,$0000
		dc.w	$2790,$2010,$37B0,$0CC0,$09F8,$020E,$0406,$0001
		dc.w	$3FD2,$0032,$4002,$8001,$1228,$6D6D,$80AA,$0000
		dc.w	$9080,$6C80,$0280,$0100,$0012,$0017,$0018,$0000
		dc.w	$A02A,$D8DF,$0000,$0000,$4000,$4000,$C000,$0000
		dc.w	$12BC,$1742,$1800,$0000,$12A1,$17D0,$1808,$0000
		dc.w	$5538,$F388,$1000,$0010,$0000,$0000,$0000,$0000
		dc.w	$0A00,$2084,$0000,$0000,$2200,$8850,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0CC7,$1C44,$0444,$0000
		dc.w	$0E12,$0FF3,$1002,$0000,$B800,$3FE0,$4000,$8000
		dc.w	$3030,$3CF0,$2B50,$0780,$071C,$03E3,$0000,$0000
		dc.w	$0065,$FFE7,$0014,$0000,$63C7,$9F45,$0044,$0000
		dc.w	$8D40,$F3C0,$0040,$0000,$0021,$0039,$002E,$0000
		dc.w	$7074,$78F4,$800B,$0000,$2000,$E000,$A000,$0000
		dc.w	$2B80,$33FE,$2400,$0800,$2170,$3970,$2E88,$0000
		dc.w	$E330,$2238,$2220,$0000,$0000,$0000,$0000,$0000
		dc.w	$2A64,$0000,$0000,$0000,$C870,$4000,$0000,$0000
	rept	3
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$2010,$3030,$2B50,$0780,$0000,$0000,$0000,$0000
	rept	5
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$2AE6,$0000,$0000,$0000,$E950,$0000,$0000,$0000
		dc.w	$65C0,$7640,$5840,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0080,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$1322,$1022,$1B62,$0780,$0000,$0000,$0000,$0000
		dc.w	$0004,$0004,$0004,$0000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$403F,$693F,$39C0,$3E00,$F400,$FFFF,$0000,$0000
		dc.w	$0550,$FFD2,$002F,$0000,$1A1A,$A51F,$E5E0,$1A00
		dc.w	$0140,$FFFF,$0080,$0000,$BFFC,$FFFC,$0003,$0000
		dc.w	$532E,$902D,$9B69,$4782,$0BF4,$0BFF,$F400,$0000
		dc.w	$000A,$FFFF,$0004,$0000,$002E,$FFFF,$0000,$0000
		dc.w	$A03A,$E6BF,$1FC0,$0000,$4000,$FFFF,$0000,$0000
		dc.w	$2940,$F9FF,$0600,$0000,$0002,$FFFF,$0000,$0000
		dc.w	$D000,$FFFF,$2000,$0000,$00AA,$FFFA,$0005,$0000
		dc.w	$0343,$54A3,$FCBC,$0340,$402D,$FFFF,$0010,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$A886,$E934,$1710,$00F8
		dc.w	$2AC5,$40FA,$7900,$1E00,$FFFF,$0000,$0000,$0000
		dc.w	$FAAD,$057D,$0002,$0000,$40E5,$5AFA,$BF00,$0000
		dc.w	$FF7F,$0080,$0000,$0000,$FFFE,$0001,$0000,$0000
		dc.w	$14A9,$9B60,$4304,$17A3,$AFFF,$D000,$0000,$0000
		dc.w	$FFFB,$0004,$0000,$0000,$FFD1,$002F,$0000,$0000
		dc.w	$5945,$F97A,$0680,$0000,$BFFF,$4000,$0000,$0000
		dc.w	$D6BF,$2F40,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$DFFF,$2000,$0000,$0000,$FF55,$00AF,$0000,$0000
		dc.w	$A81C,$AB5F,$57E0,$0000,$BFEF,$4010,$0000,$0000
		dc.w	$FFFB,$0004,$0000,$0000,$5510,$BD82,$0294,$0078
		dc.w	$40C2,$6AFD,$3300,$3C00,$BFFF,$4000,$0000,$0000
		dc.w	$ED56,$12BE,$0001,$0000,$81D3,$8DFC,$7E00,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$502C,$DFEF,$078B,$1320,$97FF,$E800,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FF68,$0097,$0000,$0000
		dc.w	$B4EA,$F4F5,$0B00,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$697F,$9680,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FDAA,$0257,$0000,$0000
		dc.w	$D03A,$D1BF,$2FC0,$0000,$7FFF,$8000,$0000,$0000
		dc.w	$FFFE,$0001,$0000,$0000,$8A46,$7A1C,$0588,$0070
		dc.w	$65C0,$7640,$5840,$0000,$0000,$0000,$0000,$0000
	rept	9
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
	
conterm		ds.w	1 

mul_tab		DS.W 200

trig_tab	dc.w	$0000,$00C9,$0192,$025B,$0324,$03ED,$04B6,$057E 
		dc.w	$0647,$0710,$07D9,$08A1,$096A,$0A32,$0AFB,$0BC3 
		dc.w	$0C8B,$0D53,$0E1B,$0EE3,$0FAB,$1072,$1139,$1200 
		dc.w	$12C7,$138E,$1455,$151B,$15E1,$16A7,$176D,$1833 
		dc.w	$18F8,$19BD,$1A82,$1B46,$1C0B,$1CCF,$1D93,$1E56 
		dc.w	$1F19,$1FDC,$209F,$2161,$2223,$22E4,$23A6,$2467 
		dc.w	$2527,$25E7,$26A7,$2767,$2826,$28E5,$29A3,$2A61 
		dc.w	$2B1E,$2BDB,$2C98,$2D54,$2E10,$2ECC,$2F86,$3041 
		dc.w	$30FB,$31B4,$326D,$3326,$33DE,$3496,$354D,$3603 
		dc.w	$36B9,$376F,$3824,$38D8,$398C,$3A3F,$3AF2,$3BA4 
		dc.w	$3C56,$3D07,$3DB7,$3E67,$3F16,$3FC5,$4073,$4120 
		dc.w	$41CD,$4279,$4325,$43D0,$447A,$4523,$45CC,$4674 
		dc.w	$471C,$47C3,$4869,$490E,$49B3,$4A57,$4AFA,$4B9D 
		dc.w	$4C3F,$4CE0,$4D80,$4E20,$4EBF,$4F5D,$4FFA,$5097 
		dc.w	$5133,$51CE,$5268,$5301,$539A,$5432,$54C9,$555F 
		dc.w	$55F4,$5689,$571D,$57B0,$5842,$58D3,$5963,$59F3 
		dc.w	$5A81,$5B0F,$5B9C,$5C28,$5CB3,$5D3D,$5DC6,$5E4F 
		dc.w	$5ED6,$5F5D,$5FE2,$6067,$60EB,$616E,$61F0,$6271 
		dc.w	$62F1,$6370,$63EE,$646B,$64E7,$6562,$65DD,$6656 
		dc.w	$66CE,$6745,$67BC,$6831,$68A5,$6919,$698B,$69FC 
		dc.w	$6A6C,$6ADB,$6B4A,$6BB7,$6C23,$6C8E,$6CF8,$6D61 
		dc.w	$6DC9,$6E30,$6E95,$6EFA,$6F5E,$6FC0,$7022,$7082 
		dc.w	$70E1,$7140,$719D,$71F9,$7254,$72AE,$7306,$735E 
		dc.w	$73B5,$740A,$745E,$74B1,$7503,$7554,$75A4,$75F3 
		dc.w	$7640,$768D,$76D8,$7722,$776B,$77B3,$77F9,$783F 
		dc.w	$7883,$78C6,$7908,$7949,$7989,$79C7,$7A04,$7A41 
		dc.w	$7A7C,$7AB5,$7AEE,$7B25,$7B5C,$7B91,$7BC4,$7BF7 
		dc.w	$7C29,$7C59,$7C88,$7CB6,$7CE2,$7D0E,$7D38,$7D61 
		dc.w	$7D89,$7DB0,$7DD5,$7DF9,$7E1C,$7E3E,$7E5E,$7E7E 
		dc.w	$7E9C,$7EB9,$7ED4,$7EEF,$7F08,$7F20,$7F37,$7F4C 
		dc.w	$7F61,$7F74,$7F86,$7F96,$7FA6,$7FB4,$7FC1,$7FCD 
		dc.w	$7FD7,$7FE0,$7FE8,$7FEF,$7FF5,$7FF9,$7FFC,$7FFE 
		dc.w	$7FFF,$7FFE,$7FFC,$7FF9,$7FF5,$7FEF,$7FE8,$7FE0 
		dc.w	$7FD7,$7FCD,$7FC1,$7FB4,$7FA6,$7F96,$7F86,$7F74 
		dc.w	$7F61,$7F4C,$7F37,$7F20,$7F08,$7EEF,$7ED4,$7EB9 
		dc.w	$7E9C,$7E7E,$7E5E,$7E3E,$7E1C,$7DF9,$7DD5,$7DB0 
		dc.w	$7D89,$7D61,$7D38,$7D0E,$7CE2,$7CB6,$7C88,$7C59 
		dc.w	$7C29,$7BF7,$7BC4,$7B91,$7B5C,$7B25,$7AEE,$7AB5 
		dc.w	$7A7C,$7A41,$7A04,$79C7,$7989,$7949,$7908,$78C6 
		dc.w	$7883,$783F,$77F9,$77B3,$776B,$7722,$76D8,$768D 
		dc.w	$7640,$75F3,$75A4,$7554,$7503,$74B1,$745E,$740A 
		dc.w	$73B5,$735E,$7306,$72AE,$7254,$71F9,$719D,$7140 
		dc.w	$70E1,$7082,$7022,$6FC0,$6F5E,$6EFA,$6E95,$6E30 
		dc.w	$6DC9,$6D61,$6CF8,$6C8E,$6C23,$6BB7,$6B4A,$6ADB 
		dc.w	$6A6C,$69FC,$698B,$6919,$68A5,$6831,$67BC,$6745 
		dc.w	$66CE,$6656,$65DD,$6562,$64E7,$646B,$63EE,$6370 
		dc.w	$62F1,$6271,$61F0,$616E,$60EB,$6067,$5FE2,$5F5D 
		dc.w	$5ED6,$5E4F,$5DC6,$5D3D,$5CB3,$5C28,$5B9C,$5B0F 
		dc.w	$5A81,$59F3,$5963,$58D3,$5842,$57B0,$571D,$5689 
		dc.w	$55F4,$555F,$54C9,$5432,$539A,$5301,$5268,$51CE 
		dc.w	$5133,$5097,$4FFA,$4F5D,$4EBF,$4E20,$4D80,$4CE0 
		dc.w	$4C3F,$4B9D,$4AFA,$4A57,$49B3,$490E,$4869,$47C3 
		dc.w	$471C,$4674,$45CC,$4523,$447A,$43D0,$4325,$4279 
		dc.w	$41CD,$4120,$4073,$3FC5,$3F16,$3E67,$3DB7,$3D07 
		dc.w	$3C56,$3BA4,$3AF2,$3A3F,$398C,$38D8,$3824,$376F 
		dc.w	$36B9,$3603,$354D,$3496,$33DE,$3326,$326D,$31B4 
		dc.w	$30FB,$3041,$2F86,$2ECC,$2E10,$2D54,$2C98,$2BDB 
		dc.w	$2B1E,$2A61,$29A3,$28E5,$2826,$2767,$26A7,$25E7 
		dc.w	$2527,$2467,$23A6,$22E4,$2223,$2161,$209F,$1FDC 
		dc.w	$1F19,$1E56,$1D93,$1CCF,$1C0B,$1B46,$1A82,$19BD 
		dc.w	$18F8,$1833,$176D,$16A7,$15E1,$151B,$1455,$138E 
		dc.w	$12C7,$1200,$1139,$1072,$0FAB,$0EE3,$0E1B,$0D53 
		dc.w	$0C8B,$0BC3,$0AFB,$0A32,$096A,$08A1,$07D9,$0710 
		dc.w	$0647,$057E,$04B6,$03ED,$0324,$025B,$0192,$00C9 
		dc.w	$0000,$FF37,$FE6E,$FDA5,$FCDC,$FC13,$FB4A,$FA82 
		dc.w	$F9B9,$F8F0,$F827,$F75F,$F696,$F5CE,$F505,$F43D 
		dc.w	$F375,$F2AD,$F1E5,$F11D,$F055,$EF8E,$EEC7,$EE00 
		dc.w	$ED39,$EC72,$EBAB,$EAE5,$EA1F,$E959,$E893,$E7CD 
		dc.w	$E708,$E643,$E57E,$E4BA,$E3F5,$E331,$E26D,$E1AA 
		dc.w	$E0E7,$E024,$DF61,$DE9F,$DDDD,$DD1C,$DC5A,$DB99 
		dc.w	$DAD9,$DA19,$D959,$D899,$D7DA,$D71B,$D65D,$D59F 
		dc.w	$D4E2,$D425,$D368,$D2AC,$D1F0,$D134,$D07A,$CFBF 
		dc.w	$CF05,$CE4C,$CD93,$CCDA,$CC22,$CB6A,$CAB3,$C9FD 
		dc.w	$C947,$C891,$C7DC,$C728,$C674,$C5C1,$C50E,$C45C 
		dc.w	$C3AA,$C2F9,$C249,$C199,$C0EA,$C03B,$BF8D,$BEE0 
		dc.w	$BE33,$BD87,$BCDB,$BC30,$BB86,$BADD,$BA34,$B98C 
		dc.w	$B8E4,$B83D,$B797,$B6F2,$B64D,$B5A9,$B506,$B463 
		dc.w	$B3C1,$B320,$B280,$B1E0,$B141,$B0A3,$B006,$AF69 
		dc.w	$AECD,$AE32,$AD98,$ACFF,$AC66,$ABCE,$AB37,$AAA1 
		dc.w	$AA0C,$A977,$A8E3,$A850,$A7BE,$A72D,$A69D,$A60D 
		dc.w	$A57F,$A4F1,$A464,$A3D8,$A34D,$A2C3,$A23A,$A1B1 
		dc.w	$A12A,$A0A3,$A01E,$9F99,$9F15,$9E92,$9E10,$9D8F 
		dc.w	$9D0F,$9C90,$9C12,$9B95,$9B19,$9A9E,$9A23,$99AA 
		dc.w	$9932,$98BB,$9844,$97CF,$975B,$96E7,$9675,$9604 
		dc.w	$9594,$9525,$94B6,$9449,$93DD,$9372,$9308,$929F 
		dc.w	$9237,$91D0,$916B,$9106,$90A2,$9040,$8FDE,$8F7E 
		dc.w	$8F1F,$8EC0,$8E63,$8E07,$8DAC,$8D52,$8CFA,$8CA2 
		dc.w	$8C4B,$8BF6,$8BA2,$8B4F,$8AFD,$8AAC,$8A5C,$8A0D 
		dc.w	$89C0,$8973,$8928,$88DE,$8895,$884D,$8807,$87C1 
		dc.w	$877D,$873A,$86F8,$86B7,$8677,$8639,$85FC,$85BF 
		dc.w	$8584,$854B,$8512,$84DB,$84A4,$846F,$843C,$8409 
		dc.w	$83D7,$83A7,$8378,$834A,$831E,$82F2,$82C8,$829F 
		dc.w	$8277,$8250,$822B,$8207,$81E4,$81C2,$81A2,$8182 
		dc.w	$8164,$8147,$812C,$8111,$80F8,$80E0,$80C9,$80B4 
		dc.w	$809F,$808C,$807A,$806A,$805A,$804C,$803F,$8033 
		dc.w	$8029,$8020,$8018,$8011,$800B,$8007,$8004,$8002 
		dc.w	$8001,$8002,$8004,$8007,$800B,$8011,$8018,$8020 
		dc.w	$8029,$8033,$803F,$804C,$805A,$806A,$807A,$808C 
		dc.w	$809F,$80B4,$80C9,$80E0,$80F8,$8111,$812C,$8147 
		dc.w	$8164,$8182,$81A2,$81C2,$81E4,$8207,$822B,$8250 
		dc.w	$8277,$829F,$82C8,$82F2,$831E,$834A,$8378,$83A7 
		dc.w	$83D7,$8409,$843C,$846F,$84A4,$84DB,$8512,$854B 
		dc.w	$8584,$85BF,$85FC,$8639,$8677,$86B7,$86F8,$873A 
		dc.w	$877D,$87C1,$8807,$884D,$8895,$88DE,$8928,$8973 
		dc.w	$89C0,$8A0D,$8A5C,$8AAC,$8AFD,$8B4F,$8BA2,$8BF6 
		dc.w	$8C4B,$8CA2,$8CFA,$8D52,$8DAC,$8E07,$8E63,$8EC0 
		dc.w	$8F1F,$8F7E,$8FDE,$9040,$90A2,$9106,$916B,$91D0 
		dc.w	$9237,$929F,$9308,$9372,$93DD,$9449,$94B6,$9525 
		dc.w	$9594,$9604,$9675,$96E7,$975B,$97CF,$9844,$98BB 
		dc.w	$9932,$99AA,$9A23,$9A9E,$9B19,$9B95,$9C12,$9C90 
		dc.w	$9D0F,$9D8F,$9E10,$9E92,$9F15,$9F99,$A01E,$A0A3 
		dc.w	$A12A,$A1B1,$A23A,$A2C3,$A34D,$A3D8,$A464,$A4F1 
		dc.w	$A57F,$A60D,$A69D,$A72D,$A7BE,$A850,$A8E3,$A977 
		dc.w	$AA0C,$AAA1,$AB37,$ABCE,$AC66,$ACFF,$AD98,$AE32 
		dc.w	$AECD,$AF69,$B006,$B0A3,$B141,$B1E0,$B280,$B320 
		dc.w	$B3C1,$B463,$B506,$B5A9,$B64D,$B6F2,$B797,$B83D 
		dc.w	$B8E4,$B98C,$BA34,$BADD,$BB86,$BC30,$BCDB,$BD87 
		dc.w	$BE33,$BEE0,$BF8D,$C03B,$C0EA,$C199,$C249,$C2F9 
		dc.w	$C3AA,$C45C,$C50E,$C5C1,$C674,$C728,$C7DC,$C891 
		dc.w	$C947,$C9FD,$CAB3,$CB6A,$CC22,$CCDA,$CD93,$CE4C 
		dc.w	$CF05,$CFBF,$D07A,$D134,$D1F0,$D2AC,$D368,$D425 
		dc.w	$D4E2,$D59F,$D65D,$D71B,$D7DA,$D899,$D959,$DA19 
		dc.w	$DAD9,$DB99,$DC5A,$DD1C,$DDDD,$DE9F,$DF61,$E024 
		dc.w	$E0E7,$E1AA,$E26D,$E331,$E3F5,$E4BA,$E57E,$E643 
		dc.w	$E708,$E7CD,$E893,$E959,$EA1F,$EAE5,$EBAB,$EC72 
		dc.w	$ED39,$EE00,$EEC7,$EF8E,$F055,$F11D,$F1E5,$F2AD 
		dc.w	$F375,$F43D,$F505,$F5CE,$F696,$F75F,$F827,$F8F0 
		dc.w	$F9B9,$FA82,$FB4A,$FC13,$FCDC,$FDA5,$FE6E,$FF37 
		dc.w	$0000,$00C9,$0192,$025B,$0324,$03ED,$04B6,$057E 
		dc.w	$0647,$0710,$07D9,$08A1,$096A,$0A32,$0AFB,$0BC3 
		dc.w	$0C8B,$0D53,$0E1B,$0EE3,$0FAB,$1072,$1139,$1200 
		dc.w	$12C7,$138E,$1455,$151B,$15E1,$16A7,$176D,$1833 
		dc.w	$18F8,$19BD,$1A82,$1B46,$1C0B,$1CCF,$1D93,$1E56 
		dc.w	$1F19,$1FDC,$209F,$2161,$2223,$22E4,$23A6,$2467 
		dc.w	$2527,$25E7,$26A7,$2767,$2826,$28E5,$29A3,$2A61 
		dc.w	$2B1E,$2BDB,$2C98,$2D54,$2E10,$2ECC,$2F86,$3041 
		dc.w	$30FB,$31B4,$326D,$3326,$33DE,$3496,$354D,$3603 
		dc.w	$36B9,$376F,$3824,$38D8,$398C,$3A3F,$3AF2,$3BA4 
		dc.w	$3C56,$3D07,$3DB7,$3E67,$3F16,$3FC5,$4073,$4120 
		dc.w	$41CD,$4279,$4325,$43D0,$447A,$4523,$45CC,$4674 
		dc.w	$471C,$47C3,$4869,$490E,$49B3,$4A57,$4AFA,$4B9D 
		dc.w	$4C3F,$4CE0,$4D80,$4E20,$4EBF,$4F5D,$4FFA,$5097 
		dc.w	$5133,$51CE,$5268,$5301,$539A,$5432,$54C9,$555F 
		dc.w	$55F4,$5689,$571D,$57B0,$5842,$58D3,$5963,$59F3 
		dc.w	$5A81,$5B0F,$5B9C,$5C28,$5CB3,$5D3D,$5DC6,$5E4F 
		dc.w	$5ED6,$5F5D,$5FE2,$6067,$60EB,$616E,$61F0,$6271 
		dc.w	$62F1,$6370,$63EE,$646B,$64E7,$6562,$65DD,$6656 
		dc.w	$66CE,$6745,$67BC,$6831,$68A5,$6919,$698B,$69FC 
		dc.w	$6A6C,$6ADB,$6B4A,$6BB7,$6C23,$6C8E,$6CF8,$6D61 
		dc.w	$6DC9,$6E30,$6E95,$6EFA,$6F5E,$6FC0,$7022,$7082 
		dc.w	$70E1,$7140,$719D,$71F9,$7254,$72AE,$7306,$735E 
		dc.w	$73B5,$740A,$745E,$74B1,$7503,$7554,$75A4,$75F3 
		dc.w	$7640,$768D,$76D8,$7722,$776B,$77B3,$77F9,$783F 
		dc.w	$7883,$78C6,$7908,$7949,$7989,$79C7,$7A04,$7A41 
		dc.w	$7A7C,$7AB5,$7AEE,$7B25,$7B5C,$7B91,$7BC4,$7BF7 
		dc.w	$7C29,$7C59,$7C88,$7CB6,$7CE2,$7D0E,$7D38,$7D61 
		dc.w	$7D89,$7DB0,$7DD5,$7DF9,$7E1C,$7E3E,$7E5E,$7E7E 
		dc.w	$7E9C,$7EB9,$7ED4,$7EEF,$7F08,$7F20,$7F37,$7F4C 
		dc.w	$7F61,$7F74,$7F86,$7F96,$7FA6,$7FB4,$7FC1,$7FCD 
		dc.w	$7FD7,$7FE0,$7FE8,$7FEF,$7FF5,$7FF9,$7FFC,$7FFE 

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
	
IMG_BSW0:
	rept	3
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$003F,$004F,$0040,$0000,$F807,$F807,$0007,$07F8
		dc.w	$FFFF,$FFFF,$F47D,$0B82,$FFFF,$FFFF,$F499,$0B66
		dc.w	$FFFF,$FFFF,$FFFF,$0000,$7E7C,$7E7C,$7E7C,$8183
		dc.w	$0000,$0000,$0000,$FFFF,$0800,$0800,$0000,$F800
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$003F,$0009,$0000,$0040,$FE92,$F692,$0002,$016D
		dc.w	$4FFF,$4FFF,$4D7F,$B280,$FFFF,$FFFF,$FEDB,$0124
		dc.w	$FFFF,$FFFF,$7F5F,$80A0,$7E7C,$7E7C,$7E7C,$8183
		dc.w	$3200,$3200,$3200,$CDFF,$1800,$1000,$0800,$F000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$001F,$0008,$0000,$0060,$F7FD,$096D,$0800,$0002
		dc.w	$B2A0,$B2A0,$0280,$4D5F,$0024,$0024,$0024,$FFDB
		dc.w	$ACA8,$ACA8,$80A8,$5357,$25C3,$25C3,$2040,$DA3C
		dc.w	$C9FE,$C9FE,$0000,$3601,$F800,$E000,$F800,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0016,$0011,$000E,$0066,$2088,$D835,$2742,$20A9
		dc.w	$0941,$B026,$46D9,$0922,$02EA,$3C01,$C134,$2ECB
		dc.w	$3FFF,$4000,$AFFF,$5000,$E4A4,$0000,$FFFF,$0000
		dc.w	$FFFC,$0000,$FFFF,$0000,$3000,$C000,$3800,$8000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0017,$001C,$0003,$0067,$E65C,$3133,$C88C,$EEDC
		dc.w	$B106,$D539,$2AC4,$BB87,$041D,$6A89,$9176,$977F
		dc.w	$6029,$0FAB,$D054,$FDBD,$2358,$C405,$38A2,$375C
		dc.w	$0900,$443F,$BBC0,$4434,$3000,$8000,$7800,$4000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0014,$001C,$0007,$0063,$89BC,$3653,$C8AC,$CBBC
		dc.w	$B90A,$C3B1,$3C44,$BD0F,$0C1F,$F3F9,$0007,$0E1E
		dc.w	$65A9,$426B,$9814,$F5BD,$2318,$8803,$74E4,$7B1A
		dc.w	$6137,$84C8,$7B00,$84B7,$3800,$8000,$7800,$4000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0015,$001C,$0002,$0066,$FFF7,$FFC9,$0008,$0000
		dc.w	$7105,$47BC,$7840,$B906,$0006,$FFFE,$FFF8,$0001
		dc.w	$F7FF,$C7FD,$1800,$F003,$260C,$8913,$74E4,$7A0A
		dc.w	$67FE,$07FD,$F800,$0003,$3800,$8000,$7800,$4000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0015,$001F,$0000,$0064,$E27F,$E261,$E200,$1D80
		dc.w	$9D0C,$938B,$087B,$7D30,$FCFE,$148E,$0000,$0301
		dc.w	$5607,$6E05,$D600,$99FB,$2318,$0843,$F4A4,$FB5A
		dc.w	$440D,$0C0C,$F00F,$0BF0,$3800,$8000,$7800,$4000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0015,$0013,$000C,$0064,$8C7F,$8C61,$8000,$7380
		dc.w	$9F1B,$90D4,$1934,$6F60,$0307,$FCFB,$FCF8,$0000
		dc.w	$5675,$AE73,$5600,$598B,$2001,$0B5A,$F4A4,$F803
		dc.w	$45CD,$19CC,$E00F,$1A30,$3000,$8000,$7800,$C000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0035,$003B,$0024,$004C,$EFFF,$EEC0,$8000,$1000
		dc.w	$CF34,$C8EB,$012B,$3F00,$0307,$FCFB,$FCF8,$0000
		dc.w	$15F9,$AD8F,$4404,$5A03,$00E0,$DB5B,$24A4,$2842
		dc.w	$43F7,$1E34,$E407,$1808,$D000,$0000,$7800,$C000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0021,$0027,$0028,$0052,$7FFD,$7242,$0002,$8000
		dc.w	$CB08,$48D7,$0D17,$3320,$0307,$FCFB,$FCF8,$0000
		dc.w	$85F9,$7C07,$0404,$AA03,$0040,$CBFB,$3444,$38A2
		dc.w	$4BF5,$1404,$E407,$1808,$D000,$4000,$3800,$C000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0029,$0027,$0028,$0052,$FFFE,$9E61,$0001,$0000
		dc.w	$CB3F,$4888,$0D40,$3340,$FF8E,$0276,$0070,$0001
		dc.w	$87C9,$7E76,$0435,$A803,$0151,$DAEA,$2444,$2913
		dc.w	$427C,$3DCC,$C587,$2000,$D000,$4000,$3800,$C000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0029,$0023,$002C,$0056,$FFBC,$90B3,$0003,$0040
		dc.w	$F85C,$7CA3,$1B23,$0540,$020E,$FDF6,$FDF0,$0001
		dc.w	$6640,$9DBC,$05BF,$E801,$81F1,$5AEA,$2444,$F9B3
		dc.w	$204C,$9FB4,$47B7,$A000,$D000,$4000,$3800,$C000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0021,$0027,$0028,$0052,$F2F0,$8D6F,$0D0F,$0000
		dc.w	$789C,$F86B,$9F23,$0180,$1FFB,$FFFB,$E003,$0004
		dc.w	$6640,$0DFD,$95BE,$7800,$26EC,$D1F0,$0CE7,$B319
		dc.w	$A04C,$1FF4,$47B7,$A000,$D000,$4800,$3000,$C800
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0061,$0067,$0068,$0012,$1051,$6FAE,$6F4E,$8030
		dc.w	$E88C,$6933,$0E73,$10C0,$2121,$C098,$DF66,$0091
		dc.w	$8E40,$65FD,$95BE,$1800,$22E8,$D9F2,$04E5,$F209
		dc.w	$A77C,$18C4,$4087,$A000,$D000,$4800,$3000,$C000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$006B,$0061,$006C,$0016,$73E7,$0C1C,$0C48,$80A0
		dc.w	$E8CC,$6973,$0E33,$10C0,$2120,$C49B,$DB64,$0482
		dc.w	$6640,$0DBD,$95BE,$7800,$A318,$5912,$0515,$F2E9
		dc.w	$A7FC,$1846,$4005,$A002,$5000,$C800,$7000,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0061,$0067,$0068,$0012,$73F7,$1C18,$0C68,$80B0
		dc.w	$FACC,$1973,$0E33,$00C0,$343D,$C11A,$CAC5,$16FD
		dc.w	$6640,$DDBC,$05BF,$6801,$2000,$DE0E,$0001,$F5F5
		dc.w	$A7FC,$1945,$4006,$A000,$5000,$6800,$D000,$A000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0069,$0067,$0068,$0012,$7377,$1C98,$0C68,$8030
		dc.w	$EECC,$0933,$0E73,$10C0,$24BD,$CB1B,$D0C4,$1CFD
		dc.w	$DE40,$45FD,$A5BE,$D800,$22A8,$D8A2,$060D,$E359
		dc.w	$A77C,$1885,$4086,$A000,$5000,$6800,$D000,$A000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$007B,$0075,$0058,$0022,$F3F4,$9C1B,$0C6B,$00B0
		dc.w	$EECC,$0933,$0E73,$10C0,$22BB,$D51D,$CAC2,$02FB
		dc.w	$CE40,$05BD,$F5BE,$C800,$43F8,$BFFE,$0209,$C405
		dc.w	$A75C,$18E5,$40A6,$A000,$5000,$6800,$D000,$A000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0073,$0071,$001C,$0066,$7354,$1C8B,$0C7B,$80B0
		dc.w	$E82C,$48D3,$0F13,$1100,$32DF,$CDB9,$C247,$1ADE
		dc.w	$0FB8,$C6BC,$3407,$0841,$81F0,$7DF6,$0001,$8209
		dc.w	$A75C,$18A5,$40A6,$A000,$6000,$4800,$D000,$A000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0075,$0073,$001C,$0064,$7354,$1C9B,$0C6B,$80B0
		dc.w	$E82C,$48D3,$0F13,$1100,$22DF,$DDFF,$C200,$1ADF
		dc.w	$0648,$8DB5,$75B6,$4800,$C7FC,$1FBE,$2001,$EC07
		dc.w	$AF5C,$10A5,$40A6,$A800,$6000,$4800,$D000,$A000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0075,$0073,$001C,$0064,$7374,$1C1B,$0CEB,$8030
		dc.w	$E82C,$48D3,$0F13,$1100,$22DF,$EDBF,$D248,$0AD7
		dc.w	$9640,$45FC,$2DBF,$9001,$07FC,$DF1E,$2405,$2803
		dc.w	$A75D,$18A6,$40A4,$A003,$6000,$4800,$D000,$A000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0075,$0077,$0018,$0064,$7354,$1C0F,$0CFB,$8030
		dc.w	$E92C,$48D3,$0F13,$1100,$22FC,$CE9C,$D1CB,$0B77
		dc.w	$9641,$4FFE,$25BD,$9803,$03F8,$DB5A,$2001,$2405
		dc.w	$A75D,$18A6,$40A4,$A003,$6000,$C000,$1800,$6800
	rept	5
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0001,$0000
		dc.w	$2B35,$6913,$803C,$34E4,$7344,$1C2F,$0CDB,$8010
		dc.w	$E93E,$48C1,$0F01,$1100,$E3D8,$3AFA,$051D,$17C5
		dc.w	$07C9,$9E36,$6435,$5803,$0BBA,$C3B9,$3802,$3C47
		dc.w	$075D,$B8A4,$40A6,$A001,$4FE2,$E7F8,$1E06,$49E8
	rept	5
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0005,$0003,$0004,$0003
		dc.w	$CB75,$8B73,$803C,$3484,$6F67,$009E,$0048,$90A0
		dc.w	$A93F,$28C5,$0F00,$5100,$E3D8,$1AFE,$0581,$1759
		dc.w	$17C9,$8637,$6C34,$5003,$0FFF,$CEEE,$3802,$3001
		dc.w	$1F5D,$A0E4,$40A6,$B801,$4FFC,$FFEB,$0E1C,$51F5
		dc.w	$8000,$0000,$8000,$0000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0014,$0004,$001C,$0003
		dc.w	$CB75,$8B7F,$8010,$348C,$7F46,$10A9,$0059,$8010
		dc.w	$F93A,$18C5,$0F05,$0100,$E3D9,$3ABE,$0541,$17D9
		dc.w	$4643,$A7BD,$5DBC,$7003,$07FC,$D4E5,$2000,$2802
		dc.w	$1F5C,$A0A5,$40A6,$B801,$4FFC,$AFCA,$5C3D,$53F5
		dc.w	$8000,$0000,$4000,$8000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0038,$0008,$0028,$0017
		dc.w	$EBF5,$EB1F,$9660,$3DFC,$7FE6,$101B,$0019,$8000
		dc.w	$993A,$78C5,$6F05,$0100,$E3D9,$3AF7,$0508,$07D9
		dc.w	$4643,$6DFD,$95BC,$D803,$1F5F,$E802,$1001,$10A1
		dc.w	$1F7C,$2087,$C084,$3803,$D50C,$2A8B,$507C,$E574
		dc.w	$8000,$4000,$2000,$8000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0059,$0039,$0059,$0006
		dc.w	$6B75,$4AFB,$F704,$BD7C,$7F36,$7329,$0009,$80C0
		dc.w	$983A,$78C5,$6F05,$0100,$C6FB,$391D,$390B,$0002
		dc.w	$C643,$6DBD,$95BC,$D803,$1FFF,$F8A3,$1001,$0000
		dc.w	$1F3C,$20D6,$C0C5,$3802,$D14C,$2E8B,$507C,$E174
		dc.w	$A000,$4000,$1000,$A000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$00FB,$003B,$00BA,$0045
		dc.w	$6B73,$CBF1,$760C,$3D76,$7FF6,$72E9,$0009,$8000
		dc.w	$913A,$7085,$6745,$0940,$1BFB,$E40B,$E401,$0006
		dc.w	$CE48,$65B6,$95B5,$D803,$8FFE,$60E0,$0000,$D001
		dc.w	$97FC,$2817,$4004,$B003,$D05C,$2F0A,$50FD,$E0F5
		dc.w	$3000,$C000,$0800,$B000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$017F,$007F,$01F8,$0007
		dc.w	$4B70,$DBE2,$661C,$2D75,$ED16,$ED1D,$8009,$12E0
		dc.w	$B87A,$58A5,$4F45,$0140,$0307,$FCFB,$FCF9,$0000
		dc.w	$5E48,$65B6,$95B5,$D803,$3FFF,$D9B3,$2000,$E000
		dc.w	$C7FC,$3816,$C015,$A002,$D0FC,$2C8A,$537D,$E3F5
		dc.w	$C000,$3800,$0400,$F800,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0077,$007F,$01A0,$00D7
		dc.w	$CB65,$76C3,$493C,$8B74,$7F3F,$3336,$0000,$80C0
		dc.w	$3C1A,$D895,$C745,$0960,$0286,$FD7A,$FD78,$0001
		dc.w	$4E50,$67BD,$95AE,$D800,$1FFF,$D111,$0000,$E000
		dc.w	$66ED,$1A04,$4007,$A110,$C3FC,$20FB,$5F0C,$EFF4
		dc.w	$0000,$F800,$0400,$B800,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$02E7,$006F,$0390,$00F7
		dc.w	$9C75,$41C3,$3E3C,$C074,$7FBE,$00B1,$0001,$8040
		dc.w	$613A,$A0B5,$8F45,$1960,$FFF9,$0277,$0006,$0000
		dc.w	$4FD8,$E677,$1424,$5800,$FFBF,$3209,$0000,$C040
		dc.w	$E7FD,$991C,$0017,$6000,$EC42,$0B19,$54E4,$ED16
		dc.w	$0200,$F000,$0E00,$9000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$02E6,$007E,$0381,$01E7
		dc.w	$7F35,$005F,$FFA0,$003C,$7FB8,$00B7,$0007,$8040
		dc.w	$F32B,$38AC,$0544,$1370,$F219,$0DE7,$0DE6,$0000
		dc.w	$5FD8,$E627,$1424,$5800,$1FFF,$0248,$C000,$6000
		dc.w	$07FD,$181C,$6007,$C000,$57F9,$6002,$8BFC,$5C03
		dc.w	$0000,$7000,$8E00,$1000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0044,$011C,$02E3,$00E6
		dc.w	$1F95,$403F,$BFC0,$001C,$7F6F,$006F,$0060,$8090
		dc.w	$4A34,$7493,$0163,$DF78,$0E19,$F1E6,$F1E6,$0000
		dc.w	$5FF0,$A677,$5404,$5808,$7FFF,$6248,$C000,$0000
		dc.w	$C7FD,$D81C,$6007,$0000,$50FF,$C200,$6DFE,$B001
		dc.w	$7600,$0000,$8E00,$7000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0040,$0318,$00E7,$02E4
		dc.w	$AFC5,$A00F,$1FF0,$E01C,$7F48,$00A7,$0057,$8020
		dc.w	$F43B,$3AD0,$0128,$173C,$8019,$7FF6,$7FE6,$0000
		dc.w	$47D8,$AE37,$5424,$5000,$3FBF,$A0A0,$0000,$4040
		dc.w	$87FC,$B81E,$0005,$4002,$457E,$C500,$78FF,$A700
		dc.w	$2700,$D000,$0F00,$E000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0002,$039D,$0062,$0060
		dc.w	$0FED,$5015,$4FE2,$A00E,$7FFE,$0001,$0041,$80B0
		dc.w	$6034,$A6F6,$8909,$1F3C,$6819,$81F6,$7FE6,$0000
		dc.w	$47D9,$EE66,$1424,$5001,$FFFF,$44E4,$8040,$8000
		dc.w	$F7F4,$4816,$2005,$300A,$507F,$EA80,$527F,$8500
		dc.w	$0F00,$7000,$8700,$6800,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0002,$0198,$0267,$0260
		dc.w	$AFED,$A005,$1FF2,$E00E,$7F7F,$6390,$0060,$80B0
		dc.w	$D87D,$DEBA,$1154,$2F6D,$4819,$01F7,$BFE6,$C000
		dc.w	$4798,$7E65,$8466,$C002,$7FBF,$45B4,$0040,$8040
		dc.w	$C7FC,$501E,$0805,$2802,$D57F,$6500,$58FF,$A700
		dc.w	$8700,$7800,$8700,$6000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0107,$0298,$0067,$0160
		dc.w	$1FDD,$4007,$BFF0,$000C,$7FF7,$6B1B,$0068,$80B0
		dc.w	$C834,$CEF5,$092A,$371E,$93DF,$E031,$1E20,$9E00
		dc.w	$0798,$3E67,$C464,$E000,$7F5F,$4912,$0000,$80E0
		dc.w	$C7FC,$581E,$0005,$2002,$D8FE,$4200,$7DFF,$8000
		dc.w	$A700,$5000,$8F00,$6800,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0087,$0318,$0067,$01E0
		dc.w	$FFDD,$0007,$FFF0,$000C,$7F77,$6B9B,$0078,$80A0
		dc.w	$C8B4,$CF75,$080A,$36BE,$93FE,$C010,$3E00,$BE01
		dc.w	$079B,$BE65,$4464,$6003,$FFBF,$89B2,$00E0,$0000
		dc.w	$FB3E,$34CC,$04C5,$1802,$FFFE,$4000,$7FFF,$8000
		dc.w	$9700,$2800,$C700,$3000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0087,$0310,$006F,$01E8
		dc.w	$FFDF,$0001,$FFF4,$000E,$7F7F,$6BB3,$0050,$8020
		dc.w	$C915,$0854,$0EAA,$313F,$93FE,$C050,$3E00,$BE01
		dc.w	$179A,$CE6C,$2464,$1003,$FF1F,$9319,$00E0,$00A0
		dc.w	$EB3C,$26CF,$04C4,$1803,$5FFE,$C000,$7FFF,$0000
		dc.w	$8700,$1800,$E700,$0000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$001B,$02E0,$010F,$0298
		dc.w	$FF83,$0001,$FFFC,$0006,$77FF,$6330,$0050,$88A0
		dc.w	$FB55,$3834,$1ECA,$015F,$93DE,$8020,$7E20,$FE01
		dc.w	$07F9,$DE1D,$2406,$9002,$FEEF,$9209,$0000,$01F0
		dc.w	$F3FC,$370F,$0C04,$0803,$DFFC,$4000,$7FFF,$8000
		dc.w	$AF00,$1000,$C700,$2800,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0003,$007C,$0383,$0000
		dc.w	$FF81,$0043,$FFBC,$0044,$77F3,$633D,$005C,$88A0
		dc.w	$FF34,$3813,$1ECC,$017D,$91D6,$8038,$7E28,$FE01
		dc.w	$87FB,$7E0F,$0406,$A000,$FF9F,$A378,$0150,$00E0
		dc.w	$FBFE,$BE0C,$0C05,$0002,$5FFC,$E002,$5FFD,$8002
		dc.w	$A700,$5800,$8700,$6800,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0045,$001C,$03A3,$0064
		dc.w	$FF35,$0083,$FF6C,$0094,$777F,$63B5,$0050,$8820
		dc.w	$EF10,$087B,$0E84,$1135,$81D6,$EA28,$1428,$9401
		dc.w	$279D,$9FE9,$4460,$6002,$FB9B,$A77C,$0404,$01B0
		dc.w	$F73C,$B2FE,$00C5,$0800,$6FF9,$4004,$9FFB,$6004
		dc.w	$6700,$1000,$8F00,$6000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0207,$001E,$03E1,$0026
		dc.w	$FC75,$0103,$FEDC,$0134,$7F7F,$0837,$00D0,$80A0
		dc.w	$EF1A,$0875,$0E80,$115B,$81D6,$E628,$1828,$9801
		dc.w	$07FB,$BE1F,$4404,$4000,$FD37,$E1D0,$0000,$0338
		dc.w	$FBFF,$FF0C,$0405,$0002,$67E2,$5008,$8FF7,$7008
		dc.w	$0E00,$7000,$8E00,$7000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$002F,$0017,$01C2,$002D
		dc.w	$60C5,$0003,$FFBC,$0074,$7F7F,$08B5,$0050,$8020
		dc.w	$EA22,$0D1D,$0AE0,$116B,$81D6,$6E28,$9028,$9001
		dc.w	$5FFB,$8614,$6404,$5800,$F73D,$EADA,$0B0A,$0130
		dc.w	$FBFD,$E50E,$0405,$0002,$6304,$4001,$9FFE,$6801
		dc.w	$2E00,$4000,$9E00,$6000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0107,$001F,$01E7,$0000
		dc.w	$1CC3,$4101,$BE7C,$81F6,$7F7B,$0833,$00C0,$80B4
		dc.w	$EE02,$297C,$0A81,$150A,$41D7,$2E29,$9028,$FC00
		dc.w	$2FF9,$D606,$0406,$2800,$F71D,$CEFE,$0802,$0338
		dc.w	$F3FD,$6C0E,$0C05,$0002,$40E0,$6605,$99FA,$4805
		dc.w	$5C00,$0000,$BC00,$4000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$000F,$000F,$00F7,$0008
		dc.w	$ABF3,$AA41,$173C,$FDF6,$8F7B,$8EBB,$8840,$7034
		dc.w	$EE00,$49FE,$0A01,$158A,$13D6,$EC28,$0028,$5E01
		dc.w	$17E9,$AE16,$4416,$7800,$FB5B,$A2B8,$0000,$077C
		dc.w	$F2FF,$AD0C,$0D05,$0002,$4255,$65A0,$980A,$4B7D
		dc.w	$5C00,$0000,$BC00,$4000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0087,$0007,$00FF,$0000
		dc.w	$2B75,$0AC3,$B53C,$FF74,$7F7F,$48B5,$0040,$8030
		dc.w	$2C08,$E9F6,$CA01,$14CA,$13D6,$EC38,$0028,$7E01
		dc.w	$17E9,$CE17,$2416,$1800,$FD5F,$8CBE,$0200,$077C
		dc.w	$F2FF,$3D0C,$0D05,$0002,$E5B1,$0A46,$D008,$65BB
		dc.w	$3800,$0000,$F800,$0000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0043,$0007,$007B,$0000
		dc.w	$6B75,$4EC3,$F13C,$BB74,$7F7F,$188D,$0074,$8030
		dc.w	$E808,$29F6,$0E01,$10CA,$53D6,$AC28,$0028,$7E01
		dc.w	$0F89,$D777,$2476,$1800,$F219,$03F8,$0604,$0F3E
		dc.w	$F23D,$1DDE,$0DC5,$0000,$D529,$2AD6,$D008,$652B
		dc.w	$7000,$0000,$F000,$0000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0020,$0007,$0038,$0000
		dc.w	$6B75,$4FC7,$F038,$BB74,$7FDC,$1807,$0073,$80B0
		dc.w	$7800,$D9FE,$8E01,$00CA,$15DE,$6820,$8220,$FE01
		dc.w	$CF89,$1676,$2476,$D800,$7089,$954D,$8230,$099A
		dc.w	$D23F,$2DCC,$2DC5,$0002,$F109,$0EB4,$D04B,$6148
		dc.w	$E000,$0000,$E000,$0000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0011,$0006,$0018,$0001
		dc.w	$8B75,$2FCF,$D230,$597C,$7FCF,$6B24,$0050,$8090
		dc.w	$E880,$4D7E,$0A01,$14CA,$11CE,$EC34,$0230,$7201
		dc.w	$1F89,$C776,$2476,$9800,$689A,$8D4E,$8230,$1DDB
		dc.w	$D23F,$2DDC,$2DC5,$0002,$500F,$6730,$98C7,$68D8
		dc.w	$C000,$0000,$C000,$0000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0009,$0002,$000C,$0001
		dc.w	$8885,$434F,$B4B0,$094C,$7FDC,$6B07,$0073,$80B0
		dc.w	$6B02,$C87C,$8E81,$114A,$23FE,$DC04,$0200,$6201
		dc.w	$4789,$9F76,$2476,$C000,$609C,$A94A,$8630,$11DD
		dc.w	$D23D,$ADDE,$2DC5,$0002,$7137,$0800,$F7FF,$4800
		dc.w	$8000,$0000,$8000,$0000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0000,$0000,$0000,$0000,$0002,$0000,$0003,$0000
		dc.w	$8885,$435B,$B4A4,$494C,$7FDC,$6B23,$0043,$80B0
		dc.w	$6B48,$C8B6,$8E01,$11CA,$41FE,$3C04,$8204,$C201
		dc.w	$078A,$7F75,$8475,$2000,$F89F,$7559,$1221,$0DDE
		dc.w	$EA3D,$D5DC,$15C7,$0000,$7036,$0800,$F7FE,$4800
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$8885,$0363,$F49C,$0954,$7F6C,$6393,$0043,$80A0
		dc.w	$6A08,$89F6,$8E01,$10CA,$63BA,$8C80,$1200,$7245
		dc.w	$970A,$66F5,$0CF5,$B800,$D89B,$157D,$0200,$3DFB
		dc.w	$6A1D,$15EC,$15E7,$8000,$7038,$4000,$BFF8,$4000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0015,$0073,$000C,$0014,$7F7C,$7393,$0063,$80B0
		dc.w	$7A40,$99BE,$8E01,$00CA,$03FE,$6A46,$9404,$9601
		dc.w	$97CC,$4E33,$2433,$9000,$401C,$DDFB,$8200,$2D3E
		dc.w	$467C,$798C,$3987,$8000,$7000,$C000,$7800,$8000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0015,$0073,$000C,$0014,$7F7C,$7393,$0063,$80B0
		dc.w	$6C02,$C9FD,$8E00,$10CB,$87FE,$6A06,$9400,$9601
		dc.w	$0FEC,$7713,$8C13,$3800,$E518,$70FC,$2A03,$1D3C
		dc.w	$E6FC,$D91C,$9907,$0000,$F000,$4000,$7800,$8000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0015,$0013,$007C,$0064,$7F7C,$7397,$0063,$8030
		dc.w	$6E08,$C9F3,$8E04,$10CD,$83FE,$6606,$9800,$9A01
		dc.w	$07E8,$D617,$2C17,$8800,$E518,$70FC,$0A03,$3D38
		dc.w	$E2FC,$DD0C,$1D07,$8000,$F000,$4000,$7800,$8000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0055,$0013,$007C,$0064,$7F5E,$7385,$0071,$8030
		dc.w	$6800,$C96B,$8E94,$1015,$81FE,$E606,$1800,$9801
		dc.w	$47E9,$1716,$AC16,$5800,$8559,$30BC,$0A0B,$5D70
		dc.w	$32FC,$8D1E,$0D05,$4002,$F000,$4000,$7800,$8000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0073,$0051,$003C,$0066,$7F58,$7393,$0063,$8034
		dc.w	$6849,$C9B2,$8E04,$10CD,$81FC,$EE04,$1000,$9003
		dc.w	$47E1,$951E,$2C1E,$D800,$E53D,$D0DA,$4A08,$2D37
		dc.w	$F0FC,$6F16,$4F05,$8002,$7000,$C000,$3800,$C000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0073,$0071,$001C,$0066,$7F78,$7393,$0063,$8034
		dc.w	$6841,$C9BA,$8E04,$10C5,$81FE,$FE06,$0000,$8001
		dc.w	$02FC,$52CF,$A803,$0D00,$453A,$70DD,$0A00,$ED3E
		dc.w	$C7E9,$5E6A,$1801,$E016,$7000,$4000,$B800,$4000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0073,$0071,$001C,$0066,$7F5B,$7380,$0070,$8034
		dc.w	$E845,$49AA,$0E14,$10D5,$8DFE,$F206,$0000,$8C01
		dc.w	$83F1,$518E,$280E,$8C00,$0510,$50F2,$6A0D,$CD39
		dc.w	$91F9,$4E30,$0E03,$A004,$7000,$4000,$B800,$4000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0072,$0070,$001C,$0067,$8C4C,$8CA7,$8053,$7390
		dc.w	$A854,$098B,$0E34,$50F5,$43FE,$3CC6,$8000,$EE01
		dc.w	$17E1,$E71F,$081E,$3800,$C508,$B0D6,$8A29,$6D0D
		dc.w	$30FD,$FF1E,$2F01,$C002,$7000,$4000,$B800,$4000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0061,$0063,$004C,$0034,$7FEC,$7317,$0043,$80A0
		dc.w	$6804,$C9EB,$8E14,$10D5,$13FE,$6CC6,$8000,$FE01
		dc.w	$01E0,$F11E,$081E,$BE01,$8548,$D087,$2A38,$CD5C
		dc.w	$20F1,$AF12,$4F01,$B00E,$7000,$C000,$3800,$C000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0065,$0063,$006C,$0014,$4F46,$4FA9,$0059,$B090
		dc.w	$F848,$1936,$0E81,$004A,$12FA,$ED42,$0100,$7E05
		dc.w	$93F1,$430F,$280F,$9C00,$4548,$9087,$2A38,$4D5C
		dc.w	$11F8,$BE1A,$5E01,$8006,$7000,$C000,$3800,$C000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0065,$0063,$006C,$0014,$6FE6,$6DDB,$0019,$9000
		dc.w	$9AA1,$785E,$6D1E,$03C0,$005A,$FFA2,$FFA0,$0005
		dc.w	$83EF,$5213,$2811,$9C00,$654A,$8085,$3A38,$CD5E
		dc.w	$1EFA,$B908,$5101,$A006,$7000,$C000,$3800,$C000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0065,$0063,$006C,$0014,$7FD6,$7C69,$0029,$8000
		dc.w	$98BE,$7B50,$6C00,$02C1,$F3FE,$8D76,$0C00,$0001
		dc.w	$D3FF,$0A83,$2000,$D401,$894A,$5481,$223C,$9D5A
		dc.w	$1FFA,$9828,$6001,$9006,$F000,$4000,$7800,$8000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0065,$0063,$006C,$0014,$F356,$EDE9,$8CA9,$0000
		dc.w	$901F,$72E8,$6520,$0B40,$804E,$7FB6,$7FB0,$0001
		dc.w	$17E6,$CE5E,$2419,$9001,$8A4A,$5181,$263C,$995A
		dc.w	$4CFE,$8F4C,$7305,$9002,$F000,$4000,$7800,$8000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0067,$0061,$006C,$0016,$F6F6,$CD7D,$8909,$0000
		dc.w	$B85F,$5AA0,$4D20,$0340,$804F,$7FB7,$7FB1,$0000
		dc.w	$07FF,$DE0E,$2402,$8001,$0200,$D8C3,$273C,$10DA
		dc.w	$4FFE,$1E0C,$E805,$0002,$F000,$4000,$7800,$8000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0061,$0067,$0068,$0012,$FF7F,$FB96,$8080,$0000
		dc.w	$3CDE,$DA20,$C520,$0BC1,$FFCF,$C037,$0031,$0000
		dc.w	$03CB,$FA3A,$0033,$A404,$0200,$D8D3,$272C,$10CA
		dc.w	$4A7A,$0B88,$F981,$0406,$7000,$C000,$3800,$C000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0061,$0065,$004A,$0030,$F7FE,$FBF1,$8801,$0000
		dc.w	$627E,$A190,$8C00,$1A41,$FFDC,$0024,$0021,$0003
		dc.w	$81B4,$3846,$4043,$C60A,$0A02,$D0D1,$272C,$18CA
		dc.w	$45B2,$0440,$F841,$0A0E,$7000,$C000,$7800,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0060,$0064,$006A,$0011,$AFB8,$AFB7,$AFA7,$5040
		dc.w	$F1FF,$3A10,$0400,$13C0,$F23A,$0DCB,$0DC0,$0006
		dc.w	$55F0,$8DA2,$6401,$F20C,$C222,$1859,$27A4,$D042
		dc.w	$41F4,$08B5,$F006,$0609,$7000,$4000,$F800,$8000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0062,$0064,$006A,$0011,$000F,$000F,$0000,$FFF0
		dc.w	$48E0,$7520,$0200,$DCDF,$0FE9,$0E68,$0006,$F01D
		dc.w	$4606,$1E04,$A605,$71FA,$6310,$9808,$27E7,$5010
		dc.w	$440F,$0C0C,$F40C,$03F3,$7000,$4000,$F800,$8000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0060,$0064,$006B,$0010,$2840,$10A0,$EF5F,$10A0
		dc.w	$C549,$0A84,$703B,$9744,$7F68,$0090,$FF67,$0098
		dc.w	$5388,$A807,$07F0,$D009,$0A52,$0108,$F4E5,$0B12
		dc.w	$423A,$1C01,$E1FE,$1200,$7000,$4000,$F800,$8000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0061,$0064,$006A,$0015,$9032,$0584,$6A49,$95B2
		dc.w	$5A01,$35F0,$980F,$CE30,$5E21,$0082,$FF7C,$0081
		dc.w	$5211,$A806,$07E8,$D019,$81F0,$0208,$7CE7,$8110
		dc.w	$310A,$0C00,$C2FF,$3301,$7000,$C000,$7800,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0060,$006B,$0064,$0014,$75AF,$00EF,$FF10,$FFBF
		dc.w	$D5D0,$2083,$DF7C,$DFFC,$0080,$7F7F,$8080,$8080
		dc.w	$2FFF,$867A,$79CD,$7FB7,$8000,$BDF7,$4208,$C208
		dc.w	$3FFF,$ABCD,$5672,$7DBF,$D000,$C000,$7800,$8000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0076,$0079,$0070,$000F,$005F,$F000,$0FFF,$F000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FF70,$0002,$FFFD,$0002
		dc.w	$0D00,$0008,$FFF7,$0008,$FCE7,$0000,$FFFF,$0000
		dc.w	$E016,$0200,$FDFF,$0200,$9000,$4800,$B000,$4800
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$007C,$0062,$0061,$001E,$004F,$E000,$1FFF,$E000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFF0,$0000,$FFFF,$0000
		dc.w	$0FDE,$2000,$DFFF,$2000,$01F0,$0000,$FFFF,$0000
		dc.w	$0F7E,$0000,$FFFF,$0000,$B000,$4800,$B000,$4800
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		dc.w	$0070,$004F,$0040,$003F,$0201,$E000,$1FFF,$E000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFFC,$0000,$FFFF,$0000
		dc.w	$0FFF,$0000,$FFFF,$0000,$FC07,$0000,$FFFF,$0000
		dc.w	$FFFE,$0000,$FFFF,$0000,$B000,$0800,$F000,$0800
	rept	3
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
	rept	10
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
	endr		
	rept	10
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr		
		even

IMG_BSW1:
	rept	3
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$2000,$0000,$0000,$2000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0004,$0000,$0000,$0004
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$2000,$0000,$0000,$2000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0004,$0000,$0000,$0004
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$2000,$0000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0004,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$2000,$0000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0004,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$5000,$0000,$2000,$5000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$000A,$0000,$0004,$000A
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$2000,$0000,$5000,$0000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0004,$0000,$000A,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$2000,$0000,$5000,$0000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0004,$0000,$000A,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$7000,$0000,$2000,$0000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$000E,$0000,$0004,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$7000,$0000,$2000,$0000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$000E,$0000,$0004,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$7000,$0000,$F800,$0000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$000E,$0000,$001F,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$5000,$2000,$F800,$0000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$000A,$0004,$001F,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0001,$0000
		dc.w	$8800,$5000,$5400,$2000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0011,$000A,$002A,$0004
		dc.w	$0000,$0000,$8000,$0000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0006,$0000
		dc.w	$8C00,$7000,$8B00,$0000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0031,$000E,$00D1,$0000
		dc.w	$8000,$0000,$6000,$0000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$009E,$0001,$0067,$0080
		dc.w	$03C8,$FC00,$0730,$7008,$0004,$0000,$0002,$0000
		dc.w	$0000,$0000,$0000,$0000,$0080,$0000,$0F00,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$2000,$0000,$4000,$0000,$13C0,$003F,$0CE0,$100E
		dc.w	$7900,$8000,$E600,$0100,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0C7C,$0002,$039E,$0C01
		dc.w	$0000,$FFFF,$0000,$0000,$0001,$FFFE,$0000,$0000
		dc.w	$C000,$0000,$0000,$0000,$0E00,$01FF,$3200,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0003,$F800,$0000,$0000
		dc.w	$8000,$7FFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$3E30,$4000,$79C0,$8030,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$009E,$0001,$0067,$0080
		dc.w	$3C21,$C2FA,$1E03,$0154,$F1C6,$0001,$CE38,$01C0
		dc.w	$2000,$C000,$1000,$0000,$307C,$0E02,$419E,$0001
		dc.w	$21F1,$FA00,$03CE,$5401,$C804,$0003,$3008,$C000
		dc.w	$638F,$8000,$1C73,$0380,$843C,$5F43,$C078,$2A80
		dc.w	$7900,$8000,$E600,$0100,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0006,$0000
		dc.w	$B843,$45F4,$BC07,$02A8,$E38F,$0000,$9C73,$0380
		dc.w	$8800,$7000,$C001,$0000,$48F8,$3005,$873C,$0802
		dc.w	$43E3,$F400,$079C,$A803,$8811,$000E,$7003,$8000
		dc.w	$F1C7,$0000,$CE39,$01C0,$C21D,$2FA2,$E03D,$1540
		dc.w	$8000,$0000,$6000,$0000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0001,$0000
		dc.w	$BFFF,$4000,$3000,$0000,$FFFF,$0000,$0003,$0000
		dc.w	$0400,$B800,$8001,$5000,$B1FF,$4000,$8E00,$3000
		dc.w	$FFFF,$0000,$0000,$0000,$D820,$001D,$2001,$000A
		dc.w	$FFFF,$0000,$C000,$0000,$FFFD,$0002,$000C,$0000
		dc.w	$0000,$0000,$8000,$0000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$2800,$5000,$B000,$0000,$0003,$0000,$0004,$0000
		dc.w	$9201,$7C00,$0006,$2800,$6700,$8000,$1800,$6000
		dc.w	$0000,$0000,$0000,$0000,$3849,$403E,$0000,$0014
		dc.w	$C000,$0000,$2000,$0000,$0014,$000A,$000D,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0800,$6000,$A000,$1000,$0000,$0000,$0001,$0000
		dc.w	$6002,$1A01,$8106,$1400,$D800,$0000,$2000,$C000
		dc.w	$0000,$0000,$0000,$0000,$3806,$4058,$1081,$0028
		dc.w	$0000,$0000,$8000,$0000,$0010,$0006,$0005,$0008
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0800,$5000,$0000,$2000,$0000,$0000,$0000,$0000
		dc.w	$2305,$1402,$0608,$0801,$A000,$0000,$4000,$8000
		dc.w	$0000,$0000,$0000,$0000,$38C4,$4028,$3060,$0010
		dc.w	$0000,$0000,$0000,$0000,$0010,$000A,$0000,$0004
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0800,$7000,$0000,$1000,$0000,$0000,$0000,$0000
		dc.w	$178B,$0804,$0710,$0003,$4000,$0000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$39E8,$4010,$30E0,$0000
		dc.w	$0000,$0000,$0000,$0000,$0010,$000E,$0000,$0008
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$1800,$7000,$0000,$2000,$0000,$0000,$0000,$0000
		dc.w	$0B8A,$0404,$1219,$0002,$8000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$29D0,$5020,$3048,$0000
		dc.w	$0000,$0000,$0000,$0000,$0018,$000E,$0000,$0004
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$2800,$7000,$0000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0354,$0408,$08A3,$0004,$8000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0AC0,$6020,$2110,$1000
		dc.w	$0000,$0000,$0000,$0000,$0014,$000E,$0000,$0008
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0800,$7000,$0000,$2000,$0000,$0000,$0000,$0000
		dc.w	$0451,$0208,$01B6,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0A20,$5040,$0580,$2000
		dc.w	$0000,$0000,$0000,$0000,$0010,$000E,$0000,$0004
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0800,$6000,$0000,$1000,$0000,$0000,$0000,$0000
		dc.w	$0452,$0208,$01B4,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0A20,$7040,$0580,$1000
		dc.w	$0000,$0000,$0000,$0000,$0010,$0006,$0000,$0008
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0800,$5000,$1000,$2000,$0000,$0000,$0000,$0000
		dc.w	$00E2,$0210,$050C,$00C0,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1F00,$7040,$00A0,$2300
		dc.w	$0000,$0000,$0000,$0000,$0010,$000A,$0008,$0004
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$1000,$6FFF,$3000,$0000,$0000,$FFC0,$0000,$0000
		dc.w	$00E4,$0113,$0008,$00C0,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$2F00,$F080,$0000,$1300
		dc.w	$0000,$03FF,$0000,$0000,$0008,$FFF6,$000C,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3E38,$4000,$39C7,$0038,$F840,$05E0,$3C00,$0280
		dc.w	$00AF,$0110,$0043,$0080,$843E,$5F40,$C079,$2A80
		dc.w	$38F8,$0005,$C73C,$3802,$4D00,$F080,$0200,$A100
		dc.w	$021F,$07A0,$003C,$0140,$1C7C,$0002,$E39C,$1C00
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3C71,$4000,$338E,$0070,$F090,$0BE0,$7800,$0540
		dc.w	$002F,$0110,$00C7,$0000,$087C,$BE80,$80F3,$5500
		dc.w	$71F0,$000B,$8E78,$7005,$8C00,$E080,$0300,$5000
		dc.w	$090F,$07D0,$001E,$02A0,$8E3C,$0002,$71CC,$0E00
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$7FFF,$0000,$0000,$0000,$FF88,$0050,$0010,$0020
		dc.w	$003F,$0100,$00C0,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FC00,$0080,$0300,$0000
		dc.w	$11FF,$0A00,$0800,$0400,$FFFE,$0000,$0000,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$7FFF,$0000,$0000,$001F,$F860,$0030,$0007
		dc.w	$FE60,$011F,$0080,$FE00,$0000,$FFF0,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$067F,$0080,$0100,$007F
		dc.w	$F800,$061F,$0C00,$E000,$0000,$FFFE,$0000,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$238F,$4000,$1C73,$0380,$883F,$5040,$C030,$2007
		dc.w	$FEE2,$011F,$0000,$FE05,$1F10,$A000,$3CE0,$4000
		dc.w	$0000,$0000,$0000,$0000,$077F,$0080,$0000,$007F
		dc.w	$FC11,$020A,$0C03,$E004,$F1C4,$0002,$CE38,$01C0
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$071F,$4000,$38E7,$0700,$083F,$B040,$8030,$5007
		dc.w	$FEE4,$011F,$0040,$FE0A,$3E30,$4000,$79C0,$8020
		dc.w	$0000,$0000,$0000,$0000,$077F,$0080,$0200,$007F
		dc.w	$FC10,$020D,$0C01,$E00A,$F8E0,$0002,$E71C,$00E0
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0FFF,$4000,$3000,$0000,$983F,$7040,$0020,$2007
		dc.w	$FEE8,$011F,$00C0,$FE04,$00F0,$FF00,$0000,$0060
		dc.w	$0000,$0000,$0000,$0000,$077F,$0080,$0300,$007F
		dc.w	$FC19,$020E,$0400,$E004,$FFF0,$0002,$000C,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$1800,$4000,$27FF,$1000,$2838,$7040,$8007,$1000
		dc.w	$00E0,$011E,$FEC1,$0008,$00F0,$0000,$FF00,$0060
		dc.w	$0000,$0000,$0000,$0000,$0700,$0080,$037F,$0000
		dc.w	$1C14,$020E,$E001,$0008,$0018,$0002,$FFE4,$0008
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$4000,$07FF,$3000,$0828,$7040,$8017,$2000
		dc.w	$00A0,$015A,$FEC1,$0004,$00D0,$0000,$FF20,$0040
		dc.w	$0000,$0000,$0000,$0000,$0500,$0280,$037F,$0000
		dc.w	$1410,$020E,$E801,$0004,$001C,$0002,$FFE0,$000C
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$4000,$07FF,$3000,$0808,$6040,$8037,$1000
		dc.w	$0020,$0196,$FE85,$0048,$0090,$0000,$FF60,$0000
		dc.w	$0000,$0000,$0000,$0000,$0400,$0180,$017F,$0200
		dc.w	$1010,$0206,$EC01,$0008,$001C,$0002,$FFE0,$000C
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$2800,$4000,$17FF,$2000,$0808,$5040,$9037,$2000
		dc.w	$0024,$015A,$FE0D,$0080,$0090,$0000,$FF60,$0000
		dc.w	$0000,$0000,$0000,$0000,$0400,$0280,$007F,$0100
		dc.w	$1010,$020A,$EC09,$0004,$0014,$0002,$FFE8,$0004
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0800,$4000,$37FF,$0000,$1818,$6040,$B027,$0010
		dc.w	$002C,$01D2,$FE0D,$0040,$00B0,$0000,$FF40,$0000
		dc.w	$0000,$0000,$0000,$0000,$0400,$0380,$007F,$0200
		dc.w	$1818,$0206,$E40D,$0800,$0010,$0002,$FFEC,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0800,$47FF,$3000,$0000,$3838,$C040,$3007,$0030
		dc.w	$006F,$01D0,$FE0C,$0080,$FFF0,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0600,$0380,$007F,$0100
		dc.w	$1C1C,$0203,$E00C,$0C00,$0010,$FFE2,$000C,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$1F08,$40BE,$2780,$0055,$783F,$8040,$F000,$0030
		dc.w	$FEAE,$01D0,$0009,$0040,$38F0,$0000,$C720,$3800
		dc.w	$0000,$0000,$0000,$0000,$057F,$0380,$0000,$0200
		dc.w	$FC1E,$0201,$000F,$0C00,$10F8,$7D02,$01E4,$AA00
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3E10,$417D,$0F01,$00AA,$F82F,$0040,$E010,$0020
		dc.w	$FE2C,$01D0,$0003,$0080,$71F0,$0000,$8E60,$7000
		dc.w	$0000,$0000,$0000,$0000,$047F,$0380,$0000,$0100
		dc.w	$F41F,$0200,$0807,$0400,$087C,$BE82,$80F0,$5500
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$7FFF,$0000,$0000,$0000,$F80F,$0040,$0030,$0000
		dc.w	$FE2F,$0190,$0000,$0040,$FFF0,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$047F,$0180,$0000,$0200
		dc.w	$F01F,$0200,$0C00,$0000,$FFFE,$0000,$0000,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$7FFF,$0000,$0000,$000F,$FF80,$0070,$0000
		dc.w	$FE20,$015F,$0040,$0080,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$047F,$FA80,$0200,$0100
		dc.w	$F000,$01FF,$0E00,$0000,$0000,$FFFE,$0000,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3087,$4BE8,$380F,$0550,$C71F,$0000,$38EF,$0700
		dc.w	$FC6C,$0290,$FCC3,$0100,$71F0,$000B,$8E78,$7005
		dc.w	$87C7,$E800,$0F38,$5007,$1E3F,$0140,$E33F,$0080
		dc.w	$F8E3,$0000,$F71C,$00E0,$E10C,$17D2,$F01C,$0AA0
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$210F,$57D0,$301E,$0AA0,$8E3F,$0000,$71DF,$0E00
		dc.w	$FCE8,$0310,$FDA7,$0000,$E3E1,$0017,$1CF0,$E00A
		dc.w	$0F8E,$D000,$1E71,$A00E,$3F3F,$00C0,$C5BF,$0000
		dc.w	$FC71,$0000,$FB8E,$0070,$F084,$0BEA,$780C,$0550
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0FFF,$6000,$2000,$1000,$FFFF,$0000,$003F,$0000
		dc.w	$FDF1,$0208,$FD96,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$BFBF,$4040,$11BF,$0000
		dc.w	$FFFF,$0000,$FC00,$0000,$FFF0,$0006,$0004,$0008
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0FFF,$5000,$07FF,$2000,$FFFF,$0000,$FFFF,$0000
		dc.w	$FDD3,$0208,$FDA4,$0002,$FFFF,$0000,$FFFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$BBBF,$4040,$B5BF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFF0,$000A,$FFE0,$0004
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0FFF,$7000,$07FF,$1000,$FFFF,$0000,$FFFF,$0000
		dc.w	$FBD7,$0408,$FB20,$0007,$FFFF,$0000,$7FFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$BBDF,$4020,$B4DF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFF0,$000E,$FFE0,$0008
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$1FFF,$7000,$07FF,$2000,$FFFF,$0000,$FFFF,$0000
		dc.w	$FB96,$0408,$FA41,$0006,$FFFF,$0000,$7FFF,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$A9DF,$5020,$B25F,$0000
		dc.w	$FFFF,$0000,$FFFF,$0000,$FFF8,$000E,$FFE0,$0004
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$2800,$77FF,$07FF,$1000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0388,$FC04,$F85B,$0000,$8000,$7FFF,$7FFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$09C0,$E03F,$A21F,$1000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0014,$FFEE,$FFE0,$0008
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0800,$77FF,$07FF,$2000,$0000,$FFFF,$FFFF,$0000
		dc.w	$0688,$F804,$F113,$0000,$C000,$3FFF,$3FFF,$0000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0960,$D01F,$808F,$2000
		dc.w	$0000,$FFFF,$FFFF,$0000,$0010,$FFEE,$FFE0,$0004
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0800,$6000,$0000,$17FF,$0000,$0000,$0000,$FFFF
		dc.w	$0505,$0802,$020C,$F000,$C000,$0000,$0000,$3FFF
		dc.w	$0000,$0000,$0000,$FFFF,$08A0,$7010,$0040,$900F
		dc.w	$0000,$0000,$0000,$FFFF,$0010,$0006,$0000,$FFE8
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0800,$5000,$1000,$27FF,$0000,$0000,$0000,$FFFF
		dc.w	$0905,$1002,$0608,$E000,$C000,$2000,$C000,$1FFF
		dc.w	$0000,$0000,$0000,$FFFF,$1890,$7008,$0060,$A007
		dc.w	$0000,$0000,$0000,$FFFF,$0010,$000A,$0008,$FFE4
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$1800,$67FF,$3000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$1202,$E001,$0C04,$0000,$C000,$3FFF,$E000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$2848,$F007,$0030,$1000
		dc.w	$0000,$FFFF,$0000,$0000,$0018,$FFE6,$000C,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$47FF,$3000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$2401,$C000,$1802,$0000,$0000,$DFFF,$C000,$2000
		dc.w	$0000,$FFFF,$0000,$0000,$0824,$F003,$0018,$2000
		dc.w	$0000,$FFFF,$0000,$0000,$001C,$FFE2,$000C,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3800,$47FF,$B000,$07FF,$0000,$FFFF,$0000,$FFF8
		dc.w	$C800,$0000,$3000,$0000,$4800,$3FFF,$4000,$147F
		dc.w	$0000,$FFFF,$0000,$FFFF,$0813,$E000,$000C,$9000
		dc.w	$0000,$FFFF,$0000,$1FFF,$001C,$FFE2,$000D,$FFE0
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$3000,$4FFF,$A000,$0000,$0007,$FFF8,$0006,$0000
		dc.w	$9000,$0000,$6000,$0000,$3080,$1D7F,$0180,$0A00
		dc.w	$0000,$FFFF,$0000,$0000,$0809,$D000,$1006,$2000
		dc.w	$E000,$1FFF,$6000,$0000,$000C,$FFF2,$0005,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0001,$0000
		dc.w	$B1C7,$4000,$0E39,$01C0,$C21F,$2FA0,$E03C,$1540
		dc.w	$6000,$0000,$8000,$0000,$19F1,$0200,$03CE,$0401
		dc.w	$C7C2,$002F,$39E0,$C015,$1806,$A000,$3001,$4000
		dc.w	$F843,$05F4,$3C07,$02A8,$E38D,$0002,$9C70,$0380
		dc.w	$0000,$0000,$8000,$0000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0006,$0000
		dc.w	$A38F,$4000,$9C73,$0380,$843F,$5F40,$C078,$2A80
		dc.w	$8000,$0000,$0000,$0000,$07E3,$0000,$009C,$0003
		dc.w	$8F84,$005F,$73C0,$802A,$3801,$4000,$7000,$8000
		dc.w	$FC21,$02FA,$1E03,$0154,$F1C5,$0002,$CE39,$01C0
		dc.w	$8000,$0000,$6000,$0000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$009E,$0001,$0067,$0080
		dc.w	$3FFF,$C000,$0000,$0000,$FFFC,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$00FF,$0000,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$F800,$0000,$0000,$0000
		dc.w	$3FFF,$0000,$0000,$0000,$FFFC,$0003,$0000,$0000
		dc.w	$7900,$8000,$E600,$0100,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0C7C,$0002,$039E,$0C01
		dc.w	$21F1,$FA00,$03CE,$5401,$8000,$0000,$0000,$8000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0001,$0000,$0000,$0001,$8F84,$005F,$73C0,$802A
		dc.w	$3E30,$4000,$79C0,$8030,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$009E,$0001,$0067,$0080
		dc.w	$03C8,$FC00,$0730,$7008,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$13C0,$003F,$0CE0,$100E
		dc.w	$7900,$8000,$E600,$0100,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0001,$0000,$0006,$0000
		dc.w	$8C00,$7000,$8B00,$0000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0031,$000E,$00D1,$0000
		dc.w	$8000,$0000,$6000,$0000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0001,$0000
		dc.w	$8800,$5000,$5400,$2000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0011,$000A,$002A,$0004
		dc.w	$0000,$0000,$8000,$0000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$5000,$2000,$F800,$0000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$000A,$0004,$001F,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$7000,$0000,$F800,$0000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$000E,$0000,$001F,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$7000,$0000,$2000,$0000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$000E,$0000,$0004,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$7000,$0000,$2000,$0000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$000E,$0000,$0004,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$2000,$0000,$5000,$0000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0004,$0000,$000A,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$2000,$0000,$5000,$0000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0004,$0000,$000A,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$5000,$0000,$2000,$5000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$000A,$0000,$0004,$000A
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$2000,$0000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0004,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$2000,$0000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0004,$0000
	rept	6
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$2000,$0000,$0000,$2000,$0000,$0000,$0000,$0000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0004,$0000,$0000,$0004
	rept	6*7+2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$FCFC,$F8F8,$84AC,$0C04
		dc.w	$7E7E,$3E3E,$424A,$6060,$7EFC,$3EFC,$4294,$600C
		dc.w	$FC7E,$F83E,$244A,$8C60,$0054,$0010,$006C,$007C
		dc.w	$00FC,$00FC,$0094,$000C,$7EEE,$3EEE,$4282,$6000
		dc.w	$007E,$003E,$0042,$0060,$7C82,$7C82,$6C82,$4482
		dc.w	$FCEE,$F8EE,$8442,$0C00,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$EEEE,$FCFC,$1212,$1212
		dc.w	$EEEE,$7E7E,$9890,$9090,$EEEE,$7EEE,$9822,$9002
		dc.w	$EEEE,$EC7E,$0290,$0290,$00EE,$007C,$0092,$0092
		dc.w	$00EE,$00EE,$0022,$0002,$EEEE,$7EEE,$9820,$9000
		dc.w	$00EE,$007E,$0098,$0090,$EE82,$FE82,$92C4,$9246
		dc.w	$EE0E,$FCEE,$12E0,$12E0,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$ECEC,$ECEC,$8A8A,$0202
		dc.w	$EEEE,$EEEE,$0202,$8080,$EEEE,$EEEE,$02A0,$8002
		dc.w	$EEEE,$EEEE,$2802,$8280,$006C,$006C,$0082,$0082
		dc.w	$00EE,$00EE,$00A0,$0002,$EEEE,$EEEE,$02A2,$8000
		dc.w	$00EE,$00EE,$0002,$0080,$EEC6,$EEC6,$822A,$0028
		dc.w	$ECEE,$ECEE,$8A2A,$0200,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$EEEE,$EEEE,$2020,$0202
		dc.w	$EEEE,$EEEE,$2A28,$0000,$EEEE,$EEEE,$2A20,$0000
		dc.w	$EEEE,$EEEE,$0828,$8000,$00EE,$00EE,$0000,$0082
		dc.w	$00EE,$00EE,$0020,$0000,$EEEE,$EEEE,$2A2A,$0000
		dc.w	$00EE,$00EE,$002A,$0000,$EEFE,$EEFE,$0020,$0010
		dc.w	$EEEE,$EEEE,$2008,$0200,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$EEEC,$EEEC,$8A8A,$0202
		dc.w	$E0E0,$E0E0,$A020,$0080,$E0EE,$E0EE,$A082,$0000
		dc.w	$0EE0,$0EE0,$0220,$0080,$00EE,$00EE,$0080,$0000
		dc.w	$00EE,$00EE,$0082,$0000,$E0EE,$E0EE,$A082,$0000
		dc.w	$00EE,$00EE,$0080,$0000,$EEFE,$EEFE,$8092,$0010
		dc.w	$EEEE,$EEEE,$8A2A,$0200,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$EEEE,$FCFC,$9A9A,$1212
		dc.w	$E0E0,$E060,$0080,$0080,$E0EE,$E0EE,$0000,$0000
		dc.w	$0EE0,$0E60,$0880,$0080,$00EE,$00EE,$00AA,$0000
		dc.w	$00EE,$00EE,$0000,$0000,$E0EE,$E0EE,$0008,$0000
		dc.w	$00E0,$00E0,$0020,$0000,$EEFE,$EEEE,$AA10,$0010
		dc.w	$EEEE,$FCEE,$9A02,$1200,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$FCFC,$F8FC,$848C,$0C04
		dc.w	$F87C,$F838,$0044,$006C,$F8EE,$F8EE,$00A2,$0000
		dc.w	$0E7C,$0E38,$0044,$006C,$00FE,$00FE,$0002,$0000
		dc.w	$00EE,$00EE,$00A2,$0000,$F8EE,$F8EE,$0022,$0000
		dc.w	$00E0,$00E0,$00A0,$0000,$EEEE,$EEEE,$02A2,$0000
		dc.w	$FCEE,$F8EE,$842E,$0C00,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$E0EE,$E0FC,$203A,$0012
		dc.w	$E00E,$E00C,$8002,$0002,$E0EE,$E0EE,$8080,$0000
		dc.w	$0E0E,$0E0C,$0A02,$0002,$00EE,$00EE,$0088,$0000
		dc.w	$00EE,$00EE,$0080,$0000,$E0EE,$E0EE,$8020,$0000
		dc.w	$00E0,$00E0,$0000,$0000,$EEEE,$EEEE,$8880,$0000
		dc.w	$E0EE,$E0EE,$2000,$0000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$E0EE,$E0EE,$2020,$0002
		dc.w	$E00E,$E00E,$2008,$0002,$E0EE,$E0EE,$2000,$0000
		dc.w	$0E0E,$0E0E,$0008,$0002,$00EE,$00EE,$0022,$0000
		dc.w	$00EE,$00EE,$0000,$0000,$E0EE,$E0EE,$2082,$0000
		dc.w	$00E0,$00E0,$0020,$0000,$EEEE,$EEEE,$2200,$0000
		dc.w	$E0EE,$E0EE,$200A,$0000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$4044,$4044,$A0AA,$E0EE
		dc.w	$4004,$4004,$A00A,$E00E,$4044,$4044,$A0AA,$E0EE
		dc.w	$0404,$0404,$0A0A,$0E0E,$0044,$0044,$00AA,$00EE
		dc.w	$0044,$0044,$00AA,$00EE,$4044,$4044,$A0AA,$E0EE
		dc.w	$0040,$0040,$00A0,$00E0,$4444,$4444,$AAAA,$EEEE
		dc.w	$4044,$4044,$A0AA,$E0EE,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$E0EE,$E0EE,$0008,$0000
		dc.w	$E00E,$E00E,$800A,$0000,$E0EE,$E0EE,$8000,$0000
		dc.w	$0E0E,$0E0E,$080A,$0000,$00EE,$00EE,$0022,$0000
		dc.w	$00EE,$00EE,$0000,$0000,$E0FE,$E0EE,$8010,$0010
		dc.w	$00E0,$00E0,$0080,$0000,$EEEE,$EEEE,$2200,$0000
		dc.w	$E0EE,$E0EE,$0002,$0000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$E0EE,$E0EE,$2020,$0000
		dc.w	$E00E,$E00E,$2008,$0000,$E0EE,$E0EE,$2082,$0000
		dc.w	$0E0E,$0E0E,$0A08,$0000,$00EE,$00EE,$0020,$0000
		dc.w	$00EE,$00EE,$0082,$0000,$E0FE,$E0FE,$2092,$0010
		dc.w	$00EE,$00EE,$0020,$0000,$EEEE,$EEEE,$0082,$0000
		dc.w	$E0EE,$E0EE,$2028,$0000,$0000,$0000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$E0EE,$E0EE,$0008,$0000
		dc.w	$EEEE,$EEEE,$8220,$0000,$EEEE,$EEEE,$8222,$0000
		dc.w	$0EEE,$0EEE,$0220,$0000,$00EE,$00EE,$008A,$0000
		dc.w	$00EE,$00EE,$0022,$0000,$EEFE,$EEFE,$8220,$0010
		dc.w	$00EE,$00EE,$0002,$0080,$EEEE,$EEEE,$8022,$0000
		dc.w	$E0EE,$E0EE,$0022,$0000,$E000,$E000,$0000,$2000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$E0EE,$E0EE,$0008,$0000
		dc.w	$EEEE,$EEEE,$0AA8,$8002,$EEEE,$EEEE,$0AA2,$8000
		dc.w	$0EEE,$0EEE,$0AA8,$0002,$00EE,$00EE,$0028,$0000
		dc.w	$00EE,$00EE,$00A2,$0000,$EEC6,$EEC6,$0AAA,$8028
		dc.w	$006E,$006E,$0082,$0080,$6EEE,$6EEE,$82A2,$8000
		dc.w	$E0EE,$E0EE,$0022,$0008,$E000,$E000,$8000,$2000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$E0EE,$E0EE,$0000,$0000
		dc.w	$EEEE,$7EFC,$9012,$9012,$EEEE,$7EEE,$9020,$9000
		dc.w	$0EEE,$0EFC,$0012,$0012,$00EE,$00EE,$0082,$0000
		dc.w	$00EE,$00EE,$0020,$0000,$EEC4,$7EC4,$9046,$90C6
		dc.w	$006E,$00EE,$00E0,$0080,$EEEE,$7EEE,$9220,$9200
		dc.w	$E0EE,$E0E6,$0008,$0008,$E000,$E000,$0000,$0000
	rept	4
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
		dc.w	$0000,$0000,$0000,$0000,$E0EE,$E0EE,$0080,$000A
		dc.w	$7EFC,$3EF8,$52A4,$600C,$7EEE,$3EEE,$5282,$6000
		dc.w	$0EFC,$0EF8,$08A4,$000C,$00EE,$00EE,$0088,$0000
		dc.w	$00EE,$00EE,$0082,$0000,$7E00,$3E82,$5282,$6082
		dc.w	$003E,$001E,$0020,$0020,$5CEE,$1CEE,$7C82,$6400
		dc.w	$E0E7,$E0E3,$0024,$0006,$E000,$E000,$8000,$2000
	rept	2
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr
	rept	10
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
	endr
	rept	10
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	endr

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

TAMPON:		dc.w	$0000
PTR_TEXTE:	dc.l	TEXTE
TEXTE:    
	;dc.b        'ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789 '
	;dc.b        ',;:!?./*-+                            '

	dc.b        '                         '
	dc.b        'A NEW DAY, A NEW INTRO...'
	dc.b        '                         '
	dc.b        'BLUE SOFTWARE PRESENTS A NEW BSW DCD NUMBER 137 : PRESS KEYBOARD FOR '
	dc.b        'F1-ETERNITY SAMPLE OVERSCAN SCREEN, F2-FANATICS DENTRO, F3-OUTLINE 2005 INVITRO, '
	dc.b        'F4-PARACON 6 INVITRO, F5-PENTA (A NEW GAME FROM PARADIZE), F6-JAGUAR CONNEXION 2005 INVITRO (ENGLISH), '
	dc.b        'F7-JAGUAR CONNEXION 2005 INVITRO (FRENCH), F8-T2 INTRO, F9-DCD DOCS AND ESC-CRC CHECK.'
	dc.b        '                         '
	dc.b        'SPECIAL GREETS : '
	dc.b        'ALL TSCC MEMBERS (CONDEMNS GREAT YOUR NEW FALCON DEMO BEAMS). '
	dc.b        'TPAU OF BAC (MY OLDEST CONTACT FROM THE ATARI SCENE). '
	dc.b        'ALL MEMBERS FROM VECTRONIX AND ICS. '
	dc.b        'ALL MEMBERS FROM THE GAME COMPILATION CREWS FUZION, AUTOMATION, BBC, FOF, D-BUG, ZUUL, POMPEY PIRATES AND MEDWAY BOYS. '
	dc.b        'BITMASTER (THANKS FOR THE PLANEMAPPER - NEW VERSION). '
	dc.b        'NOXTRA (THANX FOR THE SUPPORT). '
	dc.b        'FREDDO (GREAT WORK! THE NEW LOADER WORKS FINE). '
	dc.b        'ALL MEMBERS FROM THE DEMO COMPILATION CREWS RIPPED OFF, POV, NEW POWER GENERATION, STAX, ANIMAL MINE, EFFECT, FUTURE MINDS AND STRANGER. '
	dc.b        'ALL MEMBERS FROM WWW.ATARI-FORUM.COM. '
	dc.b        'AND ALL, WICH I FORGOT....'
	dc.b        '                                           '
	dc.b        'NOEXTRA IS FURIOUSLY ACTIVE FOR MORE INTRO GUYS! BIG THANKS FOR ALL GFXS BY MISTER.A AND THE REST OF THIS PIECE OF CODE BY ZORRO2 HIMSELF! '
	dc.b        'MAIN CODE BY ATOMUS WHO APOLOGIZE FOR THE SCROLLING - BUG - DUE TO A 3D EFFECT WHO WORK IN REAL TIME... IN OVERSCAN... (BOTTOM ONLY!) '
	dc.b        'MUSIC BY FRAZER, IT COMES FROM THE BEST COMPILATION OF PHF BY GRAZEY. THANKS DUDE TO SHARE ALL THIS MUSICS! '
	dc.b        'THIS COMPILATION COME FROM THE BYTE OF TCE AND HE COMPRESS AND RE-COMPRESS HIMSELF FOR MORE STUFF ON THIS FLOPPY!'
	dc.b        '                                           '
	dc.b        'THIS PIECE OF CODETRO HAS BEEN FINISHED NEAR THE 29 MAY 2005 IN FRANCE :-) '
	dc.b        '                                           '
	dc.b        'SEE YA FOR AN ANOTHER INTRO................'
	dc.b        '                                           '
	dc.b        '                                           '
	
	dc.w        $FF00
	EVEN				      	

music	INCBIN	"tsc_42.snd"
	even

******************************************************************

	SECTION	BSS

Code_gen:         ds.w	(2*NB_BLOC_SUPP)*NB_LIGNE_GENERE		* Place pour le code genere
									   									* pour l'effacement de l'elt 3d
								  ds.w	1							* Place pour le rts
rien            	ds.b	10000

BUFF_P1:	ds.b	41
BUFF_P2:	ds.b	1
BUFF_P3:	ds.b	3494

Vsync:	ds.b	1
        ds.b	1
        
go	ds.b	1

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
	ds.b	160*50
Zorro_screen1_len:	equ	*-start1

Zorro_scr2:	ds.l	1

Zorro_screen2:	
	ds.b	256
start2:	
	ds.b	160*200
	ds.b	160*50
Zorro_screen2_len:	equ	*-start2


	END
