;================================================================================
;		opt	x+
;================================================================================
		text
;================================================================================
begin
;--------------------------------------------------------------------------------
p_tbase		move.l	sp,save_sp
		move.l	4(sp),save4sp

super		clr.l	-(sp)
		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp
		move.l	d0,savessp
;================================================================================
		bsr	save
		jmp	intro(pc)
;================================================================================
exit		bsr	restore
;--------------------------------------------------------------------------------
user		move.l	savessp(pc),-(sp)
		move.w	#$20,-(sp)		;super
		trap	#1
		addq.l	#6,sp

		move.l	save_sp(pc),sp
		move.l	save4sp(pc),4(sp)
;================================================================================
load		move.l	#prg_n_1,f_name
		move.l	#buffer,adr_buff
		bsr	ld_file
		tst.b	flagerr
		bne.s	pterm0
;================================================================================
reloc		jmp	relog(pc)
jump		jmp	(sp)
;================================================================================
pterm0		clr.w	-(sp)			;pterm
		trap	#1
;================================================================================
save		move.w	sr,-(sp)
		move.w	#$2700,sr
		move.l	$8.w,berr		;	Bus Error
		move.l	$c.w,adderr		;	Address Error
		move.l	$10.w,illerr		;	Illegal Instruction
		move.l	$14.w,div0		;	Zero Divide
		move.l	$18.w,chktrp		;	CHK, CHK2 Instruction
		move.l	$1c.w,trapvtrap		;	cpTRAPcc, TRAPcc, TRAPV
		move.l	$20.w,supererr		;	Privilege Violation
		move.l	$24.w,tracetrap		;	Trace
		move.l	$28.w,lineatrap		;	Line 1010 Emulator (LineA)
		move.l	$2c.w,lineftrap		;	Line 1111 Emulator (LineF)
		move.l	$60.w,berrberr		;	Spurious Interrupt (Bus error during interrupt)
		move.l	$64.w,ipl1		;	Level 1 Int Autovector (TT VME)
		move.l	$68.w,hblvec		;	Level 2 Int Autovector (HBL)
		move.l	$6c.w,ipl3		;	Level 3 Int Autovector (TT VME)
		move.l	$70.w,vblvec		;	Level 4 Int Autovector (VBL)
		move.l	$74.w,ipl5		;	Level 5 Int Autovector
		move.l	$78.w,ipl6		;	Level 6 Int Autovector (MFP)
		move.l	$7c.w,ipl7		;	Level 7 Int Autovector
		move.l	$80.w,trap0		;	Trap #0
		move.l	$84.w,trap1		;	Trap #1 (GemDOS)
		move.l	$88.w,trap2		;	Trap #2 (AES/VDI)
		move.l	$8c.w,trap3		;	Trap #3
		move.l	$90.w,trap4		;	Trap #4
		move.l	$94.w,trap5		;	Trap #5
		move.l	$98.w,trap6		;	Trap #6
		move.l	$9c.w,trap7		;	Trap #7
		move.l	$a0.w,trap8		;	Trap #8
		move.l	$a4.w,trap9		;	Trap #9
		move.l	$a8.w,trap10		;	Trap #10
		move.l	$ac.w,trap11		;	Trap #11
		move.l	$b0.w,trap12		;	Trap #12
		move.l	$b4.w,trap13		;	Trap #13 (BIOS)
		move.l	$b8.w,trap14		;	Trap #14 (XBIOS)
		move.l	$110.w,timerdvec	;	ST-MFP-4 - Timer D (USART timer)
		move.l	$114.w,timercvec	;	ST-MFP-5 - Timer C (200hz Clock)
		move.l	$118.w,ikbdvec		;	ST-MFP-6 - Keyboard/MIDI (ACIA)
		move.l	$120.w,timerbvec	;	ST-MFP-8 - Timer B (HBL)
		move.l	$134.w,timeravec	;	ST-MFP-13 - Timer A (STe sound)
		move.l	$420.w,memvalid		;	Validates memory configuration if $752019F3
		move.b	$424.w,memctrl		;	Copy of contents of $ffff8001.w
		move.l	$426.w,resvalid		;	Validates resvector if $31415926
		move.l	$42a.w,resvector	;	Reset vector
		move.l	$42e.w,phystop		;	Physical top of RAM
		move.l	$432.w,_membot		;	Start of TPA (user memory)
		move.l	$436.w,_memtop		;	End of TPA (user memory)
		move.l	$43a.w,memval2		;	Validates memcntrl and memconf if $237698AA
		move.w	$43e.w,flock		;	If nonzero, floppy disk VBL routine is disabled
		move.w	$440.w,seekrate		;	Floppy Seek rate - 0:6ms, 1:12ms, 2:2ms, 3:3ms
		move.w	$442.w,_timer_ms	;	Time between two timer calls (in milliseconds)
		move.w	$444.w,_fverify		;	If not zero, verify floppy disk writes
		move.w	$446.w,_bootdev		;	Default boot device
		move.b	$448.w,palmode		;	0 - NTSC (60hz), <>0 - PAL (50hz)
		move.b	$44a.w,defshiftmod	;	Default video resolution
		move.b	$44c.w,sshiftmod	;	Copy of contents of $ffff8260.w
		move.l	$44e.w,_v_bas_ad	;	Pointer to video RAM (logical screen base)
		move.w	$452.w,vblsem		;	If not zero, VBL routine is not executed
		move.w	$454.w,nvbls		;	Number of vertical blank routines
		move.l	$456.w,_vblqueue	;	Pointer to list of vertical blank routines
		move.l	$45a.w,colorptr		;	If not zero, points to color palette to be loaded
		move.l	$45e.w,screenpt		;	If not zero, points to video ram for next VBL
		move.l	$46a.w,hdv_init		;	Vector for hard disk initialization
		move.l	$46e.w,swv_vec		;	Vector for resolution change
		move.l	$472.w,hdv_bpb		;	Vector for getbpb for hard disk
		move.l	$476.w,hdv_rw		;	Vector for read/write routine for hard disk
		move.l	$47a.w,hdv_boot		;	Vector for hard disk boot
		move.l	$47e.w,hdv_mediach	;	Vector for hard disk media change
		move.b	$484.w,conterm		;	Attribute vector for console output
		move.l	$4a2.w,savptr		;	Pointer to BIOS save registers block
		move.w	$4a6.w,_nflops		;	Number of connected floppy drives
		move.l	$4a8.w,con_state	;	Vector for screen output
		move.l	$4b2.w,_bufl1		;	Pointer to buffer control block for GEMDOS data
		move.l	$4b6.w,_bufl2		;	Pointer to buffer control block for GEMDOS fat/dir
		move.l	$4c2.w,_drvbits		;	Bit allocation for physical drives (bit 0=A, 1=B..)
		move.l	$4c6.w,_dskbufp		;	Pointer to 1024-byte disk buffer
		move.l	$4ce.w,_vbl_lis1	;	Pointer to VBL routine #1
		move.l	$4d2.w,_vbl_lis2	;	Pointer to VBL routine #2
		move.l	$4d6.w,_vbl_lis3	;	Pointer to VBL routine #3
		move.l	$4da.w,_vbl_lis4	;	Pointer to VBL routine #4
		move.l	$4de.w,_vbl_lis5	;	Pointer to VBL routine #5
		move.l	$4e2.w,_vbl_lis6	;	Pointer to VBL routine #6
		move.l	$4e6.w,_vbl_lis7	;	Pointer to VBL routine #7
		move.l	$4ea.w,_vbl_lis8	;	Pointer to VBL routine #8
		move.w	$4ee.w,_dumpflg		;	Flag for screen -> printer dump
		move.l	$4fa.w,end_os		;	Pointer to end of OS
		move.l	$4fe.w,exec_os		;	Pointer to entry point of OS
		move.l	$502.w,scr_dump		;	Pointer to screen dump routine
		move.l	$5a0.w,_p_cookies	;	Pointer to cookie jar
		move.l	$51a.w,memval3		;	If $5555AAAA, reset
		move.w	$59e.w,_longframe	;	If not 0, then not 68000 - use long stack frames
		move.b	$ffff8001.w,memconf	;	MMU memory configuration
		move.b	$ffff8201.w,st_8201	;	Video screen memory position (High byte)
		move.b	$ffff8203.w,st_8203	;	Video screen memory position (Mid byte)
		move.b	$ffff820a.w,st_820a	;	Video synchronization mode
