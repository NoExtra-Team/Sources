*********************************************************************
*                  TEXTE FONT 16x8 ONE BITPLANE                     *
*                         ZORRO 2/NOEXTRA                           *
*********************************************************************
CHARS      equ 40  ; chars per line, 80=for med res, 40 for low res *
LINES      equ 33  ; 33 for 8x8 font, 45 with 6x6 font              *
FONTSIZE   equ 16  ; 16=16x8, 8=8x8, 6=6x6 font                     *
SHIFTSIZE  equ 4   ; 2=MED RESOLUTION, 4=LOW RESOLUTION             *
*********************************************************************
print_text:     clr.w   x_curs
                clr.l   x_offset
                clr.l   y_offset
                lea     message,a2
new_char:       bsr     _x_conversion
                moveq   #0,d0    
                move.b  (a2)+,d0	;if zero, stop routine
                cmp.b   #0,d0
                beq     LF
.fin_de_ligne:  cmpi.b  #$ff,d0
                bne.s   process_char
                rts

process_char:   mulu.w 	#16,d0                 ; valeur * 16
                lea     fonte12,a1	
                sub.w	#256+160+8*12,d0         
                adda.w  d0,a1
                
                movea.l physique,a0
                add.w	#160*7+8*4+6,a0
                adda.l  y_offset(pc),a0
                adda.l  x_offset(pc),a0
                
                movea.l physique+4,a3
                add.w	#160*7+8*4+6,a3
                adda.l  y_offset(pc),a3
                adda.l  x_offset(pc),a3

                rept	FONTSIZE               ; Copy letter
                move.b  (a1),(a0)
                move.b  (a1)+,(a3)
                lea     160(a0),a0
                lea     160(a3),a3
                endr
                
                addq.w  #1,x_curs           
                cmpi.w  #CHARS,x_curs        ; 79 for MED res
                bls     new_char
                move.w  #CHARS,x_curs        ; 79 for MED res
                bra     new_char

LF:             clr.w   x_curs               ; back to first char
                addi.l  #FONTSIZE*160+160,y_offset ; linefeed when reached ',0'
                cmpi.l  #LINES*FONTSIZE*160,y_offset
                bls     new_char
                move.l  #LINES*FONTSIZE*160,y_offset
                bra     new_char

_x_conversion:  move.w  x_curs(pc),d0
                and.l   #$ffff,d0
                btst    #0,d0
                beq.s   _even
                subq.w  #1,d0
                mulu    #SHIFTSIZE,d0        ; 2=med res, 4=low
                addq.w  #1,d0
                bra     _done_conv
_even:          mulu    #SHIFTSIZE,d0        ; 2=med res, 4=low
_done_conv:     move.l  d0,x_offset
                rts
x_curs:
	ds.l 1
y_offset:
	ds.l 1
x_offset:
	ds.l 1
*********************************************************************
*                      STARFIELD 4 BITPLANES                        *
*                         ZORRO 2/NOEXTRA                           *
*********************************************************************
nb_stars equ 420        ;                                           *
xy_max   equ 8*8*2      ;                                           *
z_max    equ 512        ;                                           *
z_ft     equ 590        ;                                           *
*********************************************************************
clear_stars:
 move.l physique,a0
 lea 100*160+80(a0),a0
 move.l oldstars(pc),a1
 moveq #0,d0
 jmp (a1)
 
clr1:
 rept nb_stars
 move.w d0,2(a0)
 endr
 rts

clr2:
 rept nb_stars
 move.w d0,2(a0)
 endr
 rts

play_sequence_stars:
 subq.w #1,frames
 bne.s .cont
 move.l animation(pc),a0
 move.w (a0)+,d0
 bpl.s .skip
 lea sequence_stars(pc),a0
 move.w (a0)+,d0
.skip
 move.w d0,frames
 move.w (a0)+,d0
 asl.w #4,d0
 move.w d0,transx
 move.w (a0)+,d0
 asl.w #4,d0
 move.w d0,transy
 move.w (a0)+,d0
 add.w d0,d0
 add.w d0,d0
 move.w d0,transz
 move.l a0,animation
.cont:
	rts

play_stars:
 lea oldstars(pc),a1
 move.l (a1)+,a0
 move.l (a1),d0
 move.l a0,(a1)
 move.l d0,-(a1)
 addq.l #2,a0
 lea xyz,a1
 lea mul160+100*2,a2 
 lea offset+160*4,a3
 lea q,a4
 move.l physique,a5
 lea 100*160+80(a5),a5
 
 move.w #nb_stars-1,d0
 movem.w offset_xyz(pc),d1/d2/d3

