**********************************
* Sine-Wave Wibbler - 3 bitpanes *
**********************************
* Original version ATOMUS/NOEX   *
* Fixed by ANGEL/HMD             *
*--------------------------------*
* Parameters                     *
*--------------------------------*
NB_BLOC equ 20 ; width 320/16    *
SIZEL equ 90-1 ; height          *
MOVEY equ 0    ; little MVT      *
**********************************
Inits_Vagues:
.init_tab_vagues:
	move.l    #SIZEL-1,d0 
	move.b    #0,d1 
	lea       Tabs_Vagues,a0
.wave:
	move.b    d1,0(a0,d0.w) 
	addi.b    #2,d1 
	dbf       d0,.wave
.copy_sprite:
	lea       Buffer_Vagues,a1
	movea.l   #reflet_picture,a0 
	move.l    #SIZEL*NB_BLOC-1,d1
.buff:
	move.w    (a0)+,(a1)+ 
	move.w    (a0)+,(a1)+ 
	move.w    (a0)+,(a1)+ 
	addq.l    #2,a0 
	dbf       d1,.buff
.preshit_sprite:
	lea       Buffer_Vagues,a0
	move.l    #15-1,d4
preshif:
	move.l    #2,d3 
height:
	move.l    #SIZEL-1,d2 
width:
	addi.b    #0,d0 
	move.l    #NB_BLOC-1,d1
bitplane:
	move.w    (a0),d0 
	roxr.w    #1,d0 
	move.w    d0,(a1) 
	addq.l    #6,a0 
	addq.l    #6,a1 
	dbf       d1,bitplane
	dbf       d2,width
	suba.l    #SIZEL*NB_BLOC*6-2,a0
	suba.l    #SIZEL*NB_BLOC*6-2,a1 
	dbf       d3,height
	adda.l    #SIZEL*NB_BLOC*6-6,a0
	adda.l    #SIZEL*NB_BLOC*6-6,a1 
	dbf       d4,preshif
.dont_forget_to_init_courbe:
	move.l    #Courbe_Vagues,Ptr_Vagues
	rts 

Display_Vagues:
	lea       Tabs_Vagues,a0
	lea       Pos_Vagues,a1
	movea.l   Ptr_Vagues,a4
 IFEQ	MOVEY
	clr.w     d0
	move.b    plus_4,d0
	addi.b    #4,d0 
	move.b    d0,plus_4
	move.b    0(a1,d0.w),d0 
	lsr.b     #1,d0 
	mulu      #160,d0
 ENDC
	movea.l   physique,a3
	adda.l    #160*173+8*4,a3
 IFEQ	MOVEY
	adda.l    d0,a3
 ENDC
	move.l    #SIZEL-1,d1 
.disp:
	clr.w     d0
	move.b    0(a0,d1.w),d0 
	addi.b    #5,d0 
	add.b     (a4)+,d0
	cmpa.l    #Fin_Courbe_Vagues,a4 
	bcs.s     .reset
	lea       Courbe_Vagues,a4
.reset:
	move.b    d0,0(a0,d1.w) 
	move.b    0(a1,d0.w),d0 
	mulu      #SIZEL,d0 
	add.w     d1,d0 
	mulu      #15*8,d0 
	lea       Buffer_Vagues,a2
	adda.l    d0,a2 
	move.l    #12-1,d3
.put:
	move.w    (a2)+,(a3)+ 
	move.w    (a2)+,(a3)+ 
	move.w    (a2)+,(a3)+ 
	addq.l    #2,a3 
	dbf       d3,.put
	suba.l    #12*8*3-8*4,a3
	dbf       d1,.disp
	move.l    a4,Ptr_Vagues
	rts 

 IFEQ	MOVEY
plus_4:
	dc.w	$0
	even
 ENDC

