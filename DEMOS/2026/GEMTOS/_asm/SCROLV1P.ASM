***************************************************************
***          SCROLLTEXT WITH FONT 8x8 ONE BITPLANE          ***
***************************************************************
***                   ATOMUS/NOEXTRA-TEAM                   ***
***************************************************************
POS_SCROLL8  equ 160*120 ; Position of the scrolling          *
PLAN_SCROLL8 equ 0       ; Bitplane used for the scrolling    *
***************************************************************
Scroll_v8x8:
      movea.l   ptr_Courbe(pc),a0
      move.w    (a0)+,d0
      tst.w     (a0)
      bpl.s     .next 
      lea       Courbe(pc),a0
.next:move.l    a0,ptr_Courbe
      lsr       #2,d0 ; on divise par #4 pour l'amplitude
      mulu      #160,d0
 rept 2
      bsr       Rox_scroll
 endr
      lea       buffer_Scroll,a0
      movea.l   physique(pc),a1
      lea       POS_SCROLL8+PLAN_SCROLL8(a1),a1
      adda.l    d0,a1 
      move.w    #10,d0
.loop:move.w    000(a0),000(a1) 
      move.w    008(a0),008(a1) 
      move.w    016(a0),016(a1) 
      move.w    024(a0),024(a1) 
      move.w    032(a0),032(a1) 
      move.w    040(a0),040(a1) 
      move.w    048(a0),048(a1) 
      move.w    056(a0),056(a1) 
      move.w    064(a0),064(a1) 
      move.w    072(a0),072(a1) 
      move.w    080(a0),080(a1) 
      move.w    088(a0),088(a1) 
      move.w    096(a0),096(a1) 
      move.w    104(a0),104(a1) 
      move.w    112(a0),112(a1) 
      move.w    120(a0),120(a1) 
      move.w    128(a0),128(a1) 
      move.w    136(a0),136(a1) 
      move.w    144(a0),144(a1) 
      move.w    152(a0),152(a1) 
      lea       160(a0),a0
      lea       160(a1),a1
      dbf       d0,.loop
      rts 
      
Rox_scroll:
; text ascii
      tst.w     MaxCarac 
      bne.s     can_rol 
      movea.l   ptr_Text8x8(pc),a0
      move.b    (a0)+,d1
      bne.s     .no_reset
      move.l    #Text8x8,ptr_Text8x8
      bra.s     Rox_scroll 
.no_reset:
      move.l    a0,ptr_Text8x8
      lea       font8x8_1p(pc),a0
      lea       buffer_Charac,a1
      andi.l    #$ff,d1 
      sub.l     #32,d1 
      beq.s     .next 
      divu      #20,d1 
      move.w    d1,pos_MaxCarac
      swap      d1
      ext.l     d1
      lsl.l     #3,d1 
      adda.l    d1,a0 
      move.w    pos_MaxCarac(pc),d1
      move.w    d1,d2 ;
      lsl.w     #7,d1 ;
      lsl.w     #5,d2 ;
      add.w     d2,d1 ;
      lsl.w     #4,d1 ; mulu #160*16,d1
      adda.l    d1,a0 
.next:move.w    #6,d1 
.loop:move.l    (a0)+,(a1)+ 
      move.l    (a0)+,(a1)+ 
      adda.l    #160-8,a0 
      dbf       d1,.loop
; Pre-calc buffer
      move.w    #9,MaxCarac
can_rol:
      subq.w    #1,MaxCarac
      lea       buffer_Charac,a1
      lea       buffer_Scroll,a0
      adda.l    #160*2,a0
      move.w    #6,d1 
.roxl:move      #0,CCR
      roxl      (a1)+ 
      roxl      152(a0) 
      roxl      144(a0) 
      roxl      136(a0) 
      roxl      128(a0) 
      roxl      120(a0) 
      roxl      112(a0) 
      roxl      104(a0) 
      roxl      096(a0)
      roxl      088(a0)
      roxl      080(a0)
      roxl      072(a0)
      roxl      064(a0)
      roxl      056(a0)
      roxl      048(a0)
      roxl      040(a0)
      roxl      032(a0)
      roxl      024(a0)
      roxl      016(a0)
      roxl      008(a0) 
      roxl      (a0)+ 
      addq.l    #6,a0 
      addq.l    #6,a1 
      lea       160-8(a0),a0
      dbf       d1,.roxl
      rts
*
ptr_Text8x8:
	dc.l	Text8x8
;ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789.,!?-:()'
Text8x8:
;       +                                                           +
	dc.b	" NOEXTRA COME BACK WITH AN INTRO FOR THE GEMTOS PARTY 2026."
	dc.b	" IT'S ALWAYS TIME TO SUPPORT AN ATARI EVENT IN FRANCE AND I"
	dc.b	" LET VICOMTE TO SHARE SOME WORDS IN THE NEXT SCROLLTEXT... "
	dc.b	"                                                           "
	dc.b	-1
	even
*
pos_MaxCarac:
	dc.w	$0
MaxCarac:
	dc.w	$0
ptr_Courbe:
	dc.l	Courbe
Courbe:	even
 incbin	"E:\GEMTOS\_data\courbe.dat"
font8x8_1p:	even
 incbin	"E:\GEMTOS\_data\font8x8.dat"
	even