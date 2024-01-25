;**********************************************************************************************
;HALL OF FAME
;MYSCHOOL IS OLD
;NOTHING TO SHARE, ONLY SHIT HERE
;A LOT OF BUG UNDER LOGO DOWN AND UP AFTER STOP MOVING
;**********************************************************************************************

;**********************************************************************************************
demo             equ 0             ; Mettre � "1" pour la compilation finale !                *
SEEMYVBL         equ 1             ; Voit la VBL avec ALT, � "1" pour la compilation finale ! *
BLITTER          equ 1             ; Sync effect with Blitter                                 *
DEBUG            equ 1             ; See more visual informations                             *
*************************** PARAMETERS ********************************************************
BETTER_VIEW      equ 0             ; Permit Timers !                                          *
SYNCHRO_WAIT     equ $900          ; Adresse de la synchro                                    *
HEIGHT           equ 300           ; of screen...                                             *
SIZE_OF_SCREEN   equ 160*HEIGHT    ; Only Screen size in Low Resolution                       *
; *********************************************************************************************

***************************************
  OPT d- ; Debug OFF                  *
  OPT o- ; All optimisations OFF      *
  OPT w- ; Warnings OFF               *
  OPT x- ; Extended debug OFF         *
***************************************

 ifeq demo
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
	lea    12(sp),sp                ;
	clr.l	-(a7)		;Super mode
	move.w	#$20,-(a7)
	trap	#1
	addq.l	#6,a7
	clr -(sp)
	pea $ffffffff.w
	pea $ffffffff.w
	move #5,-(sp)
	trap #14
	lea   12(sp),sp
	move #37,-(sp)
	trap #14
	addq.l #2,sp
 endc

 IFEQ BLITTER
Sync_Blit macro                    ; Macro must be used with blitter effect outside the VBL for synchronisations
.wait_blitter:                     ; Fast Blitter Reboot
	bset	#7,$ffff8a3c.w
	nop
	bne.s	.wait_blitter
	endm

	move.w	#$80,$ffff8a3c.w         ; Launch Blitter !
	nop
restart:
	bset	#7,$ffff8a3c.w
	nop
	bne.s	restart
 ENDC

	bsr	clear_bss                    ; Clean BSS stack

 IFEQ BLITTER
	move	$ffff8264.w,Old_Shift+2    ; Save Screen Shifting
	move	$ffff820e.w,Old_Modulo+2   ; Save Screen Modulo
 ENDC
	
	lea         resolution,a0
	move.b      $FFFF8260.W,(a0)
	lea         hardste_B3,a0
	move.l      $FFFF8200.W,(a0)
	lea         hardste_B4,a0
	move.b      $FFFF8205.W,(a0) ; video registers hi byte
	lea         hardste_B5,a0
	move.b      $FFFF8207.W,(a0) ; mid byte
	lea         hardste_B7,a0
	move.b      $FFFF8209.W,(a0) ; lo byte
	lea         hardste_B8,a0
	move.b      $FFFF8265.W,(a0) ; HSCROLL
	lea         hardste_B6,a0
	move.b      $FFFF820F.W,(a0) ; LINEWID
	lea         hardste_BC,a0
	move.b      $FFFF820D.W,(a0)

initialisations:
	move.l      sp,oldsp
	move        #$2700,SR                   ; Interrupts OFF
 IFEQ	BETTER_VIEW
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
	clr.b	$fffffa07.w                ; Interrupt enable A (Timer-A & B)
	clr.b	$fffffa09.w                ; Interrupt enable B (Timer-C & D)
	clr.b	$fffffa13.w                ; Interrupt mask A (Timer-A & B)
	clr.b	$fffffa15.w                ; Interrupt mask B (Timer-C & D)
	clr.b	$fffffa19.w                ; Stop Timer A
	clr.b	$fffffa1b.w                ; Stop Timer B
	clr.b	$fffffa21.w                ; Timer B data at zero
	clr.b	$fffffa1d.w                ; Stop Timer C & D
*
	lea	Palette,a0                  ; Save adresses parameters
	movem.l	$ffff8240.w,d0-d7        ; Save palette GEM system
	movem.l	d0-d7,(a0)
*
	moveq #$11,d0                    ; Resume keyboard
	bsr	sendToKeyboard               ;
	moveq #$12,d0                    ; Kill mouse
	bsr	sendToKeyboard               ;
	bsr	flush                        ; Clear buffer keyboard
 ENDC
	move.l	$120.w,old_timerb ; Unusefull for a demo.
	move.l	$70.w,old_vbl	; I have to use my own Vbl.

	andi.b      #$DF,$FFFFFA09.W
	andi.b      #$FE,$FFFFFA07.W
	move.l      #hbl_end,$120.W 
	move.l      #null_vbl,$70.w	; A "null" vbl for the moment.
	stop	      #$2300

	bsr	black_out                  ; All palette colors to zero

	jsr	init_starsh 
    
	jsr	init_mscroll

	jsr	init_logo

