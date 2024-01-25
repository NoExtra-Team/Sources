init_logo:    
      move.l      #bufscr,d0 ; logo HMD
      andi.l      #$FFFFFF00,d0 
      addi.l      #$200,d0
      lea         LOG,a0
      move.l      d0,(a0) 
      move.l	LOG,a0	; Clear screen.
      jsr	clear_screen_4_bitplanes_full

      move.l      #buf_scr3,d0 ; stars + scroll
      andi.l      #$FFFFFF00,d0 
      addi.l      #$200,d0
      lea         LOG4,a0
      move.l      d0,(a0) 
      move.l	LOG4,a0	; Clear screen.
      jsr	clear_screen_4_bitplanes_full

      move.l      #buf_scr2,d0 ; logos mvt
      andi.l      #$FFFFFF00,d0 
      addi.l      #$200,d0
      lea         LOG2,a0
      move.l      d0,(a0) 
      move.l	LOG2,a0	; Clear screen.
      jsr	clear_screen_4_bitplanes_full
   
      lea         hmdlog1+34,a0
      lea         hmdlog2+34,a1
      movea.l     LOG,a2
      adda.l      #6*160,a2
      move.l      #76,d0 80
.boucle_lg: 
    rept 40
      move.l      (a0)+,(a2)+ 
    endr
    rept 40 
      move.l      (a1)+,(a2)+ 
    endr
      dbf         d0,.boucle_lg
      rts

move_logo:
      move.l      flag_cpt_logo,d7
      divu        #16,d7 
      swap        D7
      cmp.b       #0,d7 
      bne         suite_mvt_logo2 
      move.l      #80,d4 
suite_mvt_logo:
      move.l      flag_cpt_logo,d1
      divu        #16,d1 
      mulu        #8,d1 
      move.l      LOG,d6
      add.w       d1,d6 
      move.b      d7,$FFFF8265.W
      move.b      d4,$FFFF820F.W
      move.l      d6,(a6) 
      move.b      (a6)+,d0
      move.b      (a6)+,$FFFF8205.W 
      move.b      (a6)+,$FFFF8207.W 
      move.b      (a6)+,$FFFF8209.W 
      CMPI.l      #1,flag_cpt_logo2
      bne.s       then_mvt_logo 
      cmpi.l      #0,flag_cpt_logo
      ble.s       again_mvt_logo 
      subi.l      #4,flag_cpt_logo
      bra.s       fin_mvt_logo 
again_mvt_logo:
      move.l      #0,flag_cpt_logo2
then_mvt_logo:
      cmpi.l      #320,flag_cpt_logo 
      bge.s       chg_mvt_logo 
      addi.l      #4,flag_cpt_logo
      bra.s       fin_mvt_logo 
chg_mvt_logo:
      move.l      #1,flag_cpt_logo2
fin_mvt_logo:
      rts 

suite_mvt_logo2:
      move.l      #76,d4 
      bra         suite_mvt_logo
      rts

flag_cpt_logo:
	dc.l	0
flag_cpt_logo2:
	dc.l	0
	even