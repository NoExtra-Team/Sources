@echo off
@cls
REM -------------------------------------
REM -*- NOEXTRA COMPRESSION DATA KIT  -*-
REM -------------------------------------
set FOLDER-GFX=.\pi1\
set FOLDER-BIN=..\_bin\
set FOLDER-DATA=.\hallof.lz4\

@echo off
del %FOLDER-DATA%record.LZ4 2>NUL
@echo on
REM --- PICTURE / LINE ---
%FOLDER-BIN%cut_pi1.exe %FOLDER-GFX%record.PI1 %FOLDER-DATA%record.IMG 0 6
%FOLDER-BIN%lz4.exe -9 -zq %FOLDER-DATA%record.IMG %FOLDER-DATA%record.LZ4
@echo off
del %FOLDER-DATA%record.IMG 2>NUL
@echo on

@echo off
del %FOLDER-DATA%space.LZ4 2>NUL
@echo on
REM --- PICTURE / LINE ---
%FOLDER-BIN%cut_pi1.exe %FOLDER-GFX%space.PI1 %FOLDER-DATA%space.IMG 0 6
%FOLDER-BIN%lz4.exe -9 -zq %FOLDER-DATA%space.IMG %FOLDER-DATA%space.LZ4
@echo off
del %FOLDER-DATA%space.IMG 2>NUL
@echo on

@echo off
del %FOLDER-DATA%dforce.LZ4 2>NUL
@echo on
REM --- DF PICTURE ---
%FOLDER-BIN%cut_pi1.exe %FOLDER-GFX%dforce.PI1 %FOLDER-DATA%dforce.IMG 0 82
%FOLDER-BIN%lz4.exe -9 -zq %FOLDER-DATA%dforce.IMG %FOLDER-DATA%dforce.LZ4
@echo off
del %FOLDER-DATA%dforce.IMG 2>NUL
@echo on

@echo off
del %FOLDER-DATA%elite.LZ4 2>NUL
@echo on
REM --- ELITE PICTURE ---
%FOLDER-BIN%cut_pi1.exe %FOLDER-GFX%elite.PI1 %FOLDER-DATA%elite.IMG 0 82
%FOLDER-BIN%lz4.exe -9 -zq %FOLDER-DATA%elite.IMG %FOLDER-DATA%elite.LZ4
@echo off
del %FOLDER-DATA%elite.IMG 2>NUL
@echo on

@echo off
del %FOLDER-DATA%eqx.LZ4 2>NUL
@echo on
REM --- EQUINOX PICTURE ---
%FOLDER-BIN%cut_pi1.exe %FOLDER-GFX%eqx.PI1 %FOLDER-DATA%eqx.IMG 0 82
%FOLDER-BIN%lz4.exe -9 -zq %FOLDER-DATA%eqx.IMG %FOLDER-DATA%eqx.LZ4
@echo off
del %FOLDER-DATA%eqx.IMG 2>NUL
@echo on

@echo off
del %FOLDER-DATA%lostb.LZ4 2>NUL
@echo on
REM --- LOST BOYS PICTURE ---
%FOLDER-BIN%cut_pi1.exe %FOLDER-GFX%lostb.PI1 %FOLDER-DATA%lostb.IMG 0 82
%FOLDER-BIN%lz4.exe -9 -zq %FOLDER-DATA%lostb.IMG %FOLDER-DATA%lostb.LZ4
@echo off
del %FOLDER-DATA%lostb.IMG 2>NUL
@echo on

@echo off
del %FOLDER-DATA%ovr.LZ4 2>NUL
@echo on
REM --- OVERLANDERS PICTURE ---
%FOLDER-BIN%cut_pi1.exe %FOLDER-GFX%ovr.PI1 %FOLDER-DATA%ovr.IMG 0 82
%FOLDER-BIN%lz4.exe -9 -zq %FOLDER-DATA%ovr.IMG %FOLDER-DATA%ovr.LZ4
@echo off
del %FOLDER-DATA%ovr.IMG 2>NUL
@echo on

