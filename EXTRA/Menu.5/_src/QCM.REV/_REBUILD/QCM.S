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

	pea	l003d
	move.w	#0,-(sp)
	move.w	#$19,-(sp)		;ikbdws
	trap	#14
	addq.l	#8,sp

	move.b	#$e,$484.l

	lea	l003a,a0
	lea	$43fde,a1
	move.l	#$bb7,d1
l0000	move.l	(a0)+,(a1)+
	dbf	d1,l0000

	moveq	#1,d0
	jsr	l003a
	move.l	#l003a+8,$4d2.w

	move.w	#2,-(sp)		;physbase
	trap	#14
	addq.l	#2,sp
	move.l	d0,l0042

	pea	l0036+2
	move.w	#6,-(sp)		;setpallete
	trap	#14
	addq.l	#6,sp

	bsr	l001f

	lea	$fffffa01.w,a5
	move.l	a5,l0043
	andi.b	#$de,18(a5)
	andi.b	#$de,14(a5)
	andi.b	#$de,10(a5)
	andi.b	#$de,6(a5)
	clr.b	24(a5)
	clr.b	26(a5)

	lea	l0028(pc),a0
	move.l	a0,$134.w

	lea	l003f,a0
	move.l	$70.w,(a0)
	lea	l0025(pc),a0
	move.l	a0,$70.w

	move.l	#l0040,d0
	andi.l	#$ffffff00,d0
	addi.l	#$100,d0
	move.l	d0,l0041
	movea.l	d0,a2
	movea.l	a2,a0
	move.w	#$2acf,d1
l0001	clr.l	(a0)+
	dbf	d1,l0001

	move.l	#$ffffffff,-(sp)
	move.l	l0041,-(sp)
	move.l	l0041,-(sp)
	move.w	#5,-(sp)		;setscreen
	trap	#14
	adda.l	#$e,sp

	movea.l	l0041,a0
	lea	10240(a0),a0
	lea	l0036,a1
	lea	34(a1),a1
	lea	10240(a1),a1
	move.w	#$153f,d1
l0002	move.l	(a1)+,(a0)+
	dbf	d1,l0002

	lea	l0036,a1
	lea	34(a1),a1
	lea	5120(a1),a1
	move.w	#$3bf,d1
l0003	move.l	(a1)+,(a0)+
	dbf	d1,l0003

	move.w	#0,l0044
	lea	l0035,a5
	move.w	#$13,d4
	lea	l0031,a4

l0004	pea	l0032
	move.w	#9,-(sp)		;cconws
	trap	#1
	addq.l	#6,sp

	pea	(a4)
	move.w	#9,-(sp)		;cconws
	trap	#1
	addq.l	#6,sp

l0005	addq.l	#1,a4
	cmpi.b	#0,(a4)
	bne	l0005

	addq.l	#1,a4
	lea	l0036+34,a6
	lea	160(a6),a6
	move.w	#9,d7
l0006	suba.l	#$10,a6
	bsr	l0012

	move.w	#$32,d3

l0007	move.w	#$ff,-(sp)
	move.w	#6,-(sp)		;crawio
	trap	#1
	addq.l	#4,sp

	cmp.b	#0,d0
	bne	l0008

	bsr	l0014
	bsr	l0011

	dbf	d3,l0007
	dbf	d7,l0006

l0008	move.b	0(a5,d4.w),d1
	cmp.b	d1,d0
	beq	l0009

	bra	l000a

l0009	addq.b	#1,l0044
l000a	movea.l	l0041,a0
	move.w	#$8bf,d2
l000b	clr.l	(a0)+
	dbf	d2,l000b
	dbf	d4,l0004

	pea	l0033
	move.w	#9,-(sp)		;cconws
	trap	#1
	addq.l	#6,sp

	move.b	l0044,d5
	lea	l0034,a4
l000c	addq.l	#1,a4
	cmpi.b	#0,(a4)
	bne	l000c

	addq.l	#1,a4
	dbf	d5,l000c

	pea	(a4)
	move.w	#9,-(sp)		;cconws
	trap	#1
	addq.l	#6,sp

