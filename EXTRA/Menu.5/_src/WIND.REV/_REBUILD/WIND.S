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
	addq.l	#2,sp

	movea.l	d0,a1
	add.l	d0,l0080
	lea	l004f+34,a0
	move.w	#$1f3f,d1
l0000	move.l	(a0)+,(a1)+
	dbf	d1,l0000

	movem.l	l004f+2,d0-d7
	movem.l	d0-d7,$ffff8240.w

	bsr	l0045

	move.l	$70.w,l0086
	move.l	#l0044,$70.w

	bsr	l0003

	move.l	l0086,$70.w

	bsr	l004b

	move.w	#$ff,-(sp)
	move.w	#6,-(sp)		;crawio
	trap	#1
	addq.w	#4,sp

	jmp	exit(pc)
;========================================
l0003	sf	l004d+28+98
	sf	l0084
	lea	l004d+28,a0
	move.l	#l0074,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr

l0004	bsr	l0006
	bsr	l0043
	bsr	l0013

	tst.b	l0084
	beq.s	l0004

l0005	lea	l0082,a5
	move.l	#0,(a5)
	move.l	#0,4(a5)

	move.w	#$2500,sr

	lea	l004d+28,a5
	jsr	8(a5)
	rts

l0006	lea	l0082,a5
	move.l	d0,d6
	swap	d6
	move.b	0(a0,d6.w),d6
	andi.w	#$7f,d6
	lsr.w	#1,d6
	cmp.w	(a5),d6
	bge.s	l0007

	subq.w	#1,(a5)
	bge.s	l0008

	moveq	#0,d6
l0007	move.w	d6,(a5)
l0008	addq.w	#2,a5
	move.l	d1,d6
	swap	d6
	move.b	0(a1,d6.w),d6
	andi.w	#$7f,d6
	lsr.w	#1,d6
	cmp.w	(a5),d6
	bge.s	l0009

	subq.w	#1,(a5)
	bge.s	l000a

	moveq	#0,d6
l0009	move.w	d6,(a5)
l000a	addq.w	#2,a5
	move.l	d2,d6
	swap	d6
	move.b	0(a2,d6.w),d6
	andi.w	#$7f,d6
	lsr.w	#1,d6
	cmp.w	(a5),d6
	bge.s	l000b

	subq.w	#1,(a5)
	bge.s	l000c

	moveq	#0,d6
l000b	move.w	d6,(a5)
l000c	addq.w	#2,a5
	move.l	d3,d6
	swap	d6
	move.b	0(a3,d6.w),d6
	andi.w	#$7f,d6
	lsr.w	#1,d6
	cmp.w	(a5),d6
	bge.s	l000d

	subq.w	#1,(a5)
	bge.s	l000e

	moveq	#0,d6
l000d	move.w	d6,(a5)
l000e	addq.w	#2,a5
	move.w	#$30,l0083
l000f	movea.l	l0080,a6
	adda.w	l0083,a6
	move.w	#$40,d6
	move.w	-(a5),d7
	move.l	a5,l0081
	lea	l004f+34+14128,a5
	adda.w	l0083,a5
	sub.w	d7,d6
	beq.s	l0011

	subq.w	#1,d6
l0010	clr.l	(a6)
	clr.l	4(a6)
	adda.l	#$a0,a6
	adda.l	#$a0,a5
	dbf	d6,l0010

	tst.w	d7
	beq.s	l0012

	subq.w	#1,d7
l0011	move.l	(a5),(a6)
	move.l	4(a5),4(a6)
	adda.l	#$a0,a6
	adda.l	#$a0,a5
	dbf	d7,l0011

l0012	movea.l	l0081,a5
	subi.w	#$10,l0083
	bge.s	l000f
	rts

