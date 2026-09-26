; *************************************************************************
; ***              Led Floppy with music chanel choosen                 ***
; *************************************************************************
; ***                            Fantomas                               ***
; *************************************************************************
floppy_Led:lea $ffff8800,a0
           move.b #9,(a0)      ;	Voie 8-9-(A) - [C]hosen :)
           move.b (a0),d0
           cmpi.b #14,d0
           blt.s .led_off
.led_on:   move.b #14,(a0)
           move.b (a0),d0
           andi.b #$f9,d0
           move.b d0,2(a0)
           bra.s .led_done
.led_off:  move.b #14,(a0)
           move.b (a0),d0
           ori.b #6,d0
           move.b d0,2(a0)
.led_done: rts
