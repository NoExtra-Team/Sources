; Code : Atomus
; Gfx neochrome master : Mister (A)
; Release date : 06/06/2004

	opt	o+,w-

	SECTION	TEXT

***********************************************
*                                             * 
***********************************************

	clr.l	-(sp)
	move.w	#32,-(sp)
	trap	#1
	addq.l	#6,sp
	move.l	d0,Save_stack

	bsr	Save_and_init_a_st

machine_test:
	move.l	$5a0.w,a0
	cmp.l	#$0,a0
	beq.s	.st		; Pas de cookie_jar donc un vieux st.
	move.l	$14(a0),d0
	cmp.l	#$0,d0		; _MCH=0 alors c' est un ST-STf.
	beq.s	.stf
	cmp.l	#$10000,d0	; _MCH=$10000 alors c' est un STe.
	beq.s	.ste	
	cmp.l	#$10010,d0	; _MCH=$10010 alors c' est un Mega STe.
	beq.s	.mste
	bra.s	.other_compy
	  
.st:
.stf:
.ste:
.mste:
	lea	PSG_1,a6
	jsr	PSG_2
	move.l	a6,PLAY_PSG
	bra.s	music_ok
	
.other_compy:			; Sinon on laisse le music flag a 0.
AFFICHAGE2:
	MOVE.L    #MESSAGE_FALCON,-(SP)	adresse du message
	MOVE.W    #9,-(SP)       	num‚ro fonction
	TRAP      #1             	appel Gemdos
	ADDQ.L    #6,SP          	correction pile
TOUCHE2:	   				;On attend un appui sur une touche pour contempler
	MOVE.W    #7,-(SP)
	TRAP      #1
	ADDQ.L    #2,SP
TEST_TOUCHE2:
	CMP.W     #"q",D0        	q minusule ?
	BEQ.s       QUITTER2        	oui, bye bye
	BRA.s       AFFICHAGE2          	retour a AFFICHAGE
QUITTER2:
	MOVE.W    #0,-(SP)
	TRAP      #1

music_ok:
	bsr	Init_screens

*-//
	sf	$ffff8260.w

	moveq	#0,d0
	lea	$fffffa00.w,a0
	movep.w	d0,$07(a0)
	movep.w	d0,$13(a0)

	bclr	#3,$fffffa17.w

	move.l	Turbo_scr1,d0
	move.b	d0,d1
	lsr.w	#8,d0
	move.b	d0,$ffff8203.w
	swap	d0
	move.b	d0,$ffff8201.w
	move.b	d1,$ffff820d.w

	sf	$fffffa21.w
	sf	$fffffa1b.w
	move.l	#timer_b,$120.w

	bset	#0,$fffffa07.w	* Timer B on
	bset	#0,$fffffa13.w	* Timer B on

	stop	#$2300
*-//
	bsr	Init

*-------------------------------------------------------------------------

	movea.l	Turbo_scr1,a0
	lea	160*120(a0),a0
	move.l	a0,ptr_adr_sin
	
	move.l	ptr_adr_sin,d0
	lea	SINUS,a0
	move.w	#160*3+15,d7
.l1:	add.l	d0,(a0)+
	dbf	d7,.l1
	
	lea	FONT,a0
	lea	buf_font,a1
	move.w	#95,d7
.l2:	move.l	a0,(a1)+
	lea	8(a0),a0
	dbf	d7,.l2
	
*-------------------------------------------------------------------------
	
******************************************************************************

Main_rout:
	bsr	Wait_vbl

	bsr.s	swapscreen
	
	bsr	SCROLL_8x8
	bsr	SIN_SCROLL
	bsr	effetmirroir
	
	cmp.b	#$39,$fffffc02.w	* Wait
	bne.s	Main_rout		* Space

Wait_main_rout:
	cmp.b	#$39+$80,$fffffc02.w	* Release
	bne.s	Wait_main_rout		* space bar

******************************************************************************

	move.b	#8,-$3fe.w
	move.l	#$8080000,$ff8800.l
	move.l	#$9090000,$ff8800.l
	move.l	#$a0a0000,$ff8800.l

	bsr	Restore_st

resetoldpal  
	movem.l	savepal,d0-d7	;get our old palette
	movem.l	d0-d7,$ffff8240.w	;set it

Kflush:
	btst	#0,$fffffc00.w
	beq.s	Flush_ok
	move.b	$fffffc02.w,d0
	bra.s	Kflush
Flush_ok:

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

swapscreen:
	move.l	Turbo_scr1,d0
	move.l	Turbo_scr2,Turbo_scr1
	move.l	d0,Turbo_scr2
	MOVE.B	Turbo_scr1+1,$FFFF8201.W
	MOVE.B	Turbo_scr1+2,$FFFF8203.W
	rts

Vbl:	
	*clr.w	$ffff8240.w	;color0
	move.l	#$0000FFF,$ffff8240.w
			
	movem.l	d0-d7/a0-a6,-(a7)
	
	st	Vsync
***
newvbl:	

	sf	$fffffa21.w	* Stop Timer B
	sf	$fffffa1b.w
	
	move.l	#timer_b,$120.w
	move.b	#97,$fffffa21.w		***
	move.b	#8,$fffffa1b.w

	clr.w	counter
	
	addq	#2,pointer_up		; offset -top speed
	cmp	#400,pointer_up
	blt.s	keep_on
	clr	pointer_up
	
keep_on	subq	#2,pointer_down		; offset -bottom speed
	tst	pointer_down
	bpl.s	end_vbl

	move	#300,pointer_down
end_vbl	
***	

music:	movea.l	PLAY_PSG,a6
	jsr	(a6)

; ----------------
; Led des lecteurs
; ----------------
        lea $ffff8800.w,a0
        move.b #10,(a0)
        move.b (a0),d0
        cmpi.b #14,d0
        blt.s led_off
led_on: move.b #14,(a0)
        move.b (a0),d0
        andi.b #$f9,d0
        move.b d0,2(a0)
        bra.s led_out
led_off:move.b #14,(a0)
        move.b (a0),d0
        ori.b #6,d0
        move.b d0,2(a0)
led_out:

	movem.l	(a7)+,d0-d7/a0-a6
	rte

Wait_vbl:	move.l	a0,-(a7)

	lea	Vsync,a0
	sf	(a0)
Wait_label:	
	tst.b	(a0)
	beq.s	Wait_label
	move.l	(a7)+,a0
	rts

*********************************************
*                                           *
*********************************************

Init:	movem.l	d0-d7/a0-a6,-(a7)

	lea	Vbl,a0
	move.l	a0,$70.w

	lea	Pal,a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

	movem.l	(a7)+,d0-d7/a0-a6
	rts

************************************************
*                                              *
************************************************

Save_and_init_a_st:
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

	move.l	$070.w,(a0)+	
	move.l	$118.w,(a0)+	
	move.l	$120.w,(a0)+	
	move.l	$134.w,(a0)+	
	move.l	$114.w,(a0)+	
	move.l	$110.w,(a0)+	
	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,(a0)
	rts

***************************************************************
*                                                             *
*             < Here is the lower border rout >               *
*                                                             *
***************************************************************
HBL1:
	move.l	#$0010DDD,$ffff8240.w
	
	sf	$fffffa21.w	* Stop Timer B
	sf	$fffffa1b.w

	move.l	#HBL0,$120.w
	move.b	#18,$fffffa21.w
	move.b	#8,$fffffa1b.w
	rte

HBL0:
	sf	$fffffa21.w	* Stop Timer B
	sf	$fffffa1b.w

	REPT	95	* Wait line end
	nop
	ENDR	
	
	sf	$ffff820a.w	* Modif Frequency 60 Hz !

	REPT	28	* Wait a little
	nop
	ENDR

	move.b	#$2,$ffff820a.w * 50 Hz !
	rte

***************************************************************
*                                                             *
***************************************************************

Restore_st:
	move.w	#$2700,sr

	lea	Save_all,a0
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

	movem.l	(a0),d0-d7
	movem.l	d0-d7,$ffff8240.w

	stop	#$2300

* Sorry for the next lines, but sometimes there somes syncs error !!

	move.b	Video,$ffff8260.w
	move.w	#$25,-(a7)
	trap	#14
	addq.w	#2,a7
	move.b	Video,$ffff8260.w
	rts

************************************************
*                                              *
************************************************

Init_screens:	
	movem.l	d0-d7/a0-a6,-(a7)

	move.l	#Turbo_screen1,d0
	add.w	#$ff,d0
	sf	d0
	move.l	d0,Turbo_scr1

	move.l	#Turbo_screen1,d1
	add.w	#$ff,d1
	sf	d1
	move.l	d1,Turbo_scr2

Cls_screens:
	move.l	Turbo_scr1,a0
	move.l	Turbo_scr2,a1
	move.w	#7999,d7
.clear:	clr.l	(a0)+
	clr.l	(a1)+
	dbf	d7,.clear
	
	movea.l	Turbo_scr1,a1
	movea.l	#IMG_LOGO,a0
	move.l	#3799,d0
.aff:	move.l	(a0)+,(a1)+
	dbf	d0,.aff

palette 
	movem.l   $ffff8240.w,d0-d7     ;get entire palette
	movem.l   d0-d7,savepal       ;save palette

	movem.l	(a7)+,d0-d7/a0-a6
	rts

******************************************************************

SCROLL_8x8:
	addq.w      #1,cpt1_8x8
	andi.w      #3,cpt1_8x8
	bne.b       .nop
	lea         PTEXTE,A0
	adda.w      cpt2_8x8,A0
	addq.w      #1,cpt2_8x8
	moveq       #0,D0
	move.b      (A0),D0
	bne.b       .clrc
	moveq       #4*8,D0
	clr.w       cpt2_8x8
.clrc:
	subi.w      #4*8,D0
	lea         FONT8x8,A0
	lsl.w       #3,D0
	adda.w      D0,A0
	lea         cpt3_8x8,A1
	move.l      (A0)+,(A1)+
	move.l      (A0)+,(A1)+
.nop:
	addq.w      #1,cpt4_8x8
	andi.w      #8-1,cpt4_8x8
	bne.b       .gap
	addq.w      #1,cpt5_8x8
	cmpi.w      #22-1,cpt5_8x8
	bmi.b       .gap
	clr.w       cpt5_8x8
.gap:
	lea         BUFFER_8L,A3
	move.w      cpt4_8x8,D0
	add.w       D0,D0
	add.w       D0,D0
	movea.l     0(A3,D0.w),A3
	move.w      cpt5_8x8,D0
	add.w       D0,D0
	adda.w      D0,A3
	pea         2(A3)
	lea         BUFFER_L,A0
	lea         cpt3_8x8,A1
	moveq       #8-1,D7
.presh:
	move.b      (A1),D0
	move.w      (A0),D1
	addx.b      D0,D0
	addx.w      D1,D1
	addx.b      D0,D0
	addx.w      D1,D1
	move.w      D1,(A0)+
	move.b      D0,(A1)+
	move.w      D1,(A3)
	move.w      D1,$2A(A3)
	lea         84(A3),A3
	dbra        D7,.presh
	movea.l     Turbo_scr1,A0
	lea         160*102(A0),A0
	movea.l     (SP)+,A2
	moveq       #8-1,D7
.scroll:
	move.w      (A2)+,$00(A0)
	move.w      (A2)+,$08(A0)
	move.w      (A2)+,$10(A0)
	move.w      (A2)+,$18(A0)
	move.w      (A2)+,$20(A0)
	move.w      (A2)+,$28(A0)
	move.w      (A2)+,$30(A0)
	move.w      (A2)+,$38(A0)
	move.w      (A2)+,$40(A0)
	move.w      (A2)+,$48(A0)
	move.w      (A2)+,$50(A0)
	move.w      (A2)+,$58(A0)
	move.w      (A2)+,$60(A0)
	move.w      (A2)+,$68(A0)
	move.w      (A2)+,$70(A0)
	move.w      (A2)+,$78(A0)
	move.w      (A2)+,$80(A0)
	move.w      (A2)+,$88(A0)
	move.w      (A2)+,$90(A0)
	move.w      (A2)+,$98(A0)
	lea         5*8+4(A2),A2
	lea         160(A0),A0
	dbra        D7,.scroll
	rts         
		
SIN_SCROLL:	
	clr.l	d0
	movea.l	ptr_adr_sin,a1
 rept 68
	move.w	d0,(a1)
	move.w	d0,8(a1)
	move.w	d0,16(a1)
	move.w	d0,24(a1)
	move.w	d0,32(a1)
	move.w	d0,40(a1)
	move.w	d0,48(a1)
	move.w	d0,56(a1)
	move.w	d0,64(a1)
	move.w	d0,72(a1)
	move.w	d0,80(a1)
	move.w	d0,88(a1)
	move.w	d0,96(a1)
	move.w	d0,104(a1)
	move.w	d0,112(a1)
	move.w	d0,120(a1)
	move.w	d0,128(a1)
	move.w	d0,136(a1)
	move.w	d0,144(a1)
	move.w	d0,152(a1)
	lea	160(a1),a1
 endr
	subq.w	#1,cpt
	bne.s	.no_clean
	move.w	#$f8,cpt
	move.l	#SINUS,PTR_SINUS
	bra.s	.go_up
.no_clean:
	addq.l	#4,PTR_SINUS
.go_up:
	tst.w	PAS
	beq.s	.reset
	bra.s	.roxl
.reset:
	move.w	#8,PAS
	clr.l	d0
	movea.l	PT_TEXTE,a0
	move.b	(a0)+,d0
	bne.s	.put_txt
	lea	TEXTE,a0
	move.l	a0,PT_TEXTE
	move.b	(a0)+,d0
.put_txt:
	move.l	a0,PT_TEXTE
	subi.w	#$20,d0
	asl.w	#2,d0
	lea	buf_font,a1
	movea.l	0(a1,d0.w),a0
	lea	buf_beg,a2
	move.b	(a0)+,(a2)
	move.b	(a0)+,168(a2)
	move.b	(a0)+,336(a2)
	move.b	(a0)+,504(a2)
	move.b	(a0)+,672(a2)
	move.b	(a0)+,840(a2)
	move.b	(a0)+,1008(a2)
	move.b	(a0)+,1176(a2)
