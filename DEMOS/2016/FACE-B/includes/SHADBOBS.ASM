init_shadbobs:
	move #$2700,sr
	CLR.B     $FFFFFA07.W 
	CLR.B     $FFFFFA09.W 
	CLR.B     $FFFFFA1B.W 
	lea	HBL_Logo_Haut(pc),a0             ; Launch HBL
	move.l	a0,$120.w                ;
	ORI.B     #1,$FFFFFA07.W
	ORI.B     #1,$FFFFFA13.W
	stop	#$2300
	lea	Vbl_shadbobs(pc),a0                   ; Launch VBL
	move.l	a0,$70.w                 ;
*
	bsr	shift_bob
	move.l	#mtexte,ptr_mtexte
	rts

Vbl_shadbobs:
      st	Vsync                    ; Synchronisation
      MOVE.L    D0,-(A7) 
      MOVE      SR,-(A7)
      MOVE      #$2700,SR 
      MOVE.L    #$592-1,D0		* 1426
.rien:DBF       D0,.rien
      MOVE.B    #0,$FFFF820A.W
      MOVEQ     #4,D0 
.null:DBF       D0,.null
      MOVE.B    #2,$FFFF820A.W
      MOVE      (A7)+,SR
      MOVE.L    (A7)+,D0 
      CLR.B     $FFFFFA1B.W 
      MOVE.B    #228-20-8-1-1,$FFFFFA21.W
      MOVE.L    #HBL_Logo_Haut,$120.W 
      MOVE.B    #8,$FFFFFA1B.W

	jsr 	(MUSIC+8)                  ; Play SNDH music
	rte

HBL_Logo_Haut:
	MOVE.L    A0,-(A7)               ; Extra Palette
	MOVE.L    A1,-(A7)
	LEA       pal_Haut,A0 
	MOVEA.L   #$FF8240,A1 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A7)+,A1
	MOVE.L    (A7)+,A0
	CLR.B     $FFFFFA1B.W 
	MOVE.B    #20+1,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W
	MOVE.L    #HBL_Scroll_ligne1,$120.W
	RTE 

HBL_Scroll_ligne1:
  move.l	pal_Raster+2*0,$ffff8246.w
	CLR.B     $FFFFFA1B.W 
	MOVE.B    #1,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W
	MOVE.L    #HBL_Scroll_ligne2,$120.W
	RTE 

HBL_Scroll_ligne2:
  move.l	pal_Raster+2*1,$ffff8246.w
	CLR.B     $FFFFFA1B.W 
	MOVE.B    #1,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W
	MOVE.L    #HBL_Scroll_ligne3,$120.W
	RTE 

HBL_Scroll_ligne3:
  move.l	pal_Raster+2*2,$ffff8246.w
	CLR.B     $FFFFFA1B.W 
	MOVE.B    #1,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W
	MOVE.L    #HBL_Scroll_ligne4,$120.W
	RTE 

HBL_Scroll_ligne4:
  move.l	pal_Raster+2*3,$ffff8246.w
;  move.w	#$0009,$ffff8240.w
	CLR.B     $FFFFFA1B.W 
	MOVE.B    #1,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W
	MOVE.L    #HBL_Scroll_ligne5,$120.W
	RTE 

HBL_Scroll_ligne5:
;  move.w	#$0008,$ffff8240.w
  move.l	pal_Raster+2*4,$ffff8246.w
	CLR.B     $FFFFFA1B.W 
	MOVE.B    #1,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W
	MOVE.L    #HBL_Scroll_ligne6,$120.W
	RTE 

HBL_Scroll_ligne6:
  move.l	pal_Raster+2*5,$ffff8246.w
	CLR.B     $FFFFFA1B.W 
	MOVE.B    #1,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W
	MOVE.L    #HBL_Scroll_ligne7,$120.W
	RTE 

HBL_Scroll_ligne7:
  move.l	pal_Raster+2*6,$ffff8246.w
	CLR.B     $FFFFFA1B.W 
	MOVE.B    #2,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W
	MOVE.L    #HBL_Logo_Bas,$120.W
	RTE 

HBL_Logo_Bas:
	MOVE.L    A0,-(A7)               ; Extra Palette
	MOVE.L    A1,-(A7)
	LEA       pal_Bas,A0 
	MOVEA.L   #$FF8240,A1 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A7)+,A1
	MOVE.L    (A7)+,A0
	CLR.B     $FFFFFA1B.W 
	MOVE.B    #1,$FFFFFA21.W
	MOVE.B    #8,$FFFFFA1B.W
	MOVE.L    #HBL_Border_Bas,$120.W
	RTE 

