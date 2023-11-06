@echo off
setlocal enabledelayedexpansion

rem Get the config
if not exist "./BackUpChecker.bat.config" (
	echo Config file not found
	pause
	exit
)
for /f "eol=- delims=" %%a in (BackUpChecker.bat.config) do set "%%a"

rem Get current date
for /f "tokens=1-3 delims=/" %%a in ('echo %date%') do (
	set "current_date=%%a/%%b/%%c"
)
set "current_date=%current_date:~-10,10%"

rem Get the shortcut
set "scPath=%~dp0%shortcutName%"
if not exist %scPath% (
	echo Shortcut not found.
	pause
	exit
)

rem Get the destination of the shortcut and the disk name
set "vbsFile=%temp%\shortcut_target.vbs"
echo Set WshShell = WScript.CreateObject("WScript.Shell")>%vbsFile%
echo set lnk = WshShell.CreateShortcut("%scPath%")>>%vbsFile%
echo WScript.Echo lnk.TargetPath>>%vbsFile%
for /f "delims=" %%I in ('cscript //nologo "%vbsFile%"') do set "tFolder=%%I"
del "%vbsFile%" /f /q
set "disk=%tFolder:~0,2%"

echo Shortcut destination: %tFolder%
echo .

set /a canLogoff = 1
rem Get file list
for %%F in ("%tFolder%\*.*") do (
	for /f "tokens=1-2 delims= " %%A in ('dir "%%F" ^| find "%%~nF"') do (
		set "file_date=%%A"
		set "file_name=%%~nF"
	)
	echo %fileBlackList% | find "!file_name!" >nul
	if errorlevel 1 (
		if "!file_date!" neq "!current_date!" (
			call :echoProblem "!file_name! !file_date!"
		) else (
			echo !file_name! !file_date!
		)
	) else (
		echo !file_name! is blacklisted
	)
)

rem Get disk's free space
for /f "usebackq delims== tokens=2" %%x in (`wmic logicaldisk where "DeviceID='%disk%'" get FreeSpace /format:value`) do set byteSize=%%x
set /a gigaSize = %byteSize:~0,-10%

echo .
if %gigaSize% leq 20 (
	call :echoProblem "Free GigaBytes: %gigaSize%"
) else (
	echo Free GigaBytes: %gigaSize%
)

if %canLogoff% == 1 if %doAutoLogoff% == 1 (
	echo Log off in 10 seconds
	timeout /t 10
	shutdown /l
)

endlocal
pause
exit

:echoProblem
if %doColorHighlight% == 1 (
	powershell write-host %~1 -ForegroundColor Red
) else (
	echo Attention: %~1
)
set /a canLogoff = 0
exit /b 0