;	STE	=	$ffff820d	=	lobase
;	STE	=	$ffff820f	=	linewid
;		move.b	$ffff820d.w,ste820d	;	Video screen memory position (Low byte)
;		move.b	$ffff820f.w,ste820f	;	Width of a scanline (width in words-1)
		move.b	$ffff8260.w,st_8260	;	Shifter resolution
;	STE	=	$ffff8265.w	=	hscroll
;		move.b	$ffff8265.w,ste8265	;	Horizontal scroll register (0-15)
		move.b	$fffffa01.w,gpip	;	Parallel Port Data Register
		move.b	$fffffa03.w,aer		;	Active Edge Register
		move.b	$fffffa05.w,ddr		;	Data Direction
		move.b	$fffffa07.w,iera	;	Interrupt Enable A
		move.b	$fffffa09.w,ierb	;	Interrupt Enable B
		move.b	$fffffa0b.w,ipra	;	Interrupt Pending A
		move.b	$fffffa0d.w,iprb	;	Interrupt Pending B
		move.b	$fffffa0f.w,isra	;	Interrupt In-service A
		move.b	$fffffa11.w,isrb	;	Interrupt In-service B
		move.b	$fffffa13.w,imra	;	Interrupt Mask A
		move.b	$fffffa15.w,imrb	;	Interrupt Mask B
		move.b	$fffffa17.w,vr		;	Vector Register
		move.b	$fffffa19.w,tacr	;	Timer A Control
		move.b	$fffffa1b.w,tbcr	;	Timer B Control
		move.b	$fffffa1d.w,tcdcr	;	Timer C & D Control
		move.b	$fffffa1f.w,tadr	;	Timer A Data
		move.b	$fffffa21.w,tbdr	;	Timer B Data
;		move.b	$fffffa23.w,tcdr	;	Timer C Data
		move.b	$fffffa25.w,tddr	;	Timer D Data
		move.b	$fffffa27.w,scr		;	Sync Character
		move.b	$fffffa29.w,ucr		;	USART Control
		move.b	$fffffa2b.w,rsr		;	Receiver Status
		move.b	$fffffa2d.w,tsr		;	Transmitter Status
		move.b	$fffffa2f.w,udr		;	USART data
		move.w	#$2300,sr
		move.w	(sp)+,sr
		rts
;================================================================================
restore		move.w	sr,-(sp)
		move.w	#$2700,sr
		move.l	berr(pc),$8.w		;	Bus Error
		move.l	adderr(pc),$c.w		;	Address Error
		move.l	illerr(pc),$10.w	;	Illegal Instruction	
		move.l	div0(pc),$14.w		;	Zero Divide
		move.l	chktrp(pc),$18.w	;	CHK, CHK2 Instruction
		move.l	trapvtrap(pc),$1c.w	;	cpTRAPcc, TRAPcc, TRAPV
		move.l	supererr(pc),$20.w	;	Privilege Violation
		move.l	tracetrap(pc),$24.w	;	Trace
		move.l	lineatrap(pc),$28.w	;	Line 1010 Emulator (LineA)
		move.l	lineftrap(pc),$2c.w	;	Line 1111 Emulator (LineF)
		move.l	berrberr(pc),$60.w	;	Spurious Interrupt (Bus error during interrupt)
		move.l	ipl1(pc),$64.w		;	Level 1 Int Autovector (TT VME)
		move.l	hblvec(pc),$68.w	;	Level 2 Int Autovector (HBL)
		move.l	ipl3(pc),$6c.w		;	Level 3 Int Autovector (TT VME)
		move.l	vblvec(pc),$70.w	;	Level 4 Int Autovector (VBL)
		move.l	ipl5(pc),$74.w		;	Level 5 Int Autovector
		move.l	ipl6(pc),$78.w		;	Level 6 Int Autovector (MFP)
		move.l	ipl7(pc),$7c.w		;	Level 7 Int Autovector
		move.l	trap0(pc),$80.w		;	Trap #0
		move.l	trap1(pc),$84.w		;	Trap #1 (GemDOS)
		move.l	trap2(pc),$88.w		;	Trap #2 (AES/VDI)
		move.l	trap3(pc),$8c.w		;	Trap #3
		move.l	trap4(pc),$90.w		;	Trap #4
		move.l	trap5(pc),$94.w		;	Trap #5
		move.l	trap6(pc),$98.w		;	Trap #6
		move.l	trap7(pc),$9c.w		;	Trap #7
		move.l	trap8(pc),$a0.w		;	Trap #8
		move.l	trap9(pc),$a4.w		;	Trap #9
		move.l	trap10(pc),$a8.w	;	Trap #10
		move.l	trap11(pc),$ac.w	;	Trap #11
		move.l	trap12(pc),$b0.w	;	Trap #12
		move.l	trap13(pc),$b4.w	;	Trap #13 (BIOS)
		move.l	trap14(pc),$b8.w	;	Trap #14 (XBIOS)
		move.l	timerdvec(pc),$110.w	;	ST-MFP-4 - Timer D (USART timer)
		move.l	timercvec(pc),$114.w	;	ST-MFP-5 - Timer C (200hz Clock)
		move.l	ikbdvec(pc),$118.w	;	ST-MFP-6 - Keyboard/MIDI (ACIA)
		move.l	timerbvec(pc),$120.w	;	ST-MFP-8 - Timer B (HBL)
		move.l	timeravec(pc),$134.w	;	ST-MFP-13 - Timer A (STe sound)
		move.l	memvalid(pc),$420.w	;	Validates memory configuration if $752019F3
		move.b	memctrl(pc),$424.w	;	Copy of contents of $ffff8001.w
		move.l	resvalid(pc),$426.w	;	Validates resvector if $31415926
		move.l	resvector(pc),$42a.w	;	Reset vector
		move.l	phystop(pc),$42e.w	;	Physical top of RAM
		move.l	_membot(pc),$432.w	;	Start of TPA (user memory)
		move.l	_memtop(pc),$436.w	;	End of TPA (user memory)
		move.l	memval2(pc),$43a.w	;	Validates memcntrl and memconf if $237698AA
		move.w	flock(pc),$43e.w	;	If nonzero, floppy disk VBL routine is disabled
		move.w	seekrate(pc),$440.w	;	Floppy Seek rate - 0:6ms, 1:12ms, 2:2ms, 3:3ms
		move.w	_timer_ms(pc),$442.w	;	Time between two timer calls (in milliseconds)
		move.w	_fverify(pc),$444.w	;	If not zero, verify floppy disk writes
		move.w	_bootdev(pc),$446.w	;	Default boot device
		move.b	palmode(pc),$448.w	;	0 - NTSC (60hz), <>0 - PAL (50hz)
		move.b	defshiftmod(pc),$44a.w	;	Default video resolution
		move.b	sshiftmod(pc),$44c.w	;	Copy of contents of $ffff8260.w
		move.l	_v_bas_ad(pc),$44e.w	;	Pointer to video RAM (logical screen base)
		move.w	vblsem(pc),$452.w	;	If not zero, VBL routine is not executed
		move.w	nvbls(pc),$454.w	;	Number of vertical blank routines
		move.l	_vblqueue(pc),$456.w	;	Pointer to list of vertical blank routines
		move.l	colorptr(pc),$45a.w	;	If not zero, points to color palette to be loaded
		move.l	screenpt(pc),$45e.w	;	If not zero, points to video ram for next VBL
		move.l	hdv_init(pc),$46a.w	;	Vector for hard disk initialization
		move.l	swv_vec(pc),$46e.w	;	Vector for resolution change
		move.l	hdv_bpb(pc),$472.w	;	Vector for getbpb for hard disk
		move.l	hdv_rw(pc),$476.w	;	Vector for read/write routine for hard disk
		move.l	hdv_boot(pc),$47a.w	;	Vector for hard disk boot
		move.l	hdv_mediach(pc),$47e.w	;	Vector for hard disk media change
		move.b	conterm(pc),$484.w	:	Attribute vector for console outpu
		move.l	savptr(pc),$4a2.w	;	Pointer to BIOS save registers block
		move.w	_nflops(pc),$4a6.w	;	Number of connected floppy drives
		move.l	con_state(pc),$4a8.w	;	Vector for screen output
		move.l	_bufl1(pc),$4b2.w	;	Pointer to buffer control block for GEMDOS data
		move.l	_bufl2(pc),$4b6.w	;	Pointer to buffer control block for GEMDOS fat/dir
		move.l	_drvbits(pc),$4c2.w	;	Bit allocation for physical drives (bit 0=A, 1=B..)
		move.l	_dskbufp(pc),$4c6.w	;	Pointer to 1024-byte disk buffer
		move.l	_vbl_lis1(pc),$4ce.w	;	Pointer to VBL routine #1
		move.l	_vbl_lis2(pc),$4d2.w	;	Pointer to VBL routine #2
		move.l	_vbl_lis3(pc),$4d6.w	;	Pointer to VBL routine #3
		move.l	_vbl_lis4(pc),$4da.w	;	Pointer to VBL routine #4
		move.l	_vbl_lis5(pc),$4de.w	;	Pointer to VBL routine #5
		move.l	_vbl_lis6(pc),$4e2.w	;	Pointer to VBL routine #6
		move.l	_vbl_lis7(pc),$4e6.w	;	Pointer to VBL routine #7
		move.l	_vbl_lis8(pc),$4ea.w	;	Pointer to VBL routine #8
		move.w	_dumpflg(pc),$4ee.w	;	Flag for screen -> printer dump
		move.l	end_os(pc),$4fa.w	;	Pointer to end of OS
		move.l	exec_os(pc),$4fe.w	;	Pointer to entry point of OS
		move.l	scr_dump(pc),$502.w	;	Pointer to screen dump routine
		move.l	_p_cookies(pc),$5a0.w	;	Pointer to cookie jar
		move.l	memval3(pc),$51a.w	;	If $5555AAAA, reset
		move.w	_longframe(pc),$59e.w	;	If not 0, then not 68000 - use long stack frames
		move.b	memconf(pc),$ffff8001.w	;	MMU memory configuration
		move.b	st_8201(pc),$ffff8201.w	;	Video screen memory position (High byte)
		move.b	st_8203(pc),$ffff8203.w	;	Video screen memory position (Mid byte)

		move.b	st_820a(pc),$ffff820a.w	;	Video synchronization mode