.put_pictures:
      movea.l	LOG2,a1
      adda.w      #160*104,a1
      movea.l	#tcb,a0
      adda.w      #34,a0
      move.l	#8000,d0
.loop_lg2    
      move.l	(a0)+,(a1)+
      dbf	      d0,.loop_lg2

.ligne_1:
      lea         record,a0
      movea.l     LOG4,a1
      adda.w      #160*30,a1
			jsr	lz4_depack                   ; Depack!

.ligne_2:
      lea         space,a0
      movea.l	LOG4,a1
      adda.w      #160*53,a1
			jsr	lz4_depack                   ; Depack!
    
      move.l      #logo_HMD_col,choix_pal 
      move.l      #greetings_vbl,$70.w
      ori.b       #1,$FFFFFA07.W
      ori.b       #1,$FFFFFA13.W
   
      lea         logo_HMD_col,a0 
      MOVEM.l     (a0),d0-D7
      MOVEM.l     D0-d7,$FFFF8240.W 

      move.w      #1,cpt_logo
      move.w      #0,chg_halloffame
			move.l			#$0,$466.w

.init_music:
  move.l	#$0,$4d2.w	             ; No music routine !
	moveq	#1,d0                      ; Choice of the music (1 is default)
	jsr	MUSIC+0                      ; Init SNDH music
	move.l	#(MUSIC+8),$4d2.w        ; Play SNDH music to the VBL

; ************************************************************************

	ifeq demo
default_loop:
	elseif
effet_loop:
	endc

      bsr	      wait_vbl                     ; Waiting after the VBL

 IFEQ	SEEMYVBL
	move.l      Default_palette,$ffff8240.w	; init line of CPU
 ENDC

      move.w      chg_halloffame,d0
      cmp.w       #-1,d0 
      bne         end_tcb
      move.w      #0,chg_halloffame
      movea.l     LOG2,a0
    
      cmp.w       #1,cpt_logo
      bne.s       suite_logo
      movea.l     part_logo,a0
suite_logo
    
      cmp.w       #2,cpt_logo
      bne.s       suite_logo2
      movea.l     part_logo+4,a0
suite_logo2
    
      cmp.w       #3,cpt_logo
      bne.s       suite_logo3
    movea.l       part_logo+8,a0
suite_logo3
    
      cmp.w       #4,cpt_logo
      bne.s       suite_logo4
      movea.l     part_logo+12,a0
suite_logo4
    
      cmp.w       #5,cpt_logo
      bne.s       suite_logo5
      movea.l     part_logo+16,a0
suite_logo5
      cmp.w       #6,cpt_logo
       bne.s      suite_logo6
      movea.l     part_logo+20,a0
suite_logo6
      cmp.w       #7,cpt_logo
      bne.s       suite_logo7
      movea.l     part_logo+24,a0
suite_logo7
      cmp.w       #8,cpt_logo
      bne.s       suite_logo8
      movea.l     part_logo+28,a0
suite_logo8
      cmp.w       #9,cpt_logo
      bne.s       suite_logo9
      movea.l     part_logo+32,a0
suite_logo9
      cmp.w       #10,cpt_logo
      bne.s       suite_logo10
      movea.l     part_logo+36,a0
suite_logo10
      cmp.w       #11,cpt_logo
      bne.s       suite_logo11
      movea.l     part_logo+40,a0
suite_logo11
      cmp.w       #12,cpt_logo
      bne.s       suite_logo12
      movea.l     part_logo+44,a0
suite_logo12
      cmp.w       #13,cpt_logo
      bne.s       suite_logo13
      movea.l     part_logo+48,a0
suite_logo13
      movea.l     LOG2,a1
      adda.w      #160*104,a1
			jsr	lz4_depack                   ; Depack!
  
      cmp.w       #13,cpt_logo
      bne.s       zero_logo
      move.w      #1,cpt_logo
      bra.s       end_tcb
zero_logo:    
      add.w       #1,cpt_logo
end_tcb:

	ifeq demo
 IFEQ	SEEMYVBL
	cmp.b #$38,$fffffc02.w           ; ALT key pressed ?
	bne.s .next_key                  ;
	move.b	#7,$ffff8240.w           ; See the rest of CPU (pink color used)
