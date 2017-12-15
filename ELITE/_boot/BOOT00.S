;BOOT SECTOR v 1.0 for Maartau
;(c)Zorro2/NoExtra in 2011

TEST equ 1

	IFEQ	TEST
	clr.l	-(sp)
	move.w	#$20,-(sp)
	trap	#1

	bsr.w	DEBUT

	addq.l	#6,sp
	clr.w	(sp)
	trap	#1

DEBUT:

	ENDC

	addq.l	#4,4(sp)		;On passe le test HD sur STE

	tst.w	 $42c 
	beq	 normal
	pea	 alert(pc)
	move.w	 #9,-(sp)
	trap	 #1
	addq.l	 #6,sp
	move.l	 #$31415926,$426.w
	lea	 reset(pc),a0
	move.l	 a0,$42a.w
reset	move.w	 #$2700,sr
	move.b	 #14,$ffff8800.w
	move.b	 $ffff8800.w,d7
	ori.b	 #$7,d7
	move.b	 d7,$ffff8802.w
	move.l	 #$78000,d0
	move.l	 d0,$44e.w
	lsr.w	 #8,d0
	move.b	 #2,$ffff820a.w
	move.w	 #7999,d7
	moveq	 #0,d0
	move.l	 #$78000,a0
clear	move.l	 d0,(a0)+
	dbf	 d7,clear
	
	addq.l	 #4,sp
	move.l	 #$10ff,d2
	move.l	 #900000,d3		
bb2	lea	 data(pc),a0
	move.l	 #27,d0
bb3	move.w	 (a0)+,$ff8240
	nop
	nop
	move.l	 #87,d1
bb4	dbf	 d1,bb4
	dbf	 d0,bb3
	dbeq	 d3,bb2	 	
normal	move.w	 #$fff,$ff825e
	pea	 text(pc)
	move.w	 #9,-(sp)
	trap	 #1
	addq.l	 #6,sp
	move.w	 #$fff,d2
	move.w	 #6,d5
ah_que	move.l	 #$d200,d3
boucle	dbf	 d3,boucle
	add.l	 #-$111,d2
	move.w	 d2,$ff8240
	dbf	 d5,ah_que
	rts
	  	
text	dc.b	 27,"Y",44,48,"eL!Te...",0

alert	dc.b	 '  Eteignez votre ordinateur : VIRUS !!! ',0

data	dc.w	 $077,$176,$275,$374,$473,$572,$671,$770
	dc.w	 $661,$552,$443,$334,$225,$116,$007
	dc.w	 $107,$207,$307,$407,$507,$607,$707
	dc.w	 $617,$527,$437,$347,$257,$167,$077
