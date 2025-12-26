@echo off
@cls
REM ---------------------------------------
REM -*- ZERKMAN PROGRAM COMPRESSION MPP -*-
REM ---------------------------------------
@echo on
.\bmp2mpp.exe -9 --mode=2 --extra --ste --err perso-square320x200.bmp
copy .\perso-square320x200.mpp ..\persohmd.mpp
@echo off
pause
exit
