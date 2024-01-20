******************************************
*     LINE-A : Transfert memory bloc     *
******************************************
*            Zorro 2/NoExtra             *
*----------------------------------------*
* Parameters                             *
*----------------------------------------*
* a0 : FROM address screen               *
* a1 : TO address screen                 *
* d0 : LEFT 'to' position    (0..320)    *
* d1 : TOP 'to' position     (0..200)    *
* d2 : WIDTH                 (0..320)    *
* d3 : HEIGHT                (0..200)    *
* d4 : BITPLAN               (1..4)      *
******************************************
DoBLiTTER__Copy_Buffer:
 move.l	a6,-(sp)                 ; preserve registers
 lea	bitblt_COPY(pc),a6         ; address of blit table
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
 rts    

*****************************
* Data for the Blit Routine *
*****************************
bitblt_COPY:
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
 DCB.W	100,$0  ; Filler                     * 52 -> 152
*************************
* End of BLIT Data      *
*************************
 EVEN
