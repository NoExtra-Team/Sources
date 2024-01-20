@echo off
@cls
REM -------------------------------------
REM -*- NOEXTRA ENCODE STRING TO HEXA -*-
REM -------------------------------------
set FOLDER-BIN=..\_bin\
set FOLDER-TXT=.\
del %FOLDER-TXT%STRANGER.DAT 2>NUL
@echo on
%FOLDER-BIN%encode.exe %FOLDER-TXT%Stranger.txt %FOLDER-TXT%STRANGER.DAT 32
@echo off
del %FOLDER-TXT%SINK.DAT 2>NUL
@echo on
%FOLDER-BIN%encode.exe %FOLDER-TXT%Sink.txt %FOLDER-TXT%SINK.DAT 32
@echo off
