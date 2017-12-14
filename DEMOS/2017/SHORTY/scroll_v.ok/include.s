init_courbe_V:
      LEA       courbe_V,A0
      MOVE.W    #126,D0 
.loop:MOVE.W    (A0),D7 
      ASR.W     #3,D7 
      MOVE.W    D7,(A0)+
      DBF       D0,.loop
      rts 
      
init_texte:
      LEA       texte_V,A0
      LEA       Buffer_L7Z,A1
      LEA       fonte_V,A2
push_V:MOVE.B    (A0),D0 
      BPL.S     next_V 
      rts 
     
next_V:CLR.B     (A0)+ 
      CMP.B     #$20,D0 
      BNE.S     sub_lV 
      MOVEQ     #7,D7 
      MOVEQ     #0,D0 
.loop:MOVE.L    D0,(A1)+
      DBF       D7,.loop
      BRA.S     push_V 
sub_lV:SUB.B     #$21,D0 
      EXT.W     D0
      ASL.W     #5,D0 
      LEA       0(A2,D0.W),A6 
      MOVEQ     #$F,D7
.go_L:MOVE.W    (A6)+,(A1)+ 
      DBF       D7,.go_L
      BRA.S     push_V 

play_generated_code:
	    LEA       Buffer_L7Z,A6
      ADDA.L    compteur_V,A6
      ADDQ.L    #2,compteur_V
      CMPI.L    #$5C20,compteur_V
      BLT.S     .next 
      CLR.L     compteur_V 
.next:MOVEA.L   physique,A5
      ADD.l    #160*73+8*7+6,A5 
      LEA       courbe_V,A0
      ADDA.W    add_V,A0
      ADDQ.W    #2,add_V
      CMPI.W    #216,add_V
      BLT.S     .no_res 
      MOVE.W    #38,add_V
.no_res:JMP       Generate 
      MOVEM.L   A0-A6/D0-D7,-(A7) 
      BSR.S     loop_V 
      LEA       -8(A0,D0.L),A5
      BSR.S     loop_V 
      MOVE.L    D0,(A7) 
      MOVEA.L   A1,A4 
      MOVEA.L   A1,A6 
      ADDA.L    D0,A6 
      MOVEA.L   A6,A3 
      MOVE.B    -(A5),D7
      BSR.S     cognito 
      BSR.S     add7_V 
      BCC.S     end_V 
      MOVE.W    #4000-1,D7
lp_V1:MOVEQ     #3,D6 
lp_V2:MOVE.W    -(A3),D4
      MOVEQ     #3,D5 
lp_V3:ADD.W     D4,D4 
      ADDX.W    D0,D0 
      ADD.W     D4,D4 
      ADDX.W    D1,D1 
      ADD.W     D4,D4 
      ADDX.W    D2,D2 
      ADD.W     D4,D4 
      ADDX.W    D3,D3 
      DBF       D5,lp_V3
      DBF       D6,lp_V2
      MOVEM.W   D0-D3,(A3)
      DBF       D7,lp_V1
end_V:MOVEM.L   (A7)+,A0-A6/D0-D7 
      rts 

loop_V:MOVEQ     #3,D1 
.loop:LSL.L     #8,D0 
      MOVE.B    (A0)+,D0
      DBF       D1,.loop
      rts 

cognito:BSR.S     add7_V 
      BCC.S     doca_v2 
      MOVEQ     #0,D1 
      BSR.S     add7_V 
      BCC.S     doca_v1 
      LEA       curve_V1,A1
      MOVEQ     #4,D3 
.loop:MOVE.L    -(A1),D0
      BSR.S     adx7_V 
      SWAP      D0
      CMP.W     D0,D1 
      DBNE      D3,.loop
      ADD.L     20(A1),D1 
doca_v1:MOVE.B    -(A5),-(A6) 
      DBF       D1,doca_v1
doca_v2:CMPA.L    A4,A6 
      BGT.S     moreco 
      rts 

add7_V:ADD.B     D7,D7 
      BNE.S     .next 
      MOVE.B    -(A5),D7
      ADDX.B    D7,D7 
.next:rts 

adx7_V:MOVEQ     #0,D1 
.loop:ADD.B     D7,D7 
      BNE.S     .next 
      MOVE.B    -(A5),D7
      ADDX.B    D7,D7 
.next:ADDX.W    D1,D1 
      DBF       D0,.loop
      rts 

moreco:LEA       curve_V2,A1
      MOVEQ     #3,D2 
.lp01:BSR.S     add7_V 
      DBCC      D2,.lp01
      MOVEQ     #0,D4 
      MOVEQ     #0,D1 
      MOVE.B    1(A1,D2.W),D0 
      EXT.W     D0
      BMI.S     .nx01 
      BSR.S     adx7_V 
.nx01:MOVE.B    6(A1,D2.W),D4 
      ADD.W     D1,D4 
      BEQ.S     rear0 
      LEA       curve_V3,A1
      MOVEQ     #1,D2 
.lp02:BSR.S     add7_V 
      DBCC      D2,.lp02
      MOVEQ     #0,D1 
      MOVE.B    1(A1,D2.W),D0 
      EXT.W     D0
      BSR.S     adx7_V 
      ADD.W     D2,D2 
      ADD.W     6(A1,D2.W),D1 
      BPL.S     rear1 
      SUB.W     D4,D1 
      BRA.S     rear1 
rear0:MOVEQ     #0,D1 
      MOVEQ     #5,D0 
      MOVEQ     #$FF,D2 
      BSR.S     add7_V 
      BCC.S     .nx02 
      MOVEQ     #8,D0 
      MOVEQ     #64-1,D2 
.nx02:BSR.S     adx7_V 
      ADD.W     D2,D1 
rear1:LEA       2(A6,D4.W),A1 
      ADDA.W    D1,A1 
      MOVE.B    -(A1),-(A6) 
.lp03:MOVE.B    -(A1),-(A6) 
      DBF       D4,.lp03
      BRA       cognito 

generate_code:
      LEA       Generate,A0
      MOVEQ     #0,D0 
      MOVE.W    #8*5,D1 
      MOVEQ     #9-4,D7 
lp_gV:MOVE.W    pos_V03,(A0)+ 
      MOVE.W    pos_V04,(A0)+ 
      MOVE.W    pos_V05,(A0)+ 
      MOVE.L    pos_V02,D3
      MOVE.W    D0,D3 
      MOVE.L    pos_V01,D4
      MOVE.W    D1,D4 
      MOVE.W    #54-1,D6 
.loop:MOVE.L    D4,(A0)+
      MOVE.L    D3,(A0)+
      ADD.W     #$A0,D3 
      ADD.W     #$A0,D4 
      DBF       D6,.loop
      ADDQ.W    #8,D0 
      SUBQ.W    #8,D1 
      DBF       D7,lp_gV
      MOVE.W    #$4E75,(A0)+
      rts 
