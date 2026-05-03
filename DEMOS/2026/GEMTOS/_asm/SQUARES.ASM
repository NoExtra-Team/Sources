***************************************************************
***          RASTERS TWO LINES WITH GENERATED COLORS        ***
***                     ZORRO2/NOEXTRA-TEAM                 ***
***************************************************************
NBLINE_SQUARES equ 50     ; Number of line to display         *
POS_SQUARES    equ 160*03 ; Position to display GEMTOS logo   *
WIDTH_SQUARES  equ 50     ; Sprite Width                      *
HEIGHT_SQUARES equ 63     ; Sprite Height                     *
***************************************************************
init_Squares:
; Copy to Buffer
			lea       Buffer_FrameS,a0
      lea       Data_squares(pc),a1
      moveq     #WIDTH_SQUARES-1,d0
.rcp1:moveq     #7,d1 
.rcp2:move.l    (a1)+,(a0)+ 
      dbf       d1,.rcp2
      dbf       d0,.rcp1
; Chunk it!
      lea       Buffer_FrameS,a1 
      bsr.s     Next_line 
      moveq     #HEIGHT_SQUARES-1,d0
      lea       Buffer_FrameS,A1 
mloop:bsr.s     Next_line 
      lea       -(160*10)(a0),a0
      moveq     #WIDTH_SQUARES-1,d2 
mrep3:moveq     #3,d1 
.rep4:move.w    (a0),d3 
      move      #0,CCR
      roxl.w    #1,d3 
      roxl      24(a0)
      roxl      16(a0)
      roxl      08(a0) 
      roxl      00(a0)
      addq.l    #2,a0 
      dbf       d1,.rep4
      lea       24(a0),a0 
      dbf       d2,mrep3
      lea       (160*10)(a1),a1 
      bsr.s     Next_line 
      lea       -(160*10)(a1),a1
      dbf       d0,mloop
      rts 
Next_line:
      move.w    #400-1,d1
.loop:move.l    (a1)+,(a0)+ 
      dbf       d1,.loop
      rts 

display_Squares:
      lea       tempoS2(pc),a1
      lea       compteurx2(pc),a2
      lea       courbeS(pc),a3
      lea       tempoS1(pc),a4
      moveq     #0,d1 
      moveq     #0,d2 
      moveq     #0,d3 
      move.w    (a1),d1 
      add.w     (a2)+,d1
      cmp.w     #360,d1
      bcs.s     .next 
      subi.w    #360,d1
.next:move.w    d1,(a1)+
      add.w     d1,d1 
      addi.b    #6,(a4) 
      move.b    0(a3,d1.w),d2 
      add.b     (a4),d2 
      move.w    (a1),d1 
      add.w     (a2)+,d1
      cmp.w     #360,d1
      bcs.s     .suite 
      subi.w    #360,d1
.suite:move.w    d1,(a1)+
      add.w     d1,d1 
      move.b    1(a3,d1.w),d3 
      andi.l    #$3f,d2 
      mulu      #$c80,d2	;	3200 = 160*20
      lea       Buffer_FrameS,a0 
      adda.l    d2,a0 
      lsl.l     #5,d3 
      adda.l    d3,a0 
.display:
      movea.l   physique(pc),a1
      add.l     #POS_SQUARES,a1
      moveq     #NBLINE_SQUARES-1,d0
.loop:movem.l   (a0)+,a2/d1-d7
POS_BLOC1 equ 160*(NBLINE_SQUARES*0-0)
      movem.l   a2/d1-d7,POS_BLOC1+000(a1)
      movem.l   a2/d1-d7,POS_BLOC1+032(a1) 
      movem.l   a2/d1-d7,POS_BLOC1+064(a1) 
      movem.l   a2/d1-d7,POS_BLOC1+096(a1) 
      movem.l   a2/d1-d7,POS_BLOC1+128(a1)
POS_BLOC2 equ 160*(NBLINE_SQUARES*1-1)
      movem.l   a2/d1-d7,POS_BLOC2+000(a1)
      movem.l   a2/d1-d7,POS_BLOC2+032(a1) 
      movem.l   a2/d1-d7,POS_BLOC2+064(a1) 
      movem.l   a2/d1-d7,POS_BLOC2+096(a1) 
      movem.l   a2/d1-d7,POS_BLOC2+128(a1) 
POS_BLOC3 equ 160*(NBLINE_SQUARES*2-1)
      movem.l   a2/d1-d7,POS_BLOC3+000(a1)
      movem.l   a2/d1-d7,POS_BLOC3+032(a1) 
      movem.l   a2/d1-d7,POS_BLOC3+064(a1) 
      movem.l   a2/d1-d7,POS_BLOC3+096(a1) 
      movem.l   a2/d1-d7,POS_BLOC3+128(a1) 
      lea       160(a1),a1
      dbf       d0,.loop
      rts

Data_squares:	even
 incbin	"E:\GEMTOS\_pic\TOSGEM.IMG"	; Taille 64*50
courbeS:	even
 incbin "E:\GEMTOS\_data\COURBES.DAT"
tempoS1:
	dc.l	10
tempoS2:
	dc.l	10
compteurx2:
	dc.w	1,1
	even

