;		opt	x+
;========================================
		text
;========================================
begin		dc.w	$a00a

		pea	startgfx+2
		move.w	#6,-(sp)		;setpallete
		trap	#14
		addq.l	#6,sp

		move.w	#2,-(sp)		;physbase
		trap	#14
		addq.l	#2,sp

		movea.l	d0,a0
		lea	startgfx+34,a1
		move.w	#$1f3f,d1
l0007		move.l	(a1)+,(a0)+
		dbf	d1,l0007

		move.l	#sample,replay+$1c+2
		move.l	#$27d8,replay+$1c+2+4
		move.l	#2,replay+$1c+2+4+4
		jsr	replay+$1c

		clr.l	-(sp)
		trap	#1
;========================================
startgfx	incbin	start.pi1

sample		incbin	sample

replay		incbin	replay.prg
;========================================
zuend		end
;========================================