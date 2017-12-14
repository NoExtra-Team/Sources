init_carre.ok:
	bsr	Genere_code
	move.w	#0,pas_trace
	rts

play_carre.ok:
	cmpi.w	#-94,pas_trace
	ble.s	.no_zooming

	lea	coords,a0
	lea	coords_old,a1
	move.w pas_trace,d1
* Point #1
	moveq	#0,d0
	move.w	(a0)+,d0
	sub.w	d1,d0 *
	move.w	d0,(a1)+ ; X
	moveq	#0,d0
	move.w	(a0)+,d0
	sub.w	d1,d0 *
	move.w	d0,(a1)+ ; Y
* Point #2
	moveq	#0,d0
	move.w	(a0)+,d0
	sub.w	d1,d0 *
	move.w	d0,(a1)+ ; X
	moveq	#0,d0
	move.w	(a0)+,d0
	add.w	d1,d0 *
	move.w	d0,(a1)+ ; Y
* Point #3
	moveq	#0,d0
	move.w	(a0)+,d0
	add.w	d1,d0 *
	move.w	d0,(a1)+ ; X
	moveq	#0,d0
	move.w	(a0)+,d0
	add.w	d1,d0 *
	move.w	d0,(a1)+ ; Y
* Point #4
	moveq	#0,d0
	move.w	(a0)+,d0
	add.w	d1,d0 *
	move.w	d0,(a1)+ ; X
	moveq	#0,d0
	move.w	(a0)+,d0
	sub.w	d1,d0 *
	move.w	d0,(a1)+ ; Y
PAS equ 2
	sub.w	#PAS,d1
	move.w	d1,pas_trace

	bsr	efface_poly
	bsr	draw_polygon
.no_zooming:
	rts

***************************************************
* Génération du bloc d'effacement 1 plan de la 3D *
***************************************************

efface_poly:
	move.l	physique,a0
	moveq	#0,d0
	jsr Code_gen
	RTS 
	
* Clear last plane of screen - reasonably quickly...
NB_LIGNE_GENERE	equ	200
NB_BLOC_SUPP	equ	20
PLAN_CLS	equ	0

Genere_code:
	lea Code_gen,a0
	move.w	#NB_LIGNE_GENERE,d7
	moveq	#0,d4
Genere_pour_toutes_les_lignes:	
	moveq	#NB_BLOC_SUPP,d6
	move.w	d4,d5
	add.w	#PLAN_CLS,d5 * position du cadre
Genere_une_ligne:
	move.w	#$3140,(a0)+		 * Genere un move.w  d0,$xx(a0)
	move.w	d5,(a0)+				 * et voila l'offset $xx
	addq.w	#8,d5            * pixel suivant
	dbra	d6,Genere_une_ligne
	add.w	#160,d4            * ligne suivante
	dbra	d7,Genere_pour_toutes_les_lignes
	move.w	#$4e75,(a0)			 * Et un RTS !!
	rts

************************************************
*               3D from XMAS 93                *
*                STF code used                 *
*             Dracula/Positivity               *
*           Modifications by Zorro 2           *
*            Star design by Juliane :)         *
************************************************

nb_coord equ $4 ; <-- pas touche !!!
nb_solide equ $1+1 ; Un carré

draw_polygon:
  move.w	alphaC,d0
  addq.w	#$4,d0	; Incrementer l' angle.
  cmp.w	#$200,d0	; alpha=512?
  bne	.alpha_ok
  moveq.l	#$0,d0	; Alors c' est equivalent a 0.
.alpha_ok:
  move.w	d0,alphaC
  move.l	#sin_cos,a0
  add.w	d0,d0	; 1 sinus=1 mot.
  move.w	(a0,d0.w),d1	; d1=sin(alpha).
  add.w	#$100,a0
  move.w	(a0,d0.w),d0	; d0=cos(alpha).

  * position du solide par d‚faut
  move.w	#160,d6	; d6=incx.
  move.w	#100,d7	; d7=incy.
  
  move.l	#coords_old,a0
  move.l	#new_coords,a1

  rept	(nb_coord*nb_solide)
  move.w	(a0)+,d2	; d2=x.
  move.w	(a0)+,d3	; d3=y.
  move.w	d2,d4
  move.w	d3,d5
  muls.w	d0,d2	; d2=x*cos.
  add.l	d2,d2
  add.l	d2,d2
  swap.w	d2
  muls.w	d1,d4	; d4=x*sin.
  add.l	d4,d4
  add.l	d4,d4
  swap.w	d4
  muls.w	d0,d3	; d3=y*cos.
  add.l	d3,d3
  add.l	d3,d3
  swap.w	d3
  muls.w	d1,d5	; d5=y*sin.
  add.l	d5,d5
  add.l	d5,d5
  swap.w	d5
  sub.w	d5,d2	; d2=x*cos-y*sin.
  add.w	d4,d3	; d3=x*sin+y*cos.
  add.w	d6,d2	; d2=d2+incx.
  add.w	d7,d3	; d3=d3+incy.
  move.w	d2,(a1)+
  move.w	d3,(a1)+
  endr

  move.l	physique,a0	
  move.l	#new_coords+(16*0),a1
  moveq.l	#nb_coord,d0
  jsr	polygone	; Affichage du premier triangle.
	rts

polygone:
 include "E:\SHORTY\carre.ok\POLY_STF.S"
