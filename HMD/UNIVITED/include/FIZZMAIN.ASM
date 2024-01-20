********************************
*      FIZZ Display Effect     *
********************************
*         ATOMUS/NOEXTRA       *
*------------------------------*
* Parameters                   *
*------------------------------*
nb_line equ 200 ; to display   *
********************************
fizz_display:
		move.w	#nb_line-1,d7
.rand_loop
		move.w	#$11,-(a7)
		trap	#14
		addq.l	#2,a7
		andi.w	#$1f,d0
		move.b	d0,(a5)+
		dbf	d7,.rand_loop

repeat:
		lea	-nb_line(a5),a5
		clr.w	d7
		move.w	#nb_line/2-1,d6
looping:
		subq.b	#1,(a5)+
		bpl	step3
		move.b	-1(a5),d0
		ext.w	d0
		addi.w	#20,d0
		bpl.s	step1
		addq.w	#1,d7
		addq.b	#1,-1(a5)
		bra.s	step3
step1:
		asl.w	#3,d0
		lea	0(a4,d0.w),a0
		lea	160-8(a3),a1
		move.w	#18,d0
step2:
		move.l	-4(a1),4(a1)
		move.l	-8(a1),(a1)
		lea	-8(a1),a1
		dbf	d0,step2
		move.l	4(a0),4(a1)
		move.l	(a0),(a1)
step3:
		lea	160(a3),a3
		lea	160(a4),a4
		subq.b	#1,(a5)+
		bpl	step6
		move.b	-1(a5),d0
		ext.w	d0
		not.w	d0
		cmp.w	#20,d0
		bne.s	step4
		addq.w	#1,d7
		addq.b	#1,-1(a5)
		bra.s	step6
step4:
		asl.w	#3,d0
		lea	0(a4,d0.w),a0
		lea	(a3),a1
		move.w	#18,d0
step5:
		move.l	8(a1),(a1)
		move.l	$c(a1),4(a1)
		lea	8(a1),a1
		dbf	d0,step5
		move.l	(a0),(a1)
		move.l	4(a0),4(a1)
step6:
		lea	160(a3),a3
		lea	160(a4),a4
		dbf	d6,looping
		lea	-160*nb_line(a3),a3
		lea	-160*nb_line(a4),a4
		cmp.w	#nb_line,d7
		bne	repeat
		rts

fizz_undisplay:
    moveq     #$d,d7
    clr.l     d6
    lea       trames,a5
    lea       Buffer_Color,a6
    move.w    #$f9ff,d4 
.loop:
    mulu      #$321,d6
    add.l     d7,d6 
    divu      #$fa00,d6 
    swap      d6
    move.w    d6,d0 
    move.w    d0,d1 
    lsr.w     #1,d1  
    andi.w    #$fff8,d1 
    andi.w    #$f,d0
    add.w     d0,d0 
    move.w    0(a5,d0.w),d0 
    and.w     d0,0(a2,d1.w) 
    and.w     d0,2(a2,d1.w) 
    and.w     d0,4(a2,d1.w) 
    and.w     d0,6(a2,d1.w) 
    dbf       d4,.loop
    rts 

trames:
	dc.b	$7f,$ff,$bf,$ff,$df,$ff,$ef,$ff 
	dc.b	$f7,$ff,$fb,$ff,$fd,$ff,$fe,$ff 
	dc.b	$ff,$7f,$ff,$bf,$ff,$df,$ff,$ef 
	dc.b	$ff,$f7,$ff,$fb,$ff,$fd,$ff,$fe 
	even