l000d	bsr	l0014
	bsr	l0011

	move.w	#$ff,-(sp)
	move.w	#6,-(sp)		;crawio
	trap	#1
	addq.l	#4,sp

	cmp.b	#0,d0
	beq	l000d

	clr.l	$4d2.w

	pea	l0039
	move.w	#$20,-(sp)		;dosound
	trap	#14
	addq.l	#6,sp

	bsr	l0010

	move.w	sr,-(sp)
	ori.w	#$700,sr

	move.l	l003f,$70.w

	movea.l	l0043,a5
	andi.b	#$de,18(a5)
	andi.b	#$de,14(a5)
	andi.b	#$de,10(a5)
	andi.b	#$de,6(a5)
	clr.b	24(a5)
	clr.b	26(a5)
	bsr	l0020

	move.w	(sp)+,sr

	pea	l003e
	move.w	#0,-(sp)
	move.w	#$19,-(sp)		;ikbdws
	trap	#14
	addq.l	#8,sp

	move.l	#$ffffffff,-(sp)
	move.l	l0042,-(sp)
	move.l	l0042,-(sp)
	move.w	#5,-(sp)		;setscreen
	trap	#14
	adda.l	#$e,sp

	jmp	exit(pc)
;========================================
l0010	move.l	#$8080000,$ffff8800.l
	move.l	#$9090000,$ffff8800.l
	move.l	#$a0a0000,$ffff8800.l
	rts

l0011	move.w	#$25,-(sp)		;vsync
	trap	#14
	addq.l	#2,sp
	rts

l0012	movea.l	l0041,a0
	lea	32000(a0),a0
	lea	2560(a0),a0
	movea.l	a6,a1
	move.w	#$20,d0
l0013	move.l	(a1),(a0)
	move.l	4(a1),4(a0)
	move.l	8(a1),8(a0)
	move.l	12(a1),12(a0)
	move.l	(a1),144(a0)
	move.l	4(a1),148(a0)
	move.l	8(a1),152(a0)
	move.l	12(a1),156(a0)
	lea	160(a0),a0
	lea	160(a1),a1
	dbf	d0,l0013
	rts

l0014	move.w	#8,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l0041,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	40(a2),a2
	lea	l003b,a3
	adda.l	d2,a3
l0015	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l0015

	move.w	#1,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l0041,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	48(a2),a2
	lea	l003b,a3
	adda.l	d2,a3
l0016	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l0016

	move.w	#9,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l0041,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	56(a2),a2
	lea	l003b,a3
	adda.l	d2,a3
l0017	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l0017

	move.w	#3,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l0041,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	64(a2),a2
	lea	l003b,a3
	adda.l	d2,a3
l0018	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l0018

	move.w	#$a,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l0041,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	72(a2),a2
	lea	l003b,a3
	adda.l	d2,a3
l0019	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l0019

	move.w	#5,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l0041,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	80(a2),a2
	lea	l003b,a3
	adda.l	d2,a3
l001a	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l001a

	move.w	#6,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l0041,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	88(a2),a2
	lea	l003b,a3
	adda.l	d2,a3
l001b	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l001b

	move.w	#0,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	divu	#$10,d0
	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l0041,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	96(a2),a2
	lea	l003b,a3
	adda.l	d2,a3
l001c	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l001c

	move.w	#2,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	divu	#$10,d0
	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l0041,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	104(a2),a2
	lea	l003b,a3
	adda.l	d2,a3
l001d	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l001d

	move.w	#4,-(sp)
	move.w	#$40,-(sp)
	move.w	#$1c,-(sp)		;giaccess
	trap	#14
	addq.w	#6,sp

	divu	#$10,d0
	mulu	#8,d0
	move.l	d0,d2
	move.w	#$e,d1
	movea.l	l0041,a2
	lea	32000(a2),a2
	lea	5120(a2),a2
	lea	112(a2),a2
	lea	l003b,a3
	adda.l	d2,a3
l001e	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	adda.l	#$138,a2
	adda.l	#$98,a3
	dbf	d1,l001e
	rts

