; Avenger Intro

		clr.l	-(sp)
		move.w	#32,-(sp)
		trap	#1
		addq.l	#6,sp
		move.l	d0,save_stack

		lea	palette,a0
		movem.l	$ffff8240,d0-d7
		movem.l	d0-d7,(a0)

		bsr	save_mfp
		bsr	init_and_set_screen

		move.b	#0,$ffff8260		;resolution, 0=low,1=med
	
		movem.l	picture+2,d0-d7		;put picture palette in d0-d7
		movem.l	d0-d7,$ffff8240		;move palette from d0-d7

		move.l	screen,a0
		move.l	#picture+34,a1		;a1 points to picture
		lea	endpic,a2
copypic:	move.b	(a1)+,(a0)+		;move one longword to screen
		cmpa.l	a1,a2
		bne	copypic

		moveq	#1,d0		; select sub-tune 1
		jsr	music		; init music

		bsr	Init		;RUN THE SHOW

;>>>>> MAIN LOOP >>>>>>>>>
main:
		bsr	wait_vbl
		bsr	music+8

		move.w	#$352,$ffff8242	;upper text color

		bsr	text_shooting
		bsr	scrolling

		cmp.b	#$39,$fffffc02.w	;space
		bne	main

;>>>>>>>>>>>>>>>>>>>>>>>>>>>

		bsr	sound_off
		bsr	restore_all
		bsr	keyb_flush

		movem.l	palette,d0-d7
		movem.l	d0-d7,$ffff8240

		move.l	Save_stack,-(sp)	;back to user mode
		move.w	#32,-(sp)
		trap	#1
		addq.l	#6,sp

		clr.w	-(sp)	
		trap	#1	


;>>>>>>>>>>>>>>>> INTRO STUFF <<<<<<<<<<<<<<<<<<

keyb_flush:	btst	#0,$fffffc00.w
		beq.s	flush_done
		move.b	$fffffc02.w,d0
		bra.s	keyb_flush
flush_done:	rts


Vbl:	
		move    #$2700,sr
		movem.l	d0-d7/a0-a6,-(a7)
		move.w	#1065,d0
pause1:		nop
		dbra	d0,pause1
		eor.b	#2,$ffff820a.w	;60hz
		rept	8
		nop
		endr
		eor.b	#2,$ffff820a.w	;50hz
		st	Vsync

		move.w	#$352,$ffff8242.w
		
		clr.b   $fffffa1b.w 
		move.l	#_timer_b,$120.w 
		move.b  #228,$fffffa21.w
		move.b  #8,$fffffa1b.w
		movem.l	(a7)+,d0-d7/a0-a6
		move    #$2300,sr 
		rte


_timer_b:
		movem.l	d0/a0,-(a7)
		lea	$fffffa21,a0	
		move.b	(a0),d0		
pause_b:	cmp.b	(a0),d0		
		beq.s	pause_b		
		eor.b	#2,$ffff820a.w	;60hz
		rept	15
		nop
		endr
		eor.b	#2,$ffff820a.w	;50hz
		movem.l	(a7)+,d0/a0

		clr.b	$fffffa1b.w
		move.l	#low_rasters,$120.w 
		move.b  #1,$fffffa21.w
		move.b  #8,$fffffa1b.w

		bclr	#0,$fffffa0f.w
		rte

	
;now on scanline 200	
low_rasters:
		clr.b	$fffffa1b.w
		move.l	#rasters,$120.w 
		move.b  #25,$fffffa21.w
		move.b  #8,$fffffa1b.w
		rte		

rasters:
		clr.b	$fffffa1b.w
		move.w	#$077,$ffff8242.w
		move.l	#raster1,$120.w 
		move.b  #1,$fffffa21.w
		move.b  #8,$fffffa1b.w
		rte
raster1:
		move.w	#$067,$ffff8242.w
		move.l	#raster2,$120.w 
		rte
raster2:
		move.w	#$057,$ffff8242.w
		move.l	#raster3,$120.w 
		rte
raster3:
		move.w	#$047,$ffff8242.w
		move.l	#raster4,$120.w 
		rte
raster4:		
		move.w	#$037,$ffff8242.w
		move.l	#raster5,$120.w 
		rte
raster5:		
		move.w	#$027,$ffff8242.w
		move.l	#raster6,$120.w 
		rte
