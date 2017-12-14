init_mscroll:
	move.l	#mtexte,Mptr_mtexte
	rts

mscroll:
	move.w 	Mpas_car,d0
	cmp.w 	#8,d0
	bne.s 	plusloin3
	clr.w 	Mpas_car
	move.l 	Mptr_mtexte,a1
	move.b 	(a1),d0
	cmp.b 	#255,d0
	bne.s 	lsuite
	move.l 	#mtexte,Mptr_mtexte
	move.l 	Mptr_mtexte,a1
	move.b 	(a1),d0
lsuite:
	addq.l 	#1,Mptr_mtexte
	asl.l 	#3,d0
	lea 	mfonts,a1
	sub.w	#256,d0
	add.w 	d0,a1
	lea 	Mbuffer_car,a2
i set 0
 rept 8-2
	move.b 	(a1)+,i(a2)	;	Caracter to Buffer
i set i+2
 endr
plusloin3:
	addq.w 	#1,Mpas_car
	lea 	Mbuffer_mscrol,a1	;	Display buffer + left scroll
	lea 	Mbuffer_car,a2
i set 0
 rept 8-2
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
	lea	160*97+8*7+2(a1),a1
	lea 	Mbuffer_mscrol,a2
i set 2
 rept 6	*	hauteur du scroll
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

patch_Scroll:
	move.l	#Fond_Screen,a0                ; FROM ADRESS DATA
	move.w	#110,d2                    ; LEFT FROM ADRESS DATA
	move.w	#25,d3                    ; TOP FROM ADRESS DATA
	move.w	#1,d4        ; WIDTH of bloc
	move.w	#8,d5       ; HEIGHT of bloc
	move.w	#4,d6       ; Number of plane
; Destination 1st Screen adress
	move.l	physique,a1          ; TO ADRESS SCREEN
	move.w	#110,d0      ; LEFT TO ADRESS SCREEN
	move.w	#96,d1      ; TOP TO ADRESS SCREEN
	jsr	DoBLiTTER__Operation       ; Launch blitter operation
	move.l	#Fond_Screen,a0                ; FROM ADRESS DATA
	move.w	#209,d2                    ; LEFT FROM ADRESS DATA
	move.w	#25,d3                    ; TOP FROM ADRESS DATA
	move.w	#1,d4        ; WIDTH of bloc
	move.w	#8,d5       ; HEIGHT of bloc
	move.w	#4,d6       ; Number of plane
; Destination 1st Screen adress
	move.l	physique,a1          ; TO ADRESS SCREEN
	move.w	#209,d0      ; LEFT TO ADRESS SCREEN
	move.w	#96,d1      ; TOP TO ADRESS SCREEN
	jsr	DoBLiTTER__Operation       ; Launch blitter operation
	rts