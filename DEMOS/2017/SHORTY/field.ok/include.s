play_field.ok:
  LEA       numb_dots,A0
  TST.W     (A0)
  BEQ.S     .display_it 
  SUBQ.W    #1,(A0) 
.display_it:
  BSR       clear_dots 
  BSR       calc_dots 
  BSR       display_dots 
.Rotations:
  LEA       d_axe_X,A0
  ADDQ.W    #2,(A0) 
  CMPI.W    #360,(A0)
  BNE.S     .axe_x 
  MOVE.W    #0,(A0) 
.axe_x:
  LEA       d_axe_Y,A0
  ADDQ.W    #2,(A0) 
  CMPI.W    #360,(A0)
  BNE.S     .axe_y 
  MOVE.W    #0,(A0) 
.axe_y:
  LEA       d_axe_Z,A0
  ADDQ.W    #2,(A0) 
  CMPI.W    #360,(A0)
  BNE.S     .axe_z 
  MOVE.W    #0,(A0) 
.axe_z:
	rts

clear_dots:
  LEA       Dots_D05,A0
  MOVEQ     #0,D0 
	move.w	#75-1,d1
.clr:
  MOVEA.L   (A0)+,A1
  MOVE.L    D0,(A1)+
  MOVE.W    D0,(A1) 
	dbf	d1,.clr
  rts 

calc_dots:
  LEA       Dots_D00,A5
  LEA       d_axe_X,A0
  MOVE.W    (A0),D1 
  ADD.W     D1,D1 
  LEA       L1_dots,A1
  MOVE.W    0(A5,D1.W),(A1) 
  ADDI.W    #$2D2,D1
  LEA       L2_dots,A1
  MOVE.W    0(A5,D1.W),(A1) 
  LEA       d_axe_Y,A1
  MOVE.W    (A1),D1 
  ADD.W     D1,D1 
  LEA       L3_dots,A1
  MOVE.W    0(A5,D1.W),(A1) 
  ADDI.W    #$2D2,D1
  LEA       L4_dots,A1
  MOVE.W    0(A5,D1.W),(A1) 
  LEA       d_axe_Y,A1
  MOVE.W    (A1),D1 
  ADD.W     D1,D1 
  LEA       L5_dots,A1
  MOVE.W    0(A5,D1.W),(A1) 
  ADDI.W    #$2D2,D1
  LEA       L6_dots,A1
  MOVE.W    0(A5,D1.W),(A1) 
  LEA       L1_dots,A0
  LEA       L2_dots,A1
  LEA       L3_dots,A2
  LEA       L4_dots,A3
  LEA       L5_dots,A4
  LEA       L6_dots,A5
  LEA       buffer_dots,A6
  MOVE.W    (A3),D0 
  MULS      (A5),D0 
  LSL.L     #1,D0 
  SWAP      D0
  MOVE.W    D0,(A6)+
  MOVE.W    (A3),D0 
  MULS      (A4),D0 
  NEG.L     D0
  LSL.L     #1,D0 
  SWAP      D0
  MOVE.W    D0,(A6)+
  MOVE.W    (A2),(A6)+
  MOVE.W    (A1),D0 
  MULS      (A4),D0 
  MOVE.W    (A0),D1 
  MULS      (A2),D1 
  LSL.L     #1,D1 
  SWAP      D1
  MULS      (A5),D1 
  ADD.L     D1,D0 
  LSL.L     #1,D0 
  SWAP      D0
  MOVE.W    D0,(A6)+
  MOVE.W    (A1),D0 
  MULS      (A5),D0 
  MOVE.W    (A0),D1 
  MULS      (A2),D1 
  LSL.L     #1,D1 
  SWAP      D1
  MULS      (A4),D1 
  SUB.L     D1,D0 
  LSL.L     #1,D0 
  SWAP      D0
  MOVE.W    D0,(A6)+
  MOVE.W    (A0),D0 
  MULS      (A3),D0 
  NEG.L     D0
  LSL.L     #1,D0 
  SWAP      D0
  MOVE.W    D0,(A6)+
  MOVE.W    (A0),D0 
  MULS      (A4),D0 
  MOVE.W    (A1),D1 
  MULS      (A2),D1 
  LSL.L     #1,D1 
  SWAP      D1
  MULS      (A5),D1 
  SUB.L     D1,D0 
  LSL.L     #1,D0 
  SWAP      D0
  MOVE.W    D0,(A6)+
  MOVE.W    (A0),D0 
  MULS      (A5),D0 
  MOVE.W    (A1),D1 
  MULS      (A2),D1 
  LSL.L     #1,D1 
  SWAP      D1
  MULS      (A4),D1 
  ADD.L     D1,D0 
  LSL.L     #1,D0 
  SWAP      D0
  MOVE.W    D0,(A6)+
  MOVE.W    (A1),D0 
  MULS      (A3),D0 
  LSL.L     #1,D0 
  SWAP      D0
  MOVE.W    D0,(A6) 
  rts 

