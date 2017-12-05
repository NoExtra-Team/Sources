**************************************
* Loader double "pexec 0" (boucle)   *
* Touches "0" & "1" + test en $40.w  *
* 02/11/2009 - For Freddo by Maartau *
* 03/04/2012 - Modified by Zorro 2   *
* for Falcon version compatibility   *
************************************ *

**************************************
    OPT c+ ; Case sensitivity on.    *
    OPT d- ; Debug off.              *
    OPT o- ; All optimisations off.  *
    OPT w- ; Warnings off.           *
    OPT x- ; Extended debug off.     *
**************************************

	SECTION	TEXT

Begin
	jmp	ON_Y_VA_
*--------------------------------------------------------------------------
TOTO:
	DC.B	"...LOADER BY MAARTAU AND ZORRO 2 IN 2012... "
	EVEN
*--------------------------------------------------------------------------

ON_Y_VA_:
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

	bsr	set_super                    ; For Restoring
	dc.w	$a00a
	bsr	get_original
	bsr	get_old_palette

	bsr	set_low_rez

	lea	$484.w,a3                    ; Cut "Bip"
	move.b	(a3),old_484
	clr.b	(a3)

	jsr	Multi_boot                   ; Detection Hardware

	lea       bufferfile,a0          ; Put adresses of files
	move.l    #null,(a0)+
	move.l    #null,(a0)+
	move.l    #dmofile_1,(a0)+
	move.l    #dmofile_2,(a0)+
	move.l    #dmofile_3,(a0)+
	move.l    #dmofile_4,(a0)+
	move.l    #dmofile_5,(a0)+
	move.l    #dmofile_6,(a0)+
	move.l    #dmofile_7,(a0)+
	move.l    #dmofile_8,(a0)+
	move.l    #dmofile_9,(a0)+
	move.l    #dmofile_10,(a0)+
	move.l    #dmofile_11,(a0)+

	lea.l	ikbd_data(pc),a6
	moveq.s	#2,d0
	move.w	#$8001,(a6)             ; reset IKBD
	bsr.w	send_ikbd

loader_loop:

	bsr	cls_scr

	lea	TRACK_PALETTE,a0             ; Put palette
	lea	$ffff8240.w,a1               ;
	movem.l	(a0),d0-d7               ;
	movem.l	d0-d7,(a1)               ;

	movea.l	screen_base(pc),a0          ; Put Logo
	lea     160*(100-3)(a0),a0
	movea.l	#TRACK_LOGO,a1
	move.l	#160*5/4-1,d0
	move.l	(a1)+,(a0)+
	dbf	d0,*-2

	clr.l	$40.w                      ; Memory access to chosen file

	pea	null(pc)                     ; Load Menu
	pea	null(pc)
	pea	menufile(pc)
	clr.w	-(sp)
	move.w	#75,-(sp)
	trap	#1
	adda.l	#16,sp

	MOVEQ #$13,D0                    ; pause keyboard
	BSR Writeikbd                    ; (stop from sending)
	MOVEQ #$11,D0                    ; resume
	BSR Writeikbd
	bsr	flush

	bsr	Logo_display                 ; Display Logo

	move.l	$40.w,d0                 ; Récupère la touche renvoyé par le menu

	cmp.w	#1,d0                      ; Test ESCAPE to quit ?
	beq.w	exit

	cmp.w	#2,d0                      ; Test value
	blt.s	exit
	cmp.w	#11+1,d0
	bgt.s	exit

	lsl.w	#2,d0                      ; Seek right file
	lea	bufferfile,a0
	movea.l	0(a0,d0.w),a0

	pea	null                         ; Execute file (PEXEC)
	pea	null
	move.l	a0,-(sp)
	clr.w	-(sp)
	move.w	#75,-(sp)
	trap	#1
	adda.l	#16,sp

	lea       $ffff8800.w,a0         ; Cut sound
	move.l    #$8000000,(a0)
	move.l    #$9000000,(a0)
	move.l    #$a000000,(a0)

	bsr	set_low_rez

	bra.w	loader_loop

exit:
	move.b	old_484(pc),$484.w

	bsr	cls_scr

	bsr	restaure_original

	cmp.w	#0,detect_Falcon           ; Falcon part
	beq.s .no_Falcon_detected

	bsr	ULS_restore_launch_env
	bsr	Restore_Falcon_Video

