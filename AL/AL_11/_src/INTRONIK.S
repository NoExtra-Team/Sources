* Intro for ELITE
* Code by Nikademus (of Zuul)


* note to ELITE:
* let the text with the credits please


	opt	o+,w+,d-

START:
setblock:	move.l	sp,a5
	move.l	4(a5),a5
	move.l	$c(a5),d0
	add.l	$14(a5),d0
	add.l	$1c(a5),d0
	add.l	#$500,d0
	move.l	d0,d1
	add.l	a5,d1
	and.l	#-2,d1
	move.l	d1,a7
	move.l	d0,-(sp)
	move.l	a5,-(sp)
	clr.w	-(sp)
	move.w	#$4a,-(sp)
	trap	#1
	add.l	#12,sp

super:	clr.l	-(sp)
	move.w	#$20,-(sp)
	trap	#1
	addq.l	#6,sp
	move.l	d0,oldsp

	bsr.s	saveall
	bsr	part1
	bsr	restoreall

user:	move.l	oldsp,-(sp)
	move.w	#$20,-(sp)
	trap	#1
	addq.l	#6,sp
pterm:	clr.w	-(sp)
	trap	#1

****************************************************************************************

saveall:	move.w	#$2700,sr

testordi:	move.l	$4f2.w,a0
	move.w	2(a0),STtype

	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,oldpal
	movem.l	clearer,d0-d7
	movem.l	d0-d7,$ffff8240.w

calcadr:	move.l	#screen1,scr1
	move.l	#screen2,scr2
	clr.b	scr1+3
	clr.b	scr2+3

savnsetres
	move.w	#2,-(sp)
	trap	#14
	addq.l	#2,sp
	move.l	d0,oldphys
	move.w	#3,-(sp)
	trap	#14
	addq.l	#2,sp
	move.l	d0,oldlog

falc5	cmp.b	#4,STtype
	blt.s	falcn5
	move.w	#-1,-(sp)
	move.w	#88,-(sp)
	trap	#14
	addq.l	#4,sp
	move.w	d0,oldres
falcn5:	cmp.b	#4,STtype
	bge.s	falce5
	move.w	#4,-(sp)
	trap	#14
	addq.l	#2,sp
	move.w	d0,oldres
falce5

	move.w	#0,-(sp)
	move.l	scr1,-(sp)
	move.l	scr1,-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea	12(sp),sp

	move.w	$ffff893a.w,oldvol

	move.b	#$12,$fffffc02.w
	move.b	$484.w,old484
	bclr.b	#0,$484.w

	lea	oldvector,a6
	move.l	$68.w,(a6)+	;save HBL
	move.l	$70.w,(a6)+	;save VBL
	move.l	$134.w,(a6)+	;save TIMER A
	move.l	$120.w,(a6)+	;save TIMER B
	move.l	$114.w,(a6)+	;save TIMER C
	move.l	$110.w,(a6)+	;save TIMER D
	move.b	$fffffa21.w,(a6)+
	move.b	$fffffa1b.w,(a6)+

	lea	the_rte,a0
	move.l	a0,$134.w
	move.l	a0,$120.w
	move.l	a0,$070.w
	move.l	a0,$068.w
	move.l	a0,$114.w
	move.l	a0,$110.w

	stop	#$2300

	rts

the_rte:	rte

*********************************************************************************************************************

restoreall:
	move.w	#$2700,sr

	move.b	#$8,$fffffc02.w
	move.b	old484,$484.w

	lea	oldvector,a6
	move.l	(a6)+,$68.w	;rest HBL
	move.l	(a6)+,$70.w	;rest VBL
	move.l	(a6)+,$134.w	;rest TIMER A
	move.l	(a6)+,$120.w	;rest TIMER B
	move.l	(a6)+,$114.w	;rest TIMER C
	move.l	(a6)+,$110.w	;rest TIMER D
	move.b	(a6)+,$fffffa21.w
	move.b	(a6)+,$fffffa1b.w

rest_mfp:	lea	$fffffa00.w,a0
	moveq	#0,d0
	movep.l	d0,1(a0)
	movep.l	d0,9(a0)
	movep.l	d0,$11(a0)
	move.b	#$48,$17(a0)
	bset	#2,3(a0)
	move.l	#$000051ff,d0
	movep.l	d0,$19(a0)
	move.l	#$001e6448,d0
	movep.l	d0,$11(a0)
	move.l	#$64000000,d0
	movep.l	d0,9(a0)
	move.l	#$7704001e,d0
	movep.l	d0,1(a0)

	lea	$ffff8800.w,a0
	move.l	#$08080000,(a0)
	move.l	#$09090000,(a0)
	move.l	#$0a0a0000,(a0)

