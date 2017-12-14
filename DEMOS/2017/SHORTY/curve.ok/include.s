go_courbe:
 move.w (a0)+,amplitude_x+2
 move.w (a0)+,coef_x+2
 move.w (a0)+,amplitude_y+2
 move.w (a0)+,coef_y+2
 move.w (a0)+,vit1+4
 lea.l Scourbe,a1
 bsr Smake_courbe
 move.w (a0)+,amplitude_x+2
 move.w (a0)+,coef_x+2
 move.w (a0)+,amplitude_y+2
 move.w (a0)+,coef_y+2
 move.w (a0)+,vit2+4
 lea.l Scourbe2,a1
 bsr Smake_courbe
 move.w (a0)+,Snbre_points
 rts

Smake_courbe:
 pea (a0)
 lea.l Scosinus,a0

 move.w #0,d0
Smake_courbe2:
; traitement des X

amplitude_x
 move.w #80,d1

 move.w d0,d3
coef_x
 mulu.w #2,d3
test1 cmpi.w #1440,d3
 blo no_coef1
 subi.w #1440,d3
 bra.s test1
no_coef1

 muls.w (a0,d3.w),d1
 asr.w #7,d1
 addi.w #160,d1
 asr.w d1

; traitement des Y

amplitude_y
 move.w #80,d2

 move.w d0,d3
coef_y
 mulu.w #3,d3
test2 cmpi.w #1440,d3
 blo no_coef2
 subi.w #1440,d3
 bra.s test2
no_coef2

 muls.w 2(a0,d3.w),d2
 asr.w #7,d2
 addi.w #100,d2
 asr.w d2

 move.w d1,1440(a1)
 move.w d1,(a1)+
 
 mulu.w #160,d2		; evite le mulu #160 en cours de vbl !
 move.w d2,1440(a1) 	; (et on gagne beaucoup de cycles !)
 move.w d2,(a1)+

 addq.w #4,d0
 cmpi.w #1440,d0
 bne Smake_courbe2
 move.l (sp)+,a0
 rts
 
Lignes:
; efface les anciens points
 movea.l adr_buf1,a0
 movea.l physique+4,a1
 move.w Snbre_points,d0
 moveq.w #0,d2
eff_points
 move.w (a0)+,d1
 move.w d2,(a1,d1.w)
 dbf d0,eff_points

; transfere buffer d'effacement
 move.l adr_buf1,a0
 move.l adr_buf2,adr_buf1
 move.l a0,adr_buf2

; affiche les points
 move.w Snbre_points,d0
 move.l a5,a0
 move.l a6,a2
 movea.l adr_buf2,a3
 movea.l physique+4,a4
 move.w #$ffff-7,d6
 move.w #32768,d7

aff_points:
 move.l (a0)+,d1	; traite X et Y dans un meme reg.
 add.l (a2)+,d1

; routine d'affichage d'un point (bien optimisee,ouais !)
 move.w d1,d4		; d4=nbre de ligne-adr ecran
 swap d1
 move.w d1,d2
 lsr.w d1
 and.w d6,d1
 add.w d1,d4
 move.w d4,(a3)+
 lsl.w d1		; equivaut a lsr #3,d1 + lsl.w #4,d1
 sub.w d1,d2
 move.w d7,d1
 lsr.w d2,d1
 or.w d1,(a4,d4.w)

 dbf d0,aff_points

vit1 add.l #4,a5
 cmpa.l #Scourbe+720*2,a5
 blo.s nofin_a5 
 lea.l Scourbe,a5
nofin_a5

vit2 add.l #8,a6
 cmpa.l #Scourbe2+720*2,a6
 bne.s nofin_a6
 lea.l Scourbe2,a6
nofin_a6
	rts

Init_Courbe:
; definie les courbes de deformations
 lea.l params_curve,a0
 bsr go_courbe
 lea.l Scourbe,a5
 lea.l Scourbe2,a6
 rts
