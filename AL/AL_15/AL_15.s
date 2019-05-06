*************
* AL_15.PRG *
*************

* // Intro Code version 100% NoExtra	// *
* // Original code : Atomus		// *
* // BitBender code: Griff		// *
* // Gfx logo 	   : Mister.A		// *
* // Music 	   : TomChi		// *
* // Release date  : 12/11/2007		// *
* // Update date   : 23/11/2007		// *

*************************************
	OPT	c+	; Case sensitivity on.
	OPT	d-	; Debug off.
	OPT	o+	; All optimisations off.
	OPT	w-	; Warnings off.
	OPT	x-	; Extended debug off.
*************************************

	SECTION	TEXT

******************************************************
* > For use the bottom overscan effect
PATTERN		equ $0 	  ; put $0 to see nothing
			  ; put $010f to see nothing
* > Allow to see the top of the VBL on the screen
SEEMYVBL	equ 1     ; if you press key ALT 
			  ; 0 = see cpu & 1 = see nothing
*****************************************************

	move.l  4(sp),a5                ; address to basepage
	move.l  $0c(a5),d0              ; length of text segment
	add.l   $14(a5),d0              ; length of data segment
	add.l   $1c(a5),d0              ; length of bss segment
	add.l   #$1000,d0               ; length of stackpointer
	add.l   #$100,d0                ; length of basepage
	move.l  a5,d1                   ; address to basepage
	add.l   d0,d1                   ; end of program
	and.l   #-2,d1                  ; make address even
	move.l  d1,sp                   ; new stackspace

	move.l  d0,-(sp)                ; mshrink()
	move.l  a5,-(sp)                ;
	move.w  d0,-(sp)                ;
	move.w  #$4a,-(sp)              ;
	trap    #1                  	;
	lea 	12(sp),sp               ;  
	
	clr.l	-(sp)
	move.w	#32,-(sp)
	trap	#1
	addq.l	#6,sp
	move.l	d0,Save_stack

	bsr	clear_bss

	bsr Init_screens

	bsr	Save_and_init_a_st

	bsr	Init0

******************************************************************************

	bsr	Init
	
Main_rout:

	lea log_base(pc),a0
	movem.l (a0)+,d0-d1
	not.w (a0)
	move.l d0,-(a0)
	move.l d1,-(a0)			; swap screens
	lsr #8,d0
	move.l d0,$ffff8200.w		; set screen
	
	bsr.s	Wait_vbl

	IFEQ	SEEMYVBL
	clr.b	$ffff8240.w
	ENDC

	bsr	DISPLAY

	bsr plot_bitbend

	IFEQ	SEEMYVBL
	cmp.b	#$38,$fffffc02.w	* Wait
	bne.s	Suite_rout		* Alt
	move.b	#7,$ffff8240.w
Suite_rout:	
	ENDC

	cmp.b	#$39,$fffffc02.w	* Wait
	bne.s	Main_rout		* Space

******************************************************************************

	bsr	Restore_st

	move.l	Save_stack,-(sp)
	move.w	#32,-(sp)
	trap	#1
	addq.l	#6,sp

	clr.w	-(sp)
	trap	#1


************************************************
*                                              *
*               Sub Routines                   *
*                                              *
************************************************

Vbl:
	st	Vsync
	jsr 	(MUSIC+8)			; call music
	rte

Vbl0:
	movem.l	d0-d7/a0-a6,-(a7)
	st	Vsync
	jsr 	(MUSIC+8)			; call music
	movem.l	(a7)+,d0-d7/a0-a6
	rte
	
Wait_vbl:
	move.l	a0,-(a7)
	lea	Vsync,a0
	sf	(a0)
Wait_label:	
	tst.b	(a0)
	beq.s	Wait_label
	move.l	(a7)+,a0
	rts
	
************************************************
*                                              *
************************************************

fadein:
	move.l	#$777,d0
.deg:
	bsr.s	wart
	bsr.s	wart
	bsr.s	wart
	lea	$ffff8240.w,a0
	moveq	#15,d1
.chg1:
	move.w	d0,(a0)+
	dbf	d1,.chg1
	sub.w	#$111,d0
	bne.s	.deg
	clr.w	$ffff8240.w
	rts

wart:
	move.l	d0,-(sp)
	move.l	$466.w,d0
.att:
	cmp.l	$466.w,d0
	beq.s	.att
	move.l	(sp)+,d0
	rts

fadeon:
	move.w	#8-1,d0	8 stages
.loop1	move.w	#16-1,d1	16 colours
	move.l	#$ffff8240,a0	offset of palette
	move.l	a2,a1	a2 points to new colours
.loop2	move.w	(a0),d2
	andi.w	#$777,d2	Eliminate garbage
	move.w	d2,d3
	andi.w	#$F,d2	d2 contains B value
	lsr.w	#4,d3
	move.w	d3,d4
	andi.w	#$F,d3	d3 contains G value
	lsr.w	#4,d4
	andi.w	#$F,d4	d4 contains R value
	move.w	(a1)+,d5
	andi.w	#$777,d5	As above!
	move.w	d5,d6
	andi.w	#$F,d5	d5 contains B value
	lsr.w	#4,d6
	move.w	d6,d7
	andi.w	#$F,d6	d6 contains G value
	lsr.w	#4,d7
	andi.w	#$F,d7	d7 contains R value
	cmp.w	d2,d5
	beq.s	.end1	B already new colour
	addq.w	#1,d2
.end1	cmp.w	d3,d6
	beq.s	.end2	G already new colour
	addq.w	#1,d3
.end2	cmp.w	d4,d7
	beq.s	.end3	R already new colour
	addq.w	#1,d4
.end3	lsl.w	#8,d4
	lsl.w	#4,d3
	or.w	d4,d2
	or.w	d3,d2	d2 now contains RGB value
	move.w	d2,(a0)+
	dbra	d1,.loop2	Next colour
	rept	6
	bsr	Wait_vbl
	endr
	dbra	d0,.loop1	Next stage
	rts

fadeoff:
	move.w	#8-1,d0	Maximum of 8 stages
.loop1 	move.w	#16-1,d1	16 colours!
	move.l	#$ffff8240,a0	offset of palette
.loop2	move.w	(a0),d2
	andi.w	#$777,d2	Eliminate garbage
	move.w	d2,d3
	andi.w	#$F,d2	d2 contains B value
	lsr.w	#4,d3
	move.w	d3,d4
	andi.w	#$F,d3	d3 contains G value
	lsr.w	#4,d4
	andi.w	#$F,d4	d4 contains R value
	tst.w	d2
	beq.s	.end1	B already zero
	subq.w	#1,d2
.end1	tst.w	d3
	beq.s	.end2	G already zero
	subq.w	#1,d3
.end2	tst.w	d4
	beq.s	.end3	R already zero
	subq.w	#1,d4
.end3	lsl.w	#8,d4
	lsl.w	#4,d3
	or.w	d4,d2
	or.w	d3,d2	D2 now contains RGB value
	move.w	d2,(a0)+
	dbra	d1,.loop2	Next colour
	rept	6
	bsr	Wait_vbl
	endr
	dbra	d0,.loop1	Next stage
	rts

delay:
  move.b	#$7F,D0 
.synch:
	bsr	Wait_vbl
	sub.b	#1,d0
	cmp.b	#$0,d0	
	bne.s	.synch
	rts	
			
*********************************************
*                                           *
*********************************************

Init:	movem.l	d0-d7/a0-a6,-(a7)

	lea	Vbl(pc),a0
	move.l	a0,$70.w

	lea	Pal(pc),a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

	movem.l	(a7)+,d0-d7/a0-a6
	rts

Init0:	movem.l	d0-d7/a0-a6,-(a7)

	bsr	fadein
	
	clr.w	$ffff8240.w
	
	jsr	MUSIC+0			; init music

	movea.l	log_base(pc),a1
	adda.l	#160*76,a1
	movea.l	#LogoNoeXtra,a0
	move.l	#7999-6800+180,d0
.aff:	move.l	(a0)+,(a1)+
	dbf	d0,.aff
                	
	lea	Vbl0(pc),a0
	move.l	a0,$70.w

	lea     PalNoeXtra,a2
	bsr     fadeon	

	lea	PalNoeXtra,a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

	bsr	delay

	BSR       PRE_DECAL
	bsr flip_chars
	bsr create_routs
	bsr create_initbuf	

	bsr	fadeoff

	move.l log_base(pc),a0
	bsr	clear_screen

	movem.l	(a7)+,d0-d7/a0-a6
	rts

************************************************
*                                              *
************************************************