;	STE	=	$ffff820d	=	lobase
;	STE	=	$ffff820f	=	linewid
;		move.b	ste820d(pc),$ffff820d.w	;	Video screen memory position (Low byte)
;		move.b	ste820f(pc),$ffff820f.w	;	Width of a scanline (width in words-1)
		move.b	st_8260(pc),$ffff8260.w	;	Shifter resolution
;	STE	=	$ffff8265.w	=	hscroll
;		move.b	ste8265(pc),$ffff8265.w	;	Horizontal scroll register (0-15)
		move.b	gpip(pc),$fffffa01.w	;	Parallel Port Data Register
		move.b	aer(pc),$fffffa03.w	;	Active Edge Register
		move.b	ddr(pc),$fffffa05.w	;	Data Direction
		move.b	iera(pc),$fffffa07.w	;	Interrupt Enable A
		move.b	ierb(pc),$fffffa09.w	;	Interrupt Enable B
		move.b	ipra(pc),$fffffa0b.w	;	Interrupt Pending A
		move.b	iprb(pc),$fffffa0d.w	;	Interrupt Pending B
		move.b	isra(pc),$fffffa0f.w	;	Interrupt In-service A
		move.b	isrb(pc),$fffffa11.w	;	Interrupt In-service B
		move.b	imra(pc),$fffffa13.w	;	Interrupt Mask A
		move.b	imrb(pc),$fffffa15.w	;	Interrupt Mask B
		move.b	vr(pc),$fffffa17.w	;	Vector Register
		move.b	tacr(pc),$fffffa19.w	;	Timer A Control
		move.b	tbcr(pc),$fffffa1b.w	;	Timer B Control
		move.b	tcdcr(pc),$fffffa1d.w	;	Timer C & D Control
		move.b	tadr(pc),$fffffa1f.w	;	Timer A Data
		move.b	tbdr(pc),$fffffa21.w	;	Timer B Data
;		move.b	tcdr(pc),$fffffa23.w	;	Timer C Data
		move.b	tddr(pc),$fffffa25.w	;	Timer D Data
		move.b	scr(pc),$fffffa27.w	;	Sync Character
		move.b	ucr(pc),$fffffa29.w	;	USART Control
		move.b	rsr(pc),$fffffa2b.w	;	Receiver Status
		move.b	tsr(pc),$fffffa2d.w	;	Transmitter Status
		move.b	udr(pc),$fffffa2f.w	;	USART data
		move.w	#$2300,sr
		move.w	(sp)+,sr
		rts

berr		ds.l	1	;$8.w		;	Bus Error
adderr		ds.l	1	;$c.w		;	Address Error
illerr		ds.l	1	;$10.w		;	Illegal Instruction
div0		ds.l	1	;$14.w		;	Zero Divide
chktrp		ds.l	1	;$18.w		;	CHK, CHK2 Instruction
trapvtrap	ds.l	1	;$1c.w		;	cpTRAPcc, TRAPcc, TRAPV
supererr	ds.l	1	;$20.w		;	Privilege Violation
tracetrap	ds.l	1	;$24.w		;	Trace
lineatrap	ds.l	1	;$28.w		;	Line 1010 Emulator (LineA)
lineftrap	ds.l	1	;$2c.w		;	Line 1111 Emulator (LineF)
berrberr	ds.l	1	;$60.w		;	Spurious Interrupt (Bus error during interrupt)
ipl1		ds.l	1	;$64.w		;	Level 1 Int Autovector (TT VME)
hblvec		ds.l	1	;$68.w		;	Level 2 Int Autovector (HBL)
ipl3		ds.l	1	;$6c.w		;	Level 3 Int Autovector (TT VME)
vblvec		ds.l	1	;$70.w		;	Level 4 Int Autovector (VBL)
ipl5		ds.l	1	;$74.w		;	Level 5 Int Autovector
ipl6		ds.l	1	;$78.w		;	Level 6 Int Autovector (MFP)
ipl7		ds.l	1	;$7c.w		;	Level 7 Int Autovector
trap0		ds.l	1	;$80.w		;	Trap #0
trap1		ds.l	1	;$84.w		;	Trap #1 (GemDOS)
trap2		ds.l	1	;$88.w		;	Trap #2 (AES/VDI)
trap3		ds.l	1	;$8c.w		;	Trap #3
trap4		ds.l	1	;$90.w		;	Trap #4
trap5		ds.l	1	;$94.w		;	Trap #5
trap6		ds.l	1	;$98.w		;	Trap #6
trap7		ds.l	1	;$9c.w		;	Trap #7
trap8		ds.l	1	;$a0.w		;	Trap #8
trap9		ds.l	1	;$a4.w		;	Trap #9
trap10		ds.l	1	;$a8.w		;	Trap #10
trap11		ds.l	1	;$ac.w		;	Trap #11
trap12		ds.l	1	;$b0.w		;	Trap #12
trap13		ds.l	1	;$b4.w		;	Trap #13 (BIOS
trap14		ds.l	1	;$b8.w		;	Trap #14 (XBIOS)
timerdvec	ds.l	1	;$110.w		;	ST-MFP-4 - Timer D (USART timer)
timercvec	ds.l	1	;$114.w		;	ST-MFP-5 - Timer C (200hz Clock)
ikbdvec		ds.l	1	;$118.w		;	ST-MFP-6 - Keyboard/MIDI (ACIA)
timerbvec	ds.l	1	;$120.w		;	ST-MFP-8 - Timer B (HBL)
timeravec	ds.l	1	;$134.w		;	ST-MFP-13 - Timer A (STe sound)
memvalid	ds.l	1	;$420.w		;	Validates memory configuration if $752019F3
memctrl		ds.b	1	;$424.w		;	Copy of contents of $ffff8001.w
		even
resvalid	ds.l	1	;$426.w		;	Validates resvector if $31415926
resvector	ds.l	1	;$42a.w		;	Reset vector
phystop		ds.l	1	;$42e.w		;	Physical top of RAM
_membot		ds.l	1	;$432.w		;	Start of TPA (user memory)
_memtop		ds.l	1	;$436.w		;	End of TPA (user memory)
memval2		ds.l	1	;$43a.w		;	Validates memcntrl and memconf if $237698AA
flock		ds.w	1	;$43e.w		;	If nonzero, floppy disk VBL routine is disabled
seekrate	ds.w	1	;$440.w		;	Floppy Seek rate - 0:6ms, 1:12ms, 2:2ms, 3:3ms
_timer_ms	ds.w	1	;$442.w		;	Time between two timer calls (in milliseconds)
_fverify	ds.w	1	;$444.w		;	If not zero, verify floppy disk writes
_bootdev	ds.w	1	;$446.w		;	Default boot device
palmode		ds.b	1	;$448.w		;	0 - NTSC (60hz), <>0 - PAL (50hz)
		even
defshiftmod	ds.b	1	;$44a.w		;	Default video resolution
		even
