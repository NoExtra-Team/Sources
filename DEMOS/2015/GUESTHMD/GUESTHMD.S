***************************************
* // GUESTHMD.PRG                  // *
***************************************
* // Asm Intro Code Atari ST v0.43 // *
* // by Zorro 2/NoExtra (07/07/15) // *
* // http://www.noextra-team.com/  // *
***************************************
* // Original code : Zorro2/NoExtra// *
* // Gfx logo      : NEC/HMD       // *
* // Gfx font      : ripped?       // *
* // Music         : TomChi/NoExtra// *
* // Text          : Sink/HMD      // *
* // Release date  : 17/11/2015    // *
* // Update date   : 01/12/2016    // *
***************************************
  OPT c+ ; Case sensitivity ON        *
  OPT d- ; Debug OFF                  *
  OPT o- ; All optimisations OFF      *
  OPT w- ; Warnings OFF               *
  OPT x- ; Extended debug OFF         *
***************************************

***************************************************************
	SECTION	TEXT                                             // *
***************************************************************

**************************** OVERSCAN ******************************
BOTTOM_BORDER    equ 1         ; Use the bottom overscan           *
TOPBOTTOM_BORDER equ 1         ; Use the top and bottom overscan   *
NO_BORDER        equ 0         ; Use a standard Low-screen         *
********************************************************************
PATTERN          equ $00000000 ; Wears Screens with a plan pattern *
SEEMYVBL         equ 1         ; See CPU used if you press ALT key *
ERROR_SYS        equ 1         ; Manage Errors System              *
FADE_INTRO       equ 1         ; Fade White to black palette       *
TEST_STE         equ 1         ; Code only for Atari STE machine   *
STF_INITS        equ 1         ; STF compatibility MODE            *
********************************************************************
*              Notes : 0 = I use it / 1 = no need !                *
********************************************************************
COLOR_TOP_BOTTOM equ $224/2

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
	lea     12(sp),sp                ;

	clr.l   -(sp)                    ; Supervisor mode
	move.w  #32,-(sp)                ;
	trap    #1                       ;
	addq.l  #6,sp                    ;
	move.l  d0,Save_stack            ; Save adress of stack
mode_super_yet:

 IFEQ TEST_STE
	move.l	$5a0,a0                  ; Test if STE computer
	cmp.l	#$0,a0                     ;
	beq	EXIT_PRG                     ; No cookie_jar inside an old ST
	move.l	$14(a0),d0               ;
	cmp.l	#$0,d0                     ; _MCH=0 then it's an ST-STF-STFM
	beq	EXIT_PRG                     ;
 ENDC

	bsr	clear_bss                    ; Clean BSS stack
	
	bsr	Save_and_init_st             ; Save system parameters

	bsr	black_out                    ; Palette colors to zero

	bsr	Init_screens                 ; Screen initialisations

 IFEQ STF_INITS
	jsr	Multi_boot                   ; Multi Atari Boot code from LEONARD/OXG
 ENDC

**************************** MAIN LOOP ************************>

	bsr	Inits                        ; Initialisations

default_loop:

	bsr	Wait_vbl                     ; Waiting after the VBL

 IFEQ	SEEMYVBL
 move.w		#COLOR_TOP_BOTTOM,$ffff8240.w        ; init line of CPU
 ENDC

* < Put your code here >

	bsr	pcarres                      ; Carrées Haut & Bas
	bsr	cls_pcarres                  ; Effacement
	bsr	text_printer                 ; Texte 16*5 sur 5 lignes, 1 plan

* <

	lea     physique(pc),a0          ; Swapping two Screens
	move.l	(a0),d0                  ;
	move.l	4(a0),(a0)+              ;
	move.l	d0,(a0)                  ;
	move.b  d0,$ffff820d.w           ;
	move    d0,-(sp)                 ;
	move.b  (sp)+,d0                 ;
	move.l  d0,$ffff8200.w           ;

 IFEQ	SEEMYVBL
	cmp.b	#$38,$fffffc02.w           ; ALT key pressed ?
	bne.s	.next_key                  ;
	move.b	#7,$ffff8240.w           ; See the rest of CPU (pink color used)
.next_key:                         ;
 ENDC

	cmp.b	#$39,$fffffc02.w           ; SPACE key pressed ?
	bne	default_loop

	tst.w	ste_flag                   ; Stop Music
	bne.s	.shut_down_ste
	bsr	musoff_stfm
	bra.s	musoff_stfm_e
.shut_down_ste
	bsr	musoff_ste
musoff_stfm_e:

**************************** MAIN LOOP ************************<

ESCAPE_PRG:
	bsr	Restore_st                   ; Restore all registers

EXIT_PRG:
	move.l  Save_stack,-(sp)         ; Restore adress of stack
	move.w  #32,-(sp)                ; Restore user Mode
	trap    #1                       ;
	addq.l  #6,sp                    ;

	clr.w   -(sp)                    ; Pterm()
	trap    #1                       ; EXIT program

***************************************************************
*                                                             *
*                 Initialisations Routines                    *
*                                                             *
***************************************************************
Inits:
	movem.l	d0-d7/a0-a6,-(a7)

 IFEQ	FADE_INTRO
	bsr	fadein                       ; Fading white to black
 ENDC

; Copie le logo Zenith             ; Logo NoExtra
	movea.l	physique(pc),a1          ;
	adda.l	#160*8,a1                ;
	movea.l	#NoExtra_Image,a0        ;
	move.l	#160*186/4-1,d0          ;
	move.l	(a0)+,(a1)+              ;
	dbf	d0,*-2	                     ;

	lea	NoExtra_palette,a0           ; Put palette NoExtra
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d7               ;
	movem.l	d0-d7,(a1)               ;

	move.w	#$70,d7