Save_and_init_a_st:

	move #$2700,sr
		
	lea	Save_all,a0

	move.b	$fffffa03.w,(a0)+
	move.b	$fffffa07.w,(a0)+
	move.b	$fffffa09.w,(a0)+
	move.b	$fffffa11.w,(a0)+
	move.b	$fffffa13.w,(a0)+
	move.b	$fffffa15.w,(a0)+
	move.b	$fffffa17.w,(a0)+
	move.b	$fffffa19.w,(a0)+

	move.b	$fffffa1b.w,(a0)+
	move.b	$fffffa1d.w,(a0)+
	move.b	$fffffa1f.w,(a0)+
	move.b	$fffffa21.w,(a0)+

	move.b	$ffff8201.w,(a0)+
	move.b	$ffff8203.w,(a0)+
	move.b	$ffff820a.w,(a0)+
	move.b	$ffff820d.w,(a0)+
	
	move.b	$ffff8260.w,(a0)+

	lea	Save_rest,a0

	move.l	$068.w,(a0)+	
	move.l	$070.w,(a0)+	
	move.l	$110.w,(a0)+	
	move.l	$114.w,(a0)+	
	move.l	$118.w,(a0)+	
	move.l	$120.w,(a0)+	
	move.l	$134.w,(a0)+	
	move.l	$484.w,(a0)+	

	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,(a0)

	bclr	#3,$fffffa17.w

	sf	$ffff8260.w

	clr.b     $fffffa07.w 
	clr.b     $fffffa09.w 

	stop	#$2300

	clr.b	$484.w		; No bip,no repeat.
			
	bsr	hide_mouse

	bsr	flush
	move.b	#$12,d0
	bsr	setkeyboard

	move.l	log_base(pc),d0
	move.b	d0,d1
	lsr.w	#8,d0
	move.b	d0,$ffff8203.w
	swap	d0
	move.b	d0,$ffff8201.w
	move.b	d1,$ffff820d.w
		
	rts

***************************************************************
*                                                             *
***************************************************************

Restore_st:

	move #$2700,sr

	jsr	MUSIC+4			; de-init music

	lea       $ffff8800.w,a0
	move.l    #$8000000,(a0)
	move.l    #$9000000,(a0)
	move.l    #$a000000,(a0)
	
	lea	Save_all,a0
	
	move.b	(a0)+,$fffffa03.w
	move.b	(a0)+,$fffffa07.w
	move.b	(a0)+,$fffffa09.w
	move.b	(a0)+,$fffffa11.w
	move.b	(a0)+,$fffffa13.w
	move.b	(a0)+,$fffffa15.w
	move.b	(a0)+,$fffffa17.w
	move.b	(a0)+,$fffffa19.w

	move.b	(a0)+,$fffffa1b.w
	move.b	(a0)+,$fffffa1d.w
	move.b	(a0)+,$fffffa1f.w
	move.b	(a0)+,$fffffa21.w
	
	move.b	(a0)+,$ffff8201.w
	move.b	(a0)+,$ffff8203.w
	move.b	(a0)+,$ffff820a.w
	move.b	(a0)+,$ffff820d.w
	
	move.b	(a0)+,$ffff8260.w

	lea	Save_rest,a0

	move.l	(a0)+,$068.w
	move.l	(a0)+,$070.w
	move.l	(a0)+,$110.w
	move.l	(a0)+,$114.w
	move.l	(a0)+,$118.w
	move.l	(a0)+,$120.w
	move.l	(a0)+,$134.w
	move.l	(a0)+,$484.w

	movem.l	(a0),d0-d7
	movem.l	d0-d7,$ffff8240.w

	bset.b #3,$fffffa17.w

	stop	#$2300

	bsr	flush
	move.b	#8,d0
	bsr	setkeyboard	
	
	bsr	show_mouse

	move.b	Video,$ffff8260.w

	move.w	#$25,-(a7)
	trap	#14
	addq.w	#2,a7

	rts

************************************************
*                                              *
************************************************

hide_mouse:
	movem.l	d0-d2/a0-a2,-(sp)
	dc.w	$a00a
	movem.l	(sp)+,d0-d2/a0-a2
	rts

show_mouse:
	movem.l	d0-d2/a0-a2,-(sp)
	dc.w	$A009
	movem.l	(sp)+,d0-d2/a0-a2
	rts

flush:
	lea	$FFFFFC00.w,a0
.flush:
	move.b	2(a0),d0
	btst	#0,(a0)
	bne.s	.flush
	rts

setkeyboard:
.wait:
	btst	#1,$fffffc00.w
	beq.s	.wait
	move.b	d0,$FFFFFC02.w
	rts

clear_bss:
	lea	bss_start,a0
.loop:
	clr.l	(a0)+
	cmp.l	#bss_end,a0
	blt.s	.loop
	rts

************************************************
*                                              *
************************************************

Init_screens
		movem.l	d0-d7/a0-a6,-(a7)
		lea log_base(pc),a1
		move.l #screens+256,d0
		clr.b d0
		move.l d0,(a1)+
		add.l #32000,d0
		move.l d0,(a1)+
		move.l log_base(pc),a0
		bsr clear_screen
		move.l phy_base(pc),a0
		bsr clear_screen
		movem.l	(a7)+,d0-d7/a0-a6
		rts

clear_screen
		movem.l	d0-d7/a0-a6,-(a7)
		moveq #PATTERN,d0
		move #1999,d1
.cls:move.l d0,(a0)+
		move.l d0,(a0)+
		move.l d0,(a0)+
		move.l d0,(a0)+
		dbf d1,.cls
		movem.l	(a7)+,d0-d7/a0-a6
		rts

**************************************************************
MEMORY_BASE equ $37800	* memoire où on recopie notre vignette
HAUTEUR equ 49  } Coordonnées de la vignette 2 ou 3 plans
LARGEUR equ 62  } 
**************************************************************

PRE_DECAL:LEA       MEMORY_BASE,A0 * recopie de la vignette
      LEA       LOGO_IMG(PC),A1
      MOVEQ     #HAUTEUR,D0
.rep1:MOVEQ     #7,D1 
.rep2:MOVE.L    (A1)+,(A0)+ 
      DBF       D1,.rep2
      DBF       D0,.rep1
      LEA       MEMORY_BASE,A1 
      BSR.S     NEXT_LINE 
      MOVEQ     #LARGEUR,D0
      LEA       MEMORY_BASE,A1 
mloop:BSR.S     NEXT_LINE 
      LEA       -(160*10)(A0),A0
      MOVEQ     #HAUTEUR,D2 
mrep3:MOVEQ     #3,D1 
.rep4:MOVE.W    (A0),D3 
      MOVE      #0,CCR
      ROXL.W    #1,D3 
      ROXL      24(A0)
      ROXL      16(A0)
      ROXL      8(A0) 
      ROXL      (A0)
      ADDQ.L    #2,A0 
      DBF       D1,.rep4
      LEA       24(A0),A0 
      DBF       D2,mrep3
      LEA       (160*10)(A1),A1 
      BSR.S     NEXT_LINE 
      LEA       -(160*10)(A1),A1
      DBF       D0,mloop
      RTS 
      
NEXT_LINE:MOVE.W    #400-1,D1
.loop:MOVE.L    (A1)+,(A0)+ 
      DBF       D1,.loop
      RTS 

DISPLAY:
      LEA       DATAC03(PC),A1
      LEA       DATAC04(PC),A2
      LEA       DATAC02(PC),A3
      LEA       DATAC01(PC),A4
      MOVEQ     #0,D1 
      MOVEQ     #0,D2 
      MOVEQ     #0,D3 
      MOVE.W    (A1),D1 
      ADD.W     (A2)+,D1
      CMP.W     #$168,D1
      BCS.S     .next 
      SUBI.W    #360,D1
.next:MOVE.W    D1,(A1)+
      ADD.W     D1,D1 
      ADDI.B    #6,(A4) 
      MOVE.B    0(A3,D1.W),D2 
      ADD.B     (A4),D2 
      MOVE.W    (A1),D1 
      ADD.W     (A2)+,D1
      CMP.W     #360,D1
      BCS.S     .suite 
      SUBI.W    #360,D1
.suite:MOVE.W    D1,(A1)+
      ADD.W     D1,D1 
      MOVE.B    1(A3,D1.W),D3 
      ANDI.L    #$3F,D2 
      MULU      #$C80,D2
      LEA       MEMORY_BASE,A0 
      ADDA.L    D2,A0 
      LSL.L     #5,D3 
      ADDA.L    D3,A0 
      BSR.S     PUT_DECAL      
      RTS
      
PUT_DECAL:MOVEA.L   log_base(pc),A1
      MOVEQ     #HAUTEUR,D0
.loop:MOVEM.L   (A0)+,A2/D1-D7
      MOVEM.L   A2/D1-D7,(A1) 
      MOVEM.L   A2/D1-D7,32(A1) 
      MOVEM.L   A2/D1-D7,64(A1) 
      MOVEM.L   A2/D1-D7,96(A1) 
      MOVEM.L   A2/D1-D7,128(A1)
      
      MOVEM.L   A2/D1-D7,8000(A1) 
      MOVEM.L   A2/D1-D7,8032(A1) 
      MOVEM.L   A2/D1-D7,8064(A1) 
      MOVEM.L   A2/D1-D7,8096(A1) 
      MOVEM.L   A2/D1-D7,8128(A1) 
      
      MOVEM.L   A2/D1-D7,16000(A1)
      MOVEM.L   A2/D1-D7,16032(A1)
      MOVEM.L   A2/D1-D7,16064(A1)
      MOVEM.L   A2/D1-D7,16096(A1)
      MOVEM.L   A2/D1-D7,16128(A1)
      
      MOVEM.L   A2/D1-D7,24000(A1)
      MOVEM.L   A2/D1-D7,24032(A1)
      MOVEM.L   A2/D1-D7,24064(A1)
      MOVEM.L   A2/D1-D7,24096(A1)
      MOVEM.L   A2/D1-D7,24128(A1)
      
      LEA       160(A1),A1
      DBF       D0,.loop
      RTS 		