falc6:	cmp.b	#4,STtype
	blt.s	falcn6	
	move.w	oldres,-(sp)
	move.w	#3,-(sp)
	move.l	oldphys,-(sp)
	move.l	oldlog,-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea	14(sp),sp
falcn6:	cmp.b	#4,STtype
	bge.s	falce6
	move.w	oldres,-(sp)
	move.l	oldphys,-(sp)
	move.l	oldlog,-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea	12(sp),sp
falce6:

	movem.l	oldpal,d0-d7
	movem.l	d0-d7,$ffff8240.w
	
	stop	#$2300

	rts
		
*********************************************************************************************************************

part1:	move.w	#$2700,sr

	move.l	#my_vbl,$70.w

	move.l	#timerb,$120.w
	ori.b	#1,$fffffa07.w
	ori.b	#1,$fffffa13.w
	clr.b	$fffffa1b.w

;falc1:	cmp.b	#4,STtype
;	blt.s	falcn1
	moveq.l	#1,d0
	jsr	falczic

;falcn1:	cmp.b	#4,STtype
;	bge.s	falce1
;	moveq.l	#0,d0
;	jsr	music
;	jsr	music+18
;falce1:

	movem.l	fonts+2,d0-d7
	movem.l	d0-d7,logo+34+120*160

Stocking_fonts:
	lea	fonts+34,a0
	lea	fonts2,a1
	moveq.l	#0,d7
	moveq.l	#1,d3
	moveq.l	#3,d2
scrfnt1:	moveq.l	#5,d1
oneline:	moveq.l	#40,d0
onefont:
	rept	3*2
	move.l	(a0)+,(a1)+
	endr
	move.l	d7,(a1)+
	move.l	d7,(a1)+
	lea	(320-48)/2(a0),a0
	dbra	d0,onefont
	lea	(-41*320+48)/2(a0),a0
	dbra	d1,oneline
	lea	(41*320-6*48)/2(a0),a0
	dbra	d2,scrfnt1
	lea	logo+34+73*160,a0
	moveq.l	#0,d2
	dbra	d3,scrfnt1
Clearing_buffer_fonts
	lea	fonts,a0
	move.l	#(41*31*64)/2/4,d0
	moveq.l	#0,d1
Clrfnts:	move.l	d1,(a0)+
	dbra	d0,Clrfnts
Stepping_fonts:
	lea	fonts2,a0
	lea	fonts,a1
	move.l	#31*41-1,d0
Dostep:
offset	set	0
	rept	4
	move.b	16+1+offset(a0),24+offset(a1)
	move.b	16+offset(a0),16+1+offset(a1)
	move.b	8+1+offset(a0),16+offset(a1)
	move.b	8+offset(a0),8+1+offset(a1)
	move.b	1+offset(a0),8+offset(a1)
	move.b	offset(a0),1+offset(a1)
offset	set	offset+2
	endr
	lea	64/2(a0),a0
	lea	64/2(a1),a1
	dbra	d0,dostep

;	lea	logo+34+73*160+42*160,a0
;	move.l	#160*5/4-1,d0
;	move.l	scr1,a1
;	move.l	scr2,a2
;	lea	152*160(a1),a1
;	lea	152*160(a2),a2
;affcode:	move.l	(a0),(a1)+
;	move.l	(a0)+,(a2)+
;	dbra	d0,affcode

;affelite:	lea	logo+34+127*160+4*32/2,a0
;	move.l	scr1,a1
;	move.l	scr2,a2
;	lea	(158-4*22)/2*160(a1),a1
;	lea	(158-4*22)/2*160(a2),a2
;	bsr	afflog
;	lea	logo+34+127*160+32/2,a0
;	bsr	afflog
;	lea	logo+34+127*160+32*2/2,a0
;	bsr	afflog
;	lea	logo+34+127*160,a0
;	bsr	afflog

;	lea	logo+34+127*160+3*32/2,a0
;	move.l	scr1,a1
;	move.l	scr2,a2
;	lea	(158-3*22)/2*160+160-16(a1),a1
;	lea	(158-3*22)/2*160+160-16(a2),a2
;	bsr	afflog
;	lea	logo+34+127*160+6*32/2,a0
;	bsr	afflog
;	lea	logo+34+127*160+7*32/2,a0
;	bsr	afflog

	movem.l	logo+2,d0-d7
	movem.l	d0-d7,$ffff8240.w

