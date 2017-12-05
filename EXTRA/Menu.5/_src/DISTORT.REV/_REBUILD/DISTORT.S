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

	bsr	l0009

	move.w	#$1f,l0016
	move.l	#l0026,l0013
	move.l	#l0029,l0014
	move.l	#l0019,l0015
	bsr	l000c

	clr.w	$ffff8240.l

	move.l	#l0008,$120.l

	move.b	#8,$fffffa1b.l
	move.b	#1,$fffffa21.l
	move.b	#1,$fffffa07.l
	move.b	#$40,$fffffa09.l
	move.b	#1,$fffffa13.l
	move.b	#$40,$fffffa15.l

	move.l	#l0004,$70.l

	movea.l	$44e.l,a0
	lea	l0024,a1
	move.w	#$1f3f,d0
l0000	move.l	(a1)+,(a0)+
	dbf	d0,l0000

l0001	cmpi.b	#$39,$fffffc02.w
	bne.s	l0001

	bsr	l000b

	move.w	#0,$ffff8240.l
	move.w	#$777,$ffff825e.l

	pea	l0018
	clr.w	-(sp)
	move.w	#$19,-(sp)		;ikbdws
	trap	#14

	jmp	exit(pc)
;========================================
l0004	movem.l	a0-a6/d0-d7,-(sp)

	lea	l0026,a1
	move.l	a1,l0013
	lea	30(a1),a0
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1
	movem.l	(a0)+,a2-a6/d0-d7
	movem.l	a2-a6/d0-d7,(a1)
	adda.l	#$34,a1

	movea.l	l0013(pc),a0
	lea	$ffff8242.l,a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.w	(a0)+,(a1)
	move.l	a0,l0013
	movea.l	l0014(pc),a0
	subq.w	#1,l0016
	bpl	l0007

	move.w	#$1f,l0016
	moveq	#0,d0
	movea.l	l0015(pc),a0
	move.b	(a0)+,d0
	bne	l0005

	lea	l0019(pc),a0
	move.b	(a0)+,d0
l0005	move.l	a0,l0015
	subi.w	#$41,d0
	bpl	l0006

	lea	l0029,a0
	bra	l0007

l0006	add.w	d0,d0
	add.w	d0,d0
	lea	l001a(pc),a0
	movea.l	0(a0,d0.w),a0
l0007	lea	l0027,a1
	movem.l	(a0)+,d0-d6
	movem.l	d0-d6,(a1)
	move.w	(a0)+,28(a1)
	move.l	a0,l0014

	movem.l	(sp)+,a0-a6/d0-d7
	rte

l0008	move.l	a0,-(sp)
	move.l	a1,-(sp)

	movea.l	l0013(pc),a0
	lea	$ffff8242.l,a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.w	(a0)+,(a1)
	move.l	a0,l0013

	movea.l	(sp)+,a1
	movea.l	(sp)+,a0

	bclr	#0,$fffffa0f.l
	rte

l0009	bsr	l000a

	pea	l0017
	clr.w	-(sp)
	move.w	#$19,-(sp)		;ikbdws
	trap	#14
	clr.w	-(sp)

	move.l	#$ffffffff,-(sp)
	move.l	#$ffffffff,-(sp)
	move.w	#5,-(sp)		;setscreen
	trap	#14

	move.w	#$25,-(sp)		;vsync
	trap	#14
	adda.l	#$16,sp
	rts

l000a	move.b	$fffffa1b.l,l004e
	move.b	$fffffa21.l,l004f
	move.b	$fffffa07.l,l0050
	move.b	$fffffa09.l,l0051
	move.b	$fffffa13.l,l0052
	move.b	$fffffa15.l,l0053

	move.l	$70.l,l0054
	rts

l000b	move.b	l004e,$fffffa1b.l
	move.b	l004f,$fffffa21.l
	move.b	l0050,$fffffa07.l
	move.b	l0051,$fffffa09.l
	move.b	l0052,$fffffa13.l
	move.b	l0053,$fffffa15.l
	move.l	l0054,$70.l
	rts

l000c	lea	l001b,a0
	lea	l0025+34,a1
l000d	move.l	(a0)+,d0
	bmi	l0012

	movem.l	(a0)+,a2-a4
	move.w	#$1f,d1
l000e	move.w	#$e,d2
	move.w	0(a1,d0.w),d3
l000f	lsl.w	#1,d3
	bcc	l0010

	move.w	(a4)+,(a2)+
	addq.w	#2,a3
	bra	l0011

l0010	move.w	(a3)+,(a2)+
	addq.w	#2,a4
l0011	dbf	d2,l000f

	suba.w	#$1e,a3
	suba.w	#$1e,a4
	addi.w	#$a0,d0
	dbf	d1,l000e

	bra	l000d
l0012	rts

l0013	dcb.w	2
l0014	dcb.w	2
l0015	dcb.w	2
l0016	dc.b	$00,$00
;========================================
	data
;========================================
l0017	dc.b	$12
l0018	dc.b	$08

