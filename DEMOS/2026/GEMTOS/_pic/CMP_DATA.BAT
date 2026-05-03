@echo off
@cls
REM -------------------------------------
REM -*-   NOEXTRA CUT PICTURES KIT    -*-
REM -------------------------------------
set FOLDER-BIN=..\_bin\
set FOLDER-PI1=.\
set FOLDER-COMP=.\

DEL CMP_DATA.BAT.bak 2>NUL

:: GFX_001 --- MISTER.A PICTURE ---
set NAME-GFX_001=50PC
del %FOLDER-COMP%%NAME-GFX_001%.IMG 2>NUL
@echo on
%FOLDER-BIN%cut_pi1.exe %FOLDER-PI1%%NAME-GFX_001%.PI1 %FOLDER-COMP%%NAME-GFX_001%.IMG 0 37
@echo off

:: GFX_002 --- MISTER.A PICTURE ---
set NAME-GFX_002=GEMTOS
del %FOLDER-COMP%%NAME-GFX_002%.IMG 2>NUL
@echo on
%FOLDER-BIN%cut_pi1.exe %FOLDER-PI1%%NAME-GFX_002%.PI1 %FOLDER-COMP%%NAME-GFX_002%.IMG 0 46
@echo off

:End_of_file
PAUSE
EXIT