*****************************************************
* Original Bit Bender routs by Griff
speed		EQU 4				; scroll speed
wavespeed	EQU 20				; wave speed
*****************************************************
plot_bitbend:
		move.l scrlpoint(pc),a0		; text ptr
		move.w scrloffset(pc),d1	; offset with text
		moveq	#0,d0
		move.b (a0),d0
		sub.b #32,d0
		lsl #5,d0
		lea font32(pc),a2
		add d1,d0
		add d0,a2			; point to current strip
		move buff_ptr(pc),d2
		add #8*speed,d2			; advance buffer postion
		cmp #(320-speed)*8,d2
		ble.s .no_loop
		moveq	#0,d2
.no_loop	move.w d2,buff_ptr		; save buffer pos
		lea buffer(pc),a1
		add buff_ptr(pc),a1
i		set 0
		rept speed			; now add strip to buffer
		moveq	#0,d0
		move.b (a2)+,d0
		add d0,d0
		add d0,d0
		lea jmptab1,a4		; but we add rout address!!
		add d0,a4
		move.l (a4),i+(320-speed)*8(a1)
		move.l (a4),i-(8*speed)(a1)
		moveq	#0,d0
		move.b (a2)+,d0
		add d0,d0
		add d0,d0
		lea jmptab2,a4		; byte 2 rout address
		add d0,a4
		move.l (a4),i+4+(320-speed)*8(a1)		
		move.l (a4),i+4-(8*speed)(a1)
i		set i+8
		endr
		addq #2*speed,d1			; advance pos within char
		cmp #32,d1
		blt.s .notnext			; onto next letter?
		clr.w d1
		addq.l #1,a0			; yes, add one to textptr
		tst.b (a0)			; wrap?
		bne.s .notnext
		lea text(pc),a0			; yes reset text ptr
.notnext	move.l a0,scrlpoint		; store text ptr
		move.w d1,scrloffset		;   "   offset within char
; Now plot the bastard to the screen. (using the generated routines)
		lea buffer(pc),a1
		add buff_ptr(pc),a1		; point to curr buff adress
		lea verticalbuf1,a6		; wave base
		move.w wave_ptr(pc),d0
		add d0,a6			; a6-> y wave(*160)
		add #20,d0			; advance wave
		and #$7fe,d0
		move.w d0,wave_ptr		; store wave position
		tst switch
		beq.s .cse1
		move.l a6,old_ptr1		; store wave position
		bra.s .cse2
.cse1		move.l a6,old_ptr2		; (for clearing scroller)
.cse2		move.l log_base(pc),d2		; screen base 
	add.l	#(160*4)+6,d2 *----> le plan !!!
; Macro to plot first strip (bit 7)
plotstrip1	macro
		move.l d2,a0
		adda.w (a6)+,a0
		move #\1,d0
		move.l (a1)+,a2
		move.l (a1)+,a3
		jsr (a2)
		endm
; Macro to plot other strips (bits 0-6)
plotstrip	macro
		move.l d2,a0
		adda.w (a6)+,a0
		moveq #\1,d0
		move.l (a1)+,a2
		move.l (a1)+,a3
		jsr (a2)
		endm

		rept 20
		plotstrip1 %10000000
		plotstrip  %01000000
		plotstrip  %00100000
		plotstrip  %00010000
		plotstrip  %00001000
		plotstrip  %00000100
		plotstrip  %00000010
		plotstrip  %00000001
		addq.l #1,d2
		plotstrip1 %10000000
		plotstrip  %01000000
		plotstrip  %00100000
		plotstrip  %00010000
		plotstrip  %00001000
		plotstrip  %00000100
		plotstrip  %00000010
		plotstrip  %00000001
		addq.l #7,d2
		endr
		rts	

; Routine to rotate the 32*32 1 plane font 90 degrees. After
; flipping the font lies horizontally bitwise within a longword.
flip_chars:
	lea font32(pc),a0
		moveq #59,d6
.lp1		lea tempbuf(pc),a1
		move.l a0,a2
		moveq #15,d1
.copylp		move.W (a2)+,(a1)+
		dbf d1,.copylp
		moveq #15,d3
.lp2		moveq #0,d2
		lea tempbuf(pc),a1
		rept 16
		move.w (a1),d1	
		add.w d1,d1
		addx.w d2,d2
		move.w d1,(a1)+
		endr
		move.w d2,(a0)+
		dbf d3,.lp2 
		dbf d6,.lp1
		rts

tempbuf:
	ds.w  16

; Create the routs to draw strips of bit bender.
create_routs:
		lea routs,a0
		move doOR(pc),d5	
		move doOR1(pc),d6
		lea jmptab1(pc),a5
		move.w doJMP1(pc),d4
		moveq.w #0,d3
		bsr create1
		lea jmptab2(pc),a5
		move.w #$4E75,d4
		move.w #8*160,d3
		bsr create1
		rts

create1:
		moveq #0,d0
.makelp		move.l a0,(a5)+		; store pointer to routine
		moveq #7,d1
		move d3,d2
.make1lp	btst d1,d0
		beq.s .cont		
		tst d2
		bne.s .norm
		move.w d6,(a0)+
		bra.s .cont
.norm		move.w d5,(a0)+		; command word MOVE or OR!
		move.w d2,(a0)+		; offset
.cont		add #160,d2		; onto next line
		dbf d1,.make1lp
		move.w d4,(a0)+		; 
		addq #1,d0
		cmp #256,d0
		bne.s .makelp
		rts

; Routine to create initial 'nul' buffer + make waveform.
create_initbuf:
		lea buffer(pc),a0
		move.l jmptab1(pc),a1
		move.l jmptab2(pc),a2
		move.w #(320*2)-1,d0
.init_lp	move.l a1,(a0)+
		move.l a2,(a0)+
		dbf d0,.init_lp
make_wave1	lea verticalbuf1,A0
		move #2047,D0
		lea trigtab(PC),A1
		clr D2
.crlp		moveq #80,D1
		muls (A1,D2),D1
		addq #2,D2
		and #$7FE,D2
		add.l D1,D1
		swap D1
		muls #160,d1
		add.w #90*160,d1
		move.w D1,(A0)+
		dbf d0,.crlp
		rts

******************************************************************
	SECTION	DATA
******************************************************************
	
Pal:	
	dc.w	$0000,$0001,$0112,$0000,$0889,$0000,$099A,$0000
	dc.w	$0777,$0777,$0777,$0000,$0777,$0000,$0777,$0FFF

