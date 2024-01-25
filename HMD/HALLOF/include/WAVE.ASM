left_wave:
      movem.l a0-a1,-(a7)
      roxl      152(a0) 
      roxl      144(a0) 
      roxl      136(a0) 
      roxl      128(a0) 
      roxl      120(a0) 
      roxl      112(a0) 
      roxl      104(a0) 
      roxl      96(a0)
      roxl      88(a0)
      roxl      80(a0)
      roxl      72(a0)
      roxl      64(a0)
      roxl      56(a0)
      roxl      48(a0)
      roxl      40(a0)
      roxl      32(a0)
      roxl      24(a0)
      roxl      16(a0)
      roxl      8(a0)
      roxl      (a0)

      roxl      154(a0) 
      roxl      146(a0) 
      roxl      138(a0) 
      roxl      130(a0) 
      roxl      122(a0) 
      roxl      114(a0) 
      roxl      106(a0) 
      roxl      98(a0)
      roxl      90(a0)
      roxl      82(a0)
      roxl      74(a0)
      roxl      66(a0)
      roxl      58(a0)
      roxl      50(a0)
      roxl      42(a0)
      roxl      34(a0)
      roxl      26(a0)
      roxl      18(a0)
      roxl      10(a0)
      roxl      2(a0)

      roxl      156(a0) 
      roxl      148(a0) 
      roxl      140(a0) 
      roxl      132(a0) 
      roxl      124(a0) 
      roxl      116(a0) 
      roxl      108(a0) 
      roxl      100(a0) 
      roxl      92(a0)
      roxl      84(a0)
      roxl      76(a0)
      roxl      68(a0)
      roxl      60(a0)
      roxl      52(a0)
      roxl      44(a0)
      roxl      36(a0)
      roxl      28(a0)
      roxl      20(a0)
      roxl      12(a0)
      roxl      4(a0)
     
      roxl      158(a0) 
      roxl      150(a0) 
      roxl      142(a0) 
      roxl      134(a0) 
      roxl      126(a0) 
      roxl      118(a0) 
      roxl      110(a0) 
      roxl      102(a0) 
      roxl      94(a0)
      roxl      86(a0)
      roxl      78(a0)
      roxl      70(a0)
      roxl      62(a0)
      roxl      54(a0)
      roxl      46(a0)
      roxl      38(a0)
      roxl      30(a0)
      roxl      22(a0)
      roxl      14(a0)
      roxl      6(a0)
      movem.l (a7)+,a0-a1
      rts 

right_wave:     
      movem.l a0-a1,-(a7)
      roxr      6(a0)
      roxr      14(a0)
      roxr      22(a0)
      roxr      30(a0)
      roxr      38(a0)
      roxr      46(a0)
      roxr      54(a0)
      roxr      62(a0)
      roxr      70(a0)
      roxr      78(a0)
      roxr      86(a0)
      roxr      94(a0)
      roxr      102(a0) 
      roxr      110(a0) 
      roxr      118(a0) 
      roxr      126(a0) 
      roxr      134(a0) 
      roxr      142(a0) 
      roxr      150(a0) 
      roxr      158(a0) 
   
      roxr      (a0)
      roxr      8(a0)
      roxr      16(a0)
      roxr      24(a0)
      roxr      32(a0)
      roxr      40(a0)
      roxr      48(a0)
      roxr      56(a0)
      roxr      64(a0)
      roxr      72(a0)
      roxr      80(a0)
      roxr      88(a0)
      roxr      96(a0)
      roxr      104(a0) 
      roxr      112(a0) 
      roxr      120(a0) 
      roxr      128(a0) 
      roxr      136(a0) 
      roxr      144(a0) 
      roxr      152(a0) 
   
      roxr      2(a0)
      roxr      10(a0)
      roxr      18(a0)
      roxr      26(a0)
      roxr      34(a0)
      roxr      42(a0)
      roxr      50(a0)
      roxr      58(a0)
      roxr      66(a0)
      roxr      74(a0)
      roxr      82(a0)
      roxr      90(a0)
      roxr      98(a0)
      roxr      106(a0) 
      roxr      114(a0) 
      roxr      122(a0) 
      roxr      130(a0) 
      roxr      138(a0) 
      roxr      146(a0) 
      roxr      154(a0) 
      
      roxr      4(a0)
      roxr      12(a0)
      roxr      20(a0)
      roxr      28(a0)
      roxr      36(a0)
      roxr      44(a0)
      roxr      52(a0)
      roxr      60(a0)
      roxr      68(a0)
      roxr      76(a0)
      roxr      84(a0)
      roxr      92(a0)
      roxr      100(a0) 
      roxr      108(a0) 
      roxr      116(a0) 
      roxr      124(a0) 
      roxr      132(a0) 
      roxr      140(a0) 
      roxr      148(a0) 
      roxr      156(a0)
      movem.l (a7)+,a0-a1 
      rts 

do_wave:
      lea         table_wave,a1
      move.w      cpt_wave,d0
      adda.W      d0,a1 
      cmpi.b      #2,(a1) 
      bne.s       .init_wave 
      lea         table_wave,a1
      move.w      #0,cpt_wave
      move.l      #400,cpt_logo_wait
.init_wave:
      movea.l     LOG2,a0 
      adda.w      #160*104,a0
      moveq       #80,d0 
traitement_wave:
      cmpi.b      #2,(a1) 
      bne.s       init2_wave 
      move.w      #0,cpt_wave
      move.l      #400,cpt_logo_wait
      lea         table_wave,a1
init2_wave:
      cmpi.b      #0,(a1) 
      beq.s       rightornot_wave
      cmpi.b      #$FF,(a1) 
      beq.s       leftornot_wave 
      bsr         left_wave 
      bra.s       rightornot_wave 
leftornot_wave:
      bsr         right_wave 
rightornot_wave:
      lea         1(a1),a1
      lea         160(a0),a0
      dbf         d0,traitement_wave
      ADDI.W      #1,cpt_wave
      rts   

cpt_wave:
      ds.w	1 
table_wave:
 rept	32*2*2
	dc.b	0
	endr
	rept	10
	dc.b	0,1,0,0,1,0,0,0
	dc.b	0,0,0,-1,0,0,-1,0
	dc.b	0,-1,0,0,-1,0,0,0
	dc.b	0,0,0,1,0,0,1,0
 endr
 rept	32*2*2
	dc.b	0
 endr
	dc.b      $02,$90,'JR' 
	dc.b      $02,$90 
	even