raster6:
		move.w	#$017,$ffff8242.w
		move.l	#raster7,$120.w 
		rte
raster7:
		move.w	#$027,$ffff8242.w
		move.l	#raster8,$120.w 
		rte
raster8:
		move.w	#$037,$ffff8242.w
		move.l	#raster9,$120.w 
		rte
raster9:
		move.w	#$047,$ffff8242.w
		move.l	#raster10,$120.w 
		rte
raster10:
		move.w	#$057,$ffff8242.w
		move.l	#raster11,$120.w 
		rte
raster11:
		move.w	#$067,$ffff8242.w
		move.l	#raster12,$120.w 
		rte
raster12:
		move.w	#$077,$ffff8242.w
		move.l	#end_hbl,$120.w 
		rte


end_hbl:
		rte


init_and_set_screen:

		movem.l	d0-d1/a0,-(a7)
		move.l	#_scr,d0
		add.l	#$ff,d0
		sf	d0
		move.l	d0,screen

		movea.l	screen,a0
		move.l	#screen_len/4-1,d0
fill:		move.l	#0,(a0)+
		dbra	d0,fill

		move.l	screen,d0
		move.b	d0,d1
		lsr.w	#8,d0
		move.b	d0,$ffff8203.w
		swap	d0
		move.b	d0,$ffff8201.w
		move.b	d1,$ffff820d.w

		movem.l	(a7)+,d0-d1/a0
		rts

save_mfp:
		lea	Save_all,a0
		move.b	$fffffa07.w,(a0)+
		move.b	$fffffa09.w,(a0)+
		move.b	$fffffa13.w,(a0)+
		move.b	$fffffa15.w,(a0)+
		move.b	$fffffa17.w,(a0)+

		move.b	$ffff8201.w,(a0)+
		move.b	$ffff8203.w,(a0)+
		move.b	$ffff820d.w,(a0)+
		move.b	$ffff8260.w,(a0)+
		move.b	$ffff820a.w,(a0)+

		move.l	$070.w,(a0)+	;VBL
		move.l	$118.w,(a0)+	
		move.l	$120.w,(a0)+	;HBL
		move.l	$134.w,(a0)+	
		move.l	$114.w,(a0)+	
		move.l	$110.w,(a0)+

		move.b	$484.w,conterm	; save click state
		clr.b	$484.w		; no click,no repeat.
		dc.w	$a000
		dc.w	$a00a
		move.b	#$12,$fffffc02.w

		rts
	
restore_all:
		move.w	#$2700,sr
		lea	save_all,a0

		move.b	(a0)+,$fffffa07.w
		move.b	(a0)+,$fffffa09.w
		move.b	(a0)+,$fffffa13.w
		move.b	(a0)+,$fffffa15.w
		move.b	(a0)+,$fffffa17.w

		move.b	(a0)+,$ffff8201.w
		move.b	(a0)+,$ffff8203.w
		move.b	(a0)+,$ffff820d.w
		move.b	(a0)+,$ffff8260.w
		move.b	(a0)+,$ffff820a.w

		move.l	(a0)+,$070.w
		move.l	(a0)+,$118.w
		move.l	(a0)+,$120.w
		move.l	(a0)+,$134.w
		move.l	(a0)+,$114.w
		move.l	(a0)+,$110.w
		stop	#$2300
		
		move.b	Video,$ffff8260.w
		move.w	#$25,-(a7)
		trap	#14
		addq.w	#2,a7
		move.b	Video,$ffff8260.w

		move.b	#$8,$fffffc02.w	
		dc.w 	$a000
		dc.w 	$a009
		move.b	conterm,$484.w	;restore key click and rate

		rts

sound_off:
 		jsr	music+4
		move.l	#$7070000,$ffff8800.w
		move.l	#$8080000,$ffff8800.w
		move.l	#$9090000,$ffff8800.w
		move.l	#$a0a0000,$ffff8800.w
		rts


Wait_vbl:	
		move.l	a0,-(a7)
		lea	Vsync,a0
		sf	(a0)
Wait_label:	tst.b	(a0)
		beq.s	Wait_label
		move.l	(a7)+,a0
		rts
