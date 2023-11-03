@echo off
setlocal enabledelayedexpansion

rem Get the shortcut
set "scPath=%~dp0%shortcutName%"
echo Shortcut: %scPath%

if not exist %scPath% (
	echo Shortcut not found.
	pause
	exit
)
echo Shortcut found

rem Get the destination of the shortcut
set "vbsFile=%temp%\shortcut_target.vbs"
echo Set WshShell = WScript.CreateObject("WScript.Shell")>%vbsFile%
echo set lnk = WshShell.CreateShortcut("%scPath%")>>%vbsFile%
echo WScript.Echo lnk.TargetPath>>%vbsFile%
for /f "delims=" %%I in ('cscript //nologo "%vbsFile%"') do set "tFolder=%%I"
del "%vbsFile%" /f /q
set "disk=%tFolder:~0,2%"

echo Shortcut destination: %tFolder%
echo .

rem Get current date
for /f "tokens=1-3 delims=/" %%a in ('echo %date%') do (
	set "current_date=%%a/%%b/%%c"
)

rem Get file list
for %%F in ("%tFolder%\*.*") do (
	for /f "tokens=1-2 delims= " %%A in ('dir "%%F" ^| find "%%~nF"') do (
		set "file_date=%%A"
	)
	if "!file_date!" neq "!current_date!" (
		powershell write-host %%~nF  !file_date! -ForegroundColor Red
	) else (
		echo %%~nF  !file_date!
	)
)

rem Get disk's free space
for /f "usebackq delims== tokens=2" %%x in (`wmic logicaldisk where "DeviceID='%disk%'" get FreeSpace /format:value`) do set byteSize=%%x
set /a gigaSize = %byteSize:~0,-10%

echo .
if %gigaSize% leq 20 (
	powershell write-host Free GigaBytes: %gigaSize% -ForegroundColor Red
) else (
	echo Free GigaBytes: %gigaSize%
)

endlocal
pause
exit