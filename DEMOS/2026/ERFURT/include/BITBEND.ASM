; *************************************************************************
; ***         Routine Bit Bender/Sinus Scroller in one bitplane         ***
. ***	        Updare buffer and plot bit bender onto the screen         ***
; *************************************************************************
; ***                     Griff/IC and Atomus/NoExtra                   ***
; *************************************************************************
; Parameters                                                              *
; ------------------------------------------------------------------------*
; *************************************************************************
SpeedB  EQU 02 ; Scroll speed                                             *
HZoomB	EQU 01 ; Zoom Height font                                         *
ASinusB EQU 46 ; Amplitude Sinus                                          *
VSinusB EQU 03 ; Vitesse Sinus                                            *
; *************************************************************************
display_Bitbend:
	move.l scrlpoint(pc),a0          ; text ptr
	move.w scrloffset(pc),d1         ; offset with text
	clr d0
	move.b (a0),d0
	sub.b #32,d0
	lsl #5,d0
	lea font32(pc),a2
	add d1,d0
	add d0,a2                        ; point to current strip
	move buff_ptr(pc),d2
	add #8*SpeedB,d2                  ; advance buffer postion
	cmp #(320-SpeedB)*8,d2
	ble.s .no_loop
	clr d2
.no_loop:
	move.w d2,buff_ptr               ; save buffer pos
	lea buffer(pc),a1
	add buff_ptr(pc),a1
i	set 0
 rept SpeedB                        ; now add strip to buffer
	clr d0
	move.b (a2)+,d0
	add d0,d0
	add d0,d0
	lea jmptab1(pc),a4               ; but we add rout address!!
	add d0,a4
	move.l (a4),i+(320-SpeedB)*8(a1)
	move.l (a4),i-(8*SpeedB)(a1)
	clr d0
	move.b (a2)+,d0
	add d0,d0
	add d0,d0
	lea jmptab2(pc),a4               ; byte 2 rout address
	add d0,a4
	move.l (a4),i+4+(320-SpeedB)*8(a1)
	move.l (a4),i+4-(8*SpeedB)(a1)
i	set i+8
 endr
	add #2*SpeedB,d1                  ; advance pos within char
	cmp #32,d1
	blt.s .notnext                   ; onto next letter?
	clr.w d1
	addq.l #1,a0                     ; yes, add one to textptr
	tst.b (a0)                       ; wrap?
	bne.s .notnext
	lea text(pc),a0                  ; yes reset text ptr
.notnext:
	move.l a0,scrlpoint              ; store text ptr
	move.w d1,scrloffset             ; offset within char
* Now plot the bastard to the screen. (using the generated routines)
	lea buffer(pc),a1
	add buff_ptr(pc),a1              ; point to curr buff adress
	lea verticalbuf,a6              ; wave base
	move.w wave_ptr(pc),d0
	add d0,a6                        ; a6-> y wave(*160)
	add #20,d0                       ; advance wave
	and #$7fe,d0
	move.w d0,wave_ptr               ; store wave position
	move.l physique,d2               ; screen base
	add.w	#43*160+6,d2
* Macro to plot first strip (bit 7)
plotstrip1	macro
	move.l d2,a0
	adda.w (a6)+,a0
	move #\1,d0
	move.l (a1)+,a2
	move.l (a1)+,a3
	jsr (a2)
	endm
* Macro to plot other strips (bits 0-6)
plotstrip	macro
	move.l d2,a0
	adda.w (a6)+,a0
	moveq #\1,d0
	move.l (a1)+,a2
	move.l (a1)+,a3
	jsr (a2)
	endm
 rept 20
	plotstrip1 %10000000
	plotstrip  %01000000
	plotstrip  %00100000
	plotstrip  %00010000
	plotstrip  %00001000
	plotstrip  %00000100
	plotstrip  %00000010
	plotstrip  %00000001
	addq.l #1,d2
	plotstrip1 %10000000
	plotstrip  %01000000
	plotstrip  %00100000
	plotstrip  %00010000
	plotstrip  %00001000
	plotstrip  %00000100
	plotstrip  %00000010
	plotstrip  %00000001
	addq.l #7,d2
 endr
	rts

init__Bitbend:
	bsr.s flip_chars
	bsr create_routs
	bsr create_initbuf
	rts

* Routine to rotate the 32*32 1 plane font 90 degrees. After
* flipping the font lies horizontally bitwise within a longword.
flip_chars:
	lea font32(pc),a0
	moveq #59,d6
.lp1:
	lea tempbuf(pc),a1
	move.l a0,a2
	moveq #15,d1
.copylp:
	move.W (a2)+,(a1)+
	dbf d1,.copylp
	moveq #15,d3
.lp2:
	moveq #0,d2
	lea tempbuf(pc),a1
	rept 16
	move.w (a1),d1	
	add.w d1,d1
	addx.w d2,d2
	move.w d1,(a1)+
	endr
	move.w d2,(a0)+
	dbf d3,.lp2 
	dbf d6,.lp1
	rts

tempbuf:
	ds.w	16