wait_more:
	move.l	d0,-(sp)
	move.l	$466.w,d0
.att:	cmp.l	$466.w,d0
	beq.s	.att
	move.l	(sp)+,d0
	dbra	d7,wait_more

	bsr	clear_screens

	bsr	black_out                    ; Palette colors to zero

; Copie le logo Scoopex
	movea.l	physique(pc),a1
	adda.l	#160*27,a1
	movea.l	physique+4(pc),a2
	adda.l	#160*27,a2
	movea.l	#Nec_Image,a0
	move.l	#160*53/4-1,d0
	move.l	(a0),(a1)+
	move.l	(a0)+,(a2)+
	dbf	d0,*-4	

	bsr	init_pcarres

	jsr	test_4_ste
	tst.w	ste_flag                   ; Install Music
	bne.s	init_ste
	bsr	muson_stfm
	bra.s	init_stfm
init_ste
	bsr	muson_ste
init_stfm:

	lea	Vbl(pc),a0                   ; Launch VBL
	move.l	a0,$70.w                 ;

	movem.l	(a7)+,d0-d7/a0-a6
	rts

***************************************************************
*                                                             *
*                       Screen Routines                       *
*                                                             *
***************************************************************
 IFEQ	BOTTOM_BORDER
SIZE_OF_SCREEN equ 160*250         ; Screen + Lower Border size
 ENDC
 IFEQ	TOPBOTTOM_BORDER
SIZE_OF_SCREEN equ 160*300         ; Screen + Top & Lower Border size
 ENDC
 IFEQ	NO_BORDER
SIZE_OF_SCREEN equ 160*200         ; Only Screen size in Low Resolution
 ENDC
NB_OF_SCREEN   equ 2               ; Deux écrans déclarés

Init_screens:
	movem.l	d0-d7/a0-a6,-(a7)

	move.l #Screen+256,d0
	clr.b d0
	move.l d0,physique
	add.l #SIZE_OF_SCREEN,d0
	clr.b d0
	move.l d0,physique+4

	bsr	clear_screens

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
	ds.l NB_OF_SCREEN                ; Number of screens declared

clear_screens:	                   ; Clean sadly...
	lea     Screen,a0
	moveq   #NB_OF_SCREEN-1,d1
.cls:
	bsr.s	clear_blit
	add.l	#SIZE_OF_SCREEN,a0
	dbra	d1,.cls
	rts

clear_blit:
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	moveq	#0,d7
	move.l	d1,a1
	move.l	d1,a2
	move.l	d1,a3
	move.l	d1,a4
	move.l	d1,a5
	move.l	d1,a6
	move	#152,d0
	add.l	#160*200,a0
.cl2	movem.l	d1-d7/a1-a6,-(a0)
	movem.l	d1-d7/a1-a6,-(a0)
	movem.l	d1-d7/a1-a6,-(a0)
	movem.l	d1-d7/a1-a6,-(a0)
	dbra	d0,.cl2
	movem.l	d1-d7/a1-a6,-(a0)
	movem.l	d1-d7/a1-a6,-(a0)
	movem.l	d1-d7/a1-a6,-(a0)
	movem.l	d1-d5,-(a0)
	rts

***************************************************************
*                                                             *
*                        Vbl Routines                         *
*                                                             *
***************************************************************
Vbl:	st	Vsync                    ; Synchronisation

;	movem.l	d0-d7/a0-a6,-(a7)

 IFEQ	BOTTOM_BORDER
	clr.b   $fffffa1b.w              ; Disable timer B
	lea	Over_rout(pc),a0             ; HBL
	move.l	a0,$120.w                ; Timer B vector
	move.b	#199,$fffffa21.w         ; At the position
	move.b	#8,$fffffa1b.w           ; Launch HBL
 ENDC

 IFEQ	TOPBOTTOM_BORDER
	move.l	a0,-(a7)
	clr.b	(tacr).w                   ; Stop timer A
	lea	topbord(pc),a0               ; Launch HBL
	move.l	a0,$134.w                ; Timer A vector
	move.b	#99,(tadr).w             ; Countdown value for timer A
	move.b	#4,(tacr).w              ; Delay mode, clock divided by 50
	move.l	(a7)+,a0
 ENDC

 IFEQ	NO_BORDER
	move.b		#$00,$fffa1b	; On stope le timer.
	move.b		#$01,$fffa21	; Pour pouvoir changer TBDR.
	move.l		#ligne_haut_HBL,$120.w	; Nouvelle routine hbl.
	move.b		#$08,$fffa1b	; Even count mode.
 ENDC

;	movem.l	(a7)+,d0-d7/a0-a6
RTE:
	rte

Wait_vbl:                          ; Test Synchronisation
	move.l	a0,-(a7)                 ;
	lea	Vsync,a0                     ;
	sf	(a0)                         ;
.loop:	tst.b	(a0)                 ;
	beq.s	.loop                      ;
	move.l	(a7)+,a0                 ;
	rts

 IFEQ	NO_BORDER
***************************************************************
*                                                             *
*               < Here is the no border rout >                *
*                                                             *
***************************************************************
* La ligne
ligne_haut_HBL:

 move.l	a0,-(a7)                 ;
 move.l	a1,-(a7)                 ;
 move.l	d0,-(a7)                 ;

 move.b		#$00,$fffa1b	; On stope le timer.
 move.l		#.sync,a0
 moveq.l	#$0,d0
