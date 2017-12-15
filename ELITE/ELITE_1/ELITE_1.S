***************************************
* // ELITE_1.PRG                   // *
***************************************
* // Asm Intro Code Atari ST v0.40 // *
* // by Zorro 2/NoExtra (26/08/11) // *
* // http://www.noextra-team.com/  // *
* // Hall of fame of supreme ST    // *
* // Debugger : Maartau            // *
***************************************
* // Original code : Zorro 2       // *
* // Gfx logo      : Zorro 2       // *
* // Gfx font      : Mister.A      // *
* // Music         : Jedi/SectorOne// *
* // Release date  : 22/06/2009    // *
* // Update date   : 30/08/2009    // *
***************************************
  OPT c+ ; Case sensitivity on        *
  OPT d- ; Debug off                  *
  OPT o- ; All optimisations off      *
  OPT w- ; Warnings off               *
  OPT x- ; Extended debug off         *
***************************************

	SECTION	TEXT

********************************************************************
BOTTOM_BORDER    equ 1         ; Use the bottom overscan           *
TOPBOTTOM_BORDER equ 0         ; Use the top and bottom overscan   *
NO_BORDER        equ 1         ; Use a standard screen             *
PATTERN          equ $00000000 ; See the screen plan               *
SEEMYVBL         equ 1         ; See CPU used if you press ALT key *
ERROR_SYS        equ 1	       ; Manage Errors System              *
FADE_INTRO       equ 0	       ; Fade White to black palette       *
********************************************************************
* Remarque : 0 = I use it / 1 = no need !                          *
********************************************************************

Begin:
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
mode_super_yet:

	bsr	wait_for_drive               ; Stop floppy driver

	bsr	clear_bss                    ; Clean BSS stack
	
	bsr	Init_screens                 ; Screens initialisation

	bsr	Save_and_init_st             ; Save system parameters

	jsr	Multi_boot                   ; Multi Atari Boot code.

	bsr	Init                         ; Inits

******************************************************************************

default_loop:

	bsr	Wait_vbl                     ; Waiting after the VBL

	IFEQ	SEEMYVBL
	move.w	#RASTER_HAUT,$ffff8240.w
	ENDC

* < Put your code here >
	* Texts part
	bsr	put_texte
	* Texts scrolling
  BSR	TEXTE_V 
  * Mirror Fx
	bsr	effetmirroir

* <

	lea     physique(pc),a0          ; Swapping screens
	move.l	(a0),d0
	move.l	4(a0),(a0)+
	move.l	d0,(a0)
	move.b  d0,$ffff820d.w
	move    d0,-(sp)
	move.b  (sp)+,d0
	move.l  d0,$ffff8200.w
  	
	IFEQ	SEEMYVBL
	cmp.b	#$38,$fffffc02.w           ; ALT key
	bne.s	next_key
	move.b	#7,$ffff8240.w           ; See the rest of CPU
next_key:	
	ENDC

	cmp.b	#$39,$fffffc02.w           ; SPACE key
	bne	default_loop

******************************************************************************

SORTIE:
	bsr	Restore_st                   ; Restore all registers

	bsr	DeInit_screens               ; Restore allocation memory

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
Init:	movem.l	d0-d7/a0-a6,-(a7)

	IFEQ	FADE_INTRO
	bsr	fadein                       ; Fading white to black
	clr.w	$ffff8240.w
	ENDC
	
	moveq	#1,d0
	jsr	MUSIC+0                      ; Init music

	movea.l	physique(pc),a1
	adda.l	#160*110,a1
	movea.l	#LogoNoeXtra,a0
	move.l	#160*35/4-1,d0
	move.l	(a0)+,(a1)+
	dbf	d0,*-2

	lea	Vbl0(pc),a0
	move.l	a0,$70.w

	lea     PalNoeXtra,a2
	bsr     fadeon	

	lea	PalNoeXtra,a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)

	bsr	delay
	
	* Inits for cursor text
	bsr	Init_texte

	bsr	fadeoff

	move.l	physique(pc),a0
	move.w  #160*200/4-1,d7
	move.l  #PATTERN,(a0)+
	dbf	    d7,*-6

POSITION equ 160*10

	movea.l	physique(pc),a1
	adda.l	#POSITION,a1
	movea.l	physique+4(pc),a2
	adda.l	#POSITION,a2
	movea.l	#EliteLogo,a0
	move.l	#160*56/4-1,d0
	move.l	(a0),(a1)+
	move.l	(a0)+,(a2)+
	dbf	d0,*-4

	lea	Vbl(pc),a0                   ; Launch VBL
	move.l	a0,$70.w

	lea	Default_palette(pc),a0       ; Put palette
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d7               ;
	movem.l	d0-d7,(a1)               ;

	movem.l	(a7)+,d0-d7/a0-a6
	rts

************************************************
*                                              *
*              Screen Routines                 *
*                                              *
************************************************
 IFEQ	BOTTOM_BORDER
SIZE_OF_SCREEN equ 160*250
 ENDC
 IFEQ	TOPBOTTOM_BORDER
SIZE_OF_SCREEN equ 160*300
 ENDC
 IFEQ	NO_BORDER
SIZE_OF_SCREEN equ 160*200
 ENDC

TOTAL_NUMBER_SCREEN equ 2
TOTAL_SIZEOF_SCREEN equ TOTAL_NUMBER_SCREEN*SIZE_OF_SCREEN

Init_screens:
	movem.l	d0-d7/a0-a6,-(a7)

	move.l	#(TOTAL_SIZEOF_SCREEN+256),-(sp)   ; Malloc()
	move.w	#72,-(sp)                ; Screen memory
	trap	#1                         ;
	addq.l	#6,sp                    ;
	tst.l	d0                         ;
	beq	SORTIE                       ; Test memory

	move.l	d0,mstart                ; Keep the adress for Mfree()

	move.l	d0,d1
	add.w	#256,d0                    ; Make screens
	clr.b	d0                         ; Even by 256 bytes
	lea.l	physique(pc),a0            ;
	move.l	d0,(a0)+                 ;
	add.l	#SIZE_OF_SCREEN,d1         ;
	clr.b	d1                         ;
	move.l	d1,(a0)                  ;

	move.b  d0,$ffff820d.w           ; Put physical screen
	move    d0,-(sp)                 ;
	move.b  (sp)+,d0                 ;
	move.l  d0,$ffff8200.w           ;

	move.l	physique(pc),a0          ; Put PATTERN on screens
	move.l	physique+4(pc),a1        ;
	move.w  #(SIZE_OF_SCREEN)/4-1,d7 ;
	move.l  #PATTERN,(a0)+           ;
	move.l  #PATTERN,(a1)+           ;
	dbf	    d7,*-12                  ;

	movem.l	(a7)+,d0-d7/a0-a6
	rts

DeInit_screens:
	movem.l	d0-d7/a0-a6,-(a7)

	move.l	#mstart,-(sp)            ; MFree()
	move.w	#73,-(sp)                ; Screen memory
	trap	#1                         ;
	addq.l	#6,sp                    ;

	movem.l	(a7)+,d0-d7/a0-a6	
	rts

physique:	ds.l TOTAL_NUMBER_SCREEN ; Nombre d'écrans déclarés

************************************************
*                                              *
*               Vbl Routines                   *
*                                              *
************************************************
Vbl0:

	IFEQ	TOPBOTTOM_BORDER
      MOVEM.L   A0/D0,-(A7) 
      MOVE      SR,-(A7)
      MOVE      #$2700,SR 
      MOVE.L    #$592,D0
.loop:DBF       D0,.loop
      MOVE.B    #0,$FFFF820A.W
      MOVEQ     #4,D0 
.wait:DBF       D0,.wait
      MOVE.B    #2,$FFFF820A.W
      MOVE      (A7)+,SR
      MOVEM.L   (A7)+,A0/D0 
	ENDC

	st	Vsync

	jsr 	(MUSIC+8)                  ; Play music
	
	rte

Vbl:

	IFEQ	BOTTOM_BORDER
	lea	Over_rout(pc),a0             ; HBL
	move.l	a0,$120.w                ; Timer B vector
	move.b	#199,$fffffa21.w         ; At the position
	move.b	#8,$fffffa1b.w           ; Launch HBL
	ENDC

	IFEQ	TOPBOTTOM_BORDER
      MOVEM.L   A0/D0,-(A7) 
      MOVE      SR,-(A7)
      MOVE      #$2700,SR 
      MOVE.L    #$592,D0
.loop:DBF       D0,.loop
      MOVE.B    #0,$FFFF820A.W
      MOVEQ     #4,D0 
.wait:DBF       D0,.wait
      MOVE.B    #2,$FFFF820A.W
      MOVE      (A7)+,SR
      MOVEM.L   (A7)+,A0/D0 


      LEA   Default_palette,A0 
      MOVEA.L   #$FF8240,A1 
      MOVE.L    (A0)+,(A1)+ 
      MOVE.L    (A0)+,(A1)+ 

      st	Vsync                        ; Synchronisation
  
      CLR.B     $FFFFFA1B.W 
      MOVE.B    #57+15,$FFFFFA21.W
      MOVE.L    #HBL,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
	ENDC

	jsr 	(MUSIC+8)                  ; Play music

	rte

Wait_vbl:                          ; Test Synchronisation
	move.l	a0,-(a7)
	lea	Vsync,a0
	sf	(a0)
.loop:	tst.b	(a0)
	beq.s	.loop
	move.l	(a7)+,a0
	rts

	IFEQ	BOTTOM_BORDER
