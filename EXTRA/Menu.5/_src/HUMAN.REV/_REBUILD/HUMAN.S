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
intro	move.b	#$e,$484.l

	move.w	#1,d0
	jsr	l005e+44
	move.l	#l005e+44+8,$4d2.l

	dc.W	$a00a

	pea	l0053+2
	move.w	#6,-(sp)		;setpallete
	trap	#14
	addq.l	#2,sp

	move.w	#2,-(sp)		;physbase
	trap	#14
	addq.l	#2,sp

	movea.l	d0,a1
	move.l	d0,l00f8
	move.w	#$4fce,l00f9
	move.w	#$1f3f,d1
l0000	clr.l	(a1)+
	dbf	d1,l0000

	move.w	#$50,l00fc
	move.w	#3,d5
l0001	addi.w	#$10,l00fc
	bsr	l004b

	move.w	#5,d1
	bsr	l0036

	dbf	d5,l0001

	move.w	#2,d5
l0002	subi.w	#$10,l00fc
	bsr	l004b

	move.w	#5,d1
	bsr	l0036

	dbf	d5,l0002

	move.w	#$13f0,l00fb
	move.w	#3,d5
l0003	addi.w	#$10,l00fb
	bsr	l004a

	move.w	#$a,d1
	bsr	l0036

	dbf	d5,l0003

	move.w	#4,d5
l0004	bsr	l0049

	subi.w	#$1d,l00f9
	move.w	#$ffc0,l00fa
	move.w	#2,d4
l0005	addi.w	#$40,l00fa
	bsr	l0048

	move.w	#8,d1
	bsr	l0036

	dbf	d4,l0005
	dbf	d5,l0004

	addi.w	#$10,l00fb
	bsr	l004a

	addi.w	#4,l00f9
	lea	l00c0,a5
	bsr	l0037
	bsr	l0051
	bsr	l004c

	move.l	l00f8,l010a
	move.l	l00f8,l010b
	move.l	l00f8,l010c
	move.l	l00f8,l010d
	move.l	l00f8,l010e
	addi.l	#$160,l010b
	addi.l	#$2d0,l010c
	addi.l	#$440,l010d
	addi.l	#$540,l010e
	move.l	l00f8,l010f
	addi.l	#$c80,l010f
	move.l	l00f8,l0110
	addi.l	#$c90,l0110
	move.l	l00f8,l0111
	addi.l	#$ca0,l0111
	move.l	l00f8,l0112
	addi.l	#$c98,l0112
	move.l	l00f8,l0113
	addi.l	#$fa8,l0113
	move.b	#0,l0116
	move.b	#0,l0117
	move.b	#4,l0118
	move.b	#1,l0119

l0006	bsr	l0035

	movea.l	l010a,a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	move.l	l0053+34+5280,(a2)+
	move.l	l0053+34+5284,(a2)+
	addi.l	#8,l010a
	movea.l	l00f8,a1
	lea	152(a1),a1
	cmpa.l	l010a,a1
	beq	l0007

	bra	l0008