* Create the routs to draw strips of bit bender.
create_routs:
	lea routs,a0
	move doOR(pc),d5	
	move doOR1(pc),d6
	lea jmptab1(pc),a5
	move.w doJMP1(pc),d4
	moveq.w #0,d3
	bsr generate
	lea jmptab2(pc),a5
	move.w #$4E75,d4
	move.w #HZoomB*160,d3
	bsr generate
	rts

generate:
	moveq #0,d0
.makelp:
	move.l a0,(a5)+                  ; store pointer to routine
	moveq #7,d1
	move d3,d2
.make1lp:
	btst d1,d0
	beq.s .cont
	tst d2
	bne.s .norm
	move.w d6,(a0)+
	bra.s .cont
.norm:
	move.w d5,(a0)+                  ; command word MOVE or OR!
	move.w d2,(a0)+                  ; offset
.cont:
	add #160,d2                      ; onto next line
	dbf d1,.make1lp
	move.w d4,(a0)+
	addq #1,d0
	cmp #256,d0
	bne.s .makelp
	rts

doJMP1:
	jmp (a3)
doOR:
	or.b d0,99(a0)
doOR1:
	or.b d0,(a0)

* Routine to create initial 'nul' buffer + make waveform.
create_initbuf:
	lea buffer(pc),a0
	move.l jmptab1(pc),a1
	move.l jmptab2(pc),a2
	move.w #(320*2)-1,d0
.init_lp:
	move.l a1,(a0)+
	move.l a2,(a0)+
	dbf d0,.init_lp
make_wave1:
	lea verticalbuf,A0
	move #2047,D0
	lea trigtab(PC),A1
	clr D2
.crlp:
	moveq #ASinusB,D1
	muls (A1,D2),D1
	addq #VSinusB,D2
	and #$7FE,D2
	add.l D1,D1
	swap D1
	muls #160,d1
	add.w #90*160,d1
	move.w D1,(A0)+
	dbf d0,.crlp
	rts

trigtab:	even
	incbin	"E:\ERFURT20.26\data\TRIGTAB.DAT"
font32:
	incbin	"E:\ERFURT20.26\data\MET_06.FNT"
	even

scrlpoint:
	dc.l	text
scrloffset:
	ds.w	$1
buff_ptr:
	dc.w	$0
wave_ptr:
	dc.w	$0
;ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789!",$22,"#$%&",$27,"()*+,-./:;<=>?@
text:
	dc.b	"                "
	dc.b	"I HOPE THIS SCREEN IS VERY CONFORTABLE TO SEE ON A REAL HARDWARE, IT'S AN EXPECTATION BEFORE IT'S A CHECKER BORD "
	dc.b	"EFFECT MADE FROM OLD GOOD DAYS AND MAINLY USED IN AMIGA. THIS IS AN OLD SCREEN MADE BY ATOMUS BUT NOT FINISH YET "
	dc.b	"AND IT'S SPECIFIC FOR ATARI STF WITH LESS MEMORY WITH TOP AND BOTTOM OVERSCAN BORDER!"
	dc.b	"                "
	dc.b	"SPECIAL ACKNOWLEDGEMENT FOR TWO MEMBERS OF HEMOROIDS TEAM WHO HELPED ME TO HAVE A LITTLE SCREEN BUT IT'S VERY STRONG "
	dc.b	"WITH AN ORIGINAL MUSIC FROM 'ADRIEN' >AKA< AD AND TWO GRAPHICS BY 'GUY' AKA >NYTRIK< IN ONE WEEK AND YOU CAN "
	dc.b	"APPRECIATE THE INTRO PICTURE MADE IN ONE DAY SPECIALLY FOR THIS EVENT :)"
	dc.b	"                "
	dc.b	"DON'T FORGET TO READ THE ANOTHER SCROLLING TEXT TO HAVE MORE NEWS FROM THE NOEXTRA-TEAM THIS YEAR!"
	dc.b	"                "
	dc.b	"GREETING GOES TO DBUG - PHF - ELITE - ZUUL - PARADIZE - TSCC - ZUUL - POV - CV - PULSION - HMD - IMPACT - "   
	dc.b	"EUROSWAP - STAX - ST KNIGHTS - FUZION - XTROLL - LEMMINGS - SECTOR ONE - THE REPLICANTS - ICS - RG - OVR - "
	dc.b	"FRENCH GEMDOS CREW - EI - MPS - GEMTOS TEAM AND DHS AND PEOPLE WHO FORGOT WHILST WAITING FOR THE LATEST PALETTE "
	dc.b	"COLOR OF THIS ACTUALLY SCREEN SHOULD BE SEND FROM MISTER.A. BY MESSAGE IN FEW MINUTE!"
	dc.b	"                                "
	dc.w	$0
	even
buffer:
 rept	320*4
	dc.l	routs
 endr
 	even

jmptab1:
	ds.l 256
jmptab2:
	ds.l 256
verticalbuf:
	ds.w 2048
routs:
	ds.b	9000
nothing_but_pretty:
	ds.b	18000
	even