@echo off

set BASEDIR=%~dp0
if "%BASEDIR:~-1" == "\" set BASEDIR=%BASEDIR:~0,-1%

set action=Edit with Notepad++
set command=%BASEDIR\notepad++.exe

reg.exe add "HKEY_CURRENT_USER\Software\Classes\*\shell\%action%\command" /ve /t REG_EXPAND_SZ /d "\"%command%\"\"%%1\"" /f
reg.exe add "HKEY_CURRENT_USER\Software\Classes\*\shell\%action%" /v Icon /t REG_SZ /d "%command%,0" /fc
