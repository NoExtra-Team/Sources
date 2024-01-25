@echo off
@cls
REM ---------------------------------------
REM -*- NOEXTRA PROGRAM COMPRESSION KIT -*-
REM ---------------------------------------
set FOLDER-BIN=.\_bin\
set FOLDER-PRG=.\
del %FOLDER-PRG%hallof5.TOS
@echo on
%FOLDER-BIN%upx-3.96-win64.exe --best --crp-ms=99999 --nrv2b %FOLDER-PRG%hallof5.PRG -o %FOLDER-PRG%hallof5.TOS
@echo off
del %FOLDER-PRG%hallof5.PRG
@echo off