***************************************
* // EXTRA_V2.PRG                   // *
***************************************
* // Asm Intro Code Atari ST v0.39 // *
* // by Zorro 2/NoExtra (06/04/11) // *
* // http://www.noextra-team.com/  // *
***************************************
* // Original code : Atomus        // *
* // Gfx logo      : Mister.A      // *
* // Gfx font      : Mister.A      // *
* // Music         : TOMCHI        // *
* // Release date  : 21/12/2009    // *
* // Update date   : 26/01/2012    // *
***************************************
  OPT c+ ; Case sensitivity on        *
  OPT d- ; Debug off                  *
  OPT o- ; All optimisations off      *
  OPT w- ; Warnings off               *
  OPT x- ; Extended debug off         *
***************************************

	SECTION	TEXT

********************************************************************
TOPBOTTOM_BORDER equ 0         ; Use the top and bottom overscan   *
PATTERN          equ $00000000 ; See the screen plan               *
SEEMYVBL         equ 1         ; See CPU used if you press ALT key *
ERROR_SYS        equ 1	       ; Manage Errors System              *
********************************************************************
* Remarque : 0 = I use it / 1 = no need !                          *
********************************************************************
SYNCHRO_WAIT equ $900

Begin
                move    SR,d0                    ; Test supervisor mode
                btst    #13,d0                   ; Specialy for relocation
                bne.s   mode_super_yet           ; programs
                move.l  4(sp),a5                 ; Address to basepage
                move.l  $0c(a5),d0               ; Length of TEXT segment
                add.l   $14(a5),d0               ; Length of DATA segment
                add.l   $1c(a5),d0               ; Length of BSS segment
                add.l   #$1000,d0                ; Length of stackpointer
                add.l   #$100,d0                 ; Length of basepage
                move.l  a5,d1                    ; Address to basepage
                add.l   d0,d1                    ; End of program
                and.l   #-2,d1                   ; Make address even
                move.l  d1,sp                    ; New stackspace

                move.l  d0,-(sp)                 ; Mshrink()
                move.l  a5,-(sp)                 ;
                move.w  d0,-(sp)                 ;
                move.w  #$4a,-(sp)               ;
                trap    #1                       ;
                lea 	12(sp),sp                  ;

                clr.l	-(sp)                      ; Supervisor mode
                move.w	#32,-(sp)
                trap	#1
                addq.l	#6,sp
                move.l	d0,Save_stack
mode_super_yet: bsr	clear_bss                    ; Clean BSS stack

                bsr	Save_and_init_st             ; Save system parameters

                jsr	Multi_boot                   ; Multi Atari Boot code.

                bsr	Init_screens                 ; Screens initialisation

                bsr	Init                         ; Inits

******************************************************************************

default_loop:   bsr	Wait_vbl                     ; Waiting after the VBL

                IFEQ	SEEMYVBL
                clr.b	$ffff8240.w
                ENDC

* < Put your code here >
                BSR	KEYPAD	; mvt de la barre 
                BSR	MVT_BARRE 
                BSR	PRINT_STARS
                BSR	MYSCROLL 
                BSR	DIGITS
* <

                lea     physique(pc),a0          ; Swapping screens
                move.l	(a0),d0
                move.l	4(a0),(a0)+
                move.l	d0,(a0)
                move.b  d0,$ffff820d.w
                move    d0,-(sp)
                move.b  (sp)+,d0
                move.l  d0,$ffff8200.w

                NEG.W   TEST

                sub.l   #1,SYNCHRO_WAIT
                cmpi.l  #0,SYNCHRO_WAIT
                bne.s   .not_ready_vbl
                move.w  #$FFF,VBL_OK
.not_ready_vbl: cmpi.b	#1,$fffffc02.w     ; Space pressed ?
                beq.s   exitloop

                IFEQ	SEEMYVBL
                cmp.b	#$38,$fffffc02.w           ; ALT key
                bne.s	next_key
                move.b	#7,$ffff8240.w           ; See the rest of CPU
next_key:
                ENDC

                cmp.b	#$39,$fffffc02.w           ; SPACE key
                bne	default_loop

******************************************************************************

                add.l    #2,$40.W
                bra.s		end_program

exitloop:       move.l		#1,$40.W

end_program:    movea.l   physique+4(pc),a0 
                move.w    #260*160/4-1,d0 
                clr.l     (a0)+ 
                dbf       d0,*-2

                clr.b     $fffffa1b.w

                lea     start_vbl(pc),a0     ; main VBL
                move.l  a0,$70.w

SORTIE:         bsr	Restore_st                   ; Restore all registers

                move.l	Save_stack,-(sp)         ; Restore user Mode
                move.w	#32,-(sp)
                trap	#1
                addq.l	#6,sp

                clr.w	-(sp)                      ; Pterm()
                trap	#1                         ; EXIT program

************************************************
*                                              *
*               Init Routines                  *
*                                              *
************************************************
Init:	          movem.l	d0-d7/a0-a6,-(a7)

                lea     start_vbl(pc),a0      ; main VBL
                move.l  a0,$70.w

                bsr     fadeoff

                BSR     INIT_STARS

                move.l	#LOGO_EXTRA,a0	;	datas
                move.l	#Buffer_LZ7,a1	;	buffer destination
                bsr	d_lz77	; decompress data in a0 -> a1

                lea	physique(pc),a6
                move.l	(a6)+,a0
                lea     160*3(a0),a0
                move.l	(a6)+,a1
                lea     160*3(a1),a1
                movea.l	#Buffer_LZ7,a4
                move.l	#160*55/4-1,d0
                move.l	(a4),(a0)+
                move.l	(a4)+,(a1)+
                dbf	d0,*-4

                move.l	#VOLUME_2,a0	;	datas
                move.l	#Buffer_LZ7,a1	;	buffer destination
                bsr	d_lz77	; decompress data in a0 -> a1

                lea	physique(pc),a6
                move.l	(a6)+,a0
                lea     160*188(a0),a0
                move.l	(a6)+,a1
                lea     160*188(a1),a1
                movea.l	#Buffer_LZ7,a4
                move.l	#160*$50/4-1,d0
                move.l	(a4),(a0)+
                move.l	(a4)+,(a1)+
                dbf	d0,*-4

                lea     message1(pc),a2
                move.w  #0,FONTE_USED
                bsr     print_text

                lea     message2(pc),a2
                move.w  #$FFF,FONTE_USED
                bsr     print_text

                CLR.W   POSITION_BARRE	; initialise barre de navigation
                MOVE.B  #79-30-42-2+10-12+7,HBL_POS_1	; debut de la barre
                MOVE.B  #119-1-10-7,HBL_POS_2	; fin de la barre
                MOVE.W	#0,BAR_TEMPO          ; temporisation a chaque deplacement de la barre  
                CLR.L   $40.W

                move.l  #$001F,SYNCHRO_WAIT
                move.w  #0,VBL_OK

                move.l	#MUSIC,a0	;	datas
                move.l	#Buffer_LZ7,a1	;	buffer destination
                bsr	d_lz77	; decompress data in a0 -> a1

                jsr	Buffer_LZ7+0                      ; Init music

                lea	Vbl(pc),a0                   ; Launch VBL
                move.l	a0,$70.w

                movem.l	(a7)+,d0-d7/a0-a6
                rts

************************************************
*                                              *
*              Screen Routines                 *
*                                              *
************************************************
 IFEQ	TOPBOTTOM_BORDER
SIZE_OF_SCREEN equ 160*300        ; Screen + Top & Lower Border size
 ENDC

Init_screens:
	movem.l	d0-d7/a0-a6,-(a7)

	move.l	#Screen_1,d0             ; Set physical Screen #1
	add.w	#$ff,d0                    ;
	sf	d0                           ;
	move.l	d0,physique              ;

	move.l	#Screen_2,d0             ; Set logical Screen #2
	add.w	#$ff,d0                    ;
	sf	d0                           ;
	move.l	d0,physique+4            ;

	move.l	physique(pc),a0          ; Put PATTERN in two Screens
	move.l	physique+4(pc),a1        ;
	move.w  #(SIZE_OF_SCREEN)/4-1,d7 ;
	move.l  #PATTERN,(a0)+           ;
	move.l  #PATTERN,(a1)+           ;
	dbf	    d7,*-12                  ;

	move.l	physique(pc),d0          ; Put physical Screen
	move.b	d0,d1                    ;
	lsr.w	#8,d0                      ;
	move.b	d0,$ffff8203.w           ;
	swap	d0                         ;
	move.b	d0,$ffff8201.w           ;
	move.b	d1,$ffff820d.w           ;

	movem.l	(a7)+,d0-d7/a0-a6
	rts

physique:
	ds.l 2                           ; Number of screens declared

************************************************
*                                              *
*               Vbl Routines                   *
*                                              *
************************************************
start_vbl:      clr.b   $fffffa1b.w          ; Timer B off
                st      Vsync
                rte

Vbl:
                IFEQ	TOPBOTTOM_BORDER
                clr.b   $fffffa1b.w          ; Timer B off
                ENDC

                move.l	a0,-(a7)
                move.l	a1,-(a7)
                LEA   Palette_Extra,A0 
                MOVEA.L   #$FF8240,A1 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                move.l	(a7)+,a1
                move.l	(a7)+,a0

                st      Vsync

                IFEQ	TOPBOTTOM_BORDER
                MOVE.L    #HBL_blanc,$120.W 
                MOVE.B    #$63,$FFFFFA1F.W
                MOVE.B    #4,$FFFFFA19.W
                MOVE.B    #8+42+12,$FFFFFA21.W
                MOVE.B    #8,$FFFFFA1B.W
                MOVE.L    #COUL_1,PTR_COUL_1
                CLR.B     SYNC_BORDER
                ENDC
                
                jsr     (Buffer_LZ7+8)            ; play music
                rte

Wait_vbl:       move.l	a0,-(a7) ; Test Synchronisation
                lea	Vsync,a0
                sf	(a0)
.loop:          tst.b	(a0)
                beq.s	.loop
                move.l	(a7)+,a0
                rts

	IFEQ	TOPBOTTOM_BORDER
***************************************************************
*                                                             *
*          < Here is the top and lower border rout >          *
*                                                             *
***************************************************************
TIMER_A:        MOVE      #$2100,SR 
                STOP      #$2100
                MOVE      #$2700,SR 
                CLR.B     $FFFFFA19.W 
                MOVEM.L   A0-A1/D0-D7,-(A7) 
                dcb.w     60,$4e71
                MOVE.B    #0,$FFFF820A.W
                dcb.w     7,$4e71
                CLR.W     D1
                MOVEA.W   #$8209,A0 
                MOVE.B    #2,$FFFF820A.W
                MOVEM.L   (A7)+,A0-A1/D0-D7 
RTE:            RTE 

HBL_blanc:      CLR.B     $FFFFFA1B.W
                MOVE.B    #$ff,$ffff8240.w
                MOVE.L    #HBL_noir,$120.W 
                MOVE.B    #1,$FFFFFA21.W 
                MOVE.B    #8,$FFFFFA1B.W
                RTE 
      
HBL_noir:       CLR.B     $FFFFFA1B.W
                MOVE.w    #$101,$ffff8240.w
                MOVE.L    #HBL,$120.W 
                MOVE.B    #1,$FFFFFA21.W 
                MOVE.B    #8,$FFFFFA1B.W
                RTE 

HBL:            CLR.B     $FFFFFA1B.W
                MOVE.L    #HBL1,$120.W 
                MOVE.B    HBL_POS_1,$FFFFFA21.W
                MOVE.B    #8,$FFFFFA1B.W
                move.l	  a0,-(a7)
                move.l	  a1,-(a7)
                LEA       Palette_Etoile(pc),A0 
                MOVEA.L   #$FF8240,A1 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                MOVE.L    (A0)+,(A1)+ 
                move.l	  (a7)+,a1
                move.l	  (a7)+,a0
                RTE 

q equ $0121
f equ $0777
Palette_Etoile:	dc.w	$0101,$0404+q,$0515+q,$0626+q,f,f,f,f

HBL1:           CLR.B     $FFFFFA1B.W
                MOVE.w    #$0303,$ffff8240.w
                MOVE.L    #HBL2,$120.W 
                MOVE.B    #10,$FFFFFA21.W 
                MOVE.B    #8,$FFFFFA1B.W
                RTE 
      
HBL2:           CLR.B     $FFFFFA1B.W
                MOVE.w    #$101,$ffff8240.w
                MOVE.L    #HBL_blanc2,$120.W 
                MOVE.B    HBL_POS_2,$FFFFFA21.W
                MOVE.B    #8,$FFFFFA1B.W     
                RTE 

HBL_blanc2:     CLR.B     $FFFFFA1B.W
                MOVE.B    #$ff,$ffff8240.w
                MOVE.L    #HBL_noir2,$120.W 
                MOVE.B    #1,$FFFFFA21.W 
                MOVE.B    #8,$FFFFFA1B.W
                RTE 
      
HBL_noir2:      CLR.B     $FFFFFA1B.W
                move.l	  #$2020A8A,$ffff8240.w
                move.l	  #$1010000,$ffff825c.w
                MOVE.L    #TIMERB,$120.W 
                MOVE.B    #1,$FFFFFA21.W 
                MOVE.B    #8,$FFFFFA1B.W
                RTE 

coul_pal_rast	equ	$ffff8242

TIMERB:         MOVE.L    A0,-(A7)
                movea.l   PTR_COUL_1,a0
                cmp.w     #$FFF,VBL_OK
                bne.s     .no_vbl_ok
                MOVE.W    (A0)+,coul_pal_rast.W 
                MOVE.W    (A0),$ffff825e.W 
.no_vbl_ok:     MOVE.L    A0,PTR_COUL_1
                ADDQ.B    #1,SYNC_BORDER
                CMPI.B    #42,SYNC_BORDER
                BEQ.S     BORDER_END 
                MOVEA.L   (A7)+,A0
                RTE 

VBL_OK dc.l $0

BORDER_END:     CLR.B     SYNC_BORDER 
                MOVE.W    D0,-(A7)
                LEA       $FFFFFA21.W,A0
                MOVE.B    #2,(A0) 
                MOVE.B    (A0),D0 
.loopA:         CMP.B     (A0),D0 
                BEQ.S     .loopA 
                CLR.B     $FFFF820A.W 
                MOVEQ     #3,D0 
.loopB:         NOP 
                DBF       D0,.loopB
                MOVE.B    #2,$FFFF820A.W
                MOVE.W    (A7)+,D0
                MOVEA.L   (A7)+,A0
                MOVE.B    #1,$FFFFFA21.W
                RTE 

SYNC_BORDER:
	DC.W $0

PTR_COUL_1:
	dc.l	COUL_1
COUL_1:
	dc.w	$0C3C,$05A5,$0D2D,$0696
	dc.w	$0E1E,$0787,$0F0F,$070F
	dc.w	$0E0F,$060F,$0D0F,$050F
	dc.w	$0C0F,$040F,$0B0F,$030F
	dc.w	$0A0F,$020F,$090F,$010F
	dc.w	$080F,$000F,$000F,$0807
	dc.w	$010E,$0906,$020D,$0A05
	dc.w	$030C,$0B04,$040B,$0C03
	dc.w	$050A,$0D02,$0609,$0E01
	dc.w	$0708,$0F00,$0F80,$0F10
	dc.w	$0F90,$0F20,$0FA0,$0F30
	dc.w	$0FB0,$0F40,$0FC0,$0F50
	dc.w	$0FD0,$0F60,$0FE0,$0F70
	dc.w	$0FF0,$0FF8,$0FF1,$0FF9
	dc.w	$0FF2,$0FFA,$0FF3,$0FFB
	dc.w	$0FF4,$0FFC,$0FF5,$0FFD
	dc.w	$0775,$0EEC,$0664,$0DDB
	dc.w	$0553,$0CCA,$0442,$0BB9
	dc.w	$0331,$0AA8,$0220,$0990
	dc.w	$0110,$0880,$0000,$0000
	dc.w	$0000,$0000,$0F00,$0F00
	ENDC

