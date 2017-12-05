; ecriture du boot-sector

ON_SEN_FOUT equ 1

	OPT	w-
	
	IFEQ ON_SEN_FOUT
	move.l   #finprg,d0
	sub.l	 #prg,d0
	cmp.w	 #452,d0
	bgt	 erreur
	ENDC
	
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
	move.l	 #'NOEX',2(a0)
	move.l	 #'TRA ',6(a0)
	
	lea	 prg,a1
	lea	 finprg,a2
	lea	 30(a0),a3
bcl:
	move.b	 (a1)+,(a3)+	
	cmp.l	 a1,a2
	bhi	 bcl
	
	clr.w	 510(a0)
	lea	 buffer,a1
	move.w	 #$ff,d7
	moveq.l	 #0,d0
cheksum:
	add.w	 (a1)+,d0
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
	
exit:
	clr.w	 -(sp)
	trap 	 #1

	IFEQ ON_SEN_FOUT
errtext:DC.B "DEPASSEMENT DE CAPACITE...",13,10,10,0
	EVEN

gemdos        equ	1
crawcin       equ	7
cconws        equ	9

erreur:
	pea        errtext       ;Affichage du message d'erreur
	move.w     #cconws,-(sp)
	trap       #gemdos
	addq.l     #6,sp

	move.w     #crawcin,-(sp)          ;Attendre appui touche...
	trap       #gemdos
	addq.l     #2,sp

	bra.s	exit
	ENDC
	
prg:
 include "BOOTX.S"
finprg

	section bss
	
buffer:
	ds.b	 512

	end
	