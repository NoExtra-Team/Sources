**********************************
*              Fading            *
**********************************
* Original version KELLY.X/HMD   *
*--------------------------------*
* Parameter(s)                   *
*--------------------------------*
**********************************
Fade_couleur_fond:
	;fading qui ramène toutes les couleurs sur le fond 
	lea		Pal_fade_depar,a0						;palette départ
	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,(a0)
	lea		Pal_fade_arriv,a1						;palette arrivée
	move.l	a1,a2
	move.w	$ffff8240.w,d0
	swap	d0
	move.w	$ffff8240.w,d0
	rept	8
	move.l	d0,(a2)+								;recopie le fond
	endr	
.f_partie
	bsr		wart                     ; Waiting after the VBL
	movem.l	Pal_fade_depar,d0-d7
	movem.l	d0-d7,$ffff8240.W
	moveq	#15,d0
	lea		Pal_fade_arriv,a1	
	lea		Pal_fade_depar,a0
	jsr	Fading_auto
	tst.w	d0
	bne.s	.f_partie
	rts
;A0 = palette de la partie
Fade_couleurs_partie:
	lea		Pal_fade_arriv,a1						;palette arrivée
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)
 ;fading mets les couleurs de la partie
	lea		Pal_fade_depar,a0						;palette départ
	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,(a0)

.f_partie
***	bsr		wart                     ; Waiting after the VBL
	movem.l	Pal_fade_depar,d0-d7
	movem.l	d0-d7,$ffff8240.w
	moveq	#15,d0
	lea		Pal_fade_depar,a0
	lea		Pal_fade_arriv,a1	
	jsr	Fading_auto
	tst.w	d0
	bne.s	.f_partie
	rts

Pal_fade_depar:
		ds.l	8
Pal_fade_arriv:
	ds.l	8
RGB1_Fade:
	dc.b	0,2,4,6,8,10,12,14,1,3,5,7,9,11,13,15

Fading_auto:
	move.w	d0,-(sp)
floop
	move.w	(a0),d1
	move.w	(a1)+,d2
 
	move.w	d1,d3
	and.w	#$f00,d3
	lsr.w	#8,d3
	move.b	RGB1_Fade(pc,d3.w),d3
	move.w	d2,d4
	and.w	#$f00,d4
	lsr.w	#8,d4
	move.b	RGB1_Fade(pc,d4.w),d4

	cmp.w	d3,d4
	beq.s	green
	bgt.s	.inc
	subq.w	#1,d3
	bra.s	green
.inc
	addq.w	#1,d3
green
	move.w	d1,d4
	and.w	#$f0,d4
	lsr.w	#4,d4
	move.b	RGB1_Fade(pc,d4.w),d4
	move.w	d2,d5
	and.w	#$f0,d5
	lsr.w	#4,d5
	move.b	RGB1_Fade(pc,d5.w),d5

	cmp.w	d4,d5
	beq.s	blue
	bgt.s	.inc
	subq.w	#1,d4
	bra.s	blue
.inc
	addq.w	#1,d4
blue
	and.w	#$f,d1
	move.b	RGB1_Fade(pc,d1.w),d1
	and.w	#$f,d2
	move.b	RGB1_Fade(pc,d2.w),d2

	cmp.w	d1,d2
	beq.s	.skip
	bgt.s	.inc
	subq.w	#1,d1
	bra.s	.skip
.inc
	addq.w	#1,d1
.skip
	move.b	RGB2_Fade(pc,d1.w),d1
	move.b	RGB2_Fade(pc,d3.w),d3
	move.b	RGB2_Fade(pc,d4.w),d4
	lsl.w	#8,d3
	add.w	d3,d1
	lsl.w	#4,d4
	add.w	d4,d1
	move.w	d1,(a0)+
	dbra	d0,floop
	
	move.w	(sp)+,d1
	moveq	#0,d0
.test
	move.w	-(a0),d2
	cmp.w	-(a1),d2
	beq.s	.skip2
	sne	d0
.skip2	dbra	d1,.test
	rts

RGB2_Fade:
	dc.b	0,8,1,9,2,10,3,11,4,12,5,13,6,14,7,15
	even
