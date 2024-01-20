**********************************
*   Scroll 8x6 font 1 bitplane   *
**********************************
* Original version ATOMUS/NOEX   *
*--------------------------------*
* Parameters                     *
*--------------------------------*
MPLAN equ 6-6                    *
MPOS  equ 160*248+8*9            *
**********************************
Init_mscroll:
	move.l	#smtext,ptr_smtext
	rts

Mscroll:
	move.w 	pas_car,d0
	cmp.w 	#8,d0
	bne.s 	plusloin3
	clr.w 	pas_car
	move.l 	ptr_smtext,a1
	move.b 	(a1),d0
	cmp.b 	#255,d0
	bne.s 	lsuite
	move.l 	#smtext,ptr_smtext
	move.l 	ptr_smtext,a1
	move.b 	(a1),d0
lsuite:
	addq.l 	#1,ptr_smtext
	asl.l 	#3,d0
	lea 	small_font,a1
	sub.w	#256,d0
	add.w 	d0,a1
	lea 	buffer_car,a2

i set 0
 rept 6
	move.b 	(a1)+,i(a2)	;	Caracter to Buffer
i set i+2
 endr

plusloin3:
	addq.w 	#1,pas_car
	lea 	buffer_mscrol,a1	;	Display buffer + left scroll
	lea 	buffer_car,a2
i set 0
 rept 6
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

	move.l 	physique(pc),a1	;	buffer to screen
	add.l	#MPOS+MPLAN,a1
	lea 	buffer_mscrol,a2
i set 2
 rept 6	*	hauteur du scroll
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

