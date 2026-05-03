***************************************************************
***          SCROLLTEXT WITH FONT 8x8 ONE BITPLANE          ***
***************************************************************
***                   ATOMUS/NOEXTRA-TEAM                   ***
***************************************************************
POS_SCROLL  equ 160*145 ; Position of the scrolling           *
PLAN_SCROLL equ 2       ; Bitplane used for the scrolling     *
HEIGHT_CAR  equ 8-1     ; height character                    *
***************************************************************
init_scrolltext:move.l	#mtexte,ptr_mtexte
                rts
                
scrolltext:     move.w 	decal,d0
                cmp.w 	#8,d0
                bne.s 	scroll_it
                clr.w 	decal
                move.l 	ptr_mtexte,a1
                move.b 	(a1),d0
                cmp.b 	#$ff,d0               ; End of the sentences ?
                bne.s 	.no_re_init
                bsr.s   init_scrolltext
                move.l 	ptr_mtexte,a1
                move.b 	(a1),d0
.no_re_init:    addq.l 	#1,ptr_mtexte
                asl.l 	#3,d0
                lea     fonts_8x8,a1         ; Load font
                sub.w   #256,d0
                add.w 	d0,a1                ; Find the character in the font
                lea     buffer_carac,a2      ; Put in the Buffer
i               set 0
                rept 8
                move.b 	(a1)+,i(a2)
i               set i+2
                endr
scroll_it:      addq.w 	#1,decal             ; Put shifting character in the buffer
                lea     buffer_scroll,a1
                lea     buffer_carac,a2
i               set 0
                rept HEIGHT_CAR
                roxl 	(a2)+
                roxl 	i+38(a1)
                roxl 	i+36(a1)
                roxl 	i+34(a1)
                roxl 	i+32(a1)
                roxl 	i+30(a1)
                roxl 	i+28(a1)
                roxl 	i+26(a1)
                roxl 	i+24(a1)
                roxl 	i+22(a1)
                roxl 	i+20(a1)
                roxl 	i+18(a1)
                roxl 	i+16(a1)
                roxl 	i+14(a1)
                roxl 	i+12(a1)
                roxl 	i+10(a1)
                roxl 	i+08(a1)
                roxl 	i+06(a1)
                roxl 	i+04(a1)
                roxl 	i+02(a1)
                roxl 	i+00(a1)
i               set i+40
                endr
                move.l  physique,a1      ; Put on the physical screen
                add.l	#POS_SCROLL+PLAN_SCROLL,a1 ; At this position and bitplane
                lea 	  buffer_scroll,a2     ; From the buffer
i               set 2
                rept HEIGHT_CAR
                move.w 	(a2)+,i+002(a1)
                move.w 	(a2)+,i+010(a1)
                move.w 	(a2)+,i+018(a1)
                move.w 	(a2)+,i+026(a1)
                move.w 	(a2)+,i+034(a1)
                move.w 	(a2)+,i+042(a1)
                move.w 	(a2)+,i+050(a1)
                move.w 	(a2)+,i+058(a1)
                move.w 	(a2)+,i+066(a1)
                move.w 	(a2)+,i+074(a1)
                move.w 	(a2)+,i+082(a1)
                move.w 	(a2)+,i+090(a1)
                move.w 	(a2)+,i+098(a1)
                move.w 	(a2)+,i+106(a1)
                move.w 	(a2)+,i+114(a1)
                move.w 	(a2)+,i+122(a1)
                move.w 	(a2)+,i+130(a1)
                move.w 	(a2)+,i+138(a1)
                move.w 	(a2)+,i+146(a1)
                move.w 	(a2)+,i+154(a1)
i               set i+160
                endr
                rts

ptr_mtexte:
	dc.l	mtexte
mtexte: 
; ASCII character : ESP!'#$%&"()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyzCUR
; Character $ff = end of text
*       +                                                               +
	dc.b	"               REMERCIEMENT A RADIATION - DMA-SC - ZEELAY - SUPERNININE"
	dc.b	" - GIGI - WULF - SAMUEL - CYRIL (16/32BIT.EU) ET BIEN SUR TOUS CEUX QUI"
	dc.b	" VIENNENT A LA GEMTOS..........                                        "
	dc.b $ff
	even
fonts_8x8:	even
	incbin	"E:\GEMTOS\_data\FONTREPS.DAT"
	even