.loop:
 movem.w (a1)+,d4/d5/d6

 add.w d3,d4
 and.w #(z_max*2-1)*4,d4
 move.l (a4,d4.w),d4
 
 add.w d1,d5
 and.w #(xy_max*2-1)*16,d5
 sub.w #xy_max*16,d5
 muls d4,d5
 swap d5
 cmp.w #159,d5
 bgt.s .out
 cmp.w #-160,d5
 blt.s .out
 
 add.w d2,d6
 and.w #(xy_max*2-1)*16,d6
 sub.w #xy_max*16,d6
 muls d4,d6
 swap d6
 cmp.w #99,d6
 bgt.s .out
 cmp.w #-100,d6
 blt.s .out
 
 add.w d5,d5
 add.w d5,d5
 move.l (a3,d5.w),d5
 add.w d6,d6
 add.w (a2,d6.w),d5
 swap d4
 add.w d5,d4
 swap d5
 or.w d5,(a5,d4.w) 
 move.w d4,(a0)

.out
 addq.l #4,a0
 dbra d0,.loop

 add.w transx(pc),d1
 add.w transy(pc),d2
 add.w transz(pc),d3
 movem.w d1/d2/d3,offset_xyz
 rts

init_stars:
 lea q+2,a0
 move.w #(z_max*2)-1,d0
 move.w #-z_max,d1
.lp:
 moveq #0,d2
 move.w d1,d2
 addq.w #1,d1
 swap d2
 asr.l #4,d2
 divs #z_ft,d2
 add.w #4096,d2
 move.l #4096*4096,d3
 divs d2,d3  
 move.w d3,(a0)
 addq.l #4,a0
 dbra d0,.lp

 lea xyz,a0
 move.w #nb_stars-1,d0
 moveq #0,d1
.lp1
 bsr.s round_stars
 and.w #z_max*2-1,d2
 add.w d2,d2
 add.w d2,d2
 move.w d2,(a0)+
 bsr.s round_stars
 and.w #xy_max*2-1,d2
 asl.w #4,d2
 move.w d2,(a0)+
 bsr.s round_stars
 and.w #xy_max*2-1,d2
 asl.w #4,d2
 move.w d2,(a0)+
 dbra d0,.lp1
 rts

round_stars:
 muls #$3614,d1
 add.l #$461942,d1
 lsr.l #8,d1
 lsr.l #4,d1 
 move.l d1,d2
 and.l #$ffff,d1
 rts

animation:
 dc.l sequence_stars
sequence_stars:
 dc.w 10,0,0,-5
 dc.w 10,0,0,-4
 dc.w 10,0,0,-3
 dc.w 10,0,0,-2
 dc.w 10,0,0,-1 
 dc.w 10,0,0,1
 dc.w 10,0,0,2
 dc.w 10,0,0,3
 dc.w 10,0,0,5
 dc.w 10,0,0,7
 dc.w 50,0,0,9
 dc.w 20,1,0,10
 dc.w 10,2,0,11
 dc.w 10,4,0,11
 dc.w 10,6,0,11
 dc.w 100,8,0,11
 dc.w 20,6,0,11
 dc.w 10,4,0,10
 dc.w 10,3,0,10
 dc.w 10,2,1,10
 dc.w 10,1,2,10
 dc.w 10,0,3,10
 dc.w 200,0,4,10
 dc.w 100,0,3,9
 dc.w 20,0,2,7
 dc.w 10,0,1,5
 dc.w 10,0,0,3
 dc.w 10,0,0,1
 dc.w 10,0,0,0
 dc.w 20,0,0,-1
 dc.w 10,0,0,-2
 dc.w 10,0,0,-4
 dc.w 10,0,0,-6
 dc.w 10,0,0,-8
 dc.w 200,0,0,-12
 dc.w 20,-1,-1,-10
 dc.w 10,-2,-1,-10
 dc.w 10,-3,-2,-9
 dc.w 10,-4,-2,-9
 dc.w 10,-5,-2,-9
 dc.w 10,-5,-3,-9
 dc.w 20,-5,-4,-9
 dc.w 200,-5,-4,-9
 dc.w 20,-5,-4,-8
 dc.w 10,-4,-3,-7
 dc.w 10,-3,-2,-6
 dc.w 10,-2,-1,-4
 dc.w 10,-1,0,-2
 dc.w 10,0,0,-1
 dc.w 10,1,0,0
 dc.w 10,2,0,1
 dc.w 10,3,0,2
 dc.w 50,3,0,2
 dc.w 20,3,0,1
 dc.w 10,2,0,1
 dc.w 500,1,0,0
 dc.w 10,0,0,0
 dc.w -1
frames:
 dc.w 1
transx:
 dc.w 0*16
transy:
 dc.w 0*16
transz:
 dc.w 0*2
offset_xyz
 ds.w 3
oldstars:
 dc.l clr1,clr2
	even