init:
		bclr	#5,$fffffa15		;disable timer c
		clr.b	$fffffa1b		;disable timer b
		bset	#0,$fffffa07		;turn on timer b in enable a
		bset	#0,$fffffa13		;turn on timer b in mask a
		bclr	#3,$fffffa17.w		;automatic interrupt mode
		move.l	#vbl,$70.w
		rts
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

;********** TEXT SHOOTING **********

text_shooting:

		cmpi.l	#32*8*160,shoot_Y	;have we done all lines
		bne	do_next_line		;if not, show next line
		
		addq.w	#1,clean_timer
		cmp.w	#200,clean_timer	;clean delay
		bls	no_clean_yet
		bsr	wipe_text		;wipe all the lines
no_clean_yet:
		rts

do_next_line:
		move.w	#0,clean_timer
		addi.w	#1,times
		cmpi.w	#8,chars
		beq	convert_new_line
		bra	no_new_line

convert_new_line:
		bsr	get_characters
		move.w	#0,chars
no_new_line:	
		addq.w	#1,chars
		lea	shoot_buffer1,a0
		lea	shoot_buffer2,a1

		move.l	#7,d7
rol_it:
		lsl.w	(a0)+
		addq.l	#2,a0
		roxl.w	$98(a1)
		roxl.w	$90(a1)
		roxl.w	$88(a1)
		roxl.w	$80(a1)
		roxl.w	$78(a1)
		roxl.w	$70(a1)
		roxl.w	$68(a1)
		roxl.w	$60(a1)
		roxl.w	$58(a1)
		roxl.w	$50(a1)
		roxl.w	$48(a1)
		roxl.w	$40(a1)
		roxl.w	$38(a1)
		roxl.w	$30(a1)
		roxl.w	$28(a1)
		lea	160(a1),a1
		dbra	d7,rol_it

		lea	shoot_buffer2,a0
		move.l	screen,a1
		adda.l	shoot_Y,a1
	
		move.l	#6,d7
_copydata:	
		move.w	$28(a0),$28(a1)
		move.w	$30(a0),$30(a1)
		move.w	$38(a0),$38(a1)
		move.w	$40(a0),$40(a1)
		move.w	$48(a0),$48(a1)
		move.w	$50(a0),$50(a1)
		move.w	$58(a0),$58(a1)
		move.w	$60(a0),$60(a1)
		move.w	$68(a0),$68(a1)
		move.w	$70(a0),$70(a1)
		move.w	$78(a0),$78(a1)
		move.w	$80(a0),$80(a1)
		move.w	$88(a0),$88(a1)
		move.w	$90(a0),$90(a1)
		move.w	$98(a0),$98(a1)
		lea	$a0(a0),a0
		lea	$a0(a1),a1
		dbra	d7,_copydata

		cmp.w	#12,times
		bne	text_shooting
		move.w	#0,times
		rts

get_characters:
		lea	shoot_buffer1,a1	;holds one character
		moveq	#0,d0
		movea.l text_shoot,a0
		move.b	(a0),d0
		adda.l	#1,a0
		cmp.b	#$ff,d0
		beq.s	reset_text
		cmp.b 	#0,d0
		bne.b	not_end_of_line

		addi.l	#8*160,shoot_Y 	;go to next line
		move.l	a0,text_shoot
		bsr	clean_prebuffer
		rts

reset_text:
		lea	message,a0
		move.l	a0,text_shoot
		bsr	clean_prebuffer
		rts
not_end_of_line:
		move.l	a0,text_shoot
		
		lea	st_fonts,a0

		sub.l	#$20,d0
		mulu	#8,d0

;		btst	#6,d0
;		bne.s	_letter	
;		and.w	#$1f,d0		
;		adda.l	#$100,a0	;special chars starts at +$100
;		bra	_mul
;_letter:	subi.w	#$40,d0
;_mul:		lsl.w	#3,d0
;		adda.l	#2,a0		;skip the header

		adda.w	d0,a0

		move.b	(a0)+,(a1)+
		clr.b	(a1)+
		addq.w	#2,a1

		move.b	(a0)+,(a1)+
		clr.b	(a1)+
		addq.w	#2,a1

		move.b	(a0)+,(a1)+
		clr.b	(a1)+
		addq.w	#2,a1

		move.b	(a0)+,(a1)+
		clr.b	(a1)+
		addq.w	#2,a1

		move.b	(a0)+,(a1)+
		clr.b	(a1)+
		addq.w	#2,a1

		move.b	(a0)+,(a1)+
		clr.b	(a1)+
		addq.w	#2,a1

		move.b	(a0)+,(a1)+
		clr.b	(a1)+
		addq.w	#2,a1

		move.b	(a0)+,(a1)+
		clr.b	(a1)+
		addq.w	#2,a1

		rts