************************************************
*                                              *
*         Save/Restore System Routines         *
*                                              *
************************************************
Save_and_init_st:
                move #$2700,sr

                lea	Save_all,a0                  ; Save adresses parameters
                move.b	$fffffa03.w,(a0)+
                move.b	$fffffa07.w,(a0)+
                move.b	$fffffa09.w,(a0)+
                move.b	$fffffa11.w,(a0)+
                move.b	$fffffa13.w,(a0)+
                move.b	$fffffa15.w,(a0)+
                move.b	$fffffa17.w,(a0)+
                move.b	$fffffa19.w,(a0)+
                move.b	$fffffa1b.w,(a0)+
                move.b	$fffffa1d.w,(a0)+
                move.b	$fffffa1f.w,(a0)+
                move.b	$fffffa21.w,(a0)+
                move.b	$ffff8201.w,(a0)+
                move.b	$ffff8203.w,(a0)+
                move.b	$ffff820a.w,(a0)+
                move.b	$ffff820d.w,(a0)+

                lea	Save_rest,a0                  ; Save adresses parameters
                move.l	$068.w,(a0)+	
                move.l	$070.w,(a0)+	
                move.l	$110.w,(a0)+	
                move.l	$114.w,(a0)+	
                move.l	$118.w,(a0)+	
                move.l	$120.w,(a0)+	
                move.l	$134.w,(a0)+	
                move.l	$484.w,(a0)+	

                movem.l	$ffff8240.w,d0-d7        ; Save palette GEM system
                movem.l	d0-d7,(a0)

                bclr	#3,$fffffa17.w             ; Clear Timers
                clr.b	$fffffa07.w
                clr.b	$fffffa09.w 
                clr.b	$484.w                     ; No bip, no repeat

                stop	#$2300

                move	#4,-(sp)                   ; Save & Change Resolution (GetRez)
                trap	#14	                       ; Get Current Res.
                addq.l	#2,sp
                move	d0,Old_Resol+2

                move	#3,-(sp)                   ; Save Screen Address (Logical)
                trap	#14
                addq.l	#2,sp
                move.l	d0,Old_Screen+2

                bsr	hide_mouse                   ; Keyboard and mouse
                bsr	flush
                move.b	#$12,d0
                bsr	setkeyboard

.wait_for_drive:move.w	$ffff8604.w,d0           ; Stop Floppy drive
                btst	#7,d0
                bne.s	.wait_for_drive

	IFEQ	TOPBOTTOM_BORDER
                MOVE.B    #$21,$FFFFFA07.W
                MOVE.B    #$21,$FFFFFA13.W
                CLR.B     $FFFFFA09.W 
                CLR.B     $FFFFFA15.W 
                CLR.B     $FFFFFA19.W 
                CLR.B     $FFFFFA1B.W 
                MOVE.L    #RTE,$68.W
                MOVE.L    #TIMER_A,$134.W 
                MOVE.L    #HBL_blanc,$120.W 
	ENDC
                rts

Restore_st:     move #$2700,sr

                jsr	Buffer_LZ7+4                      ; de-init music

                lea       $ffff8800.w,a0         ; Cut sound
                move.l    #$8000000,(a0)
                move.l    #$9000000,(a0)
                move.l    #$a000000,(a0)

                IFEQ	ERROR_SYS
                bsr	OUTPUT_TRACE_ERROR
                ENDC

                lea	Save_all,a0                  ; Restore adresses parameters
                move.b	(a0)+,$fffffa03.w
                move.b	(a0)+,$fffffa07.w
                move.b	(a0)+,$fffffa09.w
                move.b	(a0)+,$fffffa11.w
                move.b	(a0)+,$fffffa13.w
                move.b	(a0)+,$fffffa15.w
                move.b	(a0)+,$fffffa17.w
                move.b	(a0)+,$fffffa19.w
                move.b	(a0)+,$fffffa1b.w
                move.b	(a0)+,$fffffa1d.w
                move.b	(a0)+,$fffffa1f.w
                move.b	(a0)+,$fffffa21.w
                move.b	(a0)+,$ffff8201.w
                move.b	(a0)+,$ffff8203.w
                move.b	(a0)+,$ffff820a.w
                move.b	(a0)+,$ffff820d.w

                lea	Save_rest,a0                 ; Restore adresses parameters
                move.l	(a0)+,$068.w
                move.l	(a0)+,$070.w
                move.l	(a0)+,$110.w
                move.l	(a0)+,$114.w
                move.l	(a0)+,$118.w
                move.l	(a0)+,$120.w
                move.l	(a0)+,$134.w
                move.l	(a0)+,$484.w

                movem.l	(a0),d0-d7               ; Restore palette GEM system
                movem.l	d0-d7,$ffff8240.w

                bset.b #3,$fffffa17.w            ; Re-active Timer C

                stop	#$2300

                bsr	flush                        ; Restore keyboard and mouse
                move.b	#8,d0
                bsr	setkeyboard	
                bsr	show_mouse

Old_Resol:      move	#0,-(sp) ; Restore Old Screen & Resolution
Old_Screen:     move.l	#0,-(sp)
                move.l	(sp),-(sp)
                move	#5,-(sp)
                trap	#14
                lea	12(sp),sp

                move.w	#$25,-(a7)               ; VSYNC
                trap	#14
                addq.w	#2,a7
                rts

hide_mouse:     movem.l	d0-d2/a0-a2,-(sp)
                dc.w	$a00a
                movem.l	(sp)+,d0-d2/a0-a2
                rts

show_mouse:     movem.l	d0-d2/a0-a2,-(sp)
                dc.w	$A009
                movem.l	(sp)+,d0-d2/a0-a2
                rts

flush:          lea	$FFFFFC00.w,a0
.flush:         move.b	2(a0),d0
                btst	#0,(a0)
                bne.s	.flush
                rts

setkeyboard:    btst	#1,$fffffc00.w
                beq.s	setkeyboard
                move.b	d0,$FFFFFC02.w
                rts

clear_bss:      lea	bss_start,a0
.loop:          clr.l	(a0)+
                cmp.l	#bss_end,a0
                blt.s	.loop
                rts

************************************************
*                                              *
*               Sub Routines                   *
*                                              *
************************************************

***************************************************************
*                                                             *
*         BARS RASTER MOVEMENT BY ZORRO2/NOEXTRA-TEAM         *
*                                                             *
***************************************************************
KEYPAD:         CMPI.B    #$48,$FFFFFC02.W	; CURSEUR HAUT
                BNE.s     .suite 
                CMPI.W    #0,POSITION_BARRE
                BEQ.s     .suite 
                MOVE.W    #1,SENS_BARRE
.suite:         CMPI.B    #$50,$FFFFFC02.W	; CURSEUR BAS
                BNE.s     .fin 
                CMPI.W    #10-1,POSITION_BARRE
                BEQ.s     .fin 
                MOVE.W    #2,SENS_BARRE
.fin:           RTS 

MVT_BARRE:      CMPI.W    #1,SENS_BARRE
                BNE.s     .bas 
.haut:          SUBQ.B    #1,HBL_POS_1
                ADDQ.B    #1,HBL_POS_2
                ADD.W	  #1,BAR_TEMPO
                CMPI.W    #10-2,BAR_TEMPO
                BlE.S	  .fin
                CLR.W     SENS_BARRE 
                MOVE.W	  #0,BAR_TEMPO
                SUBI.W    #1,POSITION_BARRE
                SUB.L    #1,$40.W
.bas:           CMPI.W    #2,SENS_BARRE
                BNE.s     .fin 
                ADDQ.B    #1,HBL_POS_1
                SUBQ.B    #1,HBL_POS_2
                ADD.W	  #1,BAR_TEMPO
                CMPI.W    #10-2,BAR_TEMPO
                BlE.S	  .fin
                CLR.W     SENS_BARRE 
                MOVE.W	  #0,BAR_TEMPO
                ADDI.W    #1,POSITION_BARRE
                ADD.L    #1,$40.W
.fin:           RTS 

************************************************
*         Little Vumeters by FANTOMAS          *
************************************************
DIGITS:         lea $ff8800,a0

                move.l physique(pc),a1
                add.l #(180*160)+8*7+4,a1
                lea (a1),a2

i               set 0
                rept 16
                clr.w i(a1)
i               set i-160
                endr

                moveq #0,d0                 ; Voie 1
                move.b #8,(a0)
                move.b (a0),d0
                cmp.b #16,d0
                blt.s ok1
                move.b #15,d0
ok1:            move.w #%11100000000000,(a1)
                lea -160(a1),a1
                dbf d0,ok1

                move.l a2,a1                ; Voie 2
                moveq #0,d0
                move.b #9,(a0)
                move.b (a0),d0
                cmp.b #16,d0
                blt.s ok2
                move.b #15,d0
ok2:            or.w #%000000111000000,(a1)
                lea -160(a1),a1
                dbf d0,ok2

                move.l a2,a1                ; Voie 3
                moveq #0,d0
                move.b #10,(a0)
                move.b (a0),d0
                cmp.b #16,d0
                blt.s ok3
                move.b #15,d0
ok3:            or.w #%0000000000001110,(a1)
                lea -160(a1),a1
                dbf d0,ok3

                move.l physique(pc),a1
                add.l #(165*160)+8*7+4,a1

i               set 0
                rept 8
                clr.w i(a1)
i               set i+160
                endr

                RTS

***************************************************************
*                                                             *
*         TEXT FONT 8*8 ONE PLANE BY AVENGER/AL TEAM          *
*  ADAPTED FOR EXTRA FONT OF MISTER.A BY ZORRO2/NOEXTRA-TEAM  *
*                                                             *
***************************************************************
MED equ 1
LOW equ 0
CHARS      equ 40  ; chars per line, 80=for med res, 40 for low res
LINES      equ 33  ; 33 for 8x8 font, 45 with 6x6 font 
FONTSIZE   equ 8   ; 8=8x8, 6=6x6 font
SHIFTSIZE  equ 4   ; 2=MED RESOLUTION, 4=FOR LOW RESOLUTION
RESOLUTION equ LOW ; if no, then its low resolution

print_text:     clr.w	x_curs
                clr.l	x_offset
                clr.l	y_offset
new_char:       bsr     _x_conversion
                moveq   #0,d0    
                move.b  (a2)+,d0	;if zero, stop routine
                cmp.b	#0,d0
                beq	LF
                cmp.b	#$ff,d0
                bne.s   process_char
                rts

process_char:   asl.w 	#3,d0                ; valeur * 8
                cmpi.w #$FFF,FONTE_USED
                beq.s  .fonte2
                lea   fonte1(pc),a1	
                bra.s .its_ok
.fonte2:        lea   fonte2(pc),a1
.its_ok:        sub.w	#256,d0         
                adda.w  d0,a1

ESPACE equ 68+7
                movea.l physique(pc),a0
                lea     160*ESPACE(a0),a0
                add.w   #4,a0
                adda.l  y_offset(pc),a0
                adda.l  x_offset(pc),a0
                
                movea.l physique+4(pc),a3
                lea     160*ESPACE(a3),a3
                add.w   #4,a3
                adda.l  y_offset(pc),a3
                adda.l  x_offset(pc),a3
                
                rept	FONTSIZE
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

LF:             clr.w	x_curs                 ; back to first char
                addi.l  #FONTSIZE*160+160,y_offset ; linefeed when reached ',0'
                cmpi.l  #LINES*FONTSIZE*160,y_offset
                bls     new_char
                move.l  #LINES*FONTSIZE*160,y_offset
                bra     new_char

_x_conversion:  move.w	x_curs(pc),d0
                and.l	#$ffff,d0
                btst	#0,d0
                beq.s	_even
                subq.w	#1,d0
                mulu	#SHIFTSIZE,d0          ; 2=med res, 4=low
                addq.w	#1,d0
                bra	_done_conv
_even:          mulu	#SHIFTSIZE,d0          ; 2=med res, 4=low
_done_conv:     move.l	d0,x_offset
                rts

message1:
	DC.B	" BIG Z.......................DEBUG/NEXT",0
	DC.B	" BIS CD-MAG 1..............BUG IN SPACE",0
	DC.B	" 80+20 SPRITES.................AVENGERS",0
	DC.B	" HEADACHE (ORIGINAL VERSION)........OVR",0
	DC.B	" SHERMAN CRACKTRO........THE INVISIBLES",0
	DC.B	" TOUTALENVERSMJJ................MJJPROD",0
	DC.B	" DARKLIGHT......WARRIOR MUNK/POSTMORTEM",0
	DC.B	" FIRST INTRO.............NEW GENERATION",0
	DC.B	" LANDSCAPE OF THE MOON....ST APOCALYPSE",0
	DC.B	" TWISTSCROLL 2...........THE RESISTANCE",$ff
	even

message2:
	DCB.W     5,$0
	DC.B      0," CODE:ZORRO 2   :TOMCHI GFX:MISTER.A",$ff
	even

x_curs:       dc.l 0
y_offset:     dc.l 0
x_offset:     dc.l 0
FONTE_USED:   dc.w 0

fonte1:
	incbin 	"FONT88F.DAT"
	EVEN

fonte2:
	incbin 	"FONT88L.DAT"
	EVEN

***************************************************************
*                                                             *
*     SCROLLING 64*64 ONE BITPLANE - ATOMUS/NOEXTRA-TEAM      *
*                                                             *
***************************************************************
MYSCROLL:MOVEA.L   PTR_SCROLLD,A0
      MOVEA.L   (A0)+,A6
      CMPA.L    #$FFFFFFFF,A6 
      BNE       .notend 
      MOVE.L    #SCROLLD,PTR_SCROLLD
      MOVE.L    SWAPM1,SWAPM0 
      MOVE.L    SWAPM2,SWAPM1 
      MOVE.L    SWAPM3,SWAPM2 
      MOVE.L    SWAPM4,SWAPM3 
.repeat:CLR.L     D0
      MOVEA.L   PTR2_TXTSCROL,A0
      MOVE.B    (A0)+,D0
      MOVE.L    A0,PTR2_TXTSCROL
      CMP.B     #$FF,D0 
      BNE.s       .norepeat 
      MOVE.L    PTR1_TXTSCROL,PTR2_TXTSCROL 
      BRA.s       .repeat 
.norepeat:CMP.B     #$20,D0 
      BNE.s       .go 
      MOVE.L    #BUFFERM,SWAPM4
      BRA.s       .swap 
.go:SUBI.B    #$21,D0 
      ROL.L     #2,D0 
      LEA       PLACE,A0
      MOVE.L    0(A0,D0.W),SWAPM4
.swap:BRA       MYSCROLL 
.notend:MOVE.L    A0,PTR_SCROLLD
      MOVEA.L   SWAPM0,A0
      MOVEA.L   SWAPM1,A1
      MOVEA.L   SWAPM2,A2
      MOVEA.L   SWAPM3,A3
      MOVEA.L   SWAPM4,A4
      CMPI.W    #0,SCROLL_CPT
      BEQ.s       .inc_cpt 
      MOVE.W    #0,SCROLL_CPT
      CMPA.L    #BUFFERM,A0 
      BEQ.s       .swap0 
      ADDA.L    #$3200,A0 
.swap0:CMPA.L    #BUFFERM,A1 
      BEQ.s       .swap1 
      ADDA.L    #$3200,A1 
.swap1:CMPA.L    #BUFFERM,A2 
      BEQ.s       .swap2 
      ADDA.L    #$3200,A2 
.swap2:CMPA.L    #BUFFERM,A3 
      BEQ.s       .swap3 
      ADDA.L    #$3200,A3 
.swap3:CMPA.L    #BUFFERM,A4 
      BEQ.s       .swap4 
      ADDA.L    #$3200,A4 
.swap4:BRA.S     PUTSCROLL 
.inc_cpt:MOVE.W    #1,SCROLL_CPT
PUTSCROLL:
      MOVEA.L   physique,A5
      lea (188*160)+0(a5),a5
      JMP       (A6)
      
