*********************
*   UTILS.ASM       *
* \SHORTY\UTILS.ASM *
*********************

***************************************************************
*                    FADING WHITE TO BLACK                    *
*                  (Don't use VBL with it !)                  *
***************************************************************
fadein:
	move.l	#$777,d0
.deg:
	bsr.s	wart
	bsr.s	wart
	bsr.s	wart
	lea	$ffff8240.w,a0
	moveq	#16-1,d1
.chg1:
	move.w	d0,(a0)+
	dbf	d1,.chg1
	sub.w	#$111,d0
	bne.s	.deg
	rts

***************************************************************
*                            VSYNC()                          *
***************************************************************
wart:
	move.l	d0,-(sp)
	move.l	$466.w,d0
.att:
	cmp.l	$466.w,d0
	beq.s	.att
	move.l	(sp)+,d0
	rts

***************************************************************
*                   Flash with WHITE colour                   *
***************************************************************
* d3 : tempo (0..6)                                           *
***************************************************************
flash_blanc:
	move.w	#$fff,$ff8240.l
.loop_flash:
	subi.w	#$888,$ff8240.l 
 rept 2
	jsr Wait_vbl
 endr
	addi.w	#$777,$ff8240.l 
 rept 2
	jsr Wait_vbl
 endr
	dbf	d3,.loop_flash
	rts

***************************************************************
*                           PAUSE-TIMER                       *
***************************************************************
* d7 : timing ($0..$fff)                                      *
***************************************************************
tempo:
	move.w	#$ff,d7
wait_more:
	bsr	Wait_vbl
	dbra	d7,wait_more
	rts

***************************************************************
*                           FADE UP                           *
***************************************************************
* a0 : palette source                                         *
***************************************************************
fade_up:
	moveq #0,d7          ; initial max R value
	moveq #0,d6          ; initial max G value
	moveq #0,d5          ; initial max B value
	moveq #7,d3          ; 8 fades (from 0 to 7)
	move.l a0,-(sp)      ; save pallete pointer
.2:
	moveq #15,d4         ; 16 colours
	move.l (sp),a0       ; get pallete pointer
	lea $ffff8240.w,a1   ; point to screen pallete
 rept 2-1
	jsr Wait_vbl         ; wait a while
 endr
.1:
	move.w (a0)+,d0      ; get a colour from pallete
	move.w d0,d1         ; copy
	move.w d0,d2         ; copy
	and.w #$700,d0       ; split R value
	and.w #$070,d1       ; split G value
	and.w #$007,d2       ; split B value
	cmp.w d0,d5          ; Is fade value higher than R value?
	bgt.s .3
	move.w d5,d0         ; If not, make colour = fade value
.3:
	cmp.w d1,d6          ; Is fade value higher than G value?
	bgt.s .4
	move.w d6,d1         ; If not, make colour = fade value
.4:
	cmp.w d2,d7          ; Is fade value higher than B value?
	bgt.s .5
	move.w d7,d2         ; If not, make colour = fade value
.5:
	or.w d2,d1           ; merge G and B
	or.w d1,d0           ; merge R, G and B
	move.w d0,(a1)+      ; display RGB value
	dbf d4,.1            ; next colour
	add.w #$100,d5       ; fade up 1 R value (max)
	add.w #$010,d6       ; fade up 1 G value (max)
	add.w #$001,d7       ; fade up 1 B value (max)
	dbf d3,.2            ; next fade
	tst.l (sp)+          ; tidy stack
	rts

***************************************************************
*                put ONE Color To the palette                 *
***************************************************************
* myColor.l : $00000000 .. $0fff0fff                          *
***************************************************************
clear_palette:
	move.l     myColor,d0           ; Clear Palette
	move.l     myColor,d1           ;
	move.l     myColor,d2           ;
	move.l     myColor,d3           ;
	move.l     myColor,d4           ;
	move.l     myColor,d5           ;
	move.l     myColor,d6           ;
	move.l     myColor,d7           ;
	movem.l    d0-d7,$ffff8240.w    ;
	rts
myColor:
	ds.l	1

***************************************************************
*                 Fades all colours to black                  *
***************************************************************
* a0 : palette source                                         *
* d2 : compteur de couleur                                    *
***************************************************************
fade_down:move.w  (A0),D0
          and.w   #%111,D0
          beq.s   col2
          subq.w  #1,D0
          move.w  (A0),D1
          and.w   #%1111111111111000,D1
          or.w    D0,D1
          move.w  D1,(A0)
          bra.s   colok
col2:     move.w  (A0),D0
          and.w   #%1110000,D0
          beq.s   col3
          sub.w   #$10,D0
          move.w  (A0),D1
          and.w   #%1111111110001111,D1
          or.w    D0,D1
          move.w  D1,(A0)
          bra.s   colok
col3:     move.w  (A0),D0
          and.w   #%11100000000,D0
          beq.s   colok
          sub.w   #$0100,D0
          move.w  (A0),D1
          and.w   #%1111100011111111,D1
          or.w    D0,D1
          move.w  D1,(A0)
colok:    lea     2(A0),A0
          dbra    D2,fade_down
          rts

******************************************
*                                        *
* LINE-A / BITBLT blitter fast routine   *
*                                        *
******************************************
* a0 : FROM address                      *
* a1 : TO address                        *
* d0 : LEFT 'to' position                *
* d1 : TOP 'to' position                 *
* d2 : LEFT 'from' position              *
* d3 : TOP 'from' position               *
* d4 : WIDTH                             *
* d5 : HEIGHT                            *
* d6 : BITPLAN                           *
******************************************
DoBLiTTER__Operation:
 move.l	a6,-(sp)    ; preserve registers
 lea	bitblt(pc),a6 ; Address of blit table
 move.w	d4,0(a6)    ; Store width. 
 move.w	d5,2(a6)    ; Store height.
 move.w	d6,4(a6)    ; Set up number of plan
 move.w	#0,6(a6)    ; Fg_col
 move.w	#0,8(a6)    ; Bg_col
 move.b	#3,10(a6)   ; For any resolution
 move.w	d2,14(a6)   ; Store left from position
 move.w	d3,16(a6)   ; Store top from position
 move.l	a0,18(a6)   ; Store 'from' address
 move.w	#8,22(a6)   ; For low resolution (number of plane * 2)
 move.w	d0,28(a6)   ; Store left to position
 move.w	d1,30(a6)   ; Store top to position
 move.l	a1,32(a6)   ; Store 'to' address
 move.w	#8,36(a6)   ; Number of word by line
 move.l	#0,42(a6)   ; Set up blit variables 
 dc.w	$a007         ; Do the blit!
 move.l	(sp)+,a6    ; restore registers
 rts                ; and return.

; Data for the BITBLT Routine
bitblt:
 DC.W	0       ; Width                        * 0
 DC.W	0       ; Height                       * 2
 DC.W	0       ; No. Planes                   * 4
 DC.W	0       ; Fg_col                       * 6
 DC.W	0       ; Bg_col                       * 8
 DC.L	0       ; Log. ops                     * 10 & 12
 DC.W	0       ; Left source x                * 14
 DC.W	0       ; Top source y                 * 16
 DC.L	0       ; Source screen top address    * 18 & 20
 DC.W	8       ; Word in line (8=low 4=med)   * 22
 DC.W	160     ; 160 for med/low              * 24
 DC.W	2       ;                              * 26
 DC.W	0       ; Left dest x                  * 28
 DC.W	0       ; Top dest y                   * 30
 DC.L	0       ; Dest screen top address      * 32 & 34
 DC.W	8       ; Word in line                 * 36
 DC.W	160     ; Line in plane                * 38
 DC.W	2       ;                              * 40
 DC.L	0       ; Pattern Address              * 42 & 44
 DC.W	0       ;                              * 46
 DC.W	0       ;                              * 48
 DC.W	0       ;                              * 50
 DCB.W	100,$0  ; Filler                       * 52 -> 152
 even

******************************************
* Clear a BOX in 2 bitplanes             *
******************************************
* a0 : screen destination                *
******************************************
Clear_two_bitplanes:
  moveq.l	#$0,d0
	movea.l	physique(pc),a0
  add.l	#160*73+8*7,a0
	move.w	#54-1,d3
.clear:
N set 0
 rept	6
  move.l	d0,N(a0)
N set N+8
 endr
  add.w	#160,a0
  dbra	d3,.clear
  rts

******************************************
* Assign Palette                         *
******************************************
* a0 : palette of the screen             *
******************************************
Assign_palette:
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d7               ;
	movem.l	d0-d7,(a1)               ;
	rts