wipe_text:	
		move.w	#8,chars
		move.l	screen,a0
		cmp.w	#259,line_counter	
		beq	done_wipe
		move.w	line_counter,d0
		addq.w  #1,line_counter
		mulu    #160,d0
		addi.w  #$28,d0
		adda.l  d0,a0 
		moveq   #0,d0 

		moveq   #$1d,d1
cleanloop:      move.l  d0,(a0) 
		addq.w  #4,a0 
		dbf     d1,cleanloop
		rts
done_wipe:
		move.l	#0,shoot_Y
		move.l	#0,line_counter
		rts


clean_prebuffer:
		move.l	#1280/4-1,d0	
		lea	shoot_buffer2,a1
cleanbuffer2:	move.l	#0,(a1)+
		dbf	d0,cleanbuffer2
		rts

;********** TEXT SHOOTING ******************>	

;********** BOUNCY SCROLLER **********

scrolling:
		cmpi.w	#8,chars3
		blt.b	nonew_yet
		bsr	put_carac
nonew_yet:	
		lea	buffer1,a3
		movea.l	a3,a0
		addq.w	#1,chars3
		lea	buffer2,a1

		moveq	#7,d7
_scroll_loop0
		lsl.w	(a0)+
		addq.l	#2,a0
		roxl.w	$98(a1)
		roxl.w	$90(a1)
		roxl.w	$88(a1)
		roxl.w	$80(a1)
		roxl.w	$78(a1)
		roxl.w	$70(a1)
		roxl.w	$68(a1)
		roxl.w	$60(a1)
		roxl.w	$58(a1)
		roxl.w	$50(a1)
		roxl.w	$48(a1)
		roxl.w	$40(a1)
		roxl.w	$38(a1)
		roxl.w	$30(a1)
		roxl.w	$28(a1)
		lea	160(a1),a1
		dbra	d7,_scroll_loop0

		move.l	screen,a1
		lea	160*200(a1),a1	
		lea	160*56(a1),a1	

		moveq	#0,d0
		movea.l	jumper,a0

		move.b	(a0)+,d0
		cmp.b	#$ff,d0
		bne	no_restart

		lea	jumping,a0
		move.l	a0,jumper		
		move.b	(a0)+,d0
no_restart:
		move.l	a0,jumper
		
		mulu	#160,d0
		add.l	d0,a1		
		movea.l	a1,a2

		lea	buffer2,a0
		moveq	#7,d7
_scroll_loop1:
		move.w	$28(a0),$28(a1)
		move.w	$30(a0),$30(a1)
		move.w	$38(a0),$38(a1)
		move.w	$40(a0),$40(a1)
		move.w	$48(a0),$48(a1)
		move.w	$50(a0),$50(a1)
		move.w	$58(a0),$58(a1)
		move.w	$60(a0),$60(a1)
		move.w	$68(a0),$68(a1)
		move.w	$70(a0),$70(a1)
		move.w	$78(a0),$78(a1)
		move.w	$80(a0),$80(a1)
		move.w	$88(a0),$88(a1)
		move.w	$90(a0),$90(a1)
		move.w	$98(a0),$98(a1)

		move.l	#(160-$28)-1,d1
		suba.l  #$a0-$28,a2
clean2:		move.b	#0,(a2)+
		dbf	d1,clean2		

		lea	$a0(a0),a0
		lea	$a0(a1),a1
		dbra	d7,_scroll_loop1

		move.l	#(160-$28)-1,d1
		suba.l  #($a0-$28),a0
clean_under:	move.b	#0,(a0)+
		dbf	d1,clean_under		
	
		rts

put_carac
		moveq	#0,d0
		movea.l	textscroll,a0
		move.b	(a0)+,d0
		tst.b	(a0)
		bne.b	no_recharge
		lea	text8_8,a0