l001f	lea	l0022(pc),a0
	move.l	$114.l,2(a0)
	lea	l0021(pc),a0
	move.l	a0,$114.l

	lea	l0024(pc),a0
	move.l	$118.l,2(a0)
	lea	l0023(pc),a0
	move.l	a0,$118.l
	rts

l0020	lea	l0022(pc),a0
	move.l	2(a0),$114.l

	lea	l0024(pc),a0
	move.l	2(a0),$118.l
	rts

l0021	ori.w	#$500,sr
	andi.w	#$fdff,sr

l0022	jmp	$10000

l0023	ori.w	#$500,sr
	andi.w	#$fdff,sr

l0024	jmp	$10000

l0025	move.l	l003f,-(sp)
	movem.l	a0/d0-d1,-(sp)
	lea	$ffff8201.w,a0
	movep.w	0(a0),d0
	movep.w	4(a0),d1
	cmp.w	d0,d1
	bne.s	l0027

	tst.b	8(a0)
	bne.s	l0027

	lea	l003c,a0
	tst.w	(a0)
	beq.s	l0026

	clr.w	(a0)
	movem.l	(sp)+,a0/d0-d1
	rts

l0026	lea	l002b(pc),a0
	move.l	a0,$120.w
	lea	$fffffa01.w,a0
	clr.b	26(a0)
	move.b	#$c7,32(a0)
	move.b	#8,26(a0)
	ori.b	#1,6(a0)
	ori.b	#1,18(a0)
	movem.l	(sp)+,a0/d0-d1
	rts

l0027	lea	$fffffa01.w,a0
	andi.b	#$de,18(a0)
	andi.b	#$de,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
	lea	l003c,a0
	clr.w	(a0)
	movem.l	(sp)+,a0/d0-d1
	rts

l0028	cmpi.b	#1,$fffffa21.w
	bgt.s	l0028

	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop

	cmpi.l	#$a100,$432.l
	bne	l0029

	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop

l0029	move.b	#$fc,$ffff820a.w

	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop

	move.b	#$fe,$ffff820a.w

	movem.l	a0/d0-d2,-(sp)
	lea	$ffff8201.w,a0
	movep.w	0(a0),d1
	movep.w	4(a0),d2
	lea	l002d(pc),a0
	move.w	#$e4,d0
	tst.b	$ffff8209.w
	bne.s	l002a

	cmp.w	d1,d2
	bne.s	l002a

	lea	l002b(pc),a0
	move.w	#$c7,d0
l002a	move.l	a0,$120.w
	lea	$fffffa01.w,a0
	clr.b	26(a0)
	move.b	d0,32(a0)
	move.b	#8,26(a0)
	ori.b	#1,6(a0)
	ori.b	#1,18(a0)
	clr.b	24(a0)
	bclr	#5,14(a0)
	movem.l	(sp)+,a0/d0-d2
	rte

l002b	movem.l	a0-a2/d0,-(sp)
	lea	$fffffa01.w,a0
	lea	$ffff8209.w,a1
	lea	l002f(pc),a2
	lea	-222(a2),a2
	moveq	#0,d0
	andi.b	#$fe,18(a0)
	andi.b	#$fe,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
l002c	move.b	(a1),d0
	cmp.w	#$de,d0
	blt.s	l002c

	cmp.b	#0,d0
	bgt	l0030

	jmp	0(a2,d0.w)

l002d	movem.l	a0-a2/d0,-(sp)
	lea	$fffffa01.w,a0
	lea	$ffff8209.w,a1
	lea	l002f(pc),a2
	moveq	#0,d0
	andi.b	#$fe,18(a0)
	andi.b	#$fe,6(a0)
	clr.b	26(a0)
	clr.b	24(a0)
l002e	move.b	(a1),d0
	cmp.b	#8,d0
	blt.s	l002e

	cmp.w	#$20,d0
	bgt	l0030

	jmp	-8(a2,d0.w)

