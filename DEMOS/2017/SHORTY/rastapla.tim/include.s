init_rastapla:
	move #$2700,SR                   ; Interrupts OFF
	sf	$fffffa21.w
	sf	$fffffa1b.w
  MOVE.L	#HBL_RASTA,$120.W 
	bset	#0,$fffffa07.w	* Timer B on
	bset	#0,$fffffa13.w	* Timer B on
	stop #$2300                      ; Interrupts ON
	move.l	#Vbl_rastapla,$70.w
	rts

Vbl_rastapla:
	st	Vsync                        ; Synchronisation
	CLR.B     $FFFFFA1B.W 
	MOVE.B    #1,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W
	LEA       COLORS,A0
	MOVE.L    #THE_COLOR,PTR_THE_COLOR
	ADDQ.W    #2,COUNT_COLOR
	CMPI.W    #$230,COUNT_COLOR 
	BNE.S     .next 
	CLR.W     COUNT_COLOR 
.next:
	LEA       THE_COLOR,A1
	LEA       PAL_COLOR,A0
	ADDA.W    COUNT_COLOR,A0
	MOVEQ     #$17,D0 * nb de ligne à afficher
.loop:
	MOVE.W    (A0),(A1)+
	MOVE.W    2(A0),(A1)+ 
	MOVE.W    4(A0),(A1)+ 
	MOVE.W    6(A0),(A1)+ 
	MOVE.W    8(A0),(A1)+ 
	MOVE.W    10(A0),(A1)+
	MOVE.W    12(A0),(A1)+
	MOVE.W    14(A0),(A1)+
	ADDQ.W    #2,A0 
	DBF       D0,.loop
	jsr	Scrolling                       ; twice ???
	jsr	Scrolling
	movem.l	d0-d7/a0-a6,-(a7)
	jsr (MUSIC+8)                    ; Play SNDH music
	movem.l	(a7)+,d0-d7/a0-a6
	rte

COULEUR_RASTA equ $FFFF8258

HBL_RASTA:
	MOVE.L   A0,-(A7)
	MOVEA.L   PTR_THE_COLOR,A0
	MOVE.W    (A0)+,COULEUR_RASTA.W 
	MOVE.L    A0,PTR_THE_COLOR
	MOVEA.L   (A7)+,A0
	RTE 
