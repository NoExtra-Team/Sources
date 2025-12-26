*****************************************
*         Sinus Wave 1 bitplane         *
*****************************************
*   Original version ANGEL/HEMOROIDS    *
*---------------------------------------*
* Parameter(s)                          *
*---------------------------------------*
NBLIGNE equ 160-0 ; nb ligne to display *
BPLAN1  equ 000   ; bitplane wave 1     *
BPLAN2  equ 002   ; bitplane wave 2     *
BPLAN3  equ 004   ; bitplane wave 3     *
*****************************************
SinusWave:
.Calcul:
      MOVEA.L	physique(pc),A4
      add.w	#160*67,a4
      MOVEA.L   #SWAVE_D1,A1 
      MOVEA.L   #SWAVE_D2,A0 
      ADDA.L    PTR_SWAVE_D2,A0
      MOVEA.L   #SWAVE_D2,A2 
      ADDA.L    SWAVE_VITESSE,A2
      MOVEA.L   #TAB_SWAVES,A6 
      MOVEQ.W   #$0000,D3 ; pattern
      MOVE.W    #$FFFF,D4 ; pattern 
      MOVE.W    #NBLIGNE,D0 ;	nb de lignes
.loop:
.Sinus_1:
      MOVE.W    (A0)+,D1	; D0
      ADD.W     (A2),D1 	;	D2
      MOVE.W    0(A6,D1.W),D2 
      MOVE.W    2(A6,D1.W),D1 
      MOVEA.L   A4,A5
      ADD.W     #8*9,a5 
      ADDA.W    D1,A5 
      MOVE.W    D3,07*8+BPLAN1(A5) 
      MOVE.W    D2,08*8+BPLAN1(A5) 
      MOVE.W    D4,09*8+BPLAN1(A5) 
      MOVE.W    D4,12*8+BPLAN1(A5)
      NOT.W     D2
      MOVE.W    D2,13*8+BPLAN1(A5)
      MOVE.W    D3,14*8+BPLAN1(A5)
.Sinus_2:
      MOVE.W    (A1)+,D1	;	D1
      ADD.W     (A2)+,D1	;	D2
      MOVE.W    0(A6,D1.W),D2 
      MOVE.W    2(A6,D1.W),D1 
      MOVEA.L   A4,A5 
      ADD.W     #8*2,a5 
      ADDA.W    D1,A5 
      MOVE.W    D3,10*8+BPLAN2(A5)
      MOVE.W    D2,11*8+BPLAN2(A5)
      MOVE.W    D4,12*8+BPLAN2(A5)
      MOVE.W    D4,16*8+BPLAN2(A5)
      NOT.W     D2
      MOVE.W    D2,17*8+BPLAN2(A5)
      MOVE.W    D3,18*8+BPLAN2(A5)
.Sinus_3:
      MOVE.W    (A0)+,D1	;	D1
      ADD.W     (A1)+,D1	;	D2
      MOVE.W    0(A6,D1.W),D2 
      MOVE.W    2(A6,D1.W),D1 
      MOVEA.L   A4,A5 
      SUB.W     #8*1,a5 
      ADDA.W    D1,A5 
      MOVE.W    D3,15*8+BPLAN3(A5)
      MOVE.W    D2,16*8+BPLAN3(A5)
      MOVE.W    D4,17*8+BPLAN3(A5)
      MOVE.W    D4,20*8+BPLAN3(A5)
      NOT.W     D2
      MOVE.W    D2,21*8+BPLAN3(A5)
      MOVE.W    D3,22*8+BPLAN3(A5)

      ADDA.L    #160,A4 
      DBF       D0,.loop

      ADD.L     #2,PTR_SWAVE_D2
      ANDI.L    #$3FF,PTR_SWAVE_D2 
      ADD.L     #2*2,SWAVE_VITESSE ; vitesse de balancement
      ANDI.L    #$3FF,SWAVE_VITESSE 
      RTS 

SWAVE_D1:
	incbin	"DATAW1.DAT"
	even
SWAVE_D2:
	incbin	"DATAW2.DAT"
	even
TAB_SWAVES:
	incbin	"SWAVE.DAT"
	even

PTR_SWAVE_D2:
	DS.L	1
SWAVE_VITESSE:
	DS.L	1
	even