trigtab:
		dc.w	$7FFF,$7FFE,$7FFC,$7FF9,$7FF5,$7FEF,$7FE8,$7FE0 
		dc.w	$7FD7,$7FCD,$7FC1,$7FB4,$7FA6,$7F96,$7F86,$7F74 
		dc.w	$7F61,$7F4C,$7F37,$7F20,$7F08,$7EEF,$7ED4,$7EB9 
		dc.w	$7E9C,$7E7E,$7E5E,$7E3E,$7E1C,$7DF9,$7DD5,$7DB0 
		dc.w	$7D89,$7D61,$7D38,$7D0E,$7CE2,$7CB6,$7C88,$7C59 
		dc.w	$7C29,$7BF7,$7BC4,$7B91,$7B5C,$7B25,$7AEE,$7AB5 
		dc.w	$7A7C,$7A41,$7A04,$79C7,$7989,$7949,$7908,$78C6 
		dc.w	$7883,$783F,$77F9,$77B3,$776B,$7722,$76D8,$768D 
		dc.w	$7640,$75F3,$75A4,$7554,$7503,$74B1,$745E,$740A 
		dc.w	$73B5,$735E,$7306,$72AE,$7254,$71F9,$719D,$7140 
		dc.w	$70E1,$7082,$7022,$6FC0,$6F5E,$6EFA,$6E95,$6E30 
		dc.w	$6DC9,$6D61,$6CF8,$6C8E,$6C23,$6BB7,$6B4A,$6ADB 
		dc.w	$6A6C,$69FC,$698B,$6919,$68A5,$6831,$67BC,$6745 
		dc.w	$66CE,$6656,$65DD,$6562,$64E7,$646B,$63EE,$6370 
		dc.w	$62F1,$6271,$61F0,$616E,$60EB,$6067,$5FE2,$5F5D 
		dc.w	$5ED6,$5E4F,$5DC6,$5D3D,$5CB3,$5C28,$5B9C,$5B0F 
		dc.w	$5A81,$59F3,$5963,$58D3,$5842,$57B0,$571D,$5689 
		dc.w	$55F4,$555F,$54C9,$5432,$539A,$5301,$5268,$51CE 
		dc.w	$5133,$5097,$4FFA,$4F5D,$4EBF,$4E20,$4D80,$4CE0 
		dc.w	$4C3F,$4B9D,$4AFA,$4A57,$49B3,$490E,$4869,$47C3 
		dc.w	$471C,$4674,$45CC,$4523,$447A,$43D0,$4325,$4279 
		dc.w	$41CD,$4120,$4073,$3FC5,$3F16,$3E67,$3DB7,$3D07 
		dc.w	$3C56,$3BA4,$3AF2,$3A3F,$398C,$38D8,$3824,$376F 
		dc.w	$36B9,$3603,$354D,$3496,$33DE,$3326,$326D,$31B4 
		dc.w	$30FB,$3041,$2F86,$2ECC,$2E10,$2D54,$2C98,$2BDB 
		dc.w	$2B1E,$2A61,$29A3,$28E5,$2826,$2767,$26A7,$25E7 
		dc.w	$2527,$2467,$23A6,$22E4,$2223,$2161,$209F,$1FDC 
		dc.w	$1F19,$1E56,$1D93,$1CCF,$1C0B,$1B46,$1A82,$19BD 
		dc.w	$18F8,$1833,$176D,$16A7,$15E1,$151B,$1455,$138E 
		dc.w	$12C7,$1200,$1139,$1072,$0FAB,$0EE3,$0E1B,$0D53 
		dc.w	$0C8B,$0BC3,$0AFB,$0A32,$096A,$08A1,$07D9,$0710 
		dc.w	$0647,$057E,$04B6,$03ED,$0324,$025B,$0192,$00C9 
		dc.w	$0000,$FF37,$FE6E,$FDA5,$FCDC,$FC13,$FB4A,$FA82 
		dc.w	$F9B9,$F8F0,$F827,$F75F,$F696,$F5CE,$F505,$F43D 
		dc.w	$F375,$F2AD,$F1E5,$F11D,$F055,$EF8E,$EEC7,$EE00 
		dc.w	$ED39,$EC72,$EBAB,$EAE5,$EA1F,$E959,$E893,$E7CD 
		dc.w	$E708,$E643,$E57E,$E4BA,$E3F5,$E331,$E26D,$E1AA 
		dc.w	$E0E7,$E024,$DF61,$DE9F,$DDDD,$DD1C,$DC5A,$DB99 
		dc.w	$DAD9,$DA19,$D959,$D899,$D7DA,$D71B,$D65D,$D59F 
		dc.w	$D4E2,$D425,$D368,$D2AC,$D1F0,$D134,$D07A,$CFBF 
		dc.w	$CF05,$CE4C,$CD93,$CCDA,$CC22,$CB6A,$CAB3,$C9FD 
		dc.w	$C947,$C891,$C7DC,$C728,$C674,$C5C1,$C50E,$C45C 
		dc.w	$C3AA,$C2F9,$C249,$C199,$C0EA,$C03B,$BF8D,$BEE0 
		dc.w	$BE33,$BD87,$BCDB,$BC30,$BB86,$BADD,$BA34,$B98C 
		dc.w	$B8E4,$B83D,$B797,$B6F2,$B64D,$B5A9,$B506,$B463 
		dc.w	$B3C1,$B320,$B280,$B1E0,$B141,$B0A3,$B006,$AF69 
		dc.w	$AECD,$AE32,$AD98,$ACFF,$AC66,$ABCE,$AB37,$AAA1 
		dc.w	$AA0C,$A977,$A8E3,$A850,$A7BE,$A72D,$A69D,$A60D 
		dc.w	$A57F,$A4F1,$A464,$A3D8,$A34D,$A2C3,$A23A,$A1B1 
		dc.w	$A12A,$A0A3,$A01E,$9F99,$9F15,$9E92,$9E10,$9D8F 
		dc.w	$9D0F,$9C90,$9C12,$9B95,$9B19,$9A9E,$9A23,$99AA 
		dc.w	$9932,$98BB,$9844,$97CF,$975B,$96E7,$9675,$9604 
		dc.w	$9594,$9525,$94B6,$9449,$93DD,$9372,$9308,$929F 
		dc.w	$9237,$91D0,$916B,$9106,$90A2,$9040,$8FDE,$8F7E 
		dc.w	$8F1F,$8EC0,$8E63,$8E07,$8DAC,$8D52,$8CFA,$8CA2 
		dc.w	$8C4B,$8BF6,$8BA2,$8B4F,$8AFD,$8AAC,$8A5C,$8A0D 
		dc.w	$89C0,$8973,$8928,$88DE,$8895,$884D,$8807,$87C1 
		dc.w	$877D,$873A,$86F8,$86B7,$8677,$8639,$85FC,$85BF 
		dc.w	$8584,$854B,$8512,$84DB,$84A4,$846F,$843C,$8409 
		dc.w	$83D7,$83A7,$8378,$834A,$831E,$82F2,$82C8,$829F 
		dc.w	$8277,$8250,$822B,$8207,$81E4,$81C2,$81A2,$8182 
		dc.w	$8164,$8147,$812C,$8111,$80F8,$80E0,$80C9,$80B4 
		dc.w	$809F,$808C,$807A,$806A,$805A,$804C,$803F,$8033 
		dc.w	$8029,$8020,$8018,$8011,$800B,$8007,$8004,$8002 
		dc.w	$8001,$8002,$8004,$8007,$800B,$8011,$8018,$8020 
		dc.w	$8029,$8033,$803F,$804C,$805A,$806A,$807A,$808C 
		dc.w	$809F,$80B4,$80C9,$80E0,$80F8,$8111,$812C,$8147 
		dc.w	$8164,$8182,$81A2,$81C2,$81E4,$8207,$822B,$8250 
		dc.w	$8277,$829F,$82C8,$82F2,$831E,$834A,$8378,$83A7 
		dc.w	$83D7,$8409,$843C,$846F,$84A4,$84DB,$8512,$854B 
		dc.w	$8584,$85BF,$85FC,$8639,$8677,$86B7,$86F8,$873A 
		dc.w	$877D,$87C1,$8807,$884D,$8895,$88DE,$8928,$8973 
		dc.w	$89C0,$8A0D,$8A5C,$8AAC,$8AFD,$8B4F,$8BA2,$8BF6 
		dc.w	$8C4B,$8CA2,$8CFA,$8D52,$8DAC,$8E07,$8E63,$8EC0 
		dc.w	$8F1F,$8F7E,$8FDE,$9040,$90A2,$9106,$916B,$91D0 
		dc.w	$9237,$929F,$9308,$9372,$93DD,$9449,$94B6,$9525 
		dc.w	$9594,$9604,$9675,$96E7,$975B,$97CF,$9844,$98BB 
		dc.w	$9932,$99AA,$9A23,$9A9E,$9B19,$9B95,$9C12,$9C90 
		dc.w	$9D0F,$9D8F,$9E10,$9E92,$9F15,$9F99,$A01E,$A0A3 
		dc.w	$A12A,$A1B1,$A23A,$A2C3,$A34D,$A3D8,$A464,$A4F1 
		dc.w	$A57F,$A60D,$A69D,$A72D,$A7BE,$A850,$A8E3,$A977 
		dc.w	$AA0C,$AAA1,$AB37,$ABCE,$AC66,$ACFF,$AD98,$AE32 
		dc.w	$AECD,$AF69,$B006,$B0A3,$B141,$B1E0,$B280,$B320 
		dc.w	$B3C1,$B463,$B506,$B5A9,$B64D,$B6F2,$B797,$B83D 
		dc.w	$B8E4,$B98C,$BA34,$BADD,$BB86,$BC30,$BCDB,$BD87 
		dc.w	$BE33,$BEE0,$BF8D,$C03B,$C0EA,$C199,$C249,$C2F9 
		dc.w	$C3AA,$C45C,$C50E,$C5C1,$C674,$C728,$C7DC,$C891 
		dc.w	$C947,$C9FD,$CAB3,$CB6A,$CC22,$CCDA,$CD93,$CE4C 
		dc.w	$CF05,$CFBF,$D07A,$D134,$D1F0,$D2AC,$D368,$D425 
		dc.w	$D4E2,$D59F,$D65D,$D71B,$D7DA,$D899,$D959,$DA19 
		dc.w	$DAD9,$DB99,$DC5A,$DD1C,$DDDD,$DE9F,$DF61,$E024 
		dc.w	$E0E7,$E1AA,$E26D,$E331,$E3F5,$E4BA,$E57E,$E643 
		dc.w	$E708,$E7CD,$E893,$E959,$EA1F,$EAE5,$EBAB,$EC72 
		dc.w	$ED39,$EE00,$EEC7,$EF8E,$F055,$F11D,$F1E5,$F2AD 
		dc.w	$F375,$F43D,$F505,$F5CE,$F696,$F75F,$F827,$F8F0 
		dc.w	$F9B9,$FA82,$FB4A,$FC13,$FCDC,$FDA5,$FE6E,$FF37 
		dc.w	$0000,$00C9,$0192,$025B,$0324,$03ED,$04B6,$057E 
		dc.w	$0647,$0710,$07D9,$08A1,$096A,$0A32,$0AFB,$0BC3 
		dc.w	$0C8B,$0D53,$0E1B,$0EE3,$0FAB,$1072,$1139,$1200 
		dc.w	$12C7,$138E,$1455,$151B,$15E1,$16A7,$176D,$1833 
		dc.w	$18F8,$19BD,$1A82,$1B46,$1C0B,$1CCF,$1D93,$1E56 
		dc.w	$1F19,$1FDC,$209F,$2161,$2223,$22E4,$23A6,$2467 
		dc.w	$2527,$25E7,$26A7,$2767,$2826,$28E5,$29A3,$2A61 
		dc.w	$2B1E,$2BDB,$2C98,$2D54,$2E10,$2ECC,$2F86,$3041 
		dc.w	$30FB,$31B4,$326D,$3326,$33DE,$3496,$354D,$3603 
		dc.w	$36B9,$376F,$3824,$38D8,$398C,$3A3F,$3AF2,$3BA4 
		dc.w	$3C56,$3D07,$3DB7,$3E67,$3F16,$3FC5,$4073,$4120 
		dc.w	$41CD,$4279,$4325,$43D0,$447A,$4523,$45CC,$4674 
		dc.w	$471C,$47C3,$4869,$490E,$49B3,$4A57,$4AFA,$4B9D 
		dc.w	$4C3F,$4CE0,$4D80,$4E20,$4EBF,$4F5D,$4FFA,$5097 
		dc.w	$5133,$51CE,$5268,$5301,$539A,$5432,$54C9,$555F 
		dc.w	$55F4,$5689,$571D,$57B0,$5842,$58D3,$5963,$59F3 
		dc.w	$5A81,$5B0F,$5B9C,$5C28,$5CB3,$5D3D,$5DC6,$5E4F 
		dc.w	$5ED6,$5F5D,$5FE2,$6067,$60EB,$616E,$61F0,$6271 
		dc.w	$62F1,$6370,$63EE,$646B,$64E7,$6562,$65DD,$6656 
		dc.w	$66CE,$6745,$67BC,$6831,$68A5,$6919,$698B,$69FC 
		dc.w	$6A6C,$6ADB,$6B4A,$6BB7,$6C23,$6C8E,$6CF8,$6D61 
		dc.w	$6DC9,$6E30,$6E95,$6EFA,$6F5E,$6FC0,$7022,$7082 
		dc.w	$70E1,$7140,$719D,$71F9,$7254,$72AE,$7306,$735E 
		dc.w	$73B5,$740A,$745E,$74B1,$7503,$7554,$75A4,$75F3 
		dc.w	$7640,$768D,$76D8,$7722,$776B,$77B3,$77F9,$783F 
		dc.w	$7883,$78C6,$7908,$7949,$7989,$79C7,$7A04,$7A41 
		dc.w	$7A7C,$7AB5,$7AEE,$7B25,$7B5C,$7B91,$7BC4,$7BF7 
		dc.w	$7C29,$7C59,$7C88,$7CB6,$7CE2,$7D0E,$7D38,$7D61 
		dc.w	$7D89,$7DB0,$7DD5,$7DF9,$7E1C,$7E3E,$7E5E,$7E7E 
		dc.w	$7E9C,$7EB9,$7ED4,$7EEF,$7F08,$7F20,$7F37,$7F4C 
		dc.w	$7F61,$7F74,$7F86,$7F96,$7FA6,$7FB4,$7FC1,$7FCD 
		dc.w	$7FD7,$7FE0,$7FE8,$7FEF,$7FF5,$7FF9,$7FFC,$7FFE 