***************************************************************
*                                                             *
*             < Here is the lower border rout >               *
*                                                             *
***************************************************************
Over_rout:
	sf	$fffffa21.w                  ; Stop Timer B
	sf	$fffffa1b.w                  ;
	dcb.w	95,$4e71                   ; 95 nops	Wait line end
	sf	$ffff820a.w                  ; Modif Frequency 60 Hz !
	dcb.w	28,$4e71                   ; 28 nops	Wait line end
	move.b	#$2,$ffff820a.w          ; 50 Hz !
	rte
	ENDC

	IFEQ	TOPBOTTOM_BORDER
***************************************************************
*                                                             *
*          < Here is the top and lower border rout >          *
*                                                             *
***************************************************************
HBL:CLR.B     $FFFFFA1B.W 
      MOVE.B    #167-15,$FFFFFA21.W
      MOVE.L    #HBL_END,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      MOVE      #$2700,SR 
      MOVEM.L   A0/D0,-(A7) 
      LEA       $FFFFFA21.W,A0
      MOVE.B    (A0),D0 
.wait:CMP.B     (A0),D0 
      BEQ.S     .wait 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
	    MOVE.L    #$1030777,$FFFF8240.W
	    MOVE.L    #$6660000,$FFFF8242.W
	    MOVE.L    #$7770777,$FFFF8244.W
      MOVE.B    (A0),D0 
.att:CMP.B     (A0),D0 
      BEQ.S     .att 
      MOVEM.L   (A7)+,A0/D0 
      MOVE      #$2300,SR 
      BCLR      #0,$FFFFFA0F.W
      RTE 

HBL_END:CLR.B     $FFFFFA1B.W 
      MOVE.B    #4,$FFFFFA21.W
      MOVE.L    #hblFin,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      MOVE      #$2700,SR 
      MOVEM.L   A0/D0,-(A7) 
      LEA       $FFFFFA21.W,A0
      MOVE.B    (A0),D0 
.wait:CMP.B     (A0),D0 
      BEQ.S     .wait 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
      NOP 
	    MOVE.L    #$0020333,$FFFF8240.W
      MOVE.B    (A0),D0 
.att:CMP.B     (A0),D0 
      BEQ.S     .att 
      MOVEM.L   (A7)+,A0/D0 
      MOVE      #$2300,SR 
      BCLR      #0,$FFFFFA0F.W
      RTE
      
hblFin:CLR.B     $FFFFFA1B.W 
      MOVEM.L   A0/D0,-(A7) 
      MOVEA.W   #$FA21,A0 
      MOVE.B    #$28,(A0) 
      MOVE.L    #hblfin,$120.W 
      MOVE.B    #8,$FFFFFA1B.W
      MOVE.B    (A0),D0 
.wait:CMP.B     (A0),D0 
      BEQ       .wait 
      CLR.B     $FFFF820A.W 
      MOVEQ     #2,D0 
.att:NOP 
      DBF       D0,.att
      MOVE.B    #2,$FFFF820A.W

      MOVEM.L   (A7)+,A0/D0 
      BCLR      #0,$FFFFFA0F.W
      RTE 

hblfin:
      MOVE.L    #$1030000,$FFFF8240.W
      BCLR      #0,$FFFFFA0F.W
      RTE

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

	IFEQ	BOTTOM_BORDER
	sf	$fffffa21.w                  ; Stop the Timer B
	sf	$fffffa1b.w                  ;
	lea	Over_rout(pc),a0             ; Launch HBL
	move.l	a0,$120.w                ;
	bset	#0,$fffffa07.w             ; Timer B vector
	bset	#0,$fffffa13.w             ; Timer B on
	ENDC

	IFEQ	TOPBOTTOM_BORDER
	CLR.B     $FFFFFA07.W 
	CLR.B     $FFFFFA09.W 
	CLR.B     $FFFFFA1B.W 
	ORI.B     #1,$FFFFFA07.W
	ORI.B     #1,$FFFFFA13.W
	ENDC

	rts

Restore_st:

	move #$2700,sr

	jsr	MUSIC+4                      ; Stop SNDH music

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

Old_Resol:                         ; Restore Old Screen & Resolution
	move	#0,-(sp)
Old_Screen:
	move.l	#0,-(sp)
	move.l	(sp),-(sp)
	move	#5,-(sp)
	trap	#14
	lea	12(sp),sp

	move.w	#$25,-(a7)               ; VSYNC
	trap	#14
	addq.w	#2,a7

	rts

hide_mouse:
	movem.l	d0-d2/a0-a2,-(sp)
	dc.w	$a00a
	movem.l	(sp)+,d0-d2/a0-a2
	rts

show_mouse:
	movem.l	d0-d2/a0-a2,-(sp)
	dc.w	$A009
	movem.l	(sp)+,d0-d2/a0-a2
	rts

flush:	lea	$FFFFFC00.w,a0
.flush:	move.b	2(a0),d0
	btst	#0,(a0)
	bne.s	.flush
	rts

setkeyboard:
.wait:	btst	#1,$fffffc00.w
	beq.s	.wait
	move.b	d0,$FFFFFC02.w
	rts

wait_for_drive:
	move.w	$ffff8604.w,d0
	btst	#7,d0
	bne.s	wait_for_drive
	rts

clear_bss:
	lea	bss_start,a0
.loop:	clr.l	(a0)+
	cmp.l	#bss_end,a0
	blt.s	.loop
	rts

	IFEQ	FADE_INTRO
