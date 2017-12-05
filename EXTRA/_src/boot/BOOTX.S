;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;            Raster Text Boot-sector             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;        (C)oderight Zorro 2/NoExtra - 2007      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	OPT	o+

BOOT	equ	1

	addq.l	#4,4(sp)		; On passe le test HD sur STE
	
	IFEQ	BOOT
	clr.l	-(sp)
	move.w	#$20,-(sp)
	trap	#1
	move.l	d0,2(sp)
	bsr.s	start
	trap	#1
	clr.w	(sp)
	trap	#1
start:
	ENDC

	move.b	$fffa09,sav_mfp
	clr.b	$fffa09
	pea	texte(pc)
	move	#$9,-(sp)
	trap	#1

	move	#0,d4
	move	#$a0,d5
	clr.b	$484
	move	 #0,d1

test:
	cmpi.b	#$39,$fffC02
	beq	fin
	cmp	 #$7f,d1
	beq fin

	add	#1,d1

	lea	raster(pc),a3
	move	#$ffff,$50(a3)
boucle:	dbf	d4,boucle
	move	d5,d4
	move.w	(a3)+,$ff8240
	cmpi.w	#$ffff,(a3)
	beq	test
	bra.s	boucle

fin:
	move.b	sav_mfp,$fffa09
	move	#$777,$ff8240
	move.b	#$f,$484
	addq.l	#6,a7
	rts

	SECTION DATA

texte:
	dc.b 	$1b,$45
	dc.b	"Compilation ",$1b,$70,">EXTRA<",$1b,$71
	dc.b	" Volume X.",$d,0
	even

raster:
	dc.b $07,$00,$07,$10,$07,$20,$07,$30,$07,$40,$07,$50,$07,$60,$07,$70,$06,$70
	dc.b $05,$70,$04,$70,$03,$70,$02,$70,$01,$70,$00,$70,$00,$71,$00,$72,$00,$73
	dc.b $00,$74,$00,$75,$00,$76,$00,$77,$00,$67,$00,$57,$00,$47,$00,$37,$00,$27
	dc.b $00,$17,$00,$07,$01,$07,$02,$07,$03,$07,$04,$07,$05,$07,$06,$07,$07,$07
	dc.b $07,$06,$07,$05,$07,$04,$07,$03
	even

	SECTION BSS

sav_mfp:
	ds.w	1
	even	

	IFEQ	BOOT
	END
	ENDC