l0013	move.b	l004d+28+98,d6
	andi.b	#$7f,d6
	beq	l0014

	cmp.b	#$10,d6
	beq	l0015

	cmp.b	#$11,d6
	beq	l0016

	cmp.b	#$12,d6
	beq	l0017

	cmp.b	#$13,d6
	beq	l0018

	cmp.b	#$14,d6
	beq	l0019

	cmp.b	#$15,d6
	beq	l001a

	cmp.b	#$16,d6
	beq	l001b

	cmp.b	#$17,d6
	beq	l001c

	cmp.b	#$18,d6
	beq	l001d

	cmp.b	#$19,d6
	beq	l001e

	cmp.b	#$1a,d6
	beq	l001f

	cmp.b	#$1b,d6
	beq	l0020

	cmp.b	#$1e,d6
	beq	l0021

	cmp.b	#$1f,d6
	beq	l0022

	cmp.b	#$20,d6
	beq	l0023

	cmp.b	#$21,d6
	beq	l0024

	cmp.b	#$22,d6
	beq	l0025

	cmp.b	#$23,d6
	beq	l0026

	cmp.b	#$24,d6
	beq	l0027

	cmp.b	#$25,d6
	beq	l0028

	cmp.b	#$26,d6
	beq	l0029

	cmp.b	#$27,d6
	beq	l002a

	cmp.b	#$28,d6
	beq	l002b

	cmp.b	#$2c,d6
	beq	l002c

	cmp.b	#$2d,d6
	beq	l002d

	cmp.b	#$2e,d6
	beq	l002e

	cmp.b	#$2f,d6
	beq	l002f

	cmp.b	#$30,d6		;#'0'
	beq	l0030

	cmp.b	#$31,d6
	beq	l0031

	cmp.b	#$32,d6
	beq	l0032

	cmp.b	#$33,d6
	beq	l0033

	cmp.b	#$34,d6
	beq	l0034

	cmp.b	#$35,d6
	beq	l0035

	cmp.b	#2,d6
	beq	l0036

	cmp.b	#3,d6
	beq	l0037

	cmp.b	#4,d6
	beq	l0038

	cmp.b	#5,d6
	beq	l0039

	cmp.b	#6,d6
	beq	l003a

	cmp.b	#7,d6
	beq	l003b

	cmp.b	#8,d6
	beq	l003c

	cmp.b	#9,d6
	beq	l003d

	cmp.b	#$a,d6
	beq	l003e

	cmp.b	#$b,d6
	beq	l003f

	cmp.b	#$c,d6
	beq	l0040

	cmp.b	#$29,d6
	beq	l0041

	cmp.b	#$e,d6
	beq	l0042

	cmp.b	#$39,d6		;#'9'
	bne.s	l0014

	st	l0084
	rts

l0014	rts

l0015	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0052,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0016	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0053,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0017	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0054,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0018	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0055,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0019	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0056,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l001a	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0057,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l001b	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0058,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr

	bra	l0004

l001c	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0059,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l001d	bsr	l0005
	lea	l004d+28,a0
	move.l	#l005a,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l001e	bsr	l0005
	lea	l004d+28,a0
	move.l	#l005b,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l001f	bsr	l0005
	lea	l004d+28,a0
	move.l	#l005c,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0020	bsr	l0005
	lea	l004d+28,a0
	move.l	#l005d,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0021	bsr	l0005
	lea	l004d+28,a0
	move.l	#l005e,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0022	bsr	l0005
	lea	l004d+28,a0
	move.l	#l005f,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0023	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0060,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0024	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0061,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0025	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0062,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0026	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0063,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move	#$2300,sr
	rts