no_recharge
		move.l	a0,textscroll
		clr.w	chars3

		lea	fonts,a0
		lea	buffer1,a1

		btst	#6,d0
		bne.s	letter2	
		and.w	#$1f,d0		
		adda.l	#$100,a0	;special chars starts at +$100
		bra	mul2
letter2:	subi.w	#$40,d0
mul2:		lsl.w	#3,d0
		adda.l	#2,a0		;skip the header

		adda.w	d0,a0

		move.b	(a0)+,(a1)+
		clr.b	(a1)+
		addq.w	#2,a1

		move.b	(a0)+,(a1)+
		clr.b	(a1)+
		addq.w	#2,a1

		move.b	(a0)+,(a1)+
		clr.b	(a1)+
		addq.w	#2,a1

		move.b	(a0)+,(a1)+
		clr.b	(a1)+
		addq.w	#2,a1

		move.b	(a0)+,(a1)+
		clr.b	(a1)+
		addq.w	#2,a1

		move.b	(a0)+,(a1)+
		clr.b	(a1)+
		addq.w	#2,a1

		move.b	(a0)+,(a1)+
		clr.b	(a1)+
		addq.w	#2,a1

		move.b	(a0)+,(a1)+
		clr.b	(a1)+
		addq.w	#2,a1

		rts

;**************** BOUNCY SCROLLING ******************>	

		SECTION	DATA
old_resolution	dc.b	0,0
line_counter	dc.w	0
clean_timer	dc.w    0
chars		dc.w	8
text_shoot	dc.l	message
textscroll	dc.l	text8_8
times		dc.w	0
shoot_Y		dc.l 	0
		even


message:
		DC.B      "                              ",0	;30 chars
		DC.B      "   ATARI LEGEND PRESENTS...   ",0
		DC.B      "                              ",0
		DC.B      " XENOMORPH EN/DE (C) PANDORA  ",0
		DC.B      " ---------------------------  ",0
		DC.B      "                              ",0
		DC.B      " CRACKED BY AVENGER           ",0
		DC.B      " SUPPLIED BY ATARI LEGEND     ",0
		DC.B      "                              ",0
		DC.B      " ONCE AGAIN WE ARE HERE TO    ",0
		DC.B      " BRING YOU ONE OF THE MAJOR   ",0
		DC.B      " TITLES, ENJOY!               ",0
		DC.B      "                              ",0
		DC.B      " WHY WE RELEASED THIS? OK I   ",0
		DC.B      " WILL TELL YOU. RECENTLY WE   ",0
		DC.B      " FOUND OUT THAT THE GAME HAS  ",0
		DC.B      " A BUG WHICH WILL CORRUPT     ",0
		DC.B      " THE GAME DISC BY FORMATTING  ",0
		DC.B	  " THE TRACK 0 IF THE DISC IS   ",0
		DC.B      " NOT WRITE PROTECTED. THIS    ",0
		DC.B      " HAPPENS ALSO WITH AN ORIGINAL",0
		DC.B      " AND THE CRACKED COPIES OUT   ",0
		DC.B      " THERE.                       ",0
		DC.B      "                              ",0
		DC.B      " WITH AN EMULATOR THIS BUG IS ",0
		DC.B      " DIFFICULT TO SPOT, BUT MORE  ",0
		DC.B      " EASILY WITH A REAL HARDWARE. ",0
		DC.B      "                              ",0
		DC.B      " WETHER ITS A BUG OR PART OF  ",0
		DC.B      " THE PROTECTION, DIFFICULT TO ",0
		DC.B      " SAY BUT ITS BEEN REMOVED NOW.",0
		DC.B      "                              ",0


		DC.B      " DUMDI DUMDI DUM......OK HERE ",0	;30 chars
		DC.B      " COMES THE CREDITS .....      ",0
		DC.B      "                              ",0
		DC.B      " CODE                  AVENGER",0
		DC.B      " GFX         MISTER A./NOEXTRA",0
		DC.B      " MUSIC                    JESS",0
		DC.B      "                              ",0
		DC.B      " GREETINGS ARE SENT TO:       ",0
		DC.B      "                              ",0
		DC.B	  " DBUG, ELITE, EVIL FORCE      ",0
		DC.B	  " EUROSWAP, HMD, ICS, IMPACT   ",0
		DC.B	  " MJJ PROD, NO EXTRA, OXYGENE  ",0
		DC.B	  " PARADIZE, POV, PULSION, PDX  ",0
		DC.B	  " RESERVOIR GODS, SECTOR ONE   ",0
		DC.B	  " ST KNIGHTS, STAX, SUPREMACY  ",0
		DC.B	  " THE LEMMINGS, TSCC, XTROLL   ",0
		DC.B	  " ZUUL AND THE REST            ",0
		DC.B      "                              ",0
		DC.B      " THATS IT, STAY TUNED FOR MORE",0
		DC.B      " RELEASES FROM US, BYE FOR NOW",0
		DC.B      "                              ",0
		DC.B      "  HTTP://WWW.ATARILEGEND.COM  ",0
		DC.B      "                              ",0
		DC.B      "                              ",0
		DC.B      "                              ",0
		DC.B      "                              ",0
		DC.B      "                              ",0
		DC.B      " REALLY ... NOTHING HERE :(   ",0
		DC.B      "                              ",0
		DC.B      "   BYE BYE.......... :)       ",0
		DC.B      "                              ",0
		DC.B      "                              ",0
		dc.b	$ff  ;the end sign, keep it like this
		even

