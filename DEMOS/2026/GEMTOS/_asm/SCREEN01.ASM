init_Screen_01:
	lea	SCREEN_01_palette,a0         ; Put Default palette
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d7               ;
	movem.l	d0-d7,(a1)               ;

	jsr	print_textASCII
	rts

timer_Screen_01_start:
	move #$2700,SR                   ; Interrupts OFF
	sf	$fffffa21.w
	sf	$fffffa1b.w
	bset	#0,$fffffa07.w             ; Timer B on
	bset	#0,$fffffa13.w             ; Timer B on
  move.l	#Hbl_Screen_01,$120.W
	stop #$2300                      ; Interrupts ON
	move.l	#Vbl_Screen_01,$70.w
	rts

Vbl_Screen_01:
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
	move.b    #1,$fffffa21.w
	move.b    #8,$fffffa1b.w
	move.l    #THE_COLOR,PTR_THE_COLOR
	addq.w    #2,COUNT_COLOR
	cmpi.w    #177,COUNT_COLOR 
	bne.s     .next 
	clr.w     COUNT_COLOR 
.next:
	lea       THE_COLOR,a1
	lea       PAL_COLOR,a0
	adda.w    COUNT_COLOR,a0
	moveq     #23,d0 ; nb de ligne à afficher
.loop:
	move.w    00(a0),(a1)+
	move.w    02(a0),(a1)+ 
	move.w    04(a0),(a1)+ 
	move.w    06(a0),(a1)+ 
	move.w    08(a0),(a1)+ 
	move.w    10(a0),(a1)+
	move.w    12(a0),(a1)+
	move.w    14(a0),(a1)+
	addq.w    #2,a0 
	dbf       d0,.loop
 ENDC

 IFNE TIMERC
	jsr     MUSIC+8                  ; call music
 ENDC

	movem.l	(a7)+,d0-d7/a0-a6

 IFEQ BLITTER
	bset.b	#7,$ffff8a3c.w           ; Launch Blitter
	nop
 ENDC
	rte

Hbl_Screen_01:
	move.l	a0,-(a7)
	movea.l   PTR_THE_COLOR,a0
	move.w    (a0)+,$ffff8242.w
	move.l    a0,PTR_THE_COLOR
	move.l	(a7)+,a0
Hbl_raster_TopEnd_1:
	rte

timer_Screen_01_stop:
	move #$2700,SR                   ; Interrupts OFF
	move.l	#Hbl_raster_TopEnd_1,$120.w
	stop #$2300                      ; Interrupts ON
	move.l	#Vbl,$70.w
	clr.b	$fffffa1b.w
	rts

CFOND EQU $0102
CTEXT EQU $0001

SCREEN_01_palette:
	dcb.w	16,CFOND

COUNT_COLOR:
	ds.l	1
PTR_THE_COLOR:
	dc.l	THE_COLOR
THE_COLOR:
	ds.b	186*2+50
PAL_COLOR:
ad3 = -$004
	dcb.w	8*5,CTEXT
	dc.w	$0805+ad3,$010D+ad3,$0906+ad3,$020E+ad3,$0A07+ad3,$038F+ad3,$0B1F+ad3,$049F+ad3
	dc.w	$0C2F+ad3,$05AF+ad3,$0D3F+ad3,$06BF+ad3,$0E4F+ad3,$07CF+ad3,$0F5F+ad3,$0FDF+ad3
	dc.w	$0F6F+ad3,$0FEF+ad3,$0FEF+ad3,$0F6F+ad3,$0FDF+ad3
	dc.w	$0F5F+ad3,$07CF+ad3,$0E4F+ad3,$06BF+ad3,$0D3F+ad3,$05AF+ad3,$0C2F+ad3,$049F+ad3
	dc.w	$0B1F+ad3,$038F+ad3,$0A07+ad3,$020E+ad3,$0906+ad3,$010D+ad3,$0805+ad3
	dcb.w	8*6,CFOND
	even