doJMP1		jmp (a3)
doOR		or.b d0,99(a0)
doOR1		or.b d0,(a0)
		even
font32		
vfontbuf:
		dc.l $00000000,$00000000,$00000000,$00000000,$00000000
		dc.l $00000000,$00000000,$00000000,$07800780,$07800780
		dc.l $07800780,$07800780,$07800300,$00000300,$07800300
		dc.l $00000000,$3CF03EF8,$0E381C70,$30C00000,$00000000
		dc.l $00000000,$00000000,$00000000,$00000000,$00000000
		dc.l $00000CC0,$0CC07FF8,$7FF80CC0,$0CC07FF8,$7FF80CC0
		dc.l $0CC00000,$00000000,$07E00FFC,$1FFE3EFE,$3E7C1F80
		dc.l $0FF007FC,$63FE7FFE,$7FFE7FFE,$7FFC07E0,$00000000
		dc.l $180F3C1E,$663C6678,$3CF019E0,$03C00780,$0F301E78
		dc.l $3CCC78CC,$F078E030,$00000000,$1FC03FE0,$78E07DE0
		dc.l $3FC01F00,$3F8C7BDC,$FBFCFFFC,$FFFC7FFE,$7FFF3FCF
		dc.l $00000000,$3C003E00,$0E001C00,$30000000,$00000000
		dc.l $00000000,$00000000,$00000000,$00000000,$03800780
		dc.l $0F000F00,$1E001C00,$1C001C00,$1C001E00,$0F000F00
		dc.l $07800380,$00000000,$01C001E0,$00F000F0,$00780038
		dc.l $00380038,$00380078,$00F000F0,$01E001C0,$00000000
		dc.l $00000000,$07006730,$77703FE0,$1FC01FC0,$3FE07770
		dc.l $67300700,$00000000,$00000000,$00000000,$00000700
		dc.l $07000700,$3FE03FE0,$07000700,$07000000,$00000000
		dc.l $00000000,$00000000,$00000000,$00000000,$00000000
		dc.l $00000000,$00003C00,$3E000E00,$1C003000,$00000000
		dc.l $00000000,$00000000,$1FC01FC0,$00000000,$00000000
		dc.l $00000000,$00000000,$00000000,$00000000,$00000000
		dc.l $00000000,$00000000,$0C001E00,$1E000C00,$00000000
		dc.l $000F001E,$003C0078,$00F001E0,$03C00780,$0F001E00
		dc.l $3C007800,$F000E000,$00000000,$0FE03FF8,$7C7C783C
		dc.l $783C783C,$783C7BBC,$7FFC7FFC,$3FFC3FF8,$1FF00FE0
		dc.l $00000000,$07800F80,$1F803F80,$07800780,$07800FC0
		dc.l $3FF03FF0,$3FF03FF0,$3FF03FF0,$00000000,$1FE01FF0
		dc.l $3FF03CF0,$1DF003E0,$07E00FC0,$1F8C3FFC,$3FFC3FFC
		dc.l $3FFC39F8,$00000000,$1FF01FF8,$3FF83CF8,$1DF803F0
		dc.l $03F8007C,$38FC3FFC,$3FFC3FF8,$3FF01FE0,$00000000
		dc.l $03F007F0,$0FF01FF0,$3FF03DF0,$79F07FF0,$7FF87FF8
		dc.l $7FF87FF8,$7FF803E0,$00000000,$0FF80FF8,$1F781E00
		dc.l $3FE03FF0,$01F8007C,$30FC3FFC,$3FFC3FF8,$3FF01FE0
		dc.l $00000000,$0FF01FF8,$1F783E00,$3FC07FF0,$7FF87C7C
		dc.l $7CFC7FFC,$7FFC7FF8,$3FF01FE0,$00000000,$1FF81FF8
		dc.l $1E781E78,$00F000F0,$01E003E0,$03C007C0,$0FC01FC0
		dc.l $3FC03FC0,$00000000,$0FF81FFC,$3E3E3F7E,$1FFC07F0
		dc.l $1F7C3E3E,$7F7F7FFF,$7FFF3FFE,$3FFE1FFC,$00000000
		dc.l $07E00FF8,$1E7C1E7E,$1FFE0FDE,$07BE607E,$7FFE7FFE
		dc.l $7FFE7FFC,$3FF81FF0,$00000000,$00000000,$00000000
		dc.l $00000E00,$1F000E00,$00000000,$0E001F00,$0E000000
		dc.l $00000000,$00000000,$00000000,$00000E00,$1F000E00
		dc.l $00001E00,$1F000700,$0E001800,$00000000,$003C0078
		dc.l $00F001E0,$03C00780,$0F000780,$03C001E0,$00F00078
		dc.l $003C001C,$00000000,$00000000,$00000000,$7FE07FE0
		dc.l $00007FE0,$7FE00000,$00000000,$00000000,$00000000
		dc.l $3C001E00,$0F000780,$03C001E0,$00F001E0,$03C00780
		dc.l $0F001E00,$3C003800,$00000000,$3FE07FF8,$78FC7E7C
		dc.l $3EF803F0,$07E007C0,$07E003C0,$000003C0,$07E003C0,$00000000
		dc.l $0FE03FF8,$7C7CF83E,$F3DEF7FE,$F77EF77E,$F7FCFBF0
		dc.l $FC007FFC,$3FFC0FFC,$00000000,$1FFC1FFC,$0F780770
		dc.l $07700FF8,$1F7C3E3E,$7F7F7F7F,$7F7F7F7F,$7F7F7F7F
		dc.l $00000000,$3FFC3FFE,$1F3E0F7E,$0FFE0FF8,$1F7C3E3E
		dc.l $7F7F7FFF,$7FFF7FFF,$7FFE7FFC,$00000000,$07FC1FFE
		dc.l $3F1E3E3E,$7E3C7E00,$7F007F8F,$7FFF3FFF,$3FFF1FFF
		dc.l $0FFE03FC,$00000000,$3FF03FF8,$1F7C0F3E,$0F1F0F1F
		dc.l $1F1F3F1F,$7F3F7FFF,$7FFF7FFF,$7FFE7FFC,$00000000
		dc.l $3FFE3FFE,$1F9E0F00,$0F700FF0,$1F803F0F,$7FBF7FFF
		dc.l $7FFF7FFF,$7FFF7FFF,$00000000,$3FFE3FFE,$1F9E0F00
		dc.l $0F700FF0,$1FC03F00,$7FE07FE0,$7FE07FE0,$7FE07FE0
		dc.l $00000000,$07FC1FFE,$3F1E3E3E,$7E3C7E00,$7E007F0F
		dc.l $7FFF3FFF,$3FFF1FFF,$0FF703E3,$00000000,$3F7E3F7E
		dc.l $1E3C0E38,$0E780FF8,$1F3C3E3E,$7F7F7F7F,$7F7F7F7F
		dc.l $7F7F7F7F,$00000000,$0FC00FC0,$07800780,$07800780
		dc.l $07800FC0,$3FF03FF0,$3FF03FF0,$3FF03FF0,$00000000
		dc.l $03F003F0,$01E001E0,$01E001E0,$01E043E0,$7FE07FE0
		dc.l $7FE07FE0,$7FE03FC0,$00000000,$1F1E1F3E,$0E780EF0
		dc.l $0FE00FF0,$1E783E7C,$7F7F7F7F,$7F7F7F7F,$7F7F7F3F
		dc.l $00000000,$3FC03FC0,$1F800F00,$0F000F00,$1F9E3FFE
		dc.l $7FFE7FFE,$7FFE7FFE,$7FFE7FFE,$00000000,$3E3E3F7E
		dc.l $1FFC0FF8,$0FF80EB8,$1EBC3E3E,$7F7F7F7F,$7F7F7F7F
		dc.l $7F7F7F7F,$00000000,$3C7E3E7E,$1F7C0FF8,$0FF80FF8
		dc.l $1F3C3F1E,$7F7F7F7F,$7F7F7F7F,$7F7F7F7F,$00000000
		dc.l $0FE03FF8,$7C7CF83E,$F83EF83E,$F83EFBBE,$FFFEFFFE
		dc.l $7FFC3FF8,$1FF00FE0,$00000000,$3FFC3FFE,$1F3E0F7E
		dc.l $0FFE0FFC,$1F803F80,$7FC07FE0,$7FE07FE0,$7FE07FE0
		dc.l $00000000,$0FE03FF8,$7C7CF83E,$F83EF83E,$F83EFBBE
		dc.l $FFFEFFFE,$7FFC3FF8,$1FF00FE0,$039803F8,$3FF83FFE
		dc.l $1F3E0F7C,$0FF80FF8,$1F3C3F1E,$7F7F7F7F,$7F7F7F7F
		dc.l $7F7F7F7F,$00000000,$0FF81FFE,$1F7E0F3C,$0FC007F0
		dc.l $01FC21FE,$7FFF7FFF,$7FFF7FFF,$7FFE7FFC,$00000000
		dc.l $3FF03FF0,$3FF037B0,$07800780,$07800FC0,$3FF03FF0
		dc.l $3FF03FF0,$3FF03FF0,$00000000,$3F7E3F7E,$1E3C1E3C
		dc.l $1E3C1E3C,$3E3C3F7E,$7FFF7FFF,$7FFF7FFF,$3FFF1FDE 
		dc.l $00000000,$3F7E3F7E,$1E3C1C1C,$1E3C1F7C,$3FFE3FFE 
		dc.l $1FFC0FF8,$0FF807F0,$07F003E0,$00000000,$FBDFFBDF 
		dc.l $FBDE79CE,$79CE7BDE,$7FFE7FFF,$FFFFFFFF,$FFFFFFFF 
		dc.l $7FFF3BDE,$00000000,$3F7E3F7E,$1E3C0F78,$07F007F0 
		dc.l $1F7C3E3E,$7F7F7F7F,$7F7F7F7F,$7F7F7F7F,$00000000 
		dc.l $3F7E3F7E,$1E3C0F78,$07F007F0,$0FE07FE0,$7FE07FE0 
		dc.l $7FE07FE0,$7FC07F80,$00000000,$3FF03FF0,$3FF038F0 
		dc.l $01F003E0,$07E00FCE,$1FBE3FFE,$3FFE3FFE,$3FFE3FFE 
		dc.l $00000000,$00000000,$00000000,$00000000,$00000000 
		dc.l $00000000,$00000000,$00000000,$00000000 
		
