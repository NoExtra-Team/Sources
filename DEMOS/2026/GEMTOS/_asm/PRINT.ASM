***************************************************************
*         TEXT FONT 8*8 ONE PLANE BY AVENGER/AL TEAM          *
***************************************************************
*  ADAPTED FOR EXTRA FONT OF MISTER.A BY ZORRO2/NOEXTRA-TEAM  *
***************************************************************
MED        equ 1   ; MED resolution                           *
LOW        equ 0   ; LOW resolution                           *
CHARS      equ 40  ; chars per line, 80=med res, 40=low res   *
LINES      equ 33  ; 33 for 8x8 FONT, 45 with 6x6 FONT        *
INNERLINE  equ 4   ; Pas between each line                    *
FONT_SIZE  equ 8   ; 8=8x8, 6=6x6 FONT                        *
SHIFTSIZE  equ 4   ; 2=MED RESOLUTION, 4=FOR LOW RESOLUTION   *
RESOLUTION equ LOW ; if no, then its low resolution           *
***************************************************************
PLAN_TXT   equ 2   ; Bitplane of text                         *
POS_TXT    equ 160*50+PLAN_TXT ; Position inside the screen   *
***************************************************************
print_text:   clr.w	x_curs
              clr.l	x_offset
              clr.l	y_offset
              lea     mess_txt(pc),a2
new_char:     bsr     _x_conversion
              moveq   #0,d0    
              move.b  (a2)+,d0	           ; if zero, stop routine
              cmp.b	#0,d0
              beq	LF
              cmp.b	#$ff,d0
              bne.s   process_char
              rts

process_char: asl.w 	#3,d0                ; valeur * 8
              lea     FONT_TXT(pc),a1	
              sub.w	#256,d0         
              adda.w  d0,a1
              
              movea.l physique,a0          ; screen one
              lea     POS_TXT(a0),a0
              adda.l  y_offset(pc),a0
              adda.l  x_offset(pc),a0
              movea.l physique+4,a3        ; screen two
              lea     POS_TXT(a3),a3
              adda.l  y_offset(pc),a3
              adda.l  x_offset(pc),a3
              
              rept	FONT_SIZE
              move.b  (a1),(a0)
              move.b  (a1)+,(a3)
              lea	160(a0),a0
              lea	160(a3),a3
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

mess_txt:
;       +                                        +
	dc.b	" Special greetings to people and teams: ",0
	dc.b	"  Dentifrice.CiH.DHS.Paradox.505.Elite  ",0
	dc.b	"  Dubmood.Sector One.Baah.Vital Motion  ",0
	dc.b	" BouB.Keops.Exocet.Dune.Razor1911.Cream ",0
	dc.b	"  MPS.Blabla.Flor Kendall.Atari-Legend  ",0
	dc.b	"  Frequent.tSCc.Live!.Dbug.Cybernetics  ",0
	dc.b	" Felice.Vincent.pOke.Overlanders.Tronic ",0
	dc.b	" Hemoroids.Grazey.Reps!.Checkpoint.Grey ",0
	dc.b	"And the people we've missed for so long!",0
	dc.b	$ff
	even       
x_curs:
	dc.l $0
y_offset:
	dc.l $0
x_offset:
	dc.l $0
FONT_TXT:
	incbin 	"E:\GEMTOS\_data\FONT882.DAT"
	even