sshiftmod	ds.b	1	;$44c.w		;	Copy of contents of $ffff8260.w
		even
_v_bas_ad	ds.l	1	;$44e.w		;	Pointer to video RAM (logical screen base)
vblsem		ds.w	1	;$452.w		;	If not zero, VBL routine is not executed
nvbls		ds.w	1	;$454.w		;	Number of vertical blank routines
_vblqueue	ds.l	1	;$456.w		;	Pointer to list of vertical blank routines
colorptr	ds.l	1	;$45a.w		;	If not zero, points to color palette to be loaded
screenpt	ds.l	1	;$45e.w		;	If not zero, points to video ram for next VBL
hdv_init	ds.l	1	;$46a.w		;	Vector for hard disk initialization
swv_vec		ds.l	1	;$46e.w		;	Vector for resolution change
hdv_bpb		ds.l	1	;$472.w		;	Vector for getbpb for hard disk
hdv_rw		ds.l	1	;$476.w		;	Vector for read/write routine for hard disk
hdv_boot	ds.l	1	;$47a.w		;	Vector for hard disk boot
hdv_mediach	ds.l	1	;$47e.w		;	Vector for hard disk media change
conterm		ds.b	1	;$484.w		;	Attribute vector for console output
		even
savptr		ds.l	1	;$4a2.w		;	Pointer to BIOS save registers block
_nflops		ds.w	1	;$4a6.w		;	Number of connected floppy drives
con_state	ds.l	1	;$4a8.w		;	Vector for screen output
_bufl1		ds.l	1	;$4b2.w		;	Pointer to buffer control block for GEMDOS data
_bufl2		ds.l	1	;$4b6.w		;	Pointer to buffer control block for GEMDOS fat/dir
_drvbits	ds.l	1	;$4c2.w		;	Bit allocation for physical drives (bit 0=A, 1=B..)
_dskbufp	ds.l	1	;$4c6.w		;	Pointer to 1024-byte disk buffer
_vbl_lis1	ds.l	1	;$4ce.w		;	Pointer to VBL routine #1
_vbl_lis2	ds.l	1	;$4d2.w		;	Pointer to VBL routine #2
_vbl_lis3	ds.l	1	;$4d6.w		;	Pointer to VBL routine #3
_vbl_lis4	ds.l	1	;$4da.w		;	Pointer to VBL routine #4
_vbl_lis5	ds.l	1	;$4de.w		;	Pointer to VBL routine #5
_vbl_lis6	ds.l	1	;$4e2.w		;	Pointer to VBL routine #6
_vbl_lis7	ds.l	1	;$4e6.w		;	Pointer to VBL routine #7
_vbl_lis8	ds.l	1	;$4ea.w		;	Pointer to VBL routine #8
_dumpflg	ds.w	1	;$4ee.w		;	Flag for screen -> printer dump
end_os		ds.l	1	;$4fa.w		;	Pointer to end of OS
exec_os		ds.l	1	;$4fe.w		;	Pointer to entry point of OS
scr_dump	ds.l	1	;$502.w		;	Pointer to screen dump routine
_p_cookies	ds.l	1	;$5a0.w		;	Pointer to cookie jar
memval3		ds.l	1	;$51a.w		;	If $5555AAAA, reset
_longframe	ds.w	1	;$59e.w		;	If not 0, then not 68000 - use long stack frames
memconf		ds.b	1	$ffff8801.w	;	MMU memory configuration
		even
st_8201		ds.b	1	;$ffff8201.w	;	Video screen memory position (High byte)
		even
st_8203		ds.b	1	;$ffff8203.w	;	Video screen memory position (Mid byte)
		even
st_820a		ds.b	1	;$ffff820a.w	;	Video synchronization mode
		even
;	STE	=	$ffff820d	=	lobase
;	STE	=	$ffff820f	=	linewid
;ste820d		ds.b	1	;$ffff820d.w	;	Video screen memory position (Low byte)
;		even
;ste820f		ds.b	1	;$ffff820f.w	;	Width of a scanline (width in words-1)
;		even
st_8260		ds.b	1	;$ffff8260.w	;	Shifter resolution
		even
;	STE	=	$ffff8265.w	=	hscroll
;ste8265		ds.b	1	;$ffff8265.w	;	Horizontal scroll register (0-15)
;		even
gpip		ds.b	1	;$fffffa01.w	;	Parallel Port Data Register
		even
aer		ds.b	1	;$fffffa03.w	;	Active Edge Register
		even
ddr		ds.b	1	;$fffffa05.w	;	Data Direction
		even
iera		ds.b	1	;$fffffa07.w	;	Interrupt Enable A
		even
ierb		ds.b	1	;$fffffa09.w	;	Interrupt Enable B
		even
ipra		ds.b	1	;$fffffa0b.w	;	Interrupt Pending A
		even
iprb		ds.b	1	;$fffffa0d.w	;	Interrupt Pending B
		even
isra		ds.b	1	;$fffffa0f.w	;	Interrupt In-service A
		even
isrb		ds.b	1	;$fffffa11.w	;	Interrupt In-service B
		even
imra		ds.b	1	;$fffffa13.w	;	Interrupt Mask A
		even
imrb		ds.b	1	;$fffffa15.w	;	Interrupt Mask B
		even
vr		ds.b	1	;$fffffa17.w	;	Vector Register
		even
tacr		ds.b	1	;$fffffa19.w	;	Timer A Control
		even
tbcr		ds.b	1	;$fffffa1b.w	;	Timer B Control
		even
tcdcr		ds.b	1	;$fffffa1d.w	;	Timer C & D Control
		even
tadr		ds.b	1	;$fffffa1f.w	;	Timer A Data
		even
tbdr		ds.b	1	;$fffffa21.w	;	Timer B Data
		even
;tcdr		ds.b	1	;$fffffa23.w	;	Timer C Data
;		even
tddr		ds.b	1	;$fffffa25.w	;	Timer D Data
		even
scr		ds.b	1	;$fffffa27.w	;	Sync Character
		even
ucr		ds.b	1	;$fffffa29.w	;	USART Control
		even
rsr		ds.b	1	;$fffffa2b.w	;	Receiver Status
		even
tsr		ds.b	1	;$fffffa2d.w	;	Transmitter Status
		even
udr		ds.b	1	;$fffffa2f.w	;	USART data
		even
;================================================================================
ld_file
;--------------------------------------------------------------------------------
fopen		move.w	#2,-(sp)
		move.l	f_name(pc),-(sp)
		move.w	#$3d,-(sp)		;fopen
		trap	#1
		addq.l	#8,sp
		tst.l	d0
		bmi.s	f_error

		move.w	d0,handle

fread		move.l	adr_buff(pc),-(sp)
		move.l	#$fffff,-(sp)
		move.w	handle(pc),-(sp)
		move.w	#$3f,-(sp)		;fread
		trap	#1
		lea	12(sp),sp
		tst.l	d0
		bmi.s	f_error

		move.l	d0,f_size

fclose		move.w	handle(pc),-(sp)
		move.w	#$3e,-(sp)		;fclose
		trap	#1
		addq.l	#4,sp
		tst.w	d0
		bmi.s	f_error
		rts
;================================================================================
save_sp		ds.l	1
save4sp		ds.l	1
savessp		ds.l	1

f_error		st	flagerr
		rts

flagerr		ds.b	1
		even

f_name		ds.l	1

prg_n_1		dc.b	"main.prg"
		dc.b	0
		even

adr_buff	ds.l	1

handle		ds.w	1
f_size		ds.l	1
;================================================================================
relog		move.l	f_size(pc),d2
		move.l	adr_buff(pc),a4
		lea	p_tbase(pc),a5
		move.l	a5,d4
		move.l	2(a4),d3
		add.l	6(a4),d3
		tst.w	$1a(a4)
		bne.s	calc_bp
		lea	$1c(a4),a1
		movea.l	a1,a2
		adda.l	2(a4),a2
		adda.l	6(a4),a2
		adda.l	$e(a4),a2
		clr.l	d1
		move.l	(a2)+,d0
		beq.s	calc_bp
.bcle1		add.l	d4,0(a1,d0.l)
.bcle2		move.b	(a2)+,d1
		beq.s	calc_bp
		add.l	d1,d0
		cmp.b	#1,d1
		bne.s	.bcle1
		addi.l	#$fd,d0
		bra.s	.bcle2