LOGO_IMG:	* Taille 64*50
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$80AB,$0000,$7F54,$0000,$77FF,$0000,$8800,$0000
		dc.w	$0000,$FFFF,$7F54,$0000,$0000,$FFFF,$8800,$0000
		dc.w	$BFFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$4000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$BFFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$4000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$BFFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$4000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$BFFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$4000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$BFFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$4000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$BFFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$4000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$BFFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$4000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$BFFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$4000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$BFFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$4000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$BFFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$4000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$BFFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$4000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$7F54,$0000,$0000,$FFFF,$8800,$0000
		dc.w	$80AB,$0000,$7F54,$0000,$77FF,$0000,$8800,$0000
		dc.w	$0000,$FFFF,$4000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$BFFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$4000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$BFFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$4000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$BFFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$4000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$BFFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$4000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$BFFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$4000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$BFFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$4000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$BFFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$4000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$BFFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$4000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$BFFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$4000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$BFFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$4000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$BFFF,$0000,$4000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000
		dc.w	$0000,$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000
		dc.w	$FFFF,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000

DATAC01:
	DC.W	$0000,$0032
DATAC02:
	dc.w	$0000,$0403,$0806,$0D0A
	dc.w	$110D,$1611,$1A14,$1F18
	dc.w	$231B,$281F,$2C22,$3026
	dc.w	$3529,$392C,$3D30,$0201
	dc.w	$0605,$0A08,$0F0B,$130F
	dc.w	$1712,$1B15,$1F18,$241C
	dc.w	$281F,$2C22,$3025,$3428
	dc.w	$382B,$3C2E,$0000,$0303
	dc.w	$0705,$0B08,$0F0B,$120E
	dc.w	$1611,$1A14,$1D17,$2119
	dc.w	$241C,$271F,$2B21,$2E24
	dc.w	$3126,$3529,$382B,$3B2E
	dc.w	$3E30,$0100,$0403,$0605
	dc.w	$0907,$0C09,$0F0B,$110D
	dc.w	$140F,$1611,$1913,$1B15
	dc.w	$1D17,$1F18,$221A,$241C
	dc.w	$261D,$281F,$2920,$2B22
	dc.w	$2D23,$2E24,$3025,$3227
	dc.w	$3328,$3429,$362A,$372B
	dc.w	$382C,$392C,$3A2D,$3B2E
	dc.w	$3C2E,$3C2F,$3D30,$3E30
	dc.w	$3E30,$3F31,$3F31,$3F31
	dc.w	$3F31,$3F31,$0000,$3F31
	dc.w	$3F31,$3F31,$3F31,$3F31
	dc.w	$3E30,$3E30,$3D30,$3C2F
	dc.w	$3C2E,$3B2E,$3A2D,$392C
	dc.w	$382C,$372B,$362A,$3429
	dc.w	$3328,$3227,$3025,$2E24
	dc.w	$2D23,$2B22,$2920,$281F
	dc.w	$261D,$241C,$221A,$1F18
	dc.w	$1D17,$1B15,$1913,$1611
	dc.w	$140F,$110D,$0F0B,$0C09
	dc.w	$0907,$0605,$0403,$0100
	dc.w	$3E30,$3B2E,$382B,$3529
	dc.w	$3126,$2E24,$2B21,$271F
	dc.w	$241C,$2119,$1D17,$1A14
	dc.w	$1611,$120E,$0F0B,$0B08
	dc.w	$0705,$0303,$0000,$3C2E
	dc.w	$382B,$3428,$3025,$2C22
	dc.w	$281F,$241C,$1F18,$1B15
	dc.w	$1712,$130F,$0F0B,$0A08
	dc.w	$0605,$0201,$3D30,$392C
	dc.w	$3529,$3026,$2C22,$281F
	dc.w	$231B,$1F18,$1A14,$1611
	dc.w	$110D,$0D0A,$0806,$0403
	dc.w	$0000,$3B2E,$372B,$3227
	dc.w	$2E24,$2920,$251D,$2019
	dc.w	$1C16,$1712,$130F,$0F0B
	dc.w	$0A08,$0605,$0201,$3D30
	dc.w	$392C,$3529,$3026,$2C22
	dc.w	$281F,$241C,$2019,$1B15
	dc.w	$1712,$130F,$0F0C,$0B09
	dc.w	$0706,$0303,$0000,$3C2E
	dc.w	$382C,$3429,$3026,$2D23
	dc.w	$2920,$251D,$221A,$1E18
	dc.w	$1B15,$1812,$1410,$110D
	dc.w	$0E0B,$0A08,$0706,$0403
	dc.w	$0101,$3E31,$3B2E,$392C
	dc.w	$362A,$3328,$3026,$2E24
	dc.w	$2B22,$2920,$261E,$241C
	dc.w	$221A,$2019,$1D17,$1B15
	dc.w	$1914,$1712,$1611,$140F
	dc.w	$120E,$110D,$0F0C,$0D0A
	dc.w	$0C09,$0B08,$0907,$0806
	dc.w	$0705,$0605,$0504,$0403
	dc.w	$0303,$0302,$0201,$0101
	dc.w	$0101,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0101,$0101,$0201,$0302
	dc.w	$0303,$0403,$0504,$0605
	dc.w	$0705,$0806,$0907,$0B08
	dc.w	$0C09,$0D0A,$0F0C,$110D
	dc.w	$120E,$140F,$1611,$1712
	dc.w	$1914,$1B15,$1D17,$2019
	dc.w	$221A,$241C,$261E,$2920
	dc.w	$2B22,$2E24,$3026,$3328
	dc.w	$362A,$392C,$3B2E,$3E31
	dc.w	$0101,$0403,$0706,$0A08
	dc.w	$0E0B,$110D,$1410,$1812
	dc.w	$1B15,$1E18,$221A,$251D
	dc.w	$2920,$2D23,$3026,$3429
	dc.w	$382C,$3C2E,$3F31,$0303
	dc.w	$0706,$0B09,$0F0C,$130F
	dc.w	$1712,$1B15,$2019,$241C
	dc.w	$281F,$2C22,$3026,$3529
	dc.w	$392C,$3D30,$0201,$0605
	dc.w	$0A08,$0F0B,$130F,$1712
	dc.w	$1C16,$2019,$251D,$2920
	dc.w	$2E24,$3227,$372B,$3B2E
