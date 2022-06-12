*********************************************************************
***                  SMALL SCROLL FONT - 1 BITPLANE               ***
*********************************************************************
*                          ZORRO 2/NOEXTRA                          *
*********************************************************************
init_mscroll:
	move.l	#mtexte,ptr_mtexte
	rts

mscroll:
	move.w 	pas_car,d0
	cmp.w 	#8,d0
	bne.s 	plusloin3
	clr.w 	pas_car
	move.l 	ptr_mtexte,a1
	move.b 	(a1),d0
	cmp.b 	#255,d0
	bne.s 	lsuite
	move.l 	#mtexte,ptr_mtexte
	move.l 	ptr_mtexte,a1
	move.b 	(a1),d0
lsuite:
	addq.l 	#1,ptr_mtexte
	asl.l 	#3,d0
	lea 	fonts,a1
	sub.w	#256,d0
	add.w 	d0,a1
	lea 	buffer_car,a2

i set 0
 rept 8-2
	move.b 	(a1)+,i(a2)	;	Caracter to Buffer
i set i+2
 endr

plusloin3:
	addq.w 	#1,pas_car
	lea 	buffer_mscrol,a1	;	Display buffer + left scroll
	lea 	buffer_car,a2
i set 0
 rept 8-2
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
	roxl 	i+08(a1)
	roxl 	i+06(a1)
	roxl 	i+04(a1)
	roxl 	i+02(a1)
	roxl 	i+00(a1)
i set i+40
 endr

	bsr	get_Screen_To_display_A1
	lea	160*194+2(a1),a1
	lea 	buffer_mscrol,a2
i set 2
 rept 10-2-2	*	hauteur du scroll
	move.w 	(a2)+,i+002(a1)
	move.w 	(a2)+,i+010(a1)
	move.w 	(a2)+,i+018(a1)
	move.w 	(a2)+,i+026(a1)
	move.w 	(a2)+,i+034(a1)
	move.w 	(a2)+,i+042(a1)
	move.w 	(a2)+,i+050(a1)
	move.w 	(a2)+,i+058(a1)
	move.w 	(a2)+,i+066(a1)
	move.w 	(a2)+,i+074(a1)
	move.w 	(a2)+,i+082(a1)
	move.w 	(a2)+,i+090(a1)
	move.w 	(a2)+,i+098(a1)
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

* SMALL SCROLLTEXT
mtexte:
* < !'#$%&"()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyzCUR> *
	dc.b "                              "
	dc.b "little come back from noextra-team to support the shadow party in 2022!"
	dc.b "                         "
	dc.b "oh! oh! oh! this is an old effect never seen from atomus before! "
	dc.b "this effect is a gouraud shaded in three bitplanes specially for atari 520 stf. the tricks is "
	dc.b "to undelete/hidden two bitplanes and clear two another bitplanes, all "
	dc.b "graphic vector lines are draw in a long and put in the last bitplane with six colors. "
	dc.b "                         "
	dc.b "original code from atomus and additional code by Zorro 2, old graphics from mister.a and music by scavenger. "
	dc.b "                         "
	dc.b "to perform the gouraud displayed, we used an old trick from kelly.x from hemoroids "
	dc.b "which use height screens! but he scrolltext seems not very synchronized with the gouraud "
	dc.b "but we don't care :) "
	dc.b "                         "
	dc.b "final screens assembled by zorro 2 in a hurry in one day! 13 years to finish it! "
	dc.b "                         "
	dc.b "we meet you to visit our github https://github.com/NoExtra-Team and see last submited sources "
	dc.b "in four repositories. "
	dc.b "                         "
	dc.b "thanks to mooz from shadow party team to accept this release very later but we like challenge! "
	dc.b "                         "
	dc.b "thanks to all people who make demo possible and don't forget:         preparation 'h' is good for you"
	dc.b "...let's wrap again........                                                                    "
	dc.b $ff
	even
fonts:
	incbin	"E:\SO_FAST\data\FONTSMAL.DAT"
	even
ptr_mtexte:
	ds.l	1
pas_car:
	ds.w 	1
buffer_car:
	ds.w 	8
buffer_mscrol:
	ds.w	200
	even