display_dots:
  LEA       all_dots,A0
  MOVE.W    (A0),D7 
  SUBQ.W    #1,D7 
  LEA       physique+4,A0
  MOVEA.L   (A0),A3 
  LEA       Dots_D04,A4
  LEA       Dots_D05,A5
  LEA       Dots_D01,A0
  LEA       Dots_D02,A1
  LEA       Dots_D03,A2
gen_dots:
  LEA       buffer_dots,A6
  MOVE.W    (A0),D0 
  MOVE.W    (A1),D1 
  MOVE.W    (A2),D2 
  MULS      (A6)+,D0
  MULS      (A6)+,D1
  MULS      (A6)+,D2
  ADD.L     D1,D0 
  ADD.L     D2,D0 
  MOVE.L    D0,D3 
  MOVE.W    (A0),D0 
  MOVE.W    (A1),D1 
  MOVE.W    (A2),D2 
  MULS      (A6)+,D0
  MULS      (A6)+,D1
  MULS      (A6)+,D2
  ADD.L     D1,D0 
  ADD.L     D2,D0 
  MOVE.L    D0,D4 
  MOVE.W    (A0)+,D0
  MOVE.W    (A1)+,D1
  MOVE.W    (A2)+,D2
  MULS      (A6)+,D0
  MULS      (A6)+,D1
  MULS      (A6)+,D2
  ADD.L     D1,D0 
  ADD.L     D2,D0 
  LSL.L     #2,D0 
  SWAP      D0
  MOVE.L    D0,D5 
  SWAP      D5
  MOVE.W    #0,D5 
  SWAP      D5
  ADDI.W    #$FA,D5 
  MOVEM.L   A0,-(A7)
  LEA       size_dots,A0
  ADD.W     (A0),D5 
  MOVEM.L   (A7)+,A0
  ASR.L     #6,D3 
  ASR.L     #6,D4 
  DIVS      D5,D3 
  DIVS      D5,D4 
  ADDI.W    #$A0,D3 
  ADDI.W    #$64,D4 
  CMP.W     #$C7,D4 
  BGT.S     end_gen_dots 
  TST.W     D4
  BMI.S     end_gen_dots 
  CMP.W     #$140,D3
  BGT.S     end_gen_dots 
  TST.W     D3
  BMI.S     end_gen_dots 
  MOVEA.L   A3,A6 
  ADD.W     D4,D4 
  ADDA.W    32(A4,D4.W),A6
  MOVE.W    D3,D0 
  ANDI.W    #$FFF0,D0 
  LSR.W     #1,D0 
  ADDA.W    D0,A6 
  ANDI.W    #$F,D3
  ADD.W     D3,D3 
  MOVE.W    0(A4,D3.W),D0 
  MOVEM.L   A0,-(A7)
  LEA       size_dots,A0
  SUB.W     (A0),D5 
  MOVEM.L   (A7)+,A0
  SUBI.W    #$96,D5 
  BMI.S     or_gen_dots 
  CMP.W     #$19,D5 
  BCS.S     or_gen_dots 
  CMP.W     #$32,D5 
  BCS.S     profondeur_D1 
  CMP.W     #$4B,D5 
  BCS.S     profondeur_D2 
  CMP.W     #$64,D5 
  BCS.S     profondeur_D3 
  CMP.W     #$7D,D5 
  BCS.S     profondeur_D4 
  CMP.W     #$96,D5 
  BCS.S     profondeur_D5 
  BRA.S     profondeur_D6 
or_gen_dots:
  OR.W      D0,(A6) 
  MOVE.L    A6,(A5)+
end_gen_dots:
  DBF       D7,gen_dots
  rts 

profondeur_D6:
  OR.W      D0,(A6) 
  OR.W      D0,2(A6)
  OR.W      D0,4(A6)
  MOVE.L    A6,(A5)+
  DBF       D7,gen_dots
  rts

profondeur_D5:
  OR.W      D0,2(A6)
  OR.W      D0,4(A6)
  MOVE.L    A6,(A5)+
  DBF       D7,gen_dots
  rts 

profondeur_D4:
  OR.W      D0,(A6) 
  OR.W      D0,4(A6)
  MOVE.L    A6,(A5)+
  DBF       D7,gen_dots
  rts 

profondeur_D3:
  OR.W      D0,4(A6)
  MOVE.L    A6,(A5)+
  DBF       D7,gen_dots
  rts 

profondeur_D2:
  OR.W      D0,(A6) 
  OR.W      D0,2(A6)
  MOVE.L    A6,(A5)+
  DBF       D7,gen_dots
  rts 

profondeur_D1:
  OR.W      D0,2(A6)
  MOVE.L    A6,(A5)+
  DBF       D7,gen_dots
  rts 