DATAC03:
	dc.w	$0000,$005A
DATAC04:
	dc.w	$0001,$0001

PalNoeXtra:
	dc.w	$0000,$0666,$0555,$0444,$0333,$0222,$0111,$00F0
	dc.w	$0766,$0655,$0544,$0667,$0556,$0445,$0777,$0FFF

LogoNoeXtra:
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0008,$0008,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$8000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0008,$0000,$0008,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$8000,$0000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0008,$0000,$0008,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$8000,$0000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0008,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0010,$0018,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0001,$0001,$0000,$0000,$0000,$8000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0018,$000C,$0014,$0000,$0000,$0000,$0000,$0000
		dc.w	$0001,$0000,$0001,$0000,$8000,$C000,$4000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0014,$0020,$003C,$0000,$0000,$0000,$0000,$0000
		dc.w	$0001,$0002,$0003,$0000,$4000,$0000,$C000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0024,$000A,$0036,$0000,$0000,$0000,$0000,$0000
		dc.w	$0002,$0000,$0003,$0000,$4000,$A000,$6000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$003A,$0058,$0066,$0000,$0000,$0000,$0000,$0000
		dc.w	$0003,$0005,$0006,$0000,$2000,$0000,$E000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00F6,$013D,$01C3,$0000,$0000,$0000,$0000,$0000
		dc.w	$0008,$0010,$001F,$0000,$2000,$9000,$7000,$8000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$005C,$009C,$00E3,$0000,$852C,$0478,$FB87,$0104
		dc.w	$8005,$4009,$C00E,$0000,$F554,$F559,$0AA3,$0003
		dc.w	$2800,$E400,$1C00,$0000,$594E,$9EB1,$E011,$0011
		dc.w	$AA90,$5580,$5470,$5600,$37AB,$2854,$0054,$1256
		dc.w	$5283,$A1C6,$1039,$0204,$0058,$0098,$00E7,$0000
		dc.w	$E4AE,$05FF,$FA00,$0110,$9037,$8031,$700E,$0000
		dc.w	$7434,$8B43,$01C8,$01C8,$D000,$C802,$3801,$0001
		dc.w	$5343,$A434,$0C9C,$0C9C,$4D00,$3C80,$8380,$8000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$007E,$0156,$01A9,$0028,$0BF9,$0957,$F6A8,$02A8
		dc.w	$A005,$0017,$E018,$8000,$FBFC,$735E,$8CA1,$88A1
		dc.w	$5A00,$F001,$0E01,$0800,$1407,$2F8D,$C070,$100A
		dc.w	$5540,$FFC0,$0030,$8800,$1D65,$37DF,$0000,$2800
		dc.w	$13A9,$E112,$107D,$0280,$0058,$0178,$0187,$0020
		dc.w	$4055,$02FF,$FF00,$02A2,$0012,$8019,$7026,$8020
		dc.w	$D45D,$7FF7,$8000,$8008,$5001,$F401,$0C02,$0002
		dc.w	$2545,$DFFF,$2000,$2000,$5500,$7740,$88C0,$8800
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00D4,$0294,$036B,$0040,$5D08,$59EF,$A650,$0450
		dc.w	$800F,$D02A,$3035,$0005,$770E,$37EE,$C851,$4051
		dc.w	$B800,$ED02,$1303,$1000,$8652,$DB26,$20F9,$5500
		dc.w	$0010,$0000,$FFF0,$0000,$02EB,$1B9E,$2400,$0071
		dc.w	$31CE,$62F2,$903D,$0110,$00B0,$02F0,$034F,$0040
		dc.w	$0237,$0268,$FD80,$0050,$602F,$A039,$1006,$4004
		dc.w	$0CAA,$DCFF,$2300,$0040,$2802,$FA03,$0600,$4000
		dc.w	$289E,$3EEB,$C104,$4004,$AA80,$FBA0,$0460,$0400
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0378,$01D8,$0227,$0020,$3F05,$3407,$CB08,$0A08
		dc.w	$7036,$C01C,$3023,$2002,$F801,$5001,$A802,$A002
		dc.w	$5603,$9D01,$2302,$2200,$498D,$E7E6,$1079,$2220
		dc.w	$0000,$0000,$0000,$0000,$1405,$1FEF,$2230,$0228
		dc.w	$7337,$8188,$1075,$220A,$037E,$017E,$0281,$0000
		dc.w	$8E00,$8E00,$7100,$0000,$0007,$003E,$0001,$0000
		dc.w	$0750,$F060,$0F90,$0000,$D600,$5C03,$2200,$8000
		dc.w	$5D45,$97FE,$2881,$2880,$0560,$1FC0,$0020,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00D0,$01D0,$022F,$0000,$7307,$6A0A,$9505,$1405
		dc.w	$202B,$E01E,$1021,$0001,$0801,$F002,$0801,$0001
		dc.w	$0B00,$BE01,$4102,$4000,$A64F,$E302,$18F9,$4414
		dc.w	$0000,$0000,$0000,$0000,$2A8E,$1FFB,$2000,$1154
		dc.w	$B0FB,$E3C2,$103D,$0000,$00BD,$01FD,$0202,$0000
		dc.w	$1F00,$1E00,$E100,$0000,$001E,$002E,$0011,$0010
		dc.w	$26B0,$3060,$CD90,$4000,$2A01,$FC02,$1201,$1001
		dc.w	$AEFB,$FBAA,$0445,$0444,$0E80,$0AC0,$1520,$1500
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$03FA,$037A,$0085,$0080,$F304,$DC05,$2B0A,$2A0A
		dc.w	$C03F,$6015,$902A,$800A,$5801,$F001,$0802,$0002
		dc.w	$E703,$6401,$9B00,$8202,$57F4,$F586,$0879,$2202
		dc.w	$0000,$0000,$0000,$0000,$0575,$2FDF,$3000,$0200
		dc.w	$595C,$F7D5,$0023,$8008,$037B,$03FB,$0004,$0000
		dc.w	$AF00,$AE00,$5100,$0000,$0018,$0012,$002D,$0028
		dc.w	$F490,$5160,$AE90,$2000,$F601,$5C01,$0202,$A802
		dc.w	$E77D,$65D6,$9A29,$8228,$0140,$1DC0,$0220,$0200
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$02FD,$03E9,$0016,$0014,$DF00,$8A0A,$7505,$5405
		dc.w	$A03F,$E00B,$1034,$0014,$F800,$A002,$5801,$5000
		dc.w	$B300,$8A03,$7D00,$0000,$88BB,$FFAF,$4040,$5510
		dc.w	$E800,$9400,$1000,$1000,$128A,$07FF,$1800,$0410
		dc.w	$AA28,$FFFA,$0006,$0100,$02F0,$03F7,$0008,$0004
		dc.w	$DF00,$DE00,$2100,$0000,$001C,$0029,$0016,$0014
		dc.w	$1731,$6062,$9F90,$1000,$A801,$FA02,$0601,$0001
		dc.w	$B3CB,$8A9E,$7D61,$0140,$41C0,$2A80,$5560,$5540
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01F8,$0342,$00AF,$00AA,$FD05,$5607,$A908,$A808
		dc.w	$403F,$E01F,$1020,$0000,$F800,$5000,$2803,$2002
		dc.w	$B903,$0601,$ED00,$8002,$3247,$DBED,$0410,$A8A2
		dc.w	$4000,$E000,$1C00,$2000,$0405,$08EF,$0F10,$008A
		dc.w	$5568,$FFE4,$001C,$8000,$016A,$03E4,$001F,$0000
		dc.w	$7700,$FE00,$0100,$0800,$0017,$003D,$0002,$0002
		dc.w	$7A50,$51E1,$8E12,$0A00,$5001,$F403,$0C00,$8000
		dc.w	$B8AD,$0616,$EDE9,$80A8,$2740,$5DC0,$0220,$0200
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$03D1,$0280,$017F,$0151,$3F01,$6A0C,$9503,$1401
		dc.w	$203F,$E00F,$1030,$0010,$F800,$F002,$0801,$0000
		dc.w	$9D02,$AA03,$7500,$0001,$A094,$F5D1,$0A2A,$4405
		dc.w	$9400,$D000,$2C00,$4000,$128E,$07FF,$1800,$0551
		dc.w	$AAA8,$FFFA,$0006,$4500,$00A7,$03EA,$001D,$0100
		dc.w	$6700,$BA00,$0100,$5400,$001E,$002B,$0014,$0014
		dc.w	$3D10,$0841,$D6B2,$3540,$D001,$C802,$3801,$0001
		dc.w	$9D45,$AA10,$75EF,$0144,$4A80,$0AC0,$3520,$1100
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01EF,$014D,$02B2,$02A2,$9503,$7E00,$810F,$8008
		dc.w	$803F,$201F,$D020,$0000,$7800,$5000,$A803,$A002
		dc.w	$A901,$1203,$FD00,$8002,$0019,$A292,$5D65,$A20A
		dc.w	$0000,$0000,$0000,$0000,$050D,$2FAF,$3050,$0282
		dc.w	$5554,$FFFD,$0003,$02A8,$036E,$01E1,$001B,$0200
		dc.w	$5100,$FE00,$0900,$2A00,$001D,$0031,$000A,$000A
		dc.w	$1551,$B7E3,$4810,$02A0,$6801,$E403,$1C00,$0000
		dc.w	$A8AF,$9214,$7DEB,$00AA,$0F40,$1840,$07A0,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01CF,$0218,$0175,$0155,$AF02,$BA08,$4507,$4400
		dc.w	$C037,$A007,$5038,$0010,$9800,$E002,$5801,$5000
		dc.w	$D100,$8C01,$7302,$5001,$8139,$D12C,$2EC3,$5014
		dc.w	$0000,$0000,$0000,$0000,$2A2A,$1F6F,$2090,$1504
		dc.w	$A62B,$F77E,$0881,$0144,$00AC,$03E2,$001F,$0140
		dc.w	$CB00,$9E00,$2100,$4400,$0039,$003A,$0005,$0005
		dc.w	$3C72,$B923,$4290,$0041,$A803,$FA03,$0600,$0000
		dc.w	$D35B,$CF02,$30F5,$1054,$0480,$0100,$1EE0,$1140
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00DB,$0059,$03A6,$0282,$B503,$5E00,$A10E,$A008
		dc.w	$403A,$201A,$D025,$0000,$1801,$5001,$A802,$2002
		dc.w	$D501,$7E01,$8102,$8000,$40A1,$E81A,$17C5,$A82A
		dc.w	$0000,$0000,$0000,$0000,$152D,$1F8F,$2050,$0AA2
		dc.w	$5305,$E1AE,$1051,$22A0,$0359,$01F9,$0006,$02A0
		dc.w	$1500,$FE00,$0100,$A200,$003E,$003D,$0002,$0002
		dc.w	$A611,$0EE3,$D110,$A8A2,$5403,$FD03,$0300,$A800
		dc.w	$BEA3,$B4A4,$4B5B,$0A0A,$0CC0,$1A40,$07A0,$0200
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$01FE,$02FB,$0104,$0104,$C903,$AA08,$1507,$1400
		dc.w	$A01B,$202F,$D030,$0010,$B801,$E002,$1801,$1001
		dc.w	$DB02,$8E01,$7102,$5001,$8120,$D464,$2B9B,$5404
		dc.w	$0000,$0000,$0000,$0000,$0BA0,$1CE5,$201A,$0505
		dc.w	$31C3,$63D6,$9029,$4010,$00EA,$03BF,$0000,$0050
		dc.w	$FB00,$AE00,$0100,$1000,$001D,$0018,$0027,$0005
		dc.w	$82B2,$87E3,$7810,$0541,$2B01,$7E01,$8102,$4400
		dc.w	$DD0F,$9D1A,$62E5,$4004,$0700,$0040,$1FA0,$1000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$017D,$01C7,$02AA,$02AA,$4106,$9606,$2909,$2808
		dc.w	$4007,$602D,$9032,$0002,$EFD7,$CFD7,$3028,$2000
		dc.w	$BC00,$1500,$EB01,$A800,$4B4C,$E8CE,$1731,$2002
		dc.w	$CD80,$F260,$0210,$0720,$1628,$1D8A,$2055,$0A82
		dc.w	$5305,$A18A,$1071,$A28A,$0201,$01FF,$0080,$02A0
		dc.w	$0D00,$F600,$0300,$0A00,$001F,$001F,$0020,$0000
		dc.w	$88F3,$8AE1,$7510,$0202,$0501,$AE01,$5102,$A000
		dc.w	$EA6F,$EA3E,$15C1,$0000,$00C0,$1840,$07A0,$0080
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$008A,$02DB,$0124,$0000,$0302,$EE0F,$5100,$5000
		dc.w	$A017,$E002,$101D,$0005,$DFEB,$8FEB,$7014,$5000
		dc.w	$E801,$BA00,$4601,$4000,$2387,$7187,$8E78,$5000
		dc.w	$AAC0,$FFC0,$0030,$4400,$0E04,$1F05,$20FA,$1101
		dc.w	$9009,$C31C,$30E3,$4114,$00BC,$02EB,$0100,$0010
		dc.w	$6B00,$BA00,$0500,$0000,$003F,$001A,$0025,$0005
		dc.w	$04D0,$05C3,$FA30,$0101,$0903,$1C01,$E302,$1400
		dc.w	$C495,$C424,$3BDB,$0010,$0E80,$0BC0,$1420,$1400
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$00B5,$010A,$024A,$024A,$6903,$9604,$8108,$8008
		dc.w	$0004,$8008,$F00F,$E000,$AAAB,$0AAB,$F554,$A000
		dc.w	$E800,$E400,$1C00,$0000,$4483,$8083,$FF7C,$0000
		dc.w	$5110,$FB80,$0470,$AA00,$2492,$0E82,$317D,$0A00
		dc.w	$222A,$1009,$F1F7,$0200,$02A5,$015A,$000A,$000A
		dc.w	$6A00,$9400,$8100,$8200,$002E,$0006,$0039,$0008
		dc.w	$20A2,$0290,$FD71,$0202,$2A02,$0900,$F703,$0000
		dc.w	$8352,$8091,$7FEF,$0000,$0180,$1640,$0A20,$0A00
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1640,$2620,$39E0,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$EB76,$EB76,$0000,$0000,$0180,$0180,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$1300,$0280,$1D80,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$AA72,$0070,$EB06,$EB76,$A080,$8000,$6180,$E180
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0900,$1400,$1B00,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0020,$4924,$EB06,$A222,$8000,$C100,$6180,$A080
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0A00,$0100,$0F00,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$A3AE,$E3AE,$4800,$ABAE,$A380,$8380,$6000,$E380
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0600,$0C00,$0A00,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$A8A8,$EBAE,$4306,$A8A8,$8280,$C380,$6100,$A280
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0200,$0600,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$A920,$E926,$428E,$ABA8,$0100,$4100,$E280,$A380
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0400,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$AAAA,$FC71,$57DF,$ABAE,$AA80,$5C00,$F780,$AB80
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0400,$0000,$0400,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0400,$0000,$0400,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0400,$0400,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
		dc.w	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF	
		
