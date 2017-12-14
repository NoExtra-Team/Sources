******************
*    UTILS.ASM   *
******************

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

; *************************************************************************
; ***             Clear a box in four bitplanes with BLITTER            ***
; ***                         Dracula/Positivity                        ***
; *************************************************************************
; Parameters:	a0.l = adress of the ramvideo.                              *
;	d0.w = x1.                                                              *
;	d1.w = y1.                                                              *
;	d2.w = x2.                                                              *
;	d3.w = y2.                                                              *
; *************************************************************************
clear_screen_4_bitplanes:
;	movem.l	d0-4/a0-1,-(sp)
  sub.w	d1,d3	; d3=dy=y2-y1.
  addq.w	#$1,d3	; d3=nb of h_lines to clear.
  move.w	d1,d4	; Multiply y1 by $a0.
  add.w	d1,d1
  add.w	d1,d1
  add.w	d4,d1
  lsl.w	#$5,d1
  add.w	d1,a0	; a0 points on the first line to clear.
  moveq.l	#-$10,d4	; inc_y_dest.
  and.w	d4,d0	; Care only about the words.
  and.w	d4,d2
  sub.w	d0,d2	; d2=(nb of words-1)*16.
  lsr.w	#$1,d0
  add.w	d0,a0	; a0 points on the first word.
  lsr.w	#$2,d2	; d2=nb of words-4.
  addq.w	#$4,d2	; d2=nb of words to clear.
  move.w	#$51,d0
  sub.w	d2,d0	; d0=inc_y_dest.
  lsl.w	#$1,d0	; It must be given in bytes.
  move.w	#$8a28,a1	; Base adress for the blitter.
  moveq.l	#-$1,d4
  move.l	d4,(a1)+	; Set all masks.
  move.w	d4,(a1)+
  move.w	#$2,(a1)+	; Inc_x_dest=2.
  move.w	d0,(a1)+	; Inc_y_dest=d0.
  move.l	a0,(a1)	; Adress for dest.
  move.w	d2,$4(a1)	; Nb of words per line.
  move.w	d3,$6(a1)	; Nb of h_lines per bitblock.
  move.w	#$200,$8(a1)	; Put everything to zero.
  move.b	#$c0,$a(a1)	; Launch the blitter.
;	movem.l	(sp)+,d0-4/a0-1
  rts

; *************************************************************************
; ***           Clear a screen in one bitplane with BLITTER             ***
; ***                          Zorro 2/NoExtra                          ***
; *************************************************************************
; Parameters:	a0.l = adress of the ramvideo.                              *
;	d0.w = number of lines.                                                 *
; *************************************************************************
clear_blitter_Halftone:
	lea.l $ffff8a00.w,a1             ; 32 bytes halftone ram to clear !
	rept 16/2
	clr.l (a1)+
	endr
	rts

******************************************
*                                        *
* Very! fast lz77 decompression routine  *
* 68000 version                          *
*                                        *
******************************************
******************************************
* Decompress data in a0 -> a1            *
* a0 : datas compressed                  *
* a1 : buffer destination                *
******************************************
 include "\FACE-B\utils\LZ77_130.ASM"
 even

******************************************
*                                        *
* LINE-A blitter fast routine            *
*                                        *
******************************************
******************************************
* a0 : FROM address screen               *
* a1 : TO address screen                 *
* d0 : LEFT 'to' position                *
* d1 : TOP 'to' position                 *
* d2 : WIDTH                             *
* d3 : HEIGHT                            *
* d4 : BITPLAN                           *
******************************************
DoBLiTTER__Copy_Buffer:
 move.l	a6,-(sp)                 ; preserve registers
 lea	bitblt(pc),a6              ; address of blit table
 move.l	a0,18(a6)                ; store 'from' address
 move.l	a1,32(a6)                ; store 'to' address
 move.w	#0,14(a6)                ; store left from position
 move.w	#0,16(a6)                ; store top from position
 move.w	d0,28(a6)                ; store left to position
 move.w	d1,30(a6)                ; store top to position
 move.w	d2,0(a6)                 ; store width. 
 move.w	d3,2(a6)                 ; store height.
 move.w	d4,4(a6)                 ; set up number of plan
 move.w	#8,22(a6)                ; for low resolution
 move.w	#8,36(a6)
 move.l	#0,42(a6)                ; set up blit variables 
 move.b	#3,10(a6)                ; for any resolution
 move.w	#0,6(a6)
 move.w	#0,8(a6)
 dc.w	$a007                      ; do the blit!
 move.l	(sp)+,a6                 ; restore registers
 rts                             ; and return.

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
 move.l	a6,-(sp)                 ; preserve registers
 lea	bitblt(pc),a6              ; Address of blit table
 move.w	d4,0(a6)                 ; Store width. 
 move.w	d5,2(a6)                 ; Store height.
 move.w	d6,4(a6)                 ; Set up number of plan
 move.w	#0,6(a6)                 ; Fg_col
 move.w	#0,8(a6)                 ; Bg_col
 move.b	#3,10(a6)                ; For any resolution
 move.w	d2,14(a6)                ; Store left from position
 move.w	d3,16(a6)                ; Store top from position
 move.l	a0,18(a6)                ; Store 'from' address
 move.w	#8,22(a6)                ; For low resolution (number of plane * 2)
 move.w	d0,28(a6)                ; Store left to position
 move.w	d1,30(a6)                ; Store top to position
 move.l	a1,32(a6)                ; Store 'to' address
 move.w	#8,36(a6)                ; Number of word by line
 move.l	#0,42(a6)                ; Set up blit variables 
 dc.w	$a007                      ; Do the blit!
 move.l	(sp)+,a6                 ; restore registers
 rts                             ; and return.

; Data for the Blit Routine
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
