@echo off
if "%1"=="" goto end
if "%2"=="" goto loop
copy %1\input.%2 input.txt >nul
%1
copy output.txt %1\output.%2
%1\mark %2
pause
goto end
:loop
for %%i in (001 002 003 004 005 006 007 008 009 010) do call %0 %1 %%i
:end
