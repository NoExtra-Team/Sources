@echo off
@cls
REM ---------------------------------------
REM -*- NOEXTRA PROGRAM COMPRESSION KIT -*-
REM ---------------------------------------
set FOLDER-BIN=.\_bin\

del /q /f /s COMP_TOS.BAT.bak 2>NUL 1>NUL

set NAME-PRG=GEMTOS26
set FOLDER-PRG=.\
del %FOLDER-PRG%%NAME-PRG%.TOS 2>NUL 1>NUL
del %FOLDER-PRG%%NAME-PRG%.S.bak 2>NUL 1>NUL
%FOLDER-BIN%upx-3.96-win64.exe --best --crp-ms=99999 --nrv2b %FOLDER-PRG%%NAME-PRG%.PRG -o %FOLDER-PRG%%NAME-PRG%.TOS
:End_of_file
del %FOLDER-PRG%%NAME-PRG%.PRG 2>NUL 1>NUL
PAUSE
@echo on