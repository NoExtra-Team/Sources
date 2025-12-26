**********************************
* Original Program Startup Tester*
**********************************
* Original version ATOMUS/NOEX   *
*--------------------------------*
* Parameter(s)                   *
*--------------------------------*
**********************************

	clr.l	-(sp)
	move	#$20,-(sp)
	trap	#1
	addq.l	#6,sp
	move.l	d0,Old_SSP+2

*	Stop Keyboard Sending

	bsr	Stop_Keyboard

	move.b	#$12,$fffffc02.w

*	Save & Change Stack

	move.l	a7,Old_Stack+2
	lea	Main(pc),a7

*	Save & Change Resolution

	move	#4,-(sp)
	trap	#14	             ;	Get Current Res.
	addq.l	#2,sp
	move	d0,Old_Resol+2

	clr	-(sp)
	move.l	#-1,-(sp)
	move.l	(sp),-(sp)
	move	#5,-(sp)
	trap	#14	             ;	Switch to Low
	lea	12(sp),sp

*	Save Current Colors

	lea	Old_Colors(pc),a0
	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,(a0)

*	Save Screen Address

	move	#2,-(sp)
	trap	#14
	addq.l	#2,sp
	move.l	d0,Old_Screen+2

*	Save Hardware Registers

	move	#$2700,sr

	lea	Save_all,a0                  ; Save adresses parameters
	move.b $fffffa01.w,(a0)+         ; Datareg
	move.b $fffffa03.w,(a0)+         ; Active edge
	move.b $fffffa05.w,(a0)+         ; Data direction
	move.b $fffffa07.w,(a0)+         ; Interrupt enable A
	move.b $fffffa13.w,(a0)+         ; Interupt Mask A
	move.b $fffffa09.w,(a0)+         ; Interrupt enable B
	move.b $fffffa15.w,(a0)+         ; Interrupt mask B
	move.b $fffffa17.w,(a0)+         ; Automatic/software end of Interupt
	move.b $fffffa19.w,(a0)+         ; Timer A control
	move.b $fffffa1b.w,(a0)+         ; Timer B control
	move.b $fffffa1d.w,(a0)+         ; Timer C & D control
	move.b $fffffa27.w,(a0)+         ; Sync character
	move.b $fffffa29.w,(a0)+         ; USART control
	move.b $fffffa2b.w,(a0)+         ; Receiver status
	move.b $fffffa2d.w,(a0)+         ; Transmitter status
	move.b $fffffa2f.w,(a0)+         ; USART data

	lea	Save_rest,a0                 ; Save adresses parameters
	move.l $068.w,(a0)+              ; HBL
	move.l $070.w,(a0)+              ; VBL
	move.l $110.w,(a0)+              ; TIMER D
	move.l $114.w,(a0)+              ; TIMER C
	move.l $118.w,(a0)+              ; ACIA
	move.l $120.w,(a0)+              ; TIMER B
	move.l $134.w,(a0)+              ; TIMER A
	move.l $484.w,(a0)+              ; Conterm

	lea	Old_Timers(pc),a1
	lea	$fffffa00.w,a0
	move.l	$00(a0),02(a1)  ; GPIP & AER
	move.l	$04(a0),10(a1)	; DDR & IERA
	move.l	$08(a0),18(a1)	; IERB & IPRA
	move.l	$0c(a0),26(a1)	; IPRB & ISRA
	move.l	$10(a0),34(a1)	; ISRB & IMRA
	move.l	$14(a0),42(a1)	; IMRB & VR
	move.l	$18(a0),50(a1)	; TACR & TBCR
	move.l	$1c(a0),58(a1)	; TCDCR & TADR
	move.l	$20(a0),66(a1)	; TBDR & TCDR
	move	$24(a0),74(a1)	  ; TDDR

	lea	Old_ITs(pc),a1
	lea	$100.w,a0
	move.l	$00(a0),2(a1)	  ; Centronic Busy
	move.l	$04(a0),10(a1)	; RS232 DCD
	move.l	$08(a0),18(a1)	; RS232 CTS
	move.l	$0c(a0),26(a1)	; Blitter
	move.l	$10(a0),34(a1)	; Timer D
	move.l	$14(a0),42(a1)	; Timer C
	move.l	$18(a0),50(a1)	; ACIA (MIDI & Keyboard)
	move.l	$1c(a0),58(a1)	; FDC & DMA
	move.l	$20(a0),66(a1)	; Timer B
	move.l	$24(a0),74(a1)	; RS232 Sending ERROR
	move.l	$28(a0),82(a1)	; RS232 Sending Buffer Empty
	move.l	$2c(a0),90(a1)	; RS232 Receiving ERROR
	move.l	$30(a0),98(a1)	; RS232 Receiving Buffer Full
	move.l	$34(a0),106(a1)	; Timer A
	move.l	$38(a0),114(a1)	; RS232 Ring Indicator
	move.l	$3c(a0),122(a1)	; Monochrom Monitor Detect

*	Go to Main Routine

	bsr	Main