************************************************
*           FADING WHITE TO BLACK              *
*         (Don't use VBL with it !)            *
************************************************
fadein:	move.l	#$777,d0
.deg:	bsr.s	wart
	bsr.s	wart
	bsr.s	wart
	lea	$ffff8240.w,a0
	moveq	#15,d1
.chg1:	move.w	d0,(a0)+
	dbf	d1,.chg1
	sub.w	#$111,d0
	bne.s	.deg
	clr.w	$ffff8240.w
	rts

wart:	move.l	d0,-(sp)
	move.l	$466.w,d0
.att:	cmp.l	$466.w,d0
	beq.s	.att
	move.l	(sp)+,d0
	rts
	ENDC

************************************************
*                                              *
*               Sub Routines                   *
*                                              *
************************************************

fadeon	
	move.w	#8-1,d0	8 stages
.loop1	move.w	#16-1,d1	16 colours
	move.l	#$ffff8240,a0	offset of palette
	move.l	a2,a1	a2 points to new colours
.loop2	move.w	(a0),d2
	andi.w	#$777,d2	Eliminate garbage
	move.w	d2,d3
	andi.w	#$F,d2	d2 contains B value
	lsr.w	#4,d3
	move.w	d3,d4
	andi.w	#$F,d3	d3 contains G value
	lsr.w	#4,d4
	andi.w	#$F,d4	d4 contains R value
	move.w	(a1)+,d5
	andi.w	#$777,d5	As above!
	move.w	d5,d6
	andi.w	#$F,d5	d5 contains B value
	lsr.w	#4,d6
	move.w	d6,d7
	andi.w	#$F,d6	d6 contains G value
	lsr.w	#4,d7
	andi.w	#$F,d7	d7 contains R value
	cmp.w	d2,d5
	beq.s	.end1	B already new colour
	addq.w	#1,d2
.end1	cmp.w	d3,d6
	beq.s	.end2	G already new colour
	addq.w	#1,d3
.end2	cmp.w	d4,d7
	beq.s	.end3	R already new colour
	addq.w	#1,d4
.end3	lsl.w	#8,d4
	lsl.w	#4,d3
	or.w	d4,d2
	or.w	d3,d2	d2 now contains RGB value
	move.w	d2,(a0)+
	dbra	d1,.loop2	Next colour
	rept	6
	bsr	Wait_vbl
	endr
	dbra	d0,.loop1	Next stage
	rts

fadeoff	
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
	rept	6
	bsr	Wait_vbl
	endr
	dbra	d0,.loop1	Next stage
	rts

delay:
	MOVE.b     #$7F,D0 
.synch:
	BSR       Wait_vbl
	sub.b	#1,d0
	cmp.b	#$0,d0	
	bne.s	.synch
	rts	
	
************************************************
*            Displaying cursor text            *
*             1 plan 8*8 + cursor              *
*      Display + clear Fx done by Zorro 2      *
*           Special font by Mister.A           *
************************************************

TEMPO equ $9F	; Time between 2 screens with cursor text

pos_obj	equ	(160*80)+8*4
retour_obj equ (160*11-(8*13))
vitesse_compt	equ	4	; 2 for speedy

POSH equ 160*80
POSB equ 160*129

Init_texte:
           move.w 	#vitesse_compt,cmpt_vbl	* init compteur VBL pour texte
           move.l 	#ptexte-1,ptr
           clr.w 	anim
           move.w	#pos_obj,adr_obj
           move.w 	#vitesse_compt,vitesse
initCLS:   move.w	clsL,d7
           moveq.w		#$0,d7
           move.w	d7,clsL
           move.w	d7,totalL
           move.w	d7,tempoL
           move.l physique(pc),a5
           lea	POSH(a5),a5
           move.l	a5,posHscr1
           move.l a5,a6
           lea	POSB(a6),a6
           move.l	a6,posBscr1
           move.l physique+4(pc),a5
           lea	POSH(a5),a5
           move.l	a5,posHscr2
           move.l a5,a6
           lea	POSB(a6),a6
           move.l	a6,posBscr2
           rts

put_texte: move.w	clsL,d7
           cmp.w #$FFF,d7 
           beq	CLS_TEXTE
           subq.w 	#1,cmpt_vbl
           bne 		nocurseur
           cmp.b	#4,vitesse
           bne.s	vlente
vnormale:  move.w 	#2,cmpt_vbl
           bra.s	suite
vlente:    move.w 	#4,cmpt_vbl
suite:     moveq 	#0,d0
           addq.l 	#1,ptr
           move.l 	ptr,a0
           move.b 	(a0),d0
           ; End of the text
           cmp.b 	#$fd,d0
           bne.s 	.deb_lig
           move.l #ptexte-1,ptr
           move.w	#pos_obj,adr_obj
           move.w	clsL,d7
           move.w		#$FFF,d7
           move.w	d7,clsL
           bra 		nocurseur
           ; End of the text line
.deb_lig:  cmp.b 	#$ff,d0
           bne	.pas_deb
           bsr	screens
i set 0
           rept 8
           clr.b 	i(a3)
           clr.b 	i(a4)
i set i+160
           endr
           add.w 	#retour_obj,adr_obj
           clr.w 	anim
           bra	 	nocurseur
.pas_deb:  cmp.b	#$fe,d0
           bne 	.caract
           bsr	screens
i set 0
           rept 8
           clr.b 	i(a3)
           clr.b 	i(a4)
i set i+160
           endr
           move.w 	#pos_obj,adr_obj
           clr.w	anim
           move.w	clsL,d7
           move.w		#$FFF,d7
           move.w	d7,clsL
           bra 		nocurseur
           ; Character to display
.caract:   asl.w 	#3,d0
           lea 		font,a0
           sub.w	#256,d0
           add.w 	d0,a0
           bsr	screens
i set 0
           rept	8
           move.b 	(a0),i(a3)
           move.b 	(a0)+,i(a4)
i set i+160
           endr
           ; Find the next character
           tst.w 	anim
           bne.s 	.next_car
           move.b 	#1,anim
           addq.w 	#1,adr_obj
           bra.s 	curseur
.next_car: clr.w 	anim
           addq.w 	#7,adr_obj
           ; Display cursor
curseur:   
           lea		font,a0
           lea	728(a0),a0
           bsr	screens
i set 0
           rept	8
           move.b 	(a0),i(a3)
           move.b 	(a0)+,i(a4)
i set i+160
           endr
nocurseur: rts

screens:   move.l 	physique(pc),a3
           lea	2(a3),a3
           add.w 	adr_obj,a3
           move.l 	physique+4(pc),a4
           lea	2(a4),a4
           add.w 	adr_obj,a4
           rts

plus:      move.w 	#4,cmpt_vbl
           rts

moins:     move.w 	#2,cmpt_vbl
           rts

NB_LIGNE_CLS equ 64

CLS_TEXTE:
           move.w	tempoL,d7
           cmp.w	#TEMPO,d7
           bne.s	.end
           move.w	totalL,d7
           cmp.w #NB_LIGNE_CLS,d7 
           ble.s	EFF_TEXTE
           cmp.w #NB_LIGNE_CLS,d7 
           ble.s	.end
           bra	initCLS
.end:      move.w	tempoL,d7
           add.w	#1,d7
           move.w	d7,tempoL
           RTS 

LONGEUR_CLS equ 13+2
POSITION_CLS equ 48-8*2

EFF_TEXTE:
           add.w	#1,d7
           move.w	d7,totalL
           move.l posHscr1,a3
           move.l posBscr1,a4
           move.l posHscr2,a5
           move.l posBscr2,a6
           MOVEQ     #0,D0 
i set POSITION_CLS
           rept LONGEUR_CLS
           MOVE.L    D0,i(A3)
           MOVE.L    D0,i(A4)
           MOVE.L    D0,i(A5)
           MOVE.L    D0,i(A6)
i set i+8
           endr
           lea.l $a0*2(a3),a3
           move.l a3,posHscr2
           suba.l #2*$a0,a4
           move.l a4,posBscr2
           lea.l $a0*2(a5),a5
           move.l a5,posHscr1
           suba.l #2*$a0,a6
           move.l a6,posBscr1
           RTS

************************************************
*        Original code by WIRE/EFFECT          *
*         Ripped/new font by Zorro 2           *
************************************************

POSITION_V equ 160*26

PUTC:MOVEA.L   PTR_BUFF_C2,A0
      MOVEA.L   physique(pc),A1
      lea	POSITION_V(a1),a1
      LEA       160(A1),A2
      LEA       160(A2),A3
      MOVEQ     #0,D1 
      MOVE.W    #$C7,D0 
.loop:MOVE.W    (A0)+,D2
      MOVE.W    D1,0(A1,D2.W) 
      MOVE.W    D1,8(A1,D2.W) 
      MOVE.W    D1,0(A2,D2.W) 
      MOVE.W    D1,8(A2,D2.W) 
      MOVE.W    D1,0(A3,D2.W) 
      MOVE.W    D1,8(A3,D2.W) 
      DBF       D0,.loop
      RTS 

TEXTE_V:BSR       PTEXTE 
      BSR       PUTC 
      MOVEQ     #0,D0 
      ADDI.W    #6,PTRLINE_C0
      ADDI.W    #4,PTRLINE_C1
      ADDI.W    #6,PTRLINE_C2
      ADDI.W    #8,PTRLINE_C3
      CMPI.W    #$2D0,PTRLINE_C0 
      BNE.S     .L1 
      MOVE.W    D0,PTRLINE_C0
.L1:CMPI.W    #$2D0,PTRLINE_C1 
      BNE.S     .L2 
      MOVE.W    D0,PTRLINE_C1
.L2:CMPI.W    #$2D0,PTRLINE_C2 
      BNE.S     .L3 
      MOVE.W    D0,PTRLINE_C2
.L3:CMPI.W    #$2D0,PTRLINE_C3 
      BNE.S     .L4 
      MOVE.W    D0,PTRLINE_C3
.L4:LEA       SINCOS(PC),A0
      MOVE.W    PTRLINE_C0,D0
      MOVE.W    PTRLINE_C1,D1
      MOVE.W    PTRLINE_C2,D2
      MOVE.W    PTRLINE_C3,D3
      ADDI.W    #$5A,D1 
      ADDI.W    #$5A,D2 
      LEA       0(A0,D1.W),A1 
      LEA       0(A0,D2.W),A2 
      LEA       0(A0,D3.W),A3 
      LEA       0(A0,D0.W),A0 
      MOVEA.L   PTR_BUFF_C2,A5
      MOVE.L    PTR_BUFF_C1,PTR_BUFF_C2 
      MOVE.L    A5,PTR_BUFF_C1
      MOVE.W    #0,D0 
      MOVE.W    #$A0,D6 
      MOVE.W    #$85,D7 
      MOVE.W    #0,D4 
      LEA       MY_CARAC(PC),A4
      PEA       (A4)
      MOVEQ     #7,D5 
L5:MOVEA.L   (A7),A4 
      BTST      D5,(A4) 
      BEQ.S     L7 
      MOVE.W    D0,D1 
      MOVE.W    D0,D2 
      MOVE.W    D0,D3 
      ADD.W     D4,D3 
      ADD.W     D4,D1 
      ASL.W     #4,D1 
      ASL.W     #3,D2 
      ASL.W     #4,D3 
      MOVE.W    0(A0,D1.W),D1 
      ADD.W     0(A1,D2.W),D1 
      MOVE.W    0(A2,D3.W),D3 
      ASR.W     #2,D3 
      ADD.W     D3,D2 
      BPL.S     .L6 
      BRA.S     L7 
.L6:CMPI.W    #$13D,D2
      BPL.S     L7 
      ASR.W     #2,D1 
      ADD.W     D7,D1 
      ADD.W     D1,D1 
      MOVE.W    COURBE(PC,D1.W),D1 
      MOVE.W    D1,D3 
      MOVE.W    D2,D1 
      ASR.W     #4,D1 
      ASL.W     #3,D1 
      ADD.W     D1,D3 
      MOVE.W    D3,(A5)+
      MOVEA.L   physique(pc),A4
      lea	POSITION_V(a4),a4
      ADDA.W    D3,A4 
      ANDI.W    #$F,D2
      ASL.W     #2,D2 
      LEA       L0020(PC),A6
      MOVEA.L   0(A6,D2.W),A6 
      JSR       (A6)
L7:SUBQ.W    #1,D5 
      BPL.S     .L8 
      MOVEQ     #7,D5 
      ADDQ.L    #1,(A7) 
.L8:ADDQ.W    #1,D0 
      CMPI.W    #$28,D0 
      BNE.S     L5 
      MOVEQ     #0,D0 
      ADDI.W    #6,D7 
      MOVEQ     #7,D5 
      ADDQ.L    #3,(A7) 
      ADDQ.W    #1,D4 
      CMPI.W    #5,D4 
      BNE       L5 
      ADDQ.L    #4,A7 
      RTS 
      
COURBE:DC.B      $00,$00,$00,$A0,$01,'@',$01,$E0 
      DC.B      $02,$80,$03,' ',$03,$C0,$04,'`' 
      DC.B      $05,$00,$05,$A0,$06,'@',$06,$E0 
      DC.B      $07,$80,$08,' ',$08,$C0,$09,'`' 
      DC.B      $0A,$00,$0A,$A0,$0B,'@',$0B,$E0 
      DC.B      $0C,$80,$0D,' ',$0D,$C0,$0E,'`' 
      DC.B      $0F,$00,$0F,$A0,$10,'@',$10,$E0 
      DC.B      $11,$80,$12,' ',$12,$C0,$13,'`' 
      DC.B      $14,$00,$14,$A0,$15,'@',$15,$E0 
      DC.B      $16,$80,$17,' ',$17,$C0,$18,'`' 
      DC.B      $19,$00,$19,$A0,$1A,'@',$1A,$E0 
      DC.B      $1B,$80,$1C,' ',$1C,$C0,$1D,'`' 
      DC.B      $1E,$00,$1E,$A0,$1F,'@',$1F,$E0 
      DC.B      ' ',$80,'! !',$C0,'"`'
      DC.B      '#',$00,'#',$A0,'$@$',$E0 
      DC.B      '%',$80,'& &',$C0,$27,'`' 
      DC.B      '(',$00,'(',$A0,')@)',$E0 
      DC.B      '*',$80,'+ +',$C0,',`'
      DC.B      '-',$00,'-',$A0,'.@.',$E0 
      DC.B      '/',$80,'0 0',$C0,'1`'
      DC.B      '2',$00,'2',$A0,'3@3',$E0 
      DC.B      '4',$80,'5 5',$C0,'6`'
      DC.B      '7',$00,'7',$A0,'8@8',$E0 
      DC.B      '9',$80,': :',$C0,';`'
      DC.B      '<',$00,'<',$A0,'=@=',$E0 
      DC.B      '>',$80,'? ?',$C0,'@`'
      DC.B      'A',$00,'A',$A0,'B@B',$E0 
      DC.B      'C',$80,'D D',$C0,'E`'
      DC.B      'F',$00,'F',$A0,'G@G',$E0 
      DC.B      'H',$80,'I I',$C0,'J`'
      DC.B      'K',$00,'K',$A0,'L@L',$E0 
      DC.B      'M',$80,'N N',$C0,'O`'
      DC.B      'P',$00,'P',$A0,'Q@Q',$E0 
      DC.B      'R',$80,'S S',$C0,'T`'
      DC.B      'U',$00,'U',$A0,'V@V',$E0 
      DC.B      'W',$80,'X X',$C0,'Y`'
      DC.B      'Z',$00,'Z',$A0,'[@[',$E0 
      DC.B      '\',$80,'] ]',$C0,'^`'
      DC.B      '_',$00,'_',$A0,'`@`',$E0 
      DC.B      'a',$80,'b b',$C0,'c`'
      DC.B      'd',$00,'d',$A0,'e@e',$E0 
      DC.B      'f',$80,'g g',$C0,'h`'
      DC.B      'i',$00,'i',$A0,'j@j',$E0 
      DC.B      'k',$80,'l l',$C0,'m`'
      DC.B      'n',$00,'n',$A0,'o@o',$E0 
      DC.B      'p',$80,'q q',$C0,'r`'
      DC.B      's',$00,'s',$A0,'t@t',$E0 
      DC.B      'u',$80,'v v',$C0,'w`'
      DC.B      'x',$00,'x',$A0,'y@y',$E0 
      DC.B      'z',$80,'{ {',$C0,'|`'
      DC.B      '}',$00,'}',$A0 