.no_Falcon_detected:

	bsr	set_old_palette

	bsr	set_user

	move.w	#$0,-(sp)                ; return to gem desktop.
	trap	#1

***********************
* SUBROUTINES SECTION *
***********************

Logo_display:
	bsr	set_black_palette

	lea	IMAGE_LZ7,a0
	movea.l	screen_base(pc),a1
	jsr	d_lz77

	lea	PALETTE,a2
	bsr	fadeon	

	bsr	set_new_palette
	rts

******************************************
*                                        *
* Very! fast lz77 decompression routine  *
*                                        *
******************************************
 include "LZ77_130.ASM"

set_super:
	clr.l	-(sp)		;Set super stack equal
	move.w	#$20,-(sp)	; to user stack before call
	trap	#1
	addq.l	#6,sp		;correct stack
	move.l	d0,stack_save	;save old supervisor stack value
	rts

set_user:
	move.l	stack_save,-(sp)
	move.w	#$20,-(sp)
	trap	#1		;back to user
	addq.l	#6,sp		;correct stack
	rts

get_old_palette:
	move.w	#8-1,d0
	lea	$ff8240,a0
	lea	old_palette,a1
get_old:
	move.l	(a0)+,(a1)+
	dbf	d0,get_old
	rts

set_new_palette:
	lea	PALETTE,a0
	bra	set_pal
set_old_palette:
	lea	old_palette,a0
set_pal:
	lea	$ff8240,a1
	move.w	#8-1,d0
set_p:	move.l	(a0)+,(a1)+
	dbf	d0,set_p
	rts

get_original:
	move.w	#3,-(sp)
	trap	#14
	addq.l	#2,sp
	move.l	d0,screen_base

	move.w	#4,-(sp)
	trap	#14
	addq.l	#2,sp
	move.w	d0,original_rez
	rts

restaure_original:
	move	original_rez,-(sp)         ; Restore Old Screen & Resolution
	move.l	screen_base,-(sp)        ;
	move.l	(sp),-(sp)               ;
	move	#5,-(sp)                   ;
	trap	#14                        ;
	lea	12(sp),sp                    ;

	move.w	#$25,-(a7)               ; VSYNC()
	trap	#14                        ;
	addq.w	#2,a7                    ;
	rts

set_low_rez:
	clr.w	-(sp)
	bra	set_rez
set_med_rez:
	move.w	#1,-(sp)
set_rez:
	move.l	#-1,-(sp)
	move.l	#-1,-(sp)
	move.w	#5,-(sp)
	trap	#14
	add.l	#12,sp
	rts

set_black_palette:
	lea	black_palette,a0
	lea	$ffff8240.w,a1
	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)
	rts

fadeon:
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
	rept	6-5
	bsr	wart
	endr
	dbra	d0,.loop1	Next stage
	rts

wart:	move.l	d0,-(sp)
	move.l	$466.w,d0
.att:	cmp.l	$466.w,d0
	beq.s	.att
	move.l	(sp)+,d0
	rts

flush:                             ; Flush IKBD
	btst.b #0,$fffffc00.w            ; any waiting?
	beq.s .flok                      ; exit if none waiting.
	move.b $fffffc02.w,d0            ; get next in queue
	bra.s flush                      ; and continue
.flok:
	rts

Writeikbd:                         ; Write d0 to IKBD
	btst.b #1,$fffffc00.w
	beq.s Writeikbd                  ; wait for ready
	move.b d0,$fffffc02.w            ; and send...
	rts

cls_scr:
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
	movea.l	screen_base,a0
	add.l	#32000,a0
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

send_ikbd:
	lea.l	$fffffc00.w,a0
	lea.l	ikbd_data(pc),a1
.waitkey:
	btst	#1,(a0)
	beq.s	.waitkey
	move.b	(a1)+,2(a0)
	subq.w	#1,d0
	bne.s	.waitkey
	rts

	SECTION	DATA

old_484:
	ds.b	1
	even
null:
	ds.l	1

menufile:
	dc.b	'EXTRA_V3.PRG',0
	even
dmofile_1:
	dc.b	'DNTP.PRG',0
dmofile_2:
	dc.b	'INTRO14.PRG',0
dmofile_3:
	dc.b	'PREVIEW.PRG',0
dmofile_4:
	dc.b	'RAYTRACE.PRG',0
