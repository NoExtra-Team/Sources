***********************************
*   Spectrum Analyser routines    *
***********************************
* Original version ATOMUS/NOEX    *
* Fixed by ANGEL/HMD              *
*---------------------------------*
* Parameters                      *
*---------------------------------*
PLAN_EQU equ 6-2                  *
POS_EQUA equ 160*198+8*2+PLAN_EQU *
NBL equ 32/2                      *
WIDTHe equ $FF/4                  *
HEIGHTe equ 0                     *
sizeBD equ 8*2                    *
SMALLs equ 0                      *
***********************************
Play_digits:
	moveq     #0,d0	; inits
	moveq     #0,d1	;
	move.b    #0,$ff8800.l
	move.b    $ff8800.l,d0
	lsr.w     #3,d0
	lsl.w     #1,d0
	move.b    #8,$ff8800.l ; Voie A
	move.b    $ff8800.l,d1
 IFEQ	HEIGHTe
	lsl.w   #1,d1
 ENDC
	movea.l   #Buffer_D,a0 
	adda.w    d0,a0 
	move.w    d1,(a0) 
	move.b    #2,$ff8800.l
	move.b    $ff8800.l,d0
	lsr.w     #3,d0
	lsl.w     #1,d0
	move.b    #9,$ff8800.l ; Voie B
	move.b    $ff8800.l,d1
 IFEQ	HEIGHTe
	lsl.w     #1,d1
 ENDC
	movea.l   #Buffer_D,a0 
	adda.w    d0,a0 
	move.w    d1,(a0) 
	move.b    #4,$ff8800.l
	move.b    $ff8800.l,d0
	lsr.w     #3,d0
	lsl.w     #1,d0
	move.b    #$a,$ff8800.l ; Voie C
 IFEQ	HEIGHTe
	lsl.w     #1,d1
 ENDC
	move.b    $ff8800.l,d1
	movea.l   #Buffer_D,a0 
	adda.w    d0,a0 
	move.w    d1,(a0) 
.clear_spectrum:
	movea.l   physique(pc),a0 
	adda.w    #POS_EQUA,a0
	moveq     #NBL,d0 
	moveq     #0,d1 
.clear:
i set 0
 rept 20-4
	move.w    d1,i(a0) 
i set i+8
 endr
	suba.w    #160,a0 
	dbf       d0,.clear
.display_spectrum:
	move.w    #0,Pointer_D
	lea       Buffer_D,a0
	move.w    #sizeBD-1,d7 
.calc:
	move.w    (a0)+,d0
	cmp.w     #0,d0 
	beq.s     .add_1 
	subi.w    #1,-2(a0) 
	bsr       Display_digits 
.add_1:
	addq.w    #1,Pointer_D
	move.w    (a0)+,d0
	cmp.w     #0,d0 
	beq.s     .add_7 
	subi.w    #1,-2(a0) 
	bsr       Display_digits 
.add_7:
	addq.w    #7,Pointer_D
	dbf       d7,.calc
	rts 

Display_digits:
 IFEQ	SMALLs
	lsr.w     #1,d0 ; height DIV 2 / 16 -> 8 height
 ENDC
	movea.l   physique(pc),a1 
	adda.w    #POS_EQUA,a1
	adda.w    Pointer_D,a1
	move.b    #WIDTHe,d3 ; width of spectrum
	move.w    #160,d4 
.fill:
	move.b    d3,(a1) 
	suba.w    d4,a1
	dbf       d0,.fill
	rts

Buffer_D:
	dcb.w	sizeBD*2,$0
Pointer_D:
	dc.w	0
	even