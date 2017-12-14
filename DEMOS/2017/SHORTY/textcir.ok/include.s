play_Texte_Circle:
      MOVEQ     #0,D0 
      MOVEQ     #0,D1 
      MOVEQ     #0,D2 
      MOVEA.L   PTR_ASCII,A1
      MOVE.B    TEST_CARAC,D0
      TST.B     D0
      BNE.S     .yes_text 
.reset_text:
      MOVE.B    #8,D0 
      MOVEA.L   PTR_TEXTE_CIRCLE,A0
      MOVE.B    (A0)+,D1
      TST.B     (A0)
      BNE.S     .no_reset_text
      LEA       TEXTE_CIRCLE,A0
.no_reset_text:
      MOVE.L    A0,PTR_TEXTE_CIRCLE
      LEA       ASCIIc,A1
      LEA       CHARACTERS,A2
      MOVE.B    0(A2,D1.W),D1 
      EXT.W     D1
      ASL.W     #3,D1 
      LEA       0(A1,D1.W),A1 
      MOVEQ     #0,D1 
.yes_text:
      MOVE.B    (A1)+,D1
      MOVE.L    A1,PTR_ASCII
      SUBI.B    #1,D0 
      MOVE.B    D0,TEST_CARAC
.ascii:
      LEA       ASCIIc,A0
      MOVEQ     #104-1,D0 
.lp_ascii:
      MOVE.B    -(A0),1(A0) 
      DBF       D0,.lp_ascii
      MOVE.B    D1,(A0) 
.display_text:
      LEA       COURBES,A1
      MOVE.L   #Buffer_L7Z,A2
      MOVEQ     #104,D7 ; for each lines...
loop_CIRCLE:MOVEM.L   (A1)+,D0-D3 
      LEA       0(A2,D0.W),A3 
      SWAP      D0
      BTST      #7,(A0) 
      BEQ.S     .no_l1 
      BSET      D0,(A3) 
      BRA.S     .yes_1 
.no_l1:BCLR      D0,(A3) 
.yes_1:LEA       0(A2,D1.W),A3 
      SWAP      D1
      BTST      #6,(A0) 
      BEQ.S     .no_l2 
      BSET      D1,(A3) 
      BRA.S     .yes_l2 
.no_l2:BCLR      D1,(A3) 
.yes_l2:LEA       0(A2,D2.W),A3 
      SWAP      D2
      BTST      #5,(A0) 
      BEQ.S     .no_l3 
      BSET      D2,(A3) 
      BRA.S     .yes_l3 
.no_l3:BCLR      D2,(A3) 
.yes_l3:LEA       0(A2,D3.W),A3 
      SWAP      D3
      BTST      #4,(A0) 
      BEQ.S     .no_l4 
      BSET      D3,(A3) 
      BRA.S     .yes_l4 
.no_l4:BCLR      D3,(A3) 
.yes_l4:MOVEM.L   (A1)+,D0-D3 
      LEA       0(A2,D0.W),A3 
      SWAP      D0
      BTST      #3,(A0) 
      BEQ.S     .no_l5 
      BSET      D0,(A3) 
      BRA.S     .yes_l5 
.no_l5:BCLR      D0,(A3) 
.yes_l5:LEA       0(A2,D1.W),A3 
      SWAP      D1
      BTST      #2,(A0) 
      BEQ.S     .no_l6 
      BSET      D1,(A3) 
      BRA.S     .yes_l6 
.no_l6:BCLR      D1,(A3) 
.yes_l6:LEA       0(A2,D2.W),A3 
      SWAP      D2
      BTST      #1,(A0) 
      BEQ.S     .no_l7 
      BSET      D2,(A3) 
      BRA.S     .yes_l7 
.no_l7:BCLR      D2,(A3) 
.yes_l7:LEA       0(A2,D3.W),A3 
      SWAP      D3
      BTST      #0,(A0) 
      BEQ.S     .no_l8 
      BSET      D3,(A3) 
      BRA.S     .yes_l8 
.no_l8:BCLR      D3,(A3) 
.yes_l8:LEA       1(A0),A0
      DBF       D7,loop_CIRCLE
.recopy_from_buffer:
      move.l	#Buffer_L7Z,a0                ; FROM ADRESS DATA
      move.w	#112,d2                    ; LEFT FROM ADRESS DATA
      move.w	#0,d3                    ; TOP FROM ADRESS DATA
      move.w	#96,d4        ; WIDTH of bloc
      move.w	#54,d5       ; HEIGHT of bloc
      move.w	#1,d6       ; Number of plane
      ; Destination 1st Screen adress
      move.l	physique,a1          ; TO ADRESS SCREEN
      move.w	#112,d0      ; LEFT TO ADRESS SCREEN
      move.w	#73,d1      ; TOP TO ADRESS SCREEN
      bsr	DoBLiTTER__Operation       ; Launch blitter operation
      rts
