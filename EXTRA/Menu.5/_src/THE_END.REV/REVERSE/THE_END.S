;	opt	x+
;========================================
	text
;========================================
begin	dc.w	$a00a

	pea	l000a+2
	move.w	#6,-(sp)		;setpallete
	trap	#14
	addq.l	#6,sp

	move.w	#2,-(sp)		;physbase
	trap	#14
	addq.l	#2,sp

	movea.l	d0,a0
	lea	l000a+34,a1
	move.w	#$1f3f,d1
l0000	move.l	(a1)+,(a0)+
	dbf	d1,l0000

	move.l	#l000c,l000d+28+2
	move.l	#$49e6,l000d+28+2+4
	move.l	#0,l000d+28+2+4+4

	jsr	l000d+28

	pea	l0003
	move.w	#6,-(sp)		;setpallete
	trap	#14
	addq.l	#6,sp

	bsr	l0002

	pea	l0004
	move.w	#6,-(sp)		;setpallete
	trap	#14
	addq.l	#6,sp

	bsr	l0002

	pea	l0005
	move.w	#6,-(sp)		;setpallete
	trap	#14
	addq.l	#6,sp

	bsr	l0002

	pea	l0006
	move.w	#6,-(sp)		;setpallete
	trap	#14
	addq.l	#6,sp

	bsr	l0002

	pea	l0007
	move.w	#6,-(sp)		;setpallete
	trap	#14
	addq.l	#6,sp

	bsr	l0002

	pea	l0008
	move.w	#6,-(sp)		;setpallete
	trap	#14
	addq.l	#6,sp

	bsr	l0002

	pea	l0009
	move.w	#6,-(sp)		;setpallete
	trap	#14
	addq.l	#6,sp

	bsr	l0002

	clr.l	-(sp)
	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp
	move.l	d0,-(sp)

	move.l	#0,$426.l

	move.w	#$20,-(sp)		;super
	trap	#1
	addq.l	#6,sp

	clr.l	-(sp)
	trap	#1
;========================================
l0001	move.w	#$25,-(sp)		;vsync
	trap	#14
	addq.l	#2,sp
	rts

l0002	bsr	l0001
	bsr	l0001
	bsr	l0001
	bsr	l0001
	rts

l0003	dc.b	$00,$00,$00,$04,$00,$06,$00,$16
	dc.b	$00,$26,$05,$55,$04,$44,$03,$33
	dc.b	$02,$22,$06,$00,$05,$56,$04,$45
	dc.b	$03,$34,$02,$23,$06,$60,$06,$66
l0004	dc.b	$00,$00,$00,$03,$00,$05,$00,$05
	dc.b	$00,$15,$04,$44,$03,$33,$02,$22
	dc.b	$01,$11,$05,$00,$04,$45,$03,$34
	dc.b	$02,$23,$01,$12,$05,$50,$05,$55
l0005	dc.b	$00,$00,$00,$02,$00,$04,$00,$04
	dc.b	$00,$04,$03,$33,$02,$22,$01,$11
	dc.b	$00,$00,$04,$00,$03,$34,$02,$23
	dc.b	$01,$12,$00,$01,$04,$40,$04,$44
l0006	dc.b	$00,$00,$00,$01,$00,$03,$00,$03
	dc.b	$00,$03,$02,$22,$01,$11,$00,$00
	dc.b	$00,$00,$03,$00,$02,$23,$01,$12
	dc.b	$00,$01,$00,$00,$03,$30,$03,$33
l0007	dcb.w	2
	dc.b	$00,$02,$00,$02,$00,$02,$01,$11
	dcb.w	3
	dc.b	$02,$00,$01,$12,$00,$01,$00,$00
	dc.b	$00,$00,$02,$20,$02,$22
l0008	dcb.w	2
	dc.b	$00,$01,$00,$01,$00,$01,$00,$00
	dcb.w	3
	dc.b	$01,$00,$00,$01,$00,$00,$00,$00
	dc.b	$00,$00,$01,$10,$01,$11
l0009	dcb.w	31
	dc.b	$07,$77

l000a	incbin	l000a.pi1
l000c	incbin	l000c
l000d	incbin	replay.prg
;========================================
zuend	end
;========================================