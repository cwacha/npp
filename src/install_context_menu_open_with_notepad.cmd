@echo off

set BASEDIR=%~dp0
if "%BASEDIR:~-1%" == "\" set BASEDIR=%BASEDIR:~0,-1%

set action=Edit with Notepad++
set command=%BASEDIR%\notepad++.exe


:: Detect if we have Administrator rights
net session >nul 2>&1
if %errorlevel% == 0 (
	set hkey=HKEY_LOCAL_MACHINE
) else (
	set hkey=HKEY_CURRENT_USER
)

reg.exe add "%hkey%\Software\Classes\*\shell\%action%\command" /ve /t REG_EXPAND_SZ /d "\"%command%\"\"%%1\"" /f
reg.exe add "%hkey%\Software\Classes\*\shell\%action%" /v Icon /t REG_SZ /d "%command%,0" /f
