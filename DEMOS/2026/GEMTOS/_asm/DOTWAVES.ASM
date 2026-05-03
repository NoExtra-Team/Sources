; *************************************************************************
; ***                     Sprites 16x16 one bitplane                    ***
; *************************************************************************
; ***                             Angel/HMD                             ***
; *************************************************************************
NB_SPRITE   equ 111    ; Nombre de sprite to display maxi                 *
PLAN_SPRITE equ 6      ; Plan du sprite à afficher                        *
POS_SPRITE  equ 020*160-PLAN_SPRITE ; Position initiale à l'écran         *
; *************************************************************************
display_dotWaves:
	move.l physique,a6
	sub.w #POS_SPRITE,a6
	move.l	a6,a5
	addq.w	#6,a5
	lea oldxys1,a3
	not switch
	beq .no_repeat
	lea oldxys2,a3
.no_repeat:
	moveq #0,d0
	jsr	Code_generated
.calcul_curves:
	lea table1(pc),a1
	lea 2048(a1),a2
	lea table2(pc),a3
	lea 2048(a3),a4
	moveq #0,d2
	moveq #0,d3
	moveq #0,d5
	moveq #0,d6
	move #$3ff,d4
	move xapart1(pc),ADDXAPART1+2
	move yapart1(pc),ADDYAPART1+2
	move xapart2(pc),ADDXAPART2+2
	move yapart2(pc),ADDYAPART2+2
	movem.w xy_pos1(pc),d0-d1
	add xinc1(pc),d0
	add yinc1(pc),d1
	and d4,d0
	and d4,d1
	movem d0-d1,xy_pos1
	add.w d0,a1
	add.w d1,a2
	movem.w xy_pos2(pc),d0-d1
	add xinc2(pc),d0
	add yinc2(pc),d1
	and d4,d0
	and d4,d1
	movem.w d0-d1,xy_pos2
	add.w d0,a3
	add.w d1,a4
	lea newxys,a6
	move #NB_SPRITE-1,d7
calculate_pos:
ADDXAPART1	add #0,d5
ADDYAPART1	add #0,d6
	and d4,d5
	and d4,d6
	move (a1,d5),d0
	move (a2,d6),d1
ADDXAPART2	add #0,d2
ADDYAPART2	add #0,d3
	and d4,d2
	and d4,d3
	add.w (a3,d2),d0
	add.w (a4,d3),d1
	move.w d0,(a6)+
	move.w d1,(a6)+
	dbf d7,calculate_pos
.plot_all_points:
	move.l physique,a6
	lea sprites(pc),a5
	sub.w #POS_SPRITE,a6
	lea oldxys1(pc),a3
	tst switch
	beq .no_old_X
	lea oldxys2(pc),a3
.no_old_X:
	lea newxys(pc),a0
	lea plot_masks+640,a4
 rept NB_SPRITE
	move (a0)+,d0
	move.l (a4,d0),d0
	add (a0)+,d0
	move.l a6,a2           ; ecran dest
	adda.w d0,a2           ; position sur l'ecran dest
	move.w d0,(a3)+        ; anciennes données
	swap d0
	move.l a5,a1           ; sprites
	adda.w d0,a1
	movem.l (a1)+,d0-d7
	or.l d0,(a2) 
	or.l d1,(160*1)(a2) 
	or.l d2,(160*2)(a2) 
	or.l d3,(160*3)(a2) 
	or.l d4,(160*4)(a2) 
	or.l d5,(160*5)(a2) 
	or.l d6,(160*6)(a2) 
	or.l d0,(14*160)(a2) 
	or.l d1,(13*160)(a2)
	or.l d2,(12*160)(a2) 
	or.l d3,(11*160)(a2) 
	or.l d4,(10*160)(a2) 
	or.l d5,(9*160)(a2) 
	or.l d6,(8*160)(a2)
	or.l d7,(7*160)(a2)
	movem.w (a1)+,d0-d3
	or.w d0,(7*160)(a2)
	or.w d1,(7*160)+8(a2)
	or.w d2,(8*160)(a2)
	or.w d3,(8*160)+8(a2)
	or.w d0,(9*160)(a2)
	or.w d1,(9*160)+8(a2)
 endr
	rts

Generated_my_clear_sprites:
	lea	Code_generated,a0
	moveq	#NB_SPRITE-1,d7
