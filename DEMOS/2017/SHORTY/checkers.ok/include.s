INIT_DEMO2:       BSR       MAKE_CHECKERS 
                  LEA       CHECK_INDEX,A0
                  LEA       CHECK_OFFSET,A1 
                  LEA       CHECK_MAX,A2
                  LEA       CHECK_REV,A3
                  MOVEQ     #1,D0 
                  MOVEQ     #4,D1 
                  MOVE.W    #$100,D2
bloop:            MOVE.W    D0,D3 
                  ADD.W     D3,D3 
                  SUBI.W    #$50,D3 
                  LSL.W     #8,D3 
.back:            TST.W     D3
                  BPL.S     tridi 
                  ADD.W     D2,D3 
                  BRA.S     .back 
tridi:            CMP.W     D2,D3 
                  BCS.S     .next 
                  SUB.W     D2,D3 
                  BRA.S     tridi 
.next:            MOVE.W    D3,(A0)+
                  MOVE.W    D1,(A1)+
                  MOVE.W    D2,(A2)+
                  MOVE.W    D2,D3 
                  LSR.W     #1,D3 
                  MOVE.W    D3,(A3)+
                  ADDQ.W    #4,D1 
                  ADDI.W    #$100,D2
                  ADDQ.W    #1,D0 
                  CMP.W     #$41,D0 
                  BNE.S     bloop 
                  LEA       CHECK_ADDRS,A0
                  MOVE.W    #$1F,D7 
.lstore:          LEA       YBIT_MAPS,A1
                  MOVE.W    #7,D6 
.store_it:        BSR       STORE_CHECK 
                  LEA       16(A1),A1 
                  DBF       D6,.store_it
                  BSR.S     SCROLL_CHECK
                  BSR.S     SCROLL_CHECK
                  DBF       D7,.lstore
                  RTS 

SCROLL_CHECK:     LEA       CHECK_INDEX,A1
                  LEA       CHECK_OFFSET,A2 
                  LEA       CHECK_MAX,A3
                  MOVEQ     #$3F,D2 
.loop:            MOVE.W    (A1),D0 
                  MOVE.W    (A3)+,D1
                  ADD.W     (A2)+,D0
                  CMP.W     D1,D0 
                  BCS.S     .next 
                  SUB.W     D1,D0 
.next:            MOVE.W    D0,(A1)+
                  DBF       D2,.loop
                  RTS 

STORE_CHECK:      LEA       CHECK_INDEX,A3
                  LEA       CHECK_REV,A5
                  MOVE.L    4(A1),D5
                  LEA       Buffer_L7Z,A2
                  BSR.S     PLOT_CHECK
                  MOVE.L    (A1),D5 
                  BSR.S     PLOT_CHECK
                  RTS 

PLOT_CHECK:       MOVE.W    #$1F,D4 
.repeat:          MOVE.W    (A3)+,D0
                  MOVE.W    (A5)+,D1
                  LSR.L     #1,D5 
                  BCC.S     .next 
                  ADD.W     D1,D0 
.next:            LSR.W     #8,D0 
                  BCC.S     .blow 
                  ADDQ.W    #1,D0 
.blow:            MOVE.W    D0,D1 
                  ANDI.W    #$F,D0
                  LSL.W     #5,D0 
                  LEA       (A2),A6 
                  ADDA.W    D0,A6 
                  LSR.W     #4,D1 
                  ADD.W     D1,D1 
                  ADDA.W    D1,A6 
                  MOVE.L    A6,(A0)+
                  LEA       512(A2),A2
                  DBF       D4,.repeat
                  RTS 

MAKE_CHECKERS:    LEA       Buffer_L7Z,A0
                  MOVE.W    #1,D0 
                  MOVE.W    #0,D1 
                  MOVE.W    my_word(PC),D2
                  MOVE.W    pointeur(PC),D3
bgcloop:          MOVEM.L   D0-D3,-(A7) 
                  MOVEQ     #8,D7 
                  MOVEA.L   A0,A1 
                  MOVEQ     #$1F,D6 
                  MOVEQ     #0,D5 
regene:           MOVE.W    D0,D4 
                  MOVE.W    D2,pointeur
                  TST.W     D1
                  BEQ.S     pointeur 
                  EXG       D1,D0 
                  EXG       D3,D2 
pointeur:         BRA.S     .next 
                  BSET      D6,D5 
.next:            SUBQ.W    #1,D6 
                  BPL.S     .nextA 
                  MOVE.L    D5,(A1)+
                  MOVEQ     #$1F,D6 
                  MOVEQ     #0,D5 
                  SUBQ.W    #1,D7 
                  BEQ.S     gloobi 
.nextA:           SUBQ.W    #1,D4 
                  BNE.S     pointeur 
                  BRA.S     regene 
gloobi:           MOVE.W    #$E,D7
lscrollc:         MOVE.W    #7,D6 
.movel:           MOVE.L    (A0)+,(A1)+ 
                  DBF       D6,.movel
                  MOVEA.L   A1,A2 
                  MOVE.W    #$E,D6
                  LSL       -(A2) 
.roxl:            ROXL      -(A2) 
                  DBF       D6,.roxl
                  DBF       D7,lscrollc
                  MOVEA.L   A1,A0 
                  MOVEM.L   (A7)+,D0-D3 
                  CMP.W     D0,D1 
                  BNE.S     .nextB 
                  ADDQ.W    #1,D0 
                  BRA.S     loop_c 
.nextB:           ADDQ.W    #1,D1 
loop_c:           CMP.W     #$21,D0 
                  BNE       bgcloop 
                  RTS 
my_word:          NOP 

UPDATE_DEMO2:     ADDQ.W    #1,DEMO2_X
                  SUBQ.W    #1,DEMO2_Y
                  MOVEA.L   physique(pc),A0
                  lea	160*72+8*5(a0),a0
                  LEA       CHECK_ADDRS,A1
                  LEA       SINES,A2
                  MOVEQ     #0,D0 
                  MOVE.W    DEMO2_X,D2
                  ANDI.W    #$FF,D2 
                  MOVE.B    0(A2,D2.W),D0 
                  MOVE.W    DEMO2_Y,D1
                  BTST      #3,D1 
                  BEQ.S     .next 
                  ADDI.W    #$10,D0 
.next:            ANDI.W    #$1F,D0 
                  LSL.W     #3,D0 
                  ANDI.W    #7,D1 
                  ADD.W     D1,D0 
                  LSL.W     #8,D0 
                  ADDA.L    D0,A1 
;a set 0
;b set 8
c set 16
d set 24
e set 32
f set 40
g set 48
h set 56
i set 64
j set 72

 rept 56-1
                  MOVEA.L   (A1)+,A2
                  LEA       4(a2),a2
                  ;MOVE.W    (A2)+,a(A0) 
                  ;MOVE.W    (A2)+,b(A0) 
                  MOVE.W    (A2)+,c(A0)
                  MOVE.W    (A2)+,d(A0)
                  MOVE.W    (A2)+,e(A0)
                  MOVE.W    (A2)+,f(A0)
                  MOVE.W    (A2)+,g(A0)
                  MOVE.W    (A2)+,h(A0)
                  ;MOVE.W    (A2)+,i(A0)
                  ;MOVE.W    (A2)+,j(A0)
;a set a+160
;b set b+160
c set c+160
d set d+160
e set e+160
f set f+160
g set g+160
h set h+160
i set i+160
j set j+160
 endr

                  RTS
