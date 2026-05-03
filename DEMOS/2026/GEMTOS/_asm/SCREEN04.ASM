init_Screen_04:
	jsr	print_text                   ; Print texts
	rts

timer_Screen_04_start:
	move #$2700,SR                   ; Interrupts OFF
	sf $fffffa21.w                   ; Timer B data (number of scanlines to next interrupt)
	sf $fffffa1b.w                   ; Timer B control (event mode (HBL))
	lea	Hbl_Screen_04(pc),a0         ; Launch HBL
	move.l a0,$120.w                 ;
	bset #0,$fffffa07.w              ; Timer B vector
	bset #0,$fffffa13.w              ; Timer B on
	stop #$2300                      ; Interrupts ON
	move.l	#Vbl_Screen_04,$70.w
	rts

Vbl_Screen_04:
 IFEQ BLITTER
.sync_Blitter:                     ; Sync Blitter with effect
	bclr.b	#7,$ffff8a3c.w
	nop
	btst.b	#7,$ffff8a3c.w
	bne.s	.sync_Blitter
 ENDC

	st	Vsync                        ; Synchronisation

	movem.l	d0-d7/a0-a6,-(a7)

 IFEQ	BOTTOM_BORDER
	clr.b   $fffffa1b.w              ; Disable timer B
	lea	Over_rout(pc),a0             ; HBL
	move.l	a0,$120.w                ; Timer B vector
	move.b	#199,$fffffa21.w         ; At the position
	move.b	#8,$fffffa1b.w           ; Launch HBL
 ENDC

 IFEQ	TOPBOTTOM_BORDER
	move.l	a0,-(a7)
	clr.b (tacr).w                   ; Stop timer A
	lea	topbord(pc),a0               ; Launch HBL
	move.l	a0,$134.w                ; Timer A vector
	move.b	#99,(tadr).w             ; Countdown value for timer A
	move.b	#4,(tacr).w              ; Delay mode, clock divided by 50
	move.l	(a7)+,a0
 ENDC

 IFEQ	NO_BORDER
* // Declarations here ...
	clr.b     $fffffa1b.w 
	move.b    #39,$fffffa21.w
	move.l    #Hbl_Screen_04,$120.w 
	move.b    #8,$fffffa1b.w

	move.l	a1,-(a7)
	move.l	a2,-(a7)
	lea     pal_haut,a1
	lea     $ffff8240.w,a2
	move.w	(a1)+,00(a2)
	move.w	(a1)+,02(a2)
	move.w	(a1)+,16(a2)
	move.w	(a1)+,18(a2)
	move.l	(a7)+,a2
	move.l	(a7)+,a1
 ENDC

 IFNE TIMERC
;	jsr     MUSIC+8                  ; call music
 ENDC

	movem.l	(a7)+,d0-d7/a0-a6

 IFEQ BLITTER
	bset.b	#7,$ffff8a3c.w           ; Launch Blitter
	nop
 ENDC
	rte

Hbl_Screen_04:
      clr.b     $fffffa1b.w 
      move.b    #2,$fffffa21.w
      move.b    #8,$fffffa1b.w
      move.l    #Hbl_Milieu,$120.w

      move      #$2700,sr 
      movem.l   a0/d0,-(a7) 
      lea       $fffffa21.w,a0
      move.b    (a0),d0 
.wait:cmp.b     (a0),d0 
      beq.s     .wait    
      dcb.w     6,$4e71                 ; 6 nops	Wait line end
      move.l	a1,-(a7)
      move.l	a2,-(a7)
      lea     pal_blanc,a1
      lea     $ffff8240.w,a2
      move.w	(a1)+,00(a2)
      move.w	(a1)+,02(a2)
      move.w	(a1)+,16(a2)
      move.w	(a1)+,18(a2)
      move.l	(a7)+,a2
      move.l	(a7)+,a1
      move.b    (a0),d0 
.att: cmp.b     (a0),d0 
      beq.s     .att 
      movem.l   (a7)+,a0/d0 
      move      #$2300,sr
      bclr      #0,$fffffa0f.w
      RTE 
      