.next_key:                         ;     
 ENDC
 	cmp.b	#$39,$fffffc02.w           ; SPACE key pressed ?
	bne	default_loop
	elseif
	sub.l   #1,SYNCHRO_SAVE
	cmpi.l  #0,SYNCHRO_SAVE
	bne.s	effet_loop
	endc

; ************************************************************************

	clr.b	      $fffffa1b.w                ; Stop Timer B
	move.l	old_timerb,$120.w ; Restore old timerC rout.
	move.l	old_vbl,$70.w	; Restore the Vbl.
  ;bsr     fade_out

.stop_music:
	jsr	MUSIC+4                      ; End SNDH music
  clr.l	$4d2.w	                   ; No music routine !
	lea       $ffff8800.w,a0         ; Cut sound
	move.l    #$8000000,(a0)         ; Voice A
	move.l    #$9000000,(a0)         ; Voice B
	move.l    #$a000000,(a0)         ; Voice C

 IFEQ BLITTER
Old_Modulo:
	move	#0,$ffff820e.w             ; Restore Screen Modulo
Old_Shift:
	move	#0,$ffff8264.w             ; Restore Old Shift
 ENDC

	move.l      hardste_B3,$FFFF8200.W 
	move.b      hardste_B4,$FFFF8205.W 
	move.b      hardste_B5,$FFFF8207.W 
	move.b      hardste_B7,$FFFF8209.W 
	move.b      hardste_B8,$FFFF8265.W 
	move.b      hardste_B6,$FFFF820F.W 
	move.b      resolution,$FFFF8260.W 
	move.b      hardste_BC,$FFFF820D.W 
	
the_end:
 IFEQ	BETTER_VIEW
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
*
	lea	Palette,a0                  ; Restore adresses parameters
	movem.l	(a0),d0-d7               ; Restore palette GEM system
	movem.l	d0-d7,$ffff8240.w        ;
*
	moveq #$11,d0                    ; Resume keyboard
	bsr	sendToKeyboard               ;
	moveq #$8,d0                     ; Restore mouse
	bsr	sendToKeyboard               ;
	bsr	flush                        ; Clear buffer keyboard
 ENDC

	ifeq demo
	move.l	#$0FFF0F00,$ffff8240.w
	move.l	#$03FF0000,$ffff825E.w
	clr	-(a7)		;...EXIT...
	trap	#1
	endc
	move.l oldsp(pc),sp
	rts

oldsp:
	dc.l	0
 IFEQ	BETTER_VIEW
Save_all:
	ds.b	16 * MFP
Palette:
	ds.w 16 * Palette System
 ENDC
old_timerb:
  ds.l	1
old_vbl:		; All the parameters for screen,
  ds.l	1	; and interrupts...
	even
	
; ************************************************************************

greetings_vbl:
 IFEQ BLITTER
.sync_blitter:                     ; Sync Blitter with effect
	bclr.b	#7,$ffff8a3c.w
	nop
	btst.b	#7,$ffff8a3c.w
	bne.s	.sync_blitter
 ENDC
      addq.l	#$1,$466.w	; Increment _frclock.

      clr.b       $FFFFFA1B.W 
      move.b      #1,$FFFFFA21.W
      move.b      #8,$FFFFFA1B.W
      move.l      #hbl_line_h,$120.W 

      movem.l     a0-a6/d0-d7,-(a7)
      jsr         move_logo
      jsr         do_starsh 
      movem.l     (a7)+,a0-a6/d0-D7  

*---------------------------------->
      cmp.l	      #$0,$4d2.w	; A music routine?
      beq.s	      .no_music
.music:		; Yes, so execute it.
      move.l	a0,-(sp)
      move.l	$4d2.w,a0
      jsr	      (a0)
      move.l	(sp)+,a0
.no_music:
*----------------------------------<

      movem.l     a0-a6/d0-d7,-(a7)
			cmpi.b      #0,mvt_wave_logo
      beq.s       .no_wave
      jsr         do_wave 
.no_wave:jsr         mscroll
      movem.l     (a7)+,a0-a6/d0-D7  
 IFEQ BLITTER
	bset.b	#7,$ffff8a3c.w           ; Launch Blitter
	nop
 ENDC
      rte           

null_vbl:
      addq.l	#$1,$466.w	; Increment _frclock.
  
*---------------------------------->
      cmp.l	#$0,$4d2.w	; A music routine?
      beq.s	.no_music
.music:		; Yes, so execute it.
      move.l	a0,-(sp)
      move.l	$4d2.w,a0
      jsr	(a0)
      move.l	(sp)+,a0
