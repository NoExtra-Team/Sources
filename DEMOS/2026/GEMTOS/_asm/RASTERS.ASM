***************************************************************
***          RASTERS TWO LINES WITH GENERATED COLORS        ***
***                     ZORRO2/NOEXTRA-TEAM                 ***
***************************************************************
NBLINE_RASTER equ 36 ; Number of line to display              *
***************************************************************
Init_Rasters:
	lea       DATA_Generate,a1
.loop:
	moveq     #0,d0 
	moveq     #0,d1 
	move.w    (a1),d0 
	move.w    2(a1),d1
	add.w     d0,d0 
	move.w    d0,(a1) 
	mulu      #80,d1 
	move.w    d1,2(a1)
	addq.w    #4,a1 
	cmpa.l    #Repeat_R0,a1 
	bne.s     .loop 
	rts

Display_Rasters:
	move.l    #CourbeR,a0
	lea       160*01(a0),a0 
	lea       Repeat_R0,a2
	lea       Repeat_R1,a3
	lea       DATA_Generate,a1
	move.l    #$80010,d4
	move.w    #NBLINE_RASTER+1,d7 
.loop:
	moveq     #0,d2 
	moveq     #0,d3 
	move.w    (a0),d0 
	move.w    0(a1,d0.w),d2 
	move.w    2(a1,d0.w),d3 
	add.w     d4,d0 
	cmp.w     #1600,d0	;	1600 octets
	blt.s     .no_restart_it 
	subi.w    #1600,d0	;	restart it!
.no_restart_it:
	move.w    d0,(a0)+
	cmpa.l    #end_CourbeR,a0 
	bne.s     .no_end_courbe 
	movea.l   #CourbeR,a0 
.no_end_courbe:
	addi.l    #Couleurs_Rasters,d2 
	move.l    d2,(a2)+
	addi.l    #genere_Courbe,d3 
	move.l    d3,(a3)+
	swap      d4
	dbf       d7,.loop
	rts

genere_Courbe:
* line 1
	dcb.w	3,$4E71
	dcb.w	36,$309B	;	MOVE.W	(A3)+,(A0)
	dc.w	$4E75
* line 2
	dcb.w	2,$4E71
	dcb.w	36,$309B	;	MOVE.W	(A3)+,(A0)
	dc.w	$4E71
	dc.w	$4E75
* line 3
	dc.w	$4E71
	dcb.w	36,$309B	;	MOVE.W	(A3)+,(A0)
	dcb.w	2,$4E71
	dc.w	$4E75

Couleurs_Rasters:
	dc.w	$01f,$09f,$02f,$0af,$03f,$0bf,$04f,$0cf,$05f,$0df,$06f,$0ef,$07f,$0ff
	dc.w	$8f7,$1fe,$9f6,$2fd,$af5,$3fc,$bf4,$4fb,$cf3,$5fa,$df2,$6f9,$ef1,$7f8,$ff0
	dc.w	$fe8,$f61,$fd9,$f52,$fca,$f43,$fbb,$f34,$fac,$f25,$f9d,$f16,$f8e,$f0f,$f0f
	dc.w	$f07,$f0e,$f06,$f0d,$f05,$f0c,$f04,$f0b,$f03,$f0a,$f02,$f09,$f01,$f08,$f00
	dc.w	$f00,$780,$e10,$690,$d20,$5a0,$c30,$4b0,$b40,$3c0,$a50,$2d0,$960,$1e0,$870
	dc.w	$0f0,$070,$0e0,$060,$0d0,$050
DATA_Generate:	even
	incbin	"E:\GEMTOS\_data\GENPLASM.DAT"
Repeat_R0:
 rept NBLINE_RASTER*3
	dc.l	Couleurs_Rasters 
 endr
Repeat_R1:
 rept NBLINE_RASTER*3
	dc.l	genere_Courbe 
 endr
CourbeR:	even
	incbin	"E:\GEMTOS\_data\COURBEP.DAT"
end_CourbeR:
	even