dmofile_5:
	dc.b	'SHOOT61.PRG',0
dmofile_6:
	dc.b	'SO_LAME.PRG',0
dmofile_7:
	dc.b	'TRACK.PRG',0
dmofile_8:
	dc.b	'ZOOMER.PRG',0
dmofile_9:
	dc.b	'INT_CP1.PRG',0
dmofile_10:
	dc.b	'MINES3.PRG',0
dmofile_11:
	dc.b	'AQABOOT.PRG',0
	even
bufferfile:
	dcb.w	40

stack_save:
	dc.l	0
screen_base:
	dc.l	0
original_rez:
	dc.w	0
black_palette:
	dcb.w	16,0
PALETTE:
	dc.w	$0000,$0311,$0421,$0532,$0643,$0754,$0765,$0776
	dc.w	$0001,$0112,$0223,$0334,$0445,$0556,$0667,$0777
TRACK_PALETTE:
	dc.w	$0112,$0DFD,$04DF,$0F00,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
TRACK_LOGO:
	incbin	"LOADING.IMG"
	even
IMAGE_LZ7:
	incbin	"SPS_SO.LZ7"
	even

	SECTION BSS

old_palette:
	ds.w	16
ikbd_data:
	ds.l	16/4

	EVEN

	SECTION TEXT

***************************************************************************
*                                                                         *
* Multi Atari Boot code ST, STe, Mega-ST,TT,Falcon,CT60                   *
* by Zorro 2 (17/03/2012)                                                 *
***************************************************************************
MAXCOOKIE       EQU 128            ; Maximum cookie entries to search     *
DISPLAY_MESSAGE EQU 0              ; Affiche le message                   *
ATTENTE_M       EQU 50*1           ; Attente du message                   *
***************************************************************************
Multi_boot:
	move.l	$5a0.w,d0                ; Check Cookies
	beq	.stf                         ; STF ?
	move.l	d0,a0
	moveq	#MAXCOOKIE-1,d7
.search_mch:
	tst.l	(a0)
	beq	.stf                         ; Null termination of cookiejar, no _MCH found = ST
	cmp.l	#"_MCH",(a0)
	beq.s	.mch_found
	addq.l	#8,a0
	dbra	d7,.search_mch
	bra	.stf                         ; Default to STF machine

.mch_found:
	move.l	4(a0),d0
	cmp.l	#$00010000,d0              ; STE ?
	beq.s	.ste
	cmp.l	#$00010010,d0              ; Mega STE ?
	beq.s	.megaste
	cmp.l	#$00020000,d0              ; TT
	beq.s	.tt
	cmp.l	#$00030000,d0              ; Falcon ?
	beq	.falcon

* --------------------------------------------------------->
 IFEQ	DISPLAY_MESSAGE
	move.l	#text_NOTST_mode,d0       ; Display mode compatible
	bsr	print                         ; Display sentence
	move    #ATTENTE_M,d7             ; Wait a while...
	bsr     wait_more
 ENDC
* <---------------------------------------------------------
	bra.w	.suite

.megaste:
* --------------------------------------------------------->
 IFEQ	DISPLAY_MESSAGE
	move.l	#text_MSTE_mode,d0       ; Display mode compatible
	bsr	print                        ; Display sentence
	move    #ATTENTE_M,d7            ; Wait a while...
	bsr     wait_more
 ENDC
* <---------------------------------------------------------
	move.w	#$ffff8e21,a0
	clr.b	(a0)                       ; MSTE at 8 Mhz, cache off

.ste:
* --------------------------------------------------------->
 IFEQ	DISPLAY_MESSAGE
	move.l	#text_STE_mode,d0        ; Display mode compatible
	bsr	print                        ; Display sentence
	move    #ATTENTE_M,d7            ; Wait a while...
	bsr     wait_more
 ENDC
* <---------------------------------------------------------

	; Reset Blitter
	clr.b	$ffff8264.w                ; Hscroll
	clr.b	$ffff820f.w                ; Linewid

	bra.w	.suite

.tt:
* --------------------------------------------------------->
 IFEQ	DISPLAY_MESSAGE
	move.l	#text_TT_mode,d0         ; Display mode compatible
	bsr	print                        ; Display sentence
	move    #ATTENTE_M,d7            ; Wait a while...
	bsr     wait_more
 ENDC
* <---------------------------------------------------------

	bra.w	.suite