random:	move.w	#17,-(sp)
	trap	#14
	addq.l	#2,sp
	andi.l	#%11,d0
	mulu	#20,d0
	lea	bumps,a0
	add.l	d0,a0

	move.l	(a0),adrbmp
	move.l	4(a0),adrbmp+4
	move.l	8(a0),adrbmp+8
	move.l	12(a0),adrbmp+12
	move.l	16(a0),adrbmp+16
	move.l	#eyebmp,adrbmp+20

	lea	text,a6
	move.w	#1,flag+2
	clr.w	fldoffset

	stop	#$2300
	stop	#$2300

waitkey:	cmp.b	#$39,$fffffc02.w
	bne.s	waitkey

;falc4:	cmp.b	#4,STtype
;	bge.s	falce4
;	jsr	music
;	jsr	music+22
falce4	rts

************************************************************************************

my_VBL:	movem.l	logo+2,d0-d7
	movem.l	d0-d7,$ffff8240.w
	clr.b	$fffffa1b.w
	move.b	#1,$fffffa21.w
	move.b	#8,$fffffa1b.w
	move.l	#timerb,$120.w
;falc2:	cmp.b	#4,STtype
;	bge.s	falcm2
;	movem.l	d0-a6,-(sp)
;	jsr	music+26
;	movem.l	(sp)+,d0-a6
;falcm2:	cmp.b	#4,STtype
;	blt.s	falce2
	movem.l	d0-a6,-(sp)
	jsr	falczic+$22
	movem.l	(sp)+,d0-a6
falce2:	bsr	chscreen
	bsr	DOthebump
	bsr	scroll16
	bsr	scrolltext
	cmp.b	#$0f,$fffffc02.w
	bne.s	endvbl
	move.w	#$700,$ffff8240.w
ENDVBL	rte

****************************************************
timerb:	move.w	#$34,$ffff8240.w
	move.l	#tim2,$120.w
	bclr	#0,$fffffa0f.w
	rte
tim2:	move.w	#$23,$ffff8240.w
	move.l	#tim3,$120.w
	bclr	#0,$fffffa0f.w
	rte
tim3:	move.w	#$12,$ffff8240.w
	move.l	#tim4,$120.w
	clr.b	$fffffa1b.w
	move.b	#155-3,$fffffa21.w
	move.b	#8,$fffffa1b.w
	bclr	#0,$fffffa0f.w
	rte
tim4:	move.w	#$23,$ffff8240.w
	move.l	#tim5,$120.w
	clr.b	$fffffa1b.w
	move.b	#1,$fffffa21.w
	move.b	#8,$fffffa1b.w
	bclr	#0,$fffffa0f.w
	rte
tim5:	move.w	#$34,$ffff8240.w
	move.l	#tim6,$120.w
	bclr	#0,$fffffa0f.w
	rte

tim6	clr.w	$ffff8240.w
	movem.l	d0-d7,-(sp)
	movem.l	logo+34+120*160,d0-d7
	movem.l	d0-d7,$ffff8240.w
	movem.l	(sp)+,d0-d7
	clr.b	$fffffa1b.w
	move.b	#100,$fffffa21.w
	move.b	#8,$fffffa1b.w
	bclr	#0,$fffffa0f.w
	rte

*****************************************************
chscreen:	movem.l	d0-d1,-(sp)
	movem.l	scr1,d0-d1
	exg.l	d0,d1
	movem.l	d0-d1,scr1
	move.b	scr1+1,$ffff8201.w
	move.b	scr1+2,$ffff8203.w
	movem.l	(sp)+,d0-d1
	rts

***************************************************************************************
DOthebump
E	lea	logo+34,a0
	move.l	scr1,a1
	add.l	#16+8+21*160,a1
	add.l	#4,adrbmp
	move.l	adrbmp,a2
	cmp.l	#$12345678,(a2)
	bne.s	ndbmp1
	move.l	#bump,adrbmp
	lea	bump,a2
ndbmp1	bsr	bump48

L	lea	logo+34+48/2,a0
	move.l	scr1,a1
	add.l	#16+8+48/2+21*160,a1
	add.l	#4,adrbmp+4
	move.l	adrbmp+4,a2
	cmp.l	#$12345678,(a2)
	bne.s	ndbmp2
	move.l	#bump,adrbmp+4
	lea	bump,a2
ndbmp2	bsr	bump48

I	lea	logo+34+(48+48)/2,a0
	move.l	scr1,a1
	add.l	#16+8+48/2+48/2+21*160,a1
	add.l	#4,adrbmp+8
	move.l	adrbmp+8,a2
	cmp.l	#$12345678,(a2)
	bne.s	ndbmp3
	move.l	#bump,adrbmp+8
	lea	bump,a2