.roxl:
	lea	buf_end,a0
	move	#0,ccr
	roxl	160(a0)
	roxl	152(a0)
	roxl	144(a0)
	roxl	136(a0)
	roxl	128(a0)
	roxl	120(a0)
	roxl	112(a0)
	roxl	104(a0)
	roxl	96(a0)
	roxl	88(a0)
	roxl	80(a0)
	roxl	72(a0)
	roxl	64(a0)
	roxl	56(a0)
	roxl	48(a0)
	roxl	40(a0)
	roxl	32(a0)
	roxl	24(a0)
	roxl	16(a0)
	roxl	8(a0)
	roxl	(a0)
	lea	168(a0),a0
	move	#0,ccr
	roxl	160(a0)
	roxl	152(a0)
	roxl	144(a0)
	roxl	136(a0)
	roxl	128(a0)
	roxl	120(a0)
	roxl	112(a0)
	roxl	104(a0)
	roxl	96(a0)
	roxl	88(a0)
	roxl	80(a0)
	roxl	72(a0)
	roxl	64(a0)
	roxl	56(a0)
	roxl	48(a0)
	roxl	40(a0)
	roxl	32(a0)
	roxl	24(a0)
	roxl	16(a0)
	roxl	8(a0)
	roxl	(a0)
	lea	168(a0),a0
	move	#0,ccr
	roxl	160(a0)
	roxl	152(a0)
	roxl	144(a0)
	roxl	136(a0)
	roxl	128(a0)
	roxl	120(a0)
	roxl	112(a0)
	roxl	104(a0)
	roxl	96(a0)
	roxl	88(a0)
	roxl	80(a0)
	roxl	72(a0)
	roxl	64(a0)
	roxl	56(a0)
	roxl	48(a0)
	roxl	40(a0)
	roxl	32(a0)
	roxl	24(a0)
	roxl	16(a0)
	roxl	8(a0)
	roxl	(a0)
	lea	168(a0),a0
	move	#0,ccr
	roxl	160(a0)
	roxl	152(a0)
	roxl	144(a0)
	roxl	136(a0)
	roxl	128(a0)
	roxl	120(a0)
	roxl	112(a0)
	roxl	104(a0)
	roxl	96(a0)
	roxl	88(a0)
	roxl	80(a0)
	roxl	72(a0)
	roxl	64(a0)
	roxl	56(a0)
	roxl	48(a0)
	roxl	40(a0)
	roxl	32(a0)
	roxl	24(a0)
	roxl	16(a0)
	roxl	8(a0)
	roxl	(a0)
	lea	168(a0),a0
	move	#0,ccr
	roxl	160(a0)
	roxl	152(a0)
	roxl	144(a0)
	roxl	136(a0)
	roxl	128(a0)
	roxl	120(a0)
	roxl	112(a0)
	roxl	104(a0)
	roxl	96(a0)
	roxl	88(a0)
	roxl	80(a0)
	roxl	72(a0)
	roxl	64(a0)
	roxl	56(a0)
	roxl	48(a0)
	roxl	40(a0)
	roxl	32(a0)
	roxl	24(a0)
	roxl	16(a0)
	roxl	8(a0)
	roxl	(a0)
	lea	168(a0),a0
	move	#0,ccr
	roxl	160(a0)
	roxl	152(a0)
	roxl	144(a0)
	roxl	136(a0)
	roxl	128(a0)
	roxl	120(a0)
	roxl	112(a0)
	roxl	104(a0)
	roxl	96(a0)
	roxl	88(a0)
	roxl	80(a0)
	roxl	72(a0)
	roxl	64(a0)
	roxl	56(a0)
	roxl	48(a0)
	roxl	40(a0)
	roxl	32(a0)
	roxl	24(a0)
	roxl	16(a0)
	roxl	8(a0)
	roxl	(a0)
	lea	168(a0),a0
	move	#0,ccr
	roxl	160(a0)
	roxl	152(a0)
	roxl	144(a0)
	roxl	136(a0)
	roxl	128(a0)
	roxl	120(a0)
	roxl	112(a0)
	roxl	104(a0)
	roxl	96(a0)
	roxl	88(a0)
	roxl	80(a0)
	roxl	72(a0)
	roxl	64(a0)
	roxl	56(a0)
	roxl	48(a0)
	roxl	40(a0)
	roxl	32(a0)
	roxl	24(a0)
	roxl	16(a0)
	roxl	8(a0)
	roxl	(a0)
	lea	168(a0),a0
	move	#0,ccr
	roxl	160(a0)
	roxl	152(a0)
	roxl	144(a0)
	roxl	136(a0)
	roxl	128(a0)
	roxl	120(a0)
	roxl	112(a0)
	roxl	104(a0)
	roxl	96(a0)
	roxl	88(a0)
	roxl	80(a0)
	roxl	72(a0)
	roxl	64(a0)
	roxl	56(a0)
	roxl	48(a0)
	roxl	40(a0)
	roxl	32(a0)
	roxl	24(a0)
	roxl	16(a0)
	roxl	8(a0)
	roxl	(a0)
	lea	168(a0),a0
	subq.w	#1,PAS
	lea	buf_end,a0
	move	#0,ccr
	roxl	160(a0)
	roxl	152(a0)
	roxl	144(a0)
	roxl	136(a0)
	roxl	128(a0)
	roxl	120(a0)
	roxl	112(a0)
	roxl	104(a0)
	roxl	96(a0)
	roxl	88(a0)
	roxl	80(a0)
	roxl	72(a0)
	roxl	64(a0)
	roxl	56(a0)
	roxl	48(a0)
	roxl	40(a0)
	roxl	32(a0)
	roxl	24(a0)
	roxl	16(a0)
	roxl	8(a0)
	roxl	(a0)
	lea	168(a0),a0
	move	#0,ccr
	roxl	160(a0)
	roxl	152(a0)
	roxl	144(a0)
	roxl	136(a0)
	roxl	128(a0)
	roxl	120(a0)
	roxl	112(a0)
	roxl	104(a0)
	roxl	96(a0)
	roxl	88(a0)
	roxl	80(a0)
	roxl	72(a0)
	roxl	64(a0)
	roxl	56(a0)
	roxl	48(a0)
	roxl	40(a0)
	roxl	32(a0)
	roxl	24(a0)
	roxl	16(a0)
	roxl	8(a0)
	roxl	(a0)
	lea	168(a0),a0
	move	#0,ccr
	roxl	160(a0)
	roxl	152(a0)
	roxl	144(a0)
	roxl	136(a0)
	roxl	128(a0)
	roxl	120(a0)
	roxl	112(a0)
	roxl	104(a0)
	roxl	96(a0)
	roxl	88(a0)
	roxl	80(a0)
	roxl	72(a0)
	roxl	64(a0)
	roxl	56(a0)
	roxl	48(a0)
	roxl	40(a0)
	roxl	32(a0)
	roxl	24(a0)
	roxl	16(a0)
	roxl	8(a0)
	roxl	(a0)
	lea	168(a0),a0
	move	#0,ccr
	roxl	160(a0)
	roxl	152(a0)
	roxl	144(a0)
	roxl	136(a0)
	roxl	128(a0)
	roxl	120(a0)
	roxl	112(a0)
	roxl	104(a0)
	roxl	96(a0)
	roxl	88(a0)
	roxl	80(a0)
	roxl	72(a0)
	roxl	64(a0)
	roxl	56(a0)
	roxl	48(a0)
	roxl	40(a0)
	roxl	32(a0)
	roxl	24(a0)
	roxl	16(a0)
	roxl	8(a0)
	roxl	(a0)
	lea	168(a0),a0
	move	#0,ccr
	roxl	160(a0)
	roxl	152(a0)
	roxl	144(a0)
	roxl	136(a0)
	roxl	128(a0)
	roxl	120(a0)
	roxl	112(a0)
	roxl	104(a0)
	roxl	96(a0)
	roxl	88(a0)
	roxl	80(a0)
	roxl	72(a0)
	roxl	64(a0)
	roxl	56(a0)
	roxl	48(a0)
	roxl	40(a0)
	roxl	32(a0)
	roxl	24(a0)
	roxl	16(a0)
	roxl	8(a0)
	roxl	(a0)
	lea	168(a0),a0
	move	#0,ccr
	roxl	160(a0)
	roxl	152(a0)
	roxl	144(a0)
	roxl	136(a0)
	roxl	128(a0)
	roxl	120(a0)
	roxl	112(a0)
	roxl	104(a0)
	roxl	96(a0)
	roxl	88(a0)
	roxl	80(a0)
	roxl	72(a0)
	roxl	64(a0)
	roxl	56(a0)
	roxl	48(a0)
	roxl	40(a0)
	roxl	32(a0)
	roxl	24(a0)
	roxl	16(a0)
	roxl	8(a0)
	roxl	(a0)
	lea	168(a0),a0
	move	#0,ccr
	roxl	160(a0)
	roxl	152(a0)
	roxl	144(a0)
	roxl	136(a0)
	roxl	128(a0)
	roxl	120(a0)
	roxl	112(a0)
	roxl	104(a0)
	roxl	96(a0)
	roxl	88(a0)
	roxl	80(a0)
	roxl	72(a0)
	roxl	64(a0)
	roxl	56(a0)
	roxl	48(a0)
	roxl	40(a0)
	roxl	32(a0)
	roxl	24(a0)
	roxl	16(a0)
	roxl	8(a0)
	roxl	(a0)
	lea	168(a0),a0
	move	#0,ccr
	roxl	160(a0)
	roxl	152(a0)
	roxl	144(a0)
	roxl	136(a0)
	roxl	128(a0)
	roxl	120(a0)
	roxl	112(a0)
	roxl	104(a0)
	roxl	96(a0)
	roxl	88(a0)
	roxl	80(a0)
	roxl	72(a0)
	roxl	64(a0)
	roxl	56(a0)
	roxl	48(a0)
	roxl	40(a0)
	roxl	32(a0)
	roxl	24(a0)
	roxl	16(a0)
	roxl	8(a0)
	roxl	(a0)
	lea	168(a0),a0
	subq.w	#1,PAS
	lea	ASCII,a0
	movea.l	PTR_SINUS,a1
 rept 40
	lea	buf_end,a2
	movea.l	(a1)+,a3
	clr.l	d0
	move.b	(a0)+,d0
	adda.l	d0,a2
	adda.l	d0,a3
	move.b	(a2),(a3)
	move.b	168(a2),160(a3)
	move.b	336(a2),320(a3)
	move.b	504(a2),480(a3)
	move.b	672(a2),640(a3)
	move.b	840(a2),800(a3)
	move.b	1008(a2),960(a3)
	move.b	1176(a2),1120(a3)
 endr
	rts
	
effetmirroir:
	movem.l	d0-a6,-(sp)
	movea.l	Turbo_scr1,a0
	lea	160*180(a0),a0
	movea.l	a0,a1
	move.w	#66-1,d6
.boucle:
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	lea	-160*2(a0),a0
	dbra	d6,.boucle
	movem.l	(sp)+,d0-a6
	rts
	
*-------------------------------------------------------------------------

timer_b
	clr.b	$fffffa1b.w
	movem.l	d0/a0-a3,-(sp)
	move	sr,-(sp)
	move	#$2700,sr
	lea	colors(pc),a0
	adda	pointer_up(pc),a0
	lea	$ffff8240.w,a1
	lea	$ffff8209.w,a2
	lea	top_beam(pc),a3
	moveq	#0,d0
wait_up	tst.b	(a2)
	beq.s	wait_up
	move.b	(a2),d0
	adda.l	d0,a3
	jmp	(a3)

top_beam	rept	172		; synchronize
	nop
	endr
	
	rept	42		; width of screen
	move	(a0)+,(a1)
	endr
	
	move	#0,(a1)
	move	(sp)+,sr
	movem.l	(sp)+,d0/a0-a3

	sf	$fffffa21.w	* Stop Timer B
	sf	$fffffa1b.w
	
	move.l	#timer_b_beam,$120.w
	move.b	#11,$fffffa21.w		***
	move.b	#8,$fffffa1b.w
		
	rte

timer_b_beam:
	clr.b	$fffffa1b.w
	movem.l	d0/a0-a3,-(sp)
	move	sr,-(sp)
	move	#$2700,sr
	lea	colors(pc),a0
	adda	pointer_down(pc),a0
	lea	$ffff8240.w,a1
	lea	$ffff8209.w,a2
	lea	bottom_beam(pc),a3
	moveq	#0,d0
wait_down	tst.b	(a2)
	beq.s	wait_down
	move.b	(a2),d0
	adda.l	d0,a3
	jmp	(a3)

bottom_beam:
 rept	203		; wait until next scanline
	nop
 endr
	
 rept	42		; width of screen
	move	(a0)+,(a1)
 endr
	
	move	#0,(a1)
	move	(sp)+,sr
	movem.l	(sp)+,d0/a0-a3
	
	bclr	#0,$fffffffa0f.w

	sf	$fffffa21.w	* Stop Timer B
	sf	$fffffa1b.w
	
	move.l	#HBL1,$120.w
	move.b	#69,$fffffa21.w		***
	move.b	#8,$fffffa1b.w
	rte

	SECTION	BSS

*--------------------------------------------------------------------------
ptr_adr_sin:	ds.l	1
buf_font:	ds.b	384
buf_end:	ds.b	160
buf_beg:	ds.b	1196
*--------------------------------------------------------------------------

cpt1_8x8:    ds.w        1           ;=2
cpt2_8x8:    ds.w        1           ;=2
cpt3_8x8:    ds.l        2           ;=8
cpt4_8x8:    ds.w        1           ;=2
cpt5_8x8:    ds.w        1           ;=2
BUFFER_L0:    ds.l        168         ;=672
BUFFER_L1:    ds.l        168         ;=672
BUFFER_L2:    ds.l        168         ;=672
BUFFER_L3:    ds.l        168         ;=672
BUFFER_L4:    ds.l        168         ;=672
BUFFER_L5:    ds.l        168         ;=672
BUFFER_L6:    ds.l        168         ;=672
BUFFER_L7:    ds.l        168         ;=672
BUFFER_L:    ds.l        4           ;=16

Vsync:	ds.w	1
Save_stack:	ds.l	1

Save_all:
	ds.b	5	* Mfp
	ds.b	3	* Video
Video	ds.b	1
	ds.b	1
	ds.l	1	* Vbl
	ds.l	1	* Kbd
	ds.l	1	* Timer b
	ds.l	1	* Timer a
	ds.l	1	* Timer c
	ds.l	1	* Timer d
	ds.w	16	* Palette

Turbo_scr1:	ds.l	1
Turbo_scr2:	ds.l	1
Turbo_screen1:	ds.b	(160*250)+256

savepal:
   ds.b 	32
	even

	SECTION	DATA

Pal:
	dc.w	$0000,$0F00,$0223,$0334,$0777,$0433,$0555,$0753
	dc.w	$0774,$0444,$0431,$0322,$0111,$0554,$0544,$0FFF

* // Loader...
MESSAGE_FALCON:
	DC.B "Only Atari ST/F/E please..",13,10,0
	EVEN
* // Beam colors
counter:
	dc.w	0
pointer_up:
	dc.w	0
pointer_down:
	dc.w	300
add		equ	$f0
add2	equ	$f0
add3	equ	$df
colors:
	ds.w	100 * black
	dc.w	$101,$111+add2,$221+add2,$321+add,$421+add,$431+add,$431+add,$431+add,$432+add,$432+add,$432+add,$433+add,$433+add,$433+add,$434+add,$434+add
	dc.w	$434+add3,$435+add3,$435+add3,$435+add3,$436+add3,$436+add3,$436+add3,$437+add3,$437+add3,$437+add3,$436+add3,$436+add3,$436+add3,$435+add3,$435+add3,$435+add3
	dc.w	$434+add3,$434+add,$434+add,$433+add,$433+add,$433+add,$432+add,$432+add,$432+add,$431+add,$431+add,$431+add,$421+add,$321+add
	dc.w	$221+add2,$111+add2,$101
	ds.w	100 * black

* // Scroll Horinzontal 8x8 1 bitplane
FONT8x8:
	incbin	"F8X8.DAT"
	even
PTEXTE:
	dc.b	'HELLO ATARIANS!             '
	dc.b	'                        N.O.X.T.R.A. IS '
	dc.b	'PROUD TO PRESENT HIS FIRST INTRO ON ATARI '
	dc.b	'ST PROGRAMMED IN ASSEMBLY. THIS NEW CREW IS '
	dc.b	'COMPOSED BY ME : ATOMUS, THE CODER AND '
	dc.b	'MISTER (A) : THE GFX-EXTRA-MAN. DON',$27
	dc.b	'T FORGET TO CREDIT THIS NICE SOUNDCHIP '
	dc.b	'FROM CRAWDADDY.                        '
	dc.b	'                                       '
	dc.b	'                        IF YOU SEE THE '
	dc.b	'REAL CODE OF THIS INTRO, SEND ME IT AT '
	dc.b	'ATOMUS(A)PERSO.BE PLEASE!       THANKS'
	dc.b	' TO SIMON SUNNYBOY FOR THIS COOL COMPILATION AND MODOS'
	dc.b	' AND ADMINS OF THE ATARIFORUM.COM ;)   '
	dc.b	'                                      '
	dc.b	'            IF YOU DON',$27,'T SEE THE '
	dc.b	'BOTTOM SCROLL_8x8, I CAN ONLY TELL YOU '
	dc.b	'THAT IS JUST A BRIEF ENULERATION OF '
	dc.b	'CREWS WHO PARTICIPATED AT DEMOS ON '
	dc.b	'ATARI ST!                             '
	dc.b	'                                      '
	dc.b	'THIS INTRO WAS TESTING ON ATARI STF WITH '
	dc.b	'TWO MEGA OF MEMORY AND ON ATARI STE '
	dc.b	'FOUR MEGA OF MEMORY AND NO NEED'
	dc.b	' A BLITTER!      AND ON THE LAST '
	dc.b	'VERSION OF STEEM OF COURSE!          '
	dc.b	'                 WE NEEDS DEVPACK TO '
	dc.b	'COMPILE ASM CODE AND NEOCHROME MASTER'
	dc.b	' FOR GFXS.                           '
	dc.b	'                                      '
	dc.b	'INTRO RELEASED BY N.O.X.T.R.A. IN 2YK4.'
	dc.b	'                                      '
	dc.b	'                                      '
	dc.b	'SEE YOU LATER FOR A NEXT LAME INTRO...'
	dc.b	'                                      '
	dc.b	'                                      ',$0
	even