SCROLL1:MOVEQ     #$27,D0 
.loop:MOVE.W    (A0),(A5) 
      MOVE.W    (A0)+,160(A5) 
      MOVE.W    (A0),8(A5)
      MOVE.W    (A0)+,168(A5) 
      MOVE.W    (A0),16(A5) 
      MOVE.W    (A0)+,176(A5) 
      MOVE.W    (A0),24(A5) 
      MOVE.W    (A0)+,184(A5) 
      MOVE.W    (A0),32(A5) 
      MOVE.W    (A0)+,192(A5) 
      MOVE.W    (A1),40(A5) 
      MOVE.W    (A1)+,200(A5) 
      MOVE.W    (A1),48(A5) 
      MOVE.W    (A1)+,208(A5) 
      MOVE.W    (A1),56(A5) 
      MOVE.W    (A1)+,216(A5) 
      MOVE.W    (A1),64(A5) 
      MOVE.W    (A1)+,224(A5) 
      MOVE.W    (A1),72(A5) 
      MOVE.W    (A1)+,232(A5) 
      MOVE.W    (A2),80(A5) 
      MOVE.W    (A2)+,240(A5) 
      MOVE.W    (A2),88(A5) 
      MOVE.W    (A2)+,248(A5) 
      MOVE.W    (A2),96(A5) 
      MOVE.W    (A2)+,256(A5) 
      MOVE.W    (A2),104(A5)
      MOVE.W    (A2)+,264(A5) 
      MOVE.W    (A2),112(A5)
      MOVE.W    (A2)+,272(A5) 
      MOVE.W    (A3),120(A5)
      MOVE.W    (A3)+,280(A5) 
      MOVE.W    (A3),128(A5)
      MOVE.W    (A3)+,288(A5) 
      MOVE.W    (A3),136(A5)
      MOVE.W    (A3)+,296(A5) 
      MOVE.W    (A3),144(A5)
      MOVE.W    (A3)+,304(A5) 
      MOVE.W    (A3),152(A5)
      MOVE.W    (A3)+,312(A5) 
      ADDA.L    #$96,A0 
      ADDA.L    #$96,A1 
      ADDA.L    #$96,A2 
      ADDA.L    #$96,A3 
      ADDA.L    #$140,A5
      DBF       D0,.loop
      RTS 
SCROLL2:MOVEQ     #$27,D0 
      ADDA.L    #2,A0 
.loop:MOVE.W    (A0),(A5) 
      MOVE.W    (A0)+,160(A5) 
      MOVE.W    (A0),8(A5)
      MOVE.W    (A0)+,168(A5) 
      MOVE.W    (A0),16(A5) 
      MOVE.W    (A0)+,176(A5) 
      MOVE.W    (A0),24(A5) 
      MOVE.W    (A0)+,184(A5) 
      MOVE.W    (A1),32(A5) 
      MOVE.W    (A1)+,192(A5) 
      MOVE.W    (A1),40(A5) 
      MOVE.W    (A1)+,200(A5) 
      MOVE.W    (A1),48(A5) 
      MOVE.W    (A1)+,208(A5) 
      MOVE.W    (A1),56(A5) 
      MOVE.W    (A1)+,216(A5) 
      MOVE.W    (A1),64(A5) 
      MOVE.W    (A1)+,224(A5) 
      MOVE.W    (A2),72(A5) 
      MOVE.W    (A2)+,232(A5) 
      MOVE.W    (A2),80(A5) 
      MOVE.W    (A2)+,240(A5) 
      MOVE.W    (A2),88(A5) 
      MOVE.W    (A2)+,248(A5) 
      MOVE.W    (A2),96(A5) 
      MOVE.W    (A2)+,256(A5) 
      MOVE.W    (A2),104(A5)
      MOVE.W    (A2)+,264(A5) 
      MOVE.W    (A3),112(A5)
      MOVE.W    (A3)+,272(A5) 
      MOVE.W    (A3),120(A5)
      MOVE.W    (A3)+,280(A5) 
      MOVE.W    (A3),128(A5)
      MOVE.W    (A3)+,288(A5) 
      MOVE.W    (A3),136(A5)
      MOVE.W    (A3)+,296(A5) 
      MOVE.W    (A3),144(A5)
      MOVE.W    (A3)+,304(A5) 
      MOVE.W    (A4),152(A5)
      MOVE.W    (A4)+,312(A5) 
      ADDA.L    #$98,A0 
      ADDA.L    #$96,A1 
      ADDA.L    #$96,A2 
      ADDA.L    #$96,A3 
      ADDA.L    #$9E,A4 
      ADDA.L    #$140,A5
      DBF       D0,.loop
      RTS 
SCROLL3:MOVEQ     #$27,D0 
      ADDA.L    #4,A0 
.loop:MOVE.W    (A0),(A5) 
      MOVE.W    (A0)+,160(A5) 
      MOVE.W    (A0),8(A5)
      MOVE.W    (A0)+,168(A5) 
      MOVE.W    (A0),16(A5) 
      MOVE.W    (A0)+,176(A5) 
      MOVE.W    (A1),24(A5) 
      MOVE.W    (A1)+,184(A5) 
      MOVE.W    (A1),32(A5) 
      MOVE.W    (A1)+,192(A5) 
      MOVE.W    (A1),40(A5) 
      MOVE.W    (A1)+,200(A5) 
      MOVE.W    (A1),48(A5) 
      MOVE.W    (A1)+,208(A5) 
      MOVE.W    (A1),56(A5) 
      MOVE.W    (A1)+,216(A5) 
      MOVE.W    (A2),64(A5) 
      MOVE.W    (A2)+,224(A5) 
      MOVE.W    (A2),72(A5) 
      MOVE.W    (A2)+,232(A5) 
      MOVE.W    (A2),80(A5) 
      MOVE.W    (A2)+,240(A5) 
      MOVE.W    (A2),88(A5) 
      MOVE.W    (A2)+,248(A5) 
      MOVE.W    (A2),96(A5) 
      MOVE.W    (A2)+,256(A5) 
      MOVE.W    (A3),104(A5)
      MOVE.W    (A3)+,264(A5) 
      MOVE.W    (A3),112(A5)
      MOVE.W    (A3)+,272(A5) 
      MOVE.W    (A3),120(A5)
      MOVE.W    (A3)+,280(A5) 
      MOVE.W    (A3),128(A5)
      MOVE.W    (A3)+,288(A5) 
      MOVE.W    (A3),136(A5)
      MOVE.W    (A3)+,296(A5) 
      MOVE.W    (A4),144(A5)
      MOVE.W    (A4)+,304(A5) 
      MOVE.W    (A4),152(A5)
      MOVE.W    (A4)+,312(A5) 
      ADDA.L    #$9A,A0 
      ADDA.L    #$96,A1 
      ADDA.L    #$96,A2 
      ADDA.L    #$96,A3 
      ADDA.L    #$9C,A4 
      ADDA.L    #$140,A5
      DBF       D0,.loop
      RTS 
SCROLL4:MOVEQ     #$27,D0 
      ADDA.L    #6,A0 
.loop:MOVE.W    (A0),(A5) 
      MOVE.W    (A0)+,160(A5) 
      MOVE.W    (A0),8(A5)
      MOVE.W    (A0)+,168(A5) 
      MOVE.W    (A1),16(A5) 
      MOVE.W    (A1)+,176(A5) 
      MOVE.W    (A1),24(A5) 
      MOVE.W    (A1)+,184(A5) 
      MOVE.W    (A1),32(A5) 
      MOVE.W    (A1)+,192(A5) 
      MOVE.W    (A1),40(A5) 
      MOVE.W    (A1)+,200(A5) 
      MOVE.W    (A1),48(A5) 
      MOVE.W    (A1)+,208(A5) 
      MOVE.W    (A2),56(A5) 
      MOVE.W    (A2)+,216(A5) 
      MOVE.W    (A2),64(A5) 
      MOVE.W    (A2)+,224(A5) 
      MOVE.W    (A2),72(A5) 
      MOVE.W    (A2)+,232(A5) 
      MOVE.W    (A2),80(A5) 
      MOVE.W    (A2)+,240(A5) 
      MOVE.W    (A2),88(A5) 
      MOVE.W    (A2)+,248(A5) 
      MOVE.W    (A3),96(A5) 
      MOVE.W    (A3)+,256(A5) 
      MOVE.W    (A3),104(A5)
      MOVE.W    (A3)+,264(A5) 
      MOVE.W    (A3),112(A5)
      MOVE.W    (A3)+,272(A5) 
      MOVE.W    (A3),120(A5)
      MOVE.W    (A3)+,280(A5) 
      MOVE.W    (A3),128(A5)
      MOVE.W    (A3)+,288(A5) 
      MOVE.W    (A4),136(A5)
      MOVE.W    (A4)+,296(A5) 
      MOVE.W    (A4),144(A5)
      MOVE.W    (A4)+,304(A5) 
      MOVE.W    (A4),152(A5)
      MOVE.W    (A4)+,312(A5) 
      ADDA.L    #$9C,A0 
      ADDA.L    #$96,A1 
      ADDA.L    #$96,A2 
      ADDA.L    #$96,A3 
      ADDA.L    #$9A,A4 
      ADDA.L    #$140,A5
      DBF       D0,.loop
      RTS 
SCROLL5:MOVEQ     #$27,D0 
      ADDA.L    #8,A0 
.loop:MOVE.W    (A0),0(A5) 
      MOVE.W    (A0)+,160(A5) 
      MOVE.W    (A1),8(A5)
      MOVE.W    (A1)+,168(A5) 
      MOVE.W    (A1),16(A5) 
      MOVE.W    (A1)+,176(A5) 
      MOVE.W    (A1),24(A5) 
      MOVE.W    (A1)+,184(A5) 
      MOVE.W    (A1),32(A5) 
      MOVE.W    (A1)+,192(A5) 
      MOVE.W    (A1),40(A5) 
      MOVE.W    (A1)+,200(A5) 
      MOVE.W    (A2),48(A5) 
      MOVE.W    (A2)+,208(A5) 
      MOVE.W    (A2),56(A5) 
      MOVE.W    (A2)+,216(A5) 
      MOVE.W    (A2),64(A5) 
      MOVE.W    (A2)+,224(A5) 
      MOVE.W    (A2),72(A5) 
      MOVE.W    (A2)+,232(A5) 
      MOVE.W    (A2),80(A5) 
      MOVE.W    (A2)+,240(A5) 
      MOVE.W    (A3),88(A5) 
      MOVE.W    (A3)+,248(A5) 
      MOVE.W    (A3),96(A5) 
      MOVE.W    (A3)+,256(A5) 
      MOVE.W    (A3),104(A5)
      MOVE.W    (A3)+,264(A5) 
      MOVE.W    (A3),112(A5)
      MOVE.W    (A3)+,272(A5) 
      MOVE.W    (A3),120(A5)
      MOVE.W    (A3)+,280(A5) 
      MOVE.W    (A4),128(A5)
      MOVE.W    (A4)+,288(A5) 
      MOVE.W    (A4),136(A5)
      MOVE.W    (A4)+,296(A5) 
      MOVE.W    (A4),144(A5)
      MOVE.W    (A4)+,304(A5) 
      MOVE.W    (A4),152(A5)
      MOVE.W    (A4)+,312(A5) 
      ADDA.L    #$9E,A0 
      ADDA.L    #$96,A1 
      ADDA.L    #$96,A2 
      ADDA.L    #$96,A3 
      ADDA.L    #$98,A4 
      ADDA.L    #$140,A5
      DBF       D0,.loop
      RTS 

***************************************************************
*                                                             *
*            STARS MOVEMENT BY ATOMUS/NOEXTRA-TEAM            *
*                                                             *
***************************************************************
PRINT_STARS:
      BSR  EFF_MINI_S 
      BSR  EFF_PET_S 
      BSR  EFF_MOY_S 
      BSR  EFF_GRO_S 
      BSR  AFF_COURBE 
      BSR  AFF_MINI_S * mini sprite
      BSR  AFF_PET_S * petit sprite
      BSR  AFF_MOY_S * moyen sprite
      BSR  AFF_GRO_S * gros sprite
      RTS

AFF_COURBE:
      LEA       DATA_ET2(PC),A0
      LEA       DATA_ET22(PC),A1
      MOVEA.L   (A0),A2 
      MOVEM.W   (A2)+,D0-D7 
      MOVEM.W   D0-D7,(A1)
      CMPI.W    #$63,(A2) 
      BNE.S     .next0 
      MOVEA.L   DATA_ET0(PC),A3
      LEA       DATA_ET3(PC),A4
      MOVE.B    (A3)+,D0
      EXT.W     D0
      ADD.W     D0,D0 
      ADD.W     D0,D0 
      MOVEA.L   0(A4,D0.W),A2 
      TST.B     (A3)
      BPL.S     .next 
      LEA       DATA_ET1(PC),A3
.next:MOVE.L    A3,DATA_ET0
.next0:MOVE.L    A2,(A0) 
      RTS 

POSITION_ETOILE equ 160*67

AFF_MINI_S:LEA       DATA_ET33(PC),A0
      MOVEA.L   physique(PC),A1
      LEA       POSITION_ETOILE(A1),A1 
      LEA       BUFF_ET3,A2
      TST.W     TEST 
      BPL.S     .next 
      LEA       18(A2),A2 
.next:MOVE.W    DATA_ET25(PC),D5
      MOVE.W    DATA_ET29(PC),D6
      MOVEQ     #8,D4 
loop:MOVE.W    (A0),D0 
      ADD.W     D5,D0 
      CMP.W     #$1E,D0 
      BLT.S     INC0 
      CMP.W     #$121,D0
      BGT.S     INC1 
NEXT0:MOVE.W    D0,(A0)+
      MOVE.W    (A0),D1 
      ADD.W     D6,D1 
      CMP.W     #$960,D1
      BLT.S     INC2 
      CMP.W     #$35C0,D1 
      BGT.S     INC3 
NEXT1:MOVE.W    D1,(A0)+
      MOVE.W    D0,D2 
      AND.W     #$F,D0
      ADD.W     D0,D0 
      MOVE.W    DATA_E0(PC,D0.W),D3 
      AND.W     #$FFF0,D2 
      LSR.W     #1,D2 
      ADD.W     D1,D2 
      MOVE.W    D2,(A2)+
      OR.W      D3,0(A1,D2.W) 
      DBF       D4,loop
      RTS 
DATA_E0:DCB.W     16,0
INC0:ADDI.W    #$104,D0
      BRA.S     NEXT0 
INC1:SUBI.W    #$104,D0
      BRA.S     NEXT0 
INC2:ADDI.W    #$2D00,D1 
      BRA.S     NEXT1 
INC3:SUBI.W    #$2D00,D1 
      BRA.S     NEXT1 
INC4:LEA       DATA_ET21(PC),A0
      LEA       DATA_E0(PC),A1
      MOVEQ     #$F,D0
      MOVEQ     #0,D1 
.loop:MOVE.W    (A0),D2 
      ROR.W     D1,D2 
      MOVE.W    D2,(A1)+
      ADDQ.W    #1,D1 
      DBF       D0,.loop
      RTS 
EFF_MINI_S:LEA       BUFF_ET3,A0
      TST.W     TEST 
      BPL.S     .next 
      LEA       18(A0),A0 
.next:MOVEA.L   physique(PC),A1
      LEA       POSITION_ETOILE(A1),A1 
      MOVEQ     #0,D0 
 rept 9
      MOVE.W    (A0)+,D1
      MOVE.W    D0,0(A1,D1.W) 
 endr
      RTS 
AFF_PET_S:LEA       DATA_ET32(PC),A0
      MOVEA.L   physique(PC),A4
      LEA       POSITION_ETOILE(A4),A4 
      LEA       BUFF_ET2,A2
      TST.W     TEST 
      BPL.S     .next 
      LEA       60(A2),A2 
.next:MOVE.W    DATA_ET24(PC),D5
      MOVE.W    DATA_ET28(PC),D6
      MOVEQ     #9,D4 
loop0:MOVE.W    (A0),D0 
      ADD.W     D5,D0 
      CMPI.W    #$13,D0 *
      BLT.S     INC5 
      CMP.W     #$12A,D0 *
      BGT.S     INC6 
