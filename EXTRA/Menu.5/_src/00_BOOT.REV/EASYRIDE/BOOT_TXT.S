	text
begin
	bra.s	l0000
	dc.b	$00,$00,'JSNN',$00,$00
	dc.b	$00,$00,$02,$02,$01,$00,$02,'p'
	dc.b	$00,'T',$06,$f9,$05,$00,$0a,$00
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

l0001	dc.b	$1b,'E',$1b,'b',$01,$1b,'Y '
	dc.b	'(The BMG'
	dc.b	' members'
	dc.b	' are :',$0d,$0a
	dc.b	$0d,$0a,$1b,'b',$02,'STr'
	dc.b	'ix (maST'
	dc.b	'er codin'
	dc.b	'g),STeph'
	dc.b	'y (Musix'
	dc.b	'),',$0d,$0a,$1b,'b',$03,'A'
	dc.b	'takid (G'
	dc.b	'FX),STri'
	dc.b	'ker,PaCe'
	dc.b	'r (Code '
	dc.b	'on PC)',$0d,$0a
	dc.b	$1b,'b',$04,'Hi to'
	dc.b	' Eric,St'
	dc.b	'allion,R'
	dc.b	'unpower,'
	dc.b	'Alien...'
	dc.b	$1b,'b',$05,$1b,'Y& S'
	dc.b	'pecial g'
	dc.b	'reetings'
	dc.b	' to :',$0d,$0a,$1b
	dc.b	'b',$06,'~ COUN'
	dc.b	'T-ZERO,M'
	dc.b	'AD-MAX,T'
	dc.b	'HALION,T'
	dc.b	'EX,IMPAC'
	dc.b	'T',$0d,$0a,$1b,'b',$07,'~ '
	dc.b	'Charlott'
	dc.b	'e,the gi'
	dc.b	'rl of my'
	dc.b	' heart..'
	dc.b	'.',$0d,$0a,$1b,'b',$08,'Hi'
	dc.b	' to all '
	dc.b	'the team'
	dc.b	's !',$0d,$0a,$1b,'b',$0f
	dc.b	$1b,'Y-%Plea'
	dc.b	'se wait.'
	dc.b	'.. Loadi'
	dc.b	'ng now .'
	dc.b	'..',$00,$90,$00,$00,$00,$00
	dcb.w	33
	dc.b	'U',$1f
zuend	end
