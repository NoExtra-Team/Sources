init_Bars:
	move #$2700,sr
	ANDI.B    #$DF,$FFFA09.L
	ANDI.B    #$FE,$FFFA07.L
	MOVE.L    #Hbl_Bars,$120.L 
	ORI.B     #1,$FFFFFA07.L
	ORI.B     #1,$FFFFFA13.L
	stop	#$2300
	lea	Vbl_Bars(pc),a0                   ; Launch VBL
	move.l	a0,$70.w                 ;
.init_Params_Bars:
	move.w #10,param_0_Bars
	move.w #40,param_1_Bars
	move.w #10,param_2_Bars
	move.w #12,param_3_Bars
	move.w #14,param_4_Bars
	move.w #16,param_5_Bars
	rts

Vbl_Bars:
      st	Vsync                    ; Synchronisation

      CLR.B     $FFFFFA1B.W 
      MOVE.B    #1,$FFFFFA21.L
      MOVE.B    #8,$FFFFFA1B.L
      MOVE.L    #Hbl_Bars,$120.L 

      MOVEM.L   A0-A6/D0-D7,-(a7) 
      BSR.s       display_Bars 
      MOVEM.L   (a7)+,A0-A6/D0-D7 

	jsr 	(MUSIC_INTRO+8)                  ; Play SNDH music

      RTE

display_Bars:
      MOVEA.L   #Buffer_L7Z+160*200+256,A0 
      MOVEq.W    #100-1,D0 
.L0:  MOVE.L    #$0,(A0)+
      DBF       D0,.L0

      MOVEA.L   #param_0_Bars,A0 
      MOVEA.L   #Couleurs_rasters,A1 
      MOVEA.L   #Courbes_rasters,A2 
      MOVEA.L   #param_3_Bars,A3 
      MOVEq.W    #3-1,D0 
loop: MOVEA.L   #Buffer_L7Z+160*200+256,A4 
      MOVEQ.w     #0,D1 
      MOVE.W    (A0),D1 
      MOVE.W    (A3)+,D2
      ADD.W     D2,(A0) 
      CMPI.W    #$830,(A0)
      BLT       .next 
      SUBI.W    #2096,(A0)
.next:ADDQ.L    #2,A0 
      MOVE.W    0(A2,D1.W),D1 
      ADDA.L    D1,A4 
      MOVE.W    #12,D1	;	hauteur
.l1:  MOVE.W    (A1)+,D2
      ADD.W     D2,(A4)+
      ADD.W     D2,(A4)+
      ADD.W     D2,(A4)+
      ADD.W     D2,(A4)+
      ADD.W     D2,(A4)+
      ADD.W     D2,(A4)+
      DBF       D1,.l1
      DBF       D0,loop
      RTS 

Hbl_Bars:  CLR.B     $FFFFFA1B.W 
      MOVEM.L   A0-A1/D0,-(A7) 

      MOVEA.W   #$FA21,A1 
      MOVE.B    #0,(A1) 
      MOVE.B    #8,$FFFFFA1B.W
      MOVEA.L   #Buffer_L7Z+160*200+256,A0 

      MOVE.W    #200-4,D1 
L0:   MOVE.B    (A1),D0 
.L1:  CMP.B     (A1),D0 
      BEQ       .L1 
      MOVE.W    (A0)+,$FF8256.L 
      DBF       D1,L0

      MOVE.B    (A1),D0 
.L2:  CMP.B     (A1),D0 
      BEQ       .L2 

      MOVEM.L   (A7)+,A0-A1/D0

      BCLR      #0,$FFFFFA0F.W
      RTE 
