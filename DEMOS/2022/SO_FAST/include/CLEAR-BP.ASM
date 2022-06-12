; *************************************************************************
; ***      Clear a part of screen in one bitplane without BLITTER       ***
; *************************************************************************
; ***                   Gt Turbo/CV - Zorro 2/NoExtra                   ***
; *************************************************************************
NB_LIGNE_GENERE  equ 168 ; Number of line / 0..199                        *
NB_BLOC_SUPP     equ 10  ; 1..20 max blocs of 16 pixels                   *
; *************************************************************************
Clear_bitplanes:
	bsr	get_Screen_To_display_A0
	add.l	#8*4+4,a0	; Beginning of the first area bitplane
	moveq	#0,d0
	jsr Code_gen
	bsr	get_Screen_To_display_A0
	add.l	#8*4+6,a0	; Beginning of the second area bitplane
	moveq	#0,d0
	jsr Code_gen
	rts

Genere_code_clear_1bp:
	lea Code_gen,a0
	move.w	#NB_LIGNE_GENERE,d7
	moveq	#0,d4
Genere_pour_toutes_les_lignes:	
	moveq	#NB_BLOC_SUPP,d6
	move.w	d4,d5
Genere_une_ligne:
	move.w	#$3140,(a0)+		 * Genere un move.w  d0,$xx(a0)
	move.w	d5,(a0)+				 * et voila l'offset $xx
	addq.w	#8,d5            * pixel suivant
	dbra	d6,Genere_une_ligne
	add.w	#160,d4            * ligne suivante
	dbra	d7,Genere_pour_toutes_les_lignes
	move.w	#$4e75,(a0)			 * Et un RTS !!
	rts