l002f	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop

	move.b	#$fc,$ffff820a.w

	nop

	move.b	#$fe,$ffff820a.w

	move.b	#$84,32(a0)
	move.b	#6,26(a0)
	move.b	#$81,30(a0)
	move.b	#6,24(a0)
	ori.b	#$20,6(a0)
	ori.b	#$20,18(a0)
	bclr	#0,14(a0)
	lea	l003c,a0
	move.w	#$ffff,(a0)
	movem.l	(sp)+,a0-a2/d0
	rte

l0030	bclr	#0,14(a0)
	lea	l003c,a0
	clr.w	(a0)
	movem.l	(sp)+,a0-a2/d0
	rte
;========================================
;	data
;========================================
	dc.b	$07,$00
l0031	dc.b	'Un de ce'
	dc.b	's mots n'
	dc.b	$27,'est pas'
	dc.b	' un syno'
	dc.b	'nyme',$0d,$0a,'du'
	dc.b	' Full Sc'
	dc.b	'reen.',$0d,$0a,'L'
	dc.b	'equel ?',$0d
	dc.b	$0a,$0d,$0a,'[1] N'
	dc.b	'O BORDER'
	dc.b	' SCREEN',$0d
	dc.b	$0a,'[2] OVE'
	dc.b	'RSCAN',$0d,$0a,'['
	dc.b	'3] FREQU'
	dc.b	'ENCY SCR'
	dc.b	'EEN',$0d,$0a,$00,'Ce'
	dc.b	'tte mach'
	dc.b	'ine n',$27,'a '
	dc.b	'jamais e'
	dc.b	'xist',$82,'.',$0d,$0a
	dc.b	$0d,$0a,'[1] 13'
	dc.b	'0 ST',$0d,$0a,'[2'
	dc.b	'] 260 ST'
	dc.b	'F',$0d,$0a,'[3] 2'
	dc.b	'60 ST',$0d,$0a,$00
	dc.b	'Quel gro'
	dc.b	'upe a ',$82,'t'
	dc.b	$82,' le pre'
	dc.b	'mier ',$85,$0d,$0a
	dc.b	'r',$82,'aliser'
	dc.b	' un Full'
	dc.b	' Screen '
	dc.b	'sur ST ?'
	dc.b	$0d,$0a,$0d,$0a,'[1] '
	dc.b	'T.C.B.',$0d,$0a
	dc.b	'[2] LEVE'
	dc.b	'L 16',$0d,$0a,'[3'
	dc.b	'] TEX',$0d,$0a,$00
	dc.b	'On peut '
	dc.b	'r',$82,'aliser'
	dc.b	' un scro'
	dc.b	'lling',$0d,$0a,'h'
	dc.b	'ardware '
	dc.b	'sur tous'
	dc.b	' les STF'
	dc.b	'.',$0d,$0a,$0d,$0a,'[1]'
	dc.b	' OUI',$0d,$0a,'[2'
	dc.b	'] SEULEM'
	dc.b	'ENT SUR '
	dc.b	'LES MODE'
	dc.b	'LES',$0d,$0a,'   '
	dc.b	' AVEC BL'
	dc.b	'ITTER',$0d,$0a,'['
	dc.b	'3] FAUX',$0d
	dc.b	$0a,$00,'La Lin'
	dc.b	'e A,c',$27,'es'
	dc.b	't :',$0d,$0a,$0d,$0a,'['
	dc.b	'1] LA LI'
	dc.b	'GNE ACTU'
	dc.b	'ELLE LOR'
	dc.b	'S D',$27,'UN',$0d,$0a
	dc.b	'    BALA'
	dc.b	'YAGE D',$27,'E'
	dc.b	'CRAN',$0d,$0a,'[2'
	dc.b	'] UNE SE'
	dc.b	'RIE DE F'
	dc.b	'ONCTIONS'
	dc.b	' DE DESS'
	dc.b	'IN',$0d,$0a,'[3] '
	dc.b	'UN PROTO'
	dc.b	'COLE DE '
	dc.b	'COMMUNIC'
	dc.b	'ATION',$0d,$0a,$00
	dc.b	'Qui a le'
	dc.b	' plus de'
	dc.b	' fonctio'
	dc.b	'ns ?',$0d,$0a,$0d,$0a
	dc.b	'[1] GEMD'
	dc.b	'OS',$0d,$0a,'[2] '
	dc.b	'BIOS',$0d,$0a,'[3'
	dc.b	'] XBIOS',$0d
	dc.b	$0a,$00,'GDOS.P'
	dc.b	'RG c',$27,'est'
	dc.b	' :',$0d,$0a,$0d,$0a,'[1'
	dc.b	'] UNE AB'
	dc.b	'REVIATIO'
	dc.b	'N DE GEM'
	dc.b	'DOS',$0d,$0a,'[2]'
	dc.b	' UN SYST'
	dc.b	'EME D',$27,'EX'
	dc.b	'PLOITATI'
	dc.b	'ON',$0d,$0a,'[3] '
	dc.b	'UN PROGR'
	dc.b	'AMME D',$27,'E'
	dc.b	'XTENSION'
	dc.b	' GRAPHIQ'
	dc.b	'UE',$0d,$0a,$00,'Une'
	dc.b	' fois in'
	dc.b	'itialis',$82
	dc.b	'e,la Lin'
	dc.b	'e-A poss'
	dc.b	$8a,'de :',$0d,$0a,$0d
	dc.b	$0a,'[1] 8  '
	dc.b	'FONCTION'
	dc.b	'S',$0d,$0a,'[2] 1'
	dc.b	'2 FONCTI'
	dc.b	'ONS',$0d,$0a,'[3]'
	dc.b	' 15 FONC'
	dc.b	'TIONS',$0d,$0a,$00
	dc.b	'Combien '
	dc.b	'de lecte'
	dc.b	'urs de d'
	dc.b	'isquette'
	dc.b	's',$0d,$0a,'peut '
	dc.b	'g',$82,'rer un'
	dc.b	' ST ?',$0d,$0a,$0d
	dc.b	$0a,'[1] 2 A'
	dc.b	'U MAXIMU'
	dc.b	'M',$0d,$0a,'[2] 3'
	dc.b	' AU MAXI'
	dc.b	'MUM',$0d,$0a,'[3]'
	dc.b	' UNE INF'
	dc.b	'INITE SI'
	dc.b	' ON A AS'
	dc.b	'SEZ DE R'
	dc.b	'AM',$0d,$0a,$00,'Un '
	dc.b	'ripper c'
	dc.b	$27,'est :',$0d,$0a
	dc.b	$0d,$0a,'[1] UN'
	dc.b	' MAUVAIS'
	dc.b	' PROGRAM'
	dc.b	'MEUR',$0d,$0a,'[2'
	dc.b	'] UNE CA'
	dc.b	'RTOUCHE',$0d
	dc.b	$0a,'[3] UNE'
	dc.b	' PERSONN'
	dc.b	'E QUI PR'
	dc.b	'END LES '
	dc.b	'CODES,',$0d,$0a
	dc.b	'    GRAP'
	dc.b	'HISMES O'
	dc.b	'U MUSIQU'
	dc.b	'ES D',$27,'UNE'
	dc.b	$0d,$0a,'    AU'
	dc.b	'TRE PERS'
	dc.b	'ONNE',$0d,$0a,$00,'U'
	dc.b	'n byte c'
	dc.b	$27,'est :',$0d,$0a
	dc.b	$0d,$0a,'[1] UN'
	dc.b	' BIT',$0d,$0a,'[2'
	dc.b	'] UN OCT'
	dc.b	'ET',$0d,$0a,'[3] '
	dc.b	'UNE SERI'
	dc.b	'E DE 8 O'
	dc.b	'CTETS',$0d,$0a,$00
	dc.b	'XBIOS 2.'
	dc.b	'..Ca don'
	dc.b	'ne quoi,'
	dc.b	'd',$82,'j',$85,' ?',$0d,$0a
	dc.b	$0d,$0a,'[1] L',$27
	dc.b	'ADRESSE '
	dc.b	'PHYSIQUE'
	dc.b	' DE L',$27,'EC'
	dc.b	'RAN',$0d,$0a,'[2]'
	dc.b	' L',$27,'ADRES'
	dc.b	'SE LOGIQ'
	dc.b	'UE DE L',$27
	dc.b	'ECRAN',$0d,$0a,'['
	dc.b	'3] LE DP'
	dc.b	'B',$0d,$0a,$00,'GenS'
	dc.b	'T c',$27,'est '
	dc.b	':',$0d,$0a,$0d,$0a,'[1]'
	dc.b	' UN PROG'
	dc.b	'RAMME DE'
	dc.b	' DESSIN',$0d
	dc.b	$0a,'[2] UN '
	dc.b	'EMULATEU'
	dc.b	'R MAC',$0d,$0a,'['
	dc.b	'3] UN AS'
	dc.b	'SEMBLEUR'
	dc.b	$0d,$0a,$00,'Le GI'
	dc.b	'OS,',$87,'a ex'
	dc.b	'iste sur'
	dc.b	' ST ?',$0d,$0a,$0d
	dc.b	$0a,'[1] NON'
	dc.b	$0d,$0a,'[2] SE'
	dc.b	'ULEMENT '
	dc.b	'SUR MEGA'
	dc.b	' STE',$0d,$0a,'[3'
	dc.b	'] OUI',$0d,$0a,$00
	dc.b	'Une font'
	dc.b	'e,c',$27,'est '
	dc.b	':',$0d,$0a,$0d,$0a,'[1]'
	dc.b	' UNE POL'
	dc.b	'ICE DE C'
	dc.b	'ARACTERE'
	dc.b	'S',$0d,$0a,'[2] U'
	dc.b	'N MASQUE'
	dc.b	' DE SPRI'
	dc.b	'TE',$0d,$0a,'[3] '
	dc.b	'UN DEUXI'
	dc.b	'EME ECRA'
	dc.b	'N',$0d,$0a,$00,'Donn'
	dc.b	'ez l',$27,'adr'
	dc.b	'esse du '
	dc.b	'vecteur '
	dc.b	'VBL',$0d,$0a,$0d,$0a,'['
	dc.b	'1] $68',$0d,$0a
	dc.b	'[2] $70',$0d
	dc.b	$0a,'[3] $48'
	dc.b	'4',$0d,$0a,$00,'Quel'
	dc.b	' est le '
	dc.b	'Nombre M'
	dc.b	'agique q'
	dc.b	'ui "d',$82,'vi'
	dc.b	'e"',$0d,$0a,'le R'
	dc.b	'ESET ?',$0d,$0a
	dc.b	$0d,$0a,'[1] $F'
	dc.b	'C0008',$0d,$0a,'['
	dc.b	'2] $3141'
	dc.b	'5926',$0d,$0a,'[3'
	dc.b	'] $75201'
	dc.b	'9F3',$0d,$0a,$00,'XB'
	dc.b	'IOS 6,',$87,'a'
	dc.b	' sert ',$85,' '
	dc.b	':',$0d,$0a,$0d,$0a,'[1]'
	dc.b	' CHANGER'
	dc.b	' LA PALE'
	dc.b	'TTE',$0d,$0a,'[2]'
	dc.b	' OUVRIR '
	dc.b	'UN FICHI'
	dc.b	'ER',$0d,$0a,'[3] '
	dc.b	'PASSER E'
	dc.b	'N SUPERV'
	dc.b	'ISEUR',$0d,$0a,$00
	dc.b	'Le Super'
	dc.b	'viseur,c'
	dc.b	$27,'est pou'
	dc.b	'r :',$0d,$0a,$0d,$0a,'['
	dc.b	'1] ACCEL'
	dc.b	'ERER LA '
	dc.b	'SOURIS',$0d,$0a
	dc.b	'[2] ACCE'
	dc.b	'DER A DE'
	dc.b	'S ZONES '
	dc.b	'PROTEGEE'
	dc.b	'S',$0d,$0a,'[3] G'
	dc.b	'ERER LE '
	dc.b	'JOYSTICK'
	dc.b	$0d,$0a,$00,'Facil'
	dc.b	'e ! Le m'
	dc.b	'icroproc'
	dc.b	'esseur d'
	dc.b	'u ST :',$0d,$0a
	dc.b	$0d,$0a,'[1] 80'
	dc.b	'286',$0d,$0a,'[2]'
	dc.b	' 68000',$0d,$0a
	dc.b	'[3] 8038'
	dc.b	'6',$0d,$0a,$00