.wait:
 move.b		$ff8209,d0	; Base basse ramvideo.
 cmpi.b		#$2,d0		; Milieu de la ligne?
 blt		.wait
 subi.l		#$2,d0		; d0=nbre de nops a executer.
 jmp		$0(a0,d0)
.sync:
	dcb.w	50,$4e71	; 50 nops	Wait line end

 move.l		#$ff8240,a1
 move.l		#colors,a0	; 2 cycles.
 dcb.w     40,$3298		; move.w	(a0)+,(a1)
 move.w		#$000,(a1)

 move.l	(a7)+,d0                 ;
 move.l	(a7)+,a1                 ;
 move.l	(a7)+,a0                 ;

; rte

* Palette ligne cubes
hbl_pal_cube_H:
 clr.b     $fffffa1b.w 
 move.b    #20-2,$fffffa21.w
 move.l    #Palette_Logo_HBL,$120.w 
 move.b    #8,$fffffa1b.w
 move      #$2700,sr 
 movem.l   a0/d0,-(a7) 
 lea       $fffffa21.w,a0
 move.b    (a0),d0 
.wait1:
 cmp.b     (a0),d0 
 beq.s     .wait1 
 dcb.w	6,$4e71
 move.l	a1,-(a7)
 move.l	a2,-(a7)
 move.l    #PAL_CUBE_VERT,a1
 lea       $ffff8240.w,a2
 move.w    (a1)+,2(a2)
 move.w    (a1)+,4(a2)
 move.w    (a1)+,6(a2)
 move.l	(a7)+,a2
 move.l	(a7)+,a1
 move.b    (a0),d0 
.att:
 cmp.b     (a0),d0 
 beq.s     .att 
 movem.l   (a7)+,a0/d0 
 move      #$2300,sr 
 bclr      #0,$fffffa0f.w
 rte 

* Palette Logo
Palette_Logo_HBL:
 clr.b     $fffffa1b.w 
 move.l	#Palette_Texte_Ligne1_HBL,$120.w 
 move.b	#64,$fffffa21.w         ; at the position
 move.b	#8,$fffffa1b.w         ; launch hbl

 movem.l   a0-a1,-(a7) 
 lea       Nec_palette,a0
 lea       $ffff8240.w,a1
 move.l    (a0)+,(a1)+ 
 move.l    (a0)+,(a1)+ 
 move.l    (a0)+,(a1)+ 
 move.l    (a0)+,(a1)+ 
 move.l    (a0)+,(a1)+ 
 move.l    (a0)+,(a1)+ 
 move.l    (a0)+,(a1)+ 
 move.l    (a0)+,(a1)+ 
 movem.l   (a7)+,a0-a1
 bclr      #0,$fffffa0f.w
 rte 

* Palette du texte
Palette_Texte_Ligne1_HBL:
 move.w	#$fff,$ffff8242.w
 clr.b     $fffffa1b.w 
 move.l	#Palette_Texte_Ligne2_HBL,$120.w 
 move.b	#20,$fffffa21.w         ; at the position
 move.b	#8,$fffffa1b.w         ; launch hbl
 bclr      #0,$fffffa0f.w
 rte 

Palette_Texte_Ligne2_HBL:
 move.w	#$eee,$ffff8242.w
 clr.b     $fffffa1b.w 
 move.l	#Palette_Texte_Ligne3_HBL,$120.w 
 move.b	#20-2,$fffffa21.w         ; at the position
 move.b	#8,$fffffa1b.w         ; launch hbl
 bclr      #0,$fffffa0f.w
 rte 

Palette_Texte_Ligne3_HBL:
 move.w	#$ddd,$ffff8242.w
 clr.b     $fffffa1b.w 
 move.l	#Palette_Texte_Ligne4_HBL,$120.w 
 move.b	#20-2-1,$fffffa21.w         ; at the position
 move.b	#8,$fffffa1b.w         ; launch hbl
 bclr      #0,$fffffa0f.w
 rte 

Palette_Texte_Ligne4_HBL:
 move.w	#$ccc,$ffff8242.w
 clr.b     $fffffa1b.w 
 move.l	#Palette_Texte_Ligne5_HBL,$120.w 
 move.b	#20-2-1,$fffffa21.w         ; at the position
 move.b	#8,$fffffa1b.w         ; launch hbl
 bclr      #0,$fffffa0f.w
 rte 

Palette_Texte_Ligne5_HBL:
 move.w	#$bbb,$ffff8242.w
 clr.b     $fffffa1b.w 
 move.l	#hbl_pal_cube_B,$120.w 
 move.b	#20-2,$fffffa21.w         ; at the position
 move.b	#8,$fffffa1b.w         ; launch hbl
 bclr      #0,$fffffa0f.w
 rte 

* Palette ligne cubes
hbl_pal_cube_B:
 clr.b     $fffffa1b.w 
 move.b    #21,$fffffa21.w
 move.l    #ligne_bas_HBL,$120.w 
 move.b    #8,$fffffa1b.w
 move      #$2700,sr 
 movem.l   a0/d0,-(a7) 
 lea       $fffffa21.w,a0
 move.b    (a0),d0 
.wait2:
 cmp.b     (a0),d0 
 beq.s     .wait2
 dcb.w	6,$4e71
 move.l	a1,-(a7)
 move.l	a2,-(a7)
 move.l    #PAL_CUBE_VIOLET,a1
 lea       $ffff8240.w,a2
 move.w    (a1)+,2(a2)
 move.w    (a1)+,4(a2)
 move.w    (a1)+,6(a2)
 move.l	(a7)+,a2
 move.l	(a7)+,a1
 move.b    (a0),d0 