*	Restore Hardware Registers

	stop	#$2300
	move	#$2700,sr

	lea $ffff8800.w,a0               ; Cut sound
	move.l #$8000000,(a0)            ; Voice A
	move.l #$9000000,(a0)            ; Voice B
	move.l #$a000000,(a0)            ; Voice C

	lea	$fffffa00.w,a0
Old_Timers:
	move.l	#0,$00(a0)
	move.l	#0,$04(a0)
	move.l	#0,$08(a0)
	move.l	#0,$0c(a0)
	move.l	#0,$10(a0)
	move.l	#0,$14(a0)
	move.l	#0,$18(a0)
	move.l	#0,$1c(a0)
	move.l	#0,$20(a0)
	move	#0,$24(a0)

	move.b	#$c0,$23(a0)   ;	Key Repeat Counter

	lea	Save_all,a0                  ; Restore adresses parameters
	move.b (a0)+,$fffffa01.w         ; Datareg
	move.b (a0)+,$fffffa03.w         ; Active edge
	move.b (a0)+,$fffffa05.w         ; Data direction
	move.b (a0)+,$fffffa07.w         ; Interrupt enable A
	move.b (a0)+,$fffffa13.w         ; Interupt Mask A
	move.b (a0)+,$fffffa09.w         ; Interrupt enable B
	move.b (a0)+,$fffffa15.w         ; Interrupt mask B
	move.b (a0)+,$fffffa17.w         ; Automatic/software end of interupt
	move.b (a0)+,$fffffa19.w         ; Timer A control
	move.b (a0)+,$fffffa1b.w         ; Timer B control
	move.b (a0)+,$fffffa1d.w         ; Timer C & D control
	move.b (a0)+,$fffffa27.w         ; Sync character
	move.b (a0)+,$fffffa29.w         ; USART control
	move.b (a0)+,$fffffa2b.w         ; Receiver status
	move.b (a0)+,$fffffa2d.w         ; Transmitter status
	move.b (a0)+,$fffffa2f.w         ; USART data

	lea	Save_rest,a0                 ; Restore adresses parameters
	move.l (a0)+,$068.w              ; HBL
	move.l (a0)+,$070.w              ; VBL
	move.l (a0)+,$110.w              ; TIMER D
	move.l (a0)+,$114.w              ; TIMER C
	move.l (a0)+,$118.w              ; ACIA
	move.l (a0)+,$120.w              ; TIMER B
	move.l (a0)+,$134.w              ; TIMER A
	move.l (a0)+,$484.w              ; Conterm

	lea	$100.w,a0
Old_ITs:
	move.l	#0,$00(a0)
	move.l	#0,$04(a0)
	move.l	#0,$08(a0)
	move.l	#0,$0c(a0)
	move.l	#0,$10(a0)
	move.l	#0,$14(a0)
	move.l	#0,$18(a0)
	move.l	#0,$1c(a0)
	move.l	#0,$20(a0)
	move.l	#0,$24(a0)
	move.l	#0,$28(a0)
	move.l	#0,$2c(a0)
	move.l	#0,$30(a0)
	move.l	#0,$34(a0)
	move.l	#0,$38(a0)
	move.l	#0,$3c(a0)

*	Restore Stack

Old_Stack:
	move.l	#0,a7	         ;	Restore Old Stack Pointer

	move	#$2300,sr

*	Restore Screen & Resol

Old_Resol:
	move	#0,-(sp)
Old_Screen:
	move.l	#0,-(sp)
	move.l	(sp),-(sp)
	move	#5,-(sp)
	trap	#14	             ;	Restore Old Screen & Resol
	lea	12(sp),sp

*	Restore Current Colors

	movem.l	Old_Colors,d0-d7
	movem.l	d0-d7,$ffff8240.w

*	Allow Keyboard Sending

	move.b	#$08,$fffffc02.w

	bsr	Stop_Keyboard

*	Restore SSP & Leave PRG

Old_SSP:
	move.l	#0,-(sp)	     ;	Restore Old SSP
	move	#$20,-(sp)       ;
	trap	#1	             ;	Back to User
	addq.l	#6,sp          ;

	clr	-(sp)              ;
	trap	#1	             ;	Quit

Stop_Keyboard:
	moveq	#-%01100000,d0
	and.b	$fffffc00.w,d0	 ;	Keep Needed Bits
	beq.s	.Leave_Test	     ;	Is Sending Over?
	move.b	$fffffc02.w,d0 ;	If Not, Free Receive Register
	bra.s	Stop_Keyboard	   ;	And Go Back to Test...
.Leave_Test:
	rts

Old_Colors:
	ds.l	8

Save_rest:
	ds.l 1	* Autovector (HBL)
	ds.l 1	* Autovector (VBL)
	ds.l 1	* Timer D (USART timer)
	ds.l 1	* Timer C (200hz Clock)
	ds.l 1	* Keyboard/MIDI (ACIA) 
	ds.l 1	* Timer B (HBL)
	ds.l 1	* Timer A
	ds.l 1	* Output Bip Bop

Save_all:
	ds.b 16 * MFP Interrupts

	even

	ds.l	128              ;	New Stack Lenght

Main: