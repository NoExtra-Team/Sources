; Text Boot-sector / Virus Detector
;
;
; (C)oderight Zorro 2/NoExtra 2007
;

	OPT	o+

BOOT	equ	1	; 0=DEVPAC / 1=BOOT

	addq.l	#4,4(sp)		;On passe le test HD sur STE
	
 IFEQ	BOOT
	SECTION TEXT

	clr.l	-(sp)
	move.w	#$20,-(sp)
	trap	#1
	move.l	d0,2(sp)
	bsr.s	start
	trap	#1
	clr.w	(sp)
	trap	#1
start:
 ENDC

**************** The boot.... ***************

.test_RESET:
	tst.w	 $42c 
	beq	 normal
	pea	 alert(pc)
	move.w	 #9,-(sp)
	trap	 #1
	addq.l	 #6,sp
	move.l	 #$31415926,$426.w
	lea	 reset(pc),a0
	move.l	 a0,$42a.w
reset:
	move.w	 #$2700,sr
	move.b	 #14,$ffff8800.w
	move.b	 $ffff8800.w,d7
	ori.b	 #$7,d7
	move.b	 d7,$ffff8802.w
	move.l	 #$78000,d0
	move.l	 d0,$44e.w
	lsr.w	 #8,d0
	move.b	 #2,$ffff820a.w
	move.w	 #7999,d7
	moveq	 #0,d0
	move.l	 #$78000,a0
clear:
	move.l	 d0,(a0)+
	dbf	 d7,clear

	addq.l	 #4,sp
	move.l	 #$10ff,d2
	move.l	 #900000,d3		
bb2:
	lea	 data(pc),a0
	move.l	 #27,d0
bb3:
	move.w	 (a0)+,$ff8240
	nop
	nop
	move.l	 #87,d1
bb4:
	dbf	 d1,bb4
	dbf	 d0,bb3
	dbeq	 d3,bb2

normal:
	PEA	text(PC)   	; title
	MOVE.W	#9,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP
	
	MOVE.B	#02,$FFFF820A.W
	MOVE.L	#$FFFF8240,A4
	MOVE.W	#$FFFF825E,A5
	MOVE.W	#$FFF,(A5)
	MOVE.L	#15,D4
	LEA	coul(PC),a6
loop1:
	move.w	(a6)+,(a4)
	MOVE.L	#0,D3
.vsync1:
	move.w	#$25,-(sp)	
	trap	#14		; Vsync
	addq.l	#2,sp
	DBRA 	D3,.vsync1
	DBRA 	D4,loop1
	
	move.l	#-1,d4
.sync:
	dcb.w	15,$4E71		; 15 nops
	dbra	d4,.sync

	MOVE.L	#15,D4
loop2:
	move.w	-(a6),d2
	move.w	d2,(a4)
	eori.w	#$FFF,d2
	move.w	d2,(a5)
	MOVE.L	#3,D3
.vsync2:
	move.w	#$25,-(sp)
	trap	#14		; Vsync
	addq.l	#2,sp
	DBRA 	D3,.vsync2
	dbra	d4,loop2

	rts	;	retour prg d'appel (Le bureau)

	SECTION DATA
	
coul:	even
	DC.W $fff,$777,$eee,$666,$ddd,$555,$ccc,$444,$bbb,$333,$aaa,$222,$999,$111,$888,$0
text:	even
	DC.B 27,"E",27,"f",27,"Y",32+11,32+9-3,"TURLUTUTU CHAPEAU POINTU #50",10,13,0
alert:	even
	DC.B 27,"E",27,"f",27,"Y",32+11,32+9-4,"SHUTDOWN YOUR ATARI ST: VIRUS!",10,13,0

data:	even
	dc.w	 $077,$176,$275,$374,$473,$572,$671,$770
	dc.w	 $661,$552,$443,$334,$225,$116,$007
	dc.w	 $107,$207,$307,$407,$507,$607,$707
	dc.w	 $617,$527,$437,$347,$257,$167,$077
	even

 IFEQ	BOOT
	END
 ENDC