.att:
 cmp.b     (a0),d0 
 beq.s     .att 
 movem.l   (a7)+,a0/d0 
 move      #$2300,sr 
 bclr      #0,$fffffa0f.w
 rte 

* La ligne
ligne_bas_HBL:
 move.l	a0,-(a7)                 ;
 move.l	a1,-(a7)                 ;
 move.l	d0,-(a7)                 ;

 move.b		#$00,$fffa1b	; On stope le timer.
 move.l		#.sync,a0
 moveq.l	#$0,d0
.wait:
 move.b		$ff8209,d0	; Base basse ramvideo.
 cmpi.b		#$2,d0		; Milieu de la ligne?
 blt		.wait
 subi.l		#$2,d0		; d0=nbre de nops a executer.
 jmp		$0(a0,d0)
.sync:
	dcb.w	34,$4e71	; 50 nops	Wait line end

 move.l		#$ff8240,a1
 move.l		#colors,a0	; 2 cycles.
 dcb.w     40,$3298		; move.w	(a0)+,(a1)
 move.w		#COLOR_TOP_BOTTOM,(a1)	;	VIOLET

 move.l	(a7)+,d0                 ;
 move.l	(a7)+,a1                 ;
 move.l	(a7)+,a0                 ;

 bclr	#0,$fffffa0f.w
 rte

colors:
 dc.w	$0 ; 1
i set $111
 rept 7 ; 7
 dc.w	i
i set i+$111
 endr
 dcb.w	20-1,$777 ; 19
i set $777
 rept 7 ; 7
 dc.w	i
i set i-$111
 endr
 dcb.w	6,$0	;	1+7+19+7+6 = 40 couleurs

PAL_CUBE_VIOLET:
	dc.w	$0404+$321
	dc.w	$0303+$321
	dc.w	$0202+$321

PAL_CUBE_VERT:
	dc.w	$0033+$123
	dc.w	$0022+$123
	dc.w	$0011+$123
 ENDC

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
herz = $FFFF820A
iera = $FFFFFA07
ierb = $FFFFFA09
isra = $FFFFFA0F
imra = $FFFFFA13
imrb = $FFFFFA15
tacr = $FFFFFA19
tadr = $FFFFFA1F

my_hbl:
	rte

topbord:
	move.l	a0,-(a7)
	move	#$2100,SR
	stop	#$2100                     ; Sync with interrupt
	clr.b	(tacr).w                   ; Stop timer A
	dcb.w	78,$4E71                   ; 78 nops
	clr.b	(herz).w                   ; 60 Hz
	dcb.w	18,$4E71                   ; 18 nops
	move.b	#2,(herz).w              ; 50 Hz
	lea	botbord(pc),a0
	move.l	a0,$134.w                ; Timer A vector
	move.b	#178,(tadr).w            ; Countdown value for timer A
	move.b	#7,(tacr).w              ; Delay mode, clock divided by 200
	move.l	(a7)+,a0                 ;
	bclr.b	#5,(isra).w              ; Clear end of interrupt flag
	rte

botbord:
	move	#$2100,SR                  ;
	stop	#$2100                     ; sync with interrupt
	clr.b	(tacr).w                   ; stop timer A
	dcb.w	78,$4E71                   ; 78 nops
	clr.b	(herz).w                   ; 60 Hz
	dcb.w	18,$4E71                   ; 18 nops
	move.b	#2,(herz).w              ; 50 Hz
	bclr.b	#5,(isra).w              ;
	rte
 ENDC

