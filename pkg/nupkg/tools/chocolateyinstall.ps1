﻿function isAdmin() {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$startmenudir = "$env:AppData\Microsoft\Windows\Start Menu\Programs"

& $toolsDir\root\install_context_menu_open_with_notepad.cmd
Install-BinFile -Name npp-menu -Path $toolsDir\root\install_context_menu_open_with_notepad.cmd
Install-BinFile -Name npp -Path $toolsDir\root\notepad++.exe

if (isAdmin) {
    # ensure configs are saved to users AppData folder to enable use for non-admin users
    "Removing doLocalConf.xml"
    rm $toolsDir\root\doLocalConf.xml
    
    $startmenudir = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs"
}

"Creating Start Menu entry"
Install-ChocolateyShortcut `
    -ShortcutFilePath "$startmenudir\Notepad++.lnk"`
    -TargetPath "$toolsDir\root\notepad++.exe"
