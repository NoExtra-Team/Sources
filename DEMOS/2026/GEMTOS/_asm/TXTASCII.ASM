; *************************************************************************
; ***        Print extended ASCII text font 3*5 in One Bitplane         ***
; *************************************************************************
; ***                         Atomus / NoExtra                          ***
; *************************************************************************
print_textASCII:
	movem.l	null,d0-a6
	move.l	physique(pc),a5     ; Screen #1
	add.l	#160*28,a5
	bsr.s	.lets_go
	movem.l	null,d0-a6
	move.l	physique+4(pc),a5   ; Screen #2
	add.l	#160*28,a5
.lets_go:
	lea	message,a1
chg:
	move.l	a5,a4
wrp:
	move.l	a4,a0
	lea	ascii,a2
	lea	petite_fonte,a3
	move.b	(a1)+,d0
	beq	bcl1
	cmpi.b	#1,d0
	bne.s	nch
	lea	160*6(a5),a5
	moveq	#0,d5
	bra.s	chg
nch:
	cmp.b	(a2)+,d0
	beq.s	post
	addq.l	#4,d6
	bra.s	nch
post:
	move.l	(a3,d6.w),d0
	moveq	#0,d6
	move.l	d0,d4
	swap	d4
	move.l	d0,d1
	lsr.w	#4,d1
	move.l	d1,d2
	lsr.w	#4,d2
	move.l	d2,d3
	lsr.w	#4,d3
	andi.l	#$f,d0
	andi.l	#$f,d1
	andi.l	#$f,d2
	andi.l	#$f,d3
	andi.l	#$f,d4
	addq.b	#1,d5
	cmpi.b	#1,d5
	beq.s	pos1
	cmpi.b	#2,d5
	beq.s	pos2
	cmpi.b	#3,d5
	beq.s	pos3
	moveq	#0,d5
	addq.l	#8,a4	
	bra.s	rin
pos1:
	lsl.w	#4,d0
	lsl.w	#4,d1
	lsl.w	#4,d2
	lsl.w	#4,d3
	lsl.w	#4,d4
pos2:
	lsl.w	#4,d0
	lsl.w	#4,d1
	lsl.w	#4,d2
	lsl.w	#4,d3
	lsl.w	#4,d4
pos3:
	lsl.w	#4,d0
	lsl.w	#4,d1
	lsl.w	#4,d2
	lsl.w	#4,d3
	lsl.w	#4,d4
rin:
	or.w	d4,(a0)
	or.w	d3,160(a0)
	or.w	d2,320(a0)
	or.w	d1,480(a0)
	or.w	d0,640(a0)
	bra	wrp
bcl1:
	rts

null:
	ds.l	16
petite_fonte:
	dc.l	$0004aeaa ; a
	dc.l	$000cacac ; b
	dc.l	$00068886 ; c
	dc.l	$000caaac ; d
	dc.l	$00068c8e ; e
	dc.l	$000e8c88 ; f
	dc.l	$00068aa6 ; g
	dc.l	$000aaeaa ; h
	dc.l	$000e444e ; i
	dc.l	$000222a4 ; j
	dc.l	$000aacaa ; k
	dc.l	$00088886 ; l
	dc.l	$000aeeaa ; m
	dc.l	$000caaaa ; n
	dc.l	$000eaaae ; o
	dc.l	$000cac88 ; p
	dc.l	$000caaa6 ; q
	dc.l	$000eacaa ; r
	dc.l	$0006842c ; s
	dc.l	$000c2222 ; t
	dc.l	$000aaaa4 ; u
	dc.l	$000aaaa4 ; v
	dc.l	$000aaaea ; w
	dc.l	$000aa4aa ; x
	dc.l	$000aa444 ; y
	dc.l	$000e248e ; z
	dc.l	$00000000 ; ESPACE
	dc.l	$0004aaa4 ; 0
	dc.l	$000c444e ; 1
	dc.l	$000ea2ce ; 2
	dc.l	$000e242e ; 3
	dc.l	$00088ae2 ; 4
	dc.l	$000e8c2c ; 5
	dc.l	$00068eae ; 6
	dc.l	$000e2488 ; 7
	dc.l	$000ea4ae ; 8
	dc.l	$000eae2c ; 9
	dc.l	$00004040 ; :
	dc.l	$00044404 ; !
	dc.l	$00000448 ; ,
	dc.l	$00004048 ; ;
	dc.l	$00000004 ; .
	dc.l	$0004a244 ; ?
	dc.l	$00044000 ; '
	dc.l	$00024488 ; /
	dc.l	$00088442 ; \
	dc.l	$0000000e ; _
	dc.l	$00000e00 ; -
	dc.l	$00024842 ; (
	dc.l	$00084248 ; )
	dc.l	$00044444 ; |
	dc.l	$000cc000 ; #
	dc.l	$0000a4a0 ; *
	dc.l	$00084248 ; >
	dc.l	$00024842 ; <
	dc.l	$000c888c ; [
	dc.l	$00062226 ; ]
	dc.l	$0004e000 ; ^
	dc.l	$0000000e ; _
	dc.l	$000e0000 ; ~
	dc.l	$000a0000 ; A
	dc.l	$00004e40 ; +
	dc.l	$0000eace ; @
	dc.l	$00004200 ; `
	even

ascii:
	dc.b	"abcdefghijklmnopqrstuvwxyz 0123456789:!,;.?'/\_-()|#*><[]^_~A+@`",0
	even

message:	*	80 caractères sur 22 lignes
*      +                                                                              +
 dc.b	"                                .                                               ",1
 dc.b	"                                 .                                              ",1
 dc.b	"                               .:                                               ",1
 dc.b	"                              :                                                 ",1
 dc.b	"                             ::                                                 ",1
 dc.b	"                            ::         n   o   *   e   x   t   r   a            ",1
 dc.b	"               ______ \ __   :::.                                               ",1                              
 dc.b	"               \_ _  \____.    :::                                              ",1
 dc.b	"               /  /  /    \.:::::   _     ___                                   ",1
 dc.b	"              /  /  /  /  /\:::____  \   /  /\                                  ",1
 dc.b	"             /  /  /  /  / / :\_ _  \___/  / /                                  ",1
 dc.b	"          __ \_/__/  /  / /  :/  /  /  /  /_/__   __   _____________  __        ",1
 dc.b	"              \\__\____/ /  :/ ____/>   _/_  __\__  \__                         ",1
 dc.b	"               -   \___\/  :/  /  /-   < \/  // _ \_____                        ",1
 dc.b	"                          .:\____/  /  /\/  //  /__/    \                       ",1
 dc.b	"                  \ ____ .::.\__/  /__/ /  //  /\_\__/  /\                      ",1
 dc.b	"                         \ ::. /  /\__\/\_</  / //     / /                      ",1
 dc.b	"          __ __ __________  :: \_/ /     \_\_/ //  /  / / _ _________           ",1
 dc.b	"                           :::  \\/  __     \\/ \____/ / sk!n                   ",1
 dc.b	"                          ::     -     \     -   \___\/                         ",1
 dc.b	"                         ::              -   \__                                ",1
 dc.b	"                        :                                                       ",1
 dc.b	"                         .                                                      ",1,1,1
 dc.b "                 a little'tro for a great atari event in france!                ",1,1,1
 dc.b "                                                                                ",$ff
 even 