***************************************************************
*                                                             *
*                Save/Restore System Routines                 *
*                                                             *
***************************************************************
Save_and_init_st:

	moveq #$13,d0                    ; Pause keyboard
	bsr	sendToKeyboard               ;

	move #$2700,SR                   ; Interrupts OFF
		
	lea	Save_all,a0                  ; Save adresses parameters
	move.b	$fffffa01.w,(a0)+        ; Datareg
	move.b	$fffffa03.w,(a0)+        ; Active edge
	move.b	$fffffa05.w,(a0)+        ; Data direction
	move.b	$fffffa07.w,(a0)+        ; Interrupt enable A
	move.b	$fffffa13.w,(a0)+        ; Interupt Mask A
	move.b	$fffffa09.w,(a0)+        ; Interrupt enable B
	move.b	$fffffa15.w,(a0)+        ; Interrupt mask B
	move.b	$fffffa17.w,(a0)+        ; Automatic/software end of interupt
	move.b	$fffffa19.w,(a0)+        ; Timer A control
	move.b	$fffffa1b.w,(a0)+        ; Timer B control
	move.b	$fffffa1d.w,(a0)+        ; Timer C & D control
	move.b	$fffffa27.w,(a0)+        ; Sync character
	move.b	$fffffa29.w,(a0)+        ; USART control
	move.b	$fffffa2b.w,(a0)+        ; Receiver status
	move.b	$fffffa2d.w,(a0)+        ; Transmitter status
	move.b	$fffffa2f.w,(a0)+        ; USART data

	move.b	$ffff8201.w,(a0)+        ; Save Video addresses
	move.b	$ffff8203.w,(a0)+        ;
	move.b	$ffff820a.w,(a0)+        ;
	move.b	$ffff820d.w,(a0)+        ;
	
	lea	Save_rest,a0                 ; Save adresses parameters
	move.l	$068.w,(a0)+             ; HBL
	move.l	$070.w,(a0)+             ; VBL
	move.l	$110.w,(a0)+             ; TIMER D
	move.l	$114.w,(a0)+             ; TIMER C
	move.l	$118.w,(a0)+             ; ACIA
	move.l	$120.w,(a0)+             ; TIMER B
	move.l	$134.w,(a0)+             ; TIMER A
	move.l	$484.w,(a0)+             ; Conterm

	movem.l	$ffff8240.w,d0-d7        ; Save palette GEM system
	movem.l	d0-d7,(a0)

 IFEQ	ERROR_SYS
	bsr	INPUT_TRACE_ERROR            ; Save vectors list
 ENDC

	clr.b	$fffffa07.w                ; Interrupt enable A (Timer-A & B)
	clr.b	$fffffa09.w                ; Interrupt enable B (Timer-C & D)
	clr.b	$fffffa13.w                ; Interrupt mask A (Timer-A & B)
	clr.b	$fffffa15.w                ; Interrupt mask B (Timer-C & D)
	clr.b	$fffffa19.w                ; Stop Timer A
	clr.b	$fffffa1b.w                ; Stop Timer B
	clr.b	$fffffa21.w                ; Timer B data at zero
	clr.b	$fffffa1d.w                ; Stop Timer C & D

 IFEQ	BOTTOM_BORDER
	sf	$fffffa21.w                  ; Timer B data (number of scanlines to next interrupt)
	sf	$fffffa1b.w                  ; Timer B control (event mode (HBL))
	lea	Over_rout(pc),a0             ; Launch HBL
	move.l	a0,$120.w                ;
	bset	#0,$fffffa07.w             ; Timer B vector
	bset	#0,$fffffa13.w             ; Timer B on
	bclr	#3,$fffffa17.w             ; Automatic End-Interrupt hbl ON
 ENDC

 IFEQ	TOPBOTTOM_BORDER
	move.b	#%00100000,(iera).w      ; Enable Timer A
	move.b	#%00100000,(imra).w      ;
	and.b	#%00010000,(ierb).w        ; Disable all except Timer D
	and.b	#%00010000,(imrb).w        ;
	or.b	#%01000000,(ierb).w        ; Enable keyboard
	or.b	#%01000000,(imrb).w        ;
	clr.b	(tacr).w                   ; Timer A off
	lea	my_hbl(pc),a0                ;
	move.l	a0,$68.w                 ; Horizontal blank
	lea	topbord(pc),a0               ;
	move.l	a0,$134.w                ; Timer A vector
	bclr	#3,$fffffa17.w             ; Automatic End-Interrupt hbl ON
 ENDC

 IFEQ	NO_BORDER
* // Code here....
 ENDC

	stop	#$2300                     ; Interrupts ON

	clr.b	$484.w                     ; No bip, no repeat

	move	#4,-(sp)                   ; Save & Change Resolution (GetRez)
	trap	#14	                       ; Get Current Res.
	addq.l	#2,sp                    ;
	move	d0,Old_Resol+2             ; Save it

	move	#3,-(sp)                   ; Save Screen Address (Logical)
	trap	#14                        ;
	addq.l	#2,sp                    ;
	move.l	d0,Old_Screen+2          ;

 IFEQ TEST_STE
	move	$ffff8264.w,Old_Shift+2    ; Save Screen Shifting
	move	$ffff820e.w,Old_Modulo+2   ; Save Screen Modulo
 ENDC

	moveq #$11,d0                    ; Resume keyboard
	bsr	sendToKeyboard               ;

	moveq #$12,d0                    ; Kill mouse
	bsr	sendToKeyboard               ;

	bsr	flush                        ; Clear buffer keyboard

; If you don't use Multi_boot...
	sf	$ffff8260.w                  ; Low resolution
	move.b	#$2,$ffff820a.w          ; 50 Hz !
	rts

Restore_st:

	bsr	black_out                    ; palette color to zero

	moveq #$13,d0                    ; Pause keyboard
	bsr	sendToKeyboard               ;

	move #$2700,SR                   ; Interrupts OFF

	lea       $ffff8800.w,a0         ; Cut sound
	move.l    #$8000000,(a0)         ; Voice A
	move.l    #$9000000,(a0)         ; Voice B
	move.l    #$a000000,(a0)         ; Voice C

 IFEQ	ERROR_SYS
	bsr	OUTPUT_TRACE_ERROR           ; Restore vectors list
 ENDC

	lea	Save_all,a0                  ; Restore adresses parameters
	move.b	(a0)+,$fffffa01.w        ; Datareg
	move.b	(a0)+,$fffffa03.w        ; Active edge
	move.b	(a0)+,$fffffa05.w        ; Data direction
	move.b	(a0)+,$fffffa07.w        ; Interrupt enable A
	move.b	(a0)+,$fffffa13.w        ; Interupt Mask A
	move.b	(a0)+,$fffffa09.w        ; Interrupt enable B
	move.b	(a0)+,$fffffa15.w        ; Interrupt mask B
	move.b	(a0)+,$fffffa17.w        ; Automatic/software end of interupt
	move.b	(a0)+,$fffffa19.w        ; Timer A control
	move.b	(a0)+,$fffffa1b.w        ; Timer B control
	move.b	(a0)+,$fffffa1d.w        ; Timer C & D control
	move.b	(a0)+,$fffffa27.w        ; Sync character
	move.b	(a0)+,$fffffa29.w        ; USART control
	move.b	(a0)+,$fffffa2b.w        ; Receiver status
	move.b	(a0)+,$fffffa2d.w        ; Transmitter status
	move.b	(a0)+,$fffffa2f.w        ; USART data
	
	move.b	(a0)+,$ffff8201.w        ; Restore Video addresses
	move.b	(a0)+,$ffff8203.w        ;
	move.b	(a0)+,$ffff820a.w        ;
	move.b	(a0)+,$ffff820d.w        ;
	
	lea	Save_rest,a0                 ; Restore adresses parameters
	move.l	(a0)+,$068.w             ; HBL
	move.l	(a0)+,$070.w             ; VBL
	move.l	(a0)+,$110.w             ; TIMER D
	move.l	(a0)+,$114.w             ; TIMER C
	move.l	(a0)+,$118.w             ; ACIA
	move.l	(a0)+,$120.w             ; TIMER B
	move.l	(a0)+,$134.w             ; TIMER A
	move.l	(a0)+,$484.w             ; Conterm

	movem.l	(a0),d0-d7               ; Restore palette GEM system
	movem.l	d0-d7,$ffff8240.w        ;

	bset.b #3,$fffffa17.w            ; Re-activate Timer C

	stop	#$2300                     ; Interrupts ON

	moveq #$11,d0                    ; Resume keyboard
	bsr	sendToKeyboard               ;

	moveq #$8,d0                     ; Restore mouse
	bsr	sendToKeyboard               ;

	bsr	flush                        ; Clear buffer keyboard

 IFEQ TEST_STE
