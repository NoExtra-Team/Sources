***************************************************************
; SUB-ROUTINES for FADE TO BLACK                           // *
***************************************************************
FadeTOblack:
	moveq   #20-1,D7                      ; Temporisation
.fade:
	lea	$ffff8240.w,A0                    ; Palette Logo
	moveq	#15,D2
	bsr.s	fade_down
	bsr	Wait_vbl                          ; Waiting after the VBL
	dbra	D7,.fade
	moveq  #0,d0                          ; Clear Palette colors
	moveq  #0,d1
	moveq  #0,d2
	moveq  #0,d3
	moveq  #0,d4
	moveq  #0,d5
	moveq  #0,d6
	moveq  #0,d7
	movem.l d0-d7,$ffff8240.w
	rts

***************************************************************
*                 Fades all colours to black                  *
***************************************************************
* a0 : palette source
* d2 : compteur de couleur
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