l0019	dc.b	'WELCOME TO THE DISTORT SCREEN [['
	dc.b	'\\\    ^   NOT BAD NO ]   a CODE'
	dc.b	' WAS bAS USUALc DONE BY STRIX ` '
	dc.b	' GREETINGS TO THE B\M\G\ MEMBERS'
	dc.b	' ^ ESPECIALY TO ATAKID FOR HIS B'
	dc.b	'OOKS [[[ AND FOR THE TESTS ON HI'
	dc.b	'S ST [[ ^  SPECIAL GREETINGS TO '
	dc.b	'PACER ^ FOR HIS SYBEX BOOK ABOUT'
	dc.b	' C a  IT IS TIME TO WRAP NOW\\\ '
	dc.b	' SEE YOU ON ANOTHER SCREEN\\\  `'
	dc.b	'STRIX`^  ',0

l001a	dc.l	l002a
	dc.l	l002b
	dc.l	l002c
	dc.l	l002d
	dc.l	l002e
	dc.l	l002f
	dc.l	l0030
	dc.l	l0031
	dc.l	l0032
	dc.l	l0033
	dc.l	l0034
	dc.l	l0035
	dc.l	l0036
	dc.l	l0037
	dc.l	l0038
	dc.l	l0039
	dc.l	l003a
	dc.l	l003b
	dc.l	l003c
	dc.l	l003d
	dc.l	l003e
	dc.l	l003f
	dc.l	l0040
	dc.l	l0041
	dc.l	l0042
	dc.l	l0043
	dc.l	l0044
	dc.l	l0045
	dc.l	l0046
	dc.l	l0047
	dc.l	l0048
	dc.l	l0049
	dc.l	l004a
	dc.l	l004b
	dc.l	l004c
	dc.l	l004d

l001b	dcb.w	2
	dc.l	l002a
	dc.l	l0028
	dc.l	l001c
	dc.b	$00,$00,$00,$08
	dc.l	l002b
	dc.l	l0028
	dc.l	l0022
	dc.b	$00,$00,$00,$10
	dc.l	l002c
	dc.l	l0028
	dc.l	l001e
	dc.b	$00,$00,$00,$18
	dc.l	l002d
	dc.l	l0028
	dc.l	l001c
	dc.b	$00,$00,$00,$20
	dc.l	l002e
	dc.l	l0028
	dc.l	l0020
	dc.b	$00,$00,$00,$28
	dc.l	l002f
	dc.l	l0028
	dc.l	l001d
	dc.b	$00,$00,$00,$30
	dc.l	l0030
	dc.l	l0028
	dc.l	l001c
	dc.b	$00,$00,$00,$38
	dc.l	l0031
	dc.l	l0028
	dc.l	l001e
	dc.b	$00,$00,$00,$40
	dc.l	l0032
	dc.l	l0028
	dc.l	l001f
	dc.b	$00,$00,$00,$48
	dc.l	l0033
	dc.l	l0028
	dc.l	l0021
	dc.b	$00,$00,$00,$50
	dc.l	l0034
	dc.l	l0028
	dc.l	l001d
	dc.b	$00,$00,$00,$58
	dc.l	l0035
	dc.l	l0028
	dc.l	l001f
	dc.b	$00,$00,$00,$60
	dc.l	l0036
	dc.l	l0028
	dc.l	l001e
	dc.b	$00,$00,$00,$68
	dc.l	l0037
	dc.l	l0028
	dc.l	l001d
	dc.b	$00,$00,$00,$70
	dc.l	l0038
	dc.l	l0028
	dc.l	l0020
	dc.b	$00,$00,$00,$78
	dc.l	l0039
	dc.l	l0028
	dc.l	l0021
	dc.b	$00,$00,$00,$80
	dc.l	l003a
	dc.l	l0028
	dc.l	l001f
	dc.b	$00,$00,$00,$88
	dc.l	l003b
	dc.l	l0028
	dc.l	l001f
	dc.b	$00,$00,$00,$90
	dc.l	l003c
	dc.l	l0028
	dc.l	l001c
	dc.b	$00,$00,$00,$98
	dc.l	l003d
	dc.l	l0028
	dc.l	l0023
	dc.b	$00,$00,$14,$00
	dc.l	l003e
	dc.l	l0028
	dc.l	l001d
	dc.b	$00,$00,$14,$08
	dc.l	l003f
	dc.l	l0028
	dc.l	l001d
	dc.b	$00,$00,$14,$10
	dc.l	l0040
	dc.l	l0028
	dc.l	l001c
	dc.b	$00,$00,$14,$18
	dc.l	l0041
	dc.l	l0028
	dc.l	l001c
	dc.b	$00,$00,$14,$20
	dc.l	l0042
	dc.l	l0028
	dc.l	l001f
	dc.b	$00,$00,$14,$28
	dc.l	l0043
	dc.l	l0028
	dc.l	l0022
	dc.b	$00,$00,$14,$98
	dc.l	l0029
	dc.l	l0028
	dc.l	l0028
	dc.b	$00,$00,$14,$30
	dc.l	l0044
	dc.l	l0028
	dc.l	l001e
	dc.b	$00,$00,$14,$38
	dc.l	l0045
	dc.l	l0028
	dc.l	l0022
	dc.b	$00,$00,$14,$40
	dc.l	l0046
	dc.l	l0028
	dc.l	l0020
	dc.b	$00,$00,$14,$48
	dc.l	l0047
	dc.l	l0028
	dc.l	l001e
	dc.b	$00,$00,$14,$50
	dc.l	l0048
	dc.l	l0028
	dc.l	l0023
	dc.b	$00,$00,$14,$58
	dc.l	l0049
	dc.l	l0028
	dc.l	l001e
	dc.b	$00,$00,$14,$60
	dc.l	l004a
	dc.l	l0028
	dc.l	l001e
	dc.b	$00,$00,$14,$68
	dc.l	l004b
	dc.l	l0028
	dc.l	l001d
	dc.b	$00,$00,$14,$70
	dc.l	l004c
	dc.l	l0028
	dc.l	l001d
	dc.b	$00,$00,$14,$78
	dc.l	l004d
	dc.l	l0028
	dc.l	l001c
	dc.b	$ff,$ff,$ff,$ff

