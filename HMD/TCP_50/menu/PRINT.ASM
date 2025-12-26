***************************************************************
*                                                             *
*         TEXT FONT 8*8 ONE PLANE BY AVENGER/AL TEAM          *
*  ADAPTED FOR EXTRA FONT OF MISTER.A BY ZORRO2/NOEXTRA-TEAM  *
*                                                             *
***************************************************************
no  equ 0
yes equ 1
MED equ 1
LOW equ 0
CHARS      equ 40  ; chars per line, 80=for med res, 40 for low res
LINES      equ 33  ; 33 for 8x8 FONT, 45 with 6x6 FONT 
INNERLINE  equ 4+2   ; Pas between each line
FONT_SIZE  equ 8   ; 8=8x8, 6=6x6 FONT
SHIFTSIZE  equ 4   ; 2=MED RESOLUTION, 4=FOR LOW RESOLUTION
RESOLUTION equ LOW ; if no, then its low resolution

print_text:   clr.w	x_curs
              clr.l	x_offset
              clr.l	y_offset
              lea     message(pc),a2
new_char:     bsr     _x_conversion
              moveq   #0,d0    
              move.b  (a2)+,d0	           ;if zero, stop routine
              cmp.b	#0,d0
              beq	LF
              cmp.b	#$ff,d0
              bne.s   process_char
              rts

process_char: asl.w 	#3,d0                ; valeur * 8
              lea     FONT_NOEX(pc),a1	
              sub.w	#256,d0         
              adda.w  d0,a1
              
              movea.l physique,a0          ; Two screens
              lea     160*18+6(a0),a0
              adda.l  y_offset(pc),a0
              adda.l  x_offset(pc),a0
              
              rept	FONT_SIZE
              move.b  (a1)+,(a0)	
              lea	160(a0),a0
              endr
              
              addq.w  #1,x_curs           
              cmpi.w  #CHARS,x_curs        ; 79 for MED res
              bls     new_char
              move.w  #CHARS,x_curs        ; 79 for MED res
              bra   	new_char

LF:           clr.w	x_curs                 ; back to first char
              addi.l  #(FONT_SIZE*160)+160*INNERLINE,y_offset ; linefeed when reached ',0'
              cmpi.l  #LINES*FONT_SIZE*160,y_offset
              bls     new_char
              move.l  #LINES*FONT_SIZE*160,y_offset
              bra     new_char

_x_conversion:move.w	x_curs(pc),d0
              and.l	#$ffff,d0
              btst	#0,d0
              beq.s	_even
              subq.w	#1,d0
              mulu	#SHIFTSIZE,d0          ; 2=med res, 4=low
              addq.w	#1,d0
              bra	_done_conv
_even:        mulu	#SHIFTSIZE,d0          ; 2=med res, 4=low
_done_conv:   move.l	d0,x_offset
              rts

message:
	dc.b	0,0,0,0
	dc.b	"           HEMOROIDS PRESENTS           ",0,0
	dc.b	"    TURLUTUTU CHAPEAU POINTU PACK#5O    ",0
	dc.b	"----------------------------------------",0
	dc.b	"     SQUARE - STNICCC VERSION (2015)    ",0
	dc.b	"   SQUARE V2 - REVISION LOADER (2021)   ",0
	dc.b	"----------------------------------------",0
	dc.b	"THANKS FOR ALL PEOPLE WHO SUPPORTED OUR ",0
	dc.b	"TEAM WITH THE TIME & OUR FRESH RELEASES ",0
	dc.b	"YOU CAN SWAP THIS MENU PACK ON ATARI ST!",0
	dc.b	"THANXX NOEXTRA TO RELEASE THIS MENU PACK",0,0,0
	dc.b	"  code:Angel - music:YQN - gfx:Nytrik   ",0
	dc.b	$ff
	even       
x_curs:
	dc.l $0
y_offset:
	dc.l $0
x_offset:
	dc.l $0
FONT_NOEX:
	incbin 	"FONT88*.DAT"
	even