text8_8:
		
 dc.b '                   '
 DC.B ' WELCOME TO ANOTHER NICE ATARI LEGEND RELEASE. THIS TIME WE BRING'
 dc.b ' YOU .......... XENOMORPH *ENGLISH/GERMAN* VERSION FROM PANDORA. '
 dc.b ' THE GAME WAS CRACKED BY AVENGER AND SUPPLIED BY ATARI LEGEND.   '
 DC.B '                '
 dc.b ' VISIT THE ATARI LEGEND WEBSITE AT HTTP://WWW.ATARILEGEND.COM    '
 DC.B ' THERE IS ALSO COMMUNITY FOR ATARI AT  HTTP://WWW.ATARI-FORUM.COM'
 dc.b '         '
 DC.B ' STAY TUNED FOR MORE RELEASE FROM ATARI LEGEND IN NEAR FUTURE... '
 dc.b '       ATARI LEGEND IS  .....    BRUME    KLAPAUZIUS    MARCER   '
 dc.b ' SILVER SURFER    MUGUK    ST GRAVEYARD    FRED R    GOLDRUNNER  '
 dc.b '  SHREDDER    DUNGEON.MASTER    CB    CHAMPIONS 2002    DBG    ZIPPY'
 dc.b '    AVENGER    AND OUR GUEST MEMBER    ALEX OF ICS       .........   '
 dc.b 'ALL RIGHT   TIME TO SAY BYE UNTIL THE NEXT ATARI LEGEND RELEASE...           '
 dc.b '            ATARI LEGEND OUT                                     '  
 dc.b 0
	even

jumper		dc.l jumping
jumping		dc.b 0,0,0,0,0,0
		dc.b 1,1,1,1,1,1
		dc.b 2,2,2,2,2,2
		dc.b 3,3,3,3,3,3
		dc.b 4,4,4,4,4,4
		dc.b 5,5,5,5,5,5
		dc.b 4,4,4,4,4,4
		dc.b 3,3,3,3,3,3
		dc.b 2,2,2,2,2,2
		dc.b 1,1,1,1,1,1
		dc.b 0,0,0,0,0,0
		dc.b $ff
		even

shoot_buffer1	ds.b 250					
shoot_buffer2	ds.b 1280

chars3		dc.b	0,$19,0,0
buffer1		ds.b	96
buffer2		ds.b	1500
		even

music		incbin "metchip.snd",0
		even
fonts:		incbin "dysp.64c",0
		even

st_fonts	incbin "_fnt8_1.fnt",0
		even
	
picture:	incbin	"al.pi1",0
endpic:		even

	SECTION	BSS
	
palette		ds.w	16
conterm		ds.w	1 
Vsync:		ds.b	1
       		ds.b	1
      	
save_stack:	ds.l	1

save_all:
		ds.b	5	
		ds.b	3	
Video		ds.b	1
		ds.b	1
		ds.l	1	
		ds.l	1	
		ds.l	1	
		ds.l	1	
		ds.l	1	
		ds.l	1	

screen:		ds.l	1
_scr:		ds.b	256	
big_screen:	ds.b	44500	
screen_len	equ	*-big_screen
		even