calc_bp		movea.l	4(sp),a0
		move.l	2(a4),$c(a0)
		add.l	$c(a0),d4
		move.l	d4,$10(a0)
		move.l	6(a4),$14(a0)
		add.l	$14(a0),d4
		move.l	d4,$18(a0)
		move.l	$a(a4),$1c(a0)
		movea.l	$18(a0),a2
		movea.l	a2,a3
		adda.l	$1c(a0),a3
		movea.l	a4,a0
		adda.l	d2,a0
		cmpa.l	a3,a0
		ble.s	.lbl1
		movea.l	a0,a3
.lbl1		moveq	#(transf-transd)/2-1,d0
		lea	transf(pc),a0
		move.l	a5,-(sp)
.bcle1		move.w	-(a0),-(sp)
		dbf	d0,.bcle1
		lea	$1c(a4),a4
		jmp	jump(pc)
;--------------------------------------------------------------------------------
transd
.bcle2		move.l	(a4)+,(a5)+
		subq.l	#4,d3
		bpl.s	.bcle2
.bcle3		clr.l	(a2)+
		cmpa.l	a2,a3
		bgt.s	.bcle3
		lea	$12(sp),sp
		rts
transf
;================================================================================
intro	dc.w	$a00a

	move.w	#2,-(sp)		;physbase
	trap	#14
	addq.l	#6,sp
	move.l	d0,l00e3

	move.l	#l00f2,d0
	andi.l	#$ffffff00,d0
	addi.l	#$100,d0
	move.l	d0,l00f1

	movea.l	l00f1,a0
	move.w	#$1f3f,d1
l0000	clr.l	(a0)+
	dbf	d1,l0000

	movea.l	l00f1,a0
	lea	l0074,a1
	lea	34(a1),a1
	move.w	#$1dff,d1
l0001	move.l	(a1)+,(a0)+
	dbf	d1,l0001

	movea.l	l00f1,a1
	movea.l	l00e3,a2
	move.w	#$1f3f,d1
l0002	move.l	(a1)+,(a2)+
	dbf	d1,l0002

	movea.l	#l0075,a0
	move.l	#$20,d0
	move.l	#0,d1
	move.l	#2,d2
	move.l	#$20,d3
	lea	l00f3,a2
	move.l	#$e,d4
	bsr	l0050

	movea.l	#l0075,a0
	move.l	#$40,d0
	move.l	#0,d1
	move.l	#2,d2
	move.l	#$20,d3
	lea	l00f4,a2
	move.l	#$e,d4
	bsr	l0050

	movea.l	#l0075,a0
	move.l	#$60,d0
	move.l	#0,d1
	move.l	#2,d2
	move.l	#$20,d3
	lea	l00f5,a2
	move.l	#$e,d4
	bsr	l0050

	movea.l	#l0075,a0
	move.l	#$80,d0
	move.l	#0,d1
	move.l	#2,d2
	move.l	#$20,d3
	lea	l00f6,a2
	move.l	#$e,d4
	bsr	l0050

	movea.l	#l0075,a0
	move.l	#$a0,d0
	move.l	#0,d1
	move.l	#2,d2
	move.l	#$20,d3
	lea	l00f7,a2
	move.l	#$e,d4
	bsr	l0050

	movea.l	#l0075,a0
	move.l	#$c0,d0
	move.l	#0,d1
	move.l	#2,d2
	move.l	#$20,d3
	lea	l00f8,a2
	move.l	#$e,d4
	bsr	l0050

	movea.l	#l0075,a0
	move.l	#$e0,d0
	move.l	#0,d1
	move.l	#2,d2
	move.l	#$20,d3
	lea	l00f9,a2
	move.l	#$e,d4
	bsr	l0050

	move.b	#$e,$484.l

	moveq	#1,d0
	jsr	l0077
	move.l	#l0077+6,$4d2.w

	move.w	#0,l010c
	lea	l0076,a5
	move.b	#0,l00f0
	move.b	#0,l010d
	move.w	#9,l00fc
	bsr	l0011

	jsr	l006b

l0003	addq.w	#1,l010c
	cmpi.w	#$167,l010c
	beq	l0004

	bra	l0005

l0004	move.w	#0,l010c
	lea	l0076,a5
l0005	move.l	(a5)+,l00fa
	move.l	(a5)+,l00fb
	subi.l	#$18,l00fb
	subi.l	#$20,l00fa
	bsr	l0042

	move.w	#8,l00fc
	bsr	l0044

	addi.l	#$20,l00fa
	move.w	#9,l00fc
	bsr	l0044

	addi.l	#$20,l00fa
	move.w	#$a,l00fc
	bsr	l0044
	bsr	l004d
	bsr	l0010

	move.w	#$ff,-(sp)
	move.w	#6,-(sp)		;crawio
	trap	#1
	addq.l	#4,sp

	move.l	d0,d6
	swap	d6
	cmp.b	#$3b,d6
	beq	l000a

	cmp.b	#$3c,d6
	beq	l000b

	cmp.b	#$3d,d6
	beq	l000c

	cmp.b	#$3e,d6
	beq	l000d

	cmp.b	#$3f,d6
	beq	l000e

	cmp.b	#$40,d6
	beq	l000f

	cmp.b	#$44,d6
	beq	l004f

l0006	cmp.b	#$20,d0
	bne	l0003

	bsr	l0040

	move.b	#3,$484.l

	bsr	l0041
	jsr	l006c

	movea.l	l00e3,a0
	move.w	#$1f3f,d1
l0007	clr.l	(a0)+
	dbf	d1,l0007

	jmp	exit(pc)
;========================================
l000a	move.b	#1,l010d
	bra	l0006

l000b	move.b	#2,l010d
	bra	l0006

l000c	move.b	#3,l010d
	bra	l0006

l000d	move.b	#4,l010d
	bra	l0006

l000e	move.b	#$fe,$ff820a.l
	bra	l0006

l000f	move.b	#$fc,$ff820a.l
	bra	l0006

l0010	move.w	#$25,-(sp)		;vsync
	trap	#14
	addq.w	#2,sp
	rts

l0011	move.b	$fffffa07.l,l00e4
	move.b	$fffffa09.l,l00e5
	move.l	$70.l,l00e6
	move.l	$120.l,l00e7
	move.b	$fffffa0d.l,l00e8
	move.b	$fffffa0f.l,l00e9
	move.b	$fffffa11.l,l00ea
	move.b	$fffffa13.l,l00eb
	move.b	$fffffa15.l,l00ec
	move.b	$fffffa1b.l,l00ed
	move.b	$fffffa21.l,l00ee

	move.w	sr,d0

	move.w	#$2700,sr

	move.l	$70.l,l00ef
	move.l	#l0012,$70.l

	move.l	#l0022,$120.l
	ori.b	#1,$fffffa13.l

	move.w	d0,sr
	rts

l0012	cmpi.b	#1,l010d
	beq	l0013

	cmpi.b	#2,l010d
	beq	l0014

	cmpi.b	#3,l010d
	beq	l0015

	cmpi.b	#4,l010d
	beq	l0016

l0013	move.l	#$100,$ffff8240.w
	move.l	#$2000300,$ffff8244.w
	move.l	#$4000500,$ffff8248.w
	move.l	#$6000700,$ffff824c.w
	move.l	#$7300740,$ffff8250.w
	move.l	#$7500760,$ffff8254.w
	move.l	#$7700774,$ffff8258.w
	move.l	#$7750777,$ffff825c.w
	bra	l0017

l0014	move.l	#1,$ffff8240.w
	move.l	#$20003,$ffff8244.w
	move.l	#$40005,$ffff8248.w
	move.l	#$60007,$ffff824c.w
	move.l	#$170027,$ffff8250.w
	move.l	#$370047,$ffff8254.w
	move.l	#$570067,$ffff8258.w
	move.l	#$770777,$ffff825c.w
	bra	l0017

l0015	move.l	#$10,$ffff8240.w
	move.l	#$200030,$ffff8244.w
	move.l	#$400050,$ffff8248.w
	move.l	#$600070,$ffff824c.w
	move.l	#$3730474,$ffff8250.w
	move.l	#$5750576,$ffff8254.w
	move.l	#$6760776,$ffff8258.w
	move.l	#$7770777,$ffff825c.w
	bra	l0017

l0016	move.l	#$10,$ffff8240.w
	move.l	#$200030,$ffff8244.w
	move.l	#$400050,$ffff8248.w
	move.l	#$600070,$ffff824c.w
	move.l	#$710072,$ffff8250.w
	move.l	#$730074,$ffff8254.w
	move.l	#$750076,$ffff8258.w
	move.l	#$770777,$ffff825c.w
	bra	l0017

l0017	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#$4b,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l0018,$120.l
	move.l	l00ef,-(sp)
	rts