ndbmp3	bsr	bumpoeil
	bsr	bump32

T	lea	logo+34+(48+48+32)/2,a0
	move.l	scr1,a1
	add.l	#16+8+(48+48+32)/2+21*160,a1
	add.l	#4,adrbmp+12
	move.l	adrbmp+12,a2
	cmp.l	#$12345678,(a2)
	bne.s	ndbmp4
	move.l	#bump,adrbmp+12
	lea	bump,a2
ndbmp4	bsr.s	bump48

E2	lea	logo+34,a0
	move.l	scr1,a1
	add.l	#16+8+(48+48+32+48)/2+21*160,a1
	add.l	#4,adrbmp+16
	move.l	adrbmp+16,a2
	cmp.l	#$12345678,(a2)
	bne.s	ndbmp5
	move.l	#bump,adrbmp+16
	lea	bump,a2
ndbmp5	bsr.s	bump48



endbmp	rts

************************************************
Bump48:
clear48:	movem.l	clearer,d2-d7
	add.l	(a2),a1
	lea	-3*160(a1),a3
	moveq.l	#1,d0
clear48_2	movem.l	d2-d7,(a3)
	movem.l	d2-d7,160(a3)
	movem.l	d2-d7,2*160(a3)
	lea	65*160(a3),a3
	dbf	d0,clear48_2
	move.l	#62-1,d0
afflog48:	movem.l	(a0),d2-d7
	movem.l	d2-d7,(a1)
	lea	160(a0),a0
	lea	160(a1),a1
limit48:	dbra	d0,afflog48
	rts		
******************************************************************************
Bump32:
clear32:	movem.l	clearer,d2-d5
	add.l	(a2),a1
	lea	-3*160(a1),a3
	moveq.l	#1,d0
clear32_2	movem.l	d2-d5,(a3)
	movem.l	d2-d5,160(a3)
	movem.l	d2-d5,2*160(a3)
	lea	65*160(a3),a3
	dbf	d0,clear32_2
	move.l	#62-1,d0
afflog32:	movem.l	(a0),d2-d5
	movem.l	d2-d5,(a1)
	lea	160(a0),a0
	lea	160(a1),a1
limit32:	dbra	d0,afflog32
	rts		

******************************************************************************
Bumpoeil:
	movem.l	a0-a2,-(sp)
	moveq.l	#0,d0
	lea	logo+34+121*160,a0
	add.l	#2,adrbmp+20
	move.l	adrbmp+20,a4
	cmp.l	#$12345678,(a4)
	bne.s	ndbmpeye
	move.l	#eyebmp,adrbmp+20
	lea	eyebmp,a4
ndbmpeye	move.w	(a4),d0
	add.l	d0,a0
	lea	-18*160(a1),a1

clearoeil	movem.l	clearer,d2-d5
	add.l	(a2),a1
	lea	-3*160(a1),a3
	moveq.l	#1,d0
clearoeil_2	movem.l	d2-d5,(a3)
	movem.l	d2-d5,160(a3)
	movem.l	d2-d5,2*160(a3)
	lea	15*160(a3),a3
	dbf	d0,clearoeil_2
	move.l	#12-1,d0
afflogoeil:	movem.l	(a0),d2-d5
	movem.l	d2-d5,(a1)
	lea	160(a0),a0
	lea	160(a1),a1
limitoeil:	dbra	d0,afflogoeil

	movem.l	(sp)+,a0-a2
	rts		

***********************************************************************************************************
scroll16:
	move.l	scr1,a0
	lea	160*(200-41)(a0),a0
	lea	8(a0),a1
	moveq.l	#39,d0
scrollit	
	move.l	d0,-(sp)
	rept	3
	movem.l	(a1)+,d0-d7/a2-a5
	movem.l	d0-d7/a2-a5,(a0)
	lea	12*4(a0),a0
	endr	
	movem.l	(a1),d0-d7
	movem.l	d0-d7,(a0)
	lea	8*4(a0),a0
	lea	8(a0),a1
	move.l	(sp)+,d0
	dbra	d0,scrollit
	rts
***********************************************************************************************************
scrolltext:
	sub.w	#1,flag+2
	tst.w	flag+2
	bne.s	normscrl
	moveq.l	#0,d0
	move.b	(a6)+,d0
	tst.b	d0
	bne.s	contscrl
	lea	text,a6
	move.b	(a6)+,d0