.stf:
* --------------------------------------------------------->
 IFEQ	DISPLAY_MESSAGE
	move.l	#text_STF_mode,d0        ; Display mode compatible
	bsr	print                        ; Display sentence
	move    #ATTENTE_M,d7            ; Wait a while...
	bsr     wait_more
 ENDC
* <---------------------------------------------------------

.suite:

	clr.b	$ffff8260.w                ; St low resolution
	or.b	#2,$ffff820a.w             ; 50 Hz

	move.w $468.w,d0
.vsync:
	cmp.w $468.w,d0
	beq.s .vsync

	bra.w	.end_video

.falcon:
* --------------------------------------------------------->
 IFEQ	DISPLAY_MESSAGE
	move.l	#text_FALCON_mode,d0     ; Display mode compatible
	bsr	print                        ; Display sentence
	move    #ATTENTE_M,d7            ; Wait a while...
	bsr     wait_more
 ENDC
* <---------------------------------------------------------
	move.w	#$0FFF,detect_Falcon     ; Falcon Detected

	clr.l	$44.w                      ; Indication for Menu
	move.l	#$12345678,$44.w         ;

	bsr	Save_Falcon_Video            ; Save video configuration

	bsr	ULS_init_launch_env          ; ULS improvements

	move.w	#$59,-(sp)               ; Check RGB/TV/VGA
	trap	#14                        ;
	addq.l	#2,sp                    ;

	cmp.w	#1,d0                      ; 1 = RGB
	beq.s	rgb50                      ;
	cmp.w	#3,d0                      ; 3 = TV
	beq.s	rgb50                      ;
	bra	vga50                        ; Otherwise assume VGA
.end_video:
	rts

rgb50:
* --------------------------------------------------------->
 IFEQ	DISPLAY_MESSAGE
	move.l	#text_falcon_mode_RGB,d0 ; Display mode compatible Falcon
	bsr	print                        ; Display sentence
	move    #ATTENTE_M,d7            ; Wait a while...
	bsr     wait_more
 ENDC
* <---------------------------------------------------------
	move.l	#$300027,$ffff8282.w     ; Falcon 50Hz RGB
	move.l	#$70229,$ffff8286.w      ;
	move.l	#$1e002a,$ffff828a.w     ;
	move.l	#$2710265,$ffff82a2.w    ;
	move.l	#$2f0081,$ffff82a6.w     ;
	move.l	#$211026b,$ffff82aa.w    ;
	move.w	#$200,$ffff820a.w        ;
	move.w	#$185,$ffff82c0.w        ;
	clr.w	$ffff8266.w                ;
	clr.b	$ffff8260.w                ;
	clr.w	$ffff82c2.w                ;
	move.w	#$50,$ffff8210.w         ;
	rts

vga50:
* --------------------------------------------------------->
 IFEQ	DISPLAY_MESSAGE
	move.l	#text_falcon_mode_VGA,d0 ; Display mode compatible Falcon
	bsr	print                        ; Display sentence
	move    #ATTENTE_M,d7            ; Wait a while...
	bsr     wait_more
 ENDC
* <---------------------------------------------------------
	move.l	#$170011,$ffff8282.w     ; Falcon 50Hz VGA
	move.l	#$2020e,$ffff8286.w      ;
	move.l	#$d0012,$ffff828a.w      ;
	move.l	#$4eb04d1,$ffff82a2.w    ;
	move.l	#$3f00f5,$ffff82a6.w     ;
	move.l	#$41504e7,$ffff82aa.w    ;
	move.w	#$200,$ffff820a.w        ;
	move.w	#$186,$ffff82c0.w        ;
	clr.w	$ffff8266.w                ;
	clr.b	$ffff8260.w                ;
	move.w	#$5,$ffff82c2.w          ;
	move.w	#$50,$ffff8210.w         ;
	rts

 IFEQ	DISPLAY_MESSAGE
print:                             ; d0.l address to null terminated string
	move.l	d0,-(sp)                 ; cconws()
	move.w	#$9,-(sp)                ;
	trap	#1                         ;
	addq.l	#6,sp                    ;
	rts
 ENDC