Old_Modulo:
	move	#0,$ffff820e.w             ; Restore Screen Modulo
Old_Shift:
	move	#0,$ffff8264.w             ; Restore Old Shift
 ENDC

Old_Resol:                         ; Restore Old Screen & Resolution
	move	#0,-(sp)                   ;
Old_Screen:                        ;
	move.l	#0,-(sp)                 ;
	move.l	(sp),-(sp)               ;
	move	#5,-(sp)                   ;
	trap	#14                        ;
	lea	12(sp),sp                    ;

	move.w	#$25,-(a7)               ; VSYNC()
	trap	#14                        ;
	addq.w	#2,a7                    ;
	rts

flush:                             ; Empty buffer
	lea	$FFFFFC00.w,a0               
.flush:	move.b	2(a0),d0           
	btst	#0,(a0)                    
	bne.s	.flush                     
	rts

sendToKeyboard:                    ; Keyboard access
.wait:	btst	#1,$fffffc00.w
	beq.s	.wait
	move.b	d0,$FFFFFC02.w
	rts

clear_bss:                         ; Init BSS stack with zero
	lea	bss_start,a0
.loop:	clr.l	(a0)+
	cmp.l	#bss_end,a0
	blt.s	.loop
	rts

black_out:                         ; Clear Palette colors
	moveq     #0,d0
	moveq     #0,d1
	moveq     #0,d2
	moveq     #0,d3
	moveq     #0,d4
	moveq     #0,d5
	moveq     #0,d6
	moveq     #0,d7
	movem.l   d0-d7,$ffff8240.w
	rts

***************************************************************
; SUB-ROUTINES                                             // *
***************************************************************

; *************************************************************************
; ***                     Display square 16x16 2 bitplanes              ***
; ***                           Mcoder/OVERLANDERS                      ***
; *************************************************************************

init_pcarres:
	move.l	#cubes,ptrcube
	rts

PLOT:
	move.l	ptrcube,a0	;source
	move.l	physique(pc),a1	;dest
	lea	160*2(a1),a1
	mulu	#160,d1
	add	d1,a1
	moveq	#15,d1		;shifting
	and	d0,d1
	eor	d1,d0
	lsr	#1,d0
	add	d0,a1
	moveq	#16-1,d0
.aff
	move	(a0)+,d2
	swap	d2
	clr	d2
	lsr.l	d1,d2
	move	(a0)+,d3
	swap	d3
	clr	d3
	lsr.l	d1,d3
	move.l	d2,d4
	or.l	d3,d4
	not.l	d4
	swap	d2
	swap	d3
	swap	d4
	and	d4,(a1)
	or	d2,(a1)
	and	d4,2(a1)
	or	d3,2(a1)
	swap	d2
	swap	d3
	swap	d4
	and	d4,8(a1)
	or	d2,8(a1)
	and	d4,8+2(a1)
	or	d3,8+2(a1)
	lea	160(a1),a1
	dbra	d0,.aff
	rts

display:
	move.l	ptrcube,a0	;source
	moveq	#16-1,d0
.copy	move.l	(a0)+,(a1)
	lea	160(a1),a1
	dbra	d0,.copy
	lea	-16*160(a1),a1
	addq	#8,a1
	rts

DISP:	MACRO
	MOVE	#\1,D0
	MOVE	#\2,D1
	BSR	PLOT
	ENDM

pcarres:
coord_x set 0
	rept 10+1
	DISP	coord_x,3
coord_x set coord_x+16+4+10
	endr

	add.l	#64,ptrcube
	cmp.l	#fincubes,ptrcube
	blo.s	.ok
	move.l	#cubes,ptrcube
.ok:

; Mirroring
	movea.l	physique(pc),a0          ; src
	lea	160*20(a0),a0
	movea.l	physique(pc),a1          ; dest
	lea	160*179(a1),a1
	move	#18,d1                     ; number of lines
.loop;
i	set	0
	rept	40                         ; repeat chunks (1 chunk=16 pixels)
	move.l	i(a0),i(a1)              ; copy 1st half of a chunk (logical)
i	set	i+8                          ; next chunk
	endr                             ; end of copying chunks
	sub.l	#160,a0                    ; next scanline line for logical
	add.l	#160,a1                    ; next scanline line for piccy
	dbf	d1,.loop                     ; end of copying lines
	rts

