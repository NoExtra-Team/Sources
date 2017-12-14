*********************************************************************
*                  SMALL SCROLL FONT - 1 BITPLANE                   *
*                          ZORRO 2/NOEXTRA                          *
*********************************************************************
init_scroll_8:
	move.l	#texte_8,ptr_texte_8
	rts

scroll_8:
	move.w 	pas_car_8,d0
	cmp.w 	#8,d0
	bne.s 	plusloin
	clr.w 	pas_car_8
	move.l 	ptr_texte_8,a1
	move.b 	(a1),d0
	cmp.b 	#255,d0
	bne.s 	.lsuite
	move.l 	#texte_8,ptr_texte_8
	move.l 	ptr_texte_8,a1
	move.b 	(a1),d0
.lsuite:
	addq.l 	#1,ptr_texte_8
	asl.l 	#3,d0
	lea 	font_8,a1
	sub.w	#256,d0
	add.w 	d0,a1
	lea 	buffer_car_8,a2
i set 0
 rept 8
	move.b 	(a1)+,i(a2)	;	Caracter to Buffer
i set i+2
 endr
plusloin:
	addq.w 	#1,pas_car_8
	lea 	buffer_scrol_8,a1	;	Display buffer + left scroll
	lea 	buffer_car_8,a2
i set 0
 rept 8
	roxl 	(a2)+
;	roxl 	i+38(a1)
;	roxl 	i+36(a1)
;	roxl 	i+34(a1)
;	roxl 	i+32(a1)
;	roxl 	i+30(a1)
;	roxl 	i+28(a1)
;	roxl 	i+26(a1)
;	roxl 	i+24(a1)
;	roxl 	i+22(a1)
;	roxl 	i+20(a1)
;	roxl 	i+18(a1)
;	roxl 	i+16(a1)
;	roxl 	i+14(a1)
;	roxl 	i+12(a1)
	roxl 	i+10(a1)
	roxl 	i+8(a1)
	roxl 	i+6(a1)
	roxl 	i+4(a1)
	roxl 	i+2(a1)
	roxl 	i+0(a1)
i set i+40
 endr
	move.l 	physique,a1	;	buffer to screen
	lea	160*73+8*7-4(a1),a1
	lea 	buffer_scrol_8,a2
i set 2
 rept 8	*	hauteur du scroll
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
i set 	i+160
 endr
	rts