Save_Falcon_Video:
	lea.l	save_videl(pc),a0          ;
	move.l	$ffff8200.w,(a0)+        ; VIDHM
	move.w	$ffff820c.w,(a0)+        ; VIDL
	move.l	$ffff8282.w,(a0)+        ; H-REGS
	move.l	$ffff8286.w,(a0)+        ;
	move.l	$ffff828a.w,(a0)+        ;
	move.l	$ffff82a2.w,(a0)+        ; V-REGS
	move.l	$ffff82a6.w,(a0)+        ;
	move.l	$ffff82aa.w,(a0)+        ;
	move.w	$ffff82c0.w,(a0)+        ; VCO
	move.w	$ffff82c2.w,(a0)+        ; C_S
	move.l	$ffff820e.w,(a0)+        ; OFFSET
	move.w	$ffff820a.w,(a0)+        ; SYNC
	move.b  $ffff8256.w,(a0)+        ; P_O
	clr.b   (a0)                     ; ST(E) OR FALCON MODE?
	cmp.w   #$b0,$ffff8282.w         ; HHT LOWER $B0?
	sle     (a0)+                    ; SET FLAG
	move.w	$ffff8266.w,(a0)+        ; F_S
	move.w	$ffff8260.w,(a0)+        ; ST_S
	rts

Restore_Falcon_Video:
	clr.w   $ffff8266.w              ; FALCON-SHIFT CLEAR
	lea.l	save_videl(pc),a0          ;
	move.l	(a0)+,$ffff8200.w        ; VIDEOBASE_ADDRESS:H&M
	move.w	(a0)+,$ffff820c.w        ; L
	move.l	(a0)+,$ffff8282.w        ; H-REGS
	move.l	(a0)+,$ffff8286.w        ;
	move.l	(a0)+,$ffff828a.w        ;
	move.l	(a0)+,$ffff82a2.w        ; V-REGS
	move.l	(a0)+,$ffff82a6.w        ;
	move.l	(a0)+,$ffff82aa.w        ;
	move.w	(a0)+,$ffff82c0.w        ; VCO
	move.w	(a0)+,$ffff82c2.w        ; C_S
	move.l	(a0)+,$ffff820e.w        ; OFFSET
	move.w	(a0)+,$ffff820a.w        ; SYNC
	move.b  (a0)+,$ffff8256.w        ; P_O
	tst.b   (a0)+                    ; ST(E) COMPTAIBLE MODE?
	bne.s   .ok                      ;
	move.w  (a0),$ffff8266.w         ; FALCON-SHIFT
	bra.s	.video_done
.ok:
	move.w  2(a0),$ffff8260.w        ; ST-SHIFT
	lea.l	save_videl(pc),a0          ;
	move.w	32(a0),$ffff82c2.w       ; C_S
	move.l	34(a0),$ffff820e.w       ; offset
.video_done:
	rts

wait_more:
	move.w	#$25,-(a7)               ; VSYNC()
	trap	#14                        ;
	addq.w	#2,a7                    ;
	dbra	d7,wait_more
	rts

ULS_restore_launch_env:
	lea SYS_PSG(pc),a0               ; restore psg
	bsr load_PSG

	lea	SYS_VBR(pc),a0
	dc.l	$f0104c00                  ; pmove (a0),VBR *restore VBR*

	lea 	uls_cpus(pc),a1            ; Restore its APPLICATION its state
	move.b	(a1),$ffff8007.w

	moveq   #0,D0
	DC.L $4E7B0801                   ; MOVEC     D0,VBR     Vektorbase=0 (eigentlich Standard)

	lea	SYS_PMMU(pc),a0              ; restore tc/tt0/tt1
	dc.w	$f028,$4000,$0000          ; pmove (a0),tc
	dc.w	$f028,$0800,$0004          ; pmove 4(a0),tt0
	dc.w	$f028,$0c00,$0008          ; pmove 8(a0),tt1

	lea 	pmmu_save(pc),a0           ; On remet l'arbre de la PMMU en place
	lea 	$700.l,a1
	move.w	#100-1,d0
.copy_pmmu:
	move.b	(a0)+,(a1)+
	dbf	d0,.copy_pmmu

	lea 	pmmu_reg(pc),a0            ; restaure sa position
	dc.l	$f0104c00                  ; pmove.d	(a0),crp

	lea	SYS_cacr(pc),a0              ; restore cache
	move.l	(a0),d0
	dc.l	$4e7b0002                  ; movec d0,cacr
	rts