NEXT2:MOVE.W    D0,(A0)+
      MOVE.W    (A0),D1 
      ADD.W     D6,D1 
      CMP.W     #$640,D1 *
      BLT.S     INC7 
      CMP.W     #$37A0,D1 *
      BGT.S     INC8 
NEXT3:MOVE.W    D1,(A0)+
      MOVEA.L   A4,A1 
      BSR       NEXT16 
      DBF       D4,loop0
      RTS 
INC5:ADDI.W    #$118,D0
      BRA.S     NEXT2 
INC6:SUBI.W    #$118,D0
      BRA.S     NEXT2 
INC7:MOVE.W    #$37A0,D1 
      BRA.S     NEXT3 
INC8:MOVE.W    #$640,D1
      BRA.S     NEXT3 
AFF_MOY_S:LEA       DATA_ET31(PC),A0
      MOVEA.L   physique(PC),A4
      LEA       POSITION_ETOILE(A4),A4 
      LEA       BUFF_ET1,A2
      TST.W     TEST 
      BPL.S     .next 
      LEA       60(A2),A2 
.next:MOVE.W    DATA_ET23(PC),D5
      MOVE.W    DATA_ET27(PC),D6
      MOVEQ     #9,D4 
loop1:MOVE.W    (A0),D0 
      ADD.W     D5,D0 
      CMPI.W    #6,D0 
      BLT.S     INC9 
      CMP.W     #$130,D0
      BGT.S     INC10 
NEXT4:MOVE.W    D0,(A0)+
      MOVE.W    (A0),D1 
      ADD.W     D6,D1 
      CMP.W     #$320,D1
      BLT.S     INC11 
      CMP.W     #$38E0,D1 
      BGT.S     INC12 
NEXT5:MOVE.W    D1,(A0)+
      MOVEA.L   A4,A1 
      BSR       NEXT12 
      DBF       D4,loop1
      RTS 
INC9:ADDI.W    #$12B,D0
      BRA.S     NEXT4 
INC10:SUBI.W    #$12B,D0
      BRA.S     NEXT4 
INC11:MOVE.W    #$38E0,D1 
      BRA.S     NEXT5 
INC12:MOVE.W    #$320,D1
      BRA.S     NEXT5 
AFF_GRO_S:LEA       DATA_ET30(PC),A0
      MOVEA.L   physique(PC),A4
      LEA       POSITION_ETOILE(A4),A4 
      LEA       BUFF_ET0,A2
      TST.W     TEST 
      BPL.S     .next 
      LEA       60(A2),A2 
.next:MOVE.W    DATA_ET22(PC),D5
      MOVE.W    DATA_ET26(PC),D6
      MOVEQ     #9,D4 
loop2:MOVE.W    (A0),D0 
      ADD.W     D5,D0 
      CMPI.W    #$FFF9,D0 
      BLT.S     INC13 
      CMP.W     #$13F,D0
      BGT.S     INC14 
NEXT6:MOVE.W    D0,(A0)+
      MOVE.W    (A0),D1 
      ADD.W     D6,D1 
      TST.W     D1
      BLT.S     INC15 
      CMP.W     #$3A20,D1 
      BGT.S     INC16 
NEXT7:MOVE.W    D1,(A0)+
      MOVEA.L   A4,A1 
      BSR.S     NEXT8 
      DBF       D4,loop2
      RTS 
INC13:ADDI.W    #$147,D0
      BRA.S     NEXT6 
INC14:SUBI.W    #$147,D0
      BRA.S     NEXT6 
INC15:MOVE.W    #$3A20,D1 
      BRA.S     NEXT7 
INC16:MOVE.W    #0,D1 
      BRA.S     NEXT7 
DATA_E1:DCB.W     32,0
NEXT8:MOVE.W    D0,D2 
      AND.W     #$F,D0
      CMPI.W    #8,D0 
      BLT       NEXT11 
      ADD.W     D0,D0 
      ADD.W     D0,D0 
      MOVEA.L   DATA_E1(PC,D0.W),A3 
      TST.W     D2
      BMI       NEXT9 
      CMPI.W    #$137,D2
      BGT       NEXT10 
      AND.W     #$FFF0,D2 
      LSR.W     #1,D2 
      ADD.W     D1,D2 
      ADDA.W    D2,A1 
      MOVE.L    A1,(A2) 
      NEG.L     (A2)+ 
      CLR.W     (A2)+ 
      MOVEP.W   1(A1),D0
      MOVEP.W   8(A1),D1
      AND.W     (A3)+,D0
      AND.W     (A3)+,D1
      OR.W      (A3)+,D0
      OR.W      (A3)+,D1
      MOVEP.W   D0,1(A1)
      MOVEP.W   D1,8(A1)
      MOVEP.W   161(A1),D0
      MOVEP.W   168(A1),D1
      AND.W     (A3)+,D0
      AND.W     (A3)+,D1
      OR.W      (A3)+,D0
      OR.W      (A3)+,D1
      MOVEP.W   D0,161(A1)
      MOVEP.W   D1,168(A1)
      MOVEP.W   321(A1),D0
      MOVEP.W   328(A1),D1
      AND.W     (A3)+,D0
      AND.W     (A3)+,D1
      OR.W      (A3)+,D0
      OR.W      (A3)+,D1
      MOVEP.W   D0,321(A1)
      MOVEP.W   D1,328(A1)
      MOVEP.W   481(A1),D0
      MOVEP.W   488(A1),D1
      AND.W     (A3)+,D0
      AND.W     (A3)+,D1
      OR.W      (A3)+,D0
      OR.W      (A3)+,D1
      MOVEP.W   D0,481(A1)
      MOVEP.W   D1,488(A1)
      MOVEP.W   641(A1),D0
      MOVEP.W   648(A1),D1
      AND.W     (A3)+,D0
      AND.W     (A3)+,D1
      OR.W      (A3)+,D0
      OR.W      (A3)+,D1
      MOVEP.W   D0,641(A1)
      MOVEP.W   D1,648(A1)
      MOVEP.W   801(A1),D0
      MOVEP.W   808(A1),D1
      AND.W     (A3)+,D0
      AND.W     (A3)+,D1
      OR.W      (A3)+,D0
      OR.W      (A3)+,D1
      MOVEP.W   D0,801(A1)
      MOVEP.W   D1,808(A1)
      MOVEP.W   961(A1),D0
      MOVEP.W   968(A1),D1
      AND.W     (A3)+,D0
      AND.W     (A3)+,D1
      OR.W      (A3)+,D0
      OR.W      (A3)+,D1
      MOVEP.W   D0,961(A1)
      MOVEP.W   D1,968(A1)
      MOVEP.W   1121(A1),D0 
      MOVEP.W   1128(A1),D1 
      AND.W     (A3)+,D0
      AND.W     (A3)+,D1
      OR.W      (A3)+,D0
      OR.W      (A3)+,D1
      MOVEP.W   D0,1121(A1) 
      MOVEP.W   D1,1128(A1) 
      RTS 