*>
log_base	dc.l 0
phy_base	dc.l 0
switch		dc.w 0
old_ptr1	dc.l verticalbuf1
old_ptr2	dc.l verticalbuf1
scrlpoint	dc.l text
scrloffset	ds.w 1
buff_ptr	dc.w 0
wave_ptr	dc.w 0
text
	DC.B      '                         '
	DC.B      'ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789 '
	DC.B      '()!,-+:?;/.',$27,'                    '
	DC.W      $0	
	even
	ds.l 4*speed
buffer
 rept 320*2*2
	dc.l routs
 endr

*<

MUSIC: 		; Not compressed please !
	incbin	*.THK
	even

******************************************************************
	SECTION	BSS
******************************************************************

bss_start:

Vsync:	ds.b	1
				ds.b	1
Save_stack:	ds.l	1

Save_all:
	ds.b	8	* Mfp : fa03.w -> fa19.w
	ds.b	4	* Mfp : fa1b.w -> fa21.w
	ds.b	4	* Video : f8201.w -> f820d.w
Video:	ds.b	1	* Video : f8260.w
	ds.w	1	* coolness guys !

Save_rest:
	ds.l	1	* Autovector (HBL)
	ds.l	1	* Autovector (VBL)
	ds.l	1	* Timer D (USART timer)
	ds.l	1	* Timer C (200hz Clock)
	ds.l	1	* Keyboard/MIDI (ACIA) 
	ds.l	1	* Timer B (HBL)
	ds.l	1	* Timer A
	ds.l	1	* Output Bip Bop
Palette:ds.w	16	* Palette

* Full data here :
* >
jmptab1		ds.l 256
jmptab2		ds.l 256
screens		ds.b 256
		ds.b 32000
		ds.b 32000
verticalbuf1	ds.w 2048
routs
		ds.b 10000

* <	
	
bss_end:

******************************************************************
	END
******************************************************************