ULS_init_launch_env:
	move    SR,-(a7)
	move    #$2700,SR

	lea SYS_PSG(pc),a0               ; save PSG
	bsr save_PSG

	lea SYS_VBR(pc),a0               ; save VBR
	dc.l $f0104e00                   ; pmove vbr,(a0) (Get VBR address)

	lea uls_cpus(pc),a0
	move.b $ffff8007.w,(a0)          ; store current CPU state
	lea 	sys_FCPUC(pc),a0           ; restore CPU mode
	move.b (a0),d0
	or.b #%00100101,d0
	move.b 	d0,$ffff8007.w

	lea 	pmmu_save(pc),a0           ; On met l'arbre de la PMMU hors de danger 
	lea 	$700.l,a1
	move.l	a1,d7
	move.w	#100-1,d0
.save_pmmu:
	move.b	(a1)+,(a0)+
	dbf	d0,.save_pmmu

	lea 	pmmu_reg(pc),a0
	dc.l	$f0104e00                  ; pmove.d	crp,(a0)
	move.l	d7,4(a0)
	dc.l	$f0104c00                  ; pmove.d	(a0),crp

	lea	SYS_PMMU(pc),a0              ; save TC/TT0/TT1
	dc.w	$f028,$4200,$0000          ; pmove tc,(a0)
	dc.w	$f028,$0a00,$0004          ; pmove tt0,4(a0)
	dc.w	$f028,$0e00,$0008          ; pmove tt1,8(a0)

	lea     pmmu_table(PC),A0
	lea	run_tc+4(pc),a1
	move.l  A0,(A1)                  ; TC_access+4
	move.l  A0,8(A1)                 ; TT0_access+4
	move.l  A0,16(A1)                ; TT1_access+4
	lea     TC_access+4(PC),A1
	move.l  A0,(A1)                  ; TC_access+4
	move.l  A0,8(A1)                 ; TT0_access+4
	move.l  A0,16(A1)                ; TT1_access+4

* Détourne la $10.w

	movea.l $00000010.w,A6
	pea     no_cacr(PC)              ; disable CACHE
	move.l  (a7)+,$00000010.w
	moveq   #0,D0
	DC.L $4E7A0002                   ; movec cacr,d0
	lea     SYS_cacr(PC),A5          ; Save cache state
	move.l  D0,(A5)
 	moveq   #0,D0
nop_me_out:
	DC.L $4E7B0002                   ; movec d0,cacr
no_cacr:
 	nop
	pea     no_pmmu(PC)              ; move the PMMU
	move.l  (a7)+,$00000010.w
	moveq   #0,D0
	DC.L $4E7B0801                   ; MOVEC     D0,VBR     Vektorbase=0 (eigentlich Standard)
TC_access:
	DC.L $F0394000,$DEADF030         ; PMOVE     pmmu_tab,TC
TT0_access:
	DC.L $F0390800,$DEADF030         ; PMOVE     pmmu_tab,TT0
TT1_access:
	DC.L $F0390C00,$DEADF030         ; PMOVE     pmmu_tab,TT1
no_pmmu:
	nop
	move.l  A6,$00000010.w           ; restore old $10

* Détourne la $08.w

	movea.l $00000008.w,A6
	pea     no_f030_proc_control(PC)
	move.l  (a7)+,$00000008.w
	lea     $FFFF8007.w,A0           ; Falcon Processor Control
	move.b  (A0),D0
	lea 	sys_FCPUC(pc),a1           ; Save its state
	move.b	d0,(a1)                  ;
	bclr    #5,D0                    ; STe Bus Emulation  ON
	bclr    #2,D0                    ; Blitter Speed      8 MHz
	move.b  D0,(A0)                  ;
no_f030_proc_control:
	nop
	move.l  A6,$00000008.w           ; restore old $8

	move    (a7)+,SR
	rts

load_PSG:
	lea $ffff8800.w,a5              ; (Restore from A0)
	move.b #14,(a5)
	move.b (a0)+,d0
	bclr #7,d0                       ; enable falcon IDE
	move.b d0,2(a5)
	move.b #15,(a5)
	move.b (a0),2(a5)
	rts

save_PSG:
	lea $ffff8800.w,a5               ; (Save to a0)
	move.b #14,(a5)
	move.b (a5),(a0)+
	move.b #15,(a5)
	move.b (a5),(a0)
	rts

	EVEN

 IFEQ	DISPLAY_MESSAGE