l0018	ori.w	#$700,sr

	move.l	#$777,$ffff8240.w
	move.l	#$6660015,$ffff8244.w
	move.l	#$170016,$ffff8248.w
	move.l	#$140013,$ffff824c.w

	addq.b	#1,l00f0
	cmpi.b	#0,l00f0
	beq	l0020

	cmpi.b	#1,l00f0
	beq	l001f

	cmpi.b	#2,l00f0
	beq	l001e

	cmpi.b	#3,l00f0
	beq	l001d

	cmpi.b	#4,l00f0
	beq	l001c

	cmpi.b	#5,l00f0
	beq	l001b

	cmpi.b	#6,l00f0
	beq	l001a

	cmpi.b	#7,l00f0
	beq	l0019

l0019	move.l	#$1110111,$ffff8250.w
	move.l	#$1110111,$ffff8254.w
	move.l	#$2220222,$ffff8258.w
	move.l	#$2220222,$ffff825c.w
	bra	l0021

l001a	move.l	#$1110111,$ffff8250.w
	move.l	#$1110222,$ffff8254.w
	move.l	#$2220222,$ffff8258.w
	move.l	#$2220111,$ffff825c.w
	bra	l0021

l001b	move.l	#$1110111,$ffff8250.w
	move.l	#$2220222,$ffff8254.w
	move.l	#$2220222,$ffff8258.w
	move.l	#$1110111,$ffff825c.w
	bra	l0021

l001c	move.l	#$1110222,$ffff8250.w
	move.l	#$2220222,$ffff8254.w
	move.l	#$2220111,$ffff8258.w
	move.l	#$1110111,$ffff825c.w
	bra	l0021

l001d	move.l	#$2220222,$ffff8250.w
	move.l	#$2220222,$ffff8254.w
	move.l	#$1110111,$ffff8258.w
	move.l	#$1110111,$ffff825c.w
	bra	l0021

l001e	move.l	#$2220222,$ffff8250.w
	move.l	#$2220111,$ffff8254.w
	move.l	#$1110111,$ffff8258.w
	move.l	#$1110222,$ffff825c.w
	bra	l0021

l001f	move.l	#$2220222,$ffff8250.w
	move.l	#$1110111,$ffff8254.w
	move.l	#$1110111,$ffff8258.w
	move.l	#$2220222,$ffff825c.w
	bra	l0021

l0020	move.l	#$2220111,$ffff8250.w
	move.l	#$1110111,$ffff8254.w
	move.l	#$1110222,$ffff8258.w
	move.l	#$2220222,$ffff825c.w

l0021	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#4,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l0022,$120.l
	rte

l0022	ori.w	#$700,sr

	move.l	#$777,$ffff8240.w
	move.l	#$6660015,$ffff8244.w
	move.l	#$170016,$ffff8248.w
	move.l	#$140013,$ffff824c.w

	cmpi.b	#0,l00f0
	beq	l002a

	cmpi.b	#1,l00f0
	beq	l0029

	cmpi.b	#2,l00f0
	beq	l0028

	cmpi.b	#3,l00f0
	beq	l0027

	cmpi.b	#4,l00f0
	beq	l0026

	cmpi.b	#5,l00f0
	beq	l0025

	cmpi.b	#6,l00f0
	beq	l0024

	cmpi.b	#7,l00f0
	beq	l0023

l0023	move.l	#$2220222,$ffff8250.w
	move.l	#$2220222,$ffff8254.w
	move.l	#$3330333,$ffff8258.w
	move.l	#$3330333,$ffff825c.w
	bra	l002b

l0024	move.l	#$2220222,$ffff8250.w
	move.l	#$2220333,$ffff8254.w
	move.l	#$3330333,$ffff8258.w
	move.l	#$3330222,$ffff825c.w
	bra	l002b

l0025	move.l	#$2220222,$ffff8250.w
	move.l	#$3330333,$ffff8254.w
	move.l	#$3330333,$ffff8258.w
	move.l	#$2220222,$ffff825c.w
	bra	l002b

l0026	move.l	#$2220333,$ffff8250.w
	move.l	#$3330333,$ffff8254.w
	move.l	#$3330222,$ffff8258.w
	move.l	#$2220222,$ffff825c.w
	bra	l002b

l0027	move.l	#$3330333,$ffff8250.w
	move.l	#$3330333,$ffff8254.w
	move.l	#$2220222,$ffff8258.w
	move.l	#$2220222,$ffff825c.w
	bra	l002b

l0028	move.l	#$3330333,$ffff8250.w
	move.l	#$3330222,$ffff8254.w
	move.l	#$2220222,$ffff8258.w
	move.l	#$2220333,$ffff825c.w
	bra	l002b

l0029	move.l	#$3330333,$ffff8250.w
	move.l	#$2220222,$ffff8254.w
	move.l	#$2220222,$ffff8258.w
	move.l	#$3330333,$ffff825c.w
	bra	l002b

l002a	move.l	#$3330222,$ffff8250.w
	move.l	#$2220222,$ffff8254.w
	move.l	#$2220333,$ffff8258.w
	move.l	#$3330333,$ffff825c.w

l002b	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#4,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l002c,$120.l
	rte

l002c	ori.w	#$700,sr

	move.l	#$777,$ffff8240.w
	move.l	#$6660015,$ffff8244.w
	move.l	#$170016,$ffff8248.w
	move.l	#$140013,$ffff824c.w

	cmpi.b	#0,l00f0
	beq	l0034

	cmpi.b	#1,l00f0
	beq	l0033

	cmpi.b	#2,l00f0
	beq	l0032

	cmpi.b	#3,l00f0
	beq	l0031

	cmpi.b	#4,l00f0
	beq	l0030

	cmpi.b	#5,l00f0
	beq	l002f

	cmpi.b	#6,l00f0
	beq	l002e

	cmpi.b	#7,l00f0
	beq	l002d

l002d	move.l	#$3330333,$ffff8250.w
	move.l	#$3330333,$ffff8254.w
	move.l	#$4440444,$ffff8258.w
	move.l	#$4440444,$ffff825c.w
	bra	l0035

l002e	move.l	#$3330333,$ffff8250.w
	move.l	#$3330444,$ffff8254.w
	move.l	#$4440444,$ffff8258.w
	move.l	#$4440333,$ffff825c.w
	bra	l0035

l002f	move.l	#$3330333,$ffff8250.w
	move.l	#$4440444,$ffff8254.w
	move.l	#$4440444,$ffff8258.w
	move.l	#$3330333,$ffff825c.w
	bra	l0035

l0030	move.l	#$3330444,$ffff8250.w
	move.l	#$4440444,$ffff8254.w
	move.l	#$4440333,$ffff8258.w
	move.l	#$3330333,$ffff825c.w
	bra	l0035

l0031	move.l	#$4440444,$ffff8250.w
	move.l	#$4440444,$ffff8254.w
	move.l	#$3330333,$ffff8258.w
	move.l	#$3330333,$ffff825c.w
	bra	l0035

l0032	move.l	#$4440444,$ffff8250.w
	move.l	#$4440333,$ffff8254.w
	move.l	#$3330333,$ffff8258.w
	move.l	#$3330444,$ffff825c.w
	bra	l0035

l0033	move.l	#$4440444,$ffff8250.w
	move.l	#$3330333,$ffff8254.w
	move.l	#$3330333,$ffff8258.w
	move.l	#$4440444,$ffff825c.w
	bra	l0035

l0034	move.l	#$4440333,$ffff8250.w
	move.l	#$3330333,$ffff8254.w
	move.l	#$3330444,$ffff8258.w
	move.l	#$4440444,$ffff825c.w

l0035	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#4,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l0036,$120.l
	rte

l0036	ori.w	#$700,sr

	move.l	#$777,$ffff8240.w
	move.l	#$6660015,$ffff8244.w
	move.l	#$170016,$ffff8248.w
	move.l	#$140013,$ffff824c.w

	cmpi.b	#0,l00f0
	beq	l003e

	cmpi.b	#1,l00f0
	beq	l003d

	cmpi.b	#2,l00f0
	beq	l003c

	cmpi.b	#3,l00f0
	beq	l003b

	cmpi.b	#4,l00f0
	beq	l003a

	cmpi.b	#5,l00f0
	beq	l0039

	cmpi.b	#6,l00f0
	beq	l0038

	cmpi.b	#7,l00f0
	beq	l0037

l0037	move.l	#$4440444,$ffff8250.w
	move.l	#$4440444,$ffff8254.w
	move.l	#$5550555,$ffff8258.w
	move.l	#$5550555,$ffff825c.w
	move.b	#$ff,l00f0
	bra	l003f

