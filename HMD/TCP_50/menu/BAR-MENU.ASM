*******************************************************
* Bar Menu                                            *
*******************************************************
* Original version ATOMUS/NOEX                        *
*-----------------------------------------------------*
* Parameter(s)                                        *
*-----------------------------------------------------*
MAX_LINE    equ 2-1  ; Nb line to manage              *
NB_LINE_BET equ 14-1 ; Nb line to scroll for the next *
*******************************************************
KEYPAD:         CMPI.B    #$48,$FFFFFC02.W	; CURSEUR HAUT
                BNE.s     .suite 
                CMPI.W    #0,POSITION_BARRE
                BEQ.s     .suite 
                MOVE.W    #1,SENS_BARRE
.suite:         CMPI.B    #$50,$FFFFFC02.W	; CURSEUR BAS
                BNE.s     .finish
                CMPI.W    #MAX_LINE,POSITION_BARRE
                BEQ.s     .finish
                MOVE.W    #2,SENS_BARRE
.finish:        RTS 

MVT_BARRE:      CMPI.W    #1,SENS_BARRE
                BNE.s     .bas 
.haut:          SUBQ.B    #1,HBL_POS_1
                ADDQ.B    #1,HBL_POS_2
                ADD.W     #1,BAR_TEMPO
                CMPI.W    #NB_LINE_BET,BAR_TEMPO
                BLE.S    .fin
                CLR.W     SENS_BARRE 
                MOVE.W	  #0,BAR_TEMPO
                SUBI.W    #1,POSITION_BARRE
                SUB.L     #1,$40.W
.bas:           CMPI.W    #2,SENS_BARRE
                BNE.s     .fin 
                ADDQ.B    #1,HBL_POS_1
                SUBQ.B    #1,HBL_POS_2
                ADD.W     #1,BAR_TEMPO
                CMPI.W    #NB_LINE_BET,BAR_TEMPO
                BlE.S     .fin
                CLR.W     SENS_BARRE 
                MOVE.W    #0,BAR_TEMPO
                ADDI.W    #1,POSITION_BARRE
                ADD.L     #1,$40.W
.fin:           RTS 

SENS_BARRE:     DC.W	$0
HBL_POS_1:      DC.W	$0
HBL_POS_2:      DC.W	$0
POSITION_BARRE: DC.W	$0
BAR_TEMPO:      DC.W	$0
	even