text_falcon_mode_RGB:
	dc.b	"Video detected : mode RGB 50 Hz setup.",13,10,0
	even
text_falcon_mode_VGA:
	dc.b	"Video detected : mode VGA 50 Hz setup.",13,10,0
	even
text_MSTE_mode:
	dc.b	"Atari MEGA STE detected : mode compatible setup.",13,10,0
	even
text_STE_mode:
	dc.b	"Atari STE detected : mode standard setup.",13,10,0
	even
text_STF_mode:
	dc.b	"Atari STF detected : mode standard setup.",13,10,0
	even
text_FALCON_mode:
	dc.b	"Atari FALCON detected : mode compatible setup.",13,10,0
	even
text_TT_mode:
	dc.b	"Atari TT detected.",13,10,0
	even
text_NOTST_mode:
	dc.b	"Atari computer not detected.",13,10,0
	even
 ENDC

detect_Falcon:
	dc.w	$0
save_videl:
	ds.w	23
pmmu_save:
	dcb.b	$200
pmmu_reg:
	dc.l	$0
	dc.l	$0
sys_FCPUC:
	ds.w 1                           ; Falcon CPU Control
SYS_VBR:
	ds.l 2                           ; location of original VBR
SYS_PMMU:
	ds.l 3                           ; state of tc/tt0/tt1 MMU registers
SYS_cacr:
	ds.l 1                           ; state of cache control register before init
SYS_PSG:
	ds.w 1                           ; psg on init (ffff8800 Port a/b)
uls_cpus:
	ds.w 1
run_tc:
	dc.l $F0394000,$DEADF030         ; PMOVE     pmmu_tab,TC
	dc.l $F0390800,$DEADF030         ; PMOVE     pmmu_tab,TT0
	dc.l $F0390C00,$DEADF030         ; PMOVE     pmmu_tab,TT1
pmmu_table:
	DCB.W     4,0                    ; F030 StartUp(boot) PMMU Table
	DC.B      $79,$FF,$3C,$00,$00,$00,$00,$00 
	DCB.W     2,0 
	DC.B      $79,$FF,$3C,$00,$00,$00,$00,$00 
	DCB.W     2,0 
	DC.B      $79,$FF,$3C,$00,$00,$00,$00,$00 
	DCB.W     2,0 
	DC.B      $79,$FF,$3C,$00,$00,$00,$00,$00 
	DCB.W     2,0 
	DC.B      $79,$FF,$3C,$00,$00,$00,$00,$00 
	DCB.W     2,0 
	DC.B      $79,$FF,$3C,$00,$00,$00,$00,$00 
	DCB.W     2,0 
	DC.B      $79,$FF,$3C,$00,$00,$00,$00,$00 
	DCB.W     2,0 
	DC.B      $79,$FF,$3C,$00,$00,$00,$00,$00 
	DCB.W     2,0 
	DC.B      $79,$FF,$3C,$00,$00,$00,$00,$00 
	DCB.W     2,0 
	DC.B      $79,$FF,$3C,$00,$00,$00,$00,$00 
	DCB.W     2,0 
	DC.B      $79,$FF,$3C,$00,$00,$00,$00,$00 
	DCB.W     2,0 
	DC.B      $79,$FF,$3C,$00,$00,$00,$00,$00 
	DCB.W     2,0 
	DC.B      $79,$FF,$3C,$00,$00,$00,$00,$00 
	DCB.W     2,0 
	DC.B      $79,$FF,$3C,$00,$00,$00,$00,$00 
	DCB.W     2,0 
	DC.B      $79,$FF,$3C,$00,$00,$00,$00,$00 
	DCB.W     2,0 
	DC.B      $79,$FF,$3C,$00,$00,$00,$00,$00 
	DCB.W     2,0 
	DC.B      $F9,$FF,$3E,$00,$00,$00,$00,$00 
	DCB.W     2,0 
	DC.B      $F9,$FF,$3E,$00,$00,$00,$00,$00 
	DCB.W     2,0 
	DC.B      $F9,$FF,$3E,$00,$00,$00,$00,$00 
	DCB.W     2,0 
	DC.B      $F9,$FF,$3E,$00,$00,$00,$00,$00 
	DCB.W     2,0 
	DC.B      $F9,$FF,$3E,$00,$00,$00,$00,$00

	EVEN
  
	END