contscrl:	cmp.b	#" ",d0
	beq	space
	cmp.b	#".",d0
	beq	point
	cmp.b	#"-",d0
	beq	minus
	cmp.b	#"?",d0
	beq	interrog
	cmp.b	#":",d0
	beq	dblpt
	sub.b	#"A",d0
	lea	fonts,a0
	lea	fonts2,a1
	lsl.w	#5,d0
	mulu	#41,d0
	add.l	d0,a0
	add.l	d0,a1
intscl:	move.l	a1,bufs
	move.l	a0,bufs+4
	clr.w	flag
	move.w	#4*2,flag+2
normscrl:	move.l	scr1,a0
	lea	158*160+160-8(a0),a0
	move.l	bufs,a1
	add.l	#8,bufs
	tst.w	flag
	bne.s	nxtsc1
	move.l	bufs+4,a1
	sub.l	#8,bufs
	add.l	#8,bufs+4
nxtsc1:	moveq.l	#40,d0
nxtsc:	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	lea	160-8(a0),a0
	lea	32-8(a1),a1
	dbra	d0,nxtsc	
	not.w	flag
	rts


space:	lea	fonts+64*41*26/2+64*41/2*4,a0
	lea	fonts2+64*41*26/2+64*41/2*4,a1
	bra.s	intscl
point:	lea	fonts+64*41*26/2+64*41/2*0,a0
	lea	fonts2+64*41*26/2+64*41/2*0,a1
	bra.s	intscl
minus:	lea	fonts+64*41*26/2+64*41/2*1,a0
	lea	fonts2+64*41*26/2+64*41/2*1,a1
	bra	intscl
interrog:	lea	fonts+64*41*26/2+64*41/2*2,a0
	lea	fonts2+64*41*26/2+64*41/2*2,a1
	bra	intscl
dblpt:	lea	fonts+64*41*26/2+64*41/2*3,a0
	lea	fonts2+64*41*26/2+64*41/2*3,a1
	bra	intscl

***********************************************************************************************************

;afflog:	moveq.l	#19,d0
;afflog2:
;	rept	4
;	move.l	(a0),(a1)+
;	move.l	(a0)+,(a2)+
;	endr
;	lea	160-4*4(a0),a0
;	lea	160-4*4(a1),a1
;	lea	160-4*4(a2),a2
;	dbra	d0,afflog2
;	lea	2*160(a1),a1
;	lea	2*160(a2),a2
;	rts

***********************************************************************************************************

	DATA
	even

logo:	incbin	elite.pi1
;music:	incbin	tidal.mus
falczic:	incbin	lapmad.mus	;lap1 lap28 nextch lapmad
eyebmp:	dcb.w	7,0*16
	dcb.w	7,1*16
	dcb.w	40,2*16
	dcb.w	7,3*16
	dcb.w	7,4*16
	dcb.w	7,3*16
	dcb.w	7,2*16
	dcb.w	7,1*16
	dc.l	$12345678
bumps:	dc.l	bump+320,bump+240,bump+160,bump+80,bump+00
	dc.l	bump+160,bump+120,bump+80,bump+40,bump+00
	dc.l	bump+160,bump+80,bump+00,bump+80,bump+160
	dc.l	bump+00,bump+20,bump+40,bump+20,bump+00
bump:	incbin	bump.dat
	dc.l	$12345678
;digit:	incbin	vader.avr	;8bit mono 16KHz
;endigit:	ds.l	1
clearer:	ds.l	16
text:	dc.b	"THIS INTRO WAS CODED BY NIKADEMUS. THE LOGO IS FROM RED AND THE SCROLL FONTS BY SPAZ.              "

;	dc.b	"      FONTS:   ABCDEFGHIJKLMNOPQRSTUVWXYZ.-?:    "
	dc.b	0
fonts:	incbin	rocktest.pi1

	BSS
	even
fonts1:	ds.b	8606
fonts2:	ds.b	40672
oldsp:	ds.l	1
oldres:	ds.w	1
oldphys:	ds.l	1
oldlog:	ds.l	1
oldvol:	ds.w	1
oldvbl:	ds.l	1
old484:	ds.w	1
oldvector	ds.l	7
oldpal:	ds.w	16
flag:	ds.w	2
bufs:	ds.l	2
scr1:	ds.l	1
scr2:	ds.l	1
STtype:	ds.w	1
fldoffset	ds.w	1
adrbmp:	ds.l	6
	ds.b	256+3*160
screen1:	ds.b	32256+3*160
screen2:	ds.b	32256
	ds.b	32000
endbss:	end

	
