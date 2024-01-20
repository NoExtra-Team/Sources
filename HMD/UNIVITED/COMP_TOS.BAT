@echo off
@cls
REM ---------------------------------------
REM -*- NOEXTRA PROGRAM COMPRESSION KIT -*-
REM ---------------------------------------
set FOLDER-BIN=.\_bin\
set FOLDER-PRG=.\
del %FOLDER-PRG%UNIVITED.TOS
@echo on
%FOLDER-BIN%upx-3.96-win64.exe --best --crp-ms=99999 --nrv2b %FOLDER-PRG%UNIVITED.PRG -o %FOLDER-PRG%UNIVITED.TOS
@echo off
del %FOLDER-PRG%UNIVITED.PRG
@echo off