.no_music:
*----------------------------------<
hbl_end:
      rte        

wait_vbl:
      move.w	d0,-(sp)
      move.w	$468.w,d0
.wait:cmp.w	$468.w,d0
      beq.s	.wait
      move.w	(sp)+,d0
      rts

; ************************************************************************

hbl_line_h:
      move.b      #0,$FFFFFA1B.W
      movem.l     a0-a2/d0-d1,-(a7) 
      movea.l     tab_two,a0
      lea         $FFFF8240.W,a1
      lea         $FFFFFA21.W,a2
      bclr        #0,-18(a2)
    
      move.l      #hbl_line_m,$120.W 
      move.b      #82,(a2) ;origine 139
      move.b      #8,-6(a2) 
      move.b      (a2),d0 
tst_line:
      cmp.b       (a2),d0 
      beq.s       tst_line 

	dcb.w 28,$4e71

.display_ligne_h:
 rept 37
      move.w      (a0)+,(a1)
 endr
      move.w      #0,(a1) 

      movea.l     choix_pal,a0           ; Put Default palette
			lea	      $ffff8240.w,a1               ;
      move.l    (a0)+,(a1)+
      move.l    (a0)+,(a1)+
      move.l    (a0)+,(a1)+
      move.l    (a0)+,(a1)+
      move.l    (a0)+,(a1)+
      move.l    (a0)+,(a1)+
      move.l    (a0)+,(a1)+
      move.l    (a0)+,(a1)+
      movem.l     (a7)+,a0-a2/d0-d1 
      addq.l      #2,tab_one
      cmpi.l      #couleur_three,tab_one
      bne.s       end_line 
      move.l      #couleur_two,tab_one
end_line:
      rte 

hbl_line_m:
      move.b      #0,$FFFFFA1B.W
      movem.l     a0-a2/d0-d1,-(a7)
      movea.l     tab_two,a0
      lea         $FFFF8240.W,a1
      lea         $FFFFFA21.W,a2
      bclr        #0,-18(a2)
      
      move.l      #hbl_line_b,$120.W 
      move.b      #54,(a2) 
  
      move.b      #8,-6(a2) 
      move.b      (a2),d0 
tst_line_m:
      cmp.b       (a2),d0 
      beq.s       tst_line_m 

	dcb.w 28,$4e71

.display_ligne_b:
 rept 40                      * Nbre de deplacement sur la ligne
      move.w      (a0)+,(a1)        * Met couleur degrades sur ligne
 endr 
      move.w      #0,(a1)

      move.b			LOG4+1,$FFFF8201.W  ; stars + scroll
      move.b			LOG4+2,$FFFF8203.W
      move.b      log4_scr_flg2B,$FFFF8265.W 
      move.b      log4_scr_flgB,$FFFF820F.W 
      movea.l     LOG4,a2

      move.l      hbl_cpt_mvt_stars,d0

      cmpi.b      #-1,mvt_hb_scroll_stars
      bne         hbl_suite_move_SCROLL_STARS

      subi.l      #160,d0

	dcb.w 60,$4e71

      BRA.s       display_scroll_stars 

hbl_suite_move_SCROLL_STARS:

      addi.l      #160,d0

	dcb.w 60,$4e71

display_scroll_stars:
      move.l      d0,hbl_cpt_mvt_stars
      
      lea         0(a2,d0.l),a2 
      move.l      a2,d0 
      move.b      d0,$FFFF8209.W
      LSR.W       #8,d0 
      move.b      d0,$FFFF8207.W
      swap        d0
      move.b      d0,$FFFF8205.W

      move.l      hbl_cpt_mvt_stars,d0

      cmp.l       #160*40,d0 
      bne.s       display_scroll_stars_colors 

      move.b      #-1,mvt_hb_scroll_stars
      
display_scroll_stars_colors:
      cmp.l       #0,d0 
      bne.s       hbl_fin_move2 

      move.b      #0,mvt_hb_scroll_stars
      
hbl_fin_move2: 
      lea   SCR_TXT_MILIEU,a0
			lea	$ffff8240.w,a1               ;
      move.l    (a0)+,(a1)+
      move.l    (a0)+,(a1)+
      move.l    (a0)+,(a1)+
      move.l    (a0)+,(a1)+
      move.l    (a0)+,(a1)+
      move.l    (a0)+,(a1)+
      move.l    (a0)+,(a1)+
      move.l    (a0)+,(a1)+
   
      jsr         flash_colors_txt         
   
      movem.l     (a7)+,a0-a2/d0-d1  
      addq.l      #2,tab_one
      cmpi.l      #couleur_three,tab_one
      bne.s       end_line_m 
      move.l      #couleur_two,tab_one
