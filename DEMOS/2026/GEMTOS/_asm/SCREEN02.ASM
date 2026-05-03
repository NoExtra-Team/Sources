init_Screen_02:
; Display NoEXtra Logo
BASELOGO2 equ 160*060              ;
	lea	physique(pc),a6              ;
	move.l	(a6)+,a0                 ;
	move.l	(a6)+,a1                 ;
	add.w		#BASELOGO2,a0            ;
	add.w		#BASELOGO2,a1            ;
	movea.l	#SCREEN_02_Logo,a4       ;
	move.l	#160*37/4-1,d0           ;
	move.l	(a4),(a0)+               ;
	move.l	(a4)+,(a1)+              ;
	dbf	d0,*-4                       ;
; Display Top Line - color 16
	move.l	physique(pc),a0          ; Fill PATTERN in Screen #1
	move.l	physique+4(pc),a1        ; Fill PATTERN in Screen #1
	move.w  #160/4-1,d7              ;
	move.l  #$ffffffff,(a0)+         ;
	move.l  #$ffffffff,(a1)+         ;
	dbf	    d7,*-6*2                 ;
; Display Bottom Line - color 16
	move.l	physique(pc),a0          ; Fill PATTERN in Screen #1
	move.l	physique+4(pc),a1        ; Fill PATTERN in Screen #1
	add.w		#160*199,a0              ;
	add.w		#160*199,a1              ;
	move.w  #160/4-1,d7              ;
	move.l  #$ffffffff,(a0)+         ;
	move.l  #$ffffffff,(a1)+         ;
	dbf	    d7,*-6*2                 ;
	rts

timer_Screen_02_start:
	move #$2700,SR                   ; Interrupts OFF
	sf $fffffa21.w                   ; Timer B data (number of scanlines to next interrupt)
	sf $fffffa1b.w                   ; Timer B control (event mode (HBL))
	lea	Hbl_Screen_02(pc),a0         ; Launch HBL
	move.l a0,$120.w                 ;
	bset #0,$fffffa07.w              ; Timer B vector
	bset #0,$fffffa13.w              ; Timer B on
	stop #$2300                      ; Interrupts ON
	move.l	#Vbl_Screen_02,$70.w
	rts

Vbl_Screen_02:
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
	clr.b	$fffffa1b.w 
	move.l	#Hbl_Screen_02,$120.w
	move.b	#1,$fffffa21.w
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

Hbl_Screen_02:
	clr.b	$fffffa1b.w
	move.l	#$00120777,$ffff8240.w
	move.l	#timer_midle_Screen_02,$120.w
	move.b	#170,$fffffa21.w
	move.b	#8,$fffffa1b.w	
	rte

timer_midle_Screen_02:
	clr.b	$fffffa1b.w
	move.l	#$01230555,$ffff8240.w
	move.l	#timer_end_Screen_02,$120.w
	move.b	#28,$fffffa21.w
	move.b	#8,$fffffa1b.w	
	rte

timer_end_Screen_02:
	clr.b     $fffffa1b.w
	move.w	#$0001,$ffff8240.w
Hbl_raster_TopEnd:
	bclr	#0,$fffffa0f.w
 IFNE TIMERC
	movem.l	d0-d7/a0-a6,-(a7)
	jsr     MUSIC+8                  ; call music
	movem.l	(a7)+,d0-d7/a0-a6
 ENDC
Hbl_raster_TopEnd_2:
	rte

timer_Screen_02_stop:
	move #$2700,SR                   ; Interrupts OFF
	move.l	#Hbl_raster_TopEnd_2,$120.w
	stop #$2300                      ; Interrupts ON
	bsr	Wait_vbl                     ; Waiting after the VBL
	move.l	#Vbl,$70.w
	clr.b	$fffffa1b.w
	rts

Mirroring:
	movea.l	physique(pc),a0
	lea	160*160(a0),a0
	movea.l	physique(pc),a1
	lea	160*180(a1),a1
	move	#10,d1                     ; number of lines to copy
.loop;
i	set	0
 rept	20                        	 ; repeat chunks (1 chunk=16 pixels)
	move.w	i(a0),i(a1)              ; copy 1st half of a chunk (logical)
i	set	i+8                          ; next chunk
 endr                              ; end of copying chunks
	sub.l	#160*2,a0                  ; next scanline line for logical
	add.l	#160*1,a1                  ; next scanline line for piccy
	dbf	d1,.loop                     ; end of copying lines
	rts