**************************************
* Loader double "pexec 0" (boucle)   *
* Touches "0" & "1" + test en $40.w  *
* 02/11/2009 - For Freddo by Maartau *
* 14/02/2013 - Modified by Zorro 2   *
**************************************

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
	DC.B	"...LOADER BY MAARTAU AND ZORRO 2 IN 2009 AND 2012... "
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

	lea	LOGO_INTRO_Palette,a0
	bsr	set_new_palette

	movea.l	screen_base(pc),a1       ; Copy Logo Intro
	adda.l	#160*((200-67)/2),a1
	movea.l	#LOGO_INTRO_Img,a0
	move.l	#160*67/4-1,d0
	move.l	(a0)+,(a1)+
	dbf	d0,*-2

	move.w	#100,d7                  ; Attente...
.display_logo:
	bsr	wart
	dbra	d7,.display_logo

	lea	$484.w,a3                    ; Cut "Bip"
	move.b	(a3),old_484
	clr.b	(a3)

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
	move.l    #dmofile_12,(a0)+
	move.l    #dmofile_13,(a0)+

	lea.l	ikbd_data(pc),a6
	moveq.s	#2,d0
	move.w	#$8001,(a6)              ; reset IKBD
	bsr.w	send_ikbd

loader_loop:

	bsr	cls_scr                      ; Fast CLS

	lea	LOAD_Palette,a0
	bsr	set_new_palette

	movea.l	screen_base(pc),a0       ; Put LOADING Logo
	lea     160*((200-5)/2)(a0),a0
	movea.l	#LOAD_Img,a1
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

	lea	LOAD_Palette,a0
	bsr	set_new_palette

	movea.l	screen_base(pc),a0       ; Put LOADING Logo
	lea     160*((200-5)/2)(a0),a0
	movea.l	#LOAD_Img,a1
	move.l	#160*5/4-1,d0
	move.l	(a1)+,(a0)+
	dbf	d0,*-2

	MOVEQ #$13,D0                    ; pause keyboard
	BSR Writeikbd                    ; (stop from sending)
	MOVEQ #$11,D0                    ; resume
	BSR Writeikbd
	bsr	flush

	move.l	$40.w,d0                 ; Récupère la touche renvoyé par le menu

	cmp.w	#1,d0                      ; Test ESCAPE to quit ?
	beq.w	exit

	cmp.w	#2,d0                      ; Test value
	blt	exit
	cmp.w	#14,d0
	bgt	exit

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

	move.l	d0,-(sp)
	bsr	cls_scr                      ; Fast CLS
	move.l	(sp)+,d0

	tst.l	d0                         ; Erreur ?
	beq.s	no_error

error:
	lea	ERROR_Palette,a0
	bsr	set_new_palette

	movea.l	screen_base(pc),a0       ; Put ERROR Logo
	lea     160*((200-5)/2)(a0),a0
	movea.l	#ERROR_Img,a1
	move.l	#160*5/4-1,d0
	move.l	(a1)+,(a0)+
	dbf	d0,*-2

	move.w	#100,d7                  ; Attente...
.wait_more:
	bsr	wart
	dbra	d7,.wait_more

	bsr.s	boucle

no_error:
	lea	LOAD_Palette,a0
	bsr	set_new_palette

	movea.l	screen_base(pc),a0       ; Put LOADING Logo
	lea     160*((200-5)/2)(a0),a0
	movea.l	#LOAD_Img,a1
	move.l	#160*5/4-1,d0
	move.l	(a1)+,(a0)+
	dbf	d0,*-2

boucle:
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
	bsr	set_old_palette
	bsr	set_user

	move.w	#$0,-(sp)	; return to gem desktop.
	trap	#1

	* FIN *

wart:
	move.l	d0,-(sp)
	move.l	$466.w,d0
.att:	cmp.l	$466.w,d0
	beq.s	.att
	move.l	(sp)+,d0
	rts

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

flush:                             ; Flush IKBD
	BTST.B #0,$FFFFFC00.W            ; any waiting?
	BEQ.S .flok                      ; exit if none waiting.
	MOVE.B $FFFFFC02.W,D0            ; get next in queue
	BRA.S flush                      ; and continue
.flok:
	RTS

Writeikbd:                         ; Write d0 to IKBD
	BTST.B #1,$FFFFFC00.W            ;
	BEQ.S Writeikbd                  ; wait for ready
	MOVE.B D0,$FFFFFC02.W            ; and send...
	RTS

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
	ds.w	1
null:
	ds.l	1

menufile:
	dc.b	'EXTRA_V4.PRG',0
dmofile_1:
	dc.b	'AW.PRG',0
dmofile_2:
	dc.b	'FUZION.PRG',0
dmofile_3:
	dc.b	'INTRO.PRG',0
dmofile_4:
	dc.b	'INVIZI.PRG',0
dmofile_5:
	dc.b	'MC3.PRG',0
dmofile_6:
	dc.b	'MJJ.PRG',0
dmofile_7:
	dc.b	'RADIATIO.PRG',0
dmofile_8:
	dc.b	'REPS-PUL.PRG',0
dmofile_9:
	dc.b	'SCREEN.PRG',0
dmofile_10:
	dc.b	'SPHERICA.PRG',0
dmofile_11:
	dc.b	'STKPHAL.PRG',0
dmofile_12:
	dc.b	'TTZP.PRG',0
dmofile_13:
	dc.b	'AW.PRG',0
	even
bufferfile:
	dcb.w	15*4

stack_save:
	dc.l	$0
screen_base:
	dc.l	$0
original_rez:
	dc.w	$0

LOAD_Palette:
	dc.w	$0801,$0801,$0c1e,$0801,$0801,$0801,$0801,$0801
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
LOAD_Img:
	incbin	"LOAD.IMG"
	even
ERROR_Palette:
	dc.w	$0FFF,$0000,$0000,$0f00,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
ERROR_Img:
	incbin	"ERROR.IMG"
	even

***>
LOGO_INTRO_Palette:
	dc.w	$0000,$0011,$0210,$0122,$0321,$0233,$0432,$0531
	dc.w	$0344,$0543,$0642,$0455,$0654,$0753,$0764,$0777
LOGO_INTRO_Img:
	incbin	"NOEXTR2A.IMG"	;	Logo 67*200
	even
***<

	SECTION BSS

old_palette:
	ds.w	16
ikbd_data:
	ds.l	16/4

	END