end_line_m:
      rte       

hbl_line_b:
      move.b      #0,$FFFFFA1B.W
      movem.l     a0-a2/d0-d1,-(a7)   * sauvegarde registres utilises
      movea.l     tab_two,a0          * met l'adr contenu dans tab_two ds a0
      lea         $FFFF8240.W,a1      * Registre hard couleur
      lea         $FFFFFA21.W,a2      * ligne d'affichage
      bclr        #0,-18(a2)
      move.l      #hbl_down,$120.W    * Appel ligne++
      move.b      #62,(a2) 
      move.b      #8,-6(a2) 
      move.b      (a2),d0             * perte de temps
tst_line2:
      cmp.b       (a2),d0 
      beq.s       tst_line2

	dcb.w 36+2,$4e71

      move.b		LOG2+1,$FFFF8201.W ; logos mvt
      move.b		LOG2+2,$FFFF8203.W
      move.b		log2_scr_flg2,$FFFF8265.W 
      move.b		log2_scr_flg,$FFFF820F.W 
      movea.l		LOG2,a2

      move.l		hbl_cpt_mvt_logos,d0

      cmpi.b      #-1,mvt_logo
      bne.s       suite_move_LOGO 
   
      subi.l      #160,d0	; DESCENT ---<

      bra.s       action_move_godown

suite_move_LOGO:

      cmpi.b      #-1,mvt_wave_logo
      beq.s       action_move_nomove

      addi.l      #160,d0	;	MONTE ---<

action_move_goup:
 IFEQ	DEBUG
	move.w	#$00f,$ffff8240.w ;---- BLEU ----->
	bra	debugme
 ENDC
action_move_godown:
 IFEQ	DEBUG
	move.w	#$0f0,$ffff8240.w ;---- VERT ----->
	bra	debugme
 ENDC
action_move_nomove:
 IFEQ	DEBUG
	move.w	#$f00,$ffff8240.w ;---- ROUGE ---->
 ENDC
 IFEQ	DEBUG
debugme:
 ENDC

			dcb.w 38,$4e71

      move.l      d0,hbl_cpt_mvt_logos

      lea         0(A2,d0.l),a2 
      move.l      A2,d0 
      move.b      d0,$FFFF8209.W
      lsr.w       #8,d0 
      move.b      d0,$FFFF8207.W
      swap        D0
      move.b      d0,$FFFF8205.W

      move.l      hbl_cpt_mvt_logos,d0

      cmp.l       #160*100,d0 
      bne         put_pal_logos 

      move.b      #-1,mvt_wave_logo
      move.l      cpt_logo_wait,d1
      cmp.l       #400,d1
      bne.s       put_pal_logos
.re_init:
      move.b      #-1,mvt_logo
      move.b      #0,mvt_wave_logo
      move.l      #0,cpt_logo_wait

put_pal_logos
      cmp.l       #0,d0 
      bne.s       hbl_logo_end 
      move.b      #0,mvt_logo
      move.w       #-1,chg_halloffame
      
hbl_logo_end:
      cmp.w       #1,cpt_logo
      bne.s       suite_logo_cols
      movea.l     part_cols,a0
suite_logo_cols
      cmp.w       #2,cpt_logo
      bne.s       suite_logo_cols2
      movea.l     part_cols+4,a0
suite_logo_cols2
      cmp.w       #3,cpt_logo
      bne.s       suite_logo_cols3
      movea.l     part_cols+8,a0
suite_logo_cols3
      cmp.w       #4,cpt_logo
      bne.s       suite_logo_cols4
      movea.l     part_cols+12,a0
suite_logo_cols4
      cmp.w       #5,cpt_logo
      bne.s       suite_logo_cols5
      movea.l     part_cols+16,a0
suite_logo_cols5
      cmp.w       #6,cpt_logo
      bne.s       suite_logo_cols6
      movea.l     part_cols+20,a0
suite_logo_cols6     
      cmp.w       #7,cpt_logo
      bne.s       suite_logo_cols7
      movea.l     part_cols+24,a0
suite_logo_cols7      
      cmp.w       #8,cpt_logo
      bne.s       suite_logo_cols8
      movea.l     part_cols+28,a0
suite_logo_cols8             
      cmp.w       #9,cpt_logo
      bne.s       suite_logo_cols9
      movea.l     part_cols+32,a0
suite_logo_cols9      
      cmp.w       #10,cpt_logo
      bne.s       suite_logo_cols10
      movea.l     part_cols+36,a0