l0027	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0064,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0028	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0065,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0029	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0066,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l002a	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0067,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l002b	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0068,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l002c	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0069,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l002d	bsr	l0005
	lea	l004d+28,a0
	move.l	#l006a,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l002e	bsr	l0005
	lea	l004d+28,a0
	move.l	#l006b,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l002f	bsr	l0005
	lea	l004d+28,a0
	move.l	#l006c,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0030	bsr	l0005
	lea	l004d+28,a0
	move.l	#l006d,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0031	bsr	l0005
	lea	l004d+28,a0
	move.l	#l006e,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0032	bsr	l0005
	lea	l004d+28,a0
	move.l	#l006f,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0033	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0070,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0034	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0071,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0035	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0072,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0036	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0073,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0037	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0074,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0038	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0075,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0039	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0076,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l003a	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0077,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l003b	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0078,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l003c	bsr	l0005
	lea	l004d+28,a0
	move.l	#l0079,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l003d	bsr	l0005
	lea	l004d+28,a0
	move.l	#l007a,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l003e	bsr	l0005
	lea	l004d+28,a0
	move.l	#l007b,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l003f	bsr	l0005
	lea	l004d+28,a0
	move.l	#l007c,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0040	bsr	l0005
	lea	l004d+28,a0
	move.l	#l007d,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0041	bsr	l0005
	lea	l004d+28,a0
	move.l	#l007e,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

l0042	bsr	l0005
	lea	l004d+28,a0
	move.l	#l007f,12(a0)
	move.l	#l004c,16(a0)
	jsr	4(a0)

	move.w	#$2300,sr
	rts

	sf	l0085
l0043	tst.b	l0085
	beq.s	l0043
	rts

l0044	st	l0085
	rte

l0045	lea	l004d+28,a0
	movea.l	a0,a1
	move.l	a0,d1
	adda.l	#$3dd7,a1
	moveq	#0,d0
l0046	move.b	(a1)+,d0
	beq	l0048

	cmp.w	#1,d0
	bne.s	l0047
	adda.w	#$fe,a0
	bra.s	l0046

l0047	adda.w	d0,a0
	add.l	d1,(a0)
	bra.s	l0046
l0048	rts

l004b	move.l	#0,$ffff8800.w
	move.l	#$1010000,$ffff8800.w
	move.l	#$2020000,$ffff8800.w
	move.l	#$3030000,$ffff8800.w
	move.l	#$4040000,$ffff8800.w
	move.l	#$5050000,$ffff8800.w
	move.l	#$6060000,$ffff8800.w
	move.l	#$707ffff,$ffff8800.w
	move.l	#$8080000,$ffff8800.w
	move.l	#$9090000,$ffff8800.w
	move.l	#$a0a0000,$ffff8800.w
	rts

l004c	incbin	'VOICE.SET',$00
	even
;========================================
	data
;========================================
l004d	incbin	replay.prg
;========================================
l004f	incbin	l004f.pi1
;========================================
l0052	incbin	l0052
l0053	incbin	l0053
l0054	incbin	l0054
l0055	incbin	l0055
l0056	incbin	l0056
l0057	incbin	l0057
l0058	incbin	l0058
l0059	incbin	l0059
l005a	incbin	l005a
l005b	incbin	l005b
l005c	incbin	l005c
l005d	incbin	l005d
l005e	incbin	l005e
l005f	incbin	l005f
l0060	incbin	l0060
l0061	incbin	l0061
l0062	incbin	l0062
l0063	incbin	l0063
l0064	incbin	l0064
l0065	incbin	l0065
l0066	incbin	l0066
l0067	incbin	l0067
l0068	incbin	l0068
l0069	incbin	l0069
l006a	incbin	l006a
l006b	incbin	l006b
l006c	incbin	l006c
l006d	incbin	l006d
l006e	incbin	l006e
l006f	incbin	l006f
l0070	incbin	l0070
l0071	incbin	l0071
l0072	incbin	l0072
l0073	incbin	l0073
l0074	incbin	l0074
l0075	incbin	l0075
l0076	incbin	l0076
l0077	incbin	l0077
l0078	incbin	l0078
l0079	incbin	l0079
l007a	incbin	l007a
l007b	incbin	l007b
l007c	incbin	l007c
l007d	incbin	l007d
l007e	incbin	l007e
l007f	incbin	l007f

l0080	dc.b	$00,$00,$37,$30
;========================================
	bss
;========================================
l0081	ds.l	1
l0082	ds.b	8
l0083	ds.w	1
l0084	ds.w	1
l0085	ds.w	1
l0086	ds.b	408
;================================================================================
buffer
;================================================================================
zuend		end
;================================================================================