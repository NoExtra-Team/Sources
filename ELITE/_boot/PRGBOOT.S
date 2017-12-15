;BOOT SECTOR v 1.0 for Maartau
;(c)Zorro2/NoExtra in 2011

	opt    	 X+
	
	move.l   #finprg,d0
	sub.l	 #prg,d0
	cmp.w	 #452,d0
	bgt	 fin
	
	move.w	 #1,-(sp)
	move.w	 #0,-(sp)
	move.w	 #0,-(sp)
	move.w	 #1,-(sp)
	move.w	 #0,-(sp)
	clr.l	 -(sp)
	move.l	 #buffer,-(sp)
	move.w	 #8,-(sp)
	trap	 #14
	lea	 20(sp),sp
	
	lea	 buffer,a0
	move.w	 #$601c,(a0)
	move.w	 #'ZO',2(a0)
	move.l	 #'RRO2',4(a0)
	
	lea	 prg,a1
	lea	 finprg,a2
	lea	 30(a0),a3
bcl	move.b	 (a1)+,(a3)+	
	cmp.l	 a1,a2
	bhi	 bcl
	
	clr.w	 510(a0)
	lea	 buffer,a1
	move.w	 #$ff,d7
	moveq.l	 #0,d0
cheksum	add.w	 (a1)+,d0
	dbf	 d7,cheksum

	move.w	 #$1234,d1
	sub.w	 d0,d1
	move.w	 d1,510(a0)
	
	move.w	 #1,-(sp)
	move.w	 #0,-(sp)
	move.w	 #0,-(sp)
	move.w	 #1,-(sp)
	move.w	 #0,-(sp)
	clr.l	 -(sp)
	move.l	 #buffer,-(sp)
	move.w	 #9,-(sp)
	trap	 #14
	lea	 20(sp),sp
	
fin	clr.w	 -(sp)
	trap 	 #1
	
prg	include "BOOT00.S"
finprg
        section bss
	
buffer	ds.b	 512				