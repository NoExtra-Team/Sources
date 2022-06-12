REM - NOEXTRA PROGRAM COMPRESSION KIT -
@cls
@echo on
del SO_FAST.TOS
upx-3.96-win64.exe --best --crp-ms=99999 --nrv2b SO_FAST.PRG -o SO_FAST.TOS
del SO_FAST.PRG
@echo off