l0038	move.l	#$4440444,$ffff8250.w
	move.l	#$4440555,$ffff8254.w
	move.l	#$5550555,$ffff8258.w
	move.l	#$5550444,$ffff825c.w
	bra	l003f

l0039	move.l	#$4440444,$ffff8250.w
	move.l	#$5550555,$ffff8254.w
	move.l	#$5550555,$ffff8258.w
	move.l	#$4440444,$ffff825c.w
	bra	l003f

l003a	move.l	#$4440555,$ffff8250.w
	move.l	#$5550555,$ffff8254.w
	move.l	#$5550444,$ffff8258.w
	move.l	#$4440444,$ffff825c.w
	bra	l003f

l003b	move.l	#$5550555,$ffff8250.w
	move.l	#$5550555,$ffff8254.w
	move.l	#$4440444,$ffff8258.w
	move.l	#$4440444,$ffff825c.w
	bra	l003f

l003c	move.l	#$5550555,$ffff8250.w
	move.l	#$5550444,$ffff8254.w
	move.l	#$4440444,$ffff8258.w
	move.l	#$4440555,$ffff825c.w
	bra	l003f

l003d	move.l	#$5550555,$ffff8250.w
	move.l	#$4440444,$ffff8254.w
	move.l	#$4440444,$ffff8258.w
	move.l	#$5550555,$ffff825c.w
	bra	l003f

l003e	move.l	#$5550444,$ffff8250.w
	move.l	#$4440444,$ffff8254.w
	move.l	#$4440555,$ffff8258.w
	move.l	#$5550555,$ffff825c.w

l003f	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	rte

l0040	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	move.b	l00e4,$fffffa07.l
	move.b	l00e5,$fffffa09.l
	move.l	l00e6,$70.l
	move.l	l00e7,$120.l
	move.b	l00e8,$fffffa0d.l
	move.b	l00e9,$fffffa0f.l
	move.b	l00ea,$fffffa11.l
	move.b	l00eb,$fffffa13.l
	move.b	l00ec,$fffffa15.l
	move.b	l00ed,$fffffa1b.l
	move.b	l00ee,$fffffa21.l
	rts

l0041	move.l	#$8080000,$ffff8800.l
	move.l	#$9090000,$ffff8800.l
	move.l	#$a0a0000,$ffff8800.l
	rts

l0042	bsr	l0069

	movea.l	l00f1,a2
	lea	l0074,a1
	lea	34(a1),a1
	move.l	l00fb,d0
	subi.w	#4,d0
	mulu	#$a0,d0
	adda.l	d0,a1
	adda.l	d0,a2
	move.w	#$63f,d1
l0043	move.l	(a1)+,(a2)+
	dbf	d1,l0043
	rts

l0044	move.w	l00fc,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	cmp.w	#9,d0
	bcs	l0045

	cmp.w	#9,d0
	beq	l0046

	cmp.w	#$a,d0
	beq	l0047

	cmp.w	#$b,d0
	beq	l0048

	cmp.w	#$c,d0
	beq	l0049

	cmp.w	#$d,d0
	beq	l0049

	cmp.w	#$e,d0
	beq	l004a

	cmp.w	#$f,d0
	beq	l004b

l0045	lea	l00f9,a0
	bra	l004c

l0046	lea	l00f8,a0
	bra	l004c

l0047	lea	l00f7,a0
	bra	l004c

l0048	lea	l00f6,a0
	bra	l004c

l0049	lea	l00f5,a0
	bra	l004c

l004a	lea	l00f4,a0
	bra	l004c

l004b	lea	l00f3,a0
	bra	l004c

l004c	move.l	l00fa,d0
	move.l	l00fb,d1
	movea.l	l00f1,a4
	bsr	l0057
	rts

l004d	movea.l	l00f1,a1
	movea.l	l00e3,a2
	move.l	l00fb,d0
	subi.w	#4,d0
	mulu	#$a0,d0
	adda.l	d0,a1
	adda.l	d0,a2
	move.w	#$63f,d1
l004e	move.l	(a1)+,(a2)+
	dbf	d1,l004e

	bsr	l006a
	rts

l004f	move.w	#1,-(sp)		;cconin
	trap	#1
	addq.l	#2,sp

	bra	l0006

l0050	lea	(a2),a4
	lea	30(a2),a2
	move.l	d4,(a4)+
	lsr.l	#4,d0
	lsl.l	#3,d0
	mulu	#$a0,d1
	add.l	d0,d1
	adda.l	d1,a0
	move.w	d2,d7
	lsl.l	#3,d7
	move.l	d7,d6
	neg.l	d7
	addi.l	#$a0,d7
	subq.l	#8,d7
	move.l	d7,(a4)+
	addq.l	#8,d7
	subq.l	#1,d2
	subq.l	#1,d3
	move.l	d2,(a4)+
	move.l	d3,(a4)+
	moveq	#$ff,d0
	moveq	#3,d6
l0051	btst	d6,d4
	beq	l0052

	addq.l	#1,d0
	move.l	d6,d1
	lsl.l	#1,d1
	neg.l	d1
	addq.l	#6,d1
	move.w	d1,(a4)+
l0052	dbf	d6,l0051

	move.l	d0,d6
	addq.l	#1,d6
	lsl.l	#1,d6
	suba.l	d6,a4
	adda.l	#8,a4
	move.l	d0,(a4)
	move.w	d3,d1
l0053	move.l	d2,d0
l0054	moveq	#3,d6
l0055	btst	d6,d4
	beq	l0056

	move.w	(a0),(a2)+
l0056	lea	2(a0),a0
	dbf	d6,l0055
	dbf	d0,l0054

	adda.l	d7,a0
	dbf	d1,l0053
	rts

l0057	lea	30(a0),a2
	move.l	4(a0),l0070
	move.l	8(a0),l0072
	move.l	#0,l0071
	move.l	d0,d6
	andi.l	#$f,d6
	neg.l	d6
	addi.l	#$10,d6
	move.b	#0,l0073
	lsr.l	#4,d0
	move.l	d0,d4
	move.l	d0,d5
	add.l	8(a0),d5
	cmpi.b	#$13,d5
	bcs	l0058

	neg.l	d4
	addi.l	#$13,d4
	move.l	d4,l0072
	neg.l	d4
	add.l	8(a0),d4
	move.l	24(a0),d5
	addq.l	#1,d5
	lsl.l	#1,d5
	mulu	d4,d5
	move.l	d5,l0071
	lsl.l	#3,d4
	add.l	d4,l0070
	move.b	#1,l0073
l0058	lsl.l	#3,d0
	move.l	12(a0),d7
	move.l	d1,d4
	move.l	d1,d5
	add.l	12(a0),d5
	cmpi.w	#$c8,d5
	bcs	l0059

	neg.l	d4
	addi.l	#$c8,d4
	move.l	d4,d7
l0059	mulu	#$a0,d1
	add.l	d0,d1
	adda.l	d1,a4
	move.l	24(a0),d4
	cmpi.b	#2,d4
	beq	l005d

	cmpi.b	#1,d4
	beq	l0061

	tst.b	d4
	beq	l0065

l005a	move.l	d7,l006f
	move.l	l0072,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
l005b	clr.w	d1
	clr.w	d2
	clr.w	d3
	clr.w	d4
	moveq	#0,d5
	clr.w	d7
	move.w	(a2)+,d5
	lsl.l	d6,d5
	or.l	d5,d7
	or.l	d5,d1
	swap	d1
	moveq	#0,d5
	move.w	(a2)+,d5
	lsl.l	d6,d5
	or.l	d5,d7
	or.l	d5,d2
	swap	d2
	moveq	#0,d5
	move.w	(a2)+,d5
	lsl.l	d6,d5
	or.l	d5,d7
	or.l	d5,d3
	swap	d3
	moveq	#0,d5
	move.w	(a2)+,d5
	lsl.l	d6,d5
	or.l	d5,d7
	or.l	d5,d4
	swap	d4
	moveq	#0,d5
	swap	d7
	not.w	d7
	and.w	d7,(a4)
	or.w	d1,(a4)+
	and.w	d7,(a4)
	or.w	d2,(a4)+
	and.w	d7,(a4)
	or.w	d3,(a4)+
	and.w	d7,(a4)
	or.w	d4,(a4)+
	dbf	d0,l005b

	adda.l	l0071,a2
	tst.b	l0073
	bne	l005c

	swap	d7
	swap	d1
	swap	d2
	swap	d3
	swap	d4
	not.w	d7
	and.w	d7,(a4)
	or.w	d1,(a4)+
	and.w	d7,(a4)
	or.w	d2,(a4)+
	and.w	d7,(a4)
	or.w	d3,(a4)+
	and.w	d7,(a4)
	or.w	d4,(a4)+
	lea	-8(a4),a4
