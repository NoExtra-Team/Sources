init_starsh:
      lea         table_starsh,a6
      move.w      #$5E,d7 
boucle_starsh:
      bsr.s       random_stars ;appel du trap pour random table
      andi.l      #$FFFF,d0 
      divu        #$A0,d0 
      swap        D0
      ANDI.w      #$FFF8,d0 
      move.w      d0,(a6)+
      bsr.s       random_stars 
      andi.w      #$F,d0
      clr.w       D1
      bset        d0,d1 
      move.w      d1,(a6)+
      dbf         d7,boucle_starsh
      rts 

random_stars:
      move.w      #$11,-(a7) 	;RANDOM la flemme 
      TRAP        #$E 
      ADDQ.l      #2,A7 
      rts 

do_starsh:
      movea.l     LOG4,a5
      lea         table_starsh,a2
      move.w      #$5E,d0 
      clr.l       D4
      move.b      #160,d4 
trait_starsh:
      move.w      (a2)+,d1
      clr.l       D2
      move.w      (a2),d2 
      move.w      d0,d3 
      andi.w      #3,d3 
      addq.w      #1,d3 
      ror.l       d3,d2 
      tst.w       D2
      bne.s       push_starsh 
      swap        D2
      clr.w       0(A5,d1.W)
      addq.w      #8,d1 
      cmp.w       d4,d1 
      blt.s       not_starsh 
      clr.w       D1
not_starsh:
      move.w      d1,-2(a2) 
push_starsh 
      move.w      d2,(a2)+
      move.w      d2,0(A5,d1.W) 
      adda.l      d4,a5 
      dbf         d0,trait_starsh
      rts 

table_starsh:
	ds.b	4000
	even