NEXT9:ADDA.W    D1,A1 
      MOVE.L    A1,(A2) 
      NEG.L     (A2)+ 
      MOVE.W    #$FFFF,(A2)+
      MOVEP.W   0(A1),D0
      AND.W     2(A3),D0
      OR.W      6(A3),D0
      MOVEP.W   D0,0(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   160(A1),D0
      AND.W     2(A3),D0
      OR.W      6(A3),D0
      MOVEP.W   D0,160(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   320(A1),D0
      AND.W     2(A3),D0
      OR.W      6(A3),D0
      MOVEP.W   D0,320(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   480(A1),D0
      AND.W     2(A3),D0
      OR.W      6(A3),D0
      MOVEP.W   D0,480(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   640(A1),D0
      AND.W     2(A3),D0
      OR.W      6(A3),D0
      MOVEP.W   D0,640(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   800(A1),D0
      AND.W     2(A3),D0
      OR.W      6(A3),D0
      MOVEP.W   D0,800(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   960(A1),D0
      AND.W     2(A3),D0
      OR.W      6(A3),D0
      MOVEP.W   D0,960(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   1120(A1),D0 
      AND.W     2(A3),D0
      OR.W      6(A3),D0
      MOVEP.W   D0,1120(A1) 
      RTS 
NEXT10:AND.W     #$FFF0,D2 
      LSR.W     #1,D2 
      ADD.W     D1,D2 
      ADDA.W    D2,A1 
      MOVE.L    A1,(A2) 
      NEG.L     (A2)+ 
      MOVE.W    #1,(A2)+
      MOVEP.W   1(A1),D0
      AND.W     (A3),D0 
      OR.W      4(A3),D0
      MOVEP.W   D0,1(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   161(A1),D0
      AND.W     (A3),D0 
      OR.W      4(A3),D0
      MOVEP.W   D0,161(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   321(A1),D0
      AND.W     (A3),D0 
      OR.W      4(A3),D0
      MOVEP.W   D0,321(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   481(A1),D0
      AND.W     (A3),D0 
      OR.W      4(A3),D0
      MOVEP.W   D0,481(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   641(A1),D0
      AND.W     (A3),D0 
      OR.W      4(A3),D0
      MOVEP.W   D0,641(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   801(A1),D0
      AND.W     (A3),D0 
      OR.W      4(A3),D0
      MOVEP.W   D0,801(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   961(A1),D0
      AND.W     (A3),D0 
      OR.W      4(A3),D0
      MOVEP.W   D0,961(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   1121(A1),D0 
      AND.W     (A3),D0 
      OR.W      4(A3),D0
      MOVEP.W   D0,1121(A1) 
      RTS 
DATA_E2:DCB.W     32,0
NEXT11:ADD.W     D0,D0 
      ADD.W     D0,D0 
      MOVEA.L   DATA_E2(PC,D0.W),A3 
      AND.W     #$FFF0,D2 
      LSR.W     #1,D2 
      ADD.W     D1,D2 
      ADDA.W    D2,A1 
      MOVE.L    A1,(A2)+
      MOVE.L    (A3)+,D0
      MOVE.L    (A3)+,D1
      AND.L     D0,(A1) 
      OR.L      D1,(A1) 
      LEA       160(A1),A1
      MOVE.L    (A3)+,D0
      MOVE.L    (A3)+,D1
      AND.L     D0,(A1) 
      OR.L      D1,(A1) 
      LEA       160(A1),A1
      MOVE.L    (A3)+,D0
      MOVE.L    (A3)+,D1
      AND.L     D0,(A1) 
      OR.L      D1,(A1) 
      LEA       160(A1),A1
      MOVE.L    (A3)+,D0
      MOVE.L    (A3)+,D1
      AND.L     D0,(A1) 
      OR.L      D1,(A1) 
      LEA       160(A1),A1
      MOVE.L    (A3)+,D0
      MOVE.L    (A3)+,D1
      AND.L     D0,(A1) 
      OR.L      D1,(A1) 
      LEA       160(A1),A1
      MOVE.L    (A3)+,D0
      MOVE.L    (A3)+,D1
      AND.L     D0,(A1) 
      OR.L      D1,(A1) 
      LEA       160(A1),A1
      MOVE.L    (A3)+,D0
      MOVE.L    (A3)+,D1
      AND.L     D0,(A1) 
      OR.L      D1,(A1) 
      LEA       160(A1),A1
      MOVE.L    (A3)+,D0
      MOVE.L    (A3)+,D1
      AND.L     D0,(A1) 
      OR.L      D1,(A1) 
      LEA       160(A1),A1
      RTS 
DATA_E3:DCB.W     32,0
NEXT12:MOVE.W    D0,D2 
      AND.W     #$F,D0
      CMPI.W    #8,D0 
      BLT       NEXT15 
      ADD.W     D0,D0 
      ADD.W     D0,D0 
      MOVEA.L   DATA_E3(PC,D0.W),A3 
      TST.W     D2
      BMI       NEXT13 
      CMPI.W    #$137,D2
      BGT       NEXT14 
      AND.W     #$FFF0,D2 
      LSR.W     #1,D2 
      ADD.W     D1,D2 
      ADDA.W    D2,A1 
      MOVE.L    A1,(A2) 
      NEG.L     (A2)+ 
      CLR.W     (A2)+ 
      MOVEP.W   1(A1),D0
      MOVEP.W   8(A1),D1
      AND.W     (A3)+,D0
      AND.W     (A3)+,D1
      OR.W      (A3)+,D0
      OR.W      (A3)+,D1
      MOVEP.W   D0,1(A1)
      MOVEP.W   D1,8(A1)
      MOVEP.W   161(A1),D0
      MOVEP.W   168(A1),D1
      AND.W     (A3)+,D0
      AND.W     (A3)+,D1
      OR.W      (A3)+,D0
      OR.W      (A3)+,D1
      MOVEP.W   D0,161(A1)
      MOVEP.W   D1,168(A1)
      MOVEP.W   321(A1),D0
      MOVEP.W   328(A1),D1
      AND.W     (A3)+,D0
      AND.W     (A3)+,D1
      OR.W      (A3)+,D0
      OR.W      (A3)+,D1
      MOVEP.W   D0,321(A1)
      MOVEP.W   D1,328(A1)
      MOVEP.W   481(A1),D0
      MOVEP.W   488(A1),D1
      AND.W     (A3)+,D0
      AND.W     (A3)+,D1
      OR.W      (A3)+,D0
      OR.W      (A3)+,D1
      MOVEP.W   D0,481(A1)
      MOVEP.W   D1,488(A1)
      MOVEP.W   641(A1),D0
      MOVEP.W   648(A1),D1
      AND.W     (A3)+,D0
      AND.W     (A3)+,D1
      OR.W      (A3)+,D0
      OR.W      (A3)+,D1
      MOVEP.W   D0,641(A1)
      MOVEP.W   D1,648(A1)
      RTS 
NEXT13:ADDA.W    D1,A1 
      MOVE.L    A1,(A2) 
      NEG.L     (A2)+ 
      MOVE.W    #$FFFF,(A2)+
      MOVEP.W   0(A1),D0
      AND.W     2(A3),D0
      OR.W      6(A3),D0
      MOVEP.W   D0,0(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   160(A1),D0
      AND.W     2(A3),D0
      OR.W      6(A3),D0
      MOVEP.W   D0,160(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   320(A1),D0
      AND.W     2(A3),D0
      OR.W      6(A3),D0
      MOVEP.W   D0,320(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   480(A1),D0
      AND.W     2(A3),D0
      OR.W      6(A3),D0
      MOVEP.W   D0,480(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   640(A1),D0
      AND.W     2(A3),D0
      OR.W      6(A3),D0
      MOVEP.W   D0,640(A1)
      ADDQ.L    #8,A3 
      RTS 
NEXT14:AND.W     #$FFF0,D2 
      LSR.W     #1,D2 
      ADD.W     D1,D2 
      ADDA.W    D2,A1 
      MOVE.L    A1,(A2) 
      NEG.L     (A2)+ 
      MOVE.W    #1,(A2)+
      MOVEP.W   1(A1),D0
      AND.W     (A3),D0 
      OR.W      4(A3),D0
      MOVEP.W   D0,1(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   161(A1),D0
      AND.W     (A3),D0 
      OR.W      4(A3),D0
      MOVEP.W   D0,161(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   321(A1),D0
      AND.W     (A3),D0 
      OR.W      4(A3),D0
      MOVEP.W   D0,321(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   481(A1),D0
      AND.W     (A3),D0 
      OR.W      4(A3),D0
      MOVEP.W   D0,481(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   641(A1),D0
      AND.W     (A3),D0 
      OR.W      4(A3),D0
      MOVEP.W   D0,641(A1)
      RTS 
DATA_E4:DCB.W     32,0
NEXT15:ADD.W     D0,D0 
      ADD.W     D0,D0 
      MOVEA.L   DATA_E4(PC,D0.W),A3 
      AND.W     #$FFF0,D2 
      LSR.W     #1,D2 
      ADD.W     D1,D2 
      ADDA.W    D2,A1 
      MOVE.L    A1,(A2)+
      MOVE.L    (A3)+,D0
      MOVE.L    (A3)+,D1
      AND.L     D0,(A1) 
      OR.L      D1,(A1) 
      LEA       160(A1),A1
      MOVE.L    (A3)+,D0
      MOVE.L    (A3)+,D1
      AND.L     D0,(A1) 
      OR.L      D1,(A1) 
      LEA       160(A1),A1
      MOVE.L    (A3)+,D0
      MOVE.L    (A3)+,D1
      AND.L     D0,(A1) 
      OR.L      D1,(A1) 
      LEA       160(A1),A1
      MOVE.L    (A3)+,D0
      MOVE.L    (A3)+,D1
      AND.L     D0,(A1) 
      OR.L      D1,(A1) 
      LEA       160(A1),A1
      MOVE.L    (A3)+,D0
      MOVE.L    (A3)+,D1
      AND.L     D0,(A1) 
      OR.L      D1,(A1) 
      LEA       160(A1),A1
      RTS 
DATA_E5:DCB.W     32,0
NEXT16:MOVE.W    D0,D2 
      AND.W     #$F,D0
      CMPI.W    #8,D0 
      BLT       NEXT19 
      ADD.W     D0,D0 
      ADD.W     D0,D0 
      MOVEA.L   DATA_E5(PC,D0.W),A3 
      CMP.W     #$14,D2 
      BLT.S     NEXT17 
      CMPI.W    #$122,D2
      BGT.S     NEXT18 
      AND.W     #$FFF0,D2 
      LSR.W     #1,D2 
      ADD.W     D1,D2 
      ADDA.W    D2,A1 
      MOVE.L    A1,(A2) 
      NEG.L     (A2)+ 
      CLR.W     (A2)+ 
      MOVEP.W   1(A1),D0
      MOVEP.W   8(A1),D1
      AND.W     (A3)+,D0
      AND.W     (A3)+,D1
      OR.W      (A3)+,D0
      OR.W      (A3)+,D1
      MOVEP.W   D0,1(A1)
      MOVEP.W   D1,8(A1)
      MOVEP.W   161(A1),D0
      MOVEP.W   168(A1),D1
      AND.W     (A3)+,D0
      AND.W     (A3)+,D1
      OR.W      (A3)+,D0
      OR.W      (A3)+,D1
      MOVEP.W   D0,161(A1)
      MOVEP.W   D1,168(A1)
      RTS 
NEXT17:ADDA.W    D1,A1 
      MOVE.L    A1,(A2) 
      NEG.L     (A2)+ 
      MOVE.W    #$FFFF,(A2)+
      MOVEP.W   0(A1),D0
      AND.W     2(A3),D0
      OR.W      6(A3),D0
      MOVEP.W   D0,0(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   160(A1),D0
      AND.W     2(A3),D0
      OR.W      6(A3),D0
      MOVEP.W   D0,160(A1)
      ADDQ.L    #8,A3 
      RTS 
NEXT18:AND.W     #$FFF0,D2 
      LSR.W     #1,D2 
      ADD.W     D1,D2 
      ADDA.W    D2,A1 
      MOVE.L    A1,(A2) 
      NEG.L     (A2)+ 
      MOVE.W    #1,(A2)+
      MOVEP.W   1(A1),D0
      AND.W     (A3),D0 
      OR.W      4(A3),D0
      MOVEP.W   D0,1(A1)
      ADDQ.L    #8,A3 
      MOVEP.W   161(A1),D0
      AND.W     (A3),D0 
      OR.W      4(A3),D0
      MOVEP.W   D0,161(A1)
      RTS 
DATA_E6:DCB.W     32,0
NEXT19:ADD.W     D0,D0 
      ADD.W     D0,D0 
      MOVEA.L   DATA_E6(PC,D0.W),A3 
      AND.W     #$FFF0,D2 
      LSR.W     #1,D2 
      ADD.W     D1,D2 
      ADDA.W    D2,A1 
      MOVE.L    A1,(A2)+
      MOVE.L    (A3)+,D0
      MOVE.L    (A3)+,D1
      AND.L     D0,(A1) 
      OR.L      D1,(A1) 
      LEA       160(A1),A1
      MOVE.L    (A3)+,D0
      MOVE.L    (A3)+,D1
      AND.L     D0,(A1) 
      OR.L      D1,(A1) 
      LEA       160(A1),A1
      RTS 
INIT_STARS:LEA       DATA_ET15(PC),A0
      LEA       DATA_ET16(PC),A1
      LEA       BUFF_ET4,A2
      LEA       DATA_E1(PC),A3
      LEA       DATA_E2(PC),A4
      MOVE.L    A3,D5 
      MOVE.L    A4,D6 
      MOVEQ     #7,D4 
      BSR.S     NEXT21 
      LEA       DATA_ET17(PC),A0
      LEA       DATA_ET18(PC),A1
      LEA       BUFF_ET5,A2
      LEA       DATA_E3(PC),A3
      LEA       DATA_E4(PC),A4
      MOVE.L    A3,D5 
      MOVE.L    A4,D6 
      MOVEQ     #4,D4 
      BSR.S     NEXT21 
      LEA       DATA_ET19(PC),A0
      LEA       DATA_ET20(PC),A1
      LEA       BUFF_ET6,A2
      LEA       DATA_E5(PC),A3
      LEA       DATA_E6(PC),A4
      MOVE.L    A3,D5 
      MOVE.L    A4,D6 
      MOVEQ     #1,D4 
      BSR.S     NEXT21 
      RTS 
NEXT21:MOVEA.L   D5,A3 
      MOVEA.L   D6,A6 
      MOVE.L    A2,(A3)+
      MOVE.L    A2,(A6)+
      MOVEA.L   A2,A5 
      MOVE.W    D4,D3 
NEXT22:MOVE.W    (A1)+,D2
      NOT.W     D2
      MOVE.W    D2,(A2)+
      MOVE.W    D2,(A2)+
      MOVE.L    (A0)+,(A2)+ 
      DBF       D3,NEXT22
      MOVEQ     #6,D0 
      MOVEQ     #1,D1 
NEXT23:MOVE.L    A2,(A3)+
      MOVE.L    A2,(A6)+
      MOVEA.L   A5,A4 
      MOVE.W    D4,D3 
NEXT24:MOVE.W    (A4)+,D2
      ROR.W     D1,D2 
      MOVE.W    D2,(A2)+
      MOVE.W    (A4)+,D2
      ROR.W     D1,D2 
      MOVE.W    D2,(A2)+
      MOVE.W    (A4)+,D2
      ROR.W     D1,D2 
      MOVE.W    D2,(A2)+
      MOVE.W    (A4)+,D2
      ROR.W     D1,D2 
      MOVE.W    D2,(A2)+
      DBF       D3,NEXT24
      ADDQ.W    #1,D1 
      DBF       D0,NEXT23
      MOVEA.L   D5,A4 
      MOVEQ     #7,D1 
.loop0:MOVE.L    A2,(A3)+
      MOVE.L    A2,(A6)+
      MOVEA.L   (A4)+,A5
      MOVE.W    D4,D0 
.loop1:MOVE.B    (A5),(A2)+
      MOVE.B    2(A5),(A2)+ 
      MOVE.B    1(A5),(A2)+ 
      MOVE.B    3(A5),(A2)+ 
      ADDQ.L    #4,A5 
      MOVE.B    (A5),(A2)+
      MOVE.B    2(A5),(A2)+ 
      MOVE.B    1(A5),(A2)+ 
      MOVE.B    3(A5),(A2)+ 
      ADDQ.L    #4,A5 
      DBF       D0,.loop1
      DBF       D1,.loop0
      RTS 
EFF_PET_S:LEA       BUFF_ET0,A0
      TST.W     TEST 
      BPL.S     .next 
      LEA       60(A0),A0 
.next:MOVEQ     #9,D1 
      MOVEQ     #0,D0 
LOOPA:MOVE.L    (A0)+,D2
      BMI.S     SPRITE1 
      BNE.S     SPRITE0 
      RTS 
SPRITE0:MOVEA.L   D2,A1 
      MOVE.L    D0,(A1) 
      MOVE.L    D0,160(A1)
      MOVE.L    D0,320(A1)
      MOVE.L    D0,480(A1)
      MOVE.L    D0,640(A1)
      MOVE.L    D0,800(A1)
      MOVE.L    D0,960(A1)
      MOVE.L    D0,1120(A1) 
      DBF       D1,LOOPA
      RTS 
SPRITE1:NEG.L     D2
      MOVEA.L   D2,A1 
      TST.W     (A0)+ 
      BMI.S     SPRITE2 
      BGT.S     SPRITE3 
      MOVEP.W   D0,1(A1)
      MOVEP.W   D0,8(A1)
      MOVEP.W   D0,161(A1)
      MOVEP.W   D0,168(A1)
      MOVEP.W   D0,321(A1)
      MOVEP.W   D0,328(A1)
      MOVEP.W   D0,481(A1)
      MOVEP.W   D0,488(A1)
      MOVEP.W   D0,641(A1)
      MOVEP.W   D0,648(A1)
      MOVEP.W   D0,801(A1)
      MOVEP.W   D0,808(A1)
      MOVEP.W   D0,961(A1)
      MOVEP.W   D0,968(A1)
      MOVEP.W   D0,1121(A1) 
      MOVEP.W   D0,1128(A1) 
      DBF       D1,LOOPA
      RTS 
SPRITE2:MOVEP.W   D0,0(A1)
      MOVEP.W   D0,160(A1)
      MOVEP.W   D0,320(A1)
      MOVEP.W   D0,480(A1)
      MOVEP.W   D0,640(A1)
      MOVEP.W   D0,800(A1)
      MOVEP.W   D0,960(A1)
      MOVEP.W   D0,1120(A1) 
      DBF       D1,LOOPA
      RTS 
SPRITE3:MOVEP.W   D0,1(A1)
      MOVEP.W   D0,161(A1)
      MOVEP.W   D0,321(A1)
      MOVEP.W   D0,481(A1)
      MOVEP.W   D0,641(A1)
      MOVEP.W   D0,801(A1)
      MOVEP.W   D0,961(A1)
      MOVEP.W   D0,1121(A1) 
      DBF       D1,LOOPA
      RTS 
EFF_MOY_S:LEA       BUFF_ET1,A0
      TST.W     TEST 
      BPL.S     .next 
      LEA       60(A0),A0 
.next:MOVEQ     #9,D1 
      MOVEQ     #0,D0 
LOOPA0:MOVE.L    (A0)+,D2
      BMI.S     SPRITE4 
      BNE.S     SPRITE11 
      RTS 
SPRITE11:MOVEA.L   D2,A1 
      MOVE.L    D0,(A1) 
      MOVE.L    D0,160(A1)
      MOVE.L    D0,320(A1)
      MOVE.L    D0,480(A1)
      MOVE.L    D0,640(A1)
      DBF       D1,LOOPA0
      RTS 
SPRITE4:NEG.L     D2
      MOVEA.L   D2,A1 
      TST.W     (A0)+ 
      BMI.S     SPRITE5 
      BGT.S     SPRITE6 
      MOVEP.W   D0,1(A1)
      MOVEP.W   D0,8(A1)
      MOVEP.W   D0,161(A1)
      MOVEP.W   D0,168(A1)
      MOVEP.W   D0,321(A1)
      MOVEP.W   D0,328(A1)
      MOVEP.W   D0,481(A1)
      MOVEP.W   D0,488(A1)
      MOVEP.W   D0,641(A1)
      MOVEP.W   D0,648(A1)
      DBF       D1,LOOPA0
      RTS 
SPRITE5:MOVEP.W   D0,0(A1)
      MOVEP.W   D0,160(A1)
      MOVEP.W   D0,320(A1)
      MOVEP.W   D0,480(A1)
      MOVEP.W   D0,640(A1)
      DBF       D1,LOOPA0
      RTS 
SPRITE6:MOVEP.W   D0,1(A1)
      MOVEP.W   D0,161(A1)
      MOVEP.W   D0,321(A1)
      MOVEP.W   D0,481(A1)
      MOVEP.W   D0,641(A1)
      DBF       D1,LOOPA0
      RTS 
EFF_GRO_S:LEA       BUFF_ET2,A0
      TST.W     TEST 
      BPL.S     .next 
      LEA       60(A0),A0 
.next:MOVEQ     #9,D1 
      MOVEQ     #0,D0 
LOOPA1:MOVE.L    (A0)+,D2
      BMI.S     SPRITE8 
      BNE.S     SPRITE7 
      RTS 
SPRITE7:MOVEA.L   D2,A1 
      MOVE.L    D0,(A1) 
      MOVE.L    D0,160(A1)
      DBF       D1,LOOPA1
      RTS 
SPRITE8:NEG.L     D2
      MOVEA.L   D2,A1 
      TST.W     (A0)+ 
      BMI.S     SPRITE9 
      BGT.S     SPRITE10 
      MOVEP.W   D0,1(A1)
      MOVEP.W   D0,8(A1)
      MOVEP.W   D0,161(A1)
      MOVEP.W   D0,168(A1)
      DBF       D1,LOOPA1
      RTS 
SPRITE9:MOVEP.W   D0,0(A1)
      MOVEP.W   D0,160(A1)
      DBF       D1,LOOPA1
      RTS 
SPRITE10:MOVEP.W   D0,1(A1)
      MOVEP.W   D0,161(A1)
      DBF       D1,LOOPA1
      RTS 

********************************************
*Fades all colours to black (ST FM only)   *
*ENTRY Colour palette holds current colours*
*      Supervisor mode enabled             *
*EXIT  Colour palette set to all black     *
********************************************
fadeoff:
	move.w	#8-1,d0	Maximum of 8 stages
.loop1 	move.w	#16-1,d1	16 colours!
	move.l	#$ffff8240,a0	offset of palette
.loop2	move.w	(a0),d2
	andi.w	#$777,d2	Eliminate garbage
	move.w	d2,d3
	andi.w	#$F,d2	d2 contains B value
	lsr.w	#4,d3
	move.w	d3,d4
	andi.w	#$F,d3	d3 contains G value
	lsr.w	#4,d4
	andi.w	#$F,d4	d4 contains R value
	tst.w	d2
	beq.s	.end1	B already zero
	subq.w	#1,d2
.end1	tst.w	d3
	beq.s	.end2	G already zero
	subq.w	#1,d3
.end2	tst.w	d4
	beq.s	.end3	R already zero
	subq.w	#1,d4
.end3	lsl.w	#8,d4
	lsl.w	#4,d3
	or.w	d4,d2
	or.w	d3,d2	D2 now contains RGB value
	move.w	d2,(a0)+
	dbra	d1,.loop2	Next colour
 rept 2
  bsr     Wait_vbl
 endr
	dbra	d0,.loop1	Next stage
	rts

******************************************
*                                        *
* Very! fast lz77 decompression routine  *
* 68000 version                          *
*                                        *
******************************************
 include "LZ77_130.ASM"

******************************************************************
	SECTION	DATA
******************************************************************

* < Full data here >
********* ETOILES ************************************>>>
DATA_ET0:		dc.l	DATA_ET1
DATA_ET1:
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$FF00
DATA_ET2:		dc.l	DATA_ET13
DATA_ET3:		dc.l	DATA_ET13
	dc.l	DATA_ET14
	dc.l	DATA_ET12
	dc.l	DATA_ET11
	dc.l	DATA_ET7
	dc.l	DATA_ET8
	dc.l	DATA_ET9
	dc.l	DATA_ET10
	dc.l	DATA_ET5
	dc.l	DATA_ET6
	dc.l	DATA_ET4
DATA_ET4:
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0063
DATA_ET5:
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0063
DATA_ET6:
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0063
DATA_ET7:
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0063
DATA_ET8:
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0063
DATA_ET9:
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0063
DATA_ET10:
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0063
DATA_ET11:
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0063
DATA_ET12:
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0063
DATA_ET13:
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0063
DATA_ET14:
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0004,$0003,$0002,$0001
	dc	$0000,$0000,$0000,$0000
	dc	$0063
TEST:		dc	$0001
DATA_ET15:
	dc	$3C00,$0000,$1E00,$6000
	dc	$6F00,$F000,$6F00,$F000
	dc	$9D00,$6200,$FD00,$0600
	dc	$7200,$0C00,$3C00,$0000
DATA_ET16:
	dc	$3C00,$7E00,$FF00,$FF00
	dc	$FF00,$FF00,$7E00,$3C00
DATA_ET17:
	dc	$3000,$4000,$5800,$E000
	dc	$B000,$4800,$E800,$1000
	dc	$7000,$0000
DATA_ET18:
	dc	$7000,$F800,$F800,$F800
	dc	$7000
DATA_ET19:	dc	$4000,$8000,$C000,$0000
DATA_ET20:	dc	$C000,$C000
DATA_ET21:	dc	$8000
DATA_ET22:	dc	$0000
DATA_ET23:	dc	$0000
DATA_ET24:	dc	$0000
DATA_ET25:	dc	$0000
DATA_ET26:	dc	$0000
DATA_ET27:	dc	$0000
DATA_ET28:	dc	$0000
DATA_ET29:	dc	$0000
DATA_ET30: * GROS
	dc	$0062,$3660,$00B6,$3200
	dc	$00A5,$0A00,$007A,$26C0
	dc	$0023,$1F40,$0122,$0C80
	dc	$00F5,$2BC0,$0050,$0FA0
	dc	$00D7,$1860,$012C,$3980
DATA_ET31: * MOYEN
	dc	$002D,$0320,$000A,$12C0
	dc	$00C8,$1F40,$0078,$38E0
	dc	$012C,$2BC0,$00A0,$0FA0
	dc	$0037,$2580,$00FF,$0960
	dc	$00D7,$3200,$0064,$1C20
DATA_ET32: * PETIT
	dc	$012A,$2620,$0046,$1900
	dc	$0023,$3840,$0116,$06E0
	dc	$0064,$3200,$00B4,$2BC0
	dc	$00A0,$0C80,$0078,$2080
	dc	$00FA,$35C0,$00E6,$1EA0
DATA_ET33: * MINI
	dc	$0064,$3200,$00B4,$2BC0 
	dc	$00A0,$0C80,$0078,$2080
	dc	$0028,$2580,$0118,$12C0
	dc	$00E6,$3520,$0046,$0F00
	dc	$00D2,$1EA0

********* ETOILES ************************************<<<

********* BAR MENU ***********************************>>>

SENS_BARRE:	DC.W      $0
HBL_POS_1:	DC.W      $0
HBL_POS_2:	DC.W      $0
POSITION_BARRE:	DC.W	      $0
BAR_TEMPO:	DC.W      $0

********* BAR MENU ***********************************<<<

********* BIG SCROLLING ******************************>>>
SCROLL_CPT:DC.W      $0
PTR_SCROLLD:DC.L      SCROLLD 
SCROLLD:DC.L      SCROLL1 
	DC.L      SCROLL1 
	DC.L      SCROLL2 
	DC.L      SCROLL2 
	DC.L      SCROLL3 
	DC.L      SCROLL3 
	DC.L      SCROLL4 
	DC.L      SCROLL4 
	DC.L      SCROLL5 
	DC.L      SCROLL5 
	DC.L      $FFFFFFFF 
PTR1_TXTSCROL:DC.L      TXT_SCROLL 
PTR2_TXTSCROL:DC.L      TXT_SCROLL 
TXT_SCROLL:
* ABCDEFGHIJKLMNOPQRSTUVWXYZ ()!,.$27
	dc.b	'        '
	dc.b	'HI EVERYONE! THIS IS ATOMUS ON THE KEYBOARD AND I SAY WITH THE TEAM A MEGA EXTRA HAPPY NEW YEAR MMXII!!!         '
	dc.b	'TO BEGIN THIS NEW YEAR, NOEXTRA IS PROUD TO PRESENT A NEW VOLUME OF THE EXTRA COMPILATION DISK.'
	dc.b	'IT',$27,'S COMPOSED OF UNSEENS SCREENS FROM VARIOUS ATARI ST CREW.............. '
	dc.b	'A LOST SCREEN FROM NEXT, AN INTRO FROM THE SINGLE DISKZINE OF B.I.S., ONE OF INTROS FROM AVENGERS, HEADACHE SCREEN FROM OVR EXPECTED FOR THE INNER CIRCLE DEMO '
	dc.b	'AND PRESENTED IN THE MAGAZINE ST MAG FOR THE FIRST TIME, FAMOUS HIDDEN UNSEEN SCREEN FROM INVISIBLES (WHO CARES!), '
	dc.b	'LASTEST INTRO CODED IN GFA BASIC FROM ZORROII FOR THE MJJPARTYIII, SINGLE AND UNIQUE SCREEN FROM ANDREAS WAHLIN AKA PERIHELION AKA WARRIOR MUNK, '
	dc.b	'FIRST RELEASE OF THE NEW GENERATION CREW, A RARETY WITH ST APOCALYPSE INTRO AND THE TWIST SCROLLER RETURNS FROM GRIFF. '
	dc.b	'        '
	dc.b	'THANKS MARCER, MAARTAU, ZORROII AND BRUME FOR THEIR COLLABORATIONS FOR THIS MEGA COMPILATION! '
	dc.b	'        '
	dc.b	'ANOTHER RELEASE SOON : EXTRA VOLUME 3 SPECIAL SECTOR ONE AND THE HEAVY KILLER ASSOCIATION! '
	dc.b	'        '
	dc.b	'LAST IMPORTANT MESSAGE, ALL MEMBERS OF NOEXTRA WOULD LIKE TO WELCOME A NEW MEMBER : HYLST!!!'
	dc.b	'        '
	dc.b	'INFORMATIONS ABOUT THE MENU : TO CHOOSE AN INTRO, USE KEYBOARD WITH ARROW KEYS TO SELECT AND PRESS SPACEBAR TO LOAD AND SEE. '
	dc.b	'TO QUIT AND RETURN TO THE DESKTOP : PRESS ESCAPE KEY. '
	dc.b	'        '
	dc.b	'THIS IS THE ALL OF FAME OF THE ATARI ST CREWS......... '
	DC.B  'O O SEVEN,'
	DC.B  'NINETY EIGHTY FOUR,'
	DC.B  'IST CREW,'
	DC.B  'FOURTY TWO-CREW,'
	DC.B  'FOURTY NINE',$27,'ERS,'
	DC.B  'ABCS EIGHTY FIVE,'
	DC.B  'ABSCENCE,'
	DC.B  'ABSTRACT,'
	DC.B  'ACCS,'
	DC.B  'ADMIRABLES,'
	DC.B  'ADRENALIN UK,'
	DC.B  'ADRENALINE,'
	DC.B  'ADRENALYN,'
	DC.B  'AEC,'
	DC.B  'AENIGMATICA,'
	DC.B  'AFTER THE BATTLE,'
	DC.B  'AGGRESSION,'
	DC.B  'AIDS,'
	DC.B  'ALBEDO O.IZ,'
	DC.B  'ALEXANDER THE GREAT,'
	DC.B  'ALIEN CRACKING FORMATION,'
	DC.B  'ALIEN NATION,'
	DC.B  'ALIENS (THE),'
	DC.B  'ALLIANCE (THE GERMAN),'
	DC.B  'ALLIANCE (THE),'
	DC.B  'ALPHA FLIGHT,'
	DC.B  'ALYSSA,'
	DC.B  'AMNESIC CACTUS,'
	DC.B  'ANARCHY,'
	DC.B  'ANATOMICA,'
	DC.B  'ANCIENT CELTS,'
	DC.B  'ANGEL OF DARKNESS,'
	DC.B  'ANIMAL MINE,'
	DC.B  'ANIMI DUX,'
	DC.B  'ANTI AMIGA CREW,'
	DC.B  'ANTI ASSEMBLEUR TEAM,'
	DC.B  'ANTIC,'
	DC.B  'ARAKIS,'
	DC.B  'ARGANOID,'
	DC.B  'ARGONAUTS,'
	DC.B  'ARKHAM,'
	DC.B  'ARSENIC,'
	DC.B  'ART MACHINE (THE),'
	DC.B  'ART OF CODE,'
	DC.B  'ARTIS MAGIA,'
	DC.B  'ASTRA,'
	DC.B  'ASYLUM (THE),'
	DC.B  'ATARI BOYS,'
	DC.B  'ATARIFORCE,'
	DC.B  'A-TEAM,'
	DC.B  'ATLANTIDE,'
	DC.B  'ATLANTIS,'
	DC.B  'ATROCITY,'
	DC.B  'AURA,'
	DC.B  'AUTOMATION,'
	DC.B  'AVENA,'
	DC.B  'AVENDESORA,'
	DC.B  'AVENGERS (THE),'
	DC.B  'AWESOME,'
	DC.B  'AXIOM,'
	DC.B  'AXXIS,'
	DC.B  'B.O.A.,'
	DC.B  'B.O.S.S.,'
	DC.B  'BAC,'
	DC.B  'BAD BOYS BELGIUM,'
	DC.B  'BAD BREW CREW,'
	DC.B  'BAD INFLUENCE,'
	DC.B  'BAD STARS,'
	DC.B  'BALD EAGLE (THE),'
	DC.B  'BARBARIANS (THE),'
	DC.B  'BASSMENT (THE),'
	DC.B  'BASTARDS INTERNATIONAL,'
	DC.B  'BAT BOYS (THE),'
	DC.B  'BERLIN CHAOTS (THE),'
	DC.B  'BIG BOSSMAN (THE),'
	DC.B  'BIG FOUR (THE),'
	DC.B  'BINARIS,'
	DC.B  'BITS CLUB (THE),'
	DC.B  'BITSTOPPERS (THE),'
	DC.B  'BLABLA,'
	DC.B  'BLACK BOXES (THE),'
	DC.B  'BLACK BYTE,'
	DC.B  'BLACK CATS (THE),'
	DC.B  'BLACK LOTUS (THE),'
	DC.B  'BLACK MONOLITH TEAM,'
	DC.B  'BLACK PANTHERS,'
	DC.B  'BLACK WIZARDS (THE),'
	DC.B  'BLADE RUNNERS,'
	DC.B  'BLANK,'
	DC.B  'BLIND IO,'
	DC.B  'BLT,'
	DC.B  'BLUE ADEPT,'
	DC.B  'BLUE BOYS,'
	DC.B  'BLUE HARVEST,'
	DC.B  'BLUE SOFTWARE (THE),'
	DC.B  'BLUE SYSTEM,'
	DC.B  'BLUES BROTHERS,'
	DC.B  'BO!,'
	DC.B  'BODGE UP SOFTWARE TEAM,'
	DC.B  'BOG BROTHERS,'
	DC.B  'BRAIN,'
	DC.B  'BRAIN BUSTERS (THE),'
	DC.B  'BRAIN WASHERS CO (THE),'
	DC.B  'BRAINIACS,'
	DC.B  'BRAINLESS INSTITUTE,'
	DC.B  'BRAINPOWER,'
	DC.B  'BUGS IN SPACE,'
	DC.B  'BUSHWACKERS,'
	DC.B  'BXC,'
	DC.B  'C.I.R.A. HACKERS,'
	DC.B  'CAREBEARS (THE),'
	DC.B  'CARTOONS,'
	DC.B  'CAT DEVELOPMENT,'
	DC.B  'CELL,'
	DC.B  'CEREBRAL VORTEX,'
	DC.B  'CHANNEL THIRTY EIGHT,'
	DC.B  'CHAOS,'
	DC.B  'CHAOS ENGINE (THE),'
	DC.B  'CHAOTIC MOTION,'
	DC.B  'CHECKPOINT,'
	DC.B  'CHESIRE CAT (THE),'
	DC.B  'CHIMERIC DESIRES,'
	DC.B  'CHRONICLE,'
	DC.B  'CIA,'
	DC.B  'CLAN,'
	DC.B  'CLIMATICS,'
	DC.B  'CLOCKWORK ORANGE,'
	DC.B  'CLONE,'
	DC.B  'COBRA TEAM,'
	DC.B  'COCKNEY REJECTS,'
	DC.B  'CODERS (THE),'
	DC.B  'COMPACT,'
	DC.B  'CONCEPTORS (THE),'
	DC.B  'CONDEMNED,'
	DC.B  'CONFUSIONS,'
	DC.B  'CONSPIRACY,'
	DC.B  'CONSTELLATIONS,'
	DC.B  'CONSTRUCT CREW,'
	DC.B  'COOL CREW,'
	DC.B  'COOL GIRLS,'
	DC.B  'COPY SERVICE STUTTGART,'
	DC.B  'COR BLIMEY NOT ARF,'
	DC.B  'CORPORATION (THE),'
	DC.B  'CRACK CONNEXION (THE),'
	DC.B  'CRACKING SERVICE HAVRAIS,'
	DC.B  'CRACKODILES (THE),'
	DC.B  'CRAZY BOY,'
	DC.B  'CREAM,'
	DC.B  'CRIME,'
	DC.B  'CRIMINAL IN DISGUISE,'
	DC.B  'CRUSADERS (THE),'
	DC.B  'CRYSTALIC,'
	DC.B  'CYBERNETICS,'
	DC.B  'CYBORG,'
	DC.B  'CYCLADES,'
	DC.B  'CYCLEMASTERS (THE),'
	DC.B  'CYCLONE,'
	DC.B  'CYNIX,'
	DC.B  'DA BOOSTERS,'
	DC.B  'DARK ANGELS,'
	DC.B  'D-BUG,'
	DC.B  'DCS,'
	DC.B  'DEAD HACKERS SOCIETY,'
	DC.B  'DEEP THOUGHT',$27,'S,'
	DC.B  'DEFCON FOUR,'
	DC.B  'DEFLECT,'
	DC.B  'DELIGHT,'
	DC.B  'DELIVERANCE (THE),'
	DC.B  'DELTA FORCE,'
	DC.B  'DELTA PIRATS,'
	DC.B  'DEPRESSION,'
	DC.B  'DETONATORS,'
	DC.B  'DEVIANT CORPORATION (THE),'
	DC.B  'DEVIANT DESIGNERS,'
	DC.B  'DEWEY,'
	DC.B  'DIAMOND DESIGN,'
	DC.B  'DIGET,'
	DC.B  'DIGI TALLIS,'
	DC.B  'DIGITAL CHAOS,'
	DC.B  'DIGITAL CREW,'
	DC.B  'DIGITAL VISION,'
	DC.B  'DIGITAL WIZARDS,'
	DC.B  'DIGITECH,'
	DC.B  'DILDO FATWA,'
	DC.B  'DIMENSION ZERO,'
	DC.B  'DIRTY TRICKS BRIGADE,'
	DC.B  'DISASTER AREA,'
	DC.B  'DISK BUSTERS ASSOCIATION,'
	DC.B  'DISKMAP CREW,'
	DC.B  'DISNEY WORLD,'
	DC.B  'DIZZIDENCE,'
	DC.B  'DMA,'
	DC.B  'DNT CREW,'
	DC.B  'DOUAI MAIN ASSOCIATION,'
	DC.B  'DOUBLE DUTCH CREW,'
	DC.B  'DOUBLE TROUBLE,'
	DC.B  'DREAM WEAVERS,'
	DC.B  'DUNE,'
	DC.B  'DYNAMIC DUO,'
	DC.B  'DYNAMITE DYNASTIE,'
	DC.B  'EAGLES (THE),'
	DC.B  'ECLIPSE,'
	DC.B  'ECLIPSIS,'
	DC.B  'EDGE OF SANITY,'
	DC.B  'EFFECT,'
	DC.B  'EGO TRIPPERS,'
	DC.B  'EGOMANIACS,'
	DC.B  'ELECTRA,'
	DC.B  'ELECTRICITY,'
	DC.B  'ELECTRONIC,'
	DC.B  'ELECTRONIC IMAGE,'
	DC.B  'ELITE,'
	DC.B  'ELLIPSE,'
	DC.B  'EMPIRE (THE),'
	DC.B  'ENIGMA,'
	DC.B  'EPSILON,'
	DC.B  'EQUINOX,'
	DC.B  'ESCAPE,'
	DC.B  'ETERNAL,'
	DC.B  'ETERNITY,'
	DC.B  'EUPHORIA,'
	DC.B  'EUROPEAN SWAPPING CREW,'
	DC.B  'EUROSWAP,'
	DC.B  'EVIL FORCE,'
	DC.B  'EVOLUTION,'
	DC.B  'EXA,'
	DC.B  'EXCELLENCE IN ART,'
	DC.B  'EXCEPTIONS (THE),'
	DC.B  'EXPLORER,'
	DC.B  'EXTACY,'
	DC.B  'EXTRACT,'
	DC.B  'EXTREAM,'
	DC.B  'EXTREME,'
	DC.B  'EXTREMLY KRIMINAL ORGANISATION,'
	DC.B  'FACTORY,'
	DC.B  'FALCON USERS NETHERLANDS,'
	DC.B  'FALLEN ANGELS (THE),'
	DC.B  'FANATICS,'
	DC.B  'FANATICS (THE),'
	DC.B  'FANTASY,'
	DC.B  'FANTASY CRACKERS (THE),'
	DC.B  'FASHION,'
	DC.B  'FEDERATION AGAINST LAMER AND LOSER,'
	DC.B  'FEDERATION OF FREE TRADERS,'
	DC.B  'FINAL SPACECODERS,'
	DC.B  'FINGERBOBS,'
	DC.B  'FIRE CRACKERS,'
	DC.B  'FIREHAWKS (THE),'
	DC.B  'FIRESOFT,'
	DC.B  'FIRM (THE),'
	DC.B  'FIRSTE,'
	DC.B  'FISK KOMPANIET,'
	DC.B  'FISSION,'
	DC.B  'FIT,'
	DC.B  'FLAMES OF FINLAND,'
	DC.B  'FLASH,'
	DC.B  'FLAT LINERS,'
	DC.B  'FLEXIBLE FRONT,'
	DC.B  'FLEXICRON,'
	DC.B  'FORCE (THE),'
	DC.B  'FORCE SIXTY NINE,'
	DC.B  'FOREST FOLK,'
	DC.B  'FORMATION CREW (THE),'
	DC.B  'FOUNDATION TWO,'
	DC.B  'FOXX,'
	DC.B  'FRAGGLE',$27,'S (THE),'
	DC.B  'FRONT DE LIBERATION ATARISTE,'
	DC.B  'FRONTLINE,'
	DC.B  'FULL METAL COMPUTERS CONNEXION,'
	DC.B  'FUN,'
	DC.B  'FUN INDUSTRIES,'
	DC.B  'FUNVISION,'
	DC.B  'FUTURE MINDS,'
	DC.B  'FUZION,'
	DC.B  'GALTAN SIX,'
	DC.B  'GAME OVER,'
	DC.B  'GAMEMASTERS (THE),'
	DC.B  'GANJA KID,'
	DC.B  'GARLIC EATERS (THE),'
	DC.B  'GENESIS,'
	DC.B  'GENESIS INC (THE),'
	DC.B  'GERMS (THE),'
	DC.B  'G-FORCE,'
	DC.B  'GHOST,'
	DC.B  'GHOST GENIUS (THE),'
	DC.B  'GIANTS (THE),'
	DC.B  'GIGABYTE CREW (THE),'
	DC.B  'GOLDEN DAWN,'
	DC.B  'GRAVATICS,'
	DC.B  'GREUH!,'
	DC.B  'GUARDIANS OF LOGIK,'
	DC.B  'GUDUL CORPORATION,'
	DC.B  'GUILD (THE),'
	DC.B  'H.A.C.,'
	DC.B  'HCC,'
	DC.B  'HEAVY KILLER (THE),'
	DC.B  'HEMOROIDS,'
	DC.B  'HIDDEN STRENGHT,'
	DC.B  'HIGH VOLTAGE,'
	DC.B  'HIGHLANDER GUILD (THE),'
	DC.B  'HIJACKERS (THE),'
	DC.B  'HITCHICKER (THE),'
	DC.B  'HOFA,'
	DC.B  'HOL,'
	DC.B  'HOLOCAUST,'
	DC.B  'HOPELESS LAMERS,'
	DC.B  'HORIZON,'
	DC.B  'HOTLINE,'
	DC.B  'HOWDY,'
	DC.B  'HYDROXID,'
	DC.B  'HYPNOSIS,'
	DC.B  'HYSTERIA,'
	DC.B  'I.C.E.,'
	DC.B  'ICARUS,'
	DC.B  'ICARUZ,'
	DC.B  'ICEBIRD,'
	DC.B  'IDEMLINE,'
	DC.B  'ILLEGAL EXCEPTION,'
	DC.B  'IMA,'
	DC.B  'IMAGINA,'
	DC.B  'IMMORTAL IMAGINATION CREW,'
	DC.B  'IMPACT,'
	DC.B  'IMPULSE,'
	DC.B  'INNER CIRCLE,'
	DC.B  'INSANITY,'
	DC.B  'INSOMNIA,'
	DC.B  'INTER,'
	DC.B  'INTER DEVELOPMENTS,'
	DC.B  'INTERGALACTIC,'
	DC.B  'INTERNATIONAL CRACKING SERVICE,'
	DC.B  'INTRUDERS (THE),'
	DC.B  'INVISIBLES (THE),'
	DC.B  'INVIZIBLES OF FLEXICRON (THE),'
	DC.B  'IRATA,'
	DC.B  'IRON TEAM,'
	DC.B  'JMP,'
	DC.B  'JSD,'
	DC.B  'JUSTICE DEPARTMENT,'
	DC.B  'KAT PROJECTS,'
	DC.B  'KEMPSOFT,'
	DC.B  'KICK IT IN SOFTWARE,'
	DC.B  'KIDS GHOSTS BROTHERS (THE),'
	DC.B  'KNIGHT TEAM (THE),'
	DC.B  'KOPA,'
	DC.B  'KRS,'
	DC.B  'KRUZ,'
	DC.B  'KUA,'
	DC.B  'LAMERS FOUNDATION (THE),'
	DC.B  'LAZER,'
	DC.B  'LEGACY,'
	DC.B  'LEGEND,'
	DC.B  'LEGEND OF DOOM,'
	DC.B  'LEGION,'
	DC.B  'LEMMINGS,'
	DC.B  'LENGAME,'
	DC.B  'LES NULS,'
	DC.B  'LEVEL SIXTEEN,'
	DC.B  'LIGHT,'
	DC.B  'LIGHT TEAM (THE),'
	DC.B  'LINEOUT,'
	DC.B  'LIVE,'
	DC.B  'LONEWOLF,'
	DC.B  'LORD HACKBEAR,'
	DC.B  'LOST BOYS (THE),'
	DC.B  'LOUD!,'
	DC.B  'LOWER LEVEL,'
	DC.B  'LOWLIFE INC.,'
	DC.B  'LSD,'
	DC.B  'LUZAK TEAM,'
	DC.B  'LYNX,'
	DC.B  'M.D.K.,'
	DC.B  'MAD,'
	DC.B  'MAD DOGS (THE),'
	DC.B  'MAD VISION,'
	DC.B  'MANGA MANIACS,'
	DC.B  'MANTRONIX,'
	DC.B  'MARVELLOUS VB (THE),'
	DC.B  'MARVELS CORPORATION (THE),'
	DC.B  'MASTER CRACKING SERVICE,'
	DC.B  'MASTERS (THE),'
	DC.B  'MASTERS OF CAVALCADE,'
	DC.B  'MEAN MACHINES UNITED,'
	DC.B  'MEDWAY BOYS (THE),'
	DC.B  'MEGA FOUR (THE),'
	DC.B  'MEGABUSTERS (THE),'
	DC.B  'MEGACREW,'
	DC.B  'MEGALAMERS (THE),'
	DC.B  'MEGAWOT AND JAILHOUSE,'
	DC.B  'MENACING CRACKING ALLIANCE (THE),'
	DC.B  'MFC NEWS,'
	DC.B  'MIND-DESIGN,'
	DC.B  'MISFITS,'
	DC.B  'MISFITS SOFTWARE (THE),'
	DC.B  'MYSTIC BYTES,'
	DC.B  'MJJ PROD,'
	DC.B  'MLP,'
	DC.B  'MONARCH,'
	DC.B  'MR CHIPS CRACKING CORPORATED,'
	DC.B  'MST,'
	DC.B  'MUGWUMPS,'
	DC.B  'MYSTERONS,'
	DC.B  'MYSTIC,'
	DC.B  'MYSTIC BYTES,'
	DC.B  'NAOS,'
	DC.B  'NASTY BOYS (THE),'
	DC.B  'NATO,'
	DC.B  'NATURE ATARI DIVISION,'
	DC.B  'NAUGHTY BYTES (THE),'
	DC.B  'NEON LIGHTS,'
	DC.B  'NERVE CENTER (THE),'
	DC.B  'NETWORK (THE),'
	DC.B  'NEW BEAT DEVELOPMENTS,'
	DC.B  'NEW CORE,'
	DC.B  'NEW GENERATION (THE),'
	DC.B  'NEW ORDER,'
	DC.B  'NEW PIRATES,'
	DC.B  'NEW POWER GENERATION,'
	DC.B  'NEW SYSTEM,'
	DC.B  'NEW TREND,'
	DC.B  'NEWLINE,'
	DC.B  'NEXT,'
	DC.B  'NEXT GENERATION,'
	DC.B  'NGC,'
	DC.B  'NO CREW,'
	DC.B  'NO LIMIT CODING,'
	DC.B  'NO TEAM,'
	DC.B  'NOEXTRA,'
	DC.B  'NOKTURNAL,'
	DC.B  'NORDIK CODERS,'
	DC.B  'NORTHSIDE,'
	DC.B  'NOTEC,'
	DC.B  'NOTHING PERSONAL,'
	DC.B  'NOW FIVE,'
	DC.B  'NUN!,'
	DC.B  'O.U.C.H.,'
	DC.B  'ODYSSEY,'
	DC.B  'OFF BASE,'
	DC.B  'OFFBEAT,'
	DC.B  'OMEGA,'
	DC.B  'OMNICRON,'
	DC.B  'OPPOSITION (THE),'
	DC.B  'ORION,'
	DC.B  'OUT OF ORDER,'
	DC.B  'OUTLAWS,'
	DC.B  'OVERLANDERS (THE),'
	DC.B  'OVERLORDS,'
	DC.B  'OXYGENE,'
	DC.B  'OXYTHAN,'
	DC.B  'OZONE,'
	DC.B  'PAPY BOOM ,'
	DC.B  'PARADISE,'
	DC.B  'PARADOX,'
	DC.B  'PARANOIA,'
	DC.B  'PASSION,'
	DC.B  'PASSWORDS,'
	DC.B  'PAULO SIMOES AND CARLOS DIAS,'
	DC.B  'PENDRAGONS (THE),'
	DC.B  'PERSISTENCE OF VISION,'
	DC.B  'PHALANX,'
	DC.B  'PHENIX,'
	DC.B  'PHOBYX,'
	DC.B  'PHYSICS,'
	DC.B  'PIXEL TWINS (THE),'
	DC.B  'POETS OF DECAY,'
	DC.B  'POLTERGEIST,'
	DC.B  'POMPEY PIRATES,'
	DC.B  'POPSY TEAM,'
	DC.B  'POSITIVITY,'
	DC.B  'PREDATORS (THE),'
	DC.B  'PRIESTS OF PLEASURE,'
	DC.B  'PRISM,'
	DC.B  'PROBYTE,'
	DC.B  'PROPHANATOR,'
	DC.B  'PROPHECY,'
	DC.B  'PSYCHO HACKING FORCE,'
	DC.B  'PSYCHONOMIX,'
	DC.B  'PUBLIC DOMAIN PACKING CREW,'
	DC.B  'PUBLIC ENEMIES (THE),'
	DC.B  'PULSE,'
	DC.B  'PULSION,'
	DC.B  'PURE ENERGY,'
	DC.B  'PYJAMA,'
	DC.B  'PYROTECHNICS,'
	DC.B  'QUARTET (THE),'
	DC.B  'QUARTEX,'
	DC.B  'QUATERMASS XPERIMENT (THE),'
	DC.B  'R.B.C.G.,'
	DC.B  'RAD RAVERS (THE),'
	DC.B  'RADIATION,'
	DC.B  'RADICAL BANDITS (THE),'
	DC.B  'RADICAL SYSTEMS,'
	DC.B  'RAGA TWINS,'
	DC.B  'RAIDERS OF THE LOST LOCK AND CO (THE),'
	DC.B  'RAM-KILLER,'
	DC.B  'RANDOM ACCESS,'
	DC.B  'RASERO TEAM,'
	DC.B  'REANIMATORS (THE),'
	DC.B  'REBELS,'
	DC.B  'REBOOT,'
	DC.B  'RED HERRINGS (THE),'
	DC.B  'REDLITE,'
	DC.B  'REFLECTION,'
	DC.B  'REGRESSION THERAPY ,'
	DC.B  'REJECT,'
	DC.B  'REMOVERS (THE),'
	DC.B  'REPLICANTS (THE),'
	DC.B  'REPROBATES (THE),'
	DC.B  'RESERVOIR FROGS,'
	DC.B  'RESERVOIR GODS,'
	DC.B  'RESPECTABLES (THE),'
	DC.B  'REVOLUTION,'
	DC.B  'RIBBON,'
	DC.B  'RIPP OF MERCHANT,'
	DC.B  'RIPPED OFF,'
	DC.B  'RISK,'
	DC.B  'ROUND TABLE (THE),'
	DC.B  'ROYAL INSTANT PUDDING,'
	DC.B  'S.C.A.,'
	DC.B  'SAFARI,'
	DC.B  'SANITY,'
	DC.B  'SATANTRONIC,'
	DC.B  'SCOOBY DOO CREW,'
	DC.B  'SCOTTISH CRACKING CREW (THE),'
	DC.B  'SCSI,'
	DC.B  'SCUM OF THE EARTH,'
	DC.B  'SECTION NINE,'
	DC.B  'SECTION ONE,'
	DC.B  'SECTION X,'
	DC.B  'SECTOR ONE,'
	DC.B  'SEDMA,'
	DC.B  'SENIOR DADS,'
	DC.B  'SENTRY,'
	DC.B  'SERENADE,'
	DC.B  'SERIAL KILLERS (THE),'
	DC.B  'SERVAL,'
	DC.B  'SEWER SOFTWARE,'
	DC.B  'SHADOWS,'
	DC.B  'SHAOLIN MASTERS,'
	DC.B  'SHARE WARES,'
	DC.B  'SHOGUN,'
	DC.B  'SIGMA,'
	DC.B  'SILVER BULLET FORCE,'
	DC.B  'SILVER GHOSTS (THE),'
	DC.B  'SILVERS,'
	DC.B  'SINISTER,'
	DC.B  'SIRIUS CYBERNETICS CORPORATION (THE),'
	DC.B  'SIXTEEN BIT CREW,'
	DC.B  'SKUNK (THE),'
	DC.B  'SLAYTANIC CULT,'
	DC.B  'SOFTRUNNER GROUP,'
	DC.B  'SOURCE (THE),'
	DC.B  'SPACE MARINES (THE),'
	DC.B  'SPECIAL FX,'
	DC.B  'SPECTRE,'
	DC.B  'SPHERICAL,'
	DC.B  'SPHINX,'
	DC.B  'SPICE BOYS,'
	DC.B  'SPIRITS,'
	DC.B  'SPIRITS OF DOOM,'
	DC.B  'SPL CREW,'
	DC.B  'SPYJACK,'
	DC.B  'ST ACTION,'
	DC.B  'ST AMIGOS,'
	DC.B  'ST APOCALYPSE,'
	DC.B  'ST CONNEXION,'
	DC.B  'ST CRACKING SERVICE,'
	DC.B  'ST FACTORY,'
	DC.B  'ST FORCE,'
	DC.B  'ST KNIGHTS,'
	DC.B  'ST NEWS,'
	DC.B  'ST SPIRIT,'
	DC.B  'ST SQUAD,'
	DC.B  'STARFIRES,'
	DC.B  'STAX,'
	DC.B  'STEELWINGS,'
	DC.B  'STEW,'
	DC.B  'STORM BROTHERS (THE),'
	DC.B  'STORMBRINGERS (THE),'
	DC.B  'STRANGER,'
	DC.B  'STRANGLERS (THE),'
	DC.B  'ST-REBELS ,'
	DC.B  'SUB HUMANS IN TURKEY,'
	DC.B  'SUBLIME,'
	DC.B  'SUN GODESSES,'
	DC.B  'SUPER BIDON',$27,'S CRACK GANG,'
	DC.B  'SUPERIOR,'
	DC.B  'SUPREMACY,'
	DC.B  'SWEDISH CRACKING SERVICE INTERNATIONAL,'
	DC.B  'SYNC,'
	DC.B  'SYNCHRON OF LEGACY,'
	DC.B  'SYNCRO SYSTEMS,'
	DC.B  'SYNDICATE (THE),'
	DC.B  'SYNERGY,'
	DC.B  'SYNTAX,'
	DC.B  'T.O.I.,'
	DC.B  'T.O.Y.S.,'
	DC.B  'TBL,'
	DC.B  'TBT,'
	DC.B  'TDA,'
	DC.B  'TEARDROP,'
	DC.B  'TEC,'
	DC.B  'TECHNO GANGSTERS (THE),'
	DC.B  'TEENAGE,'
	DC.B  'TEETH SHAKERS (THE),'
	DC.B  'TEKNIX,'
	DC.B  'TEQUE,'
	DC.B  'TERMINATORS,'
	DC.B  'TERRABYTE CREW (THE),'
	DC.B  'TETARD ZAUFTWARE PRODUCTIONS INC. (THE),'
	DC.B  'THERAPY,'
	DC.B  'THUNDER FORCE,'
	DC.B  'TIME WARP,'
	DC.B  'TIMELORDS,'
	DC.B  'TITANIUM,'
	DC.B  'TKU,'
	DC.B  'TNT-CREW,'
	DC.B  'TOONS,'
	DC.B  'TOP NOTCH,'
	DC.B  'TORMENT,'
	DC.B  'TOS CREW,'
	DC.B  'TOTAL VISION INCORPORATED,'
	DC.B  'TOUR DE FORCE,'
	DC.B  'TOYS,'
	DC.B  'TPN,'
	DC.B  'TRACK FOURTY ONE,'
	DC.B  'TRASH SECTION,'
	DC.B  'TRIO,'
	DC.B  'TRIPPLE H,'
	DC.B  'TRISOMIC DEVELOPMENTS,'
	DC.B  'TRISTAR AND RED SECTOR INCORPORATED,'
	DC.B  'TRITON,'
	DC.B  'TRONIC,'
	DC.B  'TRP,'
	DC.B  'TUMULT,'
	DC.B  'TWINS (THE),'
	DC.B  'TYPHOON,'
	DC.B  'ULTIMATE (THE),'
	DC.B  'ULTRA CREW (THE),'
	DC.B  'UNDEAD,'
	DC.B  'UNDERFORCE (THE),'
	DC.B  'UNDERGROUND,'
	DC.B  'UNION (THE),'
	DC.B  'UNIT SEVENTEEN,'
	DC.B  'UNITED FORCES,'
	DC.B  'UNIVERSAL CODERS,'
	DC.B  'UNLIMITED MATRIX,'
	DC.B  'UN-NAMEABLES (THE),'
	DC.B  'UNSENSIBLE SOFTWARE,'
	DC.B  'UNTOUCHABLES (THE),'
	DC.B  'VECTOR,'
	DC.B  'VECTRONIX,'
	DC.B  'VEGETABLES,'
	DC.B  'VISUALIZERS,'
	DC.B  'VMAX,'
	DC.B  'VORTEX,'
	DC.B  'VOYAGERS (THE),'
	DC.B  'WAIKIKI,'
	DC.B  'WATCHMEN (THE),'
	DC.B  'WEST OF EUROPE,'
	DC.B  'WHITE STATUS,'
	DC.B  'WILD BOYS (THE),'
	DC.B  'WILDFIRE,'
	DC.B  'WIZARDS (THE),'
	DC.B  'WIZZFROG,'
	DC.B  'WORLD',$27,'S PICTURE COLLECTION (THE),'
	DC.B  'XENEX,'
	DC.B  'X-FACTOR,'
	DC.B  'X-STATIC,'
	DC.B  'XTC,'
	DC.B  'X-TREAM,'
	DC.B  'X-TROLL,'
	DC.B  'XXX INTERNATIONAL,'
	DC.B  'YAK,'
	DC.B  'YESCREW,'
	DC.B  'YM ROCKERZ,'
	DC.B  'YPSILON,'
	DC.B  'ZEAL,'
	DC.B  'ZODIAC AND '
	DC.B  'ZUUL.'
	dc.b	'        '
	dc.b	'        '
	dc.b	'LIST FINALIZED WITH NOVA/EQX.                     HUM... HOW MANY CREWS ARE IN THIS BIG LIST ? '
	dc.b	'        '
	dc.b	'        '
	dc.b	'IT',$27,'S TIME TO WRAP......            '
	dc.w $FF00
  EVEN
  
SWAPM0:DC.L      BUFFERM 
SWAPM1:DC.L      BUFFERM 
SWAPM2:DC.L      BUFFERM 
SWAPM3:DC.L      BUFFERM 
SWAPM4:DC.L      BUFFERM 
 include	"BIGFONT.S"
	even
PLACE:DC.L      FNT00 
	DC.L      BUFFERM 
	DC.L      BUFFERM 
	DC.L      BUFFERM 
	DC.L      BUFFERM 
	DC.L      BUFFERM 
	DC.L      FNT01 
	DC.L      FNT02 
	DC.L      FNT03 
	DC.L      BUFFERM 
	DC.L      BUFFERM 
	DC.L      FNT04 
	DC.L      BUFFERM 
	DC.L      FNT05 
	DC.L      BUFFERM 
	DC.L      BUFFERM 
	DC.L      BUFFERM 
	DC.L      BUFFERM 
	DC.L      BUFFERM 
	DC.L      BUFFERM 
	DC.L      BUFFERM 
	DC.L      BUFFERM 
	DC.L      BUFFERM 
	DC.L      BUFFERM 
	DC.L      BUFFERM 
	DC.L      BUFFERM 
	DC.L      BUFFERM 
	DC.L      BUFFERM 
	DC.L      BUFFERM 
	DC.L      BUFFERM 
	DC.L      BUFFERM 
	DC.L      BUFFERM 
	DC.L      FNT06 
	DC.L      FNT07 
	DC.L      FNT08 
	DC.L      FNT09 
	DC.L      FNT10 
	DC.L      FNT11 
	DC.L      FNT12 
	DC.L      FNT13 
	DC.L      FNT14 
	DC.L      FNT15 
	DC.L      FNT16 
	DC.L      FNT17 
	DC.L      FNT18 
	DC.L      FNT19 
	DC.L      FNT20 
	DC.L      FNT21 
	DC.L      FNT22 
	DC.L      FNT23 
	DC.L      FNT24 
	DC.L      FNT25 
	DC.L      FNT26 
	DC.L      FNT27 
	DC.L      FNT28 
	DC.L      FNT29 
	DC.L      FNT30 
	DC.L      FNT31 
BUFFERM:
	DCB.W     3200,$0
	even
********* BIG SCROLLING ******************************<<<

Palette_Extra:
	dc.w	$0202,$0A8A,$0313,$0909,$04A4,$0C3C,$054C,$0DC5
	dc.w	$0655,$0ED6,$076E,$0767,$0FE7,$0F77,$0FF7,$0FFF
LOGO_EXTRA:
	incbin	"LOGONOEX.LZ7"	;	8800
	even
VOLUME_2:
	incbin	"VOLUME2.LZ7"	;	12960
	even
* <

MUSIC:
	incbin	"DIGUIBI.LZ7"	;	11521
	even

******************************************************************
	SECTION	BSS
******************************************************************

bss_start:

* < Full data here >
********* ETOILES ************************************>>>
BUFF_ET0:DS.B      120 
BUFF_ET1:DS.B      120 
BUFF_ET2:DS.B      120 
BUFF_ET3:DS.B      36
BUFF_ET4:DS.B      1024
BUFF_ET5:DS.B      640 
BUFF_ET6:DS.B      258 
********* ETOILES ************************************<<<

Buffer_LZ7:
	ds.b	12960
* <

Vsync:	ds.w	1
Save_stack:	ds.l	1

Save_all:
	ds.b	8	* Mfp : fa03.w -> fa19.w
	ds.b	4	* Mfp : fa1b.w -> fa21.w
	ds.b	4	* Video : f8201.w -> f820d.w

Save_rest:
	ds.l	1	* Autovector (HBL)
	ds.l	1	* Autovector (VBL)
	ds.l	1	* Timer D (USART timer)
	ds.l	1	* Timer C (200hz Clock)
	ds.l	1	* Keyboard/MIDI (ACIA) 
	ds.l	1	* Timer B (HBL)
	ds.l	1	* Timer A
	ds.l	1	* Output Bip Bop
Palette:
	ds.w	16	* Palette

bss_end:

Screen_1:
	ds.b	256
	ds.b	SIZE_OF_SCREEN
Screen_2:
	ds.b	256
	ds.b	SIZE_OF_SCREEN

	SECTION	TEXT

	IFEQ	ERROR_SYS
************************************************
*                                              *
*               Error Routines                 *
*                Dbug 2/Next                   *
*                                              *
************************************************
INPUT_TRACE_ERROR:
	lea $8.w,a0                       ; Adresse de base des vecteurs (Erreur de Bus)
	lea liste_vecteurs,a1             ;
	moveq #10-1,d0                    ; On détourne toutes les erreur possibles...
.b_sauve_exceptions:
	move.l (a1)+,d1                   ; Adresse de la nouvelle routine
	move.l (a0)+,-4(a1)               ; Sauve l'ancienne
	move.l d1,-4(a0)                  ; Installe la mienne
	dbra d0,.b_sauve_exceptions
	rts

OUTPUT_TRACE_ERROR:
	lea $8.w,a0
	lea liste_vecteurs,a1
	moveq #10-1,d0
.restaure_illegal:
	move.l (a1)+,(a0)+
	dbra d0,.restaure_illegal
	rts

routine_bus:
	move.w #$070,d0
	bra.s execute_detournement
routine_adresse:
	move.w #$007,d0
	bra.s execute_detournement
routine_illegal:
	move.w #$700,d0
	bra.s execute_detournement
routine_div:
	move.w #$770,d0
	bra.s execute_detournement
routine_chk:
	move.w #$077,d0
	bra.s execute_detournement
routine_trapv:
	move.w #$777,d0
	bra.s execute_detournement
routine_viole:
	move.w #$707,d0
	bra.s execute_detournement
routine_trace:
	move.w #$333,d0
	bra.s execute_detournement
routine_line_a:
	move.w #$740,d0
	bra.s execute_detournement
routine_line_f:
	move.w #$474,d0
execute_detournement:
	move.w #$2700,sr                  ; Deux erreurs à suivre... non mais !

	move.w	#$0FF,d1
.loop:
	move.w d0,$ffff8240.w             ; Effet raster
	move.w #0,$ffff8240.w
	cmp.b #$3b,$fffffc02.w
	dbra d1,.loop

	pea end_program                   ; Put the return adress
	move.w #$2700,-(sp)               ; J'espère !!!...
	addq.l #2,2(sp)                   ; 24/6
	rte                               ; 20/5 => Total hors tempo = 78-> 80/20 nops

liste_vecteurs:
	dc.l routine_bus	Vert
	dc.l routine_adresse	Bleu
	dc.l routine_illegal	Rouge
	dc.l routine_div	Jaune
	dc.l routine_chk	Ciel
	dc.l routine_trapv	Blanc
	dc.l routine_viole	Violet
	dc.l routine_trace	Gris
	dc.l routine_line_a	Orange
	dc.l routine_line_f	Vert pale
	even
	ENDC

***************************************************************************
* Multi Atari Boot code.                                                  *
* If you have done an ST demo, use that boot to run it on these machines: *
*                                                                         *
* ST, STe, Mega-ST,TT,Falcon,CT60                                         *
*                                                                         *
* More info:                                                              *
* http://leonard.oxg.free.fr/articles/multi_atari/multi_atari.html        *
***************************************************************************

Multi_boot:
	sf $1fe.w
	move.l $5a0.w,d0
	beq noCookie
	move.l d0,a0
.loop:
	move.l (a0)+,d0
	beq noCookie
	cmp.l #'_MCH',d0
	beq.s .find
	cmp.l #'CT60',d0
	bne.s .skip

; CT60, switch off the cache
	pea (a0)

	lea bCT60(pc),a0
	st (a0)

	clr.w -(a7) ; param = 0 ( switch off all caches )
	move.w #5,-(a7) ; opcode
	move.w #160,-(a7)
	trap #14
	addq.w #6,a7
	move.l (a7)+,a0
.skip:
	addq.w #4,a0
	bra.s .loop

.find:
	move.w (a0)+,d7
	beq noCookie ; STF
	move.b d7,$1fe.w

	cmpi.w #1,d7
	bne.s .noSTE
	btst.b #4,1(a0)
	beq.s .noMegaSTE
	clr.b $ffff8e21.w ; 8Mhz MegaSTE

.noMegaSTE:
	bra noCookie

.noSTE:
; here TT or FALCON

; Always switch off the cache on these machines.
	move.b bCT60(pc),d0
	bne.s .noMovec

	moveq #0,d0
	dc.l $4e7b0002 ; movec d0,cacr ; switch off cache
.noMovec:

	cmpi.w #3,d7
	bne.s noCookie

; Here FALCON
	move.w #$59,-(a7) ;check monitortype (falcon)
	trap #14
	addq.l #2,a7
	lea rgb50(pc),a0
	subq.w #1,d0
	beq.s .setRegs
	subq.w #2,d0
	beq.s .setRegs
	lea vga50(pc),a0

.setRegs:
	move.l (a0)+,$ffff8282.w
	move.l (a0)+,$ffff8286.w
	move.l (a0)+,$ffff828a.w
	move.l (a0)+,$ffff82a2.w
	move.l (a0)+,$ffff82a6.w
	move.l (a0)+,$ffff82aa.w
	move.w (a0)+,$ffff820a.w
	move.w (a0)+,$ffff82c0.w
	move.w (a0)+,$ffff8266.w
	clr.b $ffff8260.w
	move.w (a0)+,$ffff82c2.w
	move.w (a0)+,$ffff8210.w

noCookie:

; Set res for all machines exept falcon or ct60
	cmpi.b #3,$1fe.w
	beq letsGo

	clr.w -(a7) ;set stlow (st/tt)
	moveq #-1,d0
	move.l d0,-(a7)
	move.l d0,-(a7)
	move.w #5,-(a7)
	trap #14
	lea 12(a7),a7

	cmpi.b #2,$1fe.w ; enough in case of TT
	beq.s letsGo

	move.w $468.w,d0
.vsync:
	cmp.w $468.w,d0
	beq.s .vsync

	move.b #2,$ffff820a.w
	clr.b $ffff8260.w

letsGo:
	IFEQ	ERROR_SYS
	bsr	INPUT_TRACE_ERROR
	ENDC
	rts

vga50:
	dc.l $170011
	dc.l $2020E
	dc.l $D0012
	dc.l $4EB04D1
	dc.l $3F00F5
	dc.l $41504E7
	dc.w $0200
	dc.w $186
	dc.w $0
	dc.w $5
	dc.w $50

rgb50:
	dc.l $300027
	dc.l $70229
	dc.l $1e002a
	dc.l $2710265
	dc.l $2f0081
	dc.l $211026b
	dc.w $0200
	dc.w $185
	dc.w $0
	dc.w $0
	dc.w $50

bCT60: dc.b 0
	even

******************************************************************
	END
******************************************************************