.Loop_Generate:
	lea	Code_to_generated(pc),a1
 rept 5                 ; mes Words
	move.w	(a1)+,(a0)+
 endr
 rept	30                ; mes Long
	move.l	(a1)+,(a0)+
 endr
	dbf	d7,.Loop_Generate
	move	#$4E75,(a0)     ; mon Rts
	rts

Code_to_generated:
	move.w (a3)+,d1       ; oldxys1
	move.l a6,a0          ; screen adress 1
	add.w d1,a0           ; oldxys1
	move.l a5,a1          ; screen adress 2
	add.w d1,a1           ; oldxys1
	move.l d0,160*00(a0)
	move.l d0,160*00(a1)
	move.l d0,160*01(a0)
	move.l d0,160*01(a1)
	move.l d0,160*02(a0)
	move.l d0,160*02(a1)
	move.l d0,160*03(a0)
	move.l d0,160*03(a1)
	move.l d0,160*04(a1)
	move.l d0,160*04(a0)
	move.l d0,160*05(a0)
	move.l d0,160*05(a1)
	move.l d0,160*06(a0)
	move.l d0,160*06(a1)
	move.l d0,160*07(a0)
	move.l d0,160*07(a1)
	move.l d0,160*08(a0)
	move.l d0,160*08(a1)
	move.l d0,160*09(a0)
	move.l d0,160*09(a1)
	move.l d0,160*10(a0)
	move.l d0,160*10(a1)
	move.l d0,160*11(a0)
	move.l d0,160*11(a1)
	move.l d0,160*12(a0)
	move.l d0,160*12(a1)
	move.l d0,160*13(a0)
	move.l d0,160*13(a1)
	move.l d0,160*14(a0)
	move.l d0,160*14(a1)

init_dotWaves:
	bsr.s shift_em
	bsr gentabs
	bsr	Generated_my_clear_sprites
	rts

shift_em:
	lea sprites(pc),a0
	lea preshifts(pc),a1 
	moveq #15-1,d7
.loop:
 rept 8
	movem.w (a0)+,d0-d1
	lsr d0
	roxr d1
	movem.w d0-d1,(a1)
	addq.l #4,a1
 endr
 rept 2
	movem.w (a0)+,d0-d1
	lsr d0
	roxr d1
	movem.w d0-d1,(a1)
	addq.l #4,a1
 endr
	dbf d7,.loop
	rts

gentabs:
	lea plot_masks,a0
	moveq #20-1,d0
	moveq #0,d2
.loop:
	moveq #0,d1
 rept 16
	move d1,(a0)+
	move d2,(a0)+
	add #8*5,d1
 endr
	addq.l #8,d2
	dbf d0,.loop
	lea table1(pc),a0
	bsr.s doubleit
	lea table2(pc),a0
	bsr.s doubleit
	rts

doubleit:
	move #512-1,d2	
.loop:
	move.w (a0)+,d0
	move.w 1024*1-2(a0),d1
	move.w d0,1024*1-2(a0)
	move.w d1,1024*2-2(a0)
	move.w d1,1024*3-2(a0)
	dbf d2,.loop
	rts

sprites:
	dc.l %00000111111000000000000000000000
	dc.l %00011111111110000000000000000000
	dc.l %00111111111111000000000000000000
	dc.l %01111111111111100000000000000000
	dc.l %01111111111111100000000000000000
	dc.l %11111111111111110000000000000000
	dc.l %11111111111111110000000000000000
	dc.l %11111111111111110000000000000000
	dc.l %00111000000000000000000000000000
	dc.l %01111100000000000000000000000000
*
preshifts:
	ds.l 2*10*15
*
table1:	even
	incbin "E:\GEMTOS\_data\TABLE1.WF"
	ds.w 1024
table2:	even
	incbin "E:\GEMTOS\_data\TABLE2.WF"
	ds.w 1024
*
xinc1:
	dc.w -6
yinc1:
	dc.w 2
xapart1:
	dc.w 8
yapart1:
	dc.w 18
xinc2:
	dc.w 4
yinc2:
	dc.w 4
xapart2:
	dc.w 14
yapart2:
	dc.w 8 
*
switch:
	ds.w 1
xy_pos1:
	ds.l 1
xy_pos2:
	ds.l 1
oldxys1:
	ds.w NB_SPRITE
oldxys2:
	ds.w NB_SPRITE
newxys:
	ds.l NB_SPRITE
plot_masks:
	ds.l 320
Code_generated:
	ds.w	5*NB_SPRITE	 ; WORD
	ds.l	30*NB_SPRITE ; LONG
	ds.w	1 				   ; RTS
	even