l005c	addq.l	#8,a4
	adda.l	l0070,a4
	move.l	l006f,d7
	dbf	d7,l005a
	rts

l005d	lea	(a4),a1
	lea	(a4),a5
	lea	(a4),a6
	moveq	#0,d4
	move.w	16(a0),d4
	adda.l	d4,a4
	move.w	18(a0),d4
	adda.l	d4,a5
	move.w	20(a0),d4
	adda.l	d4,a6
l005e	move.l	d7,l006f
	move.l	l0072,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
l005f	clr.w	d1
	clr.w	d2
	clr.w	d3
	moveq	#0,d5
	clr.w	d7
	move.w	(a2)+,d5
	lsl.l	d6,d5
	or.l	d5,d7
	or.l	d5,d1
	swap	d1
	moveq	#0,d5
	move.w	(a2)+,d5
	lsl.l	d6,d5
	or.l	d5,d7
	or.l	d5,d2
	swap	d2
	moveq	#0,d5
	move.w	(a2)+,d5
	lsl.l	d6,d5
	or.l	d5,d7
	or.l	d5,d3
	swap	d3
	moveq	#0,d5
	swap	d7
	not.w	d7
	and.w	d7,(a1)+
	and.w	d7,(a1)+
	and.w	d7,(a1)+
	and.w	d7,(a1)+
	or.w	d1,(a4)
	or.w	d2,(a5)
	or.w	d3,(a6)
	addq.l	#8,a4
	addq.l	#8,a5
	addq.l	#8,a6
	dbf	d0,l005f

	adda.l	l0071,a2
	tst.b	l0073
	bne	l0060

	swap	d7
	swap	d1
	swap	d2
	swap	d3
	not.w	d7
	and.w	d7,(a1)
	and.w	d7,2(a1)
	and.w	d7,4(a1)
	and.w	d7,6(a1)
	or.w	d1,(a4)
	or.w	d2,(a5)
	or.w	d3,(a6)
l0060	addq.l	#8,a1
	addq.l	#8,a4
	addq.l	#8,a5
	addq.l	#8,a6
	adda.l	l0070,a1
	adda.l	l0070,a4
	adda.l	l0070,a5
	adda.l	l0070,a6
	move.l	l006f,d7
	dbf	d7,l005e
	rts

l0061	lea	(a4),a1
	lea	(a4),a5
	moveq	#0,d4
	move.w	16(a0),d4
	adda.l	d4,a4
	move.w	18(a0),d4
	adda.l	d4,a5
l0062	move.l	d7,l006f
	move.l	l0072,d0
	moveq	#0,d1
	moveq	#0,d2
l0063	clr.w	d1
	clr.w	d2
	moveq	#0,d5
	clr.w	d7
	move.w	(a2)+,d5
	lsl.l	d6,d5
	or.l	d5,d7
	or.l	d5,d1
	swap	d1
	moveq	#0,d5
	move.w	(a2)+,d5
	lsl.l	d6,d5
	or.l	d5,d7
	or.l	d5,d2
	swap	d2
	moveq	#0,d5
	swap	d7
	not.w	d7
	and.w	d7,(a1)+
	and.w	d7,(a1)+
	and.w	d7,(a1)+
	and.w	d7,(a1)+
	or.w	d1,(a4)
	or.w	d2,(a5)
	addq.l	#8,a4
	addq.l	#8,a5
	dbf	d0,l0063

	adda.l	l0071,a2
	tst.b	l0073
	bne	l0064

	swap	d7
	swap	d1
	swap	d2
	not.w	d7
	and.w	d7,(a1)
	and.w	d7,2(a1)
	and.w	d7,4(a1)
	and.w	d7,6(a1)
	or.w	d1,(a4)
	or.w	d2,(a5)
l0064	addq.l	#8,a4
	addq.l	#8,a5
	addq.l	#8,a1
	adda.l	l0070,a1
	adda.l	l0070,a4
	adda.l	l0070,a5
	move.l	l006f,d7
	dbf	d7,l0062
	rts

l0065	lea	(a4),a1
	moveq	#0,d4
	move.w	16(a0),d4
	adda.l	d4,a4
l0066	move.l	d7,l006f
	move.l	l0072,d0
	moveq	#0,d1
l0067	clr.w	d1
	moveq	#0,d5
	clr.w	d7
	move.w	(a2)+,d5
	lsl.l	d6,d5
	or.l	d5,d7
	or.l	d5,d1
	swap	d1
	moveq	#0,d5
	swap	d7
	not.w	d7
	and.w	d7,(a1)+
	and.w	d7,(a1)+
	and.w	d7,(a1)+
	and.w	d7,(a1)+
	or.w	d1,(a4)
	addq.l	#8,a4
	dbf	d0,l0067

	adda.l	l0071,a2
	tst.b	l0073
	bne	l0068

	swap	d7
	swap	d1
	not.w	d7
	and.w	d7,(a1)
	and.w	d7,2(a1)
	and.w	d7,4(a1)
	and.w	d7,6(a1)
	or.w	d1,(a4)
l0068	addq.l	#8,a4
	addq.l	#8,a1
	adda.l	l0070,a4
	adda.l	l0070,a1
	move.l	l006f,d7
	dbf	d7,l0066
	rts

l0069	move.l	d0,l00fd
	move.l	d1,l00fe
	move.l	d2,l00ff
	move.l	d3,l0100
	move.l	d4,l0101
	move.l	d5,l0102
	move.l	d6,l0103
	move.l	d7,l0104
	move.l	a0,l0105
	move.l	a1,l0106
	move.l	a2,l0107
	move.l	a3,l0108
	move.l	a4,l0109
	move.l	a5,l010a
	move.l	a6,l010b
	rts

l006a	move.l	l00fd,d0
	move.l	l00fe,d1
	move.l	l00ff,d2
	move.l	l0100,d3
	move.l	l0101,d4
	move.l	l0102,d5
	move.l	l0103,d6
	move.l	l0104,d7
	movea.l	l0105,a0
	movea.l	l0106,a1
	movea.l	l0107,a2
	movea.l	l0108,a3
	movea.l	l0109,a4
	movea.l	l010a,a5
	movea.l	l010b,a6
	rts

l006b	pea	l006d
	move.w	#1,-(sp)
	move.w	#$19,-(sp)		;ikbdws
	trap	#14
	addq.l	#8,sp
	rts

l006c	pea	l006e
	move.w	#1,-(sp)
	move.w	#$19,-(sp)		;ikbdws
	trap	#14
	addq.l	#8,sp
	rts

l006d	dc.b	$14
l006e	dc.b	$15,$08,$00

l006f	dcb.w	2
l0070	dcb.w	2
l0071	dcb.w	2
l0072	dcb.w	2
l0073	dc.b	$00,$00

l0074	incbin	l0074.pi1
l0075	incbin	l0075
l0076	incbin	l0076
l0077	incbin	l0077.mus

;========================================
	bss
;========================================
l00e3	ds.b	8
l00e4	ds.w	1
l00e5	ds.w	1
l00e6	ds.l	1
l00e7	ds.l	1
l00e8	ds.w	1
l00e9	ds.w	1
l00ea	ds.w	1
l00eb	ds.w	1
l00ec	ds.w	1
l00ed	ds.w	1
l00ee	ds.b	36
l00ef	ds.l	1
l00f0	ds.w	1
l00f1	ds.l	1
l00f2	ds.b	32256
l00f3	ds.b	8000
l00f4	ds.b	8000
l00f5	ds.b	8000
l00f6	ds.b	8000
l00f7	ds.b	8000
l00f8	ds.b	8000
l00f9	ds.b	8000
l00fa	ds.l	1
l00fb	ds.l	1
l00fc	ds.w	1
l00fd	ds.l	1
l00fe	ds.l	1
l00ff	ds.l	1
l0100	ds.l	1
l0101	ds.l	1
l0102	ds.l	1
l0103	ds.l	1
l0104	ds.l	1
l0105	ds.l	1
l0106	ds.l	1
l0107	ds.l	1
l0108	ds.l	1
l0109	ds.l	1
l010a	ds.l	1
l010b	ds.l	1
l010c	ds.w	1
l010d	ds.w	1
;================================================================================
buffer
;================================================================================
zuend		end
;================================================================================