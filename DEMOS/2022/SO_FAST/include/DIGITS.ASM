************************************************************
*         Little Vumeters one bitplane by FANTOMAS         *
************************************************************
Digits:         lea $ff8800,a0
                bsr	get_Screen_To_display_A1
                add.l #(160*187)+8*1+6,a1
                lea (a1),a2
i               set 0
                rept 16
                clr.w i(a1)                 ; clear part of digits
i               set i-160
                endr
                moveq #0,d0                 ; Voie A
                move.b #8,(a0)
                move.b (a0),d0
                cmp.b #16/4+2,d0
                blt.s fill_voice_A
                move.b #15/4+2,d0
fill_voice_A:   move.w #%11100000000000,(a1)
                lea -160(a1),a1
                dbf d0,fill_voice_A
                move.l a2,a1                ; Voie B
                moveq #0,d0
                move.b #9,(a0)
                move.b (a0),d0
                cmp.b #16/4+2,d0
                blt.s fill_voice_B
                move.b #15/4+2,d0
fill_voice_B:   or.w #%000000111000000,(a1)
                lea -160(a1),a1
                dbf d0,fill_voice_B
                move.l a2,a1                ; Voie C
                moveq #0,d0
                move.b #10,(a0)
                move.b (a0),d0
                cmp.b #16/4+2,d0
                blt.s fill_voice_C
                move.b #15/4+2,d0
fill_voice_C:   or.w #%0000000000001110,(a1)
                lea -160(a1),a1
                dbf d0,fill_voice_C
                RTS