l0032	dc.b	$1b,'Y  ',$00
l0033	dc.b	$1b,'Y  NOTE '
	dc.b	':',$0d,$0a,$00
l0034	dc.b	$00,$00,'0/20 :'
	dc.b	' Vous ',$88,'t'
	dc.b	'es NUL !'
	dc.b	$00,'1/20 : '
	dc.b	'Savez-vo'
	dc.b	'us qu',$27,'on'
	dc.b	' peut fa'
	dc.b	'ire',$0d,$0a,'aut'
	dc.b	're chose'
	dc.b	' que des'
	dc.b	' jeux su'
	dc.b	'r un ST '
	dc.b	'?',$00,'2/20 :'
	dc.b	' Achetez'
	dc.b	' la Bibl'
	dc.b	'e du ST '
	dc.b	'!',$00,'3/20 :'
	dc.b	' Savez-v'
	dc.b	'ous au m'
	dc.b	'oins ce '
	dc.b	'qu',$27,'est',$0d,$0a
	dc.b	'un Atari'
	dc.b	' ST ????'
	dc.b	'??',$00,'4/20 '
	dc.b	': MINABL'
	dc.b	'E !',$00,'5/20'
	dc.b	' : Si on'
	dc.b	' recomme'
	dc.b	'n',$87,'ait ??'
	dc.b	'!?',$00,'6/20 '
	dc.b	': BOARF '
	dc.b	'!',$00,'7/20 :'
	dc.b	' Mouaipf'
	dc.b	' !',$00,'8/20 '
	dc.b	': Manque'
	dc.b	' de trav'
	dc.b	'ail...',$00,'9'
	dc.b	'/20 : De'
	dc.b	's bases '
	dc.b	$85,' revoir'
	dc.b	'...',$00,'10/2'
	dc.b	'0 : C',$27,'es'
	dc.b	't juste.'
	dc.b	'..',$00,'11/20'
	dc.b	' : Il fa'
	dc.b	'ut pers',$82
	dc.b	'v',$82,'rer !',$00
	dc.b	'12/20 : '
	dc.b	'Passable'
	dc.b	'...',$00,'13/2'
	dc.b	'0 : Acce'
	dc.b	'ptable..'
	dc.b	'.',$00,'14/20 '
	dc.b	': Pas si'
	dc.b	' mal ...'
	dc.b	$00,'15/20 :'
	dc.b	' Vous ',$88,'t'
	dc.b	'es assez'
	dc.b	' dou',$82,' !',$00
	dc.b	'16/20 : '
	dc.b	'Tr',$8a,'s bie'
	dc.b	'n.',$00,'17/20'
	dc.b	' : Tr',$8a,'s '
	dc.b	'bon.',$00,'18/'
	dc.b	'20 : Tr',$8a
	dc.b	's tr',$8a,'s b'
	dc.b	'ien !',$00,'19'
	dc.b	'/20 : Ex'
	dc.b	'cellent '
	dc.b	'!',$00,'20/20 '
	dc.b	': Vous ',$88
	dc.b	'tes g',$82,'ni'
	dc.b	'al !',$00
l0035	dc.b	'221221331'
	dc.b	'23133121'
	dc.b	'223',$00

l0036	incbin	l0036.pi1

l0039	dc.b	$07,$ff,$06,$00,$08,$00,$09,$00
	dc.b	$0a,$00

l003a	include	eqx_mzk.s
	even

l003b	incbin	l003b

l003c	dc.b	$00,$00
l003d	dc.b	$12
l003e	dc.b	$08
;========================================
	bss
;========================================
l003f	ds.l	1
l0040	ds.b	44096
l0041	ds.l	1
l0042	ds.l	1
l0043	ds.l	1
l0044	ds.b	178
;================================================================================
buffer
;================================================================================
zuend		end
;================================================================================