cls_pcarres:
	move.l	physique+4(pc),a1
	lea	160*5(a1),a1
	moveq	#0,d0                      ; clear square area
 rept 80*16
	move.w	d0,(a1)+
 endr
 rts

; *************************************************************************
; ***                      Display font 16x8 1 bitplane                 ***
; ***                          MSD/POV - Angel/HMD                      ***
; *************************************************************************

OFFSET_DOWN_SCR EQU 160*72
DEPTH           EQU 16

text_printer:
	cmp.w	#1,enable_text
	blt	.do
	beq.s	.nearly
	sub.w	#1,enable_text
	rts

.nearly:
	clr.w	xpos
	clr.w	byte_offset
	sub.w	#1,enable_text
	clr.w	ypos
	rts

.do:tst.w	delay_timer
	beq.s	.no_delay
	sub.w	#1,delay_timer
	rts

.no_delay:
	move.l	ascii_pos,a0
	moveq	#0,d0
	move.b	(a0)+,d0
	cmp.b	#-1,d0
	bne.s	.ligne1
.reset:
	lea	ascii,a0
	clr.w	xpos
	clr.w	byte_offset
	move.b	(a0)+,d0

.ligne1:
	cmp.b	#15,d0	;	--- next line
	bne.s	.ligne2
	move.w	#17*1*160,ypos
	clr.w	byte_offset
	clr.w	xpos
	move.l	a0,ascii_pos
	rts

.ligne2:
	cmp.b	#16,d0	;	--- next line
	bne.s	.ligne3
	move.w	#17*2*160,ypos
	clr.w	byte_offset
	clr.w	xpos
	move.l	a0,ascii_pos
	rts

.ligne3:
	cmp.b	#17,d0	;	--- next line
	bne.s	.ligne4
	move.w	#17*3*160,ypos
	clr.w	byte_offset
	clr.w	xpos
	move.l	a0,ascii_pos
	rts

.ligne4:
	cmp.b	#18,d0	;	--- next line
	bne.s	.ligne5
	move.w	#17*4*160,ypos
	clr.w	byte_offset
	clr.w	xpos
	move.l	a0,ascii_pos
	rts

.ligne5:
	cmp.b	#19,d0	;	--- next line
	bne.s	.notcr
	move.w	#17*5*160,ypos
	clr.w	byte_offset
	clr.w	xpos
	move.l	a0,ascii_pos
	rts

.notcr:
	cmp.b	#20,d0	;	--- end of line
	bne.s	.not_end
	move.w	#100,enable_text
	move.l	a0,ascii_pos
	rts

.not_end:
	cmp.b	#11,d0	; --- delay
	bne.s	.ok
	move.w	#15,delay_timer
	move.l	a0,ascii_pos
	rts

.ok:move.l	a0,ascii_pos
	sub.w	#32,d0
	mulu	#DEPTH,d0
	lea	font,a0
	add.w	d0,a0
	move.w	xpos,d0
	and.w	#$ff,d0
	lsr.w	#1,d0	;\2
	lsl.w	#3,d0	;*8 for words across screen
	add.w	byte_offset,d0
.no_add:
	move.l	physique(pc),a1
	move.l	physique+4(pc),a2
	add.w	ypos,a1
	add.w	ypos,a2
	add.w	d0,a1
	add.w	d0,a2
offset set OFFSET_DOWN_SCR
 rept 16
	move.b	(a0),offset(a1)
	move.b	(a0)+,offset(a2)
offset set offset+160
 endr
	eor.w	#1,byte_offset
	add.w	#1,xpos
	rts

; *************************************************************************
; ***                      Replayer Mods for ST and STe                 ***
; ***                    by WizzCat the 21st of May 1991                ***
; *************************************************************************
 include	"PLAYER.ASM"
 even

***************************************************************
 SECTION	DATA                                             // *
***************************************************************

* < Full data here >

ascii_pos:
	dc.l	ascii
