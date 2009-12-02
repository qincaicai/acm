@echo off
if "%3"=="" goto loop
if not exist %1.in%3 goto end
:test
copy %1.in%3 %1.in>nul
echo TestCase%3
echo TestCase%3>>%1.log
%2
fc %1.out %1.st%3>>%1.log
goto end
:loop
if exist %1.log del %1.log
for %%i in (0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j) do call %0 %1 %2 %%i
:end