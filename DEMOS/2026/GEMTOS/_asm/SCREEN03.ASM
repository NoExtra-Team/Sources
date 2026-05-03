init_Screen_03:
BASELOGO3 equ 160*155
	lea	physique(pc),a6
	move.l	(a6)+,a0
	move.l	(a6)+,a1
	add.w		#BASELOGO3,a0
	add.w		#BASELOGO3,a1
	movea.l	#SCREEN_03_Logo,a4
	move.l	#160*45/4-1,d0
	move.l	(a4),(a0)+
	move.l	(a4)+,(a1)+
	dbf	d0,*-4
	rts

timer_Screen_03_start:
	move #$2700,SR                   ; Interrupts OFF
	sf $fffffa21.w                   ; Timer B data (number of scanlines to next interrupt)
	sf $fffffa1b.w                   ; Timer B control (event mode (HBL))
	lea	Hbl_Screen_03(pc),a0         ; Launch HBL
	move.l a0,$120.w                 ;
	ori.b	#1,$fffffa07.w
	ori.b	#1,$fffffa13.w
	stop #$2300                      ; Interrupts ON
	move.l	#Vbl_Screen_03,$70.w
	rts

Vbl_Screen_03:
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
	clr.b	$fffffa1b.w                ; Timer B off
	move.l	#Hbl_Screen_03,$120.w       ; Go Timer B !
	move.b	#1,$fffffa21.w           ; First position
	move.b	#8,$fffffa1b.w
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

color_line       equ $0235
color_line_inter equ $0124
Hbl_Screen_03:
      move.w    #color_line,$ffff8240.w
      clr.b     $fffffa1b.w 
      move.b    #151,$fffffa21.w
      move.l    #Hbl_top,$120.w 
      move.b    #8,$fffffa1b.w
      move      #$2700,sr 
      movem.l   a0/d0,-(a7) 
      lea       $fffffa21.w,a0
      move.b    (a0),d0 
.wait:cmp.b     (a0),d0 
      beq.s     .wait 
      dcb.w	6,$4e71
      move.w    #color_line_inter,$ffff8240.w
      move.b    (a0),d0 
.att: cmp.b     (a0),d0 
      beq.s     .att 
      movem.l   (a7)+,a0/d0 
      move      #$2300,sr 

      move.l	a0,-(a7)
      move.l	a1,-(a7)
      lea   Pal_Squares,a0 
      movea.l   #$ff8240,a1 
      move.l    (a0)+,(a1)+ 
      move.l    (a0)+,(a1)+ 
      move.l    (a0)+,(a1)+ 
      move.l    (a0)+,(a1)+ 
      move.l	(a7)+,a1
      move.l	(a7)+,a0
  
      bclr      #0,$fffffa0f.w
      rte 

Hbl_top:
      move.w    #color_line_inter,$ffff8240.w
      clr.b     $fffffa1b.w 
      move.b    #3,$fffffa21.w
      move.l    #Hbl_bottom,$120.w 
      move.b    #8,$fffffa1b.w
      move      #$2700,sr 
      movem.l   a0/d0,-(a7) 
      lea       $fffffa21.w,a0
      move.b    (a0),d0 
.wait:cmp.b     (a0),d0 
      beq.s     .wait 
      dcb.w	6,$4e71
      move.w    #color_line,$ffff8240.w
      move.b    (a0),d0 
.att: cmp.b     (a0),d0 
      beq.s     .att 
      movem.l   (a7)+,a0/d0 
      move      #$2300,sr 

      move.l	a0,-(a7)
      move.l	a1,-(a7)
      lea   SCREEN_03_palette,a0 
      movea.l   #$ff8240,a1 
      move.l    (a0)+,(a1)+ 
      move.l    (a0)+,(a1)+ 
      move.l    (a0)+,(a1)+ 
      move.l    (a0)+,(a1)+ 
      move.l    (a0)+,(a1)+ 
      move.l    (a0)+,(a1)+ 
      move.l    (a0)+,(a1)+ 
      move.l    (a0)+,(a1)+ 
      move.l	(a7)+,a1
      move.l	(a7)+,a0
  
      bclr      #0,$fffffa0f.w
      rte
      
Hbl_bottom:
      movem.l   a0-a6/d1-d2,-(a7) 
      lea       $ffff8250.w,a0
      lea       Repeat_R1,a4
      lea       Repeat_R0,a6
      dcb.w	27-3,$4e71
      lea       $ffff8209.w,a1
      moveq     #0,d1 
      sub.b     (a1),d1 
      lsr.l     d1,d1 
      dcb.w	40,$4e71
      move.w    #NBLINE_RASTER+1,d2 
.loop:movea.l   (a4)+,a2
      movea.l   (a6)+,a3
      jsr       (a2)
      dbf       d2,.loop
      movem.l   (a7)+,a0-a6/d1-d2 

      clr.b     $fffffa1b.w
      move.l    #Hbl_end,$120.w 
      move.b    #1,$fffffa21.w
      move.b    #8,$fffffa1b.w
      rte 

Hbl_end:
      clr.b     $fffffa1b.w
      bclr	#0,$fffffa0f.w    
 IFNE TIMERC
      movem.l	d0-d7/a0-a6,-(a7)
      jsr     MUSIC+8                  ; call music
      movem.l	(a7)+,d0-d7/a0-a6
 ENDC
Hbl_raster_TopEnd_3:
      rte

timer_Screen_03_stop:
	move #$2700,SR                   ; Interrupts OFF
	move.l	#Hbl_raster_TopEnd_3,$120.w
	stop #$2300                      ; Interrupts ON
	bsr	Wait_vbl                     ; Waiting after the VBL
	move.l	#Vbl,$70.w
	clr.b	$fffffa1b.w
	rts