L0020:DC.L      L0022 
      DC.L      L0024 
      DC.L      L0026 
      DC.L      L0028 
      DC.L      L002A 
      DC.L      L002B 
      DC.L      L002C 
      DC.L      L002D 
      DC.L      L0021 
      DC.L      L0023 
      DC.L      L0025 
      DC.L      L0027 
      DC.L      L0029 
      DC.L      L002E 
      DC.L      L002F 
      DC.L      L0030 
L0021:
	addq.w	#1,a4
L0022:
	ori.b	#$F0,$0000(a4)
	ori.b	#$F0,$00A0(a4)
	ori.b	#$F0,$0140(a4)
	rts

L0023:
	addq.w	#1,a4
L0024:
	ori.b	#$78,$0000(a4)
	ori.b	#$78,$00A0(a4)
	ori.b	#$78,$0140(a4)
	rts

L0025:
	addq.w	#1,a4
L0026:
	ori.b	#$3C,$0000(a4)
	ori.b	#$3C,$00A0(a4)
	ori.b	#$3C,$0140(a4)
	rts

L0027:
	addq.w	#1,a4
L0028:
	ori.b	#$1E,$0000(a4)
	ori.b	#$1E,$00A0(a4)
	ori.b	#$1E,$0140(a4)
	rts

L0029:
	addq.w	#1,a4
L002A:
	ori.b	#$0F,$0000(a4)
	ori.b	#$0F,$00A0(a4)
	ori.b	#$0F,$0140(a4)
	rts

L002B:
	ori.w	#$0780,$0000(a4)
	ori.w	#$0780,$00A0(a4)
	ori.w	#$0780,$0140(a4)
	rts

L002C:
	ori.w	#$03C0,$0000(a4)
	ori.w	#$03C0,$00A0(a4)
	ori.w	#$03C0,$0140(a4)
	rts

L002D:
	ori.w	#$01E0,$0000(a4)
	ori.w	#$01E0,$00A0(a4)
	ori.w	#$01E0,$0140(a4)
	rts

L002E:
	ori.b	#$07,$0001(a4)
	ori.b	#$07,$00A1(a4)
	ori.b	#$07,$0141(a4)
	ori.b	#$80,$0008(a4)
	ori.b	#$80,$00A8(a4)
	ori.b	#$80,$0148(a4)
	rts

L002F:
	ori.b	#$03,$0001(a4)
	ori.b	#$03,$00A1(a4)
	ori.b	#$03,$0141(a4)
	ori.b	#$C0,$0008(a4)
	ori.b	#$C0,$00A8(a4)
	ori.b	#$C0,$0148(a4)
	rts

L0030:
	ori.b	#$01,$0001(a4)
	ori.b	#$01,$00A1(a4)
	ori.b	#$01,$0141(a4)
	ori.b	#$E0,$0008(a4)
	ori.b	#$E0,$00A8(a4)
	ori.b	#$E0,$0148(a4)
	rts

PTEXTE:SUBQ.W    #1,PTR_CARAC
      BNE.S     .LL1 
      MOVE.W    #6,PTR_CARAC
      BSR.S     .LL2 
.LL1:BRA.S     ROX_L 
.LL2:MOVEQ     #0,D0 
      MOVEA.L   PTR_TEXTE,A0
      MOVE.B    (A0)+,D0
      MOVE.L    A0,PTR_TEXTE
      CMPI.B    #$FF,D0 
      BNE.S     .LL3 
      LEA       TEXTE(PC),A0
      MOVE.L    A0,PTR_TEXTE
      BRA.S     .LL2 
.LL3:CMPI.B    #$2E,D0 ; '.'
      BNE.S     .LL4 
      MOVE.W    #2,PTR_CARAC
.LL4:CMPI.B    #$21,D0 ; '!'
      BNE.S     .LL5 
      MOVE.W    #2,PTR_CARAC
.LL5:SUBI.B    #$20,D0 ; $20 = 32
      MULS      #$18,D0 ; $18 = 24
      LEA       MYFONT(PC),A0
      ADDA.W    D0,A0 
      LEA       BUFF_C0(PC),A1
      MOVEQ     #4,D0 
.LL6:MOVE.W    (A0),(A1) 
      ADDQ.W    #4,A0 
      ADDQ.W    #8,A1 
      DBF       D0,.LL6
      RTS

ROX_L:LEA       MY_CARAC(PC),A0
      MOVEQ     #4,D0 
.loop:ROXL      6(A0) 
      ROXL      4(A0) 
      ROXL      2(A0) 
      ROXL      0(A0) 
      LEA       8(A0),A0
      DBF       D0,.loop
      RTS 

* # Effet mirroir sur le texte :
effetmirroir:
	movea.l	physique(pc),a0
	lea	160*200(a0),a0
	lea	160*24(a0),a0
	movea.l	a0,a1
	moveq.w	#42,d6
.boucle	
	rept	40
	move.l	(a0)+,(a1)+
	endr
	lea	-$140(a0),a0
	dbra	d6,.boucle
	rts

******************************************************************
	SECTION	DATA
******************************************************************

RASTER_HAUT equ $0103
Default_palette:	
	dc.w     RASTER_HAUT,$0002,$0889,$0112,$099A,$0223,$0AAB,$0334
	dc.w     $0BBC,$0445,$0CCD,$0556,$0DDE,$0667,$0EEF,$0777

* Full data here :
* >
;-> Données texte 8*8
font	
	incbin 	"font88*.DAT"
	even
