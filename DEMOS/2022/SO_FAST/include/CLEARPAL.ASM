; *************************************************************************
; ***            Clear a palette displayed with $ffff8240.w             ***
; *************************************************************************
; ***                          Zorro 2/NoExtra                          ***
; *************************************************************************
; * Parameters:	myColor.l = color in a long = two words = 2 colours       *
; * Registers used d0-d7 * except a0-a7                                   *
; *************************************************************************
clear_palette:
	move.l     myColor,d0           ; Clear Palette
	move.l     myColor,d1           ;
	move.l     myColor,d2           ;
	move.l     myColor,d3           ;
	move.l     myColor,d4           ;
	move.l     myColor,d5           ;
	move.l     myColor,d6           ;
	move.l     myColor,d7           ;
	movem.l    d0-d7,$ffff8240.w    ; 16 colors put
	rts
myColor:	ds.l	1
	even