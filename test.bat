@echo off
setlocal enabledelayedexpansion

for /f "eol=- delims=" %%a in (BackUpChecker.bat.config) do set "%%a"
echo %shortcutName%
echo %fileBlackList%
echo %doColorHighlight%
echo %doAutoLogoff%

rem fix this:
for /L %%i in (0,1,2) do (
   echo !fileBlackList[%%i]!
)

endlocal
pause
exit