BUFFER_8L: * eight lines
  dc.l	BUFFER_L0
	dc.l	BUFFER_L1
	dc.l	BUFFER_L2
	dc.l	BUFFER_L3
	dc.l	BUFFER_L4
	dc.l	BUFFER_L5
	dc.l	BUFFER_L6
	dc.l	BUFFER_L7

*--------------------------------------------------------------------------
cpt:
	dc.w	$f8
PTR_SINUS:
	dc.l	SINUS
PT_TEXTE:
	dc.l	TEXTE
TEXTE:
	dc.b	'                                                '
	dc.b	'ALL ATARI ST CREWS : '
	dc.b	'42 CREW - '
	dc.b	'ABC - '
	dc.b	'ACCS - '
	dc.b	'ACF - '
	dc.b	'ACSS - '
	dc.b	'ADMIRABLES - '
	dc.b	'ADRENALIN - '
	dc.b	'ADRENALINE - '
	dc.b	'AENIGMATICA - '
	dc.b	'AGGRESSION - '
	dc.b	'ALIEN CRACKING FORMATION - '
	dc.b	'ALKALINE - '
	dc.b	'AN COOL - '
	dc.b	'AURA - '
	dc.b	'BBC - '
	dc.b	'BIG ALEC - '
	dc.b	'BLT - '
	dc.b	'BRAINLESS INSTITUTE - '
	dc.b	'CAT DEVELOPMENT - '
	dc.b	'CHANNEL 38 - '
	dc.b	'CHAOS - '
	dc.b	'CHECKPOINT - '
	dc.b	'CHRONICLE - '
	dc.b	'CIA - '
	dc.b	'CLAN - '
	dc.b	'COBRA - '
	dc.b	'CODEBUSTER - '
	dc.b	'CONDEMNED - '
	dc.b	'CONSTELLATIONS - '
	dc.b	'COOL CREW - '
	dc.b	'CRAZY GUY',$27,'S - '
	dc.b	'CRC - '
	dc.b	'CREAM - '
	dc.b	'CRIMINAL IN DISGUISE - '
	dc.b	'CRYSTALIC - '
	dc.b	'CYBERNETICS - '
	dc.b	'DARK ANGEL - '
	dc.b	'DARK TRIP - '
	dc.b	'DHS - '
	dc.b	'DEATH - '
	dc.b	'D-BUG - '
	dc.b	'DELTA FORCE - '
	dc.b	'DESKTOP CENTER - '
	dc.b	'DIAMOND DESIGN - '
	dc.b	'DIGI TALLIS - '
	dc.b	'DIGITAL CREW - '
	dc.b	'DIGITAL JUSTICE - '
	dc.b	'DMA - '
	dc.b	'DNS - '
	dc.b	'DNT CREW - '
	dc.b	'DOM - '
	dc.b	'DOUBLE DUTCH CREW - '
	dc.b	'DUNE - '
	dc.b	'DYNAMIC DUO - '
	dc.b	'EAGLES - '
	dc.b	'ECHO CRAY - '
	dc.b	'EDGE OF SANITY - '
	dc.b	'EFFECT - '
	dc.b	'ELECTRA - '
	dc.b	'ELECTRIC CAFE - '
	dc.b	'ELECTRONIC IMAGE - '
	dc.b	'ELITE - '
	dc.b	'ELLIPSE  - '
	dc.b	'EMPIRE - '
	dc.b	'EONE - '
	dc.b	'EPSILON - '
	dc.b	'EQUINOX - '
	dc.b	'ETERNAL - '
	dc.b	'ETERNITY - '
	dc.b	'EUPHORIA - '
	dc.b	'EXTREAM - '
	dc.b	'FACTORY - '
	dc.b	'FALCON - '
	dc.b	'FALLEN ANGELS - '
	dc.b	'FANATICS - '
	dc.b	'FANTASY - '
	dc.b	'FINGERBOBS - '
	dc.b	'FIRE CRACKER - '
	dc.b	'FIRSTE - '
	dc.b	'F.L.A. - '
	dc.b	'FLASH - '
	dc.b	'FLEXIBLE FRONT - '
	dc.b	'FMCC - '
	dc.b	'FRONTLINE - '
	dc.b	'FUTUR MINDS - '
	dc.b	'FUZION - '
	dc.b	'GALTAN SIX - '
	dc.b	'GESOX - '
	dc.b	'GHOST - '
	dc.b	'GUDUL - '
	dc.b	'GUEST - '
	dc.b	'HEMOROIDS - '
	dc.b	'HIGH VOLTAGE - '
	dc.b	'HOLOCAUST - '
	dc.b	'HOTLINE - '
	dc.b	'HYDROXID - '
	dc.b	'ICE - '
	dc.b	'ICS - '
	dc.b	'ILLEGAL EXCEPTION - '
	dc.b	'IMA - '
	dc.b	'IMAGINA - '
	dc.b	'IMMORTAL IMAGINATION CREW - '
	dc.b	'IMPACT - '
	dc.b	'IMPULSE - '
	dc.b	'INNER CIRCLE - '
	dc.b	'INSANITY - '
	dc.b	'INSOMNIA - '
	dc.b	'INTERGALACTIC - '
	dc.b	'JCB - '
	dc.b	'JESTER - '
	dc.b	'JSD - '
	dc.b	'KGB - '
	dc.b	'KOOKAI - '
	dc.b	'KRUZ - '
	dc.b	'LAZER - '
	dc.b	'LEGACY - '
	dc.b	'LEVEL 16 - '
	dc.b	'LIGHT - '
	dc.b	'LOUD! - '
	dc.b	'LYNX - '
	dc.b	'MAD VISION - '
	dc.b	'MANTIS - '
	dc.b	'MCA - '
	dc.b	'MCODER - '
	dc.b	'MEDWAY BOYS - '
	dc.b	'MEGA WANX - '
	dc.b	'MEGACREW - '
	dc.b	'MENACING CRACKING ALLIANCE - '
	dc.b	'MJC - '
	dc.b	'MJJ-PROD - '
	dc.b	'MONARCH - '
	dc.b	'MPH - '
	dc.b	'MST - '
	dc.b	'MUG UK - '
	dc.b	'MYSTIC - '
	dc.b	'NAOS - '
	dc.b	'NETWORK - '
	dc.b	'NEW CORE - '
	dc.b	'NEW POWER GENERATION - '
	dc.b	'NEXT - '
	dc.b	'NLC - '
	dc.b	'NOD - '
	dc.b	'OFF BASE - '
	dc.b	'OFFBEAT - '
	dc.b	'OMEGA - '
	dc.b	'ORIGINAL DESIGNS UNLIMITED - '
	dc.b	'OUCH - '
	dc.b	'OVERLANDERS - '
	dc.b	'OVERLORDS - '
	dc.b	'OXYGENE - '
	dc.b	'PARADIZE - '
	dc.b	'PARANOIA - '
	dc.b	'PASSION - '
	dc.b	'PCM - '
	dc.b	'PENDRAGONS - '
	dc.b	'PERSISTENCE OF VISION - '
	dc.b	'PHALANX - '
	dc.b	'PHF - '
	dc.b	'POLTERGEIST - '
	dc.b	'POMPEY PIRATES - '
	dc.b	'POSITIVITY - '
	dc.b	'PRIEST OF PLEASURE - '
	dc.b	'PROPHECY - '
	dc.b	'PSYCHONOMIX - '
	dc.b	'PULSION - '
	dc.b	'PURE ENERGY - '
	dc.b	'RADIATION - '
	dc.b	'RADICAL SYSTEMS - '
	dc.b	'REANIMATORS - '
	dc.b	'REDLITE - '
	dc.b	'RIPPED OFF - '
	dc.b	'RISK - '
	dc.b	'ROGGIE - '
	dc.b	'SAD - '
	dc.b	'SCOOBY DOO CREW - '
	dc.b	'SCOTISH CRACKING CREW - '
	dc.b	'SCUM OF THE EARTH - '
	dc.b	'SECTOR ONE - '
	dc.b	'SEDMA - '
	dc.b	'SENTRY - '
	dc.b	'SEWER SOFTWARE - '
	dc.b	'SIGMA - '
	dc.b	'SOFTWARE FOUNDATION - '
	dc.b	'SPECIAL FX - '
	dc.b	'SPECTRE - '
	dc.b	'SPHERE - '
	dc.b	'SPHERICAL - '
	dc.b	'SPL CREW - '
	dc.b	'ST CONNEXION - '
	dc.b	'ST KNIGHTS - '
	dc.b	'ST SPIRIT - '
	dc.b	'ST SQUAD - '
	dc.b	'STAX - '
	dc.b	'STEEL WINGS - '
	dc.b	'STEW - '
	dc.b	'ST-FORCE - '
	dc.b	'STONEHEAD - '
	dc.b	'STRANGER - '
	dc.b	'ST-SQUAD - '
	dc.b	'SUB HUMANS IN TURKEY - '
	dc.b	'SUNDOX - '
	dc.b	'SUPREMACY - '
	dc.b	'SYNC - '
	dc.b	'SYNERGY - '
	dc.b	'SYNTAX - '
	dc.b	'T.O.S. - '
	dc.b	'TDA - '
	dc.b	'TGE - '
	dc.b	'THALION - '
	dc.b	'THE ALIENS - '
	dc.b	'THE ALLIANCE - '
	dc.b	'THE ART MACHINE - '
	dc.b	'THE ASYLUM - '
	dc.b	'THE AVENGERS - '
	dc.b	'THE BARBARIANS - '
	dc.b	'THE BEAST - '
	dc.b	'THE BLACK BOXES - '
	dc.b	'THE BLACK CATS - '
	dc.b	'THE BLACK WIZARDS - '
	dc.b	'THE BLUE BOYS - '
	dc.b	'THE BRAINWASH COMPANY - '
	dc.b	'THE CAPED CRUSADER - '
	dc.b	'THE CAREBEARS - '
	dc.b	'THE CODERS - '
	dc.b	'THE CONCEPTORS - '
	dc.b	'THE COOLEST PARADISE - '
	dc.b	'THE CORPORATION - '
	dc.b	'THE CRAZY GUY',$27,'S - '
	dc.b	'THE CRUSADERS - '
	dc.b	'THE DEVIANT CORPORATION - '
	dc.b	'THE EXCEPTIONS - '
	dc.b	'THE FINAL SPACECODERS - '
	dc.b	'THE FIREHAWKS - '
	dc.b	'THE FIRM! - '
	dc.b	'THE FORMATION CREW - '
	dc.b	'THE FOX - '
	dc.b	'THE FRAGGLE',$27,'S - '
	dc.b	'THE GAMEMASTERS - '
	dc.b	'THE GERMS - '
	dc.b	'THE GIANTS - '
	dc.b	'THE HEAVY KILLERS - '
	dc.b	'THE HITCHHIKER - '
	dc.b	'THE IMMORTALS - '
	dc.b	'THE INCODERS - '
	dc.b	'THE INDEPENDANT - '
	dc.b	'THE ISLANDER - '
	dc.b	'THE LEGION - '
	dc.b	'THE LIGHT TEAM - '
	dc.b	'THE LOST BOYS - '
	dc.b	'THE MEGA FOUR - '
	dc.b	'THE MEGABUSTER - '
	dc.b	'THE MEGALAMERS - '
	dc.b	'THE NAUGHTY BYTES - '
	dc.b	'THE PHANTOM - '
	dc.b	'THE PIXEL TWINS - '
	dc.b	'THE POLTERGEISTS - '
	dc.b	'THE RAIDER BROTHERS - '
	dc.b	'THE REPLICANTS - '
	dc.b	'THE ROUND TABLE - '
	dc.b	'THE SCREEN KILLERS - '
	dc.b	'THE SIRIUS CYBERNETICS CORPORATION - '
	dc.b	'THE SKUNK - '
	dc.b	'THE STARFIRES - '
	dc.b	'THE STARKS - '
	dc.b	'THE SUPERVISORS - '
	dc.b	'THE SYNDICATE - '
	dc.b	'THE TECHNICAL KNOCK OUT - '
	dc.b	'THE TICK - '
	dc.b	'THE TWINS - '
	dc.b	'THE ULTIMATE - '
	dc.b	'THE UNIHAWK - '
	dc.b	'THE UNION - '
	dc.b	'THE UNTOUCHABLES - '
	dc.b	'THE VICIOUS BOYS - '
	dc.b	'THE VOYAGERS - '
	dc.b	'THE WATCHMEN - '
	dc.b	'THE WILD BOYS - '
	dc.b	'THE WIZARD - '
	dc.b	'THE WONDERSTUFF - '
	dc.b	'THE ZONE TROOPERS - '
	dc.b	'TMS - '
	dc.b	'TNT CREW - '
	dc.b	'TORMENT - '
	dc.b	'TOS CREW - '
	dc.b	'TOTAL VISION - '
	dc.b	'TROLL - '
	dc.b	'TRSI - '
	dc.b	'TSB - '
	dc.b	'TWINS - '
	dc.b	'TYPHOON - '
	dc.b	'UNDERGROUND - '
	dc.b	'UNIQUE - '
	dc.b	'UNIT 17 - '
	dc.b	'UNITED FORCES - '
	dc.b	'UNLIMITED MATRIX - '
	dc.b	'V8 - '
	dc.b	'VECTOR - '
	dc.b	'VISUALIZERS - '
	dc.b	'WARLOCK - '
	dc.b	'WHITE STATUS - '
	dc.b	'WILDFIRE - '
	dc.b	'WIZ - '
	dc.b	'WIZARD WIM - '
	dc.b	'XANTH FX - '
	dc.b	'XERCES - '
	dc.b	'X-STATIC - '
	dc.b	'X-TROLL - '
	dc.b	'XXX INTERNATIONAL - '
	dc.b	'YM ROCKER',$27,'Z - '
	dc.b	'ZEAL AND ZUUL. '
	dc.b	'                                      ',0,0
	even
PAS:
	dc.w	8
ASCII:
	incbin	"ASCII.DAT"
	even
SINUS:
	incbin	"SINUS.DAT"
	even
FONT:
	incbin	"FONT.DAT"
	even
	
*--------------------------------------------------------------------------

