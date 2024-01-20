Launch_introfx:
	movem.l	d0-d7/a0-a6,-(a7)

	lea	greg_palette,a0              ; Put Default palette
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d7               ;
	movem.l	d0-d7,(a1)               ;

  lea	greg_picture,a0              ; image source
	lea	Buffer_Screen,a1             ; destination
	jsr	lz4_depack                   ; Depack!

	move.l	physique(pc),d0          ; Put physical Screen
	move.b	d0,d1                    ;
	lsr.w #8,d0                      ;
	move.b	d0,$ffff8203.w           ;
	swap d0                          ;
	move.b	d0,$ffff8201.w           ;
	move.b	d1,$ffff820d.w           ;

	lea	Buffer_Random,a5	           ; RANDOM BUFFER
	lea	Buffer_Screen,a4	           ; SOURCE PICTURE
	move.l	physique(pc),a3	         ; DESTINATION
	bsr	fizz_display                 ; DISPLAY EFFECT

	bsr	init_introfx

	bsr	temporisation

	movem.l	(a7)+,d0-d7/a0-a6
	rts

Vbl_introfx:
	clr.b     $fffffa1b.w 
	move.b    #1,$fffffa21.w
	move.b    #8,$fffffa1b.w

	st	Vsync                        ; Synchronisation

	movem.l	d0/a0-a1,-(a7)

	move.l    #Buffer_Color,ptr_Buffer_Color
	addq.w    #2,cnt_color
	cmpi.w    #35*8*2,cnt_color 
	bne.s     .nocolor
	clr.w     cnt_color 
.nocolor:
	lea       Buffer_Color,a1
	lea       raster_colors,a0
	adda.w    cnt_color,a0
	moveq     #24,d0 ; nb de ligne à afficher
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

	movem.l	(a7)+,d0/a0-a1
	rte

Hbl_introfx:
	move.l   a0,-(a7)
	movea.l   ptr_Buffer_Color,a0
	move.w    (a0)+,$ffff8242.w 
	move.l    a0,ptr_Buffer_Color
	movea.l   (a7)+,a0
	rte

init_introfx:
	move #$2700,SR                   ; Interrupts OFF
	sf	$fffffa21.w
	sf	$fffffa1b.w
  move.l	#Hbl_introfx,$120.w 
	bset	#0,$fffffa07.w	* Timer B on
	bset	#0,$fffffa13.w	* Timer B on
  move.l	#Vbl_introfx,$70.w
	stop	#$2300                     ; Interrupts ON

	bclr #3,$fffffa17.w              ; Automatic End-Interrupt hbl ON
	rts

; d7.w : temps de la boucle en word
temporisation:
	move.w	#$ff,d7
wait_more:
	bsr	Wait_vbl
	dbra	d7,wait_more
	rts

ptr_Buffer_Color:
	dc.l	0
fond_pic equ $112
fade_color equ $102
pic_color equ $204
raster_colors:	even
	dcb.w	3*8*2,fond_pic
	dc.w	$102,$204,$315,$426,$537,$426,$315,$204
	dc.w	$102,fade_color,fade_color,fade_color,fade_color,fade_color,fade_color,fade_color
	dcb.w	3*8*40,pic_color
cnt_color:
	ds.w	1
Buffer_Color:
	ds.b	8*8*10
	even