ascii:
;  !",$22,"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_
;          +                                        +
	dc.b	15,"----------------------------------------"
	dc.b	16,"     G E N E R A T I O N   6 8 0 0 0    "
	dc.b	17,"----------------------------------------"
	dc.b	18,"   HEMOROIDS IS PROUD TO INVITATE YOU   "
	dc.b	19,"    TO STNICCC CELEBRATION IN 2015 !    "
	dc.b	20,11

	dc.b	19,"                                        "
	dc.b	18,"                                        "
	dc.b	17,"                                        "
	dc.b	16,"                                        "
	dc.b	15,"                                        "

	dc.b	15,"  DO YOU RECOGNIZE THIS INTRO? WHAT !!  "
	dc.b	16," AN INTRO AMIGA IN A ATARI DEMO ? YES ! "
	dc.b	17,"   BUT FOR 30TH ANNIVERSARY OF AMIGA    "
	dc.b	18,"  WE WANT TO TAKE THIS OPPORTUNITY TO   "
	dc.b	19,"GREET OUR FRIENDS FROM THE SCENE OF THIS"
	dc.b	20,11

	dc.b	19,"                                        "
	dc.b	18,"                                        "
	dc.b	17,"                                        "
	dc.b	16,"                                        "
	dc.b	15,"                                        "

	dc.b	15," LEGENDARY MACHINE DESPITE TO EVERYTHING"
	dc.b	16,"THAT HAS BEEN SAID IN THE PAST, AT THE  "
	dc.b	17,"END YOU SHOULD KNOW THAT WE HAD THE SAME" 
	dc.b	18," GOAL, WHICH WAS TO BEAT LIMITATIONS OF "
	dc.b	19,"    MACHINE AND I THINK WE SUCCEEDED... "
	dc.b	20,11

	dc.b	19,"                                        "
	dc.b	18,"                                        "
	dc.b	17,"                                        "
	dc.b	16,"                                        "
	dc.b	15,"                                        "

	dc.b	15,"               STAY ATARI               "
	dc.b	16,"                                        "
	dc.b	17,"             OR STAY AMIGA              "
	dc.b	18,"                                        "
	dc.b	19,"       BUT ABOVE ALL STAY 68000 !       "
	dc.b	20,11

	dc.b	19,"                                        "
	dc.b	18,"                                        "
	dc.b	17,"                                        "
	dc.b	16,"                                        "
	dc.b	15,"                                        "

	dc.b	15,"CREDITS................................."
	dc.b	16,".................CODE BY ZORRO 2/NOEXTRA"
	dc.b	17,"..........................GFX BY NEC/HMD"
	dc.b	18,".................MUSIC BY TOMCHI/NOEXTRA"
	dc.b	19,"....................AND TEXT BY SINK/HMD"
	dc.b	20,11

	dc.b	19,"                                        "
	dc.b	18,"                                        "
	dc.b	17,"                                        "
	dc.b	16,"                                        "
	dc.b	15,"                                        "

	dc.b	15,"      __   __    __ __    _______       "
	dc.b	16,"      __   __  __  _  __  _    __       "
	dc.b	17,"      _______  __  _  __  _    __       "
	dc.b	18,"      __   __  __     __  _    __       "
	dc.b	19,"      __   __  __     __  _____  2015   "
	dc.b	20,11

	dc.b	19,"                                        "
	dc.b	18,"                                        "
	dc.b	17,"                                        "
	dc.b	16,"                                        "
	dc.b	15,"                                        "

	dc.b	-1
	even

font:
	incbin	"FONT168.DAT"
	even

Nec_palette:
	dc.w	$0000,$0011,$0099,$0022,$08AA,$0833,$01BB,$0244
	dc.w	$0ACC,$0355,$0BDD,$0C66,$00F0,$00F0,$00F0,$00F0

Nec_Image:
	incbin	"NECKO2.IMG"	;	320*53
	even

NoExtra_palette:
	dc.w	$0502,$0512,$0522,$0112,$0667,$0777,$0667,$0556
	dc.w	$0445,$0334,$0223,$0000,$0000,$0000,$0000,$0000

NoExtra_Image:
	incbin	"ZENITH2B.IMG"	;	320*186
	even

cubes:
	incbin	"cubes.bin"
	even
fincubes:

mod_data:
	INCBIN	"PTWEED.MOD"
	even
	DS.B	32768			; Workspace
workspc:
	DS.W	1

* <

***************************************************************
 SECTION	BSS                                              // *
***************************************************************

bss_start:

* < Full data here >

ptrcube:
	ds.l	1

xpos:
	ds.w	1
ypos:
	ds.w	1
byte_offset:
	ds.w	1
enable_text:
	ds.w	1
delay_timer:
	ds.w	1

* <

Vsync:
	ds.w	1

Save_stack:
	ds.l	1

Save_all:
	ds.b	16 * MFP
	ds.b	4	 * Video : f8201.w -> f820d.w

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
	ds.w	16 * Palette System

bss_end:

Screen:
	ds.b	256
	ds.b	SIZE_OF_SCREEN*NB_OF_SCREEN

***************************************************************
	SECTION	TEXT                                             // *
***************************************************************

 IFEQ	FADE_INTRO
***************************************************************
*                                                             *
*                    FADING WHITE TO BLACK                    *
*                  (Don't use VBL with it !)                  *
*                                                             *
***************************************************************
fadein:                            ; Fading effect
	move.l	#$777,d0
.deg:	bsr.s	wart
	bsr.s	wart
	bsr.s	wart
	lea	$ffff8240.w,a0
	moveq	#15,d1
.chg1:	move.w	d0,(a0)+
	dbf	d1,.chg1
	sub.w	#$111,d0
	bne.s	.deg
	bsr	black_out                    ; Palette colors to zero
	rts

wart:                              ; VSYNC()
	move.l	d0,-(sp)
	move.l	$466.w,d0
.att:	cmp.l	$466.w,d0
	beq.s	.att
	move.l	(sp)+,d0
	rts
 ENDC

 IFEQ	ERROR_SYS
***************************************************************
*                                                             *
*               Error Routines (Dbug 2/Next)                  *
*          http://www.defence-force.org/index.htm             *
*                                                             *
***************************************************************
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
	move.w #$2700,SR                  ; Deux erreurs à suivre... non mais !

	move.w	#$0FF,d1
.loop:
	move.w d0,$ffff8240.w             ; Effet raster
	move.w #0,$ffff8240.w
	cmp.b #$3b,$fffffc02.w
	dbra d1,.loop

	pea ESCAPE_PRG                        ; Put the return adress
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

 IFEQ STF_INITS
***************************************************************************
*                                                                         *
* Multi Atari Boot code.                                                  *
* If you have done an ST demo, use that boot to run it on these machines: *
* ST, STe, Mega-ST,TT,Falcon,CT60                                         *
* More info:                                                              *
* http://leonard.oxg.free.fr/articles/multi_atari/multi_atari.html        *
*                                                                         *
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
; => here TT or FALCON
	bclr.b	#5,$FFFF8007.w ; Mode STE on Falcon
	bclr.b	#2,$FFFF8007.w ; Blitter at 8Mhz

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

bCT60:
	dc.b 0
	even
 ENDC

******************************************************************
	END                                                         // *
******************************************************************
