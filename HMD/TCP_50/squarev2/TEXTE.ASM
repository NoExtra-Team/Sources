**********************************
*   Print 16x8 font 1 bitplane   *
**********************************
* Original version ATOMUS/NOEX   *
*--------------------------------*
* Parameter(s)                   *
*--------------------------------*
**********************************

; ***************************************************************
; Affichage du texte
; ***************************************************************

init_texte1:
					clr.w 	anim
					clr.w		adr_obj
					move.w	#160*((200-16)/2),adr_obj
					move.l	#texte1-1,ptr_texte
					move.w	#40+1,cpt
					rts

init_texte2:
					clr.w 	anim
					clr.w		adr_obj
					move.w	#160*((200-16)/2),adr_obj
					move.l	#texte2-1,ptr_texte
					move.w	#40+1,cpt
					rts

put_texte: 
           addq.l 	#1,ptr_texte         ; + 1
           move.l 	ptr_texte,a0         ; Sauve a0

           moveq     #0,d0               ; Test si caractere ou code
           move.b 	(a0),d0              ; Code ou caract dans d0

; ---------------------------------------------------------------
; Retour en debut de texte
; ---------------------------------------------------------------
           subi.w	#1,cpt
           cmpi.w	#0,cpt
           ble.s	.sortie

           cmpi.b 	#$ff,d0
           bne 	.deb_lig
.sortie:   rts

; ---------------------------------------------------------------
; Retour en debut de ligne
; ---------------------------------------------------------------

.deb_lig:  cmpi.b 	#$fd,d0               ; Debut de ligne ?
           bne	.caract

           move.l 	physique,a3       ; efface la trace du curseur
           add.w 	adr_obj,a3
           addq.w	#4,a3
i set 0
 rept 16
           clr.b 	i(a3)
i set i+160
	endr

; ---------------------------------------------------------------
; Adresse du caractere a afficher
; ---------------------------------------------------------------

.caract:   mulu.w 	#16,d0                ; valeur * 16
           lea 		font,a0                 ; Adresse de la fonte
           sub.w	#256+160+8*12,d0
           add.w 	d0,a0                   ; a0= adr caractere

; ---------------------------------------------------------------
; Caractere -> Ecran
; ---------------------------------------------------------------

           move.l 	physique,a2       ; Affiche le caractère
           add.w 	adr_obj,a2

           move.l 	physique,a3       ; Efface la trace du curseur
           add.w 	adr_obj,a3
           addq.w	#4,a3
i set 0
	rept	16
           clr.b 	i(a3)
           move.b 	(a0)+,i(a2)
i set i+160
 endr

; ---------------------------------------------------------------
; Adresse ecran du prochain caractere a afficher
; ---------------------------------------------------------------

           tst.w 	anim
           bne.s 	.next_car
           move.b 	#1,anim
           addq.w 	#1,adr_obj
           bra.s 	curseur
.next_car: clr.w 	anim
           addq.w 	#7,adr_obj

; ---------------------------------------------------------------
; Gestion du curseur
; ---------------------------------------------------------------

curseur:   cmpi.w	#1,cpt
           ble.s	.no_cursor

           lea		font,a0
           lea	105*8+8*13(a0),a0
           move.l 	physique,a2
           add.w 	adr_obj,a2
           addq.w	#4,a2
i set 0
	rept	16
           move.b 	(a0)+,i(a2)
i set i+160
	endr
.no_cursor:rts

font:	
	incbin 	"FONT160a.DAT"
	even

; ------------------------------
; $ff = fin du texte
; $fd = retour en debut de ligne
; ------------------------------
ptr_texte:
	dc.l 	0
texte1:
*      +                                        +
	dc.b "            WE ARE ALL HUMANS!          ",$ff
texte2:
	dc.b "            WE ARE HEMOROIDS!           ",$ff
	even

cpt:
	ds.w	1
anim:
	ds.w	1
adr_obj:
	ds.w	1
	even