@echo off
del %FOLDER-DATA%reps.LZ4 2>NUL
@echo on
REM --- REPS! PICTURE ---
%FOLDER-BIN%cut_pi1.exe %FOLDER-GFX%reps.PI1 %FOLDER-DATA%reps.IMG 0 82
%FOLDER-BIN%lz4.exe -9 -zq %FOLDER-DATA%reps.IMG %FOLDER-DATA%reps.LZ4
@echo off
del %FOLDER-DATA%reps.IMG 2>NUL
@echo on

@echo off
del %FOLDER-DATA%stcnx.LZ4 2>NUL
@echo on
REM --- ST CONNEXION PICTURE ---
%FOLDER-BIN%cut_pi1.exe %FOLDER-GFX%stcnx.PI1 %FOLDER-DATA%stcnx.IMG 0 82
%FOLDER-BIN%lz4.exe -9 -zq %FOLDER-DATA%stcnx.IMG %FOLDER-DATA%stcnx.LZ4
@echo off
del %FOLDER-DATA%stcnx.IMG 2>NUL
@echo on

@echo off
del %FOLDER-DATA%sync.LZ4 2>NUL
@echo on
REM --- SYNC PICTURE ---
%FOLDER-BIN%cut_pi1.exe %FOLDER-GFX%sync.PI1 %FOLDER-DATA%sync.IMG 0 82
%FOLDER-BIN%lz4.exe -9 -zq %FOLDER-DATA%sync.IMG %FOLDER-DATA%sync.LZ4
@echo off
del %FOLDER-DATA%sync.IMG 2>NUL
@echo on

@echo off
del %FOLDER-DATA%Synergy.LZ4 2>NUL
@echo on
REM --- SYNERGIE PICTURE ---
%FOLDER-BIN%cut_pi1.exe %FOLDER-GFX%Synergy.PI1 %FOLDER-DATA%Synergy.IMG 0 82
%FOLDER-BIN%lz4.exe -9 -zq %FOLDER-DATA%Synergy.IMG %FOLDER-DATA%Synergy.LZ4
@echo off
del %FOLDER-DATA%Synergy.IMG 2>NUL
@echo on

@echo off
del %FOLDER-DATA%tcb.LZ4 2>NUL
@echo on
REM --- TCB PICTURE ---
%FOLDER-BIN%cut_pi1.exe %FOLDER-GFX%tcb.PI1 %FOLDER-DATA%tcb.IMG 0 82
%FOLDER-BIN%lz4.exe -9 -zq %FOLDER-DATA%tcb.IMG %FOLDER-DATA%tcb.LZ4
@echo off
del %FOLDER-DATA%tcb.IMG 2>NUL
@echo on

@echo off
del %FOLDER-DATA%tex.LZ4 2>NUL
@echo on
REM --- TEX PICTURE ---
%FOLDER-BIN%cut_pi1.exe %FOLDER-GFX%tex.PI1 %FOLDER-DATA%tex.IMG 0 82
%FOLDER-BIN%lz4.exe -9 -zq %FOLDER-DATA%tex.IMG %FOLDER-DATA%tex.LZ4
@echo off
del %FOLDER-DATA%tex.IMG 2>NUL
@echo on

@echo off
del %FOLDER-DATA%ulm.LZ4 2>NUL
@echo on
REM --- ULM PICTURE ---
%FOLDER-BIN%cut_pi1.exe %FOLDER-GFX%ulm.PI1 %FOLDER-DATA%ulm.IMG 0 82
%FOLDER-BIN%lz4.exe -9 -zq %FOLDER-DATA%ulm.IMG %FOLDER-DATA%ulm.LZ4
@echo off
del %FOLDER-DATA%ulm.IMG 2>NUL
@echo on

@echo off
del %FOLDER-DATA%union.LZ4 2>NUL
@echo on
REM --- UNION PICTURE ---
%FOLDER-BIN%cut_pi1.exe %FOLDER-GFX%union.PI1 %FOLDER-DATA%union.IMG 0 82
%FOLDER-BIN%lz4.exe -9 -zq %FOLDER-DATA%union.IMG %FOLDER-DATA%union.LZ4
@echo off
del %FOLDER-DATA%union.IMG 2>NUL
@echo on

