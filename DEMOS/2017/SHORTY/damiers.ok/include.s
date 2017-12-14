hline=13-0

init_rotojedi:  moveq #hline-1,d0
                lea forget(pc),a1
.nice:          lea fire(pc),a0
                move #(forget-fire)/2-1,d1
                move (a0)+,(a1)+
                dbf d1,*-2
                dbf d0,.nice
                moveq #6,d0
                lea zonkaf,a1
.nice2:         lea zonka,a0
                move #(zonkaf-zonka)/2-1,d1
                move (a0)+,(a1)+
                dbf d1,*-2
                dbf d0,.nice2
                rts

rotojedi:       lea moves,a5
                lea map,a0
                move (a5)+,d0
                lea (a0,d0),a0
                movea.l physique,a1
                lea     160*73+8*7(a1),a1
                movea.l (a5)+,a4	step incremental ($1000000)
                movea.w (a5)+,a3	dy (0)
                adda.l a3,a3	;***
                move (a5)+,d1		dx% (1)
                movea.w (a5)+,a2	dx# (0)
                cmpa.l #movesf,a5
                bne.s hurtme
                lea moves,a5
hurtme:         move.l a5,rotojedi+2
                moveq #0,d3		mover y
                moveq #0,d4		mover x%
                moveq #0,d5		mover x#
                moveq #0,d6		reserv‚
                moveq #4,d7		pour le asl
                moveq #0,d2		incremental
                lea (a0),a6
fire:           moveq #0,d3
                moveq #0,d4
                moveq #0,d5
nark set 0
                move.b (a0),d0
                lsl.b d7,d0

                add a3,d3
                move d3,d6
                add a2,d5
                addx d1,d4
                move.b d4,d6
                add.b (a0,d6),d0
                lsl d7,d0

                add a3,d3
                move d3,d6
                add a2,d5 
                addx d1,d4
                move.b d4,d6
                add.b (a0,d6),d0
                lsl d7,d0

                add a3,d3
                move d3,d6
                add a2,d5
                addx d1,d4
                move.b d4,d6
                add.b (a0,d6),d0
                move d0,nark(a1)
                move d0,nark+160*1(a1)
                move d0,nark+160*2(a1)
                move d0,nark+160*3(a1)
nark set nark+8
                rept 6-1
                add a3,d3
                move d3,d6
                add a2,d5
                addx d1,d4
                move.b d4,d6
                move.b (a0,d6),d0
                lsl.b d7,d0

                add a3,d3
                move d3,d6
                add a2,d5
                addx d1,d4
                move.b d4,d6
                add.b (a0,d6),d0
                lsl d7,d0

                add a3,d3
                move d3,d6
                add a2,d5 
                addx d1,d4
                move.b d4,d6
                add.b (a0,d6),d0
                lsl d7,d0

                add a3,d3
                move d3,d6
                add a2,d5
                addx d1,d4
                move.b d4,d6
                add.b (a0,d6),d0
                move d0,nark(a1)
                move d0,nark+160*1(a1)
                move d0,nark+160*2(a1)
                move d0,nark+160*3(a1)
nark set nark+8
                endr
                lea 160*4(a1),a1
plouf:          add.l a4,d2
                swap d2
                lea (a6,d2),a0
                swap d2
forget:         ds.b hline*(forget-fire)
                rts