cmpt_vbl   dc.w $2
clsL	     dc.w	$0
totalL	   dc.w	$0
posHscr1	 dc.l	$0
posBscr1	 dc.l	$0
posHscr2	 dc.l	$0
posBscr2	 dc.l	$0
tempoL	   dc.w	$0
ptexte:
* Character ASCII only !
*-> !'#$%&"()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyzCUR<-*

	   dc.b "  ELITE PROUDLY PRESENTS  ",$ff	* Page 1
	   dc.b "         GAME NAME        ",$ff
	   dc.b "     (C)COMPANY NAME      ",$ff
	   dc.b "                          ",$ff
	   dc.b "This intro was coding by  ",$ff
	   dc.b "the Atari ST crew NOEXTRA.",$ff
	   dc.b "Cracked by.........XXXXXXX",$ff
	   dc.b "Code...............ZORRO 2",$ff
	   dc.b "Gfx...............MISTER.A",$ff
	   dc.b "Music.................JEDI",$ff
	   dc.b "                          ",$ff
	   dc.b "NOEXTRA (C)PRODUCTION 2009",$fe

	   dc.b " !",$22,"#$%&",$27,"()*+,-./0123456789",$ff	*	Page 2
	   dc.b ":;<=>?@ABCDEFGHIJKLMNOPQRS",$ff
	   dc.b "TUVWXYZ[\]^_`abcdefghijklm",$ff
	   dc.b "nopqrstuvwxyz             ",$ff
	   dc.b "ECRAN1 FE                 ",$ff
	   dc.b "UN PETIT TEXTE POUR ELITE!",$ff
	   dc.b "UN PETIT TEXTE POUR ELITE!",$ff
	   dc.b "UN PETIT TEXTE POUR ELITE!",$ff
	   dc.b "UN PETIT TEXTE POUR ELITE!",$ff
	   dc.b "UN PETIT TEXTE POUR ELITE!",$ff
	   dc.b "UN PETIT TEXTE POUR ELITE!",$ff
	   dc.b "UN PETIT TEXTE POUR ELITE!",$fe

	   dc.b " !",$22,"#$%&",$27,"()*+,-./0123456789",$ff	*	Page 3
	   dc.b ":;<=>?@ABCDEFGHIJKLMNOPQRS",$ff
	   dc.b "TUVWXYZ[\]^_`abcdefghijklm",$ff
	   dc.b "nopqrstuvwxyz             ",$ff
	   dc.b "ECRAN2 FD                 ",$ff
	   dc.b "UN PETIT TEXTE POUR ELITE!",$ff
	   dc.b "UN PETIT TEXTE POUR ELITE!",$ff
	   dc.b "UN PETIT TEXTE POUR ELITE!",$ff
	   dc.b "UN PETIT TEXTE POUR ELITE!",$ff
	   dc.b "UN PETIT TEXTE POUR ELITE!",$ff
	   dc.b "UN PETIT TEXTE POUR ELITE!",$ff
	   dc.b "UN PETIT TEXTE POUR ELITE!",$ff

		 dc.b $fd	* -> End of the entire text

		 even
; <-

* >
PTR_CARAC:DC.W      $001 
PTR_TEXTE:DC.L      TEXTE 
TEXTE:
      DC.B      '                          '
      DC.B      ' !',$27,'#$%&"()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ' ;<- Only their characters please !!!
      DC.W      $FF00
MY_CARAC:DCB.W     3,$0 
BUFF_C0:DCB.W     249,$0 
PTR_BUFF_C1:DC.L      BUFF_C1 
PTR_BUFF_C2:DC.L      BUFF_C2 
BUFF_C1:DCB.W     200,$0 
BUFF_C2:DCB.W     200,$0 
PTRLINE_C0:DC.W      $0
PTRLINE_C1:DC.W      $0
PTRLINE_C2:DC.W      $0
PTRLINE_C3:DC.W      $0
	even
MYFONT:
	dc.w	$0000,$0000,$0000,$0000 ; ESP
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	
	dc.w	$7000,$0000,$7000,$0000 ; !
	dc.w	$7000,$0000,$0000,$0000
	dc.w	$7000,$0000,$0000,$0000
	
	dc.w	$5000,$5000,$A000,$0000 ; "
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	
	dc.w	$5000,$0000,$F800,$0000 ; #
	dc.w	$5000,$0000,$F800,$0000
	dc.w	$5000,$0000,$0000,$0000
	
	dc.w	$7000,$0000,$A000,$0000 ; $
	dc.w	$7000,$0000,$2800,$0000
	dc.w	$7000,$0000,$0000,$0000
	
	dc.w	$8800,$0000,$1000,$0000 ; %
	dc.w	$2000,$0000,$4000,$0000
	dc.w	$8800,$0000,$0000,$0000
	
	dc.w	$7000,$0000,$A800,$0000 ; &
	dc.w	$6000,$0000,$A800,$0000
	dc.w	$7000,$0000,$0000,$0000
	
	dc.w	$2000,$0000,$2000,$0000 ; '
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	
	dc.w	$6000,$0000,$c000,$0000 ; (
	dc.w	$c000,$0000,$c000,$0000
	dc.w	$6000,$0000,$0000,$0000
	
	dc.w	$3000,$0000,$1800,$0000 ; )
	dc.w	$1800,$0000,$1800,$0000
	dc.w	$3000,$0000,$0000,$0000
	
	dc.w	$A800,$0000,$7000,$0000 ; *
	dc.w	$F800,$0000,$7000,$0000
	dc.w	$A800,$0000,$0000,$0000
	
	dc.w	$2000,$0000,$2000,$0000 ; +
	dc.w	$F800,$0000,$2000,$0000
	dc.w	$2000,$0000,$0000,$0000
	
	dc.w	$0000,$0000,$0000,$0000 ; ,
	dc.w	$0000,$0000,$2000,$0000
	dc.w	$4000,$0000,$0000,$0000
	
	dc.w	$0000,$0000,$0000,$0000 ; -
	dc.w	$7000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	
	dc.w	$0000,$0000,$0000,$0000 ; .
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$2000,$0000,$0000,$0000
	
	dc.w	$0800,$0000,$1000,$0000 ; /
	dc.w	$2000,$0000,$4000,$0000
	dc.w	$8000,$0000,$0000,$0000
	
	dc.w	$7000,$0000,$9800,$0000 ; 0
	dc.w	$A800,$0000,$C800,$0000
	dc.w	$7000,$0000,$0000,$0000
	
	dc.w	$1800,$0000,$3800,$0000 ; 1
	dc.w	$5800,$0000,$1800,$0000
	dc.w	$f800,$0000,$0000,$0000
	
	dc.w	$7000,$0000,$1800,$0000 ; 2
	dc.w	$3000,$0000,$6000,$0000
	dc.w	$f800,$0000,$0000,$0000
	
	dc.w	$f000,$0000,$1800,$0000 ; 3
	dc.w	$7000,$0000,$1800,$0000
	dc.w	$f000,$0000,$0000,$0000
	
	dc.w	$9800,$0000,$9800,$0000 ; 4
	dc.w	$f800,$0000,$1800,$0000
	dc.w	$1800,$0000,$0000,$0000
	
	dc.w	$7000,$0000,$8000,$0000 ; 5
	dc.w	$7000,$0000,$1800,$0000
	dc.w	$f000,$0000,$0000,$0000
	
	dc.w	$7000,$0000,$8000,$0000 ; 6
	dc.w	$7000,$0000,$9800,$0000
	dc.w	$7000,$0000,$0000,$0000
	
	dc.w	$f800,$0000,$1800,$0000 ; 7
	dc.w	$3800,$0000,$1800,$0000
	dc.w	$1800,$0000,$0000,$0000
	
	dc.w	$7000,$0000,$9800,$0000 ; 8
	dc.w	$7000,$0000,$9800,$0000
	dc.w	$7000,$0000,$0000,$0000
	
	dc.w	$7800,$0000,$9800,$0000 ; 9
	dc.w	$7800,$0000,$1800,$0000
	dc.w	$1800,$0000,$0000,$0000
	
	dc.w	$0000,$0000,$2000,$0000 ; :
	dc.w	$0000,$0000,$2000,$0000
	dc.w	$0000,$0000,$0000,$0000
	
	dc.w	$0000,$0000,$0000,$0000 ; ;
	dc.w	$2000,$0000,$2000,$0000
	dc.w	$4000,$0000,$0000,$0000
	
	dc.w	$2000,$0000,$4000,$0000 ; <
	dc.w	$8000,$0000,$4000,$0000
	dc.w	$2000,$0000,$0000,$0000
	
	dc.w	$0000,$0000,$7000,$0000 ; =
	dc.w	$0000,$0000,$7000,$0000
	dc.w	$0000,$0000,$0000,$0000
	
	dc.w	$8000,$0000,$4000,$0000 ; >
	dc.w	$2000,$0000,$4000,$0000
	dc.w	$8000,$0000,$0000,$0000
	
	dc.w	$F800,$0000,$8800,$0000 ; ?
	dc.w	$3800,$0000,$0000,$0000
	dc.w	$2000,$0000,$0000,$0000
	
	dc.w	$7000,$0000,$A800,$0000 ; @
	dc.w	$B800,$0000,$8000,$0000
	dc.w	$7800,$0000,$0000,$0000
	
	dc.w	$7000,$0000,$f800,$0000 ; A
	dc.w	$c800,$0000,$f800,$0000
	dc.w	$c800,$0000,$0000,$0000
	
	dc.w	$f000,$0000,$c800,$0000 ; B
	dc.w	$f800,$0000,$c800,$0000
	dc.w	$f000,$0000,$0000,$0000

	dc.w	$7800,$0000,$c000,$0000 ; C
	dc.w	$c000,$0000,$c000,$0000
	dc.w	$7800,$0000,$0000,$0000
	
	dc.w	$f000,$0000,$c800,$0000 ; D
	dc.w	$c800,$0000,$c800,$0000
	dc.w	$f000,$0000,$0000,$0000
	
	dc.w	$7800,$0000,$c000,$0000 ; E
	dc.w	$f000,$0000,$c000,$0000
	dc.w	$7800,$0000,$0000,$0000
	
	dc.w	$f800,$0000,$c000,$0000 ; F
	dc.w	$f000,$0000,$c000,$0000
	dc.w	$c000,$0000,$0000,$0000
	
	dc.w	$7800,$0000,$c000,$0000 ; G
	dc.w	$d800,$0000,$c800,$0000
	dc.w	$7000,$0000,$0000,$0000
	
	dc.w	$c800,$0000,$c800,$0000 ; H
	dc.w	$f800,$0000,$c800,$0000
	dc.w	$c800,$0000,$0000,$0000
	
	dc.w	$f800,$0000,$7000,$0000 ; I
	dc.w	$7000,$0000,$7000,$0000
	dc.w	$f800,$0000,$0000,$0000
	
	dc.w	$f800,$0000,$1800,$0000 ; J
	dc.w	$1800,$0000,$9800,$0000
	dc.w	$7000,$0000,$0000,$0000
	
	dc.w	$c800,$0000,$d000,$0000 ; K
	dc.w	$f000,$0000,$d000,$0000
	dc.w	$c800,$0000,$0000,$0000
	
	dc.w	$c000,$0000,$c000,$0000 ; L
	dc.w	$c000,$0000,$c000,$0000
	dc.w	$F800,$0000,$0000,$0000
	
	dc.w	$d800,$0000,$e800,$0000 ; M
	dc.w	$c800,$0000,$c800,$0000
	dc.w	$c800,$0000,$0000,$0000
	
	dc.w	$c800,$0000,$e800,$0000 ; N
	dc.w	$d800,$0000,$c800,$0000
	dc.w	$c800,$0000,$0000,$0000
	
	dc.w	$7000,$0000,$c800,$0000 ; O
	dc.w	$c800,$0000,$c800,$0000
	dc.w	$7000,$0000,$0000,$0000
	
	dc.w	$f000,$0000,$c800,$0000 ; P
	dc.w	$f000,$0000,$c000,$0000
	dc.w	$c000,$0000,$0000,$0000
	
	dc.w	$7000,$0000,$c800,$0000 ; Q
	dc.w	$c800,$0000,$d800,$0000
	dc.w	$7800,$0000,$0000,$0000
	
	dc.w	$7000,$0000,$c800,$0000 ; R
	dc.w	$f000,$0000,$c800,$0000
	dc.w	$c800,$0000,$0000,$0000
	
	dc.w	$7800,$0000,$c000,$0000 ; S
	dc.w	$7000,$0000,$0800,$0000
	dc.w	$f000,$0000,$0000,$0000
	
	dc.w	$f800,$0000,$7000,$0000 ; T
	dc.w	$7000,$0000,$7000,$0000
	dc.w	$7000,$0000,$0000,$0000
	
	dc.w	$c800,$0000,$c800,$0000 ; U
	dc.w	$c800,$0000,$c800,$0000
	dc.w	$7000,$0000,$0000,$0000
	
	dc.w	$c800,$0000,$c800,$0000 ; V
	dc.w	$c800,$0000,$c800,$0000
	dc.w	$f000,$0000,$0000,$0000
	
	dc.w	$c800,$0000,$c800,$0000 ; W
	dc.w	$c800,$0000,$f800,$0000
	dc.w	$5000,$0000,$0000,$0000
	
	dc.w	$c800,$0000,$d800,$0000 ; X
	dc.w	$7000,$0000,$d800,$0000
	dc.w	$c800,$0000,$0000,$0000
	
	dc.w	$c800,$0000,$c800,$0000 ; Y
	dc.w	$7000,$0000,$2000,$0000
	dc.w	$2000,$0000,$0000,$0000
	
	dc.w	$f800,$0000,$1800,$0000 ; Z
	dc.w	$1800,$0000,$3000,$0000
	dc.w	$f800,$0000,$0000,$0000
	
	dc.w	$e000,$0000,$c000,$0000 ; [
	dc.w	$c000,$0000,$c000,$0000
	dc.w	$e000,$0000,$0000,$0000
	
	dc.w	$8000,$0000,$4000,$0000 ; \
	dc.w	$2000,$0000,$1000,$0000
	dc.w	$0800,$0000,$0000,$0000
	
	dc.w	$3800,$0000,$1800,$0000 ; ]
	dc.w	$1800,$0000,$1800,$0000
	dc.w	$3800,$0000,$0000,$0000
	
	dc.w	$2000,$0000,$4000,$0000 ; ^
	dc.w	$1000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000
	
	dc.w	$0000,$0000,$0000,$0000 ; _
	dc.w	$0000,$0000,$0000,$0000
	dc.w	$f800,$0000,$0000,$0000
	
	rept 10*3
	dc.w	$0000,$0000,$0000,$0000
	endr
