; *************************************************************************
; ***                Scrolltext resizable in one bitplane               ***
; *************************************************************************
; ***                           Atomus/NoExtra                          ***
; *************************************************************************
; Parameters                                                              *
; ------------------------------------------------------------------------*
; *************************************************************************
FWIDTH    equ 16 ; LARGEUR                                                *
FHEIGHT   equ 14 ; HAUTEUR                                                *
FREALSIZE equ 10 ; Taille réelle                                          *
; *************************************************************************
play_ScrollTexte:
.put_to_Buffer:
  cmpi.w	#8*4,Cpt_timing
  bne.s	.scroll
  moveq	#0,d0 
  movea.l	ptr_texte,a0
.init_texte:
  move.b	(a0)+,d0
  bpl.s	.no_init_texte
  lea	texte,a0
  bra.s	.init_texte
.no_init_texte:
  move.l	a0,ptr_texte
  subi.b	#8*4,d0 
  mulu	#(7*8)*8,d0
  addi.l	#B_Fonte,d0
  move.l	d0,sav_D0
  clr.w	Cpt_timing
.scroll:
  lea	BufferB,a3
  lea	2(a3),a1
  movea.w	Cpt_timing,a2
  adda.l	sav_D0,a2
  moveq	#FREALSIZE,d0
.loop:
 rept 20-1
  move.w	(a1)+,(a3)+ 
 endr
  move.w	(a2),(a3)+
  adda.w	#8*4,a2 
  addq.w	#2,a1 
  dbf	d0,.loop
  addq.w	#2,Cpt_timing
.display:
  movea.l	physique,A0
  add.l	#160*95+2,a0
  lea	BufferB,A1
	move.w	#6,ratio
  moveq	#FREALSIZE,d0
.repeat:
 rept 20
  move.w	(a1)+,d1
  move.w	d1,0000(a0) 
  move.w	d1,0160(a0)
  move.w	d1,0320(a0)
  move.w	d1,0480(a0)
  move.w	d1,0640(a0)
  move.w	d1,0800(a0)
  move.w	d1,0960(a0)
  move.w	d1,1120(a0) 
  move.w	d1,1280(a0) 
  move.w	d1,1440(a0) 
  move.w	d1,1600(a0) 
  move.w	d1,1760(a0) 
  move.w	d1,1920(a0) 
  move.w	d1,2080(a0) 
  addq.w	#8,a0 
 endr
	move.w	ratio,d6
	move.w d6,d5
	lsl.w #7,d6
	lsl.w #5,d5
	add.w d5,d6 ; except this shit... mulu	#160,d6
	add.w	d6,a0
  dbf	d0,.repeat
  rts 

Cpt_timing:
	dc.w	8*4
ptr_texte:
	dc.l	texte 
;  !(),./0123456789:ABCDEFGHIJKLMNOPQRSTUVWXYZ
texte:
	dc.b	"                "
	dc.b	"A LITTLE COME BACK FROM THE NOEXTRA TEAM IN THE ERFURT MEETING FOLLOWING THE FRENCH ATARI GEMTOS EVENT THIS "
	dc.b	"YEAR AND WE ARE IN GERMANY TODAY!"
	dc.b	"              "
	dc.b	"AS ALWAYS, A SCREEN CREATED IN A RUSH BEFORE THE DEADLINE THIS EVENING, BUT WITH WHAT TEAM! ONLY WITH MEMBERS OF HEMOROIDS "
	dc.b	"HELPED US WITH GFX AND SFX AS YOU CAN READ IN THE OTHER SCROLLING TEXT... "
	dc.b	"              "
	dc.b	"AND NOEXTRA WILL BE BACK SOON WITH A LOT OF INTROS, NOTABLY FOR ATARI LEGEND, FEATURING FRENCH EDUCATIONAL GAMES "
	dc.b	"FROM SCHREDDER AND FROM IFA. GAMES HAD NEVER BEEN SHARED OR RELEASED BEFORE... AND OF COURSE, OUR THOUGHTS GO OUT TO HIS WIFE AND SON. "
	dc.b	"LOTS OF SCROLLTEXTS FROM FORMER MEMBERS OF A.L. SUCH AS MUG.UK / CB / MOOD.ST SHOULD BE RELEASED SOON! "
	dc.b	"                "
	dc.b	"THANKS TO ALL THE MEMBERS OF THE NOEXTRA TEAM, PARTICULARLY ATOMUS, MISTER.A, HYLST AND YQN, FOR KEEPING THE OLDSCHOOL "
	dc.b	"DEMOSCENE MOVEMENT ALIVE ON THE ATARI ST. AND I FORGOT, TWO NEW EXTRA SPECIAL MENUS WITH NEVER-BEFORE-SEEN SCREENS DEMOS BEFORE GET OUT SOON ,) "
	dc.b	"                "
	dc.b	"THANKS FOR REGARDING THIS INTRO ON A REAL HARDWARE, ATARI STF OR STE WITH 512 KO OF MEMORY..........................                  WRAP!"
	dc.w	-1
B_Fonte:	even
	incbin	"E:\ERFURT20.26\data\BSCROLL.DAT"
BufferB:
	ds.b	(20*FHEIGHT)*2
ratio:
	ds.w	1
sav_D0:
	ds.l	1
	even