l001c	dc.b	$07,$07,$07,$06,$07,$05,$07,$04
	dc.b	$07,$03,$07,$02,$07,$01,$07,$00
	dc.b	$07,$10,$07,$20,$07,$30,$07,$40
	dc.b	$07,$50,$07,$60,$07,$70
l001d	dc.b	$00,$01,$01,$12,$02,$23,$03,$34
	dc.b	$04,$45,$05,$56,$06,$67,$07,$77
	dc.b	$06,$67,$05,$56,$04,$45,$03,$34
	dc.b	$02,$23,$01,$12,$00,$01
l001e	dc.b	$07,$00,$07,$30,$07,$50,$07,$70
	dc.b	$04,$70,$00,$70,$00,$75,$00,$77
	dc.b	$00,$57,$00,$27,$00,$07,$02,$07
	dc.b	$05,$07,$07,$07,$07,$04
l001f	dc.b	$00,$02,$01,$03,$02,$14,$02,$25
	dc.b	$02,$36,$02,$47,$04,$57,$07,$50
	dc.b	$07,$40,$06,$20,$05,$10,$04,$00
	dc.b	$03,$00,$02,$00,$01,$00
l0020	dc.b	$07,$00,$07,$10,$07,$20,$07,$30
	dc.b	$07,$40,$07,$50,$07,$60,$07,$70
	dc.b	$00,$77,$00,$67,$00,$57,$00,$47
	dc.b	$00,$37,$00,$27,$00,$17
l0021	dc.b	$00,$70,$00,$71,$00,$72,$00,$73
	dc.b	$00,$74,$00,$75,$00,$76,$00,$77
	dc.b	$00,$67,$00,$57,$00,$47,$00,$37
	dc.b	$00,$27,$00,$17,$00,$07
l0022	dc.b	$00,$01,$01,$12,$02,$23,$03,$34
	dc.b	$04,$45,$05,$56,$06,$67,$07,$77
	dc.b	$07,$75,$07,$74,$07,$63,$07,$52
	dc.b	$07,$41,$06,$30,$05,$20
l0023	dc.b	$00,$00,$01,$11,$02,$22,$03,$33
	dc.b	$04,$44,$05,$55,$06,$66,$07,$77
	dc.b	$06,$66,$05,$55,$04,$44,$03,$33
	dc.b	$02,$22,$01,$11,$00,$00,$00,$00
	dc.b	$00,$00,$07,$00,$07,$11,$07,$22
	dc.b	$07,$33,$07,$44,$07,$55,$07,$66
	dc.b	$07,$77,$06,$67,$05,$57,$04,$47
	dc.b	$03,$37,$02,$27,$01,$17,$00,$07

l0024	incbin	l0024
l0025	incbin	l0025

l0026	dcb.w	2985
l0027	dcb.w	45
l0028	dcb.w	16
;========================================
	bss
;========================================
l0029	ds.b	960
l002a	ds.b	960
l002b	ds.b	960
l002c	ds.b	960
l002d	ds.b	960
l002e	ds.b	960
l002f	ds.b	960
l0030	ds.b	960
l0031	ds.b	960
l0032	ds.b	960
l0033	ds.b	960
l0034	ds.b	960
l0035	ds.b	960
l0036	ds.b	960
l0037	ds.b	960
l0038	ds.b	960
l0039	ds.b	960
l003a	ds.b	960
l003b	ds.b	960
l003c	ds.b	960
l003d	ds.b	960
l003e	ds.b	960
l003f	ds.b	960
l0040	ds.b	960
l0041	ds.b	960
l0042	ds.b	960
l0043	ds.b	960
l0044	ds.b	960
l0045	ds.b	960
l0046	ds.b	960
l0047	ds.b	960
l0048	ds.b	960
l0049	ds.b	960
l004a	ds.b	960
l004b	ds.b	960
l004c	ds.b	960
l004d	ds.b	960
l004e	ds.w	1
l004f	ds.w	1
l0050	ds.w	1
l0051	ds.w	1
l0052	ds.w	1
l0053	ds.w	1
l0054	ds.b	24
;================================================================================
buffer
;================================================================================
zuend		end
;================================================================================