SINCOS:
	dc.w	$0000,$0001,$0002,$0004
	dc.w	$0005,$0006,$0008,$0009
	dc.w	$000A,$000C,$000D,$000F
	dc.w	$0010,$0011,$0013,$0014
	dc.w	$0015,$0017,$0018,$0019
	dc.w	$001B,$001C,$001D,$001E
	dc.w	$0020,$0021,$0022,$0023
	dc.w	$0025,$0026,$0027,$0028
	dc.w	$0029,$002B,$002C,$002D
	dc.w	$002E,$002F,$0030,$0031
	dc.w	$0032,$0033,$0034,$0035
	dc.w	$0036,$0037,$0038,$0039
	dc.w	$003A,$003B,$003C,$003D
	dc.w	$003E,$003F,$003F,$0040
	dc.w	$0041,$0042,$0042,$0043
	dc.w	$0044,$0045,$0045,$0046
	dc.w	$0047,$0047,$0048,$0048
	dc.w	$0049,$0049,$004A,$004A
	dc.w	$004B,$004B,$004B,$004C
	dc.w	$004C,$004C,$004D,$004D
	dc.w	$004D,$004E,$004E,$004E
	dc.w	$004E,$004E,$004E,$004E
	dc.w	$004E,$004E,$004F,$004E
	dc.w	$004E,$004E,$004E,$004E
	dc.w	$004E,$004E,$004E,$004E
	dc.w	$004D,$004D,$004D,$004C
	dc.w	$004C,$004C,$004B,$004B
	dc.w	$004B,$004A,$004A,$0049
	dc.w	$0049,$0048,$0048,$0047
	dc.w	$0047,$0046,$0045,$0045
	dc.w	$0044,$0043,$0042,$0042
	dc.w	$0041,$0040,$003F,$003F
	dc.w	$003E,$003D,$003C,$003B
	dc.w	$003A,$0039,$0038,$0037
	dc.w	$0036,$0035,$0034,$0033
	dc.w	$0032,$0031,$0030,$002F
	dc.w	$002E,$002D,$002C,$002B
	dc.w	$0029,$0028,$0027,$0026
	dc.w	$0025,$0023,$0022,$0021
	dc.w	$0020,$001E,$001D,$001C
	dc.w	$001B,$0019,$0018,$0017
	dc.w	$0015,$0014,$0013,$0011
	dc.w	$0010,$000F,$000D,$000C
	dc.w	$000A,$0009,$0008,$0006
	dc.w	$0005,$0004,$0002,$0001
	dc.w	$0000,$FFFF,$FFFE,$FFFC
	dc.w	$FFFB,$FFFA,$FFF8,$FFF7
	dc.w	$FFF6,$FFF4,$FFF3,$FFF1
	dc.w	$FFF0,$FFEF,$FFED,$FFEC
	dc.w	$FFEB,$FFE9,$FFE8,$FFE7
	dc.w	$FFE5,$FFE4,$FFE3,$FFE2
	dc.w	$FFE0,$FFDF,$FFDE,$FFDD
	dc.w	$FFDB,$FFDA,$FFD9,$FFD8
	dc.w	$FFD7,$FFD5,$FFD4,$FFD3
	dc.w	$FFD2,$FFD1,$FFD0,$FFCF
	dc.w	$FFCE,$FFCD,$FFCC,$FFCB
	dc.w	$FFCA,$FFC9,$FFC8,$FFC7
	dc.w	$FFC6,$FFC5,$FFC4,$FFC3
	dc.w	$FFC2,$FFC1,$FFC1,$FFC0
	dc.w	$FFBF,$FFBE,$FFBE,$FFBD
	dc.w	$FFBC,$FFBB,$FFBB,$FFBA
	dc.w	$FFB9,$FFB9,$FFB8,$FFB8
	dc.w	$FFB7,$FFB7,$FFB6,$FFB6
	dc.w	$FFB5,$FFB5,$FFB5,$FFB4
	dc.w	$FFB4,$FFB4,$FFB3,$FFB3
	dc.w	$FFB3,$FFB2,$FFB2,$FFB2
	dc.w	$FFB2,$FFB2,$FFB2,$FFB2
	dc.w	$FFB2,$FFB2,$FFB1,$FFB2
	dc.w	$FFB2,$FFB2,$FFB2,$FFB2
	dc.w	$FFB2,$FFB2,$FFB2,$FFB2
	dc.w	$FFB3,$FFB3,$FFB3,$FFB4
	dc.w	$FFB4,$FFB4,$FFB5,$FFB5
	dc.w	$FFB5,$FFB6,$FFB6,$FFB7
	dc.w	$FFB7,$FFB8,$FFB8,$FFB9
	dc.w	$FFB9,$FFBA,$FFBB,$FFBB
	dc.w	$FFBC,$FFBD,$FFBE,$FFBE
	dc.w	$FFBF,$FFC0,$FFC1,$FFC1
	dc.w	$FFC2,$FFC3,$FFC4,$FFC5
	dc.w	$FFC6,$FFC7,$FFC8,$FFC9
	dc.w	$FFCA,$FFCB,$FFCC,$FFCD
	dc.w	$FFCE,$FFCF,$FFD0,$FFD1
	dc.w	$FFD2,$FFD3,$FFD4,$FFD5
	dc.w	$FFD7,$FFD8,$FFD9,$FFDA
	dc.w	$FFDB,$FFDD,$FFDE,$FFDF
	dc.w	$FFE0,$FFE2,$FFE3,$FFE4
	dc.w	$FFE5,$FFE7,$FFE8,$FFE9
	dc.w	$FFEB,$FFEC,$FFED,$FFEF
	dc.w	$FFF0,$FFF1,$FFF3,$FFF4
	dc.w	$FFF6,$FFF7,$FFF8,$FFFA
	dc.w	$FFFB,$FFFC,$FFFE,$FFFF
	dc.w	$0000,$0001,$0002,$0004
	dc.w	$0005,$0006,$0008,$0009
	dc.w	$000A,$000C,$000D,$000F
	dc.w	$0010,$0011,$0013,$0014
	dc.w	$0015,$0017,$0018,$0019
	dc.w	$001B,$001C,$001D,$001E
	dc.w	$0020,$0021,$0022,$0023
	dc.w	$0025,$0026,$0027,$0028
	dc.w	$0029,$002B,$002C,$002D
	dc.w	$002E,$002F,$0030,$0031
	dc.w	$0032,$0033,$0034,$0035
	dc.w	$0036,$0037,$0038,$0039
	dc.w	$003A,$003B,$003C,$003D
	dc.w	$003E,$003F,$003F,$0040
	dc.w	$0041,$0042,$0042,$0043
	dc.w	$0044,$0045,$0045,$0046
	dc.w	$0047,$0047,$0048,$0048
	dc.w	$0049,$0049,$004A,$004A
	dc.w	$004B,$004B,$004B,$004C
	dc.w	$004C,$004C,$004D,$004D
	dc.w	$004D,$004E,$004E,$004E
	dc.w	$004E,$004E,$004E,$004E
	dc.w	$004E,$004E,$004F,$004E
	dc.w	$004E,$004E,$004E,$004E
	dc.w	$004E,$004E,$004E,$004E
	dc.w	$004D,$004D,$004D,$004C
	dc.w	$004C,$004C,$004B,$004B
	dc.w	$004B,$004A,$004A,$0049
	dc.w	$0049,$0048,$0048,$0047
	dc.w	$0047,$0046,$0045,$0045
	dc.w	$0044,$0043,$0042,$0042
	dc.w	$0041,$0040,$003F,$003F
	dc.w	$003E,$003D,$003C,$003B
	dc.w	$003A,$0039,$0038,$0037
	dc.w	$0036,$0035,$0034,$0033
	dc.w	$0032,$0031,$0030,$002F
	dc.w	$002E,$002D,$002C,$002B
	dc.w	$0029,$0028,$0027,$0026
	dc.w	$0025,$0023,$0022,$0021
	dc.w	$0020,$001E,$001D,$001C
	dc.w	$001B,$0019,$0018,$0017
	dc.w	$0015,$0014,$0013,$0011
	dc.w	$0010,$000F,$000D,$000C
	dc.w	$000A,$0009,$0008,$0006
	dc.w	$0005,$0004,$0002,$0001
	dc.w	$0000,$FFFF,$FFFE,$FFFC
	dc.w	$FFFB,$FFFA,$FFF8,$FFF7
	dc.w	$FFF6,$FFF4,$FFF3,$FFF1
	dc.w	$FFF0,$FFEF,$FFED,$FFEC
	dc.w	$FFEB,$FFE9,$FFE8,$FFE7
	dc.w	$FFE5,$FFE4,$FFE3,$FFE2
	dc.w	$FFE0,$FFDF,$FFDE,$FFDD
	dc.w	$FFDB,$FFDA,$FFD9,$FFD8
	dc.w	$FFD7,$FFD5,$FFD4,$FFD3
	dc.w	$FFD2,$FFD1,$FFD0,$FFCF
	dc.w	$FFCE,$FFCD,$FFCC,$FFCB
	dc.w	$FFCA,$FFC9,$FFC8,$FFC7
	dc.w	$FFC6,$FFC5,$FFC4,$FFC3
	dc.w	$FFC2,$FFC1,$FFC1,$FFC0
	dc.w	$FFBF,$FFBE,$FFBE,$FFBD
	dc.w	$FFBC,$FFBB,$FFBB,$FFBA
	dc.w	$FFB9,$FFB9,$FFB8,$FFB8
	dc.w	$FFB7,$FFB7,$FFB6,$FFB6
	dc.w	$FFB5,$FFB5,$FFB5,$FFB4
	dc.w	$FFB4,$FFB4,$FFB3,$FFB3
	dc.w	$FFB3,$FFB2,$FFB2,$FFB2
	dc.w	$FFB2,$FFB2,$FFB2,$FFB2
	dc.w	$FFB2,$FFB2,$FFB1,$FFB2
	dc.w	$FFB2,$FFB2,$FFB2,$FFB2
	dc.w	$FFB2,$FFB2,$FFB2,$FFB2
	dc.w	$FFB3,$FFB3,$FFB3,$FFB4
	dc.w	$FFB4,$FFB4,$FFB5,$FFB5
	dc.w	$FFB5,$FFB6,$FFB6,$FFB7
	dc.w	$FFB7,$FFB8,$FFB8,$FFB9
	dc.w	$FFB9,$FFBA,$FFBB,$FFBB
	dc.w	$FFBC,$FFBD,$FFBE,$FFBE
	dc.w	$FFBF,$FFC0,$FFC1,$FFC1
	dc.w	$FFC2,$FFC3,$FFC4,$FFC5
	dc.w	$FFC6,$FFC7,$FFC8,$FFC9
	dc.w	$FFCA,$FFCB,$FFCC,$FFCD
	dc.w	$FFCE,$FFCF,$FFD0,$FFD1
	dc.w	$FFD2,$FFD3,$FFD4,$FFD5
	dc.w	$FFD7,$FFD8,$FFD9,$FFDA
	dc.w	$FFDB,$FFDD,$FFDE,$FFDF
	dc.w	$FFE0,$FFE2,$FFE3,$FFE4
	dc.w	$FFE5,$FFE7,$FFE8,$FFE9
	dc.w	$FFEB,$FFEC,$FFED,$FFEF
	dc.w	$FFF0,$FFF1,$FFF3,$FFF4
	dc.w	$FFF6,$FFF7,$FFF8,$FFFA
	dc.w	$FFFB,$FFFC,$FFFE,$FFFF
	dc.w	$0000,$0001,$0002,$0004
	dc.w	$0005,$0006,$0008,$0009
	dc.w	$000A,$000C,$000D,$000F
	dc.w	$0010,$0011,$0013,$0014
	dc.w	$0015,$0017,$0018,$0019
	dc.w	$001B,$001C,$001D,$001E
	dc.w	$0020,$0021,$0022,$0023
	dc.w	$0025,$0026,$0027,$0028
	dc.w	$0029,$002B,$002C,$002D
	dc.w	$002E,$002F,$0030,$0031
	dc.w	$0032,$0033,$0034,$0035
	dc.w	$0036,$0037,$0038,$0039
	dc.w	$003A,$003B,$003C,$003D
	dc.w	$003E,$003F,$003F,$0040
	dc.w	$0041,$0042,$0042,$0043
	dc.w	$0044,$0045,$0045,$0046
	dc.w	$0047,$0047,$0048,$0048
	dc.w	$0049,$0049,$004A,$004A
	dc.w	$004B,$004B,$004B,$004C
	dc.w	$004C,$004C,$004D,$004D
	dc.w	$004D,$004E,$004E,$004E
	dc.w	$004E,$004E,$004E,$004E
	dc.w	$004E,$004E,$004F,$004E
	dc.w	$004E,$004E,$004E,$004E
	dc.w	$004E,$004E,$004E,$004E
	dc.w	$004D,$004D,$004D,$004C
	dc.w	$004C,$004C,$004B,$004B
	dc.w	$004B,$004A,$004A,$0049
	dc.w	$0049,$0048,$0048,$0047
	dc.w	$0047,$0046,$0045,$0045
	dc.w	$0044,$0043,$0042,$0042
	dc.w	$0041,$0040,$003F,$003F
	dc.w	$003E,$003D,$003C,$003B
	dc.w	$003A,$0039,$0038,$0037
	dc.w	$0036,$0035,$0034,$0033
	dc.w	$0032,$0031,$0030,$002F
	dc.w	$002E,$002D,$002C,$002B
	dc.w	$0029,$0028,$0027,$0026
	dc.w	$0025,$0023,$0022,$0021
	dc.w	$0020,$001E,$001D,$001C
	dc.w	$001B,$0019,$0018,$0017
	dc.w	$0015,$0014,$0013,$0011
	dc.w	$0010,$000F,$000D,$000C
	dc.w	$000A,$0009,$0008,$0006
	dc.w	$0005,$0004,$0002,$0001
	dc.w	$0000,$FFFF,$FFFE,$FFFC
	dc.w	$FFFB,$FFFA,$FFF8,$FFF7
	dc.w	$FFF6,$FFF4,$FFF3,$FFF1
	dc.w	$FFF0,$FFEF,$FFED,$FFEC
	dc.w	$FFEB,$FFE9,$FFE8,$FFE7
	dc.w	$FFE5,$FFE4,$FFE3,$FFE2
	dc.w	$FFE0,$FFDF,$FFDE,$FFDD
	dc.w	$FFDB,$FFDA,$FFD9,$FFD8
	dc.w	$FFD7,$FFD5,$FFD4,$FFD3
	dc.w	$FFD2,$FFD1,$FFD0,$FFCF
	dc.w	$FFCE,$FFCD,$FFCC,$FFCB
	dc.w	$FFCA,$FFC9,$FFC8,$FFC7
	dc.w	$FFC6,$FFC5,$FFC4,$FFC3
	dc.w	$FFC2,$FFC1,$FFC1,$FFC0
	dc.w	$FFBF,$FFBE,$FFBE,$FFBD
	dc.w	$FFBC,$FFBB,$FFBB,$FFBA
	dc.w	$FFB9,$FFB9,$FFB8,$FFB8
	dc.w	$FFB7,$FFB7,$FFB6,$FFB6
	dc.w	$FFB5,$FFB5,$FFB5,$FFB4
	dc.w	$FFB4,$FFB4,$FFB3,$FFB3
	dc.w	$FFB3,$FFB2,$FFB2,$FFB2
	dc.w	$FFB2,$FFB2,$FFB2,$FFB2
	dc.w	$FFB2,$FFB2,$FFB1,$FFB2
	dc.w	$FFB2,$FFB2,$FFB2,$FFB2
	dc.w	$FFB2,$FFB2,$FFB2,$FFB2
	dc.w	$FFB3,$FFB3,$FFB3,$FFB4
	dc.w	$FFB4,$FFB4,$FFB5,$FFB5
	dc.w	$FFB5,$FFB6,$FFB6,$FFB7
	dc.w	$FFB7,$FFB8,$FFB8,$FFB9
	dc.w	$FFB9,$FFBA,$FFBB,$FFBB
	dc.w	$FFBC,$FFBD,$FFBE,$FFBE
	dc.w	$FFBF,$FFC0,$FFC1,$FFC1
	dc.w	$FFC2,$FFC3,$FFC4,$FFC5
	dc.w	$FFC6,$FFC7,$FFC8,$FFC9
	dc.w	$FFCA,$FFCB,$FFCC,$FFCD
	dc.w	$FFCE,$FFCF,$FFD0,$FFD1
	dc.w	$FFD2,$FFD3,$FFD4,$FFD5
	dc.w	$FFD7,$FFD8,$FFD9,$FFDA
	dc.w	$FFDB,$FFDD,$FFDE,$FFDF
	dc.w	$FFE0,$FFE2,$FFE3,$FFE4
	dc.w	$FFE5,$FFE7,$FFE8,$FFE9
	dc.w	$FFEB,$FFEC,$FFED,$FFEF
	dc.w	$FFF0,$FFF1,$FFF3,$FFF4
	dc.w	$FFF6,$FFF7,$FFF8,$FFFA
	dc.w	$FFFB,$FFFC,$FFFE,$FFFF
	dc.w	$0000,$0001,$0002,$0004
	dc.w	$0005,$0006,$0008,$0009
	dc.w	$000A,$000C,$000D,$000F
	dc.w	$0010,$0011,$0013,$0014
	dc.w	$0015,$0017,$0018,$0019
	dc.w	$001B,$001C,$001D,$001E
	dc.w	$0020,$0021,$0022,$0023
	dc.w	$0025,$0026,$0027,$0028
	dc.w	$0029,$002B,$002C,$002D
	dc.w	$002E,$002F,$0030,$0031
	dc.w	$0032,$0033,$0034,$0035
	dc.w	$0036,$0037,$0038,$0039
	dc.w	$003A,$003B,$003C,$003D
	dc.w	$003E,$003F,$003F,$0040
	dc.w	$0041,$0042,$0042,$0043
	dc.w	$0044,$0045,$0045,$0046
	dc.w	$0047,$0047,$0048,$0048
	dc.w	$0049,$0049,$004A,$004A
	dc.w	$004B,$004B,$004B,$004C
	dc.w	$004C,$004C,$004D,$004D
	dc.w	$004D,$004E,$004E,$004E
	dc.w	$004E,$004E,$004E,$004E
	dc.w	$004E,$004E,$004F,$004E
	dc.w	$004E,$004E,$004E,$004E
	dc.w	$004E,$004E,$004E,$004E
	dc.w	$004D,$004D,$004D,$004C
	dc.w	$004C,$004C,$004B,$004B
	dc.w	$004B,$004A,$004A,$0049
	dc.w	$0049,$0048,$0048,$0047
	dc.w	$0047,$0046,$0045,$0045
	dc.w	$0044,$0043,$0042,$0042
	dc.w	$0041,$0040,$003F,$003F
	dc.w	$003E,$003D,$003C,$003B
	dc.w	$003A,$0039,$0038,$0037
	dc.w	$0036,$0035,$0034,$0033
	dc.w	$0032,$0031,$0030,$002F
	dc.w	$002E,$002D,$002C,$002B
	dc.w	$0029,$0028,$0027,$0026
	dc.w	$0025,$0023,$0022,$0021
	dc.w	$0020,$001E,$001D,$001C
	dc.w	$001B,$0019,$0018,$0017
	dc.w	$0015,$0014,$0013,$0011
	dc.w	$0010,$000F,$000D,$000C
	dc.w	$000A,$0009,$0008,$0006
	dc.w	$0005,$0004,$0002,$0001
	dc.w	$0000,$FFFF,$FFFE,$FFFC
	dc.w	$FFFB,$FFFA,$FFF8,$FFF7
	dc.w	$FFF6,$FFF4,$FFF3,$FFF1
	dc.w	$FFF0,$FFEF,$FFED,$FFEC
	dc.w	$FFEB,$FFE9,$FFE8,$FFE7
	dc.w	$FFE5,$FFE4,$FFE3,$FFE2
	dc.w	$FFE0,$FFDF,$FFDE,$FFDD
	dc.w	$FFDB,$FFDA,$FFD9,$FFD8
	dc.w	$FFD7,$FFD5,$FFD4,$FFD3
	dc.w	$FFD2,$FFD1,$FFD0,$FFCF
	dc.w	$FFCE,$FFCD,$FFCC,$FFCB
	dc.w	$FFCA,$FFC9,$FFC8,$FFC7
	dc.w	$FFC6,$FFC5,$FFC4,$FFC3
	dc.w	$FFC2,$FFC1,$FFC1,$FFC0
	dc.w	$FFBF,$FFBE,$FFBE,$FFBD
	dc.w	$FFBC,$FFBB,$FFBB,$FFBA
	dc.w	$FFB9,$FFB9,$FFB8,$FFB8
	dc.w	$FFB7,$FFB7,$FFB6,$FFB6
	dc.w	$FFB5,$FFB5,$FFB5,$FFB4
	dc.w	$FFB4,$FFB4,$FFB3,$FFB3
	dc.w	$FFB3,$FFB2,$FFB2,$FFB2
	dc.w	$FFB2,$FFB2,$FFB2,$FFB2
	dc.w	$FFB2,$FFB2,$FFB1,$FFB2
	dc.w	$FFB2,$FFB2,$FFB2,$FFB2
	dc.w	$FFB2,$FFB2,$FFB2,$FFB2
	dc.w	$FFB3,$FFB3,$FFB3,$FFB4
	dc.w	$FFB4,$FFB4,$FFB5,$FFB5
	dc.w	$FFB5,$FFB6,$FFB6,$FFB7
	dc.w	$FFB7,$FFB8,$FFB8,$FFB9
	dc.w	$FFB9,$FFBA,$FFBB,$FFBB
	dc.w	$FFBC,$FFBD,$FFBE,$FFBE
	dc.w	$FFBF,$FFC0,$FFC1,$FFC1
	dc.w	$FFC2,$FFC3,$FFC4,$FFC5
	dc.w	$FFC6,$FFC7,$FFC8,$FFC9
	dc.w	$FFCA,$FFCB,$FFCC,$FFCD
	dc.w	$FFCE,$FFCF,$FFD0,$FFD1
	dc.w	$FFD2,$FFD3,$FFD4,$FFD5
	dc.w	$FFD7,$FFD8,$FFD9,$FFDA
	dc.w	$FFDB,$FFDD,$FFDE,$FFDF
	dc.w	$FFE0,$FFE2,$FFE3,$FFE4
	dc.w	$FFE5,$FFE7,$FFE8,$FFE9
	dc.w	$FFEB,$FFEC,$FFED,$FFEF
	dc.w	$FFF0,$FFF1,$FFF3,$FFF4
	dc.w	$FFF6,$FFF7,$FFF8,$FFFA
	dc.w	$FFFB,$FFFC,$FFFE,$FFFF
	dc.w	$0000

PalElite:
	dc.w     $0000,$0001,$0889,$0112,$099A,$0223,$0AAB,$0334
	dc.w     $0BBC,$0445,$0CCD,$0556,$0DDE,$0667,$0EEF,$0777

EliteLogo:
	incbin	"ELITLOGO.IMG"
	even

PalNoeXtra:
	dc.w	$0000,$0666,$0555,$0444,$0333,$0222,$0111,$00F0
	dc.w	$0766,$0655,$0544,$0667,$0556,$0445,$0777,$0FFF

LogoNoeXtra:
	incbin	"SUPPLEX0.IMG"
	even

* <

MUSIC:
	incbin	*.snd                    ; SNDH music -> Not compressed please !!!
	even

******************************************************************
	SECTION	BSS
******************************************************************

bss_start:

* < Full data here >
ptr	       ds.l 1
vitesse	   ds.w 1
anim       ds.w 1
adr_obj    ds.l 1

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
mstart:	ds.l	1 * location memory adress

bss_end:

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

	pea SORTIE                        ; Put the return adress
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
