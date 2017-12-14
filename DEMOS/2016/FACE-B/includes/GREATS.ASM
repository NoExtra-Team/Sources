hline=49-7

init_greats:    bsr	init_rotojedi
                rts

init_rotojedi:  moveq #hline-1,d0
                lea forget(pc),a1
.nice:          lea fire(pc),a0
                move #(forget-fire)/2-1,d1
                move (a0)+,(a1)+
                dbf d1,*-2
                dbf d0,.nice
                moveq #6,d0
                lea zonkaf,a1
.nice2:         lea zonka,a0
                move #(zonkaf-zonka)/2-1,d1
                move (a0)+,(a1)+
                dbf d1,*-2
                dbf d0,.nice2
                rts

rotojedi:       lea moves,a5
                lea map,a0
                move (a5)+,d0
                lea (a0,d0),a0
                movea.l physique,a1
                lea     160*12+8*3+4(a1),a1
                movea.l (a5)+,a4	step incremental ($1000000)
                movea.w (a5)+,a3	dy (0)
                adda.l a3,a3	;***
                move (a5)+,d1		dx% (1)
                movea.w (a5)+,a2	dx# (0)
                cmpa.l #movesf,a5
                bne.s hurtme
                lea moves,a5
hurtme:         move.l a5,rotojedi+2
                moveq #0,d3		mover y
                moveq #0,d4		mover x%
                moveq #0,d5		mover x#
                moveq #0,d6		reserv‚
                moveq #4,d7		pour le asl
                moveq #0,d2		incremental
                lea (a0),a6
fire:           moveq #0,d3
                moveq #0,d4
                moveq #0,d5
nark set 0
                move.b (a0),d0
                lsl.b d7,d0

                add a3,d3
                move d3,d6
                add a2,d5
                addx d1,d4
                move.b d4,d6
                add.b (a0,d6),d0
                lsl d7,d0

                add a3,d3
                move d3,d6
                add a2,d5 
                addx d1,d4
                move.b d4,d6
                add.b (a0,d6),d0
                lsl d7,d0

                add a3,d3
                move d3,d6
                add a2,d5
                addx d1,d4
                move.b d4,d6
                add.b (a0,d6),d0
                move d0,nark(a1)
                move d0,nark+160*1(a1)
                move d0,nark+160*2(a1)
                move d0,nark+160*3(a1)
nark set nark+8
                rept 19-6 ***
                add a3,d3
                move d3,d6
                add a2,d5
                addx d1,d4
                move.b d4,d6
                move.b (a0,d6),d0
                lsl.b d7,d0

                add a3,d3
                move d3,d6
                add a2,d5
                addx d1,d4
                move.b d4,d6
                add.b (a0,d6),d0
                lsl d7,d0

                add a3,d3
                move d3,d6
                add a2,d5 
                addx d1,d4
                move.b d4,d6
                add.b (a0,d6),d0
                lsl d7,d0

                add a3,d3
                move d3,d6
                add a2,d5
                addx d1,d4
                move.b d4,d6
                add.b (a0,d6),d0
                move d0,nark(a1)
                move d0,nark+160*1(a1)
                move d0,nark+160*2(a1)
                move d0,nark+160*3(a1)
nark set nark+8
                endr
                lea 160*4(a1),a1
plouf:          add.l a4,d2
                swap d2
                lea (a6,d2),a0
                swap d2
forget:         ds.b hline*(forget-fire)
                rts

; *************************************************************************
; ***            Displaying cursor text one plan 8*8 + cursor           ***
; ***                         Zorro 2/NoExtra                           ***
; *************************************************************************
plan equ 0                      ; plan                                    *
pos_obj	equ	(160*10)+(8*3)       ; position screen                        *
retour_obj equ (160*16)-(8*14)  ; parameter                               *
vitesse_compt	equ	4             ; 4 for speedy / 2 for slowly             *
; *************************************************************************
init_texte:
           clr.w 	anim
           move.w	#pos_obj,adr_obj
           move.w	#0,continu_curseur
           rts

put_texte: cmpi.l	#-1,continu_curseur
           beq		nocurseur
suite:     moveq 	#0,d0
           addq.l 	#1,ptr_texte
           move.l 	ptr_texte,a4
           move.b 	(a4),d0

* // $FD : recommence au début du texte
           cmp.b 	#$fd,d0
           bne.s 	.deb_lig
           move.l	#-1,continu_curseur
           bra 	nocurseur ; STOP HERE !

* // $FF : fin d'une ligne
.deb_lig:  cmp.b 	#$ff,d0
           bne	.pas_deb
           add.w 	#retour_obj,adr_obj
           clr.w 	anim
           move.w	#0,nbre_carac
           bra	 	nocurseur

* // $FE : fin de la ligne du texte
.pas_deb:  cmp.b	#$fe,d0
           bne 	.caract
           bsr	put_screens
           move.w 	#pos_obj,adr_obj
           clr.w	anim
           move.w	#0,nbre_carac
           bra 		nocurseur

* // Affichage du caractère
.caract:   mulu.w 	#16,d0
           lea 		fonte12,a4
           sub.w	#256+160+8*12,d0
           add.w 	d0,a4
           bsr	put_screens
i set 0
           rept	16
           move.b 	(a4),i(a1)
           move.b 	(a4)+,i(a2)
i set i+160
           endr
           ; Find the next character
           tst.w 	anim
           bne.s 	.next_car
           move.b 	#1,anim
           addq.w 	#1,adr_obj
           bra.s 	curseur
.next_car: clr.w 	anim
           addq.w 	#7,adr_obj

* // Affichage du curseur
curseur:   add.w	#1,nbre_carac	; Test fin de ligne moins un caractère
           cmpi.w 	#28-1,nbre_carac ; pour ne pas afficher le curseur
           bge 	nocurseur

           lea		fonte12,a4
           lea	105*8+8*13(a4),a4
           bsr		put_screens
i set 0
           rept	16
           move.b 	(a4),i(a1)
           move.b 	(a4)+,i(a2)
i set i+160
           endr
nocurseur: rts

put_screens:move.l 	physique,a1
           lea	160*8(a1),a1
           lea	plan(a1),a1
           add.w 	adr_obj,a1
           move.l 	physique+4,a2
           lea	160*8(a2),a2
           lea	plan(a2),a2
           add.w 	adr_obj,a2
           rts
