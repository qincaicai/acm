@echo off
if "%1"=="" goto testall
if "%2"=="" goto loop
copy %1\input.%2 input.txt >nul
if exist output.txt del output.txt
echo Problem %1
echo Data %2
%1
%1\mark %2
pause
goto end
:loop
for %%i in (001 002 003 004 005 006 007 008 009 010) do call %0 %1 %%i
goto end
:test all
for %%i in (trade fire house) do call %0 %%i
:end