suite_logo_cols10     
      cmp.w       #11,cpt_logo
      bne.s       suite_logo_cols11
      movea.l     part_cols+40,a0
suite_logo_cols11     
      cmp.w       #12,cpt_logo
      bne.s       suite_logo_cols12
      movea.l     part_cols+44,a0
suite_logo_cols12   
      cmp.w       #13,cpt_logo
      bne.s       suite_logo_cols13
      movea.l     part_cols+48,a0
suite_logo_cols13      
      lea	      $ffff8240.w,a1               ;
      move.l    (a0)+,(a1)+
      move.l    (a0)+,(a1)+
      move.l    (a0)+,(a1)+
      move.l    (a0)+,(a1)+
      move.l    (a0)+,(a1)+
      move.l    (a0)+,(a1)+
      move.l    (a0)+,(a1)+
      move.l    (a0)+,(a1)+
        
hbl_one3:
      movem.l     (a7)+,a0-a2/d0-d1 
      rte

hbl_down:
      clr.b       $FFFFFA1B.W 
      movem.l     a1/d0,-(a7) 
      movea.w     #64033,a1 
      move.b      #24,(a1) 
      move.b      #8,$FFFFFA1B.W
      move.l      #hbl_off,$120.W 
      move.b      (a1),d0 
tst_down
      cmp.b       (a1),d0 
      beq.s       tst_down 
      clr.b       $FF820A.l 
      moveq       #2,d0 
bl_nop:
      nop 
      dbf         d0,bl_nop
      move.b      #2,$FFFF820A.W
      movem.l     (a7)+,a1/d0 
      bclr        #0,$FFFFFA0F.W
      rte 
hbl_off:
      bclr        #0,$FFFFFA0F.W
      rte     

 IFEQ	BETTER_VIEW
flush:                             ; Empty buffer
	lea	$FFFFFC00.w,a0               
.flush:
	move.b	2(a0),d0           
	btst	#0,(a0)                    
	bne.s	.flush                     
	rts

sendToKeyboard:                    ; Keyboard access
.wait:
	btst	#1,$fffffc00.w
	beq.s	.wait
	move.b	d0,$FFFFFC02.w
	rts
 ENDC

clear_bss:                         ; Init BSS stack with zero
	lea	bss_start,a0
	moveq	#0,d0
.clr:
	move.l	d0,(a0)+
	cmp.l	#bss_end,a0
	blt.s	.clr
	rts

black_out:                         ; Clear Palette colors
	moveq  #0,d0
	moveq  #0,d1
	moveq  #0,d2
	moveq  #0,d3
	moveq  #0,d4
	moveq  #0,d5
	moveq  #0,d6
	moveq  #0,d7
	movem.l d0-d7,$ffff8240.w
	rts

 include "E:\hallof\include\LZ4_183.ASM"
 include "E:\HALLOF\include\CLR4PBF.ASM"
*----------------------------------------------------------
 include "E:\HALLOF\include\LSCROLL.ASM"
 include "E:\HALLOF\include\CSCROLL.ASM"
 include "E:\HALLOF\include\STARSH.ASM"
 include "E:\HALLOF\include\WAVE.ASM"
 include "E:\HALLOF\include\MOVEL.ASM"

***************************************************************
 SECTION	DATA                                             // *
***************************************************************

chg_halloffame:   
	dc.w 0
hbl_cpt_mvt_logos:
	dc.l 0
hbl_cpt_mvt_stars:
	dc.l 0
mvt_logo:
	dc.w 0
cpt_logo_wait:
  dc.l	0
mvt_wave_logo:
	dc.w 0
mvt_hb_scroll_stars:
	dc.w 0
  even

cpt_logo: 
      dc.w      0  
part_logo: 
      dc.l      ulm
      dc.l      eqx 
      dc.l      tex
      dc.l      union 
      dc.l      reps 
      dc.l      dforce
      dc.l      tlb
      dc.l      ovr
      dc.l      sync
      dc.l      stcnx
      dc.l      synergy
      dc.l      elite      
      dc.l      tcb2
cpt_cols: 
      dc.w      0 
part_cols: 
      dc.l      tcb_col
      dc.l      ulm_col
      dc.l      eqx_col 
      dc.l      tex_col
      dc.l      union_col 
      dc.l      reps_col 
      dc.l      dforce_col 
      dc.l      tlb_col 
      dc.l      ovr_col
      dc.l      sync_col
      dc.l      stcnx_col
      dc.l      synergy_col
      dc.l      elite_col
      dc.l      tcb_col
      even  

tab_one:
    dc.l      couleur_two
tab_two:
    dc.l      couleur_one 
