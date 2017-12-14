TUBES:LEA       TUBE01,A0
      ADDA.W    BUFF_T1,A0
      CMPI.W    #-1,(A0) 
      BNE.S     .reset 
      CLR.W     BUFF_T1 
      LEA       TUBE01,A0
.reset:
      LEA       BUFF_T0,A1
      MOVE.W    (A0),D0 
      SUB.W     D0,(A1) 
      TST.W     D0
      BMI.S     .tube_1 
      CMPI.W    #$2800,(A1) 
      BCS.S     .no_add 
      ADDI.W    #$2800,(A1) 
.no_add:
      BRA.S     .tube_2 
.tube_1:
      CMPI.W    #$0,(A1) 
      BPL.S     .tube_2 
      ADDI.W    #$2800,(A1) 
.tube_2:
      LEA       TUBE02,A0
      ADDA.W    (A1),A0 
      MOVEA.L   physique(pc),A1
      LEA       160*73+8*7(A1),A1
      MOVEM.L   (A0)+,A2-A6/D0-D6
z set 0
 rept 55-1
      MOVEM.L   A2-A6/D0-D6,z(A1)
z set z+160
 endr
      RTS
