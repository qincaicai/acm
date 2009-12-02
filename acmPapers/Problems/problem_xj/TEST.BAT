@echo off
cd %1
call test %1 ..\%1 %2
copy %1.log ..>nul
cd ..