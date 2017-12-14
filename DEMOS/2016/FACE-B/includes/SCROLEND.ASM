INIT_MONSCROL:    LEA       FONT,A0 
                  LEA       FONTTAB,A1
                  MOVE.W    #$5F,D7 
.loop:            MOVE.L    A0,(A1)+
                  LEA       18(A0),A0 
                  DBF       D7,.loop
                  RTS

MONSCROL:         TST.W     LINECNT 
                  BNE       SCROLLSCREEN
                  MOVE.L   #t_Buffer_L7Z,A0 
                  ADDA.L    #202*160,A0 
                  MOVE.L    A0,COPYADDR 
                  CLR.L     D0
                  MOVEA.L   MSPNT,A0
                  CMPI.B    #$FF,(A0) 
                  BNE.S     DRESET
                  MOVE.L    #MESS,MSPNT 
                  LEA       MESS,A0 
DRESET:           MOVE.W    #19,D1 
COPYCHAR:         CLR.L     D0
                  MOVE.B    (A0)+,D0
                  CMP.B     #13,D0
                  BEQ.S     HERE
                  CMP.B     #14,D0
                  BNE.S     NOPAUSE 
                  MOVE.L    A0,MSPNT
                  BRA       CONTINUE
NOPAUSE:          SUBI.B    #32,D0 
                  ASL.L     #2,D0 
                  LEA       FONTTAB,A1
                  MOVEA.L   0(A1,D0.W),A2 
                  MOVEA.L   COPYADDR,A3 
                  MOVE.W    (A2)+,(A3)
                  MOVE.W    (A2)+,160(A3) 
                  MOVE.W    (A2)+,320(A3) 
                  MOVE.W    (A2)+,480(A3) 
                  MOVE.W    (A2)+,640(A3) 
                  MOVE.W    (A2)+,800(A3) 
                  MOVE.W    (A2)+,960(A3) 
                  MOVE.W    (A2)+,1120(A3)
                  MOVE.W    (A2)+,1280(A3)
                  ADDQ.L    #8,COPYADDR 
                  DBF       D1,COPYCHAR 
HERE:             MOVE.L    A0,MSPNT
                  MOVE.W    #10,LINECNT 
SCROLLSCREEN:     SUBQ.W    #1,LINECNT
                  MOVE.L   #t_Buffer_L7Z,A1 
                  LEA       160(A1),A0
                  MOVE.W    #210,D1
.loop:            MOVE.W    (A0),(A1) 
                  MOVE.W    8(A0),8(A1) 
                  MOVE.W    16(A0),16(A1) 
                  MOVE.W    24(A0),24(A1) 
                  MOVE.W    32(A0),32(A1) 
                  MOVE.W    40(A0),40(A1) 
                  MOVE.W    48(A0),48(A1) 
                  MOVE.W    56(A0),56(A1) 
                  MOVE.W    64(A0),64(A1) 
                  MOVE.W    72(A0),72(A1) 
                  LEA       160(A0),A0
                  LEA       160(A1),A1
                  DBF       D1,.loop
CONTINUE:         move.l	#t_Buffer_L7Z,a0
                  movea.l	physique,a1
                  sub.w	#8*6,a1
                  addq.w	#6,a1
                  move.w	#320-7*23,d0
                  move.w	#0,d1
                  move.w	#10*16,d2
                  move.w	#200,d3
                  move.w	#1,d4
                  jsr	DoBLiTTER__Copy_Buffer
                  RTS