l0007	lea	-8(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	move.l	l00f8,l010a
l0008	movea.l	l010b,a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	move.l	l0053+34+5280,(a2)+
	move.l	l0053+34+5284,(a2)+
	addi.l	#8,l010b
	movea.l	l00f8,a1
	lea	472(a1),a1
	cmpa.l	l010b,a1
	beq	l0009

	bra	l000a

l0009	lea	-8(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	move.l	l00f8,l010b
	addi.l	#$140,l010b
l000a	movea.l	l010c,a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	move.l	l0053+34+5280,(a2)+
	move.l	l0053+34+5284,(a2)+
	addi.l	#8,l010c
	movea.l	l00f8,a1
	lea	792(a1),a1
	cmpa.l	l010c,a1
	beq	l000b

	bra	l000c

l000b	lea	-8(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	move.l	l00f8,l010c
	addi.l	#$280,l010c
l000c	movea.l	l010d,a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	move.l	l0053+34+5280,(a2)+
	move.l	l0053+34+5284,(a2)+
	addi.l	#8,l010d
	movea.l	l00f8,a1
	lea	1112(a1),a1
	cmpa.l	l010d,a1
	beq	l000d

	bra	l000e

l000d	lea	-8(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	move.l	l00f8,l010d
	addi.l	#$3c0,l010d
l000e	movea.l	l010e,a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	move.l	l0053+34+5280,(a2)+
	move.l	l0053+34+5284,(a2)+
	addi.l	#8,l010e
	movea.l	l00f8,a1
	lea	1432(a1),a1
	cmpa.l	l010e,a1
	beq	l000f

	bra	l0010

l000f	lea	-8(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	move.l	l00f8,l010e
	addi.l	#$500,l010e
l0010	movea.l	l010f,a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	-112(a2),a2
	lea	1272(a2),a2
	move.l	l0053+34+5440,(a2)+
	move.l	l0053+34+5444,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5440,(a2)+
	move.l	l0053+34+5444,(a2)+
	lea	-112(a2),a2
	addi.l	#$500,l010f
	movea.l	l00f8,a1
	lea	14400(a1),a1
	cmpa.l	l010f,a1
	bls	l0011

	bra	l0012

l0011	lea	-8(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	-112(a2),a2
	move.l	l00f8,l010f
	addi.l	#$c80,l010f
l0012	movea.l	l0110,a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	-112(a2),a2
	lea	632(a2),a2
	move.l	l0053+34+5440,(a2)+
	move.l	l0053+34+5444,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5440,(a2)+
	move.l	l0053+34+5444,(a2)+
	lea	-112(a2),a2
	addi.l	#$280,l0110
	movea.l	l00f8,a1
	lea	14400(a1),a1
	cmpa.l	l0110,a1
	bls	l0013

	bra	l0014

l0013	lea	-8(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	-112(a2),a2
	move.l	l00f8,l0110
	addi.l	#$c90,l0110
l0014	movea.l	l0111,a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	-112(a2),a2
	lea	312(a2),a2
	move.l	l0053+34+5440,(a2)+
	move.l	l0053+34+5444,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5440,(a2)+
	move.l	l0053+34+5444,(a2)+
	lea	-112(a2),a2
	addi.l	#$140,l0111
	movea.l	l00f8,a1
	lea	14400(a1),a1
	cmpa.l	l0111,a1
	bls	l0015

	bra	l0016

l0015	lea	-8(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	-112(a2),a2
	move.l	l00f8,l0111
	addi.l	#$ca0,l0111
l0016	movea.l	l0112,a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	-112(a2),a2
	lea	952(a2),a2
	move.l	l0053+34+5440,(a2)+
	move.l	l0053+34+5444,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5440,(a2)+
	move.l	l0053+34+5444,(a2)+
	lea	-112(a2),a2
	addi.l	#$3c0,l0112
	movea.l	l00f8,a1
	lea	14400(a1),a1
	cmpa.l	l0112,a1
	bls	l0017

	bra	l0018

l0017	lea	-8(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	-112(a2),a2
	move.l	l00f8,l0112
	addi.l	#$c98,l0112
l0018	movea.l	l0113,a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	-112(a2),a2
	lea	952(a2),a2
	move.l	l0053+34+5440,(a2)+
	move.l	l0053+34+5444,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5440,(a2)+
	move.l	l0053+34+5444,(a2)+
	lea	-112(a2),a2
	addi.l	#$3c0,l0113
	movea.l	l00f8,a1
	lea	14400(a1),a1
	cmpa.l	l0113,a1
	bls	l0019

	bra	l001a

l0019	lea	-8(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	104(a2),a2
	move.l	l0053+34+5600,(a2)+
	move.l	l0053+34+5604,(a2)+
	lea	-112(a2),a2
	move.l	l00f8,l0113
	addi.l	#$c88,l0113
l001a	cmpi.w	#$61a0,(a5)
	beq	l001b

	bra	l001c

l001b	lea	l00c0,a5

l001c	move.w	#$ff,-(sp)
	move.w	#6,-(sp)		;crawio
	trap	#1
	addq.l	#4,sp

	move.l	d0,d6
	swap	d6
	cmp.b	#$31,d0
	beq	l0026

	cmp.b	#$32,d0
	beq	l0027

	cmp.b	#$33,d0
	beq	l0028

	cmp.b	#$34,d0
	beq	l0029

	cmp.b	#$35,d0
	beq	l002a

	cmp.b	#$3b,d6
	beq	l002c

	cmp.b	#$3c,d6
	beq	l002d

	cmp.b	#$3d,d6
	beq	l002e

	cmp.b	#$3e,d6
	beq	l002f

	cmp.b	#$3f,d6
	beq	l0030

	cmp.b	#$40,d6
	beq	l0031

	cmp.b	#$41,d6		;#'A'
	beq	l0032

	cmp.b	#$42,d6
	beq	l0033

	cmp.b	#$44,d6
	beq	l002b

l001d	cmp.b	#$20,d0
	bne	l0006

	movea.l	l00f8,a1
	move.w	#$e0f,d1
l001e	clr.l	(a1)+
	dbf	d1,l001e

l001f	lea	l00c3,a3
	lea	l00c4,a4
	move.w	#$1e,d6
l0020	cmpi.w	#$61a0,(a5)
	beq	l0021

	bra	l0022

l0021	lea	l00c0,a5

l0022	bsr	l0050
	bsr	l004f
	bsr	l0034
	bsr	l0050
	bsr	l0034

	move.w	#$ff,-(sp)
	move.w	#6,-(sp)		;crawio
	trap	#1
	addq.l	#4,sp

	cmp.b	#$20,d0
	beq	l0023

	dbf	d6,l0020

	bra	l001f

l0023	bsr	l003b

	move.l	#0,$4d2.l

	bsr	l0047

	move.b	#3,$484.l

	jmp	exit(pc)
;========================================
l0026	move.l	#0,$4d2.l
	move.w	#1,d0
	jsr	l005e+44
	move.l	#l005e+44+8,$4d2.l

	bra	l001d

l0027	move.l	#0,$4d2.l
	move.w	#2,d0
	jsr	l005e+44
	move.l	#l005e+44+8,$4d2.l

	bra	l001d

l0028	move.l	#0,$4d2.l
	move.w	#3,d0
	jsr	l005e+44
	move.l	#l005e+44+8,$4d2.l

	bra	l001d

l0029	move.l	#0,$4d2.l
	move.w	#4,d0
	jsr	l005e+44
	move.l	#l005e+44+8,$4d2.l

	bra	l001d

l002a	move.l	#0,$4d2.l
	move.w	#5,d0
	jsr	l005e+44
	move.l	#l005e+44+8,$4d2.l

	bra	l001d

l002b	move.w	#2,-(sp)
	move.w	#2,-(sp)		;bconin
	trap	#13
	addq.l	#4,sp

	bra	l001d

l002c	addi.b	#1,l0116
	bra	l001d

l002d	subi.b	#1,l0116
	bra	l001d

l002e	addi.b	#1,l0117
	bra	l001d

l002f	subi.b	#1,l0117
	bra	l001d

l0030	addi.b	#1,l0118
	bra	l001d

l0031	subi.b	#1,l0118
	bra	l001d

l0032	addi.b	#1,l0119
	bra	l001d

l0033	subi.b	#1,l0119
	bra	l001d

l0034	move.w	#$25,-(sp)		;vsync
	trap	#14
	addq.w	#2,sp
	rts

l0035	bsr	l004d
	bsr	l004f
	bsr	l0034
	bsr	l0034
	bsr	l0034
	rts

l0036	bsr	l0034

	dbf	d1,l0036
	rts

l0037	move.b	$fffffa07.l,l00fe
	move.b	$fffffa09.l,l00ff
	move.l	$70.l,l0100
	move.l	$120.l,l0101
	move.b	$fffffa0d.l,l0102
	move.b	$fffffa0f.l,l0103
	move.b	$fffffa11.l,l0104
	move.b	$fffffa13.l,l0105
	move.b	$fffffa15.l,l0106
	move.b	$fffffa1b.l,l0107
	move.b	$fffffa21.l,l0108

	move.w	sr,d0
	move.w	#$2700,sr

	move.l	$70.l,l0109
	move.l	#l0038,$70.l
	move.l	#l0039,$120.l
	ori.b	#1,$fffffa13.l

	move.w	d0,sr
	rts

l0038	move.l	#$610,$ffff8240.w
	move.l	#$370027,$ffff8244.w
	move.l	#$7770666,$ffff8248.w
	move.l	#$5000237,$ffff824c.w
	move.l	#$3600555,$ffff8250.w
	move.l	#$4440650,$ffff8254.w
	move.l	#$5400430,$ffff8258.w
	move.l	#$3200333,$ffff825c.w
	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#$60,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l0039,$120.l
	move.l	l0109,-(sp)
	rts

l0039	ori.w	#$700,sr

	move.b	l0116,l0114
	move.b	l0117,l0115
	bsr	l003c
	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	ori.b	#1,$fffffa07.l
	clr.b	$fffffa1b.l
	move.b	#$48,$fffffa21.l
	move.b	#$18,$fffffa1b.l
	move.l	#l003a,$120.l
	rte

l003a	ori.w	#$700,sr

	move.b	l0118,l0114
	move.b	l0119,l0115
	bsr	l003c
	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	rte

l003b	andi.b	#$fe,$fffffa0f.l
	andi.b	#$fe,$fffffa07.l
	move.b	l00fe,$fffffa07.l
	move.b	l00ff,$fffffa09.l
	move.l	l0100,$70.l
	move.l	l0101,$120.l
	move.b	l0102,$fffffa0d.l
	move.b	l0103,$fffffa0f.l
	move.b	l0104,$fffffa11.l
	move.b	l0105,$fffffa13.l
	move.b	l0106,$fffffa15.l
	move.b	l0107,$fffffa1b.l
	move.b	l0108,$fffffa21.l
	rts

l003c	cmpi.b	#0,l0114
	beq	l003d

	cmpi.b	#1,l0114
	beq	l003e

	cmpi.b	#2,l0114
	beq	l003f

	cmpi.b	#3,l0114
	beq	l0040

	cmpi.b	#4,l0114
	beq	l0041

l003d	move.l	l00c5,$ffff8240.w
	move.l	l00c6,$ffff8244.w
	move.l	l00c7,$ffff8248.w
	move.l	l00c8,$ffff824c.w
	bra	l0042

l003e	move.l	l00c9,$ffff8240.w
	move.l	l00ca,$ffff8244.w
	move.l	l00cb,$ffff8248.w
	move.l	l00cc,$ffff824c.w
	bra	l0042

l003f	move.l	l00cd,$ffff8240.w
	move.l	l00ce,$ffff8244.w
	move.l	l00cf,$ffff8248.w
	move.l	l00d0,$ffff824c.w
	bra	l0042

l0040	move.l	l00d1,$ffff8240.w
	move.l	l00d2,$ffff8244.w
	move.l	l00d3,$ffff8248.w
	move.l	l00d4,$ffff824c.w
	bra	l0042

l0041	move.l	l00d5,$ffff8240.w
	move.l	l00d6,$ffff8244.w
	move.l	l00d7,$ffff8248.w
	move.l	l00d8,$ffff824c.w
	bra	l0042

l0042	cmpi.b	#0,l0115
	beq	l0043

	cmpi.b	#1,l0115
	beq	l0044

	cmpi.b	#2,l0115
	beq	l0045

l0043	move.l	l00d9,$ffff8250.w
	move.l	l00da,$ffff8254.w
	move.l	l00db,$ffff8258.w
	move.l	l00dc,$ffff825c.w
	bra	l0046

l0044	move.l	l00dd,$ffff8250.w
	move.l	l00de,$ffff8254.w
	move.l	l00df,$ffff8258.w
	move.l	l00e0,$ffff825c.w
	bra	l0046

l0045	move.l	l00e1,$ffff8250.w
	move.l	l00e2,$ffff8254.w
	move.l	l00e3,$ffff8258.w
	move.l	l00e4,$ffff825c.w
	bra	l0046

l0046	rts

l0047	move.l	#$8080000,$ffff8800.l
	move.l	#$9090000,$ffff8800.l
	move.l	#$a0a0000,$ffff8800.l
	rts

l0048	dc.w	$a000
	move.w	#$40,l00e5
	move.w	#$1a,l00e6
	move.w	#4,l00e7
	move.w	#$f,l00e8
	move.w	#0,l00e9
	move.l	#$3030303,l00ea
	move.w	l00fa,l00eb
	move.w	#6,l00ec
	move.l	#l0053+34,l00ed
	move.w	#8,l00ee
	move.w	#$a0,l00ef
	move.w	#2,l00f0
	move.w	l00f9,l00f1
	move.w	#0,l00f2
	move.l	l00f8,l00f3
	move.w	#8,l00f4
	move.w	#$a0,l00f5
	move.w	#2,l00f6
	move.l	#0,l00f7

	lea	l00e5,a6
	dc.w	$a007
	rts

l0049	dc.w	$a000
	move.w	#$40,l00e5
	move.w	#$20,l00e6
	move.w	#4,l00e7
	move.w	#$f,l00e8
	move.w	#0,l00e9
	move.l	#$3030303,l00ea
	move.w	#$100,l00eb
	move.w	#$20,l00ec
	move.l	#l0053+34,l00ed
	move.w	#8,l00ee
	move.w	#$a0,l00ef
	move.w	#2,l00f0
	move.w	l00f9,l00f1
	move.w	#0,l00f2
	move.l	l00f8,l00f3
	move.w	#8,l00f4
	move.w	#$a0,l00f5
	move.w	#2,l00f6
	move.l	#0,l00f7

	lea	l00e5,A6
	dc.w	$a007
	rts

l004a	dc.w	$a000
	move.w	#$10,l00e5
	move.w	#$10,l00e6
	move.w	#4,l00e7
	move.w	#$f,l00e8
	move.w	#0,l00e9
	move.l	#$3030303,l00ea
	move.w	l00fb,l00eb
	move.w	#$20,l00ec
	move.l	#l0053+34,l00ed
	move.w	#8,l00ee
	move.w	#$a0,l00ef
	move.w	#2,l00f0
	move.w	#$98,l00f1
	move.w	#8,l00f2
	move.l	l00f8,l00f3
	move.w	#8,l00f4
	move.w	#$a0,l00f5
	move.w	#2,l00f6
	move.l	#0,l00f7

	lea	l00e5,A6
	dc.w	$a007
	rts

l004b	dc.w	$a000
	move.w	#$10,l00e5
	move.w	#$10,l00e6
	move.w	#4,l00e7
	move.w	#$f,l00e8
	move.w	#0,l00e9
	move.l	#$3030303,l00ea
	move.w	l00fc,l00eb
	move.w	#$30,l00ec
	move.l	#l0053+34,l00ed
	move.w	#8,l00ee
	move.w	#$a0,l00ef
	move.w	#2,l00f0
	move.w	#$98,l00f1
	move.w	#$16,l00f2
	move.l	l00f8,l00f3
	move.w	#8,l00f4
	move.w	#$a0,l00f5
	move.w	#2,l00f6
	move.l	#0,l00f7

	lea	l00e5,A6
	dc.w	$a007
	rts

l004c	dc.w	$a000
	move.w	#$8c,l00e5
	move.w	#$26,l00e6
	move.w	#4,l00e7
	move.w	#$f,l00e8
	move.w	#0,l00e9
	move.l	#$3030303,l00ea
	move.w	#$b4,l00eb
	move.w	#$84,l00ec
	move.l	#l0053+34,l00ed
	move.w	#8,l00ee
	move.w	#$a0,l00ef
	move.w	#2,l00f0
	move.w	#$5a,l00f1
	move.w	#$80,l00f2
	move.l	l00f8,l00f3
	move.w	#8,l00f4
	move.w	#$a0,l00f5
	move.w	#2,l00f6
	move.l	#0,l00f7

	lea	l00e5,A6
	dc.w	$a007
	rts

l004d	move.w	#9,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)
	trap	#14
	addq.w	#6,sp
	move.w	d0,l00fd

	dc.w	$a000
	move.w	#$20,l00e5
	move.w	#$30,l00e6
	move.w	#4,l00e7
	move.w	#$f,l00e8
	move.w	#0,l00e9
	move.l	#$3030303,l00ea
	move.w	#0,l00eb
	move.w	#$40,l00ec
	move.l	#l0053+34,l00ed
	move.w	#8,l00ee
	move.w	#$a0,l00ef
	move.w	#2,l00f0
	move.w	#$68,l00f1
	move.w	l00fd,l00f2
	move.l	l00f8,l00f3
	move.w	#8,l00f4
	move.w	#$a0,l00f5
	move.w	#2,l00f6
	move.l	#0,l00f7

	lea	l00e5,A6
	dc.w	$a007

	move.w	#$a,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)
	trap	#14
	addq.l	#6,sp
	move.w	d0,l00fd

	dc.w	$a000
	move.w	#$20,l00e5
	move.w	#$30,l00e6
	move.w	#4,l00e7
	move.w	#$f,l00e8
	move.w	#0,l00e9
	move.l	#$3030303,l00ea
	move.w	#$20,l00eb
	move.w	#$40,l00ec
	move.l	#l0053+34,l00ed
	move.w	#8,l00ee
	move.w	#$a0,l00ef
	move.w	#2,l00f0
	move.w	#$b8,l00f1
	move.w	l00fd,l00f2
	move.l	l00f8,l00f3
	move.w	#8,l00f4
	move.w	#$a0,l00f5
	move.w	#2,l00f6
	move.l	#0,l00f7

	lea	l00e5,A6
	dc.w	$a007

	move.w	#8,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.l	#6,sp
	move.w	d0,l00fd

	cmpi.w	#$d,l00fd
	bls	l004e

	move.w	#$c0,l00fa
	bsr	l0048
	rts

l004e	move.w	#$100,l00fa
	bsr	l0048
	rts

l004f	movea.l	l00f8,a1
	movea.l	l00f8,a2
	lea	$3de0(a1),a1
	lea	$3de0(a2),a2
	lea	8(a1),a1
	lea	(a2),a2
	move.w	#$1a,D5
x25546a	move.w	#$25,D1
x25546e	move.l	(a1)+,(a2)+
	dbf	d1,x25546e
	dbf	d5,x25546a

	dc.w	$a000
	move.w	#$10,l00e5
	move.w	#$19,l00e6
	move.w	#4,l00e7
	move.w	#$f,l00e8
	move.w	#0,l00e9
	move.l	#$3030303,l00ea
	move.w	(a5)+,l00eb
	move.w	#0,l00ec
	move.l	#l00c1,l00ed
	move.w	#8,l00ee
	move.w	#$a0,l00ef
	move.w	#2,l00f0
	move.w	#$130,l00f1
	move.w	#$63,l00f2
	move.l	l00f8,l00f3
	move.w	#8,l00f4
	move.w	#$a0,l00f5
	move.w	#2,l00f6
	move.l	#0,l00f7

	lea	l00e5,A6
	dc.w	$a007
	rts

l0050	dc.w	$a000
	move.w	#$80,l00e5
	move.w	#1,l00e6
	move.w	#4,l00e7
	move.w	#$f,l00e8
	move.w	#0,l00e9
	move.l	#$3030303,l00ea
	move.w	#0,l00eb
	move.w	#$23,l00ec
	move.l	#l0053+34,l00ed
	move.w	#8,l00ee
	move.w	#$a0,l00ef
	move.w	#2,l00f0
	move.w	(a3)+,l00f1
	move.w	#0,l00f2
	move.l	l00f8,l00f3
	move.w	#8,l00f4
	move.w	#$a0,l00f5
	move.w	#2,l00f6
	move.l	#0,l00f7

	lea	l00e5,A6
	dc.w	$a007
	dc.w	$a000
	move.w	#$80,l00e5
	move.w	#1,l00e6
	move.w	#4,l00e7
	move.w	#$f,l00e8
	move.w	#0,l00e9
	move.l	#$3030303,l00ea
	move.w	#0,l00eb
	move.w	#$23,l00ec
	move.l	#l0053+34,l00ed
	move.w	#8,l00ee
	move.w	#$a0,l00ef
	move.w	#2,l00f0
	move.w	(a4)+,l00f1
	move.w	#3,l00f2
	move.l	l00f8,l00f3
	move.w	#8,l00f4
	move.w	#$a0,l00f5
	move.w	#2,l00f6
	move.l	#0,l00f7

	lea	l00e5,a6
	dc.w	$a007
	movea.l	l00f8,a1
	movea.l	l00f8,a2
	lea	$3c0(a2),a2
	lea	$3840(a1),a1
	lea	$3840(a2),a2
	move.w	#$e0f,d1
x25568e	move.l	-(a1),-(a2)
	dbf	d1,x25568e
	rts

l0051	movea.l	l00f8,a2
	lea	27200(a2),a2
	lea	l0053,a1
	lea	34(a1),a1
	lea	27200(a1),a1
	move.w	#$4af,d1
l0052	move.l	(a1)+,(a2)+
	dbf	d1,l0052
	rts

l0053	incbin	l0053.pi1
l005e	incbin	l005e.mus

l00c0	incbin	l00c0
l00c1	incbin	l00c1
l00c3	incbin	l00c3
l00c4	incbin	l00c4

l00c5	dc.b	$00,$00,$00,$01
l00c6	dc.b	$00,$12,$00,$23
l00c7	dc.b	$00,$24,$00,$35
l00c8	dc.b	$00,$46,$00,$57
l00c9	dc.b	$00,$00,$01,$00
l00ca	dc.b	$02,$00,$03,$00
l00cb	dc.b	$04,$00,$05,$00
l00cc	dc.b	$06,$00,$07,$00
l00cd	dc.b	$00,$00,$00,$10
l00ce	dc.b	$00,$20,$00,$30
l00cf	dc.b	$00,$40,$00,$50
l00d0	dc.b	$00,$60,$00,$70
l00d1	dc.b	$00,$00,$00,$01
l00d2	dc.b	$00,$02,$00,$03
l00d3	dc.b	$00,$04,$00,$05
l00d4	dc.b	$00,$06,$00,$07
l00d5	dc.b	$00,$00,$01,$01
l00d6	dc.b	$02,$02,$03,$03
l00d7	dc.b	$04,$04,$05,$05
l00d8	dc.b	$06,$06,$07,$07
l00d9	dc.b	$03,$60,$07,$77
l00da	dc.b	$06,$66,$05,$55
l00db	dc.b	$04,$44,$03,$33
l00dc	dc.b	$02,$22,$07,$77
l00dd	dc.b	$03,$60,$07,$70
l00de	dc.b	$07,$60,$06,$50
l00df	dc.b	$05,$40,$04,$30
l00e0	dc.b	$03,$20,$07,$77
l00e1	dc.b	$03,$60,$00,$77
l00e2	dc.b	$00,$66,$00,$55
l00e3	dc.b	$00,$44,$00,$33
l00e4	dc.b	$00,$22,$00,$77
;========================================
	bss
;========================================
l00e5	ds.w	1
l00e6	ds.w	1
l00e7	ds.w	1
l00e8	ds.w	1
l00e9	ds.w	1
l00ea	ds.l	1
l00eb	ds.w	1
l00ec	ds.w	1
l00ed	ds.l	1
l00ee	ds.w	1
l00ef	ds.w	1
l00f0	ds.w	1
l00f1	ds.w	1
l00f2	ds.w	1
l00f3	ds.l	1
l00f4	ds.w	1
l00f5	ds.w	1
l00f6	ds.w	1
l00f7	ds.b	134
l00f8	ds.l	1
l00f9	ds.w	1
l00fa	ds.w	1
l00fb	ds.w	1
l00fc	ds.w	1
l00fd	ds.w	1
l00fe	ds.w	1
l00ff	ds.w	1
l0100	ds.l	1
l0101	ds.l	1
l0102	ds.w	1
l0103	ds.w	1
l0104	ds.w	1
l0105	ds.w	1
l0106	ds.w	1
l0107	ds.w	1
l0108	ds.b	36
l0109	ds.l	1
l010a	ds.l	1
l010b	ds.l	1
l010c	ds.l	1
l010d	ds.l	1
l010e	ds.l	1
l010f	ds.l	1
l0110	ds.l	1
l0111	ds.l	1
l0112	ds.l	1
l0113	ds.b	8
l0114	ds.b	1
l0115	ds.b	1
l0116	ds.b	1
l0117	ds.b	1
l0118	ds.b	1
l0119	ds.b	1
;================================================================================
buffer
;================================================================================
zuend		end
;================================================================================