HBL_Border_Bas:
	CLR.B     $FFFFFA1B.W 
	MOVEM.L   A0/D0,-(A7) 
	MOVEA.W   #$FA21,A0 
	MOVE.B    #$28,(A0) 
	MOVE.L    #HBL_Fin,$120.W 
	MOVE.B    #8,$FFFFFA1B.W
	MOVE.B    (A0),D0 
.wait:
	CMP.B     (A0),D0 
	BEQ       .wait 
	CLR.B     $FFFF820A.W 
	MOVEQ     #2,D0 
.att:
	NOP 
	DBF       D0,.att
	MOVE.B    #2,$FFFF820A.W
	MOVEM.L   (A7)+,A0/D0 
	BCLR      #0,$FFFFFA0F.W
	RTE 

HBL_Fin:
	MOVE.L    A0,-(A7)               ; Extra Palette
	MOVE.L    A1,-(A7)
	LEA       pal_Shade,A0 
	MOVEA.L   #$FF8240,A1 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A0)+,(A1)+ 
	MOVE.L    (A7)+,A1
	MOVE.L    (A7)+,A0
	BCLR      #0,$FFFFFA0F.W
	RTE

mscroll:   move.w 	bit,d0
           cmp.w 	#8,d0
           bne.s 	plusloin3
           clr.w 	bit
           move.l 	ptr_mtexte,a1
           move.b 	(a1),d0
           cmp.b 	#255,d0
           bne.s 	lsuite
           move.l 	#mtexte,ptr_mtexte
           move.l 	ptr_mtexte,a1
           move.b 	(a1),d0
lsuite     addq.l 	#1,ptr_mtexte
           asl.l 	#3,d0
           lea 	fonts_8x8,a1
           sub.w	#256,d0
           add.w 	d0,a1
           lea 	buffer,a2

i          set 	0
           rept 	8
           move.b 	(a1)+,i(a2)
i          set 	i+2
           endr

plusloin3: addq.w 	#1,bit

           lea 	trav,a1
           lea 	buffer,a2
i          set 	0
           rept	 8
           roxl 	(a2)+
           roxl 	i+38(a1)
           roxl 	i+36(a1)
           roxl 	i+34(a1)
           roxl 	i+32(a1)
           roxl 	i+30(a1)
           roxl 	i+28(a1)
           roxl 	i+26(a1)
           roxl 	i+24(a1)
           roxl 	i+22(a1)
           roxl 	i+20(a1)
           roxl 	i+18(a1)
           roxl 	i+16(a1)
           roxl 	i+14(a1)
           roxl 	i+12(a1)
           roxl 	i+10(a1)
           roxl 	i+8(a1)
           roxl 	i+6(a1)
           roxl 	i+4(a1)
           roxl 	i+2(a1)
           roxl 	i+0(a1)
i          set 	i+40
           endr

aff_scr:   move.l 	physique,a1
           *addq.w	#2,a1
           add.l		#160*219,a1
           lea 	trav,a2
i          set 	2
           rept 	9-2	*	hauteur du scroll
           move.w 	(a2)+,i+2(a1)
           move.w 	(a2)+,i+10(a1)
           move.w 	(a2)+,i+18(a1)
           move.w 	(a2)+,i+26(a1)
           move.w 	(a2)+,i+34(a1)
           move.w 	(a2)+,i+42(a1)
           move.w 	(a2)+,i+50(a1)
           move.w 	(a2)+,i+58(a1)
           move.w 	(a2)+,i+66(a1)
           move.w 	(a2)+,i+74(a1)
           move.w 	(a2)+,i+82(a1)
           move.w 	(a2)+,i+90(a1)
           move.w 	(a2)+,i+98(a1)
           move.w 	(a2)+,i+106(a1)
           move.w 	(a2)+,i+114(a1)
           move.w 	(a2)+,i+122(a1)
           move.w 	(a2)+,i+130(a1)
           move.w 	(a2)+,i+138(a1)
           move.w 	(a2)+,i+146(a1)
           move.w 	(a2)+,i+154(a1)
i          set 	i+160
           endr
           rts

do_bobs:
	sub.w	#1,bob_timer
	bne	.ok
	add.w	#8*4,bob1_offset
	move.w	bob1_offset,d0
	and.w	#63,d0
	lea	bob1,a0
	add.w	d0,a0
	lea	bob_data+8,a4
	move.w	(a0)+,(a4)+
	move.w	(a0)+,(a4)+
	move.w	(a0),bob_timer

	lea     pal_Shade,A0
	moveq   #15,D2
	jsr     fade_down

	move.l	physique,a3
	lea	160*4(a3),a3
	moveq	#0,d0
	move.w	#160*194/4-1,d1
