; *************************************************************************
; ***             Clear a screen in four bitplanes with BLITTER         ***
; *************************************************************************
; ***                          Zorro 2/NoExtra                          ***
; *************************************************************************
; Parameters                                                              *
; ------------------------------------------------------------------------*
; a0.l = destination address                                              *
; *************************************************************************
clear_screen_4_bitplanes_full:
	move.w #0,$ffff8a20.w            ; source x inc
	move.w #0,$ffff8a22.w            ; source y inc
	move.l #-1,$ffff8a28.w           ; endmask 1
	move.l #-1,$ffff8a2a.w           ; endmask 2
	move.l #-1,$ffff8a2c.w           ; endmask 3
	move.w #2,$ffff8a2e.w            ; dest x inc
	move.w #2,$ffff8a30.w            ; dest y inc
	move.l a0,$ffff8a32.w            ; destination address
	move.w #(320/4),$ffff8a36.w      ; x count (n words per line to copy)
	move.w #HEIGHT,$ffff8a38.w          ; y count (n lines to copy)
	move.b #%00000000,$ffff8a3a.w    ; blit hop (halftone mix)
	move.b #%00000000,$ffff8a3b.w    ; blit op (logic op)
	move.b #%11000000,$ffff8a3c.w    ; blitter control, start blitter
 IFEQ BLITTER
	Sync_Blit
 ENDC
	rts