couleur_two:
    dc.w	$0027,$0027,$0037,$0037,$0047,$0047,$0057,$0057
    dc.w	$0067,$0067,$0077,$0077,$0277,$0277,$0377,$0377
    dc.w	$0477,$0477,$0577,$0577,$0677,$0677,$0777,$0777
couleur_one:
    dc.w	$0776,$0776,$0775,$0775,$0774,$0774,$0773,$0773
    dc.w	$0772,$0772,$0771,$0771,$0770,$0770,$0760,$0760
    dc.w	$0750,$0750,$0740,$0740,$0730,$0730,$0720,$0720
    dc.w	$0700,$0700,$0702,$0703,$0703,$0704,$0704,$0705
    dc.w	$0705,$0706,$0706,$0707,$0607,$0607,$0507,$0507
    dc.w	$0407,$0407,$0307,$0307,$0207,$0207,$0007,$0007
couleur_three:
    dc.w	$0027,$0027,$0037,$0037,$0047,$0047,$0057,$0057
    dc.w	$0067,$0067,$0077,$0077,$0277,$0277,$0377,$0377
    dc.w	$0477,$0477,$0577,$0577,$0677,$0677,$0777,$0777
    dc.w	$0776,$0776,$0775,$0775,$0774,$0774,$0773,$0773
    dc.w	$0772,$0772,$0771,$0771,$0770,$0770  
    even

***********************************
* THE SCROLLINE
**********************************

Default_palette:
	dc.w	$0292,$065D,$0FEE,$05AB,$0F55,$0Fd6,$0FFF,$043B
	dc.w	$0F7E,$0DB4,$0FA2,$0A2A,$0F4B,$0CB4,$0BA3,$0645 	
SCR_TXT_MILIEU:
	dc.w $000,$FFF,$035D,$F0F,$00F,$00F,$00F,$700
	dc.w $000,$00F,$00F,$00F,$00F,$00F,$00F,$00F
choix_pal: 
	dc.l	PAL10 
pal:
	dc.l PAL10
	dc.l PAL11
	dc.l PAL12
	dc.l Default_palette  
	dc.l PAL_BLACK 
	dc.l logo_HMD_col 
PAL_BLACK: 
  dc.w      $0000,$0000,$0000,$0000
  dc.w      $0000,$0000,$0000,$0000
  dc.w      $0000,$0000,$0000,$0000
  dc.w      $0000,$0000,$0000,$0000
  dc.w      $0500,$0521,$0521,$0752 
  dc.w      $0500,$0521,$0752,$0521
  dc.w      $0752,$0752,$0763,$0763   
PAL10: 
  dc.w      $0000,$0500,$0500,$0521
  dc.w      $0500,$0521,$0521,$0752 
  dc.w      $0500,$0521,$0752,$0521
  dc.w      $0752,$0752,$0763,$0763 
PAL12: 
		dc.w	$0000,$0133,$01BB,$0144,$014C,$01CC,$01C5,$0155
		dc.w	$015D,$01DD,$01d6,$0166,$01EE,$0177,$017F,$01FF
PAL11:
 dc.w $000,$503,$503,$514
 dc.w $503,$514,$514,$625
 dc.w $503,$514,$625,$514
 dc.w $625,$625,$736,$736 
ulm_col:
		dc.w	$0000,$0811,$0899,$0122,$01AA,$0933,$0244,$0A5C
		dc.w	$0C65,$0411,$0DA0,$0809,$0181,$0212,$032C,$077F
union_col:
      dc.w	$0000,$022D,$0310,$0929,$02AA,$0528,$0632,$0A3A
	dc.w	$0752,$0762,$0A3F,$0642,$055F,$0119,$0444,$077F
tex_col:
      dc.w	$0000,$0002,$0303,$0414,$0523,$0620,$0730,$0740
	dc.w	$0750,$0762,$0774,$0F76,$0FF7,$0103,$0304,$0743
eqx_col:
	dc.w	$0000,$0EBF,$0FF0,$0A0A,$0C0F,$0909,$0E0F,$0FED
	dc.w	$0EE6,$066D,$06DD,$064E,$062B,$0C0A,$0202,$0777
reps_col:
	dc.w	$0000,$0CA8,$0D38,$06B9,$0EC3,$07DC,$0FE5,$0F76
	dc.w	$0BAB,$0B18,$0B06,$0C00,$0601,$0EA8,$0203,$0FFF
tcb_col:
      dc.w	$0000,$0109,$028A,$031A,$0C9B,$0D2C,$0E36,$0E46
	dc.w	$075E,$017F,$0992,$0922,$0233,$024C,$0255,$0777