.cls:
	move.l	d0,(a3)+
	dbf	d1,.cls

.ok:
	lea	bob_data,a4	;do the bobs
	move.l	8(a4),d2	;get x offset
	add.l	d2,(a4)		;add to start of sine
	move.l	(a4)+,d0	;get offset
	and.l	#511,d0		;and with size of table
	lea	sine_x,a0	;get sine table start
	move.w	0(a0,d0.w),d0	;get x position

	move.l	8(a4),d2
	add.l	d2,(a4)
	move.l	(a4),d1
	and.l	#1023,d1
	lea	sine_y,a0
	move.w	0(a0,d1.w),d1

	move.w	d0,d2

	lsr.w	#1,d0
	and.w	#$1f8,d0

	and.w	#15,d2
	mulu	#34*10,d2

	add.w	d1,d0

	lea	shifted,a0
	add.l	d2,a0
	move.l	a0,a4

	move.l	physique,a1
	lea	160*4(a1),a1
	add.w	d0,a1
	move.l	a1,a3

.plot:
	rept	34
	move.w	(a4)+,d0	;get bob data
	eor.w	d0,(a3)		;eor with screen data
	move.w	(a3)+,d1	;get screen data
	not.w	d1		;negate it
	and.w	d0,d1		;and it with last plane
	eor.w	d1,(a3)		;eor new data with screen and poke
	move.w	(a3)+,d0	;get screen data
	not.w	d0		;negate it
	and.w	d1,d0		;and it with last plane
	eor.w	d0,(a3)		;eor new data with screen and poke
	move.w	(a3)+,d1	;get screen data
	not.w	d1		;negate it
	and.w	d0,d1		;and it with last plane
	eor.w	d1,(a3)+	;eor new data with screen and poke

	move.w	(a4)+,d0
	eor.w	d0,(a3)
	move.w	(a3)+,d1
	not.w	d1
	and.w	d0,d1
	eor.w	d1,(a3)
	move.w	(a3)+,d0
	not.w	d0
	and.w	d1,d0
	eor.w	d0,(a3)
	move.w	(a3)+,d1
	not.w	d1
	and.w	d0,d1
	eor.w	d1,(a3)+

	move.w	(a4)+,d0
	eor.w	d0,(a3)
	move.w	(a3)+,d1
	not.w	d1
	and.w	d0,d1
	eor.w	d1,(a3)
	move.w	(a3)+,d0
	not.w	d0
	and.w	d1,d0
	eor.w	d0,(a3)
	move.w	(a3)+,d1
	not.w	d1
	and.w	d0,d1
	eor.w	d1,(a3)+

	move.w	(a4)+,d0
	eor.w	d0,(a3)
	move.w	(a3)+,d1
	not.w	d1
	and.w	d0,d1
	eor.w	d1,(a3)
	move.w	(a3)+,d0
	not.w	d0
	and.w	d1,d0
	eor.w	d0,(a3)
	move.w	(a3)+,d1
	not.w	d1
	and.w	d0,d1
	eor.w	d1,(a3)+

	move.w	(a4)+,d0
	eor.w	d0,(a3)
	move.w	(a3)+,d1
	not.w	d1
	and.w	d0,d1
	eor.w	d1,(a3)
	move.w	(a3)+,d0
	not.w	d0
	and.w	d1,d0
	eor.w	d0,(a3)
	move.w	(a3)+,d1
	not.w	d1
	and.w	d0,d1
	eor.w	d1,(a3)+

	lea	160-40(a3),a3
	endr
	rts

shift_bob:
	lea	bob,a0
	lea	shifted,a1
	move.w	#16-1,d7	;number of times to shift bob
.loop
offset1 set 0
 rept	34	;depth of bob: first move data to pre-store area
	move.w	offset1(a0),(a1)+
	move.w	offset1+8(a0),(a1)+
	move.w	offset1+16(a0),(a1)+
	move.w	offset1+24(a0),(a1)+
	move.w	offset1+32(a0),(a1)+
offset1 set offset1+160
 endr
offset2 set 0
 rept	34		;now shift
	roxr.w	offset2(a0)
	roxr.w	offset2+8(a0)
	roxr.w	offset2+16(a0)
	roxr.w	offset2+24(a0)
	roxr.w	offset2+32(a0)
offset2 set offset2+160
 endr
	dbf	d7,.loop
	rts