IMG_LOGO:	dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0000,$0005,$0000,$0000,$0000,$D000,$8000,$0000
		dc.w	$0000,$0005,$0000,$0000,$0000,$D000,$8000,$0000
		dc.w	$0000,$0005,$0000,$0000,$0000,$D000,$8000,$0000
		dc.w	$0000,$0005,$0000,$0000,$0000,$D000,$8000,$0000
		dc.w	$0000,$0005,$0000,$0000,$0000,$D000,$8000,$0000
		dc.w	$0000,$0005,$0000,$0000,$0000,$D000,$8000,$0000
		dc.w	$0000,$0005,$0000,$0000,$0000,$D000,$8000,$0000
		dc.w	$0000,$0005,$0000,$0000,$0000,$D000,$8000,$0000
		dc.w	$0000,$0005,$0000,$0000,$0000,$D000,$8000,$0000
		dc.w	$0000,$0005,$0000,$0000,$0000,$D000,$8000,$0000
		dc.w	$0000,$0002,$0001,$0000,$8000,$E000,$4000,$0000
		dc.w	$0000,$0002,$0001,$0000,$8000,$E000,$4000,$0000
		dc.w	$0000,$0002,$0001,$0000,$8000,$E000,$4000,$0000
		dc.w	$0000,$0002,$0001,$0000,$8000,$E000,$4000,$0000
		dc.w	$0000,$0002,$0001,$0000,$8000,$E000,$4000,$0000
		dc.w	$0000,$0002,$0001,$0000,$8000,$E000,$4000,$0000
		dc.w	$0000,$0002,$0001,$0000,$8000,$E000,$4000,$0000
		dc.w	$0000,$0002,$0001,$0000,$8000,$E000,$4000,$0000
		dc.w	$0000,$0002,$0001,$0000,$8000,$E000,$4000,$0000
		dc.w	$0000,$0002,$0001,$0000,$8000,$E000,$4000,$0000
		dc.w	$0001,$0007,$0002,$0000,$4000,$F000,$2000,$0000
		dc.w	$0001,$0007,$0002,$0000,$4000,$F000,$2000,$0000
		dc.w	$0001,$0007,$0002,$0000,$4000,$F000,$2000,$0000
		dc.w	$0001,$0007,$0002,$0000,$4000,$F000,$2000,$0000
		dc.w	$0001,$0007,$0002,$0000,$4000,$F000,$2000,$0000
		dc.w	$0001,$0007,$0002,$0000,$4000,$F000,$2000,$0000
		dc.w	$0001,$0007,$0002,$0000,$4000,$F000,$2000,$0000
		dc.w	$0001,$0007,$0002,$0000,$4000,$F000,$2000,$0000
		dc.w	$0001,$0007,$0002,$0000,$4000,$F000,$2000,$0000
		dc.w	$0001,$0007,$0002,$0000,$4000,$F000,$2000,$0000
		dc.w	$0002,$000B,$0004,$0000,$2000,$7800,$1000,$0000
		dc.w	$0002,$000B,$0004,$0000,$2000,$7800,$1000,$0000
		dc.w	$0002,$000B,$0004,$0000,$2000,$7800,$1000,$0000
		dc.w	$0002,$000B,$0004,$0000,$2000,$7800,$1000,$0000
		dc.w	$0002,$000B,$0004,$0000,$2000,$7800,$1000,$0000
		dc.w	$0002,$000B,$0004,$0000,$2000,$7800,$1000,$0000
		dc.w	$0002,$000B,$0004,$0000,$2000,$7800,$1000,$0000
		dc.w	$0002,$000B,$0004,$0000,$2000,$7800,$1000,$0000
		dc.w	$0002,$000B,$0004,$0000,$2000,$7800,$1000,$0000
		dc.w	$0002,$000B,$0004,$0000,$2000,$7800,$1000,$0000
		dc.w	$0004,$0016,$0008,$0000,$1800,$3C00,$0000,$8000
		dc.w	$0004,$0016,$0008,$0000,$1800,$3C00,$0000,$8000
		dc.w	$0004,$0016,$0008,$0000,$1800,$3C00,$0000,$8000
		dc.w	$0004,$0016,$0008,$0000,$1800,$3C00,$0000,$8000
		dc.w	$0004,$0016,$0008,$0000,$1800,$3C00,$0000,$8000
		dc.w	$0004,$0016,$0008,$0000,$1800,$3C00,$0000,$8000
		dc.w	$0004,$0016,$0008,$0000,$1800,$3C00,$0000,$8000
		dc.w	$0004,$0016,$0008,$0000,$1800,$3C00,$0000,$8000
		dc.w	$0004,$0016,$0008,$0000,$1800,$3C00,$0000,$8000
		dc.w	$0004,$0016,$0008,$0000,$1800,$3C00,$0000,$8000
		dc.w	$0008,$FFAC,$0010,$0001,$4800,$5EFF,$4400,$8000
		dc.w	$0008,$FFAC,$0010,$0001,$4800,$5EFF,$4400,$8000
		dc.w	$0008,$FFAC,$0010,$0001,$4800,$5EFF,$4400,$8000
		dc.w	$0008,$FFAC,$0010,$0001,$4800,$5EFF,$4400,$8000
		dc.w	$0008,$FFAC,$0010,$0001,$4800,$5EFF,$4400,$8000
		dc.w	$0008,$FFAC,$0010,$0001,$4800,$5EFF,$4400,$8000
		dc.w	$0008,$FFAC,$0010,$0001,$4800,$5EFF,$4400,$8000
		dc.w	$0008,$FFAC,$0010,$0001,$4800,$5EFF,$4400,$8000
		dc.w	$0008,$FFAC,$0010,$0001,$4800,$5EFF,$4400,$8000
		dc.w	$0008,$FFAC,$0010,$0001,$4800,$5EFF,$4400,$8000
		dc.w	$FF10,$FF78,$0021,$0002,$667F,$6F7F,$6000,$8000
		dc.w	$FF10,$FF78,$0021,$0002,$667F,$6F7F,$6000,$8000
		dc.w	$FF10,$FF78,$0021,$0002,$667F,$6F7F,$6000,$8000
		dc.w	$FF10,$FF78,$0021,$0002,$667F,$6F7F,$6000,$8000
		dc.w	$FF10,$FF78,$0021,$0002,$667F,$6F7F,$6000,$8000
		dc.w	$FF10,$FF78,$0021,$0002,$667F,$6F7F,$6000,$8000
		dc.w	$FF10,$FF78,$0021,$0002,$667F,$6F7F,$6000,$8000
		dc.w	$FF10,$FF78,$0021,$0002,$667F,$6F7F,$6000,$8000
		dc.w	$FF10,$FF78,$0021,$0002,$667F,$6F7F,$6000,$8000
		dc.w	$FF10,$FF78,$0021,$0002,$667F,$6F7F,$6000,$8000
		dc.w	$0020,$00B0,$FE43,$0004,$5300,$5780,$503F,$A000
		dc.w	$0020,$00B0,$FE43,$0004,$5300,$5780,$503F,$A000
		dc.w	$0020,$00B0,$FE43,$0004,$5300,$5780,$503F,$A000
		dc.w	$0020,$00B0,$FE43,$0004,$5300,$5780,$503F,$A000
		dc.w	$0020,$00B0,$FE43,$0004,$5300,$5780,$503F,$A000
		dc.w	$0020,$00B0,$FE43,$0004,$5300,$5780,$503F,$A000
		dc.w	$0020,$00B0,$FE43,$0004,$5300,$5780,$503F,$A000
		dc.w	$0020,$00B0,$FE43,$0004,$5300,$5780,$503F,$A000
		dc.w	$0020,$00B0,$FE43,$0004,$5300,$5780,$503F,$A000
		dc.w	$0020,$00B0,$FE43,$0004,$5300,$5780,$503F,$A000
		dc.w	$0040,$FDE0,$FC80,$000F,$7980,$7BDF,$781F,$8000
		dc.w	$0040,$FDE0,$FC80,$000F,$7980,$7BDF,$781F,$8000
		dc.w	$0040,$FDE0,$FC80,$000F,$7980,$7BDF,$781F,$8000
		dc.w	$0040,$FDE0,$FC80,$000F,$7980,$7BDF,$781F,$8000
		dc.w	$0040,$FDE0,$FC80,$000F,$7980,$7BDF,$781F,$8000
		dc.w	$0040,$FDE0,$FC80,$000F,$7980,$7BDF,$781F,$8000
		dc.w	$0040,$FDE0,$FC80,$000F,$7980,$7BDF,$781F,$8000
		dc.w	$0040,$FDE0,$FC80,$000F,$7980,$7BDF,$781F,$8000
		dc.w	$0040,$FDE0,$FC80,$000F,$7980,$7BDF,$781F,$8000
		dc.w	$0040,$FDE0,$FC80,$000F,$7980,$7BDF,$781F,$8000
		dc.w	$0027,$00F7,$FE47,$0000,$8300,$F780,$803F,$7000
		dc.w	$0027,$00F7,$FE47,$0000,$8300,$F780,$803F,$7000
		dc.w	$0027,$00F7,$FE47,$0000,$8300,$F780,$803F,$7000
		dc.w	$0027,$00F7,$FE47,$0000,$8300,$F780,$803F,$7000
		dc.w	$0027,$00F7,$FE47,$0000,$8300,$F780,$803F,$7000
		dc.w	$0027,$00F7,$FE47,$0000,$8300,$F780,$803F,$7000
		dc.w	$0027,$00F7,$FE47,$0000,$8300,$F780,$803F,$7000
		dc.w	$0027,$00F7,$FE47,$0000,$8300,$F780,$803F,$7000
		dc.w	$0027,$00F7,$FE47,$0000,$8300,$F780,$803F,$7000
		dc.w	$0027,$00F7,$FE47,$0000,$8300,$F780,$803F,$7000
		dc.w	$FF12,$FF7A,$0022,$0001,$867F,$EF7F,$8000,$6000
		dc.w	$FF12,$FF7A,$0022,$0001,$867F,$EF7F,$8000,$6000
		dc.w	$FF12,$FF7A,$0022,$0001,$867F,$EF7F,$8000,$6000
		dc.w	$FF12,$FF7A,$0022,$0001,$867F,$EF7F,$8000,$6000
		dc.w	$FF12,$FF7A,$0022,$0001,$867F,$EF7F,$8000,$6000
		dc.w	$FF12,$FF7A,$0022,$0001,$867F,$EF7F,$8000,$6000
		dc.w	$FF12,$FF7A,$0022,$0001,$867F,$EF7F,$8000,$6000
		dc.w	$FF12,$FF7A,$0022,$0001,$867F,$EF7F,$8000,$6000
		dc.w	$FF12,$FF7A,$0022,$0001,$867F,$EF7F,$8000,$6000
		dc.w	$FF12,$FF7A,$0022,$0001,$867F,$EF7F,$8000,$6000
		dc.w	$0009,$FFBD,$0011,$0000,$8C00,$DEFF,$8000,$4000
		dc.w	$0009,$FFBD,$0011,$0000,$8C00,$DEFF,$8000,$4000
		dc.w	$0009,$FFBD,$0011,$0000,$8C00,$DEFF,$8000,$4000
		dc.w	$0009,$FFBD,$0011,$0000,$8C00,$DEFF,$8000,$4000
		dc.w	$0009,$FFBD,$0011,$0000,$8C00,$DEFF,$8000,$4000
		dc.w	$0009,$FFBD,$0011,$0000,$8C00,$DEFF,$8000,$4000
		dc.w	$0009,$FFBD,$0011,$0000,$8C00,$DEFF,$8000,$4000
		dc.w	$0009,$FFBD,$0011,$0000,$8C00,$DEFF,$8000,$4000
		dc.w	$0009,$FFBD,$0011,$0000,$8C00,$DEFF,$8000,$4000
		dc.w	$0009,$FFBD,$0011,$0000,$8C00,$DEFF,$8000,$4000
		dc.w	$000C,$001E,$0000,$0000,$9800,$BC00,$8000,$0000
		dc.w	$000C,$001E,$0000,$0000,$9800,$BC00,$8000,$0000
		dc.w	$000C,$001E,$0000,$0000,$9800,$BC00,$8000,$0000
		dc.w	$000C,$001E,$0000,$0000,$9800,$BC00,$8000,$0000
		dc.w	$000C,$001E,$0000,$0000,$9800,$BC00,$8000,$0000
		dc.w	$000C,$001E,$0000,$0000,$9800,$BC00,$8000,$0000
		dc.w	$000C,$001E,$0000,$0000,$9800,$BC00,$8000,$0000
		dc.w	$000C,$001E,$0000,$0000,$9800,$BC00,$8000,$0000
		dc.w	$000C,$001E,$0000,$0000,$9800,$BC00,$8000,$0000
		dc.w	$000C,$001E,$0000,$0000,$9800,$BC00,$8000,$0000
		dc.w	$0002,$000F,$0004,$0000,$3000,$7800,$0000,$0000
		dc.w	$0002,$000F,$0004,$0000,$3000,$7800,$0000,$0000
		dc.w	$0002,$000F,$0004,$0000,$3000,$7800,$0000,$0000
		dc.w	$0002,$000F,$0004,$0000,$3000,$7800,$0000,$0000
		dc.w	$0002,$000F,$0004,$0000,$3000,$7800,$0000,$0000
		dc.w	$0002,$000F,$0004,$0000,$3000,$7800,$0000,$0000
		dc.w	$0002,$000F,$0004,$0000,$3000,$7800,$0000,$0000
		dc.w	$0002,$000F,$0004,$0000,$3000,$7800,$0000,$0000
		dc.w	$0002,$000F,$0004,$0000,$3000,$7800,$0000,$0000
		dc.w	$0002,$000F,$0004,$0000,$3000,$7800,$0000,$0000
		dc.w	$0003,$0007,$0000,$0000,$6000,$F000,$0000,$0000
		dc.w	$0003,$0007,$0000,$0000,$6000,$F000,$0000,$0000
		dc.w	$0003,$0007,$0000,$0000,$6000,$F000,$0000,$0000
		dc.w	$0003,$0007,$0000,$0000,$6000,$F000,$0000,$0000
		dc.w	$0003,$0007,$0000,$0000,$6000,$F000,$0000,$0000
		dc.w	$0003,$0007,$0000,$0000,$6000,$F000,$0000,$0000
		dc.w	$0003,$0007,$0000,$0000,$6000,$F000,$0000,$0000
		dc.w	$0003,$0007,$0000,$0000,$6000,$F000,$0000,$0000
		dc.w	$0003,$0007,$0000,$0000,$6000,$F000,$0000,$0000
		dc.w	$0003,$0007,$0000,$0000,$6000,$F000,$0000,$0000
		dc.w	$0001,$0003,$0000,$0000,$C000,$E000,$0000,$0000
		dc.w	$0001,$0003,$0000,$0000,$C000,$E000,$0000,$0000
		dc.w	$0001,$0003,$0000,$0000,$C000,$E000,$0000,$0000
		dc.w	$0001,$0003,$0000,$0000,$C000,$E000,$0000,$0000
		dc.w	$0001,$0003,$0000,$0000,$C000,$E000,$0000,$0000
		dc.w	$0001,$0003,$0000,$0000,$C000,$E000,$0000,$0000
		dc.w	$0001,$0003,$0000,$0000,$C000,$E000,$0000,$0000
		dc.w	$0001,$0003,$0000,$0000,$C000,$E000,$0000,$0000
		dc.w	$0001,$0003,$0000,$0000,$C000,$E000,$0000,$0000
		dc.w	$0001,$0003,$0000,$0000,$C000,$E000,$0000,$0000
		dc.w	$0000,$0005,$0000,$0000,$8000,$D000,$0000,$0000
		dc.w	$0000,$0005,$0000,$0000,$8000,$D000,$0000,$0000
		dc.w	$0000,$0005,$0000,$0000,$8000,$D000,$0000,$0000
		dc.w	$0000,$0005,$0000,$0000,$8000,$D000,$0000,$0000
		dc.w	$0000,$0005,$0000,$0000,$8000,$D000,$0000,$0000
		dc.w	$0000,$0005,$0000,$0000,$8000,$D000,$0000,$0000
		dc.w	$0000,$0005,$0000,$0000,$8000,$D000,$0000,$0000
		dc.w	$0000,$0005,$0000,$0000,$8000,$D000,$0000,$0000
		dc.w	$0000,$0005,$0000,$0000,$8000,$D000,$0000,$0000
		dc.w	$0000,$0005,$0000,$0000,$8000,$D000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0000,$0000,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$1000,$1000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0001,$0001,$0000,$0001,$2000,$B000,$C000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0003,$0000,$0003,$0003,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FE1F,$0000,$FE1F,$FE1F,$FF80,$0000,$FF80,$FF80
		dc.w	$03FF,$0200,$01FF,$03FF,$EFFF,$0000,$EFFF,$EFFF
		dc.w	$8002,$8006,$0001,$8000,$47FF,$C400,$83FF,$47FF
		dc.w	$FFEF,$0000,$FFEF,$FFEF,$FC00,$0400,$F800,$FC00
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FEFF,$0000,$FEFF,$FE80
		dc.w	$FFFE,$0002,$FFFC,$0002,$200F,$B008,$C007,$000F
		dc.w	$FFBF,$0000,$FFBF,$FFA0,$FE00,$0200,$FC00,$0200
		dc.w	$0003,$0002,$0001,$0003,$FFEF,$0000,$FFEF,$FFEF
		dc.w	$FF82,$0086,$FF01,$FF80,$2000,$B000,$C000,$0000
		dc.w	$0002,$0000,$0003,$0002,$0000,$0000,$FFFF,$0000
		dc.w	$0310,$0100,$FE1F,$0110,$0080,$0000,$FF80,$0000
		dc.w	$1E00,$1000,$0FFF,$1E00,$2800,$0000,$EFFF,$0800
		dc.w	$F003,$1007,$E000,$F001,$3C00,$2000,$1FFF,$3C00
		dc.w	$0038,$0010,$FFEF,$0018,$0780,$0080,$FF00,$0780
		dc.w	$8000,$0000,$FFFF,$8000,$02BF,$0000,$FEFF,$00BF
		dc.w	$FFFE,$0000,$FFFE,$FFFC,$2078,$B040,$C03F,$0078
		dc.w	$00AF,$0000,$FFBF,$002F,$FFC0,$0040,$FF80,$FC40
		dc.w	$001E,$0010,$000F,$001E,$0028,$0000,$FFEF,$0008
		dc.w	$00F0,$0010,$FFE3,$00F2,$2000,$B000,$C000,$0000
		dc.w	$0002,$0000,$0003,$0002,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FF17,$0000,$FF1F,$FE17,$FF80,$0000,$FF80,$FF00
		dc.w	$71FF,$4000,$3FFF,$71FF,$EBFF,$0000,$EFFF,$CBFF
		dc.w	$1C00,$0404,$F802,$1C02,$E3FF,$8000,$7FFF,$E3FF
		dc.w	$FFF5,$0000,$FFF7,$FFE1,$F8E0,$0020,$FFC0,$F8E0
		dc.w	$BFFF,$0000,$FFFF,$BFFF,$FEBF,$0000,$FEFF,$FCBF
		dc.w	$FFFE,$0000,$FFFE,$FFFC,$21C7,$B100,$C0FF,$01C7
		dc.w	$FFAF,$0000,$FFBF,$FF2F,$FFF0,$0010,$FFE0,$FF90
		dc.w	$0071,$0040,$003F,$0071,$FFEB,$0000,$FFEF,$FFCB
		dc.w	$FF1D,$0005,$FFF8,$FF1D,$2000,$B000,$C000,$0000
		dc.w	$0002,$0000,$0003,$0002,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$FF97,$0080,$FF1F,$FE97,$FF80,$0000,$FF80,$FF00
		dc.w	$CFFF,$8000,$7FFF,$CFFF,$EBFF,$0000,$EFFF,$CBFF
		dc.w	$E601,$0205,$FC00,$E601,$9FFF,$0000,$FFFF,$9FFF
		dc.w	$FFFD,$0008,$FFF7,$FFE9,$FF30,$0010,$FFE0,$FF30
		dc.w	$BFFF,$0000,$FFFF,$BFFF,$FEBF,$0000,$FEFF,$FCBF
		dc.w	$3FFE,$0000,$3FFE,$3FFC,$233F,$B200,$C1FF,$033F
		dc.w	$FFAF,$0000,$FFBF,$FF2F,$CFF8,$0008,$CFF0,$CFE8
		dc.w	$00CF,$0080,$007F,$00CF,$FFEB,$0000,$FFEF,$FFCB
		dc.w	$FFE6,$0002,$FFFC,$FFE6,$2000,$B000,$4000,$0000
		dc.w	$0002,$0000,$0003,$0002,$F9FF,$0000,$F9FF,$F9FF
		dc.w	$CF97,$0000,$CF9F,$CF17,$CF81,$0001,$CF80,$CF01
		dc.w	$BF9F,$0000,$FF9F,$BF9F,$EBF3,$0000,$EFF3,$CBF3
		dc.w	$FB01,$0100,$FE05,$FB05,$7E7F,$0000,$FE7F,$7E7F
		dc.w	$FCFA,$0000,$FCFB,$FCF0,$FFD0,$0000,$FFF0,$FFD0
		dc.w	$BFE7,$0000,$FFE7,$BFE7,$FEBE,$0000,$FEFE,$FCBE
		dc.w	$DFFE,$8000,$DFFE,$5FFC,$26FE,$A400,$D3FE,$16FE
		dc.w	$7FAF,$0000,$7FBF,$7F2F,$B7FC,$2004,$B7F8,$97F4
		dc.w	$01BF,$0100,$00FF,$01BF,$9FEB,$0000,$9FEF,$9FCB
		dc.w	$F3FB,$0001,$F3FE,$F3FB,$6000,$7000,$0000,$4000
		dc.w	$0002,$0000,$0003,$0002,$F6FF,$0400,$F6FF,$F2FF
		dc.w	$B7D7,$2040,$B79F,$9757,$B783,$2002,$B781,$9703
		dc.w	$7F6F,$0040,$FF6F,$7F2F,$EBED,$0008,$EFED,$CBE5
		dc.w	$FD83,$0082,$FF01,$FC83,$7DBF,$0100,$FDBF,$7CBF
		dc.w	$FB7E,$0204,$FB7B,$F974,$FFD8,$0008,$FFF0,$FFD8
		dc.w	$BFDB,$0010,$FFDB,$BFCB,$FEBD,$0001,$FEFD,$FCBC
		dc.w	$6FFE,$4000,$EFFE,$0FFC,$2DFD,$A801,$C7FD,$0DFC
		dc.w	$BFAF,$0000,$BFBF,$BF2F,$5BFE,$5002,$7BFC,$03FA
		dc.w	$037F,$0200,$01FF,$037F,$6FEB,$4000,$6FEF,$2FCB
		dc.w	$EDFD,$0800,$EDFF,$E5FC,$A000,$B000,$0000,$8000
		dc.w	$0002,$0000,$0003,$0002,$EB7F,$0A00,$EF7F,$E07F
		dc.w	$5BDB,$5000,$7BDF,$039B,$5B82,$5000,$7B83,$0302
		dc.w	$FEB7,$00A0,$FEF7,$FE07,$EBD6,$0014,$EFDE,$CBC0
		dc.w	$FE82,$0000,$FF83,$FE02,$FADF,$0280,$FBDF,$F81F
		dc.w	$F5B9,$0500,$F7B9,$F038,$7FF8,$0000,$FFF8,$7FF8
		dc.w	$BFAD,$0028,$FFBD,$BF81,$FEBD,$0000,$FEFD,$FCBD
		dc.w	$E7FE,$8800,$EFFE,$4FFC,$0BFA,$8002,$EFFB,$2BF8
		dc.w	$DFAF,$8000,$DFBF,$1F2F,$79FE,$2200,$7BFE,$53FC
		dc.w	$02FE,$0000,$03FE,$02FE,$B7EB,$A000,$F7EF,$07CB
		dc.w	$D6FE,$1400,$DEFF,$C0FE,$8000,$1000,$A000,$2000
		dc.w	$0003,$0000,$0003,$0003,$6F3F,$0440,$EF7F,$6A7F
		dc.w	$79FB,$2220,$7BDF,$53BB,$7986,$2204,$7B83,$5306
		dc.w	$FEF3,$0044,$FEF7,$FEA7,$EBDE,$0008,$EFDE,$CBD4
		dc.w	$7FC2,$8040,$FF83,$FF42,$FBCF,$0110,$FBDF,$FA9F
		dc.w	$F79F,$0222,$F7BD,$F53A,$7FF8,$0000,$FFF8,$7FF8
		dc.w	$BFBC,$0011,$FFBD,$BFA9,$FEBE,$0000,$FEFE,$FCBE
		dc.w	$C7FE,$1800,$DFFE,$1FFC,$1BFB,$9001,$CFFB,$1BFA
		dc.w	$CFAF,$1000,$DFBF,$9F2F,$B1FF,$0601,$B7FE,$87FD
		dc.w	$06FE,$0400,$03FE,$06FE,$F3EB,$4400,$F7EF,$A7CB
		dc.w	$DE7F,$0880,$DEFF,$D4FF,$C000,$5000,$8000,$4000
		dc.w	$0003,$0000,$0003,$0003,$763F,$00C0,$F6FF,$70FF
		dc.w	$B1ED,$0600,$B7EF,$87C5,$B185,$0600,$B787,$8705
		dc.w	$FF63,$000C,$FF6F,$FF0F,$EBEC,$0001,$EFED,$CBE1
		dc.w	$7F43,$8000,$FFC3,$FF03,$FD8F,$0030,$FDBF,$FC3F
		dc.w	$FB1E,$0060,$FB7E,$F87C,$FFF8,$0000,$FFF8,$7FF8
		dc.w	$BFD8,$0003,$FFDB,$BFC3,$FEBF,$0000,$FEFF,$FCBF
		dc.w	$0FFE,$3000,$3FFE,$3FFC,$17FD,$8000,$DFFD,$17FC
		dc.w	$8FAF,$3000,$BFBF,$3F2F,$C3FF,$0C00,$CFFF,$CFFE
		dc.w	$05FF,$0000,$07FF,$05FF,$63EB,$0C00,$6FEF,$0FCB
		dc.w	$EC7F,$0180,$EDFF,$E1FF,$40E0,$10E0,$C000,$0000
		dc.w	$0003,$0002,$0001,$0002,$B87F,$0180,$F9FF,$B9FF
		dc.w	$C3FD,$0C10,$CFEF,$CFD5,$C385,$0C00,$CF87,$CF05
		dc.w	$FF87,$0018,$FF9F,$FF9F,$EBF0,$0003,$EFF3,$CBF3
		dc.w	$FFC3,$0002,$FFC1,$FF82,$FE1F,$0060,$FE7F,$FE7F
		dc.w	$FC3F,$00C1,$FCFE,$FCFD,$BFF8,$0008,$FFF0,$3FE8
		dc.w	$BFE1,$0006,$FFE7,$BFE7,$FEBF,$0000,$FEFF,$FCBF
		dc.w	$9FFE,$6000,$FFFE,$FFFC,$57FE,$C000,$9FFE,$57FE
		dc.w	$1FAF,$6000,$7FBF,$7F2F,$E7FF,$1800,$FFFF,$FFFE
		dc.w	$05FF,$0000,$07FF,$05FF,$87EB,$1800,$9FEF,$9FCB
		dc.w	$F0FF,$0300,$F3FF,$F3FF,$C110,$0100,$D000,$9010
		dc.w	$0001,$0000,$0005,$0004,$BCFF,$0300,$FFFF,$BFFF
		dc.w	$E7F5,$1800,$FFF7,$FFE1,$E78D,$1808,$FF87,$FF0D
		dc.w	$FFCF,$0030,$FFFF,$FFFF,$EBF9,$0006,$EFFF,$CBFF
		dc.w	$FFE1,$0020,$FFC5,$FFA4,$7F3F,$00C0,$FFFF,$7FFF
		dc.w	$FE7F,$0180,$FFFF,$FFFE,$7FF0,$0000,$7FF0,$3FE0
		dc.w	$BFF3,$000C,$FFFF,$BFFF,$FEBF,$0000,$FEFF,$FCBF
		dc.w	$FFFE,$0000,$FFFE,$FFFC,$37FF,$A000,$9FFF,$37FF
		dc.w	$3FAF,$C000,$FFBF,$FF2F,$FFFF,$0000,$FFFF,$FFFE
		dc.w	$8DFF,$8800,$07FF,$8DFF,$CFEB,$3000,$FFEF,$FFCB
		dc.w	$F9FF,$0600,$FFFF,$FFFF,$E248,$22E0,$C000,$A008
		dc.w	$0003,$0001,$0002,$0003,$DFFF,$0000,$FFFF,$5FFF
		dc.w	$FFFD,$0008,$FFF7,$FFE9,$FF8B,$0000,$FF8F,$FF0B
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$EBFF,$0000,$EFFF,$CBFF
		dc.w	$FFE1,$0005,$FFE0,$FFC1,$FFFF,$0000,$FFFF,$7FFF
		dc.w	$FFFF,$0000,$FFFF,$FFFE,$DFF0,$8010,$7FE0,$9FD0
		dc.w	$BFFF,$0000,$FFFF,$BFFF,$FEBF,$0000,$FEFF,$FCBF
		dc.w	$FFFE,$0000,$FFFE,$FFFC,$2FFF,$8000,$BFFF,$2FFF
		dc.w	$FFAF,$0000,$FFBF,$FF2F,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$8BFF,$0000,$8FFF,$0BFF,$FFEB,$0000,$FFEF,$FFCB
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$E2A8,$02A0,$E000,$C008
		dc.w	$0002,$0000,$0002,$0002,$DFFF,$0000,$FFFF,$5FFF
		dc.w	$FFFB,$0000,$FFFB,$FFF1,$FF8B,$0000,$FF8F,$FF0B
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$EBFF,$0000,$EFFF,$CBFF
		dc.w	$FFE0,$0004,$FFE2,$FFC2,$BFFF,$0000,$FFFF,$3FFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$BFE0,$0000,$BFE0,$1FC0
		dc.w	$BFFF,$0000,$FFFF,$BFFF,$FEBF,$0000,$FEFF,$FCBF
		dc.w	$FFFE,$0000,$FFFE,$FFFC,$2FFF,$8000,$BFFF,$2FFF
		dc.w	$FFAF,$0000,$FFBF,$FF2F,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$8BFF,$0000,$8FFF,$0BFF,$FFEB,$0000,$FFEF,$FFCB
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$E2E0,$00E8,$E008,$C200
		dc.w	$0003,$0000,$0003,$0002,$DFFF,$8000,$7FFF,$9FFF
		dc.w	$FFFE,$0004,$FFFB,$FFF4,$FF8B,$0000,$FF8F,$FF0B
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$EBFF,$0000,$EFFF,$CBFF
		dc.w	$FFE2,$0006,$FFE0,$FFC0,$FFFF,$8000,$7FFF,$BFFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$EFE0,$4020,$BFC0,$4FA0
		dc.w	$BFFF,$0000,$FFFF,$BFFF,$FEBF,$0000,$FEFF,$FCBF
		dc.w	$FFFE,$0000,$FFFE,$FFFC,$2FFF,$0000,$3FFF,$2FFF
		dc.w	$FFAF,$0000,$FFBF,$FF2F,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$8BFF,$0000,$8FFF,$0BFF,$FFEB,$0000,$FFEF,$FFCB
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$E2A0,$00A8,$E008,$C200
		dc.w	$0003,$0000,$0003,$0002,$5FFF,$0000,$7FFF,$1FFF
		dc.w	$FFFD,$0000,$FFFD,$FFF8,$FF8B,$0000,$FF8F,$FF0B
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$EBFF,$0000,$EFFF,$CBFF
		dc.w	$FFE2,$0006,$FFE0,$FFC0,$5FFF,$0000,$7FFF,$1FFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$DFC0,$0000,$DFC0,$8F80
		dc.w	$BFFF,$0000,$FFFF,$BFFF,$FEBF,$0000,$FEFF,$FCBF
		dc.w	$FFFE,$0000,$FFFE,$FFFC,$2FFF,$8000,$3FFF,$2FFF
		dc.w	$FFAF,$0000,$FFBF,$FF2F,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$8BFF,$0000,$8FFF,$0BFF,$FFEB,$0000,$FFEF,$FFCB
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$E100,$00B0,$E010,$C100
		dc.w	$0003,$0000,$0003,$0003,$FFFF,$4000,$BFFF,$5FFF
		dc.w	$FFFF,$0002,$FFFD,$FFFA,$7F8B,$0000,$FF8F,$7F0B
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$EBFF,$0000,$EFFF,$CBFF
		dc.w	$FFE0,$0005,$FFE0,$FFC0,$7FFF,$4000,$3FFF,$5FFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$F7C0,$2040,$DF80,$A740
		dc.w	$BFFF,$0000,$FFFF,$BFFF,$FEBF,$0000,$FEFF,$FCBF
		dc.w	$FFFE,$0000,$FFFE,$FFFC,$2FFF,$8000,$BFFF,$2FFF
		dc.w	$FFAF,$0000,$FFBF,$FF2F,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$8BFF,$0000,$8FFF,$0BFF,$FFEB,$0000,$FFEF,$FFCB
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$E080,$0060,$E060,$C080
		dc.w	$0003,$0000,$0003,$0003,$AFFF,$0000,$BFFF,$0FFF
		dc.w	$FFFE,$0000,$FFFE,$FFFC,$FF8B,$0000,$FF8F,$7F0B
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$EBFF,$0000,$EFFF,$CBFF
		dc.w	$FFE0,$0002,$FFE1,$FFC0,$2FFF,$0000,$BFFF,$8FFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$EF80,$0000,$EF80,$C700
		dc.w	$BFFF,$0000,$FFFF,$BFFF,$FEBF,$0000,$FEFF,$FCBF
		dc.w	$FFFE,$0000,$FFFE,$FFFC,$AFFF,$8000,$3FFF,$2FFF
		dc.w	$FFAF,$0000,$FFBF,$FF2F,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$8BFF,$0000,$8FFF,$0BFF,$FFEB,$0000,$FFEF,$FFCB
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$E000,$0000,$E000,$C000
		dc.w	$0002,$0000,$0003,$0002,$FFFF,$2000,$DFFF,$AFFF
		dc.w	$FFFF,$0001,$FFFE,$FFFD,$BF8B,$0000,$FF8F,$3F0B
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$EBFF,$0000,$EFFF,$CBFF
		dc.w	$FFE1,$0007,$FFE2,$FFC0,$3FFF,$A000,$1FFF,$2FFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FB80,$1080,$EF00,$D280
		dc.w	$BFFF,$0000,$FFFF,$BFFF,$FEBF,$0000,$FEFF,$FCBF
		dc.w	$FFFE,$0000,$FFFE,$FFFC,$2FFF,$8000,$3FFF,$2FFF
		dc.w	$FFAF,$0000,$FFBF,$FF2F,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$8BFF,$0000,$8FFF,$0BFF,$FFEB,$0000,$FFEF,$FFCB
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$E000,$0000,$E000,$C000
		dc.w	$0002,$0008,$0003,$0002,$D7FF,$0000,$DFFF,$87FF
		dc.w	$FFFF,$0000,$FFFF,$FFFE,$7F8B,$0000,$7F8F,$3F0B
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$EBFF,$0000,$EFFF,$CBFF
		dc.w	$FFE2,$000B,$FFE4,$FFC0,$17FF,$0000,$5FFF,$47FF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$F700,$0000,$F700,$E200
		dc.w	$BFFF,$0000,$FFFF,$BFFF,$FEBF,$0000,$FEFF,$FCBF
		dc.w	$FFFE,$0000,$FFFE,$FFFC,$2FFF,$0000,$3FFF,$2FFF
		dc.w	$FFAF,$0000,$FFBF,$FF2F,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$8BFF,$0000,$8FFF,$0BFF,$FFEB,$0000,$FFEF,$FFCB
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$E000,$0800,$E000,$C000
		dc.w	$0002,$0010,$000B,$0002,$FFFF,$1000,$EFFF,$D7FF
		dc.w	$FFFF,$0000,$FFFF,$FFFE,$DF8B,$8000,$7F8F,$9F0B
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$EBFF,$0000,$EFFF,$CBFF
		dc.w	$FFE4,$0006,$FFE8,$FFC0,$1FFF,$1000,$0FFF,$97FF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FD00,$0900,$F600,$E900
		dc.w	$BFFF,$0000,$FFFF,$BFFF,$FEBF,$0000,$FEFF,$FCBF
		dc.w	$FFFE,$0000,$FFFE,$FFFC,$2FFF,$0000,$3FFF,$AFFF
		dc.w	$FFAF,$0000,$FFBF,$FF2F,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$8BFF,$0000,$8FFF,$0BFF,$FFEB,$0000,$FFEF,$FFCB
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$E800,$0C00,$E000,$C000
		dc.w	$000A,$FFA8,$0013,$0002,$EBFF,$0000,$EFFF,$C3FF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$BF8B,$0020,$BF8F,$1F0B
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$EBFF,$0000,$EFFF,$CBFF
		dc.w	$FFE8,$000C,$FFE0,$FFC1,$4BFF,$4000,$4FFF,$83FF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FA00,$007E,$FA80,$F080
		dc.w	$BFFF,$0000,$FFFF,$BFFF,$FEBF,$0000,$FEFF,$FCBF
		dc.w	$FFFE,$0000,$FFFE,$FFFC,$2FFF,$0000,$3FFF,$AFFF
		dc.w	$FFAF,$0000,$FFBF,$FF2F,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$8BFF,$2000,$8FFF,$0BFF,$FFEB,$0000,$FFEF,$FFCB
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$E800,$0EFF,$E400,$C000
		dc.w	$FF12,$FF78,$0023,$0002,$FFFF,$0800,$F7FF,$EBFF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$EFAB,$4020,$BF8F,$4F0B
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$EBFF,$0000,$EFFF,$CBFF
		dc.w	$FFE0,$0008,$FFE1,$FFC2,$6FDF,$6820,$67FF,$8B3F
		dc.w	$F77F,$0880,$FFFF,$F8FF,$FE7E,$067E,$F800,$F600
		dc.w	$BDBF,$0240,$FFFF,$BE7F,$B680,$4800,$FEFF,$CC80
		dc.w	$0002,$0000,$FFFE,$0000,$2FFF,$0000,$3FFF,$AFFF
		dc.w	$FFA0,$0000,$FFBF,$FF20,$0000,$0000,$FFFF,$0000
		dc.w	$ABFF,$2000,$8FFF,$0BFF,$FFEB,$0000,$FFEF,$FFCB
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$E67F,$0F7F,$E000,$C000
		dc.w	$0022,$00B0,$FE43,$0002,$F5FF,$0000,$F7FF,$E1FF
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$DF8B,$0000,$DFAF,$8F0B
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$EBFF,$0000,$EFFF,$CBFF
		dc.w	$FFE0,$0000,$FFE3,$FFC4,$55FB,$5004,$47FF,$B1FC
		dc.w	$BFED,$4012,$FFFF,$7FF3,$FC00,$0080,$FD3E,$F900
		dc.w	$BFFF,$0000,$FFFF,$BFFF,$FEFF,$0000,$FEFF,$FCFF
		dc.w	$FFFE,$0000,$FFFE,$FFFE,$2FFF,$0000,$3FFF,$AFFF
		dc.w	$FFBF,$0000,$FFBF,$FF3F,$FFFF,$0000,$FFFF,$FFFF
		dc.w	$8BFF,$0000,$AFFF,$8BFF,$FFE8,$0000,$FFEF,$FFC8
		dc.w	$003F,$0000,$FFFF,$003F,$E300,$0780,$E03F,$C000
		dc.w	$0042,$FDE0,$FC83,$000A,$FFFF,$0400,$FBFF,$F5FF
		dc.w	$FF77,$0088,$FFFF,$FF8F,$F78A,$2001,$DF8F,$A70B
		dc.w	$DF7B,$2084,$FFFF,$3F87,$E9BF,$0240,$EFFF,$CA7F
		dc.w	$FB60,$0480,$FFE0,$FCCF,$6FFF,$6C00,$63FF,$8DFF
		dc.w	$FFF7,$0008,$FFFF,$FFF8,$7E80,$82DE,$FC1E,$FA00
		dc.w	$BFF7,$0008,$FFFF,$BFF8,$7E00,$8000,$FE00,$FC00
		dc.w	$0001,$0001,$0000,$0001,$2FFF,$0000,$3FFF,$AFFF
		dc.w	$FF80,$0000,$FF80,$FF00,$0000,$0000,$0000,$0000
		dc.w	$0ADF,$6120,$2FFF,$0B3C,$FFEF,$0000,$FFEF,$000F
		dc.w	$FFBB,$0004,$FFFF,$FFBC,$6980,$8BDF,$E81F,$C000
		dc.w	$0022,$00F0,$FE43,$0002,$FABB,$0044,$FBFF,$F0C7
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$EF8B,$0000,$EFAF,$C70B
		dc.w	$FFFB,$0004,$FFFF,$FFFC,$6BB6,$8049,$EFFF,$CBCF
		dc.w	$DFE7,$2007,$FFE7,$3FC0,$82FF,$C000,$ABFF,$60FF
		dc.w	$FFBF,$0040,$FFFF,$FF7F,$FE00,$0000,$FEBE,$FC80
		dc.w	$ADFF,$1200,$FFFF,$B3FF,$FE00,$0080,$FE3F,$FC00
		dc.w	$0027,$00F7,$FE47,$0000,$AFFF,$8000,$BFFF,$2FFF
		dc.w	$FFA7,$0037,$FF87,$FF00,$8300,$F780,$803F,$7000
		dc.w	$0BFE,$0000,$EFFE,$0BFC,$0010,$0010,$0000,$0010
		dc.w	$009F,$0020,$00FF,$00BF,$E300,$0780,$E03F,$C000
		dc.w	$FF12,$FF78,$0023,$0002,$FFFF,$0200,$FDFF,$FAFF
		dc.w	$6FF7,$9008,$FFFF,$9FF8,$7BAB,$9020,$EF8F,$D30B
		dc.w	$EDFF,$1200,$FFFF,$F3FF,$EBFF,$0000,$EFFF,$CBFF
		dc.w	$FFE2,$000A,$FFE2,$FFC1,$97BE,$D241,$8DFF,$567F
		dc.w	$F7DF,$0820,$FFFF,$0F3F,$FF7E,$017E,$FE00,$FD00
		dc.w	$BFBD,$0042,$FFFF,$A1C6,$EE7F,$107F,$FE00,$1C00
		dc.w	$FF12,$FF7A,$0022,$0001,$A5FF,$8A00,$BFFF,$2BFF
		dc.w	$FF92,$003A,$FFA2,$FF01,$867F,$EF7F,$8000,$6000
		dc.w	$EBEE,$E010,$0FFE,$0BF0,$0000,$0000,$0010,$0010
		dc.w	$00BF,$0000,$00FF,$00BF,$E67F,$0F7F,$E000,$C000
		dc.w	$000A,$FFB8,$0013,$0002,$B57F,$4800,$FDFF,$C87F
		dc.w	$F77F,$0880,$FFFF,$F8FF,$F789,$0022,$F78F,$E30A
		dc.w	$DFFB,$2004,$FFFF,$3FFC,$ABFF,$4000,$EFFF,$4BFF
		dc.w	$FFE9,$000D,$FFE1,$FFC0,$8D7F,$8000,$DDFF,$487F
		dc.w	$F6FF,$0900,$FFFF,$F9FF,$EF00,$103E,$FF40,$F240
		dc.w	$B4FE,$0B01,$FFFF,$AB07,$DE00,$20FF,$FE00,$3C00
		dc.w	$0009,$FFBD,$0011,$0000,$AEEF,$8110,$BFFF,$2F1F
		dc.w	$6F89,$903D,$FF91,$9F00,$8C00,$DEFF,$8000,$4000
		dc.w	$09DF,$E220,$0FFF,$0A3C,$FFEF,$0000,$FFEF,$000F
		dc.w	$FFBF,$0000,$FFFF,$FFBF,$EC00,$0EFF,$E000,$C000
		dc.w	$000A,$0018,$0003,$0002,$FFEF,$0110,$FEFF,$FD70
		dc.w	$FB9E,$0461,$FFFF,$FC61,$FD8A,$0801,$F78F,$E90B
		dc.w	$EDAF,$1250,$FFFF,$1E70,$6BEE,$8011,$EFFF,$CA71
		dc.w	$DEEC,$210E,$FFE0,$E1C0,$AFFB,$A104,$9EFF,$2F67
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$FF80,$0080,$FF00,$FE80
		dc.w	$BFBF,$0040,$FFFF,$BFCF,$FE00,$0000,$FE00,$FC00
		dc.w	$000C,$001E,$0000,$0000,$AFF6,$8009,$BFFF,$2FF9
		dc.w	$FF8C,$001E,$FF80,$FF00,$9800,$BC00,$8000,$0000
		dc.w	$0AED,$0112,$0FFF,$0B1E,$AF68,$5080,$FFEF,$70C8
		dc.w	$001E,$0021,$FFFF,$0021,$E800,$0C00,$E000,$C000
		dc.w	$0002,$0008,$0003,$0002,$6EBF,$9000,$FEFF,$9C20
		dc.w	$FFFD,$0002,$FFFF,$FFC3,$FB8B,$0000,$FB8F,$F10B
		dc.w	$FBFF,$0400,$FFFF,$FC3F,$EB5C,$00A3,$EFFF,$CAE3
		dc.w	$CDE2,$320F,$FFE4,$33C0,$1EBF,$0000,$3EFF,$1E3F
		dc.w	$F7DD,$0822,$FFFF,$F83E,$DF80,$2000,$FF80,$3F00
		dc.w	$BFFF,$0000,$FFFF,$BFFF,$B600,$4800,$FE00,$CC00
		dc.w	$0002,$000F,$0004,$0000,$2FED,$0012,$3FFF,$2FF3
		dc.w	$ED82,$120F,$FF84,$F300,$3000,$7800,$0000,$0000
		dc.w	$0BFB,$0004,$0FFF,$0BFC,$FFEB,$0000,$FFEF,$3FCA
		dc.w	$5CCD,$A332,$FFFF,$E333,$E000,$0800,$E000,$C000
		dc.w	$0002,$0000,$0003,$0002,$FFEE,$0091,$FF7F,$FEB1
		dc.w	$BDDF,$4220,$FFFF,$C3E3,$FE8B,$0400,$FB8F,$F40B
		dc.w	$FEBF,$0140,$FFFF,$FF7F,$EBFF,$0000,$EFFF,$CBFF
		dc.w	$FFE3,$0007,$FFE0,$FFC0,$5FFB,$4084,$3F7F,$5FBC
		dc.w	$5EFF,$A100,$FFFF,$E1FF,$FFC0,$0040,$FF80,$FF40
		dc.w	$B7EF,$0810,$FFFF,$B870,$DE00,$2000,$FE00,$6400
		dc.w	$0003,$0007,$0000,$0000,$2FFE,$8001,$3FFF,$2FFF
		dc.w	$F283,$0D07,$FF80,$FD00,$6000,$F000,$0000,$0000
		dc.w	$0BFE,$0001,$0FFF,$0BFF,$BFEB,$4000,$FFEF,$7FCB
		dc.w	$FFFF,$0000,$FFFF,$FFFF,$E000,$0000,$E000,$C000
		dc.w	$0002,$0000,$0003,$0002,$BB5F,$4400,$FF7F,$C61F
		dc.w	$FEFF,$0100,$FFFF,$C1FF,$FD89,$0002,$FD8F,$F80A
		dc.w	$F7DF,$0820,$FFFF,$0FE0,$6B6F,$8090,$EFFF,$CB9F
		dc.w	$7B60,$8482,$FFE1,$84C1,$3B57,$0408,$7F7F,$3D18
		dc.w	$FFFF,$0000,$FFFF,$7FF9,$FBC0,$0400,$FFC0,$F780
		dc.w	$BFFF,$0000,$FFFF,$A060,$FE00,$0000,$FE00,$7C00
		dc.w	$0001,$0003,$0000,$0000,$A675,$898A,$3FFF,$298E
		dc.w	$EF81,$1003,$FF80,$1F00,$C000,$E000,$0000,$0000
		dc.w	$09F7,$0208,$0FFF,$0A0F,$DF6B,$2080,$FFEF,$E0CB
		dc.w	$6F7B,$9084,$FFFF,$9F84,$6000,$8000,$E000,$C000
		dc.w	$0002,$0000,$0003,$0002,$DDFD,$2242,$FFBF,$E35E
		dc.w	$BFFE,$4001,$FFFF,$7F01,$F78B,$0A00,$FD8F,$8A08
		dc.w	$DFFF,$2000,$FFFF,$3FC0,$EBFF,$0000,$EFFF,$4B06
		dc.w	$FDE0,$0204,$FFE0,$0240,$FDFD,$8242,$7FBF,$FF5E
		dc.w	$7FBF,$8040,$FFFF,$FFC1,$77E0,$8820,$FFC0,$9FA0
		dc.w	$BF77,$0088,$FFFF,$A0F8,$7E00,$8000,$FE00,$FC00
		dc.w	$0000,$0005,$0000,$0000,$AFBB,$8044,$3FFF,$2FC6
		dc.w	$DF80,$2005,$FF80,$3F00,$8000,$D000,$0000,$0000
		dc.w	$0BDF,$0020,$0FFF,$083F,$FFEB,$0000,$FFEF,$C04B
		dc.w	$FFFD,$0002,$FFFF,$0602,$E000,$0000,$E000,$4000
		dc.w	$0002,$0000,$0003,$0002,$FFAF,$0000,$FFBF,$FF0C
		dc.w	$FFBF,$0040,$FFFF,$1FC0,$BE89,$4002,$FE8F,$C40A
		dc.w	$AF5F,$50A0,$FFFF,$70E0,$EBFF,$0000,$EFFF,$4B06
		dc.w	$FFE0,$0004,$FFE2,$0242,$7BAF,$0400,$FFBF,$7D0F
		dc.w	$BE77,$4188,$FFFF,$C18A,$3FE0,$C000,$FFE0,$DFC0
		dc.w	$ADFF,$1200,$FFFF,$B3FF,$F600,$0800,$FE00,$8C00
		dc.w	$0002,$0006,$0000,$0000,$297F,$8680,$3FFF,$2EFF
		dc.w	$ED82,$1206,$FF80,$F300,$2000,$B000,$0000,$0000
		dc.w	$09AF,$0250,$0FFF,$0A70,$5FEB,$A000,$FFEF,$E04B
		dc.w	$FFFF,$0000,$FFFF,$0602,$E000,$0000,$E000,$4000
		dc.w	$0002,$0000,$0003,$0002,$EFFF,$1020,$FFDF,$1FAC
		dc.w	$FFDE,$0021,$FFFF,$1FE1,$DF8B,$2100,$FE8F,$E50B
		dc.w	$FFFE,$0001,$FFFF,$C07F,$EBB6,$0049,$EFFF,$4BCF
		dc.w	$DF61,$2085,$FFE0,$3FC1,$DBFF,$2420,$FFDF,$E7EF
		dc.w	$FFFF,$0000,$FFFF,$80FF,$FFF0,$0010,$FFE0,$F3D0
		dc.w	$BDF7,$0208,$FFFF,$BE0F,$FE00,$0000,$FE00,$0400
		dc.w	$0002,$0006,$0001,$0000,$2FEF,$0010,$3FFF,$2830
		dc.w	$3F82,$C006,$FF81,$C100,$2000,$3000,$4000,$0000
		dc.w	$0BFF,$0000,$0FFF,$0BC0,$FEEB,$0100,$FFEF,$7F4B
		dc.w	$B6DF,$4920,$FFFF,$CF3F,$6000,$8000,$E000,$C000
		dc.w	$0002,$0000,$0003,$0002,$5F57,$A080,$FFDF,$B084
		dc.w	$F7DF,$0820,$FFFF,$183F,$FF0B,$0000,$FF0F,$FE0B
		dc.w	$DF6E,$2091,$FFFF,$E0F1,$EBFF,$0000,$EFFF,$CBFF
		dc.w	$DEE0,$2100,$FFE5,$E1C4,$FFD6,$0001,$FF5F,$FF85
		dc.w	$BFBB,$4044,$FFFF,$C07C,$E7F0,$1800,$FFF0,$1BE0
		dc.w	$BBFF,$0400,$FFFF,$BC03,$FE00,$0000,$FE00,$0400
		dc.w	$0002,$0006,$0001,$0000,$2FBF,$8040,$BFFF,$2860
		dc.w	$9D82,$6206,$FF81,$6300,$2000,$B000,$C000,$0000
		dc.w	$0BDF,$0020,$0FFF,$0BE0,$6EEB,$9100,$FFEF,$F1CB
		dc.w	$FFDE,$0021,$FFFF,$FFE1,$E000,$0000,$E000,$C000
		dc.w	$0002,$0000,$0003,$0002,$FBFF,$0410,$FFEF,$FC54
		dc.w	$DFEE,$2011,$FFFF,$201F,$F78B,$0880,$FF0F,$0E8B
		dc.w	$FFFF,$0000,$FFFF,$FFC0,$EB5E,$00A1,$EFFF,$CAE1
		dc.w	$FFE3,$0002,$FFE1,$80C3,$FDFF,$0210,$FFEF,$FE14
		dc.w	$FDFF,$0200,$FFFF,$FE18,$FFF8,$0008,$FFF0,$0FE8
		dc.w	$BFFF,$0000,$FFFF,$B803,$FE00,$0000,$FE00,$0400
		dc.w	$0002,$0006,$0001,$0000,$2FEE,$8011,$BFFF,$2FF1
		dc.w	$FF82,$0006,$FF81,$FF00,$2000,$B000,$C000,$0000
		dc.w	$0BFF,$0000,$0FFF,$0BFF,$FFEB,$0000,$FFEF,$C0CA
		dc.w	$5EFF,$A100,$FFFF,$E180,$E000,$0000,$E000,$C000
		dc.w	$0002,$0000,$0003,$0002,$BDEA,$4201,$FFEF,$C643
		dc.w	$FFFD,$0002,$FFFF,$200E,$FB8D,$0408,$FF87,$070D
		dc.w	$DEFF,$2100,$FFFF,$E1C0,$EBFF,$0000,$EFFF,$CA40
		dc.w	$BEE1,$4120,$FFC3,$41A1,$3BEA,$C401,$FFAF,$C7C1
		dc.w	$DDFF,$2200,$FFFF,$E318,$FFD8,$0020,$FFF8,$0E30
		dc.w	$BBFF,$0400,$FFFF,$BC03,$7600,$8800,$FE00,$8C00
		dc.w	$0002,$0006,$0001,$0000,$35FD,$A202,$9FFF,$361E
		dc.w	$EF82,$1006,$FF81,$1F00,$2000,$B000,$C000,$0000
		dc.w	$0DDE,$0821,$07FF,$0DE1,$FFEB,$0000,$FFEF,$C0CA
		dc.w	$FFBE,$0041,$FFFF,$4041,$E000,$2000,$C000,$A000
		dc.w	$0002,$0000,$0003,$0002,$FFFF,$0008,$FFF7,$07EB
		dc.w	$FBEF,$0410,$FFFF,$FC1C,$FF85,$0000,$FF87,$0105
		dc.w	$FFDF,$0020,$FFFF,$8060,$EBDF,$0020,$EFFF,$CA60
		dc.w	$FEC1,$0100,$FFC3,$4181,$DDDF,$2228,$7FF7,$E3EB
		dc.w	$FFDB,$0024,$FFFF,$813C,$7DF8,$8200,$FFF8,$FE10
		dc.w	$BDF7,$0208,$FFFF,$BE0F,$FE00,$0000,$FE00,$FC00
		dc.w	$0002,$0006,$0001,$0000,$53DF,$C420,$9FFF,$543C
		dc.w	$FB82,$0406,$FF81,$0700,$2000,$B000,$C000,$0000
		dc.w	$05FF,$0000,$07FF,$0580,$DFEB,$2000,$FFEF,$60CA
		dc.w	$DFFE,$2001,$FFFF,$6041,$C000,$0000,$D000,$9000
		dc.w	$0002,$0000,$0003,$0002,$71D5,$8820,$F9F7,$8821
		dc.w	$F9FF,$0000,$F9FF,$F9FF,$8D85,$4200,$CF87,$C305
		dc.w	$BF8E,$4011,$FF9F,$C011,$EB53,$00A0,$EFF3,$CAE0
		dc.w	$7FC1,$8000,$FFC3,$FF81,$7F35,$80C0,$FFF7,$FFF1
		dc.w	$F3FF,$0000,$F3FF,$81FF,$73D8,$8020,$F3F8,$8230
		dc.w	$BF47,$00A0,$FFE7,$BFA0,$7E00,$8000,$FE00,$FC00
		dc.w	$0002,$0006,$0001,$0000,$177C,$8082,$DFFE,$14FE
		dc.w	$7F82,$0006,$7F81,$0300,$2000,$B000,$C000,$0000
		dc.w	$05BF,$0040,$07FF,$05C0,$8EEB,$1100,$9FEF,$11CA
		dc.w	$537F,$A080,$F3FF,$E0FF,$C000,$1000,$C000,$8000
		dc.w	$0002,$0000,$0003,$0002,$F6FF,$0404,$F6FB,$F215
		dc.w	$E6DD,$1422,$F6FF,$F23E,$B786,$2004,$B783,$1706
		dc.w	$FF6F,$0040,$FF6F,$C02F,$EBED,$0008,$EFED,$CBE5
		dc.w	$7FC1,$8040,$FF83,$8741,$7FFF,$8004,$FFFB,$FFAD
		dc.w	$AD7B,$4884,$EDFF,$C586,$EDD8,$0820,$EDF8,$0430
		dc.w	$B7DB,$0810,$FFDB,$B8C8,$EE00,$1000,$FE00,$1C00
		dc.w	$0002,$0006,$0001,$0000,$1BBD,$9041,$CFFD,$1BC0
		dc.w	$BB82,$0406,$BF81,$8700,$2000,$B000,$C000,$0000
		dc.w	$06FF,$0400,$03FF,$06C0,$6FEB,$4000,$6FEF,$2FCB
		dc.w	$ED7F,$0880,$EDFF,$E587,$C000,$5000,$8000,$4000
		dc.w	$0002,$0000,$0003,$0002,$CB7A,$2A00,$EF7B,$E010
		dc.w	$CB6F,$2A10,$EF7F,$E01C,$5B82,$5000,$7B83,$0302
		dc.w	$FEB7,$00A0,$FEF7,$C000,$6B56,$8094,$EFDE,$CB80
		dc.w	$FF83,$0002,$FF81,$0703,$BEFA,$4100,$FFFB,$C1F0
		dc.w	$D6FE,$1401,$DEFF,$C001,$D6F8,$1408,$DEF0,$00E8
		dc.w	$BFAD,$0028,$FFBD,$A000,$FE00,$0000,$FE00,$0C00
		dc.w	$0002,$0006,$0001,$0000,$0BFA,$8002,$EFFB,$2B00
		dc.w	$DF82,$8006,$DF81,$1F00,$2000,$B000,$C000,$0000
		dc.w	$02FE,$0000,$03FE,$02C0,$B76B,$A080,$F7EF,$00CB
		dc.w	$56FF,$9400,$DEFF,$8007,$8000,$1000,$A000,$2000
		dc.w	$0002,$0000,$0003,$0002,$EF5B,$0422,$EF79,$8A32
		dc.w	$EF7F,$0400,$EF7F,$CA0C,$7B83,$2002,$7B81,$5303
		dc.w	$5EF7,$2040,$FEF7,$60A0,$EADE,$0108,$EFDE,$4B14
		dc.w	$FF80,$0080,$FF05,$0684,$FBFF,$0402,$FFFD,$87F2
		dc.w	$DE7F,$0880,$DEFF,$D480,$DEF0,$0800,$DEF0,$14E0
		dc.w	$BFBD,$0010,$FFBD,$A028,$F600,$0800,$FE00,$0C00
		dc.w	$0002,$0006,$0001,$0000,$2DFB,$A801,$C7FB,$0D02
		dc.w	$DD82,$0206,$DF81,$8300,$2000,$B000,$C000,$0000
		dc.w	$035E,$0220,$01FE,$0360,$F7EA,$4001,$F7EF,$A04B
		dc.w	$DEFF,$0800,$DEFF,$1406,$A000,$B000,$0000,$8000
		dc.w	$0002,$0000,$0003,$0002,$F6F9,$0000,$F6F9,$8070
		dc.w	$76FF,$0000,$F6FF,$600C,$B781,$0001,$B780,$0301
		dc.w	$AD6F,$1200,$FF6F,$B300,$EBED,$0000,$EFED,$4A00
		dc.w	$F701,$0905,$FE00,$0D01,$B5F5,$4A08,$FFFD,$CE0C
		dc.w	$6DFF,$0000,$EDFF,$600C,$EDF0,$0010,$EDE0,$01D0
		dc.w	$BFDB,$0000,$FFDB,$A000,$FE00,$0000,$FE00,$0400
		dc.w	$0002,$0006,$0001,$0000,$2679,$A484,$D3FD,$1684
		dc.w	$BF82,$0006,$BF81,$0100,$2000,$B000,$C000,$0000
		dc.w	$01AD,$0112,$00FF,$01B3,$6FEB,$0000,$6FEF,$004A
		dc.w	$EDF7,$0009,$EDFE,$000D,$6000,$7000,$0000,$4000
		dc.w	$0002,$0000,$0003,$0002,$F859,$01A1,$F9F8,$81B1
		dc.w	$F1FB,$0804,$F9FF,$7816,$CF80,$0000,$CF80,$0300
		dc.w	$DF9F,$8000,$7F9F,$9F80,$EBF2,$0001,$EFF3,$4A03
		dc.w	$DE00,$2204,$FC02,$3A02,$7FFF,$0001,$FFFE,$7807
		dc.w	$F3ED,$0012,$F3FF,$601E,$F3E0,$0000,$F3E0,$03C0
		dc.w	$AFC3,$1024,$FFE7,$B024,$FE00,$0000,$FE00,$0400
		dc.w	$0002,$0006,$0001,$0000,$235E,$B220,$C1FE,$0264
		dc.w	$7D82,$0206,$7F81,$0300,$2000,$B000,$C000,$0000
		dc.w	$00DF,$0080,$007F,$009F,$9FEB,$0000,$9FEF,$804A
		dc.w	$F2DE,$0122,$F3FC,$033A,$2000,$B000,$4000,$0000
		dc.w	$0002,$0000,$0003,$0002,$F6F8,$0900,$FFF8,$F910
		dc.w	$FBBD,$0442,$FFFF,$7C63,$7B80,$8400,$FF80,$8700
		dc.w	$77BE,$4041,$3FFF,$47C1,$EAF7,$0108,$EFFF,$CB0F
		dc.w	$FC02,$0406,$F800,$E400,$9BFE,$8400,$7FFE,$9C06
		dc.w	$AFBE,$1041,$FFFF,$307F,$EFE0,$1020,$FFC0,$1F20
		dc.w	$BFFF,$0000,$FFFF,$BFFF,$6E00,$9000,$FE00,$9C00
		dc.w	$0002,$0006,$0001,$0000,$21DC,$B103,$C0FF,$011F
		dc.w	$FF82,$0006,$FF81,$0300,$2000,$B000,$C000,$0000
		dc.w	$0077,$0040,$003F,$0047,$BEEA,$4101,$FFEF,$C1CB
		dc.w	$F7FD,$0805,$FFF8,$0FE5,$2000,$B000,$C000,$0000
		dc.w	$0002,$0000,$0003,$0002,$FFF8,$0000,$FFF8,$FFF0
		dc.w	$FFFF,$8000,$7FFF,$BFFF,$FF80,$0000,$FF80,$FF00
		dc.w	$1FFF,$1000,$0FFF,$11FF,$EBFF,$0000,$EFFF,$CBFF
		dc.w	$F003,$1007,$E000,$1001,$27FF,$2000,$1FFF,$27FF
		dc.w	$BFFF,$8000,$3FFF,$BFFF,$FF80,$0080,$FF00,$FC80
		dc.w	$BFFF,$0000,$FFFF,$BFFF,$FE00,$0000,$FE00,$FC00
		dc.w	$0002,$0006,$0001,$0000,$207F,$B040,$C03F,$0047
		dc.w	$FF82,$0006,$FF81,$FF00,$2000,$B000,$C000,$0000
		dc.w	$001F,$0010,$000F,$0011,$FFEB,$0000,$FFEF,$FFCB
		dc.w	$FFF0,$0010,$FFE3,$FF12,$2000,$B000,$C000,$0000
		dc.w	$0003,$0000,$0003,$0002,$FFF8,$0000,$FFF8,$0000
		dc.w	$7FFF,$0000,$7FFF,$0000,$FF80,$0000,$FF80,$0000
		dc.w	$03FF,$0200,$01FF,$0200,$EFFF,$0000,$EFFF,$0800
		dc.w	$8002,$8006,$0001,$8000,$4FFF,$C800,$87FF,$4800
		dc.w	$DFFF,$0000,$DFFF,$0000,$FE00,$0200,$FC00,$0200
		dc.w	$FFFF,$0000,$FFFF,$8000,$FE00,$0000,$FE00,$0000
		dc.w	$0002,$0006,$0001,$0000,$200F,$B008,$C007,$0008
		dc.w	$FF82,$0006,$FF81,$0000,$2000,$B000,$C000,$0000
		dc.w	$0003,$0002,$0001,$0002,$FFEF,$0000,$FFEF,$0008
		dc.w	$FF82,$0086,$FF01,$0080,$2000,$B000,$C000,$0000
		dc.w	$0000,$0000,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$1000,$1000
		dc.w	$0002,$0006,$0001,$0000,$2000,$A000,$D000,$1000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0000,$0000,$0004,$0004,$0000,$0000,$0000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0000,$0005,$0000,$0000,$0000,$D000,$8000,$0000
		dc.w	$0000,$0005,$0000,$0000,$0000,$D000,$8000,$0000
		dc.w	$0000,$0005,$0000,$0000,$0000,$D000,$8000,$0000
		dc.w	$0000,$0005,$0000,$0000,$0000,$D000,$8000,$0000
		dc.w	$0000,$0005,$0000,$0000,$0000,$D000,$8000,$0000
		dc.w	$0000,$0005,$0000,$0000,$0000,$D000,$8000,$0000
		dc.w	$0000,$0005,$0000,$0000,$0000,$D000,$8000,$0000
		dc.w	$0000,$0005,$0000,$0000,$0000,$D000,$8000,$0000
		dc.w	$0000,$0005,$0000,$0000,$0000,$D000,$8000,$0000
		dc.w	$0000,$0005,$0000,$0000,$0000,$D000,$8000,$0000
		dc.w	$0000,$0002,$0001,$0000,$8000,$E000,$4000,$0000
		dc.w	$0000,$0002,$0001,$0000,$8000,$E000,$4000,$0000
		dc.w	$0000,$0002,$0001,$0000,$8000,$E000,$4000,$0000
		dc.w	$0000,$0002,$0001,$0000,$8000,$E000,$4000,$0000
		dc.w	$0000,$0002,$0001,$0000,$8000,$E000,$4000,$0000
		dc.w	$0000,$0002,$0001,$0000,$8000,$E000,$4000,$0000
		dc.w	$0000,$0002,$0001,$0000,$8000,$E000,$4000,$0000
		dc.w	$0000,$0002,$0001,$0000,$8000,$E000,$4000,$0000
		dc.w	$0000,$0002,$0001,$0000,$8000,$E000,$4000,$0000
		dc.w	$0000,$0002,$0001,$0000,$8000,$E000,$4000,$0000
		dc.w	$0001,$0007,$0002,$0000,$4000,$F000,$2000,$0000
		dc.w	$0001,$0007,$0002,$0000,$4000,$F000,$2000,$0000
		dc.w	$0001,$0007,$0002,$0000,$4000,$F000,$2000,$0000
		dc.w	$0001,$0007,$0002,$0000,$4000,$F000,$2000,$0000
		dc.w	$0001,$0007,$0002,$0000,$4000,$F000,$2000,$0000
		dc.w	$0001,$0007,$0002,$0000,$4000,$F000,$2000,$0000
		dc.w	$0001,$0007,$0002,$0000,$4000,$F000,$2000,$0000
		dc.w	$0001,$0007,$0002,$0000,$4000,$F000,$2000,$0000
		dc.w	$0001,$0007,$0002,$0000,$4000,$F000,$2000,$0000
		dc.w	$0001,$0007,$0002,$0000,$4000,$F000,$2000,$0000
		dc.w	$0002,$000B,$0004,$0000,$2000,$7800,$1000,$0000
		dc.w	$0002,$000B,$0004,$0000,$2000,$7800,$1000,$0000
		dc.w	$0002,$000B,$0004,$0000,$2000,$7800,$1000,$0000
		dc.w	$0002,$000B,$0004,$0000,$2000,$7800,$1000,$0000
		dc.w	$0002,$000B,$0004,$0000,$2000,$7800,$1000,$0000
		dc.w	$0002,$000B,$0004,$0000,$2000,$7800,$1000,$0000
		dc.w	$0002,$000B,$0004,$0000,$2000,$7800,$1000,$0000
		dc.w	$0002,$000B,$0004,$0000,$2000,$7800,$1000,$0000
		dc.w	$0002,$000B,$0004,$0000,$2000,$7800,$1000,$0000
		dc.w	$0002,$000B,$0004,$0000,$2000,$7800,$1000,$0000
		dc.w	$0004,$0016,$0008,$0000,$1800,$3C00,$0000,$8000
		dc.w	$0000,$0010,$000C,$0004,$1800,$3800,$0400,$0400
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$8000
		dc.w	$0008,$0008,$0010,$0018,$8000,$8000,$0000,$8000
		dc.w	$0008,$0008,$0004,$000C,$0000,$0000,$0400,$0400
		dc.w	$0004,$0006,$0018,$0010,$0000,$0000,$2000,$A000
		dc.w	$0000,$0000,$0004,$0004,$0000,$0400,$0800,$0800
		dc.w	$0000,$0000,$0000,$0000,$1000,$1000,$2800,$2800
		dc.w	$0004,$0014,$000A,$0002,$1800,$1C00,$2000,$2000
		dc.w	$0004,$0016,$0008,$0000,$1800,$3C00,$0000,$8000
		dc.w	$0008,$FFAC,$0010,$0001,$4800,$5EFF,$4400,$8000
		dc.w	$0008,$F828,$0393,$0000,$0800,$183F,$8380,$0000
		dc.w	$0000,$0000,$7E7E,$0000,$8000,$8000,$3F3F,$8000
		dc.w	$0000,$0000,$3F67,$0000,$0000,$0000,$7F3F,$0000
		dc.w	$0000,$7800,$05F3,$0400,$0000,$0000,$F9F3,$0000
		dc.w	$0008,$020C,$F4E0,$0401,$4000,$4000,$1F9F,$C000
		dc.w	$0000,$0000,$3F3B,$0000,$0000,$043E,$B180,$0000
		dc.w	$0000,$0000,$FD7E,$0100,$0000,$0000,$D67D,$1001
		dc.w	$0008,$FC0C,$01D1,$0000,$0800,$1C1F,$C5C0,$0000
		dc.w	$0008,$FFAC,$0010,$0001,$4800,$5EFF,$4400,$8000
		dc.w	$FF10,$FF78,$0021,$0002,$667F,$6F7F,$6000,$8000
		dc.w	$E000,$E000,$1393,$1010,$000F,$000F,$8390,$0010
		dc.w	$0000,$0000,$7777,$0000,$0000,$0000,$7870,$0000
		dc.w	$0000,$0000,$7077,$0000,$0000,$0000,$7F70,$0000
		dc.w	$7800,$7800,$83FB,$8000,$0000,$0000,$FBFB,$0000
		dc.w	$0200,$0208,$B911,$0112,$0000,$0000,$383B,$8000
		dc.w	$0000,$0000,$BBBB,$0000,$003E,$003E,$BB80,$0000
		dc.w	$0000,$0000,$EEE0,$0000,$0000,$0000,$EEFE,$0000
		dc.w	$F000,$F000,$09C9,$0808,$0007,$0007,$C9C8,$0808
		dc.w	$FF10,$FF78,$0021,$0002,$667F,$6F7F,$6000,$8000
		dc.w	$0020,$00B0,$FE43,$0004,$5300,$5780,$503F,$A000
		dc.w	$0000,$0000,$EFEF,$0000,$0000,$0000,$EFEF,$0000
		dc.w	$0000,$0000,$777E,$0000,$0100,$0100,$7CBE,$0080
		dc.w	$0000,$0000,$7C7F,$0000,$0000,$0000,$1CBE,$0080
		dc.w	$8000,$8000,$7BB8,$8000,$0000,$0000,$E3BB,$0000
		dc.w	$0400,$0400,$F2E3,$0404,$0000,$0080,$3E3B,$8000
		dc.w	$0000,$0000,$BF3B,$0000,$0000,$0000,$BFBE,$0000
		dc.w	$0000,$0000,$EEFA,$0000,$0000,$0000,$FEEE,$0000
		dc.w	$0000,$0000,$F7F7,$0000,$0000,$0000,$F7F7,$0000
		dc.w	$0020,$00B0,$FE43,$0004,$5300,$5780,$503F,$A000
		dc.w	$0040,$FDE0,$FC80,$000F,$7980,$7BDF,$781F,$8000
		dc.w	$0000,$E000,$EFEF,$0000,$0000,$000F,$EFEF,$0000
		dc.w	$0000,$0000,$7E77,$0000,$0000,$0000,$7887,$0080
		dc.w	$0000,$0000,$7077,$0000,$4100,$4100,$5C87,$0080
		dc.w	$0000,$7800,$7BF8,$0002,$0800,$0800,$EBFB,$0000
		dc.w	$0000,$0000,$B8E0,$000F,$0080,$0080,$393B,$8100
		dc.w	$0000,$0000,$BBBB,$0000,$0000,$001E,$BB9E,$0000
		dc.w	$0000,$0000,$EEE0,$0000,$0000,$0000,$EEEE,$0000
		dc.w	$0000,$F000,$F7F7,$0000,$0000,$0007,$F7F7,$0000
		dc.w	$0040,$FDE0,$FC80,$000F,$7980,$7BDF,$781F,$8000
		dc.w	$0027,$00F7,$FE47,$0000,$8300,$F780,$803F,$7000
		dc.w	$0000,$0000,$EFEF,$0000,$0000,$0000,$EFEF,$0000
		dc.w	$0000,$0000,$7077,$0000,$0000,$0000,$7F7F,$0000
		dc.w	$0000,$0000,$7F77,$0000,$0100,$4100,$1C7F,$4000
		dc.w	$0002,$0002,$7BFA,$0000,$0000,$0000,$E3FB,$0000
		dc.w	$0007,$0007,$BAE7,$0000,$8300,$8380,$B83F,$0000
		dc.w	$0000,$0000,$BBBF,$0000,$0000,$0000,$BBBE,$0000
		dc.w	$0000,$0000,$FEFE,$0000,$0000,$0000,$EEEE,$0000
		dc.w	$0000,$0000,$F7F7,$0000,$0000,$0000,$F7F7,$0000
		dc.w	$0027,$00F7,$FE47,$0000,$8300,$F780,$803F,$7000
		dc.w	$FF12,$FF7A,$0022,$0001,$867F,$EF7F,$8000,$6000
		dc.w	$E000,$E000,$1393,$1010,$000F,$000F,$8390,$0010
		dc.w	$0700,$0700,$7077,$0000,$0000,$0000,$7F7F,$0000
		dc.w	$0000,$0000,$7F77,$0000,$0000,$4100,$1C7F,$4000
		dc.w	$7802,$7802,$03BA,$0000,$0000,$0800,$E3BB,$0000
		dc.w	$0201,$0209,$B8E0,$0001,$8200,$8300,$B83F,$0000
		dc.w	$0000,$0000,$BBBF,$0000,$003E,$003E,$BB80,$0000
		dc.w	$0000,$0000,$FEFE,$0000,$0000,$0000,$EEFE,$0000
		dc.w	$F000,$F000,$09C9,$0808,$0007,$0007,$C9C8,$0808
		dc.w	$FF12,$FF7A,$0022,$0001,$867F,$EF7F,$8000,$6000
		dc.w	$0009,$FFBD,$0011,$0000,$8C00,$DEFF,$8000,$4000
		dc.w	$0008,$F838,$0393,$0000,$0800,$183F,$8380,$0000
		dc.w	$0000,$0700,$7077,$0000,$0000,$0000,$3F3E,$0000
		dc.w	$0000,$0000,$BF77,$8000,$0000,$4000,$1CBE,$4080
		dc.w	$0000,$7800,$83B8,$8000,$0800,$0800,$E3BB,$0000
		dc.w	$0008,$0208,$B8E2,$0000,$8000,$8280,$B85F,$0040
		dc.w	$0000,$0000,$3B9F,$0000,$0000,$003E,$3B80,$0000
		dc.w	$0000,$0000,$FD7E,$0100,$0000,$0000,$EE7D,$0001
		dc.w	$0008,$FC1C,$01D1,$0000,$0C00,$1C1F,$C1C0,$0000
		dc.w	$0009,$FFBD,$0011,$0000,$8C00,$DEFF,$8000,$4000
		dc.w	$000C,$001E,$0000,$0000,$9800,$BC00,$8000,$0000
		dc.w	$0008,$0018,$0004,$0004,$1800,$3800,$0400,$0400
		dc.w	$0000,$0000,$0008,$0008,$8000,$8000,$0000,$8000
		dc.w	$0000,$0000,$0008,$0008,$8000,$8000,$2000,$A000
		dc.w	$0000,$0002,$0004,$0004,$0800,$0800,$1400,$1400
		dc.w	$0008,$0008,$0014,$0014,$8000,$8000,$8400,$0400
		dc.w	$0000,$0000,$0000,$0000,$8000,$8000,$0400,$8400
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$1000,$1000
		dc.w	$000C,$001C,$0002,$0002,$1800,$1C00,$2000,$2000
		dc.w	$000C,$001E,$0000,$0000,$9800,$BC00,$8000,$0000
		dc.w	$0002,$000F,$0004,$0000,$3000,$7800,$0000,$0000
		dc.w	$0002,$000F,$0004,$0000,$3000,$7800,$0000,$0000
		dc.w	$0002,$000F,$0004,$0000,$3000,$7800,$0000,$0000
		dc.w	$0002,$000F,$0004,$0000,$3000,$7800,$0000,$0000
		dc.w	$0002,$000F,$0004,$0000,$3000,$7800,$0000,$0000
		dc.w	$0002,$000F,$0004,$0000,$3000,$7800,$0000,$0000
		dc.w	$0002,$000F,$0004,$0000,$3000,$7800,$0000,$0000
		dc.w	$0002,$000F,$0004,$0000,$3000,$7800,$0000,$0000
		dc.w	$0002,$000F,$0004,$0000,$3000,$7800,$0000,$0000
		dc.w	$0002,$000F,$0004,$0000,$3000,$7800,$0000,$0000
		dc.w	$0003,$0007,$0000,$0000,$6000,$F000,$0000,$0000
		dc.w	$0003,$0007,$0000,$0000,$6000,$F000,$0000,$0000
		dc.w	$0003,$0007,$0000,$0000,$6000,$F000,$0000,$0000
		dc.w	$0003,$0007,$0000,$0000,$6000,$F000,$0000,$0000
		dc.w	$0003,$0007,$0000,$0000,$6000,$F000,$0000,$0000
		dc.w	$0003,$0007,$0000,$0000,$6000,$F000,$0000,$0000
		dc.w	$0003,$0007,$0000,$0000,$6000,$F000,$0000,$0000
		dc.w	$0003,$0007,$0000,$0000,$6000,$F000,$0000,$0000
		dc.w	$0003,$0007,$0000,$0000,$6000,$F000,$0000,$0000
		dc.w	$0003,$0007,$0000,$0000,$6000,$F000,$0000,$0000
		dc.w	$0001,$0003,$0000,$0000,$C000,$E000,$0000,$0000
		dc.w	$0001,$0003,$0000,$0000,$C000,$E000,$0000,$0000
		dc.w	$0001,$0003,$0000,$0000,$C000,$E000,$0000,$0000
		dc.w	$0001,$0003,$0000,$0000,$C000,$E000,$0000,$0000
		dc.w	$0001,$0003,$0000,$0000,$C000,$E000,$0000,$0000
		dc.w	$0001,$0003,$0000,$0000,$C000,$E000,$0000,$0000
		dc.w	$0001,$0003,$0000,$0000,$C000,$E000,$0000,$0000
		dc.w	$0001,$0003,$0000,$0000,$C000,$E000,$0000,$0000
		dc.w	$0001,$0003,$0000,$0000,$C000,$E000,$0000,$0000
		dc.w	$0001,$0003,$0000,$0000,$C000,$E000,$0000,$0000
		dc.w	$0000,$0005,$0000,$0000,$8000,$D000,$0000,$0000
		dc.w	$0000,$0005,$0000,$0000,$8000,$D000,$0000,$0000
		dc.w	$0000,$0005,$0000,$0000,$8000,$D000,$0000,$0000
		dc.w	$0000,$0005,$0000,$0000,$8000,$D000,$0000,$0000
		dc.w	$0000,$0005,$0000,$0000,$8000,$D000,$0000,$0000
		dc.w	$0000,$0005,$0000,$0000,$8000,$D000,$0000,$0000
		dc.w	$0000,$0005,$0000,$0000,$8000,$D000,$0000,$0000
		dc.w	$0000,$0005,$0000,$0000,$8000,$D000,$0000,$0000
		dc.w	$0000,$0005,$0000,$0000,$8000,$D000,$0000,$0000
		dc.w	$0000,$0005,$0000,$0000,$8000,$D000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0000,$0000,$2000,$B000,$0000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$3000,$4000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000
		dc.w	$0002,$0006,$0001,$0000,$2000,$B000,$C000,$0000

******************* M U S I C ******************************

PSG_2:
	incbin	"PSG2.DAT"
	even
PSG_1:
	incbin	"PSG1.DAT"
	even
PLAY_PSG:
	ds.w	3
	even

******************* M U S I C ******************************

	END