dforce_col:
	dc.w	$0000,$0303,$0109,$0B1A,$0492,$0C2A,$05AB,$0DBC
	dc.w	$0645,$0E5D,$07E6,$0FF6,$0FFF,$020A,$0A16,$0CDF
tlb_col:
	dc.w	$0000,$04C4,$0222,$0AA3,$0BB4,$0555,$066E,$0FFF
	dc.w	$0B33,$0292,$06A0,$0EC8,$0F6B,$0903,$0FE6,$0590
elite_col:
      dc.w  $0000,$0011,$0222,$0332,$0443,$0654,$0765,$0776
      dc.w  $0101,$0312,$0422,$0532,$0642,$0752,$0763,$0202                 
stcnx_col     
      dc.W  $0000,$0112,$0223,$0334,$0445,$0556,$0667,$0777
      dc.W  $0300,$0410,$0521,$0632,$0743,$0754,$0765,$0776
ovr_col      
      dc.w  $0000,$0012,$0123,$0234,$0345,$0456,$0567,$0677
      dc.w	$0002,$0022,$0311,$0631,$0753,$0304,$0425,$0546      
sync_col
      dc.w	$0000,$0EE4,$0Ed4,$0643,$0D32,$0529,$0C19,$0B82
      dc.w	$0A0A,$0DBF,$0C17,$0385,$028B,$010A,$0EE5,$0EEE
synergy_col
      dc.w	$0000,$0100,$0200,$0210,$0320,$0531,$0641,$0750
      dc.w	$0760,$0770,$0777,$0214,$0314,$0424,$0534,$0643
logo_HMD_col:	
 		dc.w	$0001,$0945,$0834,$0752,$0721,$0510,$02d6,$0634
		dc.w	$0523,$0404,$0221,$0333,$0544,$0655,$0766,$0777
	even
      
tcb:  incbin "E:\HALLOF\PICS\pi1\tcb.pi1"
ulm:  incbin "E:\HALLOF\PICS\hallof.lz4\ulm.lz4"
union:incbin "E:\HALLOF\PICS\hallof.lz4\union.lz4"
tex:  incbin "E:\HALLOF\PICS\hallof.lz4\tex.lz4"
eqx:  incbin "E:\HALLOF\PICS\hallof.lz4\eqx.lz4"
reps: incbin "E:\HALLOF\PICS\hallof.lz4\reps.lz4"
tcb2: incbin "E:\HALLOF\PICS\hallof.lz4\tcb.lz4"
tlb:  incbin "E:\HALLOF\PICS\hallof.lz4\lostb.lz4"
dforce:incbin "E:\HALLOF\PICS\hallof.lz4\dforce.lz4"
stcnx:incbin "E:\HALLOF\PICS\hallof.lz4\stcnx.lz4"
elite:incbin "E:\HALLOF\PICS\hallof.lz4\elite.lz4"
ovr:  incbin "E:\HALLOF\PICS\hallof.lz4\ovr.lz4"
sync: incbin "E:\HALLOF\PICS\hallof.lz4\sync.lz4"
synergy:incbin "E:\HALLOF\PICS\hallof.lz4\synergy.lz4"
record:incbin "E:\HALLOF\PICS\hallof.lz4\record.lz4"
space:incbin "E:\HALLOF\PICS\hallof.lz4\space.lz4"
      even             

hmdlog1:	even
	incbin "E:\HALLOF\DATA\LASTLG1.pi1"
hmdlog2:	even
	incbin "E:\HALLOF\DATA\LASTLG2.pi1"  

MUSIC:
	incbin	"E:\HALLOF\DATA\PAREID23.SND"
	even

***************************************************************
 SECTION	BSS                                              // *
***************************************************************

bss_start:

hardste_B3:
	ds.l	0
hardste_BC:
	ds.l	0
hardste_B4:
	ds.b	0 
hardste_B5:
	ds.b	0 
hardste_B6:
	ds.b	0 
hardste_B7:
	ds.b	0 
hardste_B8:
	ds.w	0 
resolution:
	ds.w	0

LOG:
	ds.l	1 

LOG2	
	ds.l	1
log2_scr_flg:
	ds.w  1 
log2_scr_flg2:
	ds.l  1	

LOG4:
	ds.l	1  
log4_scr_flgB:
	ds.w	1 
log4_scr_flg2B:
	ds.l	1	

	even

bss_end:

bufscr:
	ds.b  SIZE_OF_SCREEN*1
buf_scr2:
	ds.b	SIZE_OF_SCREEN*1
buf_scr3:
	ds.b	SIZE_OF_SCREEN*1
	even

	END