Hbl_Milieu:
      clr.b     $fffffa1b.w 
      move.b    #120+1,$fffffa21.w
      move.b    #8,$fffffa1b.w
      move.l    #Hbl_Blanc,$120.w

      move      #$2700,sr 
      movem.l   a0/d0,-(a7) 
      lea       $fffffa21.w,a0
      move.b    (a0),d0 
.wait:cmp.b     (a0),d0 
      beq.s     .wait
      dcb.w     6,$4e71                 ; 6 nops	Wait line end
      move.l	a1,-(a7)
      move.l	a2,-(a7)
      lea     pal_milieu,a1
      lea     $ffff8240.w,a2
      move.w	(a1)+,00(a2)
      move.w	(a1)+,02(a2)
      move.w	(a1)+,16(a2)
      move.w	(a1)+,18(a2)
      move.l	(a7)+,a2
      move.l	(a7)+,a1
      move.b    (a0),d0 
.att: cmp.b     (a0),d0 
      beq.s     .att 
      movem.l   (a7)+,a0/d0 
      move      #$2300,sr
      bclr      #0,$fffffa0f.w
      RTE

Hbl_Blanc:
      clr.b     $fffffa1b.w 
      move.b    #2,$fffffa21.w
      move.b    #8,$fffffa1b.w
      move.l    #Hbl_Bas,$120.w

      move      #$2700,sr 
      movem.l   a0/d0,-(a7) 
      lea       $fffffa21.w,a0
      move.b    (a0),d0 
.wait:cmp.b     (a0),d0 
      beq.s     .wait
      dcb.w     6,$4e71                 ; 6 nops	Wait line end
      move.l	a1,-(a7)
      move.l	a2,-(a7)
      lea     pal_blanc,a1
      lea     $ffff8240.w,a2
      move.w	(a1)+,00(a2)
      move.w	(a1)+,02(a2)
      move.w	(a1)+,16(a2)
      move.w	(a1)+,18(a2)
      move.l	(a7)+,a2
      move.l	(a7)+,a1
      move.b    (a0),d0 
.att: cmp.b     (a0),d0 
      beq.s     .att 
      movem.l   (a7)+,a0/d0 
      move      #$2300,sr
      bclr      #0,$fffffa0f.w
      rte

Hbl_Bas:
      clr.b     $fffffa1b.w 
      move.b    #2,$fffffa21.w
      move.b    #8,$fffffa1b.w
      move.l    #Hbl_Fin,$120.w

      move      #$2700,sr 
      movem.l   a0/d0,-(a7) 
      lea       $fffffa21.w,a0
      move.b    (a0),d0 
.wait:cmp.b     (a0),d0 
      beq.s     .wait
      dcb.w     6,$4e71                 ; 6 nops	Wait line end
      move.l	a1,-(a7)
      move.l	a2,-(a7)
      lea     pal_bas,a1
      lea     $ffff8240.w,a2
      move.w	(a1)+,00(a2)
      move.w	(a1)+,02(a2)
      move.w	(a1)+,16(a2)
      move.w	(a1)+,18(a2)
      move.l	(a7)+,a2
      move.l	(a7)+,a1
      move.b    (a0),d0 
.att: cmp.b     (a0),d0 
      beq.s     .att 
      movem.l   (a7)+,a0/d0 
      move      #$2300,sr
      bclr      #0,$fffffa0f.w
      rte

Hbl_Fin:
      clr.b     $fffffa1b.w 
      bclr      #0,$fffffa0f.w
 IFNE TIMERC
      movem.l	d0-d7/a0-a6,-(a7)
      jsr (MUSIC+8)                     ; Play SNDH music
      movem.l	(a7)+,d0-d7/a0-a6
 ENDC
Hbl_raster_TopEnd_4:
      rte

timer_Screen_04_stop:
	move #$2700,SR                   ; Interrupts OFF
	move.l	#Hbl_raster_TopEnd_4,$120.w
	stop #$2300                      ; Interrupts ON
	move.l	#Vbl,$70.w
	clr.b	$fffffa1b.w
	rts

SCREEN_04_palette:
	dc.w	$0
	dcb.w	15,$566
pal_haut:
	dc.w	$0201,$0302,$0302,$0302
pal_milieu:
	dc.w	$0012,$0023,$0023,$0023
pal_bas:
	dc.w	$0022,$0032,$0032,$0032
pal_blanc:
	dc.w	$0777,$0777,$0777,$0777
	even