	text

begin	bra.s	l0000
	dc.b	$00,$00,$4a,$53,$4e,$4e,$00,$00
	dc.b	$00,$00,$02,$02,$01,$00,$02,$70
	dc.b	$00,$54,$06,$f9,$05,$00,$0a,$00
	dc.b	$02,$00,$00,$00

l0000	move.w	#0,$ffff8240.l
	move.l	#$7000667,$ffff8242.l
	move.l	#$5560445,$ffff8246.l
	move.l	#$7740763,$ffff824a.l
	move.l	#$7520741,$ffff824e.l
	move.w	#$777,$ffff825e.l
	pea	l0001(pc)
	move.w	#9,-(a7)		;cconws
	trap	#1
	addq.l	#6,a7
	rts

l0001	dc.b	$1b,'E'
	dc.b	$1b,'b',$01
	dc.b	$1b,'Y (','The BMG members are :',$0d,$0a,$0d,$0a
	dc.b	$1b,'b',$02
	dc.b	'STrix (maSTer coding),STephy (Musix),',$0d,$0a
	dc.b	$1b,'b',$03
	dc.b	'Atakid (GFX),STriker,PaCer (Code on PC)',$0d,$0a
	dc.b	$1b,'b',$04
	dc.b	'Hi to Eric,Stallion,Runpower,Alien...'
	dc.b	$1b,'b',$05
	dc.b	$1b,'Y& ','Special greetings to :',$0d,$0a
	dc.b	$1b,'b',$06
	dc.b	'~ COUNT-ZERO,MAD-MAX,THALION,TEX,IMPACT',$0d,$0a
	dc.b	$1b,'b',$07
	dc.b	'~ Charlotte,the girl of my heart...',$0d,$0a
	dc.b	$1b,'b',$08
	dc.b	'Hi to all the teams !',$0d,$0a
	dc.b	$1b,'b',$0f
	dc.b	$1b,'Y-%','Please wait... Loading now ...',$00,$90,$00,$00,$00,$00

	dcb.w	33

	dc.b	$55,$1f

zuend	end